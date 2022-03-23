Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0CF4E5AB4
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 22:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344901AbiCWVe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 17:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241081AbiCWVe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 17:34:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E5783FBE8
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 14:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648071176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oh11iooAkmJrsdwWBjuA6GGBECOmBuX2cXQQcpcqSuY=;
        b=Xel+mS7/qETXRUFTspUtNzwhBThOliaN05yXgU6xkR1b13Vu6/Hax/fwcvOwPJVHioI7Bz
        iOZ9+mXNkzKmtnbgGOODqZ1tGgLXRfRJ9/hfmRAx20URM+wktWrkHzJ9XIkXNqJhvuF7SF
        HRQQ3M7T8204KUjGKiOR/qB0RcUVwho=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-cSxkFXQZMpmXiaRC3htGGw-1; Wed, 23 Mar 2022 17:32:54 -0400
X-MC-Unique: cSxkFXQZMpmXiaRC3htGGw-1
Received: by mail-ej1-f71.google.com with SMTP id mm20-20020a170906cc5400b006dfec7725f3so1446142ejb.15
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 14:32:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oh11iooAkmJrsdwWBjuA6GGBECOmBuX2cXQQcpcqSuY=;
        b=3PhZ7+DfsAVc4pUefZtNBRF8AD8nb/iZZq1RDCWnMw8AKEOJ6F5MMYG9GqhR6g/WJ8
         Z0kj05jdM5I4F1X+i1xLJWUHuHhAz9VIXtWJnWGX0hmahf4kkv/XolS2sRjixF+VJHD/
         ev442KR52meWRHtSk+tSeuFFlBrkQQ1nfWbtsS84etpzfIpJqOrwQv8sxhhOYCOyZA/2
         PlVAX4bGqJgc+sw/LHz3L6wX0nNPLDpfsEYudjtX8rnc5hiQta7/no/YLgeyohKNZcT+
         WLNE9B1UsUZkZgpR4SqhrlDHlZGSKyPCaJxhIYxinA7rvgsC3cxE/5LASadD3ba/KwMJ
         SYWg==
X-Gm-Message-State: AOAM532ba/24FoGaIUOIig1UWii8KwNPVln1YnLDpZrJCQnSRLyHpwSY
        ULCCOddJV/4IVC33EVpto5wc/McKDw0gWTp1kObbJWH4nAfyAL2LfMCCd28lDFWNEbt3J8+VUBp
        H9Gaj6gLXGaUW
X-Received: by 2002:a05:6402:454:b0:416:2db7:685b with SMTP id p20-20020a056402045400b004162db7685bmr2783664edw.43.1648071173694;
        Wed, 23 Mar 2022 14:32:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHYr8na/zz+NGxL5TIMj/1NzKsoC6teN3liiWE+FHimqyjued/mO1iRCI2LxxCqk4X8SpvwA==
X-Received: by 2002:a05:6402:454:b0:416:2db7:685b with SMTP id p20-20020a056402045400b004162db7685bmr2783648edw.43.1648071173499;
        Wed, 23 Mar 2022 14:32:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id r16-20020a056402019000b00418ed60c332sm476712edv.65.2022.03.23.14.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 14:32:52 -0700 (PDT)
Message-ID: <a35f9408-9d54-654c-6639-64192f03ba3b@redhat.com>
Date:   Wed, 23 Mar 2022 22:32:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 3/3] Documentation: KVM: add API issues section
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, jmattson@google.com
References: <20220322110712.222449-1-pbonzini@redhat.com>
 <20220322110712.222449-4-pbonzini@redhat.com> <Yjtj8qESPWIL221r@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yjtj8qESPWIL221r@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/23/22 19:16, Oliver Upton wrote:
> Do you think we should vent about our mistakes inline with the
> descriptions of the corresponding UAPI? One example that comes to mind
> is ARM's CNTV_CVAL_EL0/CNTVCT_EL0 mixup, which is mentioned in 4.68
> 'KVM_SET_ONE_REG'. That, of course, doesn't cover the
> previously-undocumented bits of UAPI that are problematic:)

It depends.  My intention was to use this document more for hidden 
interdependencies, in this case between KVM_GET_SUPPORTED_CPUID and 
KVM_CREATE_IRQCHIP, KVM_ENABLE_CAP(KVM_CAP_IRQCHIP_SPLIT), 
KVM_CAP_TSC_DEADLINE_TIMER.

Paolo

