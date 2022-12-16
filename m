Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8337264ECB4
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 15:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiLPOMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 09:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiLPOMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 09:12:18 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2065.outbound.protection.outlook.com [40.107.101.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2461811441
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 06:12:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gdqn073QxM6BEVHJbBSS2g8F4Gv2JO7tXFI++Wi37yCCiEzS0MfbYfRNpMsnasMfkryLCIJPme9F7qTFRM2Rg4UCUlzdL9Fb58z4JmGaV7+wMrtPs0MEp1OYnG01YzWck32bDSrdlcCE2HMcPKbQw+m0facUnjp3CGMU2K0KUJIxzVb0Lqn6OQQ6+dVSR1ZiXzl4yqUtk8i4Rj+bE/VVSQ7CBa+QOcBaws/0FrVb002pYKFVZwH65tprsiaWBgoxMZqLjOS6Sj4ewCpHOsCLyayWzd2pRrlw1L7urVxvki3bLXi+pk3OzAEZ2zlgtw9txXDAfJrKm3MqpMQxvhpdFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MU34L5xM5o8qJQbn0uCqT8rP7mFPRX+ZGPCfxqULJPY=;
 b=DerwPqSqsRmErKmyJasLL7ydyKSnSsme+cuVQ6VLA1g6TWB4WLh8bua1X3GSp2XiLfOepEN6tNmNdIkpsYKT26xl5hrsaGkAx1mjFfI8vV6v2jTVROBP9dz8WoaGPkcN0WApjwBCHkOmViy/NABQ8vPVta8xtkbOqn644igRkzlNluiNsI9vLuu6S2wuEFmQt2eFZhdpLmFOr7iAPS5EJNxUe2RttP7HtWeW0pMjkMxkk0G0etEWZcdlFcpycFjJ0kVkDvB9BLRpMC4u1GEh0lDFRee52PYbGHMNg0LMqFE4kdbsPmV0+eqsfTabaBGRP+gA/+42O//NXWsoMZ3W5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MU34L5xM5o8qJQbn0uCqT8rP7mFPRX+ZGPCfxqULJPY=;
 b=l6kB+LOYK8QgNwi6BeQ0jYnamSw/jfgu9vEsxntktK0jqpXdv7rEMCOc6CBC+/ZlLEj14CjyAK0l2Bi+K5PPrf4etSzUjLP/ykg8xjCAjmrUI0K7sGj2uRi47U4oGNHn3iA4E4msPtChF/o+aCnUR1gQ3C2J4+hvUgXG2Nyh4ZMRpmAlaFTyOcJ5Xk3KYmrvh7OEy62mfXbmRwprnJO84LX0iBO05FJVaITk3jaMZ7QwG1yBhguh+1lEhGub3jgAQvZieLATMhjBBbUZCG0W3XK9ma+DCUojp8W9Aj/qt/sK3U3zySmS450hiMY2uYu1MzC6dmkKhDuqbwfmnPXAcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by DS0PR12MB6438.namprd12.prod.outlook.com (2603:10b6:8:ca::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Fri, 16 Dec
 2022 14:12:14 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::463f:4cb7:f39a:c4da]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::463f:4cb7:f39a:c4da%9]) with mapi id 15.20.5924.012; Fri, 16 Dec 2022
 14:12:14 +0000
Date:   Fri, 16 Dec 2022 10:12:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V5 4/7] vfio/type1: restore locked_vm
Message-ID: <Y5x8vdzF6c0ibJx7@nvidia.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
 <1671141424-81853-5-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1671141424-81853-5-git-send-email-steven.sistare@oracle.com>
