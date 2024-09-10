Return-Path: <kvm+bounces-26367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3804397459C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8E031F2741A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540BC1AF4D3;
	Tue, 10 Sep 2024 22:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Uhycxb37"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BAE1AED43
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006613; cv=none; b=p+zfb1qa5EPBL9EWlMDXR3cmS16ryVZEWHfqeAudABhmw7b3t0OKjGTSn/z8qmsGk/T6GG2z78z9T4EDetXDeW8SEFY+LgB3IU7yLrTRdL3buBSplOoOhQupfSho+hKkxPOJp51SgoMZ+0gQc4lkyZ0V80dOdnAosHdhB8bXta4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006613; c=relaxed/simple;
	bh=csBwLVLP2WeK1qWgpBtuKra8nHbvrPXygBdSa4OM2/g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jdAKo5PNL1y2oiTiCRzC2cTE8E5It5q/eJpHt9J5XAs7O5ey7kosZQc/iItrd1i8qC64BasT/0iRwO7COiI9gmoZ3ZfqAI8a2oees6yP6TYM8eBa4hEM/e9W/sOATSEY0I+TtrNaI9OaZzkTiAmYfzcMbG9pmzG9zLfsMydBrWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Uhycxb37; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-718d91eef2eso193177b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006611; x=1726611411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agjxPNPZhkjhF3pYgx+4YrvSC0QezaRTWh5rzAMbA6c=;
        b=Uhycxb37ZCqg4gUV554yewDyDG/ch3KTiTTILmvpunO7/w2Gh6HfRY6eDsXaic/aO7
         RA/8PFnHlib52fJe4tDm4jtT91CO0Evlcb93am5B9XXYxpr7IBZTF1GdQiMU/z7K325T
         bEfyCLaJpj7/Y1ku6vjvI0V8MwZamo0ctydcqKrnGsXGuxSES6RvNRjOiKcxX0RQFamA
         z6v76wbcJfQLZSrj3K+XzcSBXCRK28WWzEPN9Ts4TPwO+1rSiSiukicNK5wLcW8ZbEao
         9SEOLMXdhtX7K11jp4ix3E+eRLApA7i5Mw4s4dY1HJPcAnHwmeICVif1OzEwbiHtXPmB
         lt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006611; x=1726611411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=agjxPNPZhkjhF3pYgx+4YrvSC0QezaRTWh5rzAMbA6c=;
        b=QbqMZLkqYV2i1As3Y28azhkPQMk3lqotBzWB72yYguo7Df96J7CGbmCH/DgViyArM1
         F+qfJBHIV2CSuKsiZQFQGNddW3Qe9tlyjr45eg0kwGf/b9ow3eDy4CFzmrdCPLVVghT6
         1NWE3187alCMZSTYro9YZ/3CsdEh0MJ9iCLaReIe1MUjJbEsDHWzaK7wCsp3Li4q1FGP
         9QMRA5uYqvfD4CEnRAb/yMu7GrlELzt7CScRluJZVDjnGbjY9otGD5SwnRMRxJ76AbNQ
         b4/XuXlsxleIaCkrD/pbMm7xnFsI/SmoSk7m/S4HsjT0URDqhfTeR2ZEcX8WbwuwxtHx
         MD7w==
X-Forwarded-Encrypted: i=1; AJvYcCXhO4P5iWubJXRYLmh4uirb2QPXwEaNyID7vlq95RyV6Qsxbc6XrHd/gC8AvjCeeXX3gcw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdKVwR0hWZnXoeHwl/pOb9hAWq2l7rULTnnT1/8SlUZJRRtHnT
	IMV063Zv9sixTEjs6WPfsHGulLbJalg8kc/o4WG6D3Py/msvCM6TIrhond5YEn8=
X-Google-Smtp-Source: AGHT+IE1NeVPxPuTLt1hWZFnlbeldnxIM0Z4VwcI8eWqQlrC+NfwnNfuoOxOt9dZvUfA9IM8krjmMw==
X-Received: by 2002:a05:6a00:6f4d:b0:718:eeab:97ca with SMTP id d2e1a72fcca58-71907d98483mr7997533b3a.2.1726006611406;
        Tue, 10 Sep 2024 15:16:51 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:50 -0700 (PDT)
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
Subject: [PATCH 17/39] hw/net: replace assert(false) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:44 -0700
Message-Id: <20240910221606.1817478-18-pierrick.bouvier@linaro.org>
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
 hw/net/e1000e_core.c | 2 +-
 hw/net/igb_core.c    | 2 +-
 hw/net/net_rx_pkt.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/net/e1000e_core.c b/hw/net/e1000e_core.c
index 3ae2a184d5d..248381f9766 100644
--- a/hw/net/e1000e_core.c
+++ b/hw/net/e1000e_core.c
@@ -561,7 +561,7 @@ e1000e_rss_calc_hash(E1000ECore *core,
         type = NetPktRssIpV6Ex;
         break;
     default:
-        assert(false);
+        g_assert_not_reached();
         return 0;
     }
 
diff --git a/hw/net/igb_core.c b/hw/net/igb_core.c
index bcd5f6cd9cd..6be61407715 100644
--- a/hw/net/igb_core.c
+++ b/hw/net/igb_core.c
@@ -397,7 +397,7 @@ igb_rss_calc_hash(IGBCore *core, struct NetRxPkt *pkt, E1000E_RSSInfo *info)
         type = NetPktRssIpV6Udp;
         break;
     default:
-        assert(false);
+        g_assert_not_reached();
         return 0;
     }
 
diff --git a/hw/net/net_rx_pkt.c b/hw/net/net_rx_pkt.c
index 32e5f3f9cf7..6b9c4c9559d 100644
--- a/hw/net/net_rx_pkt.c
+++ b/hw/net/net_rx_pkt.c
@@ -375,7 +375,7 @@ net_rx_pkt_calc_rss_hash(struct NetRxPkt *pkt,
         _net_rx_rss_prepare_udp(&rss_input[0], pkt, &rss_length);
         break;
     default:
-        assert(false);
+        g_assert_not_reached();
         break;
     }
 
-- 
2.39.2


