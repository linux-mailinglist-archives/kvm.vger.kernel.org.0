Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB250579FF1
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 15:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbiGSNrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 09:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237405AbiGSNqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 09:46:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6631D49B58
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658235570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iige8/LVm6VVY2/ZBSwmWyk6JzLbyvYk5pU1/kh9Fs8=;
        b=MGqfqhoQnzFSXqSosM67DISvKbSghIa/Psu4R2+MJK3IfO/I5B1qKGoxnVp3GnUvmpKvta
        8r7Z0C2aVTcErfiiB5ZlOJI0QJLMimwQU7katIokQWvUe577fu7lj+zqxLWXIcfkDeOqbg
        /7+nFjVOxuZV5Xn3/FOcMlRbXKEZ7ks=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-HSVKjq2vNmWOFaKPwYRHwA-1; Tue, 19 Jul 2022 08:59:29 -0400
X-MC-Unique: HSVKjq2vNmWOFaKPwYRHwA-1
Received: by mail-ed1-f70.google.com with SMTP id z14-20020a056402274e00b0043ae5c003c1so9878255edd.9
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:59:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Iige8/LVm6VVY2/ZBSwmWyk6JzLbyvYk5pU1/kh9Fs8=;
        b=FpmoRPJOYgWcofRONOw7qvEacaudxajg7M20nmkOnuNgfhSmw9MvJrVSFSWCVkEn0j
         e4aUhP3Ek0If8J39usaw9f1HBFg9gZQDpapM4jtVfScIk7vnCHubGWPncpZokMWgij5v
         SMav5GAHq3t7e1CAfiqt1nzTxvyRPQQrNFIf7CSn4g9Pa+jZm88ppha6dn9xtiaW0Al8
         uAOqPqNzZju0cQHru17Hfq3Y56LIqfmSsuoZ6bzOAY0QyVyKfdbWnbCIIuu16I1DXcwW
         Xc96jrOhO40DJtKMtSgzN+Hj+eci0Le6iEUqVpIbxzYDKnGClj5oP1OeE0PDTJ7dACdM
         O/9g==
X-Gm-Message-State: AJIora/HRtSFLx7+BGfsNMNJFWJuD6h4jnp916A73ovJwR0aU5MobQvI
        J82CKUlBMPJ6a7OVodRO4nvPKQWyHZsL0nIh8yiVsiJNuTkwQ+ApvnGo3P7l64rzlQ3FR+jwNlH
        SIairi+88RDbu
X-Received: by 2002:a17:907:a06e:b0:72b:2cba:da35 with SMTP id ia14-20020a170907a06e00b0072b2cbada35mr30253420ejc.358.1658235568236;
        Tue, 19 Jul 2022 05:59:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ucBpxGGw0oeFdDnqSzMzwRP5NnWN8dyfASt8XvpZCKrqNEiQIraMSzMUU7yVcJJ46ejvHV7w==
X-Received: by 2002:a17:907:a06e:b0:72b:2cba:da35 with SMTP id ia14-20020a170907a06e00b0072b2cbada35mr30253405ejc.358.1658235568008;
        Tue, 19 Jul 2022 05:59:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id wc23-20020a170907125700b0072b41776dd1sm6622559ejb.24.2022.07.19.05.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 05:59:27 -0700 (PDT)
Message-ID: <e51fb350-265f-7123-c0e5-38df64734e9c@redhat.com>
Date:   Tue, 19 Jul 2022 14:59:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: selftests: fix bit test in is_steal_time_supported()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YtZ/Rnrm8Y+uPjDq@kili>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YtZ/Rnrm8Y+uPjDq@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/19/22 11:54, Dan Carpenter wrote:
> The KVM_FEATURE_STEAL_TIME (5) define is the BIT() value so we need to
> do shift for this to work correctly.
> 
> Fixes: 998016048221 ("KVM: selftests: Convert steal_time away from VCPU_ID")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   tools/testing/selftests/kvm/steal_time.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index d122f1e05cdd..b89f0cfa2dc3 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -62,7 +62,7 @@ static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_cpuid_entry2 *cpuid = kvm_get_supported_cpuid_entry(KVM_CPUID_FEATURES);
>   
> -	return cpuid && (cpuid->eax & KVM_FEATURE_STEAL_TIME);
> +	return cpuid && (cpuid->eax & (1 << KVM_FEATURE_STEAL_TIME));
>   }
>   
>   static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)

This is already fixed in kvm/queue, but also actually the Fixes tag 
would have to date back to commit 94c4b76b88d4 ("KVM: selftests: 
Introduce steal-time test", 2020-03-16).

Paolo

