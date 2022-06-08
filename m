Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A52542D88
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 12:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbiFHKZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 06:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236778AbiFHKXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 06:23:22 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B4F20C243;
        Wed,  8 Jun 2022 03:12:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JK3d5j5B7SNr0TdUnfDypoOetngio4MG8O03V4qQtgojdzaPB2v3PqakzckT48Lw9WzaZBgpUcNX6H82gk0FSjrrxCB/iJCTtZLv4RdeBbkXsdRwl83Z1XGLNu6adtwJRyKZTkYce8CG16HDPT+cUs08nKZUH7JqZfRzUq5oUDF4tCpXo0gz/Zf5tZFA6mTlY3dfSwfNBWSWvkIc0ThWVEjXtwoaSgM52jZICcK2Pb9h6Z+fCWboUvxvti7svEhEtPAxA1u49uvhH+3NZgpiH9ntVfDjSnruj5qFfkbMwhRXe2xXKd7sNcyZvqNtV7w5BgSR22HOFf9HQWvK4TueWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qqsbib5rKJkLjB5uAOWvILXthuFc0tn5LjcBO8C8sf8=;
 b=IBwK2VrJyFahWf2ihZxtKPDSlTocIs/FUhoX0Oa0ZhhD5J8Jz+j45sixfn2t90EwEzhmWddW6Pn//NlAQMycbipYivFQuo634eLElAfoqa8eE4iTqS/mUE5uqkqsDGCyBt21uMzyWjNK4/6JR6XDzO7K2dacJf0Y2sLo55Szub/AfrvXrLEKn2xbwyUzT/PY24SeOwHzaUAGerNXFhkzBR3+qjq1FR7C3L5fkWxwYexZMvEvpgojj3VBKc/dWUZ28P6f04aZGoz4roZiWHHzlpfj6UfQpahWbdTsnHdjjDFAWWYAcXtsBc7OvCOJAit4yVxsaIMjvEAVDWXAm5iNmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqsbib5rKJkLjB5uAOWvILXthuFc0tn5LjcBO8C8sf8=;
 b=TjwNbVqbkOrOODh0zfUPCJejdFEHWYvlbceC2qr17LaIcPSSyszs9atUGiNE4+3qJ97Nq7C7kr96tXQxs25ZJSKKD+3smXGoyJuOuY/PrBy6DKqEMFqFvz9U4ZZEkj0qHiOMR9QcCS4Dv/hqQPP0Tm6IWAB9S4IQaXEc6nBIz7+JbGbah4xzIXlvcWJS/pVdTJiISSgLbj2gy8ma3paFzfeDiOBRRjad+A5JG1PZqJFkkA/ljxG+d3VFHAxq8J51pUgkeeGZ4G5TunwPEiBTeD39uriwmDKV7HpJ3qzqTLF3sMxUloFSw1XuMTqrYSiCs6WXwFZJOaQPGsD0+6Gr0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by DM4PR12MB5309.namprd12.prod.outlook.com (2603:10b6:5:390::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 10:12:56 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057%4]) with mapi id 15.20.5332.012; Wed, 8 Jun 2022
 10:12:56 +0000
Message-ID: <4d7beb74-8958-2ec6-fcd6-1ac40e4d29cd@nvidia.com>
Date:   Wed, 8 Jun 2022 15:42:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
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
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-9-abhsahu@nvidia.com>
 <20220504134551.70d71bf0.alex.williamson@redhat.com>
 <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
 <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
 <42518bd5-da8b-554f-2612-80278b527bf5@nvidia.com>
 <20220530122546.GZ1343366@nvidia.com>
 <c73d537b-a653-bf79-68cd-ddc8f0f62a25@nvidia.com>
 <20220531194304.GN1343366@nvidia.com>
 <20220531165209.1c18854f.alex.williamson@redhat.com>
 <00b6e380-ecf4-1eaf-f950-2c418bdb6cac@nvidia.com>
 <20220601102151.75445f6a.alex.williamson@redhat.com>
 <088c7896-d888-556e-59d7-a21c05c6d808@nvidia.com>
 <20220602114412.55d1e2c8.alex.williamson@redhat.com>
 <8d2d34f5-8b5d-0b85-4603-d65160427bf1@nvidia.com>
 <20220607155031.078fc817.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220607155031.078fc817.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0048.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::19) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f4cdc06-34ba-4600-f50c-08da493774d7
