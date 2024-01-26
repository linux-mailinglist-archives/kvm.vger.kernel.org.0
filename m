Return-Path: <kvm+bounces-7193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2A083E19E
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61FA51C20C0A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F86210ED;
	Fri, 26 Jan 2024 18:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="utuHxNlP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34311C295
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 18:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706294025; cv=none; b=qXOwBHoHzcSjZjN1tRU4r+MOz4qCvjQzOdDpp3ned5ge9GBv2uGpH69IXWvWtGecuqt4ip3btfnMl6HnnzLM8apNl2avChXZKezJa5D5BsmY84rS3pa2Zq1EueMpe0t0zA12ZVkqkFNLiPbzJN+1r8xcu4YySNayWEynQpwC2P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706294025; c=relaxed/simple;
	bh=lQzonua4L7LeuBe7wO8Mc6DzTpXm+HWTrEtwIwlJ7TA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hEH8dANXQerTAB9gXvmkxWPRpQmVTJhQ6sz7TN6kSfRI/O8jOmH6hiNqe91Suf7qu0MLsr36mJEdAJfQo+uwbcfoFZDjAmEgLU0sFl71SUFlCQ3U+c6PCBl/RaDerxkInvh1/UTj21aB60qzIgiEf5Gz37BXA8/J0sUSnb45aq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=utuHxNlP; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc3645a6790so2042941276.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 10:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706294023; x=1706898823; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Dcc9LRXvpntKzSYVjpRtgdZNNstahDCXgoyjCxDxqY=;
        b=utuHxNlPmFVAA8LFUEBKQ3+hSCqPfaLcBYYkznaR13an82F8BU0OlnqY//MFOGorky
         fj1RQtmo/63wYPFHrLGUmBntqysTKd8iNxW4SlReSYp01vWj1s+ED33/0b4C67tAoPGC
         O8abyLHS3YQkK4P9BtVREHGEhmvOaK3lvw8yV1i64PhFSiXIeLcEyoWJMxWlr55DvhMU
         eCtoHSOP8stzIHKOytHUczZ+sgEB8GuIUa94QdWRPN8cE6v24Lu7MdTpXp4lrpL8dprC
         KMWMerZq6sGMzAW+HeTmk2nDit47EO53mmvQCh/vkmMRXj0uhuwxWCHKTxgppyICmEnr
         LyRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706294023; x=1706898823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Dcc9LRXvpntKzSYVjpRtgdZNNstahDCXgoyjCxDxqY=;
        b=qgVviehIl5MDZ6AgOvfihXUvUpUO7XixgLH9u+7vMXa6xkIcBdMCv3qHpHF3W0Arwp
         6wB3qizi7r8hP9uAj3HCrR7/0nNQO70f5wBCVeRAGskoVl4pf7nDN5Gj5/k72Zsm9BYf
         4j7gxLtZzUvVI+7Yh7QL+S8yP6V7wFXtmAJE/ed+RdyRsVE08yA40ZK00D6ePq9ixHqQ
         hIm9TDq1bDngiQSFDykOAGqcfhKwTZ0bM1O2Qzuhcq0Nk4wpo0Jf+YJ4UGc+pMsBCYkC
         mv6LN2mdytD6gCujUAo5YTADP2OeeUoI77JnF5r7A8Pitd5UykzzAP4jM8lpGybOvwn7
         Nd8Q==
X-Gm-Message-State: AOJu0Yyhqfh1QiiIx0oT7lemqkVtUpeeumRBs9mqBuKuHigxeM/QWOS+
	C6R0FKsk2zCDvTOUM3OnxXrwPKVK8HH8hAaH1QIAgLdlHiyH7LMF3vQ7yWjIDKTg/e0yUXfgrpn
	j/Q==
X-Google-Smtp-Source: AGHT+IG2evS1F5jsdTWYPfbDyr3i6wyF9yc/uUWrNxyUNahpRRRy9BhGGzgDwd5w+JSN//YUJY/YNq9YCRM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2481:b0:dc2:1cd6:346e with SMTP id
 ds1-20020a056902248100b00dc21cd6346emr139746ybb.8.1706294022986; Fri, 26 Jan
 2024 10:33:42 -0800 (PST)
Date: Fri, 26 Jan 2024 10:33:41 -0800
In-Reply-To: <ZbGn8lAj4XxiecFn@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240124003858.3954822-1-mizhang@google.com> <20240124003858.3954822-2-mizhang@google.com>
 <ZbExcMMl-IAzJrfx@google.com> <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
 <ZbGAXpFUso9JzIjo@google.com> <ZbGOK9m6UKkQ38bK@google.com>
 <ZbGUfmn-ZAe4lkiN@google.com> <ZbGn8lAj4XxiecFn@google.com>
Message-ID: <ZbP7BTvdZ1-b3MmE@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0 if
 PDCM is disabled
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 25, 2024, Mingwei Zhang wrote:
> On Wed, Jan 24, 2024, Sean Christopherson wrote:
> > On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> > > I think this makes a lot of confusions on migration where VMM on the source
> > > believes that a non-zero value from KVM_GET_MSRS is valid and the VMM on the
> > > target will find it not true.
> > 
> > Yes, but seeing a non-zero value is a KVM bug that should be fixed.
> > 
> How about adding an entry in vmx_get_msr() for
> MSR_IA32_PERF_CAPABILITIES and check pmu_version? This basically pairs
> with the implementation in vmx_set_msr() for MSR_IA32_PERF_CAPABILITIES.
> Doing so allows KVM_GET_MSRS return 0 for the MSR instead of returning
> the initial permitted value.

Hrm, I don't hate it as a stopgap.  But if we are the only people that are affected,
because again I'm pretty sure QEMU is fine, I would rather we just fix things in
our VMM and/or internal kernel.

Long term, I want some form of fix for the initialization code, even if that means
adding a quirk to let userspace opt out of KVM setting default values for platform
MSRs.

Side topic, vmx_set_msr() should check X86_FEATURE_PDCM, not just the PMU version.

> The benefit is that it is not enforcing the VMM to explicitly set the
> value. In fact, there are several platform MSRs which has initial value
> that VMM may rely on instead of explicitly setting.
> MSR_IA32_PERF_CAPABILITIES is only one of them.

Yeah, and all of those are broken.  AFAICT, the bad behavior got introduced for
MSR_PLATFORM_INFO, and then people kept copy+pasting that broken pattern :-(

