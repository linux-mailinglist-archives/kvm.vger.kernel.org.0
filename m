Return-Path: <kvm+bounces-26378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A68D9745B1
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0C26B251E9
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2958F1AC421;
	Tue, 10 Sep 2024 22:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GHz4oD/8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F363D1917E3
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006667; cv=none; b=Q9PK+nF5+hE5pNAQ9pUFMwj/L5jkSa9pgIoeWiXojHwSnVb64xZJoXorJAta42OYhoLbU7AQXb+03qbcKccW2Y5Fttmp4PavA9iRoMXYNTM3QJY3KxOBACV+8nZ4CDHi7jxAWaCJWpwI95mDJel662RdXoDAW5fTs4tLDWq9gJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006667; c=relaxed/simple;
	bh=9ufsd+S11Tc2FI4hR7rhGyjey3VIlBi+6WPSoRGNd7o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qF1iaLVPyvSVRQTwtMHKctTUMQGZIYlk+Nu2YhZX8ihDM1vipU9bT0WlRNSIyw6NUHjOOssqsOl+/FQFYVLWUCC3/yF9L7wiq+ARlZI9IpBwB5j6bnXhPd8sn91vukoITk2QM5VOIH+RpakLUxVWyTHJ+FS8OVI0nJj46fts+PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GHz4oD/8; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7184a7c8a45so3839486b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006665; x=1726611465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUh9IHgCF2MhxdXEfEudgW9+CnpXzCptLVYaeGylPlo=;
        b=GHz4oD/8z2rGRBtZS907dM7+AUejVsUyaV8ntJgLVYz1Ify3/RSo7aE2QQp741qL10
         WVx8LBi92GbT9ORePGQPt3WCFdIWg56esKZwk1hoXKTkES/QBH3bm3Ny6sK9Wmze1PvE
         RtOWS6umRKfFSPvaMwnmjbJBVZU6Dsub4eGwbgoA/mlGjpujmeLpPuxjHc3v39NjtXBm
         hClT8ElTU4W6ZSmVCq0T4vPJv9PtuY+h/eej2liIyhrRGn48XoYxBQumBjXy767ycbcZ
         Q59ApUIAEmKrdOiaeA4kCLQtEKkcb63ncUJ5MXAPul5cDoZ+JFdZPP0zbVD5dxIiISfx
         8rPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006665; x=1726611465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qUh9IHgCF2MhxdXEfEudgW9+CnpXzCptLVYaeGylPlo=;
        b=fd/G7Enb/5agrnnqbfitItyK349yEIc2GntVyfFGOx3S8d8XdDlZYiq0UGzyOooFbv
         0u6wleo0zqegScqWY5k0cM0M9d0dsYfT75FZ4uorXRziBkEp9Y2BK+33xNmpNKuFKZoi
         MoqZl1olIMUX6YxC54hJEQVSk0WhJSlB4G3fts33pvoeiOUIF+bKbwuw8qT1wU9i/DtV
         uip2VieIez3Txv6tywcOIDYxxWrPSMcJSbD3QF+C1CpLzzFb9RgjwwDQw72hUTbVgKl9
         WeKYFCjR9cJkVXONJlYs5UgFns+u8X6pbBdWetYwZl8KNG0EisU5XB7eWlvNPhynD+HZ
         rTpw==
X-Forwarded-Encrypted: i=1; AJvYcCXrmWqdq3xTlVx9UPfZOfrIy4r237gOBsqFj0vUeZ+WtA/K7/swpvy/TJu2uLJrrBF1jS0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv6/WzI2rtKrJFhmsiD27kE6steJ0/R2DGuV4QNir/qOUvPnEG
	fp029Os1mldVQ7G5eo7ynSdj3iOCdt7DpTnBu6Xboq1SZaeusNnF9a7iXwbtwyE=
X-Google-Smtp-Source: AGHT+IHslc3BcEPx9Pl9BNLcC3dBYXVlOSUQA7s5AOxlWq5X7KhrvJDzlRgFX2++lb84PnsqfiJvyA==
X-Received: by 2002:a05:6a00:17a9:b0:70d:2e7e:1853 with SMTP id d2e1a72fcca58-718d5ef956cmr27062604b3a.19.1726006665231;
        Tue, 10 Sep 2024 15:17:45 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:44 -0700 (PDT)
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
Subject: [PATCH 28/39] hw/misc: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:55 -0700
Message-Id: <20240910221606.1817478-29-pierrick.bouvier@linaro.org>
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


