Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C1D56FEF7
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiGKKdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiGKKdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:33:03 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA339D7B80;
        Mon, 11 Jul 2022 02:43:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQC23Z19FozcXzoldO6wAROAwZONBy4tsGd8fvjcfRsgpvIWmVWTV4zSZTUj13HxtA2DW7FFU46e4z51hWRLufHen6sten70qyEnrcrMcHatH+ma1yw9W44YnR9JhHj+MAB6CM7q2ZM0K3GpSm8y/fb+Kr5LT7S9wXPyNAaxWoVQ84FRHuqrBE6/mZ2ee++yfEWeRlbJhFVhWPgs3M1Iw/emQCngnMYonhwWckKfxalERmmDE3S5lj6cza64Pwi4Oy8eRsyPe2gY3ACUqMjqOD8GiY/KDQxEZotBpLGXztljDJEwv6CR/eRr7UEzz7inj3wO6SDRp9o9/oQb6rOJFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUiT6yJhJJSutxYMEqX8+TDpsMw+W0CSjuElG3ksN/w=;
 b=YSUdCUx1Hm58SKfjOe3x6E8nlqn38spr4e50eFOXhWhUdIQH03KCRynDSlQi1raBRzThF0VOK6Lbj4DEHdgAlk7eDHRli/OwE7Wz3l0k3kTEGVftDjosLjDmdIC4+i0Rx6Y9AZkKdL1S9uCj/X/8EZI9av3bnw+PyTTjoObxENMMSdbU6CYc0Va3GZUWYuuyxa0b1jsjq18TQs8wv+xwJB7oKvN8KOAKdyDLt9DuHEc10fJ05/0pDXwnSnWBMh7igmw74mzcqixGCb5WtafjcmLMMquSO+NV7hN0IozIJNLhtV2sPa8qtd+TmdC8LgyRiGylPJDaWgrrWa+J6HeLSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUiT6yJhJJSutxYMEqX8+TDpsMw+W0CSjuElG3ksN/w=;
 b=UrOx/cRrs+Z97cvyHjk6mgwl+V1LqFZn+Kmpuz9RhU7nRlAnpWRnyUyHoM7d/DRypZfF3qipr8mthOXj9DXFKsqCTV8F0kLTxqi6Y09fRd0G3GcAD8mZdTNRr6uNSfickQ7ebW2dIbdy6h7zBGIAm1WSwRC3WlUX1xsHst+W6aKPuESMPAfaS44c7+7S4bBStB36gItpT3qIRp/10+nEDS0zhKiOAl6Vmqzov1tdybPlfcrCCC2BKAuahSOg+NAoBjbiQ3X/t8GQk4M6UmHu5E1PvPFiE7kSxmSV+zOyseybLYVgJni+fd/kkcqzZiipIeWV94kWCEzZHLW6T35bCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by DM6PR12MB3193.namprd12.prod.outlook.com (2603:10b6:5:186::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Mon, 11 Jul
 2022 09:43:27 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 09:43:26 +0000
Message-ID: <083b39f0-7ebf-cb8f-fc52-f9a29a4f3d3f@nvidia.com>
Date:   Mon, 11 Jul 2022 15:13:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 2/6] vfio: Add a new device feature for the power
 management
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220701110814.7310-1-abhsahu@nvidia.com>
 <20220701110814.7310-3-abhsahu@nvidia.com>
 <20220706093959.3bd2cbbb.alex.williamson@redhat.com>
 <ad80eb14-18a1-8895-ecfb-32687a4ba021@nvidia.com>
 <20220708103612.18285301.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220708103612.18285301.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXP287CA0003.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::15) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e28645b-4c6d-48d2-73d5-08da6321cdda
