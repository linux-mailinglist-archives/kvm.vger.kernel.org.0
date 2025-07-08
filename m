Return-Path: <kvm+bounces-51807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C74AFD6B9
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 20:56:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B8BA1C20B09
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 18:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495122E54D5;
	Tue,  8 Jul 2025 18:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bBBTeZ4T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ABB18A6AE
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 18:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752000951; cv=none; b=r7yO3fzqII0ohqqhBq1/vQyY2kmcIDGMoWcf4Uo9y+vq053yuvus+PPs71Vpn5NA6Zs0RHNSlKYHHJ8TUsMLJ4Ae53+lULQ0gN1LIEPNwWXOJu43DprOIasIKVsDLE3qRg6sNwCIoxJHhe3PYV8Kz0UYs/1gx3xdwudiLkvuVaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752000951; c=relaxed/simple;
	bh=xTGNfOSJzth56pNWxhRD7XWCKofNAfL+zE0LKJHwAuo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n4rP6w6fL3J/j74/OtAid+WTHL5LuNSJwY8kyc5Jd7/dRjiDOJG2JK+ozLGGsFik2FyRZ+MJXh2Zj2poPIE02gNhOMF9Db1kX2ceD2mQqZI5aCO0CWi1dcZrNfhUoACsCw1MA9HyJLLBXrhpTFbbyfS1XLMtckGshFyL3Ozgw9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bBBTeZ4T; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2fa1a84566so3271511a12.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 11:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752000949; x=1752605749; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fi49isHjUbTCoTuN9wAATX2asE3D5qC38lugMILs33w=;
        b=bBBTeZ4TTJo4CXv61WweMJFBXBrCsBGt4/zq1yl4E9upXaE/l0iX3B3kGeK2F27VtN
         sID3XM/V99m41UqdlTioUBKpNcIZm5htzf8NH8bT1M1eIUus2tqmR6MrHaspA55ql894
         zKYoPZj7lNnaiEekGDuET4z9U0umFrETpdI/tV7ZJkQFl9q+tj+wSkjxQGFikbqxb1Ol
         xz76AuF6MnMrFa5hcWZei/+KdAMcJqWbZjktgyv+IZkpKso7rs1UDl/i3kaPucFNUsEB
         HXg0nmpXlv/8uts4tC9QAzAXqoYREGzJFIE6L4wwlCT6cdDo3egyBA0+QavGoTaSq4Rm
         lOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752000949; x=1752605749;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fi49isHjUbTCoTuN9wAATX2asE3D5qC38lugMILs33w=;
        b=LL+sOig9+rTF9PEmxVCNpMJZ9X+yIkm8Qo8PZRNUb8X0jbRzQ1f79OIhLXOLqb7qIQ
         5AxzyiczgSgnLWLl3SDg8j8yrg24rZ3E9rPhncZv5+1HYQflt2Hh1cpQfxa0iCklWNRx
         k+N1j6ylhIsuNTSQ5VLkRLLikvWNarujznYCuZVUvX4tqStqK0OhVZfHXFVGqG9D0Au8
         HqJS71oOMgZOdqwzSPuROQ0wgSj0F0wrBj/O8FUS07H+0+xerR7KEDVbbHevPm9FaS8O
         8dfpHS3SlMH0NmsJYA471fbCRijwQ+48lrRKQIljhF28GyXnC+nwTzZGkpIutHVnKh+C
         uKxA==
X-Forwarded-Encrypted: i=1; AJvYcCXL/7fQij8bx6v81z1qIdP95zOYAIywcNHupLt+webJwcBbyaqiOEDOrenuJrxzMPyj+WY=@vger.kernel.org
X-Gm-Message-State: AOJu0YytmujHhVyXMPs3dPi6bv7qiXnKx6P6L/HRHCCY4/b/s6jIw/Ur
	KRGH2NL00fPdlrH/jJAIUjEs0syDQVsWt7O3W0zK4+9uvx9mYNJ9TlHOPcJGEbYbP4OcagqTosF
	dAcVrdw==
