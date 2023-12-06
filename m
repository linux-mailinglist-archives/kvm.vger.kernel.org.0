Return-Path: <kvm+bounces-3651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9428380640C
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 02:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C05A51C21118
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 01:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1902410E1;
	Wed,  6 Dec 2023 01:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BAYUces9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6A61B9;
	Tue,  5 Dec 2023 17:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701825911; x=1733361911;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Dpb/wEAiGbc4H5m6AAJO2qz8HI2uMp8/qqZnsmjDgS0=;
  b=BAYUces9slazRD5Fm2my0bvLVbJQYDnPDGmQwxeOCsCV5JhHUVSum+4c
   PTje156/wxLkePScOcwKbKHfkzSoQX8p2ky7tHuipCeKyz9/ApOK+TAKe
   pnLGKzrZSTwc9ws+Ysuot5oiEu6NwcwMsVHFUPl3ch5Zhg4SCsTq2sOZZ
   bSTpKyJ6c0epxuSLQ0iT6pntezvWY0ZKCxhIGhGEBRf7UTvOExZXTzV1A
   6jvewWz/weNz78vo9TUiqnMyPEknWs33J89v9VGhxefuJYmi05PER3IVy
   3e3jnLt+BYtb7wLf2bHbBBgxykj6qR6TO6VdM8yMlaNy6NlO1ttCmyUAZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="391155163"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="391155163"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 17:24:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="771123434"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="771123434"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 17:24:56 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 17:24:54 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 17:24:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 17:24:54 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 17:24:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9n53WcK4ijE1FGwKvGEJ5iJN07DmiR468pqSKVmwUj+QWh4Upn0NU6S4wOl4GrjXFMPX+dm6vhVx+T73aqlPgVn2a0EwoxRGt/QYLNEmbdP2zOUMJbPvu5AvHYA7hROokBs2ZrqZQdK2nEeyHC2xi9f8AjLFycQmBUb75u5W9EGOD2td12F8Mt40H7Y23z50E1aTXaAuZNnS4//TZODTx1e1UvOecLyfH+rKPkSzNGQ5wSaCzfjv8xTLeBN5M/lMlhcoIP3SBUKf6IpVL+A3eC5kxmwVKMQ93bVtMCimmf0huTXLbG0Hw5VSj+3lCqTKuhvqXhS9G1B3x+Mw5QnJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BntUOtgkzrt5Hpr/iigoXv6Qv7dxdZYJc46e44sTMkw=;
 b=n6+gLmz9wpPvf37Fyi1TUucxKfdIe2l4kRHu+ckyK+K1275HiA6Nx3cdwgbk0blS19peNspRnJswb494O8DCN3zz4VoZmru8+Nwu69OcSWJsJQgzISzC1LJbcE7LnhOUQBVkXytI9JFmXg8mX32oKyWTjQkXxp7BdUy5AlIm8W5+o8JqlzDcx/3iv0eqg9rK6NoaKr1fhPwhsDO8k6DbhO8jJQpXre+BvR/QXmMKpJIqE8MK0dDKr2hagyQU8ydayUCtmFdLczjJhfU/J/w4Nzj1KZfk8MTPaMAIXjJgUv2CuK5t2cXEqMHEEbIfRAT5PTE3OyeWOaU6GtUtDO6fGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV8PR11MB8697.namprd11.prod.outlook.com (2603:10b6:408:1fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 01:24:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 01:24:51 +0000
Date: Wed, 6 Dec 2023 08:55:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
	<will@kernel.org>, <robin.murphy@arm.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <dwmw2@infradead.org>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH 16/42] iommufd: Enable device feature IOPF during
 device attachment to KVM HWPT
Message-ID: <ZW/Gk1Ili6uHBHYK@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092311.14392-1-yan.y.zhao@intel.com>
 <20231204183603.GN1493156@nvidia.com>
 <ZW7NwSCzswweHZh6@yzhao56-desk.sh.intel.com>
 <20231205145341.GF2787277@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231205145341.GF2787277@nvidia.com>
