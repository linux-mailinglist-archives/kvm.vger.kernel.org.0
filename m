Return-Path: <kvm+bounces-60327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDBABE91E1
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16E691AA1D66
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDDC432C936;
	Fri, 17 Oct 2025 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ktt8ZT44"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B559393DFF
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710381; cv=none; b=kE/CwXvIbHd69S4QLmIkY+cih1elYjpDDSzqm0ffOKr7y/02mGd+rwcr81n6lmK3lNDjUVklV+k7mEBOQQNScGpMXp3LCgsdhDDQth/iSRxDGTloCzc4WLZLx+iTVJvGURfb17JJqjPy+8phCA0ty14ihs3CfqBmBnYJ58InvgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710381; c=relaxed/simple;
	bh=k93q0YMqm3jVmEWQMi1uzpao6ZmqNYDpRHhtnvljGlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWwSUPSwK/fqju1jBTLe7Qm0wcGgTNfSo4AKDu9xIOaVdCH8C1xXJUM8v9GGYIfbClYa1yCfLNVLmKTbQB1PpBJkx/Dr1oEVe410I6m20nOfaZODI5aUhfh9dylScMULM54sW9QMOFVvpF3YwtNKHKrlEfvmxvKZETyPFA38028=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ktt8ZT44; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47118259fd8so6876785e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710378; x=1761315178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQnslZlvL/ycghWXR/jv6T9Aq0fKGJTc5vHN36t+VJw=;
        b=ktt8ZT44lcLwAAh+Hpq0XGS+AugZNlX14UdPDx4U2mVkuxi3wpJRm7rgKb5t2ArgA+
         nSO9AmfYx5DWHE9O6IlOoPXyuyTEMZy3kH47a2hRgjiPiJVSrTUVu6Hw/X3WwtGQDmJ5
         qi9CJfp4pDfjMw5T1rZLCTmriaP9WWozwqci1WPa1MFsW85bv3v3cnUAOZPIvEe9+LxT
         UMMYgHcZ+t7G2oHfAFsf2kQXnAQ9eDgUaAR5QTqqeRhCl7hZlz+bcvg82IC0FszYT7lL
         TLDi7b+Iijafmruv+M/ZS8INw5I9vj3O3fbOO7cHlLEoayWPT0ZMYPy0hr3MeF2Tlmp/
         Z0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710378; x=1761315178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQnslZlvL/ycghWXR/jv6T9Aq0fKGJTc5vHN36t+VJw=;
        b=ObWlvJRhx2PY7HwQwQpEAwqWSlIcCmrTHArY8dBAL2U6s246FhEg1HQAwivxljBuo9
         kl78bIc0Zt5c74qs5uiAthzTqaaopaop88cfSaIsTikzHQfGBtMSbtvwJqfvvhv59Ku6
         fOwjQAjSyJRWNBvyfKwZ3AtvuHtlXknCXQPeV5aC8lXlRgAxAmmG1sUw2D1kBFNlLGsY
         72L7uBF7boz5pwDrGVOEQCDEmNb79ZDY+u+gks120y5WCBY+Hr3Nb3KplL0j9qzN9SxS
         6K/2aLY+cMj/rH2XHfeEcoa50nFhuJNUScRUrD+DjdxN739FXEtrHMGO8XX0kZ+dfzfL
         HozQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8FPpEeBzv1cG9ZoVwwTn17uCkMaeFqJ+m+D2X0P7YBt6uhp6Ao3bJY+kS2MR+lfxr07o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVZVrPTYZQQ9hj2/08teu3Y4n0jgStiX8r0fVhRUu6FibRfPUW
	5Eu2iQd97LcS471FdwqM/jGzCppaDwMxMQk/9vQd9Mrv2nW021b3983U
