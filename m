Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272A15989D5
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 19:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbiHRRED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 13:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345413AbiHRRCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 13:02:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABC9CB5F7;
        Thu, 18 Aug 2022 10:01:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNz4orQDkJUMEfPpwcaQCOm3RM00IwHH9Z6l2bCn/tTPx7kqzCvCdZR9zhltZAJiqtW0r2DZAo7Z8eZ4Vbzyqh1DepvrO9oKwzFXeAnGUwefZn7QplsAukSQ85T55nZ3Bc1+qwgEXT+lB32sea3uvLQJwdbN51lY4eSIP4h3ancxgxTKN7xOpFzyGRzXeyGEnDUFplD0/Arq3qEX7irdXVaMx+1uEFaUKXNkg1zV0BCccDfAdd7dcPXqU6iTKWnIjGF4i2Jx79nNaqvdXJ/oOmPiCUYpRdpA/lMmMK/mEAEf6PwnFZIeJq+kE0D1GEZqVufvaKd7stDYS7uBhUOnLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5t2mm1SpMoxtPnxmh8iPf2GLje/c/90qc60SotkTS4=;
 b=QMj3zfmS3T9ne9dJCQ+FrlSj3r2fESF4PUl/hsidyJvMlZwP8yfGiQ6HRCfTRVEVAey7iI8JypXkw0gkLJjI0TsjETV/E0AR+j7wZHcbZj+gKYJ9xbgb5YmaVwSGMHCd6boznjOPXvMygBQgyrqtIvrE1W0czfk494LXiIn3sutGTgea3D8vzSEc4BdT2ebLQSxH6S8CVQz6QfoLxtSy3uN86V7FHUuPD0OqM+hzj9voKN1gPvQHz6fOXk5FyY0QtkYd3Pn5QwoxlW3DzY0JnXMXpRFbAK92OQqBU8Ei4kramnchkFfDpHzAnjOz/Ed7oqUJsX793WsyEl5NCS4fyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5t2mm1SpMoxtPnxmh8iPf2GLje/c/90qc60SotkTS4=;
 b=F8thv0cDbG9EDO+PGX6uJHdLLV85jiDRQ2qoDRdir7Nij+D6Bl0rrGuYEO3Wl+viC31gYfrAXuZMDALY3y8xiCaCOx8LO6RPd/HajpOvF7HRe+Tf0LmGcw2Df7NuEPSdHdZI9gmz8nd/WQBf9Q5FeZR9i0v5ZvdBAzeWFNkD7tf+yLaTiRSSabwAFrrbezsXVMt1zZXmqi3QIaHM9Unj3nKMtcCqFr3gne2p3ZhZe3UpaKYhAbak/bvjPUWtTnnPGIUwa0M9mxnRNOphAX3Ruuzj4wy4AJOvuc6cheTXGELQqwQ9Ox1GWw+RL4yc+HyK+f+f8k6jqbd9MBZ4L0AY9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by CH2PR12MB3751.namprd12.prod.outlook.com (2603:10b6:610:25::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 17:01:15 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 17:01:14 +0000
Message-ID: <62e6d510-8e7c-8a31-fb7f-905bb13afe67@nvidia.com>
Date:   Thu, 18 Aug 2022 22:31:03 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v6 5/5] vfio/pci: Implement
 VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220817051323.20091-1-abhsahu@nvidia.com>
 <20220817051323.20091-6-abhsahu@nvidia.com> <Yvzy0VOfKkKod0OV@nvidia.com>
 <5363303b-30bb-3c4a-bf42-426dd7f8138d@nvidia.com>
 <Yv0oH23UYbI/LI+X@nvidia.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <Yv0oH23UYbI/LI+X@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0042.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::7) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 296d275c-5438-4b0e-612a-08da813b4267
