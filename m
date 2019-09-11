Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9652DB0076
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 17:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbfIKPpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 11:45:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728363AbfIKPpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 11:45:23 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 97FED11A30
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 15:45:22 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id j2so2429457wre.1
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 08:45:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8dvzBDV3dcBvAdrSrp3rimgoPNd8Y7sL0ZbKHpa3Sbk=;
        b=p5jiZhxwQpupe49YFdZnz8Xwl/DfULEfLkr0PmjGo1auybd7+1kTUq7cBlj0CsE7LV
         tHNRoTZv/+wX2f4Zk7xemB4G2cKYd2obwk7ahkqAqgWl7EkGmFU9i6o46k+KCTdnr5AD
         gg2Q3pKubpzMbqveqUYCp8TvrMSJJoTXT1gGEq5omiwl6T2g+RmVeCHB3UyAFVCFp3gO
         5iUWMrUwb9PIIIZO82f1YIeyWKU1z/UjDwLOgtEOD9tDNh0GhcqLQNyONXrve/ipL/7P
         yN2Heut2G9n85ME03+RUsbDaNH3QoAxN8/RIqD3Jy/HVoYbZlAAeXZY2PlpI96JGEANJ
         k4gA==
X-Gm-Message-State: APjAAAVP8zrHEQ+vXXX23XNS3/KTi4CBVX1SX8xbzFGwozltIT7HcBl5
        GZRtRdrLpBPoYWiA3ZRGiTgQscBEuiJd5XerxdW6KvqSQOBaeE6BKfkBHTAA3Rq8dxDNrgOq5cR
        x03Ic1Ki0214b
X-Received: by 2002:a5d:5450:: with SMTP id w16mr11023789wrv.55.1568216721321;
        Wed, 11 Sep 2019 08:45:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwP9UdiTBuy5I8iMOFwJ1GcuVJ635HWUdT53JwFA00UHZ5AruDu4dWVvIgy3uHzBtAPani9xQ==
X-Received: by 2002:a5d:5450:: with SMTP id w16mr11023771wrv.55.1568216721083;
        Wed, 11 Sep 2019 08:45:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id o11sm2591258wmc.7.2019.09.11.08.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:45:20 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1566980342-22045-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a1c6c974-a6f2-aa71-aa2e-4c987447f419@redhat.com>
Date:   Wed, 11 Sep 2019 17:45:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566980342-22045-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/08/19 10:19, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Using a moving average based on per-vCPU lapic_timer_advance_ns to tune 
> smoothly, filter out drastic fluctuation which prevents this before, 
> let's assume it is 10000 cycles.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e904ff0..181537a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -69,6 +69,7 @@
>  #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
>  /* step-by-step approximation to mitigate fluctuation */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
> +#define LAPIC_TIMER_ADVANCE_FILTER 10000
>  
>  static inline int apic_test_vector(int vec, void *bitmap)
>  {
> @@ -1484,23 +1485,28 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
>  					      s64 advance_expire_delta)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> -	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
> -	u64 ns;
> +	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns, ns;
> +
> +	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_FILTER)
> +		/* filter out drastic fluctuations */
> +		return;
>  
>  	/* too early */
>  	if (advance_expire_delta < 0) {
>  		ns = -advance_expire_delta * 1000000ULL;
>  		do_div(ns, vcpu->arch.virtual_tsc_khz);
> -		timer_advance_ns -= min((u32)ns,
> -			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> +		timer_advance_ns -= ns;
>  	} else {
>  	/* too late */
>  		ns = advance_expire_delta * 1000000ULL;
>  		do_div(ns, vcpu->arch.virtual_tsc_khz);
> -		timer_advance_ns += min((u32)ns,
> -			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> +		timer_advance_ns += ns;
>  	}
>  
> +	timer_advance_ns = (apic->lapic_timer.timer_advance_ns *
> +		(LAPIC_TIMER_ADVANCE_ADJUST_STEP - 1) + advance_expire_delta) /
> +		LAPIC_TIMER_ADVANCE_ADJUST_STEP;
> +
>  	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
>  		apic->lapic_timer.timer_advance_adjust_done = true;
>  	if (unlikely(timer_advance_ns > 5000)) {
> 

This looks great.  But instead of patch 2, why not remove
timer_advance_adjust_done altogether?

Paolo
