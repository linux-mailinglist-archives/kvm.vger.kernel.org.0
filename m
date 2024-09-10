Return-Path: <kvm+bounces-26358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68FA097458C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BDB51C20CC0
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3CBF1ACE10;
	Tue, 10 Sep 2024 22:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yEOspHnk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6721AD3E3
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006593; cv=none; b=VFdafIO0OplWf7lFhcrjZxZzqSxaWaqmIPbi+Y6ZjfS28QADJ5nT3STtZAKIW2jelnO+68oUZAIDklckW7omsw+xd9DLfZ6BSQ+EL1aCB9QNYh25vgmfLEOWd2G0x/KAIALHM/xOLfVWQ/OljZOrjbX577hskXZ2XnL/Rk8sc0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006593; c=relaxed/simple;
	bh=fxB8igKl8nhtRXlHFp3cVXLJH563WLUoIrhcnU/BJrU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oxmsu9zoCliz8i0af/1lGZv4qO5/FbCulDF4YkpVjtczZS1hd3g13S1KsBX1GcPxk+FRIyG6JVHO7zYU99o90Z/h5QFU/hUly/aLIxrauo5PYwE1SC6j/ss7N2i2umkt+IHKzK3BTA7Yr3cvu8/NpfozlyEIMtQNlcscjiWmWsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yEOspHnk; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-718e11e4186so1244253b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006589; x=1726611389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSYhajPs2VsIZSUZF9nxgEDV+zkDqTYhjuMBxS8/VrA=;
        b=yEOspHnkdNwcpJdJOI56fkBIoWQiebJy+mEK+NkAa2cla2NqejOMj5UKLMrjL3NkGA
         EnXpFfupDB5ej43OWVzrhp4sgEPHmJEDghCIQKR+1O/LHTNeFqFYXNoKnJp2gGZombir
         piAMXC01NmRY6GUnlglnmHAJcDfo92XnwlTSxBJYfkm6PrIoEnvS7R0c8GidcjEooksS
         1Kg3G2aLSeb7Bz4hWxbXm3nnAdh4Z+6t6hYN+9Bx+MDnhnCSkFiBBhgurCS2+vv6DMHp
         xE8xI1vVxwSwj0wh4kTcA/V3KP6+qs3VYHMaEt40mfE3cPRPBYZ09Hm0NEnMiT3xobIN
         reyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006589; x=1726611389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gSYhajPs2VsIZSUZF9nxgEDV+zkDqTYhjuMBxS8/VrA=;
        b=ru/fWra9rWS2Gn+tooO/yWlmsToKGMqZo8/Je5p6wCodIsm2xveC8L7yei3oyZ22Lq
         IoeNkpF+ZOQ0mZeW9GREZCdZUEw4F7nQhEy+B2QbmxeZqgiQHb5YfWN+SuPUYVnQRhGn
         pvW5B8Y7W/MsUd64BNnpv5/1DZJdF8PuTzsLsx3exf9+2oDZHeUtq5NPCj0Eoa+hgKUy
         FHmCDM1nL1bvFFfF/cNvg8Pi50sCryODGK1KnAMVcVJxdQkAQNvy8ef/L4dm1n6zhvMw
         4wDkDEAT1TdC2bqdc4xEob/7lkoQsTB52ohHpLDZmEY+8jWgwl/U9Pf6jQzwD649VVTr
         GOEg==
X-Forwarded-Encrypted: i=1; AJvYcCXt3ZaHR/kUmOHfIdC9pWNy/HXUSg1/fLvDZCariQkIsyra4XIWT3h8ux9qt5BYvIlG7L8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyNTYx80887n0sPi7tVrft/xPAi0SUodOU7Gd9t+jTRca+lyxT
	RYqZVaPcME8JqM+/gaCxxigoRtw3TSDYTIvF3jhUqPjlEt8mcnwKWMv1fHg2GiU=
X-Google-Smtp-Source: AGHT+IGxt2HyeKoY0zj4rIpopJhEdomsqdPT1qYCGNgIZHRgnvsI9GfeO84x5fyCboG/E3PILzkmEw==
X-Received: by 2002:a05:6a20:c703:b0:1cf:2357:df1a with SMTP id adf61e73a8af0-1cf62c8d808mr1658573637.10.1726006589396;
        Tue, 10 Sep 2024 15:16:29 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:28 -0700 (PDT)
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
Subject: [PATCH 08/39] migration: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:35 -0700
Message-Id: <20240910221606.1817478-9-pierrick.bouvier@linaro.org>
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
 migration/migration-hmp-cmds.c |  2 +-
 migration/postcopy-ram.c       | 14 +++++++-------
 migration/ram.c                |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/migration/migration-hmp-cmds.c b/migration/migration-hmp-cmds.c
index 7d608d26e19..e6e96aa6288 100644
--- a/migration/migration-hmp-cmds.c
+++ b/migration/migration-hmp-cmds.c
@@ -636,7 +636,7 @@ void hmp_migrate_set_parameter(Monitor *mon, const QDict *qdict)
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


