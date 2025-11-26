Return-Path: <kvm+bounces-64662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 30553C8A128
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 14:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 70CC34E6727
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 13:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A26328263;
	Wed, 26 Nov 2025 13:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FhsgN7sG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4D3302CA2
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 13:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764164513; cv=none; b=hf3kSW45omTicnfyhdsl1Q3e0S/mEVRy9GLMqoLGDNI1Y4C+bfn3Jitvx96ZCgaWsp7Y6QSkOP/WUss9hu/pETPFQWRc+cylAyRyOQgmnYlViq7uySRFTMsHl2aq6d/19rbehkb54oq8Mgr1UGSiaLUkjwGZe2GTR6Navr89W0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764164513; c=relaxed/simple;
	bh=WgG4G612okA/IrrFfVRuQox4FcXq4MPJFHUChDN4aEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FopKPw2fhZak0fIkRKK7rI6MFwK1qCIkUlCe3QCZlKxQCFaEaqzn6Yw+rNPWOvmJwBHYPKbUaVGlbm5x9D8qpS014foWOBgV7RpyNZaHOWLwyCRNRScLpTPgHTFhfb90lRUU201G7ZsTkgHggDqlNlZfgFYZNEaY2FKkTv7Vybk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FhsgN7sG; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295952a4dd6so10667425ad.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 05:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764164511; x=1764769311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Itoz/CLxpOQAfqPA/mNhaSenu9h0By9pP88eUnqr5LY=;
        b=FhsgN7sGCPlM03fSENMPrOSKZ6PJC4DOABA97MvZp7SW9Q52uwoGPvfoDXQknH2mqc
         AAAASFoXmFf6MrfHFSJxR1aoWaooIDDnHPcrKWW/22zIoBn0+JY0yHSjfFJQarCSXkga
         LG/gyVfgfMPSaoYcV/fYneUZKMeP9Mr5EIMy/oHqwd8BoF4vX8ROLvGH23uHdTihQk00
         CQQ8UymsYhkDytNjnRkDe/QT0W560hcA/rrsAzoRI07vqOZfaj+6VBoFV7u6AXQ5l2wZ
         fOxucXx3EtWFOwyW8wIwV+/z7hmI7AMMQ5W8iqwyVd/uHLURizcKWd1scOD9by5nD9HO
         wonw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764164511; x=1764769311;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Itoz/CLxpOQAfqPA/mNhaSenu9h0By9pP88eUnqr5LY=;
        b=jeYqxMqJV2eSMDyTXB7yeK06a6oN27debEFt8U9cyTgvFWQdFT8X9dApm9yJ0ZNJd9
         8J6H1DkrWucthwn7U21CAKKgGnOkSlAcW2/Cb4BgB43+K1cvqWKR6enwVLFvlSliSwPy
         flJh0Ge0E1rVtwu7hQqfqxbIJ90IC0v8GFRfCmAeHmf4y++awZcd790lz74/kEO0SpYg
         i0pWuLTyXj0abbt0mDKw0p8WHnLKIdRZBngGSKdOwq+mQ/95Z6Uf/AP1KwwWLWksDKmr
         SPBpU8wZrnnF5ySL5HU9CKysJqMsb+PX6yzSooCBlu/qeCWJL5R0FTId3iWmXSQwnG+y
         L3Sg==
X-Gm-Message-State: AOJu0Yx94y9Emc9ISECs9XdmN5q2qfjOcF1sGt7KGh1SFPsS6n7et+HS
	CjgpJzleT/LWntx+jmNLtecWmSQ1Wa+KreTVBCEndMTOJ4O+x9J2lm6k/2bSRTrZb1OaTEH1bSA
	64KYfNw==
X-Google-Smtp-Source: AGHT+IHHwe7R13Fp4/fUKL5PM20qMy00dL2WfXfoZDUWGrFscjdryM+q0yvMC7uapzB6p+IvVGEThta+SXQ=
X-Received: from plps24.prod.google.com ([2002:a17:902:9898:b0:290:b136:4f08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c94d:b0:298:45e5:54a4
 with SMTP id d9443c01a7336-29b6beecc76mr208043215ad.1.1764164511382; Wed, 26
 Nov 2025 05:41:51 -0800 (PST)
Date: Wed, 26 Nov 2025 05:41:48 -0800
In-Reply-To: <CABgObfbU8kXE3xKzYg3HETFw+FURXj3MjXmDnhoL=qA+OLO-CQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com> <20251126014455.788131-7-seanjc@google.com>
 <CABgObfbU8kXE3xKzYg3HETFw+FURXj3MjXmDnhoL=qA+OLO-CQ@mail.gmail.com>
Message-ID: <aScDnAYCtGYXG2S1@google.com>
Subject: Re: [GIT PULL] KVM: x86: SVM changes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025, Paolo Bonzini wrote:
> On Wed, Nov 26, 2025 at 2:45=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > A handful of lowish priority nSVM fixes, AVIC support for 4k vCPUs, and=
 new
> > uAPI to advertise SNP policy bits to userspace.
> >
> > Side topic, this pull request is finally proof that I don't just merge =
my own
> > stuff :-D
>=20
> What do you mean? Is there anything you want me to review?

Oh, it was purely a joke.  I don't have any commits in this particular pull=
 request,
and that caught my eye when looking at the shortlog.

