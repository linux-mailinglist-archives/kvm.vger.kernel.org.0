Return-Path: <kvm+bounces-40457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D7B9A57430
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:57:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA0F8172106
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6440B258CCD;
	Fri,  7 Mar 2025 21:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uBUcgszN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E505257AED
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384600; cv=none; b=Yc2oZblXe6edIGymiPMUnXy+slD/oLliIkkCiDQbBkEtp5D43rF29CK4QFOwmaA734vgUUU5IdsiDhuLzPkvlJlefCARFIfxfpt5Zd967aBRyXG4t4BvCquN4rtvwzuqcyOZbMlCnzBcKyONRKmoGB/XsuwQylGNioRX34DlIbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384600; c=relaxed/simple;
	bh=o7hN/lOOC8GggDxAYrBlVuRqqWL64qdJAO8GDaK/hec=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R60GM2X3OH8AcUWhPTFDnLwPJz2m9vQatxGjhaYx3FFIFwUNFx/+iYPABzpu+opnnW50MOasWxj4PO0hi7jpdOmZRHOG3cVzhU87prjNNrQERxQKSxL8PGehApDnPI/SygXDw4te8QiGP6VGtQ1msYUU8m1i21BESXSs5pl7m20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uBUcgszN; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22401f4d35aso45462215ad.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 13:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741384598; x=1741989398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TvAuOoN8/PzrW6ePLHQAaqYQcMX7nhU7k0OaOWGrsUU=;
        b=uBUcgszNBKnP5JdVa0CtBeQXQFkhwLVNkNs8PH/x98/xThI2hhOtb9EbtqCnsQsLCE
         fue+dbdZ4t0l0uBJmQ88v8G95u50YRAeDQIgWMFK3wtSwH2PqGl/GQkN3MBeQXde7Y2l
         UndnV7LmcguZwg/xqvJ+zGRxQEsM/mtMiW4uQma4kfhfhThFGlFdrWf2yjWd6usT0VgM
         U8aIXikgwaH+zbzzTP0j4YfMxljhnDY8IfczlKbDwkTKz2e0KQkDKjb3OnjjJq045mgS
         vpgeLzlnZn8fmZTbGKBVh46Bfl6A+ftwjxxYuyTah+tsQhe4Oq1KDZZxHXUWTSFQpN35
         aHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741384598; x=1741989398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TvAuOoN8/PzrW6ePLHQAaqYQcMX7nhU7k0OaOWGrsUU=;
        b=CsqsYnlgMSyfavlWrWpm1cgtARdG9GYwd69VCUg5lH+RPo48NJT98O+o3PN2xnA8Lg
         Fpa0Q3tQA0uw4q0R+HlIrtC8pe8WoPsM8GYaQQUazTCoR9eqkgwnt0xBiMY0ssWXPfD0
         C4fF1iXbQVW2kSxpi3MhWLIk/sHOOluMegkGpGkI1eq3fioREoBkp5hfhoS7qiFY47CH
         iOjepFy8eGUjJ4yrdQj6b+gNiMMCDtkwQYjyfB8kKFFTIa4kEYfZbogYnqmnkCkSlsap
         pdijDJPj8Hy5kroKgWRdCpr2U4b89jQ+nxpM2JwQdrVL8YX1YYB4/xDSE04mWm4LrsFl
         LDCg==
X-Forwarded-Encrypted: i=1; AJvYcCW4yGVcMf+Tfv+bXwhl4cGxJLj3zuVGP0GN16QL4UfS0mI76H4/yF9toqMsHtFS9FSkz50=@vger.kernel.org
X-Gm-Message-State: AOJu0YwS7XF31IRKa1/dvSFP1hA8Y/HaQ2L3WR+Txnw0HAlPwQ6ELDj0
	SgcsdlgViagTCrZYqgFjtIvAfS4oOJN22jkhbhUi0CDsVKLKc1G56LXJZT9O1dDHLCf5J+C/ojj
	l
X-Gm-Gg: ASbGncvDbb6T/DFm4T+MJHMQlXKCPyu9pJipnjLUNlRD/jvtLva1cQHellN3Bv5cHgM
	ZyT5nlqIJsnkzPlvf9kSspBRkkW0Mj1iCbSZrUpz9wveSPuLsQKoJxPuC9yLvdBdFxBtGn8uL4Z
	IxVTbFS42ya5/CikTYuqDSPs9HB2Ih58F5IZwEWRg6dQIn/qaDfjpwm55psIdD0AwwvDHyhmmd+
	o72SuBtT0CwquFiVUpBFBkNct1y1j6p7PPL6KYNTCrxpvJeFUzFdauxzTXuoQC1iBIE/FwNVVJy
	IgDxgRcJT8G14KQYw2VgAGi/mcgVHpgzWSt/Cet8+UNr
X-Google-Smtp-Source: AGHT+IGl3pecSAWBhv2Obh4KryTo7/9V/E2hfk69YnyQdLFubkCq88mHRjshx69HtUMmfNzcVYvwUA==
X-Received: by 2002:a05:6a00:228c:b0:736:8c0f:774f with SMTP id d2e1a72fcca58-736aab02cd8mr7557373b3a.22.1741384598341;
        Fri, 07 Mar 2025 13:56:38 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ac9247dcsm2000927b3a.125.2025.03.07.13.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 13:56:37 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v4 5/7] hw/hyperv/syndbg: common compilation unit
Date: Fri,  7 Mar 2025 13:56:21 -0800
Message-Id: <20250307215623.524987-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Replace TARGET_PAGE.* by runtime calls
We assume that page size is 4KB only, to dimension buffer size for
receiving message.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/syndbg.c    | 11 ++++++++---
 hw/hyperv/meson.build |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
index d3e39170772..948829e6d89 100644
--- a/hw/hyperv/syndbg.c
+++ b/hw/hyperv/syndbg.c
@@ -10,11 +10,12 @@
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
 #include "qemu/sockets.h"
+#include "qemu/units.h"
 #include "qapi/error.h"
 #include "migration/vmstate.h"
 #include "hw/qdev-properties.h"
 #include "hw/loader.h"
-#include "cpu.h"
+#include "exec/target_page.h"
 #include "hw/hyperv/hyperv.h"
 #include "hw/hyperv/vmbus-bridge.h"
 #include "hw/hyperv/hyperv-proto.h"
@@ -183,12 +184,14 @@ static bool create_udp_pkt(HvSynDbg *syndbg, void *pkt, uint32_t pkt_len,
     return true;
 }
 
+#define MSG_BUFSZ (4 * KiB)
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
@@ -201,7 +204,7 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg, uint64_t outgpa,
         recv_byte_count = 0;
     } else {
         recv_byte_count = recv(syndbg->socket, data_buf,
-                               MIN(sizeof(data_buf), count), MSG_WAITALL);
+                               MIN(MSG_BUFSZ, count), MSG_WAITALL);
         if (recv_byte_count == -1) {
             return HV_STATUS_INVALID_PARAMETER;
         }
@@ -374,6 +377,8 @@ static const Property hv_syndbg_properties[] = {
 
 static void hv_syndbg_class_init(ObjectClass *klass, void *data)
 {
+    g_assert(MSG_BUFSZ >= qemu_target_page_size());
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


