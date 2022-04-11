Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04F34FBD1A
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 15:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346502AbiDKNdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 09:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346491AbiDKNdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 09:33:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 405113BA71
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 06:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649683850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wYuQwCwBuMvv4GuQmTlOIcD0Aef3LCA6p6M6pCQq0jw=;
        b=CWIKjMgAoGNVZDsIcvER6jmJnvvlBdPGU9pIWhvcMzqX3LoTQ0jKaDo/CCeJeTmq0xxh10
        SdkZ6QM6SgjhGlJHk/79ikO3kegf2IP+X3SuikcNo6t1v2uuV9UBJ+XedLWznApMZOc1H9
        lSohHdxvaYKvdFmy5EI9+q2+Taxesc4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-kI5n_x5NNNWGnoS9VIEZUw-1; Mon, 11 Apr 2022 09:30:48 -0400
X-MC-Unique: kI5n_x5NNNWGnoS9VIEZUw-1
Received: by mail-wr1-f72.google.com with SMTP id q4-20020adfc504000000b002079c9cc1bfso1038313wrf.11
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 06:30:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wYuQwCwBuMvv4GuQmTlOIcD0Aef3LCA6p6M6pCQq0jw=;
        b=UgEqRDdUW6WcFfOsUcXNOh7biJnxUiNKAB+irsW5WQ07da7MKZ+c+9SjnvBnwgFI7A
         ubEgoClrorlPTTavF6NUggeyIgyK6fkB5jNSLrJvP9cSZXw8FUlb/8gJ3vpCiDd1qMg5
         Jbeq0FU6baovEEbtWGCPpUbS1XgpXxlVAOpkHxAsCwkwOcqK0xd+MJLWQFaiHcg82Exi
         KJNyUoFspVh4x9cho87B5npYzsj6TJXXmF/lxSBOGeKtUwC6Os1c6og1vmeJ2JyKKnlM
         51h8OeHMtjZC+m2P/Z6VCdI+M7R3Kn41ZGd9dXcg2AeB5avW9XgPO6vutkJZjFCAEgqg
         pE/Q==
X-Gm-Message-State: AOAM532pQW6pUlCuBxuFHbcyK3C7k2miOWA443I7Qrs+WqHTiydzgRp0
        nyESjxBc49Hjm4dBPSVrksYRq/XFFeuk+luqEL3i5HutQQ1Aoc1dasI9llSymNfzRtK4c/K0ckG
        X2fEv47j40PAM
X-Received: by 2002:a5d:4702:0:b0:206:b8d:3dce with SMTP id y2-20020a5d4702000000b002060b8d3dcemr25197098wrq.646.1649683847637;
        Mon, 11 Apr 2022 06:30:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyH1IMm0yQS1HQxAAJ7UDv/oLR6k19JoMRWq5/dXl7LYLPG8zJgObfrGCcRPNr0kaMyhoSBEA==
X-Received: by 2002:a5d:4702:0:b0:206:b8d:3dce with SMTP id y2-20020a5d4702000000b002060b8d3dcemr25197086wrq.646.1649683847399;
        Mon, 11 Apr 2022 06:30:47 -0700 (PDT)
Received: from [192.168.42.76] (dynamic-046-114-150-143.46.114.pool.telefonica.de. [46.114.150.143])
        by smtp.gmail.com with ESMTPSA id l20-20020a05600c1d1400b0038cba2f88c0sm23248726wms.26.2022.04.11.06.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 06:30:46 -0700 (PDT)
Message-ID: <4dd6a7a4-82c5-d3e7-7f0b-ebabce4b54c2@redhat.com>
Date:   Mon, 11 Apr 2022 15:30:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH v2 1/9] lib: s390x: hardware: Add
 host_is_qemu() function
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, seiden@linux.ibm.com
References: <20220407084421.2811-1-frankja@linux.ibm.com>
 <20220407084421.2811-2-frankja@linux.ibm.com>
 <814e7115c178c3dc6613c3935a7c81a29d72c19a.camel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <814e7115c178c3dc6613c3935a7c81a29d72c19a.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/04/2022 13.46, Nico Boehr wrote:
> On Thu, 2022-04-07 at 08:44 +0000, Janosch Frank wrote:
>> In the future we'll likely need to check if we're hosted on QEMU so
>> let's make this as easy as possible by providing a dedicated
>> function.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> 
> We could also adjust the check we already have in s390x/epsw.c to use
> the new function, but also fine to leave as-is.

I'd suggest to fix it: It has the same "goto done" + prefix_pop problem that 
we recently saw in another patch, too.

  Thomas


