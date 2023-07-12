Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D442C750DAE
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjGLQLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbjGLQLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:11:41 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1BE1FE4
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:25 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b9de2bd0abso19289715ad.0
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689178284; x=1691770284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtCtF2Lqb1YygYwlUUaBy2ctB42EouI70e6s/Uz9+Cc=;
        b=EZkO2jmsowUwtRgDtIpbAptf0MaO6v+JJ4rLp6Fydhm3WGP1O6M9N26UzmspPwksWt
         A33s76ThRvy/igg9Y403/YV9StsFgmrOTRt+SSzsRHBZkSliHPdcIl1oxFONKI35UKkr
         8ySFxiJPbhgW0gFTA13HOZijL25Q8jHVyK7BopBPMovq/ajmTOUK3oxeJiecPUbe7rzi
         ZCxUmFrqpUCZUZWTQIZQ/lrrjrNB/5reJLh3GZnHICm7vO5PDsyIRD0rpwR8kmM/XrLm
         I3Ptl+6pK1xx7CgcLkx0lfK0Z8XkI/S2RlVFQWmP/jQN3eB7UF4daBbEuSvNeUDC6G/v
         lErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178284; x=1691770284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtCtF2Lqb1YygYwlUUaBy2ctB42EouI70e6s/Uz9+Cc=;
        b=KMCjYKXY9vF0qK6FQA9WNPfhXGshC04Vqblq2JjxADc3LoDQESbRPpXYrOahYQQV0i
         UfufXRcPNdXhaAGDqo34nwZy9YUQbBlCorlGl/VDNl0NMaeXPMkKxtFNoQAtWioqy8Ig
         1JtzYG1rdyF+nLlwqOTNuJ3eWwXtXbeKBTygvBK1dWSQn5fko4UX+EtOl3Kk+duA8msU
         n9X9w8WwFqD1EgbBJ8slEgftX11drSlUn1ohA4t3W/i4hy+YHz9jsj+kWq7F44lEkPMD
         POujytTRkazlr5meMAdwNYxGMzvfAcRu0laY/vl3voVw6ejsCnomTykGIfvBtsds934k
         cFvg==
X-Gm-Message-State: ABy/qLaV+zyNy8txYaIevffvnh1f+5JNEL3djHakMMa7DXanTOltP42F
        jmUa1qCIaj3TbcjT7xlyL61bJQ==
X-Google-Smtp-Source: APBJJlFvn0Tk0l05fNo16Otc3mdNQPBj68R9kqcdAv2EV8FHsvvk8krDKu/f/KUJP4LqHWd3c2A3vg==
X-Received: by 2002:a17:902:9a4b:b0:1ac:7245:ba5a with SMTP id x11-20020a1709029a4b00b001ac7245ba5amr13407006plv.61.1689178284234;
        Wed, 12 Jul 2023 09:11:24 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id bc2-20020a170902930200b001b9f032bb3dsm3811650plb.3.2023.07.12.09.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:11:23 -0700 (PDT)
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
Subject: [PATCH 6/7] RISC-V: KVM: Allow Zbc, Zbk* and Zk* extensions for Guest/VM
Date:   Wed, 12 Jul 2023 21:40:46 +0530
Message-Id: <20230712161047.1764756-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712161047.1764756-1-apatel@ventanamicro.com>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We extend the KVM ISA extension ONE_REG interface to allow KVM
user space to detect and enable Zbc, Zbk* and Zk* extensions for
Guest/VM.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 11 +++++++++++
 arch/riscv/kvm/vcpu_onereg.c      | 22 ++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 9c35e1427f73..182e7bdfc842 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -130,6 +130,17 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICSR,
 	KVM_RISCV_ISA_EXT_ZIFENCEI,
 	KVM_RISCV_ISA_EXT_ZIHPM,
+	KVM_RISCV_ISA_EXT_ZBC,
+	KVM_RISCV_ISA_EXT_ZBKB,
+	KVM_RISCV_ISA_EXT_ZBKC,
+	KVM_RISCV_ISA_EXT_ZBKX,
+	KVM_RISCV_ISA_EXT_ZKND,
+	KVM_RISCV_ISA_EXT_ZKNE,
+	KVM_RISCV_ISA_EXT_ZKNH,
+	KVM_RISCV_ISA_EXT_ZKR,
+	KVM_RISCV_ISA_EXT_ZKSED,
+	KVM_RISCV_ISA_EXT_ZKSH,
+	KVM_RISCV_ISA_EXT_ZKT,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 36871a417e69..08e077260214 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -40,6 +40,10 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(SVPBMT),
 	KVM_ISA_EXT_ARR(ZBA),
 	KVM_ISA_EXT_ARR(ZBB),
+	KVM_ISA_EXT_ARR(ZBC),
+	KVM_ISA_EXT_ARR(ZBKB),
+	KVM_ISA_EXT_ARR(ZBKC),
+	KVM_ISA_EXT_ARR(ZBKX),
 	KVM_ISA_EXT_ARR(ZBS),
 	KVM_ISA_EXT_ARR(ZICBOM),
 	KVM_ISA_EXT_ARR(ZICBOZ),
@@ -48,6 +52,13 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZIFENCEI),
 	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
 	KVM_ISA_EXT_ARR(ZIHPM),
+	KVM_ISA_EXT_ARR(ZKND),
+	KVM_ISA_EXT_ARR(ZKNE),
+	KVM_ISA_EXT_ARR(ZKNH),
+	KVM_ISA_EXT_ARR(ZKR),
+	KVM_ISA_EXT_ARR(ZKSED),
+	KVM_ISA_EXT_ARR(ZKSH),
+	KVM_ISA_EXT_ARR(ZKT),
 };
 
 static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
@@ -89,12 +100,23 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_SVNAPOT:
 	case KVM_RISCV_ISA_EXT_ZBA:
 	case KVM_RISCV_ISA_EXT_ZBB:
+	case KVM_RISCV_ISA_EXT_ZBC:
+	case KVM_RISCV_ISA_EXT_ZBKB:
+	case KVM_RISCV_ISA_EXT_ZBKC:
+	case KVM_RISCV_ISA_EXT_ZBKX:
 	case KVM_RISCV_ISA_EXT_ZBS:
 	case KVM_RISCV_ISA_EXT_ZICNTR:
 	case KVM_RISCV_ISA_EXT_ZICSR:
 	case KVM_RISCV_ISA_EXT_ZIFENCEI:
 	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
 	case KVM_RISCV_ISA_EXT_ZIHPM:
+	case KVM_RISCV_ISA_EXT_ZKND:
+	case KVM_RISCV_ISA_EXT_ZKNE:
+	case KVM_RISCV_ISA_EXT_ZKNH:
+	case KVM_RISCV_ISA_EXT_ZKR:
+	case KVM_RISCV_ISA_EXT_ZKSED:
+	case KVM_RISCV_ISA_EXT_ZKSH:
+	case KVM_RISCV_ISA_EXT_ZKT:
 		return false;
 	default:
 		break;
-- 
2.34.1

