Return-Path: <kvm+bounces-52495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB24B05B82
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B949560090
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F2B2E2F12;
	Tue, 15 Jul 2025 13:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qPp6ElAc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E460B2E2EE9
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585624; cv=none; b=K91YQp/8b0n4MGIhZoIMbSpNGQeKZUaQ0jLdCtlIyiWvYJpsJyYFOCsnVTqH+MYwWX7YdyvqUwcTGZYiP1pJMO2/cNZce+lBE6dEAksJw+a3T25eGwf2oU2T7BZOPQnoHutjOL5A73EtYY5dbMVWAGi3CJZ4l+GjY5Sirbi+oVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585624; c=relaxed/simple;
	bh=VR+8NUW3mL4ffGA48bjJUkuulhr2EyhWFt/DyW2IpGM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Acx1S/j+0ZEJkNPAxKDKiWUJ2fNlYxa8GhDAcTq+JHp/vslgZItTeLAdC4jWi1I8dxp9R5x0bAe5sDDFT9Yt6+DA0SrZyLsWEE/Esb1uqyRUcELau4CYBb5hLCTrDVRcFHiB5yMRGOmTwcr+hIqO0+XqXwSdcVyA2rlxcnsbdT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qPp6ElAc; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2357c61cda7so123865ad.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 06:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752585622; x=1753190422; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WlCJGXh+DOqyEfoBPhnw3kKyfxuvyf4oF8jquZF4T+0=;
        b=qPp6ElAcn3YZzdeLnh2XO09IHE6zFhv1bXpkiScncmXrWm+oRv0JH+0zgCWQ+t4GHc
         yUAPq2ns1xt+PpVIisxZyLUADFcF6CEoatgpRZXQFT41b/WlCTGvEQrtRicRW7sElm+s
         fqyQWQrpNhOqcWRomiy1Zplct2cJqc4U9SOYha3Gz0F9f30Tg+N9RiXAjjAmwCTLvMAD
         HLinsxohWorTD8+Kj58hHZJFwZaHakvHBFbAlsB7HPzQiUpcdOKilm/K4B1iSRDmHXTl
         /oA2BRVm1mMmFYB3QCXZZH0pkUNLS5hDVKDD94vHzBOlqHb0YFZANKCUZOmzMsPRvKvs
         uyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752585622; x=1753190422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WlCJGXh+DOqyEfoBPhnw3kKyfxuvyf4oF8jquZF4T+0=;
        b=NOcGEiDj7SAv6hmfzgnrexa9EHyAFSGgxHRXOAvNZOhUk/PkeHjKrg2ntqG0WNNpNu
         mDblheQytjmuz0KfZ1k4cLjIxfeg6o2jgH0CoDMK+/oDUCK7uzYX+qoDQx2a6vfUDFqp
         BSERjIfu4LwAFNzuOEva0BK2tYXOtoP0onWvpfjgvzzwsSyoC98ubul6IjrH/G8fpy1+
         Q1IgNcVUJw9n0POq/LDCV5DqBQNuoKTwb15UW5q0P9XUvkDI1cSe2po2+wlDyfpW/54u
         om7Sik9ICqwFMsFSutsUhZXueElULCDCCvjrFpgvQ0grP4Sd2DWMy2w3nmVNHWvbEdjD
         2gTg==
X-Gm-Message-State: AOJu0YzJKUFpSJbs6V9giHbzk5mFDIMzzcHf8lj9MG5KN3xc8i6POGKe
	XYZsQ+l9b7P0GqXvJYRK1IX6cVvr0gFtZmgXZRfyRVmSfMI3YDfd55U2lsZcwXH/lCnPLbEHXu3
	tOxIgKuubDSOz8mEAqeJRAA2UjqkDEGt8kZ+Yo1ze
