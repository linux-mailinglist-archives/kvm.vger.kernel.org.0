Return-Path: <kvm+bounces-14775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A8A8A6DF3
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:23:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EB46B22B92
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4467A12FF9E;
	Tue, 16 Apr 2024 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dQrTU51Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB91D12F5A6;
	Tue, 16 Apr 2024 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713277210; cv=fail; b=h74y3Aj8yNX36RkeS7+vZfJfX/8m6IY6H+q5Jj4mUK1t7KR0t99byFjcXHPxUw6dWunQwNXYwAfeOWHxPyEzCqRo+ud6IGsUyXBsT1WKKXqsfRE6HiZFMfow14J//tTNsrJkES4A1mIQ0RHxF6FjeZJZSGv0yAndCqdPx9+uK7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713277210; c=relaxed/simple;
	bh=Q7DI7V1Uv1rWcYHWs08cIEVMeluCfg5f+x1U8om+Jwc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WKFSKI5vwAcmh60KF1R6OKT5WQDYy/7exBiH/rjIQiSfQdJ4snKCmx5Qi9lsgvK7lo60/O/Z6qu8agA+EsrRGUQ7ips2GwEBzHxrrZJ9tUtnp//39aJOtp5jjF3lZ4RkIP0qeZMZyqy3BQpsaAv7alh7a1LU938ajpkryOYKWkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dQrTU51Y; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713277209; x=1744813209;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q7DI7V1Uv1rWcYHWs08cIEVMeluCfg5f+x1U8om+Jwc=;
  b=dQrTU51YNAXE5CK59+a22bhsyjF7/FsOh5QoGhrQA3+ImZBGWH0hi1hh
   4d4fopmjqZV4+ZrEd+UL5JsJVun4dC/IjQBLmYM5VjpRT7shG7tIQ75FG
   fGae40/iEhffubn6lMQMU9QGhE8iCvDlXm9BdM8A3c62zTk+eQjBIoB0u
   so3DP7YHj6Ux/1vaLJ4doFbb+IkIZjgDeUCHpFhXscji4AZTb4GXlzZY5
   RmNJ7vt7YdkFkeoX4ockqgAZkneea0U3sbwoMeNNtlo/nPGM6ju0N7+AV
   +dI6MfbyL4LFSAqW+KAJTl55BaZmahxUuM8LYqOsPY1sv8scZt4i2wAJk
   Q==;
X-CSE-ConnectionGUID: BXCKPbAGSl+qqPYZPDeGpA==
X-CSE-MsgGUID: naOSAVVSQeu24MUiQpgJZA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8548928"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="8548928"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 07:20:04 -0700
X-CSE-ConnectionGUID: yz+lTBkPREmWRHZlvHm4sQ==
X-CSE-MsgGUID: Pjbwe9EeSaeq3fkkmdkwdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="22872195"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 07:20:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 07:20:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 07:20:04 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 07:20:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLdkmXB57dlZeN3zljYE1ws5iZNzsqFy79RL2OOTp6Sl/5t1PlSWMYRFdLmr/hIMjr8h0zYPMTBZ8RIKtGhZuI0vbZXBQQrtjiZF9gcdOVvKCordT+XRQLlXveW4gLvk/RffaZA78BUORSWg1zvVyWaJdRW+HTtmbEbdES5omnfaT0m8/kmbp/inNXEaFP/aR6E+6n57LB60E1WtyYwC7XcHBaF/8tCdWgd7vQiPshRrIm08h43723OP1CkWLm0WnY2MVgPqSsTB0PwuanRgc+A5g0167Mlz4LxQLKXYDOQTHQHuZTU2JfedO3h8xm3j4jcEvnNRzwztpUV2/HHSRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7DI7V1Uv1rWcYHWs08cIEVMeluCfg5f+x1U8om+Jwc=;
 b=XcAd1uC3YHl7or8KlWcCut+JMd9iuRsK8d2mHKUW/oa6VuP6FdTvLpzFlQy4sGVEpzqXyxL6neefNog6jWu1xAiQQOjtuewqEtRas0ZNaBA8R6XcWUkGW8uLbqnEnU/+huRrJgZEE9KI3pgqIg6Cae/x3aesu0vNakOEPFdT9QnssDNzvzESZObF/HVjvTpH1OwGT2hP0DwHHuqKwyHnqeot7ff1r/+9HBjbthaw9hYBaiu3FZb5UHQXV9I6dgRRwGuyQcN/TCN6VZDYH/ChQxRt6Q4umAWSrEn44tbmFlFF+q2CSwq6O408NyN0QCFydC7oqSixpwOXLFP1H4Rhjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8230.namprd11.prod.outlook.com (2603:10b6:8:158::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 14:20:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 14:20:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v2 02/10] KVM: Add KVM_MAP_MEMORY vcpu ioctl to
 pre-populate guest memory
