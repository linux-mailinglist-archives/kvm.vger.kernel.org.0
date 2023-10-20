Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2AD7D095F
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376509AbjJTHW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376388AbjJTHWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:22:18 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF0F10E9
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:22:13 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 5614622812f47-3b2ea7cca04so378093b6e.2
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697786533; x=1698391333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XKdexmGCdd2bnnrJTDfux86dDbyR62+1G32W+zioUE=;
        b=EjP9DRi80NBbQp34j86KtekV/1R8/ysD99DAJ1ahh1zuXn2EF6ZDCA+xF7G2qde/8e
         Q3xE/3ma96e0D08dCGGxxHeLN46I3BjRv/7v7mUdlyp90j2QNttZ9+/JCndp9lzL+45H
         VRM+JLD0tu6p1g5qQotPFfJEuLQq9CCGbX2mgv/kdZ0ibWUSE+Jx5haQM73rEOcrHe+Y
         pG/FNIBmWaUstQzVw8KuSa0sdrUpIGNP8Nh+6nX5YOqi3ZeK4HuXhu/iLeGLDK6u9xLo
         W7iLlPWZNnVnseCacK4+5vrgBLZmKZ5S/iuLqQ+XcLWhK5olpyJ+FJ614Al3f1K/HSi8
         s50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697786533; x=1698391333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XKdexmGCdd2bnnrJTDfux86dDbyR62+1G32W+zioUE=;
        b=DYN6hNCp02dgqSpgeHwIuVLIghtUjP+pgrT+CBzgcPViW4esVxgS1u29KEymsgxvJQ
         WJ4c2ZJzRVlfkm5AQVRppMx/fAlss2Xy32Gd8NRBZLDrO7PZcKPAFNuhk3WdGiln4jaj
         upwttXOilZhh8wq2xTQD8Wg0YZNMUSO+kyv7mF6E7zC0tFoYFqVx5f/sP/8q89xubUiZ
         BUeGG8GLCVXexHtYCiOcpbvJ8dAeVXFB0m1UB6cGPgUe/av2SI972AzjyvJApEsyfYZQ
         V14/WU6wwdY1e0HN7E9O2eelbFHfYQlNuV7mSYZ0jzHMgv4Y2x/Ntqrrb1DsfhOfjHea
         tBsw==
X-Gm-Message-State: AOJu0YyF3XSAh9rSybTRO80rDx0/adpw/54IR9MF947NFD7cZbcxyB54
        fveCoW8CG6fitx0LGFCkT0FTsg==
X-Google-Smtp-Source: AGHT+IGNA3teY62UcK8wOWxlnmVNiOGXjjS4KNoIU7oF6NdgPgGX2+CnnNq3uwbgRObNWcOANMq+ew==
X-Received: by 2002:a05:6808:144d:b0:3b2:dcff:9e54 with SMTP id x13-20020a056808144d00b003b2dcff9e54mr1358519oiv.24.1697786532716;
        Fri, 20 Oct 2023 00:22:12 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.83.81])
        by smtp.gmail.com with ESMTPSA id v12-20020a63f20c000000b005b32d6b4f2fsm828204pgh.81.2023.10.20.00.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 00:22:12 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 5/9] KVM: riscv: selftests: Add SBI DBCN extension to get-reg-list test
Date:   Fri, 20 Oct 2023 12:51:36 +0530
Message-Id: <20231020072140.900967-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020072140.900967-1-apatel@ventanamicro.com>
References: <20231020072140.900967-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have a new SBI debug console (DBCN) extension supported by in-kernel
KVM so let us add this extension to get-reg-list test.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 234006d035c9..6bedaea95395 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -394,6 +394,7 @@ static const char *sbi_ext_single_id_to_str(__u64 reg_off)
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_PMU),
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_EXPERIMENTAL),
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_VENDOR),
+		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_DBCN),
 	};
 
 	if (reg_off >= ARRAY_SIZE(kvm_sbi_ext_reg_name))
@@ -567,6 +568,7 @@ static __u64 base_regs[] = {
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_PMU,
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_EXPERIMENTAL,
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_VENDOR,
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_DBCN,
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_MULTI_EN | 0,
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_MULTI_DIS | 0,
 };
-- 
2.34.1

