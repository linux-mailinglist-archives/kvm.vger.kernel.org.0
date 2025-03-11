Return-Path: <kvm+bounces-40737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC703A5B7DF
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:10:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 399097A8ACA
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91331EB9F2;
	Tue, 11 Mar 2025 04:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i5LeSA6D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4AC1EB9E8
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666159; cv=none; b=otLjAIy/Fa0mEYk1+v8MGZyE3fwICnPdl81wIiri6jXYDXeinuskXx5ute3MQeX/J0sAd9/+YQWq7gYp+W47cVA49Ojyof/a/PaJiAaQGJ/AACd5/d4E/xINBIV2U3xM/qL4hU3q8aM3GyFaiXNz33vkNWx5J+CL3BwvKrSK8Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666159; c=relaxed/simple;
	bh=BkkUjOWmF7t6i9tbUmPiymzR4gYmq3p8TFOqgr7W9ZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q/0HyX7TL4AIxDAgWT/pMCZvEKLPSBzb8j0TmpDDPZUoxb2NOKakZhCZxEEaz5kq4ZAjwH02ZGbKPK4KoMxCRxYj9mOVhmiJmPwv+dhUGXuon8BLqk1c1ybB3x8lfTc7q5Ic20MKRCJyGZ5OlrEntWCnTSDrlpu9PfJt06R615w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i5LeSA6D; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2239c066347so87019285ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666155; x=1742270955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jGKe5PComzh06JRRSjyC3R7ujh2oauOlO5efOCu+zg=;
        b=i5LeSA6DnGU1twwaWsugFWUoTBl4BQ0huuqfs8iK2RyaK2mdtRsGNMoT0K/LUlLBcY
         9hUNvlhNjs77k5cLdiRshJtAQ+UsUOpejnluZIkSUEZThacDBTb8RFy5vMvstl/MvtYV
         njZHZCpV6kjtIpawUOB7WLXdPU0gCFir/qm3554wIVSZltR7dCB+9duFJ92d74Zh87P4
         e/h2UANqFQILaXxtuDChDBPANoLA8cGMK7InGTG1OLD0l5Fz5Px549qvGjABOjELqmRV
         dSMybRPnAxPiNPAO779cbY8Mj6wYkj+C1+Tx400BSWdJ/QAtA0K8wI349WIhLZmVGcb4
         bKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666155; x=1742270955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/jGKe5PComzh06JRRSjyC3R7ujh2oauOlO5efOCu+zg=;
        b=xAVcakDRSJ8v8Djxe91o38kmYng+ahjIVV78TtTpvOFwyZyGSXw/5cILOlTpJ7GVR6
         yTjnjMr12f48sk5fM0/u2JDggTgHtdloi/SPW4IQmkxUfUEziQJzn/szL5I1GuniSNWO
         r2dr+nDFGoRdYO8mSEVEnsm3XAcH6lqzT2lC4GrMJFLnKd4z5UWd1wgZhDq3CBSbPrVe
         YfT3H/QUzBoVn0MGUZUZIYhcfkGaKHTTVnWrimZl7gYJqaI6zDBIH1AaiKLfSpVUFk24
         K+7R9cJ0d6hCBF22p+pOK9zRctNBsgGDC/aUuVJmrVhjwSvsx6pFl+rCNuFoyZRCudKh
         LXVg==
X-Forwarded-Encrypted: i=1; AJvYcCU0muZpn9L4X/DFaKUmil+7aX9igjVTyusrRPh56k7LUYTUV1j/yp6QzARjKQhwB2YSICA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQtAJYSa2lRFTDoiOBCg7Iw6C8NEzwoUkwh/Xo0CAcX2yp9sKu
	NgvztyYKq4acOaDLRbBpUddxBKjGvbeZWVWWmH9/zD1TcbsD+F9MmPX6ybj7DB0=
X-Gm-Gg: ASbGncu2J4GXrfYk4nJVf1rBBu2OdS47ixHLiejnuT/W6dTursl8ayY7RnNVtrfxOPd
	o5IKQetGRaOgZCr7NRPQEqQc5j+6d6Urufc55n5cJG4woj6i7eBtxGOpe8nglUuxeefH2pv078i
	Wf42/TDIn8Zm00zdlpg+nvZFOi9ByQ3aD3KtjTej/AYHL5NH0AIU0x7B3A975CZdZRjmAoKHmmx
	T24ks+oVsvMWy4vV3Ef2D0u17xYPz4Peza+Iho9nvolsLcbWO8EvIqPJ9eHxZg8IT9zBRle7+uA
	V+F5AM6Ak9wRZRPk5cYKltGZujh3jzWtAR8SmaaYtCWd
X-Google-Smtp-Source: AGHT+IHyNZlPl+mr9I1Abk1OGoyMfz7g2vsqkJBEqYSKDsIrZops7PpVKyQRnmB7QqPJXfOnNuaTjA==
X-Received: by 2002:a05:6a21:6f8b:b0:1f5:8b9b:ab56 with SMTP id adf61e73a8af0-1f58b9bb025mr4529566637.18.1741666154964;
        Mon, 10 Mar 2025 21:09:14 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:14 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 16/16] system/ioport: make compilation unit common
Date: Mon, 10 Mar 2025 21:08:38 -0700
Message-Id: <20250311040838.3937136-17-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
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


