Return-Path: <kvm+bounces-26366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C0597459B
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:18:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35BB51C2521A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D1C1AED41;
	Tue, 10 Sep 2024 22:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MTxY9RLV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC331ABEA5
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006611; cv=none; b=M7+2v40zBlJxf9qElz/D44ppMRmymd0C51+Odm5j7moSb5piO7q3XRRtUrSbMA1obnQ90unor4c7oT16bnIzvmgDEh1VavK0FzZ1K1M07C8iOk9ziX+Noh2X9vs6FVTW8g94dHQ+0HXMfROa51wCDXxVVrbmHnu2FoJ3zS1Z4FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006611; c=relaxed/simple;
	bh=un8fAKZDF05rRHJyUVrncbirtSi7CKHRrjczF7x2BcE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sI8D1EaBJpWbn7V1AksZSOM2xdl0QQAqM80EuTJog9PhUSofpAuT4Kgz8YiUpaCh0hNCtqNuADTqWNiS9Twdi9asY4Vu1ImAl8BH8Cdq5DMKKpf4cAMWfha7+E/rV9zGqrAsJIbLxPgv90UqGF2rkYBKHMLxzF2MVDE5JXoutz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MTxY9RLV; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-717849c0dcaso5608628b3a.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006609; x=1726611409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wo4Kwhe0+9wossg0r5F+dnO1+KIF5dbmiqLxu6TdKHE=;
        b=MTxY9RLVpV7u8e7bRJHhSnb7u0zoDSJLcdMOIZXA1Dgtv4Ev9oIyQpyuSNCoIcekkh
         P/QPcYHkx6Yt3nxCHJOPAzqqacSQmc9dl3TVtiWD2/sxAbblqcFkfhUOS2qFfyTUs7OO
         GqGi6pDOnhBwJj1i3SpRE+sGJVFDj+TF3GdzxOEI8S52ApgLRBwlPj8nOaJWNcIlki5H
         Ju6V8hc5HTmwbyNfGwBVmiW7vlo+jcIFcwaTHVsClp9tZzreAn4MYExyc/gtXcMp4ZLB
         t24xXAYG8BkMFk5q4q0v9j9NLb19tdmPznQ6bfANfyus47gPMdeYsaYWr0OzlwDrCqqL
         X9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006609; x=1726611409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wo4Kwhe0+9wossg0r5F+dnO1+KIF5dbmiqLxu6TdKHE=;
        b=T3Tbep0sC288kh9CpHTivvdqsjrD9BYn7MdzLL77+Vf8J1y2RkUBtQZebSPMnuO8n8
         BDX4hAXMOzRn4QzMits7uQaL8tZCbquR3hSOvhLJjBibCW2IXCMWYS/9IKqc6TrZhTp2
         /gLLz0Jb7tceI9mfwjt5TG1WqbevwmN+OBEkqr6FgciMcv5SLsgt1tsP7/TNx9CGda9w
         DWpnbbj2Oti2cb6zgqcxv1FoA4Umk5okpdv/u6IQJtYjBUZ0A20PZNqasEzJ6spSPBn4
         ZUd5q1IPI8JmFcbCDGrnM+0a8sAVUp1YlfYEY9OT4Mrv9idyhuyFHUv3trSS02XJ3cE+
         u1jw==
X-Forwarded-Encrypted: i=1; AJvYcCVN5TygtRYGThaJ1dGWsFFrW1lL9CYDYDRVwMOkFHABh/nkdQtizVSE2QrdRysfbbh06LY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrldzXq/YNcTJmPVgker/ffCC9fMTTO30rUk5nxyOFl0nZsAnA
	Wpanf/xpYIZUxLvU09QtdeewMwaYn8SBkDsPnRlXcTDVDJvc3QmkpZSbA4lQYME=
X-Google-Smtp-Source: AGHT+IFtMirXMv4Fe5jm8EjT5naiSbZE3xCYCvlUGLPtdk4/tytoT9EI8pJfvAZvF8ck1TGbfKyzfw==
X-Received: by 2002:a05:6a20:ac43:b0:1cf:374f:40c9 with SMTP id adf61e73a8af0-1cf5e1b7fe7mr3167936637.38.1726006609032;
        Tue, 10 Sep 2024 15:16:49 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:48 -0700 (PDT)
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
Subject: [PATCH 16/39] hw/hyperv: replace assert(false) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:43 -0700
Message-Id: <20240910221606.1817478-17-pierrick.bouvier@linaro.org>
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
 hw/hyperv/hyperv_testdev.c |  6 +++---
 hw/hyperv/vmbus.c          | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/hw/hyperv/hyperv_testdev.c b/hw/hyperv/hyperv_testdev.c
index 9a56ddf83fe..ef50e490c4e 100644
--- a/hw/hyperv/hyperv_testdev.c
+++ b/hw/hyperv/hyperv_testdev.c
@@ -88,7 +88,7 @@ static TestSintRoute *sint_route_find(HypervTestDev *dev,
             return sint_route;
         }
     }
-    assert(false);
+    g_assert_not_reached();
     return NULL;
 }
 
@@ -187,7 +187,7 @@ static void msg_conn_destroy(HypervTestDev *dev, uint8_t conn_id)
             return;
         }
     }
-    assert(false);
+    g_assert_not_reached();
 }
 
 static void evt_conn_handler(EventNotifier *notifier)
@@ -237,7 +237,7 @@ static void evt_conn_destroy(HypervTestDev *dev, uint8_t conn_id)
             return;
         }
     }
-    assert(false);
+    g_assert_not_reached();
 }
 
 static uint64_t hv_test_dev_read(void *opaque, hwaddr addr, unsigned size)
diff --git a/hw/hyperv/vmbus.c b/hw/hyperv/vmbus.c
index 490d805d298..df47aae72b8 100644
--- a/hw/hyperv/vmbus.c
+++ b/hw/hyperv/vmbus.c
@@ -1874,7 +1874,7 @@ static void send_create_gpadl(VMBus *vmbus)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static bool complete_create_gpadl(VMBus *vmbus)
@@ -1889,7 +1889,7 @@ static bool complete_create_gpadl(VMBus *vmbus)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
     return false;
 }
 
@@ -1931,7 +1931,7 @@ static void send_teardown_gpadl(VMBus *vmbus)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static bool complete_teardown_gpadl(VMBus *vmbus)
@@ -1946,7 +1946,7 @@ static bool complete_teardown_gpadl(VMBus *vmbus)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
     return false;
 }
 
@@ -1996,7 +1996,7 @@ static void send_open_channel(VMBus *vmbus)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static bool complete_open_channel(VMBus *vmbus)
@@ -2020,7 +2020,7 @@ static bool complete_open_channel(VMBus *vmbus)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
     return false;
 }
 
-- 
2.39.2


