Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD20552D500
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbiESNsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239184AbiESNsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:48:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360AF46149
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E935C617A0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFFDC34115;
        Thu, 19 May 2022 13:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968078;
        bh=9Xcg6PAiUhNMzYZjYDeZGGUgT1Ycy9l//rfV2Q6AvI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVEwx9HdjMpmh5ekCS7FwgjsynUf+WyeDaaU/04ro0kPpDvf4efNYF4t4LVB38aJu
         s2LSdeTCktXW9LNvlin/NICKBD5+esxWOHK54yG8m+zhIzWtNg5f/vsiPqAjgmy8ky
         HQ+gstuU2TuB1ovJ7rhKlWccQ8BfNptg0+2x60h6tA3UnzUsepvqjj/2iF6MvBqQ3k
         F8xwyVa5TLJCWzIh2XhG4nCHTRZ9Fwxz7zMj60J9VDkRnsNyAdw1ZyNYhnJBI31wq8
         GEsNJnlBD392FRYYzE0iIpb7ZSeskVSqyI3CKfNx15VQoVjk9krY9CK/r0SMZqBzWp
         XONyClLQ0j9hQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 84/89] KVM: arm64: Extend memory sharing to allow guest-to-host transitions
Date:   Thu, 19 May 2022 14:41:59 +0100
Message-Id: <20220519134204.5379-85-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A guest that can only operate on private memory is pretty useless, as it
has no way to share buffers with the host for things like virtio.

Extend our memory protection mechanisms to support the sharing and
unsharing of guest pages from the guest to the host. For now, this
functionality is unused but will later be exposed to the guest via
hypercalls.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 232 ++++++++++++++++++
 2 files changed, 234 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index b01b5cdb38de..e0bbb1726fa3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -70,6 +70,8 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu);
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu);
+int __pkvm_guest_share_host(struct kvm_vcpu *vcpu, u64 ipa);
+int __pkvm_guest_unshare_host(struct kvm_vcpu *vcpu, u64 ipa);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8459dc33e460..d839bb573b49 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -780,11 +780,41 @@ static int __host_ack_transition(u64 addr, const struct pkvm_mem_transition *tx,
 	return __host_check_page_state_range(addr, size, state);
 }
 
+static int host_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
+			  enum kvm_pgtable_prot perms)
+{
+	if (perms != PKVM_HOST_MEM_PROT)
+		return -EPERM;
+
+	return __host_ack_transition(addr, tx, PKVM_NOPAGE);
+}
+
 static int host_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
 {
 	return __host_ack_transition(addr, tx, PKVM_NOPAGE);
 }
 
+static int host_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	return __host_ack_transition(addr, tx, PKVM_PAGE_SHARED_BORROWED);
+}
+
+static int host_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
+			       enum kvm_pgtable_prot perms)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	return __host_set_page_state_range(addr, size, PKVM_PAGE_SHARED_BORROWED);
+}
+
+static int host_complete_unshare(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	u8 owner_id = tx->initiator.id;
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	return host_stage2_set_owner_locked(addr, size, owner_id);
+}
+
 static int host_complete_donation(u64 addr, const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
@@ -970,6 +1000,120 @@ static int guest_complete_donation(u64 addr, const struct pkvm_mem_transition *t
 				      prot, &vcpu->arch.pkvm_memcache);
 }
 
