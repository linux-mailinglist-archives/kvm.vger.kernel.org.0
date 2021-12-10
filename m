Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC3F470321
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 15:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242389AbhLJOyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 09:54:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242332AbhLJOyR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 09:54:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639147842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z35jirA25UiblnwV/sjy+/qYeLAmZOVR3MPTVKs+MzA=;
        b=Uyuo/GY2qtCE9k3wfLsY88og/eHtFDil3yIl5s4RSS2fq1JCMz4dTibhz5E8LXgVQ0gRgZ
        9XaQDvsY79uQNgg7Yp8rnj3XojoMtRx88KhdFUdVuXvt8EBCWZ4ZQyMOJZlE/H8mO9wC9/
        0EBm7bxiuRir3pYXRwRYOjFjbgiPsCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-dZ7NQYCuOgayRqfGaRfxdw-1; Fri, 10 Dec 2021 09:50:39 -0500
X-MC-Unique: dZ7NQYCuOgayRqfGaRfxdw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27665101F02A;
        Fri, 10 Dec 2021 14:50:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D88F56D034;
        Fri, 10 Dec 2021 14:50:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.16-rc5
Date:   Fri, 10 Dec 2021 09:50:37 -0500
Message-Id: <20211210145037.28568-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

