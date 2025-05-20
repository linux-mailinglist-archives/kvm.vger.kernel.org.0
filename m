Return-Path: <kvm+bounces-47198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 262CCABE819
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 01:35:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2D947A2A4E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 23:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B5B25B69E;
	Tue, 20 May 2025 23:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K5DqRX/T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6024D254870;
	Tue, 20 May 2025 23:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747784102; cv=fail; b=E1nkJqrx7du3qAAbO/CmeinY5eURjYCxWIkksTvkloxeQwS2/t69FnU250JlnT1Iryq7/lgIi3oaLKnYA2cxuJKcI2dOIHzeYrtdUbrA5TeCNxRLvzUvGk+kfstBNZSI0MhTRMSUcg9MugOH0fW6byD/szSIhybTter6DQ09360=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747784102; c=relaxed/simple;
	bh=G0+J1pPKhbw6n2xcX7l4znp76Nsz1trl/T51OOhCAl4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sTG0FLKwDtBmw/nYRs50ulRKu4pxXyiDw0Vqf8QaGP2VQ7NcGdPKmgegusRipc/JuLwh7RWcMax1robAbs2FvBKtbh8dNxrxc0I8/4xFadMyOUO50Rzaq/59QgnwEsvDH/KYfkQcXLaeKtquRYufJZNdsGM3NkllqJlCj3BJvrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K5DqRX/T; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747784100; x=1779320100;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=G0+J1pPKhbw6n2xcX7l4znp76Nsz1trl/T51OOhCAl4=;
  b=K5DqRX/TJ2A22fhd5JRDgDma9RPQpcE1Cb2yvMXXU6VdD/N/k1PiNnSY
   Z8Kg9qAENgqcsXsC5qTmFfE4WyHc/xis8n0ejCY1Pv1lIDHylOBGuqJhL
   WywlPEoEXiSuay4rExQ34oCvMO47Z8jUymnk/nEa2EDZospOfk8vROKDX
   gz1/zhljt5pq8pjLDqPr4FprwuesqFZ/hnSbjD6PaEOirKV4/ZhEFjpI9
   QMj+xo6LtIBqNsnY9+Zbs0Vp4Z8xRK1fw9dGgz2CniaeAs2e1S80m8qjZ
   wOxXRmuTU9G6zd7HhgdV/g0drF4akKeyrDwxtHFOj3uMbpJSG/iG2Rcv6
   A==;
