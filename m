Return-Path: <kvm+bounces-24334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D633B953E08
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 01:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 048931C21855
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 23:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD308156C5F;
	Thu, 15 Aug 2024 23:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jq/ym3AE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1741AC898;
	Thu, 15 Aug 2024 23:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723765566; cv=fail; b=ej1WVWozRc0oFOHMU4JTr12ub3PZLs3cHWQFdJHvMgb6HANQAXu+PNzjXP23Z9bJuzpyAq9Lwar+qgwWU+VGOPIKS6Wm914TCBhgjkgmQC9Vh9s2NRwu952EpQN3yAFP9d134zBT8f5nX6Z+WvoZqpDuMUgm+6Eal3Nv9eKdnDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723765566; c=relaxed/simple;
	bh=p1GsgOFoTfSDrqOXTtA/HssdL/8Wnoaa1XZSADYmh6c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OWqg62nZKOyUVC/iRwCAlYsk+Uc3StNcGaNKfQmAg4HJ2WQCJRtTvze35jl5PeJXOUf9v2v19DGGA1BKYjFO9H62JofYQBXfW6Ab/uov+nO18/dma9pQN3XAyieB4jEW3tdwH9nlVrFG/fWKSAaRHL1OhPhMQHP6zvZxxmrs18A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jq/ym3AE; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723765563; x=1755301563;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p1GsgOFoTfSDrqOXTtA/HssdL/8Wnoaa1XZSADYmh6c=;
  b=Jq/ym3AE0cX9UsdcdnRkmcsPOU1a2234SsO/+V71f5CIZ+qWQw6yZiOR
   Nvo11ENnfl7ueokRMg02d1Nw97tN911dDBC6zLDZTlf4HI7M+66h1b4rF
   l7AFvfyOYwuXLlrMxQ+lUBvAo+JHUoUJcAZRAOzmzQ8hNqLLhzjUklG1D
   2D7nfYuPxPQJwJCHgR3F9kU4qa9aal8oYKKn2tYMHd25QtBQtZyliqrzD
   VC0IMD3adWdxPJGEdIl73Ld0xRDPW+sT7S4zMw/+0mgyUUaswAQHJWRMY
   FVxQCK4VSTsu5KuwKR0uL0PANLHcDA9lzLVo/AdANDrSNsbu4tDHk0SRn
   A==;
X-CSE-ConnectionGUID: 5VVfZu2FT+ujcfdJ8Ya6oQ==
X-CSE-MsgGUID: fcyb+tfsQOmpPpUcUvOrPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="22191834"
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="22191834"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 16:46:03 -0700
X-CSE-ConnectionGUID: RNoNX7hYTlqPPW9haSW2Dg==
X-CSE-MsgGUID: QzpO6MQfRm25hGUdy+tDog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="64358025"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Aug 2024 16:46:02 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 15 Aug 2024 16:46:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 15 Aug 2024 16:46:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 15 Aug 2024 16:46:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JRpJG2/f/7g0I9pXAY/jzUastPkXSeg0TkavTzK/ohZmyrj++0e/5QnJoT4kmJjRSBNTAOeaqQEFfWUfjZhvc13QqYESmBio1ZxWOF98tMMYefO/Bs7NMFM6wTyi6NSy6jboSFiq2jhu4uCkNQuJPUa+iKCHKA+aJLuu3sQeYRJxkjGDlOmOdlXWHNxED/Ef2fq7fOX9Nnlv10TX576VWQdMMSkBBwtB1WEB1rsqJp15FXahfW0vgvM9LIrRg4iVVHd+Fb0EqL5fbPgzLJLWeqNhif0+jhvJW4RGdcWIXmfelmziNedJt5pPOCSyUUarRZxPeWcRavH4pZn6rOToRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1GsgOFoTfSDrqOXTtA/HssdL/8Wnoaa1XZSADYmh6c=;
 b=NKk40zkbMnlfKMQWI26gDRkDDnQHq/SX/Hzfazp9iWfdwe+lmqyWjb7wozeBo9goV3fsq+mIvbab2SGExQKKB8on4PLHe+wyt0+0bH5Hsk5bi/beVDsfzhZ5vBCFUHUbO0MwfcnHPPfKnrewGutBWYEhCHw3TS1KQslF+n7Xr8nhE1VstTTLGH8IYGpCxr3oijWxkhVq8ixJVdZlYP0b5B6R+yYgd9sn1iNOuRzfH196ADnzkPHPkMeU4Hre1IJSg0X+5liZCIwXWcK4+uw1OnA51eqGyrTtd56HnEVqaL06j0seDLzIxLHVN1lsh3XuINqLrL0zcjcFucH5PgWEMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4744.namprd11.prod.outlook.com (2603:10b6:208:263::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Thu, 15 Aug
 2024 23:46:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7875.018; Thu, 15 Aug 2024
 23:46:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/25] TDX vCPU/VM creation
