Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEB14F84AF
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 18:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244986AbiDGQSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 12:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345702AbiDGQRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 12:17:41 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5205D0816
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 09:15:40 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e8-20020a17090a118800b001cb13402ea2so2251816pja.0
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 09:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pjmFekv8jDwjPEFoUA7K+aTQqc3Lv+ZZUAGbkfR0nhI=;
        b=REXPQfxvAcns+qRUBa9udhfUz0fCCn+7TO+QFD3ATUcXTx2Phkp/eVe23ASEjcWXQV
         QCWUG/TN5909B7ITNddW45R2t5Nn0L+HnPDKPIAE3TUvrTe5ALH9E9uCBu4wPVENnyH4
         I4+BTTaYUn07QJvrBv/XnCbWfOc3DDPUx5d4JMCCWsjCQ24YHLivS+aulwih+wIp+p9u
         3E6wGA6ouQzwZoH1JuHVWifo6VTDovIKz/hOCbFL2BjA2R0lADQVaflz5XofhNWQAGnt
         6a3OMKtKv8JeWvf8pr1wp8lAbHgf06ChlK+lTBHq3gYvaVUXkSr03+NcDP3LuuGPgkHp
         y0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pjmFekv8jDwjPEFoUA7K+aTQqc3Lv+ZZUAGbkfR0nhI=;
        b=tMTdcOMV5T7tvKSXs5/vEmNpwdKk5z49IpljwLoaUD09ZPSIMotPrG5ymPQRe2f6qP
         X55I2BFK/5FiCsw7MrI3J+RMXbfy0eyXQm8KcHYXDLCqHD9JjujolmoUEmoG/DQcNR8C
         sxneJrbGz+TZ9F5Iex1l5QH7zJ8EtffK/hmLewV7cGdUVu6XsvFnz3OZf/6110/RbIIz
         seBOhEtmmVgQfldEtoKY6oyz4s/byghNihpidbPkoEbJlW1BYa/vme8kZu1sdmhlwDnx
         4yW/wW/NmB4NbsN3CV6MwEo3w8ND4Fnr2cnr6rR3Is20KoSS1La66gMy50d4fah4x5k1
         3drw==
X-Gm-Message-State: AOAM532PeGLmOsU6YZc9GZneDgkBWi/mmQ+d8f9qWeaZfYOI0UmPlb3H
        FETS/RLfK9IDxYREfRP2kRxPzQ==
X-Google-Smtp-Source: ABdhPJyyrQ71dJva+gEqAi8WgQYtWeT60fGgpZLIS3NYZpUvh4J8u8RD/czp1XiotgUuR8s75Zz2zQ==
X-Received: by 2002:a17:902:d4c1:b0:153:d493:3f1 with SMTP id o1-20020a170902d4c100b00153d49303f1mr14704352plg.102.1649348139813;
        Thu, 07 Apr 2022 09:15:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h21-20020a056a001a5500b004fb71896e49sm22593891pfv.25.2022.04.07.09.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 09:15:39 -0700 (PDT)
Date:   Thu, 7 Apr 2022 16:15:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: hyper-v: Avoid writing to TSC page without an
 active vCPU
Message-ID: <Yk8OJ5Y1IKky9cnz@google.com>
References: <20220407154754.939923-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407154754.939923-1-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 676705ad1e23..3460bcd75bf2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -979,10 +979,10 @@ enum hv_tsc_page_status {
>  	HV_TSC_PAGE_GUEST_CHANGED,
>  	/* TSC page MSR was written by KVM userspace, update pending */
>  	HV_TSC_PAGE_HOST_CHANGED,
> +	/* TSC page needs to be updated due to internal KVM changes */
> +	HV_TSC_PAGE_KVM_CHANGED,

Why add KVM_CHANGED?  I don't see any reason to differentiate between userspace
and KVM, and using KVM_CHANGED for the kvm_vm_ioctl_set_clock() case is wrong as
that is very much a userspace initiated update, not a KVM update.

>  	/* TSC page was properly set up and is currently active  */
>  	HV_TSC_PAGE_SET,
> -	/* TSC page is currently being updated and therefore is inactive */
> -	HV_TSC_PAGE_UPDATING,
>  	/* TSC page was set up with an inaccessible GPA */
>  	HV_TSC_PAGE_BROKEN,
>  };
