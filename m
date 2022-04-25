Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FE150D6A1
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 03:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240183AbiDYBiH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 24 Apr 2022 21:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240181AbiDYBh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 21:37:59 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E713EF32B2
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 18:34:55 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KmnWg4mX6zCsH1;
        Mon, 25 Apr 2022 09:30:23 +0800 (CST)
Received: from kwepemm600015.china.huawei.com (7.193.23.52) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 09:34:53 +0800
Received: from kwepemm600015.china.huawei.com ([7.193.23.52]) by
 kwepemm600015.china.huawei.com ([7.193.23.52]) with mapi id 15.01.2375.024;
 Mon, 25 Apr 2022 09:34:53 +0800
From:   "Wangjing(Hogan)" <hogan.wang@huawei.com>
To:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Huangweidong (C)" <weidong.huang@huawei.com>,
        Yechuan <yechuan@huawei.com>
Subject: Re:  [PATCH] vfio-pci: report recovery event after device recovery
 successful
Thread-Topic: [PATCH] vfio-pci: report recovery event after device recovery
 successful
Thread-Index: AdhYQ6REZrzWDB6aT9yrdNSXU0vsTg==
Date:   Mon, 25 Apr 2022 01:34:53 +0000
Message-ID: <9acffefb77ac4f228fb175a6d5272283@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.166.163.49]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Ping

> 
> As you all know, device faults are classified into the following
> types: unrecoverable error and recoverable error. vfio-pci drvier will report
> error event to user-space process while device occur hardware errors, and
> still report the other error event after deivce recovery successful. So the
> user-space process just like qemu can not identify the event is an hardware
> error event or a device recovery successful event. So in order to solve this
> problem, add an eventfd named recov_trigger to report device recovery
> successful event, the user-space process can make a decision whether to
> process the recovery event or not.
> 
> Signed-off-by: Hogan Wang <hogan.wang@huawei.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c  | 13 +++++++++++--
> drivers/vfio/pci/vfio_pci_intrs.c | 19 +++++++++++++++++++
>  include/linux/vfio_pci_core.h     |  1 +
>  include/uapi/linux/vfio.h         |  1 +
>  4 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index b7bb16f92ac6..2360cb44aa36 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -483,6 +483,10 @@ void vfio_pci_core_close_device(struct vfio_device
> *core_vdev)
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
> @@ -1922,8 +1926,13 @@ pci_ers_result_t
> vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
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
> 
>  	mutex_unlock(&vdev->igate);
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 6069a11fb51a..be76ff76c361 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -624,6 +624,17 @@ static int vfio_pci_set_err_trigger(struct
> vfio_pci_core_device *vdev,
>  					       count, flags, data);
>  }
> 
> +static int vfio_pci_set_recov_trigger(struct vfio_pci_core_device *vdev,
> +				    unsigned index, unsigned start,
> +				    unsigned count, uint32_t flags, void *data) {
> +	if (index != VFIO_PCI_ERR_IRQ_INDEX || start != 0 || count > 1)
> +		return -EINVAL;
> +
> +	return vfio_pci_set_ctx_trigger_single(&vdev->recov_trigger,
> +					       count, flags, data);
> +}
> +
>  static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
>  				    unsigned index, unsigned start,
>  				    unsigned count, uint32_t flags, void *data) @@
> -684,6 +695,14 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device
> *vdev, uint32_t flags,
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
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h index
> 74a4a0f17b28..d94addb18118 100644
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
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h index
> fea86061b44e..f88a6ca62c49 100644
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
> --
> 2.33.0

