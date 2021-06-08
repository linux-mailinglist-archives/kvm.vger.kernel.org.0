Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E6239F76C
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 15:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhFHNRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 09:17:44 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:63457
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231162AbhFHNRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 09:17:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEEwSa4MxjjFov+G9NLW7YN8N/iGQR7KiMQrFmxAEHt8nzAgEX/z3FnHeXzP8CvpruRcoxKR/sc6J2j3ZHQGvczfC7oLRi2j6CmhBEWH6bRNwpvD7JqMbZPMlD/2BeLxCZWIjxa2IfKYrZnrMwPykw0hpb5vkO1ZJfnaDcor1GajliQAopHk/zrCT23NRk0SkOJUJTEoOfS1arEJCqI7E83JgjrsayXKoo8Xb8TfqGhjtdNlOn91o8CWgfQ7CUH4M7300jipTOQAgYmUGBXyKsAVNw0uKrqpEfOZ1ogQudfeiNAxgF3uLJYPxY7epU+0+tU7mg09A+dm2hzh19oHhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wv7Ydaixc1D6IXlkQficNpH8vTJz8OcrkJE++N0n4ug=;
 b=oMx7A0m5Wm5u/Rk8CxaVG/sWCoiVb/gsxDbDCjxjO01wVsPqwVaekOY0sdBglNivdbL7PsKy/zL/H8MqVPiiw++DOWWARhOHZL5aXzcIcGcaukLhWtMa/drx2alDDgMOLlZ1ZfphlxSd41anQwCrUsknlPRV1+jxxe7GYepjsa0WkArHTx1PYBfoBEAxbk2JAcvplsn2R9MR9JnFycvAYF7sX0ExkTdny0HFojqIwqh2W6HZ6TE3QHCOPxpYQDOyy1c9pvSlOBMrYKdmxvPZrPY2p9wPNjoJWDaxqiB53Kn7VOg0eTh9eTs7gBp4Mn3PixpuUC/hub0J3BdGeQaiUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wv7Ydaixc1D6IXlkQficNpH8vTJz8OcrkJE++N0n4ug=;
 b=CYbgWL+gERBQau8KFTnaoxKFrs8sFLxnjEpdn2cQ2oqg7LJfOiiH0ezmDArx27jtsfRN1IUqX6rUAu9rjSLRBrzwSVLlG3Wsi1lmr67cZn+fylEt8qVE8nLlZmtp9gjl7gSeKqm39QcDe2MtuWtv7VbBNcaekVAc/zMCWg5QVOOb8Jl0H+oM+O0sZzJhDBkgPZm8SdahHg33FNZ6qLD/uA11odEd7xriLBCZv74UtpDInatZRUFGDYbSQzriLO/UQNrKjlvmx/OlPwgNi6NgVvc8aHFuF/hy/bELQOxgG658qxDiKcqIgseHSOTUowoA8glqIvtd1rZ2YZej+DAZcg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5206.namprd12.prod.outlook.com (2603:10b6:208:31c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Tue, 8 Jun
 2021 13:15:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 13:15:49 +0000
Date:   Tue, 8 Jun 2021 10:15:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210608131547.GE1002214@nvidia.com>
References: <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR18CA0013.namprd18.prod.outlook.com
 (2603:10b6:208:23c::18) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR18CA0013.namprd18.prod.outlook.com (2603:10b6:208:23c::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Tue, 8 Jun 2021 13:15:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqba7-003qY0-Ue; Tue, 08 Jun 2021 10:15:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25b23e3b-f899-4715-5430-08d92a7f88d6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5206A8E2BD31890131E6FBF0C2379@BL1PR12MB5206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xfa27A1a3lDlu3NgGm644VBFymLVJCEGGeENw0BoP/Mr5M5BkDfFkShXFFiESssY2CKczfYuYkrXN54W5TPSvopFGzWFwhTq9ekRfRynwDs2wrPYlplj9ahkrsTGOB474rXyVT9ox1h9jRYDajahkWarFoifXylA6nNOQsYFvrdsMVWCD19U+DU68KHYW+IU4jcJdK4AtxAUms/2meQ098JT05bNsupWPY1MwufqlpvFS+2taeB6XAJIP3rDrbeL2YYTztWJfhVcKyqGrf4te3ZkiByPaNZWZVHG7Fua9IQ7s8FI3Lk77geWVyKa3Is4adZwZqJ25xHRRKkI3eC5lrDo2zJ40LgC+XpI0ctokF8fzo++NfhsFkP1vJxJ2NrMloKNyXUQDzJG1Najy02o8VQVxLit1NdkuSu7jEfla9W6+eJMrvbuL95HJQnieGW91owFdNFldY1Ups1gvx9hL+NllCeN+5NPwjiSdgI5Gv21OfOkBUqgPQYXBxtdJgqZY+eFwggYrwZnlFPh4oNsSkqTg9uk18zmSr4OUEBvyfYSYbsweXK86B8tk9RWm427LpIPotqVtxtSJeCbCCTD9oeZ5FPrLrTzQqsjblFFaNI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(186003)(86362001)(38100700002)(8676002)(6916009)(83380400001)(36756003)(426003)(9786002)(33656002)(2906002)(9746002)(54906003)(8936002)(316002)(5660300002)(478600001)(26005)(7416002)(66946007)(66556008)(66476007)(4326008)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GKnTkeXvj5zfgWuxJbOezaILbBkr47V0fpTC6Gwi47ivYQS1CTr/WqOPYwTA?=
 =?us-ascii?Q?V5Q43tTYOci9xDNGigd5XqW51LsFcZGJFl8Z/BScF2OsDI1BBKipgDifeYgV?=
 =?us-ascii?Q?9iGXZmPdAg4YG3lOreZc2cU4k2cscZWg106NhZ7m/jRpmGiLsSoJwEk2+LQz?=
 =?us-ascii?Q?3F0oGTq1U1wXdvL2LqhFfce0dHvetdP3C5VkVVTiXlo7BiHTcZ6gW1eXPtxu?=
 =?us-ascii?Q?HRCXSEy77VJpZdFxUMq4jHdaa/fcK82saOVfuSlK+L0OOHPGEhLB+WwZnY3m?=
 =?us-ascii?Q?Bme3dfjHJBD5mPhJTWyySqi4B6ZmihV7zhoD6QGVLje8d2X8qqp/pvst2NiX?=
 =?us-ascii?Q?hk7HPo2UsH511nRO26Qd3/kYiBUgJObMy/GjDU2+AHqafdOb75dqnjlIWFxf?=
 =?us-ascii?Q?p9L6Hd98Uj54qQJVuanD19n11e4wg6IIl0q5NQUux15DMfBOQ1Fu+GLrFqkw?=
 =?us-ascii?Q?nr8oXpSoB3iWNIzjK7DWgE6MbzezMLVMBhLSYrwxqQqh10OCCkl9Ibl9M7Uq?=
 =?us-ascii?Q?uC8ZjA9oozcGBJINw1KrzPS97mRyhtFZT08O7NgpnoH2qIlR769YCq0oAVfX?=
 =?us-ascii?Q?hJnPt2evkD75yD/26CAGWBtTeb/Gw1COCp1JRnmPAAOkhuCTF5q0plUmJuEQ?=
 =?us-ascii?Q?K9dMkazFbpIiro1oeJfaxeV0ilHK3NDRjI0q+TpU4xD4p0eXAqEtnuGOgcXI?=
 =?us-ascii?Q?ymNMz3fV+rtHWY+8M1iwkgdb9Pan6pbECWJU2nd7oY9JMcxcp2q9/5CaWvc+?=
 =?us-ascii?Q?g2H7qWucyHZ97GjkK+Ve7IO7gmfem3wCA4YFocnWqOUEXpUNU2Q7YhQhMHyG?=
 =?us-ascii?Q?SbACuvA/tSFCkg1lOeHD6nwEuUsKsghRLgTgd50ym3daIZGU1WQzM/3PFNmr?=
 =?us-ascii?Q?6qpwOrLbc8AOVGbIeR83yHcg9BWCCPAJMN8M2HDJJ7RvnjDKo50cLuEQNH77?=
 =?us-ascii?Q?znGEIZpbBdHJha/A/mqL/d5Ejtzng+Tg+NCEwknRNG29un0Rd23HMbZjLG6O?=
 =?us-ascii?Q?YUayAXqvMgm3Q/lHcTo0Y8UqYNB9fXQYaK9/Qvf4u8sbyStlqHoBRLZf2i/e?=
 =?us-ascii?Q?XYaO+nPCEJeTt4xf+/0jjb7u5kWuHTfkqBMPwbv+QfWqOUzPxiPupcX3eran?=
 =?us-ascii?Q?FKwVLHasdlJ4j1b6bc7R5iJ8ZKlVN71e2ED07flGWvtXI9eYTHbhLZGc02ia?=
 =?us-ascii?Q?iGn+vMOJPtTXrrb9W2v4wskojnIGLJJTHZCQXpPDMxLj0xU1fIbTAObjJIlR?=
 =?us-ascii?Q?LbSfG0sviG59OGPti8yboAQEccG5DLG1+irM/qb32mrsf8UN3vrdbUlb/fp9?=
 =?us-ascii?Q?OXGbG+7Ngzo2nWc61Ur/4zwF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b23e3b-f899-4715-5430-08d92a7f88d6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 13:15:49.5622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JQz/FBDW4Fb9FwHCZ56NkijwBD+vGH67A7sEHhhL1IvQndU6XD4vvpnhLGdNKUJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5206
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 09:56:09AM +0200, Paolo Bonzini wrote:

> > > Alternatively you can add a KVM_DEV_IOASID_{ADD,DEL} pair of ioctls. But it
> > > seems useless complication compared to just using what we have now, at least
> > > while VMs only use IOASIDs via VFIO.
> > 
> > The simplest is KVM_ENABLE_WBINVD(<fd security proof>) and be done
> > with it.
> 
> The simplest one is KVM_DEV_VFIO_GROUP_ADD/DEL, that already exists and also
> covers hot-unplug.  The second simplest one is KVM_DEV_IOASID_ADD/DEL.

This isn't the same thing, this is back to trying to have the kernel
set policy for userspace.

qmeu need to be in direct control of this specific KVM emulation
feature if it is going to support the full range of options.

IMHO obfuscating it with some ADD/DEL doesn't achieve that.

Especially since even today GROUP_ADD/DEL is not just about
controlling wbinvd but also about linking mdevs to the kvm struct - it
is both not optional to call from qemu and triggers behavior that is
against the userspace policy.

This is why I prefer a direct and obvious KVM_ENABLE_WBINVD approach

Jason
