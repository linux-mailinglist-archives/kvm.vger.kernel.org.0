Return-Path: <kvm+bounces-34505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D07769FFF81
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 20:43:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95C591606EB
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 19:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94CC1AE876;
	Thu,  2 Jan 2025 19:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gHTT0NqF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555D6156871;
	Thu,  2 Jan 2025 19:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735847024; cv=fail; b=TjHJ5rT/SZMmIYWc/sv9LUCfKmdpmezZd/+HbFBSbvEaWcuBn8lOS0lIjunybRIycGd8BsKXDAqHrAHYVTU239yOnUym2/dquyW92H7VS7WtNDGqf1unr8ZAa9SU7Uw1hmki1LH3zaD+MgLdt7Xs/rdA3p6F5YSS1IkAWW8nDWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735847024; c=relaxed/simple;
	bh=+kN2vFCpE7wpGddEbU6hAnk7lvEd8CFNvB53N1otIak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DGMYpnUZnFFaX3Z5SPYteJ/BNs0N03mNcYTdS/G9LVc56DlbUILAftlWSA891MJ/mhMhCz667T28e1bl8Rnyd2zBosB9IEEpkRTOYXukLggTRmWktOx/ml9pcUhdGB2+BaBat5GPqZK1nLGgsR0wCNvMj1Rw4f5wqLMPHS+ohZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gHTT0NqF; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735847023; x=1767383023;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+kN2vFCpE7wpGddEbU6hAnk7lvEd8CFNvB53N1otIak=;
  b=gHTT0NqFN0Qdv4XogjEhe7eRjE2SX71XE9CEREZYqZY9JnGN/MZPESkC
   aJtVksuiGiNQ7wWJByVVB1nBjFuta7b3ua8AaREVHDXusetVkNaqPsKo8
   GRstVSaJdVcwjbtFXpzPP8cr7PEIYR6T9jy6GRDV38ik8mIyqKL5VxNdW
   s16qOYnTHfYbHn0usZJ/D9FESDhT9msk0eepxWTFVA55wz8ouZdS2fq1Z
   XuGxrtyYpgQnDxNEz8QKdgTEKNo5gp84NkZaeWQL2VaJlsvnlNeh0hGdx
   QgIkkod0Yk2QkS2pAhzXhks8Ha9FNmxFgYTjcMd1nKD4l1ZsQSQhOJPSk
   Q==;
X-CSE-ConnectionGUID: phGUFpp9Tf27HL2AryFrhg==
X-CSE-MsgGUID: 31bQiGLJTua/qc01mANKwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11303"; a="58562936"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="58562936"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2025 11:43:43 -0800
X-CSE-ConnectionGUID: 89KB9p6+RdeNJf39bSohQg==
X-CSE-MsgGUID: jinJhOhnQoG6jt8Gh0jRtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="101445392"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Jan 2025 11:43:42 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 2 Jan 2025 11:43:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 2 Jan 2025 11:43:41 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 2 Jan 2025 11:43:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F04QzbCZXe1HteuSxKffENDaQCzMnHzFiODH2PVnaNf3qZX2viBWtBFK0xev833awpWyuuLr3lUTtaQWVFdLwzsDf9YdZyJope6uHVZdis6OkTIHrnznzfjuR3t2curkxi6ndc/rOO2s45mkqpA+eLs1E3Xkyxg+Mc9k3h1w/aM5UaOSrKvfKhoHEi+e2CsINfo0KH8uzNYzxJq5qoBt2clo0gxqZtuscKY5AW+ys5Vk7ydrgVVTbl+webmG2ZxP9hatn0oI+AoH1rMKc8KUIPe6wIYeBqp3Bt0I5pu86JjY+1mUd+ZzJmkAQUHOPTsmi+Lydct1qEG9lkO1Wd1mXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+kN2vFCpE7wpGddEbU6hAnk7lvEd8CFNvB53N1otIak=;
 b=vK0PrgvwyfAHUmBr5pmMnMdSSLO1v08u/ina+GG4ZstbWvLIMGjtQK7RBSAbiRW/5z8hA8oTleS6ATPphft78oBZIr638VEkFmgf9yO/wB/6OdETxP7Z0apIGWNqSaJF5sIPZ4uN0eueQa+uTdWRTjYiZLGjrfK+QthtiBkS68p5Mantah3zpuyYrHnq28CI8XcUCrK8wE38xGVay73YU3TbvgNz/DpumWIuKjmBa65NsIm1nz4arESPkJHkpbIhA/gnaNIAmM1lPLL60CGU6DBfTmAmjoklZIsabTKzJ30SeXUAmYPCLYsFSmj+5v4A3rhhoXAOJazsow8GY8CWmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6980.namprd11.prod.outlook.com (2603:10b6:510:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.11; Thu, 2 Jan
 2025 19:43:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 19:43:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2 00/13] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Thread-Topic: [PATCH v2 00/13] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Thread-Index: AQHbXCHRVOM1A94L7UuGvfkhe8OevLMD5PKA
