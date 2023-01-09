Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ED766338F
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjAIVyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbjAIVyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:54:08 -0500
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FBD3BE80
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:54:07 -0800 (PST)
Received: by mail-oi1-x24a.google.com with SMTP id bp6-20020a056808238600b00360c55456bcso3093508oib.2
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SDYN0MRDIF+SnOeyd4pyYdGIKCrHRaNe9q+tU9g7tHk=;
        b=JpgU+lBoUCLbZ56Jvj7Pn/vdi78vU5U3QuKtvIBxucZgLmZuMLmd88ZuQTUzyBKvak
         6URYiypCIW+TZt6tpj3vahCJkJfZ/bLR5/iBFmcgS2xJWZjSs5Km1XmDOCZFVyYNrNdF
         aQxMRNm9CoVdpDALfBC57x8+EFA1cfuvZqgDxyITXdGCIOEqTxQiAuVy9uJ1cxGO/3EV
         abfT9ocI5Otykw8Nadc9eXPbqcQZXXaZrNB0el9+yvluuWfZF1VWhrmpIVzBQ0tBz6CD
         +6oL0xnc06/xPuEhNIL+kfwdmFZFTaFbgKl3SlvFFlUqQ7wMRKAH+9CjY0D5URbPHfBd
         jhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDYN0MRDIF+SnOeyd4pyYdGIKCrHRaNe9q+tU9g7tHk=;
        b=1qZOWU/Iiqt8wOXL9eVDQZkPxDiQ/o/LM4htbkQtP7F5Ii/7OONT2iRWE7/o0PSsOg
         V3dO/Cni2U51ae3APXDC0Kv046V7f/9t0S8eo1wUi3WnsoLEs0ZwcnoC9rVrWFAVcu60
         wg7am4MbtU50inm3Md/Xdil392D+P98KNiM49u5UgHvAtn6EmPlxgor4/x/gczj0HgBz
         DfJw4siiVXtAxw8sireZUdnifsdqIJBn0nuZd2rF1Ggp4HmNIHyG9N+lxqHNa9QFTOk0
         CBs1TYLW3mBkIRTeruzm6PPY7ehcoAvrt0cUXybN9wdjEtIm4UJEIKkWAMsKVJ7Wlwxp
         G0YA==
X-Gm-Message-State: AFqh2kqlJUTTXfumf2mial6ce4o0fbNncr+021j6HHjmUB1KspyCMga1
        CxoSpGW+VzUULu/UWrjo4Jti532/wDRB
X-Google-Smtp-Source: AMrXdXtrkhTOwelbRPQw7yNs/JV3tuDLBxCLoimzlrlEKqCeF4IooRkE3J40GXTjhloRi+UlLLpIxIlpLZyo
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6808:1a1d:b0:364:532d:215a with SMTP
 id bk29-20020a0568081a1d00b00364532d215amr195559oib.187.1673301246427; Mon,
 09 Jan 2023 13:54:06 -0800 (PST)
Date:   Mon,  9 Jan 2023 21:53:44 +0000
In-Reply-To: <20230109215347.3119271-1-rananta@google.com>
Mime-Version: 1.0
References: <20230109215347.3119271-1-rananta@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109215347.3119271-4-rananta@google.com>
Subject: [RFC PATCH 3/6] KVM: Define kvm_flush_remote_tlbs_range
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define kvm_flush_remote_tlbs_range() to limit the TLB flush only
to a certain range of addresses. Replace this with the existing
call to kvm_flush_remote_tlbs() in the MMU notifier path.
Architectures such as arm64 can define this to flush only the
necessary addresses, instead of the entire range.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/mmu.c     | 10 ++++++++++
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      |  7 ++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 39d9a334efb57..70f76bc909c5d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -91,6 +91,16 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
 }
 
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end)
+{
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+
+	if (system_supports_tlb_range())
+		kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, mmu, start, end, 0);
+	else
+		kvm_flush_remote_tlbs(kvm);
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f51eb9419bfc3..a76cede9dc3bb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 03e6a38094c17..f538ecc984f5b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -376,6 +376,11 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 		++kvm->stat.generic.remote_tlb_flush;
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
+
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end)
+{
+	kvm_flush_remote_tlbs(kvm);
+}
 #endif
 
 static void kvm_flush_shadow_all(struct kvm *kvm)
@@ -637,7 +642,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	}
 
 	if (range->flush_on_ret && ret)
-		kvm_flush_remote_tlbs(kvm);
+		kvm_flush_remote_tlbs_range(kvm, range->start, range->end - 1);
 
 	if (locked) {
 		KVM_MMU_UNLOCK(kvm);
-- 
2.39.0.314.g84b9a713c41-goog

