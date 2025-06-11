Return-Path: <kvm+bounces-49107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00A67AD604A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:45:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C250F188FA39
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 20:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5770F2367D4;
	Wed, 11 Jun 2025 20:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gCiJb9In"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C418B29D19;
	Wed, 11 Jun 2025 20:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749674741; cv=fail; b=K80tvKBqVlRl4y99J/KzA2/bOc6sY9W7deQMj6q+fcj00KTFP9wJYoPRLPw4+eBeXhZl+H6Dz1XSGH90us8+FRPuiLltrybM9cib7keckZ6I+jHDLzBnBP8gZb2e+PE2TpXWs6RjrlxlakjISIU6wYx2sVWHgkzVIKqh5v1xOYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749674741; c=relaxed/simple;
	bh=ZTJsAu+Vvml2jIJXb47mM7OyThwJb7phxKlhXo5J1rg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CklD+aRr5eq0cFz7T4WuJ5axca6GE4v2Ns/1WCK/yT90a8AX2a56zKljgOQ/l0whRE2Q5kf50A0c8MXrtq5Y280hhr2csXXK4gWsAudIw2vbTw4EUihJepNUuPIeGInKVc8BSY0hpu7bbtKYL4xY7YZ64MHmhvmvBe96q7Ecjac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gCiJb9In; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749674740; x=1781210740;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZTJsAu+Vvml2jIJXb47mM7OyThwJb7phxKlhXo5J1rg=;
  b=gCiJb9Inipd5dIru1StEg5vzEmoQrNIxBeeq2fp2jHKBwOGqKmh6Vrtz
   EFggTwFp01L1IMSXKWOuL8YEjxLGJRHQrCo7IWtDzAUCJKwc5Lm7TKzaI
   D8IbrhV3z3p3wPS2sCdygnwl5xoHgiS6BpOJGvj43tRdzPq3IMx4a2EJw
   H/7ZpTAg8tknrGr+fp0bY2EMwetkUYWp8v+33tXd7dgpeYP17gGdpKQeR
   IgK+du961XpbhWIZDC3MAD8AF9NGd8lMrVUXLiQzgrU1csRR+/pRyzt29
   Xh2vkCVkZ3NDzmMtGHlxnGMc1mtNkG4F42+jNz+L0CLGUTO7lHKT6a9Un
   Q==;
