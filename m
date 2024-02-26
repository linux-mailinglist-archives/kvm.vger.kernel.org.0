Return-Path: <kvm+bounces-9775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DBB4866EDA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 082641F26752
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C793879922;
	Mon, 26 Feb 2024 09:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0zJYGejO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEA92137E
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 09:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708938260; cv=none; b=FuntmXjr+tXvw80ApIONFCeDlCwMC/nCz55ESsyp6dimrEHbBcA4iGz1UMiJ7sHGA5ICVxEllEF0wdTo555KurWo/DyxZM9Mriw8/Bk+pgANAz5PEhnBH3j65fOBc/WWAfwW5vfYTieXjS73s1YcIim2kSSSJQfatG9hFgM+dtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708938260; c=relaxed/simple;
	bh=yEZyECskv2rcwMp+c/P2OzQkmGTKaUReF3Ro5PzNU5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cNwItUUMejPGsVAe+agT00ubRIX22d8Ex0OsfmakphBFo6jnFF8VDbLN3cpxwT/j6eyq6cb1X6lfZ2JjraP+/5qIXYJOEfnQAdP2oqx3oJPOarUk/CuVh/jSm9Sd9OqUTGxM8yurFiwTtgRENERLvRplWYKVdVkb10+q7/cBNks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0zJYGejO; arc=none smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-470646192b6so271593137.3
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 01:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708938257; x=1709543057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEZyECskv2rcwMp+c/P2OzQkmGTKaUReF3Ro5PzNU5M=;
        b=0zJYGejOxqWaa1gThVXvzc3nwsI70T/W8Mu8yjMKjIrv4fTOu3U6cPjJ27YH701pY9
         cKa3ueRsKAjKWIO8vGnSEGXj9HsCpoTnpsFepo7Or3YuxOq5bmMbaLWkkksdWNaQy/T9
         LdHyUtLaM6ffh9P41b0SArNVMd3xShmD/tbfOeko9fHtf5sDMmMnJW7E4e7apZTfibrG
         1V4APZDcWUm1QPQO5of7DjvWBMB1uMY+aeGpLkdbNMpfasvwp3MZ0rGiL0PqiOWHwWd6
         yqDU/KMSt/CFHGiQoIodbhL2fiPav4pDTi/Oc/pRWlTl3UbIP6Gw7UufEJXO8LlYVXcR
         abjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708938257; x=1709543057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yEZyECskv2rcwMp+c/P2OzQkmGTKaUReF3Ro5PzNU5M=;
        b=c71jy38h6GevgK9jjRxOC7xLQoHPYU5+HLr4+UI4e/I3dW79vPdaQhw4byYDPRBPJd
         jNxvOpE/56D+9AOyoj5lh1eGVAozINfV1H0GVudnsTVQUAhp+tlraf4IG3DY1B54VJcj
         S15JUcpEP53aASgPWq6WXjky+kYcWGO9w/vJodlNyjQ5rnB+39C61CyIoA8QkqrSTSyq
         pa8sAXnYc91mraff69b2AAsYUvxiNny8EDHLSzAyfo51xiZEdhleIlaAiitNrrumOmI0
         sPRwk3p0DiN7YT/Z3SgHs/UcZ2Gp6/BLqxnqEjPG1FDXlooc+AxpyNDXkn8CUaUY/Rmb
         R2Jg==
X-Forwarded-Encrypted: i=1; AJvYcCXW9B4v/5cgaPcGFSDBGCiKqVPGuylGyqq7+DXfiq6zN2iOOr7ifwSDfAKGNHeN3I0oSZvBiMILcY9C8brfyaUOFQF2
X-Gm-Message-State: AOJu0YwpJ6KfVL+GfeIRSOQoZKO/BqheOYfLubg2kdDl7LtPOPu9gqWs
	HMxS14IVSWnmQOnvVR0N+nw6sqix+ppvruQODHnCv1aj9qEnIvSwflrfYkaergwxFq0AjourHv0
	GaKOuF3gMlVKDV945cgnT71nfPHR8FTqGEsSN
X-Google-Smtp-Source: AGHT+IGEsNplZutJPQCE2XWM33H2//sA0tBNvMZ/8xQCoXrQdHcbFYE1YTM2S71oQAfgwcpsit9Bxd7++DH7yVsIWtY=
X-Received: by 2002:a67:ad02:0:b0:470:3adf:3ce2 with SMTP id
 t2-20020a67ad02000000b004703adf3ce2mr4465713vsl.10.1708938257027; Mon, 26 Feb
 2024 01:04:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
