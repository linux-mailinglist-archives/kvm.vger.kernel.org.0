Return-Path: <kvm+bounces-17530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0DE58C76CD
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 14:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CB361F22705
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 12:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7140614601C;
	Thu, 16 May 2024 12:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KOVfJZXx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F276E335B5
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 12:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715863559; cv=none; b=BFrHEMcLchaMa0kjXZFPV0yWpts/5zRGa9Sotw0wvmGY4lG54M+boAO5kgyzxC9dqA+InEK2XyOC3qd3yP5r8RwkVBJS7BERXR84ONyV4cCNP5ccGDFdYIxbx0kFyvdIQDfVKR3irFtflEVmGMXOVv4EXUvyAscPbYTrcNkgkF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715863559; c=relaxed/simple;
	bh=xHfa5u2tqq62Z2Yqj7BohljmTIio2h6h+05EN60Voxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f/SE0Geiyeeu5L9URVR/Irls2m6D2VicUJRcUm1KeU/xAks513yRhyCtxJQRpVlwa3gfg3KQPQx4DJOcu5sZcGu1wkr20TqcjHGREdIxbsigHjbeZW3BmSr5cQv6LR8ghEWdfrizly3KCnsfo0o0r0vMhBckcBRxvCKczyN7OLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KOVfJZXx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715863556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7dG6Z+45v2q5x1q/1fMWlQrJ5gyYce9+KheVF6sIr+g=;
	b=KOVfJZXxq01irZmjRggLq7Qy/smZN8m1X+cY0smd5gbLLQnyeTKE29349tvTzO2YQ2ybil
	u36m/xPBLHR6yJ7n4vq6Ni91k2YaxdGGHpEG11MTu12D2+PkMKToFEJPj4XQwefW54/dQe
	4gJWaV4UpcsrLT/GNtKixvoAdpSHjMc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-x5QXSU0IORKrm5x1nLd0Qw-1; Thu, 16 May 2024 08:45:55 -0400
X-MC-Unique: x5QXSU0IORKrm5x1nLd0Qw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-34dd570f48cso4393914f8f.3
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 05:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715863554; x=1716468354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7dG6Z+45v2q5x1q/1fMWlQrJ5gyYce9+KheVF6sIr+g=;
        b=YpjXWFyIhhx2ReWFPkenx5Y2RMA7GOj28720xZmiiBrZcWsIBrNcBCff+imkReSXNX
         zsbuoT0sv+3+Mg1F2Oi2+X0ExBS3TouqD8okWnEWatQCpNAz82Z09fz0UskohTb+iGxK
         DPal7sqXrYKCZHK9ob0eN84Ih/FWcqQY2+BV2BVIQR0BpqjRFJVUHTx6O+53+GvahD2Z
         o3+uaB79DofT+2DnxGylrMtNoy2h2YBa/DwUFZIQiXLqt46b4ZfTkFLvKXBa9tLSnyd1
         8nqEOsKnwyN8jUgdFdPj00M5FWTF6rCoyoW6OubNxT8vX0bHF4cCz+zObXAZXfGIDYmX
         q7Wg==
X-Forwarded-Encrypted: i=1; AJvYcCW6eUdbHu+wi3yJ2VvJGhEfVMd7HvDJE3ywgylSwO5La1Ck3zznHA848EHbPr1NfZvC+swBnvfPOuWTUpviVG6O1pc5
X-Gm-Message-State: AOJu0Yy8WJ2XDg2HU4C3F/83DR+J6u4YW8GauLvfihx6dnxNxx09Jqtw
	EgXzB+K736qGENj47AmPYLiSHp+k+elXcFk34x+jnhJndqiY71jVBE1juca9y5krBqb/VNKURyQ
	SyQNACuAswOz6eSt+0/oWVSL5Nbs65Vhgg7pBGRwHX9wQKKE+9ruBW0OMfBoGR9qYYsWxEdxgoC
	qvO+eDOYh+7arxB7+mNrA2GwpW
X-Received: by 2002:a5d:550b:0:b0:34a:9afe:76f with SMTP id ffacd0b85a97d-3504a73749cmr14015564f8f.30.1715863554126;
        Thu, 16 May 2024 05:45:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQ2EdeulUpFW4L96VwQkufH/EGbNBZaA8+A6kpKigJT6nq88J8jsTsHca1puBuLIbcAMkH5jX3IOPWEwU8ztQ=
X-Received: by 2002:a5d:550b:0:b0:34a:9afe:76f with SMTP id
 ffacd0b85a97d-3504a73749cmr14015549f8f.30.1715863553739; Thu, 16 May 2024
 05:45:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240510211024.556136-1-michael.roth@amd.com> <20240510211024.556136-14-michael.roth@amd.com>
 <ZkU3_y0UoPk5yAeK@google.com>
In-Reply-To: <ZkU3_y0UoPk5yAeK@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 16 May 2024 14:45:41 +0200
Message-ID: <CABgObfZXvq8_j+tm8zJ_F=5XAD22rky1JtdUSzV+VgpOXqOn-g@mail.gmail.com>
Subject: Re: [PULL 13/19] KVM: SEV: Implement gmem hook for invalidating
 private pages
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 12:32=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> > +void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
> > +{
> > +     kvm_pfn_t pfn;
> > +
> > +     pr_debug("%s: PFN start 0x%llx PFN end 0x%llx\n", __func__, start=
, end);
> > +
> > +     for (pfn =3D start; pfn < end;) {
> > +             bool use_2m_update =3D false;
> > +             int rc, rmp_level;
> > +             bool assigned;
> > +
> > +             rc =3D snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> > +             if (WARN_ONCE(rc, "SEV: Failed to retrieve RMP entry for =
PFN 0x%llx error %d\n",
> > +                           pfn, rc))
> > +                     goto next_pfn;
>
> This is comically trivial to hit, as it fires when running guest_memfd_te=
st on a
> !SNP host.  Presumably the correct fix is to simply do nothing for !sev_s=
np_guest(),
> but that's easier said than done due to the lack of a @kvm in .gmem_inval=
idate().
>
> That too is not a big fix, but that's beside the point.  IMO, the fact th=
at I'm
> the first person to (completely inadvertantly) hit this rather basic bug =
is a
> good hint that we should wait until 6.11 to merge SNP support.

Of course there is an explanation - I usually run all the tests before
pushing anything to kvm/next, here I did not do it because 1) I was
busy with the merge window and 2) I wanted to give exposure to the
code in linux-next, which was the right call indeed but it's beside
the point. Between the clang issue and this one, it's clear that even
though the implementation is 99.99% okay (especially considering the
size), there are a few kinks to fix.

I'll fix everything up and re-push to kvm/next, but I agree that we
shouldn't rush it any further. What really matters is that development
on userspace can proceed.

This also confirms that it's important to replace kvm/next with
kvm/queue in linux-next, since linux-next doesn't care that much about
branches that rebase.

Paolo


