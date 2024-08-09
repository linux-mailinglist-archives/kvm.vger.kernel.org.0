Return-Path: <kvm+bounces-23695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 008AA94D198
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:52:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC00E287136
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 13:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20D6195B14;
	Fri,  9 Aug 2024 13:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZJgV7tMf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DA11DFE4;
	Fri,  9 Aug 2024 13:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723211514; cv=fail; b=jICCLuiXe9pPldvG8UU8a/92Oyu8Aw75sq+K+jlILk7bcKuX5BRvuOG0bf7099gF6bySB2XznynyQEb0xKhL0Q9xpujO4Qq5t4HVviEAV8t5lOme/8YoTQVE5sJIQXBImP0At1CEMvII8LE2fLI0bnp7syT0uEViEZSc8JGZwjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723211514; c=relaxed/simple;
	bh=1Ra75hnxr/SMHxSkFfk3UJLVj8+D4BS4CiloTQ2ii3o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S5uuflCnLt3ZKJIk57yz1lf9p9vI0UB4VtfDTEGyyaCohJWaDaOPDSBW4BHiJR3fGbAbiPfqYYCFq8gx4Of8pv9gZxbWvFOO3hM2xIRo3IKzG68iYgEMp5scRkj5Ufb0mWYEwnX2I45TW+3nrBDu9uYUZcSqWvHWjjdX8Q0peII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZJgV7tMf; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723211512; x=1754747512;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1Ra75hnxr/SMHxSkFfk3UJLVj8+D4BS4CiloTQ2ii3o=;
  b=ZJgV7tMfMBDgcuqfui+nDI2z3vvVf7rMbxAGL6yjz6mVBvF0BS/XQH1v
   UCn/09t7equy6DoZkRlz7mzvpEFWnIf17BzCb8YZdfrEk/zJ/yxUi/FDa
   azqLBQaMoOCliG8Wh6q0ukQKRhEu8liCYh7euW2MfYMAk7kdKB0Y3FQUa
   y40cma/REFCkLZbMxvQk3ZjWFkxYG/Xurlx+P1i02tRO6C6l6VLWG5bwW
   wIILcYhPmok4ZuDCInQDhcsTNbNfbnaxiBVvimKOHw1Ph2yhtqvPwZ4rN
   IUKyZxEb7gPu9RrubOh7cYgq1QgJtHraTnT27Sym6cftLlhS+MsLpq5ZY
   Q==;
X-CSE-ConnectionGUID: l0nW+oRTQyqIQw67+qVdOw==
X-CSE-MsgGUID: TC7sznaNR+msu1Ml7ycRrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="21267918"
X-IronPort-AV: E=Sophos;i="6.09,276,1716274800"; 
   d="scan'208";a="21267918"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 06:51:52 -0700
X-CSE-ConnectionGUID: gYserc1xTcS0OA2nvepBrg==
X-CSE-MsgGUID: hfM0v3B0TLCCm0VmpMKF1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,276,1716274800"; 
   d="scan'208";a="88208391"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Aug 2024 06:51:52 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 9 Aug 2024 06:51:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 9 Aug 2024 06:51:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 9 Aug 2024 06:51:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VVHMIic9V49fvkq+1TEDqcDwGpDvWLk7srCcqk624XXuDKm3SPdLRmYeA0vsep5JxFm6vQVN9zb0pVFCuBhaFAcvpoTzhiOelLiDKttoMbY9UHuz60qGX9yxQQ8Zd6ZpqT54M5234jstIqRzZaPmItKqg/AivnO/JZdso3clzfKEF6IV50L9NQ9bqdB33nX5iGSYUAuaadWrbmFIsVDixDJ9OmKK0G66ZIqK0AdbQIGeuDY0c3G06uT2RGRABjhi4yGJj/ODbLpc/vCfmqymbYWuJaYGutVkX1DS+28MucyZY7WhQzj5CNRykQ82HHtJ/dRrBvvvXXQLw1sQbPReKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ra75hnxr/SMHxSkFfk3UJLVj8+D4BS4CiloTQ2ii3o=;
 b=ijI7+qMom8yqqRlrTt3E751T3VE2L0Emm+SFvo1UVcL+cI+zlQqoIp76P8Q/G0cnuLe1tz/rNrchPDQxvc+INp0uqFn4rEQ/I5zzuX1GudaRjOzXuWT3A6FtAN0vacEMS7Xi3LTpUWJhJ0vmgDVI/ei03fxbRzdvekjVMawr5dx3erD4urNw9OR1637c6iohhU37gneIVReyeihTyfocXaqgo3CnR2CAO3eCmmQ8qSlKrAeCQe45n8EFtQtLn+hXe3+yte+CBLp2EWXVdBlmPyAO82KZeRBxWj9/AGOkxJTAXwUVtBXT9+iVibmI7BCoxwFdjwcb7Yd5Jh2kvJ9mcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SA1PR11MB7015.namprd11.prod.outlook.com (2603:10b6:806:2b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.31; Fri, 9 Aug
 2024 13:51:48 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%3]) with mapi id 15.20.7828.030; Fri, 9 Aug 2024
 13:51:48 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: James Houghton <jthoughton@google.com>
