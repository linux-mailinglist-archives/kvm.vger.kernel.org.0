Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269E061E1D0
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 12:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiKFLRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 06:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiKFLR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 06:17:28 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88615E035
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 03:17:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=had/0nZHaOuFQxAphdnu9HC3dX+8pKl6v4ahqHTOIldG8CEEcO8W5vYSajZgM3idkkwU0bqJp4z+xEsM8vu6p3/wYNhBKRUKKMZ/1/6M69OywN+te6lFYbyVpcPG0qk4j+3k32F3MeduX1f/uTSrcofPWeqyywffisaiSxJoBtqZhvS6eACxZAv/syu1tmCc0cPGiWcHNH293KwfPgUSZlFb2zkOEuJdh8FEbkgLWjnziZ8J/ZZYES8ev3iLW4jPEuyz8b2Jx6xHfdABLGyayBLCj6Y/+GhNx5znu7kctDRUm8obHc6xNO2odQOjbmlYxZrha2XqtOzRZnr5c4DGdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xC7aMboFblllRGQ2vYgcdq3tovQmu/yZ2Knu5uzlAAE=;
 b=IsUzMoabFFXpTm5iHzLhonA+poh7BXD0OO7kk+cnSU0t9TTx7YUC8+ZfL4Q15KaWR2SPS1z+z+3ZODgY7aOMev/YWvURtsIoxK7/53roRl3HhYsirQNPEjoAqNd5k+I5C/ONOVVnoS0/L5/IGc2K+ddNGVnelzgLgE6CmLaKF/WPpAijCf1fF3A+8qbP79cqtztrCeQkLnpxo3EfupJKJc2aJJTontT6Cz/VkSa3iEcaTwKEYVOAaN90PpmiRDLNlaPgH6oLfoxT2YGfgPR5S2LKBELreQV1/rzAE2tf+ql61i2ZtBZFSzgu11yHD6f7K3BXBlXhLBipRLAhknZJeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC7aMboFblllRGQ2vYgcdq3tovQmu/yZ2Knu5uzlAAE=;
 b=Qbc6xKTLGzSoEHLtLzBwPVqwCsPixkzNQseEcDtERrYxD4lPwcWZzapcAoXsP+ogR1tYIjuka7a7sFNWdl29h5wfHYer7T4qQQTuatjGZ4+f0YAz/i/ZdcXcUaP1sEPlNqWUBUtphsWuEJUJRMObTIlbz3bPsW4zWs25m4L+YMt8GyhjaWHZaE1yeCw0P2O+h7yhmzrdycGAxxEUlOUjB/VAZcZhGkUpilTcBML5Fno1x98f0nSLevwZhzE4bUR7l65h/jFD8gXdtnjSfCkBQKlGWE+ffk9aSoEiqLooWyOulUuRSZVPHVUJX9UHvpk4X0+cNvm5rGs8Iq8CSrNkjA==
