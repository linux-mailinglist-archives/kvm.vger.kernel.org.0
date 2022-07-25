Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3005800E2
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 16:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbiGYOlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 10:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiGYOlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 10:41:00 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2BA5F59;
        Mon, 25 Jul 2022 07:40:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVu2TpLcqmp4pxqx4zmZfvGVGxtO9DVd5FRjnnjyMQqdZY62UKla+u+66uWt+6WzXUeSdXu8qD/0YsAF0E/85PlHrqRTvzE70iUQ2Nf1JyLCCWQajcNCCmKst4B4MEkqLuNseBxTf+tIVdIGan+Uj/t++8hd8lhwyAJ3CXsfA1oTUpqHwNVx0KoDzXkfl4U9JE1Xlg2CUC+GeMyQsnm0TqyWNhbMsTV5sst02B/VO4je7tmWKaQLqvT7A9ujQzcJkaQmD57m5Qu5aa3eMT5ZBFsCj3UBEFfGSsVZhbEsCSu/CPXN0yW/P3AlelwZ4zfGSohYIYcx+8jui9/CsFFS/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VlhtqJarWw6fofZRrYdzStdVNOtE4qcJG0iud2A3D2A=;
 b=e1IRDzmKtlFdjci1C/xQOf6TDvx5zC2ww4fPV1VC6RpGAIQ4pXYGb2G0kFhh0TKxpQVAxMup7JfBgg7cbFUVlw71sNRRfOSlBOgL6cJL9sDRCzFjRxhT6+gZY/MZYV84dnCodvca3c1knqHujs48FgcrwVxV48atgSOt+Qfzc4PXOQcyT1GxW3fCFzIVyM+1y6kdls9poT5eeQO0If2Zc7A7oi012uIUbDEwzNezMr6q8QS335GfWkQ/acPitw4bfF58DN/AmNf1EYLZB7gWnYUTfo1gAp76Sqn4PH805o68JAPUCSp65YCauIacIqG0Uea5C5z3DASbIR02n79w8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VlhtqJarWw6fofZRrYdzStdVNOtE4qcJG0iud2A3D2A=;
 b=J5AkF6EfTDTD9+oY4jl/UbOOg3zt5vUOxu7wUifap9lqZHNgFN2OmjMAIN4fh7qJGtENmToJ1pQ2vo1x1paHctWEr4p+XUABSPjFToyJldfYIWeX3TkUcdzJL3pl1IPklmrRy7fQZ8PpPr5bJSrqA+QVk4pQhJAmlXswdLLcgLKEIvodHM3n/h4JTbOA+mkGZnKrKc2kjSgaRwBFeBM48veCewodpb/lUlG6DNasIM7ew/ZR05vKrEqh7GN3Boyl/fBKJDj4l5VikODJZ99i1WnxriZ5oTXIYlt+2W3PCxrsP8UtqMFeLmKZ1/4xbdu/XEzoY3lmmlRS+Grne7YHwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by DM5PR12MB2536.namprd12.prod.outlook.com (2603:10b6:4:b3::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 14:40:57 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 14:40:57 +0000
Message-ID: <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
Date:   Mon, 25 Jul 2022 20:10:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
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
References: <20220719121523.21396-1-abhsahu@nvidia.com>
 <20220719121523.21396-2-abhsahu@nvidia.com>
 <20220721163445.49d15daf.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220721163445.49d15daf.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0151.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::21) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee26daf6-1db2-41db-49bf-08da6e4baf24
