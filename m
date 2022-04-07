Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF42C4F87BA
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 21:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245438AbiDGTM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 15:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbiDGTM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 15:12:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0EA616F6E5
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 12:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649358623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wELi7D3Yj0ogQ+r/idqS4CmYCSZ0XcztWiK5NXeQqkc=;
        b=JqWsblJQ1AvS4mC66NCKAS5FixQLQUzvGCiCFggidgTNI77WNnrytYlq/zKzSjJ6YYdzYl
        /OkGdaz5xXXIV7dn1NpRhQbQUDs8aJGK07LYPctzbDyT/9r+sjCCHiXdmFoUj3sNFPqT6M
        sK7osMdq/Oxe+dSr35iqI7OMDa2Almc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-kAAXxnQ9PSGC6LZiANeTGw-1; Thu, 07 Apr 2022 15:10:20 -0400
X-MC-Unique: kAAXxnQ9PSGC6LZiANeTGw-1
Received: by mail-ej1-f70.google.com with SMTP id sb14-20020a1709076d8e00b006e7eb9719b9so3576178ejc.21
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 12:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wELi7D3Yj0ogQ+r/idqS4CmYCSZ0XcztWiK5NXeQqkc=;
        b=RbtYibYBqHvtqKlW9k4v2r+2+WU+am2PluUOd1mC4NQqtstormQaZoCd7L04jQqC8V
         Rkmnl2dkAfP4DKUwrct3zLotfzRhLAEmc+o9US30NB4op2IHt25e4MYOrj/y5IU6a6F6
         Ve3xnvGn0TIuRHTcC4Iwy5QC+68EiBLSjqwXlVTw+oWPD+7I2dK1zLvCTWnukFHKlLZU
         r/P8ISSTsWaa6mqtL00tT7a66DXn2ZMC3cYS8oqto1cCcjUz1tveZUAFX0yCdB3QGJVG
         LX751+74+H/1QAiBGQ7k0TnBGjwyPoD0e60Qi4yi1OjbdbJBpqTVSPTc33H/V0ENMbW4
         5rCg==
X-Gm-Message-State: AOAM530FYYqTwKxebt6KYRL8L06/WlqDpw2WhluTYiu6gJ601hVTZTlc
        2d5jJS/7q17PXZ2r6YACApFgpuPbCuyqknS62l6ff2Z9zDNaERUNkc645KicDONc9LN2MxMlBoP
        3nPBG0KQaLei+
X-Received: by 2002:a17:906:c0c8:b0:6d0:562c:2894 with SMTP id bn8-20020a170906c0c800b006d0562c2894mr15122762ejb.625.1649358619436;
        Thu, 07 Apr 2022 12:10:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqOTR+zvElIwRf8zaAcdnR8WEkDbO25wQIQ4j1EDJnCmTwc0+2xL6U7uvXvU80O9lNimASLw==
X-Received: by 2002:a17:906:c0c8:b0:6d0:562c:2894 with SMTP id bn8-20020a170906c0c800b006d0562c2894mr15122747ejb.625.1649358619259;
        Thu, 07 Apr 2022 12:10:19 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b14-20020a170906d10e00b006e803595901sm3641599ejz.172.2022.04.07.12.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 12:10:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: hyper-v: Avoid writing to TSC page without an
 active vCPU
In-Reply-To: <Yk8OJ5Y1IKky9cnz@google.com>
References: <20220407154754.939923-1-vkuznets@redhat.com>
 <Yk8OJ5Y1IKky9cnz@google.com>
Date:   Thu, 07 Apr 2022 21:10:17 +0200
Message-ID: <87o81c7lra.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 676705ad1e23..3460bcd75bf2 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -979,10 +979,10 @@ enum hv_tsc_page_status {
>>  	HV_TSC_PAGE_GUEST_CHANGED,
>>  	/* TSC page MSR was written by KVM userspace, update pending */
>>  	HV_TSC_PAGE_HOST_CHANGED,
>> +	/* TSC page needs to be updated due to internal KVM changes */
>> +	HV_TSC_PAGE_KVM_CHANGED,
>
> Why add KVM_CHANGED?  I don't see any reason to differentiate between userspace
> and KVM, and using KVM_CHANGED for the kvm_vm_ioctl_set_clock() case is wrong as
> that is very much a userspace initiated update, not a KVM update.

Indeed, there seems to be no benefit in differentiating between
HV_TSC_PAGE_HOST_CHANGED and HV_TSC_PAGE_KVM_CHANGED. Let me retest
without it, I'll be sending v2 shortly.

>
>>  	/* TSC page was properly set up and is currently active  */
>>  	HV_TSC_PAGE_SET,
>> -	/* TSC page is currently being updated and therefore is inactive */
>> -	HV_TSC_PAGE_UPDATING,
>>  	/* TSC page was set up with an inaccessible GPA */
>>  	HV_TSC_PAGE_BROKEN,
>>  };
>

-- 
Vitaly

