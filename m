Return-Path: <kvm+bounces-59068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B028BAB4CF
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:14:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF21516828D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5137C24BBEE;
	Tue, 30 Sep 2025 04:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dQNOqzyu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35A22EB10
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205679; cv=none; b=oH85xgdL6SQNuYN70hg00dXnDj8Y6IndCrrqPWj/F8pyajGODny0w9f0hEwbTwu06VUtpESlGLV2PmCvpVYSCqFlWVqPcxNRDaOoCtMPYuc2ZBETDfFQxtiRzcjyGVvP58UPyTNJgFiSg5mqoylb9oiIC9/SUkcbMyTjO689qfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205679; c=relaxed/simple;
	bh=3N5VsEoSHGK+oSKDqOC7DWIHB3J2bGSWITImHmVNwiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLS+hX2eS35hck/93fKbyZYD3e7x78ggFJ10VPA5YYfSNxESF5+tjH51xKfF377H6GBWH4N3i8HdA6uyWY6RDEXI2041JQdr76M2ZtMZ1leL75IO6RY6ZOWgoVImKnLcwPyEaYbgdKLuyPQ33QOFdj4e2tAQbLmbTU5lB2EG6Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dQNOqzyu; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ee1221ceaaso4373508f8f.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205676; x=1759810476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onCfEhinWarPReSMP2g+nvBYz1NYywUR3fuXcFIYVYM=;
        b=dQNOqzyu+LInA5gysgb7TDC1qWncMsgqP/CsCVkwn14srz+USUZUhgpqoUN7LjcnjV
         ise2ygbfLVk3f4EHysnMXcXqpG7stIMFLoIq9ybzZho4G5QVt0BgLwtNmHB7JHgi8rLc
         5GQ9egghKDTA5+T4yw1VBuofg6XSqD984566fdhhhYCSAGpKthFEyaN6ASiz2f0VTe0J
         /DJqQr0n/SkxZ+QXE8z1x0a82+EhHJ6KSeQnEE6J6mNfTlMK5PQ39qFMhptrZsdQoUzI
         r3xJWZCij27GRFABtfVpjPeVF8bu3wa+cWlK6Xori8ZjW37I1eftkDKiw1B2jUF+EWFb
         CBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205676; x=1759810476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=onCfEhinWarPReSMP2g+nvBYz1NYywUR3fuXcFIYVYM=;
        b=BCiBvQCayElawl3Dgt2Eds9neglGQaYXysjbvG/vzsgW1FzHP08zzGVMGUWVnYkP8t
         ukcD9kwhHEix0NESmU7+KVgebRB0UZiHYpqIJJY882GKiBMCKgZgrIefXVw1IYA+gfGG
         5vEIZFOFOMA+4gZsvEMcrcM4wD0Q2b9Xu2SACdsevasXAGmpM7z7W2wtlABT7pVBw9G/
         b/QwC6W/O5j+IxXutu+aDd6ehjZR7zi2au9ucRin5Ug4VHboMgdlkJMI0yNkXxA+srIa
         DvsOmQUZPWAuQAoL0J3+jRa2+yv22gNVHJtVce796rmJKsAIwF0hRNjFladp7PwCuv76
         AVkg==
X-Forwarded-Encrypted: i=1; AJvYcCUbsvv+F7Mx/bf/zEbGxVqTq78+DR2bZ1BaCKzohIREHn6KahF4z4XmxkJ3K1snVkkWLQE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzhi1ie4HCM/48SUrGK1ei2+d5AJ2dorwx1PZuOKe/YzEFwuKLv
	Z3z/ktfHLsBnuzaTO31EMe5/KX7/lVh4bpRRxshwcBLi++1IrdGYL40Gr5svRZXkOmE=
X-Gm-Gg: ASbGncscy9tw6XBuI4kRU+KU/WGjP7J9IQ5l6wNnd9hd8p1+AsFhngQkgAtUlTFC7fX
	n5I6OL7rhaJJkjXuoZXJONOFLV+Q215/tp/+BigQ3vtPDTabAy9E4/tIqZjNZWaMx1lHiCLPnDd
	jzQtaJBgi4/xyOD/7IC/gXBRtfjiraUXfedxzwHFRuyKoi6ZsS1SUPGj95lGwEVeqGMLgV2IWmX
	moRj1hYrY5EaTJ4uotQykCamNmFMl1CT+dm0zjvhptg4edwnZ/AEyUkUcdnXRgS518ec6xkfZfa
	h5HLmOAasFVwB12TP9U/2KgAtKw+ZE4CUwNt6lnW0cc8tZpzjYj2sck1d+Jcl+0m8YJuXPko+0o
	zheVUXRXlbALJ/E26N/WmUCLbJvGyXUOrcAJcDL6t8ppTHzXgi7vHjax4zJPZ6llL5QZADUKpwp
	3fwmNfnF/EzV8J+PsJ0283aHCYHE9qaVlt2Ury4dGK5w==
X-Google-Smtp-Source: AGHT+IHXSt4CkpBPH+1BT7FZNZBNpbDyORtYFCRXPSlc1PSaGA5no80rsQKq3Agt1aNkmXQ30vgX3Q==
X-Received: by 2002:a05:6000:2689:b0:424:2158:c1a7 with SMTP id ffacd0b85a97d-4242158c3cbmr1203705f8f.34.1759205675919;
        Mon, 29 Sep 2025 21:14:35 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc72b0aeesm21288982f8f.49.2025.09.29.21.14.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:14:34 -0700 (PDT)
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
Subject: [PATCH v2 11/17] target/i386/kvm: Replace legacy cpu_physical_memory_rw() call
Date: Tue, 30 Sep 2025 06:13:19 +0200
Message-ID: <20250930041326.6448-12-philmd@linaro.org>
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


