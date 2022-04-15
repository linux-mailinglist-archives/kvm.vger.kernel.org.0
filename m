Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D84A50285F
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 12:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352349AbiDOKgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 06:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbiDOKgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 06:36:01 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF7FBB937;
        Fri, 15 Apr 2022 03:33:33 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so11504891pjn.3;
        Fri, 15 Apr 2022 03:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ezEtL5bvt05tXHZVD12zoN40Q/XitW4u7m2uAKoV0Ig=;
        b=kvV03nNeNBLEM4a3thFBKByQD9lbBfbWEyTVDGlvZOMz7uMRhjBsRIkwDjkRNg7y3s
         ulov+dkpcFkGZSz/HuMmvHhjyUzCDtORt38gazYmllRIaB4KtHL0uGfhv6D4RTxZAdB6
         gf9Bj3KS5BndKxExKiIVM8d6h4n5mWfiO10ES2x3QWvqY4YOKTX8o/UwAg3edGlusvWW
         UezduJdO7Sqyj7GWIQbF2aUrO6fIlBEuwQiDkUWWxOAB3vFroagnSzxB7vM3fGZgpslF
         ypD7XLafhFhQkuaY56YlVkEjndLWx01xxr1D3UdSvA68HauIIVs3QOB1HVgSSlNJhDDd
         iS/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ezEtL5bvt05tXHZVD12zoN40Q/XitW4u7m2uAKoV0Ig=;
        b=u2/VWpQiHxh35B6YcUEGkZGFifb2JFpVXlICvQTFQpS+8C12Jpw+xzwTs/Xw6n3spZ
         BLgW72biznW4uMk6oTiEMWn3PO4P6mSBy++OcDHqL8pe02NRPxPYbDwqJWrsCbn+5SQn
         bHJNuk1zVIVBPwkGIAnrCG0H/thxv615QQQbLkinQj/5fIGIeK3QyxOIxUe2zAxER5mz
         MiCryVnZXFZzSh3E6GpTyyHkrUny6D4Sq0BKNxlLcFpAp9MVOzoc3r+mWAnzCplJEEYj
         Gb+FEAzagkCew6XTwzm5wDY7ipz3BPTPg8MdyrGbyM57YJcZvVp5X+0HxFFfbKl5N+OU
         kHkg==
X-Gm-Message-State: AOAM532wNEvauahmRnijSOz3K60HhLAwMOk6VadKEkGgEV/FapnqS2oc
        byUbYg489PcwmCBCBrWEYtty7dyu7ic=
X-Google-Smtp-Source: ABdhPJzpdX+fbMCDNeOmyjII2ZtBj+iOKzhgPwEeJIcOpajiZN8hwIjofXqoV0EydOlumprf19F1bA==
X-Received: by 2002:a17:90a:9109:b0:1cb:a814:8947 with SMTP id k9-20020a17090a910900b001cba8148947mr3442090pjo.52.1650018813248;
        Fri, 15 Apr 2022 03:33:33 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id pi2-20020a17090b1e4200b001c7b15928e0sm8759334pjb.23.2022.04.15.03.33.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Apr 2022 03:33:32 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] kvm: x86/svm/nested: Cache PDPTEs for nested NPT in PAE paging mode
Date:   Fri, 15 Apr 2022 18:34:14 +0800
Message-Id: <20220415103414.86555-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

When NPT enabled L1 is PAE paging, vcpu->arch.mmu->get_pdptrs() which
is nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE from memroy
unconditionally for each call.

The guest PAE root page is not write-protected.

The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get different
values every time or it is different from the return value of
mmu->get_pdptrs() in mmu_alloc_shadow_roots().

And it will cause FNAME(fetch) installs the spte in a wrong sp
or links a sp to a wrong parent since FNAME(gpte_changed) can't
check these kind of changes.

Cache the PDPTEs and the problem is resolved.  The guest is responsible
to info the host if its PAE root page is updated which will cause
nested vmexit and the host updates the cache when next nested run.

The commit e4e517b4be01 ("KVM: MMU: Do not unconditionally read PDPTE
from guest memory") fixs the same problem for non-nested case.

Fixes: e4e517b4be01 ("KVM: MMU: Do not unconditionally read PDPTE from guest memory")
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/svm/nested.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d736ec6514ca..a34983d2dc07 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -72,18 +72,22 @@ static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_excep
        }
 }
 
-static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
+static void nested_svm_cache_tdp_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 cr3 = svm->nested.ctl.nested_cr3;
-	u64 pdpte;
+	u64 *pdptrs = vcpu->arch.mmu->pdptrs;
 	int ret;
 
-	ret = kvm_vcpu_read_guest_page(vcpu, gpa_to_gfn(cr3), &pdpte,
-				       offset_in_page(cr3) + index * 8, 8);
+	ret = kvm_vcpu_read_guest_page(vcpu, gpa_to_gfn(cr3), pdptrs,
+				       offset_in_page(cr3), 8 * 4);
 	if (ret)
-		return 0;
-	return pdpte;
+		memset(pdptrs, 0, 8 * 4);
+}
+
+static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
+{
+	return vcpu->arch.mmu->pdptrs[index];
 }
 
 static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
@@ -109,6 +113,8 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, svm->vmcb01.ptr->save.cr4,
 				svm->vmcb01.ptr->save.efer,
 				svm->nested.ctl.nested_cr3);
+	if (vcpu->arch.mmu->root_level == PT32E_ROOT_LEVEL)
+		nested_svm_cache_tdp_pdptrs(vcpu);
 	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
 	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
 	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
-- 
2.19.1.6.gb485710b

