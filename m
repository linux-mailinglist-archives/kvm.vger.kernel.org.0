Return-Path: <kvm+bounces-18351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E8E8D41E0
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 01:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D84431C21EE3
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 23:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D001115D5A3;
	Wed, 29 May 2024 23:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JSLG9eGc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B3414AD3F
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 23:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717024505; cv=none; b=KnEdjJG7raDCicvtGWcOgSlq0WfBTUy8G0R2B4fMG7EvjrXPMFAO/Umn+WnofJ5tlEuU13e4ll8IvqgcgiO8Mze+uFM7lvS3g+u/vN/xF3xoaa0MIGXeXHMSti6O+Nr3CPMpNLAD5ZnTexy7BLWl0+mWNITotfNlKDPR2yDN0sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717024505; c=relaxed/simple;
	bh=MjQOp5UWOk5r9+sxgG/QsPE0boIDxSM9o3fH5lVCqNA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IrR+A5D3nZGUVqlLoI+5pZv3F+hUdVxA0YBZ03xawR9Oxvu/pCfOIvMKDwrcigL3YEteZbmbRqDg2hgD5TpIBCq/SyrjTV6M/vc7E4OpG1soIGMIYnMdfw9rLT3LoyWPiegF5+xs+X3hfCZdEAaTvlJr4zpveP9qn+I0b1KBkJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JSLG9eGc; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7021d92087cso286353b3a.2
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 16:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717024503; x=1717629303; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dnabaEVJa/tSEflSlXJy3215kO3e1psGL7hL7HuyYb4=;
        b=JSLG9eGcjrUqQJCpBBxatZbmztvgdGeS/xS3j+QwwubNOga29Yr+6h2nJutLb5G6Qx
         VZD3zwYaRLNVE+g4L94VbP9EuISjgQCy3q4PFMaBXZ+08q5RoBHtqYpOzFNC12esxAQf
         uvL+qZsouha4LR0Ad9jU0duTiH4+iqcMWdAzITunqf7Z8HoKD6Gf98qEbvDAIZdMo+tG
         c/WYSTWedltkToJsIY9JE73vHizg6VQEinEoSnIzzBlhqNczav60K61P3XVW2ic1a7jl
         JwNP4Y8/Uc1GdukK2R/9768GAi+Du6AmHyN8VjDQbJnu5mquSH1BB1QAPeZajMCYIAcI
         7qUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717024503; x=1717629303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dnabaEVJa/tSEflSlXJy3215kO3e1psGL7hL7HuyYb4=;
        b=C1jZcSHKHwmzxDAcGS+V9cBVgPL3cEsUli6FTTIxbeg+FfUisGQZpP1hV//+3XlY0/
         wl6OgEPOZXxH/wyGp7bHInTWHwspswkpNXqLPJqFQkjkJmzSOdPAmxI1RiuutmRl5zgf
         isr1iE50ilx7wer3/IOu28SC6Mrr36n+5KyL3zMcIvjcocPoaXyNzd29DtS4tvnq/6EX
         8Ecc2XyTzFJc9GLLq5YY1M4W5GDIwRjJK79HXRqRUWBll6RrAP6qLSuZkFAS+9guWe1X
         JqMykZCA3BCdOhOQPf7xJrqYPwWreAqeeZ7WnF2un0NwsRaLdNJez3C2Iw7tJX4jo9yp
         9yWw==
X-Forwarded-Encrypted: i=1; AJvYcCX0k38SlxRLJs95qgr62nPHyZSEoPXq2j9To8jB/s7Z4Bei1M3sasUHbZK2ARTqQp0cmC0gKe/HRhUXYtpXer+HmGqN
X-Gm-Message-State: AOJu0YyJZSUZJjMQTm/EdAqbUPVCSValf6sN7xTDlRPh6ctZ7XoF4Hr3
	o6ffXioLJWyiN30zD7x9B2UsSnUcc4mVTLuUQtli3VcxtkqSY8x2WzaCyHCwJ4RMdqwxMN4Qedu
	2CA==
X-Google-Smtp-Source: AGHT+IFylHZJ0hSk/e3r/cyIF9npXxo5ZQGUUJErmVcpfAYzuY3QGo2W4ssjCBL/5bEcQamYl0UFx1wDS90=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d8b:b0:6ed:d215:9c30 with SMTP id
 d2e1a72fcca58-702313ff946mr19851b3a.6.1717024502862; Wed, 29 May 2024
 16:15:02 -0700 (PDT)
