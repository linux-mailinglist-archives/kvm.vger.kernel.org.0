Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3292D837D
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 01:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437568AbgLLAgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 19:36:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437750AbgLLAgT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 19:36:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607733293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6n7gVsD07Urzq1w4U97tF3A9zaEdePQkP4NQ7Yz5rzk=;
        b=hTO6U1iAavMS/GJEQSa6ohfpeQJO9Yn24Vazf0Hko/DV1kV53m4l0xXcrt+0RFv8pDd1UJ
        rPcrqTnY5hNST+AGNWnBm1qTAqXL9M6uwtE2UfBnFgxd2StuH6ed7Vzsf0yK4l+sEudBFY
        9xadHEq9JuVPL2adrWtN9ChLXlzXRlo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-TEwFRZPGN4SPRRZJQn_LIA-1; Fri, 11 Dec 2020 19:34:51 -0500
X-MC-Unique: TEwFRZPGN4SPRRZJQn_LIA-1
Received: by mail-ej1-f69.google.com with SMTP id gs3so968459ejb.5
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 16:34:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6n7gVsD07Urzq1w4U97tF3A9zaEdePQkP4NQ7Yz5rzk=;
        b=QJ7h3GFzThLP8wwLJnoRNhvnPN5dUU7pJ9LWc3qToXqxyROFFk/DadsWJylgxdwxZV
         nelFkP3uWBMUmmAc4K/XzoBio6sM6WSWVTmTGkaWPFBUp5imLol/ocfmjdrZSrW2Nxg2
         yeCdjlmm8DWtfgXG9DBdLbgxkwpqwBHH/RM5RqPRVYGMJu6+J9GQzBlti/Xty7/XIGVg
         cPFfPOwYAu4DB0tUE4E822dbTg5IEjgj/2XlLKS9UXxSNjt8u0Rqt5iSKwXt/nEk/Qza
         GYv50TdENNnvO96+UvHP2YsDCmfXx4snOJhJxGDq7CYI2nP3DQ3pi3X+u3ZUPxyY9gFD
         P0pQ==
X-Gm-Message-State: AOAM531rNUS2wiE30Gf7mcn/ZFViZWuiBYV4OidKgHx/D9lifveD2ml2
        V0ftLA5LkiRZj1rIDajJ9mYXFl3mjMeh4DqKwUKzgADwOE+1t9mDtvlSz9GEQrXT9EXgljeFbUn
        ElReChT8NsIlO
X-Received: by 2002:a05:6402:8cc:: with SMTP id d12mr14308686edz.0.1607733289713;
        Fri, 11 Dec 2020 16:34:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/pWB+W4pnUDZs9aIAM+PZkpz95i0rsIxVZMYM2VpQI7std8xVl/ZrXqx/X6Jsjx+s1Cj+hA==
X-Received: by 2002:a05:6402:8cc:: with SMTP id d12mr14308676edz.0.1607733289522;
        Fri, 11 Dec 2020 16:34:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ef11sm7991189ejb.15.2020.12.11.16.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 16:34:48 -0800 (PST)
Subject: Re: [PATCH] kvm:vmx:code changes in handle_io() to save some CPU
 cycles.
To:     Stephen Zhang <starzhangzsd@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1607588115-29971-1-git-send-email-starzhangzsd@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <46f11275-c697-9c0b-a12b-152301acaa76@redhat.com>
Date:   Sat, 12 Dec 2020 01:34:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1607588115-29971-1-git-send-email-starzhangzsd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/20 09:15, Stephen Zhang wrote:
> code changes in handle_io() to save some CPU cycles.
> 
> Signed-off-by: Stephen Zhang <starzhangzsd@gmail.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 47b8357..109bcf64 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4899,15 +4899,14 @@ static int handle_triple_fault(struct kvm_vcpu *vcpu)
>   static int handle_io(struct kvm_vcpu *vcpu)
>   {
>   	unsigned long exit_qualification;
> -	int size, in, string;
> +	int size, in;
>   	unsigned port;
>   
>   	exit_qualification = vmx_get_exit_qual(vcpu);
> -	string = (exit_qualification & 16) != 0;
>   
>   	++vcpu->stat.io_exits;
>   
> -	if (string)
> +	if (exit_qualification & 16)
>   		return kvm_emulate_instruction(vcpu, 0);
>   
>   	port = exit_qualification >> 16;
> 

I would be very surprised if there's any change in the assembly code 
after this patch.

Paolo

