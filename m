Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D8A6429F0
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 14:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiLENzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 08:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiLENzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 08:55:00 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131CD24C
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 05:54:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlH6oFM/azxvDf99VVHahEfv+rNXxa0ERXx21YUEcewyEl5EByHMN8Kg3sSfwZwNKcq1pI72zqIon9x6hjexDqpNJUmiX5bkU/svEtEOX/6bWV24iwdbRZ8SBLO53gYL/mqrhamWF7Lp6YFptiE4xXLpoxJI/lcC+3+bWvUzOJr9oQVCxeC+4Rqw/EehTp+SD+ExhmeJ38zbkGGkYk3UR3J5GTked2nEU5DytrpDuzeJbEhh5ZcWks4R2G9O22dqe0beQiBwStXVBbOh1EeWv5OxtiOZhE5/CfomNZzc5V65Z7bLQqroB73ipL5zANdNY4WLx+Ng/IwfQuQUm5mp3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TYWaWFBvBSc3MJMgDBy+ZcLd0ZPJ5bPoUtaP836x4o=;
 b=oIIt6EP+jbS2AKzeVE+EMED5foRXZ7U1TcVww0HSGVv/DDV8TF58Ktc3V47ueRRygSPMypH2E0DgSWIoPn9tbWhT/EY2ANLP1znKgLC3c3PNogxqBtP2RhX3xDobNVhPh6hYKuycYM8trFwK+aVrIms+4pNwTz/mTjI9zOiaH7pdTb0uWMLBlZTywvX1BW6TvAFaqbd9MmNaVspyKTLWID9VLup+mOAnnF1ow5UeuTo0c8kMKLUahphkVZr94S1/9c16LpEept0kwob6UF45KxQD3poQokgk72MqInCKJbt2fd46z1nsQ0Ja3HarcxDgx8E9kuVSgQ0zRQx8Wuw1Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TYWaWFBvBSc3MJMgDBy+ZcLd0ZPJ5bPoUtaP836x4o=;
 b=SOCyv7TQMfLnaKAV3fSQXqld0+xgCBkurEIWq3YOlvjlpfQTscFCwPOLC4I4+lupZiGke4RLS8Pc2Z6NHIR68DX3fU9Z6v9UQgVfkIqEwax/zUWrbU47WpieQJMJR2swfO/fNEfBmm/qsioswe7TmwBvCzHoxhXacqm9+J7CYt7jLNY/fXsbNZs3AK1UQU4Fn6SLOKqa1aruofZpTYc8Mip5kOAX2KTpLxxsUTlYCd8wGpBDNDjU6/Ry7esiuXvC7yI+VO0cHOdxDslNheh6ffkSoYs1EgQSuyheE8x6GNOSTqf0PxWtQxBbygxJ/roa09/5U9l7rpJoDzOSSjlTqg==
