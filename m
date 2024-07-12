Return-Path: <kvm+bounces-21557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82CFF92FF04
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:07:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B328B1C22BC0
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B275317D361;
	Fri, 12 Jul 2024 17:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZgqL4h79"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC1117CA10
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803709; cv=none; b=YEE78H5RYcSeOS3nWvrGhaBjrWhQPF1QeWmLkCqB+RLJCPKYG/a0zL9Z9Ent5X5a/Ab9iUUedJrpQQE93/E0mYUELcqBJuaLqf/DX1N5WI1sv3Km6yYrJ+oFnNqAmKz9+SIfOcsogXeT0gXLII2D4qqWYSbFK1A4oT9WqvpuWIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803709; c=relaxed/simple;
	bh=9+32GFQKDiKRSTS7tV4qzvgjaIO16wRpq3iLd8/veyA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ew1lSS+jtW0Mb7oDMkq1axKoBs8LUvn+854zUmPClOU/fFfapsWBaKt/tzt4AhWTWK0GdHLDusWTAdV1JIP8tBVH8vmv5dXKzmnE2zPNIx/b6UuqeREe8bByRb+Ct1TScQdY7k7ALU4bh8JLrTMOzlqf9UlNrpxt8BTOcAHhmWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZgqL4h79; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03c68c7163so3861682276.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803707; x=1721408507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L6MmdIw12rXfqeUQQj88z73bFenIU6DgFXoL45UzNnM=;
        b=ZgqL4h79FAa2jaVkqNfmRIFof8Ys8TqIeQ8ATFYskEQblxWzu7pm2OrrMjOxQinndY
         RsYlq+Al3dOqrwtiHvWgN2aHo6iK1LAa2G0DBYY5Xwnyu+0R4M7aiTmM9a+RK7yp2Tz/
         aSWubuf3R8uTiUgDOPIuIPRBiz1XdAE5G+8nhpQ5h5OWWwpQ/sHk9Gvbv2OilLkQd4sK
         z0GfMUt2jD6uSWkCghAvX08EGPRFBCj0TkcLrQLTgeIKom5G84Q6yiwzMhImIpDWDDaM
         /T0uAoRTdevMZM7tl4fDJv/LB2Ckg31afdH/GP4tRBB992gj5U6Ek48qk6qrnyF7YWni
         pZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803707; x=1721408507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L6MmdIw12rXfqeUQQj88z73bFenIU6DgFXoL45UzNnM=;
        b=IniGuQEYaUgNFgb6J1kGLBTtEv72rx3ubjvHtnSdrxu9szBB4DyEDSrNfxvmbPJN4g
         dWKu78yMNzkOvS93Fytqvytq73GQQr1a18xB8emzTvJdjC3bchj12sCxVq1+aeSaLZHY
         sgb8L3VUfeCNThBPTjUhmTpNt4kccPsKXJ8gJR60jECRJE0jSdgikWoq7nMiKKqooeph
         NSE58NIZ/0bL4QjpkF3HaMOVhCQHi16Q+dBByMpT+mUCuyjhL3eeThf0E6ugAQd/4hyj
         njh/wiHYz00hbvXvaanvvxdmrqA1gQCg7zf2Q6qkQGpIvNqCkzBMauJs7D5CnMcXMVmB
         BsXA==
X-Forwarded-Encrypted: i=1; AJvYcCUM1NEsx0PEmgYTNQOj2hZHipF8zNZCAME3vIdWCpInrrs6Ms7n2IMzb3824NcwEW8vkylXocZPUiH3XnGlgMRu+6cU
X-Gm-Message-State: AOJu0YzbALM3a+p2Z3nRcbVgJI1J5MnLDXcSM2nCe/0WVmZf7UxFWXGX
	VtI7I9LQcKtv7eVlsvXfYSBSdFYWuq3s2K53lAoXb1TFJS8RcppLqG1TPaDlnc1dxIshL6oLAAe
	qsqS6jDI5BQ==
X-Google-Smtp-Source: AGHT+IE68Lhuxh26ghjRhhLaHrJ9YduMOpsYsuWnIFTPqHiwg/OIUXbqUWhmNqr8FCCI3K44ay3Zr7IW+9N5Rw==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:6902:2e0d:b0:e03:2f90:e81d with SMTP
 id 3f1490d57ef6-e041b14c989mr757806276.11.1720803707241; Fri, 12 Jul 2024
 10:01:47 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:37 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-19-144b319a40d8@google.com>
Subject: [PATCH 19/26] percpu: clean up all mappings when pcpu_map_pages() fails
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
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>, Dennis Zhou <dennis@kernel.org>
Content-Type: text/plain; charset="utf-8"

From: Yosry Ahmed <yosryahmed@google.com>

In pcpu_map_pages(), if __pcpu_map_pages() fails on a CPU, we call
__pcpu_unmap_pages() to clean up mappings on all CPUs where mappings
were created, but not on the CPU where __pcpu_map_pages() fails.

__pcpu_map_pages() and __pcpu_unmap_pages() are wrappers around
vmap_pages_range_noflush() and vunmap_range_noflush(). All other callers
of vmap_pages_range_noflush() call vunmap_range_noflush() when mapping
fails, except pcpu_map_pages(). The reason could be that partial
mappings may be left behind from a failed mapping attempt.

Call __pcpu_unmap_pages() for the failed CPU as well in
pcpu_map_pages().

This was found by code inspection, no failures or bugs were observed.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Dennis Zhou <dennis@kernel.org>

(am from https://lore.kernel.org/lkml/20240311194346.2291333-1-yosryahmed@google.com/)
---
 mm/percpu-vm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 2054c9213c43..cd69caf6aa8d 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -231,10 +231,10 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
 	return 0;
 err:
 	for_each_possible_cpu(tcpu) {
-		if (tcpu == cpu)
-			break;
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
 				   page_end - page_start);
+		if (tcpu == cpu)
+			break;
 	}
 	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;

-- 
2.45.2.993.g49e7a77208-goog


