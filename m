Return-Path: <kvm+bounces-3653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C068806421
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 02:29:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C764128226C
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 01:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B4810EC;
	Wed,  6 Dec 2023 01:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EYOpwdiG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158B8196;
	Tue,  5 Dec 2023 17:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701826184; x=1733362184;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vrj+J+AHmWTcxMHp2hp8EcjWBMBrsRkzU94w0qq0WZ0=;
  b=EYOpwdiG1ZV++yV3cbBEpSy3+ufZ3SNc8xbOKpF8Ruo5xU+1TYllFlt1
   ISVCAsCcUBfwa2Ea0kvExZOYXuDfGl3Y9jyueDRHhMV0DGaF+AxQ66dM2
   SHY+WGHOiet+9UCLu0J0+Ha4ZlSz0atkr2PUx0YMsBeYlI7KgBV13JEIl
   +wbzAjfGwd2fw7li9xdD+UZD1Ps6irzOghzEbJbw/BS4MOCGSHZctYnSw
   Fdmmq9SGs0n8Qbcp7oEdMARYbUXshS+slIWuYbZWP1xXJEQMCpfWh/FDw
   WnTFYbhH6YMUqkk0u4C1Vc+gztDrV4e2iyE8Y67MU/yoGWbmw4iKadv0f
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="1077096"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="1077096"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 17:29:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="774821012"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="774821012"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 17:29:43 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 17:29:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 17:29:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 17:29:42 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 17:29:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkVCBtSN+5IzQ3EK6n20f5DsopKoC8DG8/lk6AiGmKTQ2q23MWH802F3XZvOlrFJwZ2Hc7rbtnHavZ6A8ziSHC5qhWOMwyFO522/FuEFfSAUjx++5B0w0HhSZyKjsWihitewj3/t0pzEFQDXsSc8NpVnGtw4NDQpxNU9NpsSPgBQjb4TXEmb37/oHqtLp1XaXvnnmg1s7dHwoaBz8X/9Ax2sQwoU5KGjvGCpsokHB64duJfwK0wWho2NfAcEV4H0ZqUn2PECg53h6len8hT7VqN9vBeB0KqyLUQNFn9tg0hnm2rDPISKInC0PNg5iOa9Wnn1WT2IZNhMawKztRQ4YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNL+rj5bnh3gYaAPsO3ePpEHDFNtqh1Kr0pCJBxWr6U=;
 b=YvyDFZdBPcenZqC9Ga6FggsFRVqahCBd626MVqLNpiJAEanwLdH7a8+Pe0n+mDsNPjZWN4EcMrmfAJHR2bUU44aGZFWIJgpLdBVLfCog704dHa7qXoIpIxlML1PcFES1MgBTwWsWcI8xxlhrt5cfqoCQ0jEEnPbOrUdSfzKEdyLO8E6aH2dB8JCrlHnl4YZz2BogiqTUpn1qspXopOZJDP9cbIxJpNnaRl8waPaWAXMqHvGYkH/UkcDGzmsgg2xzV27AOuYPOErxhn98BhdgDs1bDDfWl2QFp3nYPRT7bjv0IFBMMEeOSIUzq9S96Wy7Oybrt2a/Gxwx5sG0NKAtpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN6PR11MB8220.namprd11.prod.outlook.com (2603:10b6:208:478::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.34; Wed, 6 Dec 2023 01:29:40 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 01:29:40 +0000
Date: Wed, 6 Dec 2023 09:00:37 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
	<will@kernel.org>, <robin.murphy@arm.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <dwmw2@infradead.org>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH 11/42] iommu: Add new domain op cache_invalidate_kvm
Message-ID: <ZW/HtdqoSxhjo1tR@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092041.14084-1-yan.y.zhao@intel.com>
 <20231204150945.GF1493156@nvidia.com>
 <ZW7F3AJZe7vrqzcy@yzhao56-desk.sh.intel.com>
 <20231205145227.GD2787277@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231205145227.GD2787277@nvidia.com>
