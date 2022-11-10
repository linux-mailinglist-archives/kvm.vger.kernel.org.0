Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A00162401F
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 11:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiKJKi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 05:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiKJKim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 05:38:42 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852CD1A225
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 02:38:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0Z2Dvj/UvcgWuZVn3jCtdtV/7ziXp7UAg79xPlQIYOM8FyYZNMSVPOK4rGr2BUlMMRRjVEA35yb6EBplqLOccOxHistWJGI2BPHwOXYbvboMSlHgSV14l3S0HjRvxEDV7gvaBhpygLcRTM+zjNUu6VlAOJ/fDYEIAoZ4MUPRPo2Qeyy5fjygVp3HBiMd1Zv/Hot++e31pOzej3kGVkLBXRUJ45Mw7RUiDoCcWHzGuqKdab8Uug/P0GTx0VG7XgABGv4V2MKWwwzKQjw93VPdzLnRCdSiqQ+fEzw5bbAzIylAx1zb4qolhbyF1kJVfX5sw5uaclFIlFpJGrLK5/tYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WorFrEnuKPXvkmDHBkRao2kczitdQDBkV4YuEsuDEgM=;
 b=O3AWOhK7+d0JQMrtZQt/puzPoXJgHNoAlNl/MsBHGxfa5Bg6K8zLu8wZzolgx4WKFlu1xiHEgiyN1Jk65Tz8rRj9iUZN95See/KLIhxEXZGC0RcHlPKqgXYARKQoqnlvX43Dxd9gZCefZsjBciJB/PPpZvtXHae1zonV8w7iVI8KWfvHVwGDUCPLH5viQ7Y3HVOqzn12AjJbNI49u16YnmX3jMMJeQGv/Yn1rV/t1MmcNYr9qLjSw9wuBhfQ6SydWgZtHKO1gv9g4ddInQmKHkYIZp8KGdO1EoyOzGwFPSrD6czAtNFwx61qyZYrxKT9qrQe79Obf6y3PyN+E7AvpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WorFrEnuKPXvkmDHBkRao2kczitdQDBkV4YuEsuDEgM=;
 b=Xyc1B0fWuRJCPRwN/BZHEphA29MTM83xJQHCBeNvyEHvHa99wZY0QnPhCBa1795Kuz8V0cE11k+nqc9LGncE49pfn0EkAVzCijawDz0TZCzA+tNEW3s9LFXD4YuLzeJraj7agPlNiHd5lNBKoNbXC+HUl7pESX4eqHyZPA1zntptfwseRU7cuGarqdjl7J2e50F63kaPHIf9oZtX1mi+OmogC7nzTRYNHqXyk2BAcQwIKBzLcULKAuMU+FwI59+5hGUczGL5DjpUbk5Sv/0VbS8/SRXfXkadyiV8RGihZysaK0Ag5GUuynamaM1oSNqWYOzaWAREUcdQ6TeknBgW/Q==
Received: from MW2PR16CA0008.namprd16.prod.outlook.com (2603:10b6:907::21) by
 SN7PR12MB7156.namprd12.prod.outlook.com (2603:10b6:806:2a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 10:38:36 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::96) by MW2PR16CA0008.outlook.office365.com
 (2603:10b6:907::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13 via Frontend
 Transport; Thu, 10 Nov 2022 10:38:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Thu, 10 Nov 2022 10:38:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 10 Nov
 2022 02:38:20 -0800
Received: from [172.27.0.199] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 10 Nov
 2022 02:38:17 -0800
Message-ID: <02ee0ef4-4848-a5cc-37fd-f73d33b161d8@nvidia.com>
Date:   Thu, 10 Nov 2022 12:38:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH vfio 05/13] vfio/mlx5: Enforce a single SAVE command at a
 time
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <shayd@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
 <20221106174630.25909-6-yishaih@nvidia.com> <Y2vrucy8NNG2856a@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <Y2vrucy8NNG2856a@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT051:EE_|SN7PR12MB7156:EE_
