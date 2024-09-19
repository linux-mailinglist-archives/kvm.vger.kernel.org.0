Return-Path: <kvm+bounces-27147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D3597C397
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:50:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEE381F23691
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A811022EEF;
	Thu, 19 Sep 2024 04:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yPqQ6pnR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8113B74424
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721259; cv=none; b=R7SHMom+rNzKYzRBG/F9Q3xWSjIjh/ud49CQk8bVcF58bE0UhXqxS+ZM2mSVxz3zNHaHuEPJMVhns0oOhh8M/fEC6tw8SM1zPi9q60YkOpRgBXoldjjc1+Rgf6kJGvBKfbo5A6319+cLT1iPqBhU85ljmkWiBq4xWyF0qc1jfdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721259; c=relaxed/simple;
	bh=Tro7KQvkuedU8Bfjd301PIUE1oOHUdBXyh7zt6awA54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pBH3HVgdb2TStjPvkMe2XwDDgwA1YEOVsljQhlTY4uWXEPPcfKBzBIIaMa2jdpCDnd4uz6Hu+lfwKq3+r90R9QS4justQ6JF2S9UR8TLlps+TGtiz5E6ONQUdtSCfInskmbEkx7rajxa1JVavsu2NDmHjp3Sy49ETw/HWgkCLec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yPqQ6pnR; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-71798661a52so341973b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721258; x=1727326058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJDiyfguep+d+77wBjyKgjr0G7lr/7MmmWqca8wnD0Q=;
        b=yPqQ6pnR6ktMGCu6EdmtK6lCXCOyoObjHr+7wOLE+YxREwMnJJZow+vmcHN22EFq+s
         2ffXiCqfOIM0MZgApcJ/Wok+QjA4HKKNzZTGfUdJ8x5WL6vVSP2MKsqEX3IpgYVQbVxP
         vmDAiw9esMbFL2EHFBcgg9qMqbVSzsIUhNDk4+s5UpOG9hqk61SHvDJWQl4MQxrtAg4N
         o7ZB88xlXOw4ix3kJL39MXI4adoqwWkUseUDVkh4XkMqPrmG6PXtHh2RJSEUxP7G9tm2
         5DowSRE7xQ2cYPcqCL2Fqr3+SWGNlfGRWPJ6c36mnihMNeQlXwZMAB9BG++TgQumk81A
         sLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721258; x=1727326058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJDiyfguep+d+77wBjyKgjr0G7lr/7MmmWqca8wnD0Q=;
        b=HA/zybtw7ozqr1luXbo4wSAMALEmGDTToRvChpArFwvKFPQ+1JjdBFppWpKla2/6tP
         eDpwT6Dn36Jikko3n1Jfc3WVvQB0yqnyMQ0pa9tMEms9NulXkWoTaVNUo7xN/hWyJmXx
         ItWi48alcBFr5xAgeYgNLP55/NDKRSWc8NHpwQW6u51/QTheozZGDySR9IB5ARxEo4If
         TZJ0dgTQ7UTn9+Bs0yccIMvhG07WzylxQ3VKRvGO41UZFjIdb47v9UzGBSIUGYUi6k/B
         ZPwC5UeOYlRxNghP0lj/tXKsDRQVGtiDSEcmHOV6ObZHzt4YvwNwFdl4ulABGWjpCoL4
         VfSw==
X-Forwarded-Encrypted: i=1; AJvYcCUDMbXTvHCTx0Q8iY+rkNH9fyfzNi6LzNa/Yx8cke940RcVYhwrP7kK1J4jfNXVQgNAkF8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm+36PmcurzAhAWYIQHZvQIhYf3+v1h+C4cUQvn6NSBjMxWoba
	9mbtuEcSktfN/h3hs5nSK27A3BucEIlaWNCy+5UITA6LM1Vdkf1U6yDEaHdWpJs=
X-Google-Smtp-Source: AGHT+IHnfsGB0bg29RNFw85uJlnmT1vGFn1h2prLiEcUTMhAcq9d1LGEwFC0+nQGjVzZjK+KJFVYQA==
X-Received: by 2002:a05:6a00:4fc9:b0:717:8b4e:a17f with SMTP id d2e1a72fcca58-7198e2862cfmr2976167b3a.4.1726721257757;
        Wed, 18 Sep 2024 21:47:37 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:37 -0700 (PDT)
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
Subject: [PATCH v3 26/34] hw/hyperv: remove return after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:33 -0700
Message-Id: <20240919044641.386068-27-pierrick.bouvier@linaro.org>
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
 hw/hyperv/hyperv_testdev.c | 1 -
 hw/hyperv/vmbus.c          | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/hw/hyperv/hyperv_testdev.c b/hw/hyperv/hyperv_testdev.c
index ef50e490c4e..a630ca70476 100644
--- a/hw/hyperv/hyperv_testdev.c
+++ b/hw/hyperv/hyperv_testdev.c
@@ -89,7 +89,6 @@ static TestSintRoute *sint_route_find(HypervTestDev *dev,
         }
     }
     g_assert_not_reached();
-    return NULL;
 }
 
 static void sint_route_destroy(HypervTestDev *dev,
diff --git a/hw/hyperv/vmbus.c b/hw/hyperv/vmbus.c
index 03f415bf226..b36bd3d67d5 100644
--- a/hw/hyperv/vmbus.c
+++ b/hw/hyperv/vmbus.c
@@ -1890,7 +1890,6 @@ static bool complete_create_gpadl(VMBus *vmbus)
     }
 
     g_assert_not_reached();
-    return false;
 }
 
 static void handle_gpadl_teardown(VMBus *vmbus,
@@ -1947,7 +1946,6 @@ static bool complete_teardown_gpadl(VMBus *vmbus)
     }
 
     g_assert_not_reached();
-    return false;
 }
 
 static void handle_open_channel(VMBus *vmbus, vmbus_message_open_channel *msg,
@@ -2021,7 +2019,6 @@ static bool complete_open_channel(VMBus *vmbus)
     }
 
     g_assert_not_reached();
-    return false;
 }
 
 static void vdev_reset_on_close(VMBusDevice *vdev)
-- 
2.39.5


