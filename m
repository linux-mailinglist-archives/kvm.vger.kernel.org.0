Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4EA581FD4
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 08:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiG0GHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 02:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiG0GHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 02:07:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4853F33F;
        Tue, 26 Jul 2022 23:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYNZ9SEg9w16fk5OfDVgEkAV3ayJPsQRok3ffKZgE5n4ZfIAkUIfUvSAI913FCRGBAbcu2tWuzKrRJoo3eegrNUCK1+qL+T4P2Nf+ouA71i3bQUP00xH1iY2v8LtD+AGcy2shp431yo/FKpjpT0de1MgK3WNODhY3SUmAu9NKgQsf8sqOQCrdez2NxcP1D32/i2NoXdbx2ohUMf9ehHDvjAT/taCl+6wJOCqDbp5if/8/zD+R6ZwKqongQzWmjLIvPVdm0JULRjlqLJe9MmUehDXj40L1wf8Xm5EVa9gc3NtJLdn11uUWnjDOztdGzcE0g5+wpw/Z19kq/nuzh+yLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFoikz9/mJflHf6WY1RwS6gZ9drESLybzoNlXZNcUZw=;
 b=PLZfLYKWV3qObKuz7jh6v6igw3lB4hhTYZSyS7Trqahbsp7IonUmXr6jljjVyrwrsC881rtSqO7ia++CRY6B+60TMHJkfoM3WUPFj6SH7f6DjmcTJyOs/lElXkBIoi6WitRlhIbYovfECUL6W0k/Jgj1HZhYOZQpFhDmhXAER69oPD8y+TNmuhx9vkYF/LdsiWI9SvcPG4VUYL60+His72Gfcoc6EQ1HsI+xpqOo2afuhIkw8LDN9nYKZ64wfb2HZg08jP3mjixmeFHcOJOzS9F54oZhxAI5r+wO8HFH95d/EW8HcyoGcz9z55eWMhBs5V88O273FqjeOahrg4mQuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFoikz9/mJflHf6WY1RwS6gZ9drESLybzoNlXZNcUZw=;
 b=MzkCsLsPrJPswRKxL/XXara20Ca1Gv1pxuNrVOzZ+sB4+orrhPkl9eVvAbYcAD62HYpkguYLYDQLHBAReic+YeVwXzn5R2zqRvFmPssTsLL879a4iPejC/xYYfx715toxV9BcoX2QmeYxKfUjmpybdTrOsFZL6KBYYgnp05fAQBx1jGOm91bvVgsvw82nCQgnpl0ie+i+6J6xyEy6FwyIYNzmM5bEZtrmubrkGjIvGJvlN6oW3fRyBD7BTGbGBkZY6CCw9NeaxaGkfFT4dc6mezXb6nquHfrCBbFqZm+CU/Q9I3kcreM9DsWuBAr5x/riOOLl7ZI8cTdGetAakFO5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by SN6PR12MB2622.namprd12.prod.outlook.com (2603:10b6:805:72::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 27 Jul
 2022 06:07:15 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:07:15 +0000
Message-ID: <f903e2b9-f85b-a4c8-4706-f463919723a3@nvidia.com>
Date:   Wed, 27 Jul 2022 11:37:02 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
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
References: <20220719121523.21396-1-abhsahu@nvidia.com>
 <20220719121523.21396-2-abhsahu@nvidia.com>
 <20220721163445.49d15daf.alex.williamson@redhat.com>
 <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
 <20220725160928.43a17560.alex.williamson@redhat.com>
 <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
 <20220726172356.GH4438@nvidia.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220726172356.GH4438@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0164.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::34) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6def9d8c-7baf-4bef-9a88-08da6f9640be
