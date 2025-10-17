Return-Path: <kvm+bounces-60321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 664AABE91CF
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 276D1622540
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7841B393DDA;
	Fri, 17 Oct 2025 14:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WD4jHU5g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F8436CE17
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710373; cv=none; b=u/qlDVhSrQsWV0qPvB8siuVlQjMt0AD5zOQ6cArWWNySNH9FZO4eWzJsPw+uG3FJDG0eogGfodogjLfDTGg8RYPeEhKfvW4tn6aEU53ZTs0xEsQ1b2QAaPV9hm1tXK7JH5DT0qfDgFAHZzHtfyCTWgisQqhcs4mRalkiYqm3nSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710373; c=relaxed/simple;
	bh=IYKz6FzNw9Zm+ebVMpftVMfze2A0oxz+bYsYGv0M3ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGbGoWhxYNtKUHeqAz7e+NYKLBBQBihM1xm3qqUugaScOVvgRmjlYX6LDlJwr0boJ27ScahBp2C3guD8TVkdzRZYo1JRzN7hUF0IXI/iwYVZIRjzwoaBzLkPqEzVjUh74ikYn7kw4G31p78FGUY+vZrDXx8nsDcc2sR0fv4NAbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WD4jHU5g; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4710022571cso16790855e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710370; x=1761315170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WqDslS9NKjHnUWYR3Oq3CSi9/FfiBOz9NHEnZxcZS80=;
        b=WD4jHU5gGq1hMsqaEcMP8ttPLnpJauoJezTO1cGezURdcBNOIxV5v1YJUI1Wn+Do6l
         E4a9dNQl54wofEzTcE83Vi8k/PTHKM/z8isVMu/kuCNQFhIqAsy/I9Ch84En+uGLObX1
         apxE6V7s9m1ju/krrV7WJpeMnkNvNbEtEJkU4tlkIS87oFnY2cF1BmuIDDqOTcr4q1Ob
         un+GytTRH9TPON8sW4lvtwxgD3frBNYSznNInM5x2hnXbozAy4qWMWOfh5KbKQnNsPle
         bsVYJWQbNwG7+8J//7/tBkm4EGuAIMF5dCAfYeiL8o0bv7Zbk1ZAzIL14NYjygVO/LW1
         Ywqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710370; x=1761315170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WqDslS9NKjHnUWYR3Oq3CSi9/FfiBOz9NHEnZxcZS80=;
        b=MupmW3b9qrUS6CsDyzeJPTtTNEn29XEEhujACnqI1wyPvslJishGcCOKQ7QB3Lk3Fy
         Gi/1vMCUMJB78rQLi/k6gttviIZDRYhWmhwW8c8TtAStu6ZUxVuWESjAEiJxeQ8tOaZD
         6+NujfLvkn9twI3TC+ZuNaESc/zWQGKXM4jrEUNAdf8BeP8UoAYv1hFy0BEE8G49Ihaq
         TvklvLUB7xeWBor32ijtVncW55r23IVG1A9lF80Vsjcrs2pp2e9eM3AbI2gCTr5YsP4M
         d+TFuoFrqJMLO51tiRaudeZzNjWFnXHxKV1JxTb5Q1ZCDponrcnxkq+nYcL3e8PEWysC
         RNDQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2v54g9h9gQ/kgZcb+wWmt74IbAZWKSo6YZ0tQ2sThwEHdZFWThSKpkdN18pZH3DU0h2U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhecYXX0CVbpUpTEwyBjzCtgKuJ2WscZOkwErMbBJNaC90he7B
	VOKqTADrjqG8EOPXsAirrF+qhE9qOzHlcMw1eTPUMi5NPxuFMDKFQMA/
X-Gm-Gg: ASbGncuBJS4ER285D9UTjmYFJpVnN39MCyZLYt4naSRBXmJhqj783P08N9JWieCOJPe
	meVG2aaDTBl6fXJBG+WtEzr7CjE7dsxcEEtzscqKZyq2Sfn/ldcU3fk/VlZG9Syjg/a1ewOiw0D
	mey1VImYCVymHzPxFV1OkEUwgZIXlJWGwb4n5UwQFYOOfEzmM4eAUxrnY69yAvMk7y0ItGBCVlH
	SPveJK59B3mlPCcoipLficR7T/6cnRdzrcX28t7ky6fmjQ1+9UG3+zE7PNW+MJ9AXu2BtoWfhJE
	BSukV2puoxBsZ+jPXxhPzPBvcDpk64I6v5/G5ugH+b262/wRBFQjzqgQ96cB4GT3GFe8P9qjZf1
	5EhIb1sgFHeHnfNmNIs8nkaxcPc7cU7KtwWhlFF9YLSoePTv/dKA+FPfq4jZ5npxOqBB08cHm9j
	u0akP1IyL3GhhrS+srZDm6FUOrAdIGVzoE
X-Google-Smtp-Source: AGHT+IGYs584RAcS+bQviT9zSdPD1C3R1/CztDsteU1MEMn/nBmYwej5QPyS60IjXtCNMrEecg2MBA==
X-Received: by 2002:a05:600c:64cf:b0:46e:3b81:c3f9 with SMTP id 5b1f17b1804b1-471178a80f7mr25809605e9.17.1760710370235;
        Fri, 17 Oct 2025 07:12:50 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:49 -0700 (PDT)
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
Subject: [PATCH v2 05/11] hw/rtc/mc146818rtc: Assert correct usage of mc146818rtc_set_cmos_data()
Date: Fri, 17 Oct 2025 16:11:11 +0200
Message-ID: <20251017141117.105944-6-shentey@gmail.com>
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


