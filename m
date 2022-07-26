Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3AD581850
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 19:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiGZRYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 13:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbiGZRYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 13:24:00 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032E02B192;
        Tue, 26 Jul 2022 10:24:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnKWLGilrhohw2Apq8SrsfgU+qI+2OejKuY7A21T21nbEaQ55H6ZWsCRIqhijx0rGOD3/f+UgbQhBd8brbMYuANCX+emRTO6609iKAsoGx47mSGPZkwvfQeEx118NwkZRdySw1k9qG36ZXEgzd7/5/WAtUZVMwEajjcrpxpByyZbYP5agW+ZZ4CqspwTQW7gM9bWhyDXuFamp44yN4+M6jAp0RKMEtFCsbl2+9smCqDSUcjdSuB75J6npD+PJoTTEEmL341JhsYF2lL0cUm+Xy8/AS6fPv2n3u3+w1Xdtl92ojKv/M12C+YFda1fbo2YPOvZWJ4VFKFhTngrUpilnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGASj+vTKJMjdR7pnOO/Hp/uO0IwqILLa6u5dH+FNS8=;
 b=AblPMjep1UoeQ3JjxhfkqXtGEyQ7VdBW4Kj74Zjxhbu+boWE8iTIqIn65GKWRSTSf18VqgCAlAaX2rgQn3eOYKctyAiQaD0Rj5K5AFfaXi5A3Js5OD4Y7J4cNN/6d7BAhwXSjVLExmkb7RJr1TZW+A19r/ahrSSauf579W7NjCk8KL03l1wS2L3JVlzrL0wqTklCLi++x5N0pf7ge87PaJWN9BVSH45ioLOwnDdj79GMNELUiqurRITqVFpqvBY/gRp2IWjReAj7ZuS26+wTV70pKigA/1CO9Arb2j7eW5zf9jff77cv7WSfXftDXTJEbUKXrsyzNAvv6as4R/1aCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGASj+vTKJMjdR7pnOO/Hp/uO0IwqILLa6u5dH+FNS8=;
 b=foRdh0wdlTBJUlTu/PXst32s42fZJOUVw+PagnCQHDnEUMijOHe6V59S7DLPmvVOCjng5TvzuEhtN2W58vyV1ojmwY1L2Rq3wE5jtdHj91XqnZb3SGElew0jiuN6qL58FIeKT/23oAlH6HbnkdB71WZcwQrwOIuggsxD3AZyz3sVuYSDqxY+Eo6JjPLwT8Bk+2xn1ShogklXiIW63plpCFmmcPaO1T0d+3mj7IfE4aP3QZ4TQEX/O5PVoJqK0E5wsxfjuTALvF2pjTeLIX7no3X218hheDmF5HqyFy1+u9f9ss7GE+dyWns4VV5solg9OUQJIxe91htz0/eRiRiiZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB2530.namprd12.prod.outlook.com (2603:10b6:207:43::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 17:23:58 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 17:23:58 +0000
Date:   Tue, 26 Jul 2022 14:23:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
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
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
Message-ID: <20220726172356.GH4438@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
 <20220719121523.21396-2-abhsahu@nvidia.com>
 <20220721163445.49d15daf.alex.williamson@redhat.com>
 <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
 <20220725160928.43a17560.alex.williamson@redhat.com>
 <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
X-ClientProxiedBy: MN2PR20CA0050.namprd20.prod.outlook.com
 (2603:10b6:208:235::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 913e2d9a-1f6e-4636-c354-08da6f2b9f8d
X-MS-TrafficTypeDiagnostic: BL0PR12MB2530:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mSkSNBc8g84A/7kcUbolRL6zBv2F0GL8XpHLcmZ512k+83HrcZrxUlo02wMWXTD+ryuOhci3bSr9uSexc/PYn6bwAMumCo1jstixQPpFL14lYgd2gThHL45Lthk9eP4HyMj/NqnV06L5cv74v+4cRaOxCsmHSbus++S22mKBdSkt8c7qlK6iDD5ckgJG0DJsI0paKXwvPk7uH0dHanSbGr5UKvsCMiku5AEdKSkf9Z61nx1W79vKURiGovPinixsgQzLWHWC57i19j6lH68DHBao5isMv10sDyMDPfkrfqrgH5sf3chj2XX9NVr95kPmk5iNtHxqEBQULQpBxuaIX8z0BBle7UPTwBKR5SKIKylzyI+kiZRvadYj/i+Jkd4TX957wUU8ljHBXfo/TaZJLE/MTPE8OVSMxj+UtDKOl151P27JcOWON/dq0Z3Fx0xU2AFoU83YhRvgpR12oWStp6mjIPqFBGi41zSKoB/47xR9fTFNJC4vAkuJ5LVEa8s0PCwMSz0h01BYZiiekuOMcVlrzEW///i1UNWdQhByN2rtPrOaCJ3PZngy/aI/eYzUvI/n87aGGG6Uez7BkVA1mZDQq2WtsBtbzMGUmg5KHU8s1XzdRyJmBu7VG+TieUxI459kC/b0+7ee8UMdKb6rm6nFviQ9LXNTAgbwRaI8r0XAeb6xtgz0uFUdWKpE79v49D3Od0s4CoYDiPIqshE5pA/cV3KQw4obfA4QoOdgJvip2MC+Vqoraz4XNaG2Y7Jz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(8676002)(66476007)(7416002)(4326008)(66946007)(66556008)(5660300002)(36756003)(2906002)(33656002)(38100700002)(8936002)(6862004)(6486002)(2616005)(26005)(1076003)(186003)(6506007)(6512007)(86362001)(478600001)(41300700001)(37006003)(54906003)(6636002)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?04agtZLbMDn9zXxQgVraKYeTnjq35vtvCHcuF3DsPPiBHwfE1np6ohdK9kTW?=
 =?us-ascii?Q?utFgCG2EdWy6G/QQkwBa9+FmnVs7tGUaD9fk/DDUx4iVdAslOC0HGaQPxh4G?=
 =?us-ascii?Q?lPTbhKNCsQ76uiT5wwLLW0c6rbL0tAG/IOSHlqheCKJU2ZrsSWuJPnMtYVDi?=
 =?us-ascii?Q?8Ofy66Y8cFFEH5idAf6+qJOfCxE+fcOi5OEf4DbH6GccU/VZnQ2dW00jDCgu?=
 =?us-ascii?Q?zXTZryOmtkKYw2cUsD6RsfkgEbaoiOJ8aOP8uwbTN55Gyz+DZMOzMFTZwLE4?=
 =?us-ascii?Q?F29eaIMM4ota2EKlWdudutkWdI6JJYW0p2a6nixUut4GNooiHS42QAylRwcg?=
 =?us-ascii?Q?8dHCvElyMaQ3R3XzyqTDOYCGyZkN7cKGTUJ1aCYD3F3dovIJuCRf9rAKTnMv?=
 =?us-ascii?Q?XqMdKGc7/oYEEO8DGiEtJRxCeVw38YBKSj7A/NzI4yNMdroGg775cRMWru/8?=
 =?us-ascii?Q?H2XaxkhQib7tFAYY93vtNo6NQbMmB+JxvMhowHoUE/HWRjHAqnzXDgEV/lG5?=
 =?us-ascii?Q?7d1Ybdk2ihWv/bvMULL46G+/GhB9iaQtO7exgXhoWCKCxQucn9BAQtapZg2h?=
 =?us-ascii?Q?toWtpkQ6zapiAUHmKMHRoRHYkGeSPFk+IqSU7b1xZ5pG6HlxOCVns/5P1J0E?=
 =?us-ascii?Q?stdNygHdcvPKjuu5rDZdFVEAd0uEn6ltrkHsb1p1qnIuiaNEea9ZZ2SNaJYh?=
 =?us-ascii?Q?1CsIVRx//t+RMmORjQh7iM+egC+SSch/UktYQKSfbq476/ubdUgZS/92auZO?=
 =?us-ascii?Q?IhaBx3T7zyz845GSzUDBYHR/p0lzpxmvd04Jnp1ZVHfSeLo6nWQSBYvAAtR4?=
 =?us-ascii?Q?9kZyWBoEghekr8RqPjfZphgAgfYZ+H/u/AOyNtSj60k3xk2WMfOa7eoOUVv8?=
 =?us-ascii?Q?GC8HaRrhOyh9Wv8JKFI7FHhWgCoikAK48zo8IiE9pO7KnODRuZtAJmy1K0Sw?=
 =?us-ascii?Q?goKUJ+rGedXu+n2O0hHXTFwA0wJ2nSPvXGX+lgtF+wK4AnM/zLNnx3xV/ere?=
 =?us-ascii?Q?70syiIN2Ko6zNlhYoWd+ozTf4m0/U8fYokNWfiiL4CA18PvzFz0jT51c72k+?=
 =?us-ascii?Q?ZFJnQa9CQmw4Zcp06+Bx+k1Dn7GY8PZAUt0h86MSf2i53/m8lRnwie1RzrCs?=
 =?us-ascii?Q?15nVsw8Gkok4NrAASAVYtqm90at92t9/x2GDOSeY/9uvbKdHeZf81NenDw6h?=
 =?us-ascii?Q?P6zVrFtWFEVpN4Nm3ldm8UcA2TELVvHGvskxZZMUsTp0Ux/E0YjLgW/PDyck?=
 =?us-ascii?Q?YWNpUuBJZcRSLTcFAk49eIMHOx3kSguKv+gWoOC3pvR3nJHZN8Agy4YZIi+T?=
 =?us-ascii?Q?is3TwO8OGDHKOBfQ7GfxPPHlNakN5l7bZTn+MgAyYRVz1HPcJL9ZNUbN6Tzh?=
 =?us-ascii?Q?cCJRHeST8qdj1FaTEhn1ADa2nSRCuHPZE/EnCsYi3GvWBH9OzIJfSRQczmrW?=
 =?us-ascii?Q?9UQDmw7Bk/GRJS+To83fT+wh3AFpIOIgkiZ0PsAaOgZhA2vDwGxMtLHFR0x1?=
 =?us-ascii?Q?4hQg9TM45L+TRCNOxymAJPXSN/Q1DQPnS5vE8hFFEYM99lTdzqOseTiVAhdv?=
 =?us-ascii?Q?NfSNJcMY7FmupWipEv6g6nPxxQ9uJcx0mJEQI9TU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 913e2d9a-1f6e-4636-c354-08da6f2b9f8d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 17:23:57.9522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OVJYuK2of8SaKcy5mGEWByc0cqZsbCl9vsrBy4UGIvDiETWjnrv/ObsVMdLrmC4E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2530
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 26, 2022 at 06:17:18PM +0530, Abhishek Sahu wrote:
>  Thanks Alex for your thorough review of uAPI.
>  I have incorporated all the suggestions.
>  Following is the updated uAPI.
>  
>  /*
>   * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
>   * state with the platform-based power management.  Device use of lower power
>   * states depends on factors managed by the runtime power management core,
>   * including system level support and coordinating support among dependent
>   * devices.  Enabling device low power entry does not guarantee lower power
>   * usage by the device, nor is a mechanism provided through this feature to
>   * know the current power state of the device.  If any device access happens
>   * (either from the host or through the vfio uAPI) when the device is in the
>   * low power state, then the host will move the device out of the low power
>   * state as necessary prior to the access.  Once the access is completed, the
>   * device may re-enter the low power state.  For single shot low power support
>   * with wake-up notification, see
>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  Access to mmap'd
>   * device regions is disabled on LOW_POWER_ENTRY and may only be resumed after
>   * calling LOW_POWER_EXIT.
>   */
>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
>  
>  /*
>   * This device feature has the same behavior as
>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
>   * provides an eventfd for wake-up notification.

It feels like this should be one entry point instead of two.

A flag "automatic re-sleep" and an optional eventfd (-1 means not
provided) seems to capture both of these behaviors in a bit clearer
and extendable way.

Jason
