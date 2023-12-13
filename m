Return-Path: <kvm+bounces-4401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93489812166
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 23:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD1D0B21244
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 22:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6C28182E;
	Wed, 13 Dec 2023 22:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YL+HWKix"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CE49C
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 14:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702506356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GtHNIqYNLvneVefWnBC6zOfsKWdZrXaTN0MEXSsNlm4=;
	b=YL+HWKixxRZDtjayL4IGhuxJaNn+EhTwhRVwbLqYBYbdxAMg10OSspGWG0GJDPQi+MBHNK
	6t87v77FBfU0RTR12wa5IWNpzWSDupxmbmCDSsR4qbL1kZRP/fKLrPu7kuftg+0bKGJjKr
	4Gh5Mr51BVsyrE8Ydqoto5lDEOdHDoE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-ZEmR8ivDOo-m2ZHtS5Ou6g-1; Wed, 13 Dec 2023 17:25:55 -0500
X-MC-Unique: ZEmR8ivDOo-m2ZHtS5Ou6g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40c22bc1ebdso50835e9.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 14:25:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702506354; x=1703111154;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GtHNIqYNLvneVefWnBC6zOfsKWdZrXaTN0MEXSsNlm4=;
        b=bBhFXFGKBZXjwmeKh5vCBU3lcRaWioZxuflr9zvZkwIwasCYn7nFfC9SVwTs9DW2Do
         ONqVcTdKTeHYFnHv7zRZBNcCIUcqm0ijdRqe+ey8MwIIWyBa22mNGQz9yf1g7HLOhj8k
         cKwWifAH0yUDUepXBDNmNgW+na6BI4MAFS6G9UC+U00JQYNG03kb24ZwtR2the42CCo7
         diGotqqUx65yEDd43WgafVTWG1ZGl3PQMGuNQ0x6rKHciLS4ENeXbmABoynEgdUzeYJm
         QsWcvwXeGStpxooblzUGllqXTSq1w2sQOW4UfWKqQfPvNjz1GYDpnuN/zW88Hc6WPzNc
         ROWA==
X-Gm-Message-State: AOJu0YzV8Cg/y5ooDSScxIh44rTyOGAy9dc+IwuHxHv6clbnEmPU22GQ
	9xky+JkfgmoXdtfsGDzStGxCiCbMa1fKqRxid65NNHBtTFoNT/+tdX8wWQR0Pk3CZT0qY4Ohfkx
	niiJhTYF5eCZL
X-Received: by 2002:a05:600c:518a:b0:40b:5e4a:2354 with SMTP id fa10-20020a05600c518a00b0040b5e4a2354mr4800764wmb.86.1702506354405;
        Wed, 13 Dec 2023 14:25:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGq5vSBS9iWIl4hhY+47LaF7O2e11U2yVs0UmGQ3dWeLwMn5yVhoe2ukGq+e6/HNoX4k1QrCw==
X-Received: by 2002:a05:600c:518a:b0:40b:5e4a:2354 with SMTP id fa10-20020a05600c518a00b0040b5e4a2354mr4800760wmb.86.1702506354019;
        Wed, 13 Dec 2023 14:25:54 -0800 (PST)
Received: from starship ([77.137.131.62])
        by smtp.gmail.com with ESMTPSA id m27-20020a05600c3b1b00b0040b38292253sm24509354wms.30.2023.12.13.14.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 14:25:53 -0800 (PST)
Message-ID: <5ca5592b21131f515e296afae006e5bb28b1fb87.camel@redhat.com>
Subject: Re: [PATCH v4 10/12] KVM: x86: never write to memory from
 kvm_vcpu_check_block()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Jim Mattson
 <jmattson@google.com>
Cc: alexandru.elisei@arm.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	atishp@atishpatra.org, borntraeger@linux.ibm.com, chenhuacai@kernel.org, 
	david@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	james.morse@arm.com, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, oliver.upton@linux.dev, 
	palmer@dabbelt.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	suzuki.poulose@arm.com
Date: Thu, 14 Dec 2023 00:25:50 +0200
In-Reply-To: <ZXh8Nq_y_szj1WN0@google.com>
References: <20220921003201.1441511-11-seanjc@google.com>
	 <20231207010302.2240506-1-jmattson@google.com>
	 <ZXHw7tykubfG04Um@google.com>
	 <CALMp9eTT97oDmQT7pxeOMLQbt-371aMtC2Kev+-kWXVRDVrjeg@mail.gmail.com>
	 <ZXh8Nq_y_szj1WN0@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2023-12-12 at 07:28 -0800, Sean Christopherson wrote:
> On Sun, Dec 10, 2023, Jim Mattson wrote:
> > On Thu, Dec 7, 2023 at 8:21 AM Sean Christopherson <seanjc@google.com> wrote:
> > > Doh.  We got the less obvious cases and missed the obvious one.
> > > 
> > > Ugh, and we also missed a related mess in kvm_guest_apic_has_interrupt().  That
> > > thing should really be folded into vmx_has_nested_events().
> > > 
> > > Good gravy.  And vmx_interrupt_blocked() does the wrong thing because that
> > > specifically checks if L1 interrupts are blocked.
> > > 
> > > Compile tested only, and definitely needs to be chunked into multiple patches,
> > > but I think something like this mess?
> > 
> > The proposed patch does not fix the problem. In fact, it messes things
> > up so much that I don't get any test results back.
> 
> Drat.
> 
> > Google has an internal K-U-T test that demonstrates the problem. I
> > will post it soon.
> 
> Received, I'll dig in soonish, though "soonish" might unfortunately might mean
> 2024.
> 

Hi,

So this is what I think:


KVM does have kvm_guest_apic_has_interrupt() for this exact purpose,
to check if nested APICv has a pending interrupt before halting.


However the problem is bigger - with APICv we have in essence 2 pending interrupt
bitmaps - the PIR and the IRR, and to know if the guest has a pending interrupt
one has in theory to copy PIR to IRR, then see if the max is larger then the current PPR.

Since we don't want to write to guest memory, and the IRR here resides in the guest memory,
I guess we have to do a 'dry-run' version of 'vmx_complete_nested_posted_interrupt' and call
it from  kvm_guest_apic_has_interrupt().

What do you think? I can prepare a patch for this.

Can you share a reproducer or write a new one that can be shared?

Best regards,
	Maxim Levitsky


