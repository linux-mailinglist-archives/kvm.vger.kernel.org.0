Return-Path: <kvm+bounces-17816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A4AD8CA55F
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 02:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 459D9281A2F
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 00:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF44B67E;
	Tue, 21 May 2024 00:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7ZG0Op0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD803D6A
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 00:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716251419; cv=none; b=AQLwM3yEaWxaFOXstZYem+Oh5zisedbmYpEh4LgFRNBTcxrkQkScaQ24yldfrrnezUje7YwzpU2cPWk6EgT6gtA8MHl7igLwtwr591DjnW0MxulX4d2ljtU3uEM2hEHPXFnij3TTkhp+zlII8BoQMLKw4GsonkPcEKb0vCs57d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716251419; c=relaxed/simple;
	bh=R8w20wrWhAHj76bvR9zKsPMgoXSmLDWN8EM25FYEDfU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rm7y0Rx1e41/EDGXNtiytZa+z9I2VstfN/SWDth0lt9NpPrJNLHxUtnq4C9s51kjdCHVASasZWcKsRHJcspuHi13vxvhs2VJ9yZrd3noulkl78qjKfIbBCAsP3bp77ApWfaMwOpnTaSFaPVkebpbv0PS58dtvCfjFHz2G18AlYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d7ZG0Op0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-622ccd54587so192465367b3.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716251417; x=1716856217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ptfnRWr6+WaSf97cvh4fEBETpjMq9qszm8kFWwt98g=;
        b=d7ZG0Op0aS7Gf9u4DW+qwFtpz2LCmWYCidyjGFKVBjOIJljrGFDN2RHhEBV4c4NkSZ
         SyxXJ83u/baWjsW3apzQ6QTB5cmnviIemsZKB9XqDX5pW+5n9Fms7o/6ITA21ial3kGO
         MIVEsJo+grQX8ABfhfwJf8xg08dqCqE3sevf3yKx6/3SqT4HCuTHUSDrpayaPa8tUAja
         wxSE7OxOmNYjiW7mFINJmZveErhLYQEk1ivkdvFKMdf5rvU7ggK0iLasuxNK2946yxIm
         Rg+QkKqWjb5fWL4Mb0WLvx4CN5XEXblJey0bZ2GgIpyMwyRPhhPdG1X0zEfl0DpPn5VY
         +n0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716251417; x=1716856217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ptfnRWr6+WaSf97cvh4fEBETpjMq9qszm8kFWwt98g=;
        b=Z/PwfMQUEzERH0U3vFvb8SUow2o6tyQmwKqBith4A76ArLBaJZlA9OqAIxH+c2MP/8
         mpAYMXaE4Eqn+77AN/qUwVLQqZtp5AgW41DcQLNXrO2/JBfPKWVbdTDGvaJhtqpjrdeY
         nNJPfC0ofc2HLR+ZQw0JzwvSiqoSlpfmJV3wSVN433irXa8x9rixnCJIK4+IYqlMSkB8
         PK/oDVLvV5/keu74hMNgte7TTjQ2ICs3jooeKL2C20afY/90H/faMi9eHBiFwnLiPJTZ
         XztykZLu2EdSmITZoP9UFlh9fKAj/pzZ5Ml0lAt4HRPZgB3BZrKATMcNSnRhKOkFxFqK
         PXbg==
X-Forwarded-Encrypted: i=1; AJvYcCU0wMoPIgiC4hI1kx2DmNhx9O5qv2LhPeZCqL32J/knkykMxskE5oOEzqftF5mNgfll32WaUv/6mxiGvm1LvUVrbnYa
X-Gm-Message-State: AOJu0YzMHssrU9SOnhXZXZVbnrt8Y+F7LFggiV+feHpij0JFxaN3GANz
	0FvEmoy7qrw9iv9VZDcU4irQ0BfHGIVLnTR+brGw7hBrFMYYuzqkQKjmaJbxfoov7+58JMOabtO
	/yQ==
X-Google-Smtp-Source: AGHT+IGATBiWxOmW/cqDglHQgdjt/m1Tibs8w8tsXY3vEs4VxyaK5Qg0aR3gdp+bWKqZMm0eBuFbJ1ZMUNM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c01:b0:de5:2694:45ba with SMTP id
 3f1490d57ef6-dee4f104643mr7926731276.0.1716251417124; Mon, 20 May 2024
 17:30:17 -0700 (PDT)
Date: Mon, 20 May 2024 17:30:15 -0700
In-Reply-To: <1ce87335-2ea7-41c4-8442-36210656cdca@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-14-michael.roth@amd.com> <41d8ba3a48d33de82baa67ef5ee88e5f8995aea8.camel@intel.com>
 <ZkuJ27DKOCkqogHn@google.com> <e771a7ba-0445-483e-9c42-66bd5b331dce@intel.com>
 <ZkvZkPvHqqPnVa9k@google.com> <1ce87335-2ea7-41c4-8442-36210656cdca@intel.com>
