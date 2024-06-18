Return-Path: <kvm+bounces-19902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7B4390E01C
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 01:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B10C31C2304E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2AF11849FB;
	Tue, 18 Jun 2024 23:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNxFn7BY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10188181CE9;
	Tue, 18 Jun 2024 23:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718754157; cv=fail; b=ZBLmI9o/f6UxrwR4OiMFf0bnBWIYEhbJ/NefxdTZEAUbboDz4EKsLtSz0MF+VDGf/WS2exg4AFBJIxd2EmkmF5jEGeVExtoxuUPFDBI/Yr0QmIgr0Dp1faV5no4pKuP5pM1Eri2xw2pYfBBI1O+4ijPGVc3c5yHpNIDBxuFRp2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718754157; c=relaxed/simple;
	bh=dUcgjZRKsnS9Lq055C8arb0V0l7LL0vE7bs9hWGxu8U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IS9ORt8LCgCklYlmI1SgGdWJjmTFuJqsx67I5GAMS8WEvyZL0kQ2nmwuQrsNZw5R0Jo5Q4KsDtNxjijgaY4PYRo+7kC1y2U5rDPhm1XH/uIvUfW/cYmjBjRnselPQolfvb+piA+RNEKYobG/nWFbwo3O+I/siCwqQXG3DqfG6iM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNxFn7BY; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718754156; x=1750290156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dUcgjZRKsnS9Lq055C8arb0V0l7LL0vE7bs9hWGxu8U=;
  b=UNxFn7BYqHR5D2G+FXV+QMa9ENMyMfJJNICL+WzK1Y8/gLStX33QogZj
   MTWVYLfQlmR+xVTwhxkxFPM3gec598SfZAhX37zvlzr6To/3D/2OLKdN1
   wO3wdB6vewbS7RXkAbgTXABQWj3cGZovezCBUgXt786iFI67oBoU3Tjh2
   BZDgDRyLJX9LvtRFeyCiyCTe39myGJVg1VeqUEColi1UuEI/DrHq65qdp
   23IAjLDwfjVXcJPiZlm6EjSJ14iTYDtOfwLO5+K6JAuWMACBYR7Ipy8sI
   x6vGumIoBJlVf3LcaMEvulPvjAG0U3cLsMvV2fGwQJYPH/7N4q0sPQDrc
   Q==;
X-CSE-ConnectionGUID: 4dZH2Z5rSBKleeT2YNIWcQ==
X-CSE-MsgGUID: SJ4xJSl0TVqGrRzBEy8HSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="19451239"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="19451239"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 16:42:35 -0700
X-CSE-ConnectionGUID: iB1UsUZ0QYeq7tOldhjibw==
X-CSE-MsgGUID: eV0HiBbdSlacC6wx59YL/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="72469473"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 16:42:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 16:42:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 16:42:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 16:42:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 16:42:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LX+jpcHKT4NElM4b7IcknCiS3lXBhYfELh2+/0ED1JRr2zQ84GJosOfTQDmZhB/g+vRR0fUqc873bDkpXQKWRTSN38IbpW2qw8CuuTEOQF0tYqgPoyC3z/P/hwvPHaK6OuosP5CUwH2Y23ublgsHAg5Mnoe7Ui70Aee+93hBw4IbXG2oTXwB1DxI08a3SCj4Hx0c77awmB83WFqjw++CZJOyaUICc9L/o06v4Gr4k8YDywSEB8GXUT0Far/5afpc5/gfN9uDWxynXDv1+q+wqP28IpRjCErO4nnzyfiZ3Ka+3eyNciD2Vj+/pjtYt9c2Nmgal02jlwD+Jw67AAUn2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dUcgjZRKsnS9Lq055C8arb0V0l7LL0vE7bs9hWGxu8U=;
 b=PtDmpokF6Nd5IFIy7gP99xr9nh3GoqsHX9gQJcW+mAsgPI8aDBPwOBVDWQKFMme3LmTd9rNWiACltqd0ah67mIbXxWsks9MG0Ykp4ZWxGT3SY+jQBbi0nMeh1Jfqq6vjOdzxLvN4J84RVVAqkSka3sc0N5nyqp/8S/eYjLwP7oyR9HgE+M793m7tXvncxBrjq3afL0IBaNiq1Jw1U6YHeeq9TH0OSUpm/1hBcb2JuJUBF7TGdLpCVrfWkHz7e4Z+QZpkSjBUOXrk3Za/9E00sis8aH9Xo8mStPWneCQyokmtBlYH7CqmTp7q4eTsjs76CzryNhfruZrTVsE2a1QSvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BY1PR11MB8127.namprd11.prod.outlook.com (2603:10b6:a03:531::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Tue, 18 Jun
 2024 23:42:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 23:42:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 4/9] x86/virt/tdx: Abstract reading multiple global
 metadata fields as a helper
