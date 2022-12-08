Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16B164741C
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiLHQV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiLHQV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:21:58 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FFC6FF00;
        Thu,  8 Dec 2022 08:21:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSrzj1mhTZgq9HpRLZhKWQaj08tK2g+kfEEKt4B5mAXEfXjr0yaZPqa2VhTvIJKyVIMFxEZHexUEO4ebKF1IKfYkajgH0D67vlKuokk6sZtRJTQ+pkB6vKEHH8Kipz5DR/c3ItrZFKawFdcQf6ic7KiaAqDzgByK3U1kjifQ8oOjIi7AjbovDHXENGOgmTUUy/Ycx/yQ1N0hBPA/esCBtdlTvJn3zPp5oBP30nu8HEoHXjAU2b6xemZO9xKtN8/ANHvde0YSNk82j7jXfSawUa62iGc/ltLz66AVpLmeQ/pICJ1KjzpAcxi/J5HeXPfW7fTehvRu1mDOxehX+Uf0+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1JYNWIj6vbT1SFYQ7B8rDtBp9SLyEO0HRlauRBLtCY=;
 b=T2jLEDp9dkCG7mu5VhSt+A491t4f7EYRD9vMsIvZCeSzrrD1AmiLbTW+VN4rTKu3HcjSPtMZrZLGhxWWyh5ZFEi1ArweLm2U1u874rjdQPwYWtOEjAiOKmCIuIa7nxPGW7BC4v1oxMBeu++eBEO1zfriavZnInT1liSf7iOfOJlQy2xINkZnDfnqQ9nArm/sDUNLzJO6VBPi92yRqB5RIETGNcyeAmLIJ9Rzj1u9ZeKkB6UlM6GAk7nAjEWGhIXLg7hTeJrBY+Hbh2KTMkN8X7hn3RriFOgiTy2SFzFx5xjMMR9pdGf+I5JOWocUZg7Ft9Zin54wBBmFm7GI/oRa3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1JYNWIj6vbT1SFYQ7B8rDtBp9SLyEO0HRlauRBLtCY=;
 b=rKoApIa4Xv7knQ7T6ySN7kCF5cUnlN0Pt2JFYAywUmM27PNpSdgyB0Q2S8QqQGHhUeB12qiRkB729Q+g2+D5u2RDNi3YHXjv/ByvWJgl7GqMd6MEslmbbYpjz0zQ7tC2HF0VSjmmxnECAlfrnxOGVX+3zcRobZSdtJh63RqxcvOE2YoYDbDLFLvnul/LsaPf4wXyUrbh2/eGj3Y7UkzCPaG26QtFtn8i4Sy21Wk6JIcumPhiTn0nOdIsp+vX9Q2vkYKTTAYmze5hC2Hyq/XJXlO/VEfeonRdE5sUqu4tKCM8nMZBoFxpPo2sRst0Pz46LaiiBrp2Bs8MXoE/cU/lqw==
Received: from DS7PR05CA0104.namprd05.prod.outlook.com (2603:10b6:8:56::16) by
 MW4PR12MB7030.namprd12.prod.outlook.com (2603:10b6:303:20a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 16:21:55 +0000
Received: from DS1PEPF0000E62F.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::e7) by DS7PR05CA0104.outlook.office365.com
 (2603:10b6:8:56::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.5 via Frontend
 Transport; Thu, 8 Dec 2022 16:21:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E62F.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 8 Dec 2022 16:21:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 8 Dec 2022
 08:21:41 -0800
Received: from [172.27.1.103] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 8 Dec 2022
 08:21:38 -0800
Message-ID: <e96f06a8-c853-73cd-8028-61cbdcd4ca6b@nvidia.com>
Date:   Thu, 8 Dec 2022 18:21:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/2] vfio/mlx5: fix error code in mlx5vf_precopy_ioctl()
Content-Language: en-US
To:     Dan Carpenter <error27@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shay Drory <shayd@nvidia.com>, <kvm@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <Y5IKVknlf5Z5NPtU@kili>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <Y5IKVknlf5Z5NPtU@kili>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62F:EE_|MW4PR12MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 54c58f5b-1ba0-42e4-eabe-08dad938529d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BseEjxNCFDl8izwToJuAvpZDu1N57x/6yXFqlBneSPZlb3dVnofZhOE7jiLsWnArBcmzewz7SQG4i87BDbuXk5JIL4FONgDVQagTnwBfS934ev/0gtbTWo4pMn1FlvflXmD9rbHLZ09o2GOc5qi8d9XMuSl5AJWKt7uldPeZmg+AXseCWVNKyXTsshljsfzbfPqi20lW/XCfqyxygkzEUWfH1HbmE45G/tgIuzLi5KNHxMzcA/G24l3aHwXVXvAitlf/d3iGf5AZ8/pH2bB1HlIov8YVyhVSBoI+FM+HUNQQzS562wGiPprFYj2jcC0kIKXmEmTf9j+sBbPCPWSuz87psclLFLQV1ygkb0lZPmumKVoLhrNl7BxghdJ1HpLDcGZfW4C10QqEmZBDiOYmf/Ihvgx3JhYBjBpaaoBxm90iOmqz9HHHDTH9AlLUaiHhxPYspWKkoBY0oSgzYA6V/MlpYLqmL4ImwirD0ZqG3hZEFjFUbQ/ml9BVdVP5amHXygH8dwUEa916s7HDY4SfmfubbsEwMJrudgq4CdRoGIU2hvtZmXDIhDb7zi4vYmJo6Jj/16XAn2O8gOq4o+soclRtDzA88cDqIM/pbpeJ+jxTj7c2eTfIacNWjRO0qw8LFMhLzg1kxC/SzVSVBk4C2gaUzXI2ZaW387r57pLNayj0GpEyBY2BLkdfIfCASG8M1ObL8QbAehSqWVs1H4px3q/yuzazLKcYH9mBX6mpsSc=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(36840700001)(40470700004)(46966006)(6666004)(186003)(40460700003)(2906002)(110136005)(16576012)(316002)(8676002)(70586007)(4326008)(54906003)(478600001)(82310400005)(70206006)(16526019)(36756003)(31696002)(53546011)(82740400003)(31686004)(86362001)(40480700001)(83380400001)(8936002)(2616005)(41300700001)(36860700001)(5660300002)(356005)(26005)(426003)(47076005)(7636003)(336012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:21:55.2417
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c58f5b-1ba0-42e4-eabe-08dad938529d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7030
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/12/2022 18:01, Dan Carpenter wrote:
> The copy_to_user() function returns the number of bytes remaining to
> be copied but we want to return a negative error code here.
>
> Fixes: 0dce165b1adf ("vfio/mlx5: Introduce vfio precopy ioctl implementation")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>   drivers/vfio/pci/mlx5/main.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index befdb0de32a1..83137228352e 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -404,7 +404,10 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
>   
>   done:
>   	mlx5vf_state_mutex_unlock(mvdev);
> -	return copy_to_user((void __user *)arg, &info, minsz);
> +	if (copy_to_user((void __user *)arg, &info, minsz))
> +		return -EFAULT;
> +	return 0;
> +
>   err_migf_unlock:
>   	mutex_unlock(&migf->lock);
>   err_state_unlock:

Thanks Dan

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>