CC: Sean Christopherson <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, Axel Rasmussen
	<axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, "Anish
 Moorthy" <amoorthy@google.com>
Subject: RE: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
Thread-Topic: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
Thread-Index: AQHa5GRjQjpjZsmMrUu/bdIMjsA4ErIcE86AgADaINCAANTngIAAZhTA
Date: Fri, 9 Aug 2024 13:51:48 +0000
Message-ID: <DS0PR11MB6373A1908092810E99F387F7DCBA2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240801224349.25325-1-seanjc@google.com>
 <CADrL8HXVNcbcuu9qF3wtkccpW6_QEnXQ1ViWEceeS9QGdQUTiw@mail.gmail.com>
 <DS0PR11MB63733F7AEC9B2E80A52C33D4DCB92@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CADrL8HWH3d2r12xWv+fYM5mfUnnavLBhHDhof0MwGKeroJHWHA@mail.gmail.com>
In-Reply-To: <CADrL8HWH3d2r12xWv+fYM5mfUnnavLBhHDhof0MwGKeroJHWHA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SA1PR11MB7015:EE_
x-ms-office365-filtering-correlation-id: f6886ad9-8ef3-457b-14fa-08dcb87a6a09
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dEZJb2RzcHRHVlZvdjFzMHNKek5Ib1lqSGsrV3dGTXRQekp5d2JFMytqZS9P?=
 =?utf-8?B?UHZyZTRVcnhOUy9sVTQ2MkJzTlNBYmR3T2UwMkszS2d1YlV4UXhpMVpMMWR2?=
 =?utf-8?B?SFhMU3NkMldYQS8wWVVtanY4SDdEZUdsZU1IVGJSSTl0VmxFWXlJSkFYclhI?=
 =?utf-8?B?WTZ5azVqZUhDQ1NpeEtydld0SDU2R3FmSnJaWlA1MWo4T3BBbVVuUlYyZUVt?=
 =?utf-8?B?VTFTVWRrR3pPZURSUWZFREFjN1NpdlQzWS9PSGFYb21USE91aVhhT0hjNmlV?=
 =?utf-8?B?bHB1cFJ6RDFyU1BjNmdhTStMVFhYbkxjTldRdkhoM0hBTEdFVSt6ZlFyc3Ba?=
 =?utf-8?B?YWZLanFSUDR3R3M1UDZVYUd1Q2JrVmZCVnl2ZFYxYk5aNVFGWnFRSFh5SVpy?=
 =?utf-8?B?MlRVQkhxVjhGN1ZBUUIwMzF3RGs3akFCRWlOOWNTY0o2RytlQndQZUMramtF?=
 =?utf-8?B?MWVwb3c3Y2J6dHZvYU5VbWd2V0dkTzlDcEwvSExrR214Vy9mNHNVRmZIWWlU?=
 =?utf-8?B?YUpvRjg2d1U0ZXM0RTVQdjYzb3FLTEUxMXkzckthY3hBbjhybkVOdlljclZP?=
 =?utf-8?B?WWcvSnRIVkpJWmdjaXVKQkVxeHlMVXlUNFoxcTVuTVFVMEc4Q2o1NXNMb0JJ?=
 =?utf-8?B?Q2JIRjhYMlRpUzdwR0pOc1p0NlBmcTllR3dXNXkyQnVhRlViT2orN0NUeWJC?=
 =?utf-8?B?dWR2QngxN1laZTV2ZnArZS9ZODcwUWRHV3RENzlEUFg5dFZ3NFFUTVdSN09R?=
 =?utf-8?B?MnB0QVdubnBCejh0RUxxbWExZFF2eFRJSkMza3hEYWlwV21pRTg0YjVwNGZ3?=
 =?utf-8?B?cjNBa2hnU29paFhVQ2FkbEdiclpGdVBveEZqVE0zQUVwRjNmQlkzTWFqV3VL?=
 =?utf-8?B?emlibGVrRXh5RndDN2FKd3pjUmpteE5WNWhGUHlMazIxS1U0QWF2QXEzVVNO?=
 =?utf-8?B?NHo4c1BzVW9VU2RlakpBNUhtUFd4VFp1dUsyQWpIS1ZPNjlydGNKRmFwMWVT?=
 =?utf-8?B?Y0hDamJjcVAxWG11a2RMOWxFYVdieVV3dlVpRFJVcWk2eERkUEpDWXlPanlD?=
 =?utf-8?B?bTF5d3Q2S2NSME1uRDJuTnYwdmFOMjUwcGF5eVowKzVTVHl4cmtSM1pjYSta?=
 =?utf-8?B?Q1EyREMvUHo0eHE5UU5xY0RRMm42bmU2UnQ0R1BXeGRwSS9USjhzT2dHRnJ3?=
 =?utf-8?B?WThPUWlwZTZyOEh2cUR5ZW1GUWpSQkZNbzFoMmFSRVBCQWFqcjJLWlF2bVBp?=
 =?utf-8?B?TTBxV0RVQXYrZVVydTlsQmFhNUFzaGh1b2RBbzBVU2xxU2ZidjdoMlRZVWIw?=
 =?utf-8?B?OXNtcTRMMEJlQVVQSENERWhGVDlRcUMvUWs4RlVMQlN4QVFWSWFtTGlZZjRI?=
 =?utf-8?B?QkU0djROMVB4UzRITzdCNU16blpKMk12eU5jajViNTNOTXRXcGo0cnlLZERw?=
 =?utf-8?B?VzJXZTBmMnViVFVUTnNlTlI1M3NiZ3krUE0vU3lYTWhIckYxQy9tQ1JZYllC?=
 =?utf-8?B?MDlYa01UdjE0MytITDQ0aXpxbmlDc294S0lNLzJTOC9pNzZkNjhXSnRxMHl4?=
 =?utf-8?B?aHZKQXlMQXU0UEZBM0dKVDRaTWxKamRUSDlveGhlU3BtSG1seUxnWFd2Q0Vq?=
 =?utf-8?B?M09IMDgrcnZWRHJFUHpCUGVMYWUrVlkrUENFSTJjc0RRamdUQnlDU3p0eXRK?=
 =?utf-8?B?U29EM2hKK0Zabk00bDZiaURxYmdKYkdnQWgyS09haGVUa3BZMXRFODkwdWpR?=
 =?utf-8?B?dlVDeGlGVnJIampVWW1xakhBTWEwVEZpM25NVWNKaHNtOTBSSk9uWTdDa0Fs?=
 =?utf-8?B?Kzl5SDhBb1l1TWk0S3ZwcVN4RnV2M3pCNDJ1SnFhQWVkazRmQWRJNXQvb3l3?=
 =?utf-8?B?ZlFNWEpvSm1OM0IwK3lQb1hHbUtTKy9yMUNlVjhZZElPR0E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUNidy9LeG5uTzkrbi9GMFFwTmxRZCt0TVdtamtnc3pGYytWVVFveExhTUFv?=
 =?utf-8?B?OHQwYVZGUFN3OVZvbVJ4S09rWURLM1ZPQkk3b3pSSk52YXZrdmpwWjhTTjlk?=
 =?utf-8?B?UWNNM21YbEEvU08wR0RBN0NZNUd3YUpWczk3Z1pubGJGSXZyYXlTU1VnbGwv?=
 =?utf-8?B?MWh5RGJLbG4zbkRVcXJPdzBmS1FVRWk2ZzZJU1NTdXA3bHBscjN4eVFTZElY?=
 =?utf-8?B?MFRGTEczY2kxMjROejJZeGF5SE1IT1hsSWV0WXhJZ2xiSVRlcUdCRDFhMjZr?=
 =?utf-8?B?djN2UzNUK0NKck1jZjNhUDNFY2tyN0pSYW5YSitYMzZFNlkyU21CVmpIYTFX?=
 =?utf-8?B?T0xZcVRlU3ZNbmZuY0M1L2pKeWl4WkdCRzdMQU02SWJiMTZFM3Y5bzhnVEVn?=
 =?utf-8?B?alh6YS9iaS9xQ2ZyZG1ZaytMTzlydy9wVFE3MEo2U0dYNXNxdUJYN2VldFU5?=
 =?utf-8?B?WmJPeG9qTC91Q0F4OFpLSzEyQytZL1VNQWttbmtJVitkb3FYTUhHWksrOHp4?=
 =?utf-8?B?K3hCQ0lUWFdqVzkwSXpYN05Pd1RLM2xNK1hsYUNNODBTOXhpaWg3UVdQOTJ4?=
 =?utf-8?B?S2RJcWdMVXBVNXlzTTVaTVNYYUtZQ0cxVmFrckdXYjZ4YzB3UEJrcGZDMU9J?=
 =?utf-8?B?L3lRdTdDR2hZSDkvQjdncWN6MWlKZW1OL0Q4UHNCdndIMGxGSWY2dHFhZTg4?=
 =?utf-8?B?ZWRwK0I3VXp3U1pIZ2tpb25zTDFwcEZOTUo1Yzh3bWpDbWpLOHpaRk55Zzlm?=
 =?utf-8?B?L2t1TDRKclU5QXJJblJ1RnBKenltOUV0QndsZ1l2WDFDWHlNR1NqcWNGMEpR?=
 =?utf-8?B?QURjUnVhOU1vRHRqclJNUkdkQzhHL2Z3SS9tQW1JYVVkZ0RvVEpjYVdGenV3?=
 =?utf-8?B?MGVWdVZ5QkRiZEFOMW1FdUV1TEkzdU14U3BYQXBTNjE3ZkhSdkJDbXlocCtO?=
 =?utf-8?B?bGUwNEJJTExQWWVYcUx2ZGZmYTgvRUNDeU9Ubm96dVRNTmVWN2xLN0hhZC9W?=
 =?utf-8?B?d2pMcnNLMW4zMkpCZVphK3d3L0pWRHUzR1phcnlFS0g0Z2svbzJFOTZHL2dR?=
 =?utf-8?B?RDVDTTg5d0dwQXczcG5QYUdYQWNWcDZDbDM1Q2wwYXh6ZElKZmZ1N053UUJO?=
 =?utf-8?B?VzBtV1BmR2pjYWErV0laaERpVUxIRjg3QzMrNTFyaDloQmNZNm5BU2FRckpa?=
 =?utf-8?B?T2Z4WU5HSjEvdUphbGRNZEdoL3BwL1FQaHFUcFp0TEJmR0tDZkN1WXdwV0xZ?=
 =?utf-8?B?ZEFXZGFybDFsKy9ETE9BMWdjQ0pkcFlGUmt3T2VyTng0Uk96eG4xcU5uLzZu?=
 =?utf-8?B?TG1QNzVFVXN3WEpmVXludHV2d1lTaVlGTjd2YVdDK2prVzlTTE9PSmJVQ24r?=
 =?utf-8?B?c3hKYjk0NW5aMjNqd0Rsd0QxdWg4bG9DVEhKb1gyN0pUT2pacnhmSEMxSGJq?=
 =?utf-8?B?V3M4dG1WcWZBbFdRQ0VQUGZDSnRZV0Nwei9wcDVRcmE3dmJ0b1ZEZEdwK2Ux?=
 =?utf-8?B?TTRlbzYyTy92UVlYc0l2MGpCTDBkelN4bVNGS1IrQjRiVTQvRnZpTTdTRG1I?=
 =?utf-8?B?MFkwWDRRYUJkcWlZVXFjb3k2VFIydmQ3SVdNVjY1NVcyK09UUi9uTWg0OUZT?=
 =?utf-8?B?QWFtSlZGRkVnMmd0UzBEOWs4U0IzZXRTK3pFOS9VZDRZU1lyQ3JRWE9sNkFa?=
 =?utf-8?B?TDB3SDBGVHFlVSs5TDVadnQyUDE4UjMvSXpkMGI4bktBTkRzZ2tJV1hCQms2?=
 =?utf-8?B?M1o1R2ZOOHM1MjNtZENNYzNWQ1JNcC9hUFcvNmowVXowR01TYkFBd3RlaEts?=
 =?utf-8?B?ODhFMmp1UEZkM25uemFDOW1qdktFVjJzQ1NUVWxSVjJDZ3dNbnN0aCtXc0Zw?=
 =?utf-8?B?VGwxRjFZSk9XT0JEYXp4Mkw3OVBETHNzcVYyQWhHMWJFMjFhdHAvenFtanpT?=
 =?utf-8?B?N1p0bGZ3cGNvTmZPMXp0S0JsUzMxK0VqOFNGZ3JLVFUrY0hkSVd3cW1SUlBz?=
 =?utf-8?B?aHpSRFhnZ1BSSnZ4ZlduTm8wRy95VnFkR0Q1RHBOR0w5MGpIMXVsUWMxZ0lG?=
 =?utf-8?B?ZjB5TEE3VlFwNVpIWWtsTHFCeCtWM1lUUEZCZUxyVFBleHlrQS9vWDhFb2ln?=
 =?utf-8?Q?9AFUf9M6lQjTzV5ZJDi//GDaN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6886ad9-8ef3-457b-14fa-08dcb87a6a09
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 13:51:48.3917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8bQgtrKcXjlsVnfMs9h3wexd+zzK6tpKBwPnklFZ1NFRP/nuTgrPwdaPb43tJVSgCdDTqlduJbwEd6favINlMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7015
X-OriginatorOrg: intel.com

