Return-Path: <kvm+bounces-27144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FD7197C394
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AEE2283DA4
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1AE255885;
	Thu, 19 Sep 2024 04:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bG5t9pj5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD28F1BC40
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721254; cv=none; b=F0jB0XRSw9RW0sSjrp7Z7oNfFiJ8Dzb0zv4eeaZsCC5u8UKnqpVx8CXFPj2e0gV/6Azfj5wdgN9HfvyX5EbqkIC5TBBJon416ZT+VU9qk14LWs8HaE1eSjxxSOT9Mj7rmmsHaV3SEDVGkolHY+m3aBqQbmfSCeMid8Uw4XnE2u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721254; c=relaxed/simple;
	bh=iEfdVoaYIysQOl8X5WTQZj/hRoLe/J+kj8qq0ntwh4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uYknBEVG8esyaSSNlBu/pnDfA8p3vnnyg8Gt2HmRpmeEwQo/O6JGcz80r1EooyQ6c4PRnQkZYIgdnORBKKpz3y5smVwdW0rDQMWFxx7Kmi9xJGsNAAc1u+gy7upjgfnvOvrxlE4YOSVXZC08J9N/arykkXsEmaW/eAwDwHYa5F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bG5t9pj5; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-718816be6cbso311817b3a.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721252; x=1727326052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=htcD0BwVI8E53kI5D4tk23OSCVl4GJymUerem5Vd+Nc=;
        b=bG5t9pj5M0TDhOAqFoq7Gn48/nXwmKjshjC3mN6GLG16WbWMjMLg++TDyF3junXcWm
         xTMRwkMoY0GvOo8rl34VeCeVZXkAMIQBWG0ZLYg4ERgxgIOE/S5LzOkFNx1FUO7zR2AQ
         +EHCp0hmrXzBayfq1jOduO3r+jH33PXv0sYnhjrEnmm6zQlSyWZMe5iVYVhXx6InQ5TD
         gf2o6CgeU9UudkCdlwTaEfy9Y8d6TQEVo7jCxdZW79M1fExIQYCJgJWTn6l/pHHBjWUO
         P9+LpXX1/IBKphUpXZXwsgtgiVBw5hd24Q1i9IYSeaw2tmMFxuVFrsaeVpyxdL5R+Ly9
         Wt2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721252; x=1727326052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=htcD0BwVI8E53kI5D4tk23OSCVl4GJymUerem5Vd+Nc=;
        b=mLfo2pVgsCOsMryj92FA06K4YCaU7vZ+vKkuNeTyquuR+xX5bC922AUjuJpOWb7uU0
         P1Uje4B3266HaxRa8fJlc9pH8VaCvMg7AmrtPTsHWScEDMwvpUR0tA5D8XP6IN6l+lMv
         H3V40OOnoHxz4th2To4NiUcTeaC8KC1E3Vq3zDmDokc13bt4j7UeZB9+bPu4G+lItnsV
         lXbilh9nxcc0r48WD+pTcGJtaYsUIwCLL+EffdvpKZEo7mfwLGPimy5Heu/TgsvDOBGN
         Cq77hqFNjQlik8++RMqmqn5A6H70kX1ayFaBUqvJ4TvuUoWCIsHHIq7S6ln+U7G4CLA1
         Ct0w==
X-Forwarded-Encrypted: i=1; AJvYcCV3yJP9orZfCgBDRjpLBYCT1WaNbPk9cd0suMSvRAPgrkdWznsqhTM6423pZ3qiG8yiXXw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKqf95CbSxlCOA/e+mGMWkekEzknHuUfW+1sFKCd60jNaxCKAp
	TpZH7W9yi70fhjSG8w0yZRIokKZqrEQi17QC/GzHclRGcC2GGZxW5SbATJpMFCeUbgGIIGil5ue
	oG9rfZA==
X-Google-Smtp-Source: AGHT+IG3VDWYQsL5o+dqVWGrfQofsayNLblIyTF0AVQE/kr+M4nxrlPbIJFiaP/P/b9fsRX/Gu2PzA==
X-Received: by 2002:a05:6a00:124f:b0:714:1e28:da95 with SMTP id d2e1a72fcca58-7192608198cmr37650198b3a.7.1726721251825;
        Wed, 18 Sep 2024 21:47:31 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:31 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Bin Meng <bmeng.cn@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Corey Minyard <minyard@acm.org>,
	Laurent Vivier <laurent@vivier.eu>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Huth <thuth@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Fam Zheng <fam@euphon.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Keith Busch <kbusch@kernel.org>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	qemu-riscv@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-arm@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-block@nongnu.org,
	Joel Stanley <joel@jms.id.au>,
	Weiwei Li <liwei1518@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Yanan Wang <wangyanan55@huawei.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Jesper Devantier <foss@defmacro.it>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 23/34] fpu: remove break after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:30 -0700
Message-Id: <20240919044641.386068-24-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
References: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
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
 fpu/softfloat-parts.c.inc | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fpu/softfloat-parts.c.inc b/fpu/softfloat-parts.c.inc
index a44649f4f4a..cc6e06b9761 100644
--- a/fpu/softfloat-parts.c.inc
+++ b/fpu/softfloat-parts.c.inc
@@ -1373,7 +1373,6 @@ static FloatPartsN *partsN(minmax)(FloatPartsN *a, FloatPartsN *b,
             break;
         default:
             g_assert_not_reached();
-            break;
         }
         switch (b->cls) {
         case float_class_normal:
@@ -1386,7 +1385,6 @@ static FloatPartsN *partsN(minmax)(FloatPartsN *a, FloatPartsN *b,
             break;
         default:
             g_assert_not_reached();
-            break;
         }
     }
 
-- 
2.39.5


