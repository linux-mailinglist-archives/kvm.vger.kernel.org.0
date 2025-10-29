Return-Path: <kvm+bounces-61424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 33132C1D631
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 316474E39B8
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC153161AA;
	Wed, 29 Oct 2025 21:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X1JTFEpq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988551D5ABA;
	Wed, 29 Oct 2025 21:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761772237; cv=fail; b=s6u49EJ5Hl/iOx2z4s+KbPCNdOurBukvKDHdR+Joa3RUcAsuLWoT1HEsd2QBkdZW+mAY2bbtjww7IyQbCXsVHZ3gpNRKIN98S+MIDdAIxB79g/kEwauXel+I4OsmFPtqxUH9EeYBVD/MM+Fl29lIgoQ3SPGglAMO4uogdioq3bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761772237; c=relaxed/simple;
	bh=rnhFvj9dyGQVibSlrBEAznjH9AN4SjCnOV6W1d0HLOg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f9mX5Ax7zDv9J1qdWPvf8+LMvEZPUB3rKVg/xdzU0B5cr/X6TgqD6uHS500Pwozig1XJNGrzQMm0icRjVfP4YKEdc3yNopjtj8JEO2QD43++FDLzueNApvhaPKoZzuRbeOV/QXxGiyXczKOuno2aPZRMRDWwRX3TMrr9sN3fzXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X1JTFEpq; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761772235; x=1793308235;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rnhFvj9dyGQVibSlrBEAznjH9AN4SjCnOV6W1d0HLOg=;
  b=X1JTFEpqJTqu+IrFXUFEQzeHWAh/vE4co/mErOantUyn1GO8tKD1XAd8
   DSfhtFfIhURo18sJd8n38neyLUw95HrBI+xHM9rukJtNRzSVBP+GF+OtU
   wI3dM9TDbIcno4Cwm237jdmNeNOP6saSK3UXuBlDYyIlPVkW6ZSogYeOK
   2fj3upgtKAAw3mmNmC/VjyoehU/wus3Bt56Zh1JLbQfnxN+ydQ7PQaAig
   XhyXOu/hFEgAT9E2U5Q5uajgC2CiyPOrgJozhbwnocUZxGNfkGwKLsdFA
   ssznErXu2yvJNWehJGE5/1NiuYugjgtKFly/up18tI8yMXkGuTI/odZl/
   w==;
