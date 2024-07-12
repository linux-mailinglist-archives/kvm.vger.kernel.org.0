Return-Path: <kvm+bounces-21542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E68E792FEE6
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A25BD285EC4
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D88B517839B;
	Fri, 12 Jul 2024 17:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2nvjJHX1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A896B178374
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803665; cv=none; b=e5D5Gd4Sg2Ug1+KLIWSJeHu2gv2ZOt8DTepbWdte/zZ1l8UMpmzL5tk0rBjyJgDOKFUzx86KMZt4AuJ0H6cQjYisJKMpTZYkCVN9Qg1iia9+nvSiBCjzgblE3VqMRaRhBmrvCJ/40aMmu40rChSZzuWHTZcr0jNM/dAIGP/9nOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803665; c=relaxed/simple;
	bh=WYamHMKq11ekPlGjt0Tp4cGSXpKCPA/6UkC+Za8VmrE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pRI5C2aa1F3QNurvHlTUSBq+dKdeoaLR64Fg3/oNa7ahVMT8BHJP9R3Val1W1BnN0dcH/9nB/8siUUqaA/djqq3SJ5wspBflQO7N9ix6a0moxqMrP3WgG1mN8KfO/n4DWKjchL909I9V/mvoWENUUok7FQ2Q2QxV+Qoc3505RJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2nvjJHX1; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0360f8d773so3757915276.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803663; x=1721408463; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uRdo734SZY7LgE59iZWS/AzLUQw9XRryPytUBqM/u/Y=;
        b=2nvjJHX1vBCEHiZ/eZE+RsLY4OryH28oLsB/kAMco1NvemfN6bh8Uj0v8HGGmZsRAI
         jgm7mhu2spmdoQVzNV3TQNKn4+g/ETQbEfDFgq0Zb96+2GmWA5Ezdjl+R0Wb0D/ky8RD
         6FSOJXwTLx9ElIN9PeDs1onJZAmdtxH+7vyZ9hCyKV1E4EEDn+c0oX4O+l/wXXABnthu
         L4IyhCk+g+nMnTCq532FY5ehMSqRpcjnwCpyk/u+il1JZMGiOAOMoxJaW39sPAKlvXb8
         2Nx6SXUtDlXvo5eBkefUXc4iZMz7X2+AcaILmiIwhPqUdHAKJu5FwSm/YFHeHA3vq+sW
         EpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803663; x=1721408463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uRdo734SZY7LgE59iZWS/AzLUQw9XRryPytUBqM/u/Y=;
        b=Tu9qxGJuJQckp6fcc3DOpbitVNiyh0yFjwvBdkTgXYbDEz+oRYSIYoEOJQFAr43dxv
         PtavUaUem+SSP+rqTdsMIG/+RUCzY7+pgdwtymNgABNZHCVpPcc0HMugrvjU6Kfx6mrJ
         BcJzDbDB1urXRyIGgBCNoZdVKrgJWMAnRk/047UUU1/aKfFPlt8iZjyp3IJXvKwY+xZ8
         EDaTP/e6qsHFsqHTXYBgJwVtR/zb6+Nuhh2haEYf16d5uqr3soheiT0ThsDCyknUK2Zb
         gaQxfZTbfsSvlpaMnGvFK/qIagIPm0yIApMLURlAkanc+u0qE7hhcS2xraFGFJDIXpuK
         BAEw==
X-Forwarded-Encrypted: i=1; AJvYcCUs/jt9lQH0NOUm7pBYsBoBd3Lncv3bSSMNICcRCWYpBzzvm6c4Nn64bNNk9BSC+1wlZTWTS/upgP3eXlLBDsFLXNEY
X-Gm-Message-State: AOJu0Yz2fBUn7llXy13jcXQw2wmlk9kbYj6F99j3jI5l95KiInK14j2n
	ITGC0GsvzZqJD4hV0FeU6MgrMPaG2ZfxqPfLCbDpwlAhVCpnDYG5Grrkll/dF76VEmYOVkLrdM3
	wwjBSolCrNA==
X-Google-Smtp-Source: AGHT+IFYA55X1keLcQMRBGeCAFNmP+QStD5pTx8+8q+l5zrMjeIlti4CTq5gIWF/C14pV/xqXPndYQF6ybLHYg==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:6902:1b12:b0:e03:b3e8:f9a1 with SMTP
 id 3f1490d57ef6-e041b02fabamr791937276.2.1720803662807; Fri, 12 Jul 2024
 10:01:02 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:22 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-4-144b319a40d8@google.com>
Subject: [PATCH 04/26] objtool: let some noinstr functions make indirect calls
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

As described in the comment, some noinstr functions really need to make
indirect calls.

Those functions could be rewritten to use static calls, but that just
shifts the "assume it's instrumented" to "assume the indirect call is
fine" which seems like just moving the problem around.

Instead here's a way to selectively mark functions that are known to be
in the danger zone, and we'll just have to be careful with them.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 tools/objtool/check.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 0a33d9195b7a9..a760a858d8aa3 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3425,6 +3425,17 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 	return file->pv_ops[idx].clean;
 }
 
+static inline bool allow_noinstr_indirect_call(struct symbol *func)
+{
+	/*
+	 * These functions are noinstr but make indirect calls. The programmer
+	 * solemnly promises that the target functions are noinstr too, but they
+	 * might be in modules so we can't prove it here.
+	 */
+	return (!strcmp(func->name, "asi_exit") ||
+		!strcmp(func->name, "__asi_enter"));
+}
+
 static inline bool noinstr_call_dest(struct objtool_file *file,
 				     struct instruction *insn,
 				     struct symbol *func)
@@ -3437,6 +3448,9 @@ static inline bool noinstr_call_dest(struct objtool_file *file,
 		if (file->pv_ops)
 			return pv_call_dest(file, insn);
 
+		if (allow_noinstr_indirect_call(insn->sym))
+			return true;
+
 		return false;
 	}
 

-- 
2.45.2.993.g49e7a77208-goog


