Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EFA372EBF
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhEDRT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbhEDRTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:19:10 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89864C06134B
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:18:11 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id d15-20020a05620a136fb02902e9e93c69c8so4024663qkl.23
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EJVLUy9Wu1XMVquYiQb1OEBFSqdA144hYS1qNH/p6ok=;
        b=GaRByPbJVmtgHWnYspoS8Dyjsh95eo63qw5bARG4QFcCgvqBFPaPZgkMwhIudspGV3
         XxsQJfbuP47evZwpOW+90yLQ54UiDMP0KpyTMEay5IS3EmorT3z2HvoZ8/5HY+58ZT7D
         kJ1Q9SUEAN74G/9VOxqFRd6SHA+CU6zjz/rfMNmqlbPWQ3VkFDZQnYgRzUciw+sZiZRW
         QFVzh75tN13ns60wE+2IufukKRoZ2SteQiTMAvH8QOhuRZ86Q7W4fN6vNVaPCs6TWYY+
         gDXEUjdS1PRaApRNuzzRf8V8/kPKZjXAdFlxHvSdFGggSKInJtBXv+eGNm05UHzp+n+t
         TkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EJVLUy9Wu1XMVquYiQb1OEBFSqdA144hYS1qNH/p6ok=;
        b=IzaIvDToHjFz6iXncEYyBHxEk7cwA3wWQYeUeLHWbD7QHB/SOloxrP70qhBjEt3PVl
         rW2E9AQRhTDj6DBEOktJXQvHCpYEogatpdNkaPlodb0uDwU9YiK2iriWhfsi4LSfa6sI
         QwaEeQuqUtUXYMLxnEfo4rO7nqa9hfYUR8IsNs135CcI12vNfFIJWAwGu2QsTQ0zUMIi
         2zgWmgXp4sLiUJj4uq6/uF1SnjbgXByrGodcgBStjhlRcQfp06NEUgVbHPCpQfeDTbDL
         oqOQLH9F64uapzQTlWhqSxFQWs5SDcqYH8X4pyNzYsLb/fsUTWrW7k7jZGGXPGM0Slb8
         xNMg==
X-Gm-Message-State: AOAM530wAMV8X4NQyqNMxdjTR1DS9qwAMkHbBaHQSa5AGGLee2ht3lk/
        hJeemAjga4afFHff/Nw8hDzZU95UUXE=
X-Google-Smtp-Source: ABdhPJyhVg/bmFC4ZCuJps+AFIdNNG3bxydLRShSlFwsS1FMASCi+Phzl7sFcSPLPYREl0r4GH/DbMxTvP4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a0c:e486:: with SMTP id n6mr24367135qvl.21.1620148690729;
 Tue, 04 May 2021 10:18:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:31 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 12/15] KVM: x86: Export the number of uret MSRs to vendor modules
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split out and export the number of configured user return MSRs so that
VMX can iterate over the set of MSRs without having to do its own tracking.
Keep the list itself internal to x86 so that vendor code still has to go
through the "official" APIs to add/modify entries.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 29 +++++++++++++----------------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c9452472ed55..10663610f105 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1419,6 +1419,7 @@ struct kvm_arch_async_pf {
 	bool direct_map;
 };
 
+extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern struct kvm_x86_ops kvm_x86_ops;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 90ef340565a4..2fd46e917666 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -184,11 +184,6 @@ module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
  */
 #define KVM_MAX_NR_USER_RETURN_MSRS 16
 
-struct kvm_user_return_msrs_global {
-	int nr;
-	u32 msrs[KVM_MAX_NR_USER_RETURN_MSRS];
-};
-
 struct kvm_user_return_msrs {
 	struct user_return_notifier urn;
 	bool registered;
@@ -198,7 +193,9 @@ struct kvm_user_return_msrs {
 	} values[KVM_MAX_NR_USER_RETURN_MSRS];
 };
 
-static struct kvm_user_return_msrs_global __read_mostly user_return_msrs_global;
+u32 __read_mostly kvm_nr_uret_msrs;
+EXPORT_SYMBOL_GPL(kvm_nr_uret_msrs);
+static u32 __read_mostly kvm_uret_msrs_list[KVM_MAX_NR_USER_RETURN_MSRS];
 static struct kvm_user_return_msrs __percpu *user_return_msrs;
 
 #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
@@ -330,10 +327,10 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 		user_return_notifier_unregister(urn);
 	}
 	local_irq_restore(flags);
-	for (slot = 0; slot < user_return_msrs_global.nr; ++slot) {
+	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
 		values = &msrs->values[slot];
 		if (values->host != values->curr) {
-			wrmsrl(user_return_msrs_global.msrs[slot], values->host);
+			wrmsrl(kvm_uret_msrs_list[slot], values->host);
 			values->curr = values->host;
 		}
 	}
@@ -358,9 +355,9 @@ EXPORT_SYMBOL_GPL(kvm_probe_user_return_msr);
 void kvm_define_user_return_msr(unsigned slot, u32 msr)
 {
 	BUG_ON(slot >= KVM_MAX_NR_USER_RETURN_MSRS);
-	user_return_msrs_global.msrs[slot] = msr;
-	if (slot >= user_return_msrs_global.nr)
-		user_return_msrs_global.nr = slot + 1;
+	kvm_uret_msrs_list[slot] = msr;
+	if (slot >= kvm_nr_uret_msrs)
+		kvm_nr_uret_msrs = slot + 1;
 }
 EXPORT_SYMBOL_GPL(kvm_define_user_return_msr);
 
@@ -368,8 +365,8 @@ int kvm_find_user_return_msr(u32 msr)
 {
 	int i;
 
-	for (i = 0; i < user_return_msrs_global.nr; ++i) {
-		if (user_return_msrs_global.msrs[i] == msr)
+	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
+		if (kvm_uret_msrs_list[i] == msr)
 			return i;
 	}
 	return -1;
@@ -383,8 +380,8 @@ static void kvm_user_return_msr_cpu_online(void)
 	u64 value;
 	int i;
 
-	for (i = 0; i < user_return_msrs_global.nr; ++i) {
-		rdmsrl_safe(user_return_msrs_global.msrs[i], &value);
+	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
+		rdmsrl_safe(kvm_uret_msrs_list[i], &value);
 		msrs->values[i].host = value;
 		msrs->values[i].curr = value;
 	}
@@ -399,7 +396,7 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 	value = (value & mask) | (msrs->values[slot].host & ~mask);
 	if (value == msrs->values[slot].curr)
 		return 0;
-	err = wrmsrl_safe(user_return_msrs_global.msrs[slot], value);
+	err = wrmsrl_safe(kvm_uret_msrs_list[slot], value);
 	if (err)
 		return 1;
 
-- 
2.31.1.527.g47e6f16901-goog

