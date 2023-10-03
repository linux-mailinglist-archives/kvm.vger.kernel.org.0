Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157E97B5F95
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 05:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbjJCDxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 23:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239044AbjJCDxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 23:53:05 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D90F4
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 20:52:56 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c760b34d25so3338715ad.3
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 20:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1696305175; x=1696909975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PR9YD+pr7hv0tmO2NOz2gpQmVbaE/cJ/IAsO/LYC7Pc=;
        b=XndW1qrhTVSGZgMXpNzg31W8cUV7jQiFtUtpcG8iZmQmgibFRs4af+6llaF/WgscTR
         bhJU3jLvF+1MzNzf9MvoXDAIRAaGy0ZCx34pMBVh0fmoN+p+Xl7GxQ9CZDg69mXsglzz
         K4JAYafHcHA8Xr4efF83MALAK0eOgEy779VYsKIqwLwfjt8BK16vzHq1XcC01lXA/g3C
         sDHOQmdxdYvWocjiPuKgXiDg1n8544wAEOIxl6Lk1SN8oD39k5AdClp3DLMlW7lZZ/Wb
         bRVVBsobZ0hYOdI5ruv6WejKVSNrCpn90ar8weL6zY7dRQ6tEtoFMdm5VRtp9om0PEnh
         29Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696305175; x=1696909975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PR9YD+pr7hv0tmO2NOz2gpQmVbaE/cJ/IAsO/LYC7Pc=;
        b=xRq6IgdF/y5qw/smpYuwaGKUoOC87EDlcNOKMm0Aib6+aSkTZ+gDzPb2UP+GMQKtZx
         hmHSOLhuCeG82FEFYRG73P7mJeEm96qA/oTWSRg/Uvg4Swugmx/XA2frhSmtLlETnI7c
         TV8QMmVogeSxnJY8/949CLeovVa1AzK5MpDvp1dl9uUHwpseTpxc5UuEVvD2G0me/J/p
         gOjktUsVC7DvT73EvOV5cloMbmLEd1xwRQiC4lwFE9YlCZ3KPQTnzqUDRwxmqtGOOM/w
         /BQTYLWox6SFfqUcydZxRTwC2iwNYDB02KdzW/ornkrq1OjUdhAMJ8dhGXnrcSKC1xQm
         5w3A==
X-Gm-Message-State: AOJu0Yw17v52U0vwsQdDh7Ay04wbSWupCozJ+Xzfwl8P+uCSEZpcd8xW
        sXjfGfi/f6jbHL6I+XqT+fN1xQ==
X-Google-Smtp-Source: AGHT+IHVWdwg/sK94Dq4Rgb1USUh5bXBpGZ0ZnKGbSP+03oAaRBZUxn2NXa8Zq60ZS2d7KJ4sbaXhg==
X-Received: by 2002:a17:903:244d:b0:1c3:2ee6:3802 with SMTP id l13-20020a170903244d00b001c32ee63802mr13278709pls.47.1696305175387;
        Mon, 02 Oct 2023 20:52:55 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.84.132])
        by smtp.gmail.com with ESMTPSA id ja7-20020a170902efc700b001bf846dd2d0sm277381plb.13.2023.10.02.20.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 20:52:54 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Conor Dooley <conor@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Andrew Jones <ajones@ventanamicro.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        devicetree@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 3/6] RISC-V: KVM: Allow Zicond extension for Guest/VM
Date:   Tue,  3 Oct 2023 09:22:23 +0530
Message-Id: <20231003035226.1945725-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003035226.1945725-1-apatel@ventanamicro.com>
References: <20231003035226.1945725-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We extend the KVM ISA extension ONE_REG interface to allow KVM
user space to detect and enable Zicond extension for Guest/VM.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu_onereg.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index b1baf6f096a3..917d8cc2489e 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -138,6 +138,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZIFENCEI,
 	KVM_RISCV_ISA_EXT_ZIHPM,
 	KVM_RISCV_ISA_EXT_SMSTATEEN,
+	KVM_RISCV_ISA_EXT_ZICOND,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 388599fcf684..c6ebce6126b5 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -46,6 +46,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZICBOM),
 	KVM_ISA_EXT_ARR(ZICBOZ),
 	KVM_ISA_EXT_ARR(ZICNTR),
+	KVM_ISA_EXT_ARR(ZICOND),
 	KVM_ISA_EXT_ARR(ZICSR),
 	KVM_ISA_EXT_ARR(ZIFENCEI),
 	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
@@ -93,6 +94,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_ZBB:
 	case KVM_RISCV_ISA_EXT_ZBS:
 	case KVM_RISCV_ISA_EXT_ZICNTR:
+	case KVM_RISCV_ISA_EXT_ZICOND:
 	case KVM_RISCV_ISA_EXT_ZICSR:
 	case KVM_RISCV_ISA_EXT_ZIFENCEI:
 	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
-- 
2.34.1

