Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B11772C2D8
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 13:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjFLLeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 07:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjFLLeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 07:34:02 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3A1822B
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 04:10:55 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1a49716e9c5so2102893fac.1
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 04:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686568255; x=1689160255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zL7XkrZyqya8n0rx7DgOZlvul+j+rHB3G7NIYCr/fJ4=;
        b=Cu8HvVsL3Oo1kBqetVxfB8kxfDzsr/6mR6QXuR/GV6F3dSI2mMfAfYmUdskwrE+YsA
         H5Xpd2MWKbgGnHgAlzwLyQGRzDOcQ0Lc/c4rMu/XtI2+d33IF5dIjqFbD0aMM8f+jRMt
         zbnZ6+0uRsLg4nUomzgoSWkHxaJEwmsHgC8C0xNYgzV7UnT5kbB5fGUIP90W8/x25Usl
         JDx2Hv4KBbxi140bn/X+aovN+bd/5S42CXTgrweuu7HZzeDwgXczUzzZSyVj/aR9WUxl
         DQtCVdeDP6NxSOe7fs/+A/rghZs/zkufpNgWpQnpa1lrrFtP5B0rtCZUGUf0YRULaxhY
         oTAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686568255; x=1689160255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zL7XkrZyqya8n0rx7DgOZlvul+j+rHB3G7NIYCr/fJ4=;
        b=MRsWK/EYI8CgOKdbWdMGh66+VvCMcT6K/DS3/kAjmfCFrDc31Ci/3IusuH5tIH5+E0
         5S+aKhEhAo3WpJLPFp1Ib420WwCffQC4dGOXgSwT3mlk0kCT0qEBHPTfyYAlBlkS6Be1
         u9GPYgrylzUSdQrQRtIpCxBKC1iJm7gJ4VWmEmJ4rUSia0ZNZxOaJDWgQgWSmeVbHDyT
         yEz4xTKmdG8EnsCxkK68slfd7Es33xWYriW/+bOgvJDHv5lyGihNND+XRlbi9+QGQFmN
         71Qxo9ZmCQHMQzhACQNYd4ZuY/NCzoJYsbKFRznKN/01wyFbSuRE/yjrN4+UbjQR9b9f
         jiqg==
X-Gm-Message-State: AC+VfDxPLswjQJVpUkRunrL7xk6wY8Ka+tI+UM7D33DLUF0l4mcFPzn4
        Y6g2V/qDnLsQm/v3o74qO9iTOw==
X-Google-Smtp-Source: ACHHUZ4gRLnvcXL/JEGjteWqrP6XC6G4pxlYpyz+2HznJdMy7z5H1TyKvw56mBzuGJaiSuGr3hPVzQ==
X-Received: by 2002:a05:6870:4353:b0:196:4cb3:7b7 with SMTP id x19-20020a056870435300b001964cb307b7mr5797393oah.43.1686568255008;
        Mon, 12 Jun 2023 04:10:55 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id c8-20020a056870c08800b0017fea9c156esm5715955oad.18.2023.06.12.04.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 04:10:54 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH] RISC-V: KVM: Allow Svnapot extension for Guest/VM
Date:   Mon, 12 Jun 2023 16:40:44 +0530
Message-Id: <20230612111044.87775-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We extend the KVM ISA extension ONE_REG interface to allow KVM
user space to detect and enable Svnapot extension for Guest/VM.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 61d7fecc4899..a1ca18408bbd 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -122,6 +122,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICBOZ,
 	KVM_RISCV_ISA_EXT_ZBB,
 	KVM_RISCV_ISA_EXT_SSAIA,
+	KVM_RISCV_ISA_EXT_SVNAPOT,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 2db62c6c0d3e..7b355900f235 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -61,6 +61,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSTC),
 	KVM_ISA_EXT_ARR(SVINVAL),
+	KVM_ISA_EXT_ARR(SVNAPOT),
 	KVM_ISA_EXT_ARR(SVPBMT),
 	KVM_ISA_EXT_ARR(ZBB),
 	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
@@ -102,6 +103,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_SSAIA:
 	case KVM_RISCV_ISA_EXT_SSTC:
 	case KVM_RISCV_ISA_EXT_SVINVAL:
+	case KVM_RISCV_ISA_EXT_SVNAPOT:
 	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
 	case KVM_RISCV_ISA_EXT_ZBB:
 		return false;
-- 
2.34.1

