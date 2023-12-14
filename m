Return-Path: <kvm+bounces-4456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D376812BBC
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:31:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CDF41C2153C
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 09:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6492EB09;
	Thu, 14 Dec 2023 09:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f5sXNC1A"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8B5A6
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 01:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702546290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tTE0cMZgmLT4mbBDje7gzm+ln7P9WsJQeR7EiRHzoUg=;
	b=f5sXNC1A7XZe3RNYucaDlQL/OepM/HPXECyKAexugVZLcqR/9Q9Jx6IE7nQU0DdNVtV0jQ
	r+x/Rz8aL92XjiBdLY5MVJycllH0ex/ZWvHk6fhb8Cu0oCAhtTWQsLCLprT8gbXFeeUjlT
	CHrQ3FZ+gIkiyBQoOpxpFGjUhH3oAUY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-4aMuPSAuPJWrWOrb5jGIaQ-1; Thu, 14 Dec 2023 04:31:27 -0500
X-MC-Unique: 4aMuPSAuPJWrWOrb5jGIaQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40c2a43b0f3so53760635e9.2
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 01:31:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702546286; x=1703151086;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tTE0cMZgmLT4mbBDje7gzm+ln7P9WsJQeR7EiRHzoUg=;
        b=CcYF/CT/A24QWiaYvcQrOcIlg3lnqoqgEBpNL4VwSObbYrf3lmAx32Gsr6Oe0En8/i
         Sn1qoWdlJeQDCa9zmc9sF1Kl2E75S7xVO09I37bbcKLKfE6CyVGLfZ7wDSyyfcOv/Eqg
         TQ6hjoF65AXCRDn8ax2bbIb6wFL1aDojgFQ8ShVEcch7juvBwn1aetMUvvPpweh17evW
         0pARQZTFO8u2L2N8rLvgNJ+nc6gZnO+F7B0S12ZJLbaVqPo0zTFCN2PsK6AYX2qj9vRe
         ydAkZVgo3FNZldSCNfldjx99n2tAdx3ZZLCO1w9+gTK55uS0zNqWfPuHcyF2wkZJHsWw
         EBrA==
X-Gm-Message-State: AOJu0Ywx3FgmL7hHK5UCf/nYNT7vLgwLq0DVl9k9RTnnP8osY6QOZ32U
	dOtPdtdH/llPlJYJV4ZdSHCz+SVtO0or4tDGZa2XZ1jBfTts2Tbt/msXshBCN/Yto84W6JkZpH+
	89zbpjNqJ3kLa
X-Received: by 2002:a05:600c:188f:b0:40c:32e6:d567 with SMTP id x15-20020a05600c188f00b0040c32e6d567mr3338888wmp.119.1702546286721;
        Thu, 14 Dec 2023 01:31:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFRxP7fEK8hsKy8ujv5AAy1+oBp2F4A/KQqv4ZVDGZIIzspF+szw+DRvb7Fz+JaTSBb7ZWKhg==
X-Received: by 2002:a05:600c:188f:b0:40c:32e6:d567 with SMTP id x15-20020a05600c188f00b0040c32e6d567mr3338872wmp.119.1702546286273;
        Thu, 14 Dec 2023 01:31:26 -0800 (PST)
Received: from starship ([77.137.131.62])
        by smtp.gmail.com with ESMTPSA id fl9-20020a05600c0b8900b0040b43da0bbasm24076640wmb.30.2023.12.14.01.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 01:31:25 -0800 (PST)
Message-ID: <aa7aa5ea5b112a0ec70c6276beb281e19c052f0e.camel@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Make the hardcoded APIC bus frequency
 vm variable
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,  isaku.yamahata@gmail.com, Paolo Bonzini
 <pbonzini@redhat.com>,  erdemaktas@google.com, Vishal Annapurve
 <vannapurve@google.com>, Jim Mattson <jmattson@google.com>
Date: Thu, 14 Dec 2023 11:31:24 +0200
In-Reply-To: <ZXo54VNuIqbMsYv-@google.com>
References: <cover.1699936040.git.isaku.yamahata@intel.com>
	 <1c12f378af7de16d7895f8badb18c3b1715e9271.1699936040.git.isaku.yamahata@intel.com>
	 <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com>
	 <ZXo54VNuIqbMsYv-@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-12-13 at 15:10 -0800, Sean Christopherson wrote:
> On Thu, Dec 14, 2023, Maxim Levitsky wrote:
> > On Mon, 2023-11-13 at 20:35 -0800, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > TDX virtualizes the advertised APIC bus frequency to be 25MHz. 
> > 
> > Can you explain a bit better why TDX needs this? I am not familiar
> > with TDX well enough yet to fully understand.
> 
> TDX (the module/architecture) hardcodes the core crystal frequency to 25Mhz,
> whereas KVM hardcodes the APIC bus frequency to 1Ghz.  And TDX (again, the module)
> *unconditionally* enumerates CPUID 0x15 to TDX guests, i.e. _tells_ the guest that
> the frequency is 25MHz regardless of what the VMM/hypervisor actually emulates.
> And so the guest skips calibrating the APIC timer, which results in the guest
> scheduling timer interrupts waaaaaaay too frequently, i.e. the guest ends up
> gettings interrupts at 40x the rate it wants.

That is what I wanted to hear without opening the PRM ;) - so there is a CPUID leaf,
but KVM just doesn't advertise it. Now it makes sense.

Please add something like that to the commit message:

"TDX guests have the APIC bus frequency hardcoded to 25 Mhz in the CPUID leaf 0x15.
KVM doesn't expose this leaf, but TDX mandates it to be exposed,
and doesn't allow to override it's value either.

To ensure that the guest doesn't have a conflicting view of the APIC bus frequency, 
allow the userspace to tell KVM to use the same frequency that TDX mandates,
instead of the default 1Ghz"

> 
> Upstream KVM's non-TDX behavior is fine, because KVM doesn't advertise support
> for CPUID 0x15, i.e. doesn't announce to host userspace that it's safe to expose
> CPUID 0x15 to the guest.  Because TDX makes exposing CPUID 0x15 mandatory, KVM
> needs to be taught to correctly emulate the guest's APIC bus frequency, a.k.a.
> the TDX guest core crystal frequency of 25Mhz.

I assume that TDX doesn't allow to change the CPUID 0x15 leaf.

> 
> I halfheartedly floated the idea of "fixing" the TDX module/architecture to either
> use 1Ghz as the base frequency (off list), but it definitely isn't a hill worth
> dying on since the KVM changes are relatively simple.
> 
> https://lore.kernel.org/all/ZSnIKQ4bUavAtBz6@google.com
> 

Best regards,
	Maxim Levitsky


