Return-Path: <kvm+bounces-58788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B9DBA0C82
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:14:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E39B1784EB
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539C630DD37;
	Thu, 25 Sep 2025 17:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pVdk2EOs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC24230B52D
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758820444; cv=none; b=GP2qbj+2HhIVQ2RrkXCC+w/asKAFLNyc32eWBJGa8kJZw2ZbEZS95mcAS9Y2qtU+TYiDKA13IXPRElmRCn4VeEeKUXKUsklfywGN+GHoi/EuU+KWaguqhbouxve1tX8HSDN1Wcw9kS2iz2KQNesf9KOeRB7BMKMuP72IU+DxfOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758820444; c=relaxed/simple;
	bh=L6Uhp8MOqMvS7AUayVSY9dBOunuTM/F4S/BhsIl0FTQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G3Traf/j2GMwHgtshKELYxWezFOLLwLkZTiBtdoUtJTrUhhMzuuSlU3V86QW0hjX390Kw/yoZTr0q4gkqc2KJKTJHFoLo2LxfRadmWE6yUovCo1bjcRb2DUZYuYNata/oY5QjWUcXqVNXbD34DmEhvUKTk1fRfd4IleC0sHJ6Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pVdk2EOs; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b78657a35aso27101cf.0
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758820442; x=1759425242; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x7ycXV9ALf3t9U0+dL4DRxPImOWr4pLGbcQVQ9bNkH8=;
        b=pVdk2EOs/s+006w0EbX+nCiOXYrJLwNchHmxrPn+4czm/NwGJc4S+pIGRTiIuLLBd+
         vzgHxBOj2buuNsgZKMumO2thmoYVTjkoCR059rFSlq2mhXkIPcBsiSOY2jh+iKVTTsSX
         vpYQ2JrIlicw8pAEnIj04w7PUkuhBe+AYY6CxpZ5R1dqyf1TBTlA5j5fr7utNaZDdSUz
         a743gRWWcSwC7gbhs1JPtmyf/rq1dE0R3XnpxoHtg6fjLjptiY1wL9At+csncwDm2FIB
         goQFWcMCZ9qTI9N9cxxbef6Hfjbl06bkceL+5SMXzXI2Eszda4J8Ug5DWf4fn3ppa+TL
         MmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758820442; x=1759425242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x7ycXV9ALf3t9U0+dL4DRxPImOWr4pLGbcQVQ9bNkH8=;
        b=qRJ89anDGaUmzgB1zr5S35jWIEtRr3NeD5392MXQKLOn/Jm3rzlmQth/pc8q09tI9k
         dOfSmMEZJcV4PoeTWzwxBZbDBp+jxjCMnhnXlzWSSkJ+FQw+hf2tp9uEZDrggEkXSeNx
         GCm8hZ+roJSV2i10B9u/gJ+Un7Da7vXC48knFY+fPmi5UfgCGe8/RtEIOWavJejzpZzH
         S0XZfDBRxvTpcyAd0KvNR+zJgYNbl7Jkf1iDCbgPsbRdZM7me3HI19NctGg/N7xmD3ef
         iBtRhNB1Xv8HgDWnRpTFNKa7lVqlkHX6h4YEsaSLEm6PcNbIj/xfqa66ALimxwoszlnP
         C2FA==
X-Forwarded-Encrypted: i=1; AJvYcCXcHWLgW84O1W4gMJo0ftOzRkWWwdJuroadRFla9tmFpR9eewxE+t1U5AOIza2gDfAUfrc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQqlexWVos3fRLVkn8Wjo5w2NaVV/trK7Lqy5r3+gNRsD7sv83
	q3pXcJnPnq10z/a0sq8c+QyPEAtU4uidsSiHHCDpW62wYm3UOavQf+dG3L0TtgwRKmfGcT+uNyu
	wmqWBaLFZi4vvU+f+dKhE8YWjvK5lZaWLvoUG278i
