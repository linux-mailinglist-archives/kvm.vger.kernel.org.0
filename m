Return-Path: <kvm+bounces-56002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 369F3B39046
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:55:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1550A1C2156F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1B91A23B1;
	Thu, 28 Aug 2025 00:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S+9cU1yh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050263FC2;
	Thu, 28 Aug 2025 00:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756342494; cv=fail; b=eh132YUC15pixY6X15+IAWrwcPxT4xbcjbH0ETsvbq82El75a4zJRzzkkXdukpd0ot2q6UacHk79ZISxd7I2n5N7TlgN1tur9ZFyrOMgoLdnP05XdBR3ZihmlNabLy9lcnLztnit2asIjrRHwOT+Dtcjdjvo31djSZ2+IyTYJDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756342494; c=relaxed/simple;
	bh=E2rsr6StffTQvDnkr70LxkysfUuhuadbDHMsoTRz8G4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PAqI6wGnPfhgKfJ+J+KiRzwJHng9d7YF9FyuD/hhPeDHWzLOu2lrHwX8XhX3GhYA3VK3BPHigWypYFDOqAnvH9nv7fDhNWu6UVd0gmLcmxVh5y+rPJN+gdO3BMoNB8uW0eA8FUXoP5rpavHS1IY/uh3ncntJDZkhA/30sgSn3H4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S+9cU1yh; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756342493; x=1787878493;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E2rsr6StffTQvDnkr70LxkysfUuhuadbDHMsoTRz8G4=;
  b=S+9cU1yhgrWlPNzwOhar/PbYuXiaG7BKD5qe0Plv6zsCHXPqScdZ0rlb
   ZtZoKnhnyzuSYz+eeiHTZycVCyVSA5hIfdWE02YN95QYlCuKz3UHExeMa
   TKer04NguLqZvUI/3M+6ty6n3BbXJJiB+ZJ/gAU7DAe5Viwqit6O/mvry
   NoxwBmu5FRQrEkRrYEjCvox1zmELCPhImCRlwBx1K05CaLjgkJVbKUSV6
   C0TTm6oqwrMSPPTijyOjCSBygvb6fiMigBI6BR4/FfBK8QXKCg7ah4DxP
   MxFQARilvTAO9PSp2PUCP5BKTikcQcmjI+A0IGBq7pk1AK1jw2AxB0L33
   w==;
