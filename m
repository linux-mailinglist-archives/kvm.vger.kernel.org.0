Return-Path: <kvm+bounces-16813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D43F8BDDF0
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EABE4284ADE
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0FC714D703;
	Tue,  7 May 2024 09:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="REGXPaej"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695DF14D2BF;
	Tue,  7 May 2024 09:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073531; cv=fail; b=KaBjKo2tSRFpxGPFD/q/vaYk7YxXoVBuai4ZgWZasRCHGIIFOQX9YGnAU+MfDH930LytseSCRHW3FqZzm6/g0OHc0K0yvWeS5MyySMFNkJJ0XwNzwd+QtW+fbVN0dyDeuoKC45CK3znZ9yKuvuVBfAPePN7rDaPFgzyKBD2HHKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073531; c=relaxed/simple;
	bh=76aTYV0SywrLZ9QyTLe5/Ehaf+3FBmUnrzZKMrzhIhc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gsWVLHharPOhU7yroWhOYYDNLC0gLNXipP2TUjAruF928Xq00SbFzoWqbdaK9nnPba3KH1HnmiSBNTGK26XI2YTCe5vdQhfknEBcc5R63nU4qbAa2ITkWriJNhM34vbgj9h5trETL1PZ5noZgyl3MZvomxucMVElysWP2onfS5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=REGXPaej; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715073531; x=1746609531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=76aTYV0SywrLZ9QyTLe5/Ehaf+3FBmUnrzZKMrzhIhc=;
  b=REGXPaejA9+qCXdY82MT+Wbfc0dO9GRFXTGUWBxoMRDlb+PJhAvsgHbM
   N5sWklcpYYKU8uFUlvyinlKt+o3vQcizeUucuKvtRamXgXnarxlEWQnPR
   isoFCCGByRrjbyjPvy4cfb5pwNihvKEuuIbDc4UZjRjiY/xUTPWnylvoj
   Od8dG0zQe9aAzbkP2nmhmmZ2xgXwQ15jg1oUg+AXsvDu37AN+htrl1zmY
   oUTFMUOKAAP8iZCbdJA/v7wwivfeXcaWiIFNSLjC/e8CH4If+A/jdbE8f
   C4BdcIjy9iWLLJtltieKwzNU8tbE7zl5LOYT83Z76244dSCM1kq1IA3V3
   Q==;
X-CSE-ConnectionGUID: qyh4mc5pTOSnSKR3RYcZDw==
X-CSE-MsgGUID: jfLH1Bx2Qd67P5qMpWyxmg==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10691744"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="10691744"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 02:18:49 -0700
X-CSE-ConnectionGUID: h4vLiBdKR8+MItK/MlpnAw==
X-CSE-MsgGUID: nWKUMD3QRESLPa0xgiPhqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="28847725"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 01:51:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 01:51:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 01:51:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 01:51:34 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 01:51:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLq9eTh+iVomAPdq6Y3fBQ2SAP5AyjpkY48b14O4RE1bHBQJtKY335I45gJsXz/9nST3YDK8n0exEBhcNL6iUzLpZnE4vQ4LVqvz3fbgqtTSnK4sC2w3hm622Yj1+qeVNngS2eUw1iL2G2DkZNJxnQWILZ/e8FGQb+ES520aMXOagHDfhmyUKUqJaGSPpHEHHF2dXn5QFT9tZGQtqxXkGGD6n0fSjeTKlSR1CJzfUBwfgyG71Fq+2EF97ArFspYnA8CLmOvPXJvoJb0H+nTXcEWdkQb5Lsm2HLyEjiv6tQ2k5KPPFzbsfovr8DdsXxo8Hqv6URQAyztGhXklmmT1fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=reNSG4Dtjpt8DBWHX7knmcr7JljSnMEaDSeAoaTtb74=;
 b=MVHw/D/v91366sJKbuK5/gvpTJYq9DeaHbA1lzOThKweOC96w6OUhaxVoOQ2gYE36GsC1lDvCiFGvVQFKAeigZVU6ueBVOmsMormdOd1/cOREAkoqmM//o0L8rcQMqlJrrSiLGJoFQSZ5r95AalSoH8HD1FgNIRXpdu3pkd3bu9LJk7HEcgnOy5dSXxZIZEfNLC2PI4268jQ7WtBgC8DhpPhNbCdsEoH1Fy0OZG6pKgfW693HcIlasCaPXmis7VTT5bCQB/i4cCL3p5zbTk7gwpNZGA/7ZcXGfSAULdoxwxaD4cE2gZYjzKwxTbBsbjhX7IU1xh3xrppW2zOK0mVrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7960.namprd11.prod.outlook.com (2603:10b6:8:fe::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Tue, 7 May
 2024 08:51:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 08:51:31 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Thread-Topic: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Thread-Index: AQHaoEbP2GjyTtCjMk25/ApsokAYHLGLc5rg