X-CSE-ConnectionGUID: RNOYHamXTOS4sGCZo5z87A==
X-CSE-MsgGUID: wHrxHBGySkSdT2P0vviFwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="89375240"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="89375240"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:10:21 -0700
X-CSE-ConnectionGUID: hBlXkDHDTbeKIKpDsbK0aw==
X-CSE-MsgGUID: o/MXXfqrSrS8BewJ/NiWuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="190131835"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:10:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 14:10:19 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 29 Oct 2025 14:10:19 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.67) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 14:10:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EN3++d4fSA4ZakmDRW2Bu6hpyoLILTG1zfNmosjTpvQtOSb4Qk3XuqD21QvLhqUDVTGNH/U2J1Ms8dw5KO33+D58qeY/5RIRs/J0DogYXrbQZSKofbiQxROoo3EovboEYdZTym79MrZtLIICvK2LL7+XH0H41DUsq2raR+cQFrj+wmhonvlqScptSwTXKlAXR3gGotbgagemwS+1USS0mcUsLiVB/zgkYSs4EXXuW4kp5OXIifHNtnz0EyzGvxc3ocVf8OpRqHM80lAr0LcAKr792o8ul+sbAhm4LqPFQLymFXF1bRiKo80CrH0KoMI+zRo7t70LNQkVnJggextr3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnhFvj9dyGQVibSlrBEAznjH9AN4SjCnOV6W1d0HLOg=;
 b=RfGUg5eaXtJ6cSvGuf3WkD3iOFHUN9h5L8F9EayD1Wq8HkiJBOLYft7GOjxuAP6tQRhZuj9tKb11J/kiAKT6xlq75vOOrHQju9HcSueEfslJqUd0ElV/isy3MTnmB0TvmPvZQiNrt+qfAIKFda1q2FiSRrTMSjjNrCFmNC95x8NQKm3PNlXKDZxfy1ekfPomKOqlt73PJmZLcQX3XfIPVjyoGqyi3uZd5sOVy9SkqctTv1T6boL6H3cSxaUg391yGKwWL1E6sXJ+qvMbyXt8KLP9QGE08fLG4eX7uiIAG5xRJFbQD9H2+FTtQ93j05K/FmtED+/8SKAosCu047JgXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7274.namprd11.prod.outlook.com (2603:10b6:610:140::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 21:10:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 21:10:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>
Subject: Re: [PATCH 0/2] x86/virt/tdx: Minor sparse fixups
Thread-Topic: [PATCH 0/2] x86/virt/tdx: Minor sparse fixups
Thread-Index: AQHcSQ0Ih0h9zzbNYE6943t1KFKbXbTZmiiAgAAEl4A=
Date: Wed, 29 Oct 2025 21:10:17 +0000
Message-ID: <cac33a2da8cbc9f9a5e3248d5cc006d7a6b7faa4.camel@intel.com>
References: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
	 <22422512e68eb6a62b137379ff3f25436d75af56.camel@intel.com>
In-Reply-To: <22422512e68eb6a62b137379ff3f25436d75af56.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7274:EE_
x-ms-office365-filtering-correlation-id: 9a457629-d487-4aef-3205-08de172f8fd4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WkRieU9ud3owQzhBdTVpUU9RUFM5bXBTY0paeEQ2cEVUS1NxYXNDK0wzc0ph?=
 =?utf-8?B?ZVo1QTJlOXhQZlhnYlVRNVhoSmxPbmN5TjMrbk1xbHZtVzFFVVZ0Tzh4ZU50?=
 =?utf-8?B?K0lndUZTZUFCN1Nrb3JnUG9XSWt0WGQ3VE4wbnc5Q0pSYXIyQVUrUTJvQ3JP?=
 =?utf-8?B?aVJHWVIvYTJubW9PTk5CNytNelNYVTdKN1NmUm1nRDQ3T01icDRLSDJZZzlj?=
 =?utf-8?B?MXVkWHUrS1FzczBMblkzQ2l4YlN2V1dRMUE3dHJXcnpPam1tS09SNjQyUWJI?=
 =?utf-8?B?eGd2dFh5VmkxWWNzVEErU1ZYbEl2L1p4cWZ0ZnFtd0hIdmJWSFhiMEF4ZXc0?=
 =?utf-8?B?TTNCNUhoVW10MS93R1dTazBjUkJocHlaRFR6aEZZSzVzeWNtNURjY3FFYy93?=
 =?utf-8?B?RHUzWjB1Q1Q0dTNrNlRUQkZCaVhjSFdJcFBDdThmMlkzdUVNa3lNVWd5dTFT?=
 =?utf-8?B?T3l4MC9QU1Y2ZEtHWjhpNlJ1T0d5L2xqZHhJdUhnMkNsRnVEMExCbmxkWUNC?=
 =?utf-8?B?YXZTR1h2MEFMSXlQNXZpVHdaME5XbWpHbzM0OGY3clBuWmxsT1NhZUFmKy9z?=
 =?utf-8?B?N2tkWldkSkNwczdzUlh2Vi9ud0txV2xKWENxN1Y3TXlDNExWTlZKT2lZd0FW?=
 =?utf-8?B?VGU5dS9MYWI4dmhpSkJXd25jNzhOUHF4UkN4cm43ejk0cERxclRHVDEwTXVY?=
 =?utf-8?B?aTFuK2VCSjVkT2RvZE1hNkVBYU5nV1krUHhoYVJhNk5YZ2hoK0hxTGwwRnJx?=
 =?utf-8?B?RlZnOUpJY2oxL0tXZ280RUxhYlcwR2hMMFNRUlhjNXBTUTF0QzV1cFdSOC9N?=
 =?utf-8?B?S1dPRVRXbnZTdm1GVHNmbFpLYUlKZ2R4VTJLb3QvT2t3YU84aEhFRnphUFZ0?=
 =?utf-8?B?QlhMRC9WOEUvYXpxT3FkMmlIMzl6MGY0Y2RnaDFKdWFFSlNrQzd1Mi85Ujda?=
 =?utf-8?B?RzI0aGpaMC9RbUFDZ1M3bDNYNDFyRnZaMkt6OUhyNkNtdTc5MlhCeWJjdXVn?=
 =?utf-8?B?Ykl2d212OGNSTGJpVHRXYlo1UStzY0t6ZDRJbU1zaXp3b1JRbXFFWHhpSjhS?=
 =?utf-8?B?SFU2dnZ4dlpYK0JOYTJRaEZONGY4N2pjVjc3TTRWVWFmWWdrOFJaeVdhSlJO?=
 =?utf-8?B?SXpFWmRUOE00Q0pHSjVYbFNPTy8wVmpUQktvbVRoZFQ1NmpHR2NHUDBwVnRn?=
 =?utf-8?B?eXBiM3JSTjMyWDJaZ1pvVmtDcVRmWmFRcS9zL2dxMVllOHZhYmsvZEY4VnVt?=
 =?utf-8?B?dW5FMnpLY0cyOXhZK1lPeC92am85WXQ1KzNNSlJCSWNsY29pZElGYzh5RGdy?=
 =?utf-8?B?OFF6bnZFbFBWaVRCU2Z3WmZzY3ZwNzZjRWx2K0lCNGU5aDJVNFRJY010bHV5?=
 =?utf-8?B?ODVENHE3YUd4T1d0RU1BeHVjRlF5Nk1raG1uTjRKSXVCR0sydVpmZURkNHNm?=
 =?utf-8?B?OHZ3cHZxV2Y2RU9CRkdLY21YT1NCdXp6SUFFdUtUdzBVOEhDNVlGZHo3K0F3?=
 =?utf-8?B?RklhYVBXaUd5UFVKNkNDL2FGcHpYMGVhUkRFKzhReTFCL3BNTW9yeGZxVTgw?=
 =?utf-8?B?VjVSQy9xUjJTeFlsUEFlcmRscTBVM3JKQ1lZRVJnZ2I3MTZYOEx6Vy9RV1Ns?=
 =?utf-8?B?Z043ZjV0WWpjWGRFR0F5RzhHbWxwTG83aU96SXJ3dk9jdzdWdjhhWklEMUVG?=
 =?utf-8?B?bGY2NjdnQm1WdGZFR25jVU1WTG9DVFpYME5JelBEdUJFWUcxQkxGL3ByZzg0?=
 =?utf-8?B?TFlQK2hyS3BTQ2tLMUw4QnBsSTBFblhDT2hWdWduQVpFSW5uSnQ4byt6UzFh?=
 =?utf-8?B?VnU2dW4yOVdpZElwNloya3hBNXJyWHhPUlRDMnJLRnJ1KzgvTXlBQ1JNbENL?=
 =?utf-8?B?S0RkS2ZvZ29GQ0ZmcW96Z0pvUHJEK1NoRHN2VHhvS0lFb3NWcEdoL0FNWC9r?=
 =?utf-8?B?WnBLVnc4MnRnaW1vVWxoeVMrWDh0U0FqM2hhYldSeW1JZjhObnFXVnhOeXU2?=
 =?utf-8?B?NHpPbjN1bjRESkR2VnMzZWlpTzN3YjV6MWRFL2QxUlVvRkczUHBpR3E3T2s0?=
 =?utf-8?Q?V345+h?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTEvZVhhZklCUUg5TmVzTTFWeldaMFlsV3VhMnQ1NTk2WmduUzkrNTBudDIx?=
 =?utf-8?B?V0RxM0lwcEtCRjN5dERZVjJyUno4MGF0WXU3Vlh4c1dFNlB0VkVGRXMzayt1?=
 =?utf-8?B?Wk5VVUdYa0R5UVlRUWZiWUEwTXhScHJ3ZlZVaGsyMjNuNnZmWkRzVFJVNjJs?=
 =?utf-8?B?eXlBUFduelcyekY0ZENPSS9RbVNJTjE2dUhVMGhsM25tbS9BK2JoVys5V3dV?=
 =?utf-8?B?aXVXdUZXbzE4VStkVUgwSWphZmtIeHNVNEV3VDVGWWwwcmNKMjlvMUN2U3ll?=
 =?utf-8?B?KzdnNlRWL3NmWGRUd2VHWXdxRVh4ZW1sVWsxYTZvWXkraXkzTEdkbmRHdzA1?=
 =?utf-8?B?cjFQVmkvVkZxdmRzbVk2VjI0MVhEbUVGZU10TmhoYjlvNnk2WXhqSWhqVkNa?=
 =?utf-8?B?M1dSYm85Z2RnazZQYzVkK2NoZm9JbjBhZHdZaWxIWUtzbGRzWm9MVklWMXNU?=
 =?utf-8?B?b2JCSUZvQS8yZXRqRXVVRTJ1Q2FTSzE3bURQV0NiVnQ5UW9UdXNkM0V1MnQy?=
 =?utf-8?B?bE9SSy8rUWI5MWl6ZEowUUk1eXBWOUl5SWZ5bHhuaFBDbzRYRUNJYys0YmZh?=
 =?utf-8?B?cnRzRllHcy85K3kwWDNJOXBvbjVmVTk5emVUeXM1d1JmUG00VlU2Q0dyOVh4?=
 =?utf-8?B?U1JUNnZxN2tmWnAzSElsUUVBU01yRm9BbXI3ZVZPRTBBbDJvM3loSC9oWXIv?=
 =?utf-8?B?bTlra2VHdDhxelpha1BQR1JoU2EvaXpudmJjaXFWWEJIK0lLS2ttOC82UC9F?=
 =?utf-8?B?bVZvVlJKRjRFRlJFUDZpTTVRWjFYNHljQnNUSzlaMkh0RTNDNUp4WW9STGd4?=
 =?utf-8?B?UnJZQi9obkNPTS9Ud3lJMlpIYnhxY0hPNEhxVUpISzhoWU9ITnJIZ001d1JT?=
 =?utf-8?B?eklJRWMwS29DR24vS3lqQVBSbHFMMEJNOE0yVjZINEJlQlErdFBxMlVRQ3dm?=
 =?utf-8?B?Sk5TYkhoVDhDZzZ5U25DSUNyS05nbjBRUzdDNnV1SW4wcVQyOG1XWlZXWmFh?=
 =?utf-8?B?dUdzL0MxcHU5VmllMGNnUnp5bHJXc3kxUFdINnNBVzFTS1JoRDlrSW9JK2lI?=
 =?utf-8?B?RzkxcUtpRmJMeWJjYTJPMXY5WEFXVm1tNEVrTDVvU3BNN3ljQ0ZLam02a01i?=
 =?utf-8?B?ekRJbCs5SVdiMGh2UUUrWDJrdEJtakl1T1hBM0lYdUU0b2pvYVVCTFBMNkNW?=
 =?utf-8?B?R0lKNFJwRnpVRGl4OFA0U1BkazF6TGtFU0dKOXlSVEhheGVEWGJHdWFhUDQ0?=
 =?utf-8?B?QUpqSnA1NnhQd3FSZHVuVXE3WUtWZjI4aXlESVZUZ0R5ek1kR3lWNUZOQXFx?=
 =?utf-8?B?eUhSSU9odmtBVyszRVVlekV2clNMQUVnWVMrWU9UNFJKc0Z6V2hIbHB4RDJ0?=
 =?utf-8?B?MVlJY3J2cUNJY21yM1Jhczg4Nkh1SkpHZVdWUThvaEgvdFdpMXozWlgxNGJk?=
 =?utf-8?B?Q0MyQlBZUVJOVUtpbm4vNytRLy9qbWdTQVVBTEVMeGRBdW5la1lyYVZoT0Nm?=
 =?utf-8?B?U1BHdTMvSno2dWhjQ1F3Nk5xZHpmYlE1V2t2UkhIM1k0R2Z1MitqOHI4M3Mw?=
 =?utf-8?B?WXp3NmlMK2ZWNitDd2dONndsazdsQUFDU3ROQUYzR2hSUzhXWHVCWWlqUnpU?=
 =?utf-8?B?Mk5hRllYK29Cb3lsclF0ZWZLZ0wrUE9kV0RmNVQrYnlHRWRUaWwvTGJFVkM4?=
 =?utf-8?B?VXFoMmxaMkp0QkoraWVOYzQ2UlpzS2tsWDdjOVRKTHUrS1hRQWh4TzZ6bHA4?=
 =?utf-8?B?eWV5b1M1cTYzcDgwaFlmRjJiNE90ekpHbFdxWkJpNklxSTJZZTZxczJFZXVO?=
 =?utf-8?B?ZXBaUFo2elNNV1J5bVZISitPSFBya09BTG5zUnFEOEJMSHhnVXJkR245L2Ur?=
 =?utf-8?B?L1dMbGZHcGJ6NGczN3BzaDVwTDlxcXhJc0padVhPaXFIRXBPTjRodnVUODU4?=
 =?utf-8?B?RWc0UDJVQnFCRTIrNVp1UVhCMURYeHU3OWI0dU1qWVNmNWhXb3BoZmF6ZlIv?=
 =?utf-8?B?MXBRd2RxSFM4N2dZblp1VnQ1M05UVkwwL3FOdXVFVHllTXFRTEVCZ01XU29V?=
 =?utf-8?B?UjI3SUV1cjRzZjRQbjN3ZUtTS1owc0paT2Era1dUSVhxSXZsZGNSRmVaVCth?=
 =?utf-8?B?SXBxbk1CQnUrYVlFclp3RXgwUjRVMDVJYXN0NEdCcmthQVppeDhjNjI4UkdC?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5CB32491238534B84D8BDB85D56F257@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a457629-d487-4aef-3205-08de172f8fd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 21:10:17.7054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YLaUI5gDdBiQmCsd0sc4ce+Mp3W5sOiEZecRsaWBIdgEkBqSVA3w/HU+NwifgdLxoXJCh+zFF4qZFRmY5F0wUoTcD5qkxp8JKrRoJaEJCn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7274
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEwLTI5IGF0IDEzOjUzIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gQnV0IGNoZWNraW5nIHdpdGggdGhlIGxhdGVzdCBzcGFyc2UgYnVpbGQgZnJvbSBzb3VyY2Ug
ZGlkLCBhbmQgdGhpcyBmaXhlcyB0aGVtLg0KDQpNaW51cyB0aGUgbG9nIHF1ZXN0aW9uczoNCg0K
UmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4N
Cg==

