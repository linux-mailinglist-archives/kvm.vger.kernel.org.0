Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEAE7A519F
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 20:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjIRSHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 14:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjIRSHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 14:07:08 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1324122
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 11:07:01 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c39a4f14bcso45023175ad.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 11:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695060421; x=1695665221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/FxLJCDRi2+AhF6FOTSx+aBMLtSpJjy7MQNwR3R94og=;
        b=EBj53UQwykWiQU8EeKXFnAZED+FFwvyq0XglEGPU04QSCReR2gRhAkrK27I2V+ERON
         lgRVORA2U19ayHSDeZj/m+w8N8SSwhsgwYuOJOMFxiq1TeUZgpTtZzLFFmmpiTlfB1SB
         i75nWmPSsLo9mEeh33LB0RfnoZzxfFA0w6M3Lsqq3YzFAvLKc1a41tj73YpjrLVgzcw4
         qwpooow5ZexzXW3INHhQOOIQy+ywa3V2gxKPuajEMCzVOsB9A7IoNLZ+Ef9b+y6zMkfg
         JX2PI1NYgMnxvgZbIUfYFoBjxNZdBAQ7sADttLIlPdjcqRzK+eqU7Y50NKJmhthQ/4MV
         ADtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695060421; x=1695665221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/FxLJCDRi2+AhF6FOTSx+aBMLtSpJjy7MQNwR3R94og=;
        b=TUdGAbA4+uQe3zd1zSJFmNB1w+tuKs9hDzx6hvGP3WyRjCei+INHswNyh+go70uIjb
         oMwCFQDns1+l8haqQcj3Y9txYSsv35pj5p6B6r0akmePw5WyKkDsnNrZNysMgtALmjFW
         B8UUZIsvJIKBe8nT/6QDaGBfxV0ugYgMFTv+YH1cs5zQG/bt2XLdpqyYeC2mHnTl24ka
         Fhu6Eb/rIF5zRnFRI+MN9K2aCWSVDYf4P2LJqqVpjZDCZ7Lbn4YDBVME9IlG2AhhbHlg
         pNjAjjPRrB9Fcc5wVNpW6AtZDai4wmPCCkpdNlfBfOUd5Z0hp4KSixaWGtgoFuNt9plV
         8dNw==
X-Gm-Message-State: AOJu0YzPRhkr/4w1xMgp4Ccyt+ViI4d1/ZoMYvBT27ibEpx5+4E6Bzc/
        MWejwccQG0HGTFDsnPz2YHwENA==
X-Google-Smtp-Source: AGHT+IFDMbQdNhGOLSD6ilndqDb8cXhJ+CzNk5FP+g+eBNqALQDifdWhN3LJ8Nfabjtn2qCQLRxJug==
X-Received: by 2002:a17:903:1247:b0:1c1:ecff:a637 with SMTP id u7-20020a170903124700b001c1ecffa637mr11725339plh.15.1695060421024;
        Mon, 18 Sep 2023 11:07:01 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id h7-20020a170902704700b001aaf2e8b1eesm8556720plt.248.2023.09.18.11.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 11:07:00 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 1/4] RISC-V: KVM: Fix KVM_GET_REG_LIST API for ISA_EXT registers
Date:   Mon, 18 Sep 2023 23:36:43 +0530
Message-Id: <20230918180646.1398384-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230918180646.1398384-1-apatel@ventanamicro.com>
References: <20230918180646.1398384-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ISA_EXT registers to enabled/disable ISA extensions for VCPU
are always available when underlying host has the corresponding
ISA extension. The copy_isa_ext_reg_indices() called by the
KVM_GET_REG_LIST API does not align with this expectation so
let's fix it.

Fixes: 031f9efafc08 ("KVM: riscv: Add KVM_GET_REG_LIST API support")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 1b7e9fa265cb..e7e833ced91b 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -842,7 +842,7 @@ static int copy_isa_ext_reg_indices(const struct kvm_vcpu *vcpu,
 		u64 reg = KVM_REG_RISCV | size | KVM_REG_RISCV_ISA_EXT | i;
 
 		isa_ext = kvm_isa_ext_arr[i];
-		if (!__riscv_isa_extension_available(vcpu->arch.isa, isa_ext))
+		if (!__riscv_isa_extension_available(NULL, isa_ext))
 			continue;
 
 		if (uindices) {
-- 
2.34.1

