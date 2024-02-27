Return-Path: <kvm+bounces-10040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF1CC868C65
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:38:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A7CA1F219AC
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE69136993;
	Tue, 27 Feb 2024 09:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SIlVNR8D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5503E135A75
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 09:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709026705; cv=none; b=AXQxK15lCK7D8XDAJhHRngq234B1/22+6Bb/n3SEw5so3H10oF8fzuwTvaquHXDtOycQExM1B0sUyDEntzGFo3ov6Eka7aUNISx6rZ9ymLc0lsWTGBGqZcoFUfVF4c1pzNLwhoKZK62blNsw3JuOyinakeCk8k4ExpUZapc8JVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709026705; c=relaxed/simple;
	bh=lITNheftSYMR04YfLtv3K2IE6PAf+peApENOiHb/BYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lVvQ5iXW6LLNO90UFw00z4QBJhKvT3jVDzhPz55mc8nyC0Fn7uxQkr8wdiy+r4x51LAc26Tb+/pZRdGQ/N7Ao/hQ3EX5ZrxaQg2uJaF8mW85AcgsQDEPze8U0jn2cZIU/Nnx3vy67Ga33DvAakiLZipTUYPQ87/447PPV4+MW00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SIlVNR8D; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-47051c7635dso630219137.1
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 01:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709026702; x=1709631502; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lITNheftSYMR04YfLtv3K2IE6PAf+peApENOiHb/BYE=;
        b=SIlVNR8DBOq/cb1yv1OP8OSqzxIk3+XhkCqnMummpIfwTxMGjdWP1nuygQWM1nAes+
         TLQnXSy9vCuMakfZ9EnlcHAMkUMuryWuAGZbXfqEJ6blkcsVmuKn0zYSm0jmVAp75VlL
         9OYcPBlZ1SJbaMGjH0SVGq+9krKXC8weFx9X45oy+324YEMOlPdaqXRE9FpF6Fd2Opkb
         DiJR8UPLyo8VC6FJTUSchFUTuYfCYApaLaHr37oIUlwL8h4pI318U5ZXLGMQdN4ewecg
         Vv023kcZy5MeDIeHkgs/JnM6baeHdNVQpTWLiAaMwVgB7Bdt6ymNHxnB03DAYoWn4xVM
         VLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709026702; x=1709631502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lITNheftSYMR04YfLtv3K2IE6PAf+peApENOiHb/BYE=;
        b=JQ+7vPkLqd9f4ExyrRoPxrVXWavMiPzHkLt+yPHsK0aO6ub9BGib+eVsdCh0JlPOmG
         zypWNgKEC3RZI1630izU2Sn6gZyFmLZw7dhW5a2IMTEEf8LKuXOKWAwkbJ3ygs8ARRWv
         COWfSJ9kvyvggjudJUiBi3Y9k4OrX4kBgCjlb3jPaiPG//ax3oblCKS7bWNPZuc1Q8Qo
         +gw/yv5v8+KUhPbXv5jXiLhOBq3UhD/Ei1en8MWNF4eK0eUpPij8QZlXb98FvoIjq52H
         YBEwvmF93D/84LLq/iQbzJ9B51As7IqWbTtDWgMUzkxu9WVpCEgFjTjAWTB7ulpFhRfG
         UyQQ==
X-Gm-Message-State: AOJu0YyohJSQdHhBMvyFTTddRwLawgUT/NThk+wJNOWvTn2VS88N5QNF
	vmQbAflgYn9l2ywBbIQ11QDldFsENcnkfrxBQAA++/veYsgmNso87/CKOmLpsdDYUJ7snBGxzOG
	/X/asJvXoJ/g+Gll0nrsIs2htTujfKmaNb4la
X-Google-Smtp-Source: AGHT+IGtUSpwVCXklISxbQaZarJMI7q14JSgkprPOp6y3p4Ot6amI6BiQXX96hlj61rZiLNkfUPjDqMpwEnxXQpNCPo=
X-Received: by 2002:a67:ed57:0:b0:471:e15d:71bf with SMTP id
 m23-20020a67ed57000000b00471e15d71bfmr4819795vsp.30.1709026702061; Tue, 27
 Feb 2024 01:38:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <9e983090-f336-43b9-8f2b-5dabe7e73b72@redhat.com>
