Return-Path: <kvm+bounces-32603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB759DAE97
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:42:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8302928271E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339C8202F93;
	Wed, 27 Nov 2024 20:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mfz89ZDz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFC914AD29
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732740160; cv=none; b=Fa0E2jftJvUd7Mw0iFOEdahoK+CuXFpnDMtuymQPIP4Pis1YiI3YHtgN2Qz6uVJ2emR7gJijvzIPMCRhFzlc7R+GDHD4MRp4SQ/5Q+BqLOjHeEWOCfMFWNwFU1hq4aNC2t7k/siysJOtu+MKvX4oFsSNm+N9diyPuXMVuqGiIfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732740160; c=relaxed/simple;
	bh=7TMZSUPedZGXyMApslGrEmRr17ij/Cpxnn9h1FHUUHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RHyyfk3+8J+hpFlXjgojcCbQWc29vm8TMBirs7E4/WVVSjGNGof0lTnJ6DvFVdai25525TpzZyNoB/YwhsXHEJuQyJp6cu7/Yyz6JDPQP9VvHT67hhWpgYO3S8aoe0M5dr6KModvHQrXd4eW5KF0tPJSmhQedHDmzNPYwm7+gJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mfz89ZDz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20d15285c87so740795ad.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732740158; x=1733344958; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c9WtJ2jIIM2p3CLt1xHmlW3Ema1rsovterbczBKB60g=;
        b=mfz89ZDz2o/94qqptowHkv84Ckl88ZPIyb6Fusf4ZCZo5GKVtInBQqaD9sBbw47OOa
         aXSTWixc0YVE39JBmRPdcX/5CFfvNxm6sexASLXsPNSmrW+PnsKqdxviMNC4WDxAcADZ
         APTFFxPTJMAuciFXTi47qHmMH+m4RDdMyy+FuHF4v+0hNyv7UYk46P58W6dGDltRGnX+
         +lVdicMt5dsrzDwwsg/Shzg7p4AyP8RzsD0wIhqouS3NujPQUfoAtdPbORAeugtsNoxH
         13USE/2yplNVAeN+HxdgkgyULDfybF+5aEugDdJpK9q6auJnHQcaQ8TfJiE3wnJV8QLm
         mphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732740158; x=1733344958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c9WtJ2jIIM2p3CLt1xHmlW3Ema1rsovterbczBKB60g=;
        b=RewaIPIR5YzWRgJURR83MfO/3KbyvWGItf7/lt4rAKMuqkMoKEcvMUkX3yOfEET1mU
         +13WvNiZTRIKrLXwlS11R2U+pC4A1s9TuYLi/Eab4cgD3sK0hbLdq0Mrdj5mdYB0GcyY
         bpOP1ZwtIgApK2VX9+HwYNv2xfQ1zX3eKAqgWDXCB0dPuWBmof2wt+Ifg5JmfenhnvPc
         mfbXoXPIMq6kF8iP5oviPtnaIqP+PR96oWaHeAgYbI9kxnkrNTT7ggfnqyRGYcGNRjFv
         mQjjHYAsLQwY1T/JGEkoNySImA8WXchqQXbGOuPug3+nE0lyaInXWzbt7DHYW/HNEJR0
         pZNA==
X-Gm-Message-State: AOJu0Yzw+8w7rXSWmLjM8FditcNpwabdvm3JR+RtZfOPGXMWkj0mGGZM
	+MGSrjbGLxE3PA2N8rn5GLijoiYoDsHdUicM5fV+wkXLJpk0P8Rt5hdvsG/wtpg4i7wkqaVnm6Y
	lww==
X-Google-Smtp-Source: AGHT+IGbCAphMBE9AKvLq2ClzW9XdPZ/FMCnptUlg3EzLBjOSMj5crS2WDvLoFTxbUfzOGdnPkKcz+A8UqI=
X-Received: from pldt5.prod.google.com ([2002:a17:903:40c5:b0:20e:9b26:ccd4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:b18b:b0:212:4ac2:4919
 with SMTP id d9443c01a7336-215010994a5mr41135435ad.17.1732740158362; Wed, 27
 Nov 2024 12:42:38 -0800 (PST)
Date: Wed, 27 Nov 2024 12:42:37 -0800
In-Reply-To: <20241127201929.4005605-4-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com> <20241127201929.4005605-4-aaronlewis@google.com>
Message-ID: <Z0eEPSUXE8bxhekH@google.com>
Subject: Re: [PATCH 03/15] KVM: SVM: Invert the polarity of the "shadow" MSR
 interception bitmaps
From: Sean Christopherson <seanjc@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 27, 2024, Aaron Lewis wrote:

I'll write a changelog for this too.

> Note, a "FIXME" tag was added to svm_msr_filter_changed().  This will

Write changelogs in imperative mood, i.e. state what the patch is doing as a
command.  Don't describe what will have happened after the patch is applied.
Using imperative mood allows for using indicative mood to describe what was
already there, and/or what happened in the past.

> be addressed later in the series after the VMX style MSR intercepts
> are added to SVM.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Aaron Lewis <aaronlewis@google.com>

Your SoB is needed here too.  See "When to use Acked-by:, Cc:, and Co-developed-by:"
in Documentation/process/submitting-patches.rst.

