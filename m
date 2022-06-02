Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CB053B834
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 13:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbiFBLwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 07:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbiFBLwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 07:52:22 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2078.outbound.protection.outlook.com [40.107.102.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8044615897E;
        Thu,  2 Jun 2022 04:52:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtvTj9myAgW2CR0Ksy9LS1ovrto+Zw1dNJgOcu7B1xgRc8IBFxSuZBLupizA7Cr0UETULXekKRJ2/rgN6ThTPXoP2RuZQS715ICVMWvX8CaqGi8QxA36wOqaD6QyJHdfH3d/bAh3ux+bP1nYyje61Bo+oHm9sCWD7Go8jkJvhe7neMs6PVCJs8kOwZaUA0ZxkzRFuLCZpPtkEkcwK3MbFrK6H5l+JUSEYH7sO/Jjuuo9bqmtVryXltm2W+CFtD6zVXQzqO3H1BklSqtqSg+d3S4WsNQ83RPQmNGQSxipO9nIMRQRpgzNpgtIvYwKtagLA0PIQgtQpySEP/rrJusmOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOaB7zTqzNgWrfXe4cMql1INbgwoZJG5Wv0KiYzX00w=;
 b=QHQe6M3R5dTr6+9UuCeFfwnnf6rsTQku1ez0FQmW1vYkXmr8mMpBB/Oo2CHVHN8xWn/aXyVbo58sxVaGzg+TfYN4vPqjLHi+tV3S6KEu1I+eu5BL4Nteo8wU5XyIaANGMoCM6pxr4eYP/K2wJpOz/iACmT1G8l031OvlUmr4k4TjG+YKj5duUTm21rU2RA1hTF1EzMT4Be7eGv2fv4HI/72DuBP854v3dYzekr9sxT3TDBf+Sbvsf0mEd2myI4S6l077lD0/MOX9U9qJhjd3l6F4mN6chUucyhJyf2DxOdMPt9VvWLTjh+ibTMH9lUnvFUlPMBC9qrxKTEpT33oCbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOaB7zTqzNgWrfXe4cMql1INbgwoZJG5Wv0KiYzX00w=;
 b=tkwWgTy1C2tpO6OZ3RnwJrAYeC0dHKqj1VmEmgjGqf03xu5XyL6RrWSyLAFmvd3SzXiwOe0Oprw/UL55KwmM3PEVnUCBfZcTGs7e+RhE+J4jxC1vjXEb7z4hF4Sb3GhuUf5WmsiwNzTl8xgnQRQa/cisIdxPKy1992TQ8VxmegPiZqVwd2XmklLys5/8kaph2LlB3XjJ9Vdt3vDIPjAEqBtoqXF0DrgqT1c5OLz5IhnlLRmzluQjZ4pVSD6Fi/jtGbUXqIN0k5gIqCGStyqzmoL4H9URhUec3thaNDejKV/lkRSa/y1+fjEfGaoXneMcI1LEoXHPi2U47F+4oBv9KA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BN6PR1201MB2514.namprd12.prod.outlook.com (2603:10b6:404:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 11:52:16 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057%4]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 11:52:16 +0000
Message-ID: <088c7896-d888-556e-59d7-a21c05c6d808@nvidia.com>
Date:   Thu, 2 Jun 2022 17:22:03 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
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
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220601102151.75445f6a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXPR01CA0113.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::31) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9f105d2-fd98-489a-56b3-08da448e56c8
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2514:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2514828E8CF15DEC7B7A0B6CCCDE9@BN6PR1201MB2514.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IBvGfmOdMFMcY/SyD7RlWEVFe5Yamp6hu7OklOIOKt2ofE2qLBR9J1KdtaQWH6kIck+EHjoKkPsloTu7inMInIIV5Cir2NdI58bjEupuP3mMyw6GKo4af+kmNHimLun5YI/ClWEJOdpzqZDI5Wouim5e07BvGCbNIb0UksdJiEfmeHDZkckFrEbmCUtrg4OiynfFzIfJ49DVFJ81wjGAlegzzHpJ2gwl9Xp11oL9t6240YRYWs7hAdyOVwWEDLbyMLQqcXYECgkgAgon1y5fIsg6NUjk7VTAaHdGGIbzDstL0qG44qkbQaL5wMFFJQ3EWOD7iwwBuzKQGaMdWPs+V90ZynF9CDXTJ67pfBqYKEIsl4Xr5Jq9NV5HJ7BffjVs7fMbAkpKxnfnu+hkRE/P+3Yh5GpXkCgMVcZdD6ojac/tP4lv2tUODEOOtoygauN+s54CKZcEvCzR4dLf5lw/wK1uyVStmSH0TFoTBnrn7jNK8iQC35HsUVQnAMLPDjjPoXDOwxdGrKa3CiuBU551DvSRqwxsncsVFPrAdLz9SjBmYsbLDm/yN1GWzL1T11atP06h1uDkGN5Q9t92kViyW+1oK2h0td2LwXbCSAV7V/hVhkfuSEeskrK9nex3cgGXJvwnp6Hq04Lrxm1vzgEv/5sG3sQ4WhQykZD/baswjsg6zJpgXuk3KN0jhh/4+6uUx3qV4Tn5z5qCr83/kO8EI7Py50ws7x/dLvKa8AXcjQ+E+HuqqfDDivoFKlBM0VOTPTcRiqdf/ZYu6MdPx5OxGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(26005)(86362001)(2616005)(186003)(38100700002)(7416002)(8676002)(83380400001)(4326008)(8936002)(66556008)(66476007)(5660300002)(66946007)(6916009)(54906003)(6512007)(6666004)(316002)(6486002)(53546011)(55236004)(36756003)(2906002)(31686004)(30864003)(508600001)(6506007)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWFRdmxaalVzZkRoUGpibzNXL3E3MTdhamsyVmF2b1YxNVl2T0xSalpNa3Yw?=
 =?utf-8?B?NmZtMFFmUnBCTDQ3QkJmdzRXNUQ1Zks2YVFmOE1HTGxDajkzdDB4cjZCUkg0?=
 =?utf-8?B?b0xiSjFaRlVTTXFpN0kxOFFBYmo4bVpvTUZMd2xTYkVXNjFvRkt3ZHhGVkFm?=
 =?utf-8?B?WlIzaktnOW5leEpmZ3ZscE5NM0RvU1pHTTczUjNpTWFFLzNCenlhRUZlV0tr?=
 =?utf-8?B?bGtmQWVlM3llcWZLNXFDbjFnR2VKSzNOY3RzVVFtc3B3VG45L0dIcTluRDgw?=
 =?utf-8?B?bkdmRjFHQXl3MytqVnYxbmdNUlBLWnVxNDljSG5IaFk1b09JdG9Zb1hBbFhq?=
 =?utf-8?B?WTJpWDBWdHZJVndwWjlxVmJpQVN5ZjlkeDllb3BRQ0M3SDNqdndFZGFNaFRY?=
 =?utf-8?B?RkxyRWhZck1Qb1NISGFpVklpZ3A0Qk5TVXEzc1lCT3l6bWJ5MzZISU5OdWlo?=
 =?utf-8?B?bS8xdkFEa1RISzZkU3V5Y2Jab1hVN2wvTXFLUmpjTmY1ZWt1Mkc1cTEreFNJ?=
 =?utf-8?B?bGczenBtTk5JMndtQTQ1Y0cwTkhYK0p6cjRSTkRtNkJUQUJGc0NBcE90a0ZZ?=
 =?utf-8?B?Qm4zT0k5UTlncVBwaWxHcDhnRHhNRFI4b1ZqSVJqK2tYWWJIZXMzY2pmQkZM?=
 =?utf-8?B?OThkWjBWWXViMXZ2L0QrVStVWnlJQXY2VTRnUXVjbThnd3RBVFRvc0tNYVNE?=
 =?utf-8?B?STV4a0xLVGJKM1ZBWVBQQURmaWs5ZU5xSGxocGEzSFVFR0VpTU9qZnJybE5T?=
 =?utf-8?B?dU1CaE5KQmhlR0JuS3VkL2FoYzJ5VklvVE4vYkZFd3BudnpUUFliaExyMVps?=
 =?utf-8?B?amprU0lPWVU2VEY1VnBIQnlTQjRXTzcrdFpEcHR3WmdiYVY1SGdaRXpsMXhJ?=
 =?utf-8?B?a2RmOUFhRVNUS2JtVGpoUjcwKzN3Y0M2ZG1nWDh5TXRDamE2RFE0akh1YStS?=
 =?utf-8?B?c3lGNnQwS3dqZHgzR3VwNUxjZWE4aWhEOGk0TDNKRkNpREVTUTdoVXNMZ2dw?=
 =?utf-8?B?cVpENittL2k4YXlOczRUeGtNMDFFWURiRE1FRkVTSldJTGRpNFg5dE9JU0x3?=
 =?utf-8?B?Njhjdkt4SkdXM3Frb2lsaE9SY2tVNW1jRG9CNlVNakdhcTB0aVRJdlZvNDcv?=
 =?utf-8?B?WHNSVzBLN21mNDJYSE02SzNFUkVMVXBTUXg4ajUxbnQzV0VuNkZzTE45cEJW?=
 =?utf-8?B?allDcitseFRuS21IYzJuREFlNDhYWWlTeEl5MHVNa0N1TmdpczUySFc2S2Vs?=
 =?utf-8?B?Q1VmNGU2OHRiNlJZUExIbW1lTmw2WWdMN0RIdmdVQWhmVGxFUENJUUlzbTVQ?=
 =?utf-8?B?elQ1SEc3SlBLRDNtQ0laMGNJeXN2RjVLWVFNbzdXa00waExSSERDWFZlcTR5?=
 =?utf-8?B?VGJIa0dMMFB2MjFZVVYvMG9aTFdFcFpKSXBiaDJiL2dlaFF3NEtKdFBLckgr?=
 =?utf-8?B?TUQwTm02Qy9SVEpnUUNGRlMzSlV5L05JVVUxeElhUkhVTmF3cHd5RGNUSHNq?=
 =?utf-8?B?U1hhVUd1NHdOSDdzdGhqYzNDaDU0VVRnc3gwc0grYVcxNFVtdW52cTN4QVVB?=
 =?utf-8?B?d1lrZGtRVW5ZYXhvOFJDazd3Wmh3bXB6VkNxUW9kSEc3V3U5cDlrT2NiVysw?=
 =?utf-8?B?TVlLK2NkVjcydUF3c3o1QkJHR0tjSUhBUDdvaFNhUzh1RmlZOWwwZmZhb2xn?=
 =?utf-8?B?TkRzUHZCSGhqWjJROHdZdDBnaHpVbzVsdHVuZDZHY1pPVlhQcVFISThhYzlD?=
 =?utf-8?B?ZXpNTSszdFhGTHE1b2NqbDhNSlN4RU1rQ29TSWQzd1hHN3lmY2NYcm1qeWFX?=
 =?utf-8?B?Tm9QNmtNT28xdUdCblZIc2tMNDlZUFRwU0cvazRTajVCTWlZUTRIanNxKzNs?=
 =?utf-8?B?dmZjWnRCd2pFZ3BtL0JXcTVnei9XaFJza29lN1BPY1p0Y2hKNndxaVEzN1Zq?=
 =?utf-8?B?NjdrVC9MVEJVditsZFM4QldhZ3UvazNHU3BWTUhvdm0vOUlJVzM1UlFwMmJQ?=
 =?utf-8?B?aHVzY0RYVDYwKzZ1TEY4ZUVzRGhmWDVPcEdlaEZPc21EK0FhRjM3SkI3RCth?=
 =?utf-8?B?bWlDbWhZNG1kZlZMRi80djVFNmIvQUR5c1JhWVBlejJVNlFPWHh3d3BWRWZV?=
 =?utf-8?B?OERTb0RMTE96UHZ5c1cvb2orRXlNVURKRUxPeVlqOTJjNGwwYnQvTFVMQ3VC?=
 =?utf-8?B?TFFYemt6WlJvTWgzSzJBSHJjQnBhWlYvSUtYZm1SRXdZZ2VpS3U0cU9Cb09M?=
 =?utf-8?B?ZHVTOFQxeFhKdUdwK1duT2tyajgyOU5ZU01NZmoxWFBEYytYdW1QaTVmcnZZ?=
 =?utf-8?B?czBTb3g4d3dhYjZyOFJ2bUozY3llU3ZTNFhXWEw3by84Zy9ZT0RXZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f105d2-fd98-489a-56b3-08da448e56c8
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 11:52:16.1641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNOheUoDGHyMImXSlMbRfVEyXx35BVP6khh9YBxXpt8lS41D2J/1ORlCKdj8R3+WpbrxFtO44MLAhdbb5d9AkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2514
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/2022 9:51 PM, Alex Williamson wrote:
> On Wed, 1 Jun 2022 15:19:07 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 6/1/2022 4:22 AM, Alex Williamson wrote:
>>> On Tue, 31 May 2022 16:43:04 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>   
>>>> On Tue, May 31, 2022 at 05:44:11PM +0530, Abhishek Sahu wrote:  
>>>>> On 5/30/2022 5:55 PM, Jason Gunthorpe wrote:    
>>>>>> On Mon, May 30, 2022 at 04:45:59PM +0530, Abhishek Sahu wrote:
>>>>>>     
>>>>>>>  1. In real use case, config or any other ioctl should not come along
>>>>>>>     with VFIO_DEVICE_FEATURE_POWER_MANAGEMENT ioctl request.
>>>>>>>  
>>>>>>>  2. Maintain some 'access_count' which will be incremented when we
>>>>>>>     do any config space access or ioctl.    
>>>>>>
>>>>>> Please don't open code locks - if you need a lock then write a proper
>>>>>> lock. You can use the 'try' variants to bail out in cases where that
>>>>>> is appropriate.
>>>>>>
>>>>>> Jason    
>>>>>
>>>>>  Thanks Jason for providing your inputs.
>>>>>
>>>>>  In that case, should I introduce new rw_semaphore (For example
>>>>>  power_lock) and move ‘platform_pm_engaged’ under ‘power_lock’ ?    
>>>>
>>>> Possibly, this is better than an atomic at least
>>>>  
>>>>>  1. At the beginning of config space access or ioctl, we can take the
>>>>>     lock
>>>>>  
>>>>>      down_read(&vdev->power_lock);    
>>>>
>>>> You can also do down_read_trylock() here and bail out as you were
>>>> suggesting with the atomic.
>>>>
>>>> trylock doesn't have lock odering rules because it can't sleep so it
>>>> gives a bit more flexability when designing the lock ordering.
>>>>
>>>> Though userspace has to be able to tolerate the failure, or never make
>>>> the request.
>>>>  
>>
>>  Thanks Alex and Jason for providing your inputs.
>>
>>  Using down_read_trylock() along with Alex suggestion seems fine.
>>  In real use case, config space access should not happen when the
>>  device is in low power state so returning error should not
>>  cause any issue in this case.
>>
>>>>>          down_write(&vdev->power_lock);
>>>>>          ...
>>>>>          switch (vfio_pm.low_power_state) {
>>>>>          case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
>>>>>                  ...
>>>>>                          vfio_pci_zap_and_down_write_memory_lock(vdev);
>>>>>                          vdev->power_state_d3 = true;
>>>>>                          up_write(&vdev->memory_lock);
>>>>>
>>>>>          ...
>>>>>          up_write(&vdev->power_lock);    
>>>>
>>>> And something checks the power lock before allowing the memor to be
>>>> re-enabled?
>>>>  
>>>>>  4.  For ioctl access, as mentioned previously I need to add two
>>>>>      callbacks functions (one for start and one for end) in the struct
>>>>>      vfio_device_ops and call the same at start and end of ioctl from
>>>>>      vfio_device_fops_unl_ioctl().    
>>>>
>>>> Not sure I followed this..  
>>>
>>> I'm kinda lost here too.  
>>
>>
>>  I have summarized the things below
>>
>>  1. In the current patch (v3 8/8), if config space access or ioctl was
>>     being made by the user when the device is already in low power state,
>>     then it was waking the device. This wake up was happening with
>>     pm_runtime_resume_and_get() API in vfio_pci_config_rw() and
>>     vfio_device_fops_unl_ioctl() (with patch v3 7/8 in this patch series).
>>
>>  2. Now, it has been decided to return error instead of waking the
>>     device if the device is already in low power state.
>>
>>  3. Initially I thought to add following code in config space path
>>     (and similar in ioctl)
>>
>>         vfio_pci_config_rw() {
>>             ...
>>             down_read(&vdev->memory_lock);
>>             if (vdev->platform_pm_engaged)
>>             {
>>                 up_read(&vdev->memory_lock);
>>                 return -EIO;
>>             }
>>             ...
>>         }
>>
>>      And then there was a possibility that the physical config happens
>>      when the device in D3cold in case of race condition.
>>
>>  4.  So, I wanted to add some mechanism so that the low power entry
>>      ioctl will be serialized with other ioctl or config space. With this
>>      if low power entry gets scheduled first then config/other ioctls will
>>      get failure, otherwise low power entry will wait.
>>
>>  5.  For serializing this access, I need to ensure that lock is held
>>      throughout the operation. For config space I can add the code in
>>      vfio_pci_config_rw(). But for ioctls, I was not sure what is the best
>>      way since few ioctls (VFIO_DEVICE_FEATURE_MIGRATION,
>>      VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE etc.) are being handled in the
>>      vfio core layer itself.
>>
>>  The memory_lock and the variables to track low power in specific to
>>  vfio-pci so I need some mechanism by which I add low power check for
>>  each ioctl. For serialization, I need to call function implemented in
>>  vfio-pci before vfio core layer makes the actual ioctl to grab the
>>  locks. Similarly, I need to release the lock once vfio core layer
>>  finished the actual ioctl. I have mentioned about this problem in the
>>  above point (point 4 in my earlier mail).
>>
>>> A couple replies back there was some concern
>>> about race scenarios with multiple user threads accessing the device.
>>> The ones concerning non-deterministic behavior if a user is
>>> concurrently changing power state and performing other accesses are a
>>> non-issue, imo.    
>>
>>  What does non-deterministic behavior here mean.
>>  Is it for user side that user will see different result
>>  (failure or success) during race condition or in the kernel side
>>  (as explained in point 3 above where physical config access
>>  happens when the device in D3cold) ? My concern here is for later
>>  part where this config space access in D3cold can cause fatal error
>>  on the system side as we have seen for memory disablement.
> 
> Yes, our only concern should be to prevent such an access.  The user
> seeing non-deterministic behavior, such as during concurrent power
> control and config space access, all combinations of success/failure
> are possible, is par for the course when we decide to block accesses
> across the life of the low power state.
>  
>>> I think our goal is only to expand the current
>>> memory_lock to block accesses, including config space, while the device
>>> is in low power, or some approximation bounded by the entry/exit ioctl.
>>>
>>> I think the remaining issues is how to do that relative to the fact
>>> that config space access can change the memory enable state and would
>>> therefore need to upgrade the memory_lock read-lock to a write-lock.
>>> For that I think we can simply drop the read-lock, acquire the
>>> write-lock, and re-test the low power state.  If it has changed, that
>>> suggests the user has again raced changing power state with another
>>> access and we can simply drop the lock and return -EIO.
>>>   
>>
>>  Yes. This looks better option. So, just to confirm, I can take the
>>  memory_lock read-lock at the starting of vfio_pci_config_rw() and
>>  release it just before returning from vfio_pci_config_rw() and
>>  for memory related config access, we will release this lock and
>>  re-aquiring again write version of this. Once memory write happens,
>>  then we can downgrade this write lock to read lock ?
> 
> We only need to lock for the device access, so if you've finished that
> access after acquiring the write-lock, there'd be no point to then
> downgrade that to a read-lock.  The access should be finished by that
> point.
>

 I was planning to take memory_lock read-lock at the beginning of
 vfio_pci_config_rw() and release the same just before returning from
 this function. If I don't downgrade it back to read-lock, then the
 release in the end will be called for the lock which has not taken.
 Also, user can specify count to any number of bytes and then the
 vfio_config_do_rw() will be invoked multiple times and then in
 the second call, it will be without lock.
  
>>  Also, what about IOCTLs. How can I take and release memory_lock for
>>  ioctl. is it okay to go with Patch 7 where we call
>>  pm_runtime_resume_and_get() before each ioctl or we need to do the
>>  same low power check for ioctl also ?
>>  In Later case, I am not sure how should I do the implementation so
>>  that all other ioctl are covered from vfio core layer itself.
> 
> Some ioctls clearly cannot occur while the device is in low power, such
> as resets and interrupt control, but even less obvious things like
> getting region info require device access.  Migration also provides a
> channel to device access.  Do we want to manage a list of ioctls that
> are allowed in low power, or do we only want to allow the ioctl to exit
> low power?
> 

 In previous version of this patch, you mentioned that maintaining the
 safe ioctl list will be tough to maintain. So, currently we wanted to
 allow the ioctl for low power exit.

> I'm also still curious how we're going to handle devices that cannot
> return to low power such as the self-refresh mode on the GPU.  We can
> potentially prevent any wake-ups from the vfio device interface, but
> that doesn't preclude a wake-up via an external lspci.  I think we need
> to understand how we're going to handle such devices before we can
> really complete the design.  AIUI, we cannot disable the self-refresh
> sleep mode without imposing unreasonable latency and memory
> requirements on the guest and we cannot retrigger the self-refresh
> low-power mode without non-trivial device specific code.  Thanks,
> 
> Alex
> 

 I am working on adding support to notify guest through virtual PME
 whenever there is any wake-up triggered by the host and the guest has
 already put the device into runtime suspended state. This virtual PME
 will be similar to physical PME. Normally, if PCI device need power
 management transition, then it sends PME event which will be
 ultimately handled by host OS. In virtual PME case, if host need power
 management transition, then it sends event to guest and then guest OS
 handles these virtual PME events. Following is summary:

 1. Add the support for one more event like VFIO_PCI_ERR_IRQ_INDEX
    named VFIO_PCI_PME_IRQ_INDEX and add the required code for this
    virtual PME event.

 2. From the guest side, when the PME_IRQ is enabled then we will
    set event_fd for PME.

 3. In the vfio driver, the PME support bits are already
    virtualized and currently set to 0. We can set PME capability support
    for D3cold so that in guest, it looks like

     Capabilities: [60] Power Management version 3
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
            PME(D0-,D1-,D2-,D3hot-,D3cold+)

 4. From the guest side, it can do PME enable (PME_En bit in Power
    Management Control/Status Register) which will be again virtualized.

 5. When host gets request for resuming the device other than from
    low power ioctl, then device pm usage count will be incremented, the
    PME status (PME_Status bit in Power Management Control/Status Register)
    will be set and then we can do the event_fd signal.

 6. In the PCIe, the PME events will be handled by root port. For
    using low power D3cold feature, it is required to create virtual root
    port in hypervisor side and when hypervisor receives this PME event,
    then it can send virtual interrupt to root port.

 7. If we take example of Linux kernel, then pcie_pme_irq() will
    handle this and then do the runtime resume on the guest side. Also, it
    will clear the PME status bit here. Then guest can put the device
    again into suspended state.

 8. I did prototype changes in QEMU for above logic and was getting wake-up
    in the guest whenever I do lspci on the host side.

 9. Since currently only nvidia GPU has this limitation to require
    driver interaction each time before going into D3cold so we can allow
    the reentry for other device. We can have nvidia vendor (along with
    VGA/3D controller class code). In future, if any other device also has
    similar requirement then we can update this list. For other device
    host can put the device into D3cold in case of any wake-up.

 10. In the vfio driver, we can put all these restriction for
     enabling PME and return error if user tries to make low power entry
     ioctl without enabling the PME related things.

 11. The virtual PME can help in handling physical PME also for all
     the devices. The PME logic is not dependent upon nvidia GPU
     restriction. If virtual PME is enabled by hypervisor, then when
     physical PME wakes the device, then it will resume on the guest side
     also.

 Thanks,
 Abhishek