Date: Wed, 29 May 2024 16:15:01 -0700
In-Reply-To: <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <Zjz7bRcIpe8nL0Gs@google.com> <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
 <Zj1Ty6bqbwst4u_N@google.com> <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
 <20240509235522.GA480079@ls.amr.corp.intel.com> <Zj4phpnqYNoNTVeP@google.com> <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
Message-ID: <Zle29YsDN5Hff7Lo@google.com>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend specific
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Erdem Aktas <erdemaktas@google.com>, Sagi Shahar <sagis@google.com>, Bo2 Chen <chen.bo@intel.com>, 
	Hang Yuan <hang.yuan@intel.com>, Tina Zhang <tina.zhang@intel.com>, 
	isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, May 14, 2024, Kai Huang wrote:
> 
> 
> On 11/05/2024 2:04 am, Sean Christopherson wrote:
> > On Thu, May 09, 2024, Isaku Yamahata wrote:
> > > On Fri, May 10, 2024 at 11:19:44AM +1200, Kai Huang <kai.huang@intel.com> wrote:
> > > > On 10/05/2024 10:52 am, Sean Christopherson wrote:
> > > > > On Fri, May 10, 2024, Kai Huang wrote:
> > > > > > On 10/05/2024 4:35 am, Sean Christopherson wrote:
> > > > > > > KVM x86 limits KVM_MAX_VCPUS to 4096:
> > > > > > > 
> > > > > > >      config KVM_MAX_NR_VCPUS
> > > > > > > 	int "Maximum number of vCPUs per KVM guest"
> > > > > > > 	depends on KVM
> > > > > > > 	range 1024 4096
> > > > > > > 	default 4096 if MAXSMP
> > > > > > > 	default 1024
> > > > > > > 	help
> > > > > > > 
> > > > > > > whereas the limitation from TDX is apprarently simply due to TD_PARAMS taking
> > > > > > > a 16-bit unsigned value:
> > > > > > > 
> > > > > > >      #define TDX_MAX_VCPUS  (~(u16)0)
> > > > > > > 
> > > > > > > i.e. it will likely be _years_ before TDX's limitation matters, if it ever does.
> > > > > > > And _if_ it becomes a problem, we don't necessarily need to have a different
> > > > > > > _runtime_ limit for TDX, e.g. TDX support could be conditioned on KVM_MAX_NR_VCPUS
> > > > > > > being <= 64k.
> > > > > > 
> > > > > > Actually later versions of TDX module (starting from 1.5 AFAICT), the module
> > > > > > has a metadata field to report the maximum vCPUs that the module can support
> > > > > > for all TDX guests.
> > > > > 
> > > > > My quick glance at the 1.5 source shows that the limit is still effectively
> > > > > 0xffff, so again, who cares?  Assert on 0xffff compile time, and on the reported
> > > > > max at runtime and simply refuse to use a TDX module that has dropped the minimum
> > > > > below 0xffff.
> > > > 
> > > > I need to double check why this metadata field was added.  My concern is in
> > > > future module versions they may just low down the value.
> > > 
> > > TD partitioning would reduce it much.
> > 
> > That's still not a reason to plumb in what is effectively dead code.  Either
> > partitioning is opt-in, at which I suspect KVM will need yet more uAPI to express
> > the limitations to userspace, or the TDX-module is potentially breaking existing
> > use cases.
> 
> The 'max_vcpus_per_td' global metadata fields is static for the TDX module.
> If the module supports the TD partitioning, it just reports some smaller
> value regardless whether we opt-in TDX partitioning or not.
> 
> I think the point is this 'max_vcpus_per_td' is TDX architectural thing and
> kernel should not make any assumption of the value of it.

It's not an assumption, it's a requirement.  And KVM already places requirements
on "hardware", e.g. kvm-intel.ko will refuse to load if the CPU doesn't support
a bare mimimum VMX feature set.  Refusing to enable TDX because max_vcpus_per_td
is unexpectedly low isn't fundamentally different than refusing to enable VMX
because IRQ window exiting is unsupported.

In the unlikely event there is a legitimate reason for max_vcpus_per_td being
less than KVM's minimum, then we can update KVM's minimum as needed.  But AFAICT,
that's purely theoretical at this point, i.e. this is all much ado about nothing.

