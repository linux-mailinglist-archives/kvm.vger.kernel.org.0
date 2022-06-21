Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF1A553E1B
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 23:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355507AbiFUVru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 17:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354749AbiFUVrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 17:47:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6439018B10;
        Tue, 21 Jun 2022 14:47:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btBQ+FZg7D7CiQZ8h+fQB8URiC+jHXQd1lnryHzdvU5TMSMh/wu5HWwBYehy74lCV0fQf/6t6uqDRHND/UQhfe99v5YnZVqdovTum7SQbY5oG8a2BIm3GJPIHLAclp7gatpmIiql1yILU6RaiTt3y1yDiOXwPtNjHqVr1MYfftountstjpyuJw90NlrpDXnzos8Da838iaVdSDCSTeMjWkrCZ9o+pSGJWil1fHn+BQaij86iz8ZpWdIF2Oy+E5+Dv1HrwJwCHkwclf9nYTJQdUxK1pTsK/y8+KyePC844ukfSzpUPBdcgjgoivhigDKWX2lMiTNbhpoG7Eics+hziA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hxnKwYiDt99Mxuh60zgFK/9jO9aD/RqDXBbLbXgB5zs=;
 b=fiIyC/ZsrHbMlYbsXCcfT58k1t0gI/zg6+b2mAYeqewyX+2HSYAfNexLgxad0hfnFa/Mc6NehFAVmkNU9bJjsgAk2/qeoRC3dG5Mmj/3y7RBzKM4Pr5Kzu4t0HfJXDUGkvKH4e56//izEo/f5LDLs4JrxMNq5H7cjIp4g62nHyMt/KewHkBLzIXRccOGNIWp7ebG6cyAHawzH4HViVNGxikQN41AWlnXEMpA3ks8O5DkLz9COxOvls81UlE+5m6zKDf9jXN6hhOIXcSlJh2NcIr3euftML9cocdnvcUrbKnP1GtNsCuq78eXt3ljRXBEfFqxdGW49Uu+2k1vclagRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxnKwYiDt99Mxuh60zgFK/9jO9aD/RqDXBbLbXgB5zs=;
 b=jWHCFDxNIIHbRxL7JKr5l6812c5WwVxfFWwjLI9BeRn5Qs3cq/mlMT336db8SaSZeiP0f5H32ZSPoYTZWFpqEGp8Pzk8u7j86pq8nAzdDz19eLcHrgXz9h0ub8XKR0B/fcIgjrQc10ATYLipj4L741lGfyUGFGNitqKpFdK8Gef0vR7C1bwLiFg82omYVi2PuHwx+V2F8Fun+yhPjh6C4+qE8rbcGpTn8/jk+I+YB6NQVtfzmij8pL2cixA/4uLlTBftJ7wpdtqQ6YcTzhJxlBPxTN8KTc7VcMrUOmU0XwGqfFShUi4Lvp3ckZizdBShTf4SKk1CteNavOO6Tl87og==
