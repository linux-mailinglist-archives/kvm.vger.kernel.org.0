Return-Path: <kvm+bounces-53560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B20CB13F36
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A99EE1895B9F
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB40F2737F9;
	Mon, 28 Jul 2025 15:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b3uOU/XQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737DB15B0FE
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 15:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753717859; cv=none; b=pXG0mWovqjKa4vqT4LY4Ii4xALlJwjwpGOTw3R5TTTsDZNylEHx0jsG6tBTHW5aCk9xCTgYSrdrV4jljrv6BdPoPfKWBSb80xQ8bMYDZFwFrCn0GYleXw/ESUzg2mTghflZTjom5R0vrQAqhJGn27bypuyvLgjAxvRqXzfdm8T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753717859; c=relaxed/simple;
	bh=WhzE3lidLwRHO+kwMdf/SBR6VxZhhr+E7oc+UD+9YQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RrPR5mE07iICZBeqKOiP7Skx3OF1rjQda0NlY/B+fvKwKk9W2YBA1do72xu52Al937XqX7wX76gmVGKOGRIu1TWIDjRfEHfFe4wMoHOuDQWMfvlZJZ2rdRQgb4g/qqpIz5QE1AvCnKJfzDOSS1p4WPmYc24Dtt0cuN42JTxPdkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b3uOU/XQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753717856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvnsZw2GbjFCVwwknnxISvFS3IJGIdRBTX2kuWZgS7A=;
	b=b3uOU/XQLtHP+keI3Ipmy4VkHz5ZUAPYbQpoznn9RIqIgcAa3vCVggx6ppL7UduQX1UTVr
	wCZzozKODQh4ptaM4/yrJyLZi2A8QrADB8X29Lbo/bV/iDa9L+IMAzpZFdVZpqoMg99brm
	0ZjXPDJbxQ7EiKLekINZWLhUy/lRURg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-k-TEeQYpPnSqNBr-RyXbFg-1; Mon, 28 Jul 2025 11:50:55 -0400
X-MC-Unique: k-TEeQYpPnSqNBr-RyXbFg-1
X-Mimecast-MFC-AGG-ID: k-TEeQYpPnSqNBr-RyXbFg_1753717854
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45626e0d3e1so29244655e9.1
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 08:50:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753717854; x=1754322654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZvnsZw2GbjFCVwwknnxISvFS3IJGIdRBTX2kuWZgS7A=;
        b=f1JjflnZf04kSp87Kbff7co+ZVkLOtAT96rOnlwCZZZ1F+vncqpUL6cLw6VukBWV1r
         TAAkDZKcTSyq553Jx3FgkEiMdmPp39KgrZ6BzzGPzfgyDednYwSLHLCfYLpD6J8ZhXWv
         J8DMT4pzwySLZwl2S+zFlRIxENgbM8B5TR+lzU/DqBUfIk27q6QXifRUbk14WqqzZo1H
         sMA2nAfteA0YbCSTwim89e5GxjKTpP3mJn2PkBaX1BANNkK/oZu7fX+5zq+Ht80Pm4/A
         c8xhmlToxq1N7MTxufYkjGv2cMM5qjadfdhbYPQbHCGuDoPO3I9DGonvWAilEg1UZQCq
         Jneg==
X-Gm-Message-State: AOJu0Yxoar82+8u6CDTSOS6HE47T7mMk1Me8nCoYYQdzV7OUZGIrVw4Q
	7Ve8GAiGxGwz7oC2Ix1lkyb7jHER44XVdmzVMuDQLb1blQGDYJrZEIz8Bl0PAu2npem5zfJFB94
	V+Y0/FvpvprdVCpyxKIHXA6nxdhkcvhslK/Hfw7gmtl8Jp4YJhtYaOh2m478Dc7OTVjUK0pFaK0
	lgHZvJCM1tToOL+0Ye0uZRwA2MNEOm
X-Gm-Gg: ASbGncvCnakVtanYemYzDpDSfo4BhTLWGD3g3OrAX/Kh3OZGnHnn4fuDgjpJcE3rDgg
	u5FdKL/ucGOuNcph4NTvdgt1IpSQMAAwEwJRAi0ng203mGSzKhs6zj3R41yHa0QgUhLWK6WISrm
	bXB30nn2AtrHGXbJZdMQfANg==
X-Received: by 2002:a05:600c:3588:b0:450:cabd:b4a9 with SMTP id 5b1f17b1804b1-4587654ac7emr85500395e9.29.1753717853762;
        Mon, 28 Jul 2025 08:50:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfdb+q01BGiMc4TlKJnax9G4goN4qXjdxL6WL3y1Aru6MtzjXxXNH+rKEKqpVFgF1TewF5jIjlDjF9Y0obvMQ=
X-Received: by 2002:a05:600c:3588:b0:450:cabd:b4a9 with SMTP id
 5b1f17b1804b1-4587654ac7emr85500165e9.29.1753717853269; Mon, 28 Jul 2025
 08:50:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 28 Jul 2025 17:50:42 +0200
X-Gm-Features: Ac12FXxNG48Pb-33Lh-mw4gRuZlRHE4shPMRl8FH35D382PoAxKWtbHSr-LzrfM
Message-ID: <CABgObfYFfOuoh5fcZCfuuZtJ2LqZe+GOASjj8O2O-vUa08pA5g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Changes for 6.17
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 26, 2025 at 12:07=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> As promised, the storm has arrived :-)
>
> There are a two anomalies this time around, but thankfully only one confl=
ict,
> and a trivial one at that (details on that in the MMIO Stale Data pull re=
quest).
>
> 1. The "no assignment" pull request depends on the IRQs and MMIO Stale Da=
ta
>    pull requests.  I created the topic branch based on the IRQs branch (m=
inus
>    one commit that came in later), and then merged in the MMIO branch to =
create
>    a common base.  All the commits came out as I wanted, but the diff sta=
ts
>    generated by `git request-pull` are funky, so I doctored them up, a lo=
t.
>
> 2. The "SEV cache maintenance" pull request is based on a tag/branch from=
 the
>    tip tree.  I don't think you need to do anything special here?  Except
>    possibly mention it to Linus if the KVM pull request happens to get se=
nt
>    before the associated tip pull request (which seems unlikely given how=
 they
>    send a bunch of small pulls).

Pulled everything except the lone TDX commit, thanks. I'm going to
start testing without it.

Paolo