X-MS-TrafficTypeDiagnostic: DM6PR12MB3193:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lzPEzZ3ziK2551RmydRqM/Hg4LBxzwcqyyNlaKFjp7etJZLuyMzTSE/gAsLXLoNSt9i2P5OKsFnl3BfKKLwrfpo3vODzyB6+sNn+rlElkH83BoZNE3fiMo44sw9eI3r5pxB78uFty0m23/HoUiJJqXfrXix/aISpHZrr8qmxeFecNmGF+xMfpSkZ701vRLX4qR/xS2Q7Bx4FxsBe+XotZuQsRSowR42LcT5nMNlYvUDMLRAAlCfBz+4WTVOi5ePG8MMTFmRYtzelX4CxLQ8tAnz95DUcH17O10XFBvGNajNjZOMPEXDTyOT2EnbR/ZiAYTkuFL5wshNOMqJlFvlzwe5I4AJdBng31IXxHjTqfE9NzDcEVIg0M8IuAbjuTHrmh2nD6rlbC0623KZwxj/uZxkHd+wNaDG4KFOwqauwfjhlRSDRoKPPSNNqlLgPIIJVgiUvofol+EiAZWhMn0bxWpGoumtjtgej5jasp4CNIfFVMxVkNjYjdvnVQWvN/g6KWyntpq8SbsrZO3BOP5VyFfIALDcfVcsn/G/Lg37yWaKkFJ/Xhi9KyNiTEUkonCWeT99wMe2u3JG5zw4zWswI9d/uAMFJk6fR2heSyaDKzoI9Bp69EvkNhWjqR5FpLjNK/o8VX6W1cvok9gYbv97kEKN5Q07yBWtx4n04ZbXx5IKH6vreysIebXYvc3jhXZPYJxW3hWlkr6/3xMQuF2CUs2OvAWXclsaVtTeXBmGE+39b2VCGFT++QJR3HNYrAjSVW3H3TabBTNV5BUvTxw5uKQlQvgj87Olshspl/JDVYwsf9UEMFsUV1l9/yHHGxrZdZv9n55Kjikwqbcq28PIeEX1PBUyhk1SUIgHPpI/3ack=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(84040400005)(8936002)(7416002)(54906003)(5660300002)(478600001)(86362001)(6486002)(26005)(66946007)(8676002)(66556008)(6916009)(316002)(4326008)(66476007)(2616005)(55236004)(186003)(6512007)(31696002)(38100700002)(41300700001)(6666004)(36756003)(2906002)(53546011)(83380400001)(6506007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDE4M21qMnhNSWd6K1ZlNkRBMkVVY1M3NGU2cHVRYmtJREp4bmZpSzVaS3Ix?=
 =?utf-8?B?bnh5QzQyemZQSGRsY1A1aGhsTk9XUVdIUWgzRHVWSUhOTnAycmFDckNkRWRP?=
 =?utf-8?B?KzdkN1dyc0drOW1ZQnV3RDRXUWp6SlIwMlY5ajNiVmJkaU93aTF0aXJwN1VC?=
 =?utf-8?B?RTBmc2dJSjJrbm9td1VzUWpMTFlVeUVtR3NHOGYxNTRKdENTYkdiMjhPQU1p?=
 =?utf-8?B?QlpuUUNLbGI2THVNWUMwcllpUE5mYzNleW5xQ25sUENtc2txVFRJNC9TRXRw?=
 =?utf-8?B?dHc4bGNIYzg1MEFjQnFRcDYwRUpqZENpN3dURzQvOXJJam96WG9jcnVmYjJQ?=
 =?utf-8?B?NHF4VVhvZWVuTXhMMnJRN0JQaU5nTFFMdWFQQWZ5ZEI2Nm5PYldSdGpVU2dp?=
 =?utf-8?B?WFV3Nmp3TThRRXZqUzYrbFhJWm9FTXp0UWJnaWtySzNCRElLS0VoVkJ5eUpt?=
 =?utf-8?B?VytzaklXVC92bUZVQ1NDcjI4dno0dy9VK013SnZrYUQxKzk4Q3NxZXBwc0Vq?=
 =?utf-8?B?QnFzMk4yRUlTdUprOTI2OU8vZjRKY0dlaVpzOUZKeXMwM080eXJPWG1SOEJL?=
 =?utf-8?B?ZGhrQlRmNWJuU1E3cHlMRnorclU3WVlLenVEL0lSU0dQcS9tTHNMdnhFMXl3?=
 =?utf-8?B?NHNJeXhiYlNrY3pGQU1FZ0tLdVlTQ01TY3c2TjR0ZWxNdXZKWDlZbFgrcVd2?=
 =?utf-8?B?SzRia2ZwRTRPK3RMRDZ5SmJVSTE3VXhCREQ4R09GMmN1bldoYlhCQ2p1NjRx?=
 =?utf-8?B?a25WQ25xdVpndUt5SzAzUXFzNWhHNXhoRy8weVRRUk5hSitxVkVWNW1XWm10?=
 =?utf-8?B?bk5sNFBoVkhhODdyUlgvVG1pamI2NnMyemVsQVBRelR3aGlDUjhUUndZNFAz?=
 =?utf-8?B?NlR4VnBVN2s4aXI5VnZyOENJMFRLRnZ3azErYVFkbnpXQVJCT1ZKbUY5YStU?=
 =?utf-8?B?R2gzWUF4ckVCelBxREZLbi93eUw4dmNEUWs3emlvZVhhNDkyeTRxMmptdVpR?=
 =?utf-8?B?MDJhVWZrSmpzRmJhYU9ZY2U2VTlCaFg5cWV0RGZRUS9Qd09meGE2UkJ2eXJ6?=
 =?utf-8?B?ejQ4ZlkxL0xRTzhGaTVZRUVFc0wzOUt4ME1BSE90YzhNU1ZFbVV0czhOWVZR?=
 =?utf-8?B?dXRqMVlXQklrdUV6OXhDV2k1MTVMRXFRMXc1TWNvTlNtTVVkVVNTUjBaMHFC?=
 =?utf-8?B?em1OTnNNY21jRDBoQ25Fb3ZOT05wWXVEbm4yVzZhUW9IbkkyaWRHTVJqcDl0?=
 =?utf-8?B?YVJpVnl1dXUrbTBiRWRuMkRlVUV0RzhYQ1IvV2dZM2lwaDd2dzZBZlNTVSsr?=
 =?utf-8?B?dkYxNitPdFFsNG9pc2N0ZkFkc1dzWGVOTmVpRzNFVU9ObFIzclV2LzJsTTg0?=
 =?utf-8?B?c2RYM1F1RUVwUW5VTGt5ejFYdHVWVm9jbjlMQ0l0MTNNNWd3MkNOYzAvVkVP?=
 =?utf-8?B?bTQrdlpBY1lpWTQzSmNTM2F6VTNXVElQWnBrRmlZNS9qaEdtSFArTlVqb2lN?=
 =?utf-8?B?aVVjOXNHNlV5Qy9VVmhkNTBWV1AvTTRXTUhzSkVYb1prbUtSZjFqRmZhZWtl?=
 =?utf-8?B?NU9pb0lHSWhDNEZjMTRWQmpiU1FrdVdVUnAzcjJJeWc2UmpkRm9QYVJBRUVh?=
 =?utf-8?B?S3FvZ3dDNEt3czhWSmVKNlV4dEhSeURBT3kvSzhxd2lIT2dYcXIrWTFWdW1X?=
 =?utf-8?B?bDU2OEtsZlFGTzdBb1dvMUpxNGlaaWZmMlZldzVMbGdjaGwwTWg5aFBCQjZJ?=
 =?utf-8?B?MkkrWFVKU2FhRUdlZTRCb0QxOUNjYWx2a2tvSkxHeE0zdktHQjBQaXVzUmJP?=
 =?utf-8?B?UWp3VjZoSUZqdnNHL3lsUG4veXpMbCt5Vm5XY3FDTUgzRW8rRFJLYnJNQ0dP?=
 =?utf-8?B?eWJsQkZmWTQxanM1U2NFYWppSEhnM1p0OFdpUXNwWjVEb3Q5N0I1clk3Z0ZO?=
 =?utf-8?B?d3VUTjJubTcyckpTeHlVc0FGdkJMYVd2ZlQwRnI3dmdnQklDd1dKUVlXd1Rt?=
 =?utf-8?B?dGtSZTdrbXRFUm1tSnp1YlB3VUhPRm9JdS9XRVB1TjhrVHRZbWRQc3Q2ODR1?=
 =?utf-8?B?ZTg4MkdnT3lleDRUSHZsdG9QSWhKQTZueWNGSk9TcWY2WVRXenozeTRMWi9w?=
 =?utf-8?Q?tTEBc3mlmAHMw7HsQl4XXSwyU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e28645b-4c6d-48d2-73d5-08da6321cdda
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 09:43:26.8199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CVQ0+AgBZyPfQqyTbrJ/XUobX+rCAyA7cEsmrJH0VjkLiTi6Z3ZZ1fMOGvuBXvEYC49aHj+57VbNrEuFbW7niw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3193
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/8/2022 10:06 PM, Alex Williamson wrote:
> On Fri, 8 Jul 2022 15:09:22 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 7/6/2022 9:09 PM, Alex Williamson wrote:
>>> On Fri, 1 Jul 2022 16:38:10 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>   
>>>> This patch adds the new feature VFIO_DEVICE_FEATURE_POWER_MANAGEMENT
>>>> for the power management in the header file. The implementation for the
>>>> same will be added in the subsequent patches.
>>>>
>>>> With the standard registers, all power states cannot be achieved. The
>>>> platform-based power management needs to be involved to go into the
>>>> lowest power state. For all the platform-based power management, this
>>>> device feature can be used.
>>>>
>>>> This device feature uses flags to specify the different operations. In
>>>> the future, if any more power management functionality is needed then
>>>> a new flag can be added to it. It supports both GET and SET operations.
>>>>
>>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>>>> ---
>>>>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 55 insertions(+)
>>>>
>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>> index 733a1cddde30..7e00de5c21ea 100644
>>>> --- a/include/uapi/linux/vfio.h
>>>> +++ b/include/uapi/linux/vfio.h
>>>> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
>>>>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>>>>  };
>>>>  
>>>> +/*
>>>> + * Perform power management-related operations for the VFIO device.
>>>> + *
>>>> + * The low power feature uses platform-based power management to move the
>>>> + * device into the low power state.  This low power state is device-specific.
>>>> + *
>>>> + * This device feature uses flags to specify the different operations.
>>>> + * It supports both the GET and SET operations.
>>>> + *
>>>> + * - VFIO_PM_LOW_POWER_ENTER flag moves the VFIO device into the low power
>>>> + *   state with platform-based power management.  This low power state will be
>>>> + *   internal to the VFIO driver and the user will not come to know which power
>>>> + *   state is chosen.  Once the user has moved the VFIO device into the low
>>>> + *   power state, then the user should not do any device access without moving
>>>> + *   the device out of the low power state.  
>>>
>>> Except we're wrapping device accesses to make this possible.  This
>>> should probably describe how any discrete access will wake the device
>>> but ongoing access through mmaps will generate user faults.
>>>   
>>
>>  Sure. I will add that details also.
>>
>>>> + *
>>>> + * - VFIO_PM_LOW_POWER_EXIT flag moves the VFIO device out of the low power
>>>> + *    state.  This flag should only be set if the user has previously put the
>>>> + *    device into low power state with the VFIO_PM_LOW_POWER_ENTER flag.  
>>>
>>> Indenting.
>>>   
>>  
>>  I will fix this.
>>
>>>> + *
>>>> + * - VFIO_PM_LOW_POWER_ENTER and VFIO_PM_LOW_POWER_EXIT are mutually exclusive.
>>>> + *
>>>> + * - VFIO_PM_LOW_POWER_REENTERY_DISABLE flag is only valid with
>>>> + *   VFIO_PM_LOW_POWER_ENTER.  If there is any access for the VFIO device on
>>>> + *   the host side, then the device will be moved out of the low power state
>>>> + *   without the user's guest driver involvement.  Some devices require the
>>>> + *   user's guest driver involvement for each low-power entry.  If this flag is
>>>> + *   set, then the re-entry to the low power state will be disabled, and the
>>>> + *   host kernel will not move the device again into the low power state.
>>>> + *   The VFIO driver internally maintains a list of devices for which low
>>>> + *   power re-entry is disabled by default and for those devices, the
>>>> + *   re-entry will be disabled even if the user has not set this flag
>>>> + *   explicitly.  
>>>
>>> Wrong polarity.  The kernel should not maintain the policy.  By default
>>> every wakeup, whether from host kernel accesses or via user accesses
>>> that do a pm-get should signal a wakeup to userspace.  Userspace needs
>>> to opt-out of that wakeup to let the kernel automatically re-enter low
>>> power and userspace needs to maintain the policy for which devices it
>>> wants that to occur.
>>>   
>>  
>>  Okay. So that means, in the kernel side, we don’t have to maintain
>>  the list which currently contains NVIDIA device ID. Also, in our
>>  updated approach, this opt-out of that wake-up means that user
>>  has not provided eventfd in the feature SET ioctl. Correct ?
> 
> Yes, I'm imagining that if the user hasn't provided a one-shot wake-up
> eventfd, that's the opt-out for being notified of device wakes.  For
> example, pm-resume would have something like:
> 
> 	
> 	if (vdev->pm_wake_eventfd) {
> 		eventfd_signal(vdev->pm_wake_eventfd, 1);
> 		vdev->pm_wake_eventfd = NULL;
> 		pm_runtime_get_noresume(dev);
> 	}
> 
> (eventfd pseudo handling substantially simplified)
> 
> So w/o a wake-up eventfd, the user would need to call the pm feature
> exit ioctl to elevate the pm reference to prevent it going back to low
> power.  The pm feature exit ioctl would be optional if a wake eventfd is
> provided, so some piece of the eventfd context would need to remain to
> determine whether a pm-get is necessary.
> 
>>>> + *
>>>> + * For the IOCTL call with VFIO_DEVICE_FEATURE_GET:
>>>> + *
>>>> + * - VFIO_PM_LOW_POWER_ENTER will be set if the user has put the device into
>>>> + *   the low power state, otherwise, VFIO_PM_LOW_POWER_EXIT will be set.
>>>> + *
>>>> + * - If the device is in a normal power state currently, then
>>>> + *   VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set for the devices where low
>>>> + *   power re-entry is disabled by default.  If the device is in the low power
>>>> + *   state currently, then VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set
>>>> + *   according to the current transition.  
>>>
>>> Very confusing semantics.
>>>
>>> What if the feature SET ioctl took an eventfd and that eventfd was one
>>> time use.  Calling the ioctl would setup the eventfd to notify the user
>>> on wakeup and call pm-put.  Any access to the device via host, ioctl,
>>> or region would be wrapped in pm-get/put and the pm-resume handler
>>> would perform the matching pm-get to balance the feature SET and signal
>>> the eventfd.   
>>
>>  This seems a better option. It will help in making the ioctl simpler
>>  and we don’t have to add a separate index for PME which I added in
>>  patch 6. 
>>
>>> If the user opts-out by not providing a wakeup eventfd,
>>> then the pm-resume handler does not perform a pm-get. Possibly we
>>> could even allow mmap access if a wake-up eventfd is provided.  
>>
>>  Sorry. I am not clear on this mmap part. We currently invalidates
>>  mapping before going into runtime-suspend. Now, if use tries do
>>  mmap then do we need some extra handling in the fault handler ?
>>  Need your help in understanding this part.
> 
> The option that I'm thinking about is if the mmap fault handler is
> wrapped in a pm-get/put then we could actually populate the mmap.  In
> the case where the pm-get triggers the wake-eventfd in pm-resume, the
> device doesn't return to low power when the mmap fault handler calls
> pm-put.  This possibly allows that we could actually invalidate mmaps on
> pm-suspend rather than in the pm feature enter ioctl, essentially the
> same as we're doing for intx.  I wonder though if this allows the
> possibility that we just bounce between mmap fault and pm-suspend.  So
> long as some work can be done, for instance the pm-suspend occurs
> asynchronously to the pm-put, this might be ok.
> 

 We can do this. But in the normal use case, the situation should
 never arise where user should access any mmaped region when user has
 already put the device into D3 (D3hot or D3cold). This can only happen
 if there is some bug in the guest driver or user is doing wrong
 sequence. Do we need to add handling to officially support this part ?

 pm-get can take more than a second for resume for some devices and
 will doing this in fault handler be safe ?

 Also, we will add this support only when wake-eventfd is provided so
 still w/o wake-eventfd case, the mmap access will still generate fault.
 So, we will have different behavior. Will that be acceptable ?

>>> The
>>> feature GET ioctl would be used to exit low power behavior and would be
>>> a no-op if the wakeup eventfd had already been signaled.  Thanks,
>>>  
>>  
>>  I will use the GET ioctl for low power exit instead of returning the
>>  current status.
> 
> Note that Yishai is proposing a device DMA dirty logging feature where
> the stop and start are exposed via SET on separate features, rather
> than SET/GET.  We should probably maintain some consistency between
> these use cases.  Possibly we might even want two separate pm enter
> ioctls, one with the wake eventfd and one without.  I think this is the
> sort of thing Jason is describing for future expansion of the dirty
> tracking uAPI.  Thanks,
> 
> Alex
> 

 Okay. So, we need to add 3 device features in total.

 VFIO_DEVICE_FEATURE_PM_ENTRY
 VFIO_DEVICE_FEATURE_PM_ENTRY_WITH_WAKEUP
 VFIO_DEVICE_FEATURE_PM_EXIT

 And only the second one need structure which will have only one field
 for eventfd and we need to return error if wakeup-eventfd is not
 provided in the second feature ?

 Do we need to support GET operation also for these ?
 We can skip GET operation since that won’t be very useful.

 Regards,
 Abhishek
