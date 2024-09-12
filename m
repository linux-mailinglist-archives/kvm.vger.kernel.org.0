Return-Path: <kvm+bounces-26744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F1A5976E75
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 18:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2D1C1C23894
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167C91487CD;
	Thu, 12 Sep 2024 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="su7CljiC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C749113D8AC
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726157532; cv=none; b=YdQpVK1DdMdQjqYfU8uTFR78u9n+QQW5vpzOc3O8bFASJxUV9YkkAKfp337izQUEXBFHhbf71ymieWPSrCU0auLnfQlNuIHHEIES309X1aW4Boo2zlIfehQlG1R2+2uoMBNg2YB+TxPkMGahHcKgyPfD6+cY3MbUNMElRIQLHH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726157532; c=relaxed/simple;
	bh=a+M3PQ+pupAOpsAgt31slutK73YbnjzT4KrN/6Hu0+o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VBM12JbNbIumGcdjxL/bBh4w7HAb32HEeO3dZZHxA8EMYLLfSqMv0LMqhDSHgWjCv5DvdQw34XYZa4SBgkpZejtDEmpX40RvcWzvq3YGT+R0Zk1Ty+hlgiIEDZ/qEP442iZ85KV4GcDscoMWH8yy6rjiTMsUFjRqC3ugHpZxQ3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=su7CljiC; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2d8abac30ddso980807a91.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 09:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726157530; x=1726762330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BppHFYoQrx4qC3DO9Sb1ugevP84fPlKPBSZdTDngGiU=;
        b=su7CljiCwW/1H9Bp2DLjBuaTW7F1vtcl0FGO423sZ31K0pER6HFWYl4PWkjrpUL1OC
         mQmzGQxSo5J4BHQReAa8LpswvXqLa/mE8Rd2CqxkJqmvPYa+OpGvS+pe92ISaaVdjOIF
         wGpC1jmBMD4iRwf4SPRew7PRAkaWA5iiye0sot5U4pdK42bIeweZT4sE6isZ2wlCODet
         hOELUIP1m0BisTPnlRkIn/Eodr6YQLahyxdF2h8AvK9BWepL9aoaqljY2q/8yYOl7vzc
         gTo+enqgB1tBNu8MtgQjt894D1z+sh1g0l+/dpAbgCajMgOAZGnv2mpzPfUyA0fYRRFv
         ETgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726157530; x=1726762330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BppHFYoQrx4qC3DO9Sb1ugevP84fPlKPBSZdTDngGiU=;
        b=bT5ixtxTssSCMjLxKtvLBYKgj3lRlY1xrcQ7NAH8c/6/pmFgJo6GTNTVPqxuITpLac
         4T3JJlSYd4niuJJ6jhxo/UgN34xKmVyn5IFSfLJfaRH/to4JLCWrzVmUOyOHvhG4cU0S
         2rN6kmv8dg82oWGPn35j9NCTldAhhCsRXp7eQh0YFbjwvWRhkoPCDeKlolIJ8zSOFCbp
         3pD8n9RS0spCJWYh74fmyX6A9Idb5/2rw9sGz3U5kEYsRcBF8S0awYtLK/7r6MDW7pAU
         NpjQzicpQk23ji2j/WDZclJ7yrLLNtREGl3cw1W/JP/QZafBfNh2nFSW2LPRm/Q9BKdV
         p2yw==
X-Forwarded-Encrypted: i=1; AJvYcCVQX4n0Mc/8wnyU1P4FqLUHzWTlEa08UYEJ4Xv8AaAPRotqd3az37GSvSGCVvbw0dOWQzw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTsOJL2w5Vu3qIo1gnKFrskDJlMqb1kQH3YMFi0LBr1oqELVdX
	SH8mpYNMrZb89TAmRUmZmt2LNK8Raffnogw8CW+i5sSlEQk7g6948dSskdYlEto=
X-Google-Smtp-Source: AGHT+IFXZnFHApOhxp7HbQT8QxnSQy+ag97AShW2GHgmcSAhB2K9e6P9OwzQbkNk0mR6Kpm6KHVR+g==
X-Received: by 2002:a17:90b:4b48:b0:2d1:bf4b:4a6d with SMTP id 98e67ed59e1d1-2db9ffa1590mr3873451a91.1.1726157529892;
        Thu, 12 Sep 2024 09:12:09 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db0419aab4sm10868139a91.15.2024.09.12.09.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 09:12:09 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Weiwei Li <liwei1518@gmail.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-s390x@nongnu.org,
	Michael Rolnik <mrolnik@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>,
	qemu-riscv@nongnu.org,
	Aurelien Jarno <aurelien@aurel32.net>,
	Fabiano Rosas <farosas@suse.de>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Rob Herring <robh@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Jesper Devantier <foss@defmacro.it>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Fam Zheng <fam@euphon.net>,
	Klaus Jensen <its@irrelevant.dk>,
	Keith Busch <kbusch@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-ppc@nongnu.org,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	WANG Xuerui <git@xen0n.name>,
	Laurent Vivier <lvivier@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Corey Minyard <minyard@acm.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 46/48] qom: remove return after g_assert_not_reached()
Date: Thu, 12 Sep 2024 09:11:48 -0700
Message-Id: <20240912161150.483515-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912161150.483515-1-pierrick.bouvier@linaro.org>
References: <20240912161150.483515-1-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 qom/object.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/qom/object.c b/qom/object.c
index 157a45c5f8b..28c5b66eab5 100644
--- a/qom/object.c
+++ b/qom/object.c
@@ -2079,7 +2079,6 @@ const char *object_get_canonical_path_component(const Object *obj)
 
     /* obj had a parent but was not a child, should never happen */
     g_assert_not_reached();
-    return NULL;
 }
 
 char *object_get_canonical_path(const Object *obj)
-- 
2.39.2


