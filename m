Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51BF609544
	for <lists+kvm@lfdr.de>; Sun, 23 Oct 2022 19:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiJWRvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Oct 2022 13:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiJWRvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Oct 2022 13:51:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850FD66F0A
        for <kvm@vger.kernel.org>; Sun, 23 Oct 2022 10:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666547463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D09MWv0UvzUmBKDXwZPzEI59Y82igwH0mMVX8RFHjcA=;
        b=EpW2aYsSLlwNjDIRbfNdXxyD42LuGvVfxHF8SEZGhbVAeccFpXDNbN9lCMWPN709ATiT8E
        9uizsGZO2kYnud2mTi8wJvj1dxiXdzE24ld+GvqGJHHh1MvBGb5FCWbxRIfwODFY2l1NAt
        2WhP+MWbOqD/v16lV6XWnYlTHu10Wpc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-493-XMK7AJHuNzOYwJqlwJqPyg-1; Sun, 23 Oct 2022 13:51:02 -0400
X-MC-Unique: XMK7AJHuNzOYwJqlwJqPyg-1
Received: by mail-ed1-f70.google.com with SMTP id m7-20020a056402430700b0045daff6ee5dso7283176edc.10
        for <kvm@vger.kernel.org>; Sun, 23 Oct 2022 10:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D09MWv0UvzUmBKDXwZPzEI59Y82igwH0mMVX8RFHjcA=;
        b=1srtP0kfSVnad4KX61vD/KS0kn9axpXWJDLv520PqvxKNN6oqGs+3J3fOw8tcstPmW
         LwcsLaPH0+SlLdKewR0JBEHTzK7L6ZWs4F/toMLMtwtrduIZ4ct2kvcjazalwzRJ3ghF
         hHizt7Dcdjes/NPOZXG/ryJ2uIqCj8bZnQFXAV5Tdj05dTsnNr1lGM4KEfmLaQqGmYeJ
         EawjVkPn3cAnpD3SHZ+tpRxI1IxfajaIOD5OLy0x+E/3KCWMJOS/n8CiwLenLipD46+z
         +W/3uv1Eeh5P6CraEZP/m25OywPCw4Z+d/SyKTqIYm6aOOgBaprPC1F4pFFjAdA/XE5W
         Dhag==
X-Gm-Message-State: ACrzQf26DJfZYIhkVZzVin5kHIlT/p+2YCbceGXfRZHpIW9/Qdz2MufM
        L3Drh5ni+LouQa2l7qe23gFAQpX8V4w+XbWFCuPr2KRyHV/vCtYVDx1wzeJkmh4+/h/evjoUwMX
        v8eGvQY7GY/lO
X-Received: by 2002:a05:6402:5253:b0:45d:5914:245b with SMTP id t19-20020a056402525300b0045d5914245bmr28001383edd.227.1666547459345;
        Sun, 23 Oct 2022 10:50:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4lselhb4mBLW2XIV0vJT8VL/BMXi1ZtLK17hfsJ/qDg+TASFANunS0l1JbfqLOFrZxQJtg7g==
X-Received: by 2002:a17:907:9611:b0:78d:bb06:90a3 with SMTP id gb17-20020a170907961100b0078dbb0690a3mr24419521ejc.233.1666547448280;
        Sun, 23 Oct 2022 10:50:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id d14-20020a170906304e00b0078250005a79sm14429105ejd.163.2022.10.23.10.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Oct 2022 10:50:47 -0700 (PDT)
Message-ID: <62500f94-b95b-1e16-4aa2-f67905fab01a@redhat.com>
Date:   Sun, 23 Oct 2022 19:50:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 3/4] KVM: introduce memory transaction semaphore
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
 <20221022154819.1823133-4-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221022154819.1823133-4-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/22/22 17:48, Emanuele Giuseppe Esposito wrote:
> +static DECLARE_RWSEM(memory_transaction);

This cannot be global, it must be per-struct kvm.  Otherwise one VM can 
keep the rwsem indefinitely while a second VM hangs in 
KVM_KICK_ALL_RUNNING_VCPUS.

It can also be changed to an SRCU (with the down_write+up_write sequence 
changed to synchronize_srcu_expedited) which has similar characteristics 
to your use of the rwsem.

Paolo

