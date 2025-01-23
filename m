Return-Path: <kvm+bounces-36453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 888E5A1AD73
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:45:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6C4516958A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7038C1D5CDE;
	Thu, 23 Jan 2025 23:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l/TzvQku"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E251C1BDAB5
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675945; cv=none; b=eBGpKE1gQP1ZJfQ/uY9hPTnEj0JjZGWSN0PYtuD4PKUY+igrhRRe8X8jlkHPlnkvrstF2MME/ovZ/iscKVpL6KkRJ/N6a5cLQOKnrrwHUMFgTnA+KSoZEimI2TCIlEIS0s9wfGJfmDBZUMZQ7Jo9C4R+VizrsgUGcyIbmnH9ktw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675945; c=relaxed/simple;
	bh=lFRPiokM9eG16b+LAgFB90BHEa3TmvxS7By0aGgfwio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a6Rh+1r/J4baZzkq+2c1aWcg0neR6rDG2fbojx6LDQhyMeZ8/VQWQ2YvxY9zU+2aOz1tTzEdyFM2Y675FH2tJsf52B/owSrFPlnF2aLxuE0LTsKqfXtKOM1OdhFimCFlHgIsNzyDyXeGq9NU30z2+waJX1CfMZg3k8tXuI1y55k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l/TzvQku; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-385ddcfc97bso1317272f8f.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675942; x=1738280742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOf7cXhzVFnELwvvE/9oD0dVEdIwULgdsVx2rdQEX18=;
        b=l/TzvQkuA2D4s7NbfC7o+A1iGK+cM5S6rxT3yYt/VEo/FYGffhFyXwORUKeVWHrvte
         0jApKK43nMzy8OIJR0b4q2lBdvwm9ntoqKZeHk/u1wvvznobnPZG2QTqj66eCHiV1prn
         qQa/6KgT37QKjKLRRmpJ3tW/ww2ZcKPBUyvoVACvpbCtEuPDi4aDm2jQiYpAdivKw+Tl
         kF1wzCsMk0vNB0Ga0P4U0krN/OFtjo6j/xWerNBUU2fDiDVaOt5BNc1b6aJ+f1HrCxep
         5gq6MMRrpYW/ZJEQkrDgEOoCLZ1M8v6toIkLU8zLvutnEe8nPJSYzxCOKmQeYU4aACfX
         qnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675942; x=1738280742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GOf7cXhzVFnELwvvE/9oD0dVEdIwULgdsVx2rdQEX18=;
        b=t01qs/TA7V5QCY0HS/1OcA4WcBJm2pjxgfmkQ9QtliZzolWKSjkv+OLEpeA9LD5FYf
         cO9fKm3HNgweCkiJAmbRGX82uL5nNTxNPvPM1l1QTog8F0ev5soTP5DoB2SKs3BZ645c
         SnMhSLDffJJYAjywTLFlZyJaPzUw1TRLnAm1ZTnIzPN4vz3lyfxTq8q8EWG/x4h5Mw04
         RMK14SreUZRv7fmQ0OoZgBq2woGExqu/wd4ZQCyoS6qnvUr2FN4YiJOzei5fc8P+EmAC
         nCotLlxbrXwPWPKUqwuBQTVy0LHsFexjqm88a3F7d/NFfLyWpPxz6Js3Tm5X5G1gm66g
         Gaww==
X-Forwarded-Encrypted: i=1; AJvYcCVcTmrpEowCNsmgLmko84nwWs1etAzerc5puT5sYJPYAHWoICawX2Ekh4xpFvyRHhb+O6E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHHW+PSpRXhd8QqsMpG/SrPhH1yIB3upcu/XHTGbd3gHvirzzX
	FSCNf9I7+Z52/zi4hTGm/uA8KXdJRHKVQo1cPQQMqUCDpmMwaN5YkcbHbit1e1Y=
X-Gm-Gg: ASbGncvEAAq27QIgFegVAVhoHGRRyOrlhYK5kz9m+gXu4SGCqLMskaHPoCn/+e6GJ46
	p57BoZPlQtiOM7kuKum1sWcfJIZGBQimdvXjp7IZMAXvvHEu7himsQm5FoQsac3iRnR/CwlCdDP
	AMbf81LRE787oibY+boHeAJU1PT9ySZaOhiNyzdL5gAzx1QJhUlwedKzIDNdIcAthJbWpuB1L8o
	S7ouLlL1bS8SilCveg6YVkXIgltmUxeGlUYph8bMkrbsuoGgW1PopJVH/4EGA3hQKkmW1z9+3Yl
	K7V9lh+FMjJgNLjvXeuXrbD6cxQV8YQsDX4UET9LGFJTbXhIUE0naac=
X-Google-Smtp-Source: AGHT+IFFvdlRkBEFpuvRapz+0/bX2s0BjBYZ6M4itb1IiIpdMWapxxpC9ppUNuB95mK5m+Q7pE4GZw==
X-Received: by 2002:a5d:47c9:0:b0:385:fb56:5596 with SMTP id ffacd0b85a97d-38bf5663956mr20431872f8f.19.1737675942270;
        Thu, 23 Jan 2025 15:45:42 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bad87sm971133f8f.74.2025.01.23.15.45.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:45:40 -0800 (PST)
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
Subject: [PATCH 15/20] cpus: Fix style in cpu-target.c
Date: Fri, 24 Jan 2025 00:44:09 +0100
Message-ID: <20250123234415.59850-16-philmd@linaro.org>
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

Fix style on code we are going to modify.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 cpu-target.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/cpu-target.c b/cpu-target.c
index 6d8b7825746..a2999e7c3c0 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -47,12 +47,15 @@ static int cpu_common_post_load(void *opaque, int version_id)
 {
     CPUState *cpu = opaque;
 
-    /* 0x01 was CPU_INTERRUPT_EXIT. This line can be removed when the
-       version_id is increased. */
+    /*
+     * 0x01 was CPU_INTERRUPT_EXIT. This line can be removed when the
+     * version_id is increased.
+     */
     cpu->interrupt_request &= ~0x01;
     tlb_flush(cpu);
 
-    /* loadvm has just updated the content of RAM, bypassing the
+    /*
+     * loadvm has just updated the content of RAM, bypassing the
      * usual mechanisms that ensure we flush TBs for writes to
      * memory we've translated code from. So we must flush all TBs,
      * which will now be stale.
-- 
2.47.1


