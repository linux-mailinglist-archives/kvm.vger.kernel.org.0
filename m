Return-Path: <kvm+bounces-26190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7FF9728B1
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D68B728378B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 04:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B14E16ABC6;
	Tue, 10 Sep 2024 04:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tlh7pd95"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA821514E4
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 04:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725944322; cv=none; b=fHrJ4VOvBnwSAChpmib+CU7ZF8sR+6IjtzwwSqWhD7AFusI3jSqh3uVCqn1/S6QNAZ/xr9n85/ppSdkzEbV6NjVMQ69B3/2Jpwq1FcGXt5VvRvUgnZV5ZipYG152N4yJl3X+IH9K7c3Ia8Io0/K+XrMRiQNr3ptdE8Cat91I6u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725944322; c=relaxed/simple;
	bh=dJaAYe8taoaphDzwAxP5s7uks0FfXXrTZYZJDlRoqro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HbrwHBPPIoWQUwWCGRZ2Ll1/OhsiD/g9IyGZG6y4zbHdXuALZYRTTb+JcT+teLm1BHp1NXL19E/P6eupefVFoomvsrKCRzCMQRcmke+bvLMEmDEOqWw+mkui+UyVi/aRcF32Q31zgHMFCVkdhczZCOWr+Fh1wJHb7X5+D4PO+7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tlh7pd95; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d8a4fab0d7so6266239a91.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 21:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725944320; x=1726549120; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ctxPqvtN6tXOnflyu7Ll9TO7tWYMIjdIy+cR+i4LWlM=;
        b=Tlh7pd95GnveZjDpxt08ltoxo6PR+njVvr7K9mu969L+WEzIzaLc0BbvSygzm68bto
         p1hGk2ds4stUChFoIC7Kq7+gdnOB+MVN2UfxJWeHanZVzUOot4hYll7YoqZgwuxyTJ1b
         4MmN83vrtlq1AFJMx3xFs1XaX5piMlEg6RcvO12dIaVxP0gaVaf800oYOvvUQGXGHRev
         hPznviG/LGksXZKsXpJ6Z5HpywQnvN95Gmn54tZ4/j2kxJp6U7buFe3cv8tlgS6kRT3T
         IETTnN5rKe+s1Zex1cNChw06ZiPOrdqrRygCtiEX+Kyw4HdrutPGm6ir/XfCp84iE3Pu
         EbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725944320; x=1726549120;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ctxPqvtN6tXOnflyu7Ll9TO7tWYMIjdIy+cR+i4LWlM=;
        b=YQ7kDzGWKdMj1EBftv+fRzHGlhd4IqqksrMPkjkr8vO8TAynJXovpEGPSWFoP7M3SJ
         wySfjdXyGc/i+EsLS4ME9i+jOH7L90W9VQHbbB6NH+aCTdI7X+5WbrC8/cYFScjKBREF
         qKH1DvqNkybOcwzkMghILj7ZUb8bI79U7k2Q+BStAT/qioAc9VUa8s20u9cOllh4MN89
         FSliEH/frb09d740SxUUqROCfYOxRa4BFDNwLXBwwRpd8Dmsc9ed6bewzoMuMGT4+H/H
         eWBS912ZxcuxHpt8ie+lzwvyv/f1skN3ztB7EnkeBkE4WnlIfl+L6ZSlkKqMhmP1kmPA
         o5eg==
X-Gm-Message-State: AOJu0YwOmyqCa3wn30EQkdkHTWai68k2mHh/813R+HD2TvlX6NWaHf7J
	+bxfks+ReLyb8Vygh1AVl5Yq9V3ahAHzdlwl5rhFMcuzP/k/TS/rjFNP8WykB1ZrpMNAlFi0fMu
	RCg==
X-Google-Smtp-Source: AGHT+IFbn75t2C3kpQcMrOPy6y+G/tZIkGTTtzcSeihYGhxMuAYQIKZ+Jie4rnA/tJcKj6E6kAKPDfRIqlA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:296:b0:2d8:f814:edf8 with SMTP id
 98e67ed59e1d1-2dad512ca09mr120988a91.6.1725944320396; Mon, 09 Sep 2024
 21:58:40 -0700 (PDT)
Date: Mon,  9 Sep 2024 21:56:32 -0700
In-Reply-To: <20240830022537.2403873-1-yuehaibing@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240830022537.2403873-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <172594252038.1552710.4200877965473080029.b4-ty@google.com>
Subject: Re: [PATCH -next] KVM: x86: Remove some unused declarations
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, Yue Haibing <yuehaibing@huawei.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 30 Aug 2024 10:25:37 +0800, Yue Haibing wrote:
> Commit 238adc77051a ("KVM: Cleanup LAPIC interface") removed
> kvm_lapic_get_base() but leave declaration.
> 
> And other two declarations were never implenmented since introduction.
 

Applied to kvm-x86 misc (I have yet to post my APIC cleanups), thanks!

[1/1] KVM: x86: Remove some unused declarations
      https://github.com/kvm-x86/linux/commit/4ca077f26d88

--
https://github.com/kvm-x86/linux/tree/next

