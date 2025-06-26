Return-Path: <kvm+bounces-50920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF06CAEAA77
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 01:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6DE44E1B26
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 23:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C082264A3;
	Thu, 26 Jun 2025 23:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gicah5AB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92FA1EE032
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 23:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750979995; cv=none; b=Gq+az1SfwQzhLAglXpGYXo5CCWXvpAGc1tC9mbw6ITucBpbs2b8xat1UdmnaBB2s/SKLz7hzPG9Rqf8qbjLkxA1mXtJMfHmjJkDGjfQCT75GlFMTTFzLdVKedtKN4DK9W7XJDp5g2sFzdUPUzErh1rTHADq/8gzeqWh1IdEJo0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750979995; c=relaxed/simple;
	bh=8oJqu7vh1nKhO7zqxOlFH5GbqzDZRsYHZ4hsK1zb2tg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nsvR+QopHR4WTnSCwjZAv80NxhmPEb1881tF+/INW1778K+JMoJ0NDLvElJCE8CAGj/LP/tUEYBlbshnZkDS+3Yyn0iuVcm3JLLU7nAMcULWT0NjB7IPT8xumXbkjLpjb/mKzu77uWkgnkTLHQHYBsm6ZrGaJUq1P0JnLPM4ltY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gicah5AB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31327b2f8e4so1365113a91.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 16:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750979993; x=1751584793; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VCztHCMZgaWSxSkof1MA9Ntkv2jeWGBUS2MVA37PA/U=;
        b=Gicah5ABAxTBUp0LIHvfnd2EnJsn6GAiMFV9qMQ8h7VY9C8idNZ7c97iypSM9KB+0Q
         zcT7MIrInHLBXIybW9vkngQUWXqu3c+FITNtplx4c3LhtbZ6eO/icT5QxuGVY34EscO3
         OmSnBR39i5loHGDltXbhE6tgBmQi1W66mMdB3oGTlAD/enZ8bIjXLnk1g4QUUF+6ZDIQ
         Do6wkfv8l2iYa5Qk78sK88EpMsxKS6tkC3frxJzcv4QTWT1dvv/H6Abk8NghOyyuLaiE
         4FEs4pfpAYvkMOuO2PpQcPp9QZFfERdDw/rER9HfuLyODrYVhFELJ/HZDOcAK09GfOsI
         KL4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750979993; x=1751584793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VCztHCMZgaWSxSkof1MA9Ntkv2jeWGBUS2MVA37PA/U=;
        b=t6rkZV/UgFU+t3W3ekZkY5QTKZsKUWUEYXbKlfX+c8d57KnGQrZOVpoigrhPHgq566
         PDjAtqDk8kYiCMRmzijeqHGKKPVzkfoe3fg5RnrzmNOD6NiUpy2N5zgH+W45NAZgGPbn
         VWDC4zVaqWtXP9tGRvyYYIVDhlUFoVTaPCaMP6OlDBRnE2+VSsDCFdGcaAwcYorz/4Ao
         4BeCRfAoIwnI4TKR4B/SmXA/HX+kiGcHwQCIr76j5zfBoyiBaOCqzHq7dvztNPhKhKB8
         vU8Ig2hRfKunFFt3q5NtWPfGwDM6LiF+Ik+vatD6vtlGYCjBgzKHozDEpqE7Z/80/pe3
         h0Zg==
X-Gm-Message-State: AOJu0Yx5IB8BdIgJjLp5lMrtxvbvIkS8Gaf3ctd51bh1CN3W7LAfiis0
	zk2KRTWZgx2ILWChh+9nraoJQq1Vzq0TzYIDa/9vTMQmIeZyj/JdJ3lINIjwHBoQXD8AE4O8fGJ
	z1yEmhJpwwBgM5rofJMNI40O3aalqTjNKM2sDhcYdpxD24+ShXUtWqY1OwaPb5Kfku7GcSqnFdf
	RgcXsc3uye4MuTwhjOcxycnoeIRufntVfh2hGV/pIGtcZU3wvNBuqgFyFHV8s=
