Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC8664A428
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 16:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiLLPbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 10:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiLLPbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 10:31:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE19CFCFF;
        Mon, 12 Dec 2022 07:31:04 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so148885pjo.3;
        Mon, 12 Dec 2022 07:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmyZB7P+T7cldWqjuRT6Y6vUTkEvSfVPUCpeMf28+1M=;
        b=AJ45vMDiLsDYC0RGs8ey/ELAXs1CCXKzolW+nCXoW6DuKV5tPfmB2l3CyrBXA3/93U
         3d6O8be+Sz1gg0Lzo4hGPAWY/HGiXJ0OX6QHboSQFyZmVr/Iim+X/1JTMDoJE1J9lQjr
         g8hIUb+vXQ4CMD6fImvPp3fMGzSIi963oKLr+IprrFytd56NhpoJQ28Sk0J0YHGim1/B
         hwc1FN+QV0Ka3J73gqAL5bybDJ/ZwrkauKS/Kf2SnnzMD+8uP/2Znek+kQgfyKjbfbDM
         l1mavjbYTuhYWg07jQ8+D0mC2yJ1QBXEmCGr2/+mFWQWc1u5KHoFr4yTR8jLl7lr+Nyq
         Uz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WmyZB7P+T7cldWqjuRT6Y6vUTkEvSfVPUCpeMf28+1M=;
        b=Y8xEOb/BSqcQTdOdLSRiETYuQkYxCl8qc/mPkAmfL6HRf6UmN1jiCpZXAACowseNgK
         vH18pSepnS2om2vFOEBsLjCXz8qP3scXRT9m2sjUvo6hPWWm4ve2heq0JQRSNx/BzdV6
         IJ879NZi4dDnTiyJoGbgIWAkl19h0oa2Rdic1PPELwKw3VCwiMHvA/DVP+xgNyghNGK+
         dxvFzdOuKpxik2EC2VZnZJYejMGwEebYKYrYqdqNWhYVo6gSM5Bzm8kdIauvQf8SF+01
         GU3g9+eeBlvGgBiiDNeV9CZJ61tzqlhcT0zhUbq041QrGSy1HlTj68uAGgGdAnA1hdlp
         v67w==
X-Gm-Message-State: ANoB5pmwnnOCrfGBv/TrLIkmO6DqKzBao5gCX84fNwuBUEm/Piw/HUHA
        MqvaRI3PDpuSLyYy9/N4VlrYYNXUjug=
X-Google-Smtp-Source: AA0mqf6gKkbKbbH/jTJUCwXcd1Jr8sG1yjfFTgllpsvvmhHgIvavOXlkIfGqCvY4lYIBvfx47grGmw==
X-Received: by 2002:a17:903:2112:b0:189:e711:170 with SMTP id o18-20020a170903211200b00189e7110170mr15330874ple.64.1670859063909;
        Mon, 12 Dec 2022 07:31:03 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902d50400b0017f73caf588sm6538974plg.218.2022.12.12.07.31.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Dec 2022 07:31:03 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH 1/2] kvm: x86/mmu: Reduce the update to the spte in FNAME(sync_page)
Date:   Mon, 12 Dec 2022 23:32:04 +0800
Message-Id: <20221212153205.3360-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221212153205.3360-1-jiangshanlai@gmail.com>
References: <20221212153205.3360-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Sometimes when the guest updates its pagetable, it adds only new gptes
to it without changing any existed one, so there is no point to update
the sptes for these existed gptes.

Also when the sptes for these unchanged gptes are updated, the AD
bits are also removed since make_spte() is called with prefetch=true
which might result unneeded TLB flushing.

Do nothing if the permissions are unchanged or only write-access is
being added.  Only update the spte when write-access is being removed.
Drop the SPTE otherwise.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e5662dbd519c..613f043a3e9e 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1023,7 +1023,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
 		u64 *sptep, spte;
 		struct kvm_memory_slot *slot;
-		unsigned pte_access;
+		unsigned old_pte_access, pte_access;
 		pt_element_t gpte;
 		gpa_t pte_gpa;
 		gfn_t gfn;
@@ -1064,6 +1064,23 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			continue;
 		}
 
+		/*
+		 * Drop the SPTE if the new protections would result in access
+		 * permissions other than write-access is changing.  Do nothing
+		 * if the permissions are unchanged or only write-access is
+		 * being added.  Only update the spte when write-access is being
+		 * removed.
+		 */
+		old_pte_access = kvm_mmu_page_get_access(sp, i);
+		if (old_pte_access == pte_access ||
+		    (old_pte_access | ACC_WRITE_MASK) == pte_access)
+			continue;
+		if (old_pte_access != (pte_access | ACC_WRITE_MASK)) {
+			drop_spte(vcpu->kvm, &sp->spt[i]);
+			flush = true;
+			continue;
+		}
+
 		/* Update the shadowed access bits in case they changed. */
 		kvm_mmu_page_set_access(sp, i, pte_access);
 
-- 
2.19.1.6.gb485710b

