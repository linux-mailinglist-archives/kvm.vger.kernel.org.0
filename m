Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E1F3D7C2F
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 19:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhG0RcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 13:32:17 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:61921
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhG0RcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 13:32:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrNOTWNl5fPh83dHBzqdsFHLMQ4eWA38Gw4GrcdkTwkfjIBEJjaX3o8ylrQH2l69Cnc93au7JIT1ozMPQ7zYfObSRoHhtCp+Q3EXJSqCK3jNACGu5LgO74MrvXto6lh0KtaIYbBYEgAJLUrqpc8ymT4xcTvbXYrXCBSLz4tdvdO6Fja9CfIF0VbExVrHqsgPDnWc1f8atZAJM2iVjgni1Wzu4wEkI4Y6UECYEHRUBFs1TJEmo4igpbZxRO5hteVb9aCRL0legMxoF348VNSDHWtuygMpnUId4hx+q3T3wG0pVKNCiIT3QyGckDHbuj8WvJVGYm7vuWNR+aL9n6X7kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Huqoj5F3QztvjVsip8hrc/b8mYSbpzWx2AHB2vIsP5s=;
 b=acZxNjQb0AjRAXYZDhODmLUX4mVRXRGNsUSuvvT+g9FphuZEdgmA5bMLqBoabdk/za9s6z1yuatjhJ8NmdtDkbzISgxCx8Fqd2KIFVTCJkbpe+y7RhUitYBSuxiC8KRdKrOzUiToqGOLtgbr3VUm42aW3QgPhtgtElimcqPFgXTXa8y3MlMg1t9IutzwNX4KJkwydjXrkNy4vT1HCN0xeLzSXU+NQvX84hTseD63yi40Np+fdqlsgM9TN1SK/Ou5RMKRr6Wh1gUH+Kl9VO8deVzrn0IlUFeDJef87ZrUvW9mCjc3b+C834/OehKq+CyLbUAu2XhgFfguyOuEiVHwQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Huqoj5F3QztvjVsip8hrc/b8mYSbpzWx2AHB2vIsP5s=;
 b=mlT/o5+y8zFSYbNJnxwNLfHnoPfYWEvZRd+x3mTBawbXuwhOD3ahoPE8X5LLSWmF5Vdch9wa8mCQgYJyaazRXSsvLOuSHbnz9pY++ua2XJtuEiTHz0E8llPyEpRwNmgjZfY33RoxoZWyp19CIu8/qmMrmdXkf5a0KF0huS9zKR/lcwYHHSDMt/qy5oVfVYnOhQ5wCmo0A4+7Iwwu2SFJmvagS8vpSRkJ2DFiM/nfzXif0ERNiuo/jDMKgbUJ5wyitJK4owfEKBhQoHtvi8+MFR+Vw3oliIzc7JVQDXQkQn0rqlNormrT54/DHbHsJK1lE8FiWHahoVdWwi6MLPnpkQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 17:32:11 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 17:32:11 +0000
Date:   Tue, 27 Jul 2021 14:32:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio/mdev: don't warn if ->request is not set
Message-ID: <20210727173209.GG1721383@nvidia.com>
References: <20210726143524.155779-1-hch@lst.de>
 <20210726143524.155779-3-hch@lst.de>
 <87zgu93sxz.fsf@redhat.com>
 <20210726230906.GD1721383@nvidia.com>
 <20210726172831.3a7978fd.alex.williamson@redhat.com>
 <87wnpc47j3.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnpc47j3.fsf@redhat.com>
