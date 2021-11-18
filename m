Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7F34559AF
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343607AbhKRLMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343627AbhKRLL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:11:27 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AB5C061764;
        Thu, 18 Nov 2021 03:08:23 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id o4so5597969pfp.13;
        Thu, 18 Nov 2021 03:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6jKqwEPBzP3w6G3AtpS0thcI+j6oHMgihOAkR23jayk=;
        b=V2nP0rb1WssgEDmCO2HcTdJETovu8BUVVWmXX3ZhGGF5csCjMn88DPJi9a7TCDeejF
         YzLgFBWUKtjyGQJYTj2vdzsU2/r3d/DiSZuxZXFJf1QBakMAtUqMAY81G+T09hLDXK+j
         WFq2rKENP+/MX2A8xyuQPv+rwFNYhVMhMpOC3c1uzgSkb3LghQv2FFoDsw/cKXmU/3rr
         kyVOB5IwwlftMS5RkQjQCFNC4f6I416YnpFRPWyRe3zuTFQ773b2Oewa7sm42BH+Y7nR
         Pqk8AEr4PYG1L2EpY9dgrboohH59/qxUJPzRNxqhamp+QucVn8jp0Guudz0ELA/4KgLw
         fsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6jKqwEPBzP3w6G3AtpS0thcI+j6oHMgihOAkR23jayk=;
        b=7kO7gi2jcTmI0/l3mLxtRVWH8uT476BidKHVVTMLoILdWLf2jKSkF5DGr5NyZCn0pB
         WK2cVPD3x9iGeconJwrsZDUUrQaksy4pE1pSXzvPDY0f6oKt7KCPOxGwHn+1xQVwNfDp
         nG5ONYC57pGVeD41cF0Gvvm9fwDZ5Xn2feJXTjSMU9jYs8EXaiXKfmKFE4lokTyq9wjm
         x/hWh2b+V8hBJrFxuXGuFwDvWoznKm8cUu2S+M+miV2MG3qX3RdQMK2cLRvZ2TBnHMAa
         YtvN5zpMj32rYDzFfnLBgTzxi4orX7FN/aTxL19YKU0Rum7QnYaEj4P5WNloUXlEOQdV
         EF1A==
X-Gm-Message-State: AOAM5309YsmltNk8upv/5MB9mJnsZLB94LhixIqp5HMPahW7QoNkt1XC
        lpTXZapcXjXS25xqnn9HFroCPgD58qg=
X-Google-Smtp-Source: ABdhPJxd8P155rYhd2AhTnmcS9rIRShVjdxGQ3nhpSvQ+XchOr6YfDZqtDimvkAAmU8bx6QAkCTVEA==
X-Received: by 2002:a63:3ca:: with SMTP id 193mr10784594pgd.290.1637233703140;
        Thu, 18 Nov 2021 03:08:23 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id u22sm3135965pfk.148.2021.11.18.03.08.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:08:22 -0800 (PST)
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
Subject: [PATCH 03/15] KVM: VMX: Update msr value after kvm_set_user_return_msr() succeeds
Date:   Thu, 18 Nov 2021 19:08:02 +0800
Message-Id: <20211118110814.2568-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Aoid earlier modification.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4e4a33226edb..fc7aa7f30ad5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -602,15 +602,13 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	unsigned int slot = msr - vmx->guest_uret_msrs;
 	int ret = 0;
 
-	u64 old_msr_data = msr->data;
-	msr->data = data;
 	if (msr->load_into_hardware) {
 		preempt_disable();
-		ret = kvm_set_user_return_msr(slot, msr->data, msr->mask);
+		ret = kvm_set_user_return_msr(slot, data, msr->mask);
 		preempt_enable();
-		if (ret)
-			msr->data = old_msr_data;
 	}
+	if (!ret)
+		msr->data = data;
 	return ret;
 }
 
-- 
2.19.1.6.gb485710b

