Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEBD519CF4
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 12:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348105AbiEDKgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 06:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239023AbiEDKgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 06:36:45 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2047.outbound.protection.outlook.com [40.107.212.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C43C192B3;
        Wed,  4 May 2022 03:33:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzoogM3zsbCGYqRGCZI0RAo4Qbdyt0dnMoTGDatjUqFVPJa+GtelNaWuIyzQqOMQrBO93R59owfmwiuvYzDCUx22Z3RO72jRIaSxamSGgP0H874zjvfJ5nCBl4nClKLKgUrhuSZCNzzzqN8v+u9/QmHFII9UgRd//0Aj9g4ZA/PAh9BPv8vNH81pFBLp8nYZ1vNnRvZHIRaX29kHSGmukES8NYoktMySIZN/54bvn94yJxw5CCugjyEjNc1GzVyWcVcsrpOyC8OkxBw2svxFXjcN4w87M+OXN6W7dE8ji+VpHQ1Y49JU+Yx8odRNOn5L7vOM3glBAmNDxadrP8aBew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47RnqaiyuWIWjyyZOX9nl75nOIKlQZuBq7JiiTSBgpg=;
 b=A+H8mW5FZTleufnaZ4PU1vni1SE2ZaWDwGzrb21bVagvuuvpY0Tl33A0I9j8POQhStXF8YJ+iJU3nm+uRdK8mfM3hHmydbRc8crXqXohOV0aytHyGRARs36Pm7FAEXtXN2RDkJUUXBro6/HyipbSDVcIYf5R3p/44rJvVx8b/JmEBeq5sHTMc4WqlMTvtNMsqPvUlBzUcYjQAonfkeF3N26yCMwhkPZSVrNs1EzYF6Eojgmi7OQ7dySRqoAZLW5pbGZ8/Dnqhiguz1CygZOQZL9znCuo3ieTdA8I7OkiGkMzY2x9LZqwZPQriF5x9X7FkqCsGH9IjO26X2sUnIOfEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47RnqaiyuWIWjyyZOX9nl75nOIKlQZuBq7JiiTSBgpg=;
 b=OUTwngqbXdMxOVLvjFs+CVaNKn9VEGCgL9GwukK3nn6m08fDnUp6fBX1GP0QydcWGEAGqB9axZohEj23vIZNDZKcGxAxw5kEM8RIfP74IiLrtaxv8CvWKdlUT8rzZpyLBhpBpKHnu263rEuF3rEIEJzqt7hVjxiwBG1bYWODWTtZSbPiyIF0+83YhV2dsUY5rNZtbVmy6tU8r2yveXqY9cyv8jm/NPIdF/pRqXhRW6qXdzS8/JAmVGq6Z4KMBDcMR1qcEO7LD6PKoN898dUoWkKFdjTIQdKfyq16DORs5AariTeAQS9JyjvNCwOuLbbHd1SFpQ7Y1vGIB7s3qHTxSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by DM6PR12MB2714.namprd12.prod.outlook.com (2603:10b6:5:42::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 10:33:07 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 10:33:07 +0000
Message-ID: <f8f9ea38-0716-7f41-0879-2c71dd243369@nvidia.com>
Date:   Wed, 4 May 2022 16:02:54 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 4/8] vfio/pci: Add support for setting driver data
 inside core layer
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-5-abhsahu@nvidia.com>
 <20220503111124.38b07a9e.alex.williamson@redhat.com>
 <20220504002056.GW8364@nvidia.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220504002056.GW8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0013.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::13) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b02be29-30ae-455c-3db6-08da2db97a24