X-MS-TrafficTypeDiagnostic: DM5PR12MB2536:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wf6rsfWgogaznmDG7SQFXm5ABPPvmH+VSM1BjgxmzuF8iseoICln80zfe/k2ZWOPghgF0ETsXuMBY5hBMB4w5Gmh1gAyzti3BcvrTDyWHLp+mcZI0TPMd7WB916jHzO6nnaYEb6Px71zbs4ysG1hQnwGviZ5GF33OdjrXPauLbok31lbWtPE7kaoQPPWY1B9OE/QcAsFrCsleRA5mCfx34W+PolLxyU7EhVNT8GwLa5WIBeq/3R0WfiZm0hvozTCKW0FYa5bZWYcmrE4ITAQf/EfUcs96XQ3WlugW0apd+1QAzksu49/YW+KJBXgFLVXMw/vkuTiRzCB34SUsi303yJAHTOItsC+Gs+kAEdN1MMq64v0xM7sEctORpNosCWRsVmqGsKqvFGobHbxg8sRnASLUx/enkRbLB+7sFarkaKKVNQmxaPwDi0/nPwJSjCCOk7r1kBM9RET0Dkl/+9rTCf7QjQCmiJpgu9/JG+5s1MjXsWRDXy+INgPNoct36YezeAbkcZ9uWk/lYUs+Lffhcq3LLBRpvWMgrWxxNJ4dNEsbbcXn2sFZKD7ydm8DLYGHbfneLI/zRRW7XTdpIMbVqfNMmfwnyBo5RI2EH+cKVxV4o/2h9n7YqED6Z+8G4aZ5JPDcASn6xLsTo1tSay7mEUIC238cX8dxpj8Ke2JkoyVMB2A6SjOU6uLffPENA3sx0jkru/sUWrFiOFjmMLI8yEknBtm16bhBDUFc5gaLp4iO3wAUCHzpPr8FpMXJx7dUCENvzO5EUNSHjch+tnlKXzaJ+P3TNL0iFClayEuijjdOUysn2U04YD7RzvtHk7L3IlZ9FZgrqErTzZy1SjQMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(7416002)(26005)(6486002)(8936002)(55236004)(5660300002)(478600001)(6506007)(53546011)(186003)(31696002)(6512007)(2616005)(83380400001)(30864003)(6666004)(41300700001)(54906003)(38100700002)(6916009)(316002)(2906002)(31686004)(8676002)(36756003)(86362001)(4326008)(66556008)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0VsRjlSaHVCZkZuZ0c1cVZjN0xZUHhPYmZ6dFJxUWhhNFpaOExGck5JUk9Z?=
 =?utf-8?B?SFc1ZXlPckhSZnRzMWtsZWZnRTN4b3Y5QklqcXlxWWF3V05YSlFjMHlUQUh5?=
 =?utf-8?B?Uy8wa0poTW0yY0g0alpZeDk3NWRYeUlkNW5rZDk0KzhUU3pGQjJ1RUNKUW93?=
 =?utf-8?B?WVhEOXdYbWRwWXJrZkRBNFgycTB4cDNiMHZrWVpBeFRxY3E1YlNpK3Jlc2Z0?=
 =?utf-8?B?Z2dPOGdYYlB3S0t3TmdUWURyTEJqQU8xbWpSNXNPbDNnZEExakIveWsrRkFO?=
 =?utf-8?B?WGlnc1QvQ0xNcDlYa2hFY2NPMDZIWTVOZVJaL1NBUWoxTktZMnJyY1BDV3Vq?=
 =?utf-8?B?ZmlSTHNNWklxR2w1UmVZK0QxZDFJR0g3UlE3bDNpbnlIdzBCRGRlZmhoRFJa?=
 =?utf-8?B?Wnp1WU1RS1kzYXRHVUNRYnNZZ0hHNDBodDh4SmQ0bFJ3TDlLMDZvazBFYmdi?=
 =?utf-8?B?WWVQOU9LZk5RVGFZQ2RNbithazBIQXB1NEQ1TlczR0tLcDYxSXlSTDBYVG1r?=
 =?utf-8?B?NUlYODVXbk5VdlphNmN2UVJ1dnB0R1M1K2kvZzBSRWlwQ1pXL0U1azNVR0lS?=
 =?utf-8?B?NENFeEFzb0tFdklNaldBcjlHOXYrOVZVV3F4NUVTdi9hRnRsNmMwenkxTE91?=
 =?utf-8?B?aWQ3Ukc5ZGZ4dHlNYnEzQWR1Q3FmTkdteGljR0x6TmNFY1ArVTBoWk0yRlo2?=
 =?utf-8?B?cDR0MFBHL08zUDNRcTkySWFKYXptNE1YaVZCbm56OUlNS3psT2UzaElWQ0ZR?=
 =?utf-8?B?WDJ3Y1NxOTlJMGsxcHpSckR0RWFsQTlBMUhBK0xLSkluS0RDMUZUSk5WWUIx?=
 =?utf-8?B?a3RFdHlpYVJ6VzFTTFFzZGk5VkRUU2QvSE9ZMTNNTk5FWTlpOUw2S00xcG1R?=
 =?utf-8?B?a1h0SE1rYnRPT0pvdGVXL0tPMXZnNk40SU9WNmt4Q2l6Y1V5eG4vRjFXc3Zn?=
 =?utf-8?B?OUFUS1ZoK2h1K01zdkgvOVpMM0Q5dWtRbVBtZkxlRHg4NHdkSUdQb0w1R3Ny?=
 =?utf-8?B?MnNJMGpBT3l3SERXWU96L1B3YlFoZFVOcE5NbzdmTFpKMTVBMnB1aW43RHpa?=
 =?utf-8?B?NzllMUJXUWptZ2p2U04rVHBHSEp4YkcxVmF1N2hSVU1tQTZxMTRjSkJrbCs4?=
 =?utf-8?B?MlRHVWg4N2JuMEtOajN1NHlEYVd0em9qQlpTV1FZV1M4Lzliend6VGlzWXJQ?=
 =?utf-8?B?MW10VHFyazV2OUJTaU5QVmNnQkhMckdiUklscGdLdkRBb2VOazNGMWszM0pl?=
 =?utf-8?B?eE5KUTA0eGFIMHRPbDkwTU05cmpiZC96TGMyWlN5bFE2L1FHTEJzVVhrb2Vk?=
 =?utf-8?B?b3krWUFZdjd5STJrYW1WQ0VZRHdsN29XSjM1QVM5VmdJamQvd2hmNWcvVGVY?=
 =?utf-8?B?L09raERZSituNVdaa1Z1Y3cyaWd2K2JWUHo3V2QyZHNrOWJLK1RPVnNVdkNP?=
 =?utf-8?B?dFZEYjkxUlRCbjVHOWdtYVdOdHZFdllZY0dOei9GVmZUL1BkQ2tvSldNMEhi?=
 =?utf-8?B?UXdFbk9CN2cvSjdtdjcyUXZ2ZXJjb1ZrZTZXTjRQSFRSbUFJbCtUWXVzSnJY?=
 =?utf-8?B?Y1VaK01XOFd3aVdaR1F2QmlFZ1h2L3Y0UGROUmpyZlhyWDhzRWZZVC9HVnQy?=
 =?utf-8?B?N3lScWpVVmdrVUtwdFVhUy9ORnFrN3JsZ3V5czgwN0k2UXJkWk41eER2MUUx?=
 =?utf-8?B?L29QZ0FXcTByaWpoTzNlWFdzTmxBakF1NlB2OWlieVJackQ1MXN4bHorSElF?=
 =?utf-8?B?ZE5vM0ZoZGFGSlJtNHJjTHQ3MzltUG9QUUNzZEFKc3cySS9PMEhoNnQxOUhk?=
 =?utf-8?B?RHhqM1Q1VS9OakdLbzM5azdvR0ExemRqbTM3V01uRG1Gcm9yRitwcmRCNEs3?=
 =?utf-8?B?YnhBUHNEQjJtS1o0Sm0vd2h5WFdtYXhpNVRQRzZyY0pHbEoyZjNQenluM3NL?=
 =?utf-8?B?a1VSMFRXMHNCYXYvNjdOem1wRlR6N3lBQkV2bmdtWWpUTi9vN01uTFFIMWx3?=
 =?utf-8?B?TGpaa2ppRFpHS3prTzZ5T0FBeFRtNktsY3kxTkpxTVFkRWlPSlNTNnZkTzdw?=
 =?utf-8?B?UmZHOVQ1VlBLKzJGc2tUWVNQWFlyRXYweHNnU3pBSjRNZVBpb1lxRjJ2bEp2?=
 =?utf-8?Q?wWPLgebR3YDWHhDhhkEMqEe/4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee26daf6-1db2-41db-49bf-08da6e4baf24
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 14:40:57.2588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cyLj77vpULeADYLLdajEHRQDulePgziSKoXePjvu0UUV0b8ic6Ft+PkMZ9f+18rlaDy3yxHRFjCoSwfHTpFkfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2536
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/22/2022 4:04 AM, Alex Williamson wrote:
> On Tue, 19 Jul 2022 17:45:19 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> This patch adds the following new device features for the low
>> power entry and exit in the header file. The implementation for the
>> same will be added in the subsequent patches.
>>
>> - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
>> - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
>> - VFIO_DEVICE_FEATURE_LOW_POWER_EXIT
>>
>> With the standard registers, all power states cannot be achieved. The
> 
> We're talking about standard PCI PM registers here, let's make that
> clear since we're adding a device agnostic interface here.
> 
>> platform-based power management needs to be involved to go into the
>> lowest power state. For doing low power entry and exit with
>> platform-based power management, these device features can be used.
>>
>> The entry device feature has two variants. These two variants are mainly
>> to support the different behaviour for the low power entry.
>> If there is any access for the VFIO device on the host side, then the
>> device will be moved out of the low power state without the user's
>> guest driver involvement. Some devices (for example NVIDIA VGA or
>> 3D controller) require the user's guest driver involvement for
>> each low-power entry. In the first variant, the host can move the
>> device into low power without any guest driver involvement while
> 
> Perhaps, "In the first variant, the host can return the device to low
> power automatically.  The device will continue to attempt to reach low
> power until the low power exit feature is called."
> 
>> in the second variant, the host will send a notification to the user
>> through eventfd and then the users guest driver needs to move
>> the device into low power.
> 
> "In the second variant, if the device exits low power due to an access,
> the host kernel will signal the user via the provided eventfd and will
> not return the device to low power without a subsequent call to one of
> the low power entry features.  A call to the low power exit feature is
> optional if the user provided eventfd is signaled."
>  
>> These device features only support VFIO_DEVICE_FEATURE_SET operation.
> 
> And PROBE.
> 

 Thanks Alex.
 I will make the above changes in the commit message.