T24gRnJpZGF5LCBBdWd1c3QgOSwgMjAyNCAzOjA1IEFNLCBKYW1lcyBIb3VnaHRvbiB3cm90ZToN
Cj4gT24gVGh1LCBBdWcgOCwgMjAyNCBhdCA1OjE14oCvQU0gV2FuZywgV2VpIFcgPHdlaS53Lndh
bmdAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IE9uIFRodXJzZGF5LCBBdWd1c3QgOCwgMjAy
NCAxOjIyIEFNLCBKYW1lcyBIb3VnaHRvbiB3cm90ZToNCj4gPiA+IDEuIEZvciBndWVzdF9tZW1m
ZCwgc3RhZ2UgMiBtYXBwaW5nIGluc3RhbGxhdGlvbiB3aWxsIG5ldmVyIGdvDQo+ID4gPiB0aHJv
dWdoIEdVUCAvIHZpcnR1YWwgYWRkcmVzc2VzIHRvIGRvIHRoZSBHRk4gLS0+IFBGTiB0cmFuc2xh
dGlvbiwNCj4gPiA+IGluY2x1ZGluZyB3aGVuIGl0IHN1cHBvcnRzIG5vbi1wcml2YXRlIG1lbW9y
eS4NCj4gPiA+IDIuIFNvbWV0aGluZyBsaWtlIEtWTSBVc2VyZmF1bHQgaXMgaW5kZWVkIG5lY2Vz
c2FyeSB0byBoYW5kbGUNCj4gPiA+IHBvc3QtY29weSBmb3IgZ3Vlc3RfbWVtZmQgVk1zLCBlc3Bl
Y2lhbGx5IHdoZW4gZ3Vlc3RfbWVtZmQgc3VwcG9ydHMNCj4gPiA+IG5vbi1wcml2YXRlIG1lbW9y
eS4NCj4gPiA+IDMuIFdlIHNob3VsZCBub3QgaG9vayBpbnRvIHRoZSBvdmVyYWxsIEdGTiAtLT4g
SFZBIHRyYW5zbGF0aW9uLCB3ZQ0KPiA+ID4gc2hvdWxkIG9ubHkgYmUgaG9va2luZyB0aGUgR0ZO
IC0tPiBQRk4gdHJhbnNsYXRpb24gc3RlcHMgdG8gZmlndXJlDQo+ID4gPiBvdXQgaG93IHRvIGNy
ZWF0ZSBzdGFnZSAyIG1hcHBpbmdzLiBUaGF0IGlzLCBLVk0ncyBvd24gYWNjZXNzZXMgdG8NCj4g
PiA+IGd1ZXN0IG1lbW9yeSBzaG91bGQganVzdCBnbyB0aHJvdWdoIG1tL3VzZXJmYXVsdGZkLg0K
PiA+DQo+ID4gU29ycnkuLiBzdGlsbCBhIGJpdCBjb25mdXNlZCBhYm91dCB0aGlzIG9uZTogd2ls
bCBnbWVtIGZpbmFsbHkgc3VwcG9ydCBHVVAgYW5kDQo+IFZNQT8NCj4gPiBGb3IgMS4gYWJvdmUs
IHNlZW1zIG5vLCBidXQgZm9yIDMuIGhlcmUsIEtWTSdzIG93biBhY2Nlc3NlcyB0byBnbWVtDQo+
ID4gd2lsbCBnbyB0aHJvdWdoIHVzZXJmYXVsdGZkIHZpYSBHVVA/DQo+ID4gQWxzbywgaG93IHdv
dWxkIHZob3N0J3MgYWNjZXNzIHRvIGdtZW0gZ2V0IGZhdWx0ZWQgdG8gdXNlcnNwYWNlPw0KPiAN
Cj4gSGkgV2VpLA0KPiANCj4gRnJvbSB3aGF0IHdlIGRpc2N1c3NlZCBpbiB0aGUgbWVldGluZywg
Z3Vlc3RfbWVtZmQgd2lsbCBiZSBtYXBwYWJsZSBpbnRvDQo+IHVzZXJzcGFjZSAoc28gVk1BcyBj
YW4gYmUgY3JlYXRlZCBmb3IgaXQpLCBhbmQgc28gR1VQIHdpbGwgYmUgYWJsZSB0byB3b3JrIG9u
DQo+IGl0LiBIb3dldmVyLCBLVk0gd2lsbCAqbm90KiB1c2UgR1VQIGZvciBkb2luZyBnZm4gLT4g
cGZuIHRyYW5zbGF0aW9ucyBmb3INCj4gaW5zdGFsbGluZyBzdGFnZSAyIG1hcHBpbmdzLiAoRm9y
IGd1ZXN0LXByaXZhdGUgbWVtb3J5LCBHVVAgY2Fubm90IGJlIHVzZWQsDQo+IGJ1dCB0aGUgY2xh
aW0gaXMgdGhhdCBHVVAgd2lsbCBuZXZlciBiZSB1c2VkLCBubyBtYXR0ZXIgaWYgaXQncyBndWVz
dC1wcml2YXRlIG9yDQo+IGd1ZXN0LXNoYXJlZC4pDQoNCk9LLiBGb3IgS1ZNIHVzZXJmYXVsdCBv
biBhIGd1ZXN0LXNoYXJlZCBwYWdlLCBob3cgaXMgYSBwaHlzaWNhbCBwYWdlIGdldHMgZmlsbGVk
DQp3aXRoIHRoZSBkYXRhIChyZWNlaXZlZCBmcm9tIHNvdXJjZSkgYW5kIGluc3RhbGxlZCBpbnRv
IHRoZSBob3N0IGNyMyBhbmQgZ3Vlc3QNCnN0YWdlLTIgcGFnZSB0YWJsZXM/IEFkZCBhIG5ldyBn
bWVtIHVBUEkgdG8gYWNoaWV2ZSB0aGlzPw0KDQpUaGVyZSBhbHNvIHNlZW1zIHRvIGJlIGEgcmFj
ZSBjb25kaXRpb24gYmV0d2VlbiBLVk0gdXNlcmZhdWx0IGFuZCB1c2VyZmF1bHRmZC4NCkZvciBl
eGFtcGxlLCBndWVzdCBhY2Nlc3MgdG8gYSBndWVzdC1zaGFyZWQgcGFnZSB0cmlnZ2VycyBLVk0g
dXNlcmZhdWx0IHRvDQp1c2Vyc3BhY2Ugd2hpbGUgdmhvc3QgKG9yIEtWTSkgY291bGQgYWNjZXNz
IHRvIHRoZSBzYW1lIHBhZ2UgZHVyaW5nIHRoZSB3aW5kb3cNCnRoYXQgS1ZNIHVzZXJmYXVsdCBp
cyBoYW5kbGluZyB0aGUgcGFnZSwgdGhlbiB0aGVyZSB3aWxsIGJlIHR3byBzaW11bHRhbmVvdXMg
ZmF1bHRzDQpvbiB0aGUgc2FtZSBwYWdlLg0KSSdtIHRoaW5raW5nIGhvdyB3b3VsZCB0aGlzIGNh
c2UgYmUgaGFuZGxlZD8gKGxlYXZpbmcgaXQgdG8gdXNlcnNwYWNlIHRvIGRldGVjdCBhbmQNCmhh
bmRsZSBzdWNoIGNhc2VzIHdvdWxkIGJlIGFuIGNvbXBsZXgpDQoNCj4gDQo+IEtWTSdzIG93biBh
Y2Nlc3NlcyB0byBndWVzdCBtZW1vcnkgKGkuZS4sIHBsYWNlcyB3aGVyZSBpdCBkb2VzDQo+IGNv
cHlfdG8vZnJvbV91c2VyKSB3aWxsIGdvIHRocm91Z2ggR1VQLiBCeSBkZWZhdWx0LCB0aGF0J3Mg
anVzdCBob3cgaXQgd291bGQNCj4gd29yay4gV2hhdCBJJ20gc2F5aW5nIGlzIHRoYXQgd2UgYXJl
bid0IGdvaW5nIHRvIGFkZCBhbnl0aGluZyBleHRyYSB0byBoYXZlDQo+ICJLVk0gVXNlcmZhdWx0
IiBwcmV2ZW50IEtWTSBmcm9tIGRvaW5nIGEgY29weV90by9mcm9tX3VzZXIgKGxpa2UgaG93IEkg
aGFkDQo+IGl0IGluIHRoZSBSRkMsIHdoZXJlIEtWTSBVc2VyZmF1bHQgY2FuIGJsb2NrIHRoZSB0
cmFuc2xhdGlvbiBvZiBnZm4gLT4gaHZhKS4NCj4gDQo+IHZob3N0J3MgYWNjZXNzZXMgdG8gZ3Vl
c3QgbWVtb3J5IHdpbGwgYmUgdGhlIHNhbWUgYXMgS1ZNJ3M6IGl0IHdpbGwgZ28gdGhyb3VnaA0K
PiBjb3B5X3RvL2Zyb21fdXNlci4NCj4gDQo+IEhvcGVmdWxseSB0aGF0J3MgYSBsaXR0bGUgY2xl
YXJlci4gOikNCg0KWWVhaCwgdGhhbmtzIGZvciBleHBsYW5hdGlvbi4gDQpFbmpveSB5b3VyIHZh
Y2F0aW9uLiBXZSBjYW4gY29udGludWUgdGhlIGRpc2N1c3Npb24gYWZ0ZXIgdGhhdCA6KQ0K

