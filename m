Return-Path: <kvm+bounces-43983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD6EA9960D
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 19:08:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6534189CCE1
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F1228A406;
	Wed, 23 Apr 2025 17:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SaZKBnES"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8845BDDAD
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745428075; cv=none; b=P0aakWZBC9QS9bLgXpK9zBiOSCJuXdHDxuePU7Wav4Bj2bj9BXqnKTKBVgf73rxaFsw2jJAsRX6qFJ7bbxh4gYYhMP3p02sriF8TCgNRRyXdC6mTm2glgHnrx1NcmZVxf3CAxIoaCnpLcB+WVFjKxB2CVzG6ETes2/YJbIbK5Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745428075; c=relaxed/simple;
	bh=wL+0xUq+Wpv5CUzn5J0WCeIN7d1hdB4e5BLKw+HRd64=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mSAyL0VM5B1qoBjuQizT3WutSIt5y1x+chkPTJgETallQzxGUu87htJbEY1rF8LP9IIAeHb0upaxkCb2lMUbubGcugUJEXu5s3MP5Iz1XZOmEeZjAiYZgNdH0iCXBd1Bvpohqja9lgNWVogRzp0GUQQyTunh2N6xFeADHrmsr24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SaZKBnES; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-309c6e43a9aso125722a91.2
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 10:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745428073; x=1746032873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XlnAkp8cVn0zj/PVrvUqNTjNSTp79edpiLwavMDguXI=;
        b=SaZKBnESdrd3EhZEvvzI89/cr66r07D7SrbsPu5Pfzbdz1T69hV9PjtryDP/4kM8MM
         mtY6q66mjKuGsZ/P4uTOZJnXH8CTALCkdmiRq6GwHJfhVanmnGyBei9xBBGkn81sEZ0r
         z26P0y1G8XZhpheyEdKtpEO8KGFgsYVt2QxnB8bmgAEmxA4LB0QTqBbr8+MfY0MkYP5L
         xZPih8hpMfsdon5jz6gTp0R0ghVCLGhq2zu5a/pAcatmvPUKT7KG3D1XnBZ5wWXgCsLB
         Ws+7ssO9ZOHrY5Kf7ENLRwRyDnEQWxf91MDW005wgZ1PETpPgrA7qTEJnp/n4vh59RTW
         QhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745428073; x=1746032873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XlnAkp8cVn0zj/PVrvUqNTjNSTp79edpiLwavMDguXI=;
        b=UsPOD2QDgIpkJc+8PsDVUxT26ezlspCye5T/WweVCmsF2neRLErkiOWf4WRZnyJU/L
         5dylrRcnKYUjZcpmqJL3uDmxssY2+JnTyIyEOxoG2uDvOowGf50YCM36ErqRXzZnddDz
         v1GpCOKWb246btgms2jC1k7/OdJgl0DCCvTkvCm4M3X4+/I+Qa+aBjOjTmE02N5Z2eI4
         wRXqaTkIeHpbxMtwMkTedeDh3gIHlKqr4DczKCXx8YLb8+m4YH/T4kxAf77xN+70/2cj
         vZIxFkwv+QprFwEwbhvDq2n4b5PQt6a1VEfSyZeZEa1tRWOF2v/F2seCmQpSKoud5ege
         Vaew==
X-Forwarded-Encrypted: i=1; AJvYcCV7wv+y8SU8VRnh6py0bPDfp6/Pld7g6s0Yj7k9lUV6MaJpS3AOZDhEm9gvS4DztHgYVhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDrjH+hgW48ZwmCoEGzH6pxiKX2lMAipY2dqfALi/4JPGPznH1
	7azL/2A6uSEWM2auftE2phmrwsCZD+mmSt30Aq4EEZ/EBUJUF0twyuS55jAPesWaJJWvjgXALyj
	Z4g==
