Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F9F113F3A
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 11:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfLEKTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 05:19:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34064 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729017AbfLEKTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 05:19:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575541176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ln8ZUNvOPrVi4maH8Z61jrB9tpqjzLpExI55MiJBJ2w=;
        b=iLsbC5cE0A6FhwRuG9h0eV+HveaxcMxr6mxrhhvc2LWZivLwXT7VzR3r/RYCBKJXIEwLoD
        N9Dn7ror4DmEDVeyN9GD7ew1NKj7YGfzrfWKpWTMXK/wZfH1peq9nzCa7ULzirM6DfoZ3n
        g+6qRCt8f+z+1rcXOlczPSJCXJSbPoc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-R-CSkxtpMX-BkAB4NOY3Pg-1; Thu, 05 Dec 2019 05:19:35 -0500
Received: by mail-wr1-f72.google.com with SMTP id u12so1318539wrt.15
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 02:19:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ln8ZUNvOPrVi4maH8Z61jrB9tpqjzLpExI55MiJBJ2w=;
        b=IlXS4XArBYFwOzLNEnxvWNd1z8bQgvac8ref5VEM4Zd2za/TQcDX0KJY+jRXXb7+E2
         IpUngC6x1lA867mTeVm1mbaACfkh7hs+O/AQF/9xeNIoQ8/80iHRlomG3D3HY4FMLCxF
         vIvAK3sJqcMpWM0JEV1LE6Le8t3tTBF60Xmu3g4w5LslsSrB9iiecoY3/av1DAVLZvwA
         8VHMZ4Ub+RWaUpDWFeZvOKLNm1fZBOk00N89nGTIfX1f0HSrhnxpYHBqr9i/1+OZoQD6
         x1NrIQHKKCEC1dXis12hPu4/gBmMC5ARVLxYWp4Q+bmqfoaSvqVqduDvnkoG2yyVp7d1
         PVrA==
X-Gm-Message-State: APjAAAXWOjjWReEm0/CGSsh2/Afpg7u4GKoqdGYisdZTTCZmhkgIip5f
        U4FHI44otpVoVTPR+/GBWyYZ5K6d+YpZBg4f/jjFA4xJquwpQauRSU7gKKIbfFmvqWGJLhNq2jM
        IEvZRiKEZeJ4H
X-Received: by 2002:a1c:3803:: with SMTP id f3mr4446406wma.134.1575541174627;
        Thu, 05 Dec 2019 02:19:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqxGZwu2osdsqyQJM4F16+Z0qPXhHN5OwXXbgylNZNCRn6oWdfdmCqf0PLAgBUweCD/FWfQW/g==
X-Received: by 2002:a1c:3803:: with SMTP id f3mr4446378wma.134.1575541174401;
        Thu, 05 Dec 2019 02:19:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:541f:a977:4b60:6802? ([2001:b07:6468:f312:541f:a977:4b60:6802])
        by smtp.gmail.com with ESMTPSA id u18sm11656947wrt.26.2019.12.05.02.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 02:19:33 -0800 (PST)
Subject: Re: [PATCH] KVM: explicitly set rmap_head->val to 0 in
 pte_list_desc_remove_entry()
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1575517216-5571-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e9469628-dc2c-c738-5589-2ac19c01109c@redhat.com>
Date:   Thu, 5 Dec 2019 11:19:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1575517216-5571-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-MC-Unique: R-CSkxtpMX-BkAB4NOY3Pg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/19 04:40, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> When we reach here, we have desc->sptes[j] = NULL with j = 0.
> So we can replace desc->sptes[0] with 0 to make it more clear.
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f92b40d798c..a81c605abbba 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1410,7 +1410,7 @@ pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
>  	if (j != 0)
>  		return;
>  	if (!prev_desc && !desc->more)
> -		rmap_head->val = (unsigned long)desc->sptes[0];
> +		rmap_head->val = 0;
>  	else
>  		if (prev_desc)
>  			prev_desc->more = desc->more;
> 

Queued, thanks.

Paolo

