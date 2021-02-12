Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AEF319782
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 01:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhBLAfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 19:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhBLAe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 19:34:57 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3093BC061786
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 16:34:17 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id u66so5993685qkd.13
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 16:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XKAXpkAK94m0RVh5MFfko19Er9G2ZY3kVKxPG6EQzGU=;
        b=vjd6+zoLspGHBkN7ol8n4f+FjOIp8P2A/+YjMZg6o1//7bbDDw3LDFDWuQI/immX0s
         wXQdgoclJ2QdYDRqMi3zEeojvNCPe92KwX7KJ5fZ9UbzTqofpAt533+Jq84tbqxA4Y8B
         7cAx8qPdmBol9OoS8mgP6KYje4BE3GyGH87kFGokeMMb9OMtHyitSynWP52CX/MfFPg0
         5FeR/97QZf5daWhIOf+ZGCcWY5AoRPBzosRmBzWMEybSvVapSutS5FPHl8Y5y4Ve2klP
         dbrBNWf9g/wX4XGBcPOyHaVcSghSWi0fzrrKW2AtWRpDtzQ2zmMphIE52u6VDOM/+spw
         QT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XKAXpkAK94m0RVh5MFfko19Er9G2ZY3kVKxPG6EQzGU=;
        b=Ko+/7yCOZ7H1pF4p26D7dVGG07E7EW/4G/zqgiCnt+DsiPQ4O/+r9obZoCG27Mpmz8
         jgcGpLKa/JZqJvYx+iA9WOG30MVrzskkiIGDKz3UT5HQASXn1niRCW28kJCozXrNeChG
         FKPU2kpYtbCFgnALvY6FOk8P66Ql6/NQ1Qx1Dc6NvSQMM1UppyAR8/67aygRrI1wDNP/
         tWabNcf4/PrC15GwlkojezYiHpZUMcAclqYUf84Fxmo8wAji1QoKMzD8MMB41TXilrdR
         JDyyecKcWgHLlaJ/6F8Tr31suumDrbLqJ73iV5LBzF3fhar+eYMHRAc0Y48OM6OGbZte
         ENSQ==
X-Gm-Message-State: AOAM533Wo6vI9VJg+mMhmXpG9jo9nZEZRj2VUwx/GUTsgPn1EFQB1RL2
        1Bzw0K9LQpn2xa479T8zX8hp4h91GlE=
X-Google-Smtp-Source: ABdhPJzam5xHM6CKpgswhd+0Z76z2ZKGfRhz/IAvdhuId1g4omPd3547ZhuvaFerJAKBULuhxD/8NzglLrk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f588:a708:f347:3ebb])
 (user=seanjc job=sendgmr) by 2002:a0c:f589:: with SMTP id k9mr552818qvm.0.1613090056322;
 Thu, 11 Feb 2021 16:34:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Feb 2021 16:34:09 -0800
In-Reply-To: <20210212003411.1102677-1-seanjc@google.com>
Message-Id: <20210212003411.1102677-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210212003411.1102677-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 1/3] KVM: SVM: Intercept INVPCID when it's disabled to inject #UD
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intercept INVPCID if it's disabled in the guest, even when using NPT,
as KVM needs to inject #UD in this case.

Fixes: 4407a797e941 ("KVM: SVM: Enable INVPCID feature on AMD")
Cc: Babu Moger <babu.moger@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 42d4710074a6..ca9706c2f99b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1103,12 +1103,12 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 static void svm_check_invpcid(struct vcpu_svm *svm)
 {
 	/*
-	 * Intercept INVPCID instruction only if shadow page table is
-	 * enabled. Interception is not required with nested page table
-	 * enabled.
+	 * Intercept INVPCID if shadow paging is enabled to sync/free shadow
+	 * roots, or if INVPCID is disabled in the guest to inject #UD.
 	 */
 	if (kvm_cpu_cap_has(X86_FEATURE_INVPCID)) {
-		if (!npt_enabled)
+		if (!npt_enabled ||
+		    !guest_cpuid_has(&svm->vcpu, X86_FEATURE_INVPCID))
 			svm_set_intercept(svm, INTERCEPT_INVPCID);
 		else
 			svm_clr_intercept(svm, INTERCEPT_INVPCID);
-- 
2.30.0.478.g8a0d178c01-goog

