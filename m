Return-Path: <kvm+bounces-29188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6619A4ADB
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 03:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFE10B21726
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 01:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020B41BDAB2;
	Sat, 19 Oct 2024 01:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C1GEIIsX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC2E1922D6
	for <kvm@vger.kernel.org>; Sat, 19 Oct 2024 01:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729301387; cv=none; b=jnUJ3B+FDVH2x3nUzmH59IIS8HhWMYF1WF6WQ9u1kr4augw0+zlnPEAJWEtbln1Yoo9IZ3Kzgzl/G5v/6kzxwgc+6YM6sAmWV7UddeAR+FMVaP5ngZrMUYhF2Cy9Kmq06fvYDSFespDSJ8xFw1Ku4xbJbGTmTQ9IHwLnZ61Zz4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729301387; c=relaxed/simple;
	bh=3mtGNq9cGSGYrfQFZeSpQbC6OnKLuvDcJ3My6WR3hg8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=X23aVLzYlT4x2FuN0sfNW1Goyl4zON3q/Bx8Y7aGK5enxfEdLFbtG4zqH4Lx/MWttEKvqmExvDfWh7PbWzgboA6NF8RhpA+SYThZD5601z+3moVs4efeK+1YT0oV2T4XCcb6CRoQYqbTzBDWFdDzCRSG/tGBq69ocn22IwSzwwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C1GEIIsX; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e035949cc4eso3869290276.1
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 18:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729301384; x=1729906184; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YuCuzNJhXO6NMFow4//rMdfOZm/3Ta56iibLMueqV4o=;
        b=C1GEIIsX0Grr6+TDcrAUL+w5wqRsARy485p3C6OArX6GycOuzV9D3kU/6WDhVX/HVS
         NGDfPC0NGKlTATdn5A+4L40gdy/4Xpu85Q+0P6qICzVwyLLsnz2Wmr+K7ffPyncmoEct
         g5Ctj6/bHQddFexJUt775QlZ6tBjJtIPGBNCvQ11gZv6EdwOMA1U79XEsw2dHQMYL6lK
         kmjEk83BsSTycScO353qcGOnlM2rU+hLN+hzZlyHFYCFW0A7hnV0HE6+qsfgyVNFi6OE
         1wlurTQgF4YiQDtyYBB2ACM5XOtRqANIg7frtm37pT3TJXOtn3KJuPb/GETdaMlCTGTv
         A74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729301384; x=1729906184;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YuCuzNJhXO6NMFow4//rMdfOZm/3Ta56iibLMueqV4o=;
        b=B1pnUyGQUP+cU/VxkyPTwGgcuhLpHbT4iJekeWAcnHMzw4xh9EsUkep5YxYSCi98+Q
         uV9w9Oga4sv2hxmTj8bi+MN1mR5Th/RqTNQcd3hY1u21fIESIcxEQ83icVFv3skz7WaX
         iu8RzwIlElp1ur53srSK70O7sXYmzc2PiJzqD3pQvzg4F3A4bwYguInPfW3/PtOfCCqL
         phqVV96T7mLpnf2hRUCTb12TEojw8Cr/iafxnQvJW6iVv+kCG1VSfdnUqkw2LbbzGHem
         OaunBX8xMnSbUB4Gq6IiYVM/J5Iov5UFXIdcbfp3KdnAaHZ0gyaHbrST9B+dceA3ceRa
         Lbeg==
X-Forwarded-Encrypted: i=1; AJvYcCWuKcw0XbiQZVeW00lxbE+8Ehxck0DUerQAaSadRnBDV1+egDJaEzh0RU9fs09okE+W4Gk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH6QA6soSROiGJqRI/PIl5oNxt7XG7sTDppQEdKgnAPtKN1crm
	Y5+LB3teO6Ncj7G9PFTfvwVRMEoJUAIlAGPLRpa4kPTqwuCfDOR/MT0c+re1jopKNUgTVu2RWuk
	YfuHYmTSeWiCComLh8A==
X-Google-Smtp-Source: AGHT+IFmq0/1EPi5496WrRokUU9WA5t7S1WG8rkiw/MIseZ9iZLjY0dGBCILI69xXidmtmdxWEdpgYhtiPqAdLd2
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a25:81d0:0:b0:e28:eaba:356a with SMTP
 id 3f1490d57ef6-e2bb16d53e4mr14075276.9.1729301383632; Fri, 18 Oct 2024
 18:29:43 -0700 (PDT)
Date: Sat, 19 Oct 2024 01:29:37 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241019012940.3656292-1-jthoughton@google.com>
Subject: [PATCH 0/2] mm: multi-gen LRU: Have secondary MMUs participate in MM_WALK
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Stevens <stevensd@google.com>, Yu Zhao <yuzhao@google.com>, Wei Xu <weixugc@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Today, the MM_WALK capability causes MGLRU to clear the young bit from
PMDs and PTEs during the page table walk before eviction, but MGLRU does
not call the clear_young() MMU notifier in this case. By not calling
this notifier, the MM walk takes less time/CPU, but it causes pages that
are accessed mostly through KVM / secondary MMUs to appear younger than
they should be.

We do call the clear_young() notifier today, but only when attempting to
evict the page, so we end up clearing young/accessed information less
frequently for secondary MMUs than for mm PTEs, and therefore they
appear younger and are less likely to be evicted. Therefore, memory that
is *not* being accessed mostly by KVM will be evicted *more* frequently,
worsening performance.

ChromeOS observed a tab-open latency regression when enabling MGLRU with
a setup that involved running a VM:

		Tab-open latency histogram (ms)
Version		p50	mean	p95	p99	max
base		1315	1198	2347	3454	10319
mglru		2559	1311	7399	12060	43758
fix		1119	926	2470	4211	6947

This series replaces the final non-selftest patchs from this series[1],
which introduced a similar change (and a new MMU notifier) with KVM
optimizations. I'll send a separate series (to Sean and Paolo) for the
KVM optimizations.

This series also makes proactive reclaim with MGLRU possible for KVM
memory. I have verified that this functions correctly with the selftest
from [1], but given that that test is a KVM selftest, I'll send it with
the rest of the KVM optimizations later. Andrew, let me know if you'd
like to take the test now anyway.

[1]: https://lore.kernel.org/linux-mm/20240926013506.860253-18-jthoughton@google.com/

Yu Zhao (2):
  mm: multi-gen LRU: remove MM_LEAF_OLD and MM_NONLEAF_TOTAL stats
  mm: multi-gen LRU: use {ptep,pmdp}_clear_young_notify()

 include/linux/mmzone.h |   7 ++-
 mm/rmap.c              |   9 ++--
 mm/vmscan.c            | 105 +++++++++++++++++++++--------------------
 3 files changed, 60 insertions(+), 61 deletions(-)


base-commit: b5d43fad926a3f542cd06f3c9d286f6f489f7129
-- 
2.47.0.105.g07ac214952-goog


