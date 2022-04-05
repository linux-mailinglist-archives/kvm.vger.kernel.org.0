Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34CE4F4985
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441968AbiDEWS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456965AbiDEQCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 12:02:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF2F0FCBE1
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 08:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649172339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8TksMvZLxU5D3wLYdweZNWRXI8BerHHYyfmDHfh4uH8=;
        b=LJDi9TzNFgedT6ApbPSnY7PYlk32uSzfYfe2NW9ZNs/flh0dzFpJ3YUln0lI1LG3Hhec8k
        f8/8J9QFD7VyIyg5nur5YjIp7PHuqjdkoPKkt/q2/h11m1syTdOSZ+G17ErqdsSq7WmwCV
        WUxyk6ZUeNXL8URaWUOncK5lmWu+kMI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-2cjPaZAwO66HLWInfYT_qA-1; Tue, 05 Apr 2022 11:25:38 -0400
X-MC-Unique: 2cjPaZAwO66HLWInfYT_qA-1
Received: by mail-qv1-f70.google.com with SMTP id im8-20020a056214246800b00443d3d3956dso6540107qvb.22
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 08:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8TksMvZLxU5D3wLYdweZNWRXI8BerHHYyfmDHfh4uH8=;
        b=OAId2UNW9wHezEu3GAxW0QTvMgphW8FdUGEkK5kczCrp1Q7oRMIAe+s+AFcasGXRVM
         mNu7x8O7L+gvU+t2TbukeQEtclVnAg2fLMpFtk3yY1GxeNjRmEJ7JeK2IpFVq7cIqgTM
         yWjGttwJzlETbJX2GVsX3FQ16lJiV/IwLsNcg+Sp1Ellfu0WUkCmZLvPO6WZ4WAgyu+L
         XxMJoaifU7zdWLpB4AlyHptcyu9zwnsWkc1a2doFizP7g/Hqwaa36Qr0XlCGAcLm339M
         2PjCxYiArZcvKtYoJ3H81x13gHIUKhb3ZtBoNHgNyd1tacaSlsH5ttsiNGoNU8kufkzM
         VWrw==
X-Gm-Message-State: AOAM531cN+oKAAi28ZCHr6Tzvd+FDrRdSTcswc5xjACv8hJMb/olky79
        WpoWeyNTaN+5b4ghlAjWyg6PU90uT4hbPQVlUBFz9LPeBKPoSevwbuAM48ViWbpVM8L6WErfk+J
        mhoDVilBdh9ab
X-Received: by 2002:a05:620a:1a26:b0:680:ae30:4f3 with SMTP id bk38-20020a05620a1a2600b00680ae3004f3mr2659088qkb.372.1649172338112;
        Tue, 05 Apr 2022 08:25:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyk1CXI1DZ2crMHFuoHw3aJEAaOcePFY/oBq7yxA8t3U2kwtMvwTZgOQ0iyPnS08ku/SZl0Dw==
X-Received: by 2002:a05:620a:1a26:b0:680:ae30:4f3 with SMTP id bk38-20020a05620a1a2600b00680ae3004f3mr2659069qkb.372.1649172337808;
        Tue, 05 Apr 2022 08:25:37 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id 188-20020a3709c5000000b0067b147584c2sm8150698qkj.102.2022.04.05.08.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 08:25:37 -0700 (PDT)
Message-ID: <84d56339-4a8a-6ddb-17cb-12074588ba9c@redhat.com>
Date:   Tue, 5 Apr 2022 17:25:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 042/104] KVM: x86/mmu: Track shadow MMIO value/mask
 on a per-VM basis
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b494b94bf2d6a5d841cb76e63e255d4cff906d83.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b494b94bf2d6a5d841cb76e63e255d4cff906d83.1646422845.git.isaku.yamahata@intel.com>
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

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> +	if (enable_ept) {
> +		const u64 init_value = enable_tdx ? VMX_EPT_SUPPRESS_VE_BIT : 0ull;
>   		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> -				      cpu_has_vmx_ept_execute_only());
> +				      cpu_has_vmx_ept_execute_only(), init_value);
> +		kvm_mmu_set_spte_init_value(init_value);
> +	}

I think kvm-intel.ko should use VMX_EPT_SUPPRESS_VE_BIT unconditionally 
as the init value.  The bit is ignored anyway if the "EPT-violation #VE" 
execution control is 0.  Otherwise looks good, but I have a couple more 
crazy ideas:

1) there could even be a test mode where KVM enables the execution 
control, traps #VE in the exception bitmap, and shouts loudly if it gets 
a #VE.  That might avoid hard-to-find bugs due to forgetting about 
VMX_EPT_SUPPRESS_VE_BIT.

2) or even, perhaps the init_value for the TDP MMU could set bit 63 
_unconditionally_, because KVM always sets the NX bit on AMD hardware. 
That would remove the whole infrastructure to keep shadow_init_value, 
because it would be constant 0 in mmu.c and constant BIT(63) in tdp_mmu.c.

Sean, what do you think?

Paolo

