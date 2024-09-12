Return-Path: <kvm+bounces-26624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C4C9762E9
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1856EB21F6A
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE28191F7C;
	Thu, 12 Sep 2024 07:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L9j8Jerq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE37191F6E
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126789; cv=none; b=PHDTW1XBPz3Pomq4pWqfZx+qQ38z3a2KlMqQkz3ZozPtKSAW5vdA0LpdHWbN33bFvuKJm74kXLJerOsqeo3HX8JkVp5dOSlmRwfJayIbS5L6rsD7XPX8p49WZo4/alol0gH99ENyUnq2Bvec/f0B0m/R9q+YOn1cNy4E6K4ADSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126789; c=relaxed/simple;
	bh=XKcDNmn6XizW/gf7GqH5IzXaS1M/YG98kJBDWDnv8tc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ecmo/pg96hve4KJi8eJX5YqJmK96bQouZXgJnplUlZIMOKLHy5/j55zafocD1q7cwMIec5KYrlTlyTAg3vO3He9nxpuHD9g08ttME7wX8Zyv0fWWPy5iuAgUdd14/TJIVytPsYo7bRvFD0LBaQXhdvm777VmTrbgDH/oluKyAsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L9j8Jerq; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3e04b7b3c6dso331498b6e.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126787; x=1726731587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmOJONIVi8Rgmcdj3MpwvRz35OjK70IjJaXWHbl2cKY=;
        b=L9j8Jerq0UxADpGCC9maMg/zIrm/kLTGMQqZWAhCMCoEz24RThsJxQxzE1g+hcslFy
         nejLifeKUpLL0B9Evz+kGOkBM4P3axKODJTc9JHVlXBGFh5Sgula2VrhOjo+kPTIO+sV
         aeZcuERhXDIzxVpuhdxLkA+iy8zZ7JLwozSU8jRXDGI4sNFxeEEUJYdLZsFs8X8qlWjN
         ku7UuAg4fWB2VqXgU+RHfNOQibARPYkVJKAH6uTqPuDpaAcQhAF9iDuX+sXhNYcz45l2
         Pxa9urIATsSpwBLwPCelGa0Kj+bpGuAWMw/9DWOHPXyRWP9ipGb9mra1JYjwVNXaVq4i
         WNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126787; x=1726731587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KmOJONIVi8Rgmcdj3MpwvRz35OjK70IjJaXWHbl2cKY=;
        b=XGu9dSCuldqcdo1f4hgAHDDCuc9bRp1NlLn35Luvj1RvqXhm2EAh/xdjhAkApy6YAf
         fSMo+TBH8YqCZzdFAhBIQMza3aLh6GQ+ZbM9iRCs4Djur62ATbUgm0NaEc/nKm8suheE
         FL6AE5x0vo7m7w6vy5S6w2kbNgUwkcv4SEDWoMQaaKmWKp4zhAUx2j4DdjQ4QaANzzDj
         6kCO2gIy/pPe2gtWxg/x9sg4uE2kYBx1zH78DFkLumEc1AyVnhyjgF0psH+FPg5G9wKk
         U32moBSAhiZMx22Vg/y3ASjKXZLd9LiICWJGQgT34Mtzgai0pYC1QNoZwiYZfVvn6Rwu
         rmtg==
X-Forwarded-Encrypted: i=1; AJvYcCWR7FvlABNyVyJWH4SRPJrF3ub0xMCnkYxHlRQ1HjS03cMtic2keBLZRtw23IssV4ZVOcY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ1uI8RALjTZYHitr3eLXCzzDUpMUCPdQT9zallEKDsAFqoHsU
	wgQtzlvbqNrm49rdfFmqVRZPn38oRI9XdggkaKnZkZ6dnArFBhBJyt3bBh/JlaA=
X-Google-Smtp-Source: AGHT+IHQmwwOBmli4W+UYIBuLgmtdhnhoMM/mefW6Mu1WXJhmB0TUFR0xhKaZNkIkcZOjB8bVSAq8A==
X-Received: by 2002:a05:6808:309a:b0:3dd:3d77:2774 with SMTP id 5614622812f47-3e071b29035mr1047445b6e.43.1726126787067;
        Thu, 12 Sep 2024 00:39:47 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:46 -0700 (PDT)
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
Subject: [PATCH v2 08/48] migration: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:41 -0700
Message-Id: <20240912073921.453203-9-pierrick.bouvier@linaro.org>
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

Reviewed-by: Fabiano Rosas <farosas@suse.de>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 migration/migration-hmp-cmds.c |  2 +-
 migration/postcopy-ram.c       | 14 +++++++-------
 migration/ram.c                |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/migration/migration-hmp-cmds.c b/migration/migration-hmp-cmds.c
index 28165cfc9ed..20d1a6e2194 100644
--- a/migration/migration-hmp-cmds.c
+++ b/migration/migration-hmp-cmds.c
@@ -640,7 +640,7 @@ void hmp_migrate_set_parameter(Monitor *mon, const QDict *qdict)
         visit_type_bool(v, param, &p->direct_io, &err);
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
     }
 
     if (err) {
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index 1c374b7ea1e..f431bbc0d4f 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -1411,40 +1411,40 @@ int postcopy_ram_incoming_init(MigrationIncomingState *mis)
 
 int postcopy_ram_incoming_cleanup(MigrationIncomingState *mis)
 {
-    assert(0);
+    g_assert_not_reached();
     return -1;
 }
 
 int postcopy_ram_prepare_discard(MigrationIncomingState *mis)
 {
-    assert(0);
+    g_assert_not_reached();
     return -1;
 }
 
 int postcopy_request_shared_page(struct PostCopyFD *pcfd, RAMBlock *rb,
                                  uint64_t client_addr, uint64_t rb_offset)
 {
-    assert(0);
+    g_assert_not_reached();
     return -1;
 }
 
 int postcopy_ram_incoming_setup(MigrationIncomingState *mis)
 {
-    assert(0);
+    g_assert_not_reached();
     return -1;
 }
 
 int postcopy_place_page(MigrationIncomingState *mis, void *host, void *from,
                         RAMBlock *rb)
 {
-    assert(0);
+    g_assert_not_reached();
     return -1;
 }
 
 int postcopy_place_page_zero(MigrationIncomingState *mis, void *host,
                         RAMBlock *rb)
 {
-    assert(0);
+    g_assert_not_reached();
     return -1;
 }
 
@@ -1452,7 +1452,7 @@ int postcopy_wake_shared(struct PostCopyFD *pcfd,
                          uint64_t client_addr,
                          RAMBlock *rb)
 {
-    assert(0);
+    g_assert_not_reached();
     return -1;
 }
 #endif
diff --git a/migration/ram.c b/migration/ram.c
index 67ca3d5d51a..0aa5d347439 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -1765,19 +1765,19 @@ bool ram_write_tracking_available(void)
 
 bool ram_write_tracking_compatible(void)
 {
-    assert(0);
+    g_assert_not_reached();
     return false;
 }
 
 int ram_write_tracking_start(void)
 {
-    assert(0);
+    g_assert_not_reached();
     return -1;
 }
 
 void ram_write_tracking_stop(void)
 {
-    assert(0);
+    g_assert_not_reached();
 }
 #endif /* defined(__linux__) */
 
-- 
2.39.2


