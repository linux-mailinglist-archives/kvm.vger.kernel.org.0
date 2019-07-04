Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93495F5A5
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 11:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfGDJdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 05:33:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36082 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbfGDJdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 05:33:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id u8so5355984wmm.1;
        Thu, 04 Jul 2019 02:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AAP+l5ZYjiv99u8XkYPsmGOOVzLMqsyBpq5uEbkrk2k=;
        b=qQhkciMJU3XUyEGQghn/2f9cX+pCtDJqNLJY4FMZUEFeRWTKN4XLRADbBNe8khWbon
         pa1xv4rB+i1WiqUQbP2d4bsGwi7e0b9HHlO26I2iiiq2c6qLUeirR7/QuWgM3qBnB4hi
         5oPj6UCYq1u5Syu9gzTm+l2jBO44z4kqs8mpvOq/SveGpJ4z4ZhghhzJDd3Y1kPn2v2n
         r9oLiERdFJrGQ54hZRbuMsVya++rfssmeMpYOISuA4g6DYclcYD+SpNL4A/Rp8MzgUon
         OMdC0lbxALk0oN2Otgx+J+88rXdZshCcgUSGiEAO/rRnXrIhwEZSJnhPYFqu3ZOwW3xe
         zVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=AAP+l5ZYjiv99u8XkYPsmGOOVzLMqsyBpq5uEbkrk2k=;
        b=E9HEZCOPF4oSTyHrFYIaseYKxhTrBN8yhjN5dEYbi68Maf+PMw/WG1TtGjPPSO6171
         jKVNegDKbHSCH5a7ZFzzAUuyZAuC1NYCC6FvoRADYR1u6zcCWEzQVwcO+Nkhg2vjri/5
         aOrDvXQ3NDh/fnIAj3T6rEsu2hMMF7PTjdtTC1EsooYQQniVMshIvBPwcajHxMoBEQcB
         UKG4oMZfAy74HPOZyvV+RV21aI1Ifk3oAPQvdUS8YUYqnN4ONTKy65FK/qsmzb9sJzKy
         6UwAyrk6xw9xiFwt0LtqJP2rRBSZY7LHs76DDhms58wBuVZqdkoybS9uYs3bBF6+ErM3
         i67Q==
X-Gm-Message-State: APjAAAUk3C4JIAecHa513SAxl0b2T1WrzGmshyBGI12z/Jg/I4GD/T6o
        jyu95DF5ulcjMd1adAHzXoMxYICi4Pc=
X-Google-Smtp-Source: APXvYqzQ4eujUFDh/qqGTsFCS9v3qG2mW1UH0Y6v59X45M0DNSnELQ8/Lw/snOYIB4HXu1kgDbMnqQ==
X-Received: by 2002:a1c:1a87:: with SMTP id a129mr3073417wma.21.1562232779393;
        Thu, 04 Jul 2019 02:32:59 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id m9sm4868320wrn.92.2019.07.04.02.32.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 02:32:58 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH 1/5] kvm: x86: Do not release the page inside mmu_set_spte()
Date:   Thu,  4 Jul 2019 11:32:52 +0200
Message-Id: <20190704093256.12989-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704093256.12989-1-pbonzini@redhat.com>
References: <20190704093256.12989-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

Release the page at the call-site where it was originally acquired.
This makes the exit code cleaner for most call sites, since they
do not need to duplicate code between success and the failure
label.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c         | 18 +++++++-----------
 arch/x86/kvm/paging_tmpl.h |  8 +++-----
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 771349e72d2a..6fc5c389f5a1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3095,8 +3095,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
 		}
 	}
 
-	kvm_release_pfn_clean(pfn);
-
 	return ret;
 }
 
@@ -3131,9 +3129,11 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	if (ret <= 0)
 		return -1;
 
-	for (i = 0; i < ret; i++, gfn++, start++)
+	for (i = 0; i < ret; i++, gfn++, start++) {
 		mmu_set_spte(vcpu, start, access, 0, sp->role.level, gfn,
 			     page_to_pfn(pages[i]), true, true);
+		put_page(pages[i]);
+	}
 
 	return 0;
 }
@@ -3530,6 +3530,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 	if (handle_abnormal_pfn(vcpu, v, gfn, pfn, ACC_ALL, &r))
 		return r;
 
+	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
@@ -3538,14 +3539,11 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, write, map_writable, level, gfn, pfn, prefault);
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	return r;
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
-	return RET_PF_RETRY;
+	return r;
 }
 
 static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
@@ -4159,6 +4157,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	if (handle_abnormal_pfn(vcpu, 0, gfn, pfn, ACC_ALL, &r))
 		return r;
 
+	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
@@ -4167,14 +4166,11 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, write, map_writable, level, gfn, pfn, prefault);
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	return r;
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
-	return RET_PF_RETRY;
+	return r;
 }
 
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 367a47df4ba0..2db96401178e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -543,6 +543,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	mmu_set_spte(vcpu, spte, pte_access, 0, PT_PAGE_TABLE_LEVEL, gfn, pfn,
 		     true, true);
 
+	kvm_release_pfn_clean(pfn);
 	return true;
 }
 
@@ -694,7 +695,6 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	return ret;
 
 out_gpte_changed:
-	kvm_release_pfn_clean(pfn);
 	return RET_PF_RETRY;
 }
 
@@ -842,6 +842,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 			walker.pte_access &= ~ACC_EXEC_MASK;
 	}
 
+	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
@@ -855,14 +856,11 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 			 level, pfn, map_writable, prefault);
 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	return r;
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
-	return RET_PF_RETRY;
+	return r;
 }
 
 static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
-- 
2.21.0


