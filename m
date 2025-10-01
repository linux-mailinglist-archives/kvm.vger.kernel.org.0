Return-Path: <kvm+bounces-59358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D8675BB1699
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B63707AF6CE
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C0E2C08C8;
	Wed,  1 Oct 2025 17:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VpggiHlM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0958C2D29A9
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341375; cv=none; b=NWWmX3R5spsGAdOULDJiLAxmudTnnqs4istaUb9hcwwEQ1jv79HmWbrwuqfU7yFzN5V8wV/t0ah/id3t5OxCyZ2iuqv1tD9wxTlpUV4DyUfVfjJ/xK+FLZJgxmTXHx4fNJNeHNBmxH6dh/OwMfWZC2THzDmd0A7G5qjmAkNcOsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341375; c=relaxed/simple;
	bh=NK+CCTwv8jYjpoU8YmeWpiz1K2nO/hgDhj6DyPUEXWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9kcQ65E2VH3O6/PoDFguqyFQjnBW7d6trhYsvPwrLo01o47nIEP6/o9bJQLszU2nJv7A6/5gaq2jlwtGI6BlsRfd3zUv1uqtOdRetxp+owAKkAXxNo4NGkXIImSrj4JRSGGwu1tAgwZIsgqhb4p3TcBqmBRIsIJaYwhQT8SFbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VpggiHlM; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e48d6b95fso566625e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341372; x=1759946172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9xet65TEOOSdiYR/N0e1Kg4Di5ZGCrU0GtjpOB6lB8=;
        b=VpggiHlMruxW08SZWNXYbqkknNnQ4/VSW3MCzeOqS2c8sRRPWWdakKMgdornn+qOGR
         XbURdIQYjzwKFvVcrtG6XjMaPKTyb+xqve+bcCgcgIkEPsttwPwZzrxHkAUVLpwACwaz
         WsR2gCbLwsXno/AVt5NBYIX7pOSzFV2G4wXxSVioDuxd9yoE6KKJ2wLF1RQ3i688XLKW
         TC8880+w7QnpV2Rp9GzM9MoDXJ0qtBngXcls95reofBZyAFdobPLjH5YJslJXD70Hfmu
         JoMK45EM4gMMcazMFwYFK4z8zVNm2lGJjDgwwTyfH/f9392XF+5S28TEMBpQFrSsLDFQ
         tGwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341372; x=1759946172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9xet65TEOOSdiYR/N0e1Kg4Di5ZGCrU0GtjpOB6lB8=;
        b=ERrrqbDfwG4QxTk1cU09LJEjMC+QJoIf7EufvOVJfNZ7kC/mUlsyLmlmqiLKlDm0Rz
         gvR9wa88odpa7MZ7goQa9oxRaTkDNSMTghG6jEy4weB+pfh8F0fbU1kCs1Al/iqlYGeS
         9WcsryzjXNky91ZHxhZxSkweYD32QXHPY0vVBsWVJ8beAMb0YNSDXSQCHNa3+XE9rPfP
         LxXPOG0np8HnD9p85VukUJ6dYQY3upRvtWVD8MMKLP6fhVNHR66Ie47W/nf2pIXGc1np
         HJ80f2bhHHJPdYX/TkhoR4XdqpbBkdGfN+QM/NEwcBMIjE10HjdtL4Eyy1xPP+6O2NHH
         N5ww==
X-Forwarded-Encrypted: i=1; AJvYcCW+ppE641H0aJKJIQ3PAGQVmREzrLjdekrnwbffw9rn+6Wyvp6fFNrJnjWXaNpjWbnWmSs=@vger.kernel.org
X-Gm-Message-State: AOJu0YybXZ7lCO9CDBxmcT6bHueyhV9ssDNQvTVZyBpcCfqGX56T3Knq
	TNMnHzzR6MZFFCaTtML6ShB7Ji7Eg13ZFl4OCcuL9pbsuCGcZ36tQRtbDVo6hVrD9qY=
