Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88FC4EFA8D
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 21:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbiDATsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 15:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiDATsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 15:48:53 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDB61D2059
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 12:47:03 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id x1-20020a056e020f0100b002c98fce9c13so2458659ilj.3
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 12:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sGASyLBse2klm//8WmPcxLcR/0G/i4NUGrOkS5QfPwU=;
        b=p0I9TS+BxRlThc6cRuQsH+gXHlKHv9krEacz1VjAY7yKZldMuM5KnvSIVJAQtqZWIS
         ms13dhQL/oagduEMMikCqjI8fe0Il26LNT4mfIaDFyCY8UQ4wcJpW8wMXaYxc3WuQIvM
         mdupkhdVzZsef3F/9BV50VLdItdtPFVndfUr8B7o+MvldUqTjvZbRKJ4tsw9C7RhnT0p
         tGTUvq4GpmepsRjB3Z/NSlhaV+un8Bv1yvLJDUlr7lbjuUIICAFyOhRIeFBAwVHssCcM
         Q9rHvYe8T5j5uPcJ8tt3uaaz+/fFeykQyO7tsCryee8WEis3fkdBS6GJ/JuEmEt1u6Fi
         TtSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sGASyLBse2klm//8WmPcxLcR/0G/i4NUGrOkS5QfPwU=;
        b=DFK2ciepo9oyRg3WRgHFYREvIDn18mEAYxoF+b4vGs19KoGc4KAqY5VpQ4wtSST5Ej
         ZXqxs6r2PxwBY+m/l+RlgvEnExXrWKfJ+EMGeoX24vA9LKSFgQ9qK3Ym1+TDmQstTiUz
         hEJw2eTOen8kJDk6K1ULw1+CDEdL/cjKIpvap/BLFLq0rvMa1aWSRj8FCf0f8Xe0qPvL
         45ZVZ5QkepNqJvs+c91Ji8b/eAt95WuTV94jECF6D/i1bdb1uWhAadsXUJVCHxTs8QdY
         XQgOsC+MoO9gjhxzEHUWvlIKdlZsxvfCV1844TmDpL5KL2XM/JG/MdsOoPkjtk/mIyKO
         dZ7A==
X-Gm-Message-State: AOAM532KPfX08DmcsbzCVygUUdQb6pCL2huqZnIwuEQE7n6aBe29LXmI
        NuMDV1MJZXKufM/UauhIzDM0r5Ak6DY=
X-Google-Smtp-Source: ABdhPJzdy78X78ccSq0ir+N3gnYKV5tuuxTZVy7a3oFEuCUTAisBEAFvByvYnHiaUoeXiQdHX+wqwT+YhWE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1c46:b0:2c9:f0a8:2d32 with SMTP id
 d6-20020a056e021c4600b002c9f0a82d32mr641920ilg.54.1648842423330; Fri, 01 Apr
 2022 12:47:03 -0700 (PDT)
Date:   Fri,  1 Apr 2022 19:46:52 +0000
Message-Id: <20220401194652.950240-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2] KVM: arm64: Don't split hugepages outside of MMU write lock
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is possible to take a stage-2 permission fault on a page larger than
PAGE_SIZE. For example, when running a guest backed by 2M HugeTLB, KVM
eagerly maps at the largest possible block size. When dirty logging is
enabled on a memslot, KVM does *not* eagerly split these 2M stage-2
mappings and instead clears the write bit on the pte.

Since dirty logging is always performed at PAGE_SIZE granularity, KVM
lazily splits these 2M block mappings down to PAGE_SIZE in the stage-2
fault handler. This operation must be done under the write lock. Since
commit f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission
relaxation during dirty logging"), the stage-2 fault handler
conditionally takes the read lock on permission faults with dirty
logging enabled. To that end, it is possible to split a 2M block mapping
while only holding the read lock.

The problem is demonstrated by running kvm_page_table_test with 2M
anonymous HugeTLB, which splats like so:

  WARNING: CPU: 5 PID: 15276 at arch/arm64/kvm/hyp/pgtable.c:153 stage2_map_walk_leaf+0x124/0x158

  [...]

  Call trace:
  stage2_map_walk_leaf+0x124/0x158
  stage2_map_walker+0x5c/0xf0
  __kvm_pgtable_walk+0x100/0x1d4
  __kvm_pgtable_walk+0x140/0x1d4
  __kvm_pgtable_walk+0x140/0x1d4
  kvm_pgtable_walk+0xa0/0xf8
  kvm_pgtable_stage2_map+0x15c/0x198
  user_mem_abort+0x56c/0x838
  kvm_handle_guest_abort+0x1fc/0x2a4
  handle_exit+0xa4/0x120
  kvm_arch_vcpu_ioctl_run+0x200/0x448
  kvm_vcpu_ioctl+0x588/0x664
  __arm64_sys_ioctl+0x9c/0xd4
  invoke_syscall+0x4c/0x144
  el0_svc_common+0xc4/0x190
  do_el0_svc+0x30/0x8c
  el0_svc+0x28/0xcc
  el0t_64_sync_handler+0x84/0xe4
  el0t_64_sync+0x1a4/0x1a8

Fix the issue by only acquiring the read lock if the guest faulted on a
PAGE_SIZE granule w/ dirty logging enabled. Add a WARN to catch locking
bugs in future changes.

Fixes: f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission relaxation during dirty logging")
Cc: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---

Applies cleanly to kvmarm/fixes at the following commit:

  8872d9b3e35a ("KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler")

Tested the patch by running KVM selftests. Additionally, I did 10
iterations of the kvm_page_table_test with 2M anon HugeTLB memory.

It is expected that this patch will cause fault serialization in the
pathological case where all vCPUs are faulting on the same granule of
memory, as every vCPU will attempt to acquire the write lock. The only
safe way to cure this contention is to dissolve pages eagerly outside of
the stage-2 fault handler (like x86).

v1: https://lore.kernel.org/kvmarm/20220331213844.2894006-1-oupton@google.com/

v1 -> v2:
 - Drop impossible check for !use_read_lock before
   kvm_pgtable_stage2_map() (Reiji)
 - Codify the requirement to hold the write lock to call
   kvm_pgtable_stage2_map() with a WARN

 arch/arm64/kvm/mmu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0d19259454d8..53ae2c0640bc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1079,7 +1079,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	bool logging_perm_fault = false;
+	bool use_read_lock = false;
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1114,7 +1114,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
-		logging_perm_fault = (fault_status == FSC_PERM && write_fault);
+		use_read_lock = (fault_status == FSC_PERM && write_fault &&
+				 fault_granule == PAGE_SIZE);
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
@@ -1218,7 +1219,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging dirty logging, only acquire read lock for permission
 	 * relaxation.
 	 */
-	if (logging_perm_fault)
+	if (use_read_lock)
 		read_lock(&kvm->mmu_lock);
 	else
 		write_lock(&kvm->mmu_lock);
@@ -1268,6 +1269,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
 	} else {
+		WARN_ONCE(use_read_lock, "Attempted stage-2 map outside of write lock\n");
+
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache);
@@ -1280,7 +1283,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	if (logging_perm_fault)
+	if (use_read_lock)
 		read_unlock(&kvm->mmu_lock);
 	else
 		write_unlock(&kvm->mmu_lock);
-- 
2.35.1.1094.g7c7d902a7c-goog

