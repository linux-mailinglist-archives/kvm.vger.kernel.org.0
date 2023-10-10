Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC56D7BF9CD
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 13:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjJJLeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 07:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjJJLeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 07:34:03 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEF4A9;
        Tue, 10 Oct 2023 04:34:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXRilyuXUaRc3qRN+dZw54w4M55Ym8G0IEXc8KE12qqJzl35JoR6VW2isEGrYIWre4y502AzLKzgb5jXB2hISBDULyghohKBwGC5+uncId6PIsMbxbgBcz+9opoynMRnkVjllUEQ+wLqEOqXCA3oQ7bGlauCJOocUSJaPXkzjcpb0pgTbOErokuvZfeHpbh9NngwEo9bY90JQfV7M4kj0Qky7wSpAm/J0x1uJBBvy6NfA4RIV2F7it+eS+B3hnrStS6dJfwdKjkJx67Pt9VlhpwSz019oZu3nqpDz9dpJozjjeAantzJLt+o+Rmp5YCZUBnicpHfqAicIN1Ck0gzKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQR4DEJHBXH82oiZR5GoKzbPLaJ5JuuJeFXhkuFcTLU=;
 b=iiARdliHvhbfmCqiuLQUH3p86bg/c8n5/Tm76HlWwIEu/oISToXCM+f6Vyw9YRBbPLk2NvnPGWU8mbsi2LyLvNOsLxWdxpXoP66U22GOLaGI6ideAEte9hdddOGtZS5qlfzFl0bTYr90WJMUm9jXWUylbqgwX0+UGR++cX82jWRxTyGCNEFZMprYY5RZQMnZzsMxHRyYaVuawZh2jpTo1ry96VxRVF87Oox++aB8berE46B6hWfA6IZIril5cRsGgDQifQy1IRKmxGLgHDUxmc+wPn6CsJ+PKpVW7kLuKXk9UUEvtYEIkg1qJZQHi0udcJqJboLXl/XOBop6XVU2dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQR4DEJHBXH82oiZR5GoKzbPLaJ5JuuJeFXhkuFcTLU=;
 b=naPEAg04HBVMb6aKhu16ZoHwMFNOtIQvDWu2F80WHhLwidD3OcHZkwKMbjRzwMnrnPGMZDoPC2WHP5iOBlFM2ygjuqv4W3jqMdHZ8KeApWKTGgs5at6a4+zGDA/T3crKGtK0mLUSPy7EZLipXivVOd8FEL9tMXzcPfKdTyOPVGqqVIi/Yu10dFUeJxU8Esy3k7hiNZlO5X8angZi4mImZI96FuB4ZJMhGqI/XQrOTnI5Cm2HIp37w7SgZ7QvPgWzgg+IeLezB/UtcUUaCl3qTx24MoZaTSTPCO9AmU7f1ZIE+vIXTIuZ7BM28KHtD8IXEcuo119/SBtFA3HWRiwjhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB8804.namprd12.prod.outlook.com (2603:10b6:806:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Tue, 10 Oct
 2023 11:33:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 11:33:58 +0000
Date:   Tue, 10 Oct 2023 08:33:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "ankita@nvidia.com" <ankita@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "aniketa@nvidia.com" <aniketa@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "targupta@nvidia.com" <targupta@nvidia.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "Currid, Andy" <acurrid@nvidia.com>,
        "apopple@nvidia.com" <apopple@nvidia.com>,
        "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
        "danw@nvidia.com" <danw@nvidia.com>,
        "anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>,
        "dnigam@nvidia.com" <dnigam@nvidia.com>,
        "udhoke@nvidia.com" <udhoke@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20231010113357.GG3952@nvidia.com>
References: <20231007202254.30385-1-ankita@nvidia.com>
 <BN9PR11MB52762EE10CBBDF8AB98A53788CCDA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52762EE10CBBDF8AB98A53788CCDA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR14CA0025.namprd14.prod.outlook.com
 (2603:10b6:208:23e::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB8804:EE_
X-MS-Office365-Filtering-Correlation-Id: 10d31edf-080a-40ab-0075-08dbc984cb04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eELj79RcqXxLr5mtThgIsLWN/x2f9bdg3scCzvkpp8o2NgxOfXaEoin6qItJ657mKVpQGel1yuHHILE43VHqChqptMtyRSExBg84u7SiJH+k1oQyohwiuaeO8AWB5OwzFLbCwXd56x8kSN6pGkN6zJ2efTrdDcUaunRxXFOxdqMTu0i/S79FNRRj/jc05O54NoD1mkE51TjKc/gT1JOXRciVWxPX1nAxQBBMMa/LIbCwIfMlYwQs/jyQ3omr8OxGy+SxbzZ2k7edMIcLB4TbOjsc4lYGIQ7D1rU+C9HDuJEx/b8pHXFWBZRoG51oy8vay6w2cd71VGlW+NgkCa5+kkzdUJFXw1Y1Fi75TZFsKOjMu+/pMHvTw7IBUICOrZVWae1O4WOoPn9bGynSTZBlWUV4752iopMRraATgWrUre2zla5yudTR1ycFXZQvUt/KXvr+UgcwKYYipGfCW+ze2TNeesWOjVL4U83vwbBi1rQZYv7ITsQEh5XJXVZVrvIB33dnRHjeFfrrUhba5QvljiXg2NAU5Pe2sMkhbmjLcr2IufTXMyVV30rnaDUuJN3z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(396003)(376002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(6512007)(83380400001)(2616005)(26005)(1076003)(38100700002)(86362001)(33656002)(36756003)(8936002)(478600001)(4744005)(4326008)(6506007)(2906002)(5660300002)(8676002)(6486002)(6916009)(41300700001)(66556008)(54906003)(316002)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ionGmYR1dHsDim95lOP9n7YMuLwX9ejAPra8aV2BnYI00mNr6fx9yIhycFBO?=
 =?us-ascii?Q?ZYOiKhFSYaaAS1UZG+dXGwYCqWULkiegNEsoJQEf+tiqbpLvyCIaG1OVDYrl?=
 =?us-ascii?Q?imd4+ZM3+P6qscqmrBRn6kgGPVZ/WqctbZE2j8jT3qaj38V5+Md1hjvtPcQG?=
 =?us-ascii?Q?zsJNNTDFBZV6ml7Y1vnA8KxsFPAPTBRcI+xbgFiyQSAKxS2i+TtlHb9cCa/2?=
 =?us-ascii?Q?th9mi2fRryBMB4rEJTlseIverliNn7IkbRUNoM7gnSD4slHCf5yZSIV4G3Qu?=
 =?us-ascii?Q?EAWp+q7wxB1z3LEFQHXr/iSzrCqc3QkX3JaJhx8jQGU7iTd4BIDzUHDpVQzh?=
 =?us-ascii?Q?sQkNdb++FMxDhw++gdRFKRJjzrlx/AjqFt3l1ridcDQupCHTUsKLuSxjxZHJ?=
 =?us-ascii?Q?MSWR8O3llJ/nxIOxUgSaOtQHARaEAAW074SV1vJDu40bxaEVJQr5ACFQeFJF?=
 =?us-ascii?Q?nzieJmzF8xJAsaPPaogrxzNzVq60erqopEGD3j6mzCWCUAT9TioG9Fn4eURM?=
 =?us-ascii?Q?9+iJ1L7N3oW6H3TZo+IjF2l51sFaEVEWgPU8UqVfU28bnXhkhVzRDGwbOqCs?=
 =?us-ascii?Q?MNwGYbQugniIw6uMmK80+UlAdbelaQC8abURnyGCE+zhARIhVWksM+WerQyB?=
 =?us-ascii?Q?v5NOqwp1+FqlLH9tKJJAalEpJILrTAU4AKETGnUNEv4s3sKSjSuZMdj2Vk/Q?=
 =?us-ascii?Q?QkFcuvBXUv/LDfdPJOnXEFnVvMYg67ZJqooy7Orh+mUcMTtXAyvKFjMUBw0v?=
 =?us-ascii?Q?+RegHBTS0w0isTK2EaouYl00bw7Pmxe7LRzcrCtqNp5JeyEPGwAo5PhBIPen?=
 =?us-ascii?Q?3I+VfUDavd9CsDpALmNSZByvWHH+xhzGnUgs8SgTbsZK9aTqRoYvJRUtU/za?=
 =?us-ascii?Q?hvwGVWTRPZKAAQ7doYFNeXnmhGN5g+5whyrWvkSLrQZ/8OiNxxEaPUv4SMsH?=
 =?us-ascii?Q?tgJSGhuvsTQjcfOPbO87g+ke8dKCTpw7VXBLdwRFw0qTzwGNPiR7oc8tUhSQ?=
 =?us-ascii?Q?1SFzL4tXhkA9nz5AmWXwKyKXm34Dl2iMga+JkR7S8llt7fFJS5rxC/DA6wPW?=
 =?us-ascii?Q?vqEI9xf2CdLnI496ZJ6sIOau1RMCfWeVelYSNweyoG+bs9na1TlNRRckQ5r9?=
 =?us-ascii?Q?pxeQHypS2shnKq3GO0pRoQnbuh02qTzBof8tI+2b99fBTAZOCv2BCu5Zdv5+?=
 =?us-ascii?Q?gk5wrYOk/AsjrczE/6ADVCco4Ud+nnaIQmwJVRMgoHBCq57hsEQqVTE4htjk?=
 =?us-ascii?Q?+eNQQYZeMlehBKJ2b9f7QKp119zMxxx4W2kk/MoSy5i4jWdMuuKpLB5f82ue?=
 =?us-ascii?Q?fPFV3OfOObFn4IkkL9NY5Z3gIbyaBlaj9M8RhmXuFeM1gZM6sq8IrCbjQzSQ?=
 =?us-ascii?Q?V5XreD45s+NRt1wd0gd4b8PvTnFqzK5Qy/oc4K4vlbVr5N01GW9drswFRjuv?=
 =?us-ascii?Q?3WU8fOynl7VPKE/ZZi3WOuGAE3UiBe3RH9aY6Bkk8mlImXlJ8jF3TFv6K0B4?=
 =?us-ascii?Q?E8e4pYiEk+s9zbq+t/UcBofHxBat0fbbK8dFnNlUGHXPc25vtn7tmtrXJ20L?=
 =?us-ascii?Q?TOt+i60SbTibdHGCa2w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d31edf-080a-40ab-0075-08dbc984cb04
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 11:33:58.3742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmfpZbT8hskH/FYT2nV6eUn3qEj1lZf9X4gMr7PgAbDPkdpIlCBxxNfSqIretaT5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8804
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 08:42:13AM +0000, Tian, Kevin wrote:
> > From: ankita@nvidia.com <ankita@nvidia.com>
> > Sent: Sunday, October 8, 2023 4:23 AM
> > 
> > PCI BAR are aligned to the power-of-2, but the actual memory on the
> > device may not. A read or write access to the physical address from the
> > last device PFN up to the next power-of-2 aligned physical address
> > results in reading ~0 and dropped writes.
> > 
> 
> my question to v10 was not answered. posted again:
> --
> Though the variant driver emulates the access to the offset beyond
> the available memory size, how does the userspace driver or the guest
> learn to know the actual size and avoid using the invalid hole to hold
> valid data?

The device FW knows and tells the VM.

Jason
