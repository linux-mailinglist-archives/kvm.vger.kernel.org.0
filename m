Return-Path: <kvm+bounces-9961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2228E86800E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:51:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C609B27523
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15A4412F39C;
	Mon, 26 Feb 2024 18:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iyk8dnsj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C273412DDAB
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708973459; cv=none; b=MlOK/RhMGP7w33in4vkNnp9cjeklZpWJ+sbSB1VOvpHfj4c5Fke7Him+hR6pU4zMtgu/Y8KcOG4FGGh3UMVyaGPqfHpVEiI+dvVzKlMkxDxjOWITDSeZJjB6tU9Ol7wFkQXC8/CpwbCo6TEdukd5fRBXQj5R79aHPjH4xXOKQlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708973459; c=relaxed/simple;
	bh=mR3iJeZnih0xL1L6otAWQA+ldA1EaLa1CgEyXe7SlYQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XD+pLrQPc6S/N3Lx6BKHIg8jq6JoFJRrxixqKgef7nyY9bxOC/9aMeHq+QJ2ZGWoHIMvz5XAaiykXHFjvf5d0NE0InaSEN68B9xE+6QDECiLw/AlXFLbnBrsYLY+zBP3ctZkOu9I/fW5mCz5f1f2n1FYq7tZd6lD9prc/bNTXEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Iyk8dnsj; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b267bf11so3709019276.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708973457; x=1709578257; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gzHSVsSttEBs/IBwvNsGKixFyS/qBb/S7FRwS0QE9ng=;
        b=Iyk8dnsjGS2u6CC0DyDExuu71WhihDXUhZGy4RM1oG0YZexvizSficmCpLZptJ9ZFh
         /ct35NghAYuAclFZIblhm0JoZ4AU1z/NDRvSlmBzu2TyF3ilMrJNs+9jYRR4nF5ig4jP
         imRvWXPUH5n25XbJZ13h/oFRmO29Vj/30ouNX1yV/in3qnLjQdipV8S1PwRPsSTPQFtr
         Llce7W00B6UbNee6eIIwcKEYPw6ruxMds+MZKizrkIpuuAF9bHg5R1CAzQG6fDnGLNUX
         eK0G0v6nR5UEJdelNQohULi4DxU+cWNT7neGG0SQpK1r48eV0j22GSs/K8Ht9RcGI7pm
         GCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708973457; x=1709578257;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gzHSVsSttEBs/IBwvNsGKixFyS/qBb/S7FRwS0QE9ng=;
        b=DBvfv8oyrKRwE68drj5JkVAV3ymnqBdtoKPB/WfGsl9xZzdSFrNckHAcVHYInF/+Jz
         tbZp33URidOZtKWKZMl/s+tJ5M1H/3EPZk+N85NkfHimFjE797hcFfa0nw+oW6BY/0BA
         NUlavJKY7TL92Aan8TAFYq+fBVF/ZE929i9/KpjR+wyqfpKNSyZjnSl9U3I8Hy752ftK
         goBvxUdhTK/+j+HbP2hZ5wL7CWGDS02Y6XzlY4B1yTnt2C1Y8RV2vnGRs+dk+TXtiN6c
         qx+5vI+hGdNjp+GNjioNzG/DGlHHc1gwIIlQu5LQCaquIFfsZk41AOxDGbd3PLpA39A3
         JcQA==
X-Forwarded-Encrypted: i=1; AJvYcCXOG8aP6nrPOrAv6Q5umWvrJJbUSyxyb9a8n/FYtgpbEwaKccYer7XnV+NNSkSqppwKC4t5URxyLS595A33IBcBSMou
X-Gm-Message-State: AOJu0YwjsfojJLsdk2P6KkdHvTpuWjvGR/x6bq56MVQYTkU+Hp90n/Aw
	HsfKMecB+skpgvXxmRzmiU/Lh3hAnZbAkAiqyhNljsDNj58Qy4HZAsp7wIMtyW4KmNJbGxXbLFQ
	/tg==
X-Google-Smtp-Source: AGHT+IE3sxgoQOVKs/Aw4bLX2W3H+y8x4pf1nRDXIZJeaD0kFXZplENiuA4kqdUZmnHrG1B2dmvQUpBy5NI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1109:b0:dcd:59a5:7545 with SMTP id
 o9-20020a056902110900b00dcd59a57545mr187ybu.10.1708973456756; Mon, 26 Feb
 2024 10:50:56 -0800 (PST)
Date: Mon, 26 Feb 2024 10:50:55 -0800
In-Reply-To: <20240226180712.GF177224@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <97bb1f2996d8a7b828cd9e3309380d1a86ca681b.1705965635.git.isaku.yamahata@intel.com>
 <Zbrj5WKVgMsUFDtb@google.com> <CALzav=diVvCJnJpuKQc7-KeogZw3cTFkzuSWu6PLAHCONJBwhg@mail.gmail.com>
 <20240226180712.GF177224@ls.amr.corp.intel.com>
Message-ID: <Zdzdj6zcDqQJcrNx@google.com>
Subject: Re: [PATCH v18 064/121] KVM: TDX: Create initial guest memory
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: David Matlack <dmatlack@google.com>, isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, Sagi Shahar <sagis@google.com>, 
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com, 
	tina.zhang@intel.com, gkirkpatrick@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024, Isaku Yamahata wrote:
> On Thu, Feb 01, 2024 at 03:06:46PM -0800,
> David Matlack <dmatlack@google.com> wrote:
>=20
> > +Vipin Sharma
> >=20
> > On Wed, Jan 31, 2024 at 4:21=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > On Mon, Jan 22, 2024, isaku.yamahata@intel.com wrote:
> > >
> > > The real reason for this drive-by pseudo-review is that I am hoping/w=
ishing we
> > > can turn this into a generic KVM ioctl() to allow userspace to pre-ma=
p guest
> > > memory[*].
> > >
> > > If we're going to carry non-trivial code, we might as well squeeze as=
 much use
> > > out of it as we can.
> > >
> > > Beyond wanting to shove this into KVM_MEMORY_ENCRYPT_OP, is there any=
 reason why
> > > this is a VM ioctl() and not a vCPU ioctl()?  Very roughly, couldn't =
we use a
> > > struct like this as input to a vCPU ioctl() that maps memory, and opt=
ionally
> > > initializes memory from @source?
> > >
> > >         struct kvm_memory_mapping {
> > >                 __u64 base_gfn;
> > >                 __u64 nr_pages;
> > >                 __u64 flags;
> > >                 __u64 source;
> > >         }
> > >
> > > TDX would need to do special things for copying the source, but beyon=
d that most
> > > of the code in this function is generic.
> > >
> > > [*] https://lore.kernel.org/all/65262e67-7885-971a-896d-ad9c0a760907@=
polito.it
> >=20
> > We would also be interested in such an API to reduce the guest
> > performance impact of intra-host migration.
>=20
> I introduce KVM_MEMORY_MAPPING and KVM_CAP_MEMORY_MAPPING with v19.

KVM_MEMORY_MAPPING is not a good ioctl() name.  There needs to be a verb in=
 there
somewhere, e.g. KVM_MAP_MEMORY, KVM_FAULTIN_MEMORY, etc.

> We can continue the discussion there.

No, we absolutely cannot continue the conversation there.   That is not how=
 kernel
development works.

Enough is enough.  I am archiving v19 and not touching it.

Please post an RFC for _just_ this functionality, and follow-up in existing=
,
pre-v19 conversations for anything else that changed between v18 and v19 an=
d might
need additional input/discussion.

