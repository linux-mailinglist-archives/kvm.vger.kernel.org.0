Return-Path: <kvm+bounces-29427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A42D9AB52A
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 19:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A1551C258BC
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 17:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884861BD4F2;
	Tue, 22 Oct 2024 17:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dqd/XtFT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657871B5EA8
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 17:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729618382; cv=none; b=OMSVqfExbSnrOKQ2bj210Oshpw6xbiAICWQn0uqClIq7KV81ipaelx6ialJDEmPUlK2Rux5iqXRvEfL36VABTOdvlcDSkA1Kf5vSuW03T/BtN9JE+BoEqEqrQpdNLBCRBy8L3qyHayfEqoyv4p2aSYbWIW+J9hXEKH9O6vRu8Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729618382; c=relaxed/simple;
	bh=wCt32+Hp0Ltp7p9luxo2w+Y+qVd2NvAadzrLdqzCEgM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qIJjeat8XErIZD9lKZC/p82DA2E8jrtkXX6fE9Uw0VdD2DS++puMRb9Fa/tQWxWQHcf/BrHunRTiIQopq4YksjSCcxeQ/kxkkIn45HT6SnLzNGkOYcMSHMo77Iy+IUxpWb0waW9qVmrqJXnq4Im5s7kXUgjxwiYElgKr+K4BLD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dqd/XtFT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2ca403f5dso5538324a91.1
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729618381; x=1730223181; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jGiL2mAhdbXiHD7qcvH0j2VemTtsRJpc87jYb0znh3Q=;
        b=Dqd/XtFTtwl4ttK40yHfD+Ex5LtK6cpf0aoYz1/4vhSYrmqP/y9M56YtH45tD7Yuk7
         JfC3zmjWkO+lWeyLi46O6X05jrdvEaunNX63eFXdOt7R1s0437ucEpnZ4Y+oGo5YOGDF
         J7NZ/X2sHmwmcuMgM9s8EAjYepBceno+twlVUx338OPIySfHwshTI5sq6jWDn1g9yCtN
         nC3CDKUOYkgPMjgop++BkA3i87GMR10EfKdg9qkFTggvtfPV+UBs+nD3A56x/UW1BAjd
         abvoduJE6wt97rY18COmzewzY/PMlWzHniNn0llK7bzEAXGKARkbJ+kd69K4dOQE9ySI
         fKmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729618381; x=1730223181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jGiL2mAhdbXiHD7qcvH0j2VemTtsRJpc87jYb0znh3Q=;
        b=dg1FfBGwF+mdmS4WWnEdk04KkqBQmiexRBpuVY82fSHT+28nz4SSk8wb37tZ+TiFT+
         k06V+xl0aeS3d3NrhO4tPekKAkMymVQuBgMpfcS4uzxMvol79wnAMilYUdrp4q/ipLHp
         5rZlZruGxpFfRxKYlar6p6HZLBIS7WPJ2oxsnL7rwucsoMDpezdsnKBRwvyEbRv4ccBs
         JV8QrbyhdrwlGvAKGoxswmkJhrkzzJfoO6Z2RZcp+0PuMq+1YVSD4UJu5kX8l3jniCGL
         2vy+Qax2ukFNf64BvuSXeraSb8Ca4vcEbffuJWPvbjvTKn6UN9BRG2Iv4IzMgeb4pRbk
         QNMw==
X-Gm-Message-State: AOJu0YwxEpKUSLwPXNCjxceWJ/kyYggOiJm5iUSBqWuF1CepL+cE7HzN
	KYZ9VaI6D3Jf0GrI11cX0GjLw87PEmckhnbsihi+RJL/l0aAOdsSwnacqvcZ9FgQLLFhrFy9rt0
	rZQ==
X-Google-Smtp-Source: AGHT+IHYelvokRJs7LdNgGWjrnxNMdXVmd2Yhw20A3kmmI06l5lSRaKFTSwupbSMujEa5YSH7CWU9iBkgys=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fb46:b0:2e2:af52:a7b4 with SMTP id
 98e67ed59e1d1-2e561a55cf1mr29215a91.8.1729618380608; Tue, 22 Oct 2024
 10:33:00 -0700 (PDT)
Date: Tue, 22 Oct 2024 10:32:59 -0700
In-Reply-To: <20241018100919.33814-1-bk@alpico.io>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241018100919.33814-1-bk@alpico.io>
Message-ID: <Zxfhy9uifey4wShq@google.com>
Subject: Re: [PATCH] KVM: drop the kvm_has_noapic_vcpu optimization
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 18, 2024, Bernhard Kauer wrote:
> It used a static key to avoid loading the lapic pointer from
> the vcpu->arch structure.  However, in the common case the load
> is from a hot cacheline and the CPU should be able to perfectly
> predict it. Thus there is no upside of this premature optimization.

Do you happen to have performance numbers?  I've been itching for an excuse to
excise this code for a few years now, the only reason I haven't ripped it out is
because I didn't want to do so without numbers to back up my claim that it's a
premature optimization.

In other words, I agree with your analysis, but I don't want to yank out the code
without at least _some_ numbers to back up the claim, because then we're essentially
committing the same crime of optimizing without measuring.

> The downside is that code patching including an IPI to all CPUs
> is required whenever the first VM without an lapic is created or
> the last is destroyed.

In practice, this almost never happens though.  Do you have a use case for
creating VMs without in-kernel local APICs?

