Return-Path: <kvm+bounces-3143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3D6801026
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:32:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80B571C20A72
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D264D126;
	Fri,  1 Dec 2023 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="UOoPmUbu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7377B1B4;
	Fri,  1 Dec 2023 08:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1701448329; x=1732984329;
  h=mime-version:content-transfer-encoding:date:message-id:
   from:to:cc:references:in-reply-to:subject;
  bh=ZaGh4NUVdUvAF2JRuqkM6YevRneIAqjnG/wz+NwAVWM=;
  b=UOoPmUburc8PU00UFJ3fXA5vkXYOiRoa9pyXoMRxXPUcDCSoe5Cp9yKY
   QlZ/9XWPF+LELoo9/4rQYuwBcPOrpw/hDmL3SNph6h7VRRvwu+11RJdYu
   3NiN4v0SljxXjbu/+vu0hnMeBtRNv+fPPkFzPRo+TegCU/lwc7dJRkB9M
   Y=;
X-IronPort-AV: E=Sophos;i="6.04,242,1695686400"; 
   d="scan'208";a="169494766"
Subject: Re: [RFC 06/33] KVM: x86: hyper-v: Introduce VTL awareness to Hyper-V's
 PV-IPIs
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 16:32:06 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com (Postfix) with ESMTPS id D2299818A5;
	Fri,  1 Dec 2023 16:32:03 +0000 (UTC)
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:13312]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.183:2525] with esmtp (Farcaster)
 id e5b27342-2f4b-43fa-bd5c-99ff36690156; Fri, 1 Dec 2023 16:32:02 +0000 (UTC)
X-Farcaster-Flow-ID: e5b27342-2f4b-43fa-bd5c-99ff36690156
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 1 Dec 2023 16:32:02 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 1 Dec
 2023 16:31:57 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 1 Dec 2023 16:31:54 +0000
Message-ID: <CXD538WSGHGC.BMUQF0OJSSW4@amazon.com>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Maxim Levitsky <mlevitsk@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-7-nsaenz@amazon.com>
 <9249b4b84f7b84da2ea21fbbbabf35f22e5d9f2f.camel@redhat.com>
In-Reply-To: <9249b4b84f7b84da2ea21fbbbabf35f22e5d9f2f.camel@redhat.com>
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Tue Nov 28, 2023 at 7:14 AM UTC, Maxim Levitsky wrote:
> On Wed, 2023-11-08 at 11:17 +0000, Nicolas Saenz Julienne wrote:
> > HVCALL_SEND_IPI and HVCALL_SEND_IPI_EX allow targeting specific a
> > specific VTL. Honour the requests.
> >
> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> > ---
> >  arch/x86/kvm/hyperv.c             | 24 +++++++++++++++++-------
> >  arch/x86/kvm/trace.h              | 20 ++++++++++++--------
> >  include/asm-generic/hyperv-tlfs.h |  6 ++++--
> >  3 files changed, 33 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index d4b1b53ea63d..2cf430f6ddd8 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -2230,7 +2230,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu=
, struct kvm_hv_hcall *hc)
> >  }
> >
> >  static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
> > -                                 u64 *sparse_banks, u64 valid_bank_mas=
k)
> > +                                 u64 *sparse_banks, u64 valid_bank_mas=
k, int vtl)
> >  {
> >       struct kvm_lapic_irq irq =3D {
> >               .delivery_mode =3D APIC_DM_FIXED,
> > @@ -2245,6 +2245,9 @@ static void kvm_hv_send_ipi_to_many(struct kvm *k=
vm, u32 vector,
> >                                           valid_bank_mask, sparse_banks=
))
> >                       continue;
> >
> > +             if (kvm_hv_get_active_vtl(vcpu) !=3D vtl)
> > +                     continue;
>
> Do I understand correctly that this is a temporary limitation?
> In other words, can a vCPU running in VTL1 send an IPI to a vCPU running =
VTL0,
> forcing the target vCPU to do async switch to VTL1?
> I think that this is possible.


The diff is missing some context. See this simplified implementation
(when all_cpus is set in the parent function):

static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector, int vtl)
{
	[...]
	kvm_for_each_vcpu(i, vcpu, kvm) {
		if (kvm_hv_get_active_vtl(vcpu) !=3D vtl)
			continue;

		kvm_apic_set_irq(vcpu, &irq, NULL);
	}
}

With the one vCPU per VTL approach, kvm_for_each_vcpu() will iterate
over *all* vCPUs regardless of their VTL. The IPI is targetted at a
specific VTL, hence the need to filter.

VTL1 -> VTL0 IPIs are supported and happen (although they are extremely
rare).

Nicolas

