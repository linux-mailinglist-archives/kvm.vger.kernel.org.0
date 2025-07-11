Return-Path: <kvm+bounces-52083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4CDB01158
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 04:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 655D61C44BC6
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 02:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95AA19049B;
	Fri, 11 Jul 2025 02:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z4/frcez"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED54910E9;
	Fri, 11 Jul 2025 02:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752201983; cv=fail; b=hUOVPJ8zQJZKwR+VKNwWKSrbj9OpBcwQ7XxszFtcaxgwfeKSJZHKpDWGvoQup4i/QoCbbnyz7IuZQyMFRhW5RDK6lyEwZNTet+/YxJmolFSqI1irhDE8Hj12AA+F+d4pK9vanxTZS8ABwf9LEM8UGw6yAjsxIlaq8AOW8aK88Sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752201983; c=relaxed/simple;
	bh=UWYil7xDw6RJAA5m3jzXXl8wXwxyVA1ZkPxGvb0ZJKI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oGTarq+wE1FRD4rUQJCFrbjmw6LxZsm+srzBYOIQBxQ76p3/OdCkvv3gB+05Q8KJvK5A5vv824jD7k9LFrqE022IZsMGbRfFyflk/eJDpNKEjpHF96JceTtAUjY3Cbm0NIsT9ybPhPrTYuvy3G9LU78vUBOvzYGYVJKcjmAizG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z4/frcez; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752201982; x=1783737982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UWYil7xDw6RJAA5m3jzXXl8wXwxyVA1ZkPxGvb0ZJKI=;
  b=Z4/frcezwojdW1uOn3jVdt9oi3b8yK2cbLRoxLUNlHbS2S1U6Jz6uYsL
   YFuaRCd8Gp6YOlFruOSIn5n8A0jmHnNOVfxcFO30spSJa4aSuBlcxxmPF
   lpiUWe9qmJ5oNCkD1geyd+uYzZRxhgmtg7Ut95ZwzsNm2XkrrDSfoumwp
   +butsUpdK0n/0rQrMFkSPz4pU1iu0eeRAbc52Oo1WH3nApmqA/btcDR/z
   iTlnS7on/5V7B0vo0vJ3n9OjmFHNoylIXHLgThkVpR0GLw/7CAG15KQRn
   wsO8yizMHK68BhDa0it5Aoano0/zBjUjiVKLN5Z/1xSWRLcs5X+LNew4G
   w==;
