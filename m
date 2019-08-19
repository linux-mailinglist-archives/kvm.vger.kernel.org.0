Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D6C951CF
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 01:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbfHSXmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 19:42:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbfHSXmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 19:42:36 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31CBEC058CA4
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 23:42:36 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id j10so6024462wrb.16
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 16:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=69ss2Y/C9QzM3mjPY4ekjzD1U+tiH56BFsloD4gqX0c=;
        b=UzvB5o48R72GVC2C4hue4f1fXKvCFoO34uUVsxWrdv5eW1N/qs5kGQFdYPivlaueVj
         uxf5CgaFaWONYX78c/yxmAFz3+42Inz+v0H9k5gN/oy4xRRcwVW1mObJKMPcXGNhd+kB
         zEgLvjEHnsc7JcbrWof+jEukyn0m8dvsiZ3NV1uveozmvdVZXcuWs2rJITwUS/YOau74
         pnVWb9pF0tLroF5+uYcvCnEmFhUajQx9EgtCyg+slziydckm15MAwzPCnTEbHzdUOHrx
         hwBwC74Tt63IbxcqzEvi7y8mc0RYoTL6T/agYdRFJ5iMEWX4zYAjVcdMfIJvo9+qVgc1
         CZPg==
X-Gm-Message-State: APjAAAV2zbuNXp0P2Dkp0dr6Et+FATlayVuHxjITnJ/TiPrN+xLFag+v
        LxBwsgsGPjXPGCiX5fRjOI2hGIYxyVO0QNL5Fgzfe3RHKQiLmPCYc22DZnXkqir9AZtzz58vlpQ
        wjSY905xcmH4H
X-Received: by 2002:a1c:a701:: with SMTP id q1mr21747485wme.72.1566258154688;
        Mon, 19 Aug 2019 16:42:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwAU1Wua/rzGcsh7W05xcRr3bXazmkGvUnhpMzA3KwkDTB/Y/CTs9lFeFduskXlCNpJTb/9BA==
X-Received: by 2002:a1c:a701:: with SMTP id q1mr21747474wme.72.1566258154312;
        Mon, 19 Aug 2019 16:42:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8033:56b6:f047:ba4f? ([2001:b07:6468:f312:8033:56b6:f047:ba4f])
        by smtp.gmail.com with ESMTPSA id b15sm15022473wrt.77.2019.08.19.16.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 16:42:33 -0700 (PDT)
Subject: Re: [PATCH] KVM: lapic: restart counter on change to periodic mode
To:     Matt delco <delco@google.com>, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org
References: <20190819230422.244888-1-delco@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
Date:   Tue, 20 Aug 2019 01:42:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819230422.244888-1-delco@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/19 01:04, Matt delco wrote:
> From: Matt Delco <delco@google.com>
> 
> Time seems to eventually stop in a Windows VM when using Skype.
> Instrumentation shows that the OS is frequently switching the APIC
> timer between one-shot and periodic mode.  The OS is typically writing
> to both LVTT and TMICT.  When time stops the sequence observed is that
> the APIC was in one-shot mode, the timer expired, and the OS writes to
> LVTT (but not TMICT) to change to periodic mode.  No future timer events
> are received by the OS since the timer is only re-armed on TMICT writes.
> 
> With this change time continues to advance in the VM.  TBD if physical
> hardware will reset the current count if/when the mode is changed to
> period and the current count is zero.
> 
> Signed-off-by: Matt Delco <delco@google.com>
> ---
>  arch/x86/kvm/lapic.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 685d17c11461..fddd810eeca5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1935,14 +1935,19 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  
>  		break;
>  
> -	case APIC_LVTT:
> +	case APIC_LVTT: {
> +		u32 timer_mode = apic->lapic_timer.timer_mode;
>  		if (!kvm_apic_sw_enabled(apic))
>  			val |= APIC_LVT_MASKED;
>  		val &= (apic_lvt_mask[0] | apic->lapic_timer.timer_mode_mask);
>  		kvm_lapic_set_reg(apic, APIC_LVTT, val);
>  		apic_update_lvtt(apic);
> +		if (timer_mode == APIC_LVT_TIMER_ONESHOT &&
> +		    apic_lvtt_period(apic) &&
> +		    !hrtimer_active(&apic->lapic_timer.timer))
> +			start_apic_timer(apic);

The manual says "A write to the LVT Timer Register that changes the
timer mode disarms the local APIC timer", but we already know this is
not true (commit dedf9c5e216902c6d34b5a0d0c40f4acbb3706d8).

Still, this needs some more explanation.  Can you cover this, as well as
the oneshot->periodic transition, in kvm-unit-tests' x86/apic.c
testcase?  Then we could try running it on bare metal and see what happens.

Thanks,

Paolo


>  		break;
> -
> +	}
>  	case APIC_TMICT:
>  		if (apic_lvtt_tscdeadline(apic))
>  			break;
> 

