Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8194BEE7F
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 02:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbiBUXtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 18:49:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbiBUXtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 18:49:06 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2592F13;
        Mon, 21 Feb 2022 15:48:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNZEDgFNnFhPYXzomqmbrgT0tqSH7TMaEphZNpIBa0hLLBW8RcOK/Lvc5a++pw1w52RvO5G8qU29coC5uRf5qFslhahjtqG+8nW4V0VfMq6RV8+7s1ZsQpoKs+8+u/zoqoxfKVFg2oz+dAaz2+9vnlNYE6RjYUE+5lCgWexl6howfNw7Ycga2cRofLesRWjlMOWPmPO1uTtswwp97KUMKOTfAoySrLVmT09OwxWWkULgt5lJBMgL8AfTlNx5lCF3CXqW+5JiV+DWOGQKkRe5c/hMxX0h8OsmAGNLSzn+ohoELg4h+QqOWKOCn4iVu5L01PTmxGC8IXPY8beJUiUpSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcWDChi8lPpHRhyU4hWbSi2+fwKFXVHF64Gc3Ysd+bs=;
 b=N3YXewaMQvAsNiVlQdpaGsyyXjejaqzaNCPUM8A1Hkdaj+c7A7PEwyTnlvcpVCc9xdX/u4lp12kVNo18zGYcUnTD22xJloZpWVsYmmbEBvkn+NYkI2VSZj2j2iOMCtXQS2Ayqu/cwUjcrtcLvBcIQDNjsg1MssvtW3rynXFM7mx+IG0jUEVkppuSHpzaYzFPIExpVRy7RaNNyb/R76OB+HnPu907ZI+8Eo5dlmtqVZHy3ozLEB+kGMQtDrZZjEcd4LChsgXBB7ejCKJB86mneQtvvdWm+NcFaldWeroiGBtAPBUW4ezltKbDVl1T+MWHO7ninnyMhnTekghTjDPFxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcWDChi8lPpHRhyU4hWbSi2+fwKFXVHF64Gc3Ysd+bs=;
 b=pWgowEP/6qB4TkkXkyWMJwNZWo9GZ2s9d6U0OfSJNXEiG7bGgC6RhL5dcu+G8vPdl01xciU7s2qcBhsJXpDK2rIPoMeC1WJyhskPXzj/ZJcRaVbUHoiSqydqUxcIdiPWAESicGULaSneEb8+v+Su48DBPJOw5ChNU9I9Gu9RQuykljwwa8WRtmsMvht5rXZrH7Lnm/jaq9hImB93dKhtims9yxkox2oeG5iSn2K6prgeWoWWQCAQvgngSnOgb/03etkDPpVU3GkvGjQcgvyYEd6c06uKnQuZ23x6QzOC9TpHRuzyXIS9Ql8RlY1/jTAB0ZolFE60ZBJYJ7LJJRanGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5055.namprd12.prod.outlook.com (2603:10b6:5:38a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 23:48:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 23:48:39 +0000
Date:   Mon, 21 Feb 2022 19:48:37 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <20220221234837.GA10061@nvidia.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-3-baolu.lu@linux.intel.com>
 <YhCdEmC2lYStmUSL@infradead.org>
 <1d8004d3-1887-4fc7-08d2-0e2ee6b5fdcb@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d8004d3-1887-4fc7-08d2-0e2ee6b5fdcb@arm.com>
X-ClientProxiedBy: BL0PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:208:91::24) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b19a361d-6d97-4fd8-496e-08d9f594aeef
X-MS-TrafficTypeDiagnostic: DM4PR12MB5055:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5055D031CB232986AD17A984C23A9@DM4PR12MB5055.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iWVceXc7lVdrPdreVogL6V9AQIMzQN8K8oV59skH3YwKFLWOq74a0t+2DGui4k1ZccILKQPeuhSgmXPsVXE29OcgbpZANTNFrWt3TAx/mIc2Tb9evhAk4XaL886ImbbmVW7JYay9B6GDlA1j+Tz3IuGjMeOD3ZeBq9kvyH6GoC3zhGiUBKC1KfGzGoiBwxJJRwcOXDK+dGQXewJcDOPlcGzXkOXf62iIGJ/BbvetT56TXkuCU54HixnGCTWu1sGVYShZzIb+inQDtuhbCAP/OfWk8QCSbbRN1Nw055ycrPlJWf5KnCng0rg8wr4aor9lcMiQGviDeN2HOdtrNGwc7q8qefSwNbpv00sAWVXY0u4uAC8d2CD99Ldb8D+GTeHaUFCiIm3hocImbdjuYZRAtFMb25T+331J6YOR7PEBK77UcyfDxwKEt2K9salWVQD7p5Z9blZVX9KXg8Q0KDDXVOnWdBgdfPw0F7Oemxvl8OC4aEWGCXjEcFDYq1PjKecev+/ZDWXfCINv1vpodgPKeGCFzxx7F7wFMcNc3ZzryYvCPwA7gbjt+2PcG6+ByNwYDEyjm89+bccjk1EUSq872Wl6jqV0B+V6A8wEHUeNxm2+oRgwNBapG0Gt1YdO4mtFVXdTC4z6nvAgH9VJzhH3Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(186003)(66946007)(66556008)(6512007)(6916009)(2616005)(1076003)(6506007)(26005)(6486002)(54906003)(508600001)(316002)(66476007)(86362001)(8676002)(83380400001)(4326008)(38100700002)(5660300002)(8936002)(33656002)(2906002)(36756003)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FqGHUW4HO/XDob+kwqpfJRJi/nZwyxdGegCS65n4AepFjWTXhsiiUI0NmipE?=
 =?us-ascii?Q?/eLjNdV7hdObvSQBUF6bTFNrAtP7iKP1jTcJuqCdpMia4LcWP6/35THRTZGF?=
 =?us-ascii?Q?pkbf/tbKp5LdizDBYD4cit8RztvATa70wjj9wb+h0VnCXWffMTLVuZGVL0XW?=
 =?us-ascii?Q?34/BrchfDODt/6TpawO84wAhNavE+H2//hT0R+0vr7+aYc40bhHATyqZT9r7?=
 =?us-ascii?Q?gCZr5Gr84ScijWtv+jgr5O8BmzAwWPKjlo0IvdJhZewbimvnEOAnQZF08Cut?=
 =?us-ascii?Q?rf9IACP8wAEiuPvR9bwtni1j4Us9EwJIltsDyTFyBAi9Yp8nSye6yaVZVo5X?=
 =?us-ascii?Q?lT/0o7wGSnjJbVcxeeegRA873rmecKPlbstcuNb2x2ozaVx3Q9SZ+HdbHrTP?=
 =?us-ascii?Q?cdd6UVP/tVap3NK0tSjntiv5ravvKxPzNuj7EsUf35n3fh9r5RPA24jWxKaU?=
 =?us-ascii?Q?JV8sty74ZsJXWYAzSOSaMc2nU3QilIZb73JNQFjg4TH6e36JZDWx0/vwPWyZ?=
 =?us-ascii?Q?IHjfIJLbRqMo33NDaEEVT4VbaqqGcRs0Z/xYSxvQDorI/x7YuC945CgvMyNz?=
 =?us-ascii?Q?4Rwq5e/1Vu2JGB9ZdUMthjgIYvrzyGvs3YCyA7zA0h7FSNpFNNFvg4QI0mWg?=
 =?us-ascii?Q?wHOODwS0l8hGEmG/LZ8b+hKMTnvksSnb9LyZGKVt7iLOSY8Uz/MRkrhDXTZE?=
 =?us-ascii?Q?L2e9Ertrr+Zqaq0KU/Ic7GNVBtSQe/pGM1RfYQ5ejxLOrsEyKQE3chv+wAtA?=
 =?us-ascii?Q?JUd+R4elCJ/jIRPNxDnS0v2FPfzCkbI7wHrhO6hIUQ5Xbs3SN3RkEI5vVxE+?=
 =?us-ascii?Q?DY/boNihonh8mA8ottlMVqgoc97d9MUrZpurHABmm6kM2aQIEoyle+GAXlHG?=
 =?us-ascii?Q?OpzNF2+Uti50fy4QJ6xB87yGk/bWYvS11jM50iVC0mf9FDErBi5locw1pOR0?=
 =?us-ascii?Q?vnKBg5ZD9L8lz2KtyTsfi4nak0lCMfzBhIOTRl6pGjJRa4DLziUYuscnzIJa?=
 =?us-ascii?Q?bou0Bq2Iv0vvPjFAY6v8nLfs95TWGcVyd62JMQMsfxPp8fsKl31PiWKtOqxl?=
 =?us-ascii?Q?kL6OwMibrUSoSlM6Qg/uYBxGaO9zhOD/3i3UsXIA8kEkRJXhv8509eakrFYA?=
 =?us-ascii?Q?CWj1mdmuzN6o5NbM8Yr8YF9I5NGMFV7oykxbsyUzu79Kolovs6IReiiOuXL5?=
 =?us-ascii?Q?41nInz9OSApPwogcJzvKKl2S0BdlKsyW2x9dLLzQw3p3BHxgKSy/DJJdsK0m?=
 =?us-ascii?Q?CviA0Z7CLI3oWCxaNz8/B7j2QJUp6KyfV7oMd9gBrtlpvY9uz0OimlAcsAzr?=
 =?us-ascii?Q?Dn3Oh9kfxiS08urdi37xXdRsmqxpZ+A0s1i+OfsTIYxqA3xklJZ47oyYQHBd?=
 =?us-ascii?Q?evf6a/f0cprE7R70tNjUgB62AI5+uGFXOZRr8wSET9+LiyH6yXI96B2jEZxK?=
 =?us-ascii?Q?JwGyZYzoFBTN/8W5I3YE/DJAZSzfyyg06/ueH830/P9XjU0fzKR8GitjGkC4?=
 =?us-ascii?Q?dzgv9Q3XTdPMxvpgd+QJImwrz3fK5dCvaZ9GcNaTL1YojRG3AoT9uNgaU99W?=
 =?us-ascii?Q?CPPbbIMzdiJtqA9zCs4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b19a361d-6d97-4fd8-496e-08d9f594aeef
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 23:48:39.3673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iBlyFfVYnf1LhO6mLOQMM5dZkKEGBh5+w7/dZxFchQ+CA28cKFNmZ3H3TdDN4k1q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5055
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022 at 08:43:33PM +0000, Robin Murphy wrote:
> On 2022-02-19 07:32, Christoph Hellwig wrote:
> > So we are back to the callback madness instead of the nice and simple
> > flag?  Sigh.
> 
> TBH, I *think* this part could be a fair bit simpler. It looks like this
> whole callback mess is effectively just to decrement
> group->owner_cnt, but