Date: Tue, 7 May 2024 08:51:31 +0000
Message-ID: <BN9PR11MB527617EAB9BE91A730AC25A28CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
In-Reply-To: <20240507062044.20399-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7960:EE_
x-ms-office365-filtering-correlation-id: 546c340d-68ca-437e-1baa-08dc6e72e44d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|7416005|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?axJ2LRlgW4VmN5llYbhJbnSG0ja3LcbdYLADg4F3yZwUE3JOtUytKClGh2eA?=
 =?us-ascii?Q?pQc+e+j0evuiNOCM9TuVzdnp4W6vovOfpULUfOww4FjeASdi4prqmF9iTHkL?=
 =?us-ascii?Q?kMFy4f0tTakTfS//vuxZs9AaL8EvUKn3ceKAvIY1iUD08kWObKRj7/dsJD2b?=
 =?us-ascii?Q?B6PrE1K+9YbjR6ihycjwTo88iEQICjUi9aPlcg2KGTjChERVE4xlYyeWsggC?=
 =?us-ascii?Q?+ZRGxclEm9ZmPgK8Ok0qXHC5zFPU0BxKOfEVFgo3g00FCS/JlZhcFOcMkE/F?=
 =?us-ascii?Q?vntskziX1Hv3y7nptomcdMHCa7FuPmPFVWBL4DQdDt01mBLbAF520dmrXTJd?=
 =?us-ascii?Q?wlKmJtFPgWcLxPuunm6CvxnoYZttYABBztF5b11sGN7rRT8RYqpKpFU4B04b?=
 =?us-ascii?Q?qk+9PmQuL+FBxQxBr3t/lQ5FmJSqjkA3xU9YfbWYddc8TJOvXv4tUlLWhXG/?=
 =?us-ascii?Q?q+4MAs/Rok2TxTdG5u7Inhdv/+ZyF/cliVbDiNoYbEG4bq/ZXyqGsZ1amg3E?=
 =?us-ascii?Q?ifVWJ3gBqu7Wwe20i35uX/aaWnRPhhweGNQFnc2a2FmlTyfXseZtxNyiHTUH?=
 =?us-ascii?Q?Cc2agdRq2uAUd2rPCQNyY+l3lsZvfhTb91Ro4oOpf/Fjc1cTI9cleOgnkERT?=
 =?us-ascii?Q?ZhJCUyZKOSFIdeXpP3XPdmLCv+1vcasxJN1KBhyAC9eQr8hlLHis1ckPjdUf?=
 =?us-ascii?Q?Omib4XxLGY3bmte6HTBPA7gxH5qy4NAXi5N9P5j2Epe0OulT+8yd8XHkLjH7?=
 =?us-ascii?Q?iS3RCeDy9urrYzw9KZR2NuDpE7D7rJwNTG6A5OglpM/shNNrSn4EiJfHaawO?=
 =?us-ascii?Q?RpU+OZ4pXQNEu34Cakw9jBtGyrTSkMn3bHKqnCSNnQH5H+SqvWfnFyrDflqY?=
 =?us-ascii?Q?A6LndgmYAPtlhsJDdQTrknj7sYYpXrY5+M8Lpd1HkCHdxVC2tS98BHVuWTAO?=
 =?us-ascii?Q?a+UkONkjRL3U/A1FJBu9H8pUvSrXm1QnOJaAQsl+6Merbkwjb+XXtZTIlmU5?=
 =?us-ascii?Q?qFZnTU4CYr3qCzfgidGfuJJVExOFsOiS8NleQc50LVakvbpfQn3KuzEYzJQH?=
 =?us-ascii?Q?5FlO34w36OBqFraAQPxHyS1Xgvbcs3xqxp2W+Pv3A8EQSvOPizNoqadU5HPG?=
 =?us-ascii?Q?HtskZhGZKEFxF8/z55LQviqwx9JZbTLQ+Cv5vEDu+TYCAmrc0Llg8yIXzmSg?=
 =?us-ascii?Q?A6KkoGT7UnaoYSGs95KxVoEbH1j0rnRHd7Uch0ecHYtV6WgtsQw9sW8N2MbB?=
 =?us-ascii?Q?udYmnstGchRMhWyjCqnIAAx+DRmCwT5J2E5D4SW1kMrmH+bXUMRE/jmR7Chx?=
 =?us-ascii?Q?P5LGHI6ti/Jq77eexrXI3axTp7V8O37//1SW0vWpnWXHfw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1cipisVsgaOBs/exN1S+jatl/Mb1r21Oidx9xjaKm+i1m+uv7LYP4jYMzoT3?=
 =?us-ascii?Q?Y3U3r2h0RwIUcgxDvQn5vYjjpPbUX4X3e9Rtk9kSd6URNZV8o6CNCbDw86CK?=
 =?us-ascii?Q?U4B0ITt6kCNHNQuWSAR2yVgliWXCwa5Q6F/E9vFx7PSABQqgEUzVBzJq65mB?=
 =?us-ascii?Q?IH0DPoVSReeInwQS04sd4YH3WgOJ/TJXPEZsJXfEb93bu89pN18aTwU89kow?=
 =?us-ascii?Q?vFH+YyYN4HqVBOwI42RNhXn0OC05zTS94XVSZvFvJ5nDHhH2hLb2tmOJjj+E?=
 =?us-ascii?Q?v4+m1+R0qoq6bOV7S05b8j8KfvujBBwlDMQ9Tlx22Z8cXyaTNolBUypm2/Xq?=
 =?us-ascii?Q?IgOErMwYjmt/BZIOPGSpX6KyJQwp44HAJvffNvhJ/u6iBAzGBYR1uU4x591A?=
 =?us-ascii?Q?l6fQo94lT+qRaKvPz2uAOahHNLo9eshdGMJbITsbybTbUPRrpD7Lqpc9LDWd?=
 =?us-ascii?Q?eWfjU20hH0ayWTpXKvjH/l3nkWiALQz3ARRY1wGWGY/HC2GsQch8mIw8kDQc?=
 =?us-ascii?Q?2GvWQGVUcp6PLYz48rmjnI+0UPp3i/F2cp7Xe1zScGX1Ee07DGrbpR93FLkX?=
 =?us-ascii?Q?dd49wL0UV0xv3wKXFTxq2mtUIi8LKnLL9ebOqEvUClGKcQreysx9TG1MRGOw?=
 =?us-ascii?Q?Vvp0qQaYrrRCRc6j4yQIAlXGd0OvHh8jGxZTYut9AqrLLfJV3S9V7JGTcQKt?=
 =?us-ascii?Q?QmDg/u7L4EoEV98comos5n2dS8cogXqx2rgqWqBb8bGFJMs5ZrzPeRxGjS8S?=
 =?us-ascii?Q?QgFxwrk3khoH9YYtGJyw/E0qt08xKGuPPQKIsURih4BW0mph/X8HnGctl3/H?=
 =?us-ascii?Q?43KuBiLx8Jys3oNI2uYMxY0qwb6ZZRzkURLsyED+3nc9+6pYLpCLOJ3lOvel?=
 =?us-ascii?Q?S5EJ9LmHg321aqo303MxS5ohejfu74GoRp5paUsYBN80CnRcs3bZ0NMGSLYE?=
 =?us-ascii?Q?OSGVqF8TuXOBlahUY92JllG5Y1mSx2VHKPF35NsR7Dgj09zPO74GH/G3A9s6?=
 =?us-ascii?Q?SRYUM3G0dJqT/xx01bSuUrteq2l4k9PsBq/1s1l0RThHToL7t3zIHPKfqqTC?=
 =?us-ascii?Q?5l8ZnihMQyLe/fqjz/dsngURzdQi6WqNcD5eLV3GZRCZD/Gb1ZAPb6kO+y7j?=
 =?us-ascii?Q?fnL0YGvlPmp3lEKS/LR4R0R5Bg73vWh3iq2DYrC7GXnazk1bOUvm7KZXiUXl?=
 =?us-ascii?Q?N5sy2b3Ck14zgikThacIq1msumPVnPGtJGGh5TMUAQVJDRn4I8IHZyLDED61?=
 =?us-ascii?Q?NLhRHs8b8WWvD4D43RTPH9GzAI8HXoSYdgBmNzIv3sYYuzAF393yWXUWcmgG?=
 =?us-ascii?Q?NxAJF68XXQvZlxaVlw0a1BiD+KRIzhjtnJRyUxD9gFQpXwiMwoAfSWmTOidz?=
 =?us-ascii?Q?IGUmFo3811dqf2xodRE6DVwzpviNv88SR9NYDWhku0WQmeNN9GQc/ramWDON?=
 =?us-ascii?Q?YBPYnP/QfHWL29OeisuFx5UXK+DltWKY19VagZbiB/lXeaPFl1foVIwBKS7B?=
 =?us-ascii?Q?8n+IxSWjJsjzGqF0UpMnaqLrvs+C+PmGMsQFRzmVJAZVgz8Kk+9mendFG+Zj?=
 =?us-ascii?Q?OtFoDPCtpzwyb39oFQ80vvgO72NkTcQJwnG2WHwb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 546c340d-68ca-437e-1baa-08dc6e72e44d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 08:51:31.4742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hvvaUkuqrgcJjKDUThqzrZGuliG42JTR8o9mHyu6MY9h8sfnVYD+YgJ33kidnCR89DwiPKGyXmM8vh/YYgI2Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7960
