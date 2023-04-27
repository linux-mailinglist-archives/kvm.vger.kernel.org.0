Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D455A6F053A
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 13:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243694AbjD0Lz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 07:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243283AbjD0Lz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 07:55:27 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95470E61;
        Thu, 27 Apr 2023 04:55:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNjcUp01NU1fzYdZlFZUA6vfOnGuYpi1mFQKRmVfQ9Wbn7nuUVq70smLAZb7ZDaGvsp4sbe+tWInepJrnzmi4FyWCQOGG5pFvwD+guQ4ILKUab451KmJ/BlAsIs4RdX3rlDg8LOrk4QReKvY54ljICQQwRrVXnpQIJMSTV0dgWF3npdnju4lmOLveys6jSJk6mnC/wwseKSsb3tCSTSpVshUMkhKXsG3uhXkimLF14bIjsshcgLW9KGczbT/CvJj/BGPymzE5Pyb6JPzoWXRaoUPq0MEXU6i+hvJXuzLdIVjY5gzbiC9Jyh9XXS/xaYnRKTgL7kUG0GIKTWsUEYfDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hnLiH+QN1A9kS6R1hF2Ixsxg7fHGONXhrQvXQJ0y6h8=;
 b=ZRZ8vaOl26fv/NSySMi7J8lB4IahnhAfeZjtRMV8cRq5TF4lRcueT8vTPPCRucSV/P9T6iZ0zPnTjHMq+HsjXdDvL7SoAKVB9IOJYImous/3gNHmqk3lHp1UdSvoAnFakjOAOS2vXu6vd+KtUH7AJqhUO9V+zUmClF9HuUAQFnaHBRH/U3An0Yvl7X2rrLE1O5iMl2+7x/DcvpIWqmribkShuKpUr9I+idoc7Q5PomU/bxsRnBtPnmPPnLWUAAU7rFMewoeNLlnQ/pSYa8fnkM8mcrsnhPyY5v921HNyvCEFnCTe2yJOIKBXwm/HwwVj2aocNMmdq3PzL7khFTDIvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnLiH+QN1A9kS6R1hF2Ixsxg7fHGONXhrQvXQJ0y6h8=;
 b=BnprGrvbuoZXJcBVPJUsjrVK0UzVm7Qqe0ZtViV/TAeAQ78tW/PjmTEUSgLnsRTugGkeHsIOsmhZwlqmzkgEKObMcdfc9nMjb6ccMlWyteJVYVLHmdi6/xq0qo6LPg7QWOTNLI0PTzoa61cCkBCPYjMYNc/4xZZbxSqyDmgCTUNk7n9BW9PAeJAiGxrrV8Z0dgHyVPEtq/mGEhb8YqcFSEzBYyYKLHmrCB5r1undjV37SnYanQtxR+HQ8tR8atjsaarce/KB8JGsJM7QyhzcxAefDJeZH2Dhf4spCE3/7FWPji++y2DpgL/S8KxTrj3VNnD81F8oE8+TxmwmQx53NQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5424.namprd12.prod.outlook.com (2603:10b6:a03:300::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 11:55:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 11:55:22 +0000
Date:   Thu, 27 Apr 2023 08:55:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v4 6/9] iommufd: Reserved -1 in the iommufd xarray
Message-ID: <ZEpip09rdbm4czt8@nvidia.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-7-yi.l.liu@intel.com>
 <BN9PR11MB527637C7DBBC4295F5A3BA358C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752976E4A6838A6769EB1120C36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR11MB752976E4A6838A6769EB1120C36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR07CA0069.namprd07.prod.outlook.com
 (2603:10b6:a03:60::46) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5424:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f785f9f-5475-4edf-8e6f-08db471647d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XaxqkfnE5uay3BC4Vgfsft8O1gnwlms0R5/Zrw55QjHhradtmx7O52U8cCUKDT2vg0SrJ/eUs8Jxyqn4kR/jnZUz+KCgzs6wNTLE0VHoASskOHQ1TvordmZ/sAcg0xBCc9MRZoMbFel+btnIjEtdJstwWW49zwJmkJVwohHjslqs0MCCYAR95apREEZOGtpaPfSvtiRHa1OWaU7ygka1B2IvfNmaPWDmAQO8O5+QqV8DhjVn07ZEb35XlMR1Zsw0JNhFgU2AxebLTGDTIyXZQHt6RCKrGC6Gyk8vYL/dpMRNkFj7KM6yIl06q77Bd/H1wV16K93jRrNs9iXcmwLvopViLQKmYkDEdeUo863UAIGkpK3Iqokcmf4kSK+BkoUEZl1606bvaOoIfetMuJVdheV0ffAV3OF3lB5Y+/MhBjE4KVznYcA2SPJ7dpxDaQa7G3m2lzGA/nAAkiPPg1Zy0aQmU3zvrG2ZSYhb8Bevx9cL8xngbHgWtNZu9RsjtnCQ2Bs1Q9KHcNQ6tTqEAwG1lsNdzrxzAEHdbflqCyDemijZGHy7L95Z96Wkqqk0sOWn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199021)(316002)(4326008)(66946007)(66556008)(6916009)(66476007)(54906003)(6666004)(6486002)(86362001)(36756003)(478600001)(186003)(6506007)(6512007)(26005)(5660300002)(2616005)(41300700001)(38100700002)(4744005)(2906002)(7416002)(83380400001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QU55b1NUdFR5VmFpcWZLS0ZQU2IzbkxMMW5LR3hzRnJocG9YVmczMS9yL1Y5?=
 =?utf-8?B?YXZMSTdCQkNyYjZYVzAwdUpic2pEOUp0L0dIN2wzNHF6bXpqbGRoSnBnMGVG?=
 =?utf-8?B?akxpQWdQWlRndFBuQkRwcUtLR1NtenNndkJNZUJ1bEZkT244d1k3MlVlRnB5?=
 =?utf-8?B?cGpjaWMzZXNqWEVWSUZIejVpUFlWOUl6RWhDaWVlMEdpWDZaNDZsNzcyTVpJ?=
 =?utf-8?B?M3B4UkxZS3FNS3JWdFpHNGNMN29ZbHFIQlZvZnJ6TExFWXdzVjVjdDVoV21Q?=
 =?utf-8?B?MUFwUk41VkZYdEVVRVhib0diSlZTQ0Z4SkF1RmVNVGFTZmF5Z1YweGIvNDly?=
 =?utf-8?B?V2xnWFpwQ2ZFLzl1MTlXbW5nUWtUYkJSbE5waW0xZWdWQzBnd3RHdkxCcHJB?=
 =?utf-8?B?ak1UOU9DZ0ZNUUdTaWd6SkpFdCtZYjBaeW0yVFVHa3FtM3hENU4zQms3aUdN?=
 =?utf-8?B?bEI2d0Y5YXh3dWQrQmZGcjZ0bWlQc2FCMFNvSVhoQXl1WGNUOGR0MG54bFhr?=
 =?utf-8?B?QlRYbi9nNnd2Z29YaitxcW4yUmlCMmlMT1EyZkNHTE8zRmQwZkpNNk5xZU4w?=
 =?utf-8?B?K0RjL2lHVlZBVmJ2S2ZpSzFCbWZNS3VKNkhaV2JDWHY1R2tZd3ZnOWhLUzJv?=
 =?utf-8?B?N1lGQnpzRVA4QU5pRHlHdDdFMGtHdVlwU0dmemhObjVyWkF0c0FTN1A4djRn?=
 =?utf-8?B?VWNSVUtjSkJqbmtTRDBhbDE5RE1CRVFiOTlEcjZZVjIvdzFQckhWY21XWVJs?=
 =?utf-8?B?TXVwU0gvMmlrVVRxb1hIZ3BRUkZncnNMYlR4Z25KRllNTVhFam9BSS9vVjcv?=
 =?utf-8?B?S3FQK3VHekJOcVRJTzRKakhoSzdsU1M0VTVmajQ2ZjVtcUdjbmpQWVBsd0c3?=
 =?utf-8?B?WXhJTDIwQk9IYlZMNlVGcVVlUGZuN1JmNDZTSmU5V0Q5T3p3am5DRjdWWnhp?=
 =?utf-8?B?eDF3WVdBWEl3YU5tMGR6b1YrMTZBRFRRU0poeDRKUkcvR3IrNHpTcCtpSlVT?=
 =?utf-8?B?MWs0eWhQWjZPUFF6cVBUTjVVQ1h0TWt0cnBYRnhLWkgrMFFweG1vOWJhYVlo?=
 =?utf-8?B?eWZxQTk4SmY3cHVHUTFHSVBDUWgrWGg1RVF6eFp6eDd2OFNhRSswSTV4S0xt?=
 =?utf-8?B?VzNSUCtQMHJRbGZkWFFtVWNpS05HZW5Mb0NOVjY3UGhoaUh5V0Uwc0U3M1lJ?=
 =?utf-8?B?OFI5NGI3TTJ4QXVzWFlWY051VW1LVEw0Ujd5dEs4dUNMa0RUL1IzN2JDanZX?=
 =?utf-8?B?UUFQN2R2YXVKWnVIVEZ5VG0rRTJBQWplb3hRSzNSTmpFbkdLZFhjbzBYaWE5?=
 =?utf-8?B?WWVVNEFTMVNCYUVibWFNMHhqQmxpdW1FR04yWWQ4WDJCeWg4WFh6bWFhaDBN?=
 =?utf-8?B?Vi9KS1lhRmJ0dUpaaDV6M1N4bFJXWTB1ZjNqa2t5VTBldzNuV09KVTgwSGVT?=
 =?utf-8?B?cyt6QUQyMmJSUldEMElqZEVrakNkL1NueTd4WDdFR3BqRVZEQW5TaDllSjd2?=
 =?utf-8?B?ZGVqTE5SV2dJbkRNbDRlaWJVd0xxN3dyMXJDN0N3ZjFwM3phUysyOHkvRnBo?=
 =?utf-8?B?elN5UTRPMzFCYXhPQ01mVFZlUGEyVGZaTE0yQVpvc3BLcXVuZDBabExvcHdC?=
 =?utf-8?B?UFU1M3RHR1F1QTJISnhNUU5DazFFWmVsTHhYOGNFd0JlVnBHT1ZpT1FndUJw?=
 =?utf-8?B?ZHlpQzlkMWZiSThnTURGQTdPSmtjazVPOGY0UjNQNmd5cGJzNTJTNnFUbUFW?=
 =?utf-8?B?L05zR0F6UFNiRTBVWEovZUFoNi82ckNjTEpaMDZHclNJUTdqTktieFZldkps?=
 =?utf-8?B?aGZLVWkxaVpDS2FLQXZxem9iTFFKbHBqS2kzbEdPMlZSNG9pNGkreTFTSCs2?=
 =?utf-8?B?RDdwK0Fxc1p5RVk1dXN1N2xRaDNLbjdiM0FpZ3Mwcjg2RTBFd0NwSzFTTi9q?=
 =?utf-8?B?WERNVzlFUnQzcGNoSEtiMVIzYnZOOG8yV2svWXJhK3c3bUVtdVdpb2cwNDRQ?=
 =?utf-8?B?SGJUMG1yYmhpNTE5eEd3TjZLbC84dlZ3MVFWZlIvNWdSbERZVHdkbjZrMzNG?=
 =?utf-8?B?U2R4cmR0RVRRZ09YbUNtMHFYNzFkd1kvNEhHaGJZaENIaEJVTjc3MzBNc0xn?=
 =?utf-8?Q?BpxA30oO9ncJWEJ/S/z25oDgB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f785f9f-5475-4edf-8e6f-08db471647d2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 11:55:22.4480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lsd7jONsER2BjRvIkXrRqwtpp3Bp5ZtK++nbq2hEMPjhI8d8dxW31+o9qYzYjZrf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5424
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 27, 2023 at 07:09:38AM +0000, Liu, Yi L wrote:
> > > @@ -50,7 +53,7 @@ struct iommufd_object *_iommufd_object_alloc(struct
> > > iommufd_ctx *ictx,
> > >  	 * before calling iommufd_object_finalize().
> > >  	 */
> > >  	rc = xa_alloc(&ictx->objects, &obj->id, XA_ZERO_ENTRY,
> > > -		      xa_limit_32b, GFP_KERNEL_ACCOUNT);
> > > +		      iommufd_xa_limit_32b, GFP_KERNEL_ACCOUNT);
> > 
> > Just direct use XA_LIMIT() here.
> 
> Ok.
> 
> > btw do we need a contract so vfio can learn 0 and -1 are reserved or
> > fine to have a fixed assumption in later patches?
> 
> I doubt how to do it. ☹ @Jason? What about your opinion?

It is probably fine to use xa_limit_31b and just say that -ve values
are reserved in a comment near the define for 0

Jason
