Return-Path: <kvm+bounces-27125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 699C897C371
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:47:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E5181C219A1
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE042033A;
	Thu, 19 Sep 2024 04:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xX9UxqYP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819A51DA5F
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721217; cv=none; b=B1jN1dlpsKkbjH+PADeu6X1LT12hGDWp/dQ4o7gPBsyP0gtg/ZyLK+Isvdkw29io15tpN24ccxMI1tVBXug/jOLZVE7wIfy33RCTfjxfUNRvdLR2CNC1EqN33CzVJ/vRyUZPo1VxxU/THAKUXnY+DG4C2MYjWs41VwkEpsLgPzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721217; c=relaxed/simple;
	bh=N4L+nfwNlhn3xOr6sW3FA2aKkKmLjJrHCa14wWzSry4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZE/gaZU8bmjZDauyhYK3XZkIxzU7nBgaweJ64UUJkOOzrn25vdh9e6qTUAwtvSo9Mrl4nCBYpiHc7yY8/fSor1UvXR1tQWI49DP+ONgMX8MXVFdFgl8JvTHeNEHiVRmRsVLBm5CdEpfcdv4pRGQhd1LahTEfg+m1aS4axqLlUoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xX9UxqYP; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-718e2855479so288654b3a.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721215; x=1727326015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Azxsm+D4GnAmylef8kDOF8WcNEX0H+f5CVUHICifCkU=;
        b=xX9UxqYPT1n4Z+3ESdCX9C82AVkg2eqq/HGo1DGT9eEqGeGeZf5x0ZeOA9GG6/j/mv
         1A1urVgPYAScTdCv+nKWybJ+l12Kbt4I+cz5z9fpkG0NvaXgPCo7w+7EuonYDWmDDTN6
         UjEZXRRXgqZ+LsrEul4QyaEcg6keBO5/SGA5jmbi0tIJFbkHcmIU4iGsLyw44Fq7IEUc
         8lOggN4PGIOfqjq7kTMAFi4sybNq5948zEJUL//pitDQZvkNuCLfnAKHsTKOMLNw4ej4
         0tJWx+14OA4ktxCl2ROjhDHyonQxGp56I5Iidsw0nF/sJTiLB70NhOT5wDPiPBmDtekf
         4bbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721215; x=1727326015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Azxsm+D4GnAmylef8kDOF8WcNEX0H+f5CVUHICifCkU=;
        b=RMDTF1dgkK7reBgxj3EJXOafiuiVArH3CbImOJLbLc1erv6OSSUs1whMxPe0GyNgiZ
         S2JK0LP2JhLOT9P4l8ePclwUF52PaF26RfHSCoK/5ldEXPPY4eEALxUgv+LxSfu7FSyq
         Yd/G5XMRIm7OJyvsO+ceaxZUph4Z6YX+7iHI4hkSX1v9+qSMvfxCfCKi/qp6eMoDLcmy
         j554/J61rC4QaPb8ZmzoCCWHrB26p4KTcQOVBM+zANBssYbofWJ63f2BKxHzPHkkv3Wo
         VPGjx579ma/GPGwX4Kahz++CsGtB2dDxvhLVIvYq3gNJgHrd4vZEfHPP5v7d0bw53LFP
         cqKw==
X-Forwarded-Encrypted: i=1; AJvYcCViQp25zmzhSBnvqcAJADCNqBMAQtPPFz4sdApH7gSuxQQ/nf7uOoNmnBSlW1oPqyWgR0A=@vger.kernel.org
X-Gm-Message-State: AOJu0YytYgonp7ayB/U+9X21L8SyfQ8v27tTBIGl9TKllG9Rj6PHeldX
	253/gcmDKW5ZAZGDzXMc/XqtqGxVfHIiXcResN8fCXSJNutEe6WvnLw5Pm6iIfY=
X-Google-Smtp-Source: AGHT+IH8mpWfLmu3//R/SRK5Lkyxtdl1U1xPXKHUsLRMNU3Octj4owEwLu2zdVJDZekcWXpKcQsdUg==
X-Received: by 2002:a05:6a00:4f85:b0:717:81b3:4c7a with SMTP id d2e1a72fcca58-719262060abmr39788484b3a.24.1726721214659;
        Wed, 18 Sep 2024 21:46:54 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:46:54 -0700 (PDT)
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
Subject: [PATCH v3 04/34] migration: replace assert(0) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:11 -0700
Message-Id: <20240919044641.386068-5-pierrick.bouvier@linaro.org>
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
2.39.5


