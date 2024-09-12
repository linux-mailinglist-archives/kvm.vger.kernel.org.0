Return-Path: <kvm+bounces-26651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3882976317
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8D3A1C209AB
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10D818FDD8;
	Thu, 12 Sep 2024 07:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CsklWBLI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00FE1922F7
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126861; cv=none; b=WCehbeDPI3ZXvNf/TkBX6ZNJ5njgGv9HgwRHitc8+7+52V6dPiEmWP5W5aQSPy88GhpzXLUgQz1p8dGS3nsL9bk2med3JwTFVO37WBWAuCZNj+8KJWc995ylYvmRtI2aZq+8szmPTDh9+6H3TLbGaIrUWSvuyMYM8f0cvbihgSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126861; c=relaxed/simple;
	bh=lL5ZkXGgK1njnARcmjFUFsniCJVNlmy3bhgJsBvYxoM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XnK45Ut6o/QGX1mz4rG7KzqkOYmOjtruPRbC7rb4xv2DUHsAgD3arkgwClyxyZBtE49p7mTKrn1FJu/5VUjXCkZrh9bsoQs0q+/tl29Co/3qtoc3K3+KvWrWcbiUHnmcmHfzeNNCXT71LiwQ7a/O1hd0z5DZtmA8erhlj13x8eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CsklWBLI; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-710d5d9aac1so264769a34.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126859; x=1726731659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UU43OuMIYQY5gzBd9N0OsX2nGrNJ5ON22GSd3bl0bUA=;
        b=CsklWBLI1SnXO1XG/Dx1uRLQm9GLkrjfgVO+kXDwIHkwYlX0FJGm7V93malWYwASgN
         hBzuhs5cgbFscNPD/mLahPRg7ya+6+fUsz5hS9dJc1H1CCX43HI85wjPBHljCBT3WM5I
         St7kuzNvOaEXljKBtQELpm6Mj+Dk1hIFCerL9YmgE+rEWIkNaBPspfBioWwMq0oFx03M
         1DTQgZyO/WoY75Gnl7Zml/jz3TZIRczxTTohTka8dFLVNj8fYzvx5l8RYrrIGamqZ8WO
         qo9Kqx3sLBWqVhsKvXsG1ZR+NjkRmmgVBLA6Woo+YoQQyJGgF9zrM32kRwpIufntLiJw
         HqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126859; x=1726731659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UU43OuMIYQY5gzBd9N0OsX2nGrNJ5ON22GSd3bl0bUA=;
        b=dh7sMcK7IugZsf7e7URmdNoa8cjRzlz4nxuCkfR7w95Bhi1tstvNaF6NCBhQRUKT8N
         X/4ZJo8A0eHOrZTnCDp/gIdJZUCNLXykOBx8J4+icbNUgJYGDRkWBUBcTJ+u7dI2sh3T
         coQA/sc76Al5yt0ITMfY83PkqvAVeLi6IaoGkrb+p7qw9yltVQ04MV96QXZLUsYNMRwz
         4pCG9Vg5omhIuFVhYRb/dwswi/KSeOZC5I/NIVKaKrvlL47glkkvj3yTq0PqkKSnHlOp
         LoeJO0xoZOygwgwOceFEEVI3lYy0eqcWT3N9W7IrUsSyQ8/5MIRP5IBNM8pot4NCRrt/
         To4Q==
X-Forwarded-Encrypted: i=1; AJvYcCV5S2n35bWdHjP8LQxpzmipN4E0DGWmek7blWptbAEHFwOJFDGAjdtEQOvbty2yLjAaLEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSf9Oug9rrr8HqwCAr1ECKtlLLRpkajWDMmmz0Y0HQgaB/cQA1
	xXQVloL1iEgWmlmEEKoNyENIbLG+BTfksHXFhAgdSQjwawFwyTPJLH2oxrJ8v5U=
X-Google-Smtp-Source: AGHT+IF2wNn0ur0oT/D0x/ryrXGcpmcSlu4jLOalBhzoC7Sb43ZM6r5tgiThqhwY6bCeeW8Z+2hNyg==
X-Received: by 2002:a05:6830:3107:b0:70f:36ff:ed09 with SMTP id 46e09a7af769-71109571674mr1236876a34.28.1726126858602;
        Thu, 12 Sep 2024 00:40:58 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:58 -0700 (PDT)
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
Subject: [PATCH v2 35/48] tests/qtest: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:08 -0700
Message-Id: <20240912073921.453203-36-pierrick.bouvier@linaro.org>
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
 tests/qtest/migration-helpers.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/qtest/migration-helpers.c b/tests/qtest/migration-helpers.c
index a43d180c807..00259338833 100644
--- a/tests/qtest/migration-helpers.c
+++ b/tests/qtest/migration-helpers.c
@@ -76,7 +76,6 @@ static QDict *SocketAddress_to_qdict(SocketAddress *addr)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 
     return dict;
-- 
2.39.2


