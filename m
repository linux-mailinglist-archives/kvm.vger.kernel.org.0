Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DB1371664
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 16:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhECOG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:06:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233712AbhECOGU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 10:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620050726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GNPR9aetB5O6vbBVkjBt4WTSfiMRhHXQRTN0FbjXPg4=;
        b=D0cirnOK2AyvFzjM2BtbNQ7U+v7ClTz/b1uzu9bzTZzrizL5hcfek40Dj+GEbZzH0Af0d0
        Gu73masjpZovOcFeTr0FbWgPfNnEsFsh31wYwz2DYH8OfdWNlXIogXztX+Tt8TfPETye3b
        ybptc4YKtIpXHoBCD4GptK5gWNZungw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-UfLIO13mO2O_qbrqJL-ykg-1; Mon, 03 May 2021 10:05:23 -0400
X-MC-Unique: UfLIO13mO2O_qbrqJL-ykg-1
Received: by mail-ej1-f71.google.com with SMTP id h9-20020a1709063c09b0290393e97fec0fso2070675ejg.13
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 07:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GNPR9aetB5O6vbBVkjBt4WTSfiMRhHXQRTN0FbjXPg4=;
        b=hnhMvMOYn0lmIdRZoOeLFtPy4HM1ReHxxwJcjxFlTc2Ih9msrum/W/K2zud6jh9XPz
         jnoEdXyhgyafIidpVd+Qt8NmHcYh+BgHdXfqyhVWsmV3aEEpnzojAb40FRK0/fPloQeF
         1gYU2a8/E4gVoQB8FxgcvtNcLAM/BSx+wwFJfwm5dKwqqat6SOyP8UAMNZ4t+kKMqqBv
         QTrMfmcr4Wy2s8MbvpKFVseGLLMBfYYtROEjfVy0jGSsJ2xj/gPjcdHG/agS5MSL6tA+
         x/X/bGlJ4P8p4eRZ+eGKmeFiHfJvLiVtNJgkDozHkGcDQpdNy8nUEue340PG5LUzqese
         +k1Q==
X-Gm-Message-State: AOAM532U0/AF7X9z+NK98AZLhJnARytZKrKHPljTCtXJPZhPiIQJn+ox
        23rsgvKhMdcf9dQ+C73xmdLBMyyz3eHIrvutQhQ7ssI7ycSMpH0e4nUdQodvuHrwyWmAFBsKZ2k
        5goovx32AHtLz
X-Received: by 2002:a17:906:4d8d:: with SMTP id s13mr16729101eju.37.1620050722849;
        Mon, 03 May 2021 07:05:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4au918keNwU9ajYzFOowIyCo1Jppz2HVvxcn98scQ414jHG95DpQAGuWs5CJ8pUcPcdDWZw==
X-Received: by 2002:a17:906:4d8d:: with SMTP id s13mr16729075eju.37.1620050722699;
        Mon, 03 May 2021 07:05:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t14sm10993993ejc.121.2021.05.03.07.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 07:05:22 -0700 (PDT)
Subject: Re: [PATCH][next] KVM: x86: Fix potential fput on a null
 source_kvm_file
To:     Colin King <colin.king@canonical.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Nathan Tempelman <natet@google.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210430170303.131924-1-colin.king@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d28cde2-7aff-64bb-26f4-9909344676e5@redhat.com>
Date:   Mon, 3 May 2021 16:05:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210430170303.131924-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/21 19:03, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The fget can potentially return null, so the fput on the error return
> path can cause a null pointer dereference. Fix this by checking for
> a null source_kvm_file before doing a fput.
> 
> Addresses-Coverity: ("Dereference null return")
> Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   arch/x86/kvm/svm/sev.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1356ee095cd5..8b11c711a0e4 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1764,7 +1764,8 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>   e_source_unlock:
>   	mutex_unlock(&source_kvm->lock);
>   e_source_put:
> -	fput(source_kvm_file);
> +	if (source_kvm_file)
> +		fput(source_kvm_file);
>   	return ret;
>   }
>   
> 

Queued, thanks.

Paolo

