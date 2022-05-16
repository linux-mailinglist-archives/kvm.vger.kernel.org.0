Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499175294B2
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350176AbiEPXIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350289AbiEPXGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:06:05 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2053.outbound.protection.outlook.com [40.107.100.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F84FBF44;
        Mon, 16 May 2022 16:05:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zvbn/dG8wc+k5JFCFuZr2ZEkvtbG7uMqaFmoTND0AS+l+0DZlrEVMEyWSCN2R18KHetTIj42HMdcl+Emy3AqlfiyVAykHunoo/x7ZU3b/lbGGyhT44VM9i1lLZN8rhqCfjZIy89Ee6UZhdonIbzLtX/fGgcWfNd9eACMsGUpFak7Yka5T1uBE9+1DTsS9gMNxC9ltG+abGRUsy912+6tTcS3F90GdpmfceJGTmPiqHnd1UOOldfh5dhK6hsWgCHYu8QKTiYKA0NfRm+4hSTX6xjijOo85wsTMctGg+T1ksorF4nBGJflB/LGa2mKQylWAew6rkoyxoaA5VSNdGlGAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9Ucc5Gnc2GvalXuZmNfvwWD/77t0y9K9wEhd0P3YSk=;
 b=R66Bbp5k9upinb7pkU2DjVzGx8eIbPrUNKfZ86rOvYs8MRKVFEB5lPa2lzyWUdMasg/ppmUZjwF95G7vB1zjW4MfvGCG8MHDv8Ojz8oteRD6xfLPdyHOmny49/H6PEUp5nsPQVgFdFt1FqXCPuUx/TbbGIf0d9RrwzGQVT64xzBD7Wny1nZO/I4omkAK1/R8qRsr9flblGNN1K4302bhcy8p2tJlba/IITBBNJWvKFgbEw5oB/oLZ21CynNnFdR6vKQ4N8ng6Z0PgvDGG98zo4IVUu7cwnsS0O8FqVK0qTLcLO1AOW9zsbhjM5qzkwnGUcqpOGzXAY8LgRaTTkp2eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9Ucc5Gnc2GvalXuZmNfvwWD/77t0y9K9wEhd0P3YSk=;
 b=Ruo+aDXrgjSxmIDDEFGgrhLcosZsXjuJRz93gg/ArJVdYGLTvPJhmSJyO+u0iS/1kmYGNxpni4lBtXynVKsOJdXStYoOesVe1dNs02M2tEolnlPYjOXX02Jx0e9i6am8/O0Kj1Z6YVwCnyB1nI9mjOUacc7huSl7nbPwh9e9GqaHYUQyb+Bvo/DUd66doV6XiPrdhJ4v8emvmsN2j1XQKbZU13QueIdKPB0jz6owIJZVncSGA0lZcthB5lNROepf9eb6L3sqkzxqXO+sBVUqla39aOjAw+eV90RKDJEhfzlV62BkF+Aap7pcrgN79WJvBfFipesew58Dbsy4tfzX+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB5782.namprd12.prod.outlook.com (2603:10b6:510:1d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 23:05:53 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:05:53 +0000
Date:   Mon, 16 May 2022 20:05:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, linux-s390@vger.kernel.org,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 17/22] vfio-pci/zdev: add open/close device hooks
Message-ID: <20220516230552.GO1343366@nvidia.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-18-mjrosato@linux.ibm.com>
 <20220516172734.GE1343366@nvidia.com>
 <7a31ec36-ceaf-dcef-8bd0-2b4732050aed@linux.ibm.com>
 <20220516183558.GN1343366@nvidia.com>
 <305208c4-db8a-5751-2ffc-753751a70815@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <305208c4-db8a-5751-2ffc-753751a70815@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0228.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a5f7bff-8da2-4358-c8c2-08da3790a0ab
X-MS-TrafficTypeDiagnostic: PH7PR12MB5782:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5782BF14B2A70922CB73C32EC2CF9@PH7PR12MB5782.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5wLcwHWXfVSMYuuYQ1uUY1EgwD5CqMaibUvf1tXtRhv8OScfsk9ITjGVf+gXakXDWhSe/rIkT2V6Y9Locxds/6IKsHpBw3UA9BRVT+QEhAN+i0svo5B2jKnZwjVnDAUxmzvmvUH2t8b3YoM3Kz397fE3Mdp8J+ijGwZ9lkbxU7WAfgGhDwGlyGpqhTDDfT08W4llIL8c3ypW6Jv5/bUEDO9DSU0KNTeWTMTivErscWmsKYHJ+ZhmpTcLCcMHbr/Xq74N/mixa3oM4zFnpZaSt3eloXM1PziFiAfMzWIsKlRQLKypXQWFXH739fBZ1gZKcRhXUYO2l+MyyE+wIFn8rmYplaZNwKpWmM6/cro2J7gzpinH17k09OUSsrsbCC5rlDJYMl9h7xAKuckXswyPq9f/5rTMJ0J+ZHtRMyjhOuYCF2730BNiYF90TbrYNEhebwJ/dWvZkFiU7GLS/d2kSZJT+nMPMdLY0QaQZFB1ypY5IfwSArzeoGKaP4Wo4FvuHPD73a1BpbJYaJnc+REu1pySJSOEMn0PuAIL3NVrX8Oa5WDkQX3rHFgBElHwWdrW6WI5ItVaC11PhGGm5LiKzQgKxR8H5wl1f/w/qjFWTaBQUCtArm8nxYQawGYRdxUb4OhambJIhjKnoZ66ePv9vAXkZvQ42BlJxdmlBQaTrW+KsoeVgodsIn70xKka50tWfh32f/fqdP6VwrE75oUqMwzmV/gcB2BOZ1DTmJNXIk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38100700002)(186003)(2616005)(1076003)(6512007)(966005)(53546011)(66476007)(26005)(5660300002)(33656002)(4326008)(36756003)(7416002)(8936002)(2906002)(6916009)(86362001)(6506007)(8676002)(66946007)(66556008)(316002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mjn9ITNW/AHZMfRQkogHi7By/C6NGHNzKFv5HFQVm4VzPp0TkKMUfoGYu0kR?=
 =?us-ascii?Q?xZaDKfvq3aVZ7kvdKrangap9a1v/iK9nbO3Lv6W+e3mGBbrC90wK8PlYeLIm?=
 =?us-ascii?Q?YQzret62omCu2n61N+3gk+H8ve2BEK9BJzxdJO/adh+eKHfgygnv1tFqgxOy?=
 =?us-ascii?Q?ddRM2+I5n2DM8DAPyFdfinYrEuEObglmgDaYSV908qtF5w8lNHkmU7qmyVkl?=
 =?us-ascii?Q?N9MJvUGrcRHlVcb21P5XcsnTQ7y6Ds4oYIAsNiI8jDKSvOdGUduMhPgOUd+Y?=
 =?us-ascii?Q?xfJgJTk/yrSSg321VAx80QCcpzlsTob7jKcb2hgoVqWSHPXLyztvlpL4uN/3?=
 =?us-ascii?Q?8s76a7EtvHY7hzmPqoaVDJ8n2+TdatmwXD+3pSckY0ePgmYpxw7JN4++oia/?=
 =?us-ascii?Q?VbEDqhvxJGf1VM2HLeKFVDgl/yszjIq9Iy5jVvtzAU9+B/r/TgPA5oGXOo2A?=
 =?us-ascii?Q?HdgdVeYhUhPtn3Gd5EAwLTLXsPgarTPtzWB5qpAibWXn5X/qaXXdPJV720lO?=
 =?us-ascii?Q?MhtAdcbT2e0KdU/D8bn/DfnCPgTSBypdWcXjurjfUPV31v5I4rFEe5/6P3Cd?=
 =?us-ascii?Q?+F10bYjjHX8Q+m4NySPWCe4VXji4QE2CYaLcn6mhXjp4zgOrQ8PDFZiyGtqy?=
 =?us-ascii?Q?4oNekKVBYobHbAKohh7KTuvwa9Fro7UGzP5K+G7AziBEDs1zABBORU/w9/Js?=
 =?us-ascii?Q?oh/wzJiYrhXkznd0dmrh0avyPjMIXFMLlefVzm2zIBbFHTzMcpd1s6m0KdSQ?=
 =?us-ascii?Q?3Ffo3GhD9dPTwG9//pbA8jq/+xBgXVi15vi+b6Q1qgq+HXlkOWEOqiwynlR8?=
 =?us-ascii?Q?Eld8ryHKwo6dxzHuOauAO2CP0oN+mn6O77KBDCEjWrM9s8TCcQ5vV5krq5V+?=
 =?us-ascii?Q?DYBborA/laQoXqGPAVOLso9AMraGxe80Ro3bVn/U2BSCx9h/aXQyJmtLxRwL?=
 =?us-ascii?Q?a+YW4o/gpWR8hKUyHjUxc0kt6x75eLcyj5y2CKhaotVigMp9fhwp6f3HXUE6?=
 =?us-ascii?Q?q5VwsGJ1ZtIrUN1tzgkt2RY7x8o/FP6FRWGwC+BrfDiQzqQW59gm6Nf0csx+?=
 =?us-ascii?Q?NtP/3JzEETZbauVPrt7jHK0bVm6+/7UTLKeIGfpzsQWeW+reywKwHR3ufHlW?=
 =?us-ascii?Q?X4wz8Ef6RwHa4jV7HS4rDx6cYf+a8Na0nj5z72IxaiSnFHRqEQ1LWyBsaqJk?=
 =?us-ascii?Q?crrJxe2dkeCBhKTxj/wIQcgoDYrPZCiEExVKehm0gZaoPoDP61v3eJKNkWdy?=
 =?us-ascii?Q?RkY4I7as2PR6cPYkQZsKUCc1YqpHqy+JcekswjKyoK7Rg4cd+So/+WFUilwP?=
 =?us-ascii?Q?7dsM5424625k7WsxSA9EEBJ2JWGEkqBZZ4jcJ114XNOkVygAyIOJlm7CDrEL?=
 =?us-ascii?Q?ygTjtGYhmYYpumu08r0SEob6MFsZ7nUkuXHgvEwo9mUnoDCcMvlpmddyaDq+?=
 =?us-ascii?Q?6Qy+JR7ci7PQFmczGHuElc/HO/lkgfq2ZIu48XFf6DEc6CNRbIppspJi/gd4?=
 =?us-ascii?Q?Ifg4YIlBsLe5XY/FDanD/UxhIcMhemjJKvWXKVDABb3CwJTykZIa29/kQBFw?=
 =?us-ascii?Q?eUzY+5MSymwPzTP4AmkJxPacWjI5PFe+c6TM2UHwPdiItbxK39gm6hpSOVmu?=
 =?us-ascii?Q?d5BaYzeAhvhJx7GtjjznX209KoQSYkgp/loSNCkgkBd5U0rhScgjhuD+Ud/N?=
 =?us-ascii?Q?YKvNxqOWcOujgo4bHmEg30a23MJf9LAHuJ3iJ0yHElP1LQNYgmRwGTo8oQAX?=
 =?us-ascii?Q?WobbV0FOwQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a5f7bff-8da2-4358-c8c2-08da3790a0ab
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:05:53.7870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eEkH9STYkZ0yzxAVvDjL/wLzoZYa36OXmVaPeMPB4K1/ZMDSxQi0vJD8rhce12GR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5782
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 05:59:01PM -0400, Matthew Rosato wrote:
> On 5/16/22 2:35 PM, Jason Gunthorpe wrote:
> > On Mon, May 16, 2022 at 02:30:46PM -0400, Matthew Rosato wrote:
> > 
> > > Conceptually I think this would work for QEMU anyway (it always sets the kvm
> > > before we open the device).  I tried to test the idea quickly but couldn't
> > > get the following to apply on vfio-next or your vfio_group_locking -- but I
> > > understand what you're trying to do so I'll re-work and try it out.
> > 
> > I created it on 8c9350e9bf43de1ebab3cc8a80703671e6495ab4 which is the
> > vfio_group_locking.. I can send you a github if it helps
> > https://github.com/jgunthorpe/linux/commits/vfio_group_lockin
> > 
> Thanks -- I was able to successfully test your proposed idea (+ some changes
> to make it compile :)) on top of vfio_group_locking along with a modified
> version of my zdev series.  I also tried it out with vfio-ap successfully,
> but have nothing to test GVT with.
> 
> That said, this has caused me to realize that 'iommu:
> iommu_group_claim_dma_owner() must always assign a domain' breaks s390x
> vfio-pci :( I wonder if it is due to the way s390x PCI currently switches
> between dma ops and iommu ops.  It looks like it breaks vfio-ap mdevs too,
> but I know less about that --  I will have to investigate both more
> tomorrow.

At the very least it appears that s390 thinks that attach/detach_dev
are strictly paired and that isn't how the iommu ops are defined.

attach_dev can be called multiple times without any detach_dev.

Possibly the unbalance of zpci_register_ioat / zpci_unregister_ioat
causes the trouble?

Jason
