Return-Path: <kvm+bounces-50105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9291DAE1EDA
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:39:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08CB87A9C07
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3A92D5427;
	Fri, 20 Jun 2025 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="fLVQLtGK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA922C08A2
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433961; cv=none; b=BNQppkpM1fYVozWg8UIU6mirQsFJMstdisgPVcqcaW3ZomMJpmuLt4+SdC1XYTvorkHlR/aC+7stq06Z6AZgmKqj3jGa65rfZimm7gR7C+V7yDgz1n2x9kJUL6tTbP7qkSXtn+fvkTT23PraLdjTKiW8M/l5kj7jrUydztC7GkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433961; c=relaxed/simple;
	bh=lb4Ai4mwIXWVsTDy2T+zv2AT2zsq8YEoi8VX0Sf8oqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XW55Z/gLMS2kaooKSQEXys4MaXqm8Gz3xOU75uVm+BmAOMZUWgKpqLImIc6HSbatkrCcoCaJxxyOl2KMKkJFvphPBakmdiQ4hX9MEuhOJlzwEawwT9meIHcv584Zc+zzeJxZqTHxgpJdZ6tuLttaYH3kKhhaal2GFvojl+HO5Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=fLVQLtGK; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a588da60dfso1316551f8f.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750433957; x=1751038757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UY1AAqvD9XPBDiv6gdW9Kf4gi/kXtLrT3mcqePIZJK4=;
        b=fLVQLtGKU/+qHKV2SLIY4cecEm0rjoLO+Bh172yVZFPX8urwyn2957rGxdZ4g/ZyrG
         MCllgasE3S8OiJjywTxBy83kSQ3Bph8p4HGOK880adcYg+UfAdYMnJlxwRMr0qngn3qI
         wUKRLTDYxEt/ltt8dsnF/02uw0PDcqJvLRAu0DFagXs4d4OHJsJWHi7XfwPnxv91AS3D
         LfMgtYiJXzsV1AXX0QakfJqsPZQ2gkE+k8XkxkW3MOZCxxKfkGUT7eFTJX3oaRiJfa5M
         cQoBiYi/0st99AN4w1gLgBoc+AU9nMCIZp5e4FwXKryj+l6q/X4cwHHn1NnsMHgF+YKm
         owuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750433957; x=1751038757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UY1AAqvD9XPBDiv6gdW9Kf4gi/kXtLrT3mcqePIZJK4=;
        b=CNjF6mn8HQ6rQ8wr5EK+sDfuOX800Z1xibfy6I6bq4Pt6bYOPyZHL2bFL+UcJrGGrZ
         HF+wQu+q1nqnR6LGSC7O+YSkyDkmGSeIa9vcFWttVcu2PP++P/TfienPiTg65+ggzIVX
         Lxkk7B/Vl3JTi/zVUuRsw1cRzKyj+NRqx5qBCByDL0mJ4xH1+9DVJCw9Bmv+WO31NCh1
         bOnXV2v9m85a8+xeKgeQJeVUB7G2kByI/VtmayToIFJOhqAHoRURIiQAO0jZ+Ar/xlUq
         a42zi7RVpjcRGxYi+c1zOHPF8TL1O0X+o6d/XSoUYC587PmmIo83gzoy1cJo2tseQdm9
         Rygg==
X-Forwarded-Encrypted: i=1; AJvYcCWofzquD4FqdbRLJi5JQMEybCpvjUxBWIJPC7rDU5183bKUx4ta+7t95godHxvn0C1YF4U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2GfeXaxsniUlpWGZRSCNOCmPpNUcVQN1VSZqXCB86EVjsrU44
	hIs3+1j6sT2+WUTiD+QBn4Zm0/l3moSb9A886OPgJPlsQE7g1IGp4FJCKIcQpU9lU2VA6cDFDp5
	7QOCb
X-Gm-Gg: ASbGncsTXTapDXk7bO8Ci2nK+DbdDiLEdYU79mCxkpX22IFdfrBtOcaqOFbeuDw4/D2
	3UMZANgBJg66eQ7yDXhqSIovV9+08/lWzPexA9V/OMyRUIbMbNVxnbyqKVhMXHkb1CbcDEJLGpn
	u12XgFExBHZ0UOMmnJkQWCTvLVj4PDVn0yp3AgrGdsNtnT9VMzRJ2KA85C5tRWKJdea2/ncmnYR
	429SfEwzEnPKalyNMpI39mthNEwRu7d/EN6r85Y/2Q833UPstx6gbcJo2QNq1JWkWM6f68VYoRB
	pMutIRj2LGiVRFEkKUxV4wRMJqNl+XoKnGfA3eB83UjHgrnoXgDIIIu6Pm8CwxfrPDrhnP6xHPe
	TauTtA6n6RXdaGbRL6IxjBISfbjpB2ClBRDAVSB9Iayi/uNgoqZKSQws=
X-Google-Smtp-Source: AGHT+IFNXKVgFCf9oxHZTOVod5Zc+yNJa3LmyNQSCvc7LVtmGcpucQKrx4p4Xkkmu1Q83PV2OkUL6A==
X-Received: by 2002:a05:6000:719:b0:3a4:eeeb:7e76 with SMTP id ffacd0b85a97d-3a6d1191024mr2699699f8f.9.1750433957105;
        Fri, 20 Jun 2025 08:39:17 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d118a1f2sm2323815f8f.83.2025.06.20.08.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 08:39:16 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 1/8] x86: Avoid top-most page for vmalloc on x86-64
Date: Fri, 20 Jun 2025 17:39:05 +0200
Message-ID: <20250620153912.214600-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250620153912.214600-1-minipli@grsecurity.net>
References: <20250620153912.214600-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The x86-64 implementation of setup_mmu() doesn't initialize 'vfree_top'
and leaves it at its zero-value. This isn't wrong per se, however, it
leads to odd configurations when the first vmalloc/vmap page gets
allocated. It'll be the very last page in the virtual address space --
which is an interesting corner case -- but its boundary will probably
wrap. It does so for CET's shadow stack, at least, which loads the
shadow stack pointer with the base address of the mapped page plus its
size, i.e. 0xffffffff_fffff000 + 4096, which wraps to 0x0.

The CPU seems to handle such configurations just fine. However, it feels
odd to set the shadow stack pointer to "NULL".

To avoid the wrapping, ignore the top most page by initializing
'vfree_top' to just one page below.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/vm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 90f73fbb2dfd..27e7bb4004ef 100644
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
-- 
2.47.2


