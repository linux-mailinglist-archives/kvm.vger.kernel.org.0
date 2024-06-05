Return-Path: <kvm+bounces-18857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A1AA8FC56E
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:10:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAA181C20EFC
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 08:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFF818F2F4;
	Wed,  5 Jun 2024 08:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="idWyKkRp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC4413B5AE
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 08:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717574999; cv=none; b=AMYXFliH6tggKmXH7XnywrE3WbklJ93wjXlek00YfjgJ482kRk1eBNGv3Pqv2NcJhZKEjzvFRfj+psq53pk9Zi21JWdYupjjft/43q6minFoqSNHLIsUj4LUDNwCaBnM/u4Av7JTZsGAeERnIjNFafjgtEpfzqsOoZ79jJQKSeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717574999; c=relaxed/simple;
	bh=I8O2WXKVIOLjd5F1Vhff1FtvhtGZI8T4U6sBgbpLFoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWeJ3X1EemHtQ2CCSMRPb53xR6CbMnLPgcCSoRkw+Hm/tl+TUwGIS22Jp/i2ykfeCVtmfvAhgVczwvCqVJACWMraogyUWFRZQxYtRC13ybEWWax6bsMftgwhgEmGu4QJnAEzPwwccaDzxQisqN0WVjrNJ+qvczIhhaYcxkZhdbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=idWyKkRp; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f480624d0fso48554075ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 01:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717574998; x=1718179798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1yP+3UldxiuTRJaKYzGddUQNVqEP584eUuxDOZAmb4=;
        b=idWyKkRpPOXjxV5Heb/kojbQdXeJ4MYoAv3ANNXqGH2oP0M8Zc0WcV/ghlG/zZvSGM
         x6wFYppcTmPxt4FDqL5zCCy0NWSFNY5f5q44iwkwdzLgedVWVvK1XtbmvGhhj3CxS6Yq
         shTLgClgry3+Zqf8caoFEmLObZ7zmrUsiNVslRFivd5P74KaGcrGAPHaDxK+yJ8EjU4W
         ZpVNrkJka5EFAw8bil1ohfXSb7eTrU+ECViXRidUlcHojubVp61QZNK6Xo9OWIRcnrJV
         Fk98hGzRnqmu7RKSl+YOn+tA1ETG5MNHEU5TWT48+MsCbN+Pbmc6d3RCbzR0cBHQubW8
         CHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717574998; x=1718179798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y1yP+3UldxiuTRJaKYzGddUQNVqEP584eUuxDOZAmb4=;
        b=mW5jWI/ws5Qr1o5N50m/6Pv79+4KQ4Xzy+JlzeN0WIO3C74EBXdRZ7x3bazjpVmoKL
         dBQo6VP1huLUxDRpOwnJNpDjDP9IPfx1cVVry9vtpHlqPQ9LfwW1s+lhs37GyZjGWPIS
         wuKKaerQRHiu5olxHMdTIbLoE1fXhiNgBmSootP4Yb8PECQ1tQkzGaIMmSoOnnjy+P0E
         HpuIIceMEe76rqACB0Oc33ZQ0SlrSljjkY57nyueTMOuqXsA9GGX+NCc+qFzESDAEyQ7
         M22HUgZB3RYW7BvElfrHlYt3+HBKqINtr+esds8p5PJ+pI6WhNK3MrMgPSba5SWtiTW+
         j9nw==
X-Forwarded-Encrypted: i=1; AJvYcCXuLhs5oKK9m30DQE7IKMkFFln33e8QHwHa4F9FfSW4l7qEHjrNQryty9E0+VPykH3Pxs06mF6Lc8IqvMpm37wxtOQW
X-Gm-Message-State: AOJu0YzyB5SIsdKIM06nbxQEtc36JeqYMfIR+QnWx9zjvD2MpJXZav6Y
	Qf+cT8Yl+Zq4IqOxAoObNg7O6Rih2hFtSTR36MU796y3Gd9omCUe
X-Google-Smtp-Source: AGHT+IFtBIXap92TkugwEUW60252MvIGWkn9nxjEj7DT4LAlMD2u5BVWVMyn92U1chFxvF1O7htF5Q==
X-Received: by 2002:a17:903:1c5:b0:1f6:7d0c:e932 with SMTP id d9443c01a7336-1f6a5a19144mr20842775ad.34.1717574997632;
        Wed, 05 Jun 2024 01:09:57 -0700 (PDT)
Received: from wheely.local0.net ([1.146.96.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f64cff7166sm78662035ad.160.2024.06.05.01.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 01:09:57 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/2] gitlab-ci: Always save artifacts
Date: Wed,  5 Jun 2024 18:09:41 +1000
Message-ID: <20240605080942.7675-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605080942.7675-1-npiggin@gmail.com>
References: <20240605080942.7675-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The unit test logs are important to have when a test fails so
mark these as always save.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 23bb69e24..0e4d6205f 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -4,14 +4,18 @@ before_script:
  - dnf update -y
  - dnf install -y make python
 
+# By default artifacts are only saved on success. This uses when:always
+# because the test logs are important to help diagnose failures.
 .intree_template:
  artifacts:
+  when: always
   expire_in: 2 days
   paths:
    - logs
 
 .outoftree_template:
  artifacts:
+  when: always
   expire_in: 2 days
   paths:
    - build/logs
-- 
2.43.0


