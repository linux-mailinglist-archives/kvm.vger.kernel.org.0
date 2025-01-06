Return-Path: <kvm+bounces-34578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C50A01F05
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 06:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 706B93A3AB4
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 05:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D391CEAC2;
	Mon,  6 Jan 2025 05:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A6cysb90"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D373217C;
	Mon,  6 Jan 2025 05:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736142714; cv=fail; b=sSe2R6EI5rVwUOamZr3e3gWiGwOB1MO1PiUdd/Sv9DzTqqt2DXu5Ds7IAqEDdmNcQQ3R/D/PuFhVA6YqwicqPYofYgT/A7fR3WDcJt4mUfp+XUs+vE2Og9y4Ygd7Lf5S0412g0uDlWK+DddTw3MEzKBf+HmKBqktoK98Bryu8Ko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736142714; c=relaxed/simple;
	bh=8Un2yFoJxm1HaR4bXSVkgny67eBhGeUhVN7HYybRggw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HU6MrMAFNGhmNwmNM1GXFhSXd5kpZZQAlW9x5bbOyVAMsjsqSoKn3lMTnj5gwraiak72E8jsCg0MDoQ3Uqf/L1ZYT68OZ8qPxJx38yLPSLQxYGUDs3y3QKGysAjcW5+QvswbZC3OZ42ZnqEZDfatJXjVIA13JXsmtdcQ30aehuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A6cysb90; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736142712; x=1767678712;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=8Un2yFoJxm1HaR4bXSVkgny67eBhGeUhVN7HYybRggw=;
  b=A6cysb90NRfI9FLbzbMuf2qH2Vic33X8u7zJAos25k4SMZHmfZR+sNA6
   8uXDFZPGmR+RjB8INHjim1f9VLhDR+OCMafFOZZHPYmwRbGe8WO+sDW2p
   r7L1y6qZB9Kp7+vVcrLZnLPxKw1UNqX24WD2bL3SgyCGgkgeRNugIFRDG
   FStaNk96V1QHI1L/CZ4WcMFR97m5jLMzIb3pTSLij5mDTBcGmw6AdWPuD
   QuicSns0EDR49Y2I5zt2IFigT2FNTdHXWWKDWMmFP6SJCB9szgUWjF1fT
   vfMBZgciSOMglUkJ92fa6nUggXstY5dRHrvkFLnw9vOUEX8Ru8jUv1rSa
   g==;
X-CSE-ConnectionGUID: +DP4oqfDTzWVeTURHp7Xdg==
X-CSE-MsgGUID: lAMVjl95QWeJeh34GPCrQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11306"; a="36301365"
X-IronPort-AV: E=Sophos;i="6.12,292,1728975600"; 
   d="scan'208";a="36301365"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 21:51:51 -0800
