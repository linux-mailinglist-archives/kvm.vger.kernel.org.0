Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E884D0D58
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 02:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240745AbiCHBPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 20:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiCHBPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 20:15:11 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2B13616B;
        Mon,  7 Mar 2022 17:14:15 -0800 (PST)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KCHPb4bQ7zdZyb;
        Tue,  8 Mar 2022 09:12:51 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 09:14:12 +0800
Received: from [10.67.102.118] (10.67.102.118) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 09:14:12 +0800
Subject: Re: [PATCH v8 9/9] hisi_acc_vfio_pci: Use its own PCI reset_done
 error handler
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-10-shameerali.kolothum.thodi@huawei.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <c4c07776-cd6c-f21e-b8e0-4cbf102a0389@huawei.com>
Date:   Tue, 8 Mar 2022 09:14:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20220303230131.2103-10-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.118]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/3/4 7:01, Shameer Kolothum wrote:
> Register private handler for pci_error_handlers.reset_done and update
> state accordingly.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 57 ++++++++++++++++++-
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  4 +-
>  2 files changed, 57 insertions(+), 4 deletions(-)
> 
Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks,
Longfang
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index aa2e4b6bf598..53e4c5cb3a71 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -625,6 +625,27 @@ static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vde
>  	}
>  }
>  
> +/*
> + * This function is called in all state_mutex unlock cases to
> + * handle a 'deferred_reset' if exists.
> + */
> +static void
> +hisi_acc_vf_state_mutex_unlock(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +{
> +again:
> +	spin_lock(&hisi_acc_vdev->reset_lock);
> +	if (hisi_acc_vdev->deferred_reset) {
> +		hisi_acc_vdev->deferred_reset = false;
> +		spin_unlock(&hisi_acc_vdev->reset_lock);
> +		hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
> +		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> +		hisi_acc_vf_disable_fds(hisi_acc_vdev);
> +		goto again;
> +	}
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
> +	spin_unlock(&hisi_acc_vdev->reset_lock);
> +}
> +
>  static void hisi_acc_vf_start_device(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>  {
>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> @@ -921,7 +942,7 @@ hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
>  			break;
>  		}
>  	}
> -	mutex_unlock(&hisi_acc_vdev->state_mutex);
> +	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
>  	return res;
>  }
>  
> @@ -934,10 +955,35 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>  
>  	mutex_lock(&hisi_acc_vdev->state_mutex);
>  	*curr_state = hisi_acc_vdev->mig_state;
> -	mutex_unlock(&hisi_acc_vdev->state_mutex);
> +	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
>  	return 0;
>  }
>  
> +static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
> +
> +	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
> +				VFIO_MIGRATION_STOP_COPY)
> +		return;
> +
> +	/*
> +	 * As the higher VFIO layers are holding locks across reset and using
> +	 * those same locks with the mm_lock we need to prevent ABBA deadlock
> +	 * with the state_mutex and mm_lock.
> +	 * In case the state_mutex was taken already we defer the cleanup work
> +	 * to the unlock flow of the other running context.
> +	 */
> +	spin_lock(&hisi_acc_vdev->reset_lock);
> +	hisi_acc_vdev->deferred_reset = true;
> +	if (!mutex_trylock(&hisi_acc_vdev->state_mutex)) {
> +		spin_unlock(&hisi_acc_vdev->reset_lock);
> +		return;
> +	}
> +	spin_unlock(&hisi_acc_vdev->reset_lock);
> +	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
> +}
> +
>  static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>  {
>  	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
> @@ -1252,12 +1298,17 @@ static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
>  
> +static const struct pci_error_handlers hisi_acc_vf_err_handlers = {
> +	.reset_done = hisi_acc_vf_pci_aer_reset_done,
> +	.error_detected = vfio_pci_core_aer_err_detected,
> +};
> +
>  static struct pci_driver hisi_acc_vfio_pci_driver = {
>  	.name = KBUILD_MODNAME,
>  	.id_table = hisi_acc_vfio_pci_table,
>  	.probe = hisi_acc_vfio_pci_probe,
>  	.remove = hisi_acc_vfio_pci_remove,
> -	.err_handler = &vfio_pci_core_err_handlers,
> +	.err_handler = &hisi_acc_vf_err_handlers,
>  };
>  
>  module_pci_driver(hisi_acc_vfio_pci_driver);
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index 1c7d75408790..5494f4983bbe 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -98,6 +98,7 @@ struct hisi_acc_vf_migration_file {
>  
>  struct hisi_acc_vf_core_device {
>  	struct vfio_pci_core_device core_device;
> +	u8 deferred_reset:1;
>  	/* for migration state */
>  	struct mutex state_mutex;
>  	enum vfio_device_mig_state mig_state;
> @@ -107,7 +108,8 @@ struct hisi_acc_vf_core_device {
>  	struct hisi_qm vf_qm;
>  	u32 vf_qm_state;
>  	int vf_id;
> -
> +	/* for reset handler */
> +	spinlock_t reset_lock;
>  	struct hisi_acc_vf_migration_file *resuming_migf;
>  	struct hisi_acc_vf_migration_file *saving_migf;
>  };
> 
