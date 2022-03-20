Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF54B4E1BE8
	for <lists+kvm@lfdr.de>; Sun, 20 Mar 2022 14:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245173AbiCTNlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 09:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiCTNlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 09:41:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C119AE438F
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 06:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647783579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJiaNtncJ7OkNOLHJmBtY/rjamti15QWJg+sKpRnv3Q=;
        b=ZbBdWHsrxcTZAM1vshous2toswatxFrzWUtbFFmSdp2r/rekZPnP0uTQGwgaGwV9x/beQk
        b40oPn4mIz2aoQrPnpcKq03hw1Vmc1NULcUn2XS0D1yN2qvqcoTwBS2VhICP263dAiGu1/
        tBT14tnQy4FuHYQt+gR/Ms6YMo6G/Hs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-jT4BHJt0O_aR6Z2fZ5k_UA-1; Sun, 20 Mar 2022 09:39:38 -0400
X-MC-Unique: jT4BHJt0O_aR6Z2fZ5k_UA-1
Received: by mail-ej1-f72.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso6011817eje.20
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 06:39:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rJiaNtncJ7OkNOLHJmBtY/rjamti15QWJg+sKpRnv3Q=;
        b=0tqSimvsjvzozc3Wrs2zZ6La25cRni4J580Xio0QqWGpyRA1N+vrlrIfc7YHW5G5jV
         1encR4iZFPnJB+Igycv51ba/F6uKNYqJyjVOEXCnwDSbW1yX71f9gTbMWzeYROYin/vm
         r0CIF919ytPEDKsdOCcXFFDsF/HWnOpYQz7H6s+T1m6BJCcNbQNuyVT+B5fb2GemrOYX
         Bs3LhINGN7CqGiKJfXWvDA+HBOGdBpTTnWJWwwVOQcYpfP8aWkJCTlxYKDz/EZzG74wx
         y6DNbNN/uSeAFyzAuJsHh+VXlfRO7dl0mHrwOTHQB7KeBCprEX774abML1iE+nhwWL8B
         hr+Q==
X-Gm-Message-State: AOAM533B+xUu+72tnMuCxi302lq1/1CWHqwSS1x5uD7avn0lzq2TyK0p
        WFsQPfwu1jvskX+T5arbM2ZQOPFW6GzXf97vqcf6xO02VNrKxcOjPnr8pVWx9KAUsX1SuZ0aah7
        bSpAL9ku8tJW6
X-Received: by 2002:a17:906:6a02:b0:6d7:cda:2cf7 with SMTP id qw2-20020a1709066a0200b006d70cda2cf7mr16220126ejc.53.1647783577346;
        Sun, 20 Mar 2022 06:39:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfzb4laUUd5WdDJ9EumPGIAbG1lHZHTfNyewGhfBmwTVyQimOBSAXdcLK+RGTM/PJrkDxC3A==
X-Received: by 2002:a17:906:6a02:b0:6d7:cda:2cf7 with SMTP id qw2-20020a1709066a0200b006d70cda2cf7mr16220110ejc.53.1647783577076;
        Sun, 20 Mar 2022 06:39:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id b2-20020a17090630c200b006d58f94acecsm5909040ejb.210.2022.03.20.06.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Mar 2022 06:39:36 -0700 (PDT)
Message-ID: <9afd33cb-4052-fe15-d3ae-69a14ca252b0@redhat.com>
Date:   Sun, 20 Mar 2022 14:39:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220316045308.2313184-1-oupton@google.com>
 <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
 <YjTRyssYQhbxeNHA@google.com>
 <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
 <YjWNfQThS4URRMZC@google.com>
 <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
 <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
 <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
 <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
 <9ca10e3a-cd99-714a-76ad-6f1b83bb0abf@redhat.com>
 <YjbrOz+yT4R7FaX1@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YjbrOz+yT4R7FaX1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/20/22 09:52, Oliver Upton wrote:
> What do you folks think about having a new R/O vCPU attribute that
> returns a { TOD, guest_tsc } pair? I believe that would immediately
> satisfy the needs of upstream to implement clock-advancing live
> migration.

I don't think this adds much.  The missing link is on the destination 
side, not the source side.

To recap, the data that needs to be migrated from source to destination 
is the hostTSC+hostTOD pairing (returned by KVM_GET_CLOCK) plus one of 
each of the following:

* either guestTSCOffset or a guestTSC synced with the hostTSC

* either guestTODOffset or a guestTOD synced with the hostTOD.

* either guestTSCScale or hostTSCFreq

Right now we have guestTSCOffset as a vCPU attribute, we have guestTOD 
returned by KVM_GET_CLOCK, and we plan to have hostTSCFreq in sysfs. 
It's a bit mix-and-match, but it's already a 5-tuple that the 
destination can use.  What's missing is a ioctl on the destination side 
that relieves userspace from having to do the math.

Adding a nicer API just means choosing a different 5-tuple that the 
source side sends over to the destination, but it isn't particularly 
useful if userspace still has to do the math.

Paolo

