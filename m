Return-Path: <kvm+bounces-14895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E06B8A7605
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8EC02819AD
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA405A0FE;
	Tue, 16 Apr 2024 20:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H3On6KNN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1054044C6B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 20:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713301125; cv=none; b=eHTw61CTCBejEDxEyEbvE9qJNfvOVqyDMXY6BusfCOQW3M4Qo53PNjcjSEVvIL1gBLtKX1UYgq6we8aERb7PyaeLCfJf9nXOycdirFzpdbvX+MEVYAumCMOBwvwdI4X4HiqSKmBIEeRxeIdKSbiyqkEET3XdJpQBUSRmdePJzHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713301125; c=relaxed/simple;
	bh=bjjR/fURKyfHFmb8z6eyjmRhKvFUd2k2glmj1sFt8TY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EXSinby4VajmninhuYOR8fAUJQ8c94mmYNP4p/nBusi3JDDKRvZB4JSmrW92pL8x5vbRwbYmblQtX9PkEPEQfjoay61R/FlOeZls6+ZVsy5TVQHlNGOwt52XnRMTHGmHluHsIB1QcCUwtzPk8XSiGS26mIB7rW97SS3Yf5UkLL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H3On6KNN; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1e2bbb6049eso40646075ad.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 13:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713301123; x=1713905923; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IagCFOK7GndGvbu+ZDoWmNTm5/xYC3EkHGls/RBs+eE=;
        b=H3On6KNNg2ioDvTnm28tUZx/2XnVZVpWM+yHDvimb2uNZQ9S/nqSaXiO4uKlKPIpsG
         lyzvwAWhjHKZciWICEqFyaT70PG75cMalF4C6T0A7NbtA2JDtezStpqoeszEgeerRbT1
         UpBsSl/R43nueyWZkToJuV9DDPGNA0q3XSFeDMSNNvrGfQRajvsT4lZ1tkmRhKMSXtbx
         FrY3f9Zjwwpa+jVhbe62MNpd0fMk0F4OsAuIUpuQU8Q/S6znO35g52TPUHtA5hfFt0Z7
         bHXVRp/u+IG48+54GaAu1dZGOrHlqBPbOVXHYumLTPQoSzugDSXXIbyCs3RjZHMCXEYM
         iaFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713301123; x=1713905923;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IagCFOK7GndGvbu+ZDoWmNTm5/xYC3EkHGls/RBs+eE=;
        b=pfrXoyLnsiwKxuMNF8cFfLN7tstYGq4cCxnD/izTm0QKxOmmgNPncaXn2ViNsMrRus
         izKlWK7Ctxux7MSPYyyrbj8ObMC0CM2Du9PzlJh1dEnXOOdksv+ZcEShqQo1kjVNKUNp
         tQlI0yJGKwFWxttbIF2P3jDuQFUb4B2TeSsKssWXw38lrzIWD6v2tGiTTRBae2Ud/dU9
         km0e/5L48bPsGsg/VOVgXgbObadx+wYyYUS+8am0+1pT1U26O4+EAeosmk1jsmqD3DjN
         UTlRv9tdb7hC6o4mcygq2lMPQfQ11utp2WqQSGB/P6BCvI3dKn6ybyx9FI6GbrMT2RLq
         6PUA==
X-Forwarded-Encrypted: i=1; AJvYcCUyUnNTxO60nPNvHDaUA6N/yjUnVMzyC7XL5aUgGApInOJLe/N7Uu3irpK8HSE9T16u35R1S/Pb1dZlAF867PZrG5dL
X-Gm-Message-State: AOJu0YxOnFWLhQhBMNgiSlJTm6Uc47YrAYghYUmDpX1TOfZs5wQ253gw
	tGneTm+SGf/mwrw+v9k950tEPjX3WhMb98E95KsUpbo0tuRjWHQFwfPB8YOAj4NIyLfvzLdBYGE
	r4A==
X-Google-Smtp-Source: AGHT+IHM0igWGyveTIsywC1hHuxGax11ZYRkRW3LmLhKG0+KgIA6kBXRwvb0slBN7N43sMi/dsG5kwiUI0M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88a:b0:1e6:624c:f849 with SMTP id
 w10-20020a170902e88a00b001e6624cf849mr544995plg.4.1713301123335; Tue, 16 Apr
 2024 13:58:43 -0700 (PDT)
Date: Tue, 16 Apr 2024 13:58:41 -0700
In-Reply-To: <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
 <d45bb93fb5fc18e7cda97d587dad4a1c987496a1.camel@intel.com>
 <20240322212321.GA1994522@ls.amr.corp.intel.com> <461b78c38ffb3e59229caa806b6ed22e2c847b77.camel@intel.com>
 <ZhawUG0BduPVvVhN@google.com> <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
 <Zhftbqo-0lW-uGGg@google.com> <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
Message-ID: <Zh7KrSwJXu-odQpN@google.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, Tina Zhang <tina.zhang@intel.com>, 
	Hang Yuan <hang.yuan@intel.com>, Bo Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 12, 2024, Kai Huang wrote:
> On 12/04/2024 2:03 am, Sean Christopherson wrote:
> > On Thu, Apr 11, 2024, Kai Huang wrote:
> > > I can certainly follow up with this and generate a reviewable patchset if I
> > > can confirm with you that this is what you want?
> > 
> > Yes, I think it's the right direction.  I still have minor concerns about VMX
> > being enabled while kvm.ko is loaded, which means that VMXON will _always_ be
> > enabled if KVM is built-in.  But after seeing the complexity that is needed to
> > safely initialize TDX, and after seeing just how much complexity KVM already
> > has because it enables VMX on-demand (I hadn't actually tried removing that code
> > before), I think the cost of that complexity far outweighs the risk of "always"
> > being post-VMXON.
> 
> Does always leaving VMXON have any actual damage, given we have emergency
> virtualization shutdown?

Being post-VMXON increases the risk of kexec() into the kdump kernel failing.
The tradeoffs that we're trying to balance are: is the risk of kexec() failing
due to the complexity of the emergency VMX code higher than the risk of us breaking
things in general due to taking on a ton of complexity to juggle VMXON for TDX?

After seeing the latest round of TDX code, my opinion is that being post-VMXON
is less risky overall, in no small part because we need that to work anyways for
hosts that are actively running VMs.

> > Within reason, I recommend getting feedback from others before you spend _too_
> > much time on this.  It's entirely possible I'm missing/forgetting some other angle.
> 
> Sure.  Could you suggest who should we try to get feedback from?
> 
> Perhaps you can just help to Cc them?

I didn't have anyone in particular in mind, I just really want *someone* to weigh
in as a sanity check.

