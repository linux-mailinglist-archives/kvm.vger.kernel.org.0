Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2103648385
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 15:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLIOOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 09:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiLIOOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 09:14:00 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5FA79CA4;
        Fri,  9 Dec 2022 06:10:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhYGYM06prYsWzfqeEVPaYOVVKQk9eUvUeYNhtnB1/mbdAgo7Ty7r7EbV8OEEnLwE1aWBpR4yMFOVcuZ9ubKMhF3XZ+HjRK2EE58QPiG69LWbE+eK1Hx+NUA/A3IGMiY+yJelzZQmWDCgYRX/9RXenjoORKWbu0JQijWj+av6I6W+YQbN4F1Wo9+k/rWvOgEEf+K0IZTC4jRXebpSTezQO1hWA/eWnJj3eowNvg0+SNpmT5kPj2Hy/QFU/3heklzhMxQ10gyfuMTZxpFHaQkCfxgMaKhXOIvOY920YvdQGPj9YoaAiSKVuVzzw5DYu8wIZjfeMiHlA/L99DlkWI9bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQDYvHK8Hh6kTUXRNMBIPmN+cc6MzIvUOCz9HS8rxXY=;
 b=aSIkxMCnIXAdyJXhu3Zf4x7DXLaAdM5Jilkhkl5RFF/tO+a6PFdEVXqGu0BpXzq3NXFLyEELUSrXIcg2RZP+1IOa2+g7L+KTq5hxwWZ3mO7pvbEuhEBPp/mn+TLO49aObbb+SHgSiotF1OuGhZzaNVUgOqY3f/RbJgmJ2UB3JJ2dzBbQ/3Da4swHxUMjlpkVyCJe8J3ZRPNSsfX9pIFUS7shRPZWmVYX2k/J+ViJBcP45GHj0EknTAVdILXQeJFrD5yL+AO1N0cDi+Erq7IaV67nH09mFFFIIUxSDZE3arBS/3PNnN2vMZCjhwZ9QKV34t6akMy3jVgvRbGL58WsnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQDYvHK8Hh6kTUXRNMBIPmN+cc6MzIvUOCz9HS8rxXY=;
 b=ZMi7d+3N3i2x3Jcv9Ic6avMkkcp0M3iyZPXIbRlUxNJfh3Sv8esDQMq5zsutm2e+z9J7vGbc7YW/L/U042WcpgntGyjoY64R3oQsZc97bUN6+bhsvrj9guX+eRs9srpd3RX1Qrc+XHKDiRa7QQ5lrRFn9jFdChE2TlpCMVhW88SJxb9gfG4ClZu56ABB7fo7sdUjl/w9Ls8AEehossdCCrE7KMZnuK9n7K9+zL/5okN5V9dxvLYjxwRgCz6C6bZ09tL5KA9zxa74sRJRWKQ9GWglKFyA2HavvexqBrQ5/Jd6eGPHX3H/bLMw57i+CR8VNnRhZplXHEoyLlihdhjFVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5896.namprd12.prod.outlook.com (2603:10b6:408:172::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 14:10:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 14:10:56 +0000
Date:   Fri, 9 Dec 2022 10:10:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd 1/9] irq: Add msi_device_has_secure_msi()
Message-ID: <Y5NB7o/7gtryVpoJ@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <1-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <86bkocr83c.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bkocr83c.wl-maz@kernel.org>
X-ClientProxiedBy: MN2PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:208:236::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5896:EE_
X-MS-Office365-Filtering-Correlation-Id: 818ee4e7-671f-467e-a6b7-08dad9ef3046
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9KZqKsDWfBYkMUvUhq4yq9WjpqAyjYObonNcOW7oKTon/69nLAO8UgnsEuTW94ns6hmK8yxnnaVXo4Tsai1E5cep2XWW+HRtON/XuxXKBDDoxIGGvh+lMbnmXv0aFqV74CGNS2t+7YWyXdmTGzJJUJmVlMjtunvjdkPontGLOubf39p8G1fJuK/yuG2UfUXTrXCdbqQycOy9NgZ9vf2CZM+4foZeEg6OVlE4W001+IimRjW0NliYlvgVF0qgoc6FaVf7lskbsTY8L7qzGyRfFpbuP8VoxamfDpy6SGjs8UK1YXeOu3AQZ4MYKfsZMtqliTTJ1gE2FsM42VnXBPIQRwABxZ8YH+mdDxG6u+y3uxYHZ8Tc6KxcJhcZoyMEBNTYH8hA6hTp6WgOROgeGDII/0cEuw9K1G46R3g2aKaatjEDPlor0LaD06qiNTRQ4saV+hk5su7NNuu8R0S+zDQs9ydMCFHAR1HooQiAocZo3Zoh55dyVaKHm/wSpCS0VKFfWvi01CCkEpAtJTxwz6O9rwK3c2hv+JFaumVjeHDaQKHizhXbHsar+FTTl3NyF2/Np0otZUvl006nh7M/va0ZayhmS+V851HX71d1NwULxLoUti/yyMUSD/RsJNWTETQk3XPF9XO/bD08Uh11c3VpHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(6506007)(26005)(6512007)(478600001)(6486002)(6916009)(8676002)(4326008)(316002)(54906003)(66556008)(66476007)(66946007)(8936002)(86362001)(41300700001)(83380400001)(186003)(7416002)(2616005)(5660300002)(2906002)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EwYT5WVXIpk7fE1TzOhRsSplGvFEj3Bqhu8a9uynRAPvA//alEDrsWg2rkpS?=
 =?us-ascii?Q?E8kQ1eVy1+twEdSgXylASIEZ1exAPaoa/c7u9QSWG5N3553dv17T23NlgTV+?=
 =?us-ascii?Q?YRzcpFKzAwC4TpSbEeb0GPsgdBUSTo+u8/tS8cvkDaA6ZQHT3dLzg4gYDVtq?=
 =?us-ascii?Q?pkwAVpEAESqipJ+tA9ggGD6we3JG90IXdl2gYj3wMP3/okFnECDGNWRkakLG?=
 =?us-ascii?Q?ju9PeM5g4k4GXAnTP9WGcXwQ6kmcQEe/sGqGgnlW7HURVC6Bnf23+N9uyMwZ?=
 =?us-ascii?Q?lNoWfkoDdeKinGCzaqPL7oPORzrc/Ykbu6QK9TiTrRiIW6S8ieS4y0DNXagY?=
 =?us-ascii?Q?RX/4ovz7PcUg6WCwwgEzlFzbrGdk6DGpkAng2RXnhFqse3k3mG2aBWcnuVxV?=
 =?us-ascii?Q?rIXFmdkZ7ZIizbSAUsP1cgVwnkUywoar8X+eRL1Ux4ilOiaShWR2HN/ZfeUO?=
 =?us-ascii?Q?2hHkOVENfQmQdghMThpOL9KPTfInRWR9ZKwg83VuAF3JqvV2HVYqtPefWjY5?=
 =?us-ascii?Q?cY7GEfIuQenn8AwdQi8JeJSn5NwIhk+4JTreWOkUhVqjqSBRfxprItULEvT0?=
 =?us-ascii?Q?eHzDFF5i3g3lMcxhEyf6WnC2U6y88GQtuyqV6fMJQi5pYxOGk5rcZdvmFYLP?=
 =?us-ascii?Q?seY7TpqzP08OL72r2XbOcT0rzXAPiYsfKY+Tjb+aM5tAKZ8GFZx/jIi5lQsP?=
 =?us-ascii?Q?UHtQdY/HK4IgBm4n03F8bYJvXVzo2vdZT/OHnH5irNFbbm8HxqOxJDI0PgoH?=
 =?us-ascii?Q?7Bf6TKJWf76RwVngd3i8pRdg6tTwxRN/5LNJCARk5scYL4neUpCDc9u5aVEq?=
 =?us-ascii?Q?/7iCgLENkkm94dvK9sY0MiXz8/ds/R/DqJQR3JmY/Z99BzvjZ9xd2eEo7wyd?=
 =?us-ascii?Q?6qNwXPrqP/DbAMbaaaAfOFQEsOmqu8ju5qTQaMUSQjMsbEH2DbjTi5g2hBMK?=
 =?us-ascii?Q?bQhhLCdVMcsSMIB7RElJxN9ICqUR/aPD/LJ7KxEoxDpAS1Ce/Y9GSZdfF5+D?=
 =?us-ascii?Q?zqeHDUG8P6wfpVd08lYqsYKE1jXDcbyvnquYLCLbap4Al8unOt8XFp3PhpgS?=
 =?us-ascii?Q?wOwh9tW9tLeLszquBNdlFaUU3XYJxAX+KGsayCI4pfCBVDG298opTPOzbpJb?=
 =?us-ascii?Q?mB6ClCJ7f4Tgagp7nAu5EFAXprc9i1Z4k8iPtQ4iPcpJvU9Vy4U/J8SeVqz1?=
 =?us-ascii?Q?IO+hgduR6k3uDymWyJMYjOICtGOQfu+h4I5obQJpBUd9qgEViLt5AtN3cXUP?=
 =?us-ascii?Q?2avoj0786s9ZYJSamlbVTl1GLFEMjt6ud1A9DK7dIsndZ2PUkyFvsfJ1AATz?=
 =?us-ascii?Q?O7arfrYGUL0qSRXiBPlFDqI3lQTsHB76SRoS6ZE15jvjRBPyUD30KyJYApsg?=
 =?us-ascii?Q?tc29ciXWlCYt9zrzuVIWgeBoUB/WyC1qR+ZUNe5QDBv9k776HkDf+lmhsco/?=
 =?us-ascii?Q?RRxIkbHPIcrs7kT7S3oO6Or5TWkBXkQYzc1YLx1NodDIMIc6CbHFHe96VXNz?=
 =?us-ascii?Q?01gJBdJDEqA7mWvJ/SRNFHkhqBy2IPlHYVDPcCsUPtmeoudHc+kddPG6BoP9?=
 =?us-ascii?Q?Jdfos+9Am/VzCPZudNU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 818ee4e7-671f-467e-a6b7-08dad9ef3046
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 14:10:55.9349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZacJcErStBGC0Thoi/8KKPORkhYDWwQWJiIy3qdniqn2HS/FsbL1TFFasFmS2Mgm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5896
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 01:59:35PM +0000, Marc Zyngier wrote:
> On Thu, 08 Dec 2022 20:26:28 +0000,
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > This will replace irq_domain_check_msi_remap() in following patches.
> > 
> > The new API makes it more clear what "msi_remap" actually means from a
> > functional perspective instead of identifying an implementation specific
> > HW feature.
> > 
> > Secure MSI means that an irq_domain on the path from the initiating device
> 
> irq_domain is a SW construct, and you are trying to validate something
> that is HW property.

Sure, but the SW constructs model the HW functions, so yes this is
trying to say that the irq_domain is modeling HW that does this.

> "Secure" is also a terribly overloaded term that means very different
> things in non-x86 circles. 

Here it is being used as a software property - it is security safe to
allow device operation outside the kernel.

> When I read this, I see an ARM system with
> a device generating an MSI with the "secure" bit set as part of the
> transaction and identifying the memory access as being part of the
> "secure" domain.

Is that secure meaning "confidential" or some other ARM thing?

> > number that the initiating device is authorized to trigger. Secure MSI
> > must block devices from triggering interrupts they are not authorized to
> > trigger. Currently authorization means the MSI vector is one assigned to
> > the device.
> 
> What you are describing here is a *device isolation* property, and I'd
> rather we stay away from calling that "secure". If anything, I'd
> rather call everything else "broken".

Sure, so

msi_device_isolated_interrupts() 

And related ?

Jason
