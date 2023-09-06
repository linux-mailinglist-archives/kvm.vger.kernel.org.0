Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1607938CF
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 11:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjIFJst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 05:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbjIFJss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 05:48:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A68CFA;
        Wed,  6 Sep 2023 02:48:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TukSxJi1UuiJ3PZM0dahEVLXEfoFIW0DjKjrj0FjWQWnr3arN4JH5Avwy3qvFBM3X3wkRsw3WNzAEywggST1PmsiyrnfHxj/yfkQmjHFkqGreTT96OepclcSW3BPWvCkYijyxk4RNAgLzxMgTNEX3zei/+LFPdIDJAnguhx6qIMvWmZqzhU8darZfez5duy6twxHIwyIOwBunkPwhMlgApF3fOk4XNSiOYGUhw/SG0Vpi2SAF1ZQEd0DYNoGQxwP7+9p2fmXitHSPRbeSUjYQez4szClYGD7ANEasVQf6qk2AyYMMSN3x3PKDpbwRjvj1nbV9qVndiV6V2F/GzB5DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tK/P2b2h/QqOVjOZcTR4yHVwpND2KJCrHRWZx5oZf6s=;
 b=B+UXjXFSRnF3I6CdWXeOT2ivVrz4UgMaTCp0VR4IXJGYYMFBf6lfZ8rL/67RGEkJnYBTlrxjiQwNKdGRTfpoFugQEWtxkO8Wi4g47Xjz3Axo6ISvsXop5fMy3L6fPoqh2bJcs+TJKkJeig5iPYK/f9j0sagWJE3ntMOzaq64BLd/GF+8IBNzPfq5/GVzS+P3ev59cNt4gfo4lSj6znakXsqxYYnbfbXEEvXV3fYYFOxARIZFIMLFxjZ4tU9Yjctz8+E/uXu/YhvZhTXp4kcEbb6KQd6YPWfycBfHNIixVxVI1RKz2db/Oj4Km/772HuPYQQCQvqHVz85TyxBRUfN9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kaod.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tK/P2b2h/QqOVjOZcTR4yHVwpND2KJCrHRWZx5oZf6s=;
 b=VQHb8JX7TV1Hw0GT2vHfZxaXtGLatogCxupCU3hayp6T9Nr/V30K9XFSgQd6t+8Rfpo60Vg7yodZZ+hmsQ300cMciPnFUffyZZ8MQ7lIKnrX7quluAwi6s832sgz4AVMBl+hvthIKBb3CSI8GoctALM9wDxBhe7/gzfhhoWqDVhR5VlsqIvqyiaQzdlva4v5e3AvkuaFG+zRGgR5RJ29wtavBwn9Hvs/zpe8sfT+czE8FZD16EtVebXqGpL9dyTlpuOkLCt7PPk5gO8B3dT/u0plTiB+EyWKBwcDyiZZCTlerUk4U8Q1jRoG3wAgIzylis0J4dohgJ3tzSG0ZJgjgQ==