Received: from MW4PR04CA0212.namprd04.prod.outlook.com (2603:10b6:303:87::7)
 by CH2PR12MB4040.namprd12.prod.outlook.com (2603:10b6:610:ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 11:17:24 +0000
Received: from CO1NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::f5) by MW4PR04CA0212.outlook.office365.com
 (2603:10b6:303:87::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 11:17:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT090.mail.protection.outlook.com (10.13.175.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 11:17:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 03:17:13 -0800
Received: from [172.27.0.199] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 6 Nov 2022
 03:17:10 -0800
Message-ID: <e48c7980-0e76-3e31-88d8-c7a590887a4e@nvidia.com>
Date:   Sun, 6 Nov 2022 13:17:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH -next] vfio/mlx5: Switch to use module_pci_driver() macro
To:     Alex Williamson <alex.williamson@redhat.com>,
        Shang XiaoJing <shangxiaojing@huawei.com>
CC:     <jgg@ziepe.ca>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>
References: <20220922123507.11222-1-shangxiaojing@huawei.com>
 <20221103130742.1f95c45c.alex.williamson@redhat.com>
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20221103130742.1f95c45c.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT090:EE_|CH2PR12MB4040:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7eeb83-8267-412d-2722-08dabfe87b2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8uFOM9r321VWzlL4nUEVCKzEwhxdANMsHNv8sx9pBZyq1p6LVqAlbROm3TrIH9CaWEHE1IrTfr3osqSN+fm2U+0L/ifrrBXoUESTTCAgfyVcztHkMFCg5EiouRIRSKRccDxCgf0L8RaGsLSWbkYzPAhS21ikN29Yj86v2A81tsGFsFG9Wm1XyzyWdCsWW8g1bSeSc3eA3TO5xIbCGM+ABV+nxaBBLcMzbVSBdLzOfSPbJ0ueQlT/HLSOncfrZCvgQ3iA1esPLml3gscGaCzvkn81ji7iq5+E7RFSV9AOelsPkghNeDgVYVNAnHARA5/Pzw07s3+Gaeb0vIf0td8jl9Sybbx+CnPK8aZVb7QwuohuVZ3udyuDAoQF8jLbc79wMQy/ptPkt9vXh2sA17tui9Mdd1RqykpIv2PbHlrnc6zIwtI84bM5em1Pk3Xk/wLWvOSIFPYfERBKqdLL17IEroBhgFBUvH3LqmdR8xJZMYoKapYlEN6fZCD5zPCBoHIGxKI9axnwUjn12MsfqirXKDACS0bm3QUDwhQui9XsL0dNyY8aY2RVsjK+EnzAWkTzdMzPZUYrr5HAnd6GCqbIhHcHl70asg44aL/rAChMADIWEWck9Fd422YFz08c1hamAHLxl8OYPK2QAFY1QzESOOa/GLFkNRYmYcYp37fFPaxg8T9mGLdkjArPVC4KK4jAU7BqKTjfOemQvPlEKfdRWOnfy9M/NNeyXMxfkxatzcG5dlkP3pNzG94AkI2HUkvuuQo8cJ6OVDbRAY1VacK6gF+mEKrlpw9xxqQN7zrlghdP+cWn7JU0nIW2gLvVaQTP
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(2906002)(36756003)(316002)(41300700001)(110136005)(4326008)(8676002)(54906003)(70586007)(478600001)(70206006)(5660300002)(8936002)(36860700001)(16576012)(40480700001)(83380400001)(356005)(7636003)(82740400003)(26005)(53546011)(86362001)(6666004)(31696002)(47076005)(426003)(16526019)(186003)(336012)(2616005)(40460700003)(31686004)(82310400005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 11:17:24.4527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7eeb83-8267-412d-2722-08dabfe87b2b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4040
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/11/2022 21:07, Alex Williamson wrote:
> On Thu, 22 Sep 2022 20:35:07 +0800
> Shang XiaoJing <shangxiaojing@huawei.com> wrote:
>
>> Since pci provides the helper macro module_pci_driver(), we may replace
>> the module_init/exit with it.
>>
>> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
>> ---
>>   drivers/vfio/pci/mlx5/main.c | 13 +------------
>>   1 file changed, 1 insertion(+), 12 deletions(-)
> Nice cleanup.  Yishai?  Thanks,

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>

>
> Alex
>
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index 759a5f5f7b3f..42bfa2678b81 100644
>> --- a/drivers/vfio/pci/mlx5/main.c
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -654,18 +654,7 @@ static struct pci_driver mlx5vf_pci_driver = {
>>   	.driver_managed_dma = true,
>>   };
>>   
>> -static void __exit mlx5vf_pci_cleanup(void)
>> -{
>> -	pci_unregister_driver(&mlx5vf_pci_driver);
>> -}
>> -
>> -static int __init mlx5vf_pci_init(void)
>> -{
>> -	return pci_register_driver(&mlx5vf_pci_driver);
>> -}
>> -
>> -module_init(mlx5vf_pci_init);
>> -module_exit(mlx5vf_pci_cleanup);
>> +module_pci_driver(mlx5vf_pci_driver);
>>   
>>   MODULE_LICENSE("GPL");
>>   MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");


