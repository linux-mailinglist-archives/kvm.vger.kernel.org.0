Return-Path: <kvm+bounces-40393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D06A57124
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:10:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E4261791AD
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6562512D1;
	Fri,  7 Mar 2025 19:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YRoMmE9E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A68F2505AF
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374617; cv=none; b=GlABQfKjiblVxRL187ElEKv1IgjnGJO13CFYWSgDygMsmLE+m/SRz9xeevK83eBkLWzo/8T15tB9K1/PzZTNxAM2+RFJbmAX3erOb996BtK+UV4sQ91JJ5dQxPVVByCszGEsFmMBy5QNYqF13YWGhkne96wN7wCKDVmbNHfDEX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374617; c=relaxed/simple;
	bh=EkovfYpD+8I9GxidCF4qswFiKSQoPX9wfWd7my0rMUs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XQVBdK/UDUoZAadcqU3BLZ1o97zjVoVwPpLlMTCCvan1B+DxZgpopYABGTRFeaINa60Ig2WS/n/7tDHa38dcWqC2VU0i+MK2/GbSo7RNL0XJriCI1h5A7agcFoKOOCO8Mg3uBWj9H2G402Ck9Bq3R2tgWjamjvnxLOUmloBQawo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YRoMmE9E; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-224341bbc1dso14052405ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374615; x=1741979415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UxupFXt8v+cWVWtDpN1/5KOGycPEEPte7T4sMzf1eqQ=;
        b=YRoMmE9ES0XSocMKYNSq7iGg2y+mKMI5dd/ImC4kDsVV3iLIr4WJgXzuVWpzu3OVnf
         aQ29uXopAwAz1+043WC3ZXDv2NIpyEqtQXepUQhrtDq6pUB7FqtccZWt4KLXfKrGFX+s
         ZofGkQTpqDRrjPlRR9snPFObQuS4r4LvgRaWTzUVGve5xaPkZy/ykhT864k6QJlr2wLW
         4FINwxzIzq0NW36VSYHhQNZEqMJQEQ3kbQobUj0QdYoBSBAmnyUTKWUgZDhuFFhFaePv
         2OI8KnQktDw3bkf+pJu0J6nEqvRtFTHe2qdYiSWI3+X9u6Jr5eRanRM31Cup3Odso8hu
         DcAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374615; x=1741979415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UxupFXt8v+cWVWtDpN1/5KOGycPEEPte7T4sMzf1eqQ=;
        b=h9vnrrKVjWkd04iJGP7IC6TwUUotMwgNnxrP1GvcBGUI6kvj5RVLDiZYYv+SMTDfl3
         IYV4MB5VuS+icDxM/fYEVG8iyq15obH1DknDKW2YcHnOULhbp94dGK3kkYwPPzeBxERd
         FwJS7eQt/jiYfCHNFSM84Jw6sbd/X30Kfd7jZOmONl1rSU6+gWzvTkimm26VyY1+E6Ce
         95MPj3WKzPpGbpiuk1zoAmP6V8u9yH1axmzvmmOabBnP2d/5TK00tiMVqRgjiYiiuK6/
         KcflZ4CHrInkU4wABlDfEwVD2iQ6pxeurc6o6EtoY34arHRJFzfP3b6ENvAIGsAdM1IS
         VEwA==
X-Forwarded-Encrypted: i=1; AJvYcCUPrEW1SvAotpKWeGL5zess6vCz8/Xam/SkmyzJOLyp2qbokAxNAGK6XHDd3KC8fMrpCaI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWBMrIWT9Xh3osuK9HnuV55fcXmf87L8q39PEKWenJ0sWjORH7
	om5zL7OBpzQNZQGeeVNbZUO8uM2/CiXBrRqCsiMy83ukdDcitNxMVQRDmDH+mzg=
