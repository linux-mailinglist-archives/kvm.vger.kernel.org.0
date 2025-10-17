Return-Path: <kvm+bounces-60305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B011BE86A6
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:38:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C056A508D1C
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D2A346A1F;
	Fri, 17 Oct 2025 11:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DXA3SOhI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC953469E2
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 11:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700845; cv=none; b=sIhevVAPt3+/hMflGJcg2OlGJqaVLijZ8LKnPEE0KlskL57U6WVCNlaAf19imptt072eyt93oAKfGYzkINwc8WUar10JHV2YevOcmgTdXL7h7iFm5po0PPcHZpxVkzraX9X0frP7hFG4c+keZWN2NuhCNpoXC14IFYxiqsg0lLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700845; c=relaxed/simple;
	bh=IYKz6FzNw9Zm+ebVMpftVMfze2A0oxz+bYsYGv0M3ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZ0II4r5SPsiTCa+Lwu1oERiXLLrwvRxFwOkT/shtgeqioq9voqjdNYHC83aGrefYVN65mLITsHWZIJ7o65A/t4tge7RSe+IqizHDiff8ssvESNiTuLPEjD5OlKatTm4qDe+zm7SfwKZf/1pDiQlWziM4UbnSjHQJyGppg2bvvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DXA3SOhI; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46fc5e54cceso13674155e9.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 04:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760700842; x=1761305642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WqDslS9NKjHnUWYR3Oq3CSi9/FfiBOz9NHEnZxcZS80=;
        b=DXA3SOhIxLr41Yay+lDlYXXehzfQdMW4/rgiWfT/amNnq9rbjeR361JIHJ5GGD2qw5
         7LERTjIJbbXrtbBMVBjQ6rYX88Kx3PUvTqN100KUZ51Jxh0rKHVWWDP8phRcgYpA1+Qk
         LXrxl59uS5WKZZE0fNOz8kmx3UQSVjnv0CeHRs9ywgaimodDSv5esruiKEUBA+y1ldvi
         qhL6jA1gsOcMPeHvZeSjrKIFrh8e8q20bzlvYH7vgQ02aOXzUcwJ3RMvDBKUuuDyhbqZ
         EQl0s9p2F+NYRDxbKDH+p0kMgJ4Ly3HmV7CbyxVJ5oDSDWQVjWlPa6IZgmALFj3kSIk4
         /IdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760700842; x=1761305642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WqDslS9NKjHnUWYR3Oq3CSi9/FfiBOz9NHEnZxcZS80=;
        b=jy0e/yZv8KcIwp56XsL1eG3nj4FojgvwZW7MsFqOztCxl8+o+uyGLYDtVchVCisIh/
         EBEhOPy5nkd7jTCepzsLtSFp9DLDpC70RrDyWPKCD9e9xyKtju/46ObR7L3nlTpYRar4
         O7QBVKDUnQGs2YkWocAfO+ZmbhI9HpmIMyU7UEQoY4vZgq+L5q8xQUOvG0NhIivsZAjl
         14OB2vBpg2eRIv1/uFqeZtqo5yepcRzhYZ20w++155dO8fWQCdeSLkNV4kWm4izIngjY
         4YGQy4iGQrlbh+zqeKkg26Oojs/t3JxAtSbqSEF6i7anZ9g/91Dh+KsrMcKCbWy8XduC
         nDgw==
X-Forwarded-Encrypted: i=1; AJvYcCW66bqVC/ePd95wwDyarQrLFSY1j3A7reYHRvmtfgHf++N6XgQ+5+I9nLQAuo2mfm64EFs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzESS1jJt96rD3dADv9l2hcyVDq5VzFNVgBaCtfUse4u3r1PmLg
	oKZFqGRRTn22NLznGZ+0ruKbpBRhAjlsQqUqYbzRRY0x0fwFOHa4PigC
X-Gm-Gg: ASbGncuoY+s0Cm3/XBbyDd2stOM+4Uls6P/tdaLt4otS1wm85WG9Er81AUokT3/vX3h
	CTw7M+BA0PE9FuDFo8ccThCgxgs8SfKlVT23Ge9fIfb7xNHlfJZ/h2Kxg8LsubIE65aSKVVTVg8
	UlKNNni6cImfgNr+sWoBpiaUBAMBEp5Ss2zc3VfHUe2ASeS+iGfXiiatK8DZ50SFMo6XGarj4Zf
	H95PEWdKzT0fNSrYHNCKDsRzYpRaEY0P0xjy+FgBN0LCWxX3tIaGO3J6r26/XF76MTDvCc5uoGh
	wxDWSlTJpYe/yBMKbPX/38IsQcxv9igPrPi2zHWAUnIapC0kr+tSnqushYEzzNlI2eYfdSKXIWf
	A5fCL3VmjRIXtn8PO9lpZeWzzwPJ8p1xnF1IgvupZYDD/vVGNjWsvexO5CLq7ZNEYWzXa+hFm+B
	p6J0DSuNoRLcEj0nW+qXtFv0kExw5B+c2HuMhSEwEGNT0=
X-Google-Smtp-Source: AGHT+IGrPw3UQyxZPdqjtHKNkflxp1U5RB7MM83GtBJGNyQZGFtG1sySZZLtOmG38BC7IEhw+bsWbg==
X-Received: by 2002:a05:600c:820b:b0:46e:27fb:17f0 with SMTP id 5b1f17b1804b1-47117877244mr24190025e9.9.1760700842351;
        Fri, 17 Oct 2025 04:34:02 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711444c8adsm80395435e9.13.2025.10.17.04.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 04:34:01 -0700 (PDT)
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
Subject: [PATCH 5/8] hw/rtc/mc146818rtc: Assert correct usage of mc146818rtc_set_cmos_data()
Date: Fri, 17 Oct 2025 13:33:35 +0200
Message-ID: <20251017113338.7953-6-shentey@gmail.com>
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

The offset is never controlled by the guest, so any misuse constitutes a
programming error and shouldn't be silently ignored. Fix this by using assert().

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/rtc/mc146818rtc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/hw/rtc/mc146818rtc.c b/hw/rtc/mc146818rtc.c
index 5a89062b4c..8631386b9f 100644
--- a/hw/rtc/mc146818rtc.c
+++ b/hw/rtc/mc146818rtc.c
@@ -726,9 +726,8 @@ static uint64_t cmos_ioport_read(void *opaque, hwaddr addr,
 
 void mc146818rtc_set_cmos_data(MC146818RtcState *s, int addr, int val)
 {
-    if (addr >= 0 && addr < ARRAY_SIZE(s->cmos_data)) {
-        s->cmos_data[addr] = val;
-    }
+    assert(addr >= 0 && addr < ARRAY_SIZE(s->cmos_data));
+    s->cmos_data[addr] = val;
 }
 
 int mc146818rtc_get_cmos_data(MC146818RtcState *s, int addr)
-- 
2.51.1.dirty


