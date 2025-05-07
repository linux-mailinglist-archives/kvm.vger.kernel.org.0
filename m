Return-Path: <kvm+bounces-45807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 027AEAAEF8E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:47:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 356BB1C031B2
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 104A8291861;
	Wed,  7 May 2025 23:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="szlpZ1C2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD31E1B422A
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661615; cv=none; b=ePJoVl6uXlhjiqN2zMODa3MKy2rCl9vjTw6QR5uv/Wx5soiUrWJXt+n7ews7Yi2tsKAvfrzHGX45eAYbCeIsaRd9ljyClklFThh9Alsf1LEG7PJDMEfnv1+3tbx2pLxpkRvL53ZdKv8ZZsGbQtxb2ELEckwane5hky6Q+ZCFj4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661615; c=relaxed/simple;
	bh=+GsKxGDFi9LdBjiYYl4g3upDO0FWMo1rCOOSDcsVo1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDu1VfIYoDE/YHLWMiW84BDvaiqUU0TNkCbEpLS7t6ASLAWZsODB8is5JLdC9imH6iIJwJHR3vCffR56EKNWsdi6MVOruO4OR+7fgv7Th8Kaj82iw98e1p/+qkNV5SdaqZsE6HBjFznKN7C3gxpMFHmoidMO2Ph/UUd8zq4u7UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=szlpZ1C2; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-af5085f7861so210482a12.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661612; x=1747266412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IO5E5SNmIeDx8PW0b+RfMLgVUuAcPfL8utSgWSmdyqA=;
        b=szlpZ1C2T15Uyv91Qpv9g9ZKe9JKWCw07HFLjotWW16gRetA4fAX9v7uYdU9jrq3zC
         Ykpc3TiHvqLbhkoqVZ1KgQcpXJV0cFc+q6yL//2OOqpbfQQOw5tKzy1514eMTQA7XhXH
         PppOHXWA7XbJn+bTNCwihUoRDaeu6BJnrAojJMoeHhS+bh0mvHTc6g39tBCdbEb2Uivq
         tJlZ9J8lCxIIm1pZfrnaVKJ5YmiGTBtqAN5FeuvFt1WICWZTKntK79TBWbKxNTFw3i2X
         jkJYE7GIaQvwqeTu/WQzUkKLrmxkKIRv67uSeakSwtjzLxa47BOJ4OHZpcwd6eGGP6kN
         Dh1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661612; x=1747266412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IO5E5SNmIeDx8PW0b+RfMLgVUuAcPfL8utSgWSmdyqA=;
        b=DagXEl/Mur4l4P+nLUxypdoMzw5LBmiI6X7oDAeJ6P/AGS/Cl6Ff+ryoyNcjHIddm/
         x8k8eOk7l7CU9Jabeo07vQWfrfRoeO3tNrsEfMGsanhTKahFWwpE8gED+SnL7tK4s5to
         Tz1qUMS8ZdSIiZuTPbGYdWalIQYIlnEuSPOmIButi4wiotZZ5DfCvXSXJuyLt9mRefVU
         7UqSRXJX2VxmgUJZHJ/WxdRy7udhRrWHHJOFxbIyW8n2NrzyHbBG/AqCuwNnD9SblllX
         FHK79LQxV0upHGJSLfc908WWMg7TvdHrMnD+9eMy6aqyI/kjrpF12g9skPTrGvq+BNBQ
         UUNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBMHtjf8uls46/QS5C6FsN7PV0eTNK9/7+KXfoSQWCVE77K+QcIoi0hyB8tdMGJ690MG8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1pGD3NvgNqv2hO6z5E0JzNcWhyUQxmZVGltz68ElssqvRsMB0
	jxuawA4cD5dPM3ycUzLRx88aKuItwDz22Nucida+Jj0MvmR/13sBKVcJDXdUf1c=
X-Gm-Gg: ASbGncv8iA+NFEWA+QTQo2EusFcSPd3hHOm6BmsVQLzYQ1ZebEa20G8mBV92OjTq7Al
	mgD186nX7vncIuzKDeQGBDHjwGWEUVcmtEYMKvJYQlpp15HgbPzWQt1+Bmrt+TJ2pQxW61VN+im
	pe27H4sMmCWSNy2TTnQcMuAre4awyIIYzvl57DHZsFV9zrYO16a5x3V5Ru9pSPhIHfGUEfOdfVy
	kCCXfRt9S6pdZqW3bTutKSNs98+x3jFFGs7FTHPSjf5URGwY7u9J2XYNKLbG7D8x/MQ1cwlZIgA
	tGokMN8UC6AzGmky8z2Z+rl7eqL5CrvKkxRgwQc2
X-Google-Smtp-Source: AGHT+IEHYf5gn4Kms+01AVGqYQpj4Yv7nVnKVCgM8oiazO1HdzL36aOMXIYItrwG0ce1halY5iExPQ==
X-Received: by 2002:a17:902:e78c:b0:215:8d49:e2a7 with SMTP id d9443c01a7336-22e5ee1cc15mr64885385ad.50.1746661611918;
        Wed, 07 May 2025 16:46:51 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e97absm100792435ad.62.2025.05.07.16.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:46:51 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 40/49] target/arm/tcg/vec_internal: use forward declaration for CPUARMState
Date: Wed,  7 May 2025 16:42:31 -0700
Message-ID: <20250507234241.957746-41-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed so this header can be included without requiring cpu.h.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/vec_internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/tcg/vec_internal.h b/target/arm/tcg/vec_internal.h
index 6b93b5aeb94..c02f9c37f83 100644
--- a/target/arm/tcg/vec_internal.h
+++ b/target/arm/tcg/vec_internal.h
@@ -22,6 +22,8 @@
 
 #include "fpu/softfloat.h"
 
+typedef struct CPUArchState CPUARMState;
+
 /*
  * Note that vector data is stored in host-endian 64-bit chunks,
  * so addressing units smaller than that needs a host-endian fixup.
-- 
2.47.2


