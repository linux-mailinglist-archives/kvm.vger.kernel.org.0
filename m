Return-Path: <kvm+bounces-9045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D236859EC3
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0D611F21CD8
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0C722063;
	Mon, 19 Feb 2024 08:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AiDGlo7k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A942219E9
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 08:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708332577; cv=none; b=eCDmlO6zvlormVeatcCan6eEPi7zXk+VZbMWSSPxnpRO6xb5fkC/C7ZW53aCN3PtUyaMsi9d+JW+TpjRAzUTg1R9JxPXNht7EI/HpmTBqIULXKvDPZjaUePmASUgkvU/pVVsCmz+j5oVbZ6lbcJZZah6dTdyMf83E1qirgpjeBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708332577; c=relaxed/simple;
	bh=4vrD7gURK23uvGCpvGNZ2p+JpmqgcQjE11vQoahAhrI=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WLDBmlNILDIXJxd6YYYheX/p+4Bc6CWVJcybOcyVhi2v3lb3Zi/itcCD+8oP1wyyf9+RS+oc2bcaGOpJlrGVFUyF6JjN+Fk4U2W61/IWCTcM1fA636XQrMk55g6RyRK6hQBpUeJnvq5A6L86HGbImTl8efJ7nTk1tHsNMWg5erM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AiDGlo7k; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-41262e0475bso7061865e9.3
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 00:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708332574; x=1708937374; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X5RiSOer964Ixpdf3kHLWly+q8bGNOBh0ZnJ5Jzx/xg=;
        b=AiDGlo7kMIaQvFue6xNg0Jr2B/ppqWYiNxq7/0WSZB2mprTHpTvfWX2AUUPEXzYdSr
         A6OeyejOie1CzqqouFJycZWz9IVZ2lQ1eICLaJvSJmPcfMv5CYOL8pG72I5bgXFcZNxC
         oA0PPWy9NeXKt1Uq8cIFkqYAOhz7AwqlptCvr+n916PUVFf+PI7SX7k65IiR/v5nNf83
         EAqsAVJB0oYJQAJ3ckauPjLs6OED1BPWOfwWmMD94DP0ujk+U0K3gRW/zBJXnIkV/k3f
         rIJn21AEaGkB7dk096Nc0paCKGZSsTz4MSacZAxzsBukYfx96Glye3pC3xCJA+Ji/x7o
         biuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708332574; x=1708937374;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X5RiSOer964Ixpdf3kHLWly+q8bGNOBh0ZnJ5Jzx/xg=;
        b=SnKH6XYv9p8S8HSa3iuCARk88O8gGFIK342urKv4H4QpUExSbhDD4EmJRGob6b3jzK
         DBClw9CUnkUq9Tkz2gm5nYOjpVdbRopbYDNGiZYV1k3PnfaNy9UNc2fmKSkkU6g6t6nL
         WZdHQPqYgmHVC2ihGZUGDy6xAXUKwmkIZIuOCMlZyDWKrg5rGCiGNIekPyp4G0DofHKh
         gsolHtqAKYXowAMdUN1iUPF5BwznHwuYfMeHH+3Dln6pkXb93BylxpNTw9W5zi3IH76S
         z6Rc+gpg1FWzegOwT6dQ4wvtR15YMxrKF5HRu4TeB8equSxklRiENO5Hz+KHvrJzLdTp
         3kDQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4Dr256dVeF5/fabWREFxsXHmN00sKRtcpDzTA0Xu3JknxNCqOiLudLPP+4/LdqM0E6wIMl3yyHuSK24YyimPQtQ02
X-Gm-Message-State: AOJu0YyJrQ0GzbWBlZw6R4/kkmoIVPEJjnKFobgaOReaNBJtmBovtFd0
	rraSqdo+jtrQ1Aei88NczCIQVCRg4k+cXr74cbw6+epkfjYRqvF3
X-Google-Smtp-Source: AGHT+IH2lmTLLyIaoNtEhxUCozhXsQuql/Fu74YFwRCxpvOtddzYmlmUF4A6afeO3E5fuHS7q/2c4w==
X-Received: by 2002:a05:600c:1e02:b0:412:66ef:4b3c with SMTP id ay2-20020a05600c1e0200b0041266ef4b3cmr1496780wmb.18.1708332573682;
        Mon, 19 Feb 2024 00:49:33 -0800 (PST)
Received: from [192.168.6.211] (54-240-197-228.amazon.com. [54.240.197.228])
        by smtp.gmail.com with ESMTPSA id 13-20020a05600c020d00b00410dd253008sm10567310wmi.42.2024.02.19.00.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 00:49:33 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <c58850d7-c01b-4b49-be78-511554ecae71@xen.org>
Date: Mon, 19 Feb 2024 08:49:32 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 3/6] KVM: x86/xen: remove WARN_ON_ONCE() with false
 positives in evtchn delivery
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>,
 David Woodhouse <dwmw@amazon.co.uk>
References: <20240217114017.11551-1-dwmw2@infradead.org>
 <20240217114017.11551-4-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20240217114017.11551-4-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/02/2024 11:27, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The kvm_xen_inject_vcpu_vector() function has a comment saying "the fast
> version will always work for physical unicast", justifying its use of
> kvm_irq_delivery_to_apic_fast() and the WARN_ON_ONCE() when that fails.
> 
> In fact that assumption isn't true if X2APIC isn't in use by the guest
> and there is (8-bit x)APIC ID aliasing. A single "unicast" destination
> APIC ID *may* then be delivered to multiple vCPUs. Remove the warning,
> and in fact it might as well just call kvm_irq_delivery_to_apic().
> 
> Reported-by: Michal Luczaj <mhal@rbox.co>
> Fixes: fde0451be8fb3 ("KVM: x86/xen: Support per-vCPU event channel upcall via local APIC")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/xen.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


