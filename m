Return-Path: <kvm+bounces-3437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9451F804536
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5052D2814A0
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6827779F2;
	Tue,  5 Dec 2023 02:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Y+ciD/tN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD386A4
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 18:43:33 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6d986a75337so1268313a34.1
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 18:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1701744213; x=1702349013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESe2+H6xRcIvQHZC4sCC1Ujc/nu3bNcuHE36+amdpNs=;
        b=Y+ciD/tNCJQ8NcC2aGaOUHpwaeXN8Bf4qOEpdx8qdaMxXj+XhQ0CJGVcbaW2iopBha
         EWPptcxKOXaAIF44bTipFnQAzSBJax29OwbCbYsdm96LVzlQqU34IvNM2H5mDmVLqJW9
         ctBByOzacU7BTiAoLrbLg0SDJIktlQUEnFSX4nvhA/HGoXe2XF2M0rbLeYyqZg/Gvuht
         AjCdMW3YlZt29/NrIT3WYz6bIbU/ERucE2PS0Qp6SNUk0hGWCXp2WGOwN6EO1aOGAgVm
         S1T1NEUI/PzvYqnC0uBE6LbmffXt8h5AUhB/S1hoJNQPP3xlWCHjN1+RyJ8JL/bDnxTW
         e3ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701744213; x=1702349013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ESe2+H6xRcIvQHZC4sCC1Ujc/nu3bNcuHE36+amdpNs=;
        b=rN6VvW690AXF+5msxVDswoJFO6HBr9YThsmHgRk8r56KcuWRm0uS94+YwiA0nAJ0X4
         ewVqU7VBVTMyZP2MZcYtQe5xUIMWVc5IcNaVmlE7vwU6yYSqyZRF549P0yum38S3XCdS
         MTbfS0PPQrRtakQLjpqjGJL5hlI6z2oE4/WYTgOz/4Eq77QkdmRqN7knGAN9pAdFXsuV
         tLKSLbvz4ajvpNZJXGyNWAgZ1G7AVhY3vGbU6vJAkyYH73z7IhxkvxrFUzcwMxK5V2I4
         Zr+qGukul99ksWa2njvrQwjW41TXQXTBBIfYMyTB93xNFt7Z2LfmGH7t28ouXX6w8TIe
         tTqw==
X-Gm-Message-State: AOJu0YwXX7LRWDZY9THU2T4tCIz8foYOyCMXk5e1nbo3V/iuHgx34rl4
	0BOPI8jSEV3JChm3P0YYnGt6xEEZXZtrQ2RVwGF//A==
X-Google-Smtp-Source: AGHT+IGEgSVldCBVjabdNWyXSrgKexmOSpdOUxfqb+i3/FDPH6nx8GslbA4iHobHadY6ni/KUBPIug==
X-Received: by 2002:a9d:748b:0:b0:6d9:9ef8:84b7 with SMTP id t11-20020a9d748b000000b006d99ef884b7mr2852315otk.26.1701744213065;
        Mon, 04 Dec 2023 18:43:33 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id z17-20020a9d62d1000000b006b9848f8aa7sm2157655otk.45.2023.12.04.18.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 18:43:32 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [RFC 2/9] drivers/perf: riscv: Add a flag to indicate SBI v2.0 support
Date: Mon,  4 Dec 2023 18:43:03 -0800
Message-Id: <20231205024310.1593100-3-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231205024310.1593100-1-atishp@rivosinc.com>
References: <20231205024310.1593100-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SBI v2.0 added few functions to improve SBI PMU extension. In order
to be backward compatible, the driver must use these functions only
if SBI v2.0 is available.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 16acd4dcdb96..40a335350d08 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -35,6 +35,8 @@
 PMU_FORMAT_ATTR(event, "config:0-47");
 PMU_FORMAT_ATTR(firmware, "config:63");
 
+static bool sbi_v2_available;
+
 static struct attribute *riscv_arch_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_firmware.attr,
@@ -1108,6 +1110,9 @@ static int __init pmu_sbi_devinit(void)
 		return 0;
 	}
 
+	if (sbi_spec_version >= sbi_mk_version(2, 0))
+		sbi_v2_available = true;
+
 	ret = cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
 				      "perf/riscv/pmu:starting",
 				      pmu_sbi_starting_cpu, pmu_sbi_dying_cpu);
-- 
2.34.1


