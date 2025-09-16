Return-Path: <kvm+bounces-57706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8360B5930B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:12:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 832F73A71D4
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F772F7ACF;
	Tue, 16 Sep 2025 10:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aFGm9ikr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E7B2F747D;
	Tue, 16 Sep 2025 10:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758017532; cv=fail; b=G8vjwwBPvY54IiBGIY6usfgODubyx8LqVvUfVweCM+470UJtnjwJ0tH7y8iGONFzlLYBaDVeZ//9+E4e1rrHNNaIC5l7NeGhU42dWu+P3k8+xuyCEj+TUfvy+MFW07ZhqcQEmn9CHheoDsLfflrsG5SKz2n/QAgJdfVjwpLqhDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758017532; c=relaxed/simple;
	bh=iYSSG24BuMNNef82X3JNgSxc65AdgHLLLYogU23h87o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q2/sFlYhGef3g72xaUfpFEVpwksuy5uy4AmBNnE5c532pNQMS6d/npuZkRJCd2/xSJ4nGjHONor+Z6YiH/jxsPZijl8KXPT+aqM8ddKAvARTai1kJnzcKiH9yYT5tksSjV+HWyUmbfMa5kkh3UGatyHREUQIshUzl6gRT+M/MGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aFGm9ikr; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758017531; x=1789553531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iYSSG24BuMNNef82X3JNgSxc65AdgHLLLYogU23h87o=;
  b=aFGm9ikrkaHQopK4smmobYPn7IPMJueApFt+rdemGu8UJhZKCG0qtGPs
   dn6WvMxguiqb5Yopr45+P0bJGMz3haB5St74a+wZ1DrYYiA1kW5dXNWIg
   Xeuzas2e8MIE6NtUCeo7nqJ7Btju7D0uL0MyWjqKmfWarlIBf28tq5cTj
   llI6LeCzkCs2qXdSN1dbWvH1aF5Bw1L2e7JAKovZRhpgqu0m//Q6MxF6O
   PyiFuo0GPbOyn5h0NelnmGHCrFNdcOsDMg7Daki8bYdYG03zPME+rSRl8
   gkKSQPpuTX6dw43llFA1GAMzVLNhBGW1EO/RTkpzKyOwVAwiy96TYjck3
   w==;
X-CSE-ConnectionGUID: 1xBhUhMgQyeBQG8x2QxH0Q==
X-CSE-MsgGUID: pnEUSZT8Rbu3ZNyynwgphQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="70539725"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="70539725"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 03:12:10 -0700
X-CSE-ConnectionGUID: qaWfI2xjQbOKF7S535H5Ug==
X-CSE-MsgGUID: 3xcAownxQE6DQoeHwiN6bQ==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 03:12:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 03:12:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 16 Sep 2025 03:12:08 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.33) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 03:12:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jycom4/qo5khKD76Xb4MaEfKtT3iU/7a0q5EVEAAMiaV1czU9PZzJwfSuenq2Vy83MBM2jYbAqkkH6F6dSpJ34FIjqgsjtw7iong9It9v2IHQWT8Wc+QvQCbQeyZGyhoimGq2AzLYKLLmnJWhVL3fbIIh9HU2pZymPOW0kK60qVl0lgi5xD1dDVksvVdRNttkVHBSumKw4bR9Y8CX+QGijFQEapJEwKNXeO+Mdjzqu+lf7sBXoRRbX8zPsbq7R28Jbp7hmdsBmgD/tn2K1IQZiyQbLc5KAkG3AFL3P/7jvjwUC53ZW3bIo0PGLURzt7RcpA4iewyxHlh0HualDOWzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYSSG24BuMNNef82X3JNgSxc65AdgHLLLYogU23h87o=;
 b=cZN/vFmrGbbuIgyYJvz5gWeG5tc2m/yoBxVNpzNUPaARpAl6yq2QGtt2ynSB09PgDbxh39opK/M859GrOhp9SR9yfKEy0CoyiKic8HF5VOkHlb6wVLgLMjVeN9PLy2d6Sk5OL58yzNeyBQV7mbhlTtnJnz7Ndv41zdJtZDNkY7IRGS/yRFcdx5qTinpQiW87H7FXM09T+9Xl9kLO7eQ3kTjfMM/xhazHvU9Acj2W/llHEBaVt67MxYgbj0qPXw2Z9Ib6Zj8uMnxl53aJPD2keVl88tWgp37pqwIq82k6577j9p8JXhCLcJhXlxxR/hQR/VsauD8oKLsIr21RPjnKdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by PH8PR11MB6853.namprd11.prod.outlook.com (2603:10b6:510:22e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 10:12:03 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%4]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 10:12:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "hou, wenlong"
	<houwenlong.hwl@antgroup.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] KVM: Disable IRQs in
 kvm_online_cpu()/kvm_offline_cpu()
