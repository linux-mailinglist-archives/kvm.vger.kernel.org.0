Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00243A67EC
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhFNNeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:34:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233421AbhFNNeB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 09:34:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623677518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hRN6/Q9IZr0H5ss8eONnqm8A5V4iwCEsv9Clym5vYoM=;
        b=RxWZYajPKihSMngiPG+eWWrE7/SW4NqEULhFmpc1deYmyk0NLgWnL7LWg239L5i5t4d5Wk
        eyGE4mgnIpBFfcNJgyZjSFCtuAS+Qv55yFRtTT2ZTui+zoMqPIv2w6RdSi6ElhsLdBzPxu
        Krf4bt21mae+gpBR2+mJg8g2e9DYkhA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-Zcu1iuY3Mp2mtg32vjCDcA-1; Mon, 14 Jun 2021 09:31:57 -0400
X-MC-Unique: Zcu1iuY3Mp2mtg32vjCDcA-1
Received: by mail-ej1-f70.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso3064224ejc.7
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 06:31:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hRN6/Q9IZr0H5ss8eONnqm8A5V4iwCEsv9Clym5vYoM=;
        b=hTQwTlp0AP2SX+TU+jeNMBM+0/RpQP1vg2xy/b5UK6ZSOj4XvwXDklkT/y2E8dCdir
         l+r2kPzjti7N1qHztGk1CLJ1jSKSD6AwR664hS1ZFep93sB9voCg0+nwV5RvvaedfZpG
         GBhoi2M8pjpnUUUZmMEn3sTI4zB5ircQnxDBXhtl/BU7mv6U9B/gkRMBB/v29GC60tfA
         qjVq3gtN7v99H1F0TgZ95wJqeWTaBMS6YzpSAj8WPEO026KFEGVg2cerQOKg8dcBAl/L
         JVOPPRIJ+K6But36Q6FYIlCQgM2sY9sDW5tKmQ/XUWmxcQ9ozJ/xtxbEZzpjC81je52w
         ABpQ==
X-Gm-Message-State: AOAM531CZTp4TnmkTOIM0WhHqxK42FVCQhG4lMegG06XjLawLuRb15lx
        PDgyI7oS6fXOuQALIpKGcWSEi0knZQoI5o05FUIWQX7nGJ++7Sa7CxycLBa03SXt33eZVS5D02f
        eCjKuOJJCKnZ5
X-Received: by 2002:a17:906:7f0e:: with SMTP id d14mr14953877ejr.103.1623677513181;
        Mon, 14 Jun 2021 06:31:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuPat7iKOKVGaHSl9Eavatgh5H1KEdhUcv5IoRUvyJm8KChNXQJslIuskIvp3/MEhBOe+XWQ==
X-Received: by 2002:a17:906:7f0e:: with SMTP id d14mr14953861ejr.103.1623677513007;
        Mon, 14 Jun 2021 06:31:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i15sm7553633ejk.30.2021.06.14.06.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 06:31:52 -0700 (PDT)
Subject: Re: [PATCH] KVM: svm: Avoid NULL pointer dereference in
 svm_hv_update_vp_id()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210614113851.1667567-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <556a5cfa-4a45-e910-6560-8e33b3eb349e@redhat.com>
Date:   Mon, 14 Jun 2021 15:31:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210614113851.1667567-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/06/21 13:38, Vitaly Kuznetsov wrote:
> Hyper-V context is allocated dynamically when Hyper-V features are enabled
> on a vCPU but svm_hv_update_vp_id() is called unconditionally from
> svm_vcpu_run(), this leads to dereferencing to_hv_vcpu(vcpu) which can
> be NULL. Use kvm_hv_get_vpindex() wrapper to avoid the problem.
> 
> Fixes: 4ba0d72aaa32 ("KVM: SVM: hyper-v: Direct Virtual Flush support")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> - The patch introducing the issue is currently in kvm/queue.
> ---
>   arch/x86/kvm/svm/svm_onhyperv.h | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> index ce23149670ea..9b9a55abc29f 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -99,9 +99,10 @@ static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
>   {
>   	struct hv_enlightenments *hve =
>   		(struct hv_enlightenments *)vmcb->control.reserved_sw;
> +	u32 vp_index = kvm_hv_get_vpindex(vcpu);
>   
> -	if (hve->hv_vp_id != to_hv_vcpu(vcpu)->vp_index) {
> -		hve->hv_vp_id = to_hv_vcpu(vcpu)->vp_index;
> +	if (hve->hv_vp_id != vp_index) {
> +		hve->hv_vp_id = vp_index;
>   		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
>   	}
>   }
> 

Squashed, thanks.

Paolo

