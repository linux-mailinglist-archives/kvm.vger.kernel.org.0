Return-Path: <kvm+bounces-11605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA14878BCD
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C12E51F2172B
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 00:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCAA029AF;
	Tue, 12 Mar 2024 00:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="birIeGsB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B13D191
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 00:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710202128; cv=none; b=BQ9bOYl1zdW58zcHYFQdcVayhwmDeMRtKsRf3pCrKV3kVuL0i5FeS2Rj3UXIhnnyduH/ogxOuECFHjc93ZtETsbCbOEo9i3mIsCq8KXCsIsW7ZfISl+2lGGNcQMQf6XfHYfR09lVJTNCR9aE1rvzbzIQnlUxBWm64n2WdcQeXeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710202128; c=relaxed/simple;
	bh=0Yb12pPEmKrsC1pLW8reJgDFPcWSOLnjlFPRgboKnzM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qyaWIJmmuUZU2JKR5EB//6uvwdkEA/Z15rgSZzDex8nlkIj0DoDpRmXITreTeZxks1h/IC/sjbd+0BSvAzVI2ekX3xaVZzLjyKAmfxHbMjgTiSNjuZ8pswLvGMKI4GMRfMYSBSR9c6LKkYAClu4LobWMZZxcO2d2AAMfPQXtaQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=birIeGsB; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dced704f17cso8521287276.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 17:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710202124; x=1710806924; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+d74PXd4taKq/kej/o6mNWve0XFGzP2O6HVRwkMDONA=;
        b=birIeGsBBaAQIffVUzrsSkdieJBLwk7eZdpIOPCXTqlADokw1+d/KcrsIhieBq67uH
         xDVqBjEMll/LUgDtNKkYOfO/gkSQyGbHUVMMrXcPbN9GUyIIVeS7QdRFAFb9B/6wHysY
         +ErhaYewCw0Q5kMAq7C4v33IM9CUgjBWLbizzanf8uRAFKzsRIqY8wPp7hXmF+H/4lWr
         ZR2cSLBWJOug8HxXdYbP/RFd65BsDybx1OOYkaGlNpGyyjE5H20uFXRFhkG5Rm0ruFw1
         cLlyRsVqRn9Z3Ljfubmk5U6Y0qSHoR9WoTr0kGtJnARq+dlOwbH7s+QoFfPnZY9aV7sC
         mr7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710202124; x=1710806924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+d74PXd4taKq/kej/o6mNWve0XFGzP2O6HVRwkMDONA=;
        b=adhXtYO7L59btM5JNyxISwIfb0+28L6TZIXuyYL5/Ehd+fleu9YdwY1VVSntJpWzNQ
         HT6a7T3uPVBnuh896zMxtvcSuRcKU5Ue44YXYtVTWawn2V+3LOmfr1eUDl5R1dSBBjiQ
         kOFmwPOZ6SBgLeI/YFsEKb1VWZdQSnDgnXReUJq9ExtnsasnzrVQcA4t1l5JZRhMeVu/
         4q4EqRwhZJ3VSqtIXuu9wQJfbdH0JZWbc/Hw34WQ5WeVXLKnieSVp1MRxSLNjYkJIdx0
         31rQUXYl9VQgC65ExyKQbu8OB5L3w6c8flFBne59D1aFjFznBudu8JpEv0UIugagTUex
         7bOg==
X-Forwarded-Encrypted: i=1; AJvYcCURr1OOfDmX5hwjb5ZZpt+KbMF+eT5rnjOtUt0pFEeIEloDPtZn+03JyVmtgTw+iPueMmXQChZWyv3Nso/Fy1z/o4ZW
X-Gm-Message-State: AOJu0Yz2ihnS80YYZnzEQ+RJLPo4iwo5LXAel+A/1FixPDRsDR1PZ0dZ
	UQysnhWABpCbfOt7TfA9xzDLeAZTzIw+ayO1iUyEpbWbyLWuK5R6oUQdLJzUHDjs1FlVlgciD5Q
	uEA==
X-Google-Smtp-Source: AGHT+IFKY3pZHfuOr1Yij7OhUEHiSO8WW9VIgdjvPIWPfwcBwVP8Sm713pwSINrR33+2phQXB5qutd145N4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab6f:0:b0:dcd:3a37:65 with SMTP id
 u102-20020a25ab6f000000b00dcd3a370065mr414308ybi.7.1710202124212; Mon, 11 Mar
 2024 17:08:44 -0700 (PDT)
Date: Mon, 11 Mar 2024 17:08:42 -0700
In-Reply-To: <Ze62bqgWhbReg9wl@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309010929.1403984-1-seanjc@google.com> <20240309010929.1403984-2-seanjc@google.com>
 <Ze62bqgWhbReg9wl@yzhao56-desk.sh.intel.com>
Message-ID: <Ze-dCirMCOCsbsVJ@google.com>
Subject: Re: [PATCH 1/5] KVM: x86: Remove VMX support for virtualizing guest
 MTRR memtypes
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>, kvm@vger.kernel.org, 
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 11, 2024, Yan Zhao wrote:
> On Fri, Mar 08, 2024 at 05:09:25PM -0800, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 7a74388f9ecf..66bf79decdad 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7596,39 +7596,27 @@ static int vmx_vm_init(struct kvm *kvm)
> >  
> >  static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> >  {
> > -	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
> > -	 * memory aliases with conflicting memory types and sometimes MCEs.
> > -	 * We have to be careful as to what are honored and when.
> > -	 *
> > -	 * For MMIO, guest CD/MTRR are ignored.  The EPT memory type is set to
> > -	 * UC.  The effective memory type is UC or WC depending on guest PAT.
> > -	 * This was historically the source of MCEs and we want to be
> > -	 * conservative.
> > -	 *
> > -	 * When there is no need to deal with noncoherent DMA (e.g., no VT-d
> > -	 * or VT-d has snoop control), guest CD/MTRR/PAT are all ignored.  The
> > -	 * EPT memory type is set to WB.  The effective memory type is forced
> > -	 * WB.
> > -	 *
> > -	 * Otherwise, we trust guest.  Guest CD/MTRR/PAT are all honored.  The
> > -	 * EPT memory type is used to emulate guest CD/MTRR.
> > +	/*
> > +	 * Force UC for host MMIO regions, as allowing the guest to access MMIO
> > +	 * with cacheable accesses will result in Machine Checks.
> This does not always force UC. If guest PAT is WC, the effecitve one is WC.

Doh, right, I keep forgetting that KVM doesn't ignore guest PAT for MMIO.

