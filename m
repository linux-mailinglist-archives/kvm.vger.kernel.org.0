Return-Path: <kvm+bounces-13563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C328898890
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 15:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01D9E28538F
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2897126F3C;
	Thu,  4 Apr 2024 13:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bdHpKdQq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9783C839F8;
	Thu,  4 Apr 2024 13:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712236222; cv=none; b=hvVxZHEyrO/WrZSzYo/nqdCIRkv4LLv5FSJcE9UVcF2ZmZOJrMpQUOptNkPahvHXbdC7Pnd6KDSNNhgWRrq+J6DPsU/B0exIM9jILJgBZaaBMAIthos28VOvWwj6AkYK/9l5GjFVDG+4mLrnJzf/SNmCvcgLsmx20UmOLZTgnuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712236222; c=relaxed/simple;
	bh=iHH4LrZ9oFnDZqNFfC8i8gMwCvTD31+bnK5OYnA0h9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bxWpj4k49wmcmJUUxYQhZCNQIc5ub76MoI8FI9c8xEOgXNj6frVrDr9YvNy5GU+6H9i41QEKDdnbXscBVZph0c+FWVV1mfye7c8eQehwh9+NmCXhLABVMpF3sAnIk+68zjId6OyxqUDJfWVkvZOceRcyc7xFOF6qQEKRTiNaPZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bdHpKdQq; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e0d82c529fso8801655ad.2;
        Thu, 04 Apr 2024 06:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712236219; x=1712841019; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqelwH9o3hW+5yUTUJV2TSdaxzPG/CMwUy6DAArd0Jo=;
        b=bdHpKdQqrY0lUqj/NmQsFkDmYbna0diapLOQEAcdsevYsgozklEF1YTk+xRHWIQ8gN
         r+6LlLoyMQ5sQjMldy0JBkp8BHglaG80+j/1hFisxwopwkIHuGPxet2krurOirD2bJtM
         fIPuohy2d4yu2zcLTS9k9hQWZspNa0VT0fxZPXjDA0hGTzuFjayahb71qVh1/qlNaWNZ
         nzOwBk03l+twqqUifB3L90gQakLRNhdKvvlkoiiVkFqaarxHV+9MIBt7sxLXa8V3L4ey
         EkZIQtmKP8/ebt0IvcSG0AxK2/p2N1ATCLGhfhz6AzNRh8+cSc6CoO++egjjVfZIi4oI
         GBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712236219; x=1712841019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqelwH9o3hW+5yUTUJV2TSdaxzPG/CMwUy6DAArd0Jo=;
        b=dn1jDsV/1/3pFBx0HS/DcO0hF4uE23KXW5X2/LWAbkx0gfLXN5SLnYWoiL2QgS95P3
         f9Cx02a/WlCb4UiPk0l09Gc0zFnJPGUG9BcL9WwjzzXuUtHEUy4Eb/u66oo+Dw0Cnc6U
         92mnfe0QVHgRsmZ4BX2eqGKJ1HBcemhQJ2IP0CJgs7TtJMBOZcvstv36624QBQauHVT5
         TvZhcyRbEC7Efrc1Zy6qkcF00qbbSCjPfyE6ZVR7i+0ZQ9iZRVImLWwzy/ZvFWG01TUt
         eA8H6eHOgUr9MYtafd762pL5UfIttaCTYq/Ac+JQ47x45NoYmlxp4PpWPctgtWmk9amb
         6iLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWF/5lx8PmFXmEPYqUkQqb8sa0imXjheBrcWuU8WBMLOBGcVfQSzxsRmbkZTDQXrFNY2oD4gLmREN8aIL7e11HZc0dMmrfJJwJDWedj
X-Gm-Message-State: AOJu0YxNXdtsAUUGrD4PMuuJrSq61pl1qYRAmwzoIEsn02Z9qPTzzJZb
	vP9jTcHtkCCnxGebbGd/TuAqvF8cXmYbBo0DwbmUt0g71wnhjoYnifkBuq1o7vbjCl9XxCMin2w
	XzK2JA5Ie9N3AdFV8INoAK1YACjE=
X-Google-Smtp-Source: AGHT+IFBbUbEXXh+CayLTumLwG7G7cpecD4eSpEGBW7zUX0ib/iK49LkKTwlM2LnbwTVUNEs4pcocwtPvlIs5GGiUSI=
X-Received: by 2002:a17:903:124c:b0:1e2:23d2:a855 with SMTP id
 u12-20020a170903124c00b001e223d2a855mr2556653plh.28.1712236219350; Thu, 04
 Apr 2024 06:10:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402190652.310373-1-seanjc@google.com>
In-Reply-To: <20240402190652.310373-1-seanjc@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Thu, 4 Apr 2024 21:10:05 +0800
Message-ID: <CAJhGHyCgQkBcHZGxEUVMYimmad7UcuzDHXoyRGyTEngO=ZBDEg@mail.gmail.com>
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
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, 
	Wei Wang <wei.w.wang@intel.com>, Liam Merwick <liam.merwick@oracle.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Kirill Shutemov <kirill.shutemov@linux.intel.com>, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Jinrong Liang <ljr.kernel@gmail.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 3, 2024 at 3:08=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
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
>    - Eliminating "struct page" for guest_memfd
>    - Passthrough/mediated PMU virtualization[4]
>    - Pagetable-based Virtual Machine (PVM)[5]

Wenlong and I would like to share the various use cases of PVM and
discuss its inherent value, underlying technology, and prospects for
the future. We also aim to initiate a discussion on the design of an
effective PV page table management system, with a particular focus on
optimizing it for Nested-TDP as well as PVM scenarios.

Thanks
Lai

>    - Optimizing/hardening KVM usage of GUP[6][7]
>    - Defining KVM requirements for hardware vendors
>    - Utilizing "fault" injection to increase test coverage of edge cases
>
> [1] https://lore.kernel.org/all/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.=
camel@amazon.com
> [2] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com
> [3] https://lore.kernel.org/all/CABgObfa=3DDH7FySBviF63OS9sVog_wt-AqYgtUA=
GKqnY5Bizivw@mail.gmail.com
> [4] https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@lin=
ux.intel.com
> [5] https://lore.kernel.org/all/20240226143630.33643-1-jiangshanlai@gmail=
.com
> [6] https://lore.kernel.org/all/CABgObfZCay5-zaZd9mCYGMeS106L055CxsdOWWvR=
TUk2TPYycg@mail.gmail.com
> [7] https://lore.kernel.org/all/20240320005024.3216282-1-seanjc@google.co=
m
>

