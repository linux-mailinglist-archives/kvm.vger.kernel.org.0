Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F585640CBD
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiLBSAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbiLBSAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:00:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB20E466E
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670003982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bp6CEyhw9bjuHKg7g27P7NTbTOjVcpur3SU7g78NmqY=;
        b=gEGgbzsDQC1z6eRZsVI9DcNa0DC6uEbMTEHx6xj1+BqVQdNq9J8Be1Jz7yDPME/tYPSnJE
        i7BUxqq/bzI4XU907wglZm4+gE7Czd+LHhUGstUg8V1BNaafPlbbT+SonXsNwhUMxLoql3
        CEC+DDbDIjlQsv0sL1x3TndDnSb8034=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-475-781MYTe8Pjm3TukxyRkNgA-1; Fri, 02 Dec 2022 12:59:27 -0500
X-MC-Unique: 781MYTe8Pjm3TukxyRkNgA-1
Received: by mail-wr1-f69.google.com with SMTP id v14-20020adf8b4e000000b0024174021277so1252346wra.13
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:59:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bp6CEyhw9bjuHKg7g27P7NTbTOjVcpur3SU7g78NmqY=;
        b=WlVIWcEH09pbgSwPsR0ZOxEfPLxDHbR4YkdwBQlAToX1G1QPP517WY2o/W98EWfH2I
         NLdc9qTbPIGfk0cY2mkbU760BPQV3LuT/rmPsPA2qopN9z1RSenZ1MB5LGH/CJ/N8ZKp
         gWroEUuFZk8XOD6O68IyZSSomHrlNdvvrYTM24Pf8JFbOKLjbcryjhBYIRfUm3xq8sFn
         GuFqflBRC/4FYb8ZEDH3BQjju5Tdp+U94U8gS8Eji78vWrL3tkEFPlaGCxOYBJudrD5M
         UHm9U6ynKWY95K4ahBNC9YpbDvT9sPhYMFYGwE+xHqAyAAN2CxLY2IIzWv0/+/+YTGsF
         GjTA==
X-Gm-Message-State: ANoB5pk9xZVk0BeLq0prq0eBF4lxnMKRZXzg/VgXq+pCv3b6f3baBWKn
        4jkApVSiWDpWU5d4TO22GpPOGCgtzOSpkHeihEwn6pnWEmwDd99XsJGQnKh30yZe3ctupSyYoYl
        AFlc7BJ8hDJum
X-Received: by 2002:adf:ee12:0:b0:242:4903:3caa with SMTP id y18-20020adfee12000000b0024249033caamr1857816wrn.347.1670003965504;
        Fri, 02 Dec 2022 09:59:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5hbvdGiX/6FC+n+tV2G1bJUgbvynlS3sulEcFplaTKvIoEZDv3j54Wb0NGxxFZvJGUMmvmnw==
X-Received: by 2002:adf:ee12:0:b0:242:4903:3caa with SMTP id y18-20020adfee12000000b0024249033caamr1857810wrn.347.1670003965285;
        Fri, 02 Dec 2022 09:59:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j1-20020a05600c1c0100b003cfd4e6400csm10767125wms.19.2022.12.02.09.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 09:59:24 -0800 (PST)
Message-ID: <e31bd449-3eb7-ed6e-16a4-d52e82786452@redhat.com>
Date:   Fri, 2 Dec 2022 18:59:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM: x86: Fixes and cleanups for 6.2
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <Y4lHxds8pvBhxXFX@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y4lHxds8pvBhxXFX@google.com>
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

On 12/2/22 01:33, Sean Christopherson wrote:
> Please pull misc x86 fixes and cleanups that have been floating around for a
> while.  These haven't been plugged into any bot-visible branch; I forgot about
> most of them until doing a bit of fall/winter cleaning.  That said, the only
> one that is substantially complex is Anton's TSC snapshot fix, and that's been
> on the lists for many months.
> 
> Jim's IBPB fix is arguably fodder for 6.1, but the bug has been around for
> 2+ years so squeezing it in this late in the cycle doesn't seem necessary.
> 
> Holler if any of these give you pause!

All good!  Pulled, thanks.

Paolo

