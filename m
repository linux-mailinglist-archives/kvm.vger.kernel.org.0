Return-Path: <kvm+bounces-26370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A73829745A4
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AB4328BF9D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63F51B14FB;
	Tue, 10 Sep 2024 22:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xQ2qv6PI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37BD1B1D6E
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006620; cv=none; b=TNr2dowRiFx3yqtwRSrZvZTgn8kQFQpRgMFlPMX/K7/ndw7vUmGmsWLiX6kLEymchNz8jsODV8JbwRggDYv7AYA8QW6r2v6HaKA/qoU7nWsmoARPkqXWTb/XqpTfzzakpP8pUPFd2vfjuwxoNkZl0noerbSTUcTb6N2/8n4SxuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006620; c=relaxed/simple;
	bh=7LqFEY2QfoGxyVYwZS6fAzF+2VVFA03Wck9rcu1wO1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P+XO4RBYTDuITE5Q9IntO//wTAkbT0dQW5r+DasMeXFOj/SWfyy/sSbxSU7QAYbVcKTMCEXZPvAY2NA2370UMXZYxV3nk1eQzWhFRQag7bOlui+k5tlVG9OSblvn00a4HX3S7axBLcAdGCEizUkQfqGYrLKPAg8ESWT6Zmjo4Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xQ2qv6PI; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7c3e1081804so736972a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006618; x=1726611418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcrIg2qAf6uELGwQ4F3jw2Dk1PoiMNeAX8XN3cIVz0A=;
        b=xQ2qv6PIY/zvRlCXB+ejcB+sGEA9/t8I5pzbvzUfNOBD6j7Kp8vYIwdbuhA8es4hK6
         NpD4VlLf0laUS26NFmk9Ovvizb0QWo9Ng6YVUR1RbnAA6S8oemGteoUls6wfhhCfphMM
         UNjXG++nqx+UYzS6UmjRxMiJAf5YlRlMo38Qkl85FftKM0dBcUs0uzd5wLi29xv1zbL2
         rHKrjzxTtIB7UWKb3BEyvh8qXl/41p/YzsGlYp/QFdL56gQjO6fcji9lAk44s0mBkEI8
         7YffJuVHKCv73tIKtRG1PCPB3oHwwC6MCecl1JPIe6kB/g4gIfk7BVYGfwQZAgA3xtMX
         eCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006618; x=1726611418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qcrIg2qAf6uELGwQ4F3jw2Dk1PoiMNeAX8XN3cIVz0A=;
        b=JYAPqdS6cJiNERXuyEzkUw+VZaLtVBj1j2h9wDG/gwAHTX0z2OtJN0qt4EwPfsRoHd
         ALcKbg0JtL/Mcpb1gHu2+6RbXkXqUu80JvkdA8ePfP2jM7QlhkSQxnn8vL/L1bVdZXMh
         vlcCN+34uLnkzc8qy5EVL9LArgM2VLjbrGsU2SdhJhVYPgGyj37QDLwGLei8QBQe9adz
         8d+NeAKBTftqLOberFJZ+6hNR6gEyZF3spveUvUOA9Aa4ODee5bGhA+Z3qaars0anhts
         2kIvcx4tiFFeSfIPDQ/a/EmXlIf5ycxuuD2uEyJHa4E8/Am+A6FcRQM9blXt1tt6sQ/A
         h12g==
X-Forwarded-Encrypted: i=1; AJvYcCWO46hnpW4inhrmOVXA5TJhCsA2zOE/JW2k5O7LdYOf5VK7co0XgndUU/1UvCNtN6rmhK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaXW5Yjgd3m/pPffJg2yBg2AUUvOeFw/aAZUZfkEx4p47rZcG1
	iaoFFHGU/R/g00aR86QXPFz/jyEoG0vyAD3LZNhMASsnWhagqsiyKJmD0Q/0Qiw=
X-Google-Smtp-Source: AGHT+IHlXcViJ7Uqavmm9h0Agv/EoGh3ujOBi2hWwTsBLR4Ow1eipycn2U7OZZTHFj/uG0XH/qrB2Q==
X-Received: by 2002:a05:6a21:70cb:b0:1c4:9f31:ac9e with SMTP id adf61e73a8af0-1cf62d7bea5mr1368837637.42.1726006618086;
        Tue, 10 Sep 2024 15:16:58 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:57 -0700 (PDT)
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
Subject: [PATCH 20/39] hw/ppc: replace assert(false) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:47 -0700
Message-Id: <20240910221606.1817478-21-pierrick.bouvier@linaro.org>
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
 hw/ppc/spapr_events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
index cb0eeee5874..38ac1cb7866 100644
--- a/hw/ppc/spapr_events.c
+++ b/hw/ppc/spapr_events.c
@@ -645,7 +645,7 @@ static void spapr_hotplug_req_event(uint8_t hp_id, uint8_t hp_action,
         /* we shouldn't be signaling hotplug events for resources
          * that don't support them
          */
-        g_assert(false);
+        g_assert_not_reached();
         return;
     }
 
-- 
2.39.2


