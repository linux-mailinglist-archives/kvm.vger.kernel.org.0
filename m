Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBD3514C5E
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376611AbiD2OKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377130AbiD2OK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:10:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD5298CCD1
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651241156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xKDdsM4MIWkc8vNQb6ubKyY0KGO/jrEC70jcj8M7HbU=;
        b=VNKO4t4J9cUBRkM4eTMPdzJlVe0f6DYQcUE/zkR/rhpXe8geVL7M9EJZraBS4aWnl8KeY3
        BhGnfobrbJNMgSrD4lPi5vCKVILHmPnGsxwTAjkrkHA+PdFgQxcTeDB6PPK3LL9CL0wMHs
        tAP3v0vMLnsmAQ8fY0RHi9HFIjcvmBs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-xYfY2k8IPFSpIsEqAUauiQ-1; Fri, 29 Apr 2022 10:05:55 -0400
X-MC-Unique: xYfY2k8IPFSpIsEqAUauiQ-1
Received: by mail-ej1-f70.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso4601850ejs.12
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xKDdsM4MIWkc8vNQb6ubKyY0KGO/jrEC70jcj8M7HbU=;
        b=6POZOx6bAblNrk9GGVYrLobWaQQq/z2Vbv7kIRME1TfYfTZ1z7gZBMQTnVrUonxO2D
         QuoCUQMHp0P/+s2q9RqV2stWK1fuDXhyWCM+2FZknc/H1z3D6C8VJ+ADADPoQHSUOVj/
         QwtgRyuCsA+dWlbpFnjKIojxBSBxyxDUlavDPa/bgJgrbf2lWFLi9ka41xTsAVWRCxtC
         y3I9FpgJy/OjmI4Xv4U/OGTjkv8WazXAsoovhzvvywmdR6ZmZzshp8FFp7CmDqdFggSu
         Akf3OiyqUHsRqWrhkIhzAXXZO8+w0X7NqM5ewj37qlMPYiLX0avlPEnnOh+5sXVL55/6
         m8xA==
X-Gm-Message-State: AOAM531GMq2THxf6yTuWdQRsjQgV3ImpTy+vA91ROtW6MFDycimAx1H+
        VfVmaDyfFqf3+WJXGm0MYyuz+LPu/HU5IS5KfofinoV5DXKCs9DZjX9ucI9XdLh287CvCsT0AC1
        ESkU0x+zam4R4
X-Received: by 2002:aa7:c58e:0:b0:425:b5e3:6c51 with SMTP id g14-20020aa7c58e000000b00425b5e36c51mr1321407edq.99.1651241154224;
        Fri, 29 Apr 2022 07:05:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVA32tC1Jm5pRpOfD7vJcD40YR0MhY1LIRWmSQXXpuV+3PjRXFG7z+RLgbuUJ5MVEEPQKoBQ==
X-Received: by 2002:aa7:c58e:0:b0:425:b5e3:6c51 with SMTP id g14-20020aa7c58e000000b00425b5e36c51mr1321389edq.99.1651241154023;
        Fri, 29 Apr 2022 07:05:54 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id qs24-20020a170906459800b006f3ef214e1bsm689383ejc.129.2022.04.29.07.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 07:05:53 -0700 (PDT)
Message-ID: <bbf38496-658a-d6ca-b76c-d3642609b8fb@redhat.com>
Date:   Fri, 29 Apr 2022 16:05:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH for-5.18] KVM: fix bad user ABI for KVM_EXIT_SYSTEM_EVENT
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Gonda <pgonda@google.com>
References: <20220422103013.34832-1-pbonzini@redhat.com>
 <YmvwK0MeKpsQkZN4@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YmvwK0MeKpsQkZN4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 16:03, Sean Christopherson wrote:
> On Fri, Apr 22, 2022, Paolo Bonzini wrote:
>> For compatibility with userspace that was using the flags field,
>> a union overlaps flags with data[0].
> 
> I think "compatibility" is slightly misleading, e.g. the offset of the field is
> changing for 32-bit userspace.

Well, the only such userspace AFAIK is crosvm on ARM and there's no 
compat ABI for ARM.  But yeah, your wording below sounds good.

>    To avoid breaking compilation of userspace that was using the flags
>    field, provide a userspace-only union to overlap flags with data[0].
> 
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 91a6fe4e02c0..f903ab0c8d7a 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -445,7 +445,11 @@ struct kvm_run {
>>   #define KVM_SYSTEM_EVENT_RESET          2
>>   #define KVM_SYSTEM_EVENT_CRASH          3
>>   			__u32 type;
>> -			__u64 flags;
>> +			__u32 ndata;
>> +			union {
>> +				__u64 flags;
> 
> As alluded to above, what about wrapping flags in
> 
> #ifndef __KERNEL__
> 				__u64 flags;
> #endif
> 
> so that KVM doesn't try to use flags?

Interesting idea.  I'll apply it and push the patch.

Thanks for the review!

Paolo

>> +				__u64 data[16];
>> +			};
>>   		} system_event;
>>   		/* KVM_EXIT_S390_STSI */
>>   		struct {
> 

