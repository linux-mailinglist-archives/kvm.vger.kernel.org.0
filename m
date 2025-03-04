Return-Path: <kvm+bounces-40012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2A5CA4D9A2
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:59:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFC903B3381
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3492D1FCFF5;
	Tue,  4 Mar 2025 09:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m1AtPQR8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B631FDE37;
	Tue,  4 Mar 2025 09:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741082086; cv=fail; b=k/o2YE0JytvROoxxK75Oiupg+1csF/laVD8uTVJ52CxcLcnWgspkmjnACYnTc6fkOkaQfgYNKUChHNODCJA4JDsrWxFkty3lexDP3+LfR7PfxOBPXFDV5i3ds3Ek1bBK6ava20p52ctkdkJ3Yeb78ITM0jAp7v98RxRhBJEzXtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741082086; c=relaxed/simple;
	bh=e5xz1JeXlfUT2Ms5qq7rgdTVd52tGkioqMRriRtklUY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SQQWKMq+wr5LqPNKpmjcfgFpN4iXZKqP+9Fbgux8Z52IU3CBoX0bYe/4gKuN4BDVhUX4p5NT8ABgJxMX7IMpFvPJGtI8RRAeB6O8tLSrE1+U37/tbBR/BXxBxRGDT0lD+y4nNOZQaBR+1c/w4PfgBMKOU3Mu6aHNzO3PSpPzztU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m1AtPQR8; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741082085; x=1772618085;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e5xz1JeXlfUT2Ms5qq7rgdTVd52tGkioqMRriRtklUY=;
  b=m1AtPQR8IQQ/hXCGJZ9jHnKwlOTWMGvj5MEVns5z3UXf6FQJTsCDLHii
   RR/LRuLGHkGuENJKouXg28kPtg4exb7wfbSdbzzoE/vAZYwXzKlZIEV0C
   tnCnJWB5SJfBe0BJH7eWlK0cSHJH9yTOqIKb9isigqmM5NSM9B192xexD
   THGonhE/g2ZptDkFHuZfaGlHmdsU9c2+ti9ta/iIAcxmZngQv5EN0SoxV
   PyVbBG9I4OzYkYAHA3O/XEBmw+9OGJCZkcIMhGudCzJ0IsKLJBXPIb0pl
   O6VBQ+8m9ep1Cgw7p/VJ3PDYP+NW2O2k2eUCxNW8587F8anpSPQSicZL7
   Q==;
X-CSE-ConnectionGUID: QnxJYZC/TWKEjedXtmnT0Q==
X-CSE-MsgGUID: ZomnZuPISWqpdhJT1ptHKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="59539850"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="59539850"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 01:54:44 -0800
X-CSE-ConnectionGUID: 6eaKshU8QXWlIF5dDqHjAw==
X-CSE-MsgGUID: lV8j1pmaR52tOS9CRGKezQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="118813870"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 01:54:44 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 4 Mar 2025 01:54:43 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 4 Mar 2025 01:54:43 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 01:54:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OPW4dF6rLPatchxKuWk0YvdTPaNunAvfSzafLdrVSJWHcv6iy1ALkK3WY513f+UyM6aGISAhcYivVtnG1iVNVVrQZ14ojZnEDT5RLWE/rPa+tdFeRtGq+236RcBdlqzzXSACIqW9z4mdEPIxdJLLEFgrbm7tRm8/5GxL16El7pDoS8L+K8k3tG409eLjPmsHm2ZCPeYrrX1mey+Q/EbSGBqBVwoiKDHTpd/4RAb1k1b/itF14K5B5S+DfoeddCHkoXr34yDfrRe2lUCN5XWbbZ8cWXwfIaQ/5oVZdhXA0Y+CbEm6niSgFDkq6UYpowaqZApt6JWuVCkjoKKj50+igQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5xz1JeXlfUT2Ms5qq7rgdTVd52tGkioqMRriRtklUY=;
 b=HUkmL3a/GjaVALXk7FaBGIpmrUtIPeOOxtRehmuLYJ6HPyHSmA+MV5lium5p7YZBySq0D/m9lVC8t8veGWUDEOMI636ZX7btzldpIMaOtFNg954BFWq/SrOV3OHqfKdKEnzvZHa8T5shI4/O50WdyQSCgOsdTNfUYQ4ZvNmhulwovPpS8JaFqDBVv8Mxw0h87rTPGpsZygScLoHKQ3tjxwf6TXTR4L0QDKD1o54mm92QUeiQom0k2PQw2g0Ckq87IREQw6IEABoS1k8lxW2/PY4GPYqncCxVC77BxO+2aEKtMa8LoVddLPj5OYv3hfBD3JPnkJ9YIePY8g/wb4jxaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6244.namprd11.prod.outlook.com (2603:10b6:208:3e6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Tue, 4 Mar
 2025 09:54:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 09:54:00 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"xuyun_xy.xy@linux.alibaba.com" <xuyun_xy.xy@linux.alibaba.com>,
	"zijie.wei@linux.alibaba.com" <zijie.wei@linux.alibaba.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] KVM: x86: Rescan I/O APIC routes after EOI
 interception for old routing
