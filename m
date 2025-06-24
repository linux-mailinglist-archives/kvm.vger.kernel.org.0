Return-Path: <kvm+bounces-50482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B02AE6269
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 12:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2067402CB7
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 10:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E394285068;
	Tue, 24 Jun 2025 10:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fm+osPHK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A7926A1BE;
	Tue, 24 Jun 2025 10:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760904; cv=fail; b=A/RY+6kSMdbezTj+CGnhb/JEhf8zeCx1snla77oouMHtKOUmNgsi6TBJCXgfqrsdOV5TUj3Vnv9gut2NCHYZAcGvWPQm9Np6k+uIuFRzfKUyuFFGvajT+RLywczVD5MqDwWGlxuXlM2qSPBMKySVSo/38snJ/rzM6nfO4PXOtw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760904; c=relaxed/simple;
	bh=lS9X7Fe8xXSVCr/Pa4kAk0lEMjWAsJwDA2G2LX0nwRs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eTKZCS43zZGYNmUKsyIbUUegDGb3mQBmoQ9dlLm0Q0q8OBpVXF67Cttt4+/EwtiEdR0uLr8wNIBWTtojpb/n46SH5usYVU7+dPJFqokas2H7kRAtpsYa8DZl+wKexqkWzXoOB1PEk1aNhme8lqS1GaKwcmfQ2fVuG10tUpg0HSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fm+osPHK; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750760904; x=1782296904;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lS9X7Fe8xXSVCr/Pa4kAk0lEMjWAsJwDA2G2LX0nwRs=;
  b=fm+osPHKuEGVdsPmQ+7qnsrZa9Hz7qTYNhJ8PAfuSSk1AX6uYy5LSsm5
   zs0TjVjtv1/1rpKzTudbkbBTLi8PyYmnM2z9EsuofaZl3FKEwWp+yB2bM
   J7b94vc7HEYPWm2itF4z1vc8CC/W1yOTZ0eoJrr0gOW0+on/Zy4JUQ/Bi
   RjmtwH+mJgX+jpeBTr2vY7S/tOEBkgzgk7DHAGx9T3saQeK8CLYVBuehl
   SXFJFN9bmjtGJDvW8ClPSGZoF8h+ASGoeRSqGAPfIIf6buuO+PV9XWzoU
   HmI+1lj8IAqXRQUlr+OdFZ7U0iP49BSsppaMqM818ITxAt+33a8CVkgyU
   A==;
X-CSE-ConnectionGUID: EGub3vltScmOVaI2kU7Tjg==
X-CSE-MsgGUID: MkGn8VO8Q7ayn4FUwOv48Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="56777942"
X-IronPort-AV: E=Sophos;i="6.16,261,1744095600"; 
   d="scan'208";a="56777942"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 03:28:23 -0700
X-CSE-ConnectionGUID: NqnKTIjFSdeNw6vWJ0UhSg==
X-CSE-MsgGUID: QC4ZgrSkQ4+8bhbitofeBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,261,1744095600"; 
   d="scan'208";a="152169292"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 03:28:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 03:28:21 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 03:28:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.57) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 03:28:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fzRqmw+sAxyubqlnlBMFWz6q+NLCi1Xf4yRN6pbI3+oqCSX8+mcpMHccdSKGOtJGO360EqZRJ+tfZU480qlrpeVNp13FWPRfIn7qHN3RcexyXzbKkO5FNC9KHzx3Pr9+w1DZWK6m+JeRcBg8cAJLTuYxTScv+BUDTVKnZ0otWaSlovZ+fCTIbhC6AQmEFJ2WJAOYsZ+Ss3433CiiTyoo6sQ9e9M1absHY6HuBWfLcpWGaePGiU4Nou+WaUhA5KOwsRr09DJLgd4FStoLNHE/vNRZOagDNc/Cwz6wMD0lQN/0jkouCyURsfgzQT2asDv9jfuyfgZsWAfTMwGW33jqQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lS9X7Fe8xXSVCr/Pa4kAk0lEMjWAsJwDA2G2LX0nwRs=;
 b=xVPD8kWeIrOcu7JgubXt7nQj07GdpGAwjajtlD4h+reBeGqmEewJxQmYnVJwkaW5QRMJeh/V4yzl1Cgc+9WzIMtzGK3bjzv+UfU2YOCw4jZw+EGUEObg8HMgi0IZGOkxHSRLl4k5QUitfiWsHHUaqmFvsiok1WEHVhZuhMUAbokaK8fEpOBs0d6VBG1xp5iqxvzfBSBTlBy5m6t6TF31xpUK4K8q+og4bMLATBBPpDyYhUpM5t5EUFgYMIgZVTUgkE0A+RiaZz22bA+xv5YhWGs/VZUEPn4bvD8itivCklHg+gvht8tMExZA+Z2sMHXSCRwZIaisv39Qs/AVveeF2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BY1PR11MB8053.namprd11.prod.outlook.com (2603:10b6:a03:525::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Tue, 24 Jun
 2025 10:28:18 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Tue, 24 Jun 2025
 10:28:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Neeraj.Upadhyay@amd.com" <Neeraj.Upadhyay@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tiala@microsoft.com"
	<tiala@microsoft.com>, "Vasant.Hegde@amd.com" <Vasant.Hegde@amd.com>,
	"Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "huibo.wang@amd.com"
	<huibo.wang@amd.com>, "Santosh.Shukla@amd.com" <Santosh.Shukla@amd.com>,
	"nikunj@amd.com" <nikunj@amd.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>,
	"naveen.rao@amd.com" <naveen.rao@amd.com>, "David.Kaplan@amd.com"
	<David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v7 17/37] x86/apic: Unionize apic regs for 32bit/64bit
 access w/o type casting
