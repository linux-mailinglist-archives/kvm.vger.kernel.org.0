Return-Path: <kvm+bounces-60454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F43BEEC88
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 23:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECFC13E45FB
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 21:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1706D238C07;
	Sun, 19 Oct 2025 21:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FIIKo8eO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B43226CF7
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907811; cv=none; b=rL5Gxp+tq4KELwR5ns4EGMlLMNu68qSLGNwdLrLaXmhuRW7pcteydPUEogZ+r4nqpRtdGrzoqltdlfbqf1qK879WjMrWl8JX3hmCcCAfe8ng3gp5mm0rGjUn4lugWZQjNR+c9a50OxpVRjJKnrQtjTs/nlQONKb9UOaRvrmCu1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907811; c=relaxed/simple;
	bh=bxdHKZc9pbxBqChYt8+Yh2D0W1yYdSw1LpL8rApqlNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8d3/YzEKOr65GBnsKSBg1T5YciF939ci6j2UY3b2KqO+h1W9tD8EM6dJW1PWHG6ZV+DhmMEsxKlcrCOdGe04MxsrB8SN+PEw1Z+wFU4+nxXBCMjeNY/zaPSVmqkf4AwWiGkMN5uwtLiDlIx6KzYBmsms6Yu9dHPwj2FjXpo+DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FIIKo8eO; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b3d80891c6cso893781966b.1
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 14:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760907808; x=1761512608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFuBYoXthwAAHQXYSal9xNPgZEHCC/OlTSTKqa/XfA4=;
        b=FIIKo8eORbCnb6AoM9cr7KJ9+aCpdpYztZRWSdRHD4hKThT4+HjhjPYG/sJvsGNC6T
         8qPQRTo9jp+HuZ3QegMpFSw8Ib9vQjvvvQKwqrWwPWMcYKt9HWazf3iDHxsRQCgtSZ/N
         UktPtFzp4yZGlWhWDEI8cDh2BqV78hlNgAWGWl96ej43Fx1Lz74Ggm/cr+hlmtJpknzJ
         88sCXQ9ZoOD/YNUDFbNU8sz04EsRf88vtwgqAJIGd9ju+8c1csY9STdmDX35RIfWM6kq
         nkiQ8Nn+JyXHk2V4G5q2bXOmqwRMejgWAUJ74K2VI4WlAniVyoYFUMUeuX7W5g/ngKG7
         c0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760907808; x=1761512608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFuBYoXthwAAHQXYSal9xNPgZEHCC/OlTSTKqa/XfA4=;
        b=hEYVuCozL3QzENbtwU6uqUB9OUNmIt8TtrIbMlsE3R+hLBDmyKEg3weTg1C3b4gVy+
         lMnpVmCpjR62CSLhpozg0OjH4TcYamEc9/o8tD5e2x5E339yc9k/FgDimzjot1lRwcyy
         y9PrFce67E1Fn276KZf2Y7gTMsNkUQ6jZPieIEPCgQhaI5gwC7KSe5AsEkp/p21GnsgX
         tAopaV/w6kcpLp3h6fCoUdRbAlI4msmzBVHI7bsFVw924OLalOKrmYLj90v45IZMnWLs
         uZGefMiqnZUhpZlz00Xn7dNNIzR7CJHQccHKwstt2hYdnkJbs0vfDv0+AC3af7Iw4pG+
         +JtA==
X-Forwarded-Encrypted: i=1; AJvYcCW+KQ5d/UdAIuBBog0euapMpRX4+iRoS61sziOt6yFNq+AmpZ3KnIFHAgC3ej22/cLIrQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUI9wtHet/aXYLJwocghy05otSYZIq0qUG615Bv1LvPg/akSF8
	bVRlxn5L5b79ntVdLYLfjavGkfSUTxnsyOTMj0641qWZ1RdTkAVaBlS5