X-Google-Smtp-Source: AGHT+IGhg62gnwDuvC+PxXSi6CDz4jilJV6tGssP+7fXEQAB/a9SlpJoSZ0TQDPRqFrYifSq2QDRbxu9Uco=
X-Received: from pjbst14.prod.google.com ([2002:a17:90b:1fce:b0:2ff:852c:ceb8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:380f:b0:2ee:9d49:3ae6
 with SMTP id 98e67ed59e1d1-3087bb5336cmr30977016a91.10.1745428072873; Wed, 23
 Apr 2025 10:07:52 -0700 (PDT)
Date: Wed, 23 Apr 2025 10:07:51 -0700
In-Reply-To: <8a58261a0cc5f7927177178d65b0f0b3fa1f173c.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401155714.838398-1-seanjc@google.com> <20250401155714.838398-3-seanjc@google.com>
 <20250416182437.GA963080.vipinsh@google.com> <20250416190630.GA1037529.vipinsh@google.com>
 <aAALoMbz0IZcKZk4@google.com> <8a58261a0cc5f7927177178d65b0f0b3fa1f173c.camel@intel.com>
Message-ID: <aAkeZ5-TCx8q6T6y@google.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Allocate kvm_vmx/kvm_svm structures
 using kzalloc()
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "vipinsh@google.com" <vipinsh@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Kai Huang wrote:
> On Wed, 2025-04-16 at 12:57 -0700, Sean Christopherson wrote:
> > On Wed, Apr 16, 2025, Vipin Sharma wrote:
> > > Checked via pahole, sizes of struct have reduced but still not under 4k.
> > > After applying the patch:
> > > 
> > > struct kvm{} - 4104
> > > struct kvm_svm{} - 4320
> > > struct kvm_vmx{} - 4128
> > > 
> > > Also, this BUILD_BUG_ON() might not be reliable unless all of the ifdefs
> > > under kvm_[vmx|svm] and its children are enabled. Won't that be an
> > > issue?
> > 
> > That's what build bots (and to a lesser extent, maintainers) are for.  An individual
> > developer might miss a particular config, but the build bots that run allyesconfig
> > will very quickly detect the issue, and then we fix it.
> > 
> > I also build what is effectively an "allkvmconfig" before officially applying
> > anything, so in general things like this shouldn't even make it to the bots.
> > 
> 
> Just want to understand the intention here:
> 
> What if someday a developer really needs to add some new field(s) to, lets say
> 'struct kvm_vmx', and that makes the size exceed 4K?

If it helps, here's the changelog I plan on posting for v3:
    
    Allocate VM structs via kvzalloc(), i.e. try to use a contiguous physical
    allocation before falling back to __vmalloc(), to avoid the overhead of
    establishing the virtual mappings.  The SVM and VMX (and TDX) structures
    are now just above 4096 bytes, i.e. are order-1 allocations, and will
    likely remain that way for quite some time.
    
    Add compile-time assertions in vendor code to ensure the size is an
    order-0 or order-1 allocation, i.e. to prevent unknowingly letting the
    size balloon in the future.  There's nothing fundamentally wrong with a
    larger kvm_{svm,vmx,tdx} size, but given that the size is barely above
    4096 after 18+ years of existence, exceeding exceed 8192 bytes would be
    quite notable.


> What should the developer do?  Is it a hard requirement that the size should
> never go beyond 4K?  Or, should the assert of order 0 allocation be changed to
> the assert of order 1 allocation?

It depends.  Now that Vipin has corrected my math, the assertion will be that the
VM struct is order-1 or smaller, i.e. <= 8KiB.  That gives us a _lot_ of room to
grow.  E.g. KVM has existed for ~18 years and is barely about 4KiB, so for organic
growth (small additions here and there), I don't expect to hit the 8KiB limit in
the next decade (famous last words).  And the memory landscape will likely be
quite different 10+ years from now, i.e. the assertion may be completely unnecessary
by the time it fires.

What I'm most interested in detecting and prevent is things like mmu_page_hash,
where a massive field is embedded in struct kvm for an *optional* feature.  I.e.
if a new feature adds a massive field, then it should probably be placed in a
separate, dynamically allocated structure.  And for those, it should be quite
obvious that a separate allocation is the way to go.

