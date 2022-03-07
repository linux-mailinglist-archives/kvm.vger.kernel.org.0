Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5574D05BC
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 18:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242924AbiCGRyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 12:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240268AbiCGRyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 12:54:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 512986E7AA
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 09:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646675630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Phzvk5ZfdwXL86R1Ll1kGCmrMjBQ5JPq3LvWiDPj4HI=;
        b=jQ7nj1YftwEr6vNriH8nSE4Aeg0KxhurbWbAvIE+qf5Sn+prFf24BMpU1rczAizA/JXjpp
        SC3m1ESZh0ITbYAa4bk0OLj9weKNeOd0yNhOiKNLrpZ2OdiRivYGp1iJ6fsgGUNkio6fZV
        lNj2YqK9tgCvWxphF4Avz1Ed+7ikIOc=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-j_MM9sm0Pk2qh651nALW4Q-1; Mon, 07 Mar 2022 12:53:49 -0500
X-MC-Unique: j_MM9sm0Pk2qh651nALW4Q-1
Received: by mail-ot1-f71.google.com with SMTP id n7-20020a9d4d07000000b005b2389a99cfso2016076otf.17
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 09:53:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Phzvk5ZfdwXL86R1Ll1kGCmrMjBQ5JPq3LvWiDPj4HI=;
        b=PK7WBfvuJTm1iwGq4KprRD09vVVEV2oA9fRhMh1efH0Okj6WP2C+36eogmcbvDfZkC
         h9/X0qLbQqVlAYadALt2FAuW3qpbHug6okPqXEUp+edDG6J9X3DvNIOOIrXqKzwC+q+M
         IoSasz27BewIH1LYtUvNxM2nAXgI/1ugl8rSpxy+VWvlPcB0j5WqZjAz/ufKW+fKN+5J
         5re9lmLU7d3Fjyazi7JUByRg1M1jHrBS3JSqxzK/LAu8L/FFG7NRMvzdqmgf1W/fzGD2
         gt2UXa/bbZ7f/HKYh43rV8SOPnmrTm26+Ioef2xJQs0eFrhL0ebgK05+E+EIx2iHfMPJ
         YPgA==
X-Gm-Message-State: AOAM531io0+Aoy/tkvbMVA+xcuLjiYfYYPvKg3nl0OkfCMcLR9ysaP08
        0scchH32TAQVGnGJJaeZQo1uGvfjC5pmQ4u8SfX6IKpnesl1sYkP04rwxuUPSxudlezqICAuX2n
        ZyFGNPQ0hsUSh
X-Received: by 2002:a05:6870:d250:b0:da:b3f:2b29 with SMTP id h16-20020a056870d25000b000da0b3f2b29mr59758oac.200.1646675626337;
        Mon, 07 Mar 2022 09:53:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxkd31qGYNfbok3dPK+eneOXrzS9JbQt5xfLAP9lippOgfoNtXjovLUd0XVAZ13GsGSiD+fg==
X-Received: by 2002:a05:6870:d250:b0:da:b3f:2b29 with SMTP id h16-20020a056870d25000b000da0b3f2b29mr59738oac.200.1646675626068;
        Mon, 07 Mar 2022 09:53:46 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l3-20020a056830268300b005b21c30a3c5sm3512451otu.29.2022.03.07.09.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 09:53:45 -0800 (PST)
Date:   Mon, 7 Mar 2022 10:53:44 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v8 3/9] hisi_acc_qm: Move VF PCI device IDs to common
 header
Message-ID: <20220307105344.171b4621.alex.williamson@redhat.com>
In-Reply-To: <20220303230131.2103-4-shameerali.kolothum.thodi@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
        <20220303230131.2103-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

Here's the respin of this patch that adds only the VF device IDs to
pci_ids.h.  The next patch in the series[1] adds a consumer of these
IDs as a vfio-pci vendor driver.  Thanks,

Alex

[1]https://lore.kernel.org/all/20220303230131.2103-5-shameerali.kolothum.thodi@huawei.com/

