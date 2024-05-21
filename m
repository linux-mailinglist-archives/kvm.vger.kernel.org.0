Return-Path: <kvm+bounces-17864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E0F38CB4BD
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 22:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50DA71F22826
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 20:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6761494B9;
	Tue, 21 May 2024 20:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q8xTUZJh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D738F50269
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 20:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716323505; cv=none; b=Z6GR4LtEfoNkQAbvjJPlPanKJT1hytcFxiS2quj4FrlcFmH4A8pIfEWR4cRHpMRs+3iwxTbZcjwTGIwQkfWS0bZSI4x08oZ4g0kSYtot3gk6Z4AiFkBGgITmEikRMXT9o6Ifbm1wB4GlqiWmo05f7PUG3Th/B5xh3r9O2c4d9mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716323505; c=relaxed/simple;
	bh=QuUd2WIszBgiRLRMwosQW3GxJBwnIuQ7/If73ZyYbfA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TTnMwaL6F8UB2E5Q4H/HdqjofHp2Ond8pXMe1Nh62Fy5klcN5GeOaiJw25EE/6db/FVFGn0nziqWeg8hJMNa6dhwdLIIOpN5i02ObaSGwwasz5UaXQUXs8woL4LOUtgfcvnBk0Xl7QpyhIcsK/Bm+Sidxuqr/v0Uqd72ugGnzlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q8xTUZJh; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f46eb81892so12712911b3a.0
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 13:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716323503; x=1716928303; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RIxYIUY6xfa0Z61X8hb/LG8bYVX3fiRC8Zg5CcwCluY=;
        b=Q8xTUZJhveLvXkoO/x1fUOd7lVkYsmwGekVBSXOGvD7dOcNFBllInms6rwOKzACnzl
         ET+wZ0hm5g0QORofywxELACZAF6GOVfvKiNobkumnvSLli7p2gMJh2qrrA5fULNzAdNK
         gjqK4k11nClvwgtd2jHOeGYkurDSlZwJGoqhQPsViubV612do1xo1vGTSMKwvVsnJWSs
         3f0Dw1VZwLPzH4QyfnNx0WSE221vP0WW3x9cagaa8raPCearALdajpMK7fIR7NpY/Ts3
         jP8ruxTOZEoMVIXIKYJMFS4aAganq5VtCZNdcpCQ6iWwkIhMpRz4JhZqiOWqbnpXiKql
         m6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716323503; x=1716928303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RIxYIUY6xfa0Z61X8hb/LG8bYVX3fiRC8Zg5CcwCluY=;
        b=uE/MgoqFlfJiBgwZBvbD4adgt81AcXzDDGHWLZdUdwyFOGzC4irNMDlrcXESAruSIX
         PAzISakkgfb5W5Co/LA3FeJFoCdk/jX/XKYPs9I2c1cY5D89xdLpez647kEc185VDavs
         EzRludr4cblOWXuKibeReGBb3U0GDxO5ZdcfO5sTIEqCwLgBX7Sr3rbXmvG1BZaJHUMr
         DSOXms9cIzY2/76gLI6WtR0jEYSK0KVAfedQO1G6bi6W47pEaehp9Ia8IuJXVbrjwE6/
         Pvr2SNb/TUG5jW6kgvljDV4OJT6vEeSmNI4v9pVTuIrX+R1u9l5UVclqu1r2yWBMKDkw
         lIkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhKcRxVHdohr0oUgJu8xT8qT6RDMaoFWxbYmDVWUl5FTj239RxWLR4iZ/rzl7olWc/C40rXpeZEHUDxTeU3xMdA4/X
X-Gm-Message-State: AOJu0YxlQB3jfKK8ETKpgXBrGWd3EY/SEfs7XXNfJEOuoGPgosDYAVYC
	JSkp3nXNNFCwg/qYbp3+CrYXWhDXyY0aP921V84G3ZcPYkX4TRMgYMB4dBqYQXDd7c+/eXpHY3P
	Y1w==
X-Google-Smtp-Source: AGHT+IHh7glVSft5QaLCRrxXDi7uu5WLdc5qtZ1rOL0wAEurEIF+QY6zQhvvtTu4XmwUuxKFnuuMpe8K5ec=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e8f:b0:6f3:f447:57e1 with SMTP id
 d2e1a72fcca58-6f6d6002b65mr392b3a.1.1716323502715; Tue, 21 May 2024 13:31:42
 -0700 (PDT)
