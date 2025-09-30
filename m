Return-Path: <kvm+bounces-59067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B45BAB4CC
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96F877A50DE
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C8524BD1A;
	Tue, 30 Sep 2025 04:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zwr2+0B2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB96438DE1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205672; cv=none; b=oaZ5Qk/NjxOgRWKin5Dfuozsi4x7u6gNuUUXbQN/SMDCrkeuCNsJj5v5km6c+8PjI8e0S1XS7jz3I/NqCwkNs+/8i97K2t6FEtIVQCxzIxpP5OAPhnPx6q5dZ5CQH7Y1M3nBDsgsjTkS/udEaEXpX83IkBdBUxfbfn98ZhzNnno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205672; c=relaxed/simple;
	bh=Kd3qG8yteLnzqTqa5lNxN+xIix6uNUkVKZrS5PpxcpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RixSpJ7RDLhH35+YdL0RputTzaFU/idNNh1jEEIMvCx4zEKiBleY9+synyK2kYJEodjI/c/BacJ3RwdsJOxozGTaIFzstL+qKOuxkUe3Sk16R6saN2STxTYxV5CtciOe/IcSb0ka4548jKQ3LpCsHa+dqRWdVEhgG9TxqyatD2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Zwr2+0B2; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e37d6c21eso36009285e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205669; x=1759810469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbEYNZgIU6LqvkF49qge8kIj2C3i6K2S813tsyxbWwg=;
        b=Zwr2+0B2xK2BKw6PISUiDDndNJdEGPlc9iyyPkOyT5jnN2YgpEl+s94oWO/XYKAgJE
         GxUxr91RjB0O6lldHCkS4SZpobKgw1kODnkebpN6gooI+0s4uk/Vqm+d7XCGFM+CuKyu
         CLSq1eEjhIwVcjxOyhs4hXbqSbCkhIJAAE9ScrZUlfuvdr5paXGRtk7PFN496Unc8e3Z
         TzVG6Ts+bMtuO1feUG//YZxZERfbbQYhCajpyYudP+3p1slLzFx4L0xpbdO3VlhZ8V5v
         uYWiXHwE3KnS+DHAmzP9Uhvtj4PIC9/9kghAV4gh6O4SOIvpki05/FSzExrdSB25VuWC
         j73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205669; x=1759810469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DbEYNZgIU6LqvkF49qge8kIj2C3i6K2S813tsyxbWwg=;
        b=A7e8JQsMU831q/hY0Z/bTqEQ5ktPk0kNQIiKbY+KXoviRlpFtKtqkBeEopmfO3Vu5D
         M9wafIvQUpkA1pHjLe16qelzEYRDMyVt9D1YuURxETyPrqpGP0tI9b6lF96bi5w3UUbX
         nP3YYQMBMdO4gxVm8moKJ3a/DSep7lZ+lPIBIXyyR9bYnduwY/FTlGpHDhAvj6bYWwAY
         wHmrNTGH5fNSYfAIO6NdMB2Q3WfWMJaHZ/K/X9Vig4+RdoeW3PH11yGqD20zJ0xsg+n9
         B4L8ZYUZnXajghMyhal4ZCiNLy0ZfjeJxJfSThgrRy9TDB/WcO8Kl6WwoswQbmzrBldA
         12CQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+tXRq8hnxImpx5eAAqF/qiiXReU4bTSO4kMdnUz8D95bSZ1vRuDiMfzc5Um4KSZgp+rE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz2vyoLbElX+Wv7VAILIouwIQn5aTwqYdOuX1NH5qs1mZWFkle
	MwMj0/Jk8F1ImLs8VxqGgBkTweN1a/xTXoPZ4GCOYYOQ+p3m1A3Ol0pwNbmgnY4KYsE=
X-Gm-Gg: ASbGnctd3np8A6JMuM37hPcuhHsLnhW9PZTNsrUJujxLpjuA2DVouZtY5PfrtT+QVop
	dE6bt55TxYfM3LNaJbFoYdKbqDFXgW5QGqxmRacy6iXiPvXUmkOt0xitYgK9cTif6FNz1jVeTT6
	/yWnyE6Sx5KKhOuRt9xa9UnD2EK80iFTZCSM7q/drwAWJQ+Bx5HWF0WYMHC4UHGKAyrniw/Ain7
	aXPmFMpm58/1dNRfRW3bSfZu7nsezpyWmaZuW3oT9z2biJQSK3BLcmu2wCVlGDXJFMd38voXn5F
	KPTBCutssExILNy3uh+mox/lTlYoL/QYe/7cF+qExYHO1BUBwdCMw0ksb2XFpv5jouSB6u7tu0J
	WCX4h1X1oB1/G7Vvt/AEfOmi5JQm5n8tLAzhMtGCMc3+YHTDBkPjc8gFKRFAICqUYrpUrSXQu6N
	3/o6ksYT8x1SaELw8YGpJGa+3/YOD8bMI=
X-Google-Smtp-Source: AGHT+IGQV+zsO38iVKo0msrSbqnR/OPqPQnfcFKxd1s907Qhohb0/U7DrOdOWLv1d/ID8PieNnQk2g==
X-Received: by 2002:a05:600c:871a:b0:46e:477a:f3dd with SMTP id 5b1f17b1804b1-46e477af5c1mr75062075e9.36.1759205669015;
        Mon, 29 Sep 2025 21:14:29 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb89fb19fsm21119525f8f.21.2025.09.29.21.14.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:14:25 -0700 (PDT)
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
Subject: [PATCH v2 10/17] target/i386/whpx: Replace legacy cpu_physical_memory_rw() call
Date: Tue, 30 Sep 2025 06:13:18 +0200
Message-ID: <20250930041326.6448-11-philmd@linaro.org>
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

Get the vCPU address space and convert the legacy
cpu_physical_memory_rw() by address_space_rw().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/whpx/whpx-all.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 2a85168ed51..82ba177c4a5 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -788,8 +788,11 @@ static HRESULT CALLBACK whpx_emu_mmio_callback(
     void *ctx,
     WHV_EMULATOR_MEMORY_ACCESS_INFO *ma)
 {
-    cpu_physical_memory_rw(ma->GpaAddress, ma->Data, ma->AccessSize,
-                           ma->Direction);
+    CPUState *cpu = (CPUState *)ctx;
+    AddressSpace *as = cpu_addressspace(cs, MEMTXATTRS_UNSPECIFIED);
+
+    address_space_rw(as, ma->GpaAddress, MEMTXATTRS_UNSPECIFIED,
+                     ma->Data, ma->AccessSize, ma->Direction);
     return S_OK;
 }
 
-- 
2.51.0