X-MS-TrafficTypeDiagnostic: DM6PR12MB2714:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB27145A483ADC9206D78ACE3ACCC39@DM6PR12MB2714.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZoNX92OxUFLaATKqNikPvDdpkfLk3nLJkWxdOjIDHfuQ6NLlZCD1P9XqPf2h/Alv8GpPhNj0zSQ3Y6s+dnk5JO+ZjR2Rn/NCE3BWuSY5gFo37NY4yGG1q/pTJawN1LjhdveQnCWAzzucsQbTJncRMICOBbfFYRJ5Aj2fovQQ37B1yBTc2oYYGLIuZnQep2yxVW7wgQppN5bjekQPqphUAwOHCQCDlcLm+yqPLbwR+vKqYZ1RtsMTTVZgtOvaBXcBSM48UPz8BdttHlKsTBw5DkUCVBUqtSdq6aHNH66mSVsOzcPPccEaJzfsmE5kN7kSQYV6ivC9a6BgOhThjO2azl+1Xrvvsq6Noz9kzMOHiYirtnYyJngK/um0HY8OvV0tlRQS8hFhKgsX848Oj9mhT7Re8ZyeLNVR4SlpvEJABGo2fUOOjWpwKzflbvLvr9VEUzNr8ZyT8DgNy/+eDbfiCJ2AhrDeNzJ8f0vH+ciN33P4IPClZsaibH/nBFtidepxU73USzeBoFbK/79flcXB5lgJegtf6SmlBgfyvJLTfOyCNA08LT5pieNgMw46xDo5hJUX3UU7FTfldw3bmP5D4qclf0h3jTiVViLzH/TeI2g31jYd6Evo4EcDTOYVZV3aCr73rBhnR6nrEMHacFm3RjZD4oiC4v//OwLohvAgDNGuSlArhxlAeG3SIo+kF+EmAPkK8DpBNrIOgFrsrSyS6erB9fSnOKfdL9IJcQVyeoOPGlCTUXliE16TNqy5Glr2VfKVHspmHJEgUTK8g11h5M/9aXfDOFPHKCmc5si+6zHkKkqWpxsTl03d74p3luBg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(966005)(6486002)(508600001)(31696002)(26005)(53546011)(55236004)(6506007)(6512007)(38100700002)(6666004)(7416002)(66556008)(186003)(66476007)(316002)(2906002)(66946007)(36756003)(5660300002)(8936002)(54906003)(31686004)(110136005)(83380400001)(4326008)(8676002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0h5UFB1YklNMWRLMUswcm1xTDM3R0pQaW14Umk2Ulg4ZDVVcE1VMmppNWZa?=
 =?utf-8?B?K0F6Q3ZPNWlQTVU4YW41SWMvcnBtLzc4MkR2MEpieXI4b1hmOVlwbFAxRWp4?=
 =?utf-8?B?Q2hWakZpa2dWK1BUMFZ3ZHdlODBFS2ZTRU1LZHRrcVQvR0pTaGhlWWwrUExZ?=
 =?utf-8?B?YnQ2S2lyZ1p2d2diTjFZamFrNkNua3VrWUVwemVvemMzcmk3amZjNlpabUli?=
 =?utf-8?B?QlpYQXdJU3dWWW8rQlQ2NTd3TjhrNGgzdWVaaHd3QVc2L2ZsUmZPajF6ZFdY?=
 =?utf-8?B?d0Q3bjZQR1VTSzhibnVadFk2bXNMNjl4ZDVjWlpOcDhtYk90SlhLNDU4ZVlF?=
 =?utf-8?B?SjFPL2JPQjZ6OWpDM1Y0RlNXOFd0NmNWclQ5Q1R2YXBsMmZFYTV0c1B1K21t?=
 =?utf-8?B?OGVKb0R3a1hOYzltdEVXZ2hJVlBxVHJCQ3VFUTkzREpIVmtvQzRIZGlaRHdo?=
 =?utf-8?B?am1tQlR5Nm9Yc3V0WGpORnNIVk94V1ZIYzFUZ0FvM1B0d014SFpuMGszek9p?=
 =?utf-8?B?MHdxYnFCYVUxMDFLZ0Y2bGRzcVVobnRXZDF1Si9HdWtxNHFXNmZiM29VT0dT?=
 =?utf-8?B?MzkzK2xtVFRUZ0l3NnF1c3dsYXBYZHU2TEE5eDZYeW9pWm1KY08yU1g1Sy95?=
 =?utf-8?B?bHA1YzZGRU9jU09qQm1ZaWQxeThYTEFvUGhvUFB1TjNZWEhFMDdmYktaRVEv?=
 =?utf-8?B?dEltV09mQzQxZDZzSFlVZEhkdGY3RDYwbG9tdDg5VFdTWTUveEdUZDlVM21q?=
 =?utf-8?B?Z1htd0U4MzRPNmdsaSthalIxU04zaE5yZndINGZqL0xQalVoUEp2RXBKYVRm?=
 =?utf-8?B?TFlVNHhoMkhDUFdreEh3cTNtTW03NU5MRnVkWjJ3OTdOREsyb0ZLTmVUN21o?=
 =?utf-8?B?V3BnT3A3NWpDRU5XTnBhVnNqNFNzOXdqQ0tYSDlJYzIvZ1VpQ1MrNkk5ZXhQ?=
 =?utf-8?B?M3g0UWdWTmZjNDR0Q3dreWkyYXdJamtrOGVaSjM5akcrd0xlVUQyUE5NWnVp?=
 =?utf-8?B?M2hVdEVtN2JBbXBGOGRHTnJjTEhsSEprdHVuUVZCNXdJUE5UV2xkdDNDWFRq?=
 =?utf-8?B?THBvSThsY1NvZjRROWdtczdLRi9vM1Q2RmxUck1yYktadUtnSXJ0TzRQUC9L?=
 =?utf-8?B?cGpYZnZSUTZZeHhXdGVVSUY3Y3JDMnFjTHlRM3BBbjdWaVlvWGVHaG5UQU95?=
 =?utf-8?B?QSs5M0luL2dzellvU25sMzlzZ2FTNk1RaFdrbmpieU1ZaHA2ZjltODdHbnha?=
 =?utf-8?B?bGNyQksxUEdnYXVBaGNjTHlZeXVVS2VsQWtYenkzVjVQWGFZMXZxdTI1L2RI?=
 =?utf-8?B?dlRsSis0cXdpOWVZZmUvM2VPLzFqR3RmWHBpMy9kOFpFMXBrYWJWRms0U2Nw?=
 =?utf-8?B?dEJyYW44VDJMaHVmYTNtWkhXeElqUmcraWhkWWtUSTB6QjRFK0FFdUk5L0N3?=
 =?utf-8?B?aFhTaGJOWStkRHIwZ09DMlZ5U1M0c3dHYjgwMVhkVDFBaXF3R0JqcHZqNEVZ?=
 =?utf-8?B?T25IMjhNblFaaDVkOXNNV09MSkp0TGVIZCtqQk03NEZzbS9FLzFlVzV3WGVR?=
 =?utf-8?B?S0pDRnZwSWNaU28xaW91aGEwekE2aFQwTGZtNlF1OWlMcmRkUE5yR2lkTE10?=
 =?utf-8?B?ZEE2QTdGQnJmbk1Mbm5RU3Q2Z1ZDcE9xOGJrNVZ5RDV2N0ZpOU9mY3ZzbEM1?=
 =?utf-8?B?aHlmTFFKQU11OUhmeHMrOUNGYmpISjVrU3UyeVhsR3E2djFDVkt0NzJhOENm?=
 =?utf-8?B?MDYrbzZVTm9oNHlDY2tyNGxQUlhQYk1UTjBiUFhETXdyNCtGekl1OGt0TTBG?=
 =?utf-8?B?Z2Y4b0tDT2RHSWk1bG1RZjVpbndXRm13RzdobCsxL1lCYUNoL0JmWXUyQVpP?=
 =?utf-8?B?S2ZFRC9lTzZ6My92Y1F6ZC9pZ0ZFNk45UFVxeUg1YTBhb3d5RTZMQW1yYmYz?=
 =?utf-8?B?Z2tPSkcxZ0Vad1Z0UlhCeDlMaW04ZWloRlYvbE11YWFBT2JmbXVHRldZTlZm?=
 =?utf-8?B?M0F6U2pkZmo3MEJzcnNTMy9QL3dSdVMvMktTSTJ6SDdwcjNpMmRWSit0OEFW?=
 =?utf-8?B?dXhUcVhMbWsvRjRDbUhWNTVlUlByU0tUb2hIZVBXNWJiMzRmRytSdnJ6QWli?=
 =?utf-8?B?V2t4UmxlMmZRNEUwVXg2Ty95ZStMSXF6eGtXT3JqaEN5Ym16OFZ3T0g0SllM?=
 =?utf-8?B?YndCV2RQOVNvbGIrR2FVOE1abXhWQ1hHak53WkRrS09nWVdnTTJiQUtYZEJJ?=
 =?utf-8?B?MUlGYUFUc1c3WEhzVDFWeXdGTkNUV01kQnU1RU4wanBoZnB3S0NHYVdkbkNZ?=
 =?utf-8?B?bnlmd1pJRm03VUltZ3paVHZTYUpzSjZyMDFHZldtRHhIUWlaVlhqUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b02be29-30ae-455c-3db6-08da2db97a24
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 10:33:07.1021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zd2AGBg/EDl9YgDRssY5FWTaiBw/rvSP4ef3ZQQcHHVPDWUlmv/ZFMzy68JX70oEeT5JxnRlRyMEajexEcFo7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2714
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/2022 5:50 AM, Jason Gunthorpe wrote:
> On Tue, May 03, 2022 at 11:11:24AM -0600, Alex Williamson wrote:
>>> @@ -1843,6 +1845,17 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>>>  		return -EBUSY;
>>>  	}
>>>  
>>> +	/*
>>> +	 * The 'struct vfio_pci_core_device' should be the first member of the
>>> +	 * of the structure referenced by 'driver_data' so that it can be
>>> +	 * retrieved with dev_get_drvdata() inside vfio-pci core layer.
>>> +	 */
>>> +	if ((struct vfio_pci_core_device *)driver_data != vdev) {
>>> +		pci_warn(pdev, "Invalid driver data\n");
>>> +		return -EINVAL;
>>> +	}
>>
>> It seems a bit odd to me to add a driver_data arg to the function,
>> which is actually required to point to the same thing as the existing
>> function arg.  Is this just to codify the requirement?  Maybe others
>> can suggest alternatives.

 Yes. It was mainly for enforcing this requirement, otherwise in future
 if someone tries to add new driver (or done changes in the existing
 structure) and does not follow this convention then the pointer will
 be wrong.

