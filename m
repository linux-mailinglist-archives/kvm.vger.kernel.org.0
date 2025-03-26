Return-Path: <kvm+bounces-42026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6FDA710E0
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:58:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58B6717411C
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD4DD19D892;
	Wed, 26 Mar 2025 06:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="FHWgWhpt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E9B188734
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972239; cv=none; b=UyI1fXp2S/q6+i+lVkSIlLCRZua044eTxzsLSXarGaNcEWISNhmPh1lgJiV+3TZVUXiE9qanXJbUH8Jz76srFdZTsLlsu4Xqk6AprUe83QEGkLUBeATT5P3DFUHUxSAZjIDBS+jGxyETnEJrmiQXNPr9utGhByZnGM+sxF5qrAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972239; c=relaxed/simple;
	bh=Z7kCb0CH7JESphENtfsMMJsw4L5SG9NdnuxZle6za4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcINf2drR+y8Is8J+DiZA8toCqMi6UnLzHj0j4kJiabjgocSZ0J03n1wu9g5v/8n932YYxUrTZ9w/79Rhu3Ea9ePUDbDeTryYUbifyU58z4Qx+fOiJH9r0W+IGwvslaamGh5QYcCqw5yF8scqE/sg3FSCLEj6do6uE+BM4nZ+ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=FHWgWhpt; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22398e09e39so133244015ad.3
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972237; x=1743577037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpgStyTcu6ohuguHcXTsVTGNp1bnGO1cAa+NtUp6vks=;
        b=FHWgWhpt9FLgdnR6cNl9gEL83DtCxDp5bTo7UIP6EYuOv+e0JtiCmBIXatB8834QNw
         RtoXNel/f3kUoi3QxR0t1K0SMgmkDLUgJ1JvuCTtMieewCfYH6+t0hEc2Sj3s8ec5wzL
         ky7aPLDjkp4Wma/OkkpfOKdNwNtI2On8Qnn/jjMrKD9sEj0a7xLDhqId4VsFxPm2ampG
         c79XQDVSXnIoCVHwwsXBCgUWRI5ONvurnXdPQutTBwdyi2ZZt2u3dFaMw1qHG8visI/j
         VVpBN9rz/dMhKGQ4TBoI05DQAMg4cv1TQCdm85xfW6SgKUwBjPrJ8zMzIQwMCva/mw1t
         BeIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972237; x=1743577037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qpgStyTcu6ohuguHcXTsVTGNp1bnGO1cAa+NtUp6vks=;
        b=fH1WqWUV312FNAQR2cyczSkLF+p66GMrZGBxYWSRp1P8BnJHJXXaXY0YVVToP4A4mH
         vEjvEKfcP0kqtTWGO32RTJZORJGzXK0yPeALhwfCn8Qp4RX0+h+ehk74+BnniOWsk8LS
         rR37zSH1RhQD86S2MJCu/m0Z9K6CAPTe/eag6WiNtRZwr+ke32En/6cTFa705e3JSOWM
         u5xdo503GGw/5Y2b1xqzQ3MeIxiX3Dzs2JXwvjEAjq82QnFb3elERy+/IpCJqeRnJpyL
         ucxxZ+5s/IqRKoXi6y0ZGCK/Id83lz3rrfWoWF7ZmGBcaa2cn++z2txlXTMFFyQIC7Un
         PPig==
X-Forwarded-Encrypted: i=1; AJvYcCUo1gT0YZrKhtWy5YvuMAclTeSigF2lc554mPgC7Oq5bPTm9Q3HZw0PW+RaPWBRkFXkyQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPsJHZZNxOyrhJ4bZfpItfwdd8uCFfrQU5PODotEewVy3Ip6TC
	VDRtv+47YXXkiLFe37skdMEhwZpUwav9pwYCMgM2W+lB7uVBWQAP4LeLXGMv3ig=
X-Gm-Gg: ASbGncvpj9PV7h0v5GsH7fx9WiXi7ukEa6GibSfrWLq1CMLLZbZ5mvZJubSWv87QI6o
	rkPtfgfPXWR7LESv1mETxYemEQwB6eLdwaJKUjTCJRGo2KpnEndCpZg3SpWN3lwiIHgqOlUq7oM
	dyRHNS1ojxtipmtSC//Sc4UsPAW+n2nCiQ/GX2ylX/nfXmmeehfmJjt2N2MgAw8ZbPv7FVx5uwy
	5CqLP9S7LilOs7WGBYbFdtyBeowUx/E3BZjN+tTDSeeb86ZaWfnVYGcL0RqUFbFYQXfw45icvOO
	2A+/9lOgkjowkVfDwLuS+20PjUkFRlZXXQL0SaIklnnigz66u+F2AwYSPA4FmCt4TgLKICY4ozV
	GBuUOferLuWi1W531
X-Google-Smtp-Source: AGHT+IGuMr6un5BMFt7acfamIOQ5qad6lUuhEqtX8+veIxEaoNVnhVBSqdim6LjqJMmMoNsGVYVLjA==
X-Received: by 2002:a05:6a00:1812:b0:736:6151:c6ca with SMTP id d2e1a72fcca58-7390598df4emr26325730b3a.4.1742972236720;
        Tue, 25 Mar 2025 23:57:16 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:57:16 -0700 (PDT)
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
Subject: [kvmtool PATCH 06/10] riscv: Make system suspend time configurable
Date: Wed, 26 Mar 2025 12:26:40 +0530
Message-ID: <20250326065644.73765-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250326065644.73765-1-apatel@ventanamicro.com>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
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


