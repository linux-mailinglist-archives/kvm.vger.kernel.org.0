Return-Path: <kvm+bounces-26632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61F349762F7
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:41:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 862AB1C22D76
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F07619307E;
	Thu, 12 Sep 2024 07:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XUV/PJXh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5E919047D
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126811; cv=none; b=lR4aa/4JEWXtg86XElw089o4FEwQPbPZULcE8uJb+sXgU50JMfiZq1zN+3sgl10yTqXy4pbMYYVs05Yt3s63qea9Fal5N5kTXdr8ACF67QuxbmDmCJ90IOjIrpMD4KmOLStQ5vzIZKes/aI6jO8sBtJCstdT9GaCQK7O43+SK7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126811; c=relaxed/simple;
	bh=dgWzymuqhmUePNSYVALxLYItS2EOTNvUEBajuEvTDVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BvufgDpLxxPFc4O7VOqIHbrJOEIA+Vf9SZZVzeUJyZk1zS5S80S9lQxdQ1jI7zTbdmCg2KntWBXRRj65eZqJs8N0eEnlPqh9Xlv2QlCwRizsxmUuccx5J+3iuG/kqEF+7PaiVBaaQHCpZaR9lYoC6Ta8QigpdkVBllUeM4wky4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XUV/PJXh; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71911585911so521673b3a.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126808; x=1726731608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P59BoCfpfnoUAXReWsDYStuySlGSOxKrMipSHR5f/PE=;
        b=XUV/PJXhpCGKKQDQzynH0u9G0UlX4MmyXs/gP+X1tIQgnxHS490UlYli5wkjgiGKDZ
         Z/ZUuBzLg9Z53b8nrOLhYBiccEGkFF5EFSheuD7Td2haKwkVlMGGKJXQU7rSdbOQZUSk
         qtz+oFtVXPvuiwZRI5+SPCnNmS5MZVUorMtLUYNWcwgayj+Gkky7gQpkL3XMijebi/V4
         vluv3GxekiKU1NqzHoDjhKIWnH1xEWqBnXDaQ0PYcx3zhuIdkI4pDENCWDNaC8HFK0gQ
         WpxJY3hiecyMtBPdiXx8igPjRyVBP9drJO1Tt+1BsMaC1f71HLSnz7FlB3mYHGf3KlHC
         bi6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126808; x=1726731608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P59BoCfpfnoUAXReWsDYStuySlGSOxKrMipSHR5f/PE=;
        b=okFR3gN4VuSrSaieQbO8TX8GgsavAC7V6KsAcK6tWy4wnGkMjlcqJMNL1jrkIhsQet
         s+FPXeFn3xNcPTzceX06gKTpGB6M5P7+M+b+82kS1v7phhIs5Md+zQ4MRtSXlb0lkrtK
         n33eeejmE8JSyCnyamdRdGj6L7vxc0BNrJqZslfEWLm7vyqivjLY1xsFM4FzjJBw7xbS
         ngpjv+psvGPpX/9CF1jO+JtuL2qLgJlgewdMhuv31XhLSS03VfA7uF9Zn4HyLdLtcW3o
         2bFx4AyVAyNCgcyJqMXA8Kq5ZynaXnDGOUZ3uRcwZskbTR8iAOnDVbpJyIReLQ9voz/h
         xfGg==
X-Forwarded-Encrypted: i=1; AJvYcCUIDFgKxX1Ox+trrpnNzBHR3/K6AzhnxsZtomgrcVKUh8dPf5uZzxmSMLR8XQ42Ro/bDXs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzXDTVsCNuMgB6499vFE1Vat2amUkSrYrsN9UbRYF0Nrbc9JXb
	WTZB8nmOhaXnWpJvT457a10Z9afAiCfebGBTL58Sq3jQyw9cj+6huXiCDh4xYo4=
X-Google-Smtp-Source: AGHT+IHWrcePIqQHDHOWlFI4nJcx4ZMXRIsFR9KI7njLnd//xW7SZTBR6BsOUNPJAp3rZN3BYPs/RQ==
X-Received: by 2002:a05:6a21:114d:b0:1c6:ae03:6607 with SMTP id adf61e73a8af0-1cf75ea27bcmr3064643637.6.1726126807996;
        Thu, 12 Sep 2024 00:40:07 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:07 -0700 (PDT)
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
Subject: [PATCH v2 16/48] hw/hyperv: replace assert(false) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:49 -0700
Message-Id: <20240912073921.453203-17-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
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


