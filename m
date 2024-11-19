Return-Path: <kvm+bounces-32060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E81789D292F
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 16:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A885A282139
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FCB41CF5F9;
	Tue, 19 Nov 2024 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="gbQGxuqu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8031D0488
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732028592; cv=none; b=PW+0ti/99xsN9KFrpLvFsz81/vvpOU4CKc5VRawQYDrcDTzuyJwlD77aDGSL6nvi0EkZmMCmoxHY0/60Xg61By7Kp0A+NqWRdJKrTPUS+/2zS/tTQHkrvnJeTAAPY4VINoMl9xxnM+MrGUjyYoq8ilW0t1KCEmxaZwpgzx+5aDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732028592; c=relaxed/simple;
	bh=XvwcDJBml62yKn4itDkBswOJHcySD6NBqEbnj9WBXCA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Z7N9izcLb4eelluHfi7sHlaLIOI2qmcS8+5z2zMifXJVRk2/dVSvEEzL5APFKyCfBvkZO9Yu+6qISbSK5TM3ZdI2Yq68Zaf2+cfvWadqHk1BDASL+j85L6KJMP5wmebTEO6EfoyJNjPEcGcY8K06gz9BH1tB7UGDUHjw5p35a/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=gbQGxuqu; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-38231e9d518so2637786f8f.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 07:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732028588; x=1732633388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwuBbcUvdsJsNlAmA8kNK2a4zz8OYZ18Ka20Jiz0Pm0=;
        b=gbQGxuqut63p5EeX/513O7hfgsouqJ700G1npYlaGa8kCNNc2PQD7C8Qs041O69/5U
         oifX2tKDSRexCLw0igiXs0HoAImGlCAE/+mW2Ex8yJCyePnvEjsPXj9792PZrLUSgwc1
         CXupiK/hknPEsxHk8WZhhjXdVhc8K1M9wfKIRPpNXfZNAAtokcFUqnu77j14TOHqBVPk
         J6aRR85M4E1gnMJVZg4CThbUHcz+5W8tzJC6Qhlhn11DpXkkRdBp9jxwGDPDPMhpR137
         1nDGWRKkstFnQseJiBPuQDgNhOo75g1TohqK2KIXh9KdQGfPanhPga6lHRzwzopU1Aq9
         SLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732028588; x=1732633388;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dwuBbcUvdsJsNlAmA8kNK2a4zz8OYZ18Ka20Jiz0Pm0=;
        b=VXdq6Sr9fp3SYWZF7MAq45PenFb0njN2kA2a2vsKb957NVIIqQ0+kniO9AdZijAvBc
         w9D/5Q6PLl74vK8bJfHNhqDsg3b7KoCUzgl5p9QLDXWET7ZCxIjyRU/Z7tz6sLuOZDP9
         s85PC4kP7sc9Wd3Ep8vUl1mMqRVK3DAlzP6bMM1FMVS3jL/DX29uQpYfY3g2Md3yze71
         H1ErQB6f0kKosCGNCWthAmiqf8lTQSjVdaDkLCeJ6acDYev2eFDduaprOeL/nTG6Rwfp
         kW26u6EY0651nWaHAlgjgXpkXwrJt2tIgaPc4QsgINFr9/dothsXg/Pjrexy7eU4HrqU
         sQIw==
X-Forwarded-Encrypted: i=1; AJvYcCXwBwYO2LmWkhR+bFO+fHjSURC7CPym+0wGh+Qs0b212BXgOXhP1UkAw/VjDqTeUvKVd28=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLIByZiRj87yUuFXvsp52Z48Ct1cegc6ek3wLfD8R3tsg/OvBI
	+31g7HWGmJinRq1I8DZ2kjN0ePaC2I8Hd7ae0pdeExwqS28V23X6ZKEchTcRnrQC+zqzu6BnB/q
	k9zo=
X-Google-Smtp-Source: AGHT+IFvFX7MJ8Tu28i9oH50avvlnQXkr7wiV44jnwVsLQSm9Sm8I2ZZy94Fp/+zJ+w9zxPk7qMCZA==
X-Received: by 2002:a05:6000:178d:b0:382:5137:30eb with SMTP id ffacd0b85a97d-382513734fdmr780854f8f.8.1732028585939;
        Tue, 19 Nov 2024 07:03:05 -0800 (PST)
Received: from [127.0.0.1] (78-80-61-208.customers.tmcz.cz. [78.80.61.208])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da28bc11sm197286915e9.31.2024.11.19.07.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 07:03:05 -0800 (PST)
Date: Tue, 19 Nov 2024 16:03:05 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 tjeznach@rivosinc.com, zong.li@sifive.com, joro@8bytes.org, will@kernel.org,
 robin.murphy@arm.com, anup@brainfault.org, atishp@atishpatra.org,
 tglx@linutronix.de, alex.williamson@redhat.com, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_08/15=5D_iommu/riscv=3A_A?=
 =?US-ASCII?Q?dd_IRQ_domain_for_interrupt_remapping?=
In-Reply-To: <20241119140047.GC559636@ziepe.ca>
References: <20241114161845.502027-17-ajones@ventanamicro.com> <20241114161845.502027-25-ajones@ventanamicro.com> <20241118184336.GB559636@ziepe.ca> <20241119-62ff49fc1eedba051838dba2@orel> <20241119140047.GC559636@ziepe.ca>
Message-ID: <DE13E1DF-7C68-461D-ADCD-8141B1ACEA5E@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On November 19, 2024 3:00:47 PM GMT+01:00, Jason Gunthorpe <jgg@ziepe=2Eca>=
 wrote:
