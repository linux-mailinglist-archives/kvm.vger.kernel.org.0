Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23CF78BC41
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 02:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbjH2Asx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 20:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbjH2Asf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 20:48:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7253D19B;
        Mon, 28 Aug 2023 17:48:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNG3iVxiZtb/S8TeIC33NOy+l/8SDAjPzUoOK6MqDqAaafFmMiq7ILhtzPRkdtjLml+sFqAvcFOdYEiuG1BbBHhfgTF5hVu0+H6pAdzXmaxPqrzjtO3300SJ4B4QKtpDttxSceYNXm80qK6xI5I1B94qCSUVvo1f80qoZUskFLcxNjXmzpvLVSjN/lk42X2iu2g7+SCvuSlp7EprQz3V3s3Ys4UXYC0JuSGgQklnXa3zhJlwgZIJzVFv5go19naHCHUe6lHngw2oR75eEyr2Z/ZbMO2ZHm2txAV+QNC+mhjKzXMP0Y9O1HU1NENCIEZoTuTKgt470bbhUf2voh2HKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+/jsXUSE44tgg4ppRizeT0MQvDliSJAJJl/JqaAtwI=;
 b=FlaC+LYuc5HilbahFDbECVnl/FhVThz63fBoj++GIqbVm8E4Xk1XUGH822z6SZay45NOs1DqjjMNL+DtReLBV/zUDDUI2A57UwcJhotV18KrTPyCQMbOjAezfRTFo4NhjElOnWXePUE2BSaur16UGP68hgumT3NB9I8hJi7ObQR+AkYkW7VI8pgrsse0tsRQBbZLA4GyBEWcp6DRVROBbg7KHndWpmzIGFrZ2K2pVdVvn/4J67eFDkUXrC04BNfM8LZMTaZCEgVys4gv3jSM4BgK1Ita+Rj7GFdBZSXVZdHCMngzOlEsoRQ8G+cVsgim0LztXIIF8Qqz2jDqBXdQWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+/jsXUSE44tgg4ppRizeT0MQvDliSJAJJl/JqaAtwI=;
 b=E80iUoIlRH7lODPWvL9PUIpk6UD7Axbco++YLYBhWv5BZKmlx5OELLaOfyzkcfD2kCFD8W+24ec6QbHl1sxNvpSYvpccmvC58w6I5ABat4HbbFoIeTmx80rUijG6LyoBx2zBffebXq6tYSYWaMgd0xUZbjVHxojbSRg5lMrwtJM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by MW4PR12MB5667.namprd12.prod.outlook.com (2603:10b6:303:18a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.35; Tue, 29 Aug
 2023 00:48:11 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6699.034; Tue, 29 Aug 2023
 00:48:11 +0000
Message-ID: <2c712626-c9e1-9cf1-b38c-a1ffda8620ec@amd.com>
Date:   Mon, 28 Aug 2023 17:48:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v14 1/2] vfio/migration: Add debugfs to live migration
 driver
