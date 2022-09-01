Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD7C5AA389
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 01:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbiIAXN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 19:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbiIAXN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 19:13:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D15F7C1E8
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 16:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662074036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0uNFRShYMMlbuXwRO4iSE3fZJzbHHJMWnBQqnMlM0WI=;
        b=PKw7W7FWfWgvc/d1CKeKsqyC0Y7vINKMQKXqiQBeDZyooulyY/jaMVwfRl6IqOQDmED53S
        Vw2u3Y8p/+i+N+OD2IiigG/kVB+4TzHAa6UaboykSbn0Cknb8GmAC7oDazpgXDMV40fdMW
        ci2Dw1zrLz7lIaqYZaLmAIFRTvqlxno=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-160-fLIklRYbPC2bq5L0MFUAcA-1; Thu, 01 Sep 2022 19:13:52 -0400
X-MC-Unique: fLIklRYbPC2bq5L0MFUAcA-1
Received: by mail-ej1-f71.google.com with SMTP id dr17-20020a170907721100b00741a1ef8a20so132750ejc.0
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 16:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0uNFRShYMMlbuXwRO4iSE3fZJzbHHJMWnBQqnMlM0WI=;
        b=ziKX9F6rYB5t4bjavTauCxFlCi1gcFcPursqXXYZEs+DOcnC2RtoL3IpJ65bx7A9TA
         7Y1c3Kn84L03z+L6iXVUtU1bElLYgXAVNDzPgKNYXXfvQtm2Nyt1Hx6ywAVYY+jvHqYw
         Ftm2pi5bJTN021iYwUFuLX8ZCz+bDsqFoqLIHcvFWDEocPDsf6uqlTRnd/RefJT7I92i
         +A3CHlTRYaDgNxNyxiDCP/7ous3kTYqAf1u/PH9fL/iuSakPw9jf8NxCHFpA0o+THAmf
         4MH2hxfPnGi3UM7M4cCGUfZSTSbJErFZx+waxIuiC4ccNmoR7H27FymiaZx+3nEXTMd7
         cZnw==
X-Gm-Message-State: ACgBeo2KpjOhX8e4nEMfshmfCjnwztcpVPfkgbPrt6gJwTcR4eI/6rto
        8L13sXZzMwp9l7/UlTYRU4L+qiKE5KYw1/iWyvUWCYF6p7kMp3C7/6YkzlH2JPKAigcV91g4eeV
        k9Ir45nUOUpap
X-Received: by 2002:a05:6402:288b:b0:444:26fd:d4c4 with SMTP id eg11-20020a056402288b00b0044426fdd4c4mr30482814edb.249.1662074031333;
        Thu, 01 Sep 2022 16:13:51 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6zsbdYTuP6k9HNNGPrxH5P4h8py4rrct2hzmI2l6mRFqYqg6/bMImhLzm96AZERsQOmkhRhg==
X-Received: by 2002:a05:6402:288b:b0:444:26fd:d4c4 with SMTP id eg11-20020a056402288b00b0044426fdd4c4mr30482807edb.249.1662074031166;
        Thu, 01 Sep 2022 16:13:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id x68-20020a50baca000000b0044bfdbd8a33sm256247ede.88.2022.09.01.16.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 16:13:50 -0700 (PDT)
Message-ID: <a30dec19-f6f7-4d3b-0124-44f30d587567@redhat.com>
Date:   Fri, 2 Sep 2022 01:13:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2] KVM: x86: Mask off unsupported and unknown bits of
 IA32_ARCH_CAPABILITIES
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Vipin Sharma <vipinsh@google.com>
References: <20220830174947.2182144-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220830174947.2182144-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/30/22 19:49, Jim Mattson wrote:
> KVM should not claim to virtualize unknown IA32_ARCH_CAPABILITIES
> bits. When kvm_get_arch_capabilities() was originally written, there
> were only a few bits defined in this MSR, and KVM could virtualize all
> of them. However, over the years, several bits have been defined that
> KVM cannot just blindly pass through to the guest without additional
> work (such as virtualizing an MSR promised by the
> IA32_ARCH_CAPABILITES feature bit).
> 
> Define a mask of supported IA32_ARCH_CAPABILITIES bits, and mask off
> any other bits that are set in the hardware MSR.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Fixes: 5b76a3cff011 ("KVM: VMX: Tell the nested hypervisor to skip L1D flush on vmentry")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Vipin Sharma <vipinsh@google.com>
> ---
> 
>   v1 -> v2: Clarified comment about unsupported bits.

Queued, thanks.

Paolo

