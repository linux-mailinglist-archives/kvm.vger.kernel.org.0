Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CF313D5EC
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 09:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbgAPI1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 03:27:44 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40740 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729730AbgAPI1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 03:27:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579163262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n6OKWorUpXtJWORIatOckAmUa1LJaKhueVthosat7x4=;
        b=A0xyXB8iVxpwkoYKnyo5aDV5h45P0CvX6ull1JarP2bB6bsEhuSLZfp6arExHJZYNjLCsB
        vhXlnEj2wujduNl/MQ4fQ19V6+tNpgVp/kZ8BtX6GQsw01GZoJiO6ihigw/7zk9U/xtPqz
        7Bh40KSEc2irinWyJe8H3j5qEzjzOzM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-pifPKtuIPLezZDxVmTsNNQ-1; Thu, 16 Jan 2020 03:27:41 -0500
X-MC-Unique: pifPKtuIPLezZDxVmTsNNQ-1
Received: by mail-wr1-f69.google.com with SMTP id f15so9085494wrr.2
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 00:27:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=n6OKWorUpXtJWORIatOckAmUa1LJaKhueVthosat7x4=;
        b=XH0O1wvPRWFFF3Fuge2Ix8bLrauZSFluxP5ONBpFVyBZgNL/cDXxnlqs4g60S5g09P
         gVB7af4kolHLFTyoox7h5HL4QiigszNE6UfTeisv1pnl7Uyu7uofwxfXT/0lnoZ5sABJ
         9L/3/J9h/GeURTCoHXWuDCh8x2+rRPw2ENnXKzGVmw8XlSWEbwQ9tdnz4e4YdNlbGbct
         ecaC+g30yZkwFcwXEJo45X15PhWKKaUBXg4MpUeljXzKSvWPGrP5j3J9SunAV2KS5Ucr
         gIJ5akWUe+Pkyn8VRmHhkJLjoLBOy6soJdzBn/mt/WwxP0Yokvlfo3xS9fizu2QYiJuQ
         9/Lw==
X-Gm-Message-State: APjAAAWYUG2y/OtMoBVGwpbFG/IPqeeAgbyOl4znMNO7KUcIIJRPO6lN
        V3Fi0ddVqRlR4P1AuA11bS7yjzhkQbQD6qaDUT3GF1/+AiwA+bUHEwn73U5xyz/kKYxX16zuO7p
        q1wK5A2HD1jkH
X-Received: by 2002:a1c:f210:: with SMTP id s16mr4684966wmc.57.1579163260055;
        Thu, 16 Jan 2020 00:27:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqwVolGeukQa36Dfr81fPYllOJxeYL24l5Z41rqF1Lj8IsfizGSC2C91s7ayuKdoMSkQ+1ZraA==
X-Received: by 2002:a1c:f210:: with SMTP id s16mr4684950wmc.57.1579163259854;
        Thu, 16 Jan 2020 00:27:39 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p7sm1879703wmp.31.2020.01.16.00.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 00:27:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "mingo\@redhat.com" <mingo@redhat.com>, bp@alien8.de,
        "hpa\@zytor.com" <hpa@zytor.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: Adding 'else' to reduce checking.
In-Reply-To: <2a1a3b72-acc5-4977-5621-439aac53f243@gmail.com>
References: <2a1a3b72-acc5-4977-5621-439aac53f243@gmail.com>
Date:   Thu, 16 Jan 2020 09:27:37 +0100
Message-ID: <87d0bjiz5y.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Haiwei Li <lihaiwei.kernel@gmail.com> writes:

>  From 4e19436679a97e3cee73b4ae613ff91580c721d2 Mon Sep 17 00:00:00 2001
> From: Haiwei Li <lihaiwei@tencent.com>
> Date: Thu, 16 Jan 2020 13:51:03 +0800
> Subject: [PATCH] Adding 'else' to reduce checking.
>
> These two conditions are in conflict, adding 'else' to reduce checking.
>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>   arch/x86/kvm/lapic.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 679692b..ef5802f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1573,7 +1573,7 @@ static void 
> kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
>          kvm_apic_local_deliver(apic, APIC_LVTT);
>          if (apic_lvtt_tscdeadline(apic))
>                  ktimer->tscdeadline = 0;
> -       if (apic_lvtt_oneshot(apic)) {
> +       else if (apic_lvtt_oneshot(apic)) {
>                  ktimer->tscdeadline = 0;
>                  ktimer->target_expiration = 0;
>          }

I bet the compiler will generate the exact same code
(apic_lvtt_tscdeadline() and apic_lvtt_oneshot() are inlines), however,
I think your patch is still worthy: 'else' makes it obvious it's either
one or another and not both.

One nitpick: coding style requires braces even for single statements in
case other branches require them so in your case it should now be:

if (apic_lvtt_tscdeadline(apic)) {
	ktimer->tscdeadline = 0;
} else if (apic_lvtt_oneshot(apic)) {
        ktimer->tscdeadline = 0;
        ktimer->target_expiration = 0;
}

With that,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