X-CSE-ConnectionGUID: JHQJE6D7QkqoQ6urhf3bzg==
X-CSE-MsgGUID: VVlM28ybRIO4PC/Le04UuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="57629495"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="57629495"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 17:54:52 -0700
X-CSE-ConnectionGUID: f5zNZjikSl+6koXMS+N2jA==
X-CSE-MsgGUID: +f2jx4oSSCyawpcMdDlIew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169904505"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 17:54:52 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 17:54:51 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 17:54:51 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.49)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 17:54:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hgGXprT+u+XJQHn8cEuEK9gu31SspmWwcr5uMUnRIUMLpfK7EXwImjigtkzPD0OnhotNy9xDel3pp0Z2/FzIq/TRBqbr2lWchOtcJg0+0m5i25HUnIZ2FydrLH3PRlRumB4jSR0iPHDPvDohqnZ5pSR/K2Rgz6rui443hJf+drmRLPc93lQLhX2CAZAZpEV/7gPDvYCgmJyWeMyf5ain5Wz+ny61ZZgtHvy9NMgtIgdP4eL23vHGyAFbYaNCxS8fZExlQPKqNah/ZCGNTE3ug4CoM6Zac9BeJjrhwI2J6IPjDK3cypk1rQB5/yolgrmfFzj9TBfNU308DkUhXQQDZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2rsr6StffTQvDnkr70LxkysfUuhuadbDHMsoTRz8G4=;
 b=msAZBE1PbID+f+eCm0f+6L3L6/10jx/16rt8M6HWC66OpspklhXkbQxh+mARXq/jZ+8+YQMenERorNMjfjN/ASd6oIUH8MSpKCu7QcNzyuvQ/fX9E6wna5RDBs8F8uo5EZTLp5ZCNv+rA7aG0A/phaR69X8NFcDuLQO6YmB3SaHD9HdFBijBBG71YASE4Cj2Swp0w9EMNYUT97jIoht+ypQfeOKY78R1RJzk89kObAyKu4egqG/6vLbVBmzIyg470JlWGWLawdg2ORMfUibhhmcylGI9STFH6+5KWD+1G0TWxYahYDM85pU7aTLB4O40Sy92QALX6zxwOK0kC/wyLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6174.namprd11.prod.outlook.com (2603:10b6:8:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.24; Thu, 28 Aug
 2025 00:54:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 00:54:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Thread-Topic: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Thread-Index: AQHcFuZRH7A9gjtzDkWLIdW2XN4AQ7R2KoyAgAEUWoA=
Date: Thu, 28 Aug 2025 00:54:48 +0000
Message-ID: <4c292519bf58d503c561063d4c139ab918ed3304.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-3-seanjc@google.com>
	 <aK7BBen/EGnSY1ub@yzhao56-desk.sh.intel.com>
In-Reply-To: <aK7BBen/EGnSY1ub@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6174:EE_
x-ms-office365-filtering-correlation-id: ea3f46f2-c24c-4395-5169-08dde5cd7cd0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SDQ3L2xBMENHbjJWUVRHdjRMVzVpVy85ZVJhdDBnY1A5YU8ySVpBRnQvYW1q?=
 =?utf-8?B?eFVoRkp5SFJjVVdwRlE2SUNGVEhuc3ZGSzN0cWdLUVJ0N1BOMzUzcHZVcERE?=
 =?utf-8?B?TE40WitXRW40SEo5NVlPRjR1NUU5VDdpSWM0Q0VBeFR6MXd0TmwwWjN1VU5r?=
 =?utf-8?B?UWlDeno2VzVFdUs1ZFoyWFJnaCtlTWplVTNEQlhENHFxZW5SQ0hkWURMOFdZ?=
 =?utf-8?B?WW9WZWZBVVdpMThpNU9hZE9wVXAvSVp1WXJOajR5cWpuczBvNVdDOTg1Z01F?=
 =?utf-8?B?MDc0cFZQbUdobE9WWUVOdW9XYXNzdnV2cFdDajdiN3VzbDQ2Z0JReTZ6Sngr?=
 =?utf-8?B?SnRUZms5VjgrNDM0MXdGY3lib0sxNW1VeXdUcWdlSDhHblZpVm9uek1lQ01l?=
 =?utf-8?B?SGVaZ0ZUQk9qY0RkcU1zTGNCb3dBU3JEYktDc2lwbVNsaDV4TEZjYnhIbzdP?=
 =?utf-8?B?Wld2bzdvVGlDRTBsNzY5WW5QYzZEblFyaTFkRHI0bHY2VjBtQjl6MnY2d2ZX?=
 =?utf-8?B?dDRCYThURGNTMnRnMjNQaWZLb1YzZ2kvTVNHaVpBaEh5NzRBb1RQOUJWN2Za?=
 =?utf-8?B?eW9DaDlqRDRjd0NaTGU1M3lldlRibVZ0NHhsdlN2YndGSWRYT21QR3lScXdx?=
 =?utf-8?B?UDRqR2RZa0xubi8xSU9hUnFXazk5cld3cE5qdG0rZThDMm5oV3Nhc2VrV1VV?=
 =?utf-8?B?bEtzb214UXI4dWZ4TEFtV2kzVDlOQURCWkJrMnZoT0ZBMWlaWmx3WjVYSDlO?=
 =?utf-8?B?Z1MwakE0RzROMXpnVWRSb1NMd29UaUtqRjgyNmVoMmwrM1EwQXN5V2VsSlV2?=
 =?utf-8?B?bDZHLzRSRlcrYXord3JXRnZEdnR1NGhCUURRWkJzWFJJRXVkL1A2QjE4cytM?=
 =?utf-8?B?SGVwQllyVStEak9pNEhUKythY0Ntc3VTSkUzemo2NmwxR05NMEFPOG96VGQ2?=
 =?utf-8?B?R3k0TnNxQUhvOGxCejV0cG14Q0cxejh4ckpDSnltR2JBRG1RNVFzM2wxSGhh?=
 =?utf-8?B?SnBrTitpVzNOdTExcGFPTHhaRENORTZHWGpJdlp0a1pkbjI4aVkyWVBTVnNV?=
 =?utf-8?B?MUJjdzBHZWFCTW9VczlRY1RoN2FpQUo2VFpOaXNEVk5GMEFwTXhHWEpkVGZ2?=
 =?utf-8?B?RGtMcVVUeWVaeEw5OGxjdHM5V0VTbVViWmJmMnJIaG1xaUFBaVRwL21aNXpp?=
 =?utf-8?B?ZHZ1YTBMWlU3dFp0M2R0Y3AyaXBmQXBGL3llQ3hmMmxVSFlVakhLVFc1MFZO?=
 =?utf-8?B?TXJaOUd4Ujh3cEJScm9IWVB6Vi9Lc1JoVGhPNDI1d01aMy9TTU9xNjNaL3VQ?=
 =?utf-8?B?T3lxYWhmNEpxMGpVaER0YVV2eGdFTWl4VFB1N0YvdklKTEd2NnJLOVk4ZkZk?=
 =?utf-8?B?SlBZS3g0bnBGNGdvdUpJRmM5cnVvOXE3T2NxdTl0VC92ckVsUDBWdy9wRjA0?=
 =?utf-8?B?ZnRadVpXejU1QTdqb05xRlFEcHpaSE5TdlV2VVN3amk3dHNzSlZuUFQvQ0tZ?=
 =?utf-8?B?QTJXei9zV1NEMVhEQjBndC9MY0NEQWNxakZUSDZJSTRVOGdCVy9hMkZMV0Jy?=
 =?utf-8?B?OC9aMnpYb2haVHQ3aWVRd21uK0oxNGxXb1JRWEIzVmR4bThhTjVpZGxDaXQ0?=
 =?utf-8?B?MUJ3NlFMQ1ZxaVR2NGNBSE5NQmkrNDRDUHpxTy9HaW5CRk0zd2c4Q1Q3RGcv?=
 =?utf-8?B?eHloRW16OWdpSWNiay8vZklNR2lneHV0SDZ5TzhQcHB5bDMvTm1YNS9sdml3?=
 =?utf-8?B?Ykw2OElHSDJweGVxS3M1eFdFbWw2ZnZJcjlLWnVSb1hCQXhLSm5taW9wSWIx?=
 =?utf-8?B?OEhwV0JqbXdvSnV6TmR3WWdEOFEyTTd3Wld0NjBZQzlVRzh1RUxGMWhnZXMr?=
 =?utf-8?B?d0xsS0NnMU8xS0JFaDJCdXRXei9GWG1hZGpQYlIzQUkyclU1NFJPWmlqS0Jv?=
 =?utf-8?B?VUR4YlRCRkVqb3A0OTJnMysyWW9uK0ZmRVY2bXdraXpTOHl5RUxTb2ExekFS?=
 =?utf-8?B?MjZGK2cwekxRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzJLdHVwUWdXbzFJK1psbzNWT0p3eG5NcGl0eWJOS3VrdFJhaXBncWY0dk9u?=
 =?utf-8?B?eVphalo4emhFeUZJTFZzcjVKalVuLzZuU1B4RHcwRWV3d3EvMUpXM3J1OUdn?=
 =?utf-8?B?YnlwVWR0Sm1rSHlRYkxoakY3cXFNSXhJN0R6U1FMK2tjYjl6RTBjVTk2UHVV?=
 =?utf-8?B?N2ErMEcyN1drNHFvS0RMSGZFOUxoaU1qYXpzUTdpRzhpd1VaeGs3eWpEZFpp?=
 =?utf-8?B?NkFxWjhPaWdtN2JIdFpSbkZwWWtzanNUMGRsL2hsMU95UFFoTnRKdzhleTNQ?=
 =?utf-8?B?SWZRUWJrRDVsZk1GSmkvcGV2dHpDeEFwTzNZQXZwUHBwK3RUbmllRVgwcmdi?=
 =?utf-8?B?dGo1cmd2VU51bDVpSit2eTBiYmtHVVFLSXZjUFJlVm1JQWhQZk1aUGZhVFFh?=
 =?utf-8?B?OThLOGxWUjlLNmpEbTR4RlR4TCtGb1Y0UzJoNFpsbTJEZ2hIY1J2bEVRTmk2?=
 =?utf-8?B?Qng2YVdQYU5KTEFra21lSjFIejBSblZYZy9NTUl5cCsxa1NLUFpZckV3eEdp?=
 =?utf-8?B?Z0h3MGd0cXkvN1J2YnV4QXZMTUNRdk5oL0UxSStQQ3Q5TTBldU1aV0VuTlc5?=
 =?utf-8?B?ZEFocWNjZ0w5WUVrZzQxeGZLdm4ybWVINDYrUkRhQnRUSWhxYjVMbll2alk3?=
 =?utf-8?B?bTlpdFJlSVJONVN5SmxhaUI0bTV4eXMrM3ZoL2Z5a1pET1VJZTRlZ0hybmxT?=
 =?utf-8?B?elZhWTYwaHlxaDR3bXE4WWVQM0pnYVFINUtuVlRvZEtYVlBTcDJoMlErdCto?=
 =?utf-8?B?U3lacE1YTjllZ0oreERxU3laWFBpc1RDNllUNktZajIydk9CdFNWVDlNdE4x?=
 =?utf-8?B?VEVUNXJwOFhBZXk4ZVR6dFJUNnBubHpFL3ByNFkxb1lqL09kM3JnTHg5aTZa?=
 =?utf-8?B?aVRYcDhYbHVyZk5NMnlURXQ3TU9yLzdoT3NLNVk2Slloc3l3N25oNDBIN1Q1?=
 =?utf-8?B?cXhZdFVLd1BKMFdVeit0Q0s1UDg1M2oxQXoyRHJnZ3lqa09LUG5ZTlBmeDBF?=
 =?utf-8?B?VlcyczBMQTUveXdtQ0Z6aHpNZ3lOWXdhNDE0SHc3d3loYlZmV0xVTHpNUUUw?=
 =?utf-8?B?UmduaDJQSnFFSStVWnNjMkFtNFNzNlpiVjRhbE1pamo3dFM1bXJUYS9aUEZU?=
 =?utf-8?B?d0pPMGRlbnU1STJJLzBlVmh5WTV5a3padytXcU90bHk0dTh4YjVKaGFYenNQ?=
 =?utf-8?B?akMzNXc5aGdqTURmM01nenJsMEVBY0h6STdhK2NQdnJmWXk5dlBmS09sZ1Jh?=
 =?utf-8?B?bjRDcEtGWUxtcFQ1TTRTa1M4WXFDVyt4ZTc4WmxmMk12UEc5RmhkbFRLUk9m?=
 =?utf-8?B?WjVYVFpTQWNVZHJqYWFjOWExdWJkUUxCaHQyL3JCUERSanlFL1h1Um5aYlY0?=
 =?utf-8?B?VlpVZ1JWKzRUdThEVkhUZVJtZUtKUmN4dVZvUk1PQWNRY1FaNzg2NTA3S0Zq?=
 =?utf-8?B?K3lKenhmZzNXTWFEN0x6SXZRaGN5VnhOcitjUzM3NW5UMSt6MElxYklJMllD?=
 =?utf-8?B?OFFUdFBiNVUwTUF1KzlVZDVEQWxWakE1WkcwS3hjalpLc1N1TnJweTU5c3pK?=
 =?utf-8?B?V1Nvc2ZXRjV2NkRKRkNaNHpQQzJBTStncmFYbXJkSjM3cWxlcVM3SXVBeDVL?=
 =?utf-8?B?UVJZVG9PRWF4dDZ4cldXdzc0anNrWTlQWkJxSzJWWjNiNm1CZkcxZytNa2NE?=
 =?utf-8?B?c05XTWk0Yk1SOTZDc1pkZWVRY0MzU3ZNOGlURThQOUkrTkppMks0Y05ENkVF?=
 =?utf-8?B?SjR6UFZvS25kMEpDUjZvNm1Mcm4vcmZmb2NuNFZFUWhzUWlwY3YzTWwxczNt?=
 =?utf-8?B?UnNOaThBNWdtZ1kwYlVsUUdXcU9IYnVLc0tiZVhXc2ZpODZDcVNjLzkzdzcw?=
 =?utf-8?B?czZmSGJ3ZGcxSW1JQVZVSXdaOWloY1NqWU9RdENzc1JMbzY4dzZIOHllMDFH?=
 =?utf-8?B?V3hxRG9xU21zeEc1SUJ0L1B4NjNtR2dPMnpWSTlveFZJaG9MLy9xYmRCZ2xX?=
 =?utf-8?B?NXh0aVk5a1Y2QWVHOWJ4SUtHNWgyUVd4dGZuVWZOb3RyL2dqWE9qS2tXaVNN?=
 =?utf-8?B?c3M0SHBsL0ZBNVo4Qi9zZmdkSmd1QVZhaWd6RERIOHZTNDRQQWhnbEgwVXR1?=
 =?utf-8?B?RWhhTnVKYURldm9CVE1WUk5NajFaVWt1TVFGejU4SWE3a3hyQ2RGM1VtQ1Ir?=
 =?utf-8?B?UVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A382B1031BFCD543968A858EF0925E07@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3f46f2-c24c-4395-5169-08dde5cd7cd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 00:54:48.1274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EK7XCIB1fxPeYRYTYTago3l3Yk5Z7PVlR73tvRiyG6DwrYMR7AFgWXGLeasD4d5887hORZzsQKRnQibQZ5pjtf1no/UB5CMS44HmRoIOd3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6174
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTI3IGF0IDE2OjI1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiAr
ew0KPiA+ICsJc3RydWN0IGt2bV9wYWdlX2ZhdWx0IGZhdWx0ID0gew0KPiA+ICsJCS5hZGRyID0g
Z2ZuX3RvX2dwYShnZm4pLA0KPiA+ICsJCS5lcnJvcl9jb2RlID0gUEZFUlJfR1VFU1RfRklOQUxf
TUFTSyB8DQo+ID4gUEZFUlJfUFJJVkFURV9BQ0NFU1MsDQo+ID4gKwkJLnByZWZldGNoID0gdHJ1
ZSwNCj4gPiArCQkuaXNfdGRwID0gdHJ1ZSwNCj4gPiArCQkubnhfaHVnZV9wYWdlX3dvcmthcm91
bmRfZW5hYmxlZCA9DQo+ID4gaXNfbnhfaHVnZV9wYWdlX2VuYWJsZWQodmNwdS0+a3ZtKSwNCj4g
PiArDQo+ID4gKwkJLm1heF9sZXZlbCA9IEtWTV9NQVhfSFVHRVBBR0VfTEVWRUwsDQo+IExvb2tz
IHRoZSBrdm1fdGRwX21tdV9tYXBfcHJpdmF0ZV9wZm4oKSBpcyBvbmx5IGZvciBpbml0aWFsIG1l
bW9yeSBtYXBwaW5nLA0KPiBnaXZlbiB0aGF0ICIucHJlZmV0Y2ggPSB0cnVlIiBhbmQgUkVUX1BG
X1NQVVJJT1VTIGlzIG5vdCBhIHZhbGlkIHJldHVybiB2YWx1ZS4NCg0KSG1tLCB3aGF0IGFyZSB5
b3UgcmVmZXJyaW5nIHRvIHJlZ2FyZGluZyBSRVRfUEZfU1BVUklPVVM/DQoNCj4gDQo+IFRoZW4s
IHdoYXQgYWJvdXQgc2V0dGluZw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLm1h
eF9sZXZlbCA9IFBHX0xFVkVMXzRLLA0KPiBkaXJlY3RseT8NCj4gDQo+IE90aGVyd2lzZSwgdGhl
ICIoS1ZNX0JVR19PTihsZXZlbCAhPSBQR19MRVZFTF80Sywga3ZtKSIgd291bGQgYmUgdHJpZ2dl
cmVkIGluDQo+IHRkeF9zZXB0X3NldF9wcml2YXRlX3NwdGUoKS4NCg0KWWVzIHRoaXMgZmFpbHMg
dG8gYm9vdCBhIFRELiBXaXRoIG1heF9sZXZlbCA9IFBHX0xFVkVMXzRLIGl0IHBhc3NlcyB0aGUg
ZnVsbA0KdGVzdHMuIEkgZG9uJ3QgdGhpbmsgaXQncyBpZGVhbCB0byBlbmNvZGUgUEFHRS5BREQg
ZGV0YWlscyBoZXJlIHRob3VnaC4NCg0KQnV0IEknbSBub3QgaW1tZWRpYXRlbHkgY2xlYXIgd2hh
dCBpcyBnb2luZyB3cm9uZy4gVGhlIG9sZCBzdHJ1Y3Qga3ZtX3BhZ2VfZmF1bHQNCmxvb2tzIHBy
ZXR0eSBzaW1pbGFyLiBEaWQgeW91IHJvb3QgY2F1c2UgaXQ/DQoNCg0K

