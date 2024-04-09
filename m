Return-Path: <kvm+bounces-13994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9996089DD2F
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 16:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1076C1F25B68
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 14:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE3D85276;
	Tue,  9 Apr 2024 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ejjW05Zk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3653BBD4;
	Tue,  9 Apr 2024 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712674021; cv=fail; b=nx1OjIx3Yp7ZAIGnObn86jFILmbbExh0EHTl41/KcVvRZmFmr5ilud0jaBF7bhAL0HS25jvXUuDPLgILzFVIPGuac0DjuLoJPtGksIqSlOSFwh11eGaYbHmjQz8blPdOj5XtEcx2US1EJQ5lgUf7ElPD4nW99orJ5YM/afckzOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712674021; c=relaxed/simple;
	bh=unCBs6I6L5riUuF7q8cqz3msDYD5GyyD5v5ibmEBgvk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n5SYRFHFyxVYgVwrD1FbZYXGzxRETOIhw1mmOxoSFFVgYCoDzWVxZCPswPvusaSrr6VLqeTv8cPyBFcm0jQDQ5zF6YIDIb8heZUUyy0BEXL69tLRXAppF8OAq+iMm9pvOmrEw4T/8B7w03QYxjIB+XEnYId2oRgZ7R5BJsfSfd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ejjW05Zk; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712674019; x=1744210019;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=unCBs6I6L5riUuF7q8cqz3msDYD5GyyD5v5ibmEBgvk=;
  b=ejjW05ZkF+RKAcJcWcGFisTb6mHtnJ0l73Nj9hfv0dWZPmYqk6Zb+48C
   xnTV8ztJDO2sY9uJdDqmsR41Q/d90/dbVkKfaZY971meh4J5Se6yQgPqm
   slIp3a92w6FSS8HqGlHUAd7SJ3elPsBuU0ctR0ObmrZ5Wy9mMWBBBv9wF
   UPrsHK1sbOaaukvFbGInwWqHKZTDoPsahCGWKb2/qLi7azCHFl1l/Ggx6
   cuMrIFGhGTBn73fG651ZgTQePCPv6w9FIargWLkUKGk8omfTUaokhbihq
   i8XoV/+Zqh/6GjWD1248/W3o065OIOGJuqUeUC+Z8fAzZjbD+dj63H8EI
   Q==;