In-Reply-To: <9e983090-f336-43b9-8f2b-5dabe7e73b72@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Feb 2024 09:37:44 +0000
Message-ID: <CA+EHjTyGDv0z=X_EN5NAv3ZuqHkPw0rPtGmxjmkc21JqZ+oJLw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Mon, Feb 26, 2024 at 9:47=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 22.02.24 17:10, Fuad Tabba wrote:
> > This series adds restricted mmap() support to guest_memfd [1], as
> > well as support guest_memfd on pKVM/arm64.
> >
> > This series is based on Linux 6.8-rc4 + our pKVM core series [2].
> > The KVM core patches apply to Linux 6.8-rc4 (patches 1-6), but
> > the remainder (patches 7-26) require the pKVM core series. A git
> > repo with this series applied can be found here [3]. We have a
> > (WIP) kvmtool port capable of running the code in this series
> > [4]. For a technical deep dive into pKVM, please refer to Quentin
> > Perret's KVM Forum Presentation [5, 6].
> >
> > I've covered some of the issues presented here in my LPC 2023
> > presentation [7].
> >
> > We haven't started using this in Android yet, but we aim to move
> > away from anonymous memory to guest_memfd once we have the
> > necessary support merged upstream. Others (e.g., Gunyah [8]) are
> > also looking into guest_memfd for similar reasons as us.
> >
> > By design, guest_memfd cannot be mapped, read, or written by the
> > host userspace. In pKVM, memory shared between a protected guest
> > and the host is shared in-place, unlike the other confidential
> > computing solutions that guest_memfd was originally envisaged for
> > (e.g, TDX).
>
> Can you elaborate (or point to a summary) why pKVM has to be special
> here? Why can't you use guest_memfd only for private memory and another
> (ordinary) memfd for shared memory, like the other confidential
> computing technologies are planning to?

Because the same memory location can switch back and forth between
being shared and private in-place. The host/vmm doesn't know
beforehand which parts of the guest's private memory might be shared
with it later, therefore, it cannot use guest_memfd() for the private
memory and anonymous memory for the shared memory without resorting to
copying. Even if it did know beforehand, it wouldn't help much since
that memory can change back to being private later on. Other
confidential computing proposals like TDX and Arm CCA don't share in
place, and need to copy shared data between private and shared memory.

If you're interested, there was also a more detailed discussion about
this in an earlier guest_memfd() thread [1]

> What's the main reason for that decision and can it be avoided?
> (s390x also shares in-place, but doesn't need any special-casing like
> guest_memfd provides)

In our current implementation of pKVM, we use anonymous memory with a
long-term gup, and the host ends up with valid mappings. This isn't
just a problem for pKVM, but also for TDX and Gunyah [2, 3]. In TDX,
accessing guest private memory can be fatal to the host and the system
as a whole since it could result in a machine check. In arm64 it's not
necessarily fatal to the system as a whole if a userspace process were
to attempt the access. However, a userspace process could trick the
host kernel to try to access the protected guest memory, e.g., by
having a process A strace a malicious process B which passes protected
guest memory as argument to a syscall.

What makes pKVM and Gunyah special is that both can easily share
memory (and its contents) in place, since it's not encrypted, and
convert memory locations between shared/unshared. I'm not familiar
with how s390x handles sharing in place, or how it handles memory
donated to the guest. I assume it's by donating anonymous memory. I
would be also interested to know how it handles and recovers from
similar situations, i.e., host (userspace or kernel) trying to access
guest protected memory.

Thank you,
/fuad

[1] https://lore.kernel.org/all/YkcTTY4YjQs5BRhE@google.com/

[2] https://lore.kernel.org/all/20231105163040.14904-1-pbonzini@redhat.com/

[3] https://lore.kernel.org/all/20240222-gunyah-v17-0-1e9da6763d38@quicinc.=
com/



>
> --
> Cheers,
>
> David / dhildenb
>

