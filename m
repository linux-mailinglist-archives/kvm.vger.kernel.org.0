Return-Path: <kvm+bounces-26354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00952974580
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:16:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD6BF28BEF2
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549AC1AC885;
	Tue, 10 Sep 2024 22:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AhhTXGGN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5B61AC450
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006582; cv=none; b=aphOr0Ul+yh1nIczqhY2lnETAM42bDPUU67gYPVxaryrw4UB8Jptu94PWMmMyrr8f4cdLHKnjk5pdWH0uoTno+A9F8vGYNBG0YCCg8sA9JFYrIqbD/UNkGhXVYGCBPCto4yOpYpLEql8eAF5pgqofACGzta+2MWfKsbNNwKcKDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006582; c=relaxed/simple;
	bh=EUOtKks6ZVWI73P5MJPZ+0UG3U4gHSXjeFlJw5Kc3oY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T9gaF0fRtbWnTChn4RWCcqKWRZkvP/NpEtBLq8N14FCMKAQwbKPm911lg6Cp5kWwG6NLXUSUqRMiAvsKslQt2+gPFVktscVICMGEWkj7PYTvkRYhfcevBAO/e02MKrjk2tBEn8wFPrPj1oMCZMoKGFrc8XkkrCgbLYkVOT3tH/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AhhTXGGN; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-718f4fd89e5so1253069b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006580; x=1726611380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4bb0fjpC/uXLETkc56Hcik4SHlsgHHXUYkY/bpvbVpc=;
        b=AhhTXGGN1O8umOEpK7dthwO5m9ShlrMdo7I9JeTCmNHN00fXw/JZesREGq+l9l8BM6
         c68WogWG073k6n0zhsco2Beiy5tjF/g64Ba+hya5XonWFzkRSM6xNcM2g2CtrJJw7axb
         3+Fv+SZsIrJAGVsGiQPBUyP4buasDVLuVMoo5l9UEEac82cISjy9phyVEqrwEyRkxHGF
         AXAvzl+xDPEbSGHd9krjPX2SOEo5ZQivx/sByJKSt4eGEAPg8xmBS7bcoAUPXSBZS/Bf
         +nwJPOpR7PT1HmJABrJnn5mxPsURj1fTUU1nIImgM7tzFIov+bxV/4AZhkkQdL7CHZ4x
         y/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006580; x=1726611380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4bb0fjpC/uXLETkc56Hcik4SHlsgHHXUYkY/bpvbVpc=;
        b=LN1fULFlIR+MC5sR7HLgzpC5+wWnyXVswox2Lgg1ygz8rLGJ3cRkm04Yxzdw0z9/oJ
         uGkkN7Cgx6mDzwUmddT3aCOVNd7rEJ3aKJOvRotgo5fa3iWDa17ZlvA5bi0dOY3EW7bz
         lYsDe9+gbWb1Hco0ppCL4t8vVlZP951nd4Ys74UTYjRBrAhWDmg6bafBO1ydgs48Sl1J
         kW8kK6WZxEwkz0I/+vR41jbFYeJEsVlS4CJaeUnDunrVTCoXAKSR7BCk64IAqQLUNdXA
         gZ38XGzlJ2hDX8zzO8VclHYk+tFwJX8mCeG8ti2E2KeEAmPgW8px24LtDrJg4JPhQp9N
         8CMg==
X-Forwarded-Encrypted: i=1; AJvYcCXalQkZQAQxl2gCuEsIIxheLkRWvTw3/KOsAgIoaz1dR8AThls067nJPtkeQ9tUIYJm/uc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmP/YEFaiyroAafC+qFM7GINqteyLi80gB2fn5jH7/pJYYC/Pp
	sJXo3szSlWoQv96y1jTYTaShA91hoduVUYs1RK7JiP9V9YS9jg2JBSjP+5EjNcg=
X-Google-Smtp-Source: AGHT+IFM7yoNH8xDo/vMJeUSRp0S9a/uDDcAvMhTSJpgsleZma8JtumByGI1crPqNwfnaO/FhIWNLQ==
X-Received: by 2002:a05:6a00:928c:b0:714:28c7:2455 with SMTP id d2e1a72fcca58-71916d950a2mr1273190b3a.6.1726006580270;
        Tue, 10 Sep 2024 15:16:20 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:19 -0700 (PDT)
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
Subject: [PATCH 04/39] hw/char: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:31 -0700
Message-Id: <20240910221606.1817478-5-pierrick.bouvier@linaro.org>
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
 hw/char/avr_usart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/char/avr_usart.c b/hw/char/avr_usart.c
index 5bcf9db0b78..e738a2ca97e 100644
--- a/hw/char/avr_usart.c
+++ b/hw/char/avr_usart.c
@@ -86,7 +86,7 @@ static void update_char_mask(AVRUsartState *usart)
         usart->char_mask = 0b11111111;
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
     }
 }
 
-- 
2.39.2


