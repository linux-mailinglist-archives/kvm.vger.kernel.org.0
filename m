Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2E34F4978
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389655AbiDEWRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443400AbiDEPje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:39:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A970514A918
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 06:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649166955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uG51r3M7RVYcRnm/2VnqTxDFbU3yILDGOcg7NHA/EVE=;
        b=e/YGorh2IYiFLs9e2S00OuyesqmRlxgu/wqwl3fpYH7BkRIk20dElNpYaajpEYTwFWMIef
        FfV8MWxiuSjBw4qVbQBbsvP1HkdDICV02fQ15Ti+l/dgufA+VLIv687D9NIXi36FjyaVUh
        UZdznKrUU0W2l8Pp80C/c7XuJMmOxTI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-2SB8ZCU5NuKMoGGNosVTyw-1; Tue, 05 Apr 2022 09:55:53 -0400
X-MC-Unique: 2SB8ZCU5NuKMoGGNosVTyw-1
Received: by mail-wr1-f69.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so2481499wrg.19
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 06:55:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uG51r3M7RVYcRnm/2VnqTxDFbU3yILDGOcg7NHA/EVE=;
        b=4xNtBEyxGzn+oO/jcC5fr9rJjyx6e1DeHPO4tVnDFp+ynGr/5seFpZ9D1rz/ocThU9
         nr3dDYaugS/PnHP+zAnG1ac8NMxL15Z9FPI1fJYc3Uo2o+wOhSWTE/RYfA+p6VxYDYHK
         u/Re0qjs2bAjMLr/CdqX3rQyalh+tHqQ7ca/0By1cVGWS2ISS26E+npEG86stjmiJiZj
         UP0SYekrH6Wd537vmZHQJTaBblEg86gJi68Yh2zOE+KVrG/lApnD4b3ByohFaYuDaExX
         jbrte1iZpdXjVTw/59cSi9hu+AbQjy1iCPUjjLKURz5kHhwVl3DyadK/mXFPjFu1J2gp
         NiYw==
X-Gm-Message-State: AOAM530SiEvdHMz6IgJXliMT2l2bNNb362DV6AYyWANmOMgEGh1u5tae
        Jwaqxaxv+hfgrOwuZL5/m8NSOJVCDn3iqksAztdMfpnmovKSA6sRjj5l3xJZlPTDAshuWEF+xlp
        Gu2AjNPPs94ua
X-Received: by 2002:adf:eb48:0:b0:203:f854:86cc with SMTP id u8-20020adfeb48000000b00203f85486ccmr2856457wrn.102.1649166952736;
        Tue, 05 Apr 2022 06:55:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1H0yzLskUVTxPjwU09zZhTiaOqOeF2BztP3MND60K5tnpoktPv1L4umG1BOl0AD8Dea3Z6Q==
X-Received: by 2002:adf:eb48:0:b0:203:f854:86cc with SMTP id u8-20020adfeb48000000b00203f85486ccmr2856433wrn.102.1649166952490;
        Tue, 05 Apr 2022 06:55:52 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id f8-20020a5d50c8000000b002061622ec88sm4441715wrt.105.2022.04.05.06.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 06:55:51 -0700 (PDT)
Message-ID: <5443b630-d2c8-b0c3-14f5-2b6b3f71221c@redhat.com>
Date:   Tue, 5 Apr 2022 15:55:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 033/104] KVM: x86: Add infrastructure for stolen
 GPA bits
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <a21c1f9065cf27db54820b2b504db4e507835584.1646422845.git.isaku.yamahata@intel.com>
 <2b8038c17b85658a054191b362840240bd66e46b.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <2b8038c17b85658a054191b362840240bd66e46b.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/31/22 13:16, Kai Huang wrote:
>> +	if (range && kvm_available_flush_tlb_with_range()) {
>> +		/* Callback should flush both private GFN and shared GFN. */
>> +		range->start_gfn = kvm_gfn_unalias(kvm, range->start_gfn);
> This seems wrong.  It seems the intention of this function is to flush TLB for
> all aliases for a given GFN range.  Here it seems you are unconditionally change
> to range to always exclude the stolen bits.

He passes the "low" range with bits cleared, and expects the callback to 
take care of both.  That seems okay (apart from the incorrect 
fallthrough that you pointed out).

>>
>>  
>> -		gfn = gpte_to_gfn(gpte);
>> +		gfn = gpte_to_gfn(vcpu, gpte);
>>  		pte_access = sp->role.access;
>>  		pte_access &= FNAME(gpte_access)(gpte);
>>  		FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
> 
> In commit message you mentioned "Don't support stolen bits for shadow EPT" (you
> actually mean shadow MMU I suppose), yet there's bunch of code change to shadow
> MMU.

It's a bit ugly, but it's uglier to keep two versions of gpte_to_gfn.

Perhaps the commit message can be rephrased to "Stolen bits are not 
supported in the shadow MMU; they will be used only for TDX which uses 
the TDP MMU exclusively as it does not support nested virtualization. 
Therefore, the gfn_shared_mask will always be zero in that case".

Paolo