X-CSE-ConnectionGUID: gbhGwN2hQFy34gCOR0avSA==
X-CSE-MsgGUID: E0YHLqd8RYStsYA9DfX2oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="106384876"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jan 2025 21:51:51 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 5 Jan 2025 21:51:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 5 Jan 2025 21:51:49 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 5 Jan 2025 21:51:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NvPsXSaLhVdCXrTvV6RlnKFdgTi4Jiin1nOcTD/bFZWSpDHUIinrtHJHhmDCNwMUYK61PDF4LK6sdiNqXPwVz8OXFPmeQ0vhwaW1Nh68MG1haQbtWBMULRZyZC8dQwQNL5ryK2w7j9AZTvu6hhTFtJz1pS4ZPYX3Po1XavGdAPAShIPPMIz2NNCpNMD0S857Vq8EtVUSk0QgLGQqg3i79RYmVH4dqsseMR4cpMm1wJolxl0Fy9NUal+PezU26gAnFY1WHz0UkgClHLZ8kdTLFFuB2ULKsGDYegkFd8TRj4PdngpHgwjRK3WHnAfbFXlAUKjcERjLvy48vXg9MvhB1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uG3+gsST2heMhU7nr+uXT5Vj151rLW2LziqSw5qtIjg=;
 b=dpR37diE/RTxSFtOjnM2y4Cxdqse+EUorASshg2iNiWrZ/uv6PRmQTeJMIx8R9hw+gh588DpvfnIWRyqITnra16GNqT9zWnxEkp2UYVsEHR4i15qDP6UG09H6Ljc1FtJ8ldXes4R8UzVB3Oq2eHPf4SrMssg5ygRSMw5Y4cWb5XISGDSkddzDm507JiceR3KY9CC7z+PyE5urfK7RCFKwiuTbWav9yj8R+PDG+gQGS/MEoqnfL3/wjtChlw2qMaVyXAOnja2umpwWDZ3v7aheS4L9gfatOsnKqo2fqTQIezkX4+dPvuT1bIbSWHQrjwkLqnjOV3umG1qr5c2in0SeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7779.namprd11.prod.outlook.com (2603:10b6:930:77::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.16; Mon, 6 Jan 2025 05:51:16 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 05:51:15 +0000
Date: Mon, 6 Jan 2025 13:50:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Message-ID: <Z3tvHKMhLmXGAiPg@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-9-pbonzini@redhat.com>
 <c11d9dce9eb334e34ba46e2f17ec3993e3935a31.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c11d9dce9eb334e34ba46e2f17ec3993e3935a31.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0046.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7779:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0dac7c-395e-4c87-3331-08dd2e162255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TxQdwUaz1aqE8VCz6YONE3Tt+h+Fggmxu/EFPstqzyWtQm1/LUfoEFq1ciqZ?=
 =?us-ascii?Q?Fjgbo/qC8ceU5++2aQpKo8Ip1uzKpmMbCWv2PJMm7y6oNxDr8f4C28UqZ76H?=
 =?us-ascii?Q?buoaB1hFkfpg2rWj2s6e1GV/kTiiiddO6fYPi6H+HP4IGkGG53vM74BWIJCm?=
 =?us-ascii?Q?UiNDtPO6HdgXSUBf5ozU8tK8EWBUYEGE/YJArzWFXCkfcUWy5YnA3wu8VNCU?=
 =?us-ascii?Q?OApsa2xEEK07jDzADys2pcXzEQzcX4ZaVZr/tb9619iutBhYcuArHSNLRjpr?=
 =?us-ascii?Q?d5UcyXNAdoW7oBw4jXuIYFE8OCm7lZ8EE3v4qCmnGLcORf8OSNsh5rZpOpFR?=
 =?us-ascii?Q?aNihlWeW2SymT5FMH9H9xO3PjalXUreaLrX3dIovXY7tWEDSbCa6wijvX3N7?=
 =?us-ascii?Q?/+BxYXvLZvoNoySPgChip4IHEPKOYnfIQxAnqJ/s1Xtg0CLHUAsFwfeENYHI?=
 =?us-ascii?Q?cpo9IniA91OjS+I9k0Sr7dWgOi50HF2BqCnoqyAldqP7CAKNquD5G8Hu3JVw?=
 =?us-ascii?Q?X1jY2wnG/IwHQiLTsbP8oh/HIQ0y8/faDH2fXc783/kB3tKvy5J/5Oh0ONCm?=
 =?us-ascii?Q?1aOeqRXHyUbRCAV/AW0futKm7f+V/7bOACs9Z/fm8y1EuCNrRsH+JVoHmHLN?=
 =?us-ascii?Q?Y4Tto982J+MTJTDqMu7dvAL8YvKsmIL1U3+o3awT9UKcfpiNw9vqwNAXmuCj?=
 =?us-ascii?Q?QwJQj4bDD5hSNPPxMgzHTfKj80PL1BdeAISzebMSM5YapB9OHjwFqDTn94kq?=
 =?us-ascii?Q?y2viTce302vkEfxx1OFkq62d/Sa+GjXU4NZQ12lFxkWbrY4snExf/QBI0Du/?=
 =?us-ascii?Q?Lyqpk92cgp8nwRSQ0SVrTWkY/1PHrH1zqn4iQFnffLigKkhK/SJJ40lIEVrd?=
 =?us-ascii?Q?cZMmJRORCHfawCbGudVmvDCzqahmaZLr8viDlXW44VpUyj2+GYhlsrSOY2xr?=
 =?us-ascii?Q?2Kjj2RxwK6iFgQik/tPqxPSyuLpGmfSlsElaFHmnETexxMywbVJ2f0toTZP7?=
 =?us-ascii?Q?z+Ros18ZqxFbL4nmcQdEAhK7176So6m3opcA4tCCnCZkrLWN2VbV/kGwN2gV?=
 =?us-ascii?Q?cphVmHIzfeWpjZNaHiT1t6TLK2I9YvqiMMHLVqMKQ2hH4HMWAZhABT0tI5xz?=
 =?us-ascii?Q?5zdP3ke7UCZxAMhtelVsQhWdAYd+u7amLtOPSqpfTpTb+F2oodOy2htSOCzu?=
 =?us-ascii?Q?mV83CjsZfVznJE3ZMsZWfW10cljHegrHGN2tlOQyaIzkfUl0IT+cwo5G1yUG?=
 =?us-ascii?Q?ZTWZaAGH/laoZwKVzPPxb8yw3i9O0/RW/iUGpuMu/Fv9zjR0nIGkJUG7uKAd?=
 =?us-ascii?Q?AzvufMrhMCN+iod/OZH/QdzyzJa/8blpCv2ffXXV3OdIvKXWAdJUB4SivsPH?=
 =?us-ascii?Q?FJQNFi2MssfBol2j0n7xnaoBSD/E?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/KuBrvBLQYv3OiGFWQ6T4Q3IebPEEFZsPTRUYXieX2u3WNS+Hlrt312BBqER?=
 =?us-ascii?Q?OboDLtAjuq6v+sa37aKqr/h03nBC+Jdfr6/aYzgIlAlBVvgVZoSrUKRqzKqR?=
 =?us-ascii?Q?2sVvuGwNwZlH3c/4OXZh/OPM77NTo5Ff7j9oz8pdaz+Y8HSMEL2Y9vst9/nk?=
 =?us-ascii?Q?1MjdTay7PcngqC0mZOnHqPNKvWReiMgvR4jWOXffIk6NeOicOxNu1S8V6Mqr?=
 =?us-ascii?Q?kSUP0oRBMrVqrVtXNrWhYAmzkdIFNJb6x62U5yTPy0Wh00mM0b1hQ7MDj+Cl?=
 =?us-ascii?Q?fn+U+hFAJv6ZpokpBerEPfA1y1NMK1VuSLf+aL5yCTQFAnQiYyUO/L9tLuhe?=
 =?us-ascii?Q?euPpWiOrId7WSGWcUxhUtSugRYi6PCxBmCD1famCrk4a4rN4PTCLmgOgKw3w?=
 =?us-ascii?Q?8r7nCwY43F5fyO1DeROyx11NFORWH2adJTjSGHK5cr6y1UK3BL6ZXUpSS5Vg?=
 =?us-ascii?Q?rsBYS+gdTMNo2tIxGA6VyzBdR0KQUnSRr8DifCjsFYtkzUPvtDHI/vOA5P4W?=
 =?us-ascii?Q?QeQDAw9XDLFH2w4OrNMa2DnIJYOpAnrodf8ZEj79ggbUX4wBCiDQLu5nzH51?=
 =?us-ascii?Q?XMIw+AkECosShl9qkfbAMdvzNhJcXpZnB/v/nW0AGW1+VozWD7I5HQ/svDN5?=
 =?us-ascii?Q?m80y6XXmSM8dwwPEExAiaX5EsOar7CRlkwCwCqEnq/B1FpJEkyrGVaLEe7rn?=
 =?us-ascii?Q?JwmPxSdo2SyraESyu68aVcnQSI/N+JqEQTAuBm6m1x0uwGQQXln/KI2TFi2w?=
 =?us-ascii?Q?dNO7Ks2Ah1FcIo1S/xeCjrmsBMUDZkkfRepCKh78lcKLz+W5z1Djck0s1CVU?=
 =?us-ascii?Q?8mcGF/MBwsvZyh69fhGGQbDW9PxiLDe6lFU915L95bxJcYgN+rCxXnQ1dfK8?=
 =?us-ascii?Q?Hk/qPopheZZOKq4kEz5JEhB/lIp+nq6M5KNal9eS9wzX4GvA3DQxBKwMFAFB?=
 =?us-ascii?Q?Yj1kZU4Tmz5aRShwbkoR8xtt0OPrKm4BZXaoP3QWUqKiLeDfm0YdmqkGb4u6?=
 =?us-ascii?Q?cLOE3jmO0RInEKJlGUABZi2D9sXYm9wzp3G4sMDLZCTz+bJ93j7mwaheGSNg?=
 =?us-ascii?Q?6CC4sJp8/H99khhmE7gUea1b5zi/GOJuu1bcuwsW/nIWfebaB9HOhCCBRSMb?=
 =?us-ascii?Q?4h5wMqF8kMwcc7NEqk8V5B+LTnqxR3elIm5pX64IMy+IMDKtWRex97W1c/yY?=
 =?us-ascii?Q?qK0vMpr0Z/PuIOYcZTx/bMy1LmOh6D/YKSRb3bRCabrOuHqHfQ/b1fVn4gQk?=
 =?us-ascii?Q?Yw8NgZKJ+0YBPIlV9xahPJpEccqZDWBATjCYSVpgXmH4OxwaTuKZy9JoT5dE?=
 =?us-ascii?Q?TAKiMcm/SVxhWmuO6csEQOznih6v5/ae4ehKnwyHOflXwhJQRMswWY6gyRzZ?=
 =?us-ascii?Q?6+tgjdoKXxoMeZzdpjuXjea1puUwGNmqql0fabOkBCvKjHuMvMOYWV0sBvfQ?=
 =?us-ascii?Q?Am7LMQQFaUu2NPaALQOcbGhSwHr46yQJ1xpEoGHNoKNDk7cytD31OcZztY/N?=
 =?us-ascii?Q?ZT7c9/7RF2rnJRTVmF4BQqRRoo0LPT1/TAgte4+yHrNqKexvn8hKk1V1Azln?=
 =?us-ascii?Q?lFVAizEmxewkCrNrbI5L+2fejVQj7M3Z2ubQWnAl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0dac7c-395e-4c87-3331-08dd2e162255
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 05:51:15.7786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYGo7gqNu1IFI+DL+IcnGHZFazQMN7S/FveRZd24HHdvuuEk6JtYIrhLgdus2B7QBvjQL8I/Zhsyc6FKxNc61A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7779
X-OriginatorOrg: intel.com

On Fri, Jan 03, 2025 at 07:32:46AM +0800, Edgecombe, Rick P wrote:
> > +u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx)
> > +{
> 
> hpa should be struct page, or as Yan had been ready to propose a folio and idx.
The consideration of folio + idx is to make sure the physical addresses for
"level" is contiguous, while allowing KVM to request mapping of a small page
contained in a huge folio.

> I would have thought a struct page would be sufficient for now. She also planned
> to add a level arg, which today should always be 4k, but would be needed for
> future huge page support.
Yes, in previous version, "level" is embedded in param "gpa" and implicitly set
to 0 by KVM.


The planned changes to tdh_mem_page_aug() are as follows:
- Use struct tdx_td instead of raw TDR u64.
- Use extended_err1/2 instead of rcx/rdx for output.
- Change "u64 gpa" to "gfn_t gfn".
- Use union tdx_sept_gpa_mapping_info to initialize args.rcx.
- Use "struct folio *" + "unsigned long folio_page_idx" instead of raw
  hpa for guest page in tdh_mem_page_aug() and fail if a page (huge
  or not) to aug is not contained in a single folio.
- Add a new param "level".
- Fail the wrapper if "level" is not 4K-1G.
- Call tdx_clflush_page() instead of clflush_cache_range() and loops
  tdx_clflush_page() for each 4k page in a huge page to aug.


+u64 tdh_mem_page_aug(struct tdx_td *td, gfn_t gfn, int level, struct folio *private_folio,
+                    unsigned long folio_page_idx, u64 *extended_err1, u64 *extended_err2)
+{
+       union tdx_sept_gpa_mapping_info gpa_info = { .level = level, .gfn = gfn, };
+       struct tdx_module_args args = {
+               .rcx = gpa_info.full,
+               .rdx = tdx_tdr_pa(td),
+               .r8 = page_to_phys(folio_page(private_folio, folio_page_idx)),
+       };
+       unsigned long nr_pages = 1 << (level * 9);
+       u64 ret;
+
+       if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||
+           (folio_page_idx + nr_pages > folio_nr_pages(private_folio)))
+               return -EINVAL;
+
+       while (nr_pages--)
+               tdx_clflush_page(folio_page(private_folio, folio_page_idx++));
+
+       ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
+
+       *extended_err1 = args.rcx;
+       *extended_err2 = args.rdx;
+
+       return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_aug);