+static int __guest_get_completer_addr(u64 *completer_addr, phys_addr_t phys,
+				      const struct pkvm_mem_transition *tx)
+{
+	switch (tx->completer.id) {
+	case PKVM_ID_HOST:
+		*completer_addr = phys;
+		break;
+	case PKVM_ID_HYP:
+		*completer_addr = (u64)__hyp_va(phys);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __guest_request_page_transition(u64 *completer_addr,
+					   const struct pkvm_mem_transition *tx,
+					   enum pkvm_page_state desired)
+{
+	struct kvm_vcpu *vcpu = tx->initiator.guest.vcpu;
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	enum pkvm_page_state state;
+	phys_addr_t phys;
+	kvm_pte_t pte;
+	u32 level;
+	int ret;
+
+	if (tx->nr_pages != 1)
+		return -E2BIG;
+
+	ret = kvm_pgtable_get_leaf(&vm->pgt, tx->initiator.addr, &pte, &level);
+	if (ret)
+		return ret;
+
+	state = guest_get_page_state(pte);
+	if (state == PKVM_NOPAGE)
+		return -EFAULT;
+
+	if (state != desired)
+		return -EPERM;
+
+	/*
+	 * We only deal with page granular mappings in the guest for now as
+	 * the pgtable code relies on being able to recreate page mappings
+	 * lazily after zapping a block mapping, which doesn't work once the
+	 * pages have been donated.
+	 */
+	if (level != KVM_PGTABLE_MAX_LEVELS - 1)
+		return -EINVAL;
+
+	phys = kvm_pte_to_phys(pte);
+	if (!addr_is_allowed_memory(phys))
+		return -EINVAL;
+
+	return __guest_get_completer_addr(completer_addr, phys, tx);
+}
+
+static int guest_request_share(u64 *completer_addr,
+			       const struct pkvm_mem_transition *tx)
+{
+	return __guest_request_page_transition(completer_addr, tx,
+					       PKVM_PAGE_OWNED);
+}
+
+static int guest_request_unshare(u64 *completer_addr,
+				 const struct pkvm_mem_transition *tx)
+{
+	return __guest_request_page_transition(completer_addr, tx,
+					       PKVM_PAGE_SHARED_OWNED);
+}
+
+static int __guest_initiate_page_transition(u64 *completer_addr,
+					    const struct pkvm_mem_transition *tx,
+					    enum pkvm_page_state state)
+{
+	struct kvm_vcpu *vcpu = tx->initiator.guest.vcpu;
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	struct kvm_hyp_memcache *mc = &vcpu->arch.pkvm_memcache;
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	u64 addr = tx->initiator.addr;
+	enum kvm_pgtable_prot prot;
+	phys_addr_t phys;
+	kvm_pte_t pte;
+	int ret;
+
+	ret = kvm_pgtable_get_leaf(&vm->pgt, addr, &pte, NULL);
+	if (ret)
+		return ret;
+
+	phys = kvm_pte_to_phys(pte);
+	prot = pkvm_mkstate(kvm_pgtable_stage2_pte_prot(pte), state);
+	ret = kvm_pgtable_stage2_map(&vm->pgt, addr, size, phys, prot, mc);
+	if (ret)
+		return ret;
+
+	return __guest_get_completer_addr(completer_addr, phys, tx);
+}
+
+static int guest_initiate_share(u64 *completer_addr,
+				const struct pkvm_mem_transition *tx)
+{
+	return __guest_initiate_page_transition(completer_addr, tx,
+						PKVM_PAGE_SHARED_OWNED);
+}
+
+static int guest_initiate_unshare(u64 *completer_addr,
+				  const struct pkvm_mem_transition *tx)
+{
+	return __guest_initiate_page_transition(completer_addr, tx,
+						PKVM_PAGE_OWNED);
+}
+
 static int check_share(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
@@ -980,6 +1124,9 @@ static int check_share(struct pkvm_mem_share *share)
 	case PKVM_ID_HOST:
 		ret = host_request_owned_transition(&completer_addr, tx);
 		break;
+	case PKVM_ID_GUEST:
+		ret = guest_request_share(&completer_addr, tx);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -988,6 +1135,9 @@ static int check_share(struct pkvm_mem_share *share)
 		return ret;
 
 	switch (tx->completer.id) {
+	case PKVM_ID_HOST:
+		ret = host_ack_share(completer_addr, tx, share->completer_prot);
+		break;
 	case PKVM_ID_HYP:
 		ret = hyp_ack_share(completer_addr, tx, share->completer_prot);
 		break;
@@ -1011,6 +1161,9 @@ static int __do_share(struct pkvm_mem_share *share)
 	case PKVM_ID_HOST:
 		ret = host_initiate_share(&completer_addr, tx);
 		break;
+	case PKVM_ID_GUEST:
+		ret = guest_initiate_share(&completer_addr, tx);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1019,6 +1172,9 @@ static int __do_share(struct pkvm_mem_share *share)
 		return ret;
 
 	switch (tx->completer.id) {
+	case PKVM_ID_HOST:
+		ret = host_complete_share(completer_addr, tx, share->completer_prot);
+		break;
 	case PKVM_ID_HYP:
 		ret = hyp_complete_share(completer_addr, tx, share->completer_prot);
 		break;
@@ -1062,6 +1218,9 @@ static int check_unshare(struct pkvm_mem_share *share)
 	case PKVM_ID_HOST:
 		ret = host_request_unshare(&completer_addr, tx);
 		break;
+	case PKVM_ID_GUEST:
+		ret = guest_request_unshare(&completer_addr, tx);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1070,6 +1229,9 @@ static int check_unshare(struct pkvm_mem_share *share)
 		return ret;
 
 	switch (tx->completer.id) {
+	case PKVM_ID_HOST:
+		ret = host_ack_unshare(completer_addr, tx);
+		break;
 	case PKVM_ID_HYP:
 		ret = hyp_ack_unshare(completer_addr, tx);
 		break;
@@ -1090,6 +1252,9 @@ static int __do_unshare(struct pkvm_mem_share *share)
 	case PKVM_ID_HOST:
 		ret = host_initiate_unshare(&completer_addr, tx);
 		break;
+	case PKVM_ID_GUEST:
+		ret = guest_initiate_unshare(&completer_addr, tx);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1098,6 +1263,9 @@ static int __do_unshare(struct pkvm_mem_share *share)
 		return ret;
 
 	switch (tx->completer.id) {
+	case PKVM_ID_HOST:
+		ret = host_complete_unshare(completer_addr, tx);
+		break;
 	case PKVM_ID_HYP:
 		ret = hyp_complete_unshare(completer_addr, tx);
 		break;
@@ -1255,6 +1423,70 @@ int __pkvm_host_share_hyp(u64 pfn)
 	return ret;
 }
 
+int __pkvm_guest_share_host(struct kvm_vcpu *vcpu, u64 ipa)
+{
+	int ret;
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	struct pkvm_mem_share share = {
+		.tx	= {
+			.nr_pages	= 1,
+			.initiator	= {
+				.id	= PKVM_ID_GUEST,
+				.addr	= ipa,
+				.guest	= {
+					.vcpu = vcpu,
+				},
+			},
+			.completer	= {
+				.id	= PKVM_ID_HOST,
+			},
+		},
+		.completer_prot	= PKVM_HOST_MEM_PROT,
+	};
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = do_share(&share);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
+
+int __pkvm_guest_unshare_host(struct kvm_vcpu *vcpu, u64 ipa)
+{
+	int ret;
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	struct pkvm_mem_share share = {
+		.tx	= {
+			.nr_pages	= 1,
+			.initiator	= {
+				.id	= PKVM_ID_GUEST,
+				.addr	= ipa,
+				.guest	= {
+					.vcpu = vcpu,
+				},
+			},
+			.completer	= {
+				.id	= PKVM_ID_HOST,
+			},
+		},
+		.completer_prot	= PKVM_HOST_MEM_PROT,
+	};
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = do_unshare(&share);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
+
 int __pkvm_host_unshare_hyp(u64 pfn)
 {
 	int ret;
-- 
2.36.1.124.g0e6072fb45-goog

