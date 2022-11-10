Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68683624192
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 12:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiKJLiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 06:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiKJLiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 06:38:23 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4276C716E2
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 03:38:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5VJ6CIqBv7fwmmrQqzbChqo4haPigsXPWlQPulbUsxdxnMrG95Mf0u5saN/IwwAAUtQA846GbDboAvMvlfEGtOtDXyQtE3zJEq/hqg6ZNJVHNCfVvsz6w+dVjruCP05W0FnI4NgeHttKKkj69O+e2glfeOpHS+7P5Rb5OOVEDmkZuZG9NpbmLGrFmQo7S8NxWcbkTgsUisJJMfCeQkIGRhhKa1DPjFmiJ2OpD6TGVW3GsP+5OVBITTPSF5ZnVLCkaZbMegPo50T8PC1VQvcnNDwEp9u7Kch0NWQxLIlwLnHa/q3EBLPum3ygbpJyxDi2f4NY/+Sm1iirt5yjCTjOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pjHBLeEEHuG6JnbuRfJbBiBKBJBpg6bzlqNyvc3KJ4Q=;
 b=htvPXpmNmO0vNCOXQdfJHdwoi1dWhg9o5kXlhXOdxTgB2YdBD0v7UpEDk159f2QiDecCn66zttFIz06daooJrgxixuNKXv00UjyEKEua0R99Rimu303/LVtMlb4AGVB3nm6zJiH2z5UM6nqd6/AGpioDOlODXHkzPFGJAplagJ2ccv5xTBLDRvfIzk7bre7A73DX9fFqoc4/xu9ynbCIwmrVURERkt7hfb44y/5IQ+kTR+Q8UvNXpS6KM0ir+o4nvXj5nce1SIofKTJTf7z1tIcvt2dSH0+P+O64BN7tny4gV4VV31JPGAW/XmInBV9kZvsYAFGugT4q0Nt6N1Ji6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjHBLeEEHuG6JnbuRfJbBiBKBJBpg6bzlqNyvc3KJ4Q=;
 b=rnrhl1cRNA2xI7bUTdp9BVWbEwx4k7H31W/BTHzjW4qgdNkb4BA7/jZxp6FHH30m5L1eqpTQl15ntbb92DG7sDBNCflVB/KPnuId5Z3EvbKUonas4RtTe3DpnkdlONMAyS7Q7YOzleO1F5iItXdKSyoQWS0EC+H8raAMKVKTXw/tyGCqlROjaTOOIIgqoRbAzugN/iaQ/wtgJ+1e8gPwZHIi3yBRizvR2gD6V1Y78QJ5pKN7/3E3l5irpkVdE3F38f6uh4Bk1ydR6eXtdI89QaUpCIh6p71PIdwZtlUnIwETEKpBnP3gneAFdTyQbFhC2qfo6TEzxkYavnK3uSOCkw==
Received: from MW4PR04CA0047.namprd04.prod.outlook.com (2603:10b6:303:6a::22)
 by DM6PR12MB4436.namprd12.prod.outlook.com (2603:10b6:5:2a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Thu, 10 Nov
 2022 11:38:20 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::fa) by MW4PR04CA0047.outlook.office365.com
 (2603:10b6:303:6a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Thu, 10 Nov 2022 11:38:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Thu, 10 Nov 2022 11:38:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 10 Nov
 2022 03:38:12 -0800
Received: from [172.27.0.199] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 10 Nov
 2022 03:38:08 -0800
Message-ID: <bb44268a-c08d-1cb4-b0f6-9e3ee559a0aa@nvidia.com>
Date:   Thu, 10 Nov 2022 13:38:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH vfio 06/13] vfio/mlx5: Refactor total_length name and
 usage
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <shayd@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
 <20221106174630.25909-7-yishaih@nvidia.com> <Y2vtPpeNPoED2Crr@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <Y2vtPpeNPoED2Crr@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT061:EE_|DM6PR12MB4436:EE_
X-MS-Office365-Filtering-Correlation-Id: a1d78894-5162-44a3-447e-08dac310112c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JtoaS3TGLIq2j+M8dQCmWwGkopQJD+ywSa/zt1PTdaO8clR8db89Wpltl0ZRp7+lv6Ppmai/12dEAXMutJcyQBdzgwWucobaddJ20jL7+Y8f2fyhf4Fx5pJUSE62wfXvclPjwQUa7P/fojHAUB19fhmFAPXfIW7WqlJMy0YY27wD6pf4uWu2nsrVo/ceEuALEI6ZN8KYrHH7HJQU7VUkWQugEgtSceu2P2NCg/SmJwcz5jJRbc0B0IFJjGfmMfe3KnQo/ij6pxJ/A1yg3Bbj273abK/7nVKbqcEb+RDoz7a25Xc90EWtvneTpnX1HhbCXUMV+9rH+5hxu5xOkxIVxUtoxIR30ySi8OT5INhp/uHTCC3ysAyfq1rFUang+Bn+FVoWJ7wFJd88qR/R4X9LSAquDA5bDkLEpJJlwij0hefnqA1whafLEvkgjAx/j9cRxSxnCnZt5EZpYEyqV7F4ZmoEHPLITWw67Q0NtTQSKFfpOHkKFug4ST96BL6tYzTndbR7BdKuvrmAgq9ExGUYTgzSNarKvcOV/D2bvEMzFNoNHxrqItRy4UU/6Uav/MMGwERBYWaAUljO9kC3Z1CBc//nxsVqrPTnDdwX8rGX/iBXUeCF/1EjxQA6OnsOw4s7vq4hid0tyyju8Kf+wt9D+6loAmMbZ9P9rrkwL+hhISNKU7MvMupfpqeypmrKGbcFh228TUL0ocFLa8Oy5D8xMMo6dmToDmEBk04I/xwa6oq7dtsluXLqeTe32beLxgV4a9OOzdg06bkwum+FJzFeBi5uKeMCQyWx6vwpWMkDgdw=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199015)(36840700001)(46966006)(40470700004)(36756003)(41300700001)(40480700001)(36860700001)(53546011)(316002)(82310400005)(16576012)(37006003)(86362001)(40460700003)(6636002)(31696002)(82740400003)(4326008)(54906003)(7636003)(70206006)(8676002)(70586007)(26005)(356005)(2906002)(426003)(47076005)(6862004)(186003)(8936002)(4744005)(5660300002)(478600001)(16526019)(2616005)(336012)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 11:38:19.9634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d78894-5162-44a3-447e-08dac310112c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4436
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/2022 20:11, Jason Gunthorpe wrote:
> On Sun, Nov 06, 2022 at 07:46:23PM +0200, Yishai Hadas wrote:
>
>> @@ -1047,7 +1045,7 @@ static int mlx5vf_alloc_qp_recv_resources(struct mlx5_core_dev *mdev,
>>   	if (err)
>>   		goto end;
>>   
>> -	err = _create_mkey(mdev, pdn, NULL, recv_buf, &recv_buf->mkey);
>> +	err = _create_mkey(mdev, pdn, NULL, recv_buf, &recv_buf->mkey, 0);
> This seems pretty goofy, a 0 length means use the length in the
> recv_buf?
>
Right

In V1 will embed here the expected length (i.e. npages * PAGE_SIZE) and 
use it directly as part of _create_mkey().

Yishai

