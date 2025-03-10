Return-Path: <kvm+bounces-40562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE6B0A58B69
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E42237A3645
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25AAA1D89FD;
	Mon, 10 Mar 2025 04:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HyHMkFqD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09B61D6DBF
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582751; cv=none; b=CKAHvLpIbrHpLzQD5vTnX+r54VOj6DN8DeRCebwUzQJIuwDZDEzUqgTD9MI3v9LuEfEEmKEVSmQGWoGXrwgWLvnFEmx4X39vD6QMVGHaByfbc/R9xhfc3Dz4JEiRgrlfNqJze4Dehombjn4idKSPMR1/I9O2BEe/kyHk6bI0e64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582751; c=relaxed/simple;
	bh=0rtqNP6/gSnLmVrosh+fl1kNewzUJ5c0wYi2Lx27vqU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bzrDe7xJ8yZZ7A8OuYJslcTfZWqZkXuqIf7SkcvrvbplxTOla13k8ww1vKNiYMUF7EY+TyRchAInjeqJyAXQdH08xYnryDogYPZ7eZTrj+IqS0fMM7fRXEr/Gs8PnkARaBG3HE42Y+uONLjufUZeVWcUWHRcm2oli2se43QflmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HyHMkFqD; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ff797f8f1bso4650734a91.3
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582749; x=1742187549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yo5TAW5cQeh1DHP1d5HtuffIuVKJac+rUoQhULbtd80=;
        b=HyHMkFqDThs4hofHwm31AWtM/+H8/K6Wdi461uqx7SCuk/HUcVfZQn68qGOqYChLwH
         CA0yXZPzsUkkZKgKtUT9oVVG8D7AgqgTtAn/jfYWCDR9jr4PM1L8dweIGttZTt/XOqR7
         azou/fqNUDTrvA7JNyMyvb5vnZ31/LS9qoBIOor9/8aYxrM/Nt9d2HjGYKYwW8qIsg1m
         oEE2B2UxQpTmMNeLkU4tcieyFRZAagCzTyoUK2polkLwsPaGPbBzJLK0y/ESTe73pRYM
         OIz9fl29wkz1/NjoFKFj5mXyZPxRxhRB4k2pv965amMWsl/8JcBvZ49EEAqeCR5ko7D1
         0Wpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582749; x=1742187549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yo5TAW5cQeh1DHP1d5HtuffIuVKJac+rUoQhULbtd80=;
        b=wdoXtuaxEYdFy5MIzAXY2Gl1KaN5zaLopB9yFQEMxCVltSe0nRmlvT2hRQ8dCaanqr
         RyVv5RRIyG4K2rAuV58V0gMme0idc3vkM8UM21cVu5YL1zkX1skhEfywXUX/PLzCyDmb
         rDsVq/fNm7DwOSRTh1o1h665co5TInJYw90n1PRqIvgCTDK7RD1mHL56EBiHB4qvz8XJ
         YQHlzOdPI3K1X5hOKtUJSQMK2WLkNNAcOUxsOoGWOeebykfw9BSi32LyFfViaZl4C7IX
         M8K6nJSoBpULJWdcsyOmrrmuNYeugROEcM49i2oMr2VykgftFrRvUg4JiV3IxeS5MHCn
         nd5A==
X-Forwarded-Encrypted: i=1; AJvYcCXhoXxnmWOC+H2szv+nUGY7p8I2ddAssH4AomAPUBj28IFphpwQkj6+rDzXV1FHFzOoJJg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwX7/hj13a11I8R9OqQq9rZiBaq4F6H72Pdm8KlCF4oHoFoe4W
	nRzG3LuZgWhYrXNG5yJCTaTZmBxWuQ91peKM1vJaNqaoEkmM025TSHu4kYE4hXI=
X-Gm-Gg: ASbGncvo/idC+Lkoq9pF9iFghjka17SoTr7V9Tft2XiOlFB+y7E37EKy/iC/icXfBTB
	PLO5RzBBEPG+O+K1Gg/PlpPlEDHzfzaCyPeXJ7iphkwyXEsFkCZ1A8eqPmioKC/Bztuw2VqZyYj
	k9kNDBHBMjeCPjrgG1buK4Ly2973ZXlqobGnxZLWHF38u/URf40tFdHnr2pbwY7eyJxKi2OxdqJ
	4kVw4OqykPeO99iwYh+v8Ua1Nuf78lK0kVopJ16bMkUL85dcdrjcPjNuWznk37CA9uCM7q4FUKl
	9Osr2mEFqDMWcu5+urueZf4vNur7PHucUJZETVSQRmPL
X-Google-Smtp-Source: AGHT+IE5gWrqVh7MPBsCW9xpH4WbBfOw86WZFsUWQXQSa3FRghy/XQpC1OkuRKA1xd7a02NCd2RqPg==
X-Received: by 2002:a05:6a21:6e93:b0:1f5:6e00:14da with SMTP id adf61e73a8af0-1f56e0016d7mr7868375637.40.1741582749217;
        Sun, 09 Mar 2025 21:59:09 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:59:08 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	manos.pitsidianakis@linaro.org,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 16/16] system/ioport: make compilation unit common
Date: Sun,  9 Mar 2025 21:58:42 -0700
Message-Id: <20250310045842.2650784-17-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 system/ioport.c    | 1 -
 system/meson.build | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/system/ioport.c b/system/ioport.c
index 55c2a752396..89daae9d602 100644
--- a/system/ioport.c
+++ b/system/ioport.c
@@ -26,7 +26,6 @@
  */
 
 #include "qemu/osdep.h"
-#include "cpu.h"
 #include "exec/ioport.h"
 #include "exec/memory.h"
 #include "exec/address-spaces.h"
diff --git a/system/meson.build b/system/meson.build
index 881cb2736fe..3faec7e4dfb 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -1,6 +1,5 @@
 specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
-  'ioport.c',
 )])
 
 system_ss.add(files(
@@ -12,6 +11,7 @@ system_ss.add(files(
   'dirtylimit.c',
   'dma-helpers.c',
   'globals.c',
+  'ioport.c',
   'memory_mapping.c',
   'memory.c',
   'physmem.c',
-- 
2.39.5