X-CSE-ConnectionGUID: iH1esKVMQTymyVLVgJq2kQ==
X-CSE-MsgGUID: K4IgSBg/QyS9uZrWs4um+A==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18705279"
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="18705279"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 07:46:58 -0700
X-CSE-ConnectionGUID: a4P+4YEiQLqX3/tz8z606Q==
X-CSE-MsgGUID: 94F6CwqnQ7u9d1iSudNReg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="25016751"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Apr 2024 07:46:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Apr 2024 07:46:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 9 Apr 2024 07:46:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 9 Apr 2024 07:46:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEeiyWfiU+pOi78owevl7FaRwtG6OW0DLQq/LXULaFErvyrQAQ8+3moNSQ+2xJ+ui73mKwA2qECUr3kD2BPEG0GpCJ0ZR1ubS3/SCq/Ts6AHbROyDVFaWcHMr6GW1chLOq8//7ydlHZuU1DosEhLzyN3iERAgX52rm16A0O0OoAzHkpy0pLyfvcy1uLBRvJceKDcm1imYPEQTFNCb1Id46Qwic75+wJ+yTa/9PBtSm9xfQkCyVt3DW2ePYinNWTWysF/YwiFH/pmLsaRiyvUgQ51FJcENQHONtiMidVjCVdcMoYrjPMnpNYMxq7amtjU4ckaMTPc3A0K0MlCOF+E4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unCBs6I6L5riUuF7q8cqz3msDYD5GyyD5v5ibmEBgvk=;
 b=NfBVXmNluMVun1O9MEmFi0dSwy0ZD+2PkktuoL8ezYFIvHO0/2L5XGcvMlSOE44e/qdN+UvnjKkN0xRb6dBKcjDqALkNLOsCebo07lkWkG8UM8GDm/PCMhUM8pOs9TF1S9yV56J3pyTVn+raI4EjqyBg+S/V9993y6K0vLs91DpIyqRg4PPWTG5IDZBR3i37MNTXYwvueOcJXVOEZ7DQeswQySmdG1qV9pvCT2Kv05jTVW/XC76GA2aZh9tTZOU+Rc4MZZvBsNmQXQvq0E1lez/syK4Bt2Yh/dHB+tKe6gkyFVIu2mVfp10OpBPVBL3iRG0DNl5EFmx16uQhNPoQ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL3PR11MB6434.namprd11.prod.outlook.com (2603:10b6:208:3ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Tue, 9 Apr
 2024 14:46:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Tue, 9 Apr 2024
 14:46:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "srutherford@google.com"
	<srutherford@google.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Topic: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Index: AQHah3qOMqOgejWDsE6lTffyy9yei7FcJJkAgAJt44CAABa0AIAAE3AAgAAzlgCAAAskgIAAE5mAgAAfEYCAANyAgA==
Date: Tue, 9 Apr 2024 14:46:44 +0000
Message-ID: <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
	 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
	 <ZhQZYzkDPMxXe2RN@google.com>
	 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
	 <ZhQ8UCf40UeGyfE_@google.com>
	 <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
	 <ZhRxWxRLbnrqwQYw@google.com>
	 <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
	 <ZhSb28hHoyJ55-ga@google.com>
In-Reply-To: <ZhSb28hHoyJ55-ga@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL3PR11MB6434:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QtzwiLWPFjnsdEsAKX3nJL2Ytz0qgfEqFuVU73ELkRwcWWEOw5t/tLacVxLxI0eCjGvv73182CMOmViNBO6TLCPu1hdYBwjXanWvkxh3algaRx094icTdSCMyleAwnoiIhcVOVAYOQ15Y4pEKlZuqW6h2g2Ll7RfcEQUlq1kiSrQwYFrVxB0EKjZ/8cZL1ePehw7i4CJvf5Mm4nCtT41lC+lhzp/XUITUnyQEfCXtwHlrlq2O2furUQoNPcaxQhjDobv3WPndhwGnaFR2yUihRj6Ax1C2g8XBq1/B+JIx3KTNYso9/t81TO91RJCRVNjOKx5KdXo/BA/TdiWpdEJXQZfwt8zANbJrggR7AGhH1acuw/LrHr/2gpId6yLCuYE+Tsqyuw0HDdHOEzo6lGPXcE7O5IerxSOiMow9keJij1vogSeX/YrSJFWRB3uex0dJQ60w9He/omgYDQhgb9w28HmOrqXDYByk92AlyoLSVB1jQJX/dO2DrIAMAjZju0GeyoH08C92ce/9qyaae2wtJwPgLkyC2f++XHrwcIo+M5cEeXTO/d8wTz//0y4ikw5m/ybKaYGxVjA5sx8gc1FpYO9zevjajuh7eFnjPwwL+dANW8Ih9ePyGJYt7txBHsD0sUTIed+kOMGg2ufOQxvPvx/YMIttc9UqgURwT0Hcvo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1UvSHdiQUxiNDlYZFRFSlFXMTB4dUxuWjJwVkhLdW40djdVb2pxd1NzVXpu?=
 =?utf-8?B?TUozeTVNUTFORmtFNVZ0TXpzUW8zZE9nc3psNEFXL1dRSXB6TGJrYnE4WWFZ?=
 =?utf-8?B?bVNNWVhGcFhVaGpLcGE0YmE0QmYrTG9IVGtOL2d5WnFBOW1EOUo3eDc4SlJR?=
 =?utf-8?B?d2g0YnFLdWxUVTBXSnA1eFFOSFdMVjJZbHlHUk5OU2F3UjNwOUVWR3FUdnJj?=
 =?utf-8?B?dEdISnNpL0h4Uzh4WnhDS0pILzh5Nm5odEhiRUo5OVlxSUJqLzM5VmFtUnRY?=
 =?utf-8?B?b3ltZEg3U2dycjF3NDBSeEdiTmdOelE4dTJQSDdCcTJpbGlyQzJDTy9YcEZL?=
 =?utf-8?B?RU1Da3dBWkFTL2lFcnNJTjNsbUhITVNoK1dxL2hDUEhGWlpuczllVUprZVpO?=
 =?utf-8?B?b3RhT2w5YUxkWDZIdmxocjh4cDRxYzFzRUtYN050Nzc1NXdnSVRqaEVyb3Fl?=
 =?utf-8?B?MVF6N1hLK0psZHJYeHI5Mk41allCS1JUTEYxSU9GMkQ2WjE1dDN0YlhxeHA4?=
 =?utf-8?B?cnd1bm1wanFYQTNXeHBuQmtIOHp1dUhkNU0xV2Q1TUpQTmRiamdtcG8ySVJi?=
 =?utf-8?B?Tlcvc3ptQmZaOUk2QXdJWFdtSGlyZHM0WWdCelhqejVwYnNJREI5T3UwbE9N?=
 =?utf-8?B?eVNZUGdsZEU2dXl2aVY3T3A2ckRHajhFblNSTHE3UWdUWGRsa1Y1Qm8yWkZq?=
 =?utf-8?B?cjZra21MTks5bnVMWFlQTWdSVjhGUFB3cjhieHl4SE1UcW9YeVBrakFQdnFO?=
 =?utf-8?B?amhqd01ENXdJYW9ZVlRnL1NaK2ZONDJxQVBuQzlUUGRsa2tCYVB3VmpCbkFB?=
 =?utf-8?B?NmgyZEdCbW4xL0orNWk4eDVQWFNsQjdPdml4OVVXNXlYZWVZYkQrOC8vZHNX?=
 =?utf-8?B?Y3NVSGtCWjlUS3cyTUFMeUV6Ym12aG1LaFNmcWZCdTgyckJXL2VHRlFYZEZI?=
 =?utf-8?B?dm9BRTN0STdEVkNvZEVaenViRCs2Nlpnek1aQnZTOGZDNzlDN3pTQk1tbCtr?=
 =?utf-8?B?d05OWXNhZUhVZnBHbkRZTmlxRVB6UGk1OEo0NXUxalZNL29ZMU9MQjJLUUpC?=
 =?utf-8?B?Q3JUZUFNL0F5VzRUajVYSlZ1anZsQ3Z3eUNLN29LOWRESWgvNFpGRjBCQWJF?=
 =?utf-8?B?bkErQWljS25QOVRuRkNSNloreU9CUGxtTDZCYWNtVnBmRmdEZ0VmWjJDMzZB?=
 =?utf-8?B?TUhJblV2U2Zvd0NOcUNkTUdWSnM2djh4ZThBM0N6TkRpb2daMEhCMmpHWnhR?=
 =?utf-8?B?WGszYkh3cXpDYmc5SG1naTArZUpUdkFVclM0KzBmb0pUOEgydU9WZTgzWVp5?=
 =?utf-8?B?ZldGbWVnVWlISzFkQncvVHV0ZmgwMlYyYklZR3lTZDhaWVV0SzAzRUhRYVJ0?=
 =?utf-8?B?eXNqSllrbDRBekxWUXZnOU5sVXFJSmNhNUFlaFZQVmlvWlcrSitPaWgwNm9k?=
 =?utf-8?B?eVV5UDRzT24zQ1BKU0owWWtzRHR5VEgwcHdPcjJKZVRwdms4MlBxeXQwV3RN?=
 =?utf-8?B?WS9HVU1OQUhrQ3NYbHFFMGRlVUkvSmczRGJkVEM5RFVkdS9zazRjWXB5VHp4?=
 =?utf-8?B?WTgrb3QrU0gyNjlkSTE4UEs1UitiNVBVK0pPZzdhTldkaWluTTJqYTc2NWpB?=
 =?utf-8?B?dFZhbzJyVUV2YXZQOEM4TE5aNzNVenZMSlVKVXR0a045Q0VVbjc4ZG9wZm11?=
 =?utf-8?B?VHB4V2VkWURvcTEyMElHZm1BTVRMUVM1dkRJR3NkTWxXT01GeEtvMjc4SHlI?=
 =?utf-8?B?OFdoanVENHV6TUtJMjZsTkdGSWl0Ni9LVnE1eXh0ODJEMm9OWFlzRzNQamZr?=
 =?utf-8?B?ai94bjBkcDJXb3diSzNFR1VIdG1aODREOVZjWFovaG01ZUdPM0h2ajk1RUxw?=
 =?utf-8?B?dExDcW52Rzl1U2JXQTdtY3ZjM2tBYzF6dGV0R1h2bGpyMjJTTzBMa0I0NjJW?=
 =?utf-8?B?YXNpdWdkZ2tybEhrdUJyQk4yN3VoYTViSWVnVnAxbUZMRDNyV1ZqOUZrOEhW?=
 =?utf-8?B?OEVvZGloQ21BZWVyaDJTeGo5UzhtdVFaL3hDYW52UmI3VzlLbkFJRXZiT213?=
 =?utf-8?B?TVI5dTVqazBDUjN0ZzNnaWhlaDV5S3pkRzErRE85UEZFS0NxSlRYNWpuVUhr?=
 =?utf-8?B?bktBWENvTnNaN284dTdvVlVUQ2g0OVUxUkhwQktYSDkvcHVKOEp5NXBOd1ZJ?=
 =?utf-8?Q?mCiZCsu5qgRvmOADWST7PHs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C3F175CBEFCA7438458D8B423E6FCD7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e73ee9f1-8900-42bd-8669-08dc58a3e059
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 14:46:44.6361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lXsh+i4go+Z9qFGdL862Hr6llhlkaQLoezoHqQqrO8D85rHbEIRX0YhBqrpGjwZgwF2e0gRbUheEFPauFhvOVkRebvt5QQz2czxQckHWCOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6434
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA0LTA4IGF0IDE4OjM3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gSXMgZ3Vlc3QuTUFYUEhZQUREUiBvbmUgb2YgdGhvc2U/wqAgSWYgc28sIHVz
ZSB0aGF0Lg0KPiA+IA0KPiA+IE5vIGl0IGlzIG5vdCBjb25maWd1cmFibGUuIEknbSBsb29raW5n
IGludG8gbWFrZSBpdCBjb25maWd1cmFibGUsIGJ1dCBpdCBpcw0KPiA+IG5vdA0KPiA+IGxpa2Vs
eSB0byBoYXBwZW4gYmVmb3JlIHdlIHdlcmUgaG9waW5nIHRvIGdldCBiYXNpYyBzdXBwb3J0IHVw
c3RyZWFtLg0KPiANCj4gWWVhaCwgbG92ZSBtZSBzb21lIGhhcmR3YXJlIGRlZmluZWQgc29mdHdh
cmUuDQo+IA0KPiA+IEFuIGFsdGVybmF0aXZlIHdvdWxkIGJlIHRvIGhhdmUgdGhlIEtWTSBBUEkg
cGVhayBhdCB0aGUgdmFsdWUsIGFuZCB0aGVuDQo+ID4gZGlzY2FyZCBpdCAobm90IHBhc3MgdGhl
IGxlYWYgdmFsdWUgdG8gdGhlIFREWCBtb2R1bGUpLiBOb3QgaWRlYWwuDQo+IA0KPiBIZWgsIEkg
dHlwZWQgdXAgdGhpcyBpZGVhIGJlZm9yZSByZWFkaW5nIGFoZWFkLsKgIFRoaXMgaGFzIG15IHZv
dGUuwqAgVW5sZXNzIEknbQ0KPiBtaXNyZWFkaW5nIHdoZXJlIHRoaW5ncyBhcmUgaGVhZGVkLCB1
c2luZyBndWVzdC5NQVhQSFlBRERSIHRvIGNvbW11bmljYXRlIHdoYXQNCj4gaXMgZXNzZW50aWFs
bHkgR1BBVyB0byB0aGUgZ3Vlc3QgaXMgYWJvdXQgdG8gYmVjb21lIHRoZSBkZSBmYWN0byBzdGFu
ZGFyZC4NCj4gDQo+IEF0IHRoYXQgcG9pbnQsIEtWTSBjYW4gYmFzaWNhbGx5IHRyZWF0IHRoZSBj
dXJyZW50IFREWCBtb2R1bGUgYmVoYXZpb3IgYXMgYW4NCj4gZXJyYXR1bSwgaS5lLiBkaXNjYXJk
aW5nIGd1ZXN0Lk1BWFBIWUFERFIgYmVjb21lcyBhIHdvcmthcm91bmQgZm9yIGEgIkNQVSINCj4g
YnVnLA0KPiBub3Qgc29tZSBnb29meSBLVk0gcXVpcmsuDQoNCk1ha2VzIHNlbnNlLiBJJ2QgbGlr
ZSB0byBnZXQgdG8gdGhlIHBvaW50IHdoZXJlIHdlIGNhbiBzYXkgaXQncyBmb3Igc3VyZSBjb21p
bmcuDQpIb3BlZnVsbHkgd2lsbCBoYXBwZW4gc29vbi4NCg0KPiA+IA0KW3NuaXBdDQo+ID4gPiAN
Cj4gDQo+IEFzIEkgc2FpZCBpbiBQVUNLIChhbmQgcmVjb3JkZWQgaW4gdGhlIG5vdGVzKSwgdGhl
IGZpeGVkIHZhbHVlcyBzaG91bGQgYmUNCj4gcHJvdmlkZWQNCj4gaW4gYSBkYXRhIGZvcm1hdCB0
aGF0IGlzIGVhc2lseSBjb25zdW1lZCBieSBDIGNvZGUsIHNvIHRoYXQgS1ZNIGNhbiByZXBvcnQN
Cj4gdGhhdA0KPiB0byB1c2Vyc3BhY2Ugd2l0aA0KDQpSaWdodCwgSSB0aG91Z2h0IEkgaGVhcmQg
dGhpcyBvbiB0aGUgY2FsbCwgYW5kIHRvIHVzZSB0aGUgdXBwZXIgYml0cyBvZiB0aGF0DQpsZWFm
IGZvciBHUEFXLiBXaGF0IGhhcyBjaGFuZ2VkIHNpbmNlIHRoZW4gaXMgYSBsaXR0bGUgbW9yZSBs
ZWFybmluZyBvbiB0aGUgVERYDQptb2R1bGUgYmVoYXZpb3IgYXJvdW5kIENQVUlEIGJpdHMuDQoN
ClRoZSBydW50aW1lIEFQSSBkb2Vzbid0IHByb3ZpZGUgd2hhdCB0aGUgZml4ZWQgdmFsdWVzIGFj
dHVhbGx5IGFyZSwgYnV0IHBlciB0aGUNClREWCBtb2R1bGUgZm9sa3MsIHdoaWNoIGJpdHMgYXJl
IGZpeGVkIGFuZCB3aGF0IHRoZSB2YWx1ZXMgYXJlIGNvdWxkIGNoYW5nZQ0Kd2l0aG91dCBhbiBv
cHQtaW4uwqBUaGlzIGJlZ2dlZCB0aGUgcXVlc3Rpb25zIGZvciBtZSBvZiB3aGF0IGV4YWN0bHkg
S1ZNIHNob3VsZA0KZXhwZWN0IG9mIFREWCBtb2R1bGUgYmFja3dhcmRzIGNvbXBhdGliaWxpdHkg
YW5kIHdoYXQgU1cgaXMgZXhwZWN0ZWQgdG8gYWN0dWFsbHkNCmRvIHdpdGggdGhhdCBKU09OIGZp
bGUuIEknbSBzdGlsbCB0cnlpbmcgdG8gdHJhY2sgdGhhdCBkb3duLiBMb25nIHRlcm0gd2UgbmVl
ZA0KdGhlIFREWCBtb2R1bGUgdG8gZXhwb3NlIGFuIGludGVyZmFjZSB0byBwcm92aWRlIG1vcmUg
aW5mbyBhYm91dCB0aGUgQ1BVSUQNCmxlYWZzLCBhbmQgdGhvc2UgZGlzY3Vzc2lvbnMgYXJlIGp1
c3Qgc3RhcnRpbmcuDQoNCklmIEtWTSBuZWVkcyB0byBleHBvc2UgdGhlIHZhbHVlcyBvZiB0aGUg
Zml4ZWQgbGVhZnMgdG9kYXkgKGRvZXNuJ3Qgc2VlbSBsaWtlIGENCmJhZCBpZGVhLCBidXQgSSdt
IHN0aWxsIG5vdCBjbGVhciBvZiB0aGUgZXhhY3QgY29uc3VtcHRpb24pLCB0aGVuIG1vc3Qgd291
bGQNCmhhdmUgdG8gYmUgZXhwb3NlZCBhcyAidW5rbm93biIsIG9yIHNvbWV0aGluZyBsaWtlIHRo
YXQuDQoNCj4gDQo+ID4gU28gdGhlIGN1cnJlbnQgaW50ZXJmYWNlIHdvbid0IGFsbG93IHVzIHRv
IHBlcmZlY3RseSBtYXRjaCB0aGUNCj4gPiBLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRC9LVk1fU0VU
X0NQVUlELiBFdmVuIGV4Y2x1ZGluZyB0aGUgdm0tc2NvcGVkIHZzIHZjcHUtDQo+ID4gc2NvcGVk
IGRpZmZlcmVuY2VzLiBIb3dldmVyLCB3ZSBjb3VsZCB0cnkgdG8gbWF0Y2ggdGhlIGdlbmVyYWwg
ZGVzaWduIGENCj4gPiBsaXR0bGUgYmV0dGVyLg0KPiANCj4gTm8sIGRvbid0IHRyeSB0byBtYXRj
aCBLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRCwgaXQncyBhIHRlcnJpYmxlIEFQSSB0aGF0IG5vDQo+
IG9uZQ0KPiBsaWtlcy7CoCBUaGUgb25seSByZWFzb24gd2UgaGF2ZW4ndCByZXBsYWNlZCBpcyBi
ZWNhdXNlIG5vIG9uZSBoYXMgY29tZSB1cCB3aXRoDQo+IGENCj4gdW5pdmVyc2FsbHkgYmV0dGVy
IGlkZWEuwqAgRm9yIGZlYXR1cmUgZmxhZ3MsIGNvbW11bmljYXRpbmcgd2hhdCBLVk0gc3VwcG9y
dHMNCj4gaXMNCj4gc3RyYWlnaHRmb3J3YXJkLCBtb3N0bHkuwqAgQnV0IGZvciB0aGluZ3MgbGlr
ZSB0b3BvbG9neSwgY29tbXVuaWNhdGluZyBleGFjdGx5DQo+IHdoYXQNCj4gS1ZNICJzdXBwb3J0
cyIgaXMgbXVjaCBtb3JlIGRpZmZpY3VsdC4NCj4gDQo+IFRoZSBURFggZml4ZWQgYml0cyBhcmUg
dmVyeSBkaWZmZXJlbnQuwqAgSXQncyB0aGUgVERYIG1vZHVsZSwgYW5kIHRodXMgS1ZNLA0KPiBz
YXlpbmcNCj4gImhlcmUgYXJlIHRoZSBiaXRzIHRoYXQgeW91IF9tdXN0XyBzZXQgdG8gdGhlc2Ug
ZXhhY3QgdmFsdWVzIi4NCg0KUmlnaHQsIHdlIHdvdWxkIG5lZWQgbGlrZSBhIEtWTV9HRVRfU1VQ
UE9SVEVEX0NQVUlEX09OLA0KS1ZNX0dFVF9TVVBQT1JURURfQ1BVSURfT0ZGIGFuZCBLVk1fR0VU
X1NVUFBPUlRFRF9DUFVJRF9PUFRJT05BTC4gQW5kIHN0aWxsDQppbmhlcml0IHRoZSBLVk1fR0VU
X1NVUFBPUlRFRF9DUFVJRCBwcm9ibGVtcyBmb3IgdGhlIGxlYWZzIHRoYXQgYXJlIG5vdCBzaW1w
bGUNCmJpdHMuDQoNCj4gDQo+ID4gSGVyZSB3ZSB3ZXJlIGRpc2N1c3NpbmcgbWFraW5nIGdwYXcg
Y29uZmlndXJhYmxlIHZpYSBhIGRlZGljYXRlZCBuYW1lZA0KPiA+IGZpZWxkLA0KPiA+IGJ1dCB0
aGUgc3VnZ2VzdGlvbiBpcyB0byBpbnN0ZWFkIGluY2x1ZGUgaXQgaW4gQ1BVSUQgYml0cy4gVGhl
IGN1cnJlbnQgQVBJDQo+ID4gdGFrZXMNCj4gPiBBVFRSSUJVVEVTIGFzIGEgZGVkaWNhdGVkIGZp
ZWxkIHRvby4gQnV0IHRoZXJlIGFjdHVhbGx5IGFyZSBDUFVJRCBiaXRzIGZvcg0KPiA+IHNvbWUN
Cj4gPiBvZiB0aG9zZSBmZWF0dXJlcy4gVGhvc2UgQ1BVSUQgYml0cyBhcmUgY29udHJvbGxlZCBp
bnN0ZWFkIHZpYSB0aGUNCj4gPiBhc3NvY2lhdGVkDQo+ID4gQVRUUklCVVRFUy4gU28gd2UgY291
bGQgZXhwb3NlIHN1Y2ggZmVhdHVyZXMgdmlhIENQVUlEIGFzIHdlbGwuIFVzZXJzcGFjZQ0KPiA+
IHdvdWxkDQo+ID4gZm9yIGV4YW1wbGUsIHBhc3MgdGhlIFBLUyBDUFVJRCBiaXQgaW4sIGFuZCBL
Vk0gd291bGQgc2VlIGl0IGFuZCBjb25maWd1cmUNCj4gPiBQS1MNCj4gPiB2aWEgdGhlIEFUVFJJ
QlVURVMgYml0Lg0KPiA+IA0KPiA+IFNvIHdoYXQgSSB3YXMgbG9va2luZyB0byB1bmRlcnN0YW5k
IGlzLCB3aGF0IGlzIHRoZSBlbnRodXNpYXNtIGZvciBnZW5lcmFsbHkNCj4gPiBjb250aW51aW5n
IHRvIHVzZSBDUFVJRCBoYXMgdGhlIG1haW4gbWV0aG9kIGZvciBzcGVjaWZ5aW5nIHdoaWNoIGZl
YXR1cmVzDQo+ID4gc2hvdWxkDQo+ID4gYmUgZW5hYmxlZC92aXJ0dWFsaXplZCwgaWYgd2UgY2Fu
J3QgbWF0Y2ggdGhlIGV4aXN0aW5nDQo+ID4gS1ZNX0dFVF9TVVBQT1JURURfQ1BVSUQvS1ZNX1NF
VF9DUFVJRCBBUElzLiBJcyB0aGUgaG9wZSBqdXN0IHRvIG1ha2UNCj4gPiB1c2Vyc3BhY2Uncw0K
PiA+IGNvZGUgbW9yZSB1bmlmaWVkIGJldHdlZW4gVERYIGFuZCBub3JtYWwgVk1zPw0KPiANCj4g
SSBuZWVkIHRvIGxvb2sgYXQgdGhlIFREWCBjb2RlIG1vcmUgdG8gZm9ybSBhbiAodXBkYXRlZCkg
b3Bpbmlvbi7CoCBJSVJDLCBteQ0KPiBvcGluaW9uDQo+IGZyb20gZm91ciB5ZWFycyBhZ28gd2Fz
IHRvIHVzZSBBVFRSSUJVVEVTIGFuZCB0aGVuIGZvcmNlIENQVUlEIHRvIG1hdGNoLsKgDQo+IFdo
ZXRoZXINCj4gb3Igbm90IHRoYXQncyBzdGlsbCBteSBwcmVmZXJyZWQgYXBwcm9hY2ggcHJvYmFi
bHkgZGVwZW5kcyBvbiBob3cgbWFueSwgYW5kDQo+IHdoYXQsDQo+IHRoaW5ncyBhcmUgc2hvdmVk
IGludG8gYXR0cmlidXRlcy4NCg0KVGhhbmtzLiBQYW9sbyBzZWVtZWQgZWFnZXIgdG8gZ2V0IHRo
ZSB1QVBJIHNldHRsZWQgZm9yIFREWC4gQmFzZWQgb24gdGhhdCwgaXQncw0Kb25lIG9mIHRoZSB0
b3AgcHJpb3JpdGllcyBmb3IgdXMgcmlnaHQgbm93Lg0KDQpBbHRob3VnaCBoYXZpbmcgdXNlcnNw
YWNlIHVwc3RyZWFtIGJlZm9yZSBrZXJuZWwgbWFrZXMgbWUgbmVydm91cy4gSXQgY2F1c2VkIGEN
CnBpbGUgb2YgcHJvYmxlbXMgZm9yIG15IGxhc3QgcHJvamVjdCAoc2hhZG93IHN0YWNrKS4NCg==

