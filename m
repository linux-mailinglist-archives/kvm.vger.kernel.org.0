Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38233523C49
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 20:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346102AbiEKSOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 14:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiEKSOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 14:14:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47A82E15CE
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 11:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652292850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e8tw4RHpvoWpE5ZFmkiiqo8JgoKYAYHFVX7zBeOOfRM=;
        b=eKMLzKp9pVYT0Uc6SA2O7YqNDV8t7103RnN5ig+iSdxyuKX7DnIGd0Woru+CkFEfDqIepr
        XfQaBhM6Y7WBr60Tm+RRyk3dCVoAI7XskPST0Ge6W16Ro4HhgPJKbhRRtzxsbT/qsbBNin
        G4ZOMmIDRyw4K3HP5gW1FMnsMK+yjIg=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-26rtAtI5Oa-3L4UDXFewVw-1; Wed, 11 May 2022 14:14:09 -0400
X-MC-Unique: 26rtAtI5Oa-3L4UDXFewVw-1
Received: by mail-il1-f200.google.com with SMTP id g1-20020a92cda1000000b002cf30d49956so1812546ild.18
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 11:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=e8tw4RHpvoWpE5ZFmkiiqo8JgoKYAYHFVX7zBeOOfRM=;
        b=2zc7YsQ2CsfQCA1rhezlnMCav7EmtCB8SA3krwxCX44VIU0ZysBkKBq1EszUIBug7E
         reSeMiiWDLdqZLLvnhT76YPXFQBKiu9vgJXz+myuEczLMhuofUwvTpQxpvSOIq3M1D3a
         K/CjMgZsiRxonxyGwrbo4hreI8xaLR1GmOq6DZ89ifuA7+OVfoArQl0JtRmzdBuYlDVe
         oMs1028Oh4CrhH5REIlCF3BYD+cLlPP1tB3TXLPlfe2JvbWCcFhNN1q+Yyc3N3+yKyd7
         AVBbKl1E9W2IWZrZwTYDlK27zu8BJ2TwjFbpzHrRR6sNEReFaLjeuxS+mJU+Es48j0Xy
         u0RQ==
X-Gm-Message-State: AOAM533DMPFS098RgImH0prz/SI1U3xN2tZNocT2NzWRwhw27YgdixLj
        GK67Dioxt6AHrygIuXCOD1Ggf7xknnVSr1vUrA1C3rYOH9JL6TTwBWrO43+0SKxGjCnnTOAEZt1
        cyhXUTnCaqWs9
X-Received: by 2002:a6b:3fc2:0:b0:65a:4236:bb42 with SMTP id m185-20020a6b3fc2000000b0065a4236bb42mr11430667ioa.215.1652292848588;
        Wed, 11 May 2022 11:14:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFckRLd6juGR8V19mdOBBRdd/wh332jZ4Tlto4gSsrGUAC53RhX6bBbX+07SFiJNasCHHtsA==
X-Received: by 2002:a6b:3fc2:0:b0:65a:4236:bb42 with SMTP id m185-20020a6b3fc2000000b0065a4236bb42mr11430658ioa.215.1652292848330;
        Wed, 11 May 2022 11:14:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h18-20020a0566380f1200b0032b3a7817a3sm761417jas.103.2022.05.11.11.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 11:14:07 -0700 (PDT)
Date:   Wed, 11 May 2022 12:14:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Hogan Wang <hogan.wang@huawei.com>
Cc:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <kvm@vger.kernel.org>, <weidong.huang@huawei.com>,
        <yechuan@huawei.com>
Subject: Re: [PATCH] vfio-pci: report recovery event after device recovery
 successful
Message-ID: <20220511121406.0f9836e6.alex.williamson@redhat.com>
In-Reply-To: <20220420071601.900-1-hogan.wang@huawei.com>
References: <20220420071601.900-1-hogan.wang@huawei.com>
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

On Wed, 20 Apr 2022 15:16:01 +0800
Hogan Wang <hogan.wang@huawei.com> wrote:

