Return-Path: <kvm+bounces-59035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 981DBBAA4FD
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 588F93A5EF5
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66E0323BF9F;
	Mon, 29 Sep 2025 18:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S11AqDBj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16F578F5D
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170829; cv=none; b=E/9gD1SFDEoU+v/y5fqlQ7w0C1Vw+k25dfhBuPoVxRYmtrLlh9tafPz9MrqzhNhfgneRmhvlN83oFYelIJzA3q0oHPm7ZXCHhEVcpc/0SwlUiyRgJmuiqO3qhxZ9C2+6I2OqV51TRZLD4J18EhUABXKmZmsrSToccoXAblvK0N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170829; c=relaxed/simple;
	bh=3N5VsEoSHGK+oSKDqOC7DWIHB3J2bGSWITImHmVNwiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SXV9Ek3HbHURNQ/W0WeV2CLIuk1SWNXyYWuArjAjYu4Gkdgumz0xqzZwTOpYfMv1Ra8l6arr3pGN1RWqaYwc6UUOQYy16DufHm0DTQgYQXKsXH42qz61Rnj6fJKCHXC67ZVlD6tghR+MYLp98StqBaJec59iVJBoimRJNXWZJoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S11AqDBj; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e384dfde0so51427205e9.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170826; x=1759775626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onCfEhinWarPReSMP2g+nvBYz1NYywUR3fuXcFIYVYM=;
        b=S11AqDBjL0vLFfpAbhQS9DhVI52wUTJqzUEkvjiwnVtcrQgGF/9CgMaGYmpo0oMGsN
         TVEFalj/kzG+TDOhe/yS6l9yF1MD+eo8E4UmMr06uADy57In5A1gsbyDMLNKH4kVnkqf
         xCUYm6XwcIMAYqi7/x5t298jXNMB2r+ZezhlERjbSCubVmk+cqhflyB5K/EfhFwEbYeR
         zwW9zFrSqMBHPR8k/xdVVeLQn4IwCwFa5amuF3f3Grl00P1Z2vR88sx+ctNhsgFyaEbF
         qRU8ZKsAt7BsJxCAqA5rY9vRNoAqB+GZE5olx0Ex/effxBk/3O5ytKEToDADE/JJ/dOM
         xvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170826; x=1759775626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=onCfEhinWarPReSMP2g+nvBYz1NYywUR3fuXcFIYVYM=;
        b=ER3moz8Lb24lmhbWWhDTx0AI6xZZR2ez97MKD81jhArTA+OfTs3ZNe87NGnaxIQOVU
         9CL+Xb4cwuPnHfH8cgLkNHistbRLt/I1nYFG3kXckYwiQwf7jroqlnNmUwhzBcGJZRGk
         5e+bZCsGR20awb1KFBu9pGeQ7zVgFb6T3h815jkg3RMAfY6mWbPvHpRHGnUfhL1uQEMk
         AM/LUxpnJvmvekFIhSQc9LDPoNKeROmbAoiPoxNgNgbS1mjO/WGKt1jQVGKvGOarDba5
         DUIZ8qSL6Uo7d3jhHjMakrXP1jJMinLTF36JW+nopHxaAnmHdQFHNMUKHew2/McIqjdN
         TivA==
X-Forwarded-Encrypted: i=1; AJvYcCUBwvGQnAqsmaK+HnvM518NVWkdCU40iNFN150GJFOJyo1wGfKjNuvcnJ7TNanZBYQ+pzk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp/RP6P9TaQOwuOx9Ja9q/Y78DilQa5JTGkkdudX0rFuOnH1zl
	5PzR+12Cd12PMdpYLYOB/OJkLSUek0twyqkjXZFetdSmMgweFNZtHWouhguQaNPZV6w=
X-Gm-Gg: ASbGncsPeo01AH9hRjXYnoI7qFS2HochvsKHfdoHQ4ewyut+zMIbVrDBlaYfuCszfNE
	16ef55hisqlzTYkzV/7iUuNtdv3mWbQfqYB2iix8bJLgX1T2LjtSlLu4BjCHmZxDpvmAVCOvAwD
	995yXO7cJMNmLRWIoFGyW1Yzbfkrmcd4JklKNvcUdpBuu1Tt6Zp9RWK2XyRDecgyIeyxbIxsIHm
	747F4KsmFw4QuPFAwOfdFKbvGQHa2xs9D9+k5eHAvS45N8Cd9v6o7Ba0jpW7PDYfF1/CdYTvDMa
	nLyWAV+IbCHLx4MSRdiLf5jG5FXwtgYSy6rUInHXU92NbpeX/oJ5Pt9lQd2RzWUM/c0gIYiNSLS
	xJ5KWfpfNRKVrj3BZkXpM4vRzqmVFxN8IX7eChPD5NhU9A0dh3AydxQozkEJ4av0fVLzGNtdJ
X-Google-Smtp-Source: AGHT+IGY3Rr3VyTE3S7oem5ZxfcOaYJ6i/vEMLPbvgnpiGprZwacrZ9bUpREdcpvLgXehTAMtkJc6Q==
X-Received: by 2002:a05:600c:348f:b0:46e:447d:858e with SMTP id 5b1f17b1804b1-46e447d8828mr94281545e9.28.1759170826202;
        Mon, 29 Sep 2025 11:33:46 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab48c28sm234491505e9.18.2025.09.29.11.33.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:45 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>,
	qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	kvm@vger.kernel.org,
	Eric Farman <farman@linux.ibm.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	xen-devel@lists.xenproject.org,
	Paul Durrant <paul@xen.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Anthony PERARD <anthony@xenproject.org>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 09/15] target/i386/kvm: Replace legacy cpu_physical_memory_rw() call
Date: Mon, 29 Sep 2025 20:32:48 +0200
Message-ID: <20250929183254.85478-10-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929183254.85478-1-philmd@linaro.org>
References: <20250929183254.85478-1-philmd@linaro.org>
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
 target/i386/kvm/xen-emu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index 284c5ef6f68..52de0198343 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -21,6 +21,7 @@
 #include "system/address-spaces.h"
 #include "xen-emu.h"
 #include "trace.h"
+#include "system/memory.h"
 #include "system/runstate.h"
 
 #include "hw/pci/msi.h"
@@ -75,6 +76,7 @@ static bool kvm_gva_to_gpa(CPUState *cs, uint64_t gva, uint64_t *gpa,
 static int kvm_gva_rw(CPUState *cs, uint64_t gva, void *_buf, size_t sz,
                       bool is_write)
 {
+    AddressSpace *as = cpu_addressspace(cs, MEMTXATTRS_UNSPECIFIED);
     uint8_t *buf = (uint8_t *)_buf;
     uint64_t gpa;
     size_t len;
@@ -87,7 +89,7 @@ static int kvm_gva_rw(CPUState *cs, uint64_t gva, void *_buf, size_t sz,
             len = sz;
         }
 
-        cpu_physical_memory_rw(gpa, buf, len, is_write);
+        address_space_rw(as, gpa, MEMTXATTRS_UNSPECIFIED, buf, len, is_write);
 
         buf += len;
         sz -= len;
-- 
2.51.0