>>
>> We also need to collaborate with Jason's patch:
>>
>> https://lore.kernel.org/all/0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com/
>>
>> (and maybe others)
>>
>> If we implement a change like proposed here that vfio-pci-core sets
>> drvdata then we don't need for each variant driver to implement their
>> own wrapper around err_handler or err_detected as Jason proposes in the
>> linked patch.  Thanks,
> 
> Oh, I forgot about this series completely.
> 
> Yes, we need to pick a method, either drvdata always points at the
> core struct, or we wrapper the core functions.
> 
> I have an independent version of the above patch that uses the
> drvdata, but I chucked it because it was unnecessary for just a couple
> of AER functions. 
> 
> We should probably go back to it though if we are adding more
> functions, as the wrapping is a bit repetitive. I'll go and respin
> that series then. Abhishek can base on top of it.
> 

 Sure. I will rebase on top of Jason patch series.

> My approach was more type-sane though:
> 
 This is also fine.

 Initially I wanted to do the same but it requires to have a new
 wrapper function for each driver so I implemented in the core layer.
 
 Thanks,
 Abhishek

> commit 12ba94a72d7aa134af8752d6ff78193acdac93ae
> Author: Jason Gunthorpe <jgg@ziepe.ca>
> Date:   Tue Mar 29 16:32:32 2022 -0300
> 
>     vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata
>     
>     Having a consistent pointer in the drvdata will allow the next patch to
>     make use of the drvdata from some of the core code helpers.
>     
>     Use a WARN_ON inside vfio_pci_core_unregister_device() to detect drivers
>     that miss this.
>     
>     Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 767b5d47631a49..665691967a030c 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -337,6 +337,14 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
>  	return 0;
>  }
>  
> +static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct hisi_acc_vf_core_device,
> +			    core_device);
> +}
> +
>  static void vf_qm_fun_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  			    struct hisi_qm *qm)
>  {
> @@ -962,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>  
>  static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
>  
>  	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
>  				VFIO_MIGRATION_STOP_COPY)
> @@ -1278,7 +1286,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  	if (ret)
>  		goto out_free;
>  
> -	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
> +	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
>  	return 0;
>  
>  out_free:
> @@ -1289,7 +1297,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  
>  static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>  	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index bbec5d288fee97..3391f965abd9f0 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -39,6 +39,14 @@ struct mlx5vf_pci_core_device {
>  	struct mlx5_vf_migration_file *saving_migf;
>  };
>  
> +static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct mlx5vf_pci_core_device,
> +			    core_device);
> +}
> +
>  static struct page *
>  mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
>  			  unsigned long offset)
> @@ -505,7 +513,7 @@ static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
>  
>  static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
>  {
> -	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> +	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
>  
>  	if (!mvdev->migrate_cap)
>  		return;
> @@ -618,7 +626,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  	if (ret)
>  		goto out_free;
>  
> -	dev_set_drvdata(&pdev->dev, mvdev);
> +	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
>  	return 0;
>  
>  out_free:
> @@ -629,7 +637,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  
>  static void mlx5vf_pci_remove(struct pci_dev *pdev)
>  {
> -	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> +	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&mvdev->core_device);
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 06b6f3594a1316..53ad39d617653d 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -262,6 +262,10 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	u16 cmd;
>  	u8 msix_pos;
>  
> +	/* Drivers must set the vfio_pci_core_device to their drvdata */
> +	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
> +		return -EINVAL;
> +
>  	vfio_pci_set_power_state(vdev, PCI_D0);
>  
>  	/* Don't allow our initial saved state to include busmaster */

