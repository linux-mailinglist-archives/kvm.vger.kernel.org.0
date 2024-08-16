Return-Path: <kvm+bounces-24378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B00379546D5
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 12:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 998B21C220B4
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 10:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5729A1917FC;
	Fri, 16 Aug 2024 10:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IbRZp2C7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D601DFFC
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 10:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723804855; cv=none; b=QntTKmaXTUZrtsQqdasDgnpxKMwEMf6nREsFr/FTahifIV0WiWQZSQ9Q9RdsRXTYOwZLsfXGPDETSQ0FcGP7z194exFxaRysUrSqhIlj7BJyRj/0jhjdb+pW4IUEoI1AuG7LyWuBwL5c3bUGsMBJub8jeDH8ankWyi5pPgEYYMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723804855; c=relaxed/simple;
	bh=AOXCO+gO5CgShIZ7CshbaSet0p0IhOG0WbsSMcT71tU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HgJxbPp/YgkXvJkFJw91iv4WdptmC7fUmjC1VWQpVAFpF9/F51yHT2nxWFuT02drTclKR1zz6HVlcMYCpn/+js92WrSz8JtVl3ME1XzvmNY+7rcmY5Nn6vU0THbrMk/OzWC5FmVa9p7mGS3YE5m7NlZfUTKdnr/14TMpLNfMVMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IbRZp2C7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723804852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JgR5EMLHmaVR7qbyXU0gJ7Rk3GvEx4rWFbGheyQQCM=;
	b=IbRZp2C7hCjO2SR44Cmx2LNryLOgp8cSbBauI5g8Y3z/l4CU6dEAhcRF/YrCmLiOfK/kwS
	Pj/aRZH8DWsRPICvi8u3O0D2p3R9aygTuaVvEcolWbbr3/sJhxYqpPcdv0smqwVPwddQQ2
	mxstnTKkjvMNbGXjXDy22aAX/GBaKsQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-KC8Z9YYaPJCh4HX-vq6xXg-1; Fri, 16 Aug 2024 06:40:51 -0400
X-MC-Unique: KC8Z9YYaPJCh4HX-vq6xXg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-369bbbdb5a1so990959f8f.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 03:40:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723804850; x=1724409650;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7JgR5EMLHmaVR7qbyXU0gJ7Rk3GvEx4rWFbGheyQQCM=;
        b=o5hIH9zKjGbrilLp2Gja4WN1zksItK4MjDJUFs0GpUa14kbktejOMnetKCO5TchVz/
         cpKG67nGxffHGMoMS76hLxxrLzvmdbHuLiOVAxcmCJLJlkrQjQbeD0p2RFeUP3RXEn+p
         JmjtJ6qwHLevAUqbEKujVhQ3FBDjAra6yBcgfH4Buc7ym5aqvaD3ZRHkU1Y1kJ9yvbxI
         7qUDEgx7vsRIERMGYHw1MjbP9KDJ1a0KZ6FeUB29PeUD7dXJ0QIf9Z22QYyqh7HnsWWB
         W+vzBI1waH6Nonn1gJJT0yNkCppJjzBBYqxyn9zvriTKt4QWTZA91e6AmyJsAe8Ed9WX
         OrUg==
X-Gm-Message-State: AOJu0YxJAvb+NSJ64XGYbOcfjKykLpIbMI8KAIqE78gVqyk7p4sMWKpO
	n5zLutXF/8wPX4zFc5qDR1JYWtdYIpGyVCcxpCp/0sW75gcnS/OzY64gLe04830QSEf9G+YWSBE
	+aW7B3PsbAgq6087izB3npMLmlMe9zfaWpERA62NqaLB/JN7m0mJWUALm61wopM8Iv6lejYjWEL
	3ltpk2qJVxT1JXsXAC+qpM01ztCpFhVLDBAQ==
X-Received: by 2002:a5d:46cb:0:b0:367:9049:da2e with SMTP id ffacd0b85a97d-37194badde1mr1627111f8f.8.1723804850183;
        Fri, 16 Aug 2024 03:40:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWeIVwxkTqApNBVM8LC1LWsvulwA5ev/6tZFq7bIW+DUr9acYZd2PDpfOddEbdm4s5NLYj5w==
X-Received: by 2002:a5d:46cb:0:b0:367:9049:da2e with SMTP id ffacd0b85a97d-37194badde1mr1627080f8f.8.1723804849621;
        Fri, 16 Aug 2024 03:40:49 -0700 (PDT)
Received: from intellaptop.lan ([2a06:c701:77ab:3101:d6e6:2b8f:46b:7344])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-371898ac79esm3363061f8f.110.2024.08.16.03.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 03:40:49 -0700 (PDT)
Message-ID: <4d292a92016c65ae7521edec2cc0e9842c033e26.camel@redhat.com>
Subject: Re: [PATCH v3 3/4] KVM: nVMX: relax canonical checks on some x86
 registers in vmx host state