X-Gm-Gg: ASbGncsn4INCyUtC+SqqWdF3sw667e/OD1s+/AhFmDjTDIydfKU5Snjz/U3KoqsoFBz
	kHvrqq/G1bwjnC+WBFpPsRFo+w/LJWw5gCXLfuMNWDsdMO3ode1pJ7QmCxOvNpOz1UbOsNeO24S
	9UXB75IizOIJlO9FJGbbvyuAViJYwKr1mDmCraKWqrJLA+TLh2/rHZiPwbhm2Gxi19EMs2ldzVL
	BzzNVBVwDr6MtE6LQRK+grAn79dITp9GVA9asVY9EscEe4=
X-Google-Smtp-Source: AGHT+IE/3omXtmTIFphm5XyKxWwfQx3mUzjPLQqwGtDxdWjLUXgOos5LeMh+l14NC5S9rmfkM2Iu1IpHfWn93O4LE8E=
X-Received: by 2002:a05:622a:353:b0:4ca:c49a:549d with SMTP id
 d75a77b69052e-4da2d90021amr9438401cf.9.1758820440890; Thu, 25 Sep 2025
 10:14:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904065453.639610-1-sagis@google.com> <20250904065453.639610-11-sagis@google.com>
 <0e8a2035-caeb-4c75-9620-b65df07be1a0@linux.intel.com>
In-Reply-To: <0e8a2035-caeb-4c75-9620-b65df07be1a0@linux.intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Thu, 25 Sep 2025 12:13:49 -0500
X-Gm-Features: AS18NWBadwHPJhh-03bo9A-fY7XHc5b_Fi0gzqzGhNSrf-GYZk-2trDrTs8KUfc
Message-ID: <CAAhR5DFQv0kVYDduoRv6bAL24N23ZA+1ggs=CAh6=iEcA2husg@mail.gmail.com>
Subject: Re: [PATCH v10 10/21] KVM: selftests: Set up TDX boot parameters region
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 8, 2025 at 3:07=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.com=
> wrote:
>
>
>
> On 9/4/2025 2:54 PM, Sagi Shahar wrote:
> [...]
> > +
> > +void vm_tdx_load_common_boot_parameters(struct kvm_vm *vm)
> > +{
> > +     struct td_boot_parameters *params =3D
> > +             addr_gpa2hva(vm, TD_BOOT_PARAMETERS_GPA);
> > +     uint32_t cr4;
> > +
> > +     TEST_ASSERT_EQ(vm->mode, VM_MODE_PXXV48_4K);
> > +
> > +     cr4 =3D kvm_get_default_cr4();
> > +
> > +     /* TDX spec 11.6.2: CR4 bit MCE is fixed to 1 */
> > +     cr4 |=3D X86_CR4_MCE;
> > +
> > +     /* Set this because UEFI also sets this up, to handle XMM excepti=
ons */
>
> I don't get it.
> Could you elaborate it a bit?
>

I'm not entirely sure where this code came from but it looks like this
is unnecessary, at least for now. Dropping this in the next version.

> > +     cr4 |=3D X86_CR4_OSXMMEXCPT;
> > +
> > +     /* TDX spec 11.6.2: CR4 bit VMXE and SMXE are fixed to 0 */
> > +     cr4 &=3D ~(X86_CR4_VMXE | X86_CR4_SMXE);
> > +
> > +     /* Set parameters! */
> > +     params->cr0 =3D kvm_get_default_cr0();
> > +     params->cr3 =3D vm->pgd;
> > +     params->cr4 =3D cr4;
> > +     params->idtr.base =3D vm->arch.idt;
> > +     params->idtr.limit =3D kvm_get_default_idt_limit();
> > +     params->gdtr.base =3D vm->arch.gdt;
> > +     params->gdtr.limit =3D kvm_get_default_gdt_limit();
> > +
> > +     TEST_ASSERT(params->cr0 !=3D 0, "cr0 should not be 0");
> > +     TEST_ASSERT(params->cr3 !=3D 0, "cr3 should not be 0");
> > +     TEST_ASSERT(params->cr4 !=3D 0, "cr4 should not be 0");
> > +     TEST_ASSERT(params->gdtr.base !=3D 0, "gdt base address should no=
t be 0");
> > +     TEST_ASSERT(params->idtr.base !=3D 0, "idt base address should no=
t be 0");
> > +}
> > +
> [...]

