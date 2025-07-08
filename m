Return-Path: <kvm+bounces-51826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09106AFDB75
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 00:59:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B2D77A7BB1
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 22:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164A622FE02;
	Tue,  8 Jul 2025 22:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JqTLmT+g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48FD21480B
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 22:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752015563; cv=fail; b=ClZx+RmYgMV5fVCPifp2YjgZLvvgTiEJx/IKYsXra4Hc7+HRoJoUJ0Yh2jbcQ32ntJnyklViMJqnO3thqjRXWuyq1pPgk4r2EL/2z4fPnzKo+MyTl3I7KPabhQHo6P5mufjSrdgRNXoECH0FzuGoL3sPZNwLmbqRp6Ossll18NY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752015563; c=relaxed/simple;
	bh=M+hjQVtIb9k5Gs3uG14baGttBVoRRq9zXvlbd5tdxuQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GQzbuq6+q7H7IGb4LAgJ1809mla72JtB1Wh8Rk19/JARpcTmcytMNROS2C8YresUXDqcs+n4lip2SlUA0Qc7j16OssbJ0tWtDzTubBkWkLpLt2fHrYkHVpavDv7limjKnAE9DofaUHCuqfhHbu7YZ9M/5YMJT5IP5cVegqkJqRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JqTLmT+g; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752015561; x=1783551561;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=M+hjQVtIb9k5Gs3uG14baGttBVoRRq9zXvlbd5tdxuQ=;
  b=JqTLmT+gM23zdN96FgD/TyR+WZkfMpsxwuJxty0Lf4BWvVJc1ZHalSPY
   6gqo173nClLLrhDWX9YG8Uyiwve6nvm8QqjI0/biwOpQdh3//tNFUMkiJ
   bvX5DOEI5uCYo/1OqT5325R3KnmioeGLVtwdLkkm39uhtnOJDRgtpA3q1
   I1XfuhdSbEnYoVx3VLjHmjFvbQPOx90QDfih67PDDhsZ+un5917GUPx/h
   XZdxYFKsaDNJ1TfiYohiiQXNABNtIU7Pui7ZV2usPLZRYibFG3OtDGX0I
   Ya868DifXAXACFJBPtOsCQjseL2pNyh6z7gL3/L56YAuhLVgPNTE3vpp9
   A==;
