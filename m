Return-Path: <kvm+bounces-18092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C1EB8CDEE9
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 02:30:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F8301C20BF8
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 00:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A458F6FC3;
	Fri, 24 May 2024 00:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IKGUxIj8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAA0BE48;
	Fri, 24 May 2024 00:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716510625; cv=fail; b=e2nRCO/rUKUqggsOds5v0AiD6Y2URQ0obbuCokoS0PQ92KcHuAN8R2/XHAe90pw1Um4X6SAUnAMIP/nXI0gF0tvwWOjPg6fG6zi73tlTkVBA182/2jab9/I6Vr9YsM7N2Nt1MOvKtE5iVv3mElqVJ1soPGpVDv1z5QCD6C1clA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716510625; c=relaxed/simple;
	bh=JAzsEOjgZv2ZBqBSNLgK9neLD5O4YzjObVnEy9qoGZ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uTEly9So5EOKWhtbmmcCOg983U/UjHxkhOkL/C5jbq3VsHzNw07agnnqdwf9NuDrr2tho/oRLhU8HxK4kX7/1ddTCZyA1lHzO5YY4yekm8QjrE+b3sK00giVpcmr6s6lJdFai0NbUgH18woL5PgoYNW4j/8fPYuO9JNQkGNerzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IKGUxIj8; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716510624; x=1748046624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JAzsEOjgZv2ZBqBSNLgK9neLD5O4YzjObVnEy9qoGZ4=;
  b=IKGUxIj8HYavM5kUGGNCSCd2h/w6s2PpzOciExJ+J6yWb2h7SOwnzQO7
   3xF6tKDltoyYRLBaQk/yUj9nblgr2HfubmFJHv9tceXd4OS1FLnhv5dn0
   O1kCvBoeDV13AtHFakeoPamqxFuW7qSUyPxT3jlbXvDw6EEMJspaqVeah
   gWE3YDscVrA6O6+dCdsx32wls7R4SdIS0uhnkTmvkwfCODB5pczmq3Eqf
   3QifCso/7y92hdamRwvo6xflm0t2XZzjN9nKvR2NHcOLO37Fgx1L9/BH6
   CAE8WLlmTvT47+/TF3089A3Fz9lpCEtDn1sx5x7GQ3gxyY85zLLlvfJUz
   g==;
