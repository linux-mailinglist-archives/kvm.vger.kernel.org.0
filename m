Return-Path: <kvm+bounces-9506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69AFB860E9E
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 10:51:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16FE62837B3
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 09:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 847C65D8F7;
	Fri, 23 Feb 2024 09:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GO4hnWG4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41AB5D742
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 09:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708681739; cv=none; b=OC008BrSpV2bELi8UCbJ5gzrkDt2YAD+gAWMY20VuL92ToCMvX5pF0jo6745jWUBkwh7cNhJkoSNGIa11wQUT+Q7qBZARiMddcFm3yTSi++6Yeoq4YpkC/aom7U18rkB08kAutvIskYLkOfhWov/KOmivamfh+DDI3F4dluJBjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708681739; c=relaxed/simple;
	bh=CHQ8ojToVVo2x2nBAVOg3oJvhiLAFfyJ4tNHaOYASYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AJFUoavUde2uWUdo3/zzEbknCr3twk8BDeh9TcI65EqZVoiEfTGxrW7UdpgbYs8qaivCNGJbJQfaI0MXa5AlBAEyR/KMqEi3ZiCrA+VisHpEYMKg+tjQq+7IJSCgyML7TEKo7XsUvUyqNuGhurOobJw6vU5nnb7Ofyv2uuQjsS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GO4hnWG4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708681736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ny3rlNG4dj3vSMIabxV2MPIzBtaBKbqMGyTxyLeP7EI=;
	b=GO4hnWG4YbtY3tn+JlwNjPr99Hw/8ayaYxK1ptHbB7pGkfyrIfHjXNHh/4UvqViFjnON8k
	QAWchskUwBCUsn3L7WhIa93CaKrHnUlLmhB1Lew0zYg7p4v8OM+4yHstiXMfhN1CvbYg5k
	uAtOb18o5NoghaSlg/NHQktNYKXoUdU=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-He-cyuUvMaSGV6svJFaJvA-1; Fri, 23 Feb 2024 04:48:54 -0500
X-MC-Unique: He-cyuUvMaSGV6svJFaJvA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-512add274bfso533804e87.3
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:48:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708681733; x=1709286533;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ny3rlNG4dj3vSMIabxV2MPIzBtaBKbqMGyTxyLeP7EI=;
        b=J/sFm9HtiEeLLFjYwcsT7nAySmL3duByTrKWn0Nb4lDWGljLZ068DgvLX2JbVCSq3F
         wOr2eRGuxnao0zYEou74MzYJGOuqN1gJCpD8eOSfGCobUxnLFRjZlG/WLYGEwlScnY7X
         EuonfjtGHO4qXSOuhg+M/SKdtd6DABGyA2w7XKHUPKqQV+511nZo3RXibpynH2SmwDp8
         pEYmo002Up1LWzsYHJNpSLYgI5S55y0W5/iQ07hIm9nmbv6pAErVaKC/KOFMJsBfeQ0o
         zo/gpNO18W3tPZwoUHUAHtDgwiONc4hsRmG4MJKojOK5NR10t5fucvhdxkPnuJ/G9zfM
         pjaA==
X-Forwarded-Encrypted: i=1; AJvYcCXqMv3ShYE0e6I0p3b0YKC2Q7aXsWrVNTNXel8rw2Hlzs5vxsRaFKAvmwoKy5B84ySyGUWa+1mpyeJuc3l1pU/trvis
X-Gm-Message-State: AOJu0YwKh1138RfOPvcy38PDBi21bMZsF2Rdb0wcIqP03qKYSKDwXQEg
	+aB1WsPvM5LHgm/ogsEqon20YDGOG2IfDFKRf8DExN9nLnpyk1sese3nZPgPBSMBaTcOQJ8t64E
	cS85LDsN1r4HXY8wyQ1qOZ55/2xq6pZ+IvEfcEuNx30WgHLIwyA==
X-Received: by 2002:ac2:4ec3:0:b0:512:bdd3:1539 with SMTP id p3-20020ac24ec3000000b00512bdd31539mr967271lfr.37.1708681733280;
        Fri, 23 Feb 2024 01:48:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzFi43eAzp8ls1n6lYPSL+WeUvLXTf3gmpGB+Q/29q/XRkCZHV6zgEp+R6GOxjP1qCo1xU5w==
X-Received: by 2002:ac2:4ec3:0:b0:512:bdd3:1539 with SMTP id p3-20020ac24ec3000000b00512bdd31539mr967253lfr.37.1708681732952;
        Fri, 23 Feb 2024 01:48:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id p11-20020a05600c468b00b004128812dcb6sm1740881wmo.28.2024.02.23.01.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 01:48:52 -0800 (PST)
Message-ID: <5580a562-b6ac-448d-a8fe-cedc32d33bab@redhat.com>
Date: Fri, 23 Feb 2024 10:48:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 4/8] KVM: mmu: Improve handling of non-refcounted pfns
Content-Language: en-US
To: David Stevens <stevensd@chromium.org>,
 Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240221072528.2702048-1-stevensd@google.com>
 <20240221072528.2702048-5-stevensd@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20240221072528.2702048-5-stevensd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 08:25, David Stevens wrote:
> +	/*
> +	 * TODO: Remove the first branch once all callers have been
> +	 * taught to play nice with non-refcounted struct pages.
> +	 */
> +	if (page && !kfp->refcounted_page &&
> +	    !kfp->allow_non_refcounted_struct_page) {
> +		r = -EFAULT;

Is the TODO practical, considering that 32-bit AMD as well as all 
non-TDP x86 do not support non-refcounted pages?

If the field is not going to go away, it's better to point out (in the 
definition of the struct) that some architectures may not have enough 
free space in the PTEs for the required tracking; and then drop the TODO.

> +	} else if (!kfp->refcounted_page &&
> +		   !kfp->guarded_by_mmu_notifier &&
> +		   !allow_unsafe_mappings) {
> +		r = -EFAULT;

Why is allow_unsafe_mappings desirable at all?

None of this is worth a respin, it can be fixed when applying.

Paolo


