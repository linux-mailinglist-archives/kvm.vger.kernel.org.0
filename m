Return-Path: <kvm+bounces-59059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E034BAB49F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5ED3F1923054
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 729F7248F7F;
	Tue, 30 Sep 2025 04:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i+MNz9LP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88DC38DE1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205624; cv=none; b=AlEdFkjP89+voHz9Nyp89MSRMyx/qTD7VIDPveLfVS42UdzqPQhuwEmMXnjW5eb/ou5QsuQoSb83ADHbOuCBFvx76kWsgNDTMUcoNGdTAxoAJNcaAY/ToGnLxUxe1Q9V3GN8uDPwlpjCVcIJ8PVVEjUaRB7eyfI/pR0/8v8dIuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205624; c=relaxed/simple;
	bh=KcoSwAGss2/zYyUK7zhtYnCCm4At/o3+++dZiXTE6i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IOz3EKVzSEx/6YysTN2Qm8mJxVrdj/yWWZB3VoKVmfn9HN2xd5M2cy29BwdDeMFzJxctucUV38Ce9ZUce3ubmr0sYHso7Yyucc8B4j0l7bCEUxw4jQgYN/Or3IQ9+GJUIAv6JLaRmqvOGx3o08xeRciuVmbg437+NyXdTIUJIag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i+MNz9LP; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-46e3ea0445fso20597475e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205621; x=1759810421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJyVnOWNCddCGl/+ypfUNoAsZWxoJ+Iw1ZeRnG+UY2M=;
        b=i+MNz9LP5rCwDNtjXL6+tSyKl9Q2B8vhkd/I9aNOqjO2+KWhB5908ujkREPHuv08c2
         pb7s1GCIT0CEXVuFhCbUiH2YlWGrBP4w99qS627vPaGAevT6VVn6ybszoGLwiutQJjtZ
         Yl+3QEpGRG4lW+K5QM4gIkCibELZ110z/OT5OtWsTZ3mqTItP0T8Aa4Dd99eBAlGXTw6
         xoY/9C7iCgt/vc3yoUiZqBV6D6/EyhyL76QPp6QLoax1q8YJWEwsNeQjQSf8Ui9BPuqo
         R5rAv7eIO/FlBH6ucvFPdWqWwA3EyFnpJr2zwKP5NJ3WMJ5tsgdISutFUQ6TA8U9lbi1
         hEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205621; x=1759810421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tJyVnOWNCddCGl/+ypfUNoAsZWxoJ+Iw1ZeRnG+UY2M=;
        b=gEY6Jj/r+LMbDOkEww58g+GUZW/5xWwLsCrymeHDcFBBsVO9kTXrtujY34vZD+1WJV
         S1GMbNnoMu2O5tN50iFLj+4xHBYM3iker+9KQTZfioN+l9beBiDJ/6n0cwJv7qxWIYh5
         InmHcQdwJjSjjH7oGvMuiF2AwA2XjiwzdZo7ifaOBoXL+p3eLfQ4/ra63VMhsI6RqQUE
         sMNf9vR5XwjT41Rud2tmgrBlgAECU8om6Mekmoeb3TcSG/WEBKYoZ1STQ8qzBXgFxeQa
         vtg5pP35gfI+HvywwVPNjE0slaPn3p+bseYMlfLCBsw50VgkIxAYKqYLNrkbA6380TXY
         wHzA==
X-Forwarded-Encrypted: i=1; AJvYcCW+LD0kzzIhAVjaJAKT8FJwuS/kw0NlgfX8eEoe0OFgB4e4Vu0zf1ncYZpBYc3l0hwAfHo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSA5malo/eH6OskxKtROGVu8813VSt1y6Us7vPT8Hjc8aWT7Ac
	WPF9vGrW+tQqPyZNWU6LXvLm5kx/48sO+baXoA+FzZZ4AKQiYAGv31AhtdrgMOsUgv4=