X-MS-TrafficTypeDiagnostic: DM4PR12MB5309:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5309AD7E5BD635754011F43BCCA49@DM4PR12MB5309.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fbnhLfVDRdKD2uwlLouKFsoOPu4ogXRP71n6EhCS4mnNa/iMyL6hm4xsXw7mTuqQdbRkUjswM5SRbcqWupon2yLbi6HjPQ0UnksZgjPjDXE6sBjv0o8YrmZe2Oo/iudvOum8xHlIGf1P9IHN8FYuQ9UTX8VfsY8bBGETBr16bccAzFp8+RpdGCsfIy6YQlC7nx+TemG/DVxDZXzdtv2FMVSQzU82XRaAnU0ZDmq3azqmU9anjgkjfrwLnSW7UMi2j5XKCkv/Dw6M2Fj0FmS3gz8RdOSyvFzqPLra6iJNgHeGlWmegcW2F7Kcs04n2GW9gXeudyEATCYh9/nsJn6jtGJYY2RMKv5qP8/1gWYNCVAX+x1nY2HjYI7R30BvXwcfiM9Eyeye//IxzVznHyViuXRXtVlxQyk5+U+I/FCAR+S+/lfB5rRcq6r1Z0MZU/pii3JRHImdFq49DZpghQPEMUqLzPS3SRmK9JAdy5dPf1chR9G8MoE5CPtDJ1OPGvLSKb6xMtdG2wqFqUJP8DFGKDxiJCPVrItiae8zvJMTwQQrjKm3luXh7lRXr/0TbRHw8iQcGKWrF0XRKYBswba405x3t/f2CD2rnwZW4MDYSvqmhPzPsK73Bpe8l5VkEzGLbc2KWBSWr3xCoJj70pvT+7OCD49kJY4jPStC3YY1QB8Lvl69jO8sxpgI+qXxmiQDKOzepqI3yp4yjF0bpfDHRIBk+7YyjaN8CXO+LTsoKiTUc4nD8NS7hvTGXgNgGC4DtFBntZVtN6K3Oq60Vx/Epg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(2906002)(6666004)(83380400001)(2616005)(186003)(36756003)(316002)(54906003)(6916009)(31686004)(26005)(38100700002)(6506007)(53546011)(55236004)(66556008)(508600001)(66946007)(66476007)(8676002)(31696002)(5660300002)(86362001)(7416002)(8936002)(30864003)(4326008)(6486002)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnZ1US9GV01tV3RUNnFwMGoxV0V6blYySFRWOENuWEhpcE45Um5GQ2VwRFlF?=
 =?utf-8?B?eVpZaEo1bytyVzBqTzZ1OTE2eFkzQlNMZDdpMS9jRllGRDR0SHc0VEtwVG9a?=
 =?utf-8?B?SDQyY0IyaVpyNUQ3ZERIc2hWcFYzQVI1d3hCTkRnWFh1TjF1Y2tTcC9VN3g4?=
 =?utf-8?B?NUgyd250WmQzRkg0Z3VlRjg1U2VFTWhYYWRJVEpIU3BWOExkWUlIc0t6aFZQ?=
 =?utf-8?B?NW9acEZSOEpFZ1RUR2thV0xyVkRqbjhONjZIWFM2eDNPVXd4L3RKRW53VmFk?=
 =?utf-8?B?M2RGQ2p4SldrRHJMNWtpdldCTU5tbEZoMys3c2F5aFBIOGRjQ0xRQ3hkaklI?=
 =?utf-8?B?TjY0Rm1WWFovKzFlNG4waTJwSC9Sa0k0RmdWKytZMlJWYkVCOHkxTjAvbDBj?=
 =?utf-8?B?SitlaW8yNXBOcHcramNLdVpRa2RxdHExV2k5bC84NmNBT21qUkhNQWw2UTJr?=
 =?utf-8?B?SW9tUHZpbHJLVmlQRjJQU2dGY05QSVhJSHhZamJkNE5QQmZjZDhtaUp5cy9B?=
 =?utf-8?B?L213ZnM5bGdsZU9DODliOC9LZzJBRlNsUFR1MWdzVzFVd2swRHVJWjJYemRw?=
 =?utf-8?B?QmZnQ3BqNkFDOTJEeTJoeUFrazk1VlFMTSt3cGJiU0dFNW5KWlYzRjlvR1Z5?=
 =?utf-8?B?M2ZNVUVrd0V0YlIxWkRmTXorNXRaOEVTS2hMc0Jxem9OWjlPcjJldnRBQWRN?=
 =?utf-8?B?cjE3L2FQS053L3hQWWVXeTh3ZG13S21HcUs0eCtxTVVyem5NRnBtOGN1Ym1G?=
 =?utf-8?B?Y1dGeHpBSGRFdC9iQXNFN1c3WHY0SEJPdUdHVWliWjgxQjdGN3I3MFF5ZU92?=
 =?utf-8?B?VStwbWszdkZBVUovQVVKcit2aE9HVWdIc1FTQnExbGZnNXUwVkZmdjlzT1Ay?=
 =?utf-8?B?MGpJNTVTRDREaXdxVUI2YVlMd09KbWVZMDJZTkc5TkZJMVdBcFJiRytlY3U0?=
 =?utf-8?B?bGlzb3JvY3dDN0VSTVhmNnlGZDJ5a1FMaDU1bk93YjNodUFHMVdyRS9OZ0Yv?=
 =?utf-8?B?OEtiZVBGc3EyNnIvaVNETXJQeHBHbHBGa0MyWnlzTUxKL3prVVIrb1NuMjRw?=
 =?utf-8?B?YW1mM21GM2dINEVVc3lIQlhrelRCQUJDYVIxUit0dHZFanJTZDNuWnZ0UGhQ?=
 =?utf-8?B?Y1I0aytjSGdWUTZNSjNyN201Y3NZZzBVdEpFN2lORXMrcUN2M3pYanZXa1Fp?=
 =?utf-8?B?eXRlcW9UdExLKy9HVDdPbkhlWTl4NC9iNnlBRW1RQkZPc0t6NTV3eTVzd2ZC?=
 =?utf-8?B?d1lXVVpqWW8rV0ROR1pjc2FQL0VFaDhmMk96K282cnFpNC81cVhBTVZ3YnFs?=
 =?utf-8?B?ZXliYXdIR1ZWVkJVRWlGWnZNUERnSGlyRVNtRE1id2w2cWxrQmpEa2RqckZM?=
 =?utf-8?B?SW5BNnNibWpyV29vUHZLQ3lOSVQ1cVM4bjVINWlmcjA5V01LeC9qM2JEV0Rq?=
 =?utf-8?B?bi91UktDTFJITTdLdytEcUlzRzJBQWVzMHhTdG8wbHpFUy9lSWg5WUU1NzZK?=
 =?utf-8?B?QkIrbVY0QUZHd1JiU1p6VWdmVkhtTzhwSUUwRTJUTlNvdmdmT1Q0ekhscExD?=
 =?utf-8?B?cU5sbHNpNzdValRvSzZwZWo2NWNvd0lkd25HbmZnK1NTb0ozSWlZaEFlYk42?=
 =?utf-8?B?R0NLNW5JTFNsc3RNWVBZZzUrOUFCYnFaRjlXZENHVFJ1bjFRZW9Jem1HYm9i?=
 =?utf-8?B?YnplS0RWYXlZKys4alZWWUJtZXBPcVFaTklHaUEyaWxyZUs4UXAwMlhja2Qw?=
 =?utf-8?B?Vzg5MExSa3NtRmFIWi8yU0JCblYvelRQNThsYkVGOVlXZXU0WkIxWDB0cXFq?=
 =?utf-8?B?SFJkekhVZVVkMW14ZTRTRVRnWjl3Tmk2ZU96cFN2eGs3YS81M0dabEJGWURj?=
 =?utf-8?B?QWtyTzQ4eWNQQktYUkNsV1hKdDNrV2xNcFZnakdiOU4vY0t4MjJ1ekR0QnFo?=
 =?utf-8?B?TVAzTTlJeGtsOWFISjdya1hvWlpzZklEeXhiUXFTRm1pMllnZmQraTY2TkNw?=
 =?utf-8?B?dFNiTTU3OU03YzU2WUtPeW1DaWNGR3BYNDJ4UjFBK3VXV2Fzajg3M3FHNStF?=
 =?utf-8?B?bWRqSHY5aXdUQ0dGUW5zZ2FVZ0h4dkhkUEpha0Qybk1aVDluZVhIaXN3UzYr?=
 =?utf-8?B?VU5OdEJNcHJJWnNqa05GSkdhSlM5SzhmRTcyOE5qcVp6OVVVb1NXVUo0Vlhx?=
 =?utf-8?B?OHFQODdGa1Z1b01zdTRieFFuYTlsSklrUGJpL01wbDg4emRrajQ5bnl1REho?=
 =?utf-8?B?Y2c4RFdRNlNxeGFmYVREU2NlbThvdDV3VWxEbXk5RUJnQ01qUkQwNHpQdmc3?=
 =?utf-8?B?YmI1bUI0SzVOVnljdEdqbUNxMm5GTC9uRHBXcU9pMHpHUGV0NCtFUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4cdc06-34ba-4600-f50c-08da493774d7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 10:12:56.0885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzyGX2TcrUcOMCPd9TvuPqx/M+cu7wi72wsHF/prPklQQYDN2LffQnCgBKH80+JWYr5IqCVJRYOq9XY9lkY1DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5309
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/2022 3:20 AM, Alex Williamson wrote:
> On Fri, 3 Jun 2022 15:49:27 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 6/2/2022 11:14 PM, Alex Williamson wrote:
>>> On Thu, 2 Jun 2022 17:22:03 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>   
>>>> On 6/1/2022 9:51 PM, Alex Williamson wrote:  
>>>>> On Wed, 1 Jun 2022 15:19:07 +0530
>>>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>>>     
>>>>>> On 6/1/2022 4:22 AM, Alex Williamson wrote:    
>>>>>>> On Tue, 31 May 2022 16:43:04 -0300
>>>>>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>>>>       
>>>>>>>> On Tue, May 31, 2022 at 05:44:11PM +0530, Abhishek Sahu wrote:      
>>>>>>>>> On 5/30/2022 5:55 PM, Jason Gunthorpe wrote:        
>>>>>>>>>> On Mon, May 30, 2022 at 04:45:59PM +0530, Abhishek Sahu wrote:
>>>>>>>>>>         
>>>>>>>>>>>  1. In real use case, config or any other ioctl should not come along
>>>>>>>>>>>     with VFIO_DEVICE_FEATURE_POWER_MANAGEMENT ioctl request.
>>>>>>>>>>>  
>>>>>>>>>>>  2. Maintain some 'access_count' which will be incremented when we
>>>>>>>>>>>     do any config space access or ioctl.        
>>>>>>>>>>
>>>>>>>>>> Please don't open code locks - if you need a lock then write a proper
>>>>>>>>>> lock. You can use the 'try' variants to bail out in cases where that
>>>>>>>>>> is appropriate.
>>>>>>>>>>
>>>>>>>>>> Jason        
>>>>>>>>>
>>>>>>>>>  Thanks Jason for providing your inputs.
>>>>>>>>>
>>>>>>>>>  In that case, should I introduce new rw_semaphore (For example
>>>>>>>>>  power_lock) and move ‘platform_pm_engaged’ under ‘power_lock’ ?        
>>>>>>>>
>>>>>>>> Possibly, this is better than an atomic at least
>>>>>>>>      
>>>>>>>>>  1. At the beginning of config space access or ioctl, we can take the
>>>>>>>>>     lock
>>>>>>>>>  
>>>>>>>>>      down_read(&vdev->power_lock);        
>>>>>>>>
>>>>>>>> You can also do down_read_trylock() here and bail out as you were
>>>>>>>> suggesting with the atomic.
>>>>>>>>
>>>>>>>> trylock doesn't have lock odering rules because it can't sleep so it
>>>>>>>> gives a bit more flexability when designing the lock ordering.
>>>>>>>>
>>>>>>>> Though userspace has to be able to tolerate the failure, or never make
>>>>>>>> the request.
>>>>>>>>      
>>>>>>
>>>>>>  Thanks Alex and Jason for providing your inputs.
>>>>>>
>>>>>>  Using down_read_trylock() along with Alex suggestion seems fine.
>>>>>>  In real use case, config space access should not happen when the
>>>>>>  device is in low power state so returning error should not
>>>>>>  cause any issue in this case.
>>>>>>    
>>>>>>>>>          down_write(&vdev->power_lock);
>>>>>>>>>          ...
>>>>>>>>>          switch (vfio_pm.low_power_state) {
>>>>>>>>>          case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
>>>>>>>>>                  ...
>>>>>>>>>                          vfio_pci_zap_and_down_write_memory_lock(vdev);
>>>>>>>>>                          vdev->power_state_d3 = true;
>>>>>>>>>                          up_write(&vdev->memory_lock);
>>>>>>>>>
>>>>>>>>>          ...
>>>>>>>>>          up_write(&vdev->power_lock);        
>>>>>>>>
>>>>>>>> And something checks the power lock before allowing the memor to be
>>>>>>>> re-enabled?
>>>>>>>>      
>>>>>>>>>  4.  For ioctl access, as mentioned previously I need to add two
>>>>>>>>>      callbacks functions (one for start and one for end) in the struct
>>>>>>>>>      vfio_device_ops and call the same at start and end of ioctl from
>>>>>>>>>      vfio_device_fops_unl_ioctl().        
>>>>>>>>
>>>>>>>> Not sure I followed this..      
>>>>>>>
>>>>>>> I'm kinda lost here too.      
>>>>>>
>>>>>>
>>>>>>  I have summarized the things below
>>>>>>
>>>>>>  1. In the current patch (v3 8/8), if config space access or ioctl was
>>>>>>     being made by the user when the device is already in low power state,
>>>>>>     then it was waking the device. This wake up was happening with
>>>>>>     pm_runtime_resume_and_get() API in vfio_pci_config_rw() and
>>>>>>     vfio_device_fops_unl_ioctl() (with patch v3 7/8 in this patch series).
>>>>>>
>>>>>>  2. Now, it has been decided to return error instead of waking the
>>>>>>     device if the device is already in low power state.
>>>>>>
>>>>>>  3. Initially I thought to add following code in config space path
>>>>>>     (and similar in ioctl)
>>>>>>
>>>>>>         vfio_pci_config_rw() {
>>>>>>             ...
>>>>>>             down_read(&vdev->memory_lock);
>>>>>>             if (vdev->platform_pm_engaged)
>>>>>>             {
>>>>>>                 up_read(&vdev->memory_lock);
>>>>>>                 return -EIO;
>>>>>>             }
>>>>>>             ...
>>>>>>         }
>>>>>>
>>>>>>      And then there was a possibility that the physical config happens
>>>>>>      when the device in D3cold in case of race condition.
>>>>>>
>>>>>>  4.  So, I wanted to add some mechanism so that the low power entry
>>>>>>      ioctl will be serialized with other ioctl or config space. With this
>>>>>>      if low power entry gets scheduled first then config/other ioctls will
>>>>>>      get failure, otherwise low power entry will wait.
>>>>>>
>>>>>>  5.  For serializing this access, I need to ensure that lock is held
>>>>>>      throughout the operation. For config space I can add the code in
>>>>>>      vfio_pci_config_rw(). But for ioctls, I was not sure what is the best
>>>>>>      way since few ioctls (VFIO_DEVICE_FEATURE_MIGRATION,
>>>>>>      VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE etc.) are being handled in the
>>>>>>      vfio core layer itself.
>>>>>>
>>>>>>  The memory_lock and the variables to track low power in specific to
>>>>>>  vfio-pci so I need some mechanism by which I add low power check for
>>>>>>  each ioctl. For serialization, I need to call function implemented in
>>>>>>  vfio-pci before vfio core layer makes the actual ioctl to grab the
>>>>>>  locks. Similarly, I need to release the lock once vfio core layer
>>>>>>  finished the actual ioctl. I have mentioned about this problem in the
>>>>>>  above point (point 4 in my earlier mail).
>>>>>>    
>>>>>>> A couple replies back there was some concern
>>>>>>> about race scenarios with multiple user threads accessing the device.
>>>>>>> The ones concerning non-deterministic behavior if a user is
>>>>>>> concurrently changing power state and performing other accesses are a
>>>>>>> non-issue, imo.        
>>>>>>
>>>>>>  What does non-deterministic behavior here mean.
>>>>>>  Is it for user side that user will see different result
>>>>>>  (failure or success) during race condition or in the kernel side
>>>>>>  (as explained in point 3 above where physical config access
>>>>>>  happens when the device in D3cold) ? My concern here is for later
>>>>>>  part where this config space access in D3cold can cause fatal error
>>>>>>  on the system side as we have seen for memory disablement.    
>>>>>
>>>>> Yes, our only concern should be to prevent such an access.  The user
>>>>> seeing non-deterministic behavior, such as during concurrent power
>>>>> control and config space access, all combinations of success/failure
>>>>> are possible, is par for the course when we decide to block accesses
>>>>> across the life of the low power state.
>>>>>      
>>>>>>> I think our goal is only to expand the current
>>>>>>> memory_lock to block accesses, including config space, while the device
>>>>>>> is in low power, or some approximation bounded by the entry/exit ioctl.
>>>>>>>
>>>>>>> I think the remaining issues is how to do that relative to the fact
>>>>>>> that config space access can change the memory enable state and would
>>>>>>> therefore need to upgrade the memory_lock read-lock to a write-lock.
>>>>>>> For that I think we can simply drop the read-lock, acquire the
>>>>>>> write-lock, and re-test the low power state.  If it has changed, that
>>>>>>> suggests the user has again raced changing power state with another
>>>>>>> access and we can simply drop the lock and return -EIO.
>>>>>>>       
>>>>>>
>>>>>>  Yes. This looks better option. So, just to confirm, I can take the
>>>>>>  memory_lock read-lock at the starting of vfio_pci_config_rw() and
>>>>>>  release it just before returning from vfio_pci_config_rw() and
>>>>>>  for memory related config access, we will release this lock and
>>>>>>  re-aquiring again write version of this. Once memory write happens,
>>>>>>  then we can downgrade this write lock to read lock ?    
>>>>>
>>>>> We only need to lock for the device access, so if you've finished that
>>>>> access after acquiring the write-lock, there'd be no point to then
>>>>> downgrade that to a read-lock.  The access should be finished by that
>>>>> point.
>>>>>    
>>>>
>>>>  I was planning to take memory_lock read-lock at the beginning of
>>>>  vfio_pci_config_rw() and release the same just before returning from
>>>>  this function. If I don't downgrade it back to read-lock, then the
>>>>  release in the end will be called for the lock which has not taken.
>>>>  Also, user can specify count to any number of bytes and then the
>>>>  vfio_config_do_rw() will be invoked multiple times and then in
>>>>  the second call, it will be without lock.  
>>>
>>> Ok, yes, I can imagine how it might result in a cleaner exit path to do
>>> a downgrade_write().
>>>   
>>>>>>  Also, what about IOCTLs. How can I take and release memory_lock for
>>>>>>  ioctl. is it okay to go with Patch 7 where we call
>>>>>>  pm_runtime_resume_and_get() before each ioctl or we need to do the
>>>>>>  same low power check for ioctl also ?
>>>>>>  In Later case, I am not sure how should I do the implementation so
>>>>>>  that all other ioctl are covered from vfio core layer itself.    
>>>>>
>>>>> Some ioctls clearly cannot occur while the device is in low power, such
>>>>> as resets and interrupt control, but even less obvious things like
>>>>> getting region info require device access.  Migration also provides a
>>>>> channel to device access.  Do we want to manage a list of ioctls that
>>>>> are allowed in low power, or do we only want to allow the ioctl to exit
>>>>> low power?
>>>>>     
>>>>
>>>>  In previous version of this patch, you mentioned that maintaining the
>>>>  safe ioctl list will be tough to maintain. So, currently we wanted to
>>>>  allow the ioctl for low power exit.  
>>>
>>> Yes, I'm still conflicted in how that would work.
>>>    
>>>>> I'm also still curious how we're going to handle devices that cannot
>>>>> return to low power such as the self-refresh mode on the GPU.  We can
>>>>> potentially prevent any wake-ups from the vfio device interface, but
>>>>> that doesn't preclude a wake-up via an external lspci.  I think we need
>>>>> to understand how we're going to handle such devices before we can
>>>>> really complete the design.  AIUI, we cannot disable the self-refresh
>>>>> sleep mode without imposing unreasonable latency and memory
>>>>> requirements on the guest and we cannot retrigger the self-refresh
>>>>> low-power mode without non-trivial device specific code.  Thanks,
>>>>>
>>>>> Alex
>>>>>     
>>>>
>>>>  I am working on adding support to notify guest through virtual PME
>>>>  whenever there is any wake-up triggered by the host and the guest has
>>>>  already put the device into runtime suspended state. This virtual PME
>>>>  will be similar to physical PME. Normally, if PCI device need power
>>>>  management transition, then it sends PME event which will be
>>>>  ultimately handled by host OS. In virtual PME case, if host need power
>>>>  management transition, then it sends event to guest and then guest OS
>>>>  handles these virtual PME events. Following is summary:
>>>>
>>>>  1. Add the support for one more event like VFIO_PCI_ERR_IRQ_INDEX
>>>>     named VFIO_PCI_PME_IRQ_INDEX and add the required code for this
>>>>     virtual PME event.
>>>>
>>>>  2. From the guest side, when the PME_IRQ is enabled then we will
>>>>     set event_fd for PME.
>>>>
>>>>  3. In the vfio driver, the PME support bits are already
>>>>     virtualized and currently set to 0. We can set PME capability support
>>>>     for D3cold so that in guest, it looks like
>>>>
>>>>      Capabilities: [60] Power Management version 3
>>>>      Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>>>>             PME(D0-,D1-,D2-,D3hot-,D3cold+)
>>>>
>>>>  4. From the guest side, it can do PME enable (PME_En bit in Power
>>>>     Management Control/Status Register) which will be again virtualized.
>>>>
>>>>  5. When host gets request for resuming the device other than from
>>>>     low power ioctl, then device pm usage count will be incremented, the
>>>>     PME status (PME_Status bit in Power Management Control/Status Register)
>>>>     will be set and then we can do the event_fd signal.
>>>>
>>>>  6. In the PCIe, the PME events will be handled by root port. For
>>>>     using low power D3cold feature, it is required to create virtual root
>>>>     port in hypervisor side and when hypervisor receives this PME event,
>>>>     then it can send virtual interrupt to root port.
>>>>
>>>>  7. If we take example of Linux kernel, then pcie_pme_irq() will
>>>>     handle this and then do the runtime resume on the guest side. Also, it
>>>>     will clear the PME status bit here. Then guest can put the device
>>>>     again into suspended state.
>>>>
>>>>  8. I did prototype changes in QEMU for above logic and was getting wake-up
>>>>     in the guest whenever I do lspci on the host side.
>>>>
>>>>  9. Since currently only nvidia GPU has this limitation to require
>>>>     driver interaction each time before going into D3cold so we can allow
>>>>     the reentry for other device. We can have nvidia vendor (along with
>>>>     VGA/3D controller class code). In future, if any other device also has
>>>>     similar requirement then we can update this list. For other device
>>>>     host can put the device into D3cold in case of any wake-up.
>>>>
>>>>  10. In the vfio driver, we can put all these restriction for
>>>>      enabling PME and return error if user tries to make low power entry
>>>>      ioctl without enabling the PME related things.
>>>>
>>>>  11. The virtual PME can help in handling physical PME also for all
>>>>      the devices. The PME logic is not dependent upon nvidia GPU
>>>>      restriction. If virtual PME is enabled by hypervisor, then when
>>>>      physical PME wakes the device, then it will resume on the guest side
>>>>      also.  
>>>
>>> So if host accesses through things like lspci are going to wake the
>>> device and we can't prevent that, and the solution to that is to notify
>>> the guest to put the device back to low power, then it seems a lot less
>>> important to try to prevent the user from waking the device through
>>> random accesses.  In that context, maybe we do simply wrap all accesses
>>> with pm_runtime_get/put() put calls, which eliminates the problem of
>>> maintaining a list of safe ioctls in low power.
>>>   
>>
>>  So wrap all access with pm_runtime_get()/put() will only be applicable
>>  for IOCTLs. Correct ?
>>  For config space, we can go with the approach discussed earlier in which
>>  we return error ?
> 
> If we need to handle arbitrarily induced wakes from the host, it
> doesn't make much sense to restrict those same sort of accesses by the
> user through the vfio-device.  It also seems a lot easier to simply do
> a pm_get/put() around not only ioctls, but all region accesses to avoid
> the sorts of races you previously identified.  Access through mmap
> should still arguably fault given that there is no discrete end to such
> an access like we have for read/write operations.  Thanks,
> 
> Alex
> 

 Thanks Alex for confirming.
 I will do the same.

 Regards,
 Abhishek