X-CSE-ConnectionGUID: S/4T+3d9Sq2Gld4gYoz+LQ==
X-CSE-MsgGUID: ylQJ5OUwTVSrCF9dlzAxUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="62444127"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="62444127"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 13:45:36 -0700
X-CSE-ConnectionGUID: N3oqkOpGQ3Gp5SLq1lJz3Q==
X-CSE-MsgGUID: XDOI2OflSyKKvhj8qxgXqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="152575566"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 13:45:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 13:45:35 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 13:45:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.59)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 13:45:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AL6HtdPDS0qfwIb+LYDDDb4yulflV057h66HUJ18L4F3l/WF0tENpJKKSchUxpw6Dfj8ScThKl8nK/isgWgvaNy98kOqzPlk3FmQ4sVbGGsI/+igLd59NpiWrGCFDg5OtwuM9tTdPIaOADQxKapkIo88P0zYwp0WMi8ZhAQuL0HHThxaSWSs8G2U6NHwvki9Ita7jlsZAfC0c7H7HSY/0pJDZnXvBvRzA0GJJDH1ZDpXU1QwFFeE1dIBrQ+unhAXEpWbsc7MHpGfU0dnfdx4wC6jXhd4l8mAnR9FYRUIXrNDSdOLOsVyk9AtBbrLBMPrLJuY6erweb5d2BFpFRKCNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZTJsAu+Vvml2jIJXb47mM7OyThwJb7phxKlhXo5J1rg=;
 b=CTmZUaJKbQTNzeMxOwdbDEjWS2ck3rsiTlm8BKotqR5PKzkhf/jl1dhvIkIKihb4FJhWrzSdgGxdV7tjbxADr2nI+M3oIn7sJwNtrePc/8eXQQFAJ3AbbfbyqADiKgHz0ZVSg7YfDrwnpA9LZMiLV2Bi3KnGxy/cUZBc9O3zFQkPEVWil163uLhCyINTT6JS1jiAbOiArwh7eEwOxJEzbTlQL6SQKRwiK7rh1Fv6NmnhjsnLByRyv4ihvcSP+ztJbqfTOM0O355E4kvpQI1TH54tQr4WOT4syhIxwDwu61xmxJA+ej8QXONrZprD91RTka9sV58RWPY9fxl4yuEgCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB8783.namprd11.prod.outlook.com (2603:10b6:8:254::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.26; Wed, 11 Jun
 2025 20:45:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 20:45:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Topic: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Index: AQHb2mYn9dWQDgvWTEqusObPtA6y57P+Q2SAgAArRYA=
Date: Wed, 11 Jun 2025 20:45:14 +0000
Message-ID: <32ff838c57f88fd4b092326afcb68b6a40f24ba0.camel@intel.com>
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
	 <aEnGjQE3AmPB3wxk@google.com>
In-Reply-To: <aEnGjQE3AmPB3wxk@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB8783:EE_
x-ms-office365-filtering-correlation-id: 4e14bc67-d3ce-4ad3-c8ab-08dda928ddc9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?THVWSVQ4cDk2VmZKZ3ZoV0Q2K0o1T05wMnJhVWtzcll3dThWSlM1OVc4c0ND?=
 =?utf-8?B?Q3p4Y2lKRnVhWFpKdXdZQ1RkL1BWbnA2N0p6U01DUHNDa0gxbHJqUXBxZ2F4?=
 =?utf-8?B?K3ZUM3p2TlhEOS9hRm9NWVBtbDNid3Z2cXhxOEJNeS9kTzRXR0pPMnhUZUdM?=
 =?utf-8?B?L3ZUZFdmU2gxWFN6N0d1ajJEcVM2RW1YSEhiY3N4bFBZdFlwZVJVa2M1WXZZ?=
 =?utf-8?B?elYyMWdQU0dwSGFVTXZOTFk4SUVFVTBJMCtmSm5MZysxdDNQV0dlcHRWeER3?=
 =?utf-8?B?alI2Nm1IcFRGWXRqWjJhb3NGOWlMN3ZwcWIwUVcyQXNScm5BTEtTcCt1M05i?=
 =?utf-8?B?eHdKVmZJa0M1VE0rRGFWd0ZjbmdTSUlYWVdRdUorNWVzbzVXdW0yMFYyRmlK?=
 =?utf-8?B?Y0I4TzJyeThTYlMyOHoydWdzVmtCSFI0NE9WL084K2FDVGlKcnp3dmxjYTVU?=
 =?utf-8?B?WHBYYWZEb3YxWEwydTMzRDd2Tld3ZWdGU3FJdDVjRFNiS3d1NDFLMlFlRmpD?=
 =?utf-8?B?OVc0RDFCd2NTajV3REhPVmJDMWlGZFY0YzBSejRUakl0dFV4dkRHUVE2SHV1?=
 =?utf-8?B?RlRPUmI2cENHU0hpNWE1dC9hZ2JQMTM2cFlRbW5VdFE4Yjk5T0Z5dUw5bk5t?=
 =?utf-8?B?WE83ZG1CS1RIS0IwckJGV1pFUmV5QXhSbWhBc0ljMFA3NkZkODFsTlZ2QXVm?=
 =?utf-8?B?ZHdiRXZHTjNWdFFCSDZZeEV4aFBZa2dmdEVScDZuQUpWOUZ0S2QvSVk0dzVG?=
 =?utf-8?B?SHQ0UUxzUDhQelFCR2c0UnBJak9VN0gzajZyMW9ZMHhqdGFxZzN5a1dIemIw?=
 =?utf-8?B?Nnl5OXVYTHo4eVNSRW1vcU54Nk1veXRLQzZYT1FzZ2lJc2N3ZUFBd3Naa09G?=
 =?utf-8?B?VGx2UlNscDltYlNxLyt5WXdTcHBXbkM0T1R6YWlaM0MxUTFQK0djTnBJVFor?=
 =?utf-8?B?ekYreTc3emdJRFBmZmEwYTZrc0E1VFRaNVZ1VTBHVUwzenVET3NjdlVROVRv?=
 =?utf-8?B?YlhDWTRra2NPdTRadVo1MGdvdEY1VWRuNnpDWFpXNGt3YkhocmlnWnlQcnl1?=
 =?utf-8?B?dSt2QVEremFUYVNyMXJzNXZ5MWZNczZES0FFdG0vM3BTRFdqK0JXR0E2bWp6?=
 =?utf-8?B?UDdGNFBWd1g0UXQ5MDRxK3pydXdxMHVrMG5qQ1VlcHF3TENZWTlJVXpCRDly?=
 =?utf-8?B?MnBpVWtPblNHRlZoMjd4amVEVWFpUkxCOEtieklYV2hKNUppYWNFc21qQ2d6?=
 =?utf-8?B?M1M1cVlkMTRQMHlFRzRId0dQT3RXNTU4SHUrSk1vRzZSTjN5MjVncFJqVHNn?=
 =?utf-8?B?V1pXV0I0NkJDRTBmbzNNdWlUcWV4QlNOSWFJaEgyUUE0VS83NHpWVGdTV2d4?=
 =?utf-8?B?cUhzZUNORWdNUnBtRmkxbVB4RVcvQTNtNXBxaExhVGxJK1E5NUtBdUxwVVlw?=
 =?utf-8?B?ZFhjcmZ2Zy9MalNMTDVaTWI3QVlqcC9BaUxKYlUydkkyL3FpZ293aW1VMUdm?=
 =?utf-8?B?L3FSSHUrOU1IUHV6d3ZFSVdsLzVRcnRITmtjK3RZRXhxSXFFU0d0WGpmZzYv?=
 =?utf-8?B?OFZMcHcwYmFMZFQ5NDFRa0phMFhxT2xDZzRWQ1BwcEI1RWNSYS9TaGZKdGNH?=
 =?utf-8?B?OGljU291Qll3OGU4SXJ4VFQ3NVNsanZJcjQybXhqc0Q5aFRacThxNG9MV0VD?=
 =?utf-8?B?VDltRTk0R1B2aGIramNhQmVpdVBudkVpVnpabzlLSU9HQllBVTUxMVBRTTFt?=
 =?utf-8?B?VDhlSjZWbnl5Y0pPVVVxa3M0WDNnYjJCUVpxeHBhNmVJWEFiV2Zrdld2U2Zk?=
 =?utf-8?B?S3RXa2hBWUxYR21PREoxOStMNWMrbDlqZGt3Tk41WlRpaWNXNVEwTEQ5cko4?=
 =?utf-8?B?c1llN1VIU3N5Tmt6amhubnlJOEtIN01hclJNa3dkQU80VmswQVdpNUd4NHpY?=
 =?utf-8?B?TW1mbXhjR0twQlh1M3ZrSmpsUUJSVFZhNTFHaGdBSzR6NUEzNkRXR3d5K1gr?=
 =?utf-8?Q?nL1bpb0/Ocu9X1TSV2bhyLGywMaf9E=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEkxU1duS3dTaXA1MmpqaWdmQ3dKc21GUjRaYmlZdUVjM0pua2tPTWFSTVdo?=
 =?utf-8?B?VGFBQkk4d2pBVnVjRUFwQTFKNXE1NFpsK0x0K1pYelJZQldaNUw1aXJnK2o3?=
 =?utf-8?B?MGdkMjB6c3pac3dQT2FiYXZKL3gxWEpWL2o1RUVoU010ckdpQng5STZveXJl?=
 =?utf-8?B?UGUrc3FYcEZWMzBVdVRkNytuelNld0dSeDFlK2dtNlNobVBnVVh1a2hscGdx?=
 =?utf-8?B?c0srWFliWTIycjMrVG40TDBoTUlNUkRkRk1HNVZuUnpwMHBybDg0Nlhmb3NX?=
 =?utf-8?B?Qkl1SUtRWVV3Q2Fta1JmNldMOC9jN0t5R0Z2SlUxWXZVbjAzUWJTOFR2dXJR?=
 =?utf-8?B?YWJ0UE94eURZZE4xYnRYaTZqZE41ZWc0Z1pCNFg5NVNIZHhmUURjaWUyNHhC?=
 =?utf-8?B?U2RHdjZ0dW54b3JaaWRjcEs3UmR3NUFla0VOZnNycEY0U1ZtcFdZcG9RblEx?=
 =?utf-8?B?cm9xUEhTeWMwTkpwdUJxMU9TQ1BJVlREdHA1U3huUDg5elJscWhMNE1Cc2lZ?=
 =?utf-8?B?OFJwd24zRUkzOUFwcXkyR3gzbWE1VW9sZ0R0bmhzNUpTQ254NkpSMk9KU29U?=
 =?utf-8?B?R0VQK3pGUUNTQ0MweHUvaWcrdy9vbG1LeG50U01hWEo1RVdKNTJjUmoxbEZB?=
 =?utf-8?B?QTNWSEc3dGxCRGZ3QnVYenJZbnFEb3hoRExrT05jT2t4ZG9MMjlsTEpFU3FK?=
 =?utf-8?B?a2llRjNhYytXTUFtWnpPUGhFQlJ0UFNzRzF6WWFnZm1kb0tZMGFrY3c3VW85?=
 =?utf-8?B?WHVsRkYxc1R1djdMRWhsQlZ3VnBwUlQyVWVMRzRIUEQ0cmhNTEZNTDkxemoy?=
 =?utf-8?B?TTJnb2U3d0huT2R1ejZLM2lJQnllelNLZGV0TXRQRmNaSVlpR212YUZ6enJJ?=
 =?utf-8?B?UGxwa2UzYzhuRW1EWk9Kd1FPOEgwM2cwYW1FZ3FDQ1Nxek5oU0V2Mm9ib1NW?=
 =?utf-8?B?TGZ3SDN3VloyRzV5T21Bc2dxUHRMNG1XN1NTUms2RWxGdUt3ZnRIbmtJV3d0?=
 =?utf-8?B?Tkw4VnRaeXRwZzFkL1hreWhrT3MzUUplV1ZyT3p4VkloNFd6VzZ2OTdidk5v?=
 =?utf-8?B?T045VnJ5YWZQSlF3T0wwMG1sTVNaWTdzREI3TTAzdnZtRS9XdHFaRU1jUXZU?=
 =?utf-8?B?K3dMWVZaWFNJdmJDbnBjSXI0Qk4waEl4SnlDYWpmM3k4K05XQytVVjZodUpZ?=
 =?utf-8?B?YnNidEZhcGxMZHhqd2srdkljQkVRRVVQUEM2b2VscDFMcWdvSWRLdllJZG1n?=
 =?utf-8?B?S2lIaTE0U203S1laakRZNjZRWFQ2NXhLY0FwdmdHRXFnaWN0aVByazlDbXVw?=
 =?utf-8?B?RFFwaU1TVSs0NTVLOCtwMzFXOGFhMTFlUE80aEtxS2NjaHl3WFlXTzczMzd0?=
 =?utf-8?B?QVNnSnl2L0ZhZmRzRU4rL3Z0UnNXK216Ym0vOUc2dEZDUlJpTEUvMk5sZXBZ?=
 =?utf-8?B?SE5IQ1VVWDViNW1GL0VDRkZVb05Ia2xnN0Q5bVhvVENqaEhLSXhReVM4ckp4?=
 =?utf-8?B?WjZDN1k5YytsOUd5bE1FS0ZWVktmVVpNUTJSYTg4amF0dTNUeE10NXg2clFO?=
 =?utf-8?B?K1BZSzNkYi8vVS95VDB5Y3ozRktxVkk1bkphcmNjTUdlTUZkVG9aZWR1Q1RO?=
 =?utf-8?B?K3o0Nk1Ka3VyYjg3aUJKZ3IzZ2RvRlI1VVNxQUx5Y0E4VkFxblhUT3JmUG5a?=
 =?utf-8?B?cmlPb3crUno3VXhYUEZaR0xadTM1QnZMNzBUaVJiRFlIS3k5N1NqZ25TeXda?=
 =?utf-8?B?VXU1QzJQRmlvbkhlNlBadXBhWWpMNTZQaVFKM2QwQUtkOXI1TEtQWVNVbk5M?=
 =?utf-8?B?cURQRlcyazNSS1hsMnNLZWpINTBwM2VRVWY0LzNtSU9DbXFCelNhN1U3bEsz?=
 =?utf-8?B?blpJRU5xR1ZQM1o1UEs1RGYrSzV5OGxqTm54eHo4dXUwT014SEU2K1JGcy9M?=
 =?utf-8?B?Sm5TKytlcnI1cWR0ZUF4QmNWdzVxK0phUjJTWjVxYnc0aktkemdtL2QxTnBQ?=
 =?utf-8?B?TWJPOHFnMHdXbFdWb1pHanhtYVB6Qk56L1F4TEoyMmVvT09BN0R3Z2pYVG1x?=
 =?utf-8?B?WHZQbE5zUXdpY1c4Zm9qRUkvYkJvRTYyK2lBV2tiT3paVUlReDFpUFdkNFg1?=
 =?utf-8?B?TmJoR0x1cE53YTk4V1ZtYko0UUpBRFJwOUIySW4rNlc0TnVneGlSNFZJWUlE?=
 =?utf-8?B?cnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07A8E2B85EF0C24FAD08AB4A5D2DFCCE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e14bc67-d3ce-4ad3-c8ab-08dda928ddc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 20:45:14.0712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +b2Pg+h4qL6920lTaQ1Kfh+Jli+d361lE+8c7Nkii9MCAmz3Htf4RgZzCixZpJTD7pqtlbI+srLmCcQWPUrpIoqCYiAMwF5yRF+k97mUWYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8783
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDExOjEwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBCYWNrIHRvIHRoZSBtYWluIHRvcGljLCBLVk0gbmVlZHMgdG8gaGF2ZSBhIHNpbmds
ZSBzb3VyY2Ugb2YgdHJ1dGggd2hlbiBpdCBjb21lcw0KPiB0byB3aGV0aGVyIGEgZmF1bHQgaXMg
cHJpdmF0ZSBhbmQgdGh1cyBtaXJyb3JlZCAob3Igbm90KS7CoCBDb21tb24gS1ZNIG5lZWRzIHRv
IGJlDQo+IGF3YXJlIG9mIGFsaWFzZWQgR0ZOIGJpdHMsIGJ1dCBhYnNvbHV0ZSBub3RoaW5nIG91
dHNpZGUgb2YgVERYIChpbmNsdWRpbmcgY29tbW9uDQo+IFZNWCBjb2RlKSBzaG91bGQgYmUgYXdh
cmUgdGhlIG1pcnJvciB2cy4gImRpcmVjdCIgKEkgaGF0ZSB0aGF0IHRlcm1pbm9sb2d5OyBLVk0N
Cj4gaGFzIGZhciwgZmFyIHRvbyBtdWNoIGhpc3RvcnkgYW5kIGJhZ2dhZ2Ugd2l0aCAiZGlyZWN0
IikgaXMgdGllZCB0byB0aGUgZXhpc3RlbmNlDQo+IGFuZCBwb2xhcml0eSBvZiBhbGlhc2VkIEdG
TiBiaXRzLg0KPiANCj4gV2hhdCB3ZSBoYXZlIG5vdyBkb2VzIHdvcmsgKnRvZGF5KiAoc2VlIHRo
aXMgYnVnKSwgYW5kIGl0IHdpbGwgYmUgYSBjb21wbGV0ZQ0KPiB0cmFpbndyZWNrIGlmIHdlIGV2
ZXIgd2FudCB0byBzdGVhbCBHRk4gYml0cyBmb3Igb3RoZXIgcmVhc29ucy4NCg0KS1ZNIFhPJ3Mg
dGltZSBoYXMgY29tZSBhbmQgZ29uZS4gT3V0IG9mIGN1cmlvc2l0eSBpcyB0aGVyZSBhbnl0aGlu
ZyBlbHNlPw0KUmVhZGFiaWxpdHkgaXMgdGhlIG1haW4gb2JqZWN0aW9uIGhlcmUsIHJpZ2h0Pw0K
DQo+IA0KPiBUbyBkZXRlY3QgYSBtaXJyb3IgZmF1bHQ6DQo+IA0KPiDCoCBzdGF0aWMgaW5saW5l
IGJvb2wga3ZtX2lzX21pcnJvcl9mYXVsdChzdHJ1Y3Qga3ZtICprdm0sIHU2NCBlcnJvcl9jb2Rl
KQ0KPiDCoCB7DQo+IAlyZXR1cm4ga3ZtX2hhc19taXJyb3JlZF90ZHAoa3ZtKSAmJg0KPiAJwqDC
oMKgwqDCoMKgIGVycm9yX2NvZGUgJiBQRkVSUl9QUklWQVRFX0FDQ0VTUzsNCj4gwqAgfQ0KPiAN
Cj4gQW5kIGZvciBURFgsIGl0IHNob3VsZCBkYXJuIHdlbGwgZXhwbGljaXRseSB0cmFjayB0aGUg
c2hhcmVkIEdQQSBtYXNrOg0KPiANCj4gwqAgc3RhdGljIGJvb2wgdGR4X2lzX3ByaXZhdGVfZ3Bh
KHN0cnVjdCBrdm0gKmt2bSwgZ3BhX3QgZ3BhKQ0KPiDCoCB7DQo+IAkvKiBGb3IgVERYIHRoZSBk
aXJlY3QgbWFzayBpcyB0aGUgc2hhcmVkIG1hc2suICovDQo+IAlyZXR1cm4gIShncGEgJiB0b19r
dm1fdGR4KGt2bSktPnNoYXJlZF9ncGFfbWFzayk7DQo+IMKgIH0NCj4gDQo+IE92ZXJsb2FkaW5n
IGEgZmllbGQgaW4ga3ZtX2FyY2ggYW5kIGJsZWVkaW5nIFREWCBkZXRhaWxzIGludG8gY29tbW9u
IGNvZGUgaXNuJ3QNCj4gd29ydGggc2F2aW5nIDggYnl0ZXMgcGVyIFZNLg0KPiANCj4gT3V0c2lk
ZSBvZiBURFgsIGRldGVjdGluZyBtaXJyb3JzLCBhbmQgYW50aS1hbGlhc2luZyBsb2dpYywgdGhl
IG9ubHkgdXNlIG9mDQo+IGt2bV9nZm5fZGlyZWN0X2JpdHMoKSBpcyB0byBjb25zdHJhaW4gVERQ
IE1NVSB3YWxrcyB0byB0aGUgYXBwcm9wcmlhdGUgZ2ZuIHJhbmdlLg0KPiBBbmQgZm9yIHRoYXQs
IHdlIGNhbiBzaW1wbHkgdXNlIGt2bV9tbXVfcGFnZS5nZm4sDQo+IA0KDQpPb2gsIG5pY2UuDQoN
Cj4gIHdpdGggYSBrdm1feDg2X29wcyBob29rIHRvIGdldA0KPiB0aGUgVERQIE1NVSByb290IEdG
TiAocm9vdCBhbGxvY2F0aW9uIGlzIGEgc2xvdyBwYXRoLCB0aGUgQ0FMTCtSRVQgaXMgYSBub24t
aXNzdWUpLg0KPiANCj4gDQoNCg0K