On Thu, 3 Mar 2022 23:01:25 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Move the PCI Device IDs of HiSilicon ACC VF devices to a common header
> and also use a uniform naming convention.
> 
> This will be useful when we introduce the vfio PCI HiSilicon ACC live
> migration driver in subsequent patches.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 13 ++++++-------
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 15 +++++++--------
>  drivers/crypto/hisilicon/zip/zip_main.c   | 11 +++++------
>  include/linux/pci_ids.h                   |  3 +++
>  4 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> index ebfab3e14499..3589d8879b5e 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> @@ -68,8 +68,7 @@
>  #define HPRE_REG_RD_INTVRL_US		10
>  #define HPRE_REG_RD_TMOUT_US		1000
>  #define HPRE_DBGFS_VAL_MAX_LEN		20
> -#define HPRE_PCI_DEVICE_ID		0xa258
> -#define HPRE_PCI_VF_DEVICE_ID		0xa259
> +#define PCI_DEVICE_ID_HUAWEI_HPRE_PF	0xa258
>  #define HPRE_QM_USR_CFG_MASK		GENMASK(31, 1)
>  #define HPRE_QM_AXI_CFG_MASK		GENMASK(15, 0)
>  #define HPRE_QM_VFG_AX_MASK		GENMASK(7, 0)
> @@ -111,8 +110,8 @@
>  static const char hpre_name[] = "hisi_hpre";
>  static struct dentry *hpre_debugfs_root;
>  static const struct pci_device_id hpre_dev_ids[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_PCI_DEVICE_ID) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_PCI_VF_DEVICE_ID) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_HPRE_PF) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_HPRE_VF) },
>  	{ 0, }
>  };
>  
> @@ -242,7 +241,7 @@ MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
>  
>  static int pf_q_num_set(const char *val, const struct kernel_param *kp)
>  {
> -	return q_num_set(val, kp, HPRE_PCI_DEVICE_ID);
> +	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_HPRE_PF);
>  }
>  
>  static const struct kernel_param_ops hpre_pf_q_num_ops = {
> @@ -921,7 +920,7 @@ static int hpre_debugfs_init(struct hisi_qm *qm)
>  	qm->debug.sqe_mask_len = HPRE_SQE_MASK_LEN;
>  	hisi_qm_debug_init(qm);
>  
> -	if (qm->pdev->device == HPRE_PCI_DEVICE_ID) {
> +	if (qm->pdev->device == PCI_DEVICE_ID_HUAWEI_HPRE_PF) {
>  		ret = hpre_ctrl_debug_init(qm);
>  		if (ret)
>  			goto failed_to_create;
> @@ -958,7 +957,7 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
>  	qm->sqe_size = HPRE_SQE_SIZE;
>  	qm->dev_name = hpre_name;
>  
> -	qm->fun_type = (pdev->device == HPRE_PCI_DEVICE_ID) ?
> +	qm->fun_type = (pdev->device == PCI_DEVICE_ID_HUAWEI_HPRE_PF) ?
>  			QM_HW_PF : QM_HW_VF;
>  	if (qm->fun_type == QM_HW_PF) {
>  		qm->qp_base = HPRE_PF_DEF_Q_BASE;
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 26d3ab1d308b..311a8747b5bf 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -20,8 +20,7 @@
>  
>  #define SEC_VF_NUM			63
>  #define SEC_QUEUE_NUM_V1		4096
> -#define SEC_PF_PCI_DEVICE_ID		0xa255
> -#define SEC_VF_PCI_DEVICE_ID		0xa256
> +#define PCI_DEVICE_ID_HUAWEI_SEC_PF	0xa255
>  
>  #define SEC_BD_ERR_CHK_EN0		0xEFFFFFFF
>  #define SEC_BD_ERR_CHK_EN1		0x7ffff7fd
> @@ -225,7 +224,7 @@ static const struct debugfs_reg32 sec_dfx_regs[] = {
>  
>  static int sec_pf_q_num_set(const char *val, const struct kernel_param *kp)
>  {
> -	return q_num_set(val, kp, SEC_PF_PCI_DEVICE_ID);
> +	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_SEC_PF);
>  }
>  
>  static const struct kernel_param_ops sec_pf_q_num_ops = {
> @@ -313,8 +312,8 @@ module_param_cb(uacce_mode, &sec_uacce_mode_ops, &uacce_mode, 0444);
>  MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
>  
>  static const struct pci_device_id sec_dev_ids[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, SEC_PF_PCI_DEVICE_ID) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, SEC_VF_PCI_DEVICE_ID) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_SEC_PF) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_SEC_VF) },
>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, sec_dev_ids);
> @@ -717,7 +716,7 @@ static int sec_core_debug_init(struct hisi_qm *qm)
>  	regset->base = qm->io_base;
>  	regset->dev = dev;
>  
> -	if (qm->pdev->device == SEC_PF_PCI_DEVICE_ID)
> +	if (qm->pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_PF)
>  		debugfs_create_file("regs", 0444, tmp_d, regset, &sec_regs_fops);
>  
>  	for (i = 0; i < ARRAY_SIZE(sec_dfx_labels); i++) {
> @@ -735,7 +734,7 @@ static int sec_debug_init(struct hisi_qm *qm)
>  	struct sec_dev *sec = container_of(qm, struct sec_dev, qm);
>  	int i;
>  
> -	if (qm->pdev->device == SEC_PF_PCI_DEVICE_ID) {
> +	if (qm->pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_PF) {
>  		for (i = SEC_CLEAR_ENABLE; i < SEC_DEBUG_FILE_NUM; i++) {
>  			spin_lock_init(&sec->debug.files[i].lock);
>  			sec->debug.files[i].index = i;
> @@ -877,7 +876,7 @@ static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
>  	qm->sqe_size = SEC_SQE_SIZE;
>  	qm->dev_name = sec_name;
>  
> -	qm->fun_type = (pdev->device == SEC_PF_PCI_DEVICE_ID) ?
> +	qm->fun_type = (pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_PF) ?
>  			QM_HW_PF : QM_HW_VF;
>  	if (qm->fun_type == QM_HW_PF) {
>  		qm->qp_base = SEC_PF_DEF_Q_BASE;
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index 678f8b58ec42..66decfe07282 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -15,8 +15,7 @@
>  #include <linux/uacce.h>
>  #include "zip.h"
>  
> -#define PCI_DEVICE_ID_ZIP_PF		0xa250
> -#define PCI_DEVICE_ID_ZIP_VF		0xa251
> +#define PCI_DEVICE_ID_HUAWEI_ZIP_PF	0xa250
>  
>  #define HZIP_QUEUE_NUM_V1		4096
>  
> @@ -246,7 +245,7 @@ MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
>  
>  static int pf_q_num_set(const char *val, const struct kernel_param *kp)
>  {
> -	return q_num_set(val, kp, PCI_DEVICE_ID_ZIP_PF);
> +	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_ZIP_PF);
>  }
>  
>  static const struct kernel_param_ops pf_q_num_ops = {
> @@ -268,8 +267,8 @@ module_param_cb(vfs_num, &vfs_num_ops, &vfs_num, 0444);
>  MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63), 0(default)");
>  
>  static const struct pci_device_id hisi_zip_dev_ids[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_PF) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_VF) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_ZIP_PF) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_ZIP_VF) },
>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, hisi_zip_dev_ids);
> @@ -838,7 +837,7 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
>  	qm->sqe_size = HZIP_SQE_SIZE;
>  	qm->dev_name = hisi_zip_name;
>  
> -	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ?
> +	qm->fun_type = (pdev->device == PCI_DEVICE_ID_HUAWEI_ZIP_PF) ?
>  			QM_HW_PF : QM_HW_VF;
>  	if (qm->fun_type == QM_HW_PF) {
>  		qm->qp_base = HZIP_PF_DEF_Q_BASE;
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index aad54c666407..31dee2b65a62 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2529,6 +2529,9 @@
>  #define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
>  
>  #define PCI_VENDOR_ID_HUAWEI		0x19e5
> +#define PCI_DEVICE_ID_HUAWEI_ZIP_VF	0xa251
> +#define PCI_DEVICE_ID_HUAWEI_SEC_VF	0xa256
> +#define PCI_DEVICE_ID_HUAWEI_HPRE_VF	0xa259
>  
>  #define PCI_VENDOR_ID_NETRONOME		0x19ee
>  #define PCI_DEVICE_ID_NETRONOME_NFP4000	0x4000

