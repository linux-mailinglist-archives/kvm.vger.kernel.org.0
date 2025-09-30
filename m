Return-Path: <kvm+bounces-59070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D02ABAB4D5
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB7271625CA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E957D24BBF0;
	Tue, 30 Sep 2025 04:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fNS+izia"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626C1248878
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205690; cv=none; b=GC+1RghKmjHQ5Od+0DiaIRzE5fVTuN5XPY9v6SAAMPBR3xB4WJbaXz15o9zEC5yfOfhxBQ8FK3NT8K9dy1tIMHcnGDBfvMVrb/Rijz145H1UI14xG30mn9u87EqrUhdKjhAU2RJPJewIhERoBzLURXiUyHF//iHGK1unC718GnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205690; c=relaxed/simple;
	bh=cBk9rTdlZaeGtkIh1++S8TmCuoilFiDpVupramB5zDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kPU+0+fbq2vAJDuutj1LUpMOny+RnYLwO5q2yTJNYM5fGTrsCtTMI7QU3fWCO5kW9W5ApXc+iLqMi+gr3uzYN0kod+R0Ig8TWDyllAFJpOCF8TriCYFAA1Jf2BO4LcV2qNWROhEABLB1d9XCeLu95ga5CqJ0ZokHgbZt7YpWPQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fNS+izia; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e42deffa8so44946575e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205687; x=1759810487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U9bErLRqv9kjbdzs2kwz9FzL8C8SAPMQ12Esuz3D9Fo=;
        b=fNS+iziaaxTeEPFFXET/2AhZlQUD5np/RlKYKn4DrIi21iAIXG3L/10jpPDrtLCEou
         fo7d+rl2fpqu4tQ8MUZkt80cf1Q2Bk78WMjEo6kd07u2/lslXG6wj+WwfjCVF0NitsUx
         b+q8ZnephifBPzztfNO3gYxInglW4Bv/RLrsfY+2KEJDnYSbZgySDEDp43/W2fmLEzaV
         PMXvY6S3UoKjn8IR8zrDUAraa8Dzooj+YVRrhLZYevxyTzhNwindJp/osnE1Ns4epkXY
         U/1E0uQzAwFKmkdSB9k2sVUbMn9c7dNBCtAacqOoRgsVUHw9zvEoIpM90iQfa05Uc4ob
         CaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205687; x=1759810487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U9bErLRqv9kjbdzs2kwz9FzL8C8SAPMQ12Esuz3D9Fo=;
        b=WqRlSN2S48WPKj4lCvAX36BI7Nsu3brfaA6I383J4185jBir/jJ3DzILCuieF6q2yV
         HKF1XNFJGv7nhbiAqoY+ZyG2Owi1TYmm2yztsQnkGE5bir6vCTnzoFd2n7V18lxyaW73
         UQtvtme6DTOUDHclumyaj20CWYgpWbqgWBHstyhPmFNabcFhwla8PRmJMZuAS031gsS7
         qwtwm+rs8D/rbO41GyrbUwP+oP2qrwhAIVP5U5Oq+nGAlMI0Z8qsWAgXNSjXmnHTABmS
         WIYul/+NgzASrFYn5xCQauxITkNZ8nbPmTTnJvbSQUhJ/Yt36J9x1uEi/ueFcTUbMUcB
         5Aww==
X-Forwarded-Encrypted: i=1; AJvYcCWshHv4gPxg6HUdEYkbw1JazQHji8cpzOYxvNXCd1vlaBMOgBgcXISAG+8bSPPfQ2EoB88=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhEEd2FMeWA17Nn1hsxcYkmQi6B/KASYPy0S1lp+XMh1jmnWnW
	8wsrawZ+5XzNWEHPadp/bLBcD+nBZ0XCfp6ESdvWgLDXAA6dHZ4xaUxdnQyxX3BdMBU=
X-Gm-Gg: ASbGncvfh9YnjN0RReKu8feBW+54sN36eo5BROxswTU8+wnZtfRX6RSErZlw2DQJovH
	YiLGox+iUCl2A76g2qZ59W1qPWAojNylfUKZ3qkVjj09DvIi2Ky6ml9QTM865h+SXbMRsBkIjGD
	+7mPDnBn0QrnKp6y9u6ZPrm4uHfBJEwa+60dDDTvENPj32yHaVdo6T6eD4rPF9oHStzHIdtGmXF
	dkszHIQ89i7Jl1+CEpYIkoX0CZfSTipfdiRbcqvIbEubHX+HGiQVS8NB1DFWLuItzox3qS0LH6e
	M17oyG7DmNY/Zlp6cAa2KbGfAowb1C7AdLUQR+AUnbnNC8Q4KpkUqadNgctT8Zup7x7d7fBu6hX
	dKF9UBCmNnKS5jWDoAb6PkNgj0nk4jU9eL+Zbvq56MrDXaXbd1cLM439u/Md0w3JXz0n9Sj/ot7
	Z599zl7lpYsCgw01cYc/3G
X-Google-Smtp-Source: AGHT+IGyKmmQIMqQURGJv7gP62rq5JnP7SAE6q2ubqy946YRUlo5uVTz66eDWtBwE0h2GgBG2/uY2w==
X-Received: by 2002:a05:600c:4e43:b0:46e:3f6f:a8ee with SMTP id 5b1f17b1804b1-46e3f6faa76mr119745615e9.13.1759205686721;
        Mon, 29 Sep 2025 21:14:46 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9ac5basm284686015e9.7.2025.09.29.21.14.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:14:46 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	Eric Farman <farman@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 13/17] hw/xen/hvm: Inline cpu_physical_memory_rw() in rw_phys_req_item()
Date: Tue, 30 Sep 2025 06:13:21 +0200
Message-ID: <20250930041326.6448-14-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930041326.6448-1-philmd@linaro.org>
References: <20250930041326.6448-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

cpu_physical_memory_rw() is legacy, replace by address_space_rw().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/xen/xen-hvm-common.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/hw/xen/xen-hvm-common.c b/hw/xen/xen-hvm-common.c
index 78e0bc8f644..52e2cce397a 100644
--- a/hw/xen/xen-hvm-common.c
+++ b/hw/xen/xen-hvm-common.c
@@ -12,6 +12,7 @@
 #include "hw/xen/xen-bus.h"
 #include "hw/boards.h"
 #include "hw/xen/arch_hvm.h"
+#include "system/memory.h"
 #include "system/runstate.h"
 #include "system/system.h"
 #include "system/xen.h"
@@ -279,8 +280,8 @@ static void do_outp(uint32_t addr,
  * memory, as part of the implementation of an ioreq.
  *
  * Equivalent to
- *   cpu_physical_memory_rw(addr + (req->df ? -1 : +1) * req->size * i,
- *                          val, req->size, 0/1)
+ *   address_space_rw(as, addr + (req->df ? -1 : +1) * req->size * i,
+ *                    attrs, val, req->size, 0/1)
  * except without the integer overflow problems.
  */
 static void rw_phys_req_item(hwaddr addr,
@@ -295,7 +296,8 @@ static void rw_phys_req_item(hwaddr addr,
     } else {
         addr += offset;
     }
-    cpu_physical_memory_rw(addr, val, req->size, rw);
+    address_space_rw(&address_space_memory, addr, MEMTXATTRS_UNSPECIFIED,
+                     val, req->size, rw);
 }
 
 static inline void read_phys_req_item(hwaddr addr,
-- 
2.51.0


