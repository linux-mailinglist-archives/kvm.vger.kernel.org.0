Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00341542785
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 09:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiFHHGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 03:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354909AbiFHGTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 02:19:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED17DDEA
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 23:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654669171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2qdpgRzMUhsIWQD2m9gzx7YEZ9aS+BKgAe1jCPfxbsI=;
        b=Nrri5V29gAi0n0GV3m1fTE+oEzQP1i34JY5XNh8Ppx87T1vvRBNBuod/P6xVc6AIN4RYqn
        jR9gLdbsg3YjeBpT8OQatqDas0CbxhnAvsFKNeXI/QpD5QiA/unsq2JXhqFjfgqfVi9Hyt
        HXpD02CoSCc4B9bCJRmn/pJPX8naFQs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-245KEke-MxyRsluj3x-_fw-1; Wed, 08 Jun 2022 02:19:29 -0400
X-MC-Unique: 245KEke-MxyRsluj3x-_fw-1
Received: by mail-wr1-f72.google.com with SMTP id q14-20020a5d61ce000000b00210353e32b0so4399624wrv.12
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 23:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=2qdpgRzMUhsIWQD2m9gzx7YEZ9aS+BKgAe1jCPfxbsI=;
        b=0VfPbxicuNqK4g5WfHF8wdRPq1nmLO+J4SSn6AmfV5YOwvITnzHgfySFc+G6g95mtX
         lH95MqIMNaK21IaoGWNrK3nSaajzYRoy2lk9xQaepMdyVhmZfQq6LiKxPQHw/dnw0+CR
         nOhTEiJErOuIYaMQzdCblVYGe1g91w0Dqq6F9L8rVNuqXs6XH1DHMWCvUkdPQshTIJf6
         9TZRMIo981o2njqWu/iNxFRatNliFR87H5vUS9TiIWUtqsT73o4EZG8Q8e0LoAbV47Ff
         T2R46v4yc4GZPL9cvOuUxjmvDxfZuZc/1IV7EBsyWminsTzmWl40WCbQWWz/MHBhFmYc
         fM/Q==
X-Gm-Message-State: AOAM532UmR2Q415JQIsKkjq2BYAml5+ELf+h/xOKKyTe3AlCjUo9aTm0
        qcjR582aFXOGU1h81q98EQOTg9BefK7dgSQlA0p3GvNGx9Gu598Palire/ejBXWX8a/5QpHYvAz
        r5cjCYcnYJkXh
X-Received: by 2002:adf:d1c4:0:b0:210:1935:3dd8 with SMTP id b4-20020adfd1c4000000b0021019353dd8mr31593020wrd.229.1654669167905;
        Tue, 07 Jun 2022 23:19:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkaMUFdFQF32rETtSx3hpO9mEFM8hwy/9yxM+E2FB4DD6LrNRYSSbnwhOPIH9KVPr+yWRkng==
X-Received: by 2002:adf:d1c4:0:b0:210:1935:3dd8 with SMTP id b4-20020adfd1c4000000b0021019353dd8mr31592992wrd.229.1654669167726;
        Tue, 07 Jun 2022 23:19:27 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-42-114-66.web.vodafone.de. [109.42.114.66])
        by smtp.gmail.com with ESMTPSA id m125-20020a1ca383000000b0039c5b4ab1b0sm3545849wme.48.2022.06.07.23.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 23:19:27 -0700 (PDT)
Message-ID: <025699e6-b870-2648-d4a4-ffbc5fff22e8@redhat.com>
Date:   Wed, 8 Jun 2022 08:19:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
 <20220606203325.110625-11-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v9 10/21] vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM
In-Reply-To: <20220606203325.110625-11-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/2022 22.33, Matthew Rosato wrote:
> The current contents of vfio-pci-zdev are today only useful in a KVM
> environment; let's tie everything currently under vfio-pci-zdev to
> this Kconfig statement and require KVM in this case, reducing complexity
> (e.g. symbol lookups).
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   drivers/vfio/pci/Kconfig      | 11 +++++++++++
>   drivers/vfio/pci/Makefile     |  2 +-
>   include/linux/vfio_pci_core.h |  2 +-
>   3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 4da1914425e1..f9d0c908e738 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -44,6 +44,17 @@ config VFIO_PCI_IGD
>   	  To enable Intel IGD assignment through vfio-pci, say Y.
>   endif
>   
> +config VFIO_PCI_ZDEV_KVM
> +	bool "VFIO PCI extensions for s390x KVM passthrough"
> +	depends on S390 && KVM
> +	default y
> +	help
> +	  Support s390x-specific extensions to enable support for enhancements
> +	  to KVM passthrough capabilities, such as interpretive execution of
> +	  zPCI instructions.
> +
> +	  To enable s390x KVM vfio-pci extensions, say Y.

Is it still possible to disable CONFIG_VFIO_PCI_ZDEV_KVM ? Looking at the 
later patches (e.g. 20/21 where you call kvm_s390_pci_zpci_op() from 
kvm-s390.c), it rather seems to me that it currently cannot be disabled 
independently (as long as KVM is enabled).

So if you want to make this selectable by the user, I think you have to put 
some more #ifdefs in the following patches.
But if this was not meant to be selectable by the user, I think it should 
not get a help text and rather be selected by the KVM switch in 
arch/s390/kvm/Kconfig instead of having a "default y".

  Thomas

