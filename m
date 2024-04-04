Return-Path: <kvm+bounces-13619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8FD089918F
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 00:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 140B6B213C8
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 22:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C16670CDE;
	Thu,  4 Apr 2024 22:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rlZVHMZ5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7FC6F505
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 22:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712270739; cv=none; b=r/IRsKdwyq1M0SHvTKS5xtFANNh9KUYxUATPnF0EXVhhuZnP/iwLGTY3ZubgeLOhK+henQqZbMBcFCCB5rOp4f1ciOB8OYMcKtdmqRE0ZD6iuPcs6DcHE6TRsOCUvxs5kLQA4dh+YQcEZPaCTSiFXhNR/g1kVI7o5QiwaSjrroE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712270739; c=relaxed/simple;
	bh=MUx2dwxzhoYs9ch7Wt+3vyW6IzeDkamXK5A2n7Xd0fQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hFLW+8Cs33bPy7KTt53Lf5hMrGCTXaO6DBwOLAy0pfh0EyyrnW0l+nY6btowW0inZaJ5oY/E4Y2VVFh+DUoiAM8Jj6R5qX6nO2zvCVu7UWOPYFo/Pt6uEHOyqnlr/VZPK4NSfkPdoMUEShP+yLaoWjnGlGeOI6KbUZZIjA2cBkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rlZVHMZ5; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso1234977a12.2
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 15:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712270737; x=1712875537; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lsOQoN7hxmCV0LDs2mMcH4xPxMzlScVQ7Q1vgpJyJKk=;
        b=rlZVHMZ5nkCmofPXmmi5kTjbSpLrvOq/byimfIOESIbpsiotgBaEyJ0KkSol1Q4Yxl
         TXCtLx2omC+oJSC8zjG6u2g2XRqcOOkZNO/lupWYIiUnTnEdro5ShxZoupBwG5OyGP58
         2Sx8wSvr8QKAivlYwg1iQBmKCzTRzh5GPyhk3o92tZb1diLRU3a9PeFylHfWmDztp/Sd
         DkraUMslxAm7dWcF6ctGelMOB4lwE2kaKJA2+9poXjid/4i5q9F6A8hvkMbwrjch1Oks
         jNrmyxyN5upAODQj5Y45G1YPiJpmp8k3qiB5fPdNKZpJlBuIWxdZoMr61AOVDf1h471O
         72HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712270737; x=1712875537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lsOQoN7hxmCV0LDs2mMcH4xPxMzlScVQ7Q1vgpJyJKk=;
        b=v5nAprVPKMAUxDXdqzFHQhhoD2Uo+d6ia8JcfOGtiw3emPfGyw0E6zPHRgm825EGtj
         ruuvFWpWG7W+Hy0wS388jewEZjLo2W+Zr8uQ2qQNNKzbIREl3rda+PZN5lSt8Wmxh/5E
         B/7t1eAEOnux3t+Ngbpye3flCP6ayyon2oYQJluER9Bv0wsdQwsQrqB3yHwlrbGG098B
         HGons2xGgAmfEoClgHgybC4WDMRO/8fzweKiuUuI2dXN//jdVXzGLLgBu/9xczDqqt0N
         hd5/9hC5Aq1cZaACL1xc/9+l6ZT6ApOoOqto+OrX9Zt6eUba7nnSgQQVf6O46vOlM7Z9
         zqug==
X-Forwarded-Encrypted: i=1; AJvYcCW6qM7bfSTIhCHzaYfHNoJfrsOK0NRTEFObTenoGw7u8zqH5ybLGympll1lbflBnrzcUJzKt6EUMiu7dAEVoWsqHqDT
X-Gm-Message-State: AOJu0YwFfDNVeMTBC/SHyoNimyGHU231sQbZNIM7eLZ1JLkfPEcuuyyc
	5ox3/FWc/aw7CB3kE3ipv+lOjOD46Q/lxcufsYCxADPFhxRHzlhsMOYrjOgzJs7dRCuSjLf3Uy2
	Pcg==
X-Google-Smtp-Source: AGHT+IHbOI/wISwYIXG4Yqgo960LfMgv+MknEzIl12RXqwFok1pqEpcq60Iw38H2JOxRF9WKKXTO2txmBAo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2282:b0:1e2:b75e:37b5 with SMTP id
 b2-20020a170903228200b001e2b75e37b5mr2512plh.2.1712270737181; Thu, 04 Apr
 2024 15:45:37 -0700 (PDT)
Date: Thu, 4 Apr 2024 15:45:35 -0700
In-Reply-To: <1f30ab0f7a4dc09e65613f6dc1642fb821c64037.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
 <gnu6i2mz65ie2fmaz6yvmgsod6p67m7inxypujuxq7so6mtg2k@ed7pozauccka> <1f30ab0f7a4dc09e65613f6dc1642fb821c64037.camel@intel.com>
Message-ID: <Zg8tJspL9uBmMZFO@google.com>
Subject: Re: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Tina Zhang <tina.zhang@intel.com>, 
	Hang Yuan <hang.yuan@intel.com>, Bo Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	Erdem Aktas <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 04, 2024, Kai Huang wrote:
> On Thu, 2024-04-04 at 16:22 +0300, Kirill A. Shutemov wrote:
> > On Mon, Feb 26, 2024 at 12:26:20AM -0800, isaku.yamahata@intel.com wrote:
> > > @@ -491,6 +494,87 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > >  	 */
> > >  }
> > >  
> > > +static noinstr void tdx_vcpu_enter_exit(struct vcpu_tdx *tdx)
> > > +{
> > 
> > ...
> > 
> > > +	tdx->exit_reason.full = __seamcall_saved_ret(TDH_VP_ENTER, &args);
> > 
> > Call to __seamcall_saved_ret() leaves noinstr section.
> > 
> > __seamcall_saved_ret() has to be moved:
> > 
> > diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
> > index e32cf82ed47e..6b434ab12db6 100644
> > --- a/arch/x86/virt/vmx/tdx/seamcall.S
> > +++ b/arch/x86/virt/vmx/tdx/seamcall.S
> > @@ -44,6 +44,8 @@ SYM_FUNC_START(__seamcall_ret)
> >  SYM_FUNC_END(__seamcall_ret)
> >  EXPORT_SYMBOL_GPL(__seamcall_ret);
> >  
> > +.section .noinstr.text, "ax"
> > +
> >  /*
> >   * __seamcall_saved_ret() - Host-side interface functions to SEAM software
> >   * (the P-SEAMLDR or the TDX module), with saving output registers to the
> 
> Alternatively, I think we can explicitly use instrumentation_begin()/end()
> around __seamcall_saved_ret() here.

No, that will just paper over the complaint.  Dang it, I was going to say that
I called out earlier that tdx_vcpu_enter_exit() doesn't need to be noinstr, but
it looks like my brain and fingers didn't connect.

So I'll say it now :-)

I don't think tdx_vcpu_enter_exit() needs to be noinstr, because the SEAMCALL is
functionally a VM-Exit, and so all host state is saved/restored "atomically"
across the SEAMCALL (some by hardware, some by software (TDX-module)).

The reason the VM-Enter flows for VMX and SVM need to be noinstr is they do things
like load the guest's CR2, and handle NMI VM-Exits with NMIs blocks.  None of
that applies to TDX.  Either that, or there are some massive bugs lurking due to
missing code.

