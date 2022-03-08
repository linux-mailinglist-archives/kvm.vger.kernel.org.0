Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19644D1F70
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349293AbiCHRvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348709AbiCHRvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:51:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C78254FB6
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646761826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HhVq4NG09Yd9b8QvgLRVbkikFbdePpQBri7vAnREkiw=;
        b=c3nVvjDYY+/sC6BIyguvMlprBpkpkVcsYhp7PJPAUk1iaOt6/s096ca0RIPx22TKrUeB7r
        5YpWB/mXbYSayb4/RgHAWfTg/j1GS5V0uaPThU9X+Mb8LweN8DRZezoVmd/lr280dG3J0H
        WMv1DKoXtX4PDht5YiZE/Vb6bsINRrA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-cTZIpXO0MUuvfJgPqNNvBQ-1; Tue, 08 Mar 2022 12:50:25 -0500
X-MC-Unique: cTZIpXO0MUuvfJgPqNNvBQ-1
Received: by mail-wm1-f72.google.com with SMTP id r133-20020a1c448b000000b00385c3f3defaso6307499wma.3
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:50:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HhVq4NG09Yd9b8QvgLRVbkikFbdePpQBri7vAnREkiw=;
        b=QgLRRUwpPncp2tI64iSuz4wVlD4K8hJ8bc1jnCxncLSIPRkHCu9vPKB1PlXHx4hItD
         uiPTOl25RefafQU4h8dWkGO2s97C53n5bCtk8w6SljRY/Prxdnnn5tOzGVr3aUJI0abN
         nWGOANs+9U+VTF3tr4pSC3pPHIpkf12emP+WoS6/XGpSyIoVFtnMNXF7YKizUs/Am7Qc
         i1s8qhCftK0ZYpq2KWAw9eP4ZDAFiGE0oucSh9kSIufiYWBrfzd4BBHHAoXljH5+6Sif
         lk2uD+bZefMXQzsBY23HKuEBQjHgohrRNIZ4puWupc+2CGKXkkfAamDVFAgCBFX44VqH
         ZXVw==
X-Gm-Message-State: AOAM530UlqmGSHiMwWnwyIvQmDsWf5EOd1uBymGF07p8FWw1ZFdXOWBM
        H4T/Z1/DsUjmxG1Om3HAB84jMAzFIHG78Oi9UFOU8MrMkIRfUiL51wXJ8CUZir4GC2Ao1I+jHXT
        mkFHPqhaHCDdU
X-Received: by 2002:a5d:4e83:0:b0:1ea:99dd:d335 with SMTP id e3-20020a5d4e83000000b001ea99ddd335mr13761153wru.16.1646761824303;
        Tue, 08 Mar 2022 09:50:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXaKH7qtJ3XhWUyVWnDr9kUvihmBN1ZTa2EX+LmoDkmO7GAo9fIS2kQhFvn2eyi1VE4qRY9w==
X-Received: by 2002:a5d:4e83:0:b0:1ea:99dd:d335 with SMTP id e3-20020a5d4e83000000b001ea99ddd335mr13761137wru.16.1646761824103;
        Tue, 08 Mar 2022 09:50:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g6-20020a5d5406000000b001f049726044sm14439971wrv.79.2022.03.08.09.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 09:50:23 -0800 (PST)
Message-ID: <f9e7903a-72b6-5bd7-4795-6c568b98f09d@redhat.com>
Date:   Tue, 8 Mar 2022 18:50:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 11/25] KVM: x86/mmu: remove
 kvm_calc_shadow_root_page_role_common
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-12-pbonzini@redhat.com> <YieW+PZarPdsSnO7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YieW+PZarPdsSnO7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 18:48, Sean Christopherson wrote:
> On Mon, Feb 21, 2022, Paolo Bonzini wrote:
>> kvm_calc_shadow_root_page_role_common is the same as
>> kvm_calc_cpu_mode except for the level, which is overwritten
>> afterwards in kvm_calc_shadow_mmu_root_page_role
>> and kvm_calc_shadow_npt_root_page_role.
>>
>> role.base.direct is already set correctly for the CPU mode,
>> and CR0.PG=1 is required for VMRUN so it will also be
>> correct for nested NPT.
> 
> Bzzzt, this is wrong, the nested NPT MMU is indirect but will be computed as direct.

CR0.PG=1 means it's *not* direct:

> +	role.base.direct = !____is_cr0_pg(regs);

Paolo

