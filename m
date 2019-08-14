Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5415D8D4B2
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 15:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfHNN3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 09:29:24 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42582 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbfHNN3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 09:29:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id b16so14393045wrq.9
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 06:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vt6M8evguG8mza7xAGCORpRNGIMSe6MxiCbo5YivOBk=;
        b=Nz4o7XxH5ZDfV3rc5oZpN4MYoyO9vvdG/xPkDlLAfNNnLMvtBDyL1WBwUJp/Yr+89t
         4TPrVf45BvCer6GxhUntgjf6cWCeAm8a5UYqnXs3Em6W6mxBKz7cNy8mEA39ycKJJawY
         fDVrwvX+RhKDiWbt8rVYhSbuZi6aqCFlgXnl872f3MVFq2wNVljCmqvlKJG5vF7kKOXR
         IgyeZD+YRMaYObLza/tYUverH16I6bu1wCfY2kKs5IrB+e2rasPLvOpxdJFqqKOhfWog
         xDBOliCilX2aCsp/xUPanp8kegSVR/2gCZyuqfNLQ9GZ0LUKRkAz+kBonQEV9cY/Xm8Z
         akyA==
X-Gm-Message-State: APjAAAX3QMH8QaVjikU874QYfwoAFoQ83w7rUalCT3WLYRrDQ43FuIBh
        8A3Jxw9F8HmdgEMu4oM3n9Rv+L9BjZc=
X-Google-Smtp-Source: APXvYqwGUCBvQIFvJWsaQjWF1pIdbcTuoqLxKp8M4Us+qFA7PbNgUf7dCVRKH2NabDANH5yzssaA8g==
X-Received: by 2002:adf:fc87:: with SMTP id g7mr48053642wrr.319.1565789362015;
        Wed, 14 Aug 2019 06:29:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2cae:66cd:dd43:92d9? ([2001:b07:6468:f312:2cae:66cd:dd43:92d9])
        by smtp.gmail.com with ESMTPSA id f18sm8245770wrx.85.2019.08.14.06.29.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 06:29:21 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: skip populating logical dest map if apic is not
 sw enabled
To:     Bandan Das <bsd@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <jpgv9v076ym.fsf@linux.bootlegged.copy>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <aee50952-144d-78da-9036-045bd3838b59@redhat.com>
Date:   Wed, 14 Aug 2019 15:29:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <jpgv9v076ym.fsf@linux.bootlegged.copy>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/19 05:37, Bandan Das wrote:
> 
> recalculate_apic_map does not santize ldr and it's possible that
> multiple bits are set. In that case, a previous valid entry
> can potentially be overwritten by an invalid one.
> 
> This condition is hit when booting a 32 bit, >8 CPU, RHEL6 guest and then
> triggering a crash to boot a kdump kernel. This is the sequence of
> events:
> 1. Linux boots in bigsmp mode and enables PhysFlat, however, it still
> writes to the LDR which probably will never be used.
> 2. However, when booting into kdump, the stale LDR values remain as
> they are not cleared by the guest and there isn't a apic reset.
> 3. kdump boots with 1 cpu, and uses Logical Destination Mode but the
> logical map has been overwritten and points to an inactive vcpu.
> 
> Signed-off-by: Radim Krcmar <rkrcmar@redhat.com>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> ---
>  arch/x86/kvm/lapic.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 685d17c11461..e904ff06a83d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -216,6 +216,9 @@ static void recalculate_apic_map(struct kvm *kvm)
>  		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
>  			new->phys_map[xapic_id] = apic;
>  
> +		if (!kvm_apic_sw_enabled(apic))
> +			continue;
> +
>  		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
>  
>  		if (apic_x2apic_mode(apic)) {
> @@ -258,6 +261,8 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
>  			static_key_slow_dec_deferred(&apic_sw_disabled);
>  		else
>  			static_key_slow_inc(&apic_sw_disabled.key);
> +
> +		recalculate_apic_map(apic->vcpu->kvm);
>  	}
>  }
>  
> 

Queued, thanks.

Paolo