> As you all know, device faults are classified into the following
> types: unrecoverable error and recoverable error. vfio-pci drvier
> will report error event to user-space process while device occur
> hardware errors, and still report the other error event after deivce
> recovery successful. So the user-space process just like qemu can not
> identify the event is an hardware error event or a device recovery
> successful event. So in order to solve this problem, add an eventfd
> named recov_trigger to report device recovery successful event, the
> user-space process can make a decision whether to process the recovery
> event or not.
> 
> Signed-off-by: Hogan Wang <hogan.wang@huawei.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c  | 13 +++++++++++--
>  drivers/vfio/pci/vfio_pci_intrs.c | 19 +++++++++++++++++++
>  include/linux/vfio_pci_core.h     |  1 +
>  include/uapi/linux/vfio.h         |  1 +
>  4 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index b7bb16f92ac6..2360cb44aa36 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -483,6 +483,10 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  		eventfd_ctx_put(vdev->err_trigger);
>  		vdev->err_trigger = NULL;
>  	}
> +	if (vdev->recov_trigger) {
> +		eventfd_ctx_put(vdev->recov_trigger);
> +		vdev->recov_trigger = NULL;
> +	}
>  	if (vdev->req_trigger) {
>  		eventfd_ctx_put(vdev->req_trigger);
>  		vdev->req_trigger = NULL;
> @@ -1922,8 +1926,13 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
>  
>  	mutex_lock(&vdev->igate);
>  
> -	if (vdev->err_trigger)
> -		eventfd_signal(vdev->err_trigger, 1);
> +	if (state == pci_channel_io_normal) {
> +		if (vdev->recov_trigger)
> +			eventfd_signal(vdev->recov_trigger, 1);
> +	} else {
> +		if (vdev->err_trigger)
> +			eventfd_signal(vdev->err_trigger, 1);
> +	}

The goal of the existing notification is to signal on any uncorrected
error which requires intervention at the device.  Here we're masking
non-fatal, ie. recoverable, errors from that existing mechanism.  There
is no userspace that currently handles this new recovery notification,
therefore this is not a backwards compatible proposal.

I also don't see how an asynchronous notification to userspace allows
the device to continue operating, the problem is not as simple as
raising a different interrupt.  Thanks,

Alex

>  
>  	mutex_unlock(&vdev->igate);
>  
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 6069a11fb51a..be76ff76c361 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -624,6 +624,17 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
>  					       count, flags, data);
>  }
>  
> +static int vfio_pci_set_recov_trigger(struct vfio_pci_core_device *vdev,
> +				    unsigned index, unsigned start,
> +				    unsigned count, uint32_t flags, void *data)
> +{
> +	if (index != VFIO_PCI_ERR_IRQ_INDEX || start != 0 || count > 1)
> +		return -EINVAL;
> +
> +	return vfio_pci_set_ctx_trigger_single(&vdev->recov_trigger,
> +					       count, flags, data);
> +}
> +
>  static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
>  				    unsigned index, unsigned start,
>  				    unsigned count, uint32_t flags, void *data)
> @@ -684,6 +695,14 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>  			break;
>  		}
>  		break;
> +	case VFIO_PCI_RECOV_IRQ_INDEX:
> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
> +			if (pci_is_pcie(vdev->pdev))
> +				func = vfio_pci_set_recov_trigger;
> +			break;
> +		}
> +		break;
>  	}
>  
>  	if (!func)
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 74a4a0f17b28..d94addb18118 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -128,6 +128,7 @@ struct vfio_pci_core_device {
>  	struct pci_saved_state	*pm_save;
>  	int			ioeventfds_nr;
>  	struct eventfd_ctx	*err_trigger;
> +	struct eventfd_ctx	*recov_trigger;
>  	struct eventfd_ctx	*req_trigger;
>  	struct list_head	dummy_resources_list;
>  	struct mutex		ioeventfds_lock;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index fea86061b44e..f88a6ca62c49 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -621,6 +621,7 @@ enum {
>  	VFIO_PCI_MSIX_IRQ_INDEX,
>  	VFIO_PCI_ERR_IRQ_INDEX,
>  	VFIO_PCI_REQ_IRQ_INDEX,
> +	VFIO_PCI_RECOV_IRQ_INDEX,
>  	VFIO_PCI_NUM_IRQS
>  };
>  

