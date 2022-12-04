Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237CE641B9F
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 09:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiLDIft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 03:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiLDIfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 03:35:47 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3550F11C19
        for <kvm@vger.kernel.org>; Sun,  4 Dec 2022 00:35:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msG2UwTQDTZBaplAhKkGVcHbd4444fqkW/nOxRyuL43PA/O4q2VEoj/pzOUmthm/xm+2rJy348VsK78BPZnjS/xD3EFtb234GTpr32tNGK821T3epmgAZ5Qh1qdEo3PCSMh0Vi+KNhfN7jMn6EKJGbskf82ecFyQAitPAyBmCWdpYgD7cWmdcIZG9RvvqgmKC8zXtP6tBwx0R4utMOz9IpIM3axqpvakvTi5rDUZE8sYwDy2zkvaxAl6dfjIWnlhdUWaDWHOrTyTb/RhN7k0LR0aoK+QtaQqn+TcFDKIB1Hkz/heiT9T3WCH9IkdwE8eqnBx8oznhWOeOhpEZNO0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0ztVjqrEZNQUjBynS63AoIIZ0cwGDsfQIlHHg5AMrI=;
 b=U96Kx871Qfigh1JpMG8uBs54Vvtv3iFzvGAP0CMzrrluCJB830fBNxVjf3bHXTnUJyma6m+w67LySvO8wE/XeO3Xe2UNMCtw/aUmJWzdeBOW19iG+VOONa4TuWqjd0VW4zbGdE2U6TXjOZCzedWEr6HV90gaiA0Yz08k4LarGwQ5aC89b/aFx+cQikkAkP27BC172NQvZyfspjMnqq4lLDejvp3MacdAL406rQeQvVN8F42zmiIWa/B6yOw/bRD34W3wPeK9hsbuQIl+afyPTtXY5Fja55rwx7IHlKHNruSA78mgD/ouX6C7oM1zfucte1qGqUuVt7MDQj44sFjsuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0ztVjqrEZNQUjBynS63AoIIZ0cwGDsfQIlHHg5AMrI=;
 b=EXHfD0KyAE22rlzqJVcwKo6yRvcB8H7xG8A3kqZZZa9R0aYymP5xdUI8Qht3LccDV937/Cr0w6d7vq1UlkkwPU5Ljrf/bejhju0aByEgiq6Pt4NzEfHaif47cEkbz2KPBv9kkX8qRSQsXuemC0ZdG+JO4Nq4P+8J9WrEPqb7FQUi8U3EXPoUr/l8T1UDml+wPZO+yLrgxOEuwPM9ZmdigYXM/H+Tbl+k69QQbS/J8cET4MDhst1PKGUlYo03dizqVfjkqdnBsFkIs8WLs5Mzul+DYEoFUNgVyD69SfGL277yTJfdro9h6ilK7ELRxYbCvlBs8hMeKH4Vdn53gzpksg==
