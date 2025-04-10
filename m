Return-Path: <kvm+bounces-43067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD66A83B2A
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:31:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A23C8444D4D
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1184D20B7E9;
	Thu, 10 Apr 2025 07:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IBTCKrf9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4602F1FA262;
	Thu, 10 Apr 2025 07:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744270120; cv=fail; b=S6CqNo1e9ZX2TTtCaCzUvXIHwnV9uRDpExtrO4WK5EwAtDHUGAm2f1h8MRp7JxUIv7i0dvZfKYEW6nv9cYJqyjoPxMA/njfPfpyVZny5FTLcrMOctdm14q1CP+E2C3CEbmIIxi6U6I0CrQz7uLbmdghnrBq1JT6HLWxXXGUh1xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744270120; c=relaxed/simple;
	bh=EqAnjqchL9r+WHseQ55I8GSkqSqQocYRB+rFp7mFfUY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l1aGoipDG2FdUaxlFrjbPjmaKz056idRyt+XUr9wCEztKeRqs6+cgr/Rb4utzii2I7K8wNAS4Rx6WmSDkGJT0javgu7/6w3/yHV2g7op0ML9PvXzL5mDjoMDT2cxiyDHiuLeqSRGFnOYcOoTHtDZGpBsL1cHo1g4VlGX64cePP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IBTCKrf9; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744270118; x=1775806118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EqAnjqchL9r+WHseQ55I8GSkqSqQocYRB+rFp7mFfUY=;
  b=IBTCKrf92QWQEzDczWOuUGVjFwvMuGRmiwMQYn/2xQTFR1OoWHVW2gaV
   rZZwTVtnh/Brr2GcjLgPxJNFhwcNyVYy32Wjaktu02On+L63dWhyWo4Y6
   cfqkkE2GiOVuUsfhm6v2NKwUS/200iTz3dsf4QM5TdPRhja6rMPmmWdTR
   ChGGa3RGr14WuV6lpFZ2OFK4+jYRTZvUVvIhNkZ41vrOfQRFlWViPTvcP
   EZFX54o45TGKT991O8FN5a8bLp47QTUqIMDbKY86dQVEuv+xuWv8omSK+
   UgOo0V3FsOsMEdEjxIshxHSxPH9wjk+B98CBwyjUjYEwA/dzp6r6JG3YF
   g==;
