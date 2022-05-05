Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2D251BC56
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 11:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349066AbiEEJoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 05:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353961AbiEEJom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 05:44:42 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6344B43F;
        Thu,  5 May 2022 02:40:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIMzqSnhA2vjBnfSHGC1RYGVUyQoWLcBw+7H5bzQmJSwNOfBMtfUOutxWnEve5lT5iP9yJnY3Cl17F16QmZxWpvrqvUJyTRVrkqVB991647Yiko2yn89l+dOeoDIDsTfBi6QWibEyMaEYzdiQJgFpIgpsrZKTMHSCz47miArwgE7vmMrVYRWWu/lTwx9yH+4GhF6Rbto4I1+RNMsFT/W4oac5Hiedr7++6tRuP/V1ywnkXjPv4/Pbge6kN+g3U5nLfuXcRl/kfup1lGtBq5KS/7ZH5gRXjqXej2yPpBxvt5e4xPcs7pRXaIECDK2Rm6RYBu5lIY7YHyaoetkRsi0GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJ/IJFAlezuSlLHWfmcbwRrwRnjuYyAwEogLIahdgGs=;
 b=Q8NFjVp+jsLsvXKRh9Qs5GbGQ0Tf0VxJUGMTPBvY3Bq2K475U7A+xscb79Nx8KvXyYfQLVSt8XFH1SrlaffFfMM/NTJnV+m1c7/3XDiLIDm08adQFLoxX9uNSOdziAqq/zacYpliD393Fv3/vpP1rcOZ08dYUMWypae1rSxAZQhvcG/hyHxNCT9pxhhZoLxRfmrejYidhcE1p2C/YaFkHUBgCSaeJKXLq7WMBc0xdgCtM5DQ9VrWZ94E7IlYK9SXPvwgu5CwLPShQeJFmplqRwFAZjb3Ieu9ql9rUESBsJ/Ph6193rqbXdVBzJ/G/IklR1u01nE98xQqPFG36jLz1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJ/IJFAlezuSlLHWfmcbwRrwRnjuYyAwEogLIahdgGs=;
 b=dbdXeAAjnwmXF9Yqs1DSDw7PKG5nEadrvpnz05pP+AfbRR5e0cDRvufuxNXTBhSA2t4jKxEbwhGOaZMWNz90ZSGBVjNwpJ8aAmD1TeJRTCxxqSL7ywHDvlCeXe1GZKkVflgvoJZSaLCmiNJC65MzCfk1p11ZL5Yh1mPp697VbnogqBUCm1jSkJilDk2FJ0czcMFUa3h+9v/sKVI3BDy6ReOMOz0FPwee7A+jSlJly6SSAAhkTZgvBnHVZ4+JyIGlvhmrFC3KPhKKO3KFBEOltHGKZG7d/JVT+2nudfs0x55lq+0PYDcUdyNQ1YiN120Cy12OYWARaMRsOnYsvrL10w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by MWHPR12MB1245.namprd12.prod.outlook.com (2603:10b6:300:13::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 5 May
 2022 09:40:56 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d%6]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 09:40:56 +0000
Message-ID: <0ba3d469-58af-64d3-514c-6d33c483f8fb@nvidia.com>
Date:   Thu, 5 May 2022 15:10:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 6/8] vfio: Invoke runtime PM API for IOCTL request
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
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-7-abhsahu@nvidia.com>
 <20220504134257.1ecb245b.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220504134257.1ecb245b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::13) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 419c216e-f2c9-4b8c-e84d-08da2e7b5a84
