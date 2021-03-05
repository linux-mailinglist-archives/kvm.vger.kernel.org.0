Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897B432F299
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhCESbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhCESbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:38 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9799BC061756
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:38 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b127so3353499ybc.13
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4YINoE2f5i/FWyXIMOd2/gI6pVHQ38yw3mdEyw0YPEA=;
        b=lMu7b4dH22Ybw3HJnHv0sZaIAwHMSoQbg6RZEHzU7v9m9bxL18jZXP4/BmAs3p2909
         aNLzfgExkDPjm1/lPx3xqhF8qREngm9n23xqLulPbctAc6Z4uVd/9mgUy+GbPrDX315P
         vU9sba68QLHhUxxM13nuaBkeo1qz5aH1RpTKZp6bs6JKewiGyfH2cR3tI5oYdiIu0dNi
         C3Y7jTvRRIoCnMb/XEmtyGvx/3jqUvrEfOFjycfgyVGGj9tBQormUSpiSRpiyjE8QN7D
         TyJMS4jK/Fb07J9mx1a4BoNHJyTR/hnjUew5zPAiXKVnxer4q0y6AC6OsFd7MFmOr5BJ
         I/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4YINoE2f5i/FWyXIMOd2/gI6pVHQ38yw3mdEyw0YPEA=;
        b=p9RTD0BgmNz5fIg5yMOQrLloMQbzTqlfF2D2vNV4B++BAKzFgTw7rihAA5KMeH+jMZ
         36vHT+sPzlgY9boO0/HOQBprslQrca+gkxzbljiLU5qpCkxnMT6W8ZLgo5HI64splxyT
         GC6z/qrsT4kWL6chDJ0TVbzvSx6XpT3rUSYbpV6ZBLEVUjqEtQ7VY814hFbBcjuzPeoa
         Sbtq0vFb2cYvvKcEJFaPpV4jh6qRhtKnLGO1+FuMaIQy/RvVrR1rzEvHhHBv62VyPK8N
         QOGn2ryLx+UIle8kpPzYkrvD4fYsujAcs/tUieEetwM43F0grq0aSRLRXjQcwIIF84m/
         0nyg==
X-Gm-Message-State: AOAM533x3wXf+Ir/Pv2b1bxH/efGRRe79CNgP8CYhiiP/qQM+ePAFAr3
        nEBBNiok7mY3PlNv/DEeQeY2vD03KNY=
X-Google-Smtp-Source: ABdhPJxuOqghynkRdvEOEwuikdEEE9eOWiqKQQRqyr7JZ7A0yy3dHoyMDl+yh5i4HXQaLgk3EiMPb2iqgTE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:dc85:: with SMTP id y127mr16205853ybe.198.1614969097895;
 Fri, 05 Mar 2021 10:31:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:16 -0800
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Message-Id: <20210305183123.3978098-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210305183123.3978098-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 04/11] KVM: VMX: Fold Hyper-V EPTP checking into it's only caller
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Fold check_ept_pointer_match() into hv_remote_flush_tlb_with_range() in
preparation for combining the kvm_for_each_vcpu loops of the ==CHECK and
!=MATCH statements.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 44 +++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf79fc6c01bb..a1c7ba0918e7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -472,28 +472,6 @@ static const u32 vmx_uret_msrs_list[] = {
 static bool __read_mostly enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
 
-/* check_ept_pointer() should be under protection of ept_pointer_lock. */
-static void check_ept_pointer_match(struct kvm *kvm)
-{
-	struct kvm_vcpu *vcpu;
-	u64 tmp_eptp = INVALID_PAGE;
-	int i;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!VALID_PAGE(tmp_eptp)) {
-			tmp_eptp = to_vmx(vcpu)->ept_pointer;
-		} else if (tmp_eptp != to_vmx(vcpu)->ept_pointer) {
-			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
-			to_kvm_vmx(kvm)->ept_pointers_match
-				= EPT_POINTERS_MISMATCH;
-			return;
-		}
-	}
-
-	to_kvm_vmx(kvm)->hv_tlb_eptp = tmp_eptp;
-	to_kvm_vmx(kvm)->ept_pointers_match = EPT_POINTERS_MATCH;
-}
-
 static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush,
 		void *data)
 {
@@ -523,11 +501,29 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct kvm_vcpu *vcpu;
 	int ret = 0, i;
+	u64 tmp_eptp;
 
 	spin_lock(&kvm_vmx->ept_pointer_lock);
 
-	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK)
-		check_ept_pointer_match(kvm);
+	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK) {
+		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
+		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			tmp_eptp = to_vmx(vcpu)->ept_pointer;
+			if (!VALID_PAGE(tmp_eptp))
+				continue;
+
+			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+				kvm_vmx->hv_tlb_eptp = tmp_eptp;
+			} else if (kvm_vmx->hv_tlb_eptp != tmp_eptp) {
+				kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+				kvm_vmx->ept_pointers_match
+					= EPT_POINTERS_MISMATCH;
+				break;
+			}
+		}
+	}
 
 	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
 		kvm_for_each_vcpu(i, vcpu, kvm) {
-- 
2.30.1.766.gb4fecdf3b7-goog

