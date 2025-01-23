Return-Path: <kvm+bounces-36454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13913A1AD75
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5007A16708C
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829371D5144;
	Thu, 23 Jan 2025 23:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BJiu1REt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD5F1BDAB5
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675950; cv=none; b=T4yTpzJ2ULAU68GFAmQ475KfTOH+sGFa/Pe30cH2VZ0ghfWHp2rlpgNlA4iJ7ITZr2gVcBzQysszBuvP6SjBa3TkS57kZG9zQKISiaUXaz1rwLztu3uSNnFIyInFA1UrNUhauvk7GtkdPIVqlEtzqCIZ7b8bYAqQEsmnNw+cFIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675950; c=relaxed/simple;
	bh=ub6bjeSmWlmCdXRczEdgqvKy9WwyzTRj55xBtNaNX3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BscQeRgJ4TowNpPHfZrWf20V2JSjvPOd1CjmmvQCpTkVMf+pJsd6bEkCpTPbQE5khNJcsshR1RQkZlry/s/dY27XzIC5334OfBSoQHs0jQ/HnZu9sR2Ux0TntQ/Inych+LGrp0KGQTdltSmP7guC8iV82BZE1gH1OQYFOsXqoDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BJiu1REt; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4361f65ca01so15622185e9.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675947; x=1738280747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OmeiNXwxDOryj9Nk89BSf7ntmaAiV2ODrxL67LjT3oE=;
        b=BJiu1REtfthomaNMF9UoBdKWKV8RCjZWzw9586QzqntNHbmuyYAEBV34J/fF1iCBiU
         iW9tJ5odNj7CzroHRLaEv5cll5SfiEuEXzPTcaUhuzeGkSqY/5F7z88To2A0X2FjOmMY
         zjIQmo1UWOo2NpYC0XVAnvF50wpd06KyxXeHWoOTrIbIswFzHgRr8DElRBC4/VPD+z85
         IBVUfeGyrc50E4xMKFREqc6xV8Po5IJo6GKrXGXYK113QKKI4VsPt5wEkzqtOzf5ax0N
         ItPNy0PdBgMqnRPJSPlC8zGvPrfP7ejamXDPLb8eqOeFpvtPFlSLII0MhvzhDMlcBDt2
         n52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675947; x=1738280747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OmeiNXwxDOryj9Nk89BSf7ntmaAiV2ODrxL67LjT3oE=;
        b=qFF9U3Jw6su9SjRLmoCvpemPZvcVZuCXEwhg27puSbGHfPMbgwRzVUradg+epkS+C3
         fQ8TI3/oT6lofHU38PGYvgyYI08EKhD4Ea/LiLdhrOygu6TLcyCF4QTkxH8sgcyLTNOP
         ZyEhfp5WV8jV+c9T9W9pmM9Q6iv2LfeowD/d4Y2RQCLgVRaoYwrxjB1wRETNV6Ixxg1q
         SwDihfMCAEa4HzPaUNg/gDe2oHZ6wJ1FlzZyJPgTkYMXNb5bMFXcW1F3J6j6lNf4tJh9
         JQkvUBztnUdfD1A3gtHPiHNc5QOzWaIKMIjy0MumnEf4tpuwaADSnlKCQx7ltJe2mdXo
         8bjg==
X-Forwarded-Encrypted: i=1; AJvYcCU+jLA4Bd6VTiob6Han3R7Bpg0ELWd2gIYrI0r9J4MQZvjNRqvoDXxDHVA0k9kHePfIxQo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6Q/tH9bItHlJ90zdtsRLip0ke8+0lR6pB4hgThKoD617B5LYC
	HbYL5z/yLgBtfAmiCekgBKsOoSqs30gKj2ypbTUuI3couIyidbFVKI/b7SdhPOw=
X-Gm-Gg: ASbGncvauWmNEevVMSgone7U9bQr5OVkng2vt4b6Eg+skxARZ0Rw55ec8PcuIEO4F+f
	ohB6zKfJBAeFULXYeYoH26IPWGzspH0WS3iBWY9TBjiScZjEvxw+evuTYvP0EJnJLQljTysLxn4
	bMa6K5t8j2LhX+6uJagiGKTA3l12L7MrqFYZn+aYo28GzZ3kyvO0xBKDy9pR4L1/UB28Hvk9NtS
	pHXY8V5vQuKSqeqxNdUNW6X7ziCrIDtlMTGbV9rIqgQ93BcdBYfSDMpawISDaGViml8UIhDPX0p
	XS1JqA2LsoFcMOv0WaunXobBgTItXrYpLOR3R6gr51lunBiBDE9ZwIw=
X-Google-Smtp-Source: AGHT+IEFJ1SeJWoUW3YaXnTGBs2yrvL22hVEarb/siWyosLBI70zXEF7xcr/1TRnUm9/lQBURa7m3g==
X-Received: by 2002:a05:600c:1e18:b0:436:8a6f:b6db with SMTP id 5b1f17b1804b1-4389141c12emr225835175e9.22.1737675947213;
        Thu, 23 Jan 2025 15:45:47 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd47f355sm7138595e9.4.2025.01.23.15.45.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:45:46 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 16/20] cpus: Restrict cpu_common_post_load() code to TCG
Date: Fri, 24 Jan 2025 00:44:10 +0100
Message-ID: <20250123234415.59850-17-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

CPU_INTERRUPT_EXIT was removed in commit 3098dba01c7
("Use a dedicated function to request exit from execution
loop"), tlb_flush() and tb_flush() are related to TCG
accelerator.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 cpu-target.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/cpu-target.c b/cpu-target.c
index a2999e7c3c0..c05ef1ff096 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -45,22 +45,27 @@
 #ifndef CONFIG_USER_ONLY
 static int cpu_common_post_load(void *opaque, int version_id)
 {
-    CPUState *cpu = opaque;
+#ifdef CONFIG_TCG
+    if (tcg_enabled()) {
+        CPUState *cpu = opaque;
 
-    /*
-     * 0x01 was CPU_INTERRUPT_EXIT. This line can be removed when the
-     * version_id is increased.
-     */
-    cpu->interrupt_request &= ~0x01;
-    tlb_flush(cpu);
+        /*
+         * 0x01 was CPU_INTERRUPT_EXIT. This line can be removed when the
+         * version_id is increased.
+         */
+        cpu->interrupt_request &= ~0x01;
 
-    /*
-     * loadvm has just updated the content of RAM, bypassing the
-     * usual mechanisms that ensure we flush TBs for writes to
-     * memory we've translated code from. So we must flush all TBs,
-     * which will now be stale.
-     */
-    tb_flush(cpu);
+        tlb_flush(cpu);
+
+        /*
+         * loadvm has just updated the content of RAM, bypassing the
+         * usual mechanisms that ensure we flush TBs for writes to
+         * memory we've translated code from. So we must flush all TBs,
+         * which will now be stale.
+         */
+        tb_flush(cpu);
+    }
+#endif
 
     return 0;
 }
-- 
2.47.1