X-Gm-Gg: ASbGncuAT9LUhECTSVbdlyBfU4QXh24jCIZ5zHUYj9HNwNppRhM9J/w7yd+8IFQZoL1
	GZgasmCr0/aFDgppGpTGiV2kc7jf1lCAA1Km2CJhVH5QHpmOdPL05/GkH81UBLkB759cqa+/U5Q
	6Lv7S8hzNw3eAyCsb2SxvZccqlcH7ggSFedJC1oI30iNLhSILywMjoSQcwB+bzSziSFnNS81VHR
	DKBjLUcNoJKzKDuKZ8+rpFggXf/c2tnXRZdXujwYYuzVFcsMePLfa5JUR4wcXmP5s69jw9fhTTF
	IqWtJVta3Mnxl9Zs1RxBscjd3WtTLLzK8FFQ16SgMIVtOT2sxkWeTKc/KzOnfeSs9AL0o3FW114
	CrPKQdloBmP1p9cm+foaXQrQsNhJR/YFn/OfUBPOPN9J5GbEg6WHJYlnwRTCvhY/IRD3l7Xyjgc
	099TpA/0NiFYrsG3fwUhkIW25N7QvoXkPsu3eXJDk5gXDAEMbd5/E1DAEdKA==
X-Google-Smtp-Source: AGHT+IEq801hCLtUohQJ3LOj0X3B+ZbYdyw4N64PsS7W265OlZV1xfYspqNnKezI+v90AM1dJWgHzw==
X-Received: by 2002:a17:907:3992:b0:b40:c49b:709 with SMTP id a640c23a62f3a-b605249d84dmr1777498366b.8.1760907807556;
        Sun, 19 Oct 2025 14:03:27 -0700 (PDT)
Received: from archlinux (dynamic-002-245-026-170.2.245.pool.telefonica.de. [2.245.26.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4945f003sm5107655a12.27.2025.10.19.14.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 14:03:26 -0700 (PDT)
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
Subject: [PATCH v3 01/10] hw/timer/i8254: Add I/O trace events
Date: Sun, 19 Oct 2025 23:02:54 +0200
Message-ID: <20251019210303.104718-2-shentey@gmail.com>
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

Allows to see how the guest interacts with the device.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/timer/i8254.c      | 6 ++++++
 hw/timer/trace-events | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/hw/timer/i8254.c b/hw/timer/i8254.c
index 4b25c487f7..7033ebf50d 100644
--- a/hw/timer/i8254.c
+++ b/hw/timer/i8254.c
@@ -29,6 +29,7 @@
 #include "hw/timer/i8254.h"
 #include "hw/timer/i8254_internal.h"
 #include "qom/object.h"
+#include "trace.h"
 
 //#define DEBUG_PIT
 
@@ -130,6 +131,8 @@ static void pit_ioport_write(void *opaque, hwaddr addr,
     int channel, access;
     PITChannelState *s;
 
+    trace_pit_ioport_write(addr, val);
+
     addr &= 3;
     if (addr == 3) {
         channel = val >> 6;
@@ -248,6 +251,9 @@ static uint64_t pit_ioport_read(void *opaque, hwaddr addr,
             break;
         }
     }
+
+    trace_pit_ioport_read(addr, ret);
+
     return ret;
 }
 
diff --git a/hw/timer/trace-events b/hw/timer/trace-events
index c5b6db49f5..2bb51f95ea 100644
--- a/hw/timer/trace-events
+++ b/hw/timer/trace-events
@@ -49,6 +49,10 @@ cmsdk_apb_dualtimer_read(uint64_t offset, uint64_t data, unsigned size) "CMSDK A
 cmsdk_apb_dualtimer_write(uint64_t offset, uint64_t data, unsigned size) "CMSDK APB dualtimer write: offset 0x%" PRIx64 " data 0x%" PRIx64 " size %u"
 cmsdk_apb_dualtimer_reset(void) "CMSDK APB dualtimer: reset"
 
+# i8254.c
+pit_ioport_read(uint8_t addr, uint32_t value) "[0x%" PRIx8 "] -> 0x%" PRIx32
+pit_ioport_write(uint8_t addr, uint32_t value) "[0x%" PRIx8 "] <- 0x%" PRIx32
+
 # imx_gpt.c
 imx_gpt_set_freq(uint32_t clksrc, uint32_t freq) "Setting clksrc %u to %u Hz"
 imx_gpt_read(const char *name, uint64_t value) "%s -> 0x%08" PRIx64
-- 
2.51.1.dirty


