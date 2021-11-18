Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF1C4559C2
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343828AbhKRLOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343635AbhKRLMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:12:42 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503C7C06121D;
        Thu, 18 Nov 2021 03:08:47 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id n26so5627310pff.3;
        Thu, 18 Nov 2021 03:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/8DObiGFy1ZJgr/sl7IgJ6YAecXd6ICgL6Wv5yClO9k=;
        b=THXQo6MHvGYoDnb5XubuHkCtaC6MFhwS+hunjE06Sjd6+HOJXgFTCZ6Fe0Nwj8la+9
         DILH55iDqGdwHIcYiX20cgwdF4xtg678GAG5VQj7YDxEJuoGQw3GfdWrG6AtE4Rjp4+h
         vF9bI1s54nw5rncYHJyCUKsO0w/MqdjzpKCDCloyJeAF59hpeVfDGzm1kAQEXNUszEzK
         G/cUAe1H1FzS03jahJkTWDHw5tm6snRxcjPzmV1xqOi3T2a1KAYQ0Uy69nUpKYgwuXXq
         kChYuQBMAWBUesXqF5UsKtQCc5qHc3Eq/GQZFTj1RDVlVqrxIT5I9stWvkttAoNX72iO
         DuVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/8DObiGFy1ZJgr/sl7IgJ6YAecXd6ICgL6Wv5yClO9k=;
        b=VGyzkCA/9lyOOs73VIK7m7ZrfvORmhKNJj5ldgRW2rsgFEm6E8aNgb+Le8K5hsMucJ
         dIpLestltc+jcT8dShTlDh1S1q+Ir0cth8NhGmOtM2pJavtPCT9/1a6Jwmm6E3Ccf1D4
         +nkPpj/X5gyCAGRUc+VI5i+kGRLYFHGPFuHi2S8t8RkbYeUQEYMWk8RhPNfUZcFqfEqX
         6bzspZLbWu06dCdGWcWTzA+fi1/6D0qZAsG+0KY8kl/hnDkHtGi0NNto4QEjHS6KqMjD
         D+y9G3pEvvwMYfGUcEJIedRBRM3HxqiBCGc4NQE79E6D3xSPREu6bW3mJlPCatZ+k8JV
         F38A==
X-Gm-Message-State: AOAM5306xOscIfh5cSUNHFsNxvb3dMYN/5GPIalRxl/u47cJ8y8HHusF
        IUVUmyAiGwD8LNFJxdbZPz4hx+LdB3g=
X-Google-Smtp-Source: ABdhPJxYrTn+tMOGRmDnifEVTL9jK4h4e0hO/vF8kKu8Me12kXsicDQW59R5/sBWSTivP1EGIV9Rxw==
X-Received: by 2002:a05:6a00:1c65:b0:49f:d8d0:c5d9 with SMTP id s37-20020a056a001c6500b0049fd8d0c5d9mr13920696pfw.72.1637233726730;
        Thu, 18 Nov 2021 03:08:46 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id a23sm2065793pgl.37.2021.11.18.03.08.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:08:46 -0800 (PST)
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
Subject: [PATCH 07/15] KVM: VMX: Change comments about vmx_get_msr()
Date:   Thu, 18 Nov 2021 19:08:06 +0800
Message-Id: <20211118110814.2568-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The variable name is changed in the code.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a0efc1e74311..c6d9c50ea5d4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1757,7 +1757,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 }
 
 /*
- * Reads an msr value (of 'msr_index') into 'pdata'.
+ * Reads an msr value (of 'msr_info->index') into 'msr_info->data'.
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-- 
2.19.1.6.gb485710b

