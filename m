Return-Path: <kvm+bounces-59367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94A60BB1A58
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 21:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 452C51751D9
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 19:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B037D26FDA8;
	Wed,  1 Oct 2025 19:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gm9AtWW2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4322AD0C;
	Wed,  1 Oct 2025 19:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759348137; cv=fail; b=n9RvGceG8OYUHvE+ybfh7YU7APzZbbjgxGcpw7Q16dCtMw3mbXXnleErKZ5Je2y9Sw8YLVh5IG8Zjih6RKyU4riYR8udHHKseQC91XPYBidxD1c29ifa4lky9TSYrRhpHkG8+Yevfs9gdsdd9lffAYZUJClO6Ga2QEnxYcQDumc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759348137; c=relaxed/simple;
	bh=YC/onOeyjVQwCoCEWz+rte1qlBZLFcLli7BzklqVfdU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rdINT3El+JtkD/WKJ5v5uFmuuYLikJFaKom5z6Wl0WW69Pg85zTjQ/KtfCJZb2SC6STWIuumV9H+ljAmkXWU42D3UATIkm4jHEPf6sThsvei8m0bn5Z2e++bFYL4VQ5Xez5ucnqSTUH7JUeUZQbhNqNNauGEu2R647xarXJVkHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gm9AtWW2; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759348136; x=1790884136;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YC/onOeyjVQwCoCEWz+rte1qlBZLFcLli7BzklqVfdU=;
  b=gm9AtWW2lVDJSDwuFLDe3Vkd9nshRg4agb9jGgYfm1UyiddRNTzioVGq
   wYRy3hwvN/QLOZQlkT4NGNV859zzpB5VnQ9azJkPy+UlmwkihbvU6Dh1I
   XpREEKS0f53AsWgjLEkxyqKdmIHeaCTZ3UI4uss4sF/mSt6IH90D+54jU
   qbkWe39c/YkQ/CE1znzZmMKHCmtTz/xkcWXRYsHDUPLl0gPTMRRBE6gZr
   o/ydIESsZWbYCYg68tKHafNzXXIhQERO7KbAXpypiEoEvKvz4J14DJcTp
   /Y1JO+0yTrll9Yy2aaYeCsS4dxDfS/2UBiYNYBCm2WLyPECI4on9InSYE
   g==;
