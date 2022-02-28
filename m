Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01674C73E1
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 18:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbiB1Rij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 12:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238783AbiB1RiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 12:38:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45BE57D013
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 09:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646069624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EqPUjuDBqn5Lu6pDeJoTefOb/5PdohRN9v0ddUjXPvo=;
        b=f3IwtuLYBs6Rs5PAjtfpa9eS6ip0Pbc98Tp7CXrqXJ9DZAvrIg2O8u5J1M9okEWA2PgA2w
        CSgf4tE2RR47qI1EacQJad8IBSt7bYEtL/UiI+JwlQ9XZl4qTqs/Ep74uNzE6pbFLI1b3Y
        e4vAmJ9rfvgxqfj3Zk+sGvueAbFVn24=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-T5JMIASgPF2Q9oGs0If3nA-1; Mon, 28 Feb 2022 12:33:43 -0500
X-MC-Unique: T5JMIASgPF2Q9oGs0If3nA-1
Received: by mail-oi1-f197.google.com with SMTP id be8-20020a056808218800b002d5425fab8cso5883770oib.1
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 09:33:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EqPUjuDBqn5Lu6pDeJoTefOb/5PdohRN9v0ddUjXPvo=;
        b=jfSB/KsfM/Rn/OuyNn9v+rkeWgw7+61rrZjoNYFRwd0PjHySyDWS2SDrNsfbraiTHY
         3FxV9U9GfWlAGd+q2UP5CiDK9QDgjpBGraNZ8fWEijbyk6gvDOYfoQOH/K84CWjNZRFO
         rl6Oj5REo4QBR/3QdijK/OvP4bGavGN6fiBR8aZ3dYnuEXsHFsosvn7xRubCR4I7gKa9
         uoMDT+BRXwtscZvK6qlkH3Utv0eWoCDt3NjSw2u18r0OQhEufUdNSXTIBYQfFG0Mbw5t
         wyUpQ+JzLvmq7ksfos43/EHuLpEnpM5L5h2yBnqAbrvmmDXklBxCBNG5sKIj4AqUwAus
         KxRA==
X-Gm-Message-State: AOAM531msGDJB4xUjkAbgw7gTatMwB/+s3OAEeGqnx74VN2PCIqopJNR
        VdtXsZuyrlMYolT1qBpe4GscZ/JPVHy4S2mT0nDnau8dQjHRXxY7Ge+xi/0mUgtJWbKScL8tJWT
        mEH+V6PTYHnNg
X-Received: by 2002:a9d:6445:0:b0:59a:ebae:155b with SMTP id m5-20020a9d6445000000b0059aebae155bmr9778561otl.270.1646069621990;
        Mon, 28 Feb 2022 09:33:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQPFJaAb0KvlwoTLjIGtuvXmo4QXpyccFci0Rpu++2G9KCLx2NXKpWsI0Q6uTyb2Aa6RRzxQ==
X-Received: by 2002:a9d:6445:0:b0:59a:ebae:155b with SMTP id m5-20020a9d6445000000b0059aebae155bmr9778519otl.270.1646069621348;
        Mon, 28 Feb 2022 09:33:41 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l26-20020a05683004ba00b005af665739e0sm5256946otd.30.2022.02.28.09.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 09:33:40 -0800 (PST)
Date:   Mon, 28 Feb 2022 10:33:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 03/10] hisi_acc_qm: Move PCI device IDs to common
 header
Message-ID: <20220228103338.76da0b3b.alex.williamson@redhat.com>
In-Reply-To: <20220228090121.1903-4-shameerali.kolothum.thodi@huawei.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
        <20220228090121.1903-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Cc+ Bjorn, linux-pci]

