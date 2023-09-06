Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECD6793320
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 03:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbjIFBCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 21:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjIFBCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 21:02:54 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5161A3;
        Tue,  5 Sep 2023 18:02:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zk3VZVhKVyjfN9eqRbK3jyV+UwZY2WeAlYvHPyJeKxJisPF14vsxLm4GuOMH5bTdFSzomLw3tPLJ/hoDcxJj3P0SgcQjSnkVKK9JhqNqwK5z87zjBI4DDjMezOZzWOQaPFQobRNJV9c2bsz5s5+bw5xZyj/7HFhjlZS4ZRBLlYPkmrmCpqO2ME8NO4Ztpb1pN+UYxm29VtZc0HtHiW9EujDLc2gCtYnDLgQBrMvssn4iZp9lRBVif3LpBX1h5SfOLhMqfbw+EecWFpGb5AEBfhWhE3RpYO2O9qxcdYrgox9oBPx91WbixjNBQSozWburQwQ3YDQ8XC4q+zngeBkLUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+kIpEQM3YHYY0mSzn7nZjQV73WkDD6JAd/Jx3b/2VLo=;
 b=nm5dVOPprtowz65LpyxZ455MX2E11+IyZWiGpSqdkIvaT+yA1iPIDEelW9h+KRmUGetPCwKBMYhKo0zCNpag/zax7BrMbd5ZCq9Ji4REXuRmua/aTdeRlNSLq6Kb/OMpXkKAMe3S2QTOwYdgNWBIkfBHdlm4wXMDAB6GoHR7/DyKyciIjsNuLGuBVifH4ZRklJULtn6HDaA5hMslDiuGQ3bNFFkq2B4+e1wa9bJ2FZV7NorG797/O0ixqzEVDVolFSo+l/JNslMDQ8LBjQsMUSHnhtAe7bgTqlloWbIo/CYEKug4O61q4SYy7FmVfYAlBS6KUr4pfdgs9JI3gO6syg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kIpEQM3YHYY0mSzn7nZjQV73WkDD6JAd/Jx3b/2VLo=;
 b=3OsGnkdVozyk1hh5A8rJnv4c+rMpA7cxEWQbvTca5FeHDDK8EZMM1shx4G5y23DzrYluZSywAyNoEQpSPJlLaVwTwIk6kxsc8HqmkSFHsWuBsKcowG5J2phJXuIaQddV41PFevvu331tBxo7SUfdAIQzW17fL7+o3G8TZ6bGym8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by MN0PR12MB5931.namprd12.prod.outlook.com (2603:10b6:208:37e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Wed, 6 Sep
 2023 01:02:48 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6745.034; Wed, 6 Sep 2023
 01:02:47 +0000
Message-ID: <f17a483b-3a75-9268-392b-69340d9121b8@amd.com>
Date:   Tue, 5 Sep 2023 18:02:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] vfio/pds: Limit Calling dev_dbg function to
 CONFIG_PCI_ATS
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        oushixiong <oushixiong@kylinos.cn>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230905024028.940377-1-oushixiong@kylinos.cn>
 <20230905083119.27cf3c03.alex.williamson@redhat.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230905083119.27cf3c03.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7PR17CA0001.namprd17.prod.outlook.com
 (2603:10b6:510:324::25) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|MN0PR12MB5931:EE_
