Return-Path: <kvm+bounces-50924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 895D4AEABC6
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 02:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C06621C40BD3
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A59012E5B;
	Fri, 27 Jun 2025 00:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e5YnQLaH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4969D259C;
	Fri, 27 Jun 2025 00:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750984212; cv=fail; b=Ucc527EB5ac2iZTWaNY7dlIHnVnAZhia2Hugq19f7RhvEqneSPZpYegMvnhKrdFKpEC40Kdr28PcYYTJDa6QPanB3zGBSsG0jUTzoG47CjAcZUShfTc1pdLVeZa/ou60hrwj+fM4/FDlonbElvwv83whJPF/rHqzwzBaE38tHgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750984212; c=relaxed/simple;
	bh=+vo2vc9FPloaVk/SjMzsnrlxpS3e9AHMfRLoXOajy8k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A+DI4dAw3RvyUhynRAUr5Yqkyo02C7Iw448bqZ59v8vb42qYZDTaIPV0r3lVS5V3amwgGdk0Uyu3EOuDbZlklVJ6VFiCQwDWaFLRumPYo9aWRiDGx8LfV5GaoaIFAq+PyzftBq+oQoSh1eoYPLvqZ6LP5JX8oU4uaMdkUbMmZ/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e5YnQLaH; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750984211; x=1782520211;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+vo2vc9FPloaVk/SjMzsnrlxpS3e9AHMfRLoXOajy8k=;
  b=e5YnQLaH80ypnIXi/MfUIwZOqv4oUCL2siU2vhjje6DMxpQm5MAYIvSP
   78DyzzOP9KorSUaBA69ToVc2p+yZkGfywxYwmSunwlVW225JZ3RTsO8fu
   0TM1OCx/PrctaBCQnCOZRSqQ36NpjR2iNIvLn657VhxI1VV1TSteZmY89
   kGXmmOxCM3zJ7xfuQzLcgeD0Vke7l0MIrNucy9AeoUS+pteHGCgpY8mEq
   laa51qB5D54AA5yctz7K6R0j7hLgHnXD4t+Sy/QcwVefUKsUSAkK00As6
   KfITYpq3zaN+7685l0kQD0XkpJH3ap1hIQMmV62E3q8N52g1cmqJBdbYJ
   g==;
