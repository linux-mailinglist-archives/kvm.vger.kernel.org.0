Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A18A41395A
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhIUSAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 14:00:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232052AbhIUSAu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 14:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632247161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJEAcSEIgId9AwYVRC0qQ3ajHWBc7r/Wum0Va5Cj43g=;
        b=e3/QXpBSnbSxpapmMgpxQZrr8NkPHN3drLIbMfvpDGZbX8AxTI8O6zxmYIa6/dqkx7Vrii
        iDeXyjAnL5tR8/Y1X0qI9ycQSwC1Uj2UEAE2ICRqtvdnfJ1cELI4VQXVpxS32agHjxPDD2
        0vQFm2aCS58msQk2TRjvd/fdJgbCj3I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-N7-ewaLgOSOon9M-e9W6ug-1; Tue, 21 Sep 2021 13:59:20 -0400
X-MC-Unique: N7-ewaLgOSOon9M-e9W6ug-1
Received: by mail-wr1-f71.google.com with SMTP id x2-20020a5d54c2000000b0015dfd2b4e34so9503587wrv.6
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zJEAcSEIgId9AwYVRC0qQ3ajHWBc7r/Wum0Va5Cj43g=;
        b=T8SHWhyd/VGd9OjSwH1vAKyuyJq7ciyOuYzBqrHEEl85JPOnPTaeUC6cmd8REQbNgv
         pyYbPAKfLbxfczu3Pq2Ey8JkiQgSONxWmpze+dcTfCI8EnZrAQYkkmSqw2yOjMvG20W+
         qWek7cKgktq5LJmpNU8boIOv3pcCKYsTViki90iyQWTL6djBcL5FkcoJ4llU2/9hAbUz
         tK6zGySbTAM3w3daU5jGVdp6VQLY3/F/VTpY9i6Tf/I9nmZwMwuqliHdNZDyDhx+oftb
         s2Dq4lIkB34pCxFR5/8/n33JHqkFOfTmqaw0Bkd5RP1zvd93CiKN7xikti50VRD3G/4B
         4DEw==
X-Gm-Message-State: AOAM530n4KJY0bssa0CvyUTYjwBeZZdqS5h3WMsZ0koeiaLP+3aXFy40
        jL7bz5ZYXppYJ9oVZlFTXs5ML5fDDUobbhyeCiqkhtClxV9FU890mA/o0e65DuHEqz1nu8cWFF/
        JTE8UrThV9wEF
X-Received: by 2002:a7b:c112:: with SMTP id w18mr6169888wmi.86.1632247158799;
        Tue, 21 Sep 2021 10:59:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE58/MDukCj9/T6TCsmIk/mI3Qr4J4pYFiogRVuZatAFTjuNxHA7WL3p8No1sKEner6nUpvw==
X-Received: by 2002:a7b:c112:: with SMTP id w18mr6169872wmi.86.1632247158573;
        Tue, 21 Sep 2021 10:59:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f19sm3626219wmf.11.2021.09.21.10.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 10:59:17 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: SEV: Pin guest memory for write for
 RECEIVE_UPDATE_DATA
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Masahiro Kozuka <masa.koz@kozuka.jp>
References: <20210914210951.2994260-1-seanjc@google.com>
 <20210914210951.2994260-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bdbe4098-a72c-6e73-6f1e-88c2ebc07571@redhat.com>
Date:   Tue, 21 Sep 2021 19:59:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210914210951.2994260-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/21 23:09, Sean Christopherson wrote:
> Require the target guest page to be writable when pinning memory for
> RECEIVE_UPDATE_DATA.  Per the SEV API, the PSP writes to guest memory:
> 
>    The result is then encrypted with GCTX.VEK and written to the memory
>    pointed to by GUEST_PADDR field.
> 
> Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
> Cc: stable@vger.kernel.org
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75e0b21ad07c..95228ba3cd8f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1464,7 +1464,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   	/* Pin guest memory */
>   	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
> -				    PAGE_SIZE, &n, 0);
> +				    PAGE_SIZE, &n, 1);
>   	if (IS_ERR(guest_page)) {
>   		ret = PTR_ERR(guest_page);
>   		goto e_free_trans;
> 

Queued both, thanks.

Paolo

