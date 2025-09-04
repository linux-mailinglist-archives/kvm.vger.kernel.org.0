Return-Path: <kvm+bounces-56820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB375B4399A
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 13:08:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FD1A1B285E9
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0312FC895;
	Thu,  4 Sep 2025 11:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WX+06C28"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D762EC08B;
	Thu,  4 Sep 2025 11:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756984130; cv=fail; b=Fi7NntVwKs1pZ9RRBWj/a5ob65ptsMIX2wZPc+FwrkJkiieCHB+9gbfEnkupYpfMqpuX5F8o5UHnF3nc/sEFwGxdvsjIV2W/wK6a1vRg8tfQMTzJx03GyAh687an5DPiMT3hQlYn3dlv/q5Zz/ZvO1eZ1I9sMyBhW7sdPEBqMZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756984130; c=relaxed/simple;
	bh=fM4UdfaaybS8ozVAGEBE07Vfo7RwZkHUq+PIeYcNbpI=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nvphsPHbwGcXZ9r4xNwgMQQiBOzejtNjppMPLUKQcLDafNOso42b5fDkg5j5uFgIVEjk8qcyazPCKnN09T63jekpit70ZKRxxAJcC1pvn/KRqhgRDWbbtW0hqo9Li9pzyCq/O6XXfhxetuMWyo493bWv4FDPD3JAO6W9W17LJ7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WX+06C28; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756984129; x=1788520129;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=fM4UdfaaybS8ozVAGEBE07Vfo7RwZkHUq+PIeYcNbpI=;
  b=WX+06C28i1hAlpokuJC/z6KV177kjpQv9lwPE8J7Z2GkXu1eirlj+iKG
   VrpYqymjeBPftZRKu1GYSmzSq0UC2VPxfNRaTwc7Lo/0sdN29nY6M8pJf
   mEX9Y7N9r8uWCnak1Lc+kvUWNocdSy/zG/dLV/Ofu0jaw62Fyv3tHyLgn
   RH2HHe4TYW2sMP9NcpiPvp/rZFfZn5XceR6HVeWUPwv2yIRhk7RmngOzt
   zlyELzsIfsvB9uSK+ltabhMUbIVKj81GRvWtYvPHrMmtKRFraUzjlPtu7
   z0rgAwnjspMNevPxgEfA54qftszo0u7uCrG7388qhZZgFvU2FWt86Ymsa
   w==;
X-CSE-ConnectionGUID: mRUimNp6Sc6tYjA9OHGzaA==
X-CSE-MsgGUID: yP53cRGFSJyGjHw3LsKIWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="70412398"
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="70412398"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 04:08:49 -0700
X-CSE-ConnectionGUID: ddc+M4Z3QJuuPB//aPTvbg==
X-CSE-MsgGUID: pYr9fymiTr6eMWXvWYsQ0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="175980275"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 04:08:47 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 04:08:47 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 4 Sep 2025 04:08:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.53)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 04:08:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9yJs8dbQEXjD8TzGREcFMa5FzpvPmJgXiJCNkhljb0367f2OvXVQeOqax9NgfhR3KPv3kn9U0y13w7BvdPtSXsbMwLRC+ymnUmt8Li5bZVWT4rsQExGh/62MZ9zRyU9hVt2KVIfN/ybxekzjZctNRTh1fBRFB71jbOgJbWotIMNZEnLaznlc6b4Jo96zWBjGCZiORCIAJmH5ToC5A4LMaOSgpNAprNueyyv6p6VCwBzQPVWK6MiyMzV81eNsHal5miXD09+YVNjyezkWZh/mYSw2bINZSJMW6DW8FQ1Ysi0NyTAQ7qzyTVJgrc14xje0+zc5cOAURoKcIJrtKkVEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jY/v6brggSNaUYGS/9ATFo+59zFiitNuUGJ97Mhw3k=;
 b=QGkR9DcDzweOGBAj4Ebb6i+p8HuZKvL5zdop35HahQRHil1VF5jAT7MqRA/r0xNmi8SIxAAz1lQjS/mW/4qmZe1o35aLYv21GiUS0cL/f5ewxnm4DqdrNY4O9KeqPm5caIi+Kupdqh3P045QwJX6/XOASX6UrN+CHFqig5HcGh4q15jbMtDyoBnOptfm0w0CPQmCCfx6MLIZaOG1vxYkyIkO1WaiO+YJKqcxfSV5eRqLOLuW5jumnB8VSPZFALAchNHGwRPKFVc0QLGnpPWeUd7YIZflDBl7HUUF2U7eyBBjzxFGoKrHLG1BZlR3Dc1APPH4K7v9giSOqfEDSG/3Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPFFA27DACA6.namprd11.prod.outlook.com (2603:10b6:518:1::d63) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 11:08:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Thu, 4 Sep 2025
 11:08:35 +0000
