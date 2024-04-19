Return-Path: <kvm+bounces-15328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 288618AB308
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D88DB232C0
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D550F131BB2;
	Fri, 19 Apr 2024 16:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bpc2mp6S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD74130AEB
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543150; cv=none; b=T7EdQf41gn5POh5G5qgB8VnjpdxG8tGARp4DNX+ZvLMnoHBghLYDamvaNL4pU942RFomYWkhPUcPf5T5LePHXl/KPHqBIvT2I2NC40OqpXTBqQtgEUuYUVE7CVB3vezpRYbni+cbzE+0BRgHM8PnuxonPBwtYyUElZ84U2HscLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543150; c=relaxed/simple;
	bh=BoY/Dy3UEpWzAlEVCqDQTE76CEu5CAwU1Yr/gwGs0FU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h5FogOH2PDI8ZaypJO1BhQWqrPPUY8u7AvRJKvXN4xcgzf61gvkMehcQqKiRcz9WeOyE310KsGwJUZdYMmI2xj48AHQCzLszgnQd47SrrrkZClY25hednU6nV9vBpDQUq1ZZXD7tgEEsnWmNq+8ARTQgXllnEI1ukoNrqMzuXVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bpc2mp6S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713543147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9uBiWyy2Y6aSUbUd2veflvDo2gmH6uQXxYZf3A1GRsI=;
	b=Bpc2mp6SLG7zIQdxlmAKtdIxjFmShYq7tjJaZ+Rn28vu9VxFhO1io2a7EX3WfzX2gqzvqL
	r/009oZ14Cvn/A882ptEdpPfDG25PiYvHsarV8Bwd+d4tDzx/TaICQXMYgqmD68jqZy7Gh
	bYiqar9zJ8SFjsHzAnb6+ZYej0rElCY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-TNNMVgUVNSqNVtutQBTzYA-1; Fri, 19 Apr 2024 12:12:24 -0400
X-MC-Unique: TNNMVgUVNSqNVtutQBTzYA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343f8b51910so1339925f8f.3
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543143; x=1714147943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9uBiWyy2Y6aSUbUd2veflvDo2gmH6uQXxYZf3A1GRsI=;
        b=ssUeqIKV3MW8CEA5VRCYFQlQtzCerfkkW6JZ1x0X882y+7DPq5r/NSDAGL4/RTSvBP
         OK6K4Y3osOgq0MDVmjavB68blOaA2lm4VUjmuuQIkdw3oFdLuhYcy/20XzXZR60rxniL
         ll4oGHLhcIHSiDIN2/L5D0VWiGLKyh7NUWw5yHTEw27kIjKPy22hfpS8MqlPbn2BVBgl
         x8leqA3HxJc2uB7DnTRd62cHrLNp1MFzvefU/3HZVVBDAGt6HzdCGtOctdPRBdwuGZ5h
         pZ//Q41C3UFj9GkADvnIgQxn6Fjbpcsf8pGMXbFGLSp3oC08/5doBLYheCO91pytu0VW
         jdBA==
X-Gm-Message-State: AOJu0YyGiT0hvD+0Oygtwfp8H3r5QrogoSKphRh9oS2ReVj3ywTdwXdM
	jJ2aHdRkCeTa9KpPfElF23PtYrvcMp9/g60cLN+HJLbXTSSrAZ7L0PY523dot+WY9g+sfWyfJKR
	yF0od+2NCsUpeJYz+QUqF31QgX8GILYirCaPwhOKDgnd5JtzdVb0/FQSktTKaTTIM07z+y+gggR
	Ri2VhmsYNsk1LQda8wxUvt6MFF
X-Received: by 2002:a05:6000:f:b0:34a:72d:8dae with SMTP id h15-20020a056000000f00b0034a072d8daemr1744505wrx.22.1713543142967;
        Fri, 19 Apr 2024 09:12:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGu/laGQnrA9BrIF/Cu+lsjfknC5maDVu87SwW7AhUXq8hp5tDZF8U2qhpYBw4LEzoXCxA4xzi8O802s4cFw3o=
X-Received: by 2002:a05:6000:f:b0:34a:72d:8dae with SMTP id
 h15-20020a056000000f00b0034a072d8daemr1744478wrx.22.1713543142601; Fri, 19
 Apr 2024 09:12:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com>
 <20240418194133.1452059-11-michael.roth@amd.com> <CABgObfaj4-GXSCWFx+=o7Cdhouo8Ftz4YEWgsQ2XNRc3KD-jPg@mail.gmail.com>
In-Reply-To: <CABgObfaj4-GXSCWFx+=o7Cdhouo8Ftz4YEWgsQ2XNRc3KD-jPg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 18:12:11 +0200
Message-ID: <CABgObfa9Ya-taTKkRbmUQGcwqYG+6cs_=kwdqzmFrbgBQG3Epw@mail.gmail.com>
Subject: Re: [PATCH v13 10/26] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 1:56=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
> > +       ret =3D kvm_gmem_populate(kvm, params.gfn_start, u64_to_user_pt=
r(params.uaddr),
> > +                               npages, sev_gmem_post_populate, &sev_po=
pulate_args);
> > +       if (ret < 0) {
> > +               argp->error =3D sev_populate_args.fw_error;
> > +               pr_debug("%s: kvm_gmem_populate failed, ret %d (fw_erro=
r %d)\n",
> > +                        __func__, ret, argp->error);
> > +       } else if (ret < npages) {
> > +               params.len =3D ret * PAGE_SIZE;
> > +               ret =3D -EINTR;
>
> This probably should 1) update also gfn_start and uaddr 2) return 0
> for consistency with the planned KVM_PRE_FAULT_MEMORY ioctl (aka
> KVM_MAP_MEMORY).

To be more precise, params.len should be set to the number of bytes *left*,=
 i.e.

   params.len -=3D ret * PAGE_SIZE;
   params.gfn_start +=3D ret * PAGE_SIZE;
   if (params.type !=3D KVM_SEV_SNP_PAGE_TYPE_ZERO)
       params.uaddr +=3D ret * PAGE_SIZE;

Also this patch needs some other changes:

1) snp_launch_update() should have something like this:

   src =3D params.type =3D=3D KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL :
u64_to_user_ptr(params.uaddr),;

so that then...

> +               vaddr =3D kmap_local_pfn(pfn + i);
> +               ret =3D copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_S=
IZE);
> +               if (ret) {
> +                       pr_debug("Failed to copy source page into GFN 0x%=
llx\n", gfn);
> +                       goto out_unmap;
> +               }

... the copy can be done only if src is non-NULL

2) the struct should have some more fields

> +        struct kvm_sev_snp_launch_update {
> +                __u64 gfn_start;        /* Guest page number to load/enc=
rypt data into. */
> +                __u64 uaddr;            /* Userspace address of data to =
be loaded/encrypted. */
> +                __u32 len;              /* 4k-aligned length in bytes to=
 copy into guest memory.*/
> +                __u8 type;              /* The type of the guest pages b=
eing initialized. */

__u8 pad0;
__u16 flags;   // must be zero
__u64 pad1[5];

with accompanying flags check in snp_launch_update().

If you think IMI can be implemented already (with a bit in flags) go
ahead and do it.

Paolo


