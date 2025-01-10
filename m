Return-Path: <kvm+bounces-35067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BAE4A0989D
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 18:35:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78A72188F003
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 17:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91872139A8;
	Fri, 10 Jan 2025 17:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2x2+Kw+R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9342063EE
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736530493; cv=none; b=MQbu6Ke6dViWH5O6o4vKod6jdc/gEEPhpBGDA9Z5egd8WC+mb22AlCz0ZnMBI8bu8frLdIIS/AF281wJ59+f7FPLE6hCJJH87PYc/YueQOPR7L4fLOyabmFeRNV+Jwfyibfc/I3w9Sx0TTuXdz4r+HLw3KSdr4snD17Ttnt+MKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736530493; c=relaxed/simple;
	bh=gBgeldrCdE4O+TRsJ8MRyDwkdKmD35QutZSJ1c8kWt8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cn9Lm5NK1tnCeV0e3CUYYOtMiKl41iO9f7RCPmpam9WH8U3eYNapO2bbXpMzhMmM/EhZuEWE3VipuhuhkL29PrduKSxFYMc8Tq87gbfdx7ffkC2nAQnIwofaA/EszSe4WVyaskPwHXj/xCnQb58CzXWiBoLJ9/RHZ2vre85Xq64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2x2+Kw+R; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9b9981f1so5936387a91.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 09:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736530491; x=1737135291; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T9dqD1Tf/mv4q3uRP2fdcj/6wZOso3xcQHQ5+9ZZMrI=;
        b=2x2+Kw+RLlAxvSrcyFQWS+N5y3vjfjv7Dn6Mun9gAyStM4u5qMKxy+hObzD8Rwa86C
         GUKikpN5JyrZd5KTuYvaqWndsmuGN2wCkH+9LHsKPluQavTFTaP/8KvXTUofkX7sjnxm
         18sdmkInYwoaOV6rx45N3ewFiCU2q+55/XxPvaUo+xIp8+qdniuGNr6vBe69re1BYDfG
         QgVCqnSg2B94orXNcLbaJVrZovMwFUQbtpu+EQSxVeUkrjob5WIbUbehTLQvFIaEPcdf
         Ii8xblNPRgFRN5Jyw1rirb7/IqEFwTPKb2TBZo+Cg/m9kAcEI3i6AvuJkVke59zBz4qN
         9kHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736530491; x=1737135291;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T9dqD1Tf/mv4q3uRP2fdcj/6wZOso3xcQHQ5+9ZZMrI=;
        b=hqlArfFT0FVGXNdjngapwIMbCdlsQEiGqYUSc4N98GyGVkx8u03iZzicX30bUliTmC
         JOAMfYT5Y1CvGvL86bF2Y4yjRd0TaPXj+3zfRhNMMHuzT6mPxQ3YJTnTBqyYV6G0KUvT
         VOEBWP9G+PtIF60wuFXMfeK9NIZ1PykJn0gZmQ4ogcvKQcTjjnabnShZmC/8Sx0eVOB8
         VNdSLMgy9QoJF++s5tblKf/Dw3gz9Y2pdQeZytAukwlj5xxIe5Xp0HnWF7yJeQHDv+ra
         S/nG8y2aP0nauEUXdLnAor9Jeg/VRn10DfIE1e2mei6U6kS2uTRY093F+9x3tNoroSX5
         ovvg==
X-Forwarded-Encrypted: i=1; AJvYcCU7dWnUTau6RVh5++GzEV1AO4fobeGVqdH/z40DiHrA2nhNudl9McZ4iIBF38Dnrz8liAg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6Z1852CNS8RN8xRXSoWJ9NQ1QCjPuCnUIeB4RORlH0z1mLGDE
	rUxZPEuhtJxCmKeiXynFEBN7ZSMwLdldkGlOMMMcaSYO7ZAubRRcvoVSJvTdKNN2X+QrQG5vo92
	8pA==
X-Google-Smtp-Source: AGHT+IEMsVSMFQBUuy7cS575/2jhvZisiUb/qh678baB0qvndAffYz81YNLBEOaAxM3dwoH0W44L9lAh0Ss=
X-Received: from pjbdj16.prod.google.com ([2002:a17:90a:d2d0:b0:2ee:4826:cae3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e10:b0:2ee:7233:4e8c
 with SMTP id 98e67ed59e1d1-2f548f102c6mr17510631a91.8.1736530490838; Fri, 10
 Jan 2025 09:34:50 -0800 (PST)
Date: Fri, 10 Jan 2025 09:34:49 -0800
In-Reply-To: <20250110180225.06dfba3c@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
 <20250108181451.74383-3-imbrenda@linux.ibm.com> <12a4155f-9d09-4af9-8556-ba32f7f639e6@de.ibm.com>
 <20250110124705.74db01be@p-imbrenda> <Z4FJNJ3UND8LSJZz@google.com> <20250110180225.06dfba3c@p-imbrenda>
Message-ID: <Z4FaOW3-hen3nIpF@google.com>
Subject: Re: [PATCH v1 02/13] KVM: s390: fake memslots for ucontrol VMs
From: Sean Christopherson <seanjc@google.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org, 
	frankja@linux.ibm.com, schlameuss@linux.ibm.com, david@redhat.com, 
	willy@infradead.org, hca@linux.ibm.com, svens@linux.ibm.com, 
	agordeev@linux.ibm.com, gor@linux.ibm.com, nrb@linux.ibm.com, 
	nsg@linux.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 10, 2025, Claudio Imbrenda wrote:
> On Fri, 10 Jan 2025 08:22:12 -0800
> Sean Christopherson <seanjc@google.com> wrote:
> > AFAIK, that limitation exists purely because of dirty bitmaps.  IIUC, these "fake"
> > memslots are not intended to be visible to userspace, or at the very least don't
> > *need* to be visible to userspace.
> > 
> > Assuming that's true, they/it can/should be KVM-internal memslots, and those
> > should never be dirty-logged.  x86 allocates metadata based on slot size, so in
> > practice creating a mega-slot will never succeed on x86, but the only size
> > limitation I see in s390 is on arch.mem_limit, but for ucontrol that's set to -1ull,
> > i.e. is a non-issue.
> > 
> > I have a series (that I need to refresh) to provide a dedicated API for creating
> > internal memslots, and to also enforce that flags == 0 for internal memslots,
> > i.e. to enforce that dirty logging is never enabled (see Link below).  With that
> > I mind, I can't think of any reason to disallow a 0 => TASK_SIZE memslot so long
> > as it's KVM-defined.
> > 
> > Using a single memslot would hopefully allow s390 to unconditionally carve out a
> > KVM-internal memslot, i.e. not have to condition the logic on the type of VM.  E.g.
> 
> yes, I would love that
> 
> the reason why I did not use internal memslots is that I would have
> potentially needed *all* the memslots for ucontrol, and instead of
> reserving, say, half of all memslots, I decided to have them
> user-visible, which is hack I honestly don't like.
> 
> do you think you can refresh the series before the upcoming merge
> window?

Ya, I'll refresh it today, and then I can apply it early next week and provide
an immutable topic branch/tag.

My thought is to have you carry the below in the s390 series though, as I don't
have a way to properly test it, and I'd prefer to avoid having to do a revert on
the off chance removing the limit doesn't work for ucontrol.