X-MS-Office365-Filtering-Correlation-Id: e5e5ddce-18e3-41a9-7bce-08dac307b870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8blVJ716ONez/gdq2b7Is6ismOrBozeesoouJrkGiNkU+zMBLMkouv5iJ+YKZsgK6nsz2LybIZFXDjN+xppf2CFp36Zz+zUDK7lZwZ23r5ZLheqlFseQQmh5oToEfPfRefvcD+JtzZrRgRvNiMsY+QrCS9g/puM1EFdaWk4Xi/C1YLou+HSr1bGF2jhsI9L9P5Lx4sR/54rhlWE+N/K1mhOAfg7TDYwuRzOUFuIb94yXn13JBpTtQlJyH1ER4GLXc1us3TkStZSUHnc3BqUhlcXA4ZX/wzsXlp4yupjH5gn8CSRv5JX4ZpdiQXjzKx7lorHiX2Dn/1jSXfZ+spexzLNZFfsVXi9Y4DglWl4xe+nwnm0qadSG602IJFBuXaybJZJoNJl6OweUIVKlPEFt3BFWcfOT5lB7Po6+0yS8MwZXxy62CBPPA/514Dd90ywQMbFuMxpQJXvPZmUGN6FpY0Xf1oaV/GdpIxr+kURnmD8ehChk9FxwNmwRKUJ0dP7HuVKXhcqNLTJBvgkAnbcyop8ouXMxucChc7Ga/xx9l6v/VxnrWi2mOV5SazitW7nvF+MIc7PL1Esc3td50NzQyCTf0Hi4NB3eSLMYa2J8/QlgX69/V3h2X7vT6RiyJlrvmm0aGYbNqzU29/rGEi774EjzlWJF4kGBFHrP2pMNRV0nTimEiOuAWyqEadPTOSbxl05re6OyT3D1uRtn3y8jpzlhKiI1AMsf6bhmXNiqX6hqlKhL/HtXoI/t8OI8HcRZfS2MkjE9iYAfX+48lOL8R1Hgn/WiXZ4/7Atb88qcRc=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(7636003)(86362001)(70206006)(82740400003)(31696002)(40460700003)(356005)(54906003)(41300700001)(36860700001)(8936002)(5660300002)(16576012)(6862004)(316002)(37006003)(70586007)(6636002)(4326008)(8676002)(2616005)(426003)(82310400005)(2906002)(47076005)(336012)(16526019)(186003)(40480700001)(83380400001)(26005)(478600001)(53546011)(36756003)(31686004)(66899015)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 10:38:35.1350
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e5ddce-18e3-41a9-7bce-08dac307b870
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7156
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/2022 20:04, Jason Gunthorpe wrote:
> On Sun, Nov 06, 2022 at 07:46:22PM +0200, Yishai Hadas wrote:
>> Enforce a single SAVE command at a time.
>>
>> As the SAVE command is an asynchronous one, we must enforce running only
>> a single command at a time.
>>
>> This will preserve ordering between multiple calls and protect from
>> races on the migration file data structure.
>>
>> This is a must for the next patches from the series where as part of
>> PRE_COPY we may have multiple images to be saved and multiple SAVE
>> commands may be issued from different flows.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/vfio/pci/mlx5/cmd.c  | 5 +++++
>>   drivers/vfio/pci/mlx5/cmd.h  | 2 ++
>>   drivers/vfio/pci/mlx5/main.c | 1 +
>>   3 files changed, 8 insertions(+)
> This should just use a 'counting completion' instead of open coding
> one.


Makes sense, will change accordingly as part of V1.

Yishai

>
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index 0848bc905d3e..b9ed2f1c8689 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -281,6 +281,8 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
>>   	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
>>   	mlx5_core_dealloc_pd(mdev, async_data->pdn);
>>   	kvfree(async_data->out);
>> +	migf->save_cb_active = false;
>> +	wake_up(&migf->save_wait);
> complete()
>
>>   	fput(migf->filp);
>>   }
>>   
>> @@ -321,6 +323,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>>   		return -ENOTCONN;
>>   
>>   	mdev = mvdev->mdev;
>> +	wait_event(migf->save_wait, !migf->save_cb_active);
> wait_for_completion_interruptible()
>
>>   	err = mlx5_core_alloc_pd(mdev, &pdn);
>>   	if (err)
>>   		return err;
>> @@ -353,6 +356,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>>   	get_file(migf->filp);
>>   	async_data->mkey = mkey;
>>   	async_data->pdn = pdn;
>> +	migf->save_cb_active = true;
>>   	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
>>   			       async_data->out,
>>   			       out_size, mlx5vf_save_callback,
>> @@ -371,6 +375,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>>   	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
>>   err_dma_map:
>>   	mlx5_core_dealloc_pd(mdev, pdn);
>> +	migf->save_cb_active = false;
> complete()
>
>>   	return err;
>>   }
>>   
>> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
>> index 921d5720a1e5..b1c5dd2ff144 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.h
>> +++ b/drivers/vfio/pci/mlx5/cmd.h
>> @@ -26,6 +26,7 @@ struct mlx5_vf_migration_file {
>>   	struct mutex lock;
>>   	u8 disabled:1;
>>   	u8 is_err:1;
>> +	u8 save_cb_active:1;
>>   
>>   	struct sg_append_table table;
>>   	size_t total_length;
>> @@ -37,6 +38,7 @@ struct mlx5_vf_migration_file {
>>   	unsigned long last_offset;
>>   	struct mlx5vf_pci_core_device *mvdev;
>>   	wait_queue_head_t poll_wait;
>> +	wait_queue_head_t save_wait;
>>   	struct mlx5_async_ctx async_ctx;
>>   	struct mlx5vf_async_data async_data;
>>   };
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index 4c7a39ffd247..5da278f3c31c 100644
>> --- a/drivers/vfio/pci/mlx5/main.c
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -245,6 +245,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
>>   	stream_open(migf->filp->f_inode, migf->filp);
>>   	mutex_init(&migf->lock);
>>   	init_waitqueue_head(&migf->poll_wait);
>> +	init_waitqueue_head(&migf->save_wait);
> init_completion()
> complete()
>
> Jason


