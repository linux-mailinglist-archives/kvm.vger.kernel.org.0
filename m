Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB10753B21
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 14:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbjGNMiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 08:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbjGNMhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 08:37:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27779E68;
        Fri, 14 Jul 2023 05:37:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kn1ES4K5zLbTvL7rq0KSzZr5bpWFLc8H9NnOzbEZVGVsn24tjbYiDhDFreBD9Uw67+DQtt0hsJU/+O9ZpR91CUpy6PHrZL8YpEp6NAXfIVdv0V3f8TXPqDxP5QrCdHvN/0sHqu/7NvU6MPbx9IQ6HHk9H9eanjjycyIEnX/aSQjr75HfZiBO7zSty7SugmBZtactkrlcPElHV0yVU9KRTn13vr1/tyDktCk5kAl91LC3dCOZf54SWBHaFBWSnRK8FH0yjnUT/K3vdN+J60/dua8C9A0CozuKBHELa/InFiU3OULBus7svzIeOhAqG/oBH6WRgrbWKybmDI9SZFkuTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DkEIaMoVi4rlvDtRMHnDDi5/Mdql5dScAYCugfxdtHo=;
 b=HWKaRW/hVRlrsz6OH11v/tBaJJYP9I4ilBk+DS/T2g1LZdb9vXgk1H39UPdVN9oZG9i9jtbE78eXjHr0XBXAShgWgnYK07s3qkHUfVjwIWBdydhNhGuyzdBaoBRGks3l+TL2TYlKwMynkRyWB7fTHot1vGvDVgboNR3xAztgpgFJPt+gt3Wk8upTROejHl/ad5R+U6EMkC229oaORpGqHOF6BNhYYll3faul8ssf37jwoQ83Hl8aS5gjje8zWBUHnY+vwnEwgYC2fXsqhsttBcs1SrCL7YfVh/fBbE1h5WBEWzGKiXP1fynZMTm9bKbJn95Bf0XK9EB2BZdZqG6E2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkEIaMoVi4rlvDtRMHnDDi5/Mdql5dScAYCugfxdtHo=;
 b=VXu8XdjCz9jbcDREWyccMVmrGjzSdoaPrnVH/8ppg2AhSHLR/87o1ouPxL2tNByK22agQ+1kV60H5GOO1r/2ko0tWHsX+8mnE90ruqCHqITR8h4xy/mk9ORgNrlm1uQLm67xtyhoVajsNZMWfxigT63cQ8CAHTW0zTZL5lETusvTLnM4owtL9SaNJGMTD/sGmtRedEJ1tWlO8KjlM8HVqfxMcoj7WThcdN8Ki6VusfLNAzDQK6PgJUIYgVEQOnl5C1C61dr4KyCKB9qVQ5mpWVA542ykGCXsdBBH/NezblTEimy03nVQ1hsHBXqhWVGfoqbWMg6r+cIX5BUt9GMt4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB7615.namprd12.prod.outlook.com (2603:10b6:208:428::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 12:37:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55%4]) with mapi id 15.20.6565.028; Fri, 14 Jul 2023
 12:37:51 +0000
Date:   Fri, 14 Jul 2023 09:37:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, osamaabb@amazon.com,
        linux-pci@vger.kernel.org, Clint Sbisa <csbisa@amazon.com>,
        catalin.marinas@arm.com, maz@kernel.org
Subject: Re: VFIO (PCI) and write combine mapping of BARs
Message-ID: <ZLFBnACjoTbDmKuU@nvidia.com>
References: <2838d716b08c78ed24fdd3fe392e21222ee70067.camel@kernel.crashing.org>
 <ZLD1l1274hQQ54RT@lpieralisi>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLD1l1274hQQ54RT@lpieralisi>
