Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027CC677F85
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 16:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbjAWPVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 10:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjAWPUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 10:20:51 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CF22BEEF
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 07:20:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTs+rUe5W9sapRqhhUwn2RWcQLcQWDi5lJFFuOZ3Dpkd43p6nlFofzmthuAV3a9zwdZf8ofO9CtP7EdlGUEu0xgGM6Qbp/7xytt+FYSkLs7ySb8xGtwjg2ILIqypZlmzfq7bDTk6sWEFtOm8zFLwl2XMam09XDoXZUmTXLhiFWC2QEIH9JBatVeSKXlXnCCCgC2zWLvTXVHFxLdPQjfyVVx+rkeVjue05DcxDg9o8O2I1PCQxVgHHbSRtZd7KsfzWhUin3bIsGoTWXgKX8u+W2ylM6pkXiSAEaTM3mr2wyDJT7Zk+uo7NF0Tdwkj9K+2I4v8YmbOq1hJGPHvEMu13A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RO8ESjJXS8m8AumboxDYedSBPjWvJtRkzwjGR2UsJxg=;
 b=dxykWVjXPJd/kT+Uc0OEAWavrYfPxR8yDahnZyo2lbKFnOe/Y5+k6mqxi0roK2OJoAvxU+WN7NUEY/VezHyRrebmVl7t+H+3o9M/4Ul0KgfyW+XmLC3yS2lw26Mi0wth8YgL/A8M39g+Vm4ojZakAaIf028kpm6kHD5TGwKpp/ph/5vCaCtii/qgYJ1DHTpF5FEHuVW8KxE56siHrhhFKTRZ8eVrYWRyDnjw+mimHeK94jBfyyAXethfjYuWtv+uM/WNyoyk/TqPgOKFpjTS79P0PMGbzlxvy2P5Ys+DmyQ54JjQar60x61YsPtcZUO2/0dr4u9Q1WZYgD+C2v6q4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RO8ESjJXS8m8AumboxDYedSBPjWvJtRkzwjGR2UsJxg=;
 b=UHNfjzCxr88D0feYBdXQzCYbgGY0/oriUMuZ3aKYGuOdC8Jop5bgHxapTotE1hFkqANL3a+uS8fs9Q/i1+ldu5TjGtMlXsbBhO502tfg+ft2zty8/gvxZdqK10YeAWui5IU6Jia2oWX08pNjyGhCtEWJHtW9BYxF8kikshgj807DIF70izlQuPTL//E1/eAuZhNS6Pj5nzdgvl5Hw7OyiD5kAb0nUMH4OD1KrPymEqKb8h42IiYT5C8L2lDVQjobkmW0a5byQ6XJaYMZ1DtmWctiPIxXEcEdMkz2WZYJeCWRXL6ZU7TM0lzB8d326/+tKOezR8Ox0W9moY7z1ZX3fg==
Received: from DM6PR07CA0096.namprd07.prod.outlook.com (2603:10b6:5:337::29)
 by MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 15:19:27 +0000
