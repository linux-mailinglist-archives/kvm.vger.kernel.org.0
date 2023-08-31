Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EAA78F16E
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 18:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242667AbjHaQnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 12:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjHaQnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 12:43:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1569C122;
        Thu, 31 Aug 2023 09:43:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dvi7csskcv+cX3WuCB8nOeNr085DNTxi4+hbmVMd7kd0e2y/KKEd027DpqmV/nCWwlQ9Fj1+PQLIGZQ9E5X2mD76AePrPikPNHTPK6yxm6ZUr0NsU2GemVV2xFR8maYb6snLfj4vms33F6CwLGJE77PTou4rkGtejUNIV6fLtKUkx+pQw9cy/WBobkv8KtjAHXnFYA0EuT/8yI09XqPa9ERv7Tv0bZ3TPsH+kZA/w2/Z/Xymwp4g5PoSAosOynRImU03cNu3UeZtZzYkmwW/YVIgqBCIllyZuxjWXae15NrrW3I+tQzwkMw+G3tTesLaQ6l+0muMkrCMHP6Orpz7fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmHDeyh3t69VVvLg7C2u+2Gxgg8W2Aqgn9WKGWus4NE=;
 b=ZSMoiOMdj9tgn6jLImcJuiySgOkz7W+OOseLBNwuEzAc5i7MRVDAhpSREKVkjvQ/YkJOQEuhF0qjHvOl0pcmU+179NTbtVCkSPuOhiYPz14xBLqvvoS+yjmR4LTFJ/41JBwNPrOYeUKI7UcWrkSFF6AXWApm7k5ktenaE0RNZEkdJ7aMGTh4psaUQ181HO1l1e107+f9biw225kfH/XniX/whI8WTKslzwp/bmKYwmZVcQOi3FRiBMB3lHYmZb0k3N6cE4vB5rfndYXHDvv19wdkF+bMuNoMx1tEoWs+c9PGC6HaFJg/ybu6cXPBN20bJL0AxxQP0W4nzwZF2A2Z4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmHDeyh3t69VVvLg7C2u+2Gxgg8W2Aqgn9WKGWus4NE=;
 b=sZEB04JUzmoLXVFMdSktm5qnSSGajOTuBvtxoKIkK1iQXSBtR1sfzLlTuI30Dvf36CL+jYrykxsGJuHGBOEDq3hgpSnj8nPohK23j5dpaSid68+lUWw4kfPDchUyxefV8MeHYPkXgk7gedNK6dtRXB//s+VcjAUnpYrLj1ZELS8TVdKGyF/4ovXsNx9bT39GDsyxiUjKNDQ6YuHCRCHn1bCEN29KteEEYhjj39QPIOMtUiMFQk7KMn40GBIVawDVHKiq513cFs0UoS38QgdtQVReppzxTjRx4pxvzDoesECd2Gz2e40XYafpAoarHPUzQXOPRj2DKdjrW3xnQ7tBkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB7847.namprd12.prod.outlook.com (2603:10b6:a03:4d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.20; Thu, 31 Aug
 2023 16:43:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6745.020; Thu, 31 Aug 2023
 16:43:13 +0000
Date:   Thu, 31 Aug 2023 13:43:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <ZPDDHhOyE95IqClU@nvidia.com>
References: <ZO/Te6LU1ENf58ZW@nvidia.com>
 <CAHk-=wg_L-97_06_ruO7xL7vxX4QpaqGQKw-6LtKAR_CB1cyYw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg_L-97_06_ruO7xL7vxX4QpaqGQKw-6LtKAR_CB1cyYw@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB7847:EE_
