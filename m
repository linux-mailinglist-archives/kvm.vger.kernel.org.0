Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D912750DA6
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjGLQLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbjGLQLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:11:16 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D25A1BE2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:14 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-262e839647eso5185166a91.2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689178273; x=1691770273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4eCvgIEwUhNpUS/9a23InYjY0pR/vf8cughyXw/poo=;
        b=oFNNIVC+CISviFrM5Vq5FH0kRBY5kviSOIb0veSS6PqYkk04O51aDXHMPf+RyxK559
         BdqwgsAfWPphwmsN9ZSPRmZP64wNsrVtNoZc2WvfZYiSde4hGaVFAQeOrcXf3Sygnkd/
         SGZ6OhgD3slRwedfyssodEbncbVjEbp0FP+Ez7Y7g5gdZv1DnmIYV/sDneB9upEx41sV
         y7P/RUcccpOA9sgTxHHaSsBRJBUP6MtaHOewj779biMoUZSp/OJ7aKoniVmaYRJIbYeb
         HUxsM8cW1WtfHhGL4OeFQgKi83dYW6bSw5KVZG6gePc0P2jyam3oe7Z8frf+1qeODQBK
         2nPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178273; x=1691770273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+4eCvgIEwUhNpUS/9a23InYjY0pR/vf8cughyXw/poo=;
        b=YG5St4n7lV+XR3J7lj2GYZqrjS4IsLJ3GFclDXe9O3lS6emPVPNJF6HaZfd4J0Ol1B
         J42lV4sR7ssMSZZohaOaC1ZszGppIGhlOkOZ0qsYGzb/LZsHxSaWurMd0SFpuoftW9yh
         630x5nvQE3BcszVvHpaKizic39/RLM+RqDknyq/WuewKuLACgr8skxN3XmL2p6jtI0Sk
         5pK4gHsC3Vu0nU8ot2kGnu5Cflkk1spfoPLtuwX/pujE0TRxQi5gNZ6ylfaVnW6RCW2N
         lYf2vdOpb5c0ryNPrvZfZpR2UYaR/mDkVbaXamYJXfYRpALsTVrTVXWXTsMpwgp5ztMo
         VwPA==
X-Gm-Message-State: ABy/qLb86gV6uOHwrIntmf1mIqC5SQI8HUut6b1rx5bU6/89ZDgiqNMB
        GNEWD0o6J/ZeiGYsN1B2kgT7Hw==
X-Google-Smtp-Source: APBJJlHj2x7yj/VukJwmedNdpQID1nbTjJYHe48QPbo5swu8h+VBiX7XkelJf6YwNGHe6Ubn6M6HVw==
X-Received: by 2002:a17:90b:614:b0:260:fd64:a20 with SMTP id gb20-20020a17090b061400b00260fd640a20mr19650835pjb.9.1689178273292;
        Wed, 12 Jul 2023 09:11:13 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id bc2-20020a170902930200b001b9f032bb3dsm3811650plb.3.2023.07.12.09.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:11:13 -0700 (PDT)
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
Subject: [PATCH 3/7] RISC-V: KVM: Allow Zba and Zbs extensions for Guest/VM
Date:   Wed, 12 Jul 2023 21:40:43 +0530
Message-Id: <20230712161047.1764756-4-apatel@ventanamicro.com>
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

We extend the KVM ISA extension ONE_REG interface to allow KVM
user space to detect and enable Zba and Zbs extensions for Guest/VM.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 2 ++
 arch/riscv/kvm/vcpu_onereg.c      | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 6c2285f86545..68f929d88f43 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -124,6 +124,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SSAIA,
 	KVM_RISCV_ISA_EXT_V,
 	KVM_RISCV_ISA_EXT_SVNAPOT,
+	KVM_RISCV_ISA_EXT_ZBA,
+	KVM_RISCV_ISA_EXT_ZBS,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 236359722364..555acebcbe02 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -37,7 +37,9 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVNAPOT),
 	KVM_ISA_EXT_ARR(SVPBMT),
+	KVM_ISA_EXT_ARR(ZBA),
 	KVM_ISA_EXT_ARR(ZBB),
+	KVM_ISA_EXT_ARR(ZBS),
 	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
 	KVM_ISA_EXT_ARR(ZICBOM),
 	KVM_ISA_EXT_ARR(ZICBOZ),
@@ -81,7 +83,9 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_SVINVAL:
 	case KVM_RISCV_ISA_EXT_SVNAPOT:
 	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
+	case KVM_RISCV_ISA_EXT_ZBA:
 	case KVM_RISCV_ISA_EXT_ZBB:
+	case KVM_RISCV_ISA_EXT_ZBS:
 		return false;
 	default:
 		break;
-- 
2.34.1

