Return-Path: <kvm+bounces-13875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7875A89BDD7
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFA81B23AEA
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 11:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B1565190;
	Mon,  8 Apr 2024 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hl3CpN/V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C368464CCC
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 11:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712574769; cv=none; b=Bn2Y+mfjHGGYt7Bo+kJdT0k5OHiSazbgD9Whteq0R1Ag5Xxwtks7rUaH5hTE/RFnv5WBv+1iXINjDcoC9PgCTIOi5MtFwLD9rYVz0M8l+MvS9WAsuHjVM1Zw3ZOoLOszYIjYfTr42MPyMnOXfO/R9K8vGsvBXrrZ2WhSJXB2Qes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712574769; c=relaxed/simple;
	bh=o8/yUrS+9ELgoOfSv/5fx2tLnA/jbX8Cuy7sNcw5WCo=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ftxtIONwewb9wvU7z5fu6f/wxCTIzshSkyfLponIB+ARgNsatUCV2JfeklGHwleYWugSHxpm1+SeyP0EDD6Gz1c0HD1EqUmvZiwYiD9endOxkVpvOeGTNEBFIVrqtm+AT91XHFuElA8WmGhOT/a5AIV89PtD9gZmW0WDcRFOFUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hl3CpN/V; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-516d1c8dc79so4453944e87.1
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 04:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712574766; x=1713179566; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hmqn09jB4V1hPxALBNC3FvTX0YV044zbkMnwxUCbYIU=;
        b=Hl3CpN/VEaXcui7VNdv4ulSOgQjDqr/Sa+98M/k9KdALA+XMICIxA3aDjsEwysB22S
         zMxYQbC8zJhw5XilAVzwNTMT4PjKC3Qxd3WhW9VGYuemfTVR5bFwEW03w5L1HO54XzdL
         JR+v6Sr8rr7CsZ8SYB0ulImmF+E9C9c3xtEYM9TLgUM9zu19/n76BIvhg+pnkjGHnn3H
         3w7w7pq4chQ4hSR6VC9T97Za/MfCHzE3GewxLdZ/CNdUkLNywAzwLIAvds5yGeByM3C4
         ZiyHGvgTvtHTZLMbkbNkl0kbzeiGE2gaj0sdZqpN8MfJkeK8J2LjR0AsYvO9fGOLhex+
         VwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712574766; x=1713179566;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hmqn09jB4V1hPxALBNC3FvTX0YV044zbkMnwxUCbYIU=;
        b=CyiWJ0xHJnllUa7vBReHVLPux/aOZS0DPb3+DeQqXKrIS4EObjNyIbdUOeK6abXKQ8
         YFFjaVScm8WayrwGs5uSainkqJP6YhnCLmSHhBT6w5Oib6MPfy9hxoy/HgPjalo9E8xq
         KCIe0CEn1kly5R/UdDZ+bGy1/mkZ5Nuxs7nJMKnRzNMZyBnVaqHdsl4tsudTkcTe4UH1
         RaaxH4jdhjNaOjRHdT5yd5KMDkHXpZdNQRpnlWyuNHzkSKiHrMQG8/AG7lbkWdDDEhii
         qOyKzniiDcZjOojP9Cy/L0bNSaD/2Tjbyr+OOU1Li5EI8S8lJNOYZFaWTkidEiuG5yAf
         XkBw==
X-Forwarded-Encrypted: i=1; AJvYcCUvsRpqNGeFkxq/QIzrztZ6p8LFDnz29+8xHYCAtymdttigf3cYbG9hgYuQdn3XOwmpP5xrRLjiibkHe4XHAJ+mCMTp
X-Gm-Message-State: AOJu0YyYHaFTF5S61w5uH9vcKkXPLvq7zqin54W4YAxdNw453NdCGJ5l
	1/4pe13m7Nu6yGKlZ+oITThVepCjvnfUzSRHK5d60o0WBfFdKpq0
X-Google-Smtp-Source: AGHT+IGHIdtsmX0OQqTZFtNaU36YkUHKK3NtoszmOpMj7gGfvXyIFRVXpIr9wt8YdEhXDbfQNJdqqQ==
X-Received: by 2002:a19:740c:0:b0:515:ab7b:fc23 with SMTP id v12-20020a19740c000000b00515ab7bfc23mr6048453lfe.34.1712574765615;
        Mon, 08 Apr 2024 04:12:45 -0700 (PDT)
