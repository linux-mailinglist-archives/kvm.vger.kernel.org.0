Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121744CD849
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 16:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240502AbiCDPvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 10:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiCDPvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 10:51:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C14B2E339D
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 07:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646409013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RSyM1IOqRTw+sDMm/FTC+OW0Y6rlsHReLpr/RMqJ/kk=;
        b=PgeN/XCWTt1Wsw1qa25Mem529MlAlpQBSGhfVWW9k12fQ1kcCBYvWqkIQuxuzM94sfpJ6x
        RGuY0WEvcLQpKhaGjiJblMJ+09oIO5Ll0d6CWJ0vzeJpJhmrqVsvT8rbjhN4nXw27Q4Ofb
        m7Umo50rwAU2jUWQMQ9afXjE/DZf8RA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-vbz09wWYPmmtD4Jsjnxn4Q-1; Fri, 04 Mar 2022 10:50:12 -0500
X-MC-Unique: vbz09wWYPmmtD4Jsjnxn4Q-1
Received: by mail-ej1-f71.google.com with SMTP id sa22-20020a1709076d1600b006ce78cacb85so4611891ejc.2
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 07:50:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RSyM1IOqRTw+sDMm/FTC+OW0Y6rlsHReLpr/RMqJ/kk=;
        b=3J5g+d17FUUaCNe6kPT/KFgdkkF5MLbFuUUTQt/JnpqPV29FAe83GTXVDUjkIWJnPq
         ZH1vCUnhL8IaEw2w6BBL8mds6e9iQ/oBdUQQf5sNpScEjLfGYeILnx7jaTskRZIHLTBB
         VUjvNT5nmiMaOeJa/0ubf83l1HsAUNgIf3humYEooTNe8Tt0tcI/tQTP0kBe5IogWelg
         eDXPyElpC16flgeUavxzlfqmkpD58Ix9Fa5f4oaYyvmK7RW5XsKEO1JsZUhk+fJufujh
         7bsm/1CRNx/3Pc4JpA0EVzuuQExZErnxFS1nfJ4TZ4gPOHs14wmZ7gcZmwdSFuTgmzJB
         f2lw==
X-Gm-Message-State: AOAM530ym2VCuqP54MmIGXza+2yiyy1W8nvUrtsXM8Dm1yuwYgkfOD+U
        eIxVwklsNpFUKMaR1kIfrvvbBKHGQI9MCxKDSGTd6s0JumcrT5qRTsmcfSk3Djzq1oSj/zVzdLY
        sLceh2vAgWAjb
X-Received: by 2002:a17:906:6693:b0:6cf:3cb:89c9 with SMTP id z19-20020a170906669300b006cf03cb89c9mr32107376ejo.23.1646409011237;
        Fri, 04 Mar 2022 07:50:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxU52qwaa8M7rXiRYWdNAXDyMeYD/e9GMD9T8kr1tmdY40u9xyVVPOqOOKGeqvmIhzJlgidmw==
X-Received: by 2002:a17:906:6693:b0:6cf:3cb:89c9 with SMTP id z19-20020a170906669300b006cf03cb89c9mr32107363ejo.23.1646409010961;
        Fri, 04 Mar 2022 07:50:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c1-20020a170906762100b006d00ae72b0csm1838365ejn.221.2022.03.04.07.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 07:50:09 -0800 (PST)
Message-ID: <764d42ec-4658-f483-b6cb-03596fa6c819@redhat.com>
Date:   Fri, 4 Mar 2022 16:50:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
References: <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
 <Yh5pYhDQbzWQOdIx@google.com>
 <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com>
 <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
 <Yh/nlOXzIhaMLzdk@google.com> <YiAdU+pA/RNeyjRi@google.com>
 <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com>
 <YiDps0lOKITPn4gv@google.com>
 <CALMp9eRGNfF0Sb6MTt2ueSmxMmHoF2EgT-0XR=ovteBMy6B2+Q@mail.gmail.com>
 <YiFS241NF6oXaHjf@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YiFS241NF6oXaHjf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 00:44, Sean Christopherson wrote:
> 
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index c92cea0b8ccc..46dd1967ec08 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -285,8 +285,8 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
>  }
> 
>  /* No difference in the restrictions on guest and host CR4 in VMX operation. */
> -#define nested_guest_cr4_valid nested_cr4_valid
> -#define nested_host_cr4_valid  nested_cr4_valid
> +#define nested_guest_cr4_valid kvm_is_valid_cr4
> +#define nested_host_cr4_valid  kvm_is_valid_cr4

This doesn't allow the theoretically possible case of L0 setting some 
CR4-fixed-0 bits for L1.  I'll send another one.

Paolo

