Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C026B750DAC
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbjGLQLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjGLQLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:11:39 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8962127
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:21 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-517bdc9e81dso2709221a12.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689178281; x=1691770281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HMl+3di3ifPPR0J8mu4JHNAW6MjLms68ot2tGPXSQQ=;
        b=mZf39NpCdkgfQ/VivpPnvKcCof7f9EuIMC3YmRIn7VvXPbx6t4mqg2OdlM1YkWbiC5
         6aTjSDJ0F1de9/3WCK+SXI3V+qDv2B36AXkMhXx7IsjlDz51ovmmY4rXNypOa3u1t9IM
         cvY2A9Gw5EXHdzW+4z7A2hA4rv0zDqKXPNYI7SmGvK8Mdb0lQtXy9orN1x3llS/ZWzjo
         LxYMmUTZuxi54QVMYkHhfEHNmY6i7kkaca5BgXos237GojE/z+/MxyXnJjG0VNOSZVV/
         L7Nm298rNlxHYVMpGS8HtqF0YxEpQnLP2YdurJORH4u8xAxU5chHPn4Eevz14VLdknmD
         nVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178281; x=1691770281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9HMl+3di3ifPPR0J8mu4JHNAW6MjLms68ot2tGPXSQQ=;
        b=eRJtgF7VmhTBGS4BMT/dLmKOKMHNAiwAqdMlJ7mJ4ymrZ41VOxxYxliggdz/TIrh9M
         l7voSRKnSVMb2d21kP7QlvAflIJdoZT473vzwFGzlMUHWROInxsyCSMVhbc/leekSpYh
         qtyr5By1I1ty6RllerZ8Ecd03NaCm7zgMoKEe5P8MqzCG+uBkqjYf1NRZGKT9h6z+1/R
         0WKHAJXLh7ynOZMHIJUOzbRtQ/LDBWsc16Ha623X0WHPefmyDImFJYUu+1RrnIoFapxR
         2QokiEdSNwN4b5CQdsTLSBcDMOSWmieQ9x31Lph5u/x453MIXgqEDft7oWKjXojX+2EW
         rszw==
X-Gm-Message-State: ABy/qLYd/a317YZJNVSvZujwUUbQZaptZXHKR5y8P9hruVK7vYOXEk4X
        b/Lz55I9Uy97uMMnnxYd5vOyoA==
X-Google-Smtp-Source: APBJJlFCstxiycuz4EWqUbsVDEZNs3hK944q9YYyrlNHK/0+r5ZzGzlMBmb4rMnPm0gSHom+jTfe3w==
X-Received: by 2002:a17:902:b083:b0:1b9:e091:8b08 with SMTP id p3-20020a170902b08300b001b9e0918b08mr6966398plr.58.1689178280775;
        Wed, 12 Jul 2023 09:11:20 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id bc2-20020a170902930200b001b9f032bb3dsm3811650plb.3.2023.07.12.09.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:11:20 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Samuel Ortiz <sameo@rivosinc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 5/7] RISC-V: KVM: Sort ISA extensions alphabetically in ONE_REG interface
Date:   Wed, 12 Jul 2023 21:40:45 +0530
Message-Id: <20230712161047.1764756-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712161047.1764756-1-apatel@ventanamicro.com>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let us sort isa extensions alphabetically in kvm_isa_ext_arr[] and
kvm_riscv_vcpu_isa_disable_allowed() so that future insertions are
more predictable.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index e73f9b105a02..36871a417e69 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -23,6 +23,7 @@
 
 /* Mapping between KVM ISA Extension ID & Host ISA extension ID */
 static const unsigned long kvm_isa_ext_arr[] = {
+	/* Single letter extensions (alphabetically sorted) */
 	[KVM_RISCV_ISA_EXT_A] = RISCV_ISA_EXT_a,
 	[KVM_RISCV_ISA_EXT_C] = RISCV_ISA_EXT_c,
 	[KVM_RISCV_ISA_EXT_D] = RISCV_ISA_EXT_d,
@@ -31,7 +32,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	[KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
 	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
 	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
-
+	/* Multi letter extensions (alphabetically sorted) */
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSTC),
 	KVM_ISA_EXT_ARR(SVINVAL),
@@ -40,13 +41,13 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZBA),
 	KVM_ISA_EXT_ARR(ZBB),
 	KVM_ISA_EXT_ARR(ZBS),
+	KVM_ISA_EXT_ARR(ZICBOM),
+	KVM_ISA_EXT_ARR(ZICBOZ),
 	KVM_ISA_EXT_ARR(ZICNTR),
 	KVM_ISA_EXT_ARR(ZICSR),
 	KVM_ISA_EXT_ARR(ZIFENCEI),
 	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
 	KVM_ISA_EXT_ARR(ZIHPM),
-	KVM_ISA_EXT_ARR(ZICBOM),
-	KVM_ISA_EXT_ARR(ZICBOZ),
 };
 
 static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
@@ -86,14 +87,14 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_SSTC:
 	case KVM_RISCV_ISA_EXT_SVINVAL:
 	case KVM_RISCV_ISA_EXT_SVNAPOT:
+	case KVM_RISCV_ISA_EXT_ZBA:
+	case KVM_RISCV_ISA_EXT_ZBB:
+	case KVM_RISCV_ISA_EXT_ZBS:
 	case KVM_RISCV_ISA_EXT_ZICNTR:
 	case KVM_RISCV_ISA_EXT_ZICSR:
 	case KVM_RISCV_ISA_EXT_ZIFENCEI:
 	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
 	case KVM_RISCV_ISA_EXT_ZIHPM:
-	case KVM_RISCV_ISA_EXT_ZBA:
-	case KVM_RISCV_ISA_EXT_ZBB:
-	case KVM_RISCV_ISA_EXT_ZBS:
 		return false;
 	default:
 		break;
-- 
2.34.1

