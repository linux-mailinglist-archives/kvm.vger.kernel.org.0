Return-Path: <kvm+bounces-58392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 361F4B92426
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4A53444BBB
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA34F3126BB;
	Mon, 22 Sep 2025 16:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o3+oNtS1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D07C31197D
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758559271; cv=none; b=Hm0wXod9Tm5f99HsKwId+O58Xw99b5kgqdTISN378SbqzXoXhnDRGi7Decqt+4cFccKaFSNFM7bpmDpLGQAq+HnF8UumER1ndTpBWaZqjuCPT58527gdj/72Lsix6U273C53eaM7oVIGCoHIqs2ZifvY6Qr8/gpliSR2AtMKw7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758559271; c=relaxed/simple;
	bh=cgRpOeV/h8eXSJgC9yPwO6bTk7jVPQzl+0xil1ELsMo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BgZM975GIxTn5Ybw5N0fjLP5Qzplwh+qbsz53daaploPKe1malQ6LvGh7jYKkYYQTGELU8XW6OZBvpg081MNIAL5bCwpgUZJ7eWVC3g3HedEDDUix6sEWHjA8oj/P0ZLmZxjH0f6UM5JofyGeI3rtvsL9p108goFWAwv+3fV8+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o3+oNtS1; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b5508cb189cso5941079a12.2
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758559269; x=1759164069; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mTfqCdokW+X8HtLwVeSE+IdGBuVQNPlKza47DCX1dCM=;
        b=o3+oNtS1a2m5574eM/5RS1PDtlXpQUW5EnAefoHiRPaE7A7jpE0kZj/jQZEL9+G3aX
         rXY7SIgnoI0kPMy5otzT0gP6cL0UT2Hxn3vUpHWS2rEm5npMgfqS0ZEKpGiz1IkBJfFq
         a6CLnnidM6R8Hy20KJu68Nyr272CG7qFFCQULTPPzEQs9eIJbakjpXIIvqBrum4fCRwM
         h2eLVozsgvdkGgaan5PzBxM6vQo9ho7xgbx6DIzCVfrhwklEk2N4017PeKTGxFhyfJPJ
         mfaouWXZaRk+WdrEaJBpRlLtr9XplihsDNFpzN5UTi7xqmeXTDErCm+j4D36Aogo3mJ7
         EWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758559269; x=1759164069;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mTfqCdokW+X8HtLwVeSE+IdGBuVQNPlKza47DCX1dCM=;
        b=VlH/yM/u5h0HXa2LjF6eiLXJeey3CLmMNFsmgbJpRaBDkYzt7MPzs0zJ200kxLzbbz
         y32RQbsoz6Rj2rmGstZMwVeb8Sx3XbTZAsweqlyYkIzQauk9nVndNFCyutcKu0CQqAx8
         o66Nosu7nbepN0sAfORzoVDODaYtBckUpDbvIe9HxOXxYM+PUNorkmZpzj4H/FS3WFMN
         LqchG3ivS67g7x3NSiq4qEBL6M2qEGX+7pp+5RPkYnnPqdjgVJ40AaBseCPMAx/LLhX0
         X/ouPGesi5ReiFEsIvGCxjvLlQ2HHcHLFzWgrqYVMhQATGp1qzZqIkwnAaGwhgjwayHO
         2CJg==
X-Forwarded-Encrypted: i=1; AJvYcCVAYsLGo04Y4NafXKu6S4o4L2cl7cVdPFe1hcVk8OdLVm9ShxirbdWuyyadAKa3c0Vk4og=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGzygXQ8NiyTlbjfedjVTkFWoL9RPt+835ZRQ0PIB508RoqwuZ
	fphFV4tlWYQc/bNl9H/FXqh/skUSKdruGCbjesB2IU3OorP5XupYEX0GrNM1C2ZvI4Y9jQPoO/T
	hJGdTfA==
X-Google-Smtp-Source: AGHT+IGx+vF97ASb9/nxfiDDS7HQfaF+ctUmw4CeMoTHspSFjuxuZ2UWCEgDSadB8xY7RzjrLjcoo2AEKD0=
X-Received: from pfbfj7.prod.google.com ([2002:a05:6a00:3a07:b0:772:5ec0:9124])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d88:b0:262:e0d4:6a9
 with SMTP id adf61e73a8af0-2927031a2e0mr21298385637.34.1758559269308; Mon, 22
 Sep 2025 09:41:09 -0700 (PDT)
Date: Mon, 22 Sep 2025 09:41:08 -0700
In-Reply-To: <4570dfa1-1e8d-40e9-9341-4836205f5501@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-10-seanjc@google.com>
 <4570dfa1-1e8d-40e9-9341-4836205f5501@linux.intel.com>
Message-ID: <aNF8JMN71Bibp24U@google.com>
Subject: Re: [PATCH v16 09/51] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 22, 2025, Binbin Wu wrote:
> 
> 
> On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> [...]
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 3e66d8c5000a..ae402463f991 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -136,6 +136,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
> >   static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
> >   static DEFINE_MUTEX(vendor_module_lock);
> > +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> > +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> > +
> >   struct kvm_x86_ops kvm_x86_ops __read_mostly;
> >   #define KVM_X86_OP(func)					     \
> > @@ -3801,6 +3804,67 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> >   	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
> >   }
> > +/*
> > + * Returns true if the MSR in question is managed via XSTATE, i.e. is context
> > + * switched with the rest of guest FPU state.  Note!  S_CET is _not_ context
> > + * switched via XSTATE even though it _is_ saved/restored via XSAVES/XRSTORS.
> > + * Because S_CET is loaded on VM-Enter and VM-Exit via dedicated VMCS fields,
> > + * the value saved/restored via XSTATE is always the host's value.  That detail
> > + * is _extremely_ important, as the guest's S_CET must _never_ be resident in
> > + * hardware while executing in the host.  Loading guest values for U_CET and
> > + * PL[0-3]_SSP while executing in the kernel is safe, as U_CET is specific to
> > + * userspace, and PL[0-3]_SSP are only consumed when transitioning to lower
> > + * privilegel levels, i.e. are effectively only consumed by userspace as well.
> 
> s/privilegel/privilege[...]

Fixed up, thanks!

