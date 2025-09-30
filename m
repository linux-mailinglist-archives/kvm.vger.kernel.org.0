Return-Path: <kvm+bounces-59116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66FAFBAC00D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:22:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EE571926711
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42FF2F39DD;
	Tue, 30 Sep 2025 08:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n8adn7Ba"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D39723BF9E
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220563; cv=none; b=blC7y7HEG7/+4/XbT8V5pLqQJ12FBlR+wRT0jvKhM+rD5kphGfuGifRkpaEaIlZ/wAh3NFFO19+6HLwzY26AAFRBhL0QPcE6xkstXJl7cCCk/BE+scul4frbQJJwEjg7OYT21OJ7U+fgn1pAerBLPgTBeSOTitBNW3kIOWV7Rwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220563; c=relaxed/simple;
	bh=cBk9rTdlZaeGtkIh1++S8TmCuoilFiDpVupramB5zDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o2biwI8DRm+WeFq7E1gKH50wiIQiQ/LP3gr/P+9PiaJOdyHq4jE1TAcklqkWvJ4zIHiNyp7f4ydKuUrn/+4surKuF60mim5iNJlB8io0kRoPXePzdVa/2WowdWmYZ84oRjL071uXSG/RLSX05Q9cJMpkjHByiM5ovJ+d0uJYn6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n8adn7Ba; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e542196c7so9677575e9.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220560; x=1759825360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U9bErLRqv9kjbdzs2kwz9FzL8C8SAPMQ12Esuz3D9Fo=;
        b=n8adn7Bag3C/Cq2nOwlBI3EPtWiutd5W9KrBnfHE2AumWiXX9UdGsK2RMOU9+0oTrX
         BHioqbmORo+CDIJGJGODkygjOb0i+eGmzXpqyvRFGX8py27f5NFKGMSrqJbPLaCy+ixg
         WBe368iD9VeY8kcVktUDPjfFjYSICLIq6PZE+nb4NoSPLp4bUG5bL/ofTmjXHLGEN1at
         2VLodlv9otwTNa9HAQNY6kHHQ87qB395ujkZBW9qTreMTXdUg25X9mFPFub2H9SY6p2S
         w16vXlw8Y0hlfRAB0usGlbNBAYoT5Xm+FSLKPax634Ed6cPXFjVow0rRzToa6p7gBaLU
         IrFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220560; x=1759825360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U9bErLRqv9kjbdzs2kwz9FzL8C8SAPMQ12Esuz3D9Fo=;
        b=IHZInXCk+BEMJ3PNE/sJBCSzUxK+2Ks68njYihNr8xxbZXPRprTybnneTCmtxXhw5W
         yDeZoptwUz5WD1a7xRI0WCTcWpimoNwND6l61aLJkp5fx6OtzlMaDcpZh+oi5ykgPQsc
         km88znlPYSMauhEiCdZY8uIEa8V1QcKBDQE+Zg5wxj9AWbmcSsJnV7L0DGzjpd2pCOOX
         oEuZrI8iMjrnAwDzx4melbJ2EsEDaRydGKC4sW5SKpQWuxkNvH7Dm5aPBzLb/ab9c1PJ
         Eo03z6M7Eck5vmR8CoChQ+2H8094RnB4VZdXHhoQ9omTChKLSHL2E/ahuMfcQ8Ub+2aw
         HVlA==
X-Forwarded-Encrypted: i=1; AJvYcCVcfxKo1ZyIEUxiyMNy8ltFrFy9BXbgDRlGF1zdIbmiUmferBRydMR87Hp6mG/eoaF88Zw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDNi15YVUxatSaeMfY2Q/RZbXjfpp4yWdWdyTFkwKKRniPgG1U
	kno25M5TPFDyLM3XljhEwSeN2Ovo2ozbzlYY1JKyOBAD6gPtjN3b9eeMVHy+w55zudI=
X-Gm-Gg: ASbGncvcB/PARLYcj3VTXWDclJnHc7XGma1ktftg44fmZiIN4/ECA3UejbAASBIkT/P
	WMVXkCaVORJEXTze74KZx2CvkIwp8Fki175AOFkg2gkvSlPy0G4oq74eR48EgG/vQ+Z/ZueVKzV
	9EIfxemfTw8ryREyzMB2MjbbHAYf8BqwhmIBj3hA4zP66sThOcNZQO5+pe4MUzF9KXjdrPW2JEw
	gGcNI0huvpY/hWIFB0toSGEbcowYeDNoqXZUc85ueQIAmCkK1vvk59VmNABNoMDa2GoqUVNAt7/
	SlTkPTM3t44RXjBwn2jNeu+ZSJCj/5QR/kHdIPvBVGeuOR3gWOtgDifG41BS4bbjQSnp2+oBmFl
	6+ezSrRnUmogOqdWeWMQRGvAPHceO25UpTPub6RRGBB40aR3opLmo8hJiEFIGC7ZCVU8tUgvDxo
	p4wMWKPg+4NrVF6p32YbdeOhZZ9VSkgcs=
X-Google-Smtp-Source: AGHT+IFKquQgcsAUg0Wckpi3Q1uVvpKK2LWW0oi9N9Q9t0bhLrHk1BTizML0eTatl5XEnZE1L5+HFQ==
X-Received: by 2002:a05:6000:40c7:b0:407:d776:4434 with SMTP id ffacd0b85a97d-4241227789emr2953961f8f.30.1759220560163;
        Tue, 30 Sep 2025 01:22:40 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab4897bsm257449245e9.17.2025.09.30.01.22.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:39 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paul Durrant <paul@xen.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 13/18] hw/xen/hvm: Inline cpu_physical_memory_rw() in rw_phys_req_item()
Date: Tue, 30 Sep 2025 10:21:20 +0200
Message-ID: <20250930082126.28618-14-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930082126.28618-1-philmd@linaro.org>
References: <20250930082126.28618-1-philmd@linaro.org>
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


