Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850A4371659
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 16:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhECOBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:01:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230431AbhECOBq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 10:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620050452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQP5f90o36Xr8pCkH+xTrPiQ9ls07TJ+JHUflRSejpM=;
        b=JipdYY1/K0HHtpwWI6UUnCMaLKz8bjUCeAAu+gxEXD5CrdfHho4hfRNLe+wH+9cff4N4MW
        61U0rld2tR9mxLsvvmqK1NgVUPD8x1WFg5ir9Ug3cBBI2ZImoJ9lWVfA3FcEbhRx/5nYpG
        9nt8bAW+XfyvwMQblKxUjSbDu0SZrdw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-T_umVrfaNDW2lBPvzG6FhA-1; Mon, 03 May 2021 10:00:51 -0400
X-MC-Unique: T_umVrfaNDW2lBPvzG6FhA-1
Received: by mail-ed1-f70.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso4574836edb.4
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 07:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LQP5f90o36Xr8pCkH+xTrPiQ9ls07TJ+JHUflRSejpM=;
        b=bPg1AExKOAxjFmcInJ9dKlrp7Ff12KAWAzNybFK4ztaimgacP9rZw31nRrS8fJJYvJ
         pvrXyL/gMqB7wrwj2HV4/3fuzeu21R3kCFlDsuRoK2COqXFfibmhcjg5V/JN89zNcaSe
         BSe68ZzChmlnvVnGnxY4vpMdPzR/E8KHlGHc4R+suBWTiiJ+AiT4Rm9To+NP4Om1cXce
         wiPx1AICO9LAAMm5TEpR/q6MCrEESwv/f4PS4FjEoQHrL4ux/ZVZDdpnBmmaer8ziQXR
         lll95Tr+hdYmYb8bfOfOdYjRCOnoHFL05YVCRYDmsOZguFDuHx/MwcAnp3O44EEZAEhD
         MhcA==
X-Gm-Message-State: AOAM533v0thoWKbJf8Hg/K+Enz+IqRYYpXUOpz0jq8HjkQp24nVJCrO5
        fAiV5Qjc96JRkmqQBKWOfQ8kCrTj0bgXM73+YzCqzUDXud5mxKEh539rKoO/6R40sPeVfVdGaKF
        GE/By7jh8U1cj
X-Received: by 2002:a50:fe03:: with SMTP id f3mr19855449edt.92.1620050450176;
        Mon, 03 May 2021 07:00:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzD6d7R6KEA+JnEqTPFmo6jf6aAbjBIWVVaZ5xSe/NHlSWTGcjof2n47qmYuEiT/PbXqWfC5A==
X-Received: by 2002:a50:fe03:: with SMTP id f3mr19855411edt.92.1620050449890;
        Mon, 03 May 2021 07:00:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k12sm12006105edo.50.2021.05.03.07.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 07:00:48 -0700 (PDT)
Subject: Re: [PATCH 4/5] KVM: nSVM: force L1's GIF to 1 when setting the
 nested state
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Cathy Avery <cavery@redhat.com>
References: <20210503125446.1353307-1-mlevitsk@redhat.com>
 <20210503125446.1353307-5-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7d2fe4a1-9603-8bea-e7f1-fb3c24198941@redhat.com>
Date:   Mon, 3 May 2021 16:00:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210503125446.1353307-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/21 14:54, Maxim Levitsky wrote:
> While after a reset the GIF value is already 1,
> it doesn't have to have this value if the nested state
> is loaded later.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 32400cba608d..12a12ae940fa 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1314,6 +1314,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   	else
>   		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
>   
> +	/* Force L1's GIF to true */
> +	svm_set_gif(svm, true);
> +
>   	svm->nested.nested_run_pending =
>   		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
>   
> 

Hmm, not sure about this one.  It is possible in principle to do CLGI in 
L2 with the intercept disabled.

You need to use

svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));

instead.

Paolo

