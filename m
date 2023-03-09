Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639256B1D56
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 09:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCIIIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 03:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCIIIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 03:08:49 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AFA65C67
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 00:08:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e31epS+W1LeqHRNqa9gJrkMYxzz62V3MWlJboNcAxjvcXEwiNP4ilIOwCUPIK6aB9GaBtLbA3ana35mFfRs7Z5Qrr3Q96UPbsLX0IBToHtR+musxmS5vMmDLC97/vqZBj7N1p4xkdfjmnqr15uAtqpJcNpl4NFcmkgLRvbgpTUh+Cb+pWt0E9LLddQkIHlQhQWLAiMIb+3+vQliDujs89Vhm6gmoibdOo5NxeH8atvr7HsLlMUYCaGV4bZGkvV70FgU0Is7rrU6g3VogcVV+5cAMbr9Wlt/7j0EyrgQy7vauhsG5Pm5Kndpc1gaZZZyOsVxbLnjorLKtaNVkUUAVLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lB71E7COpy8zRmA3WNKpWJaEfiF72Bf3IHTydwv0WMw=;
 b=aUDUd0hA1tlvqrlcW7bzcdVe5/MaHPXn0QwqolspGdsk6Z0cVZu/C9XxFjgA1m/XJoF+LpJmMHcfhsHiSqnUnNesHPTs31NzWdEsZmPZUQ8x8BLmiqd6lIXCil9PodG+XYPKgJ9pT/JT9PGhoISB6hYocN1W/ovDPBQTWjGhi8oiiiIYRPIGW+kd337gTB/HVv5cTeADoW5gvH3nq4P7mcyegCqhrI4Ma1LvOTSScCTE3nLUfA3UvHi5xyy4po2bwx75kDxD6FRxnDOj71YQTv0RXwV3Z3kl49GgTEn6QQcaWjUcRXFnnJBq4C8cRUl3d2k7ybICgn85zEwxqTkVuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB71E7COpy8zRmA3WNKpWJaEfiF72Bf3IHTydwv0WMw=;
 b=fXmpssC3XS4tZGU17V/g0vCfl8BApjmOatkIt1idvcIuwn1YsRp2qPke1S9jy2utqa7A9rXqAE9wjNyaQBAtnKFYpnS/kzyljNciRV2X8TogUcneLxhoMqGNlQ8g6OrsU7Osym5pzl+vgthcVwCiM1D1TYaacXd9ava5HTGzobKtgTp0Pqp/KXbfHXq5AiYpceZ1XfoNYJJjDUlEKT8G37HKKzcN5uj1ityY56Y+ZN+o3y1iqnxGrssTPnci6YOKTW9w/z9+sM9+DV91royICvU/oGwo4I9UEMoHEKWEzp6FSIqfIQnPwJn4vIB/lfICuliZk2aL4SycJI/YbVGQEw==
