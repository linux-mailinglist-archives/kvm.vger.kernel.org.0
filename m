Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1FA54FFB5
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 00:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345459AbiFQWGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 18:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244217AbiFQWGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 18:06:33 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2065.outbound.protection.outlook.com [40.107.212.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CBD59BA8;
        Fri, 17 Jun 2022 15:06:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFRh5cYNogJ7ksibKfqNM/i9DGS1l0XXbKZhLFnCdlNcwQm9z+BJcGoLPyMlKCeUN4lqEbbwniKnUkf6opMe1ACdbGiiMZMzG8DJOCu+zM7ZKhxQ/p25UxE3d+aMF2TqxKp3mM/4yEpF1V0JKGCjj6DOaSeUFxiB3CAO9UPIHBH22rXwUANR/yG/1pWlO4Q+k87YCYnCTM2LYnJKFsY0y6oF66lSjgcEIR0n5axc8pCfhlQaueGEjqUL4aoU5gxVen4oFnEKd5dsPDnBgrWDQMlke36NHkaBgBPFxBXDBbhxMowNC/87oHr+G5zJ1FapZNuTLLhs/m+20AYHIKtxyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hTgB7vTW2DPvpjS8cJT1N+y7fKQ/UCYMjeuyLHfdu5c=;
 b=X3x72aa3dUitO3FMiGUf5j6F0Id8OGZDgzLTYcdU3SIcOAotnWiSYUsYpCCzuLv+SMt2LoAdCC1QJNgcA8o/EbHOrl9ZlBt2JAbTJrZO8fqfJoNcJCAU+Tpe0PlWS3e7NhyKMgncPY6Vd/4fIvY4+64TI9u1CeVmiB2NdsC+X8bA6YhiATgdOx1kp8KrdGaqv14ibU4bbcfRQp/5s6zs/g9yp1AfP+RMgintzgeHWcLl2mvrEShlGsHVg7Q7tpfmCoeTAHQF/T+9M4NeJ0oFBRb1RWCkJibeuMX8USr736W646yDBggcTGCELkgDiOEGFlNPLeNjvsQnm5DdScQQ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTgB7vTW2DPvpjS8cJT1N+y7fKQ/UCYMjeuyLHfdu5c=;
 b=P94Xp6AwCIPviQA8vsmChA0WpUXMwO2sTaTz7wFH+CVmr7Fz10OOlhsaN+gxfw+5zIIGD9EHbsfR6IZKg9Smi4EoPZoGxQtC6RU9QNf3QNvqwlX6CXZImPoxraBveljBc0y2MPsOiyrfI4HaagubhffipjsOKugTQnB0OuecvAg/XSYSTCntRp22ilgb3Ik99s8RDJMseFpGS25919WUi0yG/LLfA80/+JGTdG9oruAKGi4mayBuSQroN/4Rg5HvkhNIrvP5ZTuneTJTZVQbZEHA1CBnZMxD5PrPd7jewGcbQhnXGNG7mIL7s3PBZzCSBy/BCoWCCplcr8Vihvni5A==
Received: from BN6PR14CA0004.namprd14.prod.outlook.com (2603:10b6:404:79::14)
 by MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Fri, 17 Jun
 2022 22:06:31 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::3d) by BN6PR14CA0004.outlook.office365.com
 (2603:10b6:404:79::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Fri, 17 Jun 2022 22:06:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Fri, 17 Jun 2022 22:06:30 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 17 Jun 2022 22:06:29 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 17 Jun 2022 15:06:28 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 17 Jun 2022 15:06:27 -0700
Date:   Fri, 17 Jun 2022 15:06:25 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
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
        <cohuck@redhat.com>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <jchrist@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: [RFT][PATCH v1 6/6] vfio: Replace phys_pfn with phys_page for
 vfio_pin_pages()
Message-ID: <Yqz64VK1IQ0QzXEe@Asurada-Nvidia>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-7-nicolinc@nvidia.com>
 <YqxBLbu8yPJiwK6Z@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YqxBLbu8yPJiwK6Z@infradead.org>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac732851-9c52-4aca-3bb4-08da50ada1ec
X-MS-TrafficTypeDiagnostic: MWHPR12MB1248:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB12484B57147A74B12A07BAF6ABAF9@MWHPR12MB1248.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5CEUDW86WAUmkYzdN9N+pfgFV3kjHrdDwoU2fyfVTySxA5tp0H3TPXRyOU9PeSwHMzaN6MC5S6l7nFt3AzghMzZamgResq4QME2a9Bz6z6kDMXS0p1Xs0klxmTp5ABtdwjPtxE5UGmKpvVdnP2V/gCxXoUpnG0sHnzfm5SwlNW+o93pC/uTNWcNCEZI2xyX7pSv6I49zk2T3/TGP8nN0/JP0n+gQYtf9sg6Ljctnqgl72FRj4/5XSQpupB11VGZLzqfAXiALNub2kBVIMIjUAmCoLjPGDG6yjjRYQAo3a4v7t2O1prKr/yIOrSl5qV0vdP3KkA+OfYfnMmR6NHK0cgEQvha2eIb5T9PDcSwtdozIusmMpfP2n1pHx0dqaroURCVO6KA8piB/ZzK7lDEzQ3ei9T7MaK2xXMTerF7UTmxJu3kHj72Hem3Kqqv6x7Vifh+jYSG4U+HATjkPEcYU03BCu+hErSRs0e/6Ni6JMIE2es3DKxlsvlSkuu2S3BckyncvqM3+pSeiTVV+LYecQPQqfaMIYwzF1CcjHv+BHoKF7xIJWfqBnwjTG3hQTlzGV4KwwFxPQSph2fi2QELOGHF1XPUApP/ZVyH0WCt5LcvvuciiNJ9qAujv79lg2Be+OgoYFC3X+xIpztvu1qQAFmE0mLoENM0RTN4LFDhtSeUGGkxx+Vg3aJ0O+/mBCGEyw3zNBAOlVrI6dWiTtmNr4Q==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(6916009)(54906003)(316002)(26005)(55016003)(8936002)(81166007)(82310400005)(498600001)(9686003)(83380400001)(47076005)(5660300002)(426003)(336012)(7406005)(40460700003)(70206006)(7416002)(356005)(36860700001)(186003)(2906002)(4326008)(33716001)(8676002)(86362001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 22:06:30.0805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac732851-9c52-4aca-3bb4-08da50ada1ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1248
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 17, 2022 at 01:54:05AM -0700, Christoph Hellwig wrote:
> There is a bunch of code an comments in the iommu type1 code that
> suggest we can pin memory that is not page backed.  

Would you mind explaining the use case for pinning memory that
isn't page backed? And do we have such use case so far?

> >  int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
> > +		   int npage, int prot, struct page **phys_page)
> 
> I don't think phys_page makes much sense as an argument name.
> I'd just call this pages.

OK.

> > +			phys_page[i] = pfn_to_page(vpfn->pfn);
> 
> Please store the actual page pointer in the vfio_pfn structure.

OK.

> >  		remote_vaddr = dma->vaddr + (iova - dma->iova);
> > -		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
> > +		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn,
> >  					     do_accounting);
> 
> Please just return the actual page from vaddr_get_pfns through
> vfio_pin_pages_remote and vfio_pin_page_external, maybe even as a prep
> patch as that is a fair amount of churn.

I can do that. I tried once, but there were just too much changes
inside type1 code that felt like a chain reaction. If we plan to
eventually replace with IOMMUFD implementations, these changes in
type1 might not be necessary, I thought.