Thread-Topic: [PATCH 4/9] x86/virt/tdx: Abstract reading multiple global
 metadata fields as a helper
Thread-Index: AQHav+UE6RryEdMBfk2c/d/9ZyT7hLHNakiAgADIRAA=
Date: Tue, 18 Jun 2024 23:42:29 +0000
Message-ID: <2af34675563cf78db0d17d8d5af3d7160c82cd94.camel@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
	 <dd4ab4f97fc12780e4052f7ece94ceadffafd24d.1718538552.git.kai.huang@intel.com>
	 <7a9eddb2-2ad1-4aab-8edb-548f05b524ec@suse.com>
In-Reply-To: <7a9eddb2-2ad1-4aab-8edb-548f05b524ec@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BY1PR11MB8127:EE_
x-ms-office365-filtering-correlation-id: ee23e896-4c20-4cd5-b11c-08dc8ff0515f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|7416011|366013|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?a280bWdhTytRUUM4d0hxTmExc05qUW5JTnlPOC84ME90SldSNXViQnQwc2JO?=
 =?utf-8?B?QlAvRndpWEEyTk5jNS9OdFI2bmlUY0Z1MlJiL2x1R0p1VHJzZ01FLy80UnJp?=
 =?utf-8?B?Vktmc2ZlbWhSSkxWOHFkbFhrZGVnMThGd1hzOHJqNS9UeEtLM2tZRXUzOW1n?=
 =?utf-8?B?cHBGTFk1M1dPUStXZ2oxeEhhYTB5VW13SkVQd0JRSi9SYnppc0xCZHhXMHA1?=
 =?utf-8?B?RXZEVDBCbGNiWnFzSUhoVGQ3SDRFRzkzVzJNaEtsOVpIeG43SnFsQllSTUY3?=
 =?utf-8?B?SnRnNzJFaUhzRHJoTWZpRGJFNktvblhRNmhzUFd6WTBJWm0xV2pWaEdOYnh6?=
 =?utf-8?B?QWxBMW54d2dhZDJNYWF3Vk5TdkFnRG5kVitDbEFwc1RuakNhMzRzWlcrbDBx?=
 =?utf-8?B?cnZnMzh5RWVIVEhGQ1F4YWk2cU4xN2tTOHBMdVRHYkZRRllSL01WZ2JMWHcv?=
 =?utf-8?B?SmpBOWtUUG5SSG9JV2MrejZiRXZ4RFdwN0UwRzRCVGJWNkgyNVdoNDNpd3ZN?=
 =?utf-8?B?aWVtaDQvTE1TRUY5SnNWaS9YS01ZaHRVbEZzSTgweVI5Z1FNNHV4Z20xUk1m?=
 =?utf-8?B?UDBkMHBsUFFER0xCaXM4NWoxdTA0endnQ3dDR1A2MjVzeHpFZ3dxYUh2UU1K?=
 =?utf-8?B?QVdEMFdmRnJCdUI0NS9oWTc2WTlaemdnL2U0MjZjeTYxMTZibXMyU294eGVP?=
 =?utf-8?B?RXVJRk9HUURNTGhzNTRjeVVMeE9SY0tYR1BuS0o5RjBRQTRDeExCTWhVb09a?=
 =?utf-8?B?SHBienpEcytZS3NMQXJqNGRxb1J5aXZ6REF3Ti9KUjhpd3hvU3VaSVJjN0pt?=
 =?utf-8?B?WFVEQTRRZHJFQk13TW1DL29HLzVKSXlZYUhTWmpQbGJIcnpmNm9ESmxuZlFN?=
 =?utf-8?B?dnhzSHAzNWJSaytuNjNVNGhPWW5SZnFaT2JNM0I2d2dDOE9IYVM5NHNiakIw?=
 =?utf-8?B?MGEwclVmY202MFdNcTNKOHQ5NVZZcUk0WnZjY2svNVZteW9xNEt1VDlTVDY2?=
 =?utf-8?B?WGtwWW5pNDQ4emx0KzFJK0crR0Q5QzZCQVBpSmF5b3lSR1l3dmtJUUYrVkFG?=
 =?utf-8?B?K1dQSCt4VmtEUlZFT0J1VEpSRlN2WDZCS1RkV2RCWnBycFMwVUE3NWlITVFL?=
 =?utf-8?B?aE1DYUNZcTFrTWFrWUsvOHBPczBOWkIxeG9OMjNqVEhwZ1NpL2Vyd1FvcU0z?=
 =?utf-8?B?eHlDY2RNc2tOUDBWOFowNHFjN0xScjVoSExHUDZPQ1hyNnpGcUtoT0ZLQnFY?=
 =?utf-8?B?TElKTUsvcjNISFNSU1c0bVIyMk01aTE4czFVaUU4UFpncVZnWE1nUHRMUzh1?=
 =?utf-8?B?ZkFRQTJLWitxa1FKYkFQMTVJcXBDZXlxci9TWFhEbGVLa3BEMTdDYVpUcFpv?=
 =?utf-8?B?d0RIOU5qMitjZHUzNC94YWhmb3RSQ085Y1BTazNvaE1qSmdaN1JINmFVbTJM?=
 =?utf-8?B?RkFndndrNHc1b3Z3TlVKTXR6MVg4VEV0SVlhbDNiQjZWWk1jVUNnRitDV1h0?=
 =?utf-8?B?ZGZ3RVpRZ2l0bDJqSDE2VVpmd2d2eUdGa01PZExaMTV3c09SdmJCT2FTQnly?=
 =?utf-8?B?R1F5eEZLS3lnWUVWWU5nQ0ZHZkRTa24yWTMwbmJXRUpOS1VmNkpHUlhKRUd1?=
 =?utf-8?B?YjMydkc4NDY2SXJXL2ZMbjR3djVveTdOY2NoWUxJRU5acmg5a2JVYXJjQmdj?=
 =?utf-8?B?UXNpYm95a3dTNGZXME5wNVBiajRsWkxjSG1NeVBLTE42cnc5YWU5WlZOS2h0?=
 =?utf-8?B?SzlVMjdIYVZhOVN3RGI5N2xYTk1rYU54enAxdHdWSkhIVnRTT0xram9rRVFh?=
 =?utf-8?Q?kAWD2KnuKR/Wzyq9xs5Y5/tAqajAvQUktkWAQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(366013)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tlc5ZmM3bmVHMTFOUUhiQkxVdzA0bzJvN1Q1UnpoSk5DNFhDRnJweXMxcXRY?=
 =?utf-8?B?YUQ4aUhOMXZ3cEllTmhEYVZFeUE1aFllYnZxZG13ci83T0ZGMTlYRkIzYkZt?=
 =?utf-8?B?cmdYa1pYYi9QRkFCdnJqQjh2NURoUmUzckZrY2NDaDQwM041Q2FEcmdkRGo3?=
 =?utf-8?B?Mnd4VjRabG5xZmRXNkZrZmplVk9lbEdvNjh1bHM3TEF2NnBGYWxaNjhBZy80?=
 =?utf-8?B?Y3lPSjRReGw0SFhEY2Fya2xQTVpWVWpSaUtrb1Z2QmF1UG15Y2pOTU9SYU9O?=
 =?utf-8?B?bldVamc1dTE4QUlrWjk4V0d4Q2dpSEpHRWU4ZExic3NnN08yYzdraUpSZU1m?=
 =?utf-8?B?cXZxUzRmQU1QN0pmT29Sa3lJODVOVWE1aDhRZytta3d6NDB1QTY5T25YK01C?=
 =?utf-8?B?YzN3YnI4dlBscUpYNW5FQi9kcTREemM2aXJad3RLOVEzaThaQ1NBc2VWQ09T?=
 =?utf-8?B?SnBlNmo5STh3MUUwSnpVWEJwM2xJMDFDK1VyTkVCNjJKMy9oUVpNNDkxOHdz?=
 =?utf-8?B?S29NYU1MR0pyUTkvM0NuQjE1RnJvWnY1eVptd2ZlaFdhaE9aNXJoOGNHa295?=
 =?utf-8?B?QWl5NHRkcU5QMmlJQ3QvL1dENWFkM0tVUmxyT3ZoWVJFc0dJQ21OdGVHMVl5?=
 =?utf-8?B?bDZvRjdrK0FQa0VrL0MwY0FxNEt0YkhkbDR5TW1ObFNxUmZNTEJKZkhGdWN1?=
 =?utf-8?B?ZzlEUnlsQU9iQ1d0Z2dLVzR3Mk5ZOEtCbytneDBtYzVPQWp2YWJ5VEx3NEhT?=
 =?utf-8?B?cTF6cFd4N2JiZnZWdDYzZmI3elcvWktnMk1VYnJ2Qm8xVS9jcVo3THlTVE5a?=
 =?utf-8?B?WlVlMXdpZU9aRk5IZ0tlZzVjSE9KbGVpM29uc3JyT3N5emFUSWZQY241MlpY?=
 =?utf-8?B?RUd0Nll2UTlVVFFVTDNVVlF3L3lJNXRZQzRHd1BnZWc2TStzc2laOFJiUWFT?=
 =?utf-8?B?aGljbzh4UEVYZG4wSkZaNXIzTmtocHlxK05MQkViczJ0Q2o5M05SL2FIQitq?=
 =?utf-8?B?cjV3SjRlNDFnQWhKZTJPd0pTdGIvQTNNRDhBbTRHSUVFeHZoMGhvcVczeHV5?=
 =?utf-8?B?RVdNWTNNejA1Ujg2NmJZTlR6MzBWSGlhcVpaN3EvRjhPT0czUGdGV014cFNN?=
 =?utf-8?B?UWFWSFVEU010a09lc0JjckhmbmZQeEdaTnV3T21yVVpsb3g3cE5sUjFQSmJ3?=
 =?utf-8?B?elZjdEVFZFBwajY2dHVvQ21kL09wOUFGdXo0WVBkTDdQNy9jdWR1VFJTd3NW?=
 =?utf-8?B?a0srZk1meHNETFFZS0o0NnZFRzhDUXZUWXlHSU1JYTgxY3NKWndzcDZXOThC?=
 =?utf-8?B?NFh5bXBtUzkvSzhmWTlzSkY2YlQ0Vzk3ZkNCc2xPY2xjTnovUjErUkhFWHpC?=
 =?utf-8?B?dVFkMWhKQ1B0OTQ4VzVZQ1htTHhaeGdscWFQRlUwTUZEaVVpbHpwN3NJbUlw?=
 =?utf-8?B?WWY3dk9YWkFHd0ZsQjI3U2FYSTNrRERhK1FSM2tETm1lci9ENGFEcmpxQldt?=
 =?utf-8?B?aHpwVUdZalI1a0g2ZWt2aG9BSWJNbVVEbGMrUkh0UjJsc1hNVjBVZWx0M1Ir?=
 =?utf-8?B?WHFsNTNYejdIY1VWdWkxNUIvN2NJQm4xbGtlWmFvTERteXJMc3BVSjlXRWpY?=
 =?utf-8?B?RWk4ZGwxMEVvbTZGR3VPZ1J1eGZDeWRvdWNDdmRpN012RUNoSVczelY0eGJk?=
 =?utf-8?B?RUlhSUdUVmFWZ0dQZTRwYVRrSStGaVB3Tkw2Qk81RGF2ZEp0V3BxTUVDdHBm?=
 =?utf-8?B?L0RxeWk4WnNtSW1CL1c4cmNwa0FmK3JoYUxRSWI3RUgxRXBsUkc0dkczd01p?=
 =?utf-8?B?OU54dWZvVmhSRGdsQUVRSk1STURBZnBJS21OYmVWcWhrYkhOMlRVTUVROHE4?=
 =?utf-8?B?VFdjOW1jZ2NiNk1rT0VqQTlPaWpadnd3ckVDVCtES0d6ZUJXb0xZZkdMa04x?=
 =?utf-8?B?YkNvRlIzN014Yk1oVHFYRDZYSHhJMWJ2aXN6WkxDb0xHNk5YK2lXRmF3TGhB?=
 =?utf-8?B?WitpWEZuVjBNSENXbHZmSnE3aFVQN3lFNUpTUlRyTHl1VjBKS1ovWis1dU85?=
 =?utf-8?B?NThvdVBHbXRHVlNyT3ZQb3l5VGl0amRYaVpNZUt2TFNKVE5OYXJHRXd4NXNx?=
 =?utf-8?Q?mxdgjpQJC70FwNu4ZOfQN883N?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB11F0FA484BC34CA048C2721B2ACEE7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee23e896-4c20-4cd5-b11c-08dc8ff0515f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 23:42:29.9378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G0JhjOZXXhhObCkosYDkA5o7VPSVLNg8EnzwINaiBlQ65xBnQCTthRWbzGdUMvku3/AdCNpHjvGnyWwdKALFWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8127
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTE4IGF0IDE0OjQ1ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAxNi4wNi4yNCDQsy4gMTU6MDEg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
Rm9yIG5vdyB0aGUga2VybmVsIG9ubHkgcmVhZHMgIlREIE1lbW9yeSBSZWdpb24iIChURE1SKSBy
ZWxhdGVkIGdsb2JhbA0KPiA+IG1ldGFkYXRhIGZpZWxkcyB0byBhICdzdHJ1Y3QgdGR4X3RkbXJf
c3lzaW5mbycgZm9yIGluaXRpYWxpemluZyB0aGUgVERYDQo+ID4gbW9kdWxlLiAgRnV0dXJlIGNo
YW5nZXMgd2lsbCBuZWVkIHRvIHJlYWQgb3RoZXIgbWV0YWRhdGEgZmllbGRzIHRoYXQNCj4gPiBk
b24ndCBtYWtlIHNlbnNlIHRvIHBvcHVsYXRlIHRvIHRoZSAic3RydWN0IHRkeF90ZG1yX3N5c2lu
Zm8iLg0KPiA+IA0KPiA+IE5vdyB0aGUgY29kZSBpbiBnZXRfdGR4X3RkbXJfc3lzaW5mbygpIHRv
IHJlYWQgbXVsdGlwbGUgZ2xvYmFsIG1ldGFkYXRhDQo+ID4gZmllbGRzIGlzIG5vdCBib3VuZCB0
byB0aGUgJ3N0cnVjdCB0ZHhfdGRtcl9zeXNpbmZvJywgYW5kIGNhbiBzdXBwb3J0DQo+ID4gcmVh
ZGluZyBhbGwgbWV0YWRhdGEgZWxlbWVudCBzaXplcy4gIEFic3RyYWN0IHRoaXMgY29kZSBhcyBh
IGhlbHBlciBmb3INCj4gPiBmdXR1cmUgdXNlLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEth
aSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGFyY2gveDg2L3Zp
cnQvdm14L3RkeC90ZHguYyB8IDI3ICsrKysrKysrKysrKysrKystLS0tLS0tLS0tLQ0KPiA+ICAg
MSBmaWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPiA+IA0K
PiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBpbmRleCA0MzkyZTgyYTliY2IuLmM2OGZiYWY0YWExNSAx
MDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiArKysgYi9h
cmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBAQCAtMzA0LDYgKzMwNCwyMSBAQCBzdHJ1
Y3QgZmllbGRfbWFwcGluZyB7DQo+ID4gICAJICAub2Zmc2V0ICAgPSBvZmZzZXRvZihfc3RydWN0
LCBfbWVtYmVyKSwJCVwNCj4gPiAgIAkgIC5zaXplCSAgICA9IHNpemVvZih0eXBlb2YoKChfc3Ry
dWN0ICopMCktPl9tZW1iZXIpKSB9DQo+ID4gICANCj4gPiArc3RhdGljIGludCBzdGJ1Zl9yZWFk
X3N5c21kX211bHRpKGNvbnN0IHN0cnVjdCBmaWVsZF9tYXBwaW5nICpmaWVsZHMsDQo+IA0KPiBS
ZW5hbWUgaXQgdG8gcmVhZF9zeXN0ZW1fbWV0YWRhdGFfZmllbGRzIGkuZSBqdXN0IHVzZSB0aGUg
cGx1cmFsIGZvcm0gb2YgDQo+IHRoZSBzaW5nbGUgZmllbGQgZnVuY3Rpb24uIFdoYXRldmVyIHlv
dSBjaG9vc2UgdG8gcmVuYW1lIHRoZSBzaW5ndWxhciANCj4gZm9ybSwganVzdCBtYWtlIHRoaXMg
ZnVuY3Rpb24gYmUgdGhlIHBsdXJhbC4gQnV0IGFzIGEgZ2VuZXJhbCByZW1hcmsgLSBJIA0KPiBk
b24ndCBzZWUgd2hhdCB2YWx1ZSB0aGUgInN0YnVmIiBwcmVmaXggYnJpbmdzLiAnc3lzbWQnIGlz
IGFsc28gc29tZXdoYXQgDQo+IHVuaW50dWl0aXZlLiBBbnkgb2YgDQo+IHJlYWRfbWV0YWRhdGFf
ZmllbGRzL3JlYWRfc3lzX21ldGFkYXRhX2ZpZWxkcy9yZWFkX3N5c3RlbV9tZXRhZGF0YV9maWVs
ZHMgDQo+IHNlZW0gYmV0dGVyLg0KDQpyZWFkX3N5c19tZXRhZGF0YV9maWVsZCgpIHZzIHJlYWRf
c3lzX21ldGFkYXRhX2ZpZWxkcygpIGlzIGhhcmQgdG8NCmRpc3Rpbmd1aXNoIGR1ZSB0byB0aGVy
ZSdzIG9ubHkgb25lIGNoYXJhY3RlciBkaWZmZXJlbmNlLiAgVGhpcyBpcyBvbmUNCnJlYXNvbiBJ
IGFkZGVkICJzdGJ1ZiIgcHJlZml4IGhvcGluZyB0byBtYWtlIGl0IG1vcmUgY2xlYXIgdGhhdCB0
aGlzDQpmdW5jdGlvbiByZWFkcyBtdWx0aXBsZSBmaWVsZHMgdG8gYSBidWZmZXIgb2YgYSBzdHJ1
Y3R1cmUuDQoNCkluIHRlcm1zIG9mICJzeXNtZCIgSSBqdXN0IHdhbnRlZCB0byBtYWtlIHRoZSBm
dW5jdGlvbiBuYW1lIHNob3J0ZXIuICBUaGlzDQpmdW5jdGlvbiBpcyBvbmx5IHVzZWQgYnkgdGR4
LmMgaW50ZXJuYWxseSBzbyBJIHRoaW5rIGl0J3MgZmluZS4NCg0KQW55d2F5IEkgYW0gb3BlbiBv
biB0aGlzLiAgTGV0J3Mgd2FpdCBmb3Igc29tZSBtb3JlIHRpbWUgdG8gc2VlIHdoZXRoZXINCm90
aGVyIHBlb3BsZSBoYXZlIGNvbW1lbnRzIG9yIG5vdC4NCg0K

