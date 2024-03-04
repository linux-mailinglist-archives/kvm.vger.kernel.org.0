Return-Path: <kvm+bounces-10839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EDF987114A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 00:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A84D28137D
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 23:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420FC7E105;
	Mon,  4 Mar 2024 23:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EGJRFCEx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F4B7D3EF
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 23:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595883; cv=none; b=lZzt/mOSJmpsvkXEgIriZThGjm6uiub1bnX1DsCmSiMd9J4MrQFn+Ga27U3HS2GBdafiGK10pqIXsOD6+BH3gokLWz/yZrvNEgGpzEKmahDBWej1LAVG9AHsJlIIJxqVU6MEw9wXy5UpcO05ZuNqR1+mUEF+hnhcZNzBgQjnHTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595883; c=relaxed/simple;
	bh=q9XmueUxbjw5lzeCu4mv5wTYnOiXjtKEJoOansD9KfM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TZvaNWvXLtAOfHqi344QDyVRb5kButI+BfQZJ4Tff8yY/IOzcI6IN1hJUZayUhO/xgXmmvz3FMC74nqa5OczRXnFT/ZsPd9d+hhmJlE+hDpXdHE4J9y1zSsBgMnj9AQuZSo74KoQ8eH4kycviWpCk4YZT439AuPPN+MDQ5h/alA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EGJRFCEx; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6087ffdac8cso79411487b3.2
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 15:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709595881; x=1710200681; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wBtKQnxlmeHsINOAtDwKBhBMo0ip64bjHSs/xVD34BQ=;
        b=EGJRFCExpYi2mldg2CgqpcLnJ6bfJCOp1I87HKM+u67JXKdtFGapHrnnsNwoUgtAzN
         qJx5o0ozi3QeSSC9qgzCKSSNrs2KLx6twUUeZgjO3nH0HEEBjg9Dn7Yp1qDjFXN43mfV
         loPlL+7OisGXLwIWTnFXR9DKUXbj3BUdTz8Z/7mdioZXz17CqMwMG8aoyVyD5nIkpicC
         roPsm0+qU5UtD7IF8HlMZtbe1eTswpNfJs3RmLTs7dS5dflgnRsH7aJyuFCB7zbYX0kr
         vIzDsTpZDkCrCnMLKROZL9z+nMuU59uEtaVMpvGqZlfQgA26qYJLOQtYgieMoJRALpKN
         4y/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709595881; x=1710200681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wBtKQnxlmeHsINOAtDwKBhBMo0ip64bjHSs/xVD34BQ=;
        b=sK2ynLlInSoc3QZcAjFOVJGvNVZwiGWFfmdMO8FB6vfsyIuzkqp2tyxMJvMC6cVDqM
         GS4+GaAGynQTlZrnR0Sak05qZwEMAHVdVFK4ZtuucNlmopPIEuhF9P/059LmQgcD4u5H
         19CqwHgEOlG6+4hIb7AW0SXSNkluzETS1wVmEuC3gAfrEp8yNCi96Qm6KFZjsURVwjgJ
         TrnzPc3cssoC/PhY2f8WWJy4QHR4mZb44LSelnYu4Zgwo9NADaWqcw9l2mjeevXTxs9J
         AOVJb90xjYAXfB3U2gTne5aIMuHS+yaZXgRZlUQecp/SkA+FMPVFOSNGzazkAXflEXGG
         7FbQ==
X-Gm-Message-State: AOJu0YweW2FZmWsS1at3ADXDLKvytUt7noruVEGXnDRLs599c28AFIQa
	w8mk6rgkXOzdjG0Y1SF1TnGzmqlYUEdU/4r0NNtXkS0OiMKAptkNyzjKae9quTx43Ym7Q/E05bC
	E0w==
X-Google-Smtp-Source: AGHT+IF61WcK2N5S7kyQaTCIatvpsMfjH1BBW4sZfS0S6SuEUGYJtNz2iUmsGyTWJrWkisV1eKXUs8jREoY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc7:48ce:d17f with SMTP id
 w4-20020a056902100400b00dc748ced17fmr2713056ybt.10.1709595881009; Mon, 04 Mar
 2024 15:44:41 -0800 (PST)
Date: Mon, 4 Mar 2024 15:44:39 -0800
In-Reply-To: <20240227115648.3104-2-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227115648.3104-1-dwmw2@infradead.org> <20240227115648.3104-2-dwmw2@infradead.org>
Message-ID: <ZeZc549aow68CeD-@google.com>
Subject: Re: [PATCH v2 1/8] KVM: x86/xen: improve accuracy of Xen timers
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Michal Luczaj <mhal@rbox.co>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, David Woodhouse wrote:
> +	/* Xen has a 'Linux workaround' in do_set_timer_op() which
> +	 * checks for negative absolute timeout values (caused by
> +	 * integer overflow), and for values about 13 days in the
> +	 * future (2^50ns) which would be caused by jiffies
> +	 * overflow. For those cases, it sets the timeout 100ms in
> +	 * the future (not *too* soon, since if a guest really did
> +	 * set a long timeout on purpose we don't want to keep
> +	 * churning CPU time by waking it up).
> +	 */

I'm going to massage this slightly, partly to take advantage of reduced indentation,
but also to call out when the workaround is applied.  Though in all honesty, the
extra context may just be in response to a PEBKAC on my end, as I misread the diff
multiple times.

> +	if (linux_wa) {
> +		if ((unlikely((int64_t)guest_abs < 0 ||

No need for a second set of parantheses around the unlikely.

> +			      (delta > 0 && (uint32_t) (delta >> 50) != 0)))) {

And this can all easily fit into one if-statement.

> +			delta = 100 * NSEC_PER_MSEC;
> +			guest_abs = guest_now + delta;
> +		}
> +	}

This is what I'm going to commit, holler if it looks wrong (disclaimer: I've only
compile tested at this point).

	/*
	 * Xen has a 'Linux workaround' in do_set_timer_op() which checks for
	 * negative absolute timeout values (caused by integer overflow), and
	 * for values about 13 days in the future (2^50ns) which would be
	 * caused by jiffies overflow. For those cases, Xen sets the timeout
	 * 100ms in the future (not *too* soon, since if a guest really did
	 * set a long timeout on purpose we don't want to keep churning CPU
	 * time by waking it up).  Emulate Xen's workaround when starting the
	 * timer in response to __HYPERVISOR_set_timer_op.
	 */
	if (linux_wa &&
	    unlikely((int64_t)guest_abs < 0 ||
		     (delta > 0 && (uint32_t) (delta >> 50) != 0))) {
		delta = 100 * NSEC_PER_MSEC;
		guest_abs = guest_now + delta;
	}

