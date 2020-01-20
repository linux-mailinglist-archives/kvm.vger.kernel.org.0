Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA185142845
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 11:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgATKd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 05:33:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58292 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbgATKd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 05:33:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579516437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qJR64Lgz5zSWEXU05VYTGaMjJP53H0YAi/lnRrE9Dq8=;
        b=Br3VK53hLLiM2dyd2kDmpqYKq18VpIqI3/f5mB+j+VIFOgT7O3hQsvCtPQIDOYdX2xqecY
        9zrIZl2SQYGDJLwUDi7XDL0Gz+2wFg8msF9JJXtuMhbnXyfFvtprzc8ekWXqlDCZHyoS0h
        vWLRT/a4Il8X4ZcFkCc5k+SXMHAt+5M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-2Odr8Bw6MlGgLxqv883H2A-1; Mon, 20 Jan 2020 05:33:56 -0500
X-MC-Unique: 2Odr8Bw6MlGgLxqv883H2A-1
Received: by mail-wr1-f69.google.com with SMTP id v17so13892410wrm.17
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 02:33:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qJR64Lgz5zSWEXU05VYTGaMjJP53H0YAi/lnRrE9Dq8=;
        b=XRiEylUjHaf/Yt7S+99Vu/NiGOXu3/E3+1b0BNYsMrUVNHJdeNG0KP0RKUVygaBOGk
         zK62tc3u72H8SThjCJj+XYuWmCH/P8IzXQ/mwxG/Cgzb0Ucn5+hlHgyIRx8lWE7tSGH2
         3Ux/ijL0QPIl/aC9wRqARKhWVvTHPPLQst6SnDrVTvpmvawDyVAZzy05gE8aQLvMWQ1R
         zmcux03z90eAn3guX2Fm/QuSmiII8614zJ/qehZjPEyMfG6quygq+ph1HCYXcaGV9jMH
         BJ/ANrGdpRKtCkoyvHp4W+jcC1fZkChT7o5lTaoc2CEd06wwyh79St0Ov7MuV0c1u3Di
         U4Kw==
X-Gm-Message-State: APjAAAVRi4VnHwiddFL8AUsFOWy3MKUCHH+gUA90SVAZ1b987UJisJoJ
        2Uk8fTXFiPx7TcVYYRmwV9UOVnnqIRss48V5KZEEl0l1u3/FPSQdvfijren4aaqfWtt80fudg6h
        ndrfbwKsXWmZB
X-Received: by 2002:a7b:cf01:: with SMTP id l1mr18049006wmg.86.1579516435494;
        Mon, 20 Jan 2020 02:33:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxPzprOup/ucbM1P9rBV9XmWxl30oih10hcKT7ltFCGUEvFlIONj+0vKzn9cx1PD42odqSiUA==
X-Received: by 2002:a7b:cf01:: with SMTP id l1mr18048981wmg.86.1579516435320;
        Mon, 20 Jan 2020 02:33:55 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e18sm46511363wrw.70.2020.01.20.02.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 02:33:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: apic: short-circuit kvm_apic_accept_pic_intr() when pic intr is accepted
In-Reply-To: <1579315837-15994-1-git-send-email-linmiaohe@huawei.com>
References: <1579315837-15994-1-git-send-email-linmiaohe@huawei.com>
Date:   Mon, 20 Jan 2020 11:33:53 +0100
Message-ID: <87sgkafmcu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Short-circuit kvm_apic_accept_pic_intr() when pic intr is accepted, there
> is no need to proceed further. Also remove unnecessary var r.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/lapic.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 679692b55f6d..502c7b0d8fdb 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2370,14 +2370,13 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
>  {
>  	u32 lvt0 = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVT0);
> -	int r = 0;
>  
>  	if (!kvm_apic_hw_enabled(vcpu->arch.apic))
> -		r = 1;
> +		return 1;
>  	if ((lvt0 & APIC_LVT_MASKED) == 0 &&
>  	    GET_APIC_DELIVERY_MODE(lvt0) == APIC_MODE_EXTINT)
> -		r = 1;
> -	return r;
> +		return 1;
> +	return 0;
>  }
>  
>  void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)

My eyes would've appreciated a blank line after each "return 1;" but you
patch makes the code a bit nicer anyway, thanks.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

