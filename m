Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F29429629
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 19:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhJKR7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 13:59:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234155AbhJKR7K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 13:59:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633975029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E/5bZi3m0cV+//b6WevzGww5yl4Hu1ZXn87oh0/epQQ=;
        b=EevKQSNf96ISHOlmcUf1SbSXtdpyOsqajDFKR3gTniXersfp1w0DrigW+7sl5M9I4oSWi2
        QpGy2dt+LNt1lhuyP2J6TK23R9xC8+hPINg4IiDdAXjUIg67ubeg9VjU9ZYDWxQLoTLhRY
        qMHxEwucLLWH2BK7ubPvNLDv0g0HRVY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-Pg66ExTOOaS396zpV6KKCw-1; Mon, 11 Oct 2021 13:57:06 -0400
X-MC-Unique: Pg66ExTOOaS396zpV6KKCw-1
Received: by mail-wr1-f70.google.com with SMTP id s18-20020adfbc12000000b00160b2d4d5ebso13935618wrg.7
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 10:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=E/5bZi3m0cV+//b6WevzGww5yl4Hu1ZXn87oh0/epQQ=;
        b=AdcFve5WK8fz5I/lf5s78dP2UmRAEhOtkR/1lMxFA+rcHbiW0QYEKT1eQ9ZjZgfCXN
         O4IHYmuE5aR3MwS4ju51jnjTJ0f4ZCU9TkLQQWW3g11xtSjx99DcGl8FeBBoLH+5zvi3
         KHhywik08FgvcCAAkGWVpvc49AyRWJpEKlULYFSsPdT1NIdHe2XWg/ZJQ0YANx31XxvH
         q9J6+3FFP2dvbBo3ysHve/cIrN4eV3k65GSfG1fYpcfjd8+MEQON2fLLmOKmrUWug/99
         RHtTPG5WLH+J/4faMsmf/8zL/AA9B8Ayq/wULHY07edcbZvPdEbcygQaLuMneeYuFV8E
         jo+A==
X-Gm-Message-State: AOAM532d/VkqSyRO3Bvzemf650Rax6960xhn0I9QRYhvflKLnt0f3C26
        CeqgDI8lvjyFB79ibDVOu7smdQ4pTqMkDlx10tlfNAKwiqZ2HNASlzEy1NlFbmEmD1nG+Gnt2NA
        R0h+y1/2jUtYG
X-Received: by 2002:adf:fb0a:: with SMTP id c10mr27836998wrr.354.1633975025004;
        Mon, 11 Oct 2021 10:57:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKGGwyIKO0k01yOuR3wlxMM05AG04P32tsZWeSIbZoC0xX0DuRbe/iFHxbaDWGM6c3TDR0dg==
X-Received: by 2002:adf:fb0a:: with SMTP id c10mr27836982wrr.354.1633975024834;
        Mon, 11 Oct 2021 10:57:04 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c64ba.dip0.t-ipconnect.de. [91.12.100.186])
        by smtp.gmail.com with ESMTPSA id d8sm8372925wrz.84.2021.10.11.10.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 10:57:04 -0700 (PDT)
Subject: Re: [RFC PATCH v1 1/6] KVM: s390: Simplify SIGP Set Arch handling
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211008203112.1979843-1-farman@linux.ibm.com>
 <20211008203112.1979843-2-farman@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <de4726aa-aa72-7e17-8bc6-9d42ca6125a8@redhat.com>
Date:   Mon, 11 Oct 2021 19:57:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211008203112.1979843-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.10.21 22:31, Eric Farman wrote:
> The Principles of Operations describe the various reasons that
> each individual SIGP orders might be rejected, and the status
> bit that are set for each condition.
> 
> For example, for the Set Architecture order, it states:
> 
>    "If it is not true that all other CPUs in the configu-
>     ration are in the stopped or check-stop state, ...
>     bit 54 (incorrect state) ... is set to one."
> 
> However, it also states:
> 
>    "... if the CZAM facility is installed, ...
>     bit 55 (invalid parameter) ... is set to one."
> 
> Since the Configuration-z/Architecture-Architectural Mode (CZAM)
> facility is unconditionally presented, there is no need to examine
> each VCPU to determine if it is started/stopped. It can simply be
> rejected outright with the Invalid Parameter bit.
> 
> Fixes: b697e435aeee ("KVM: s390: Support Configuration z/Architecture Mode")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   arch/s390/kvm/sigp.c | 14 +-------------
>   1 file changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index 683036c1c92a..cf4de80bd541 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -151,22 +151,10 @@ static int __sigp_stop_and_store_status(struct kvm_vcpu *vcpu,
>   static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter,
>   			   u64 *status_reg)
>   {
> -	unsigned int i;
> -	struct kvm_vcpu *v;
> -	bool all_stopped = true;
> -
> -	kvm_for_each_vcpu(i, v, vcpu->kvm) {
> -		if (v == vcpu)
> -			continue;
> -		if (!is_vcpu_stopped(v))
> -			all_stopped = false;
> -	}
> -
>   	*status_reg &= 0xffffffff00000000UL;
>   
>   	/* Reject set arch order, with czam we're always in z/Arch mode. */
> -	*status_reg |= (all_stopped ? SIGP_STATUS_INVALID_PARAMETER :
> -					SIGP_STATUS_INCORRECT_STATE);
> +	*status_reg |= SIGP_STATUS_INVALID_PARAMETER;
>   	return SIGP_CC_STATUS_STORED;
>   }
>   
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

