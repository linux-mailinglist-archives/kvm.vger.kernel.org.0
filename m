Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD7F4B91D4
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 20:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbiBPTzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 14:55:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbiBPTzD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 14:55:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BED32B1028
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 11:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645041290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gy1JbZCePy9qOBCjb/sFfJIqk+Z7H23AEqm8NiFiOF8=;
        b=WfAN2moo0VlSLNq6vTbOdRIuaV0/rPUNWpKiCD2Y8cYPjE6gC6bWusiZCtVOw0Ajwzcr01
        xDNVdIxX25bEweQjpeyi0FP36L1bKXp6YuKuJ3yZmvJlI4k4oV8nGn+6yZ9mi2NFaOrFxv
        5XryXIQVRlpXjqVIQxcbYUTGysXJSvk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-3-vCoYySM3qPBFid0pFcRQ-1; Wed, 16 Feb 2022 14:54:49 -0500
X-MC-Unique: 3-vCoYySM3qPBFid0pFcRQ-1
Received: by mail-ed1-f71.google.com with SMTP id o8-20020a056402438800b00410b9609a62so2218978edc.3
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 11:54:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Gy1JbZCePy9qOBCjb/sFfJIqk+Z7H23AEqm8NiFiOF8=;
        b=0XEMcfGfUUXKJrNcrpdm2EipIs9kuZfROydudaG0Em9dTEk+K/qRSp+x9BhEaYbzZx
         qzawIe54tXZgOsKLik/EfrXkPY7FHKMBu9BVxv1PadLz6eqbyxIXxyTJm1/JeZ2HHgCU
         Xb4FZHTPAewM7hrZFdaM78rJrBxPfxVTiPi6RIt5njh2fhrlRWn37/UoQ2ap/OtsAv2x
         x/TFnRupwFwKrCDFTztVaL4+eaGTf/7ryO4atDBufq8tcLnD96zfPKjOHeYTl7ES90Os
         3wLlpGETKWhAZwt/geG2E0sYUA06RZq3kEqYGpnpUYUpWO1QnyrSRCwOm7kPD/noziKu
         +lGg==
X-Gm-Message-State: AOAM531kq7s/O9MCa3LbEkFqKRUvMpf6eZalUrk5r0TqOe+1OCfRp3Ye
        uuXOwxR7kBZ+sLOprzkqk+r4Cqtv+vCWSPW7P/6zR8p/6k6L8Fc7bvCoNGXCIcFmvW7aySi7skf
        nOpQWjvf0x3Oo
X-Received: by 2002:a17:906:2a1b:b0:6ce:a15b:a561 with SMTP id j27-20020a1709062a1b00b006cea15ba561mr3631299eje.403.1645041287434;
        Wed, 16 Feb 2022 11:54:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcnTGqiJiDylSJ+Gc6o6/uZHTUkIcqbGAhPkGIbFJuxCaxo4Ti/9smbR/0ictEYd9iSnvSqA==
X-Received: by 2002:a17:906:2a1b:b0:6ce:a15b:a561 with SMTP id j27-20020a1709062a1b00b006cea15ba561mr3631290eje.403.1645041287228;
        Wed, 16 Feb 2022 11:54:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g6sm270889ejz.170.2022.02.16.11.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 11:54:46 -0800 (PST)
Message-ID: <b9f7b049-9f15-d06c-239e-3804da325b66@redhat.com>
Date:   Wed, 16 Feb 2022 20:54:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in
 always catchup mode
Content-Language: en-US
To:     Anton Romanov <romanton@google.com>, kvm@vger.kernel.org
Cc:     mtosatti@redhat.com, vkuznets@redhat.com
References: <20220216182653.506850-1-romanton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220216182653.506850-1-romanton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/16/22 19:26, Anton Romanov wrote:
> If vcpu has tsc_always_catchup set each request updates pvclock data.
> KVM_HC_CLOCK_PAIRING consumers such as ptp_kvm_x86 rely on tsc read on
> host's side and do hypercall inside pvclock_read_retry loop leading to
> infinite loop in such situation.
> 
> v3:
>      Removed warn
>      Changed return code to KVM_EFAULT
> v2:
>      Added warn
> 
> Signed-off-by: Anton Romanov <romanton@google.com>
> ---
>   arch/x86/kvm/x86.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7131d735b1ef..d0b31b115922 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8945,6 +8945,13 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
>   	if (!kvm_get_walltime_and_clockread(&ts, &cycle))
>   		return -KVM_EOPNOTSUPP;
>   
> +	/*
> +	 * When tsc is in permanent catchup mode guests won't be able to use
> +	 * pvclock_read_retry loop to get consistent view of pvclock
> +	 */
> +	if (vcpu->arch.tsc_always_catchup)
> +		return -KVM_EFAULT;
> +

KVM_EFAULT is for invalid addresses.  I changed it back to EOPNOTSUPP 
and queued the patch.

Paolo