X-MS-TrafficTypeDiagnostic: CH2PR12MB3751:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bzO6Cio7FGLWmcMYD81VV5TFJj5NOa99XB/GwumNH641ULkOZgJLpzVrqQpxEnRfjeFV6PrSuZeo5sZAH3JjpiMce/Z90A/tO1katxw8uN8m6iPB1FlXEhEbIuxUch7UpipCT9TxIs+lRUOUk4ShAlleQMUJzNcLnfcbD6AU1s+ey/U77F2T8j1Co4rgOxChgPiPMZQ4aJr5M/J2ZZOpnhwnKHTlOjA0soRJ6HFuP949GMI7JYhhy604DhEqsqdAOKy9fIDgz75FRiIkGyJAovvHsfizdD4x6//uwnx9ztUcPpY5tr2kkQr3iYStu6ryhnEaxdGnz0LJbpdvBV7K2++eyeIX63oqOeWW6ZtCYXuC+Razdoxi57gi7Zim76YWCBk1iPVA9KUQO5qwvVk6X3ExgNekwpwPL1PfG3UZ6A7TWgkVCtXUYKJ4Ekxliq54wxj922MnlZ2oYnk/aIOTMF0eonZx7dI6XK6ZR4K/tX3r4gzVxJVyI/MmTRj2MgH4yRFdSrbbLGfZpoZF97IPaXUztgkBCm/hIY+2my87AD01lk5nElgD1nY4K7xssb6fzbWFaVoasDLKvCG3D6/BUYbJlpFoCFz8yGSJQ73fg1p24FNpoQQy7k8TDauVdAlZwqEe7P8HqRf9LZvyjlpkD3GdrpA2FQ2RrP+J8cG+pDr/mN5Z1jra8aoZiO2ejMp4suPCYmPaayejdADE6zOqqf9Ulp9mhlSX2T2rBvfe1JfJJXI0E/1/GEqyy59pEfKtMzTi1x7YZc4goBDRIzM6p6w7eQ3eua+GMXPObn4iDjw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(2906002)(41300700001)(66476007)(66556008)(4326008)(8676002)(7416002)(66946007)(54906003)(316002)(31686004)(37006003)(6636002)(6512007)(26005)(6486002)(478600001)(53546011)(55236004)(6506007)(6666004)(31696002)(86362001)(83380400001)(5660300002)(6862004)(36756003)(8936002)(2616005)(38100700002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGNYVldSQnduc09td1VaenFySTZoSFJTMURTTDl6eVQwR3dubVZNTnBic256?=
 =?utf-8?B?NGZjRVV3aU1nR0lKVWhvNUVIUTBCaTVSYytJVzNmSHFBdUlldTZFSXpYdkps?=
 =?utf-8?B?QWZBRmJQcW0yeEQ5SUpESUtLMjFULzc5ZzFFVVdCSzNtL05nV2N2aXZUTHZB?=
 =?utf-8?B?c2JyamdsMlIyZFJSTGJWU0RaUE92a010emN3K3gwSUtZanVqQnhxU3BMQlRO?=
 =?utf-8?B?dkkvRnBDQVN2M0JSQ2lVRlhtYUxCMkQyWHdVZXczMERYSnB3QzlZdi9XaHpu?=
 =?utf-8?B?YmZmN3JzTkFlWk4wM01jMThTODY0MGxGdUp2NWo3T1hrVmdNQVl1WjZOUkZW?=
 =?utf-8?B?VUZKRFRIdnRJV2NzYzAreVB3UmhVWG5HN0FrTEtBTW1wYzY2bzRDWnp5Zm1v?=
 =?utf-8?B?blNhQVpxVXczclBWOTBrUVdKNi84RWxNV0tzYkVtYjN2YkNWVFk0bk1XUTho?=
 =?utf-8?B?SzhZb08yY3V5WHU0WmM1STZpQWtZaHNFb3RwWHNreWlqLzR2RDRkLzlHNnFq?=
 =?utf-8?B?dk5LdjNGUFBPaVoyaTZ6S3NWSmV0WmYwVVgzdDVsKzVHRDFucFYxUUJYMzRV?=
 =?utf-8?B?a1BrWWh6ZkYreEdMYmxSTXpZSHhmbHczbnBEc1htb01oeFErd2xYRGRsU0po?=
 =?utf-8?B?V0Jxd2VGbk9RSHJhSjFjLzc4QlFPdzVvSlFKamhONVVlRTR6T25qL3M3WnU1?=
 =?utf-8?B?YXpWQU15L0xkdTNZZDRCeDJtQkVkQWJTZTE0MXRkS0VMY0lyb2ZyRlAwRTVJ?=
 =?utf-8?B?TkpMTWNoK29KVzFyeTlJZDNKZVhMRzNmUXNxb1VqKzhEWTFKQWNGQ2tCRTZk?=
 =?utf-8?B?ZEV2TTEyVml2R1hkeTNKNEM1cVNwYncwdjM0TEdWR05JaEUwWkp4MTZJeFNV?=
 =?utf-8?B?UmdWUk10NlpMK2cxOFp6YmFEQnhMUE5LVVlZaFZWdnMrS1lnTi9seURLTDh6?=
 =?utf-8?B?MVRNdUIxNjM4NEVOdThlL2V2YU5PTkxLMEkvSWRWZHM1TGY4a0ViUDlld0lD?=
 =?utf-8?B?cXRsU21peDZoUkpDdEpjRkJGSjZZYVpCTlo4dnNaT2NjOTk1alZXL1RtelhE?=
 =?utf-8?B?dW94NzBtQWdzVVJ5UklvK2FIMHJBRllnTExkeHhlMGZjckw0dEhIRVh4NkdU?=
 =?utf-8?B?R2JHYWR2NkllNFV5V0Z3cmdONTJnNTZtaWxwSndDeEdDVnp5Uzlna2hFR25L?=
 =?utf-8?B?YkRBMUZxcXNyYmFUK01vNnI0Q3FRNlVrKzV1YnZjL1RvUUxmTVRnS0dyNVMv?=
 =?utf-8?B?eVJZRHhaemg0TU1zRGgxTHZQcHh3R1Z1WWNRRmRPeloyY2owOWxxUmVEUmw1?=
 =?utf-8?B?dFdNeWhUWnEyWHBTbGpZSURUYzI0SC9PaGd1UWhLY3B6Z0U4cUdpcXJZbmVh?=
 =?utf-8?B?Yll5SmRJdWRpRUcrZDBncjg3ZmFNOTN5RXJ2ZDM3cnB6Z2g3MndLdVh5VVo0?=
 =?utf-8?B?Mkx6dVVRMzhNZFRjMHd2SThQZUIwWUJjMXROVHNncGp5SDVCRytkSzZjUkg4?=
 =?utf-8?B?c3VaMXdVWXlKNUNSRWdmb3NwSER2TWNNVHBPbElkY3FSOHVVd1JkdVYxS0VJ?=
 =?utf-8?B?YjNqZER4dVlqOWszdDlTRFZyOTBKUmhWQlAzeTQrM0swSmhVUlFHazZIdFFn?=
 =?utf-8?B?ME4rMi83SElSVjN3MUlmWjkvb2RqWHRFYWQ5ZS9JUFg2ODVnRWJvWW5kNGli?=
 =?utf-8?B?dTZxYnpWcGp6dHNyUzBiYXhEemtHTGRYUUdORkpVSHhRejEvZ2dHaEJDTW02?=
 =?utf-8?B?bk5uWldHZDZMN2xnTjROaHhQVXVuM3ZHMGpMazdtLyt5RExJejk0dTZMenNw?=
 =?utf-8?B?OUdWMlg0aU41eFNBSlBqY0JuVmlxdmZsVUhJYzYvVUY4OUp3eWZ4K0RibUdY?=
 =?utf-8?B?L3dnejZjclY2Ym4xeVNuUHVGTDRDcmhDbFh4TFRXUStEWW0vNC9obUNkNzRt?=
 =?utf-8?B?SzdGb1JFaisrS2FSSTQxVFdRSzFNYllEREM1TFNOMWp0MHZTbkUreU01eDVG?=
 =?utf-8?B?WkpLODdFV0p4WG85M2ZwQ1NCZVZObDlwVFBhYjhVYUVMT2ZkdWEzbUlzQ0pi?=
 =?utf-8?B?dlorL3hhUXdtZytIc1BSbmpXbmRORVlSKzFoMS9EUVQwNkduQ1IxWDdJNG51?=
 =?utf-8?Q?BL9vMhZ728r6p1dhUUu5iqv3d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 296d275c-5438-4b0e-612a-08da813b4267
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 17:01:14.7064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgQsE8kVGZZ5unZ72mWMThKb+zC8pz+LUyKTeiSOhw7qmdn0uJGQeCnLKXcgWEek+Xcjth7nZJy+pMjAaSlh4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3751
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/17/2022 11:10 PM, Jason Gunthorpe wrote:
> On Wed, Aug 17, 2022 at 09:34:30PM +0530, Abhishek Sahu wrote:
>> On 8/17/2022 7:23 PM, Jason Gunthorpe wrote:
>>> On Wed, Aug 17, 2022 at 10:43:23AM +0530, Abhishek Sahu wrote:
>>>
>>>> +static int
>>>> +vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
>>>> +				   void __user *arg, size_t argsz)
>>>
>>> This should be
>>>   struct vfio_device_low_power_entry_with_wakeup __user *arg
>>>
>>
>>  Thanks Jason.
>>
>>  I can update this.
>>
>>  But if we look the existing code, for example
>>  (vfio_ioctl_device_feature_mig_device_state()), then there it still uses
>>  'void __user *arg' only. Is this a new guideline which we need to take
>>  care ?
> 
> I just sent a patch that fixes that too
> 

 Thanks for the update.
 I will change this. 

>>  Do we need to keep the IOCTL name alphabetically sorted in the case list.
>>  Currently, I have added in the order of IOCTL numbers.
> 
> It is generally a good practice to sort lists of things.
> 
> Jason

 Sure. I will make the sorted list.

 Regards,
 Abhishek
