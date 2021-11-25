Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD97B45D2BF
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353120AbhKYCDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353040AbhKYCBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:09 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FA6C0619E0
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:41 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id t7-20020a17090a5d8700b001a7604b85f5so1682206pji.8
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=v4lffraMzakIdUiTUukcwzgD1wcKcn9HDk9YIkDpKuA=;
        b=nsZzb1Ko+tOGE5el9hs7vSZuAwHG9Sc9M4Q2uh1dJV51Jd14MXKzVTvL7NAwV4zNj4
         XFQuiYcRyt19AtD9LTwJngX4WzIFenYDPBdbu4kH9FmzQMRGLh7QeLZCiw+qDGi57zja
         vDib+2lez6Yfrenfh9XTqSkSaXy15gJ8S4QJTDJ19+w5CI2tttgLO7GSOfAjASANChue
         cn1n/doGsU19fu9gPAw0J5IoJiawO0V/iyDZbdYEVooSW5om7BMZ22Bxym2FrNDjetb+
         Zj7taGHwm1Xso3AQMUu4IKXBPGemTRN+ldJcd6G5/e4V4ikGnNw/mO9nse44ABBHffrs
         wcbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=v4lffraMzakIdUiTUukcwzgD1wcKcn9HDk9YIkDpKuA=;
        b=LgCDsYlSTyBJJYhOMZ8MaPhzRbKqNmJXNf+6x/rTK4tL9ufWg4wA/QIVTdaA8IFVYz
         sj36kKGr+JAozRBS4GSS1oF3ThAjioxQg3A2xI1ul2Ygw+roRzjfkI3pOZqoiyS112fF
         NyOo/6pnAPb4PZMhKYTK0REcOymKXkCT4nogG2A9Yok8dKxDbqG+UfomXGTIyaT7zsHh
         pCVP7blT3MepThDlD1hcuRLmLWWt3KXa2V2Aqj+LUHxt0T8476LYaKjclrqgEewsjbZb
         7sin2T0Wp9I11BuJX9CWMP8hhcTS6PXBfW07xXlzc6W6NENLj2VjzG5qAHtbm+J0mZdQ
         xOfQ==
X-Gm-Message-State: AOAM5303GiDZCDs9PMaYH/wdkhSuz7m+2VlyxEMTQ4+G5WG8k8Ot8Vab
        ThD75wFvOCWiW7svcOhU72qHIkYIMUI=
X-Google-Smtp-Source: ABdhPJwG5Cod1uLmUvTdqOJHKw74OiaZ5Bj4Fv6yqa9MIPbMgTuWFYWyZJkd1Ca6tjHdiWVhqGhcrd1Ywwg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:117:: with SMTP id 23mr13923722pgb.183.1637803780682;
 Wed, 24 Nov 2021 17:29:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:43 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-26-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 25/39] nVMX: Drop less-than-useless ept_sync() wrapper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop ept_sync(), it's nothing more than a wrapper to invept() with
open-coded "assertions" that the desired flavor of INVEPT is supported.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c       | 21 ---------------------
 x86/vmx.h       |  1 -
 x86/vmx_tests.c | 26 +++++++++++++-------------
 3 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 7a2f7a3..554cc74 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1144,27 +1144,6 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
 	       !!(expected_gpa_ad & EPT_DIRTY_FLAG));
 }
 
-
-void ept_sync(int type, u64 eptp)
-{
-	switch (type) {
-	case INVEPT_SINGLE:
-		if (ept_vpid.val & EPT_CAP_INVEPT_SINGLE) {
-			invept(INVEPT_SINGLE, eptp);
-			break;
-		}
-		/* else fall through */
-	case INVEPT_GLOBAL:
-		if (ept_vpid.val & EPT_CAP_INVEPT_ALL) {
-			invept(INVEPT_GLOBAL, eptp);
-			break;
-		}
-		/* else fall through */
-	default:
-		printf("WARNING: invept is not supported!\n");
-	}
-}
-
 void set_ept_pte(unsigned long *pml4, unsigned long guest_addr,
 		 int level, u64 pte_val)
 {
diff --git a/x86/vmx.h b/x86/vmx.h
index 28e28f1..0212ca6 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -953,7 +953,6 @@ int init_vmcs(struct vmcs **vmcs);
 const char *exit_reason_description(u64 reason);
 void print_vmexit_info(union exit_reason exit_reason);
 void print_vmentry_failure_info(struct vmentry_result *result);
-void ept_sync(int type, u64 eptp);
 void vpid_sync(int type, u16 vpid);
 void install_ept_entry(unsigned long *pml4, int pte_level,
 		unsigned long guest_addr, unsigned long pte,
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0df69ee..78a53e1 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1335,7 +1335,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page1);
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page2);
 			if (have_ad)
