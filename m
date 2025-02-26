Return-Path: <kvm+bounces-39208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C00BA4522D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:27:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CD813A37BC
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26DC188CAE;
	Wed, 26 Feb 2025 01:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4YtLOw+S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF55E56A
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 01:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740533218; cv=none; b=GtgurFvL38U42ETBaz45ZimDV7MqFwp2ABxq7SIxkx7uifhDULYZrwUJ3QYIsLTJd9m2G9p213fJQGpgngOoi710c/fjJ/0LEAvZcDYHceSL69IOwtOEbfTnlB68Hg0Rdw+7x7Ocijf7AuGwrGdD2olhTsCymrig21aQAeayhJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740533218; c=relaxed/simple;
	bh=zlFEyC5JeqNAQZFtKzotM5zUfFmUiborem5NGUXLCd0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V7gxjIgZuaIMAXFMQLU5a2EDK2B/4dtlNgb4E3WWW9N4AlKPjcqYJ7OQG6xC9fGxQEomMmeClLRzgeBKVPEG0vRfpXHVjKABN7mNu9qtGe0EKeqV5q3LBh2VcZCWpO12jsxniwgY1/koK/Z/r4lUOxo1vF7reJyzn+WqLWds32w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4YtLOw+S; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fbff6426f5so12942959a91.3
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 17:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740533214; x=1741138014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P5aQ9/mYNTRs5PTgmLo7iB4ydZJA2zvGbKJjvdE0VlI=;
        b=4YtLOw+SrPQOhO3zYMYgKU04iCFUo8p9kFS2r1DCcMyOClYnCiLoz58fdvquj6bmFm
         osI53bhCk+k/5V1b7/H5WFKr5RQEceim7n2S6zBSnn0kJ5O7d1zNJEkhqRhPkXGKcXSC
         PqnuVkVdUi0II/rrJDVqcq31Dp7LJbNoky/9uQ7K/AWdJal/LsP+/NH/jsqlfRKBE5AC
         a2DIKhI5iIxRw6VZf4INOd/jO2RhQ9mkl+XTJWdUb4GoQQjNth/850/QrvWBGBw25+CP
         5t72W5LX/CC6W/2r5egHqKsCpTCqyk7AYEr7LLNThyptcXy8P7tw7sGzUT0H63twoP2Q
         2wjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740533214; x=1741138014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P5aQ9/mYNTRs5PTgmLo7iB4ydZJA2zvGbKJjvdE0VlI=;
        b=L0FQyEc77pvcOdK92Rfvy5i5wb9sNKmCJa+CudEigg1Oz3+ylXaa+knIMBdGpxvtxA
         2dBpYbgk9tBJ6Isngl78HwSiG3F6Q+9B7EWUOP+Bd9Bg2K52OuJ3AFB3W4dA/bL1BCyg
         a3X/ELtDem9Re8Sp5aVHBRcY8PHxCwMlLG9lEhpd8aH+BrhORtkKpLHMzdANnsd6u9CB
         TpetRULF+uq0cBr8rBb88hgiMoNRAz+ij4ucrzIzK4Hv+Vi40mAjONAwlEDtnfPyAiqv
         pYDw5cqXZeyuX+qJ4eNkLnblkuVbPl1KTy+BQ5+agHPfhaK7yW926mzOW+ZkEs9heNJM
         nDmA==
X-Forwarded-Encrypted: i=1; AJvYcCXOlFslLn4NyhOX2LgM6cVS20YcfclM+x94QAvJ969VwivzmXdQ9qRbjAeoexcudx+ielg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhqX4NN1KdCfJtgU9vgg/a/3N/EGnRNhDsTyPzBtDodfVRDdMt
	Ey7LYjUuODSOFn0dIOpPflkJXl7KQllBcgIrb9BE4cjTntbsJ+AJKHBHVEJO3UVK4LxAwYcjckE
	AGA==
