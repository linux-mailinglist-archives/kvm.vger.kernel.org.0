Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D72E2579AB
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgHaMsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:48:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33937 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726927AbgHaMsV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Aug 2020 08:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598878099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cnx3CjRYB9hGIWsNjQqszr2co7+0ihfxtc0QgvVHV+M=;
        b=LNasvsZ7SbEDYQjMM8xGySdh47Bqssi4QRR6ArndKIreMwD47UyY/ENbizOi6N3MK23wz3
        I7TKbXDI2orI6jBeu/uMcB2qDBnShIL7Tj7c+zuCf8IZwherbJ4BLcdrqzKtt4o/p5y9+c
        zDg+mLx+uanv+ZI3VOSmYYDU9XzTgnE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-1codpAUsPsWPQLHyynoZuQ-1; Mon, 31 Aug 2020 08:48:15 -0400
X-MC-Unique: 1codpAUsPsWPQLHyynoZuQ-1
Received: by mail-wr1-f69.google.com with SMTP id r15so3175982wrt.8
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 05:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cnx3CjRYB9hGIWsNjQqszr2co7+0ihfxtc0QgvVHV+M=;
        b=aAyCxCUsbOjeUmu/u0FZEVr60fnuhX7fKaZVMlonuNvrFQv3g3AUFtV8W+c27Qw324
         ilVN6CbuvWLEeihn8SyE0M6pQ8vPwe3c5GHEDnp2K7f3JetvmeX9koigne1YTa6XpvDP
         CiN/VDulGxiJ3l4uk/Hp9md52H1lV2c396Bugp0fhVSoUffTN+XdAvBW2nENqNBojcMH
         JNhq+p8iYhBDv1qaw3kOLjtiHhtRb+D+ThnaoSSO7i44L74NCfI99RZGjtiSC34lb99G
         mtR3g2Sf0fqtkWSohcMS++73DsJ8xYiTJkCqHNPFPwqKFpwuOtCCwZTctuEsr/gmllRj
         5e8A==
X-Gm-Message-State: AOAM530ZseR9QKhCCbjVPieVTfoiDnpxq+Nh2lDNiigkwXLosPDgPkMa
        iewMhVA7Gdw6vBFvShtvP8wLlT3L+OqqpJmjqnH9onz1rYD2X0uBgCTyfm5FNtY2MdWcRLPsg6J
        6l299HB2UMfOY
X-Received: by 2002:a1c:2e17:: with SMTP id u23mr1319221wmu.73.1598878094354;
        Mon, 31 Aug 2020 05:48:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwc3ks723eU0MJaIHVO/d8tt1FXCDACXwreTLs0dlEDnbVrsUC4Kux9ZLcT5gY6wvSD7o4bJg==
X-Received: by 2002:a1c:2e17:: with SMTP id u23mr1319205wmu.73.1598878094196;
        Mon, 31 Aug 2020 05:48:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 62sm12384616wre.60.2020.08.31.05.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 05:48:13 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: LAPIC: Reset timer_advance_ns if timer mode switch
In-Reply-To: <1598578508-14134-1-git-send-email-wanpengli@tencent.com>
References: <1598578508-14134-1-git-send-email-wanpengli@tencent.com>
Date:   Mon, 31 Aug 2020 14:48:12 +0200
Message-ID: <87a6ybx9pv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> per-vCPU timer_advance_ns should be set to 0 if timer mode is not tscdeadline 
> otherwise we waste cpu cycles in the function lapic_timer_int_injected(), 

lapic_timer_int_injected is just a test, kvm_wait_lapic_expire()
(__kvm_wait_lapic_expire()) maybe?

> especially on AMD platform which doesn't support tscdeadline mode. We can 
> reset timer_advance_ns to the initial value if switch back to
> tscdealine

'tscdeadline'

> timer mode.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 654649b..abc296d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1499,10 +1499,16 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
>  			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
>  			apic->lapic_timer.period = 0;
>  			apic->lapic_timer.tscdeadline = 0;
> +			if (timer_mode == APIC_LVT_TIMER_TSCDEADLINE &&
> +				lapic_timer_advance_dynamic)
> +				apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
>  		}
>  		apic->lapic_timer.timer_mode = timer_mode;
>  		limit_periodic_timer_frequency(apic);
>  	}
> +	if (timer_mode != APIC_LVT_TIMER_TSCDEADLINE &&
> +		lapic_timer_advance_dynamic)
> +		apic->lapic_timer.timer_advance_ns = 0;
>  }
>  
>  /*

-- 
Vitaly

