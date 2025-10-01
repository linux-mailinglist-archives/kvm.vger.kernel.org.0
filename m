Return-Path: <kvm+bounces-59355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80CA1BB168E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8464D7A7A43
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A982D3A86;
	Wed,  1 Oct 2025 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Egab2SJL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20DB34BA32
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341359; cv=none; b=j7OGrLX63RSjWzKhhccFteUf7oB8XyXW6KxEJCWWNeJfSS9D9N62fvOtaemAgaEDIFQLB7veovw/DuqXca79RUuRUsxlcORQBcGn/37/pz+kmq89/fGWL9gsx73kKwwRqBdS0je4tVBqOzOavtv4dv88PD7AYUfBAkYDasB0p1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341359; c=relaxed/simple;
	bh=Qatu1azn45R2J9DGx+ifditeo1tX6DabAIUZW40ONHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uh0r7vMZZSa1h7CDsMh2/6viMrsaOMwLXdNeMgo8nL/i/yp5PeCbFxgbgQ1f3n5bdHLbbxV+RRgfEUyfxf4oX8wpe009GNoUmCy/03RRlyqT0eubBAZDoBtxXAG+n5maKuXYHjuh+MRTYd1HTVLlnsOKyzYTlO43bKISolylhxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Egab2SJL; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e384dfde0so915005e9.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341356; x=1759946156; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlChLU8Sv66u34cuVfj2m981SsQ1riJ99O+cWJLK7Og=;
        b=Egab2SJLKh0OLFm2r/qG9EuFbfRMvffnUw5e6g36l4+CAmZqfnPuMnNXxGmVepz9oW
         ItnJeQzqSlwBgk+N/ddlkval4B+hF+1PLSsXPRRC6Zx+wuSN5Kvw8WXgBa0gAgG0O3vx
         4DwcQ5TY11+Dj6hWEuiFqOWDYZoKprTxLjLSPydDsqKzxUg3DKnZSzxl/h3dN9q6hKst
         eRyVkaJYVRzgb7gypzkVL2fZGj13SKizTDBusTCZxOW4AKR0FtTbL8UYQugm/9I676mq
         sJueXbsm+yYPq4gtg/6r+VjzugihaZSbCgDfnu1EJoYcoum8XHdKvVZk1G43hlDvS+0P
         KUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341356; x=1759946156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DlChLU8Sv66u34cuVfj2m981SsQ1riJ99O+cWJLK7Og=;
        b=ki5BPVowxWb6ZYHB45iGxZnG08RXidclkC8euVQ9ryVDb46YwHhVPq2UzMltnaVT5B
         TGfQphV5rnZN3unWUHJZLsa9XfjAYudLo3T2KQCKZW+DArwq5N05zhy2onkNq8POi0Ka
         rL6+sN3VQAzJcLZljWE8Qq7Jg5PuVLTIfWVRC0UB8Iv4kFR36M9WAwV/YrFDli0Kuln1
         dl9gPGmOcDslEIvwWUCepeKXVYo6hVewMFv4Mh1NwqNRE82isZZtxepuxBBUjeGhn9lL
         gT1vu+u7eCxG8+qrPssbub1JRXWC8QDkhPnQ0owLfJrzBQEUsd8JhnbeCEm8er3qa0rP
         jHnA==
X-Forwarded-Encrypted: i=1; AJvYcCWzeCfqwoQjLHByylBMIdde8lJYy1qUyJoOgYMhrgE2LAFm1O2Qb+PZJqSMOD7VRYUBDL0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHqVFCl97eSNvhFHyUCmJIBGMCCFJnLnCP24rpoVEpV+Tukr0W
	XKit4sseVuMUEs7s5wV5g0EyInavW+2ZBVAHIR7KJiTXL/CSzlNVoHxLtAjGSaVYU+k=
X-Gm-Gg: ASbGncto2qgvkxokESA31f+Djiw2+RfUSrs5layzVLb5MAcvL/RvBw931xl6UIsER+Z
	uj7b8l7hXnANw+kUMVeblS0y9vBQxr1RPlqTrxvQPObrvu3mQYh3dqn/yBr9S3DkTvBccHCoJ3q
	MqToDWLhM2ONFx8ogZdfDkSoR61xeKh/8NMnEvn6X92FL67nfbWZkG3SsDQ2r+CfLCicWgjvO8A
	gPbXqXrFhBU/8lzil0KpelXUOYljYRFerWVU+1gVzVX03xABbAlmx7CEMM+0jHSkSTfLY4jkiDs
	43TwalxtJsQ3NRN7Xaf8ZZAOxoNq6gAUY3olQ4YdR18F/a33Le11nlEkbrPKAwXgukW96qo3z1L
	b6981DABBQ8omGZ3yd3PKUkGBzSH2Q1pHAToYyaWNkqsrE6EbOa/ugwN6Efrh6KQyQBmK8tK1eX
	Kypx+d6mgf+vaQO2h9gciHe6JqyA==
X-Google-Smtp-Source: AGHT+IHfeO7OH/QdtcggUnA5uGklDQpIabKZxQPr/EBAMEwVNTVFueen9PGLslG1prHgPOf0O5ib5g==
X-Received: by 2002:a05:6000:288b:b0:3e0:e23f:c6d9 with SMTP id ffacd0b85a97d-425577f3550mr2999587f8f.17.1759341355760;
        Wed, 01 Oct 2025 10:55:55 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6e1bsm144312f8f.8.2025.10.01.10.55.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:55 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	qemu-ppc@nongnu.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Eric Farman <farman@linux.ibm.com>,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 12/18] system/physmem: Remove _WIN32 #ifdef'ry
Date: Wed,  1 Oct 2025 19:54:41 +0200
Message-ID: <20251001175448.18933-13-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001175448.18933-1-philmd@linaro.org>
References: <20251001175448.18933-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit fb3ecb7ea40 ("exec: Exclude non portable function for
MinGW") guarded cpu_physical_memory_set_dirty_lebitmap() within
_WIN32 #ifdef'ry because of the non-portable ffsl() call, which
was later replaced for the same reason by commit 7224f66ec3c
("exec: replace ffsl with ctzl"); we don't need that anymore.

Reported-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index ca5ae842442..fbf57a05b2a 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -155,8 +155,6 @@ void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
 void cpu_physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
                                          uint8_t mask);
 
-#if !defined(_WIN32)
-
 /*
  * Contrary to cpu_physical_memory_sync_dirty_bitmap() this function returns
  * the number of dirty pages in @bitmap passed as argument. On the other hand,
@@ -265,7 +263,6 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
 
     return num_dirty;
 }
-#endif /* not _WIN32 */
 
 static inline void cpu_physical_memory_dirty_bits_cleared(ram_addr_t start,
                                                           ram_addr_t length)
-- 
2.51.0


