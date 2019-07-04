Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5BC5F5A2
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 11:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfGDJdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 05:33:04 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55471 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbfGDJdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 05:33:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so5023745wmj.5;
        Thu, 04 Jul 2019 02:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GnsSV+9plXEtjLhtC/9bXUz2JmmT3CqsIVs8uNZmv1I=;
        b=cuTqmAmuK/WLNpaklW1Hry5yMQ/osBW9iu6tgqYAkEQccQva/F+dktrSK02bZ/1Pun
         rm2JoToVaX00vdT2nRJqwcUumjH9dBdAKDQnkFxqNpqKBjJ49VGQDdszz3L0BIyKtARO
         4qRM2u6Xp2v1QqkHd9K6oLpWS8AbIha9+BLXOmi3FJKkcYPO5ts+8C3OghZuLawADncp
         homuCpb07/CB4UTQNTWmuTEbLTHjlUCwLIdxdEq87kMGl5MtufPe+QA09yM5m6iDO6mo
         cpP+T3xiYYuIWq3DtyfP8db+6A4xBZIycMTnakVpukwk52rffduyxy1xEB+VURNDVzPN
         L4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=GnsSV+9plXEtjLhtC/9bXUz2JmmT3CqsIVs8uNZmv1I=;
        b=tlavYAo32wFHqWRFWzmqKDS63IwdA0osJblMYaDuhcgu1ip+UsWX9OeXOvYiBJp7WI
         rLYH3NJLxGuvF7uxza7iaO6abIC7eACh21uo++bHGwHeKsgT5ITquxtfxCFIn0Jxf0RM
         JTDX6FzzNrSZXNThFVO8tTvdYyK1CBGcra2R0XkEO6sTAVmKRfyFfdhKmLumx2cvpJ5w
         MxW21gFT3YPLxGTr/zSQ4ncUgvmlv/fEZpO32GdSQrivwTiLq7XGoUcnNvW0xynDvwFO
         OaqvhCU0LJSRFhqfYRNN0Ks4Ky2qFVdRJh3YD7fVYaNolQnXaUSpcEw233c1AFdNBhVa
         Uh6Q==
X-Gm-Message-State: APjAAAX2FlL974D5DVZX1BXHl17VC7Ql+hSED7l/Q7rXHjg0NKxxkHeX
        0w6IutlgSGZsd1brK8zUPcGqpJoJi4Y=
X-Google-Smtp-Source: APXvYqzVmSnYyc1kRtQSFv8Pp9YABrf1xxXTEbYHZsAWrld6auAj8sM+VSRLDznQZXSvb6/673n3sw==
X-Received: by 2002:a1c:c542:: with SMTP id v63mr2038342wmf.97.1562232781205;
        Thu, 04 Jul 2019 02:33:01 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id m9sm4868320wrn.92.2019.07.04.02.33.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 02:33:00 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com
Subject: [PATCH 3/5] KVM: x86: remove now unneeded hugepage gfn adjustment
Date:   Thu,  4 Jul 2019 11:32:54 +0200
Message-Id: <20190704093256.12989-4-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704093256.12989-1-pbonzini@redhat.com>
References: <20190704093256.12989-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the previous patch, the low bits of the gfn are masked in
both FNAME(fetch) and __direct_map, so we do not need to clear them
in transparent_hugepage_adjust.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c         | 9 +++------
 arch/x86/kvm/paging_tmpl.h | 2 +-
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index af9dafa54f85..084c1a0d9f98 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3240,11 +3240,10 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 }
 
 static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
-					gfn_t *gfnp, kvm_pfn_t *pfnp,
+					gfn_t gfn, kvm_pfn_t *pfnp,
 					int *levelp)
 {
 	kvm_pfn_t pfn = *pfnp;
-	gfn_t gfn = *gfnp;
 	int level = *levelp;
 
 	/*
@@ -3271,8 +3270,6 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 		mask = KVM_PAGES_PER_HPAGE(level) - 1;
 		VM_BUG_ON((gfn & mask) != (pfn & mask));
 		if (pfn & mask) {
-			gfn &= ~mask;
-			*gfnp = gfn;
 			kvm_release_pfn_clean(pfn);
 			pfn &= ~mask;
 			kvm_get_pfn(pfn);
@@ -3536,7 +3533,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
 	if (likely(!force_pt_level))
-		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
+		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
 	r = __direct_map(vcpu, v, write, map_writable, level, pfn, prefault);
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
@@ -4162,7 +4159,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
 	if (likely(!force_pt_level))
-		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
+		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
 	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn, prefault);
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index bfd89966832b..f39b381a8b88 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -850,7 +850,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
 	if (!force_pt_level)
-		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
+		transparent_hugepage_adjust(vcpu, walker.gfn, &pfn, &level);
 	r = FNAME(fetch)(vcpu, addr, &walker, write_fault,
 			 level, pfn, map_writable, prefault);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
-- 
2.21.0


