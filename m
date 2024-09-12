Return-Path: <kvm+bounces-26657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E18397631E
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53A86B20529
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4588C1A01C3;
	Thu, 12 Sep 2024 07:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DuQp1Hki"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209261A00C5
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126876; cv=none; b=lJ67hQI+sX9JJZgcpM5A8CTAhuhH4cx+wzf/JfQy+MVi6BvB2KEZYrHbjcLHzHeQwce50wFSggOlP/gu0X4xm1RI67HEGy8kuAp1M+59ONy+B8WhcCnFGrX6DYszL7MUej4PB+hrEy0vBOrPU4j4dmOq2NSEj0pNCa7H9nQtc/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126876; c=relaxed/simple;
	bh=a3+097keVJCBLEwyt/Rda1DG1GjC6WhYPgywdLMfrWI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rmVFRBC9u86FYmRE9k1nGeCn8ZabzDIQ7wKAw4ucC+XRWWJEs7aUSzLdTSvQJdjKNIa+HGhPJQgdw2FLjmEVHxAYPrNrmx+0VcRZuLLnh4olRKmFLFSyJ7ajh61jnR27rG0kcIjE8hIiUtK1JrEfYBgBcSe1Qsb3/TgzTlIX9iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DuQp1Hki; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-6bce380eb96so444881a12.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126874; x=1726731674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vXYJ3kbU9hsr2ebFSyiWuonl8XOv822rbyHItwqNMM=;
        b=DuQp1HkicqpizgDgQsbNJasTTbs8gTw9ElOvo8nLMTJz8uOBNLVapBwHrXByvwWRBI
         t7fzgTKEJmySVEddpQ0NxTvEyd9cPqqLDPVJ+VVec/7pCWvN6FahSfL87a6Alb3XDa41
         Roc+CWynx2jmV6WF0pz/2OqDY1jVt2UsvByq8FDjjwerYKMYipSNrZqFTHvCGuhDemom
         FmwM2sfn5tieV0yg9VkPEt/GoRkamqkSlCYKPlUxz5k2TMkcPCGYVLSBNbrD9Kzq+2hL
         YSAzwFitZ9YiV/jw74xpnbvlZvwtwloGFgZ8+Rru/bSfKhP3flZKBM8vW3s6MZ6uJuLE
         Ockg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126874; x=1726731674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4vXYJ3kbU9hsr2ebFSyiWuonl8XOv822rbyHItwqNMM=;
        b=RoKZwnEZ0O2sRs/ty7Y2TcxeyWjZVcFePrFOfWVFUFF8i0Fp+uUIx4/JVM2Zr6APFd
         9O8xI2q+AxF8dCmxqEOFDyB8TSqm44Pa57JvKQOAQrCFdKwMiVLoTuDE/x7keynHAfy+
         xTXA258/mOnRvvfmuxf9SenuaEDetXo1Q7O9jYrLRbKceMbKNxc1mnKVxlGc84g5dblc
         7+JReOBcbIcIZCnp9rSs5yKi4YhoRDpmVKHXJc600bps6EB4Rw8AQcXXXsuX1DnOlo9F
         4Q00O1e6OwHeSTkQ6YvhTNJZpFvix3ZSOott2dixIw11lak0S9j4V01TaFWflgXUxTXe
         lrGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSaJP2AJGlSyejhcw9FqHTB2zUHfrdzVogcBQKACkaYOeSEX+JWNJtLPgYTNJfNbgpTeg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiAAcMw1hIE6L++aORY+wqUvm8s8MEdIvCPmgyl6QHfc/zOVCr
	Imx+HP5hY1at+r/5GsGBRkfaJQRoLzVbVXhvNmAOA6cP5AncgZcdOiC2Xh8FG0g=
X-Google-Smtp-Source: AGHT+IGfovdnAqYWOwtqmXfs1YlWNLytry27KoN7DkkE+JMDdDN0epVDte/LII/bTeQGg3HedxA6ow==
X-Received: by 2002:a05:6a20:e30b:b0:1cf:6d67:c078 with SMTP id adf61e73a8af0-1cf76237989mr2787587637.42.1726126874107;
        Thu, 12 Sep 2024 00:41:14 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:41:13 -0700 (PDT)
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
Subject: [PATCH v2 41/48] hw/net: remove return after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:14 -0700
Message-Id: <20240912073921.453203-42-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/net/e1000e_core.c | 2 --
 hw/net/igb_core.c    | 2 --
 hw/net/vmxnet3.c     | 1 -
 3 files changed, 5 deletions(-)

diff --git a/hw/net/e1000e_core.c b/hw/net/e1000e_core.c
index 248381f9766..2e4c50ddbaf 100644
--- a/hw/net/e1000e_core.c
+++ b/hw/net/e1000e_core.c
@@ -562,7 +562,6 @@ e1000e_rss_calc_hash(E1000ECore *core,
         break;
     default:
         g_assert_not_reached();
-        return 0;
     }
 
     return net_rx_pkt_calc_rss_hash(pkt, type, (uint8_t *) &core->mac[RSSRK]);
@@ -841,7 +840,6 @@ e1000e_ring_free_descr_num(E1000ECore *core, const E1000ERingInfo *r)
     }
 
     g_assert_not_reached();
-    return 0;
 }
 
 static inline bool
diff --git a/hw/net/igb_core.c b/hw/net/igb_core.c
index 6be61407715..5dffa12c64b 100644
--- a/hw/net/igb_core.c
+++ b/hw/net/igb_core.c
@@ -398,7 +398,6 @@ igb_rss_calc_hash(IGBCore *core, struct NetRxPkt *pkt, E1000E_RSSInfo *info)
         break;
     default:
         g_assert_not_reached();
-        return 0;
     }
 
     return net_rx_pkt_calc_rss_hash(pkt, type, (uint8_t *) &core->mac[RSSRK]);
@@ -747,7 +746,6 @@ igb_ring_free_descr_num(IGBCore *core, const E1000ERingInfo *r)
     }
 
     g_assert_not_reached();
-    return 0;
 }
 
 static inline bool
diff --git a/hw/net/vmxnet3.c b/hw/net/vmxnet3.c
index 63a91877730..6b5185c707b 100644
--- a/hw/net/vmxnet3.c
+++ b/hw/net/vmxnet3.c
@@ -456,7 +456,6 @@ vmxnet3_setup_tx_offloads(VMXNET3State *s)
 
     default:
         g_assert_not_reached();
-        return false;
     }
 
     return true;
-- 
2.39.2