Thread-Topic: [PATCH v5 3/3] KVM: x86: Rescan I/O APIC routes after EOI
 interception for old routing
Thread-Index: AQHbjKV9hUdG+IPYPkGuzgOeandLw7NivWaA
Date: Tue, 4 Mar 2025 09:54:00 +0000
Message-ID: <8e99d1bf0f2ad849aae66d0b3b67d25d1a4511cb.camel@intel.com>
References: <20250304013335.4155703-1-seanjc@google.com>
	 <20250304013335.4155703-4-seanjc@google.com>
In-Reply-To: <20250304013335.4155703-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6244:EE_
x-ms-office365-filtering-correlation-id: 796f395b-6b3f-4dcf-9fb6-08dd5b027d1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZENEd3FDdEtYbVU3NmxHWVYxejNQak1RUXpiMmVXeDl0ZWdRSU4yOXAwSFlD?=
 =?utf-8?B?TVRINlFKcktCZHZsQVpxS1A1STNVandwaGo0V1MxTkt6UWZ4ZzRydXNZVG8w?=
 =?utf-8?B?TkQwRldiRXlFMFdpVGtRSnN0V1ZNYWFIQ1lOYnEvcGt0MjBLakoxMlpDSEJW?=
 =?utf-8?B?TmE4Y1U3NC83OU1PUDdSRkVZM0FaQUk3YkJyOVJhY2hxNTVScDNjejdDMElw?=
 =?utf-8?B?REY4UGVQRFdiT1BjSU5iK2lpWHVvVXo0emo5ZGV3MGk2OWxVa3BnT3RNRUFR?=
 =?utf-8?B?VVB2cCtsS1kyamJHNVRRWGtsQ0M0ZVRpb3p1bSswNloxWEJheituSkVIYXdW?=
 =?utf-8?B?YjhLOGZ4a2J1Qk9OYjlhTGFaNUhWdXBnMmtSVU4yWFlyS2swbkNUTlFoMWFR?=
 =?utf-8?B?SnRIL05WYW9aTFN0L2p0eFR0Q0FGeENUbW9kMExXNFh5QlFqblhBWDl4Qkty?=
 =?utf-8?B?M2M3Z3J6c0FjY3lxZ2orU0t0R3RTR1FwQW9IWnlWUHhpNHlVcTdMU20rQWJU?=
 =?utf-8?B?c0Y4YkYvbWFaTTM4YXVpZXdOYzlqamxQc2RrTEtUME1qZ3lHNzNETGJLb3pK?=
 =?utf-8?B?MU9JT3h6UFBOdlpsWnhjWG9teEVUQ05xVTgveFFJVTNHVzZIS21XdFU5WlB0?=
 =?utf-8?B?RDJYcCtFOVN6N2RZRjV1NFRiVWxmMjBPWlc0NVhmVUNMOGNuN2h0bEtJa2sr?=
 =?utf-8?B?Um8zUUZqVW9GSmczR0ErZ3ZUNVBOMTh6a3ZCTUhPM2YvVkQ0SXdTTERMSyts?=
 =?utf-8?B?Ky91WmdLa2wyTW84NXV3ZG5BZjQyeEJVa21hM281c3p0WjBla2pxekg3NkZ5?=
 =?utf-8?B?NG4zRUxpaFlaQkc1U01hRm5ydWZVSUtCRUJLQmtqWUF5Y1gvWGdscHNRWlYz?=
 =?utf-8?B?TFBtbExjTWVuY2x3d0owSHZqWW9LOW9pcC9RbGhIRlhzdkVzK3NIdUdrZ2lP?=
 =?utf-8?B?L01ZTktidjBIK0JQZzdXQjdGUnNxMm5xOW1ucTdDeWhWdWgxc1o0S20ySVZ2?=
 =?utf-8?B?V1NsU1VEdjRuemcvcVNBcmlVSGdvV25ycUFKNzVJL1ZEVTZEcXpXNENVdWg0?=
 =?utf-8?B?WnNFRWRyb3JXL2QrbVdXTTM0WXNLNnkrZFFwWFJZcnBjME5aUm01ZWg1akI5?=
 =?utf-8?B?S3d5NFY5UzJzRGE1YmJRb1QrcUQyRWhwd1NNbGdTM3ZUT1BwNGx4b1Q4Uktw?=
 =?utf-8?B?MDJGbkF5SU43ZzcybVIwd1JzUGdYL2x3OHhUVXI5V0VLejNIbUduTXU1N1hk?=
 =?utf-8?B?Z1EvL01lWCtrTTNoa09QalprREt0SFF6VGg0RXZPRzBaVGI5blpVYVoxdGZt?=
 =?utf-8?B?RDNrNzZNTUduM0pOOGxHVVJIc1Vmd0I0OVFKL0hBSFdOYVk5cWVvcmxtbVVM?=
 =?utf-8?B?bjBUeXJnU2tBWWd1OTlhOThIclFhY2p6TGdGQXU5cFUzNDdCTTJaNzBROHZw?=
 =?utf-8?B?OUtpSVBPSXNEN3BsTC9Ya25LUXk0dUl0NTNEMHBFUGFwRU5pREFvcTY5SVg1?=
 =?utf-8?B?ZzlEV3F4R2pYMDA1UjJwNy9LVDhXTEZmM2dFT0FuSnBnd3pKMlRwOGRNOUxH?=
 =?utf-8?B?b29FTnhyd2k0TXZyL0lpTVlpWE5kSmpMNzhYdVE2N05pOHRlVFppZE1YZXRy?=
 =?utf-8?B?RHhPV2lBTDA5d2U0THdBNFFHMEFWV2JkOUt6Rm5LTng2WDJJMWZoaTlGQVI2?=
 =?utf-8?B?cC8xTmZ0QTNtRFpINkhGbm43UG5NTGdndjZiRjRmTWV3OGU3eVFPMmhEdko5?=
 =?utf-8?B?aXlpNS9sbUp2RG5FazNaMlJ4WWEzZ1hvYU0wNlRYVnQ4SmZ4QzRyc056WEhT?=
 =?utf-8?B?bHdRaXVKVnhkaWpFd3Q4amx5eUhKaUcxM2ZJa1NRd2I4ZlVPdTdjUFg3RENv?=
 =?utf-8?B?VDk0a2kxWC9wVFF0R1F5RWFITUozeTdFYjJUV2NmRWJjT09kWGgyYjZZL1Js?=
 =?utf-8?Q?iUa73x3vrrclSmYXxSX3F6ggpARsbT3y?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUlQNnZFbFRIREdLbzIvSVRUdEs2aU92WnRZOUFlcDRsb0NhZHJkckphNEF4?=
 =?utf-8?B?QXhtUmFzanJoNDZndTdqdm1td01xd3V0NHAwQUNldld6WHZHZXl6WWM5c1Vv?=
 =?utf-8?B?U0RqVUxXTk1tVElhSThPNWY1ZWRGdVI5ZVptcFRDdlB5Um1GdUIwVnA2cFMx?=
 =?utf-8?B?S2VZbVBTcjNZME9XTkdLNFdtMWcvUXl0c3A2cVRtbytFc3h5dHcvWTB5NDYw?=
 =?utf-8?B?WC80bTdiUmlqbXZTamk2OHQ4b1YzbnhJQk9vZlpUSTNWQ1JvTTUxOU9XTFZw?=
 =?utf-8?B?aE9KT3NTTEkzSk4vcVN5ZlMrWktCczZ6MlBTVDVvSzk5eEdYSlNGcFNuSi9O?=
 =?utf-8?B?QzM2MVFMdVR3M29EMlhLWEY4ckIrb0ZIMkhFNkdBNlpmblc4TURXbStHK3JD?=
 =?utf-8?B?RTVvV1JsWU5hUVQzTi85M21BeHQ2TFNUUGZGaWhtV3ArM0NzRGt0by9STlpY?=
 =?utf-8?B?a3dhb3dOYUR1cXc4QmpWdmRZVmQ3a3JldHZFaWtPcVY2dUdpbDhzM1Q1YmZ5?=
 =?utf-8?B?RWVvTTU0eTdDZ0YxT1h6eXFDS2cxT04wOS9oUVYzWGpLc2dSZTM3WXk2MWtz?=
 =?utf-8?B?akMySEE2YnZpU3NlcFF4WUlPaGU0OTJ1NlhFOXMxeUkrcTR6TXdzeFhRRE1q?=
 =?utf-8?B?YUs1c2R6M0greEpYMU1CT285RWNaVEp0K3NSeC80T25LQkpwQjNZWVFvZ1Zr?=
 =?utf-8?B?M1FsZ25STFEzd0JKeEFSdXgzc21hRXVDT3phRUFYNVNnOGRJV0ZuMTJGZFUw?=
 =?utf-8?B?MFkwMzFOME1MK0M3b0FBT1RLNU9zSmlhOVJyRU0za0RuUHdoS2JpWnBnWXd6?=
 =?utf-8?B?UkJsQm41L1Jwc2lJSHdlMTBFRTd1TFJQL3lSNm5ocUNaS2JCeTFIOG5TdlQ2?=
 =?utf-8?B?OE9RY0U4VHFNb1AvV1M2eEI1UnZvZHErZnZMcGIycjNadHVsUmZXYW53UlNK?=
 =?utf-8?B?bTF6VmVaSXRic3lKMzN3em9JeXppa3B5ejFsVk5BcGp5U2lINXJiL3A3RnU5?=
 =?utf-8?B?YmJSR3NCSFJ6cjh3bjB4QmEzSG5kMWtPbjFLRDU4NVFPYzRwMnJmZVVGUFZ2?=
 =?utf-8?B?QzBpTzIxcXVNQmpGb1duV2FkNFNTQVpPQnN6ZjhhaGZGckZYODdrVkxaWkR5?=
 =?utf-8?B?cUZBVDFVaVdFSTZVV2U4cDBFWXgzQ2QxU3ZTM3BMUWErU0VCUzAxOG4zNTAv?=
 =?utf-8?B?bTJpME1UcDVxRDdFTnJ0dkd2b1AzbWM3UllXNWxXSGpqeEc4emxCWmFQbFlH?=
 =?utf-8?B?RGNiL3BsMnNMejRwZzZjdi83NVpTOEtwQXZGQ1AyY3RkRm84anlYeTFGZWdP?=
 =?utf-8?B?cks3SGtSZVBIWS8xcklPNld0OHpnZGFUSTJETE5nVy9wSXI2aDJXVmVTVjF3?=
 =?utf-8?B?enBIa1crVnFWUXJRL2dTZ0MybVBWWmVNK2hFRngvRTljM0FFNUtwQ0VJRllo?=
 =?utf-8?B?Z0RSZFVWTzl5QzBteksraE1nRUN2cnhsSDRTeFZ0WDE3b3JBbXRpWVRscU56?=
 =?utf-8?B?QTlLRDFYelNiQTNWZk9vb21ZQi83SVBkYmxCeWQxblZieHV0M054TzBZRkQv?=
 =?utf-8?B?cFZNOVFsRmlmS2FiZG5uRWhOeDF1WWZEcndJOU8zN1lXZFRudTNKMnFWeHZ4?=
 =?utf-8?B?cGVXVGJycHlMQlNvZDd3RFNGOGVoVVRuMFVuZUJrTWMxanZHYUlMU3NZS1ov?=
 =?utf-8?B?b0JLRDExcXNPVk5md3lNM1JnSWRpMTZ4L1VZRXBoMi9zUm1OSUlJK3NpM2Jp?=
 =?utf-8?B?M2ZvMkR4SGNIeUhBVEhYbjhWdGtrTjJIOXB5bll1U2JjWjBQRWM0T0pVQkRu?=
 =?utf-8?B?MnNabWRoeHB5VzVXMlRjUlY1L2ZpSmIvdFBGbnZEcWhIYW9SOTdzV29vMGZp?=
 =?utf-8?B?dmh4MVdyUEc3SHVEbVhZdm11ellLNkFUcnIyaHFQR2RGQjlSQU5ndkxhQmdn?=
 =?utf-8?B?UkIyN0NQZHFnUUxGRXd2ZGlzQVNPRTdJRit1S1Bua1lBcHE3Sk1kOGg2VEFQ?=
 =?utf-8?B?TkVLMGswZHllN3FXKzBVbWJkejlBYnBqM0JKcTF5amVFREtUSFBPREdCMGJJ?=
 =?utf-8?B?bEVxaVRGY1F3N3VJcVhuN1l2U1NyLzRUZ2JuclowdmY2dkJVM3JkYXFvbk5s?=
 =?utf-8?Q?2E3N3gdvoE2GjiWCGFK7CkOWM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF42465DB354A742AF8BCF10811CF511@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 796f395b-6b3f-4dcf-9fb6-08dd5b027d1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 09:54:00.3209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tk9kSYo/z06W1I40bFxLi8q2gNCNRptNhkn2vk6/g749RJS5cAALIeCXMzAyZtm65YPYAsD7LL9ENDjUUTuhqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6244
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAzLTAzIGF0IDE3OjMzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiB3ZWl6aWppZSA8emlqaWUud2VpQGxpbnV4LmFsaWJhYmEuY29tPg0KPiAN
Cj4gUmVzY2FuIEkvTyBBUElDIHJvdXRlcyBmb3IgYSB2Q1BVIGFmdGVyIGhhbmRsaW5nIGFuIGlu
dGVyY2VwdGVkIEkvTyBBUElDDQo+IEVPSSBmb3IgYW4gSVJRIHRoYXQgaXMgbm90IHRhcmdldGlu
ZyBzYWlkIHZDUFUsIGkuZS4gYWZ0ZXIgaGFuZGxpbmcgd2hhdCdzDQo+IGVmZmVjdGl2ZWx5IGEg
c3RhbGUgRU9JIFZNLUV4aXQuICBJZiBhIGxldmVsLXRyaWdnZXJlZCBJUlEgaXMgaW4tZmxpZ2h0
DQo+IHdoZW4gSVJRIHJvdXRpbmcgY2hhbmdlcywgZS5nLiBiZWNhdXNlIHRoZSBndWVzdCBjaGFu
Z2Ugcm91dGluZyBmcm9tIGl0cw0KCQkJCQkJICAgXg0KCQkJCQkJICAgY2hhbmdlcyA/DQoNCj4g
SVJRIGhhbmRsZXIsIHRoZW4gS1ZNIGludGVyY2VwdHMgRU9JcyBvbiBib3RoIHRoZSBuZXcgYW5k
IG9sZCB0YXJnZXQgdkNQVXMsDQo+IHNvIHRoYXQgdGhlIGluLWZsaWdodCBJUlEgY2FuIGJlIGRl
LWFzc2VydGVkIHdoZW4gaXQncyBFT0knZC4NCj4gDQo+IEhvd2V2ZXIsIG9ubHkgdGhlIEVPSSBm
b3IgdGhlIGluLWZsaWdodCBJUlEgbmVlZHMgdG8gaW50ZXJjZXB0ZWQsIGFzIElSUXMNCgkJCQkJ
CQleDQoJCQkJCQkJYmUgaW50ZXJjZXB0ZWQNCg0KPiBvbiB0aGUgc2FtZSB2ZWN0b3Igd2l0aCB0
aGUgbmV3IHJvdXRpbmcgYXJlIGNvaW5jaWRlbnRhbCwgaS5lLiBvY2N1ciBvbmx5DQo+IGlmIHRo
ZSBndWVzdCBpcyByZXVzaW5nIHRoZSB2ZWN0b3IgZm9yIG11bHRpcGxlIGludGVycnVwdCBzb3Vy
Y2VzLiAgSWYgdGhlDQo+IEkvTyBBUElDIHJvdXRlcyBhcmVuJ3QgcmVzY2FubmVkLCBLVk0gd2ls
bCB1bm5lY2Vzc2FyaWx5IGludGVyY2VwdCBFT0lzDQo+IGZvciB0aGUgdmVjdG9yIGFuZCBuZWdh
dGl2ZSBpbXBhY3QgdGhlIHZDUFUncyBpbnRlcnJ1cHQgcGVyZm9ybWFuY2UuDQo+IA0KPiBOb3Rl
LCBib3RoIGNvbW1pdCBkYjJiZGNiYmJkMzIgKCJLVk06IHg4NjogZml4IGVkZ2UgRU9JIGFuZCBJ
T0FQSUMgcmVjb25maWcNCj4gcmFjZSIpIGFuZCBjb21taXQgMGZjNWEzNmRkNmIzICgiS1ZNOiB4
ODY6IGlvYXBpYzogRml4IGxldmVsLXRyaWdnZXJlZCBFT0kNCj4gYW5kIElPQVBJQyByZWNvbmZp
Z3VyZSByYWNlIikgbWVudGlvbmVkIHRoaXMgaXNzdWUsIGJ1dCBpdCB3YXMgY29uc2lkZXJlZA0K
PiBhICJyYXJlIiBvY2N1cnJlbmNlIHRodXMgd2FzIG5vdCBhZGRyZXNzZWQuICBIb3dldmVyIGlu
IHJlYWwgZW52aXJvbm1lbnRzLA0KPiB0aGlzIGlzc3VlIGNhbiBoYXBwZW4gZXZlbiBpbiBhIHdl
bGwtYmVoYXZlZCBndWVzdC4NCj4gDQo+IENjOiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5j
b20+DQo+IENvLWRldmVsb3BlZC1ieTogeHV5dW4gPHh1eXVuX3h5Lnh5QGxpbnV4LmFsaWJhYmEu
Y29tPg0KPiBTaWduZWQtb2ZmLWJ5OiB4dXl1biA8eHV5dW5feHkueHlAbGludXguYWxpYmFiYS5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IHdlaXppamllIDx6aWppZS53ZWlAbGludXguYWxpYmFiYS5j
b20+DQo+IFtzZWFuOiBtYXNzYWdlIGNoYW5nZWxvZyBhbmQgY29tbWVudHMsIHVzZSBpbnQvLTEs
IHJlc2V0IGF0IHNjYW5dDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNl
YW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50
ZWwuY29tPg0K