From: mlevitsk@redhat.com
To: kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Thomas
 Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, "H. Peter
 Anvin" <hpa@zytor.com>
Date: Fri, 16 Aug 2024 13:40:47 +0300
In-Reply-To: <20240815123349.729017-4-mlevitsk@redhat.com>
References: <20240815123349.729017-1-mlevitsk@redhat.com>
	 <20240815123349.729017-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

=D0=A3 =D1=87=D1=82, 2024-08-15 =D1=83 15:33 +0300, Maxim Levitsky =D0=BF=
=D0=B8=D1=88=D0=B5:
> Several x86's architecture registers contain a linear base, and thus must
> contain a canonical address.
>=20
> This includes segment and segment like bases (FS/GS base, GDT,IDT,LDT,TR)=
,
> addresses used for SYSENTER and SYSCALL instructions and probably more.
>=20
> As it turns out, when x86 architecture was updated to 5 level paging /
> 57 bit virtual addresses, these fields were allowed to contain a full
> 57 bit address regardless of the state of CR4.LA57.
>=20
> The main reason behind this decision is that 5 level paging, and even
> paging itself can be temporarily disabled (e.g by SMM entry) leaving non
> canonical values in these fields.
> Another reason is that OS might prepare these fields before it switches t=
o
> 5 level paging.

Hi,

Note that I haven't included a fix for HOST_RIP. I did today a bare metal c=
heck
and indeed the microcode does check CR4.LA57, the one that is stored in the=
 vmcs
as you suspected.

I add a patch to this patch series with this mostly theoretical fix, when I=
 send a new revision.

Second thing, I kept the canonical check on 'vmcs12->guest_bndcfgs because =
Intel
deprecated this feature and none of CPUs which support 5 level paging suppo=
rt MPX.

Also I think that since this is a guest state field, it might be possible t=
o just
remove the check, because the value of this field is copied to vmcs02 and t=
he
CPU's microcode should do the same check that KVM does.

Best regards,
	Maxim Levitsky


>=20
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
> =C2=A0arch/x86/kvm/vmx/nested.c | 30 +++++++++++++++++++++++-------
> =C2=A01 file changed, 23 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2392a7ef254d..3f18edff80ac 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2969,6 +2969,22 @@ static int nested_vmx_check_address_space_size(str=
uct kvm_vcpu *vcpu,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> =C2=A0}
> =C2=A0
> +static bool is_l1_noncanonical_address_static(u64 la, struct kvm_vcpu *v=
cpu)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u8 max_guest_address_bits =3D =
guest_can_use(vcpu, X86_FEATURE_LA57) ? 57 : 48;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Most x86 arch registers whi=
ch contain linear addresses like
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * segment bases, addresses th=
at are used in instructions (e.g SYSENTER),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * have static canonicality ch=
ecks,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * size of whose depends only =
on CPU's support for 5-level
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * paging, rather than state o=
f CR4.LA57.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * In other words the check on=
ly depends on the CPU model,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * rather than on runtime stat=
e.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return !__is_canonical_address=
(la, max_guest_address_bits);
> +}
> +
> =C2=A0static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 struct vmcs12 *vmcs12)
> =C2=A0{
> @@ -2979,8 +2995,8 @@ static int nested_vmx_check_host_state(struct kvm_v=
cpu *vcpu,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(!kv=
m_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_noncanonical_address=
(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_nonca=
nonical_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_l1_noncanonical_addr=
ess_static(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l1_no=
ncanonical_address_static(vmcs12->host_ia32_sysenter_eip, vcpu)))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if ((vmcs12->vm_exit_cont=
rols & VM_EXIT_LOAD_IA32_PAT) &&
> @@ -3014,11 +3030,11 @@ static int nested_vmx_check_host_state(struct kvm=
_vcpu *vcpu,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(vmc=
s12->host_ss_selector =3D=3D 0 && !ia32e))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_noncanonical_address=
(vmcs12->host_fs_base, vcpu)) ||
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_nonca=
nonical_address(vmcs12->host_gs_base, vcpu)) ||
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_nonca=
nonical_address(vmcs12->host_gdtr_base, vcpu)) ||
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_nonca=
nonical_address(vmcs12->host_idtr_base, vcpu)) ||
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_nonca=
nonical_address(vmcs12->host_tr_base, vcpu)) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (CC(is_l1_noncanonical_addr=
ess_static(vmcs12->host_fs_base, vcpu)) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l1_no=
ncanonical_address_static(vmcs12->host_gs_base, vcpu)) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l1_no=
ncanonical_address_static(vmcs12->host_gdtr_base, vcpu)) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l1_no=
ncanonical_address_static(vmcs12->host_idtr_base, vcpu)) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_l1_no=
ncanonical_address_static(vmcs12->host_tr_base, vcpu)) ||
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CC(is_=
noncanonical_address(vmcs12->host_rip, vcpu)))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0