X-Gm-Gg: ASbGncsUAybYaTetewxwO5VmkMIhOZuQbWscKV1vxBninwULUMk0joSMcj3Fb6Ifd/Q
	l+QZp9417U0GVXxLdMXywSOavem5Nx3pbRSgfNU0vEZ4ARMHjGpNgX3xo+7OooWrKXgQHNx3Cqq
	9MhOsjvFZMmNgVW2f+gaVhnZ7ro5L5jdxerCxUSGmB/L7w8jnJXdpKfIbzBOPAMuqafahVBXXFY
	mIthV2cPxnWpf0//+fWmsRVbnuFkb7Wa1X9OZYARhuPfoOA21tX6FrGTh3jLSrK2IocJZWFePxo
	AF2W05hapiFPCHd4nmdDSFV5YUqlv13KLgvEX3ebiEVfl4cQ+K6R6Mk06QedhdQCpWwaUFsQMOM
	Kn0Y5rSwo9fASA36qEhHQX13oOK5/3zHveGudpODhoc1y55KnjVyNUA5MBvYUW4qbcQUnnEu0pU
	+HlE0wMZ3moZKUsJJXHzSpeB8SYQ==
X-Google-Smtp-Source: AGHT+IFtPw+XkDGCPtbOzTM8COU+87F0gw68e5y7gIRqG0MAwDKlBk+G4T/X6jf8Wu0bRkQQ3KANlQ==
X-Received: by 2002:a05:600c:4e48:b0:46e:36f9:c574 with SMTP id 5b1f17b1804b1-46e61269e21mr35695375e9.23.1759341372177;
        Wed, 01 Oct 2025 10:56:12 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a2a808sm49585535e9.21.2025.10.01.10.56.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:56:11 -0700 (PDT)
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
Subject: [PATCH v2 15/18] system/physmem: Reduce cpu_physical_memory_clear_dirty_range() scope
Date: Wed,  1 Oct 2025 19:54:44 +0200
Message-ID: <20251001175448.18933-16-philmd@linaro.org>
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

cpu_physical_memory_clear_dirty_range() is now only called within
system/physmem.c, by qemu_ram_resize(). Reduce its scope by making
it internal to this file. Since it doesn't involve any CPU, remove
the 'cpu_' prefix. As it operates on a range, rename @start as @addr.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 9 ---------
 system/physmem.c          | 9 ++++++++-
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 54b5f5ec167..cafd258580e 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -175,15 +175,6 @@ bool cpu_physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
                                             ram_addr_t start,
                                             ram_addr_t length);
 
-static inline void cpu_physical_memory_clear_dirty_range(ram_addr_t start,
-                                                         ram_addr_t length)
-{
-    cpu_physical_memory_test_and_clear_dirty(start, length, DIRTY_MEMORY_MIGRATION);
-    cpu_physical_memory_test_and_clear_dirty(start, length, DIRTY_MEMORY_VGA);
-    cpu_physical_memory_test_and_clear_dirty(start, length, DIRTY_MEMORY_CODE);
-}
-
-
 /* Called with RCU critical section */
 static inline
 uint64_t cpu_physical_memory_sync_dirty_bitmap(RAMBlock *rb,
diff --git a/system/physmem.c b/system/physmem.c
index 0daadc185de..ad9705c7726 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1139,6 +1139,13 @@ bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
     return dirty;
 }
 
+static void physical_memory_clear_dirty_range(ram_addr_t addr, ram_addr_t length)
+{
+    cpu_physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_MIGRATION);
+    cpu_physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_VGA);
+    cpu_physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_CODE);
+}
+
 DirtyBitmapSnapshot *cpu_physical_memory_snapshot_and_clear_dirty
     (MemoryRegion *mr, hwaddr offset, hwaddr length, unsigned client)
 {
@@ -2073,7 +2080,7 @@ int qemu_ram_resize(RAMBlock *block, ram_addr_t newsize, Error **errp)
         ram_block_notify_resize(block->host, oldsize, newsize);
     }
 
-    cpu_physical_memory_clear_dirty_range(block->offset, block->used_length);
+    physical_memory_clear_dirty_range(block->offset, block->used_length);
     block->used_length = newsize;
     cpu_physical_memory_set_dirty_range(block->offset, block->used_length,
                                         DIRTY_CLIENTS_ALL);
-- 
2.51.0


