Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565ED67ED68
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 19:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbjA0S00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 13:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbjA0S0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 13:26:19 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35BD7DBE3
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:18 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w6-20020a17090ac98600b0022c58cc7a18so1043003pjt.1
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75NYeBzTa+D//nXwSO0c9cu0uNpb/RJgMmwNWXsNQ7A=;
        b=YY7c/gb7KD4BgGwCl4QuD8RpNT7TTipby8rQS1fM8ewCQdAAVE7CoiEkS36lf3TY1+
         j3OpeGdZzI/FiuYvcGelaEpd818JPNjfPw5HRXDaKrEsFrqQR+6h3u2BoRBgd9QlAccY
         HDaOvbsPh9oJjc7aXIhCOrLyevo+m6Ry6cj+mJZ8grdtEokiLxkJS3Wgb67hSnJ3ny3B
         fdGvutiKC31lsRsHB07vjTgOC5Mh7oUjuEQX5QwOVbq5DU0s+Ur+Y7Z/GcKfyw3I0xA7
         lPMsCdqnd8ySESkWIsbXcv5QzXJOfH01v3I0e1Tj1NG1M9eSLmeKg5cOtxQhNaIVEsDH
         tagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75NYeBzTa+D//nXwSO0c9cu0uNpb/RJgMmwNWXsNQ7A=;
        b=cOq+uiBEv8/3CziGtx7SR8Gkuss/XHz9lyA5VuhH4NO7aloEpjvzBOj7L70EVU9zwa
         HvPCFLuwVwAe8c+6/xZD2VgG6H5SdgvatJ7QxOm29P9pcw8qBsBWCM4lc/9KFj+rQGfa
         8t4hoz7cT6Ze0ANMQq5dU8u9CvMVI/7ioYotOkpZwldivITjEcuXXVMmZK/PjEyqsxBi
         drmG8J+9/6/NPj8SkxvW5+XG+WLqZBDqwK9v/RpYQ7YUKSbPRsM0Px3H/HLOOL/XT7Qj
         k+D3ZddpYBJ8nUx2ECItKPaaWF7I6TYjPevA8R+qoObrD5iRi6IIk/C15PSk1HaVj2Xc
         6Obg==
X-Gm-Message-State: AFqh2ko2QO3rrXA2tcMM+XN3GnE0AEupf0EtA0VrBamJqn+Ttd0tQNJR
        KSqrJ5lb9h1xjeGvqDU4clR3Kw==
X-Google-Smtp-Source: AMrXdXtpndneDdeSSBdxCsMnxxzoCdgvpXuk7zeWfLXM+d7saHZXmYD4+9nx/fhrb0dq0pShXiEOXQ==
X-Received: by 2002:a17:902:7c93:b0:194:98f0:108e with SMTP id y19-20020a1709027c9300b0019498f0108emr34153952pll.13.1674843978225;
        Fri, 27 Jan 2023 10:26:18 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jc5-20020a17090325c500b00189d4c666c8sm3195219plb.153.2023.01.27.10.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:26:17 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v3 05/14] RISC-V: KVM: Return correct code for hsm stop function
Date:   Fri, 27 Jan 2023 10:25:49 -0800
Message-Id: <20230127182558.2416400-6-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127182558.2416400-1-atishp@rivosinc.com>
References: <20230127182558.2416400-1-atishp@rivosinc.com>
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

