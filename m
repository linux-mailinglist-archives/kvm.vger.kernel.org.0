Return-Path: <kvm+bounces-30335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD14B9B9654
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73045281295
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B971CB330;
	Fri,  1 Nov 2024 17:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IJaqvonf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C1E1C9DE5
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730481304; cv=none; b=VIIHis4aVKLbDt8SwcQKsg4O0qZIGNbSTKJoHScaHDnQ1uitZBirL4QKQe3oYvCvQLt65s2WyRjX23CTky6V8Hsl6LxHIXsceif+o8RHsvC2JGPWVU1gQoxZElb5wJwp8sDsUgCms9sdtTgm0xM76NkI6XquzLTJ83gkNDZsi38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730481304; c=relaxed/simple;
	bh=+Q8C3WVkar+gRBgM9zh5E/CuzXQcTMOL92452R8Vcww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rXGGlXKIzkDd0d2RxT0LxDSYiKlOZdhHejCHRPS4BHd188d4y0dFLiU0R4/v5kk+8vafjE92dlnExnfUutyPAJFFcaW3KT3iZo1dN1Q2wj/akO3+aYx9gtvU0xQcYd+RhvoIz2L6SN/mBlGd7LQRlG8EKWKHnrTrzvxqcienJaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IJaqvonf; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-206da734c53so24465265ad.2
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 10:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730481302; x=1731086102; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3WjphhVBeIg+7r0qHzagqZhNZbHBJirJ2EYUizEIggg=;
        b=IJaqvonf7QavaEjyNkJ3Wrb46sJzK1YbLZleGMDS9JF1oXkIVIQo86/s6yMs6ve3v4
         l97jiw1+vW+ZEwl4SCVZ7UUjrjFWDb1donAV5JliJgjBfWYBHcU+pBvVokhV3ZQ/Tppl
         pFD/nB+MvqJeYpq33Qb2+0zWIYoW2ySxLaYgEDB+cnaaysEPheYTQ08qcTzC3CPx28g5
         UQDUeCxsfox9CKEaSbckWl0gWoyUPzJumskXopDf0JhmqE9/SPj21Yn4jmJSNBF+Xh3p
         qpw+mwtBDWIi0sJ07PHe1ZKKOPRiUQIAan5m01yPWDC2/svWmvoah5feK18vuiQeTvp1
         e9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730481302; x=1731086102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3WjphhVBeIg+7r0qHzagqZhNZbHBJirJ2EYUizEIggg=;
        b=DAFHzDxOqWFPAC/w1zV9/eMjhsqd19XuKv4kPLQUP4KcUCykkLGosmHmq+RTr0J37G
         MZvikgrOUeD3hbYP3G3+VwNPv+bfXKGRfEY7gFNPTrqRsFL1F1vLcrSvIg89IzPgMTCS
         KmtwRx3NDb1cwsuBvdNIQFpHgpyKQLbtawuFnlX6tGtoZE1lyO1iASfsVupdepXtkcWb
         KaI80w0e9+NIkzDLvN/Cn890I9qsxGJyYHwmXrzpv0G/MMi+YLBTMRMoadTuwW9DrXKw
         6vl6G8ZmK0pKSpXg3CCC0kb9T72uWUfZev02ncUZVY1GQj3eEy4KWiAw4eLlT7/psub1
         kLLw==
X-Gm-Message-State: AOJu0YxBgTjRl3F8oT/92LfQMhAMaBbg4QVQ3GhUxtpAAqonm/V0rW/H
	ai2cHfHluj31kKsTOOBRpA4Rv2BbNDF3GygKXjq3YUhcMkE1peNrdkxK04x24NuGrBlpbFT9BCy
	E+Q==
X-Google-Smtp-Source: AGHT+IGiiMkgXigZOym5diL9lYG2iUONulsIdBggyaGMQ6PHY6vHPvHoiKnVDi2yvIMlqFpuiZ/Xg+eKsdM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:808:b0:20b:e5d:ab01 with SMTP id
 d9443c01a7336-211039e344cmr61715ad.0.1730481302055; Fri, 01 Nov 2024 10:15:02
 -0700 (PDT)
Date: Fri, 1 Nov 2024 10:15:00 -0700
In-Reply-To: <20241023083237.184359-1-bk@alpico.io>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023083237.184359-1-bk@alpico.io>
Message-ID: <ZyUMlFSjNTJdQpU6@google.com>
Subject: Re: [PATCH] KVM: x86: Make the debugfs per VM optional
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

+Paolo and others

Please use scripts/get_maintainer.pl, otherwise your patches are likely to be
missed by key folks (Paolo, in this case).

On Wed, Oct 23, 2024, Bernhard Kauer wrote:
> Creating a debugfs directory for each virtual machine is a suprisingly
> costly operation as one has to synchronize multiple cores. However, short
> living VMs seldom benefit from it.
> 
> Since there are valid use-cases we make this feature optional via a
> module parameter. Disabling it saves 150us in the hello microbenchmark.
> 
> Signed-off-by: Bernhard Kauer <bk@alpico.io>
> ---
>  virt/kvm/kvm_main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a48861363649..760e39cf86a8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -94,6 +94,9 @@ unsigned int halt_poll_ns_shrink = 2;
>  module_param(halt_poll_ns_shrink, uint, 0644);
>  EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
>  
> +bool debugfs_per_vm = true;
> +module_param(debugfs_per_vm, bool, 0644);

I'm not opposed to letting userspace say "no debugfs for me", but I don't know
that a module param is the right way to go.  It's obviously quite easy to
implement and maintain (in code), but I'm mildly concerned that it'll have limited
usefulness and/or lead to bad user experiences, e.g. because people turn off debugfs
for startup latency without entirely realizing what they're sacrificing.

One potentially terrible idea would be to setup debugfs asynchronously, so that
the VM is runnable asap, but userspace still gets full debugfs information.  The
two big wrinkles would be the vCPU debugfs creation and kvm_uevent_notify_change()
(or at least the STATS_PATH event) would both need to be asynchronous as well.