Thread-Topic: [RFC PATCH v7 17/37] x86/apic: Unionize apic regs for
 32bit/64bit access w/o type casting
Thread-Index: AQHb2jG9eY4JLzyyEEiJtn+WnaO5rLQSMP4A
Date: Tue, 24 Jun 2025 10:28:17 +0000
Message-ID: <05a9de6392a4ade9c9e70953be2a6a87a06044ca.camel@intel.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
	 <20250610175424.209796-18-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250610175424.209796-18-Neeraj.Upadhyay@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BY1PR11MB8053:EE_
x-ms-office365-filtering-correlation-id: ce4b24bd-767d-4157-8c7a-08ddb309d593
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YThFc3BiTkU5TmZseERXSHp1YXlRMXB4T3VhKzZ1eVBJc05ubTc1Z1k2SnUv?=
 =?utf-8?B?RzhEb0lGNC9JUWVHQTB6dlFWK0lpbldobythVENxUzY4Q1Y2SUU4MDh0c0lH?=
 =?utf-8?B?NnFaTUFjSjVnK3N1ZTRFTFlPU1RMNWRQWmVOdkJuYXg5OEhiWDNnM1ExM0lX?=
 =?utf-8?B?NllnSlI5dmxLQXdydDNpcDNMUWlSYXMxR1R3VDNzcFBvdUpETmZsbnVEMkhN?=
 =?utf-8?B?bUxXWUp4dVlpMWNvSVcvTmsvMUtTZkcvRXhvM0U1eXRUS0tNZGxpMEc3dGo2?=
 =?utf-8?B?TitkditSKzdWS3UvQytReDVmemNIclZyVlFBcUZKTTY5dWI2WDlwMEN5RVNG?=
 =?utf-8?B?TEE2eFVuYk4rMEJ1WndjOU4vbVZUZmZLeHpidlRmUnd5L3cyM0FSa2trUk0r?=
 =?utf-8?B?THZJcjNsdGswbUNpYnp2S1lycEo2R2hGYmFHQ1VVbmw4N1l1WmJNbVpVN0lC?=
 =?utf-8?B?andYMHhBc1NsOWs3SS9NamFJNXdYN3VFakZ6enVRR3BTdE5IK3I4aG5GRVJv?=
 =?utf-8?B?WUh1OE1KREozKzZNREpTK3Y3SGY5cnUydW1FOFJqK3BxR0xLd2lnME4vVm1H?=
 =?utf-8?B?dEpqdmFmblJ6MFZ4WERVNTZweExMaElhU01lNjBTT1hicjZLd2daZlUzTDZu?=
 =?utf-8?B?dWN3QmRleWhvM05mUmNrdUZIdXhRZXEvRUw0a2ZCYkNPK1dwblFKMkJoT09w?=
 =?utf-8?B?QUJWVC9qbWd2Si9QdWh2ODVMRmRBNC9JRlhpc3hqaGI4ejZqbGdrcitvMXZM?=
 =?utf-8?B?RUlCN2h2aHFWRC9mNUExMENqY1pvcjV3N2h6dUlUcDJweDhOdkZ5RVRyNlBs?=
 =?utf-8?B?RzZra1AwVldCZE16aTN6b3hSZ2lWbm9PNEdQVHRheUFCUGdVWmRZbUdBd3dh?=
 =?utf-8?B?ZnFEMUttOERXeFhaQ0NrYk5YZGpHNzliSkp5Vmd0R3RFaGhQZ3d2cE1mUGVk?=
 =?utf-8?B?OVFCMERmMTlBR3RuWUMzQnpYc0k4ZnNVTTlHcjRoRzhrcjB0WlhrWVBnOXZr?=
 =?utf-8?B?MWttRlAvb2FMRWxZUGhqZFJEQWl1WTBFN1RDK2lpTlpocW9rMmhqU0dnbnNw?=
 =?utf-8?B?TVBZRnAveWJQUDVic1hNZ0JieU9QOUJYVFBpT0RySzBOcWNIK3ZKQ1g4R3B6?=
 =?utf-8?B?c0EyTW0rbnFpZmloL3VCS3NxL1NtM1hydHZEYzQ1WFJDdm1kM1AzVWxaREM0?=
 =?utf-8?B?b01ob3lZbDVNU0tCMWtpUmg1WVZ1T2E1U0dMYm1SbitNQnpuVUhYTHhlN1Jq?=
 =?utf-8?B?bjREQkpXNW5WUGt0ZGM3SXZnSmNRZE44Uzd2M0RtNXJzaWtHVUNVa3VRSXZi?=
 =?utf-8?B?enVGT0lsUVUrbVFQYU1HNUo0WU03Q0ZiaWR6alFlalRZSUcrbEY0cGU2M085?=
 =?utf-8?B?NFp3cGFTYUFIeUc3SFZKZnQwSG1ESGM2RlNqYVk2djVGc24zRitzd2NyMCtM?=
 =?utf-8?B?L2ZXeXJzM1dTWk8vSWhvNjVlVmlYL1FjdnZDTVNZQ2htQ1FvTWxrTHNMMDhk?=
 =?utf-8?B?cUZ1Vm5UOGtPWW5jOS9rc1BaaHEwVkh0S3NSOHNwOFJxQjlyL05ZL0JNZFFk?=
 =?utf-8?B?c2JNSnZtSlUvTklrcDFvd0lUZFU4UHl0azQ5aWo1YjlNOERZbERhaS9ZMDQ2?=
 =?utf-8?B?azVIYjNRL0dNTUZMbStzWXhGQ0xGNWZuM2J4TVNkbExBS0RKc0VsbzJSak5X?=
 =?utf-8?B?RVhQMWtSdjhDeWp4VkVvSUh1cDRtamFOam5BdDdHNkxwSHJ3V1Rja3MrSk5J?=
 =?utf-8?B?Z0hHZzFMSHMvK3FnNnRqRGx1RFVUWHB2ZUR5dEVqV25yQno4SzNHWkNCMVUw?=
 =?utf-8?B?SnJTY3YxRzdIRTR3MGtWMy9HV2Ntcjg1WUFUcHZCUVQ1bWQwZkJTVVg3VHhh?=
 =?utf-8?B?N0FWdEl6bnk3VDVSTElqVmpOQ3pudnVYcWZFamZVY3o2WU9rZXd3dzRwZ2ZQ?=
 =?utf-8?B?QXdPSEdXUzBIUkhFUzAwZWNnMStOaVZGTElnUHQ5em9LNGU0SCtyWUpsNjI0?=
 =?utf-8?Q?hcnPYhpWy+FnYrGvtQGrsnBGU5DwcY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RG50SkY5RFh5YzlJdndPUnRQd0lLMm4zMGF3U0xMbHFTVkNKelIvZlZ0amZW?=
 =?utf-8?B?dERjdTY1a2NzT0p2YjRnKzhzRE13cDIzSVpHMjRmckZCUUtrQ2xTcXpnTHRZ?=
 =?utf-8?B?ZkRadFd1WHhOZmt5WXNSaStMbmlkWjFoeXpGUHZBSlRKc1FQWWRFOHhueGdS?=
 =?utf-8?B?OW9oYnBkYlJXb1B6bG1NVkdVblBiUCtDcldZZEVVR3gyMFZkR2xzd1Fhb2di?=
 =?utf-8?B?Z1paYXNuNkdTQVgxdDNUblRKRzM0Q2xsZUIzODJMRC9EMUJ4K1dJcWZxWmd6?=
 =?utf-8?B?TWdjZmpwSnoyd0RhaE1MNzROYyt3THNhRHFBSzVxK3lQb2dDaElPdjBzNGU3?=
 =?utf-8?B?bEg0N1VmbUpYbzdHQ2N3ZW15MU5kL0lXZmNhOWFSeWM4RjNMMUU3cG5RMXgw?=
 =?utf-8?B?ZzJ1R0Q1TVVsaXBhUXJkSTZDT1VYUThQQklkWC9xYnplMGsxTzZZMmMvcWlM?=
 =?utf-8?B?djF2UVhXaGlmekdMMUQvT0crdDRCN0ZZUE5UWUtXcCtLYkdLYTJ0VUpCUW9s?=
 =?utf-8?B?RWdrSENrMmRUNVU3NkZ1YU9mQmVTQmN0UW1uNHQrdTM1SVpaZW56enYxS0VO?=
 =?utf-8?B?UU1qYUpubGpPeGxLQlRJMUNSTG95TkRwKzdzWU1vVVd1eG9USE8vRGhaemF5?=
 =?utf-8?B?dytKSG1Fd1IrWFhFQllRekErQks2Z0tBWnBvbWlXdm1ueExKYlY3NGxDZk1U?=
 =?utf-8?B?eVVFSVhjWW4zMURyTElTM3doKzE5UXF0L1M5Z3p2WmRQWVhJUnpGalM5dlFQ?=
 =?utf-8?B?TTVjZGRXZGxlSDZMRnNoWjFKL1NTWnEyWjkwQzBTYkxLbEZQWXdLMG9wSERK?=
 =?utf-8?B?RFQxM1pCam9vVlZIckVIc2xxZzU0amV2cnJycmpjV2dOaWpwdmVVa0tMTHRR?=
 =?utf-8?B?enJ1RWRHRkViTnk2dHRvUG1jKzdoSTEwT1dMN2RlMXNQQ0diWTFLVVhaZ2xW?=
 =?utf-8?B?QkNkQTh0eGp2UUlkQ1ZlUjcwR2VkZE9nQzRrUDRXaWRRM0p4NlE3bk9HOXN5?=
 =?utf-8?B?ZXFtU1o1Z2RNejJ2SysyTzR0Rmk2QUFyL05ESCtlMVlXZ3VjS3RZaE5SN0I5?=
 =?utf-8?B?QldSQlFWRmN3OUc4V1ppbGlPc2dUaVZvdWtSbENJV293NHB3Skc5bWJvd3Bz?=
 =?utf-8?B?Tmo1ZGtTQ1YvNkl3ZVl2TmwrazB5WGFIa3h0K0ZYRDQ1aWprV1BkWmZZdGFB?=
 =?utf-8?B?U0NwUVNia2c1R2FGRzY3VXNMam5jaDdGTk9yUWFJV2VYM1NmR3FZSWZWeHlC?=
 =?utf-8?B?NnlnUDIvUnN3YUZ0eVlwRjFTUjFqNmlxcmY3QUNvbDdiRU5vYUtuTk53Qkcx?=
 =?utf-8?B?VTl4RVU4K0taYkZFdDN3WnBjamt4RXdMN3NUZng5MkFqbTJKVnFUWW1tMStQ?=
 =?utf-8?B?cVZFQTZxNGF2RzBIVUhxVXF5cDJ2WVYvQjU0SXoxQmkwZW0wZVEwalBURmYz?=
 =?utf-8?B?VWo0T25EemhwZW1CR05panBxeTlEaDhsc1VMcDVKWTRrWmhUOXg5c2dacTh1?=
 =?utf-8?B?SGp2eXVwRldtQVNBbTR3OFEvRW5tQ0l3NitvcjNBWG5HS2JGK2xSbWl3ZlZr?=
 =?utf-8?B?YUVubGp2eE5DQm54RTNKUG5ReWhKOER3V2cxSFVTbDlIak8vOWI1SVhiUmsy?=
 =?utf-8?B?L2xpVEIzazFXMGJaNmdJNFg1RHRONEorNGFqTWZBLzZGRGl5K1BpVksxM0FD?=
 =?utf-8?B?SXJyTEYrbE92aU40V0N2NittRmNDb29pWXpLL2NEOFRLbGk2NlF3YURvYVVZ?=
 =?utf-8?B?dXo3OWtYVkQwMUo0SmhrSGpFU2tTMzJMQ1JSVnRDck40YjBCRWg5dzdIdkZ0?=
 =?utf-8?B?R1pSN2dWNlo1ODVvcFNBQk0yVnJTSms5R3ZtdnpGUmRCRHB1NVlneDl3OGZu?=
 =?utf-8?B?QVlZc0xPQUo1MkJraWllMHZOUGNJVktNS3JMN29jdG8rN3BFSCs0QTVCZlov?=
 =?utf-8?B?L3N0Tysrb0sxOUdldjcydDZER3llazd1WkFhUlBmNWtBeGdVMFNjV0U0Q05M?=
 =?utf-8?B?SytyMmZkRkRHb1kzMXlZUnlVeEVJRjYxcHljeGNveGFpRitMUDRvSUVPYjNL?=
 =?utf-8?B?VEZmVVgxUks4bFZGa0MxWlo3UUEwWk5ZVUsyU0pUeW9MWHdnQkJuY0FTZUl3?=
 =?utf-8?Q?gl1eC9nmiFguylvO2XbBS6XPi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91F9F7EE87D0DE409ECA90E04786FD6E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4b24bd-767d-4157-8c7a-08ddb309d593
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2025 10:28:17.5318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: unVKxwT0iZjA+eBK/bgMbcdHhLzMQJ4y6nPE4xXupBlGQCIToWsmOg5cvO6U2p7r/ajhRvtwSNFrJ6qcNpwiMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8053
X-OriginatorOrg: intel.com

