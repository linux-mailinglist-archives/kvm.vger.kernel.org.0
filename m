Return-Path: <kvm+bounces-2640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6D47FBD84
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:57:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9552B282F29
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 065455CD27;
	Tue, 28 Nov 2023 14:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GVsmJRCA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08DD127
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:57:16 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1cfafe3d46bso31772065ad.0
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183436; x=1701788236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7BCkDlEadkuDM5M9mJaJ5lnCVNpUbfkuweY2LH7cKc=;
        b=GVsmJRCAtoR3MQi+OtiL3wfp4Y+FxWb9RXhWhx71hUFI4nYmCuae6lQvyTPVpCa2Sa
         Y7m3sZ/UmAs56n+GG4bb3UnicNwHRMwA+2BrVeYRP43GeS4VPJPjJn6r+YZLmt946cl1
         1j8gUEStnV/U2qXbZGV0lbwY6SWsnDMRpeethyW8tXvowvadnOQPA9gTHhWjNtRSKpFH
         nXqHxxMhNWm/UBxfvbxE7fErscPaY9QRB2Oh7NxwvVMkctWU+u1+XErRCXaLHh29MTpQ
         DhzjUTskXlHVd6OmbTzIRIqFI7nzRbk6ZoyDzyyixE/s5tdmAJWOrZEb7IoBoiGxJTpm
         zvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183436; x=1701788236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O7BCkDlEadkuDM5M9mJaJ5lnCVNpUbfkuweY2LH7cKc=;
        b=gTJO6CrcBdr/45EpsATC4s5uCiQH/GYnzxK5bBkbrM5l31eAwiB5TshrDpCo0F9D0/
         IIKZpn8Pv0CQEkWGRTNI+3XysKDaQA2woaSZr7nC3/P5fMNzXye0hF6Kkr2DXIGk08lF
         FhO+uOCqrqfTAUanU1Ki3xAPxM/71th+JUT35PxD6h+KvIXQGGeN0JzEmk1m0oEaa6PA
         bcTTMigoXwXZt/6uZh+WhWA1kjO8IUQGTYGOyXAKeTQ7xIPmpM/EwGO9MiDXFI1YKDcI
         g2ya/MKueXQKXKmvYSUcmPzRHusXqRzsWqy9wF+WdPmabvwlrjNXd28zEmSHTZvCnGO0
         hSaw==
X-Gm-Message-State: AOJu0Yy46RJlYrnZDqJ+VxWA8ErTclBOktXkVfoR5Gt7Si4zALKK6AuN
	qfFedSPA6IGvUCpLj26g+faLqg==
X-Google-Smtp-Source: AGHT+IEddxVCpbDyl7DSz4+wlRdml0wvPHO0ZR3csY2RtvrNL6EiXNiXdE42jWS5zvFJZJPvZKBDuQ==
X-Received: by 2002:a17:902:bb8c:b0:1cf:a8ef:df8f with SMTP id m12-20020a170902bb8c00b001cfa8efdf8fmr13087800pls.68.1701183436017;
        Tue, 28 Nov 2023 06:57:16 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:57:15 -0800 (PST)
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
Subject: [kvmtool PATCH 09/10] riscv: Set mmu-type DT property based on satp_mode ONE_REG interface
Date: Tue, 28 Nov 2023 20:26:27 +0530
Message-Id: <20231128145628.413414-10-apatel@ventanamicro.com>
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

Instead of hard-coding the mmu-type DT property, we should set it
based on satp_mode ONE_REG interface.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 1124fa1..8485acf 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -57,7 +57,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 	int cpu, pos, i, index, valid_isa_len;
 	const char *valid_isa_order = "IEMAFDQCLBJTPVNSUHKORWXYZG";
 	int arr_sz = ARRAY_SIZE(isa_info_arr);
-	unsigned long cbom_blksz = 0, cboz_blksz = 0;
+	unsigned long cbom_blksz = 0, cboz_blksz = 0, satp_mode = 0;
 
 	_FDT(fdt_begin_node(fdt, "cpus"));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
@@ -125,15 +125,45 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 		}
 		cpu_isa[pos] = '\0';
 
+		reg.id = RISCV_CONFIG_REG(satp_mode);
+		reg.addr = (unsigned long)&satp_mode;
+		if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+			satp_mode = (vcpu->riscv_xlen == 64) ? 8 : 1;
+
 		_FDT(fdt_begin_node(fdt, cpu_name));
 		_FDT(fdt_property_string(fdt, "device_type", "cpu"));
 		_FDT(fdt_property_string(fdt, "compatible", "riscv"));
-		if (vcpu->riscv_xlen == 64)
-			_FDT(fdt_property_string(fdt, "mmu-type",
-						 "riscv,sv48"));
-		else
-			_FDT(fdt_property_string(fdt, "mmu-type",
-						 "riscv,sv32"));
+		if (vcpu->riscv_xlen == 64) {
+			switch (satp_mode) {
+			case 10:
+				_FDT(fdt_property_string(fdt, "mmu-type",
+							 "riscv,sv57"));
+				break;
+			case 9:
+				_FDT(fdt_property_string(fdt, "mmu-type",
+							 "riscv,sv48"));
+				break;
+			case 8:
+				_FDT(fdt_property_string(fdt, "mmu-type",
+							 "riscv,sv39"));
+				break;
+			default:
+				_FDT(fdt_property_string(fdt, "mmu-type",
+							 "riscv,none"));
+				break;
+			}
+		} else {
+			switch (satp_mode) {
+			case 1:
+				_FDT(fdt_property_string(fdt, "mmu-type",
+							 "riscv,sv32"));
+				break;
+			default:
+				_FDT(fdt_property_string(fdt, "mmu-type",
+							 "riscv,none"));
+				break;
+			}
+		}
 		_FDT(fdt_property_string(fdt, "riscv,isa", cpu_isa));
 		if (cbom_blksz)
 			_FDT(fdt_property_cell(fdt, "riscv,cbom-block-size", cbom_blksz));
-- 
2.34.1


