Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75574CD180
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbiCDJn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbiCDJn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:43:56 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1443F80235;
        Fri,  4 Mar 2022 01:43:05 -0800 (PST)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K92td3Bwbzdg4v;
        Fri,  4 Mar 2022 17:41:45 +0800 (CST)
Received: from [10.67.103.22] (10.67.103.22) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 4 Mar
 2022 17:43:04 +0800
Message-ID: <9ea8eabb-0581-dbc6-d7af-acd019173f7e@hisilicon.com>
Date:   Fri, 4 Mar 2022 17:43:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v8 7/9] crypto: hisilicon/qm: Set the VF QM state register
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-8-shameerali.kolothum.thodi@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <20220303230131.2103-8-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.22]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500005.china.huawei.com (7.192.104.229)
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

> From: Longfang Liu <liulongfang@huawei.com>>
> We use VF QM state register to record the status of the QM configuration
> state. This will be used in the ACC migration driver to determine whether
> we can safely save and restore the QM data.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Acked-by: Zhou Wang <wangzhou1@hisilicon.com>

Best,
Zhou

> ---
>  drivers/crypto/hisilicon/qm.c | 8 ++++++++
>  include/linux/hisi_acc_qm.h   | 6 ++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index c88e013371af..6a8776db38b5 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -3492,6 +3492,12 @@ static void hisi_qm_pci_uninit(struct hisi_qm *qm)
>  	pci_disable_device(pdev);
>  }
>  
> +static void hisi_qm_set_state(struct hisi_qm *qm, u8 state)
> +{
> +	if (qm->ver > QM_HW_V2 && qm->fun_type == QM_HW_VF)
> +		writel(state, qm->io_base + QM_VF_STATE);
> +}
> +
>  /**
>   * hisi_qm_uninit() - Uninitialize qm.
>   * @qm: The qm needed uninit.
> @@ -3520,6 +3526,7 @@ void hisi_qm_uninit(struct hisi_qm *qm)
>  		dma_free_coherent(dev, qm->qdma.size,
>  				  qm->qdma.va, qm->qdma.dma);
>  	}
> +	hisi_qm_set_state(qm, QM_NOT_READY);
>  	up_write(&qm->qps_lock);
>  
>  	qm_irq_unregister(qm);
> @@ -3745,6 +3752,7 @@ int hisi_qm_start(struct hisi_qm *qm)
>  	if (!ret)
>  		atomic_set(&qm->status.flags, QM_START);
>  
> +	hisi_qm_set_state(qm, QM_READY);
>  err_unlock:
>  	up_write(&qm->qps_lock);
>  	return ret;
> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
> index 00f2a4db8723..177f7b7cd414 100644
> --- a/include/linux/hisi_acc_qm.h
> +++ b/include/linux/hisi_acc_qm.h
> @@ -67,6 +67,7 @@
>  #define QM_DB_RAND_SHIFT_V2		16
>  #define QM_DB_INDEX_SHIFT_V2		32
>  #define QM_DB_PRIORITY_SHIFT_V2		48
> +#define QM_VF_STATE			0x60
>  
>  /* qm cache */
>  #define QM_CACHE_CTL			0x100050
> @@ -162,6 +163,11 @@ enum qm_debug_file {
>  	DEBUG_FILE_NUM,
>  };
>  
> +enum qm_vf_state {
> +	QM_READY = 0,
> +	QM_NOT_READY,
> +};
> +
>  struct qm_dfx {
>  	atomic64_t err_irq_cnt;
>  	atomic64_t aeq_irq_cnt;
> 
