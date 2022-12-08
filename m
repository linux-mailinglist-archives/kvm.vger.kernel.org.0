Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91134647406
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiLHQRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiLHQQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:16:50 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2869AE4E5;
        Thu,  8 Dec 2022 08:16:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcwN1dEYDz5zETl5URxwms0KyjJ6BhsvoEoif6KXGFdUZSEaonM07UI4nH/VXQ02QOF94BtdxXNrcfXR6IzMftPLyRxmoDebMejh2XWb5BhuDjwLLzZMza0OcH60LColNQSiiOCh3D7hYfb0xsk31NjcO4ZD3Q0/dK2reyiuw11eC8VIP7upTBJkK8dfzYumaJw7wTprN7Jfa80fM0iH2829mPPEo0puSqnCKp9GkCx7qUsM4R/qpX+jFEvsIeC3JDRCD4CRBHUzmB2T5m4Yk1SPvsSOBRplrzSa9DEy/yvxPR8EeYMN7GkVkzBZP94ZChYIHtMdWk6KKId73Y6Rxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwKdrs3ZSuXo45bLmogcqATJA3vRMCEnL2ZLst62ZDU=;
 b=E/yYllS6Yx+OkPay3Upeo53JJG3oL6EumO5UzBg72013Oipx0Y596aY4cO9gT1hxEHzlD0dLTkopwiRdz5erZVX1DB8Wpv/tQcK8PJMObSzoAO9eTKzxAwgwOuqM9VJ1gYC51KpaeBnTMA4IazIxPE0faY5XOdOZ/4ohQSt8gQSIWLMnrJBfXbfvnJfnP0fBBD33wb9mCqWliY+Zn4Bpj2y7uS2sjl9bbxiSbPI1Dv73f1wurH06qGDhPuExSWBwqOuTGgVP7LPDhFZkCP6dqBFMCTpSLUjRZeHktALWNspFPtcTge7Sa9B2Moq7Boc5Uhw8GmFzj7Aen2lTnykbXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwKdrs3ZSuXo45bLmogcqATJA3vRMCEnL2ZLst62ZDU=;
 b=YGba6iTDzCXRwQHcMNltmnVDL1wOVKbPKKbHewAXcimmYXx3786R6bPdMDtRXKtMFo2PE1hz64n62YTNFgxO/+aZtjXgqjj6T8DMnJ5Am9GmJzadz+tRuWT1fJNhNF+4ueytgimqlDIqrQ/mIwOeZfSQHXM1Rx/dYAwcYDTHs8BNVklva4EIl2P1ROpRzui2omh4hhYYEKiIOXoT8q8QpgM7slC5OiOBX/NwXGYf/yFRvbIg8jhK5yNOR3nCnLyJIzzDHdiHBAtBwnCK/40WAtPYH40cHTlIB5gopMUZR5a8PQK8vjxa8PPkUjvn6DF57kjOeOdLO6qTS9sddCyaQg==
Received: from DS7PR05CA0021.namprd05.prod.outlook.com (2603:10b6:5:3b9::26)
 by MW4PR12MB7312.namprd12.prod.outlook.com (2603:10b6:303:21a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Thu, 8 Dec
 2022 16:16:45 +0000
Received: from CY4PEPF0000B8EF.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::92) by DS7PR05CA0021.outlook.office365.com
 (2603:10b6:5:3b9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.5 via Frontend
 Transport; Thu, 8 Dec 2022 16:16:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EF.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.11 via Frontend Transport; Thu, 8 Dec 2022 16:16:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 8 Dec 2022
 08:16:30 -0800
Received: from [172.27.1.103] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 8 Dec 2022
 08:16:27 -0800
Message-ID: <9ab7a534-a634-b144-05ef-41ae4a727220@nvidia.com>
Date:   Thu, 8 Dec 2022 18:16:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 2/2] vfio/mlx5: error pointer dereference in error
 handling
To:     Dan Carpenter <error27@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <Y5IKia5SaiVxYmG5@kili>
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <Y5IKia5SaiVxYmG5@kili>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EF:EE_|MW4PR12MB7312:EE_
X-MS-Office365-Filtering-Correlation-Id: 653ea865-b602-45ef-6aeb-08dad9379968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: buBg68QWfr/KhDw9o7CNNV8hHxZCMmVGqj5aWOJGN4T+KcadIj/DYWpy54VM/gEdxtWd7NYSgGqHof4vKV4nOTZC1g5rPnVj4yO5mOfH1G4ZZrgoDj//zDBc0Q6uos5oy92MWynzWSNWXkaRf86b8XNQPh47cV2qfhWTbq214QFGr9ZVds16jJxlVgPhQXL96l7ep8GJ/uSgfxG5PEbwEJUR/3afKJX9s0NQ3W4wT3WCHurt5pti0dPNR3SNCMYGGdmn9SjsIjXFfQNVv04+Pkz+DY58EJKJtiJHI3OhrSTwjG5xI1z9p1CjmRoPMrcz23FLoYoggrpjaCRWIJYtJ+oOHDwKLFK9kILCmcz0rF46d8VYPeMggFVdH4suGJENi+ouiU+BEWNHo2xr/ACjRX0JXRjQABeiBimOOumGgrKyAWky5IvQHOhVVEDbl2F5CQkTNr0fwIOwDVHM46p87DzcZeq7ITIvS3b/yzIP0Xyw3K/4dg4755H57ujyie2W3urtJxPqRk/euZOyJfXk0GF8Myppzhrzp9nvpLg78bqSmg5RhJZ8NQtyRk4mf3/0/rLl8EmKVITwOC45bIsPLu2hZ0oG4uP0a59Fmm4vZX0EUI9YexBkVd7axxAYUDndUUndCSYFO/hu0G0Mv3TChDjpFVThzXXmR09K+VnCYgc2tCGwIVXZ40uEpk3GyFKRfBa61OhdjBQEiAIEhT7p4b7pUEYkYdXgdqmNqVMVrwg=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199015)(40470700004)(46966006)(36840700001)(356005)(7636003)(31686004)(31696002)(478600001)(82310400005)(86362001)(6666004)(53546011)(36860700001)(82740400003)(2906002)(70586007)(316002)(4326008)(70206006)(8676002)(110136005)(54906003)(4744005)(336012)(36756003)(40460700003)(16526019)(41300700001)(66899015)(426003)(8936002)(83380400001)(2616005)(5660300002)(16576012)(47076005)(26005)(186003)(40480700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:16:44.4969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 653ea865-b602-45ef-6aeb-08dad9379968
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7312
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/12/2022 18:02, Dan Carpenter wrote:
> This code frees the wrong "buf" variable and results in an error pointer
> dereference.
>
> Fixes: 34e2f27143d1 ("vfio/mlx5: Introduce multiple loads")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Why did get_maintainer.pl not add Yishai to the CC list?
>
>   drivers/vfio/pci/mlx5/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 83137228352e..9feb89c6d939 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -826,7 +826,7 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
>   	spin_lock_init(&migf->list_lock);
>   	return migf;
>   out_buf:
> -	mlx5vf_free_data_buffer(buf);
> +	mlx5vf_free_data_buffer(migf->buf);
>   out_pd:
>   	mlx5vf_cmd_dealloc_pd(migf);
>   out_free:

Thanks Dan

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>