X-ClientProxiedBy: SJ0P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: 01bab31c-5bf1-4bb3-7bf9-08db84672315
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fxhbt8uFkAzVUDjJqOVyRAOTgp2merTiVzcUksiZuRlAEStLL/4XMbNDDZfuFraEPotYNqaQgYJ2dbW7ClpfrFupZdP6vocOoB1f0x6Wh96cPZFOJUrKPlhOSiYqW/qZ1fYfNJcKswPivlu8cEAbCorCo4JO6+URBAMKe2vUSpnVIVzBxFeD+8zgIDmxJ9xJ5ZxJUL8NqS+Wsdv4+3qzXxZK6Dip4E+rRuP6630oIR0Hn+LzVcbiMCJLEKhAuGPhfE4DtZiQlTr9mPf2/fLTcS3iHo5dhEwmyV1oaIbP43B4vSpjgKoewjOKCa2RJMxe91eBlZwChJBxZ0IIdP+JYxT48+vW2Rd3bR3/kLDWhbzr5xLg5fj0MY9rDa9zSQiRuj4wbFPYuGAOkG3UM/nH59wnwkxCaXMDGdm2HHe6MGdahpuT7A9979grbi5xRNknfnq3SGZVRCzefEiEMy8/2rWTiiKwEuEGQWd6BL1h+ON5YAD1VkFbE/DuAUVLko+MJCgbNkxKZF/fkIc4oKeXkCZkQZCjXpra+K+Nn/hajpaC7Au4gkD6TnpHDxq9jFofU+t/hWpnbUspcy6W4TfGeNhVqcHHljHkB3nbsYSuoug=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(451199021)(2906002)(54906003)(478600001)(38100700002)(966005)(6512007)(186003)(2616005)(26005)(6506007)(86362001)(5660300002)(8936002)(7416002)(36756003)(6666004)(41300700001)(66556008)(66946007)(4326008)(66476007)(8676002)(6486002)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UJnx4m/SMDCc0VfdfI8gGDBNX9cJArlmNM0qv1PGXt2Of1hFm6Yr9oUYJAL7?=
 =?us-ascii?Q?hdr2mSKTT1nfjeANHKZCzQt8qVayvCnUDGxNZdv4Zx3/4mLWyVRIeqFSnaay?=
 =?us-ascii?Q?ngh2j53bkzwYln6X7ETTQUjSzaGSqVcYnlMXwlUHH4FI1msuujgAl3pAZBjJ?=
 =?us-ascii?Q?Hkig1LVoZ/4ViLJkYWS6kBhvqLdxNl4pRkjKTrvzpRGjKncmqxRwOX0V+8Nn?=
 =?us-ascii?Q?gYiyy+24yQ3IzVrdDbCXBSY01voK9e/Lbvqlly1NsRYOal4pRuM7Bb4KhLr8?=
 =?us-ascii?Q?W8mucMrRwjVQVWIO7o1GnTH5j0cI/yVV4dfVPBetKETvjZqFoe1591IenmJq?=
 =?us-ascii?Q?CgBAcC+AAGidgwDAypvCJHf7sONRhFM2wFbN1tU5ChVSLxzwHMO5RGDsjNy0?=
 =?us-ascii?Q?hhDYXz2hVlg7vtI/SRMtr5wGJV/+DFG9vBR8m6605CCbBgXIqOYWyqRZqHXB?=
 =?us-ascii?Q?5gqs9NbxT6ElP2luJspbs9zvlwmHmzPqMqkT3l9M1u1O4z1IRuVA8g9rln25?=
 =?us-ascii?Q?FfChtRwixcd0XoVRtUq+s0dOlzanVq9+dYJmEYf/UCaiG0iUV/tGogm3C0sI?=
 =?us-ascii?Q?m2oVr8BfGmk9QfYHoMZgi30QwzFYpsmb2d9ym8F9+IlHBHksyWbAW+1hmVWN?=
 =?us-ascii?Q?ayyQNDRrLykzY1mlMQkrikJelT2ueNSGtmVwM1Z61iEIbCyvRPxDs3wlJitT?=
 =?us-ascii?Q?BOkIjByE34DKP/IyMnZDeiS1LoybN9jEiENMpyDb+2eBfTaeunWOThMeGXkF?=
 =?us-ascii?Q?Jw9inZBn7rFOJ1hdUnsJtvwdzF22BMWTFbvra331yWpED7YP36AeRm3X36Wa?=
 =?us-ascii?Q?G7cEl4rAD7kU/f3PaSY01Azsgr6MGxJF0Wl51x+lpTPDSU/RdeoAt3uRKlwq?=
 =?us-ascii?Q?zs0G/QXjYVX2Lx5m7bgZcVuqst0PH/m+Kj4jmVZBL2xQDn5COKM6Amec+jE5?=
 =?us-ascii?Q?TzSzcjZasqq2qIHscPNpk2sR7AAED1y2pJ18gBF66ZCJYTjqQnUgih5N41S4?=
 =?us-ascii?Q?0KBCEgsBnFCQ//B20AmloeAjomSsOBpwHEFFML7OCi4geV8KN61aRQ7FvS7/?=
 =?us-ascii?Q?pkM9wsGMIG9ylEetRBdQK2BeMhcnHcyFN6JsxbG8MH8JvxXcj8vuApwVE9Ol?=
 =?us-ascii?Q?J+hJz8dqPiua8GH8axOy0tYjSiuHLTgmFCx/NmtE5fVM1OzE2UQZT2+bdUoZ?=
 =?us-ascii?Q?zRLHy62RsGf/Y7aJbxkAl6Ow4D/4EmVA/5TdDGY+uqb8emOq4tKXFGCcGZgI?=
 =?us-ascii?Q?lTf9DooRT8TpeYSA7jfzeUFW4o9x6nmPQn3mP1xedHtTDNXwuqlYRFUNF/jq?=
 =?us-ascii?Q?ivTVVoSxnJCzSjKOjyuiAYEiiXwd3nvf+hrIUYQfLQEAFZ/84bAkq2paZa4g?=
 =?us-ascii?Q?PlgR+OjVarfYGrGIjSbX3vAyn7mZMFvtjLrzC9azZRvUU1dpVZ6TU5gQQkUO?=
 =?us-ascii?Q?PklTn+KjpmgEiX+82FjuBMeFeIMklbKF6j6sVdrMFll2yHciIkoks7sQwo6H?=
 =?us-ascii?Q?t+UvcBsk6jvE7gsfgUVVWo+o+l3TQTnYeeV5kXny8p8c0YLibnwHUolrHQLJ?=
 =?us-ascii?Q?riD/oVuXhrqSKWLlvQ2Cymazy1rUkUqIr7cMGYrT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01bab31c-5bf1-4bb3-7bf9-08db84672315
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 12:37:51.0153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O3L10blXGiLrolaf3WAJCaERUZ4HyiBAwvi+v8YRm5gJePDWs1nnZccNJWnc2Gz6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7615
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023 at 09:13:27AM +0200, Lorenzo Pieralisi wrote:
> [+Catalin, Marc, Jason]
> 
> On Fri, Jul 14, 2023 at 12:32:49PM +1000, Benjamin Herrenschmidt wrote:
> > Hi Folks !
> > 
> > I'd like to revive an old discussion as we (Amazon Linux) have been
> > getting asks for it.
> > 
> > What's the best interface to provide the option of write combine mmap's
> > of BARs via VFIO ?
> 
> There is an ongoing thread on this topic that we should use to
> bring this discussion to completion:
> 
> https://lore.kernel.org/linux-arm-kernel/ZHcxHbCb439I1Uk2@arm.com