X-MS-TrafficTypeDiagnostic: MWHPR12MB1245:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB124519D1C4A90082E271853BCCC29@MWHPR12MB1245.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7OojXz6SIU/0jJ9Vw43tiZDiVXyE2wJrmrys0dMTZ26sMRYkwBfrigVrXkr0bQ4xIGqmBxhxbc4UhFTG2G/vAf+S94tr+vfXa9sQXGYfxvle6kirDko+m6O4m0qFiUB+I2kp/ufkmj+cKCvSFkmxK3b8qmE0Dvq3vVO93viAuV+nDkhqoi3T4UCRtRwln6SaAEUK8d0C7uo72Svp2qyvUjDN1/xFOX5N5CveuuIubeMg+Q0Eejm1AC8Diylg050fk9znvsJmN7Wu+P6kUszBNsT3X4W14y1EkDW9dUS81hfLFs6cqFEDs+ZM/ncJGHBSvlc8Ai/9Okz9Zq2Kr8GNPzZdke4lAOpN5L/y/esPWTCmQ3lmF4ow+T3pCoWAyA4jI+vLUPuMWZ7fxbDqbBi9DRG41QGB4H5yX0bcZwwbr3wIYaQqg/Twv8K6FbvAWgr8mP/MQtOMGF5ek+8buXvVVblvjDLDz7Nm1WrjRVjBhqqgwXh4Gn9HzWwQRk6jcxvHH+Uu4YrKZbOxJK2oUC2wEdFN0KLkV9RW86GUmXDuS1Eq7amwxoV1nfkdnuZANXz8hZ84al6R3b10cPonI6wLE1AYQAmjw3UzicFOjl35pzMCoFMRPhfpY4PUYoxWEqbwNtApp/EnzR4Yo453LSQqkwzaWCe/lY72zq34/FTfyE7QLR32znOyNrYM4Nkw3hJU8IQHdKsz6ekioDwvbdhFTs5LNrfU/mzRlVRQ8I8phdRYDAw5o1Qsmqj8ajj1VUNV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(4326008)(8676002)(2906002)(36756003)(31686004)(86362001)(66556008)(66946007)(66476007)(6666004)(26005)(316002)(5660300002)(7416002)(8936002)(38100700002)(508600001)(2616005)(54906003)(6916009)(83380400001)(186003)(6506007)(6512007)(6486002)(55236004)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDhNV1VEbzVVOEsvS1hZcm1ucXUxbVIyTnFsRStGNGlRUHJJTUk0Yi9OdXVB?=
 =?utf-8?B?ZTMrODBaYXovdXdXUU43M2JMdjU4YTlvMVNid2pGcUY4WXBhRysxMWhodWJi?=
 =?utf-8?B?aVRRM1BnYWNCTGE3MUk3dVExdCtBcGN2VFhuZyt1QTZ1S0h4ZnpkRmtKcDNX?=
 =?utf-8?B?VjZqaGkrVlJtVDNUUGJBQjBrNHpiUGhZQlJoZjM1M2NpQkRqN01OL21lcTJi?=
 =?utf-8?B?U3dVV3R1ODdBUk5CUXVsT2Qza3BZY3ArNGxJT0Z6bXdDMzhZL1YycjNNRVFq?=
 =?utf-8?B?ZDRMU2gvczMvMGIvWUZCaW9velkraXJiUVo1VWh0Ykd0c3lBemdOWXZtanpk?=
 =?utf-8?B?SHU1NktpclVjd284TU9lTzUwRE41V3VDSFBkdWVkUS8xN0p3WlBSRE8vZHFp?=
 =?utf-8?B?V2VrKzZON2Y2TlZMeXc1SDVNWDF5VExPbVVDODJyVnE4cXZBV1JIR054UXVC?=
 =?utf-8?B?QmdCdG1WelVna0k1MEdacm5QTnl5eStKQmdxL3FJZmplaTFvUmRaUzBZellN?=
 =?utf-8?B?d3hwTC9JLzFPQ1lRWjhaaG05aDNKczB6SHNSdmYvcVlNQ0orekQ4clVJRys1?=
 =?utf-8?B?NXdLQjZ2TTEvVGRpY05wbmd0VGNDWlNqUzI0dHpLZ3hZVUw4ZXFta0ZTNlNj?=
 =?utf-8?B?aWJPc0ZvQlhrRXRDUGUwbzRTZGRDWVFzZmVCNmNDMUc2aSs0RXJuYkZQR0Q1?=
 =?utf-8?B?ZCtZVlpVMlpCTTZEeVcwa3ZXVzNwMXFwMmJwSWgwRjNSMVQrQlFCSnh4aC9N?=
 =?utf-8?B?YVlGR3lXSXJKZ0hleExlYzVodk9JbXl5YUp6elA3SXE1dmJTaGc0UFBoL0w0?=
 =?utf-8?B?U01WVVk0YWpCelJRVnRJMXVZeUszNFJnTERMeFJ6akJJdXJxbk5tbWVxYUdN?=
 =?utf-8?B?bTNaQkxFeTFJelM0RDVXZUE0a3lSUzVDdW9MY1BmT0QvZHFHMHYzUlA0dWo1?=
 =?utf-8?B?NGZ2RFZpNXFZYXpKaTc4eHNPb1FiaFVvNTlmL20rUWgrOHNmTkRDYlczbUxa?=
 =?utf-8?B?ZStYOVFLWjJyRndKTWE3bXpFM3ZNaHNjeTBxd3FQTHZXMC9GeTJXVmorcG0x?=
 =?utf-8?B?T1RUUzJFWUZJOXpFRDQyWDRGSkorbjZ3MUdZQk9ycXFoM1lVbXdsUExLTzRm?=
 =?utf-8?B?UDg5WkYwSmNKNUxSMjFtUXI0K242eGp3ZEdyeDBIamVqcUpkR2dpSGpDeEdu?=
 =?utf-8?B?bmpDR0hLeTBoQnZjc1JzVStKTXY5ZkQ2ZE9pUlR1bE45L285SG0zMjRHSW5Q?=
 =?utf-8?B?Q1VxS0JNTG16YW96c0ltWS9wSGU5dVJBRkw5NnhWc2R0N0NPSGlGbFlCa2FY?=
 =?utf-8?B?aUp6TjZ0a2FqT2hXVEVwZU45WnhXcXVMSTJYOHg3R1Z3aEN3ampCME8wbXFJ?=
 =?utf-8?B?MkVjV29nb2g5bkVINkUvSWNYSWN1K3Zzc0RtS2tWQ25EYkUyMUYwS1Q1M2dz?=
 =?utf-8?B?REhxQ002Q0JzUVVWRmxpcEg1Y2RCMDBCUXBTbDduWFpUU25hZGlkMUtUUys4?=
 =?utf-8?B?RkltTThodkx2YWNGSllqTnY3aTFtYTI5VEJXbDZLcWlnRHg3M203aU5OakE5?=
 =?utf-8?B?TFdZMVFaTmZoMm41WkR0MTNZZitLZzhwcE9qaUFHeFp3QlRFZmtHSGY2WStp?=
 =?utf-8?B?TDhhK1hQUElaeFBoT01YMjFhQkQ1ZXZremNrOFBTSGZnc2pCNCtBYzNsd1FJ?=
 =?utf-8?B?MU9tSkJwRW5JOTBZZ1BmTVNSYjFRdVBOSXVPWkdMTzRPN000YUZIWXFUeFlp?=
 =?utf-8?B?MWYvSlBTZ3RIUGxjRFlqMGc1SmhjVC9pMzVtb1o0TmM1VmUrMjJrRHY5WG54?=
 =?utf-8?B?RTZQTjgwN204TkNwN3d1djBZSFBVOVNDNDdPWVFvdFhRejBpbmYzb3hTT2Zk?=
 =?utf-8?B?MmNWdnNyNldmWXNjdHQ4amg1Q2Y3YTBIZnFTNjhwaGZPRmlnb1lNbnVsVVdu?=
 =?utf-8?B?ekIvMk8vSTdrN2RuaWNqM1VyY2NWbGNYMFJ3cE1YL1djQWhNQkJ2SjRSdGVm?=
 =?utf-8?B?WjduUHJuOXFLNFB6b081SHRibTFCOXRsVnc5NE40dW8vbkRWdHlSTnRRcnY5?=
 =?utf-8?B?UnNjeDJ1SVdCeEN6dG02RUZOdWRqNXpwMk9wazVvNmdXU2t5WTZGYm1tMGNG?=
 =?utf-8?B?ckVPS0w3a1lFUERaSkNwc0hQNVdvODh4OFBtOVNyOXpzaGtZL3NGUmVUSHZv?=
 =?utf-8?B?bDlGeVlWTjBvSHRwWG9YWDhzTFdrTCtzMFVBeUpoczRmaXhFVU9tTFVybENv?=
 =?utf-8?B?QUhCL2xPWXRSSkw1akRMRndqYkdoM0V0L0FEeUJOeVMrV0FCUDlsSzd6U1BC?=
 =?utf-8?B?ak1GU2oyK29LbVUyL2RZOUh4Y1J0QTBFN1FXbkk0UGxKN1Awbm9iZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 419c216e-f2c9-4b8c-e84d-08da2e7b5a84
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 09:40:56.4611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MNsCFocP3oSm8wNRr1qP9Fgf4afmMfSRoJQkdm37VMmhGmDP2S7k7suXZRZhr5Fm5bnH9c2Rw3X6sGKNoEJVOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1245
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

