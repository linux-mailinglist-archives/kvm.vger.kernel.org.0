Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D93B579FD1
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 15:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239420AbiGSNjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 09:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbiGSNjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 09:39:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B691491CC6
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658235206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vYGXV6VgJ0jbRi7uTgbbITqPjX0LforEhShmkJTwxsg=;
        b=KyWuILNvvLCEhZNg4JNiffPFk2NAik7dFJgeirC09PGDz2WOlejv/OLV03sg+mZC+Ry+2E
        cQnYO1mZV0qU+VPwQl8DZ25dlJUKccFZ2MTrQTI1RH7lUB4RC7Tt4phK+anHokqO4yyEEL
        12VpiGTqo3IVNqwsDeUrpvnvD9FzVWQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-eUpWCs8BOeK_6nKX2IWm-A-1; Tue, 19 Jul 2022 08:53:25 -0400
X-MC-Unique: eUpWCs8BOeK_6nKX2IWm-A-1
Received: by mail-ej1-f70.google.com with SMTP id oz11-20020a1709077d8b00b0072f2f17c267so1094809ejc.16
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:53:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vYGXV6VgJ0jbRi7uTgbbITqPjX0LforEhShmkJTwxsg=;
        b=a7PJiK+/R+FzcVRa86aeBuWqVxw/JzTCLrdbEhalAL9h6erAx7YuIC/MDkWYa5sVQb
         3A6q4KzDkAe18tv83WhO7UKLiGQegRSbs/yewqhj4WXCY6DdQqooAkORdOLfFbatePAI
         3J/YnhZOy2Ay8q/C/VKZtHYu9jKNB0Rbml0Kwl8tNq03nZo8URMnkxinQgJ4tYmBQCpZ
         UoYJ9SPfyWBs0XVkH4jYZ7t9+zVsQyJ3wYZiwnDVtpl+bDoA2LBsmV1h2ZQNSa4uiVDZ
         qACdKSm+YxjAKkgxu82ky0dHNM7Vi4MpVEQwjZcZa/v5VUccErWeOVqkq68e4LVEg+I4
         x+Jw==
X-Gm-Message-State: AJIora8e71GI9C+lKsq7w2lns1h+WOP/LMar/lu5KF0UX3GRgNYh9AVH
        DxG1DHeKJoMeY8KhsqAcj+JybPfB0CMvvaEyPSNzbsza3VCUTnyNFqlum9hgegMqKScNZt6vQSz
        vnw1ZDQWPDH+z
X-Received: by 2002:a05:6402:4411:b0:437:b723:72 with SMTP id y17-20020a056402441100b00437b7230072mr43754968eda.38.1658235204012;
        Tue, 19 Jul 2022 05:53:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sm+vQW3jb4GmKgnagf1V6OYd0BlDkRaUriqf3EdN6Kw9Uxhafo0UV0VqKqMC2f4P0MpWyiBg==
X-Received: by 2002:a05:6402:4411:b0:437:b723:72 with SMTP id y17-20020a056402441100b00437b7230072mr43754946eda.38.1658235203829;
        Tue, 19 Jul 2022 05:53:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id k8-20020a17090632c800b0072f3efb96aasm1922493ejk.128.2022.07.19.05.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 05:53:23 -0700 (PDT)
Message-ID: <d09011ee-6f97-99de-4984-5cf849582af8@redhat.com>
Date:   Tue, 19 Jul 2022 14:53:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: stats: Fix value for KVM_STATS_UNIT_MAX for boolean
 stats
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, jingzhangos@google.com,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
References: <20220719125229.2934273-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220719125229.2934273-1-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,TRACKER_ID autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/19/22 14:52, Oliver Upton wrote:
> commit 1b870fa5573e ("kvm: stats: tell userspace which values are
> boolean") added a new stat unit (boolean) but failed to raise
> KVM_STATS_UNIT_MAX.
> 
> Fix by pointing UNIT_MAX at the new max value of UNIT_BOOLEAN.
> 
> Fixes: 1b870fa5573e ("kvm: stats: tell userspace which values are boolean")
> Reported-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
> 
> Tested with kvm_binary_stats_test, which now passes.
> 
> Sending out a few improvements to assertions in kvm_binary_stats_test
> separately.
> 
>   Documentation/virt/kvm/api.rst | 2 +-
>   include/uapi/linux/kvm.h       | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 6e090fb96a0e..98a283930307 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5658,7 +5658,7 @@ by a string of size ``name_size``.
>   	#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
>   	#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
>   	#define KVM_STATS_UNIT_BOOLEAN		(0x4 << KVM_STATS_UNIT_SHIFT)
> -	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
> +	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_BOOLEAN
>   
>   	#define KVM_STATS_BASE_SHIFT		8
>   	#define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 811897dadcae..860f867c50c0 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -2084,7 +2084,7 @@ struct kvm_stats_header {
>   #define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
>   #define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
>   #define KVM_STATS_UNIT_BOOLEAN		(0x4 << KVM_STATS_UNIT_SHIFT)
> -#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
> +#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_BOOLEAN
>   
>   #define KVM_STATS_BASE_SHIFT		8
>   #define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
> 
> base-commit: 79629181607e801c0b41b8790ac4ee2eb5d7bc3e

Oops, thanks.

Paolo