X-MS-Office365-Filtering-Correlation-Id: c8446fd1-4467-4d46-7f77-08dbae74fc68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IzcBzHJEVxs+Wi0FN+Jh2oDJWUIc2ckPggpWfvcRwzZhjkwLBDb4rDzFFuaDnvExBP7rLeMutLs3d0xshfIRMh6zyHbRfxocrrlUYOJ7WR2VWKqKz7tFdvvdP6P/aogTucVuNigEqAKjS4gwhJKym7pkXVIL/7SwCZcpyz6rDGn/Gp88DXtfIDowU0wQ0UGbIZO8IyAKcIs48yBlVeCP43YOrExe6FpS6OMTDRO3q2d0FTZPkirkVXFFgFpafI7l/Iu8SLaQ6mqu3Fl7atXbpu/V52M4VAGVAx5hTvjXqEOw2QP2+M3igUyzXTFZWkA68mD7XqDYXIktFaTsPkAlriZ2g4GWqlQGL2K5ut2cjh34u8zxoqvbXDoS7YUxy+GhawIOFe9y9ko9i21k6oQn+MSsfM91dVDhJRVXMEFi/7/asriCOPYUdpUPzc24jKIeJQaZVIXctx1GTXt/r+QlaMpm65gvMa6qKgA49ZqpPz40WQ1nXQ0crdUz3hZe6RzJ7CkPvHMYxh7jyXosuzbSwt/S96rfZNzfKLTBqiZlFRw+OhqlAN9Oru9ZvoGQ0XZUO2yx351ZgJddIjdyelC8etT6JYOKZXavhv6wVh0bPq4DlcgLKvDicoin36zKj8f5URTZCub3GMAsuaFNrxGCXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199024)(1800799009)(186009)(31686004)(5660300002)(8936002)(110136005)(66476007)(36756003)(54906003)(66556008)(316002)(66946007)(2906002)(4326008)(8676002)(41300700001)(6486002)(6506007)(26005)(6512007)(53546011)(38100700002)(478600001)(83380400001)(2616005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnUyaUlJaUdWdzdlZnhteTFra29QNFd1MERZQzBQTEdnaTFJemI2ZGowcjg0?=
 =?utf-8?B?QlhVNUd0MTdCemk1N0J0TUFUb1RZVWdHUzA1Ris2SnRXZ1krZnFWL0lPcVBJ?=
 =?utf-8?B?aTlFVGdiTmdnRWRmUGNKVXpiTy80Q3EvemxpNmdHcVA5TUltaEFVZ2pFcXVi?=
 =?utf-8?B?QkdrV3F6b1ROZ0ZhME1LK0VGRkdWRE9NMXpJQlhtaWVXTW5ZQWRCUTVma0NZ?=
 =?utf-8?B?alVtR2hkQWc1OTNKVWJBNUZmT0x5TmJLY005MkRBMnQzSWh5dTZaaEUrQjVj?=
 =?utf-8?B?dndlY0UyazlHTGxVNi91Wm5qZ0JKVElNVk9oWFRFcHA0ZFV1djVvcVUrM2Nv?=
 =?utf-8?B?eTYzZkZoSU9ObllvRm1EZXV3MHVCOUVlQ0lOUC9ycGtTYUFDTWNVVEhJTE9Y?=
 =?utf-8?B?UlN0eEpyRG00K090MnhxaVBZYzYzUFNUTVJWOGEzUG9kS1pySmRmUEJmU1dv?=
 =?utf-8?B?dElqWXpzOHVkMjFnYWVkZDJjRFcrdG9RQm5zNzZPVUFlMWZxRG9neEZxc2c2?=
 =?utf-8?B?eFB1OGk2c21JcUlTUEp4VmRaZ0FRdWM2NlpmTnZTZEpZMXdHL1RVUEMzRmxi?=
 =?utf-8?B?aU1zY1pLV1FqcW9LVmZWZ3dYbG5qNHlhRUNGcmtVeEZmQXFaRFFSSngxNit1?=
 =?utf-8?B?MjVSL3llYzYwQnVLUUlwbERrRzRwY2Q0L1FPaXVqeXJQWlN4N2FsUmNnSjhM?=
 =?utf-8?B?NCtFSEdpK3VlUHVPU2ExYlVGTlF1NllxVHpOSDlWNUpGeTFPTks3TlJ0QVkw?=
 =?utf-8?B?MUJqSnI0bXFGVG9mYnZubzNPN0dDMzVPak50d1hEeENqV0pONTlpRnlQQ0p2?=
 =?utf-8?B?MUVKZlhJbXdWZE0rekMzcDVKKzdmNDJWdGJoMmNzSktSS1dUQVVMdXIxTVlI?=
 =?utf-8?B?UnlPOTE0OU9oSDN6QXdkT2xwRE8rRnUvZnArZmlSRm1lSllrK1d2bTBmeCtq?=
 =?utf-8?B?VnFSUHZvaXVIUHVDc2dLZTdlWWV4eTFEN2QvT2VoMmVDTXFkOGpsNG5yM2ZZ?=
 =?utf-8?B?aHYxTC9ZbWp4QXNRZ3VON2Jabld0R1ovdHd2MlpVdXFkUFlCN1NQQlBSUEda?=
 =?utf-8?B?RzlTNG4weGxDMnQ2emU5QXJYSFJaN0pvN3hFT1c5bkZmcURHRXU2M01KMmlW?=
 =?utf-8?B?eVB1enFhSWhQN0pucjh0YmxRanpZTHV3MlVLTkNteHNHbnJQZUpyV3B2aXlB?=
 =?utf-8?B?aWFoMGh1cEpheng4eVN2VnIvU1pFTEVJeVk1NmRwMG1SOUh6Z3g5VkhLb1pV?=
 =?utf-8?B?S3BSVzFucDVKWDJHZStxQmVKL0g2bWc3RkEwa1NwTHZoOVlhUm9HQ1dZcmw5?=
 =?utf-8?B?N2ExNmw4aWkxT29DNFdZZC9VRkNCem92blFCeG1wc1RibFJVV2UxQ1A5eXVl?=
 =?utf-8?B?QjhHTElMNDFjemVHWk9XMk4rYS9keEE2Y3F1cm40SDR4Vjg1c0NlL0xpNm9M?=
 =?utf-8?B?SU5MNDNLdkNIYTMxQlJXWXZoNmRTR1Fzc3ZFRW5sNjlaR3lLWDRhaUtsQzU2?=
 =?utf-8?B?dUtXdXg1VnJTNmdiNitxSFQ3UTVBamRHSjlUczVGam91NW5LT3Yvb2FldEUy?=
 =?utf-8?B?RnNqenhucCtHZTVUbVYyNGRlU2pVMGVKaTlyOTVMbEltclRWeU1JRWVTakJU?=
 =?utf-8?B?VWlQQmlKMm1VbnlxZGRDS3M4MWROaitJSEVsbFRjWmFiUk9pK2kxZmdFN21S?=
 =?utf-8?B?Rk9tQ0ZqVlVqU2Z6MysyckhlMGpHRVoxeks1QVdJSVdMeEUwRlVMNHNqYmt5?=
 =?utf-8?B?WDE0a0tLTmVtNXhnQmhwVzlIaTRDSFBLWWJVWHJoTUIvbk5Jd2NhdlFNN2Rz?=
 =?utf-8?B?TDd2UWJpTE5vRWx4cEE2LzJvZmtzKzd1VmVYRTduMHFTN1NNM09HMUFjQzly?=
 =?utf-8?B?K25iLzlBM0RhdnFYQisyaUJZTEEvOW5KSms4blhIeVB2ZjlQbENLZzl1RHpF?=
 =?utf-8?B?eXlTWG1GYXh5SnAwMURzUEc1WGFuVi9SdUhOUkVMVDZlenhkdFloZzlPMkxy?=
 =?utf-8?B?SEtGNzNhQ2loUVhsRFE5RTlEUERCY1JmRHZYbHdNKzc4blhhcEEvd0ZQQzhv?=
 =?utf-8?B?cXJER0R4d0tzWGhkL1V6ZFJuVWJyWTBvNEZSb2UzVWNrc2NiV2JCQVdYZVZt?=
 =?utf-8?Q?fbso1e9t6kiEdaZir6b8lBIkN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8446fd1-4467-4d46-7f77-08dbae74fc68
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 01:02:47.8636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qspnLiYV6PvRbSSOrOWEcQ+ao22ocA4bIT0SvT1mhFqtK3ZpxyXnSkPIyedQYbtuTFtDbISGBWlP7QD5PZ0nRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5931
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/5/2023 7:31 AM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Tue,  5 Sep 2023 10:40:28 +0800
> oushixiong <oushixiong@kylinos.cn> wrote:
> 
>> From: Shixiong Ou <oushixiong@kylinos.cn>
>>
>> If CONFIG_PCI_ATS isn't set, then pdev->physfn is not defined.
>> So it causes a compilation issue:
>>
>> ../drivers/vfio/pci/pds/vfio_dev.c:165:30: error: ‘struct pci_dev’ has no member named ‘physfn’; did you mean ‘is_physfn’?
>>    165 |   __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
>>        |                              ^~~~~~
>>
>> Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
>> ---
>>   drivers/vfio/pci/pds/vfio_dev.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
>> index b46174f5eb09..18b4a6a5bc16 100644
>> --- a/drivers/vfio/pci/pds/vfio_dev.c
>> +++ b/drivers/vfio/pci/pds/vfio_dev.c
>> @@ -160,10 +160,13 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
>>        vdev->log_ops = &pds_vfio_log_ops;
>>
>>        pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
>> +
>> +#ifdef CONFIG_PCI_ATS
>>        dev_dbg(&pdev->dev,
>>                "%s: PF %#04x VF %#04x vf_id %d domain %d pds_vfio %p\n",
>>                __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
>>                pci_domain_nr(pdev->bus), pds_vfio);
>> +#endif
>>
>>        return 0;
>>   }
> 
> AIUI, this whole driver is dependent on SR-IOV functionality, so perhaps
> this should be gated at Kconfig?  Thanks,
> 
> Alex

It seems like depending on SR-IOV functionality makes more sense.

Thanks,

Brett
> 