X-CSE-ConnectionGUID: ytA+I36uQr2BoWAK2Rjqdw==
X-CSE-MsgGUID: 1qiZ6ys9QpajupD1M4om5A==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12990036"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="12990036"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 17:30:23 -0700
X-CSE-ConnectionGUID: oEdUPXUfSeq+OM5ySamBSA==
X-CSE-MsgGUID: NhRjOk10TTm5lR5v26kUmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="38415781"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 17:30:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 17:30:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 17:30:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 17:30:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiEby+0GuF2SEsU8jXF+jKq+cdgL1t+ctQCPt2B1iGd+7M6Aqco2chLdQh3+72p7TwEWGL9VbAsWXe1rYvI8mb32PdW9dQuj4qnrhkDq9rTIfGFPod3VHAjMN+fXrEJmgzzxrROp+wcH4fo7YjyPb8bxNQRVLs7hQhQ9zLnwoF8Qr94mHSund7URD+DKOAfQ6RD+B5kFcUJ8QHx42KJf3cyISfbH5sEfFIeSi1sQkW/AVBu4q6CLX38rk32KJZjrzu9p7+uawQXhLcCn1yy8YD1EeZKcQpp17CpGZDZEBztv5u3klsBRV8RGgcft+7b3vcJ/Vq7h2ZJ24x2B+jTH6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UoTwoKeIssEUksoSDvjXRSOIL+/ZkmMo0K887A/oKMM=;
 b=lnBfHgTDtPGrLFZD3lamxJs5v/97ApFGz9p8+SHkiA6ygoDtS+X2RKInZLhutWUrKbcWMxE9wdWomGEkvA59U9D7ZcrRoxjzesPk1S08u547cb5JaodsAZ7HdoUdIR71k/ptVio0myGnUjc303dVeCFkqPvufXT+OSWgfy3A7DboJXXffYPZLqy7QHVeDoN6pcrANyOdK5QWkmxmifcc/vNNv1HMnV+1nRhqEcFRUAsTSnFMiOUaZn+vVlYeXdMnNhQ4HuVDCtvk74/9KV6tTZER25IsNUMCwb067kt4Yx8jtGbr4A1XbJH9mRwBT1cmBKeyKu40fmyJP/OyMwEvcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB8229.namprd11.prod.outlook.com (2603:10b6:8:15e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Fri, 24 May
 2024 00:30:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 00:30:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: "Vetter, Daniel" <daniel.vetter@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org"
	<will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>
Subject: RE: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Topic: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Index: AQHaoEb1yTw+2+R5T02uRFeJZuQMNbGPN+OAgAER64CAAGvrAIAEE0QAgATCszCAANP1gIABWkKAgAPDRsCAAnQoAIAAA/SAgAADhwCAAB2LgIAABQiAgAC9HuCAAG5egIAAtd9QgAADQICAAADyYIABAfAAgACDD4CAABpGIA==
Date: Fri, 24 May 2024 00:30:20 +0000
Message-ID: <BN9PR11MB52768B71B41ADD916ED51D348CF52@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240521160714.GJ20229@nvidia.com>
	<20240521102123.7baaf85a.alex.williamson@redhat.com>
	<20240521163400.GK20229@nvidia.com>
	<20240521121945.7f144230.alex.williamson@redhat.com>
	<20240521183745.GP20229@nvidia.com>
	<BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240522122939.GT20229@nvidia.com>
	<BN9PR11MB527604CDF2E7FA49176200028CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240522233213.GI20229@nvidia.com>
	<BN9PR11MB5276C2DD3F924ED2EB6AD3988CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240523145848.GN20229@nvidia.com>
 <20240523164753.32e714d5.alex.williamson@redhat.com>
In-Reply-To: <20240523164753.32e714d5.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB8229:EE_
x-ms-office365-filtering-correlation-id: 7dd25baf-f937-49ad-9e90-08dc7b88b176
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?d+wVlUUNQ8MfT5M3kYhStuM4TsvkPE2PmWd+yX2khcicd8aLBoE6ycQrDUc/?=
 =?us-ascii?Q?9mdBtP3BpecHUUu2rR7eNmLowVt5mt0PJUH5eC+Qh+wr1PNo4rCeigwpcaVw?=
 =?us-ascii?Q?ZFCJX8THQ12eNjgceMHLN92CHQPZKCxseaaxqdNN/DewZaIn+hUT46qplQ0h?=
 =?us-ascii?Q?cUET5+v+FI+Ag8Ng1sRWpePmoKyDTK2Zv4hOgQ0AZpLY46HyXS46WjMwhYqX?=
 =?us-ascii?Q?zX6kKjJBRMy7ap9G0GA+K2JHfFg/wR93JAzFqqaP9+j7HHKQEHNbak2JGKM2?=
 =?us-ascii?Q?qttoH7cG9yjqutqTeBRK9y3D5vYtLUrEDiy/o0iqS22VhgdtshcGXe74j/Hc?=
 =?us-ascii?Q?J0a6GOEC91Gq1wkM01/+GAVXL/ujtgFm1VpOVh1UjIEssI4qqoCuUn++kIiH?=
 =?us-ascii?Q?h9KyrClD0lZ6Vjrz4nI03HwGkTQCsLK+w9ABU59l6XBp54v9l+jSEk2aa3S+?=
 =?us-ascii?Q?viYCuqkdDjPUeMUd4CjssYELyZpMwl62EC3kMA3NW3Nu1GVdkzC56TDD+x52?=
 =?us-ascii?Q?tHZ5j/k6EQyGPOzDL3oY4BUIZNSruzCnsd4Xh4BEMgfsEUmL9TOXof7p3yt+?=
 =?us-ascii?Q?IXv7e4xrERgNH7RmetmfRtfH6hIXbamEvqRMz6zQVsGW8miZsih6Trp0/L3O?=
 =?us-ascii?Q?FzUDw0QmS0+vbaLX34sqFx/OugdZnXZLKxGwNmC1Z7ZDi3/GUwLNfxfIU4Am?=
 =?us-ascii?Q?8jr20v9GNuqwd647bKFCVZlpWAc2K0ciWyr8YF73fJFzfBm1xBnMACvHRri3?=
 =?us-ascii?Q?eTRId87Xo4aJGzrzxGtVJRIajOOQcRI0KrIjplGhfLYXrlopd7hirPLqnyda?=
 =?us-ascii?Q?S5+ArqI4XwWW7hfAghWEP8yWb32TpGHzVZg0HaPnaLdFR/ObbddDnnJtDf8V?=
 =?us-ascii?Q?YRP+KuPaLMggjbSY2FbFDUXxTZl7/UqyxoOAMyI/riuE6+fIfvOX2r0xw5SA?=
 =?us-ascii?Q?xGE8Jeji9CMpxmEWXR9LQo9VbxHY1mc4Evg6oYjLOq0ZDW2bAdjU7lP76rNT?=
 =?us-ascii?Q?Gu8BFf4uN4tLNpqcA8PpzEHpcjkpoLwc0SVUwZtm8deb3u5DFlp1zbSb6jxb?=
 =?us-ascii?Q?OBKKntQa9W17IUHnyI4r3R2NCOWo/UxnYFiqWhKUuqvXfJgr1MK12wZQ/jh0?=
 =?us-ascii?Q?toSwimf7wXDyFKmXO4IIbGdbI1ZLLa9UxAqG0fc2lDg650TKFNIp+eeVcQ3g?=
 =?us-ascii?Q?B+gLnW6V3bmff096Aqm1b4iPQHxy3f/JHOSvJNIzfTH5IORDc43Z3tV/Gwy4?=
 =?us-ascii?Q?Cq2L4YjnyIxAIb4cfcbKGgq3W4kzX+fsVkd0FqIi94LXLT64Xkrt1Vs8w4CG?=
 =?us-ascii?Q?fbz/xXHPnkTa0/jq1X1o2kNEVfHNQLArCVwXFbTjpyRt+A=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lDxDEo5Sy3mP/dGgYq1YT/TxqjqiABoLNB4z0zjjVY0XDJm1iRW27J0gF5k/?=
 =?us-ascii?Q?nKMywwSfZbRHD/cls490IjxCNpXo7MhsLCYQyiixRs32Q8a1oywspk0ysDL/?=
 =?us-ascii?Q?D7sX/7xVEf9pZsWcIQzvUgHKIGI2VVOuv/pdGwK21hjr4H9VK+V0+kAkT1Fl?=
 =?us-ascii?Q?DLwBfOMA1GKG2a+IYRaxl1lhH4Sdurw8EvzRCkkPCdYTBN50X0hyZtkTPHpX?=
 =?us-ascii?Q?KUAOBYCMOcYiV0yCbGYbbS92EBTuU9woc83h9qwyXKRZVZ7FcIX348kOA76j?=
 =?us-ascii?Q?KWvkT1UjDb6BF14Wv/h1va5EDGw7EM9VXXbimQrkQYijNSgeUF18VxkdDuSa?=
 =?us-ascii?Q?bDCGfN3Fq4BFgWj3np+sH5XxSdCIDYDWp/6wEqpFzhCkXJnSytvXXRtM2xuB?=
 =?us-ascii?Q?m/+m5ZF+Ky4lGT2S9D3EEojPm0SM2MTV1ye3ffjmN54r/ys5fpsmmDY+UEw2?=
 =?us-ascii?Q?/zwdVzUUnzyr31bg9BPy0g6m48O22fSfkFIomcyBel12Ll1I8y4uDBrL9vl9?=
 =?us-ascii?Q?oONw/+dPuqKlg/e8RM/MvdfbpEDRy3vhAKjw/31jKuEvesgmxTJXre0PvgFH?=
 =?us-ascii?Q?T/P+RWTRuAQxnudpQIEUrd1m+6B3UbA/4mmJImvGyDJqAtyBHFbFT82wvnks?=
 =?us-ascii?Q?/E+o6OspvqPbdeH1a07cNI/cd1Hmjex0UuHSYQqOVO4sFjma9R7lTdXhgwoS?=
 =?us-ascii?Q?nG1u6bbeyZdW+9LXBMejstWoKz/mr9gpYb69P2e/bVUq6WEV9io0CARWGVNZ?=
 =?us-ascii?Q?sXVlxMV5ATV786bmqRZ6MiVH5ROihQWkCPFbFf+eed7fy/RmCHPyjmZLSLof?=
 =?us-ascii?Q?ZElutU5FPAc+Iz1E8APpaav4eNLePkPHUH2kaT+TDrEn3w5wR67JSt8obHNu?=
 =?us-ascii?Q?s2w9x+oX7ePe5tVUe6nckTU5cN+oNDIyctEPwGqiO28N9/P12ZXtkQSITIlw?=
 =?us-ascii?Q?nJzMZ7ETLlhrQPZP/u+472Ur7+ijbLDjPcAV+yqhsXiI/7+5k5cBXLofxzC3?=
 =?us-ascii?Q?+FpXD9mBTxJJK5rFBQ4V8A7wiGAlMLlaRrdDgh9HlljXrT9SHipDEYpO6AzN?=
 =?us-ascii?Q?/8Wu0eHxSmoNneeh380APLeKWHPTOMoyk+H8KaDzZ9N01HiLGa9iB2GMjQbr?=
 =?us-ascii?Q?5i00AhJN8iU3I/A2nI5n8EMX6XFGwz6W1Rw2Zu2e4Y+pghiUHjq9hm3TnobE?=
 =?us-ascii?Q?i2hitWZTPl2ysI9MRbhvxzwT67aueVcMHREV7CDpHr7v7opa7VYu5cLbSdMV?=
 =?us-ascii?Q?E/+TY2+4VQBiUiC3bSroVE9GojNBtY6xndYCsFh4MzEQ5VBQOvYUbiDP/bLK?=
 =?us-ascii?Q?ha25BPDkdvF1//PqR1CYXiDpqwvQ3y5lthHY/R41gUEv5aPYFziDQqjrAd1+?=
 =?us-ascii?Q?7BZf2mrSmZdyx7Eg3uyxcp2Md0f7Ljr8TNA9D6vocqGvf2r6F79yylWqhymS?=
 =?us-ascii?Q?pWohcrPwZXVmI6BVBls6JPqLAtH+3eXNHqylw6cptlu17wKiJGoRI7LCaBas?=
 =?us-ascii?Q?AwR4EOZ0cdW+p1oHRjTYn/mkmKfLCAjlWRh6TRH7h7JIkCneB5sM1QiV0PDy?=
 =?us-ascii?Q?vXImAca4KPPe70jJZkrFTuCoc/mNcz0b//GMNcu7?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd25baf-f937-49ad-9e90-08dc7b88b176
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2024 00:30:20.2556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BWORcorudxIWrQx7JYNn4GZcTlus6NaZHhs193SY9YJAEg+gKUtO8iv5HTkzLdT8gxeSKzLT9LjX09hfW1/dmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8229
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, May 24, 2024 6:48 AM
>=20
> On Thu, 23 May 2024 11:58:48 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Wed, May 22, 2024 at 11:40:58PM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Thursday, May 23, 2024 7:32 AM
> > > >
> > > > On Wed, May 22, 2024 at 11:26:21PM +0000, Tian, Kevin wrote:
> > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > Sent: Wednesday, May 22, 2024 8:30 PM
> > > > > >
> > > > > > On Wed, May 22, 2024 at 06:24:14AM +0000, Tian, Kevin wrote:
> > > > > > > I'm fine to do a special check in the attach path to enable t=
he flush
> > > > > > > only for Intel GPU.
> > > > > >
> > > > > > We already effectively do this already by checking the domain
> > > > > > capabilities. Only the Intel GPU will have a non-coherent domai=
n.
> > > > > >
> > > > >
> > > > > I'm confused. In earlier discussions you wanted to find a way to =
not
> > > > > publish others due to the check of non-coherent domain, e.g. some
> > > > > ARM SMMU cannot force snoop.
> > > > >
> > > > > Then you and Alex discussed the possibility of reducing pessimist=
ic
> > > > > flushes by virtualizing the PCI NOSNOOP bit.
> > > > >
> > > > > With that in mind I was thinking whether we explicitly enable thi=
s
> > > > > flush only for Intel GPU instead of checking non-coherent domain
> > > > > in the attach path, since it's the only device with such requirem=
ent.
> > > >
> > > > I am suggesting to do both checks:
> > > >  - If the iommu domain indicates it has force coherency then leave =
PCI
> > > >    no-snoop alone and no flush
> > > >  - If the PCI NOSNOOP bit is or can be 0 then no flush
> > > >  - Otherwise flush
> > >
> > > How to judge whether PCI NOSNOOP can be 0? If following PCI spec
> > > it can always be set to 0 but then we break the requirement for Intel
> > > GPU. If we explicitly exempt Intel GPU in 2nd check  then what'd be
> > > the value of doing that generic check?
> >
> > Non-PCI environments still have this problem, and the first check does
> > help them since we don't have PCI config space there.
> >
> > PCI can supply more information (no snoop impossible) and variant
> > drivers can add in too (want no snoop)
>=20
> I'm not sure I follow either.  Since i915 doesn't set or test no-snoop
> enable, I think we need to assume drivers expect the reset value, so a
> device that supports no-snoop expects to use it, ie. we can't trap on
> no-snoop enable being set, the device is more likely to just operate
> with reduced performance if we surreptitiously clear the bit.
>=20
> The current proposal is to enable flushing based only on the domain
> enforcement of coherency.  I think the augmentation is therefore that
> if the device is PCI and the no-snoop enable bit is zero after reset
> (indicating hardwired to zero), we also don't need to flush.
>=20
> I'm not sure the polarity of the variant drive statement above is
> correct.  If the no-snoop enable bit is set after reset, we'd assume
> no-snoop is possible, so the variant driver would only need a way to
> indicate the device doesn't actually use no-snoop.  For that it might
> just virtualize the no-snoop enable setting to vfio-pci-core.  Thanks,
>=20

Yeah. I re-checked the use of PCI_EXP_DEVCTL_NOSNOOP_EN and
actually all references are about clearing the bit, echo'ing the point
that if a driver wants to use nosnoop it expects the reset value w/o
doing an explicit set and the virtualization of the no-snoop enable
bit is more reasonable to catch the intention of 'clear'.

