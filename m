Return-Path: <kvm+bounces-63258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 170E3C5F46A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A84323582EF
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956B82FB09E;
	Fri, 14 Nov 2025 20:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tABE//xr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551D82FB0B5
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153471; cv=none; b=XODDAhnwZ80eqhr2hAIM71jS+q1X6V/9rRrbr/w2STX/M5h3rvt6I0nCOfrtbjSdQj6pAkzpK68RgKTVN7wXJkoSHAfJQIWFcFlQlWj1VD7McR8eHvKntge6hii5RCWYNtO8psieThl0cPmT2DlGZ9JasEzOw9kD+XBPil+TYv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153471; c=relaxed/simple;
	bh=mggLTR85xhWj6YKFdY65eTpC6FNh3/omp9/m79E581g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QboleGXKDg+37fiaS0o91SinadmGKi8qsrQF9zytxJxnbsAmY17jXwEO888ZmFxzDhKuomSnnXifhmL+p+ZEhiAROgIlytQtCWYime4/V7tHMQ1cOZyw0hczvcmYf0yJ1UW92YubE0v4haPWbMU8+2KATpr59lF00Q/FqBDe1W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tABE//xr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso3199831a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153469; x=1763758269; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xFCwPAyxL885lQQgjPTsa5XDuX/DbG6LG9iOuomIbgY=;
        b=tABE//xr0gVMljgvj5qQrlZNzV7dsvp6uE0k+YvizZmNasjLJXNLpmdix2f/lIyLb7
         bKo95mCP8dYQTyq6dNDqdgSO/7n2tLHYeNDvs/l3lwlaCVS7C3FSAQLO/ps0xDkipcSj
         8VgEfGF6kYf2UQNZLl2gC/yC2R8Yk5NHMhRz9zeaksKyEe5L186gdab5g7ADMrKmmQAc
         6siuBjfBygxrfvSp+wwBquyfqHeZtylfOk0JRsuRn24aagr63IV+8c7COF4xVATbYkR2
         V1EdKoGA8ayBFnPv+QQ+IZpHEpd4qkUh6v370BBe3+PsMhIy3G3roVIP+P/oGUA74boR
         QecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153469; x=1763758269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFCwPAyxL885lQQgjPTsa5XDuX/DbG6LG9iOuomIbgY=;
        b=gby+exvpSuSW4XG4/MoRM03RMifaIYJ2g+/hd/pVBBhpnrYG7Jv7hs8KJfA2fqQfPH
         JOaZjjisDf0FsQxPm+JPrqdBHsRxiit0rlyLocqsSXPC0o5ac5smk0oegnPMLXpKoQlL
         a8YzMDBTFSsJKKhpp4nq+BM8JjtNFi+wd/sMmcrR5h1zm1tXBVes4SHD4koH7d+DR4XT
         3ztmsjfYMdZ5tH1lL5Zvb3mFw69bnVqBL3gIcHujdxvpfZ7Fek9iJceeKxoUMZNuSufy
         Cy1YsqrpHiWtxjCfSNvJ+XHkd2Dhx5vVFsVXFLfyYXwuw5hhfeU9HY0PAE5tVGDZckPq
         cytw==
X-Gm-Message-State: AOJu0YzbC6HQ3Qe8UhgXFMEHLaGiXmS2HGyN1fRJjbeCtUJUxeGPbMaz
	4qeer2XyC+1VYUzIAum/EFXseu9fUqTAYNJtbMjUXnRtAeQxDjdk/+ZIYp63KjjBVBh3zY1l5j1
	y0K55AQ==
X-Google-Smtp-Source: AGHT+IEnZRSzICHpY0vHcrP6f8j+rAlUBqN5mmE4zqf9crj4tumZFMkkUfX3BPgBf8fi/NYwrLrK4Pq4a70=
X-Received: from pjzi17.prod.google.com ([2002:a17:90a:ee91:b0:33b:b0fe:e54d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5804:b0:340:f05a:3ed3
 with SMTP id 98e67ed59e1d1-343fa52544fmr4776251a91.17.1763153469408; Fri, 14
 Nov 2025 12:51:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:44 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 02/18] x86: cet: Remove unnecessary memory
 zeroing for shadow stack
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
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