On Mon, 28 Feb 2022 09:01:14 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Move the PCI Device IDs of HiSilicon ACC devices to
> a common header and use a uniform naming convention.
> 
> This will be useful when we introduce the vfio PCI
> HiSilicon ACC live migration driver in subsequent patches.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 12 +++++-------
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 14 ++++++--------
>  drivers/crypto/hisilicon/zip/zip_main.c   | 11 ++++-------
>  include/linux/pci_ids.h                   |  6 ++++++
>  4 files changed, 21 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> index ebfab3e14499..ba4043447e53 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> @@ -68,8 +68,6 @@
>  #define HPRE_REG_RD_INTVRL_US		10
>  #define HPRE_REG_RD_TMOUT_US		1000
>  #define HPRE_DBGFS_VAL_MAX_LEN		20
> -#define HPRE_PCI_DEVICE_ID		0xa258
> -#define HPRE_PCI_VF_DEVICE_ID		0xa259
>  #define HPRE_QM_USR_CFG_MASK		GENMASK(31, 1)
>  #define HPRE_QM_AXI_CFG_MASK		GENMASK(15, 0)
>  #define HPRE_QM_VFG_AX_MASK		GENMASK(7, 0)
> @@ -111,8 +109,8 @@
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
> @@ -242,7 +240,7 @@ MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
>  
>  static int pf_q_num_set(const char *val, const struct kernel_param *kp)
>  {
> -	return q_num_set(val, kp, HPRE_PCI_DEVICE_ID);
> +	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_HPRE_PF);
>  }
>  
>  static const struct kernel_param_ops hpre_pf_q_num_ops = {
> @@ -921,7 +919,7 @@ static int hpre_debugfs_init(struct hisi_qm *qm)
>  	qm->debug.sqe_mask_len = HPRE_SQE_MASK_LEN;
>  	hisi_qm_debug_init(qm);
>  
> -	if (qm->pdev->device == HPRE_PCI_DEVICE_ID) {
> +	if (qm->pdev->device == PCI_DEVICE_ID_HUAWEI_HPRE_PF) {
>  		ret = hpre_ctrl_debug_init(qm);
>  		if (ret)
>  			goto failed_to_create;
> @@ -958,7 +956,7 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
>  	qm->sqe_size = HPRE_SQE_SIZE;
>  	qm->dev_name = hpre_name;
>  
> -	qm->fun_type = (pdev->device == HPRE_PCI_DEVICE_ID) ?
> +	qm->fun_type = (pdev->device == PCI_DEVICE_ID_HUAWEI_HPRE_PF) ?
>  			QM_HW_PF : QM_HW_VF;
>  	if (qm->fun_type == QM_HW_PF) {
>  		qm->qp_base = HPRE_PF_DEF_Q_BASE;
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 26d3ab1d308b..ab806fb481ac 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -20,8 +20,6 @@
>  
>  #define SEC_VF_NUM			63
>  #define SEC_QUEUE_NUM_V1		4096
> -#define SEC_PF_PCI_DEVICE_ID		0xa255
> -#define SEC_VF_PCI_DEVICE_ID		0xa256
>  
>  #define SEC_BD_ERR_CHK_EN0		0xEFFFFFFF
>  #define SEC_BD_ERR_CHK_EN1		0x7ffff7fd
> @@ -225,7 +223,7 @@ static const struct debugfs_reg32 sec_dfx_regs[] = {
>  
>  static int sec_pf_q_num_set(const char *val, const struct kernel_param *kp)
>  {
> -	return q_num_set(val, kp, SEC_PF_PCI_DEVICE_ID);
> +	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_SEC_PF);
>  }
>  
>  static const struct kernel_param_ops sec_pf_q_num_ops = {
> @@ -313,8 +311,8 @@ module_param_cb(uacce_mode, &sec_uacce_mode_ops, &uacce_mode, 0444);
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
> @@ -717,7 +715,7 @@ static int sec_core_debug_init(struct hisi_qm *qm)
>  	regset->base = qm->io_base;
>  	regset->dev = dev;
>  
> -	if (qm->pdev->device == SEC_PF_PCI_DEVICE_ID)
> +	if (qm->pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_PF)
>  		debugfs_create_file("regs", 0444, tmp_d, regset, &sec_regs_fops);
>  
>  	for (i = 0; i < ARRAY_SIZE(sec_dfx_labels); i++) {
> @@ -735,7 +733,7 @@ static int sec_debug_init(struct hisi_qm *qm)
>  	struct sec_dev *sec = container_of(qm, struct sec_dev, qm);
>  	int i;
>  
> -	if (qm->pdev->device == SEC_PF_PCI_DEVICE_ID) {
> +	if (qm->pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_PF) {
>  		for (i = SEC_CLEAR_ENABLE; i < SEC_DEBUG_FILE_NUM; i++) {
>  			spin_lock_init(&sec->debug.files[i].lock);
>  			sec->debug.files[i].index = i;
> @@ -877,7 +875,7 @@ static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
>  	qm->sqe_size = SEC_SQE_SIZE;
>  	qm->dev_name = sec_name;
>  
> -	qm->fun_type = (pdev->device == SEC_PF_PCI_DEVICE_ID) ?
> +	qm->fun_type = (pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_PF) ?
>  			QM_HW_PF : QM_HW_VF;
>  	if (qm->fun_type == QM_HW_PF) {
>  		qm->qp_base = SEC_PF_DEF_Q_BASE;
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index 678f8b58ec42..f4a517728385 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -15,9 +15,6 @@
>  #include <linux/uacce.h>
>  #include "zip.h"
>  
> -#define PCI_DEVICE_ID_ZIP_PF		0xa250
> -#define PCI_DEVICE_ID_ZIP_VF		0xa251
> -
>  #define HZIP_QUEUE_NUM_V1		4096
>  
>  #define HZIP_CLOCK_GATE_CTRL		0x301004
> @@ -246,7 +243,7 @@ MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
>  
>  static int pf_q_num_set(const char *val, const struct kernel_param *kp)
>  {
> -	return q_num_set(val, kp, PCI_DEVICE_ID_ZIP_PF);
> +	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_ZIP_PF);
>  }
>  
>  static const struct kernel_param_ops pf_q_num_ops = {
> @@ -268,8 +265,8 @@ module_param_cb(vfs_num, &vfs_num_ops, &vfs_num, 0444);
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
> @@ -838,7 +835,7 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
>  	qm->sqe_size = HZIP_SQE_SIZE;
>  	qm->dev_name = hisi_zip_name;
>  
> -	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ?
> +	qm->fun_type = (pdev->device == PCI_DEVICE_ID_HUAWEI_ZIP_PF) ?
>  			QM_HW_PF : QM_HW_VF;
>  	if (qm->fun_type == QM_HW_PF) {
>  		qm->qp_base = HZIP_PF_DEF_Q_BASE;
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index aad54c666407..6b98e0d91f0a 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2529,6 +2529,12 @@
>  #define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
>  
>  #define PCI_VENDOR_ID_HUAWEI		0x19e5
> +#define PCI_DEVICE_ID_HUAWEI_ZIP_PF	0xa250
> +#define PCI_DEVICE_ID_HUAWEI_ZIP_VF	0xa251
> +#define PCI_DEVICE_ID_HUAWEI_SEC_PF	0xa255
> +#define PCI_DEVICE_ID_HUAWEI_SEC_VF	0xa256
> +#define PCI_DEVICE_ID_HUAWEI_HPRE_PF	0xa258
> +#define PCI_DEVICE_ID_HUAWEI_HPRE_VF	0xa259
>  
>  #define PCI_VENDOR_ID_NETRONOME		0x19ee
>  #define PCI_DEVICE_ID_NETRONOME_NFP4000	0x4000