Received: from [10.24.66.14] ([15.248.2.234])
        by smtp.gmail.com with ESMTPSA id co24-20020a0564020c1800b0056e3d80ca71sm3260132edb.35.2024.04.08.04.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Apr 2024 04:12:45 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <7b037cb0-d876-462a-8a22-c18feef2f959@xen.org>
Date: Mon, 8 Apr 2024 12:12:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM: x86/xen: Do not corrupt KVM clock in
 kvm_xen_shared_info_init()
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
 Jim Mattson <jmattson@google.com>, Simon Veith <sveith@amazon.de>,
 Jack Allister <jalliste@amazon.co.uk>,
 Joao Martins <joao.m.martins@oracle.com>
References: <7e0040f70c629d365e80d13b339a95e0affa6d61.camel@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <7e0040f70c629d365e80d13b339a95e0affa6d61.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 07/04/2024 14:15, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The KVM clock is an interesting thing. It is defined as "nanoseconds
> since the guest was created", but in practice it runs at two *different*
> rates — or three different rates, if you count implementation bugs.
> 
> Definition A is that it runs synchronously with the CLOCK_MONOTONIC_RAW
> of the host, with a delta of kvm->arch.kvmclock_offset.
> 
> But that version doesn't actually get used in the common case, where the
> host has a reliable TSC and the guest TSCs are all running at the same
> rate and in sync with each other, and kvm->arch.use_master_clock is set.
> 
> In that common case, definition B is used: There is a reference point in
> time at kvm->arch.master_kernel_ns (again a CLOCK_MONOTONIC_RAW time),
> and a corresponding host TSC value kvm->arch.master_cycle_now. This
> fixed point in time is converted to guest units (the time offset by
> kvmclock_offset and the TSC Value scaled and offset to be a guest TSC
> value) and advertised to the guest in the pvclock structure. While in
> this 'use_master_clock' mode, the fixed point in time never needs to be
> changed, and the clock runs precisely in time with the guest TSC, at the
> rate advertised in the pvclock structure.
> 
> The third definition C is implemented in kvm_get_wall_clock_epoch() and
> __get_kvmclock(), using the master_cycle_now and master_kernel_ns fields
> but converting the *host* TSC cycles directly to a value in nanoseconds
> instead of scaling via the guest TSC.
> 
> One might naïvely think that all three definitions are identical, since
> CLOCK_MONOTONIC_RAW is not skewed by NTP frequency corrections; all
> three are just the result of counting the host TSC at a known frequency,
> or the scaled guest TSC at a known precise fraction of the host's
> frequency. The problem is with arithmetic precision, and the way that
> frequency scaling is done in a division-free way by multiplying by a
> scale factor, then shifting right. In practice, all three ways of
> calculating the KVM clock will suffer a systemic drift from each other.
> 
> Definition C should simply be eliminated. Commit 451a707813ae ("KVM:
> x86/xen: improve accuracy of Xen timers") worked around it for the
> specific case of Xen timers, which are defined in terms of the KVM clock
> and suffered from a continually increasing error in timer expiry times.
> 
> Definitions A and B do need to coexist, the former to handle the case
> where the host or guest TSC is suboptimally configured. But KVM should
> be more careful about switching between them, and the discontinuity in
> guest time which could result.
> 
> In particular, KVM_REQ_MASTERCLOCK_UPDATE will take a new snapshot of
> time as the reference in master_kernel_ns and master_cycle_now, yanking
> the guest's clock back to match definition A at that moment.
> 
> There is no need to do such an update when a Xen guest populates the
> shared_info page. This seems to have been a hangover from the very first
> implementation of shared_info which automatically populated the
> vcpu_info structures at their default locations, but even then it should
> just have raised KVM_REQ_CLOCK_UPDATE on each vCPU instead of using
> KVM_REQ_MASTERCLOCK_UPDATE. And now that userspace is expected to
> explicitly set the vcpu_info even in its default locations, there's not
> even any need for that either.
> 
> Fixes: 629b5348841a1 ("KVM: x86/xen: update wallclock region")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/xen.c | 2 --
>   1 file changed, 2 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


