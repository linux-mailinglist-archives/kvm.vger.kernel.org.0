Return-Path: <kvm+bounces-2634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B32177FBD7E
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:57:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56170B21BBD
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ABCC5C915;
	Tue, 28 Nov 2023 14:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="QJz/2YdX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58F91BD1
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:50 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1ce3084c2d1so46216965ad.3
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183410; x=1701788210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FgjoNrqFDNIe7ian9OPihopZ/0iJ0MZOML4kaPf+Pyw=;
        b=QJz/2YdX5Lv/5MpohPVnL9WoC//yB/cDdP47e19mbOKkAgtNUF+p6oHE17n7LwjMEq
         93l5iy8JgR+ao4VfVxrSL3UuKTlmeFcJnqpCZ5mBvnxko3vH6wr9SwFA8i1Q4lQE7W4D
         IIL5eQLYTzUEsRgoDcTMeVf+TrV4kEkfHKgZMy/otmUHXNh1SKfwJ7RMKXVI5k1Fs53S
         HS3WNznxmjEc25tEG2Yfj117Be0ul0CHeoswA0x9kDLYYmrX5MO9N6aVJZAb0lHcuP7C
         I6sG640XNfG20RhE4oGfshgBGgP7plf7l6oPtz4DaTpRkd65NVmtl5p6wvq+yVlXUxH3
         gKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183410; x=1701788210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FgjoNrqFDNIe7ian9OPihopZ/0iJ0MZOML4kaPf+Pyw=;
        b=liOXFlLTee4osiihGCWePiK04trYZ7zuVmMxbX5V8T9bIVmDO08W1/RHUG0GG3mAP+
         kwrREAjxL9j0Ct+RpmtrmkEmE5OIGZlaXNkyzsFDkQ7bECqc0KIKdHqndJA2N2k9XErm
         CTEsOjYcY6Rq2JTPLPmTS+UFyHUQWUqzG/MEai3GSVqtbyAbevv9xhXWpCkjgXS7BFds
         8zqgqXifVDtumLGV8jvIyFtohbpcTjfg/5AlUC+3zJ60GOwALI9AyL93W/WqfmekK9dw
         UKJNqa5PULLqpbpTuzSIvZeJtg92yI4fCZx9vWz7/YjfCJQtqyBgtG9G7myd8ZnmDxSQ
         0GXg==
X-Gm-Message-State: AOJu0Yznk9B4gZ9We6y0qcvCqciuoklCbIrONiVPG5oNSi8Ajc3SYsLk
	ivZtSSOKes+MnpMupGi/S1FrBA==
X-Google-Smtp-Source: AGHT+IHgigFZ6pNkcrRyi5Kih3JjvCGjjnKNVK7ixGDK5KkCRRVdCD8e5XtNe/xEko9S/RpSC6SLuw==
X-Received: by 2002:a17:902:f64d:b0:1cf:61c8:73e9 with SMTP id m13-20020a170902f64d00b001cf61c873e9mr21345331plg.50.1701183410129;
        Tue, 28 Nov 2023 06:56:50 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:56:49 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 03/10] riscv: Make CPU_ISA_MAX_LEN depend upon isa_info_arr array size
Date: Tue, 28 Nov 2023 20:26:21 +0530
Message-Id: <20231128145628.413414-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128145628.413414-1-apatel@ventanamicro.com>
References: <20231128145628.413414-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the CPU_ISA_MAX_LEN is a fixed value so we will easily
run out of space when all possible ISA extensions supported by
KVM RISC-V are available.

Instead of above, let us make CPU_ISA_MAX_LEN depend upon the
isa_info_arr[] array size so that CPU_ISA_MAX_LEN automatically
adapts to growing number of ISA extensions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index b45f731..230d1f8 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -44,7 +44,6 @@ static void dump_fdt(const char *dtb_file, void *fdt)
 }
 
 #define CPU_NAME_MAX_LEN 15
-#define CPU_ISA_MAX_LEN 128
 static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 {
 	int cpu, pos, i, index, valid_isa_len;
@@ -60,6 +59,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 
 	for (cpu = 0; cpu < kvm->nrcpus; ++cpu) {
 		char cpu_name[CPU_NAME_MAX_LEN];
+#define CPU_ISA_MAX_LEN (ARRAY_SIZE(isa_info_arr) * 16)
 		char cpu_isa[CPU_ISA_MAX_LEN];
 		struct kvm_cpu *vcpu = kvm->cpus[cpu];
 		struct kvm_one_reg reg;
-- 
2.34.1


