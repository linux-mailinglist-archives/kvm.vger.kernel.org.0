Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABE6750DB3
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbjGLQL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbjGLQLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:11:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F12F2696
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b89b75dc1cso6570835ad.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689178288; x=1691770288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mmAdt18zp6t4Zhgiqm8zC0JEDWTldiIyDdHXaTHo/h0=;
        b=kQkQUlSShEQrgDlX6aIxC7vQH9LcEtlGV0uGQCn6b057ZS+SXc6XNnSW8/ZN3WobJE
         pGekJOd/AaW89tvlhFIywJf2d99HhqH1Am/O0aszingM1caqHb/btaE+IFccIYRbSmag
         5EFUc9uhQoisGTOVWtt2iJBhQWVoPZx7If0IS7eUanEi6trVA8tRHdFXsZdhRV5KK6Bk
         RyxNOlGCOU8Eg5VUdYs/xJEYLb6t9eNA4swZ5LwJcBtwp3lSfY895jeJu21rzNVly5jk
         oXW3QoE475K/klVUJXHXxZfjugv4/qMeWeRc2l6PJgF+6BBQWZP308x8O7cZyD5TUxTs
         QNuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178288; x=1691770288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mmAdt18zp6t4Zhgiqm8zC0JEDWTldiIyDdHXaTHo/h0=;
        b=i7fQvAyulz0W+mywrso/y2zT1ic5HHukcfzkUkd9eYwYfY0WeBWN/7bhZvRm2/HT7o
         VTYWhppBpn1lNcaoYPKUbKQhLWBVogTpL8ePIVpiaXGmSpU2BQhFo1OamjcxTdZgVkvn
         DuQW+iDBddqxL3uPn3sloQweccXpSNsNEna/VbxkA6cbzk1tUSNBDs/d0rfTE4VMQUuH
         kgWND8d3yeBskUa2sUxdf4qn1JPGYdhHJbIPwR29YAraDhFl3Lsus0eFNv2XQA7/3fHm
         XfDBOb+FUGV7S9/saj0eCgDqCc3mZ4NVTigAZibkffvx2MDMEgWXYRGWYOHJYnK+yGeZ
         Uyug==
X-Gm-Message-State: ABy/qLZuGhZVV8Yx0O5Ed8Z/kjD/fhnU0Heqt65FIbEjG1y1S1pJP9i4
        o+93UpxNvZMuLAINdnqD9MDrJw==
X-Google-Smtp-Source: APBJJlHAwaBqYGiIZmjm5nXgjudHpZLu+aIM3EZuURNmVtDG80/PswBUaHV1/MXHja9nt8wuObYMWQ==
X-Received: by 2002:a17:902:ea02:b0:1b9:d335:1b7d with SMTP id s2-20020a170902ea0200b001b9d3351b7dmr3023742plg.6.1689178288003;
        Wed, 12 Jul 2023 09:11:28 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id bc2-20020a170902930200b001b9f032bb3dsm3811650plb.3.2023.07.12.09.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:11:27 -0700 (PDT)
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
Subject: [PATCH 7/7] RISC-V: KVM: Allow Zvb* and Zvk* extensions for Guest/VM
Date:   Wed, 12 Jul 2023 21:40:47 +0530
Message-Id: <20230712161047.1764756-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712161047.1764756-1-apatel@ventanamicro.com>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We extend the KVM ISA extension ONE_REG interface to allow KVM
user space to detect and enable Zvb* and Zvk* extensions for
Guest/VM.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  9 +++++++++
 arch/riscv/kvm/vcpu_onereg.c      | 18 ++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 182e7bdfc842..3929d3a7bd24 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -141,6 +141,15 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZKSED,
 	KVM_RISCV_ISA_EXT_ZKSH,
 	KVM_RISCV_ISA_EXT_ZKT,
+	KVM_RISCV_ISA_EXT_ZVBB,
+	KVM_RISCV_ISA_EXT_ZVBC,
+	KVM_RISCV_ISA_EXT_ZVKG,
+	KVM_RISCV_ISA_EXT_ZVKNED,
+	KVM_RISCV_ISA_EXT_ZVKNHA,
+	KVM_RISCV_ISA_EXT_ZVKNHB,
+	KVM_RISCV_ISA_EXT_ZVKSED,
+	KVM_RISCV_ISA_EXT_ZVKSH,
+	KVM_RISCV_ISA_EXT_ZVKT,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 08e077260214..89efa5e3e3f1 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -59,6 +59,15 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZKSED),
 	KVM_ISA_EXT_ARR(ZKSH),
 	KVM_ISA_EXT_ARR(ZKT),
+	KVM_ISA_EXT_ARR(ZVBB),
+	KVM_ISA_EXT_ARR(ZVBC),
+	KVM_ISA_EXT_ARR(ZVKG),
+	KVM_ISA_EXT_ARR(ZVKNED),
+	KVM_ISA_EXT_ARR(ZVKNHA),
+	KVM_ISA_EXT_ARR(ZVKNHB),
+	KVM_ISA_EXT_ARR(ZVKSED),
+	KVM_ISA_EXT_ARR(ZVKSH),
+	KVM_ISA_EXT_ARR(ZVKT),
 };
 
 static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
@@ -117,6 +126,15 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_ZKSED:
 	case KVM_RISCV_ISA_EXT_ZKSH:
 	case KVM_RISCV_ISA_EXT_ZKT:
+	case KVM_RISCV_ISA_EXT_ZVBB:
+	case KVM_RISCV_ISA_EXT_ZVBC:
+	case KVM_RISCV_ISA_EXT_ZVKG:
+	case KVM_RISCV_ISA_EXT_ZVKNED:
+	case KVM_RISCV_ISA_EXT_ZVKNHA:
+	case KVM_RISCV_ISA_EXT_ZVKNHB:
+	case KVM_RISCV_ISA_EXT_ZVKSED:
+	case KVM_RISCV_ISA_EXT_ZVKSH:
+	case KVM_RISCV_ISA_EXT_ZVKT:
 		return false;
 	default:
 		break;
-- 
2.34.1

