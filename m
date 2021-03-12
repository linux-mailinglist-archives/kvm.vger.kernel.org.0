Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7853395F2
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhCLSNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 13:13:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232602AbhCLSMo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 13:12:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615572764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fUWzsLoozTTcmn+QM4/07lmzU/Q0q3Sz+mnRlNZfAzk=;
        b=hAS25j8vNqRRz5mqqJpj7lRCJdrKVifrAa26t+sHNUx0UT7wFcTSCE1QZraFRf/CGK8Dw1
        L9FcWuy5yWTJSjBaJtv5PCY+9fFAG0g5K/qRy8ebi532EFu/07aIQpxlcctbQCGSePoVRb
        OsroTGdtKNOQDi0Y03QbJYpOGGN4SJs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-bmHbOFDTNoyjD-G21s9bJw-1; Fri, 12 Mar 2021 13:12:42 -0500
X-MC-Unique: bmHbOFDTNoyjD-G21s9bJw-1
Received: by mail-wr1-f71.google.com with SMTP id m9so11530789wrx.6
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 10:12:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fUWzsLoozTTcmn+QM4/07lmzU/Q0q3Sz+mnRlNZfAzk=;
        b=DPNvTF2K874+BPd2E0B5mAns4IObGPZPWmZoEzUytEpx6Pxd5hW7eYw992Ab2RmooI
         /r2OnSxUEKedrM8wThvwIPpAjsd3+MrUsgt18mQ8vhFn6TVGh8hW1e+6TN+Oh4MaPcg0
         6xL/zVd0z6zyNq4V2/j6JNijT6YP4Q50zM9pFt68TggGeEVHu5HoMGCqtsO50Fgc2Nm8
         wxqC5UKA4C1k0bTHcOX6TR1o/dQTzSfnr4BMUZZYbBoW/ghIJdcgBaevv5IiUCKBSJMQ
         1GXW1yNVx7CkaekuoDj6QoOIt2vB3Sw0rBFzS94a+crxh+TyJii+kZXjvKJITQ2AZlpF
         lSnA==
X-Gm-Message-State: AOAM532yRWWnmPB+3VBmG6Ew1Jw1KsA8ddVpdq9rl9mCoo/KC3mX/Vfh
        QBoymDPE4h01OUBcBqHHxEANBBMHZsD7VQv80M8umYk2EJiIxDhJA5cflD9eHVErLDUPzYHv8TO
        3pnIHyDqFR1XF
X-Received: by 2002:adf:ed12:: with SMTP id a18mr15415210wro.249.1615572761141;
        Fri, 12 Mar 2021 10:12:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJym36OZic3ZRkbaPewaIje3WJ+KPnJYffgTAjPe0HcOubZ8vFfEijSDsNnGkLSpNfH17jA+/w==
X-Received: by 2002:adf:ed12:: with SMTP id a18mr15415199wro.249.1615572761003;
        Fri, 12 Mar 2021 10:12:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n6sm10113288wrw.63.2021.03.12.10.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 10:12:40 -0800 (PST)
Subject: Re: [PATCH v2] KVM: LAPIC: Advancing the timer expiration on guest
 initiated write
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1614818118-965-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4dd4f7c2-bd9e-31a9-3eec-86a96203b66f@redhat.com>
Date:   Fri, 12 Mar 2021 19:12:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614818118-965-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/21 01:35, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Advancing the timer expiration should only be necessary on guest initiated
> writes. When we cancel the timer and clear .pending during state restore,
> clear expired_tscdeadline as well.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>   * update patch description
> 
>   arch/x86/kvm/lapic.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 45d40bf..f2b6e79 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2595,6 +2595,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>   
>   	apic_update_ppr(apic);
>   	hrtimer_cancel(&apic->lapic_timer.timer);
> +	apic->lapic_timer.expired_tscdeadline = 0;
>   	apic_update_lvtt(apic);
>   	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>   	update_divide_count(apic);
> 

Queued, thanks.

Paolo