X-Google-Smtp-Source: AGHT+IEFMwD1SUZ6NWjUN/Oq62lH5zXOf8LQ57ZZYUcKAc0E0p/gulNYcvCDjCJG+mP3axWJpVjPcEFNH7M=
X-Received: from pjtd3.prod.google.com ([2002:a17:90b:43:b0:312:18d4:6d5e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c88e:b0:31a:bc78:7fe1
 with SMTP id 98e67ed59e1d1-31c2ee7d9dbmr289595a91.18.1752000948847; Tue, 08
 Jul 2025 11:55:48 -0700 (PDT)
Date: Tue, 8 Jul 2025 11:55:47 -0700
In-Reply-To: <5decd42b3239d665d5e6c5c23e58c16c86488ca8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAGtprH_57HN4Psxr5MzAZ6k+mLEON2jVzrLH4Tk+Ws29JJuL4Q@mail.gmail.com>
 <006899ccedf93f45082390460620753090c01914.camel@intel.com>
 <aG0pNijVpl0czqXu@google.com> <a0129a912e21c5f3219b382f2f51571ab2709460.camel@intel.com>
 <CAGtprH8ozWpFLa2TSRLci-SgXRfJxcW7BsJSYOxa4Lgud+76qQ@mail.gmail.com>
 <eeb8f4b8308b5160f913294c4373290a64e736b8.camel@intel.com>
 <CAGtprH8cg1HwuYG0mrkTbpnZfHoKJDd63CAQGEScCDA-9Qbsqw@mail.gmail.com>
 <b1348c229c67e2bad24e273ec9a7fc29771e18c5.camel@intel.com>
 <aG1dbD2Xnpi_Cqf_@google.com> <5decd42b3239d665d5e6c5c23e58c16c86488ca8.camel@intel.com>
Message-ID: <aG1ps4uC4jyr8ED1@google.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pvorel@suse.cz" <pvorel@suse.cz>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, Jun Miao <jun.miao@intel.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pdurrant@amazon.co.uk" <pdurrant@amazon.co.uk>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"amoorthy@google.com" <amoorthy@google.com>, "tabba@google.com" <tabba@google.com>, 
	"quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>, "maz@kernel.org" <maz@kernel.org>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>, 
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, Vishal Annapurve <vannapurve@google.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, Wei W Wang <wei.w.wang@intel.com>, 
	Fan Du <fan.du@intel.com>, 
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, Dave Hansen <dave.hansen@intel.com>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, 
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>, "aik@amd.com" <aik@amd.com>, 
	"usama.arif@bytedance.com" <usama.arif@bytedance.com>, "fvdl@google.com" <fvdl@google.com>, 
	"jack@suse.cz" <jack@suse.cz>, "quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>, 
	Kirill Shutemov <kirill.shutemov@intel.com>, "willy@infradead.org" <willy@infradead.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "anup@brainfault.org" <anup@brainfault.org>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "keirf@google.com" <keirf@google.com>, 
	"mic@digikod.net" <mic@digikod.net>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nsaenz@amazon.es" <nsaenz@amazon.es>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	Zhiquan1 Li <zhiquan1.li@intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	Erdem Aktas <erdemaktas@google.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, 
	"david@redhat.com" <david@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hughd@google.com" <hughd@google.com>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, Haibo1 Xu <haibo1.xu@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"rppt@kernel.org" <rppt@kernel.org>, "steven.sistare@oracle.com" <steven.sistare@oracle.com>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, Kai Huang <kai.huang@intel.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, Chao P Peng <chao.p.peng@intel.com>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, Alexander Graf <graf@amazon.com>, 
	"nikunj@amd.com" <nikunj@amd.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"jgowans@amazon.com" <jgowans@amazon.com>, Yilun Xu <yilun.xu@intel.com>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, Ira Weiny <ira.weiny@intel.com>, 
	"richard.weiyang@gmail.com" <richard.weiyang@gmail.com>, 
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>, "qperret@google.com" <qperret@google.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "pgonda@google.com" <pgonda@google.com>, 
	"quic_pderrin@quicinc.com" <quic_pderrin@quicinc.com>, "roypat@amazon.co.uk" <roypat@amazon.co.uk>, 
	"hch@infradead.org" <hch@infradead.org>, "will@kernel.org" <will@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-07-08 at 11:03 -0700, Sean Christopherson wrote:
> > > I think there is interest in de-coupling it?
> >=20
> > No?
>=20
> I'm talking about the intra-host migration/reboot optimization stuff. And=
 not
> doing a good job, sorry.
>=20
> > =C2=A0 Even if we get to a point where multiple distinct VMs can bind t=
o a single
> > guest_memfd, e.g. for inter-VM shared memory, there will still need to =
be a
> > sole
> > owner of the memory.=C2=A0 AFAICT, fully decoupling guest_memfd from a =
VM would add
> > non-trivial complexity for zero practical benefit.
>=20
> I'm talking about moving a gmem fd between different VMs or something usi=
ng
> KVM_LINK_GUEST_MEMFD [0]. Not advocating to try to support it. But trying=
 to
> feel out where the concepts are headed. It kind of allows gmem fds (or ju=
st
> their source memory?) to live beyond a VM lifecycle.

I think the answer is that we want to let guest_memfd live beyond the "stru=
ct kvm"
instance, but not beyond the Virtual Machine.  From a past discussion on th=
is topic[*].

 : No go.  Because again, the inode (physical memory) is coupled to the vir=
tual machine
 : as a thing, not to a "struct kvm".  Or more concretely, the inode is cou=
pled to an
 : ASID or an HKID, and there can be multiple "struct kvm" objects associat=
ed with a
 : single ASID.  And at some point in the future, I suspect we'll have mult=
iple KVM
 : objects per HKID too.
 :=20
 : The current SEV use case is for the migration helper, where two KVM obje=
cts share
 : a single ASID (the "real" VM and the helper).  I suspect TDX will end up=
 with
 : similar behavior where helper "VMs" can use the HKID of the "real" VM.  =
For KVM,
 : that means multiple struct kvm objects being associated with a single HK=
ID.
 :=20
 : To prevent use-after-free, KVM "just" needs to ensure the helper instanc=
es can't
 : outlive the real instance, i.e. can't use the HKID/ASID after the owning=
 virtual
 : machine has been destroyed.
 :=20
 : To put it differently, "struct kvm" is a KVM software construct that _us=
ually_,
 : but not always, is associated 1:1 with a virtual machine.
 :=20
 : And FWIW, stashing the pointer without holding a reference would not be =
a complete
 : solution, because it couldn't guard against KVM reusing a pointer.  E.g.=
 if a
 : struct kvm was unbound and then freed, KVM could reuse the same memory f=
or a new
 : struct kvm, with a different ASID/HKID, and get a false negative on the =
rebinding
 : check.

Exactly what that will look like in code is TBD, but the concept/logic hold=
s up.

[*] https://lore.kernel.org/all/ZOO782YGRY0YMuPu@google.com

> [0] https://lore.kernel.org/all/cover.1747368092.git.afranji@google.com/
> https://lore.kernel.org/kvm/cover.1749672978.git.afranji@google.com/

