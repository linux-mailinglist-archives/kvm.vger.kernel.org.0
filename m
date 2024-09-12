Return-Path: <kvm+bounces-26631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE5F9762F6
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:41:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B20AD1C225DE
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:41:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BE119047A;
	Thu, 12 Sep 2024 07:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FxGeW4LE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A16B192B8D
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126807; cv=none; b=NGNw8BHhjh4/M9r/M8VOWrPrqBbWGoReilpgwZd/Dm7VCeR6v6yvv7qiv8qr2469I9VTuMRBe8fXOQSUo9fH9CKwQc2OgvLvDN9sQt9pJlcGP8dG+virXJ6yCpDtiYWfXFdEr8k7FiLdqC5e7/gAI1x3pIK0vyMwjonGz9GxuGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126807; c=relaxed/simple;
	bh=yNmoBMylyOucZGz0kA77fXTBlKvOobO732WuHrRADpc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WirB2uJdeTw55mTAj/km4FvBFvnVz2dX7jtfxQ3Hu3f5ZDyaBiRI+0hmQ0KJFiYxmW0yMEjazivKKM0xBbxbZeSSkIfDiZgS7UYuYMft/Kwzxg8DC+MI9QLw82Rv9z2lf11NtskLQFc5Ti+g3C2YkQ7XlowUwf88XrSpS/aGvbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FxGeW4LE; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7db238d07b3so384810a12.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126805; x=1726731605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5zF+jA5qLmLbmnQj5+SFXwtuz0TNrysgMomjB+iiCqE=;
        b=FxGeW4LEfYC29DC/05jVjWUJBG751UT449YrO/gAVV1DjhTkGQcFqClPBuEV8JUcNX
         xe3Uyof80UAGuQsV0iEUjI5kuteM5kyP//lgK3wQq/46LejHuBKtZh6GGNDURPLpy0qO
         Wv0X7j4APXlEqJujxCCTifkR6gWSJ+OMF/X6PfYtctjZxyhJIVp7LGUamuWGpeK5f74V
         zAh+4DG51tTbQLMPN9tW7g75xDDmEX4fcG+zs/IBoiAiCe/i2/zxQvvQ0fSq+TOO6cCE
         LUU0OGfn07nXhKjGx8HqazYuRBA80F4u2iLkgVby5D7/DgrRR13emI6biZ/E84hiGRPu
         t0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126805; x=1726731605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5zF+jA5qLmLbmnQj5+SFXwtuz0TNrysgMomjB+iiCqE=;
        b=iMNC2q4jDT+lEtIbv/W80ArKUrNXI1V1m24xFvVZ4Pgw8aqWU/k4LlJPLa9raCyeqy
         S2jX5JNOy6FO2TqAx7fourC2dZMkeRz4LggxHWm3OxLiXMaqfx/j+v5OkPsmRjAJNyJ+
         8GL8XS/w5DslLc2qTpat9R9Me4p/jxikMb4IyZXfJz/uZGAicWD6KYKUwxQ59/Kgqye+
         dX/yVvHfanJ9BhV4UhBZpqFReF6ok8ioZMM2VbqP2OezfFGI0GbCJKxUKxmhB+eGBVK/
         BNhXm3MOxdPgYgPobhijzgAjsEqe7ifqPZDR/LoPTnSF5f7yo1Rz9hYmGv+BAdvc/Rge
         jKmA==
X-Forwarded-Encrypted: i=1; AJvYcCVCUsUl9hMLX2D7uA8fuZZ/8Qz/fB+aZMDZUg7MPvgTqSPygPIki1CoBmpgj8Yisb0mWUQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaUoDNO4KJMPoMA/rANn9xPUKmHLeppwg4KJjIuI5UyduqhV8f
	TH0zFyHj4UOhk+03zU1E5T9ViSqRuXnLrp96tbUZJxm8J+6ieg6eV7BnsF4bOFk=
X-Google-Smtp-Source: AGHT+IHDXrX+NbUP9NtxGqG8dJEo0gfcy7xOv/m7ynMdOyBHgNq9WtYD8rjvMD0vL3Bh2gbeHd5Gyw==
X-Received: by 2002:a05:6a20:1056:b0:1cf:9a86:73e4 with SMTP id adf61e73a8af0-1cf9a86a035mr1164601637.14.1726126805353;
        Thu, 12 Sep 2024 00:40:05 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:04 -0700 (PDT)
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
Subject: [PATCH v2 15/48] block: replace assert(false) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:48 -0700
Message-Id: <20240912073921.453203-16-pierrick.bouvier@linaro.org>
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
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 block/qcow2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/qcow2.c b/block/qcow2.c
index dd359d241b7..803ca73a2ff 100644
--- a/block/qcow2.c
+++ b/block/qcow2.c
@@ -5299,7 +5299,7 @@ qcow2_get_specific_info(BlockDriverState *bs, Error **errp)
     } else {
         /* if this assertion fails, this probably means a new version was
          * added without having it covered here */
-        assert(false);
+        g_assert_not_reached();
     }
 
     if (encrypt_info) {
-- 
2.39.2