X-CSE-ConnectionGUID: /eUBoxelSwy9Vhh+pg+BrA==
X-CSE-MsgGUID: c8M0HXtqRuuQ3XSLMWmhdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54360825"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54360825"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 15:56:31 -0700
X-CSE-ConnectionGUID: KE7jq13uSl+x02iixTY3Ig==
X-CSE-MsgGUID: c4KAUEF6T3a/vWcNh6SxrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="192798999"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 15:56:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 15:56:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 15:56:30 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 15:56:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s2LDk8LtA15xMTbYUk04zgQeac5SZoUqwYDhx7jJXUul8lw8bhH9AX3cxYU3ZPo98sbF/pwDG6/TcpIuNxxdjZhncLxzVQZ36FBCsufz0SXPkoeCLp7sQSYhG3ugSKLXwpD2Kn9tFyrRGqu35GrzmT5IKRsN4bHrmMtXcqzkJFtP6DZmIx2ilELoTU5CZkVtW+SBc1/PpQwmndx/KkdkOkblDh7Xj+fkkLo3DHZzUgo3P+iUPbIP/jxasyKEfa7P/VwrP7GnJLxYBxbde4zOUmZu9JqAI03/KbqVjmEB6C5xP5HiQYFOtFeZZcQ4TbJ9CARqTXnhzoeUeP8WZHu89w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+hjQVtIb9k5Gs3uG14baGttBVoRRq9zXvlbd5tdxuQ=;
 b=Q0IkBToY4Eibl8+GIs8d31DW9D2wzNeiEjvs/rD3TxaQTpBIrkxp4n3UId6HVKRdSBEOWoTlre0iTuDLW3fwJ9fCoMpq24/9bPkY/XyJsc44BSnnrOish2JMaGq58QrN8NxjRz5X74zeEoTRhx4Cb97OvJ20K2662v97qft8mG5Rp3buPVewz1XKhbGjCT78lvfZ3SqPP7QzVlKrzjX+kfYcXX0cbKxcC2vmEpNyjK1Dy775aM8qVv4yO1U4LncxNGmiQDvP3+b3sFgQ43R1Neb0K9CxPYpdPuo80TSFBxXIe+ipyh2qW/h17Cqk8snSXJMoQNEMVwVsYM/opcIEcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB7038.namprd11.prod.outlook.com (2603:10b6:806:2b3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Tue, 8 Jul
 2025 22:56:09 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 22:56:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "bp@alien8.de" <bp@alien8.de>, "vaishali.thakkar@suse.com"
	<vaishali.thakkar@suse.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"nikunj@amd.com" <nikunj@amd.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Topic: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Index: AQHb7yd7VfkdP/oV20S9Gj+gph7qB7Qnf8YAgABSdACAADxpgIAAQBiAgACJ7wA=
Date: Tue, 8 Jul 2025 22:56:09 +0000
Message-ID: <13feda96f84da526b14c4ff48d41626b827140fb.camel@intel.com>
References: <20250707101029.927906-1-nikunj@amd.com>
	 <20250707101029.927906-3-nikunj@amd.com>
	 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
	 <cf03633c-63ba-40b7-abd1-8cbeb4daadd9@intel.com>
	 <d8a30e490c50956a358887a3d018a9b86df91fd0.camel@intel.com>
	 <aG0uUdY6QPnit6my@google.com>
In-Reply-To: <aG0uUdY6QPnit6my@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB7038:EE_
x-ms-office365-filtering-correlation-id: c940244b-9fd1-4c57-3f73-08ddbe72a0de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RHdRSlMxNUFSSnNsTUN4bWxHS2tqVjlsM0ZjRGtNdzB0a1F0UWlEeGxtemhV?=
 =?utf-8?B?SzJBckcxUWdHL3VhTzI0RlZ3OTM1dWI5WmRNOFZPYUlRRkZMRGVnSm5lREQ4?=
 =?utf-8?B?TmtJaVpMa0FNY2c3b1hSb2dZRnVkOHZlOFMwZllGUG5ReTZESWQwYWVKdTNG?=
 =?utf-8?B?Uk5CdW5mSVkrSHNLQmRkRllYZlNCTko1M1dWK1FOWnlQUVh0d2FLZ3ZYWnQv?=
 =?utf-8?B?OHYreXBwdkR3RHo5TTRxSXJxYVRoSVduSXFYYjZDZUlZbmF0a1RhOHZsNytp?=
 =?utf-8?B?VzR5Q01PcCtpT2VRL0F6K2dwZ3BnTFV1RGNSOTIzaTdsYjcrOExVb3Uxb0N3?=
 =?utf-8?B?cDNmNkh1azFUSVcvVzhheUR6cGI0MWNMcjhHcGkvd3Y4OXVNcmxNc0V3bTZp?=
 =?utf-8?B?a2hvbGZyRnNUbjdySXZSZG9mellBeUhzeUc1TlJsMkZqZjJ3cVpUUEo3Z3ZP?=
 =?utf-8?B?K2tBVU9UeUFSY0hPUEpuQTl5ZldTZmxOMGo2bEtsd3cwQy8vYXZJTThWVXdx?=
 =?utf-8?B?NVVBUHByQ1czN3JtOW9UUEx2NGJpMXFZdG0vZWxrWHo3UFJYUlpNM2VSdFF6?=
 =?utf-8?B?RkZEZ0l2eFNQa095RmdoWnBXUk1BcUlwdU1pME90WGFTaDBVR1dyT2p6RmpK?=
 =?utf-8?B?ZEd5eG13OHU5M1JEMGFpamtmb2pjbnpkNk9VQTJxeVFkZWh2ajYyVHNsTlNy?=
 =?utf-8?B?TUh6cVJTdjNMcm42c0pJODJhTVRNblNmeTdRUnNlZThqUlQ4Q3lUUC9PTmJY?=
 =?utf-8?B?WllHcUxqQWk0ckJCbWNlbEtndUVvTXF4NG1oUUtzWU5jMER0eUhVNjh5dGRk?=
 =?utf-8?B?NjNGS01uWDgvNnZabUEyUHVYaDFKRUIvZW9lemN3ZnVlVmNpdTRCMjlPSm9z?=
 =?utf-8?B?eEx2QVpISFd2VXE3eEl6cStRcUJGMjhFdEFNSHgzQTEzMEQwY1JsVDlzYldz?=
 =?utf-8?B?ZDZrWmMwYkdkL2dZVU9mZTk4WXpoZi9uREkvejlOZEFNekZIRGZwN2dpVy9Z?=
 =?utf-8?B?TFpKU3FYcWFoZmpROUJTQjBxUXhlT1FrdFlDTXJnQUNZUHZQcUdEMDFlR1hE?=
 =?utf-8?B?aWtmaVRJVTcyYWxsY2VVQUhYelVvYnNaM2l3U2s2MHRTYWkwUGVFYlJubXhL?=
 =?utf-8?B?REpaMEoxN2pNZFZKOEw3NkZRTVUvMmk5V2pwSVV5bDZFcWJvQnlRRC90L3Er?=
 =?utf-8?B?aHNnR0NudEFKUUVneDVlNzJSbk9zdlhldmhyZmIzbEVXSHlWczZtdTBkTWk0?=
 =?utf-8?B?Vy9JWHlMN0xuQXc3Nnd1WDE0QlpyOXJ4aHRBZDRObHhTUXI3ZnQxUkNJTTd4?=
 =?utf-8?B?S0FSQ3d2bjBLQUJsa0puNXgrQ0FOZW1YZ1ZoVzMvYW1PMG40THpIMHFtd0xR?=
 =?utf-8?B?U2ZpazdtOS8ySC9VS0xGQjYwWmt3SU5KUGdrRFpFMzNaTFVmRmU4TUx3YnRQ?=
 =?utf-8?B?eVV6L0FVaUZaOUZtSkZLMENXZzRrRFh2c1FERUdHWHdLRkxGNDJ0eGJ2L21P?=
 =?utf-8?B?RGF0dWJzNCtnZ3RmM1I0NUZKVVBqalJGTDF4VEZSTmpRNW9CQzRGTktBNWRL?=
 =?utf-8?B?SExRd1YzQ0NoK1FZQjJJR3FsNjBGSzF0SktFaDZYVW9NeW8zU2RBYll1YUVz?=
 =?utf-8?B?OHpXa1FnRWJiUklmb0c2M2ZsVkl3bVRsZm15SkR1clJjdEFwRmlQc0h6dVdM?=
 =?utf-8?B?UVpyOUV3VkFTNWhJSEEzenNUNDBuMDBjRkFLWS9HbnprTlhISjZJbmNLdyt2?=
 =?utf-8?B?SEtDSFduT1NOaFMrY3ZKNXZnU2VIVy9wdmczanB1SlJyaVQ3Z0wzakh0Y3lE?=
 =?utf-8?B?K0RZVGtZSkQ1UGFLc0tYNkJyNG5qZlkvRjBUa3pLcER6a1VIOVFzZlNIb29y?=
 =?utf-8?B?ZlRUd3BGbGNHcXVRbXo5QVVybmRzblBVamw3SDJXQnlvWTRpaWx4cGIyVTlw?=
 =?utf-8?B?YUNOZnR6UjFOcHZuajhPTyt2djNsN3kzOC9hbU1wOVBIOHgvaDYvYnJUc2w1?=
 =?utf-8?Q?68xT3yeJj8tXBoxXihr+6WKejZ4yWY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3FEdnhTR2VvZnZGM2YxMEs2OUMrQlVRNVJKRC9hVFp2MGxldVlUdEVxNE9I?=
 =?utf-8?B?YXhINXk0ajdISnVFNVhqOUhmbHJyMkxnL2NXMU9maWpEeW05ekpUYkpZK2pI?=
 =?utf-8?B?Z0dzSHRRY25YbGxYWFBneXkwM2ZSMGZhckdibFV0MTU4Q1g4ZEpDTW1qbk1T?=
 =?utf-8?B?R2dxQldSa2NkTnY1UVFnUHIrWXF6ZStNVXk5ZXVVc3RCRGJpWlA2d3JsV2w0?=
 =?utf-8?B?dlJCYU9ick1CUG9vTitiRCtBdlJzREhQTFlsbTl0aFZvcWNvemVSLzl1KzA4?=
 =?utf-8?B?ZDVlVVFjVUxTMUlzcU9zcXgyNmdDQXdPa0JSUi9QazR4WFY0cXBGVWgrSVhj?=
 =?utf-8?B?a3BzMzRjTkI1ME55NkloZzlWcmZIMDZPNVhURzdVdTM3WTlXL3Q1dkZ6VVhl?=
 =?utf-8?B?OVFmcE9ETVJLRzZ2VDhsakY4YnM1T0xEaldYVk1vZHhpQVpvaWgreVBwc2Nt?=
 =?utf-8?B?NDY1dHRTNnkxSDhWSFZuZERNdTNUZElNb2o2ZlBTZVNhZXZxcHA0NnpTODNU?=
 =?utf-8?B?S284dzN0QTZnUjkzM3YxdGkwa2JBeVVLUTF2cW1BK1lBcnFnMEF0YWwxWm9T?=
 =?utf-8?B?c3ZNOFUxUzhxVkZiOEx3UTBjYmtBdXRkZjR1amorVDFzK09yNzZ2Z3FlUXY1?=
 =?utf-8?B?b0VCRU5UTkowTG1ma0s1cWpWeXdqQTh6TUNiRThiRFByaitDRE9PRGlCWUV6?=
 =?utf-8?B?dUtaRFRRZHVGdlNyS1M4NTdENHFjRXAxWFVBb0NBd0k0TThmaGxLY2lDUW9F?=
 =?utf-8?B?US9sZGFkSmQ3OTlQSDVtWi9uL0oxUEd2MVNHRTVkSVdlanIrUHdDcUFmeGx3?=
 =?utf-8?B?WGRiTWxIMHpOb1VzZmxVd2taNlpRSXF1TjI5VnRuL0xoM1ljMUM2WlI4UmI2?=
 =?utf-8?B?U2hPS1YyaU51RTJVdmpDem81ejhEcncrRVdVUEtZMURhQlVDQytEUXY1Tnhx?=
 =?utf-8?B?MmtkUmZTVDZKalNMUzhwZlIzSm5oTEQzazA3LzVoSTJPa0ZQbGZKam55Vm53?=
 =?utf-8?B?ZlRBQ1YxM1EweXhJR0ZjK2lFM3VVQklZejkzSUF4MnBQVzZwQ0tQa1BaV2sz?=
 =?utf-8?B?WGtOSHZ3ZERXZVozdWxHZWJOT3k3MmMxVUZOUmhHNE1ZS01NbGdjaVhlNXNV?=
 =?utf-8?B?aStuNjFYVis1TENhWEhXWkMrU1NZVVhjWmJqTDVCTFpNdHo4alNkNnpMc09R?=
 =?utf-8?B?dmVVMWZZdGZEbmdKRzFHc2lhd0NJazY4bG5ZZUE1VExPVEpzd3lDcDZ1Zko5?=
 =?utf-8?B?NVNKRmdpUUVaSWowbU45ZlhEZFVNWWs2Zk81czV0ZmptRXNHTy84SUh5d3pq?=
 =?utf-8?B?MFJ3S2krcnB1QlBzUmVWSitYSzg5cTlKTkVvNlJwdnphcnFnM0l4N3QyNzZ3?=
 =?utf-8?B?MFRWSTBIWXVRbnN6UFVXZHFRZGx2Vmt6M1Y4bSt0MFZGazcrc2hFUjhqdmIx?=
 =?utf-8?B?SlhTQW5tbUExbkU3TXJLWHpndXh3M1g4bi85L1FocU9aaWJ6dUxNM2FqRWxh?=
 =?utf-8?B?UFBsY0gzRU5PcTV5ZktOUjBTZWZFSVM2eVRtaEowUlZHck1vOHB3ZzFNbTVj?=
 =?utf-8?B?dnFUMWRHUDZ0UVpDYjRJRnQrOUlXRjdXcWNCUjk5eTlJQWZBbGRMcnZyNU9X?=
 =?utf-8?B?dnhGL0NveGNJRnNpQ2lUMitibklpak81RnM1cGpTUFNYV2dLaGd0Q3JUVlFY?=
 =?utf-8?B?YmNDVVBGU2s3aFJZendpc0pOa21zS1I5OTBoVHlBeXBzSlpjSEdScGlyNHNt?=
 =?utf-8?B?M2pIWVVZK3FSSVpia0xtNFpWL0o2emNhMjAzcXR4aWRqb1U0VWlJMlpnWXNo?=
 =?utf-8?B?eGZvem5GTEFLYlBxVG5jSVhkZENkcmF6MkdPcnVMc3hwZ1dBT1hzRThjaVpH?=
 =?utf-8?B?RmpPM2YyOVRWWGZRZTE4Tkd2SDB3aDU2ODZ5ZFR0UXZjZE44MmFLL0RhaXFX?=
 =?utf-8?B?S3poemtxcXBkaVU0SkdOV2haZGpIRnFJUzEzeHdWN2sveU1tSmk0TVI2OHRm?=
 =?utf-8?B?cjBBQWlEU05NUFBCZmNBMytzY3NVT1RjMVNYYTgxTmpFVWVhOFpLYW1VeTdq?=
 =?utf-8?B?M2txYklCQkJGak1kWmlUdWNNMjN4Q1ZuSXd0MU5FdUI5bTBnYUdMcnE1a2RN?=
 =?utf-8?B?Z056WVBLclNtRmtRWEUvbDVocjNDVHUyY0YvRXE4ZDNxY3NYdWdNTmtoMWNq?=
 =?utf-8?B?MGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEC1F73F151AC0439A3CD2B311AD370D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c940244b-9fd1-4c57-3f73-08ddbe72a0de
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 22:56:09.0644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JodKK6KZTCgf4reWh480QgiFMMyo07GggrjBpi+WwZEdHZDX4baWVBFhha+ALL3GKGNZD9F3nxnWbWqx8npHHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7038
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTA4IGF0IDA3OjQyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEp1bCAwOCwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IA0KPiA+
ID4gPiA+IC0JCXN2bS0+dmNwdS5hcmNoLmd1ZXN0X3N0YXRlX3Byb3RlY3RlZCA9IHRydWU7DQo+
ID4gPiA+ID4gKwkJdmNwdS0+YXJjaC5ndWVzdF9zdGF0ZV9wcm90ZWN0ZWQgPSB0cnVlOw0KPiA+
ID4gPiA+ICsJCXZjcHUtPmFyY2guZ3Vlc3RfdHNjX3Byb3RlY3RlZCA9IHNucF9zZWN1cmVfdHNj
X2VuYWJsZWQoa3ZtKTsNCj4gPiA+ID4gPiArDQo+ID4gPiA+IA0KPiA+ID4gPiArIFhpYW95YW8u
DQo+ID4gPiA+IA0KPiA+ID4gPiBUaGUgS1ZNX1NFVF9UU0NfS0haIGNhbiBhbHNvIGJlIGEgdkNQ
VSBpb2N0bCAoaW4gZmFjdCwgdGhlIHN1cHBvcnQgb2YgVk0NCj4gPiA+ID4gaW9jdGwgb2YgaXQg
d2FzIGFkZGVkIGxhdGVyKS4gIEkgYW0gd29uZGVyaW5nIHdoZXRoZXIgd2Ugc2hvdWxkIHJlamVj
dA0KPiA+ID4gPiB0aGlzIHZDUFUgaW9jdGwgZm9yIFRTQyBwcm90ZWN0ZWQgZ3Vlc3RzLCBsaWtl
Og0KPiANCj4gWWVzLCB3ZSBkZWZpbml0ZWx5IHNob3VsZC4gIEFuZCBpZiBpdCdzIG5vdCB0b28g
dWdseSwgS1ZNIHNob3VsZCBhbHNvIHJlamVjdCB0aGUNCj4gVk0tc2NvcGVkIEtWTV9TRVRfVFND
X0tIWiBpZiB2Q1BVcyBoYXZlIGJlZW4gY3JlYXRlZCB3aXRoIGd1ZXN0X3RzY19wcm90ZWN0ZWQ9
dHJ1ZS4NCj4gKG9yIG1heWJlIHdlIGNvdWxkIGdldCBncmVlZHkgYW5kIHRyeSB0byBkaXNhbGxv
dyBLVk1fU0VUX1RTQ19LSFogaWYgdkNQVXMgaGF2ZQ0KPiBiZWVuIGNyZWF0ZWQgZm9yIGFueSBW
TSBzaGFwZT8pDQoNClRlY2huaWNhbGx5LCBpZiB3ZSB3YW50IHRvIGRvLCBJIHRoaW5rIHdlIHNo
b3VsZCBkbyB0aGUgc2ltcGxlIHdheSAodGhlDQpsYXR0ZXIpLiAgQnV0IEkgdGhpbmsgdGhpcyB3
aWxsIGhhdmUgYSByZWFsIHBvdGVudGlhbCBpbXBhY3Qgb24gdGhlIEFCST8NCg0KSSB3b3VsZCBw
cmVmZXIgdGhlIHNpbXBsZSB3YXkuICBIb3cgZG8geW91IHRoaW5rPw0KDQo+IA0KPiA+ID4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4g
PiA+IGluZGV4IDI4MDZmNzEwNDI5NS4uNjk5Y2E1ZTc0YmJhIDEwMDY0NA0KPiA+ID4gPiAtLS0g
YS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiA+ID4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+
ID4gPiA+IEBAIC02MTg2LDYgKzYxODYsMTAgQEAgbG9uZyBrdm1fYXJjaF92Y3B1X2lvY3RsKHN0
cnVjdCBmaWxlICpmaWxwLA0KPiA+ID4gPiAgICAgICAgICAgICAgICAgIHUzMiB1c2VyX3RzY19r
aHo7DQo+ID4gPiA+ICAgDQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgciA9IC1FSU5WQUw7DQo+
ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIGlmICh2Y3B1LT5hcmNoLmd1ZXN0X3Rz
Y19wcm90ZWN0ZWQpDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0K
PiA+ID4gPiArDQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgdXNlcl90c2Nfa2h6ID0gKHUzMilh
cmc7DQo+ID4gPiA+ICAgDQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgaWYgKGt2bV9jYXBzLmhh
c190c2NfY29udHJvbCAmJg0KPiA+ID4gDQo+ID4gPiBJdCBzZWVtcyB0byBuZWVkIHRvIGJlIG9w
dC1pbiBzaW5jZSBpdCBjaGFuZ2VzIHRoZSBBQkkgc29tZWhvdy4gRS5nLiwgaXQgDQo+ID4gPiBh
dCBsZWFzdCB3b3JrcyBiZWZvcmUgd2hlbiB0aGUgVk1NIGNhbGxzIEtWTV9TRVRfVFNDX0tIWiBh
dCB2Y3B1IHdpdGggDQo+ID4gPiB0aGUgc2FtZSB2YWx1ZSBwYXNzZWQgdG8gS1ZNX1NFVF9UU0Nf
S0haIGF0IHZtLiBCdXQgd2l0aCB0aGUgYWJvdmUgDQo+ID4gPiBjaGFuZ2UsIGl0IHdvdWxkIGZh
aWwuDQo+ID4gPiANCj4gPiA+IFdlbGwsIGluIHJlYWxpdHksIGl0J3MgT0sgZm9yIFFFTVUgc2lu
Y2UgUUVNVSBleHBsaWNpdGx5IGRvZXNuJ3QgY2FsbCANCj4gPiA+IEtWTV9TRVRfVFNDX0tIWiBh
dCB2Y3B1IGZvciBURFggVk1zLiBCdXQgSSdtIG5vdCBzdXJlIGFib3V0IHRoZSBpbXBhY3QgDQo+
ID4gPiBvbiBvdGhlciBWTU1zLiBDb25zaWRlcmluZyBLVk0gVERYIHN1cHBvcnQganVzdCBnZXRz
IGluIGZyb20gdjYuMTYtcmMxLCANCj4gPiA+IG1heWJlIGl0IGRvZXNuJ3QgaGF2ZSByZWFsIGlt
cGFjdCBmb3Igb3RoZXIgVk1NcyBhcyB3ZWxsPw0KPiANCj4gNi4xNiBoYXNuJ3Qgb2ZmaWNpYWxs
eSByZWxlYXNlIHlldCwgc28gYW55IGltcGFjdCB0byB1c2Vyc3BhY2UgaXMgaXJyZWxldmFudCwN
Cj4gaS5lLiB0aGVyZSBpcyBubyBlc3RhYmxpc2hlZCBBQkkgYXQgdGhpcyB0aW1lLg0KPiANCj4g
Q2FuIHNvbWVvbmUgc2VuZCBhIHByb3BlciBwYXRjaD8NCg0KSSB3aWxsIHRyeSB0byBkbyB0b2Rh
eS4NCg0KQnV0IGlmIHlvdSBhbHNvIHdhbnQgdG8gcmVqZWN0IEtWTV9TRVRfVFNDX0tIWiBWTSBp
b2N0bCBpbiBlaXRoZXIgd2F5LA0KdGhlbiBpdCBjb3VsZCBiZSBpbiBhIHNlcGFyYXRlIHBhdGNo
LCB3aGljaCBtZWFucyB3ZSBzaG91bGQgaGF2ZSAyDQpzZXBhcmF0ZSBwYXRjaGVzIHRvIGhhbmRs
ZT8NCg==

