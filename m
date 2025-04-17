Return-Path: <kvm+bounces-43569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86C86A91BDF
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:24:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E30FB3BEBC9
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE221245029;
	Thu, 17 Apr 2025 12:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="YW0Pekvc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EFA24293D
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 12:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744892659; cv=none; b=KUXoc/hm7zyMYr+lgq8bhM4PgGNDNSyF3feo2z66E6NFqAPofD2sULjwMsBGqF6BIg2LKddy2pmeAVOQZtgnNpPHPJIddjGundDzmf8nmSOdTm5TMphu/9x277TnklHNy1ho9701wNsw5BInwbjyuD2mCrHRPWl3efmG0ZgdeQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744892659; c=relaxed/simple;
	bh=I8q3a/r8sIPwl9ULO4heNHCAxh6RA5hJvMvMHg5vqgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oWJ+gfoEXjK+y8YFOIZaSkeO5W1OGxptFYcGEaw5kp83Gx/6I6GNd2tHgPPKR9RNzdM9b0QkQsVwNHPMOY3CNUPvtFgxn7+0FUmK7U8B8ZGKtBkHVyxTcDbfWf0z6Jf+33IAPBaVktlQdpc2yequslHkvkta8H9+7ps/MKqHSgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=YW0Pekvc; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-225df540edcso19426775ad.0
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 05:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1744892658; x=1745497458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJ5IZYf4f1NhGHvFycXXpF/34tAS76qwhFgvuPH97UQ=;
        b=YW0PekvcepDEL3CNBicFspmuytgnbXMVpYVkMaHix670fEShFT+lc/mMY0iZaPCPQ/
         yuULSJXL6H9WfDpXS56vKkOXAN4jcZcLjPzuK9xue0TvhToXId5IztsN0w2bwF76Lwx3
         QeEHZPVkkKogjpcIp4MybW89Vi1RQaz+2xvecAH19RpZWagG4Eq7HSoTomUxYB05Z3Pi
         6rcLlbwTKsOadpEq4J4yLGQYSYWMa/0yWkEd/lqrQu8tyJaLiWXAjgcR+ACWhkQXIDQ8
         p5zBgLCLZJZqGUbZPKgeUjC2pIMq27dMoJ1XtTQf6297sUp5umm3RoEEbl5L0XvNXeqr
         5ynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744892658; x=1745497458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJ5IZYf4f1NhGHvFycXXpF/34tAS76qwhFgvuPH97UQ=;
        b=JJzks5anz3z675TY/sh7NrTPR5KoFNz1X3Vm7HbM3Z26lIKZbbBls0JaPISh6DgqZW
         n2GZkpHgRml3cFrRXucuRvR7G2KTXodsTI8d+Wg0upDl6Zt674/vq/NN4XKOpXzIOJol
         Nr+4WTeSMklcRvrSMQpdu8m4k5A+/8lgZVFskLvHUIVNYpY3D6jXuswaA1yG55FeEvSI
         QEZzcDrUIwLuiIW3wjGHew41g+U8HZuc+u7XJUR0wtQCiZUqm5MD7f+PV90PAe0EOqlI
         ziJ4CLUfLnnyBWZQM+yX4dL5lAbqN50av9y5pTBF5EOAwxq9gQ9VJgFVuxK6ToPFH6Az
         i6gQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQWHCtkSFVt+dQLj0SB+RpU01xIprmoiCYrDJhJgF0Bys6iTfcgywrkppj3yGOC+Qjr1s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yygj3d4DdptD21+u9xzT5l+A+PfEjPeL2wE0FBzYNv5t2w86oWn
	mYv156spUCfeK/oQpuz5Z5s7/or+XgFuqxrZWtFN+NU5dRyYg8bRd70ETqwzG9Y=
X-Gm-Gg: ASbGncvafpa99tbMPjpnDnP59rdOB/GAOq1MBmbGbAwZCPTNrhXr/ImDcZgbPQ/2mkB
	esFi+aunpX9l1kdaj9HD+iuheg56PodW2ZQ9ADyxYEeso+kGB0Uu01R+MSawLplFr3tSHyLSmyO
	O6HRjJTg2eFTaTrDqEF/BZO2ICiVqM69HF3YrFANZLYsQFSgEealhcoY6aRswKriMKmH71kjMYV
	tz3p3OPAI2z8ZIJPnBX9Eyo1fl1oiD41o4kEk096/oQH/nt7Rez9FZksWB0XUq7cJntdwQxeSJ0
	7YQWxFZ2E96D1+cXfTTgvGnchzX2C67E8FZp6p/ZyA==
X-Google-Smtp-Source: AGHT+IE0XjCz5TtIm1U/KycHsULkn93MfV8ZJ4DCUOeKjh64BtT2X4MD7ZC1hijUVKkaUKvQHFj5ag==
X-Received: by 2002:a17:902:f642:b0:215:9eac:1857 with SMTP id d9443c01a7336-22c4196f564mr40963855ad.5.1744892657640;
        Thu, 17 Apr 2025 05:24:17 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c3ee1a78dsm18489415ad.253.2025.04.17.05.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 05:24:16 -0700 (PDT)
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
Subject: [PATCH v5 02/13] riscv: sbi: add new SBI error mappings
Date: Thu, 17 Apr 2025 14:19:49 +0200
Message-ID: <20250417122337.547969-3-cleger@rivosinc.com>
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

A few new errors have been added with SBI V3.0, maps them as close as
possible to errno values.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/sbi.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index bb077d0c912f..7ec249fea880 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -536,11 +536,21 @@ static inline int sbi_err_map_linux_errno(int err)
 	case SBI_SUCCESS:
 		return 0;
 	case SBI_ERR_DENIED:
+	case SBI_ERR_DENIED_LOCKED:
 		return -EPERM;
 	case SBI_ERR_INVALID_PARAM:
+	case SBI_ERR_INVALID_STATE:
 		return -EINVAL;
+	case SBI_ERR_BAD_RANGE:
+		return -ERANGE;
 	case SBI_ERR_INVALID_ADDRESS:
 		return -EFAULT;
+	case SBI_ERR_NO_SHMEM:
+		return -ENOMEM;
+	case SBI_ERR_TIMEOUT:
+		return -ETIME;
+	case SBI_ERR_IO:
+		return -EIO;
 	case SBI_ERR_NOT_SUPPORTED:
 	case SBI_ERR_FAILURE:
 	default:
-- 
2.49.0


