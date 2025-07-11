Return-Path: <kvm+bounces-52112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F5CB0176A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 11:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 589A07A6896
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 09:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98DD264612;
	Fri, 11 Jul 2025 09:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="vOkGMT49"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADCA2620E5
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 09:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752225292; cv=none; b=QvwTpGK4lsQXuCajPhPwPS4R8GuURZfQWAQCyqYE2lO89NwsEkVSrPCCl5xbun6sijauWKqxc2eErROkM1KtN8y4F1X3a0fKATGyYlNjOjZpyiR2Jpo6eKJrxm64YWNK1JByJ7pr6UKP5lCoBQOdsN30uu0WnK+bu7b9lyM5oiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752225292; c=relaxed/simple;
	bh=GIsKTfjQyBAJesrOIMCHcAVCeT0XXr+fFOUP3O9UfT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RT0VdejlI2o7Y2cacHrsUXVO0AUTwSYV0lVX0meCkg6dM/2pqMSlWtlwpPgraW+UitgDnwFVqL9mXMvX3CuiXWrW69W01cmt/nGulD5PYxOBQsNLtfu+Elpt8zn6KUjDXIxWsqzsHRc374J4UkrjwvedHXCpuBsb/ven7f+jrBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=vOkGMT49; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-450cb2ddd46so10837335e9.2
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 02:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1752225288; x=1752830088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M8wUMcQ/KCBzWUrJMipNuX6+bNZxmCjtjO+UX5Q4/xY=;
        b=vOkGMT49LyRAd94NWYjufvwSjh4Nvszzr5EoA6Zhd5Zkp7rVi58hQMneL30hGi9tFg
         sq5vet9EzPxpzi+BdsK7MOxrREBIC3rKWRDsMOZtIP5X5QWKR74tHBQK1hGOs4/bHpek
         4jqBnYao1rDbVLC9ulpqaxhnjOvAX4YKcOI+RXYrPBosFhqrQO8YJ1KHgr2B9HGamOoq
         7g405CBev9zXkmaXrdQ7ONYnPW7Q6DO1OF+5dmDz1NelhsUwGEomGLLz1nwx8zz7ZtpC
         aHUiy+Nq/WNYmKpuux2UTu85IRjozwd/bNMZ6YYuQJDairXf8WP4E2dDIRe4C6on33+z
         +B3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752225288; x=1752830088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8wUMcQ/KCBzWUrJMipNuX6+bNZxmCjtjO+UX5Q4/xY=;
        b=Dy5CvB2j2OBpaqmM73FbOQUvVEyJDuc7IELgtBTvMFqn3s+FpI0OP1gI5x9QyuV7/S
         dB8fwXoo3QnIT9cmG9GxbWWTCMD4Ai98olso2Pu5TVWbPi4gSjKe0Z/Ls98rykaSHyXr
         4N1uZ8Esif/M6Rtq1DUBx0iahmC8JtosmSddvR11Maez/48ihkVgOBl8NACyMXbpyncj
         sGrVX/JMWAq0IHts6TIIbK1DfNwwFZ/RGUdjuQXNJZbxt6mZVhDjUJ1I9uit8lSJqg6H
         ZrgbQ7ChFDgoBJPJOu4rU6byaDLnBZhgK4796bmGoedSVNn61oULaVjgmeVoQXebvFrg
         h2yQ==
X-Forwarded-Encrypted: i=1; AJvYcCVY47VOGLIYU9QR5OuqDVgLBgB4RMj3UzOXCcs1TaNp3SFyqm61fpdP6yeQEx/6eCmSZO8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu/Wng7JNiwzNZrHy/ZgZ7GGgbqaukR6x7xz1iUIAmgbbbTf1j
	qWpsLXJZ7gsE3FqkEle+8wTibiM7QVRKTdLzSnuYQcBey2sQaIHPTC7PCXsUOKBRs4m2JWONuPb
	/vIoK
X-Gm-Gg: ASbGncsudjZeLOjblF3r0zKGeGjA3LAAglHTxu8p5N34M1Ywmc+Dvn5XOzJa9duelks
	2WXj1DnkZLk1sezdB+L244r+RqdjZ5ta36935fLLbP7J0IV7D7Dl9v94sTrUhz25H1n5XS6Emlg
	y0C7eN6ogkpxuPZmgrW6U0hKMKDKYaoGE3NKDXuQyeJ/S7pFNHriQRXdgy235PDcBi6k2SO512u
	Ig7cHhKwsyIyD1CBBCNqiI6lYh7JEP0ZicTOViX29CZbulfJAbPNd6/uzv3yj4pTwZArdTALEJ9
	AIwJB2rGGgSjfz4aLjKgcKKJwt/EFeDsKTFUP9YlzO/qTcRliLJdMDVjS1M2Jn2ncakoQsxHK1E
	zp3sE2rqcOjVP3S066SJvybBjCgRbzgMOtQMCnpTjcBBnlmFqlvDRx1rF8Oh71a/UNmh8mC7NwF
	31E2C7Xpg2rZguZdvO
X-Google-Smtp-Source: AGHT+IEHeUmL7cCxR39HTq/BkwQzZOWzQ82KzMdCWyEOTxQ/sCfDLmhsJ4iX0XDxUlRHKH9t45q8Vg==
X-Received: by 2002:a05:600c:1d8b:b0:455:ed48:144f with SMTP id 5b1f17b1804b1-455ed4815f8mr8394025e9.14.1752225288484;
        Fri, 11 Jul 2025 02:14:48 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454d5061a91sm80965275e9.17.2025.07.11.02.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 02:14:48 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 2/2] scripts: Fix params regex match
Date: Fri, 11 Jul 2025 11:14:38 +0200
Message-ID: <20250711091438.17027-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250711091438.17027-1-minipli@grsecurity.net>
References: <20250711091438.17027-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit bd93a9c61513 ("scripts: Add 'kvmtool_params' to test definition")
moved the "(extra_params|qemu_params)" regex sub-string to a helper
function vmm_unittest_params_name() but dropped the brackets, leading to
unintended matches if a line starts with "extra_params", wrongly making
it match a multi-line parameter expression.

Fix that by reintroducing the brackets.

Fixes: bd93a9c61513 ("scripts: Add 'kvmtool_params' to test definition")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 scripts/common.bash | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 315c41537f64..41310701f231 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -52,8 +52,8 @@ function for_each_unittest()
 			smp="$(vmm_optname_nr_cpus) ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
 			test_args="$(vmm_optname_args) ${BASH_REMATCH[1]}"
-		elif [[ $line =~ ^$params_name\ *=\ *'"""'(.*)$ ]]; then
-			opts="$(vmm_default_opts) ${BASH_REMATCH[1]}$'\n'"
+		elif [[ $line =~ ^($params_name)\ *=\ *'"""'(.*)$ ]]; then
+			opts="$(vmm_default_opts) ${BASH_REMATCH[2]}$'\n'"
 			while read -r -u $fd; do
 				#escape backslash newline, but not double backslash
 				if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
@@ -68,8 +68,8 @@ function for_each_unittest()
 					opts+=$REPLY$'\n'
 				fi
 			done
-		elif [[ $line =~ ^$params_name\ *=\ *(.*)$ ]]; then
-			opts="$(vmm_default_opts) ${BASH_REMATCH[1]}"
+		elif [[ $line =~ ^($params_name)\ *=\ *(.*)$ ]]; then
+			opts="$(vmm_default_opts) ${BASH_REMATCH[2]}"
 		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
 			groups=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
-- 
2.47.2


