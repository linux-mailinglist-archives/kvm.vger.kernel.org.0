Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5777626BF6F
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 10:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgIPIga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 04:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgIPIg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 04:36:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9191CC06174A;
        Wed, 16 Sep 2020 01:36:29 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x123so3547026pfc.7;
        Wed, 16 Sep 2020 01:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KT47zfJmk0l7JghqVT5ZA5rEy8OCXlg/IWMuynysqoI=;
        b=I/nL8EJJEdwYLLDbfZjvs/cqVdyYo5txPiN1xZ7rkpBRmJIrn4u3/Hxb/wjG0rehZ4
         go8mNOFsVCgqGnSnLZmn/UzVoh2xfNa+X3CCDeB3LHXqFStfNJGGepQWWqzMC2fr2SBX
         jFO7fNse+b7YDJPRBTLT5WU5LurvCTxoxZrUBETu8viXtFAGMS2s+tx1ar7I865v/9OA
         UgSE00xU6hImInbi57hnzYOEXHz/pljPeYAgf7t3xjpOnOLjdeuTSo09aMewwx40FzQZ
         kXUm/+RR29oDy8NYBYVxRGgILZWO1Z4grhJrMqZ7/Zkh/+yrNSowDNAPtj/FkJahh6z6
         9fMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KT47zfJmk0l7JghqVT5ZA5rEy8OCXlg/IWMuynysqoI=;
        b=B71yEVDtW3O/UK5BI54ukkkUoAJ+1LUvnn/qWc0cVLx5p2pCEOnZr3iWBIvhWgpURI
         Od9HrDkDCH0t5Vt8VPm1IZXxgTl4Xk1lK/0EbsYjxs1wEUA8oaSKSLlPivhqCX+ZoIAM
         2Fl6vLdHeccVveCRxARZoqjR5QbRjr7QPLqJYfoJsSw0/t2MEhyydswNIIodsIv5aYXP
         BoaNeZ4KDEgDe4meLSC0UiN+4ZUDjmz78+4I9TPYUuGIr+5NKuaeLaG8WC6sitTv7e9/
         VOcssN1p4hRwnbA46pkkDSwagSvj7O/8CcacCmyddD7juGFVoU8AgO21/D2NNq1mLg+3
         xEAg==
X-Gm-Message-State: AOAM532Zq4caHrn/qcoWk/eq6xc7fRkbFBfp7vWiKvTsIoXdbTo5HdDh
        0fEEDqWHdZNyLUhnhA2VL3o5/Bvs0ngo
X-Google-Smtp-Source: ABdhPJxniQ3ds4YHSA2Ue2nrlmMmPPLMCqvXrVwKt7jYep+pX01hfC0BD9DPul4ueTvSoZH0p7Z6ng==
X-Received: by 2002:a63:8ac8:: with SMTP id y191mr17492646pgd.159.1600245388877;
        Wed, 16 Sep 2020 01:36:28 -0700 (PDT)
Received: from LiHaiwei.tencent.com ([203.205.141.64])
        by smtp.gmail.com with ESMTPSA id w6sm14523417pgf.72.2020.09.16.01.36.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 01:36:28 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH] KVM: SVM: use __GFP_ZERO instead of clear_page()
Date:   Wed, 16 Sep 2020 16:36:21 +0800
Message-Id: <20200916083621.5512-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

Use __GFP_ZERO while alloc_page().

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
 arch/x86/kvm/svm/avic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ac830cd50830..f73f84d56452 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -153,20 +153,18 @@ int avic_vm_init(struct kvm *kvm)
 		return 0;
 
 	/* Allocating physical APIC ID table (4KB) */
-	p_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	p_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!p_page)
 		goto free_avic;
 
 	kvm_svm->avic_physical_id_table_page = p_page;
-	clear_page(page_address(p_page));
 
 	/* Allocating logical APIC ID table (4KB) */
-	l_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	l_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!l_page)
 		goto free_avic;
 
 	kvm_svm->avic_logical_id_table_page = l_page;
-	clear_page(page_address(l_page));
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
  again:
-- 
2.18.4

