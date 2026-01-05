Return-Path: <kvm+bounces-67057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B7EECF48B4
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 16:58:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 02A11313DF20
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 15:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F643054EF;
	Mon,  5 Jan 2026 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rNOiiN49"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3D727B347
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628329; cv=none; b=V8/ie6Mbz62j2Z8sMBXO0j+FLQQeHNbWnnO+kkN4/ZkOoEmKHzLCXkhVv4lg3Hm/X4+DzstgUN8LStsK0+RXqAHa5Zora50EZe6LjzBAWs5VLLtoHXRn0CRR1s8AUq9MRpoVKctEIxtcuMM4/NqfwATMNMqA2kDN9mMOQzHMxq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628329; c=relaxed/simple;
	bh=RCqc1K2H51T+0fRx+YAw2QfwgUtkd5MfFqKUMXEaI9E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=khvxYQxo1ZIK+iWfycS535k9ZyELNN5x1Ox/UoruozuhZh8uesz8j2Ae2VQCQ/D37Lz3uiCGtCagRaD83pb9YRYMvMPNL2M1oxlIz+R1YzfkuAwrblsj485Fh1o3eR7m4xUMzXJBIBr3uLPZZJvGKExdD933qAEpyvdjNVNCgbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rNOiiN49; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ea5074935so132327a91.0
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 07:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767628326; x=1768233126; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u7ZrFjM0PFkxi63NtaMx1QrjwmvFUSpNxs6Nn+92Dw8=;
        b=rNOiiN49uKrAUy7L3MlQ9Pc1V7zQT5OpFb0qagoODZ1LIonRE/Ncw87b+GRm7p4A7v
         UPOLJUZbppb8PMyVpxiPeHjwoxTUbibf2DLmqLQiCT7POZjeY37ma6tjTyPPH5jNJVBt
         LF7d27RP6iw77fGfMq9FfmK+fHBZlHN4MQ/S9RSD4koh3KdV/CG0YlU1I+0E8MYSMm2t
         R+jKPzqdzAU+GtiyrN0kpUojqDPqAmy3CRmQpRo7nymW2khgVbNSF9n/tRy8md0c0TQO
         98PPH8kj1jdr8f45Ep6N1dbhdDV+F0y+swDVopHHRT78bi+nHGyPtVCWj/4serS/nQZv
         Ybqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767628326; x=1768233126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7ZrFjM0PFkxi63NtaMx1QrjwmvFUSpNxs6Nn+92Dw8=;
        b=L4i6IulTdj77JOWqoqYMb/vfL2MzjA9xyUGDlXi+dtAGUZGAdJ4iVgSnatFCXj6z5g
         asNHyVsJcGiZA/ykw2zn80qgrSKxEpcSPq7c8ifB/VvJEQP/AkvSdVsQXRLcjjwjKf69
         jY/ht38pQIkNX6UD9tUZZr4rZ8PyeP5e72vpIzpS59jJYnP71c6z01cUuuYpBYqBtFB9
         dBy1tu7z8HbHRJDjFbTNERNmLh/Ds1wYJsiqSqWkvkN2C6i9o9mElrS+FGQZAb5oXw4m
         2TfJXcbHkJ85UJAzyrnSb4gRSPdDIG5hdNLoswtb51QQPbqAcZk++2U648cgiZ8nTH9D
         zfRA==
X-Forwarded-Encrypted: i=1; AJvYcCU5uE7aOiyz8a+onRxTuJJpyPAeZ00fLD7K846tguZ7+q3CtrUyzkW5KCYrdguKGRGDpRg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgzaKRLV29yQK7I0z/Km9B82SNYsR8/SsusE4/RiF0d62ryB8u
	iPHV0TJ/3kAzdtc8SDr/UNVoll5jpKBYyb4Yof1GoPJdLzHJcpoDw0fLfG+jeY7uPmEvRRlBb2c
	2QQ4ufg==
X-Google-Smtp-Source: AGHT+IEWgZO5625IXW8fQ0Tp1xvUFHo/yvm04nNJi/rgYNfnXJNwr5M+AFDOogDHvIl8zXGJ+W/FMgqnXK4=
X-Received: from pjca7.prod.google.com ([2002:a17:90b:5b87:b0:34e:8f5a:9197])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c4b:b0:34c:e5fc:faec
 with SMTP id 98e67ed59e1d1-34e9212f72dmr34857608a91.2.1767628326173; Mon, 05
 Jan 2026 07:52:06 -0800 (PST)
