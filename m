Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839144164DD
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 20:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242692AbhIWSOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 14:14:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242695AbhIWSO3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 14:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632420777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nGiyo9Kb8y6C4PyFYU5baolsG6mjzgEb10Ln0lF+3dY=;
        b=G12k53d4tb4dODZdGPWIqpSLqMQos5QyycYmYf4WOvqQBDWHQobUFoUWu4elYBXjKUNn4w
        EyQPMckosPJqbvP8Q/bnrSkNZtra+8y/OwwLIziGEUBKQmvQ13m3TVrEWXeLgLtYyNFJ2k
        4p005IWxDiCreklU4rwg0/RnhP7ejqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-DJs5u56IPCKFXW3MVXcM1A-1; Thu, 23 Sep 2021 14:12:54 -0400
X-MC-Unique: DJs5u56IPCKFXW3MVXcM1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28F8BBBEE0;
        Thu, 23 Sep 2021 18:12:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC6186B54A;
        Thu, 23 Sep 2021 18:12:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/rseq changes for Linux 5.15-rc3
Date:   Thu, 23 Sep 2021 14:12:52 -0400
Message-Id: <20210923181252.44385-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit e4e737bb5c170df6135a127739a9e6148ee3da82:

  Linux 5.15-rc2 (2021-09-19 17:28:22 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-rseq

for you to fetch changes up to 2da4a23599c263bd4a7658c2fe561cb3a73ea6ae:

  KVM: selftests: Remove __NR_userfaultfd syscall fallback (2021-09-22 10:24:02 -0400)

----------------------------------------------------------------
A fix for a bug with restartable sequences and KVM.  KVM's handling
of TIF_NOTIFY_RESUME, e.g. for task migration, clears the flag without
informing rseq and leads to stale data in userspace's rseq struct.

I'm sending this as a separate pull request since it's not code
that I usually touch.  In particular, patch 2 ("entry: rseq: Call
rseq_handle_notify_resume() in tracehook_notify_resume()") is just a
cleanup to try and make future bugs less likely.  If you prefer this to
be sent via Thomas and only in 5.16, please speak up.

----------------------------------------------------------------
Sean Christopherson (5):
      KVM: rseq: Update rseq when processing NOTIFY_RESUME on xfer to KVM guest
      entry: rseq: Call rseq_handle_notify_resume() in tracehook_notify_resume()
      tools: Move x86 syscall number fallbacks to .../uapi/
      KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs
      KVM: selftests: Remove __NR_userfaultfd syscall fallback

 arch/arm/kernel/signal.c                          |   1 -
 arch/arm64/kernel/signal.c                        |   4 +-
 arch/csky/kernel/signal.c                         |   4 +-
 arch/mips/kernel/signal.c                         |   4 +-
 arch/powerpc/kernel/signal.c                      |   4 +-
 include/linux/tracehook.h                         |   2 +
 kernel/entry/common.c                             |   4 +-
 kernel/rseq.c                                     |  14 +-
 tools/arch/x86/include/{ => uapi}/asm/unistd_32.h |   0
 tools/arch/x86/include/{ => uapi}/asm/unistd_64.h |   3 -
 tools/testing/selftests/kvm/.gitignore            |   1 +
 tools/testing/selftests/kvm/Makefile              |   3 +
 tools/testing/selftests/kvm/rseq_test.c           | 236 ++++++++++++++++++++++
 13 files changed, 258 insertions(+), 22 deletions(-)
 rename tools/arch/x86/include/{ => uapi}/asm/unistd_32.h (100%)
 rename tools/arch/x86/include/{ => uapi}/asm/unistd_64.h (83%)
 create mode 100644 tools/testing/selftests/kvm/rseq_test.c