DQo+ICtzdHJ1Y3QgYXBpY19wYWdlIHsNCj4gKwl1bmlvbiB7DQo+ICsJCXU2NCAgICAgcmVnczY0
W1BBR0VfU0laRSAvIDhdOw0KPiArCQl1MzIgICAgIHJlZ3NbUEFHRV9TSVpFIC8gNF07DQo+ICsJ
CXU4ICAgICAgYnl0ZXNbUEFHRV9TSVpFXTsNCj4gKwl9Ow0KPiArfSBfX2FsaWduZWQoUEFHRV9T
SVpFKTsNCg0KVGhlICdieXRlcycgZmllbGQgaXMgbmV2ZXIgdXNlZC4gIFNob3VsZCBpdCBiZSBy
ZW1vdmVkPw0KDQo+ICsNCj4gIHN0YXRpYyBpbmxpbmUgdTMyIGFwaWNfZ2V0X3JlZyh2b2lkICpy
ZWdzLCBpbnQgcmVnKQ0KPiAgew0KPiAtCXJldHVybiAqKCh1MzIgKikgKHJlZ3MgKyByZWcpKTsN
Cj4gKwlzdHJ1Y3QgYXBpY19wYWdlICphcCA9IHJlZ3M7DQo+ICsNCj4gKwlyZXR1cm4gYXAtPnJl
Z3NbcmVnIC8gNF07DQo+ICB9DQo+ICANCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCBhcGljX3NldF9y
ZWcodm9pZCAqcmVncywgaW50IHJlZywgdTMyIHZhbCkNCj4gIHsNCj4gLQkqKCh1MzIgKikgKHJl
Z3MgKyByZWcpKSA9IHZhbDsNCj4gKwlzdHJ1Y3QgYXBpY19wYWdlICphcCA9IHJlZ3M7DQo+ICsN
Cj4gKwlhcC0+cmVnc1tyZWcgLyA0XSA9IHZhbDsNCj4gIH0NCj4gIA0KPiAgc3RhdGljIF9fYWx3
YXlzX2lubGluZSB1NjQgYXBpY19nZXRfcmVnNjQodm9pZCAqcmVncywgaW50IHJlZykNCj4gIHsN
Cj4gKwlzdHJ1Y3QgYXBpY19wYWdlICphcCA9IHJlZ3M7DQo+ICsNCj4gIAlCVUlMRF9CVUdfT04o
cmVnICE9IEFQSUNfSUNSKTsNCj4gLQlyZXR1cm4gKigodTY0ICopIChyZWdzICsgcmVnKSk7DQo+
ICsNCj4gKwlyZXR1cm4gYXAtPnJlZ3M2NFtyZWcgLyA4XTsNCj4gIH0NCj4gIA0KPiAgc3RhdGlj
IF9fYWx3YXlzX2lubGluZSB2b2lkIGFwaWNfc2V0X3JlZzY0KHZvaWQgKnJlZ3MsIGludCByZWcs
IHU2NCB2YWwpDQo+ICB7DQo+ICsJc3RydWN0IGFwaWNfcGFnZSAqYXAgPSByZWdzOw0KPiArDQo+
ICAJQlVJTERfQlVHX09OKHJlZyAhPSBBUElDX0lDUik7DQo+IC0JKigodTY0ICopIChyZWdzICsg
cmVnKSkgPSB2YWw7DQo+ICsJYXAtPnJlZ3M2NFtyZWcgLyA4XSA9IHZhbDsNCj4gIH0NCj4gIA0K
PiAgc3RhdGljIGlubGluZSB2b2lkIGFwaWNfY2xlYXJfdmVjdG9yKGludCB2ZWMsIHZvaWQgKmJp
dG1hcCkNCg==

