Return-Path: <kvm+bounces-43571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D240A91BEA
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4A7619E4929
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56953248892;
	Thu, 17 Apr 2025 12:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Gvcv5E0q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EA9245002
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 12:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744892677; cv=none; b=g8NVAgA7qxzShnKnYP79J1LB1BX35BX70Hdhj592Ey+NgPXGOgQ7tg3lX/eMomphQ/CocTcgMdzvAOh2B+lhVy+l0DG/AE9IER6xlx1pO0e2zQbSaExaivCYfhNSpcidlicN58yr6IWYI2VP7sQ2m2HMbGE9QioJ4y19mQncpwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744892677; c=relaxed/simple;
	bh=qJu1m4hx4nbu+oDFlDHA2hR7AvuynQAz0skV827DhvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RK8li1Q8t3mI4xHjJsFkHdbjWsNC7xDjtEYPu4KVBfwysgWVPsgw7FTvcCQPUQgiaqMDEQy/1KnP12vxoIgXWZsi6hV0t8OynU4Go/sTIqqbnllB7nrldKaibEL/IXZ6lUD176j6icLV+R84lEf/bzeBZxuUfQA8kgnt3XiYI3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Gvcv5E0q; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-224191d92e4so7402735ad.3
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 05:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1744892675; x=1745497475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DkvRtqiwpGFu2F2LneoosRxgLPIUe40LOw9HI4KIxXc=;
        b=Gvcv5E0q7WqcEvNo6Eg5joSeG01Iyyd0lKPavaMmhHr3u+PWN0xV4mFwfqRmSAB30o
         qUA/7LCPqp9+QlScp8y/95J/eJVwK0D9OOeSI+nioht74bY6oFljLxmg5DfM30v+BIgc
         HMtT4jD8vCrKvRau9K9pGlwr4rM0LIkBcAnnTeei9YX/fLZVzAFVztfaej6wQrqlhMLr
         sNlD+LX94iVvxutP4h3nLBAFrgSwiCLj3JTa7dOt2qVfnjEjR+aIuwugOicZriRCSGac
         plf9mnYgKJMqhWn5eQHTdulbIo8C/gL8d9/wX8ZCjUPcHzDFbq/GCc2rGkQL+YL0hhEC
         iTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744892675; x=1745497475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DkvRtqiwpGFu2F2LneoosRxgLPIUe40LOw9HI4KIxXc=;
        b=vEf8qH8YIwSBcI1WgxUeZq9yKIjiJIEsp3QWcVw7vo8lq+YDECpL/xB81xSYPb/5EG
         E2NEiA1ZKk7gP5gR722nPYTnCARnFvhGavJpln8yTNXOJlxynQh/188QtHf0jm3DBXR2
         Yk8O+ra2D4/1wYhvV2W5XGHBNZWDNk1zER65iaavULwkLNkfvRfvflyqoz2GzMosWBFl
         q9WkCjR7BkbooafnzVBYVeno3uF6zSkTCNLvzA42TPhmqcuoA56dxkGVP6uOlaCdstd4
         wMfJ7ifI4uS2P3gxa8rHO7S0wQXRVtVUpXnWyheOgzRc6ah1YH1aXSpQQU9v/Qoj/6jR
         qlew==
X-Forwarded-Encrypted: i=1; AJvYcCVBYf0jX/XrzLVQ8TGE6ed24MM7iJ8IWFvtnmZ/Z0Dn0rSMV1/Qa0qlrKeHxjhyeGkwuR4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzb26F6t00rOHi2G1iuJ0UTCxzvSH3b+5KT3X0MKGEh5AyJ9Bq
	zhlWUZoO1WUXvp/4lDgm/WCOfxuG0Rs3MrvAkSBhDDO6yVCAkPUHm2PBgqZ6zIg=
X-Gm-Gg: ASbGncsMo7QV0NEwb4XyUr7B6S1oc8KNs6YgE2LeQ9z9qBKc5v2iq3ywBRyX0d8EFpL
	WN7CUuU8UM5Sx4sGHdlONZi3OsVLxT5uUwG05M3G4+/rPG8/Ht6SFltlGsVDWBnNuDYl7fC/oqB
	JeutiVLQI30x4gcz8cRR5B8KCdYdLJNhF6QixtWXeJ3fa6xyVlzJbO5LE1lae08QL0ptaBxxh//
	TjniOXMYSrofQJQcWKHPjDTP3/1n9Hp7rnNhdqRgr+qUaPkbZGwm8alCo8sCOnCVCCb/CWlS35H
	nL41/kkSDdIy5zqPaRIYqESa64YClsVIrVayomXWzg==
X-Google-Smtp-Source: AGHT+IFwoPNkZRHRLCRUuOqGDF2uiHAGyCvd3q8quDmBUyk1f/F/4WvIpLrbGYXfNhaC6uEF0f4feg==
X-Received: by 2002:a17:903:2447:b0:227:eb61:34b8 with SMTP id d9443c01a7336-22c35916f13mr99932925ad.25.1744892675059;
        Thu, 17 Apr 2025 05:24:35 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c3ee1a78dsm18489415ad.253.2025.04.17.05.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 05:24:34 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v5 04/13] riscv: sbi: add SBI FWFT extension calls
Date: Thu, 17 Apr 2025 14:19:51 +0200
Message-ID: <20250417122337.547969-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417122337.547969-1-cleger@rivosinc.com>
References: <20250417122337.547969-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add FWFT extension calls. This will be ratified in SBI V3.0 hence, it is
provided as a separate commit that can be left out if needed.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/sbi.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index 379981c2bb21..7b062189b184 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -299,6 +299,8 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
 	return 0;
 }
 
+static bool sbi_fwft_supported;
+
 /**
  * sbi_fwft_set() - Set a feature on the local hart
  * @feature: The feature ID to be set
@@ -309,7 +311,15 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
  */
 int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags)
 {
-	return -EOPNOTSUPP;
+	struct sbiret ret;
+
+	if (!sbi_fwft_supported)
+		return -EOPNOTSUPP;
+
+	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
+			feature, value, flags, 0, 0, 0);
+
+	return sbi_err_map_linux_errno(ret.error);
 }
 
 struct fwft_set_req {
@@ -348,6 +358,9 @@ int sbi_fwft_local_set_cpumask(const cpumask_t *mask, u32 feature,
 		.error = ATOMIC_INIT(0),
 	};
 
+	if (!sbi_fwft_supported)
+		return -EOPNOTSUPP;
+
 	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
 		return -EINVAL;
 
@@ -679,6 +692,11 @@ void __init sbi_init(void)
 			pr_info("SBI DBCN extension detected\n");
 			sbi_debug_console_available = true;
 		}
+		if ((sbi_spec_version >= sbi_mk_version(3, 0)) &&
+		    (sbi_probe_extension(SBI_EXT_FWFT) > 0)) {
+			pr_info("SBI FWFT extension detected\n");
+			sbi_fwft_supported = true;
+		}
 	} else {
 		__sbi_set_timer = __sbi_set_timer_v01;
 		__sbi_send_ipi	= __sbi_send_ipi_v01;
-- 
2.49.0