Date: Thu, 4 Sep 2025 19:07:39 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<x86@kernel.org>, <rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kas@kernel.org>, <tabba@google.com>, <ackerleytng@google.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 17/23] KVM: guest_memfd: Split for punch hole and
 private-to-shared conversion
Message-ID: <aLly++6PDqzNF6YH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094503.4691-1-yan.y.zhao@intel.com>
 <6b61cee4-0405-4967-afee-af934df34c5f@linux.intel.com>
 <aLlgesTc3ZIvgPg6@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aLlgesTc3ZIvgPg6@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI1PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPFFA27DACA6:EE_
X-MS-Office365-Filtering-Correlation-Id: fffc6844-b952-4e95-5ae7-08ddeba36444
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ENJ4XTlsdQua9uRq0OF5HA86XPR1Vpc3KEXTg8bzabhmV6iuRtGjAys6+SWU?=
 =?us-ascii?Q?0M6CtYrCX0obFpW8VVykrcAPMQvotI60AHXGK1be15oYWuEbAZfRNRoSmyFC?=
 =?us-ascii?Q?rTz6WlOBJrvBAuCcHC+rNp9O8qjsQ8WIGG2W5avD+0DySOOd6W9DyA+tqZny?=
 =?us-ascii?Q?b3LQBRWpCHpCXLxH5OygR1HrOG6MvX2nao+HbFYRAI42JVFbOtJpXcsVZgF3?=
 =?us-ascii?Q?wHo/IasO1rpURrhcX0nVAsUYJd2oUTW6Z8i+qupss/s3sMfuOqnNNVlsKpPp?=
 =?us-ascii?Q?uCnyFDSoh2TmoU0g3Lpj+lbnDgfucvnoUeGaiBnjBbKSplQAxuoCJsATyxAg?=
 =?us-ascii?Q?QuwtR9hJEAnOkZKDfWG0ewKEmb+IJpPZ6wNmjCWcZmNTmV+fH4KXQ73MmaKO?=
 =?us-ascii?Q?H6pVLEfBK92nNf+mKYu6D7u4cr1XIenG0w5mZGe3FyRXE3fWTlXRFEkexyeY?=
 =?us-ascii?Q?xsSYik+kxzBvFsGg8ne821w2h2qObwTI78ysLPC44o7BjUXFmRsHhhnuGB63?=
 =?us-ascii?Q?NA3HAUVL66QVgnRoUptsVxVspNoMP4jte4ecUOBKaV3UMaYr0bCcPSlA1W3O?=
 =?us-ascii?Q?TmebFxs43U3yhQjri4bC0YdFDKpnymJT0BaUEqybZVbcMlcFGQmS8U+LKEuH?=
 =?us-ascii?Q?bWdTfb0Hc5LIoqv/5LKdQQCqYTV2Pqm8+NQ7VqgRZpD7sIJPsAuWplHtPJ+a?=
 =?us-ascii?Q?aEbDeeNYE1BBmbbE98+mnfXnriTCCUD/iqOGqMoicPAU/H8T+xR9y0a3ZM0r?=
 =?us-ascii?Q?4r6eojLjEjW6gf1Zeh4BpGb+j9gLGZMn4hCTttnWHN9KXRByBpxZ3ivjXJD+?=
 =?us-ascii?Q?HrJXP1PqUxwebWXfXkurkj9JkfVMO8/L2jruWzVu9Ps5Dn2Whi2bRAPB2i1y?=
 =?us-ascii?Q?dXmfQqw0JxuJO/GpcuWpPlIeiIujsFiDr0q7ku9tSpKqFTJXrcstN3CD7gnE?=
 =?us-ascii?Q?LGjW6IiTyspFGofw+actuUEs9otmssdqyAAfzB9plTN4hfbU9gQbS7y5RTRZ?=
 =?us-ascii?Q?1VivdW+w12bSqzD4SqBXI0NtfAJtgfQ7sTEXIxWxhG/lG2aWJiDjt9DcWIwy?=
 =?us-ascii?Q?mhlpfGNQSgpyT1QDVm7OEm36lsMF2Eq9mBumliy7IR11TgLpyvpWNoeD4sLe?=
 =?us-ascii?Q?5srdBP4S/QG8Gv8TqN+hxVAhR+CMaFtRqT3GuPBU3nwnKNnOY7nVwX6S45PU?=
 =?us-ascii?Q?cePt/Lky2NW4jEUgIV99uwq0UgIKhNeYWPwqoKR3Ta+drNWIjKlkE3JM/bYN?=
 =?us-ascii?Q?aARLruN95XIca9T7P89FG/KETenfs/c4fYDEs0IsTschHbEqoCoaPPNpmsGJ?=
 =?us-ascii?Q?QqogsYpbh4TNhX7XZ2a63ZSfPZYgXjnbVLR0WzkQWPXNoda5tgnRG1onYc5w?=
 =?us-ascii?Q?I+xE9orFqk7lzcxKegThRiHbfJj77O8x7jNH7KCOaBw45+vEjGpKaM0YhYV9?=
 =?us-ascii?Q?IFkbmfuqdY6ti/KBU1bU9n/dD+P/jHy+uXc2AU7EoQFkQxpaNAcjhw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DzsILP6vHTlJ8d4qHlOp2w4fOuFoWF710xNY0D+u2W1FsZSscbcZiDZc8RTz?=
 =?us-ascii?Q?YQzjm1tWIuAVCbDQWt0jqxJJU3NUrNoohB+m/MvZF654kNC3ZW4Ok8aA9UZf?=
 =?us-ascii?Q?zudov3sC+48mJYdwqfT0P38qwQBJu7WkyjwLUvL7ORvWiQB/nhZy9ouch4we?=
 =?us-ascii?Q?CO1bGSva8KYOeB9BKMJ1nKLxv4qO915+MENMsTxGAkBN7y8oRYUYuI9RAdry?=
 =?us-ascii?Q?TcANbPpK0wa7XClwFFBYwMH6t+e7oXiWWQD4ytn3/e4gsjzKtm2ZI4omivd+?=
 =?us-ascii?Q?ANJF9PIPcMewanodBi5MrnEkjvNwNUJoidIWHxoF7sO8eNA80CqzpQ32OCdC?=
 =?us-ascii?Q?oz2Pq6uU5oTh354rUycP2zE4+pNk9wFrclv0VWwXEV0odiBk8enY31b3bDWJ?=
 =?us-ascii?Q?bch8Xf91GFdELIVETfFm6pU+SQboHzhmDZmnxc8XJnQKAlKvwxjO1ocf5gTv?=
 =?us-ascii?Q?xlPEFydKfcxwD4E7HzK/b20g6hx6+0pu5wsebegCE68jPbnqLRaeplLgW0GV?=
 =?us-ascii?Q?y6pvo6NYUp41uPQN3CzALobm4N8GzQCnaMbieTEL4mGAeNteK4w+KBJqCNCu?=
 =?us-ascii?Q?4N56y0iwFRzb2kNHdcxySRIlB8Z3gnwL3HKVo2bkG5tT+rvk60Ix3czn1nw+?=
 =?us-ascii?Q?3ZsBgYqajQSls1Xc7qJZGisQ1nZNF/+Lt7DZIZgAffLqcmttHK+nmb0CTQw/?=
 =?us-ascii?Q?zajEsUAu6El69RDUUPb6mQj5t6FaXQQ0HFWIBnQ667GtJdmW0U+vksGaISci?=
 =?us-ascii?Q?lC+yDkRRPZ14vFaMUszUucWqlVf4emqIGZUqQLJi4mdnPS89r+UQp978YdZG?=
 =?us-ascii?Q?DMsIoj7/IZ3FUy8AKjpztHL022QAiipRijCkAzLYng15iBnDNTQfX7PPfg8W?=
 =?us-ascii?Q?cYNXyAhGALT41cxycLfvEh0zJ1qf+Argt576ddtAS7W9Umybc6zVnZER2Uwb?=
 =?us-ascii?Q?e/Ir2Xgc8A1j18vuk3hEeOCL/CEThMLt7if/DOu3HXDADkI79+L0CIZq15er?=
 =?us-ascii?Q?X+NgtQHdOZqum9xcP+hDkY3QvGIdNAe2yDYKaRSIlzi+a4cFzo8OHAnmBekw?=
 =?us-ascii?Q?k6wKK1dxXmJEc9G8R8MFLAPmAqgJSGcAgDmseFmLrItMf+ZIeotHICQKQcAV?=
 =?us-ascii?Q?6I0qDaBwq0VjWnvFyqST+tDZiXdQXSadcLsmYkO4t8NlyQgSMfm0vUus+KM3?=
 =?us-ascii?Q?iPlUp91Xl1G5CAA1me0z/Hti8sOgUzfEJ44hATcUPuuVQwEgPvduP0unbQQt?=
 =?us-ascii?Q?60K0nz/gjMplPe7IKrT93gthxrBQegrnyF5rPUzuTNNHCniXjAp+cMySG8ZG?=
 =?us-ascii?Q?y6oW2IjxZ2zvQzoLN3knKzFoyLlPgYKf8KJ+SCmaBtBbW+ciwNwHQl8vuI3X?=
 =?us-ascii?Q?HcskVoeypkI3c0bBzTJ7wS6zK2bXr9AOUyY5lspPvMsDIgW8ukMZk4H4KP0k?=
 =?us-ascii?Q?kD9N44riswiMUFsMPSA+yd2qtJKGe7wH1N+5MBx/UEpXSiWo4XemR3Iql+pG?=
 =?us-ascii?Q?NVDM/rCSX/NC+tHae9/sIxdQg+VG5iKqRLAIItrtwJv3iis345wEKr6Z2KK4?=
 =?us-ascii?Q?nbX6OaCFESFsL5tME+2gEkQf9HmY4RL0KtDvvMag?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fffc6844-b952-4e95-5ae7-08ddeba36444
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 11:08:35.3042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pCsxLuhxssJoSE4sj9e49gHGUnp5O2hWH8foJMvRZ+Lh1qd8d2DKV8QNGRku6QdKZwnx+cnpSFjNUWBnwMM98A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFFA27DACA6
X-OriginatorOrg: intel.com

