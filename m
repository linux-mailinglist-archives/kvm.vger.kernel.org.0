Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B70334F153
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 20:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhC3S7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 14:59:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232958AbhC3S6z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 14:58:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617130734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J6RA/5YBSEXFrib0Mj4ENt+Q2fhHfFS3xUYo5/rYdaw=;
        b=YDFO/vjRZd6lxd4lvkISoWv+cEEdlFHBAXrOXCRhix/ps7z3gFv9yRQD8orj/qg0Qla5hI
        0pY3Bgm88J8KElmqWrF2H/P7ovs7IXJeh3ZTS5p1vjMHcG5GGRNial3K/A7fBzYBJA02/5
        VYsaLOREHkkqF7Cv8MPbHUETSlReHu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-_ODYVjhIMseUViOsni0ADA-1; Tue, 30 Mar 2021 14:58:52 -0400
X-MC-Unique: _ODYVjhIMseUViOsni0ADA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1617911E3;
        Tue, 30 Mar 2021 18:58:49 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-41.ams2.redhat.com [10.36.112.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EAC519C44;
        Tue, 30 Mar 2021 18:58:44 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH 0/4] kvm: cpuid: fix cpuid nent field
Date:   Tue, 30 Mar 2021 20:58:37 +0200
Message-Id: <20210330185841.44792-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series aims to clarify the behavior of 
KVM_GET_EMULATED_CPUID and KVM_GET_SUPPORTED
ioctls, and fix a corner case where the nent field of the
struct kvm_cpuid2 is matching the amount of entries that kvm returns.

Patch 1 proposes the nent field fix to cpuid.c,
patch 2 updates the ioctl documentation accordingly and 
patches 3 and 4 provide a selftest to check KVM_GET_EMULATED_CPUID
accordingly.

Emanuele Giuseppe Esposito (4):
  kvm: cpuid: adjust the returned nent field of kvm_cpuid2 for
    KVM_GET_SUPPORTED_CPUID and KVM_GET_EMULATED_CPUID
  Documentation: kvm: update KVM_GET_EMULATED_CPUID ioctl description
  selftests: add kvm_get_emulated_cpuid
  selftests: kvm: add get_emulated_cpuid test

 Documentation/virt/kvm/api.rst                |  10 +-
 arch/x86/kvm/cpuid.c                          |   6 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/lib/x86_64/processor.c      |  33 ++++
 .../selftests/kvm/x86_64/get_emulated_cpuid.c | 183 ++++++++++++++++++
 7 files changed, 229 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/get_emulated_cpuid.c

-- 
2.30.2

