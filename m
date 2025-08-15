Return-Path: <kvm+bounces-54769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E920AB277C9
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 06:32:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4073565264
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 04:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 556F6239E97;
	Fri, 15 Aug 2025 04:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jb03uXgm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9683A8F7
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 04:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755232329; cv=none; b=kzhUzYb7I1jMs9Ytsh93k+tSEAW0Ler5FDOtQWasVC82XwYIJJoksvTz9fgdG2vuJvSTa7XIwLa85Aof/6qkd7HBp4zGEAdx9yxCIZh24ee8zbkFkk0uCXoOAugKM/V9MFjOw/HUZ0MtZK2eaHJlOzc3doAqifupZRUDOGnfxrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755232329; c=relaxed/simple;
	bh=ZrNGdDa3ue2pXZ7p4mCgz63fzMgbaYzPSvRgN66XhtM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pgrAdaY6j3TD1lQeDEVW6nuCMf3q15dPGi2OBvwdRocFE57Xham12kDqWbZb0CGPySrxeQVh5CeSdvaQEhD37gLcIrrlsUjI/rTkFeV30cWYNsSWlh/P/WIXFzRuxTOC3+5KaGPS4HODB4/6SJwH6x0QKLD3T7pNDgfDc22ZoDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jb03uXgm; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b0bf08551cso143341cf.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 21:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755232326; x=1755837126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vphq+KdVGQBHDleeYMXLhEN4hWNJK2UKgGf0Gk0kNNA=;
        b=jb03uXgm3WzytuhEHVyuOFqcC9m/Qsf9DWsPR+uomXYkAyZqQyw289KD0vpHV74hfE
         NT8tuo2dNy+kHmqyTWFAaAZn+GLVHa6u3tQe4T6CiGvVMJfKGXLdKSy5xoGg+cN1hA+A
         dl5sH3SSEGnW9LF3C3VZI59nRX7nkk3aHKpeUUgtTDTyLf4yhLN8wtswMom6zFBdpJHY
         nFcjPKgzsA/HiutyYgKHJD0oeZOriRh6CGftM+H7I8TfD4bYYRa+izwrA/IXCoSPOihV
         3L6Dw+PBzzGtyIw7HzEhQGp/rMMFKZQZLfIRPlke51zBaRRmO+AnjMCNnMcrvAyp9I/N
         R64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755232326; x=1755837126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vphq+KdVGQBHDleeYMXLhEN4hWNJK2UKgGf0Gk0kNNA=;
        b=DWx6XwJtU/ZN02DikukBCSXIP7q1oz4vcp5PpCXPfVKC+NMAWFsqlvte9Zn1G3Vehy
         t33QeCO36XMdAlVWOMEKV4TrunppuqJEH9mzat05x0m52UQjcJMS25aMssV0FJzWtVhw
         yv3GbhJLM9cP/kB2uZSdTON9mGxr8qcnrwiNvGMQXAa3qH+u6LNcqF8YbwiGA0itUjRJ
         ys06BnN4syIinQnIxhWv3eQtC27k+dku41reID1iurMAIg7JXForTLSCHC5kh32M1dSX
         9x6/qxnoHksZGJVtCMkaGPL6HHtLXO60JObR7yUfm7eJzzpZApq2XGEmRnIABAAgaVJ3
         jTCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTQSxSa/JflVNFXQOUSC7o/FSN4qRf7t1MsoebVpVzdp8V7yeFzyXwu6jXCrY3jCzNoSE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbDkN54NOyECDlR9KnV2gBGM+IGmaBrRkXxz77m/bD6d9hedH8
	Al3HUa8PKEmuuL8nDhb34HGYzZPRW25tgsS4dClMp28KlfxN+Qt6yRrjQbxU1SnMUJ/qrVH7pwp
	ntYoZz/SpPAebWqdL98fMa2NaozEeg8sA5S1Skxbx
X-Gm-Gg: ASbGncs19/xZBaLHEW2lQ5w3gjgsG2zXDNTdQ32+54X+3i/8+fMTWgYTHHXIKaSJBvC
	aQ3HNkANpf5tLOQ1cjxw+FNI64UDVXUirkWLLK3oqjgt0TEqTvNq9ThODgf53myVa/n1shonoi7
	XTbJkvKsMP0C9NEPzQXS/h0POeIqRFNM5Ug/cvmOoWSDaDj9VvP0AhoAMnvt3PuLn6EJXLCgKXR
	giSkPqh3/t7TNdCed/ZBqZ6kLPEh/rFy69SfoT3Xvw8SA==