Received: from DS7PR03CA0031.namprd03.prod.outlook.com (2603:10b6:5:3b5::6) by
 CH2PR12MB5514.namprd12.prod.outlook.com (2603:10b6:610:62::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.11; Sun, 4 Dec 2022 08:35:44 +0000
Received: from DS1PEPF0000E62E.namprd02.prod.outlook.com
 (2603:10b6:5:3b5:cafe::16) by DS7PR03CA0031.outlook.office365.com
 (2603:10b6:5:3b5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Sun, 4 Dec 2022 08:35:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E62E.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Sun, 4 Dec 2022 08:35:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 00:35:36 -0800
Received: from [172.27.11.40] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 00:35:33 -0800
Message-ID: <ae4a6259-349d-0131-896c-7a6ea775cc9e@nvidia.com>
Date:   Sun, 4 Dec 2022 10:35:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V2 vfio 02/14] vfio: Extend the device migration protocol
 with PRE_COPY
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "shayd@nvidia.com" <shayd@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "avihaih@nvidia.com" <avihaih@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
 <20221201152931.47913-3-yishaih@nvidia.com>
 <BN9PR11MB5276F73EE06AB80BB5039D998C179@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB5276F73EE06AB80BB5039D998C179@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62E:EE_|CH2PR12MB5514:EE_
X-MS-Office365-Filtering-Correlation-Id: f714102b-c8e7-4ab5-542d-08dad5d288cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IxIkP5IjmmyRJLdI6ZtFNDqjF18BtPF9uoKbxcD8t4ua4BpOOiU2g3083Sgd5IH7QWqjazieb6koCA41K9386raBtg54FCBYCP61vOI/sva2Su9UF5uh9HaoBQFdB05B0gQ0uaz6QpNqstHECgBcqNVjs+cH/1maoi7w3CotRUUOyXey+vtdPwFta4mNyi+7URIAdZYxeu1rT8VMVhjAY8JStgCwDQP39c+vkDb4HX7atig6N+LbHOBQoauSlNFR4LDgJhF/8m/arwCCnh+yobZ+EI/KIKLhko5sTERxWyhsGmugL+vQRYiQ7fy9YXsc0fz39JazJgschj7MRQp253j151/3B9dnurrxgJchVHw24FmkHSghYLmWdQ9qv2L6sV4LjQxLJMq8pk/m3Wdezr28DKuJKPlb3C4xpco1dDjiSNWtNtHBLlbwt+kwZVfc1M37v2/iPJ9mCD2SA+fU6UI2DrDta8IW9MikSdLNl0bPvrS2grIY4VHKF9Lixs1DNGRtOKRcjpqMlfGGIFd2n8u2Et/EEoQrHL0c8BbSUGV4dp25kgIJpUBLJ8PRks5dCVKBdPrKiIIkbzyqnkUXphm7Fdq3BNL03Y2KDHKFdtWF2CHU5U5ElLX6srZfsB3UfvV1eYva1+ZocZrfxEPzm1schM9J2IfAibk5SELbDJpmXCnsKlpc7kJzPFX8jyuALyF6RPhUQj3ejvpmE7DEX4CQmUEESioOLntd+GHZBFg=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199015)(36840700001)(46966006)(40470700004)(336012)(186003)(16526019)(31686004)(316002)(16576012)(6636002)(478600001)(54906003)(110136005)(7636003)(82740400003)(356005)(40480700001)(40460700003)(86362001)(31696002)(36756003)(47076005)(426003)(2616005)(53546011)(82310400005)(26005)(5660300002)(2906002)(36860700001)(41300700001)(70206006)(4326008)(70586007)(8936002)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 08:35:43.9790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f714102b-c8e7-4ab5-542d-08dad5d288cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5514
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2022 10:48, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Thursday, December 1, 2022 11:29 PM
>>
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
> 'slower' because partially transferred initial state is wasted and a full
> state transfer is still required in STOP_COPY?

Not only, 'the initial_bytes' can serve any driver for its specific 
needs to reduce downtime.

For example, mlx5 passes by that some metadata about the state that 
allows the target to be prepared for during STOP_COPY.

This data can be used by the FW to allocate host pages pre-ahead, 
reorganize its internal data structure accordingly, etc.

Leaving PRE_COPY to STOP_COPY earlier might not give the target the 
chance to enjoy from that information and things might be slower as part 
of STOP_COPY.

>
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
> I didn't get what the last sentence is trying to say. By definition those
> fields have nothing to do with the transferred data in STOP_COPY.
>
> is there an example what a silly driver might do w/o this caveat?

It comes to say that user space can't assume anything about the size of 
the trailing STOP_COPY data set, this is why it's part of the UAPI header.

I believe that better keep it, as it clarifies things and prevent any 
mistake.

> Except above this looks good to me:
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks Kevin, will add your Reviewed-by as part of V3.

Yishai

