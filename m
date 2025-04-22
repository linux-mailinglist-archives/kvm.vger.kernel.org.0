Return-Path: <kvm+bounces-43854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D50BA97AB5
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 00:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0FB25A167A
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 22:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235DA2C2AA2;
	Tue, 22 Apr 2025 22:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QW4DkoA8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEAE1EE7B7;
	Tue, 22 Apr 2025 22:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745362428; cv=fail; b=gMXd9NQNglaHGzjB6FzblD2ohrUWpK3sOu/3JktadedTODiE6YyGswZevf4xEYr5QJM2Lb1lxO/4FyrgF9nTLHNT2EUgBdX3+4OzTeDvGpyp+wnI5qcaEzE8uNJjEqpirh+yINFNTOeEkdEhQa+xFxKFrbMQJOsPDjCEg/ArFqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745362428; c=relaxed/simple;
	bh=awa3mBTZo1R0gl56l9oZRC77v3NdDW92M7fIRbLXg7g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pjiJQIyYzHKMpFege0bc0UgBqlnDA5SE3gg6r7yE05hErxrQpb4KMBD4CNHCe4g66r9E/W1E8TkuHVwFkw9QUIm2YqjFpbl05da5zxu2l/jYE9R7x++mluM1v9+EllKb9nnuWErCDLaous+vJYVknw+HJu/Ugg+FvCMJd3xJe+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QW4DkoA8; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745362426; x=1776898426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=awa3mBTZo1R0gl56l9oZRC77v3NdDW92M7fIRbLXg7g=;
  b=QW4DkoA8ZXMS9DnnvLnGBW5kT9qblo5F4ypf+sR3oEQeMbpkUS/P06O9
   8AI1n9aisqXgf3g8tGeOEJp15US5EHD6s9v+Epzg0wkCIQxpWa03ou7Ee
   zRpGMnGTJy1I/j3Vlunr78fX7npK74OHElDhU75vOnTpuEvrhtLDx9o0j
   J8mMt6GBizqceIl53bvybQordrMWvb6+2esQ5MD01lcm+5BEt+v6M7ALG
   N4TPqjTY4pqw9eZHVkImKef/kzuKogunWbsrSnrkPRW7qxbKKI0Jkq6WG
   ljRSG2QDSGKnKWklYOqtq9KcrrhcVOxfdy1rGCdOUCPmeeU0HRfOkURWf
   g==;
X-CSE-ConnectionGUID: Txy5E/PnRVOa56b/iqcD9g==
X-CSE-MsgGUID: LORNfQInQqqFbFn/NKHf2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="46817031"
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="46817031"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 15:53:44 -0700
X-CSE-ConnectionGUID: 8WQQ/FFESq6phwoVIqpnPA==
X-CSE-MsgGUID: xWAui/R/SdyY6ET1y+w0rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="137007389"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 15:53:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 15:53:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 15:53:41 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 15:53:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nRnIU5ba9frehwsNpLuIcrD3KTpPnoqucECRjK3Gh1XlFIsu8H9EMzqs3TReNxTW3ckX5W5bPB5ysQw8JJNiPM44feQ3bmdkTWm+/G0/GDqrVUE+bPedbOZHYHzfIn6BEnhOCD2uUyw82s9oA5coRsiSizWOoWz7t9IPbFZ07mulHbWkeFlaGwlwI6x19ZO1Hxle3BRbcRnKl9yiFFiMKohpPRuK8hmqcxtP7Jepv1Yhg4Yo2HyEbmxrLC8huR/VkltM0QlHwIQKeaaxgOq4tnMhdTsPETItEqaVQrwLtnO0wUj2qW2d6EGEOy3+CM0istgFdE5LFBLIzChXWzimWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awa3mBTZo1R0gl56l9oZRC77v3NdDW92M7fIRbLXg7g=;
 b=EN2LlMvVOaclCLfY5pyHLLBUWJgjetYXeRMkHABPCYDKqksh9JmlXx3NFbuZec1DoUjFeg//vi5CIyof09dIdMZ1YOgPhLwGMVbOoQ0FEHVkOvtRQTGA3eHM9FEkIs5Aa3gcOVsR34qKovO+JqumAoG7ppcAV1AJRLetNE+iZLj4LSwjsdlJY8SVqktyVLYmUG9Pyo0HoiiIGrvYYMV68bZsMawzMV6hgTYtjd9514/SYHyq9k6ewGYI7lCatU0a0RDLX7OfjMiKgNl51/txV1N88mxaTbhodZke1FQwccgurcqVt1G2q6oP7Qvs6GyZRBbYg/D4c5EZ4wZYS1+elA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB8543.namprd11.prod.outlook.com (2603:10b6:806:3ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 22:53:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 22:53:38 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "vipinsh@google.com" <vipinsh@google.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] KVM: x86: Allocate kvm_vmx/kvm_svm structures
 using kzalloc()
