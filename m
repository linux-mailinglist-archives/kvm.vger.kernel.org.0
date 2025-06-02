Return-Path: <kvm+bounces-48230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26C5AACBDBE
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46D131882FE1
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 23:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486F920D4E1;
	Mon,  2 Jun 2025 23:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CUHIsws0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC3F18B47C;
	Mon,  2 Jun 2025 23:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748907855; cv=fail; b=qf6NUwGsiHFqezmnDZqHhEOyd5BLQxWBoFLiL10wmFCz00Do0TQutsK2k75Ou635JV8F5femiqWq0QoOfyECsAZctx56Lkl2bEtvlu15F9ODXb6pnUS46IbnE70gGOxTNePnl8U0Oy5Waq7hKgklIcA1zvM4M4/ASvS2Z7FruZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748907855; c=relaxed/simple;
	bh=k9htidvcpH6k6nFXqeP2QuIlJ46A0/ldxT8oaewSj4Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UuU79Aa5X7XVevxlPkxKqxp8ygBU1ppLStAhWRlEZmARHTvFLdtcMmwssMj3pUbgLvunlbG016NlxAHJtQ5NqTfc/inyhmnER0tmFku0e7WVNAhrckAf7hriQ/e6ziYc54MJJFJ7a37gNrq2Iss8oPygZ/Ea6/AsllKopE8+ZhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CUHIsws0; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748907854; x=1780443854;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=k9htidvcpH6k6nFXqeP2QuIlJ46A0/ldxT8oaewSj4Q=;
  b=CUHIsws0v7/AhGEQrNFyCguiMDCAygHPvoJ/O0Ro3yIKjYT8zG6mp1QI
   iXju5XA4gtin6HdKI4dwLQbUNIVEWCgSKp6HbmcSYma1skhDvQLKd5qZQ
   AEYS4sjQvfdkChihlAgsjVFouWd75WSAYSVyuJmxk+RJGFK55DEG5pvoc
   K7idaSiWnSxzyLDD/ep42sjhcCzSBp1sq4jBdqTALcFysyWFOi+P+HOYI
   2PKBpndFAzS6AC+DtIwqLAgQ4ZpLg5AgvhJLgzkmbUztHRXvesLOcaIhx
   uBfnZvb/ElK1Do4lfVsV6LNEj9BsGCuH9TJTMUT4ypO+a2a4phorih/rE
   Q==;
X-CSE-ConnectionGUID: mnci3oVNRbO/7INy+VUehw==
X-CSE-MsgGUID: 3LtPigrqTW201Wd15+5H/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="50846564"
X-IronPort-AV: E=Sophos;i="6.16,204,1744095600"; 
   d="scan'208";a="50846564"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 16:44:13 -0700
