Return-Path: <kvm+bounces-41532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9DE5A69D59
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 01:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C2707A1D26
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 00:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7821C5485;
	Thu, 20 Mar 2025 00:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="otdrlPxl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558F61A5BA4
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 00:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742431348; cv=none; b=qGrf4afelW8seQQ3DvN2x8TJ6Gdlpq8IXcvMpvuBc/vsSFIAgTikNWxZvtxKLcwo10Ek8fm802rNuHnwMMtX7RVWucheOdSv5elPDDKopFE83O4c6FrmldlVHiPOpzXo7eridymIS921j6mrISO+DfTIj6q4+i91Z5wgSCo8d/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742431348; c=relaxed/simple;
	bh=Ik9SXkU31K0764lyf+Ipyqb2m4yCcr+lHs7BMaemI0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VUpEdaN54vTzsGcnm+4LovsmkBN9I4eCz8vSvA0UKhz6XIE1VPMSOd3cSa7nikKVeXz/93MHhB0wBGdw78qM8eFY21QP49/qvAlkhSp17JkQ/MP27fqQ5nYuh+c1SIOoGv4+C9WqIEd+9Yb7Vyjfv/xsgGqMX8hj4vwQE+jcNXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=otdrlPxl; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2240aad70f2so114005ad.0
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 17:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742431346; x=1743036146; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=68p5xOeHiNmIQH2oMy5E4KrS9x+vnIIIuPqk3H1WCkQ=;
        b=otdrlPxl5YJvb6xps4498g4YfDHKCTMUGnKA/rQixbZTI6puZy4MFPdwOYGmhfWM7I
         LUtZVnREAmRaxwR9jhh4a94uZlsvcTsHFVojQ9WPfftYT4sEMKTRJaapEPMeHr/UGJJH
         OE65m/AwFS3pw/UpSDbCJxqNZRknUQxooTYF2i9Mjsu7iJLpdSXx/JGhY/HPkF5Wqm6U
         2iL8+xLwPlvPMSpe9kZqQRwo3bIgDtDFCSkeg9Gege60Civ2m2fYBUwajKl4rDA3cWWK
         BnYV4UVm7kgtOwUirF09F12zSeVgY5YsERduJQNy0tdTNdcYZOIiYhzN5W6r3NZczRQg
         unnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742431346; x=1743036146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=68p5xOeHiNmIQH2oMy5E4KrS9x+vnIIIuPqk3H1WCkQ=;
        b=d/NfTCr1HfFuHOqXkBtdnnbhQfR8FB9Bzj4X3D1GnKTxaHV7r4u0nX1zw27nbxYmxY
         bcCY1Rr2yYuzklhagWTKE+H94cfZzasSRLk4fjqWHV2X0l38MnK6477uRI3TexmEIL8m
         mCJQOgdajWmv7bNWORwQs0/oF4y1vmi/0Rl/hfh71QSKS1yFzHRpZ0iNR2S3aXBfiIsX
         VppAIqY7TcEMywykdeN5JjV359iRUWKx00i/METJYkUuT4Db6aAtwt3+oC4rjpE8DPKZ
         ZjOtjADe30BV9TC6gvrs1rVtmit5GeTJ3av/vT8CzNkGbQNFso25ALKCcZ8vUzuCqszR
         d9IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMSRCfB8XO1+lac32aMK/kYmyWIS/7lw7ZnaH9zwsHCOSsmlvOIO2UeIEiL7jikm9/d5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfVZXMw1Gde2M2JWtcIn981To17aE77+Fq4WUMDd90qZ/HIers
	N/JUs5amXYvlMiKERTdiZRBS6YpuqpAKldJIXgsai8UIXljVFWOrtwnEAO9dt0fvE2p8be6+7UZ
	610ESk/jjmiN3H+Ni05jH4DpuXKDJMJtrvv6S
X-Gm-Gg: ASbGncv7Wt02K+Q7DVrfV5g5jr0QhSLe+glp3llV5hY8wFGL2GQrON+EQSnYPJY83ID
	ZW5Ro8fI8eI5q+yuQ2eI+RcX4SXw+VpzaDtITc34G5AwQjknOgpygydUjhFgMMhAG8sqJhy6UFX
	ux097OMEYam/LNvSkHvRU8ou2mZU8F+x4zx3yE6AXri8WyUghapOy7RnsD
X-Google-Smtp-Source: AGHT+IHZGZSRKscUg7/fntbxmoB13emA+Y+b4K7Eo8oqNMIfa80VPf96yWAV8ulHx1Okf0K/H5cj+KfA9AHRhl/jYFU=
X-Received: by 2002:a17:903:1b2b:b0:216:21cb:2e06 with SMTP id
 d9443c01a7336-22661fe293dmr822575ad.19.1742431346250; Wed, 19 Mar 2025
 17:42:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250313181629.17764-1-adrian.hunter@intel.com>
