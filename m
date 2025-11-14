Return-Path: <kvm+bounces-63129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D10A6C5AB96
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:13:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1A3104E493D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B53821ADB7;
	Fri, 14 Nov 2025 00:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WObFv9eI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFB91DED63
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079188; cv=none; b=Fdgi9mxRNW1nzShVex6E+tHmQFjNsZVuf+U26jcno3/Lu8IjijJo2afg+nwI15XfB4+WplLmmQpqU/kUwYAgikLotqCszLo7/ZxjhB/+aW9bSiyQSnUuEQaMYoNU8KHjAny62HhvBbYxzinJpxDPCi7twba/pmUpmheN/jxQyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079188; c=relaxed/simple;
	bh=mggLTR85xhWj6YKFdY65eTpC6FNh3/omp9/m79E581g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=To0MigoMPm2fxhtRNazpQDpC61MnOOKlP0QrmC5PbdbI25GXHLQaS/dOLiq32oe9fD1xVR0OXiSg3NjqUzNKrPNuKioUzinR2clgCivSg592UOTffcUyFjDuq7azmbyG9JTMBVWoL2dQ1u1mEBOiOzG3ozJ3UClVlTkkGdd8cP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WObFv9eI; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b849837305so948607b3a.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079186; x=1763683986; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xFCwPAyxL885lQQgjPTsa5XDuX/DbG6LG9iOuomIbgY=;
        b=WObFv9eI2pEFbTroHwDzu3+PtIFooOdZyu7xe6waVdTQjfGoeJuDDPgkrZL8Sm5O7n
         t+PHJNJRxLyuKRnmA7W6r1mC3S83OqwHw4V0k0VkuJlIt+qMfWzmnBwxuk7rEVae/ChF
         uA+ONcEfyov2cFSiyBL8jpJK5QPIfdGQgZ1LmmpgsIhsPmYlQhAf0Ekcft4uWvMAap/T
         ogWXHNnxf3sh2mxtjT+uuwttSt2moo4oK/KW7VZedGdUFBznh0iaW5e/mkYIh6f1bjts
         XO1P6vLRz3M+pHRkiKLX3tnNLzGeBUmnVU/SJZT/3m0VXIX6h68ZGnB5yrwug2Hj00mV
         wKiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079186; x=1763683986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFCwPAyxL885lQQgjPTsa5XDuX/DbG6LG9iOuomIbgY=;
        b=MhfF8OAxJq+To67ErofThmdf4zvIaXT5ql+5mRFkw69dbLS6BSklj2FaXsk5lDkzmd
         czPd9Rttya0kVhjx5G+L8vs7Jc89EEG4/NIrqvSONYnFLonzRCezJ73RVEwkoZ8Acqjk
         0afFhq1js/BsB9lhcn70K865MtX+pINSSy63Bs/5yMKp+oQuDNJeFUH6Iu50eAoWAc+w
         PW3Wn/tGzhQoaUgrOAF/9gFdkQ6haOWP7Z4qRM5Y3JjAqgW0/7fqnqLXdRwc44xXbtDI
         Z045ou8wDryv6rIashEeGDlXf4s9pyILz46cpDW1Phlvk0Np0FiWpkHK57uggAUab0d4
         ySLQ==
X-Gm-Message-State: AOJu0Yz7hsn55mr1v4CMIccCXfGrb2fRM4kYB0HKDjNt52nk4pxXb6pQ
	eBHgUetE9IjPUc/q4IHV2rVrOpvznzdz55mwRQJkpikBsT3o45ncuJArRYOQXs3oVO3uP7ZA6Ry
	9lK5JLA==
X-Google-Smtp-Source: AGHT+IG9LdnOZZIfBqrJKkEYkklYP8J+hKXtIXyQjlcAr2UKTCyrfXsXAgTytjIyOGd9+KxqgdZHk0qBxS8=
X-Received: from pgbfe16.prod.google.com ([2002:a05:6a02:2890:b0:bac:a20:5f0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a14:b0:34f:99ce:4c31
 with SMTP id adf61e73a8af0-35ba259daddmr1611040637.46.1763079186115; Thu, 13
 Nov 2025 16:13:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:44 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 03/17] x86: cet: Remove unnecessary memory
 zeroing for shadow stack
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Skip mapping the shadow stack as a writable page and the redundant memory
zeroing.

Currently, the shadow stack is allocated using alloc_page(), then mapped as
a writable page, zeroed, and finally mapped as a shadow stack page. The
memory zeroing is redundant as alloc_page() already does that.

This also eliminates the need for invlpg, as the shadow stack is no
longer mapped writable.

Signed-off-by: Chao Gao <chao.gao@intel.com>
[mks: drop invlpg() as it's no longer needed, adapted changelog accordingly]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
[sean: add a comment to explain the magic shadow stack protections]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 51a54a50..e2681886 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -67,7 +67,6 @@ int main(int ac, char **av)
 {
 	char *shstk_virt;
 	unsigned long shstk_phys;
-	unsigned long *ptep;
 	pteval_t pte = 0;
 	bool rvc;
 
@@ -89,18 +88,14 @@ int main(int ac, char **av)
 	shstk_virt = alloc_vpage();
 	shstk_phys = (unsigned long)virt_to_phys(alloc_page());
 
-	/* Install the new page. */
-	pte = shstk_phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+	/*
+	 * Install a mapping for the shadow stack page.  Shadow stack pages are
+	 * denoted by an "impossible" combination of a !WRITABLE, DIRTY PTE
+	 * (writes from CPU for shadow stack operations are allowed, but writes
+	 * from software are not).
+	 */
+	pte = shstk_phys | PT_PRESENT_MASK | PT_USER_MASK | PT_DIRTY_MASK;
 	install_pte(current_page_table(), 1, shstk_virt, pte, 0);
-	memset(shstk_virt, 0x0, PAGE_SIZE);
-
-	/* Mark it as shadow-stack page. */
-	ptep = get_pte_level(current_page_table(), shstk_virt, 1);
-	*ptep &= ~PT_WRITABLE_MASK;
-	*ptep |= PT_DIRTY_MASK;
-
-	/* Flush the paging cache. */
-	invlpg((void *)shstk_virt);
 
 	/* Enable shadow-stack protection */
 	wrmsr(MSR_IA32_U_CET, ENABLE_SHSTK_BIT);
-- 
2.52.0.rc1.455.g30608eb744-goog


