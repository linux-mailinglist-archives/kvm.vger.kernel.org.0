Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15DA360368
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 11:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbfGEJut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 05:50:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35469 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbfGEJut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 05:50:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so653846wrm.2
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 02:50:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YUgV9oyAP3Ji8jA9MSEhvMmGZhPCnmuMeRDLIoIYTW0=;
        b=EtGDm2NOtJhJV/AFwwMKc8FBuVDJrqc24+/esp+zt3X9N2gWMBjH4h5zzA234m940M
         85K/0BszSFnbZl0efmVogRWMg41d80KyEIKmHWTfGdll9Mwi5+Xp0lkP4GNoFJZG6G14
         U4jjzUOL8GDkrPMg2CtY6IyJl6B5WdX8vbpvFm458Sk4ccoIzcA7MwZREOKft22McIST
         tCV0vNd2kZ/8yipCEfmIaUjZkE+vE3yawXNI5/D6DKI5PoifUHlGlYeYU+2d+CxJQaMe
         A9tZwWS/YzWL/ApnqDPawef+AMfOiv61PPjI3OMUzZd4IxHNZDqoRFjQXOEbauoygbwB
         UBDw==
X-Gm-Message-State: APjAAAVoZ/qktq3nOB0cQ/aKDWss4ivVm2Ft/VmFNjZbuVNs10DRSUC4
        QIQ/tsnAP17dMtBctFVfwffczA==
X-Google-Smtp-Source: APXvYqypJu/BEjih6IidHXtaQ3xrNB0U+85zf/Y9MMWD6a3bCmLx/E4SeqEvaBrNU348XT146MdsGQ==
X-Received: by 2002:a5d:5492:: with SMTP id h18mr3261472wrv.212.1562320246561;
        Fri, 05 Jul 2019 02:50:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:19db:ad53:90ea:9423? ([2001:b07:6468:f312:19db:ad53:90ea:9423])
        by smtp.gmail.com with ESMTPSA id z1sm8749189wrv.90.2019.07.05.02.50.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 02:50:46 -0700 (PDT)
Subject: Re: [PATCH] KVM: LAPIC: Reset timer_advance_ns to 1000 after adaptive
 tuning goes insane
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1562319651-6992-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dfdce82d-7cea-9b8d-0187-906b777d494d@redhat.com>
Date:   Fri, 5 Jul 2019 11:50:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562319651-6992-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 11:40, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Reset timer_advance_ns to the default value 1000ns after adaptive tuning 
> goes insane which can happen sporadically in product environment.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 05d8934..454d3dd 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1549,7 +1549,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
>  	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
>  		apic->lapic_timer.timer_advance_adjust_done = true;
>  	if (unlikely(timer_advance_ns > 5000)) {
> -		timer_advance_ns = 0;
> +		timer_advance_ns = 1000;
>  		apic->lapic_timer.timer_advance_adjust_done = true;

Do you also want to reset timer_advance_adjust_done to false?

Paolo

>  	}
>  	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> 

