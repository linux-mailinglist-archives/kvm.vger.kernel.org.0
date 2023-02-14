Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B3F69562C
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 02:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjBNBym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 20:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBNByl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 20:54:41 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8DAB46F;
        Mon, 13 Feb 2023 17:54:40 -0800 (PST)
Received: from kwepemi100025.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PG43R4D9bzJqhP;
        Tue, 14 Feb 2023 09:52:51 +0800 (CST)
Received: from [10.174.148.223] (10.174.148.223) by
 kwepemi100025.china.huawei.com (7.221.188.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Feb 2023 09:53:47 +0800
Message-ID: <e28e0102-72ca-ae9d-d09c-6003f4f1c53c@huawei.com>
Date:   Tue, 14 Feb 2023 09:53:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] vhost-vdpa: cleanup memory maps when closing vdpa fds
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <20230131145310.2069-1-longpeng2@huawei.com>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
In-Reply-To: <20230131145310.2069-1-longpeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi100025.china.huawei.com (7.221.188.158)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi guys, any suggestions?

在 2023/1/31 22:53, Longpeng(Mike) 写道:
> From: Longpeng <longpeng2@huawei.com>
> 
> We must cleanup all memory maps when closing the vdpa fds, otherwise
> some critical resources (e.g. memory, iommu map) will leaked if the
> userspace exits unexpectedly (e.g. kill -9).
> 
> Signed-off-by: Longpeng <longpeng2@huawei.com>
> ---
>   drivers/vhost/vdpa.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index a527eeeac637..37477cffa5aa 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -823,6 +823,18 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
>   		vhost_vdpa_remove_as(v, asid);
>   }
>   
> +static void vhost_vdpa_clean_map(struct vhost_vdpa *v)
> +{
> +	struct vhost_vdpa_as *as;
> +	u32 asid;
> +
> +	for (asid = 0; asid < v->vdpa->nas; asid++) {
> +		as = asid_to_as(v, asid);
> +		if (as)
> +			vhost_vdpa_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
> +	}
> +}
> +
>   static int vhost_vdpa_va_map(struct vhost_vdpa *v,
>   			     struct vhost_iotlb *iotlb,
>   			     u64 iova, u64 size, u64 uaddr, u32 perm)
> @@ -1247,6 +1259,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>   	vhost_vdpa_clean_irq(v);
>   	vhost_vdpa_reset(v);
>   	vhost_dev_stop(&v->vdev);
> +	vhost_vdpa_clean_map(v);
>   	vhost_vdpa_free_domain(v);
>   	vhost_vdpa_config_put(v);
>   	vhost_vdpa_cleanup(v);
