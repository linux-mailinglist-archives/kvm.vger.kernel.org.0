Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F3C49CDE8
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 16:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242736AbiAZPWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 10:22:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242734AbiAZPWQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 10:22:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643210536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4ZDxj2tUt1e0JX2wIjk67S3NQ1bq5Rff7PgciH553iI=;
        b=NVHDj5E9rt1h40O0xuUBYOSlV+NiHAANDQLG/mF1L98li5eWOXIV0zNB9UdBIlW3n8F0TU
        NEvWP+ockNT7FY9ZqTZoth6wUZs5b83s4O16oUcW2gP55H5AFE7OxJPmCs8q69AtA1Q3y+
        255gE5vr3VifZ5MpBAT5ruP4CjnnlpM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-thDmues9PsKHgOM-GwlYKA-1; Wed, 26 Jan 2022 10:22:12 -0500
X-MC-Unique: thDmues9PsKHgOM-GwlYKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5BA13E743;
        Wed, 26 Jan 2022 15:22:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEA7540EFD;
        Wed, 26 Jan 2022 15:22:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     yang.zhong@intel.com, seanjc@google.com
Subject: [PATCH 0/3] KVM: x86: export supported_xcr0 via UAPI
Date:   Wed, 26 Jan 2022 10:22:07 -0500
Message-Id: <20220126152210.3044876-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While working on the QEMU support for AMX, I noticed that there is no
equivalent of ARCH_GET_XCOMP_SUPP in the KVM API.  This is important
because KVM_GET_SUPPORTED_CPUID is meant to be passed (by simple-minded
VMMs) to KVM_SET_CPUID2, and therefore it cannot include any dynamic
xsave states that have not been enabled.  Probing the availability of
dynamic xsave states therefore, requires a new ioctl or arch_prctl.

In order to avoid moving supported_xcr0 to the kernel from the KVM
module just for this use, and to ensure that the value can only be
probed if/after the KVM module has been loaded, this series goes
for the former option.

KVM_CHECK_EXTENSION cannot be used because it only has 32 bits of
output; in order to limit the growth of capabilities and ioctls, the
series adds a /dev/kvm variant of KVM_{GET,HAS}_DEVICE_ATTR that
can be used in the future and by other architectures.  It then
implements it in x86 with just one group (0) and attribute
(KVM_X86_XCOMP_GUEST_SUPP).

The corresponding changes to the tests, in patches 1 and 3, are
designed so that the code will be covered (to the possible extent)
even when running the tests on systems that do not support AMX.
However, the patches have not been tested with AMX.

Thanks,

Paolo


Paolo Bonzini (3):
  selftests: kvm: move vm_xsave_req_perm call to amx_test
  KVM: x86: add system attribute to retrieve full set of supported xsave
    states
  selftests: kvm: check dynamic bits against KVM_X86_XCOMP_GUEST_SUPP

 Documentation/virt/kvm/api.rst                |  4 +-
 arch/x86/include/uapi/asm/kvm.h               |  3 ++
 arch/x86/kvm/x86.c                            | 45 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  1 +
 tools/arch/x86/include/uapi/asm/kvm.h         |  3 ++
 tools/include/uapi/linux/kvm.h                |  1 +
 .../selftests/kvm/include/kvm_util_base.h     |  1 -
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  7 ---
 .../selftests/kvm/lib/x86_64/processor.c      | 27 ++++++++---
 tools/testing/selftests/kvm/x86_64/amx_test.c |  2 +
 11 files changed, 80 insertions(+), 15 deletions(-)

-- 
2.31.1