In-Reply-To: <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Feb 2024 09:03:40 +0000
Message-ID: <CA+EHjTwOx930n7Ja6yXZKCmVJ1t_tcccgGpA36o4JigYKEcVAQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Elliot,

On Thu, Feb 22, 2024 at 11:44=E2=80=AFPM Elliot Berman <quic_eberman@quicin=
c.com> wrote:
>
> On Thu, Feb 22, 2024 at 04:10:21PM +0000, Fuad Tabba wrote:
> > This series adds restricted mmap() support to guest_memfd [1], as
> > well as support guest_memfd on pKVM/arm64.
> >
> > We haven't started using this in Android yet, but we aim to move
> > away from anonymous memory to guest_memfd once we have the
> > necessary support merged upstream. Others (e.g., Gunyah [8]) are
> > also looking into guest_memfd for similar reasons as us.
>
> I'm especially interested to see if we can factor out much of the common
> implementation bits between KVM and Gunyah. In principle, we're doing
> same thing: the difference is the exact mechanics to interact with the
> hypervisor which (I think) could be easily extracted into an ops
> structure.

I agree. We should share and reuse as much code as possible. I'll sync
with you before the V2 of this series.

> [...]
>
> > In addition to general feedback, we would like feedback on how we
> > handle mmap() and faulting-in guest pages at the host (KVM: Add
> > restricted support for mapping guest_memfd by the host).
> >
> > We don't enforce the invariant that only memory shared with the
> > host can be mapped by the host userspace in
> > file_operations::mmap(), but in vm_operations_struct:fault(). On
> > vm_operations_struct::fault(), we check whether the page is
> > shared with the host. If not, we deliver a SIGBUS to the current
> > task. The reason for enforcing this at fault() is that mmap()
> > does not elevate the pagecount(); it's the faulting in of the
> > page which does. Even if we were to check at mmap() whether an
> > address can be mapped, we would still need to check again on
> > fault(), since between mmap() and fault() the status of the page
> > can change.
> >
> > This creates the situation where access to successfully mmap()'d
> > memory might SIGBUS at page fault. There is precedence for
> > similar behavior in the kernel I believe, with MADV_HWPOISON and
> > the hugetlbfs cgroups controller, which could SIGBUS at page
> > fault time depending on the accounting limit.
>
> I added a test: folio_mmapped() [1] which checks if there's a vma
> covering the corresponding offset into the guest_memfd. I use this
> test before trying to make page private to guest and I've been able to
> ensure that userspace can't even mmap() private guest memory. If I try
> to make memory private, I can test that it's not mmapped and not allow
> memory to become private. In my testing so far, this is enough to
> prevent SIGBUS from happening.
>
> This test probably should be moved outside Gunyah specific code, and was
> looking for maintainer to suggest the right home for it :)
>
> [1]: https://lore.kernel.org/all/20240222-gunyah-v17-20-1e9da6763d38@quic=
inc.com/

Let's see what the mm-folks think about this [*].

Thanks!
/fuad

[*] https://lore.kernel.org/all/ZdfoR3nCEP3HTtm1@casper.infradead.org/


> >
> > Another pKVM specific aspect we would like feedback on, is how to
> > handle memory mapped by the host being unshared by a guest. The
> > approach we've taken is that on an unshare call from the guest,
> > the host userspace is notified that the memory has been unshared,
> > in order to allow it to unmap it and mark it as PRIVATE as
> > acknowledgment. If the host does not unmap the memory, the
> > unshare call issued by the guest fails, which the guest is
> > informed about on return.
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/all/20231105163040.14904-1-pbonzini@redhat.=
com/
> >
> > [2] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstrea=
m/pkvm-core
> >
> > [3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guest=
mem-6.8-rfc-v1
> >
> > [4] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/gue=
stmem-6.8
> >
> > [5] Protected KVM on arm64 (slides)
> > https://static.sched.com/hosted_files/kvmforum2022/88/KVM%20forum%20202=
2%20-%20pKVM%20deep%20dive.pdf
> >
> > [6] Protected KVM on arm64 (video)
> > https://www.youtube.com/watch?v=3D9npebeVFbFw
> >
> > [7] Supporting guest private memory in Protected KVM on Android (presen=
tation)
> > https://lpc.events/event/17/contributions/1487/
> >
> > [8] Drivers for Gunyah (patch series)
> > https://lore.kernel.org/all/20240109-gunyah-v16-0-634904bf4ce9@quicinc.=
com/
>
> As of 5 min ago when I send this, there's a v17:
> https://lore.kernel.org/all/20240222-gunyah-v17-0-1e9da6763d38@quicinc.co=
m/
>
> Thanks,
> Elliot
>

