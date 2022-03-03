Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3E44CB788
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiCCHPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiCCHPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:15:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 055361275D1
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646291689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WEqRPqaD5FWGRJv5e1sQSjcE5/2LakOMZH9spOXim5M=;
        b=JRqxx7fWw6ZHMfNVkrcBhznv29SAZ/DT0b4w3Olvl+JQJAIYBuxpzvsgenTpnNlrFqFjJR
        5b0EgoaA8B3855D9b3jLuU/PL20Ip+b2pzjzWfK5NZlp28iHInKYOfsLrgSpV1yhUV5Qqk
        gVCJvbffcE8YSPJMSfIVSapEjzw2ymc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-SsM5ngmAMZKKXff9MHvlKA-1; Thu, 03 Mar 2022 02:14:45 -0500
X-MC-Unique: SsM5ngmAMZKKXff9MHvlKA-1
Received: by mail-wm1-f69.google.com with SMTP id m34-20020a05600c3b2200b0038115c73361so1035084wms.5
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 23:14:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WEqRPqaD5FWGRJv5e1sQSjcE5/2LakOMZH9spOXim5M=;
        b=RkBOdvbLd80N99ej//QlMob7b3RK7HEHB+THBhmeMQB5Y4xbciplgQUG/+GnBV+xN+
         Xtr9XsoSsSuus2TTIqAwohQrjAHHMVAekKIUlUVbG0yIEWClD83T5XbYemC41gcvBoy9
         Couq1GHrzdiO3hIutBT+Wm0ZbziOguWP0zMa0ohFLEBOd3vMIA1U+BwLJ82o/FiqeMBm
         f4Q7a6FXgEaOa4FY9nj1aUiWDYQoaRleExVZmiH0dAVCjberdnB30Wm4AhRpcKz0morE
         ESiJ51joIlsGo0LYlZTPiXV9zQqaZ1r0jAN5ZfGcMmnLUWvbq/m315xwUSCPdT1FmFz1
         aO4w==
X-Gm-Message-State: AOAM533B2n5AsuZLgOmYg9MJFFTNn8sE7OE/n54gWSDXa45MC1k13uKt
        Yy1lqgBW7j6TC4fTjahmlXvxFmPKwdU1q/q2xVTjaAFW9qbiH82F0z1Y0BgqzCv5E9NZUobaVAP
        Zatebj3RR4EgU
X-Received: by 2002:a05:6000:143:b0:1f0:25a1:874c with SMTP id r3-20020a056000014300b001f025a1874cmr5296254wrx.191.1646291684445;
        Wed, 02 Mar 2022 23:14:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmjuyMNNC6DR/Bl4cLZuPvdIEPk0k/BS2RIKyITE+TQM+Zj5AHfzvYai86xVZe0dQU+DiiAA==
X-Received: by 2002:a05:6000:143:b0:1f0:25a1:874c with SMTP id r3-20020a056000014300b001f025a1874cmr5296233wrx.191.1646291684224;
        Wed, 02 Mar 2022 23:14:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id 11-20020a05600c22cb00b00382a960b17csm6127182wmg.7.2022.03.02.23.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 23:14:43 -0800 (PST)
Message-ID: <0c22b156-10c5-1988-7256-a9db7871989d@redhat.com>
Date:   Thu, 3 Mar 2022 08:14:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 4/7] KVM: x86/mmu: Zap only obsolete roots if a root
 shadow page is zapped
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <20220225182248.3812651-1-seanjc@google.com>
 <20220225182248.3812651-5-seanjc@google.com>
 <40a22c39-9da4-6c37-8ad0-b33970e35a2b@redhat.com>
 <ee757515-4a0f-c5cb-cd57-04983f62f499@redhat.com>
 <Yh/JdHphCLOm4evG@google.com>
 <217cc048-8ca7-2b7b-141f-f44f0d95eec5@redhat.com>
 <Yh/1hPMhqeFKO0ih@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh/1hPMhqeFKO0ih@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 23:53, Sean Christopherson wrote:
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index c5e3f219803e..7899ca4748c7 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3857,6 +3857,9 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu,
>> hpa_t root_hpa,
>>          unsigned long cr3;
>>
>>          if (npt_enabled) {
>> +               if (is_tdp_mmu_root(root_hpa))
>> +                       svm->current_vmcb->asid_generation = 0;
>> +
>>                  svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
>>                  vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
>>
>> Why not just new_asid
> My mental coin flip came up tails?  new_asid() is definitely more intuitive.
> 

Can you submit a patch (seems like 5.17+stable material)?

Paolo

