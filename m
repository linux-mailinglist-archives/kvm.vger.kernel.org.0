Return-Path: <kvm+bounces-2249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F907F3E51
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 07:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BF0EB218AA
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 06:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D132C2C7;
	Wed, 22 Nov 2023 06:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 925 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Nov 2023 22:47:01 PST
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4761AC
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 22:47:00 -0800 (PST)
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: RE: [PATCH] KVM: x86: fix kvm_has_noapic_vcpu updates when fail to
 create vcpu
Thread-Topic: [PATCH] KVM: x86: fix kvm_has_noapic_vcpu updates when fail to
 create vcpu
Thread-Index: AQHaHI1mX2GKishodE6D+ySiwkK6pbCF0Aig
Date: Wed, 22 Nov 2023 06:15:44 +0000
Message-ID: <0b000299dc964dad8bdc26271e4939a6@baidu.com>
References: <20231117122633.47028-1-lirongqing@baidu.com>
 <ZVzJTK4J+sm5prKG@yilunxu-OptiPlex-7050>
In-Reply-To: <ZVzJTK4J+sm5prKG@yilunxu-OptiPlex-7050>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2023-11-22 14:15:44:513
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 10.127.64.37
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM



> -----Original Message-----
> From: Xu Yilun <yilun.xu@linux.intel.com>
> Sent: Tuesday, November 21, 2023 11:14 PM
> To: Li,Rongqing <lirongqing@baidu.com>
> Cc: x86@kernel.org; kvm@vger.kernel.org
> Subject: Re: [PATCH] KVM: x86: fix kvm_has_noapic_vcpu updates when fail =
to
> create vcpu
>=20
> On Fri, Nov 17, 2023 at 08:26:33PM +0800, Li RongQing wrote:
> > Static key kvm_has_noapic_vcpu should be reduced when fail to create
> > vcpu, this patch fixes it
> >
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> >  arch/x86/kvm/x86.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> > 41cce50..2a22e66 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11957,7 +11957,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
> *vcpu)
> >  	kfree(vcpu->arch.mci_ctl2_banks);
> >  	free_page((unsigned long)vcpu->arch.pio_data);
> >  fail_free_lapic:
> > -	kvm_free_lapic(vcpu);
> > +	if (!lapic_in_kernel(vcpu))
> > +		static_branch_dec(&kvm_has_noapic_vcpu);
> > +	else
> > +		kvm_free_lapic(vcpu);
> >  fail_mmu_destroy:
> >  	kvm_mmu_destroy(vcpu);
> >  	return r;
>=20
> It is good to me. But is it better also take the chance to tidy up
> kvm_arch_vcpu_destroy():
>=20
> 	kvm_free_lapic(vcpu);
> 	idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> 	kvm_mmu_destroy(vcpu);
> 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> 	free_page((unsigned long)vcpu->arch.pio_data);
> 	kvfree(vcpu->arch.cpuid_entries);
> 	if (!lapic_in_kernel(vcpu))
> 		static_branch_dec(&kvm_has_noapic_vcpu);
>=20

Do you means that calling kvm_free_lapic when lapic_in_kernel is true?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c92407..9d176c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12122,14 +12122,17 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
        kvm_pmu_destroy(vcpu);
        kfree(vcpu->arch.mce_banks);
        kfree(vcpu->arch.mci_ctl2_banks);
-       kvm_free_lapic(vcpu);
+
+       if (lapic_in_kernel(vcpu))
+               kvm_free_lapic(vcpu);
+       else
+               static_branch_dec(&kvm_has_noapic_vcpu);
+
        idx =3D srcu_read_lock(&vcpu->kvm->srcu);
        kvm_mmu_destroy(vcpu);
        srcu_read_unlock(&vcpu->kvm->srcu, idx);
        free_page((unsigned long)vcpu->arch.pio_data);
        kvfree(vcpu->arch.cpuid_entries);
-       if (!lapic_in_kernel(vcpu))
-               static_branch_dec(&kvm_has_noapic_vcpu);
 }

 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)




