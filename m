Return-Path: <kvm+bounces-21547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3793692FEF1
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8866EB23360
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804A517B415;
	Fri, 12 Jul 2024 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TcR3Tt4M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327F117B058
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803680; cv=none; b=aQAXuzHa8a6GMUWF+xtR/Xz4T7E12xOACha6sGSgWep4ie36w4SqfnhfuIGoFgZ8CEfSIGOJFlYOFb77XQqSdl4k4xkT/9WEGeUpEY8g9cyJpvGW/YwQTy/r58oy1zhjj+nsgNwcY5U3HxeBv3uuXbpoLxRF42eweGP20QXrAhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803680; c=relaxed/simple;
	bh=GLYAN/kV7nMWH7raHmImHFUkFRo8aYGtdJRB09Hyu5E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PeCl2AVaP4WiKQ/cp9fDuntvGOZO+lXU4Jo6c8iropVb3QrVoqDMl6XbOBE2UndXDrrDSi0LfFCAoNljc3U7yTf1qJ5dBkJlpuuSE2Uz82BUdfrXmjcjEBvXoNCd3ZJCTrUY/1T+EWXbRJNp5kS2Zng8xvL/0zkgorQRnS5XyZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TcR3Tt4M; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-42668796626so14700305e9.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803677; x=1721408477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=STKCp8fX1eTmkj5Bbc4ElFS0AmmAwYWDzWQm15HV9Io=;
        b=TcR3Tt4MErZrNXdoflAGqLhy0CV9tAuAPZwTeZTxRpYUkjvadVNgybEv6jwjDIkaAV
         BnmlXu6x2Lu/hG8aR5igl0eg63BMPedFfyG6zOjkqklyeMPRTrq7qN7qY9BTk8BrBXDP
         7b4kl7/uXUKouL2H+lxiGlC+aO1w5cYurSlObuo/YwLDyOCu+Q/FJgIS6Ur0wh6/re76
         x6/GlLYNq5H6VUR+DpOVteW82c7iJz4xngpj+SFa+SvduXjbtqo+nuVWjYIRv/0a7ztp
         ys7mJYtXPGkNno+IVC96qi1aZ94Lu/ovqHF9iPRSIUiZaydWiWvk+MW7pixnt9UkIFQ7
         6dIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803677; x=1721408477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=STKCp8fX1eTmkj5Bbc4ElFS0AmmAwYWDzWQm15HV9Io=;
        b=LV/bRGSYoVdLyQYEGjvOrrbndqNR671Q38+xDVHWB89COv1Id2TecQ0DXPcE6HRf5I
         VGV+K2gwHIk+8CUazOUxPXvjdmVMaqtsKB3EFpmB5iBzrwcrfTIPNHq48a79QcxHbBs+
         m4mytPfmmt3KwnUZq0g0rDDOuLj5Ra1baPvd3NdQXLd9rF/eyEkV2d18L4LWhdBqms6G
         F0MzfAwej2C+2NJ2civJoZK5Ai7AtVSFoAzmX7FSlbHt4lbucNx7QnE9X/hxnPahPRuO
         vvZSfYCI3/hcPvASVEhKCWxyGbTXWqiewgYugKHKoPsTkNZLYiGi0AuDezW6JZU2jn6R
         D+tg==
X-Forwarded-Encrypted: i=1; AJvYcCVSf9kL6fwjwKoMgGIWvi8n03Uil9ItQ5Z2QTWHiV1L0YIQYI6Y3omnrAZ69+alENnMRZDiFYZ+/lhcE5xFPV5KgBJ3
X-Gm-Message-State: AOJu0YwnIFacV/HXL8OKs7g0JkgxHVqb5ghZrVWgd4qSt8keisSEYpeD
	wtrhFm/9/KDrdfw7vaZn3bz32Xnm02NletWgopkKxA1qk2qXRcvSGg7Ls7zY7t9WjrVKsp+U4Bf
	LiJD32Suhiw==
X-Google-Smtp-Source: AGHT+IFyt7OjPNZMl6PbkdfYNDPh8L+dPRBgusnHtzyUmHnXcEp/uNI1T+enUzqfuMGxALw2f3LiWe2F0njYig==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:600c:358a:b0:426:5ff0:1b48 with SMTP
 id 5b1f17b1804b1-426708ef8b5mr784025e9.4.1720803677551; Fri, 12 Jul 2024
 10:01:17 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:27 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-9-144b319a40d8@google.com>
Subject: [PATCH 09/26] mm: asi: Make __get_current_cr3_fast() ASI-aware
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

From: Junaid Shahid <junaids@google.com>

When ASI is active, __get_current_cr3_fast() adjusts the returned CR3
value accordingly to reflect the actual ASI CR3.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/tlb.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 34d61b56d33f..02f73a71d4ea 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -18,6 +18,7 @@
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
 #include <asm/apic.h>
+#include <asm/asi.h>
 #include <asm/perf_event.h>
 
 #include "mm_internal.h"
@@ -1125,14 +1126,32 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
  */
 inline_or_noinstr unsigned long __get_current_cr3_fast(void)
 {
-	unsigned long cr3 =
-		build_cr3(this_cpu_read(cpu_tlbstate.loaded_mm)->pgd,
-			  this_cpu_read(cpu_tlbstate.loaded_mm_asid),
-			  tlbstate_lam_cr3_mask());
+	unsigned long cr3;
+	pgd_t *pgd;
+	u16 asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
+	struct asi *asi = asi_get_current();
+	u16 pcid;
+
+	if (asi) {
+		pgd = asi_pgd(asi);
+		pcid = asi_pcid(asi, asid);
+	} else {
+		pgd = this_cpu_read(cpu_tlbstate.loaded_mm)->pgd;
+		pcid = kern_pcid(asid);
+	}
+
+	cr3 = build_cr3_pcid(pgd, pcid, tlbstate_lam_cr3_mask(), false);
 
 	/* For now, be very restrictive about when this can be called. */
 	VM_WARN_ON(in_nmi() || preemptible());
 
+	/*
+	 * Outside of the ASI critical section, an ASI-restricted CR3 is
+	 * unstable because an interrupt (including an inner interrupt, if we're
+	 * already in one) could cause a persistent asi_exit.
+	 */
+	VM_WARN_ON_ONCE(asi && (asi_is_relaxed() || asi_intr_nest_depth()));
+
 	VM_BUG_ON(cr3 != __read_cr3());
 	return cr3;
 }

-- 
2.45.2.993.g49e7a77208-goog


