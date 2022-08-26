Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153255A297F
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 16:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344495AbiHZOb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 10:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344472AbiHZObM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 10:31:12 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440269E0C3;
        Fri, 26 Aug 2022 07:30:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkD4YHsVZb+tAQKAxMo/NRhg6I70V5Ez8VU1E9/mH2sll+ERZm05tZyDJoL6b14SIvQnuUwGL9c1HZAEQXvRA0mVREpmreyhlG5dhTg3WodCTVxxES5mdJ2wcxZy5Whn/roBNIEZC3UEIkL3/tUIbmImdvCREGiV/TlQyXNDp683IY/wp45xO4Rf6f0zgMLZa04N2S3+EsuAehFsuWr8bJX4+op4SMLLlp/F4e6/d6nS5wWWPb7XmtWGD3xmo47o945BQnQ5BPyX6EXGCjC/zLkoyAGHS4PP397418Fa/afY4+8o7HfB1hUudu/Ram2LINyXmILe3hW0vz2Whv6KcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYa6zMu01LliFHJeThxCwymNcASh8hYIWMCHRrn4DBw=;
 b=krvGWWQ1UJ9btpbu08C9mFDmriGvjZel319q+RXvEOtdi2dR7m62faV7hHsi0jiUHb7PtguNtAif8zg4UynAt1hX/8svsqkTMRnkITdPV5R7baDOTsyidxEUGFo7ekk05PikYqgROe/PLVqRBXseqO+Nx9ZIJxu6Sf4Hvd6R9XVc/XBk59qjeix1QMkMJdjfmUJDY27j3x/RGz16k1ffvfqyiexvsDJhApVSxDa68g7CllUDEWz/RoOAb515kWA0Icbw/8yA8/lv5CwbHsrU3RtDVI1ydY2Trzn3bHbcEWT5AGfcZzJYsknJdlGBUtSNbDltkW3EH2ZVbZvdt9wayw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYa6zMu01LliFHJeThxCwymNcASh8hYIWMCHRrn4DBw=;
 b=WshM5SRKUutJaPumJzdb6S4ItRbSIybSLm7WD4eBVYlwzbMelwrdMqhYzAKDzBRuuDTQhAkva/t1qkzZdgnH7lafqzGLRWEHxYdU094WrB9VBkLaDvheIhbejYP7WtHGvQ3XCJUTZs+de3vByMEcCysn4SStmDgaHXFXktlFQjTuk87h2pB5jx22p/N1KL3RdUERb4yBiLb3taJ2CtTSjKvHALFxU3J4l+9dn7SwhtourXthfpWDVtfko/lAobH7dMnqUYfyQQ/nv3zhHrcUmYjGYA6e3JLw2twU/RDpf7RjYe/89h28Sl1tykipskJYduvft9deiAEoxWNlwqGWtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 14:30:56 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::753c:8885:3057:b0a1]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::753c:8885:3057:b0a1%3]) with mapi id 15.20.5566.019; Fri, 26 Aug 2022
 14:30:56 +0000
Message-ID: <44dfe49d-6613-5869-390e-f9709e71ca50@nvidia.com>
Date:   Fri, 26 Aug 2022 20:00:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v6 5/5] vfio/pci: Implement
 VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
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
 <62e6d510-8e7c-8a31-fb7f-905bb13afe67@nvidia.com>
 <20220825163240.274950c8.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220825163240.274950c8.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0017.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::12) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e1ca2aa-6fbf-40f3-c22d-08da876f965b
