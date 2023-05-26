Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFE071308D
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 01:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243601AbjEZXp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 19:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238108AbjEZXpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 19:45:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA58E57
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:44:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bad0f5d6a7dso2621780276.0
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685144695; x=1687736695;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M3AF7fBmc1xnJAMOiZdfCsfXZHiS6oPk41ReBM4zbdo=;
        b=yrD5cypjwj76oGySeMKoL+EObdL+VlHBR0ZE4dlUQxoYbTEWiiVpSKdOJmkcaaiF/Z
         4zilNg4E7S1qiA0OC/fMHUKvaq4lLe3h3XrcfBRajVZEzuTWsMjYGvjMBJ/wRyLbmfd/
         x0p59R3lRKLAmUF0+sTBQhD8rRciT1hrCi2rbco+ObNSFPCgz7YI6gzDi295X90OlgMM
         zrJNip6i/8aKO3FHb/HgogYFOfPOgx60+DOedoHxymQQDAPdmrus+K28IPt1M7E0g0cI
         asbBmGj30I6PgAgE5VquUWTvHUX2/5VYaFLlsw0xBC7qUsoM7lDeTwedn+JU6nSVVIPC
         w2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685144695; x=1687736695;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M3AF7fBmc1xnJAMOiZdfCsfXZHiS6oPk41ReBM4zbdo=;
        b=W2U7oOJvbsyWhsO/sdAaagFEGpa6OOUB2D4UwpSwktWccpj4pMX5NWtJtHmZJjYATc
         9v7w8MqYa5ACeMsrFVj0rhqZLZ+yriwtQMyrH4BmLa3SFn3vgon6IYOWo1IWAcN4eQAK
         wv2FCSjdKz+rnQGvX02gV35lmh5NQgeA2a/3xqg2VeCbiS1LMbWFaJQr6Ps+K2aGTQR9
         o72vGGcAQ/57nSWkoxFJQSaml3dO6xvgUOo62Z9UGnlXzPceYVgmyghGFwm00Qz1tvmY
         AJ8OlNbdk6hztzJkiChe9l4Ew67Bc1gG+9JAqImt8nV+KSemh8fAawHE/yg6B7pLjKZ0
         fuQg==
X-Gm-Message-State: AC+VfDzGMVXV7UoOOkrVxbmT6zWND9xx2ZpnYERxnWCiXAEdZEUAjDcs
        2ynnl1J1wHyI4XC2T3CKmUSAiBWXpTc=
X-Google-Smtp-Source: ACHHUZ4QgTvrucO0Q6McE6sU/ZYyF1Ujw9/eAceyjgq3u2aouYR16g/56Sc2t/zSHX7sxuPwIu+K0d0WjYg=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:910f:8a15:592b:2087])
 (user=yuzhao job=sendgmr) by 2002:a05:6902:1341:b0:bac:6bb:2549 with SMTP id
 g1-20020a056902134100b00bac06bb2549mr1840571ybu.7.1685144695170; Fri, 26 May
 2023 16:44:55 -0700 (PDT)
Date:   Fri, 26 May 2023 17:44:34 -0600
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
Message-Id: <20230526234435.662652-10-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Subject: [PATCH mm-unstable v2 09/10] kvm/x86: add kvm_arch_test_clear_young()
From:   Yu Zhao <yuzhao@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com, Yu Zhao <yuzhao@google.com>
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

Implement kvm_arch_test_clear_young() to support the fast path in
mmu_notifier_ops->test_clear_young().

It focuses on a simple case, i.e., TDP MMU sets the accessed bit in
KVM PTEs and VMs are not nested, where it can rely on RCU and
clear_bit() to safely clear the accessed bit without taking
kvm->mmu_lock. Complex cases fall back to the existing slow path
where kvm->mmu_lock is then taken.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 34 +++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 753c67072c47..d6dfdebe3d94 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2223,4 +2223,11 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
  */
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
+#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
+static inline bool kvm_arch_has_test_clear_young(void)
+{
+	return IS_ENABLED(CONFIG_X86_64) &&
+	       (!IS_REACHABLE(CONFIG_KVM) || (tdp_mmu_enabled && shadow_accessed_mask));
+}
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 08340219c35a..6875a819e007 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1232,6 +1232,40 @@ bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
 }
 
+bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	struct kvm_mmu_page *root;
+	int offset = ffs(shadow_accessed_mask) - 1;
+
+	if (kvm_shadow_root_allocated(kvm))
+		return true;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
+		struct tdp_iter iter;
+
+		if (kvm_mmu_page_as_id(root) != range->slot->as_id)
+			continue;
+
+		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
+			u64 *sptep = rcu_dereference(iter.sptep);
+
+			VM_WARN_ON_ONCE(!page_count(virt_to_page(sptep)));
+
+			if (!(iter.old_spte & shadow_accessed_mask))
+				continue;
+
+			if (kvm_should_clear_young(range, iter.gfn))
+				clear_bit(offset, (unsigned long *)sptep);
+		}
+	}
+
+	rcu_read_unlock();
+
+	return false;
+}
+
 static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 			 struct kvm_gfn_range *range)
 {
-- 
2.41.0.rc0.172.g3f132b7071-goog

