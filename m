Return-Path: <kvm+bounces-72766-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDyfAQDFqGk2xAAAu9opvQ
	(envelope-from <kvm+bounces-72766-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:49:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 90FC9209218
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 02E8B30576B3
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8943D38642F;
	Wed,  4 Mar 2026 23:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IKIrBByT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AD635CB6D;
	Wed,  4 Mar 2026 23:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772668150; cv=fail; b=U6Va7pd5+dGBcEqa2PNUuwpnQFJvnwUMkp42MYY9386nYjdEWr2sRgsTZXIdOebmE+52wZ7007pQNvQ252d7MEgtrjsv7z3oOd9XBuLc5wR2bPGMSUuiSX+UWOr/fUOIn6unOKwKVG6HkIif2SvH0p5h1gxu2GeIzLqSTUp0zHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772668150; c=relaxed/simple;
	bh=1FOL9ddyHe0rCCD0lStt1yaBESWgF8LzhvdHJe/xfyI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XzwGI7juovSZ24scgGsvR6yugSYeqg/aDBux6FKY8qSdZrZThr4azqEzx+XrmCbAg3iUnmP+3h5PvnKpWFfcBCnBZ6lAUNTbv5WsmylCWa+brDgsIKrIM/7ABdcJy644mWqlz7BmKHYf+td09MOn31h62MatciZXJKsFGkx9oi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IKIrBByT; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772668149; x=1804204149;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1FOL9ddyHe0rCCD0lStt1yaBESWgF8LzhvdHJe/xfyI=;
  b=IKIrBByTk3tkH6UeCwu6Ykv2IqyDSs0qxJgtqZwHdiihxIqRuIaP4+Qp
   cxotccLIqR4qvjM8CXpu/nhe1FqM/F4eFVQJyTksrCULphKgvgmrByDeM
   JXgwEJA9IXqKmGGlJ+NEm2w1QrnZqzkxo33f6Q4LAjOp41G1JE3+TVPFn
   NzxERBvQBQlbsrQSXoz7PN2oyQSJ6451FjSosyLhpSGXoqjqpoKAKpVKK
   BKUq1XYVtxj3oAlbXX83m4idcji74rgruSsnm0IqEghtYSgusYDbeJ4kx
   Fk1VGpvKbunX+vwQgGgg/EftGOCAh8tVhMBE9J/uksDBhbnWqfIDet3t1
   w==;
X-CSE-ConnectionGUID: C3kKPdtyRQSBOs61cizCzw==
X-CSE-MsgGUID: 9KxqWA4xS2erMAmwFgaRGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="61316608"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="61316608"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:49:05 -0800
X-CSE-ConnectionGUID: 81C/osU6T3+YgGY4mkB+pw==
X-CSE-MsgGUID: /OVyl2xdRve2U/uRkwzIgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="218486038"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:49:05 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:49:04 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 15:49:04 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.16) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:49:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NQgFqyDJ3NDyRwitjEd6RsUEXeoBxpwECipLgDnaGFCNSQI3lskgi1mWacmq0cb0i7siMTaYS1krAcuNXkpsIUC/MI5T7ItdT15YbJDcxJMll0YorN66M22HTvpxfnI7m4oOKlM9Yi7go6pnFcpc4uVzcmLcf5Xa+gipV97ZGPlvdoK56BGLQWDSbE2LbG394z2xi37dcK6IjQGgogK+dnPq4CFPiX0pV2S9hipHKU0Ns+ACLd2WgYR8kHkl3tk9Y4yuI8IwikpFQ6ZXQsl69C4wHqLCY0bW2EJAJ95ByQsHGG0bTwW+tW64AC57xWdpt/1PJN+MYlHhKiT6noXitg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1FOL9ddyHe0rCCD0lStt1yaBESWgF8LzhvdHJe/xfyI=;
 b=il4OKu/pv+nanNLZ5q/kvEervGSf4fHfUmV/13MizAVAEIlzxnVRhLpPiWyIAal9ZT441CXvlaum+jrIvBPILWOzlXd6xAMV8fu8tiXgsLljlqTr82xrOFsFXKDuABhb5+mjtZBOhzLRwMvrmH/1QjOoGh0F46BzbKX7nt2cJrTB2MplOOi/LxghDWnu1NzuXkufVEKsCOry6O9dKWaJpQwASW7C/M2sB7vbedVmw3CZC8a0BZwXe4c50IL8YDGzCZBaNzXil1n2fXRZ86odjPgq0SjIgY9DLqUHIIkq0qNQbbhY5mf7MzjjtyjTQCE6sHA7b9WHbwktqjPGx76r9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 DS0PR11MB8739.namprd11.prod.outlook.com (2603:10b6:8:1bb::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.17; Wed, 4 Mar 2026 23:49:00 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 23:49:00 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 23/24] x86/virt/tdx: Document TDX Module updates
