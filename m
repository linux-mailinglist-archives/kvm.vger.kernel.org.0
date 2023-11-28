Return-Path: <kvm+bounces-2619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07C137FBD57
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:54:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B50BC282EA1
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4BE5C09C;
	Tue, 28 Nov 2023 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RwnLmE4r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D57A1BC8
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:54:28 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1cfc9c4acb6so19533965ad.0
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183268; x=1701788068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqxVg8l3Hg6Frv7KJ86Slj6nrb0o+W/dOYeQGaFJwTE=;
        b=RwnLmE4rkrQMvGRi/+5v+L5fyf0KqiEjfivfQtk29e0o0NlGtHVDzFrB6WV41va5Dn
         37UM8/GTdAKsQy0/2BdVsa2BlEZS5DkVJ48dgSTjILpcoVXEjeDSgsQ6Mun9i0Muicux
         vuM3jpyyYilBA1VRqPD66VZwX1gqUKNB7K4bwD6tfH+qGzXRZPCXbrF/+m7ixduyEel4
         DqEdlwhbzt7ppX++rAwqaxfi5mi4vfwtvJmLLVHHFyPdrRl3zulTyl859b5Segj4HpPD
         nppb//Ov0jqf6FS6C8mjsD/Ajyns9q/NbmEPe1DD0aX79WeJbCBST3Dt2CQTQPVcaSAq
         tfSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183268; x=1701788068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vqxVg8l3Hg6Frv7KJ86Slj6nrb0o+W/dOYeQGaFJwTE=;
        b=YjU4ag+yS1Be/D7aYFn5X6iT83xYamJotUupPt8+S1Q72znbYlAMka3pEkCVxeXdzL
         jCFqHcEL4oaKRk/qtoqmkapuZTBcbNig5JVQMuVmNVkRvZv7irMPqlHA6DjXi0uXuQtA
         TdfCgrBB5JXXh+TuIw9Rd8Dt+XJIJU3UKeNwtL3LKnQaVl4g1WVoBbEKSELEU3E8MuBS
         W4wDk/OOSR8DqKSL2NBuoPRo2/m+GvYFz8VvMf0hMcZjoeLaqBpLNj8EWjaokBI89q24
         2qvDb70lEwLcSo6ecSh8FUc6/tF3AulsUJ3qPhghlRPpwo624hd10afijrks96IJRN2k
         5oWA==
X-Gm-Message-State: AOJu0YwjahPypxhzC/XpyMu2pJ6KVbZawONtFUd8wDnEAWN51Fh9w8uZ
	D/YKhJiPequR+oPxJWO+B0Zw2g==
X-Google-Smtp-Source: AGHT+IFcoaA2hxnFbXCCUocOR1sG99CREnANM1PmTY3hLfSSQRNudLUWraMAAhbsdJoHp2lrLA44uw==
X-Received: by 2002:a17:903:11c4:b0:1cc:4072:22c6 with SMTP id q4-20020a17090311c400b001cc407222c6mr17937667plh.24.1701183267919;
        Tue, 28 Nov 2023 06:54:27 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001bf11cf2e21sm10281552plg.210.2023.11.28.06.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:54:27 -0800 (PST)
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
Subject: [PATCH 04/15] RISC-V: KVM: Allow scalar crypto extensions for Guest/VM
Date: Tue, 28 Nov 2023 20:23:46 +0530
Message-Id: <20231128145357.413321-5-apatel@ventanamicro.com>
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

We extend the KVM ISA extension ONE_REG interface to allow KVM
user space to detect and enable scalar crypto extensions for
Guest/VM. This includes extensions Zbkb, Zbkc, Zbkx, Zknd, Zkne,
Zknh, Zkr, Zksed, Zksh, and Zkt.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 10 ++++++++++
 arch/riscv/kvm/vcpu_onereg.c      | 20 ++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 518b368b41e5..7b54fa215d6d 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -140,6 +140,16 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SMSTATEEN,
 	KVM_RISCV_ISA_EXT_ZICOND,
 	KVM_RISCV_ISA_EXT_ZBC,
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
index f789517c9fae..b0beebd4f86e 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -43,6 +43,9 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZBA),
 	KVM_ISA_EXT_ARR(ZBB),
 	KVM_ISA_EXT_ARR(ZBC),
+	KVM_ISA_EXT_ARR(ZBKB),
+	KVM_ISA_EXT_ARR(ZBKC),
+	KVM_ISA_EXT_ARR(ZBKX),
 	KVM_ISA_EXT_ARR(ZBS),
 	KVM_ISA_EXT_ARR(ZICBOM),
 	KVM_ISA_EXT_ARR(ZICBOZ),
@@ -52,6 +55,13 @@ static const unsigned long kvm_isa_ext_arr[] = {
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
@@ -94,6 +104,9 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_ZBA:
 	case KVM_RISCV_ISA_EXT_ZBB:
 	case KVM_RISCV_ISA_EXT_ZBC:
+	case KVM_RISCV_ISA_EXT_ZBKB:
+	case KVM_RISCV_ISA_EXT_ZBKC:
+	case KVM_RISCV_ISA_EXT_ZBKX:
 	case KVM_RISCV_ISA_EXT_ZBS:
 	case KVM_RISCV_ISA_EXT_ZICNTR:
 	case KVM_RISCV_ISA_EXT_ZICOND:
@@ -101,6 +114,13 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
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
 	/* Extensions which can be disabled using Smstateen */
 	case KVM_RISCV_ISA_EXT_SSAIA:
-- 
2.34.1