Right, the new callback is because of Greg's push to put all the work
into the existing bus callback. Having symetrical callbacks is
cleaner.

> since we should only care about ownership at probe, hotplug, and other
> places well outside critical fast-paths, I'm not sure we really need to keep
> track of that anyway - it can always be recalculated by walking the
> group->devices list, 

It has to be locked against concurrent probe, and there isn't
currently any locking scheme that can support this. The owner_cnt is
effectively a new lock for this purpose. It is the same issue we
talked about with that VFIO patch you showed me.

So, using the group->device_list would require adding something else
somewhere - which I think should happen when someone has
justification for another use of whatever that something else is.

Also, Greg's did have an objection to the the first version, with code
living in dd.c, that was basically probe time performance. I'm not
sure making this slower would really be welcomed..

> and some of the relevant places have to do that anyway.

???

> It has to be s It should be pretty straightforward for
> iommu_bus_notifier to clear group->owner automatically upon an
> unbind of the matching driver when it's no longer bound to any other
> devices in the group either.

That not_bound/unbind notifier isn't currently triggred during
necessary failure paths of really_probe().

Even if this was patched up, it looks like spaghetti to me..

> use-case) then it should be up to VFIO to decide when it's finally
> finished with the whole group, rather than pretending we can keep
> track of nested ownership claims from inside the API.

What nesting?
 
> Furthermore, If Greg was willing to compromise just far enough to let us put
> driver_managed_dma in the 3-byte hole in the generic struct
> device_driver,

Space was not an issue, the earlier version of this switched an
existing bool to a bitfield.

> we wouldn't have to have quite so much boilerplate repeated across the
> various bus implementations (I'm not suggesting to move any actual calls
> back into the driver core, just the storage of flag itself). 

Not sure that makes sense.. But I don't understand why we need to copy
and paste this code into every bus's dma_configure *shrug*

> FWIW I have some ideas for re-converging .dma_configure in future
> which I think should probably be able to subsume this into a
> completely generic common path, given a common flag.

This would be great!

Jason