Received: from BN9PR03CA0396.namprd03.prod.outlook.com (2603:10b6:408:111::11)
 by BL0PR12MB4865.namprd12.prod.outlook.com (2603:10b6:208:17c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 08:08:45 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:408:111:cafe::3c) by BN9PR03CA0396.outlook.office365.com
 (2603:10b6:408:111::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18 via Frontend
 Transport; Thu, 9 Mar 2023 08:08:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Thu, 9 Mar 2023 08:08:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 9 Mar 2023
 00:08:38 -0800
Received: from [172.27.13.10] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 9 Mar 2023
 00:08:35 -0800
Message-ID: <0b8ed235-777f-3752-e416-b50ea87f638c@nvidia.com>
Date:   Thu, 9 Mar 2023 10:08:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH vfio] vfio/mlx5: Fix the report of dirty_bytes upon
 pre-copy
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <avihaih@nvidia.com>
References: <20230308155723.108218-1-yishaih@nvidia.com>
 <20230308135639.1378418d.alex.williamson@redhat.com>
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20230308135639.1378418d.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|BL0PR12MB4865:EE_
X-MS-Office365-Filtering-Correlation-Id: de8f93d3-3598-4bfb-ea4b-08db2075812f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: soXdZhOSZCI2E4CT9+0y0fvaKZnLD1YH5RiRrZzikLXr0QSUGbFxXkFMeuiTjzUZektn61zaRVpcoHDGBfJf+QOBWncAxkfjGYHwryOPlAvT0vAADD/cITIAo8tfQyJHXs5+ztASyiOVmp7MjYyVvXSXweRhgi/tUbnmPS6i2M4DNqk7v6RXEh8L5PlgA/usZNARrSrEqc3S/m+VygZHFKRnG86hQDAd8xXMshLQGwjAUdx2ZcVBBYsY35B1CDcXzhLStjUnTxiw3quCjxqMeo1TAW8b8AeVDdxggFpCX5woWR/rnz2iEHcTp+mHcoR0mohNO3jzXpWzMNmY2YDGGvFicJHn8fUcl7WiPxnRG6t1cdgFTbh6i4wtD4wLjeZXNvq4Z0iVPgrjktIABL7bKR1lFssKJUcja2Ae+XKXJ6FsGgI1SHyQtyAW0rcE8D5K+xdtDk5qo1usJqxrVKuqKr06YvU4brct3rWlS3ncxSM3dO572fkbPq23N3Qfak6BkJrMUOZQSL6SnO+TA/iNti5NAO9MEgx3eNCoJBu60LDoVxc5QDMJJBpBUQ953b2tEeNRX28TCuEFh2ntiidroeSnu8TcXRFK/GwStAQjB5Dx/VhvUaSszMgGNJQrLmWlTFYzYaGkUVgOSkS5b5fHRzNr78+NEy2oJIet78iZhbJvmQloErJsKoy6AKGGVfIPvnXl/4twfjGN8/5rSRmPhrs4IWuRDWW8JfHOhBV5QZKLEo3Lkb3u2xWirRUOuCRtQcHz2wanIDKENuTzW+tp8g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199018)(36840700001)(46966006)(336012)(47076005)(426003)(31686004)(16576012)(316002)(54906003)(36756003)(40480700001)(86362001)(31696002)(82740400003)(36860700001)(7636003)(356005)(26005)(53546011)(107886003)(83380400001)(186003)(82310400005)(16526019)(2616005)(8936002)(5660300002)(478600001)(41300700001)(2906002)(6916009)(70206006)(8676002)(4326008)(70586007)(14143004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 08:08:45.1689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de8f93d3-3598-4bfb-ea4b-08db2075812f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4865
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/03/2023 22:56, Alex Williamson wrote:
> On Wed, 8 Mar 2023 17:57:23 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> Fix the report of dirty_bytes upon pre-copy to include both the existing
>> data on the migration file and the device extra bytes.
>>
>> This gives a better close estimation to what can be passed any more as
>> part of pre-copy.
>>
>> Fixes: 0dce165b1adf ("vfio/mlx5: Introduce vfio precopy ioctl implementation")
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/vfio/pci/mlx5/main.c | 14 ++++----------
>>   1 file changed, 4 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index e897537a9e8a..d95fd382814c 100644
>> --- a/drivers/vfio/pci/mlx5/main.c
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -442,16 +442,10 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
>>   	if (migf->pre_copy_initial_bytes > *pos) {
>>   		info.initial_bytes = migf->pre_copy_initial_bytes - *pos;
>>   	} else {
>> -		buf = mlx5vf_get_data_buff_from_pos(migf, *pos, &end_of_data);
>> -		if (buf) {
>> -			info.dirty_bytes = buf->start_pos + buf->length - *pos;
>> -		} else {
>> -			if (!end_of_data) {
>> -				ret = -EINVAL;
>> -				goto err_migf_unlock;
>> -			}
>> -			info.dirty_bytes = inc_length;
>> -		}
>> +		info.dirty_bytes = migf->max_pos - *pos;
>> +		if (!info.dirty_bytes)
>> +			end_of_data = true;
>> +		info.dirty_bytes += inc_length;
>>   	}
>>   
>>   	if (!end_of_data || !inc_length) {
> This is intended for v6.3, correct?  Thanks,

Yes, thanks.

Yishai


