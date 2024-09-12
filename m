Return-Path: <kvm+bounces-26654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF55497631B
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7ACAC1F2422F
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA5419259B;
	Thu, 12 Sep 2024 07:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x9cTmyWi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B17419F421
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126869; cv=none; b=oYknoPAYHcu24gU05XpRDjMp7V3Rw3RI1lxAlD2hEfzlSqTWZclaKqMTFil+gxedvgXzaZ9K1VfqA6l+AXvHDT6RfaZ3gfhE00tkzwVV1O7ndsYkgpIqRnV+KHb4V+LN3HQXB0OTpvq2xTdW043ESSJ6ucQv/w84wiC/bc0wzpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126869; c=relaxed/simple;
	bh=9cCgEKRA5DvxpgLapJwiNzaItMGs4Azztj8O3oNdROE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mMp9JP4L5mpYhlXkDAJdrKaWym5Vo3LYud+MHDQ8GCtHzq9NWKAtvs3Vi9a7b2QbYLz9ZTNklsyP3Aqpv8AhY3SGezO6l91YrvNTB8sh0kjl/Wd+270oNUu5s9+IAKhaU1aTtGWizVC+gTPOeWoKsf0yvX1qCC7F4eOU9M6VcQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x9cTmyWi; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-710d2cf2955so348893a34.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126866; x=1726731666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2xm8XElPGDNfZprtVH37Ayr0VHkHPtJKuU1ivlIVl4=;
        b=x9cTmyWigSqED9KviG4Mb91LHHWbb8mX6bgE4bDGqQIYd7sCOnBwQ/ZjJpW8qle1j1
         STOJ51gX4163uR6vMLuDQKIWDNJxGnZAl7DwqT57DmFrJt46ccqCfcT2CFj7KFTM6M4W
         ttcnd7KOFXrj6wQi5o5sCnC1Tkf8Vk3cjl2satG/jyyESwXvplf0OIF+6+DAHZiFOetq
         k1S1YcInM62HSSqYooUeoboT4XdDweE9GlyTg7fEl5xiZONH+xSRqGIUENWxUp+6yEsB
         WO7pQrqR0jY0k6IshJmYZicohfpuDpa4fe8AbnkrwlxFGWIXIaQ1WBP97azDEJxoGZZY
         FBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126866; x=1726731666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e2xm8XElPGDNfZprtVH37Ayr0VHkHPtJKuU1ivlIVl4=;
        b=p6jEr66toPqrlwZ/daROtGKe566z/humNYaHowFP8mkvLygBnRd2fWqvAQvxwkp1v4
         ey0iKgWTuzkgXoAl2sOZkMCRJX/7UfdXC/3b8bhQ8z8QtSOFJotYhav0MAa/jf3b2BLQ
         nnLT4cjyqhHuN35PvmplsRSTSHljj70ObfWrEfKaOX9s6H95miE+xJ+kVsg5ERPzoorK
         SBsNDEZMXwrPr1DgZ9S7b7dlv+5WltWpHXNlzB9bVJneD/aWBsYKHtNvin+zst4jrP/v
         4dfR/oTtCbYEyF0AcMJgNiQqP8TVMlyxTbEYfQR6/slADrfcTa/AQgUYbUuCDTiASGIp
         MGSw==
X-Forwarded-Encrypted: i=1; AJvYcCWNPrtBOjfp0p6pj8tizpe1vvYlsLyg52c9S6ndcvBLrh4/OTmuXvDLtGpi7lS8UojuRmQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe4YJM1RcYgWe0/SWILV8RID1xMXxJUASayKkTIOfxONdDmHv6
	pn/gRUlN+omGMszFYnmtfvqD+jg6BnJd6OSjV14A0PsKTSG5O1rERr+g0WDfoRo=
X-Google-Smtp-Source: AGHT+IG2bps8N5RHQbEXbK5LIaAzGTJ/B29Jpl6a6SJzD8g0CGD/dFT1EoXlmzuLP4NSZ0I+DvMqHw==
X-Received: by 2002:a05:6830:6e89:b0:710:f926:708a with SMTP id 46e09a7af769-711094be6dcmr1645437a34.31.1726126866494;
        Thu, 12 Sep 2024 00:41:06 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:41:05 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	WANG Xuerui <git@xen0n.name>,
	Halil Pasic <pasic@linux.ibm.com>,
	Rob Herring <robh@kernel.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Corey Minyard <minyard@acm.org>,
	Keith Busch <kbusch@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jesper Devantier <foss@defmacro.it>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	Laurent Vivier <laurent@vivier.eu>,
	qemu-riscv@nongnu.org,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Peter Xu <peterx@redhat.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Eric Farman <farman@linux.ibm.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	qemu-block@nongnu.org,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Eduardo Habkost <eduardo@habkost.net>,
	David Gibson <david@gibson.dropbear.id.au>,
	Fam Zheng <fam@euphon.net>,
	Weiwei Li <liwei1518@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 38/48] tcg/loongarch64: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:11 -0700
Message-Id: <20240912073921.453203-39-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 tcg/loongarch64/tcg-target.c.inc | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tcg/loongarch64/tcg-target.c.inc b/tcg/loongarch64/tcg-target.c.inc
index 5b7ed5c176b..973601aec36 100644
--- a/tcg/loongarch64/tcg-target.c.inc
+++ b/tcg/loongarch64/tcg-target.c.inc
@@ -650,7 +650,6 @@ static int tcg_out_setcond_int(TCGContext *s, TCGCond cond, TCGReg ret,
 
     default:
         g_assert_not_reached();
-        break;
     }
 
     return ret | flags;
-- 
2.39.2


