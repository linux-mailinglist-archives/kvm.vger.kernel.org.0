Return-Path: <kvm+bounces-3588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6282805824
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 16:03:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D0301F217A5
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 15:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0222B67E86;
	Tue,  5 Dec 2023 15:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ePTpLsfB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DB3C9
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 07:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701788575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RVfnz9yEraI13QEVMWCv15KSWf2rbynT5uHuzX4Khhk=;
	b=ePTpLsfB244PoNSMUqN/J7+/mCUxYwFG+Klo6c6MxrulyvoQMa5bG7n5EWEKPUw31qyDnl
	bifl10K9g7j6M//dwNj21PZP/JKFvk/cHvJ6eGW3cWqKyTIBXbQ/g9H3HzP7RD1Fd1iNZS
	1WgNq8Fvt49Flp4CBbINTb2kXcpLGKw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-t8DsjgwRPLOXOv0S2OozKw-1; Tue, 05 Dec 2023 10:02:46 -0500
X-MC-Unique: t8DsjgwRPLOXOv0S2OozKw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40bd5ea7aeaso23295985e9.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 07:02:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701788563; x=1702393363;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RVfnz9yEraI13QEVMWCv15KSWf2rbynT5uHuzX4Khhk=;
        b=O7ddps9LfDX+PXJyHQvrhPtM/sGX063cnToqeJZxkEqzxFPir0EQO/a3cn+sl4Nup7
         4d65zwIW5uLxGZ1FcrKekGg/RF1lmh6L5Hhi5UkcS3ytTwt9U2ktWXklTmQDJJox6ebI
         EpGKwRF1ra1bRVEFCws8WPl8aPWKTU9AvkOvFM+A0OQBanmolc35dcJbTx+vJar28tAC
         OfQv1LWcl/rEuxyV5qhTZeWfQ++bto7PBJPXOP0uTvbLoVw+uCuF/3xlCPmReOj99aww
         iX/quYRm8YBJMhE5bpDUWJqyelWReFfG0awm1zH56a13WDuwqSTWjM9KkhDwZmlAWx51
         8m0Q==
X-Gm-Message-State: AOJu0YyeMmR1MBy/n8Cn+/wE2QmdcKMFmx6XJK8umpVybLaq/trh0px3
	tgZ55cfWav5MAlHsKQFh3Yhjv4LlUf2mfrvRtRFM6LTdXcGmKG1z7dESwxueZyLuGi6svAupwCg
	80glTQ1onIZKiQBvAGDaS
X-Received: by 2002:a05:600c:4506:b0:40b:37ef:3671 with SMTP id t6-20020a05600c450600b0040b37ef3671mr4708324wmo.38.1701788563083;
        Tue, 05 Dec 2023 07:02:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFw+ZIqFfTxBo1MNegF8bmaDRUQK0S0GcC3WZpfcXrIP2tAUAD/esumx04OeKShDkq6yYuUlA==
X-Received: by 2002:a05:600c:4506:b0:40b:37ef:3671 with SMTP id t6-20020a05600c450600b0040b37ef3671mr4708304wmo.38.1701788562696;
        Tue, 05 Dec 2023 07:02:42 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id g16-20020a05600c4ed000b0040b47c53610sm18964395wmq.14.2023.12.05.07.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 07:02:42 -0800 (PST)
Message-ID: <72ab3fa2932dc661a4e0e124ac630e6bb269ebd4.camel@redhat.com>
Subject: Re: [RFC 06/33] KVM: x86: hyper-v: Introduce VTL awareness to
 Hyper-V's PV-IPIs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 anelkz@amazon.com,  graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com,
 corbert@lwn.net,  kys@microsoft.com, haiyangz@microsoft.com,
 decui@microsoft.com, x86@kernel.org,  linux-doc@vger.kernel.org
Date: Tue, 05 Dec 2023 17:02:40 +0200
In-Reply-To: <CXD538WSGHGC.BMUQF0OJSSW4@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-7-nsaenz@amazon.com>
	 <9249b4b84f7b84da2ea21fbbbabf35f22e5d9f2f.camel@redhat.com>
	 <CXD538WSGHGC.BMUQF0OJSSW4@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-12-01 at 16:31 +0000, Nicolas Saenz Julienne wrote:
> On Tue Nov 28, 2023 at 7:14 AM UTC, Maxim Levitsky wrote:
> > On Wed, 2023-11-08 at 11:17 +0000, Nicolas Saenz Julienne wrote:
> > > HVCALL_SEND_IPI and HVCALL_SEND_IPI_EX allow targeting specific a
> > > specific VTL. Honour the requests.
> > > 
> > > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> > > ---
> > >  arch/x86/kvm/hyperv.c             | 24 +++++++++++++++++-------
> > >  arch/x86/kvm/trace.h              | 20 ++++++++++++--------
> > >  include/asm-generic/hyperv-tlfs.h |  6 ++++--
> > >  3 files changed, 33 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > > index d4b1b53ea63d..2cf430f6ddd8 100644
> > > --- a/arch/x86/kvm/hyperv.c
> > > +++ b/arch/x86/kvm/hyperv.c
> > > @@ -2230,7 +2230,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
> > >  }
> > > 
> > >  static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
> > > -                                 u64 *sparse_banks, u64 valid_bank_mask)
> > > +                                 u64 *sparse_banks, u64 valid_bank_mask, int vtl)
> > >  {
> > >       struct kvm_lapic_irq irq = {
> > >               .delivery_mode = APIC_DM_FIXED,
> > > @@ -2245,6 +2245,9 @@ static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
> > >                                           valid_bank_mask, sparse_banks))
> > >                       continue;
> > > 
> > > +             if (kvm_hv_get_active_vtl(vcpu) != vtl)
> > > +                     continue;
> > 
> > Do I understand correctly that this is a temporary limitation?
> > In other words, can a vCPU running in VTL1 send an IPI to a vCPU running VTL0,
> > forcing the target vCPU to do async switch to VTL1?
> > I think that this is possible.
> 
> The diff is missing some context. See this simplified implementation
> (when all_cpus is set in the parent function):
> 
> static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector, int vtl)
> {
> 	[...]
> 	kvm_for_each_vcpu(i, vcpu, kvm) {
> 		if (kvm_hv_get_active_vtl(vcpu) != vtl)
> 			continue;
> 
> 		kvm_apic_set_irq(vcpu, &irq, NULL);
> 	}
> }
> 
> With the one vCPU per VTL approach, kvm_for_each_vcpu() will iterate
> over *all* vCPUs regardless of their VTL. The IPI is targetted at a
> specific VTL, hence the need to filter.
> 
> VTL1 -> VTL0 IPIs are supported and happen (although they are extremely
> rare).

Makes sense now, thanks!

Best regards,
	Maxim Levitsky

> 
> Nicolas
> 



