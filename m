Return-Path: <kvm+bounces-49812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F2BADE354
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 08:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A8ED3B7BEB
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CA31E0B86;
	Wed, 18 Jun 2025 06:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dCXpX43u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6705415D1
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 06:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750226456; cv=none; b=flJTXMJHbs27oR3GVVNiGDr3T/gnl1tbkCe9WCPavN+moYI4s4StWNs7/2ARIZn+2nkwmpy4Q9vqAW65u1DZkrH/i9wxqTDAlaFbjNg/4Y8o2dT6yvff40Bn8kc1O0kQKjBJNcq6gErBv4ww77v+NPJpZmxLJCjO83JY2x+kb8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750226456; c=relaxed/simple;
	bh=4Zgjd6gnF9v/99etOHsRMTSTYjNQAZRLnd05tXZTvdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LFdjAGR0vmAL6WcCsVUZYfp/CfyZD3kyP977izQrWXbA/saOPflUpNVOXPd9Ztl31662Yf5i5SGmu9mXssC9ppavXbTW9PHL0MtKIGIkT2JLKjirgBsLZJ2SNDNsrmRwK4A7p0xbSNxdRsRi6AtyEGlb5QGUW99Yp1vi+zNeA2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dCXpX43u; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2348ac8e0b4so70005ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 23:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750226454; x=1750831254; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Lwi91r3JxBJupBaG+2UOIImxjmJDsRx7zkdQ0Qkg/s=;
        b=dCXpX43u/TTs5WyCUXG0jFrCv+dP93LaHur5UXUzpdKf2i+uOjxr7K74gQuNv7lf8i
         2XXPwSoZDSYRqjPVWcaLkcO0U7bUQN5+uBVwbLDrNeZo8DbuSJ6qSw3S5TFkbm3Y8s64
         ROqTYn7dUCPZvoBVwMD7VFTSro5IDd6npKT1cm7OR2F5H0JAPrBrGh0DpyTxIKEakva4
         5+7Y7yqQL33O82esz92EPZYk6g8oB2P0phkbng759CtAU883QekgLpZRpgclZwRLmQwa
         dsFDJdDMTMMvvGHXMF/7mpOnxOU79nq66/pX+sYpZiDeFYJfQss8cPLIisOsU3Qqkz4r
         4J6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750226454; x=1750831254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Lwi91r3JxBJupBaG+2UOIImxjmJDsRx7zkdQ0Qkg/s=;
        b=wozZ9yuRJUB/jiyyGzhN14lza5dfJ3wv1rtxPex8GLQsn7kV14DkISqQBdSGYUXiKn
         U2YdzJNm3OvtCDCyBLpa5aZDRJUfOHi55k46afJMXgu38QbMHBUcJfWr7oH0j7rLlxcg
         lMxzIsy4JYGPe7LaWmaZgkuUvRvpaN81zGaZxjOvmZ5hMu84sAOH8u2UE+9YeNmGPjQd
         QgFSW2xacwgGWLCF9nngdggJ5ohDNrH48iJHCpzpqgEKEHaMTWpzUq6Cbbgvczl0lsBS
         0XmA6HKlOJrJF6R53AN8wliQH65VcCcilGSQtUmReWvlvw7SZaFUrOpO1IuWDnXSxcIy
         45WA==
X-Forwarded-Encrypted: i=1; AJvYcCXLez8nw/UiimvFT06J76fm4dLpTFTc9TtNero/X1/eADgS5cHAHW602TvKzYCWIDbvp+I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr9vT1OELiQzm4/CO2owET6rCd0rJ0YUk2qqGjRY9BWmf+SVu2
	cOmYEbgUBE1ZZexEEw3RIsTt2IPzDF1bCU3G0as9D+GROSDyW97qHmNskkv14w6qTHSowbwZ1CG
	fnm8kRRVveuYwwXRhzS13V7bljIHfRTAygnxwTDB/
X-Gm-Gg: ASbGncua2wzzDy+57qiQLrzUmdrZofcUANRqBtSvcxmTKbUW4FCaAGZ1moVmYvkbiMC
	6C1HWyyqSq9Bpntak/jNmSzTxFNEx9EGahBILkEHGW4ML50o6OxP6ErlB1y03Hlj15A3on/5WWb
	PkzN2GIsRVy5BHEWVFfK6yafoy7ZxzJMfF9PfcZxgsiA==
X-Google-Smtp-Source: AGHT+IGd3Cmn404YHuokOrwbSXvVwvjTp57tOUkPzGLs8N+Gdkvo1lOIsdRLB/cl+CQsh3MVqtp3oQixIjk7CTl9D7Q=
X-Received: by 2002:a17:903:19e4:b0:235:e1fa:1fbc with SMTP id
 d9443c01a7336-2366c4c2c44mr12285535ad.0.1750226453922; Tue, 17 Jun 2025
 23:00:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <20250611095158.19398-2-adrian.hunter@intel.com> <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com>
In-Reply-To: <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 17 Jun 2025 23:00:41 -0700
X-Gm-Features: AX0GCFvXti2XDNJCtYz-gj21OeTGM_aopJJEoqDhfHGJIJMSIis82dKBQDZiWy8
Message-ID: <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 10:50=E2=80=AFPM Adrian Hunter <adrian.hunter@intel=
.com> wrote:
> ...
> >>
> >> Changes in V4:
> >>
> >>         Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
> >>         Use KVM_BUG_ON() instead of WARN_ON().
> >>         Correct kvm_trylock_all_vcpus() return value.
> >>
> >> Changes in V3:
> >>
> >>         Remove KVM_BUG_ON() from tdx_mmu_release_hkid() because it wou=
ld
> >>         trigger on the error path from __tdx_td_init()
> >>
> >>         Put cpus_read_lock() handling back into tdx_mmu_release_hkid()
> >>
> >>         Handle KVM_TDX_TERMINATE_VM in the switch statement, i.e. let
> >>         tdx_vm_ioctl() deal with kvm->lock
> >> ....
> >>
> >> +static int tdx_terminate_vm(struct kvm *kvm)
> >> +{
> >> +       if (kvm_trylock_all_vcpus(kvm))
> >> +               return -EBUSY;
> >> +
> >> +       kvm_vm_dead(kvm);
> >
> > With this no more VM ioctls can be issued on this instance. How would
> > userspace VMM clean up the memslots? Is the expectation that
> > guest_memfd and VM fds are closed to actually reclaim the memory?
>
> Yes
>
> >
> > Ability to clean up memslots from userspace without closing
> > VM/guest_memfd handles is useful to keep reusing the same guest_memfds
> > for the next boot iteration of the VM in case of reboot.
>
> TD lifecycle does not include reboot.  In other words, reboot is
> done by shutting down the TD and then starting again with a new TD.
>
> AFAIK it is not currently possible to shut down without closing
> guest_memfds since the guest_memfd holds a reference (users_count)
> to struct kvm, and destruction begins when users_count hits zero.
>

gmem link support[1] allows associating existing guest_memfds with new
VM instances.

Breakdown of the userspace VMM flow:
1) Create a new VM instance before closing guest_memfd files.
2) Link existing guest_memfd files with the new VM instance. -> This
creates new set of files backed by the same inode but associated with
the new VM instance.
3) Close the older guest memfd handles -> results in older VM instance clea=
nup.

[1] https://lore.kernel.org/lkml/cover.1747368092.git.afranji@google.com/#t

