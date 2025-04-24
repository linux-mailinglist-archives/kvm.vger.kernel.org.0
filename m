Return-Path: <kvm+bounces-44233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97956A9BB3D
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 248CB926878
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2660F291143;
	Thu, 24 Apr 2025 23:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="az5+vshU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B902828E61A
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537324; cv=none; b=BexmlDCwS+zI3pU2RcGANbTirJ4vX8kxw8KI9tzolI0i+3mLzyUIkW1VGvAchzp8MQ0YWJaUs39YkXdcixaM7zYoS8zwDnYTXxKJHrbe11tTZEjbSmTFZZSgpLRevcOgjsyIx17Hhp0ygf6t3XXG7oFSMcQxHBIAtKDzlzxPJNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537324; c=relaxed/simple;
	bh=RfvE2RFrZYArrXJFfcxoqeofl87zPOaTANAeAOeLGuY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CyM7XVCB0/z1wqdKsTEQKNqS3YuGZ4cm/LGcCf7+pQbPk7Oi1XWOclbtrIGn2stDoI5f6wFGHV1wxIQ2wggEVUiXIJKR11L1jcI5zviM7LG7+jWlw4Opaj9cpo9xsqOZ8oZq5fZsEii6+bcM2md6SqMZI2Yj+B8H8ZMF8h0HYaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=az5+vshU; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-736ad42dfd6so1449149b3a.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745537322; x=1746142122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VU4H5gBzaTT//12kf03NeonR/1W+AoBYDcX+xQsRjak=;
        b=az5+vshUK3RU3ee/5WV41fTIjy2dSl/DvwZI5yCZtVAIsaSOzDwURqaigayR8m9Dj5
         KOEkvh/9cb3NGcAZmB72UxwKxzNR2gNBZ2/AV4cYnQJwppVMRORI1cZZw1tKWXIBXI61
         vKn/HHHpA6fjSPxT1aGEwTBhbjlIJ8AjFlS7wEWtOdEjuBXtJUXxlWBTvoibhuSD7ONj
         kCZFEuapIHB4+2tDZXqv6ek8y43q71DD4YtXhcqdP8TiKZUHcNEOoA1lof6DmVzsHqOR
         oLrVxLqTOLU9CFluQkcec5zyUCCIAuBihCDCRlH2AtamK4lBRHQTrDaW7WL4PkxWKCQa
         wVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745537322; x=1746142122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VU4H5gBzaTT//12kf03NeonR/1W+AoBYDcX+xQsRjak=;
        b=Z8bThumYV5lhXa8uSZVmUnUan56/dVxjmP3mbItDAI+/2x5uRak80dphaqIAVpA1LE
         X5Si5kV7YHQjkEfeww1uozxcRyjDb40VyLsSF7ttxW8eSJwBTYayGP4xT69xlnY76x04
         9rGZsHbv1kAltMC9FO2WcOFB5uRYbZzpNtgwvXpWKjozI6tAg/eN4IRN3UZmTroWNqyS
         0tyOx9XQrRx1gaDGAXldoD1SfNBd+ZRdX8irR5aZfFzxjclbO5CFpr0H479Ds4j4j0wo
         hJ2ywezRQMspL3s7WjcPTEJPeExeEb8RmtFAkhDvJpmhwIc+tC0zlgZgOUtjaPNBrwz3
         LpUw==
X-Forwarded-Encrypted: i=1; AJvYcCU2PjEFLT3Q7sFWMGzc+6LEB2aMzPI7WlZozer/x5to2dof4oLLouDHYXtzhpwV3TKAQFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI9XQBgCNUgEFzvVjJ5C0J98BCU22ADBLQnKrz64hXU+H700K5
	PaBJaJUBnZ7T7gMm8XaxXZ6/l9LAtRt5O/HcjmKz3/5RmPZwls9A6jLUfWcuaBc=
X-Gm-Gg: ASbGncv4CRxs0fQv1KX1vmkeFawgtNeQ8+372wwz07MARu9N8v53+us1zXb6Bsm45Xj
	c5KGLiPgibifsMy0KBZwZB0sfyan3qpw+Xfx2OcfZFVdjN5wLgJKUiJhQOzmTJbl208yQpfc3E4
	ocpa7ii+EIjs3izqx5E3GjL/Bav43s1XoT38hlxcIWX8BuxF2o2aX7dHVoS4l007qUKNp+fmJ1s
	ok0eY41M9qVLIAv5eknsrFnHcYNAZ2YlVP7xC/MRyP77SqGiJs6h3UiW3fmz0OzVhihNKDA6cKJ
	yYMUZrP1xPkNHbR3KauTR44J1ODuwWAK9HvRqBoZ
X-Google-Smtp-Source: AGHT+IECiElg13aCp6iXTwsCVsYwe1s4yuOdgcG0oT4UliCkJPy+e1n7QFUec7uaJun/gU3pWxujNw==
X-Received: by 2002:a05:6a00:114a:b0:736:a540:c9ad with SMTP id d2e1a72fcca58-73fd9047c3fmr122457b3a.20.1745537321988;
        Thu, 24 Apr 2025 16:28:41 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25accfbesm2044318b3a.177.2025.04.24.16.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 16:28:41 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	philmd@linaro.org,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	richard.henderson@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH v5 4/8] hw/hyperv/syndbg: common compilation unit
Date: Thu, 24 Apr 2025 16:28:25 -0700
Message-Id: <20250424232829.141163-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We assume that page size is 4KB only, to dimension buffer size for
receiving message.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/syndbg.c    | 9 ++++++---
 hw/hyperv/meson.build | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
index a410b55b9a5..6cb8b6c427a 100644
--- a/hw/hyperv/syndbg.c
+++ b/hw/hyperv/syndbg.c
@@ -10,11 +10,11 @@
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
 #include "qemu/sockets.h"
+#include "qemu/units.h"
 #include "qapi/error.h"
 #include "migration/vmstate.h"
 #include "hw/qdev-properties.h"
 #include "hw/loader.h"
-#include "cpu.h"
 #include "exec/target_page.h"
 #include "hw/hyperv/hyperv.h"
 #include "hw/hyperv/vmbus-bridge.h"
@@ -184,12 +184,15 @@ static bool create_udp_pkt(HvSynDbg *syndbg, void *pkt, uint32_t pkt_len,
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
+    g_assert(MSG_BUFSZ >= qemu_target_page_size());
+    uint8_t data_buf[MSG_BUFSZ];
     hwaddr out_len;
     void *out_data;
     ssize_t recv_byte_count;
@@ -202,7 +205,7 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg, uint64_t outgpa,
         recv_byte_count = 0;
     } else {
         recv_byte_count = recv(syndbg->socket, data_buf,
-                               MIN(sizeof(data_buf), count), MSG_WAITALL);
+                               MIN(MSG_BUFSZ, count), MSG_WAITALL);
         if (recv_byte_count == -1) {
             return HV_STATUS_INVALID_PARAMETER;
         }
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


