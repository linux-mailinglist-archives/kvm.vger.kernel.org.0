Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667054CD216
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239520AbiCDKLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239508AbiCDKL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:11:29 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048DA1A906C
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:10:42 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id l25so7360191oic.13
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 02:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W88BFAMfIQPlzsE5Ded5mhnnTZPYQAXRUS4xOsxlGF8=;
        b=Z7FrQFwP4mQzZlkB+t/MUGoPQiN5FpXuFBrVMEGTrFHdsP/Ku0wM0ctZfEwhJ/TcCo
         YIgllBiFTU9Y5Bn64UNQNHSKbiXZfylJVAUjWeqlgG8Exo5pqex4c82ztKsGhkyX7ytW
         qk4he5M4sfasojeIafs3e4J/sLJ97UOqm7Xv9KH6t3FwFSafBfAedwNNgML2e6ahZKRm
         pGioqd6n1m1vQCCUgC0NAW4MQIlkV6EHbIqLbGgML5tUScx5zcLTxqSrGvx30Moe6IbC
         IIHPSztNrFaiAQBeve2GA7B5JAg5aeqWZWoYATAvNVG7e0gYrw43NADwcyaklWTAa9FC
         BmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W88BFAMfIQPlzsE5Ded5mhnnTZPYQAXRUS4xOsxlGF8=;
        b=ZFC1Oan6UOlFx1tuAvIzqHFK9DKUSifQD9pJgR0QlLpWQNVCafz0gApy6Bzk1i4Jx4
         47qtlQsDPGVn76Deo5zmi67kBfEiWjQhBa4tzfsBQQPRZmr1gDjN1v+D9BwbYD3/cb5F
         eKYKJa0nW+X0Hq1K2iJ2vsu13xodWW6S5E0wo+bS9+qFRmqxqpBX0pMyqZDYlcLL0cbk
         dOLPGShS2hmr6jfXLcpIUTwUl+xOWqUSfAH3uSs7Ce0YcJzKHiUBJB5WF7i22XQhX6WQ
         Pi51VFVmcrAWJii+ADyxkPMYbQsZhrtt4c8CdQcSCG4LxsfnHWDIq9Dm8D3pYpwFVnDL
         0JvQ==
X-Gm-Message-State: AOAM530UFIRsPkJRK4rntB7k7bkrRiiskK9OKMvwQWOMO7tNw/sgOquS
        RnkSJZCkU3Xr1ozPTFj1OLJt0+C46FvIpw==
X-Google-Smtp-Source: ABdhPJwV54ScY8i/ips2wTe5bsNNncZk9pf1ppUMD4kkWEfEnfp74WGt5mf9/Ln+wN4O+APOBBkIXQ==
X-Received: by 2002:aca:2112:0:b0:2d4:653d:82b8 with SMTP id 18-20020aca2112000000b002d4653d82b8mr8838442oiz.126.1646388641364;
        Fri, 04 Mar 2022 02:10:41 -0800 (PST)
Received: from rivos-atish.. (adsl-70-228-75-190.dsl.akrnoh.ameritech.net. [70.228.75.190])
        by smtp.gmail.com with ESMTPSA id m26-20020a05680806da00b002d797266870sm2358769oih.9.2022.03.04.02.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 02:10:40 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [RFC PATCH kvmtool 1/3] riscv: Update the uapi header as per Linux kernel
Date:   Fri,  4 Mar 2022 02:10:21 -0800
Message-Id: <20220304101023.764631-2-atishp@rivosinc.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220304101023.764631-1-atishp@rivosinc.com>
References: <20220304101023.764631-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The one reg interface is extended for multi-letter ISA extensions
in KVM. Update the uapi header file as per that.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 riscv/include/asm/kvm.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index f808ad1ce500..e01678aa2a55 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -47,6 +47,7 @@ struct kvm_sregs {
 
 /* CONFIG registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_config {
+	/* This is a bitmap of all the single letter base ISA extensions */
 	unsigned long isa;
 };
 
@@ -82,6 +83,23 @@ struct kvm_riscv_timer {
 	__u64 state;
 };
 
+/**
+ * ISA extension IDs specific to KVM. This is not the same as the host ISA
+ * extension IDs as that is internal to the host and should not be exposed
+ * to the guest. This should always be contiguous to keep the mapping simple
+ * in KVM implementation.
+ */
+enum KVM_RISCV_ISA_EXT_ID {
+	KVM_RISCV_ISA_EXT_A = 0,
+	KVM_RISCV_ISA_EXT_C,
+	KVM_RISCV_ISA_EXT_D,
+	KVM_RISCV_ISA_EXT_F,
+	KVM_RISCV_ISA_EXT_H,
+	KVM_RISCV_ISA_EXT_I,
+	KVM_RISCV_ISA_EXT_M,
+	KVM_RISCV_ISA_EXT_MAX,
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -123,6 +141,9 @@ struct kvm_riscv_timer {
 #define KVM_REG_RISCV_FP_D_REG(name)	\
 		(offsetof(struct __riscv_d_ext_state, name) / sizeof(__u64))
 
+/* ISA Extension registers are mapped as type 7 */
+#define KVM_REG_RISCV_ISA_EXT		(0x07 << KVM_REG_RISCV_TYPE_SHIFT)
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
-- 
2.30.2

