Return-Path: <kvm+bounces-24625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC989586CB
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 14:19:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD7A6B2729E
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF81C18FC93;
	Tue, 20 Aug 2024 12:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SUZC2eH+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B079F18F2F9
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 12:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724156353; cv=none; b=paIpZ1AYlp7pijXviwovA40tPT05bv5wkMDQfMDvoS5/N39GGM6U8gg6+fGV50QsrXuZYhzBrHHbdLN0EnziiESHWkb4rXAipupfe2uFhsF1QX97TwIlmtErB0PI+I4PBX84AAAjHM/c4LJJpStAr0scrjPuqSo5aTFRxXCnblg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724156353; c=relaxed/simple;
	bh=Septe+OOLYMFpRUi4bu4Hpw2PRoU61r3zQSUBeaXVEA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ETUFLRAbARd4FvOn/Uk53A/3bQrkq8iJgSE6RX3UEdhlmD4hM8c3wj0wJXQnPFiHB6OKUaa9XAMkhSt5MsjrqdwGN33WdDDHA/KVN0ZNQatAPA3tjZ0eQcyggNWvxpn0lCoO9Rsy+R9RP1q0LIlKYaHEICA/E6+9TSo0KkzFHUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SUZC2eH+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724156349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bvXzkTtAKVrZEFV//MYOBb6hKuWqDYdht9x0ns/xxrQ=;
	b=SUZC2eH+w7MOxhomfp9g9UOUeONd6MpbDN4Rp4SNokXdQsyTGz+oRIQDDYEbtTpsKa9lfS
	2Mq/oi8jdkdUoMsTG/q4Bs2IY+MAk2X5/8yztRmlaWsXD9ta7/YwjPMs0v3mYCjWNyOtYh
	YuPwbkfykZAafsCAoO/E3otPttqKw1E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-eXcKbXAYOaukI1n3_a-IMw-1; Tue, 20 Aug 2024 08:19:08 -0400
X-MC-Unique: eXcKbXAYOaukI1n3_a-IMw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-371845055aaso3160611f8f.3
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 05:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724156346; x=1724761146;
        h=mime-version:user-agent:references:in-reply-to:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvXzkTtAKVrZEFV//MYOBb6hKuWqDYdht9x0ns/xxrQ=;
        b=QFH0PnWF4IxJ2UtfFXG2S72lhmmH4h0bsgLrp7VPofldwAh9Y1fqPzSLSNUE1cvT6p
         ODZk7bi01ADctf3OJgv7CmOq34C9t0SmJ3450odToSnP1WAm7VQZz0vN8ga2slxYDBZ3
         R93W7hZzmf8K++K7ZleEqJ+JZfS1jPg8cIeGpEaU7KiWAET2WeEas340KJDknXSY92am
         ieJUg/tO/VcXIteXX0jPkMo4sM5ZKbCDbEI2tQwJFRpySs50zEwzmmEyaV5RVrwR2duV
         m0jbfexiN9mQ4Y5WvF7S23QHNCPfTyL+a72fJUhwP7REtAAjMvm1zgYiWlXIRpHhaqY2
         j5uA==
X-Gm-Message-State: AOJu0Yyug4UH5RsPkYkkrN9i68dL84Pd+YHK+jptt3SGARdJLUxgXW8a
	7d4F9lpicrdoKxZ+vkJsYHqnHzT4ZmD3Ij0UDC/mVKYfScZ/pmX3QhVbu+LCZ+BZgb+xqI0TwXC
	TWyVnYeLljgC1S5n8jXeMRG1TPt/HQzCO/xHhwULr7XoQ8hwMJBOH1QYpqA==
X-Received: by 2002:a5d:670d:0:b0:367:9903:a81 with SMTP id ffacd0b85a97d-3719469fac2mr8042884f8f.43.1724156346418;
        Tue, 20 Aug 2024 05:19:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGA31JPkbb8POJ5dx59RG8GFkciMGPCsYCQzRMV/vhoX6fmi6//yVvDy8+0ghSMXTmNRVou1Q==
X-Received: by 2002:a5d:670d:0:b0:367:9903:a81 with SMTP id ffacd0b85a97d-3719469fac2mr8042860f8f.43.1724156345775;
        Tue, 20 Aug 2024 05:19:05 -0700 (PDT)
Received: from intellaptop.lan ([2a06:c701:77ab:3101:d6e6:2b8f:46b:7344])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded7bb5fsm199154565e9.40.2024.08.20.05.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 05:19:05 -0700 (PDT)
Message-ID: <6f111fb46c003cd88dd3e2e3a66d903b9df4d2b4.camel@redhat.com>
Subject: Re: [PATCH v3 3/4] KVM: nVMX: relax canonical checks on some x86
 registers in vmx host state
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 20 Aug 2024 15:19:03 +0300
In-Reply-To: <Zr_Ms-7IpzINzmc7@google.com>
References: <20240815123349.729017-1-mlevitsk@redhat.com>
	 <20240815123349.729017-4-mlevitsk@redhat.com>
	 <4d292a92016c65ae7521edec2cc0e9842c033e26.camel@redhat.com>
	 <Zr_Ms-7IpzINzmc7@google.com>
Content-Type: multipart/mixed; boundary="=-owDS2/HMysC5GQlSjSbA"
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

--=-owDS2/HMysC5GQlSjSbA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=D0=A3 =D0=BF=D1=82, 2024-08-16 =D1=83 15:03 -0700, Sean Christopherson =D0=
=BF=D0=B8=D1=88=D0=B5:
> On Fri, Aug 16, 2024, mlevitsk@redhat.com=C2=A0wrote:
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > > =C2=A0arch/x86/kvm/vmx/nested.c | 30 +++++++++++++++++++++++-------
> > > =C2=A01 file changed, 23 insertions(+), 7 deletions(-)
> > >=20
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 2392a7ef254d..3f18edff80ac 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -2969,6 +2969,22 @@ static int nested_vmx_check_address_space_size=
(struct kvm_vcpu *vcpu,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > > =C2=A0}
> > > =C2=A0
> > > +static bool is_l1_noncanonical_address_static(u64 la, struct kvm_vcp=
u *vcpu)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u8 max_guest_address_bits =
=3D guest_can_use(vcpu, X86_FEATURE_LA57) ? 57 : 48;
>=20
> I don't see any reason to use LA57 support from guest CPUID for the VMCS =
checks.
> The virtualization hole exists can't be safely plugged for all cases, so =
why
> bother trying to plug it only for some cases?

