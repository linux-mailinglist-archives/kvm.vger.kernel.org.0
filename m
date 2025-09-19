Return-Path: <kvm+bounces-58211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ACE0B8B6B3
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E37F1CC22E1
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521DB2D4B7C;
	Fri, 19 Sep 2025 21:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uj+xYlRt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC8B26D4DE
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319012; cv=none; b=cCCholuIRg+SQmEBo+tJPvgFj081sCGOMJYIv9dehIZvlXKwgDPGPzPrFFyUo5d+Nl/KyAj1BHxBAIHikbrsH1RHOgG753Z1QTGNLTW3b0tkScbfUE+2I0DLoxCAZ7ydU2b6nDkRLz2Yjou6lYANQwjduMw6I5LBpZgdi6jcrOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319012; c=relaxed/simple;
	bh=igHxpSnoF5Kb8JVdQPsx+6NFF2n5cn2LdylQutZ5QYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ubP8I3NgcvehtktVNF1xdv3zb9BABoMZCbP9znEYJ3DkW/7T5xj6H7yfa0nnv7WuwMsF8v6nNDVRRhBDrvHeOM40/eWEoh7ka0lLKaTOchPcszc1jMW6tnWpX2dNy8UuWq3VyBkj0TxjbjjDuVGGlHlqKUMeVVttALh63267/zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uj+xYlRt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb864fe90so3768963a91.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758319010; x=1758923810; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FSeaN0drXXPg1f9FuSTW4yBvIIFvX43DlnUrM8CS0NU=;
        b=uj+xYlRtLKZMdfdzdaTAKr/c18PRi98Xw1Im9aiHQ5kH0OpRKPa7ZG9MqzxMNMQQQy
         L9wKmD4vKTsS4CkzUT1MlTQLS69MLzM/pmyOxOWCVGkK9lUG9iwI7iqhVQLuS02Iv8C5
         vsvBjtL3/o08B+uNuy1ZKuAD5hN73L8iol8z7dh+NVYyhH1BHPJ0piWu/nSmQ53paXlj
         oDpB39Uw4fpkayaMoTMJn4x1jm0ABC46Wt9MC8LJhaSSylkvpCa1z+P/9bqA1UBqF8Zx
         FiGJeLoRHnY9FNuAwT21p6yNG66TlT53iDIKAOlhTJC+72lepj/jyr/WU3eLVHCQG3Ti
         gD5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758319010; x=1758923810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FSeaN0drXXPg1f9FuSTW4yBvIIFvX43DlnUrM8CS0NU=;
        b=DYE9Cw1/7aVsE1QtFXs56giU2AmesCcukKZ+4NzD307UyDCnPltCYTHLbIRiyJ7RUC
         q541snKlBEZXMeeHsDFBVWi9x/pfRQtUjYYbeNIeX9WLXmS5hnPJ693OQ4FpNgn+agRd
         X6QFhYRaudcjtvt8EBKFyoYEO3M2zvm2wHUWbXjqf8BPydxQmpUGQjF1AqoEbe7TTsB4
         3J+ISdPqsjmvXRFGiZtWng1eQqXDC8LF9G4pf3pHE52LsJkR9Zm6B/Q27siQLvQsOpjg
         3wVpmLsvbByia/eDT8WFTpcKCH3PLpsoaJgkKQjv7Mdc/FCj6Zhr+aVUVKqb/JvCNk/i
         uV/w==
X-Forwarded-Encrypted: i=1; AJvYcCXx4UItrRMcklFFAhjDOb56U7SD43qLCwWPU8Ftw47ZN/oVmeaSfBK1uhzXJILemXnrXic=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb7FWPI4qbnU5UCL3sw0UNdsFpShNad/HokwakoH5pUB6/p0ac
	cu8a4vBmxlIsXl11x4kRMB9SxfU6ududDZucwFzgBvp7nmYiuHJco09YbQj90qHAgCTE3vfGlEp
	ehC31Fw==
X-Google-Smtp-Source: AGHT+IFHHJ+E5msUuNFmJGIGLmjlzaUahnz2PVA54G+cCjdH3Esd/tItndD375RRvkO7+PRjUFj9laNQtKA=
X-Received: from pjl13.prod.google.com ([2002:a17:90b:2f8d:b0:32d:def7:e60f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:288f:b0:329:ed5b:ecd5
 with SMTP id 98e67ed59e1d1-33098246259mr6191568a91.19.1758319010480; Fri, 19
 Sep 2025 14:56:50 -0700 (PDT)
Date: Fri, 19 Sep 2025 14:56:49 -0700
In-Reply-To: <4vqqbmsqcaeabbslmrmxbtrq4wubt2avhimijk3xqgerkifune@ahyotfj55gds>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919002136.1349663-1-seanjc@google.com> <20250919002136.1349663-7-seanjc@google.com>
 <4vqqbmsqcaeabbslmrmxbtrq4wubt2avhimijk3xqgerkifune@ahyotfj55gds>
Message-ID: <aM3RoW3MzUfp-yto@google.com>
Subject: Re: [PATCH v3 6/6] KVM: SVM: Enable AVIC by default for Zen4+ if
 x2AVIC is support
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 19, 2025, Naveen N Rao wrote:
> On Thu, Sep 18, 2025 at 05:21:36PM -0700, Sean Christopherson wrote:
> > @@ -1151,6 +1170,18 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> >  
> >  static bool __init avic_want_avic_enable(void)
> >  {
> > +	/*
> > +	 * In "auto" mode, enable AVIC by default for Zen4+ if x2AVIC is
> > +	 * supported (to avoid enabling partial support by default, and because
> > +	 * x2AVIC should be supported by all Zen4+ CPUs).  Explicitly check for
> > +	 * family 0x19 and later (Zen5+), as the kernel's synthetic ZenX flags
> > +	 * aren't inclusive of previous generations, i.e. the kernel will set
> > +	 * at most one ZenX feature flag.
> > +	 */
> > +	if (avic == AVIC_AUTO_MODE)
> > +		avic = boot_cpu_has(X86_FEATURE_X2AVIC) &&
> 
> This can use cpu_feature_enabled() as well, I think.

It could, but I'm going to leave it as boot_cpu_has() for now, purely because
the existing code uses boot_cpu_has() for X2AVIC and mixing the two adds
"complexity" where none exists.

I'm definitely not opposed to using cpu_feature_enabled() in general, just not
in this case (of course, we could just swap them all, but meh, it's init code).

