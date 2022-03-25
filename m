Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF214E794E
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 17:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377001AbiCYQv6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 12:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348674AbiCYQv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 12:51:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C403C12C5
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 09:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648227021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tEjq/KiPSXWL3MlMEJXSJIy04cv7r0dUWkKt5cvZ2AM=;
        b=B4w52Bp7FXNmjPLIowiK1olqyQItg7cZ2l23/giA12cC5mCtNHQMaXxnAsuCFp+nU14yYG
        sqDuy85xBSx0hXyhvZJGnvp1CQQ40shPfjbVSqnjoDAvXN0eo5LrbKEzsgsWY101+TFy2Q
        V41ceroD05NZ3mnw4gh0hn4BnEpWTII=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-_R26_JZoOpm0BNohOIe7Nw-1; Fri, 25 Mar 2022 12:50:18 -0400
X-MC-Unique: _R26_JZoOpm0BNohOIe7Nw-1
Received: by mail-ed1-f69.google.com with SMTP id m21-20020a50d7d5000000b00418c7e4c2bbso5267449edj.6
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 09:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tEjq/KiPSXWL3MlMEJXSJIy04cv7r0dUWkKt5cvZ2AM=;
        b=KJRS6gASzxWfFfWJF42ImMX1OF6yLhCMt3TVP6dnqY7LYcfleK7FxO+ePWYm3/QNuF
         /BHlH5V9gLS2RJCzgn+jaR9Gj0UF3E/BZmyLmPFyDM6QlTR9ui7Ge/tBtKRHi8nKWFz3
         mzsHIiJ1ErDxDM6Hyg5NgLtBcsWgQC9MtVIeYrmcdYDBKCUZqbfEJTqJg1sEK9MBdwoM
         D3CZCUTSOwWWEP8BcVKK8RpEth7J8dhqgiTAqTdu6I3mow+m7JXvZUioTJG9VTEGCiPF
         DHdLmZgctxuraqbSI323CAQS139zFaS8YvtHEEnWvvO9UT/ifzr1Oax53t43v/5zgbXU
         ThDw==
X-Gm-Message-State: AOAM531tM6RTTvCKFFcvyxewRvx1tXx+qNbPe7SzvpPx6O4/mJVPkZVU
        X7lfQY7RKISc+Gxe50823Bd49lHw1N+RbR4XkWmHZWwRyxp/mLZaETIN4UF691q4HNJajuKiB5W
        MNR+mez5VnbkF
X-Received: by 2002:aa7:cc96:0:b0:410:b9ac:241 with SMTP id p22-20020aa7cc96000000b00410b9ac0241mr14368995edt.246.1648227017510;
        Fri, 25 Mar 2022 09:50:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtI7/PWnIA3ZNXxg4nfFvrZQa1n7rQsKtbxPki/ewcdN3qvWtTFHO7bqVxVhCh9We4XHqzJw==
X-Received: by 2002:aa7:cc96:0:b0:410:b9ac:241 with SMTP id p22-20020aa7cc96000000b00410b9ac0241mr14368975edt.246.1648227017312;
        Fri, 25 Mar 2022 09:50:17 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id hs12-20020a1709073e8c00b006dfd8074d27sm2501958ejc.79.2022.03.25.09.50.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 09:50:16 -0700 (PDT)
Message-ID: <53cc074f-350f-5fa8-1ee4-c33921f17cb1@redhat.com>
Date:   Fri, 25 Mar 2022 17:50:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH] KVM: x86/mmu: fix general protection fault in
 kvm_mmu_uninit_tdp_mmu
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+717ed82268812a643b28@syzkaller.appspotmail.com
References: <20220325163815.3514-1-paskripkin@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220325163815.3514-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/22 17:38, Pavel Skripkin wrote:
> Syzbot reported GPF in kvm_mmu_uninit_tdp_mmu(), which is caused by
> passing NULL pointer to flush_workqueue().
> 
> tdp_mmu_zap_wq is allocated via alloc_workqueue() which may fail. There
> is no error hanling and kvm_mmu_uninit_tdp_mmu() return value is simply
> ignored. Even all kvm_*_init_vm() functions are void, so the easiest
> solution is to check that tdp_mmu_zap_wq is valid pointer before passing
> it somewhere.

Thanks for the analysis, but not scheduling the work item in 
tdp_mmu_schedule_zap_root is broken; you can't just let the roots 
survive (KVM uses its own workqueue because it needs to work item to 
complete has to flush it before kvm_mmu_zap_all_fast returns).

I'll fix it properly by propagating the error up to kvm_mmu_init_vm and 
kvm_arch_init_vm,

Thanks,

Paolo

