Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C206E5A2585
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 12:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiHZKKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 06:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiHZKKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 06:10:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C342A6C10
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 03:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661508649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DcTpl0Wy35V0dtimCv1uimSCVwCZkiyLvJPUjMOsYiE=;
        b=Okl574a8QLObi89QkGXck7uRXY8BZR+/W87duOXW8s/MPgW+YYoFZCaadB4Nyh2V9kteTp
        j4Fnkfht5qMnYmODRxO3BpCwNwFmuDPXSgGDKrgIt6U8xq2X4XBcMltageQyjohyg6P9xs
        yCqMzDxMyWUO7KWTAEY1u/HDYcxH+qY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-550-Ws8p20mSPDCTHCk-7rESUA-1; Fri, 26 Aug 2022 06:10:48 -0400
X-MC-Unique: Ws8p20mSPDCTHCk-7rESUA-1
Received: by mail-ej1-f72.google.com with SMTP id sa33-20020a1709076d2100b0073d83e062c8so442126ejc.0
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 03:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=DcTpl0Wy35V0dtimCv1uimSCVwCZkiyLvJPUjMOsYiE=;
        b=xPVeLNPUbWniCaBkVRqplBzf2r1ie0XMAFq9Gl7yoC2sdsKWHvuJzwaeZ7xvH8Kv0R
         T0TKclTYGvuWgcFIfZvUKn2C1vVITDp1vEWrssHgHOOlXoxJGHhCdlX+K7nTjmE6ZwKE
         ahqEZLUD6e47Dk3noAjYiWsSBMdhjorvQrO8Rp7reKp1LElTderByK+kx8w/nzJHVnrU
         7Li0RPgoJP9neVe+M/oAlEojx+xJtqjp+cTrWydOWgc6nY03qFqFyq7bnW1EiYrvkqEk
         jrN7gjbiVzKjuTZ7CydNpOXOoqif7lz5r122zFS3X3sY9h6R3SkJOS4eafZJ2Yv+VIwP
         D2xQ==
X-Gm-Message-State: ACgBeo2MMlDZdrJIZidp/fEngUwKPCm1Eu0lJC813TRgIH9AvvJYJuiS
        FmaFM9Ew/I5IUQJF8qimKscwFgr1uDzyL5Y4mIbLxVKs313zpnWuvscN2OXsEd1SgUKr96G+PAb
        0rg8es0Z9lYW/
X-Received: by 2002:a05:6402:34d5:b0:446:cc39:2d38 with SMTP id w21-20020a05640234d500b00446cc392d38mr6209439edc.171.1661508647034;
        Fri, 26 Aug 2022 03:10:47 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7AwF3pGOxIX7OudqHD1JgPw34+XYwXsbIADeU85iqiVXbE8gx715QbeCQFyUk9JInkyzzBeA==
X-Received: by 2002:a05:6402:34d5:b0:446:cc39:2d38 with SMTP id w21-20020a05640234d500b00446cc392d38mr6209421edc.171.1661508646833;
        Fri, 26 Aug 2022 03:10:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id bq10-20020a170906d0ca00b00734b2169222sm687776ejb.186.2022.08.26.03.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 03:10:46 -0700 (PDT)
Message-ID: <b28c0e56-59b3-1152-56ef-490887cb0d87@redhat.com>
Date:   Fri, 26 Aug 2022 12:10:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Babu Moger <babu.moger@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        joro@8bytes.org, tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <CALMp9eSKcwChbc=cgYpdrTCtt49S1uuRdYoe83yph3tXGN6a2Q@mail.gmail.com>
 <e3718025-682d-469c-eac9-b4995e91dc11@redhat.com>
 <CALMp9eQCcy-MjB8Su+654XyL3zfR876tdh4QHUjvB7EiNjCU9A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eQCcy-MjB8Su+654XyL3zfR876tdh4QHUjvB7EiNjCU9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/22 19:16, Jim Mattson wrote:
>> Borislav asked to not show psfd in /proc/cpuinfo, because Linux had
>> decided not to control PSF separately; instead it just piggybacked
>> on SSBD which should disable PSF as well.  Honestly I disagree but
>> it's not my area of maintenance.
> 
> Do we expose PSFD in KVM for the use of another popular guest OS?

Yes, that was the purpose of this patch and we expose it via 
MSR_IA32_SPEC_CTRL (the only validation that KVM does is in 
kvm_spec_ctrl_test_value(), so it does not need to know more about the 
specific bits).

Paolo

