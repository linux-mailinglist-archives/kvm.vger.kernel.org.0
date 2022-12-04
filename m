Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE043641CCF
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 13:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiLDMHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 07:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLDMHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 07:07:46 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2061.outbound.protection.outlook.com [40.107.212.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5558DC68
        for <kvm@vger.kernel.org>; Sun,  4 Dec 2022 04:07:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2ex8aHVUmbtZ+Du4+Wlgcn65jmaDtATyMrbZNkJx5e0m+TFun3U9dgpobZM7Ur09cTxLMxhu7/6xVbIhr/AXwrvmUPwGEUxbNfuHYy4HkvxktoMMEir7kaIFn3G1yKaY5+4Swre3UQmA7VJbwyjellvA2FVk/sFk8cRkrZZd0uUC2RkGavqNKYSmdTb/nXJ4OKW5JHw3wsOqz9sNlwi6eKX/FF35pCcYfdfKaasruq0dLAI9ZwdpuOU6+TT0vwJqu2VSECdpCRQmO7OHEA2RQdW4cHxilPex+XsALiyXRS8SZX9qDFf7nBigvCrc1/HMOFnSP/ek0uMiG4Sbmx0tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtdXMGrchzoby+cF23W6s/+7Sp4a4ksulO5fs45lsmg=;
 b=SV7EZVxHx43IVhP+9FLaqcHhBiBTt38HLSiUGMrflbSW4XLRp1JLFaMDICWTrETj4fs80v30hstd69OnCoSUQ+1so2eO331djwLbDh2IAEyXjYVdibWMHPMthun7A6VZMjnAtlg1bj48Ju9ECXjOSfZfqlKKohEZgWiIRMeIt5fm+Dr52grLwOH5h4bP3Ug5RXu8wkzp+72A5R0RwIEwlbW8uH7UlFLs/Fob0PAI3T0EzChKuGL2d43st0EEWDy4D5DvfwmvX/zW55k2DQM7DLWFpZn1XvS7lQ7tcQdqgU0omkHotGXg0KmkDEkEyvFDaiDxdl2n3OsrXZz0U5ZsOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtdXMGrchzoby+cF23W6s/+7Sp4a4ksulO5fs45lsmg=;
 b=bHMkjhNA6ztht2D0xpRPFwDfzfCRbNvl/AAPpymPPt2QHWgyDP83kmzFB21MgijxwzFS91vmEoWWEIZrZov02otcd6PmPlzutihHBFyhRL0C2iXpoFvQEyjDoGV8kwNn0dTrFk2E9t2gWBuWhq44GA44AxcUg7cxtF5Uuhl/2z4a9IMOymHkr47OJjLokS4lxwakvntc+wxuYIAld6vQZ9VjK9yzjNGCVnxkvHym0m0duOlitHC8n3d4VwUv+gPLSAQNgNrFOa64rvnHg9FxyI2OVeaziPx1b5j5A2xqRhSQWyrOYTsG4u3qxjejhvKixBzVUr1zz5NJys8GL5rINA==
Received: from BN8PR03CA0004.namprd03.prod.outlook.com (2603:10b6:408:94::17)
 by BY5PR12MB4034.namprd12.prod.outlook.com (2603:10b6:a03:205::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 12:07:38 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::31) by BN8PR03CA0004.outlook.office365.com
 (2603:10b6:408:94::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Sun, 4 Dec 2022 12:07:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 12:07:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 04:07:25 -0800
Received: from [172.27.11.40] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 04:07:21 -0800
Message-ID: <af31d76a-d802-2fcf-176d-4bbac2b6eb19@nvidia.com>
Date:   Sun, 4 Dec 2022 14:07:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V2 vfio 03/14] vfio/mlx5: Enforce a single SAVE command at
 a time
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <shayd@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
 <20221201152931.47913-4-yishaih@nvidia.com> <Y4lL9CdGcqLWh0F2@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <Y4lL9CdGcqLWh0F2@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT065:EE_|BY5PR12MB4034:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b9103f1-3981-4ba9-f90c-08dad5f0231e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: szt9STCF92A/hzcqiNf/LvyOJCImHYEvUk6cxtvDj3xCHpQpaeoUkDBDhfYK14frITmryjfRtzOZkmIU5wKrTuDwnsOyzMo6iTMhHWfbIqRITS2D69Wwqq0hy3uw7jaZub0L3pqQRO3jBGWg0ZiJUW/p7hKGM7qUxrvyXL6P3aeClbsCv0kcNFyFlmjjJ6oa2vJ27vHH3VcEZzpTN9UOF8+uNzM4JJ5i4AAQsrnR6g/hBbMBqU2Ji6qzEYHIxOsvZZ3wFsTul491V48jfk/0Y3cCmJy98RTpMuvPiGL+7GFl0ymAE54P6YBpcziFUeyTgsu2zi2on7O3wNLL6LKpeMSREXSmYyNj9vsu1UjDcuZVviav/cCrNFDB1KQUe8vYEdvlRlr4Yrfbx/j24+Bk4/cekXmpkx0HzaiTcWE0c8OXDzZiwyspBtmBkwgukNpPIw0NKfhsri48p/b7FCkyWD0Yd89cTVR5hzPyou2bUmzYmhJ3J3MbrBp2ZKl+leY4f51kmraOIBnwyjwZ7dGL/S2k3HZfHCUkDZSmpfXbFLQ9d0LpFj6BsgnxLliPftsY6o6j/SUDO0Bg6Txqus8rbL9ORfZh/rEk8K/L1kXE4YlK/eLb0/aJuVNiwPCYpW7iNUyUTYDSK8CMSLfPhreMoue5KA31xtXkFe7BOP8j4uH1R/Mi9bS8+LQr0uTv+mPAouX4adE2EPOVGZ7Q06y2KA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39850400004)(376002)(346002)(451199015)(46966006)(36840700001)(40480700001)(36756003)(86362001)(31696002)(478600001)(26005)(82310400005)(53546011)(186003)(4744005)(5660300002)(8676002)(4326008)(2906002)(41300700001)(6862004)(16576012)(8936002)(316002)(54906003)(37006003)(70586007)(70206006)(6636002)(36860700001)(82740400003)(7636003)(356005)(2616005)(336012)(16526019)(83380400001)(47076005)(426003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 12:07:38.2415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9103f1-3981-4ba9-f90c-08dad5f0231e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4034
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2022 2:51, Jason Gunthorpe wrote:
> On Thu, Dec 01, 2022 at 05:29:20PM +0200, Yishai Hadas wrote:
>
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index 6e9cf2aacc52..4081a0f7e057 100644
>> --- a/drivers/vfio/pci/mlx5/main.c
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -245,6 +245,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
>>   	stream_open(migf->filp->f_inode, migf->filp);
>>   	mutex_init(&migf->lock);
>>   	init_waitqueue_head(&migf->poll_wait);
>> +	init_completion(&migf->save_comp);
>> +	complete(&migf->save_comp);
> Add comment here
>
> save_comp is being used as a binary semaphore built from a
> completion. A normal mutex cannot be used because the lock is passed
> between kernel threads and lockdep can't model this.
>
> Jason

Sure, will add the comment as part of V3.

Yishai

