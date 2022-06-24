Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC6055A11C
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 20:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiFXSuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 14:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiFXSuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 14:50:08 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D645981726;
        Fri, 24 Jun 2022 11:50:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0fdda7dsxF8/LiLZqiRX7WkKFqTPXIxPYL/h+Gz6sfJJ7LX2SriThWn32TqRThS98AOsnTzQMtf1h8R0PZjnQv/ubJKbEvyPjKgU+5Op5qrvDNBpoMM8YaxtJTZr/aJRYE3ivosDXGbwSrA477Kc8hJjXKmy5sLKsSmWX0iSouXWSuVHnR/kLZCNyrvuFAKTGITLzWLSBLvTiQfTcwYMyxiT2XNjJrg9SUXrPAxDob9BXbL3q1dBgItsnlvU/oIloNPs23G4yC0k8wBth01MXteNJzm/UZKgJc9Z4aSPHfBTJJGONXCMXHNEo+cBPPhfD9ftd9oFrqWguyglUWVGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ar1DrRnr5aeiOn2j+4hrITCimwBGG5AfntD5qrgD0EI=;
 b=ASqcODov9biOppaQ0oKy+lzLCjLeAruv4WIdr7E3OLcd8+SeQbVoPUNxJGVASYDj4PaLsPvNGGs1szAqGODkf2bI1TyNMJ+SCTmkEESlkxSUcc82zubjmLsymrUhKglfczChbmlWNp53VE4llRTPQOHKF7+Jwr1U4AzYK3teU569EVOMF9Mbdu93l3zie1L7hu1IVY7d4s9gv+D/eDmv9iSP0XtqkwUVgBQncKMoLxAjMDPvyXMQLDd42eJn0cXM7zGCvXksY7MtOdUoNd8B6QMZC0uxkj6dgdK253wTE5Inq5ey88ffNT7q5sbgdW6Gp+0BHcQSbvqiHuDUrEx/CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ar1DrRnr5aeiOn2j+4hrITCimwBGG5AfntD5qrgD0EI=;
 b=fjEOH9JzePDZ8d//QMbQh936tUMynTdCWvAxPFwsxVTa+jnJPC/t6V2+ndfDL/sdGdRaWJFKOQZxJcn0alkWeTfTdwNNssssMwca6ZKp/MySB467dNvtJ0T1ozexa9ccXhs/f235ehRqcNkD+sjR+/SRhPoFy+VR0Xk/ZTGyhbvUCEwm963L6Ea/IVC+60vDdtN2/5DWP8hnKUCjNdo5OPscSjwA7q0v6y46zZm3lmfCSCO4QUmORp8wOsW45KYG1tE1phbgpbjSVZKWy825+KbYC29X79FVqlRIzansKu0vbjXoaCSGvVCp4GpGQtZ6RFjEoHcGxHzfnsRARIpakg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4643.namprd12.prod.outlook.com (2603:10b6:a03:1ff::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 18:50:04 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 18:50:04 +0000
