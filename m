Return-Path: <kvm+bounces-40426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F5AA5721C
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 203B2168401
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B62B256C61;
	Fri,  7 Mar 2025 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sFsA9Dav"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D95257437
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741376250; cv=none; b=FpSw5Bq9vCkzhWEaUUxcyV7QBI2kd88PbrTFfclBETqF3zrw3htNJQ32V2r717nLmkzQfRt0VZ3MAoLRGWD35sTf2mp5GhhVWoCTU4mPlNDlTIyiBVcAVvrmx/a0iWdMbnzus0sMe7rV3uxVs4T5ZHsq7Fl64Xl1wbplXzFvsJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741376250; c=relaxed/simple;
	bh=2cHFRxcrDOQORnwpMppKt+pStx9DePBOJ6qwvia8E/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D6C7HUuTSIVtRmArexZ3uDbAr7DDBjo+baqZRo8AdnsZBYy4E0G9zKxIf+g2ypK+TUFdM0qpJxnEYZUJqJpQP7JAtwnBQ9SxHl4Xn39K1WwdHF+TeK/NygLq8QJ7Gz0KegodmcNvBM3fsdo9pND6QaDeZpKy1vpIWK2+blKg2+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sFsA9Dav; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ff80290e44so2138424a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741376248; x=1741981048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7TO8UyCMpQA9GFmU43KRp15LWAsbGPR+sOTKQ30ilM=;
        b=sFsA9DavbhA2OELKxUWxahNCpkLiWeddndft7P7dwHlg0shwp5upxEuNRQreRF4ZUd
         HzJrHzO1Dd8udMOF9W+yvRz6bzfsxqxK8qJ4aeslZLrZPcQcCgAGupyTkvh+KqXX5uDz
         C8olrefd+Wez8v6u9b0wbbG1uuVgSEIa2xTLcPdvfxC39IJ7EdNK3EBhfb5pVzNcFv1b
         WYXOHtZfwdPLF1f5dIVsJWXkF1p44fUxlpoNvSbHwfU9fXN2+vxOObUXhRp2DT7yZnsp
         iAVgrqHAuSMk0iiVZNjMTzHln0x3Z3S1pVAaPlsBqGfUYiW2cGTqO4jRfF31JXiuzJXU
         nhZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741376248; x=1741981048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y7TO8UyCMpQA9GFmU43KRp15LWAsbGPR+sOTKQ30ilM=;
        b=fN7LSh/+IfydCtrMVP9b3cQdX1pQXpua/p1JsLGkKS5RP1uSKkNDJ9BZuUT9Eqr70f
         qAZXITr7mhY2AGYtoeCjDp5S6bdxFpSbMnFOwG/4d3iXlhlvJfDubN5XCz89716wSqPW
         YrqalAPEVMoYMTtwTAkZ4Vz0VxkFG652uKOLM5p9NWqcM1N4gJdVmfROoBQ33vR7UKn2
         BmglFyAxl5xe9rezgIBVdpqivihyI9VIdDstZm4zHLv5xbey54eDKmfGGgyS5UVTJ4f8
         LmLgR1x3DKjqQXiA5E7u7WEOSOMElZ2V66L/7+bN0lmdgKpqHU3asG52BefRXHPosKq5
         LhXA==
X-Forwarded-Encrypted: i=1; AJvYcCUBuF0KQRieenxXq02VLsS/7R/qx+Yx2RjNdFMSGJRUOlg8rqeGUbH//gI9X4mEcW2Psmc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGYixrEaJwe/x/mz+iVqQb+yXn0k7pDOGnOrfBcqrhbflQMlIl
	o14Gx+XULtrfyO6lZQ4uyu8dpzma2L4zUimM6vNeS/iJJTx84cD/Wawtu/2u1Fg=
X-Gm-Gg: ASbGncuKZCKlPWObt/L5uQNoC5QbGXIjIjrWM84dBeamRv4bW1vJ8akFLjeckbVNtF3
	tezpxHCDanQdVj3m+UHpewTOuPXzWxQUkdbJ3E9EVN1bQAyGHF6LAf5MJNdOUD5wTrAdnlV60d6
	n6e95piq/j0rnqhOFocUhS9muZMLJ1I+Uf6QUACAsE1RxOuei+4fh6G/maNhJ9KJdqyvREYv1NR
	hvyDEp3FKkKSacnx6jHvt65qKBCtew79vPDvRbdi3gniu+zABwHXR3OlIXYtIayfoi1to9SyXyu
	OfNlRuG2ZwgdL54OGqXE5cvLoDTtnkmetuK0009z6Jnm
X-Google-Smtp-Source: AGHT+IFj65vtT81oEsrUT1DRviBXXeZJTWcarf5IGtmt/W5WbNQvB9z8nj3KFVpsxQFrj2wLp0iOpA==
X-Received: by 2002:a17:90b:38cd:b0:2fa:17dd:6afa with SMTP id 98e67ed59e1d1-2ff7cea999amr8282502a91.17.1741376247034;
        Fri, 07 Mar 2025 11:37:27 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff693739ecsm3821757a91.26.2025.03.07.11.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:37:26 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: alex.bennee@linaro.org,
	philmd@linaro.org,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v3 5/7] hw/hyperv/syndbg: common compilation unit
Date: Fri,  7 Mar 2025 11:37:10 -0800
Message-Id: <20250307193712.261415-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
References: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace TARGET_PAGE.* by runtime calls
We assume that page size is 4KB only, to dimension buffer size for
receiving message.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/syndbg.c    | 10 +++++++---
 hw/hyperv/meson.build |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
index d3e39170772..0ec71d9bfb8 100644
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


