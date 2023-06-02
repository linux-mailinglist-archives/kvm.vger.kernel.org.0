Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F11971F772
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbjFBBBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbjFBBBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:01:42 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900C5F2
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:01:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b03cfa7602so7420745ad.3
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685667700; x=1688259700;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nbf2YY9JgvSR1isDO4f+1dVMAPGRxAlaP3N8pZvTMnM=;
        b=NTu3RQc/jBKHO9MZ6qOtzpgygscxYYJv1uhntZv9YZJ+aS9lg11DuZKYikquoDjv0T
         VxYaKjTdzHfMASf4ahZyEBibdY/+SP+kHRTItKffWfHcVU+/Chf47HtLQWh1TLf9AJVm
         sbaKU3bH5OLrETrrb/t+0OXzj+juO1iyhZe2UKsb0ywusnKh8WdQmrcoUzV4oVwN6lzJ
         7H7pzT7syiMdpSQWzHqeGm5j1IHgvEuqffDYN9UXji9zCt8LIwy5I4dekA5ULmroDxe4
         xocWeBDRecCm/PxI1uFHi7UV0XUftNoT2veHu+HSrUxyM1gi5FJOsf5q59ua3HNsWhn3
         fhng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667700; x=1688259700;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nbf2YY9JgvSR1isDO4f+1dVMAPGRxAlaP3N8pZvTMnM=;
        b=iz73icPE7W3MoIep/WMjTIHGsmSIVpZDa3nmYEopuRrXzG1FnKyJcSL6dXbMsqNsPG
         lA0NV9qABaWOfb+YQ6Ep6YAHOlppdR+RCKD/cxGCK4UaN7ET0atYO8XW1wlVFVqTFeqB
         MsWp3Y23Ga0X3uo+27vKmPxJXeVh6vUpnG57N/7YnkjoL9XrnrHD9n+EkazqP5AlolK+
         VkxVzpTmi1SHVq+rxT7LhHOR9aJRBwtfaP37nOwUwhRiff1Gdbcv8nrlLYbGx9/Uao2m
         zjAmipqHU/PowBem9riofTV3HShlphoeujzbcQw1wO8xAmItMabRTU3lkJeOXYXY8Gxv
         zk9g==
X-Gm-Message-State: AC+VfDywzn19XZ6oRB5005oMG5Kr7F++KCAsmnj9TtKKSAuKHLaCC9h2
        K6ULzrj+c62c0Y/op3FVV/4FRr+rApg=
X-Google-Smtp-Source: ACHHUZ6PixROVRiD0d09qoKBuv2/hAT8sl7ON6bIyuLhSadb1FPDwByLKB3+rJ4v9xCkzE7nauuhhN2LCC4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bf4c:b0:1ac:af80:5a8a with SMTP id
 u12-20020a170902bf4c00b001acaf805a8amr252587pls.9.1685667700010; Thu, 01 Jun
 2023 18:01:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Jun 2023 18:01:37 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230602010137.784664-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Grab memslot for correct address space in NX
 recovery worker
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Coatti <fabio.coatti@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor in the address space (non-SMM vs. SMM) of the target shadow page
when recovering potential NX huge pages, otherwise KVM will retrieve the
wrong memslot when zapping shadow pages that were created for SMM.  The
bug most visibly manifests as a WARN on the memslot being non-NULL, but
the worst case scenario is that KVM could unaccount the shadow page
without ensuring KVM won't install a huge page, i.e. if the non-SMM slot
is being dirty logged, but the SMM slot is not.

 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 3911 at arch/x86/kvm/mmu/mmu.c:7015
 kvm_nx_huge_page_recovery_worker+0x38c/0x3d0 [kvm]
 CPU: 1 PID: 3911 Comm: kvm-nx-lpage-re
 RIP: 0010:kvm_nx_huge_page_recovery_worker+0x38c/0x3d0 [kvm]
 RSP: 0018:ffff99b284f0be68 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff99b284edd000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: ffff9271397024e0 R08: 0000000000000000 R09: ffff927139702450
 R10: 0000000000000000 R11: 0000000000000001 R12: ffff99b284f0be98
 R13: 0000000000000000 R14: ffff9270991fcd80 R15: 0000000000000003
 FS:  0000000000000000(0000) GS:ffff927f9f640000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f0aacad3ae0 CR3: 000000088fc2c005 CR4: 00000000003726e0
 Call Trace:
  <TASK>
__pfx_kvm_nx_huge_page_recovery_worker+0x10/0x10 [kvm]
  kvm_vm_worker_thread+0x106/0x1c0 [kvm]
  kthread+0xd9/0x100
  ret_from_fork+0x2c/0x50
  </TASK>
 ---[ end trace 0000000000000000 ]---

This bug was exposed by commit edbdb43fc96b ("KVM: x86: Preserve TDP MMU
roots until they are explicitly invalidated"), which allowed KVM to retain
SMM TDP MMU roots effectively indefinitely.  Before commit edbdb43fc96b,
KVM would zap all SMM TDP MMU roots and thus all SMM TDP MMU shadow pages
once all vCPUs exited SMM, which made the window where this bug (recovering
an SMM NX huge page) could be encountered quite tiny.  To hit the bug, the
NX recovery thread would have to run while at least one vCPU was in SMM.
Most VMs typically only use SMM during boot, and so the problematic shadow
pages were gone by the time the NX recovery thread ran.

Now that KVM preserves TDP MMU roots until they are explicitly invalidated
(e.g. by a memslot deletion), the window to trigger the bug is effectively
never closed because most VMMs don't delete memslots after boot (except
for a handful of special scenarios).

Fixes: eb298605705a ("KVM: x86/mmu: Do not recover dirty-tracked NX Huge Pages")
Reported-by: Fabio Coatti <fabio.coatti@gmail.com>
Closes: https://lore.kernel.org/all/CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..6eaa3d6994ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7091,7 +7091,10 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 		 */
 		slot = NULL;
 		if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
-			slot = gfn_to_memslot(kvm, sp->gfn);
+			struct kvm_memslots *slots;
+
+			slots = kvm_memslots_for_spte_role(kvm, sp->role);
+			slot = __gfn_to_memslot(slots, sp->gfn);
 			WARN_ON_ONCE(!slot);
 		}
 

base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

