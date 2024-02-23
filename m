Return-Path: <kvm+bounces-9469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D391B86085B
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6C73285B4C
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D34125C0;
	Fri, 23 Feb 2024 01:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MtY7VIV0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6418DBE5A
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652200; cv=none; b=IB/482YfdcREh7vFrV1d/GgKqU6NQt9T77YYl5N/N6p1FLQEa8byKvdS0lY5uqLmiAmzDOdxMk4XxaCUm6cYY9Hh7BN0SSpRdv3GtWrdZuEYcP5TQXOQCf2IBxxBTz3yHJTq5mOywHpxL0+1mCpGWwNviQ1+Tse51N2t2y9aO/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652200; c=relaxed/simple;
	bh=+6iflh9OwyDaYSBxEKexc+X2ZO9QrWnV28hXqu/Xngc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mZMPEqOdfv2ADINIZ29cL8YntCT+E1Dlxe5kSKhAaCNdsIrfgUrqPUKSpXzAqs7sZuV5ERG/xmhguTIZXNRzMyXHv7r33LIiL0eUlAy/DBhfwdI6dCt609b5jzMVzpXYMbePgghR3tqE9fmUGRteqQH8LoPvVuMCT6pr64hRDGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MtY7VIV0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6047fed0132so6577377b3.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 17:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708652198; x=1709256998; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fJPIUUm/mIbzRmGTJsg5X63GQ0pru4llRiB5k8zA6Sc=;
        b=MtY7VIV0F48GUZzHBCIdYL20n8IZd/HjFzFD9+n5saXUqsxOQEExqmZ7ZhZCwFT4sO
         o/q5UqQIpI2vmf84c//1yli36S1gglxy7JgUFnQ4S1ERqYmHYRBJU99Dikub0VRIXM7L
         GgOulXTRtlQdiXO0eZ/QpDjgIFD7jUlTzTDRctpISKXXVDnAypWY06cMqhwWT4O5P12Z
         +kh6fCIbw3j0gIyUpANYfL0yMRX4DrP6Jt7WSjMHgnOrw4piFGuUQsC+hhJLq624GHGN
         e1UoJFV7W2hzf8I719SNoWgppdL4R8u9guOOJ5F1I2c1k719oO4G79vUKYzEoT1a87kU
         1j2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708652198; x=1709256998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJPIUUm/mIbzRmGTJsg5X63GQ0pru4llRiB5k8zA6Sc=;
        b=GqCZ9/vtizxun1Z+Lx3HOQ8CedYpnJWwctZZ3gz3uh0iPpdTSdGs/lBvtXTNepBp8y
         zBK4Ho8POSFR46QX66GC823W0XnLsidjVbDzj8AzcxKHOD+u2CWJ2m07+OGuDD710pPQ
         8MoulOAGM0AJ4ntyZ1ccFGEdckp1w1g5CH60gbTCssbVIILE8OtthPP4rQ6kq3FntXkY
         pAvmpq51XcYMdtBhJxDveTKtCLQQgtvmOxIQAsZIreiRwnPAvppKuiVVux2w7L2CvYwv
         bIPGGyoz2Oz9qATPqCRX/pNNvSU8yH7Qq7P7gHBx08g1z9LEh47CvDY6Jmq6QKQgD1OZ
         Uxhw==
X-Gm-Message-State: AOJu0YzYs1jYAmbfUAJfNKEmTDR1B43MnT7xwF0qLNhDuL5/7dx66HMh
	ulICx4D+U/WeunBGSBfG3Je2Dy59v4dCpFLRSZI/wZhr7rZP6w8LmffXqNcqndpAdYli3p0/1wO
	dpg==
X-Google-Smtp-Source: AGHT+IFqvVI2wY7eaXRVKtP1ie0OueNFTFkbl3BOnxmUFVvvdQVVHKVXaSJugYcQNPPubbWiTI+5H/4ltp4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d408:0:b0:608:801a:e66e with SMTP id
 w8-20020a0dd408000000b00608801ae66emr167575ywd.3.1708652198486; Thu, 22 Feb
 2024 17:36:38 -0800 (PST)
Date: Thu, 22 Feb 2024 17:35:46 -0800
In-Reply-To: <20240111020048.844847-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111020048.844847-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <170864814086.3090349.6029084831645798943.b4-ty@google.com>
Subject: Re: [PATCH 0/8] KVM: x86/mmu: Allow TDP MMU (un)load to run in parallel
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pattara Teerapong <pteerapong@google.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 10 Jan 2024 18:00:40 -0800, Sean Christopherson wrote:
> This series is the result of digging into why deleting a memslot, which on
> x86 forces all vCPUs to reload a new MMU root, causes noticeably more jitter
> in vCPUs and other tasks when running with the TDP MMU than the Shadow MMU
> (with TDP enabled).
> 
> Patch 1 addresses the most obvious issue by simply zapping at a finer
> granularity so that if a different task, e.g. a vCPU, wants to run on the
> pCPU doing the zapping, it doesn't have to wait for KVM to zap an entire
> 1GiB region, which can take a hundreds of microseconds (or more).  The
> shadow MMU checks for need_resched() (and mmu_lock contention, see below)
> every 10 zaps, which is why the shadow MMU doesn't induce the same level
> of jitter.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/8] KVM: x86/mmu: Zap invalidated TDP MMU roots at 4KiB granularity
      https://github.com/kvm-x86/linux/commit/8ca983631f3c
[2/8] KVM: x86/mmu: Don't do TLB flush when zappings SPTEs in invalid roots
      https://github.com/kvm-x86/linux/commit/fcdffe97f80e
[3/8] KVM: x86/mmu: Allow passing '-1' for "all" as_id for TDP MMU iterators
      https://github.com/kvm-x86/linux/commit/6577f1efdff4
[4/8] KVM: x86/mmu: Skip invalid roots when zapping leaf SPTEs for GFN range
      https://github.com/kvm-x86/linux/commit/99b85fda91b1
[5/8] KVM: x86/mmu: Skip invalid TDP MMU roots when write-protecting SPTEs
      https://github.com/kvm-x86/linux/commit/d746182337c2
[6/8] KVM: x86/mmu: Check for usable TDP MMU root while holding mmu_lock for read
      https://github.com/kvm-x86/linux/commit/f5238c2a60f1
[7/8] KVM: x86/mmu: Alloc TDP MMU roots while holding mmu_lock for read
      https://github.com/kvm-x86/linux/commit/dab285e4ec73
[8/8] KVM: x86/mmu: Free TDP MMU roots while holding mmy_lock for read
      https://github.com/kvm-x86/linux/commit/576a15de8d29

--
https://github.com/kvm-x86/linux/tree/next

