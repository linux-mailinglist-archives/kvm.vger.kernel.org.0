Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440B763DB6E
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 18:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiK3REW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 12:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiK3RDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 12:03:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28C3900ED
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 08:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m9a6wFc0RaDwZ5W3tObwtvd4DevYG79SiLdXsbs2flM=;
        b=QBLAmvcAosw6RLQruAN7Iz3dA87ehx7doUMOMwEzZ/zspt/qOZL2fd3sreCcVDj5sBTIm4
        P4FfHTZYPVAplGSFCWxznzBrijqf4PLQKOsIFqqEBMQ1fEBsQKm2sgJIqSJf2NKgZlJ8oq
        +qsDx4XWlr0d9TUgaoq+8bbFUgZuyvo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596-vBDq0nslNbq8qyt8m45AdA-1; Wed, 30 Nov 2022 11:58:59 -0500
X-MC-Unique: vBDq0nslNbq8qyt8m45AdA-1
Received: by mail-ed1-f70.google.com with SMTP id q13-20020a056402518d00b00462b0599644so10254590edd.20
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 08:58:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m9a6wFc0RaDwZ5W3tObwtvd4DevYG79SiLdXsbs2flM=;
        b=gVHK/2MkH/RJ3IJikYGKeMTGEcBZCFs48cgIal8vqpyCP3QGl3hAC9D8tPbObrsfCZ
         ZqAUAPi/vwXrDgBbpcD338uDj23B42eplcdQn25c8/ejzdI97HaKo3lm30HLstI60Rrg
         vYA3I9zkHZlCeuJzPMJCejc7tVmzxCWwc6yfhLc3cbT/7qibAb8bwZzPM+6WLu/CbiLP
         xhSaWZ8ryiEoeT8enDiL69kzmBqrThNrniUn2x3812sfUUxOmZATgVkoU/qKeE0GMJWR
         pAtL5LUL9pajwVFYtDchkkIUlkv9ss1kfq5ZwsqmfU+HLSCiJsRC99O6CIern0qyV9e7
         uRdg==
X-Gm-Message-State: ANoB5pkCbIf4J6XmjIGwAtlDyKSMPTGTP23Tze0zQ8VEoZnvn5LLGG/U
        aNf8Z79TfvAlazDXijJEXXjwo1nw2Do7lbBhwJ1TEYXF2KvTvo8Fc8lx01pngcglDeUsI+dwJZV
        1L7p3T28hwRUk
X-Received: by 2002:a17:907:7784:b0:7ad:9ad7:e882 with SMTP id ky4-20020a170907778400b007ad9ad7e882mr39488589ejc.520.1669827537828;
        Wed, 30 Nov 2022 08:58:57 -0800 (PST)
X-Google-Smtp-Source: AA0mqf73qL1Jhq523BYbZhmApLx4RduRu+6qDZGDKtgYCMtGXyWkWoUIgRl5EweEwMB+7nAWZtnqqw==
X-Received: by 2002:a17:907:7784:b0:7ad:9ad7:e882 with SMTP id ky4-20020a170907778400b007ad9ad7e882mr39488574ejc.520.1669827537573;
        Wed, 30 Nov 2022 08:58:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id gi20-20020a1709070c9400b0077d6f628e14sm847674ejc.83.2022.11.30.08.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 08:58:56 -0800 (PST)
Message-ID: <e43ffb47-6526-6b2d-f7b3-0755f3c54a71@redhat.com>
Date:   Wed, 30 Nov 2022 17:58:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: Deal with nested sleeps in kvm_vcpu_block()
Content-Language: en-US
To:     Space Meyer <spm@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kpsingh@kernel.org
References: <20221130161946.3254953-1-spm@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221130161946.3254953-1-spm@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/22 17:19, Space Meyer wrote:
>   bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
>   {
> +	DEFINE_WAIT_FUNC(vcpu_block_wait, woken_wake_function);
>   	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>   	bool waited = false;
>   
> @@ -3437,13 +3439,11 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
>   	preempt_enable();
>   
>   	for (;;) {
> -		set_current_state(TASK_INTERRUPTIBLE);
> -
>   		if (kvm_vcpu_check_block(vcpu) < 0)
>   			break;
>   
>   		waited = true;
> -		schedule();
> +		wait_woken(&vcpu_block_wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
>   	}

Also, this does not work I think, because there is 
add_wait_queue()/remove_wait_queue() pair.  Adding it is not easy 
because KVM is using a struct rcuwait here instead of a wait_queue_t.

Paolo