I also thought like that but then there is another argument:

My idea was that the guest really ought to not put non canonical values if =
its CPUID doesn't
support 5 level paging. There is absolutely no reason for doing so.

If the guest does this though via WRMSR, most of the time the MSR is not in=
tercepted, thus
it makes sense to allow this in emulation patch as well, as we discussed to=
 be consistent.

But when VMRESUME/VMLAUNCH instruction, which is *always* emulated, writes =
those MSRS on VM exit,
then I don't see a reason to allow a virtualization hole.

But then as it turns out (I didn't expect that) that instructions like LGDT=
 also don't check CR4.LA57,
and these are also passed through, then I guess singling out the VMX instru=
ctions is no longer better.

>=20
> It'd be very odd that an L1 could set a "bad" value via WRMSR, but then c=
ouldn't
> load that same value on VM-Exit, e.g. if L1 gets the VMCS value by doing =
RDMSR.
>=20
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Most x86 arch registers=
 which contain linear addresses like
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * segment bases, addresse=
s that are used in instructions (e.g SYSENTER),
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * have static canonicalit=
y checks,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * size of whose depends o=
nly on CPU's support for 5-level
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * paging, rather than sta=
te of CR4.LA57.
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * In other words the chec=
k only depends on the CPU model,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * rather than on runtime =
state.
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return !__is_canonical_add=
ress(la, max_guest_address_bits);
> > > +}
> > > +
> > > =C2=A0static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 struct vmcs12 *vmcs12)
> > > =C2=A0{
> > > @@ -2979,8 +2995,8 @@ static int nested_vmx_check_host_state(struct k=
vm_vcpu *vcpu,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC=
(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > > =C2=A0
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_noncanonical_add=
ress(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_n=
oncanonical_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_l1_noncanonical_=
address_static(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l=
1_noncanonical_address_static(vmcs12->host_ia32_sysenter_eip, vcpu)))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > > =C2=A0
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if ((vmcs12->vm_exit_=
controls & VM_EXIT_LOAD_IA32_PAT) &&
> > > @@ -3014,11 +3030,11 @@ static int nested_vmx_check_host_state(struct=
 kvm_vcpu *vcpu,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC=
(vmcs12->host_ss_selector =3D=3D 0 && !ia32e))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > > =C2=A0
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_noncanonical_add=
ress(vmcs12->host_fs_base, vcpu)) ||
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_n=
oncanonical_address(vmcs12->host_gs_base, vcpu)) ||
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_n=
oncanonical_address(vmcs12->host_gdtr_base, vcpu)) ||
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_n=
oncanonical_address(vmcs12->host_idtr_base, vcpu)) ||
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_n=
oncanonical_address(vmcs12->host_tr_base, vcpu)) ||
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_l1_noncanonical_=
address_static(vmcs12->host_fs_base, vcpu)) ||
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l=
1_noncanonical_address_static(vmcs12->host_gs_base, vcpu)) ||
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l=
1_noncanonical_address_static(vmcs12->host_gdtr_base, vcpu)) ||
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l=
1_noncanonical_address_static(vmcs12->host_idtr_base, vcpu)) ||
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l=
1_noncanonical_address_static(vmcs12->host_tr_base, vcpu)) ||
>=20
> If loads via LTR, LLDT, and LGDT are indeed exempt, then we need to updat=
e
> emul_is_noncanonical_address() too.

Sadly the answer to this is yes, at least on Intel. I will test on AMD soon=
, as soon as I grab
a Zen4 machine again.

And since these instructions are also all unintercepted, it also makes sens=
e to use host cpuid
for them as well.

I attached two kvm unit tests, which I will hopefully polish for publishing=
 soon, which pass
with flying colors with this patch series, and unless I made a mistake prov=
e most of my
research.

The HOST_RIP field I checked separately by patching the L0 kernel, and obse=
rving it
either hang/crash or fail VM entry of the first guest.

Best regards,
	Maxim Levitsky

>=20
> The best idea I have is to have a separate flow for system registers (not=
 a great
> name, but I can't think of anything better), and the
>=20
> E.g. s/is_host_noncanonical_msr_value/is_non_canonical_system_reg, and th=
en
> wire that up to the emulator.
>=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC=
(is_noncanonical_address(vmcs12->host_rip, vcpu)))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > > =C2=A0



>=20


--=-owDS2/HMysC5GQlSjSbA
Content-Disposition: attachment;
	filename*0=0001-Add-test-for-writing-canonical-values-to-various-msr.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-Add-test-for-writing-canonical-values-to-various-msr.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSBlNmQ3YmQyYWE0ZjE4NTg4MTcxNGE2MTAzZTllNjcyYjBkYmQxMmFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXhpbSBMZXZpdHNreSA8bWxldml0c2tAcmVkaGF0LmNvbT4K
