Return-Path: <kvm+bounces-63140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 82DB4C5ABB4
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DD78F4E4EE5
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FF120CCCA;
	Fri, 14 Nov 2025 00:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W71I72QR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0BF23B63C
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079206; cv=none; b=Bg2dR6wWq37g53t+DNHcPTfaGtt2R9rpr6xFlQmnvp8TTwmUd69JlJidR23dF8CG0boNQMJjnjDndakBi2Hjc1X3QIesR/m+o3txpuiaNNfv2Xn+XedKLNqXdzAR0ITS394wC6yGQ8u/ocBDToC2UNy4zbnrBHy4Oy6CXVOcBMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079206; c=relaxed/simple;
	bh=fNlC6CtcPy+hYt3fSdW59Y+0yyOezRwf0CVgZd3vtOo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nrZnezB11Afchwk89exsASlPESXWTXOv7w/UQyYEJDZ1Pf4Wrnr3x5UQHysACRhms3e8Aap3EIfexTDjNv+wczyGEPeDa/XRJOJcmYk9c9c6Kpt+/WWmLSsmlMK/APXGQCK1jLieBJrTZ3XoolmUPtKyzgo6WL6j1kDUZnM6Rd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W71I72QR; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b991765fb5so1583595b3a.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079205; x=1763684005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eZsg/w5cybgrdWIvF1XkfBoIk6bInOVbbMf0mRSJdpY=;
        b=W71I72QRJ35bAeHQe1vHnwNkPlBWjuzILrVAc4aUxcQOK2NWvUV2eKGuVxBRioRGwf
         EjWCseJPIXNdytU2cMIgM7CiqHL8dCDFE3Ujx193DeY2cJDfM24rz2KNr6inf5XqHUPf
         9uTsZ6K7pOIRe4PeqS3rqvmUbboBafpmnKZLysiIEdxwnfkmqZPTOkojn3JFtmrBCy/R
         2oPbUaJBo+gUjK6eCpfNQFFMHS/SOJLK357uC28Gik9SC0hHOwq9vhRKz//oTadEI7eE
         wLIygI5gu52XO9IvLsvXNvabDGgjEUnLte/ljIG56na6mxasOQV9VDyCLDSXyOr55kum
         Y/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079205; x=1763684005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eZsg/w5cybgrdWIvF1XkfBoIk6bInOVbbMf0mRSJdpY=;
        b=LE+82UBjtshQ170LdTWaiDja0tBEty6/J03h8cA6isPjKhtArVg+Vz8C9/Ej3NR55+
         tjznkFJrvBLjMRsyzwmhs/zh4dHBPc9y833sAZf1UhihFYTJFcnr28sQCYhj7rSUHSnw
         5vkcKYcMmUehoKrWRGwo/DWTnoub3xEgQghlEjWll+VfVVPppQ5DQYZRH+faXfmzzkLX
         mdXt5qnJFFt+Ex6FFspENyXbFYPlD/aJ6GU2wEbPBKXfuWx2Qi0wSXyPPpCtnoL0C4O8
         vWYinCYNvlrejKukS2Yxl5tL1RCspW4zg50kfnyBHTGfovRx0FoSunUN7t/fr8qIkah7
         BWzw==
X-Gm-Message-State: AOJu0Yw6zniQ9+057wD0y+tWh9RoCh7O20CBAo7+JQ4MXXsw7NYw+mrd
	xkiSc2HSLpT1NgdU/VDHzHLxmrGhPutVjcPHKvD/I2YZMkxx3kons0cCDWB/0kXh84r7DkEt1+n
	XpkTlhw==
X-Google-Smtp-Source: AGHT+IG1zPJrfOkxQys3uR24gztdlWtCJX9FW8YZ6O/b+92SNiDM9FHHXogoGhkEao5Keu7avC61Oal9vV8=
X-Received: from pgnd26.prod.google.com ([2002:a63:735a:0:b0:bc1:fbfc:ca1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9988:b0:350:6603:b595
 with SMTP id adf61e73a8af0-35b9ff84732mr1873831637.13.1763079204632; Thu, 13
 Nov 2025 16:13:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:55 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-15-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 14/17] x86: Avoid top-most page for vmalloc
 on x86-64
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Mathias Krause <minipli@grsecurity.net>

The x86-64 implementation if setup_mmu() doesn't initialize 'vfree_top'
and leaves it at its zero-value. This isn't wrong per se, however, it
leads to odd configurations when the first vmalloc/vmap page gets
allocated. It'll be the very last page in the virtual address space --
which is an interesting corner case -- but its boundary will probably
wrap. It does so, for CET's shadow stack, at least, which loads the
shadow stack pointer with the base address of the mapped page plus its
size, i.e. 0xffffffff_fffff000 + 4096, which wraps to 0x0.

The CPU seems to handle such configurations just fine. However, it feels
odd to set the shadow stack pointer to "NULL".

To avoid the wrapping, ignore the top most page by initializing
'vfree_top' to just one page below.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/vm.c |  2 ++
 x86/lam.c    | 10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 90f73fbb..27e7bb40 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -191,6 +191,8 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
         end_of_memory = (1ul << 32);  /* map mmio 1:1 */
 
     setup_mmu_range(cr3, 0, end_of_memory);
+    /* skip the last page for out-of-bound and wrap-around reasons */
+    init_alloc_vpage((void *)(~(PAGE_SIZE - 1)));
 #else
     setup_mmu_range(cr3, 0, (2ul << 30));
     setup_mmu_range(cr3, 3ul << 30, (1ul << 30));
diff --git a/x86/lam.c b/x86/lam.c
index 1af6c5fd..87efc5dd 100644
--- a/x86/lam.c
+++ b/x86/lam.c
@@ -197,11 +197,11 @@ static void test_lam_sup(void)
 	int vector;
 
 	/*
-	 * KUT initializes vfree_top to 0 for X86_64, and each virtual address
-	 * allocation decreases the size from vfree_top. It's guaranteed that
-	 * the return value of alloc_vpage() is considered as kernel mode
-	 * address and canonical since only a small amount of virtual address
-	 * range is allocated in this test.
+	 * KUT initializes vfree_top to -PAGE_SIZE for X86_64, and each virtual
+	 * address allocation decreases the size from vfree_top. It's
+	 * guaranteed that the return value of alloc_vpage() is considered as
+	 * kernel mode address and canonical since only a small amount of
+	 * virtual address range is allocated in this test.
 	 */
 	vaddr = alloc_vpage();
 	vaddr_mmio = alloc_vpage();
-- 
2.52.0.rc1.455.g30608eb744-goog


