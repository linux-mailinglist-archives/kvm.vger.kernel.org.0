Return-Path: <kvm+bounces-41903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F99A6E903
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25ABA168278
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DBF51EFF9D;
	Tue, 25 Mar 2025 04:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EVLh+uuz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8F11EB1B5
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878776; cv=none; b=UUgmh+KdzqUJgAg9NyX/F+sLjfepbHJvBPsQ2o2u9hZQZw7qoFInDt9kzD5mZ/H6Zg5biPmchIgzecSUhxIltTqSPVOS0Oa/YfblAXO5b0PceYMyDnUJ9H8EH8qVe1NcomEvhn23BZ5nmBVzPQkDub0CbezPWzlofU34oGDHt/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878776; c=relaxed/simple;
	bh=HvquKKHWdUXF03NGSGiSSwESiHR7uvkF49O4Ip0A8No=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n2aGnEoMImwAQAGhm+xGms/tTtnutngJUjY7k+JD8v0zzf5jTMO8B0Q9BPySBcbwiWw/0EYiSOHM80+kQnJFZLxCLkN3EYWs1MZ/Y89mrtfENGu/NpUvqv9n6Q6eF55AyGXgwsIQzMChhFvipUjbh0zZTd7SWZD5cp/T6QuJe9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EVLh+uuz; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3014ae35534so7976713a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878774; x=1743483574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=suKjzNx+ro19ZSxlCmxY92LJNBi/ThyI6kfAqCnEFLE=;
        b=EVLh+uuzJZjJKcq8v2K1txdfMwMO29u4CuhChzdri5GTkQl5hkcTBmAJUzlsArt/cr
         AxzrLNAHmFgLsvKSOCYfqEe+d0h04Uhodtfl4wk337eIaB68p1Uufqb39IdJHiGqfkMU
         CtOeV3uZKUNklfMphUturEP1xVBpCwAhJZRNg61sN6gV0nxFZlelif237g6UTygAsvna
         6xvW2BSo60NG7RbVjbX+aVj5/09U9eNnnA33J+lBhE6Zv03QUGumyerJH1MfcqwqiPl6
         oE3Q5jj0e3gfcEvFXS6zZVslLC1+hHUdxnDyCsMAdVHdjwXao1CvWJ4VzFidC2Ripfjv
         Z5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878774; x=1743483574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=suKjzNx+ro19ZSxlCmxY92LJNBi/ThyI6kfAqCnEFLE=;
        b=fl11tF+Lc09BPDrRAjsavP5CsvYS8TPnWwnnzXufU6RIT/pp8fmLXxMvkae3xZ+ZM/
         wSZT4U6mwKzy61liT8H30MkTt5MSSVol2nJX5+ChaTGg2Kmy5VrECdht/ixqQrm44eMT
         kq5l3CME/ywEdfTWmNQ7Au88XhxJ37xfq7hPc09rQ5VKsHZz74VJ7XkTdnyf4fH50vLd
         eSX5kDbRaaYL1Iig0eNsBt52bT02PDhuwVojWSFPRITW7BudPnsxWbUqUjczsGuTsfZC
         ElVpoDCjsd8PyCdMS4g5U7UEHp3ERZMZgSa0x7B6pYSw+qpEGJShuXSnW8SD4KQ5JBTX
         Z19w==
X-Forwarded-Encrypted: i=1; AJvYcCXpbLNH6zm+gdSOLWkNtRM/QYpzGjHPK7bA9hGP1sLlSsGn3LeIQZYj08b8ascLuSA7r3E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy11fVZWUNvsNrQf00THjZOivF1Gt4YUaAlRa0jWw6vGtX/vRLU
	RgC2bplaRkYzi2V0LtSWD+NpPuf4BxS9EBMfu9M1841q+tEBvV7DA+31xAK9EUM=
X-Gm-Gg: ASbGncvje715gJs6K00GoWoSgQ9ktl1AWVcObLWzx0tbvd7Hdw2bCEJnmvESIJthQdD
	J2qhUL/0EO0lH9Hp0NEVDVGSwy4+IrriEg9OKksdtwE6tMuReQBSbvi8ZS3ds6JDUrDSETLeIf1
	jwFnzbXA3ry4ZbD/Cwm6UOinIOv7Q8icPMqO7pM4Fkf+KdYMo4m/13Ynl53jrU8OzzXsMRDSVMz
	/Rb5rGXIHfNlPveuaEfBBBPDnIG0AKUzUOtvTPWFP3vFQAP4v2WRJ/B4oIhtHpQTK+v9RzfLgHv
	DdHLYGN0tyCU4G3k4rO61xHvbadn9tfQVfqng2u8no6PPXsOk6ac1Hc=
X-Google-Smtp-Source: AGHT+IHPU4uchBIGiRjkJmhVeK2EhQ4Ui7xYBT+ie5zJXI7wvII1DZ8qGB//kHUIjROeSaKjFRMo2A==
X-Received: by 2002:a17:90b:3e47:b0:2f4:4500:bb4d with SMTP id 98e67ed59e1d1-3030fec4e66mr25832284a91.20.1742878774134;
        Mon, 24 Mar 2025 21:59:34 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:33 -0700 (PDT)
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
Subject: [PATCH v3 13/29] exec/cpu-all: remove cpu include
Date: Mon, 24 Mar 2025 21:58:58 -0700
Message-Id: <20250325045915.994760-14-pierrick.bouvier@linaro.org>
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

Now we made sure important defines are included using their direct
path, we can remove cpu.h from cpu-all.h.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 2 --
 accel/tcg/cpu-exec.c   | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index d4d05d82315..da8f5dd10c5 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -21,6 +21,4 @@
 
 #include "exec/cpu-common.h"
 
-#include "cpu.h"
-
 #endif /* CPU_ALL_H */
diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
index 207416e0212..813113c51ea 100644
--- a/accel/tcg/cpu-exec.c
+++ b/accel/tcg/cpu-exec.c
@@ -36,6 +36,7 @@
 #include "exec/log.h"
 #include "qemu/main-loop.h"
 #include "exec/cpu-all.h"
+#include "cpu.h"
 #include "exec/icount.h"
 #include "exec/replay-core.h"
 #include "system/tcg.h"
-- 
2.39.5


