Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49F5493B42
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 14:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354855AbiASNmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 08:42:35 -0500
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:50911
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234312AbiASNme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 08:42:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4+FO7mZn5M7LDqotLo1I4k5ZX/BO9Kjvcn+P3p06A3J0JRy8RV3cNJ4ASxbGAyi8NihQCuRmczZmU/CYpFSJH/S605PGaGQ29VMqqLIFNfiBdwCcyTJm7E5QsDjwGhzdrw3FETLZHzA1V8lKDJufiFSOE4X6IXPfAt1s9kci0ll5d6BuCSxdoXH2Wu+LMuY1yzRnpTLEYOOtaKoB3g9ntgH0gU75O9PvhiNC74ch92HoH12E3y9JRaHEeOVw+rM0/vkpnZ64A78IZ7APCx37jZFYzhyovfs6JgUflluX5ssj6hIAAtuC6+QzNVOREk8mO5WyPBnXThyMKKJbg1ycg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jtffe/ld4Cm1Yo5vxqBQoMvDYfheTFpXgHdqsdBtSX8=;
 b=BZCnCcdSbQyyyE4T1qiWqsG3RJj3Tt2dQiesQR0qcw9upyvLuDi201/1b7h5B9Yq2QVd5fV2OapZJyL2Epl9OijizCN6fCuWEMyGclNdlirbcfFFj6TlMrwmlXLAGhys2cG0d1B4eLFWCxPRzCnXJUhkJfIDDT5neCDh1QdiyrotDGGPSgDMhpGCcgg3CDKiselyWF3CdvNedL8aht77RmdiyKrhswRdO3nvlF0nZHeZ6p0EgWIN23xlupxJim2PfuQ8eY71FpfCDmlWKK1DabN6xwV3qc34dKjUIDYtK8M6QiPsGYsSDvVXA0vt8kGcyG16DfMkjYnUpIXEHS+W1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtffe/ld4Cm1Yo5vxqBQoMvDYfheTFpXgHdqsdBtSX8=;
 b=lmlxr2PeAnn5crf1bLDEcNnunQNq+Z3ICA4kZyJJzT1vGfCtxTiFUkq3sYeEtsXrRUMWIFvj8zN/+u2xDuguCi6/FpiQYMxHu2tFJVQ/rS8YxJKkrCjs7MA/wNAtsQHyAlhgAicx1d0FHbOrcw8GuU2L1G+LdWGVgLcIMMsKAH503CGhsQeZVY8xpDdCR+E3tlp7F8vGOdrJqEyuQzxCoA2wFGmKHTvK2iiX6CFew6fESkurbbi5TltWufpkB24vhLxNRCTFzzLdD1zUtIs7e56WYInHJUCATkCu9Zc+MtF+zuVpRx3wQ4UAGdo8/5FCtN1JAydsbc7F4OnbuUT1yQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB2468.namprd12.prod.outlook.com (2603:10b6:207:44::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 19 Jan
 2022 13:42:33 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%8]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 13:42:32 +0000
Date:   Wed, 19 Jan 2022 09:42:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220119134230.GM84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
 <20220118210048.GG84788@nvidia.com>
 <87sftkc5s4.fsf@redhat.com>
 <20220119124432.GJ84788@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119124432.GJ84788@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0433.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::18) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc1cd65e-8b51-4563-8483-08d9db518b3d