X-CSE-ConnectionGUID: xuUXMIt+TKW3bz06LUq/0A==
X-CSE-MsgGUID: 2s4NdUVXRhiI6R+C0IAGCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="79055513"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="79055513"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 12:48:56 -0700
X-CSE-ConnectionGUID: AjQJC47uSUCaI5ZIEKU7DA==
X-CSE-MsgGUID: ddagww6SSDeMvrRiYjcUXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="202596093"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 12:48:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 12:48:54 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 1 Oct 2025 12:48:54 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.60) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 12:48:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=To5FjjXh5NiqeLCOw0Ox2E9g/XU6iHAc+xxd5IBGTVMraAcVeY+6TVL4m4eXxGC1gwaTcMIok10OHwePyJxsUH6bHIpWYeOMgDoLxrtQdRQVI5Xzv6WBmwT5LLz0ZTx0ZKImD5exkv0fXSWCb2vvpC8w4F5bv7mMCv0l3mU1J+Zr5vzifzszD4zqzvhkbpVGhbIzNntt0lHxvf85cAe3W+ckC4tNA8RzQXKZvRoSS3xjw6kOdTUlaK8/TNU6Elq+aTT9ukF5sL+DAcHBNda9E5ve74gxd7q1BR+o0bCGhBCcN3IUfUcdCk/mJtZ+0EuO5wPbpbU9ghrRzDwHj81VUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YC/onOeyjVQwCoCEWz+rte1qlBZLFcLli7BzklqVfdU=;
 b=rdb3xH/oplhqI7jH/WHydyWK3atoM5d8CVrrJEr+5GWPII7mnDAqdbU3CDr7udlyLEJaoPO+MD4S6DKlZ2IxXeCKhj7IyyB1quD6l185E2yVxfIVQVGUnDN3imJ/LYXKx/ncP/zS+GaD+POA47bZZAkybkUeeFMPEAmB3qKC+E6GnEy2VsP3JnbZ9yhucwbBUYom1wM/sNsIctUGAT26Tlbsy0+f/Y6ivi9rWmkgD1FOZclmJY+A9sNt4stEnutBoXKbnu0pWcy3zRHakEdZQYwXwJv9ObtIi4sNIOFdt7Cxnd3HTxvlgJG/yvoydkYcpcXXiZ6MtXSFvPUBYMC9DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB8303.namprd11.prod.outlook.com (2603:10b6:208:487::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 19:48:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 19:48:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kas@kernel.org" <kas@kernel.org>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcKPM47wNFJAdMMkCLNWN+W5B0ObSaRTEAgBOBuoA=
Date: Wed, 1 Oct 2025 19:48:51 +0000
Message-ID: <5ed71682f0ed725c69d4900cfb1ee15cd6f791b3.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
	 <l3wzjxkokrcuu7mguuojr5vnzfwjpjfxgg3d6pw5zmmgsgpdfv@wz6gvpglqkiz>
In-Reply-To: <l3wzjxkokrcuu7mguuojr5vnzfwjpjfxgg3d6pw5zmmgsgpdfv@wz6gvpglqkiz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB8303:EE_
x-ms-office365-filtering-correlation-id: f5690a4b-ca3d-4d69-6aab-08de01238c20
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bzRFdGNnN1h1NGRMakZORlhSNzFPRlhZdjdycDZGbkQ4eGZRNkk5ZWFXT204?=
 =?utf-8?B?anlra0J1UHpnOCtVUElkdnE5eFNBYVRoYVl2RkZxVUppQ3RYMkRoWExQaklm?=
 =?utf-8?B?RVVoblBQSVkxM3plYWRGWlpNR0Jvb1J0R1ZVT0RBTTVmY1FkMGVTcVg2UXF5?=
 =?utf-8?B?K244Z1dvQ2UwRVorVjNYVGZYOHgzTkRUSWhBOEdHbExEdm9zS09ZZ0FkZG9p?=
 =?utf-8?B?M0dPc1JKSDhsa1FKbzhpR2dyVmJVTzJwZTZXTE0wT21SNXhPRUF0eCtURTNS?=
 =?utf-8?B?UzZkRmljUnJweThQL09PSmxUMDhyZm1lNWF6eVJqUElCcDJlR3o5SHUyNnhH?=
 =?utf-8?B?bGM0dWJwYXA4VmYwbDRidCtBMWJGQTFLUXBHblh2V1ZyV1JMZXFOK1QyOFhH?=
 =?utf-8?B?MXZiK3dKbFdOaXlsSW1wQzBGMFQ1MEw1dmowYXY0M25pRWRUakl0R2E0Tnh1?=
 =?utf-8?B?T054azdhV0Q1RlZyMDhoSGQ0SVZ3d2lUQzR4YkxhNFBzVzVMcE5hM0VJZUFm?=
 =?utf-8?B?Rm1YckZOSU5VUUpTblZDN1V4a3NDV0NjUWhvT0t0MGZ4bVU2MFc4NVBhR2px?=
 =?utf-8?B?MkZYV0VqTWI2OXBacDI5QUVhcWwvSUYxOG5leWFmRTV4QVZyZEdDSWpmdklW?=
 =?utf-8?B?RWNoRk11SEQ4T2ZZOUVJdzdEYzFXbVlNbDBQczhNL1FKOEdwRENZa3RWZWtH?=
 =?utf-8?B?Njk5Wm1jN05qUnVpZ3BLUWlJclJOalc5OWp0NnpZa1czTStnUHFnb1E3QTRp?=
 =?utf-8?B?eTZiaFMwK3R6L01xMjVTRUtJQ3JOcjV6K2RTUnh2cDFxaGN1dkUwZzJTYk94?=
 =?utf-8?B?L3NwTE15Yjg0WnNXLzlGRXl3bGdDYVVaVG9CdHRnQmgzK1FJa2hiNDkzTjNO?=
 =?utf-8?B?ZnBTNEtRbkxTRytleTBQbGZIK3Y4dmg1QXdaQzk3TldWNlg1Rm1VNXdERmEw?=
 =?utf-8?B?SjUvWVAvclc3ajduSHZyYWlSK2hDY2sxMTRSRmtSQTd0Um5xRHByZjk5N21T?=
 =?utf-8?B?WURQNHVUQVllUkhVc1BGZllVcDJtQzR3TkJ1dy9wUElvK3RwWHk0OEZJRTlB?=
 =?utf-8?B?SzNYV1ZFNDdoQmUxeEVuYnBXc2xkdzdrS1RKbGxJTEhRL0N4ai8vc1k5Yksz?=
 =?utf-8?B?akZ6bXQ3YkZJUmhvMVJWZ3dENWlwazZXZE92WU9VbkFDdWVXMXYxVm4zR0NG?=
 =?utf-8?B?UEVxMDhDOFAzaDByZ1FSbHZFdVplVXRFZ09JOGJ6SHV2WmkrMUpTbC9CMWNp?=
 =?utf-8?B?bXo0eC9yU1Vlb1dJZ1oyc2xpTTE2Q3ZoZCt0bDhKOEJVb0ZZeVpwR3JoZEdy?=
 =?utf-8?B?Vkd2Njdrb3Y5Vjd2NGkrN1BtWkt5b1NrVlRYNm1jWldwdmhnalBLbkV3bHpY?=
 =?utf-8?B?SlJ3cDkvTUUveDlVUFY3MUN6cFJ0L2R2amQrTlpqNjliL3U0UFJtMTBjSTdJ?=
 =?utf-8?B?NTN0Q3o0aStnalpMblRteFRqbmo4TmQrNVZkT1B5eHAzQm56TTIrTytoUXNB?=
 =?utf-8?B?eE13WC9HUVdRNmtBRUZqeTBTOGtUK1paWWtqeDdQZTUyenFvdjJDQUxhRHI0?=
 =?utf-8?B?OE5BYXFBMDZmY3pXejg3QTdqNm9aNnhNVG9sUWZHc2hYS05VU2FZTXRzbzVL?=
 =?utf-8?B?SkRJQW1zU2VxdlNpSGVVRVdock9RY2FBN2x1UXVxSTMzWlFxZ2o2RnFJR3lE?=
 =?utf-8?B?L285eFZqUWF6OWx0d21QUXp3T1RhazFLS3AyOFBLWkpTWUJTZ0U2RHhCTURF?=
 =?utf-8?B?d1VLejVqaWdCNHhlZ2tGWjloMWtSbjE0UmxqRVIrd002Mld6TnFGWndoQ3lC?=
 =?utf-8?B?RGJqNTZQTnhyclZzK1RWemgvSEorMkRkVStwblJUZzBoWjZQZjl2aGkyZWc1?=
 =?utf-8?B?SXNMZ0JkYkpjd05tb1FhLzJlSDBjRytvamxTNTZwSXEyV3gwYm5yWXRjY0Zo?=
 =?utf-8?B?ZTQ2UHp0b0lYN05yeTVucExDdGZHRmx0K29FNFJibEtsRnhLMnhuWTEvN24z?=
 =?utf-8?B?d3JwdVY2M25XR1dsTTZkMlRXTEYvVktjQlNITFpzQ2IwakQ5T3hnKzJWTWFU?=
 =?utf-8?Q?9DSAYX?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGZRNHpOTEJ0YzVQVTRKczNIQS80VURPdDFNWjJNNHErTFhhOCtpZkZxQm9U?=
 =?utf-8?B?NGd6OU03ZlRLSmFIRTg2NDBoT0dGWUVUYXRHOUdOK2lyNkp0a0kvd0pKMzFw?=
 =?utf-8?B?UEhwaFl2TzVuYUdrZlZYbmlGMWlZQjZyM1lUSUNnUmVCajNXMHA2eHJka1RQ?=
 =?utf-8?B?VkpvZk5NaEJFVGhRYXhQVUp6c3hNSTBUcmM0Ujlza2JlUFp6aGQrT09CclhP?=
 =?utf-8?B?LzlkZlNFNk9FVys5amRTZVppSXBYUHRwaWtsR2c4SzhCdWxCWHRtYVhhMlpv?=
 =?utf-8?B?Umw4NmtFR2RrYVU5cWRUNjJVREdLSjlUR05KL2ZyZ013UEtFakkyWFJQY0lX?=
 =?utf-8?B?c3pyUTFONDBTYS9aUkE3bkhYM3dwVWhtSEdmWDVQYWNEdGpxQ3d0MVUwMk1n?=
 =?utf-8?B?d01FL1JRU2dtamhZLzMrV3lraFhlZ01ucTRVTnk5RVBmSjRrcnpHY09pbDho?=
 =?utf-8?B?L00rTTY0bmpza1F5WmRYSGhsYzQ1RlZPOWczNStHR2hGbmE5bzdhMjJqNEIz?=
 =?utf-8?B?L1BydTdXZEgyOVBUVDhuTmE0Q2s1WU5EQTBHMHhZRjNFZW82QzFCYzFHeVd5?=
 =?utf-8?B?dmgvVE42czlNYS9pRGZ0SEIzV05BMVVIL0prRmsxQjJ3RHNNd0ZHZXVTNXl4?=
 =?utf-8?B?VzBZa1h4NmdYeVA4d0s5V2JETTRGNUhYQUlGaVdHNWk2ZjNVRTl5Nkt6T2Zy?=
 =?utf-8?B?MTQzSGtjMzlwNVdUNGtxemdlOVFnSW9uaUlpMjNmbFFjRG9KbTEyT3crRWc3?=
 =?utf-8?B?WkFxb0RvUE8zYm05djFGY28wY1NkTDV1ams0bXNoTW83Ukc4elRjREZXRUtv?=
 =?utf-8?B?aWg0RjdwSHE4NlVFZGxuQ21tSTJyM3d5KzBOQU1HMFJsTEtNS2phYldEZ2JH?=
 =?utf-8?B?RHNmZDZSYS9mRDRvUm5FbklNaUdqZE5FM3czQVpoakljNUxzSHJkMGRCcE1G?=
 =?utf-8?B?ZG95MDFsZTJTdnFDOU5WejFvRmlzeFhIYlQwR1RkbmJHcTV4NDF4TkxoNm16?=
 =?utf-8?B?Znd4RVY2QkNsWS81TkRqeW5DMldIOHJHQWc1ODdTTkpQYU14dVFaSy9GYSs4?=
 =?utf-8?B?Z1RnYWR1cDV0OU56NlpHNDN2WFd4Tm9INURZS09rc0lCcnhoSUNCRW9qLzVL?=
 =?utf-8?B?QUJFWFVnTlBHNlBKdmtMSFp3NkpvaHNpcDFkQXVtYU9KMDlISm9Rem1wNDl6?=
 =?utf-8?B?Q2JYZlpLRHJ5RCtVTWlnVkREaFpPVllvdTYvWlpXSlhpRUFkbHBXT1ovTjl3?=
 =?utf-8?B?Y0c2UmtuUzdJcjYzdlFNdkdNNFZlSkZrZDdsRlRIVGZqeGZyK1ppNmNJSUpU?=
 =?utf-8?B?bldvcjhtb2JCVU1Rc0hYdkx5b0dabTVUQ0tKNG84eTV4SXF5bzhRQmJyaUp6?=
 =?utf-8?B?ZDZjYkRSaldFMEk5R3JlUVFNTzVkaW1hYjF6c2FleVVMdmNmaDZmVlF4TVpN?=
 =?utf-8?B?QWtVRmZaNTJDRzZ0eHZ3bnhZWXdUUVc3QkxkZDZDWitNcW1nV2d0VTlYelh4?=
 =?utf-8?B?QmIxSURUSnM2eGdaTGQ2VnhDVG1SaEJMTUovekI3bEN3Ulp2djFPSUhmUENF?=
 =?utf-8?B?Qkw4YWZvMzcrL2Fsb1MrcW5jSkNKMWdkN0RneHNTSXViSVBOM1hIcWVqdnFC?=
 =?utf-8?B?RTZLR1MvQnZ1NFZjTkdxcXBIeEQ5NFFsaWdsbmhtenVVdlVBb3JvZFdmWHZP?=
 =?utf-8?B?aUd5QklBR3pxekd4RFBES0FoRER0M0x5T0tkUFhWNysxMkFrb1FyVi96L2xQ?=
 =?utf-8?B?Vm5lUStqak1GdlB0dlFEUnlJUEJ1S0JUQlFSSEtSMEc2Q1piLzNIWE9jdTNn?=
 =?utf-8?B?MncwOFdDZmp3aTV1K09WUDZMeWxUNUFGV1BWK0xUeGNLSmErc2RmLzFEdnpL?=
 =?utf-8?B?eWwzUTBFakR6VXFHb1VSL0pCSituRk04Nk5QMG53S1JCWndwVVNtcHVEcy9E?=
 =?utf-8?B?TTg3T29qVWpxdTlxYmw4S2hQMzdLYzExcDZyd2N2VGRpcmhkaGxBUHBEYkZM?=
 =?utf-8?B?QmZ3b0ViU01KR0N3MmxkZHBERkk1SnJBbVNNdC9BdDBGNDBwbmV2R1hGaHFi?=
 =?utf-8?B?d2Q2UGRVekJVQi9UUzZ4S2NEQUM2bEs5NS9YYTduSGdzVXJMZVk1MlY0enpi?=
 =?utf-8?B?N1BrQ1NZS1pBZDVzYkxBTHZGeThyZ3dvVDBFS1liRndiVWdkWDVVZHYzd0gv?=
 =?utf-8?B?akE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCD234B7981FEB4FB6B2846CEB7B8B4B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5690a4b-ca3d-4d69-6aab-08de01238c20
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 19:48:51.9096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gXPJX35GKnknCCD2689lVlHrp2G9AKGRLOhC0GzasZr2sSy2GFo4kR8xB3/Yp7/FIgCw/uPGpRC97gYhp2bNYlAxnAARIfd31zG2y52LP2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8303
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTE5IGF0IDEwOjU1ICswMTAwLCBLaXJ5bCBTaHV0c2VtYXUgd3JvdGU6
DQo+ID4gaW5zdGFsbGVkIHVuZGVyIGEgc3BpbiBsb2NrLiBUaGlzIG1lYW5zIHRoYXQgdGhlIG9w
ZXJhdGlvbnMgYXJvdW5kDQo+ID4gaW5zdGFsbGluZyBQQU1UIHBhZ2VzIGZvciB0aGVtIHdpbGwg
bm90IGJlIGFibGUgdG8gYWxsb2NhdGUgcGFnZXMuDQo+ID4gDQo+IA0KPiA+ICtzdGF0aWMgaW5s
aW5lIHN0cnVjdCBwYWdlICpnZXRfdGR4X3ByZWFsbG9jX3BhZ2Uoc3RydWN0IHRkeF9wcmVhbGxv
Yw0KPiA+ICpwcmVhbGxvYykNCj4gPiArew0KPiA+ICsJc3RydWN0IHBhZ2UgKnBhZ2U7DQo+ID4g
Kw0KPiA+ICsJcGFnZSA9IGxpc3RfZmlyc3RfZW50cnlfb3JfbnVsbCgmcHJlYWxsb2MtPnBhZ2Vf
bGlzdCwgc3RydWN0IHBhZ2UsDQo+ID4gbHJ1KTsNCj4gPiArCWlmIChwYWdlKSB7DQo+ID4gKwkJ
bGlzdF9kZWwoJnBhZ2UtPmxydSk7DQo+ID4gKwkJcHJlYWxsb2MtPmNudC0tOw0KPiA+ICsJfQ0K
PiA+ICsNCj4gDQo+IEZvciBwcmVhbGxvYy0+Y250ID09IDAsIGt2bV9tbXVfbWVtb3J5X2NhY2hl
X2FsbG9jKCkgZG9lcyBhbGxvY2F0aW9uDQo+IHdpdGggR0ZQX0FUT01JQyBhZnRlciBXQVJOKCku
DQo+IA0KPiBEbyB3ZSB3YW50IHRoZSBzYW1lIGhlcmU/DQoNClVoaCwgaG1tLiBJJ2QgaG9wZSB0
byBrZWVwIGl0IGFzIHNpbXBsZSBhcyBwb3NzaWJsZSwgYnV0IEkgc3VwcG9zZSB0aGF0IHRoaXMg
aXMNCmEgcmVncmVzc2lvbiBmcm9tIHRoZSBjdXJyZW50IHVwc3RyZWFtIGxldmVsIG9mIHNhZmV0
eS4gSSdsbCBhZGQgaXQuDQo=

