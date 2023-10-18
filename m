Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F817CD69C
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 10:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344713AbjJRIdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 04:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344708AbjJRIdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 04:33:07 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2076.outbound.protection.outlook.com [40.107.102.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B2F100
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 01:33:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gto11121bey0bZhj4C2thdKdMRxJms3ZLfv/0k5p5uV7Dd6KozD7DS8NuSnhWihKsW7aiIsF4wUS1KIbRoshBbJgXG98hYwoyd2zwuvE0I0uQJDchBUwQ9nOPS4I9OgQ8YGEy17DChMSoHSdpm3CUTKBzE5XUgkgPvUKWSX8IYKkRrm3WqwjQOTY1fx8GQenxx0Evl3FTRjzpgThkLY3XfStIz3jXyFC+8IDPa6O827mew25c6/0aXjXC+dph5VmQ63htgvY+emxpm2mtaFFZzG3t8v/H6ExaY5kxQ2X1yPs3sZ6/xQEr77wXz6lsu48FMoHH9+v8jtpVJHPPO9ZuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMKv29bTGS4j9kuawqlEklmAfs13HaKivBIlC6lCtY8=;
 b=VIUxfV1CshpikXPUgwgejcqmzZGKIgNgRYDNfINi2ZtTJxYv9t+KQ49f+rRNwMgtTBT2e58b15/19F54fjKF55zMl0HdZjaUQyVxFOk6dGLJKvrvBpuhAxtUvBUZbpBzHCNa4jhB6L6ZrdAf7+hIhoLl7gWzWFV2us3j3Lb5Khev5YWSC25k5Xag5+zvTBg4FTKtDhm2CAaM3BNeEwt1bffQ8wxJsljSgr/txDp47hiKhfx28Jigizen95eICfB6Oah9djML6irrJIcSE/g61a2dbCjSc5otq0PvdeIlUV9TGfc2cn6shHl6vIVFV8shJtHwxr6tb60oFdlo1ocpkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMKv29bTGS4j9kuawqlEklmAfs13HaKivBIlC6lCtY8=;
 b=OVRFomhV9M0NUKLnGsiDEp7Y9enIFzZHvGvv40axDRZXQkpJLFC7wk2yBwb5Ut7079XqSSyo9RhuJQkdop5b9yNrLTwoQYvHCoJS0WZGipNK6A6m/J4rsjX1bK4kOf6qUgdSOCNPOQ+Wbi6lC+Gx8IGZIEeMsXA6gc1oDVBU1dI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 BN9PR12MB5082.namprd12.prod.outlook.com (2603:10b6:408:133::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 08:33:03 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::726d:296a:5a0b:1e98]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::726d:296a:5a0b:1e98%4]) with mapi id 15.20.6886.037; Wed, 18 Oct 2023
 08:33:03 +0000