X-CSE-ConnectionGUID: O9DcvaYxQruVZl0E2fbz/w==
X-CSE-MsgGUID: woFprZzORn+Bx4CjxjQXDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="64652228"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="64652228"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:30:09 -0700
X-CSE-ConnectionGUID: f4yqUZoOS9G2IHB0e4+FgA==
X-CSE-MsgGUID: +PZC5Y26RFqaUKMeESEEzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="152412643"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:30:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:30:09 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 17:30:09 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.62) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:30:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kfWqVU4DlI74uKRaYFnuc60A2+dr6k+PBRd0dgimIznbTXZanedLRYu6TNtwR/T0bYfcXfu9lX3XSPX2c9Ag6BMFDltxGWPCdvCQJMGjqrhWKwhzKVtEj2T/YXcUekixuGiM3J6vZ5ZfRYe3XOQHKHMMhTAHynIgwoOVCZAN46NqltnCeK0jyzGZ0VDroI1p7FZB5xJL+T07RrkLZPiAe8gR2w1o6JeL4Pd64JbqS/85Yew25dhHodxLHM6lQ8cnGgQ91/D1wb+7sasoIXKaZtU6TxHV+VK7fSpAk70aGmlNKMzttabIp0sfWSXGWOhZn3LowwWhKpS/Kp3Xg9OBcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vo2vc9FPloaVk/SjMzsnrlxpS3e9AHMfRLoXOajy8k=;
 b=DOfOmQsvhWSxr3pmxk3tE2MLO5XLyN60TDxv5jZi2AHqopx26i2VBoGIsDZM4zoRiF2m1pS0P3y/WXjq8P39c5UrYvk1Gzw1hdTlrz8ZQyMpb/zWaEJ2ssxDlwxOyGxCcO6ds6VlJ66GZFdsb2d2gFWBRUm5f427UPAKdRPhh8eqpJSJMqFFXgODlFfSuDhPD5kJ8lHYgzTBx4JzSrWflwMigYv0pulIOFIAqe6EKFyndvvjhYZ5M+aVs1O9f6WCwMswNOSwbrA00st17Ec89wPmOozpRhi7EFZw3pekM5XAoQfsglQ1D3AxzeFYD6WO+lMFP3dXu9TSjOi1bl1y7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB7253.namprd11.prod.outlook.com (2603:10b6:8:10f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Fri, 27 Jun
 2025 00:30:06 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 00:30:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Topic: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Index: AQHb5ob1Aej6jhsWsE288GxQicmcLLQVuwOAgAAL8ICAAGE8AA==
Date: Fri, 27 Jun 2025 00:30:06 +0000
Message-ID: <0b8948ed672ebf6701ddc350914e4e325032ad87.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
		 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
		 <ffcb59ff61de9b3189cf1f1cc2f331c5d0b54170.camel@intel.com>
	 <b368fb3399d1e64e98fb9ad6a7a214387c097825.camel@intel.com>
In-Reply-To: <b368fb3399d1e64e98fb9ad6a7a214387c097825.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB7253:EE_
x-ms-office365-filtering-correlation-id: 5b38f99d-f562-46b3-81ee-08ddb511c43d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?aWN4dVczSy9vVVAvMFNNVElqdU90UHBYbGhMZ2szazJ5MlNBZ0hWZEtlY3RM?=
 =?utf-8?B?eFBqU0Q2aE5BQVZRUFFCU1RMTVhUc0QxMjdvdm1KeVZ5M2FMNi8vbXlqQVdW?=
 =?utf-8?B?dEI2V0NTVkp3TWIyTk4vdG1Wck9rcWZxdzBZakU2UitKYnFxME9UanVFMXBj?=
 =?utf-8?B?Zy9KTlQvbHB3YUlyMkdoMG1iN0pvSEdLYy9uSkdJLzhKT2JUNkVobk1CYk9H?=
 =?utf-8?B?T2sxaDdVOFFEV0VLbU1QcWp3Q2RLQ0FQdExkWGRQZy9LY3lGS2J3Y3FGTFVE?=
 =?utf-8?B?RVNHMHJuOXNmUXUraVZjZ2owcjhjTngvcmd6NEJKWWpRZXhiZzhkSGZQL3No?=
 =?utf-8?B?Y0YySVhUaWY2Q2Q1OU1vZ3RCSUZ1NEwya1RTTVZhVWNlNHFzTDBDdTZodU9y?=
 =?utf-8?B?ZFBkdmU0SW5ZUEY2OGZsSGg1ekVGaWd1bXY2ME1UdjNnQjZQUEJEay9ncUFo?=
 =?utf-8?B?Zkh0QnF1bEdoajJzd3V5SmFKYkJNM1ZNbmJrTmVVZFF5SENFMXdsK0NGVnBL?=
 =?utf-8?B?TXVuQStFaTd5YVBpRXI5WGVISGZzOVVPcEcrZjFOUU52Si9Mc2dsZzRZRkRa?=
 =?utf-8?B?Zko1d0hkblNIZG9xS1BSRVh1Q0V6RjVQYWF0NWpwcUZ3RnJNUTM4YTROUDJZ?=
 =?utf-8?B?WjIrQjFFcy9GQkROeWVDcENNQWZHVUpaSHArOHk2M1F1Y1ZIdUFkb1I1ekQ4?=
 =?utf-8?B?TTd5K2NhdFRxcjJHUkQxOWJZdjRJMHRKcHVjejAzaTF6OGlvSlR1NlZyS2do?=
 =?utf-8?B?YnNpcXVmTTRLMWRvWGs1TGt3NU9ub3c3dERtbU9QRzJteHdhVmlXY3Q5eGlN?=
 =?utf-8?B?eVEzcDFMMzZVNmxIOW45VU92OGY3aSsvdnRSVnlrTGdndWV6SVNQQmhCZWp0?=
 =?utf-8?B?TU56Z085TDZsWDIyYTZ1YmFZSWdHMUs2QU9OOGlKWjFTRThKZzFDMk8wR25E?=
 =?utf-8?B?V0w0RHJscC9ZbDdLYUsyeGxRczNiQzlndDdXSERrRjRjOWE0akthbkpLTUdm?=
 =?utf-8?B?ZSs1ZldTRHNYRUJMRGxNSnA4aEFQRWZLTDJXZEwwcXRBSGx1OWcrSlJENnlI?=
 =?utf-8?B?RGNvYUhROCtwTjhzcTErSnhtMWFjb3Fjb2xCMzZaU2Z2bi90OXR2N2x5YWs0?=
 =?utf-8?B?NkhBY0s2dUdJcm5YY1hFQ2N5OWxGZ0ExVFdudUdja2Q2Y29uaDgzbWQ5bDZq?=
 =?utf-8?B?bVVGdE0zN280VUpEM1FjN2NDaVJFa0RDUGFaME5JbTI1Z3FBSkYzMExCYlZs?=
 =?utf-8?B?ZVUvOTdzR05Jb2s1QjZWT3ZMeTZzclBWaE5UVkJsTnROV0IvaXQ5UDVPU3Jk?=
 =?utf-8?B?ZXJXOHpoUk1LNmN5U3BQVTlEQjd6L3lJN1ZreWx4aTgrQ0lSZXN6VURXeW9y?=
 =?utf-8?B?eEc3ZVlaaXdFTXBsTU5FTkhDWHZGcUF5dGRjNE53V3VxVndnUER1bE9GcmJi?=
 =?utf-8?B?b2xJV2FnTHJQbEg4bzhtL2plTE1QWHlDR2tLQ0xFOU1KMXhFMnpLQTVIY1E0?=
 =?utf-8?B?T3FmVzJRdUk5YURsWUphRncxWE1WVzMvbzhKdXJaeUhPTFFIa3pjT2Q4MjR5?=
 =?utf-8?B?U05wcUlMMzNCRFlSZWtRaVYzQUZUSythazhOSzBQaUovaFVteE05SS9RU250?=
 =?utf-8?B?LzRveVdEWk5PajF3ck5WYkEyQU9xOWp5R3QvOFo4Mk83VjlSZU83Y3hlaGxj?=
 =?utf-8?B?c01MZ284enNPNUVHWXBXWlV1OEpjR0k1U3JHem5yNlFEVkxuTU1GRDhnY3BI?=
 =?utf-8?B?cWwxSW5NNzg0SGZRbVJyL0NTYWFXZ2E5dUNsVm1GOHhYKzdla2VNVnlsOFBx?=
 =?utf-8?B?RmZONmh4OTNWRjVsd0VsVTdZQXozZ2VNdERTeVBRbTlDcG03cDNXS2lJUW9U?=
 =?utf-8?B?ZjZPci9jVTVZdkRkQUdqRVN6cUhFcGFXbUVnb29hbGF3dGxxYXJpREtuNXdN?=
 =?utf-8?B?dTRubXJVRzRvcGtZQ3Q5eWxEZm1CY3JlL0NBQ0NDdmNnYnFFWlVuTVUrNUlC?=
 =?utf-8?Q?TZ92Dsxhc/dHedmx5VoyDjIXzKYyxo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUFLTUoxS0pSYjIralpjMU84ZGlkaER2T096TWJqdHJmT0JncFdBL1FPYmR5?=
 =?utf-8?B?Z1NQM09mWUgzQXRsTzhTb1VjcWpsY2p2QXVMVnM0ZzlWdXJJS2pHcTJsalha?=
 =?utf-8?B?d1ZYamNDWllCM2pWSC9EZDdQVWVGbVpyY2M2aWd0VEFnK3ZRcDZsaWdsZEN1?=
 =?utf-8?B?K05wa3ByWGhmMDJkaFJpZnoydmppU0lkNHI0eVcvMUpGOVlDWFlsY1RmR3oz?=
 =?utf-8?B?MG9Ia2ZjUW94NDdjQXdWUERsSDZ3VGZJZWs1bjgrU0FkRktMSmsrTnAzSGJH?=
 =?utf-8?B?eGJpeko2NVhqM0JUYWpndWFHaGVuYUpWa2Izd09EQ2VCTlZQK0xOR1g4azky?=
 =?utf-8?B?eGFabGZYVXpqZW5ldUNGaEVYRlpjNWQ1dmxDZ241VWJuRmlDcjBmRUNRYmxS?=
 =?utf-8?B?WkVnRTFUZ2VGV05wOVNvSXk2WExMdHNCblpXa3owRlRFbUQ0YS9CNEdBeEN1?=
 =?utf-8?B?S29tVEFVclpvazRLNEJSakU0azAwbmd3dGJCUmpSSDhKMTZXOHNpZmV4Skpr?=
 =?utf-8?B?WjFyTmI5SkZvQmVOZFk2b0gycDBvM0c4TzgvSkx6ZXRJV2c0Z24zZm40L1Ur?=
 =?utf-8?B?empoTDAvbEVmQTJjNXUydnBzRjBTYmUyVmlwK1ZjTHo2bXZTa2Yxc3FEcjNE?=
 =?utf-8?B?VmswVUZZVG9kR3NlZmIrcmpJL29vRkw3djJ4QnpWclIyNFVhd096bmt5c2Fq?=
 =?utf-8?B?SDIwZ0RnYTQrTXZLQldQYkN4SCt0U1NoZThlQ2JzVFhYYldQZFFTZUlrRXhD?=
 =?utf-8?B?VzlFWG91c3RHRU1HZHpNNHkwbyt4QXo3TnMvZFh2SnZqM1BFeHFNMU04WWFB?=
 =?utf-8?B?UXN1UXFIUmVSeURBQVcwWHc3dEMzM1FTbkp3cG90OWxPU3AvanJNRzNqVFl0?=
 =?utf-8?B?TmFyaDM0VHBuSEJtUGNjOGlycjJaSjZwOEdrVGZjQVBmZXRUYU5vc0FrVENB?=
 =?utf-8?B?aTFzZU01NnE1REpiNlBPaXdBdXRLU1lxWGtmUW83R2UxK2xUbUo5S0swQW5T?=
 =?utf-8?B?VTRPN3hUdkpIODZBQ2dZTXlnU2N6eUlJZnRQcTZCL1I2MDU1UkNZUGJuaEdL?=
 =?utf-8?B?VzZxY2o0ekZwM0pKZDRYSGFjK1kxSWpSRUNaTXdCWTVhSkFOc0I5dGovMy83?=
 =?utf-8?B?SHpvdFJLekNsV1UwQTVCVWZ0V3FIREM2RFg3REhjRFJjaFRSaXFSRDNOT2tS?=
 =?utf-8?B?Tm0ycEdSUVBYdUNOY2pKQ0hXRm1PdzBDbkpxQnFob3Fkb3pVMUdwTnRmTjJK?=
 =?utf-8?B?b0xaZXJQQVpuOTNyM2tmbWVvL0dWK0tsUEhBbVlSR0MxUXlTQTk5NDRkQTNQ?=
 =?utf-8?B?czVNSStxTXJ5VldydHYzdGlnanZUUG96U1JYQXIzc3Z4WCtNdnVhakY0RnZJ?=
 =?utf-8?B?NFJSbm5jY2VpTE5WSUJKa0FtSUcySWY0TUs0WkNjS0JtYXBFTzI5SG9LQVlT?=
 =?utf-8?B?OEhjS1FMekE0Rzk0RnpENjBBeEVWRE16ckFJSHgyT1I5VFowU3BjTFlzVmYv?=
 =?utf-8?B?aFFsTG9KNnkzb3ppc1BlRWtZSHdGY08zT3JKNGkwME5HSmhtUEgzOTZwT2N1?=
 =?utf-8?B?WEg0cTg0SUdpNlVvK1duKzgvc281SkNjTGJWVHlOOGVUbUdUYmdHNnp6VG5E?=
 =?utf-8?B?dHpOcUdlTk9jMTJSRXlBcklvSkhIUkxvRWxvcXV4Y3hzU3VPNUJ5VlRwbEND?=
 =?utf-8?B?akFlVkt3TDNjaTU2UTlwRSs1ZGd6aVdaa3BWQjRITlZENUdqeEE1ZnlwV2xt?=
 =?utf-8?B?K3dtdmpKbk1EajV0U3p4UnRYekhlMlNPVXYxK3RZQkhpOEdQSTc4OHBlb1Ex?=
 =?utf-8?B?NGFWTnczc2xITStBMDB5eEswcTNJS2ljRGdBVXR5SjU2L1piSjZqNzZDaHds?=
 =?utf-8?B?WnFBdGxENFZMSHdQT1J5eDlMbHdaajNQUWlsMWpCdHR6dklpdElKaCs3bHp3?=
 =?utf-8?B?NDhIVURXUVdhT3B2K0RWSFVZaUJiQlNqNjAzNW1tbDZsWjI0SWNaRE40R3gx?=
 =?utf-8?B?c3ZaRytwUGpBZWx2NUpQYUlxdWZlQXE3aEZsTFpidWtLQUJGeFBvQ0RFQ0Vp?=
 =?utf-8?B?WjZ0V1lweGxGaXNEOVRobjNVNmE1VDZXS0xPWlZzTkloUFdJeGp5UWlyY2E5?=
 =?utf-8?Q?bFzYPPUTtHd4mdXH44iHcC4Y/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75D017B4BEE64F469FA1A7A25BE57BAE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b38f99d-f562-46b3-81ee-08ddb511c43d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 00:30:06.7836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3hDl3Z/Z0gxctlZKiN25isOQtVsbbtvMWjg0XNNckdSoerWcWrRmxVa+qvkLWrbI+PmAnn50eE7rM0cllWl+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7253
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDE4OjQyICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gVGh1LCAyMDI1LTA2LTI2IGF0IDEwOjU5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3
cm90ZToNCj4gPiBTaW5jZSB0aGUgcmFjZSBpcyByZWxhdGVkIHRvIHN0b3BfdGhpc19jcHUoKSBp
dCBkb2Vzbid0IGFmZmVjdCBpdC4gQnV0IGl0IGRvZXMNCj4gPiBtZWFuIHRoYXQgdGhlIGJyaW5n
IHVwIENQVSBtYXkgbm90IGZsdXNoIHRoZSBjYWNoZSBpZiB0YWtlcyBhIGtkdW1wIGtleGVjIGJl
Zm9yZQ0KPiA+IHRoZSBwZXItY3B1IHZhciBpcyBzZXQ/IE9mIGNvdXJzZSB0aGUgZXhpc3Rpbmcg
bG9naWMgZG9lc24ndCB0cmlnZ2VyIHVudGlsDQo+ID4gY3B1aW5mb194ODYgaXMgcG9wdWxhdGVk
LiBXaGF0IGlzIHRoZSBjb25zZXF1ZW5jZT8NCj4gDQo+IE9oLCBkb2ghIFRoaXMgc3R1ZmYgYWxs
IGhhcHBlbnMgYmVmb3JlIGtkdW1wIGNvdWxkIGxvYWQuIFJpZ2h0Pw0KDQpJJ2xsIHJlcGxhY2Ug
a2R1bXAgd2l0aCBub3JtYWwga2V4ZWMgaW4gdGhlIGFib3ZlIGNvbnRleHQsIHNpbmNlIGtkdW1w
IGNhc2UNCihjcmFzaF9rZXhlYygpKSB1c2VzIGEgZGlmZmVyZW50IHBhdGggZnJvbSBub3JtYWwg
a2V4ZWMgd2hlbiBzdG9wcGluZyByZW1vdGUNCkNQVXMuICBBbmQgdGhlcmUncyBubyBXQklOVkQg
aW52b2x2ZWQgaW4gdGhlIGNhcnNoIGR1bXAgY29kZSBwYXRoIGZvciBTTUUuDQoNClRoZSByZWFz
b24gSSBndWVzcyBpcyByZWFkaW5nIGVuY3J5cHRlZCBtZW1vcnkgZnJvbSAvcHJvYy92bWNvcmUg
aXMNCm1lYW5pbmdsZXNzIGFueXdheSB0aGVyZWZvcmUgZXZlbiBtZW1vcnkgY29ycnVwdGlvbiBj
YW4gaGFwcGVuIGl0IGlzIGZpbmUuDQoNCk5vdyBmb3Igbm9ybWFsIGtleGVjOg0KDQpGb3IgU01F
IHRoaXMgYm9vbGVhbiBpcyBuZXZlciBjbGVhcmVkIG9uY2Ugc2V0IHdoZW4gdGhlIENQVSBpcyBi
cm91Z2h0IHVwDQpmb3IgdGhlIGZpcnN0IHRpbWUuICBTbyBpbiBwcmFjdGljZSB5ZXMgd2hlbiB0
aGUga2V4ZWMgaXMgcGVyZm9ybWVkIHRoZQ0KYm9vbGVhbiBpcyBhbHJlYWR5IHNldCBmb3IgYWxs
IENQVXMuDQoNCkJ1dCwgeW91IGFyZSByaWdodCB0aGVyZSdzIGEgY2FzZSB0aGF0ICdtYXhjcHVz
JyBrZXJuZWwgY29tbWFuZGxpbmUgaXMgdXNlZA0Kd2hpY2ggcmVzdWx0cyBpbiBvbmx5IHBhcnQg
b2YgQ1BVcyBhcmUgYnJvdWdodCB1cCBkdXJpbmcgYm9vdCwgYW5kIHRoZSB1c2VyDQpjYW4gbWFu
dWFsbHkgb25saW5lIHRoZSByZXN0IENQVXMgYXQgcnVudGltZS4NCg0KKFNpZGU6IHRoaXMgJ21h
eGNwdXMnIHNob3VsZCBub3QgYmUgdXNlZCBmb3IgbW9kZXJuIG1hY2hpbmUsIHNlZSB0aGUgZW5k
KS4NCg0KSW4gdGhpcyBjYXNlLCBJSVVDLCBfdGhlb3JldGljYWxseV8sIHRoZSBuYXRpdmVfc3Rv
cF9vdGhlcl9jcHVzKCkgY291bGQgcmFjZQ0Kd2l0aCBDUFUgb25saW5pbmcsIGJlY2F1c2UgSSBk
aWRuJ3Qgc2VlIENQVSBob3RwbHVnIGlzIGV4cGxpY2l0bHkgZGlzYWJsZWQNCmJlZm9yZSB0aGF0
Lg0KDQpCdXQsIHRoZSBuYXRpdmVfc3RvcF9vdGhlcl9jcHVzKCkgb25seSBzZW5kcyBJUElzIHRv
IHRoZSBDUFVzIHdoaWNoIGlzDQphbHJlYWR5IHNldCBpbiBjcHVfb25saW5lX21hc2ssIGFuZCB3
aGVuIG9uZSBDUFUgaXMgYWxyZWFkeSBpbg0KY3B1X29ubGluZV9tYXNrLCB0aGUgY29kZSB0byBz
ZXQgdGhlIGJvb2xlYW4gaGFzIGFscmVhZHkgYmVlbiBkb25lLCBzbyB0aGUNCldCSU5WRCB3aWxs
IGJlIGRvbmUgZm9yIHRoYXQuDQoNClRoZSBvbmx5IHBvc3NpYmxlIGlzc3VlIHRoYXQgSSBjb3Vs
ZCBmaW5kIGlzIG9uZSBDUFUgYmVjb21lcyBvbmxpbmUgYWZ0ZXINCmNwdXNfc3RvcF9tYXNrIGlz
IGFscmVhZHkgcG9wdWxhdGVkOg0KDQoJQ1BVIDAJCQkJCQlDUFUgMQ0KDQoJCQkJCQkJc3RhcnRf
c2Vjb25kYXJ5KCkNCg0KCWNwdW1hc2tfY29weSgmY3B1c19zdG9wX21hc2ssIGNwdV9vbmxpbmVf
bWFzayk7DQoJY3B1bWFza19jbGVhcl9jcHUodGhpc19jcHUsICZjcHVzX3N0b3BfbWFzayk7CQkN
CgkJCQkJCQkuLi4NCgkJCQkJCQlhcF9zdGFydGluZygpOw0KCQkJCQkJCS4uLg0KCQkJCQkJCXNl
dF9jcHVfb25saW5lKCk7DQoJCQkJCQkJLi4uDQoNCglpZiAoIWNwdW1hc2tfZW1wdHkoJmNwdXNf
c3RvcF9tYXNrKSkgeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAg
ICAgICAgICAgIGFwaWNfc2VuZF9JUElfYWxsYnV0c2VsZihSRUJPT1RfVkVDVE9SKTsNCgkJLi4u
DQoNCkJ1dCBhZ2FpbiB0aGlzIGlzc3VlIChhc3N1bWluZyBpdCBleGlzdHMpIGlzIGFuIGV4aXN0
aW5nIGlzc3VlIHdoaWNoIGlzIG5vdA0KcmVsYXRlZCB0byB0aGlzIHBhdGNoLg0KDQpBbmQgSSBh
bSBub3QgMTAwJSBzdXJlIHdoZXRoZXIgdGhpcyBpc3N1ZSBleGlzdHMsIHNpbmNlIGFsbG93aW5n
IENQVSBob3RwbHVnDQpkdXJpbmcga2V4ZWMgZG9lc24ndCBzZWVtIHJlYXNvbmFibGUgdG8gbWUg
YXQgbGVhc3Qgb24geDg2LCBkZXNwaXRlIGl0IGlzDQppbmRlZWQgZW5hYmxlZCBrZXJuZWxfa2V4
ZWMoKSBjb21tb24gY29kZToNCg0KICAgICAgICAvKg0KICAgICAgICAgKiBtaWdyYXRlX3RvX3Jl
Ym9vdF9jcHUoKSBkaXNhYmxlcyBDUFUgaG90cGx1ZyBhc3N1bWluZyB0aGF0DQogICAgICAgICAq
IG5vIGZ1cnRoZXIgY29kZSBuZWVkcyB0byB1c2UgQ1BVIGhvdHBsdWcgKHdoaWNoIGlzIHRydWUg
aW4NCiAgICAgICAgICogdGhlIHJlYm9vdCBjYXNlKS4gSG93ZXZlciwgdGhlIGtleGVjIHBhdGgg
ZGVwZW5kcyBvbiB1c2luZw0KICAgICAgICAgKiBDUFUgaG90cGx1ZyBhZ2Fpbjsgc28gcmUtZW5h
YmxlIGl0IGhlcmUuDQogICAgICAgICAqLw0KICAgICAgICAgY3B1X2hvdHBsdWdfZW5hYmxlKCk7
DQogICAgICAgICBwcl9ub3RpY2UoIlN0YXJ0aW5nIG5ldyBrZXJuZWxcbiIpOw0KICAgICAgICAg
bWFjaGluZV9zaHV0ZG93bigpOw0KDQpJIHRyaWVkIHRvIGdpdCBibGFtZSB0byBmaW5kIGNsdWUg
YnV0IGZhaWxlZCBzaW5jZSB0aGUgaGlzdG9yeSBpcyBsb3N0DQpkdXJpbmcgZmlsZSBtb3ZlL3Jl
bmFtaW5nIGV0Yy4gIEkgc3VzcGVjdCBpdCBpcyBmb3Igb3RoZXIgQVJDSHMuDQoNCkF0IGxhc3Qs
IEkgYmVsaWV2ZSAnbWF4Y3B1cycgc2hvdWxkIG5vdCBiZSB1c2VkIGZvciBtb2Rlcm4gcGxhdGZv
cm1zIGFueXdheQ0KZHVlIHRvIGJlbG93Og0KDQpzdGF0aWMgaW5saW5lIGJvb2wgY3B1X2Jvb3Rh
YmxlKHVuc2lnbmVkIGludCBjcHUpDQp7DQoJLi4uDQoNCiAgICAgICAgLyoNCiAgICAgICAgICog
T24geDg2IGl0J3MgcmVxdWlyZWQgdG8gYm9vdCBhbGwgbG9naWNhbCBDUFVzIGF0IGxlYXN0IG9u
Y2Ugc28NCiAgICAgICAgICogdGhhdCB0aGUgaW5pdCBjb2RlIGNhbiBnZXQgYSBjaGFuY2UgdG8g
c2V0IENSNC5NQ0Ugb24gZWFjaA0KICAgICAgICAgKiBDUFUuIE90aGVyd2lzZSwgYSBicm9hZGNh
c3RlZCBNQ0Ugb2JzZXJ2aW5nIENSNC5NQ0U9MGIgb24gYW55DQogICAgICAgICAqIGNvcmUgd2ls
bCBzaHV0ZG93biB0aGUgbWFjaGluZS4NCiAgICAgICAgICovDQogICAgICAgIHJldHVybiAhY3B1
bWFza190ZXN0X2NwdShjcHUsICZjcHVzX2Jvb3RlZF9vbmNlX21hc2spOw0KfQ0KDQpTbyB1c2lu
ZyBib29sZWFuIGZvciBTTUUgcmVhbGx5IHNob3VsZG4ndCBoYXZlIGFueSBpc3N1ZS4NCg0KCQkJ
CQkJCQ0K