Received: from BN0PR04CA0096.namprd04.prod.outlook.com (2603:10b6:408:ec::11)
 by SN1PR12MB2352.namprd12.prod.outlook.com (2603:10b6:802:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 21 Jun
 2022 21:47:45 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::a8) by BN0PR04CA0096.outlook.office365.com
 (2603:10b6:408:ec::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17 via Frontend
 Transport; Tue, 21 Jun 2022 21:47:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Tue, 21 Jun 2022 21:47:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 21 Jun
 2022 21:47:44 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 21 Jun
 2022 14:47:43 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 21 Jun 2022 14:47:39 -0700
Date:   Tue, 21 Jun 2022 14:47:37 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     <kwankhede@nvidia.com>, <corbet@lwn.net>, <hca@linux.ibm.com>,
        <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <tvrtko.ursulin@linux.intel.com>,
        <airlied@linux.ie>, <daniel@ffwll.ch>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>, <pasic@linux.ibm.com>,
        <vneethv@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <freude@linux.ibm.com>, <akrowiak@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <kevin.tian@intel.com>,
        <jchrist@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: [RFT][PATCH v1 6/6] vfio: Replace phys_pfn with phys_page for
 vfio_pin_pages()
Message-ID: <YrI8eYsXemPgNBa2@Asurada-Nvidia>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-7-nicolinc@nvidia.com>
 <YqxBLbu8yPJiwK6Z@infradead.org>
 <20220620030046.GB5219@nvidia.com>
 <YrAK87zjdOqUF6gB@infradead.org>
 <YrAVuxMEkV4Wytci@infradead.org>
 <20220620153628.GA5502@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220620153628.GA5502@nvidia.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdd285c3-c2bf-4151-6dfb-08da53cfacf6
X-MS-TrafficTypeDiagnostic: SN1PR12MB2352:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2352CCDB6F223174BA858242ABB39@SN1PR12MB2352.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wszq4XMsCaMkLKfCdaRnS9oDcwZ1WPbTQXiOegtpfjqu9vCTNG9JHva4LY0Bwj9r6rAen4E8U8sfLp11ci58tLYMTq1LHFbjsFKqVcJVxkPdwo8WBaYjN5jirvm/hQ90QTRelPCwYWuOA9QABt+6m+VMy7wpq2gIQzomxkFEVNPp6GNMLRrNBHkQKz2N3fxMcZWY+3BkZmW5uIAOUoE1EnvUxBA17PuBgpdQYOuwB0USipzmPnT/XIXWKExzTUAXIs835dUHIGhERsSnsJNCrDRcvoT8Nv5AAv5Ild1D1tPBcJBBaYjlq2EKxBBDdF+WIDeRS3qk4VD2TeVxe6HwwDTje5wIcNwuJWHVh5szDvjElHNbgvOhoyBKWpkVr8RI46Id64dXPwaxQrJVI1J1385+SGAmnTuVYb3h58Cg/GgFtC4bKIGy2APCWQwuagiOZKqVJjyaJlfBFWQwiXE7ZNUX+Hrj8ArIogv1b5aLFzppbn9zcDnBMvC2h2I4jVcoaMlEUpb66qSeMl923VlwktWJeag/6nGiBPh1DBFNgdX+WCwsZUfds0bOuey2eb5YfFfofTHHgV0IbfQeiY8rEIa1OIBHnz7YerEp2oeI1OFbw0K2QHXh337FhRco5GS5OI18SPtTBpCs8NMvJnU+DRGrgQbmrIR8GLa9vNSWeg/UT9YT1bKDEzhavHrdrKxZYqbX0nOkSeSrQBDwiz4+jiQfDe0IRm9WU2P9G9Owr1kX1ee69EdZa/O7Q8A1cptp
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(36840700001)(46966006)(40470700004)(6636002)(54906003)(70206006)(110136005)(2906002)(70586007)(7416002)(316002)(478600001)(9686003)(26005)(7406005)(5660300002)(41300700001)(8936002)(4326008)(8676002)(82740400003)(40460700003)(86362001)(81166007)(47076005)(426003)(33716001)(40480700001)(55016003)(186003)(336012)(356005)(36860700001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 21:47:44.9794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd285c3-c2bf-4151-6dfb-08da53cfacf6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2352
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 12:36:28PM -0300, Jason Gunthorpe wrote:
> On Sun, Jun 19, 2022 at 11:37:47PM -0700, Christoph Hellwig wrote:
> > On Sun, Jun 19, 2022 at 10:51:47PM -0700, Christoph Hellwig wrote:
> > > On Mon, Jun 20, 2022 at 12:00:46AM -0300, Jason Gunthorpe wrote:
> > > > On Fri, Jun 17, 2022 at 01:54:05AM -0700, Christoph Hellwig wrote:
> > > > > There is a bunch of code an comments in the iommu type1 code that
> > > > > suggest we can pin memory that is not page backed.  
> > > > 
> > > > AFAIK you can.. The whole follow_pte() mechanism allows raw PFNs to be
> > > > loaded into the type1 maps and the pin API will happily return
> > > > them. This happens in almost every qemu scenario because PCI MMIO BAR
> > > > memory ends up routed down this path.
> > > 
> > > Indeed, my read wasn't deep enough.  Which means that we can't change
> > > the ->pin_pages interface to return a struct pages array, as we don't
> > > have one for those.
> > 
> > Actually.  gvt requires a struct page, and both s390 seem to require
> > normal non-I/O, non-remapped kernel pointers.  So I think for the
> > vfio_pin_pages we can assume that we only want page backed memory and
> > remove the follow_fault_pfn case entirely.   But we'll probably have
> > to keep it for the vfio_iommu_replay case that is not tied to
> > emulated IOMMU drivers.
> 
> Right, that is my thinking - since all drivers actually need a struct
> page we should have the API return a working struct page and have the
> VFIO layer isolate the non-struct page stuff so it never leaks out of
> this API.
> 
> This nicely fixes the various problems in all the drivers if io memory
> comes down this path.
> 
> It is also why doing too much surgery deeper into type 1 probably
> isn't too worthwhile as it still needs raw pfns in its data
> structures for iommu modes.

Christoph, do you agree with Jason's remark on not doing too much
surgery into type1 code? Or do you still want this series to change
type1 like removing follow_fault_pfn() that you mentioned above?
