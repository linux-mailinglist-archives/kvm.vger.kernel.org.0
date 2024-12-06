Return-Path: <kvm+bounces-33233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 849BD9E7BD5
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 23:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 637FF16B00C
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 22:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F23FF22C6F6;
	Fri,  6 Dec 2024 22:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mJCamlNN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A654F212FB6
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733524244; cv=none; b=nPaoOC5iWm2TDMHHlbBI/Qv3I3jeIHp/ILpBnseaXQwc21c2cfj7sVvrYFKtp3JRWJQOLkNKqK7qJwT4OeypjuWNifSfAtO73aOaaZdjHw3DyyN6FCbv4vX7TENn3fH06YRBUbMbj5V4stNN4wyiDl1CZITddXXILrmf0RdT2eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733524244; c=relaxed/simple;
	bh=SPeVPwKrzLZek5GfDo09DmwTHKr5Y70YVXjOj9s53bc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SjxiZaDSch+XwDPd1GpYVkbnpW6eEG8y1x1J9NiuREAyYhPzoiiq2nILt1zqgDPkrSYy6HZLaFYsuRSz/z+o5DbSAS0Gvv/kUW0Rmm943K8YL4sANBM6VIpAWR7zPrkoXIx4gvveXjrVsaviPh/c1OfA4oh+33+YQJDysnLPUnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mJCamlNN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef73159d6fso1140047a91.1
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2024 14:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733524242; x=1734129042; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ehs/f+RINRe38P2riAl7HuSD689ga4M8osV1LhPlfjY=;
        b=mJCamlNNd349GsAanrLFL26GdyDnzJC/24o2sAMJ4a/8tWTc7fJWdVio1vmhEQ++0u
         TQ8iTgwoNfzMAqAnR6p3o8otf0+ulBAn8URxOmABbYvr85Ha1436oEoPK59RxQYVJXE8
         ecuvYvYULjvICV9vCILhPDPWCNT8FWFKgOaBVZdPjb0MO1MLoJOXWbsCZQW9i11GJ72S
         HJa2pfF10QYLODJChkenWZY/FCwourSqRLgJvbS56H+QScgUiprw0HCtVoBuMkSJEEVS
         hslc3mPIwrd8lQ8AHpJzDVymDJ2gbBEuu2HdnQqfT99WU1f3vJ3SaOiA/73bqsnFTAy7
         Pz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733524242; x=1734129042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ehs/f+RINRe38P2riAl7HuSD689ga4M8osV1LhPlfjY=;
        b=Bd+uwoVkE6kfQfHC+UL8PvQPmQuIlK+hqkwPtBRBLBadDCgvQTDXEq2wLJ6kv+So/4
         UsbELa/WXHEGwhThKxt8rU9Lw8AdB8/pwyUID7Lvq+W0WsmXYWITQUUO8bi6A3EVuEyv
         47e/AGSZkNZCTW/qQH/ELk/eZoSmcox+f4n+oNxT5fOTvv8S+lvZmjmIbbgDbZBeUm+r
         ToToBTVBjt81VWmK2ZXDi7rZO5jGxEeZWLU0fBj+TTifAc/DqckuUyqGXuqe7WqZKDgg
         JA+QLsMFpwWHMo8Sg6es6owvQQQAa4TMh9N8LtoYDcaxfoo+UrZlrB9G2vZWFNqsfa5L
         OO9g==
X-Forwarded-Encrypted: i=1; AJvYcCWXMADj00lp/y6mFd9jYXFMdEGGC7/uI4ej3+pmLf5TLGPwpsgLWc3V3L8l5RzKu3Aha0E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbg0lzE417jzxjOdVpJMzV70Su7Ks5dwWe2PBT6qdXe4Xzj/Kv
	tZZ9m6iuaeLHvQUZfS7jTxAmfUlpsFwt9X4efLBqWn/9xnKzdqy5YgIcQv6SDb5FL7FhS2f51C9
	4QQ==
