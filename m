Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FF25973A8
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240557AbiHQQHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240531AbiHQQFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:05:11 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39419C2C9;
        Wed, 17 Aug 2022 09:04:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knjYKgu5mAvDYGmxcQRs6BkALwlUgRBepBpt+wqS8RkhVSGTvJXz6qzmJZy/4Dq5HUrYMid2PxoWvRbv19vHsS2AuPQIyJXy4lH4TvNkOR31NXHgXM6fLiK7Vf3jNDFTCPqYQ23Cztaa+zMQBPV2qTSICQivtmMRiVcb6nEHVv43XrcJ/eI3hi6DueIlfsa/ZLxdZZmDEaRsaGDLKbsMDGhIemt6R+NQO2amscYL0JR1+fhD8uabr4F5d19kr4GjBCRxiPRI5Ys1PJrd8UIIogdwrzQS5o2eQoJacNs6OvD55fCiQVTEDqkkorwB/m3dg48WBWiaOQSRgnYZ+y+09A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KXOD1sbfn2N18p1fW5WOHy5QWLp/1PgQL+ozKR9XdW4=;
 b=law1mKSDkBHRMdJ6FJDEvuisAoweJ42KL3F2G2qT1LiczJ2+3ElfLpmOq9OdWmuByW/IAGgjids0PbbmskZY9uHUUc2VIKke5p8U0vMyIqQ5TxYKWeMT6wtjeTtYMRG1+cDeOfq1uI9srOU1gOxdF7BpJ9jQkMBxzyNB3F5h73xlQGyY5BmUsEJMXufKOZyOBcLqCjHeqxadsQZsxYfdpmvKh88QTlgF6ZKrwKUJxNcySlh64qQV+49gfV+Vw7QQwOOuz3vYVI8NP0lUKjpemQfZHu/eBtR60w3+8RC35OP0OX0VD740V+MkDVhJMMwYXtfApzKR6aaacuaGyFA1Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXOD1sbfn2N18p1fW5WOHy5QWLp/1PgQL+ozKR9XdW4=;
 b=agA2/ynVJa0kghSlNmncLV9xKBydhvLQkdzyXIVl4nXyTrEID8+PKv/bHF92YR/TTD9r+Fjf0IJoNTUVRZRuMyTWVcIWFALtKAuX0By+ODAoTPugOLFkLaDHICMS0qVU/kSnEfER71qEXn/IdcfJcK9RK12TZyYIKA6yJmZ964srwN10KCmCNb9zmn4UJ8t53nTr1+7t28dHvjJUGsxFkOpN9ZpmBFnwdaFKp/DxDo84Lwivmqs1sLda0J2XWdXPDExyuQY8O+2MH9VO0nv/kHwEs/mx2jN3rkq2Pauz678n+HQ9jl/7hop87cTQJf2iSwqUxPqRpbAlxURuuPJHEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BL0PR12MB2403.namprd12.prod.outlook.com (2603:10b6:207:40::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Wed, 17 Aug
 2022 16:04:43 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 16:04:43 +0000
Message-ID: <5363303b-30bb-3c4a-bf42-426dd7f8138d@nvidia.com>
Date:   Wed, 17 Aug 2022 21:34:30 +0530
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
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <Yvzy0VOfKkKod0OV@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR01CA0118.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::36) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d24e28ab-85ff-4dd9-7703-08da806a322f
X-MS-TrafficTypeDiagnostic: BL0PR12MB2403:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vu5W3MMw4MesHF7Jo8wIKtoCivFjBwpp7WZeU7OAh/Y9Q5+0L2hk+cS1SM/n5v6r7I7Ea9tw4r+ZMlCERlXNf5R1CKXyDBUIgCChkbSDQvjKNEINWqjeylDlS5fbpJggHaNS9+Urr2ZdYJRdhdxEwUh+IsQzqUqPN4NRyr3WzZXBQJ6PJf1kTFqf/e95P9qnBy1ifgG+ojHattasIxoH8aqitE80R3zU/DmZa3l5DlWdRg+x5bj3iHHHqbv5LIjSOtCzhfqNTeWxk2OSCyB8zSlaC//gS9qN26wc6IUe1J1o7YVbA/DZHbw6fPQqfilj2Xt1hLZjXawhmtqrJuxFMYeH8n9DP+I9TUfnSshSEIQU0pXBQYlNHZjLaWoIFKRoM58UIvk4D6kgickYfmD7itJKOt9VT3RB94fv3wWKnW0Yjy2wVJctjFMFvPBP+F7hHU+b6T/9aFcIt/QgL2EgBdM5P3eG1sYDvWgYkPTkduKU84vVf8Xss3s4pFxonWH/5Kipd2LbLEwwME7G3ViWztn5le6RO5iRJeV3NBGXrTxdo9BCNtorOa0Du3VTnMS0Em8pYrHw3tSJhPmBEWCeaK/9TA6APw4CA3wqvI162qf3EFKbdZ6IymAYwnhYFY8SIRv6nSIUuWUvRff2mR4OKG/N2d2u621GoxmWWamZHNU/N2+Cqvyx9IrkqvaY5oaMrIZDvF7IikbuZpfCgz4oLnvOViy9a9sqLA78SW7RB4O1O+uMQ/8kziKwdYfQuhxHOoMeOspk0u026+ZeOX8IH/AobDn6r48qZZHDzAQxNgH0Az9ofMNb0EmG97Zy0tY7hob8cqWXqgAa8OrXH36lGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(83380400001)(38100700002)(54906003)(37006003)(7416002)(8936002)(6862004)(66946007)(66556008)(66476007)(4326008)(8676002)(5660300002)(6636002)(316002)(2616005)(186003)(55236004)(53546011)(2906002)(478600001)(6486002)(26005)(6666004)(6512007)(6506007)(41300700001)(31696002)(31686004)(36756003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDcyRHhCUGx4YjZjcVlKdXBKLzRiMm02K09reWVpZkNIV1JjUGpzRnlLRzJI?=
 =?utf-8?B?Q0p3ZFpFeWJsWmMwQUduV1ZWMWZYNkZ0bG50NEV6NnRYb3ZySDNVMCtkTzk5?=
 =?utf-8?B?VFlCSHJKNFNyNC82V2s1aFlXbUtjTFBzMlJyU2pWNGYvWlR0U2FnZmlNbGNl?=
 =?utf-8?B?di96dlkxNzFzSWhRUEtNREVxejJBSUFSS240N0FTa0JlclM2bDZMdjg3THc0?=
 =?utf-8?B?MHlSd0ZTcTAvcU5oQ1ZLNUtNODhpbjZmbmhKby9aaDUva1M3OFZ6WFhUekFH?=
 =?utf-8?B?bFNSUzZXNlVRVFgrZldxZ1dwVk5pS2FsUHMxTElhekpjaytOQm1Jc3pSZFJu?=
 =?utf-8?B?UE5TQ2xGL0ErcWFPSzBJTXNuTjl1ZzgxK25pY3NzZXAyMzBhZitiQmFhYmdR?=
 =?utf-8?B?R05xK3B4b0hJR3hCdGxQa3NqOXNJc0psU1lWenBoZFdwZlV0YkpYR2hxWlM2?=
 =?utf-8?B?ZnFyeUV3bDFGMUhnYTBieVo3bm01ZU1YamtqaEs2SVBuSTF6ckY0M0xiTVpt?=
 =?utf-8?B?bGx0VFhkUlBJUGpQbnBMOGxXT3lOTGZiUWtvMUFjTFJvQ3dDa0w4NFU1TDdV?=
 =?utf-8?B?bkl6TXVkUWdGdFhZdWp2ZFRGZSs5VXY0L3dUM1p3ZjRHMnkvbkw1VFhuZVJT?=
 =?utf-8?B?WUMvQ1lhb2JlNXU1cytZdjBlbGN6dVJ4Yk1Rc09ON0dZNkJ0WjJ2K3lGR0Y1?=
 =?utf-8?B?dURYSStsTDcwSUk4K3N5czA3RExyK0Vid3h5bFdzVEdQbVdQWTRFajhCWjlU?=
 =?utf-8?B?dHFmMks1RjM4OXVXUzRRb2pJOGlidVRsUTlIZUsrd2dyZEZMY1NJbkhYWEov?=
 =?utf-8?B?Sm9mZ2J1eVd3eFdXYWpGQ0M4SkJKNnZ2M0g1dEh3RzFsU0lkN1J6ckJ5dWVk?=
 =?utf-8?B?ZkNFQ0pRSVVCcXk1MmZ1TXF4dzVrM2dnQ2F0aCtIYVF5YVhtRU8vODZZcThm?=
 =?utf-8?B?aDdOZFhhZVM1OVE5ZTRGU0ppZDlZMUs4dER1UnJjaEdIZ1J1d0UrTXRIRU0y?=
 =?utf-8?B?WEhrRXZIcTRsVHR5TnBEZ3RrdFJuSnhLbEFVZ0htOGtJN2dBdTdGQ2ZTdzFx?=
 =?utf-8?B?OGJueFZjMU9XVU1GUVU5ak85a1B3ckF3OWxPMTBHQ3dOa2VnRWNkQkkyazVY?=
 =?utf-8?B?ek5ubVM1cEZkRittK1djOHlYaXkrdkxFSmdacFdtQ2dabHN5RGdwQ0g0SmtK?=
 =?utf-8?B?ZEhjK0c0dVVJN2txOHNBS2VhaWRlQ1JJUEN5TmFxUG5UNzJJc3BhZnp3dHFx?=
 =?utf-8?B?cERxcFQ1NDVWTXJWSStEK1o3UnpiNUNhM3Nnb09ySlRJc25RTUFZZC9vSlVS?=
 =?utf-8?B?SE1WY0tYY2ZXMXJveGtXeCtSZ3BvZzhvSSt4dEZMVDM3cmRKdzNvVittOHFK?=
 =?utf-8?B?RndmcjFiZGY0Y0JjL0g1S2JRMzhKcHFQVVNPbGR6VDAzdWRONmRsOWVwclpR?=
 =?utf-8?B?NXlpY2ZwT0krZ0NabmF6ZXVMbnd6RDhRb1I3cXo1Wi9SR01ONS8zam9sZkNt?=
 =?utf-8?B?ZXdLbjJTZzlFbTh2QTNHWUtISC9xTEFqbTk4V0JmSXl2Q3RDUjBQS0VDeDhS?=
 =?utf-8?B?cHZUK3lwWXMvS2pENTRnWnZzMi93S0RKOGkxWDlESUlUZEhtRy8xT0l6aXBk?=
 =?utf-8?B?M3h2N3BxaXcwbUttZXMxU0hFN2Y0SzBIbXYxWDVVVThNKy9CdlpudHZwYWY3?=
 =?utf-8?B?aDcrSTVWTUlhNzJGRnFPcGRtRHJIMTZwRWkrWFREV0p5dUVwbUZ4bGI0d2Rk?=
 =?utf-8?B?NnVlU3hpTEY5akhxWHpXN21pWnJVUXVBUGd0a0JPcVU3WHZyL2pheDlIekM5?=
 =?utf-8?B?MTlhUUdJZTVaNDVZU0J2NXhBbW1RQnBNbGdkQUVPRDQybVVIRGYvNkk4NG9Z?=
 =?utf-8?B?YWdoSXJXYmVUY1VzcGhMQ1czTjNhcDlQNkJoTGl1Yi91SGhkc0h0cTg2WEll?=
 =?utf-8?B?ZHo5dHdrVTdka040V0J3T1NKc05WZnpRVjZnOE53TllXMGxXcWF6WHcycnZj?=
 =?utf-8?B?Ykc5YzNqTk1QaCswK0sxZTRaWVJ1NURwQ0FodlhLT1FoSEIwRFdXSXhPeTFF?=
 =?utf-8?B?SEtLSmZnb284dmlQbXo2NHkxdUNua1lMM2toVWhiNFdHeFZka05JOG1SNkNO?=
 =?utf-8?Q?2dewS8d80/pk6nqlMa7xKv7GR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d24e28ab-85ff-4dd9-7703-08da806a322f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:04:42.6499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cF9osWuhLQoWRFMeXoTw7lKxIyi+L76MpumEs2DIicZGegiVcddXVm3MvLWoolhvnpbfiup+v7sRbm89poLGag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2403
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

On 8/17/2022 7:23 PM, Jason Gunthorpe wrote:
> On Wed, Aug 17, 2022 at 10:43:23AM +0530, Abhishek Sahu wrote:
> 
>> +static int
>> +vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
>> +				   void __user *arg, size_t argsz)
> 
> This should be
>   struct vfio_device_low_power_entry_with_wakeup __user *arg
> 

 Thanks Jason.

 I can update this.

 But if we look the existing code, for example
 (vfio_ioctl_device_feature_mig_device_state()), then there it still uses
 'void __user *arg' only. Is this a new guideline which we need to take
 care ?
 
>> @@ -1336,6 +1389,9 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
>>  	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
>>  		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
>> +	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP:
>> +		return vfio_pci_core_pm_entry_with_wakeup(device, flags,
>> +							  arg, argsz);
>>  	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
>>  		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
> 
> Best to keep these ioctls sorted
> 
> Jason

 Do we need to keep the IOCTL name alphabetically sorted in the case list.
 Currently, I have added in the order of IOCTL numbers.

 Regards,
 Abhishek
