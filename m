Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D29543747
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 17:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244683AbiFHPZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 11:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244385AbiFHPYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 11:24:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59FE1264
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 08:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654701613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oI7iLpKGOzsaKuECmyGzbvgD7svr83STRun8kjdiZxg=;
        b=H09ltKUJ8qQ5vdj2V/oAka5Bql+gUaSLBg7RvmQooYus33UJ2Mf6yzmjT9qcY9/MfMg+eg
        nqp/8p7bulvi8GXroUwpfxbsgpKab3IppkeYHwDcYBGIm6L6Ady+/QsE7a75oTmN6pJ8n+
        LdtNmG/pgtOp7CZmCY3tjKaHrGvMtsg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-gkXZE3VIPcuEZBg54Z3j_A-1; Wed, 08 Jun 2022 11:20:10 -0400
X-MC-Unique: gkXZE3VIPcuEZBg54Z3j_A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1239385A584;
        Wed,  8 Jun 2022 15:20:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E89C718EA5;
        Wed,  8 Jun 2022 15:20:09 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.19-rc2
Date:   Wed,  8 Jun 2022 11:20:09 -0400
Message-Id: <20220608152009.893314-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit ffd1925a596ce68bed7d81c61cb64bc35f788a9d:

  KVM: x86: Fix the intel_pt PMI handling wrongly considered from guest (2022-05-25 05:18:27 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 6cd88243c7e03845a450795e134b488fc2afb736:

  KVM: x86: do not report a vCPU as preempted outside instruction boundaries (2022-06-08 04:21:07 -0400)

----------------------------------------------------------------
* Fix syzkaller NULL pointer dereference
* Fix TDP MMU performance issue with disabling dirty logging
* Fix 5.14 regression with SVM TSC scaling
* Fix indefinite stall on applying live patches
* Fix unstable selftest
* Fix memory leak from wrong copy-and-paste
* Fix missed PV TLB flush when racing with emulation

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      KVM: Don't null dereference ops->destroy

Ben Gardon (1):
      KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty logging

Jan Beulich (1):
      x86: drop bogus "cc" clobber from __try_cmpxchg_user_asm()

Maxim Levitsky (1):
      KVM: SVM: fix tsc scaling cache logic

Paolo Bonzini (2):
      KVM: x86: do not set st->preempted when going back to user space
      KVM: x86: do not report a vCPU as preempted outside instruction boundaries

Seth Forshee (1):
      entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is set

Shaoqin Huang (1):
      KVM: x86/mmu: Check every prev_roots in __kvm_mmu_free_obsolete_roots()

Vitaly Kuznetsov (1):
      KVM: selftests: Make hyperv_clock selftest more stable

 arch/x86/include/asm/kvm_host.h                   |  3 ++
 arch/x86/include/asm/uaccess.h                    |  2 +-
 arch/x86/kvm/mmu/mmu.c                            |  2 +-
 arch/x86/kvm/mmu/tdp_iter.c                       |  9 +++++
 arch/x86/kvm/mmu/tdp_iter.h                       |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c                        | 38 +++++++++++++++---
 arch/x86/kvm/svm/nested.c                         |  4 +-
 arch/x86/kvm/svm/svm.c                            | 34 ++++++++++------
 arch/x86/kvm/svm/svm.h                            |  2 +-
 arch/x86/kvm/vmx/vmx.c                            |  1 +
 arch/x86/kvm/x86.c                                | 48 +++++++++++++++++------
 arch/x86/kvm/xen.h                                |  6 ++-
 kernel/entry/kvm.c                                |  6 ---
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c | 10 +++--
 virt/kvm/kvm_main.c                               |  5 ++-
 15 files changed, 124 insertions(+), 47 deletions(-)

