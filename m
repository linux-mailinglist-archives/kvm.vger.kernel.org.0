Return-Path: <kvm+bounces-41353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AFCEAA668AA
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:52:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6809D7A7923
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48DF1C861A;
	Tue, 18 Mar 2025 04:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="omkP8YyZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED1C1C7001
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273500; cv=none; b=Fs3vOvCwcKWav/89Hi7Hx0vRMJ79g6Ao1e0d3YJvbpqsFPGBW8MdRjmn/+hMQNL+JcOXDBNhQANn36GSHe1z6yGzTs/O1hnFk0HhiacWnGymZn2TFISXFT1G4ABar7qzUeGTlRlen81W1QDA8HFQ4Zofz2gwD0UWSX9GvUQ9BiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273500; c=relaxed/simple;
	bh=6jGMmKxtkDiRAd25i0YIE1HvrPZKWogICSooVoc1vYs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qc0cmvMRb4bbWWyKGapytXTZmGMXI+GAQEzH7nkdbt4pZ09wNIsm/Unvh7GwC0kHAAaH1mQPD6OS7x0EoEauZGHXRq58wM2+mhN+heJk+ZU8EjWSwGBk7Rbm/S+gbMksDAqSZLxvJaRU7WVcZ/uMJvSzTIfoFXEQW5hcmhxMIHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=omkP8YyZ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22398e09e39so110410975ad.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273499; x=1742878299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FSHS1XcppE5ZPP6nkhpeNl/9mIWtetza6WviZOkY9i8=;
        b=omkP8YyZHg5ScRQxTHqcEYKmVdzngFKPd0G9/+wFf7pTtK20fP12M6HhLL7BiO9Ypf
         3TlF3sNewmMf+DSTxxB7AqapAK96XRk5PumetJUkJIm8Zn/9bxT9l1SFOq/cGgxQ/xVp
         u40ZtYgxDRMkMGNhxWUTQK7VbEDrzgZvecrrqp1Rc76o8c2uXlSHvjfYCG/V1kyNQShd
         Uyg5tW3pTiq5CkpdZ0H4jPGP9xNWmzdh3+JE5U5tW/JcYgPwN2ZiONtrmQUBZujZyOeQ
         6wf0yDlGfoZPQ8oTAdapWhYqeiOSHUHKbM13vMZLjT/atKCENVUVXOE74srljjy33T4v
         oBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273499; x=1742878299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FSHS1XcppE5ZPP6nkhpeNl/9mIWtetza6WviZOkY9i8=;
        b=Qdt1pt3fsjJZY2o9wvy1as2xo/YSR/T262e52445Bt+KMZQ/XFVKIRsy/imXTjKUlU
         HwMOHmO84oT7578NdwvqG9RC9vSeEuSavb5iPpG/2bcr2QNjh4SRCs0fA0W99G79ih+n
         RNb6GIp5ihsnpsnomvRhP75/MumWKbNoIrafeCqgXqfyT8I7hRK5nSrKGGG2YRDYSoa0
         0mBJmyqyvZ3RXReJlh1BHIxkAMYumkcOoEhbcoup52uPWJ1cZVNWvn3zjabZcghdetyL
         5Sfm2VzTET73Roc4CbVGymk0LHX3WXkwCale6Bw7tWQzdxXorsp95DpHCfj+G+aCB5YH
         ppZA==
X-Forwarded-Encrypted: i=1; AJvYcCXEcoGHOWQnBC6DP7GKa+0kep/ExpzMzTeGG/MFGKf7mCfna1RvNgdekJi2U/VCXj9gO7U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxW5Nk/Av8q12YX/PphNsJeHYa3RTBYQMavC34PeKfHstiMmMMu
	r0w5a4tyvdp/f3Dq0jWdd10XeqNNX1OaQxVNMBNkwltoth4w65Z1qKAddlwMQ5c=
X-Gm-Gg: ASbGncvO4iwuj2sKmBTsA60dZE2QyqpSGN4aA3hK6fAUXvUfjmxF5ZMbWut/sO+q19/
	pXYpSvGga+lL4ABXirwoV4W+ZefjwnkUg07FSzmHFemxDXPpQ6sItaRB/dXU6YTEPcnTnT2PGWS
	i0ZCpa21QrwYJrc4y7Gje8miftrG3LRq6AQNIISrR6YkiQniv4p+xIMgO5zlojBouQShx5YKV4c
	00wFVwlXv/POtQ1uCjxylxXPGCW2Ar1/E9N8zX8IBT3Ozj+q9nQW/x4FfmmXiVU5eoeOBIlu+yZ
	CY3X4LiQFzT0Af9Q7khCzrdWEdx/F2HIO84l46DMXt7L
X-Google-Smtp-Source: AGHT+IGLHGqHmqYs4ezZCOm2c2SvTDjQRRs33WUEidalhqMBp81xlxxvFOnPgr1sAs0uuf26mtAqeA==
X-Received: by 2002:a05:6a00:4649:b0:728:e2cc:bfd6 with SMTP id d2e1a72fcca58-7372240beeemr19161977b3a.18.1742273498760;
        Mon, 17 Mar 2025 21:51:38 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:38 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 06/13] exec/poison: KVM_HAVE_MCE_INJECTION can now be poisoned
Date: Mon, 17 Mar 2025 21:51:18 -0700
Message-Id: <20250318045125.759259-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We prevent common code to use this define by mistake.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/poison.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/exec/poison.h b/include/exec/poison.h
index 8ed04b31083..816f6f99d16 100644
--- a/include/exec/poison.h
+++ b/include/exec/poison.h
@@ -67,4 +67,6 @@
 #pragma GCC poison CONFIG_WHPX
 #pragma GCC poison CONFIG_XEN
 
+#pragma GCC poison KVM_HAVE_MCE_INJECTION
+
 #endif
-- 
2.39.5


