Return-Path: <kvm+bounces-3156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1534801265
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 19:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F34BD1C20B44
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 18:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C194C4F206;
	Fri,  1 Dec 2023 18:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Ve1IKSeG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B75F9;
	Fri,  1 Dec 2023 10:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1701454571; x=1732990571;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=hgs3mkSW/WgX8t1/olpmhoODPmslM5+oH0THeK3eQWI=;
  b=Ve1IKSeGrYKw/Ba3YeqbRF91K7neoyETvtJoRUFj91T8Ck1RB+qSDNtO
   VU+mLSGTWt+fCQxBjWSCBEar2vOM4HLYM0lI08upasd2RpOqrHsic3pwP
   BU9Bqh2kHF65F89zUslqhLDp4GVatK/lPKY8Fr0FQpbFISNCKc85LwAJl
   I=;
X-IronPort-AV: E=Sophos;i="6.04,242,1695686400"; 
   d="scan'208";a="366083187"
Subject: Re: [RFC 05/33] KVM: x86: hyper-v: Introduce VTL call/return prologues in
 hypercall page
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 18:16:08 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id 9851BA6115;
	Fri,  1 Dec 2023 18:16:04 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:41546]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.14.81:2525] with esmtp (Farcaster)
 id 7a9e3de9-5dbc-4eed-a35e-b26a36385304; Fri, 1 Dec 2023 18:16:03 +0000 (UTC)
X-Farcaster-Flow-ID: 7a9e3de9-5dbc-4eed-a35e-b26a36385304
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 1 Dec 2023 18:16:03 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 1 Dec
 2023 18:15:59 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 1 Dec 2023 18:15:55 +0000
Message-ID: <CXD7AW5T9R7G.2REFR2IRSVRVZ@amazon.com>
CC: Maxim Levitsky <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <vkuznets@redhat.com>, <anelkz@amazon.com>,
	<graf@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<kys@microsoft.com>, <haiyangz@microsoft.com>, <decui@microsoft.com>,
	<x86@kernel.org>, <linux-doc@vger.kernel.org>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-6-nsaenz@amazon.com>
 <f4495d1f697cf9a7ddfb786eaeeac90f554fc6db.camel@redhat.com>
 <CXD4TVV5QWUK.3SH495QSBTTUF@amazon.com> <ZWoKlJUKJGGhRRgM@google.com>
 <CXD5HJ5LQMTE.11XP9UB9IL8LY@amazon.com> <ZWocI-2ajwudA-S5@google.com>
In-Reply-To: <ZWocI-2ajwudA-S5@google.com>
X-ClientProxiedBy: EX19D033UWC002.ant.amazon.com (10.13.139.196) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Fri Dec 1, 2023 at 5:47 PM UTC, Sean Christopherson wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you can confirm the sender and know t=
he content is safe.
>
>
>
> On Fri, Dec 01, 2023, Nicolas Saenz Julienne wrote:
> > On Fri Dec 1, 2023 at 4:32 PM UTC, Sean Christopherson wrote:
> > > On Fri, Dec 01, 2023, Nicolas Saenz Julienne wrote:
> > > > > To support this I think that we can add a userspace msr filter on=
 the HV_X64_MSR_HYPERCALL,
> > > > > although I am not 100% sure if a userspace msr filter overrides t=
he in-kernel msr handling.
> > > >
> > > > I thought about it at the time. It's not that simple though, we sho=
uld
> > > > still let KVM set the hypercall bytecode, and other quirks like the=
 Xen
> > > > one.
> > >
> > > Yeah, that Xen quirk is quite the killer.
> > >
> > > Can you provide pseudo-assembly for what the final page is supposed t=
o look like?
> > > I'm struggling mightily to understand what this is actually trying to=
 do.
> >
> > I'll make it as simple as possible (diregard 32bit support and that xen
> > exists):
> >
> > vmcall             <-  Offset 0, regular Hyper-V hypercalls enter here
> > ret
> > mov rax,rcx  <-  VTL call hypercall enters here
>
> I'm missing who/what defines "here" though.  What generates the CALL that=
 points
> at this exact offset?  If the exact offset is dictated in the TLFS, then =
aren't
> we screwed with the whole Xen quirk, which inserts 5 bytes before that fi=
rst VMCALL?

Yes, sorry, I should've included some more context.

Here's a rundown (from memory) of how the first VTL call happens:
 - CPU0 start running at VTL0.
 - Hyper-V enables VTL1 on the partition.
 - Hyper-V enabled VTL1 on CPU0, but doesn't yet switch to it. It passes
   the initial VTL1 CPU state alongside the enablement hypercall
   arguments.
 - Hyper-V sets the Hypercall page overlay address through
   HV_X64_MSR_HYPERCALL. KVM fills it.
 - Hyper-V gets the VTL-call and VTL-return offset into the hypercall
   page using the VP Register HvRegisterVsmCodePageOffsets (VP register
   handling is in user-space).
 - Hyper-V performs the first VTL-call, and has all it needs to move
   between VTL0/1.

Nicolas

