Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CF6666E81
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 10:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbjALJm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 04:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240114AbjALJlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 04:41:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6ACBC2E
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 01:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673516307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fwHsnc1Ec0AxqpE9AphsrdbS365Zamo3ZBVtwHr8mbI=;
        b=HKOzGLYSycy/6R8nkgU7/DyhkfOqwssGGRXj3VJC4u17HEX52YcM+ty0ufrJ0RbB7N9UeY
        kfezPDIkBfCI6Vp1DSBJ9TLwgs7VLynxUModNK125d3uK4nSEG8Uw/lSF1Sk6YwGZ6nBfj
        yaZc6fel3bUKVNE3jYkzTPAKr5GzqOA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-BvCJyFFrM26Jr9nHaQzIug-1; Thu, 12 Jan 2023 04:38:26 -0500
X-MC-Unique: BvCJyFFrM26Jr9nHaQzIug-1
Received: by mail-wm1-f70.google.com with SMTP id m7-20020a05600c4f4700b003d971a5e770so9027979wmq.3
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 01:38:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fwHsnc1Ec0AxqpE9AphsrdbS365Zamo3ZBVtwHr8mbI=;
        b=N6438kD/NZ0xAI7SSkh2lv9VAiL9ydNnGWjxAIlF8A5iexOxT3WtrmgKYF1DDyE/Y1
         otLz79R6tqgSdDkB8zlEI+5y1DG343PpW39vY+dZC9Zh5rOTlPJ1i+1gmkEG3O+JgXRc
         nBZHZHpvYdas12Z3/oWp6ePm7/iVNp9XmpfZEcSLhE86L837+9XWe7EpYYyW7qWdhdCn
         XRthXuD+WDz7wWhbn6oo0CQGC1x7lfkD6uc1YRFGCp80Zq0WBD7ko46R6cZkB6hIyb+a
         RQnqk2CDDvcJ3KMs8aom4OnIwuByat6hwxM0BuDYblrx0iS/s6xC7Eoz1bEvlDzl58rn
         iZxA==
X-Gm-Message-State: AFqh2krBC3C0AoCMoNcVyAK82NnRAn4iMiLAvJ8idlZXM2m937UYkF37
        hJIY/HsZjPLALn9d9TVwUJnLffzzM4wJF5nx/xohzG9qdoxnL2jfN+JkgvXbvDDfhgodKKlEset
        6ZHOVU4D6rd1O
X-Received: by 2002:a7b:c7d3:0:b0:3d9:f1b6:9110 with SMTP id z19-20020a7bc7d3000000b003d9f1b69110mr10670458wmk.13.1673516305090;
        Thu, 12 Jan 2023 01:38:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsVJnkbWi9Nw8LsYrb0JksFFQ3lmCwiT9IZb3GI3xbSZMjYaugnpPEdIEpVsJUSGemPgUKbPg==
X-Received: by 2002:a7b:c7d3:0:b0:3d9:f1b6:9110 with SMTP id z19-20020a7bc7d3000000b003d9f1b69110mr10670442wmk.13.1673516304870;
        Thu, 12 Jan 2023 01:38:24 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-128.web.vodafone.de. [109.43.177.128])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c510900b003c6f8d30e40sm29081731wms.31.2023.01.12.01.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 01:38:24 -0800 (PST)
Message-ID: <62580f66-1bbd-1a7f-c1fa-53dbf51577ec@redhat.com>
Date:   Thu, 12 Jan 2023 10:38:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v2 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
Content-Language: en-US
To:     Colton Lewis <coltonlewis@google.com>, pbonzini@redhat.com,
        nrb@linux.ibm.com, andrew.jones@linux.dev, imbrenda@linux.ibm.com,
        marcorr@google.com, alexandru.elisei@arm.com,
        oliver.upton@linux.dev
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20230111215422.2153645-1-coltonlewis@google.com>
 <20230111215422.2153645-2-coltonlewis@google.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230111215422.2153645-2-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/01/2023 22.54, Colton Lewis wrote:
> Replace the MAX_SMP probe loop in favor of reading a number directly
> from the QEMU error message. This is equally safe as the existing code
> because the error message has had the same format as long as it has
> existed, since QEMU v2.10. The final number before the end of the
> error message line indicates the max QEMU supports. A short awk
> program is used to extract the number, which becomes the new MAX_SMP
> value.
> 
> This loop logic is broken for machines with a number of CPUs that
> isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
> but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
> 6. This can, in rare circumstances, lead to different test results
> depending only on the number of CPUs the machine has.
> 
> A previous comment explains the loop should only apply to kernels
> <=v4.3 on arm and suggests deletion when it becomes tiresome to
> maintian. However, it is always theoretically possible to test on a
> machine that has more CPUs than QEMU supports, so it makes sense to
> leave some check in place.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   scripts/runtime.bash | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f8794e9..4377e75 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -188,12 +188,10 @@ function run()
>   # Probe for MAX_SMP, in case it's less than the number of host cpus.
>   #
>   # This probing currently only works for ARM, as x86 bails on another
> -# error first. Also, this probing isn't necessary for any ARM hosts
> -# running kernels later than v4.3, i.e. those including ef748917b52
> -# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
> -# point when maintaining the while loop gets too tiresome, we can
> -# just remove it...
> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> -		|& grep -qi 'exceeds max CPUs'; do
> -	MAX_SMP=$((MAX_SMP >> 1))
> -done
> +# error first. The awk program takes the last number from the QEMU
> +# error message, which gives the allowable MAX_SMP.
> +if $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> +      |& grep -qi 'exceeds max CPUs'; then
> +	GET_LAST_NUM='/exceeds max CPUs/ {match($0, /[[:digit:]]+)$/); print substr($0, RSTART, RLENGTH-1)}'
> +	MAX_SMP=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& awk "$GET_LAST_NUM")
> +fi

Is that string with "exceeds" really still the recent error message of the 
latest QEMU versions? When I'm running

  qemu-system-aarch64 -machine virt -smp 1024

I'm getting:

  qemu-system-aarch64: Invalid SMP CPUs 1024. The max CPUs
  supported by machine 'virt-8.0' is 512

... thus no "exceeds" in here? What do I miss? Maybe it's better to just 
grep for "max CPUs" ?

  Thomas

