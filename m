Return-Path: <kvm+bounces-13510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C56897CED
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 02:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E6331C27A1D
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 00:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145311BC3F;
	Thu,  4 Apr 2024 00:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ptn02ojM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B881773A
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 00:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712189859; cv=none; b=f8hV/TGEugpBZ2rXpgR5Wl2rHsH+HGQ84uPChGX/9Ox+EkWe9OnzGZMlWl1T/beWC/WIw+O6qWHTgST99RJExzAZLW9zCWfO99Y5cDztv6+ngQ7rboZqtMyhbd6tYaauVV6GE7DEH4YIAgkm+z0d2Bv2VME7vrU5G6R62is7Kws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712189859; c=relaxed/simple;
	bh=jhNHOysICI779o73Egt7UZHvLrPML8bG71A3jGDYzbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nIqvH+vvhEGMn98CHwr2NMh2/i0CEFdZQDJzwKkh7EXy6WlDfVpjvs15YMuzv9JLBHGPGsr4UDJqO7cOTybquG27HiRcXYcNZ63Gkj6PxxRBzNWVZiln9pUuAeR5ZvJy/gVBXe68A7fqiVeu0NoTc+2wABeDQ2cvmi/zw+jniDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ptn02ojM; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a4e5ee91879so51504266b.3
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 17:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712189856; x=1712794656; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ssLe+xRcfYlMx9xR0eZTwk414Gz+dUio7AdeAbJ5si0=;
        b=Ptn02ojMpXPgsSpuFeVFbpXW5GYFwMsv5Z2hW/e8oMbZGnnov/tXNMGYCN6aBO9ne1
         0fBL+zr+wfdxd5jUKrTUVBJW9C5lmj+KVxhqyegHnUwwAj/bzqaF82bog7HPS9hugl/M
         pM/dZ76CTXMI/S5TJk5Ysg2ab8u38bdbfKwZJ6MTHzDEXmpD3XR0pqCfgqsw0kTTntRX
         jApgZgYnsOBVyYMhqikkeOSx3aYCRplb56RZ42ssrcNpS15+dQfnnUni78/+jKltnZSI
         M0m/50K0S/E8kWMzPiPpHfqDS/NFo1z2Wb3jGuhjayADa8X34X0mkWI2ChEhaGNetGaG
         9Nuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712189856; x=1712794656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ssLe+xRcfYlMx9xR0eZTwk414Gz+dUio7AdeAbJ5si0=;
        b=Z6/BeK92Ty95KfdOV1rIq+jK4qJWEfw7mc3egSs4Q0N6bsIN5YnN0tyEd/HPYSQGWy
         eKUG5rIX4ujNTVlIP0CTfiQdEVy3n9QkYq7HfVIsNmAaUVNnjzkA6orVlyNeFZYR5RPG
         4G+OJsZ9DUlzUm1ou3xVObow6H+BUFcgMcfPDBfI/ZfbOJ5B/sE9O4HctLhUg7yhfV9v
         xv/W8UqL9ofJ6XsOBdP9YKqP3Y+me2ZNaNbLrGv25qhorsYkmwm1zxDeJmtKEX2yQAWP
         q5fvNo/ApDZzQCJsAqFlThUo8iodm5JGffU3zlx2V1pBoqXrFil8PFuybiLWEopv4YQy
         Q2+A==
X-Gm-Message-State: AOJu0YyW9mieOJRzK8FNfuwjrn2/z2v/TkhKefLKKqkgEwnQw+Me8Ihh
	3bC3+Bfp5YH0MQetzrdzbphKL5QDLDBrFS9DG7L/1ks+3lHcsuXuSk2YPrMNfN6JzXz6Wdw0C3C
	bDaHAO9EzffqhywN5+dye+hl9cx9VD2bv4Cpd770Z7tUkQzq6Yg==
X-Google-Smtp-Source: AGHT+IHn3kmEEVtY/Z4M+IGnFBXQCBBGjilKeGG8Z9DojfTAjitMp5NLvPl7buki9auqxl4foHhN3uLjmOlKu2CDHyU=
X-Received: by 2002:a17:906:1b02:b0:a4e:6957:de24 with SMTP id
 o2-20020a1709061b0200b00a4e6957de24mr447385ejg.37.1712189855541; Wed, 03 Apr
 2024 17:17:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402190652.310373-1-seanjc@google.com>
In-Reply-To: <20240402190652.310373-1-seanjc@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 3 Apr 2024 17:17:19 -0700
Message-ID: <CAGtprH9WB7=B3NrL9xDHvcONPBkQG=S1uCMDi91=oZ=5uNkcTA@mail.gmail.com>
Subject: Re: [ANNOUNCE] KVM Microconference at LPC 2024
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, David Stevens <stevensd@chromium.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jim Mattson <jmattson@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Edgecombe@google.com, Rick P <rick.p.edgecombe@intel.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wei Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Kirill Shutemov <kirill.shutemov@linux.intel.com>, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Jinrong Liang <ljr.kernel@gmail.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 12:08=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> We are planning on submitting a CFP to host a second annual KVM Microconf=
erence
> at Linux Plumbers Conference 2024 (https://lpc.events/event/18).  To help=
 make
> our submission as strong as possible, please respond if you will likely a=
ttend,
> and/or have a potential topic that you would like to include in the propo=
sal.
> The tentative submission is below.
>
> Note!  This is extremely time sensitive, as the deadline for submitting i=
s
> April 4th (yeah, we completely missed the initial announcement).
>
> Sorry for the super short notice. :-(
>
> P.S. The Cc list is very ad hoc, please forward at will.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> KVM Microconference
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> KVM (Kernel-based Virtual Machine) enables the use of hardware features t=
o
> improve the efficiency, performance, and security of virtual machines (VM=
s)
> created and managed by userspace.  KVM was originally developed to accele=
rate
> VMs running a traditional kernel and operating system, in a world where t=
he
> host kernel and userspace are part of the VM's trusted computing base (TC=
B).
>
> KVM has long since expanded to cover a wide (and growing) array of use ca=
ses,
> e.g. sandboxing untrusted workloads, deprivileging third party code, redu=
cing
> the TCB of security sensitive workloads, etc.  The expectations placed on=
 KVM
> have also matured accordingly, e.g. functionality that once was "good eno=
ugh"
> no longer meets the needs and demands of KVM users.
>
> The KVM Microconference will focus on how to evolve KVM and adjacent subs=
ystems
> in order to satisfy new and upcoming requirements.  Of particular interes=
t is
> extending and enhancing guest_memfd, a guest-first memory API that was he=
avily
> discussed at the 2023 KVM Microconference, and merged in v6.8.
>
> Potential Topics:
>    - Removing guest memory from the host kernel's direct map[1]
>    - Mapping guest_memfd into host userspace[2]
>    - Hugepage support for guest_memfd[3]

I and Ackerley would like to discuss 1G page support with guest_memfd
and its implications on host MM and IOMMU implementation.

Regards,
Vishal

