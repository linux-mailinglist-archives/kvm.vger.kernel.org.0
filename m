Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1292B7D00DA
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 19:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346247AbjJSRsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 13:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345163AbjJSRsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 13:48:37 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D190F114
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 10:48:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLZpMvPy/JraLAgLFMmcGt+yjrjktKH3dJUm0lZY+edCZWiim7c8IrvuM1qV54xh9uWl13otsAzaq6bD9H5vkrVEerexA8mQHAKiU+AoIv6t14aC4JXex28/fBIxVyHnOmbjTJMPDMziqiTypF8EUBfYQHC9xD7/4fVmWGjV7dRZhHAiy/iT8FS+bN3FuG9VRJiKX+VbzfUY1+moG1z8svEvxHgD5N+nrlJre/VoQW7nXLbCmwROli7+yekMoQxccv1160GW9VCAz5JOHW2LXeKqg6BCf2PUC/sk8maFZd1r5lZCNO+CHA+cHffA6gdfEMIjo4aLPylDwy9jC6nbKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcCtMMtyAg896EE7hfyUPr8tqEHyw4AtvUAfocRODKA=;
 b=XTU0cSB3/ZQwga8Sp+dN5CR3dsUY+gfIGA5K1wW1dj56uZqxNjmFTsvbJEf0YutYN3b0gnDVjIbpfwzH+JrAsLJcDMLuRjJFxiJAGg8JzPJ+DvcLEwsIs43t5qPTU+1j5udauZRkOa+56xm5IJKvmnfZ5no4A/dMCfVNRwJoplYk5dQkQjjLpvp70RJ5HCaHu4WbZ1FOuuyot1BtOypvYoaeAxcTasiM1OA38CJ38JW6RtES2RCzNalunEotgaWz/u7UOkc1bHfXjWkylR43fHad1oZa5j+UatQdLJ5pbhfOEVsC+9iqeau1NX451oc1sccjJbi2vQ402y48hXdq/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcCtMMtyAg896EE7hfyUPr8tqEHyw4AtvUAfocRODKA=;
 b=3lDt/iiNaFuNlYKGpcGX2v/cAi00Rx74lhOQwT9ifCJOo8aMYNuVJas6O72hGInA/6g0gtJcC2IBK7Qw1gd1WpaQAJKEoHHDN7ww6/kZlqu6l7ikiwTWWm+BfLWMXe5Ndbjz0W4fEl+kVrRfbdbtJ9YjLyLxnT6LQEXbC/rDWsI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CH0PR12MB5251.namprd12.prod.outlook.com (2603:10b6:610:d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Thu, 19 Oct
 2023 17:48:33 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::8859:6c1d:e46c:c1b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::8859:6c1d:e46c:c1b2%5]) with mapi id 15.20.6907.022; Thu, 19 Oct 2023
 17:48:33 +0000
Message-ID: <a1114743-390e-b55c-b84c-30c7f6e26b31@amd.com>
Date:   Thu, 19 Oct 2023 10:48:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 02/18] vfio: Move iova_bitmap into iommufd
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Brett Creeley <brett.creeley@amd.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-3-joao.m.martins@oracle.com>
 <20231018221454.GG3952@nvidia.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20231018221454.GG3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0062.namprd03.prod.outlook.com
 (2603:10b6:a03:331::7) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CH0PR12MB5251:EE_
