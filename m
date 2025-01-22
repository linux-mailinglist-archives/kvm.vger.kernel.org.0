Return-Path: <kvm+bounces-36194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F2EA188C1
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:14:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E928B16327A
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 00:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1A428EC;
	Wed, 22 Jan 2025 00:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R5r43eTp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84117632
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 00:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737504847; cv=none; b=ug1jqEbR5AUq7vDbbuDdUKAxkyKj8jzuF29p9fGh/lqv3uIVKcJ+E+DK8uhnXtEtYwtX1bLx4nO9y+r9iXznbL6tQTLf+GPDwaA/BdyKMNOo717U3CE7arc9mGiO+waIDaRvTrJOZJzChL+KyNaFdzcSKpZJHtxSsppe+mpSfRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737504847; c=relaxed/simple;
	bh=ALSi7ewkpKvUNsAggUiXK4fRRB0CnnUgio03SYrsHGU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NsudsfB1GVAWz5m1TEs/AfYq40k6z9uUM2KZCd48vIVCCw756a9GtE4CmWvIzJUgiCpQzYuANllgYouMnjZs0aoaoSdqtMJ+o8AaX9yUyb+l7uKod2A6egayJleXZ8qJJts8L5uAOuIVfJlUj8hgvCJ1j3d2npULyFY+b4SAYlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R5r43eTp; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-844d54c3eb5so394522739f.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737504844; x=1738109644; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tDhsnnTohi4uUO4sN3qMiFQn2DVkOz9pZZ7EMmWB6Xo=;
        b=R5r43eTpCuU/5AhIImNKGg56pZBDOv6XsAbA58pte8mtDCWld8NphWujZwxdR+a7mo
         izvUtXYCYDs+hEEvmu+V5gSJzoxMg50E7Fj2qWrjIUsjl4SCEsXToy5/sqCr4Cp6JAN/
         efy88Ajob6D/dQmOsO77oH5prfErtHZceHj/ovAFUoMghozTectYFMz65yYI0v32rZXG
         0gvKm+d9DE5nc3YINwT4skwUQVIl9WHDW/bfHPZvQXAaT9nI/go+fjKSs9E0pTvVBUQ5
         +u+v6T1tnjbDd/ATRdTqAlNLGoPiIB4N2pr+JBPUlgVb791Cvlom5R3MQYf6eYIg5hkG
         JWZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737504844; x=1738109644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tDhsnnTohi4uUO4sN3qMiFQn2DVkOz9pZZ7EMmWB6Xo=;
        b=F1F/+YIo/Npx1F0mfqN5VKx+TbfyXW0PgYDglB+WbSzpCdDCWFnusUHNsm3z5kxaQI
         YpBheKSLJJ4B/cVfS9uctlc/Mx4Q+9KB4Tt3+O0BZcXBxA71BciLol2U8KTJqsArLvGb
         zcu/YYWLYBq0sJY5OBu6ztCciihvNxp8s1CTMYTy5z2qwLJotM9widMOugMidXDUTurb
         4rT4QRpFoFhv65TFInMU2rDk4W9pDOVeIN81yO2CrUa8PULrin2LwotycT5D62etb59T
         KCqE/VZXDDKgpF/QnDx6of5EQPSRNW1zQXqVPwtL0iUw9NfKw855uCp3fsS0u49h/xXB
         TAZA==
X-Forwarded-Encrypted: i=1; AJvYcCVq1t0nPYdbnluNvVrgIAT4R6JeLcZaYbkCJnEbW0cDZisor8XtBwYowsGLt/xPARaItHo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIWCiNICccL2B3QvgF/ZUQDGJYl+osHgRbEy8Zv8TIooSoFRsI
	pPYVWr0L1PZFYcXH7ivNK07PX7JgtvTns71sDJ5LgK4jYy95tY91+5UTMjBqo9GJyhr8zueZHtd
	jZKmHrstwzPQQ99EfCJprZYjUwsgCpA==
X-Google-Smtp-Source: AGHT+IGg+DWgz6HUfFFcJt1qMaS+kMuybtGM1RkIsCe5j0h+kzyRsLrCOk8meTV9R5ideUzIYA/1xR+QlTP0O473wJP2
X-Received: from ioy24.prod.google.com ([2002:a05:6602:a118:b0:84f:538f:fd79])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:26d2:b0:84a:7906:eeb7 with SMTP id ca18e2360f4ac-851b60094eamr1835510439f.0.1737504844554;
 Tue, 21 Jan 2025 16:14:04 -0800 (PST)
Date: Wed, 22 Jan 2025 00:13:27 +0000
In-Reply-To: <20250109225533.1841097-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109225533.1841097-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250122001329.647970-1-kevinloughlin@google.com>
Subject: [PATCH v3 0/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Kevin Loughlin <kevinloughlin@google.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kevinloughlin@google.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, ubizjak@gmail.com, 
	jgross@suse.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	pgonda@google.com, sidtelang@google.com, mizhang@google.com, 
	rientjes@google.com, manalinandan@google.com, szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"

AMD CPUs currently execute WBINVD in the host when unregistering SEV
guest memory or when deactivating SEV guests. Such cache maintenance is
performed to prevent data corruption, wherein the encrypted (C=1)
version of a dirty cache line might otherwise only be written back
after the memory is written in a different context (ex: C=0), yielding
corruption. However, WBINVD is performance-costly, especially because
it invalidates processor caches.

Strictly-speaking, unless the SEV ASID is being recycled (meaning all
existing cache lines with the recycled ASID must be flushed), the
cache invalidation triggered by WBINVD is unnecessary; only the
writeback is needed to prevent data corruption in remaining scenarios.

To improve performance in these scenarios, use WBNOINVD when available
instead of WBINVD. WBNOINVD still writes back all dirty lines
(preventing host data corruption by SEV guests) but does *not*
invalidate processor caches.

First, provide helper functions to use WBNOINVD similar to how WBINVD
is invoked. Second, check for WBNOINVD support and execute WBNOINVD if
possible in lieu of WBINVD to avoid cache invalidations.

Note that I have *not* rebased this series atop proposed targeted
flushing optimizations [0], since the optimizations do not yet appear
to be finalized. However, I'm happy to do a rebase if that would be
helpful.

[0] https://lore.kernel.org/kvm/85frlcvjyo.fsf@amd.com/T/

Changelog
---
v3:
- rebase to tip @ e6609f8bea4a
- use WBINVD in wbnoinvd() if X86_FEATURE_WBNOINVD is not present
- provide sev_writeback_caches() wrapper function in anticipation of
  aforementioned [0] targeted flushing optimizations
- add Reviewed-by from Mingwei
- reword commits/comments
v2:
- rebase to tip @ dffeaed35cef
- drop unnecessary Xen changes
- reword commits/comments
---
Kevin Loughlin (2):
  x86, lib: Add WBNOINVD helper functions
  KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency

 arch/x86/include/asm/smp.h           |  7 +++++
 arch/x86/include/asm/special_insns.h |  7 ++++-
 arch/x86/kvm/svm/sev.c               | 41 ++++++++++++++--------------
 arch/x86/lib/cache-smp.c             | 12 ++++++++
 4 files changed, 46 insertions(+), 21 deletions(-)

-- 
2.48.1.262.g85cc9f2d1e-goog


