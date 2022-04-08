Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878CE4F9299
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 12:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiDHKMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 06:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbiDHKMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 06:12:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D91A7A997B
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 03:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649412637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dDv/rk0p/ym3Otaap0CgRvB/aOstceiT80X2oN268IM=;
        b=IAoQCqkIzlu+4Hk7fyAfvYV5vd07ulJ6K3CdCRJllErxiRIKYejYIKptisVgshDP9ih2Rd
        NzGeYq+1PBlNzHphpti8OXkJ0M0iXKLzDoZg2PgZiwTVHqskJVRz+XIEsjQLpfh2Ii6vYK
        jbmsbdpM8fl3/ndnDq+5Ves0/4lH0w0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-VPq8DTyCPq-fCpG10LpbRg-1; Fri, 08 Apr 2022 06:10:36 -0400
X-MC-Unique: VPq8DTyCPq-fCpG10LpbRg-1
Received: by mail-wm1-f69.google.com with SMTP id 206-20020a1c02d7000000b0038eaa12aafcso256565wmc.7
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 03:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dDv/rk0p/ym3Otaap0CgRvB/aOstceiT80X2oN268IM=;
        b=qxxiU1NWBvp+RqlnSYTd3N8P+P8didL1G9mhCqwHr21sRapsG3TZL/Z8QMPX2Zap1D
         Winw7OctKMe+cCDh15QqDIsnpO96zn7kL22p/BRRAlUfp5eGEugTm82t9raGxItWTWgZ
         87vfxzAAsqEIHbknQfDqNVGSHbAtNNEKJXzFHqbsOX/+GIHHLLCcnM5a+sc5j/5Kmhfa
         tKXiH9e6Xi2+/5EcuCNe4oDRiM1Tmbd6ZYY/wCFxMfQr+PbxfiqAyZORsOmGQiG3yv02
         Aky58kPQN2vhIzxGfXv8rdb/3b4goPc30c/tbmA06JbnJGeU5uWJmgnZwCFF3iOsJHit
         IQMw==
X-Gm-Message-State: AOAM532zlBHcObjUqSp6EECNJta/lbdcivBcbZ6R0b+4Zr0aNGnz0gkn
        Ruyxlzb4ejBqnAO4xMmpu7I89wzW2QrN+wnb8B/sUpwULnp9SCPbIU8ALT+k4e+dZqleDaVs2FN
        ewPB77ka3TJDT
X-Received: by 2002:a5d:4712:0:b0:206:120d:b038 with SMTP id y18-20020a5d4712000000b00206120db038mr14696760wrq.542.1649412635422;
        Fri, 08 Apr 2022 03:10:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1beWVQuoGGl5w6Zz3Zazu8hP0ijuNjw/pQk7dZcuH0wdWMvMcyHhbw6FqT4wuqPomqK5XFw==
X-Received: by 2002:a5d:4712:0:b0:206:120d:b038 with SMTP id y18-20020a5d4712000000b00206120db038mr14696747wrq.542.1649412635207;
        Fri, 08 Apr 2022 03:10:35 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id n65-20020a1c2744000000b003862bfb509bsm9776282wmn.46.2022.04.08.03.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 03:10:34 -0700 (PDT)
Message-ID: <c31a5f84-6da2-c6a0-c0cd-9f6802c39fc3@redhat.com>
Date:   Fri, 8 Apr 2022 12:10:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: x86/mmu: remove unnecessary
 kvm_shadow_root_allocated() check
Content-Language: en-US
To:     luofei <luofei@unicloud.com>, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220407014016.1266469-1-luofei@unicloud.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220407014016.1266469-1-luofei@unicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/22 03:40, luofei wrote:
> When we reach here, the return value of kvm_shadow_root_allocated()
> has already been checked to false under kvm->slots_arch_lock.
> So remove the unnecessary recheck.

It's a little less clear t check !is_tdp_mmu_enabled().

That said, this is only done once, so perhaps it's better/easier to just 
remove the if completely.

Paolo


> Signed-off-by: luofei <luofei@unicloud.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8f19ea752704..1978ee527298 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3394,7 +3394,7 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
>   	 * Check if anything actually needs to be allocated, e.g. all metadata
>   	 * will be allocated upfront if TDP is disabled.
>   	 */
> -	if (kvm_memslots_have_rmaps(kvm) &&
> +	if (!is_tdp_mmu_enabled(kvm) &&
>   	    kvm_page_track_write_tracking_enabled(kvm))
>   		goto out_success;
>   

