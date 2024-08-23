Return-Path: <kvm+bounces-24962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 887DD95D9D7
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40EA62844A8
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4CA1C93B9;
	Fri, 23 Aug 2024 23:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NZJ3KtQ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1366149C4C
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724456807; cv=none; b=RAq2J5c4D0nYcIRTQFPr+/sO1w0gwt5FQ0StQQHWR0s5EkmOpGWwfF/18ci1l9Qf5qP1VpskRmfn/3iaXZ5nTEUvrYFg4+HfO2fE9GdunhFiT9jzrJ/8ASCX8tGc3HpOFkbxCBbEJhYZrYZKP1xxI/wpRDE2Y6ryOD3brlKy4rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724456807; c=relaxed/simple;
	bh=dHOchrkL6fAecNkuUUXA3/+o41T9FjUdMVi/uBBrCmw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h6SfLiDfRPNG7P+h2Yo9O6evcHgkXWh+0Ud1YCmiXoEZIDCK3z9UuG3s7UFd0dth6JRxPGw/XYAphzScLlm6TwnKLascBXJ3ZXolx42KSc5uE89mpOz0aoF2160FMqYy+KhIJS1lJXnB5P8yhrzdlzCNMpIxbQeqT+KPebRh6mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NZJ3KtQ6; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b2249bf2d0so51666827b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724456805; x=1725061605; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N3H6wXI36PqvYyb5KsmlapRLwsCWfbVGz3QYy6oSpQU=;
        b=NZJ3KtQ62Bh99lMs79hLZE49yvL7zSQzSYaLmRdqGwyeU+dVt3Q3XVVT2l0Jt3h749
         3euknddmk95cT0L3LtJjFoasxe5Y35/00YUgyS6NjEToCM/EM8LqAkwGU8AvnRlyTUT7
         1kl1U53+7G0NkUTX9+WZY7VsU67M0BHdAVOs3kax0ts6ABkQ0DfJiPIg8WrhZMNeVni8
         xwtAhLXxQGDag/oIWbQtYP0HTLC2nbOfVFps4NeLuKpRnpsb7V0PDghjq1BkWf6vZK5S
         xuTT1sNDNDhM7VODpWPASeB6nVvYrTzwAhKwN9ZVse6i8f3ZYWDRrVv/IM1q5WFu8KCG
         h1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724456805; x=1725061605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3H6wXI36PqvYyb5KsmlapRLwsCWfbVGz3QYy6oSpQU=;
        b=kRQ4XlOFxyxdamuJaJap36AfPLAQ77XvF3gllha6VMLCKSigb+WTSld6WEHoEaULy+
         xpU/yhJJwCq37TBtUxYFhf/PgXuyUmT3WF+7LDPMo3j5j6rBGIWUqQSJFmzo7n3/NhZV
         koVFLwLMo+6g5U4Hv7UVgMqT9uaslBAYzY2UlrH+ryI2M2UdLD105R8doEY2IixdDi49
         0W9H3mtD4MxJYi2VOGcb0u7Tj1EUEOUqalwr0u/BYiYf2P6vKu4RM/vtUt6r5x3JbSYy
         zsCIVovi6xPAiygbeCoVlSU6772SHYTBi6Y1xM9U609+l46qfIjLx8TH2JwbuXia1SY3
         47hg==
X-Forwarded-Encrypted: i=1; AJvYcCUvE+Wn+SRLxtoNvXRho7U58f5Yg52hKjXz6UTmPi+T2hIto943owsGxZQIs+268f4U0Bc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhgS5W1QloqafOg991ucoXULEWxzzS8aneot0qPf+H9frClWoi
	0SsxFo47oAb/JPqcc+KtkKnhqVjH6QZSInwnACwCquQfXLo1yAGPYue48aKc7FqPw1koost/Cc9
	uvw==
