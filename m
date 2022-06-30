Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A42561F9C
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 17:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbiF3Ppn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 11:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbiF3Ppf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 11:45:35 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2085.outbound.protection.outlook.com [40.107.96.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E440D403C1;
        Thu, 30 Jun 2022 08:45:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JATiAwSww2gmyJNr7/g1gK9fdrV6oGO6bSxnr4hfqoEjVY0e3D8x0d19tzyCZZCHyn2hHIR8Yw0+yiI43UcsAJfEP1loDn/Tg+hxr9ybRp70BaCDRF83FRB0VlLokJv4mdta9kqDo0HFxe+SHIlyAWtuVHYSS+rZnGuYRj0z47UyiOtzcRNGRwBDV8ZQGHWW4lPDeyNWR2BObN0q8p3zXxdjJ1jDKrRGmiWhli+kJ9HevRkeyn6eEBZZ0flV1JInQUSjjGMi+b/IfQxzUdoEIjKpBn2rZyBVp82wk3z1mx6TrSO/cr6rshtRPyn50Qtd78isKV7d66fcdv52nS67iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mj4avkkOhNM+7LCDWFCNwgBWpxcimP80cgquJ0k5CpM=;
 b=Z1azTaQ4LfzXccIs+K1VIx5UfSn4nnoXJwNMVMQedawPkeEbruyBUJ8JrNGoDYaY9QYjh31s1tH/tEAMauXDEWFoo9RoSQJPrkh/skStwqa04wi13WdUn+WId97m65IUqYa135jEtuiEySoEsoD3uU21x8lOrwlya147bjQ66BRt580/KWggvZHuueedcnn5GU7wstO046edoDeChtA5rbxF+dMI3u68QcBcQk48CXqF2YWzVIYOgR5MwIRkFoJXDt3A01rC1PPpnZjIs7Qc/wymuooBOD8TzZCF0bEcpgVKUby8Y1oQIRGTiY4TbdgptziAzDr09gUTYH0IYJepzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=rosenzweig.io smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mj4avkkOhNM+7LCDWFCNwgBWpxcimP80cgquJ0k5CpM=;
 b=n0p53tQKfZB4hHCxtqfzAa93/ykgE69bmxA6t0zGBsFA1WaFm+ByaV0P3ExLkwV1OfFFgRfrrmHSc3zJ6uG2ZdloPdNqWaH9sHiZKLBjKCZz6iZtOVU8/X6dmNCh4CgHeZyGfkVnycHpnXw0Ak44dNZRK+a4M+jmSGQtxzu3RkNOlaPJjEmE92nGlww9w72G7u6lnlbSLhu3zBBzrr6UrWahhDmrQFG/q/Cb/2534oSIGCMpwNWHJnP4+KdWcYFkIfB1drvc4Gzc2f4HSGKOjRt2xTNlE5HKlIFQ0H6nbLFqW/8VRlNQHZr5ek8+wtsVnIS5kKmiIu1CvlZZr2v3cA==
Received: from BN9PR03CA0936.namprd03.prod.outlook.com (2603:10b6:408:108::11)
 by BL1PR12MB5875.namprd12.prod.outlook.com (2603:10b6:208:397::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 15:45:33 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::ae) by BN9PR03CA0936.outlook.office365.com
 (2603:10b6:408:108::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Thu, 30 Jun 2022 15:45:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 15:45:32 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 15:45:31 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 08:45:31 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 08:45:30 -0700
Date:   Thu, 30 Jun 2022 08:45:29 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Yong Wu <yong.wu@mediatek.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <Yr3FGRhvJbkW8/Px@Asurada-Nvidia>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
 <20220623200029.26007-2-nicolinc@nvidia.com>
 <270eec00-8aee-2288-4069-d604e6da2925@linux.intel.com>
 <YrUk8IINqDEZLfIa@Asurada-Nvidia>
 <8a5e9c81ab1487154828af3ca21e62e39bcce18c.camel@mediatek.com>
 <BN9PR11MB527629DEF740C909A7B7BEB38CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <19cfb1b85a347c70c6b0937bbbca4a176a724454.camel@mediatek.com>
 <20220624181943.GV4147@nvidia.com>
 <YrysUpY4mdzA0h76@Asurada-Nvidia>
 <63969062a55b1c520f276b9a4b5f79faa12da20b.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <63969062a55b1c520f276b9a4b5f79faa12da20b.camel@mediatek.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c416e8ca-8cec-4914-84e6-08da5aaf9130
X-MS-TrafficTypeDiagnostic: BL1PR12MB5875:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QsKF1XZdcW0qq48bWg8TaFRO+vR0OIxwF8qbjYcIYfYJeDX1v3oh4A+qf47hcrcutTrd3DeB9HQt6UUBl/h7kAM5JO2Owy+egp0PEZME3HSsqFITYq/BZ8/lTTmWygmxvkJlwHxBb8JNvVO6azAt73XPjEWXqBSMZs6y3a3mm8IhOxwhC+0Tf3UP6KzbhXOFvq+rVP/lyVxlsx8s8kYbed+i/g7/o8c6ZT5CO8CaN+KkOQexWWAEbFNXBvHxaK5Q19kZJ+sY7yu9Sj7RyiGwBySXHjZ3xellaWUJJoyfcWQ2I/e1zSsLfAvrSVEbzscE3d33Erjatal7LRZ2wKlum3+t8X/NUsOWxG9IKIc0Ob8DgiTnRQOqICosED8JXBdODpGIHgxgwBNR6Z4p8FSdoC9WwpodnIqvS+v5Odqe3MhCZuJSIa7bDpvT4fsLlAffo1UxjB7UxVRMAxg/8FI89KKNs7vw6Xf1ynNeeDzmuteLxuvGhBdzQmI8ff3XKmdpayeWrHH7N58S9/OwAG0j5oP2BRQr4QrQ4D7CWu/pjtK4wz7vbN3ivE8NQMygfAY9y1km/QyoXLbHSsbSkXqc7zPBL12acQuPnx4d2CnoPgjd8JEEWSj0M4xcJKeQcEwMusppi8DtK9bWNdou26yt0Z4R4vJazYSx2g6fBoINfzKpsJuGdQ+XfXuUTo3DKH5KiD6RB9WJ/GkCDt9l9cP/zKN5Xhre0okR7xrHbbQ6Ela/V9EK5HWvCJ12Kte2++6R0vLxRoZD1/J5+DDUWKrYTULpXnOCqrvYVlxdI8grozE7jGRVqFLChr8zRRqjvWT6/zEkNP0Z6FWfagajuf56hU0sXtxrIM2lofzx2jh2Ugc=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(346002)(136003)(36840700001)(46966006)(40470700004)(8936002)(316002)(54906003)(6916009)(36860700001)(186003)(82310400005)(426003)(336012)(47076005)(7406005)(40460700003)(33716001)(4326008)(7416002)(9686003)(8676002)(82740400003)(356005)(5660300002)(81166007)(40480700001)(26005)(83380400001)(55016003)(2906002)(41300700001)(86362001)(478600001)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 15:45:32.6280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c416e8ca-8cec-4914-84e6-08da5aaf9130
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5875
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 05:33:16PM +0800, Yong Wu wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Wed, 2022-06-29 at 12:47 -0700, Nicolin Chen wrote:
> > On Fri, Jun 24, 2022 at 03:19:43PM -0300, Jason Gunthorpe wrote:
> > > On Fri, Jun 24, 2022 at 06:35:49PM +0800, Yong Wu wrote:
> > >
> > > > > > It's not used in VFIO context. "return 0" just satisfy the
> > > > > > iommu
> > > > > > framework to go ahead. and yes, here we only allow the shared
> > > > > > "mapping-domain" (All the devices share a domain created
> > > > > > internally).
> > >
> > > What part of the iommu framework is trying to attach a domain and
> > > wants to see success when the domain was not actually attached ?
> > >
> > > > > What prevent this driver from being used in VFIO context?
> > > >
> > > > Nothing prevent this. Just I didn't test.
> > >
> > > This is why it is wrong to return success here.
> >
> > Hi Yong, would you or someone you know be able to confirm whether
> > this "return 0" is still a must or not?
> >
> > Considering that it's an old 32-bit platform for MTK, if it would
> > take time to do so, I'd like to drop the change in MTK driver and
> > note in commit log for you or other MTK folks to change in future.
> 
> Yes. Please help drop the change in this file.
> 
> Sorry I don't have the board at hand right now and I could not list the
> backtrace where this is needed(should be bus_iommu_probe from the
> previous debug...)

OK. Thanks for the reply.