>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 55 insertions(+)
>>
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 733a1cddde30..08fd3482d22b 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
>>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>>  };
>>  
>> +/*
>> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
>> + * with the platform-based power management.  This low power state will be
> 
> This is really "allow the device to be moved into a low power state"
> rather than actually "move the device into" such a state though, right?
> 
 
 Yes. It will just allow the device to be moved into a low power state.
 I have addressed all your suggestions in the uAPI description and
 added the updated description in the last.

 Can you please check that once and check if it looks okay.
 
>> + * internal to the VFIO driver and the user will not come to know which power
>> + * state is chosen.  If any device access happens (either from the host or
>> + * the guest) when the device is in the low power state, then the host will
>> + * move the device out of the low power state first.  Once the access has been
>> + * finished, then the host will move the device into the low power state again.
>> + * If the user wants that the device should not go into the low power state
>> + * again in this case, then the user should use the
>> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature for the
> 
> This should probably just read "For single shot low power support with
> wake-up notification, see
> VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below."
> 
>> + * low power entry.  The mmap'ed region access is not allowed till the low power
>> + * exit happens through VFIO_DEVICE_FEATURE_LOW_POWER_EXIT and will
>> + * generate the access fault.
>> + */
>> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
> 
> Note that Yishai's DMA logging set is competing for the same feature
> entries.  We'll need to coordinate.
> 

 Since this is last week of rc, so will it possible to consider the updated
 patches for next kernel (I can try to send them after complete testing the
 by the end of this week). Otherwise, I can wait for next kernel and then
 I can rebase my patches.