Thread-Topic: [PATCH v2 2/3] KVM: x86: Allocate kvm_vmx/kvm_svm structures
 using kzalloc()
Thread-Index: AQHbox7gNNt5MIEoWkqSWOPujcKUELOms2CAgAALtACAAA40AIAJnzuA
Date: Tue, 22 Apr 2025 22:53:38 +0000
Message-ID: <8a58261a0cc5f7927177178d65b0f0b3fa1f173c.camel@intel.com>
References: <20250401155714.838398-1-seanjc@google.com>
	 <20250401155714.838398-3-seanjc@google.com>
	 <20250416182437.GA963080.vipinsh@google.com>
	 <20250416190630.GA1037529.vipinsh@google.com> <aAALoMbz0IZcKZk4@google.com>
In-Reply-To: <aAALoMbz0IZcKZk4@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB8543:EE_
x-ms-office365-filtering-correlation-id: 679c148f-1283-4244-c4ed-08dd81f08562
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?empia0RONngxbTAwTUZoN1BGSnQ4eWMyaTNIZ0M2dEFWb2d6THhzZEwxV2Zl?=
 =?utf-8?B?L3h1ZE9jeEd1M3h6bzNDa0xxcDRtc3NmOW83alZlY0pZNWVGOWRSUVNUSm05?=
 =?utf-8?B?bXI0RTQ2bjU3SllCdkRLZ21RdVltOFVqWkVuR25EUk9aT0VZVXZBcTFBNTN0?=
 =?utf-8?B?VDV1bTFxaGlGQnY3dEM4UE1GM21kaXVJNWt2SVN2b3B1TTd6MDlqQ3c2SVJV?=
 =?utf-8?B?NlVPNWVONXIxbGdHWm9Rb1dKbmtWMWttVzBRcFB5bi8wN2ozZjA0RnBNTXVG?=
 =?utf-8?B?bEtYbFVCNy9tdW9MdDBsdlo2MnltaFAvNTBZU0NUUDNDa3ZYM1lvYytZREx6?=
 =?utf-8?B?dWtYR2s5ZTQyUXl0bGdBMjEvTlBVU0JxaHNVdmdxSDFQL242TjQvRW9CaEsr?=
 =?utf-8?B?NjR6M1NkZlI1OWhjaVUxS2lkaURseUF5b3ZYWDV4NmVLb0pkTVFGU29FeVZR?=
 =?utf-8?B?THNzWktDZDBLSU9xUnR5dm45QU5LQlNFZEc1M3pMdW9qbzZBcXN3QUR6c2Yz?=
 =?utf-8?B?amsreUlhYkxhaXdpbXhYdU5rK3cxK2pCMVZ1T0MxZy9oM0tWTTVNTjV1bG80?=
 =?utf-8?B?U3FKcitiZjNvREk3djF5ZkwyUlNaaytmN3NRTU5UMGFYTFlaSXkvR21lUVQx?=
 =?utf-8?B?WEZVNkk3SFlJWjNObmJXWUkrM2N5YVFlcGNRd0owcERNQ2FaTy93YzQ5VTYw?=
 =?utf-8?B?YW5HaEFGOGJLUThDYjRLR0xLWThxOEJLTnM4aFIxQ01rUUpnNDVhaXBRZkFa?=
 =?utf-8?B?QVpyc3k5dGVySVYrY3hmYVYvRldpZWd2NHd1T1BPczRVa1pMUDRzY1Zub1NO?=
 =?utf-8?B?YldNa2ttRVZBbWxvdS8zckZYVkdzQ3JTUmJDK1Vuc2RjNytPaCs5L0l1dGtr?=
 =?utf-8?B?ODd5NGNzVnpBMjNCZ0ZJNUY4ZjBQQWVtMm9kUzVnVEhncnRPd2VvWWJoaVRW?=
 =?utf-8?B?SjUwcXVZUmI2UjZZUDZyeDFFeXZUZERPdHlQSEo3VmFlNk4rT0tCOElBSDBD?=
 =?utf-8?B?UlBjMWtWQ1hTYW9EZWhXZHd3ZU0ybUFDeGZWcW03OXpWRTNJN01sNUlHMlUw?=
 =?utf-8?B?YlJPQXJzVysrK2ZpTHdPcW9XMHNQamE1MnYwd3c4aFF5cXpwd3U1U3Jsdmsz?=
 =?utf-8?B?L1RtZzV5ejN5NUEydU15ZEprZjNZWGlRV1o2V01HSk0xc3poZTFOUTdYTFpU?=
 =?utf-8?B?TUpoTlFuWCt3MHgyaWc4UmNNWVVwUHFiTkJ5b3R0NVN2UVZLeVllRjlsaHh4?=
 =?utf-8?B?dTYrTm80RldReXpLMXJoT1NtdUtOcFBPMy90YS9JNlpKVHdiU3ZXVFkrVjBl?=
 =?utf-8?B?OGxTRlh4RWNJUVl6WUJ0dG5FT2RLb3M4Mzl5ODYrQkI1am1HVmJzek5rWm9J?=
 =?utf-8?B?dEJ2NDM0Nk01UitMTEhpa1h0YWt0S3hsOXlBbkxxNFA0c1grTGpnU0VuUlpl?=
 =?utf-8?B?aDBCbU9adWFRbHFBOTV1Rmo1eHBHN0twVmNYZW5NcThuRDlHMFV2eTZmVytC?=
 =?utf-8?B?UEE5bnJqQkI2UWRwakF4RC9nci8vR2tTZ2JwMm9Tc0tIRm5uYlYvdU9rOElP?=
 =?utf-8?B?ZXVJYnRXQU50L1Rxdk5WR3lVMElLTEFKWEhDaFllNFh2Q0RNbFlKS2wxODR6?=
 =?utf-8?B?UFlxaC9EdFZOczhQMEJGYjcvWDVKNTZQcC9kMG80OXJWMnhtVFVMQXdkQjFE?=
 =?utf-8?B?SnRqMnBJdWRRTXJNdTFhVWw4TWFldVlBVjZrSmR4ZmlIMElpU2NId3N3ZnJD?=
 =?utf-8?B?ZjRRMm1iM1RZaFcxUlA1N3BzeXI2bWFvR0pEZGp1aTA3Uk1iVmJXQWEvRGpm?=
 =?utf-8?B?NkJTV0RMSHRaOWQ0NkdMeU5Tb3JDWm81UDdTTHVMNkw1VWJJS1cwK2dQc3pv?=
 =?utf-8?B?d21GNTNJOWhoZEtTdVhlVFpHQkJnWEZGdFVtdVhKV0V6WUVNTlluUE40cjVO?=
 =?utf-8?B?Wm5MZUxiTWxhK0luZHVoT3I0OTJkUGNTVUNMbHFYR3UrcFl3YmlQUWhkOUxv?=
 =?utf-8?Q?wMb0Oh/Co9hOLmB4QwWIdtEfpVlMjg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkVleHhobEFVeVd5M3JyY3F2YUZGblFTL3lFSjlzei9Vb3crUE9aeldOSmpH?=
 =?utf-8?B?dE0rNzdTSGVUQm1jdUFDUlpuYnNqdTQwcFUvMEFtVmJHNnFTTHY4a1FtWnBL?=
 =?utf-8?B?aWVVYWpDNzlUNnJaVXZzK2tUa3g1MkVpYXpDQ3IydFZOSExEaTNZL3I2RktH?=
 =?utf-8?B?elRsVXZEN01icTNXdHh2TURVM3pwcWdDMExMLzdVaTgyeHhUMG1rRFdGcXhS?=
 =?utf-8?B?Z29xRFFKL2NRUEd1NWV6dzJnb2ZXVTlRVWJac0RMc002WTlhM2UwUndPcDgx?=
 =?utf-8?B?U01zdG16QmEzK0d3YXpxdEZ4dWVVY3p5c0NUVnJTR2lleGRmNytPbnBabnp1?=
 =?utf-8?B?YWY4QlZ3d1dnQUtKTTBsOTZpLzJsZUkrbHZHSGNVOEhUZUg4ZkFkUm5UbUF3?=
 =?utf-8?B?MGxDZ0lzd05JUmZuREJoRWtmNTZaZVBvcUlXcWhRekZ3TEwyQ3ZGV0tVeXpu?=
 =?utf-8?B?SGVaQVBpbGE4VnRER2lCZlZaYkczUzhHcGZnclFkQXp2eitGUmxaeVBqblls?=
 =?utf-8?B?ejduQ0NqaHh4dlNkVmhQMHp4Mzg5bkVtRzQyOU11Nlo0VUFXcUwyN0twVGFM?=
 =?utf-8?B?QzRQUzJ6UnN6em9yWGdmTGtQWjgzSjR1VzZRbEltL2FQL2prdjY5bmMzdW01?=
 =?utf-8?B?U09IL0ZFUmk4RldDdERjdHN3dDRKbDdoZnhtbnBPRzE2dTBtS1JMRDlESHdL?=
 =?utf-8?B?WEJUczloTXFDbnhtQ0phM2FKN3QvOUhjemE4S3NWdlVGOW1DM1k5TzlZS3NV?=
 =?utf-8?B?dDZxclNjVDU2S1RocjBpNWI4RDEyVXhxZHlMMnRPTmRLa0NIWkJKNmUwTVRT?=
 =?utf-8?B?YXNNU0plenkxSm11d3VIQnVmRjVST1ZUTnFJT0d4R2Zmdkxxam54cjFNeVZO?=
 =?utf-8?B?SnViZkVXaUxJR3oyazN0SHJ6VHcyaWRuc3d3WVhIZURzVGlzYk9Eb3BKV2dp?=
 =?utf-8?B?d2NzR21hUXFRU3A5NDh0UTNTcHBMOFZyaWZlUXFiUzViMys4ZmFlK01XS0x0?=
 =?utf-8?B?enNHdGFIdnlRUmhtd1AxbmJmNXo4UDMzSlM0dGJFS3ltN2djNCtXS0Z4Zk1a?=
 =?utf-8?B?RmtzMU94WmR5TVp6NDJkNFh5eTM2NlhXWmo4Mm41NHFSNmVydUN2Q2J4T0pp?=
 =?utf-8?B?bUxXY1ZWaDNsWUFyWU9acmVHR2hlTkE4Ujd3N0ZSMjZYL3FRNEtLMHJVWUZO?=
 =?utf-8?B?TVcwaHQxZ055SG9LenpxQnduS3dTWGVnZ29ocCsySlVBeDNNaURKRExwYzN5?=
 =?utf-8?B?eHBQQ3U5VlRGQWJSMS9iUXNKa2h2TlBjU2xIVFZIdDZpR2hEQ3MwWWs0S25k?=
 =?utf-8?B?ejV0ZC9GaXUvajkyOFhmRmx0bkFIMXNKNkIyMTNDWlFHeE52QTN3WXBqR0l2?=
 =?utf-8?B?MkExWWY0dERyR1VKK2xHeEV0WWVja2pscnVzbTBVVWxBS0pnWEYvZFdqc3BC?=
 =?utf-8?B?UHp6aFdWMUFhOUVDTnRyU241eU52WGFMeVNha05UZndHZDNTMW12RWxoY2pO?=
 =?utf-8?B?TmlQbUx2Rk0wcElvbWtqamZZZklhUndCZ2M4MDl6aW5sb0RZei9RR3Jjbk1a?=
 =?utf-8?B?V3pCK3FpK05BNzJoeVZmak1WSHVFMFJQMEdwV2hvMTE4SGZwNXY3N2paTFhr?=
 =?utf-8?B?c3FwNzhFOUs4K1BKN0xKZ0cwWHcycDdQMkhvcTd1TUJwSVpjWGRJMWxrNHpQ?=
 =?utf-8?B?YVlkMVRnWEIydGpnVHBjYnZuWXJFZVp6YjJmUDlMNGJBd2F0U2g4aEdBSnl3?=
 =?utf-8?B?Q3hkWkY0aG9uSCttZXFMSGJEUk52VHdEUHpKekcrL0JSNmZsdkZDRlArMXg4?=
 =?utf-8?B?YWVzNUpHSUI0QngrY081bEpkTml5anlqTWtsWlhHRHlpQmphQTlTQ2FuZ3N5?=
 =?utf-8?B?bmV3bU5iZWg0RjZsOS9rMDF1NUgvU0lEQVg1dERCMUh5NGV3b1BNTFE0WnAw?=
 =?utf-8?B?Y0Nia1lkMWVITENnTitLNGN1WllVV0NKRHkvSlg5VVdVSW95c3BBR21YQ3Qy?=
 =?utf-8?B?WEY5R0Y2VTFBaUdJUGNhMUxVZXJING53anYzR3oralJMQWJnOFUzMWxSSmtr?=
 =?utf-8?B?Qk5rRng0ZTBaQnpRbzUvNlEzWndWMHJZaWZjY2EwREtrVlNvMUQ5amtZUGF2?=
 =?utf-8?Q?SZiF4u6/Sb1XEwXB+jt+dT9dK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8503475E40839A4C8CDDDD5618DAE6DE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 679c148f-1283-4244-c4ed-08dd81f08562
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 22:53:38.6299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VNx/XyK2Dy/qPHlFn7vu68jTFn7O37DrJqv/+32IOodyN1gXry6r+69QgghEpjO40bdJYzErVuC8CivtFpT1mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8543
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA0LTE2IGF0IDEyOjU3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEFwciAxNiwgMjAyNSwgVmlwaW4gU2hhcm1hIHdyb3RlOg0KPiA+IE9u
IDIwMjUtMDQtMTYgMTE6MjQ6MzcsIFZpcGluIFNoYXJtYSB3cm90ZToNCj4gPiA+IE9uIDIwMjUt
MDQtMDEgMDg6NTc6MTMsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiA+ICANCj4g
PiA+ID4gKwlCVUlMRF9CVUdfT04oZ2V0X29yZGVyKHNpemVvZihzdHJ1Y3Qga3ZtX3N2bSkgIT0g
MCkpOw0KPiA+ID4gDQo+ID4gPiBUaGVyZSBpcyBhIHR5cG8gaGVyZS4gSXQgaXMgY2hlY2tpbmcg
c2l6ZW9mKHN0cnVjdCBrdm1fc3ZtKSAhPSAwLCBpbnN0ZWFkDQo+ID4gPiBvZiBjaGVja2luZyBn
ZXRfb3JkZXIoLi4uKSAhPSAwLg0KPiA+ID4gDQo+ID4gPiA+ICAJcmV0dXJuIDA7DQo+ID4gPiA+
ICANCj4gPiA+ID4gIGVycl9rdm1faW5pdDoNCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gPiA+IGluZGV4IGI3
MGVkNzJjMTc4My4uMDEyNjQ4NDJiZjQ1IDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9hcmNoL3g4Ni9r
dm0vdm14L3ZteC5jDQo+ID4gPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiA+
ID4gQEAgLTg3NTUsNiArODc1NSw3IEBAIHN0YXRpYyBpbnQgX19pbml0IHZteF9pbml0KHZvaWQp
DQo+ID4gPiA+ICAJaWYgKHIpDQo+ID4gPiA+ICAJCWdvdG8gZXJyX2t2bV9pbml0Ow0KPiA+ID4g
PiAgDQo+ID4gPiA+ICsJQlVJTERfQlVHX09OKGdldF9vcmRlcihzaXplb2Yoc3RydWN0IGt2bV92
bXgpICE9IDApKTsNCj4gPiA+IA0KPiA+ID4gU2FtZSBhcyBhYm92ZS4NCj4gDQo+IFVnaC4gIFRo
YXQncyB3aGF0IEkgZ2V0IGZvciB2aW9sYXRpbmcgdGhlIGtlcm5lbCdzICJkb24ndCBjaGVjayBm
b3IgJzAnIiBydWxlDQo+IChJIHRob3VnaHQgaXQgd291bGQgbWFrZSB0aGUgY29kZSBtb3JlIHVu
ZGVyc3RhbmRhYmxlKS4gIEJhZCBtZS4NCj4gDQo+ID4gQWZ0ZXIgZml4aW5nIHRoZSB0eXBvIGJ1
aWxkIGlzIGZhaWxpbmcuDQo+ID4gDQo+ID4gQ2hlY2tlZCB2aWEgcGFob2xlLCBzaXplcyBvZiBz
dHJ1Y3QgaGF2ZSByZWR1Y2VkIGJ1dCBzdGlsbCBub3QgdW5kZXIgNGsuDQo+ID4gQWZ0ZXIgYXBw
bHlpbmcgdGhlIHBhdGNoOg0KPiA+IA0KPiA+IHN0cnVjdCBrdm17fSAtIDQxMDQNCj4gPiBzdHJ1
Y3Qga3ZtX3N2bXt9IC0gNDMyMA0KPiA+IHN0cnVjdCBrdm1fdm14e30gLSA0MTI4DQo+ID4gDQo+
ID4gQWxzbywgdGhpcyBCVUlMRF9CVUdfT04oKSBtaWdodCBub3QgYmUgcmVsaWFibGUgdW5sZXNz
IGFsbCBvZiB0aGUgaWZkZWZzDQo+ID4gdW5kZXIga3ZtX1t2bXh8c3ZtXSBhbmQgaXRzIGNoaWxk
cmVuIGFyZSBlbmFibGVkLiBXb24ndCB0aGF0IGJlIGFuDQo+ID4gaXNzdWU/DQo+IA0KPiBUaGF0
J3Mgd2hhdCBidWlsZCBib3RzIChhbmQgdG8gYSBsZXNzZXIgZXh0ZW50LCBtYWludGFpbmVycykg
YXJlIGZvci4gIEFuIGluZGl2aWR1YWwNCj4gZGV2ZWxvcGVyIG1pZ2h0IG1pc3MgYSBwYXJ0aWN1
bGFyIGNvbmZpZywgYnV0IHRoZSBidWlsZCBib3RzIHRoYXQgcnVuIGFsbHllc2NvbmZpZw0KPiB3
aWxsIHZlcnkgcXVpY2tseSBkZXRlY3QgdGhlIGlzc3VlLCBhbmQgdGhlbiB3ZSBmaXggaXQuDQo+
IA0KPiBJIGFsc28gYnVpbGQgd2hhdCBpcyBlZmZlY3RpdmVseSBhbiAiYWxsa3ZtY29uZmlnIiBi
ZWZvcmUgb2ZmaWNpYWxseSBhcHBseWluZw0KPiBhbnl0aGluZywgc28gaW4gZ2VuZXJhbCB0aGlu
Z3MgbGlrZSB0aGlzIHNob3VsZG4ndCBldmVuIG1ha2UgaXQgdG8gdGhlIGJvdHMuDQo+IA0KDQpK
dXN0IHdhbnQgdG8gdW5kZXJzdGFuZCB0aGUgaW50ZW50aW9uIGhlcmU6DQoNCldoYXQgaWYgc29t
ZWRheSBhIGRldmVsb3BlciByZWFsbHkgbmVlZHMgdG8gYWRkIHNvbWUgbmV3IGZpZWxkKHMpIHRv
LCBsZXRzIHNheQ0KJ3N0cnVjdCBrdm1fdm14JywgYW5kIHRoYXQgbWFrZXMgdGhlIHNpemUgZXhj
ZWVkIDRLPw0KDQpXaGF0IHNob3VsZCB0aGUgZGV2ZWxvcGVyIGRvPyAgSXMgaXQgYSBoYXJkIHJl
cXVpcmVtZW50IHRoYXQgdGhlIHNpemUgc2hvdWxkDQpuZXZlciBnbyBiZXlvbmQgNEs/ICBPciwg
c2hvdWxkIHRoZSBhc3NlcnQgb2Ygb3JkZXIgMCBhbGxvY2F0aW9uIGJlIGNoYW5nZWQgdG8NCnRo
ZSBhc3NlcnQgb2Ygb3JkZXIgMSBhbGxvY2F0aW9uPw0K