X-CSE-ConnectionGUID: 0DmS0pW1TRW1l43W8/DQHQ==
X-CSE-MsgGUID: AWHo0D2/TvO6KxbO82fblw==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54370850"
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="54370850"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 19:46:21 -0700
X-CSE-ConnectionGUID: +fkEPdohQWmnAlZFR+AQlg==
X-CSE-MsgGUID: NEX3bCT4T7eeljJ1cDN2wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="156601488"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 19:46:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 19:46:15 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 19:46:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.73) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 19:46:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gnizY6gKJMrBqX24jksZqkGxLbdweN0Da+CdH6hYXRNChHKwGNWYJV0YVZ2Xg1e91z80YIhq6ZtNZ0DvYVrtu3jy2f/dgEvPvt3BsqN5ScJwKjkvE2O62pPzo7rRmpYnxidYf2nNdcJCY9AbZnv5myykVbAW3beOO/y6v/q/GVw3KTlcCNLozQFDvSINAVR4ykT/4dft+y3tgHnaSXccxVl+gjEcnIZO41FBqLeuAf6YNu238Jo+3+qSTEHUHAcUwg3H/+inXgW1IpfcxsFGYO5o+dyWZ2TdareEu/1v9bNmZ+W7YV1FSFqGhtmN5hpUlc/ePGNe7Xb2DvAxeVgPgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UWYil7xDw6RJAA5m3jzXXl8wXwxyVA1ZkPxGvb0ZJKI=;
 b=cEch7QIS5Fy7VVL3mFlv4LUJZx6EZ4m9Hx6dmHUt81mJ8NIaYQ6THwZokGstipYNqYBgthXK1rwuzR2Duqpt5AyMT38pcioAZlN0iBZyYL1t55wfiJLZ/1qQGB9kyALma17T3c1R452H32OSeiHNKGuOiVGiypjwvjW8413APasbBGo0iKNNy95h5Bgx/EY7T0VMs3WQZkLKOl8Bc07XTTdmy5AI18acGppsNAW8SPDIGf1gcb0M+vVvFyWJByrzvfR1Cd6MQ5iT9a3El9MhBxwrOiiJoYh3ynRcoBD/7Lk0oHzOC7q9xPK62COHsdASSSZUflHRBeedukQzKoLt5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB6685.namprd11.prod.outlook.com (2603:10b6:806:258::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Fri, 11 Jul
 2025 02:46:12 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Fri, 11 Jul 2025
 02:46:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "nikunj@amd.com" <nikunj@amd.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
Thread-Topic: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
Thread-Index: AQHb8JJNsvqII3I3Gk2c0fgebVez6LQpd12AgABZx4CAAiiBAIAAGYIAgAAflICAAAgJgA==
Date: Fri, 11 Jul 2025 02:46:11 +0000
Message-ID: <02ee140496680e9e3d364dc13f98d472f3b4d028.camel@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
	 <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
	 <aG4ph7gNK4o3+04i@intel.com> <aG501qKTDjmcLEyV@google.com>
	 <78614df5fad7b1deb291501c9b6db7be81b0a157.camel@intel.com>
	 <2fa327b84b56c1abe00c4f713412bace722de44c.camel@intel.com>
	 <aHB0M/aJwzuqYBG4@intel.com>
In-Reply-To: <aHB0M/aJwzuqYBG4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB6685:EE_
x-ms-office365-filtering-correlation-id: f08d0703-6b6c-49e0-2ea3-08ddc02518e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R2kraEljdlVJTitDM3VaTEtqRXNBbDZBeGRzZ3RiTVU0L0lrS1pvelByR3Ns?=
 =?utf-8?B?V1FPK2swVzVjY3Jva2NNQ05mbzBJSk42UmE3TGdHS1pmRFFYaHJhMGwzUXBl?=
 =?utf-8?B?SzMxVkU0MUhub3BGc05PSS85SmdDNUxsNGYrSGE4Ryt6YWp6eHdKZlRudTht?=
 =?utf-8?B?QXdXK3lxWmhIZTd6eEV1M3FnYkRLNkdrSmFGZmZSQVhCZ0lOZUozSGFPUnRX?=
 =?utf-8?B?bUN4a2NpRld0bHBGc3FVejZZZiszaHJ2Y1hYQnhzY0Z4S2czVmUraysybTZl?=
 =?utf-8?B?TDdHbDh1YUcrZ0t6ajVnb1Y2SDBOazcxczVudVhmSWIveDdEUmIxSldZQS9U?=
 =?utf-8?B?YXpjR0ZCTUF1OGEybCtYL0hFZTdXVFVIcmt4V3ZZYkIxT0R1S0g5d3krd0w1?=
 =?utf-8?B?Y3BCU0sxNWlmaDdaVm12M0VhSllBOTlyWmxYYmMyVkU1ekZFMnVvTUYvRU9v?=
 =?utf-8?B?eUZBWHlFeEdKalh4WXhhYkJpNm0rR1lrRWcrRXl2dHlYV29hWDJzclZkVDRk?=
 =?utf-8?B?WjlkWjBBdVFkT2l6TWVDcTFFQ0RhTzBzWHhYNmJGY2IyRDZ2Wm1WVEhsSzBv?=
 =?utf-8?B?MmFnQWsrVFU3SDlNaGNMQkRvMW9HdHNSd1B3RHRHZVkwODhyc3IydytYMTB0?=
 =?utf-8?B?UjJUVWNsOFhCSHdFSjd4RnNFSHd2VEh2dTZabFVEUnozMGVLYlRuYnBVTGxZ?=
 =?utf-8?B?ZllmRE9RbG1ndittMWk4alhraXp3LytkUXVhbFlBVWpnbUpJdkFYUWYwbW9S?=
 =?utf-8?B?VTdMdzNTQzQ5ZkRiNHpkTjJoRXFmenpDb1pFL0FmZUhqU1dneFB4UytSd29I?=
 =?utf-8?B?UExKd0srZ1hQZG5KVDh0R0d5N0Rqc0l1dHJ1R1orenpZOU1qVmJpVlU0WnZ1?=
 =?utf-8?B?VE5aNzdDZ3VFNWdCMVVZektYV0RUNHV4bXVyUENEeGFyaFJKMmQ4K2JjbTBk?=
 =?utf-8?B?UTZsVEd3WWd6cWhMYlYwT1p5RE9sSVV6SVhMUk12OU1OYVdpSWlxczh0c3M0?=
 =?utf-8?B?S1lERXNoejdadk1EQm9OdlNSNFhqRXZrSHcxT1FWVHIvRnMwdkpwVC9RbWFD?=
 =?utf-8?B?MGxYQlRvTk1DdmpCM0hKcXFyZkNVNkY5ME90UmZZMXBwWGFYYTJIQ0ttZ210?=
 =?utf-8?B?MFVFTnRPc1gwdEJsT0lhQ1VYdWYyakVVNWVtVzJSRG51V2dyTEdlZ3N0RDM3?=
 =?utf-8?B?NDhpckhIRkhoTVB0SnJmYnhMSzZBcjJ1Ti80RXlwaXhOdFo2b0pLZVRBeU9Z?=
 =?utf-8?B?RDcxL2s0MlFkYUV3SVl4R2hXQUhwY3lMMXA5Rzg3TXNvRldPOUpER1pxNFBF?=
 =?utf-8?B?ZFcwUEZpT1ZaU3ZHSklOb0NSdlJkOTM4YURNWjhEZWtoSkxjUno5ZGFiSjRE?=
 =?utf-8?B?NzNtdWg4cCtEcVR6ZHE0STI1eXRoYXd6ZnRjeXQ5S2N0Q1o0b0J5bUxyN0hD?=
 =?utf-8?B?LzhQajJySjFVMzZ1M2dJTURadTZ6TFhlV3FOMmF2d0QvQnJBdk4vRVFjTW9C?=
 =?utf-8?B?UDcyTCtKYWNjWlRPNThENTV6Q0ZHNjlvM3ZUTWlKdU85NmFocC8vNmR5YU80?=
 =?utf-8?B?cHMydklid3ZiYmtLMkd3QnFOOG9qVzJSWGhmNGVTODZYOW9oTFllOUxRdkUz?=
 =?utf-8?B?c2J2WTc1cmd3Mk1ISStlaEUvM0ZSWGZIaVBvK2lTelhIcGYzUkRwbmM5L091?=
 =?utf-8?B?TWhzWTFncXExdDFBNW9BZ3E4MmN0RVVNVjM5cmN4WDFpZDRlbVBBMGZ4S0NT?=
 =?utf-8?B?MTFsclZoV0wrL1N6VkFNOVpxZmFRNlZIaGl0RmFjbWxyMEFGcTQwNmhML25r?=
 =?utf-8?B?cTI4ekhzd0t4eHhaNE1Sa2hkMU5zeklEeHNzZ00xczVUTWc2aTZoR2ZkYTVK?=
 =?utf-8?B?MW9OWGh5REtEWXVKYTdCRzFEMmpxSFRYTFRjWDFUWDRJS1Q3NEgrNitGc3VJ?=
 =?utf-8?B?cGZ6U1NGckRLUVR1QndMQjFUbXZGWDJkeGI5WWFZMzZGNUNNcm52WkZIV000?=
 =?utf-8?Q?ThSlIdirRW1dxWO16FLaRf3XH4UKGs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGsxTkJhNURQbU5qckh0MWZZcTRkVCs3NFRwejVEN1BhT2xEQnBhcGxxWGdj?=
 =?utf-8?B?Q2dBQm1ZSW9lb0NwK2hiWXFtT0xJWmU0VzBNWDVkanlrSmZUZGJNTzNlT0Vy?=
 =?utf-8?B?RUxQc0xkYWNUUUUxVkNGWm1LT0ErUGVqTVcvQnJJMWlQekRHQU41SVUxK0xh?=
 =?utf-8?B?VFZlOFdKM3BBbXhjWUl6bGtNbXRnb1BJZ01kZzhqSjd1QXJkRS96WkZsR2Zt?=
 =?utf-8?B?UU5Hb2tGN3lMMlJaYndMK1lLdXhRZkRzSW9oQVViTW5oQnd2ckN1ZzdNdXRY?=
 =?utf-8?B?aUkwQmYyV2xUUTlxR2RQK0w1Q3YwWHNBTzhFVjdHMjVFYmNrVElFenRFaXp3?=
 =?utf-8?B?SG4xZXdlcFFTaUk2VG9oYlFwdXNQOHZJU2htUzdEbUlJa3FWSTRvZm9rWlRk?=
 =?utf-8?B?T1o4L28yZjlzV3RINXhpSWExamZjdGRjWWtUOFVTTnk3ZDV4ZDBLa3hJWDM0?=
 =?utf-8?B?MkNTRlV3UFE4Z2lJRGltdVVmbFdPcUFKbFhjQ2ZhM1I1TlV4NG9QMXA2bzFJ?=
 =?utf-8?B?OEpDRzNzU0NsYkpxcTVHUGc4SnVKOFgzMjFlVmI0Zm04YzdPR0Q0MTJ5V2Z4?=
 =?utf-8?B?RlduOHg2Y1IySWxQdEpZWERmNzJVR2NjVnBMa1E3V3kxVXpzS3pLUUxnMFJt?=
 =?utf-8?B?UGw5THNpL1ZUb1BtYlB4S2RPNzl5anRxK3lJN1FUK0NlcTR3SXc3N2cxY0wz?=
 =?utf-8?B?VURUMTFFZ1ZzTVNUbWQ0c3FZQnE2NDUwOHpXVG1VTmoyRnVvTzBWUHJEMTBW?=
 =?utf-8?B?ZEJFOFhtUTNkcElhSVdPcjk2a3dMRUJSMkJkRHQrWStPbndkeThURms2U1li?=
 =?utf-8?B?eTNFYldDL0FVUElnRm9iWGhVR283b1NHbXZPc0kxdG5qRnk2VVFML042NktC?=
 =?utf-8?B?T0ZvL0E0UUxBYVNBUURqL0hZemNjbHdta2R3RXdPdnBaeDZ2MGdsTUpiNXRN?=
 =?utf-8?B?MmNXZ21nRDZYbjBHVUZ1Vk85WW9xekZ5UTBRMkZIZ2JnaHFsZjNOczE1TGtS?=
 =?utf-8?B?STJjVU9Ha3Q4aEVzZlRjbFVxcExkYk5VdHRpd3pZOEdCS0FIR3pDVjVTcVph?=
 =?utf-8?B?U0MwM1FCRDZNWmVBdnl2bjdDU24zUlJoN2taSkt4MVR2bHpJbjBBVGtSVkk2?=
 =?utf-8?B?V3hHNXJEekw0QmNUeFhsMHkzditMMzdHVXZKdUIvaVRBbFJWSDdnSVJmOCsy?=
 =?utf-8?B?dXIya2RmS2NHVURxQ1B2V3AwODJlTXZRTlRaMHd1ZEJzcGpIcUZ2aERyZlBS?=
 =?utf-8?B?S2NpOS92RlZhQnNULys5N2hxdHpkcVBadzUvdlROWU41RzdnNzExTytXSnRS?=
 =?utf-8?B?cTFieHlRS0EyTUVMbGQ3Q3lVaEJUaXpiamhZUVI2RUxmWWdmK01zSVZSa083?=
 =?utf-8?B?NFRtMjBzVXJYL2gxTll1NGphdnZvcituWktuaTY4VnJiRnV3bWV4NHVybFJX?=
 =?utf-8?B?UUtzeFMva3F6V3U2M2xFR2krNVVjZUc3dXFGVmlzY1ZjMmNoRjExYnVqbmgw?=
 =?utf-8?B?YXB0SkJmNWIrclord0dvUFNEM3Fmem5DOWF4TmN2TWUyMHdleTFJWjZIcURG?=
 =?utf-8?B?MmZQWTJzL2lzbFNoT0ovTHg1OERrNHFvUXIzVCt4YzNsVTgyTHBRcmttVEND?=
 =?utf-8?B?RnlZVFMyVlUvMzVXNXBjUUtmUGovOU02SHFmMER4NWVHMXB6d1FFRTFVcVp3?=
 =?utf-8?B?MUNBT0E1SW9WNjlYelFhN1FMQ29NY2xsOXpsU1RWbVVUaTM3ZTkwRVl6SmRN?=
 =?utf-8?B?aHFjVjhsQUNlVlc2ZmQxZHp4bmhHN29ndy90VUg1UFlJalJjcDlwcTBZMnNq?=
 =?utf-8?B?NlVSS0tlemVqTUNnd0xRRGg4Um5CWmtYYVF1UnQ2WkFRMW5EdlFtQnF0eXEv?=
 =?utf-8?B?OFMweFZ0Y1ZUcjBKZ1pGdTVFcjVIcHJDK1kvazJ3bEUvV3F1OFdZZ3FFUGlx?=
 =?utf-8?B?YzVpZDg0dW5mWmcramk1OHZaOVNwVnhCMmdSUU9hb01vTU1JdVhWand3cXdz?=
 =?utf-8?B?ZVRHZFdQTW1aTkx4cHIzYXRkbG1PU1BLR0E3NWt4K1ErY0NnS25xVGthVnB0?=
 =?utf-8?B?TDBxeEtvdWZudSs1NFhlczFtR3MrOVFZem9HeitHU2ErZ1V4TXdFWlVVS3Zw?=
 =?utf-8?Q?3Bu66Ok3wW4PFyWymwpEP5kMA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EB89442FB62A943A148492CA2F523D0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f08d0703-6b6c-49e0-2ea3-08ddc02518e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 02:46:12.0161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wRgUWWHymvYfyfFBnFZJTWflkQphcXbnTF74an7kCZh+i1NVXJ6J0JC7tjjOVoakGqIK7K7Th/fqIJY4b/jrbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6685
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDEwOjE3ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiBB
RkFJQ1QgdGhlIGFjdHVhbCB1cGRhdGluZyBvZiBrdm0tPmFyY2guZGVmYXVsdF90c2Nfa2h6IG5l
ZWRzIHRvIGJlIGluIHRoZQ0KPiA+IGt2bS0+bG9jayBtdXRleCB0b28uDQo+IA0KPiBZZXAuDQo+
IA0KPiA+IFBsZWFzZSBsZXQgbWUga25vdyBpZiB5b3UgZm91bmQgYW55IGlzc3VlPw0KPiA+IA0K
PiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QNCj4gPiBiL0Rv
Y3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdA0KPiA+IGluZGV4IDQzZWQ1N2UwNDhhOC4uODZl
YTFlMmIyNzM3IDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJz
dA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdA0KPiA+IEBAIC0yMDA2
LDcgKzIwMDYsNyBAQCBmcmVxdWVuY3kgaXMgS0h6Lg0KPiA+IA0KPiA+IElmIHRoZSBLVk1fQ0FQ
X1ZNX1RTQ19DT05UUk9MIGNhcGFiaWxpdHkgaXMgYWR2ZXJ0aXNlZCwgdGhpcyBjYW4gYWxzbw0K
PiA+IGJlIHVzZWQgYXMgYSB2bSBpb2N0bCB0byBzZXQgdGhlIGluaXRpYWwgdHNjIGZyZXF1ZW5j
eSBvZiBzdWJzZXF1ZW50bHkNCj4gPiAtY3JlYXRlZCB2Q1BVcy4NCj4gPiArY3JlYXRlZCB2Q1BV
cy4gIEl0IG11c3QgYmUgY2FsbGVkIGJlZm9yZSBhbnkgdkNQVSBpcyBjcmVhdGVkLg0KPiANCj4g
CQleXiByZW1vdmUgb25lIHNwYWNlIGhlcmUuDQoNCk9LLg0KDQo+IA0KPiAibXVzdCBiZSIgc291
bmRzIGxpa2UgYSBtYW5kYXRvcnkgYWN0aW9uLCBidXQgSUlVQyB0aGUgdm0gaW9jdGwgaXMgb3B0
aW9uYWwgZm9yDQo+IG5vbi1DQyBWTXMuIEknbSBub3Qgc3VyZSBpZiB0aGlzIGlzIGp1c3QgYSBw
cm9ibGVtIG9mIG15IGludGVycHJldGF0aW9uLg0KDQpUaGUgY29udGV4dCBvZiB0aGF0IHBhcmFn
cmFwaCBoYXMgImNhbiBhbHNvIGJlIHVzZWQgLi4uIiwgc28gdG8gbWUgaXQncw0KaW1wbGllZCB0
aGF0ICJpZiBpdCBpcyBjYWxsZWQiLCBpLmUuLCBpdCdzIGltcGxpZWQgdGhhdCBpdCBpcyBvcHRp
b25hbCBmb3INCm5vbi1DQyBWTXMuDQoNCj4gDQo+IFRvIG1ha2UgdGhlIEFQSSBkb2N1bWVudGF0
aW9uIHN1cGVyIGNsZWFyLCBob3cgYWJvdXQ6DQo+IA0KPiBJZiB0aGUgS1ZNX0NBUF9WTV9UU0Nf
Q09OVFJPTCBjYXBhYmlsaXR5IGlzIGFkdmVydGlzZWQsIHRoaXMgY2FuIGFsc28NCj4gYmUgdXNl
ZCBhcyBhIHZtIGlvY3RsIHRvIHNldCB0aGUgaW5pdGlhbCB0c2MgZnJlcXVlbmN5IG9mIHZDUFVz
IGJlZm9yZQ0KPiBhbnkgdkNQVSBpcyBjcmVhdGVkLiBBdHRlbXB0aW5nIHRvIGNhbGwgdGhpcyB2
bSBpb2N0bCBhZnRlciB2Q1BVIGNyZWF0aW9uDQo+IHdpbGwgcmV0dXJuIGFuIEVJTlZBTCBlcnJv
ci4NCg0KSSBhbSBub3Qgc3VyZSB3ZSBuZWVkIHRvIG1lbnRpb24gLUVJTlZBTC4gIFRoaXMgSU9D
VEwgaXMgYWxyZWFkeSByZXR1cm5pbmcNCi1FSU5WQUwgZm9yIG90aGVyIGVycm9ycyAod2hlbiBp
bnZhbGlkIHVzZXJfdHNjX2toeiBpcyBzdXBwbGllZCkuDQoNCklNSE86IFVzZXJzcGFjZSBzaG91
bGQganVzdCBjYXJlIGFib3V0IHdoZXRoZXIgc3VjY2VzcyBvciBub3QuICBCZWluZw0KZXhwbGlj
aXQgaXMgZ29vZCwgYnV0IHNvbWV0aW1lcyBpdCdzIGJldHRlciB0byBoYXZlIHNvbWUgcm9vbSBo
ZXJlLg0KDQpCdXQgSSdsbCBsZXQgU2Vhbi9QYW9sbyB0byBkZWNpZGUuDQoNCj4gDQo+ID4gDQo+
ID4gNC41NiBLVk1fR0VUX1RTQ19LSFoNCj4gPiAtLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiBp
bmRleCAyODA2ZjcxMDQyOTUuLjQwNTFjMGNhY2I5MiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4
Ni9rdm0veDg2LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiBAQCAtNzE5OSw5
ICs3MTk5LDEyIEBAIGludCBrdm1fYXJjaF92bV9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwgdW5z
aWduZWQNCj4gPiBpbnQgaW9jdGwsIHVuc2lnbmVkIGxvbmcgYXJnKQ0KPiA+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGlmICh1c2VyX3RzY19raHogPT0gMCkNCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdXNlcl90c2Nfa2h6ID0gdHNjX2to
ejsNCj4gPiANCj4gPiAtICAgICAgICAgICAgICAgV1JJVEVfT05DRShrdm0tPmFyY2guZGVmYXVs
dF90c2Nfa2h6LCB1c2VyX3RzY19raHopOw0KPiA+IC0gICAgICAgICAgICAgICByID0gMDsNCj4g
PiAtDQo+ID4gKyAgICAgICAgICAgICAgIG11dGV4X2xvY2soJmt2bS0+bG9jayk7DQo+ID4gKyAg
ICAgICAgICAgICAgIGlmICgha3ZtLT5jcmVhdGVkX3ZjcHVzKSB7DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgV1JJVEVfT05DRShrdm0tPmFyY2guZGVmYXVsdF90c2Nfa2h6LA0KPiA+IHVz
ZXJfdHNjX2toeik7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgciA9IDA7DQo+ID4gKyAg
ICAgICAgICAgICAgIH0NCj4gPiArICAgICAgICAgICAgICAgbXV0ZXhfdW5sb2NrKCZrdm0tPmxv
Y2spOw0KPiANCj4gTEdUTS4NCj4gDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
Z290byBvdXQ7DQo+ID4gwqDCoMKgwqDCoMKgwqB9DQo+ID4gwqDCoMKgwqDCoMKgwqBjYXNlIEtW
TV9HRVRfVFNDX0tIWjogew0K