X-Google-Smtp-Source: AGHT+IHlNQ5IiZOzlAdmwX5lSgim2XgHtoN9cYmDSibC0w1TZnTWCxGEQ0ilxIU3H83+4BpiEAN/Z5oPYmg=
X-Received: from pjbsf2.prod.google.com ([2002:a17:90b:51c2:b0:2fe:7f7a:74b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8e:b0:2ee:c9b6:c26a
 with SMTP id 98e67ed59e1d1-2fe68ada3bemr9005257a91.11.1740533214601; Tue, 25
 Feb 2025 17:26:54 -0800 (PST)
Date: Tue, 25 Feb 2025 17:26:53 -0800
In-Reply-To: <20250201000259.3289143-2-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250123002422.1632517-1-kevinloughlin@google.com>
 <20250201000259.3289143-1-kevinloughlin@google.com> <20250201000259.3289143-2-kevinloughlin@google.com>
Message-ID: <Z75t3d1EXQpmim9m@google.com>
Subject: Re: [PATCH v6 1/2] x86, lib: Add WBNOINVD helper functions
From: Sean Christopherson <seanjc@google.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, kirill.shutemov@linux.intel.com, kai.huang@intel.com, 
	ubizjak@gmail.com, jgross@suse.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, manalinandan@google.com, 
	szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 01, 2025, Kevin Loughlin wrote:
> +static inline int wbnoinvd_on_all_cpus(void)
> +{
> +	wbnoinvd();
> +	return 0;

Returning anything is silly.  I'll prepend a patch (I'm going to send a combined
version of this and the targeted flushing series) to remove the return value
from wbinvd_on_all_cpus(), which I'm guessing is the source of the silliness.

>  static inline struct cpumask *cpu_llc_shared_mask(int cpu)
>  {
>  	return (struct cpumask *)cpumask_of(0);
> diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> index 03e7c2d49559..86a903742139 100644
> --- a/arch/x86/include/asm/special_insns.h
> +++ b/arch/x86/include/asm/special_insns.h
> @@ -117,7 +117,24 @@ static inline void wrpkru(u32 pkru)
>  
>  static __always_inline void wbinvd(void)
>  {
> -	asm volatile("wbinvd": : :"memory");
> +	asm volatile("wbinvd" : : : "memory");
> +}
> +
> +/* Instruction encoding provided for binutils backwards compatibility. */
> +#define WBNOINVD ".byte 0xf3,0x0f,0x09"

Argh.  This causes problems for KVM, because KVM's newfangled CPUID macros heavily
use token pasting with X86_FEATURE_xxx, and so KVM's usage of:

	F(WBNOINVD)

causes explosions.  Somewhat amusingly, this is the second time today I ran into
this problem, as WRMSRNS as the safe issue.

Dave (and others),

Any thoughts on the best way forward?  I hacked around a similar collision in
commit 8d862c270bf1 ("KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to avoid macro
collisions"), but (a) that scares me less because KVM should never use the
SPEC_CTRL_SSBD macro, and (b) I really, really don't want that to be the long-term
solution.  The only reason I committed the hack was because it was the only
blocking issue for a massive rework, and I couldn't get traction on renaming
the MSR macro.

For WBNOINVD, WRMSRNS, and any other instructions that come along, what about this?
Quite ugly, but it's at least descriptive.  And more importantly, the chances of
unwanted behavior are quite low.


/* Instruction encoding provided for binutils backwards compatibility. */
#define ASM_WBNOINVD ".byte 0xf3,0x0f,0x09"

/*
 * Cheaper version of wbinvd(). Call when caches need to be written back but
 * not invalidated.
 */
static __always_inline void wbnoinvd(void)
{
	/*
	 * If WBNOINVD is unavailable, fall back to the compatible but
	 * more destructive WBINVD (which still writes the caches back
	 * but also invalidates them).
	 */
	alternative("wbinvd", ASM_WBNOINVD, X86_FEATURE_WBNOINVD);
}

