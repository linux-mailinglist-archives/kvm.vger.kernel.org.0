Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C171F966D
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 14:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbgFOMVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 08:21:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37076 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728510AbgFOMU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 08:20:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592223658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EasL+iwudDwaX8fibQYpdgDm70QqjTjs/gR6LEEX8a0=;
        b=RfL5Nk8J7AbVEgxFd4sDxy+0Zwl59bO188ce+ug/i7jiSYTwWg/CBODAIMvW9HqSzUiNx4
        JRQl7XJkdqybE+svApjosqCqX6WtZjZ+r8oa2pOfENeaqhto/4i8n0Cz2th89ivJwjdhws
        gE1CX+8dIrhaJV/snY9l54xkN4SDwFY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-lrrSCWmEMBGUDwD1wy_KAA-1; Mon, 15 Jun 2020 08:20:56 -0400
X-MC-Unique: lrrSCWmEMBGUDwD1wy_KAA-1
Received: by mail-wr1-f72.google.com with SMTP id t5so6960260wro.20
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 05:20:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EasL+iwudDwaX8fibQYpdgDm70QqjTjs/gR6LEEX8a0=;
        b=n5hAvkAwhBSIkDa7WI98orudev9BPFOnHHw44GAF502zK+e4WzgGXwrcJ9LtQjxhY7
         VrLPCJjlbmJptBg/kYZb3geX+/6whoua+IDPuoSpnEROckT9zntaXJIozPhqCqR9hkNv
         7f8Rt+72qrJpm3itsCLLGKSMhY6Z0i1F6PMGYYucdLijT+y8npvJja4McXjsovp7JFnv
         qgCiW0MQ7DskHMkQie4BW4mXI11FLLpma9+Njb7Dm1NOct6P9H5EO0GC1qcIw2uZH3p7
         wNiMUmrZdXJjk0kbRON8A47LAIz8RvTvfyriLVRH55fJXWBL59j49fgdK05M/Bko62QQ
         htUA==
X-Gm-Message-State: AOAM531tzph4eQioJtr/j6b2Xka97ry3vei885GuKAxJgvUwMBLkMY/A
        uU5O5jRtIybFhDaMzbze4uzySrTfovJliS53dT6+LUwuLA/E5GUtHyTZdZ4PEcfRuPo6SFaFKuD
        wE4OQqwVHNMAt
X-Received: by 2002:a1c:7f44:: with SMTP id a65mr13508630wmd.53.1592223655346;
        Mon, 15 Jun 2020 05:20:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycvVgLlOpAIDjOm9FC5SXpasBxt8RV7DxdXvmAerfLLDbnhKztR199zZ/sX2GcD0DNxVfagw==
X-Received: by 2002:a1c:7f44:: with SMTP id a65mr13508611wmd.53.1592223655098;
        Mon, 15 Jun 2020 05:20:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a923:91b5:cd79:f0e8? ([2001:b07:6468:f312:a923:91b5:cd79:f0e8])
        by smtp.gmail.com with ESMTPSA id x18sm21611222wmi.35.2020.06.15.05.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 05:20:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: allow TSC to differ by NTP correction bounds
 without TSC scaling
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200615115952.GA224592@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <646f0beb-e050-ed2f-397b-a9afa2891e4f@redhat.com>
Date:   Mon, 15 Jun 2020 14:20:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200615115952.GA224592@fuller.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/20 13:59, Marcelo Tosatti wrote:
> The Linux TSC calibration procedure is subject to small variations
> (its common to see +-1 kHz difference between reboots on a given CPU, for example).
> 
> So migrating a guest between two hosts with identical processor can fail, in case
> of a small variation in calibrated TSC between them.
> 
> Allow a conservative 250ppm error between host TSC and VM TSC frequencies,
> rather than requiring an exact match. NTP daemon in the guest can
> correct this difference.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

This is the userspace commit message.  Can you resend with a better
commit message that actually matches what the patch does and explains
why the userspace patch is not enough?

Also you should explain what happens with new userspace and old kernel.

Thanks,

Paolo

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3156e25..39a6664 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1772,6 +1772,8 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
>  
>  	/* TSC scaling supported? */
>  	if (!kvm_has_tsc_control) {
> +		if (!scale)
> +			return 0;
>  		if (user_tsc_khz > tsc_khz) {
>  			vcpu->arch.tsc_catchup = 1;
>  			vcpu->arch.tsc_always_catchup = 1;
> @@ -4473,7 +4475,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		r = -EINVAL;
>  		user_tsc_khz = (u32)arg;
>  
> -		if (user_tsc_khz >= kvm_max_guest_tsc_khz)
> +		if (kvm_has_tsc_control &&
> +		    user_tsc_khz >= kvm_max_guest_tsc_khz)
>  			goto out;
>  
>  		if (user_tsc_khz == 0)
> 