X-MS-TrafficTypeDiagnostic: PH0PR12MB5481:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gm1ULQwcBB2RuUnoaka92AdqTKlH+p+LwIhUsjXPyBr60aNeKB3N9SxXXsPORmQI9t26A2y9Oh+XyQ3/wvEwxBBttK0RynxMtTaNgrFCGYJtBHiRXkHOAhwu5GqdMIfsPdvZlQQlBFPK+xViR1+q7RlEr+Nzr6QwclpkqInZt9s/omAa+W48srMEHUxN+dDPqWIurOY296bcfdLwN0dfbbRPE7r1lDgwwPBhvGN6pUcK/EoUy2qno94DI45NE0WRM/ENMJ4Rjfbsl5EFI6waZaJ4P41NJuaVkJeZ0iEIFkobr7ZhMnwVdlVyq4kczoCdK8E7noSAlwRS/BfeT2CpCHZJd3kNCQ6utfx2vINXTBdjmd2PE0Fz6/tVuALYcss3phInqY+B1pE8mQEz/ErasgIoPatDUxMrlsevWrX5rRaEINtylG8l7lWNmzA8ZYVMAr7ekpo79g9FXWHZqK/j6cQ6e3OEwClkYRGH/nbzwNgT/JHhyIp2J8l+oaQ29rfm2wPR/w/ACQ8p/LlRZv0+BxQxHXwQ3niu1WAoDYhQYLlRQKV2MBTDuoHo1WV/HPxpj8qsoYYRNIAdnwRBsaHUIqjSwyN47evIP6OnXnIyP2XgU+ttltttRD6h9BoLG9NF89dekOyVQAln+XIkIO+I2zlzzpCFyUl99PURZFAgpUd0mbeja/EQ6Kj6nvQ1czBleic2JNqRZBBOtHR+q/EHD5wn/JXFrtFjMPlZ88Y6zPmyxv+Hl/YzWF7CChAQyTrye+o6E+3FtIvQ1N208zL0nbPWd1PgUdy4pEbw5ADZTn3GM+1JP+rjpDLJrqhFFYhcdXpT82W2tIidv7s0t64/UwUeBsaB1g2+4b3bfpbIIW/3tUe3NO+U7sqslaxFjnnpS9ROiFdxF3X1PJ3w/NGvaNCOdMHHaOlZBwld8i0i4KM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(6666004)(6512007)(6506007)(55236004)(478600001)(53546011)(6486002)(41300700001)(83380400001)(2616005)(26005)(5660300002)(8936002)(7416002)(2906002)(186003)(316002)(6916009)(54906003)(4326008)(8676002)(66476007)(66556008)(66946007)(36756003)(38100700002)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlpjcVlMdjMvSmt2aFozbUh0TEF0ZlB0aERIeGFWbjR6M0J1dis1SFVHVmJB?=
 =?utf-8?B?YmFTQUw2TTlLVHNvSEtxcExZSFhTOHkxY0JnaWIzUkVHWmZZcXVsRzgzaUNQ?=
 =?utf-8?B?bnBCWUFrS245RHJZd21uem9NazhzZ0NmUUR0d2FyZnRVQnpJYUhScVN1WEdS?=
 =?utf-8?B?OG0rd3c5UHNkWUt5Ym5UNFhaNUlNSVpDaGFFQ1hiSEdobnBzMWpObWk4MGtn?=
 =?utf-8?B?RnV1NmdqRTl2MlZVRFFJUHpuUHhvVE1NdUpzYzNTMTBRbzlEUFl6MkpqaGFu?=
 =?utf-8?B?VXhJbFRPdmhkbGhKV3NTcHVrUzlkWnhxN050aG9ubHdKSHFWMjRtM2k1d0FE?=
 =?utf-8?B?aDhKWVRqSE5YckFjM1AvZjFmWC9DZ2hwZFpmRUx3ZGtoVm9sWEJtODFFc0FU?=
 =?utf-8?B?YkNsMzgwWEthdzdrM1Y4bEVNeTBSZVJoenkzV1Yvc1JuL2krUXpKNFdJWjFN?=
 =?utf-8?B?TDk1ZURYK1dqMkliNDVhaDdEMzFCN1NvY1BPQmlVcXNPcWdnajN6R2RRSTl0?=
 =?utf-8?B?SlVQeHEzcFJnRmNDWEZ4YjkxN2VjblBjNGFMbGF2TE1LUi82VW5YdUJ5TUJn?=
 =?utf-8?B?YVEyaWVMdCtaOTcvNHJkRkZ0cFppQ3RDRkcwWTlEeUI2R0FZd21xSGFDWlZN?=
 =?utf-8?B?MWk1OWFGYmthTEFabXdwWmJPenBQMmRkaWNzVVdLZXUwU0NhVW90NVZpK1Jo?=
 =?utf-8?B?dFRZRjBKbS9FTUcxM3IyRUxWYkJVOXVmbFlrT0lESk8xT2hqU0hIaEtCUmxE?=
 =?utf-8?B?ZnhYV0pFbkxJRFp3MnVXMzBxTjV3dFJYQVpvSXVYajJWcEptbkZOZWlWOTN6?=
 =?utf-8?B?bUFkT1lNYWtST21LQkxuK1BlNzhiVWlRaTF3QVgxNlRoY2FUcVZ4a09VNVpk?=
 =?utf-8?B?VHFTR1YxUHNhTjV1bFFPSVVtbkF1RUp4RjNZb3B1UXM2QllRUysyQW5WVXNk?=
 =?utf-8?B?UXlwdFVTMkNZWUZhd21tSkw2a01kK3U5dlVLcHhZanBXYXMwcmxkcGlwK0xl?=
 =?utf-8?B?dDhvZHNNK1Y3dXlpZjNsSTZ4V3ptR3F3bTZ3cUpTK2tjWUFMdlBaU2xvWTZ5?=
 =?utf-8?B?N0RYNUM1TTkvWHEzOTdpelJuWjkvODBtODl4N2NjdStjNDNLZ3lna3VMTlJE?=
 =?utf-8?B?QjBvVURUemZ5a1BHM0hJYVZ4S2ZlZlRDN0JWYTFuVzNWbHhOZzZkeU5uZ3B1?=
 =?utf-8?B?UG5NZzh3MTFGYVNDdkFibTVxRDdoR3JTOG1DaGFBWmdFSFdydnJOTVhSTEQ4?=
 =?utf-8?B?bTdiay9ucVRmSVhsQ1k0dTgxY0NrL1UrL2wrOStuNU9vZVFyVWxyTGZKY3RQ?=
 =?utf-8?B?RGgzZnRkZk5QV3kzVTJBUHZPMlR0UUpFMDBTMTBkUHo1RWhDMnpzNGgrZ0Vv?=
 =?utf-8?B?NzcxYktCQUVoTDJMQVMrL2JBMFkyeS9ycmhxNVNIdzVCUTJrVmNraGxzbGlZ?=
 =?utf-8?B?QVh5dFYzaDloZkJ5VTIxb3dHK21sVVVFNzFtY2dtSUJWV3pqc0RBdWR4OWty?=
 =?utf-8?B?Q2paMXhwZUNkc3JrOUJLeDBXNjdhckUxKzJGNUZBQXJqNmk3RjhBVC9yak9U?=
 =?utf-8?B?ZEtjL3lBMU4xMGVVUmtOdTRJa0VXTk1nZVo0Rll4K2ZmRnpETktyVVZDaW5K?=
 =?utf-8?B?TmNuRXQxK2d4a01yczFVMHJyWFZZS29DcmRVSlJraXc0T0wrSko4c2t2a1Zh?=
 =?utf-8?B?ZHRFSGNjNndxb0pPUS9kRzl0dHlEdUtLR0M2TUVKYjcvbVh5VmhFS3ZLeWxn?=
 =?utf-8?B?MlV6c0FJU3laZXZnNEt6RFVwYXZCM3lObEpvaXltd1J6VlpBN3VERFNYSDA1?=
 =?utf-8?B?VU45Ylp1RzBOMmtlbWpFeXRlN3U5T00vb25HcUpPNk9jSDBRb3FYcHNjM3pj?=
 =?utf-8?B?YXNOTTBLaGExZlgzblRSZm8rajVLOGUvT0pFOHZXM3dWV0IwZGpVcmRyQ1F4?=
 =?utf-8?B?Sm9GdDVKZE9UUlRNMHBuSTlHZ3FBdDNWZ2djM2EwVWdqMHNCd1RGa2g0OHlS?=
 =?utf-8?B?Skx0NStyR01KeG9tNFlqK2thVWdMZDZDMzM0eGNla0FCOWNPZUxWQmpJemI5?=
 =?utf-8?B?a2hPVXZBQ2hpR2RFc3pINW05OFJGeSs2OHF1WE9wRWxIcFM3cXFBSnRsbXNV?=
 =?utf-8?Q?wdqFBtLzjbBTHpKltaVueF2B/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1ca2aa-6fbf-40f3-c22d-08da876f965b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 14:30:56.3811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfuUxMqVDfICzVwmb7nUV6iphq00Wt8iRqN9XV6bEahvM6iBAhnGsNVu1wz2zRXN5eTQdp52ZrgL6N3vUABYpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5481
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/2022 4:02 AM, Alex Williamson wrote:
> On Thu, 18 Aug 2022 22:31:03 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 8/17/2022 11:10 PM, Jason Gunthorpe wrote:
>>> On Wed, Aug 17, 2022 at 09:34:30PM +0530, Abhishek Sahu wrote:  
>>>> On 8/17/2022 7:23 PM, Jason Gunthorpe wrote:  
>>>>> On Wed, Aug 17, 2022 at 10:43:23AM +0530, Abhishek Sahu wrote:
>>>>>  
>>>>>> +static int
>>>>>> +vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
>>>>>> +				   void __user *arg, size_t argsz)  
>>>>>
>>>>> This should be
>>>>>   struct vfio_device_low_power_entry_with_wakeup __user *arg
>>>>>  
>>>>
>>>>  Thanks Jason.
>>>>
>>>>  I can update this.
>>>>
>>>>  But if we look the existing code, for example
>>>>  (vfio_ioctl_device_feature_mig_device_state()), then there it still uses
>>>>  'void __user *arg' only. Is this a new guideline which we need to take
>>>>  care ?  
>>>
>>> I just sent a patch that fixes that too
>>>   
>>
>>  Thanks for the update.
>>  I will change this. 
>>
>>>>  Do we need to keep the IOCTL name alphabetically sorted in the case list.
>>>>  Currently, I have added in the order of IOCTL numbers.  
>>>
>>> It is generally a good practice to sort lists of things.
>>>
>>> Jason  
>>
>>  Sure. I will make the sorted list.
> 
> The series looks good to me, so I'd suggest to rebase on Jason's
> patches[1][2] so you can easily sort out the above.  Thanks,
> 
> Alex
> 
> [1]https://lore.kernel.org/all/0-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com/
> [2]https://lore.kernel.org/all/0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com/
> 

 Thanks Alex.
 I will rebase my patches to the above mentioned patch series
 and will send the updated patches.

 Regards,
 Abhishek
