Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AAA4559C6
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343886AbhKRLPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343800AbhKRLNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:13:12 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400C8C06122B;
        Thu, 18 Nov 2021 03:08:59 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id r132so5012486pgr.9;
        Thu, 18 Nov 2021 03:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fh/XlgYsBLsDFl8X1AJ7Nue6Cjst6u62FiLb/dSgde8=;
        b=FlHitvg74QJC+Ny8Rnqceob2+7pokibaATGqk1KZ9DKKKxl7dr4t5nAicTNsxSPFHA
         jR8S8LYZD8Ku1N/ocMot3tjYXdTuFxV2qGlq/E+n1hY4oNRDau/BeFfkfmEn5xw+6mVp
         uq1Gq+X3p8xrIcXAoQvKjePh6QwgOwvB/FrdmlbYyshq/DxzxjQn1PgRTzsjJZI1fV2o
         ry9PAkcrPAP6eY6oRFmB71a+Lt3xQmEET1q1jfDCalRhtGhhRJSDkkhs4va3O8oNRcW5
         F9DhaaYpbyM2YxqdTd26NGRreSzFpbIK1eFFbEwRCGqqUDpws8K+LQJ0wCnhxb5tyVO7
         eHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fh/XlgYsBLsDFl8X1AJ7Nue6Cjst6u62FiLb/dSgde8=;
        b=3dUSEg3p0Xft1wMrJR0yP+rKC/y+OcvJqtyaTHApryMKI6sdZNeQzPIV2FPEUUdd7h
         iul1CMUwp4ChPECagPyXoKfoJEK/r3vwMse7dlZU7I+T78xVneMUoetTWyJzR8KAmKDi
         pVLJFicJAVYHAUOeuvPBBrm9aY2rOBvzJ//xi/S9T3EOtkwKP3nH+AQJ/592C+qr2d05
         aSlfwoK1zEO0i89oyRsSkeLh7GWIQb3U69Zi1E3u/4NqDR7G6MH1LiH/8wLDKZEkCRlr
         tm5IFOGxLkIF+EauNqMj+zDUcCGZ+WI5DQl4Wf3HWy3AO2XA0r7hA1M1ylel9mzxb7Qh
         LwEw==
X-Gm-Message-State: AOAM531tmBZnFkH8g1ZR77ZZ8NRYeGc6sijg7dIKszf+GAh5Kc+XhHOi
        V1MchzibGv8MhK55/Re1HRq2TX+FZnQ=
X-Google-Smtp-Source: ABdhPJxLq4FNtKGzakxenbPaFL4EEzLWGkjrl9z9DkSh2apy0gYHf27qakH5SXb9ownwO6vAmIVTYw==
X-Received: by 2002:a05:6a00:15ca:b0:49f:d22b:afff with SMTP id o10-20020a056a0015ca00b0049fd22bafffmr14398124pfu.35.1637233738665;
        Thu, 18 Nov 2021 03:08:58 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id j17sm1368394pgh.85.2021.11.18.03.08.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:08:58 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 09/15] KVM: SVM: Allocate sd->save_area with __GFP_ZERO
Date:   Thu, 18 Nov 2021 19:08:08 +0800
Message-Id: <20211118110814.2568-10-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

And remove clear_page() on it.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/svm/svm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 33b434fd5d9b..d855ba664fc2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -585,12 +585,10 @@ static int svm_cpu_init(int cpu)
 	if (!sd)
 		return ret;
 	sd->cpu = cpu;
-	sd->save_area = alloc_page(GFP_KERNEL);
+	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!sd->save_area)
 		goto free_cpu_data;
 
-	clear_page(page_address(sd->save_area));
-
 	ret = sev_cpu_init(sd);
 	if (ret)
 		goto free_save_area;
-- 
2.19.1.6.gb485710b

