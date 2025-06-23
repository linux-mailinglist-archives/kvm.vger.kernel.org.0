Return-Path: <kvm+bounces-50343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB07AE41D5
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:12:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E055C18912F9
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D8D24EF7F;
	Mon, 23 Jun 2025 13:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Znaye2rP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AD72417C3
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684312; cv=none; b=jkaB1609jhI0NsCZo4PKTguRu2JfhxuNleciPHzhdxdGfyxcKPcUfsD6pdqOrYXf7+uSHBr7KvN+0F1chohT41kMigy4pBRpVOed0q6mqHmhtr6Q419r6yF1K6fQGuvFseVzCp6UQkuEw/OMcKDNDDX32BsfK2L3u616nbfwOEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684312; c=relaxed/simple;
	bh=aipb6w3ZeI23DykCC3PlLKkpZcAJolTuLc30hg/kmOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chyDq3Iomwu85saoBPLQMZJdM9suTwk/EHLfG4L7dSza5NN+c2Ms+cb6WP41d/M1ofirgK3ktHut6DCcFmrjYdDiFBdNHBrkjn2rJXHbOKRjH5T0J57hyYALs/v9egpBUeNKG0V7aXbuSYNk4e5ZR1br+ATOoGcwL9utHuG5AW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Znaye2rP; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-236377f00easo47751645ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 06:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750684310; x=1751289110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=294f0NWEzhgQ1KvYHlyCdSwVPknM4JTUNd93oDWBhbk=;
        b=Znaye2rPNd6n2UgZ/PYE0pI/7u53n8OJCe1LRVuo27h1q9Y+JHcjIriYTYVqwL2MsI
         pN6DAshhM17iVI6ApNTuaSPItb4oviPcbR4GBqSSQ0j83SD0bjeso4BIB84I4a6flBnQ
         bkOGgq8LUU5JkHeunUGO9sir/1iTWgMWArkDKinE1XyS74ZwNr92EG5csa5XHO20X4wW
         bzPTe2cQ8t3lZFSOUN0Vriyl7AnQuc+53kVutHPkZQ9zTanJPKjVIJYZ+7dg7v4xAfZ5
         V9yTAkTUifSCXa4sMn/zQsoH3iyDn+FQtponRlh1tWXajjQEpKO33+j+hCxgYyG3BF7K
         4Vdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750684310; x=1751289110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=294f0NWEzhgQ1KvYHlyCdSwVPknM4JTUNd93oDWBhbk=;
        b=bcWCUrLtx05BduLMVPssBz7zX1WSbXCUieJIXHlo9fxjXLujbxfHOFLdJpt8/OlSu+
         DkRim/T6QuUYkycb73AJYdoTexz7QwEk1sw7/mqPYgfHsEwu8ChH6mabzpKA79de+EVo
         qsX1o3zrMofhdi5W1hn/ooNeurPxEqhNZtfEANmk+qvDhy55flv8n+qVFdRTnMkcpsoB
         ueznfgOL0rB71/bv1aGBmyoE91GvaS9gralWWkyaXhHWeN1hV28snEgEd73kW7pobXzT
         5YdfmOj0d0P52Oao1HWd72RdBK5dr0n8tMfl2JOg17pmTuY44w1y9LhRQ2cTs+jheyGu
         l+dg==
X-Gm-Message-State: AOJu0Yzxy2+ATk5k6c/QuPV0b+6xLRiDiOfP/BD7lTj9Kn9/SXWZgdlW
	chOex/qcdxuuxygiWLjEe9tFwunFRqBmW903QgCzPIUj27MCg4BIkcQm3L6/vZIkmKMPsA3OJNA
	tlK6zQXI=
X-Gm-Gg: ASbGncuEg1BsbPHAhtfJoyrBbkcJN0y+fVQnxhp+GVagLvoCXnC8pfvRDWX9ETT0CoB
	cpeYcv697pvW38BHAuUQ5nTnUCkuMVQwpv+idswIe5MLfBEk00XksG41TE+1QxDpG0i4Fl6ac5E
	0ZKII+Yjq5fMMnI2CHx/XnTuZRAEHg/t653f/A4GPK5/GcxQQz43WC0WCnEVVA5rAqfdwI7auzJ
	L6jO1cvkoZu6J70z3XFm/iI0toopCWug09HyjtnvoFYelksAv3PVXcj2DWymYFx95IyGqAfPxw5
	R2yEW0njsKHfn3UeVazipzWCTNcIOcD7FwomvxyjOlHC1vzwQ1fgGcYoPZETHz5xfYc=
X-Google-Smtp-Source: AGHT+IHbA49BPoVB5DhkDb7g3yBY6ntesarXpYb3Bz0xdGIJAdRpjLCElGdQeRGD69gdl7vWZGwNLg==
X-Received: by 2002:a17:903:4410:b0:234:f182:a754 with SMTP id d9443c01a7336-237d9bb3cadmr166890735ad.47.1750684310146;
        Mon, 23 Jun 2025 06:11:50 -0700 (PDT)
Received: from carbon-x1.home ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8673d1asm84314385ad.172.2025.06.23.06.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 06:11:49 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [kvm-unit-tests PATCH 1/3] riscv: sbi: sse: Fix wrong sse stack initialization
Date: Mon, 23 Jun 2025 15:11:23 +0200
Message-ID: <20250623131127.531783-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623131127.531783-1-cleger@rivosinc.com>
References: <20250623131127.531783-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The sse stack temporary storage wasn't correctly initialize to 0. Since
this is used to know if stack needs to be deallocated at the end (in
the error handling path), sse_stack_free() would crash if an error
happened while registering the sse event for instance. Fix this by
correctly initializing all the stacks entries.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/sbi-sse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
index bc6afaf5..2bac5fff 100644
--- a/riscv/sbi-sse.c
+++ b/riscv/sbi-sse.c
@@ -957,8 +957,8 @@ static void sse_test_injection_priority_arg(struct priority_test_arg *in_args,
 			continue;
 
 		args[args_size] = arg;
+		event_args[args_size].stack = 0;
 		args_size++;
-		event_args->stack = 0;
 	}
 
 	if (!args_size) {
-- 
2.50.0


