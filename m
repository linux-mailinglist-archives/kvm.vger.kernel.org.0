Return-Path: <kvm+bounces-2540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47EDA7FAE6B
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 00:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F18022815E5
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 23:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12BA49F78;
	Mon, 27 Nov 2023 23:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JJ51m+5w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9847A1B1
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 15:36:09 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2859d83dfafso3672957a91.3
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 15:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701128169; x=1701732969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l2m9WeXChb3IZcdkKWz2g1bAMA6uELaN8nkmuyBZmHQ=;
        b=JJ51m+5wRnTP7vn03VCHFIfTvAw0xvgRojQ6u5JK931ViOOx9HO8zWPrCjvp1Ou7t6
         hc6vBHZ8Ob95+Tx49Yoxrx43E+duJ1T45hzXkEY4laEQfreEoDvJZSTdhtGL2bUlw2nx
         ZIqcfGRr5rDdBdJJB1q4akp2y4t9ZVkfadWwVDODx8BBFWXXCFWPz2UW20exsOG1HmtN
         7Op7jaJGXIzgL+yIcnruHcNn2jy+BISi1if2XFnTbaxj593IZ1PT5H8alRSVpoG+UwF2
         YnICVbQ5CsDms0b5RGUzqbvqaq1ixWv4vjooSsZxJqMrDNygV1jMuoc50hnan9p53kFr
         7ZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701128169; x=1701732969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l2m9WeXChb3IZcdkKWz2g1bAMA6uELaN8nkmuyBZmHQ=;
        b=MpZrYIMwfMzDvuFJh2plWVEtm/MJuy0W5LAYcGKN4d4tPFl2j7VNDoz30CgTcCUSWo
         vQaNTqTlX28Ua2rDIFZowlZcsiVrTLwTXbMteyqXV9Z/qN25SCAEPpkwUwnXNIYRDARk
         3hjYTleDbvcKeyvG5KCAkY7NchXSg4M6qFoCj2k9tJUkUxtuRXic08hnmq49bpmrOulq
         EE5I3um5ROjLXyvwUVqIbb55pV9sPvmykO3xDPkxVKqftKHN22nvXj0SbJ7epi5ittmu
         EXF6EBBCwncskfEhDrNyve/0HlytSkPNFd1p+an2UEl17uedhELUIC4jfz2rD78SwU1Q
         KL3Q==
X-Gm-Message-State: AOJu0YzarBSMpBcmtJeZLx1/EY7QbesPqi6y3mpZqT0QJVsnBBYsM38v
	auIUBOjN/UNTRLKE+gnmzirM0XihANU=
X-Google-Smtp-Source: AGHT+IEl4S0gbL0JXiTGTFFkSpfut1kGjfX9yALNxNMX7MfX3x5UbA+DNYzB4IO60o0GRmpObK+5rcrVVuk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:88:b0:285:860c:3359 with SMTP id
 bb8-20020a17090b008800b00285860c3359mr2734111pjb.4.1701128169103; Mon, 27 Nov
 2023 15:36:09 -0800 (PST)
Date: Mon, 27 Nov 2023 15:36:07 -0800
In-Reply-To: <a1ebd80f87229fe513f9c2256982ef6c1d0cca2a.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231121180223.12484-1-paul@xen.org> <20231121180223.12484-6-paul@xen.org>
 <a1ebd80f87229fe513f9c2256982ef6c1d0cca2a.camel@infradead.org>
Message-ID: <ZWUn50A5vxiTd-ZT@google.com>
Subject: Re: [PATCH v8 05/15] KVM: pfncache: remove KVM_GUEST_USES_PFN usage
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 21, 2023, David Woodhouse wrote:
> On Tue, 2023-11-21 at 18:02 +0000, Paul Durrant wrote:
> > From: Paul Durrant <pdurrant@amazon.com>
> > 
> > As noted in [1] the KVM_GUEST_USES_PFN usage flag is never set by any
> > callers of kvm_gpc_init(), which also makes the 'vcpu' argument redundant.
> > Moreover, all existing callers specify KVM_HOST_USES_PFN so the usage
> > check in hva_to_pfn_retry() and hence the 'usage' argument to
> > kvm_gpc_init() are also redundant.
> > Remove the pfn_cache_usage enumeration and remove the redundant arguments,
> > fields of struct gfn_to_hva_cache, and all the related code.
> > 
> > [1] https://lore.kernel.org/all/ZQiR8IpqOZrOpzHC@google.com/
> > 
> > Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> 
> I think it's https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com/

Yeah, that's the more important link.

> which is the key reference. I'm not sure I'm 100% on board, but I never
> got round to replying to Sean's email because it was one of those "put
> up or shut up situations" and I didn't have the bandwidth to actually
> write the code to prove my point.
> 
> I think it *is* important to support non-pinned pages. There's a reason
> we even made the vapic page migratable. We want to support memory
> hotplug, we want to cope with machine checks telling us to move certain
> pages (which I suppose is memory hotplug). See commit 38b9917350cb
> ("kvm: vmx: Implement set_apic_access_page_addr") for example.

The vAPIC page is slightly different in that it effectively never opened a window
for page migration, i.e. once a vCPU was created that page was stuck.  For nested
virtualization pages, the probability of being able to migrate a page at any given
time might be relatively low, but it's extremely unlikely for a page to be pinned
for the entire lifetime of a (L1) VM.

> I agree that in the first round of the nVMX code there were bugs. And
> sure, of *course* it isn't sufficient to wire up the invalidation
> without either a KVM_REQ_SOMETHIMG to put it back, or just a *check* on
> the corresponding gpc on the way back into the guest. We'd have worked
> that out.

Maybe.  I spent most of a day, maybe longer, hacking at the nVMX code and was
unable to get line of sight to an end result that I felt would be worth pursuing.

I'm definitely not saying it's impossible, and I'm not dead set against
re-introducing KVM_GUEST_USES_PFN or similar, but a complete solution crosses the
threshold where it's unreasonable to ask/expect someone to pick up the work in
order to get their code/series merged.

Which is effectively what you said below, I just wanted to explain why I'm pushing
to remove KVM_GUEST_USES_PFN, and to say that if you or someone else were to write
the code it wouldn't be an automatic nak.

> And yes, the gpc has had bugs as we implemented it, but the point was
> that we got to something which *is* working, and forms a usable
> building block.
>
> So I'm not really sold on the idea of ditching KVM_GUEST_USES_PFN. I
> think we could get it working, and I think it's worth it. But my
> opinion is worth very little unless I express it in 'diff -up' form
> instead of prose, and reverting this particular patch is the least of
> my barriers to doing so, so reluctantly...