On 5/5/2022 1:12 AM, Alex Williamson wrote:
> On Mon, 25 Apr 2022 14:56:13 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> The vfio/pci driver will have runtime power management support where the
>> user can put the device low power state and then PCI devices can go into
>> the D3cold state. If the device is in low power state and user issues any
>> IOCTL, then the device should be moved out of low power state first. Once
>> the IOCTL is serviced, then it can go into low power state again. The
>> runtime PM framework manages this with help of usage count. One option
>> was to add the runtime PM related API's inside vfio/pci driver but some
>> IOCTL (like VFIO_DEVICE_FEATURE) can follow a different path and more
>> IOCTL can be added in the future. Also, the runtime PM will be
>> added for vfio/pci based drivers variant currently but the other vfio
>> based drivers can use the same in the future. So, this patch adds the
>> runtime calls runtime related API in the top level IOCTL function itself.
>>
>> For the vfio drivers which do not have runtime power management support
>> currently, the runtime PM API's won't be invoked. Only for vfio/pci
>> based drivers currently, the runtime PM API's will be invoked to increment
>> and decrement the usage count. Taking this usage count incremented while
>> servicing IOCTL will make sure that user won't put the device into low
>> power state when any other IOCTL is being serviced in parallel.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/vfio.c | 44 +++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 41 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index a4555014bd1e..4e65a127744e 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -32,6 +32,7 @@
>>  #include <linux/vfio.h>
>>  #include <linux/wait.h>
>>  #include <linux/sched/signal.h>
>> +#include <linux/pm_runtime.h>
>>  #include "vfio.h"
>>  
>>  #define DRIVER_VERSION	"0.3"
>> @@ -1536,6 +1537,30 @@ static const struct file_operations vfio_group_fops = {
>>  	.release	= vfio_group_fops_release,
>>  };
>>  
>> +/*
>> + * Wrapper around pm_runtime_resume_and_get().
>> + * Return 0, if driver power management callbacks are not present i.e. the driver is not
> 
> Mind the gratuitous long comment line here.
> 
 
 Thanks Alex.
 
 That was a miss. I will fix this.
 
>> + * using runtime power management.
>> + * Return 1 upon success, otherwise -errno
> 
> Changing semantics vs the thing we're wrapping, why not provide a
> wrapper for the `put` as well to avoid?  The only cases where we return
> zero are just as easy to detect on the other side.
> 

 Yes. Using wrapper function for put is better option.
 I will make the changes.

>> + */
>> +static inline int vfio_device_pm_runtime_get(struct device *dev)
> 
> Given some of Jason's recent series, this should probably just accept a
> vfio_device.
> 

 Sorry. I didn't get this part.

 Do I need to change it to

 static inline int vfio_device_pm_runtime_get(struct vfio_device *device)
 {
    struct device *dev = device->dev;
    ...
 }

