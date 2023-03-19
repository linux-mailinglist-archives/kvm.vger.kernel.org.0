Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E876C0139
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 13:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjCSL7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 07:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCSL7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 07:59:48 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFF419C46
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 04:59:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Irw87ewtEt0rpLyPxeyWDN9pXwEz9/Zr0NO1fUqdFhNHeh64KYat+Lz6L3BKz2fJHwvDqxjxiVVuTmXw/bfU5z5HgC/X9W6qdBt7V/++osP97LOpqIsewE3+711ZNRlnRQ/iuXkAGJIzXK2AqVuolg9HlY9V/oGFjhiKUQX1XUoxYH9qKfzPl/RCshSDI/FN7l+cjb+Ae5F0DLXFhC5/C2dA0Q80tByOkqmKiDDxHAVqMy1EbDteK21ZpUQeSpX+GWlhcUzZEvbzN26seSlDXXuvfmfMyFxRaAz/X5LvyJFyE4i2MCveQmkesHTY/pTjeDz2YZzIvj6vp/DTCXszXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eaMea2uli/R3ZC/nw2kRs8Zn9lpbXdRlmdFwS6ixJxc=;
 b=T+VmMYvsPwWqe31g2p4gPucGMYKjd/H9FzH6SniOLYtqyOxjrYJ72mayt/7uRtY6rvNCunQ6o5Ecqh15JlwbUzlJGSCwD667aNP9wmF9IbHKBTMnTvLm31/wcf8avDVrYFikmLFqdapQXjpjz1IsY0HV7czLUjA4jJuYZSkGqVBqR9wUlI5CmIpL/hoVjxoZkashEg+RqEZ8BGmLZAF8Pi2yF8y5GsrEIfEweQAwB5gdcEU1yIC8H48LQiMhd44k/9eJFi3eEOjGmhoRcd6M+BWgOdW3Ue+xuKNZU5k2+vxVixV6TogyPZbeFTYB4DjpDHXbZbEiO+pQD6xOS+jH5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaMea2uli/R3ZC/nw2kRs8Zn9lpbXdRlmdFwS6ixJxc=;
 b=XT9c3Wv0N/fhb7QCX0Wv7da+/uPJZ6bv/Lgf6vs5awWZbKU8pukSx3sFtfaYUzkGl5nsGXbGST/8RQcTOSd5NSner4QEWAPJYT77HAqOfrvZLh/AVGAk9I4EL/lOdMxTok6ETEL6Z92vTLDXaPDsrpkdWK35qjwQKi/KRi1HBhBGykldxXmiJFh+AFrGDuV+gnaTHrKYulhPv7ezIr9iY4FfZMXSQuGOK8nipqjyVRSni33n6wNSCEiue5F71Uz9SWrq35wHGpWQgqCwXzfZb9gjm9V1mD7C5i1CUFfbf2oKbiJs1cxUFW5fiN+Uq+JxHEi1t7jwp9gDkGYvku8s4w==
