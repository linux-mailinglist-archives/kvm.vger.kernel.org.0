Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D8C5A003E
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 19:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239983AbiHXRT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 13:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238271AbiHXRT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 13:19:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3EE2B27E
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 10:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661361593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=htSTO8x0Cj6KPZv2uj2h4VO+F7UUjPoTVomapi+SfYc=;
        b=iaxTX6wzT8Y7p3E6YSBWvCibh68F47Pe5AfkIZblsnGQ4F0MXBdL1RU45R7n/oLsK/7JeM
        //GmsHUt+867wQFlalNKHjM4N2WAMw2xQy+vAGRcXqvD9ukQNBv0YeLacRgZ+J8Bz+Pxxt
        2drkMubPtRLQoF0drjmNxaxJ332tJpM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-351-wzfxF12kMhKpZA-X4FZqmQ-1; Wed, 24 Aug 2022 13:19:50 -0400
X-MC-Unique: wzfxF12kMhKpZA-X4FZqmQ-1
Received: by mail-wm1-f71.google.com with SMTP id c66-20020a1c3545000000b003a5f6dd6a25so1102925wma.1
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 10:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=htSTO8x0Cj6KPZv2uj2h4VO+F7UUjPoTVomapi+SfYc=;
        b=gki0/26GSqy2twjgIqVwV1h9GtQPPu8Z72Qp/i30QmJi3BsqagFVWZ8CBk9DVPrxTo
         lNzYhS1UjcaCSZhekUQixPi3ReQGWJRbWm8IR4yeakjfWsEAEKFoTivHKH3z0RzX5Ac8
         /fFpiLNDxGgD2Vk/Srfb1pOLDyapZYG4Of5bs/hAjW3N6W7xxkmSCxiUUn4KonoyVKkV
         l2+Ok6vUjdThzSIw18sIgsdlb1/Ee/YFR1Q2/mcEku77i9oSqB8DXzpg12NtBJBIKYf5
         dcGX4Hnoqo+gdX+saNwZpoxc//oLvASikDEQ6iWHh6C+UrMVhiNTJtQ/pagCL9qjNVuB
         rCrw==
X-Gm-Message-State: ACgBeo1VcxC19wqL1gVZxbRPuVbSIQs2/RY5W2kTBFNBVCuDpLvTi4R6
        rErWs5Uc+MuT0kDyz0iRS9u/UGeqRsRGwkk+yCRAk/UjaaDr3qMhtAVJRO1A0Ht+uqduEpMqx7e
        1YZ5fzGkLGKb4
X-Received: by 2002:a05:6000:18af:b0:222:c48d:9064 with SMTP id b15-20020a05600018af00b00222c48d9064mr153474wri.18.1661361589148;
        Wed, 24 Aug 2022 10:19:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR522n77IX34OfIqY48YVItbyp3nWng/H47uaIhpZa58w6cK9bPh77nndiUAFiwlqROo2tDd/A==
X-Received: by 2002:a05:6000:18af:b0:222:c48d:9064 with SMTP id b15-20020a05600018af00b00222c48d9064mr153462wri.18.1661361588902;
        Wed, 24 Aug 2022 10:19:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id u11-20020a05600c210b00b003a531c7aa66sm2464531wml.1.2022.08.24.10.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 10:19:48 -0700 (PDT)
Message-ID: <1ef45852-7acd-21e2-5a92-326c6ce771da@redhat.com>
Date:   Wed, 24 Aug 2022 19:19:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] KVM: x86/emulator: Fix handing of POP SS to correctly set
 interruptibility
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org
References: <20220821215900.1419215-1-mhal@rbox.co>
 <YwVusiSjT8xINz2q@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YwVusiSjT8xINz2q@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/22 02:20, Sean Christopherson wrote:
>    Fixes: a5457e7bcf9a ("KVM: emulate: POP SS triggers a MOV SS shadow too")
> 
> and probably
> 
>    Cc:stable@vger.kernel.org
> 
> even though I'd be amazed if this actually fixes anyone's workloads:-)
> 
> Reviewed-by: Sean Christopherson<seanjc@google.com>
> 
> 
> Paolo, do you want to grab this for 6.0, or should I throw it in the queue for 6.1?

Go ahead for 6.1.

Paolo