RGF0ZTogRnJpLCAxNiBBdWcgMjAyNCAxMjo0MDoyMCArMDMwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBBZGQgdGVzdCBmb3Igd3JpdGluZyBjYW5vbmljYWwgdmFsdWVzIHRvIHZhcmlvdXMgbXNycwog
U2lnbmVkLW9mZi1ieTogTWF4aW0gTGV2aXRza3kgPG1sZXZpdHNrQHJlZGhhdC5jb20+CgotLS0K
IGxpYi94ODYvYXNtL3NldHVwLmggfCAgIDEgKwogbGliL3g4Ni9wcm9jZXNzb3IuaCB8ICAgNSAr
CiBsaWIveDg2L3ZtLmggICAgICAgIHwgICAxICsKIHg4Ni9NYWtlZmlsZS54ODZfNjQgfCAgIDEg
KwogeDg2L2NzdGFydDY0LlMgICAgICB8ICAzNSArKysrKysrCiB4ODYvbXNyX2Nhbm9uaWNhbC5j
IHwgMjM2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiA2IGZp
bGVzIGNoYW5nZWQsIDI3OSBpbnNlcnRpb25zKCspCiBjcmVhdGUgbW9kZSAxMDA2NDQgeDg2L21z
cl9jYW5vbmljYWwuYwoKZGlmZiAtLWdpdCBhL2xpYi94ODYvYXNtL3NldHVwLmggYi9saWIveDg2
L2FzbS9zZXR1cC5oCmluZGV4IDQ1OGVhYzg1OC4uMzk5Y2VkMWY5IDEwMDY0NAotLS0gYS9saWIv
eDg2L2FzbS9zZXR1cC5oCisrKyBiL2xpYi94ODYvYXNtL3NldHVwLmgKQEAgLTE0LDYgKzE0LDcg
QEAgdW5zaWduZWQgbG9uZyBzZXR1cF90c3ModTggKnN0YWNrdG9wKTsKIAogZWZpX3N0YXR1c190
IHNldHVwX2VmaShlZmlfYm9vdGluZm9fdCAqZWZpX2Jvb3RpbmZvKTsKIHZvaWQgc2V0dXBfNWxl
dmVsX3BhZ2VfdGFibGUodm9pZCk7Cit2b2lkIHNldHVwXzRsZXZlbF9wYWdlX3RhYmxlKHZvaWQp
OwogI2VuZGlmIC8qIENPTkZJR19FRkkgKi8KIAogdm9pZCBzYXZlX2lkKHZvaWQpOwpkaWZmIC0t
Z2l0IGEvbGliL3g4Ni9wcm9jZXNzb3IuaCBiL2xpYi94ODYvcHJvY2Vzc29yLmgKaW5kZXggZGEx
ZWQ2NjI4Li5kNDc4ZWZmOTEgMTAwNjQ0Ci0tLSBhL2xpYi94ODYvcHJvY2Vzc29yLmgKKysrIGIv
bGliL3g4Ni9wcm9jZXNzb3IuaApAQCAtNDY4LDYgKzQ2OCwxMSBAQCBzdGF0aWMgaW5saW5lIGlu
dCByZG1zcl9zYWZlKHUzMiBpbmRleCwgdWludDY0X3QgKnZhbCkKIAlyZXR1cm4gcmRyZWc2NF9z
YWZlKCJyZG1zciIsIGluZGV4LCB2YWwpOwogfQogCitzdGF0aWMgaW5saW5lIGludCByZG1zcl9m
ZXBfc2FmZSh1MzIgaW5kZXgsIHVpbnQ2NF90ICp2YWwpCit7CisJcmV0dXJuIF9fcmRyZWc2NF9z
YWZlKEtWTV9GRVAsICJyZG1zciIsIGluZGV4LCB2YWwpOworfQorCiBzdGF0aWMgaW5saW5lIGlu
dCB3cm1zcl9zYWZlKHUzMiBpbmRleCwgdTY0IHZhbCkKIHsKIAlyZXR1cm4gd3JyZWc2NF9zYWZl
KCJ3cm1zciIsIGluZGV4LCB2YWwpOwpkaWZmIC0tZ2l0IGEvbGliL3g4Ni92bS5oIGIvbGliL3g4
Ni92bS5oCmluZGV4IGNmMzk3ODdhYS4uNjBhY2UxYTg0IDEwMDY0NAotLS0gYS9saWIveDg2L3Zt
LmgKKysrIGIvbGliL3g4Ni92bS5oCkBAIC04LDYgKzgsNyBAQAogI2luY2x1ZGUgImFzbS9iaXRv
cHMuaCIKIAogdm9pZCBzZXR1cF81bGV2ZWxfcGFnZV90YWJsZSh2b2lkKTsKK3ZvaWQgc2V0dXBf
NGxldmVsX3BhZ2VfdGFibGUodm9pZCk7CiAKIHN0cnVjdCBwdGVfc2VhcmNoIHsKIAlpbnQgbGV2
ZWw7CmRpZmYgLS1naXQgYS94ODYvTWFrZWZpbGUueDg2XzY0IGIveDg2L01ha2VmaWxlLng4Nl82
NAppbmRleCAyNzcxYTZmYWQuLjFiYzFjMTBiMCAxMDA2NDQKLS0tIGEveDg2L01ha2VmaWxlLng4
Nl82NAorKysgYi94ODYvTWFrZWZpbGUueDg2XzY0CkBAIC0zOCw2ICszOCw3IEBAIHRlc3RzICs9
ICQoVEVTVF9ESVIpL3JkcHJ1LiQoZXhlKQogdGVzdHMgKz0gJChURVNUX0RJUikvcGtzLiQoZXhl
KQogdGVzdHMgKz0gJChURVNUX0RJUikvcG11X2xici4kKGV4ZSkKIHRlc3RzICs9ICQoVEVTVF9E
SVIpL3BtdV9wZWJzLiQoZXhlKQordGVzdHMgKz0gJChURVNUX0RJUikvbXNyX2Nhbm9uaWNhbC4k
KGV4ZSkKIAogaWZlcSAoJChDT05GSUdfRUZJKSx5KQogdGVzdHMgKz0gJChURVNUX0RJUikvYW1k
X3Nldi4kKGV4ZSkKZGlmZiAtLWdpdCBhL3g4Ni9jc3RhcnQ2NC5TIGIveDg2L2NzdGFydDY0LlMK
aW5kZXggNGRmZjExMDI3Li5hOTFkNTVkMDAgMTAwNjQ0Ci0tLSBhL3g4Ni9jc3RhcnQ2NC5TCisr
KyBiL3g4Ni9jc3RhcnQ2NC5TCkBAIC05Miw2ICs5MiwyNyBAQCBzd2l0Y2hfdG9fNWxldmVsOgog
CWNhbGwgZW50ZXJfbG9uZ19tb2RlCiAJam1wbCAkOCwgJGx2bDUKIAorCitzd2l0Y2hfdG9fNGxl
dmVsOgorCW1vdiAlY3IwLCAlZWF4CisJYnRyICQzMSwgJWVheAorCW1vdiAlZWF4LCAlY3IwCisK
Kwltb3YgJHB0bDQsICVlYXgKKwltb3YgJWVheCwgcHRfcm9vdAorCisJLyogRGlzYWJsZSBDUjQu
TEE1NyAqLworCW1vdiAlY3I0LCAlZWF4CisJYnRyICQxMiwgJWVheAorCW1vdiAlZWF4LCAlY3I0
CisKKwltb3YgJDB4MTAsICVheAorCW1vdiAlYXgsICVzcworCisJY2FsbCBlbnRlcl9sb25nX21v
ZGUKKwlqbXBsICQ4LCAkbHZsNQorCisKIHNtcF9zdGFja3RvcDoJLmxvbmcgc3RhY2t0b3AgLSA0
MDk2CiAKIC5hbGlnbiAxNgpAQCAtMTM5LDMgKzE2MCwxNyBAQCBzZXR1cF81bGV2ZWxfcGFnZV90
YWJsZToKIAlscmV0cQogbHZsNToKIAlyZXRxCisKKworLmdsb2JsIHNldHVwXzRsZXZlbF9wYWdl
X3RhYmxlCitzZXR1cF80bGV2ZWxfcGFnZV90YWJsZToKKwkvKiBDaGVjayBpZiA0LWxldmVsIHBh
Z2luZyBoYXMgYWxyZWFkeSBlbmFibGVkICovCisJbW92ICVjcjQsICVyYXgKKwl0ZXN0ICQweDEw
MDAsICVlYXgKKwlqeiBsdmw0CisKKwlwdXNocSAkMzIKKwlwdXNocSAkc3dpdGNoX3RvXzRsZXZl
bAorCWxyZXRxCitsdmw0OgorCXJldHEKZGlmZiAtLWdpdCBhL3g4Ni9tc3JfY2Fub25pY2FsLmMg
Yi94ODYvbXNyX2Nhbm9uaWNhbC5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAw
MC4uODllODA5ZDkwCi0tLSAvZGV2L251bGwKKysrIGIveDg2L21zcl9jYW5vbmljYWwuYwpAQCAt
MCwwICsxLDIzNiBAQAorI2luY2x1ZGUgImxpYmNmbGF0LmgiCisKKyNpbmNsdWRlICJhcGljLmgi
CisjaW5jbHVkZSAicHJvY2Vzc29yLmgiCisjaW5jbHVkZSAibXNyLmgiCisjaW5jbHVkZSAieDg2
L3ZtLmgiCisjaW5jbHVkZSAiYXNtL3NldHVwLmgiCisKK3N0YXRpYyB1bG9uZyBtc3JfbGlzdFtd
ID0geworCS8qTVNSX0dTX0JBU0UgLSB0ZXN0cyBuZWVkcyB0aGlzIG1zciBmb3IgX3NhZmUgbWFj
cm9zICovCisJTVNSX0lBMzJfU1lTRU5URVJfRVNQLAorCU1TUl9JQTMyX1NZU0VOVEVSX0VJUCwK
KwlNU1JfRlNfQkFTRSwKKwlNU1JfS0VSTkVMX0dTX0JBU0UsCisJTVNSX0xTVEFSLAorCU1TUl9D
U1RBUgorfTsKKworI2RlZmluZSBURVNUX1ZBTFVFMCAweGZmZmZmZmNlYjE2MDAwMDAKKyNkZWZp
bmUgVEVTVF9WQUxVRTEgMHhmZjQ1NDdjZWIxNjAwMDAwCisjZGVmaW5lIFRFU1RfVkFMVUUyIDB4
ZmE0NTQ3Y2ViMTYwMDAwMAorCisKK3N0YXRpYyB2b2lkIHRlc3RfbXNyczAodm9pZCkKK3sKKwlp
bnQgaTsKKworCWZvciAoaSA9IDAgOyBpIDwgQVJSQVlfU0laRShtc3JfbGlzdCkgOyBpKyspIHsK
KworCQl1NjQgdmFsdWUgPSByZG1zcihtc3JfbGlzdFtpXSk7CisJCXU2NCB2YWx1ZTE7CisJCWlu
dCB2ZWN0b3I7CisKKwkJLy8gd3JpdGUgdGVzdCB2YWx1ZSB2aWEga3ZtCisJCXZlY3RvciA9IHdy
bXNyX2ZlcF9zYWZlKG1zcl9saXN0W2ldLCBURVNUX1ZBTFVFMCk7CisKKwkJaWYgKHZlY3RvcikK
KwkJCXJlcG9ydF9mYWlsKCIlZCBGYWlsIHRvIHdyaXRlIG1zciB2aWEgZW11bGF0aW9uIiwgaSk7
CisJCWVsc2UgeworCQkJLy8gcmVhZCB0ZXN0IHZhbHVlIHZpYSBoYXJkd2FyZQorCQkJaWYgKHJk
bXNyKG1zcl9saXN0W2ldKSAhPSBURVNUX1ZBTFVFMCkKKwkJCQlyZXBvcnRfZmFpbCgiJWQ6IFdy
b25nIG1zciB2YWx1ZSBzZXQgdmlhIGVtdWxhdGlvbiIsIGkpOworCQl9CisKKwkJLy8gcmVzdG9y
ZSB0aGUgb3JpZ2luYWwgdmFsdWUKKwkJd3Jtc3IobXNyX2xpc3RbaV0sIHZhbHVlKTsKKworCQkv
LyBub3cgd3JpdGUgdGVzdCB2YWx1ZSB2aWEgaGFyZHdhcmUKKwkJd3Jtc3IobXNyX2xpc3RbaV0s
IFRFU1RfVkFMVUUwKTsKKworCQkvLyBub3cgcmVhZCB0ZXN0IHZhbHVlIHZpYSBrdm0KKwkJdmVj
dG9yID0gcmRtc3JfZmVwX3NhZmUobXNyX2xpc3RbaV0sICZ2YWx1ZTEpOworCisJCWlmICh2ZWN0
b3IpCisJCQlyZXBvcnRfZmFpbCgiJWQgRmFpbCB0byByZWFkIG1zciB2aWEgZW11bGF0aW9uXG4i
LCBpKTsKKwkJZWxzZSB7CisJCQlpZiggdmFsdWUxICE9IFRFU1RfVkFMVUUwKQorCQkJCXJlcG9y
dF9mYWlsKCIlZDogV3JvbmcgdmFsdWUgcmVhZCB2aWEgZW11bGF0aW9uIiwgaSk7CisJCX0KKwor
CisJCS8vIHJlc3RvcmUgdGhlIG9yaWdpbmFsIHZhbHVlCisJCXdybXNyKG1zcl9saXN0W2ldLCB2
YWx1ZSk7CisJfQorfQorCisKKworCisvKgorICogd3JpdGUgbm9uIGNhbm9uaWNhbCBmb3IgNCBs
ZXZlbCBidXQgY2Fub25pY2FsIGZvciA1IGxldmVsIHBhZ2luZworICogdmFsdWUgdG8gdGhlIHNl
dCBvZiB0ZXN0ZWQgbXNycworICovCitzdGF0aWMgdm9pZCB0ZXN0X21zcnMxKHU2NCB0ZXN0X3Zh
bHVlKQoreworCWludCBpLCB2ZWN0b3IxLCB2ZWN0b3IyOworCisJZm9yIChpID0gMCA7IGkgPCBB
UlJBWV9TSVpFKG1zcl9saXN0KSA7IGkrKykgeworCisJCXU2NCB2YWx1ZSA9IHJkbXNyKG1zcl9s
aXN0W2ldKTsKKworCQl2ZWN0b3IxID0gd3Jtc3Jfc2FmZShtc3JfbGlzdFtpXSwgdGVzdF92YWx1
ZSk7CisJCXdybXNyKG1zcl9saXN0W2ldLCB2YWx1ZSk7CisKKwkJdmVjdG9yMiA9IHdybXNyX2Zl
cF9zYWZlKG1zcl9saXN0W2ldLCB0ZXN0X3ZhbHVlKTsKKwkJd3Jtc3IobXNyX2xpc3RbaV0sIHZh
bHVlKTsKKworCQlwcmludGYoIiVkOiBodyBleGNlcHRpb246ICVkIGt2bSBleGNlcHRpb24gJWRc
biIsIGksIHZlY3RvcjEsIHZlY3RvcjIpOworCisJfQorfQorCisKKy8qCisgKiB3cml0ZSBub24g
Y2Fub25pY2FsIGZvciA0IGxldmVsIGJ1dCBjYW5vbmljYWwgZm9yIDUgbGV2ZWwgcGFnaW5nCisg
KiB2YWx1ZSB0byB0aGUgc2V0IG9mIHRlc3RlZCBtc3JzIHdoaWxlIHVzaW5nIDUgbGV2ZWwgcGFn
aW5nLAorICogYW5kIHRoZW4gc3dpdGNoIHRvIDQgbGV2ZWwgcGFnaW5nCisgKgorICoKKyAqLwor
c3RhdGljIHZvaWQgdGVzdF9tc3JzMih2b2lkKQoreworCWludCBpOworCisJc2V0dXBfNWxldmVs
X3BhZ2VfdGFibGUoKTsKKworCWZvciAoaSA9IDAgOyBpIDwgQVJSQVlfU0laRShtc3JfbGlzdCkg
OyBpKyspIHsKKwkJd3Jtc3IobXNyX2xpc3RbaV0sIFRFU1RfVkFMVUUxKTsKKwl9CisKKwlzZXR1
cF80bGV2ZWxfcGFnZV90YWJsZSgpOworCisJZm9yIChpID0gMCA7IGkgPCBBUlJBWV9TSVpFKG1z
cl9saXN0KSA7IGkrKykKKwkJaWYgKHJkbXNyKG1zcl9saXN0W2ldKSAhPSBURVNUX1ZBTFVFMSkK
KwkJCXJlcG9ydF9mYWlsKCJNU1IgJWkgZGlkbid0IHByZXNlcnZlIHZhbHVlIHdoZW4gc3dpdGNo
aW5nIGJhY2sgdG8gNCBsZXZlbCBwYWdpbmciLCBpKTsKKworfQorCisKK3N0YXRpYyB2b2lkIHRl
c3RfbGxkdF9ob3N0KHU2NCB2YWx1ZSkKK3sKKwl1MTYgb3JpZ25hbF9sZHQgPSBzbGR0KCk7CisK
KwlzZXRfZ2R0X2VudHJ5KEZJUlNUX1NQQVJFX1NFTCwgdmFsdWUsIDB4MTAwLCAweDgyLCAwKTsK
KwlsbGR0KEZJUlNUX1NQQVJFX1NFTCk7CisJbGxkdChvcmlnbmFsX2xkdCk7Cit9CisKK3N0YXRp
YyB2b2lkIHRlc3RfbHRyX2hvc3QodTY0IHZhbHVlKQoreworCXNpemVfdCB0c3Nfb2Zmc2V0Owor
CisJc2V0X2dkdF9lbnRyeShGSVJTVF9TUEFSRV9TRUwsIHZhbHVlLCAweDEwMCwgMHg4OSwgMCk7
CisJbHRyKEZJUlNUX1NQQVJFX1NFTCk7CisKKwkvKiByZXN0b3JlIFRTUyovCisJdHNzX29mZnNl
dCA9IHNldHVwX3RzcyhOVUxMKTsKKwlsb2FkX2dkdF90c3ModHNzX29mZnNldCk7Cit9CisKK3N0
YXRpYyB2b2lkIHRlc3RfbGdkdF9ob3N0KHU2NCB2YWx1ZSkKK3sKKwlzdHJ1Y3QgZGVzY3JpcHRv
cl90YWJsZV9wdHIgZHRfcHRyOworCXU2NCBvcmlnX2Jhc2U7CisKKwlzZ2R0KCZkdF9wdHIpOwor
CW9yaWdfYmFzZSA9IGR0X3B0ci5iYXNlOworCisJZHRfcHRyLmJhc2UgPSB2YWx1ZTsKKwlsZ2R0
KCZkdF9wdHIpOworCisJZHRfcHRyLmJhc2UgPSBvcmlnX2Jhc2U7CisJbGdkdCgmZHRfcHRyKTsK
K30KKworc3RhdGljIHZvaWQgdGVzdF9saWR0X2hvc3QodTY0IHZhbHVlKQoreworCXN0cnVjdCBk
ZXNjcmlwdG9yX3RhYmxlX3B0ciBkdF9wdHI7CisJdTY0IG9yaWdfYmFzZTsKKworCXNpZHQoJmR0
X3B0cik7CisJb3JpZ19iYXNlID0gZHRfcHRyLmJhc2U7CisKKwlkdF9wdHIuYmFzZSA9IHZhbHVl
OworCWxpZHQoJmR0X3B0cik7CisKKwlkdF9wdHIuYmFzZSA9IG9yaWdfYmFzZTsKKwlsaWR0KCZk
dF9wdHIpOworfQorCisKK3N0YXRpYyB2b2lkIHRlc3Rfc3BlY2lhbF9iYXNlcyh1NjQgdmFsdWUp
Cit7CisJdGVzdF9sZ2R0X2hvc3QodmFsdWUpOworCXRlc3RfbGlkdF9ob3N0KHZhbHVlKTsKKwor
CXRlc3RfbGxkdF9ob3N0KHZhbHVlKTsKKwl0ZXN0X2x0cl9ob3N0KHZhbHVlKTsKKworCXByaW50
ZigiU3BlY2lhbCBiYXNlcyB0ZXN0IGRvbmUgZm9yICVseFxuIiwgdmFsdWUpOworfQorCisKK2lu
dCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKK3sKKyNpZm5kZWYgQ09ORklHX0VGSQorCisJ
cHJpbnRmKCJCYXNpYyBtc3IgdGVzdFxuIik7CisJdGVzdF9tc3JzMCgpOworCisJcHJpbnRmKCJ0
ZXN0aW5nIG1zcnMgd2l0aCA0IGxldmVsIHBhZ2luZ1xuIik7CisJdGVzdF9tc3JzMShURVNUX1ZB
TFVFMCk7CisJcHJpbnRmKCJcbiIpOworCisJcHJpbnRmKCJ0ZXN0aW5nIG1zcnMgd2l0aCA0IGxl
dmVsIHBhZ2luZyAoNCBsZXZlbCBub24gY2Fub25pY2FsIHZhbHVlKVxuIik7CisJdGVzdF9tc3Jz
MShURVNUX1ZBTFVFMSk7CisJcHJpbnRmKCJcbiIpOworCisJcHJpbnRmKCJ0ZXN0aW5nIG1zcnMg
d2l0aCA0IGxldmVsIHBhZ2luZyAoZnVsbHkgbm9uIGNhbm9uaWNhbCB2YWx1ZSlcbiIpOworCXRl
c3RfbXNyczEoVEVTVF9WQUxVRTIpOworCXByaW50ZigiXG4iKTsKKworCisJc2V0dXBfNWxldmVs
X3BhZ2VfdGFibGUoKTsKKworCXByaW50ZigidGVzdGluZyBtc3JzIHdpdGggNSBsZXZlbCBwYWdp
bmdcbiIpOworCXRlc3RfbXNyczEoVEVTVF9WQUxVRTApOworCXByaW50ZigiXG4iKTsKKworCisJ
cHJpbnRmKCJ0ZXN0aW5nIG1zcnMgd2l0aCA1IGxldmVsIHBhZ2luZyAoNCBsZXZlbCBub24gY2Fu
b25pY2FsIHZhbHVlKVxuIik7CisJdGVzdF9tc3JzMShURVNUX1ZBTFVFMSk7CisJcHJpbnRmKCJc
biIpOworCisJcHJpbnRmKCJ0ZXN0aW5nIG1zcnMgd2l0aCA1IGxldmVsIHBhZ2luZyAoZnVsbHkg
bm9uIGNhbm9uaWNhbCB2YWx1ZSlcbiIpOworCXRlc3RfbXNyczEoVEVTVF9WQUxVRTIpOworCXBy
aW50ZigiXG4iKTsKKworCisJcHJpbnRmKCJ0ZXN0aW5nIHRoYXQgbXNycyByZW1haW4gd2l0aCBu
b24gY2Fub25pY2FsIHZhbHVlcyBhZnRlciBzd2l0Y2ggdG8gNCBsZXZlbCBwYWdpbmdcbiIpOwor
CXRlc3RfbXNyczIoKTsKKworCXNldHVwXzVsZXZlbF9wYWdlX3RhYmxlKCk7CisKKwl0ZXN0X3Nw
ZWNpYWxfYmFzZXMoVEVTVF9WQUxVRTApOworCXRlc3Rfc3BlY2lhbF9iYXNlcyhURVNUX1ZBTFVF
MSk7CisKKwlzZXR1cF80bGV2ZWxfcGFnZV90YWJsZSgpOworCisJdGVzdF9zcGVjaWFsX2Jhc2Vz
KFRFU1RfVkFMVUUwKTsKKwl0ZXN0X3NwZWNpYWxfYmFzZXMoVEVTVF9WQUxVRTEpOworCisjZW5k
aWYKKwlyZXR1cm4gcmVwb3J0X3N1bW1hcnkoKTsKK30KKwotLSAKMi40MC4xCgo=


