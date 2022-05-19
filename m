Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1DB52D4BD
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiESNqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239128AbiESNpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8FDA5036
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8913561798
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9DBC36AE5;
        Thu, 19 May 2022 13:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967900;
        bh=SxLFdfnMnEkcdrJsQkkeO75KQ4eQ7yY1tbJ5lT5ChX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPqQc4zFWaMfABPQw5/dfWp2s/7zHYM4gze5jPW/dQaRUBPmocGR+TcexDTEnwGMM
         WJvO3tIobJKM1MzgXouAiiYjA6CHFTaOdjqSOS7lvHtFc1O+EfmIX3u5EgX2Z+2OUM
         rmB9N6bKE5jmxc9UB4Uz85VqPcUA9C2pduwt5TbVOmXPD9dt+ZCNk+XaHvw391dfX7
         bkGM4ItJ/0wz5rTkUnSMJDbIKUL3Ofi3USzyfEbSkeyh8W6b5rgCg5PK+vS17guiNl
         fbt/1HMMOHa6ZTqaEkpF/0aqIgAskIulImvKfGdF2DHv6grWpZrwdvlssJWnyolUGG
         A4MDzh0YrL17Q==
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
Subject: [PATCH 39/89] KVM: arm64: Extend memory donation to allow host-to-guest transitions
Date:   Thu, 19 May 2022 14:41:14 +0100
Message-Id: <20220519134204.5379-40-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for supporting protected guests, where guest memory
defaults to being inaccessible to the host, extend our memory protection
mechanisms to support donation of pages from the host to a specific
guest.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 62 +++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c                  |  2 +-
 3 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 364432276fe0..b01b5cdb38de 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -69,6 +69,7 @@ int __pkvm_host_reclaim_page(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu);
+int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2e92be8bb463..d0544259eb01 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -890,6 +890,14 @@ static int guest_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
 					      size, PKVM_NOPAGE);
 }
 
+static int guest_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	return __guest_check_page_state_range(tx->completer.guest.vcpu, addr,
+					      size, PKVM_NOPAGE);
+}
+
 static int guest_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
 				enum kvm_pgtable_prot perms)
 {
@@ -903,6 +911,17 @@ static int guest_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
 				      prot, &vcpu->arch.pkvm_memcache);
 }
 
+static int guest_complete_donation(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	enum kvm_pgtable_prot prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED);
+	struct kvm_vcpu *vcpu = tx->completer.guest.vcpu;
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	return kvm_pgtable_stage2_map(&vm->pgt, addr, size, tx->completer.guest.phys,
+				      prot, &vcpu->arch.pkvm_memcache);
+}
+
 static int check_share(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
@@ -1088,6 +1107,9 @@ static int check_donation(struct pkvm_mem_donation *donation)
 	case PKVM_ID_HYP:
 		ret = hyp_ack_donation(completer_addr, tx);
 		break;
+	case PKVM_ID_GUEST:
+		ret = guest_ack_donation(completer_addr, tx);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1122,6 +1144,9 @@ static int __do_donate(struct pkvm_mem_donation *donation)
 	case PKVM_ID_HYP:
 		ret = hyp_complete_donation(completer_addr, tx);
 		break;
+	case PKVM_ID_GUEST:
+		ret = guest_complete_donation(completer_addr, tx);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1362,6 +1387,43 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u64 guest_addr = hyp_pfn_to_phys(gfn);
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	struct pkvm_mem_donation donation = {
+		.tx	= {
+			.nr_pages	= 1,
+			.initiator	= {
+				.id	= PKVM_ID_HOST,
+				.addr	= host_addr,
+				.host	= {
+					.completer_addr = guest_addr,
+				},
+			},
+			.completer	= {
+				.id	= PKVM_ID_GUEST,
+				.guest	= {
+					.vcpu = vcpu,
+					.phys = host_addr,
+				},
+			},
+		},
+	};
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = do_donate(&donation);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
+
 static int hyp_zero_page(phys_addr_t phys)
 {
 	void *addr;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a6676fd14cf9..2069e6833831 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -47,7 +47,7 @@
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-#define KVM_MAX_OWNER_ID		1
+#define KVM_MAX_OWNER_ID		FIELD_MAX(KVM_INVALID_PTE_OWNER_MASK)
 
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
-- 
2.36.1.124.g0e6072fb45-goog

