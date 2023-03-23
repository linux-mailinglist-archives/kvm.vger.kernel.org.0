Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77036C6749
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 12:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjCWL4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 07:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjCWL4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 07:56:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464EA3433B
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679572535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tGk/j8vrX7r5dPbhWigUgMhkgAKMed1wg6HnqoWMy6w=;
        b=MLMqP0cKruwY5IbhvQHPjKKpjSHxocOXriXdV0DxPwWbJeCbdgzA27NJB9KJx3oUejqGCh
        Miz8/YG2rjcaLrGuRhMPTRAiIa7xROFqnQ7eF/n2uB/uldqBkpyRreh0DV9OzQndjlzzVL
        4Nfks2BWMS2MoCahtRFHG/onOQGZpWc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-x663pRwiMZeGKYDb-KdlDg-1; Thu, 23 Mar 2023 07:55:34 -0400
X-MC-Unique: x663pRwiMZeGKYDb-KdlDg-1
Received: by mail-wm1-f70.google.com with SMTP id iv10-20020a05600c548a00b003ee112e6df1so824127wmb.2
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:55:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679572533;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tGk/j8vrX7r5dPbhWigUgMhkgAKMed1wg6HnqoWMy6w=;
        b=YZ1mHpgmyYTZGRnPV75VyNFH0fmVdq8ydTwiz1hxYlfu+pqeQFjPxmqbpW+VTSvkdL
         E7w7Ip+Qn4A9PHvNYImS2lQuFiIlRlKXcrcqrKfq0bLoGkMtv5ioxX6R63BwbAKmA2bX
         L4CXzUPwga/1xqhiyMac0aFN3rGtsMWciALYLhvbIi9Pdqm7U7RCCRyi0dzxkOCVMGyQ
         83rybaaljjq38vjvmGfTjnu1+pY9eBDZtUdDsOun7hrCqeN1veO9KpQD29oYeFK7rTOX
         fol0gVl60svFxBliF0s3S6sOk/ypvbwwR9f4PAh5v6Ik6KpHIRVbP4/3/W5kbn2//iig
         kWvQ==
X-Gm-Message-State: AAQBX9eJvNOahBZpkhdBlsNJOgWM/TA/yrvdicoTDWsQlmZgYrSNfkeK
        kH0LVsWXFyNezJojnCnYVmf7O+AlFFJbuCDoB0bSJy921kEHUI6g21J7KJkAwVB5t402rNcwA6L
        iGDP6Kf536K0c
X-Received: by 2002:adf:ff90:0:b0:2d8:28a9:f9e6 with SMTP id j16-20020adfff90000000b002d828a9f9e6mr2264219wrr.32.1679572533246;
        Thu, 23 Mar 2023 04:55:33 -0700 (PDT)
X-Google-Smtp-Source: AKy350YPuNZYYyzUpcIbxfD7REs3D4UAbd0oztyEO7Q0ufMs36tPm8YxQyWWMujBLUwAGzzPKi651A==
X-Received: by 2002:adf:ff90:0:b0:2d8:28a9:f9e6 with SMTP id j16-20020adfff90000000b002d828a9f9e6mr2264208wrr.32.1679572533024;
        Thu, 23 Mar 2023 04:55:33 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-146.web.vodafone.de. [109.43.179.146])
        by smtp.gmail.com with ESMTPSA id b13-20020adff90d000000b002c54c92e125sm16015308wrr.46.2023.03.23.04.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 04:55:32 -0700 (PDT)
Message-ID: <6b08baaa-4117-a7b4-9682-c9fc5b32dc20@redhat.com>
Date:   Thu, 23 Mar 2023 12:55:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH 4/7] powerpc: Add ISA v3.1 (POWER10)
 support to SPR test
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230317123614.3687163-1-npiggin@gmail.com>
 <20230317123614.3687163-4-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230317123614.3687163-4-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/2023 13.36, Nicholas Piggin wrote:
> This is a very basic detection that does not include all new SPRs.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/sprs.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

