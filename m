Return-Path: <kvm+bounces-59114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF30BAC007
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A600419266DB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68EA52F3C2F;
	Tue, 30 Sep 2025 08:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m3sQtXZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8D5255F27
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220552; cv=none; b=adE7d/lKscKMIjGPyfeQzyC5+4VgK7yV7VHXaA2b89dBiV5AeyJQVtlBPhA910JRIm0u7lAsaYwDxC0LTJlcm4L6YumRfkbw0UOnvJW3sRNyJi6rjl7SPKLEyL8zJZQLd6ZOrKcVjH6nGqb2uuZTxiFYpl2JHrlURtN0fCHqaw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220552; c=relaxed/simple;
	bh=3N5VsEoSHGK+oSKDqOC7DWIHB3J2bGSWITImHmVNwiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TnsRcjnAaDDEbz+TCakbxpPMm7haewlZmdxuLuniRwcZ63ayDD8tsNbxWelHakRtp6EurUFBd41PBmiEX1FOpnOqtUpJBN/+fKmumfgwZH8UdG8vw2GGaBiEPdEFq9Bcxw6uC8cF329R4bMsfu0t1vr7xPjsTWdlZjXs1bQ54Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m3sQtXZ4; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-414f48bd785so3014677f8f.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220549; x=1759825349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onCfEhinWarPReSMP2g+nvBYz1NYywUR3fuXcFIYVYM=;
        b=m3sQtXZ4b7kD9aX6CjI5yVDMRpWPrDP/JAbPU62fHL6odaFTa9w0j4UvKUOdStBFKy
         rutI5UXZrOJACPggJQ7OQitW9F3xh5GNc0W370f3U5EK2z3Wb0lbHbnwulq2J4GJJEUC
         oZsAidNEdTuv04EliiGZBQ7kh1F3jJMVdXHTxS11s6V9aKo3l5mkEdC7ycvk0TsimoJm
         lnuoYV1IbWz6uJkLJeHp2oMECCLKEdXC9qP9rLCp9t2Y3UnWpxjuDm2gnSo8NN2r2qf+
         jgADdg6KZAELJRBVzrdRMnnuj3UVz/fUOKntaNuza0rz//lSNCQJhoiEqJKfvDYLdqxY
         a9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220549; x=1759825349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=onCfEhinWarPReSMP2g+nvBYz1NYywUR3fuXcFIYVYM=;
        b=Bzuvz2GK/zLvCu5sgCj6UrQGKF9+GtPq71Z0qTaoKJsPHrK46Rb2OpcpB0zjwXaIGN
         vE45JtXnFMf9tgLC9QiIXNVBkDkxn52f7DlrAOjCcNZHNP56NQNhBx1wOR2NMa3xDcMS
         Yk6IX3tWiNyJNRbzIRZa2bpm9H3mYnwX/AUrnL7NW2Y57uK+aMbRXM9nVVbxwmMvfmHU
         RlZzu1QiWiWRI0cSudFo6U2E22UjDcDFrnQtu8xE+qD/mBqqfGFgcykK6B9XlHhHFf7V
         EdZKDjf/yQAKdd5ARREAIwZkYXMFWiOHhJ+G4hR5qaXRHcyhIe1YlH55Ve0ZY+WwDD/K
         /bsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWip4+2tj8p6az1iamZPKnDelyWpiV1opwGDfFYC7FNInPYmVqZKxgPuEvW55DJtwFP8W8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyctyTs8+mYb2Dol2SSxhl5jETdToo3oMRxhyg/OD5P4iLfWOgf
	2zcyCW0+kyqyCVFJuw+umKAT/GgjkaeroRiJtGwf6fVO5wbYZDHaeIOBNPK50o1dEiU=
X-Gm-Gg: ASbGnctzJMBwRICmLoq+ieXAaaSOzUFqs7S96ucenwAy5DTn05DC4MwQVmvuwm9MRBZ
	6kBT9DCCZ7kI0hqELjDhR3Q7uWJ+sK+5dIdZ5O2iBLILn2VGPRjnWvMLoXwnpLmmVycyjyh0Opj
	vHeaJ3Z9sQ9G867sgkzxkppc+t1nLyPkmipKEKl9BJxmjYNBQbaRKimm21aneo+raqM6kmaFgox
	5P7BMYjmQS21MkmmkIPemayzhGLIq1xAGW/iHGm0SoxL5/2tha9W5aw9+uPfBlIGs9jyu7NqYfL
	8Bf5K2hjzcpOF4Bdn18diJFH7eptZpZa6DtM1yTC5C1TNCszTMoNwuGjEBtfEx3q6U5iZ6rvsdT
	TXlwXu0a3uJNnZrc7h3EKVA9xRUQtM14sbPoMf21UBDxQt8JMAHrdstyXoV/ctm16RCzTEvmme5
	YzJCwEV/B7R1yfuPR4hjk0umWPKmoMK4s=
X-Google-Smtp-Source: AGHT+IGEB7zt4QY7wj3rTZFjv9pmOMXqLorCZDEnNJaXiQGRhxTkEhGFSRSSrKDdM5xt6JNSxZxslA==
X-Received: by 2002:a05:6000:18a7:b0:3e9:d0a5:e436 with SMTP id ffacd0b85a97d-40e437371acmr19690967f8f.23.1759220549024;
        Tue, 30 Sep 2025 01:22:29 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e572683ccsm47008715e9.22.2025.09.30.01.22.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:28 -0700 (PDT)
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
Subject: [PATCH v3 11/18] target/i386/kvm: Replace legacy cpu_physical_memory_rw() call
Date: Tue, 30 Sep 2025 10:21:18 +0200
Message-ID: <20250930082126.28618-12-philmd@linaro.org>
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


