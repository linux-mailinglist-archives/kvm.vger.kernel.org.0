Return-Path: <kvm+bounces-49297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D09CAD7665
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:36:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B14CC3B5EBC
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78864299944;
	Thu, 12 Jun 2025 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DBVcFbG7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD939298998;
	Thu, 12 Jun 2025 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742031; cv=fail; b=gYI2yqgb6dx2apjiiMW1dMAM/vU+SuzVKucr+kNMJaq3GkODnAgSgzluUSq0vNGjJhI/jggSkEJmK32hVKepqGGQBIC2QxfAnI8UJzBrA3S1D0fH+wx7rXCNFkjGq5r/6/PHD+HxkWgKpo3JMQ6vKqEj2k15sCkKxyyR44fzca4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742031; c=relaxed/simple;
	bh=+Uk57wSbV7Qkfw6Q+o6Ral76TTlm2/zw1ylOTGLfryA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cWNo5kQ/3RcdOIIy8zIAHf1UHRRZEvA95g0wYiDPQy9FqkYMUPqYpTLdkPH5EEmZNwCZdv+EhfLV3oj5kwxHoub5bAkAqb3Dm2/39C2KAzqwyOy4W9YhbEfub2qYWb5Y8ntkutHg7GewpB0/r/d16OReXDFsaY7DFz8PhHlv+Xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DBVcFbG7; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749742030; x=1781278030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+Uk57wSbV7Qkfw6Q+o6Ral76TTlm2/zw1ylOTGLfryA=;
  b=DBVcFbG7fFCYBZqyplsE1/v55Txi6IOtWJlOAZOtHuRklpj1PgNht/uU
   SgQJLKTPuVz7vqT9MDIs6LYn4ctBgBni3D0e8BQfsvVGtaXwsBam5vm09
   2QtNnEJ8O9LtECBOEBih/EKHKkI3AIw58NlUYp3TBCkDw1yvj9ontQZE4
   Fo14UtdFuxDL+l2mI6av41tsCRtkuBYhRomY1DCvswFv66tGqT0WTbbh1
   U6nHHPNmFr8jTnuCmPnPWXHcGEVrbQQtVXalRe5/6nDvFrepX08t79Tyi
   yZACpbeFT8ixqMVlxn1Z8TffEWXf/fvFTkpMS0OvgZROeHccALlNR3TzL
   g==;