In-Reply-To: <20250313181629.17764-1-adrian.hunter@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 19 Mar 2025 17:42:13 -0700
X-Gm-Features: AQ5f1JpTy922TejXSWIEWJSf5djBoN18sk9npopQmaURKGhCDx8Ks-wisEUtLMY
Message-ID: <CAGtprH_ag0RXU4pJKCkcmyjwxRj1pVJN0rm91XTvYnCmDxjKTQ@mail.gmail.com>
Subject: Re: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease
 shutdown time
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025 at 11:17=E2=80=AFAM Adrian Hunter <adrian.hunter@intel=
.com> wrote:
>
> Improve TDX shutdown performance by adding a more efficient shutdown
> operation at the cost of adding separate branches for the TDX MMU
> operations for normal runtime and shutdown.  This more efficient method w=
as
> previously used in earlier versions of the TDX patches, but was removed t=
o
> simplify the initial upstreaming.  This is an RFC, and still needs a prop=
er
> upstream commit log. It is intended to be an eventual follow up to base
> support.
>
> =3D=3D Background =3D=3D
>
> TDX has 2 methods for the host to reclaim guest private memory, depending
> on whether the TD (TDX VM) is in a runnable state or not.  These are
> called, respectively:
>   1. Dynamic Page Removal
>   2. Reclaiming TD Pages in TD_TEARDOWN State
>
> Dynamic Page Removal is much slower.  Reclaiming a 4K page in TD_TEARDOWN
> state can be 5 times faster, although that is just one part of TD shutdow=
n.
>
> =3D=3D Relevant TDX Architecture =3D=3D
>
> Dynamic Page Removal is slow because it has to potentially deal with a
> running TD, and so involves a number of steps:
>         Block further address translation
>         Exit each VCPU
>         Clear Secure EPT entry
>         Flush/write-back/invalidate relevant caches
>
> Reclaiming TD Pages in TD_TEARDOWN State is fast because the shutdown
> procedure (refer tdx_mmu_release_hkid()) has already performed the releva=
nt
> flushing.  For details, see TDX Module Base Spec October 2024 sections:
>
>         7.5.   TD Teardown Sequence
>         5.6.3. TD Keys Reclamation, TLB and Cache Flush
>
> Essentially all that remains then is to take each page away from the
> TDX Module and return it to the kernel.
>
> =3D=3D Problem =3D=3D
>
> Currently, Dynamic Page Removal is being used when the TD is being
> shutdown for the sake of having simpler initial code.
>
> This happens when guest_memfds are closed, refer kvm_gmem_release().
> guest_memfds hold a reference to struct kvm, so that VM destruction canno=
t
> happen until after they are released, refer kvm_gmem_release().
>
> Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
> reclaim time.  For example:
>
>         VCPUs   Size (GB)       Before (secs)   After (secs)
>          4       18              72              24
>         32      107             517             134
>
> Note, the V19 patch set:
>
>         https://lore.kernel.org/all/cover.1708933498.git.isaku.yamahata@i=
ntel.com/
>
> did not have this issue because the HKID was released early, something th=
at
> Sean effectively NAK'ed:
>
>         "No, the right answer is to not release the HKID until the VM is
>         destroyed."
>
>         https://lore.kernel.org/all/ZN+1QHGa6ltpQxZn@google.com/
>
> That was taken on board in the "TDX MMU Part 2" patch set.  Refer
> "Moving of tdx_mmu_release_hkid()" in:
>
>         https://lore.kernel.org/kvm/20240904030751.117579-1-rick.p.edgeco=
mbe@intel.com/
>
> =3D=3D Options =3D=3D
>
>   1. Start TD teardown earlier so that when pages are removed,
>   they can be reclaimed faster.
>   2. Defer page removal until after TD teardown has started.
>   3. A combination of 1 and 2.
>
> Option 1 is problematic because it means putting the TD into a non-runnab=
le
> state while it is potentially still active. Also, as mentioned above, Sea=
n
> effectively NAK'ed it.
>
> Option 2 is possible because the lifetime of guest memory pages is separa=
te
> from guest_memfd (struct kvm_gmem) lifetime.
>
> A reference is taken to pages when they are faulted in, refer
> kvm_gmem_get_pfn().  That reference is not released until the pages are
> removed from the mirror SEPT, refer tdx_unpin().

Note that this logic to pin guest memory pages should go away to
support in-place conversion for huge pages [1], though you can still
pin inodes IIUC.

[1] https://lore.kernel.org/all/CAGtprH8akKUF=3D8+RkX_QMjp35C0bU1zxGi4v1Zm5=
AWCw=3D8V8AQ@mail.gmail.com/

