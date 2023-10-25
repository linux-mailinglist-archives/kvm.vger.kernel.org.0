Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C77A7D72AA
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 19:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjJYRvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 13:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjJYRvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 13:51:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5295F137
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 10:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698256223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=oZcPlRhzb1ZMgUbV6e7uYAIcqwlbmREdCjS3rjwS3+k=;
        b=Qv9OGrXnf60qGBSvSP1wTjqMbib9zlitYit8atkzHm0nmAkRxSHz8p3bdHenfSVN5Nhbwr
        LNI4uX+++mlS/rbOH/dxojssnDi5g4P2h539uBa+KnjTDENSZdJyqtsx3N5rwlOMGSrq08
        FKGU0djCcFn1Acb1g5GYXgBWUI1L+vE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-ye54Mo_sPkOse99KSO0nYA-1; Wed, 25 Oct 2023 13:50:22 -0400
X-MC-Unique: ye54Mo_sPkOse99KSO0nYA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-66d4aa946ceso17579226d6.1
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 10:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698256221; x=1698861021;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZcPlRhzb1ZMgUbV6e7uYAIcqwlbmREdCjS3rjwS3+k=;
        b=q6XRciythdG6SPhEixM+whNR/OxWjmuahNkR8f9cakP7fSDufGeuU1996TIrURXDmX
         kJP/P8I7lm4aKamkde6ZkWgQcnUXETevKqFQKsWyaoHL+UV6RabzLfcd0hibZ3WZBFQx
         qznwwpg6E8lFWCORKwutQdhria5vg2hQbf+RMy/8dR1N+lBfb8oro2GQiF0HWbYUEYJ4
         ZcMqlqqIv+ogrow5WWUSZVsF0rfpSK8PuzDP6N80UNWBsgErgWc0EJmnex86nG9pfvZH
         VQI/IEPWzhgBJJUv4MGHFQ8V39SpOj611vvHqqE/UVAHI0nd69WsbpHHGNiSWigWaOIO
         kPTQ==
X-Gm-Message-State: AOJu0YwWiAU8K54m8KcZhYrx6cWwv+WVSlyl0c9QnlWgL+WZo6+bRH12
        f6icaB/gS475WZhVPFAgBaXd8cIZe7KKIF9HcMQ3Pp4U18LzGPuKRDQpl4JPx+SHtC8gLbMbS0C
        anc7L+ibLuTYo
X-Received: by 2002:ad4:5c42:0:b0:656:3045:5638 with SMTP id a2-20020ad45c42000000b0065630455638mr677336qva.16.1698256221603;
        Wed, 25 Oct 2023 10:50:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEu11Px6LK7kEhBKITWvC7SWA0DG+4HmqUb3YvTEZO7D8TOkS4+rtU4tLnBgje33jOhSksTCw==
X-Received: by 2002:ad4:5c42:0:b0:656:3045:5638 with SMTP id a2-20020ad45c42000000b0065630455638mr677328qva.16.1698256221380;
        Wed, 25 Oct 2023 10:50:21 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-176-238.web.vodafone.de. [109.43.176.238])
        by smtp.gmail.com with ESMTPSA id lf18-20020a0562142cd200b0065b21b232bfsm4562777qvb.138.2023.10.25.10.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 10:50:20 -0700 (PDT)
Message-ID: <9b525819-f284-43fd-8093-3856dcc6d288@redhat.com>
Date:   Wed, 25 Oct 2023 19:50:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 09/10] scripts: Implement multiline strings
 for extra_params
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
 <20231020144900.2213398-10-nsg@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20231020144900.2213398-10-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/2023 16.48, Nina Schoetterl-Glausch wrote:
> Implement a rudimentary form only.
> extra_params can get long when passing a lot of arguments to qemu.
> Multiline strings help with readability of the .cfg file.
> Multiline strings begin and end with """, which must occur on separate
> lines.
> 
> For example:
> extra_params = """-cpu max,ctop=on -smp cpus=1,cores=16,maxcpus=128 \
> -append '-drawers 2 -books 2 -sockets 2 -cores 16' \
> -device max-s390x-cpu,core-id=31,drawer-id=0,book-id=0,socket-id=0"""
> 
> The command string built with extra_params is eval'ed by the runtime
> script, so the newlines need to be escaped with \.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>   scripts/common.bash  | 16 ++++++++++++++++
>   scripts/runtime.bash |  4 ++--
>   2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 7b983f7d..b9413d68 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -36,6 +36,22 @@ function for_each_unittest()
>   			kernel=$TEST_DIR/${BASH_REMATCH[1]}
>   		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
>   			smp=${BASH_REMATCH[1]}
> +		elif [[ $line =~ ^extra_params\ *=\ *'"""'(.*)$ ]]; then
> +			opts=${BASH_REMATCH[1]}$'\n'
> +			while read -r -u $fd; do
> +				#escape backslash newline, but not double backslash
> +				if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
> +					if (( ${#BASH_REMATCH[1]} % 2 == 1 )); then
> +						opts=${opts%\\$'\n'}
> +					fi
> +				fi
> +				if [[ "$REPLY" =~ ^(.*)'"""'[:blank:]*$ ]]; then
> +					opts+=${BASH_REMATCH[1]}
> +					break
> +				else
> +					opts+=$REPLY$'\n'
> +				fi
> +			done

Phew, TIL that there is something like $'\n' in bash ...
Now with that knowledge, the regular expression make sense 8-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