X-Gm-Gg: ASbGncsOva3PbvKbC+8zT2VypYTGCFomot9NOaMzFRigvKffXpiN8y/F6MStVP+vVa6
	wsMhsck1A4u+R2urhPT0lkM7cHouIVJ8QU1psys5E1ws5z/0oqE5TEa1PksCPQprG2sS50/8fyh
	z8k1eNqrz7dobBCEKcXEmHLpbevhwX0/feDmYLf1qDcFJYYQ+cE5w3yKhxgDb6pHA+RluB8Hy85
	xWL9+iXKvMmZPlnDVKN4RYayozpdor9yLtYPoZCoslxGvsmyBywzGL+iuOxmY5SKGqwwWy/+ZxF
	Gj5kandq1vKHVWTNDN4va6UuIBwfMLakdkBDAoCaQODF
X-Google-Smtp-Source: AGHT+IFk7jHET5Rs41Ubs4P3mm50rGduCenvs6hzji3ZZTTsMDlCYtfecrZbAZzCmTi4EWlLoN77Nw==
X-Received: by 2002:a05:6a00:2e17:b0:736:a7ec:a366 with SMTP id d2e1a72fcca58-736aa9de241mr6584061b3a.9.1741374615256;
        Fri, 07 Mar 2025 11:10:15 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736b2da32c6sm1449895b3a.149.2025.03.07.11.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:10:14 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	pierrick.bouvier@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v2 5/7] hw/hyperv/syndbg: common compilation unit
Date: Fri,  7 Mar 2025 11:10:01 -0800
Message-Id: <20250307191003.248950-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace TARGET_PAGE.* by runtime calls

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/syndbg.c    | 10 +++++++---
 hw/hyperv/meson.build |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
index d3e39170772..ee91266c070 100644
--- a/hw/hyperv/syndbg.c
+++ b/hw/hyperv/syndbg.c
@@ -14,7 +14,7 @@
 #include "migration/vmstate.h"
 #include "hw/qdev-properties.h"
 #include "hw/loader.h"
-#include "cpu.h"
+#include "exec/target_page.h"
 #include "hw/hyperv/hyperv.h"
 #include "hw/hyperv/vmbus-bridge.h"
 #include "hw/hyperv/hyperv-proto.h"
@@ -183,12 +183,14 @@ static bool create_udp_pkt(HvSynDbg *syndbg, void *pkt, uint32_t pkt_len,
     return true;
 }
 
+#define MSG_BUFSZ 4096
+
 static uint16_t handle_recv_msg(HvSynDbg *syndbg, uint64_t outgpa,
                                 uint32_t count, bool is_raw, uint32_t options,
                                 uint64_t timeout, uint32_t *retrieved_count)
 {
     uint16_t ret;
-    uint8_t data_buf[TARGET_PAGE_SIZE - UDP_PKT_HEADER_SIZE];
+    uint8_t data_buf[MSG_BUFSZ];
     hwaddr out_len;
     void *out_data;
     ssize_t recv_byte_count;
@@ -201,7 +203,7 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg, uint64_t outgpa,
         recv_byte_count = 0;
     } else {
         recv_byte_count = recv(syndbg->socket, data_buf,
-                               MIN(sizeof(data_buf), count), MSG_WAITALL);
+                               MIN(MSG_BUFSZ, count), MSG_WAITALL);
         if (recv_byte_count == -1) {
             return HV_STATUS_INVALID_PARAMETER;
         }
@@ -374,6 +376,8 @@ static const Property hv_syndbg_properties[] = {
 
 static void hv_syndbg_class_init(ObjectClass *klass, void *data)
 {
+    g_assert(MSG_BUFSZ > qemu_target_page_size());
+
     DeviceClass *dc = DEVICE_CLASS(klass);
 
     device_class_set_props(dc, hv_syndbg_properties);
diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index c855fdcf04c..a9f2045a9af 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -1,6 +1,6 @@
 specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
-specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
+system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
 specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
-- 
2.39.5


