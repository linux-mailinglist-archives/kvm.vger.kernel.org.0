Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4707CDC94
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 15:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjJRNEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 09:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjJRNEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 09:04:24 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2072.outbound.protection.outlook.com [40.107.102.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99B4106
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 06:04:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5bx3t5DCOuorK8ySbqF5vvqzycIiDbo0MQPiRKg+B5gODX10defiOJFRrr/AJAggnaN7tYExrtOp59J5KFt3A8PEteNiINX8260SkC0UsdqT51XyBa2qDaCUXMv6G8SrKFnd3SywelXzb3fzOTJBGX7pjfkqgXbslnwS+zU+5aXMpLPkFpYTYY65Ldhoq/YdOetCRSl4AVnaB63NrdRic1Q7prNGlKD786RCGXXhu2bLTHDLyHNm9n0APE5AZaAc4hiODKILrrq8gbCPoL0lvpjNxUSoMQR0eQOU217Qt3L0FyPma97H63q2JRu64Y6CjTLEMcbfpWCHcMJAJnFKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=08uvuwbP0m3snRYWSG2WnEmmPdY5WqYkdXY4Re0BPYY=;
 b=houreoXhFVenhf2adCIK6lPBOJGgFDIm4NzSSo1YeHw+EE6N0AU+QSsEcdLqycHa2o3ViXVXz34ND69aSsXg4q+1cEqt+Vl5twMcywA7nd0Zw5LZiv8O7gE8xJUjyGuSbxZQ8Ldl87NSkTm9bP3u4vL3nLX5qLuW54fyVMJwixa+gEZg6ZoJcSI7IrK0SxNOQ0PuTHYBGtfolWuXf5BxBz/LVAcbeBbS0IvIFzf3UypEY9Gho2YXVjS1FS1UaifrjdQX9L7tKFSq7aHD7uJTEzj/IHroiLbtrLlY2CxOY/KcZDhcyObA009t5/jv1arsmm5CM0mG6OEkoMnHEQPUnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08uvuwbP0m3snRYWSG2WnEmmPdY5WqYkdXY4Re0BPYY=;
 b=BAjpxP6K0WjcbdAmrvIC8H8mjRfr9Y10NfvvpZ8dkUTD8txtIn8s6TiQEO5ZkDD1TmfK+O2JKz7geh363AFWkh6CQJC1cb9K1t/UP4lX1QtZ4fTOBDdyxLg7QhLrTr8qd0upXsLquFoogSsAvKCAgklZCuGGAZcysY7aYX2KXMk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 PH7PR12MB5830.namprd12.prod.outlook.com (2603:10b6:510:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Wed, 18 Oct
 2023 13:04:19 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 13:04:19 +0000
Message-ID: <14cc91b4-6087-369b-c6e8-5414143985c6@amd.com>
Date:   Wed, 18 Oct 2023 20:04:07 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
 <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:195::12) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 7147b008-837a-4ed7-afed-08dbcfdabd25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vNOJy40lmsbSNOmLHkKLrm2tL4Dr9/uSaV5pvwjOtVwg7XD0xOXmJzn5KasSDsk5o6XgURH3KTZ9ak7zHLDm+YWoy48GEG70HA3IEQQ3D+QvNIgSg9eplrRxMoOyVLbTkR0ekiGMxgIAe+nhp7IuM1PeXBeGLGymsvyr0IfTucRH94A/H/yFO2A/AnOdY4IyPj5EZI8PgJXZMRpU9rpQ27J6v/4lCiFdM32hpnzdljWd6pqQjeDjTTeRH0Slh4B+Moa46o5wXZx3+WkoJz5tJi5IGYpMrRxSpaTpdWY9WHED2R3GavYOdR9mVn690TZzPplDFrx/nRbrOuPPXB10bhzpbGRQDyxgRMYHDGi3zVMe9qdPYbq7lTggvZPfVsxm5sH+vLnRooXYvzx5sz7h8HA3XnZm1iPGW45TS4NApNl01v/bZfrmSoFUuCX/U52b9NQ+ls4e5dt2XlIZtS136ZOWcYpIOxhQeDV20nvir3srwHF3FJIspenMsjDZoIwP9q0ydj54q4GskQXc1O2zWzMzwLh8IduOBQUGVZYKPaB23tiRJcv2UrnWfxGR8Rdovx9drvP4YTDK/fjLljbqiP4MGgMs00/xFEZoHw7uuCnA/z+rE+vj4HHPDORELmArpNAKFQbQcSHEGdWsVtIDOO6qmEzK+iT1R2mXkWfPirk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(376002)(366004)(39860400002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(26005)(36756003)(5660300002)(8936002)(4326008)(8676002)(41300700001)(53546011)(2616005)(31696002)(86362001)(31686004)(6486002)(6666004)(66476007)(66946007)(54906003)(2906002)(7416002)(66556008)(6512007)(6506007)(316002)(478600001)(38100700002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dW1YZDkzeFd1dE5HcE85dEhpaWhobDJvSTd0TlNveTNpTFJYWEd6RWdPcktp?=
 =?utf-8?B?UWt1WTlZbVYzSE84di9VV21ieG1zYjVvL2ZjVGRTTmNQRS9GR1Z4a1hqcW01?=
 =?utf-8?B?VTBiOU1RajJjNm1JTy9UOXZpRTNZZU9iNHdTendnRCs5V3RJSXNDT3FwUWk4?=
 =?utf-8?B?YTA1dGtUVHR2T1pzZTNxUHRpWnBFcnFrYXZSeDhad1JGQ2NRRThxM0ZXZnlG?=
 =?utf-8?B?d2lOQWtjc04rTUR2aStPVnAzVDg1aVI2VFB3YWIrdlhnWkpLN0FPMGZMcXJY?=
 =?utf-8?B?dmx6dDhza3ZaR1ltL3h5MVZHTHkxNWkwcWcvNnpyZ1VyTDhxZit3TVJUbXVH?=
 =?utf-8?B?SzZpWXMyMFh4aGJLTjgxOFdYVjlwLzYySW1uVzgxaWx5Q0hsQmltY3VxR2xH?=
 =?utf-8?B?YnZtdHA2aFJ5L3ZjdzVGWjI3SGkzaWZ1ZHVHRTlZb2lBeis2M2Ixa2cxblFU?=
 =?utf-8?B?UUNHTVhEelB0ek1vSS9UVDUzTjRQTUNycHoyREdXUXo3RStMR3o3SGZMVDJS?=
 =?utf-8?B?OUxGL2VQd2NtS3hlR1J1eGRUMVJWbDlQVVhuZ0hCRDZjK2FDbWIrYlVKcUhj?=
 =?utf-8?B?aW9QV2NQRHRSTTZwQ1ZLMWVIeHlVeEdmRkdRYkJRamVNWFdRYU5TNGlXZExX?=
 =?utf-8?B?VzlSTmFCZHkrSmVBSXJsaERETzA5enhYQkoyRVJJcWE4Qk5TanFFN2lLNG5I?=
 =?utf-8?B?aHkyTS84QUc2MFN5YmI5bjd3M2hxMXMrSlhXaVJvSnlBQWxlMFZmdWsxb245?=
 =?utf-8?B?bkF3ZjUwcksvRzZ1dnZDeDZkaHlSNzd4UXBwYzBiTEtQTXRCZU9qODdSZy9i?=
 =?utf-8?B?Z1EvUXducDQyTzUvQ29XOERRYjFXK213L0UycFZISTZTWFliK05yRGVmdlda?=
 =?utf-8?B?QkV0c2lnVkFuSHlsYjR1QUk2elN6TVAvMDJxblk1VEcyK09GWVJ0aDdhODRa?=
 =?utf-8?B?aHYyS3ZaZm10c1JQZ1FBdjBlUDYwQXNneEZETjBNT2k0aXpqL3ZCbTNmWDl2?=
 =?utf-8?B?RnNGQzVFQnZ3d1g3Wkhpd0wvNEhneEdkekp4eElzMEFoYVhjYWo0Y25qS0hL?=
 =?utf-8?B?VnpSQ0tZRzR6SWZ0ako5S2lXT0pBeUxZNXc0Y05va0RzcUsrajA5QzVlYXlV?=
 =?utf-8?B?aEJ3U3A1b2s2QlR2ZG5pU2paNmJQUEFjMzF6TzJhUjhGdTZZdWhYZEkweDlS?=
 =?utf-8?B?UzJqbGRyR0tHd2ZGa0RXSUZLL0hnckk1OG1JL01XWmFtcm43OU1iNXQvSk85?=
 =?utf-8?B?YXF3Z01yN2JZRytsR0g4MkxvVXkwK01IS3BPUm9RVlAwbWpBd3RobUZhMnNr?=
 =?utf-8?B?SFRQbnp0Z0JCN1RZSHZUdXJxY1ZzY2I4UmxsSlNCOGkwV2RxeXhuTHVGSDNt?=
 =?utf-8?B?ZEYzU1VvMDRiOXl0NzdGS3FLMlZncnNNUlhuSUNVek9md0UvQkFzRXlKTndI?=
 =?utf-8?B?SlNlYWdsZTNGSUpPbG10TlpDRHMrNlVHTEVrN0dnR09VeDhHelk1YnVPOHJT?=
 =?utf-8?B?a1ZqVjVTbm5ERjRuWmZOSkZLNFZBVmxzWUlEZk90SnVDSHpmVXRmUCtiUFp3?=
 =?utf-8?B?WlVLNnBoUVdrWVVjM0NXZnVnZGVQcndFb2RLUGsxL2NSYnU4MUpwamxjY2JQ?=
 =?utf-8?B?YTZwS3BzMG1USzFvaHJVNnJoTVNGRlpERWJHTTRWMXUvZ3VDMjVsSStxU3gz?=
 =?utf-8?B?ZDhER1hPS0JQWndXelNMeWN6bFc3TUUzOFlUV2wweXhBaXV3QmF4UXpNZnNZ?=
 =?utf-8?B?TDI3NXc1STNGS0NjdDM4YVYveFZsb2JpTy9IeisxQU9yY2ZPREpoNlFIdUY1?=
 =?utf-8?B?SEkwb0RuYUxBTnJoYm1TZmNMekFXaW1BVnExOERXMmt2RUFIS1BCaFZRMDBq?=
 =?utf-8?B?QVRjYzBXaUZGSDZKNXhVZk1lc1ROb0c1d1RiZGlaL3BtaXZFUGYwZ294dWtt?=
 =?utf-8?B?YWdOSnc4SWI1R2dnRmc3anEzZmx1V2hmcjZGaE9sR0ZSUjBkdnh1VGJYYWZj?=
 =?utf-8?B?ZUQ0SUsxTjJvbm9ZRi93aU5PV2paSFg0UWd5L2NxOFVQMVl5dUhrTG9xd0pj?=
 =?utf-8?B?dEs3RXF4akhFWS93WnJ6M1VBbVpiQmpuaHhuVnVGLzAwMFlEU2dXenN1WlVY?=
 =?utf-8?Q?TqrymHI9tA4yu4kXkG+9D2qFc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7147b008-837a-4ed7-afed-08dbcfdabd25
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 13:04:18.9699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c2XH+J/SwyxuM0H/jzarr0H59cdOqEl/FH0ufFelQDCojbsKSY+9Tox35ysWN691DLTLS0VMJQl2rSX6ZJjLtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Joao,

On 10/17/2023 4:54 PM, Joao Martins wrote:
>>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>>> index af36c627022f..31b333cc6fe1 100644
>>> --- a/drivers/iommu/amd/iommu.c
>>> +++ b/drivers/iommu/amd/iommu.c
>>> ....
>>> @@ -2156,11 +2160,17 @@ static inline u64 dma_max_address(void)
>>>        return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
>>>    }
>>>    +static bool amd_iommu_hd_support(struct amd_iommu *iommu)
>>> +{
>>> +    return iommu && (iommu->features & FEATURE_HDSUP);
>>> +}
>>> +
>> You can use the newly introduced check_feature(u64 mask) to check the HD support.
>>
> It appears that the check_feature() is logically equivalent to
> check_feature_on_all_iommus(); where this check is per-device/per-iommu check to
> support potentially nature of different IOMMUs with different features. Being
> per-IOMMU would allow you to have firmware to not advertise certain IOMMU
> features on some devices while still supporting for others. I understand this is
> not a thing in x86, but the UAPI supports it. Having said that, you still want
> me to switch to check_feature() ?

So far, AMD does not have system w/ multiple IOMMUs, which have 
different EFR/EFR2. However, the AMD IOMMU spec does not enforce 
EFR/EFR2 of all IOMMU instances to be the same. There are certain 
features, which require consistent support across all IOMMUs. That's why 
we introduced the system-wide amd_iommu_efr / amd_iommu_efr2 to simpify 
feature checking logic in the driver.

For EFR[HDSup], let's consider a VM with two VFIO pass-through devices 
(dev_A and dev_B). Each device is on different IOMMU instance (IOMMU_A, 
IOMMU_B), where only IOMMU_A has EFR[HDSUP]=1.

If we call do_iommu_domain_alloc(type, dev_A, 
IOMMU_HWPT_ALLOC_ENFORCE_DIRTY), this should return a domain w/ 
dirty_ops set. Then, if we attach dev_B to the same domain, the 
following check should return -EINVAL.

@@ -2252,6 +2268,9 @@ static int amd_iommu_attach_device(struct 
iommu_domain *dom,
  		return 0;

  	dev_data->defer_attach = false;
+	if (dom->dirty_ops && iommu &&
+	    !(iommu->features & FEATURE_HDSUP))
+		return -EINVAL;

which means dev_A and dev_B cannot be in the same VFIO domain.

In this case, since we can prevent devices on IOMMUs w/ different 
EFR[HDSUP] bit to share the same domain, it should be safe to support 
dirty tracking on such system, and it makes sense to just check the 
per-IOMMU EFR value (i.e. iommu->features). If we decide to keep this, 
we probably should put comment in the code to describe this.

Thanks,
Suravee