X-MS-TrafficTypeDiagnostic: SN6PR12MB2622:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lrVxXnzA/oTBVDfAVTd5Hxvk+E4N7gupK9UWXM+zccrQOOXYZMielijZBCecGc6twindbvqm+b5AcVX7IWIo3EqRJ152nbNwN/ncyyscsAmznYfSWn9O46e2/PlGk2F26qkLJOhn1JujZaUZWB4voo6wl11KQzc02Jb3a10IEcF3zD6HnPVvptiEucHk9jFeC5fCa6H/U6DSEiV+PW7w7HDPMr/YepgO7l01xsaLjlRWnOYe/LLvMsnuwTFOM9fYD6iRYj8/T3595+srZkC/cZmz3zCP+1DsBV9bB/4zUoznYJvYVeD36tqchWBBTfSZSnVzY3eed5nTXB0eBNrSK8pUWXIw6v+cp3xxy0gUvPAhwYDHtux1c93Hlx8VUYSLKLlw6jpWWlK8nxp9bw+RqqlOcqfRGA2AotVbeybjIPEZ1sUI1AW1mMWQpux9dzI108eir+UHWDA128sZg6v3umUYCMrmeN4T4vOJheCjhkWDwJFQUO1CEtLvoEPPpd0vIX6TmHpc2/b0J+1+MOYYMr3T4QtvYV/D4uABdlL9IMhrP1spDZB+eRCJSnsmNdZIeZB+BdzZzEHEhamKEW1Apx6BFr6BBDovutAU2x5y994iNkw9WNGkgrVK+oA0WM9EowV+S63Z7j1Q1m8PezUWcL/FqYbH64IyL8dSeKfj5EaCEm21/TiNY73JJmualgpgkT6/dSTj1KhLosKNZyhF8j3mu3mxOb4KURbKVc6nH4DaOVUHQnxVAWPvZJq3C8P6/b7kMUAjOnU/53dcdpO2YBk/BNJSWWPw3FRkTF2BKHIgvUwji3I/rXYYYU/tU/jjbvD3iu5EuUwloCK20mT25g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(6862004)(31686004)(2906002)(66476007)(7416002)(6512007)(2616005)(8676002)(31696002)(86362001)(186003)(8936002)(5660300002)(36756003)(66556008)(66946007)(478600001)(4326008)(54906003)(6636002)(6666004)(6506007)(41300700001)(6486002)(83380400001)(26005)(53546011)(316002)(37006003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjRQODdxalVwWkJNL2tkVTJXZ3hFV0p3RHV3NVdtM2RWZHo2cS8yZjk2Njda?=
 =?utf-8?B?VVY1TjNCR2wxdk5XYytnWUxyUGQ0aUljVVRDZG5nZEdNc05JWlNrc2xHb2R5?=
 =?utf-8?B?RHgyaFozUUdYSXNYUy8vcUk2R2dGN05kL3ViQnB2K2ZITU5oTWkycHhiWkI1?=
 =?utf-8?B?NER0cTEydGZ1b05xRVdDNWtSS1VVQmxjS2o4ZXJzZmpNTmxoOEgxOG82NVFQ?=
 =?utf-8?B?VUl6cS9KMXRqWlM0UlJ3T2RvTm15Yktad2lmdjFSeHl1MkpPUlIvdlZPYkxC?=
 =?utf-8?B?RjViKzE1bnJKZGRrRlFjQVRGb2dvdUpDdG4remZQR21KT1JIZHlKVVhBTU9y?=
 =?utf-8?B?SkRpUkZ5cVRGMXp6NW9mRERaWEV6REJwL2NFaFloeGhMUnhpVWpScWNhNHJ3?=
 =?utf-8?B?bjlGSzlwWkhqcGEvVUZYaGZlc0tZTTVPWUVvR3VJZHlYRy9hMkNEY2xaaE1F?=
 =?utf-8?B?SURCU3BCVXRnR28wV2ptQ0hyNGNIR0xWekpBZDF1WWlTODA4UTJJYjFRQ0pY?=
 =?utf-8?B?NHUxUUJSYU12N0x0MmlwTTMwNjdtd2U4UjRaYjArV0NIUlZHOU5iVEtUaHpo?=
 =?utf-8?B?NVROd0ZTRTFxU29jZTI1cW1mMStCeUozaWFoWmxtNk9TVlgvSFFFTnJMWUlv?=
 =?utf-8?B?THpTUFJYQi9CT0hpb2o3WG5iRDV0ZStZbCtaSFJzV05nZFZkNExRaHdlbTFR?=
 =?utf-8?B?eTZtNkhBSnRCVys0R3RIMXphVEhpbTlTelJUeXR3S1Zid3I3UnQwU2J5bnh2?=
 =?utf-8?B?NDdjU3Qvd2V0OEFIdG4zNkdHUDM3QjE0MmZ6VG9oSkUrNkRMYmJxQ0Z1RWtS?=
 =?utf-8?B?QzlwT0hkbFFkeWRmNE41d2xhTXdUN09KRmxuQitBS1JTcDFXOFFQWDloMXFo?=
 =?utf-8?B?YTFWZXlYZmhkZm5LK0FUVk9YNUVOWnBjTjN6NUduWkdnWWJvT2psS1dmZGpB?=
 =?utf-8?B?dFphbG5aSnlFOGczY1pOVkoybFlBVXBaT3dNbmdGQzgxV3VlUE5xYWFPclpC?=
 =?utf-8?B?UzBXZDMxOWNHcXk0UlI2bEFsOW0vc1IyTmNmSjNFK0tNOHgzSWJDb29BZXVF?=
 =?utf-8?B?L3FxaW1Mdmc0TDZzUVJtZjl1a01sRVhJVEkxMElOdDBLWDkwZWZuQk95SGRq?=
 =?utf-8?B?RXgrVUtzWlhoT2tkYk5aZVFhcFA1L1RDWmk5ellKMU5QclRFaHRxbk1kb0U2?=
 =?utf-8?B?ZHVDanA2RC9WeXpaU0Jzc3h6TGYxeFQyWGQxaFBtUDV2VHpLOWlZK1BGS3Vz?=
 =?utf-8?B?cVNGcGpXM2RSb0U3TTkwd3JEVVJtZDFUUzFlWkxVYTBubkc4c1VMekF5OHVm?=
 =?utf-8?B?OG5BMW1lQVR6SU1ERzVVN1VtbmNGMFRaTXFkVDlYdWowYUNxbXROTXhDdHhr?=
 =?utf-8?B?SEwraEg5VUN1QUorMldKdU1iTTdHYXVuU0FFLzRwem1LMGt2NHN1NHZSeWpD?=
 =?utf-8?B?UWU1WlZWQXRPVXdEbTFGMVNMcVlzUFRzaFo4RmNWTnhObTZJYXNES0FKQytU?=
 =?utf-8?B?bm9KMTZlOGJscGRjQzI3SDBuOEpWeGtEWHN3L0FSYnNXZTJRQkpnN2EvU3Vk?=
 =?utf-8?B?OWozc0c1Vms5d0F6MUZtMjkwV2V6N2x6UFNYcFVndXlKMkFGMG0zTnFUbGE4?=
 =?utf-8?B?cGZBZURCRVN4a250Y2pqREtRQjFFUnFFcFZwV2Q4bDB4MG5lT0xNNGMrUFZa?=
 =?utf-8?B?Nk9nTENYZ0dxZ29NRFVvN2QvQzJVK21ZK3FVR3FSdVRDdEZQc0c0SnZvNkp0?=
 =?utf-8?B?cWVjc1dIcWZQNm1nQzZzenNZRUR3aDl4OE1XRFh5N29CUERnL1ZnS2JySFI5?=
 =?utf-8?B?aGF5QThwaVNuWGx2ZnRTeHkwZTFPa0RDd0Mva3VQZld6M3c4Sm1IdlIxNElS?=
 =?utf-8?B?WHl5TWgzUms1aHp0TFV5YTVkWGxqYTJXWFB0TUs2RmVMNVB4ZlNqMlJjUTZu?=
 =?utf-8?B?blZtYngxL1FoS2pqcnlZaFZjcU5JSjQ0NzZFb29rVWtFMTkwVHRqNGFHUTF0?=
 =?utf-8?B?a0E2RkxOSktFWXVocGdQdWhaZnBEVnpTNVpzMmJzMUd2eC8xMi9WRE0zZlJ4?=
 =?utf-8?B?U0JqM0dQUWZ3bEc3T2NhS1FBeitmaDNLTDNXQmt3K2hMc1VJNnEyQUI5RWZm?=
 =?utf-8?Q?1a63HBDxS6hbzof76zzOk3ieK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6def9d8c-7baf-4bef-9a88-08da6f9640be
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:07:14.9910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+BbyhVzWv3EIBWoGaknEI0aadmZl+YDz2P+kE4kvBSYMNdnXUjwVaoj7WpOVAX5ozl84irdoeWym1i8B/Hdrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2622
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/2022 10:53 PM, Jason Gunthorpe wrote:
> On Tue, Jul 26, 2022 at 06:17:18PM +0530, Abhishek Sahu wrote:
>>  Thanks Alex for your thorough review of uAPI.
>>  I have incorporated all the suggestions.
>>  Following is the updated uAPI.
>>  
>>  /*
>>   * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
>>   * state with the platform-based power management.  Device use of lower power
>>   * states depends on factors managed by the runtime power management core,
>>   * including system level support and coordinating support among dependent
>>   * devices.  Enabling device low power entry does not guarantee lower power
>>   * usage by the device, nor is a mechanism provided through this feature to
>>   * know the current power state of the device.  If any device access happens
>>   * (either from the host or through the vfio uAPI) when the device is in the
>>   * low power state, then the host will move the device out of the low power
>>   * state as necessary prior to the access.  Once the access is completed, the
>>   * device may re-enter the low power state.  For single shot low power support
>>   * with wake-up notification, see
>>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  Access to mmap'd
>>   * device regions is disabled on LOW_POWER_ENTRY and may only be resumed after
>>   * calling LOW_POWER_EXIT.
>>   */
>>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
>>  
>>  /*
>>   * This device feature has the same behavior as
>>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
>>   * provides an eventfd for wake-up notification.
> 
> It feels like this should be one entry point instead of two.
> 
> A flag "automatic re-sleep" and an optional eventfd (-1 means not
> provided) seems to capture both of these behaviors in a bit clearer
> and extendable way.
> 
> Jason

 We discussed about that in the earlier version of the patch series.
 Since we have different exit related handling, so to avoid confusion
 we proceeded with 2 separate variants for the low power entry. Also,
 we don't need any parameter for the first case.

 But, I can do the changes to make a single entry point, if we conclude
 for that. 

 From my side, I have explored how the uAPI looks like if
 we go with this approach.

 /*
  * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
  * state with the platform-based power management.  Device use of lower power
  * states depends on factors managed by the runtime power management core,
  * including system level support and coordinating support among dependent
  * devices.  Enabling device low power entry does not guarantee lower power
  * usage by the device, nor is a mechanism provided through this feature to
  * know the current power state of the device.  If any device access happens
  * (either from the host or through the vfio uAPI) when the device is in the
  * low power state, then the host will move the device out of the low power
  * state as necessary prior to the access.  Once the access is completed, the
  * device re-entry to a low power state will be controlled through
  * VFIO_DEVICE_LOW_POWER_REENTERY_DISABLE flag.
  *
  * If LOW_POWER_REENTERY_DISABLE flag is not set, the device may re-enter the
  * low power state.  Access to mmap'd device regions is disabled on
  * LOW_POWER_ENTRY and may only be resumed after calling LOW_POWER_EXIT.
  *
  * If LOW_POWER_REENTERY_DISABLE flag is set, then user needs to provide an
  * eventfd for wake-up notification.  When the device moves out of the low
  * power state for the wake-up, the host will not allow the device to re-enter
  * a low power state without a subsequent user call to LOW_POWER_ENTRY.
  * Access to mmap'd device regions is disabled on LOW_POWER_ENTRY and may only
  * be resumed after the low power exit.  The low power exit can happen either
  * through LOW_POWER_EXIT or through any other access (where the wake-up
  * notification has been generated).  The access to mmap'd device regions will
  * not trigger low power exit.
  *
  * The notification through the provided eventfd will be generated only when
  * the device has entered and is resumed from a low power state after
  * calling this device feature IOCTL.  A device that has not entered low power
  * state, as managed through the runtime power management core, will not
  * generate a notification through the provided eventfd on access.  Calling the
  * LOW_POWER_EXIT feature is optional in the case where notification has been
  * signaled on the provided eventfd that a resume from low power has occurred.
  *
  * The wakeup_eventfd needs to be valid only if LOW_POWER_REENTERY_DISABLE
  * flag is set, otherwise, it will be ignored.
  */
 #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
 
 struct vfio_device_low_power_entry_with_wakeup {
 	__u32 flags;
 #define VFIO_DEVICE_LOW_POWER_REENTERY_DISABLE	(1 << 0)
 	__s32 wakeup_eventfd;
 };
 
 /*
  * Upon VFIO_DEVICE_FEATURE_SET, disallow use of device low power states as
  * previously enabled via VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY device feature.
  * This device feature IOCTL may itself generate a wakeup eventfd notification
  * if the device had previously entered a low power state with
  * VFIO_DEVICE_LOW_POWER_REENTERY_DISABLE flag set.
  */
 #define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 4

 Thanks,
 Abhishek
