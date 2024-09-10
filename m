Return-Path: <kvm+bounces-26377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 081A29745AF
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E089B24812
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C56B1B3B2B;
	Tue, 10 Sep 2024 22:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WXvTJVLH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572831B2EEE
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006635; cv=none; b=dXEdx1BjSys3/IC3MY6yN7FiEDCGrAG6Oqh2DYL+c+oaa2Q2zdxwIgpDpjGa08+Wmm6iYFDS7tSREeih8so4fwi6So0uwBFFB0ePeNqfu+6MVE5mrmbXl1WBfoa+Blp57kxsoO7rEGRI35vKmKskHUGlNfLTpmkSlOQY3CzV2UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006635; c=relaxed/simple;
	bh=SVZjWH7PGIBui6S1kK8Be8JE/Mk92uvBK0Ho+9B/nMs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MJN8MgHDyc0ZGdLYiRte3Jqt8cdLyVK3IVJ1INQQmJlrk/cudFDXhJ+3ye8OqGJHwOzzZAPI8dUehYDKZ6WJ7BGJO8N8Y8pGwHI9bKG+ud00A/MihkA8jVzevDrFJ+gVb5szgH9P8xlQboprD8Jv2lZumMs7pBj5+oggPaadWn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WXvTJVLH; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-71781f42f75so4835015b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006634; x=1726611434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ywE7aBllZLgmnJKdHtMZdYUoug1zQm9p/Yk1hU0pi0=;
        b=WXvTJVLHKblmerRcdpGQSqM0fPCrHwrUYg/on9ak7t1Vj/7IRB0svokPw3zgoqrjIU
         5hs6Fu5v0ydZcBESnTl6EVP4dDtJSun0hwpPGr8GAGU7zjOZiLIbkRAXM+zsZY+z6Pqb
         zMO8BncwXgy9Jo5sqTxT939QiMe7sAdizOWJFeESgMvwgw6EaUcNwo+JtfYrUukXR5zB
         PebxYOWFKf5JbmIo2IoKwkPfnTdH/kMyFbygjg3pzoENzonHg3rDCRsg61toslBSrMAd
         pWE42nSZSXn4EjDOTQwBBq0pKwLn6w7A43wvLLwjUwFQxuAdGiUKTIdXLX79zQa46Eav
         CCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006634; x=1726611434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ywE7aBllZLgmnJKdHtMZdYUoug1zQm9p/Yk1hU0pi0=;
        b=l90PEt4SjBsPc0XmzICouu2rvEgtLwsazqmPwLG60AcFOJYQZDjALTpqt8KztcNg3c
         aiNPzvMqwruB8UcrymGZqSwT8jPMUHIFBo1MPArSRIkfaVzzAIR7r1pzR7t81ig5QoXv
         t7EuCbpzdyuW4BDUKYXTxkwYW70LNxjEGjx1oiRUtNg3hSnR2Pw8oIv9cw9IrtTi2EdL
         qVqSi6FmV/S6wA2gMqbLwCIoD2DIK5vkwf3bbIIUojTlF7eteptzWf84EnT6qwyNWujs
         EWmpFxuKhzPBP/rdTcVIO424MJjWeJfOCRlYZCCry52ATL3d5hZmwgfmnvwCPqpRvxdI
         zkUA==
X-Forwarded-Encrypted: i=1; AJvYcCWuOPqMh65iElZEVNrtk7+mfkhODhrMad6MeWZSCH3Elp/Kt+9HCh/qzo/xOWfaZYoWSBg=@vger.kernel.org
X-Gm-Message-State: AOJu0YygWcpYWKVtLQr4L+yUnql7pUD1BoKQVmDWkgAulG1lP/5Cm8Ps
	hSHqsEB2Nxg+xTKAp+Na6xSkcoghhzaE3VBldT7X307f/V5JXI5k38DyQywTMXo=
X-Google-Smtp-Source: AGHT+IHHTIm661dnrLfProZH8rQf+m5V0dPJUbPuYgsdXc/eGTx4AE4PeGXzkYEx7p3OoHgG+hD8nw==
X-Received: by 2002:a05:6a20:e68d:b0:1cf:32d1:46d with SMTP id adf61e73a8af0-1cf5e19e225mr3167109637.32.1726006633892;
        Tue, 10 Sep 2024 15:17:13 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:13 -0700 (PDT)
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
Subject: [PATCH 27/39] hw/gpio: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:54 -0700
Message-Id: <20240910221606.1817478-28-pierrick.bouvier@linaro.org>
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
 hw/gpio/nrf51_gpio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/gpio/nrf51_gpio.c b/hw/gpio/nrf51_gpio.c
index ffc7dff7964..f259be651e1 100644
--- a/hw/gpio/nrf51_gpio.c
+++ b/hw/gpio/nrf51_gpio.c
@@ -40,7 +40,6 @@ static bool is_connected(uint32_t config, uint32_t level)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 
     return state;
-- 
2.39.2


