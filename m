Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6207D627113
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 17:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbiKMQ7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 11:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiKMQ7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 11:59:00 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2056.outbound.protection.outlook.com [40.107.95.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D80227
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 08:58:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fatuWlq+dFG0RjE+qLaeIvrUukI5znSw7bcVPEIdb5S93rY3uWy5kXtKu+KbMc1GX3oPQ/qLyV0+KXO7VgrLao0RhUm8LZbF8hfi1uindKo9bpMSiQHNPtsQtJbRtCAXB/jpM3yR1bZO4XTqFf8G+MyG13HyYZWU6GdOl/IWRHqMKeV0euZMnfUQVcJ3i8hNDF8No+ZRluBfdGcUBzuvWqWfzwnbGOB2Fircf9azHoKWra1tThqE6XMnXcABYnU1/NXszMV30KUGky4SPzk+Hg4iOWvyc0Bj7ay2cmCJQ+zru9BHDqOXzU7iTbSA682+SEIbe8mXJ+kYDIke3Kf4Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=azcf4HAMjPqc1CqYXBZUgeTsKNqfsYcM2bxDc/XSDo8=;
 b=m/HMSobmmIyJRsXZohji6DPU4H7OlfB0Tj8ZKIXUWFP87Zp8j793uSXS4ri1u6Kt1UD8nFgPQD1O/U5VhJPNfYfqBKaz44rN5dk1Tyk2UwywhJGMSXeD1tI050/sfx4+b8HyUz3xwXWEn8j1DypeTZHOWiu5B8dkxciPL0Z8KC76cyYUphKc7xDph6Wolnp7W1IGvGNRTEILu6EosPfOxLkDY4Un1wAKxUcykssdu9nzglj7J/jQKOM36COfnWxhj+gnuyXgligJzOa/+iJB694F+zwCrdfIvwjJvnRUyYfP+Fvaab9mA6ns2UCaCgki5u5qg1xG7XV5eXWNYcAYYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azcf4HAMjPqc1CqYXBZUgeTsKNqfsYcM2bxDc/XSDo8=;
 b=mV2jNjsKruxC3ghtCSvBcdKrggCO6In7VZ08E89XCGAQ185cBy5afu3gfJeGjJOq2/eBSjEFOMQ1CeeW1EjSfutfq6bsWTdmaRyHzt70405dyAyDvui7RGqn7X7PjUXYiRnti+7KmQK9Smoa86DC82kwFVBlmKM7qC/HfPFQ1WIzQTaUDJSvqQvcp9RKHSw0wIEoDBvC6Sr5Nrws7VhAo7ogVv/+pZFm3dpzNLoHovHlwaOGBFscluklNR6p+6wjnrBVpCPWolO7Fa07jtF60QRoxwMi/sY4Yvf4yM7bvHcKjAwlXLi0Hx9/P2I5UesHIBsmrwwe59JbxiVaTIyvhw==
Received: from MW4PR03CA0019.namprd03.prod.outlook.com (2603:10b6:303:8f::24)
 by IA1PR12MB6188.namprd12.prod.outlook.com (2603:10b6:208:3e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Sun, 13 Nov
 2022 16:58:57 +0000
Received: from CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::81) by MW4PR03CA0019.outlook.office365.com
 (2603:10b6:303:8f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Sun, 13 Nov 2022 16:58:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT039.mail.protection.outlook.com (10.13.174.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Sun, 13 Nov 2022 16:58:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 13 Nov
 2022 08:58:54 -0800
Received: from [172.27.1.161] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 13 Nov
 2022 08:58:50 -0800
Message-ID: <dae6bdc2-eee5-daaf-e98f-1ca278310f3d@nvidia.com>
Date:   Sun, 13 Nov 2022 18:58:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH vfio 01/13] vfio: Add an option to get migration data size
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <shayd@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
 <20221106174630.25909-2-yishaih@nvidia.com> <Y2veI4vCSO1xUi/C@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <Y2veI4vCSO1xUi/C@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT039:EE_|IA1PR12MB6188:EE_
X-MS-Office365-Filtering-Correlation-Id: 6779aecf-ce81-4d3b-f622-08dac5985ab7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4JFLK74hmdah8H8nGJFBcMkQorT7/iGhCiLsjB/DK86HUAhkbQlLEjt86H1518YCdWUN25k4BDbidMsjaCE+v19i1jJItz1ri7MESo+mwe48c67eWD2QxQsCBWZTJrEY8tqFXGGoNrGaXSmOrYr/AyEzONx9ff6wwtTkQlMaGxiPQ+YwTon8YwgxWvO+ctmTayGZRka5VyR1phqv/iWAxn/SB8Iqlp2qgbtmCKFGvSpqpl/wQ4D2BmGl326SoK6UXFlvIg0a7JwnlTefNPCvBkm7xm6hsVWKnCM1X0MAnQZr3CzVPdQdpEtflJAlOd1+bLo/XlSQWAh68+Hl+IWy9EIxXbbPGF3Hp+5opZSExNH6ZTZ3AzAStGa1p8tHfSlZCNpOHlxhwzw2uqy5s0yHhQInReOUq5ZBwsTb5LlblUOsusOXpr3hxuCKkzTMG+EcBBK7/XJWx8cGIOQZcLwIUB96uSpo+mELLBCUNa3U+Zf7081Iy/5G+Rl6GmyuDA3EKXC5QCjbZcsJmnGhsI7oN5r9PftqVSIwiDb67kt2xyuw8/QHThlcVCrvKcXCgaFYUljUp9p29ODoF47tv35ZLgRRn7M4+2XuyoiNEoyMxYEBeUAv4aqBMAeIw4dTzgIi6CZyz2LjfTeOhG7sjnMsXbxMd8FBDW8T86CvwZMSTBZG7+eTOWUoUcg2T/UqRPq9NmN+2FQ61AKVRZocXGZt7dYyc2BchGsCKdNs4k/GwqZEZozqSC8sXuGHTqBqggyNArT0WmoU6/PhhT+cE3ixevI6xMpGoqP8Kggki+s78y4=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199015)(36840700001)(40470700004)(46966006)(54906003)(110136005)(478600001)(31686004)(53546011)(16576012)(316002)(26005)(8936002)(36756003)(70206006)(70586007)(8676002)(4326008)(336012)(2616005)(41300700001)(186003)(16526019)(5660300002)(83380400001)(36860700001)(40460700003)(7636003)(426003)(47076005)(82310400005)(2906002)(40480700001)(31696002)(356005)(82740400003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2022 16:58:57.2489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6779aecf-ce81-4d3b-f622-08dac5985ab7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6188
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/2022 19:06, Jason Gunthorpe wrote:
> On Sun, Nov 06, 2022 at 07:46:18PM +0200, Yishai Hadas wrote:
>> Add an option to get migration data size by introducing a new migration
>> feature named VFIO_DEVICE_FEATURE_MIG_DATA_SIZE.
>>
>> Upon VFIO_DEVICE_FEATURE_GET the estimated data length that will be
>> required to complete STOP_COPY is returned.
>>
>> This option may better enable user space to consider before moving to
>> STOP_COPY whether it can meet the downtime SLA based on the returned
>> data.
>>
>> The patch also includes the implementation for mlx5 and hisi for this
>> new option to make it feature complete for the existing drivers in this
>> area.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  9 ++++++
>>   drivers/vfio/pci/mlx5/main.c                  | 18 +++++++++++
>>   drivers/vfio/pci/vfio_pci_core.c              |  3 +-
>>   drivers/vfio/vfio_main.c                      | 32 +++++++++++++++++++
>>   include/linux/vfio.h                          |  5 +++
>>   include/uapi/linux/vfio.h                     | 13 ++++++++
>>   6 files changed, 79 insertions(+), 1 deletion(-)
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>
> Jason

Alex,

Are we fine with taking the first 2 patches from this series ?

For this one we have reviewed-by from Jason and Longfang Liu, the next 
patch has also a reviewed-by Jason and is very simple.

Please let me know if you want me to send them separately outside of 
this pre_copy series and add the mentioned reviewed-by or that you can 
just collect them out from the list by yourself.

Thanks,

Yishai