Thread-Topic: [PATCH v4 23/24] x86/virt/tdx: Document TDX Module updates
Thread-Index: AQHcnC0Erk4r+FZ5/UKa1KWo9BLcULWfKocA
Date: Wed, 4 Mar 2026 23:49:00 +0000
Message-ID: <f563073be315f421d10d1d56e5525aad34596c4b.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-24-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-24-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|DS0PR11MB8739:EE_
x-ms-office365-filtering-correlation-id: 8d19c2ad-d713-42df-d1fa-08de7a489bc5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: M2PvSzlKhZqT1JI8cQ7YiqHw9ZWn9Ut03QPAkAOAocHKQHR8kY1CDTKRvt0aMPpDC1pagK6kduCqONzqVoQhLaJuxGIL3d+7Tx5ld1ygEsqrj7cIGnFd7qaOyJgqSuVmLcxuJ2a0y6x1Swt0yKkLIfweJUTlshT/ZFdq85xuzXBH8tckzZ/L1FAcPpKY2x5W2h2aLr5oe55sud3mofjJoFeRUaW6phDd6L41m8zVtQu890t9X399Fk/yCwO1XmiD/+xyPgXrR5bC1C1/6R4h38ZoT9obSZNNldHDwYBIY7fhJ+G1DPyFeJIc+CUOsKRxp3DlLF8bpcdLA0WWatLC9XA2iFxxA6Gae6TdYQQieTWGJJ3soIq4ZPhNTz5g3G9VWM+AjI/E2fnp2kcizIBdBFy65DQPKobpkL0+oymMfyUuv9CHWzNg1LoCHgYNC7tc++E5u+1tdvsWbQf9cOAD76O9S4+5Aga10VOrY9ThnjWXDaDaOLu6Bgcqkom7D6Tum6XoEA43obj7bU0f7U6Gaj9jPby8sm1Ue0HrthoYd6nLJC8X2CCO+hJrWWO3JmconE75zEgU7VQJy+x2icQ1rv6JXf2lvTT2tfhhVsrp2Nni/JHrffJ/JJ6cw4/0ozQZkN82hn0N4lNBBfZb7UZ9XVOB1bqeOQ4c9LVz19gC4JhVeuf3sddz9brgAW18iLdPpOeMyhgeoPeAAmlPMaEoSrYmtCcoI/TsT3W9B9Y+UMnTx1P0fkFfNJ1v/E+qE/L+Ypm/QAAp+akyavlXnkEW6CXN02n05/C5/uk7ObThhvg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTRZZ1NHOEV1eUttK2phVGFNNm9uOTNDRXZENFdTazE3K2FqRHpoblhmekg0?=
 =?utf-8?B?Y1FldFU1UExjdmZnK2RGZFNqT3V0Yys4SERCYTlxY00raEZSbHIvbkxaV1F0?=
 =?utf-8?B?SzZPQ21TUGh0T1NqNlFxeW8rem1lbWR4YURnemZxNGx5SHNOMm1aMFI0RkJU?=
 =?utf-8?B?b0dNY3d6WVR4ZGI2ZTI5Q05JMVY0KzA0SHk3Q2ZzMG0zRTc2Q24wOTZDVkF4?=
 =?utf-8?B?N0lCcGVSa3ZFL2M0Z1gydTdsUlowQkJhZDJzYlRqL2ZlV0ZZRUhoVzFvUmpk?=
 =?utf-8?B?V0NFem41OU5yalNaeC9tT1IrVjJ3bExWTHN6T2xyenVJbURFdy9GZEVQZTND?=
 =?utf-8?B?U3lONmRrbWhjWDNKMU56ZVRQQ1JkZjdhMU90NDJCK3czT2ZqOHJGQmRMTjd5?=
 =?utf-8?B?Sldud2JNVllpRVFSQ1llN1d0bkE4SG4rdkk3a0MvdWt3akdTN05IbzNKa3NW?=
 =?utf-8?B?OFBJNlJtWHFJdUZndDE5L2JtYWNhR0hNV0FseklmR3pWK3BhaUE0OHZZZjlO?=
 =?utf-8?B?WGtiNzY5OVFjcm1uSWg4MjlmMlRZdnRLWkZMZFg4SUpRUTRMQ08rRStSNHNT?=
 =?utf-8?B?bXFxUzUrU2pzUjlBc3BDcDVTM2p6WmJDTk5jLzlEYytXR1dqT1Zyd2V6WGxJ?=
 =?utf-8?B?Z2FPV2hTbDU2S2hlMFJEdHdDYnNJUUxMcUh4MEdCbml4a3lZUXBiM0RSRUlT?=
 =?utf-8?B?VHdDR3A0MXNhdWd4TEM4blFqUCtycDhYUXh6UmVRUzFLcjJtbkpJay9HT0FU?=
 =?utf-8?B?am5XQndscFgvUlRKMENUeGVTZS9LNVpFanJCZzcrL0dMdkdJU0ZBemwwVmsy?=
 =?utf-8?B?dVBNckJJam5CU21ncDdaeEVIb1VOdGNaRzJrbWU1THVSQUJReHl3Q0xUYmF5?=
 =?utf-8?B?S1Z5NkFRMVZRMGxGZ1ZUYmlPSUdGbU41SDl6MUs0b3ozVytxcG9VbHpqOU5z?=
 =?utf-8?B?Y3EyRE91bFpLRU1IL1BLNzZrR2ZPOExtQ2ZGWjE3eGNJZTh3RGh5R0M1dmIx?=
 =?utf-8?B?WTZ1UzQvaGo1MC94RnBNVzJXYmd4NzlUamlIT2JKeFRIREpRUG5NNkJTZkMr?=
 =?utf-8?B?bEdkUkZHemNJZHNFSnpFTDh6M3FDbDZ5VUxpY3FwdUE2SWFNd3pNVG5LUzlF?=
 =?utf-8?B?T0RWK0VxME9NQVJXaUR6akpheU80VjlIQlVDUVN0RkdpeklISytkbksyeTVw?=
 =?utf-8?B?VnZ6ZEtuTWw0TnNoaXlobkxPcUUyY2JraUR6TnpuYVY1QWV3cU9BTDBZLzBx?=
 =?utf-8?B?VXNKMDJ3NGhDa3kwdThXTGg5akFSUlZqNzhVelp4Q2E3aTJpT0xCUVIwSjgv?=
 =?utf-8?B?OVM2QnNPemNlQkFhRHRNOE1OMHhNREtLV1hRbTJPekUzWktzbWZhU2h0SElx?=
 =?utf-8?B?N3B0N3VhSVF2MURHY1VzT09sbnFBcGlUSU8zSmdIY0JuV0lHNTF4K05wOXpM?=
 =?utf-8?B?OUtkaUZpeFJHMlRjUHdhTnpvVnV4dkhBZGxLVmNBeDBqTkxGbmNSVi9iaFR3?=
 =?utf-8?B?d25HVlJwY3U0U3pMa1pDUjg3ZlN5M1JSamNzVDd1MEMyb056UGR0WE1RMW9X?=
 =?utf-8?B?ek9tZVI5VU1qUlMzUmVndUVKYzdPZ3pBOTk4S3RibmR0dlpjRnF5MDg0TTNk?=
 =?utf-8?B?NzdWcW5EMHZyaE5OQ1RmY2tMNzd0OHYrRlRXYnh0UU9zMW0zRFlRcVNLOEFm?=
 =?utf-8?B?VEYxQm9UZHh3cTFGa2g3Ym92dDlYZVE0Y0R4Slc1Q0N4V3FWZjVGTDk5NWVn?=
 =?utf-8?B?M0s2Tk54OEdWM2JSZ1ZyS0lHcnJGaHNBVXFxa0YwNkp4MVpXZ1Z4WG10aVBF?=
 =?utf-8?B?cGhrMWlnTzQ2eW9nekljNU9Na2tLd0RrMzlEYlMxNHBsTUpkQ2pMYjQvL3hj?=
 =?utf-8?B?cjg5SWd4RE9JbldtUFpsSW9rRXpwc0w5WDhBTTgxTFV2WU1XYUUyek03UUt1?=
 =?utf-8?B?d0Z4Z3RXb3piajlsWURHc092enI2NzZHaUVYbGcwZTkxNllHY3BQQ2IzVHFB?=
 =?utf-8?B?N0VRS0huU0tsZ2cyZkZQRWx0S1JFeW9ESmpWMjVabTduWEpqTlRtMTZMblh5?=
 =?utf-8?B?ejhkYXZPdTlXQXZlZDJ2UEV4aEZzZmZNN2p6TWEybVMxUSt3ekRtTXRGOUpw?=
 =?utf-8?B?eTEzajl5TDhyWGVQSkliMUgwK3EwV2lkWGlJM2tjdWtUU0xtblBHM1ZRUUFS?=
 =?utf-8?B?L05Pa2I5MnZMbWp1MEJwbVhIMVJhby9YbWNMcEl2VUpFSmNMbGVMRFdveWdW?=
 =?utf-8?B?V0tkeFYxS1lTRjZ4R2FVZ2hKMGhsQVE5TGxsaWc1elhZVHdKTW53T1UrK3hq?=
 =?utf-8?B?cGRpYXEwM2NKUTFDeGd3ZHRXSWQ3Q0FpU3BkalJwWGloR0JYVEFHQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F4BC3068D99AF4FB9F392CBAF38DE10@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: UEsoCca453HXiNu3hK2NOHbS1uSklH914nE9pRyMf1wV7V5d1gEp5khn4sXKfLVEsz5jajhsQO38E8JfRCrxOCwICHrAs+wmObkPYp7O8QrFAFVMd/T0AQk6qwwtsMT/JlZt30OwqEhNuh40BHxhn+Hi71fVFNwfnpR04Mz5fGnUgBx+mwx7sI6GcX9rc1ik8VWCEh98bWdve6GjR74Jv01ytn5j03i5KD63WJXAx7/+yrsI8cB7zYJ6HVMJRuX5JnE4nbC4xDSqHY4xxGeWDnQ9hXPWi1SZeyOJ7d6dimFmdgC8h2A8Z4hnl1BUBYp58KSZyXVE2Q1o1qNZtAUztA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d19c2ad-d713-42df-d1fa-08de7a489bc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 23:49:00.2676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ukoAC/7vlV67dgsWoSH+eyTUfgz9yVxldGVqLH7Tp1DqjsCOke0LU7doCGc/Q8Pu/047O3lP/5zqQ1FGON44Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8739
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 90FC9209218
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72766-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[27];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gRG9j
dW1lbnQgVERYIE1vZHVsZSB1cGRhdGVzIGFzIGEgc3Vic2VjdGlvbiBvZiAiVERYIEhvc3QgS2Vy
bmVsIFN1cHBvcnQiIHRvDQo+IHByb3ZpZGUgYmFja2dyb3VuZCBpbmZvcm1hdGlvbiBhbmQgY292
ZXIga2V5IHBvaW50cyB0aGF0IGRldmVsb3BlcnMgYW5kDQo+IHVzZXJzIG1heSBuZWVkIHRvIGtu
b3csIGZvciBleGFtcGxlOg0KPiANCj4gIC0gdXBkYXRlIGlzIGRvbmUgaW4gc3RvcF9tYWNoaW5l
KCkgY29udGV4dA0KPiAgLSB1cGRhdGUgaW5zdHJ1Y3Rpb25zIGFuZCByZXN1bHRzDQo+ICAtIHVw
ZGF0ZSBwb2xpY3kgYW5kIHRvb2xpbmcNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENoYW8gR2FvIDxj
aGFvLmdhb0BpbnRlbC5jb20+DQo+IC0tLQ0KPiAgRG9jdW1lbnRhdGlvbi9hcmNoL3g4Ni90ZHgu
cnN0IHwgMzQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNo
YW5nZWQsIDM0IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9u
L2FyY2gveDg2L3RkeC5yc3QgYi9Eb2N1bWVudGF0aW9uL2FyY2gveDg2L3RkeC5yc3QNCj4gaW5k
ZXggNjE2NzBlN2RmMmY3Li4wMWFlNTYwYzdmNjYgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRp
b24vYXJjaC94ODYvdGR4LnJzdA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2FyY2gveDg2L3RkeC5y
c3QNCj4gQEAgLTk5LDYgKzk5LDQwIEBAIGluaXRpYWxpemU6Og0KPiAgDQo+ICAgIFsuLl0gdmly
dC90ZHg6IG1vZHVsZSBpbml0aWFsaXphdGlvbiBmYWlsZWQgLi4uDQo+ICANCj4gK1REWCBNb2R1
bGUgUnVudGltZSBVcGRhdGVzDQo+ICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiArDQo+
ICtUaGUgVERYIGFyY2hpdGVjdHVyZSBpbmNsdWRlcyBhIHBlcnNpc3RlbnQgU0VBTSBsb2FkZXIg
KFAtU0VBTUxEUikgdGhhdA0KPiArcnVucyBpbiBTRUFNIG1vZGUgc2VwYXJhdGVseSBmcm9tIHRo
ZSBURFggTW9kdWxlLiBUaGUga2VybmVsIGNhbg0KPiArY29tbXVuaWNhdGUgd2l0aCBQLVNFQU1M
RFIgdG8gcGVyZm9ybSBydW50aW1lIHVwZGF0ZXMgb2YgdGhlIFREWCBNb2R1bGUuDQo+ICsNCj4g
K0R1cmluZyB1cGRhdGVzLCB0aGUgVERYIE1vZHVsZSBiZWNvbWVzIHVucmVzcG9uc2l2ZSB0byBv
dGhlciBURFgNCj4gK29wZXJhdGlvbnMuIFRvIHByZXZlbnQgY29tcG9uZW50cyB1c2luZyBURFgg
KHN1Y2ggYXMgS1ZNKSBmcm9tIGV4cGVyaWVuY2luZw0KPiArdW5leHBlY3RlZCBlcnJvcnMgZHVy
aW5nIHVwZGF0ZXMsIHVwZGF0ZXMgYXJlIHBlcmZvcm1lZCBpbiBzdG9wX21hY2hpbmUoKQ0KPiAr
Y29udGV4dC4NCg0KRHVyaW5nICJ1cGRhdGVzIiBvciAidXBkYXRlIj8gIFRoZSBtb2R1bGUgb25s
eSBiZWNvbWVzIHVucmVzcG9uc2l2ZSBkdXJpbmcNCiJvbmUgbW9kdWxlIHJ1bnRpbWUgdXBkYXRl
IiwgY29ycmVjdD8NCg0KPiArDQo+ICtURFggTW9kdWxlIHVwZGF0ZXMgaGF2ZSBjb21wbGV4IGNv
bXBhdGliaWxpdHkgcmVxdWlyZW1lbnRzOyB0aGUgbmV3IG1vZHVsZQ0KPiArbXVzdCBiZSBjb21w
YXRpYmxlIHdpdGggdGhlIGN1cnJlbnQgQ1BVLCBQLVNFQU1MRFIsIGFuZCBydW5uaW5nIFREWCBN
b2R1bGUuDQo+ICtSYXRoZXIgdGhhbiBpbXBsZW1lbnRpbmcgY29tcGxleCBtb2R1bGUgc2VsZWN0
aW9uIGFuZCBwb2xpY3kgZW5mb3JjZW1lbnQNCj4gK2xvZ2ljIGluIHRoZSBrZXJuZWwsIHVzZXJz
cGFjZSBpcyByZXNwb25zaWJsZSBmb3IgYXVkaXRpbmcgYW5kIHNlbGVjdGluZw0KPiArYXBwcm9w
cmlhdGUgdXBkYXRlcy4NCj4gKw0KPiArVXBkYXRlcyB1c2UgdGhlIHN0YW5kYXJkIGZpcm13YXJl
IHVwbG9hZCBpbnRlcmZhY2UuIFNlZQ0KPiArRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL2Zpcm13
YXJlL2Z3X3VwbG9hZC5yc3QgZm9yIGRldGFpbGVkIGluc3RydWN0aW9ucw0KPiArDQo+ICtTdWNj
ZXNzZnVsIHVwZGF0ZXMgYXJlIGxvZ2dlZCBpbiBkbWVzZzoNCj4gKyAgWy4uXSB2aXJ0L3RkeDog
dmVyc2lvbiAxLjUuMjAgLT4gMS41LjI0DQo+ICsNCj4gK0lmIHVwZGF0ZXMgZmFpbGVkLCBydW5u
aW5nIFREcyBtYXkgYmUga2lsbGVkIGFuZCBmdXJ0aGVyIFREWCBvcGVyYXRpb25zIG1heQ0KPiAr
YmUgbm90IHBvc3NpYmxlIHVudGlsIHJlYm9vdC4gRm9yIGRldGFpbGVkIGVycm9yIGluZm9ybWF0
aW9uLCBzZWUNCj4gK0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMtZGV2aWNlcy1mYXV4
LXRkeC1ob3N0Lg0KPiArDQo+ICtHaXZlbiB0aGUgcmlzayBvZiBsb3NpbmcgZXhpc3RpbmcgVERz
LCB1c2Vyc3BhY2Ugc2hvdWxkIHZlcmlmeSB0aGF0IHRoZSB1cGRhdGUNCj4gK2lzIGNvbXBhdGli
bGUgd2l0aCB0aGUgY3VycmVudCBzeXN0ZW0gYW5kIHByb3Blcmx5IHZhbGlkYXRlZCBiZWZvcmUg
YXBwbHlpbmcgaXQuDQo+ICtBIHJlZmVyZW5jZSB1c2Vyc3BhY2UgdG9vbCB0aGF0IGltcGxlbWVu
dHMgbmVjZXNzYXJ5IGNoZWNrcyBpcyBhdmFpbGFibGUgYXQ6DQo+ICsNCj4gKyAgaHR0cHM6Ly9n
aXRodWIuY29tL2ludGVsL2NvbmZpZGVudGlhbC1jb21wdXRpbmcudGR4LnRkeC1tb2R1bGUuYmlu
YXJpZXMNCj4gKw0KPiAgVERYIEludGVyYWN0aW9uIHRvIE90aGVyIEtlcm5lbCBDb21wb25lbnRz
DQo+ICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIA0KDQpJ
IHRoaW5rIEkndmUgY29uZnVzZWQgd2hhdCB5b3UgbWVhbiBieSAidXBkYXRlcyIgb3IgInVwZGF0
ZSIuDQoNClBlcmhhcHMgeW91IG1lYW4gdGhlICJzdGVwcyIgZHVyaW5nIG1vZHVsZSB1cGRhdGUg
YXMgInVwZGF0ZXMiPw0KDQpCdXQgdG8gbWUgeW91IGluZGVlZCBzYWlkICJ1cGRhdGUiIGluIHRo
ZSBjaGFuZ2Vsb2c6DQoNCiINCiAtIHVwZGF0ZSBpcyBkb25lIGluIHN0b3BfbWFjaGluZSgpIGNv
bnRleHQNCiAtIHVwZGF0ZSBpbnN0cnVjdGlvbnMgYW5kIHJlc3VsdHMNCiAtIHVwZGF0ZSBwb2xp
Y3kgYW5kIHRvb2xpbmcNCiINCg0KUGxlYXNlIG1ha2UgdGhpcyBjb25zaXN0ZW50IGF0IGxlYXN0
Lg0KDQpXaXRoIHRoaXMgY2xhcmlmaWVkL2FkZHJlc3NlZCwgZmVlbCBmcmVlIHRvIGFkZDoNCg0K
UmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KDQoNCg==