X-CSE-ConnectionGUID: haVgXKx8SIWAs4ULTCiA6A==
X-CSE-MsgGUID: QeVtkROKRlGabbSohj5HIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="33381176"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="33381176"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:28:37 -0700
X-CSE-ConnectionGUID: cS15AIB9Q1iYUALdyYfS4w==
X-CSE-MsgGUID: PVYdnZGdThOQCRTHLgkikg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="134010169"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:28:37 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 00:28:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 10 Apr 2025 00:28:36 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 10 Apr 2025 00:28:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ETM0sIiO2Gv9ICTXkET9lcy9KZ/EU6xwX/PPBEiNQssoz5TvIMJr4bNnpWQqWHE6e4tIml5GntH+8PAUIncM+nqw+3xBuudsN/Me3Y+p3weYkJJLBmZSOhRVjJhb127YHZlAaGDpMwiDdt1P/4YPK8RgdM+CXVDturcYXYxzy12gwg7La8d2x2FniTuCsmPyoZMzNeFe+skiVU0P+MoG1sv/PNkFR9rmsS7enJmZeAIAAxpbMTzObsUMXNdUMZ2ct+ZdnGmYkEhw7GX1l4bfOvPvU68KwODeC97FWKZ+DryodJktZfYjyvMVf8nKf9RXY72FTMgWfIhRsIB4mIV/jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EqAnjqchL9r+WHseQ55I8GSkqSqQocYRB+rFp7mFfUY=;
 b=WBe15X6QkuqDs16Cou0Vq82Bc7UZAhjXb948Wbogn3rrZQWlrsci8npWLNjUGl84mvLPMcGiJq9K3Q4PwnZgK/ER3Xt7gKpJZ+sBYmGWqWOWdspGmX1Ha2LdLkkcAAUgSKhDRwELaiMJ59t5fX4OWexHop6hiCa9M+rM/H4e4VmEaYpfR2zXtrqhcQw27BCqi7j4qIIrDlehdAm7tum0oiYKxD0Fu3MVisILo6t0yCFTmlAO/zp9YeCzmBRSe/Rn8ouKbC45mCYx6T/lCsu+eVuJLfk7Tv/ThLGJEwkKtuoSKGAggT+Jmvde2C19FaCk2awMuY+gCZLEpS5Sk2czlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6871.namprd11.prod.outlook.com (2603:10b6:806:2b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.42; Thu, 10 Apr
 2025 07:28:34 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 07:28:34 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, Like Xu
	<like.xu.linux@gmail.com>, Yong He <alexyonghe@tencent.com>
Subject: RE: [PATCH 3/7] irqbypass: Take ownership of producer/consumer token
 tracking
Thread-Topic: [PATCH 3/7] irqbypass: Take ownership of producer/consumer token
 tracking
Thread-Index: AQHbpabUe8Rn8c3xck2wQxzYMRzxarOchT2A
Date: Thu, 10 Apr 2025 07:28:34 +0000
Message-ID: <BN9PR11MB5276385B4F4DB1919D4908CF8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250404211449.1443336-1-seanjc@google.com>
 <20250404211449.1443336-4-seanjc@google.com>
In-Reply-To: <20250404211449.1443336-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6871:EE_
x-ms-office365-filtering-correlation-id: 9bb36745-e9d9-4a78-f1ce-08dd78014d4b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YTNMK0prb2oxTUMvaXNuMXpJUHZFWldtWDF6MDhSTFBRaDdsMm9aZG82K1kr?=
 =?utf-8?B?SlBlYzRNQzJ5bVJ4OGtROEc2eFN0ZWZ0ZlhlNWt5b25WeVFOWGo1NnpzMjV1?=
 =?utf-8?B?TGlFZ0xLci9TTUlFK0hzVXAva2phVE5EanZXMmVoMG9lTGRrZElxdVk1YXV3?=
 =?utf-8?B?cnE3R3lvNGhRanNjbHdsSENvNDBLR2EzNEtpNERHLzFSNW9ZRjZuVXprbnd3?=
 =?utf-8?B?Q3VBaVVMQk9QdkRGblJFWTRtTXpWTHBNajZaZ1o3SEcwdjlrY3dFQ1JHWWNj?=
 =?utf-8?B?MTdDa3ZzdUU0alkwQzk0eGcyQXdrOEJTbk84NThmS2NWdDBlMUtJLy9uQVRa?=
 =?utf-8?B?Y0NWTERBYUN1WVR5VWVweHl2WVdWYWlMTGJmby9DL2hBb21tK3dTVDB2Tys5?=
 =?utf-8?B?SkF1aERneWQ0dEhUZjdnTUwxd0d3dVN5UnJkWVdWL0pObi92NnhFeWZtZFFo?=
 =?utf-8?B?aW9QUE5NdTFiSk0wMS90ZFpSZzVObkN4b3dXcktUM1d3MENLbUJiTkkxdzQy?=
 =?utf-8?B?QVk3Rk5TdXRSR2JDUmoxVk1MVXNzeGkrL3dWQTFZOUtrRFpxZkhuT2c4cm1q?=
 =?utf-8?B?bTBXemFtZmJKaGxpNTVqdytzb2JLdG5WWE9xdG1yclkxY2xQa0dsUlM5VElK?=
 =?utf-8?B?aWcwZjk4Qk1wM2FsWXRtZ3dyRDFtaFlQQnBvemhBRnFZcE1KVzBKWWg0U05T?=
 =?utf-8?B?REsvTU42T001eGhqSWlWcGZwYlp0T2FhOEcrUTNJbE1hSFBxOWpnZ2x5VXRM?=
 =?utf-8?B?MXpxdEZtQzFCU1ZOUXVMWkdiT0FIUTh0MCtMRHlhSlZpWTA3QmFoVXdkUzhv?=
 =?utf-8?B?WGs5VU1RQ2FKQ2xpT2haU1lIZldMYVVxRUwwNVZmK3R1cEpjbnFCRGZ5d1JP?=
 =?utf-8?B?cU1KU0NTbmZNaG1Ydm1VZ2NCakxReWVnNVJPTS9malFoek41RXErdjFkOHN4?=
 =?utf-8?B?UVg5K2dWNmRmYVBtY05zV1lsUGhVT1JJYXp2MmZXa01tSjNReUlLU3k3ckJy?=
 =?utf-8?B?MTVpL3Y3MzBldTdpSk1jWWU5YzVTNUJwRkFCSmEwMXIvSGorQ01xYUJ5ZWZo?=
 =?utf-8?B?Q29GcmFJM1VuY3ZKcVcwb24yY0R5QnJRVG0rTG1WWk55Zy9GRVUwZmRmMUU3?=
 =?utf-8?B?VE5NZFVLT1ZJM2pJak1zcVNLUGo5aml1MmRXbEIrMDl0YVFjY3BJeGQyTG9x?=
 =?utf-8?B?bHVFRHJwRVJMR3pmV3FUam5OOFBMTVJJUjcyOGQ1aWw0YytrWlhNbWZEOEdL?=
 =?utf-8?B?OW9UTXc0YjZXQk9PN1VNd1RlSVdoVXRhSXMxZEM1MVJNTDJkNUdQWm80dmxC?=
 =?utf-8?B?TUd4NTc5OXZZUnM1bVBYV0ZONmxDcUtQKy9hdFlRRERMT2pBUGwybVJxcnJS?=
 =?utf-8?B?WGJpYUxOTWM4bGJEbVZnZ0dEVEtCR2kwRnNVMFZqNnB4N0tVbWFORnUxaHZD?=
 =?utf-8?B?Q082UUF3VVZQbFhHNnM4OUlUQjIvdkJ1RkJKS0F5VTBxVG1uL0hYcTRicHVF?=
 =?utf-8?B?UUtrU1BJa1ZhRkp0TU5ObC8rbVRQWUlkL2VOZFlQK251Ym9iT0ptMm5Pb0tt?=
 =?utf-8?B?SGpZOWV1NXo2SlUvUEx1cXRwU1drQUVnVElvbEFtVjNqM1Q2VkZ2SHYzQ0h0?=
 =?utf-8?B?aWRoRlladzhnYUlXOTRmaTdDeDlXd0Rhcms0MW5pb2V2WmlualdFS1lkT2JC?=
 =?utf-8?B?TTBSeWtWNzd3T0pEQXBRNXVEUVNGS25LV0h3RUNLaW1iWXdDNDZMZHppRm1V?=
 =?utf-8?B?VU1MU0trS2Y5L21NQXZwMmxBSGxNUlFURktQaVZGNGxPanlBeVQwTitaLzcw?=
 =?utf-8?B?alRZWXczd2o4MFE0WVF6Qit6ODNzR1BqbG11bFNGdDM4RHY0bHBRYk9mbnpt?=
 =?utf-8?B?TVhjbFBMQmtlc0s0VTRra0NFL2x1TGI4eG1EclloNERpbjEwNVRMMWVjSDRJ?=
 =?utf-8?B?ZGxlOGxsRnM4VGQ4ME1MVjk0cVIxOFp2OHJ3bS9Ici9NK3R1UmZCV0VvRDhr?=
 =?utf-8?Q?SCu8GqgBsZo2rYFUPOhXA5haKZPgCI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2JQcXNmYzJIb0hDYXJtQythaTV1ZjFLRXBtQ0ZzR3E4ZGpqbHEyK0pWMUVF?=
 =?utf-8?B?c0E3U3hpSVRHaHZObVRCWW1RRXhUUkNSSlA3TVc3dFA5cENWb2Q1MzUvNmxr?=
 =?utf-8?B?T3Nzd0pFdS93Q0JvcDU4ZjY5UVlZSkNobHVrWFhHMSthcnRtVW5VTWxmZXo3?=
 =?utf-8?B?eGdDdXRqNnE5UzJobEdCaEhSZ1E3a0RtdGY3YVora0VaZzZ0TGNEbXF0cTU2?=
 =?utf-8?B?OFVJT0tJUTIxYU5HQ3o5c1ZYQk9GbjdTV2NiTkZqWHVYMUt4eldSRTdrWllw?=
 =?utf-8?B?YnExWTJzZERIdThScWsyTUs2TmVpc2hXTGpYczNDZElmeGl2czB4VlZkaVk4?=
 =?utf-8?B?R0NWdUhXM2E1UW5zcmtSaHFwODFhdk5pT1ZHWnFyRDVMaUo1T1E0WTlPRVI3?=
 =?utf-8?B?WHZ1b2gyY2VFRW1nUVBKRmt1VEZjcVVjTVVBYVhmTzczK1VQQndMYko0N0dD?=
 =?utf-8?B?L2VTWHdMemh2TjhVVFRxVXlSL0trTmY5WUdqL3h3VnR4clFKc0k4MnRLL0RD?=
 =?utf-8?B?ZmdPMlByZksxOExsSFRVZXR6S09kRUwweXlkdkVlNU9RV0VmWHJyS0ZzR2lu?=
 =?utf-8?B?T0ZHRDNuK1hCK2VyVVk0SXBPcDJrQVloQWJFZW44aXpsOFJTS1RuWE1TQ1VO?=
 =?utf-8?B?VUYxWjF5OWFDOU9IbU5xV2dISmdBZC9RTlFRdDJqUkhUTkF1T091Z0xlcVpC?=
 =?utf-8?B?c0R4WU1xMmNnZmc3N0JDd1ZtWVdTQ0M0Znc0ck1VWFVYTCtCdGpCdmpWK0NY?=
 =?utf-8?B?N1BMeDJoanI5VGhDZHBjb3ExemNSaG81QTlwbTlPcE1weDNNRWYreGJndHBU?=
 =?utf-8?B?VnE1OEdPS2krUmwwMlRXK1Z5Q1MvYUpqQ0dDd1JFS05BbXpveG5wQWVWN1Ru?=
 =?utf-8?B?MjZhVisrUkZUQ2hnaU1FclFGNzBzRDhVR0lMU21VcGJETFZFQ3h6ZHc2VVFX?=
 =?utf-8?B?TXcvVit4eW1WckJTdkV3dlNURzZHQlFaOU0rUDQ5R2JRU1EzTlhZaHZKeTdk?=
 =?utf-8?B?eUdTUk45K244cVdRNXA2MGVENEx2dWFTUWRQalVWYm52ekVTdEVoNmloNXVF?=
 =?utf-8?B?am5oc2VOQU5YTUFrSXVyT0Q5NkZwbVNLY1hpMHhGOEFBczhCNWRRMFhCSGRN?=
 =?utf-8?B?NUt5Y09QWTlqWGhzOGQyb1FEN2RyK1V1ZXRqM0NYMU1IMktHcG1UYThFRHJE?=
 =?utf-8?B?c0Y0SVoyNWFJOUpteS9rNzkwT2VBYWtZSUpJNlpDemdIUWxLa0tsS1E5aml2?=
 =?utf-8?B?azRFanZNWVUyWThlZFU2WDR1bXhQZk0zdTJyZENpSDNLMUJ3dDYrOTlGa2xE?=
 =?utf-8?B?dXQycStSWFVBZ3JuakVaMUQ1eXJ1K2lzSFlDL0dTcFNNT1BEcDhMVmFUaWRX?=
 =?utf-8?B?dE5MWW9OdG1udysrUCt1Z2NCVWhtUVhrNG5tenpRYklSMTcvUDMyb1VNVUUx?=
 =?utf-8?B?bExoYi9xMks2V2lwMzlRMUt2SnV3a1AzT2tlSXpaRkFURVVLdjZ1NVlLNEVr?=
 =?utf-8?B?S3o1eUp5OWgzMGNtTUZRbEdFYkVUSlI2eUp6SDBDdDZGNVRMQklLT0JvVHU4?=
 =?utf-8?B?UmI3OGViYUlUU0wrbitxNXY4MWtPaHZOdEMyVlJyQ2hySW94ZFpUQnQwMm1D?=
 =?utf-8?B?OUtwSVp2dzVtSWowak9jUEROSzArWmhFbTFCNldXZS9CQlFPeW81UUk2cjRE?=
 =?utf-8?B?Vk91NkpYb0pMazlzRXU2TlFmb1F2TFlnampvMG5rQ3VidkIzN0RhU2tXOW1O?=
 =?utf-8?B?MnBiZmhCSE9KbUJyMGR0T0JKVWZOKzRFOHRwUjNVSkUvQnBDU3RwOVMybSs0?=
 =?utf-8?B?TFRtMHFRWVJlZHNSa0FyQnZ0L1o4a2lTRExZaitQVGRBVWt1R010cnoxU0Ji?=
 =?utf-8?B?S2hxeE1uMEk2SkdZNFZOOFk5QnVwVkdzemxidE81b1padDQ1NnFndzhiZE01?=
 =?utf-8?B?K1IrYUZQZXY2S3BVMzNOT2JmRFBWVTFyazN3QnF3ZERMeUhPbHJ4enlsVHFC?=
 =?utf-8?B?Y0xWVTVtMXk3K251OUdZS21tVEM0Q3RranlUZ1YycGZBRStpcUJrTnZvVTlG?=
 =?utf-8?B?cHV6VE9Jd1ZSUVZ6a00ydFFjV0tYVmVHWm5BL1hQaDAyT0FkNWNaL3g4dDJX?=
 =?utf-8?Q?kbTxYCHFb8HHwZOkfLxX5M9fW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb36745-e9d9-4a78-f1ce-08dd78014d4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 07:28:34.3530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QhDXtxEUv0ut5nQFa55vMk8mJn8656F/IUBudFG3BKtonyNp39ogHpAj8xujYkMnNyyRE9pqYu8dew3dg0RDxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6871
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
U2F0dXJkYXksIEFwcmlsIDUsIDIwMjUgNToxNSBBTQ0KPiANCj4gQEAgLTUwNSwxNSArNTA1LDEy
IEBAIHN0YXRpYyBpbnQgdmZpb19tc2lfc2V0X3ZlY3Rvcl9zaWduYWwoc3RydWN0DQo+IHZmaW9f
cGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiAgCWlmIChyZXQpDQo+ICAJCWdvdG8gb3V0X3B1dF9l
dmVudGZkX2N0eDsNCj4gDQo+IC0JY3R4LT5wcm9kdWNlci50b2tlbiA9IHRyaWdnZXI7DQo+ICAJ
Y3R4LT5wcm9kdWNlci5pcnEgPSBpcnE7DQo+IC0JcmV0ID0gaXJxX2J5cGFzc19yZWdpc3Rlcl9w
cm9kdWNlcigmY3R4LT5wcm9kdWNlcik7DQo+ICsJcmV0ID0gaXJxX2J5cGFzc19yZWdpc3Rlcl9w
cm9kdWNlcigmY3R4LT5wcm9kdWNlciwgdHJpZ2dlcik7DQo+ICAJaWYgKHVubGlrZWx5KHJldCkp
IHsNCj4gIAkJZGV2X2luZm8oJnBkZXYtPmRldiwNCj4gIAkJImlycSBieXBhc3MgcHJvZHVjZXIg
KHRva2VuICVwKSByZWdpc3RyYXRpb24gZmFpbHM6ICVkXG4iLA0KPiAgCQljdHgtPnByb2R1Y2Vy
LnRva2VuLCByZXQpOw0KDQpVc2UgJ3RyaWdnZXInIGFzIGN0eC0+cHJvZHVjZXIudG9rZW4gaXMg
TlVMTCBpZiByZWdpc3RyYXRpb24gZmFpbHMuIA0KDQo+IEBAIC0xOCwyMCArMTksMjAgQEAgc3Ry
dWN0IGlycV9ieXBhc3NfY29uc3VtZXI7DQo+ICAgKiBUaGUgSVJRIGJ5cGFzcyBtYW5hZ2VyIGlz
IGEgc2ltcGxlIHNldCBvZiBsaXN0cyBhbmQgY2FsbGJhY2tzIHRoYXQgYWxsb3dzDQo+ICAgKiBJ
UlEgcHJvZHVjZXJzIChleC4gcGh5c2ljYWwgaW50ZXJydXB0IHNvdXJjZXMpIHRvIGJlIG1hdGNo
ZWQgdG8gSVJRDQo+ICAgKiBjb25zdW1lcnMgKGV4LiB2aXJ0dWFsaXphdGlvbiBoYXJkd2FyZSB0
aGF0IGFsbG93cyBJUlEgYnlwYXNzIG9yIG9mZmxvYWQpDQo+IC0gKiB2aWEgYSBzaGFyZWQgdG9r
ZW4gKGV4LiBldmVudGZkX2N0eCkuICBQcm9kdWNlcnMgYW5kIGNvbnN1bWVycyByZWdpc3Rlcg0K
PiAtICogaW5kZXBlbmRlbnRseS4gIFdoZW4gYSB0b2tlbiBtYXRjaCBpcyBmb3VuZCwgdGhlIG9w
dGlvbmFsIEBzdG9wDQo+IGNhbGxiYWNrDQo+IC0gKiB3aWxsIGJlIGNhbGxlZCBmb3IgZWFjaCBw
YXJ0aWNpcGFudC4gIFRoZSBwYWlyIHdpbGwgdGhlbiBiZSBjb25uZWN0ZWQgdmlhDQo+IC0gKiB0
aGUgQGFkZF8qIGNhbGxiYWNrcywgYW5kIGZpbmFsbHkgdGhlIG9wdGlvbmFsIEBzdGFydCBjYWxs
YmFjayB3aWxsIGFsbG93DQo+IC0gKiBhbnkgZmluYWwgY29vcmRpbmF0aW9uLiAgV2hlbiBlaXRo
ZXIgcGFydGljaXBhbnQgaXMgdW5yZWdpc3RlcmVkLCB0aGUNCj4gLSAqIHByb2Nlc3MgaXMgcmVw
ZWF0ZWQgdXNpbmcgdGhlIEBkZWxfKiBjYWxsYmFja3MgaW4gcGxhY2Ugb2YgdGhlIEBhZGRfKg0K
PiAtICogY2FsbGJhY2tzLiAgTWF0Y2ggdG9rZW5zIG11c3QgYmUgdW5pcXVlIHBlciBwcm9kdWNl
ci9jb25zdW1lciwgMTpODQo+IHBhaXJpbmdzDQo+IC0gKiBhcmUgbm90IHN1cHBvcnRlZC4NCj4g
KyAqIHZpYSBhIHNoYXJlZCBldmVudGZkX2N0eCkuICBQcm9kdWNlcnMgYW5kIGNvbnN1bWVycyBy
ZWdpc3Rlcg0KPiBpbmRlcGVuZGVudGx5Lg0KDQpzL2V2ZW50ZmRfY3R4KS9ldmVudGZkX2N0eC8N
Cg0KPiAraW50IGlycV9ieXBhc3NfcmVnaXN0ZXJfY29uc3VtZXIoc3RydWN0IGlycV9ieXBhc3Nf
Y29uc3VtZXIgKmNvbnN1bWVyLA0KPiArCQkJCSBzdHJ1Y3QgZXZlbnRmZF9jdHggKmV2ZW50ZmQp
DQo+ICB7DQo+ICAJc3RydWN0IGlycV9ieXBhc3NfY29uc3VtZXIgKnRtcDsNCj4gIAlzdHJ1Y3Qg
aXJxX2J5cGFzc19wcm9kdWNlciAqcHJvZHVjZXI7DQo+ICAJaW50IHJldDsNCj4gDQo+IC0JaWYg
KCFjb25zdW1lci0+dG9rZW4gfHwNCj4gLQkgICAgIWNvbnN1bWVyLT5hZGRfcHJvZHVjZXIgfHwg
IWNvbnN1bWVyLT5kZWxfcHJvZHVjZXIpDQo+ICsJaWYgKFdBUk5fT05fT05DRShjb25zdW1lci0+
dG9rZW4pKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiArCWlmICghY29uc3VtZXItPmFk
ZF9wcm9kdWNlciB8fCAhY29uc3VtZXItPmRlbF9wcm9kdWNlcikNCj4gIAkJcmV0dXJuIC1FSU5W
QUw7DQo+IA0KPiAgCW11dGV4X2xvY2soJmxvY2spOw0KPiANCj4gIAlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KHRtcCwgJmNvbnN1bWVycywgbm9kZSkgew0KPiAtCQlpZiAodG1wLT50b2tlbiA9PSBjb25z
dW1lci0+dG9rZW4gfHwgdG1wID09IGNvbnN1bWVyKSB7DQo+ICsJCWlmICh0bXAtPnRva2VuID09
IGV2ZW50ZmQgfHwgdG1wID09IGNvbnN1bWVyKSB7DQo+ICAJCQlyZXQgPSAtRUJVU1k7DQo+ICAJ
CQlnb3RvIG91dF9lcnI7DQo+ICAJCX0NCj4gIAl9DQoNCnRoZSAybmQgY2hlY2sgJ3RtcCA9PSBj
b25zdW1lcicgaXMgcmVkdW5kYW50LiBJZiB0aGV5IGFyZSBlcXVhbCANCmNvbnN1bWVyLT50b2tl
biBpcyBub3QgTlVMTCB0aGVuIHRoZSBlYXJsaWVyIFdBUk5fT04gd2lsbCBiZQ0KdHJpZ2dlcmVk
IGFscmVhZHkuDQoNCm90aGVyd2lzZSwNCg0KUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmlu
LnRpYW5AaW50ZWwuY29tPg0K

