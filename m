Return-Path: <kvm+bounces-43095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7090BA848E3
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 17:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA5FA3BECA8
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 15:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D221E1EF0B0;
	Thu, 10 Apr 2025 15:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IkZFaSgD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC231E9B2F
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 15:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744300281; cv=none; b=ADKC/LQsC7IpZqvkTzYGI+KUdrBIr7t6RnfU4pslEDMkzt28dS1VeC2D9r2KlVypR+Xwi4jZvRnZdiZNSxn+Yux9JjAEiU1jM2r/vFYYLCCvr1OonKUPNYaqrUytTZ2FBrJ+0eLHJdT218X+7A2TorOFUJHhbzzWB9cAKcsj5cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744300281; c=relaxed/simple;
	bh=I1HL4EhttE881MicAtF32b66FddNBn0rz1b+bJ5vSpI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q9D/lVgd5G0rbkxcKvUSzgTxvjY0+y2DmvoMmD7BuRdisCToW3rEC32qsCpeIgkzpsXWg2wHcpSjiaRMbduSuH+KJdh3wsqRtflvLIqHun2DwfXO1kTR8Mg/mqFjeuGNHak8NR5ppIfNd/u5Gm7wzLcuXdAt6opyv3Y4HZTGuoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IkZFaSgD; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22403329f9eso8455015ad.3
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 08:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744300280; x=1744905080; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WI+w75MsGfdj1Z+7uV4Y8gvQFBHXDpFpnvwgAEL/2AQ=;
        b=IkZFaSgDMxVLDJYiztqhLWeJ9BKaBmCbT7F4CFXTzXGHk78dhVZw31jouCnNDop6qG
         LyvJ2AGGW9B/NjGJES68OuKAKaLBwFvD2KGUWdvUlsG1f0aD8K6C+rGbK5ysE6vJ1dDv
         +K+JpZcy29v0dUf1sfGwTYaAYrUFfG7GrYAzIQi7CH+jkldW1WG3aBanwL1UNOUAXBRV
         bHMPWtECNA0qzJQhzQzy4ceyGFHvF2uUxZwwYnkpxqCNMe6h/tq8OFE5STxYBiSEa0NU
         lfHoRRzZvrm0R3beELu0HF0TwdJm5QdJx8sDTJg7rPPsfd5OuFieaYBGI8NvdpPXr494
         9s4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744300280; x=1744905080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WI+w75MsGfdj1Z+7uV4Y8gvQFBHXDpFpnvwgAEL/2AQ=;
        b=aycQTpUvJVn/stzRk4SmDdVDPdL51xTn84VsLFmhMx57pLusE4PQmCNn8Apc1n3hEa
         wrrD61A7jv1nDMK8ZDWEJIbk42cbjMr5i8x5Ry9urVEYejxSndHKYXVe6wfSYYhtpKRq
         9D9yZiM72kC2zKUfxNDIkrCNC+OabazEV8WptqK+OXxBDsKsFMrqq2OE/GWeX5/Pw12K
         pE6Xcikse5rkDqi8FAk7AvE0avqAkyB6+BQIZamW3dE7QXssxZezg4tGq+IJDRBO+t4M
         vmYnMUIDFXqVQrmVm4yklNUQJJK/ZK65IwlZ2EHN/YYIiQFo8Zi8AP6zJhZ7bs0UV57L
         cUFA==
X-Forwarded-Encrypted: i=1; AJvYcCXaCj6btajPVIdzrpqhxJ4E3hPAa6urLdTVbyFWwtCuGN04oNq3FLLdHEHREM+ck8dvRl4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzELfJ7SQxF3ySpa7lxXzuN7tZ5NuYVJLVNrNOTYmeNyJYN6bcE
	RBZlNCko4LoaJYC3tEEOuVY9f36MTiI9modbNCLjPoK1NRJsdtPPcRL2cl/gJAmrOV36gWYeD3Z
	tgQ==
X-Google-Smtp-Source: AGHT+IHHdPvjX46b6rya58AVmth99Sr4qyG2wQ8QULk3PUwKRfJK74c4z91IfDSthvFsL0y+9dnZ4azBoYg=
X-Received: from plsb7.prod.google.com ([2002:a17:902:b607:b0:229:2f8a:d4ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4cf:b0:220:d601:a704
 with SMTP id d9443c01a7336-22be0302063mr29493945ad.18.1744300279479; Thu, 10
 Apr 2025 08:51:19 -0700 (PDT)
Date: Thu, 10 Apr 2025 08:51:18 -0700
In-Reply-To: <BN9PR11MB5276385B4F4DB1919D4908CF8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404211449.1443336-1-seanjc@google.com> <20250404211449.1443336-4-seanjc@google.com>
 <BN9PR11MB5276385B4F4DB1919D4908CF8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
Message-ID: <Z_fo9hPpSfpwi5Jn@google.com>
Subject: Re: [PATCH 3/7] irqbypass: Take ownership of producer/consumer token tracking
From: Sean Christopherson <seanjc@google.com>
To: Kevin Tian <kevin.tian@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 10, 2025, Kevin Tian wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > +int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
> > +				 struct eventfd_ctx *eventfd)
> >  {
> >  	struct irq_bypass_consumer *tmp;
> >  	struct irq_bypass_producer *producer;
> >  	int ret;
> > 
> > -	if (!consumer->token ||
> > -	    !consumer->add_producer || !consumer->del_producer)
> > +	if (WARN_ON_ONCE(consumer->token))
> > +		return -EINVAL;
> > +
> > +	if (!consumer->add_producer || !consumer->del_producer)
> >  		return -EINVAL;
> > 
> >  	mutex_lock(&lock);
> > 
> >  	list_for_each_entry(tmp, &consumers, node) {
> > -		if (tmp->token == consumer->token || tmp == consumer) {
> > +		if (tmp->token == eventfd || tmp == consumer) {
> >  			ret = -EBUSY;
> >  			goto out_err;
> >  		}
> >  	}
> 
> the 2nd check 'tmp == consumer' is redundant. If they are equal 
> consumer->token is not NULL then the earlier WARN_ON will be
> triggered already.

Oh, nice.  Good catch!  That check subtly gets dropped on the conversion to
xarray, so it definitely makes sense to remove it in this patch.

