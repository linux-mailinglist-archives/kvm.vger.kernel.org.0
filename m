Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072D451AD95
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350503AbiEDTQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377463AbiEDTP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:15:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E769488AD
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651691539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xDmu2VEbBUhEHNkxRESm0tt/LHwM6H1VfZRPNRo+6nI=;
        b=bZD153QLu4GW943f4e4QhkRpYbCOKEYeWOQk4Uz1XL6/Z70tdGYz/o+RLSW+jp//HNEhoN
        GfPOIgJ8u5CrBHoXNduFKhixg9sy70OuJ3zjBYVWO+3xJtZo2hEpY+LoexJzabHfsTMQna
        3WMdGRSDr7ixOpMI96TVYjxFu10yNxA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-0Cus4y5SNj2HAI_ZJuTBPg-1; Wed, 04 May 2022 15:12:18 -0400
X-MC-Unique: 0Cus4y5SNj2HAI_ZJuTBPg-1
Received: by mail-ed1-f71.google.com with SMTP id e3-20020a50a683000000b00427afcc840aso1263539edc.13
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 12:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xDmu2VEbBUhEHNkxRESm0tt/LHwM6H1VfZRPNRo+6nI=;
        b=2k0sgF3NrJ6j5rieHYG9NNaRyGG43xHyJNcpCE/gv4a6/Q59U9yjkeFkBpI4vUEM4X
         ZNZWWjDD3L4yfdfGF9xqHIAJgti3GeUBoxkUyHkO4r+seejU6fUpNbMPLvLgz8yu0ToR
         P3rt1F0Swp8fDvFWDV3QPtocsnnnqxkBj2Eu8JxzMcBKeTsoUMcQUb4C6ejN2kcwoLUw
         jntcns/Cx+5ASpig4/f7FuiGat7pd0uXilVyrvl+Tyut9uSF2GBW4TzT4iOvpGvXF9Qr
         bU34lQ+PGwQq0bmaQwYTvqdpYDkK9MFjon0QcELOh0mVDdZnWY3bzQcIDdXl8lsW8v9X
         lB3Q==
X-Gm-Message-State: AOAM533GOwDz18ynNdnWK795CcWpxibHzYh8mjifTasXhyEhNMLxcpCk
        vFWKb1rEaVREf2szlxQHf+jA7hngXM0mnTEOUcGV2T0ixnUlC2eZayak2He5knfokEcChVntHD8
        AX/dGO46Wb0qm
X-Received: by 2002:a17:906:6a1c:b0:6f4:b0e0:2827 with SMTP id qw28-20020a1709066a1c00b006f4b0e02827mr5515159ejc.249.1651691537188;
        Wed, 04 May 2022 12:12:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhnpEzLDxtlrhT1+lHv71xBxdKhZqRRQvwTtgteUIXhiyiwklv5dzaLmhmBQf0Y/Mi81f3iw==
X-Received: by 2002:a17:906:6a1c:b0:6f4:b0e0:2827 with SMTP id qw28-20020a1709066a1c00b006f4b0e02827mr5515143ejc.249.1651691536949;
        Wed, 04 May 2022 12:12:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ml11-20020a170906cc0b00b006f3ef214e59sm6065311ejb.191.2022.05.04.12.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 12:12:16 -0700 (PDT)
Message-ID: <e17f9866-dfd0-da08-6128-852f7346b8a1@redhat.com>
Date:   Wed, 4 May 2022 21:12:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: VMX: Fix build error on claim of
 vmx_get_pid_table_order()
Content-Language: en-US
To:     Zeng Guang <guang.zeng@intel.com>, kvm@vger.kernel.org
Cc:     Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Chen Farrah <farrah.chen@intel.com>,
        Wei Danmei <danmei.wei@intel.com>
References: <20220504032102.15062-1-guang.zeng@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220504032102.15062-1-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/22 05:21, Zeng Guang wrote:
> Change function claim to static.
> Report warning: no previous prototype for 'vmx_get_pid_table_order'
> [-Wmissing-prototypes].
> 
> Fixes: 101c99f6506d ("KVM: VMX: enable IPI virtualization")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
> Paolo, could you please merge this fix into commit 101c99f6506d ("KVM:
> VMX: enable IPI virtualization") in kvm/queue? Sorry for such mistake.
> 
>   arch/x86/kvm/vmx/vmx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bb09fc9a7e55..2065babb2c9c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4402,7 +4402,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>   	return exec_control;
>   }
>   
> -int vmx_get_pid_table_order(struct kvm *kvm)
> +static int vmx_get_pid_table_order(struct kvm *kvm)
>   {
>   	return get_order(kvm->arch.max_vcpu_ids * sizeof(*to_kvm_vmx(kvm)->pid_table));
>   }

Yup, done.

Paolo

