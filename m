Return-Path: <kvm+bounces-24175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D51579520BE
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80E3F1F22E0A
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC2D1BC07F;
	Wed, 14 Aug 2024 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="buKTCz2H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD3C1BC06C
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723655529; cv=none; b=lw51Y1wJHxHwx4FagElG5lp3SjP9FRCQb3kB1H635kkdMO7jRdALB/p9DAUsbs+OcmhFUREjwtN6LemUlRcjcNlVkBVmagPJy3RnE/D/5jpWSpudbEwOdG5Kh1J5LjWQ9k4xEEBkUEEEt5LKc38crQ7GRr8o+EL0bW9OI4XH6fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723655529; c=relaxed/simple;
	bh=+od6ycfk1qfJFtCux5yak7pCzPljuMC6b0hSdafOhWY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FknxSZFHprWh5mqFlC8ECc0xcFwPhXgipN9QRUvdRvflK4JqDaKlckMI9mA2uLtU/DyRm3MWglei2hVhla1/51v1K9O/W6H9/3h5SDyntiYlADMEv14uZum53r8vKGvpPt57aKAHJpoyuXuI5+0BQUV8iBW938J9U4/RdwDlU5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=buKTCz2H; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fd70ba6a15so770205ad.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723655528; x=1724260328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7PkrlYQr/V3YMS3es97SiZgcfp3AW/tKZmcfuYfGEw=;
        b=buKTCz2HeRfcFlaXlcDCBA61LrMhVw05ABq8g1ZmTSD94dGc6sG3L02RMXUII09Ao8
         WIibTC8TvgfdDJHycVA4CFUYnCQrLS46SfJ852Ucp8H63Z7Fc0xMi3r0K6wTdn2Bb4CQ
         s9dusRsw4YVCOqDD99bUdc64H9KoGOHTm9nOuEroOICfX0GMqoev3JHa5g+eE+V2a2+2
         KoDzz0E7JUsc5836InoqiGKUPSJ7epDtf07C5nvPrUKjAq2xZVQWxwVtg7sdNKky/f4n
         /PwyP/UXFbHUI3bSc/vqdFeaG/mfY+Qje2TjGR+huZB3O7PKMkZEhdWQvGs68T9+mPW9
         Q/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723655528; x=1724260328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7PkrlYQr/V3YMS3es97SiZgcfp3AW/tKZmcfuYfGEw=;
        b=gvr6GIagvIxpNQw9VxAt7gi/tsC1Jwne/Dw2dNj74O+UqhtRMsye+WoRzJVxbfk3/g
         o+0OQF6gJO6u8WOwX5CesL87ciOnqx9+QVFnvQFC/+aaSFJp1VQEY39/AHPFrAKq9SG/
         DWOOv6j0IOn35g0gGmmijtGoih0BI9L+WZO3bHCSRPHm7vR2o1N4vTfz4PpeEM7jNDMw
         96yBzv2g3RRqwdWbyC1kQevCSgxTBrJkrWzqJE+D3X7nmn/QU+vgcj+xHK5GQ/GsISWI
         JmQd8jgqBaEkYh6wKEsf6BOUvIkKybpmDrbnG7hxcUhou7MP8Thw9tCjpJSvSAclrL6B
         r4xQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6gKzrl347hwaU5rSVgtNoKvhR0SO/OClYeDkAzT58cix5fHZVALUJwsGJToy1QbkQSHwNAbju9hN5V+JLQFnSBT3S
X-Gm-Message-State: AOJu0YwufU9Bw55NHaAxzRYX4AFkyE26kenbKNvx/daLv7JZFV2AqLdb
	Y58jHsmch/B0Iyvqi599mntZVLie61xP5oGcPRX52IPXEEuJXFoWPB+TkEhKAd0=
X-Google-Smtp-Source: AGHT+IH1edYhLET7/RIFW48bFtTCY7hghNR+eEBNjSEPgKc65lUBwapnO/P1culqyBP8m+YCz6d0NQ==
X-Received: by 2002:a17:902:d2c4:b0:1fb:7b96:8467 with SMTP id d9443c01a7336-201d651f85emr34242465ad.63.1723655527854;
        Wed, 14 Aug 2024 10:12:07 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::b861])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1c8783sm31813895ad.245.2024.08.14.10.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 10:12:07 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Beraldo Leal <bleal@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 3/4] target/s390x: fix build warning (gcc-12 -fsanitize=thread)
Date: Wed, 14 Aug 2024 10:11:51 -0700
Message-Id: <20240814171152.575634-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
References: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
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


