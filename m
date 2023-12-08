Return-Path: <kvm+bounces-3963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA48B80AD49
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:43:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1B9A281BEF
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BF25026C;
	Fri,  8 Dec 2023 19:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kj5aqDyO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9AC1987;
	Fri,  8 Dec 2023 11:43:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8ip5vEtoh+mhiu6fsKg8WsaqJDjjcJlHbf8Jvt3nGsOnq7RubVS/0ISQAEev6iDzkNnaAIUb/ptEn3e5iSfQ4rqRKGQoF1ubRx0p1ARXQxHCqFAI07oRFIEqqNdraFeSM25JUMnZwhONNAqJaZ5i6lQ/DU/DomRWbo2u2ldj/7YlItDLLgEhr5Y65le41VujUWJrmrAavkgb2aonqOczge7YqMyNsBr9dnv1z5fa+tou+5pHnUh2LR8xmXYQUM1zpT8VZQsQjBFzzuu8q1okPJwCGcGqy6tX+FEtnWyqrFsZWEjsLtz6+3CVuCXbjoT5pDbYy2km0mrfWKDJjqjQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfcOYssrhXU2rmR0yFAXeFVJhYpGYqZHLLKwGlJ9tEQ=;
 b=PpbH2j7Al6dsNVc3if66NythUrGkFFDAXrahJHbXRtkP1uX/WzFgc29+qz0pOv0EnbsOxcGQBSjw8wIt27dWaCboouCaMVdJH9UQw4bXIUNJSwmhJKYitp10VvEA/I4sLrR7g1rU1J6AFmAkRcnjwV4fDSx5E72MVUxHdWkPtdCaG9HlZyRvKAeecdwtQUWXg++IPoXCloO5RzYVFgNUREKHlePNTWGU/fN+azyBD4jYGcLKVsRGRTMIjWqe/e7ErPI9eN9TfvA45evK+ykZIE4GUHyuAU6rB91VbOfQxS6RQ4L8bGdsfyXCW/T7PO5Dc0wCDhogrcst5S35MZYLPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfcOYssrhXU2rmR0yFAXeFVJhYpGYqZHLLKwGlJ9tEQ=;
 b=kj5aqDyO7iMeakN9X/CpeM47jFITW3nDduZZuzQc8wNNz0E8WM/de5waWx9v6ery6HU08Mj5Hab+7Xrj2Yr7FKd1LqxvNUca6RyNgnvzzT8z/IuHdV/ugEAJyAWKz2NzhuPCdx7Me6q3oWuETOIDXC0AnQxHk6z0rRl5WGLM1hswfkO5SJ+BoF0KMjCLUXigok5eXICiUPedV1zW3QUWRNqzBjXMKIK1N7VxKaYjRvWtvbH/yFkNK+3+182TcXwoXfyZ6h2pGmOvpK1rsoPSjGzakuSQhZE2kulSJMtXihU6IoLGMBeLvLC4yhF5+mCrxcXZoLm8hcxt+AWBzB6VSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV3PR12MB9216.namprd12.prod.outlook.com (2603:10b6:408:1a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 19:43:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.038; Fri, 8 Dec 2023
 19:43:45 +0000
Date: Fri, 8 Dec 2023 15:43:44 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jim Harris <jim.harris@samsung.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ben@nvidia.com" <ben@nvidia.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Message-ID: <20231208194344.GT2692119@nvidia.com>
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
 <ZXJI5+f8bUelVXqu@ubuntu>
 <20231207162148.2631fa58.alex.williamson@redhat.com>
 <20231207234810.GN2692119@nvidia.com>
 <ZXNUqoLgKLZLDluH@bgt-140510-bm01.eng.stellus.in>
 <20231208174109.GQ2692119@nvidia.com>
 <ZXNZdXgw0xwGtn4g@bgt-140510-bm01.eng.stellus.in>
 <20231208180157.GR2692119@nvidia.com>
 <20231208111215.5a47090e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231208111215.5a47090e.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR19CA0007.namprd19.prod.outlook.com
 (2603:10b6:208:178::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV3PR12MB9216:EE_
X-MS-Office365-Filtering-Correlation-Id: 96469852-f7ee-4a83-7b5e-08dbf825fd74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CuDrOu7qN5gofjy5rrj8oCsaZ/Q7D/l0JJQ3nHjFni271K9FZ/6FVFyG6eLlHrcOF+ZPy9rKMOgKB8U7Vn9HDEpfN3ZQI349InK7z+2CiI0GZgeVA9+qKzWJ3uk0VfLsygXF2IIGzgZx6dHHG8JVNW1HUOMl9BxAm8PbyzsKoeF/HA6xcBk+t4xfCnocKdadfAIdqFlzfPuNpRibMqeny3jBGQ6GgAf3r9pKPleOOenmPdWVSqu+nvhycUhYLwc8JRjDfW8oo4Jp7ZDgbe0UrxzCjZ5ybp+SAOsIhj02aJBlOpjuTLp1E8X9i6NrblbUcIw9gIynXFqEFf9q1b2xGlvyiBDj5iPyx+bc62FxmyYpXdgVxU3mqXUXwDlDHK/h4F0s4inmI3B6m/rgqtUl2rR2wvzX4+k/pxycvZ6YWJEB6nL4UAP1eADHSjhTilPLtZIR3qBegq2skKaBuxHmQjQuTEZ83+rCOyKyUS/OBf60qN4cCzmBNgw4ZoSJFmv2SfjtaaS5RbY8lKihyhh5esuoZup22i2mj4vLboHjKuGoj3DBxdSvrjXTnJJRtiSH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(366004)(376002)(346002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(66556008)(66476007)(316002)(6506007)(478600001)(6916009)(54906003)(66946007)(5660300002)(6486002)(6512007)(8936002)(8676002)(4326008)(2616005)(1076003)(26005)(33656002)(86362001)(41300700001)(36756003)(2906002)(83380400001)(107886003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?czJpq+nENpWrRO1MVImNvoozNsh+/6Kr6Dy2dLsON2NK5gdnNsaBi3jjyXVT?=
 =?us-ascii?Q?j89F6OO7nY0nzWX56CqIKEuAh2BtyCp2nqiJvR3B97qtQseayOsCwvbl5GVt?=
 =?us-ascii?Q?4R1l0StdU2TtDx/w5G4EdXrXeQQB0A/9BsgD9V5vlis91l1xZXlGhzakp1Ld?=
 =?us-ascii?Q?t+A8ft+xtmeXBxD9s2cePgipjeCCNxkPdp26ciz2F9X7vcSrT9bPWHOdOAce?=
 =?us-ascii?Q?bB/U4CCc5tVeLe/qMH3xOzYqDiAEUv67yUAvP3T2TCOdLFcvoDwB6EF9eFlF?=
 =?us-ascii?Q?Nen3c+adT+DTt5bJMcY6qjhu5uw/pqWg4pMIJCsfOAmXlaJiQwKV6nD0KG9k?=
 =?us-ascii?Q?+8/jAFLbx0hYBQRDz0wJfyWFwDCdqIBJH1NWz+2A9oM3z2yqTJQ8HqECo+nP?=
 =?us-ascii?Q?32ZEAbr6Kxm7wMZzTwF+WHJgPAYr66lThg2hC9IgpIkvgDGYDgeMchwQLgf1?=
 =?us-ascii?Q?Fg5l9L5waSYwnGzzibeO75tyNr/tH2oJg3HEpvavVZrkhrxSSUUIY9iVyNYT?=
 =?us-ascii?Q?K3f1v8oJ92KuP+lKO3OmWlGElBYotzNg21MySHYQEF+0Kfk95RMES5AFJpgn?=
 =?us-ascii?Q?QNRjSCM/iwP6lCAMgjuvGOyuHDNn1iHFXsAuiSJigpABMQ/13LJS4XB8Fr65?=
 =?us-ascii?Q?0EeMcfkbcx4IvKNpksSte6Dwyhck0fWvwnSAkPe1B+5BE1EkOmOk2LbM+lSa?=
 =?us-ascii?Q?4uoPCkOC2Fo7ipgqU3MdmFzfqujo0kKgraLEMH84K4sgUtnd56kIfGY69luE?=
 =?us-ascii?Q?SmMUGAja73LSl3yVsh+8mIJ2yCeBTF6ActU5AhGriqGHAhZDCUUnO5G9rn+0?=
 =?us-ascii?Q?TcZpP2Cgy8ChDfIdYALWS6qzp+5qUhHG/mffnWwtX0cPfPP/56+7dPNpgiHa?=
 =?us-ascii?Q?/ZMDkX3f7qub9KFpfrFeF7pJKgeCdHqRkQjCVr+oMD/nUWU0h2cWP0BZRoPI?=
 =?us-ascii?Q?/L4cKyaMXjTAjlXu/wJ1eaSMShpfcwaY6+q/vrSmjthKbB0tnyLYIIIE3yA3?=
 =?us-ascii?Q?UCBJMkN4amMmriDYM8Nl85y5GRI3own/DMv4rY21muIOCot6368r4n/EicDm?=
 =?us-ascii?Q?1V+tWYI0VvPjd85QqToBMUTqXYJXvOIWjTD8nvIL+UQE13FqjEwF7ohHFHCZ?=
 =?us-ascii?Q?k8UTFDIv2BsfQvX9kk7pe//K/S/nnMFeInL8/mEojQoUtav86AhY79FK2ujI?=
 =?us-ascii?Q?MIQxUycmN8tG1YqzSaVRUQu7rdsLewWChsWlZIndZEtIZgugRydxPlgnAyQ5?=
 =?us-ascii?Q?rk6fk8G+uXLSei//pGxFo7yGp59cZeJ/RlEAMkzqan34ifXzGGEAllSOqwJO?=
 =?us-ascii?Q?ZAggdcbZlKw+5o6ZK3Efqsoqkhy4WukN6w11pghJJHPJ49yjyVdeLHfTUvWV?=
 =?us-ascii?Q?AxlwYxAX19ZxWTZ6A3KB/0yBeD2OMtV8tqrTPy3VM10zFONzdGNY50mvvknD?=
 =?us-ascii?Q?ZA6vmZLfKmtSQAqo2+cJGe2///ccgMoFFNAH3ekgAV7XN2qOx3FNf0fcI0Vs?=
 =?us-ascii?Q?GhcNKGyriGDHTVojJf6SJd8fKbX3jQtNMeoUyRkWEljyfAKWzU18f6ukgMvP?=
 =?us-ascii?Q?mLK0JEcevbEUIairMJpl4dwdCjfgmat6igmjpm0j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96469852-f7ee-4a83-7b5e-08dbf825fd74
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 19:43:45.4825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YgJFt/cN1nbobfEpRYnKPGCLIk3QTKKdD87sDtUqpe1qgOW15VCRfA+GJgNaSr7h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9216

On Fri, Dec 08, 2023 at 11:12:15AM -0700, Alex Williamson wrote:

> > > > avoided. But in that case RDMA knows the BAR memory is used only for
> > > > doorbell write so this is a reasonable thing to do.  
> > > 
> > > Yeah, this is exactly what SPDK (and DPDK) does today.  
> > 
> > To be clear, I mean we did it in the kernel.
> > 
> > When the device driver is removed we zap all the VMAs and install a
> > fault handler that installs the dummy page instead of SIGBUS
> > 
> > The application doesn't do anything, and this is how SPDK already will
> > be supporting device hot unplug of the RDMA drivers.
> 
> But I think you can only do that in the kernel because you understand
> the device uses those pages for doorbells and it's not a general
> purpose solution, right?
> 
> Perhaps a variant driver could do something similar for NVMe devices
> doorbell pages, but a device agnostic driver like vfio-pci would need
> to SIGBUS on access or else we risk significant data integrity issues.
> Thanks,

Yes, basically.

Might be interesting to consider having a VFIO FEATURE flag to opt
into SIGBUS or dummy page, perhaps even on a VMA by VMA basis.

Jason

