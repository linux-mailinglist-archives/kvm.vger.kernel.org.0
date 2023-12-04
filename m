Return-Path: <kvm+bounces-3305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24CFD802E93
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:28:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53C911C209E5
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92ABB199A4;
	Mon,  4 Dec 2023 09:28:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 904 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Dec 2023 01:28:38 PST
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F29B3
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 01:28:37 -0800 (PST)
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Sean Christopherson <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>
Subject: RE: [PATCH v2] KVM: x86: fix kvm_has_noapic_vcpu updates when fail to
 create vcpu
Thread-Topic: [PATCH v2] KVM: x86: fix kvm_has_noapic_vcpu updates when fail
 to create vcpu
Thread-Index: AQHaJHd/lgMJGZM9UUyLQebEeRkjvbCY2mvA
Date: Mon, 4 Dec 2023 09:13:06 +0000
Message-ID: <98bd6a9f7488462ab9d8cccdd339f7af@baidu.com>
References: <20231123010424.10274-1-lirongqing@baidu.com>
 <ZWoQfVxynCVv2_CB@google.com>
In-Reply-To: <ZWoQfVxynCVv2_CB@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.54
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Saturday, December 2, 2023 12:58 AM
> To: Li,Rongqing <lirongqing@baidu.com>
> Cc: x86@kernel.org; kvm@vger.kernel.org; mlevitsk@redhat.com;
> yilun.xu@linux.intel.com
> Subject: Re: [PATCH v2] KVM: x86: fix kvm_has_noapic_vcpu updates when fa=
il
> to create vcpu
>=20
> On Thu, Nov 23, 2023, Li RongQing wrote:
> > Static key kvm_has_noapic_vcpu should be reduced when fail to create
> > vcpu, opportunistically change to call kvm_free_lapic only when LAPIC
> > is in kernel in kvm_arch_vcpu_destroy
>=20
> Heh, this has been on my todo list for a comically long time.
>=20
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> > diff v1: call kvm_free_lapic conditionally in kvm_arch_vcpu_destroy
> >
> >  arch/x86/kvm/x86.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> > 2c92407..3cadf28 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12079,7 +12079,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
> *vcpu)
> >  	kfree(vcpu->arch.mci_ctl2_banks);
> >  	free_page((unsigned long)vcpu->arch.pio_data);
> >  fail_free_lapic:
> > -	kvm_free_lapic(vcpu);
> > +	if (lapic_in_kernel(vcpu))
> > +		kvm_free_lapic(vcpu);
> > +	else
> > +		static_branch_dec(&kvm_has_noapic_vcpu);
> >  fail_mmu_destroy:
> >  	kvm_mmu_destroy(vcpu);
> >  	return r;
> > @@ -12122,14 +12125,17 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu
> *vcpu)
> >  	kvm_pmu_destroy(vcpu);
> >  	kfree(vcpu->arch.mce_banks);
> >  	kfree(vcpu->arch.mci_ctl2_banks);
> > -	kvm_free_lapic(vcpu);
> > +
> > +	if (lapic_in_kernel(vcpu))
> > +		kvm_free_lapic(vcpu);
> > +	else
> > +		static_branch_dec(&kvm_has_noapic_vcpu);
>=20
> Rather than split code like this, what if we let the APIC code deal with =
bumping
> the static branch? =20

I am fine, thanks

-Li


