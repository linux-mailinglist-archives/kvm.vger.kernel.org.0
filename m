Return-Path: <kvm+bounces-27130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5EB897C376
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAE2A1C224C0
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC4029429;
	Thu, 19 Sep 2024 04:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BkrLpYjy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B22A23775
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721226; cv=none; b=tqBPoAXTjVlP9umJTmyvrYbpFuqCpV9xS9tQ+J1Edmcu1PVMMyKrR/0Ej9OEqeJ3jnvfr3D9Aw5roEeNIK2+cD/SKjihhB4jqyjRO5ALDVoO9hhkrF6jx6cKq+zvC75TmDdbNupRQC5ge6TfMv4FChQ+itd+eMs1+GGufkiSsDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721226; c=relaxed/simple;
	bh=13RnyaHBVHON0a43aIFGGWd9STQ67b+kyR330rcN8D8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JpLtHj3smd2XxNpd+HATSyZ6D2ClgenLxmUEUZQUlilTBhS2lyx0ojpI+R8UUU8i6q9Rcwu0gmle2PueRSlOOh1ErOQxRSMdT5if29DmpMD6vObBrkxTvOWQbNBbXNIQkHVgx/dv0uI1JQh6ktCgATGijB7Cb6hYsmux8HfIzrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BkrLpYjy; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7d4f85766f0so296100a12.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721224; x=1727326024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HfkyjDHktRIdC53aV7jz+MEYNAmpLLxTbQ4xm76fWo0=;
        b=BkrLpYjyC/MgpDmqHMkeJlCjPLP053/rgXSLacXLRNMoRW+CEYqkFfRUZg6XwNtEqB
         NAxHl+iB6HmLjCKLGJtH5jua/EdkXR9hOfQTDbrkMv7fce6UvkFCVDoeClacvGp5gBKY
         TsEQWLrZ3VBBl0QrfH8+rReijF1TZqnMGwIUjxNkd/0OQJBvxl9is+eX4fvIv2kthnpL
         DZDj0qvCa7zhraQ3hizX/5VzzGJUXrGqegmCuOKBqWCVnooiwtWnxZ95rUHcZ4+q/EjH
         Jixlw/SNFYThoq4RjbT7V+J0vi7b41rchRRBE4GheJz7DcZW2iqT+BJGnb/b2l+0mFUU
         ZPgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721224; x=1727326024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HfkyjDHktRIdC53aV7jz+MEYNAmpLLxTbQ4xm76fWo0=;
        b=vSRKh9eq29nf1kPgSPDVP71slyQ+e9+qBW0CLPnk50wshUNasfPyrbt/jxai2T+8W+
         b1tWye0d67Hz0yNEjQoXhTR+Ql0OVlxRmvDviCaymZtKnbw9KvPs58DwjBfRuaR7HSS1
         fz1zJHkc6xEAgv0gguz3eTB6d5GOnQbEPF37aGTx6h9dmRgTuRGBRDZkZuKJcF3a9alZ
         C7tbcB63lUN3890ubouNJ4O991w5QGbX08X3A3ae6RltJyzRCLc4PIc5NtuoUahCYs8M
         dRv9/HU4wvJhlxOCEXvMUSLUaVd7KWp3CxZ8Za95DzbYMh+ZoJkGxI6ZrZZ+3EHkBdfI
         KL6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUfaw/tEUXO4t2dvhuhXfxONh9tA7clHKInC6Y3S55FwUZUsRp8Iih4utAaIGg9LUO1Kxw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0+xYEWkyzBfpSAcyCwkKOCZZLDQ+Tw7KuX3nc0TTGL+JofIbk
	gIE4jbI9sUSwKiCS0hyPf3gmHmf8I/g3qn7lAPeUJtApbfwCKwPNrSLtz0UDaek=
X-Google-Smtp-Source: AGHT+IFbn4h/5fpDdM1su4Z9mSEZxrAAcU1BwZZyKC3gnrGjV7NEGzkE2iqfTaMdogn2HPgRWiWmww==
X-Received: by 2002:a05:6a21:3a44:b0:1cf:2ab6:a348 with SMTP id adf61e73a8af0-1cf75ea1dc8mr38949451637.1.1726721224333;
        Wed, 18 Sep 2024 21:47:04 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:03 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Bin Meng <bmeng.cn@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Corey Minyard <minyard@acm.org>,
	Laurent Vivier <laurent@vivier.eu>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Huth <thuth@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Fam Zheng <fam@euphon.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Keith Busch <kbusch@kernel.org>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	qemu-riscv@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-arm@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-block@nongnu.org,
	Joel Stanley <joel@jms.id.au>,
	Weiwei Li <liwei1518@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Yanan Wang <wangyanan55@huawei.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Jesper Devantier <foss@defmacro.it>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 09/34] hw/net: replace assert(false) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:16 -0700
Message-Id: <20240919044641.386068-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
References: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
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
2.39.5


