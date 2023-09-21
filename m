Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8EE7A9E24
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjIUT5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjIUT5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:57:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA93165BD
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:49:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8ipwY1xCd6rgxmhilsLJuI4eRIrmeyGedVu2OXI6Xjc1wihWWnHqkzfMQN2ntFbPi5BLIIDsc2+8a2aNqOht0D7LX/Wx8vK0UdftqBTjZ7vuCvGq5lqxety4za32b6KJ9wJNMn2CiKISspy1kpiWPlqr1ayCfFy3XoQ6m1IOrlyjIcM/EOJgTq3RGxC5ONy9PHu10NuG51hG6KsozSGzdCQAgGVPLCP1wiybYIhFtuRKOyd70LHYEcb374In6GN1N0+kHcGY9e6Wm0S+mQzOIRTLPRhcmFoM14F4qGOfcH98h/whM2q5/ylo8YEuPg6QBd7D7rrbOf7NZuhX9CTiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uzgoVPukV7QysCi+/o25itvOTHSJ46H/oIBx1yswtw4=;
 b=ZIWsk/z95rC/APOamnizCTl++1F22zHPopivY5+DLvD1JF3nZ+E7sMEPaFlMiO0KKgl9QBtxJhb4TVC/1laIIvbsqepecF7l1DjTKloGHviqh0NLruiFTuYgM74Iww8x9587ZOnUxVVO8fptNm4bKlhAXAdpebQpyGMYt+zkdGZUF5ldhHlzq7RD19pPhBJ0rEGTg1jL3hei5zFspQTDB2IMeXIC7miHCHUcepzON96G6sb1msWyscFpM/jQ7ZgtQMe/1fDpcvD9cZ9Z/qvvXjsFXwDS0Y68b3bvMClragh89lB5qd8b3OTPnfJfd8yP+QTkhggL4KWCP+irCcXhsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzgoVPukV7QysCi+/o25itvOTHSJ46H/oIBx1yswtw4=;
 b=IRZlPLC65jhwBTKKJwhiycOfkuU+SaedWcGgew8Po5r34GkPP4umrUJStZu5woCS+5JSyqwR30y5+VHloqjGpjvJA66/r0EP51l+KmQT0bLtPcvvm1XhJZIGhn99NryUqZhG6jSebUTbTg0M3EnR8XJcUkfQ1mlpvM0BspJ5I8kIQMuUB1XjVfIHUBKzwzpt6r4zuJC+bJJ6jgDvjjVApjqiI1odwdp76Vu8X2MHs+oSWB5gOy14z5H7nYcd+1xYx+9HGB1UGyJ8VHiodCQh2RWxVqcSFQ7aBGTCTK5vpUOipCkKkFQbTzo9Lis8cmh40QdwhGTx6HEWm9z3co+ytA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6469.namprd12.prod.outlook.com (2603:10b6:8:b6::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.21; Thu, 21 Sep 2023 19:49:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 19:49:48 +0000
Date:   Thu, 21 Sep 2023 16:49:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921194946.GX13733@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921150448-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR16CA0031.namprd16.prod.outlook.com
 (2603:10b6:208:134::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6469:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f2f84f1-6343-442c-3a8d-08dbbadbe99c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wnRGZS7MXYWMfGDH2FCCko0IpmI1CeyrLMwtZ23hZNXN13wZR85t07P4iq7jKH35y/w9nqZvplmHi2WdL1XdINSUt3JXHHnQ4XQr2LjRsk1Ewini/0wCoHDppzvK37yEIc99EjJJ2scrtBOBmC618X/ahHQzJmdMT7bf4T9A3dCiygqIuJFmxP04GdL6VVtddTN+Daj+wXP4n1zw7u2akHTvd32iqA1LdpZ1wj21iLB1DX5H1vTEQ1tjXsAlkkB4x0y2NdvdhVAsVldFHiaUPRJwUkUqoRUMvMDDfwzs6Q3WfDI550xsL965JcqVSC/ZYIp6mHO22cWtvI4y+4e2DNJL4GxoJOW6SmEUL0UwEd3dfzJTK36/XSCJfhU7cMrrk1mvwGBDSd4jY+duXOhm22TB3l3CRQZEslwxncOln4wAL9kP76qQbNgAj37H94TPGqEFo2sAOOhHimFOmzslJ/xx4GdMkwvUbwH7NglzUO+ZbqwOyFxuCwa3nyFiAerp1D66/luOsDMA1zLc9KRThKRkm1tPK9Y5ZR3XeCkdas9bCWgpUhDlyKlET1OD7w/T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(136003)(396003)(39860400002)(186009)(1800799009)(451199024)(6512007)(26005)(38100700002)(316002)(66946007)(6916009)(66556008)(1076003)(66476007)(36756003)(2616005)(41300700001)(107886003)(478600001)(6506007)(6486002)(33656002)(2906002)(83380400001)(86362001)(8676002)(8936002)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rI/6ZCQ8QaCBIpk8/myC1+vFyQENx8a2owIg5TuDMyYmQgDMfYZOrXR10ql2?=
 =?us-ascii?Q?4t6kzu8jhBaxIWDbhzyxAJI6KLhJnkxmw1+No4ktrHuMC6QV9Ct7JI1TpIiB?=
 =?us-ascii?Q?yP+nPuKZoOQzpRHa1V8aD5QZiPYFfJ/5g1lmIg3LvIKeQ5PwVGOVvmimk93o?=
 =?us-ascii?Q?1EQ939A8jTc9pPLVkA3rX52WkJGzgXn/tJndBQL1UTgQwMZFgflPF9Ccf8/y?=
 =?us-ascii?Q?0RjTQfq+GtnDQBacLY86Mq0TfS/FmYoUeRcpMCBSWarkyadku/Jvf4Ipjv9R?=
 =?us-ascii?Q?j7lpeI3BfyWvB7n2lHKU47ZVd/KXZZjbie68hoYbHQa4xn7IBoaK5brujIx8?=
 =?us-ascii?Q?pgZXasCxOp8MhXbQbH1pigcMOF5TxE/AW6dloyJFbUUhOlPPQgJuKeWGYlVy?=
 =?us-ascii?Q?ftKrim1nCMfh82K2gSqLmfjlEnwdKjqI92HEGMcfKcErfe1rdqGJhwMt1iG9?=
 =?us-ascii?Q?pI5V7sZdXI+ibk2vpxFGbq/CW1vG6ZjWb7UbdAIeN5yTT+jvBQiLZnrG0HvY?=
 =?us-ascii?Q?JQJ/C/S1Snp4HYpVeSpvOpCb4Sp/f2r9Yk/N7T+G0+DAGDdio1PVZaDGApsU?=
 =?us-ascii?Q?n+WfgFo5yC7n0UB33U+PIodqBlBLz/CYZU6d0eEAQnryM+WsM9MXKWkfcmwy?=
 =?us-ascii?Q?syV8C2CNi1/01hPXMA6HBX97qbetSv0epB6RN0puobXf77/ESbKc5vyu1gCk?=
 =?us-ascii?Q?cO/oICFaUnLE+x197JSTdibPlPwgVYVjB61Qcdj+MSH+nBLC8HDkaNFwugxe?=
 =?us-ascii?Q?nUqKsDFH79sSm+4NbGsBpDDtF8nj8QIkqCST6Qkw0rZz6xFW6XtH5sair103?=
 =?us-ascii?Q?6d67EZG5nZCYTBeMCWPSkumdCYIg/INDjC7ktc1VT/Wd2cmGqX0ipxB0jAdE?=
 =?us-ascii?Q?1ss/7I7aLvoqLpojoxLZOUNJ4X5zcj9L/Jbk2q7JT1ttv8Lzh1WV1GKCuqhW?=
 =?us-ascii?Q?S5LdMtAfK4FEeH7FF8LxBPtT6swMnT6uNmuJII9/HpoGLPl2tH4/iCy6+50Q?=
 =?us-ascii?Q?5aaEP+Y0d89Ipr4qsgOXIhF2DzQCN5vgthmYUAyp+u7E2W3xbfhikIqz572d?=
 =?us-ascii?Q?GlzwjlKOvNK7E8bGDdWHXWWf7iI/C284T38ShkFIsC2/K0BegA1mNWOIbCaB?=
 =?us-ascii?Q?NqM+TjBhSY6HiJJzfXXjoQxabCGQZaMT1+Cg5ipf4XvA1bjMYR1uMeyvnW0a?=
 =?us-ascii?Q?hDl+6h99ijDHGHiHaGND+OOlUduN0xBFQs3xz1vd78u9AYQ0I39HdwagBT29?=
 =?us-ascii?Q?hvPiYEofG3ODCUCgwdDN/nlnmGrFMZM/o50XFjErUsemPyG9YCGi2mmR28yA?=
 =?us-ascii?Q?eTDqdoZf2Is2YaK+zhFb1mGm5ajWW67cC6qONLsZ6T/ieCXvwglMq/qTg1XD?=
 =?us-ascii?Q?o84W2vNGe/76ShlQwHjRYv7JVj2bHktjPAjOnhS0SrE2fg0uONvk9g8OKOH1?=
 =?us-ascii?Q?LSYH+gFKPFqfLxb1O3G6MkRaQdPxacAMJ9psV+r5wAz1DEJwKqZa0W4uI8ga?=
 =?us-ascii?Q?stS+bDrw/YClAbaq+iy1rS9IcKnMRb9yH17phBauZ1tmAUQySiPbotfIeDdx?=
 =?us-ascii?Q?wRPwWNbxf4kko2Y9RKQvYDwj1Ehr9S5xlL8JWa3Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f2f84f1-6343-442c-3a8d-08dbbadbe99c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 19:49:48.4692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7QUvLtL+mlum4KXMt2AsxIIqrB7Gd2MUeiepgfJPT5u3r6Rn3SY3UXabJxBlba5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6469
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:13:10PM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 21, 2023 at 12:53:04PM -0400, Michael S. Tsirkin wrote:
> > > > vdpa is not vfio, I don't know how you can suggest vdpa is a
> > > > replacement for a vfio driver. They are completely different
> > > > things.
> > > > Each side has its own strengths, and vfio especially is accelerating
> > > > in its capability in way that vpda is not. eg if an iommufd conversion
> > > > had been done by now for vdpa I might be more sympathetic.
> > > 
> > > Yea, I agree iommufd is a big problem with vdpa right now. Cindy was
> > > sick and I didn't know and kept assuming she's working on this. I don't
> > > think it's a huge amount of work though.  I'll take a look.
> > > Is there anything else though? Do tell.
> > 
> > Confidential compute will never work with VDPA's approach.
> 
> I don't see how what this patchset is doing is different
> wrt to Confidential compute - you trap IO accesses and emulate.
> Care to elaborate?

This patch series isn't about confidential compute, you asked about
the future. VFIO will support confidential compute in the future, VDPA
will not.

> > > There are a bunch of things that I think are important for virtio
> > > that are completely out of scope for vfio, such as migrating
> > > cross-vendor. 
> > 
> > VFIO supports migration, if you want to have cross-vendor migration
> > then make a standard that describes the VFIO migration data format for
> > virtio devices.
> 
> This has nothing to do with data formats - you need two devices to
> behave identically. Which is what VDPA is about really.

We've been looking at VFIO live migration extensively. Device
mediation, like VDPA does, is one legitimate approach for live
migration. It suites a certain type of heterogeneous environment well.

But, it is equally legitimate to make the devices behave the same and
have them process a common migration data.

This can happen in public with standards, or it can happen in private
within a cloud operator's "private-standard" environment.

To date, in most of my discussions, I have not seen a strong appetite
for such public standards. In part due to the complexity.

Regardles, it is not the kernel communities job to insist on one
approach or the other.

> > You are asking us to invest in the complexity of VDPA through out
> > (keep it working, keep it secure, invest time in deploying and
> > debugging in the field)
> > 
> > When it doesn't provide *ANY* value to the solution.
> 
> There's no "the solution"

Nonsense.

> this sounds like a vendor only caring about solutions that involve
> that vendor's hardware exclusively, a little.

Not really.

Understand the DPU provider is not the vendor here. The DPU provider
gives a cloud operator a SDK to build these things. The operator is
the vendor from your perspective.

In many cases live migration never leaves the operator's confines in
the first place.

Even when it does, there is no real use case to live migrate a
virtio-net function from, say, AWS to GCP.

You are pushing for a lot of complexity and software that solves a
problem people in this space don't actually have.

As I said, VDPA is fine for the scenarios it addresses. It is an
alternative, not a replacement, for VFIO.

Jason
