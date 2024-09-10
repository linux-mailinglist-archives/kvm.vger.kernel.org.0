Return-Path: <kvm+bounces-26357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A295F974588
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D28041C2110E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2A51AC8B2;
	Tue, 10 Sep 2024 22:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zuLxXrIn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC8C1AC8A0
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006589; cv=none; b=GMGm4DuzqMDoBz0BiZXiDUTc0UhjldCIrsSjCCRYqU3QlRHDXEC6Kv0OslpmU4Y2BBTDqQubrL4QEPto+Chfi5LxYLIWgAj4MIg4RhfByxKy0v5lrZjbKlkLxcerSLCPSbfYEGhXA9QiNKui+eWeXyx9z5FXw1BJjGktG1Ss4/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006589; c=relaxed/simple;
	bh=RXu8MkbgMXpefN3GL83r1g6q5hFCtAzQ5sTuQ8gTpO4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pv5uQK5Hss5M8EUyH2D4izijJVbWAH9GWzLfWaoUJonTRMOilYv6gqu2E5fpqG9QNUxVD093c4tlUCPTCpp4OBDwGraEtJfil790y56mFKTYl80f8WwsO+BX2azEt9I3ZeWqIPECtqI5DgKuRDyjIT+dOfLplz50i27x64jw2ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zuLxXrIn; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-718f4fd89e5so1253181b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006587; x=1726611387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evr5nxnDoGKUr/y5uq9IdG4R5sIImXVpCjqkjM7zT2c=;
        b=zuLxXrInkNv389lRPi4XCeGHSUENhGfST0b0Lm8FXRaX9QtlywxfK+qMRIpxdyBrx2
         2Kh9vFrnF0vJ3xPu6EjJYih8JlsqKmH5uuTyiAmjGFD87eaIw246PyBtFt9bYG5amGIv
         zYEZdgM0kcWlY/oIaONOgRGyYvX64GCnbviC82Xbe8OEuqLsog39Nho+Fq0fGLLEyEby
         ujrXqbIuwNtBrk+i3X1LFf8I2qmuLfIJcs864uI5U0/UVEsbdOyCJaXQ++LX6I55t8ZQ
         Gg2qoLxjRyBMjma/XdG93Pbfimnep27huqnUdV4SAj16Ugcogz4LJb2U+31cMCYnaW+P
         hl4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006587; x=1726611387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=evr5nxnDoGKUr/y5uq9IdG4R5sIImXVpCjqkjM7zT2c=;
        b=QXL3ElTMV7wi51A6RTM+GgOZR9ZXXSNW+SQl1h2W8Gp3Agqxh+CITZshyUkGayxV7m
         v7uEAfNXADcVgyJ72IVHjqjYe6xTOsC2OQ/3vE3kgTE5oyJaVYTaPbmbXK0YLUDCFOBC
         i46c9lRZ0oDKbUSdUVsOVrUXyreKHbNzSywfPIeKBt7sYYmTrkGiqlXK3vbeVgC9qBgh
         tRiJ6tF7PfvMJ+DajR8UcHk7YQ7DNP3X9uF+o4cmOhqVlc0+3QgVLStykDbZWjogJ6Aa
         wG/QCzj2SKPQkrAL/JC/t70nVxsD0D+lBbQWgxfA4ycSj/ucK2W+d3L6jBb/VW04bBbc
         /51Q==
X-Forwarded-Encrypted: i=1; AJvYcCWDKkjh4ZmsXdiKbSVW4mvhqwpU61BB64rtbbZHBCr7dE0AGHRSL6icEepHQpd9QYhJ1RM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy19wfovcY0qDOZKRuwAT8kOeyzApPpX+2mFfP7UwMTRqq7pKKw
	i9TPE42njOzZ2IifF1VCf8mzXdMhkxcWpIvGQALinsCvvsiVLXrF1w8zvIxVY7w=
X-Google-Smtp-Source: AGHT+IGXKqllEsnkUm0CvfCkcCDSr1DZ+m3eTy1QQa0XwW6UoPGELkeBde/1LfDNQnnnco07gvAb6A==
X-Received: by 2002:a05:6a20:214a:b0:1cf:6625:f08 with SMTP id adf61e73a8af0-1cf662514d3mr560108637.45.1726006587131;
        Tue, 10 Sep 2024 15:16:27 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:26 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>,
	Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>,
	qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 07/39] hw/watchdog: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:34 -0700
Message-Id: <20240910221606.1817478-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/watchdog/watchdog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/watchdog/watchdog.c b/hw/watchdog/watchdog.c
index 955046161bf..d0ce3c4ac55 100644
--- a/hw/watchdog/watchdog.c
+++ b/hw/watchdog/watchdog.c
@@ -85,7 +85,7 @@ void watchdog_perform_action(void)
         break;
 
     default:
-        assert(0);
+        g_assert_not_reached();
     }
 }
 
-- 
2.39.2


