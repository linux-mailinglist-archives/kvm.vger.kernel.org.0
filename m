Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F23E5A800D
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 16:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiHaOYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 10:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiHaOYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 10:24:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C15C2290
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 07:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661955849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GjRO2qngV1MyjHgouxIsjq2zLGb0UGeLKd6G6vxUZKg=;
        b=fnTo13nl+zALPESVLtsBMtAnI33MG4i7Xd1ZZNTfEGqVCR7VxbD0Zzr5Yx94fRu746I4Ai
        W/4EUvnYRlbQWN4luu+jJcejA17UuT1gHNJJZwiiB4wvgQCuXuOu+MvC+EYTsENQ012Swu
        KPtE8pGy60Vv0NoDSS+HAuKIyIaYqL8=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-451-TbkrlRjzOaWLMlg9qc2Aig-1; Wed, 31 Aug 2022 10:24:08 -0400
X-MC-Unique: TbkrlRjzOaWLMlg9qc2Aig-1
Received: by mail-io1-f71.google.com with SMTP id z30-20020a05660217de00b00688bd42dc1dso8775327iox.15
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 07:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=GjRO2qngV1MyjHgouxIsjq2zLGb0UGeLKd6G6vxUZKg=;
        b=eMuOLh8btWEPonJDb4UJ/YcgWjCi1XlsWZ7efxEc3l4MBAV1bGPsxMGHGQ+NR5uyaF
         H5+8zs3GjNy4cGgeRo14yDlROqEnQn60AAmlnLEM7g/kSMgb6FhTMHBaK3aA8e5PCyhh
         +UNlx7hH9GpcqnFxeMi7ZtUhYTeCLrlk7z699IKAfrUSmwl0XMVV0gdmKIAXTFM7M7Jh
         7JWp5wN3VUCyNkqE5s38Xbn4ZNymoBkNRcOAEa+6TqxEJKnldMcBlU4JkwwSKFP6+4BK
         50b1hCP8yC/IBAZy3joKa9dQo1Xwul+L6ZRQDXyDCLDO0jfRcdFx/QGHGMLIC8XSDNRW
         N8nA==
X-Gm-Message-State: ACgBeo35ifTWf494meTpI/Flry7Za0E5vWrpJig0+PPEUng4a56k0kY5
        bsC00E7H+0RgfGjLyqrND8aBMwIhJlvIZnH15wKWVW1bbmlt7qdeb4nE4X9bE7wtK16fzBLk8hz
        L7og7nb69ytpc
X-Received: by 2002:a05:6e02:f43:b0:2ea:fbaa:fa71 with SMTP id y3-20020a056e020f4300b002eafbaafa71mr7788045ilj.180.1661955848090;
        Wed, 31 Aug 2022 07:24:08 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5DvNKpZfKWZiSe/UKPmvYB3hTDdb70FQj0W8IEn6Wg1/9MuOxGy9QKnu/HDHttYEpDJLFwTw==
X-Received: by 2002:a05:6e02:f43:b0:2ea:fbaa:fa71 with SMTP id y3-20020a056e020f4300b002eafbaafa71mr7788036ilj.180.1661955847909;
        Wed, 31 Aug 2022 07:24:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e13-20020a92a00d000000b002df2d6769b3sm6475704ili.45.2022.08.31.07.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 07:24:07 -0700 (PDT)
Date:   Wed, 31 Aug 2022 08:24:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        liulongfang <liulongfang@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for
 hssi_acc_drvdata()
Message-ID: <20220831082406.06f3d2c6.alex.williamson@redhat.com>
In-Reply-To: <f0eb49b8497940049b3e7aa227dd6c69@huawei.com>
References: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
        <20220831081216.0f8df490.alex.williamson@redhat.com>
        <f0eb49b8497940049b3e7aa227dd6c69@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Aug 2022 14:15:38 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: 31 August 2022 15:12
> > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> > Cc: kvm@vger.kernel.org; jgg@nvidia.com; kevin.tian@intel.com; liulongfang
> > <liulongfang@huawei.com>; Linuxarm <linuxarm@huawei.com>
> > Subject: Re: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for
> > hssi_acc_drvdata()
> > 
> > On Wed, 31 Aug 2022 09:59:43 +0100
> > Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> >   
> > > Commit 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the
> > > vfio_pci_core_device in drvdata") introduced a helper function to
> > > retrieve the drvdata but used "hssi" instead of "hisi" for the
> > > function prefix. Correct that and also while at it, moved the
> > > function a bit down so that it's close to other hisi_ prefixed
> > > functions.
> > >
> > > No functional changes.
> > >
> > > Fixes: 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the  
> > vfio_pci_core_device in drvdata")
> > 
> > The above two lines are usually mutually exclusive, the latter will
> > cause this change to be backported to all releases including that
> > commit.  As a largely aesthetic change, is that what you're looking
> > for?  Thanks,  
> 
> Nope. I don't think we need to backport this. Hope you can remove
> the "Fixes" tag while applying the patch.

Yep, I can drop it.  Thanks,

Alex
  
> > > Signed-off-by: Shameer Kolothum  
> > <shameerali.kolothum.thodi@huawei.com>  
> > > ---
> > >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 20 +++++++++----------
> > >  1 file changed, 10 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c  
> > b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c  
> > > index ea762e28c1cc..258cae0863ea 100644
> > > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > > @@ -337,14 +337,6 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
> > >  	return 0;
> > >  }
> > >
> > > -static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev  
> > *pdev)  
> > > -{
> > > -	struct vfio_pci_core_device *core_device =  
> > dev_get_drvdata(&pdev->dev);  
> > > -
> > > -	return container_of(core_device, struct hisi_acc_vf_core_device,
> > > -			    core_device);
> > > -}
> > > -
> > >  static void vf_qm_fun_reset(struct hisi_acc_vf_core_device  
> > *hisi_acc_vdev,  
> > >  			    struct hisi_qm *qm)
> > >  {
> > > @@ -552,6 +544,14 @@ static int vf_qm_state_save(struct  
> > hisi_acc_vf_core_device *hisi_acc_vdev,  
> > >  	return 0;
> > >  }
> > >
> > > +static struct hisi_acc_vf_core_device *hisi_acc_drvdata(struct pci_dev  
> > *pdev)  
> > > +{
> > > +	struct vfio_pci_core_device *core_device =  
> > dev_get_drvdata(&pdev->dev);  
> > > +
> > > +	return container_of(core_device, struct hisi_acc_vf_core_device,
> > > +			    core_device);
> > > +}
> > > +
> > >  /* Check the PF's RAS state and Function INT state */
> > >  static int
> > >  hisi_acc_check_int_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> > > @@ -970,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct  
> > vfio_device *vdev,  
> > >
> > >  static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
> > >  {
> > > -	struct hisi_acc_vf_core_device *hisi_acc_vdev =  
> > hssi_acc_drvdata(pdev);  
> > > +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
> > >
> > >  	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
> > >  				VFIO_MIGRATION_STOP_COPY)
> > > @@ -1301,7 +1301,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev  
> > *pdev, const struct pci_device  
> > >
> > >  static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
> > >  {
> > > -	struct hisi_acc_vf_core_device *hisi_acc_vdev =  
> > hssi_acc_drvdata(pdev);  
> > > +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
> > >
> > >  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
> > >  	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);  
> >   
> 

