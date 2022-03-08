Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BACD4D14C3
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345862AbiCHK37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 05:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244341AbiCHK36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 05:29:58 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB1D3C48F;
        Tue,  8 Mar 2022 02:29:01 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KCWjk5KmWzdb2N;
        Tue,  8 Mar 2022 18:27:38 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 18:29:00 +0800
Received: from [10.67.103.212] (10.67.103.212) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 18:28:59 +0800
Subject: Re: [PATCH v8 6/9] hisi_acc_vfio_pci: Add helper to retrieve the
 struct pci_driver
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-7-shameerali.kolothum.thodi@huawei.com>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
From:   "yekai(A)" <yekai13@huawei.com>
Message-ID: <77d96509-bad2-b271-aaaf-07ca6b699db6@huawei.com>
Date:   Tue, 8 Mar 2022 18:28:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220303230131.2103-7-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.212]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml100012.china.huawei.com (7.185.36.121)
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
> struct pci_driver pointer is an input into the pci_iov_get_pf_drvdata().
> Introduce helpers to retrieve the ACC PF dev struct pci_driver pointers
> as we use this in ACC vfio migration driver.
>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 6 ++++++
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 6 ++++++
>  drivers/crypto/hisilicon/zip/zip_main.c   | 6 ++++++
>  include/linux/hisi_acc_qm.h               | 5 +++++
>  4 files changed, 23 insertions(+)
>
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> index 3589d8879b5e..36ab30e9e654 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> @@ -1190,6 +1190,12 @@ static struct pci_driver hpre_pci_driver = {
>  	.driver.pm		= &hpre_pm_ops,
>  };
>
> +struct pci_driver *hisi_hpre_get_pf_driver(void)
> +{
> +	return &hpre_pci_driver;
> +}
> +EXPORT_SYMBOL_GPL(hisi_hpre_get_pf_driver);
> +
>  static void hpre_register_debugfs(void)
>  {
>  	if (!debugfs_initialized())
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 311a8747b5bf..421a405ca337 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -1088,6 +1088,12 @@ static struct pci_driver sec_pci_driver = {
>  	.driver.pm = &sec_pm_ops,
>  };
>
> +struct pci_driver *hisi_sec_get_pf_driver(void)
> +{
> +	return &sec_pci_driver;
> +}
> +EXPORT_SYMBOL_GPL(hisi_sec_get_pf_driver);
> +
>  static void sec_register_debugfs(void)
>  {
>  	if (!debugfs_initialized())
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index 66decfe07282..4534e1e107d1 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -1012,6 +1012,12 @@ static struct pci_driver hisi_zip_pci_driver = {
>  	.driver.pm		= &hisi_zip_pm_ops,
>  };
>
> +struct pci_driver *hisi_zip_get_pf_driver(void)
> +{
> +	return &hisi_zip_pci_driver;
> +}
> +EXPORT_SYMBOL_GPL(hisi_zip_get_pf_driver);
> +
>  static void hisi_zip_register_debugfs(void)
>  {
>  	if (!debugfs_initialized())
> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
> index 6a6477c34666..00f2a4db8723 100644
> --- a/include/linux/hisi_acc_qm.h
> +++ b/include/linux/hisi_acc_qm.h
> @@ -476,4 +476,9 @@ void hisi_qm_pm_init(struct hisi_qm *qm);
>  int hisi_qm_get_dfx_access(struct hisi_qm *qm);
>  void hisi_qm_put_dfx_access(struct hisi_qm *qm);
>  void hisi_qm_regs_dump(struct seq_file *s, struct debugfs_regset32 *regset);
> +
> +/* Used by VFIO ACC live migration driver */
> +struct pci_driver *hisi_sec_get_pf_driver(void);
> +struct pci_driver *hisi_hpre_get_pf_driver(void);
> +struct pci_driver *hisi_zip_get_pf_driver(void);
>  #endif
>

Hi Shameer,

It looks good to me for this movement.

Acked-by:  Kai Ye <yekai13@huawei.com>

Thanks,
Kai
