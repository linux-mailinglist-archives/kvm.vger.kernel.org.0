Return-Path: <kvm+bounces-2618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5761F7FBD52
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:54:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 894A51C20EE1
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F1F5C08E;
	Tue, 28 Nov 2023 14:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ZyB5NGaa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3221701
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:54:23 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1cf7a8ab047so42829385ad.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183263; x=1701788063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqoarEcYKPTwyPmOGP/1tRxw/l4x1unFGwuPZisXSs0=;
        b=ZyB5NGaaVVjLSIkAX4xKpip9qQ1O/BbdB1h8f1W7Wuz2wptTFHu3mzJU9cnan/cMLG
         cmR9EE5EZy4sY+1FDVgICcGnWGwpcnTb5wCqZd0Z07QnZ/mucdE0RqOmLLQJe60W2FbH
         8BSXTSU89JTXqLYTODcYFEqwJE9Z2i1253T5JED4txDyjjK1PIwQtTRiH/rxA+8JmY5u
         5rdHh2bKQS9CBjcxBv/uIgEMRN42cvGvI9sk/V5M3uR3+mDvnqtLiHmPMOWqvrv02qTq
         AsuJLZt3w0PNd0DQUZnqS7I54HWidKgoR8UcTuE6iO+hBzcfJjxA9cHlbWKINCD/JH8n
         5MUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183263; x=1701788063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IqoarEcYKPTwyPmOGP/1tRxw/l4x1unFGwuPZisXSs0=;
        b=rZvUK0V1m7SX9JPIErOeQG4g1G/54IG5EtUkHayK/s9v9Oii01jRpKwN/BkHEKJYCa
         OwzhkTs4zRcGltl+ZaTZPxqkd4nrne7npF3Eo0mjgEG66BJY/9JQ42+yjw/lJ0Tw35jD
         g6qOs+HFpsrG6JA3xXgKKihOYbPDL8C9owa8+d9xkLQSF3j99XoTB5eW3TyhiSX+Wj7Z
         HrcKtJEYLLCNkymmdvT7/9uY+3Olr/ovdCxD2tYDCfZNLXsXHGLvCZYHhp+G9XA5M71L
         +ne4B2f4KPO7tOPS7dNeoiOuWfAuHPvAtUtgCI7hR8V3bsXyyqoNAfVJHMQn+4WPXTNg
         icoA==
X-Gm-Message-State: AOJu0Yz6V1jLhDXF2Kc+TDo0ey7fODPqjFGTb+yWP1egvcLMPUjrgB48
	m4mVzztDLDB4oXX6UcAq8kT0UA==
X-Google-Smtp-Source: AGHT+IF0goMcAklKoJKTKjWtl2nqOMf0dgEj4xslQsxSZoF9zhQ3gTvjB8b3QY0TAV4Wuuo/tXKSpA==
X-Received: by 2002:a17:902:e843:b0:1cf:c404:45dd with SMTP id t3-20020a170902e84300b001cfc40445ddmr8585604plg.57.1701183262958;
        Tue, 28 Nov 2023 06:54:22 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001bf11cf2e21sm10281552plg.210.2023.11.28.06.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:54:22 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 03/15] KVM: riscv: selftests: Add Zbc extension to get-reg-list test
Date: Tue, 28 Nov 2023 20:23:45 +0530
Message-Id: <20231128145357.413321-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128145357.413321-1-apatel@ventanamicro.com>
References: <20231128145357.413321-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM RISC-V allows Zbc extension for Guest/VM so let us add
this extension to get-reg-list test.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index b6b4b6d7dacd..4b75b011f2d8 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -44,6 +44,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SVPBMT:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZBA:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZBB:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZBC:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZBS:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICBOM:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICBOZ:
@@ -361,6 +362,7 @@ static const char *isa_ext_id_to_str(const char *prefix, __u64 id)
 		KVM_ISA_EXT_ARR(SVPBMT),
 		KVM_ISA_EXT_ARR(ZBA),
 		KVM_ISA_EXT_ARR(ZBB),
+		KVM_ISA_EXT_ARR(ZBC),
 		KVM_ISA_EXT_ARR(ZBS),
 		KVM_ISA_EXT_ARR(ZICBOM),
 		KVM_ISA_EXT_ARR(ZICBOZ),
@@ -739,6 +741,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
 KVM_ISA_EXT_SIMPLE_CONFIG(svpbmt, SVPBMT);
 KVM_ISA_EXT_SIMPLE_CONFIG(zba, ZBA);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbb, ZBB);
+KVM_ISA_EXT_SIMPLE_CONFIG(zbc, ZBC);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbs, ZBS);
 KVM_ISA_EXT_SUBLIST_CONFIG(zicbom, ZICBOM);
 KVM_ISA_EXT_SUBLIST_CONFIG(zicboz, ZICBOZ);
@@ -761,6 +764,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_svpbmt,
 	&config_zba,
 	&config_zbb,
+	&config_zbc,
 	&config_zbs,
 	&config_zicbom,
 	&config_zicboz,
-- 
2.34.1


