Return-Path: <kvm+bounces-60308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5691BE86B2
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B91091AA54AA
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8CD34BA52;
	Fri, 17 Oct 2025 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXYm+4E9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FFB332ED5
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700849; cv=none; b=i48pmlCIQYuQTloKiMf9C3dsn3rVNtHuG0Zp3V35CQi52ZSMHycOScvVS5bhAVHaolb9xwZHErgf2FLxQp36N/UT8OKTy/U4Qgud2vU9K2lgimTOA/G21uFrxyACF5yqIJaHh1O4mT+yvWgWeblSZrA/Q7YlhEao/yKxDruW0Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700849; c=relaxed/simple;
	bh=k93q0YMqm3jVmEWQMi1uzpao6ZmqNYDpRHhtnvljGlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFZUjqlG3/K2ZutBJdSXcI0MnAn2xB8xwMx4ppNcJRFoF0onjA0W/+Q7BDv6vcI2XqTdrcQWeVjWaFPVYxipTb3iczYp8fPGD37ctDG9i4GWYhmKEARjiq+O0/2iSeW4fkLK0uvzWVGguJFT6tI56WTSc9lkF4MATyOHiZ4FAt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EXYm+4E9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e29d65728so12788495e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 04:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760700846; x=1761305646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQnslZlvL/ycghWXR/jv6T9Aq0fKGJTc5vHN36t+VJw=;
        b=EXYm+4E9Te6mdyL70S2S9YHzQ3rMdPbDvxwA3AlglOWugukAPCMS8B3PBKFBQ+vz1T
         cNfqUi5lMswL8FZGTa2AjX/t6v2/GR7OJp2vDDJZxhjzXwBhAvgIS+ZTqMfAY9mhY5Lw
         Itr/ORgNlLOa6+jlUTFLC7qxVWZIoCgk0zCKzr5ZAeP+/8LSJ1ItDK4JTSFJybXqRXXL
         ontT8iJ3545vNBhyTVAAsq6nLl8RTWXAF2WwXt1KhdOAku2uhw8T4JXwz6AUSvBzQqc2
         5OSKUJwaSHQZ2rRcDGFwF70qK+DyHagf2OEoiEahWfAWb20egBi0rFDT/NyquzWvWlRS
         0wWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760700846; x=1761305646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQnslZlvL/ycghWXR/jv6T9Aq0fKGJTc5vHN36t+VJw=;
        b=JrPK8mg1sKbf4RI1sA6MVJ0qGWObQPZhoA7jtj3FHcek1FZr7hdA+fNpbRi0o67JkA
         QnW1QLVMuv2tI11syCmA8FesoXW9VU96uv1waEoYh0w2CjhFVLyme76rtnMLVEk+gD/L
         1pM+jVTTOvfH7AGzaIXVUKifNU3dVH0HZOqNf65F0RgOmf/0bWqyiTVRvinagejM2SFi
         SaQh9FZiMPfzKbkVWg+FsXxwH5vq3Lsd3cBDFjpQCAjO3k7Ll7+kDaf2ZWmDvBoLYnO6
         GVyvva6wlECYpIvytETAdQDHCDaikR2aWyMm1p4NifuDyZSj4/s/5smqRj7qgeq+gIkz
         3seg==
X-Forwarded-Encrypted: i=1; AJvYcCXrsm/5x7jk7DSryLSj8sV6zACUHrZ1TJFBOPY6r+vvs6nxbal6Mcyb9VQGdZyzMlRYowM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzssP2ywltrf2v2lgv/m+4U/vxTLoicQPLEFPgXDtnKhiZoeH8g
	YD/K/swQ1noXIk5kLpE3wWCtRxKe+s+d5Q0cIWJbV0DRQAWfu2XsJS3O
X-Gm-Gg: ASbGncu5EadDTPSs0FluX1ht0rqZ8tCmcRFSWOqxcYa9fTX4bLsamjfA/5feePX1pj+
	fWoDrZNYUItSGhWJxw+Mw6vIjhHvKDjl1QSjU1y8JKO42pEdUkAi7L/Xyy1hzQ1ZTgPvA0WNFli
	uVkMHDm426kZaV7KFUC5FK6gjpBG/KaRKk9ivirK3OW+OD8Gu+707fEAsjd1fhKr76dag/yIpiY
	zMOWkK67b9vO6FpleCCKE5/mF+bNIzu1L6UikSKOUREK18us9mzsA61ZIzzN9bjKRnZCpnxzDQj
	k6a67vznehK+UmYcAywlCKTVU4mdYtaE0lttT7eeI8Oygd7ptk107689xK7OOosQVvAmvDvVsMj
	eGUruFk/GAMqEd191fbP/qTuP6mKaK8Cy6vz+xGrBdMhw2L8RMV4uFgpqj1gRO33h+rQiBwKUX2
	/iRbSVx532zicsUI5x7USKlO/w2BuRL3VG
X-Google-Smtp-Source: AGHT+IGDXcu2rXaYf088S0s5/SDu9Cf2kgWGnkugds6Z0E40Y/sQzyHqYGd7lbYq4iS2oi2fq9qvDg==
X-Received: by 2002:a05:600c:3e86:b0:46e:36f8:1eb7 with SMTP id 5b1f17b1804b1-471178a3a94mr25753985e9.10.1760700845944;
        Fri, 17 Oct 2025 04:34:05 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711444c8adsm80395435e9.13.2025.10.17.04.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 04:34:05 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <laurent@vivier.eu>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-trivial@nongnu.org,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 8/8] tests/qtest/ds1338-test: Reuse from_bcd()
Date: Fri, 17 Oct 2025 13:33:38 +0200
Message-ID: <20251017113338.7953-9-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017113338.7953-1-shentey@gmail.com>
References: <20251017113338.7953-1-shentey@gmail.com>
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


