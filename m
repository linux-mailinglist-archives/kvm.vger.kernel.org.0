Return-Path: <kvm+bounces-50420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D97CAE5295
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 23:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C387D1B65753
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 21:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CED225785;
	Mon, 23 Jun 2025 21:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XNI76+Uz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAD02AEE4;
	Mon, 23 Jun 2025 21:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715097; cv=fail; b=bvJeMy01hCKzJJGBQoiS45BnGLK7wK7OlI9hL7jmowW72tTkkfiUUUr27HzmeJWgfWrOOM3CO/N3t1r3TnEz+nwMLtAhLH6z4zwVyGppabgtRBWLpFraYCPl0Tc8MUnZxZ6cNzAc8SUD1uY0+DAt7xai/TSK7MVw8R/7dcb2nxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715097; c=relaxed/simple;
	bh=ejE45EnKicgfbbXWevFSlgO86aJPkMe/Wn9Nmfawyr8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y0ZSeQjFsR2Gx45hn0dIVCPwybplfXVqjgR6vkPXUjOawTBj/M/yuhFT9zxrKDGhHGjoZmMtdthynPpampabRTS99nTfKbDs0AcijSiBtdgfNLlc7F4BVl3HUOCp2KrM8Enzq1bypQB7dO8fKzfTwOzUK6vZ3+6g2wsTeCEW+FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XNI76+Uz; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750715095; x=1782251095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ejE45EnKicgfbbXWevFSlgO86aJPkMe/Wn9Nmfawyr8=;
  b=XNI76+UznLuFMq3c4b4Am2QZaABHmBGpHeQOPyRvsmfWRNQiCSGMmvKq
   dcpjKMRLkh7dZuEP6L3kTRi9xlXi5B1cSgPLsGic+ZdKiYT5dgo3US5se
   ZL178WUv/2CMC1amJrln7GQseNnSRPWz2N6YFnzCX90SfsufLyySczu6K
   x5aakgAYlb8qLpRFYgkBTvBuH/uQRyJktuWO3AC3vdRhS/7rZtDLC7K5O
   dQbKP7yASjK9qvB0VoWgbJmaNQPOONhr92SDOTt0ZM7O/sGxdesmGK8dS
   4s76jw/V6sd8MbxZtalVYKSXZ/V6dctrmape71eMNJuk4WBSJiUkCQDTT
   Q==;
X-CSE-ConnectionGUID: 4vLI4P60Q+eJ5PZonyP+DQ==
X-CSE-MsgGUID: fNZbDwE4S9qjxwCdk0xrAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="70503945"
X-IronPort-AV: E=Sophos;i="6.16,259,1744095600"; 
   d="scan'208";a="70503945"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 14:44:54 -0700
