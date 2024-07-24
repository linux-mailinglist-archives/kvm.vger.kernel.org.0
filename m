Return-Path: <kvm+bounces-22193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1221593B663
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 20:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFE1C28594C
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 18:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860C016A956;
	Wed, 24 Jul 2024 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGeTzIgD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E81155A24
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721844122; cv=none; b=ioFS6+ahh4hbILEDrsqGMEAkiXLXF8xMfztvksQD6j5AIodjjf76nhbS6DhO2T2om2FRNWTRMG4Eg24ZdIk6ysZpNwm6Nw0kHhBVxOzo/DgWNmcAy4L5tZHDFvLQC0cn0aOsbqfgOrYwiAGwCr0yfyoVDW5pFbYHHjgwF70517g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721844122; c=relaxed/simple;
	bh=NGZo+fA/ilRIlCycVHkaKrLjDlQSUOcSWWgG3kvb9Mo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XJUXviGVndEa8A+mxo6UJeBzrNcYl1pV7EiYVUWKB+nJuHL9uMO+L3BXGmvVJmzdEfH5lZ1rbwrjoOm2pjRo6MJv125IeEi5pGs+FuDEEdtSPFy7yrbtrqczP1WPxU7LoeoBEHfcU5Y2jCshv7oPjyYkVjNFq3HFe7h4Q6jHEUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGeTzIgD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721844120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jzcC9strTDkqEpjO7pYUjkzMIvlRQNGVM4oVnCebrR0=;
	b=JGeTzIgDmhmlCyiEtZJwcuKPoMc0t32Ws3M481uYFKwTtLRHxndSwvo1FQLwazDBOwcuih
	+RIxhFq3i1xekc2w1iifnqKCXRU76KbB67fSGfLHWBlFVCpfFKsU9M/qLPBURlvYYtEE4n
	MaP/0OMlhC8snT5JaGCyiOLz3VBXsgE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-V5vKLSJRNEiSR8FiLKQLqg-1; Wed, 24 Jul 2024 14:01:58 -0400
X-MC-Unique: V5vKLSJRNEiSR8FiLKQLqg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b7a5ab3971so1277716d6.2
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 11:01:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721844118; x=1722448918;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jzcC9strTDkqEpjO7pYUjkzMIvlRQNGVM4oVnCebrR0=;
        b=TbyiMtuFOUj2I4cABk8HIgajmXANsg8S2kKy6HwLvHKs2Mv6yh6E9zbiSYzgZyIeki
         puUGolvn4OPpS08IJevs7H9Z3xBfDcOxLljDBqW5+vUWsK6tOVemA0+0W3koEVjZsvQd
         f3b0aIY7Dxm3IglLLIIhPWS4VV4JUiHi1BwT2RsO4kl79SIiqg45wm/1oK9fNr4bD+x6
         hiJ8e4Ow1AcGUTxE0ZJVE543bpDGbJtRaDVNBOHrW8HuUARyzE2RdCR4feaBiFb4W8ET
         uBKEi0vucrxO1XeL+fkEpXsHxQ3Uy5DcIu+Yi+ofhs0sf+sSPayxEHJnLXFg4C7hhLHg
         z7lA==
X-Forwarded-Encrypted: i=1; AJvYcCUj5YQjer8PvadSRuE4ZbuBmEbAD1bwOXll9lkm3YTHEr0Ai8r7zfm8eAm3x0ubyJXyCOAkqa87OamgRvRn+o2rj0Wl
X-Gm-Message-State: AOJu0YwTXNELaqPLmAKo6z9a28MKMkrSy086Jl7fgfb5zH2D9BiHOW0s
	1aQVlxUuBNCz3S4SssjKGtupH3847oBQ4KFsm10inb/JBEFF3ZJ2bljzl+nql1uNJTicy1qbe7Q
	iY5IrNAcUmO8dwK1/8WJiiw8C+0vZb7+4mkDIIdXNexeihdEQaA==
X-Received: by 2002:a05:6214:2263:b0:6b5:ab8:3c67 with SMTP id 6a1803df08f44-6bb3ca4a18amr5253546d6.12.1721844118125;
        Wed, 24 Jul 2024 11:01:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZEhac2G3eS9qVXLObbJ6dYQUXvi7/B/WoD7rOb25+o96829TGkskMEd5EHjlduvB/RI+kKg==
X-Received: by 2002:a05:6214:2263:b0:6b5:ab8:3c67 with SMTP id 6a1803df08f44-6bb3ca4a18amr5253056d6.12.1721844117592;
        Wed, 24 Jul 2024 11:01:57 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b7ac9c3b58sm60232466d6.93.2024.07.24.11.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 11:01:56 -0700 (PDT)
Message-ID: <421ab8ab3aba859e57518922fe1976ac077423cc.camel@redhat.com>
Subject: Re: [PATCH v2 46/49] KVM: x86: Replace (almost) all guest CPUID
 feature queries with cpu_caps
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 14:01:55 -0400
In-Reply-To: <Zo2Nb653OcdDge9N@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-47-seanjc@google.com>
	 <928f893e5069712a6f93c05a167cf43fa166777c.camel@redhat.com>
	 <Zo2Nb653OcdDge9N@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2024-07-09 at 12:20 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > +static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
> > > +					    unsigned int x86_feature)
> > >  {
> > >  	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> > >  	struct kvm_cpuid_entry2 *entry;
> > > +	u32 *reg;
> > > +
> > > +	/*
> > > +	 * XSAVES is a special snowflake.  Due to lack of a dedicated intercept
> > > +	 * on SVM, KVM must assume that XSAVES (and thus XRSTORS) is usable by
> > > +	 * the guest if the host supports XSAVES and *XSAVE* is exposed to the
> > > +	 * guest.  Although the guest can read/write XSS via XSAVES/XRSTORS, to
> > > +	 * minimize the virtualization hole, KVM rejects attempts to read/write
> > > +	 * XSS via RDMSR/WRMSR.  To make that work, KVM needs to check the raw
> > > +	 * guest CPUID, not KVM's view of guest capabilities.
> > 
> > Hi,
> > 
> > I think that this comment is wrong:
> > 
> > The guest can't read/write XSS via XSAVES/XRSTORS. It can only use XSAVES/XRSTORS
> > to save/restore features that are enabled in XSS, and thus if there are none enabled,
> > the XSAVES/XRSTORS acts as more or less XSAVEOPTC/XRSTOR except working only when CPL=0)
> 
> Doh, right you are.
> 
> > So I don't think that there is a virtualization hole except the fact that VMM can't
> > really disable XSAVES if it chooses to.
> 
> There is still a hole.  If XSAVES is not supported, KVM runs the guest with the
> host XSS.  See the conditional switching in kvm_load_{guest,host}_xsave_state().
> Not treating XSAVES as being available to the guest would allow the guest to read
> and write host supervisor state.
Makes sense. The remaining virtualization hole is indeed that we can't disable XSAVES,
even if userspace chooses to, we still can't.


> 
> I'll rewrite the comment to call that.
> 
> > Another "half virtualization hole" is that since we have chosen to not
> > intercept XSAVES at all, (AMD can't do this at all, and it's slow anyway) we
> > instead opted to never support some XSS bits (so far all of them, only
> > upcoming CET will add a few supported bits).
> > 
> > This creates an unexpected situation for the guest - enabled feature (e.g PT)
> > but no XSS bit supported to context switch it. x86 arch does allow this
> > though.


Best regards,
	Maxim Levitsky