Thread-Topic: [PATCH v2 02/10] KVM: Add KVM_MAP_MEMORY vcpu ioctl to
 pre-populate guest memory
Thread-Index: AQHaj4x9YTK8tiV6JUuhH6gHWtiotLFq8zyA
Date: Tue, 16 Apr 2024 14:20:02 +0000
Message-ID: <9a57f554a2a969cbb54b95d5f4543334165ce33f.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <819322b8f25971f2b9933bfa4506e618508ad782.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <819322b8f25971f2b9933bfa4506e618508ad782.1712785629.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8230:EE_
x-ms-office365-filtering-correlation-id: 5d53c306-d186-41af-96c6-08dc5e204e3b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bBaS+M67fl+zJgqV0xPxCR7iHNun+FTgXNzTjomsVqeAUoOJWTQVZjNbDagseDTWbVtf/qZ3qgs5S3X/9x59+9mQuw4sQojqRJNjUexm/+G8sbryS0MfVmkXo9/+G+lSK2YJ6Mqet4UHE8EOw9Ja1QsKoKb5wnssJ6hsmwlT31qVQ9huSRPaqJYNBu2zvhuit1synJ7vyl5/+tQ2Jm/eEAhPLHvggxP2AAiIcibFdqttrmXyx7uAp2o91NXaIFibg7PpHRxG8wxy2vvL20nZgyVhCE+x+JkZEsDWLpFcDNNfrpo5+zPH7fmvNTjUElsAp5XtzM4mf5UInINhW95cOzcnTdqW+SXTof5SINR9Gh5h7zd3PMv8q3eXzofV8J3bdU80WBK75pUNbM8WJ/i1sPKnvApRXFz/d1sIQxWTfWF6/Ced+flTRMu2wNkFSiITsNAAQkqv0Bl2Yr8p/uUPVN4tu0XVncHEyNl8DLcEbetvwJYb4BDR5JpukYzIlBFUEaqm9D9eAjgwJtqK04oAKDVFTX7oVV1hkUUAiFTVpA+loGNVBoNymBYqqYVQ24bwJWMTzlB/vvbx7/AUUzddnLq0GkFpgviDVpqUQLpBa5qYJISz6qStErdJwqWNe1xLnN0gLBJvcOJuTgJ3S1Cp9By7KgcFrRNDrg0eSNhplGWMEZcUnrxBwMaG6KfKyBsQKdLxHth/TZEZQpi/7CDS3Pm5CxTUUkxRw4UG7fGnVCE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1A0OWluMlV5NVhJV0pKRkJKM0NjSFE1bHlFSFJsZEFqQlROejNkckk2Z0xM?=
 =?utf-8?B?ODM1LzIxMGtGQm1kSm1USkM4SmRjWktkY1hDVHVoRmFuclg3cHhFeVRqei81?=
 =?utf-8?B?OG5EcmZWeFVUdU5OejV6c2RoNmpEVmwxUFo1RGxSOHdKaEgrenhtZGpOZ1ds?=
 =?utf-8?B?ZWZNQWFsWnBhMDlEc2VnZnNqVkk5L1hvdHp5OFlLTjZKbSsrYllvWWMwcG1y?=
 =?utf-8?B?T0JPdUg0aGN0M0g1dUd4K3NWMEdHM2NtbHBnRTYzMGxuOGU4andpTGxTZXAx?=
 =?utf-8?B?YnhkdG5UN3VWWjFmTG90Q3F6c01KT3JvUDFwZ3ZZcU9SQk90ajAyVWRsUXZn?=
 =?utf-8?B?cHJEbEJjUjdkZ0NqV2QweVBob3h5UStKTWhxQ2kwV2k2eXBOUUZXVXZRMlVs?=
 =?utf-8?B?OXlqWlpFdGlBSWx6SkwxbjVWUi96N2xLazAyUFhyanJVeCtmWXVqVU9sN1I1?=
 =?utf-8?B?SmJjU29WU3lZZGExVitPRmlMWm1LSzQ1NHpZSnJZVzlwTkhJdEZadGF3V0tI?=
 =?utf-8?B?KzVsMTBkMmIrTzRxejRiUkovUUdxK0FJM2JNbVhlNTZTTXhkd1BISVpSS0pp?=
 =?utf-8?B?a2poOWY2bm9UeU5GdWJZSFRkWVhtVkwrS3M4YmtsMmtYUkdTV1dxOEhUbWFC?=
 =?utf-8?B?VFFrRE5vaGRFNExZelh3S2NsSTRYWUpVY0xid0xHell6Z05lNSt5OEhpYWlB?=
 =?utf-8?B?Q1p5eXBVVXRwaXVmMi94K0VBc3Vzc0lGbFc3RndiM1RUYlRpZ1k1Z3RNRVAx?=
 =?utf-8?B?U0pkM0V2SzVrV2FDS2pIVllkZGRiNDg0cU03YWo5bDQyQ1JqZlNPZE5DYk1a?=
 =?utf-8?B?MXhqTXFnRFBPMmtuOXUrcjhKNDc1ZzFlS1JHdEV0bW5iR2Yvb1pNOTB0KzBz?=
 =?utf-8?B?UmY5b0x0cUd0OFlqV1krVVVnTXUwaG9xOVNrOWJpejFwaXU1RGwvTUVXMTd0?=
 =?utf-8?B?aHI4WlZMaWJUWHNuS3VLZ1NZRUpQdUR6ci9CSVk0bjR4aWJvYnVnNm5OVE85?=
 =?utf-8?B?cks3SUZNQWEzQUg5OGl0cGRQZjhlM2NWNi9BYXJka200T1NldGRQNTNqT2lz?=
 =?utf-8?B?STRmWFhYOS94bVlTR0RST0wydkN4bEhwbGpxdjBoZUxFdHR3YUlEdmJKUVQ1?=
 =?utf-8?B?NHQ2S2wrOTluK1lINUpyRUhlem9oQUVUL1dnYVBMNDdyMkJKRmVQa2ZpMkVW?=
 =?utf-8?B?MEpKYzJKQ0Q3ZHFNbFBUQkNHU0lqMGdQQ3p0UGZ6M0RRcDRENTF2YU8yNHI2?=
 =?utf-8?B?RXE0YVJOdnNrbzNxS3JNdUpCQXVJUFFnclY5cVlwMEl2WXAwSlFGOTZWbi96?=
 =?utf-8?B?ZEhJZjhDRGNKakVXek1ITnFFZHdZQWFqRlVvVW9HWFo0bHY2a3Z3TTRYclFr?=
 =?utf-8?B?TUo2c3RwRkJLSnlkcmpuL0lMTiszTUxSNDFBenZsZGtPcnM2K2M2UFhVbmFN?=
 =?utf-8?B?NGVTeUxDdkhZN1dFTENOWlNKWjV0M3NmZ2YzMEV2VzQzVWJITnV1MXNab3J4?=
 =?utf-8?B?WWpvUTNjU010OVpjRnExV0tleDAxSFRqZE5DUmFMd2FmczkrMEp5ZXhoU3Z1?=
 =?utf-8?B?MTFvemt2WG1mbjRkT0pwN0N1YzdIVUJjcXBRdkJhODdrYlZtL2pDZmRtT1pj?=
 =?utf-8?B?TU83MkJFZjBsMFFFYWFUMXh2Z1JWdWJVcU5kZnNHRTRNdjZvTW55b0FRdDh5?=
 =?utf-8?B?NWJ0UnhnOTI2MzIwalN2dDJEZ1BLU01vNUtuK0FRNWQwTzNPRDNzVTlyc0Nw?=
 =?utf-8?B?dno2VDhmZWVwY3o2T0dPVHltbThaWTg5UmxiV0VMRDBDSEwzd3IyWmZINDVQ?=
 =?utf-8?B?bHMvMUg5NkI5c3U3SVY2TXVseVZvWHd0TVdxTnF0cVltWEdXMUVHbEtKR2ZP?=
 =?utf-8?B?RENhb2xyRXdYazAvK3FnWUJDQmhvU1VUQjFiUnFSeGJTd3J0SzYwbGhDUlZp?=
 =?utf-8?B?a0dMRzFzbmJIbmVtdFYxTVZxV1RNckxFV2NYenRNRmIxU2dxa1RBUGQyV0N4?=
 =?utf-8?B?a28wVFJVNnR4Rm5yQno4ZUhiTllJQmpxdDB4RG1penB2T0pkemk1My80S1lx?=
 =?utf-8?B?OS9aTi9rNkhNTy8zNDdxRW56VHNaUDVPWGJwWnlQSkNDbEFaMUhqQVhaeitY?=
 =?utf-8?B?TTdsK1RMekV5N3gzTnIwd3RVOFJtUUNIcEtMMjU4VWJncjd1TXdoMzQvWkh4?=
 =?utf-8?B?dnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8AB38C885720340A6C632C13B5F57D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d53c306-d186-41af-96c6-08dc5e204e3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 14:20:02.4219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UlUbFVeHgnEIScIP+Ser4yxZrzPHXnPORpQZoj3IluzNmrVRAR65v53aUK1dFsCjh7ONsoTUm0PdoM9+niKsq0JpJ1pUJq12YBoCbxBGZ3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8230
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTEwIGF0IDE1OjA3IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBBZGQgYSBuZXcgaW9jdGwgS1ZNX01BUF9NRU1PUlkgaW4gdGhlIEtWTSBjb21t
b24gY29kZS4gSXQgaXRlcmF0ZXMgb24gdGhlDQo+IG1lbW9yeSByYW5nZSBhbmQgY2FsbHMgdGhl
IGFyY2gtc3BlY2lmaWMgZnVuY3Rpb24uwqAgQWRkIHN0dWIgYXJjaCBmdW5jdGlvbg0KPiBhcyBh
IHdlYWsgc3ltYm9sLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1
LnlhbWFoYXRhQGludGVsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNr
LnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg0KQnV0IG9uZSBjb21tZW50IGJlbG93Lg0KPiAtLS0N
Cj4gdjI6DQo+IC0gRHJvcCBuZWVkX3Jlc2NoZWQoKS4gKERhdmlkLCBTZWFuLCBLYWkpDQo+IC0g
TW92ZSBjb25kX3Jlc2NoZWQoKSBhdCB0aGUgZW5kIG9mIGxvb3AuIChLYWkpDQo+IC0gRHJvcCBh
ZGRlZCBjaGVjay4gKERhdmlkKQ0KPiAtIFVzZSBFSU5UUiBpbnN0ZWFkIG9mIEVSRVNUQVJULiAo
RGF2aWQsIFNlYW4pDQo+IC0gRml4IHNyY3UgbG9jayBsZWFrLiAoS2FpLCBTZWFuKQ0KPiAtIEFk
ZCBjb21tZW50IGFib3ZlIGNvcHlfdG9fdXNlcigpLg0KPiAtIERyb3AgcG9pbnRsZXNzIGNvbW1l
bnQuIChTZWFuKQ0KPiAtIERyb3Aga3ZtX2FyY2hfdmNwdV9wcmVfbWFwX21lbW9yeSgpLiAoU2Vh
bikNCj4gLSBEb24ndCBvdmVyd3JpdGUgZXJyb3IgY29kZS4gKFNlYW4sIERhdmlkKQ0KPiAtIE1h
a2UgdGhlIHBhcmFtZXRlciBpbiBieXRlcywgbm90IHBhZ2VzLiAoTWljaGFlbCkNCj4gLSBEcm9w
IHNvdXJjZSBtZW1iZXIgaW4gc3RydWN0IGt2bV9tZW1vcnlfbWFwcGluZy4gKFNlYW4sIE1pY2hh
ZWwpDQo+IC0tLQ0KPiDCoGluY2x1ZGUvbGludXgva3ZtX2hvc3QuaCB8wqAgMyArKysNCj4gwqBp
bmNsdWRlL3VhcGkvbGludXgva3ZtLmggfMKgIDkgKysrKysrKw0KPiDCoHZpcnQva3ZtL2t2bV9t
YWluLmPCoMKgwqDCoMKgIHwgNTQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPiDCoDMgZmlsZXMgY2hhbmdlZCwgNjYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaCBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3Qu
aA0KPiBpbmRleCA0OGYzMWRjZDMxOGEuLmU1NmEwYzdlNWI0MiAxMDA2NDQNCj4gLS0tIGEvaW5j
bHVkZS9saW51eC9rdm1faG9zdC5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaA0K
PiBAQCAtMjQ0NSw0ICsyNDQ1LDcgQEAgc3RhdGljIGlubGluZSBpbnQga3ZtX2dtZW1fZ2V0X3Bm
bihzdHJ1Y3Qga3ZtICprdm0sDQo+IMKgfQ0KPiDCoCNlbmRpZiAvKiBDT05GSUdfS1ZNX1BSSVZB
VEVfTUVNICovDQo+IMKgDQo+ICtpbnQga3ZtX2FyY2hfdmNwdV9tYXBfbWVtb3J5KHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3Qga3ZtX21lbW9yeV9tYXBwaW5nICptYXBwaW5nKTsNCj4g
Kw0KPiDCoCNlbmRpZg0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIGIv
aW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oDQo+IGluZGV4IDIxOTBhZGJlMzAwMi4uOTcyYWE5ZTA1
NGQzIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCj4gKysrIGIvaW5j
bHVkZS91YXBpL2xpbnV4L2t2bS5oDQo+IEBAIC05MTcsNiArOTE3LDcgQEAgc3RydWN0IGt2bV9l
bmFibGVfY2FwIHsNCj4gwqAjZGVmaW5lIEtWTV9DQVBfTUVNT1JZX0FUVFJJQlVURVMgMjMzDQo+
IMKgI2RlZmluZSBLVk1fQ0FQX0dVRVNUX01FTUZEIDIzNA0KPiDCoCNkZWZpbmUgS1ZNX0NBUF9W
TV9UWVBFUyAyMzUNCj4gKyNkZWZpbmUgS1ZNX0NBUF9NQVBfTUVNT1JZIDIzNg0KDQpUaGlzIGNh
biBnbyBpbiBhIGxhdGVyIHBhdGNoLg0K

