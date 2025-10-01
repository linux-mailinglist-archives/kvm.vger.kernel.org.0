Return-Path: <kvm+bounces-59344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ABFDABB166F
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45889194333A
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F8728D8D9;
	Wed,  1 Oct 2025 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jmx1hpZn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BA834BA32
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341301; cv=none; b=T08D5YYlhiTmXf4eotMhw37B4DbgrKGPpnEm8sgdOQU9Bpz5pXMaJQ1wLUNp4San5SVz8WzYELwxyK3/nDylcxmlkQmaFHjfSzo5ULhCyIVsecc8mLDNG01d2/Pdf6KGsovexL6rQs5uGGKFN+jkuwavvq8Osu+9tjJGj3M2+hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341301; c=relaxed/simple;
	bh=+85KRDxkWTMo7h1lhAiuyS0oQkBgFpWnzGobOtCS40w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EYP5qVT0tJj8XISEI3D9wRJvOKqUFc0u2YTcgBoSzbEwJsyvn42mVIfGF0UT9vC3lrpXV8V2wVpDDP7F2TvY/Fn8ClMvBsrauL/sjC7bbWSFQ+HicvLzv42Kaju5MFhFTfcsx4KYv5vZAqnyeh1nqJOVioJP8WdErufxUQuYdtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jmx1hpZn; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e34bd8eb2so812765e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341298; x=1759946098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XkYjpkGwROToQk/2WbGPU7KxLpYxvDufJjy5PE3aYU=;
        b=Jmx1hpZn3s1dZDhACI5LGTKVdltjT6q8Y1BuFcJ4O1YYLH/FEB/0BsPb08lmfzkEJj
         lSeL6bDENsvKj97xULflFFcTCo4iw03GT0xGjvm8c28iOVfPfJMjCMX+O3aB6VPHxMUP
         n7NRVnOmzSHNQVHairiq4wU/el0PHt1bvZnYWiQvRRhBQft9l20bphTiR50b8/E96C0b
         Yi6pkyeRwORb1y2IVf30iZogLRzc+kXMpm6iY3dfq4wgjwYr4mAb8zKO03S7qQeRvq8Q
         9sukrRfKhiSowhea4DIiCdjeciFK9p7sFe1M9aWIEijPTbGgy8nKU2SUXq5Aw2iuMskl
         vOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341298; x=1759946098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XkYjpkGwROToQk/2WbGPU7KxLpYxvDufJjy5PE3aYU=;
        b=gJl8graJSTJ6yI2EKs3Kae+7QJ+HjBe3b+rAO8ZzqLe0MrjAYm32u9fLCBbfeoIIaf
         pAjLjbTqpkJRVqbURpxXZR/I/5/P1xZQ2Uoiq4Yf21l0UgAN1eKEAdMrPy/37xXLd/7m
         WuqrekkVBG7XrUrrvoARueIcxvDuEPVQ62T9dCVUyWG2F6t9HPs1yOApy3sCTZnD7wEb
         +Sw6Uach63ReKt1qDvseXKPuoOCqHgFvFVtFZdYR8hUm305TaaaTfL/cbwmfmluGR1g7
         QnKsL8t+3kiprbja+s2/sOUh3q0q2trB4OChw0hSqyqPT7pwKBCxobC/SAwenDG0Whsb
         mWcw==
X-Forwarded-Encrypted: i=1; AJvYcCU5s/2ahGIzzQ8EqfWtx6jjTU/hf07JLVBx4ayAMYmcFnA3+xMOovXDGCmPirA6h97bKYg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWitrvLFHmHCoeoxQBNeYRn5jPqPqF73R9sScsqIJs+KLgrpZq
	Irh0NOvth8UbXphc5SEZhjE1onGP2aTh/AS1B4pjHXcFvxVAlDCYoRkDTRkShbcWcMo=
X-Gm-Gg: ASbGncskcqe9Mh1t1/SgDeoUFeA7BqkOSVi0akzyvlHLlKpcLAZ7vkUnaryq4PyZGpj
	Xx1SPhzo3+g7VBpW59i8vIlZxZ0AuE1hYrdeGoD7i0ieyqtaVBIN6B9Yszz5zJ44dTCWpPDOPii
	CcQ+0DjnNdUjnjX2foAZdpS19CoBLjhxL5knRcP6aRI2t/Oij2KgOcaYPy72SQWm7lsZl5J+Fa5
	V3a0WKscz5cqP+Cbp1J3TWldh/pknaN4oq8lEcTEXWlFlrtIjzRaQshIHU+DIcmwfRUxYuqcaJt
	Z80ScROLzHfLCo8Kcyx6Rsf7I6Z8O5YKg54si1t4MduGXSPlhtWaoIpO+uYTLxkgB6LN3XQGPD8
	zoMIgcUfRTi4zcbcxAfY47vcAJde2AWpBbN2hQ3CzIgF36uGz3HSs0gbkkUBvWk5KAGAWyJBvfy
	ksJU01sXP3mOM7XiZPXP/wEXHOK6JSdiwL3M5K
X-Google-Smtp-Source: AGHT+IG+6A4w+oZ2nzHqr3/j+TRguh1ZpSriyILzNvAQJTaQHCMqI3mPsO36a1m6OS4BIGT2UtInzQ==
X-Received: by 2002:a05:600c:8b24:b0:45b:7a93:f108 with SMTP id 5b1f17b1804b1-46e6125cf2amr37605675e9.3.1759341296396;
        Wed, 01 Oct 2025 10:54:56 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e980dsm119278f8f.36.2025.10.01.10.54.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:54:55 -0700 (PDT)
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
Subject: [PATCH v2 01/18] system/ram_addr: Remove unnecessary 'exec/cpu-common.h' header
Date: Wed,  1 Oct 2025 19:54:30 +0200
Message-ID: <20251001175448.18933-2-philmd@linaro.org>
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

Nothing in "system/ram_addr.h" requires definitions from
"exec/cpu-common.h", remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 6b528338efc..f74a0ecee56 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -29,7 +29,6 @@
 #include "qemu/rcu.h"
 
 #include "exec/hwaddr.h"
-#include "exec/cpu-common.h"
 
 extern uint64_t total_dirty_pages;
 
-- 
2.51.0


