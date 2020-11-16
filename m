Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825722B5066
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgKPS7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:59:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40575 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726812AbgKPS7M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 13:59:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605553150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+osUxqYK5cMud4zaRL15T6XoOjxtXYWHGiOY4btD6Ao=;
        b=dQh236w+OgnBV24EnKLtUiLjpxpj/OcZXedJdMKQGv8GnMJ9M0lTjqjCax3pVHe+cyBFEB
        tVW42x5VERwAbYZhwpT820E01bvQQ7+Uy9BbWbY6eXtelsjCWPD4eJ2/J2NuVyjBZ4t/dN
        HlrgXULP4/4zz2mBQImlMW0lZ5U5Vbk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-zKlrDqYqOV6sylApfgrkuQ-1; Mon, 16 Nov 2020 13:59:08 -0500
X-MC-Unique: zKlrDqYqOV6sylApfgrkuQ-1
Received: by mail-wr1-f71.google.com with SMTP id w5so9346664wrm.22
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 10:59:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+osUxqYK5cMud4zaRL15T6XoOjxtXYWHGiOY4btD6Ao=;
        b=QH6MQfLXwTXm0nkaJerzpyH4MsT9i/p+S8ihVeFRPVreXMiz70PGGRlpn0/A+rwN8F
         v7Blt3tMdPTXXaitwPCRhcoh+hsNUPDJZMzcyZDVv+ITRMJFYUea/9nlOTk+9J2Ud5Fa
         nae18UYx2gTZGjDWdZmzOOL6VzeXbJIhQEO9rrQTXRd5taaMbaujfh/tvKqJdDBwuANr
         92QLBkpQGPSPYKpZ1iFDzEX779CQScugGnig9I3aDrYkzjgYAUoTx/z1DeoASexjf5rn
         bPsVqxbH93TeGYm5PBx7r0iZS5qvUBjjrleUSH3YgiQHSSxwmdaZvTjdy47MNfHO6wTN
         U1dw==
X-Gm-Message-State: AOAM532/b9xzocuNdgffxNasYWItr2sQfqppfMzEcHK731fB53GaLVLN
        wxJItBD+Uf3OgcVLGjI2X+dvBNXFg3uZxq+gniz76MJXHmtY7ndCYD9mTlYhc4c0OrPO4mgxdt+
        uirHgyUAMOmXF
X-Received: by 2002:a5d:50d1:: with SMTP id f17mr21166385wrt.264.1605553147565;
        Mon, 16 Nov 2020 10:59:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5OouAvYgD5YfXOJI3Yx8ts7SI9ylIaP0bb7awCuHIwZEeVY5tubf9YQwkgtoE1B6+Cguqyg==
X-Received: by 2002:a5d:50d1:: with SMTP id f17mr21166370wrt.264.1605553147396;
        Mon, 16 Nov 2020 10:59:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m18sm22450471wru.37.2020.11.16.10.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 10:59:06 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: Fix offset computation bug in
 __sev_dbg_decrypt().
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        Brijesh.Singh@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ssg.sos.patches@amd.com
References: <20201110224205.29444-1-Ashish.Kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d9f6ac9b-0655-6403-aa4e-4dc70f519b28@redhat.com>
Date:   Mon, 16 Nov 2020 19:59:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201110224205.29444-1-Ashish.Kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/20 23:42, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Fix offset computation in __sev_dbg_decrypt() to include the
> source paddr before it is rounded down to be aligned to 16 bytes
> as required by SEV API. This fixes incorrect guest memory dumps
> observed when using qemu monitor.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c0b14106258a..566f4d18185b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -642,8 +642,8 @@ static int __sev_dbg_decrypt(struct kvm *kvm, unsigned long src_paddr,
>   	 * Its safe to read more than we are asked, caller should ensure that
>   	 * destination has enough space.
>   	 */
> -	src_paddr = round_down(src_paddr, 16);
>   	offset = src_paddr & 15;
> +	src_paddr = round_down(src_paddr, 16);
>   	sz = round_up(sz + offset, 16);
>   
>   	return __sev_issue_dbg_cmd(kvm, src_paddr, dst_paddr, sz, err, false);
> 

I just missed it.  Queued now, thanks.

Paolo