X-Google-Smtp-Source: AGHT+IHdhH8ITRv9cW8KgH5/tqkfKTR20I9VNYg2JDiGnFwPr7gUYlsI7lzp5a8sI4DElo4dVOJ70r/0NWw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2a92:b0:62d:1142:83a5 with SMTP id
 00721157ae682-6c62943b009mr76967b3.8.1724456804696; Fri, 23 Aug 2024 16:46:44
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:46:43 -0700
In-Reply-To: <ZsfaMes4Atc3-O7h@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-5-seanjc@google.com>
 <20240814142256.7neuthobi7k2ilr6@yy-desk-7060> <6fsgci4fceoin7fp3ejeulbaybaitx3yo3nylzecanoba5gvhd@3ubrvlykgonn>
 <ZsfaMes4Atc3-O7h@google.com>
Message-ID: <ZskfY2XOken50etZ@google.com>
Subject: Re: [PATCH 04/22] KVM: x86/mmu: Skip emulation on page fault iff 1+
 SPs were unprotected
From: Sean Christopherson <seanjc@google.com>
To: Yao Yuan <yaoyuan0329os@gmail.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 22, 2024, Sean Christopherson wrote:
> On Fri, Aug 16, 2024, Yao Yuan wrote:
> > On Wed, Aug 14, 2024 at 10:22:56PM GMT, Yuan Yao wrote:
> > > On Fri, Aug 09, 2024 at 12:03:01PM -0700, Sean Christopherson wrote:
> > > > When doing "fast unprotection" of nested TDP page tables, skip emulation
> > > > if and only if at least one gfn was unprotected, i.e. continue with
> > > > emulation if simply resuming is likely to hit the same fault and risk
> > > > putting the vCPU into an infinite loop.
> > > >
> > > > Note, it's entirely possible to get a false negative, e.g. if a different
> > > > vCPU faults on the same gfn and unprotects the gfn first, but that's a
> > > > relatively rare edge case, and emulating is still functionally ok, i.e.
> > > > the risk of putting the vCPU isn't an infinite loop isn't justified.
> > > >
> > > > Fixes: 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++++++++--------
> > > >  1 file changed, 20 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index e3aa04c498ea..95058ac4b78c 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -5967,17 +5967,29 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > > >  	bool direct = vcpu->arch.mmu->root_role.direct;
> > > >
> > > >  	/*
> > > > -	 * Before emulating the instruction, check if the error code
> > > > -	 * was due to a RO violation while translating the guest page.
> > > > -	 * This can occur when using nested virtualization with nested
> > > > -	 * paging in both guests. If true, we simply unprotect the page
> > > > -	 * and resume the guest.
> > > > +	 * Before emulating the instruction, check to see if the access may be
> > > > +	 * due to L1 accessing nested NPT/EPT entries used for L2, i.e. if the
> > > > +	 * gfn being written is for gPTEs that KVM is shadowing and has write-
> > > > +	 * protected.  Because AMD CPUs walk nested page table using a write
> > 
> > Hi Sean,
> > 
> > I Just want to consult how often of this on EPT:
> > 
> > The PFERR_GUEST_PAGE_MASK is set when EPT violation happens
> > in middle of walking the guest CR3 page table, and the guest
> > CR3 page table page is write-protected on EPT01, are these
> > guest CR3 page table pages also are EPT12 page table pages
> > often?  I just think most of time they should be data page
> > on guest CR3 table for L1 to access them by L1 GVA, if so
> > the PFERR_GUEST_FINAL_MASK should be set but not
> > PFERR_GUEST_PAGE_MASK.
> 
> Hmm, now I'm confused too.  I thought this was handling the case where L1 is
> accessing EPT12/NTP12 entries, but as you say, that doesn't make sense because
> those accesses would be PFERR_GUEST_FINAL_MASK.  And the EPT12/NPT12 entries
> should never be used by hardware.
> 
> The only thing that I can think of is if L1 stops using the pages for EPT/NPT
> entries, and instead reallocates them for IA32 page tables.  But that doesn't
> make much sense either, because KVM's write-flooding detection should kick in
> when L1 repurposes the page for its own page tables, before L1 actually starts
> using the page tables.
> 
> I'll try to reproduce the excessive emulation that this code is handling, because
> I think I'm missing something too.

*sigh*

After poking for an hour and never being able to hit that error code, _period_,
even if without the vcpu->arch.mmu->root_role.direct guard, I came to the conclusion
that the only way to hit this is if L1 is reusing its own page tables for L2.

And then I finally wised up and went hunting on lore, and indeed that appears to
be what this is trying to handle[1]:

 : I think this patch is necessary for functional reasons (not just perf),
 : because we added the other patch to look at the GPA and stop walking the
 : guest page tables on a NPF.
 : 
 : The issue I think was that hardware has taken an NPF because the page
 : table is marked RO, and it saves the GPA in the VMCB.  KVM was then
 : going and emulating the instruction and it saw that a GPA was available.
 : But that GPA was not the GPA of the instruction it is emulating, since
 : it was the GPA of the tablewalk page that had the fault. It was debugged
 : that at the time and realized that emulating the instruction was
 : unnecessary so we added this new code in there which fixed the functional
 : issue and helps perf.
 : 
 : I don't have any data on how much perf, as I recall it was most effective
 : when the L1 guest page tables and L2 nested page tables were exactly the
 : same.  In that case, it avoided emulations for code that L1 executes which
 : I think could be as much as one emulation per 4kb code page.

To muddy the waters more, the vcpu->arch.mmu->root_role.direct was a proactive
suggestion from Paolo[2], i.e. not in response to an actual failure that someone
encountered.

Further adding to the confusion was Paolo's commit that extended the behavior
to Intel CPUs.  The AuthorDate vs. CommitDate is particularly interesting, as
it suggests that Paolo wrote the patch in response to the SVM series being
posted:

  Subject: [PATCH v2 1/3] kvm: svm: Add support for additional SVM NPF error codes
  Date: Wed, 23 Nov 2016 12:01:38 -0500	[thread overview]

  commit eebed2438923f8df465c27f8fa41303771fdb2e8
  Author:     Paolo Bonzini <pbonzini@redhat.com>
  AuthorDate: Mon Nov 28 14:39:58 2016 +0100

and then commited after asking many of the same questions we just asked, with
Brijesh's reply[1] coming just a few days before:

  Subject: Re: [PATCH v2 1/3] kvm: svm: Add support for additional SVM NPF error codes
  Date: Wed, 2 Aug 2017 12:42:20 +0200	[thread overview]


  Commit:     Paolo Bonzini <pbonzini@redhat.com>
  CommitDate: Thu Aug 10 16:44:04 2017 +0200

    kvm: nVMX: Add support for fast unprotection of nested guest page tables
    
    This is the same as commit 147277540bbc ("kvm: svm: Add support for
    additional SVM NPF error codes", 2016-11-23), but for Intel processors.
    In this case, the exit qualification field's bit 8 says whether the
    EPT violation occurred while translating the guest's final physical
    address or rather while translating the guest page tables.


  Subject: [PATCH v2 1/3] kvm: svm: Add support for additional SVM NPF error codes
  Date: Wed, 23 Nov 2016 12:01:38 -0500	[thread overview]

Intel support is especially misleading, because sharing page tables between EPT
and IA32 is rather nonsensical due to them having different formats.  I.e. I doubt
Paolo had a use case for the VMX changes, and was just providing parity with SVM.
Of course, reusing L1's page tables as the NPT tables for L2 is quite crazy too,
but at least the PTE formats are identical. 

Given that the patches were original posted as part the SEV enabling series[3],
my best guest is that the AMD folks were doing some prototyping or emulation
hackery that involved running a nested guest by simply reusing CR3 as hCR3.

So, I'll rewrite the comment to make it clear that practically speaking, this
scenario can be hit if and only if L1 is reusing its own page tables for L2's NPT.

[1] https://lore.kernel.org/all/f8a2c258-0b53-b33c-1dae-a6f6e0e68239@amd.com
[2] https://lore.kernel.org/all/21b9f4db-f929-80f6-6ad2-6fa3b77f82c0@redhat.com
[3] https://lore.kernel.org/all/147190822443.9523.7814744422402462127.stgit__43469.155036337$1471909238$gmane$org@brijesh-build-machine