X-CSE-ConnectionGUID: 0yCfxIIJQE2P0rrQ+gySDw==
X-CSE-MsgGUID: K5LpshkGRxm6S69QEJ37YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,259,1744095600"; 
   d="scan'208";a="155727392"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 14:44:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 14:44:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 23 Jun 2025 14:44:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.86)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 14:44:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=teTxxPdAgM2UYCgyHnARYYz0jeCyX7s6CHYtPckt12qlqMpgALvhA1MUisko8ZUa25S31CHzATBs0UjrEvbw6op0AEVE7yl/AO9aMlB1CX9L6ASTStHufI1dNKu/b/qHJYULI6CwicaM9HlkLXBDNElMgGzI8MxkW+b6yz5w8s1E6W3BVp7WYnLUxU8DVXshvdjAxFFfW4ivIaLj6f0t9xtPlS2F8nI0uGWQrgqvWfR6KvqDUzF977gBY91QUjHY4ddabyNUN/idg6rMJCRNPhVcrVLPYmE0Z0xZcDeCL3vhjd/WT2w9hq47RDn6t4JTje4PGecZzqv0V1rIYQ/IXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejE45EnKicgfbbXWevFSlgO86aJPkMe/Wn9Nmfawyr8=;
 b=GcEfRHrS51LiDcXKWZZ/HFxk6y6z3OTV3+rvmfbYM1WMXSTFcrzdvKnMjdKH+eO/en2+PhFXspihRlMj3FazROb3RGYe+tUazJGR4iRb717N7gCaFDyobBGKrN1rS3gNoS91Y+pdmXxD5tvfzPVansSHYnYjBKm+XaKWlia2TsILT5UlVb9lcM8Yf/I8gzWSUwRYUceXl6bl8OLzPWbV2nqDUD1OJ0q7rm1J1fvre4MUkO1uF4CFCOitaKJFuCP3F/jVNSO5Xfr1g4cPjA6mJA8O5+af8DD6Mt2Yzg2S1wCxEM64PZuAbZ8i9Fq/7EdoMFz9qEm+Dd89rpT4I0Ov+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB8223.namprd11.prod.outlook.com (2603:10b6:208:450::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Mon, 23 Jun
 2025 21:44:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Mon, 23 Jun 2025
 21:44:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygIADYjmAgAFIQYCAACKZgIABjCaAgAQxHwCABQ5egA==
Date: Mon, 23 Jun 2025 21:44:17 +0000
Message-ID: <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
References: <aEt0ZxzvXngfplmN@google.com>
	 <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
	 <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
	 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
	 <aEyj_5WoC-01SPsV@google.com>
	 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
	 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
	 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
	 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
	 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com> <aFWM5P03NtP1FWsD@google.com>
In-Reply-To: <aFWM5P03NtP1FWsD@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB8223:EE_
x-ms-office365-filtering-correlation-id: 180cf96c-fd60-406d-560f-08ddb29f1a93
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N3VPS0prY1JVSzg3MU82MWMzUFJYY1k2NlRTRzdwNUVsM2NNcnhLblRXZzdN?=
 =?utf-8?B?TTB5bE5KY20yT0JzTmtrOVRPOTVsTUtkc0x0VEo2anN5TTg1WEIrd1c5MWgv?=
 =?utf-8?B?WUpaYUdQOC9DclRYZGNvZWJXZ1p2SFl0UmhSL0ZWVGhVOVlsdXVqTEtQOHpY?=
 =?utf-8?B?SncrR1FpakRnM05Lbk9TSXozNXZWQUN3UWczbWt0N25HU2lMMGhwdkF5WXRC?=
 =?utf-8?B?VVpacGZkSnltb0N4ZjdKMTBtY2o4VWJSdllCd1NvYyt2ZUdKMkNoZHh5REVG?=
 =?utf-8?B?YkNRekpVMXFWeE9LYVpNM2JaMXJrYUVJYWM0TVR6Smx4K3J2c0kxdEgxMzQv?=
 =?utf-8?B?SUVVMXBsTENDcWM3V2dBMVFpQkhNc2dUaXBrN1lXOU1ydEhidWM4V2NNRndF?=
 =?utf-8?B?cEZvN24xRkhvQkM1akwySlpCR1phOGhUZGN6OUxMYnBlVnlYRy9lSnQzMkFx?=
 =?utf-8?B?T0NGajJLNERkVTBlWTZhNDUwcWZyQm9VYXJCM3QvY2lRektia25vTmNpbWZI?=
 =?utf-8?B?VVVaSjNMSTlveXlUS2Q4WnZtMldId3p6elpFOEo2VGVuc0pkZWlkSUlzZW0x?=
 =?utf-8?B?T0U1Y09waE1KTXM1R0lVTWg1N1YyQktlaTVQKzVjUzViaXdLWXpHeWRIZ2Q3?=
 =?utf-8?B?S3d5b1VGMFQyVFZIa1BiSXZ5cCtvTUlUcmlEa2dzYUc4Y3Q1bXpMTGg4bUtJ?=
 =?utf-8?B?cjNvcys3eXRrNjhTdFJXcGhVVjZ2WWx5aHl6MCtvbjlGNTZjZzg5aElpYkRY?=
 =?utf-8?B?N2lkODRWZkxQMk41cnIvaXVtbTMzRkhYdE03K2hHem9pcW11K1lTcTkxQWFH?=
 =?utf-8?B?SVA4djJwbW9VbmhKWjVMV2FXeUZybU5GMlgrVkUzWThSQ09oOUVnNmpqdGYv?=
 =?utf-8?B?Wi9aZXpwamhkNDR3Z3hKRnhyYjNTMHpuUklkZW5wTS9TKzdobzVRUkluVHox?=
 =?utf-8?B?aFJWbGJHSklwaVRaWGlMai9hZCtwMlArQ2N1bEZORTM2UnNhUTNzeEFXeVJl?=
 =?utf-8?B?WHJYek82RTJvNzJkUFo5dXJGMVBLVlc5L3c5cmY5cjRucGQ3ZWRDT0VPVUsy?=
 =?utf-8?B?RnJmU1RWQ3Z5cWMrTm9kTDRkcEdmSFBqNmwrcHMwSVF1QmlZWmwxWWQyR0Rk?=
 =?utf-8?B?OFFhL3IrM0w1MXhCWkhWRk5kNlJIMEJGRzF5MUxoU2NMVldUMjFKamRXNlp6?=
 =?utf-8?B?YmRtOE1ucWVRZUV2ZzBRVHVIdGw5d21oMjRXTGUyUDNOS1hoY0trdjdUU2Vq?=
 =?utf-8?B?TnYwM3ZMb0tiNDFTNUV5M0V3Zi9HTjV2MHVWTmlETmZFZjRWUjBaajVSZnlt?=
 =?utf-8?B?U1dtSHVwY1IrWENKdDRJbGVZUkN0UEFkRUpIVEhGL1NleGQ2ejVhL1IwS1VB?=
 =?utf-8?B?WE1hL0U1SHd1YkNWT2JNbUl6YzY3Y216K3N0QzcvblFqVmhCSW9jRmZ6MlZ0?=
 =?utf-8?B?WDFlZlRaWjdWbFh0UmcwL3h1VVE0NlZsRWU1dGZIWFJjUjF5SFE0MzZYTHV5?=
 =?utf-8?B?OENkV2Y4Wks5RHk5NjlYNzR1Uk9VUlRtRmd4eW0veGM5VUZkWmdvL2QwSVNX?=
 =?utf-8?B?RzNSdk5DYkYyWk9KZmpDUEllME5FZCtvZ1FDeFo0eloyU0doVHBGeGhGYzhK?=
 =?utf-8?B?dHo5Ly9IbjFEL3hDdE1CU1lDMG55L2FrNHJBOXQxbG1oWCt4azVldTB2aHBx?=
 =?utf-8?B?SXBhOURIb3hsQXVBU0dlZkovMWJKWjhONmtvbGRmNnVmdEY4SktvT21ZWHQv?=
 =?utf-8?B?MlMyZDJLaHNOazBTZEVHdjI5bGx3VHNoWEpLTXFmaHh6YzBESEExZjVlMWo4?=
 =?utf-8?B?djlqR2J0a0ZuNEVHVWlZOGVOMkxwQ1dYZ3BkS0ptV2NWNnI0TFVNcUNYRFMr?=
 =?utf-8?B?MjQ1R3d6ODlkZU5wWFAxNHpSaDVQVHNCYXplRHFxK1JNRVppQmpWaDlEMjBy?=
 =?utf-8?B?cjF0YUtibXZZNU03ZGR5RWJLVlQ4K2ZQMGZId2VSeXNlWVZoVWZIanFDaDU2?=
 =?utf-8?B?TjlVRFg3VnlBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGl1K0NwdGtlcjYrK3daSXhXc0pLU2g2cXFRME4zVUZsVlhkdXFicm5pdGZl?=
 =?utf-8?B?U080eG81WW1yeFpuVkZHdmkxWTVhaFNNSDVsdGt5ZjU4RnRLak11aWZ1UFVD?=
 =?utf-8?B?R1pqVVgrSkFkM0FiRCtJTWRVWEYyQVZMcHBzdjhVYjhZU2RSMGZTUEt2Q2NX?=
 =?utf-8?B?a1JBV0VSKzdpVGV5SFdMZmFoOHZTbklMc1l4b3AzbGgxd3dLN292ODFTdytO?=
 =?utf-8?B?VHFSdkhoVTNxbVNaL3plMGF2dEpSRWN5WFBybnJ5WVNkV2pTN1JXZmVCejZo?=
 =?utf-8?B?MndIaWNyRkRCVDZhVDlaNWxsNFpITXk2aGE2aXlqQlZWN2luQU9YU3BoMHM2?=
 =?utf-8?B?Y3Y0NFN0aXVseS9ROVVVZy9lOWhsRE5aQ1hPV1ZTRVJkV1R0Z2dZYkZDVXpX?=
 =?utf-8?B?ekpXRWptbCt3TUZieVprbXZUU04zY1dIL1BDZXdyWmVOY2UwcU82LytCK0hz?=
 =?utf-8?B?VjhZODlrYUM2eWhMb0JFMTQxSzdCOU8ybG5YMkx0cEsybnJ5Ykp3UkdXQnln?=
 =?utf-8?B?ZkhzaVJpaGdpUTVtcWw4emJId0lFdGlsN2Vqb0JZZUFFM2UzWlYzNkhwNllM?=
 =?utf-8?B?elVaQ0plVythZ3p5U0s3eVpjTVdVV1lkaHFuWWJwUTNwOWZkM3p3b1FOVUtV?=
 =?utf-8?B?QWZzTGdqclF1dzhKamZjK0hkd1MwSVRWcm5KWkE0LytOd3NUREFWbmtXN3h0?=
 =?utf-8?B?eHE3bTJmT1hiMThPRHQrT2cxMHZBb21LVkRkazBuQ3NZRXdDd0Vlbys2YjBV?=
 =?utf-8?B?cGc5czVnR0pERUc0OWlXV0R0NjU2SnpLOHJ1LzMxYWFIV2hsRkNwY09tSmN3?=
 =?utf-8?B?enF6VTcvNkFqak4vajlaVGM2WE9rOG1Kd3R3dHM2VjU3VVZzVG5oa2NPM20v?=
 =?utf-8?B?QUZxZ2R0RXliRlJWNE1XZ2dBaGE2aE1YSUJrZHNiWHBjeE00bC9ZNW1ocDRN?=
 =?utf-8?B?TE9MZi9ybEMvdFNZS3JMZFVvV1FPZ2tmaDhTMk9acGpSOUgvSkh4bHFZZSts?=
 =?utf-8?B?OHpNS0Y3TlNYQVZUa2hpKzdDL3VFaXhIZEEzZmtxUmVOYUlzcURXUVA1eW5k?=
 =?utf-8?B?V1lmR2NSRUVpVTk3endHb1JyZzJ4UkdIK1U1Vm1JMmhmNmExSDYxUVVnMFE2?=
 =?utf-8?B?dDZSWFBPTnJJMEVMN3JHRVVMeEQzZEppWC9GTzVXQmVRK01RSEg1NGVFZy90?=
 =?utf-8?B?bkY4MGUzdVRZMVJEcDJqVnRKQWxrL2wzdnNZK09TVWJPOW0xWWwvcmlZZ3Rt?=
 =?utf-8?B?ODViODlzUTUvRGJ3dEVmYTVrNTRqUEI0TUpuTDJicGVVcG9tSlJlbGorK0V4?=
 =?utf-8?B?TDR2RUVLNVdYN1g4czZocDliRGNycUgxT3Y0Z1FuZzlSMDRUR2tZT050cXFm?=
 =?utf-8?B?ajFLNUs3a0lxbk5qQ2kzWk5vU0ZXKzdIWnhRUnVqejFZT2J0NnlKeFh5RzVQ?=
 =?utf-8?B?YmwyK0h0THJZSFBWVjluRkFoajJySHBnSkM4Nk52ZzVQVkprVkJkaitnRllo?=
 =?utf-8?B?Ui9GSEhLTHhOT2RRMEVVaDhtbGZISHJCNCs2Q2p2Sjl3V3JJeDlrT2dnRGVy?=
 =?utf-8?B?Z3lSelJYLy9NNTJwaktGZDlLdTlmREJ4bXVrNlRrMmVjS0lRM1BqUHV0LzVQ?=
 =?utf-8?B?d21NVGhqeWQrY2VUczk4MTFZMmczYytTQVBwM3lnQVZ1dlcvU3oybHNQeVYv?=
 =?utf-8?B?SGJRLzY2anUvVCtaSWRlakZCSit4VEU1MlcyeEFpY25iZHVOU1U0dDU0b1pM?=
 =?utf-8?B?V3k4QUVva2VTUm0vWkF3VVBIZjZnQlZ6T09XVjNRanFTS3ZuWUNGOWJxdVNW?=
 =?utf-8?B?S1N2QnArQldFWktXbmU2clFuSW5iSUlPOW1XZFEyN3p0ZDlUU0VHVGtYL3Bn?=
 =?utf-8?B?RUI0dFp0YmhrRmtpYW5hYyt1ZVB0aUhJZjJxKzJBNVVST0p4c3RncjYyT0lP?=
 =?utf-8?B?WXA3cTU2ZzJqbkVyajdMRWNHQmdpWWNIYkJ6UnZiZUlRdDhCZHcyaFZhUGlU?=
 =?utf-8?B?MWJDTEpvN25wdEhONDlpSzl2ekpCSjA0UWNocXFpOG0xcHRNYTY1cjBqS1Ix?=
 =?utf-8?B?VnUyNzhoL1dONlZhZmZTMWxJb0YrY1ZJZ1lCUElYcnpGbjlNaHJzNUtnNnZP?=
 =?utf-8?B?WTllTXVJN3ExekF1NUg2NjcyNFRoeE9mSGR4MEVweGx5UUJwY09nVE5rdzBS?=
 =?utf-8?B?bVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5D80D250BED3043A7A7FBCBDEE5982F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 180cf96c-fd60-406d-560f-08ddb29f1a93
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2025 21:44:17.1734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o2SlcHLvZAWRVjuEXxgE4bSVy8+xQ8JBBb04UOA1Xb8kc7Q+RFyfujN+tePalRGaIXZEjNhBIOv+LzVncAl3kjJDlqmn+P7VD7zW2KfKSlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8223
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTIwIGF0IDA5OjMxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IE9uIFdlZCwgSnVuIDE4LCAyMDI1LCBZYW4gWmhhbyB3cm90ZToNCj4gPiA+ID4g
wqDCoCB3aGVuIGFuIEVQVCB2aW9sYXRpb24gY2FycmllcyBhbiBBQ0NFUFQgbGV2ZWwgaW5mbw0K
PiA+ID4gPiDCoMKgIEtWTSBtYXBzIHRoZSBwYWdlIGF0IG1hcCBsZXZlbCA8PSB0aGUgc3BlY2lm
aWVkIGxldmVsLg0KPiA+IA0KPiA+IE5vLsKgIEkgd2FudCBLVk0gdG8gbWFwIGF0IHRoZSBtYXhp
bWFsIGxldmVsIEtWTSBzdXBwb3J0cywgaXJyZXNwZWN0aXZlIG9mIHdoYXQNCj4gPiB0aGUgZ3Vl
c3QncyBBQ0NFUFQgbGV2ZWwgc2F5cy7CoCBJLmUuIEkgd2FudCBLVk0gdG8gYmUgYWJsZSB0byBj
b21wbGV0ZWx5IGlnbm9yZQ0KPiA+IHRoZSBBQ0NFUFQgbGV2ZWwuDQoNClRoaXMgaXMgd2hhdCBJ
IHdhcyB0aGlua2luZywgYnV0IEknbSBzdGFydGluZyB0byB0aGluayBpdCBtaWdodCBub3QgYmUg
YSBnb29kDQppZGVhLg0KDQpUaGUgUEFHRV9TSVpFX01JU01BVENIIGVycm9yIGNvZGUgYXN5bW1l
dHJ5IGlzIGluZGVlZCB3ZWlyZC4gQnV0ICJhY2NlcHRlZCIgaXMNCmluIHNvbWUgaW1wb3J0YW50
IHdheXMgYSB0eXBlIG9mIHBlcm1pc3Npb24gdGhhdCBpcyBjb250cm9sbGFibGUgYnkgYm90aCB0
aGUNCmd1ZXN0IGFuZCBob3N0LiBUbyBjaGFuZ2UgdGhlIEFCSSBhbmQgZ3Vlc3RzIHN1Y2ggdGhh
dCB0aGUgcGVybWlzc2lvbiBpcyBzdGlsbA0KY29udHJvbGxlZCBieSB0aGUgaG9zdCBhbmQgZ3Vl
c3QsIGJ1dCB0aGUgYWxsb3dlZCBncmFudWxhcml0eSBpcyBvbmx5DQpjb250cm9sbGFibGUgYnkg
dGhlIGhvc3QsIGZlZWxzIHdyb25nIGluIGEgY291cGxlIHdheXMuDQoNCkZpcnN0LCBpdCB0dXJu
cyBob3N0IG1hcHBpbmcgZGV0YWlscyBpbnRvIGd1ZXN0IEFCSSB0aGF0IGNvdWxkIGJyZWFrIGd1
ZXN0cyB0aGF0DQpyZWx5IG9uIGl0LiBTZWNvbmQsIGl0IGJldHMgdGhhdCB0aGVyZSB3aWxsIG5l
dmVyIGJlIGEgbmVlZCBmb3IgZ3Vlc3RzIHRvIHNldA0KdGhlIGFjY2VwdCBzdGF0ZSBvbiBhIHNw
ZWNpZmljIHNtYWxsZXIgZ3JhbnVsYXJpdHkuIE90aGVyd2lzZSwgdGhpcyBwYXRoIHdvdWxkIA0K
anVzdCBiZSBhIHRlbXBvcmFyeSBzaG9ydGN1dCBhbmQgbm90IGFib3V0IGNvbXBvbmVudHMgaW1w
b3NpbmcgdGhpbmdzIHRoYXQgYXJlDQpub25lIG9mIHRoZWlyIGJ1c2luZXNzLg0KDQpJbnN0ZWFk
IEkgdGhpbmsgdGhlIHR3byBpbXBvc2l0aW9ucyB0aGF0IG1hdHRlciBoZXJlIGFyZToNCjEuIFRE
WCByZXF1aXJlcyBzaXplIHRvIGJlIHBhc3NlZCB0aHJvdWdoIHRoZSBnZW5lcmljIGZhdWx0IGhh
bmRsZXIgc29tZWhvdy4NCjIuIFREWCBkZW1vdGUgaXMgaGFyZCB0byBtYWtlIHdvcmsgdW5kZXIg
bW11IHJlYWQgbG9jayAoYWxyZWFkeSB3b3JraW5nIG9uIHRoaXMNCm9uZSkNCg0KU2Vhbiwgd2Vy
ZSB0aGUgdHdvIG9wdGlvbnMgZm9yICgxKSByZWFsbHkgdGhhdCBiYWQ/IE9yIGhvdyBkbyB5b3Ug
dGhpbmsgYWJvdXQNCmNoYW5naW5nIGRpcmVjdGlvbnMgaW4gZ2VuZXJhbCBhbmQgd2UgY2FuIHRy
eSB0byBmaW5kIHNvbWUgb3RoZXIgb3B0aW9ucz8NCg0KT24gdGhlIHN1YmplY3Qgb2YgYWx0ZXJu
YXRlcyB0byAoMSkuIEkgd29uZGVyIGlmIHRoZSB1Z2x5IHBhcnQgaXMgdGhhdCBib3RoIG9mDQp0
aGUgb3B0aW9ucyBzb3J0IG9mIGJyZWFrIHRoZSBLVk0gbW9kZWwgd2hlcmUgdGhlIFREUCBpcyBu
b3QgdGhlIHJlYWwgYmFja2luZw0Kc3RhdGUuIFRERy5NRU0uUEFHRS5BQ0NFUFQgaXMga2luZCBv
ZiB0d28gdGhpbmdzLCBjaGFuZ2luZyB0aGUgInBlcm1pc3Npb24iIG9mDQp0aGUgbWVtb3J5ICph
bmQqIHRoZSBtYXBwaW5nIG9mIGl0LiBURFggbW9kdWxlIGFza3MsIG1hcCB0aGlzIGF0IHRoaXMg
cGFnZSBzaXplDQpzbyB0aGF0IEkgY2FuIG1hcCBpdCBhdCB0aGUgcmlnaHQgcGVybWlzc2lvbi4g
S1ZNIHdvdWxkIHJhdGhlciBsZWFybiB0aGF0IHRoZQ0KcGVybWlzc2lvbiBmcm9tIHRoZSBiYWNr
aW5nIEdQQSBpbmZvIChtZW1zbG90cywgZXRjKSBhbmQgdGhlbiBtYXAgaXQgYXQgaXQncw0KY29y
cmVjdCBwYWdlIHNpemUuIExpa2Ugd2hhdCBoYXBwZW5zIHdpdGgga3ZtX2xwYWdlX2luZm8tPmRp
c2FsbG93X2xwYWdlLg0KDQpNYXliZSB3ZSBjb3VsZCBoYXZlIEVQVCB2aW9sYXRpb25zIHRoYXQg
Y29udGFpbiA0ayBhY2NlcHQgc2l6ZXMgZmlyc3QgdXBkYXRlIHRoZQ0KYXR0cmlidXRlIGZvciB0
aGUgR0ZOIHRvIGJlIGFjY2VwdGVkIG9yIG5vdCwgbGlrZSBoYXZlIHRkeC5jIGNhbGwgb3V0IHRv
IHNldA0Ka3ZtX2xwYWdlX2luZm8tPmRpc2FsbG93X2xwYWdlIGluIHRoZSByYXJlciBjYXNlIG9m
IDRrIGFjY2VwdCBzaXplPyBPciBzb21ldGhpbmcNCmxpa2UgdGhhdC4gTWF5YmUgc2V0IGEgImFj
Y2VwdGVkIiBhdHRyaWJ1dGUsIG9yIHNvbWV0aGluZy4gTm90IHN1cmUgaWYgY291bGQgYmUNCmRv
bmUgd2l0aG91dCB0aGUgbW11IHdyaXRlIGxvY2suLi4gQnV0IGl0IG1pZ2h0IGZpdCBLVk0gYmV0
dGVyPw0K

