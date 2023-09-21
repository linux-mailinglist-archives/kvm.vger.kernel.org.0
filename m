Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405E77A95ED
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjIUQ7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 12:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjIUQ7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 12:59:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B82E5B
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 09:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695315432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tD4U+DBz8vqdTLY/43Ehl4REYq1fEB86EZ9HCmor6qM=;
        b=HAtPDqytJsC0AM8Di+z+faPBrTiLabyjGXPmDXXDsGouDsmPN+64T/ZJ133z8CdTnHE+qK
        /xLzZC4g1qMuE1UT+reCUF7FkRSQg2pdBUWnEckgUG12p3c6U0h4diSd3HTW3Fl1kTFYNw
        ICxDUYTXWsbApBZ8l4EXCBInGzXGN98=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-iB9JIYQCN2-dDU4QF1mNGw-1; Thu, 21 Sep 2023 12:35:36 -0400
X-MC-Unique: iB9JIYQCN2-dDU4QF1mNGw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-797e9be94d9so78465039f.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 09:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695314135; x=1695918935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tD4U+DBz8vqdTLY/43Ehl4REYq1fEB86EZ9HCmor6qM=;
        b=A/JZNSe7ZhuMELG38SMslbeJgygggLHrXhHGhD67vUX3AJU6RtiyBOJMOMO52OPGfy
         c/j/lfMWFMf4k55X889PXj3N/FSOlqKVp3JN+q4arhw7B0Q4z40uAD2oj5LCXLrsu0/j
         OwQ8phu/drz6ILNbcfX3f1ikJoAL1YO6m3bobBp64I7jaCUyRdJ9hFqDpSkV5rFLg9Am
         boWpr0JS7N3+2KBTYgXEI/ypULbz8ZAtB94mlbJANjZBaucTGfOqbkajtpPFgO/xGDZk
         cnoB84wOoVQiuCLmOUPubCwCKvxrHm4t/BJolSWMj14haLtf5goa6n5SUZODf1PWHbVO
         S1lA==
X-Gm-Message-State: AOJu0YwnvW0+onvMslCyE2ohrjMIG0pTSeOSu9noTsAo7/MoWuuYoPom
        HdcIg6MN0/xvf2JOal4S1z6+kS/PtBgzLcAR+AntGePflKOyRooJgK1BfZ7X0NL+8PasH3XX3Yy
        KW7zXOAVpkojp
X-Received: by 2002:a05:6602:22c9:b0:792:72b8:b8a with SMTP id e9-20020a05660222c900b0079272b80b8amr5798017ioe.18.1695314135539;
        Thu, 21 Sep 2023 09:35:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHg+vjIgiiKahCTX3pMbVYZvVM7y++HS72J5LDp17dAkeKgi8T2pTu5LkSnAe4sFsqgAei9hg==
X-Received: by 2002:a05:6602:22c9:b0:792:72b8:b8a with SMTP id e9-20020a05660222c900b0079272b80b8amr5797998ioe.18.1695314135221;
        Thu, 21 Sep 2023 09:35:35 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id w26-20020a02cf9a000000b00430a69ea278sm456847jar.167.2023.09.21.09.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 09:35:34 -0700 (PDT)
Date:   Thu, 21 Sep 2023 10:35:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH vfio 08/11] vfio/pci: Expose
 vfio_pci_core_setup_barmap()
Message-ID: <20230921103532.3e5f319e.alex.williamson@redhat.com>
In-Reply-To: <20230921124040.145386-9-yishaih@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
        <20230921124040.145386-9-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Sep 2023 15:40:37 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Expose vfio_pci_core_setup_barmap() to be used by drivers.
> 
> This will let drivers to mmap a BAR and re-use it from both vfio and the
> driver when it's applicable.
> 
> This API will be used in the next patches by the vfio/virtio coming
> driver.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 25 +++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_rdwr.c | 28 ++--------------------------
>  include/linux/vfio_pci_core.h    |  1 +
>  3 files changed, 28 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1929103ee59a..b56111ed8a8c 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -684,6 +684,31 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
>  
> +int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	void __iomem *io;
> +	int ret;
> +
> +	if (vdev->barmap[bar])
> +		return 0;
> +
> +	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
> +	if (ret)
> +		return ret;
> +
> +	io = pci_iomap(pdev, bar, 0);
> +	if (!io) {
> +		pci_release_selected_regions(pdev, 1 << bar);
> +		return -ENOMEM;
> +	}
> +
> +	vdev->barmap[bar] = io;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(vfio_pci_core_setup_barmap);

Not to endorse the rest of this yet, but minimally _GPL, same for the
following patch.  Thanks,

Alex

> +
>  void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_core_device *vdev =
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index e27de61ac9fe..6f08b3ecbb89 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -200,30 +200,6 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  	return done;
>  }
>  
> -static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
> -{
> -	struct pci_dev *pdev = vdev->pdev;
> -	int ret;
> -	void __iomem *io;
> -
> -	if (vdev->barmap[bar])
> -		return 0;
> -
> -	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
> -	if (ret)
> -		return ret;
> -
> -	io = pci_iomap(pdev, bar, 0);
> -	if (!io) {
> -		pci_release_selected_regions(pdev, 1 << bar);
> -		return -ENOMEM;
> -	}
> -
> -	vdev->barmap[bar] = io;
> -
> -	return 0;
> -}
> -
>  ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  			size_t count, loff_t *ppos, bool iswrite)
>  {
> @@ -262,7 +238,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  		}
>  		x_end = end;
>  	} else {
> -		int ret = vfio_pci_setup_barmap(vdev, bar);
> +		int ret = vfio_pci_core_setup_barmap(vdev, bar);
>  		if (ret) {
>  			done = ret;
>  			goto out;
> @@ -438,7 +414,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
>  		return -EINVAL;
>  #endif
>  
> -	ret = vfio_pci_setup_barmap(vdev, bar);
> +	ret = vfio_pci_core_setup_barmap(vdev, bar);
>  	if (ret)
>  		return ret;
>  
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 562e8754869d..67ac58e20e1d 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -127,6 +127,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
>  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
>  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
>  void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
> +int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
>  pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
>  						pci_channel_state_t state);
>  

