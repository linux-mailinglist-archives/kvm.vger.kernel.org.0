Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BC363EAC2
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 09:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiLAICf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 03:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLAICL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 03:02:11 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448631CFF3
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 00:02:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHvaf+UNzxsLheohDc6kulIlZTsFcse270WlF7U3KSf1a4svlu6x9qdt0/GVBGRnnUkB8BBk8bsPqIXQYQKdcv3GG+YS0b4liOunDodPyhDbcuK81Pw256Xv7BSBiwgU96GEbLbjCT58ltr/5px8yIsMJ6vR+30ZVmo4LxGbFF5PPbHjrUWJbKSYqAK8ribC4F5xQJ+hXJQUqsfH36SAoTnPrE89Vg3v/mvJGBjmRO+99kiMFhZU4XR7+809FyuMwG7Tc7Ag308P76cdXkhE8at9V6UX4QrAlFVTOAeC7ArLSROFMStSVY3a8qDUNIOW/aDeE8mCHPnQWMZnhCmk4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+BbvOwxAKUKbQReOtjk+1QZE7vkIUJqVJJlnvEGvrU=;
 b=fn7aNYa+RNb5kZRPGcnFII+NDZrhBdQn4zW2nORM2SDzYwLu+y1PMksU+wJivUmziwZ+silQm3lQ3aelEG5CZFMQ5FnOh4SV25LC6HjUV8OOgePvLtU48wA6qFO+nCyjJezDrnerJPzthH1VTl1E63fDWosF3I9AKMoLX7htyxRysg3K3adAykjxl9+VCVKa0wtcVjBEOLxktiUEb9Ad7F5gk2EqnCLJSxoTIc8rQMSQ8OjBUxjBXrO1o1kfFWKiuJyX9jRc3WMyN5HxO5ssvRyCWrM/TglmyLGo0kHItSpsdNm3aecmWeGN11QbWOf9lxK+uiQ6NnckvSxs/F0SOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+BbvOwxAKUKbQReOtjk+1QZE7vkIUJqVJJlnvEGvrU=;
 b=LssgvUQnCYqAAk7Mwm68szZW+uyzItPnuvTTgHBd7vdPBjlyFl3Rs/BKaPR3JW00LOcs7c0BYMpw1wzp+u50hAdBnY4MZz84oG4mG8M94Y96xOwEvU+ulhSEEPrutDsOxDVXWo85JJgzOpvHa46/hO/VMbruo4uStuYuFW4YfhVAySnTP9qu/3S0UiCpF+8T4dZgrxsRKVwqLH3uirJ14Pk93beaLu+R1j0AQgVRc6ORJj2OrOGbWldpiID6qHlXTJTWSFc2ukM4unobT7lqFx5QPfClWlhkStRxGe7zG4Jugzkkw7xtA8mxUl5NYNNTWwvQo+epfZpaeD3tf1Vipw==
