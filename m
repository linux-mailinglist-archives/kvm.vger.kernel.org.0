Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3E95814BE
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 16:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238982AbiGZOD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 10:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiGZOD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 10:03:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA2C813E39
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 07:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658844207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Aj2o5i8sRZPkvGpdj4offvNBsKrFczvaAT1u6fxUWrM=;
        b=Gfak/4zQQnqLlhLju7VJ5WgBUcublxWj4svfC1y51HmWsSFNMl3AUaI8rysQXdZwQrtJcG
        Gy7MsRspSEiN5NZ4c7dVCqqGkk7/g26OVnfO3bgKLLXL5FJPJfvNmSi2z8Qp0wGzvuMvA/
        UbvcrZ/LW/nue5KBsFH8uq8fldjv09s=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-7071VH8qNiKZzJ3e84dPXQ-1; Tue, 26 Jul 2022 10:03:23 -0400
X-MC-Unique: 7071VH8qNiKZzJ3e84dPXQ-1
Received: by mail-io1-f72.google.com with SMTP id h10-20020a5ecb4a000000b0067bcc5ff59bso5309485iok.18
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 07:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Aj2o5i8sRZPkvGpdj4offvNBsKrFczvaAT1u6fxUWrM=;
        b=J7HNNYoh4h9/nqGnxKCfKurs6SthDmZWWnC+le5bkte5bf91JgnZ5iyXxutQyq3ixp
         XJyjzyAao6+DVnIz3cUM2W0o5mlBcQv/Eas4L/j0AIUl1u4QWk5+5O7HJsdv3ahY7sN8
         pvsa1IBdIfxXHLOdrPGsEvNMgAL1ELkRfWO0iIXZMSuptnt3kXNugSojeyXsTKTEXxPO
         esQnGmdBcUL0w4grsgIJbtFLERNiwSr7z8E79M9N+Nm8qP7vSVcbIWsPtPa919SrTP7e
         7zEBmCfks6uk1MpoKa7lWJax7V5kLtaaCuUucSx1c5CI20d2Jw+ffsKbClko9E3jJ+Ts
         Wceg==
X-Gm-Message-State: AJIora+9G3ibswvAC8dAP4K94E7mk8I4pqkib6FM6HHyTV08AdGTlYsC
        oTSnmPVQeN7or2yFYk7YercDCRS2xEgsMzR1L72gzM4muYGMtMgiwaF4jo2qIRRi1KTDf+eF1CD
        otAQQiBT+xdJa
X-Received: by 2002:a02:c8c4:0:b0:341:6357:cffa with SMTP id q4-20020a02c8c4000000b003416357cffamr6915847jao.142.1658844202579;
        Tue, 26 Jul 2022 07:03:22 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tF+s1y/HCNVOMy/Gsz6h9KPQXaAbNw4kbHEoNH74VSWq79rzLT0aSgNfL+3hjKFkBweFzFLg==
X-Received: by 2002:a02:c8c4:0:b0:341:6357:cffa with SMTP id q4-20020a02c8c4000000b003416357cffamr6915827jao.142.1658844202308;
        Tue, 26 Jul 2022 07:03:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p12-20020a056638190c00b0033156d6016asm6761847jal.91.2022.07.26.07.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 07:03:22 -0700 (PDT)
Date:   Tue, 26 Jul 2022 08:03:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <20220726080320.798129d5.alex.williamson@redhat.com>
In-Reply-To: <eab568ea-f39e-5399-6af6-0518832dfc91@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
        <20220714081251.240584-4-yishaih@nvidia.com>
        <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
        <56bd06d3-944c-18da-86ed-ae14ce5940b7@nvidia.com>
        <BN9PR11MB5276BEDFBBD53A44C1525A118C959@BN9PR11MB5276.namprd11.prod.outlook.com>
        <eab568ea-f39e-5399-6af6-0518832dfc91@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jul 2022 11:37:50 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 25/07/2022 10:30, Tian, Kevin wrote:
> > <please use plain-text next time>
> >  
> >> From: Yishai Hadas <yishaih@nvidia.com>
> >> Sent: Thursday, July 21, 2022 7:06 PM  
> >>>> +/*
> >>>> + * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.  
> >>> both 'start'/'stop' are via VFIO_DEVICE_FEATURE_SET  
> >> Right, we have a note for that near VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP.
> >> Here it refers to the start option.  
> > let's make it accurate here.  
> 
> OK
> 
> >  
> >>>> + * page_size is an input that hints what tracking granularity the device
> >>>> + * should try to achieve. If the device cannot do the hinted page size then it
> >>>> + * should pick the next closest page size it supports. On output the device  
> >>> next closest 'smaller' page size?  
> >> Not only, it depends on the device capabilities/support and should be a driver choice.  
> > 'should pick next closest" is a guideline to the driver. If user requests
> > 8KB while the device supports 4KB and 16KB, which one is closest?
> >
> > It's probably safer to just say that it's a driver choice when the hinted page
> > size cannot be set?  
> 
> Yes, may rephrase in V3 accordingly.
> 
> >  
> >>>> +struct vfio_device_feature_dma_logging_control {
> >>>> +	__aligned_u64 page_size;
> >>>> +	__u32 num_ranges;
> >>>> +	__u32 __reserved;
> >>>> +	__aligned_u64 ranges;
> >>>> +};  
> >>> should we move the definition of LOG_MAX_RANGES to be here
> >>> so the user can know the max limits of tracked ranges?  
> >> This was raised as an option as part of this mail thread.
> >> However, for now it seems redundant as we may not expect user space to hit this limit and it mainly comes to protect kernel from memory exploding by a malicious user.  
> > No matter how realistic an user might hit an limitation, it doesn't
> > sound good to not expose it if existing.  
> 
> As Jason replied at some point here, we need to see a clear use case for 
> more than a few 10's of ranges before we complicate things.
> 
> For now we don't see one. If one does crop up someday it is easy to add 
> a new query, or some other behavior.
> 
> Alex,
> 
> Can you please comment here so that we can converge and be ready for V3 ?

I raised the same concern myself, the reason for having a limit is
clear, but focusing on a single use case and creating an arbitrary
"good enough" limit that isn't exposed to userspace makes this an
implementation detail that can subtly break userspace.  For instance,
what if userspace comes to expect the limit is 1000 and we decide to be
even more strict?  If only a few 10s of entries are used, why isn't 100
more than sufficient?  We change it, we break userspace.  OTOH, if we
simply make use of that reserved field to expose the limit, now we have
a contract with userspace and we can change our implementation because
that detail of the implementation is visible to userspace.  Thanks,

Alex