There are two topics here

1) Make ARM KVM allow the VM to select WC for its MMIO. This has
   evolved in a way that is not related to VFIO

2) Allow VFIO to create mmaps with WC for non-VM use cases like DPDK.

We have a draft patch for #1, and I think a general understanding with
ARM folks that this is the right direction.

2 is more like what this email talks about - providing mmaps with
specific flags.

Benjamin, which are you interested in?

> > The problem isn't so much the low level implementation, we just have to
> > play with the pgprot, the question is more around what API to present
> > to control this.

Assuming this is for #2, I think VFIO has fallen into a bit of a trap
by allowing userspace to form the mmap offset. I've seen this happen
in other subsystems too. It seems like a good idea then you realize
you need more stuff in the mmap space and become sad.

Typically the way out is to covert the mmap offset into a cookie where
userspace issues some ioctl and then the ioctl returns an opaque mmap
offset to use.

eg in the vfio context you'd do some 'prepare region for mmap' ioctl
where you could specify flags. The kernel would encode the flags in
the cookie and then mmap would do the right thing. Adding more stuff
is done by enhancing the prepare ioctl.

Legacy mmap offsets are kept working.

> > This is still quite specific to PCI, but so is the entire regions
> > mechanism, so I don't see an easy path to something more generic at
> > this stage.

Regions are general, but the encoding of the mmap cookie has various
PCI semantics when used with the PCI interface..

We'd want the same ability with platform devices too, for instance.

Jason
