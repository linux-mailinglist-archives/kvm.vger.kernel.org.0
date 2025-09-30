Return-Path: <kvm+bounces-59109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D71BBABFD7
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:22:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 246B33C59D5
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830422F39DA;
	Tue, 30 Sep 2025 08:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N7H9LCvX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F8E2BE037
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220524; cv=none; b=OLavU34cGV5WM1GvsICzdUPmHtVrku/+c1j1O8XX1R7Zc+9Dns4z+ip3arCyKHW5h0LVbSrMpzZ5hvCwMfIV0E3T7sgaJFhYrxEVd+LAI86zkkR6GZPuoiCv+PANuZ2VaUCE6eMFuxPhVqXh9HsNVftOAUO1XjDh77DijS0D1NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220524; c=relaxed/simple;
	bh=xHlKaNQiyK9SxMSHKfmIcMB5KHbHUCdLXW5JifU1J54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XdoUMQxnekIdGnSymJoOKaVRTXG9egHV4PlWy93ylHapAZmU1fI3y8PLNX9y2oSmZZSS3boU2Jq/22BLuZwBSvTmnbDNtGQGYZKMMnN11g8/OEsRfH40K18CxfVz7mmsDkk3OgjwXM108SRhzxmNU7XzdPAsNj1ruZWuJdQW1YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N7H9LCvX; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3f0134ccc0cso3831296f8f.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220521; x=1759825321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlQqoXg6at6m3NCWUmLz6YxBYJSCTlYqTL2bdBtbhz0=;
        b=N7H9LCvX2LAurqRO31dAMN2bx5gJUHBIWlDpybE/BkvkMfPZl5kZq/pKgOopAbMgiI
         pkzfOLx/jTx6U+WQnLl/qt+/HI/TUJa+jok0fhzzjU2ulCl/rF2i+U93Q47vk85nFgVO
         1C5uv2YE9RjtOxzf4OuyADrmP1Vv01RBcrS3oILwf0ipuHTEXhP9mu4W4vH7h1HX3OpC
         gnY2Oh8RSSKoDzBPPpDyQuNx4jKq2XzuLajTpEbwcc5cwmSWnwMao0Ge9T9lK6L2sD2D
         UPVYO5ChIdGOv48tGCig6L8QCfxQ5y1hMTOShnm45qRuwFUJArYrjObE6RmDr6n5n41e
         zYSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220521; x=1759825321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rlQqoXg6at6m3NCWUmLz6YxBYJSCTlYqTL2bdBtbhz0=;
        b=NzS0wQTtxOzni2JAeJLF4PjiKPCtuWsT/haR90rWQeT41yVrieynYX3LT438vG3xky
         bVFxRqI0z7foL65C653P3tLPOVEsVVFy1svtuLagFWs+8HfxSw+M2Xrsk9tzoEDhZ3YC
         PzAV05IR8okTWZRRiiLIuzAYmXOdkee8mgVawHtFQS7ne76cwVWjGor3C/P2H+dpWD7P
         y52gJlmAAEyNYMhyS6McftvTTRhYV8svMB5ZWpYyD4bh8HHt8z9nRGuTcPHiYrdsORce
         huRmPStFGYIOZplbKsCz4a869ARMSZRKN4Xcld1MegPff+CKB4xuzObimG7j1XqPljm9
         6IFw==
X-Forwarded-Encrypted: i=1; AJvYcCVVimFkdMVc/WDmrM7gHziNvgifqQk6DN9Q6AwCNwh2LHVOyQWeq5+pBCJ+7dRBgONAvTU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyB0gXhKWjJe5JlMNNF34J+mDZCreoNl7uybjOwqYATlgnVBF8w
	vuqS9Jm2Xo/ycKzmzBswwFB4TBbQo8+eyXT+aqDK/KcjspPvAodqdZw8J49dgD1E0xw=
X-Gm-Gg: ASbGncsI/58Q6FCijAwgNXQOiWDevXil8JKf5uY0QUV1uQkAga57EfM/bmbjCt5OXfs
	Lld7zww5KcWrMaBJbq05eDID6oIv+SClOPqCfu6/tCsdxplhW/7fzZmO3aje3kkd/BnyviAlU7R
	+ZcTiMYoNiqj3ClcO8OFgZsA9I5d08W6TOgxZGCW/NxVBLZfrz4p9ua7aN2DxRhgK7vLHcl4y70
	5oaL4+JiYQjWY6rxdetCYSx7wn5ovIk0R3g+n3AYUUmsT5ltAhE9+ih2IWRFonfoZUOwfNAtemh
	WdbTmixSkTGMd3QJ/lZxTVNoHw+ZJ8t0kLJONkjhm3hJtAsNflrFk7VJH8ZEMjvryf/SKMqnisO
	UAeNKKQKfmpJeE6EOpccU1Ya6n6ZT42XetHcgdz11QGMJ3ZQv/nDndoWMBMEhnxDa4k2fha+FPQ
	z5ppeqH9ncoG4awvSIiO/cVk8agkugAbY=
X-Google-Smtp-Source: AGHT+IGxp9mmy7B4YaVXtK8axEEppjEFlOJUhOlUxG1XXBFZ2PBviuJyAi3OzbI29QHLpWomSM6JGg==
X-Received: by 2002:a05:6000:22c2:b0:3e7:ff32:1ab with SMTP id ffacd0b85a97d-40e4b294f33mr14571301f8f.50.1759220521460;
        Tue, 30 Sep 2025 01:22:01 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fac4a5e41sm22972926f8f.0.2025.09.30.01.22.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:01 -0700 (PDT)
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
Subject: [PATCH v3 06/18] system/physmem: Remove cpu_physical_memory_is_io()
Date: Tue, 30 Sep 2025 10:21:13 +0200
Message-ID: <20250930082126.28618-7-philmd@linaro.org>
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

There are no more uses of the legacy cpu_physical_memory_is_io()
method. Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/exec/cpu-common.h | 2 --
 system/physmem.c          | 5 -----
 2 files changed, 7 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index e413d8b3079..a73463a7038 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -149,8 +149,6 @@ void *cpu_physical_memory_map(hwaddr addr,
 void cpu_physical_memory_unmap(void *buffer, hwaddr len,
                                bool is_write, hwaddr access_len);
 
-bool cpu_physical_memory_is_io(hwaddr phys_addr);
-
 /* Coalesced MMIO regions are areas where write operations can be reordered.
  * This usually implies that write operations are side-effect free.  This allows
  * batching which can make a major impact on performance when using
diff --git a/system/physmem.c b/system/physmem.c
index 84d7754ccab..dff8bd5bab7 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3764,11 +3764,6 @@ int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
     return 0;
 }
 
-bool cpu_physical_memory_is_io(hwaddr phys_addr)
-{
-    return address_space_is_io(&address_space_memory, phys_addr);
-}
-
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
 {
     RAMBlock *block;
-- 
2.51.0