X-ClientProxiedBy: SI1PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN6PR11MB8220:EE_
X-MS-Office365-Filtering-Correlation-Id: 985d1acd-a66a-4871-15ec-08dbf5fad0d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZRxbQuj8CdxJTtFrOaXP+sewKTW/KaTPTxIPz1HtGVt3rS6cmZi8TwbBOfqkLz84vaGlJssFf5EzMJ/7joiuRYT0A7juMWTkRUzw+wlV/DX6VHTGniQx6+QF7s0mROnRkLUGnO+zGxoerRcrw+MRSZ7OB4IHgvibmSDHxAkZ2bxuRBND9lpLdIoYXnJchnfEnWKfLkUqUsYYXiHuyz1RGDNhxwCzyRm9WaB839oSi/iQGcrnh/sGeX5mI/QJ1LQOd4Lal/DAlW7ToCTCg+qwrqx/QfI1/QrOPDa/E1hDkstHk3VnvNQnLLJPX1kyHWuXwbZ3/t3YcDQiNXylr+23aFM5qEEXbxzsCjOALChqIaJFbmoWe0qq9tEAFymqqQAZ+qbgnXQKjlvso9kTB89C3kgwip65BqvdGT8Hh/WMZ+ch+Dnu3V5Jz3nukgmeID293zy6+OSA3j5R+ljV6uzE55mjyzZMUPF988rDRzyIrNW6xK8B1smkEt0zY+0rTO0MAP42RAfjFkz/7iB+YTexwqwa8dx4YwGHcsP6bVHT8QfVcChG+UCg0peOBR+WVzE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(366004)(376002)(136003)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(8936002)(83380400001)(41300700001)(8676002)(4326008)(82960400001)(86362001)(38100700002)(2906002)(3450700001)(7416002)(5660300002)(6506007)(6666004)(26005)(478600001)(6486002)(6512007)(6916009)(66946007)(66556008)(66476007)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bJkRN6toTAf1siclQXpTPQAtvONbXZh06LwmaM2k6986Byju86KJ9SbDC/qD?=
 =?us-ascii?Q?QLoBdPJ5TptStBbzXzLHiCCzHtnBb8lU6MlZj/nIeVkfJjJHt8Qu+yNMVSjQ?=
 =?us-ascii?Q?TKeF0X1BuLfCdiEH2n1huAt3IfGwOHLLP/jY/weBYI/UPPcp6Ca/mTNuAPu1?=
 =?us-ascii?Q?N2RByCOcTa+hFodBFwI5DbFSg8zMDpcPbLYZLjoW6of7mWkNGkqcGssI/Il/?=
 =?us-ascii?Q?rJ5sW6hb9Rv1g0YcN8NMWIkp+dlqsdzSm3PJdAWCXgrXvfy5+2EUnLLh17zo?=
 =?us-ascii?Q?+BqikrK3IaN83/eILEoGwwzj89uqqDHBSpDV98t2nSpRhXsdHIdOBKIxKe9y?=
 =?us-ascii?Q?46gDyk983RuwN/dB3N3LOsO8lX3Icr+oh2zu/t8puejSg+7csOk0gbd+Hnqp?=
 =?us-ascii?Q?VWtFs2R9+hggZjwNK4JrHnjUbBawPqeE7U3nKPuBpplmaNypC51z/gCZfLPx?=
 =?us-ascii?Q?EerxDXkfupjLI2vpYXpH6wNs6Jfgk3W2uWRt3JJVZwWNQRd7ftzpDS+pSXIV?=
 =?us-ascii?Q?PugFpjvh7BNq3+iux7uTcvhgx2P1F6YkptksW4+uJOCUFnXhtIt6eXr+Y4R9?=
 =?us-ascii?Q?nlOblIneuegXzFKJbwbWuv8I5KnC3PLLKqZB4zN2+KILQwkf+2+GGnmYWJpZ?=
 =?us-ascii?Q?wE6BFHXtukRrMHjsajT67yjITAyKQfqjMtBt1l/M7S/LenIeRMFDo+zKxuj9?=
 =?us-ascii?Q?DxWXmWlaY8ib1Z+lqB30iXM6hgdA1900kZj7PH5fdede20RJSTU2xQO8aBf7?=
 =?us-ascii?Q?teeWbmqqro2+8P9WEcwG60rmUAVuXoNwdwQL8Tx9XywjOMINiI9SYfy36KLe?=
 =?us-ascii?Q?rAXXxhGtbDFh4W7VfT/1gCCHSpp9papM/SNi0xBsv/2z5BSJbbZCrHd/z06X?=
 =?us-ascii?Q?5iPYYpclFSbDV/6cHOiBzlf99kz59dJIYGaXsX9hY2GMhNZX/orjUV7qFCyV?=
 =?us-ascii?Q?DKy807un6+jygAGpQyGNG2TmImEntjbUMNDW8v9daoqFw3sa8uuHXsjQhr1R?=
 =?us-ascii?Q?+mqfBmrdNRCuYOfpcivV8q3P8noGL4MNiXMEbNPslUpNGh2hv/HR8lVb0Pmk?=
 =?us-ascii?Q?v0tEe3vgGotGF+Ee4J9JzKGQcmKOoWJFG+QnTsHH2UFAASyKi22ZgT4i002H?=
 =?us-ascii?Q?DwM9MbfDplfxP1jmybvR7Xah8rwnNTBozKGYkFxFFfqf9Rxfj9CMj1TPC7r2?=
 =?us-ascii?Q?Kv+mcNol9KFOYpYv2oQ62WUGn6a/+S8U9UgUypoN9bZFGuvO3y6BAzww4xdF?=
 =?us-ascii?Q?okvKpQl0ZJa1gzJkRLgh0J45SZUTh1FO/rIdnWfx4B4KPZfl5UMpnnLOScJZ?=
 =?us-ascii?Q?rrZudCuZUJB+Er/RV4R0JPQJsuYU8UxzrehYsGnM9fDw4xly4ve240+nd0xt?=
 =?us-ascii?Q?YHqnch0loZjJuUYuEabG6O94fn7mhF96/SCS/U4ogPc1691j9M+kAbQThp3C?=
 =?us-ascii?Q?X/IO/G0K++AIDSTzwNd+zoxNCHay+ewQcL4j2zJQVakfvmsaOUwDfTPuoFB9?=
 =?us-ascii?Q?xB2Q1AXos9GJA30G9TZFDGMwSxgAdW29VG0Eapff2jKnzBw7BRWVNky8ACEo?=
 =?us-ascii?Q?CAO1hy0KwuGLG1iP/xX7nl9IaxZff39NS5cqPVWT2MwXiBLbi2IKIIhUi/Pq?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 985d1acd-a66a-4871-15ec-08dbf5fad0d3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 01:29:39.8919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ob1zCannUR//6+mQLD5u5rmjvP+GNommbXVumzhc66wEUaQ5G0DqNQPHH12cobn9XJVhtFFJTJknnstgtvhM5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8220
