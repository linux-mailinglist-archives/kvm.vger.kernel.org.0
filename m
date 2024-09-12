Return-Path: <kvm+bounces-26644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 507F197630A
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11E6B280D03
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F4F319F101;
	Thu, 12 Sep 2024 07:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f4DbkHQr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60D2191F64
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126842; cv=none; b=EBEvfEGOmNg12L6Or8F+PGvj8gsWtmyogifuaif4TsYJbQW15XJ4MZoUCk289Djn5DXz/kenP559UbrnsDVROWAgFNtIoXx43mntyDnsp65lBx7LIujvU9UovNNLEqyxNa37/MeNYKgq2FCi+9rAEhD9b2miisnLhIQVThSncvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126842; c=relaxed/simple;
	bh=7aF564MlKMlP+tn7TYfgvThEYzDqQarXuAJQXDIdP3E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QUxMxo77nea4bRcKLlJ1fvn2nR23WmV4wO8OZ4z9+LVRT6CR8wRsbZYo9pu6RdkhTj5aRWmaZ+bKxQr2I5tVONWb63NDBj/vCxVee41RXeeXJMDZ8+nL4g5YqH3e12nTmsuhGK7SgnWXEN5A1IIFosFxUseaq2ojaU+3WZKdYnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f4DbkHQr; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-82cd93a6617so24113639f.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126840; x=1726731640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aWS8WcyTWapQPcbM+bRD40JZ4f8WdoLt0xgMhn2PBmc=;
        b=f4DbkHQrgcumxNibsRDlufLGBWwFD61WGBqA23Ryiu3poE7eYyJzopixlcqjBpSpVn
         9l/1T2CadaVXBmpqeSu+cGWHrBW+Vco8rB0CCCaqtS/4AOX7Y0keKRuUDtknsIkiKeSo
         dNkVvGaUHTq2bU3cJ80XRmo9aQDAsOxsa9qGCn796DqbLSz3vBRaIkpnNk3hpI4u3WP9
         mWKFSEnH/qTY8C0l87KnfKzFG9wfzxWOE0Ddnbh7hXJqGLUsDi1avPH39lSLVGBkNgpD
         vhkcSjZdJOwwnA54mfNYyy3YukmRNeZ/tu9pLRmYvC3l4YkB581b/1q7OBt4TxwNh+5y
         WvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126840; x=1726731640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aWS8WcyTWapQPcbM+bRD40JZ4f8WdoLt0xgMhn2PBmc=;
        b=lFubUkS8pSEA8eg41juOneXiEbDmq8x4tyiHiZ/0A3QadrzYEpYu2Z7fHS8HIaDZGZ
         o/c8sMf6/oA5RvgBxFk97BSvyEw0WDc1WE/QRDTc6du7Oi8Z6pcOTcw5il6KylgJAi7Q
         rTFeZ2iKnMjrbfIQ/8OughzAPrZyzCIAYwzsnR4+SPT8mfKCZibygZf+5NH6HDWUV3sQ
         f9o477bGwjmVMkW9rfA4rSLHAadbBYhEcFq8wp9UIU3aqNcKqhiWAJM+CxD1FT5ftaG4
         ho4w/RHEAfJ3VQcHrzCK3t3bpovOd/iuiChT+K/I3bzwatKs2N0ZLIxbmZECdGEY1XFv
         SQxw==
X-Forwarded-Encrypted: i=1; AJvYcCV9D+74i5WMCTRf0kylh6RPgQM72XAgqcXl2pTLfThOQqYgBD7px1BQBgQ0x3PBhUuE9ZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJoNuf5OYRVzyfEP26zy2VjhBhMV7cXnAGk5oMStQkXBQW1HFk
	zydYRC+6PXI8//o2Xukuu0q6yvjZQ1oG1OfpnvR/OXgwbaBrk6NowGuodEa82oQ=
X-Google-Smtp-Source: AGHT+IFYzQhybkxo/re134Wva/li7Du5eyOeNHQCOj8YeNMIPHFJEF4Fg9V+twS4J8sKDv4Qe7CqZA==
X-Received: by 2002:a05:6e02:1383:b0:39f:5abe:ec25 with SMTP id e9e14a558f8ab-3a08495478amr17127215ab.19.1726126840002;
        Thu, 12 Sep 2024 00:40:40 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:39 -0700 (PDT)
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
Subject: [PATCH v2 28/48] hw/misc: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:01 -0700
Message-Id: <20240912073921.453203-29-pierrick.bouvier@linaro.org>
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
 hw/misc/imx6_ccm.c | 1 -
 hw/misc/mac_via.c  | 2 --
 2 files changed, 3 deletions(-)

diff --git a/hw/misc/imx6_ccm.c b/hw/misc/imx6_ccm.c
index b1def7f05b9..fd5d7ce4828 100644
--- a/hw/misc/imx6_ccm.c
+++ b/hw/misc/imx6_ccm.c
@@ -301,7 +301,6 @@ static uint64_t imx6_analog_get_periph_clk(IMX6CCMState *dev)
     default:
         /* We should never get there */
         g_assert_not_reached();
-        break;
     }
 
     trace_imx6_analog_get_periph_clk(freq);
diff --git a/hw/misc/mac_via.c b/hw/misc/mac_via.c
index 652395b84fc..af2b2b1af3d 100644
--- a/hw/misc/mac_via.c
+++ b/hw/misc/mac_via.c
@@ -495,7 +495,6 @@ static void via1_rtc_update(MOS6522Q800VIA1State *v1s)
                 break;
             default:
                 g_assert_not_reached();
-                break;
             }
             return;
         }
@@ -556,7 +555,6 @@ static void via1_rtc_update(MOS6522Q800VIA1State *v1s)
             break;
         default:
             g_assert_not_reached();
-            break;
         }
         return;
     }
-- 
2.39.2