Date:   Fri, 24 Jun 2022 15:50:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        baolu.lu@linux.intel.com, iommu@lists.linux.dev
Subject: Re: [PATCH v3 1/2] vfio/type1: Simplify bus_type determination
Message-ID: <20220624185002.GZ4147@nvidia.com>
References: <194a12d3434d7b38f84fa96503c7664451c8c395.1656092606.git.robin.murphy@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <194a12d3434d7b38f84fa96503c7664451c8c395.1656092606.git.robin.murphy@arm.com>
X-ClientProxiedBy: BL1PR13CA0080.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6529ef71-134c-4626-10c9-08da561259a3
X-MS-TrafficTypeDiagnostic: BY5PR12MB4643:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ESGPGHSmF7rIgdAbMlyZINxOQnynQ63gVP16pNwnvjJVf3RIABPDqyULR5oLOo7fzaEv42ZBR4hM0EaEW8Bc1LjLvzqeI8Rx+jPDVmkE/uMI+S5a46jCGNdESd738ObcE4jgWTalhiXvyzneAWUazPaqwvPW8lNW90+/+w1S5ZUJN9y/kFsZpiV79s3reKC6ZkNXZz1MOUKi9E8g1ggEOOuaBEKtOP3ya1ze8QPCpd72kdUzPH2kPBrfcC8rNzGVv9MvRtNi0d1JRx0darRPiXmdQ9eeK4zBX20VyxSHMH4m+m1atDdkuRtXL060vIemLAfsXyIvcR0XM9DZTLD2d3a9rZPoHNpdxMqJ3UlDxD5iUxs6OvlbRJUOvbIh4ja+ekl4NasJLTD7WH6hbVfBMAZ1l4nPSHMDfg5JrbwAYdjbYUaDeKhITxXVnwZP6pOAniRxZXWvYM8SkEsXcyMTXczRN03X/blmbRPlBWtUiUJnJRUYCvwHzhKVNQruEjDrXN3KbnNI5rRiM6IgOS6UHKpOL5DUFgdwVY0Ba/2eTWl2yS32LLiUt1QF8DkXerh2i48h6rCskD4im2Gdgj/4Rwbjb6FbDajH56Wi0U03UO9mYQGvKD00dKciYp9k4GIkToU2QGfKe5wV+GmCkYO1UXZp3Rl8y68jdjKFvS7fztNNft5vWou/9rYzkwkVEl8MOGsu4uRvufKyYRb3lA3ooXgwbuCuVqlKrN3of3F9mslQBi3lXdajJTAiaLnPWBap
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(86362001)(478600001)(26005)(6486002)(8936002)(5660300002)(66476007)(66556008)(4326008)(66946007)(8676002)(1076003)(33656002)(2616005)(38100700002)(41300700001)(186003)(2906002)(36756003)(316002)(6506007)(6916009)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ms/0Ww/Kzaq27sO3JZ6QfMDVdoBmvi+3gcxgGXWNaRcaTsZxv97zMBq30NG1?=
 =?us-ascii?Q?Z6AnETlXFE/hVA+Z4MeBi2UdFoTw7Da0giqA50ACLZX5n6pnoEtW5JvXib0j?=
 =?us-ascii?Q?OWUeZw91f2vwvLN8UaHB2mqZ46c04JFEyHkI1/bHfu3ci/+gsWjaili8jAtB?=
 =?us-ascii?Q?J7TxlcfyEqccftE8i2/spOKQw+gp0UrZTJTRT5RKXj0oWPyyytkhNwkYzMzy?=
 =?us-ascii?Q?/gmMsbJO+wqZQqaIu0iSB0XBSnlp0HD/gA0qOyPYZwYPeVpWJAL/HGf7LVSu?=
 =?us-ascii?Q?IRg32j/nbjpnl5jph3ZEpYHR/iqFwaX4G6derpR+mN3zvWj0A+49XXq9OLT9?=
 =?us-ascii?Q?glob2Nt986SlJRTXZcB2Ym8+GJ1CRBxe+U51B3cBD8qX2/b1Q4Zd+y+Ltvot?=
 =?us-ascii?Q?twJHR3VDZJ7WeK/NTqXjnGNMC7lMfFSK3EeVBilGWLedDxqSR4MmhYjeiVD6?=
 =?us-ascii?Q?UQbJL4uUYu+rfyErJFIVUPVaqnOIBlr4kPIn2ZFgDkYBFmJoGQreEBj2L5Pz?=
 =?us-ascii?Q?MKBbzuQIvdQRif2bjSM2zD0oq6ViEADscYV1t7GFp/0rlbORuFzWpqxkZ1vT?=
 =?us-ascii?Q?VCOjFDpt4bU8P8j7f/RFyS0Cub/Fve7AT4hj/LOYEFymA/GldgHTiiYze0kb?=
 =?us-ascii?Q?pI3lG8kQgDjvoRjJbAuLbCnRQnwD7UvXfE23sDVVAdYiZvx3rZmRETqtaB0I?=
 =?us-ascii?Q?rHxBVAaXlsG1nCnv8owfZpjPMK1hRLqkTdPFnmuH6HQXafF/RFodVL9TpdBh?=
 =?us-ascii?Q?yi98Utkb2zgOCGuh2rxk0LXja5SR5L/MNf437ELaKP6f8R4RHE59F3m1WrMk?=
 =?us-ascii?Q?pvmKvGhaX+Zg4tU8zTmXT4oZ0tjVQ2fQb372hSdEETh4HJpOHaQVWcau+hw+?=
 =?us-ascii?Q?g0AfD//T7kRP7h0fZ9PaDh3VGxf9a/co/plL+bQcqN0u28gXLhhYWiNiSxoQ?=
 =?us-ascii?Q?30BNhpwjE2frwkgjKPMX546pBGz0uFCA6pCNuuDZHgezXjCD0/FWhjNJS4Z0?=
 =?us-ascii?Q?DTna3taANBWWAHV7TyGGFc//+Yew3XCNKb8eOHqNV/irnyoMumSWixv0jT1Q?=
 =?us-ascii?Q?UuPdEUqcj7PcgV0YgR2vo+aEBcO4wbWAniuclxVtSe/JhMHapqNz7RYfNBB0?=
 =?us-ascii?Q?f+2SlJvlTyrGPF/bFoWiM1c9QDpPhRQykJByhUUAIDR7U48IBapBSspmDIU5?=
 =?us-ascii?Q?K1qb4qzE4HJnY6xEt7gUj2haWAMuAiJItwhKQzFffwLLW2nXftSHFIk9d4nM?=
 =?us-ascii?Q?wevlRT4XCsznDgFFLtT6j2vJTW8bZ3DDdULFtFLUP3nV9yj5syPyjLBvS2hH?=
 =?us-ascii?Q?SPHVrI7k9M51nUXrLRvos6BVlYW/QGOzC2dMcC/WGBmv91/QkE8lqCVxMd/A?=
 =?us-ascii?Q?h0/8quhe/k9GYq9QkAVuh+04vywmBYFZS9HioFBOlCnwYOD2LfJHowapBzEb?=
 =?us-ascii?Q?vXP4E3im6xVez4fatVP7cPoE9uBp+mK3juriP/saO5j+SvTUB1d0J2URsgdO?=
 =?us-ascii?Q?GlbC4fTrx0K5WU+l7tubk92djxeV9TCSqL0M/EDKifCmaRlZq67aLAXhMiAR?=
 =?us-ascii?Q?/0dDwRbuznvKra8gw/2/Rd1LuLsjE9iwcOJhAll8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6529ef71-134c-4626-10c9-08da561259a3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 18:50:04.0542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRCnITn5t/QTD8EOAFVfS/4f5N+/FDgnVrBQYxo6uXFHYOGyFceXfA0+dNclsjQZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4643
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 06:51:44PM +0100, Robin Murphy wrote:
> Since IOMMU groups are mandatory for drivers to support, it stands to
> reason that any device which has been successfully added to a group
> must be on a bus supported by that IOMMU driver, and therefore a domain
> viable for any device in the group must be viable for all devices in
> the group. This already has to be the case for the IOMMU API's internal
> default domain, for instance. Thus even if the group contains devices on
> different buses, that can only mean that the IOMMU driver actually
> supports such an odd topology, and so without loss of generality we can
> expect the bus type of any device in a group to be suitable for IOMMU
> API calls.
> 
> Furthermore, scrutiny reveals a lack of protection for the bus being
> removed while vfio_iommu_type1_attach_group() is using it; the reference
> that VFIO holds on the iommu_group ensures that data remains valid, but
> does not prevent the group's membership changing underfoot.
> 
> We can address both concerns by recycling vfio_bus_type() into some
> superficially similar logic to indirect the IOMMU API calls themselves.
> Each call is thus protected from races by the IOMMU group's own locking,
> and we no longer need to hold group-derived pointers beyond that scope.
> It also gives us an easy path for the IOMMU API's migration of bus-based
> interfaces to device-based, of which we can already take the first step
> with device_iommu_capable(). As with domains, any capability must in
> practice be consistent for devices in a given group - and after all it's
> still the same capability which was expected to be consistent across an
> entire bus! - so there's no need for any complicated validation.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
> 
> v3: Complete rewrite yet again, and finally it doesn't feel like we're
> stretching any abstraction boundaries the wrong way, and the diffstat
> looks right too. I did think about embedding IOMMU_CAP_INTR_REMAP
> directly in the callback, but decided I like the consistency of minimal
> generic wrappers. And yes, if the capability isn't supported then it
> does end up getting tested for the whole group, but meh, it's harmless.

I think this is really weird, but it works and isn't worth debating
further, so OK:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