X-Google-Smtp-Source: AGHT+IFPZByzyXdjiwV8jKmY40Cj3sanVuekYnCn7YFFgb7gotLW0eqU5EvmJr9Dd5Hb/clw6m1dn9YOJk/nOy9NWw==
X-Received: from pjbpv13.prod.google.com ([2002:a17:90b:3c8d:b0:312:1af5:98c9])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5108:b0:313:283e:e881 with SMTP id 98e67ed59e1d1-318c922f2c7mr1105843a91.11.1750979992473;
 Thu, 26 Jun 2025 16:19:52 -0700 (PDT)
Date: Thu, 26 Jun 2025 16:19:51 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
Message-ID: <diqzh602jdk8.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: aik@amd.com, ajones@ventanamicro.com, akpm@linux-foundation.org, 
	amoorthy@google.com, anthony.yznaga@oracle.com, anup@brainfault.org, 
	aou@eecs.berkeley.edu, bfoster@redhat.com, binbin.wu@linux.intel.com, 
	brauner@kernel.org, catalin.marinas@arm.com, chao.p.peng@intel.com, 
	chenhuacai@kernel.org, dave.hansen@intel.com, david@redhat.com, 
	dmatlack@google.com, dwmw@amazon.co.uk, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, graf@amazon.com, haibo1.xu@intel.com, 
	hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> Hello,
>
> This patchset builds upon discussion at LPC 2024 and many guest_memfd
> upstream calls to provide 1G page support for guest_memfd by taking
> pages from HugeTLB.
>
> [...]

At the guest_memfd upstream call today (2025-06-26), we talked about
when to merge folios with respect to conversions.

Just want to call out that in this RFCv2, we managed to get conversions
working with merges happening as soon as possible.

"As soon as possible" means merges happen as long as shareability is all
private (or all meaningless) within an aligned hugepage range. We try to
merge after every conversion request and on truncation. On truncation,
shareability becomes meaningless.

On explicit truncation (e.g. fallocate(PUNCH_HOLE)), truncation can fail
if there are unexpected refcounts (because we can't merge with
unexpected refcounts). Explicit truncation will succeed only if
refcounts are expected, and merge is performed before finally removing
from filemap.

On truncation caused by file close or inode release, guest_memfd may not
hold the last refcount on the folio. Only in this case, we defer merging
to the folio_put() callback, and because the callback can be called from
atomic context, the merge is further deferred to be performed by a
kernel worker.

Deferment of merging is already minimized so that most of the
restructuring is synchronous with some userspace-initiated action
(conversion or explicit truncation). The only deferred merge is when the
file is closed, and in that case there's no way to reject/fail this file
close.

(There are possible optimizations here - Yan suggested [1] checking if
the folio_put() was called from interrupt context - I have not tried
implementing that yet)


I did propose an explicit guest_memfd merge ioctl, but since RFCv2
works, I was thinking to to have the merge ioctl be a separate
optimization/project/patch series if it turns out that merging
as-soon-as-possible is an inefficient strategy, or if some VM use cases
prefer to have an explicit merge ioctl.


During the call, Michael also brought up that SNP adds some constraints
with respect to guest accepting pages/levels.

Could you please expand on that? Suppose for an SNP guest,

1. Guest accepted a page at 2M level
2. Guest converts a 4K sub page to shared
3. guest_memfd requests unmapping of the guest-requested 4K range
   (the rest of the 2M remains mapped into stage 2 page tables)
4. guest_memfd splits the huge page to 4K pages (the 4K is set to
   SHAREABILITY_ALL, the rest of the 2M is still SHAREABILITY_GUEST)

Can the SNP guest continue to use the rest of the 2M page or must it
re-accept all the pages at 4K?

And for the reverse:

1. Guest accepted a 2M range at 4K
2. guest_memfd merges the full 2M range to a single 2M page

Must the SNP guest re-accept at 2M for the guest to continue
functioning, or will the SNP guest continue to work (just with poorer
performance than if the memory was accepted at 2M)?

[1] https://lore.kernel.org/all/aDfT35EsYP%2FByf7Z@yzhao56-desk.sh.intel.com/

