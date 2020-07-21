Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D5E227AFC
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 10:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgGUIqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 04:46:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42142 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725984AbgGUIqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 04:46:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595321213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GpXiietiHo/uebrG4FqVDk0/hTImFXNdoWg6rWOirEA=;
        b=G6tloRozb7wHtCwnEGiZ3UOqcjNd34WSdL9iaJmm1kHQExVs1tTDACl8dqD6JsHJSzhs5Z
        mLxhwA398kh5iMVC4gNnIRImTkGfsBPZBVdYxdkQKWRMMS4xtSnT+xrzZfXKwXrGJ9O6ZM
        No0lBxs1lMn7oYfn9ztPZ4mg9rj4gwk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-OT9S9d3qNxWRSHqfBtBc1Q-1; Tue, 21 Jul 2020 04:46:52 -0400
X-MC-Unique: OT9S9d3qNxWRSHqfBtBc1Q-1
Received: by mail-wm1-f70.google.com with SMTP id b13so975570wme.9
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 01:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GpXiietiHo/uebrG4FqVDk0/hTImFXNdoWg6rWOirEA=;
        b=hWMkmosXXBN+loEEVh7xUF0H9Ry/e0xaA3QvkeYrMOFnfOlOeTqFDx/DrsS9TzNDiu
         jhaptQuK94QU5NyqlutKHHvccnG1cpNkTX2vgZLDdnDPak6O7mhBu4JjsaLMapP9/PM0
         zu9q9olkWlVUzS43UtrOvLhOku8hbAX0IzueKit5ycQyj0JNlZVvoXgXXJQDeYxbNBQj
         F4fSij7MJWmBepqz6RI2o5DvDHhHYQG6msT5s6fGr2cJa4/jWPiRhnyRvJJIWM9aIAD5
         suTi/wB5++BqLc67jKdmtH+sxjfs4Gm4kwJyMx30LaoNfTMu2sbOaof/1hDBZ/Ad7gDC
         HizQ==
X-Gm-Message-State: AOAM532l5wL0+ltlMYNpSUMO8WqD1SCMv8wX4OaL0ABASIrbdIfFseqh
        Shah7tuN1g+iRLtBbrA3VJq9CUVVYLWdOwG2rT30Ox8e55rUOT4BMDF7i/Wjb0YasqsXU0R0DmF
        6pP0VrseqW/0f
X-Received: by 2002:adf:d08d:: with SMTP id y13mr5657125wrh.313.1595321210865;
        Tue, 21 Jul 2020 01:46:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSoX0Zk8SgUFV/+ujTmFHSuwajjuxuCf1dMZIdKNE9RX8hdTDqEE63PdpE9IZfAbOOQXS+ug==
X-Received: by 2002:adf:d08d:: with SMTP id y13mr5657106wrh.313.1595321210666;
        Tue, 21 Jul 2020 01:46:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b23sm2680832wmd.37.2020.07.21.01.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 01:46:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>, mingo@redhat.com,
        "bp\@alien8.de" <bp@alien8.de>, "hpa\@zytor.com" <hpa@zytor.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: Using macros instead of magic values
In-Reply-To: <4c072161-80dd-b7ed-7adb-02acccaa0701@gmail.com>
References: <4c072161-80dd-b7ed-7adb-02acccaa0701@gmail.com>
Date:   Tue, 21 Jul 2020 10:46:47 +0200
Message-ID: <87tuy1p85k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Haiwei Li <lihaiwei.kernel@gmail.com> writes:

> From: Haiwei Li <lihaiwei@tencent.com>
>
> Instead of using magic values, use macros.
>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>   arch/x86/kvm/lapic.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 47801a4..d5fb2ea 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2083,7 +2083,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, 
> u32 reg, u32 val)
>
>   	case APIC_SELF_IPI:
>   		if (apic_x2apic_mode(apic)) {
> -			kvm_lapic_reg_write(apic, APIC_ICR, 0x40000 | (val & 0xff));
> +			kvm_lapic_reg_write(apic, APIC_ICR,
> +					    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
>   		} else
>   			ret = 1;
>   		break;
> --
> 1.8.3.1
>

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

