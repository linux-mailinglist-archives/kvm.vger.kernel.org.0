Return-Path: <kvm+bounces-30369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 470579B9874
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AC01281A0B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D411D0433;
	Fri,  1 Nov 2024 19:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p+aV4Vki"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C863D1CC8A1
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730489160; cv=none; b=l9hGC0cVGkENO/qPQOua3vSkTPy61lbD4a9sXzRPhqkLk/naoFJpjP8ILdpXtLfwKV0JSi2CXbSWbz30p5DEa4qzTGuz10PIOMQ97uSPbIe3LaVKZLEx4Jl2MP35vdSGI/tcjh9L4mhBZ0fXJ6R6nJ9lLKxmRMoN61YiSI30iAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730489160; c=relaxed/simple;
	bh=9RRq5zRiBjsuhIo93/YhYxFqpppBvG12vd+urRDzQ/Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LGMH+j4nEKYVuUm/ptbwdw000wQVuKliyUqLfvyv7RrKwAzTMdaBH78a8p+Y3WAfqt4HH+C95iGsFwLactLwMpeUWZ3DFYTMKmgYnTbU2TN0+dZOe4FOXzj8VqeS1/neZXI0duWI+vv6OvmJUX9ag+rdetNY+8lJih9xvvT0GQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p+aV4Vki; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e29142c79d6so4080769276.3
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730489158; x=1731093958; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zb5W4dbPYNTmLxwSEfSFJhO7P2tgHOLrBg1KR1NKswI=;
        b=p+aV4Vkij4sA/kOS5Yqaoy4wOuExwtpEg6UmRTcOYtDN8UJdfVDTtz8hpjzFwk3DXS
         8p+zz2k51QjbDXqEvNcrE0VabjNM9flGstJpixwdEGAyCLSwAE9cJReYkBIZbr96FSeb
         wahZiEkQDZNsluOxCfjgqGp6lxRtLXeepH3vvFon4zkKUMphWdjSJESgCLRqJruaMJRw
         lDBZiSvyQLzN5LWUtdou2aG9nday3JIYR7MaROXSH/4SPpd0Vnybsqht1rg0Bvp7tha9
         VqEURmGbU7Egv6FPW5KaIf8xb6Gxgq4ThARTMiREYmkidjT04khFL8CwPYF2a8qXu09P
         mk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730489158; x=1731093958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zb5W4dbPYNTmLxwSEfSFJhO7P2tgHOLrBg1KR1NKswI=;
        b=eMxvKWaOv+3P2srMc5yMzw0qTL7Aw2SsZCtA+OqyzSgpitlpYoG6vvHgiWVMrJLyfz
         9kVtgbfl8dTIHoEixFS73P2YcJIMaVnnkXDnzNA8+KSeM5VB5n+ta/5KlQQ7xsZKExxr
         I64ATwp0WAvyPIDxLur5YQz4M80/BPaI2Q2zZTvKWot6sv2Hk70sqbkFNbkMTaJkSZUg
         XGR3ww7W4YjqTUgzgosY1RraIVFhbZ90VYyiYgPX133Lb0WWACBsOD8PEYEkQ7jwFEx3
         Dzb6b5N3p1VSXsLwMmF/cIF5q7PeoC0LU/xw9cCQHAbZ9/1vjEKYfZNNq0ZlPmCBeZMy
         V8tQ==
X-Forwarded-Encrypted: i=1; AJvYcCWysRsZrLxoI+mnsG2EFRV4/OWySqrnGxGWNfQ8Y7dFfuMzn8KWOzvc8RH3ga0fkJshDfA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2s5gT2lbh81CBwFpjGX1BrhuIXXcowoWIr3Caa2BQioeiZ9xz
	pDnL5z7n5d6VEsHXQpF4z0/2A4AiniMD4jzuKdmbhvc8UGa+3Akr/2moCWZvdHJuHg8uJYOocb+
	NYA==
X-Google-Smtp-Source: AGHT+IGq3Dv2BlhxAMEm7nGR+GKdNpvGCeVpzNihoKgFHssrlWuGZbWQottjzjM2Z+tz/Qhv2Gdqobf8r38=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:3054:0:b0:e30:d445:a7c with SMTP id
 3f1490d57ef6-e30e5a03f4bmr4516276.1.1730489157852; Fri, 01 Nov 2024 12:25:57
 -0700 (PDT)
Date: Fri, 1 Nov 2024 12:25:56 -0700
In-Reply-To: <173039499504.1507535.6500285672510733682.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1728383775.git.kai.huang@intel.com> <173039499504.1507535.6500285672510733682.b4-ty@google.com>
Message-ID: <ZyUrRP7sa3IqsVwP@google.com>
Subject: Re: [PATCH 0/2] Fixup two comments
From: Sean Christopherson <seanjc@google.com>
To: pbonzini@redhat.com, kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Sean Christopherson wrote:
> On Tue, 08 Oct 2024 23:45:12 +1300, Kai Huang wrote:
> > Spotted two nit issues in two comments of the apicv code (if I got it
> > right) which probably are worth fixing.
> > 
> > Kai Huang (2):
> >   KVM: x86: Fix a comment inside kvm_vcpu_update_apicv()
> >   KVM: x86: Fix a comment inside __kvm_set_or_clear_apicv_inhibit()
> > 
> > [...]
> 
> Applied to kvm-x86 misc, thanks!
> 
> [1/2] KVM: x86: Fix a comment inside kvm_vcpu_update_apicv()
>       https://github.com/kvm-x86/linux/commit/e9e1cb4d5502
> [2/2] KVM: x86: Fix a comment inside __kvm_set_or_clear_apicv_inhibit()
>       https://github.com/kvm-x86/linux/commit/8eada24a8e83

FYI, I rebased misc to v6.12-rc5, as patches in another series had already been
taken through the tip tree.  New hashes:

[1/2] KVM: x86: Fix a comment inside kvm_vcpu_update_apicv()
      https://github.com/kvm-x86/linux/commit/ef86fe036d0a
[2/2] KVM: x86: Fix a comment inside __kvm_set_or_clear_apicv_inhibit()
      https://github.com/kvm-x86/linux/commit/6e44d2427b70

