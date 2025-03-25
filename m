Return-Path: <kvm+bounces-41895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 054EDA6E8F8
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:59:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A94C16871D
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 04:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6481C84AE;
	Tue, 25 Mar 2025 04:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iCko9knj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0220A1AB530
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878768; cv=none; b=lTdpctPlnGlLeE8JQgVgOg4EfRc7k+aV9UoEzqqcvLS/TmOYnHWEebvTrkzM8V6LvA/RhgskRabgIj5JEFAdkq0YdiTCVHpnba9nAaRoNICfXUD00ARIZXVauUYOd05G5rc4H5ldXAivSPmKRNEV1byz6FsG3RCCAKOKBP5P6xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878768; c=relaxed/simple;
	bh=apowcHZZhs4et8fkKiErlFVt0Kh2OfFGrW56UE7cHM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bn79YyE18Ma15StgeCdA+NpYuSM5EdRiqsoIYoe5x4z4R2mqYGogT1IHF09ccXUdARG1OdD43tdGRiTb1V4oNjiBkq8QHUZNLdMXjAX0d8e4PUuP4z5KtskvMIZUiLpwLrN/xyzgSjVapVLt/NnWoQKQYFbpFEOPdogsLrQPhMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iCko9knj; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223fb0f619dso103539325ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878766; x=1743483566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQiP5GUFkFFVY7PDaY5zaedRYxLQ4TsTpg+RlxTtlvE=;
        b=iCko9knjwUUOdOhQgx4Ea3IvdFFxlziJXjNV7XHPPCHIBcqWaqZ6YoXMVZZTd09I5y
         lH45arNr1RB4B8cJF4LDDM/kCHU0L3enubkhlPKddU7oUnRRwQDPg9wUk4MuZVMa4jjl
         UBAJbA6VDCpPC24ZOuZ8HM5t5q1Y52AtJDxJiXALfXjRo43QpFCA86N3/Dji/PkrprJb
         4lmIohRjrkHRQX0g8uU+0dtny4DhgBZQouvFlIpnH0YA1sLHX3bm0Av9xB9Ek1Ec3OZ0
         poJY1iYe9vDN4/uLzJHbTU7LnUHZqCThXMWXT2KS0SUaZvq2ZS4i0dsTx4BlgRThaeel
         Cj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878766; x=1743483566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQiP5GUFkFFVY7PDaY5zaedRYxLQ4TsTpg+RlxTtlvE=;
        b=pLl7Mqv7llNbcE1AA8NO6c7x9o0mlLGYHW0iOxNLAbm1Us7wrYo0/AzrWk2O4hpI7C
         xhCqXVev/EoNFPzZ8EVUNuVZCQ7J6THGz84fREc9PvNNGlWFdGqQltegqdssUi7R9wVu
         QF4P+RwXcMiFe6l3NPwa/EfeiplTwUUuihaOpXuIqeFDy6GeUR9xWEkt0SoWGokRAL6N
         e9V099iqiDcWCOGQCQ42l5F63c41VbttRhzsgp4NeYMYbd8XDn5WPjxHW60eQPEqHBpK
         V7rInnWaLvHug2oiDnPmEf8hqBdqmQU7A05T652Xb0Okc7pMWneh9y1Z5l+80pkh0Tcf
         gvtw==
X-Forwarded-Encrypted: i=1; AJvYcCXFPy+kJcVgbaahKZydQ+fApASlj8WsIuF5UW8gmHgpiZintBLhWK2fBfwbqsrS3NVBAsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/Eed1WXL+t0hdYm36RntYIlwhxianLDPBV7vxs/N7LPA1jwUj
	wFSI5Y/ifIKXKqMe2GvvPl1W4PYtY7xwXOQiDOwi4pBdlgQ5hwH3K33abm9PJkU=
X-Gm-Gg: ASbGncvLTmo/oYROlyFNPqiKBBKBYdQ7wDplleQgG2IjfG3yLZtdz6uCrkN1w8a4oiQ
	AeHGN8elKl/yR3LoiWBvSgEhifWoR8aEycI6fljtRWPOiISMeixW71Nk7pFIZj1J5/c4ewn0Evv
	VBGlbmxJOsDfmSQupP7eXO80QmL5aCSXq9Xf3+qXnrg6jYTKetlaAKuw1VlwuCuo7qY97gUL7C4
	8PyEW78JOZKTZ6xMPdeKX3OQ1yXlrL4ukx4zfswSefobdouY8qQbcBKEqlNFXxJm5C81Y3xzfJy
	nUQpv5q+kXsVJHAjHBwZ7rJLSnnib+mOeC4KTende0jH
X-Google-Smtp-Source: AGHT+IGQVuU0IksPtjKkLrUXDMm+LhK2vYe+xFJfkgcp4bXwqJ47SOrxeScwDJQAOrOoSkVIRFVAow==
X-Received: by 2002:a17:902:e74d:b0:223:5e6a:57ab with SMTP id d9443c01a7336-22780e10df0mr235483485ad.39.1742878766217;
        Mon, 24 Mar 2025 21:59:26 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:25 -0700 (PDT)
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
Subject: [PATCH v3 05/29] exec/cpu-all: remove exec/page-protection include
Date: Mon, 24 Mar 2025 21:58:50 -0700
Message-Id: <20250325045915.994760-6-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index eb029b65552..4a2cac1252d 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -19,7 +19,6 @@
 #ifndef CPU_ALL_H
 #define CPU_ALL_H
 
-#include "exec/page-protection.h"
 #include "exec/cpu-common.h"
 #include "exec/cpu-interrupt.h"
 #include "exec/tswap.h"
-- 
2.39.5