Thread-Topic: [PATCH v3 1/2] KVM: Disable IRQs in
 kvm_online_cpu()/kvm_offline_cpu()
Thread-Index: AQHcJtEWwfMrjNXOBU28u+iQoEvNcrSVlwwA
Date: Tue, 16 Sep 2025 10:12:03 +0000
Message-ID: <dd4b8286774df98d58b5048e380b10d4de5836af.camel@intel.com>
References: <15fa59ba7f6f849082fb36735e784071539d5ad2.1758002303.git.houwenlong.hwl@antgroup.com>
In-Reply-To: <15fa59ba7f6f849082fb36735e784071539d5ad2.1758002303.git.houwenlong.hwl@antgroup.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|PH8PR11MB6853:EE_
x-ms-office365-filtering-correlation-id: 0db6a9b5-7afc-4bbb-b04b-08ddf5097b93
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bVR2TnpXYzBQc1l3a3h2S0l2T05kenExenFneVFBeTNpMzR1YS9JOEFaWGgx?=
 =?utf-8?B?T3hpR1Y3SEFkSkQyYXZnU0hGZEd5NFQ1bC9wUW9UKzRGS2ZpUmxRRVJwVmlK?=
 =?utf-8?B?OC9rQ2UwT2R4WElYcHZBZXY1ZUpoTWNuWTc4OGdSR1MxUWN2WitPOWc1NjdH?=
 =?utf-8?B?Ly9BdlliOGJob1Jad3dtVklyMm4zQ3pXV1hJRHRaOFArS05tQ3VOZ3FvVXMw?=
 =?utf-8?B?OFNtWUtsQ2dqSVVacFJSejBXQzNaSisrS2ZyVzk1SDgyQkZkK3I2MzFubVQ0?=
 =?utf-8?B?UXBpdnUrVUJWWTdjWHJxOGJnY0haTGM4SlV4TDMweGNFZUw0WWNKUmJ2N1NK?=
 =?utf-8?B?Yk9qMnRuanFCZXg1VENNVXpyZWpiSjRmcENkQUFCRXFmdXVsZkNHeWpZWmlx?=
 =?utf-8?B?ei9PVnQwWE5sWXZidlFwUXE1S3BQL0w2OVZaWkpGd0J6VHRER1dMZ0dJeFZ4?=
 =?utf-8?B?NnlQY21RY0VuN21aNUtSVmEra0ZOYm40MU53MUVtdXMrV3N1YWVSajl1eSti?=
 =?utf-8?B?cnVSL2s0b3UydHNoM3g3ZnhXc1BWQms0bnJGS2gzbEZvN1oyMjZtb0I3cVl4?=
 =?utf-8?B?OEk2SDNiSG5kR3BieUFxVUttdnRIa3N6cGlvcnRMa0lDVTRqbHloUmQ1QXVt?=
 =?utf-8?B?ekNmVlJwQ1JUaEJHTlFmS3ZaZXRTdG1NYjdDQlZ5ZS9LQXNMRmdkc0pidDc1?=
 =?utf-8?B?SnZrOWI1c20wTk41YllNTjhieHAwOWFBaEw2eDNhMUZja1l2aVNJcFZDakJr?=
 =?utf-8?B?REUxNys1cGFKOWxibXRqL3JiK1liMmxCWlVRb01DbVRUMjUxc2RhTENaOTFw?=
 =?utf-8?B?WCt0eVdkY2ZBU1UzQ1QzVGE0dkswVi9WZ2p6cnpWTEwyWDFnb0VFbkJtTUpv?=
 =?utf-8?B?ekVHbW85ZnJLakVlOVptQ1NiSGY5Zkh0Q2tIWk00T25VcndyL1dKVForanlC?=
 =?utf-8?B?SHVKWGZzUVlBWjl2eXYwVWVWVDhjem5pb3h5MXhlc2k2RDBkVDZBbnRDRlY3?=
 =?utf-8?B?YW9YYmFYUmp0WUVEUGtaRWhmaHNZYnExU0NPcERYOTRBWlRFcDNOMjNNZi9R?=
 =?utf-8?B?K0RGRThhek9NRmxGRGY5RjhzWExUZ1JGVGNudlY2ZWdiTnlDZFZrcWY0UnNM?=
 =?utf-8?B?cHhla0YvWFc4NEtYOUREeHNjbHdhMmFqUmpqb1NXT3BKRjhPSHN6TjAzVTd5?=
 =?utf-8?B?eGRmVHFvTXZxQXA3MzV1alYwVFJualRwNkw0L2toZFYyZGdNeGdhYVoxTFFT?=
 =?utf-8?B?UlRKY3NZblZBTzg0VnZYaGZlYStzZlF0K3hFbWFSbHByUVFZNGxyeHM0MnU5?=
 =?utf-8?B?a3pkcTJDeFJLbFlvZVJ5c0JXMDQ5SlpiTm9aTG5NcmgyRXZoR3BBSnFsQXJq?=
 =?utf-8?B?L3JkbHBsTUova3dGRDJwL2EwUllhcHo3dTBlQzFGVWxuNVJpRDV1QWZZVm1j?=
 =?utf-8?B?RWcwcVExU2xVclMrL2s4V1pXNG5aRXJCd2Y0QmZOUkFIL1FVUmZoa0x6eUFN?=
 =?utf-8?B?dTVndUpqeDZRRmlWUERoTzNuMEZXRkRyeU83M0tNMHZ4Zk1BQ2s0VUw3SXFl?=
 =?utf-8?B?UDlmWVZUUHhwdzBOd3JsME9tODBiUnZJUGxsODFlaFBHaXdKZ2E3VFNTMVhH?=
 =?utf-8?B?bXowVE1HU1pLVFFybUFJUU5MTWNHZkdIdXBnT2Z5V2hjY0FjUFFkR2Z6QTVF?=
 =?utf-8?B?cGpvMDc4MnNUTlg2M2FxbUI2WEJqU2UzL0xzT0V3RVd6YXNQU3FmYUhMend2?=
 =?utf-8?B?cXNUTkhSQTBQczRiRDU2YU5PeDNMRzZVeUFYQkpnT01ERnRJRHp4VUlYMlJD?=
 =?utf-8?B?RFhzbEF2Sml4MVNKQ2ZiejNRc1VGT21RT2FwZHlINVFiQkM5YXpMQnlJb3ZM?=
 =?utf-8?B?cklZTHhCVjdqcWVhSDA4dmdlSFZvc1FrUkFWVzFXWm40bE5EQm1ERUU1NmVm?=
 =?utf-8?Q?JkxgVjfHPpw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkZpUEk1QmdsMXVWYVc4K3lPQlg5OGVGbGxvQ2cvdW1iNHJtT3Y0ZnF4ZG5p?=
 =?utf-8?B?c0ZIR3JNb3dyT3JQc2tTdm1rR1l4NG5TSEhtUjlNQlY5aS96anh0U0hmUWl2?=
 =?utf-8?B?KzJrSUdURkFoekRiS1gyQU5CR0hJYmVkYVVqV3BtcnN3ZmxvL1l4aTdlcnlo?=
 =?utf-8?B?TUd4MndSSWt0NkRDSTJWWE1CN093Ukp3N09uaWk2UG5uZmllVUQ4MHFTNlAr?=
 =?utf-8?B?OGtsV1pTdGhETmd1ZXdyMzd0aVNtZm5TL3dRdlNySjYvR3UyNUg3ODcxYXl3?=
 =?utf-8?B?allNaDkzNUc4K0ROYy9xZjVkblZuYlBXVi9WbmVnQTdVc3Qzb3JEK25ISk8y?=
 =?utf-8?B?SzdEYlpMS3ljbTRyaTVnYlN5ckRCaWYxYWFMdzdmMWZoM0ZVQTJyeFg3L3dI?=
 =?utf-8?B?M1o3OXlYMlhFVloyeTZYcTI5OXAxeDd1WG4zNkVIU3AzUnBkSjVpQU5HSFhi?=
 =?utf-8?B?Q0dHQ0VBdXBRVjUwc0w2cHcvcmhreUR6bDdidnZnUHR4dk81MmNhSnQ1UU1C?=
 =?utf-8?B?Ni93dmkyVUs4YUpHbjJ1UzI3NVp5bmxwbWUvOXhZRlVlZEpBQkIvMXFsZ01M?=
 =?utf-8?B?ZC9kOFNLNjNYOVB6WkkxU2pHZUZsU1Q4NC9uSXFrNmtnVmZ0b2g2TnUrbEU5?=
 =?utf-8?B?Z0wrbVZMVzA5MUJrZTNmR3pPNVpKYm04STh1VDF5UWxlRmFGQVhmSVRzVTg0?=
 =?utf-8?B?UlpTOTJGbEx1WUZBNnJCSVZUeGJTYlVFclJYUm5mWmhybkdRMW0xbHhpODZE?=
 =?utf-8?B?WjlCWit6cHlmb1hMNkZNTkEwbXFrVXRwUEU2a3J0NnlWdTJiVzlqUEZOOWJK?=
 =?utf-8?B?b1dnQ01OZGw4d3VPanoyaWpQeENBekNhUm9rTHZiM3RpeENqOVBmdS90R0pt?=
 =?utf-8?B?QjljdkFFcW9XcjYyZGNqdVdKenBVdHVQRFpyOUsvb0JFNzBTS2t3T3FCNHQ5?=
 =?utf-8?B?MXRqelVURm1uSmc0Sk5ZYjB2bXh3NHVKZW1EQjczNmlUSDk2azBzb0IxalVu?=
 =?utf-8?B?MGZUay9Cc1dHSnJPUUFRRlFhcllpTisrV0EzOC9zNkMzNzM1VVRUb1QxZCtv?=
 =?utf-8?B?cWRGRmhpYVdPVi90dHhiOXRLQytHSzljKzhnRXE0UjF1MXVTTWlNVmJWYXBV?=
 =?utf-8?B?VnJKOExMMVRjUXorR3p5eXZEYTZTMWVTYUxPSXhGOFlsN01QTzFtV2kwM0g2?=
 =?utf-8?B?eTd3OEQ0TCt3ZWFwV244UmZkRTZRVWVXRWRtcGV0c0krN2dFMFJkZGZWRys1?=
 =?utf-8?B?QWdHOXNuRExzOXhQUVpmeW8vSXFpM1Jjd2g5V0VLNDlWbERzKzZ5M0t0ditI?=
 =?utf-8?B?U25lclpoWG9SbjlGMkc0bTNGTlIzZmwyclVQWVNiZmFSQTZhMlBIdFRQQW1C?=
 =?utf-8?B?TlJoTThoTEd5TVBFZm8wNjRqa05naEtKa2NuNzBzU1pLL3dKNEx3RkN0U0dx?=
 =?utf-8?B?UG9JZktwNXlHVnhQcWVORndTQUVpczJhQ1FieUkrMVZ4aFdGekpGU09zWWpi?=
 =?utf-8?B?L3RCTFhPZDd6OHpUcVFoMmdSUlp4LzJzYU9YWStBTDRobzFmM0xnQXpxRDVw?=
 =?utf-8?B?THA5Y3pRbG03Y0o3NnJPZHJqQ0NRampXbzMyMEJTMGsrRDFmakdXYitvejh6?=
 =?utf-8?B?ZUhiVTAvNTdiVFRsL3J1Vjh1a1cvS2VyM3NaZ3BkVnBteEZZM1gvMzhTS0xz?=
 =?utf-8?B?RmJtSWlGUTQ1UkN4MVF3Y2lDdUVqdk92aGx4UEYxOUxUZlZTMzRFL3I1OG1G?=
 =?utf-8?B?aFY0aW5BUkVXKzlTT2xkdFRMTUlxOWM4ZVZ4bjNzRjI3b3dndDNLUVR3ME43?=
 =?utf-8?B?WnFRK25YZ0FkQzQrSDVieHlyNkdiYjlrV1NPcU5TQ2xZL2kva0dIYVJKMVRC?=
 =?utf-8?B?R1hzVWxSYm44eVorSm9NVXovMzdtL2p6ME5OU2E1S0lISmNVd0VEVDlyN1JI?=
 =?utf-8?B?S1VKNncwRDc3KysvaFE4cVViZHBkUUc1clZPRnJsUTBwandVbmR5K2tiamhG?=
 =?utf-8?B?dkt6UmJ0N3dHWU4wSXNNVzhHK29FL0xVNWpyWjA1dTBhVjY0YTh0cVNwMG1X?=
 =?utf-8?B?TzNKM3FpVXdaUE5PbitGblJ1dnNFMDRSWXFEeXFNRmdvVmluZUJqakdHc1Nw?=
 =?utf-8?Q?ihCmK1/zQF426pqaAS0VedR0m?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66741D0C8784B348B6D8E1FF09A1335F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db6a9b5-7afc-4bbb-b04b-08ddf5097b93
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2025 10:12:03.2934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ciIgunkeG5rZevHGF+2+WSX/z4xQh1Nf/mrW692imI62wUTnS+OTel5rQZkJVsjUKJbA1A6iOmlgYaEO0MTV3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6853
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTE2IGF0IDE0OjA3ICswODAwLCBIb3UgV2VubG9uZyB3cm90ZToNCj4g
QWZ0ZXIgdGhlIGNvbW1pdCBhYWYxMmE3YjQzMjMgKCJLVk06IFJlbmFtZSBhbmQgbW92ZQ0KPiBD
UFVIUF9BUF9LVk1fU1RBUlRJTkcgdG8gT05MSU5FIHNlY3Rpb24iKSwgS1ZNJ3MgaG90cGx1ZyBj
YWxsYmFja3MgaGF2ZQ0KPiBiZWVuIG1vdmVkIGludG8gdGhlIE9OTElORSBzZWN0aW9uLCB3aGVy
ZSBJUlFzIGFuZCBwcmVlbXB0aW9uIGFyZQ0KPiBlbmFibGVkIGFjY29yZGluZyB0byB0aGUgZG9j
dW1lbnRhdGlvbi4gSG93ZXZlciwgaWYgSVJRcyBhcmUgbm90DQo+IGd1YXJhbnRlZWQgdG8gYmUg
ZGlzYWJsZWQsIGl0IGNvdWxkIHRoZW9yZXRpY2FsbHkgYmUgYSBidWcsIGJlY2F1c2UNCj4gdmly
dHVhbGl6YXRpb25fZW5hYmxlZCBtYXkgYmUgc3RhbGUgKHdpdGggcmVzcGVjdCB0byB0aGUgYWN0
dWFsIHN0YXRlIG9mDQo+IHRoZSBoYXJkd2FyZSkgd2hlbiByZWFkIGZyb20gSVJRIGNvbnRleHQs
IG1ha2luZyB0aGUgY2FsbGJhY2sNCj4gcG90ZW50aWFsbHkgcmVlbnRyYW50LiBUaGVyZWZvcmUs
IGRpc2FibGUgSVJRcyBpbiBrdm1fb25saW5lX2NwdSgpIGFuZA0KPiBrdm1fb2ZmbGluZV9jcHUo
KSB0byBlbnN1cmUgdGhhdCBhbGwgcGF0aHMgZm9yDQo+IGt2bV9lbmFibGVfdmlydHVhbGl6YXRp
b25fY3B1KCkgYW5kIGt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uX2NwdSgpIGFyZQ0KPiBpbiBh
biBJUlEtZGlzYWJsZWQgc3RhdGUuDQoNClJlYWRpbmcgdGhlIHYxIHRocmVhZCBbKl0sIElJVUMg
dGhlICJ2aXJ0dWFsaXphdGlvbl9lbmFibGVkIGJlaW5nIHN0YWxlDQp3aGVuIHJlYWQgZnJvbSBJ
UlEgY29udGV4dCIgaXMgcmVmZXJyaW5nIHRvIHRoZSBjYXNlIHdoZXJlDQprdm1fZGlzYWJsZV92
aXJ0dWFsaXphdGlvbl9jcHUoKSBnb3QgaW50ZXJydXB0ZWQgYnkgSVJRIGFuZCByZS1lbnRlcmVk
Lg0KDQpCdXQgSUlVQyB0aGlzIHNob3VsZG4ndCBoYXBwZW4uICBJZiBJIGFtIG5vdCBtaXNzaW5n
IGFueXRoaW5nLCB0aGUNCnN5c2NvcmVfc2h1dGRvd24oKSAoZnJvbSB3aGljaCBLVk0gc2VuZHMg
SVJRIHRvIGNhbGwNCmt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uX2NwdSgpKSBpcyBhbHdheXMg
Y2FsbGVkIGFmdGVyDQptaWdyYXRlX3RvX3JlYm9vdF9jcHUoKSwgd2hpY2ggaW50ZXJuYWxseSB3
YWl0cyBmb3IgY3VycmVudGx5IHJ1bm5pbmcgQ1BVDQpob3RwbHVnIHRvIGNvbXBsZXRlIChpZiBh
bnkpIGFuZCBkaXNhYmxlcyBmdXR1cmUgQ1BVIGhvdHBsdWcuICBUaGVyZWZvcmUNCml0IHNob3Vs
ZG4ndCBiZSBwb3NzaWJsZSB0aGF0IGt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uX2NwdSgpIGNv
dWxkIGJlDQppbnRlcnJ1cHRlZCBhbmQgcmUtZW50ZXJlZCB2aWEgSVJRLg0KDQpJIGRvbid0IG9w
cG9zZSB0aGlzIGNvZGUgY2hhbmdlLCBidXQgSSB0aGluayB0aGlzIHNob3VsZCBzb21laG93DQpk
b2N1bWVudGVkIGluIHRoZSBjaGFuZ2Vsb2csIGlmIEkgYW0gbm90IG1pc3NpbmcgYW55dGhpbmc/
DQoNClsqXTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2FNaXJ2bzlYbHk1ZlZtYllAZ29v
Z2xlLmNvbS8NCj4gDQo+IFN1Z2dlc3RlZC1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbmpj
QGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEhvdSBXZW5sb25nIDxob3V3ZW5sb25nLmh3
bEBhbnRncm91cC5jb20+DQo+IC0tLQ0KPiAgdmlydC9rdm0va3ZtX21haW4uYyB8IDEwICsrKysr
KysrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0va3ZtX21haW4uYyBiL3ZpcnQva3ZtL2t2bV9t
YWluLmMNCj4gaW5kZXggMThmMjllZjkzNTQzLi5jZjhkZGRlZWQzN2UgMTAwNjQ0DQo+IC0tLSBh
L3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gKysrIGIvdmlydC9rdm0va3ZtX21haW4uYw0KPiBAQCAt
NTU4MCw2ICs1NTgwLDggQEAgX193ZWFrIHZvaWQga3ZtX2FyY2hfZGlzYWJsZV92aXJ0dWFsaXph
dGlvbih2b2lkKQ0KPiAgDQo+ICBzdGF0aWMgaW50IGt2bV9lbmFibGVfdmlydHVhbGl6YXRpb25f
Y3B1KHZvaWQpDQo+ICB7DQo+ICsJbG9ja2RlcF9hc3NlcnRfaXJxc19kaXNhYmxlZCgpOw0KPiAr
DQo+ICAJaWYgKF9fdGhpc19jcHVfcmVhZCh2aXJ0dWFsaXphdGlvbl9lbmFibGVkKSkNCj4gIAkJ
cmV0dXJuIDA7DQo+ICANCj4gQEAgLTU1OTUsNiArNTU5Nyw4IEBAIHN0YXRpYyBpbnQga3ZtX2Vu
YWJsZV92aXJ0dWFsaXphdGlvbl9jcHUodm9pZCkNCj4gIA0KPiAgc3RhdGljIGludCBrdm1fb25s
aW5lX2NwdSh1bnNpZ25lZCBpbnQgY3B1KQ0KPiAgew0KPiArCWd1YXJkKGlycXNhdmUpKCk7DQo+
ICsNCj4gIAkvKg0KPiAgCSAqIEFib3J0IHRoZSBDUFUgb25saW5lIHByb2Nlc3MgaWYgaGFyZHdh
cmUgdmlydHVhbGl6YXRpb24gY2Fubm90DQo+ICAJICogYmUgZW5hYmxlZC4gT3RoZXJ3aXNlIHJ1
bm5pbmcgVk1zIHdvdWxkIGVuY291bnRlciB1bnJlY292ZXJhYmxlDQo+IEBAIC01NjA1LDYgKzU2
MDksOCBAQCBzdGF0aWMgaW50IGt2bV9vbmxpbmVfY3B1KHVuc2lnbmVkIGludCBjcHUpDQo+ICAN
Cj4gIHN0YXRpYyB2b2lkIGt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uX2NwdSh2b2lkICppZ24p
DQo+ICB7DQo+ICsJbG9ja2RlcF9hc3NlcnRfaXJxc19kaXNhYmxlZCgpOw0KPiArDQo+ICAJaWYg
KCFfX3RoaXNfY3B1X3JlYWQodmlydHVhbGl6YXRpb25fZW5hYmxlZCkpDQo+ICAJCXJldHVybjsN
Cj4gIA0KPiBAQCAtNTYxNSw2ICs1NjIxLDggQEAgc3RhdGljIHZvaWQga3ZtX2Rpc2FibGVfdmly
dHVhbGl6YXRpb25fY3B1KHZvaWQgKmlnbikNCj4gIA0KPiAgc3RhdGljIGludCBrdm1fb2ZmbGlu
ZV9jcHUodW5zaWduZWQgaW50IGNwdSkNCj4gIHsNCj4gKwlndWFyZChpcnFzYXZlKSgpOw0KPiAr
DQo+ICAJa3ZtX2Rpc2FibGVfdmlydHVhbGl6YXRpb25fY3B1KE5VTEwpOw0KPiAgCXJldHVybiAw
Ow0KPiAgfQ0KPiBAQCAtNTY0OCw3ICs1NjU2LDYgQEAgc3RhdGljIGludCBrdm1fc3VzcGVuZCh2
b2lkKQ0KPiAgCSAqIGRyb3BwZWQgYWxsIGxvY2tzICh1c2Vyc3BhY2UgdGFza3MgYXJlIGZyb3pl
biB2aWEgYSBmYWtlIHNpZ25hbCkuDQo+ICAJICovDQo+ICAJbG9ja2RlcF9hc3NlcnRfbm90X2hl
bGQoJmt2bV91c2FnZV9sb2NrKTsNCj4gLQlsb2NrZGVwX2Fzc2VydF9pcnFzX2Rpc2FibGVkKCk7
DQo+ICANCj4gIAlrdm1fZGlzYWJsZV92aXJ0dWFsaXphdGlvbl9jcHUoTlVMTCk7DQo+ICAJcmV0
dXJuIDA7DQo+IEBAIC01NjU3LDcgKzU2NjQsNiBAQCBzdGF0aWMgaW50IGt2bV9zdXNwZW5kKHZv
aWQpDQo+ICBzdGF0aWMgdm9pZCBrdm1fcmVzdW1lKHZvaWQpDQo+ICB7DQo+ICAJbG9ja2RlcF9h
c3NlcnRfbm90X2hlbGQoJmt2bV91c2FnZV9sb2NrKTsNCj4gLQlsb2NrZGVwX2Fzc2VydF9pcnFz
X2Rpc2FibGVkKCk7DQo+ICANCj4gIAlXQVJOX09OX09OQ0Uoa3ZtX2VuYWJsZV92aXJ0dWFsaXph
dGlvbl9jcHUoKSk7DQo+ICB9DQo+IA0KPiBiYXNlLWNvbW1pdDogYTZhZDU0MTM3YWY5MjUzNWNm
ZTMyZTE5ZTVmM2JjMWJiN2RiZDM4Mw0K

