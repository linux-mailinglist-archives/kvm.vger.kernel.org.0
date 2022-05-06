Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0AE51E0BE
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 23:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444276AbiEFVML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiEFVMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:12:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8EE26EC79
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 14:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651871305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3vpsy1Bw2G0Z9czumFHK+em0TnSkriS3/ldF2FpDKXw=;
        b=hQ9H/bP8GyORT8kRfTNMhMfCIK0INl/1ZWTuKnREnQOBQZiG7DzHzPA5M+I685ksUrK90Z
        fj0AtfRoULjogKDwRgX2ut1Xicn/CTaJXMHM6mLdSkEQ58vkyzR72A71uH7Kl/dM+ALNjF
        m3X7sOrOtzEGAsgg5DBpTG6575FWxBE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-Zv6n8VcWNui5bhx68uCQNA-1; Fri, 06 May 2022 17:08:24 -0400
X-MC-Unique: Zv6n8VcWNui5bhx68uCQNA-1
Received: by mail-io1-f70.google.com with SMTP id b1-20020a05660214c100b006572ddc92f7so5726511iow.2
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 14:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3vpsy1Bw2G0Z9czumFHK+em0TnSkriS3/ldF2FpDKXw=;
        b=VBcSUoa4GGDS+8rrr+mzRpqgrdE4JVSHYW37VU7Me3T+3QntV9n/zt6GYHo5T3MYjf
         a6sVAL7j+vO6tbcsOWsvH6X9HonOBwnEbehFLg0kw5OpvFdz+uSRnCdEiLIpeUsumz0a
         /beEH/hoTEdbadOOiDhPidHah6z1+KKN6QQ88+nnb8YuqbLaVlyFzETt4Wns8jLF5Kab
         /Tm+4595ahEH/NRAzVMQGsK6TOpOe3D47hwGjmrJQm439mX1MkKFZ19R8FpYJJUuL39W
         SvYXfDTdXmwr0PGGpSShqX4eq3BF5pvMCuuzprrrmRCOc6n6Lzu0w9q+XtN5c4oWM6M6
         C5kg==
X-Gm-Message-State: AOAM5302NbxrJi6yOl16GcVBiit1Jc8uwVVUhQ01xNty6yM3AUoU5+VV
        XlnHfsMRjHygUqwt/EwTkkHyf8Gqi1khhryvdR/WKPb1EGKShm7l+5YrMn7r5FEz8mDb3Tg3gw3
        OL9S2vN5jFoUc
X-Received: by 2002:a92:cda8:0:b0:2cf:3e10:a9f5 with SMTP id g8-20020a92cda8000000b002cf3e10a9f5mr2098188ild.82.1651871303963;
        Fri, 06 May 2022 14:08:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6kB96mNdBAFRMB/1o0gyjqGnvitANqV7XnD0CVHHoGSyJo0cCnWJnYVkLWzhcEcQB5LX93g==
X-Received: by 2002:a92:cda8:0:b0:2cf:3e10:a9f5 with SMTP id g8-20020a92cda8000000b002cf3e10a9f5mr2098181ild.82.1651871303706;
        Fri, 06 May 2022 14:08:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m36-20020a026a64000000b0032b5b40c82dsm1577600jaf.65.2022.05.06.14.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 14:08:22 -0700 (PDT)
Date:   Fri, 6 May 2022 15:08:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: Re: [PATCH v3 2/2] vfio/pci: Remove vfio_device_get_from_dev()
Message-ID: <20220506150821.696a21c3.alex.williamson@redhat.com>
In-Reply-To: <ab4dcdd6-cc30-f9a9-5e6e-6f040b21e5b2@nvidia.com>
References: <2-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
        <ab4dcdd6-cc30-f9a9-5e6e-6f040b21e5b2@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 May 2022 01:50:45 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 5/5/2022 12:31 AM, Jason Gunthorpe wrote:
> > The last user of this function is in PCI callbacks that want to convert
> > their struct pci_dev to a vfio_device. Instead of searching use the
> > vfio_device available trivially through the drvdata.
> > 
> > When a callback in the device_driver is called, the caller must hold the
> > device_lock() on dev. The purpose of the device_lock is to prevent
> > remove() from being called (see __device_release_driver), and allow the
> > driver to safely interact with its drvdata without races.
> > 
> > The PCI core correctly follows this and holds the device_lock() when
> > calling error_detected (see report_error_detected) and
> > sriov_configure (see sriov_numvfs_store).
> > 
> > Further, since the drvdata holds a positive refcount on the vfio_device
> > any access of the drvdata, under the device_lock(), from a driver callback
> > needs no further protection or refcounting.
> > 
> > Thus the remark in the vfio_device_get_from_dev() comment does not apply
> > here, VFIO PCI drivers all call vfio_unregister_group_dev() from their
> > remove callbacks under the device_lock() and cannot race with the
> > remaining callers.
> > 
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> > Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>  
> 
> My ack was on previous version where drvdata is set and used in same module.
>   https://www.spinics.net/lists/kvm/msg275737.html
> 
> Its not a good practice to force vfio_pci_core vendor drivers to set a 
> particular structure pointer in drvdata. drvdata set from a driver 
> should be used by same driver and other driver should not assume/rely on it.
> 
> I still prefer earlier version.

Kirti,

Do you still have an objection to your previous ack being carried
forward?  Thanks,

Alex

