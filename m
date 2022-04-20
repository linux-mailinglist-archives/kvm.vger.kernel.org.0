Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8EB508936
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378992AbiDTN2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378990AbiDTN2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:28:10 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89C03CA5A;
        Wed, 20 Apr 2022 06:25:24 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v12so1773137plv.4;
        Wed, 20 Apr 2022 06:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I4usMyDcj5fWXer18hnDtOwiRS1hL2tNUD9GGuHV+go=;
        b=cmdtINL6FXpxHXfQfHRZIbwBLotN19dA4LLjlmOCALf/zMQjuITpLTXiawmgyFsvlQ
         W/4/AUbJv1VdawN50Rwh+IVaZJywIVucyjGN5915EPn3VrFMOZU+jwcngz2nZuwhh+Li
         XVvk5LhkARHFJOLLEPOLnmxT3rRLfCDSK7sOzEHoUFIhD7IgJ1+eBt62r+lLSSNTuIHH
         7kDKJC0ziGPT5udyBuYAcz87TzOahMprKSCdju81dIIcJcbCmR6bNTE1dzBQrYhHHoHg
         41QdwnSM+ZTF8wILMeiEwrvvPiWjhV5/t+otiaAfKvm3jUCMagGy62fBhN4TreP2RITS
         kBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I4usMyDcj5fWXer18hnDtOwiRS1hL2tNUD9GGuHV+go=;
        b=4tvLWV/fhy9Moyaxr8GahNWV2rE2gUS3kdp0sE2OW92flQ7lIhYkpGAKIRbce4yePw
         Bb8OrxvJiPGp8U3nRzMIRFGfWnLSfYF3PdsGa1VBCFsDITSC3yQj+4uLdJB/bOsU9fbF
         GIGsmU19xvVgTlyoD4V1fAlR2EJXllevh1PcB+CFYMZNAeoNELPhBRakEXf2vrY6N2yH
         wWWyH/VzoIuNRALKqqvmGVkGjfnjd1Rm+5YTJg8arAlmc/73AYUtw57qFPFqV4K4NWCg
         ki04hthafQuUcCH9meP2T/kslq8kENs/q+B5hlyOqn/zfZYBqSzOpMvJCvKdEOcvy5Sk
         R0zw==
X-Gm-Message-State: AOAM533mYAUbb8VzqW4jqcEGNJ3bDKX61F3MPNY8ZFyXdXN8N/hOKLFz
        6cb7wLwVfcbAlXoaWNMA7vDW66xyJBI=
X-Google-Smtp-Source: ABdhPJwqqUVWT/2tEyMlxOREiJfJ1klPI1HgepDxoguLbr2s62rutwySIZyWV07bB4f4mNQGNdB3sQ==
X-Received: by 2002:a17:902:cec4:b0:159:4cf:229d with SMTP id d4-20020a170902cec400b0015904cf229dmr13173171plg.40.1650461123936;
        Wed, 20 Apr 2022 06:25:23 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id a19-20020a62e213000000b005061dd378a1sm19627806pfi.35.2022.04.20.06.25.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:25:23 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/7] KVM: X86/MMU: Add using_special_root_page()
Date:   Wed, 20 Apr 2022 21:25:59 +0800
Message-Id: <20220420132605.3813-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220420132605.3813-1-jiangshanlai@gmail.com>
References: <20220420132605.3813-1-jiangshanlai@gmail.com>
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

In some case, special roots are used in mmu.  It is often using
to_shadow_page(mmu->root.hpa) to check if special roots are used.

Add using_special_root_page() to directly check if special roots are
used or needed to be used even mmu->root.hpa is not set.

Prepare for making to_shadow_page(mmu->root.hpa) return !NULL via
using special shadow pages.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d14cb6f99cb1..6461e499d305 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1714,6 +1714,14 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
+static bool using_special_root_page(struct kvm_mmu *mmu)
+{
+	if (mmu->direct_map)
+		return mmu->shadow_root_level == PT32E_ROOT_LEVEL;
+	else
+		return mmu->root_level <= PT32E_ROOT_LEVEL;
+}
+
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
 {
 	struct kvm_mmu_page *sp;
@@ -4201,10 +4209,10 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
 {
 	/*
 	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
-	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
-	 * later if necessary.
+	 * having to deal with PDPTEs.  Special roots can not be put into
+	 * mmu->prev_root[].
 	 */
-	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
+	if (VALID_PAGE(mmu->root.hpa) && using_special_root_page(mmu))
 		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
 
 	if (VALID_PAGE(mmu->root.hpa))
-- 
2.19.1.6.gb485710b

