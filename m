Return-Path: <kvm+bounces-59381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3ECEBB26E7
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 05:28:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9821732126B
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 03:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C672417E0;
	Thu,  2 Oct 2025 03:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dzHVmaEx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C89A23D7D0
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 03:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759375705; cv=none; b=VCv/PDs43+McRW5h6HWVnAOmmuqrGmyRIjxU1ublaCdTPpj3DXMJn0Rd1ZX+5om9KFogQi11cjujKWaB6QB4pbQMMyRxyyCPf6YKu92H6Dpk+kIvcnwY4ja/l4xKMRpRs2JfpiITFe5psXuLrg7VpGRuafIdQvzjf1csAjR/BdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759375705; c=relaxed/simple;
	bh=WMaAVUhK9j/HAqz+uC9/gaKKhCrwb2ml/jw03TGRP30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jXysWpvMAkkYmDWg1ILgPNunyKHknQPdyL1QM50PbhYUUZjXArRz9p/c7Q/d0g7h3tQZphjtXs+HkafLCH1Xkv63/nwDFPAZNkanO+SH4yy43W9Vhg9FhcTEbE8tMUJZNbzFyteBqDgUE6Zowms2MuPNuqMzDNwur7C6delxwqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dzHVmaEx; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ecde0be34eso932166f8f.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 20:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759375701; x=1759980501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mRS6aeO4S0WFLqM+NL6GeJq2x0UMCG4AbesJD75r0bU=;
        b=dzHVmaExfluTM3VUEJvFO739ua6FAs/2oUQUpKS2VkSfWNPQCr2EaSlIPCUcV04+AK
         gyUpz7emB/9f9J81naJeMSp+xzrw0Vd8sk/2Ek2j2TZgF3cqVWcJWhF1OAUXeyygdu7q
         0RVLI9fd86o0I1V770akOGE11CJVhHy1Opj/gU92OEurroAwWVtbEao3vRRU6ILc8Tfe
         dooOsuaNU4KXfxBOzuUcQNC/d35qnMjOtgaA+otMX/hK2VuuMLNYtkmFDrBHvEjwiNp4
         rCy8FR3opYcsWreL8mWTr8jYOM5/eG4g/EUvJ8UnzOo/T/nPEGPkHdEgTPhkOqHAcYYc
         SRmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375701; x=1759980501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mRS6aeO4S0WFLqM+NL6GeJq2x0UMCG4AbesJD75r0bU=;
        b=SXPp+g0hZv/kbTEWeENOhFpX72l/rtcFj1RDLvKaa5s/+Bif5rIPNYUjVVtMhZI04+
         IBwlawtdRonoA7R7SddBQw88Kc4JGgORsmLPQqx/i4mzQ3IqEBMN8VpZBCAMb+z3HdVh
         0cUAnsXniS3E3GGPNHSnSIgDTtkjbugSlComX9S6WUUcYz2KHaefEgsUrHEVzfVoEqdL
         LN14emimzJS+gUkT2oqDvZavnVCm8232tBRQ13QW5b7gBn75bcXUjbfhh7D4m4ftMvFP
         i7LkXVehZLzDGiVmBUiRJX+IrOORu+NGvIRzf5NlMi8JlAsnKIisCCgnPpJM68GnFbv8
         JuDw==
X-Forwarded-Encrypted: i=1; AJvYcCXttWlxnQE6G/jkPQfz97RZsDiZxvtJ5QWZO7IPT+7+Jz6v5+N2QlXvHcGeVU8tw06wP7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywiwx7r22d97UQhmxFSLQ7MyFSRum7WAZ1Pr4srZ7MiYIXo9fMX
	/y4V5gdXbMLOmJlwM9Yp7SCQKHAGkL0GnO72vntcNOdhdg+dWTaFX7kwy/q8ez4vuWU=
X-Gm-Gg: ASbGncsSadxX2At6MoPdClLLH+ipfKw05vpEYDvqVXgLs9lnszHwLdq7UJFR5Vd1wx7
	K5BJwJnyv2GEOq0AiYjZVWW82AbvwLVZpEZiD1+2SmANbY7t2TklW6KFkr0Nfkpg0LDqPoYvBAO
	xFAHzjsOsuLBHB8TCacGtKw1euS5f6o/ItcgL97LL8Ta+LFzXYLmoMUI6dmQlhaxDXWVsWdiGmg
	DCEnL/Nzthr8T83ufXu8SFEGfV+S9GJYqKhuFQcNt0my7KYaKpomA9OMwANPKLcX2maRqDpiQty
	8g/boBl5b18WqgihkWDU83rGVbvyRiD9HMweixF/6xmvl/FmrlgVmEvXL0w7W9P1GOq9NhpW7Sv
	waw/UI7qYeSVlIvP3pRqck0Kps9RQ3ethe58ZqSiwxWJkZftDunp/OI9cf33XliaUD/7rUzyFfq
	j3RZKQgac8BymOypF2ODlxjv0jqM+zyg==
X-Google-Smtp-Source: AGHT+IH0OMPCx7J9hwHsXn61KTtqc/GiwpLPC8HsNzniJ9ciFldSBJGv3pbAqBv9Q1Sc3FuO6RziTQ==
X-Received: by 2002:a05:6000:250e:b0:410:9b07:483b with SMTP id ffacd0b85a97d-4255d2bb017mr971102f8f.15.1759375701355;
        Wed, 01 Oct 2025 20:28:21 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e9762sm1623186f8f.38.2025.10.01.20.28.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 20:28:19 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Subject: [PATCH v3 1/5] system/ramblock: Remove obsolete comment
Date: Thu,  2 Oct 2025 05:28:08 +0200
Message-ID: <20251002032812.26069-2-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002032812.26069-1-philmd@linaro.org>
References: <20251002032812.26069-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This comment was added almost 5 years ago in commit 41aa4e9fd84
("ram_addr: Split RAMBlock definition"). Clearly it got ignored:

  $ git grep -l system/ramblock.h
  hw/display/virtio-gpu-udmabuf.c
  hw/hyperv/hv-balloon.c
  hw/virtio/vhost-user.c
  migration/dirtyrate.c
  migration/file.c
  migration/multifd-nocomp.c
  migration/multifd-qatzip.c
  migration/multifd-qpl.c
  migration/multifd-uadk.c
  migration/multifd-zero-page.c
  migration/multifd-zlib.c
  migration/multifd-zstd.c
  migration/multifd.c
  migration/postcopy-ram.c
  system/ram-block-attributes.c
  target/i386/kvm/tdx.c
  tests/qtest/fuzz/generic_fuzz.c

At this point it seems saner to just remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ramblock.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 87e847e184a..8999206592d 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -11,11 +11,6 @@
  *
  */
 
-/*
- * This header is for use by exec.c and memory.c ONLY.  Do not include it.
- * The functions declared here will be removed soon.
- */
-
 #ifndef SYSTEM_RAMBLOCK_H
 #define SYSTEM_RAMBLOCK_H
 
-- 
2.51.0