X-ClientProxiedBy: MN2PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:208:234::21) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|DS0PR12MB6438:EE_
X-MS-Office365-Filtering-Correlation-Id: ea77fb50-e0a1-4b16-acc1-08dadf6f8833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: My6nyQdCdP+V4TUUQo5IAl7U5QbYUwNIz+Ixq/LUJQXW04/T7xqEe0uhpZxtlSvoROMnmFzv+bZrPBwKiBpSCgvH5EhFJToRr+jrLBk9bxqeyJz43sNnlhaE0QDVj3dkiUhXulGVpO5uddLzCWG188DCj8opiy9SuoOYCdRtyoRzOwTPtuXL0EtHXfCFG6T8MuXXHvBLRhe8uGfsnsM9k+t43OdS/Ox6scbAtmjnew4IUVnGg2sEQY3TfomC+oQ8cuFQ5ExTdVK1KU4iWf7qcjdCkqr+D4zQA9NuENF+LCHCJ57cpBM+HpKvl3n2le94YULmgF3kWzbpIfVWGzQW1xdejqhsqCqRFUfgxSGOW8ENNU2IgGV36rIL6OtP9eYnVj0D9eVmKnF+CYLX5FX6oZh91eE9M5j99IxpTl2xoUqMR5t8eLPeqdEp90/gEh50NvcoEybjaTABaMesvDo5t899W+fPDWcnXKd+mp6MLFyGnCeocmrqZ2oLKvrSMJk54NSWwlm8CJoHnDPgR1rXmwsa4pXcrHX3xGR7hvAwq4MBuhlwVhkz7jN3CHayaUnT96f5SGUoArMnxCKbQfahgAPbjuSNHyanL47CdW8cnyrhrlF+69uTQeC7u23Hvk6TnGjt0VaJDaqNTNShPCw1oA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199015)(6506007)(6486002)(26005)(6512007)(38100700002)(478600001)(316002)(186003)(54906003)(6916009)(41300700001)(8936002)(5660300002)(83380400001)(2616005)(2906002)(8676002)(66946007)(4326008)(36756003)(66476007)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3X/unmREOqUa2a8htZ7rBK/rBOR1oN65ukyrm7HCX4zVWeQg8I4IhzelvGnQ?=
 =?us-ascii?Q?xvdfaCZiw87LLq96W+vIoo4EKBEfwUdl2B7sW2vXb55L7/k+LdggImcqKM6a?=
 =?us-ascii?Q?+yvVnJC3GDmlxnumV+IMc3lsYBVpGOLj11iZm2kZRiRUecrz5ZqJwt8oQIA4?=
 =?us-ascii?Q?WeMj/gmamDLkBX7RLWL6NzQ5EB0LDdjNOe5mHlLXaaxzjp6fXkYu2lhUJpDX?=
 =?us-ascii?Q?VeY4C42pF2+blOdq6IE/tNeFMY60PlF1fecf1isdcZ1bZnrTQnj0lvrdmfdA?=
 =?us-ascii?Q?B5UE+nlhV7t7mriq96+7tb8jvK7gjclPlCWDPiY6UtFZdeM8ocF4TlH4JRbs?=
 =?us-ascii?Q?7X8ZZR4/dsEy2q9w8acNiDHDaccPzdJETiouiji02Z4+j7Tx0EAERIAfTMZE?=
 =?us-ascii?Q?TydPEdqUIXd/pR0ywNMbSC/qfCCANDy7wYQqiH/5N/H0DkNHSA7vuudWwuP0?=
 =?us-ascii?Q?Asz6pGec2ueH3ooam5gjuLyFe+AffuUBrl6e8onnrAH3SOcXEge/hc/P67BF?=
 =?us-ascii?Q?CHYFa2xGibCiLOM7fzMm+DJNYiIRw60DA9w2yB6E9S/OAzLsJbS6g8SYsksX?=
 =?us-ascii?Q?5MVNJcSQ/kZU+PSKDiPOXkGKKMf9JxR9zTR8saC9UmnWnYv7OFVQ8Tyud0ML?=
 =?us-ascii?Q?1sZLGUE3AOYlwfVuVS///NmFgk4Yutw8eP99o8nwY+US5IUQH148YozlITfT?=
 =?us-ascii?Q?1k13ngVN5Jjd8l/f6va/jbDhqWMcvicaSjvgc00gNwobCe60MUx5HKWp2l37?=
 =?us-ascii?Q?VUV6R+60qJbmBLCAPIC5x/nWKGkDQKd5nB0SZWzufvmVIuAN920gKETvpsoX?=
 =?us-ascii?Q?D2kUYNoMVxDHzfLnDK64lQqEacWmgfGRfb70S9+Whe3Njnrt3/A/zdLCDDgG?=
 =?us-ascii?Q?P3T3uFGbTlulO0xN+vqQ+IgufijiSO8OJE29HGg7J3+SMSyEzlZoz3FAA84S?=
 =?us-ascii?Q?pBrdYhbb4RZ8W8t1rltLtB9lFgfW/5eQpYL+MsoK2D+btc7Hi0E0F8oYYm4Y?=
 =?us-ascii?Q?MY2BTGgeT5EDSeXVU/smbp814MBp7q0nGlL1P0gWAb513aSDr8j0aySPJwEE?=
 =?us-ascii?Q?knsmpbWDKeGyD6Wlzq94pBPcLn4zQB0g17F+XqGtxPBN4+5EpnR7R18buUXw?=
 =?us-ascii?Q?e+fHyEzXH31o45ZEWM9o7h9mVif015SM/SbvgXJPTPGlfnP5DZZa6qIUYVbK?=
 =?us-ascii?Q?CJbbs7i5PtGSZ0hODeRiKmYqIHSPx5iIZGV1ixjN9/N4QckvDoZEllBzjgkn?=
 =?us-ascii?Q?BWCECxEjAuMuYojfcN9fMOZAcAQxRcUdS4oKFMU373Ars2FLPdlP6EVJgpME?=
 =?us-ascii?Q?bRN4lX1lt/MyrhkjelEU67ED0L36LfSg+bBdlgeY6NCSM21VBP4OM+f9PbZS?=
 =?us-ascii?Q?EM7PsxM/k307Crbr6vUy89WiGnaNRrhvXXsQy2S5w00aMtvxJRBdGY9RU0c5?=
 =?us-ascii?Q?QNhrSrFoLm8k58Ad1Z294V7d+k9Mv9cg9w6NwXgNOXRvpBuGHrEsvYs0Jhb2?=
 =?us-ascii?Q?ktVh4jS2VhRwN2tn9s5WoCpAE4mkhQsRfpyoYMdJIh5jyBnFSMfR5oQ6zcxu?=
 =?us-ascii?Q?9UaIfY89j8qwiDIaGiU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea77fb50-e0a1-4b16-acc1-08dadf6f8833
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 14:12:14.7657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gAd0FJdPI0tBHNp5V7R+F3B/VOiYfgub8sw+TPOsJ1AprCPu/+vaDWrPBJ/DUknT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6438
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 01:57:01PM -0800, Steve Sistare wrote:
> When a vfio container is preserved across exec or fork-exec, the new
> task's mm has a locked_vm count of 0.  After a dma vaddr is updated using
> VFIO_DMA_MAP_FLAG_VADDR, locked_vm remains 0, and the pinned memory does
> not count against the task's RLIMIT_MEMLOCK.
> 
> To restore the correct locked_vm count, when VFIO_DMA_MAP_FLAG_VADDR is
> used and the dma's mm has changed, add the mapping's pinned page count to
> the new mm->locked_vm, subject to the rlimit.  Now that mediated devices
> are excluded when using VFIO_UPDATE_VADDR, the amount of pinned memory
> equals the size of the mapping less the reserved page count.
> 
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index add87cd..70b52e9 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1588,6 +1588,38 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
>  	return list_empty(iova);
>  }
>  
> +static int vfio_change_dma_owner(struct vfio_dma *dma)
> +{
> +	struct task_struct *new_task = current->group_leader;
> +
> +	if (new_task->mm != dma->mm) {
> +		long npage = (dma->size >> PAGE_SHIFT) - dma->reserved_pages;
> +		bool new_lock_cap = capable(CAP_IPC_LOCK);
> +		int ret = mmap_write_lock_killable(new_task->mm);
> +
> +		if (ret)
> +			return ret;
> +
> +		ret = __account_locked_vm(new_task->mm, npage, true,
> +					  new_task, new_lock_cap);
> +		mmap_write_unlock(new_task->mm);
> +		if (ret)
> +			return ret;
> +
> +		vfio_lock_acct(dma, -npage, true);
> +		if (dma->task != new_task) {
> +			put_task_struct(dma->task);
> +			dma->task = get_task_struct(new_task);
> +		}
> +		mmdrop(dma->mm);
> +		dma->mm = new_task->mm;

This also should be current->mm not current->group_leader->mm

Jason