--=-owDS2/HMysC5GQlSjSbA
Content-Disposition: attachment;
	filename*0=0002-vmx-add-test-for-canonical-checks-on-various-fields.patc;
	filename*1=h
Content-Type: text/x-patch;
	name="0002-vmx-add-test-for-canonical-checks-on-various-fields.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSBlMTQyODhmNTA4OTZjYWFhZmJkZDhlNjZkNThmZTc1N2YyMzdiMTNjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXhpbSBMZXZpdHNreSA8bWxldml0c2tAcmVkaGF0LmNvbT4K
RGF0ZTogTW9uLCAyMiBKdWwgMjAyNCAxMTowOTo0MCAtMDQwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSB2bXg6IGFkZCB0ZXN0IGZvciBjYW5vbmljYWwgY2hlY2tzIG9uIHZhcmlvdXMgZmllbGRzCgpT
aWduZWQtb2ZmLWJ5OiBNYXhpbSBMZXZpdHNreSA8bWxldml0c2tAcmVkaGF0LmNvbT4KLS0tCiB4
ODYvdm14X3Rlc3RzLmMgfCAxNTEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTUxIGluc2VydGlvbnMoKykKCmRpZmYgLS1n
aXQgYS94ODYvdm14X3Rlc3RzLmMgYi94ODYvdm14X3Rlc3RzLmMKaW5kZXggZmZlNzA2NGM5Li44
Zjk3ODQzNjAgMTAwNjQ0Ci0tLSBhL3g4Ni92bXhfdGVzdHMuYworKysgYi94ODYvdm14X3Rlc3Rz
LmMKQEAgLTEwNzMyLDYgKzEwNzMyLDcgQEAgc3RhdGljIHZvaWQgaGFuZGxlX2V4Y2VwdGlvbl9p
bl9sMSh1MzIgdmVjdG9yKQogCXZtY3Nfd3JpdGUoRVhDX0JJVE1BUCwgb2xkX2ViKTsKIH0KIAor
CiBzdGF0aWMgdm9pZCB2bXhfZXhjZXB0aW9uX3Rlc3Qodm9pZCkKIHsKIAlzdHJ1Y3Qgdm14X2V4
Y2VwdGlvbl90ZXN0ICp0OwpAQCAtMTA3NTQsNiArMTA3NTUsMTU1IEBAIHN0YXRpYyB2b2lkIHZt
eF9leGNlcHRpb25fdGVzdCh2b2lkKQogCXRlc3Rfc2V0X2d1ZXN0X2ZpbmlzaGVkKCk7CiB9CiAK
KworI2RlZmluZSBURVNUX1ZBTFVFX0NBTk9OSUNBTCAgMHhmZmZmZmZjZWIxNjAwMDAwCisjZGVm
aW5lIFRFU1RfVkFMVUVfNUNBTk9OSUNBTCAweGZmNDU0N2NlYjE2MDAwMDAKKworc3RhdGljIHZv
aWQgdm14X2Nhbm9uaWNhbF90ZXN0X2d1ZXN0KHZvaWQpCit7CisJd2hpbGUgKHRydWUpIHsKKwkJ
dm1jYWxsKCk7CisJfQorfQorCitzdGF0aWMgaW50IGdldF9ob3N0X3ZhbHVlKHU2NCB2bWNzX2Zp
ZWxkLCB1NjQgKnZhbHVlKQoreworCXN0cnVjdCBkZXNjcmlwdG9yX3RhYmxlX3B0ciBkdF9wdHI7
CisKKwlzd2l0Y2godm1jc19maWVsZCkgeworCWNhc2UgSE9TVF9TWVNFTlRFUl9FU1A6CisJCSp2
YWx1ZSA9IHJkbXNyKE1TUl9JQTMyX1NZU0VOVEVSX0VTUCk7CisJCWJyZWFrOworCWNhc2UgSE9T
VF9TWVNFTlRFUl9FSVA6CisJCSp2YWx1ZSA9ICByZG1zcihNU1JfSUEzMl9TWVNFTlRFUl9FSVAp
OworCQlicmVhazsKKwljYXNlIEhPU1RfQkFTRV9GUzoKKwkJKnZhbHVlID0gIHJkbXNyKE1TUl9G
U19CQVNFKTsKKwkJYnJlYWs7CisJY2FzZSBIT1NUX0JBU0VfR1M6CisJCSp2YWx1ZSA9ICByZG1z
cihNU1JfR1NfQkFTRSk7CisJCWJyZWFrOworCWNhc2UgSE9TVF9CQVNFX0dEVFI6CisJCXNnZHQo
JmR0X3B0cik7CisJCSp2YWx1ZSA9ICBkdF9wdHIuYmFzZTsKKwkJYnJlYWs7CisJY2FzZSBIT1NU
X0JBU0VfSURUUjoKKwkJc2lkdCgmZHRfcHRyKTsKKwkJKnZhbHVlID0gIGR0X3B0ci5iYXNlOwor
CQlicmVhazsKKwljYXNlIEhPU1RfQkFTRV9UUjoKKwkJKnZhbHVlID0gZ2V0X2dkdF9lbnRyeV9i
YXNlKGdldF90c3NfZGVzY3IoKSk7CisJCS8qIHZhbHVlIG1pZ2h0IG5vdCByZWZsZWN0IHRoZSBh
Y3R1YWwgYmFzZSBpZiBjaGFuZ2VkIGJ5IFZNWCAqLworCQlyZXR1cm4gMTsKKwlkZWZhdWx0Ogor
CQlhc3NlcnQoMCk7CisJfQorCXJldHVybiAwOworfQorCitzdGF0aWMgdm9pZCBzZXRfaG9zdF92
YWx1ZSh1NjQgdm1jc19maWVsZCwgdTY0IHZhbHVlKQoreworCXN0cnVjdCBkZXNjcmlwdG9yX3Rh
YmxlX3B0ciBkdF9wdHI7CisKKwlzd2l0Y2godm1jc19maWVsZCkgeworCWNhc2UgSE9TVF9TWVNF
TlRFUl9FU1A6CisJCXdybXNyKE1TUl9JQTMyX1NZU0VOVEVSX0VTUCwgdmFsdWUpOworCQlicmVh
azsKKwljYXNlIEhPU1RfU1lTRU5URVJfRUlQOgorCQl3cm1zcihNU1JfSUEzMl9TWVNFTlRFUl9F
SVAsIHZhbHVlKTsKKwkJYnJlYWs7CisJY2FzZSBIT1NUX0JBU0VfRlM6CisJCXdybXNyKE1TUl9G
U19CQVNFLCB2YWx1ZSk7CisJCWJyZWFrOworCWNhc2UgSE9TVF9CQVNFX0dTOgorCQl3cm1zcihN
U1JfR1NfQkFTRSwgdmFsdWUpOworCQlicmVhazsKKwljYXNlIEhPU1RfQkFTRV9HRFRSOgorCQlz
Z2R0KCZkdF9wdHIpOworCQlkdF9wdHIuYmFzZSA9IHZhbHVlOworCQlsZ2R0KCZkdF9wdHIpOwor
CQlicmVhazsKKwljYXNlIEhPU1RfQkFTRV9JRFRSOgorCQlzaWR0KCZkdF9wdHIpOworCQlkdF9w
dHIuYmFzZSA9IHZhbHVlOworCQlsaWR0KCZkdF9wdHIpOworCQlicmVhazsKKwljYXNlIEhPU1Rf
QkFTRV9UUjoKKwkJLyogc2V0IHRoZSBiYXNlIGFuZCBjbGVhciB0aGUgYnVzeSBiaXQgKi8KKwkJ
c2V0X2dkdF9lbnRyeShGSVJTVF9TUEFSRV9TRUwsIHZhbHVlLCAweDIwMCwgMHg4OSwgMCk7CisJ
CWx0cihGSVJTVF9TUEFSRV9TRUwpOworCQlicmVhazsKKwl9Cit9CisKK3N0YXRpYyB2b2lkIGRv
X3ZteF9jYW5vbmljYWxfdGVzdF9vbmVfZmllbGQoY29uc3QgY2hhciogbmFtZSwgdTY0IGZpZWxk
KQoreworCS8qIGJhY2t1cCB0aGUgbXNyIGFuZCBmaWVsZCB2YWx1ZXMgKi8KKwl1NjQgaG9zdF9v
cmdfdmFsdWUsIHRlc3RfdmFsdWU7CisJdTY0IGZpZWxkX29yZ192YWx1ZSA9IHZtY3NfcmVhZChm
aWVsZCk7CisKKwlnZXRfaG9zdF92YWx1ZShmaWVsZCwgJmhvc3Rfb3JnX3ZhbHVlKTsKKworCS8q
IHdyaXRlIDU3LWNhbm9uaWNhbCB2YWx1ZSBvbiB0aGUgaG9zdCBhbmQgY2hlY2sgdGhhdCBpdCB3
YXMgd3JpdHRlbiAqLworCXNldF9ob3N0X3ZhbHVlKGZpZWxkLCBURVNUX1ZBTFVFXzVDQU5PTklD
QUwpOworCWlmICghZ2V0X2hvc3RfdmFsdWUoZmllbGQsICZ0ZXN0X3ZhbHVlKSkgeworCQlyZXBv
cnQodGVzdF92YWx1ZSA9PSBURVNUX1ZBTFVFXzVDQU5PTklDQUwsICIlczogSE9TVCB2YWx1ZSBp
cyBzZXQgdG8gdGVzdCB2YWx1ZSBkaXJlY3RseSIsIG5hbWUpOworCX0KKworCS8qIHdyaXRlIDU3
LWNhbm9uaWNhbCB2YWx1ZSB2aWEgVk1MQU5VQ0gvVk1SRVNVTUUgaW5zdHJ1Y3Rpb24qLworCXNl
dF9ob3N0X3ZhbHVlKGZpZWxkLCBURVNUX1ZBTFVFX0NBTk9OSUNBTCk7CisJdm1jc193cml0ZShm
aWVsZCwgVEVTVF9WQUxVRV81Q0FOT05JQ0FMKTsKKworCWVudGVyX2d1ZXN0KCk7CisJc2tpcF9l
eGl0X3ZtY2FsbCgpOworCisJaWYgKCFnZXRfaG9zdF92YWx1ZShmaWVsZCwgJnRlc3RfdmFsdWUp
KSB7CisJCS8qIGNoZWNrIHRoYXQgbm93IG1zciB2YWx1ZSBpcyB0aGUgc2FtZSBhcyB0aGUgZmll
bGQgdmFsdWUqLworCQlyZXBvcnQodGVzdF92YWx1ZSA9PSBURVNUX1ZBTFVFXzVDQU5PTklDQUws
ICIlczogSE9TVCB2YWx1ZSBpcyBzZXQgdG8gdGVzdCB2YWx1ZSB2aWEgVk1MQVVOQ0gvVk1SRVNV
TUUiLCBuYW1lKTsKKwl9CisKKwkvKiBSZXN0b3JlIG9yaWdpbmFsIHZhbHVlcyAqLworCXZtY3Nf
d3JpdGUoZmllbGQsIGZpZWxkX29yZ192YWx1ZSk7CisJc2V0X2hvc3RfdmFsdWUoZmllbGQsIGhv
c3Rfb3JnX3ZhbHVlKTsKK30KKworI2RlZmluZSB2bXhfY2Fub25pY2FsX3Rlc3Rfb25lX2ZpZWxk
KGZpZWxkKSBcCisJZG9fdm14X2Nhbm9uaWNhbF90ZXN0X29uZV9maWVsZCgjZmllbGQsIGZpZWxk
KTsKKworCisKK3N0YXRpYyB2b2lkIHRlc3RfbGxkdF9ob3N0KHU2NCB2YWx1ZSkKK3sKKwl1MTYg
b3JpZ25hbF9sZHQgPSBzbGR0KCk7CisKKwlzZXRfZ2R0X2VudHJ5KEZJUlNUX1NQQVJFX1NFTCwg
dmFsdWUsIDB4MTAwLCAweDgyLCAwKTsKKwlsbGR0KEZJUlNUX1NQQVJFX1NFTCk7CisJbGxkdChv
cmlnbmFsX2xkdCk7Cit9CisKK3N0YXRpYyB2b2lkIHZteF9jYW5vbmljYWxfdGVzdCh2b2lkKQor
eworCXJlcG9ydCghKHJlYWRfY3I0KCkgJiBYODZfQ1I0X0xBNTcpLCAiNCBsZXZlbCBwYWdpbmci
KTsKKworCXRlc3Rfc2V0X2d1ZXN0KHZteF9jYW5vbmljYWxfdGVzdF9ndWVzdCk7CisKKwl0ZXN0
X2xsZHRfaG9zdChURVNUX1ZBTFVFXzVDQU5PTklDQUwpOworCisJdm14X2Nhbm9uaWNhbF90ZXN0
X29uZV9maWVsZChIT1NUX1NZU0VOVEVSX0VTUCk7CisJdm14X2Nhbm9uaWNhbF90ZXN0X29uZV9m
aWVsZChIT1NUX1NZU0VOVEVSX0VJUCk7CisKKwl2bXhfY2Fub25pY2FsX3Rlc3Rfb25lX2ZpZWxk
KEhPU1RfQkFTRV9GUyk7CisJdm14X2Nhbm9uaWNhbF90ZXN0X29uZV9maWVsZChIT1NUX0JBU0Vf
R1MpOworCisJdm14X2Nhbm9uaWNhbF90ZXN0X29uZV9maWVsZChIT1NUX0JBU0VfR0RUUik7CisJ
dm14X2Nhbm9uaWNhbF90ZXN0X29uZV9maWVsZChIT1NUX0JBU0VfSURUUik7CisKKwl2bXhfY2Fu
b25pY2FsX3Rlc3Rfb25lX2ZpZWxkKEhPU1RfQkFTRV9UUik7CisKKworCXRlc3Rfc2V0X2d1ZXN0
X2ZpbmlzaGVkKCk7Cit9CisKIGVudW0gVmlkX29wIHsKIAlWSURfT1BfU0VUX0lTUiwKIAlWSURf
T1BfTk9QLApAQCAtMTEyNjIsNSArMTE0MTIsNiBAQCBzdHJ1Y3Qgdm14X3Rlc3Qgdm14X3Rlc3Rz
W10gPSB7CiAJVEVTVCh2bXhfcGZfaW52dnBpZF90ZXN0KSwKIAlURVNUKHZteF9wZl92cGlkX3Rl
c3QpLAogCVRFU1Qodm14X2V4Y2VwdGlvbl90ZXN0KSwKKwlURVNUKHZteF9jYW5vbmljYWxfdGVz
dCksCiAJeyBOVUxMLCBOVUxMLCBOVUxMLCBOVUxMLCBOVUxMLCB7MH0gfSwKIH07Ci0tIAoyLjQw
LjEKCg==


--=-owDS2/HMysC5GQlSjSbA--


