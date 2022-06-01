Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37BF539FF8
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245063AbiFAI73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346074AbiFAI71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:59:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7076B6BFC1
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 01:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654073965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uzxCOihBBp2MvYCnWOOgAbyz9Dw1/OZ2iZqah66p3+o=;
        b=EXOjlnKQirydQ4DGET0xbN2cNa7Z4L70epX6LmNKhu9loYdD15pyTETP25xHGuxCuJVG7A
        4XIiqBTwMdBcx6IAxe/0BSkmgiMyA/pS5eAPF2CpRmbuhi14SWtJYPqCZ4ZByJjpE7lVF2
        nQE8rwCdnsiYKtQWG2S6MN5nYYfmGvw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-8putw-8SNg-A-YCsYOJUMg-1; Wed, 01 Jun 2022 04:59:24 -0400
X-MC-Unique: 8putw-8SNg-A-YCsYOJUMg-1
Received: by mail-ej1-f71.google.com with SMTP id v13-20020a170906b00d00b006f51e289f7cso593032ejy.19
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 01:59:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uzxCOihBBp2MvYCnWOOgAbyz9Dw1/OZ2iZqah66p3+o=;
        b=KoxIY6nUaeHJajl+CatbooeswFfPocudeXbZJT53ctK0GWL5d22/eXjUVqNK/gPYxL
         u9HtQ+A7u78rEQ9/49Hjr34dELvl+wZnXGs0I/jsX6WI1ZwpxoStIJujeJQAkSWVTevS
         r3roM5GepO16TCp7aYKxOZTOZGJxQp5Qfy+/G1SQIx/fW/CAxnAy1SS5LiRtxa2iK728
         sx8XFvNMGta9vHYTAu3gutB/PUMONT7fxYsF8qTomQ/xJiszApIhDX4CTOEsOU7uey60
         EIcByqRHJzHeYpJfTkANZTaqqV68ATEVpnK3CaZa/cR0Wru27sN9wLFIqtsimMkPWWc+
         uU1g==
X-Gm-Message-State: AOAM532wRod/rNDdDcK6ZIOJPleNVQ5Ujue5EsKRw922322zZQt8DvCO
        0kCuV72Nh2KogDALZfD0lPvYGsg0v9xcR3a1tUFqQEn+q6MlyKfPnnByRfJX3vynzdYyOAEhNTg
        azo2M0xRDe7jg
X-Received: by 2002:a50:ea8b:0:b0:428:7d05:eb7e with SMTP id d11-20020a50ea8b000000b004287d05eb7emr66994813edo.185.1654073963162;
        Wed, 01 Jun 2022 01:59:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcZzdAmqTqAOV48EeckvF3+BiTMXPZ6japnr184Gq8Eqzb54YOTFyRdX28qRg+QRUvnZvVOA==
X-Received: by 2002:a50:ea8b:0:b0:428:7d05:eb7e with SMTP id d11-20020a50ea8b000000b004287d05eb7emr66994790edo.185.1654073962970;
        Wed, 01 Jun 2022 01:59:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id cx12-20020a05640222ac00b0042bd6630a14sm644395edb.87.2022.06.01.01.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 01:59:22 -0700 (PDT)
Message-ID: <b9238c07-68a7-31fa-c654-d8111a1e2d4b@redhat.com>
Date:   Wed, 1 Jun 2022 10:59:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: ...\n
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        "Allister, Jack" <jalliste@amazon.com>
Cc:     "bp@alien8.de" <bp@alien8.de>,
        "diapop@amazon.co.uk" <diapop@amazon.co.uk>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "metikaya@amazon.co.uk" <metikaya@amazon.co.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
 <307f19cc-322e-c900-2894-22bdee1e248a@redhat.com> <87tu94olyd.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87tu94olyd.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/22 09:57, Vitaly Kuznetsov wrote:
>>> I'll bite... What's ludicrous about wanting to run a guest at a lower CPU freq to minimize observable change in whatever workload it is running?
>> Well, the right API is cpufreq, there's no need to make it a KVM
>> functionality.
> KVM may probably use the cpufreq API to run each vCPU at the desired
> frequency: I don't quite see how this can be done with a VMM today when
> it's not a 1-vCPU-per-1-pCPU setup.

True, but then there's also a policy issue, in that KVM shouldn't be 
allowed to *bump* the frequency if userspace would ordinarily not have 
access to the cpufreq files in sysfs.

All in all, I think it's simpler to let privileged userspace (which 
knows when it has a 1:1 mapping of vCPU to pCPU) handle it with cpufreq.

Paolo

