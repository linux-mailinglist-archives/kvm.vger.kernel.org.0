Return-Path: <kvm+bounces-41906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95DE2A6E904
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:00:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BA1A169112
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297221F0E22;
	Tue, 25 Mar 2025 04:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N/RUJhaO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78891F03D1
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878779; cv=none; b=mzSDpSTpEqXHvfCkxLZpK9YbDTd532NPt7NHbBG5GEP63n/q8Mz1dmTGIGVMT/GvYTWA3n4zSlOj3jg51AyjOGmVSc1686sP6otHXAc9bXG48w6sj1HU4lqjZnO2CpyMZ8ij7nHxN4CQTwJB50cFG1TcUWjyK7tCRdfHydaix58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878779; c=relaxed/simple;
	bh=koOePhk4+szypPcCLvagB8jF+4HgkO7+nLo/kOSwecE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ie91Qvb2nc0FjVwqO5tQ8Cex9yx9X0zVxd0ymSa3iIgYEgQ0NB3fJgFrUBoQi7ZYRhVZkkvpMLf7uE17VkcrB2TA7z5b3XoXk127sRTvui54WyOIR8AbTPa/w4rdOUYuPFOcblM6VqzoMHPnJUKBi8W+btNII/57n+erls0Txb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N/RUJhaO; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ff4a4f901fso9525492a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878777; x=1743483577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7b7Pa/XivG7M4hjK9jqso2S4d+dz1DGry6GtvIR3C8c=;
        b=N/RUJhaOs91FGu9btPkWNRe8B4IShkbPDUoivg1qVqlxmM6X+Zca72cImIya0IMXnb
         U+WvCuI6iAcwQFh1R8lwZofh2xvAhqtaybGwdf8d6QQ8oYtG5zdnmw8avwniTTuNJd7E
         wR7fUJweovXLsXpuHYLZOxKNeQPKB+dn/Iejnu1oUZb6dJCqucaeOowuHz4kkQateKWZ
         0+AREzzX6sxSAv8p4glJdXLazYMzilJTu2nv/sOOlQElP1xP5Q3J8OfBsz5VFrdod5B5
         7tjuDFQNCamqrASDG+cJ1T3Tio1iASjSKBYTdbdRsKEYwy/FECGOij5/YSc7J0lRMPnx
         mTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878777; x=1743483577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7b7Pa/XivG7M4hjK9jqso2S4d+dz1DGry6GtvIR3C8c=;
        b=WfPPFxzN4dglDBLpu0IZ2oeQtP070CItpcUGW0C/ZhT3wbJDLZakPeh4zEYzax9z7Y
         XU33wtuQGoo5ZQZmRtObwcYNCEb2r9+GynqMPSLrkaq5cdQmRenCNV+wnMKcw3BWv5cz
         8iy61+7TgjN/NDi0hPA5AG/vvaztTVviVa6bqxQ9S37NAmXlw+0HUIywVpqgY9H4a2HO
         kpD2UbEn5c1B1XlM8m+yPmQtyMpnmIJ4vqslDVMbZuAWnytU5oPuSZKvaPl19vzkTz60
         fUb0rllRUA7sFDh6Mns34De5/DH0tsOk1sJKF2RYVqGm1vm59P+UF3j69Ptjbz7gXs23
         +erw==
X-Forwarded-Encrypted: i=1; AJvYcCVajrBfbFfCvsfFENyJWV9WVeM6/LDNrtoYc0wsJaxEQEUuCWx+SI+q32hhjGiPvcfbY2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMmTWnnc584XCjYiiwPRQRvG4Y46ineuw3kCtTq8+tgxffmPAc
	Y3tTve+79COJWXvNKBWWueqy9Aiu28XSJFe4R2wqwxOXgdDWKxuoU55rw1NMntA=
X-Gm-Gg: ASbGncvSMclCDZctj7QKX8ZUKXDWYN0wzN8mmwLy2rgb/FWPmse1vK27SGg1sGqkY5l
	xEARYDOqhgNm9QprKr7OifdOT3wGl6PhE4aIvNF62yZ0zg8/XeknK8pTKYLW1EkqeOR3AHq5jqO
	D1OJ5UXd4FlMZ+DUp7G3Jm3/PZWlgztppBj2cOwfSUZ8pxPOb5/lMiK9IvHuzho+0tOZNryUklE
	+wpWnMT+My/SoF6w5L7AtQKjgoQnxWchSa36fypFP4n63u5+hp7Z2kCw0bmgutKCzrMPuIHwhOo
	DTbme+guj/M9uxxh7Sd5EnW4CEJGJjTXb5a1DA6SA7kT
X-Google-Smtp-Source: AGHT+IE6/e75fo+Kg/zgnWaJm+LIfAfDzGoGdg/CTmdUB6XE9NW7yCx2vtaKJnH35gGHMugZZFYWOw==
X-Received: by 2002:a17:90b:2743:b0:2ff:4a8d:74f8 with SMTP id 98e67ed59e1d1-3030fe721dfmr22138307a91.6.1742878776987;
        Mon, 24 Mar 2025 21:59:36 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:36 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 16/29] exec/target_page: runtime defintion for TARGET_PAGE_BITS_MIN
Date: Mon, 24 Mar 2025 21:59:01 -0700
Message-Id: <20250325045915.994760-17-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We introduce later a mechanism to skip cpu definitions inclusion, so we
can detect it here, and call the correct runtime function instead.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/target_page.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/exec/target_page.h b/include/exec/target_page.h
index 8e89e5cbe6f..aeddb25c743 100644
--- a/include/exec/target_page.h
+++ b/include/exec/target_page.h
@@ -40,6 +40,9 @@ extern const TargetPageBits target_page;
 #  define TARGET_PAGE_MASK   ((TARGET_PAGE_TYPE)target_page.mask)
 # endif
 # define TARGET_PAGE_SIZE    (-(int)TARGET_PAGE_MASK)
+# ifndef TARGET_PAGE_BITS_MIN
+#  define TARGET_PAGE_BITS_MIN qemu_target_page_bits_min()
+# endif
 #else
 # define TARGET_PAGE_BITS_MIN TARGET_PAGE_BITS
 # define TARGET_PAGE_SIZE    (1 << TARGET_PAGE_BITS)
-- 
2.39.5


