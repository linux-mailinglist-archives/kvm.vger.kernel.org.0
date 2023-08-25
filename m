Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1756F787D9D
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 04:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjHYCYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 22:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbjHYCYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 22:24:05 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6882CCB
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 19:24:03 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56c49207ce2so332924a12.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 19:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692930243; x=1693535043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oVtCByE4fDO3d4y8kIYOOEOORwXrAjMG9bL5RaKJEvo=;
        b=ur6VpWRHVFba2UbZYv3uMwXPvqeBZqy5oCA5fJjgrGUUBOyYN2oleq4keewpDQ+mxs
         P8kpbCDHKLDGTRsSFbyu4ZUDbKQTxpnzSRHTSdsuQa5eys8Gz8s4vCcnRi+5QORbXeNI
         ziPChPP/73BRcKbpEZLOQhEjmPwdtLpXfrJBfsiTG3n5fNBFXQ1SGfoULSTV9igNAFw/
         hic7Y1EbDaXCPCAQdrPpxCZuMImeMGhYoq0tsYCiBEuo5yzLeG/PUhTF0PrGOHOICFjz
         gqxh/pN++mdXmJyyD06AZfRCsoFkxr1CD+/DfGXd47yt2yUwJOjrQzwTxXESyENUY5ig
         rosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692930243; x=1693535043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oVtCByE4fDO3d4y8kIYOOEOORwXrAjMG9bL5RaKJEvo=;
        b=MAZ5P0RD59xFQdWQF+YFEOfgYpMpKmrkdi+A/rDORY9XeoxC14sueCgpMI1ppD/tXI
         O7oEN6+CagFHOg1Ag5uwk6m7UAb5zKDh8t7Z1Fy55JHsSCuxzwDiaX0gL90HNZYYf8md
         uD9HiA70Nf76SaKZqXfr9+S9rl8jyR3sCPkxZbFG3JvB1bsQxIexgNCq5yeMQmtxaRV7
         unE12AobS96Cq04Sqy7hqzF8ObdJdcbmD/xEQ9eSL4zylRqwQpzFuU/j5YiTazM6UtDb
         /FR8lyEuT/oIIM9a8yRMLmprdbfBjDeuZ12Rm7ctpwStNVPw/Q/jVIqL5xq53JdDvcAt
         vfDA==
X-Gm-Message-State: AOJu0Yy0cwlQ6uQh0hufqPx4bz3Ne0RGF5adz6uQNPTV6VlRERlZ2xei
        7LfwafruCB2CgLgV+ZaRO9k2pZfeMD4=
X-Google-Smtp-Source: AGHT+IF4TG4sBB/OOSznvFnGrC/wmig/Of5xf2wy3XzoLJK2Grrjw7w1nIisXmoqH4AKiH2Jo7cmip6vg1Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:be49:0:b0:569:3810:dda3 with SMTP id
 g9-20020a63be49000000b005693810dda3mr3190445pgo.9.1692930243268; Thu, 24 Aug
 2023 19:24:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Aug 2023 19:23:56 -0700
In-Reply-To: <20230825022357.2852133-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230825022357.2852133-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230825022357.2852133-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: SVM: Get source vCPUs from source VM for SEV-ES
 intrahost migration
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a goof where KVM tries to grab source vCPUs from the destination VM
when doing intrahost migration.  Grabbing the wrong vCPU not only hoses
the guest, it also crashes the host due to the VMSA pointer being left
NULL.

  BUG: unable to handle page fault for address: ffffe38687000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP NOPTI
  CPU: 39 PID: 17143 Comm: sev_migrate_tes Tainted: GO       6.5.0-smp--fff2e47e6c3b-next #151
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 34.28.0 07/10/2023
  RIP: 0010:__free_pages+0x15/0xd0
  RSP: 0018:ffff923fcf6e3c78 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffffe38687000000 RCX: 0000000000000100
  RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffffe38687000000
  RBP: ffff923fcf6e3c88 R08: ffff923fcafb0000 R09: 0000000000000000
  R10: 0000000000000000 R11: ffffffff83619b90 R12: ffff923fa9540000
  R13: 0000000000080007 R14: ffff923f6d35d000 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff929d0d7c0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffe38687000000 CR3: 0000005224c34005 CR4: 0000000000770ee0
  PKRU: 55555554
  Call Trace:
   <TASK>
   sev_free_vcpu+0xcb/0x110 [kvm_amd]
   svm_vcpu_free+0x75/0xf0 [kvm_amd]
   kvm_arch_vcpu_destroy+0x36/0x140 [kvm]
   kvm_destroy_vcpus+0x67/0x100 [kvm]
   kvm_arch_destroy_vm+0x161/0x1d0 [kvm]
   kvm_put_kvm+0x276/0x560 [kvm]
   kvm_vm_release+0x25/0x30 [kvm]
   __fput+0x106/0x280
   ____fput+0x12/0x20
   task_work_run+0x86/0xb0
   do_exit+0x2e3/0x9c0
   do_group_exit+0xb1/0xc0
   __x64_sys_exit_group+0x1b/0x20
   do_syscall_64+0x41/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
   </TASK>
  CR2: ffffe38687000000

Fixes: 6defa24d3b12 ("KVM: SEV: Init target VMCBs in sev_migrate_from")
Cc: stable@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2cd15783dfb9..acc700bcb299 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1739,7 +1739,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 		 * Note, the source is not required to have the same number of
 		 * vCPUs as the destination when migrating a vanilla SEV VM.
 		 */
-		src_vcpu = kvm_get_vcpu(dst_kvm, i);
+		src_vcpu = kvm_get_vcpu(src_kvm, i);
 		src_svm = to_svm(src_vcpu);
 
 		/*
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

