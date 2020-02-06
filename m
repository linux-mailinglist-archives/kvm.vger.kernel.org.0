Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D2815424C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 11:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgBFKrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 05:47:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56536 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727806AbgBFKrI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 05:47:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580986027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LwUpU4+5TYhyq7gA8U9gCKtyirwnAwi8lnA+NgPfo3s=;
        b=GXq9qsrKFs8vHHwnxGaxWgWbTNkUlIY3Mi+aidyGOnZXbOqLbKEJm1UecpDxskw8jyZOeB
        LbIYKpGZ5U95ez7jW6odbU+K8OyYrA/u2MnAsKkJojBLoxxjy1Agm0w77KEAYHzefUNaRy
        i5yD8G6w/bV9K9zJvH6Gt4deJUVrVNc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-XhozNfTKMii8aQoKeFbTSQ-1; Thu, 06 Feb 2020 05:47:05 -0500
X-MC-Unique: XhozNfTKMii8aQoKeFbTSQ-1
Received: by mail-wr1-f71.google.com with SMTP id w17so3188033wrr.9
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 02:47:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LwUpU4+5TYhyq7gA8U9gCKtyirwnAwi8lnA+NgPfo3s=;
        b=oUH127wdya1A+HVGa+RYhlWIqkPxpBdWOul/HZNJTZp8aRHb0QjatGQa2065GE8Paw
         KSlPQJA7krPMH2CKum+mbXQ/LzzBa5R03IUlEkLL12t7jRa3ysCfK+u6IxnBgYfvjzi7
         /B6KmLCiMznmseihjTNDI4E5Lg9q3C5EMh57ctKc1+tcjluu8hAiyfe/J0E/xc02n4ZL
         EOwllRRoU2ypJXhniwiQeqpEkxmSGBXM0h8mF8vYLS9HVVo4yMQ2whjwpXKLBGcTwi3w
         CDwaeEFWseuPGJpLSL7qB+D7KORV5PE9PUXH23XlzG9xnlQVOlR4DBJiuflRwDMxYaDX
         WTgw==
X-Gm-Message-State: APjAAAUL7RVrqCeF6FYTCGXXnxJSGR1YDAb/lyayXQOWK9bbId/B7tHn
        yzehQsnqCCG9wM0NNztwgrImfIiXRBLHjfVpB0zozFQtChG5e98D5tP4+a5SHoFTzAPIB4Rt9RO
        yIz4F6JPEs6Zk
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr3725145wmg.136.1580986024130;
        Thu, 06 Feb 2020 02:47:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqzUXesjapYVLNDGg33W1PSAh8QmTUREwHpI41B5FUgh22WCFZglKZPj1KkMXoFa3bCLqnPBkA==
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr3725097wmg.136.1580986023542;
        Thu, 06 Feb 2020 02:47:03 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i11sm3631994wrs.10.2020.02.06.02.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 02:47:03 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: apic: reuse smp_wmb() in kvm_make_request()
In-Reply-To: <1580954375-5030-1-git-send-email-linmiaohe@huawei.com>
References: <1580954375-5030-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 06 Feb 2020 11:47:02 +0100
Message-ID: <87d0asgfh5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> There is already an smp_mb() barrier in kvm_make_request(). We reuse it
> here.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/lapic.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index eafc631d305c..ea871206a370 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1080,9 +1080,12 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>  			result = 1;
>  			/* assumes that there are only KVM_APIC_INIT/SIPI */
>  			apic->pending_events = (1UL << KVM_APIC_INIT);
> -			/* make sure pending_events is visible before sending
> -			 * the request */
> -			smp_wmb();
> +			/*
> +			 * Make sure pending_events is visible before sending
> +			 * the request.
> +			 * There is already an smp_wmb() in kvm_make_request(),
> +			 * we reuse that barrier here.
> +			 */

Let me suggest an alternative wording,

"kvm_make_request() provides smp_wmb() so pending_events changes are
guaranteed to be visible"

But there is nothing wrong with yours, it's just longer than it could be
:-)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

>  			kvm_make_request(KVM_REQ_EVENT, vcpu);
>  			kvm_vcpu_kick(vcpu);
>  		}

-- 
Vitaly