Received: from DS1PEPF0000E64F.namprd02.prod.outlook.com
 (2603:10b6:5:337:cafe::ce) by DM6PR07CA0096.outlook.office365.com
 (2603:10b6:5:337::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 15:19:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E64F.mail.protection.outlook.com (10.167.18.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.10 via Frontend Transport; Mon, 23 Jan 2023 15:19:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 23 Jan
 2023 07:19:17 -0800
Received: from [172.27.11.158] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 23 Jan
 2023 07:19:13 -0800
Message-ID: <0ac2c961-2592-0925-e3ed-acd3d3de9d4b@nvidia.com>
Date:   Mon, 23 Jan 2023 17:19:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V1 vfio 0/6] Move to use cgroups for userspace persistent
 allocations
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
 <20230117163811.591b4d6f.alex.williamson@redhat.com>
 <Y8gM+9ptO2umgPQf@nvidia.com>
 <20230118104044.2811ab35.alex.williamson@redhat.com>
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20230118104044.2811ab35.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64F:EE_|MW6PR12MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 96a561bb-2659-445c-ccf1-08dafd5537bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dhr00EVlxo0mmX36amR1eNBRZunv5qVM5RAxLZeKBJbzAgKeQJJQKFWCDAUf0BVJLx99i/pc23deZhWpY/JQkAlEKK+BHdSgFIY9QD/YIe+/XqnTF6bwaMqpM3FIlGZrA0OxIm5/L0+PDipoyPKS4fy59JpHGChjVr4+2Cda035fduhnSY+zy3ECAd2xUb9WHaN0/AHeyTmwuC2G1bWAa7HV3Tmajw0Qf+9FxPiMWcsw4MXOSNb/LYwv0Mv1Km/U+NSBs1OmxfWhh+ybmUl/1juVDCAvejrrtMtyhLU5nBBVrA5uDHGHxnDCmtTjRMre5qhZc/n2pb/J68upw5GUnQWzLXzi0FHFcNUhM19X6Lv8kz8DKyCV1e/wH2rR6/txyvauyuJY8xGiZH5/ejikAlQl46niW5NV7uaYXwNryhSnycjQIzk62HPS2lWEVMMGA4oRwwUt/I1Ci4zxfJB2mYUL28CZNYIJ98Ioa9oZ9uQ33qw3PVvnVppwI0Q7JQ3CyX7G3h1Q7eK3tlNiJwrb9hrQQoNqkpbNyTmqXo8hVnpqo5hvgbj+8qsmiKyByagl2WykUI+qFiU9XK6FRbXNJRHACU/4q9haVzs1GzO4kg28hlJQjP0rd/sbvs1zMkgPngBY7lRlONWk71IPHu012X/eq9kqOnaVySesVCe2HkNioexhsFVTfNo4p+jdc1GVbS8oJJ8dXoq1LuSUYeORyUS3chJ6vZ6KXz7yds4i9Zs=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199015)(36840700001)(46966006)(40470700004)(36860700001)(83380400001)(31696002)(82740400003)(82310400005)(2906002)(86362001)(5660300002)(356005)(41300700001)(7636003)(8936002)(4326008)(40480700001)(40460700003)(8676002)(16526019)(186003)(53546011)(26005)(47076005)(426003)(16576012)(336012)(54906003)(316002)(70206006)(6636002)(2616005)(70586007)(110136005)(478600001)(31686004)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 15:19:27.4107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96a561bb-2659-445c-ccf1-08dafd5537bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7086
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/2023 19:40, Alex Williamson wrote:
> On Wed, 18 Jan 2023 11:15:07 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Tue, Jan 17, 2023 at 04:38:11PM -0700, Alex Williamson wrote:
>>
>>> The type1 IOMMU backend is notably absent here among the core files, any
>>> reason?
>> Mostly fear that charging alot of memory to the cgroup will become a
>> compatibility problem. I'd be happier if we go along the iommufd path
>> some more and get some field results from cgroup enablement before we
>> think about tackling type 1.
>>
>> With this series in normal non-abusive cases this is probably only a
>> few pages of ram so it shouldn't be a problem. mlx5 needs huge amounts
>> of memory but it is new so anyone deploying a new mlx5 configuration
>> can set their cgroup accordingly.
>>
>> If we fully do type 1 we are looking at alot of memory. eg a 1TB
>> guest will charge 2GB just in IOPTE structures at 4k page size. Maybe
>> that is enough to be a problem, I don't know.
>>
>>> Potentially this removes the dma_avail issue as a means to
>>> prevent userspace from creating an arbitrarily large number of DMA
>>> mappings, right?
>> Yes, it is what iommufd did
>>   
>>> Are there any compatibility issues we should expect with this change to
>>> accounting otherwise?
>> Other than things might start hitting the limit, I don't think so?
> Ok, seems like enough FUD to limit the scope for now.  We'll need to
> monitor this for native and compat mode iommufd use.  I'll fix the
> commit log typo, assuming there are no further comments.  Thanks,
>
> Alex
>
Alex,

Based on the above, can you please take it into your next branch ?

I would like to send soon some small series in mlx5 driver which 
improves some flows as part of pre_copy to reduce downtime as part of 
stop_copy.

Some code there should be sent on top of current series.

Thanks,
Yishai

