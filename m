Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA575F7E55
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 21:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJGTxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 15:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJGTxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 15:53:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC65118767
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 12:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665172393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXS92aHvjHBlZ1bWSPCrXkOkM+Bf2FuZKlkc5QTB6SA=;
        b=goA+Y+1xmczpRzmv3vPBhWZPI9NSVCIMPESpMM3T0HIe9NHQk/Blq92v3buwQ8Gn4u2KQy
        fo9NaQ14rKl2KCO2NOm28g16aDXM3kGCAq3eyvMX569KRLsNDJejsevqYLwDcARsJxPM7I
        UNd44GRjI/iLZpcwO1lNZHocd8BCctc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-599-aBge-dozP4Kp0x8xclCJcw-1; Fri, 07 Oct 2022 15:53:08 -0400
X-MC-Unique: aBge-dozP4Kp0x8xclCJcw-1
Received: by mail-il1-f199.google.com with SMTP id i3-20020a056e020d8300b002f90e6fedcfso4540877ilj.12
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 12:53:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rXS92aHvjHBlZ1bWSPCrXkOkM+Bf2FuZKlkc5QTB6SA=;
        b=F+Paq9UfP18NAhC5q+MQlGaCoXcai24v0x0heox6vpIOtJpkwcfiFCzDe6thsfEbao
         EKhCjdMJGaf5otL2TAxUJEYQ430GPdxbadqh9rxvUuFrK8vqr69udfuimYFVuI+yzWEe
         Nmye5YCpbEQA6SKLeqKaTl9OvX/k7T9llV4c/qD02NPgNzcrf95BwgMo3DDQfzJqOVR7
         pcnor1WVENHjozkaT+brlbovCS42Z7B8WS+4QZ+8mc97lYKrGNapxtS+EybA2ct2T1XA
         rHRsfHsgkjYSZB4Y1t2TbUPuttiHC6LdjG2lNCIdM1EXREbw7aSf7/kPtDZquMOSEOTA
         uYiA==
X-Gm-Message-State: ACrzQf2BMfTk1KFjVCuevhLCm+NU5XMYjoAb58R47PjIoatLuliumaev
        aVZxTcPsL6ARTBa8fZWuN5rju/LSzPf63aNgO9Rm2u6umgpcOh4ANDLLhsv5852ecj1Io9EuaBm
        w/bRpk3yOkzea
X-Received: by 2002:a05:6638:1455:b0:363:4dc8:96b1 with SMTP id l21-20020a056638145500b003634dc896b1mr3464992jad.52.1665172388211;
        Fri, 07 Oct 2022 12:53:08 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM756Hm3CJKOPhNUt2Twl4IMB/7Xl3TEqIkdQoTNm96ujWHrtavBGo55EkH5TFXOASMBzz8gbw==
X-Received: by 2002:a05:6638:1455:b0:363:4dc8:96b1 with SMTP id l21-20020a056638145500b003634dc896b1mr3464983jad.52.1665172387982;
        Fri, 07 Oct 2022 12:53:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r23-20020a02b117000000b00362c9a4a3a9sm1172812jah.113.2022.10.07.12.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 12:53:07 -0700 (PDT)
Date:   Fri, 7 Oct 2022 13:53:05 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 0/3] Allow the group FD to remain open when
 unplugging a device
Message-ID: <20221007135305.437daafb.alex.williamson@redhat.com>
In-Reply-To: <0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
References: <0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Oct 2022 11:04:38 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Testing has shown that virtnodedevd will leave the group FD open for long
> periods, even after all the cdevs have been destroyed. This blocks
> destruction of the VFIO device and is undesirable.
> 
> That approach was selected to accomodate SPAPR which has an broken
> lifecyle model for the iommu_group. However, we can accomodate SPAPR by
> realizing that it doesn't use the iommu core at all, so rules about
> iommu_group lifetime do not apply to it.
> 
> Giving the KVM code its own kref on the iommu_group allows the VFIO core
> code to release its iommu_group reference earlier and we can remove the
> sleep that only existed for SPAPR.
> 
> v2:
>  - Use vfio_file_is_group() istead of open coding
>  - Do not delete vfio_group_detach_container() from
>    vfio_group_fops_release()
> v1: https://lore.kernel.org/r/0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com
> 
> Jason Gunthorpe (3):
>   vfio: Add vfio_file_is_group()
>   vfio: Hold a reference to the iommu_group in kvm for SPAPR
>   vfio: Make the group FD disassociate from the iommu_group
> 
>  drivers/vfio/pci/vfio_pci_core.c |  2 +-
>  drivers/vfio/vfio.h              |  1 -
>  drivers/vfio/vfio_main.c         | 85 +++++++++++++++++++++++---------
>  include/linux/vfio.h             |  1 +
>  virt/kvm/vfio.c                  | 45 ++++++++++++-----
>  5 files changed, 95 insertions(+), 39 deletions(-)

Applied to vfio next branch for v6.1, along with my trivial follow-up.
Thanks for the group effort on this one!

Alex

