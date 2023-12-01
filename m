Return-Path: <kvm+bounces-3172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0058015CB
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 22:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D96BD1C20AD6
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 21:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414F95AB94;
	Fri,  1 Dec 2023 21:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ssphFiNj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCDCFE
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 13:59:05 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-3b85c88710eso686819b6e.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 13:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701467944; x=1702072744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2RxA+HS2wQkaKFxcob0bYuPWMAKlakET2G+EqYXprig=;
        b=ssphFiNj3kUjFZ5RdiI5b5ajDJCacJ4+oKb2JUO+o1H4mxiRGhBGFRiVDPQtiuodYM
         1OOKvKV25xOFUXgDNyyfrKqiTr8Hjnz7G82iOiaKLASr457kdVz80SmoYnugx7Rbj9S/
         tDlOFQ7d5KdRLWpSHrgtvpxmgQfh+AamyobL0PuTOvx7JxPMGcWWrDKKFpxZrJYD7EtZ
         0HVL5SQDay0C3ASJbzHhGYs0HkOXcnpIlubHcG6kTQTFUq4vKvMWvsHudVagDH12jBcy
         Y5zclcx2GeIKLIGgxotack6TdQNSpTmJOMYmdQEmtGGU/J0Zt6RHIw65x2lKV8ydY30O
         da3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701467944; x=1702072744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2RxA+HS2wQkaKFxcob0bYuPWMAKlakET2G+EqYXprig=;
        b=TcZ3zWM5QsPGqKLWAwvyM8xqivgr47+fNlp2y5VyaFHLewAiN0VrGa+6L02syBkDKj
         SkyCiArEv+bpT4t8PyAo4h5JXLhhT7oJRkawePSENRbTRT1VUaz6HfI5yOyPibjJGMXu
         VjF/qQDX+48qzVaWwlxdkYApo7SsqtPlJxV0hsuevn5Bsj7PHefPfa6KYmCeDqAjlzI7
         VQG5Z6p4zO8tlbD0+VgN9hEFKnvL7xSRj6/Wlg+F8iefYt1a5RlzuXmeLaz4UEeG4N21
         DPYzV6+MOtVNHxS9oON5kvw7rFKh52MRmLZwJ9CNkNvUTKMsj7ASAfF8rL2rWu7CgjGQ
         EADw==
X-Gm-Message-State: AOJu0YykVLPrJmGNx0UDjXZGqEs/A4ONvhSfdXp68xDS1Om1YyctqXGa
	IGcFBjPWeqSgZ9pZ/ic1BnCQ6EjKcT+dRW1voxFC7Q==
X-Google-Smtp-Source: AGHT+IEj7nwBeuP3UV2JxmXeYtqyfrtR0j8wQ8frtf4ojDUje/lEaNCe7MMMiAOnPjRzY3l/W+pnm+fMaZtiPrT+T9U=
X-Received: by 2002:a05:6870:2192:b0:1fb:4a6:31dd with SMTP id
 l18-20020a056870219200b001fb04a631ddmr249494oae.42.1701467944465; Fri, 01 Dec
 2023 13:59:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com> <ZWogUHqoIwiHGehZ@google.com>
 <CAL715WKVHJqpA=VsO3BZhs9bS9AXiy77+k-aMEh+FGOKZREp+g@mail.gmail.com> <f3299f0b-e5c8-9a60-a6e5-87bb5076d56f@amd.com>
In-Reply-To: <f3299f0b-e5c8-9a60-a6e5-87bb5076d56f@amd.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Fri, 1 Dec 2023 13:58:28 -0800
Message-ID: <CAL715WK7zF3=HJf9qkA-pbs1VMMxSw_=2Z-e6e_621HnK-nC8g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] KVM: SEV: Limit cache flush operations in sev
 guest memory reclaim events
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, Jacky Li <jackyli@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ovidiu Panait <ovidiu.panait@windriver.com>, 
	Liam Merwick <liam.merwick@oracle.com>, David Rientjes <rientjes@google.com>, 
	David Kaplan <david.kaplan@amd.com>, Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 1, 2023 at 1:30=E2=80=AFPM Kalra, Ashish <ashish.kalra@amd.com>=
 wrote:
>
> On 12/1/2023 1:02 PM, Mingwei Zhang wrote:
> > On Fri, Dec 1, 2023 at 10:05=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> >>
> >> On Fri, Nov 10, 2023, Jacky Li wrote:
> >>> The cache flush operation in sev guest memory reclaim events was
> >>> originally introduced to prevent security issues due to cache
> >>> incoherence and untrusted VMM. However when this operation gets
> >>> triggered, it causes performance degradation to the whole machine.
> >>>
> >>> This cache flush operation is performed in mmu_notifiers, in particul=
ar,
> >>> in the mmu_notifier_invalidate_range_start() function, unconditionall=
y
> >>> on all guest memory regions. Although the intention was to flush
> >>> cache lines only when guest memory was deallocated, the excessive
> >>> invocations include many other cases where this flush is unnecessary.
> >>>
> >>> This RFC proposes using the mmu notifier event to determine whether a
> >>> cache flush is needed. Specifically, only do the cache flush when the
> >>> address range is unmapped, cleared, released or migrated. A bitmap
> >>> module param is also introduced to provide flexibility when flush is
> >>> needed in more events or no flush is needed depending on the hardware
> >>> platform.
> >>
> >> I'm still not at all convinced that this is worth doing.  We have clea=
r line of
> >> sight to cleanly and optimally handling SNP and beyond.  If there is a=
n actual
> >> use case that wants to run SEV and/or SEV-ES VMs, which can't support =
page
> >> migration, on the same host as traditional VMs, _and_ for some reason =
their
> >> userspace is incapable of providing reasonable NUMA locality, then the=
 owners of
> >> that use case can speak up and provide justification for taking on thi=
s extra
> >> complexity in KVM.
> >
> > Hi Sean,
> >
> > Jacky and I were looking at some cases like mmu_notifier calls
> > triggered by the overloaded reason "MMU_NOTIFY_CLEAR". Even if we turn
> > off page migration etc, splitting PMD may still happen at some point
> > under this reason, and we will never be able to turn it off by
> > tweaking kernel CONFIG options. So, I think this is the line of sight
> > for this series.
> >
> > Handling SNP could be separate, since in SNP we have per-page
> > properties, which allow KVM to know which page to flush individually.
> >
>
> For SNP + gmem, where the HVA ranges covered by the MMU notifiers are
> not acting on encrypted pages, we are ignoring MMU invalidation
> notifiers for SNP guests as part of the SNP host patches being posted
> upstream and instead relying on gmem own invalidation stuff to clean
> them up on a per-folio basis.
>
> Thanks,
> Ashish

oh, I have no question about that. This series only applies to
SEV/SEV-ES type of VMs.

For SNP + guest_memfd, I don't see the implementation details, but I
doubt you can ignore mmu_notifiers if the request does cover some
encrypted memory in error cases or corner cases. Does the SNP enforce
the usage of guest_memfd? How do we prevent exceptional cases? I am
sure you guys already figured out the answers, so I don't plan to dig
deeper until SNP host pages are accepted.

Clearly, for SEV/SEV-ES, there is no such guarantee like guest_memfd.
Applying guest_memfd on SEV/SEV-ES might require changes on SEV API I
suspect, so I think that's equally non-trivial and thus may not be
worth pursuing.

Thanks.
-Mingwei