X-CSE-ConnectionGUID: /BEg+tk+SM2qyNGhQyo1KA==
X-CSE-MsgGUID: D/4xpwuyR3u/8JQplRAwug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,204,1744095600"; 
   d="scan'208";a="145610963"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 16:44:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 2 Jun 2025 16:44:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 2 Jun 2025 16:44:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.51)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 2 Jun 2025 16:44:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mCQAqIHnhOy9MzQlUBJVaJpioT7I3sXmvSFkvHZpr6hdV5Rzs3eDma6MJAoH82WoqyzAOOj0VwXZNQEdD9YeKpJ7fkCK2DBD02+pSf9zgGKepkc9MecreKccwT2NdyY4sruj6yTwFTiEeZQet8dxxX6lsWos2vjWNY1Y30HqPEBqJwyC9LB/dDGb4oj3wFVvpIyzvg9A8BNhH04QsigZ/WfYz56qL2KmfhVLAqkZ31xC+wZ5a2MvVbz34hoOsYCfnK0DcgwMyh7g8zkqVCYXslFM8wvWcv2x/OTGk0LG0aWrhVPCD/OO8+4HaYmvORGoPVHT0eF3iJ1TnM5Dvhynvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9htidvcpH6k6nFXqeP2QuIlJ46A0/ldxT8oaewSj4Q=;
 b=caDcm7Xnnrct36VLglW976mmWDt2EFTsb7gkZzMZxoRKW+vXi3rZSF8o9gvGiyyCG2zxJ0ql5hs1u4Ch59LwQV4nCqeXPtavVlY939WWhGMR4M5xswKU6yNL4A6SA1hdmap/7f0j81IBw57QbTnGJ96alNq+XeAa+U9aC44yS2tl3rip1adkeAZ+c4SdABYCK7JXQWX5X2zHPbZZx2Q+NRPsxRn3NoUUocgBnFLWYINcJy8hPK8sI/g8aKi8vucFNGtu6gWjwrWS2LcBKIYCUfKXIzjbwcFOjtfS+cE5Zv2ghgjwMOPufn6c68nJzzEWYJZAPVLHsOjpAvYYB3zZQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA4PR11MB9393.namprd11.prod.outlook.com (2603:10b6:208:569::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Mon, 2 Jun
 2025 23:44:08 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8792.034; Mon, 2 Jun 2025
 23:44:08 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Dong, Eddie"
	<eddie.dong@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Reshetova,
 Elena" <elena.reshetova@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 04/20] x86/virt/tdx: Introduce a "tdx" subsystem and
 "tsm" device
Thread-Topic: [RFC PATCH 04/20] x86/virt/tdx: Introduce a "tdx" subsystem and
 "tsm" device
Thread-Index: AQHby8iNcpEmINNxbky66YHmdnh+k7PwmOEA
Date: Mon, 2 Jun 2025 23:44:08 +0000
Message-ID: <61fd680c4e4afd5eb4455ee0dbbb05c30f0e7a0d.camel@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
	 <20250523095322.88774-5-chao.gao@intel.com>
In-Reply-To: <20250523095322.88774-5-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA4PR11MB9393:EE_
x-ms-office365-filtering-correlation-id: cd39c1bc-e9da-43a3-48ad-08dda22f5e38
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NDFtTTJmRkR3QlRGWlJJNE9TVFBDTER2MTVoYjJVRDJYOWh3VE9wSmI4ZkRN?=
 =?utf-8?B?NnZRb1EyYWtpWXY3aUp4YTNYQWRCNWZCcm92Z21yamtlMlo0Q1dCbFFHVDEv?=
 =?utf-8?B?bklybjluYUhqc0U2L2o0NGxwUTFSSnVLVGcwYXFrcGdOSzd4TDFZd1ByT0tE?=
 =?utf-8?B?djM0Um5idU1mTnV5LzNHZmtYSE81ZWlJbVRWWGFwMUlsYW1qZUhNZG9sSXVE?=
 =?utf-8?B?dXVna0FJM0Flcjk1OGo3NHFuYzhIdEVNVGZ0WFAwQ2hzNjh3b0gyNTdZNWRj?=
 =?utf-8?B?dmN3c1FZN3lNS3hBbVplWGFBZUVqQnNtam9MZGljOWdvOG04ZlJITk5scjV5?=
 =?utf-8?B?TEYxUnNqM1FvZExsd1p2RmlzRHAzVVFGSXhYc25LZ1Y2dEFiOHFGOC8vQVJZ?=
 =?utf-8?B?SWJHSCtOb1B3MVppdGY1Z0lVRm5yWHdHMk1rUDRhS0RZVk0zZ2JCeU1LZGli?=
 =?utf-8?B?ampTcHVRL1NuM256N1lyb1cwcUdhRk9EZm9nT0wxRXk0aUdXNzI1TmJqaDFL?=
 =?utf-8?B?T3Z0S0RBYThzaHJGSnY0Y0thY1A5VlhOMEl3KzB5SzJyemhwNzVEVkVXdVIy?=
 =?utf-8?B?UEJMN3YrWXF3dXd4amV1UHNHN3E0MEQwNDZGU1dqaU1iWWZ6ODJkTFZhR1dx?=
 =?utf-8?B?L2pJSkt6cks0ZmtCRjlvdEYyTElZSHFUeG02dDRVL0NmYnY2a2xWbmlzVHJ6?=
 =?utf-8?B?aUlNdjZlRWMzY0xlS21XVWtPMFVOdUMyRFhHMFYreTNuUXZoaXArck9hQ0Ru?=
 =?utf-8?B?LytKYkd3enZhNnI3REJmMzQ4TTF3SjEvSmxLWE1seklKS1M3ajdmMHNkbkxy?=
 =?utf-8?B?SGxBdDlBUHhMTld2cDhNbVpleHlaL05FMXV5T3lOL1Rjd0crZmdSUDRnaWxh?=
 =?utf-8?B?TEdyR0RrWXRaMWp1bWxoZUNOOEhIdzJ2TmZ5dFhRV0tNQXZjNGwvK1I5Z0s0?=
 =?utf-8?B?bVp1TkxJNDN6Y2VqelF3dVVmMDRNSmtDNk5DcTNmOHhsT1dVd1RTWnRncTBw?=
 =?utf-8?B?TERXYThsQzA3L1BIYWlSUUl4UUdlZTVBUDU2RlVSZDZrVWZrQ2U3cjVla0k2?=
 =?utf-8?B?KzNxOFlRK1F0VEQyY3JWL1MxckNRSVJSN1IzRXF0SWg1K29FSVlXeHFzUG50?=
 =?utf-8?B?RE0rMWFhZWJnNlBKZ1NnQzZnOWw3WnF6SGQwVFNxdlh5TFFmREJyUXVuYVR3?=
 =?utf-8?B?NDAvTTZSSWoyZVlMblNxOWxiRDFObjE2YXZVV0dEL2JyTVFKaGlJb21ScEdB?=
 =?utf-8?B?RUlYam9iRkVUZFVHeVJFNklGVk84UnRKWklMd1NCOCtsYUxmSXNMQytEZHdJ?=
 =?utf-8?B?SmFkTWFsU3VxY080dHlEa2M1WkR3SDVzckk5dmluYzlaZ1E3NFI1eHpYN01l?=
 =?utf-8?B?ait1cHZNUEluc2syYnAzS2ZwaTRSczkvVTgzWlpJY0ppaWd0QmlXdW9uWVdx?=
 =?utf-8?B?UXJLd3N5NmNSbVRqSFIya08yb1hjaWt3anRNR1ZMT0VKbjd3L1ZrbGcyaU1L?=
 =?utf-8?B?dFlqdWNOSXp4TncyREdNV3I2WkJ0TExnNFBYSzdoSXJrdEpwZlpxMHV5aDVY?=
 =?utf-8?B?WTBaUDArRmVjNTJxL0ZScFRKdkk2YmZmQzdXM0NpTmY0WE51dWpJQmlNRVh2?=
 =?utf-8?B?Q1BXWVo1S2d5MzY0eWtEREhWRW00MEpCRGFRV0hoNjZqTGw4UTRjZ1k2M0pV?=
 =?utf-8?B?dFh3Wm9SVkxGYWRQbzFNcFRCc3gzSlZ4Zk1ZeG1BbVA5blhQWWVRZ2kyempG?=
 =?utf-8?B?ajU3SHEvRGVGMGtsWDRkQU1iOXBDM08zTE16WTlJMThsNk9VMWRBQ2s4TGo3?=
 =?utf-8?B?STJYZVlzcnR3eS9BcW16YU5YR1hBb2IvMTd3anUyeStkUFA4U3ZteE5HYm50?=
 =?utf-8?B?bDNaV0NwZWtxNSszdlhkaGJ0QWpnK0tzMEM2RXdUUjV0d0VDTFFoN1JUTE9N?=
 =?utf-8?B?SklZendITEVUUWMyU0M1c3JxVUJtcnBLNlhodGQ5K2c5SWd1UFQ3UVZXcEs4?=
 =?utf-8?Q?eKPjbEW+4qEj098z8mCHUyHuamUGT4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amxuOWxwM1drSTNxZHBya3VMODRYdHdETXBFRWo1YWgrYU5EU0dlVzNaQXI1?=
 =?utf-8?B?SzlRWThXdUg2VG5mWXlsMWx5OEVOQVZhZnN6M3NPSi9CWnhZeVpQdVR1eC9p?=
 =?utf-8?B?TW92Z2tBV1h4M1hyM2sybWszU2p4WDlaaXk0Z2cwUE96MER4QU91My9CSTlv?=
 =?utf-8?B?NGVYc2Y0TjZMQVRGajZtamFuaDdiRytWS1V0RjBHNkx2Ukw4ejVOTFRmazN6?=
 =?utf-8?B?MnRRRVNZY0dCSUNRaUJJVnBLY041MC9LaEpFNGhMVFc0TkVJamVnTS9pTDNv?=
 =?utf-8?B?djhQdEpOeFJ6cW1abXM1bGZMcFlLd05jdEJMU1BHQThFaWxMOWtLdlRmaEdQ?=
 =?utf-8?B?V0FFenNUTzQ0WGFVbnJrTTNqWlBXWWN0Uk1kdzA5Q2xyQzh4dldJZVhXVUxt?=
 =?utf-8?B?cW45dVVnSmM1THQ3cytDY3dLcUJsT0hqQ1hLQitTZzd0Ymp2djlLWE4xSGxy?=
 =?utf-8?B?eEdVRzRCMDFqWCszMUd1UXRqUEdrTmM4YTR2NG1zL0VsQk56NDYzLy9ZSU1k?=
 =?utf-8?B?bkpVMDJSTDcwVWp1dEY0L1RqbVRDaEgwck0zRVYwa0JmYjY5VkVBVWJvOTlz?=
 =?utf-8?B?eHdkQkZ0bnBibWJKZnZjV1dHbVZYaDJSY25PVWhEbFhmK0ZxdkJqYWpJb1Bk?=
 =?utf-8?B?VnlERmw4UkVoeUJwdXdIbnYzT1d3RU5ZVkZDZVlkNTlqZHhZYVFvVmlLdkE5?=
 =?utf-8?B?UHRzT0hMSkV5U2RSWE94d0ZISCtxMjE0STFNcFVtbnhudFdnQWladjQyaEpR?=
 =?utf-8?B?Y29KbFNMNWpoTXk0RjFJd01SUERPQnlQc0U3ZEs3NmE3NHlINk00OVIvb1pM?=
 =?utf-8?B?YUEvQmFITEc0KzdCczVhcENqcTU2a09OSlg5L1FvZnhPdDlCSG45TytLbS9X?=
 =?utf-8?B?bFBPcnJxdy80RmZvYlhWdmpIbCtmQnMySVUyNStMUi92RFRPRUVOTkJyWEtx?=
 =?utf-8?B?WUpOanVlUmNHNkJMaFlzRG5Ebkpqa3RIYVJRUGN2YzZuQXM3WEkrZlUzVU1k?=
 =?utf-8?B?NTl6UDNPRldjWEhyQkY4QmIxVTVUT3RadWUvVldOQnVrSk96eFJTV2ZFUGVl?=
 =?utf-8?B?VlgxdEduMld0NGlIS2h2cDAxYm5mVTNpendKZzRSRzhySGhhYVE5cEdNdUYx?=
 =?utf-8?B?QjIxSUVsdVNOOXFOckw4eFFhTUN5NFE4emRKVG55UUNGeHRpcjFnTkIvcDkx?=
 =?utf-8?B?amd5STZkbWVJZ0krdWhENGQraUxDMWprQlIxLzVtOTBvZFBQY0dSOGxHQk5j?=
 =?utf-8?B?WUw5L2MrSVVUMWw0WE9iR0VnN3Z1YzQzdlJwb2J2MWcxclA3cHUwYk1IU05H?=
 =?utf-8?B?dHhFQjZ1MDRVbXZWRGQ3cXBDWXN5cEtDbSszVm1FMkdWSWYzYVhxbm1kWHV3?=
 =?utf-8?B?L2lKN3gzOGoybWVHVWJjbW5VbGl5OGhhRmRVWlNPSWxITndRWFdlb3JiOXJM?=
 =?utf-8?B?YkVXWHA0UzBVMm5sYzdpUXM3RkpqVEkvYnBmT1NnV0VMVW1jUFFSNlJaT2Fy?=
 =?utf-8?B?cXpYdzZyVjdXNHpNNUhibGMxUjVXYWU0ZGJZZTlkdHV1clB3VlN1cFQwM0Yz?=
 =?utf-8?B?U0p4UlBTTVZJNTJ3MTAzVUtzTktUZk5ZbEwzeGgyTXp1M2NiK2ZsTXp5dkts?=
 =?utf-8?B?MHdpVVRMSXhQYWtWZFlJQUp4K1lEMmJtNGZneENaNC8xOC9IaU5ESnF2Z2Qy?=
 =?utf-8?B?eGg0K3ZpM3VvOUhES095UU15TDBSdE5zekdkc0lpMGpDbmhaNUkxdmdXZkgy?=
 =?utf-8?B?OEFQemdmNUttUkE2c1JOdDNzT0RyR1h5QTVNUEgveGkzS1kzZFIrS3ZuUUVp?=
 =?utf-8?B?NG5UQmFwL1FHY1poMXVEN2F0OXlxOGhaeXZGT0ZnRXQwY1IvaXJlT1BseG8r?=
 =?utf-8?B?U1pNaGxDZnF1S3BPQVM4cjY4aXlwazJLN0dUV1h0VndqUGd1NGxwdHBUM2xs?=
 =?utf-8?B?anRPN2VGR0JGOHZ6VGY5ODUvYkNiQU9uMkV3UnNucElGYk5EdFdYVmE0TS9S?=
 =?utf-8?B?dzk5WVhiOGhvNVVRemRnV2tFWmM5VmZ1ZnZYVGF2NlU4dUxHYkFVWjRjNmts?=
 =?utf-8?B?alpTZE1rN3NHaUJ1bmFWOXg4MnluWUY2NVA2NXhpQUVQUm4vcS96Ym9ZQllL?=
 =?utf-8?Q?pQTc1hY5exaWICYhHwO3Ph0An?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <864AF6022885994A959C9DC6FF9F4758@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd39c1bc-e9da-43a3-48ad-08dda22f5e38
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2025 23:44:08.3796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BRfCLhU9IF5VvJriZ68do23/Cz5OBqU/eOZHMzJBT5f/h+lO0L9Cj9wPkelwSaAAfXAvMyBA5PRFFtpAcbxTEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9393
X-OriginatorOrg: intel.com

DQo+ICBzdGF0aWMgaW50IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KPiAgew0KPiAgCWludCByZXQ7
DQo+IEBAIC0xMTM2LDYgKzEyMDksOCBAQCBzdGF0aWMgaW50IGluaXRfdGR4X21vZHVsZSh2b2lk
KQ0KPiAgDQo+ICAJcHJfaW5mbygiJWx1IEtCIGFsbG9jYXRlZCBmb3IgUEFNVFxuIiwgdGRtcnNf
Y291bnRfcGFtdF9rYigmdGR4X3RkbXJfbGlzdCkpOw0KPiAgDQo+ICsJdGR4X3N1YnN5c19pbml0
KCk7DQo+ICsNCj4gIG91dF9wdXRfdGR4bWVtOg0KPiAgCS8qDQo+ICAJICogQHRkeF9tZW1saXN0
IGlzIHdyaXR0ZW4gaGVyZSBhbmQgcmVhZCBhdCBtZW1vcnkgaG90cGx1ZyB0aW1lLg0KDQpUaGUg
ZXJyb3IgaGFuZGxpbmcgb2YgaW5pdF9tb2R1bGVfbW9kdWxlKCkgaXMgYWxyZWFkeSB2ZXJ5IGhl
YXZ5LiAgQWx0aG91Z2gNCnRkeF9zdWJzeXNfaW5pdCgpIGRvZXNuJ3QgcmV0dXJuIGFueSBlcnJv
ciwgSSB3b3VsZCBwcmVmZXIgdG8gcHV0dGluZw0KdGR4X3N1YnN5c19pbml0KCkgdG8gX190ZHhf
ZW5hYmxlKCkgKHRoZSBjYWxsZXIgb2YgaW5pdF90ZHhfbW9kdWxlKCkpIHNvIHRoYXQNCmluaXRf
dGR4X21vZHVsZSgpIGNhbiBqdXN0IGZvY3VzIG9uIGluaXRpYWxpemluZyB0aGUgVERYIG1vZHVs
ZS4NCg==

