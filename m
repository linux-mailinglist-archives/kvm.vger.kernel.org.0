Return-Path: <kvm+bounces-60463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A151BEEC9D
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 23:04:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB3E618995F5
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 21:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF2323B638;
	Sun, 19 Oct 2025 21:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7c80fXu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F223239E75
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907829; cv=none; b=gvI114ilUpr00s6Qa9wD0XYZ4uIHqZZBagsllrUrFhFWt9rRw+9F8UuEIziOwfQ9mkjtrutzLlQOT/QQyp9b18pWhTw15UYSA1/1IDBzsgvzoVUtFTEBzKgcgfFpltY3tUe+K8L8iUDiCVW4++6ec1/hXq7GqZ8ik/QdZZ4d5OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907829; c=relaxed/simple;
	bh=k93q0YMqm3jVmEWQMi1uzpao6ZmqNYDpRHhtnvljGlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/qEXO2oHui+Tg0daTbt1KXya9qyRvah0UYTw/BzCB0EtTEz7TIdAetGcZxlnUwG+qIXFJbtHY6l0nQyJPJabiEafM2ZfRzrwclxTqa/63IMS2YfE2ezA19RQuwWPKrn7NY96aX5SYYGwiN0BMsg7jrKmveWy/8e9AKRmBx8UBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C7c80fXu; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b3ee18913c0so697458766b.3
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 14:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760907827; x=1761512627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQnslZlvL/ycghWXR/jv6T9Aq0fKGJTc5vHN36t+VJw=;
        b=C7c80fXuoQxT9eN6fCZa9H3QuH9UFg8TyUqh8+FMyYjWgsYgXk27tLuUq759J8MBxi
         exeLN+8N6Gb1MMtVrx7H1u56EdV92erzQJbfKpMQ2FWDted+f2FZr2uwXm+dnp5A8Xbi
         qT0h0gzpIQk6pmswlvrMSj9g0zbm7rqv6+OdV/iGG/g1aYhJU4eaJQmHd3eDd8KHCkX6
         VUxs6CpGqjSrWw7JvM+FR6VTJHtZyiZG2tdZwLfuAuTNE3PiV7wamsNt9ZvzAIwRUU7e
         WTxjfRUzBsGmUbMB85dVHhMdyRWepel+mnmEDuxai/7NfHe1SUtSyZEk39b1WLCvZESs
         wDNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760907827; x=1761512627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQnslZlvL/ycghWXR/jv6T9Aq0fKGJTc5vHN36t+VJw=;
        b=bqZs320pbkMFgHh5U/Fwvjd2X9L3FhLFLEk+pZXhtN7xHS1ecb4H2swYhaE8R90lkQ
         vZ9V9weJ5wpGvQWXKXV+HM1Ve9j5w2PLioy5W4KDqOYPTApsnBLFUxNOEv1hXHWoD9nN
         2/hTH5EqZxCCrIZwkiuMO1eoEyjVxcEwaGI70aXBC7QOvWwdbf3uVv/7vAXbuNJizqXK
         mNBwcg0i0wsA2CKHrWUzVpw3ujwFoTosydzXv7l5GIwgyIEsswhgBAeNOQWm+d8isPd4
         ZLp4/dViUbkwSCf1fZPmGCQAWHE43RJKDG4fG80ikyAQyBV4tLkHbfiGQrtxsmCm364Q
         qcpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUX6MxY4/XYx85An9uqKVdUKicDVKcaGchlRt4qdHqX6eS+EyyaAkegOTQbrAq4x2LJT6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YztPXy4F7BkwC7tw/LchKzTV/DpNBX5yQXShJYDXCaHdvxqtoSt
	UgjfS2ahIGWix74LKNcm19ptxwN2LScpd1BY65AehfHJ0R/7LTcYvd55
X-Gm-Gg: ASbGncusf8S7IHYleh9kFCsPg4PGCzHgPvBZgcTUvBpE+V+es76XwDAqTfbFK21Nbvv
	nOxTK6R28j2wPxAr3y6xwNyGmajIyHPrZNRwhBeYTdv35KV85Ww8GjVvpU/xV0tQZD3UA7B9h70
	+okTd/cNkeQOUe1+uK4NFkreThddoYrjnDFKpdcflDToiizRSfSkkU1GHhwfA9N9TWkiox6/ZLt
	GMJlKHe9b64wrpTK4yMlmzhDOxAu5ISJAL1UJB22bSw1nfr27eCjkMemTMQHFwifLNdxechCSOP
	KZPOi59tBW2BODA52YGIKNv/LH9MQbV/H+1T+sAWmnMBarKUA6uTrBVl7uoEji6kBk7vBVrZwMy
	CA3coHEMt6GTZQOIY2B/3z3iyKxs0+fmWA+W7Fix1C70t7gBM0ula05FkOKuDEiIVht/w9HrHSZ
	aLBjXtdQ/SQ7w/Kr4AwgFqFv3Qdecd4L13fWiYegaimUGAtsV34z/H2I0Qf4MaTXBNSGd0
X-Google-Smtp-Source: AGHT+IFxPtXo9vzXd3rOAqwwxaNDvJIFsK7Eo1zA6M2lE6v+t/sNoVY4Repet5YBzuRnemWgklColw==
X-Received: by 2002:a17:907:c06:b0:b3c:bd91:28a4 with SMTP id a640c23a62f3a-b6473045139mr1262880766b.28.1760907826411;
        Sun, 19 Oct 2025 14:03:46 -0700 (PDT)
Received: from archlinux (dynamic-002-245-026-170.2.245.pool.telefonica.de. [2.245.26.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4945f003sm5107655a12.27.2025.10.19.14.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 14:03:45 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	Michael Tokarev <mjt@tls.msk.ru>,
	Cameron Esfahani <dirty@apple.com>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-trivial@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v3 10/10] tests/qtest/ds1338-test: Reuse from_bcd()
Date: Sun, 19 Oct 2025 23:03:03 +0200
Message-ID: <20251019210303.104718-11-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251019210303.104718-1-shentey@gmail.com>
References: <20251019210303.104718-1-shentey@gmail.com>
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