The corresponding changes in KVM:

static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
 {
-       put_page(pfn_to_page(pfn));
+       folio_put(page_folio(pfn_to_page(pfn)));
 }
 
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
                            enum pg_level level, kvm_pfn_t pfn)
 {
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-       hpa_t tdr_pa = page_to_phys(kvm_tdx->td.tdr_page);
-       hpa_t hpa = pfn_to_hpa(pfn);
-       gpa_t gpa = gfn_to_gpa(gfn);
+       int tdx_level = pg_level_to_tdx_sept_level(level);
+       struct page *private_page = pfn_to_page(pfn);
        u64 entry, level_state;
        u64 err;
 
-       err = tdh_mem_page_aug(tdr_pa, gpa, hpa, &entry, &level_state);
+       err = tdh_mem_page_aug(&kvm_tdx->td, gfn, tdx_level, page_folio(private_page),
+                              folio_page_idx(page_folio(private_page), private_page),
+                              &entry, &level_state);
        if (unlikely(err & TDX_OPERAND_BUSY)) {
                tdx_unpin(kvm, pfn);
                return -EBUSY;
@@ -1620,9 +1621,9 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
         * migration.  Until guest_memfd supports page migration, prevent page
         * migration.
         * TODO: Once guest_memfd introduces callback on page migration,
-        * implement it and remove get_page/put_page().
+        * implement it and remove folio_get/folio_put().
         */
-       get_page(pfn_to_page(pfn));
+       folio_get(page_folio(pfn_to_page(pfn)));

> I think we should try to keep it as simple as possible for now.
Yeah.
So, do you think we need to have tdh_mem_page_aug() to support 4K level page
only and ask for Dave's review again for huge page?

Do we need to add param "level" ?
- if yes, "struct page" looks not fit.
- if not, hardcode it as 0 in the wrapper and convert "pfn" to "struct page"?

 

