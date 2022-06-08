Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A899B543631
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 17:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243177AbiFHPKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 11:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242796AbiFHPKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 11:10:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8672F47BCD2
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 08:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654700507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hImUqq81nsVWX35qLEtCQciHYWT/M6hkZvxAV6wtRbM=;
        b=WXcTL5pJ/8ueeALEx9rt8fox0tSYTmGRxYAWrxU17jkXq1Fkifj4HnJdNvPjX5IiTSE/AL
        gud8R81yqGdFYHKYV9ddwgYNF5cHcFilW4YiRFAxA2Vbc3S7YX+KyqfxGd/7i/UoFMQEUs
        l9gveeu7XTp6EtQPaVzygWltNlugoxQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-hy2To7pyMAmlmNP16oJARw-1; Wed, 08 Jun 2022 11:01:46 -0400
X-MC-Unique: hy2To7pyMAmlmNP16oJARw-1
Received: by mail-wm1-f71.google.com with SMTP id h189-20020a1c21c6000000b0039c65f0e4ccso106018wmh.2
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 08:01:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hImUqq81nsVWX35qLEtCQciHYWT/M6hkZvxAV6wtRbM=;
        b=CRGkb6a+X2uTmhqs5tMclyxnB3MBoejQVvUTIbwcG7rPNM0pkUZ9ixTdJpT2nzzTk7
         yD4CgxKXwXoipCLr4oOZ0iYr5yfejUjWajM3n9z1XDMar9R4jvLTHTmLLpC3gqHUVcR2
         GyDpwF5SToaT2QPmCqXwBJTBwgh4IBn+C0ppFSgUwZB2IC8AJNmBtb7zDiR53g2Q/1KJ
         j1DieknXccoLUbbml+i1M16AJCyvP2Eslf7aiJhtWFC3yukoRj9ghz0RJPue1Zea73QG
         vuViGUeSSAZH3bp6Jzn/SreBHEo4P6PUqJxsBMSiygzRYPuDiX7xCo6mAruqQUduVCDF
         I5Jw==
X-Gm-Message-State: AOAM530ddyftiNrf13bnTnPIT6zpYxeFG+ZcGBTw9XwNLw6sF48BdYkY
        NMZ4PiBln/z/Ek6SM2RqtO8TdIZRMZa02uv7LBaSnxCk3wOhxQc8HUXlb2BT2XtmmJANiRtY+Jw
        wW1gZoI5DJNaT
X-Received: by 2002:a05:600c:4f4d:b0:397:4d0f:f92f with SMTP id m13-20020a05600c4f4d00b003974d0ff92fmr64886199wmq.36.1654700504856;
        Wed, 08 Jun 2022 08:01:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4q2nur4K3c+AEjtKWjSJusQeIGhrSTGfOK3Lzr9yvq+XhTvBx8lF7Krf5+qJ5RmSQftW1iw==
X-Received: by 2002:a05:600c:4f4d:b0:397:4d0f:f92f with SMTP id m13-20020a05600c4f4d00b003974d0ff92fmr64886170wmq.36.1654700504626;
        Wed, 08 Jun 2022 08:01:44 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id m18-20020a05600c3b1200b00397122e63b6sm24717540wms.29.2022.06.08.08.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:01:44 -0700 (PDT)
Date:   Wed, 8 Jun 2022 17:01:42 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 045/144] KVM: selftests: Make vm_create() a wrapper
 that specifies VM_MODE_DEFAULT
Message-ID: <20220608150142.nnhiyp5svrrkenxv@gator>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-46-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603004331.1523888-46-seanjc@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 12:41:52AM +0000, Sean Christopherson wrote:
...
> +/*
> + * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
> + * loads the test binary into guest memory and creates an IRQ chip (x86 only).
> + */
> +struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
> +struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
> +
>  static inline struct kvm_vm *vm_create_barebones(void)
>  {
> -	return __vm_create(VM_MODE_DEFAULT, 0);
> +	return ____vm_create(VM_MODE_DEFAULT, 0);
> +}
> +

I don't [overly] mind the "____helperhelper" naming style, but in this
case wouldn't __vm_create_barebones() also be a reasonable name?

Thanks,
drew