To:     liulongfang <liulongfang@huawei.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        jonathan.cameron@huawei.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org
References: <20230826074325.48062-1-liulongfang@huawei.com>
 <20230826074325.48062-2-liulongfang@huawei.com>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230826074325.48062-2-liulongfang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::31) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|MW4PR12MB5667:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a2e5782-adf1-4e41-c1ee-08dba8299eaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DErmv9JjbDetAtiQhV8QlYaB8JPk/JypxjAUYwQrH1mNijiifM+UVn9uYmEP+7/sCvwBA0iTEg4YiWFAJN4tU03nbWL3UyY0yYkrD1IP3uG/LTw3pME/qKwvsi/DkhZeu9qgGj0fJEgw+fymNqVoNB1fiuMBkkzApdcgC0xerOdjLgUtfK/W79xNrkxxIVsArMu5tJ1V9UMXBZBLML09rnfSRWlS/zC47wlEWyBq0QHqr7PjlqmT7kuNRUd0BAaeFW2ytBPJaCBtVnQrsm13K4Gd9evWs3CDMKB7guXjvCf4YIMeXEmuzVPjCDdHxrboyw+K0HfOTbupgbpxXCZtUHa3QW5KEr/nWoipmSO0IiUdXnm8imVN65noMLOnvjVEKVJPxq0WsHPSj9R3U9i6fIIcuApMB6fEQ3zwVvcI6XFA2EDAyksqN6LBzkXkifgftZ9eDEXgFNgb9oM/Y1RhdUFYapbxLkC0j9veqhU5w5Q9ZE8lQynnJQgVeCQ2WXdhXXuU/cwV3srJmyOPEhOpp3wsQKYuFcLSHulypjn4FDctRt4IrqoSnL/fsGrFqTtr4EF12Yi3bsQSIeESbeOtqcJ8wRyBiAqv2m0yGIw0MwcJ4ih1hcIQRIguNmE8gX4Qi6qtTTGeYoWna9kGWbeCgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(396003)(136003)(346002)(186009)(1800799009)(451199024)(6512007)(6666004)(6486002)(6506007)(53546011)(83380400001)(478600001)(26005)(2906002)(2616005)(316002)(66476007)(66946007)(41300700001)(66556008)(4326008)(5660300002)(8936002)(8676002)(36756003)(38100700002)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1RrZFYwZ0xUS0xBbC81RkhSTEMvL3JUQVRyMUgrcFRocHhWbnM1T0xoVUNV?=
 =?utf-8?B?Wlo1N09MS0lpdmE1ZWhUcUVwTjFOcm04dzNRdGMvZ0VJemYxZTRBNVpUWStK?=
 =?utf-8?B?b3ZCUE9MRE1lMnNKRHRUcUpmZkx6Z05DczhmOUxQa0hVQ3RoVDZoZGM1RGZK?=
 =?utf-8?B?Y0IrSDdlaTU5ZytJenRNR2t6MVJNSERMZHZKc3dCMjU4VDAybGI0U3FJVnB6?=
 =?utf-8?B?S3lTR1RLNEl1dTlrdU05Y0Q2cEFhdEU5NkZZbjVHR3JsaTNOOVA0RnBjV2hL?=
 =?utf-8?B?NS9CRzNsaGhxelk4QnppK1BFUXJNN1hidWdkTHJlbjBWZDJwZDdGQjhCMldO?=
 =?utf-8?B?d21qQW9sdFY1YUN3RjB5NDNUZnlUeU5YVnJwOENVZS9VT0NSTXFoSHZjNkcw?=
 =?utf-8?B?NXk3TlhFNGppcnhPZk5WSHQvbFdHM3cyQ1kxTnFTRHpkNnJDUVZRZ2dGYUpq?=
 =?utf-8?B?N2tMcGtoajZzRzJ1OVBhK1BkVFhScUxKSW9jb2Z3Q2c4OTk2YWV0ajIwVU5W?=
 =?utf-8?B?QjYwZ01qb0ExcXQ0bVhjK2tzZVUrUHRBNDVPOXhiTm5QN3B3R0hvVjFhQWxp?=
 =?utf-8?B?a3lpUTlJSmxWOHNoQWJOZmszcGNoWGtVdlIrZHgwYXlObnR0WS9rL0d4S0Fq?=
 =?utf-8?B?TEU0SzhONFA4Yll1c2hCY1lhVk1wT1luZW9JSWhWYnliNUFCZDh5S0djWTNX?=
 =?utf-8?B?Y0d5Snp0QkdYcmZjRlFBSkNPYWQ1U3Z3MDE5VWtzZHlhWmxnbGtvSk9WakN2?=
 =?utf-8?B?VEFLKzVtNVlHVzZ0aThlTzhjdjhCM2Q0aWVVU3AzN1VudDhQTEVjT1d4VllQ?=
 =?utf-8?B?QmdTTStpeU8xMjB2dEtrLzVQN1EzMmxMR0RQajF3QXVoOFpWOVlpUW9NelZX?=
 =?utf-8?B?cEJyZzR0SE5BZHBpbWVWSDY0Nzh1N2hsQjI4amlUUUV4Yi9HZUFYTXhLeWRY?=
 =?utf-8?B?Tmw1OEIxZXpaS1M3VTJjdjRhYUhrQXEvU3pjYm5jcnNXekhzSmxxa3YrUUJl?=
 =?utf-8?B?cTM3N2ovQlg1OVdCck8rWjdOUWZNTS9XR1dtLzg0WG9rZGxMbHErU2xMa2Q2?=
 =?utf-8?B?OFJTQnVkL1dNdEYvaHpldFpUenRXMnE2UHJteHg3ZE1nT0JPUXJjWmZHTk9x?=
 =?utf-8?B?a0FXUlV2S1creERlV241YnAvM1c4Qno5VGQ4eTB5WXhTQzYzY29lR0VhUTBt?=
 =?utf-8?B?MVZza0FOaWtOYWM4U0RTV2pvOXY0QnVxSG94MnpHY1IxZWY0dmRqTjUvbjcx?=
 =?utf-8?B?Tk5hb09UVnZmMndLb09PTU1VTGcrKzRNVmYwb3RHK1pVVENXSzJkMEJXMWVi?=
 =?utf-8?B?UzErQ0hrVEFya2VmR3hGUTRTSzJsYlFqQUdZZUhudndNTW9oWmkwenRkcUFx?=
 =?utf-8?B?ZUNxWjB6bk1ycjYwSkZ6VnRSU090NlZsb29zbGVtQnlxVk1xVjFqQXZsd0x4?=
 =?utf-8?B?bTBmaVAzK2F6NXF4NnFHN0E2M3hVaG5jaFdQdHlKNjgxSzNJSGFmOXJsb2h4?=
 =?utf-8?B?NVJEMGtFMkFxdlBKdkx2bkJ6SWpZeWxLNjZqRS96VFZvOXhzQW5GMG5nRWYr?=
 =?utf-8?B?T2NWbk4wdFlucVZDNlRqMGM2YW1yU3J5WWJkb2pFSy9oTUlGdXFoUVoycFZI?=
 =?utf-8?B?SVRROVlabUpMdS9QNHBuUEpCbVd2UUNFS0ZoblpEdG9Lem9NdStySUpPMVVx?=
 =?utf-8?B?ZUtEd3U5QkFZWTdGU2JsUTBycnF5UDREOEdLOHZybnRzYnpieFFOSVlGanc3?=
 =?utf-8?B?eEVKeWNKRit0Y2VGZEFQdVFOdjdXZE5oa2RWTTJTcE1JdFZhRXpxalpTUXlH?=
 =?utf-8?B?S1VTWGZWQXhBejA1SkxWdUdkazAreTVxaTJpc2RLNys0Y3RLUVFtUWNMTU1X?=
 =?utf-8?B?N011Zk45VTBDbmV2T0I0RWFLYURuRDZpSE1oNWNmY2E2aldzeUtTL2RIak5O?=
 =?utf-8?B?M01vejBLT3hhOWprNEowQXV5SWFCRWVxSEhBUERWMHA4WjlOUEtnY2F5Z01u?=
 =?utf-8?B?cDMwa09OV0tRbDNyckplNW1HMjh6SzI0dTRjQTh1bkllUEdNSjdrZ2dwc2l0?=
 =?utf-8?B?VFhvRnQ2UUF3R2QvUmk0MHJjWHhzUVd0eE8rWGlqaFZJZld2VGdIRVBxaVFN?=
 =?utf-8?Q?z89GaQwS4taUfCBf4qQJ+lisX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2e5782-adf1-4e41-c1ee-08dba8299eaa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2023 00:48:11.3587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6o1LNCmClz2NUcuzU6dovvrCPzDqfX84TUmzEk7g34H1Hgs22R1tMfvDUZakMUx6q7B8b3ORiIC0BIc1sQlaSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5667
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/2023 12:43 AM, liulongfang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> From: Longfang Liu <liulongfang@huawei.com>
> 
> There are multiple devices, software and operational steps involved
> in the process of live migration. An error occurred on any node may
> cause the live migration operation to fail.
> This complex process makes it very difficult to locate and analyze
> the cause when the function fails.
> 
> In order to quickly locate the cause of the problem when the
> live migration fails, I added a set of debugfs to the vfio
> live migration driver.
> 
>      +-------------------------------------------+
>      |                                           |
>      |                                           |
>      |                  QEMU                     |
>      |                                           |
>      |                                           |
>      +---+----------------------------+----------+
>          |      ^                     |      ^
>          |      |                     |      |
>          |      |                     |      |
>          v      |                     v      |
>       +---------+--+               +---------+--+
>       |src vfio_dev|               |dst vfio_dev|
>       +--+---------+               +--+---------+
>          |      ^                     |      ^
>          |      |                     |      |
>          v      |                     |      |
>     +-----------+----+           +-----------+----+
>     |src dev debugfs |           |dst dev debugfs |
>     +----------------+           +----------------+
> 
> The entire debugfs directory will be based on the definition of
> the CONFIG_DEBUG_FS macro. If this macro is not enabled, the
> interfaces in vfio.h will be empty definitions, and the creation
> and initialization of the debugfs directory will not be executed.
> 
>     vfio
>      |
>      +---<dev_name1>
>      |    +---migration
>      |        +--state
>      |
>      +---<dev_name2>
>           +---migration
>               +--state
> 
> debugfs will create a public root directory "vfio" file.
> then create a dev_name() file for each live migration device.
> First, create a unified state acquisition file of "migration"
> in this device directory.
> Then, create a public live migration state lookup file "state"
> Finally, create a directory file based on the device type,
> and then create the device's own debugging files under
> this directory file.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>   drivers/vfio/Makefile       |  1 +
>   drivers/vfio/vfio.h         | 14 +++++++
>   drivers/vfio/vfio_debugfs.c | 80 +++++++++++++++++++++++++++++++++++++
>   drivers/vfio/vfio_main.c    |  5 ++-
>   include/linux/vfio.h        |  7 ++++
>   5 files changed, 106 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/vfio/vfio_debugfs.c
> 
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index c82ea032d352..7934ac829989 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -8,6 +8,7 @@ vfio-$(CONFIG_VFIO_GROUP) += group.o
>   vfio-$(CONFIG_IOMMUFD) += iommufd.o
>   vfio-$(CONFIG_VFIO_CONTAINER) += container.o
>   vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> +vfio-$(CONFIG_DEBUG_FS) += vfio_debugfs.o
> 
>   obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>   obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 307e3f29b527..09b00757d0bb 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -448,4 +448,18 @@ static inline void vfio_device_put_kvm(struct vfio_device *device)
>   }
>   #endif
> 
> +#ifdef CONFIG_DEBUG_FS
> +void vfio_debugfs_create_root(void);
> +void vfio_debugfs_remove_root(void);
> +
> +void vfio_device_debugfs_init(struct vfio_device *vdev);
> +void vfio_device_debugfs_exit(struct vfio_device *vdev);
> +#else
> +static inline void vfio_debugfs_create_root(void) { }
> +static inline void vfio_debugfs_remove_root(void) { }
> +
> +static inline void vfio_device_debugfs_init(struct vfio_device *vdev) { }
> +static inline void vfio_device_debugfs_exit(struct vfio_device *vdev) { }
> +#endif /* CONFIG_DEBUG_FS */
> +
>   #endif
> diff --git a/drivers/vfio/vfio_debugfs.c b/drivers/vfio/vfio_debugfs.c
> new file mode 100644
> index 000000000000..d903293ed9c7
> --- /dev/null
> +++ b/drivers/vfio/vfio_debugfs.c
> @@ -0,0 +1,80 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, HiSilicon Ltd.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/vfio.h>
> +#include "vfio.h"
> +
> +static struct dentry *vfio_debugfs_root;
> +
> +static int vfio_device_state_read(struct seq_file *seq, void *data)
> +{
> +       struct device *vf_dev = seq->private;
> +       struct vfio_device *vdev = container_of(vf_dev, struct vfio_device, device);
> +       enum vfio_device_mig_state state;
> +       int ret;
> +
> +       ret = vdev->mig_ops->migration_get_state(vdev, &state);
> +       if (ret)
> +               return -EINVAL;
> +
> +       switch (state) {
> +       case VFIO_DEVICE_STATE_RUNNING:
> +               seq_printf(seq, "%s\n", "RUNNING");
> +               break;
> +       case VFIO_DEVICE_STATE_STOP_COPY:
> +               seq_printf(seq, "%s\n", "STOP_COPY");
> +               break;
> +       case VFIO_DEVICE_STATE_STOP:
> +               seq_printf(seq, "%s\n", "STOP");
> +               break;
> +       case VFIO_DEVICE_STATE_RESUMING:
> +               seq_printf(seq, "%s\n", "RESUMING");
> +               break;
> +       case VFIO_DEVICE_STATE_RUNNING_P2P:
> +               seq_printf(seq, "%s\n", "RESUMING_P2P");

Should this be "RUNNING_P2P" here in the seq_printf() statement?

> +               break;
> +       case VFIO_DEVICE_STATE_ERROR:
> +               seq_printf(seq, "%s\n", "ERROR");
> +               break;
> +       default:
> +               seq_printf(seq, "%s\n", "Invalid");
> +       }
> +
> +       return 0;
> +}
> +
> +void vfio_device_debugfs_init(struct vfio_device *vdev)
> +{
> +       struct dentry *vfio_dev_migration = NULL;
> +       struct device *dev = &vdev->device;
> +
> +       vdev->debug_root = debugfs_create_dir(dev_name(vdev->dev), vfio_debugfs_root);
> +
> +       if (vdev->mig_ops) {
> +               vfio_dev_migration = debugfs_create_dir("migration", vdev->debug_root);
> +               debugfs_create_devm_seqfile(dev, "state", vfio_dev_migration,
> +                                         vfio_device_state_read);
> +       }
> +}
> +
> +void vfio_device_debugfs_exit(struct vfio_device *vdev)
> +{
> +       debugfs_remove_recursive(vdev->debug_root);
> +}
> +
> +void vfio_debugfs_create_root(void)
> +{
> +       vfio_debugfs_root = debugfs_create_dir("vfio", NULL);
> +}
> +
> +void vfio_debugfs_remove_root(void)
> +{
> +       debugfs_remove_recursive(vfio_debugfs_root);
> +       vfio_debugfs_root = NULL;
> +}
> +
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index cfad824d9aa2..8a7456f89842 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -309,7 +309,7 @@ static int __vfio_register_dev(struct vfio_device *device,
> 
>          /* Refcounting can't start until the driver calls register */
>          refcount_set(&device->refcount, 1);
> -
> +       vfio_device_debugfs_init(device);
>          vfio_device_group_register(device);
> 
>          return 0;
> @@ -378,6 +378,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>                  }
>          }
> 
> +       vfio_device_debugfs_exit(device);
>          /* Balances vfio_device_set_group in register path */
>          vfio_device_remove_group(device);
>   }
> @@ -1662,6 +1663,7 @@ static int __init vfio_init(void)
>          if (ret)
>                  goto err_alloc_dev_chrdev;
> 
> +       vfio_debugfs_create_root();
>          pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>          return 0;
> 
> @@ -1684,6 +1686,7 @@ static void __exit vfio_cleanup(void)
>          vfio_virqfd_exit();
>          vfio_group_cleanup();
>          xa_destroy(&vfio_device_set_xa);
> +       vfio_debugfs_remove_root();
>   }
> 
>   module_init(vfio_init);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 454e9295970c..769d7af86225 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -69,6 +69,13 @@ struct vfio_device {
>          u8 iommufd_attached:1;
>   #endif
>          u8 cdev_opened:1;
> +#ifdef CONFIG_DEBUG_FS
> +       /*
> +        * debug_root is a static property of the vfio_device
> +        * which must be set prior to registering the vfio_device.
> +        */
> +       struct dentry *debug_root;
> +#endif
>   };
> 
>   /**
> --
> 2.24.0
> 