X-MS-TrafficTypeDiagnostic: BL0PR12MB2468:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB24689DEE78D8F0BA7B87F8FEC2599@BL0PR12MB2468.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JgkipX42DC54axZbZMmau7Vpx5Kk2bPgkHZh4NaGAqtyIdpSEs+3QqksDhsscD5QH343EJ8URPOjNQQnu/m+Gy9R6tRU8+0FOWbdeukOhd1+KIuPiVeP4Bdb9zW73wvwfbsS35JHGOcROM6J7SCneqCRWwX9EolhMc0fAgKV7c47EAzLu4ksrSP9O43JmQeF8h/qhzo2zrXHcWne4is5i++eXNnw5AqROy8pzxf+3QivhRGHZDsApg6WMq7o4zUnb8slSA7cprHMbYvOKA1Winz3vPsDA4V4Uq7ao2C6qSnUrqxsaACcqkmQreORDnLQVzk8KEwx2GQhlvdG3vkinkk1MhjaEiIf0uEKofgPcaC9A2+mJNcEqOkZr8inTH6u0hRZYrVjLIuJvdKVveqZdyEMDCh8TxOV6tqg+3SSIIyADl5/6/iDgsTOs0WZbJdI8/+WELLhQulCx4/vt5hAYoEt/PL4rx/Yvd9TzSfBFIKuFIk4wSPCEcUzVhCMBexazfGrwGvk8r1fu7ZtR6o3HsXr/AI4w7zOb6s5UaMgnXBjZnD0EPG171bgr6IZiQgxVIwGGonVYEM7BNmye4/H6BsqyR6g7GA50uyVSTW7DDEHqp+oKFqQYjciHfzPiWrYI2R0g4e5qL+wBvokikveJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(33656002)(2616005)(1076003)(6512007)(38100700002)(66476007)(66556008)(66946007)(6506007)(5660300002)(107886003)(4326008)(186003)(54906003)(36756003)(316002)(83380400001)(6916009)(508600001)(8936002)(6486002)(86362001)(2906002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RWq9NXgbHsfBoit+YMJgumHXFlbU9WvQlc4H01XFki9a5SQu+/bjvM47Qj/c?=
 =?us-ascii?Q?+e49BCzsbCylwlE452rlsiS1rVXPMZ/p6mcQamE3HgNICb8ylXOI0mUvqLH2?=
 =?us-ascii?Q?kX7Sfi4f1v9LRCWmvVdiMxcvc2eyJcE5pmxRSOk4Dfe8YZhkEdYgLd1BtG1z?=
 =?us-ascii?Q?KHLQeloS50/ciBQStGUZ6ReO8PLNkWMHLZUHopJZIwhfjQPfHlkScoJfJuwF?=
 =?us-ascii?Q?O2IPUfmExYyGeXJ/5Zi6vOxN1awsCz30QNEA+dpr2ZT39J5GUG2Jmx0vM31t?=
 =?us-ascii?Q?hc6l4zlLUQjO7cardxO7TaPfJTkuFW4TIkg/oZltRsHJqRmAgtF6SANXbx7Q?=
 =?us-ascii?Q?gT2MxnV6iH2SH3L2Ha93BLMRMyL2m+eWsAUksFhr68BZPi0APh4jHWp0vdJG?=
 =?us-ascii?Q?1x/3TDyN4fTQHmpI/bi/lntYgCeOP70J8wqM4j3DQIzgXyrxBuN2cczYmEg/?=
 =?us-ascii?Q?bmyNdIebSMqeNdYMkcvg/SBsJEQ6A48T9VDO1At/l1P7IrmsUIaU2GHCoQkG?=
 =?us-ascii?Q?AZQWipcOdMnbpJS6TRW1uAwlVZmycvQ4CzGl6beUDTdlGdHkPXi/ShvPVhRQ?=
 =?us-ascii?Q?4LAXdG1Pel/2SgNnyCBUmLk+LEewK96W7pJLUEJ7PECvqKUWmwCmhimW6Njm?=
 =?us-ascii?Q?UI9J2nMuUxX8xmW+k5XPTkapedPCBFok/nhd++gX6U7sRhsI8+1Cdx2uG9tS?=
 =?us-ascii?Q?Ror8SxF7dEfQou56AEM2kabHzJGfsskf1PTVrzyc9Ohjp/0wJisnJ3JZ/yh7?=
 =?us-ascii?Q?PUJql7faSiLUq0B7bPAbsS+UQmr9F6c5WEXPSe11RgabjsmSQ+U4vz1PT+Su?=
 =?us-ascii?Q?UZYnkjKq7O/f6etZ2UoOF9ulwCaD81K77zpYR18VzRf+dt6qfHLIx2EJLQ6x?=
 =?us-ascii?Q?5Ki4G/G4VG1Zd1Oi2v5ifRMOOCjS9i3aRLgCT4Nc8kGzAfmCe3lWRH6zSyre?=
 =?us-ascii?Q?md7FTddGmDBYFeEWt28Pq9nxNgthnQrvt4NL7qMP9K1oERVS0NGQn5m+Lhvs?=
 =?us-ascii?Q?VQE+aDiueSyRHtf6vw4bfAONsl2vaV9OfQBQA6JaqsoGpxlQbLbv0TBoul1L?=
 =?us-ascii?Q?u7nMBpQgSCEAcSrrnvFCH0QVbQoLu7kh7TlXqwrfVFvjUeLi0YS8GCngHUe8?=
 =?us-ascii?Q?0pjoEPmlX8/v807R2JCIqqA/yGKI3up97Z7pZ2k+D5K9nX8tqSSPn0YrNsu1?=
 =?us-ascii?Q?VQJBD4CUVIUETrYv0nbTg6vi1v9uNz9+NrJqvOlVA5ej9E+/f6Fb+AS8JEdG?=
 =?us-ascii?Q?cZaYulYJrbyQfsltPxSgxEOGyfEpSevYkh+UX1yjTYeTJD9XkK3caTcDQQYm?=
 =?us-ascii?Q?iucdYyWSK9S7JBnvBjUT246uGohLNr9lxBX/qVISFeQlbxoxyY39amkbfx0T?=
 =?us-ascii?Q?Ls1PWt+e3s6PIq9OvfDjsmRc5QdSVJUn/q8PvkZWmXXnNeU8Gc9aO31C8ReO?=
 =?us-ascii?Q?XV66DvKNKYmpDFYP+THf12K2/hWYJmueQXTD8MCGeNjTEkZO7kMKc7cFK2X3?=
 =?us-ascii?Q?KtsLDuI/DBZFYAqQ17MkO3mA67HYjNzc7TwDybgGwgJC/Vbb8HgZzo6DvhBR?=
 =?us-ascii?Q?jYXduJc4lK1j/2sKLg0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1cd65e-8b51-4563-8483-08d9db518b3d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 13:42:32.6096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lVSYWgSsBj7ItRTJPW1zgpzp26l0wDPQQ1RARDbaMh19Mw1R2hvMGWozg3b2zJzT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2468
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022 at 08:44:32AM -0400, Jason Gunthorpe wrote:

> > What about leaving the existing migration region alone (in order to not
> > break whatever exists out there) and add a v2 migration region that
> > defines a base specification (the mandatory part that everyone must
> > support) and a capability mechanism to allow for extensions like
> > P2P?

Actually, I misunderstood your remark, I think.

The ARC_SUPPORTED *is* the capability mechanism you are asking for. 

It is naturally defined in terms of the thing we are querying instead
of being an 'capability bit'.

It would be reasonable to define bundles of arcs, eg if any of these
are supported then all of them must be supported:

        PRE_COPY -> RUNNING
        PRE_COPY -> STOP_COPY
        RESUMING -> STOP
        RUNNING -> PRE_COPY
        RUNNING -> STOP
        STOP -> RESUMING
        STOP -> RUNNING
        STOP -> STOP_COPY
        STOP_COPY -> STOP

(And since we already defined this as mandatory already, it must
succeed)

And similar for P2P, if any are supported all must be supported

        PRE_COPY -> PRE_COPY_P2P
        PRE_COPY_P2P -> PRE_COPY
        PRE_COPY_P2P -> RUNNING_P2P
        PRE_COPY_P2P -> STOP_COPY
        RUNNING -> RUNNING_P2P
        RUNNING_P2P -> PRE_COPY_P2P
        RUNNING_P2P -> RUNNING
        RUNNING_P2P -> STOP
        STOP -> RUNNING_P2P

        [Plus the frst group]

This is pretty much the intention anyhow, even if it is was not
fully written down.

Which means that qemu needs to do one ARC_SUPPORTED call to determine
if it should use the P2P arcs or not.

We also have the possible STOP_COPY -> PRE_COPY scenario Alex thought
about which fits nicely here as well.

I can't see a good reason to use capability flags to represent the
same thing, that is less precise and a bit more obfuscated, IMHO. But
it doesn't really matter either way - it expresses the same idea. We
used a cap flag in the prior attempt for NDMA already, it isn't a big
change.

Please lets just pick the colour of this bike shed and move on.

Thanks,
Jason