Date: Thu, 2 Jan 2025 19:43:35 +0000
Message-ID: <5c8228769f27244f2f1435a74879a0ab64c3df97.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-1-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6980:EE_
x-ms-office365-filtering-correlation-id: ae85bf60-0099-4942-a040-08dd2b65bf06
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OG11UjN3SVVsd3VTb0o1c2xSODBTWWRjS3RJODFBYmNUbWdzeUZERHRCSmVC?=
 =?utf-8?B?UzYzcjNhTUN5N1kraW1hUWRWU0kyWFQ0TFJPY3ZrSk13YVJwVitwQi9GSTM5?=
 =?utf-8?B?WHBHRnlmckRETm81Rzl5YmxFcDhFS1ZvUlh0V3ViWng3K0YyeE9UMCtBRStC?=
 =?utf-8?B?TUpVMkZCdk9Gc28vYy82dTFSb01KRW52YmxOdzFZSFR2NDV4TmlxWmtxQXNJ?=
 =?utf-8?B?SkFPV1lWRWtkRkx3OHpIMmIzZHRlTUh4cmpvTFZYQlA5NmJDOE80UGVMQkdQ?=
 =?utf-8?B?alBsbXNveVNrdGdJYmVwTUJZWEFrR1NUb2ZtZWtzaHR1Q2wzeWprcjhYRllO?=
 =?utf-8?B?OTFvZmZab3EyUlI5R1lKMlA3ZGg3Vkx5RlVIWDJQYnNoRDl3enRzMlJkZFlz?=
 =?utf-8?B?QjNidzVrNURPSEpDM3dseUNGN2pBalRoUGx4OWJqOFVmci9mQWtEeUIySjIz?=
 =?utf-8?B?b1grOEtTYmQwdmZ6Tm55bkVDeWdKRDFHN1FrK0JzMHYrTFk2UWVod3k4NFZP?=
 =?utf-8?B?d24vamhOa2hENnBTd0FENzlxZGNicWRQZ0N2eWVJMjlNTE00T21DR1hMNkxm?=
 =?utf-8?B?NERwOEY0YmQxRmRENnhnOWJGcHYwWmZwV0QvUzNhVzBVekhrSkxLM3JJdUt2?=
 =?utf-8?B?eHZMcnZCdkF3WHFYZ0ZnU3gxQWZBcWw2M3FaTC9ST3U5MkM0UzB5TURsWi9T?=
 =?utf-8?B?dFFYVjdjSEkrSTRZVTRGbCtGcHdXODdLUVk3b01NNTZtQnVWMGo5OE5pcTRr?=
 =?utf-8?B?MEZ4ZEhtUE83dmRrMzlRZTZFNG9tY1VLVDFoQkJQa2VuNTFUbDdSMm9pQlVG?=
 =?utf-8?B?N2Z3R3E5ckdRVElBMDVvZTlJcEdPWVBIdEN6Nkx4Mk50NHdCNlIzOWh0UHZ3?=
 =?utf-8?B?OWgwOHRPbCtTZVl0TTNYbTUydmtMbzlEeDBXVG96WFhsaWwrU2g5UkJUbTlJ?=
 =?utf-8?B?bnVoOHhGUmcrZlpJLzhkbDZPc0RLWU5GSzFzSGEyb2NEZDB3ZEN4UDVqWSt1?=
 =?utf-8?B?YmN5K242anV0WkZFRlJwTTJ6OUhGb2t0cXc0NitkTmhTdHp2UEthOERlTjBV?=
 =?utf-8?B?eXNXay9xS0N6ZHBXeVdUc09rcCtlbTZUL2kvU0UrVUZFMThlV1J4OVV6NnB3?=
 =?utf-8?B?anVsMlQwOHpFS3Z0aEJQek5zRmZSTEI0Y3labFBQdlhZVXM0UEJGMXBvVUtt?=
 =?utf-8?B?UXJNN0Mrck91VE5ZTVJyOVY1MUVyWkJCQ2R6RE1aK2dkQkR4YmxkUWZMMWRD?=
 =?utf-8?B?OG9mMnV5ODQ3YmpVUDJ1aDhGaW9YTzdRN3dMRHlrL0RJcUZyQjhlWHhNT0V3?=
 =?utf-8?B?c2FIQy9XRm8zS29uclRVcHV0Y2duYlMxenEybE1ZdzRRcGE3ejR1bWxjQ09j?=
 =?utf-8?B?L1c2ZTdobDdkZ1FPbTZOcmhzZ3A2ZG9BU1lrdVdmMHhFaWV3dm9uNlF1eFht?=
 =?utf-8?B?Rkk3OHVkbjd4aFFNeGZxdDFzMS9IUU8wd09NOFgvT21makxVV1BKVUNDZm1P?=
 =?utf-8?B?RjdQeEw5VEJjRmt5dnVtV1R6c1FNSktsMnR2LzZ4QThDYnFsTFlMRWdOWUZa?=
 =?utf-8?B?Qkh2WnNzRE4rYmE4Vzg1QmtjK0pPUzRYUitMWWpPSGhtcnZwcmFZZ0dOMEd0?=
 =?utf-8?B?a255VlExaTlyWFQ4MXlZdXhLZ3VmWDVWNHNSN01ZcElCNkxsK3lNUyt1VG9x?=
 =?utf-8?B?UzZoMzhja21ibDlxUlpTUFhxMGlxODBWYUpyS1N6cXh3eVNrWFB3cHlteWJn?=
 =?utf-8?B?Q0JNcCtJZXZaYmR4RzFYZytCUkZKQllmS2FBcDJqZDZvL2FtY3IyVVc0REhH?=
 =?utf-8?B?dGdWL0tmSlF5ZjdjcVE4MTFyWjJOR3Q0cWxacUFYK1laSVlVSnRwSS9GTW5Z?=
 =?utf-8?B?QXkrY0Q3bzJsbjBQUVo1NHgzNnZwU2Y3TnhYKzc1b2NKZFUxdUFYMFVZaHg3?=
 =?utf-8?Q?pz1+J0eWUdFQGeSAl8GcnFywQK2MA2m9?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXBJenFOdGNZT1dtWXpoMVdNRXdLbkxyK3hDWStkeUZFS3VQT044RU51NWRt?=
 =?utf-8?B?RmROL1hHVUVDYWU1TlMxaENzaUhjcEdEVXBwNWY5NDlrTm5mUkxSS2ZPc3Rm?=
 =?utf-8?B?d3pGcEtGSzBJSVZWMmNWVjFyczBGK0wrVXNJb1NzM2JUR0c0bHc1SU45TXox?=
 =?utf-8?B?YXY1L2pVYjl0NVRmQ3N5Um80RXMyeXYyaGR3K0hDRXkveWtmWUhjb3VJWGpF?=
 =?utf-8?B?Z1VsZ0M4ZFBtb1B6SkN3UXJzRDNqdm0xVGJYWjBUdFNkbnQrd2dlcmFSbzgx?=
 =?utf-8?B?K1NoMGkybFZxUHRmNGZBK1MzV3pCbmNtWHQ5b1RCQ251aS9KZ2FmeFg3dDBV?=
 =?utf-8?B?dU0zWGVVSW9ONWxlRTJ6QkcrSkJyQW5VR3hHd3hkeVM2QkRiSjVRL1RqMjBX?=
 =?utf-8?B?U3c1RUJyN3NsRkg0OGRwaTdpc1Rkc1laRUNkYXcxanJRN0w1Wi9uVlFGMEtW?=
 =?utf-8?B?ZVRNTHFwRmlwNVlxOGJmNDE1cHNNcXd5cDJIdFdzNTJiSW84aHp6VTZaMEpR?=
 =?utf-8?B?cUhPMSt1SnRiVnh6NHJxTy9uQXN1YXp2b3JWY2c4cjdLai9CWHNIVEEva0x6?=
 =?utf-8?B?cWlUOVZ5TTdLN2p6UzYwTHB3R0crWHZiQVZQamt3MEUxVFVmanlKd1VhUm5Z?=
 =?utf-8?B?RXJMcG13ZUo3MGVGWFVPMjZuOXg4S0pkUWY0dW9WMFp2bHBnVG5POVVncm5Q?=
 =?utf-8?B?eFluOSt1V09WNGk3Z2cvbXN0Y1hkQ2RHV2d1QUthNHNqMGxhR1lvZlJ2NkVz?=
 =?utf-8?B?YWs3Y2lYUjNicUFPZEhMM3c5ZE1VL0ptdWI5LzBOK2g4SDVFNFdKbHNxOFYv?=
 =?utf-8?B?YzcycDdMK2wxNVY1bklDbWhyaUtibmxycWxkREJLZmJqRStlME94aTRGZERI?=
 =?utf-8?B?dlh0bDY5Vzd4ek1ZMXpKVkI3RkFydU9vK3lyOWpXWjAwb01RTXBDazBaakxl?=
 =?utf-8?B?aFkvelZiY2pWWGhSZk4reC9SQm1mbmxCYVN4VTRwTlRMWTZEWUNPbEVDUkNM?=
 =?utf-8?B?MWc1N0dVSGRERDRsQXJXOUIyYTBJUU8vTEQ4dmQrWUlSR2tza3ZicDhGWFlO?=
 =?utf-8?B?dW94b0kzbURwWEY4SURxVnBseStzUDRWTU9sVWJ2ZXdOMHZFWTAxdVJzMVVD?=
 =?utf-8?B?b25Jbng3RUFIZVpoczNtTldSWHVkNk82am95SWdwYW1RemFMeUdKdjNNR2lt?=
 =?utf-8?B?ODhPZFNNcjNTcFBET0JJcXhXNC9QOFdhZXdXWnhScXo0Q0JncXRyaU1zRmtD?=
 =?utf-8?B?TERxZDFWcTV2RXVwODBvc29RZjhaTjlXRWQyNEh3ZHpsYkhHcWo1clRvdnUy?=
 =?utf-8?B?Sy9ZbnltZzRsWW5rQ2ZQVE5NUkFYY243MG5wTFhYdCtoZDQyM1g3ZFg2K0lz?=
 =?utf-8?B?cmEvRHc1S0UvT3dPNHB6Y2Zwck1DSloxeGJ4MjBEQTRrMUhJYXVYVFY3Zlov?=
 =?utf-8?B?c0pkMEE5VFN0V21nSE1XNnJrTFNDSjdoQmdiU2N0NUp4dG9HSk1qZzJOMkdP?=
 =?utf-8?B?VTZBQnFvVHJldnFiS1lDdFVSRnV3bWFpOVhKRWc5VWp5NTUxNXozNWJWVkor?=
 =?utf-8?B?RVhUYUdMbGU0MWx5ZFhPTGFodml2T012cHg0dDF4dElyTXc0VGd5TjZyMXY2?=
 =?utf-8?B?YW1kaDVNMW9XRzhvUzVFSUdNSHE0WTBIeW0yN0JzaDF2NVlObGJrWWV3MXIx?=
 =?utf-8?B?V2RWeDAxbkhGclArK1Jta2twQmt5aVlpaVJsQzJTWGxQZ1ZvWWxleW85bFFW?=
 =?utf-8?B?SzNCN1dCMm1CYXA2dTlhN1dtR2dEcVg5b1I4eUpUTUNaaUZKTW1GdmN1RzR0?=
 =?utf-8?B?S1l2WTJwYlM2WDc3alZ3cy9VenUrRU1PNXgwa2h6WERNbDJyM1o4R3BkYjUv?=
 =?utf-8?B?UnBIaENtRnBtTnkveTQ1SVptcEluZy9uZVNsQU5sc3pVR2paQ2VlRDFBbHVu?=
 =?utf-8?B?OE5PeXY5NTlFN2syMEY5T1VvaVpFT3lrczVIV3QyQTVQcjJBcm5MYVRLMy9P?=
 =?utf-8?B?RHFnNXByRTA4QWd2dlk0aktSUTh1c3FMeWN1WUlYRkVPN3o1Z09oYXAzSHpD?=
 =?utf-8?B?bWNZcklYeHAwNVdwU3A1eEFDSnMwbGhsVGxuUnRYVjU0TjB2dFkzU0wzNEQv?=
 =?utf-8?B?S2hBZWR0UFNmejErMENQM2ViNkhPak1Kak04Q0ZVblBKZEJyUjdYMXRoTnNO?=
 =?utf-8?B?Q3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1047FAC73845AB48AF90AD30A5C3D244@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae85bf60-0099-4942-a040-08dd2b65bf06
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2025 19:43:35.2478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k/99a+6frJ9Ijvc01xmjMPjNiut8dckIEH+3/hFmCTrGfWaY/+g1bPdv9c6DleYAjvhFg/uI9O57IYuVu6HFUPzOWdvLJU7n8n4H4N+G+zQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6980
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTAxIGF0IDAyOjQ5IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBUaGlzIGlzIGEgY29tcGxldGVkIHZlcnNpb24gb2YgUmljaydzIFJGQyBzZXJpZXMgYXQNCj4g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDI0MTIwMzAxMDMxNy44Mjc4MDMtMS1yaWNrLnAu
ZWRnZWNvbWJlQGludGVsLmNvbS8uDQoNClRoYW5rcyENCg0KPiBEdWUgdG8gRVBBTkVUVE9ORSBJ
IGRpZG4ndCB1c2UgdGhlIGxhdGVzdCBSRkMsIHdoaWNoIGlzIGZpeGVkIGhlcmUuDQo+IA0KPiBB
cyBpbiB0aGUgcGF0Y2hlcyB0aGF0IEkgc2VudCB0ZW4gbWludXRlcyBhZ28sIEkgdG9vayBhbGwg
dGhlICJBZGQNCj4gU0VBTUNBTEwgd3JhcHBlcnMiIHBhdGNoZXMgZnJvbSB0aGUgdmFyaW91cyBU
RFggcGFydHMgYW5kIHBsYWNlZCB0aGVtDQo+IGluIGEgc2luZ2xlIHNlcmllcywgc28gdGhhdCB0
aGV5IGNhbiBiZSByZXZpZXdlZCBhbmQgcHJvdmlkZWQgaW4gYSB0b3BpYw0KPiBicmFuY2ggYnkg
RGF2ZS4NCg0KVGhlIGxhc3QgcGxhbiB3YXMgdG8gaGF2ZSBob3N0IG1ldGFkYXRhIGdvIHRocm91
Z2ggdGlwIChjdXJyZW50bHkgdjkgaXMgcXVldWVkDQppbiB0aXAgIng4Ni90ZHgiKSwgYW5kIGV2
ZXJ5dGhpbmcgZWxzZSBnbyB0aHJvdWdoIEtWTSB0cmVlIHdpdGggRGF2ZSBhY2tzLiBJDQpkb24n
dCBzZWUgYW55IGJpZyBwcm9ibGVtIGluIGNoYW5naW5nIHRoYXQsIGJ1dCB3ZSBoYWQgYmVlbiB0
ZWxsaW5nIGhpbSB0bw0KZXhwZWN0IHRvIGp1c3QgZ2l2ZSBhY2tzIG9uIHRoZSBvdGhlciBwYXRj
aGVzLiBUaGUgcmVhc29uIHRvIHNlcGFyYXRlIHRoZW0gdGhhdA0Kd2F5IHdhcyBiZWNhdXNlIHRo
ZSBvdGhlciBwYXRjaGVzIHdlcmUgdGlnaHRseSByZWxhdGVkIHRvIEtWTSdzIHVzYWdlLCB3aGVy
ZSBhcw0KaGFzIGhvc3QgbWV0YWRhdGEgaGFkIG90aGVyIHVzZXJzIGluIG1pbmQgdG9vLiBEbyB5
b3Ugd2FudCB0byBjaGFuZ2UgdGhhdCBwbGFuPw0KSSBtZW50aW9uIHRoaXMgYmVjYXVzZSBJJ20g
bm90IHN1cmUgaWYgeW91IHdlcmUgb2JqZWN0aW5nIHRvIHRoZSBjdXJyZW50IHN0YXRlDQpvciBq
dXN0IHNsaXBwZWQgdGhlIG1pbmQuDQoNCkFsc28sIGRpZCB5b3Ugc2VlIHRoYXQgRGF2ZSBoYWQg
YWNrZWQgcGF0Y2hlcyAxIHRocm91Z2ggNj8gU28gaWYgeW91IGFyZSBnb29kDQp3aXRoIHRoZW0g
dG9vLCB0aGVuIEkgdGhpbmsgd2Ugc2hvdWxkIGNhbGwgdGhvc2UgZG9uZS4gRm9yIHRoZSBNTVUg
b25lcywgWWFuIGhhcw0Kc29tZSB1cGRhdGVzIHRvIHRyeSB0byBhZGRyZXNzIERhdmUncyBnZW5l
cmFsIGZlZWRiYWNrIGZyb20gdGhlIGZpcnN0IGJhdGNoIG9mDQpTRUFNQ0FMTHMuIFdlIGNhbiBj
b21tZW50IHRoZSB1cGRhdGVzLg0KDQpGb3IgdGhlIG90aGVycywgSSBoYWQgcGluZ2VkIERhdmUg
b24gIng4Ni92aXJ0L3RkeDogUmVhZCBlc3NlbnRpYWwgZ2xvYmFsDQptZXRhZGF0YSBmb3IgS1ZN
IiBiZWZvcmUgdGhlIGJyZWFrLCBidXQgbWlzc2VkIHRoYXQgIng4Ni92aXJ0L3RkeDogQWRkIFNF
QU1DQUxMDQp3cmFwcGVycyBmb3IgVERYIEtleUlEIG1hbmFnZW1lbnQiIGhhZCBEYXZlJ3MgZ2Vu
ZXJhbCBhZ3JlZW1lbnQgYnV0IG5vdCBhbg0Kb2ZmaWNhbCBhY2suIElmIHdlIGNvbGxlY3QgYWNr
cyBvbiB0aG9zZSBsYXN0IHR3bywgd2Ugc2hvdWxkIGhhdmUgZXZlcnl0aGluZw0KbmVlZGVkIHRv
IHF1ZXVlICJWTS92Q1BVIGNyZWF0aW9uIi4NCg0KPiANCj4gSSB3aWxsIHJlYmFzZSBrdm0tY29j
by1xdWV1ZSBvbiB0b3Agb2YgdGhlc2UsIGJ1dCBJIGFsbW9zdCBkZWZpbml0ZWx5DQo+IHdpbGwg
bm90IG1hbmFnZSB0byBmaW5pc2ggYW5kIHB1c2ggdGhlIHJlc3VsdCBiZWZvcmUgZ2V0dGluZyB0
aGUgZmlyc3QNCj4gTk1JcyBmcm9tIHRoZSByZXN0IG9mIHRoZSBmYW1pbHkuwqAgSW4gdGhlIG1l
YW53aGlsZSwgdGhpcyBnaXZlcyBwZW9wbGUNCj4gdGltZSB0byByZXZpZXcgd2hpbGUgSSdtIG5v
dCBhdmFpbGFibGUuDQoNCllvdSBtZW50aW9uZWQgd2FudGluZyB0byB1c2UgaXQgYXMgYW4gZXhl
cmNpc2UgdG8gbGVhcm4gdGhlIGNvZGUsIHNvIEknbGwgbGVhdmUNCml0IHRvIHlvdS4NCg==

