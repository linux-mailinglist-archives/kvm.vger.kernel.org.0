Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BE15A7FA2
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 16:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiHaOMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 10:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHaOMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 10:12:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8807DC58C6
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 07:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661955140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zWs4mDYEe/bQczSiotWCV3jvs7xD1NYYuqh2QJd2AZY=;
        b=VUb3zYLL5f5jWsZ8sVLIkBXG4BiSp7JWyc2uYhXEr0+jasMwZJIQn02h9DQKBcdIPcB7/F
        8Z8OUanqS0hqNSIPmvw9VYXVH8XQGL6D0Yd0yVTIBiduWsdiKCjwqQvlD3rjE3FdBeQ3DQ
        iqoJpiwCbl8pH18BFtvkPbhKpvC8/ug=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-206-t1kqGFqwMwqI20jcYOMMxg-1; Wed, 31 Aug 2022 10:12:19 -0400
X-MC-Unique: t1kqGFqwMwqI20jcYOMMxg-1
Received: by mail-il1-f197.google.com with SMTP id e2-20020a056e020b2200b002e1a5b67e29so10664377ilu.11
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 07:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=zWs4mDYEe/bQczSiotWCV3jvs7xD1NYYuqh2QJd2AZY=;
        b=Tl/3Ivq8SMiSZaqzRr4qfXx2TqmvW/wcwi0UXRA8+lkO32JarQzTtRYjuQhQAO3S1L
         KxKQh7BENq3MMElvQbXyGLasqL/AGI5b1tsJRTDj85bXA+DdECCk31/B9F4aqals/WPJ
         vYFQzpM/Mph4VnSKH2t57+GgXp4U7wCih3ZJShWJ91ApFuqbBzyQTfGNhFjUXuggD64g
         LSSHkOOYUybe3fmC0Is2dojvKXFsDrT8Mx9/EJgPvvv8s30jO/qnBd5a5XiNnU7rc6gF
         PKxlZRPj6NT0fS3pDNiMg7sApFTaqAEvl4DSZBqVh7zcLZhq2G+nYf+HObHB/MBA9o0p
         9FSQ==
X-Gm-Message-State: ACgBeo38qk/Gf0EmzlMq7m+l5CNnLLc+LubS2YRKlwmZNXsO8GmosO2b
        R4lWbt27AuqU1T94seRhRrloGChyD42CFW5eKunv0xLtc0qYEZipCsnjkIBLT8JjywuTv9gikp/
        lgbTS/6z1MjDQ
X-Received: by 2002:a02:3449:0:b0:349:66a3:3f5 with SMTP id z9-20020a023449000000b0034966a303f5mr14495697jaz.109.1661955138891;
        Wed, 31 Aug 2022 07:12:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4pb0ceZ9MN32Kk9uijudLueoYdYDI+vgr70pmyvFY/hY9+Mimg8Kox7TYFGAs2GCiXo7jPgw==
X-Received: by 2002:a02:3449:0:b0:349:66a3:3f5 with SMTP id z9-20020a023449000000b0034966a303f5mr14495687jaz.109.1661955138660;
        Wed, 31 Aug 2022 07:12:18 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z11-20020a027a4b000000b00349bdd5212asm6925554jad.47.2022.08.31.07.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 07:12:18 -0700 (PDT)
Date:   Wed, 31 Aug 2022 08:12:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <liulongfang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for
 hssi_acc_drvdata()
Message-ID: <20220831081216.0f8df490.alex.williamson@redhat.com>
In-Reply-To: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
References: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Aug 2022 09:59:43 +0100
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Commit 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the
> vfio_pci_core_device in drvdata") introduced a helper function to
> retrieve the drvdata but used "hssi" instead of "hisi" for the
> function prefix. Correct that and also while at it, moved the
> function a bit down so that it's close to other hisi_ prefixed
> functions.
> 
> No functional changes.
> 
> Fixes: 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata")

The above two lines are usually mutually exclusive, the latter will
cause this change to be backported to all releases including that
commit.  As a largely aesthetic change, is that what you're looking
for?  Thanks,

Alex

> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 20 +++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index ea762e28c1cc..258cae0863ea 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -337,14 +337,6 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
>  	return 0;
>  }
>  
> -static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev *pdev)
> -{
> -	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> -
> -	return container_of(core_device, struct hisi_acc_vf_core_device,
> -			    core_device);
> -}
> -
>  static void vf_qm_fun_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  			    struct hisi_qm *qm)
>  {
> @@ -552,6 +544,14 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	return 0;
>  }
>  
> +static struct hisi_acc_vf_core_device *hisi_acc_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct hisi_acc_vf_core_device,
> +			    core_device);
> +}
> +
>  /* Check the PF's RAS state and Function INT state */
>  static int
>  hisi_acc_check_int_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> @@ -970,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>  
>  static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
>  
>  	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
>  				VFIO_MIGRATION_STOP_COPY)
> @@ -1301,7 +1301,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  
>  static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>  	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);