X-CSE-ConnectionGUID: xCbnd3bFRUamQSGkMUUuZw==
X-CSE-MsgGUID: 8gnv+2WmS56ktxFN+5/XvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="60380563"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="60380563"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 16:34:59 -0700
X-CSE-ConnectionGUID: vgkb3XuHRP+TRnqx3jFpqg==
X-CSE-MsgGUID: GIYmKT6VRGyNaWRLnolizg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="143836319"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 16:34:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 16:34:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 16:34:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 16:34:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WnVVdspL6k2Uqg1YIO41qMQotK620VQtDZOMe2HKSOriCXJlpxKv1mNzBCA4EQkGRmMRNCbrPbOemN3bnxS1jdvmsXX2VlCf/1YgOcyE+MR850pFCcBMgEZ+Np9ibV7rQzPk0E15t/FMCltwUomTQoY2ZY9gqclxik4G/GzJFWkz87n5QxcLm9+OL0kHoPfMtYAx0qicJRFDS5GFr1zQZxEUwnFTkX7rA/G6Dxo+rxX76W81PlOQN+jbB051qP2SPmWoW5V2sd3dewW85VaqTY4JKbCXwUIvUboXmzFxuZIlC5tDeETQHLTy5v1V+hO17ztxHeOSieBNuspmnvWKyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0+J1pPKhbw6n2xcX7l4znp76Nsz1trl/T51OOhCAl4=;
 b=QoeMV089agvksSFj9IFMnO7/44Q1pB0iC5ABh+nJE4KXESeRZkUzqo95D4o7B4Lc4H3TttrOtKO76WnLgAaJhE8rDiSOCPOWEfrQLD7woAFBD2y88odM2a758ZHXIqbJ1oJcadsk0mXPRuTeBG2E8+RhL7YCsmb0A6DNpp5HwmcPK8VPHcl4Z10JX+ALoXlmdYXQCiYmryO8a0wBKl1KEv+H9C6xP2M7EcwXaVJC5lPoTJan4u2vHjD6Ksdam0MJ2ucHlmb8qj3kuQtR+cejiQxiRVA6YDCwzoPpr+5iqK0mY5bkHR+3KSrSGLkSj++hjlJiyqheRYoHMeSpAQa6GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB7313.namprd11.prod.outlook.com (2603:10b6:930:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 23:34:52 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8746.031; Tue, 20 May 2025
 23:34:52 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMZBhA49+LJMgEuvNu90MMjg/bPRHIEAgAN/lACAAIg8AIAA1+cAgAPLQ4CAAo6FAA==
Date: Tue, 20 May 2025 23:34:52 +0000
Message-ID: <02f8678221629a0aa05a73bcade8e1fe6f3aa1e5.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030618.352-1-yan.y.zhao@intel.com>
	 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
	 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
	 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
	 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
	 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB7313:EE_
x-ms-office365-filtering-correlation-id: c2cf1db9-ed36-4f90-f0d4-08dd97f6eb5b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V3Y5VGZhcjZuWEZwdVZyOFc5RkJ6TFVFQk81M1BvY2k4ZklDWE9rYUNKdXhM?=
 =?utf-8?B?Ym1qYThGeDcrUS92Q3o0QXRnUlhHcTRqMnhKMVM2UXVkWXZLbGtlaWN1anhl?=
 =?utf-8?B?S1MyZFMrQkJFL3FpWWdIaGt6R3F4RUJ6Y2V1U21VSVBOUFlReXozOVVRUTZk?=
 =?utf-8?B?aDRzMXpSN2ZLWTJzZ2xDYldlN0pPWkVmT3hDYys1U0xOd1ZobkQ1Syt0Uno4?=
 =?utf-8?B?T1pQQy9WNU0xVElOeWg0bjM4UDlPQStwUU4rOEU2NWl6bFloblZUM2VhaW93?=
 =?utf-8?B?Tm1vVW53Y0M1WDFQalB2TFYvTkxnazVPT2NkYWdvdWFhajk4RzRINWp3WGxw?=
 =?utf-8?B?UE9MSWdGWmIrenlTc0lKaTZnbmtSOEdPZGxOU0lWTlZZUm5vTHhnamlSREt3?=
 =?utf-8?B?VEZUL1dYaG5IOFUrNXd4dWtzbWtpWXJqZXcrQ3hFQTIxWWdiS3pMR3FlTTNG?=
 =?utf-8?B?VVdiVFR3Wm5oOERyUDFaK3MxTUZaZ1QxRCt5MXBuVTU4WE03aVUvK01XUnV5?=
 =?utf-8?B?dC9jYXZTNzQ0OVJEbUQ2dWJ6NWNPZnZZYnV3MEl1ekN4Y01WR25RR0lmNE4w?=
 =?utf-8?B?ZGJEZ1lNUjVNRmxUdlU1eDZCSEkxVkJzcUlmRDA1eXRvQmZoYzg0V1dkcjN4?=
 =?utf-8?B?OCtVeXBVMUtjKzRXb1g2UVhzbi9ybHk1a2UzWHNtVjY5cDVOUC9IMWRoRFha?=
 =?utf-8?B?MGM2NFc3VmlLZkxRN3o0cElSM1V1NXZKQldhOE9CMjVuK1o0MGdvSE1tck51?=
 =?utf-8?B?U1l3Zm8vL05CVlozWHp3WUpsTjg3cFl4VDF3OHBpclk2ZUwvQkZ3eG5takd5?=
 =?utf-8?B?dENDTlhJdmJRZ3NTVldNUDV0T2RvRDR1ckNjWmdpWW5zekU3a1VnaDIyUm9L?=
 =?utf-8?B?bGJWWjNJeDBiRy9YZXRMTklTN3M0Q0pqbjJSc3hYdGdtelB0RTZsUUhKNXY5?=
 =?utf-8?B?NHdxeUQyM3kyKzZ4cEZnZEFjRXdvbHY4SkhyVFlxL0RLbk0vRGxpU290d3dS?=
 =?utf-8?B?YXhHZ3p2eUxRdmNnSWNRZWQwc2s3cHRpcC9QdHZ0bjZYOFg4UTBSbDNMVGpC?=
 =?utf-8?B?K0NNSnE2alpiSDZ5Y3ZnRzZGZjhDcWhYeFI4YXB3ekF5MlBEMjFHUkZyM1lu?=
 =?utf-8?B?blBaVENvNmlTRWF5Y1lTemVYT3RmcUxJTFFVeG5EU1lNNkwwRnFob0I4ZWtk?=
 =?utf-8?B?ZHZxcFE0cjUrbWVRemZkM0ozbjA3dHA3UVVUYXJyc29OdVNXT3JvelNkbThh?=
 =?utf-8?B?dFBXemh3d2g2eVRTYXo1emcwcU5mYjhNdFZPb0lFOWlvRkVpcXg4ZElKRzMv?=
 =?utf-8?B?VVIrVlJmZDFsUjc3d2gzZWsxU1huVm41VkpXbjdwSzRyM21ZTHY3MHdnMFVv?=
 =?utf-8?B?ejhiQWVCeE5Oc1h4SS9XMFFYMTQ0d3RNNGYxQis5MnUyaEtnY1BWbDlEZHQw?=
 =?utf-8?B?N3luQ04vUjRBMkduMkdWZ3FIeWVmNTlwM3NkbjVRSmdtcS9ScCt3bXN1aUp0?=
 =?utf-8?B?SjJzNm1lT3REYzNJSEJnTS95d0YxK3Z4SmFTOFZyQXcvaVc0MHU5NlZvNGVo?=
 =?utf-8?B?eUQrSjBzWnd0TXFnUXJFSDkwNGZLQWMyVkVNc1hBUy9TS24zWkMwbHBKV1NZ?=
 =?utf-8?B?b3ZyR3pBRTJ0ZkNwNVB2VHV3d0tiN1lLc2hEa0JDWXliQ0VZOWlYMVlsdEVV?=
 =?utf-8?B?ZTRZMnQ4U3NIeitPekVqQkd6LzFkRzZwNUpnU1FJN2trR3YwZUYwNmliWjlh?=
 =?utf-8?B?cmt3SXE5Y1VqNHpTNTdqOW5QbDkyU1EwUVZJeFpGOHVPZEt0SWNielRwaEJn?=
 =?utf-8?B?L0tDVDlQeUpRdmNBTDVEZjNQV2VPemRtSVgzM2JubzhYdWV2cHhvbzRDM3dL?=
 =?utf-8?B?WXFqT2NWN0hQNEVWc1IvcXhaaWdJMGd3SFhhOENySHRnbTg3bGErM3RLb3B5?=
 =?utf-8?B?SWlrMU5hbGl5Vm1FczZ2VUtGZ1pVdHBrZWowWmF5MkN4WTRnMVY0RThUWFkz?=
 =?utf-8?B?cUVIWFVkMnJRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enZBRmx5NExjd0paVlgydW8vZEE5Yzh1WGI5d1BiSFNwOFVrcmtPak5qcHg4?=
 =?utf-8?B?L3dJTFlKc0ZOSUhESUM3UjMvVnNLZlJDWGJndWlqTmtnd3NvM0ZRejBBbWdr?=
 =?utf-8?B?UG5YaHg0dlI1ZmsyYmdXK2I3MU5kUSszSnJWRHMvZktZZ29zY0VmQzZoaDVI?=
 =?utf-8?B?TnI0UnI3VXI4UFlxRnI2dFpmMlFzemV6eHRCalNReTNNTXlhSGI4OU9vWGZ3?=
 =?utf-8?B?WE5odTFPeWd1UUhtVzFmUHl3U3NmUWtYR0dGRXN5Q2dNWjU0SVRwdW9JdVlz?=
 =?utf-8?B?ZFkrVUtxYlMwSWIwTE5BelRWK25malhvUithV3RPQmx0OGw1SWpEWjlySm9F?=
 =?utf-8?B?bGdlc21JOHFtM1U2d2cxQ0drLy9DTkZQZEVVZEdYVVo3bFlBZEMrTlovdTJj?=
 =?utf-8?B?aGo4TEZkc2xVa3ZqSldia1JFcUxiTDAxZjQ2ZTdWVnFlbFZjdDFxQ3dOdTZL?=
 =?utf-8?B?Wk9CQTc3TUhMZzdmSlRTUWpmcFpUVHZtaENQeUszUzJmWFE0Vk9HTXJOWTJV?=
 =?utf-8?B?UmtkMmZaeVVlMFVYV1ovU0tVYzd4bzAxK2VIY2l0VXhSVHN0UWQzem9YYWsx?=
 =?utf-8?B?R2JZazZqeXE5dllpY0EzNVZLeGNobmN0TEMrK1A1WkpIVTRXZW53WFFSRE9Z?=
 =?utf-8?B?SkRLNEVoVGxSNGRqajJhVTN1NVUxTUhhaDV3L2pQQ0VuUVlJM3JYREFFL0RK?=
 =?utf-8?B?MHVUMmtmQmw3VmhyK0JHeHJ2aWFYRWJzTHlwa0FBZktQNnd4ZGdDQm5jcXVH?=
 =?utf-8?B?Sys5RUZjVWx3b3JnSlgrN3h3bjFNUzB6ZW44cVBuMlY3YUtUQTlCOVl0aTZX?=
 =?utf-8?B?SW9QVlo3MW1vVzV4ZlhmVDV2RjdTWnVybWxPSzEvem11Z1EyUGxrckJweHZh?=
 =?utf-8?B?S3RXVm1rdDJkVC91eVRNdzZYTFBjZGRlWHpFQTN3NGxHVGdGMmdzanV5QmY1?=
 =?utf-8?B?Y2ZRMVU2aVZySldmNVI5WFZGQm81eHZubGtMaC9FSks4dHFqaHgzdzRhc0Rx?=
 =?utf-8?B?bzh6YWdheEoxZmlqS1NVWERFMGprZWpMZkdiT0ZTMHFUS3NLU1J6M2JUODBU?=
 =?utf-8?B?aFdqRDRzK2ZrZE9MdDBPcHhuTTcvMFpGTkN1aEQ2OUZqVE5vVGpGMXBvbkZE?=
 =?utf-8?B?RjhpQVI0cDRZMnZkN1YrZ2ZNRUU3YkJscFBBaU9Bb0pPNGNOaXVJZE1lN3lp?=
 =?utf-8?B?L0Vyb1J5dVljeHhNRG9EdkdmaUoxdUdTbEJPYjF6T3laTHFQRUlldmpzZm5S?=
 =?utf-8?B?UFpuSXlRWS9JU0RRQnVyeENuMWs2RCtTTHFSQUFHTmxVOGhTRXFCNFNxY2VM?=
 =?utf-8?B?NktYRFdEZTRaVkx2L1ZuTjBTOGZpa3Jsc0poK2FnRFdzc1VwdFYxaTRobjRz?=
 =?utf-8?B?dHlOcUErR0Y1b0tIUmF6SlA0QkhnSDZRQkN0Y2I5dml6TUZYekFYUkpJcEpE?=
 =?utf-8?B?V2Z6THNkak5kTDAxbkdMV2M3dklsL0xSam5LenlSV1FtQ0FPK1IwclZhdVV1?=
 =?utf-8?B?RW13a0FZdzNJSUFaaUt1T09OVTdiL2pKaE4ycFVHTFdoMWZFczV1L1BXSkcy?=
 =?utf-8?B?NUZIY0tnaXVueFkwMHFRUjFhNjBhR0l0THdKMFhTWldnT2ZsSzNEaHF6ZEVw?=
 =?utf-8?B?VlV3OXJaWXU2Ky9WeWFGYklId2VkS05VZWJiOGxEU2RzMEt4cTkyZk0yakF6?=
 =?utf-8?B?QjZRYWt4cS9MTVQ0QTYxaXJCMDk3bHEzdmlVbm55dHFVbitMZVJYSW1ZQnc5?=
 =?utf-8?B?ektRY2ppdVdtT21TeXhJaHh2cGF3TDlNY0NqM0pOcWVrWndBejlncUYvclFZ?=
 =?utf-8?B?aVN1Y2dxNmc4QkpObDZnazlFd0QyS3hDMndna09LWG1GUUxaeWxMUlg1UG5y?=
 =?utf-8?B?ZFMzSjBBcmhsN0Q5cXpXUzg1U1Ivc1M0WEo4YVRNZTJGMzNyRjczc0VONUVS?=
 =?utf-8?B?Ni9KRHYybGdDUTlndzZBSTdWQUlTcmM5MDRzeFBvdmxxOHFqck9YcXpFeTJ3?=
 =?utf-8?B?SnNMMjkwK2RVdGNJMitycjN3NnRTeUc3K1ZkR1Z0UmdhUmtKbjdJVUJkNWZ1?=
 =?utf-8?B?V2tSUGF3WVJpcXQ4UHJTTkxjWml3c2ZLVEdyQ090WVlTS3BvY0d5QnArYU11?=
 =?utf-8?Q?h2iXvNoknhpsApXptQ7Rj/n6v?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5922C0845C4CEB4F980103A07334B55B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2cf1db9-ed36-4f90-f0d4-08dd97f6eb5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 23:34:52.2305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oUHx4SV+qcudKwhtWE8l9l8H+2ZRBVRgX3gXkaBaBzQY6kJtBu+D5Udld6/dihc2h6oziZMCtWcCxdD4kjjU/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7313
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDE2OjMyICswODAwLCBaaGFvLCBZYW4gWSB3cm90ZToNCj4g
PiBCdXQgaW4gdGhlIGFib3ZlIHRleHQgeW91IG1lbnRpb25lZCB0aGF0LCBpZiBkb2luZyBzbywg
YmVjYXVzZSB3ZSBjaG9vc2UgdG8NCj4gPiBpZ25vcmUgc3BsaXR0aW5nIHJlcXVlc3Qgb24gcmVh
ZCwgcmV0dXJuaW5nIDJNIGNvdWxkIHJlc3VsdCBpbiAqZW5kbGVzcyogRVBUDQo+ID4gdmlvbGF0
aW9uLg0KPiBJIGRvbid0IGdldCB3aGF0IHlvdSBtZWFuLg0KPiBXaGF0J3MgdGhlIHJlbGF0aW9u
c2hpcCBiZXR3ZWVuIHNwbGl0dGluZyBhbmQgInJldHVybmluZyAyTSBjb3VsZCByZXN1bHQgaW4N
Cj4gKmVuZGxlc3MqIEVQVCIgPw0KPiANCj4gPiBTbyB0byBtZSBpdCBzZWVtcyB5b3UgY2hvb3Nl
IGEgZGVzaWduIHRoYXQgY291bGQgYnJpbmcgcGVyZm9ybWFuY2UgZ2FpbiBmb3INCj4gPiBjZXJ0
YWluIG5vbi1MaW51eCBURHMgd2hlbiB0aGV5IGZvbGxvdyBhIGNlcnRhaW4gYmVoYXZpb3VyIGJ1
dCBvdGhlcndpc2UgY291bGQNCj4gPiByZXN1bHQgaW4gZW5kbGVzcyBFUFQgdmlvbGF0aW9uIGlu
IEtWTS4NCj4gQWxzbyBkb24ndCB1bmRlcnN0YW5kIGhlcmUuDQo+IFdoaWNoIGRlc2lnbiBjb3Vs
ZCByZXN1bHQgaW4gZW5kbGVzcyBFUFQgdmlvbGF0aW9uPw0KDQpbU29ycnkgc29tZWhvdyBJIGRp
ZG4ndCBzZWUgeW91ciByZXBsaWVzIHllc3RlcmRheSBpbiBteSBtYWlsYm94Ll0NCg0KWW91IG1l
bnRpb25lZCBiZWxvdyBpbiB5b3VyIGNvdmVybGV0dGVyOg0KDQogICAgKGIpIHdpdGggc2hhcmVk
IGt2bS0+bW11X2xvY2ssIHRyaWdnZXJlZCBieSBmYXVsdC4NCg0KICAgIC4uLi4NCg0KICAgIFRo
aXMgc2VyaWVzIHNpbXBseSBpZ25vcmVzIHRoZSBzcGxpdHRpbmcgcmVxdWVzdCBpbiB0aGUgZmF1
bHQgcGF0aCB0bw0KICAgIGF2b2lkIHVubmVjZXNzYXJ5IGJvdW5jZXMgYmV0d2VlbiBsZXZlbHMu
IFRoZSB2Q1BVIHRoYXQgcGVyZm9ybXMgQUNDRVBUDQogICAgYXQgYSBsb3dlciBsZXZlbCB3b3Vs
ZCBmaW5hbGx5IGZpZ3VyZXMgb3V0IHRoZSBwYWdlIGhhcyBiZWVuIGFjY2VwdGVkDQogICAgYXQg
YSBoaWdoZXIgbGV2ZWwgYnkgYW5vdGhlciB2Q1BVLg0KDQogICAgLi4uwqBUaGUgd29yc3Qgb3V0
Y29tZSB0byBpZ25vcmUgdGhlIHJlc3VsdGluZw0KICAgIHNwbGl0dGluZyByZXF1ZXN0IGlzIGFu
IGVuZGxlc3MgRVBUIHZpb2xhdGlvbi4gVGhpcyB3b3VsZCBub3QgaGFwcGVuDQogICAgZm9yIGEg
TGludXggZ3Vlc3QsIHdoaWNoIGRvZXMgbm90IGV4cGVjdCBhbnkgI1ZFLg0KDQpTbyB0byBtZSwg
SUlVQywgdGhpcyBtZWFuczoNCg0KIC0gdGhpcyBzZXJpZXMgY2hvb3NlIHRvIGlnbm9yZSBzcGxp
dHRpbmcgcmVxdWVzdCB3aGVuIHJlYWQgLi4NCiAtIHRoZSB3b3JzZSBvdXRjb21lIHRvIGlnbm9y
ZSB0aGUgcmVzdWx0aW5nIHNwbGl0dGluZyByZXF1ZXN0IGlzIGFuIGVuZGxlc3MNCiAgIEVQVCB2
aW9sYXRpb24uLg0KDQpBbmQgdGhpcyBoYXBwZW5zIGV4YWN0bHkgaW4gYmVsb3cgY2FzZToNCg0K
IDEpIEd1ZXN0IHRvdWNoZXMgYSA0SyBwYWdlDQogMikgS1ZNIEFVR3MgMk0gcGFnZQ0KIDMpIEd1
ZXN0IHJlLWFjY2Vzc2VzIHRoYXQgNEsgcGFnZSwgYW5kIHJlY2VpdmVzICNWRQ0KIDQpIEd1ZXN0
IEFDQ0VQVHMgdGhhdCA0SyBwYWdlLCB0aGlzIHRyaWdnZXJzIEVQVCB2aW9sYXRpb24NCg0KSUlV
QywgeW91IGNob29zZSB0byBpZ25vcmUgc3BsaXR0aW5nIGxhcmdlIHBhZ2UgaW4gc3RlcCA0KSAo
YW0gSSByaWdodD8/PykuIA0KVGhlbiBpZiBndWVzdCBhbHdheXMgQUNDRVBUcyBwYWdlIGF0IDRL
IGxldmVsLCB0aGVuIEtWTSB3aWxsIGhhdmUgKmVuZGxlc3MgRVBUDQp2aW9sYXRpb24qLg0KDQpT
bywgaXMgdGhpcyB0aGUgIndvcnN0IG91dGNvbWUgdG8gaWdub3JlIHRoZSByZXN1bHRpbmcgc3Bs
aXR0aW5nIHJlcXVlc3QiIHRoYXQNCnlvdSBtZW50aW9uZWQgaW4geW91ciBjaGFuZ2Vsb2c/DQoN
CklmIGl0IGlzLCB0aGVuIHdoeSBpcyBpdCBPSz8NCg0KSXQgaXMgT0sgKk9OTFkqIHdoZW4gImd1
ZXN0IGFsd2F5cyBBQ0NFUFRzIDRLIHBhZ2UiIGlzIGEgYnVnZ3kgYmVoYXZpb3VyIG9mIHRoZQ0K
Z3Vlc3QgaXRzZWxmICh3aGljaCBLVk0gaXMgbm90IHJlc3BvbnNpYmxlIGZvcikuICBJLmUuLCB0
aGUgZ3Vlc3QgaXMgYWx3YXlzDQpzdXBwb3NlZCB0byBmaW5kIHRoZSBwYWdlIHNpemUgdGhhdCBL
Vk0gaGFzIEFVR2VkIHVwb24gcmVjZWl2aW5nIHRoZSAjVkUgKGRvZXMNCnRoZSAjVkUgY29udGFp
biBzdWNoIGluZm9ybWF0aW9uPykgYW5kIHRoZW4gZG8gQUNDRVBUIGF0IHRoYXQgcGFnZSBsZXZl
bC4NCg0KT3RoZXJ3aXNlLCBpZiBpdCdzIGEgbGVnYWwgYmVoYXZpb3VyIGZvciB0aGUgZ3Vlc3Qg
dG8gYWx3YXlzIEFDQ0VQVCBhdCA0SyBsZXZlbCwNCnRoZW4gSSBkb24ndCB0aGluayBpdCdzIE9L
IHRvIGhhdmUgZW5kbGVzcyBFUFQgdmlvbGF0aW9uIGluIEtWTS4NCg==

