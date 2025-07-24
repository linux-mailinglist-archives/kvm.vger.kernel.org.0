Return-Path: <kvm+bounces-53382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DDF4B10D67
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 16:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5B3C1CC2399
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 14:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853B02E2679;
	Thu, 24 Jul 2025 14:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wiJMl2xq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B3A2DE714
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 14:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753366922; cv=none; b=tD6QCSb/39YavHS/t630JMVz9vZXLWcj3ZbJmiSxrcvZa7/1LhIoJYcuyrVHfgxTDvwYTWtnDyOzoa3krO3q7Lv9ohFvDn2mAS/UlB8nZ6tloFkitzj5d7LI29wJzp2M58QwRV4RpLhVVZmL4u3U76ca5cbj4MalQn+VEcbELB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753366922; c=relaxed/simple;
	bh=wyfT0lXlWgBZ7J4I+v8/GWC71/ciwzqFrNAvns84tc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mRIz65DcGkiRPqT1cAWqymG1IVTf0rKOTAiUjuv6tQB+4jd0hjZh+6U8d5Q+gQUb/U9dmm/z1oV++5EwXoXl6pZnwTGK08SOMwwdByT52fazudb/keE6diUXq/ZHuES0/KFAHuWAymivpL7E2HtnYcDqZgQhdfZy3Fm//i4zM+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wiJMl2xq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3139c0001b5so987278a91.2
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 07:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753366920; x=1753971720; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JBPgz6dq3fSok+MVJE7cDxS7mjAo8FmDqNF2oBUS74E=;
        b=wiJMl2xqSStfl29twCZX/YM7Mgv+qf993mAKHSaraICIZR3P4L14ehA0TOeiML6mPM
         zUxf2lk8ARJSVdRRQf2hMPGRCR7NHIVXOsu7BqrpHz2dueFt2kDPa+Vk5JAua1p+wqUf
         b5R5sUR4may7f4GAQqXoKEMEwuesjHeBPrakf1+5HbN9Rbix2KdSiA5Lv9mKcWwScFFx
         MTzRtFlvT2ygGNvR1YqA0EFguKJFaH3c9Ij5B1PikN/htsTGR0lS6C/6/BEH+Qx8I+/q
         Embht/P5TjtBePkboNJZhXoi07/GrWxSAlHzoI/PJ/lyykj8iqXau07hbTzap9H1B+cc
         8oOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753366920; x=1753971720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBPgz6dq3fSok+MVJE7cDxS7mjAo8FmDqNF2oBUS74E=;
        b=qn8ngIQcpKug0clHyf4pkYs+V+jb4bYZfRDlaood4pYPx/c/7colkF+d9xDFaOddB2
         RwDGJ/Q6RDrrohvpCOrFA5Atp5ul/qLo3uW0WJnDlwLfsM2Kj5mf5x7wq3zgdy5XnMBn
         Dctfmjt7Yp01ODKpuQxDwGvHnuWakG+l5iLvQCBCVOvMYzgyBQSwvgPWgCcGHnumZcH9
         Az2Vs/0W/gVzZ/nRAiU2AfRYhB96qkvPN1Q5HocLIe+CQPaSzjw7KH8gf+vIP7uttGVa
         3zhcqj7LsIR1h+xM6lohFXKi6JpFYPPfpllevVGYUbQefqTooWXyjy0S6EmOe0CMsr/o
         tLOw==
X-Forwarded-Encrypted: i=1; AJvYcCUYsToC8M7YIlvbKR1egOz8jg7sgRMXcjRRPguOKUwSEPoRDyoDEgOZOke6jI43/zDVxG4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuGZoHK1aAp65ROsqICstLtwevpgm7dB9+djKXyK+oPsmhBBac
	tMpEctRQ3/GYfP03aCtxteLwTe1mBbUVPjUsp/RML9EgW9b/vDRSRIFt4jwpOBLaEEOvOMEtzEM
	OPfyX+A==
X-Google-Smtp-Source: AGHT+IGyr6m6sYxeDVWbtV76V+e10V5EqpQcKsqL6VOEfiaPX5rEUC83p0W/o7l34XMM7fh4CaHbs8GaLBQ=
X-Received: from pjbse6.prod.google.com ([2002:a17:90b:5186:b0:31c:c2a5:9b5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2542:b0:311:c5d9:2c79
 with SMTP id 98e67ed59e1d1-31e507b42a9mr10069378a91.21.1753366920589; Thu, 24
 Jul 2025 07:22:00 -0700 (PDT)
Date: Thu, 24 Jul 2025 07:21:59 -0700
In-Reply-To: <85ikji9c8d.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250716055604.2229864-1-nikunj@amd.com> <2d787a83-8440-adb1-acbd-0a68358e817d@amd.com>
 <aHp9EGExmlq9Kx9T@google.com> <85ikji9c8d.fsf@amd.com>
Message-ID: <aIJBhyUSIQGtBK5v@google.com>
Subject: Re: [PATCH v2] KVM: SEV: Enforce minimum GHCB version requirement for
 SEV-SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	santosh.shukla@amd.com, bp@alien8.de, Michael Roth <michael.roth@amd.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 24, 2025, Nikunj A Dadhania wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > @@ -418,7 +418,18 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
> >         if (data->vmsa_features & ~valid_vmsa_features)
> >                 return -EINVAL;
> >  
> > -       if (data->ghcb_version > GHCB_VERSION_MAX || (!es_active &&
> > data->ghcb_version))
> 
> Any specific reason to get rid of the first check for GHCB_VERSION_MAX ?

Purely a goof on my part, I didn't intend to drop it.