X-ClientProxiedBy: SG2P153CA0054.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::23)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV8PR11MB8697:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fe7d384-ea56-4006-c612-08dbf5fa24ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQhToq4+fGl+UXrxFFOk6B68/xXciWv7nRoAZCF/C1LlW1olwN/Bch7MJE+bRh5USdNvprVY+aQvgxCeQZxeAsddy4UMs9aSLqNWdTo6hncOCDL1lRrVqQ8R300CQpUbQUHXHJkwhXvJ1EzBQCXze7lCidFeCzk49ZDpBFmNhnSTzFwI69S9nFsjGJVp8bpoo2kyXw8bZwdRiD1c5fLNCx6TDUc+gjop456zeW4Bk/1X4+w/p44WkTG6UslEeaiaGYrHJAFvLRBrg0vulSrjlT2STzaMve/8X/uW8puzGBxfy51EmSMOmgpjNW4UUDfInigng68TrUzs7keeyohBgW3DaAcLZ46Z/1J1WcW2Z2YmUQDZfEB7fIAzrDKZF718vwaqVIwWnE15Gb75lA8Zav38xU6W2TWTErEjc7j/ZeqoMLUxpLOvuFXNTMbsCwqfFsFADuPXqcFuRBb/KhOCId8NbyvNxAklDAP0JYK/YL+g1pZTGT0nx1eHdjl+HWF1PrCAdqm2yJMiEuGedcpqLsUgB5Lc1QiPO5IoYoZy+xqaaDzUH1mejTegG4O66f9/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(376002)(396003)(346002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(4744005)(2906002)(3450700001)(5660300002)(7416002)(86362001)(41300700001)(38100700002)(82960400001)(6512007)(26005)(6506007)(6666004)(478600001)(6486002)(54906003)(316002)(83380400001)(66556008)(66476007)(66946007)(6916009)(4326008)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ahaMuA3tKE5DVCqmjISs2pYvtbwCiFST/TxIOPRXIANT7puqNo7ixcDpT2x/?=
 =?us-ascii?Q?5O6KUwOiRyZV5SyyLDpMK9nn6V/cL/r8zAshGAFUHYWOM/cwAI564Iv615Xv?=
 =?us-ascii?Q?zqrexPLwylkaBLhpRIAfHJSxvOjXV4TBPX92wgj4uFwN+8R4WXFKpTtQFR6m?=
 =?us-ascii?Q?F56NihhcqJN+GSrsZ5LouPuzdCGe314SfUTF52tjazGMPGGcjXGgTn1Jw+pc?=
 =?us-ascii?Q?OKGXIFQ6W+1aWLpbz/OwJJzBtSLxEUpkXUxsi06LITHqA+/eXVF9RL3MN62J?=
 =?us-ascii?Q?T4tqoDVlsAno7Spv+/QQZDSXCGq0MuX1J9nPF68wFlm8MElmST8T4LgzKnU4?=
 =?us-ascii?Q?bqK19mLtuNcR618JOkANM91L5JxQw+WQEiiwYkOrW/kDrlWllytA8kJ8gOHY?=
 =?us-ascii?Q?YOUG9Ue9izrttuin6RgktKhWoHdgl3LI6sPxpG2hnHrz3gr2zYFkbiG3vPoJ?=
 =?us-ascii?Q?xRZH5a2jw6K3eY1MxtwMzpYLODNgDH2Mugj27rmsbCH77RhsavgNIRhPg10B?=
 =?us-ascii?Q?IbbYvSyO3qhpHu3f0W2KGghdRjaH5L/S2mEBAYOEjpBCpBEmvLM9C0m5cn19?=
 =?us-ascii?Q?CFIg1xsOxLys3wNCbFQwdww7v6IKxdIOMAe7s/TRht4UTQLqHiQehEUP3xIc?=
 =?us-ascii?Q?PtTLu/oOSjHgBli4kEokg4O9DKE6RXliPUNhqCw73Lr2hRXiNlXMtoQMN87f?=
 =?us-ascii?Q?vlZBBSerV4Nm4M7HfEbKA+IBHxi41EbkfzF8tGJlmnPPoBm/Vq45pUAAytF2?=
 =?us-ascii?Q?kl2MIj1D8Ysp3WcghPgoNRRNjICrC5JlCPWuVsR+oad6uFP6fa8Lzq8EPW7I?=
 =?us-ascii?Q?xNV6UwUFsRE9QSqOg6+xON3y8BWOoc7xXfNHMEViBMFngCxKUsO/ZyjKr3YE?=
 =?us-ascii?Q?NUAw/EP2HqrdP1NexQ0Ak72GmcvgtVgkoZSNRFqSstNG1oqR7I9LR3EgwyAt?=
 =?us-ascii?Q?dw1qVjdI1M8EPvibvAzUa226edc/xainltqk7UeR9VtJZ4wROS1pBxXmtd9P?=
 =?us-ascii?Q?/GFKRbeM5Eo26ycVBoWPKAqJx7+1fYIu/665Ht8Nkerc58tgpfXRepGZZ2b5?=
 =?us-ascii?Q?E7F6EsFsW3dzD7ydXHjJEJOdAZ6iNDaDadqvLJLrgoFJv8QT3z7AJZwCylx8?=
 =?us-ascii?Q?4XQ1nR88D/4AM43eLtyHJBfZHYC04PXhk+3sZqxZLXEyC6gI/XfM1vxsFZlG?=
 =?us-ascii?Q?jW+gLt/oNa9n+OsVn/KM45dG5f8h2DJ1i9lNDM2qxeUKD7oYLV/mGRFFkFr/?=
 =?us-ascii?Q?bT0WvIOOwN8QFo4kGnCMZTv5LsPIq/klxOcyz8eGv/32IhbyIY/RkXDhGBZ2?=
 =?us-ascii?Q?4GHX9Llhe44nw92ik/RKaPonbixqLLeYmexzZnDCKDqz5RViSHvbc4EPhdJ5?=
 =?us-ascii?Q?+50xU3b6MKnmyMz5LRmZ/N105Aetd4MV/fe5Kgz7J6c0kVN1w+eTszVuhNVY?=
 =?us-ascii?Q?mTQ/RwUUgu3dtdVd7d5m+Snb/BJyLqnH5kfM81+Kf8tQhO3FJ1I+dogROYbX?=
 =?us-ascii?Q?iuN+M91bL7DbwFG3rhJyWQG0t2EZjsQ7C63xN3NwjufgrSNLmQI+HU2kK2BB?=
 =?us-ascii?Q?ZR+8hkNhscmHCGoKr8AKE+0aXwH11UedsYFi3hsx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe7d384-ea56-4006-c612-08dbf5fa24ef
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 01:24:51.7064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rATRVpnBMSw2nGVSb6uildlbEsUUIx/nf6ZMSKXqPyGkPwo3tujQTWvf06e2QgeIebrHvh2LOEBu9G2NjxiRHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8697
X-OriginatorOrg: intel.com

On Tue, Dec 05, 2023 at 10:53:41AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 05, 2023 at 03:14:09PM +0800, Yan Zhao wrote:
> 
> > > I would like to remove IOMMU_DEV_FEAT_IOPF completely please
> > 
> > So, turn on device PRI during device attachment in IOMMU vendor driver?
> 
> If a fault requesting domain is attached then PRI should just be
> enabled in the driver
>
Right, it makes sense!