Received: from CY5PR04CA0024.namprd04.prod.outlook.com (2603:10b6:930:1e::15)
 by MW5PR12MB5599.namprd12.prod.outlook.com (2603:10b6:303:194::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Wed, 6 Sep
 2023 09:48:29 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:930:1e:cafe::19) by CY5PR04CA0024.outlook.office365.com
 (2603:10b6:930:1e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34 via Frontend
 Transport; Wed, 6 Sep 2023 09:48:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6768.25 via Frontend Transport; Wed, 6 Sep 2023 09:48:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 6 Sep 2023
 02:48:18 -0700
Received: from [172.27.14.125] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 6 Sep 2023
 02:48:13 -0700
Message-ID: <1b60d2d3-e8b3-b47e-ad4b-e157bcd4bf18@nvidia.com>
Date:   Wed, 6 Sep 2023 12:48:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH V7 vfio 07/10] vfio/mlx5: Create and destroy page tracker
 object
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        'Avihai Horon' <avihaih@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
 <20220908183448.195262-8-yishaih@nvidia.com>
 <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org>
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|MW5PR12MB5599:EE_
X-MS-Office365-Filtering-Correlation-Id: 53cd6d07-a906-4273-83db-08dbaebe6cd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AmNweysRZQWIv4WjXr8GcjidF0MUqZ3G8xwJkpS64NpE6Lfs8m5t3lNSXSo27kpn8INJRnfgmC7iVMal328GjykHrS/b70BfoNvARg4PAJTASAaecpn8oB7cZ19qOvfS7ik7VPQ9kB1Xonr1BhRnw1kHgS4DDlS22D+8UwwS2u8i38+BsfcPQmTXNKKSjvVa09QVngA58dyNzxrNXS3xs7skr6jAXgwsOiAw5rcCCdfBd7rl7bMhuCgYChluR+IOhB/Jt5uiNaFgrM8r0cza/EhCGvpp95YN4o6QWyJPSch/iPNXpok9+je+T3qCTSOhtsX9gigizxZCZNKn+Y4hmuTEUC3v4i5b8i7ElBqXBeYMH1FJkik1cemUUj0HpUPKrVziGpPLBO+9bI1+tSkrLp0uCLSQOiQ6M//PQrzMFoF15UFcgBZE6XvVbDw3K0YPIrha90PBUFlogbRQFZ12wfxABDMvYplYNcFfmF9h4sb/FSUmIfXFyX2COWLjrgTEfmZuZREN+8aUBaua05Ot46nj4E1F59OPliiC7U0L/aeMBBAelbho5TmNy/yvQv2btuXopX/ZtJWAVHw1fxnfT1UvOq197BR9i1xrYxk/8OM2unokhOOGzxL/RioWI031Vpst70cVpidqjFkFUrMb97od8H+6jg3hzX65hdPQmccYl/4fcPTWjQPyUQv72EW5pkBIHRlW4xUoYXxdEqZ6XQ5+Ed8EuDtUu4/lF/1sbwjNLbpGgVenIF8ZHr9U3/wUiprFKW6OjOuiLgDnDen6dg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(136003)(346002)(186009)(1800799009)(82310400011)(451199024)(46966006)(36840700001)(40470700004)(31696002)(82740400003)(36756003)(86362001)(40480700001)(40460700003)(6666004)(53546011)(478600001)(83380400001)(26005)(336012)(107886003)(426003)(16526019)(2616005)(5660300002)(8936002)(8676002)(41300700001)(4326008)(31686004)(2906002)(316002)(6636002)(110136005)(54906003)(16576012)(70586007)(70206006)(356005)(7636003)(36860700001)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 09:48:29.4431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53cd6d07-a906-4273-83db-08dbaebe6cd0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5599
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/2023 11:55, Cédric Le Goater wrote:
> Hello,
>
> On 9/8/22 20:34, Yishai Hadas wrote:
>> Add support for creating and destroying page tracker object.
>>
>> This object is used to control/report the device dirty pages.
>>
>> As part of creating the tracker need to consider the device capabilities
>> for max ranges and adapt/combine ranges accordingly.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/vfio/pci/mlx5/cmd.c | 147 ++++++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/mlx5/cmd.h |   1 +
>>   2 files changed, 148 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index 0a362796d567..f1cad96af6ab 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -410,6 +410,148 @@ int mlx5vf_cmd_load_vhca_state(struct 
>> mlx5vf_pci_core_device *mvdev,
>>       return err;
>>   }
>>   +static void combine_ranges(struct rb_root_cached *root, u32 
>> cur_nodes,
>> +               u32 req_nodes)
>> +{
>> +    struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
>> +    unsigned long min_gap;
>> +    unsigned long curr_gap;
>> +
>> +    /* Special shortcut when a single range is required */
>> +    if (req_nodes == 1) {
>> +        unsigned long last;
>> +
>> +        curr = comb_start = interval_tree_iter_first(root, 0, 
>> ULONG_MAX);
>> +        while (curr) {
>> +            last = curr->last;
>> +            prev = curr;
>> +            curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
>> +            if (prev != comb_start)
>> +                interval_tree_remove(prev, root);
>> +        }
>> +        comb_start->last = last;
>> +        return;
>> +    }
>> +
>> +    /* Combine ranges which have the smallest gap */
>> +    while (cur_nodes > req_nodes) {
>> +        prev = NULL;
>> +        min_gap = ULONG_MAX;
>> +        curr = interval_tree_iter_first(root, 0, ULONG_MAX);
>> +        while (curr) {
>> +            if (prev) {
>> +                curr_gap = curr->start - prev->last;
>> +                if (curr_gap < min_gap) {
>> +                    min_gap = curr_gap;
>> +                    comb_start = prev;
>> +                    comb_end = curr;
>> +                }
>> +            }
>> +            prev = curr;
>> +            curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
>> +        }
>> +        comb_start->last = comb_end->last;
>> +        interval_tree_remove(comb_end, root);
>> +        cur_nodes--;
>> +    }
>> +}
>> +
>> +static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
>> +                 struct mlx5vf_pci_core_device *mvdev,
>> +                 struct rb_root_cached *ranges, u32 nnodes)
>> +{
>> +    int max_num_range =
>> +        MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_max_num_range);
>> +    struct mlx5_vhca_page_tracker *tracker = &mvdev->tracker;
>> +    int record_size = MLX5_ST_SZ_BYTES(page_track_range);
>> +    u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
>> +    struct interval_tree_node *node = NULL;
>> +    u64 total_ranges_len = 0;
>> +    u32 num_ranges = nnodes;
>> +    u8 log_addr_space_size;
>> +    void *range_list_ptr;
>> +    void *obj_context;
>> +    void *cmd_hdr;
>> +    int inlen;
>> +    void *in;
>> +    int err;
>> +    int i;
>> +
>> +    if (num_ranges > max_num_range) {
>> +        combine_ranges(ranges, nnodes, max_num_range);
>> +        num_ranges = max_num_range;
>> +    }
>> +
>> +    inlen = MLX5_ST_SZ_BYTES(create_page_track_obj_in) +
>> +                 record_size * num_ranges;
>> +    in = kzalloc(inlen, GFP_KERNEL);
>> +    if (!in)
>> +        return -ENOMEM;
>> +
>> +    cmd_hdr = MLX5_ADDR_OF(create_page_track_obj_in, in,
>> +                   general_obj_in_cmd_hdr);
>> +    MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode,
>> +         MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
>> +    MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type,
>> +         MLX5_OBJ_TYPE_PAGE_TRACK);
>> +    obj_context = MLX5_ADDR_OF(create_page_track_obj_in, in, 
>> obj_context);
>> +    MLX5_SET(page_track, obj_context, vhca_id, mvdev->vhca_id);
>> +    MLX5_SET(page_track, obj_context, track_type, 1);
>> +    MLX5_SET(page_track, obj_context, log_page_size,
>> +         ilog2(tracker->host_qp->tracked_page_size));
>> +    MLX5_SET(page_track, obj_context, log_msg_size,
>> +         ilog2(tracker->host_qp->max_msg_size));
>> +    MLX5_SET(page_track, obj_context, reporting_qpn, 
>> tracker->fw_qp->qpn);
>> +    MLX5_SET(page_track, obj_context, num_ranges, num_ranges);
>> +
>> +    range_list_ptr = MLX5_ADDR_OF(page_track, obj_context, 
>> track_range);
>> +    node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
>> +    for (i = 0; i < num_ranges; i++) {
>> +        void *addr_range_i_base = range_list_ptr + record_size * i;
>> +        unsigned long length = node->last - node->start;
>> +
>> +        MLX5_SET64(page_track_range, addr_range_i_base, start_address,
>> +               node->start);
>> +        MLX5_SET64(page_track_range, addr_range_i_base, length, 
>> length);
>> +        total_ranges_len += length;
>> +        node = interval_tree_iter_next(node, 0, ULONG_MAX);
>> +    }
>> +
>> +    WARN_ON(node);
>> +    log_addr_space_size = ilog2(total_ranges_len);
>> +    if (log_addr_space_size <
>> +        (MLX5_CAP_ADV_VIRTUALIZATION(mdev, 
>> pg_track_log_min_addr_space)) ||
>> +        log_addr_space_size >
>> +        (MLX5_CAP_ADV_VIRTUALIZATION(mdev, 
>> pg_track_log_max_addr_space))) {
>> +        err = -EOPNOTSUPP;
>> +        goto out;
>> +    }
>
>
> We are seeing an issue with dirty page tracking when doing migration
> of an OVMF VM guest. The vfio-pci variant driver for the MLX5 VF
> device complains when dirty page tracking is initialized from QEMU :
>
>   qemu-kvm: 0000:b1:00.2: Failed to start DMA logging, err -95 
> (Operation not supported)
>
> The 64-bit computed range is  :
>
>   vfio_device_dirty_tracking_start nr_ranges 2 32:[0x0 - 0x807fffff], 
> 64:[0x100000000 - 0x3838000fffff]
>
> which seems to be too large for the HW. AFAICT, the MLX5 HW has a 42
> bits address space limitation for dirty tracking (min is 12). Is it a
> FW tunable or a strict limitation ?

It's mainly a FW limitation.

Tracking larger address space than 2^42 might take a lot of time in FW 
to allocate the required resources which might end-up in command 
timeout, etc.

>
> We should probably introduce more ranges to overcome the issue.

More ranges can help only if the total address space of the given ranges 
is < 2^42.

So, if there are some areas that don't require tracking (why?), breaking 
into more ranges with smaller total size can help.

Yishai