Received: from MW4PR04CA0080.namprd04.prod.outlook.com (2603:10b6:303:6b::25)
 by DS0PR12MB7769.namprd12.prod.outlook.com (2603:10b6:8:138::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 08:02:03 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::a6) by MW4PR04CA0080.outlook.office365.com
 (2603:10b6:303:6b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 08:02:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.18 via Frontend Transport; Thu, 1 Dec 2022 08:02:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 00:01:54 -0800
Received: from [172.27.14.49] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 00:01:50 -0800
Message-ID: <632ec4d4-b661-9de2-ff83-8de7acefd8a2@nvidia.com>
Date:   Thu, 1 Dec 2022 10:01:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V1 vfio 02/14] vfio: Extend the device migration protocol
 with PRE_COPY
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>,
        <cohuck@redhat.com>, Juan Quintela <quintela@redhat.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
 <20221124173932.194654-3-yishaih@nvidia.com>
 <20221130152240.11a24c4d.alex.williamson@redhat.com>
 <Y4f6gk2JD3l47p2y@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <Y4f6gk2JD3l47p2y@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT060:EE_|DS0PR12MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b17e3a9-c0ea-44c7-13ae-08dad372551d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u3tzYo+mqYTFiVKS8nu96SeQK4C2RmOIHbE8ziXZKbH23jZSNjZHQAxDZZw6iA/aH/34XZPL5jf9/dnfdz2z0TK53jdqQI/Nqk1DVu9PUZ4HntYTKTEr4FE7mhYjDddM0gsyrSjsZcGDwOvR+f2jeZNha3yU2j0SmyS4R9A1c8xa0rbJvvBtZLs6iT2h1ebh4fIRj9Ps4yaNT0cFor9YHvH66QL8frMjpXa4JqJe6YVd5Q7TFYW0Z7Jv2gGEkAvBGxz0YlirxaErLiSX7coSTTy/tqe9K5se9VURS58ZPNwdKG1O1JHRaM/+G3crUlCWXAm5T2QFwloGnRbAjynNjJksOmCRRwo+zRLabI+f/Ox10rkFwgapaL2ZCLUyFl5KJDD1vzuHP1xc2T+T7o1DOHsJ7DnsoUbAuuBhQz3ZQQdkqJIxUOF3ZR9uCUsomMexBvUj6M4GtaSKpqFgGm2S8bTMyC5JSuGIKNWCWetxLNTzxIJE1xRGWDE3ePCqMh8kNQNYszB58Wr50dz30dSZ+o5gvMTNlI+0PQuqyOTFCvX2Gu+uGQKkH/rxpJUbSx5EZ6Nfd1o4g53UsgKvVfwq50E2TrC6ntKO9GHEsONv+BsGiOYNBhjBch5+ze5J4MtxGpxeshZV10lC0AnI3tlp3+aAeYmK6/SZ+B/23vKKE+GN3mHzGHDa/ae2PazSiyHF1v23qi/Hjf2c0N4Ahwf6d0F7ncc+PVKH2+TPMUPR+fQ=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(47076005)(2616005)(426003)(336012)(186003)(31686004)(16526019)(316002)(40480700001)(86362001)(31696002)(54906003)(16576012)(82740400003)(110136005)(7636003)(356005)(36756003)(40460700003)(36860700001)(8936002)(26005)(53546011)(82310400005)(5660300002)(4326008)(70206006)(478600001)(41300700001)(2906002)(70586007)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 08:02:03.3110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b17e3a9-c0ea-44c7-13ae-08dad372551d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7769
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/12/2022 2:51, Jason Gunthorpe wrote:
> On Wed, Nov 30, 2022 at 03:22:40PM -0700, Alex Williamson wrote:
>> On Thu, 24 Nov 2022 19:39:20 +0200
>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>> +/**
>>> + * VFIO_MIG_GET_PRECOPY_INFO - _IO(VFIO_TYPE, VFIO_BASE + 21)
>>> + *
>>> + * This ioctl is used on the migration data FD in the precopy phase of the
>>> + * migration data transfer. It returns an estimate of the current data sizes
>>> + * remaining to be transferred. It allows the user to judge when it is
>>> + * appropriate to leave PRE_COPY for STOP_COPY.
>>> + *
>>> + * This ioctl is valid only in PRE_COPY states and kernel driver should
>>> + * return -EINVAL from any other migration state.
>>> + *
>>> + * The vfio_precopy_info data structure returned by this ioctl provides
>>> + * estimates of data available from the device during the PRE_COPY states.
>>> + * This estimate is split into two categories, initial_bytes and
>>> + * dirty_bytes.
>>> + *
>>> + * The initial_bytes field indicates the amount of initial mandatory precopy
>>> + * data available from the device. This field should have a non-zero initial
>>> + * value and decrease as migration data is read from the device.
>>> + * It is a must to leave PRE_COPY for STOP_COPY only after this field reach
>>> + * zero.
>>
>> Is this actually a requirement that's compatible with current QEMU
>> behavior?  It's my impression that a user can force the migration to
>> move to STOP_COPY at any point in time.  Thanks,
> I think it is a typo
>
> It should be explaining that leaving PRE_COPY early will make things
> slower, but is not a functional problem.
>
> Jason

Right

I''ll rephrase as part of V2 as of below.

The initial_bytes field indicates the amount of initial precopy
data available from the device. This field should have a non-zero initial
value and decrease as migration data is read from the device.
It is recommended to leave PRE_COPY for STOP_COPY only after this field
reaches zero. Leaving PRE_COPY earlier might make things slower.

Yishai