Date: Tue, 21 May 2024 13:31:41 -0700
In-Reply-To: <b66ea07a-f57e-014c-68b4-729f893c2fbd@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416050338.517-1-ravi.bangoria@amd.com> <ZjQnFO9Pf4OLZdLU@google.com>
 <9252b68e-2b6a-6173-2e13-20154903097d@amd.com> <Zjp8AIorXJ-TEZP0@google.com>
 <305b84aa-3897-40f4-873b-dc512a2da61f@amd.com> <ZkdqW8JGCrUUO3RA@google.com> <b66ea07a-f57e-014c-68b4-729f893c2fbd@amd.com>
Message-ID: <Zk0ErRQt3XH7xK6O@google.com>
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, michael.roth@amd.com, nikunj.dadhania@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 20, 2024, Ravi Bangoria wrote:
> On 17-May-24 8:01 PM, Sean Christopherson wrote:
> > On Fri, May 17, 2024, Ravi Bangoria wrote:
> >> On 08-May-24 12:37 AM, Sean Christopherson wrote:
> >>> So unless I'm missing something, the only reason to ever disable LBRV would be
> >>> for performance reasons.  Indeed the original commits more or less says as much:
> >>>
> >>>   commit 24e09cbf480a72f9c952af4ca77b159503dca44b
> >>>   Author:     Joerg Roedel <joerg.roedel@amd.com>
> >>>   AuthorDate: Wed Feb 13 18:58:47 2008 +0100
> >>>
> >>>     KVM: SVM: enable LBR virtualization
> >>>     
> >>>     This patch implements the Last Branch Record Virtualization (LBRV) feature of
> >>>     the AMD Barcelona and Phenom processors into the kvm-amd module. It will only
> >>>     be enabled if the guest enables last branch recording in the DEBUG_CTL MSR. So
> >>>     there is no increased world switch overhead when the guest doesn't use these
> >>>     MSRs.
> >>>
> >>> but what it _doesn't_ say is what the world switch overhead is when LBRV is
> >>> enabled.  If the overhead is small, e.g. 20 cycles?, then I see no reason to
> >>> keep the dynamically toggling.
> >>>
> >>> And if we ditch the dynamic toggling, then this patch is unnecessary to fix the
> >>> LBRV issue.  It _is_ necessary to actually let the guest use the LBRs, but that's
> >>> a wildly different changelog and justification.
> >>
> >> The overhead might be less for legacy LBR. But upcoming hw also supports
> >> LBR Stack Virtualization[1]. LBR Stack has total 34 MSRs (two control and
> >> 16*2 stack). Also, Legacy and Stack LBR virtualization both are controlled
> >> through the same VMCB bit. So I think I still need to keep the dynamic
> >> toggling for LBR Stack virtualization.
> > 
> > Please get performance number so that we can make an informed decision.  I don't
> > want to carry complexity because we _think_ the overhead would be too high.
> 
> LBR Virtualization overhead for guest entry + exit roundtrip is ~450 cycles* on

Ouch.  Just to clearify, that's for LBR Stack Virtualization, correct?

Ugh, I was going to say that we could always enable "legacy" LBR virtualization,
and do the dynamic toggling iff DebugExtnCtl.LBRS=1, but they share an enabling
flag.  What a mess.

> a Genoa machine. Also, LBR MSRs (except MSR_AMD_DBG_EXTN_CFG) are of swap type
> C so this overhead is only for guest MSR save/restore.

Lovely.

Have I mentioned that the SEV-ES behavior of force-enabling every feature under
the sun is really, really annoying?

Anyways, I agree that we need to keep the dynamic toggling.

But I still think we should delete the "lbrv" module param.  LBR Stack support has
a CPUID feature flag, i.e. userspace can disable LBR support via CPUID in order
to avoid the overhead on CPUs with LBR Stack.  The logic for MSR_IA32_DEBUGCTLMSR
will be bizarre, but I don't see a way around that since legacy LBR virtualization
and LBR Stack virtualization share a control.

E.g. I think we'll want to end up with something like this?

	case MSR_IA32_DEBUGCTLMSR:
		if (data & DEBUGCTL_RESERVED_BITS)
			return 1;

		if (kvm_cpu_cap_has(X86_FEATURE_LBR_STACK) &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_LBR_STACK)) {
		    	kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
			break;
		}

		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
		svm_update_lbrv(vcpu);
		break;