X-CSE-ConnectionGUID: ut5XRFdaRSa6iPer5Huypw==
X-CSE-MsgGUID: 4xi15SW/T8ifWbIvKDp/rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="39542707"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="39542707"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 08:27:09 -0700
X-CSE-ConnectionGUID: CVakKCjYReygaw5Uu64zMQ==
X-CSE-MsgGUID: 1iPBwOiZTfaDzKMp2ksyIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="151382997"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 08:27:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 08:27:08 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 08:27:08 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.55) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 08:27:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tjr7EkVz9huV7g0eBD+NGfl8L4FwvAR8rTJxF/zW6+F1zjkdumCXABkcw1HYoxn0k/lrgCAL52rNhBUzGE17RgJDkhEl0QRqn0P929STdrO4qfFH994+u+SGHJr9LZFeDTKkL8IToge4woV62kSzD7E/6cN3YwXsrR9kuHfzID5zauTou32qO7w507NT3CsAcc5tdSdzDaenupgcEmq2NbCGUYnu1wdmNuUiNFSFRlUsSRDaIK0Qcq3Fp1KAPwT8WLQnKBeNUJQM6AYrtFutPmmGHbRQLFgXhucWNAenoAC5taEeCWZBPqAhFoltAm3Coe+LGGVl7ps4RoqYHL8j+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Uk57wSbV7Qkfw6Q+o6Ral76TTlm2/zw1ylOTGLfryA=;
 b=OL3t0WsrlhYdsfxR0CHRZnjuEgi87XLB18AqLwspfh4BEYzsJ7reCAYuYhIwZJrbxoHrlyd0pa9ajoVb/y6tW2GF4rrkmIB0AaE0/k+MOr7G8X3GM6fWOlH7OV7XyF360mSgX30ZS/NkRWZ3SusS6k16ABAI2ckalF39ZaB0xawT9DB1k6dVZycfOj0Rrg4TGxmlFwVowceofI9sNzjFZWd4Mq/oOIO42G5jpcdFdwVDG4R3mwpFYNw5vIRzhRwlC9x1i+UwmRQ4jH3cIlPo2hxqvacs49LUjafNqC4rU+SOtZX7BNSSmJjNZgV8kpG54udCwrG1m21oIikdVenLSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB5254.namprd11.prod.outlook.com (2603:10b6:208:313::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 15:26:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 15:26:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Yao,
 Jiewen" <jiewen.yao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Lindgren, Tony"
	<tony.lindgren@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Topic: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Index: AQHb2a1TbQakduG6E0K+sX62VG3CXrP8HXSAgAESDYCAAAs3gIAA02cAgAABHgCAABiEAIAAB40AgAAWhQCAAO51AIAAdTIA
Date: Thu, 12 Jun 2025 15:26:51 +0000
Message-ID: <d7ca6f2cfb5e1d24c2331af425a538b996d12004.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
	 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
	 <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com>
	 <7f17ca58-5522-45de-9dae-6a11b1041317@intel.com>
	 <aEmYqH_2MLSwloBX@google.com>
	 <effb33d4277c47ffcc6d69b71348e3b7ea8a2740.camel@intel.com>
	 <aEmuKII8FGU4eQZz@google.com>
	 <089eeacb231f3afa04f81b9d5ddbb98b6d901565.camel@intel.com>
	 <aEnHYjTGofgGiDTH@google.com>
	 <88c3cd16a24c7318f671223bd65eef63fe276a08.camel@intel.com>
In-Reply-To: <88c3cd16a24c7318f671223bd65eef63fe276a08.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB5254:EE_
x-ms-office365-filtering-correlation-id: 3988ead6-824e-4251-d3ba-08dda9c58e77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eDVPRkZiZSs2eVU3SVYyZTIxcUcvVm1ZVEo1OXpydGQ0VDNjQmd2dzI0aDI1?=
 =?utf-8?B?bzJIT0hmZG5mMk9qbkRqVVJiMm4zaVNmQTlQOXFFSVc4RnVBVzMxUFFkZXNw?=
 =?utf-8?B?SUh5SEF5cjgyVjc2enYxQzhUWEg4WURBZzJBK3B4K3Q3Wm83NUtRazBHVmRx?=
 =?utf-8?B?d0NTLytTdmFuQ25GNmRMVWp0STllaHVKcVpIUW1veEhCSEc4TnZ6K3pyRTNL?=
 =?utf-8?B?ZjBwY0t1b0RmQk9hWkJwcjRIQ0VEZ1RkTk1ibXJyV25mZkJQWUtYUXlrbVor?=
 =?utf-8?B?UlpHYmR3elRqa3BxZ0M1TVc4WFd1MFZOai9IMExtd2pQUnlQcHhLWGx0TEo1?=
 =?utf-8?B?TDlGYmpCNU5zelFWaHhHeWdFZEFnNzYrWUlxM0ZWTk1qUU10b1FJdTMvOHFz?=
 =?utf-8?B?WDFQRWV3aTAzcy94R2dIRGs3VG4vUnBaZDh3YXBzb3V2ZDBYbmhaZGZKaUpK?=
 =?utf-8?B?aDlLNmtIUGVxTDhuN1JnaklHNlFoSHVhQlB2Q1diMkliNE5JaDR6aG9WTmVW?=
 =?utf-8?B?TlUxRlJpTldtSTBwTnVwaVR3STEyaXU2NGt2ZlY2cXRQejg3dVBsZWgvRk1I?=
 =?utf-8?B?NFIxMEY5dmRkbW5pc0xoZHFUaHhNQUs5Ny9waWFhSHZlK0pkMVA0ZGF3a3dy?=
 =?utf-8?B?NmpYeEFiVUdGUElaTFNSWHQxaHZqUjRJNUtLUjJJM1JaaklpTFBPYzRnZ0sz?=
 =?utf-8?B?L1JDK1B1VjR2cW1mTWRUMVJETlk1dXFxR3BSaWJyWGhqTGRTVWhHTXhHUEZq?=
 =?utf-8?B?OTNKZEpKcm5BdUNIUjdxWXF6UTRMb2hxanZvNGd0Y1R6OW8vT0loaXV5YkM1?=
 =?utf-8?B?bFNOaDhibHhOZll6V0FhaUgwWEthN0xnd1lickV0Z3FSSEc4aFVoV2NwVUh4?=
 =?utf-8?B?ci9qS2JkWnV2KzhEd28xTnpiZVZ4Y1RGUVJsV2tiRU5ZTUozRVh5OFRjTmk4?=
 =?utf-8?B?VlRBSERLcnBOLzBoeE5oL29hRE1CbjhDbTFrT0NrSVVLUExqN0ZaS3Y2ZGUy?=
 =?utf-8?B?Zzc2YUFuU1JTWHZuVVF6TzdGek92cXdNZTl3UnczWHBOTVo2Z2wzNWROL3R2?=
 =?utf-8?B?QW9XZVhHYnErUlFoU29qZVdXVGhEVFdNQnM0RDZjMXJCMjZaVGFSN09aTW5u?=
 =?utf-8?B?Tzg3Mk9mTDFvdVM3ZGxvcnRIYUZMNHBPRDJZYmlxbXpMRCt3TjRqRU9lTS9Y?=
 =?utf-8?B?SXlQRk93MVl5dlpLN2tWWmJVRlQ5aVkwSFBTMWJ2cFJOeklCajdHTFJYOS9Y?=
 =?utf-8?B?QTFrby8vMTlTUWxDRU1WT1ZBS0txQnE4VUg4blpPbUUzdy9WQS9LL2xQRWJU?=
 =?utf-8?B?enFSR2owYW5WU3VDVmZMUkZXcWxXa29KelZ5RFViL1N5UHJYWDA4QmVRSTVE?=
 =?utf-8?B?eUdHNHVETllxNWtDd1dpZy9mRmJHTXdZbk1ZbWN3TFF5YUh5a2xvS05xekRp?=
 =?utf-8?B?NzBLOXl2MFBNaUJEcTJVbDE0Nm9oVDBZOTlSNzV0OENqQWZuRTdoVVpIWnkv?=
 =?utf-8?B?KzRyVG1UOGo3YXVTL2dVaGQ2Y2hBaGRhb01PcGpob2dmTFZaTHBmQ2R4ODI0?=
 =?utf-8?B?WlZSTU1DWG5BV3NqNzF6ZFFNOHBPRmtZeXJtZFI0NS9uMmZSekc0N2NPZVI2?=
 =?utf-8?B?OVpQZSthMUdDd0EzaXpoS2ZTUGZTUmZtb094b3Jvajh4VDUvNTIwSlVGQUJI?=
 =?utf-8?B?TUZRdU9OcFFxdFpqdzJnQkVWS3lhWkFiRjBLMm1jVWZBcWpBcmN3a3Y4U1BH?=
 =?utf-8?B?QmhqOFlsZXc2WklwTmk1V3ZxZVZraVpFaC9jNDRzb1AxbzlEb3RMUGwwRG1O?=
 =?utf-8?B?cUhzU1RQZm43cGdJeE1uQ0ZndWlDaTZMVGxrVEgrSzlwbTBTbXlnTlJxdFFG?=
 =?utf-8?B?WjJPQlVIc1lja2lmU3NRMGovanMvU2hwNGxXcDRzWVpmNjE5YW1XTlBnN1BF?=
 =?utf-8?B?RWkrSU1pQ0g0eHdPaWM0dFNpTjhYMG9POXJIQjZlRGN4UEF1U3Z6K2puUmZv?=
 =?utf-8?Q?hA4tbrpLzbpviBhm2tvTdXJkbjZ9c0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDFCS3h0TW5jMTRRbEFYZDhnN0pHbk5OS1lacm1UQkRKaUlkWlFYckFhdi8v?=
 =?utf-8?B?TVBLckp3UmFaK3gvbFNQeGRpMTBQTlBtOEhiSzZEVXFCL3diQ0U0QjIxWlNa?=
 =?utf-8?B?TXF0aFNZL0pRa1NrNTQzdUo0V3owWjE5bHl1QkdBbHlyYmRmUFUyS1I1K2xS?=
 =?utf-8?B?WDRud3U5UWVZWHZ3dnFLTytlazNzV3dxdjNWNnVOTFRvSG1JK08xdXd3eTBp?=
 =?utf-8?B?cVJDSWw5RkpPT2xLRHlXc0FKYWhNQ2RWUEdRUC9QbXlrdXJkTnEzbHlneDR6?=
 =?utf-8?B?MlU2OVlNWTZINjI0eXNCZVRaMmt0cXRRUTZ0dzgzQmRweEZTQ29XeEZXVmFS?=
 =?utf-8?B?Rk4rUkVyMTNUa2FlcnovQ2RzQ1poc0t5WXgveEJ4SG12VHpDZ2s5OHNXQy8x?=
 =?utf-8?B?dWV4Qk1wZzM2a2lxc0FOUFd4WE9lRGd5OTk5aVd2MVZPOC9sZ0RpV3ptZVZ2?=
 =?utf-8?B?M0pjMnpjZWtHNUFEdnNqWGNBR0NQMTRDbVNSa0xEUlR4d0VLME9tdFpwczFq?=
 =?utf-8?B?TWZudDQ5dnd0QVBGSjRvUEFDOEpYODV0UnkxN0R6QTBYK0pVa2ZNNWxWMllv?=
 =?utf-8?B?OVZjM25yYi9kQVJqY3lHWWtEeWtxVnBleG5WUjdjU0xYQzV3QllaMG9pSVVt?=
 =?utf-8?B?S3hUUlhYaTFKMllHdUkxV04wSnhRamR4MFRrU3JWYnVXZXp1TUd6SGdqMThG?=
 =?utf-8?B?UjVFdkhuOWJDZkFkR3V4anl5UDVIOWtEVHQwZVJuT3k4akRZMjh1NVBFdkEz?=
 =?utf-8?B?UkgxMmE0Qk5GL2tEMTRXbnYrdUYyMVdOZnVsdEhFUnRzbUtXNUg3REVJTndZ?=
 =?utf-8?B?eERkWnoxNDNQNlppMWxZTzBpMllSWWZSRE1GTXFwYXJSN1YxN1BtU0dQWTN2?=
 =?utf-8?B?Q3VXdURuaUZtSkxwZUV3VGpFY3Blc3dvNGthSEZjWjhmeFhORUlBRlpkb2ND?=
 =?utf-8?B?R3l2RWdmV0tjeUE3SGtDalhCTHRzK2xhUEdyaW8xQTFRMUJxV0xoTzFKdnF5?=
 =?utf-8?B?djVhNVFxQk04bk9TMFlIT3NiRmxQTHE0dWJiaXRjdDA5R21qazdIcmxmOUJm?=
 =?utf-8?B?Vk45VlMzZnMzWmU5Y3NiVXloSEc1MWVxU0E4R0JiYlNHemNxYkp1cE9LaGI4?=
 =?utf-8?B?d1BZYUpRMzJaOWd5cGVUeTkvN3ZRN1R3VkpRVVpuTW50akI3UlVWSWJObXp2?=
 =?utf-8?B?Nk1ucUp0Rk5adjViUzVZL3Fvc3VIbitLOVVRemNHbTFMZDVQUWdkN1p0eXhW?=
 =?utf-8?B?ZXpWRUxUSXpRZVRMQ0xBS3hLbm93UXRlTEd1LzJ1ekhCdUhPTGlEMHVRdGFE?=
 =?utf-8?B?SCtDZ0c1NmR0VXJObzVacUFwMjVLcGR1NmFDTXB0Wk5remF0eGFRVGxNSVJu?=
 =?utf-8?B?Rk9GZnJQbUx6WUltS2daQkYxVHlscGZuWnRqZ21UL3JxcUxNR1NMalh2MlIv?=
 =?utf-8?B?WUtCcWJaZUxodW85a1R4VSs5ZDFFN25HbU9Za0VCcnZnL3V5UHNCMm9BRTdo?=
 =?utf-8?B?WmQyV2EyMCswN3NCR3VMZDJFVUlKYk5TMkdaaENZVmMxOWJFVUpacStTYU5p?=
 =?utf-8?B?bFlTWk95eXlWeFFHd1ZDbXB6Ym9JMDRRVGFndk9EWm8xWXlKUmYrd1BTWHJK?=
 =?utf-8?B?Z0hTQWdPUmhJcjRKRjY4bTFiOURxUmNTZGJkQWRQa0dGeVJmV0FQaUdGMWp5?=
 =?utf-8?B?eEpJZjBSbElMTTNQMkRqdzVZTDhQeEhzZCtXbWx1QkFkczczcjhNYzVTakhG?=
 =?utf-8?B?OERvZkF1ZW9yemJML1Rib3F1aXNvUldQOTQ2WTV1Z3gyZjdBOW9XSFVzZUlh?=
 =?utf-8?B?ZkNGZzFNVUxObVpBM2E2OHFqZUl5UnZOQXlpbzVHVy9MejdxNGtVd245dWp2?=
 =?utf-8?B?b1pML1RidUdoQUZKTDRWTiszQXNDRSt4dmhsYnNaeHE5NXRLZWY3bUlJT25a?=
 =?utf-8?B?TU9wQlZRQksxajREaDRRazN4U2RVNnMxb0VKVHlUMWlKYzMwS1FWTjFDbnVR?=
 =?utf-8?B?YVJCSEJaRUV6VGRURkU2aWlRRlZNaE1UWFR6K09Ud2FMVm41d3o1MGhDVHFT?=
 =?utf-8?B?WGV5THRoZGUrTDAxVksxUDdVUlhuWFJaVzJ4WThSdnVwMWR4ZjFSUEVkb21C?=
 =?utf-8?B?cW1tb0pUaXRMWDRESUlhNklQSUtITGs1WHdlc1dEY0ZzbmlpeUJmRTIyU3Q2?=
 =?utf-8?Q?eVSoacQ30f0dkjttOvIxtpg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB73FF4B6F752A4C9C0F716061941099@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3988ead6-824e-4251-d3ba-08dda9c58e77
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 15:26:52.0216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w0z7fEh2ywUej2HKtFTmqxfIDc2zF5ssVVOxxiDwUSTRjlPNIb1BCbGcvEG06j9XbjwPIEmVu6D5bihIiEarkD1vR0k7Gm0DUeuotBtjsdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5254
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTEyIGF0IDA4OjI3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBX
aXRoIG5vIGludGVudGlvbiB0byBkaXNydXB0IHRoaXMgZGlzY3Vzc2lvbiwgYnV0IGV2ZW4gdy9v
IEdldFF1b3RlIFREWCBjYW4NCj4gYWxzbyBzdXBwb3J0IGF0dGVzdGF0aW9uLCBiZWNhdXNlIFRE
IGNhbiBqdXN0IGdldCB0aGUgVERSRVBPUlQgYW5kIHNlbmQgdG8NCj4gcmVtb3RlIFF1b3Rpbmcg
RW5jbGF2ZSB0byBnZXQgaXQgc2lnbmVkLCB2aWEgd2hhdGV2ZXIgY29tbXVuaWNhdGlvbiBjaGFu
bmVsDQo+IGF2YWlsYWJsZSAodnNvY2ssIFRDUC9JUCBldGMpLiA6LSkNCj4gDQo+IEl0J3MganVz
dCBub3QgYWxsIFREWCBndWVzdHMgaGF2ZSB0aG9zZSBjb21tdW5pY2F0aW9uIGNoYW5uZWxzIGF2
YWlsYWJsZSBpbg0KPiBDU1AncyBkZXBsb3ltZW50LCBhbmQgR2V0UXVvdGUgY2FuIGZpbGwgdXAg
dGhlIGhvbGUgYXMgYSBsYXN0IHJlc29ydC4NCj4gDQo+IE9mIGNvdXJzZSBub3cgVEQgdXNlcnNw
YWNlIG1heSBjaG9vc2UgdG8gb25seSBzdXBwb3J0IEdldFF1b3RlIHNpbXBseQ0KPiBiZWNhdXNl
IGtlcm5lbCBzdXBwb3J0cyAidW5pZmllZCBBQkkiIHRvIHJldHVybiByZW1vdGVseSB2ZXJpZmlh
YmxlIGJsb2INCj4gYWNyb3NzIHZlbmRvcnMsIGJ1dCBzdGlsbCAuLi4NCg0KVGhpcyB3YXMgd2hh
dCBJIHdhcyBnZXR0aW5nIGF0IGJ5ICJTb21lIGhpZ2hseSBjb3VwbGVkIGd1ZXN0L1ZNTSBoYXMg
YW4NCmFsdGVybmF0ZSBhdHRlc3RhdGlvbiBzY2hlbWUiLiBJZiB5b3UgZG9uJ3QgY2FyZSBhYm91
dCBydW5uaW5nIG9uIGFueSBWTU0sIHlvdQ0KY291bGQgaW52ZW50IHlvdXIgb3duIGNvbW11bmlj
YXRpb24gY2hhbm5lbC4gQnV0IHRoZSBzYW1lIGlzIHRydWUgZm9yIHRoZSBvdGhlcg0KVERWTUNB
TExzIGFzIHdlbGwuDQoNCkkgZ3Vlc3MgdGhlIHdheSB0byBsb29rIGF0IGl0IGlzIHdoYXQgaXMg
dGhlIE1WUCBmb3IgYSBURCB0aGF0IGV4cGVjdHMgdG8gcnVuIG9uDQpnZW5lcmFsIFZNTXMuIFRo
ZSBvdGhlcnMgY291bGQgYWxzbyBpbnZlbnQgdGhlaXIgb3duIGVudW1lcmF0aW9uIEFQSSBhbmQg
cmV0dXJuDQpmYWlsdXJlIGZvciBHZXRUZFZtQ2FsbEluZm8uDQo=