X-OriginatorOrg: intel.com

On Tue, Dec 05, 2023 at 10:52:27AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 05, 2023 at 02:40:28PM +0800, Yan Zhao wrote:
> > On Mon, Dec 04, 2023 at 11:09:45AM -0400, Jason Gunthorpe wrote:
> > > On Sat, Dec 02, 2023 at 05:20:41PM +0800, Yan Zhao wrote:
> > > > On KVM invalidates mappings that are shared to IOMMU stage 2 paging
> > > > structures, IOMMU driver needs to invalidate hardware TLBs accordingly.
> > > > 
> > > > The new op cache_invalidate_kvm is called from IOMMUFD to invalidate
> > > > hardware TLBs upon receiving invalidation notifications from KVM.
> > > 
> > > Why?
> > > 
> > > SVA hooks the invalidation directly to the mm, shouldn't KVM also hook
> > > the invalidation directly from the kvm? Why do we need to call a chain
> > > of function pointers? iommufd isn't adding any value in the chain
> > > here.
> > Do you prefer IOMMU vendor driver to register as importer to KVM directly?
> > Then IOMMUFD just passes "struct kvm_tdp_fd" to IOMMU vendor driver for domain
> > creation.
> 
> Yes, this is what we did for SVA
> 
> Function pointers are slow these days, so it is preferred to go
> directly.

Ok. Will do in this way. thanks!

