Return-Path: <kvm+bounces-26656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F2297631D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:43:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C19B82816EB
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82EE319006A;
	Thu, 12 Sep 2024 07:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wdCk0uyB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6153819F43E
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126873; cv=none; b=sCZxp3oLwzgNhlu2jXz1AOjXU8LsqaVPLtlA9cpZhD3JJNb2cZXv0S7oaIDAOU3bvqcoLvqX+XSrNViViC6C1FkDmeDww1StPWJEtzX2FcYH2M1v9lpGw3r1LR4zrx8cewzRC0ySjzG1a3K0cICSWESLQZItpzwgL+WYuKwSGRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126873; c=relaxed/simple;
	bh=oa5AL/HwdyX7y2/urQTvAYAUXGLIjF8e/GVGt6+JtKI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nd0ZkPq5Ed0O1qAZbGV28kN6Sid5wEI27flPRdO0UObqX4cXKZ5cXX78FxutO0ahPv/lliZxmCma/57dilNLjilK5WrEhKBZ4Vv+B5CRayphQwrxnt6lBtqf6e/T3CxTh6gIvgRsZHp4jFpsI9G23mOyrl7FLJVFzgCTeYdJKEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wdCk0uyB; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-717849c0dcaso595274b3a.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126872; x=1726731672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Q1mMHu0qY1Mg7YdLUybGWIueKQg5CpgXLD+/9rtI1o=;
        b=wdCk0uyBWix1AI/QrarPqQEsTUKsuCfEXQeEphJCQi4ip8XRkbzx85Si6iT4OXyzzb
         tytOa+gZUm6zwW2rAhYWgmyji1Ujo/bKCULg4EZ0fS/ewPq3xMlVfDZHlm4CjhPdWz3F
         o6mqApkkB/oMy/4d102JmTmHpA/QaxH1Rao9lkUrn1coApIdyiBIWHWXFZe25GkS2MT6
         tKg2U++4LjA1Ak8web5rTh7A8oH8ASwLXlNDxb0ufz64wCGIutjt3B42ge+qOdHJE+uK
         qf6LsfzaCHOsRvAReM2Ipe0z7O3ImU9Euu3d1Sncklt8hIJFOFCWEia12hcUR88BzHSA
         aRDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126872; x=1726731672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Q1mMHu0qY1Mg7YdLUybGWIueKQg5CpgXLD+/9rtI1o=;
        b=N0wz0xIIMtcJ/I1kWy6Z+6CkWPl97/ODR/GOov4IvMOm2FYyyTJ/eMfBDtX2OEniCq
         ZliVkz4Woq3bAa7BNvtAruHLLEc28HacxIumj4jAIxCe3ePqjtAGQ6ifVDaAar1Se0M0
         /UhI4fCDUHHs3Frxl1e2mVK4ESxohB9sVqjrcMm41iF1Tks02FAi63dRgLaSqpNmv1eT
         Clycwu8sHdls4kkqB7s6fS2NV+8VDkRD2O9JbeSJYjDW+gbf/L704fdRotrADKA1luMr
         UT6cQZn58xYW4CDVhB/rh/3h7xOHpQYv+z4RfUCzQuCTd47nrYxPU4TnGSR8owL3goJk
         VqWA==
X-Forwarded-Encrypted: i=1; AJvYcCU0Flo00OOE2KnjDSmX+M+WI8xxH1lvvg+7Bdqt13R8502P4qb5LWe/15hKnb77jQBe16Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZyIjmR41DC/gQRQG4xucSCN8s0mndKD4fSnQtQW/HARWil316
	6/eM0dsUb+EmCRsOYYJDPJY8Wxw43oTc5brUQDwVk9hTCYVXJ4QEjGAG5qL0Tg0=
X-Google-Smtp-Source: AGHT+IE7t7Xs2KH5JUIaVOe68OuWPwNTouEEYSj6TZqCiSQvTjYgxD2YaXeBSDQ2jSGG5jMqgQ5hKg==
X-Received: by 2002:a05:6a00:1906:b0:718:532f:5a3 with SMTP id d2e1a72fcca58-7192607ec83mr3028275b3a.7.1726126871623;
        Thu, 12 Sep 2024 00:41:11 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:41:11 -0700 (PDT)
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
Subject: [PATCH v2 40/48] hw/hyperv: remove return after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:13 -0700
Message-Id: <20240912073921.453203-41-pierrick.bouvier@linaro.org>
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
index df47aae72b8..be7d3172c4f 100644
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
2.39.2


