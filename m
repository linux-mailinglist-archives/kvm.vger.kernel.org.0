Return-Path: <kvm+bounces-68110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B101D21F20
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:12:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B4A4F3015D28
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB67925776;
	Thu, 15 Jan 2026 01:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jTOCmLYN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87C721C9FD
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439544; cv=none; b=pgFgRxW+A9yoW9XafLsQ2K22ttsXvLVfPn9ulfYNRk/sNufFOkqDudlWwE9GoCqA5D0cPrWGpjClJ/jYcT1qefjFGvN/DZ8gFY5EntnlY69r0JSbeQB6rGCZTII6aSh9AVPQLkQBjanMz8IJLBi6sMeaaw4+9MMMKcntHlZTod8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439544; c=relaxed/simple;
	bh=dVHAfBRpEgC5Ucvxc9exvOiwGfv4r7hTfYbBvXV5ZcU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DR2XhA8my/OItGP7kdpSxwYmQNvdmLYpyOTYoIHc49bw+P4VvAcpNrEJf7Eb5qSrs3hWi6zdG/LkG+uYA95xP5an4TVkEq/0TzJE2HwZFLBndLuUT/h8qxeLKNAAmh2kDwAJAjKXIYoZOc+pWXzok3KY+b2xqx7ZhcNS2dX9g8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jTOCmLYN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso635747a91.0
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768439542; x=1769044342; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Blk5r+gNg8D5o7ALzuwBmyzjRV/ZbOgxlBeTlxNYU2g=;
        b=jTOCmLYN5pEisIVnkBiZWAdCvCKly2lZVZIn6T1pgmqPSjKG818cNxul5DyEFJRGbz
         MWP8N6i6vlZx2uWWKApBV7K/9PbyJdZm2cVvS5Ayz/nMP8wJT2Gu6gGieDQtsh1fuxkG
         TCQmKF2o0AW/YlRvtQacn1nRFeBs4ZiL5X0t48A8zgLlepw5uO5x7F4Q+uDmojKJBOsz
         ekIgVApVoHKVBYgE0pZps7sbyrgYGKaLBL4+meWp32CHelJx2ClARW1bZABsZp3lmtRm
         0H+ChRnLfO6+n+fPHzJHJbRp7n/FlzxTw03xhkUsNj9zm2KODC87u3+5cXq4OcSf9gOS
         wsGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768439542; x=1769044342;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Blk5r+gNg8D5o7ALzuwBmyzjRV/ZbOgxlBeTlxNYU2g=;
        b=krBTQWh2JQ9N4XL4X8GQsYoLmMgPRp87mKvMIT5SAkHTqfefLB8pqInVcLm3LUW+z+
         shsdDcSY82QX7kI9JZdG9obqn72l2nEO0bX/nvniva+zLlyYBrQj2rP1yscz9UKSKblf
         9kk2H8oJVrASi8j3GIJp7yr1zmudOuI7Z+xg8jh0CAaKdCE++Vw8HcDtLdMy4h0Pl0gq
         j4gN4rz9esi9cyy4xnkmRl7s6jyVtXg/8Ca6AkLCajIln1c62q19YJYJ26ppyDivBt7B
         aj+dH9eiT6wCenVxfAcYo6qe0SiDjA6lXHnPe2LDJs4Z0Pgsv6uETnNjmOxnPF5AmH8o
         w2gw==
X-Forwarded-Encrypted: i=1; AJvYcCU+t5tExlAO+Oe3hnDgWAnFuW5R52BJCMPs3m02t/nFiZS8zQbbQhjbRUxUXY8pa8qC4pE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFR2TV6Q3/BH/gdLPXbxqSyJ29WXON24/9nVPrLjFZw0eVx7/i
	pTEI74/nARchr8O/SVVVJVSDh8TIAksEj0GDOGkDovwyqrVUN4W9IFKhAOyIitbQMqWrJ/4EWMw
	DMaStGA==
