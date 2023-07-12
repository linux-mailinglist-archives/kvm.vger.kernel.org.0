Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45905750DA8
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjGLQLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbjGLQLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:11:23 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7631FFF
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b8b4748fe4so37224755ad.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689178277; x=1691770277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIhoBJIji5REw+c97wvX8gH5yx7OMiGOjWHtFLvuXY8=;
        b=DZZl6Tyw8rygxq6v1Ip8WcrsD1yMw3IJx70AOvwyWIZXUv6g7wymi7DWduMTgyI/t9
         uvO8LdmbUqraLqRMq8xwFd6S9oAciovNB9nTsIblGR+XwQ9Xe/FL5Qf1lsXCblO0QXM3
         X8jEL+v85UEWQggyFYzoT0GNUi+xZunYwUP07iidokwKQYaorj8lmWEV1b1jrIBPCrQR
         qO8iH1vLuooQC01OSehv8g3+36qDMzDLYB5Ccghk1GLgLihiA6Orq5rk7GKR17rBy4SO
         rPpkN1ZEChVnqODAcYV2KjMouU3bds6fmw4j/qEkE6SBWX7QfhNkYV/nW7wRcyRbh1cY
         dipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178277; x=1691770277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yIhoBJIji5REw+c97wvX8gH5yx7OMiGOjWHtFLvuXY8=;
        b=X6/ABsACKjOoie7Hik5W75UZh1OD8nHr4L1MmEwk24/Ntcjqa7yHluZjGZk13IPP2b
         O44qiTgsiI8pwlDAoUBwXQ0QQyr7N6VMoZIix72b4s2q2+JTOh0h925obe6TalTO+sMC
         SAKhMAh2cPb6EioP2ckMsOWeFITsa3Hr6003d2ldkS6RyI43m2ZQRXm6t7mEOdHbcnY0
         FZHgVu1EnRAO140zy2H8GgM/cJdbKOlYUmhkmDgHdcCZwfGqWSZT9kCcBYGPdfIifanE
         QHUqOKX3a/Zn1uTMVY9c2KEJQ78YQcr0CjdJLgrQPs91hSClg9TJwRYi7U3puMBetbT+
         uotQ==
X-Gm-Message-State: ABy/qLZHKR9zxJnt4EefntnzQdGF9Sp+oBU5JLUOBHclyqrF9/InMenO
        TnrO3/pmfqAxILsTOQufXEWnFQ==
X-Google-Smtp-Source: APBJJlFZDPe0kDucLXqtwvSgUfPEhKZKDiIULA3ytTvWn38iLHBRbIqekwRmcjuywf6ZlCFyltNA3A==
X-Received: by 2002:a17:903:2305:b0:1b8:9b17:f63d with SMTP id d5-20020a170903230500b001b89b17f63dmr18745465plh.23.1689178277316;
        Wed, 12 Jul 2023 09:11:17 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id bc2-20020a170902930200b001b9f032bb3dsm3811650plb.3.2023.07.12.09.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:11:16 -0700 (PDT)
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
Subject: [PATCH 4/7] RISC-V: KVM: Allow Zicntr, Zicsr, Zifencei, and Zihpm for Guest/VM
Date:   Wed, 12 Jul 2023 21:40:44 +0530
Message-Id: <20230712161047.1764756-5-apatel@ventanamicro.com>
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
user space to detect and enable Zicntr, Zicsr, Zifencei, and Zihpm
extensions for Guest/VM.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 4 ++++
 arch/riscv/kvm/vcpu_onereg.c      | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 68f929d88f43..9c35e1427f73 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -126,6 +126,10 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SVNAPOT,
 	KVM_RISCV_ISA_EXT_ZBA,
 	KVM_RISCV_ISA_EXT_ZBS,
+	KVM_RISCV_ISA_EXT_ZICNTR,
+	KVM_RISCV_ISA_EXT_ZICSR,
+	KVM_RISCV_ISA_EXT_ZIFENCEI,
+	KVM_RISCV_ISA_EXT_ZIHPM,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 555acebcbe02..e73f9b105a02 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -40,7 +40,11 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZBA),
 	KVM_ISA_EXT_ARR(ZBB),
 	KVM_ISA_EXT_ARR(ZBS),
+	KVM_ISA_EXT_ARR(ZICNTR),
+	KVM_ISA_EXT_ARR(ZICSR),
+	KVM_ISA_EXT_ARR(ZIFENCEI),
 	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
+	KVM_ISA_EXT_ARR(ZIHPM),
 	KVM_ISA_EXT_ARR(ZICBOM),
 	KVM_ISA_EXT_ARR(ZICBOZ),
 };
@@ -82,7 +86,11 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_SSTC:
 	case KVM_RISCV_ISA_EXT_SVINVAL:
 	case KVM_RISCV_ISA_EXT_SVNAPOT:
+	case KVM_RISCV_ISA_EXT_ZICNTR:
+	case KVM_RISCV_ISA_EXT_ZICSR:
+	case KVM_RISCV_ISA_EXT_ZIFENCEI:
 	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
+	case KVM_RISCV_ISA_EXT_ZIHPM:
 	case KVM_RISCV_ISA_EXT_ZBA:
 	case KVM_RISCV_ISA_EXT_ZBB:
 	case KVM_RISCV_ISA_EXT_ZBS:
-- 
2.34.1