X-ClientProxiedBy: BL1PR13CA0215.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0215.namprd13.prod.outlook.com (2603:10b6:208:2bf::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 17:32:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m8Qw5-0095yn-PF; Tue, 27 Jul 2021 14:32:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5aee5555-fbe0-43c9-e621-08d9512476d7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5223:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52233DB5BA46E2B67791CB87C2E99@BL1PR12MB5223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gyFbCPGPnT4JYbh1FMa/MuYkoNVRFRK5cwY6y4HnIYY/ovsg+dnoJyR9aKMCio9y+YSuNj3VOKIj03l0BD2r8+j3U2BwVusQwD6WTM38rGfB18FDVsCvvPyQZp1KLHCwLVCD4PKwJQ9deZUTSkZgxKwYRSLMUyws14FI7IB8ov1PVkP058rLM+Cy7+ybYq2xRTLOEMKQjpgBr3vtt2AroITTM0j44xyMNF9fMJgp/EtglFWJTpv48FD2P2yyp950c3cKtKI6c6E8z6ryipDj83ac0HpbwighVOav+1CMCUaJNB51xAlJve39t7zOF9dJC9Tfaf3skz53eEVdHLzzk89hRQwlQccxygNovXggfQf0LiBqSamVIGoTMDkG5kbGs0BPDdfhBy5eyd7u84cXg6dl5F712qxpTpu6rNNiHczFNpOa8steWgUnc2nsek0EG9F57bPv+/2Za1lgikw9tW729AhL/0viTZZ40b9qGRCg9O5U2drO0tYT/Kq0T9oqZkLK0lnlFmhjk7+w88jVPWPkxVtpu9grPIKCq8erkQAtloP28Ov2oi+cFieJXyER/vI1C7OJGrMXqqkwkKiFL3kazM9sKffZ1cWDj2nQPCGj4B3szFAbEdAJUDqLFV8lj1ejyt/BgDGLxyK8hNdUIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(38100700002)(26005)(508600001)(2906002)(9786002)(4326008)(8676002)(1076003)(36756003)(186003)(54906003)(66946007)(9746002)(66476007)(33656002)(66556008)(2616005)(8936002)(6916009)(426003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RTOzOREUoGEZ1h6P6qQG3kt/PuUHjLVhj6pgrIlKS9NVNJmGKVfTcsj85RH5?=
 =?us-ascii?Q?Wknh8pUWNrAhsjV/Mb0/7fyku90IuBFWkimjjN4Afy/k3UHxN9Q19oo6JwTk?=
 =?us-ascii?Q?57FwINlI0ozEf2FxYvXYqxUX+iDZs0nyWDh8uQ6yanUmKCVtlbynkeYTXDNa?=
 =?us-ascii?Q?NEVHDF8xmrw8gPKeWkCsfNuWg2zGFF2mgo1mvtdhtpx3ckZhhM7KATKnlaO4?=
 =?us-ascii?Q?j0Np7n5TINyfjZCVGx4R/vrH8ebA9iMFkdr1JYgVGG8BAbbUUnzs8erGxkCV?=
 =?us-ascii?Q?YG5QN1EIdxgBGVJBPvrJDY1XZqFPRYb0ShuTgxpz5GyVVqMN1+hQwamm4T3I?=
 =?us-ascii?Q?onQEIlVPqUPmtvJHo2OmHO1LN/X/6kIbMk8ebAURv8ZUnJUqVAf+LMMMs4vi?=
 =?us-ascii?Q?A3NjrdBpaS2G3m3ac6DO0uP3ohPyPZUNfXqidybuQyi2zs5JeBetQnJ03GD6?=
 =?us-ascii?Q?WCUouJP/3qJbFWlF+erSVnUfUNvZHSOQPLqYuCykAVGPoRPVftT4AldR2zFb?=
 =?us-ascii?Q?eNQMG6rc49YZPq/6ocuRv+XImeVdGzAQawJTAjEnnaQ0pK2wWF+SLCXVCVms?=
 =?us-ascii?Q?9UiyBiy3WYtTl5VAAmx3tlIVrX9trdxDUtRRcFkai8Ph4q7fKLC787YmlxI/?=
 =?us-ascii?Q?JE01Cgmy/af0iYwjNW7zNHZeMR1wMJz5UY+ChK/Z34AUErFAMNRNvZ3CzkUu?=
 =?us-ascii?Q?alMDYxY3dACJc1A0rb700MMOMjG/DjBkWYo5mG9F/7KHePtDdFt85TyN1f8A?=
 =?us-ascii?Q?j3FNCZ+uCRqTv3hg//nSmxqGC7lJwo1UTGC7oQTB6eHcJdp88zMYvM0I8ql+?=
 =?us-ascii?Q?jYKkc3WR6SXrm38FwUvq7zG0Q1g7Gj75sL6ClJzzKsLYhOutkckfV8kuNcip?=
 =?us-ascii?Q?QGM1QkRhryR0rpbHm616MKKcGLwJpbfyRtjIJhaX2qcdOFYMVi7dNejfVV4r?=
 =?us-ascii?Q?SoEFjK+FOEZdjR8FvJro56srgkuEjqf0BrItWX8xIrNUN2luKZ5yKuWvVAJz?=
 =?us-ascii?Q?fHPc7DakvhBmcjzFDWxHb4MZUAWmpyu/tVVBO7zg+2j8vbdKMgyneibMbkcJ?=
 =?us-ascii?Q?b/rjj62JDXgJFC+9g7QaZC4v3RyYCDt1gfZTYpp9XApEbtrWd6/EgLR99HwY?=
 =?us-ascii?Q?aM+WjeKDGrtk/tguKa6VeTtf94lbZAL1nHlh0kkYEQUvpjGNcN9bm/gKc3Vo?=
 =?us-ascii?Q?ljksahyhKzokSbQkqw0GviHu7PtvRHMmxE4vjSMMJP2uDkzY7yMJwXFayK5I?=
 =?us-ascii?Q?DtFlb9d/70riXNEPiSk6boBrCorE88klDwyb6cS0mExoq7FfPDTChtJ0PJ/3?=
 =?us-ascii?Q?NZGEmbVTt6ZnevDBMeH6S75m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aee5555-fbe0-43c9-e621-08d9512476d7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 17:32:11.2044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g3d3aAq1hg2i22rqUCI5K24jT1DOabXXg6DFO6ITt+n6ZaxOS1ZFFSmqqYp8dU4i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 08:04:16AM +0200, Cornelia Huck wrote:
> On Mon, Jul 26 2021, Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Mon, 26 Jul 2021 20:09:06 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> >> On Mon, Jul 26, 2021 at 07:07:04PM +0200, Cornelia Huck wrote:
> >> 
> >> > But I wonder why nobody else implements this? Lack of surprise removal?  
> >> 
> >> The only implementation triggers an eventfd that seems to be the same
> >> eventfd as the interrupt..
> >> 
> >> Do you know how this works in userspace? I'm surprised that the
> >> interrupt eventfd can trigger an observation that the kernel driver
> >> wants to be unplugged?
> >
> > I think we're talking about ccw, but I see QEMU registering separate
> > eventfds for each of the 3 IRQ indexes and the mdev driver specifically
> > triggering the req_trigger...?  Thanks,
> >
> > Alex
> 
> Exactly, ccw has a trigger for normal I/O interrupts, CRW (machine
> checks), and this one.

If it is a dedicated eventfd for 'device being removed' why is it in
the CCW implementation and not core code?

Is PCI doing the same?

Jason 
