Return-Path: <kvm+bounces-38473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D1AA3A5B6
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 19:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7D5418965B6
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6391F5838;
	Tue, 18 Feb 2025 18:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x4fOUhev"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E302E1EB5E8
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 18:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739903613; cv=none; b=athTSBFhYGmt5qzjmPJu/wUHiAVMjApDvjDKok5DgOMhpQAVjfqyvgqu7s1ymnde426g4t/PHM2/sQax4tcPZfu23h4/sugRGzOmop4GpCH4C8zBQ5Qo/a6rO/bcQSgPTWJU16KOSOB9IW18zrnXHnMPDsV0sgbC8TNcsmwnOLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739903613; c=relaxed/simple;
	bh=ti3yr2A/5iAPyTvCN7LoMdLTMISr8vOEEWZ2ctY2bwc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E/8Q+YOCZwlRtO/1CJHhPktOahYXolCFTQfifhTRTsGkm0zRgo5WTJotOXoL04w2o0/sOCxdkPYe+ewVDzoomyTyeYVsERzwqr0rspngASsmNtPPnleJrnKc9v2sSdT2jzHeAdbPKVHqCAsWSSYKZtymTwvt/eOHR9TWF8vsslg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x4fOUhev; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc45101191so6058468a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 10:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739903611; x=1740508411; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RXlNUKi1nXILcNxScCTGDcCAb7tkH8J9nCCjyi/czMs=;
        b=x4fOUhevmn+gPtDKJpMuIKN7MvU6n41muA60MhraQIu3iyD1sFXmJbtwgbLjBz271a
         Gf067RpOTdCtwjSEMtMhfqkVSCkazZ0ZkjF3UVB1nDFnwzydsb1Q2d2kg3uGZv67/t+5
         VFhXGclFIuGsli6EyBGLoAOI3KovtUg28dL0/925vNRYDIVYKJr2bZHqkWMfSjIw0Z69
         XSApq/RGpvz+8sw77ohHSVQy51yvUXMGPyh7kxo4AtQbVPBDEsrf68z0nBgZkKaQFE6u
         0w5tUkcaA07Fs+AxCJQcUsWgjRDBB0+Q1EXbta5RuNCULIu3qVjJrMSFEdo6NFmhE2BN
         yv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739903611; x=1740508411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RXlNUKi1nXILcNxScCTGDcCAb7tkH8J9nCCjyi/czMs=;
        b=aYloVpOI4WmSW40r6Ylv7hz9kxKLA1gLKfWdvuZKVxmNGwquPb386WhxeZROB/+xiS
         yI3AT7AANZBawTYM3k6segtgH/5e0I2wiNrET/leRQVVh8LLWYwRvB6kMDAz4vWI8EWo
         6mtaHT/HAkHmy87s/CpugxSzwBzhnY2lZfIMXNa0Z+DpUf9f2WJT3a3GtOaxiS6LCieM
         2rqe56Imh+uMe8pY3F+X41TH/wGMzpyOOoTVLv4vNYMUd7XH1kOjNZ3zwDYnVJSmDrOM
         Hia3laVNJNCCwFvmEHJtt1wFG/TvBtDxfNs3XrXBcsyFUIEYTewH3c3NmclTt2GAe4Z/
         pezw==
X-Forwarded-Encrypted: i=1; AJvYcCVpjiPp5NIWco+KKFhEjJtJ450iVvvK36UeeH8vU686wpqSBvCLKJQiyLgjewkadU8HlXo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx694yabybT6DA056R1DVNN573Oxwkeu9xu+HLu+5DFKOzmrOz5
	hXekvfwkYHOn0NdnmudBdPr5lbhc/EssJgEvH1LRC2/s0xzIOuXQP3MHfUOsRbLLVmG3LmcbN3V
	P+w==
X-Google-Smtp-Source: AGHT+IEcW7Bb+oVUdOJFQR7wversG/+Mi/U5uft9ooKkzX2p+pew6XYKq/ofkOd7HS18VAqSMoPIlTSlOmw=
X-Received: from pfbfr18.prod.google.com ([2002:a05:6a00:8112:b0:730:76c4:7144])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:14c2:b0:730:9659:ff4b
 with SMTP id d2e1a72fcca58-732618e4fccmr18645840b3a.19.1739903611200; Tue, 18
 Feb 2025 10:33:31 -0800 (PST)
