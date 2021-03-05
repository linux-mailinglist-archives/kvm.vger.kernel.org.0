Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D17432F298
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhCESbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhCESbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:41 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC68EC061756
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:40 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id k4so2341561qtd.20
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=QDgGIBKwEx0IcrZDmaovjYwei3TYW6SVG8g5soBde6c=;
        b=Y9E9rvso32rvxg65Z/hGLo9l2wp4yjO0ntQNV0P9/UGS6t6R3CyPnr85JRrrAgE9Eh
         PVMnt6GqL4jnmhArsOaxazCprp8wVxqf7e7yJX8CDRs29EGlQ/Zb1q5qs+owWMvCCM8n
         LVHK7W/DazTg3RpQ/ABsq5BOa+OJXIh6VCRO5+4PAiERZLjYx34nY58s62oNTH/aF8Bt
         UDivVUnKgy4PNaLzv+3VB8qjocaS7aVeKqwwEA00l89QD0pV/kbW2cWQ0UIw6AahSlMj
         gylyPaYlWxEkqAS5RHKkHcjv3sL0KQ8Zo+lSpw4uiK0rQXnObI6vs+m5kc0ZX+AqCIHB
         4WFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=QDgGIBKwEx0IcrZDmaovjYwei3TYW6SVG8g5soBde6c=;
        b=KL4mP0ESqBChJtZS63QT6fIfC6ynnCaYzR87tyS7DncjGxu9pc4HXiLAYT6gShqPZ6
         J/be0Vh9HibbZMpMnhATBtASRlPcM4fIEimsaqCRQVRMNwB/vyHpRe6WyG0F2zjGZPhU
         I0bOzTh0HZRpWzfz5UcqMv05z3wTy7AEj2EMyKcZVl9jFwDdg/L2ujFRqXdpAum8Djeq
         hUUb/xvI3u+e5utBPPKUs4rj5sz2lEzNPwl75mBM+cyfxicstxyc4KbpIrt4h3K/M0xc
         muaUOl5DdLcKB+JaGn+ASDs309My0aLk5SPRjPUpOwx5WjfFTmFp208yMmQcOPM72SbH
         dE+g==
X-Gm-Message-State: AOAM532nxfiGtjgxpvhHjoZMb2U3kbJC/BREm+DsVRkMhIh2w9z231EL
        +7oNZDyeDCD62TjKyCeMpb6tAoah5Uk=
X-Google-Smtp-Source: ABdhPJzIJ+98kwAqBiAVXJfxBB5p9HFDc8EdbKKTCNa1dh86kF2JNkLJNmkA+2iJJGRxAPZa7/e0wdXtCrI=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a0c:a819:: with SMTP id w25mr10035806qva.6.1614969100131;
 Fri, 05 Mar 2021 10:31:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:17 -0800
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Message-Id: <20210305183123.3978098-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210305183123.3978098-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 05/11] KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP
 hasn't been flushed
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

Combine the for-loops for Hyper-V TLB EPTP checking and flushing, and in
doing so skip flushes for vCPUs whose EPTP matches the target EPTP.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a1c7ba0918e7..a1a5b411c903 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -505,33 +505,26 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 
 	spin_lock(&kvm_vmx->ept_pointer_lock);
 
-	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK) {
+	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
 		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
 		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
 
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			tmp_eptp = to_vmx(vcpu)->ept_pointer;
-			if (!VALID_PAGE(tmp_eptp))
+			if (!VALID_PAGE(tmp_eptp) ||
+			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
 				continue;
 
-			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
 				kvm_vmx->hv_tlb_eptp = tmp_eptp;
-			} else if (kvm_vmx->hv_tlb_eptp != tmp_eptp) {
-				kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+			else
 				kvm_vmx->ept_pointers_match
 					= EPT_POINTERS_MISMATCH;
-				break;
-			}
-		}
-	}
 
-	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			/* If ept_pointer is invalid pointer, bypass flush request. */
-			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
-				ret |= hv_remote_flush_eptp(to_vmx(vcpu)->ept_pointer,
-							    range);
+			ret |= hv_remote_flush_eptp(tmp_eptp, range);
 		}
+		if (kvm_vmx->ept_pointers_match == EPT_POINTERS_MISMATCH)
+			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
 	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
 		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
 	}
-- 
2.30.1.766.gb4fecdf3b7-goog