Message-ID: <b7cb98c2-6500-1917-b528-4e4a97fc194d@amd.com>
Date:   Wed, 18 Oct 2023 14:02:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 18/19] iommu/amd: Print access/dirty bits if supported
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-19-joao.m.martins@oracle.com>
From:   Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20230923012511.10379-19-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0079.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|BN9PR12MB5082:EE_
X-MS-Office365-Filtering-Correlation-Id: 11aa386c-c4ea-4d0e-6924-08dbcfb4d81d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Og9tZCPwdNrHTT23+LoeGKNmmgDNrigfNrvTMwgRkrK4/rvTZUpLQjXH6iuTflj19VLwEF7ONQRiOaJSXfshu+47TI1r4HmGPsSNApeo+sQQdaTqNOMwsnuiss1DonkfY46hmPqT9kXeTKTwK7bFf6sBxwikyoufhMdYvXPR8w4iIRJR+MyZJraweIWO7fA0UMDbz+NXyr1rfBhKWAjKeQ5AOPMf5EHfHlEl81A4MnLCN1VKni6nJnX+rZQNWf+hFYEveREUN365hqAZfVSncVhg7hPsDzw8168OCjl0DiKosccEF+71KHXykOIVA8CrpZokO37c6WJ3ux+vFZGRzueiU9UVDU8xCb00iF8Ek9++UlVIsr7xcw8ZGKTurImG3Fc0se9pFKmnOpRkdKi5GDNm8BodE2LYJKYgwqMvBSPWZLWiWa6bD9noFQriibPEsqZPOpXTT5VoELy/sj8gl9OXUgrOYHS0utbvQ+xRe1rmDTyQ7U/4AJ15/cG+spoEPDyNjf9KnZkAyGh6X9GozidALq9bRPmKCMGVWIEHQyGPI5BZdh348m68zpCh+754hyWIXoi00vgMFqasYNcg6sqKNh0BqEW/VwNfe5fMBqZYjt4Kai9zZs3JnLj4psM0ZJccFogq6nhfqwxERZiyegM6SEAo7zZcl4Fhn8fTarc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(396003)(136003)(366004)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(26005)(6506007)(2616005)(6666004)(4326008)(53546011)(8936002)(316002)(44832011)(5660300002)(41300700001)(7416002)(2906002)(4744005)(478600001)(8676002)(6486002)(66556008)(66946007)(54906003)(66476007)(86362001)(31696002)(38100700002)(36756003)(31686004)(6512007)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEg4ZUJuNXYvQVY5MEpzU1RZam5NTEVoOVhZSnMrd0tZaWhEQ1A2SDlQcWNP?=
 =?utf-8?B?YTRrZGlWTzVmcnR6UFNrdXBKMkRXRnlhcUg2TmhNd0w1aUxjajZsbzU2aFdw?=
 =?utf-8?B?QnY1MDg3dXZXdmR5dkd5Vkc1aDNWL3VGT1MxWXRsempvbGxKZnAvTmdPMWVk?=
 =?utf-8?B?UnV3cUpUWTlzdnhMMjNRZ09EZDhCZ0d4RlBsZjd5MXJZRlRhcW5NMHBHOCt4?=
 =?utf-8?B?ZklQY2ZVRk8rK2kySVpUUlA2YlZIQk8wbVhxa05sZDF2K0NjZ3poQkUwUjVB?=
 =?utf-8?B?Q0dkdUN5U2FETHM3d1FkbzRXa2MxKzMzT2JCNDhCRGdVTzBodjQxMWQvWHRP?=
 =?utf-8?B?cStqdWlVZFJ2TDRpclNuVTVkR3JETnIwelFuaUgxeVdjQjEvdTMyb2JuUnVQ?=
 =?utf-8?B?Vks3b25FSzc3S2VVeWVtVDgyYzAzaU10c2libkZvdnBRWm1ldjEwbTdxL3E5?=
 =?utf-8?B?NzBxcjNZYk5wb2lQZ3graEFNSm5TdlZoMnVEb2EyL0J2ZnlEV0k5Ry9TQUkr?=
 =?utf-8?B?Wjk1WmdxOTRaZ2VpTTRicS9Cc29aN2t0eXlNMlMxYzZyc1Q2U3NPak02Vngx?=
 =?utf-8?B?a2FJTmRNUUdFZW5nRzZkcWhZSVFNU0dOWWNDeEd5MmJlUlNjZHVheEE1UFpF?=
 =?utf-8?B?TUdjemVoVzIxc2VLMFBTb2p4OFBadlBmLzFnK1JkYkp4d0dZZnhVa2w5MGdH?=
 =?utf-8?B?WVVpdWQ0Y3g2NTNRNlYySlBDZ1J1VmRVT2lKWW12RzF4RXNqeDlzTFpiTlR3?=
 =?utf-8?B?elFwVGRLQjBqRktORzN6ZDJhYUpqaXNpejhoRjQrS3FWUFJBSHAwL3ZrMlJu?=
 =?utf-8?B?VXdpYmFlQ1NJQ0JCN0pwTDNYNE5vMVhkMjRuU1NTSG5HUEw2NmxZZ2FuWnlK?=
 =?utf-8?B?YmQ5OEd3QXg1ekpySEJkWVR4QmF0VDJVcjdBVjRLY1EzRHlxOFpPV3ZlTFlQ?=
 =?utf-8?B?WERxWVJYS3Rzem5CR2tETFhGZ1FOcnR6QVo1ZGpUblJpb0lJOHdOZHp6REFm?=
 =?utf-8?B?UVpqZm1iVkYzWkZtdkFEYWJIU2tqdzdUWWlYZ0xjRjQ5NWc3dS9mRy9EZXZs?=
 =?utf-8?B?ZkVzQ3c3SS82N2xZWGZLaW9GY25keVQyS084WU96VG9OaTVYdFMzRC91emhO?=
 =?utf-8?B?eVk4VVNBYWd4UTFuZDhYTkw4NVRGOUFkRENEV1hQc2xLNk10WG15UmZjYVV1?=
 =?utf-8?B?K2ZGcjY3M0Jjd0lBODdIZjFCOFU2OEdIWUpJOEtwM2VPb3IwYnU5YzA0bENu?=
 =?utf-8?B?b1puRnQvOGVEMzAxQlJXcHNtWmhGSXZpTnhCdUZIemtaK0U5Q1dNcVYzUytM?=
 =?utf-8?B?K3U4Y28zN01OdnhPQW02NVROR3kvQzY1d1NBUGxUNndWR0grQ3lwUUhzam53?=
 =?utf-8?B?WXJHcUg0Q3BUYUI0MStkQ3RNdURYWVh0VkVaeVpKd0pFZWxjMTl2bmliZllS?=
 =?utf-8?B?ZnJKVkprREhZNlREUW9zRUdpRkxGU0RHUTJUbXUrb3RnT2UrQmtSeVhCeU03?=
 =?utf-8?B?bFlzY1kxclMxYVNIaTAzZ2Vqc2FYWjB5UldkaDVrWE5OYXh2andCSWxiMERF?=
 =?utf-8?B?RHdoajB3OXpJQ2hTRGpaVHZNcVFNbHdFTVAyU2ZLM29CalRYSmVoUVAyZnZP?=
 =?utf-8?B?YTNDa1VNVGEva29QVzFGMVdYNEJ5SlVkSnQ1azVoKy9KSmhKc2V1ZHlZZmtH?=
 =?utf-8?B?QmJYZ2djQVlVYTlkVGtFcFBtakZ0RU1rWEdOUTFYazRzdnh1Zitzd0NzS095?=
 =?utf-8?B?bmgyaUlyUlVqd3ZwT3V2bHphcDhVU0xsZGxvK1FjSzdpNmljZWJxbHEycE44?=
 =?utf-8?B?OElTZUVlTGVoOFBRM20wZm83NDcvU2lIVzNYTG9kWW5HODVOWXFJRXoxWTlU?=
 =?utf-8?B?bk1USVdSNjZRK0RxSkJtbzdPSUljc0RvNUtUVm11V1RsbGFMNmEwMUJ4R3BR?=
 =?utf-8?B?SWk5VTUvT1l4WEJ0em9jUDJiUktScGR2WmRXWk00VjYyaXZEOUpFTGk1eWpq?=
 =?utf-8?B?a0lId2pHM2xKWkppR0xHNVJ2bzE5NDdZZWVwMGVudEM2NDkwL3IzcTR5K0FT?=
 =?utf-8?B?NEN5ZjAvK1lYQVRyZjlHbllBRXZiNk1tbVltekNvSjF6Ri9RMUNDOEF1VmpW?=
 =?utf-8?Q?YCyK8A8p3s286dVefxvHp+PgG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11aa386c-c4ea-4d0e-6924-08dbcfb4d81d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 08:33:03.3439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZ8XIrnVXjGENRLzQMp1Y/If+TmT0k5OPN+/mteHpC0palwRocRkfqtEvDZBkjo0ApNu5y6Pc4xkXw5+9mvDwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5082
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Joao,

On 9/23/2023 6:55 AM, Joao Martins wrote:
> Print the feature, much like other kernel-supported features.
> 
> One can still probe its actual hw support via sysfs, regardless
> of what the kernel does.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/amd/init.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 45efb7e5d725..b091a3d10819 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -2208,6 +2208,10 @@ static void print_iommu_info(void)
>  
>  			if (iommu->features & FEATURE_GAM_VAPIC)
>  				pr_cont(" GA_vAPIC");
> +			if (iommu->features & FEATURE_HASUP)
> +				pr_cont(" HASup");
> +			if (iommu->features & FEATURE_HDSUP)
> +				pr_cont(" HDSup");

Note that this has a conflict with iommu/next branch. But it should be fairly
straight to fix it. Otherwise patch looks good to me.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant



