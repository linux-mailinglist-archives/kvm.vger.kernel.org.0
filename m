Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DFC54FF92
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 23:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbiFQV6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 17:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237186AbiFQV6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 17:58:00 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E751900D;
        Fri, 17 Jun 2022 14:57:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPnXHaCh33Lo1i6PrqgIXhfpllLXqqjfnE54eUHIPONra1YNCl3c6PTjeeVX8fex954zNnvEN8hg6P8eY5jsm4usAno3yzSTJkx79SBo7j/fvYb6YBlhKRIvnRZImDVsCTR2ZCKqNmUr19EQs6Qi6lvcEtIgdNlx7gN3V3dg+B5SbPhhLFtYpes6Y7SrXzNZhBvxJOpaRhKuctnkKP7eo8jdrcrM19/4581U9mPIajx0Fh79hhviADl43XvjuOeqxShbDNMCzCD/v2uLa11Bn0WVwyii4BVFwNhYOaFONOeuXTLcno57Dx1Y9F1deDfAJr48HtzHDZaQ9SA9+8HPew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znkRA8Z4zT0hhTVsPJ898SJImrtU5K4yJGKe7OqSB6c=;
 b=YExOA1i8luexSwBWVDLzY7h0DWAo6JUFasILJuTVDdAF0XBxo7rBERRSQ58gVTiR/OlzYYYogDs396wRbgjngsCI9eD1wedmA+yPro0l46jRi59icKq5ZGIm15EoG2xBLEnQIoxH7/GFdxXmvjnvPWQta/yc5hnqKY8iwMOwhZROLbRpY8km3KBvhjuiGpjk3dPVuc5ivUfTWj3XSK8NkLyzVlQSEkdIsVItS23cZt414uSxaaUnhjNo42ahkdh3YskA1dHItTjOJG8TdQ6jsvwSjnMoLEKAeehCjhaVNgXp4qtzCOWjQJcI8yzJDh23DOEmjwrfQE5IH3A6PdGIpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znkRA8Z4zT0hhTVsPJ898SJImrtU5K4yJGKe7OqSB6c=;
 b=nyELMDJypZq3guG9eeth9mbIU2RAGswAzsgwpgZyyUjClN2zEgHJ9VxUKkX7Hisd6KbGY5FF3NY8HGBsO7ijZldT4rbbbOS0YF209BoPkvvIIi7rUx+FLP2y88Hn+19BFvj5zXHrKOtWxnrY1S73VlYI17AMjQaJdlxBHDTMXVN1KRKf5rvV9MB9Hp5QMMKe4+w3eYB01GDXQsAQ9UW0c8HO4Yx383uwIAqvt6FbeXrCUZE/9MACcpgtkZIurJNG0ZkTHFzACyMSZfwIShuAYh0MRZFIgNtEaa/qUj8G9lUpdVPlM7GQ1RaLovxfEQiONyhw7vGq1ux5Sn7vddXJUA==
Received: from DM5PR1101CA0010.namprd11.prod.outlook.com (2603:10b6:4:4c::20)
 by IA1PR12MB6433.namprd12.prod.outlook.com (2603:10b6:208:3af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Fri, 17 Jun
 2022 21:57:49 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::17) by DM5PR1101CA0010.outlook.office365.com
 (2603:10b6:4:4c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.18 via Frontend
 Transport; Fri, 17 Jun 2022 21:57:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Fri, 17 Jun 2022 21:57:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 17 Jun 2022 21:57:47 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 17 Jun 2022 14:57:47 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 17 Jun 2022 14:57:45 -0700
Date:   Fri, 17 Jun 2022 14:57:44 -0700
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
Subject: Re: [RFT][PATCH v1 3/6] vfio: Pass in starting IOVA to
 vfio_pin/unpin_pages API
Message-ID: <Yqz42ApyYoj3TUll@Asurada-Nvidia>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-4-nicolinc@nvidia.com>
 <Yqw+goqTJwb0lrxy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yqw+goqTJwb0lrxy@infradead.org>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3062efc2-0ca8-4952-da21-08da50ac6b29
X-MS-TrafficTypeDiagnostic: IA1PR12MB6433:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB6433066883A6AD4BE583075BABAF9@IA1PR12MB6433.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VM+dx/Y2vxWca6s2eAiR3BY0m8c3ofVbtDDLu3qeTDDGV0Js0492B43lA9eoJZejx4CKlIJ3KAXjsEyc5J189XLWTf+pzhUJQmQdoZDxmgckyQeDc22X4ebEyFW4nP2M1BqeMNik3odgxCIoPDC0SL0cGfddEoKWLRRyVds+SvaJMdMVU0wNYNJYsRJuaa3BIAIbuc7155HIz6jmkv3WP3n8Z+cAj6WowKnC9dsVBMPcfqKqvpVJWoiIHHz8ZfUl7Dj+FmMPJC1RgJIaNqT9r14y2pbB5PvVYzlgXPKIsma9/aG0Wk8DIZUQ3N4mUhnBayNjIvK1WAD3J/Dd5v25X+mgYwOY5rwg/9GTW5MI2749SfL5pr40rxsnrMOzcMdfTMFzjftyCMb2zcMVCt15knqyxz7YEF3WAywWcjDUmjFkr88GubOUYgVDScC5q1zd004qXTstzZPJ+4XDhih1kBHSHXoparMWNxZy3gUFdqFJc5bts4rJ2AsUw9twoplvBTnCngovm7CRfqF7ilZhZkCz0x0SWFauCtlE6E45WhHOCqaPCCZ+j+MCLKCjQhoqyYNBVNl8w3QcSS/T4FN8IjVS8JcS5sKSvtLksJf7tpRUnXpWSGBTavgEbAn/R3S+xKkZuxvs9eEKIde8lXJoIcb43bTZ93NrO9YgTS795SKtMFY7J8uROItbvYHKRV91fBKovo0Ju9naDxwBJq5+RA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(33716001)(70586007)(82310400005)(70206006)(7416002)(8676002)(4326008)(316002)(186003)(55016003)(8936002)(7406005)(6916009)(54906003)(2906002)(36860700001)(5660300002)(498600001)(336012)(9686003)(86362001)(426003)(47076005)(26005)(40460700003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 21:57:48.7129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3062efc2-0ca8-4952-da21-08da50ac6b29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6433
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 17, 2022 at 01:42:42AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 16, 2022 at 04:52:09PM -0700, Nicolin Chen wrote:
> > +	ret = vfio_unpin_pages(&vgpu->vfio_device, gfn << PAGE_SHIFT, npage);
> > +	drm_WARN_ON(&i915->drm, ret != npage);
> 
> The shifting of gfn seems to happen bother here and in the callers.
> 
> Also this is the only caller that does anything withthe vfio_unpin_pages
> return value.  Given that you touch the API here we might as well
> not return any value, and turn the debug checks that can return errors
> into WARN_ON_ONCE calls the vfio/iommu_type1 code.

Thanks for the suggestion. I will do that.

> > +extern int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
> >  			  int npage, int prot, unsigned long *phys_pfn);
> > -extern int vfio_unpin_pages(struct vfio_device *device, unsigned long *user_pfn,
> > +extern int vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova,
> >  			    int npage);
> 
> This will clash with the extern removal patch that Alex has sent.

And I will rebase on top of Alex's change.