-				ept_sync(INVEPT_SINGLE, eptp);;
+				invept(INVEPT_SINGLE, eptp);
 			if (*((u32 *)data_page1) == MAGIC_VAL_3 &&
 					*((u32 *)data_page2) == MAGIC_VAL_2) {
 				vmx_inc_test_stage();
@@ -1348,14 +1348,14 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 		case 1:
 			install_ept(pml4, (unsigned long)data_page1,
  				(unsigned long)data_page1, EPT_WA);
-			ept_sync(INVEPT_SINGLE, eptp);
+			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 2:
 			install_ept(pml4, (unsigned long)data_page1,
  				(unsigned long)data_page1,
  				EPT_RA | EPT_WA | EPT_EA |
  				(2 << EPT_MEM_TYPE_SHIFT));
-			ept_sync(INVEPT_SINGLE, eptp);
+			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 3:
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page1);
@@ -1363,7 +1363,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 						1, &data_page1_pte));
 			set_ept_pte(pml4, (unsigned long)data_page1, 
 				1, data_page1_pte & ~EPT_PRESENT);
-			ept_sync(INVEPT_SINGLE, eptp);
+			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 4:
 			ptep = get_pte_level((pgd_t *)guest_cr3, data_page1, /*level=*/2);
@@ -1372,12 +1372,12 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			TEST_ASSERT(get_ept_pte(pml4, guest_pte_addr, 2, &data_page1_pte_pte));
 			set_ept_pte(pml4, guest_pte_addr, 2,
 				data_page1_pte_pte & ~EPT_PRESENT);
-			ept_sync(INVEPT_SINGLE, eptp);
+			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 5:
 			install_ept(pml4, (unsigned long)pci_physaddr,
 				(unsigned long)pci_physaddr, 0);
-			ept_sync(INVEPT_SINGLE, eptp);
+			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 7:
 			if (!invept_test(0, eptp))
@@ -1400,7 +1400,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			install_ept(pml4, (unsigned long)data_page1,
  				(unsigned long)data_page1,
  				EPT_RA | EPT_WA | EPT_EA);
-			ept_sync(INVEPT_SINGLE, eptp);
+			invept(INVEPT_SINGLE, eptp);
 			break;
 		// Should not reach here
 		default:
@@ -1428,7 +1428,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 				vmx_inc_test_stage();
 			set_ept_pte(pml4, (unsigned long)data_page1,
 				1, data_page1_pte | (EPT_PRESENT));
-			ept_sync(INVEPT_SINGLE, eptp);
+			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 4:
 			check_ept_ad(pml4, guest_cr3, (unsigned long)data_page1, 0,
@@ -1440,7 +1440,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 				vmx_inc_test_stage();
 			set_ept_pte(pml4, guest_pte_addr, 2,
 				data_page1_pte_pte | (EPT_PRESENT));
-			ept_sync(INVEPT_SINGLE, eptp);
+			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 5:
 			if (exit_qual & EPT_VLT_RD)
@@ -1448,7 +1448,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			TEST_ASSERT(get_ept_pte(pml4, (unsigned long)pci_physaddr,
 						1, &memaddr_pte));
 			set_ept_pte(pml4, memaddr_pte, 1, memaddr_pte | EPT_RA);
-			ept_sync(INVEPT_SINGLE, eptp);
+			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 6:
 			if (exit_qual & EPT_VLT_WR)
@@ -1456,7 +1456,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			TEST_ASSERT(get_ept_pte(pml4, (unsigned long)pci_physaddr,
 						1, &memaddr_pte));
 			set_ept_pte(pml4, memaddr_pte, 1, memaddr_pte | EPT_RA | EPT_WA);
-			ept_sync(INVEPT_SINGLE, eptp);
+			invept(INVEPT_SINGLE, eptp);
 			break;
 		default:
 			// Should not reach here
@@ -2483,7 +2483,7 @@ static unsigned long ept_twiddle(unsigned long gpa, bool mkhuge, int level,
 		pte = orig_pte;
 	pte = (pte & ~clear) | set;
 	set_ept_pte(pml4, gpa, level, pte);
-	ept_sync(INVEPT_SINGLE, eptp);
+	invept(INVEPT_SINGLE, eptp);
 
 	return orig_pte;
 }
@@ -2491,7 +2491,7 @@ static unsigned long ept_twiddle(unsigned long gpa, bool mkhuge, int level,
 static void ept_untwiddle(unsigned long gpa, int level, unsigned long orig_pte)
 {
 	set_ept_pte(pml4, gpa, level, orig_pte);
-	ept_sync(INVEPT_SINGLE, eptp);
+	invept(INVEPT_SINGLE, eptp);
 }
 
 static void do_ept_violation(bool leaf, enum ept_access_op op,
-- 
2.34.0.rc2.393.gf8c9666880-goog

