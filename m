Return-Path: <kvm+bounces-40966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F32A5FC15
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 149943B4C7D
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF33326AAAC;
	Thu, 13 Mar 2025 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FoMxmgg0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C3626AA84
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883973; cv=none; b=H3Aa4wozQBHe6eQ8Am4GVgsiPWi1SoI0Ysw9x7Dp4gTlflpEa89dGLMdJ3EMXCy4zuPWfoHfH/UEy8ROV00rMgn62xcXh16+c0J6HTmBjU0HezM1hXbRFE5yqfshRc5Ixpfom8e61gqdjxfVWYJba8rPsDwXO+Fq/7yq0sx9Zu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883973; c=relaxed/simple;
	bh=8cc5k/dBJ8A5yXdLs7/Et5ghEBM8BXgwEWxHnVDm94A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nlIb8//Vb+9WALXfeGDgxe/FOJ8LFqQm/e/4tW+PxbfOK8ghFMcmTyi8Mu4pqJE27t/XJmQr2cITnGmwR9+E5MspW1YOEtmytcNvlWaOUVhpZc2cSOkynvy6bsNn/gvcbs48xwkNIeqpYEqNiGRIh+j1RzfuOFEb4do3pmqSHJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FoMxmgg0; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-223fd89d036so26176715ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883971; x=1742488771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdsNHldr91xnqdGHk1DTLXuYnmkD/cCe/HKmA2EoKL4=;
        b=FoMxmgg0Y61b0vfXL6BoCPEi7Pm0K8qEhuiJVod8DztrLMUVt7GfqE+F0Rq0gvvmwo
         ZyQXaPICzHCzqIA+rJdrT1ZSaY7qOMYksrAnE2hpVV8kbQtULbbfmKzYaxAtBmy1TLkh
         uMyAY3PeSwtJO+fXSeYnUVQxebGoSD4aBkP0O8HSD05mHMQex2iPc6M45DWIEWzZ6WXK
         nLovmM/JiODOw2wXbM7MqPUcIDE6zYOrBWsQPyIY91vzjJJL5BTGk3wh9Hbm92jWyECc
         +8GGTYP4SRgI8smZwQQ9nvT4Xg2QgWgpPHo2cQBrvCL/OW9F7G2VYItMe5GETdnz/tmU
         YDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883971; x=1742488771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pdsNHldr91xnqdGHk1DTLXuYnmkD/cCe/HKmA2EoKL4=;
        b=ppjwQBQqraXdbTNKW/5FAp3b1yJUH1rpHJZ4NlCatWYOyitzoXTPM2jGpDD+GkU86r
         VAGd3NnEKd/o8m7ebiFKy7qh1yXEXkf+aOTmqH8eCR7tAlVyoJhg7i8WpiOOIwhksiqY
         r7NyPMuIjsEHjQr9MnA3kjk7n1+pyMLETsWqhtUkcbzP5/XeBiesSIEdPxwM2caQX0xh
         B3srgqaeG/ilNxaHT1QVosTqoUpKgOjib/4nMJ+7a4F1nJKWjzPGzAz/BEUI2DUTUpiW
         rxfIY3aMxBispWPMW+SExLuz6lV6AAJU6Kb9ZCZ+VjTVOCt/o/cgkxEJzT8KMHUGtBTW
         Anlg==
X-Forwarded-Encrypted: i=1; AJvYcCW+aWabrt0Pb9em1YR0gXhiW7cVthPt8sYFXq5hWypgi3yfC1TulJx0TddLpm8xsIqOBoc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNK1TBbZ3IPo0AH7Sx4KcKSmYP5nhFrh/h56mPxJ5urs2S44vy
	u5Y6i9+QqO00YbnrDNHm7YS7d0RZ352UsiXUhB1mF7Wli8iKetgvy4j6VwxAzIU=
X-Gm-Gg: ASbGncvhUu/X0Q7yOS8U3s5fyP1l72TWtS4MVBMwGS0DefyaEnKE+ATvRCT+Y0+S0Mb
	aUqsdwvbE2ykSFWv1yNFF5o/zqS2hq0B/M1XJd1Es/kyJyCQpFVz1O19uYYP/iTK98u+TWwk/hb
	uOXGkw+VKcguz7AgOpNQsVm5rR8NWOKgg+5NFcUlCaw52i695HR8zthqcKKV1DY5Kye3q/VvNCU
	oSpa6LeL9uRobdFz6JNKoYL7LFWLFcwYf3jW896bveUAm7jlrCkPjarfP7obmbacf0jlPFLhMWv
	828wywkIZBaX284f22yC5HQwQwlGT41ScEhg02N0+ES6
X-Google-Smtp-Source: AGHT+IGwkoEmUkadWWuwDPp5K+cQQMib7Zg2jJHfpZBwTIoZ4S09vzdl8DeRv7aJJJyLYJnLE9fiwQ==
X-Received: by 2002:a17:90a:d604:b0:2f9:cf97:56ac with SMTP id 98e67ed59e1d1-3014e735345mr385635a91.0.1741883970945;
        Thu, 13 Mar 2025 09:39:30 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:30 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 17/17] system/ioport: make compilation unit common
Date: Thu, 13 Mar 2025 09:39:03 -0700
Message-Id: <20250313163903.1738581-18-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
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
index 4f44b78df31..063301c3ad0 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -1,6 +1,5 @@
 specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
-  'ioport.c',
   'globals-target.c',
 )])
 
@@ -13,6 +12,7 @@ system_ss.add(files(
   'dirtylimit.c',
   'dma-helpers.c',
   'globals.c',
+  'ioport.c',
   'memory_mapping.c',
   'memory.c',
   'physmem.c',
-- 
2.39.5


