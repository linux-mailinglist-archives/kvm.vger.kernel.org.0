Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB22469963
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 15:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344553AbhLFOtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 09:49:07 -0500
Received: from mail-bn8nam11on2084.outbound.protection.outlook.com ([40.107.236.84]:58665
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237563AbhLFOtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 09:49:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jb+WBilqQ4MHkBq7ipfq1lCvHSW9vjRNPxTv1F1Dt733JP6L8u2hF4tD260SB8creHc6bV8VR4uj2HC8MsL/lotPxMYi1rOBy2HZtw2x9tkwE5HUsfBz7beFLcb3rxvZXKkEDy8QsD+3GhwhQ3M2ux8/Nq7GtQQn4uiPeYvL8X1ORyw2+dh9vTN2kMnJXAM8JYDnDSPVOjyxFa5UQ0p6vFv1xOM3VKPOpSUOCNnoKcTb8ig3lbqbaSU7j+a6H9ji/VGcUbDJEmQuP1gLk7XNbyg3wj7OYeRMhc4xTl9pNW0H+W5VeU+J5HLJP7rFIzKdq3Lm7WIXcB+n6Qgln68GXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zcOBMliJctQvmvU0NgKzAKiFfxlXjnZUpemdDnxDiU=;
 b=d5oVaipgYDZEbG+sqHUAs00JODnW0BTw0cwefij5zrewU2WAeVQn3tFPmkXVH94bpEN8zc8ZguBpreVPFe7KoiBoTSCLDKTMDMYTg+5DlQ8OcG95d6cKkQpe8tMdXG1qImoMcSBmz5q5ENiFfxiei/gdvBat2YYLUOS42dxboDemHUqs2LbCHnAsCex/w5C3yz/0Jx4oGrTuaNoywh49fdpj3/s3mo4nbXPWBNEdOGmPDNtx6+LPDl0HMTAtc4c0PJZu1xcOosfMhwIcTrZrR7237I40OqaYlFgofO/jM97nGDOVmzN3X1Ly/lesBBhpM4fouAp8mR/coaO7HC6+jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zcOBMliJctQvmvU0NgKzAKiFfxlXjnZUpemdDnxDiU=;
 b=AwHSYtQQoDmflam2Tmz+F04HEr7gDjVFg/kg+jeYM3y462n4oxMCC/nfPuCoAURo7Sx3mDiZ5WYsj/fDxUuLv+Lt7/3d6g25zLcu1voRXtzJx45N3osrWVhi5Dn4Lxpt5uew0OJBPMNkRm5zR89ScKz/BPgrtjZLvAHbSU2qeX3ykZzGr7ayI9STYMgSyaTi0qZN6YDym65XWY8bCDe3Pddixa7LYngZw6aGcygGVg+OsuLRiRgdjY+7c7Mn+tIdStNNESXl4d9jZk/EIlVWnXnwZYVmt2IeOk+4iS6ILPM/ox4jCsT96j07eudTlAYOnSp2aXo3hT9YOtv8N9xGFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5224.namprd12.prod.outlook.com (2603:10b6:208:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 14:45:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 14:45:36 +0000
Date:   Mon, 6 Dec 2021 10:45:35 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/18] driver core: platform: Rename
 platform_dma_configure()
Message-ID: <20211206144535.GB4670@nvidia.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-4-baolu.lu@linux.intel.com>
 <Ya3BYxrgkNK3kbGI@kroah.com>
 <Ya4abbx5M31LYd3N@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya4abbx5M31LYd3N@infradead.org>
X-ClientProxiedBy: BLAPR03CA0040.namprd03.prod.outlook.com
 (2603:10b6:208:32d::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0040.namprd03.prod.outlook.com (2603:10b6:208:32d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Mon, 6 Dec 2021 14:45:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1muFFH-008wl3-DV; Mon, 06 Dec 2021 10:45:35 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c11d5041-6440-4dfc-2389-08d9b8c7107a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5224:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5224D339FBC7BC1ABBCF65F2C26D9@BL1PR12MB5224.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ByxporPBOPBck18dNWYqadQh0ngSIHrw2vWDNBX1x2EXnf73YVek7gPLANtHgzrsQoVpRFpG4gMpGuh7Tpgf2SSe2WWOtBewfwbtYWL9i5qhuYriabtw960yQeTNfg6X76tTkMapgamY3rf/ZqxuVGkboPGrgCMSa6+j7C3THqQjOcY89gJ6E03EPaUEroh9B3wWm44N1n/EbouqiOkoSW5znR3yE6dUwflB0Zmm14lCSF62C0xwvDf0imzCLzBa+fHMASBkEd7Hz11nDBk9o1F81FJbAaEhcjI5ws2Fr7B5GHQ1PN83CgK8JWOjO3LQdDpZl7HYdzVo0TiqLnKw6bRoFgZtyLhqVjK06d6gSIMErhQSixy6ueReyIIIFDxROFzmrMqAsvoOlL4YCyaXx9TI4VvwAPWnEBkOLzZOQdeRhh01V10n4ZcV60hkaCoNsMxhGIN6khDv9FRepU501Dhi0qDZVlMe7QaR54CQnDs6eB+9g4SZtRTtDXQUmlL2tRUcEd58+42XUUTRxysymopXyf1cxhCVUvUe0GdWmFijcMNsnuPgOCfVxQMXJC9F04WtRNzAjakTLVb4fAOj38Pz4wcPo9hYK90Bn8F18uevN36YucL5oKnsctmPPkbpw1vkVcFtDasZg120WpYseA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9746002)(4326008)(9786002)(508600001)(4744005)(316002)(6916009)(33656002)(1076003)(66476007)(66556008)(7416002)(186003)(54906003)(36756003)(426003)(38100700002)(66946007)(8936002)(2616005)(8676002)(2906002)(86362001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xm3id8NP6TpfRZLglNj8LG/3Gy+KDXzfylN6YczpWt572VZ/n810iiTcrlF5?=
 =?us-ascii?Q?NFCVXo/uvo5nCm/Z4RnM7LE0uEEbN1Miqauj2H5pbDIFuWYY3bcKZqt5MVEU?=
 =?us-ascii?Q?Y3bLbdwK9lG+iORI+N3lRg+Ebb2fNdmgBpsp135K2c0IdAp2fg30WcrnHvJx?=
 =?us-ascii?Q?BE48Ye63DLzIf+dFuMa5JBe8U95IoPMuiL4U2O/2j/tor9u2BVotcG0WS9dQ?=
 =?us-ascii?Q?SElVsJ28URgWijdHXHwjy7FfAn24IVfghqKZ1KdNzT8LAN1HHYvkvYVJhMRT?=
 =?us-ascii?Q?iZk5sYWM4/QkoYJ9b+zMytrId5O/8MQdNIdpPV/OiCnd5i118EiF57eBq/BX?=
 =?us-ascii?Q?+IPVEysxS9PLroeVMkQBfjekGwsMv9K5KJ+SzvW9giz9rTUPJpoTJKA2NF8b?=
 =?us-ascii?Q?anRFo7Hh1jgQ7NG6limL2Ys64zBZZZ0XsjOg2PLedOHqTQdVww2nmlS51iH9?=
 =?us-ascii?Q?JgjivRvVlSrZ+wqgYWwc4gD5VVKwR0bSbwPTgCFYhk6UNSWcDsi7GoJyulJd?=
 =?us-ascii?Q?gLSxUpV5vDxjJomAl2Apk2Wxgzk+5KCctn7JuLBakLRU2yaljpMPO8qprAQh?=
 =?us-ascii?Q?hulR6BuZfScgQPWIaqmPh9hGQcF4E4uf3b3G6SiTwVI8B1BjY/0au8JRqY94?=
 =?us-ascii?Q?/fsqbdnmZtxBby7z2F+JdCHkkMML+dyyfUIZinNJF/HV3UxuVTeszh7eTP0r?=
 =?us-ascii?Q?jl6cIelpGOl561juqvp93U+8QTEseeXAYTfjFS7yDiUILK8QM3RSW8B6lOVX?=
 =?us-ascii?Q?l+hF9a9hti8+2CGgJ1N7d5pY3p2ANcJ8R14KZydahUaWSShoJ9XGnrVFiDsz?=
 =?us-ascii?Q?vkVzIcJC/rsklfuRph+VjRT7q4iGqnf0I+ixBMaz570J62JOAaDF/UXfT3by?=
 =?us-ascii?Q?WK4eSDtBuFW2awJ2HRq4/rsqzB5yOp95VV+Vd61fRQmZ4DW8Jh+5fZyTj77A?=
 =?us-ascii?Q?6Lil8TDFKp+dD3M9S9PU+sZXcxjG3+znb2MLFPXDRfYvt1a0w+04K0KiHEwu?=
 =?us-ascii?Q?v9qXDuUuiVAvjNGi942ZuxeFe8sV0Hhr2sYrQZgbqj+jhbyF0tZcQzixsiPY?=
 =?us-ascii?Q?HSpRCoX4+15q6t6kJSZcAaRItDbJL5QR0X9HYalD9gG6OWJoor5NxIBajyda?=
 =?us-ascii?Q?FLUzWEZrWMYqUELfjw+sT98xakYPMX+RhvvWR2oblCZ8Nu/XAdTTz3snUX5X?=
 =?us-ascii?Q?U0bKVmmTxvl0Khr1HdRTIfU1gzgpulj06V6pdN+t79l8C81YClf9w47B5Ytg?=
 =?us-ascii?Q?2lS/chWz2ksIl/St8dBg+41Bc7Tx/jDclgAb7cUz3r1V4pjrNkNDp5N9hquI?=
 =?us-ascii?Q?jAvEqfHFO/SKe3FCFe4tOBwni7sE27IbTs/9E7ojRaQAyRA50NOEr8kMdSnL?=
 =?us-ascii?Q?OVVQ4RqM2271MZ2eOh4SCZnG75etEhs7Wf6tpJNBdgnyPy5jl5IB4l4SUfU4?=
 =?us-ascii?Q?rizYH9Sk10mlB1Tf1ho/cXWxo6RQ7ulmoh6DxdKsG7Tv7WZ5LgN+L2q24GuM?=
 =?us-ascii?Q?bP/6/J6/OAuZsJMmZ/Rf6sedIzQJVkrR4hMp+lrhRAcI33zw91ak5Chqlq2E?=
 =?us-ascii?Q?WC507GvF0/5o73oQ4f4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c11d5041-6440-4dfc-2389-08d9b8c7107a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 14:45:36.6434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvIg4lmCMSInrDtONKvkS/Yymr9nCbdcWNqr8uSZk1qqEjZGia+lH8eT4/uOVntT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5224
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 06:13:01AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 06, 2021 at 08:53:07AM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Dec 06, 2021 at 09:58:48AM +0800, Lu Baolu wrote:
> > > The platform_dma_configure() is shared between platform and amba bus
> > > drivers. Rename the common helper to firmware_dma_configure() so that
> > > both platform and amba bus drivers could customize their dma_configure
> > > callbacks.
> > 
> > Please, if you are going to call these functions "firmware_" then move
> > them to the drivers/firmware/ location, they do not belong in
> > drivers/base/platform.c anymore, right?
> 
> firmware seems rather misnamed anyway, amba doesn't reall have anything
> to do with "firmware".

IIRC the only thing this function does is touch ACPI and OF stuff?
Isn't that firmware?

AFAICT amba uses this because AMBA devices might be linked to DT
descriptions?

Jason
