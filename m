Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30616399C5
	for <lists+kvm@lfdr.de>; Sun, 27 Nov 2022 09:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiK0IyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 03:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiK0IyK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 03:54:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F377CBC1C
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 00:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669539198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Br4Rln7XCqJbOUw1KscJEXa06iK1vrBwPHJNVfCnrC8=;
        b=B0jgQ9MGSbowF5SA1hT6G0Luyp7oiyxW4cUu+bUVWNCFhellb17axbJbtIu2Cv7pADzMNk
        vSYNltSBPVBXPqQAGFsFZHBe2HPa6OR4UGUYep8t9CXijNsyBlQt9EWMXIi8wp4811EZ7B
        Gxny4GXEjDCQbIQzGRsoLpySZwodgs4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-zDqUkPI3MrGTDPCqFSKIvQ-1; Sun, 27 Nov 2022 03:53:17 -0500
X-MC-Unique: zDqUkPI3MrGTDPCqFSKIvQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9F1D8339B4;
        Sun, 27 Nov 2022 08:53:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D455492B05;
        Sun, 27 Nov 2022 08:53:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.1-rc7
Date:   Sun, 27 Nov 2022 03:53:16 -0500
Message-Id: <20221127085316.452610-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 6d3085e4d89ad7e6c7f1c6cf929d903393565861:

  KVM: x86/mmu: Block all page faults during kvm_zap_gfn_range() (2022-11-11 07:19:46 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to fe08e36be9ecbf6b38714a77c97b1d25b7a6e4b0:

  Merge branch 'kvm-dwmw2-fixes' into HEAD (2022-11-23 18:59:45 -0500)

----------------------------------------------------------------
x86:

* Fixes for Xen emulation.  While nobody should be enabling it in
  the kernel (the only public users of the feature are the selftests),
  the bug effectively allows userspace to read arbitrary memory.

* Correctness fixes for nested hypervisors that do not intercept INIT
  or SHUTDOWN on AMD; the subsequent CPU reset can cause a use-after-free
  when it disables virtualization extensions.  While downgrading the panic
  to a WARN is quite easy, the full fix is a bit more laborious; there
  are also tests.  This is the bulk of the pull request.

* Fix race condition due to incorrect mmu_lock use around
  make_mmu_pages_available().

Generic:

* Obey changes to the kvm.halt_poll_ns module parameter in VMs
  not using KVM_CAP_HALT_POLL, restoring behavior from before
  the introduction of the capability

----------------------------------------------------------------
David Matlack (3):
      KVM: Cap vcpu->halt_poll_ns before halting rather than after
      KVM: Avoid re-reading kvm->max_halt_poll_ns during halt-polling
      KVM: Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL

David Woodhouse (3):
      KVM: x86/xen: Validate port number in SCHEDOP_poll
      KVM: x86/xen: Only do in-kernel acceleration of hypercalls for guest CPL0
      KVM: Update gfn_to_pfn_cache khva when it moves within the same page

Kazuki Takiguchi (1):
      KVM: x86/mmu: Fix race condition in direct_page_fault

Maxim Levitsky (9):
      KVM: x86: nSVM: leave nested mode on vCPU free
      KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while still in use
      KVM: x86: add kvm_leave_nested
      KVM: x86: forcibly leave nested mode on vCPU reset
      KVM: selftests: move idt_entry to header
      kvm: selftests: add svm nested shutdown test
      KVM: x86: allow L1 to not intercept triple fault
      KVM: selftests: add svm part to triple_fault_test
      KVM: x86: remove exit_int_info warning in svm_handle_exit

Paolo Bonzini (2):
      Merge branch 'kvm-svm-harden' into HEAD
      Merge branch 'kvm-dwmw2-fixes' into HEAD

 arch/x86/kvm/mmu/mmu.c                             | 13 ++--
 arch/x86/kvm/svm/nested.c                          | 12 +++-
 arch/x86/kvm/svm/svm.c                             | 16 +----
 arch/x86/kvm/vmx/nested.c                          |  4 +-
 arch/x86/kvm/x86.c                                 | 29 +++++++--
 arch/x86/kvm/xen.c                                 | 32 +++++++---
 include/linux/kvm_host.h                           |  1 +
 tools/testing/selftests/kvm/.gitignore             |  1 +
 tools/testing/selftests/kvm/Makefile               |  1 +
 .../selftests/kvm/include/x86_64/processor.h       | 13 ++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 13 ----
 .../kvm/x86_64/svm_nested_shutdown_test.c          | 67 ++++++++++++++++++++
 .../selftests/kvm/x86_64/triple_fault_event_test.c | 73 +++++++++++++++++-----
 virt/kvm/kvm_main.c                                | 52 ++++++++++++---
 virt/kvm/pfncache.c                                |  7 ++-
 15 files changed, 251 insertions(+), 83 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c