X-Received: from pjre16.prod.google.com ([2002:a17:90a:b390:b0:340:9d73:9c06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2250:b0:34c:a29d:992f
 with SMTP id 98e67ed59e1d1-3510913e074mr4478597a91.31.1768439542099; Wed, 14
 Jan 2026 17:12:22 -0800 (PST)
Date: Wed, 14 Jan 2026 17:12:20 -0800
In-Reply-To: <6cozacewv4sop77ilrqnervzpifinxki2ykef55awan2ka5jdf@sqyj7jed3qii>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
 <3rdy3n6phleyz2eltr5fkbsavlpfncgrnee7kep2jkh2air66c@euczg54kpt47>
 <aUBjmHBHx1jsIcWJ@google.com> <rlwgjee2tjf26jyvdwipdwejqgsira63nvn2r3zczehz3argi4@uarbt5af3wv2>
 <aWgTjoAXdRrA99Dn@google.com> <6cozacewv4sop77ilrqnervzpifinxki2ykef55awan2ka5jdf@sqyj7jed3qii>
Message-ID: <aWg-9POhfPxbOZ3K@google.com>
Subject: Re: [PATCH] KVM: SVM: Fix redundant updates of LBR MSR intercepts
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> On Wed, Jan 14, 2026 at 02:07:10PM -0800, Sean Christopherson wrote:
> > On Mon, Dec 15, 2025, Yosry Ahmed wrote:
> > > On Mon, Dec 15, 2025 at 11:38:00AM -0800, Sean Christopherson wrote:
> > > > On Mon, Dec 15, 2025, Yosry Ahmed wrote:
> > > > > On Mon, Dec 15, 2025 at 07:26:54PM +0000, Yosry Ahmed wrote:
> > > > > > svm_update_lbrv() always updates LBR MSRs intercepts, even when they are
> > > > > > already set correctly. This results in force_msr_bitmap_recalc always
> > > > > > being set to true on every nested transition, essentially undoing the
> > > > > > hyperv optimization in nested_svm_merge_msrpm().
> > > > > > 
> > > > > > Fix it by keeping track of whether LBR MSRs are intercepted or not and
> > > > > > only doing the update if needed, similar to x2avic_msrs_intercepted.
> > > > > > 
> > > > > > Avoid using svm_test_msr_bitmap_*() to check the status of the
> > > > > > intercepts, as an arbitrary MSR will need to be chosen as a
> > > > > > representative of all LBR MSRs, and this could theoretically break if
> > > > > > some of the MSRs intercepts are handled differently from the rest.
> > > > > > 
> > > > > > Also, using svm_test_msr_bitmap_*() makes backports difficult as it was
> > > > > > only recently introduced with no direct alternatives in older kernels.
> > > > > > 
> > > > > > Fixes: fbe5e5f030c2 ("KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()")
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > > 
> > > > > Sigh.. I had this patch file in my working directory and it was sent by
> > > > > mistake with the series, as the cover letter nonetheless. Sorry about
> > > > > that. Let me know if I should resend.
> > > > 
> > > > Eh, it's fine for now.  The important part is clarfying that this patch should
> > > > be ignored, which you've already done.
> > > 
> > > FWIW that patch is already in Linus's tree so even if someone applies
> > > it, it should be fine.
> > 
> > Narrator: it wasn't fine.
> > 
> > Please resend this series.  The base-commit is garbage because your working tree
> > was polluted with non-public patches, I can't quickly figure out what your "real"
> > base was, and I don't have the bandwidth to manually work through the mess.
> > 
> > In the future, please, please don't post patches against a non-public base.  It
> > adds a lot of friction on my end, and your series are quite literally the only
> > ones I've had problems with in the last ~6 months.
> 
> Sorry this keeps happening, I honestly don't know how it happened. In my
> local repo the base commit is supposedly from your tree:
> 
> 	$ git show 58e10b63777d0aebee2cf4e6c67e1a83e7edbe0f
> 
> 	commit 58e10b63777d0aebee2cf4e6c67e1a83e7edbe0f
> 	Merge: e0c26d47def7 297631388309
> 	Author: Sean Christopherson <seanjc@google.com>
> 	Date:   Mon Dec 8 14:58:37 2025 +0000
> 
> 	    Merge branch 'fixes'
> 
> 	    * fixes:
> 	      KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Exit
> 	      KVM: VMX: Update SVI during runtime APICv activation
> 	      KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (failed VMRUN)
> 	      KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits
> 	      KVM: Harden and prepare for modifying existing guest_memfd memslots
> 	      KVM: Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot
> 	      KVM: selftests: Add a CPUID testcase for KVM_SET_CPUID2 with runtime updates
> 	      KVM: x86: Apply runtime updates to current CPUID during KVM_SET_CPUID{,2}
> 	      KVM: selftests: Add missing "break" in rseq_test's param parsing
> 
> But then I cannot actually find it in your tree. Perhaps I rebased the
> baseline patches accidentally :/

Argh.  And now that I checked some of my other repositories, it looks like I have
it in literally every repo _except_ the one I use to push to kvm-x86.

Double argh.  This is my fault.  12/08 lines up with the "KVM: x86 and guest_memfd
fixes for 6.19" pull request I sent on 12/10.  So it makes sense that the only
branch merged into kvm-x86/next would be 'fixes'.  I can only assume I forgot to
tag that specific incarnation.

So, my bad, and sorry for falsely accusing you.

> Anyway, I rebased and retested on top of kvm-x86/next and will resend
> shortly.

Please do, even though I've now got this version applied locally; it'd be nice
to have a conflict-free version.

Again, my apologies.

