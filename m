Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365026871A8
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 00:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbjBAXNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 18:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjBAXNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 18:13:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E151114C
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 15:12:57 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso130219pjb.4
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 15:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cl7UMnqTD5QWwSQtcMHkzcnwz8kfWWwFumdLwjzGjWU=;
        b=AYyDHKJWglbSzJEBLsLPFIGYX8v9aHwYKVczL2pHtwC5N22rJfU9y9NSfKlgOdh0fv
         w2W+uyo3DAMX5HmdfdUMCHzWsJeZy1A6LGouRSP4Txaz+2I7rPOOhzpZdOqOYLabMum9
         RF8gaSlxNxAsjzgxjAIujsLqXF61EP5lrlmVFpApJJZtwve5f+cIe5OLH86MvYz6CW6T
         rHOlw5+PXp3yiMoz5DPxDc/XfO3kd0E/hj3ETsWis1HuVlSY2A3/7kI9Z2n6DIWw17X5
         3lvZfhscfxSjPXVvpZspLtv8cxhpBq6IEqz3LxbptRZntG5zYI7hXpPp+IU58crDpYAG
         e7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cl7UMnqTD5QWwSQtcMHkzcnwz8kfWWwFumdLwjzGjWU=;
        b=VzVqDkafXEUEQ9f6KSa5mZIVDNk+D5qnkbFyIx2c3cU6gfj46ebRDGzclgMdwZuGt5
         o8D2aciwPUmx1EFc/u8lRnMFer2b0Phoi6jzrl9SeKoYG1cc+mFabbo8VYpBN2F/z+BE
         E9H7uIPTy2qMUEWs7ZwaxPMbLYxukmB5eA9Td6lNzCnYEPVT3PkNPG29HFshMs8L2mqQ
         E4rlnW8HNlVE2CrSlyj8/eKqt8SZgQIMWEQjwIvAZd6f7v5ZFCc8F1aQW5YjBRcpB1Tw
         U9DJGVp3KdoowVG+nVqO7pO0tOk6TnJXzvGuV+kAxplOUES9Qaj+a/hj0v06MPvO9vp4
         qBzQ==
X-Gm-Message-State: AO0yUKWPRxclJiHJAuXXXQ/CmlR4GeRZqe6BE71RZNWkVri829byNRlt
        8Es1NW2b8EZ2SSmmzgLjH9KniA==
X-Google-Smtp-Source: AK7set+Zn3MRswtmIYIu62T6jZNygP14u2L1nwSLIM7HoaQCKkcqy33BWtvgX2o1OqydHiDIklFHUw==
X-Received: by 2002:a17:90b:3148:b0:22c:5f97:f6b4 with SMTP id ip8-20020a17090b314800b0022c5f97f6b4mr4143148pjb.44.1675293177450;
        Wed, 01 Feb 2023 15:12:57 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090a510300b0022bf0b0e1b7sm1861774pjh.10.2023.02.01.15.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 15:12:57 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v4 05/14] RISC-V: KVM: Return correct code for hsm stop function
Date:   Wed,  1 Feb 2023 15:12:41 -0800
Message-Id: <20230201231250.3806412-6-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201231250.3806412-1-atishp@rivosinc.com>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SBI specification, the stop function can only
return error code SBI_ERR_FAILED. However, currently it returns
-EINVAL which will be mapped SBI_ERR_INVALID_PARAM.

Return an linux error code that maps to SBI_ERR_FAILED i.e doesn't map
to any other SBI error code. While EACCES is not the best error code
to describe the situation, it is close enough and will be replaced
with SBI error codes directly anyways.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_sbi_hsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 2e915ca..619ac0f 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -42,7 +42,7 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.power_off)
-		return -EINVAL;
+		return -EACCES;
 
 	kvm_riscv_vcpu_power_off(vcpu);
 
-- 
2.25.1