>> +
>> +/*
>> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
>> + * with the platform-based power management and provide support for the wake-up
>> + * notifications through eventfd.  This low power state will be internal to the
>> + * VFIO driver and the user will not come to know which power state is chosen.
>> + * If any device access happens (either from the host or the guest) when the
>> + * device is in the low power state, then the host will move the device out of
>> + * the low power state first and a notification will be sent to the guest
>> + * through eventfd.  Once the access is finished, the host will not move back
>> + * the device into the low power state.  The guest should move the device into
>> + * the low power state again upon receiving the wakeup notification.  The
>> + * notification will be generated only if the device physically went into the
>> + * low power state.  If the low power entry has been disabled from the host
>> + * side, then the device will not go into the low power state even after
>> + * calling this device feature and then the device access does not require
>> + * wake-up.  The mmap'ed region access is not allowed till the low power exit
>> + * happens.  The low power exit can happen either through
>> + * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT or through any other access (where the
>> + * wake-up notification has been generated).
> 
> Seems this could leverage a lot more from the previous, simply stating
> that this has the same behavior as VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
> with the exception that the user provides an eventfd for notification
> when the device resumes from low power and will not try to re-enter a
> low power state without a subsequent user call to one of the low power
> entry feature ioctls.  It might also be worth covering the fact that
> device accesses by the user, including region and ioctl access, will
> also trigger the eventfd if that access triggers a resume.
> 
> As I'm thinking about this, that latter clause is somewhat subtle.
> AIUI a user can call the low power entry with wakeup feature and
> proceed to do various ioctl and region (not mmap) accesses that could
> perpetually keep the device awake, or there may be dependent devices
> such that the device may never go to low power.  It needs to be very
> clear that only if the wakeup eventfd has the device entered into and
> exited a low power state making the low power exit ioctl optional.
> 

 Yes. In my updated description, I have added more details.
 Can you please check if that helps.

>> + */
>> +struct vfio_device_low_power_entry_with_wakeup {
>> +	__s32 wakeup_eventfd;
>> +	__u32 reserved;
>> +};
>> +
>> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
>> +
>> +/*
>> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device out of the low power
>> + * state.
> 
> Any ioctl effectively does that, the key here is that the low power
> state may not be re-entered after this ioctl.
> 
>>  This device feature should be called only if the user has previously
>> + * put the device into the low power state either with
>> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
>> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature.  If the
> 
> Doesn't really seem worth mentioning, we need to protect against misuse
> regardless.
> 
>> + * device is not in the low power state currently, this device feature will
>> + * return early with the success status.
> 
> This is an implementation detail, it doesn't need to be part of the
> uAPI.  Thanks,
> 
> Alex
> 
>> + */
>> +#define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5
>> +
>>  /* -------- API for Type1 VFIO IOMMU -------- */
>>  
>>  /**
> 

 /*
  * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
  * state with the platform-based power management.  This low power state will
  * be internal to the VFIO driver and the user will not come to know which
  * power state is chosen.  If any device access happens (either from the host
  * or the guest) when the device is in the low power state, then the host will
  * move the device out of the low power state first.  Once the access has been
  * finished, then the host will move the device into the low power state
  * again.  For single shot low power support with wake-up notification, see
  * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  The mmap'ed region
  * access is not allowed till the low power exit happens through
  * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT and will generate the access fault.
  */
 #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3

 /*
  * This device feature has the same behavior as
  * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
  * provides an eventfd for wake-up notification.  When the device moves out of
  * the low power state for the wake-up, the host will not try to re-enter a
  * low power state without a subsequent user call to one of the low power
  * entry device feature IOCTLs.  The low power exit can happen either through
  * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT or through any other access (where the
  * wake-up notification has been generated).
  *
  * The notification through eventfd will be generated only if the device has
  * gone into the low power state after calling this device feature IOCTL.
  * There are various cases where the device will not go into the low power
  * state after calling this device feature IOCTL (for example, the low power
  * entry has been disabled from the host side, the user keeps the device busy
  * after calling this device feature IOCTL, there are dependent devices which
  * block the device low power entry, etc.) and in such cases, the device access
  * does not require wake-up.  Also, the low power exit through
  * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT is mandatory for the cases where the
  * wake-up notification has not been generated.
  */
 struct vfio_device_low_power_entry_with_wakeup {
	 __s32 wakeup_eventfd;
	 __u32 reserved;
 };

 #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4

 /*
  * Upon VFIO_DEVICE_FEATURE_SET, prevent the VFIO device low power state entry
  * which has been previously allowed with VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
  * or VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.
  */
 #define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5

 Thanks,
 Abhishek