X-Gm-Gg: ASbGncspnvhhZJ+oool0w5usgGN+DCSRzDYI9sUe/6qLqmWf7RSrJOtAlaOXILtwnlh
	ZHWgaNebtAREG6Yg4vsO2XzHWe9S/87K2bjMppvxWr85/COY5zqJx17NRF0Bb+yO2l8PTV/HjF3
	b1YDJKFDcvZJrRdfvEQU7LB+QInBr5dygoZ3qznn+/7c/A3QoRseBUyMdWVHwlkNYHr3kkGk3gI
	LJVdW1f+VFTPDJCcI5yMjD6TQkETckgZoDhbrJ2Ls1YtTN7mnOzDTc63Ixy+8oV/5HI+/RHHoEl
	Xf6v7WWYVtoLTQK+v6J7ZYZAX3Z6WWBser/lolEihEzUnFJE21uhrsOVEXW+Y+J8WLTBz+3fDS6
	zeHlfF3+khkoZRR6UhcftecNp9HNeEStBHMLwXbVdk6edY1bbhRGP859tYANsag3nToNwVZpK/D
	5K6OVshN0c/4f51YR7zavq
X-Google-Smtp-Source: AGHT+IEBLGmPjHaV6MityTIXBSpNltcXVYjuhb00aWpIbO25PxYLKS/w9T+ltaJf/K1UbWKlm67UDQ==
X-Received: by 2002:a05:600c:4ec6:b0:46c:7097:6363 with SMTP id 5b1f17b1804b1-46e329b441cmr166612445e9.13.1759205620914;
        Mon, 29 Sep 2025 21:13:40 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f3dbcfsm38006405e9.3.2025.09.29.21.13.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:13:39 -0700 (PDT)
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
Subject: [PATCH v2 02/17] system/memory: Better describe @plen argument of flatview_translate()
Date: Tue, 30 Sep 2025 06:13:10 +0200
Message-ID: <20250930041326.6448-3-philmd@linaro.org>
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

flatview_translate()'s @plen argument is output-only and can be NULL.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/memory.h | 5 +++--
 system/physmem.c        | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index aa85fc27a10..3e5bf3ef05e 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -2992,13 +2992,14 @@ IOMMUTLBEntry address_space_get_iotlb_entry(AddressSpace *as, hwaddr addr,
  * @addr: address within that address space
  * @xlat: pointer to address within the returned memory region section's
  * #MemoryRegion.
- * @len: pointer to length
+ * @plen_out: pointer to valid read/write length of the translated address.
+ *            It can be @NULL when we don't care about it.
  * @is_write: indicates the transfer direction
  * @attrs: memory attributes
  */
 MemoryRegion *flatview_translate(FlatView *fv,
                                  hwaddr addr, hwaddr *xlat,
-                                 hwaddr *len, bool is_write,
+                                 hwaddr *plen_out, bool is_write,
                                  MemTxAttrs attrs);
 
 static inline MemoryRegion *address_space_translate(AddressSpace *as,
diff --git a/system/physmem.c b/system/physmem.c
index 8a8be3a80e2..2d1697fce4c 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -566,7 +566,7 @@ iotlb_fail:
 
 /* Called from RCU critical section */
 MemoryRegion *flatview_translate(FlatView *fv, hwaddr addr, hwaddr *xlat,
-                                 hwaddr *plen, bool is_write,
+                                 hwaddr *plen_out, bool is_write,
                                  MemTxAttrs attrs)
 {
     MemoryRegion *mr;
@@ -574,13 +574,13 @@ MemoryRegion *flatview_translate(FlatView *fv, hwaddr addr, hwaddr *xlat,
     AddressSpace *as = NULL;
 
     /* This can be MMIO, so setup MMIO bit. */
-    section = flatview_do_translate(fv, addr, xlat, plen, NULL,
+    section = flatview_do_translate(fv, addr, xlat, plen_out, NULL,
                                     is_write, true, &as, attrs);
     mr = section.mr;
 
     if (xen_enabled() && memory_access_is_direct(mr, is_write, attrs)) {
         hwaddr page = ((addr & TARGET_PAGE_MASK) + TARGET_PAGE_SIZE) - addr;
-        *plen = MIN(page, *plen);
+        *plen_out = MIN(page, *plen_out);
     }
 
     return mr;
-- 
2.51.0


