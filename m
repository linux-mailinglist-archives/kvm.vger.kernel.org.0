Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC6F69F63C
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 15:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjBVOQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 09:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBVOQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 09:16:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F284237737
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 06:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677075314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sQsLqX1OjjYuAZxQpRIQQNFoZetiCPqyoN+kLuymI3Q=;
        b=CET4dmHnHPKHCTHz+RzNnYh4CwNXgI6accc2rcatKROGpo/iHBbqRKET2P/EF2A84f3hLo
        JmWRsRF8y8JlDqq4/CVQQiMDXMccCqvjimTaqssjC9H5g+UAF8/Cr2G9YfoxT1AJWnWoEK
        CJIELOtix2cOlRucYX6svp0IrUC3Oxo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-382-vJZ1RiOyMle5S1VVNIG8Mg-1; Wed, 22 Feb 2023 09:15:12 -0500
X-MC-Unique: vJZ1RiOyMle5S1VVNIG8Mg-1
Received: by mail-wr1-f71.google.com with SMTP id m15-20020adfa3cf000000b002be0eb97f4fso1577859wrb.8
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 06:15:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sQsLqX1OjjYuAZxQpRIQQNFoZetiCPqyoN+kLuymI3Q=;
        b=cmX+mLYYrFisi1DIaqyHW8ugtwTDC1RJ0F+bRvIemA84CnBrPFQWI9HBHkf9yDqnjr
         WOqG1XJL1Ew9ZXzHoFNs2Wyw2/CZSTTT/oAwJIJtZ7iDvAT7plifbawt7AFYk0d2FIgi
         mfVsTpxsM5cmUf0arOAL7nDHaV0UPHchFLskDm32uNZP0s6nG7x8e5CVvBH6Su5EZVj7
         S4iozcEJ0HO3x2qr7Be/HEzNiLq8naI8vQfCmMV9dha231JTTPPx4lObjoGbOYOnVw8j
         KBdYoOs3Cv9WsjfajTL1TlOsLFooGrL2MsdfB/uNeX9TWq3MsKZqV6ZWwRSx1u1milYL
         kKeg==
X-Gm-Message-State: AO0yUKXx8YVLNQzWAur6Q+d3EAwjcDtQD8ftQGt4Zd7b6h1LKQTO9NW+
        pGKHdL7Fo0M455S89noSiHOEUJXhrbxhSISv1R5+6iHNYKm7Hzsu8D6wBzB1x2LNgRYQ8zIm+un
        4AUE5wiWJrTFof03j3hEDYmmm39YHgEeNm1UzcCG9lpxkg8KRFg5qry83UeDIu04G5aFFew==
X-Received: by 2002:a1c:6a12:0:b0:3dd:1c46:b92 with SMTP id f18-20020a1c6a12000000b003dd1c460b92mr7372587wmc.16.1677075311495;
        Wed, 22 Feb 2023 06:15:11 -0800 (PST)
X-Google-Smtp-Source: AK7set/S3zSWR7FXEvK09uraAeYBi21Ba0z7ojWTKmJJzanv6OVLXKGEETksizHsfOLf29IRFrXFiA==
X-Received: by 2002:a1c:6a12:0:b0:3dd:1c46:b92 with SMTP id f18-20020a1c6a12000000b003dd1c460b92mr7372563wmc.16.1677075311148;
        Wed, 22 Feb 2023 06:15:11 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ja14-20020a05600c556e00b003dfefe115b9sm5509683wmb.0.2023.02.22.06.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:15:09 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: hyper-v: placate modpost section mismatch error
In-Reply-To: <20230222073315.9081-1-rdunlap@infradead.org>
References: <20230222073315.9081-1-rdunlap@infradead.org>
Date:   Wed, 22 Feb 2023 15:15:08 +0100
Message-ID: <87k0094wib.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> modpost reports section mismatch errors/warnings:
> WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
> WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
> WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
>
> Marking svm_hv_hardware_setup() as __init fixes the warnings.
>
> I don't know why this should be needed -- it seems like a compiler
> problem to me since the calling function is marked as __init.
>
> This "(unknown) (section: .init.data)" all refer to svm_x86_ops.
>
> Fixes: 1e0c7d40758b ("KVM: SVM: hyper-v: Remote TLB flush for SVM")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Vineeth Pillai <viremana@linux.microsoft.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> ---
>  arch/x86/kvm/svm/svm_onhyperv.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -- a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -30,7 +30,7 @@ static inline void svm_hv_init_vmcb(stru
>  		hve->hv_enlightenments_control.msr_bitmap = 1;
>  }
>  
> -static inline void svm_hv_hardware_setup(void)
> +static inline __init void svm_hv_hardware_setup(void)
>  {
>  	if (npt_enabled &&
>  	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
>

There's a second empty svm_hv_hardware_setup() implementation 50 lines
below in the same file for !if IS_ENABLED(CONFIG_HYPERV) case and I
think it needs to be marked as '__init' as well.

-- 
Vitaly

