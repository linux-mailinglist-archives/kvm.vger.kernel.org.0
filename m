Return-Path: <kvm+bounces-26373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E31499745A8
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12A6C1C259BF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D17A61AC8A6;
	Tue, 10 Sep 2024 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EuegN64v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEC31B29DD
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006627; cv=none; b=j74XzTNp+K0qlLFn5iduOP9xT4jLZZVRrR4+JnVQ8NWSvsGuPUhLCyaeY8rggh1RAHcAFzmlFkZwoA8dXWf3aBbUoWEJr5U2VoZTiJEfFTKztKfRyUPDKnMypE32Acc3EptN99s6XCoi0jIngqQsBvvHLkanN/AVSV9uarFENco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006627; c=relaxed/simple;
	bh=3b/VWaODMpRWYjHbxk9DixghmJPHnvULK5x5nT1gld4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s4FmSChy0vQH10607CzS/azXA/r3qUk0PNhSyzb9YAYzoC0cndD3BSWnY3Y7mcZZircmV/CyM/0OPnK8IDkqd9jmjtXqz1lYi+VirgqsUgUqIW2+29R3W+n9nvj8IHNGY1Ea70k+OjKGXwhd1FDjOkivja9r9ZNxA++Fn57TUSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EuegN64v; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7184a7c8a45so3839168b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006625; x=1726611425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KD2LlUR5NpZlDvwnn9zLAQK2DmzjwDVkQP9qh6fOE8I=;
        b=EuegN64vjyfV2xXS3eKfFj9QMAwwnxPF0lOU2GGrou8Fq3Q+J2OpiGwRlpWD8MvRLU
         AZUJrU+Jpai1DCpPsnbvGVOln+bkseOD8iHgZ8DBbI/nhMWjQmK/ENv+VCr9jRucn/F1
         n/Vy0ldsWaoen0pysGRdN2ImonbtA0Vlef4EB3o8F6t16Plk5XqjtBOQy/4NvE5F4M7D
         9Mgk9vCPZpN2gg/S4jFkI3xgph1jvHcdqL8J/lV/akR8UkQMf2oZog+WA2EoYkb/6FsS
         LpmMYE/5MeFfT8TMlAUHi7AiE3VTwBg76b/pOwQUcDP0LYN97d9x3vfc1SUKAOMw8TuC
         uTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006625; x=1726611425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KD2LlUR5NpZlDvwnn9zLAQK2DmzjwDVkQP9qh6fOE8I=;
        b=UCzbj94VVSrkekCYfUA0yejq4btHHNFybv5IZxnvcFPo+Xlm6+3/4bdhLJ5fWSvEv6
         C++KCiU2QLuSr9i0xhm6qsPQnTOy4v52p2QO71qqennZh9hiyW0j0YrliXTXZHia1wTS
         zbT4idE8INYo16Up8J1/huRDf1kL4+jvywTjFSiyeVB5E+LyYy/WZRG2uBtPpkRFB3Qa
         8R8NHmST+8X0vMgdz+YMZPSIgZScAHkOuG1dzbTdm0YnDnRIxe2LEqvG0Y/IAB21Opz8
         Y1/iyKpotiphmXLPZ38ObfNFyRwMeiaomXQHFN830ej/iuz/u5ncPgkoymEuH4qtXwab
         dg3w==
X-Forwarded-Encrypted: i=1; AJvYcCUQ2MPpAnrT2XEqSFZes01z39ZCq4Ydv1x1EJobvD7Ho5Wxqrrul97mZxvLDUtIv4yI150=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIYE0ui26DzU6dYs9edUQTM28y6ppJ3lxi0kbK/OIF8if7ekBt
	vscXo5+ejzz5HcOOw3e/X7Oz3B573rASOioFRfrBTN5Jc7FjNpXT5Fr1O55JolA=
X-Google-Smtp-Source: AGHT+IH6UNKS9chWYn2YPKe9g9weGMxCR6dyTwjj+WvGPNZcuS65Wi2QHFhu7k4/MBMW5kKyVoj53g==
X-Received: by 2002:a05:6a00:3e1a:b0:717:87a1:786 with SMTP id d2e1a72fcca58-718d5e17ba9mr20187214b3a.9.1726006624765;
        Tue, 10 Sep 2024 15:17:04 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:04 -0700 (PDT)
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
Subject: [PATCH 23/39] tests/qtest: replace assert(false) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:50 -0700
Message-Id: <20240910221606.1817478-24-pierrick.bouvier@linaro.org>
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
 tests/qtest/numa-test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/qtest/numa-test.c b/tests/qtest/numa-test.c
index ede418963cb..6d92baee860 100644
--- a/tests/qtest/numa-test.c
+++ b/tests/qtest/numa-test.c
@@ -162,7 +162,7 @@ static void pc_numa_cpu(const void *data)
         } else if (socket == 1 && core == 1 && thread == 1) {
             g_assert_cmpint(node, ==, 1);
         } else {
-            g_assert(false);
+            g_assert_not_reached();
         }
         qobject_unref(e);
     }
@@ -207,7 +207,7 @@ static void spapr_numa_cpu(const void *data)
         } else if (core == 3) {
             g_assert_cmpint(node, ==, 1);
         } else {
-            g_assert(false);
+            g_assert_not_reached();
         }
         qobject_unref(e);
     }
@@ -257,7 +257,7 @@ static void aarch64_numa_cpu(const void *data)
         } else if (socket == 1 && cluster == 0 && core == 0 && thread == 0) {
             g_assert_cmpint(node, ==, 0);
         } else {
-            g_assert(false);
+            g_assert_not_reached();
         }
         qobject_unref(e);
     }
@@ -305,7 +305,7 @@ static void loongarch64_numa_cpu(const void *data)
         } else if (socket == 1 && core == 0 && thread == 0) {
             g_assert_cmpint(node, ==, 0);
         } else {
-            g_assert(false);
+            g_assert_not_reached();
         }
         qobject_unref(e);
     }
@@ -367,7 +367,7 @@ static void pc_dynamic_cpu_cfg(const void *data)
         } else if (socket == 1) {
             g_assert_cmpint(node, ==, 0);
         } else {
-            g_assert(false);
+            g_assert_not_reached();
         }
         qobject_unref(e);
     }
-- 
2.39.2