On Thu, Sep 04, 2025 at 05:48:42PM +0800, Yan Zhao wrote:
> On Thu, Sep 04, 2025 at 03:58:54PM +0800, Binbin Wu wrote:
> > > @@ -1906,8 +1926,14 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
> > >   	start = folio->index;
> > >   	end = start + folio_nr_pages(folio);
> > > -	list_for_each_entry(gmem, gmem_list, entry)
> > > -		kvm_gmem_invalidate_begin_and_zap(gmem, start, end);
> > > +	/* The size of the SEPT will not exceed the size of the folio */
> > To me, the comment alone without the context doesn't give a direct expression that
> > split is not needed. If it's not too wordy, could you make it more informative?
> What about:
> The zap is limited to the range covered by a single folio.
> As a S-EPT leaf entry can't cover a range larger than its backend folio size,
> the zap can't cross two S-EPT leaf entries. So, no split is required.
Sorry, my brain just froze.
Should just be:

As a leaf SPTE can't cover a range larger than its backend folio size,
no splitting is required before the zap.


> > > +	list_for_each_entry(gmem, gmem_list, entry) {
> > > +		enum kvm_gfn_range_filter filter;
> > > +
> > > +		kvm_gmem_invalidate_begin(gmem, start, end);
> > > +		filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED;
> > > +		kvm_gmem_zap(gmem, start, end, filter);
> > > +	}
> > >   	/*
> > >   	 * Do not truncate the range, what action is taken in response to the
> > 

