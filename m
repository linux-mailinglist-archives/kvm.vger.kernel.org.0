Return-Path: <kvm+bounces-70092-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KGbeKfRpgmmvTwMAu9opvQ
	(envelope-from <kvm+bounces-70092-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 22:34:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 224CDDEE07
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 22:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C4FB4301D954
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 21:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39DD236A00E;
	Tue,  3 Feb 2026 21:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BCGKOJME"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF4E29617D;
	Tue,  3 Feb 2026 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770154472; cv=fail; b=bkj+gAaKwYWtlTohrLiFUQrGBeQjPh8hqCO0h2gyIezDrQ1YLw5CCOiNxU1owzbUTpZrmX2nLeRz7TAXu+NDMQEonOht+qX+lBKLl8B6RvSTNfbTfZcvQCimh0wJwMGdqC6ZLgTcFmq84/LKc1cWEkkwlKXRZQStXDkNeFaVk+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770154472; c=relaxed/simple;
	bh=6SbTZ+BJXxq9r7FM44MGON8UpKKMQ3PPqu7SHSb8yrQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l7YNUfIyB6Db5gTVs67hiumDiYZiPP60QqofWDIjkBD4QrJL9hwJ0di6JaGiPwQ912t7l4yfM22gz3o8vdXhBz7Rc51f/MGsMizN8GyBtm0BQrsq+w0quZgNokRMarf1SR/65ZX5sHqJ6JxvQq4aOxgbTiZVgff8kcQ1EuQ0MFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BCGKOJME; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770154470; x=1801690470;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6SbTZ+BJXxq9r7FM44MGON8UpKKMQ3PPqu7SHSb8yrQ=;
  b=BCGKOJMEOXGqOKVCNDHgOQx8b3ZRE38Pe6n2mAEh4HNaZmviH2BvzuXl
   vd1bCQVqQJNJPrTx+T/nCJtyk/LwVzWyBAo1ajAWe5Oh3dJhzxTSYGZdO
   ojdeNx5CXcJMJedX21ryUigihstw7gp3F6Vj4Kj0vLWljowRUG9pyJNxA
   PL3hImV5Y9o4Zs429lhrgYqMYwgVsN6IRxHs2mZ/fYF2SOIdAQ+W55JCY
   ErCURH2KbYPA3mw7OGMoCcT2nHVOqF5w/t2kSCl0gmDIC7SMB7PMv2EZ6
   qYgxcRBCwWYtfv+JHpZ663WHrJHuR85m6nEFhojxxL6IWpw4QWvYpaSvb
   w==;
X-CSE-ConnectionGUID: snltqniZQ06359//8GorRQ==
X-CSE-MsgGUID: YG3sJQhBQMusI5n5Zb2RAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88910784"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88910784"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 13:34:29 -0800
X-CSE-ConnectionGUID: o2pYgM48QBC0BYyR5DKWjg==
X-CSE-MsgGUID: bGmzyAWbQryoN4kjvWy2qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="210008165"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 13:34:29 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 13:34:28 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 13:34:28 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.15) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 13:34:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WSeiAQF4uiowfObNsI/rkZ1Ia7o3MUUGmitT2BfG6R5K+BRdROtb0MJprZw1WkaHwQSfbfCy57VR4YEzQOgpdgGOq++LVyUlB01hwZb6DJWbcVltTnD6WcmaSL9BE2Et0rfHcvhZbWrU0V5nzQ+qt0CbLXO1Si5CmklquB8g+mzB3eDbuLzJDCJ9mIfsduODGdlown4rAIPCZhWIIOjaOJTw19pWmmJ7v4hx0s8qm2j9JlsLvHtS4hRHH1JqWy7aL5kbOFHV3PsvVGIucp7WRUfkTEUYccjtxJVdDIVChe+GJh87yariN9LVgyNcJR+BYQj1PzG9arO9VWRhZ0i13Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6SbTZ+BJXxq9r7FM44MGON8UpKKMQ3PPqu7SHSb8yrQ=;
 b=WwZDF2SZQY1q1Kg7822xPTbLjq9l6i8Ph4agMtifCTd5m+SbzZq/bfPygMbb0H+j8cN98T1JwveuqilFFC2lxIyd5yV4qoCxuNOhaTptQLrM5f4EzP42wkY/T7FV8WGn429kcvwt3RxLeQy2Jb7d7UIIOFo5alqEU+nWQMryKoqg1IGNY+9tA9p6CUY1uykuJrgTrQ4aVzVEe6l99xS12y/s8bsHsRkXrSxqI3A7euauPRLDrmRH0jd2JQNJIbVlSdHKVNZGyNqAwVjG/cXOvqoAteYdYL20NCzGdtengaBV/xjokeJe4yUi/XktU9ZWf2r9nXcK8aN+Pw49HAF3HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by DM3PPFF28037229.namprd11.prod.outlook.com (2603:10b6:f:fc00::f5f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Tue, 3 Feb
 2026 21:34:25 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 21:34:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Annapurve,
 Vishal" <vannapurve@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
Thread-Topic: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
Thread-Index: AQHckLzLjnMvtKJ+j0SX9/QNnZOZkbVwztQAgACg3YCAABiOAA==
Date: Tue, 3 Feb 2026 21:34:25 +0000
Message-ID: <e2a0b7ed0b856e3895b3f9b58c847ea272275176.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-3-seanjc@google.com>
	 <1c4bdb3613ebaf65b5dcf9a2268b06fa0c5a6ef3.camel@intel.com>
	 <aYJVRQMW8yeTkRxR@google.com>
In-Reply-To: <aYJVRQMW8yeTkRxR@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|DM3PPFF28037229:EE_
x-ms-office365-filtering-correlation-id: 32e37a62-b8ea-4cda-b913-08de636c00c3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Ylp1ZmZ4YUVudFBxdlEzc0hxbXB4U0pCT0R0QVVQUzVHbmIwUnFsVHlvaDZr?=
 =?utf-8?B?Y3l0bFpxNmJJVXBicmhlR3lRZHY4OGNpbHpON0N0YXRZbUhOcC9GRWpyR1E3?=
 =?utf-8?B?RmlHSTdKM3B3OGY2V09rdW5MSnd3WWtOMStpMXQrSUZJcFFjN2xTWTlHZGRl?=
 =?utf-8?B?VDdDV05YU1hhU2V2cWI1d2ZmQ1Q0dHkrZ0paTjdiTWpxL1I2enh1OWJoOFRM?=
 =?utf-8?B?eU9wZnk5Z09BZDVLL1YzemE4Z1QwUVJTOWdFL3M3RjhaRkcrRDJUeUZaNG85?=
 =?utf-8?B?QVFmV0FwL3lnMG5Bb0g3ZExBaW8xNWtnczByWk5pU0hjTTkwcXdWMjlXN1NO?=
 =?utf-8?B?d2wwcVZaOFVLLzB6UXhPeE5hN0RUdGN6WXc4bklkbnd6eUhzbU51dlVrdEJu?=
 =?utf-8?B?VEoyMmVmeWVPSE9CRDI2NkdRRFFWK2tkRFljREQwcUx0azNENlVzWllzV3dy?=
 =?utf-8?B?Z3JDZi8zT1ZJUGRLa1Z2VmpBNmV3aUI0SGlZN3o2K2pjL05rZ29pMW9pc2Zu?=
 =?utf-8?B?Z1dvZXhUVnBTeitaMmFqaDdUNU84UzQ1LzdkUkxLdXFDL3dPYnFBdEd4R0xO?=
 =?utf-8?B?eEVYb2JGZFowRWtzaEVlRUEvejhzblFyZXFMOGlHREFsRXgrV0JydTRJMmZl?=
 =?utf-8?B?bTlmbnFBZVFMbmxXZDFnRFpIMlU2SDk0WXIxc1JtNlJmWGxoMnYreS9KNHZD?=
 =?utf-8?B?ODBDdFFHNlZjdjVDOWRtTHpvODBtRnJnS2docWVqY3JLNStzQ3dLQzh6cGZi?=
 =?utf-8?B?QVI1bGs4QUI4VmROUGluMUtVTlhyamRCSExGMy82b1B4RTJ6dGtad0c1eFlS?=
 =?utf-8?B?UDMxMTllYTgwWUozWE00cHQxR3BnQkZXYnd0S1FOYXkrYndDTXB5RjlTTC9Z?=
 =?utf-8?B?cGx1dFFIbHhKYjRFcVJBYVljWHVSZGZBNXZPalFyVjg1NjU2UnhLd1IrMUxM?=
 =?utf-8?B?TTA3aTdxNWpzTlhHVGxLd1NZUTB5OFlBaTBzcnE0QXNIblJ5NmIvbWtXLzFa?=
 =?utf-8?B?Tmh3OEpXM01IVFJQakFrbG9vTTFjcHMzRFlZZTlGSmkvczJzU0dabTJzb08y?=
 =?utf-8?B?a0E1T1dGN3MySElqZmRpbk1GUzlOd0N5QVM1M2NrQUNJUGltQjBTdUNweHhF?=
 =?utf-8?B?bDYzR1k2UlYweWw3OGdrZ0J6a25ydmJMWnZTS1FiMzY3R2VHRmEvSUk1cXlt?=
 =?utf-8?B?clhQOUFISmRNdWhXSzlibFk0WEJTL0FEZWlLb2ZtOHlhb3UrYmJWY2FYZ3Zr?=
 =?utf-8?B?S2NMT2tONHRUbjJ0am5TYU1aS3RCNEVQVXBMaHRLaDJQMFhCOEp0c044d21z?=
 =?utf-8?B?SG9tMWtaRHVNY2UvLy9sS1BKOVJnU1dVUm1wU2tnMEVYM0xtRWRqcXJLTjIr?=
 =?utf-8?B?aytIWFBoYTRjVHZWcUNvbGpjbUErNnlOckJDK2NKZkozYkkzODRDSWZoMnVx?=
 =?utf-8?B?eTNhQ3pETS82YkpkbXFsdDU1SWFnN0Z2U2FxazBBYjY5M0xqOGRrcmlSNm54?=
 =?utf-8?B?cnUxOCtxM00wZGV5bGMvcHEyRGErNXZVYWdvZUp1YWhHSXJuSTRzT3U2NzNP?=
 =?utf-8?B?MmMyUGxYVlA0TXBxTWRPMklucXZDNlBwZVhmNnIra2g1Z1ZscEJGbUFZUUVO?=
 =?utf-8?B?WnJBTSticGVFTU5FOXNiMVBFV1l4NDZvVzlsaXBVZlF5eld0T2gxbmNSbzlY?=
 =?utf-8?B?czJQVnRodXBJSmk0bnlTSFhOa0JEZWxidXM2N2xUeTNRSFg2VVBXS2c0dDlz?=
 =?utf-8?B?UEJNTWkwb1Q4Z1lSRTY1UEdPYkk0cmdpcmIvZUxqczh1T09YV0hxVENsKzJR?=
 =?utf-8?B?aTM2TnlOcVc1SEhab0lLaXpCN1pja0VDSjdLTnZWdlFONmZTOWlhVm5Nb0Mr?=
 =?utf-8?B?ZkpUNGluRHp4cWg4V05YZ25rY0NsMjNwbUwwZFM0eFBESlZtZTZ6QmVvZklQ?=
 =?utf-8?B?dm9HRlhDcS9QSG9aUEpKSDc2Rmx2eWFENDZIdml4REFYcHdjMGRjQW4yMm1D?=
 =?utf-8?B?MVh3SW9pMU5ta3RHOUhGdnU0d3RNZ0hMRGF1ZER6RmNXWURWWjdRUWRpd1JV?=
 =?utf-8?B?eTBKek84ek91cDdxSi9kc3FHaGNsRHlXMlZmU1VpcHFwNEMxYmJzRWh2QzNG?=
 =?utf-8?B?SCt0WWxsTHk1VzB0NFRjV1NsZ0hLUDNNemVQY2xHY2dreXl5N0FUbnNPcWRJ?=
 =?utf-8?Q?7gRjOVFbcyWzTojxmj+pHYo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlNHOFh4TnY1c1dQRG1QTEx3K1hBZ2Jvc00za1pCblFUenR6bEluSEt6U3dP?=
 =?utf-8?B?b2RlQlAxeXA3M21xWXM2MnZQcEE5TmVzL0hzVmRHRk1FNC9rM1p5MTFvWjNQ?=
 =?utf-8?B?N1BvdHo2b2NxcGNpaVBEZElYN28xcTFkWWlKcld5UjMxLzc1YzN5aUF1aHdS?=
 =?utf-8?B?YnZEUHh5VHZzNi9wRms1c0dRZzB6cTF3L0FCZlh0Vzl4ZXQzbVA0MSsrN0ly?=
 =?utf-8?B?SWJwdVRXYWpGdlY4aEIraTNsYXE5cVNCVzBtZTExZmdsNVhFODkyVENXTEFw?=
 =?utf-8?B?QmZ1QlBwaStiVFI3R29iRFNjSmF5UmNzUHJwbVdvVXRQSFJLcllUUmdZeXZL?=
 =?utf-8?B?Y0tpS2ZwaHFxUGllZVAvdHYxdXErc0t6anFMNlVZaXZaZTVaN0VnR2s1akEy?=
 =?utf-8?B?emtGaFNYRzdJYTNzei9JWGNPeTBJRSs5OEtlMzJUbStlWGRJWjMrUkthelBv?=
 =?utf-8?B?S2VVekJiQjUvSFN1RkxLYzlXS21ERGFBcDFWOEZJWE16MXF5dTdUajFYZjUx?=
 =?utf-8?B?RTN0d01FdGxyY1V4eXFoeldUZTE0QXdmQ2MwR3ZFNFluclk0MHBER3JRS2dt?=
 =?utf-8?B?LzRCWVc3Nm9nZTFIZkxFSTFxRElQclFOOVA1RHgrMWlaV0FWLzZpQVBxb3dF?=
 =?utf-8?B?WkpsNjRrK25TY1k4Y21wL2JYSnJrU00vemY4eG5DVG5jVFlVRmFlVnRvVXFG?=
 =?utf-8?B?YlE0ekVhelBra0lacGVRL2YyZFVDVFdwUGhTUm1kYWFNMUNsWitkdjZVNGVZ?=
 =?utf-8?B?TlUzTGZYZ2ZGVEIxampGN2RVSU9nUXc0V1k0SHBsTmVudGZhRytnb3Znd1RW?=
 =?utf-8?B?cGIzR2hUM0FmclBMVEw3eEgzbzJEcWFzNVl6YmxYbEFQZFJ1WFBiclNtUklk?=
 =?utf-8?B?WVNUWG1PSFNMVG5Edm5vejFaOG5ERlM0Ly81WkZSa2ZodGJZeVV4bUtGWEtH?=
 =?utf-8?B?eXhnNStnbHovVkZOQ0E4a3Q3UjdWYTVJSFREY2tuekwzWDI5cDBZa21CTTlI?=
 =?utf-8?B?VFoxODN0NEdoUG03R0FldVlMelZUU29aWFRia3ptVURmRTkxODk0NUlDaEdI?=
 =?utf-8?B?M3hNMXdOSUJkYlVobGJGOVhDa0VhVXhxeFQzWUhLK1FuQmhueTB6cjdCckRi?=
 =?utf-8?B?VmI1bGp0Y1pteXRoY3ZWcmxraDVKczNyQUtKNGpDWTdDZU9iUTRHMTdDNGNY?=
 =?utf-8?B?ZzVXc3VYOVZXeW43UU5hcWRTTWlnaWtyZWtoS0FqZUpWamN5d1UzQ2lKQitY?=
 =?utf-8?B?c3hZcElBaDQyQUZHdjBYZFp5dG81aWJLYkFzQjhraHljUVNNcXYrOVhWMzJi?=
 =?utf-8?B?cVQrMTZZY0hFMllHYzZaQW53eCt4SnlTT3IyMXZhZ3hqaGRLYy85ZGsvN0FN?=
 =?utf-8?B?ek53dnRrb3Jua0N2MkhDVm5sQ1lEWjhWV0RPZEZVcDZGUFM3MFkwZU5Cc0Fn?=
 =?utf-8?B?MldqcWFoMjBySS9pNVpSVmphMVo1dWlVajZjYUQrRHV5ZlkwajVHY25IVDRj?=
 =?utf-8?B?WFl2L24wWXRCbGZmWmlrc3haN2FvM1E5SnhxOXQwbUdzOWd6LzlidUJtbk1k?=
 =?utf-8?B?Z3FCOVdUdW4vK2RLTmZFdXIrTHBaWUtxOWg3UG02RnZGZk1xbW51T3BoWmdq?=
 =?utf-8?B?ZURRSG9nR3BnZFFHcWJ5VXVKVEIrU2VYUDRvcml1VHNRZ2p3MHExejZsWEwz?=
 =?utf-8?B?Nk95d2tpcERwVlp4NWdQL1dxcXF5cVU3S2w4UW9rWkpzL3Nsc3JqVVRoYVRa?=
 =?utf-8?B?NjZuaTJqTDZKSmVwclJETWVJMDh3VERQd2JIWEU5OUV6bWgzT010V0RrTjA5?=
 =?utf-8?B?S0VCVjd5ZWRuZ2d5R0tsUnloaU53NjBZL2lsT1ZqSEZGOU9ramRRdGRXSVAz?=
 =?utf-8?B?TURtYlVKdzhJYldCV20vY2c1cENSMTFiaXQ5YWtZOGhVTDhCTE5oMUNQczIz?=
 =?utf-8?B?THM4UVArUzNvYWR2cm5EQkJkOU5USXBSSTdVNm15Wmpmbkk3dlpZenRQbzBZ?=
 =?utf-8?B?cGVCajQ1d2dGZTI5N284aUsvWUE5ckFadGdDV0gvdnVpdlRvcEJRSEVXMkZY?=
 =?utf-8?B?SU1SODA5YzIwRjVvdnVmOWw0YklGL0NRemRTaHk4RklkMUZvQ2t5UXpkQi9h?=
 =?utf-8?B?cjY3QXRnNnFoNmZLZWxlZVRXajIwQ3FFZ3BsT1B2QkZkZGtQU0tIYzYyRGhw?=
 =?utf-8?B?K0hjOHVjeFhJcXpnK1lvd0QvUXZkRktLTGcvUldwRW9ML08xQVFhL1dTeGlL?=
 =?utf-8?B?V0hiMEdHSmRoRnVabEthUmgvM3o3VnB5OGYvNG5QMnBLMXRjNUdIT213TTdo?=
 =?utf-8?B?VmtKcTM2alJ1Z1o5aVhrU2hRRzZWc01XVDVWbmxnUHlYSXh3Uzl2dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6A85ABAD7CB5E4399DD52018C159F05@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32e37a62-b8ea-4cda-b913-08de636c00c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 21:34:25.3425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e6k6eVm89jIAm+THNjXsrZ8pWhvf0ULBJka0aVCiq8AoFsWz0M8pSdeGX6PI9r7oBGbOgmabn+Xs5XQvpAUPYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFF28037229
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70092-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 224CDDEE07
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTAzIGF0IDEyOjA2IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEZlYiAwMywgMjAyNiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNi0wMS0yOCBhdCAxNzoxNCAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IFBhc3MgYSBwb2ludGVyIHRvIGl0ZXItPm9sZF9zcHRlLCBub3Qgc2ltcGx5IGl0cyB2
YWx1ZSwgd2hlbiBzZXR0aW5nIGFuDQo+ID4gPiBleHRlcm5hbCBTUFRFIGluIF9fdGRwX21tdV9z
ZXRfc3B0ZV9hdG9taWMoKSwgc28gdGhhdCB0aGUgaXRlcmF0b3IncyB2YWx1ZQ0KPiA+ID4gd2ls
bCBiZSB1cGRhdGVkIGlmIHRoZSBjbXB4Y2hnNjQgdG8gZnJlZXplIHRoZSBtaXJyb3IgU1BURSBm
YWlscy4gIFRoZSBidWcNCj4gPiA+IGlzIGN1cnJlbnRseSBiZW5pZ24gYXMgVERYIGlzIG11dHVh
bHkgZXhjbHVzaXZlIHdpdGggYWxsIHBhdGhzIHRoYXQgZG8NCj4gPiA+ICJsb2NhbCIgcmV0cnki
LCBlLmcuIGNsZWFyX2RpcnR5X2dmbl9yYW5nZSgpIGFuZCB3cnByb3RfZ2ZuX3JhbmdlKCkuDQo+
ID4gPiANCj4gPiA+IEZpeGVzOiA3N2FjNzA3OWU2NmQgKCJLVk06IHg4Ni90ZHBfbW11OiBQcm9w
YWdhdGUgYnVpbGRpbmcgbWlycm9yIHBhZ2UgdGFibGVzIikNCj4gPiA+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+IA0KPiA+IFJldmll
d2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+ID4gDQo+ID4gQnR3LCBk
byB3ZSBuZWVkIHRvIGNjIHN0YWJsZT8NCj4gDQo+IFByb2JhYmx5IG5vdD8gIFRoZSBidWcgaXMg
YmVuaWduIHVudGlsIGRpcnR5IGxvZ2dpbmcgY29tZXMgYWxvbmcsIGFuZCBpZiBzb21lb25lDQo+
IGJhY2twb3J0cyB0aGF0IHN1cHBvcnQgKGlmIGl0IGV2ZXIgbWFuaWZlc3RzKSB0byBhbiBvbGRl
ciBrZXJuZWwsIGl0J3MgZmlybWx5DQo+IHRoYXQgcGVyc29uJ3MgcmVzcG9uc2liaWxpdHkgdG8g
cGljayB1cCBkZXBlbmRlbmNpZXMgbGlrZSB0aGlzLg0KDQpNYWtlcyBzZW5zZS4gOi0pDQo=

