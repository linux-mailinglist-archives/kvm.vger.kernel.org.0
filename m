Return-Path: <kvm+bounces-24056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E8E4950BF4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 20:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDA2D1F23FC5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11271A38DC;
	Tue, 13 Aug 2024 18:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="euWawftz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C0D199246
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723572424; cv=none; b=ZrBtvZqFZjV/dryNYNS7clWTNfQqz1xQYP/EJL6lSySl9ay0/6p82A8TwYGxCgRAb4aQ65GNuuTfG9dVwj8YYldlZoA8Xfk8HVBzrsWI2DQTuSb8WIFpptGJ3TJ+rxIDGlI0dz1f7vb3BbzwYndz1J1A1Wqqj5FS1/+cRvJgvJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723572424; c=relaxed/simple;
	bh=sOfus6+/DqZAdQFB9OtvKFQMXpAt1JX07Ha9uWIUGJs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pJXZ/5YNtEtQoYUqlNCUygKk8UkVUnOxV4o9xQSXkdCUCfKlikIvB8k0dAEjOKmMvmfgl+jkhQopLGYMzu2xHs1JM+wNlzXcTwlPUFjhsrTpviMuJn+z1mMjV3zs08cGhEf5qXj77kLfK7mUUGdCUyDWh5WTZ96CX0e/aY5p3OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=euWawftz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ff3dfaa090so43564345ad.3
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 11:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723572423; x=1724177223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6N2j6hj9Xt1/uQL+7yLQtfz3MlJVXjDshFxiGVCkNtI=;
        b=euWawftz7ZBNFJaKD+Ka4S/4b2FEwBHhYEvBs0rok7K7KJDTGod6Yn09uQWqdVzNDL
         u7teb0Yt7/106HY5KYCr+OJwR3FWE+mX/oAPpqtDIc3YAwvUsuBJApoCMxFNHoRiWhEa
         wf/F0TshI8slbYXmqlYjKmaMyZbJKWwLBAQDncUK+N0PtmVH4GR9B2wYg1m6NCBOJ5Fr
         Sbbn24nz3HsMad7DWXoQmZklALSTcbfZmVUpORMXW9y5IMyngFCXxJgiwVklSzNEDg84
         MWEFRFrOkw1eKjQvHtZgx5guA/E+cx3Cd/5H/kvIQqmHl3onkUZ8T/sfYJTKAkuU1NhE
         jQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723572423; x=1724177223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6N2j6hj9Xt1/uQL+7yLQtfz3MlJVXjDshFxiGVCkNtI=;
        b=FXtWz2HHOswqE2amuohvrG6TTFwmT6Oclg0CEMMzZ+a1aJc+F7EaKToowdBFA/jbcb
         iIdO66Dp97XxBi5q5tcg1dxMyAP78dG2Mk/cqrI+XF7P4b5L7SOF2J1VgOzPJFjWt2z1
         jCuAoJnKoYs4M92HdS7HPs2uw2Frt6hZ8Ael2xMAlBeYsVZPXj/ubGUmOmat0HPedZTc
         +jhWiFOAKF8vtiw4pxiDR6whRqVFndm6bIrWzuKaTaFKVHLwcMy2hd+bT4kKErXRkFno
         8J/ZZlV41cI/j6iMx0LGgVnvpX0ie/UhfoPIfBZlHqmz3WwqXGCwFCFYq9aW8RQIBRYx
         OYEA==
X-Gm-Message-State: AOJu0YyHJZUvAs8a93TWl4zpIXYqPGvhRqMFuyP1odNS+8nRWynoyewW
	HQVPmUQtNwXXuVXbFPPrSqhGtRt99R0v0tfFyl2VtwIi+kbUuCAAT70aHFxBAE1YG5t5eSUujf0
	HJA==
X-Google-Smtp-Source: AGHT+IHOrM2tWvPXKObrlH/h6vzbjKiArEJx6s5cZJzigUG3+ukFW7aTc0ehnclrvZIEwYyJkJb04oyYQWA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f68d:b0:1fb:7c78:4efc with SMTP id
 d9443c01a7336-201d64a5a81mr163125ad.11.1723572422606; Tue, 13 Aug 2024
 11:07:02 -0700 (PDT)
Date: Tue, 13 Aug 2024 11:07:01 -0700
In-Reply-To: <20240522001817.619072-5-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-5-dwmw2@infradead.org>
Message-ID: <ZrugxU6OHlLRQZ_j@google.com>
Subject: Re: [RFC PATCH v3 04/21] UAPI: x86: Move pvclock-abi to UAPI for x86 platforms
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jalliste@amazon.co.uk, sveith@amazon.de, zide.chen@intel.com, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, David Woodhouse wrote:
> From: Jack Allister <jalliste@amazon.com>
> 
> KVM provides a new interface for performing a fixup/correction of the KVM
> clock against the reference TSC. The KVM_[GS]ET_CLOCK_GUEST API requires a
> pvclock_vcpu_time_info, as such the caller must know about this definition.
> 
> Move the definition to the UAPI folder so that it is exported to usermode
> and also change the type definitions to use the standard for UAPI exports.

Shouldn't this be order before the introduction of KVM_[GS]ET_CLOCK_GUEST?

