Return-Path: <kvm+bounces-26639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D71976304
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:42:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E604FB23ECC
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1491917EF;
	Thu, 12 Sep 2024 07:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OYT1SbNU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3599719CC27
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126829; cv=none; b=S2UWXun4VvLw/0ycp3qEE3OWw/ayjlDpZ9llhXlkLIfq5Yufnno/tA7GSFAK9lJipRHUzUn+NfPQWhv6abCHun66vjimDW3P1tax12j1RyHqkJg5YdI84afXUwsiTK2y/Fq2io4IW+IEkvwwQ33ttD/hU8511jT/USuEqFr9YFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126829; c=relaxed/simple;
	bh=yWaiHO1T3K5f5K/f20tS6mWPHLpYj2UGrmuZsyu5VZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cbqNWzZHb0XJLkWSLyWDSNqVRBmi8QURECerXiSR8VXwy9CBA4GHlSogH8d+MfcMLTayO3rA5byBcqo+L9eNmGgXYGOJSKXknev0ZfQF84d1q12WcnQ+Iere+Vic3XAOSTDhfgA2Vf62GyUmVcpaFeiO+cZAkVdSq0ysEqfFGaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OYT1SbNU; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-37636c3872bso2430285ab.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126827; x=1726731627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAgxsGkzSX6UIjZ+akO+9hnbz8NplQ6SsHLnjF/2omU=;
        b=OYT1SbNUNtwGygmmdkUj+Pgy76fjF7gvamC9VNX1ufiefNtDlmzzyLfMn/YF03IDEp
         Td1ngKJSbR6wtgZz3GjXz5GY+wZD74D9eF+mdhfmeIaNdbi74zXiiSEfCOMEBJN5iFdJ
         5tNjb8La3HkH1GjB+sxkWYuI1GGz6FkiWzDthXw2sD8SGsWnuyysqZWK8sHmS+DviNqW
         8/2GFKZzfcKCSHttxShSMQxai5umE6smse/igDOq+7J559k3P3IjtH8pQUS1P/XRD2V6
         OH1Y8nZwZVjtYeNmTweXVhnVr8PcoOM4fOoUxipbb+72WjKD3HdARaODpXGnoxJBfI29
         //pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126827; x=1726731627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lAgxsGkzSX6UIjZ+akO+9hnbz8NplQ6SsHLnjF/2omU=;
        b=wQKda6YergitwwrwtvrAryNT0OhitXWANRiAKauWwTdvOau1OPT5V2CNybuSXDfzv6
         FtT0OcdeiERerI6NlzvNuAWgcZrEPOWhF8o5LvuSTb/QB7gytnmiuDFjSR0V5BIorncv
         eJsKOoez3mByJ+4bdtOJ1fC/5I5ICuer05wqpBB80FhPn8qSJUmwccDhsqs2r2qOu2ds
         0GDSVENntN0jEv8Rkgc+y2gqo7hVlr4xwQ+Kq2iYKJXsbW5JwUWf0zSjWOgtHzPjgHsD
         A8Z4dtiugn7bGXcfe+BRZiQXaar5T/Mm3SWlTEPj/SIPGRGt06vtHxMkxp6jxpvYZT5n
         7ptg==
X-Forwarded-Encrypted: i=1; AJvYcCXLrMwQlpRaccVs/Bpk0wGkdP8j5o34rXBP6ONUjlKshT/ALQ36TBCUGzUGDEKJTayo+Ug=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7XpKpyHvXfUdZFJIE6R6lgVzlkGhHXieFfDAlrY6iYz7323YX
	Qkfg/FeVclJmfmBYmPiNg9EO7HSfkBEDiprPDWy1+YjVNgw7m0zfQvl9gCctOh0=
X-Google-Smtp-Source: AGHT+IEyvhxwwfs3O4zBogJKiJanB1/6FwZWrxSk8P1iezRQ+YaRZrKbsv+G1dKwphxUzMpD10O4JQ==
X-Received: by 2002:a05:6e02:180c:b0:39f:709d:72b5 with SMTP id e9e14a558f8ab-3a0848fc3ddmr16439855ab.10.1726126827207;
        Thu, 12 Sep 2024 00:40:27 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:26 -0700 (PDT)
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
Subject: [PATCH v2 23/48] tests/qtest: replace assert(false) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:56 -0700
Message-Id: <20240912073921.453203-24-pierrick.bouvier@linaro.org>
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


