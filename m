Return-Path: <kvm+bounces-7339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5367E8408BC
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 15:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 780821C2329B
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 14:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA73D15351B;
	Mon, 29 Jan 2024 14:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mm/sS8YI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B9C153510
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 14:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706539155; cv=none; b=SuvXS1MvAfHuDUVL1vxEkkQ0gDwC/IWjFBtdOk3ZKw3PN7TlYpcsz0YtDCnfM8/HSe+tHFU7SbIjO8jOSLn00yETNNdNdXqeciJjRIkAOPQJ1WGo32oHcyp4HvPGQOJikz0mGTPQsk4VIY+inmg5yR8rAsQuTv/w0QSZMM+7GLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706539155; c=relaxed/simple;
	bh=w6xOEn8WKgVePaayx4M9kPgAo/U2r1uyqckzN4gOE88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J8s5LFb0lxzcTSadef3C2GOhmwWGhCgCYL2rZeE+bKFbe7z1tgn+GU78HLk5w1yxj1kOORLeL8sj3icFYVrR4vCD0L1UsmMJPaVxLOxB/zYY9p83v/UEKJ3GTcp5vTT+HR50yLWTm1tnhkbqFO4bZWdf7ppnY1y3EWOkXSgbnwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mm/sS8YI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706539152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+lTtJ8uhAys/SPsnMLyyxEvKNPaV7nrfyTBriA7a36I=;
	b=Mm/sS8YIy8V4lO1YnYtbF2qgAYZIqrv/FgTMSi44nOCOfNtS+otFZ0k5K/O7gPnTnUYk/X
	I/BuQjPsDYhH4/BcsdCCa2y7o7HRj4lBZExrT5mfxxDG4r2Uok/ZfEcmAL6VH0C7d5efxK
	wKmzIC5vMpwI/P8VuQr6qFEaLju4dAc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-KXdzKPAlMw2CdCzbpjvbEw-1; Mon, 29 Jan 2024 09:39:10 -0500
X-MC-Unique: KXdzKPAlMw2CdCzbpjvbEw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-55f1f9c3ae5so285612a12.3
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 06:39:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706539149; x=1707143949;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+lTtJ8uhAys/SPsnMLyyxEvKNPaV7nrfyTBriA7a36I=;
        b=rpSkQiW5AICoaGLrj+U3Sk8qqNyObf10cUUaXtK62cDw0He4prhP15tu+NvLIwnJqR
         065pVqzdPRaFpTO+hyaGZgRFTrlrxtLJB1PCjxq9hhQMKDCZwZOdF2mfmvru5BSVsDmk
         Ydxa/gSaHqPUXKNkW00sIKRpn7btlWEb7GiNKVf1kFAvvdKsZrFIBiA0Z3Py1NBu81c4
         ewZnGLq0vv+Sdc5XHR+LEv3XQZAXGnehxOczeAMhGarSjejy7QhpNnejZZG+yBVTU4YP
         TO8Mryr/7nxSsXVc3nMAcQ+ZRKeSBLO57/9vOlJbdrTPCIxk8WrSm4bzXiSihzJhLASt
         LZxw==
X-Gm-Message-State: AOJu0YzAkwEcxHW2f3O2t1bk3XTenElly0TZ2al3j6Fs1Vp6k+pis1Yf
	zkk5fe7sFsKJVw6JQrXrC+xRwYYQDe7kqqO+KA5yn/6Rvzn8IZmxZTCMXgABjqXIHAfqKUQXF0W
	HjUrNGhA40G/wVrk+GiajdmYUm0JWBfDthkTlLWsHAxuihdpuhg==
X-Received: by 2002:a17:906:2290:b0:a35:57b6:4c0b with SMTP id p16-20020a170906229000b00a3557b64c0bmr3301764eja.45.1706539149613;
        Mon, 29 Jan 2024 06:39:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxClIAdQMqK8I0v8hoE8/MCNpvuwqMHyq6XhB6OENTtpRI1leE0cv6tj49DwtQ2/Wd2tFOHA==
X-Received: by 2002:a17:906:2290:b0:a35:57b6:4c0b with SMTP id p16-20020a170906229000b00a3557b64c0bmr3301754eja.45.1706539149227;
        Mon, 29 Jan 2024 06:39:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id vg14-20020a170907d30e00b00a30f3e8838bsm3963169ejc.127.2024.01.29.06.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 06:39:08 -0800 (PST)
Message-ID: <b0b5ba26-505e-4247-b30d-9ba2bb0301c1@redhat.com>
Date: Mon, 29 Jan 2024 15:39:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0 if
 PDCM is disabled
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240124003858.3954822-1-mizhang@google.com>
 <20240124003858.3954822-2-mizhang@google.com> <ZbExcMMl-IAzJrfx@google.com>
 <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
 <ZbGAXpFUso9JzIjo@google.com> <ZbGOK9m6UKkQ38bK@google.com>
 <ZbGUfmn-ZAe4lkiN@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZbGUfmn-ZAe4lkiN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/24/24 23:51, Sean Christopherson wrote:
>> If we follow the suggestion by removing the initial value at vCPU
>> creation time, then I think it breaks the existing VMM code, since that
>> requires VMM to explicitly set the MSR, which I am not sure we do today.
> Yeah, I'm hoping we can squeak by without breaking existing setups.
> 
> I'm 99% certain QEMU is ok, as QEMU has explicitly set MSR_IA32_PERF_CAPABILITIES
> since support for PDCM/PERF_CAPABILITIES was added by commit ea39f9b643
> ("target/i386: define a new MSR based feature word - FEAT_PERF_CAPABILITIES").
> 
> Frankly, if our VMM doesn't do the same, then it's wildly busted.  Relying on
> KVM to define the vCPU is irresponsible, to put it nicely.

Yes, I tend to agree.

What QEMU does goes from the squeaky clean to the very debatable 
depending on the parameters you give it.

With "-cpu Haswell" and similar, it will provide values for all CPUID 
and MSR bits that match as much as possible values from an actual CPU 
model.  It will complain if there are some values that do not match[1].

With "-cpu host", it will copy values from KVM_GET_SUPPORTED_CPUID and 
from the feature MSRs, but only for features that it knows about.

With "-cpu host,migratable=no", it will copy values from 
KVM_GET_SUPPORTED_CPUID and from the feature MSRs, but only for *feature 
words* (CPUID registers, or MSRs) that it knows about.  This is where it 
becomes debatable, because a CPUID bit could be added without QEMU 
knowing the corresponding MSR.  In this case, the user probably expects 
the MSR to have a nonzero.  On one hand I agree that it would be 
irresponsible, on the other hand that's the point of "-cpu 
host,migratable=no".

If you want to proceed with the change, I don't have any problem with 
considering it a QEMU bug that it doesn't copy over to the guest any 
unknown leaves or MSRs.

Paolo

[1] Unfortunately it's not fatal because there are way way too many 
models, and also because until recently TCG lacked AVX---and therefore 
could only emulate completely some very old CPU models.  But with "-cpu 
Haswell,enforce" then everything's clean.


