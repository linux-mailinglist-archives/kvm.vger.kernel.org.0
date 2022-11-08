Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6965A621D6E
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 21:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiKHUKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 15:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKHUKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 15:10:08 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2043.outbound.protection.outlook.com [40.107.102.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C8D627D2;
        Tue,  8 Nov 2022 12:10:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jho/7VtDqMSV7yxyjLNOz5epoZbKeHBcQOAl7Tsgt3UUgEJXK8YTestaeAGogNJWnBP3mj8UqBnQitoTjas9RshghxAoUVikkibobBtcIJQVJLJgCsxpvuqQd8NgDvqYCWsAEWVorys7LQrd5mZGepGiwQqUHEbYZoh/EdIwqp7BmwSCoSKZgmaCUJwad/PkFsu5XJWzIQxh1C/9DTIq198S9dceA/1uPO/oJ99qavb4EbLvYQDjQlqYPIN366xPrgcYoDf5p22k9Ht+Wb3ahaxnGbff1dtbzlbmOxUXmyzcxq5fljFsu/WqCRRa3LgznHhIfQ7QznQH3CSNw7/N+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFbZ0QSx20aGRgRzr9CeIZAqYx0LaFrPXTLfsR4pkpQ=;
 b=ReSrzfea4gqQyvPGxkja+Icfvv3gaha1Yp5kPm8EVKRIFVA/eCrmF/uA9/+UCVg+fvvxJBa97tx1kVd8IDKpUn5SSrlf0DAu6xVIyZoXSlSmUXAJ1ssWmSH0d/VwT4c/s3i2WmMxd1cw/tWmiQFtJOerG82wPyF90hQqPBIadEF73m2MA0W5hnPRgsZ+jLWSVmdGs4s28RZCQ3ng2g6L1sAWPzyLoGBi9OgZMkxUmsMMQAoMaRVXA0Eyp12coxYqab3T7DjprKCKMusJKrEtezbtOfR0nwzo7G0oZUjgOoVKaKYWNHBNhnI+HsQhc3T5a5CJB7il0/F3ilkTQtaT7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFbZ0QSx20aGRgRzr9CeIZAqYx0LaFrPXTLfsR4pkpQ=;
 b=EyrmZ4GH8ZD+4LM/Ue+bbgO6iDVBdvIw68VfL8N/I+QL9ry2t243QMyzWKVVWVjW4ues3Yl0tHsFcCFF6i1jDx94+Dm5sFukAfROuRVUjgnSsZMH9odmPFbKiLUXpjVEXnflKmmMiO7T5oa1tuSYZVC73GrLPJjq4IYwEzfEBI6KScOZo99wy+JoOP/CFst9eLlyGozsaZrptXr5FguoqI141zpkgm+16JwfECgul8Xx8Ze6oAmujQgg5c7tgRRU2548bqG0omCJ5fem4QtOAzFmGG7kXvKpSi+3OFqPfCQ5SinDRVMDpWkjjbFlOnpyJD3hyiyIlkmamSgrT+oKIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB6828.namprd12.prod.outlook.com (2603:10b6:303:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 20:10:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 20:10:05 +0000
Date:   Tue, 8 Nov 2022 16:10:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: S390 testing for IOMMUFD
Message-ID: <Y2q3nFXwOk9jul5u@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
 <Y2pffsdWwnfjrTbv@nvidia.com>
 <67dafaf27cc029ffde1f7c474c2fd17907958d5a.camel@linux.ibm.com>
 <Y2ppq9oeKZzk5F6h@nvidia.com>
 <ce7bfc8b7efccf0fc35f89d3c79992dfba511b3a.camel@linux.ibm.com>
 <Y2qvYJRsv+mO8FSM@nvidia.com>
 <fbaa1f1d0510d51045120d896ac8b4aa01dd333f.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbaa1f1d0510d51045120d896ac8b4aa01dd333f.camel@linux.ibm.com>
X-ClientProxiedBy: BLAPR03CA0121.namprd03.prod.outlook.com
 (2603:10b6:208:32e::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB6828:EE_
X-MS-Office365-Filtering-Correlation-Id: ba293edd-3742-4e41-5886-08dac1c53a15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8jV7oXWbctVWNnmjU9CUH9ezc+SUaClAbI0+gghwMUgq55wPx0iuZIvDfgfFnq3OsF7Hu5bIX1ttVJC4fnLPylCGImpoxmXop2Iq9YLDt4x/tlDP9BlFX7tnZ18JnNVFwPA3rTaJjOEEjoubwapRMLvb7qoiyQOKw509FLSTgmBLzcSAie1W71LPUvl7HTa1ekBHeKNw7YYizDPlTno6EuxN8ddop68/yOEkVAZUZ+9rNaQjf9nmz1wPQmIkb2ftMpPN10kjJUOgilgqMUJKmi4tognyXTwNLWBQ/FOGPYNL7AdF/cybChDd8qkXD9WprqsB6Gwmde6Dz7kf5s127zwf95dQNaGO9MjIZ28dMnMBE/QBOyCWJXk2iAuUtD8UHaut9qqyDLzH9dzUZYrp2fuZrwcwhvdHmrTZEMSUL6uUqjZ2ygQh4oId1pLtjSY2qkBiMBUsf1hZlYZ631quGTgAbh9mI9xSPneZsHzFI+ub6n6H9XQondnUTfs+orCr1ky8wwHiCMTKE0xq4Lra1h/TtSAKVBjuqtGjGGK+bP556eLpMw5uL55tjbZ6wkmKUozkgdq+Ei5iL/WGYCL+Q8E3ixqwFcwWpSs5MAxyJ531sHIhBwbCYkqnolbKKi7jnbxxUALml0zeoEyW5qR30R7OJWLTGlUPbjBKngLcgL8XHWK97k9Q/o4bJWNjl5QGBuB9uLUbrpVoChHR81CiDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199015)(4744005)(8676002)(66556008)(4326008)(316002)(54906003)(66946007)(66476007)(6916009)(2906002)(5660300002)(7416002)(6486002)(38100700002)(107886003)(6506007)(8936002)(86362001)(186003)(6512007)(83380400001)(26005)(478600001)(2616005)(41300700001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SwXBL1FrTtdmpQBSbJIuAakfsILMSbepm4S05UQnWbMI+89YNZgWbSCBi8a6?=
 =?us-ascii?Q?t81m4BFN9wcKbjNySQSAxCyIMfb3OaeuvVQcckSyJfpoiMRGMO3iZ1EjJvZ4?=
 =?us-ascii?Q?+tPpHy91R1lXe4cwyXYqDLQtvTzQ9FHKsjpCHDUoyVK7HEWB4b96hWqmh6+1?=
 =?us-ascii?Q?2Di9K/TOe6UqCTbrmPRKVJZ+KeFn6BSQ8l2pUB0wSLVpcbec1HOVX3AWHGxf?=
 =?us-ascii?Q?mP7wx/sDbKqzb9wjnV5032DdUNR3z4Ff2Xwv/ZMzWqErK4YuE2Iy7t8N1p9O?=
 =?us-ascii?Q?m1IdM2CGoug/VwR5Yf206ZPTINLWxaHbp3Ui+5ULhDS2GlIKrUYPmVPoG7ZF?=
 =?us-ascii?Q?ppDaPgjp+rz90Xpoa9r6QnsCKwGCx+DAspZ6RQsr6EnLoieecUnxOnMCpSso?=
 =?us-ascii?Q?RPzY6LaZMRoiE9NMbAq38WoBvM1gXlvPI7qvvIgKEjBqEw3klcUJnI9otsI/?=
 =?us-ascii?Q?5MnliD/QO+ehmZ7xeL6hff3AjB9nDK1iJHrU4q52VmeufqJDzxbCZ3+ouH6w?=
 =?us-ascii?Q?aG1zE9ImcKf+y3vuuIfwTbiL1MNDLXgSEqsVaCb9WcrjZapBKCU3nlUDMWXg?=
 =?us-ascii?Q?SIhTA9fYmUJlHi6VE8XTksLQ1L1Uuk55tVE4MNb1SKrjYUq56nvPVFRC/OHZ?=
 =?us-ascii?Q?Soi5bZ18eufZgsSg51+y4ceyJzHz1RYo7nJNFeZxadPDER4Sr5vmcWGQtdvx?=
 =?us-ascii?Q?Mxj2XbuhOKDTwyHxnrjSykY+BBUN0axJNZmUR1zWKkeaGAHwmdBZ1vZ+v/wv?=
 =?us-ascii?Q?9G42uU8VqV8915cIBN3Ct5MjcfZVIv9iiydZ3RJ8e/sAPlmvKutFRrTqbZJl?=
 =?us-ascii?Q?vU19FE5E+0W3SuB9/hci3XKj8xvidZSXbbmz/soOyPC/2Gw6Bv7egHnYHboa?=
 =?us-ascii?Q?d08+btjP3vM6V+RcTWj1KH9TrCjyAAaKU7lzlN1FbFIOREPQTvzz/0HfhayD?=
 =?us-ascii?Q?YK0dXmYIHhlKA3GGyaGyyzJSMRFsqsL24o+HNZaIvNNFJaQPeX6KsRpTlBTI?=
 =?us-ascii?Q?QojoZm9MQzRVnUlgV5ljDH+yquA7gNeXGGOrTf59rVRfFF4TjyB+dM/b7UVQ?=
 =?us-ascii?Q?SUCbg0MORxMbuxezQT1ItZCas1iBK+vttFQHs+sUAAG6HKFzH4O5tUo1r42b?=
 =?us-ascii?Q?FYRifr+3pm3fo4BeU4zTdwAvkAOnSDGrokzGkiUTjzmCAB79Wj6SWJTf9Ocp?=
 =?us-ascii?Q?bKe8b/mncte+w8bMs3UifYLeGZhgZHHeKYiCBdaLYBjEZ54/mTkpJs33sxXa?=
 =?us-ascii?Q?hQ7rE6y+F4SbHO68Pdd7wKzziCYHi2Pa2uqjEVUWj/BMlSwpWfjqZhGVqJ2n?=
 =?us-ascii?Q?laGH7RQNF3gasYmjGrqP+nU9cJ2O5j55axqiaZGtzfPIvChiMII2nHJe3gTW?=
 =?us-ascii?Q?OQL6anTchWsNmxHYHNiHnJEMlrJ9t/9ZzKbva28RhO1+QyBil/yI3tU6dave?=
 =?us-ascii?Q?C1ELsBluiXSUD5jjp7wrJi7p7L7t1UXOt0fiJDRHUvuJSzdT/+5ANqG2Wh4w?=
 =?us-ascii?Q?21hUxdWmTjNVFdAn9pmONyiOUUvV8eD/8CR28JOv5leoBHdwQfeMLg6+9sBv?=
 =?us-ascii?Q?06vDFsuHY3G8+noZ+8I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba293edd-3742-4e41-5886-08dac1c53a15
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 20:10:05.4479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QAFYBrYi3kUymkeV2T0IeV1+8ZjUEUcUfFvD/xK2qO8Jjj8NlboC3FZ6134Xu7bz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6828
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 03:07:19PM -0500, Eric Farman wrote:
> Patch 2 doesn't address the above symptoms, but a lot of that code is
> getting reworked by the aforementioned series so I didn't spend a lot
> of time studying your suggestion. And as I type this I see you just
> sent a new patch, let me go try that...

Patch2 is following the assumption the WARN_ON is triggered by a
failure path that isn't work right. Eg trying to unpin a 0 IOVA
because the failure flow is wrong. Removing all the calls to unpin on
failure paths make that impossible.

Jason