X-MS-Office365-Filtering-Correlation-Id: 840e6f14-f98e-431c-d929-08dbaa415e02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8xOq6o2a6d8/Cj6q5eaPj2ULY2h6hJYJhIK4LETq63oTJthVicZyEiMarHQ4Z8hHt1f2KXzxhEINoDb3HWY1Wefcjoa5QNuyxOfOAdRumfG8vxem6jbpqc27SHDFU1NNqhE3YyEGHTywlOzY1gl0XM9HTLTUGDbChmcK+lK0ra51Iigwf4/jf0nZnJ1tNJqX30mQo6NnqTQYOqwe4BCGsp7acmg2VBmKeRAaFvuHPtnlJMe+RBqBiULcloSzVQ6ScrUyW2+ClM3DHSaU3DPqzJzcZSiICfR1XcKlsK7BgVfbvApwK7gSICJdEjRgI54qmVsX4jQUS1z+tvbAv1/6bm4VGnTTfJlmPvYtHJ55qulJaD6PHWTyckL2B5+lWRaugWKofqOiVSYXPn0hn6FPoGjZC/L/ko/4HTZ8/kQG98HvmjjNL+iR4L1FgM/Orc0GSN2eGLE7Lrrwmov/mXWsYxRowFnr/53HZVHpDPtxikgc+aCW/copPFc/JZfsonpsJMbTGBLYoBNCMTGTATBcX+8dUvw/k1PZDxjuR7SrVmAEvVKvGcnh7mEZKR7TCBWq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(136003)(376002)(1800799009)(451199024)(186009)(2906002)(66556008)(316002)(66476007)(66946007)(6916009)(478600001)(38100700002)(86362001)(8936002)(8676002)(5660300002)(41300700001)(4326008)(83380400001)(6512007)(2616005)(6506007)(6486002)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GM+4yBMVCJPhHUehKPtgzJ62MgEicUAy/GJbtrSQPESDQpW2TiUglXu1Xd60?=
 =?us-ascii?Q?I3ZoPWMJksipkgusjlK9yWNIOFbvv0IsBHfYuUs/wrlcqqnsal0bXw+xdoFZ?=
 =?us-ascii?Q?yV6GJJ1mCjL92RbgjPP2SUJGYpqwAlx4SFDXeGjU2VLgoiGiySJv0Qe8aEri?=
 =?us-ascii?Q?NuzQy5ZwANUCGvFsK9+0kmSV8E0ASpFZgNTf/JhU7SDLvNOPn+1yIyVZ5CZs?=
 =?us-ascii?Q?rTFTXgMxjN4QsuEbWkIw4AqPgiVvhI8sim4kDM6XnO99kA8c5MKlRtXmLNAe?=
 =?us-ascii?Q?IKWj/ZjljMf8RghPUikIbmIAkrU4aCSuWPGnA/qKUIvWF/q40Zz0M9NGd1jH?=
 =?us-ascii?Q?hLhYH87fbXfJipvt2oqohUG88TL5tuXH3tO6maKRYy1BmlFVzT2AYMEwnXoQ?=
 =?us-ascii?Q?9QPDp17Qb00K1wUvPpCxdy+vy0sfau58caa4ySHizqeEmH56PeTgigC7Sx/X?=
 =?us-ascii?Q?rJ1DBZeJgeEhybs3VIwGQUMxHpQ6ZRAGJjobsSV4FOWhABmAmJd0cVZmUe/v?=
 =?us-ascii?Q?AI8MAq6a2ePKcPYW1lh1dP8FoX9Uzcv5yat4tRoDjrjvta1oY9EcnQSVP/u0?=
 =?us-ascii?Q?JU3Q+YT2nPlAZJtnBqUw+HcX72Qk38XSVRa60H3DwCp2j831/Z0gwSfpvbiz?=
 =?us-ascii?Q?/CzZzKHWLLs5V3V6oh+sSYu3chOba0Te2IF0I5DhCvclxSpJE/W9rHrOHuTX?=
 =?us-ascii?Q?vkLM6+mnwdJoVDq+jlav4Z3nazzslwVvNdnLFzsv+62PyuUDMzoGlQsjKX1l?=
 =?us-ascii?Q?/3eUS7uL+nMQ3CrJvof7GbCCKE3W6d7CTRqVvDzYPXYH1aYcZA0vPWGfwWH/?=
 =?us-ascii?Q?vqHrC7gq6U5H9QyT/KYWOoX779hnmQ/nVExRNW4qxElpWpa1n9TWRLZVjwBp?=
 =?us-ascii?Q?pdGXvUok/isc2rX1nXBl4Ag/I1W9VLKhvmpvwKcTCvk+xuohFsCM0q6qaeAi?=
 =?us-ascii?Q?DNAdi2YY7p5q1giAlcaSCgwGLD1v/xV2TMvwupGUre+8YhhxWrL27dfLhgXT?=
 =?us-ascii?Q?2tPtyt18CTnTWpojyyRak/nq7oa9tYWUojoUy8e0bn49zKqzCT8hZT2nj7CV?=
 =?us-ascii?Q?kKFJUHSNIGRwJRcquwqE+cdeoV4hdRO0VrJdR7y4THizDlK0jxJJDkiWpejz?=
 =?us-ascii?Q?C50KRmn/Qs6o+hpKwsZsOF3nFT4dLNO8Zq9yEnvkJwXUIbABVlmB9bDjDQYy?=
 =?us-ascii?Q?W+Og+vYl6xZgQaRZ6GX1g6R9e6prAIEh1VpsqcsPoM7QW1yfDY7iPaA/6xei?=
 =?us-ascii?Q?NZycxpci01PWo1o0nqRHqgduzKF3q53UEUJRl0UFf9Opou0vvWWbKJjoNB3C?=
 =?us-ascii?Q?YbbBGi5eKZfbQeeNota6FsTj1UUw/UKefv/GfEOyuipAOkB8FlIolzpa+U+b?=
 =?us-ascii?Q?duKb19J72lyXRoC73eiD923F9Khk8gRzK+WHDoPfScxW9ggRpDV72gNqFKBq?=
 =?us-ascii?Q?1DdtPtC/5i8a7rvF+I2MY/j4Z+2UoXGRL8w8QhECQy6VYR0CqfkqNllUSYqW?=
 =?us-ascii?Q?bN9bcaFfESfOGzEQnFrNIWJFjt2mND+cHLAUYh1K6o2BDkqhyZ+2Nt9mLQNk?=
 =?us-ascii?Q?B4iNTZ9mR2+WDe0Np+WHBUVR0ls46Q/ZZ1mU2GqT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 840e6f14-f98e-431c-d929-08dbaa415e02
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2023 16:43:13.2513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bx5E51ThYCi1qNcsBPqrRAwd4wFeZfq0PZq3YfZxXB/t0Lo5DYh2p+0WJVS+H2rl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7847
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023 at 08:59:15PM -0700, Linus Torvalds wrote:
> On Wed, 30 Aug 2023 at 16:40, Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > This includes a shared branch with VFIO:
> >
> >  - Enhance VFIO_DEVICE_GET_PCI_HOT_RESET_INFO so it can work with iommufd
> >    FDs, not just group FDs. [...]
> 
> So because I had pulled the vfio changes independently with their own
> merge message, I ended up editing out all the commentary you had about
> the vfio side of the changes.
> 
> Which is kind of sad, since you arguably put some more information and
> effort into it than Alex had done in his vfio pull request. But the
> vfio parts just weren't part of the merge any more.
> 
> I did put a link to your pull request in the commit, so people can
> find this info, but I thought I'd mention how I ruthlessly edited down
> the merge commit message to just the parts that were new to the merge.
> 
> I appreciate the extra background, even if I then decided that by the
> time I merged your part, some of it was "old news" and not actually
> about what I merged when I pulled your branch.
> 
> .. and if I had realized when I merged the vfio parts, I probably
> could have added your commentary to that merge. Oh well.

Thanks, I've been trying to make these PR emails sort of a 'state of
the union' for the project as there are a lot of collaborators
involved right now. The vfio parts are logically part of the iommufd
work.

Jason