X-MS-Office365-Filtering-Correlation-Id: 13f31d56-ea9c-4ecd-3400-08dbd0cb9cb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N1i2F34YXPvgd3iCjrfbLQuDWPWQuZVBbf5nXymOwb8iEJbXH1O83XtIwDNrszMnnBDA0IV5HIz9CCr2tL6lXaxyY4W40r8A8X24CieLojWdzv53c+8NCg9lk/2+GO7bcm0LUZ6+EV1YgLERw/r6NaXoIxasiuwg8/LavB79DAhsNSXSX0E9ZRZ7dicuZ28CGTuNDE3xSOXdWKJ5H8yKr4q/FzBXAu/+BZlDmJEiRNj6He8LLUyb0Ra5g3BgARTfQT8ng24TUuauYdRmE7o8tbjnq0/c+L4bt2immDZpiXuF4cUOk/leAEO4wdFPXJblNFwLZBtYhCsHppcJcTOybpvB+jY35TcTqMpDd+/hBycniBqpNwe/8M1zZ/QeQz0x2mXgahb4S3FKzlzqD9rPGqMhaHyYpgQXIzUhbhHFGbZEyQqYI4782vNW9oL+CWtebvWdvyf2uqNNcmrCzBy6UjfF6Ekw79ydoELXWSfLU+EYC0PCEgiStu0C4zrowoBE0MOc3K32Du9AMTP2KT3EHvqSWWOoU0YRUvKILgyow9KTKQ3TC+YvywY0NH3quy95RV352V3fw/xnkTEbtOkzsb6c3hm5fawCGF/2AzZOOMRuc4eY80l+8KPowX4NXyQslEroudrzJ6NVLseqpjA3KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(366004)(346002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(6486002)(66476007)(38100700002)(478600001)(2906002)(66946007)(54906003)(6506007)(316002)(66556008)(6512007)(7416002)(8936002)(5660300002)(41300700001)(8676002)(110136005)(2616005)(53546011)(83380400001)(26005)(36756003)(4326008)(31686004)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3lUVTkzRDFPbFVxOE9KV2RaM2I0b1VWVmFTbmZlL1dNa1FYMkZ4T2RrLy9p?=
 =?utf-8?B?c2NuRmcrU0NrL3FyWVF1ejNGbTJNaENNM1U0bGVGZ0pNOUIvZWtVejFBYnlK?=
 =?utf-8?B?VXN0OURvcVZydXpHTWhMa3FqY1A4d21FbXZkUDZGcS9IMXZHS3NaOGh6U0xl?=
 =?utf-8?B?SUhoQ3RkRGZldjRtUTBnRTNidzE1cGtzSDRDR2d2Mllhd2xwejJkNzlURDFU?=
 =?utf-8?B?T0pFTExFNTRzUUpJbVVxZk40SDZ5ZXdFWW1PUndSWU9QeGNuVWVTT2ZpQTNu?=
 =?utf-8?B?Q1pRNk5RUTR0ZmNSMVRyUXFsOCs0UVBRN0tvRkMyZkpEVkpSRjlWWCtPMVd0?=
 =?utf-8?B?U1lXTWNyaHFGTitybW11L0cwTFY5eTF0L2Q3aW5KNW9VWDl5dXFmSWF2VWhu?=
 =?utf-8?B?VTVmRDJsWDA1RThFRVQrNkV6ZXdzV241SGFtZTZaU0t6enZtc0phNUR4OGFT?=
 =?utf-8?B?S0pCMWxpSUJ2RStnaUdTR3pJemg1VEVmVXlFb0pkc282bVpQY0NXajk2Q1Yz?=
 =?utf-8?B?M3E3N29EUTRidFdpOWZ0cGFtcGJ4K05xR3NscmpyZE5Pa1FGV0J6U1BUbmxv?=
 =?utf-8?B?RHJQWmdVWU5ibHlGUGU1RitONjBqQ0NmY21SYVhTSUhmZVFQVzlQamFDMXpu?=
 =?utf-8?B?aWpGUmM5QkkyeGRCSlNuY0pMOTJBdmxHeC96MWVTUkhweGFRbGo0b0VGVXhZ?=
 =?utf-8?B?d0NqNStzSTJNWDdPUk9aWS8yTVpTaDRnRmZ0bVV6VFBMNXAvZlAzQ1UzQ1J2?=
 =?utf-8?B?S2pJZ3ZPb2dqQi9uUk1NdlVDcFJ2cmpFWStNVGtxTXJpT1lDY2tZSldKelVY?=
 =?utf-8?B?T0RpMHhtNDk5eWRBZEJlV3IvTndMSldGZ1U0dmNRS3g1a1ZuZUJPVTREOTBx?=
 =?utf-8?B?ZVlaRzNMU2R6enR3QklHN0FkYy9YaVFOemdxUnowRDBvNHIza2RVT2UvdS8z?=
 =?utf-8?B?Q1RUZ1gxdG1CdlBUWktuNWl6bld4UHRJMmpmQktEZFdMSEwrYzBRbk5nZmcy?=
 =?utf-8?B?Y25yZHpqQzFVbGpNNDhHT2xPNnRmc3BESDRlR2huY2ZCQTh1ditVeFpmLzRo?=
 =?utf-8?B?TGtNV0FNNTVIRWlOTWVZZTZmVGV1QzhzNm1mOHB4Y1NEVUlzOXl1QmV5TzZP?=
 =?utf-8?B?RzIrcjNLbmN3bnJBOW1mS0Jqd3RuSVNTVWNtdUk2MGpLS2lYUEdpa3Z6Yjlr?=
 =?utf-8?B?bU00dkVzMHRxK3JPNGZsS25XcGxNVTdyVDFHcjdVU21JZHd6WDJIK3ZtTCs3?=
 =?utf-8?B?TGpUTVRwR0k2Ny9wNG5xa3BZd1A0MlpMQkhyQXZ2Ky9tcnh4eDU5R1lQZWQ3?=
 =?utf-8?B?N2IyUXF3V2p0MGJIa3dTRUFGSUdma1hCVkFnOFg0b2pkNjlIanBNcGIrbDFL?=
 =?utf-8?B?R1J2OUo4OXRpb1JwV3VPN1lrOXEybEhKcWl4Q2x2dnFlMFVQeHIxUFFiNDFa?=
 =?utf-8?B?SG5KSERHYUUxRTVVNWZvVW1DU29TOUF5elorV09hNXcwSXZpaDBPMlRwdzNX?=
 =?utf-8?B?UXFMU3B1enNXOHVzKzdhVjUzOTNpRnNQNVF5alo4YnVZYmZUdGhqUnpYL25i?=
 =?utf-8?B?VjJuaHYyWWk0YmNzUVJFZjYrNk1scnNZT295T3VaWXpOMkJXRHlzZEtuakc0?=
 =?utf-8?B?WG5YTHFoZUlSMG0yTzRWVVNud0tFNHdTbzRGMGg3emZFa3UvaDBKUkVibWJo?=
 =?utf-8?B?ZnlESkRGYTNzQzVuZjVSdTZlcnl2SnhCYkxhaUIvK29sZmtmZ1pLS0pzU2Vh?=
 =?utf-8?B?ajZ3ZXhWRU9UakxOY2VaWi9vd29xWXptS1g1eHI2NXYwdGdHalp0cjlnbTJm?=
 =?utf-8?B?SkoxQjMyL1c5VXh2d1VVTURWWkJmdnlERFBSekRULzR5V01UcmV0ZTgrUmFT?=
 =?utf-8?B?cUpVWm9MT2I3OGE5a3hQR2liNUh4ZkNWQzdCM2lEdzJJYUk4MDBBMFpEbEg5?=
 =?utf-8?B?WW1tRU12RUpmRElyNXVBNWY0Y2Z3TmJBV1A2dDJLRHhreVZsYWYzZmcvUkJ3?=
 =?utf-8?B?Q1JqOUJCNjhkOGlld2xBUkFQREZhWEZlRWRmQ25ESmpNdTlWRjN2TmVoZVdq?=
 =?utf-8?B?Vmc3b2lDNjU1N3p1WksrdE9jVmlRNUdjZ2Q3MVJPVVNuU1EvQ1JLQkRLemZZ?=
 =?utf-8?Q?oNGT0f4tX8IcT7eyuVfnfYVUs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f31d56-ea9c-4ecd-3400-08dbd0cb9cb1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 17:48:33.0228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zRU4ctdcUYC5E4pXvdQhpeAEZtpePbS5tAhfrtWtKXnjKVZjyy7Gzlqrn8ziF+Yn3JoEEYkQUfhFqCAyl8i0dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5251
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/2023 3:14 PM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Wed, Oct 18, 2023 at 09:26:59PM +0100, Joao Martins wrote:
>> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
>> the user bitmaps, so move to the common dependency into IOMMUFD.  In doing
>> so, create the symbol IOMMUFD_DRIVER which designates the builtin code that
>> will be used by drivers when selected. Today this means MLX5_VFIO_PCI and
>> PDS_VFIO_PCI. IOMMU drivers will do the same (in future patches) when
>> supporting dirty tracking and select IOMMUFD_DRIVER accordingly.
>>
>> Given that the symbol maybe be disabled, add header definitions in
>> iova_bitmap.h for when IOMMUFD_DRIVER=n
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/iommufd/Kconfig                 |  4 +++
>>   drivers/iommu/iommufd/Makefile                |  1 +
>>   drivers/{vfio => iommu/iommufd}/iova_bitmap.c |  0
>>   drivers/vfio/Makefile                         |  3 +--
>>   drivers/vfio/pci/mlx5/Kconfig                 |  1 +
>>   drivers/vfio/pci/pds/Kconfig                  |  1 +
>>   include/linux/iova_bitmap.h                   | 26 +++++++++++++++++++
>>   7 files changed, 34 insertions(+), 2 deletions(-)
>>   rename drivers/{vfio => iommu/iommufd}/iova_bitmap.c (100%)

Reviewed-by: Brett Creeley <brett.creeley@amd.com>

Thanks,

Brett
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason
