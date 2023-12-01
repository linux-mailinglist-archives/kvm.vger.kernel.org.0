Return-Path: <kvm+bounces-3146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E584E80108E
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 827ECB21342
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B07A4CE18;
	Fri,  1 Dec 2023 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="YGd1sdhU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D4DCF;
	Fri,  1 Dec 2023 08:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1701449456; x=1732985456;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=jzcYp1+G+LJEnQ/Nf3Fzjvbwr6w5g4s4GfO6LThiCsM=;
  b=YGd1sdhUJvsAsu+ui9H2wz6mzVWzUx+6XYufrcCwuMNs4l9CyHhCZ1+2
   g4FIpKbc2GULZYhOhaq6mYNjODdsJdO6FFeIWuadHyDHATzQFghR+GOWa
   CNCv4TH9Q5ZhS5RAPbVuZqRvzgQPbpj6lonoivQSEMN1DNbOMT0/3bo2H
   k=;
X-IronPort-AV: E=Sophos;i="6.04,242,1695686400"; 
   d="scan'208";a="688377607"
Subject: Re: [RFC 05/33] KVM: x86: hyper-v: Introduce VTL call/return prologues in
 hypercall page
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 16:50:50 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com (Postfix) with ESMTPS id D414C40DA8;
	Fri,  1 Dec 2023 16:50:47 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:43089]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.14.81:2525] with esmtp (Farcaster)
 id 82517984-b528-4c7f-9edc-388069a39df6; Fri, 1 Dec 2023 16:50:46 +0000 (UTC)
X-Farcaster-Flow-ID: 82517984-b528-4c7f-9edc-388069a39df6
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 1 Dec 2023 16:50:41 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 1 Dec
 2023 16:50:37 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 1 Dec 2023 16:50:33 +0000
Message-ID: <CXD5HJ5LQMTE.11XP9UB9IL8LY@amazon.com>
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
In-Reply-To: <ZWoKlJUKJGGhRRgM@google.com>
X-ClientProxiedBy: EX19D032UWB004.ant.amazon.com (10.13.139.136) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Fri Dec 1, 2023 at 4:32 PM UTC, Sean Christopherson wrote:
> On Fri, Dec 01, 2023, Nicolas Saenz Julienne wrote:
> > > To support this I think that we can add a userspace msr filter on the=
 HV_X64_MSR_HYPERCALL,
> > > although I am not 100% sure if a userspace msr filter overrides the i=
n-kernel msr handling.
> >
> > I thought about it at the time. It's not that simple though, we should
> > still let KVM set the hypercall bytecode, and other quirks like the Xen
> > one.
>
> Yeah, that Xen quirk is quite the killer.
>
> Can you provide pseudo-assembly for what the final page is supposed to lo=
ok like?
> I'm struggling mightily to understand what this is actually trying to do.

I'll make it as simple as possible (diregard 32bit support and that xen
exists):

vmcall	     <-  Offset 0, regular Hyper-V hypercalls enter here
ret
mov rax,rcx  <-  VTL call hypercall enters here
mov rcx,0x11
vmcall
ret
mov rax,rcx  <-  VTL return hypercall enters here
mov rcx,0x12
vmcall
ret

rcx needs to be saved as it contains a "VTL call control input to the
hypervisor" (TLFS 15.6.1). I don't remember seeing it being used in
practice. Then, KVM expects the hypercall code in rcx, hence the
0x11/0x12 mov.

Nicolas

