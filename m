Return-Path: <kvm+bounces-26652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15222976319
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3202EB23F14
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44BFE1922E3;
	Thu, 12 Sep 2024 07:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bUm3sKaS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1417619F409
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126863; cv=none; b=phRyR/PjtvFt5/wcFFPGkrIN0Lx9kbQ6yffN/E+Ip9IoHpLhcfo+N3i7vPsJWcXnRA41fkUeS1rJyW1k1pMlVPJWaSX8fxjNRkJToHy+lxR8MJM2PvKgUKGSJiEB5fKw6FLBa2tFCz6nU22Fdf0WhIcTKNFDpZ8dVCDCCNuWtMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126863; c=relaxed/simple;
	bh=8H1/OH4Br3oIzvlrSG/kOWgIs7zGZjCOJy4WQ3GfVPM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dl51TMV/woq0j05UnFASnp5z8dIqb5leuzL9o8KEnZ6ObTurlXjEj/xUpdiu5SOgMy6AtoTAOna6rEEHjqEGinS6DKuhkN/7ExwPJ3PM7+txgVesRluOp8u/tbh1hjbenzoFq6MIK0EA9nwpPSdPbjEzVAO+lSx3CuLGtxq7vrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bUm3sKaS; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71790ed8c2dso507458b3a.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126861; x=1726731661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aRhqi3ndGuxNd7tYiOTJthgyMGQ64hBDEtZC2U8BXx8=;
        b=bUm3sKaS7Gw/QLCdg0DoyvYDH2H3wnDkTfvLyPm2IeKoczjyDvt7IeHlS34An7lVMa
         CHUUwvtE2vH9t2HD/0fn/QLb+dDPoaED+EYGBixRV2helGCXmjoG0hDJNMC9EsjxVF1C
         XP48QASUoyONsfd0vxzpmtfB610i/xnbvppMaLJxlGTyMy/3GJ2td42xmS8S88BCos3M
         VSj17Mr73CUzokVfvB5l/ThXaXrh19u0WhQvvCZqzpj/dndEUkEENDoC1Ls/ItlrsNDE
         M8LtwHvxutXI+w6jPRykN6GTIONOUPciL2/E5LexCEIELWC6ilC+CBVbkkCfg1prusgB
         yiyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126861; x=1726731661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aRhqi3ndGuxNd7tYiOTJthgyMGQ64hBDEtZC2U8BXx8=;
        b=uvSnYBfBoOOEH1/vwXqANYboRxNW9VP08umt2SgsuSaA543bQljz8aa+1gLSrzRz2y
         YeONLOGe8C3LjgctnFsXC3Ux/MEOLDzwLxnCBCsslWmhPZLWYv6t5umvsRkIqXcsvI+A
         BoF2UWGxWDCGo/sCoKM7udCcQQD/sYppIZFy98FSVlamDb+iGpXak09klnq+0QaUDrKQ
         Mpfe4didoMQmqKsAnLp8O3HVCGJ38CkMQrZdV6HyAfu2B8DSA0wMFAoOHl5wcVyPLrHN
         gKDhIXwbHy5gsFPXRNzu19bLOqZ1xZ+94lXreYlBMudTPbXiJXkGHO8XON+TLiNWKScy
         kgAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFhSg3nX2LUY4Dc4SWHBYLNi5LFgFe/PRql2+8RtVIyAYJs2LQGRaWVGaoENv8SwIfNfk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgqrU0MF3SUoJjiAaoZTqNaPrggxOc90cENM75DC0AisYTXR6c
	5EgQvzNEbYtD9R0yxsN5a2di9ydLe/RUQ0pqmZ8MHRYjKm78WcbHUL1ACNEhQhU=
X-Google-Smtp-Source: AGHT+IGvK/n67vexDNSV79VALisw5Y++i7pBybF1QnzpQzK+oXQjb+Ja4u4bg2whNjS5JPChzGsWuA==
X-Received: by 2002:a05:6a00:218f:b0:70d:2892:402b with SMTP id d2e1a72fcca58-7192608123fmr2966919b3a.7.1726126861203;
        Thu, 12 Sep 2024 00:41:01 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:41:00 -0700 (PDT)
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
Subject: [PATCH v2 36/48] ui: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:09 -0700
Message-Id: <20240912073921.453203-37-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 ui/qemu-pixman.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ui/qemu-pixman.c b/ui/qemu-pixman.c
index 5ca55dd1998..6cada8b45e1 100644
--- a/ui/qemu-pixman.c
+++ b/ui/qemu-pixman.c
@@ -49,7 +49,6 @@ PixelFormat qemu_pixelformat_from_pixman(pixman_format_code_t format)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 
     pf.amax = (1 << pf.abits) - 1;
-- 
2.39.2