X-Google-Smtp-Source: AGHT+IG7KwTlm9La7VaJupYFQcMsbRhngIakjharI0ZpEaG+VpJ37f7N0AvvnzDB+FaakyJbiNolQI288ZY=
X-Received: from pjbsd7.prod.google.com ([2002:a17:90b:5147:b0:2ea:5c73:542c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53c7:b0:2ee:c059:7de3
 with SMTP id 98e67ed59e1d1-2ef6a6bc29bmr7467563a91.18.1733524242063; Fri, 06
 Dec 2024 14:30:42 -0800 (PST)
Date: Fri, 6 Dec 2024 14:30:40 -0800
In-Reply-To: <7ea2b3e8-56b7-418f-8551-b905bf10fecb@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com> <ZwlMojz-z0gBxJfQ@google.com>
 <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com> <Zz5aZlDbKBr6oTMY@google.com>
 <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com> <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com>
 <Zz9mIBdNpJUFpkXv@google.com> <cb62940c-b2f7-0f3e-1710-61b92cc375e5@amd.com>
 <Zz9w67Ajxb-KQFZZ@google.com> <7ea2b3e8-56b7-418f-8551-b905bf10fecb@amd.com>
Message-ID: <Z1N7ELGfR6eTuO6D@google.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au, 
	x86@kernel.org, john.allen@amd.com, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 21, 2024, Ashish Kalra wrote:
> On 11/21/2024 11:42 AM, Sean Christopherson wrote:
> > On Thu, Nov 21, 2024, Tom Lendacky wrote:
> >> On 11/21/24 10:56, Sean Christopherson wrote:
> >>> On Thu, Nov 21, 2024, Ashish Kalra wrote:
> >>> Actually, IMO, the behavior of _sev_platform_init_locked() and pretty much all of
> >>> the APIs that invoke it are flawed, and make all of this way more confusing and
> >>> convoluted than it needs to be.
> >>>
> >>> IIUC, SNP initialization is forced during probe purely because SNP can't be
> >>> initialized if VMs are running.  But the only in-tree user of SEV-XXX functionality
> >>> is KVM, and KVM depends on whatever this driver is called.  So forcing SNP
> >>> initialization because a hypervisor could be running legacy VMs make no sense.
> >>> Just require KVM to initialize SEV functionality if KVM wants to use SEV+.
> >>
> >> When we say legacy VMs, that also means non-SEV VMs. So you can't have any
> >> VM running within a VMRUN instruction.
> > 
> > Yeah, I know.  But if KVM initializes the PSP SEV stuff when KVM is loaded, then
> > KVM can't possibly be running VMs of any kind.
> > 
> >> Or...
> >>
> >>>
> >>> 	/*
> >>> 	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
> >>> 	 * so perform SEV-SNP initialization at probe time.
> >>> 	 */
> >>> 	rc = __sev_snp_init_locked(&args->error); 
> >>>
> >>> Rather than automatically init SEV+ functionality, can we instead do something
> >>> like the (half-baked pseudo-patch) below?  I.e. delete all paths that implicitly
> >>> init the PSP, and force KVM to explicitly initialize the PSP if KVM wants to use
> >>> SEV+.  Then we can put the CipherText and SNP ASID params in KVM.
> >>
> >> ... do you mean at module load time (based on the module parameters)? Or
> >> when the first SEV VM is run? I would think the latter, as the parameters
> >> are all true by default. If the latter, that would present a problem of
> >> having to ensure no VMs are active while performing the SNP_INIT.
> > 
> > kvm-amd.ko load time.
> 
> Ok, so kvm module load will init SEV+ if indicated by it's module parameters.
> 
> But, there are additional concerns here. 
> 
> SNP will still have to be initialized first, because SNP_INIT will fail if
> SEV INIT has been done.
> 
> Additionally, to support SEV firmware hotloading (DLFW_EX), SEV can't be
> initialized. 
> 
> So probably, we will have to retain some PSP style SEV+ initialization here,
> SNP_INIT is always done first and then SEV INIT is skipped if explicitly
> specified by a module param. This allows SEV firmware hotloading to be
> supported.
> 
> But, then with SEV firmware hotload support how do we do SEV INIT without
> unloading and reloading KVM module ?

So the above says:

 SEV_CMD_SNP_INIT{_ES} cannot be executed if SEV_CMD_INIT{_EX} has been executed.

but the existing comment in _sev_platform_init_locked() says:

	/*
	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
	 * so perform SEV-SNP initialization at probe time.
	 */

Which one is correct?  I don't think it matters in the end, just trying to wrap my
head around everything.

And IIUC, SEV_CMD_SNP_INIT{_EX} can be executed before firmware hotload, but
SEV_CMD_INIT{_EX} cannot.  Is that correct?  Because if firmware hotload can't
be done while SEV VMs are _active_, then that's a very different situation.

> This can reuse the current support (in KVM) to do SEV INIT implicitly when
> the first SEV VM is run: sev_guest_init() -> sev_platform_init() 

I don't love the implicit behavior, but assuming hotloading firmware can't be done
after SEV_CMD_INIT{_EX}, that does seem like the least awful solution.

To summarize, if the above assumptions hold:

 1. Initialize SNP when kvm-amd.ko is loaded.
 2. Define CipherTextHiding and ASID params kvm-amd.ko.
 3. Initialize SEV+ at first use.

Just to triple check: that will allow firmware hotloading even if kvm-amd.ko is
built-in, correct?  I.e. doesn't requires deferring kvm-amd.ko load until after
firmware hotloading.