Date: Mon, 5 Jan 2026 07:52:01 -0800
In-Reply-To: <87eco8bajg.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230211347.4099600-1-seanjc@google.com> <20251230211347.4099600-9-seanjc@google.com>
 <87eco8bajg.fsf@redhat.com>
Message-ID: <aVveISeqIBPmZ7xW@google.com>
Subject: Re: [PATCH v2 8/8] KVM: SVM: Assert that Hyper-V's
 HV_SVM_EXITCODE_ENL == SVM_EXIT_SW
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 02, 2026, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Add a build-time assertiont that Hyper-V's "enlightened" exit code is that,
> > same as the AMD-defined "Reserved for Host" exit code, mostly to help
> > readers connect the dots and understand why synthesizing a software-defined
> > exit code is safe/ok.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/hyperv.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/x86/kvm/svm/hyperv.c b/arch/x86/kvm/svm/hyperv.c
> > index 3ec580d687f5..4f24dcb45116 100644
> > --- a/arch/x86/kvm/svm/hyperv.c
> > +++ b/arch/x86/kvm/svm/hyperv.c
> > @@ -10,6 +10,12 @@ void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> >  
> > +	/*
> > +	 * The exit code used by Hyper-V for software-defined exits is reserved
> > +	 * by AMD specifically for such use cases.
> > +	 */
> > +	BUILD_BUG_ON(HV_SVM_EXITCODE_ENL != SVM_EXIT_SW);
> > +
> >  	svm->vmcb->control.exit_code = HV_SVM_EXITCODE_ENL;
> >  	svm->vmcb->control.exit_info_1 = HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH;
> >  	svm->vmcb->control.exit_info_2 = 0;
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Alternatively (or additionally?) to BUG_ON, I guess we could've
> 
> #define HV_SVM_EXITCODE_ENL SVM_EXIT_SW 
> 
> unless including SVM's headers into include/hyperv/hvgdk.h is too big of
> a mess.

Heh, I had the same thought[*], but Wei pointed out that the definitions in hvgdk.h
mirror internal Microsoft headers:

  On Fri, Nov 14, 2025, Wei Liu wrote:
  > On Fri, Nov 14, 2025 at 07:22:41AM -0800, Sean Christopherson wrote:
  > > On Fri, Nov 14, 2025, Michael Kelley wrote:
  > > > From: Sean Christopherson <seanjc@google.com> Sent: Thursday, November 13, 2025 2:56 PM
  > > > > @@ -281,7 +281,7 @@ struct hv_vmcb_enlightenments {
  > > > >  #define HV_VMCB_NESTED_ENLIGHTENMENTS		31
  > > > > 
  > > > >  /* Synthetic VM-Exit */
  > > > > -#define HV_SVM_EXITCODE_ENL			0xf0000000
  > > > > +#define HV_SVM_EXITCODE_ENL			0xf0000000u
  > > > 
  > > > Is there a reason for making this Hyper-V code just "u", while
  > > > making the SVM_VMGEXIT_* values "ull"? I don't think
  > > > "u" vs. "ull" shouldn't make any difference when assigning to a
  > > > u64, but the inconsistency piqued my interest ....
  > > 
  > > I hedged and went for a more "minimal" change because it isn't KVM code, and at
  > > the time because I thought the value isn't defined by the APM.  Though looking
  > > again at the APM, it does reserve that value for software
  > > 
  > >   F000_000h    Unused    Reserved for Host.
  > > 
  > > and I can't find anything in the TLFS.  Ah, my PDF copy is just stale, it's indeed
  > > defined as a synthetic exit.
  > > 
  > >   https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/nested-virtualization#synthetic-vm-exit
  > > 
  > > Anyways, I'm in favor of making HV_SVM_EXITCODE_ENL an ull, though part of me
  > > wonders if we should do:
  > > 
  > >   #define HV_SVM_EXITCODE_ENL	SVM_EXIT_SW
  > 
  > I know this is very tempting, but these headers are supposed to mirror
  > Microsoft's internal headers, so we would like to keep them
  > self-contained for ease of tracking.
  > 
  > It should be fine to add the "ull" suffix here. I briefly talked to a
  > hypervisor developer and they agreed.

[*] https://lore.kernel.org/all/aRdJQQ7_j6RcHwjJ@google.com

