Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B226F2DDF44
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 08:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732803AbgLRHw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 02:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbgLRHw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Dec 2020 02:52:27 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1B9C0617A7;
        Thu, 17 Dec 2020 23:51:46 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id e2so831287pgi.5;
        Thu, 17 Dec 2020 23:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5VSd6QhQzMHF1/sHiWkO/Om8MKHK55gKlP12xsEBAQc=;
        b=nPBYwnZnRDnkzJLG8ciezDh0ioFE9cM89K0LjVQum+nNKuQstWKAG7QiTA7vMg6lQg
         9EUaItPu8ZBnTx3BPYkiMpJMbmkbBMSOoryssx7uOdJJaX0NCEcPnCfyCKht1waGJQj8
         4joG31cVQcaZ2KW+7/Rxp5sa9MvndWOLhlNDd2NNtlXuHECSl9m28Ygw1aFy3/zvZqd8
         r0BVCOexaAGbwFD5k5mYlSoJI8yHSEO60znBOtCqQ8+IbJa7hqT+9iCGxs7HZTY+8810
         gRVCtPEpUuqPuTX7tZit7DjBIPhrdW9QeCX2hYhTfyPEmaFSlzSrpHMfonc7dVcQpUYm
         E1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5VSd6QhQzMHF1/sHiWkO/Om8MKHK55gKlP12xsEBAQc=;
        b=n2Q4qHqVGyOFJjo9+DYAFWtuVlNBhIi4aXifEHxYDV33QFNOdQ2w3TWYY3R1UguoDP
         G36wpFCvkSKyqdFW3UPQ4MIf14RfFAqpRKgpgIZtDRi4e0yJaTFBHOQ6pBhHMI1EvqjK
         eRex2vD0CSzY5QhRmBXwDgpz3hZC5mOQyjpe7UoZjZZBakYMi//W70uX4ZBY30k8IHlt
         WeMj8tOrtfFDP519watDw2R4IizCkxVGbHiCBeQl8BqW7wo6gbxYdUEehYF+vV/Gw4kz
         Xgo/UUVBu5y8rXwshC3rX8ygg9G4790V1tYUFOR9NHNI22QZVsMEpbgZ1/Hn5f1ZgzjI
         flhQ==
X-Gm-Message-State: AOAM5332Bxjd28QN/m+gSYe2dYjoei6QyojFpNnTsTBbqnLzWxuyBrLi
        ia417Hf0uamGTOCv7sgX5qxc3kY0sgLvbw==
X-Google-Smtp-Source: ABdhPJwN60C1OBDKtOWnVAb2bUt5aw9uehpe+VcCZyCCKra2T2YrFYOgjtohyT6ba2gMmuPdaFsOkA==
X-Received: by 2002:a62:fc86:0:b029:19d:9943:c843 with SMTP id e128-20020a62fc860000b029019d9943c843mr2641438pfh.71.1608277906531;
        Thu, 17 Dec 2020 23:51:46 -0800 (PST)
Received: from localhost.localdomain (ec2-18-162-59-208.ap-east-1.compute.amazonaws.com. [18.162.59.208])
        by smtp.gmail.com with ESMTPSA id v125sm8373699pgv.6.2020.12.17.23.51.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Dec 2020 23:51:46 -0800 (PST)
From:   Stephen Zhang <stephenzhangzsd@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Zhang <stephenzhangzsd@gmail.com>
Subject: [PATCH] KVM: x86: change in pv_eoi_get_pending() to make code more readable
Date:   Fri, 18 Dec 2020 15:51:37 +0800
Message-Id: <1608277897-1932-1-git-send-email-stephenzhangzsd@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3136e05..7882322 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -674,7 +674,7 @@ static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
 			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
 		return false;
 	}
-	return val & 0x1;
+	return val & KVM_PV_EOI_ENABLED;
 }
 
 static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
-- 
1.8.3.1

