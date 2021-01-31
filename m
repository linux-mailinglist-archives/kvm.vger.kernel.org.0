Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8FE309D94
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 16:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhAaPdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 10:33:21 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6138 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhAaPch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 10:32:37 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6016cd6a0000>; Sun, 31 Jan 2021 07:31:54 -0800
Received: from [172.27.11.151] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 31 Jan
 2021 15:31:52 +0000
Subject: Re: [PATCH RFC v2 08/10] vdpa: add vdpa simulator for block device
To:     Stefano Garzarella <sgarzare@redhat.com>,
        <virtualization@lists.linux-foundation.org>
CC:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        <kvm@vger.kernel.org>
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-9-sgarzare@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <e8f97ea2-d179-de37-a0ea-b2858510f3ce@nvidia.com>
Date:   Sun, 31 Jan 2021 17:31:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210128144127.113245-9-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612107115; bh=/0xd12CGdsGgQtAO4roApjViFTPmfrwbBmD5WIKe4bA=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=OSZetRcvpEbs0ZZLIMhzYbQI1yiT2a2zmYRRxH0odZjlWuGGNjgmiMoeS7bjQSHox
         Mlfwj3FAs1mgHvyp+jRnDDxEOsUJd8e1Jljk4CBM6glQChxwB/xewhjDaO5RWLui/e
         UOymk5H0YZxawSS98flX4W0WdSSYi+96UsQPP9HEUQRMbXETnRBJIZvFICUWZwTImp
         9Ae0uZrTi9ByJbkSdW4+DtaM117lgUQq1wY9HOw7EFk3+ECuj4cGU53QIpD1gMZiJL
         ZalyNj+LmJBBQ30XoiPYCfvHtp5Hq4KNScWQ3PRQnyrlt74yIW6HWMfuCt2eIquWS6
         2AohHnABGkoYA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/28/2021 4:41 PM, Stefano Garzarella wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
>
> This will allow running vDPA for virtio block protocol.
>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> [sgarzare: various cleanups/fixes]
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v2:
> - rebased on top of other changes (dev_attr, get_config(), notify(), etc.)
> - memset to 0 the config structure in vdpasim_blk_get_config()
> - used vdpasim pointer in vdpasim_blk_get_config()
>
> v1:
> - Removed unused headers
> - Used cpu_to_vdpasim*() to store config fields
> - Replaced 'select VDPA_SIM' with 'depends on VDPA_SIM' since selected
>    option can not depend on other [Jason]
> - Start with a single queue for now [Jason]
> - Add comments to memory barriers
> ---
>   drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 145 +++++++++++++++++++++++++++
>   drivers/vdpa/Kconfig                 |   7 ++
>   drivers/vdpa/vdpa_sim/Makefile       |   1 +
>   3 files changed, 153 insertions(+)
>   create mode 100644 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> new file mode 100644
> index 000000000000..999f9ca0b628
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -0,0 +1,145 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VDPA simulator for block device.
> + *
> + * Copyright (c) 2020, Mellanox Technologies. All rights reserved.

I guess we can change the copyright from Mellanox to:

Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.

Thanks.

