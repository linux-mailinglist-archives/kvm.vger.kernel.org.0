Return-Path: <kvm+bounces-14257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC1D8A169C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 16:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 204A8289840
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1376150981;
	Thu, 11 Apr 2024 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rNdUaFYV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9580B14F9F2
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712844231; cv=none; b=jAgVI5xkiB6P2JWlZASjaCFWVZ2KhpLccLfLSN8wKdtjOxnyNk+sSBEHwTwarThfZPqaLl+0UP5QhAkrgBBoKZ6PrUzJSqzpasPiarlDRD+ybi1yMpr3/rVKhNNu03N3hf+14/YOcm33FrkNoCGo5+MsgTFCXMiXJLXJ976NjrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712844231; c=relaxed/simple;
	bh=0xnaIVIg2McZSemKKHSu5d2zpo1EqA8Xpzut4W7GquE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O+7N4TYMr1Fgh7WtMqsT2PVOtZK38bDTFZ7xy1Lk9OwxeCVHJucseMwY+RCAJkxEWUbZ9H7dwjnEoL0WYtYxe8ht+0NXYBThbInxviKvoJe0o2OqLYfcaqpeif8/9VyUFGfx/lYPHS0qIshlT9RwzYwD0LTv1sr+zODk09JlUWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rNdUaFYV; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5c670f70a37so6406882a12.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 07:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712844230; x=1713449030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gv0uEmfxcV0o1KTjrBW7d5VYbmIjgWwr011CMxJ3/SQ=;
        b=rNdUaFYVLCCqMjPRUfK0aOjB7fvQV58qgYK2GDle8opaogiiJVfdZ3b6c/2bpi10R+
         H290r4rrTSEbhzrbOUur5qWUhsyWauhgreSBGGwz5rGdt+a9emKE759hsMDuUqlmyJHK
         My/h2JdqtNXDGcCLLFKOuZvtQiWUoGHDDcdO8rKVkW1jXNMPMvEAogcbT3ZcSdBvazj2
         ORzyLBurIfXH+MSEroVfMHJFykHF8X0Fmxf3ay9p+mYTnRBl+y2mYpeN/mnmAzjD6ThC
         SfKmNH2df0M7iVvNrLwqR4sgioVYxilt0Sg9gh626GXKmMOQk4TWGRwR963Biac/amWA
         WrCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712844230; x=1713449030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gv0uEmfxcV0o1KTjrBW7d5VYbmIjgWwr011CMxJ3/SQ=;
        b=DOi6i/8w27Q16emmAq4cLLtow5/ymctSFOPvq592YtMUCubzX+NAZXHXx8a54dYnad
         friSh7W5gUe2NmZNCpL5RVS0Br9P3Ly8DkZoyQzJ1RIFFaNHbaSEUUXkh0PteQ4n7MvA
         sej2xiWnC6Gma+35vZpFUrwXkbsKLGT2IolDEbhKAqWCsIYhH3GkA3DGQlLeQHuhA4pc
         Y+ikNZ9BjD7F8qNFBvLj/ZByRP70MLPcj7RMoieO08nhfflhcCtekFXsyTsNAefY8zxy
         MtIIdSnK3zvZETJ8IXo/WF6usM+bvtU2qsPVoPchgkZJuMiBf+hFG97coOGF9Y4U/CV0
         DwbA==
X-Forwarded-Encrypted: i=1; AJvYcCWEXSgSSoto1NPmyJ+NWC9zHiPfeybo+9aeGWYq9yBImKIO1O3mWIfw4iA1OhJR6ont/BFdCOBjreQ05FZN8qOpYCZ1
X-Gm-Message-State: AOJu0Yxao9dk5nqHiHsJ1ptYduAvCtPyDhXrwWTivyDLFU08EH3lxi7Y
	p/DMrpjtGGqYe5M3CKZkjGgyhmP1PrpHfbprtWCrJz19jqdNPrhaLeN6J5awH7jMjMkqA93uJ1U
	ODA==
X-Google-Smtp-Source: AGHT+IGCBKb+/q7mp/Pz7v3jWdmvLYqh/ube4SzG6l4AN6rGygZBLDlMvzmZJYmfuyzkEyyPAOgyikAjgv0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2290:b0:1e5:57ac:a7aa with SMTP id
 b16-20020a170903229000b001e557aca7aamr138693plh.10.1712844229893; Thu, 11 Apr
 2024 07:03:49 -0700 (PDT)
Date: Thu, 11 Apr 2024 07:03:48 -0700
In-Reply-To: <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
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
Message-ID: <Zhftbqo-0lW-uGGg@google.com>
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

On Thu, Apr 11, 2024, Kai Huang wrote:
> On 11/04/2024 3:29 am, Sean Christopherson wrote:
> > On Wed, Apr 10, 2024, Kai Huang wrote:
> > > > > What happens if any CPU goes online *BETWEEN* tdx_hardware_setup() and
> > > > > kvm_init()?
> > > > > 
> > > > > Looks we have two options:
> > > > > 
> > > > > 1) move registering CPU hotplug callback before tdx_hardware_setup(), or
> > > > > 2) we need to disable CPU hotplug until callbacks have been registered.
> > 
> > This is all so dumb (not TDX, the current state of KVM).  All of the hardware
> > enabling crud is pointless complex inherited from misguided, decade old paranoia
> > that led to the decision to enable VMX if and only if VMs are running.  Enabling
> > VMX doesn't make the system less secure, and the insane dances we are doing to
> > do VMXON on-demand makes everything *more* fragile.
> > 
> > And all of this complexity really was driven by VMX, enabling virtualization for
> > every other vendor, including AMD/SVM, is completely uninteresting.  Forcing other
> > architectures/vendors to take on yet more complexity doesn't make any sense.
> 
> Ah, I actually preferred this solution, but I was trying to follow your
> suggestion here:
> 
> https://lore.kernel.org/lkml/ZW6FRBnOwYV-UCkY@google.com/
> 
> form which I interpreted you didn't like always having VMX enabled when KVM
> is present. :-)

I had a feeling I said something along those lines in the past.  

> > Barely tested, and other architectures would need to be converted, but I don't
> > see any obvious reasons why we can't simply enable virtualization when the module
> > is loaded.
> > 
> > The diffstat pretty much says it all.
> 
> Thanks a lot for the code!
> 
> I can certainly follow up with this and generate a reviewable patchset if I
> can confirm with you that this is what you want?

Yes, I think it's the right direction.  I still have minor concerns about VMX
being enabled while kvm.ko is loaded, which means that VMXON will _always_ be
enabled if KVM is built-in.  But after seeing the complexity that is needed to
safely initialize TDX, and after seeing just how much complexity KVM already
has because it enables VMX on-demand (I hadn't actually tried removing that code
before), I think the cost of that complexity far outweighs the risk of "always"
being post-VMXON.

Within reason, I recommend getting feedback from others before you spend _too_
much time on this.  It's entirely possible I'm missing/forgetting some other angle.