X-Gm-Gg: ASbGncs6ghcxOZlBWGfY/E6nNWl60yxNpqVfbi/eAmMySqtV2h+UA0LvZ4Js3XT3C7a
	w8WitY8P5v+5qgi9A/+pGRh0fBGUHwMF/YuAmmIXcaSvnWu6BGf+XgZRzpMJOCWzKw9OMKdc4UZ
	AXQ1/aXnhRGmpTJB7r7YijWbb+JO6fYMamhR2rpI0/lZVH1ZNGk68PaUyUHQbQyjwQo4AMQdUg5
	RPvZbkRTUt7UtvBjAWw7T8ahon6iQVyOBouMdLMweGkY8AJn0U8AQYUOs1iwREwgcdDmjMxIQJm
	+Edr+NcyxQyzdM4CRsdGFjeWpcTxUrPXw71NJJ0S4dMWe4Gu0qsN9zSpAQXCvH7mlGQpFwa5bnj
	RV+ihs8hirDd7rZJ5P0iw9+FiacEGfSPiFzuoYJR+6gH8Lq+u9JTOOVqtQkIb7+Kp0b9smIA299
	XbjjXEgDDKDrApBiA/VGb3fpjJv61QGLnU
X-Google-Smtp-Source: AGHT+IE3VdA3wZK4Q+OXcjfSwZbSfpo04I9zXOgWlNizZyarmBkO2VPXkxj5kadJ9tYwUN2d2fgUFA==
X-Received: by 2002:a05:600c:37c7:b0:471:12ef:84be with SMTP id 5b1f17b1804b1-47117900c2dmr26449135e9.22.1760710377632;
        Fri, 17 Oct 2025 07:12:57 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:57 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Roman Bolshakov <rbolshakov@ddn.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Eduardo Habkost <eduardo@habkost.net>,
	Cameron Esfahani <dirty@apple.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-trivial@nongnu.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	qemu-block@nongnu.org,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Michael Tokarev <mjt@tls.msk.ru>,
	John Snow <jsnow@redhat.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v2 11/11] tests/qtest/ds1338-test: Reuse from_bcd()
Date: Fri, 17 Oct 2025 16:11:17 +0200
Message-ID: <20251017141117.105944-12-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017141117.105944-1-shentey@gmail.com>
References: <20251017141117.105944-1-shentey@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

from_bcd() is a public API function which can be unit-tested. Reuse it to avoid
code duplication.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 tests/qtest/ds1338-test.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tests/qtest/ds1338-test.c b/tests/qtest/ds1338-test.c
index d12424d27f..b8d0e65ec4 100644
--- a/tests/qtest/ds1338-test.c
+++ b/tests/qtest/ds1338-test.c
@@ -18,16 +18,12 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/bcd.h"
 #include "libqtest.h"
 #include "libqos/i2c.h"
 
 #define DS1338_ADDR 0x68
 
-static inline uint8_t bcd2bin(uint8_t x)
-{
-    return ((x) & 0x0f) + ((x) >> 4) * 10;
-}
-
 static void send_and_receive(void *obj, void *data, QGuestAllocator *alloc)
 {
     QI2CDevice *i2cdev = (QI2CDevice *)obj;
@@ -39,9 +35,9 @@ static void send_and_receive(void *obj, void *data, QGuestAllocator *alloc)
     i2c_read_block(i2cdev, 0, resp, sizeof(resp));
 
     /* check retrieved time against local time */
-    g_assert_cmpuint(bcd2bin(resp[4]), == , tm_ptr->tm_mday);
-    g_assert_cmpuint(bcd2bin(resp[5]), == , 1 + tm_ptr->tm_mon);
-    g_assert_cmpuint(2000 + bcd2bin(resp[6]), == , 1900 + tm_ptr->tm_year);
+    g_assert_cmpuint(from_bcd(resp[4]), == , tm_ptr->tm_mday);
+    g_assert_cmpuint(from_bcd(resp[5]), == , 1 + tm_ptr->tm_mon);
+    g_assert_cmpuint(2000 + from_bcd(resp[6]), == , 1900 + tm_ptr->tm_year);
 }
 
 static void ds1338_register_nodes(void)
-- 
2.51.1.dirty