>On Tue, Nov 19, 2024 at 08:49:37AM +0100, Andrew Jones wrote:
>> On Mon, Nov 18, 2024 at 02:43:36PM -0400, Jason Gunthorpe wrote:
>> > On Thu, Nov 14, 2024 at 05:18:53PM +0100, Andrew Jones wrote:
>> > > @@ -1276,10 +1279,30 @@ static int riscv_iommu_attach_paging_domain=
(struct iommu_domain *iommu_domain,
>> > >  	struct riscv_iommu_device *iommu =3D dev_to_iommu(dev);
>> > >  	struct riscv_iommu_info *info =3D dev_iommu_priv_get(dev);
>> > >  	struct riscv_iommu_dc dc =3D {0};
>> > > +	int ret;
>> > > =20
>> > >  	if (!riscv_iommu_pt_supported(iommu, domain->pgd_mode))
>> > >  		return -ENODEV;
>> > > =20
>> > > +	if (riscv_iommu_bond_link(domain, dev))
>> > > +		return -ENOMEM;
>> > > +
>> > > +	if (iommu_domain->type =3D=3D IOMMU_DOMAIN_UNMANAGED) {
>> >=20
>> > Drivers should not be making tests like this=2E
>> >=20
>> > > +		domain->gscid =3D ida_alloc_range(&riscv_iommu_gscids, 1,
>> > > +						RISCV_IOMMU_MAX_GSCID, GFP_KERNEL);
>> > > +		if (domain->gscid < 0) {
>> > > +			riscv_iommu_bond_unlink(domain, dev);
>> > > +			return -ENOMEM;
>> > > +		}
>> > > +
>> > > +		ret =3D riscv_iommu_irq_domain_create(domain, dev);
>> > > +		if (ret) {
>> > > +			riscv_iommu_bond_unlink(domain, dev);
>> > > +			ida_free(&riscv_iommu_gscids, domain->gscid);
>> > > +			return ret;
>> > > +		}
>> > > +	}
>> >=20
>> > What are you trying to do? Make something behave different for VFIO?
>> > That isn't OK, we are trying to remove all the hacky VFIO special
>> > cases in drivers=2E
>> >=20
>> > What is the HW issue here? It is very very strange (and probably not
>> > going to work right) that the irq domains change when domain
>> > attachment changes=2E
>> >=20
>> > The IRQ setup should really be fixed before any device drivers probe
>> > onto the device=2E
>>=20
>> I can't disagree with the statement that this looks hacky, but consider=
ing
>> a VFIO domain needs to use the g-stage for its single-stage translation
>> and a paging domain for the host would use s-stage, then it seems we ne=
ed
>> to identify the VFIO domains for their special treatment=2E
>
>This is the wrong thinking entirely=2E There is no such thing as a "VFIO
>domain"=2E
>
>Default VFIO created domains should act excatly the same as a DMA API
>domain=2E
>
>If you want your system to have irq remapping, then it should be on by
>default and DMA API gets remapping too=2E There would need to be a very
>strong reason not to do that in order to make something special for
>riscv=2E If so you'd need to add some kind of flag to select it=2E
>
>Until you reach nested translation there is no "need" for VFIO to use
>any particular stage=2E The design is that default VFIO uses the same
>stage as the DMA API because it is doing the same basic default
>translation function=2E

The RISC-V IOMMU needs to use g-stage for device assignment, if we also wa=
nt to enable irqbypass, because the IOMMU is specified to only look at the =
MSI table when g-stage is in use=2E This is actually another reason the irq=
 domain only makes sense for device assignment=2E

>
>Nested translation has a control to select the stage, and you can
>then force the g-stage for VFIO users at that point=2E

We could force riscv device assignment to always be nested, and when not p=
roviding an iommu to the guest, it will still be single-stage, but g-stage,=
 but I don't think that's currently possible with VFIO, is it?

>
>Regardless, you must not use UNMANAGED as some indication of VFIO,
>that is not what it means, that is not what it is for=2E
>
>> Is there an example of converting VFIO special casing in other
>> drivers to something cleaner that you can point me at?
>
>Nobody has had an issue where they want interrupt remapping on/off
>depending on VFIO=2E I think that is inherently wrong=2E
>
>> The IRQ domain will only be useful for device assignment, as that's whe=
n
>> an MSI translation will be needed=2E I can't think of any problems that
>> could arise from only creating the IRQ domain when probing assigned
>> devices, but I could certainly be missing something=2E Do you have some
>> potential problems in mind?
>
>I'm not an expert in the interrupt subsystem, but my understanding was
>we expect the interrupt domains/etc to be static once a device driver
>is probed=2E Changing things during iommu domain attach is after drivers
>are probed=2E I don't really expect it to work correctly in all corner
>cases=2E

With VFIO the iommu domain attach comes after an unbind/bind, so the new d=
river is probed=2E I think that's a safe time=2E However, if there could be=
 cases where the attach does not follow an unbind/bind, then I agree that w=
ouldn't be safe=2E I'll consider always creating an IRQ domain, even if it =
won't provide any additional functionality unless the device is assigned=2E

>
>VFIO is allowed to change the translation as it operates and we expect
>that interrupts are not disturbed=2E
>

The IRQ domain stays the same during operation, the only changes are the m=
appings from what the guest believes are its s-mode interrupt files to the =
hypervisor selected guest interrupt files, and these changes are made possi=
ble by the IRQ domain's vcpu-affinity support=2E

Thanks,
drew

