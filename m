Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEA160C9AA
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 12:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiJYKN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 06:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiJYKNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 06:13:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012ED148F74
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 03:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666692307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WkMY2q7k/FRScATXzFjfEIt8wnjgYfKsZeIIXZ3g4lg=;
        b=TQbOIQV3bDWg1hgoh2ldytt/Is6yZRqK4ahz/A9kG+iELNVo70FU80tpASLNEWqdyHJ8tI
        s7D96cskDqVX7gLiUwXZ077y1OkzrEM4iGIVj1UQUt86VLKkWDQCBFjj/+uYJyizBBWval
        6Xnk0t6j9RK1FL8yM7zIzjvwm/0Gh0M=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-483-AxfgyMAuPb2Up-uNoNNZwQ-1; Tue, 25 Oct 2022 06:05:06 -0400
X-MC-Unique: AxfgyMAuPb2Up-uNoNNZwQ-1
Received: by mail-qv1-f69.google.com with SMTP id c2-20020a05621401c200b004bb71b13dfcso2489140qvt.6
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 03:05:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WkMY2q7k/FRScATXzFjfEIt8wnjgYfKsZeIIXZ3g4lg=;
        b=C2xypoSmHO/n+qYX37A6yo6c71VPVlmeAJrfGZoPMR7tCpTHiuMwtcgR91x7cNGbt4
         MIRxQcZqztKYsuXLAjdx9qzo5WjafLSdRU+R9mRuGeV9sv0q9hBQpPbuTPQADqa3++EX
         FvSeNtf755WCBFCpttyCF6wBihkERmYpFTnlkDW3Ut5g5ENthF8Vd1Hbv4CS5xRuDbUD
         62Ijc57ePaXozRjv+4hEvWXWPSzlqjMdexaOjUnbOYYFjE2AO0Hog/WS2Zf7ymK9D3Nq
         Oj94i8Qx7AJPMZa4dR7jXrsH8bGWw+gpQMSPlUbW/RMNcD+hM6eBBf+kfz83IL+sh66Z
         tg1w==
X-Gm-Message-State: ACrzQf00eCPZBDvG55pEBJFeH54gzOasy059fBQDmsYJyNZdHgW/Sf/l
        TPQugoApScs7U1WJKNEeEc2mB2nirtea1394g3qKgQeey8uvFQGr25gt6UO5k6FNy/8mcFgXjNo
        J5FaQmR9SnVC4
X-Received: by 2002:a05:6214:21e5:b0:4b3:f3e0:5432 with SMTP id p5-20020a05621421e500b004b3f3e05432mr30997926qvj.19.1666692305292;
        Tue, 25 Oct 2022 03:05:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM693U09GZt8c3TCu0FJo9qI1g4ScuhxN9DXfAJplWl/vGo09zLnXBtWBBG2qZwZQgoHuj3OGw==
X-Received: by 2002:a05:6214:21e5:b0:4b3:f3e0:5432 with SMTP id p5-20020a05621421e500b004b3f3e05432mr30997911qvj.19.1666692305082;
        Tue, 25 Oct 2022 03:05:05 -0700 (PDT)
Received: from [10.201.49.36] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.googlemail.com with ESMTPSA id d13-20020a05620a240d00b006bc192d277csm1807519qkn.10.2022.10.25.03.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 03:05:04 -0700 (PDT)
Message-ID: <6812bb87-f355-eddb-c484-b3bb089dd630@redhat.com>
Date:   Tue, 25 Oct 2022 12:05:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 4/4] KVM: use signals to abort enter_guest/blocking and
 retry
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221022154819.1823133-1-eesposit@redhat.com>
 <20221022154819.1823133-5-eesposit@redhat.com>
 <5ee4eeb8-4d61-06fc-f80d-06efeeffe902@redhat.com>
 <4ef882c2-1535-d7df-d474-e5fab2975f53@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4ef882c2-1535-d7df-d474-e5fab2975f53@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/24/22 09:43, Emanuele Giuseppe Esposito wrote:
>> Since the userspace should anyway avoid going into this effectively-busy
>> wait, what about clearing the request after the first exit?  The
>> cancellation ioctl can be kept for vCPUs that are never entered after
>> KVM_KICK_ALL_RUNNING_VCPUS.  Alternatively, kvm_clear_all_cpus_request
>> could be done right before up_write().
>
> Clearing makes sense, but should we "trust" the userspace not to go into
> busy wait?

I think so, there are many other ways for userspace to screw up.

> What's the typical "contract" between KVM and the userspace? Meaning,
> should we cover the basic usage mistakes like forgetting to busy wait on
> KVM_RUN?

Being able to remove the second ioctl if you do (sort-of pseudocode 
based on this v1)

	kvm_make_all_cpus_request(kvm, KVM_REQ_USERSPACE_KICK);
	down_write(&kvm->memory_transaction);
	up_write(&kvm->memory_transaction);
	kvm_clear_all_cpus_request(kvm, KVM_REQ_USERSPACE_KICK);

would be worth it, I think.

Paolo