Date: Tue, 18 Feb 2025 10:33:29 -0800
In-Reply-To: <gxyvqeslwhw6dirfg7jb7wavotlguctnxf5ystqfcnn5mk74qa@nlqbruetef22>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207233410.130813-1-kim.phillips@amd.com> <20250207233410.130813-3-kim.phillips@amd.com>
 <4eb24414-4483-3291-894a-f5a58465a80d@amd.com> <Z6vFSTkGkOCy03jN@google.com>
 <6829cf75-5bf3-4a89-afbe-cfd489b2b24b@amd.com> <Z66UcY8otZosvnxY@google.com> <gxyvqeslwhw6dirfg7jb7wavotlguctnxf5ystqfcnn5mk74qa@nlqbruetef22>
Message-ID: <Z7TSef290IQxQhT2@google.com>
Subject: Re: [PATCH v3 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Kim Phillips <kim.phillips@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kishon Vijay Abraham I <kvijayab@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 17, 2025, Naveen N Rao wrote:
> On Thu, Feb 13, 2025 at 04:55:13PM -0800, Sean Christopherson wrote:
> > On Thu, Feb 13, 2025, Kim Phillips wrote:
> > > On 2/11/25 3:46 PM, Sean Christopherson wrote:
> > > > On Mon, Feb 10, 2025, Tom Lendacky wrote:
> > > > > On 2/7/25 17:34, Kim Phillips wrote:
> > 
> > Third, letting userspace opt-in to something doesn't necessarily mean giving
> > userspace full control.  Which is the entire reason I asked the question about
> > whether or not this can break userspace.  E.g. we can likely get away with only
> > making select features opt-in, and enforcing everything else by default.
> > 
> > I don't think RESTRICTED_INJECTION or ALTERNATE_INJECTION can work without KVM
> > cooperation, so enforcing those shouldn't break anything.
> > 
> > It's still not clear to me that we don't have a bug with DEBUG_SWAP.  AIUI,
> > DEBUG_SWAP is allowed by default.  I.e. if ALLOWED_FEATURES is unsupported, then
> > the guest can use DEBUG_SWAP via SVM_VMGEXIT_AP_CREATE without KVM's knowledge.
> 
> In sev_es_prepare_switch_to_guest(), we save host debug register state 
> (DR0-DR3) only if KVM is aware of DEBUG_SWAP being enabled in the guest 
> (via vmsa_features). So, from what I can tell, it looks like the guest 
> will end up overwriting host state if it enables DEBUG_SWAP without 
> KVM's knowledge?
> 
> Not sure if that's reason enough to enforce ALLOWED_SEV_FEATURES for 
> DEBUG_SWAP :)
> 
> If ALLOWED_SEV_FEATURES is not supported, we may still have to 
> unconditionally save the host DR0-DR3 registers.

Aha!  We do not.  The existing KVM code is actually flawed in the opposite
direction, in that saving host DR0..DR3 during sev_es_prepare_switch_to_guest()
is superfluous.

DR7 is reset on #VMEXIT (swap type "C"), and so KVM only needs to ensure DR0..DR3
are restored before loading DR7 with the host's value.  KVM takes care of that in
common x86 code via hw_breakpoint_restore().

However, there is still a bug, as the AMD-specific *masks* are not restored.  KVM
doesn't support MSR_F16H_DRx_ADDR_MASK emulation or passthrough for normal guests,
so the guest can't set those values either, i.e. will get a #VC.  But the masks
do need to be restored, because the CPU will clobber them with '0' when DebugSwap
is enabled.

And of course the DR0..DR3 loads in sev_es_prepare_switch_to_guest() are a
complete waste of cycles.

*sigh*

Ugh, it gets worse.  The awfulness goes in both direction.  Unless I've misunderstood
how this all works, just because *KVM* enables DebugSwap for the BSP doesn't mean
the guest will enable DebugSwap for APs.  And so KVM _can't_ rely on DebugSwap to
actually swap DR0..DR3, because KVM has no way of knowing whether or not a given
vCPU actually has it enabled.  And that's true even when SEV_ALLOWED_FEATURES
comes along, which means treating DR0..DR3 as swap type B is utterly worthless.

What a mess.  I'll send a small series to try and clean things up.

Also, I told y'all so: https://lore.kernel.org/all/YWnbfCet84Vup6q9@google.com

P.S. Can someone please get the APM updated to actually explain WTF enabling
     Debug Virtualization in SEV_FEATURES does?  The APM does not at all match
     what y'all have told me.  A sane reading of the APM would be that DRs are
     *unconditionally* swap type B when DebugSwap is supported, whereas I've been
     told from the very beginning[*] that treating them as type B requires software
     enabling:

         AMD Milan introduces support for the swapping, as type 'B', of DR[0-3]
         and DR[0-3]_ADDR_MASK registers. It requires that SEV_FEATURES[5] be set
         in the VMSA.

[*] https://lore.kernel.org/all/20221201021948.9259-3-aik@amd.com

