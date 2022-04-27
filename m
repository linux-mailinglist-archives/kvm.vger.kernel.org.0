Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C749B5110DF
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 08:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbiD0GKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 02:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiD0GKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 02:10:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD8295AA60
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 23:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651039616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWgF3IzWwc8DWyaMyWyQeWJPbHFs1Ob+K2sFzH1yItI=;
        b=U0GjodZyvRS1EHdF+kYQXRuJKjQ0GFVUU9hIcNPKgPq5SzcSjxxLx7CUZkO3m+R5vfrNGZ
        IGPPivXenvp1gtCe32+rxYAvuI7BsV2DigQfBjnjRnlxlS8Cd2x9I/QMQjWBFo0nP9yPKV
        D/lA8UytnHIhOxUKqMCgZs6yymvXuAQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-8o0yQZiHP26Vc1KwUefoBA-1; Wed, 27 Apr 2022 02:06:53 -0400
X-MC-Unique: 8o0yQZiHP26Vc1KwUefoBA-1
Received: by mail-ej1-f71.google.com with SMTP id sg44-20020a170907a42c00b006f3a40146e8so486469ejc.19
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 23:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aWgF3IzWwc8DWyaMyWyQeWJPbHFs1Ob+K2sFzH1yItI=;
        b=R7ieJfGlpBY7GCvcEcE+TXNhrlOSsXfPPa6eNNiUcrGrgYoXSB4lpYSaPzL4jjiF61
         sguFkvFgBqQg/16k9qU0+wzdvoofXPPiq/tESDLjkW9kQ20R8//VLRd07cV2LTiQYipn
         iIMerlDByItj7uxb4etKi2sY0QIfk1P+BxpLkAoYHnkBc7qy7569aLyaW7CtUwLdmJGC
         vBzprMliPXjphwMCTSxquA1FaEBmSZE9iInkN9fti6L+eFS8ZVSb1DsHNBWfVI+sD+oz
         m6ZKyIwF4Kx43NiKiQLrzmI68iv6MRfmvZf+Z8bu0clXLudujtNF+AiC2FW9fiZfVflW
         25SA==
X-Gm-Message-State: AOAM531WKSSpZP+v1DK0f5r7Q68M/K/Nw2PphKeK1oMZHVOYRXlwtlMK
        lk2dKyc5Am7oU+eynptZaxdD/xPPj2zQwDa8TMVxu5h4Ar2Rj6wTnri2UuNnuxGaywn0T0kYnb0
        YzfijSo1XSDUO
X-Received: by 2002:a17:906:9b85:b0:6db:ab80:7924 with SMTP id dd5-20020a1709069b8500b006dbab807924mr24971949ejc.160.1651039612808;
        Tue, 26 Apr 2022 23:06:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1fzon5VKfL8UuAC13xokgOYYm8jW/639n9tuhmfdvm9dqgjTr2RdDrxELXnom6MWbMljbzg==
X-Received: by 2002:a17:906:9b85:b0:6db:ab80:7924 with SMTP id dd5-20020a1709069b8500b006dbab807924mr24971936ejc.160.1651039612638;
        Tue, 26 Apr 2022 23:06:52 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id o5-20020a170906974500b006dfc781498dsm6176164ejy.37.2022.04.26.23.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 23:06:51 -0700 (PDT)
Message-ID: <24265b0c-ce9f-58b7-1717-944e4cd313c9@redhat.com>
Date:   Wed, 27 Apr 2022 08:06:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: linux-next: build failure after merge of the kvm tree
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     KVM <kvm@vger.kernel.org>, Peter Gonda <pgonda@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20220419153423.644c0fa1@canb.auug.org.au>
 <20220427132327.731b35d8@canb.auug.org.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427132327.731b35d8@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 05:23, Stephen Rothwell wrote:
>>   #define KVM_SYSTEM_EVENT_NDATA_VALID    (1u << 31)
>>   			__u32 type;
>>   			__u32 ndata;
>> +			__u64 flags;
>>   			__u64 data[16];
>>   		} system_event;
>>   		/* KVM_EXIT_S390_STSI */
>> -- 
>> 2.35.1
> I am still applying the above patch.

I am waiting for review of 
https://lore.kernel.org/kvm/202204230312.8EOM8DHM-lkp@intel.com/T/.

Paolo

