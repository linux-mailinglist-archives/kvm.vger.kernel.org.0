Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03DA6AD0C8
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 22:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCFVsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 16:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjCFVsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 16:48:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE2959E7E
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 13:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678139242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Br2fM+dq2MbmdwWMegmiUL+0/JHBwu0al6ub8wm0Pc=;
        b=LyvgJE4xsVbQlJ3Ud4cSqi7KI5wyhQ3JDUssDIkvxOluFXkW9C53an0lrbGdMgPOxKjnlJ
        eLom76YDGsV3aAAbQ5eICRpZSwwCTF62a3ZKW1UbBehHoNg+6cwOqLY6HblVQxJp0cYjxr
        NOSyD8/0LWyLLnlSwUrlab/cwrwN0b0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-Tf0URH-TO72CRtMR-t79QA-1; Mon, 06 Mar 2023 16:47:21 -0500
X-MC-Unique: Tf0URH-TO72CRtMR-t79QA-1
Received: by mail-ed1-f69.google.com with SMTP id k12-20020a50c8cc000000b004accf30f6d3so15794037edh.14
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 13:47:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678139240;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Br2fM+dq2MbmdwWMegmiUL+0/JHBwu0al6ub8wm0Pc=;
        b=xwQkzPvMlHR41cx56e5YP0W/CND8KFO7pxZuv6ywcX8wcJ5SxWE9YbTcNG2tJ9ECKX
         P53Dn559NoBjqhZlpv8O5/RKC5KoN82g8/V1ZnewdTBgTP8OBzKs9xZXzJs4DYtt+HD3
         siDPKpK12o1EbPTbn72oNDAxP/ilrYODglUm8FIYXFkyBqMrKUCCwOcr6JOWB5YzwVw0
         NRCkv+GPycaMP2gsoF60njCy2Q/7vSo/acRBzKAN+UnfAzYs/oldrDZaLwBXZBOaU/N1
         4WLvg3Cd7riJUChqdOiFp6x2IUYJHw/BV9VNcxI8vxItWezabV26aFEICc0pGveLPGOZ
         v7ZA==
X-Gm-Message-State: AO0yUKV2Qd6KVtBtmiMr1wxrkz5y4rQMwsPBvMdpbRsKmYfxIk7sjSeP
        5puuvXcVozMmkAO+wpb34kTJYympsfch6RH/NxW0hUrIztSNDD0ntb8J8F+pAbpmVw5Om93RYIp
        ycq75fc9iLKQ1
X-Received: by 2002:a17:906:af18:b0:8aa:c155:9233 with SMTP id lx24-20020a170906af1800b008aac1559233mr12129684ejb.26.1678139240345;
        Mon, 06 Mar 2023 13:47:20 -0800 (PST)
X-Google-Smtp-Source: AK7set9qQPWhkT+H5o/LyE5GoVofPJyoXfzrQkR7RrrdA855YpEt4uUAQN2kIdBCGLf1sQdplSc7zw==
X-Received: by 2002:a17:906:af18:b0:8aa:c155:9233 with SMTP id lx24-20020a170906af1800b008aac1559233mr12129662ejb.26.1678139240017;
        Mon, 06 Mar 2023 13:47:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id i2-20020a17090685c200b008dcaf24bf77sm5048067ejy.36.2023.03.06.13.47.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 13:47:19 -0800 (PST)
Message-ID: <25249e7d-4fd9-e1c1-8efb-31750740ec27@redhat.com>
Date:   Mon, 6 Mar 2023 22:47:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     Takahiro Itazuri <itazur@amazon.com>, dave.hansen@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        zulinx86@gmail.com
References: <Y/5oBKi6vjZe83ac@zn.tnic>
 <20230228222416.61484-1-itazur@amazon.com> <Y/6FIeJ5KCOfKEPN@zn.tnic>
 <ZAZYKe4L8jhMG4An@google.com>
 <20230306214419.GDZAZes941k+4NPgDL@fat_crate.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230306214419.GDZAZes941k+4NPgDL@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/6/23 22:44, Borislav Petkov wrote:
>> I thought that the consensus was that adding unused-by-the-kernel flags to
>> cpufeatures.h is ok so long as the feature is hidden from /proc/cpuinfo and the
>> kernel already dedicates a word to the CPUID leaf?
> I guess we should finally write it down in Documentation/x86/cpuinfo.rst
> 
> And in case there's no dedicated word, it should be resorted to KVM-only
> feature flags.
> 
> In any case, I'd like for baremetal CPUID stuff to be decoupled from
> KVM's machinery as far as possible as both have different goals wrt
> feature flags.

It's very rare that KVM can provide a CPUID feature if the kernel has 
masked it, so if the kernel needs to know about a feature word than KVM 
most likely needs to know what kind of massaging the kernel has done.

Paolo

