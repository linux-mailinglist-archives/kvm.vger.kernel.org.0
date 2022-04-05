Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4485C4F43A8
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 00:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiDEOt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382112AbiDEORO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 10:17:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD7BE160C0D
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 06:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649163688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c1Lv+i1PBgFa+gfs5DRpbJ6m0eCPENa4LFWCMUe7Pgk=;
        b=hmIiDp6eQmWRUFa4HQBfZXDWhSWFU+Iy3MmCx/DSvI+qdCebXpmEjcslsIzED0X6f6kj81
        owGOqTpjcZv37Nx1n5T1XVbsyIRmRWx4G3i2qSWzIMrFi9NG1HuwJ9mnC/awyeEhk8+YyZ
        NpgWqeuYnhPnpwvmteZVYjsk0NxaHU4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-TlFKFqeYNdWonB8atvAgng-1; Tue, 05 Apr 2022 09:01:12 -0400
X-MC-Unique: TlFKFqeYNdWonB8atvAgng-1
Received: by mail-wm1-f71.google.com with SMTP id l7-20020a05600c1d0700b0038c9c48f1e7so1319511wms.2
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 06:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c1Lv+i1PBgFa+gfs5DRpbJ6m0eCPENa4LFWCMUe7Pgk=;
        b=yn8mMgfFyauSkJJWD/uZbn1pvvofDd5Ly+511DGVXCYnChtj1rW07sVvjtZMe8gAlU
         PzlcKkRFvaWyP7RdDgY0bszXCk7yQ6lAH3yAr2cLiGPupAa+Mo9fuBmhv2MtSGvQerrV
         hRSbSiWS6qJg7vNhWw9CaBaw9abChhbyH39zA0bG2+cqqymiU6weyBt4magr9/qpQHNu
         7uzZR78E9hUMx+Nm0Xg/TiPbkPc/wWC/k8fcMCIofddVzENSRg042GB/R6/6wk17cJUr
         4tj2TiL0srRUNeY2kW09gJXo6OiM984f0N/EvZTsA2BFL7Mn4QkVNgEOe+N7nkcGAw2R
         JHiQ==
X-Gm-Message-State: AOAM532Jq4f8KAABAw4/7uhk9Nz2SG81Xcng3H7Jbm/khh98AQ4lCafH
        WtaL1NsCL1JzgTjrR5TVUx3slJ4M9Y4z+MTOWpoQouWm2nrsvtrVXKdRxZcMVIeSqKdF8KQvpdf
        VRGpZ6+Uo0reB
X-Received: by 2002:adf:ba8f:0:b0:1e9:4afb:179b with SMTP id p15-20020adfba8f000000b001e94afb179bmr2726492wrg.57.1649163671583;
        Tue, 05 Apr 2022 06:01:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNzI5PD1sS5Vh0+bMeeZnomXZHkWuWTcu1XLTQ/uRuaUVRxMlYuIfdB8IaN0F1ErzpxtndZQ==
X-Received: by 2002:adf:ba8f:0:b0:1e9:4afb:179b with SMTP id p15-20020adfba8f000000b001e94afb179bmr2726472wrg.57.1649163671377;
        Tue, 05 Apr 2022 06:01:11 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id n2-20020adfb742000000b00205eda3b3c1sm12716780wre.34.2022.04.05.06.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 06:01:10 -0700 (PDT)
Message-ID: <6e370d39-fcb6-c158-e5fb-690cd3802150@redhat.com>
Date:   Tue, 5 Apr 2022 15:01:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 027/104] KVM: TDX: initialize VM with TDX specific
 parameters
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
 <509fb6fb5c581e6bf14149dff17d7426a6b061f2.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <509fb6fb5c581e6bf14149dff17d7426a6b061f2.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/31/22 06:55, Kai Huang wrote:
>>   
>> +struct kvm_tdx_init_vm {
>> +	__u32 max_vcpus;
>> +	__u32 tsc_khz;
>> +	__u64 attributes;
>> +	__u64 cpuid;
> Is it better to append all CPUIDs directly into this structure, perhaps at end
> of this structure, to make it more consistent with TD_PARAMS?
> 
> Also, I think somewhere in commit message or comments we should explain why
> CPUIDs are passed here (why existing KVM_SET_CUPID2 is not sufficient).
> 

Indeed, it would be easier to use the existing cpuid data in struct 
kvm_vcpu, because right now there is no way to ensure that they are 
consistent.

Why is KVM_SET_CPUID2 not enough?  Are there any modifications done by 
KVM that affect the measurement?

Thanks,

Paolo