Received: from MW2PR16CA0064.namprd16.prod.outlook.com (2603:10b6:907:1::41)
 by SA1PR12MB8721.namprd12.prod.outlook.com (2603:10b6:806:38d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sun, 19 Mar
 2023 11:59:44 +0000
Received: from CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::33) by MW2PR16CA0064.outlook.office365.com
 (2603:10b6:907:1::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Sun, 19 Mar 2023 11:59:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT113.mail.protection.outlook.com (10.13.174.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.11 via Frontend Transport; Sun, 19 Mar 2023 11:59:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 19 Mar 2023
 04:59:35 -0700
Received: from [172.27.12.5] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 19 Mar
 2023 04:59:32 -0700
Message-ID: <e55a6d9d-fcad-4c27-830e-9b1c66aaf04d@nvidia.com>
Date:   Sun, 19 Mar 2023 13:59:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH vfio] vfio/mlx5: Fix the report of dirty_bytes upon
 pre-copy
From:   Yishai Hadas <yishaih@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <avihaih@nvidia.com>
References: <20230308155723.108218-1-yishaih@nvidia.com>
 <20230308135639.1378418d.alex.williamson@redhat.com>
 <0b8ed235-777f-3752-e416-b50ea87f638c@nvidia.com>
Content-Language: en-US
In-Reply-To: <0b8ed235-777f-3752-e416-b50ea87f638c@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT113:EE_|SA1PR12MB8721:EE_
X-MS-Office365-Filtering-Correlation-Id: 77794411-3e0e-47a3-024a-08db28716e22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6a6ZGtERz1J9C6PocjY4EF176VH4KdQuPXIyoZzIcQcdszOtmLnK2ZaMNP4BcDzPtSPG0W61YL1U8i1N/V5F0aryK4ar+MHRYw4RW7VW/ldmL9dWkguIFj+ppgaBvATZbFTO8gLttwKuwOAhtWSy/d5wzrtuPV6Fr45UyxMy6/sRC9NS/IHTkq8VFiB4IIdlEuCpwDQQ/HbejfePrXr1cTCpy4ZlU880z/kt5MhYIOE2G2sI/DzI+B5VYMxFqU8qg0FX5sSadul7MAnKX0U4WkRP2fLrZvSlNu7qjhRwFm/gk2vVbHi7XjUsqFYOP1ix5toxMAUZhcrx0KRg/tp5JahK/pR3QZMbG5/fRTRv9C4Dafh5D8XEnJ/Eb7/ZVOGrz3glVeR/VX5tEuZgFwPb/GfnGYdDXx5P+u0KaPiJkAK1N5Ftsw8y26sjCoqmH7llu/ityL8xgfCJH++fa0fDwEECz+1M1BXTt7yhUf82SP0T9XdUgZrbmJwUy5nwoLrT0Io5JwMazw25i380BYT31V4/uEd8vmcaKEeNqf8Yx2hFywtOSKqRCFEsm1Wkze6ZiIvF6ptyZLDA1uO1I5OZQ9W5z5Hk2DZ4zhv4gsdoMSJg0uZ2aO5zQN2bYsVg1XGTdZSa8IIhFzxZ9MbnVbgcLyJJ3Q0ZYsY/JLNQvV8P0Sr1uRbjXxpBHcE5VrWTmER+AHb7MuJFGmBHAwiPObUS1GI4mN8JqPndzjsTIvujb3pksKUulzFUJgalPeYxnxTN5krKkv07dFw5SFL75eSK/hjE+XZ6Nw/cKOnzLySDYBfPvElKLzv+fCpKfS3k0Z7s
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199018)(40470700004)(36840700001)(46966006)(2616005)(26005)(107886003)(16526019)(31686004)(186003)(47076005)(336012)(426003)(16576012)(316002)(53546011)(8676002)(4326008)(70206006)(70586007)(83380400001)(54906003)(478600001)(8936002)(41300700001)(82740400003)(2906002)(5660300002)(7636003)(36860700001)(6916009)(356005)(86362001)(31696002)(40480700001)(36756003)(82310400005)(40460700003)(14143004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2023 11:59:44.5632
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77794411-3e0e-47a3-024a-08db28716e22
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8721
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/03/2023 10:08, Yishai Hadas wrote:
> On 08/03/2023 22:56, Alex Williamson wrote:
>> On Wed, 8 Mar 2023 17:57:23 +0200
>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>
>>> Fix the report of dirty_bytes upon pre-copy to include both the 
>>> existing
>>> data on the migration file and the device extra bytes.
>>>
>>> This gives a better close estimation to what can be passed any more as
>>> part of pre-copy.
>>>
>>> Fixes: 0dce165b1adf ("vfio/mlx5: Introduce vfio precopy ioctl 
>>> implementation")
>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>> ---
>>>   drivers/vfio/pci/mlx5/main.c | 14 ++++----------
>>>   1 file changed, 4 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/mlx5/main.c 
>>> b/drivers/vfio/pci/mlx5/main.c
>>> index e897537a9e8a..d95fd382814c 100644
>>> --- a/drivers/vfio/pci/mlx5/main.c
>>> +++ b/drivers/vfio/pci/mlx5/main.c
>>> @@ -442,16 +442,10 @@ static long mlx5vf_precopy_ioctl(struct file 
>>> *filp, unsigned int cmd,
>>>       if (migf->pre_copy_initial_bytes > *pos) {
>>>           info.initial_bytes = migf->pre_copy_initial_bytes - *pos;
>>>       } else {
>>> -        buf = mlx5vf_get_data_buff_from_pos(migf, *pos, &end_of_data);
>>> -        if (buf) {
>>> -            info.dirty_bytes = buf->start_pos + buf->length - *pos;
>>> -        } else {
>>> -            if (!end_of_data) {
>>> -                ret = -EINVAL;
>>> -                goto err_migf_unlock;
>>> -            }
>>> -            info.dirty_bytes = inc_length;
>>> -        }
>>> +        info.dirty_bytes = migf->max_pos - *pos;
>>> +        if (!info.dirty_bytes)
>>> +            end_of_data = true;
>>> +        info.dirty_bytes += inc_length;
>>>       }
>>>         if (!end_of_data || !inc_length) {
>> This is intended for v6.3, correct?  Thanks,
>
> Yes, thanks.
>
> Yishai
>
Alex,

Are we fine to proceed here ?

Thanks,
Yishai

