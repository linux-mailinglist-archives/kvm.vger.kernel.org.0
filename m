Return-Path: <kvm+bounces-22295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A4C93CE76
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBE222827A0
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 07:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536FA176AD5;
	Fri, 26 Jul 2024 07:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNfl0+ZM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1181741F4
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 07:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721977524; cv=none; b=YOrhbab4tfbilhpWH5OqDbxwDyvRxTomJ/pSDmvqmNzHc7hsLwkDE8e8LJ5Ub7oU2HWluNAHdzYCYi5WKPRMmbJV4zeuvwJkZj6s+6JFD+2qNoQKBVRuNhCAlghCIcVDWksem+IQi39atIucApevpgj2gwmS6DYgsj8eYc7dRwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721977524; c=relaxed/simple;
	bh=XBGxaoWB+EYK/SPgdv/1jckXtDGTJreg7aBVb6/KF58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBXJ8/Nbal5Jh71sCkrykY88S9i+KEKN/jCknPhPDACsB2WNR+4X/5IBYpw1htQdl3DG0gb2wY6cKxFnjJEpv9aQASw9EWKEm1BJiAAT8IsHxALjqrbBaqxcHU/rVqjwlf6eMI8e3XvLpC17pp4UDMXy+ZFdTWgxxznT4TbXEDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KNfl0+ZM; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fc49c0aaffso2977815ad.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 00:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721977522; x=1722582322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Im0yo0nWe4l2i4E7jnJFmzEbvSq0w2haaINgkUTbDJA=;
        b=KNfl0+ZMF1EDLOrJBC/OLNYOS5KRy305GoUeMmlpv1Jh5TyKm/7e+gKeXMiOKr72vy
         zUWwyvsN2p5R/6VEqvaMYw8GmOp9GvDOXeQqJhbA6D4DsS1givhNkFYyvyuGnSnpFyqo
         uTEcC9tGKCip739SGFgBRStWj/8z/KRVVGGBoU8njl6mQXgi4vGP9ulK96MHwIROSOlX
         BIdLWQ6daMUOegvCu9EboPHZZ/4im0+Btt8jh3/4vSPE90dKmh7HRdsATB+WqAp2dej0
         KwqwYDHwWKHJ8AKIsoGSb+0h9cIt5knEnjXvUJlrjezFkSsfD/mWnEG2PkkraX0oip5i
         Slwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721977522; x=1722582322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Im0yo0nWe4l2i4E7jnJFmzEbvSq0w2haaINgkUTbDJA=;
        b=U02/DEVxx1mPvYu2Ankv7UGth6qyuqigAhExepRH2nu9hWpGLij16uwNp/Yptrb0D2
         Jjce9y6F4YMqgHTWAokwhHcfqbJWFYYPkp3/XNg8PDXUMIzS/TVHF1YwUQ0t7pnJkxVE
         1QNr/mGw9nj3DMIJBvvnCIw+HP6D42B/zr3DD3TpKWzwKi+KYsTznjYLBOj4BUfu6m+f
         wu/GLkNubFj+HATR8Jfd54VFuCLs1MX7Ut7CmvKigLE8gKVT7IURkDgJk10/YAR3yZy7
         vOu3w4W5/b4dWvTBFFR9C7HV4Ux5CUyIdDpX2aw6Ym8Ao3WzmUgpnNyRq7gwpZwYfrnb
         gjYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUce26d2kwpxR+xfPEJKE75y302ejZnINvejmTpSIJLNPNCsDfY42uq2MSiL3R2QXvaBHxwE5FOIXC6kelCd5usB8z+
X-Gm-Message-State: AOJu0Yyjn9MsSKYn25XbhMgHQcEEvSnU+XoF0MXGG9pCK6sIV7kEhOoc
	NAZHt1+gPf9xGNUWSsnn6E8tb/pRWXlFv1XUQQpua6CGIiWAMrCrCO5gtA==
X-Google-Smtp-Source: AGHT+IEfKJsaxDu9QUPo1XmpBhDafwnB3lw3yfeNfp+kT7I8Cuz/Jy9Rfa60I1t/OWsg5X09XBxNiw==
X-Received: by 2002:a17:902:d4cd:b0:1fd:67c2:f975 with SMTP id d9443c01a7336-1fed9259317mr46815315ad.29.1721977522435;
        Fri, 26 Jul 2024 00:05:22 -0700 (PDT)
Received: from wheely.local0.net ([1.146.16.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee4d26sm25034215ad.166.2024.07.26.00.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 00:05:22 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 5/6] gitlab-ci: add a shellcheck test
Date: Fri, 26 Jul 2024 17:04:46 +1000
Message-ID: <20240726070456.467533-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240726070456.467533-1-npiggin@gmail.com>
References: <20240726070456.467533-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we have some shellcheck support, might as well run it in
CI.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 0f72cefe7..2d55c6dcf 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -429,3 +429,16 @@ check-kerneldoc:
   before_script:
     - apk -U add bash make perl gcc
   allow_failure: true
+
+check-shellcheck:
+  extends: .intree_template
+  stage: build
+  image: python:3.10-alpine
+  needs: []
+  script:
+    - ./configure --arch=x86_64
+    - make -s shellcheck 2>&1 | tee shellcheckwarnings.txt
+    - test -z `cat shellcheckwarnings.txt`
+  before_script:
+    - apk -U add bash make gcc shellcheck
+  allow_failure: true
-- 
2.45.2