X-Gm-Gg: ASbGncuDZgSO06Rm1cGwhvaeh5DSFhV89Bp7QLGx8lJ2f5sAIj1SKVFDDLU6FUFpekS
	OQ4BN/JuPeCYyAH85ZyVSc5KDH87VEn3hBBJcOSxG5sfsXSX1xB5xoMj4cesLkMhtqBaMcJz2OW
	gOT3uCKiObnAPw/rsA5/u/SINOkSbqxpPVdVhWG7zA4t+ou6R6RXAWzS6u7zPyGocKvi05bhXc3
	SL7LlwfsUrCFkDY3E83dalsA24g/fzS+/rJTqs=
X-Google-Smtp-Source: AGHT+IFmDnj7+7K2+mnfOTNdR+Aw+YaytnwDDjpn3qAQ9yqrximLoYRf4l3rk/6s3TFG9z/SXMskhFKqUBehgiK3Wys=
X-Received: by 2002:a17:902:e84a:b0:234:c37:85a with SMTP id
 d9443c01a7336-23e1ab85c7amr2901485ad.24.1752585621695; Tue, 15 Jul 2025
 06:20:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613005400.3694904-1-michael.roth@amd.com> <20250613005400.3694904-4-michael.roth@amd.com>
In-Reply-To: <20250613005400.3694904-4-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 15 Jul 2025 06:20:09 -0700
X-Gm-Features: Ac12FXw0-WaLjY8qLo4gIdV3Uj1d2qvRKcayg-mqAaNlcSi7aOXIlvsa9VQBB5w
Message-ID: <CAGtprH9gtG0s9ZCRJXx_EkRzLnBcZdbjQcOYVP_g9PzKcbkVwA@mail.gmail.com>
Subject: Re: [PATCH RFC v1 3/5] KVM: guest_memfd: Call arch invalidation hooks
 when converting to shared
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, tabba@google.com, 
	ackerleytng@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org, 
	pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 5:56=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> When guest_memfd is used for both shared/private memory, converting
> pages to shared may require kvm_arch_gmem_invalidate() to be issued to
> return the pages to an architecturally-defined "shared" state if the
> pages were previously allocated and transitioned to a private state via
> kvm_arch_gmem_prepare().
>
> Handle this by issuing the appropriate kvm_arch_gmem_invalidate() calls
> when converting ranges in the filemap to a shared state.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b77cdccd340e..f27e1f3962bb 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -203,6 +203,28 @@ static int kvm_gmem_shareability_apply(struct inode =
*inode,
>         struct maple_tree *mt;
>
>         mt =3D &kvm_gmem_private(inode)->shareability;
> +
> +       /*
> +        * If a folio has been allocated then it was possibly in a privat=
e
> +        * state prior to conversion. Ensure arch invalidations are issue=
d
> +        * to return the folio to a normal/shared state as defined by the
> +        * architecture before tracking it as shared in gmem.
> +        */
> +       if (m =3D=3D SHAREABILITY_ALL) {
> +               pgoff_t idx;
> +
> +               for (idx =3D work->start; idx < work->start + work->nr_pa=
ges; idx++) {

It is redundant to enter this loop for VM variants that don't need
this loop e.g. for pKVM/TDX. I think KVM can dictate a set of rules
(based on VM type) that guest_memfd will follow for memory management
when it's created, e.g. something like:
1) needs pfn invalidation
2) needs zeroing on shared faults
3) needs zeroing on allocation

> +                       struct folio *folio =3D filemap_lock_folio(inode-=
>i_mapping, idx);
> +
> +                       if (!IS_ERR(folio)) {
> +                               kvm_arch_gmem_invalidate(folio_pfn(folio)=
,
> +                                                        folio_pfn(folio)=
 + folio_nr_pages(folio));
> +                               folio_unlock(folio);
> +                               folio_put(folio);
> +                       }
> +               }
> +       }
> +
>         return kvm_gmem_shareability_store(mt, work->start, work->nr_page=
s, m);
>  }
>
> --
> 2.25.1
>