Message-ID: <ZkvrFw1QMtImegQD@google.com>
Subject: Re: [PATCH v15 13/20] KVM: SEV: Implement gmem hook for initializing
 private pages
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"tobin@ibm.com" <tobin@ibm.com>, "liam.merwick@oracle.com" <liam.merwick@oracle.com>, 
	"alpergun@google.com" <alpergun@google.com>, Tony Luck <tony.luck@intel.com>, 
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org" <luto@kernel.org>, 
	"ak@linux.intel.com" <ak@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"pgonda@google.com" <pgonda@google.com>, 
	"srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>, "slp@redhat.com" <slp@redhat.com>, 
	"rientjes@google.com" <rientjes@google.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>, Jorg Rodel <jroedel@suse.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, 
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "kirill@shutemov.name" <kirill@shutemov.name>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "ardb@kernel.org" <ardb@kernel.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, May 21, 2024, Kai Huang wrote:
> On 21/05/2024 11:15 am, Sean Christopherson wrote:
> > On Tue, May 21, 2024, Kai Huang wrote:
> > > On 21/05/2024 5:35 am, Sean Christopherson wrote:
> > > > On Mon, May 20, 2024, Kai Huang wrote:
> > > > > I am wondering whether this can be done in the KVM page fault handler?
> > > > 
> > > > No, because the state of a pfn in the RMP is tied to the guest_memfd inode,
> > > > not to the file descriptor, i.e. not to an individual VM.
> > > 
> > > It's strange that as state of a PFN of SNP doesn't bind to individual VM, at
> > > least for the private pages.  The command rpm_make_private() indeed reflects
> > > the mapping between PFN <-> <GFN, SSID>.
> > 
> > s/SSID/ASID
> > 
> > KVM allows a single ASID to be bound to multiple "struct kvm" instances, e.g.
> > for intra-host migration.  If/when trusted I/O is a thing, presumably KVM will
> > also need to share the ASID with other entities, e.g. IOMMUFD.
> 
> But is this the case for SNP?  I thought due to the nature of private pages,
> they cannot be shared between VMs?  So to me this RMP entry mapping for PFN
> <-> GFN for private page should just be per-VM.

Sorry to redirect, but please read this mail (and probably surrounding mails).
It hopefully explains most of the question you have.

https://lore.kernel.org/all/ZLGiEfJZTyl7M8mS@google.com

> > Regardless of whether or not guest_memfd supports page migration, KVM needs to
> > track the state of the physical page in guest_memfd, e.g. if it's been assigned
> > to the ASID versus if it's still in a shared state.
> 
> I am not certain this can impact whether we want to do RMP commands via
> guest_memfd() hooks or TDP MMU hooks?
>
> > > If we truly want to zap private mappings for SNP, IIUC it can be done by
> > > distinguishing whether a VM needs to use a separate private table, which is
> > > TDX-only.
> > 
> > I wouldn't say we "want" to zap private mappings for SNP, rather that it's a lot
> > less work to keep KVM's existing behavior (literally do nothing) than it is to
> > rework the MMU and whatnot to not zap SPTEs.
> 
> My thinking too.
> 
> > And there's no big motivation to avoid zapping because SNP VMs are unlikely
> > to delete memslots.
> 
> I think we should also consider MMU notifier?

No, private mappings have no host userspace mappings, i.e. are completely exempt
from MMU notifier events.  guest_memfd() can still invalidate mappings, but that
only occurs if userspace punches a hole, which is destructive.

> > If it turns out that it's easy to preserve SNP mappings after TDX lands, then we
> > can certainly go that route, but AFAIK there's no reason to force the issue.
> 
> No I am certainly not saying we should do SNP after TDX.  Sorry I didn't
> closely monitor the status of this SNP patchset.
> 
> My intention is just wanting to make the TDP MMU common code change more
> useful (since we need that for TDX anyway), i.e., not effectively just for
> TDX if possible:
> 
> Currently the TDP MMU hooks are called depending whether the page table type
> is private (or mirrored whatever), but I think conceptually, we should
> decide whether to call TDP MMU hooks based on whether faulting GPA is
> private, _AND_ when the hook is available.
> 
> https://lore.kernel.org/lkml/5e8119c0-31f5-4aa9-a496-4ae10bd745a3@intel.com/
> 
> If invoking SNP RMP commands is feasible in TDP MMU hooks,

Feasible.  Yes.  Desirable?  No.  Either KVM tracks the state of the physical page
using the guest_memfd inode, or KVM _guarantees_ the NPT mappings _never_ get
dropped, including during intra-host migration.  E.g. to support intra-host
migration of TDX VMs, KVM is pretty much forced to transer the S-EPT tables as-is,
which is ugly and painful (though performant).  We could do the same for NPT, but
there would need to be massive performance benefits to justify the complexity.

> then I think there's value of letting SNP code to use them too.  And we can
> simply split one patch out to only add the TDP MMU hooks for SNP to land
> first.