Received: from CY5PR10CA0020.namprd10.prod.outlook.com (2603:10b6:930:1c::10)
 by BL3PR12MB6522.namprd12.prod.outlook.com (2603:10b6:208:3be::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 13:54:57 +0000
Received: from CY4PEPF0000B8EC.namprd05.prod.outlook.com
 (2603:10b6:930:1c:cafe::e4) by CY5PR10CA0020.outlook.office365.com
 (2603:10b6:930:1c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 13:54:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EC.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.11 via Frontend Transport; Mon, 5 Dec 2022 13:54:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 05:54:46 -0800
Received: from [172.27.11.24] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 05:54:42 -0800
Message-ID: <f44e180c-7bef-4fdf-2380-16cec5800705@nvidia.com>
Date:   Mon, 5 Dec 2022 15:54:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V2 vfio 02/14] vfio: Extend the device migration protocol
 with PRE_COPY
Content-Language: en-US
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "shayd@nvidia.com" <shayd@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "avihaih@nvidia.com" <avihaih@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
 <20221201152931.47913-3-yishaih@nvidia.com>
 <90968e5f85a64bc68bb3d140fd7a4045@huawei.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <90968e5f85a64bc68bb3d140fd7a4045@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EC:EE_|BL3PR12MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: 730c83d8-d97e-4751-01a9-08dad6c84aca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJF1S9i72esa/y1GSCQbjx7gbYkeI8XOdUg5xEFa4QV8ssBbEUxtAQbi9AGdn6tLw0q267+9HFUfoYbptnELx66zv0R4aUe8xv/pFt5yjpAVXo1Y/nfAO10N+inpJUapHfs6AUiqV/QnvuhNa39vRg76BJJx4a4b/ltJNlI44U2vs5eb6VSHMfQ73dL+su6IRqIjHbpq9jTjfrIk0/GH+oLU86AyRe2zVd9qF8pJnR63zYg56z75pabHaci9XYFlCAGaMBavYqzWNukq+Sh1vBc4VdKUGTAnaPByoCH4nVHY9NJ+/xwvFKO+1mEY7+ggW+vELXLbMKaCs2Nw+fMFzT6EejAISV0wsB54goZKHA/N66p+sG0zpZjgdjCjzGoeK+EIcisW/y6nAmFTalUik/5WVEEnvmHvd4FHX9vc8EAiVMUYD3EOwvZuQEcCN3YBDrF1RZDii2SuWi+QCM9rrOaDxPygMA5cqzmIimNqFLJvFQCxgX5ljZ2GvkDAEQNBh1x7mqdikKWj2MHLNkJh1dsh4rDk+xWNDewSSx9ZsIWarQmRJ5ao/VonL4xpjSoZuACQ07L63cMrQYxDsqyh/nvzMHyc2mJ9ddYiKRgZQh2fCE8rmyUh9UiUxsdPuMA+dK3xXBmN2XplIZ/BueNVE/iHgZw73pMMb8OySlvCEY/UcvRhYdIUEit0LaG57P++6jmtshuI3vWSlXbBW++ruhenmp6T06LockLUkG4lqF4=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(40470700004)(36840700001)(46966006)(2906002)(8676002)(4326008)(31686004)(70586007)(70206006)(16526019)(316002)(16576012)(40460700003)(110136005)(6636002)(36756003)(5660300002)(54906003)(86362001)(31696002)(26005)(40480700001)(53546011)(8936002)(186003)(336012)(478600001)(83380400001)(426003)(7636003)(47076005)(356005)(41300700001)(2616005)(82740400003)(36860700001)(82310400005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 13:54:55.9933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 730c83d8-d97e-4751-01a9-08dad6c84aca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6522
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2022 11:38, Shameerali Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Yishai Hadas [mailto:yishaih@nvidia.com]
>> Sent: 01 December 2022 15:29
>> To: alex.williamson@redhat.com; jgg@nvidia.com
>> Cc: kvm@vger.kernel.org; kevin.tian@intel.com; joao.m.martins@oracle.com;
>> leonro@nvidia.com; shayd@nvidia.com; yishaih@nvidia.com;
>> maorg@nvidia.com; avihaih@nvidia.com; cohuck@redhat.com
>> Subject: [PATCH V2 vfio 02/14] vfio: Extend the device migration protocol
>> with PRE_COPY
> [...]
>   
>> +/**
>> + * VFIO_MIG_GET_PRECOPY_INFO - _IO(VFIO_TYPE, VFIO_BASE + 21)
>> + *
>> + * This ioctl is used on the migration data FD in the precopy phase of the
>> + * migration data transfer. It returns an estimate of the current data sizes
>> + * remaining to be transferred. It allows the user to judge when it is
>> + * appropriate to leave PRE_COPY for STOP_COPY.
>> + *
>> + * This ioctl is valid only in PRE_COPY states and kernel driver should
>> + * return -EINVAL from any other migration state.
>> + *
>> + * The vfio_precopy_info data structure returned by this ioctl provides
>> + * estimates of data available from the device during the PRE_COPY states.
>> + * This estimate is split into two categories, initial_bytes and
>> + * dirty_bytes.
>> + *
>> + * The initial_bytes field indicates the amount of initial precopy
>> + * data available from the device. This field should have a non-zero initial
>> + * value and decrease as migration data is read from the device.
>> + * It is recommended to leave PRE_COPY for STOP_COPY only after this field
>> + * reaches zero. Leaving PRE_COPY earlier might make things slower.
>> + *
>> + * The dirty_bytes field tracks device state changes relative to data
>> + * previously retrieved.  This field starts at zero and may increase as
>> + * the internal device state is modified or decrease as that modified
>> + * state is read from the device.
>> + *
>> + * Userspace may use the combination of these fields to estimate the
>> + * potential data size available during the PRE_COPY phases, as well as
>> + * trends relative to the rate the device is dirtying its internal
>> + * state, but these fields are not required to have any bearing relative
>> + * to the data size available during the STOP_COPY phase.
>> + *
>> + * Drivers have a lot of flexibility in when and what they transfer during the
>> + * PRE_COPY phase, and how they report this from
>> VFIO_MIG_GET_PRECOPY_INFO.
>> + *
>> + * During pre-copy the migration data FD has a temporary "end of stream"
>> that is
>> + * reached when both initial_bytes and dirty_byte are zero. For instance,
>> this
>> + * may indicate that the device is idle and not currently dirtying any internal
>> + * state. When read() is done on this temporary end of stream the kernel
>> driver
>> + * should return ENOMSG from read(). Userspace can wait for more data
>> (which may
>> + * never come) by using poll.
>> + *
>> + * Once in STOP_COPY the migration data FD has a permanent end of
>> stream
>> + * signaled in the usual way by read() always returning 0 and poll always
>> + * returning readable. ENOMSG may not be returned in STOP_COPY.
>> Support
>> + * for this ioctl is optional.
> Isn't mandatory if the driver claims support for VFIO_MIGRATION_PRE_COPY?

It seems reasonable to let it be mandatory once the driver claims to 
support PRE_COPY.

This will also simplify things from QEMU point of view which can expect 
the IOCTL to be supported.

Will add a note here as part of V3.

>
> Other than that looks fine to me.
>
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>
Thanks, will add your Reviewed-by as part of V3.

Yishai