>> +{
>> +#ifdef CONFIG_PM
>> +	int ret;
>> +
>> +	if (!dev->driver || !dev->driver->pm)
>> +		return 0;
>> +
>> +	ret = pm_runtime_resume_and_get(dev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 1;
>> +#else
>> +	return 0;
>> +#endif
>> +}
>> +
>>  /*
>>   * VFIO Device fd
>>   */
>> @@ -1845,15 +1870,28 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>>  				       unsigned int cmd, unsigned long arg)
>>  {
>>  	struct vfio_device *device = filep->private_data;
>> +	int pm_ret, ret = 0;
>> +
>> +	pm_ret = vfio_device_pm_runtime_get(device->dev);
>> +	if (pm_ret < 0)
>> +		return pm_ret;
> 
> I wonder if we might simply want to mask pm errors behind -EIO, maybe
> with a rate limited dev_info().  My concern would be that we might mask
> errnos that userspace has come to expect for certain ioctls.  Thanks,
> 
> Alex
> 

  I need to do something like following. Correct ?

  ret = vfio_device_pm_runtime_get(device);
  if (ret < 0) {
     dev_info_ratelimited(device->dev, "vfio: runtime resume failed %d\n", ret);
     return -EIO;
  }
  
  Regards,
  Abhishek
 
>>  
>>  	switch (cmd) {
>>  	case VFIO_DEVICE_FEATURE:
>> -		return vfio_ioctl_device_feature(device, (void __user *)arg);
>> +		ret = vfio_ioctl_device_feature(device, (void __user *)arg);
>> +		break;
>>  	default:
>>  		if (unlikely(!device->ops->ioctl))
>> -			return -EINVAL;
>> -		return device->ops->ioctl(device, cmd, arg);
>> +			ret = -EINVAL;
>> +		else
>> +			ret = device->ops->ioctl(device, cmd, arg);
>> +		break;
>>  	}
>> +
>> +	if (pm_ret)
>> +		pm_runtime_put(device->dev);
>> +
>> +	return ret;
>>  }
>>  
>>  static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
> 

