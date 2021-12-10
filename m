Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25522470322
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 15:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242413AbhLJOyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 09:54:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242405AbhLJOyY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 09:54:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639147849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z35jirA25UiblnwV/sjy+/qYeLAmZOVR3MPTVKs+MzA=;
        b=ii30eHOm51L4QFUiT1uAlFHgT5VQ/z+ZmuPE/tZ0U5jNBo68Csodd07N+QTxazhIfcf+zA
        pmdvgnAQtzDw6WjgG3wrhyklFIwb4acbBAZY/ep6u+++kiO75gaY12C3g2m73jvpt1L1hl
        xFeZu1s5aCkJ6OONDDdCI4kScnPTfio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-O3pw-CUzMROkMpmPihl7EQ-1; Fri, 10 Dec 2021 09:50:46 -0500
X-MC-Unique: O3pw-CUzMROkMpmPihl7EQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBED51044A81;
        Fri, 10 Dec 2021 14:50:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C7C160622;
        Fri, 10 Dec 2021 14:50:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.16-rc5
Date:   Fri, 10 Dec 2021 09:50:44 -0500
Message-Id: <20211210145044.28699-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 0fcfb00b28c0b7884635dacf38e46d60bf3d4eb1:

  Linux 5.16-rc4 (2021-12-05 14:08:22 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 10e7a099bfd860a2b77ea8aaac661f52c16dd865:

  selftests: KVM: Add test to verify KVM doesn't explode on "bad" I/O (2021-12-10 09:38:02 -0500)

----------------------------------------------------------------
More x86 fixes:
* Logic bugs in CR0 writes and Hyper-V hypercalls
* Don't use Enlightened MSR Bitmap for L3
* Remove user-triggerable WARN

Plus a few selftest fixes and a regression test for the
user-triggerable WARN.

----------------------------------------------------------------
So I am not sure if this counts as "the kvm side calming down"; but the
larger scale bugfixes are all in-tree now, and what I've got here looks
(at least on the arch/ side) like a fairly normal pull request for
middle RCs.

Thanks,

Paolo

Lai Jiangshan (1):
      KVM: X86: Raise #GP when clearing CR0_PG in 64 bit mode

Maciej S. Szmigiero (1):
      KVM: x86: selftests: svm_int_ctl_test: fix intercept calculation

Paolo Bonzini (1):
      selftests: KVM: avoid failures due to reserved HyperTransport region

Sean Christopherson (3):
      KVM: x86: Ignore sparse banks size for an "all CPUs", non-sparse IPI req
      KVM: x86: Don't WARN if userspace mucks with RCX during string I/O exit
      selftests: KVM: Add test to verify KVM doesn't explode on "bad" I/O

Vitaly Kuznetsov (2):
      KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
      KVM: x86: Wait for IPIs to be delivered when handling Hyper-V TLB flush hypercall

 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/kvm/hyperv.c                              |   7 +-
 arch/x86/kvm/vmx/vmx.c                             |  22 ++--
 arch/x86/kvm/x86.c                                 |  12 ++-
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h     |   9 ++
 tools/testing/selftests/kvm/lib/kvm_util.c         |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  68 ++++++++++++
 .../selftests/kvm/x86_64/svm_int_ctl_test.c        |   2 +-
 .../selftests/kvm/x86_64/userspace_io_test.c       | 114 +++++++++++++++++++++
 11 files changed, 223 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_io_test.c

