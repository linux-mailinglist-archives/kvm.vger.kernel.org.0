Return-Path: <kvm+bounces-24212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C37169525E5
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CF7D1F233C0
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3475214EC79;
	Wed, 14 Aug 2024 22:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RktEHB9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375E9143888
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 22:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723675302; cv=none; b=I8XP5FAww40Aq75A7Imj7SrA+/wEpbU/WLWVSy2kipS/a48l9OEWRcylub4qhZDrFecTrDfZIAXgd8bD60vSdciGiNEv7vH4e5LldrEybY0bJew+9AErGLaD7PvdyMZE7QdIrPlQ0Y+dOxKmwfvFJSCLgCy2odO7/0ld7wrFF0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723675302; c=relaxed/simple;
	bh=gnvdMFmWfB+UmpzunGQ1TsPmjggL3z4dlVNsJFDOfFM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OhRFhGe4+kQOTxUuWyFLE5k9QtaIlQ1mAVxdM0Sg0Pycc+woA1IpboeaRVBlcYPdi2hzim8Jq2wk6ye5zwUuOK4l2vWxTtbX2V4JZcikviS6dBeRnjOll8IjKkvo2UYOLWfsX2Dnkf8sJgOjfiDN9aDDXHvCUz4UJJT/LrTMykI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RktEHB9x; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fd640a6454so4214065ad.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723675299; x=1724280099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ix2f5gCzV/CdkxjLWnI0M17lOMP/hB/dGS/GHu24vmM=;
        b=RktEHB9xxHFTGdkEgKCn/o0z0kx1F9IwPz0acMG1Bu5ZvUvKMtnGST048vwpw7+axl
         WszrXI9J1SeLpvmUH+S1N68IuE+8T1Djdaa9LVYqOCSDAXwqvm9EraH+dv+XHch6X17u
         xj4uZjmgDZuUQINxzABzg0PNmr64pCs3HRcajHhupu16d1mmxjtePJ6PWmvuARtNPzO2
         TdtHR2Joq5SSkaJsFud6+QdzhKdcHSj7AaWJgkno2HiqMoN8wg0413hk1FYdFOU/zyMh
         d9OFYyp76BilYjhgaJDraJmuJjJOFnKXuN1y0RDwGpmS+y4PM+R/akm8LtaXj4d5pl1o
         W1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723675299; x=1724280099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ix2f5gCzV/CdkxjLWnI0M17lOMP/hB/dGS/GHu24vmM=;
        b=BJ6oxidb0xzAo61NS9tQdIFh06NoZv2af5kS/ZJZT+C9n5+Ye3b6uePbQMaV0TtZzN
         OGnDwdwFoiWF8smcm8hs89VmWZpOek5s+Uhcn0TxwJQulAE21yXD3B1YRo06NnQEyakz
         5MHp5L+eV0ETjnxSZyrOhkxSEnGEC/bW8KsNQ0DjmzNF2rwn0aPD1bj2r7KfkWVxpleu
         GCIVe2mdvgfof9yJrLQ7PIQG2gUImoxF9vxcUoy+4msV0cSnAnd1aJzc1LT7LgGwPjqE
         A6E1lEugtQyOzeMW56UoQmIfrgGCHBgJi5T0WpVhhuvh3M2QMcY+Wes02SXh3UuwCruN
         qtEw==
X-Forwarded-Encrypted: i=1; AJvYcCXFcaHEIFHYsLSeiwB9D/ZFU1mAYaZJQaBk/Fsh1t6pJwCZGVikP7YJKnkgx/aXpR764zT/GpGW9hY99yybXFztU1TT
X-Gm-Message-State: AOJu0YxOaLUsYMiXcbhMBkXSaQdms0I0OAW5YiqSWbJ4J0Wr+OOURnKs
	in2x7OAJVB6eKKi6MBvEo8BC1TAcKyqiGtvWaBqF/481s7ViOKb49iQ66Ru5QaU=
X-Google-Smtp-Source: AGHT+IEcu9RodvL06jYwIW+MbnMmHphUULHzOODkrJsSEEKFjCAGokM2BML2UnWqSdowzt0TfjMKog==
X-Received: by 2002:a17:902:d508:b0:201:e792:d6ff with SMTP id d9443c01a7336-201e792d9f9mr31346215ad.10.1723675299512;
        Wed, 14 Aug 2024 15:41:39 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00:5b09:8db7:b002:cf61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03b2874sm1225595ad.308.2024.08.14.15.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 15:41:39 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 3/4] target/s390x: fix build warning (gcc-12 -fsanitize=thread)
Date: Wed, 14 Aug 2024 15:41:31 -0700
Message-Id: <20240814224132.897098-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Found on debian stable.

../target/s390x/tcg/translate.c: In function ‘get_mem_index’:
../target/s390x/tcg/translate.c:398:1: error: control reaches end of non-void function [-Werror=return-type]
  398 | }

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/s390x/tcg/translate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/target/s390x/tcg/translate.c b/target/s390x/tcg/translate.c
index c81e035dea4..bcfff40b255 100644
--- a/target/s390x/tcg/translate.c
+++ b/target/s390x/tcg/translate.c
@@ -392,7 +392,6 @@ static int get_mem_index(DisasContext *s)
         return MMU_HOME_IDX;
     default:
         g_assert_not_reached();
-        break;
     }
 #endif
 }
-- 
2.39.2