Thread-Topic: [PATCH 00/25] TDX vCPU/VM creation
Thread-Index: AQHa7QnJAZR45Djm7U+CDVxjNcpGlbIny6KAgAE02YA=
Date: Thu, 15 Aug 2024 23:46:00 +0000
Message-ID: <148dec1f2d895581f4fec63359e475013ad40c6d.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <Zr2QI_JKj6gs1K3e@tlindgre-MOBL1>
In-Reply-To: <Zr2QI_JKj6gs1K3e@tlindgre-MOBL1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4744:EE_
x-ms-office365-filtering-correlation-id: c8c5251f-e654-4572-2c5a-08dcbd846aa7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?amN6eU5tVlRGb0s0R214Rnd6blRONXZvNkp2VmthK2VSRHE1Q2VvMFRzd1VK?=
 =?utf-8?B?dlhhNjB2dVJhamkwRzdLTlJEQWkxclNhaDdmSk1JVzNZWnRMMzdmbjU3MTdV?=
 =?utf-8?B?T0tVU2cycE1JdGR5emxscGtTbFJkOGtacmJueWtwcmxYbHozM2czak9keXc4?=
 =?utf-8?B?S1BmbWV0UERIajdJMlJMVm1aYVI2VWJsZEFoNyt3Z3UxWlJKTXRpcTk1Qkd0?=
 =?utf-8?B?YW5BdUlrN095SnNJZEM1ZE4reWVtaXBVZFhkcEdsSWFQYU9RVXo4SkJYUlF1?=
 =?utf-8?B?OHltNEFIeC9GT3dJMHVrK2t0TUViWEpibGV1Sk5mblViMmtzZUN3WFV6ZmhI?=
 =?utf-8?B?bGw0V3RqTkdZVjYxcVpROFdobWJYWlpMZzVvbzJ4aGJZamV0VHdCMTJXR20r?=
 =?utf-8?B?NnFYOThVaERqV3psNDFFVFpjWEljOFNRQkpRQ3R0Uis3TjNiSktoakFxTEcx?=
 =?utf-8?B?M2NET2UyMVdIYUJxZFRYVS81K1dML2pGOVMwcUNEbEdoYjZMVFBDdmYwMThJ?=
 =?utf-8?B?S2xyQlNjMHdzQUN2QXpXYUt3UXh1UHVkek5OWWpFUDVOOFRHYzd5VStIUjh1?=
 =?utf-8?B?b0hPekl0NThsb3EwZ2M4S3hIbGJMUkltNWpubDRVUHZwVzJpa3Z1c1V1N1Vy?=
 =?utf-8?B?VWRwa0ljNnFZNFhOU1FFbHE5RnVpdURqd2ZmV3FVS01ZQ3A1M2IvT3lkL09u?=
 =?utf-8?B?K1hxSmFQY1V5dCtMd295S2dsOGZZb0tSUU00bHROREJ1RnY4cnk5MWRBNlQ1?=
 =?utf-8?B?a0dSUld3Ri9ZLzNqTkd3VXQ2czc2TURtaUxKMjhyRGxoR3NOZWRFaEZkV2xU?=
 =?utf-8?B?Nm9JSU4wUmJybXhHY1FkVHJhUFVIU0x6SXR5Q1F2Snh5YXRqSStzSm8vT0NM?=
 =?utf-8?B?RDQ2V0FQM2NZTWpPMmEzejJvY2hzaTVsN0VhMUlyUW0zTGhBaXpBTUNBYzli?=
 =?utf-8?B?bzNHL051U050L2h1WlR4VlpFTmVMMlU2cWJqSDhpVVdEUktMUGM4ZTArOFdR?=
 =?utf-8?B?d1BNNUE2empqNnJQczA4a1QvdDV6MytNTWFHQUkrWWNlRHFueXloeVc5eEp2?=
 =?utf-8?B?V1plQzhORE9tR3dDaWRJVjloOUFzRElvYjFGOERzUS9GY0VqV3g5NUZIU05h?=
 =?utf-8?B?bk1meEQ0TjVZMjZ2NEI0OEVuUTcxOEhnSFIvUGJsRE96ZU5LaUhZM0RiVUcv?=
 =?utf-8?B?QSsvN0hRekZHU2gwMDdidEQ0alJyc3BvNlQzWFdHak1RcEpXUDA0Rm1IOFZ1?=
 =?utf-8?B?TzhlSjh3Q2xnKzBCeDlQclE5MjUwSU52M0d4VjU4OVhMaUI5Q0svWDViU1B1?=
 =?utf-8?B?bTJJa3Zpdm9ZQ05jbmRTMUhWSzN5T3NJRlpVRVAwRGQ0d254SzFFREhBM0lY?=
 =?utf-8?B?U2dNYndmVGdWM0V3ZDVyKzV4U1hxYWdCdXdpYjZ4UmxKd3h4ZDQvZGM2V1k0?=
 =?utf-8?B?anBBTHdERFBoWGozS2hrVnV2NnpWVkFhSVZxS041WGlOdUpTejZDalBTTUFz?=
 =?utf-8?B?aE5OZFdOZHprUEhkQXorL1UxM3prclFSZ0VXWFF3dGU5RkJnQW9ScE05WnhP?=
 =?utf-8?B?WUdiV1NiVDUzYnUyaGN2aXdYZ1dXNlZndUVZNWRCbU82cFdTODJZYU9DMG1W?=
 =?utf-8?B?SzZ0bFpOTjJzY2VkUittclA1Q2tZcytVbUNLZXpKVmRsNHlFTXhNNVRrQXAr?=
 =?utf-8?B?QTduVlY2WTdOWHBnUFBYRmJxN3hINGZqWkFROW5yTWJObDR4NzJTTUJTZlk2?=
 =?utf-8?B?R1QwdHZjZXRnaFBPQ1JoRFoxdzM0T0Y0ak05NjNjNHdxWTJuamxrUUQzUFYx?=
 =?utf-8?B?RnRreVlRRkpvTnE2TG9WVTdwNVhsQzVSOHVuSkN1Z3M5RG1DRlYrSXRzNzRO?=
 =?utf-8?B?UUdDbnBpUjU1RW1XN0w3ekgvNnZrdFFSVDcwalN2ZjRnQkE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlZxa0dSNU9QdlE4TTB1VStPMERPNk1ZR2xCQlQ1b0pBUk9ONkZVdEZBUGk5?=
 =?utf-8?B?aHpjZ3dKNXZrYUJYZmNqbnBhd1YyYmZiNnZKYUFWUmtLWi8zeDlya3BydzR5?=
 =?utf-8?B?V3Y2NUNMbExnUkIwNkdDV21qT0kyTVNZclRxOCtvRW53V01BUTcrRVExb2Ju?=
 =?utf-8?B?eGtJOE95M1JIMkFRNmcybmtMdkVObkR1S3UxYUcvOXFmOWo0TWxFQ0hIeHRz?=
 =?utf-8?B?bmxzaWZYWm0wTkQrQmNJNEU4ZTJWYy9mdDgrQ05IeThMYnJCL25oUHp1Y29k?=
 =?utf-8?B?RWJQemlJYXNISkhsbDVBRUd2eU4xWGNjR2RtYUZYdFNhRFgxSElLRkw0REY1?=
 =?utf-8?B?aFBwcFYzdVBpY3RCYzQ4QXVKczhYUzI2dVRGcHZXREFDbDByd3NwdmpNTEht?=
 =?utf-8?B?SFRHcndiSHJOZUFRdUVtQ1JFYkpEQVVBa01mb3RhWlJLUkRvSVhnZjMwdE9w?=
 =?utf-8?B?YzN2OVRvSzdTMnpLcXZDV2lHZGlnK2ZEVjM3MGxQcmVITzBRYXo5UVY0MWh5?=
 =?utf-8?B?c1RpRnU4QzIzZXZFcjhadllnenBKU1pzR1FTNkdXT1FDTVhWOURpaEJPbXRm?=
 =?utf-8?B?clA2bysraUhxaXBYa0QxM1R1bGVUVTNRbUZEenNhbTJQNTB0U2pweGszdEUx?=
 =?utf-8?B?SWJSbXJKYlRRVTBJeDg5ZTBqS254K0RQOE1KdEE3Y25zdnJhS01vdmN6bldE?=
 =?utf-8?B?eVl6THNVeDd6U01mNEx4RkxaMGp5cmxxYW1ZaXM2bU1yL3h5L3MvdmhXNk5t?=
 =?utf-8?B?UmY1RVYwWS9sMnhRajdVOGVRbHVuRFN0a0pJOGQ3RUh6VmFwRUxsK1NlRGta?=
 =?utf-8?B?WXBzb2hvNG1tUGtOVkRPdUxweEwxYkNyVkxPeVNKWXV4bGU4WTN6eGhrQmZU?=
 =?utf-8?B?aXNSSTFOdk1ab1Nrdi9HMFpYZkRScjZhcFhKZjREN2M0aGJKd0dBZVhIRjI4?=
 =?utf-8?B?K1NTL3c2Q0UrR2drK2NJRVpNNVdkWng4TjYzL0MxTG9JN3ZjVmZ0UTRiRDFY?=
 =?utf-8?B?ZzI5eDR6ZmRMcjBnaXNmNFFWdXQvQ09rS0h4RkdJRlZmUHpueTV5cy9mUm0w?=
 =?utf-8?B?YjRvQ0doRWJ2Z1Z6YVBHSUlYbXRWKzVuUlJpYjVIcG9rR3Q1MUJKQU0yVUVh?=
 =?utf-8?B?YWVrTmVVMXpaOXhhQzBNUzB5aWhoSXhXb05MNmNmcEkyU3l2eU5ON0JZeEtD?=
 =?utf-8?B?QUNvTkhNMHhhUk8yOWxHYXBwS0VhQTRZbGFWOGNISEhFL3ZjRnFUWjgyazF2?=
 =?utf-8?B?Q1pHUllqQzFxdHh6Rm0zUXZGaVg2QXFVeEZ2RC9YODVVZkprMERLVnVmekRV?=
 =?utf-8?B?TEhpWkJGeHBKRDB4YVNxcGdBRDJXNGZqMVhpUFVxM3pzbXB1Z0pGQzdYZllR?=
 =?utf-8?B?aFdadE1peklEa2pzU1FxMzF3cTNVWDhIcWxEVzdVakN5czUwM0Q4elVtNWUv?=
 =?utf-8?B?Q3dHYm1FRGhEVXpQRUVjbUxSeEFCeHBWRE4rbzhveSsxd2hTYkhBMVM2d3JD?=
 =?utf-8?B?b1lsNXNzOEl1U29QWkVCMDRzMGZWTVpDaGRMWGs2bW1vaVdHVWo4eHNTQk9w?=
 =?utf-8?B?dktWTlJSMjFoZzdLYUVOWlRhRGVhRWcvRC96aloxa3JnQVo5ZGZseHVpbG4x?=
 =?utf-8?B?TXdtNFpvV0ErbnArd09MckpickR1VXJvQUJsaUZUSGgzT0kyc2dCWGllQWtk?=
 =?utf-8?B?WGE1WWMwTktZYTNMRlpFcGQrQlk0dnlBZ2hTelBXU1gwUVo4dTdWWi9OMDJU?=
 =?utf-8?B?NmF6T1hMTEFkc3lHcTBzaUNFazQydTlBOWFVODZ3VW9lWXRhN1hRQTgyTmVS?=
 =?utf-8?B?V2JDUW9IaUt6Um5oakU0Z0tCc2NRTUdCTDB2MVB6aFhMSDU4MjNkdXY5ZlZO?=
 =?utf-8?B?VUxzTDhLZVp0bUxUSkMzeFM1SHBHcEM1MkZKc0NaMFZ1R2gxMzRFcWZWZy9F?=
 =?utf-8?B?MkJZbTRTLzhvaDBoRFBqb3NUNUdKQ2luSkNLOFVzV3NjbjlWMEtaRm12VjI0?=
 =?utf-8?B?LzUveTR2c3hFU2h6NWoybnN2WGJnd2l3TnhzZm8wbk5XaDFTWGY1c0QxRE1v?=
 =?utf-8?B?TVFQcmxZdlFoSGNrL25iUkErUkhDS3JxeFlBRStKOWg1aHFiOVZRVXhaNkZI?=
 =?utf-8?B?UldkdzBLbitOYnlvcGNCZUJxeEcrSHd1a09uMHNmckRNOWpXekJNcW9qbG9x?=
 =?utf-8?B?QlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EE9261EFC93144C9961F01841706F55@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c5251f-e654-4572-2c5a-08dcbd846aa7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2024 23:46:00.2232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bttux2ADgGF5iz2/8XkHoaapA+WRdicfQ/nf3kHXBYGynE5tdzviE9n2ePCHsbEp5iEO7O3uWV5x2E04UZsfVnkh/AFlW+rSZkAx+QNeHxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4744
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA4LTE1IGF0IDA4OjIwICswMzAwLCBUb255IExpbmRncmVuIHdyb3RlOg0K
PiBXZSBjYW4gZ2VuZXJhdGUgYSBURFggc3VpdGFibGUgZGVmYXVsdCBDUFVJRCBjb25maWd1cmF0
aW9uIGJ5IGFkZGluZw0KPiBLVk1fR0VUX1NVUFBPUlRFRF9URFhfQ1BVSUQuIFRoaXMgd291bGQg
aGFuZGxlZCBzaW1pbGFyIHRvIHRoZSBleGlzdGluZw0KPiBLVk1fR0VUX1NVUFBPUlRFRF9DUFVJ
RCBhbmQgS1ZNX0dFVF9TVVBQT1JURURfSFZfQ1BVSUQuDQoNCldoYXQgcHJvYmxlbSBhcmUgeW91
IHN1Z2dlc3RpbmcgdG8gc29sdmUgd2l0aCBpdD8gVG8gZ2l2ZSBzb21ldGhpbmcgdG8gdXNlcnNw
YWNlDQp0byBzYXkgInBsZWFzZSBmaWx0ZXIgdGhlc2Ugb3V0IHlvdXJzZWxmPyINCg0KRnJvbSB0
aGUgdGhyZWFkIHdpdGggU2VhbiBvbiB0aGlzIHNlcmllcywgaXQgc2VlbXMgbWF5YmUgd2Ugd29u
J3QgbmVlZCB0aGUNCmZpbHRlcmluZyBpbiBhbnkgY2FzZS4NCg0KU29ycnkgaWYgSSBtaXNzZWQg
eW91ciBwb2ludC4gS1ZNX0dFVF9TVVBQT1JURURfSFZfQ1BVSUQgb25seSByZXR1cm5zIGEgZmV3
DQpleHRyYSBlbnRyaWVzIGFzc29jaWF0ZWQgd2l0aCBIViwgcmlnaHQ/IEknbSBub3QgZm9sbG93
aW5nIHRoZSBjb25uZWN0aW9uIHRvDQp3aGF0IFREWCBuZWVkcyBoZXJlLg0KDQoNCj4gDQo+IE9y
IGFyZSB0aGVyZSBzb21lIHJlYXNvbnMgdG8gYXZvaWQgYWRkaW5nIHRoaXM/DQoNCg==