X-Google-Smtp-Source: AGHT+IFnROl57LOIo9VPRxxOkeG5UUxFhM748VBrThhMVODn1XycukQQxmqkPtifgt9g/+IDrdCECfZfwFk25dWIj7k=
X-Received: by 2002:a05:622a:1194:b0:4b0:f1f3:db94 with SMTP id
 d75a77b69052e-4b11b73e747mr1445661cf.5.1755232325910; Thu, 14 Aug 2025
 21:32:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com> <20250807201628.1185915-6-sagis@google.com>
 <aJo3ww82Ln-PxgGL@google.com>
In-Reply-To: <aJo3ww82Ln-PxgGL@google.com>
From: Sagi Shahar <sagis@google.com>
Date: Thu, 14 Aug 2025 23:31:55 -0500
X-Gm-Features: Ac12FXxKl3jb58UGowv2eTWXkzgtsssQat3t2ZOfCXUQ1j88a7mXr-l44I61YfE
Message-ID: <CAAhR5DF5RTT8nF6mwLQPePL01k-bXBLapZZ3uNLH01j1W4UjSQ@mail.gmail.com>
Subject: Re: [PATCH v8 05/30] KVM: selftests: Update kvm_init_vm_address_properties()
 for TDX
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2025 at 1:34=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Aug 07, 2025, Sagi Shahar wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Let kvm_init_vm_address_properties() initialize vm->arch.{s_bit, tag_ma=
sk}
> > similar to SEV.
> >
> > Set shared bit position based on guest maximum physical address width
> > instead of maximum physical address width, because that is what KVM
> > uses,
>
> "because KVM does it" is not an acceptable explanation.
>
> > refer to setup_tdparams_eptp_controls(), and because maximum physical
> > address width can be different.
> >
> > In the case of SRF, guest maximum physical address width is 48 because =
SRF
> > does not support 5-level EPT, even though the maximum physical address
> > width is 52.
>
> Referencing a specific Intel microarchitecture is not proper justificatio=
n for
> why something is supported/legal/correct.  Using its three-letter acronym=
 is
> just icing on the cake.
>
> > Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > ---
> >  tools/testing/selftests/kvm/lib/x86/processor.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/te=
sting/selftests/kvm/lib/x86/processor.c
> > index d082d429e127..5718b5911b0a 100644
> > --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> > @@ -1166,10 +1166,19 @@ void kvm_get_cpu_address_width(unsigned int *pa=
_bits, unsigned int *va_bits)
> >
> >  void kvm_init_vm_address_properties(struct kvm_vm *vm)
> >  {
> > +     uint32_t gpa_bits =3D kvm_cpu_property(X86_PROPERTY_GUEST_MAX_PHY=
_ADDR);
> > +
> >       if (is_sev_vm(vm)) {
> >               vm->arch.sev_fd =3D open_sev_dev_path_or_exit();
> >               vm->arch.c_bit =3D BIT_ULL(this_cpu_property(X86_PROPERTY=
_SEV_C_BIT));
> >               vm->gpa_tag_mask =3D vm->arch.c_bit;
> > +     } else if (vm->type =3D=3D KVM_X86_TDX_VM) {
>
> Please add an is_tdx_vm() helper.
>
> > +             TEST_ASSERT(gpa_bits =3D=3D 48 || gpa_bits =3D=3D 52,
> > +                         "TDX: bad X86_PROPERTY_GUEST_MAX_PHY_ADDR val=
ue: %u", gpa_bits);
> > +             vm->arch.sev_fd =3D -1;
> > +             vm->arch.s_bit =3D 1ULL << (gpa_bits - 1);
> > +             vm->arch.c_bit =3D 0;
>
> The VM is zero-initialized, no need to set c_bit.
>
> > +             vm->gpa_tag_mask =3D vm->arch.s_bit;
> >       } else {
> >               vm->arch.sev_fd =3D -1;
>
> I think it makes sense to set sev_fd to -1 by default instead of duplicat=
ing the
> non-SEV logic into all non-SEV paths.  SEV VMs will write it twice, but t=
hat's a
> non-issue.  E.g.
>
>         vm->arch.sev_fd =3D -1;
>
>         if (is_sev_vm(vm)) {
>                 vm->arch.sev_fd =3D open_sev_dev_path_or_exit();
>                 vm->arch.c_bit =3D BIT_ULL(this_cpu_property(X86_PROPERTY=
_SEV_C_BIT));
>                 vm->gpa_tag_mask =3D vm->arch.c_bit;
>         } else if (is_tdx_vm(vm)) {
>                 TEST_ASSERT(gpa_bits =3D=3D 48 || gpa_bits =3D=3D 52,
>                             "TDX: bad X86_PROPERTY_GUEST_MAX_PHY_ADDR val=
ue: %u", gpa_bits);
>                 vm->arch.s_bit =3D 1ULL << (gpa_bits - 1);
>                 vm->gpa_tag_mask =3D vm->arch.s_bit;
>         }
>

Thanks for all the suggestions. I will incorporate them in the next version=
.

