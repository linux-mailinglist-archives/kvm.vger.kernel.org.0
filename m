Return-Path: <kvm+bounces-54429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81431B212DA
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:08:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 419E63E1455
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A06E2C21FC;
	Mon, 11 Aug 2025 17:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jwXD8Vnv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E47B2D4816
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754932036; cv=none; b=mTtALPTGTXYhU9/BLVzRKWgUuMW+cw6PjGS8STdqJktNlqQ6/6yql2fR+m//KEjOAXRAhujMFjJBCKaLig7JFQZkxUD44rucn30PwW7M5qZstgeK9tuuj0rHIxI5EMtuAePyV/4UGOnQb9Zfdg5n2iefZ65S0mbmZwDA+p85fBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754932036; c=relaxed/simple;
	bh=cHdKIkTwpLgbG7hNZHe/bDx0dvJvx+OmSRSZQwkdVAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p7RS545WUB/FLPIveyWIcrzlUfvUmevmh9wzzwePCtD0SyaeaZWTN7EfGs0sn0t5lLNbIuZ7LM6tvXVvB0tp30F5QMyC0/nSrIlgzncUNIgHI6QWNTz5jzkRirwpnkBmJ+KaAnTlYVz7cAZnH8HsKMVxPs9mUo/1i3hHvqQUC/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jwXD8Vnv; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-458c063baeaso25615015e9.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754932033; x=1755536833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/kpYoiyGaNwP9QeQLj/6KulYrhyYzjmCLEuykA1SH0I=;
        b=jwXD8VnvSZo5L6jyf/qR6bnO4n96UwDJqCpX4VtRkl9auWIvk1GWJj62mJ6zpvIYOC
         fUOQZD1/O3kYaoysz2dHZkjJZ/V0Zu70ItVLQC48eZk+Phk1hfMrr1vHWs09qmHxKa3f
         oapXNNy1NZVMVWp9P+ocqJBhvFHTIQjt1celwUEY67lDxxMQf5YFx8tmAAFbT1eBTyLn
         qYDRBBmSYS+OIoBZ5EkPEE9mwGjO/efYuZKnVWnsV+0nOk2qB31030Mdo4ajCzpJ9s3t
         L8u1vaMNBtBHBkm7hVTO1iF7eQ7yee3HfucluehSY71qWdLUUaB0r+EbOpdx7sNkElvS
         q8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754932033; x=1755536833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/kpYoiyGaNwP9QeQLj/6KulYrhyYzjmCLEuykA1SH0I=;
        b=Gat18DI9i1cvExy81eSol+yT4UnvwFbhs/2sOEpvwUVCJuaGzoir/0E/Qc2nb6r3Iv
         LNveBb5Q0vOg2ftdvkxnWILQo4+UieoMytc8l44q3x3S/cmsnh3m4k6ckLWao6kLMSEW
         bLlUO5tc2rw1rUphUuf0d/HR3wv0hiHWjJvf3RY56qMEd4aqJwEYfuOPqqxWs9cRztRg
         nNxulczocSBonxcWGvnWqnOHL/JCnsjRcNRkn8viV/qYBqDtOmt/F0mIB39GPc7mCL6D
         VkYo7pRlIfGUQ71j4CTtIZK7n3HlHM7N27h4MhW29ERAMb8dkIuJBf5t8+YnOHrlP17L
         /U/w==
X-Forwarded-Encrypted: i=1; AJvYcCVjz5h5Ae9pXPkfyoRKX9R9nDu1YlEvSzzjPssgNe1glQZqW4I3Bw+7g7Xjl+qAzLWgj20=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1m8yVye+u/iR5Edrpp5FkDBKAcIXNG08pnW11pDwnEZXCAn+i
	IH1BE7KJMJo3pYqHxBAjyYqlRWxkPM/wUxRg7j3vjnsj5txm0NCMTU8/wxa8I51Emjg=
X-Gm-Gg: ASbGncsyG7Bg8e219Uamh9Tu3ZJWkATenXd6zbEFeJXGoTIlYktkcpTyLO0By5C1vTE
	IL9moJoIp4UVuqfa1M8bE14UiPxbTv8E2iO/bSsgSo76qxtZEWEx41YT22eNHGvtA6hidmowvsI
	R1X1veW8qNIhniwGENzTA62/DpGMp+LsGu/uvs77lLsiLViL0dNtZmJW8veNZ0+VSTJ+OKzss2N
	Nalw7O7Iwyx/ngv/9ARR3TJAhlnBDtxj+wkHDx/1qePpLLyqUJsmxSyVbNWhJ1eRiyozD9XbYir
	Pfwah2+IumpBy2WBZT1lOIOCCunLzF//UOvondr9EUDbJ1MmiNUWqYVBMo3X8ATJ616spZ0hzi2
	4zGHMHr297pEETudyAVqDxkL1q8bDW1haR77U4T6yrp7NHLItZX4Xx0a/QG14AnwUvj/Otcx9
X-Google-Smtp-Source: AGHT+IGPNlPGCtPBypS+3QH5V8BmL3guma48smLhKJ8u6uzLKRJHeGM33dI4w+1pFfja9aZ7mD/1ew==
X-Received: by 2002:a05:600c:35c5:b0:458:bfe1:4a91 with SMTP id 5b1f17b1804b1-45a10be7b42mr4144935e9.20.1754932033011;
        Mon, 11 Aug 2025 10:07:13 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e58553f8sm279207095e9.14.2025.08.11.10.07.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:07:12 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Haibo Xu <haibo.xu@linaro.org>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Alexander Graf <agraf@csgraf.de>,
	Claudio Fontana <cfontana@suse.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Mads Ynddal <mads@ynddal.dk>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 11/11] target/arm/hvf: Allow EL2/EL3 emulation on Silicon M1 / M2
Date: Mon, 11 Aug 2025 19:06:11 +0200
Message-ID: <20250811170611.37482-12-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250811170611.37482-1-philmd@linaro.org>
References: <20250811170611.37482-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Another API PoC.
---
 target/arm/hvf/hvf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index d74f576b103..0519903c928 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -17,6 +17,7 @@
 #include "system/hvf.h"
 #include "system/hvf_int.h"
 #include "system/hw_accel.h"
+#include "system/tcg.h"
 #include "hvf_arm.h"
 #include "cpregs.h"
 #include "cpu-sysregs.h"
@@ -1014,11 +1015,14 @@ bool arm_hw_accel_cpu_feature_supported(enum arm_features feat, bool can_emulate
     case ARM_FEATURE_GENERIC_TIMER:
         return true;
     case ARM_FEATURE_EL2:
+        if (can_emulate) {
+            return true;
+        }
         ret = hv_vm_config_get_el2_supported(&supported);
         assert_hvf_ok(ret);
         return supported;
     case ARM_FEATURE_EL3:
-        return false;
+        return can_emulate && tcg_enabled();
     default:
         g_assert_not_reached();
     }
-- 
2.49.0


