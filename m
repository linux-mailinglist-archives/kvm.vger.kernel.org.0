Return-Path: <kvm+bounces-44406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF9C0A9DA4D
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBF149A270D
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67E5227EB2;
	Sat, 26 Apr 2025 11:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GwsE20Rp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABBA21D5B7
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665468; cv=none; b=sttvbqDBl9TcvuHBR4+3036SbPLgDFL88guUGzpIJMooVhS4uxJkeOhscahEGlImoX8dTwgEZR3Rpn6mCZXQhHVIUMAC+qMcnHtgk8tnFktrRDY06a8BSaXfh0YizuVeArLxe//D0NsGWY3QcYExmk32qIF5SXVfC9EsJ5nppfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665468; c=relaxed/simple;
	bh=Z7kCb0CH7JESphENtfsMMJsw4L5SG9NdnuxZle6za4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAxWI1S+ZwbT5lRl6vCmqV3mfgoYz765La1MpyNVSvntwzeVz4iAnEiJGWjn/cyS0qVIm7RpWpPlNsk/jRcWu6SqnO4tzzWrsnWYtZwWtSY2ach4i59ohvwh82NKESeUhi11HgK43WSgjqAZY4klnY6ZbshC3yyYaabtGGSrEEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GwsE20Rp; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-227d6b530d8so35827775ad.3
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665467; x=1746270267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpgStyTcu6ohuguHcXTsVTGNp1bnGO1cAa+NtUp6vks=;
        b=GwsE20RpzrlC9GQiO9JeSlip1toNnnu+j+yxBAVBT9QrpyjPM+2YEBJg0CtcTJtL1a
         ICitQmpBq3m4USuIKg/4sh80oqgf9ONUydDeHCobrCUdU1zivd/yRgShOBN3d2Q7jH5p
         KOKQBYjnHBtUmgzDxXZl1+gPhvR7YecP5yVngdmYoNN7qbAI1b+GZ1CYBOF4hpxcUlkB
         RWhv/L8JPGKsHA2ZuVfd9rPdGbByLYqNyXNDHdW2gwYpkdh/lvwvkhk44oWVLHiKAGBl
         9/hnI4nDdpJQes9QnS44r75WxyJ4ejwoOvoQV15Xp9/yRmHDaO4fk/K7SDCKV94honKR
         R5Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665467; x=1746270267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qpgStyTcu6ohuguHcXTsVTGNp1bnGO1cAa+NtUp6vks=;
        b=flpD7ccB5WXkH3+RqIeBMyGktiFtXkCLaRVp6hcSPpfnlZyrEzoGtQMKlJyB+X3gmL
         Z8CEuMrJzUR5/xTDd5ppNoFahXCe7sDTscMhkUax8Qj9zAAEkLYdRxh9VN1F07/a0ioG
         yV0J4VklF4PX7fdowhGZ2hUpdDoCrKTV2Un1r7WK5Fk/kCCIYj9k+FdK2lSVrTCQvz9c
         baQynof4QI8NHyjro8nYlzrshc5bJSb9BbCubqsC9+TlrQRxrrAus5z8ZnNnZLoLkfmS
         RQ8noM0417D9/yfsH5n8N5a/J6R7c0sFbRLv2QZoO4Pq/9pvLKCscSHG+IZRPaaGyIt6
         qBtA==
X-Forwarded-Encrypted: i=1; AJvYcCV7Uychp5rzIeKEqoBgR5Ai5CnmMVpuvWvFWxl3BsGJQDamOYpBoUOdSJcVIGXkwCHBEgc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaJYPvHn7okctqFbMjqTkijpxwfkOaONd2IjzPbsIKw7ma6QZv
	rYvHqCT+KoSgUHwRh49e3ROCGag4MHKGt/yyfaIcND/wV2TMWp6xHbkpvDkIeDI=
X-Gm-Gg: ASbGnculyOs0k/9WrYDJXhZe3A1r/C6AlLp2AbHJl1IRbBSSkYcisBkdulR2S/WwBLe
	S1OiM1GCUfJVxNYdPwhdZ7GybeKm8KLLunNHF7miHeynvRvHNbvIE2As2j+r9/j02QqGNFxKiKd
	teHc4LaMiwA4VGA8E+68gD9e9EMnGBU00Pzi82hNWJPiE/4wLp0WhAYsRVxrxgdpLiWlTdSN9Yg
	8C1C/qV4h4oY02X1r72amY1bbR53YyujicZpkiBaWlewgoWObIMTYkQ/FiPlltpc8XrN+xK41fl
	x4VtO0dCame70GB3ys/6Aw6S7PvdkHD1iIzFIesvwxJ1Z4QdJrY00yJf3UjN2ybYtOU3zcIrPy5
	i9Iug
X-Google-Smtp-Source: AGHT+IHY+MWooXBudXe6/FxvZppRhx+JScomLCpPvE4NndfOyCY9KevTgUJayj3I4wHjFdFKIRZh1w==
X-Received: by 2002:a17:903:1a24:b0:224:76f:9e4a with SMTP id d9443c01a7336-22dbf5ef699mr91723255ad.14.1745665466641;
        Sat, 26 Apr 2025 04:04:26 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:04:26 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 06/10] riscv: Make system suspend time configurable
Date: Sat, 26 Apr 2025 16:33:43 +0530
Message-ID: <20250426110348.338114-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
References: <20250426110348.338114-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

If the default of 5 seconds for a system suspend test is too long or
too short, then feel free to change it.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/include/kvm/kvm-config-arch.h | 4 ++++
 riscv/kvm-cpu.c                     | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 0553004..7e54d8a 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -5,6 +5,7 @@
 
 struct kvm_config_arch {
 	const char	*dump_dtb_filename;
+	u64		suspend_seconds;
 	u64		custom_mvendorid;
 	u64		custom_marchid;
 	u64		custom_mimpid;
@@ -16,6 +17,9 @@ struct kvm_config_arch {
 	pfx,								\
 	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,		\
 		   ".dtb file", "Dump generated .dtb to specified file"),\
+	OPT_U64('\0', "suspend-seconds",				\
+		&(cfg)->suspend_seconds,				\
+		"Number of seconds to suspend for system suspend (default is 5)"), \
 	OPT_U64('\0', "custom-mvendorid",				\
 		&(cfg)->custom_mvendorid,				\
 		"Show custom mvendorid to Guest VCPU"),			\
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index ad68b58..7a86d71 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -228,7 +228,7 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
 				break;
 			}
 
-			sleep(5);
+			sleep(vcpu->kvm->cfg.arch.suspend_seconds ? : 5);
 
 			break;
 		default:
-- 
2.43.0


