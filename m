Return-Path: <kvm+bounces-13952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62CF889D02E
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 04:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14567282255
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49AA34F1E0;
	Tue,  9 Apr 2024 02:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N8DNuWvL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBF656455
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 02:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712628180; cv=none; b=FnGcVURimgcRDxYF37rPjWYtNU94x8pavtaPSxlxkSuYVQ431wamCoWUfnSYBenzrqRGdimYc6aXxh9r8Srozn0+kcn99XPt8iL87isCjAIyZWjRJrJ3UPHE6u6N2p4/KLPZzWW6MyAzvI64vFFW87hhh67X5fGliAJzM5fqjxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712628180; c=relaxed/simple;
	bh=/66ANqhlgh6dfJsAL2UyKasucCcRFsXjIhwslGGnq/g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rk7Ze66J/gHZUUv+0OzYR6LHLlnCPv1aB+gaI1pvjvVs/vhVetcroq3/dBbl906yneSldwxcDpUDffC353Gt9E2RphsGbZxp7eZJ+2O7CQqRFOVNgf1Wm1hRSWrir2o+BQLGr5bkBHFpFqbn3e+QGSbru/d2KIohzPYNLyztnJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N8DNuWvL; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc4563611cso7641353276.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 19:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712628178; x=1713232978; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2fpNLMOdTuzWqLni5ebK55upYwMGmEgOY//8538KyEg=;
        b=N8DNuWvLg3Dek3uI8v83apdHF9SLE1XFPySDK9L1YGz45j9sYI4m337gzEk4m9My9l
         NBZLqmjGtvxWinETu8607auqI99rW7LmGKX3LDLxGfU4gwClUCXTmK2e0D0aj/0PPzsE
         wHD9atofGr8b3GKrEwObEHYTKBDnQasXEEdbFHHujjX4VDwzdz626Zq8vJVZIy54ghij
         wQXg/bPppavQqNokBrSLfRPz9OvL8PWlfB/Q/R/wdshr4V4XmCjmykbzO8EVVe9b1X+D
         7a/Kd6QY+0ubKVMLkODNfwqv4sj6AOgxosVgBQLGJRrEMoewt2z7Zb1cQ1BQ0PIS9HeD
         P90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712628178; x=1713232978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2fpNLMOdTuzWqLni5ebK55upYwMGmEgOY//8538KyEg=;
        b=rRMOg7XurAgRAXpw1ho6BjwL+3YpGn8YTkr3aJy/pee+6yBP0rr77GrOlrswSD/vL3
         WcQsSNcTdVuJFuHm/KDcbKhnBzYep+UXabEryLRqQ7ya0wles6rnuUIqgUNU8xy7BfWI
         Sio5Qxn0gHN5jBlEMMErxnMfeGh4J7alTHpmiTJEgmlnE8uLFhG2+2l1b3f1uUWGHsj+
         TFHciEmRi3adnhh8SdSGHUpzklXhiFzEGMfpz/yaphVlPqIOrkQ/GdF+CC2Ys65BiKvV
         WDpedSssSpl5YWS97gpdUjcN59yRFW8weURA/HY3lC1KR28PMb23hPqx3PEnhVQufMZA
         6R2g==
X-Forwarded-Encrypted: i=1; AJvYcCXd06VTvzi4Z48mQdm7DegTk+Op/OQyYOzEycL5gpS3pKdu7b/EFX8uhffAg204pDP2rxWf2wlijgmkQe/vVqjNLOiC
X-Gm-Message-State: AOJu0Ywv+QbXjFueZ5kzJGyETuocF9cr3odDroZYPHjjZxuPVLf6nmFh
	PpaXq1ccVbOnMnM1mw79q8kEhr9oz1Uo89+dQhpKYazrCnQglVefOXBgYeVXENEWCl9Qu1TPc+1
	Pmw==
X-Google-Smtp-Source: AGHT+IFkT3IqNk8Swm6Z6BzO4HQMeVVomPflFll1hzbTPvwK61G/5hP4ruxToK9jO/RPTXxksja17dHvTW0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c03:b0:dc2:1f34:fac4 with SMTP id
 fs3-20020a0569020c0300b00dc21f34fac4mr3156555ybb.2.1712628178083; Mon, 08 Apr
 2024 19:02:58 -0700 (PDT)
Date: Mon,  8 Apr 2024 19:01:33 -0700
In-Reply-To: <20240307011344.835640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307011344.835640-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171262750089.1420807.14858434543826601467.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: VMX: Disable LBRs if CPU doesn't have callstacks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 06 Mar 2024 17:13:41 -0800, Sean Christopherson wrote:
> Disable LBR virtualization if the CPU (or I guess perf) doesn't support
> LBR callstacks, as KVM unconditionally creates the associated perf LBR
> event with PERF_SAMPLE_BRANCH_CALL_STACK.  That results in perf rejecting
> the event, and cause LBR virtualization to silently fail.
> 
> This was detected by running vmx_pmu_caps_test on older hardware.  I didn't
> tag it for stable because I can't imagine anyone is trying to use KVM's LBR
> virtualization on pre-HSW.
> 
> [...]

Applied to kvm-x86 fixes, as I can't imagine anyone objecting to patch 2.

[1/3] KVM: VMX: Snapshot LBR capabilities during module initialization
      https://github.com/kvm-x86/linux/commit/2a94a2761236
[2/3] perf/x86/intel: Expose existence of callback support to KVM
      https://github.com/kvm-x86/linux/commit/0c0241c12332
[3/3] KVM: VMX: Disable LBR virtualization if the CPU doesn't support LBR callstacks
      https://github.com/kvm-x86/linux/commit/0eb2416c8111

--
https://github.com/kvm-x86/linux/tree/next