X-OriginatorOrg: intel.com

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Tuesday, May 7, 2024 2:21 PM
>=20
> +
> +/*
> + * Flush a reserved page or !pfn_valid() PFN.
> + * Flush is not performed if the PFN is accessed in uncacheable type. i.=
e.
> + * - PAT type is UC/UC-/WC when PAT is enabled
> + * - MTRR type is UC/WC/WT/WP when PAT is not enabled.
> + *   (no need to do CLFLUSH though WT/WP is cacheable).
> + */

As long as a page is cacheable (being WB/WT/WP) the malicious
guest can always use non-coherent DMA to make cache/memory
inconsistent, hence clflush is still required after unmapping such
page from the IOMMU page table to avoid leaking the inconsistency
state back to the host.

> +
> +/**
> + * arch_clean_nonsnoop_dma - flush a cache range for non-coherent DMAs
> + *                           (DMAs that lack CPU cache snooping).
> + * @phys_addr:	physical address start
> + * @length:	number of bytes to flush
> + */
> +void arch_clean_nonsnoop_dma(phys_addr_t phys_addr, size_t length)
> +{
> +	unsigned long nrpages, pfn;
> +	unsigned long i;
> +
> +	pfn =3D PHYS_PFN(phys_addr);
> +	nrpages =3D PAGE_ALIGN((phys_addr & ~PAGE_MASK) + length) >>
> PAGE_SHIFT;
> +
> +	for (i =3D 0; i < nrpages; i++, pfn++)
> +		clflush_pfn(pfn);
> +}
> +EXPORT_SYMBOL_GPL(arch_clean_nonsnoop_dma);

this is not a good name. The code has nothing to do with nonsnoop
dma aspect. It's just a general helper accepting a physical pfn to flush
CPU cache, with nonsnoop dma as one potential caller usage.

It's clearer to be arch_flush_cache_phys().

and probably drm_clflush_pages() can be converted to use this
helper too.

