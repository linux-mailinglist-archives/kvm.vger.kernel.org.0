Return-Path: <kvm+bounces-5861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 35FC4827CFB
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 03:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A908F1F236AB
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 02:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2D7568B;
	Tue,  9 Jan 2024 02:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OhY8Ws8G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257C65390;
	Tue,  9 Jan 2024 02:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704768453; x=1736304453;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=I5s9fVyGH73W/EKMTuEBxHwC6Psj5Cvtc2X05e7mGho=;
  b=OhY8Ws8GmzJfHuzsF2cq0ZOeAu5GZ2tmVS4nc8QIzrertzEY9hXPotQk
   rsaCxnRaI/tQ4csufnoblLE6YXSDinhM+ebrKeGhy3j+zZlayUsePqJfT
   6v+BFwiG8kUBDjHPobngWW02oO3E3BkI+eCSTbVndbqmPsFve2ZW5FaL8
   xspLarjL7bIMyHvkF9YM8+/E/fysNbu2zgV26qRmnEutCtLilI9x3P3ok
   DOR0Xdl1SwJjv/aXvtpU3GD/6Vhp3rd4PXWtaAC9FZd8xUKL16y2eC/eP
   AzqucNI1QpiccRNPWwseVZQLyiRQIC1wU0LSVkJ1YM1DyfFgujL/2faN6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="11549339"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="11549339"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 18:47:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="785058519"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="785058519"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2024 18:47:32 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Jan 2024 18:47:31 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 8 Jan 2024 18:47:31 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Jan 2024 18:47:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVx46bU4++6LFoW3fJYnVYzF3kq1eATc7Sf9j9xokMLNXD5uVC/y7qGZ0tEGvLbZNLDVqqeHhw/bMO9XylKUQD6nj1fwFUZ1bRc7Bihl4P0gmoTueE0YRSwrBk4t+h1E/U3JUE0kMRLChkBDQH4kF9S/dzxO2+Z0zb9Kt4WgsjA82MUbuF/xztU0DXNrM4F4GWxHzEBesjq7/ePRw/COsXyD9S+zBG1wMh65EbmswN5jHFxywPbEpPRwR+gM0y5QeLoKK73jZbTwOHLER3VeBpfdjLFRMnPkvDzywQb9ZlXgtgsLpEnJMUyQHhSrscEDXejqNyL6rhXIIj3kKuuvqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R9md5OsinI2nF2j2vgxLcKctQaByf9u0CGynCAZNKPU=;
 b=Z2ZIo+dDWKU0vs/HlGO2eKQOjmacVLPLGAWRxYLWQfv6lUlMKeTG/e5Mm1if2Hzz4r8dgxa4iL94PN61iODduhWQ5vrK9Hn7luwzZhwZOu7EOAanCmti431GqgN114TXhAinL/FOUdjpmF9qvJm/o8E8tYneQftEar8x8vyTDBfZYthsf5KKQCqr3ScJ4KOVsIMfnRam1/kq3nSOAoO0wjkKX3vGaFNWCnQRUEUqbRgKhDCKGm18x5B65/q9GzBcI/yuFYu4PeNY8jOU7uzmd71io1Ha+ij8SP4u6UDKrF9Bj4HbIsXXODc5IfXUwROAMWSEPAUyQmNvbjdtRv/Zzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV2PR11MB6023.namprd11.prod.outlook.com (2603:10b6:408:17b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7159.23; Tue, 9 Jan 2024 02:47:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7159.020; Tue, 9 Jan 2024
 02:47:29 +0000
Date: Tue, 9 Jan 2024 10:18:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Sean Christopherson <seanjc@google.com>, Oliver Upton
	<oliver.upton@linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "James
 Houghton" <jthoughton@google.com>, Peter Xu <peterx@redhat.com>, "Axel
 Rasmussen" <axelrasmussen@google.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, David Matlack <dmatlack@google.com>, "Marc
 Zyngier" <maz@kernel.org>, Michael Roth <michael.roth@amd.com>, Aaron Lewis
	<aaronlewis@google.com>
Subject: Re: [ANNOUNCE / RFC] PUCK Future Topics
Message-ID: <ZZys4SH4I7ggIB2P@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231214001753.779022-1-seanjc@google.com>
 <ZXs3OASFnic62LL6@linux.dev>
 <ZXyzZ8GOtWVhXety@google.com>
 <ZX/bOwVVsnO5OEhI@yzhao56-desk.sh.intel.com>
 <20240109002437.GB439767@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240109002437.GB439767@nvidia.com>
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV2PR11MB6023:EE_
X-MS-Office365-Filtering-Correlation-Id: a570e643-f2e7-401b-b3f1-08dc10bd5231
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /tK3+D5lsqWkQGF/N3AiTMW8/dqIEtQY1gViCNr6sbgUiPirFTh8ABJtLO8nAUY0Q6pxm3mlWsLPdJauwTj65NLIoqhNmaDw92hdVhJVKQCHy88n6vVsBI5EECgH/OENup8o+TOcQseChw03JU95Q3K/JuE+qQ2if/MaOeXEp6ecFAmu94TW5yDZvpYxl/Bi53s2LoaV9IWpjfonU0p49SJscy27MG/Qkc386vGBqcnsrmWupO6+SeMFYKjApnR331R1bxa1cfq8HovfGIOzKjk8GdsFUyK7dTeXhVp75lWCDzuOKDMk/NjfCA1wfNEWew7SbZITFzOO784qcu4hM069UgVNA8PgKgaQXm7TWa7uq712Xzb41AgHmwL4G+FS9SYO8OedyCb7hTFcLBfuLq/n8u24zbIM+gLor1uRxyn1JXVakHfkVjcp8oaWrQ6gKF+5djU5w1OigS+rZ1dDBNeWHehtz7Sv/KKU7a8nzSlGFoUJo8iMnZAoGyZPuDkWZ2nXnR0+WBe/FlrmbrNYC7w0nDv+dO1PXzrO36U1EpI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(136003)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(26005)(6666004)(6506007)(478600001)(6512007)(6486002)(966005)(3450700001)(38100700002)(86362001)(82960400001)(2906002)(4744005)(41300700001)(66476007)(7416002)(5660300002)(6916009)(316002)(66946007)(66556008)(54906003)(4326008)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vxgmsteR6ZgLLG3g4kPNIRe586O2/6Lpxzz3warlWFRuZgjl29Jz4kgKv7vR?=
 =?us-ascii?Q?fYjA8LsH5P4u7Ei2HWldSjMoFqA9K1RgheGH9kfjJP6NV5AONRSpaQgs6Au3?=
 =?us-ascii?Q?ZBCsfJadTJL9Ztbwo3IhggLe/PGtkaq9o3UJ35UiaOWS2KehnA2RLoYMAgVm?=
 =?us-ascii?Q?jHYvwlIy5G+jGUovQ+zrQgifLxz4ycUeKjmlXciXLmtjE1GQtehNlc+Eyfa3?=
 =?us-ascii?Q?g6qhMf5APVGuuvBiMERFytRXzpILyWQMAsYEHhNYjvTRdLbRCfC1lWo+9AIC?=
 =?us-ascii?Q?IpzqPbesM0j6SMd3a4UIwRiTqNJKjixxbaRzLQ+MsHb1je5Te9ezVIkWEMVk?=
 =?us-ascii?Q?hHCO0QQ8t+PkT5k7gxljjci8wyUUhZLEtGDsNCuudVNGwSAU8q0HDFpypSSQ?=
 =?us-ascii?Q?ChBUDkcwnuk9MKwIp/H/4BkhOdwUPN8ayk2v1cY5IDQJ+iWou7EWoJGM1YLf?=
 =?us-ascii?Q?GXIURV6bbCTdE9XQcZvv/TAo84WfLhYhjwsGX4zW5RP+3bqQtiyZr2QtsATr?=
 =?us-ascii?Q?42RXuMiQnlpCgG/HqXQXOEgO4vnZkQCrpweKjr1bSPysU+NWNJQLhqlTtNIq?=
 =?us-ascii?Q?Zr0Qi96J7Usf+9d1KQBysAHF4y7qq/FpNL9ZWoxXvYIebPdBqNJO7ou05OqI?=
 =?us-ascii?Q?MWAQrqyfwrENqWsyKfXqHXLwhkl7qlCyZNeMScPJ179qGN4FiD/XBHJU/Sf6?=
 =?us-ascii?Q?YhDjEt8JNsia4Ja8XrTjwiek0a5ro0mbe15fAzeLMfkfVYNG/ps6rehwpUDJ?=
 =?us-ascii?Q?Tza/MqKFJZnYsAymU0FATZ+xpEdKuB1YwvgVRHrS1syqmVB1THOnnCrY+T4E?=
 =?us-ascii?Q?ECHFFpqwNzQZvlLW2EexEp+TgpGFaJ1zxSni2N7yJptFsY+7+W+ILkzcCIHu?=
 =?us-ascii?Q?6QNFDM5lvs0W0rsPURuhjLN/WZMXsA3P9zIueKLxPxLejK0kiVJ/ryF0Ehy8?=
 =?us-ascii?Q?tEVX/WORg56CkZL0DiVUmYneYeFQWFCjfcvnxIOlmznM9DX0OVmhPbwoPDKe?=
 =?us-ascii?Q?IRN5i+GoUSNmzDOOskOIRTGOcVjfDZrEtZ+ysJz9QI3zHZOEjNg3sKT6jPRK?=
 =?us-ascii?Q?xm0wP7prTMv5+NyJxeeUkVAxmb09groMMwSBlf6QS3FgRPpC7wr1/ROCU0JE?=
 =?us-ascii?Q?8N69aTlJCOPTYn5LZ5qAiqVKC44TR4I+90bdQYARZsd3rXP6Snvn6pSeRD4m?=
 =?us-ascii?Q?fCHtD9v5HihuXJQVJTjMo3LL+luEo+GxQ4Rs48pF46a1FhtBHmsl+XrVCCEx?=
 =?us-ascii?Q?FJkqZ/PZfESOwJe9OAXCizYtIYAjvu44OZwpb4yR55fLf0q9X+v7mc8JJJYx?=
 =?us-ascii?Q?7gOoPTMMtReLXEUP8n0+LzLsfi+mKUdDqtlGjv10Ib4N1LwvPgeBsy4CjZH5?=
 =?us-ascii?Q?QuVknxQNWsxDOWZzmIUbhy2BDy8Sj0oRvZcnJjF9tyHOBGdVG/g1EXBT18dV?=
 =?us-ascii?Q?EwBIf6h8Qnv6ILX+y+9JtdMjxxO8cikpN88qpy4mXbmM5PUAfZfyRLy1xTO6?=
 =?us-ascii?Q?q2bCx5PhHJ1F8KycmqU7Rd2neaB3Efk4hpOIfJ4YTbSKXNwBdSW5DK2jm6bV?=
 =?us-ascii?Q?4ZlGSqkA4i6qiVgWk5NGN/mzskNp2wWNW2IftRrh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a570e643-f2e7-401b-b3f1-08dc10bd5231
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2024 02:47:29.5037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkx/POYb0VLZrDByML/wFMvRVkeiS+FJZFunEIfPAn/azx0NMWzbzRH0aWoW5a4YC8TGsNKq3CQDTJU2MIGkfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6023
X-OriginatorOrg: intel.com

On Mon, Jan 08, 2024 at 08:24:37PM -0400, Jason Gunthorpe wrote:
> > hi Jason,
> > Would you like to join the session to discuss "TDP MMU for IOMMU", which is on
> > 01.17 or 01.31?
> > (6am PDT
> >  Video: https://meet.google.com/vdb-aeqo-knk
> >  Phone: https://tel.meet/vdb-aeqo-knk?pin=3003112178656
> > )
> 
> Yes, I can make the 17 it looks like
>
Thanks a lot!

