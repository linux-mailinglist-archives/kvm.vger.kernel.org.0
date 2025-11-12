Return-Path: <kvm+bounces-62907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3A2C53BE9
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:42:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6D904344BB1
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438D534C130;
	Wed, 12 Nov 2025 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="olfkkNhZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CA034AAF9
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969195; cv=none; b=l7hydPG6W0h7wi+HzIwUeGFeP0ycUOpqKelrTSEoEzvnkFP4VGY21iKlCyzcpKAprP7+7MeMBN2+3RXogIJLlfH5JWoPEDlag88fXBiGnMmS/ObtVRmUVqcMG17ElxTJAinpMnKJYpvf09X9jlNySv1n5PExWKOVbTnWwNSmcgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969195; c=relaxed/simple;
	bh=lbv7KBOnId+FabH1167dMbnJJpBWntZ2AQurHl0Ymh4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bAsW8ahB0Dbm/C+/Gv4ovqDC+b5AHotMwO56qpi/qwqWnIvCxbDqv+GFzRp9OYXaDuQk3IgeawT03AQ07RGsoEGiFpjbPuu+5COytZh0ANmt+G3BSRgM/kGOXU21K5YazBjWx8gWqQJ1XddWDmnUc/fEQfLwjvSmmVBg3eKUzQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=olfkkNhZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3418ad76023so2404960a91.0
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 09:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762969192; x=1763573992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5TnDpCtdkW5EjfNm/WK8+BC1Q5HsHLmqdVi4Osqi6cA=;
        b=olfkkNhZWRcGazUd1JqEEuH+f1nLwKOQBE3vuPUpfH3w1y7gpdR8/nMJJSiSdhqfzr
         i1hS+OxkvMf9PVLS80WMN4uAGnXbA8BYySRXNqeMpYljUGSEQx02ikTVZZ4KGklkd4Wk
         O3bTjaRxv8/ZubCS4id0RXbw38eI2RX8KB9zG43dnUK10Oo+/UVAjqk0GrIK5D1PcbVq
         g6xqUF0veor+AQ1wn/s45vm4oJcjKq9KSYRoKGYrxXHgK6hR48CTtmn/KAnLSL3di5cK
         /VDXElIeCcPmKBpLMsmEPd9VsA7YUoPhmgZE1DnZJDRoLTFMxl0E5BTS7xKPJfJ/jdWx
         qHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969192; x=1763573992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5TnDpCtdkW5EjfNm/WK8+BC1Q5HsHLmqdVi4Osqi6cA=;
        b=Hx5IPZ2RLrG9uvk0R66RI94YcydnDTY9YIy79Tk4oH1gr1JvM9Ss2ksfGkovbjciD4
         KlN1ZbzzorVOQ4wO3jquBwpC7DCM+bWBzskSDR+J4atSpLiApEBCVzj/kOZn0gTYcuQ6
         kMfhrHarfFBwsVz9BRsS2aMfb6hIerVTb+PQPkcd07iglqWquh/wtKhNLHBcgBUcu3CY
         n5ib5zog1zZ/Ow20TEG+xr0gJlgOMdtCWZptkMODvRkZcE6Zi0FH1GiNSasxFOVnOrte
         /eELI7J82okmGwUmYN6XyT1wjj0Zv3TCtUSZEPsmHb8UKgP4JCwGWLcTCAVDjqfFXn7T
         Ueuw==
X-Forwarded-Encrypted: i=1; AJvYcCVazaVHWQ/wSQCHR1r774wvMQy8jGS27U2VrYoYddq3ZVNoKJ39aHhmUZG/NGkG3xtllsY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxjH0svdy0GRLlukYnQERMQ5+u1Wf2kQSqUsavCK0FA0PQBdmk
	4fy053glpoHhApJbDAaSdu8MTIiaWZc+9D3RZ7abGVuyWDr+ZFBOejvoOym/OnN1vBMKW4lYgH3
	9Emk6jg==
X-Google-Smtp-Source: AGHT+IHz/l05PZRgfyqRId2a6PpuZL13C+FOannHS5GzYwvPYmTtNXM3YC7Qpo5B6cCtNaEfJoKUfU9w7hc=
X-Received: from pjbeu11.prod.google.com ([2002:a17:90a:f94b:b0:338:3e6b:b835])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a91:b0:341:761c:3330
 with SMTP id 98e67ed59e1d1-343dde8addfmr4774092a91.23.1762969192338; Wed, 12
 Nov 2025 09:39:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 09:39:43 -0800
In-Reply-To: <20251112173944.1380633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112173944.1380633-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112173944.1380633-4-seanjc@google.com>
Subject: [PATCH 3/4] x86/mm: Drop unnecessary export of "ptdump_walk_pgd_level_debugfs"
From: Sean Christopherson <seanjc@google.com>
To: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvm@vger.kernel.org, linux-sgx@vger.kernel.org, linux-coco@lists.linux.dev, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Don't export "ptdump_walk_pgd_level_debugfs" as its sole user is
arch/x86/mm/debug_pagetables.c, which can't be built as a module.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/mm/dump_pagetables.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index a4700ef6eb64..2afa7a23340e 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -486,7 +486,6 @@ void ptdump_walk_pgd_level_debugfs(struct seq_file *m, struct mm_struct *mm,
 #endif
 	ptdump_walk_pgd_level_core(m, mm, pgd, false, false);
 }
-EXPORT_SYMBOL_GPL(ptdump_walk_pgd_level_debugfs);
 
 void ptdump_walk_user_pgd_level_checkwx(void)
 {
-- 
2.51.2.1041.gc1ab5b90ca-goog


