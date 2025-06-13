Return-Path: <kvm+bounces-49355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 079C9AD8068
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 03:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D51301898FA1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 01:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4101DE4CA;
	Fri, 13 Jun 2025 01:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="caTIVmGx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C506C2F4317;
	Fri, 13 Jun 2025 01:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749778896; cv=fail; b=KDx+lFes0XLSk5mavXHYsZQ+nMDHZG3aTm8M1AB2Te4ADXEyi/U5JC3McxsJO3O6lh0mITLLqPRTKB4+6o+M4Fp/bpHNVkmGl2nUZQFIJagcgD3HqIXVn229xF22TxlraJXIwTYieTbAhyb6zH3cWuXA+fDRXZOLlaV6VhrTp74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749778896; c=relaxed/simple;
	bh=LfmOjdPrX71aIXXGUeVXoKt6BqAsfokAdyi6dwpycCQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Li32sYaAiv/0XJEj1Ldx8192s7PF7RvbOMmooG0I0HxFUPBOT+BiJl+iUPFJE0v4F71ru8BdZG9E3WUUp7l15XcZUFeJTmYJ/O5ZuZ5NdH/ATCBsB4nN45MkWKW4+UHSflbKFlRHbUgeJh69nPSRUSDvQvNPW6K7ZZxLX1+rMlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=caTIVmGx; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749778894; x=1781314894;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LfmOjdPrX71aIXXGUeVXoKt6BqAsfokAdyi6dwpycCQ=;
  b=caTIVmGxbpKwxooJaKDPRj8fHAhp9SxAlESWtvMv/uQpA3PWRgwnp/aC
   Ko20J7sS3TAIHGs2hbA9bOo9KJtrH9Ee0EUYGsAH5mtTM5bX+2lthP3br
   aDicAosbAEC86ANnxil0DVzipY3gMb+8dXABeXyJC182SAGyenwxb//XT
   hlC4g0vs3uIiqaQZjrCbBnbOZfgoRp7Dao0aLX0+sPKcxryriyvMbbchj
   vLAWb00mdEi/TCr2oWaMISWfhqcRT5FWT0HLmZECEZ9LLo8rcejIm1TBD
   j3Zm5e3YB+6U3ZLrqq2oYOtgPhtprAKkEpAbvjMogW/fsC6ips6ICA3TR
   A==;
X-CSE-ConnectionGUID: gQHkVw02ScGCqabs1zTSRg==
X-CSE-MsgGUID: SF8hsCGRSaeDx/rpYoQdIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52080142"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="52080142"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 18:41:34 -0700
X-CSE-ConnectionGUID: ColSopCuSrexnZ1kyUkM7g==
X-CSE-MsgGUID: N/D2T4WiQeyLSc8giXrn2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="148168112"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 18:41:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 18:41:33 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 18:41:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.48)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 18:41:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NdNXqHKBFr4VUDRpq6VYxbIWXZpmRpnOO7Jsc0kmecTSNFdHlwpKjVvKp4KvsowR2hrm4IEHAyccpM+2zoMhnjRgyCtq3IQ3q/+5eRpHae00IKyzA39uvxFLsro/lF5nMTzTbfpR6Ll9d6qb/By9Pu/ie5rUBSXrVrmZjZPDiftQYqB8jnbyAaQ2wPfn9ZfkpG7QKPYixVkbvatGiwDVXr1m++S1SgM3bMb10FQvBmHW1s2J+uJiABs9mdUGODjlfTFUMlYV8AKcfXcuX02df75ZW8Ud3MNTYyJVe2h53L/n34e3oiu+a8KTD50rQf8XsuKqvOt2arbZAxIs+exGOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfmOjdPrX71aIXXGUeVXoKt6BqAsfokAdyi6dwpycCQ=;
 b=hfqDn0+zCuWTg7+6wBMEutyNw/3WPxRD3b1adwEhtQjLAB+xQwiILRYWTes3GsIGkcfHRwvt7VRWO6PKAYiBi/i7Fnxef4pJYzCshx6C2sxJrzE9+iwQs0skJU+5sWpnwDNUOVi+L3/hMq2whkRPzUZ6ERVs3ZnWRRSwWo55GX5NhkfNxUi458NKKJkLLTfn9s/WSDaCFh1iQFS5KjOah8EndU3PmUcCPe2FZn75S6kOtr4fsp7B0CwC0v6ifGo95QfFG2c8g0D5FF5YYSZHaPceb22s+KCZCmP2r3aJJDWb8eJ8n4tnlUAZZdCAWGkhuvlxZli8Xl+4IeRwoxs2hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA4PR11MB9012.namprd11.prod.outlook.com (2603:10b6:208:56d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 01:41:10 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 01:41:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: Re: [PATCH v2 04/18] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
Thread-Topic: [PATCH v2 04/18] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
Thread-Index: AQHb2xjgdBz9JRDcZUyv9DbGRr27drP+z80AgAFz0YCAAA6kgA==
Date: Fri, 13 Jun 2025 01:41:10 +0000
Message-ID: <b73ef73a707faab870fa64f96af9e0c4de213043.camel@intel.com>
References: <20250611213557.294358-1-seanjc@google.com>
	 <20250611213557.294358-5-seanjc@google.com>
	 <44cb77805d1d05f7a28a50fc16e4d2d73aca88f3.camel@intel.com>
	 <aEt1aXPhivCJZbyE@google.com>
In-Reply-To: <aEt1aXPhivCJZbyE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA4PR11MB9012:EE_
x-ms-office365-filtering-correlation-id: 04114ca6-dc93-4ce8-c561-08ddaa1b600f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UXhlRkUxQ1U0TlZCVEpjV3U1MzBKZStzTVUyUlBpaStqS2VtNXpYRUQySmo3?=
 =?utf-8?B?WmhBTUFkTy93QjdIZElQTWFKNlppQjhTM2EzbE1zVTVhaFdDYUl2NXV1U2hm?=
 =?utf-8?B?ekNqRmJKRU9sWUM0K1cvcW1NV0JNQU5QbnRLekFXTnU0YTR5RW9TSUN6TVBp?=
 =?utf-8?B?eGJFTUdSNHVFZjNqT3pBSlFjV3VSS2J2SExaSWtvTUkyZVpwY0tCQUhEZDN5?=
 =?utf-8?B?dmFnYTRoeE1zWnNKNVpRWXYyeWNWYmhJQVMvT2lsZVNHQ3JCZ3VZSEJud0F1?=
 =?utf-8?B?dTBLdi9RSFdIS08zdE5hY3ZtSFBIRTVzTzR0NjVLZ241WlhyNG4vRmNKcnlo?=
 =?utf-8?B?RzlNSFV1YmVxeC84cHkyUHU4M09vWUQySG5DdHEyVHdhQWdFcUptUDJuRTMr?=
 =?utf-8?B?MEVqSk1uMnhVbm9yZ1RnRU5ncUM1eXZva1BmOHRnRXBwZDNFWHRmK3pjUUMv?=
 =?utf-8?B?SlRROTRVU01NYVFERFI2VjliYkx1aWVDWnZJUktLWFhtZ0JVSDFMSEJpMWhw?=
 =?utf-8?B?SlVVKzNkMFQwVTAxY0pKYkFGVW5LMkxHakxQcWlscVVJNElDLzk0RGpKV3dV?=
 =?utf-8?B?TEJxSGI1MG9HbTNEaUNXN3lhWnRLZzdRS0djblhvQisvb1BaY0lQVFRJMG03?=
 =?utf-8?B?K0FVcWd3UDZvTlJYNUFFOFI0M0tpUFNodDFlelFBMUliY2VCaGRzNGgyQisw?=
 =?utf-8?B?WWJHenhXMGlsamxyOHg4OXRubGtnSTY5WkQxS2xJc2sxLzZ1UWFIL21HbmRl?=
 =?utf-8?B?OFhvRXdoZjIrbVZGanRmR3BXZmFiU09nQ3pMODEwQ1ZjbEVSRmFlN2NBbk40?=
 =?utf-8?B?ZVM1cVQvZ2JucEY4L0gzajZrbDR1SVBQSE5CbEFMdG1KTUVBVWNHaVE0dG4r?=
 =?utf-8?B?dWNkbGdTMGYxem0wNzFUamZ0ekhsZE1XeFFPMTJVaWkxb2JxUkVIMWtwZjBL?=
 =?utf-8?B?UnVtSzFZOUNUTjhxVG5uSW5vZ1pIQS8ycmxnRVBBMHpWR0xVY3A0NURIcEQ3?=
 =?utf-8?B?TC9CK25MNHY3U3ZFVDNRVkRVU3FOUHdrZ3JjRDBwaGdMNDAxdDljMVVjeUJN?=
 =?utf-8?B?Z1FpMlVmVGlIRk5veWhnWmN4T2pRU09YRlFFRW9xZTNGVGppWENEYUZPZU1x?=
 =?utf-8?B?dElQdGE3ZmROa2hjdzNqQi9wQS9md0x1c0E0Q3I1M0ZWaVp1T0Z0Ry80TSsz?=
 =?utf-8?B?eVFhTGpqdmpFYXQxZ3NmSThvWGVpUDRlQjl0eUs1QmJCWEtrN21kOGg3UHZm?=
 =?utf-8?B?YVVzZ1NwM0IxVHpSSklPVVl4QlF2S2ZIYk5wb0xVSFRxajVZNG5HNHhPQmdX?=
 =?utf-8?B?Wk5XY2dTWVpjS2N2aUhuejZTem1DdXVZOXNzeUE4OEJFNUZUMktUaUtXR3E2?=
 =?utf-8?B?MEZiSC95M1hvRFVmZ2Q4NUNVSnpwMmV6TlZZQ0hwSkE1dGx0bXJ1UEZmb0xV?=
 =?utf-8?B?OEx4YVB5Qk56TzM4WHNvb2I2TmNPbXlQR0RKRTg1NVg4NUwvNlFWNkJiZFRQ?=
 =?utf-8?B?OXIwMVkxeHNXZE83SDR2aDVraUhGRG43RkVyQUFrNDN3UzFjajYzcmcrU3hT?=
 =?utf-8?B?dUFpbmRSMWpiRTNFRUhZQ2l4S0pvTDhLS08vNFFwbEY5UnVhVlp5a3BxNU1C?=
 =?utf-8?B?dW5odWZkTVJES3Y0R2ZjdDhScHFRYVhzT0o3eDNWaFh3SjhnMTFtWFA2Z21K?=
 =?utf-8?B?ZVlnT01nZG5tRVJXY1p0ZStrZWxnMC9ZcGN6NlZscUcvOFpzU2c2aVVRbnlL?=
 =?utf-8?B?aGN5WXBXOXNERUIxVmxrZG51Q3NFdW0rUS9PNGphZ3JnaVAwclhXNzZ3NGti?=
 =?utf-8?B?MjZzN1h2clF2a2dlR3kxRWZ3L0oraHZPK0xLRVlTSjcyUDBFNzhlVDZUL3VP?=
 =?utf-8?B?dDlNZHQyS3F1c1BUN1FaRnhBZ3BLSXVPMTcxSDNpcXloVVVLYStKbEtLSHNG?=
 =?utf-8?B?NDhCWnV3SjlOMkRmNCtSL21MRTlyeGhPdDJvSjZpWFdzSHY3RlhZRHNmTERV?=
 =?utf-8?Q?n/VjRs1x5y98nWqS62eZ80gjOI8VXY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amVQRXJvNzlBTDhPUjNUNDZZcmRMWjhaM1liN0J1c1FHS3NQZVk0bVUxZ2xh?=
 =?utf-8?B?N3hTdm80dnoycHVsSTdiaitLQmNUOXkxaGhBSTAwQ2FQeDllYStEZGVQa3pk?=
 =?utf-8?B?V1AwMmN3RklsZXo0L3hqWEhVZGlmeWRNV3lDL0UrbWtGWTBkNVJHeHV5WHdL?=
 =?utf-8?B?OXpFRDFOaWViNzV6MXZMTFZlK1RCZXIrZWdxb25tRXJ3aU9oT3EyakpsSS80?=
 =?utf-8?B?d1lnWE9EeWtBK2RMdzdTODNiVUZleHlBc2EzU01pTlUwM3BUTjdVRnNucHdw?=
 =?utf-8?B?Q0VCSUhUWlNLV2s4SDQwVmJQbE5idEVpbDVGbXFvL0hXSTU1S0hsdnA0cExj?=
 =?utf-8?B?TXQrSlRQeWVUakZURkFQZXdxZ0lmOFRER2Z0VjNsczE0M1h2ZkV5bC9kMGRO?=
 =?utf-8?B?enVlSm9FVDZkWUM0b3QyUFVHR2VrVjBHT1NQcW5EdmtJMVZuZVBQcWFtbS9D?=
 =?utf-8?B?dW9tZDFDcUQwZFYxRSttSUh3K0QrU1NDK2d2eEJiZWgzVnF3cHpwREhjYXNX?=
 =?utf-8?B?cUMxdExRZnBodFJrdjh0TmFWNlFQd1hBT0IrdmxBNGJDcnlZL3F3RitXcWxj?=
 =?utf-8?B?bG9xdlNlZjN5TURvYURXcDE0V1h5MFR1bGEyZHJkNWNtdlBvamhGWlM5am5Z?=
 =?utf-8?B?MllHRnBrUUprbFFjdTVIN3NnVGFURlJWOXJkSFo5ZWhHbS9tenhydDdvT3Nv?=
 =?utf-8?B?K3lDbmRuTkwzUURFcWtrWWxZUEdxVGV4RzJsbjVCUlROdG9xdmM3UnNrQmQz?=
 =?utf-8?B?OGo0bzd3K3J6b3ZJdFhDVE5GNWxaS2xyc2ZRcU9GYzA0V2JnR0JIRUZSdDFk?=
 =?utf-8?B?Ump3WnRhU1VWUVRFYnA2ZjRpMkpBZ2hTSEJFMlNSaWUwVG4wREJjeDMxSWg1?=
 =?utf-8?B?d3hOZ2tSWmhwNUwzR3llR1dNcHZpMHNhcEZ1QkUzVFJMRlVGVWJ1OTRKUzV3?=
 =?utf-8?B?TERjU2JMbUVKQU5DQ2dvOUZtdDRIcitjbTRQdnU0SGd5VC80U2trdzM1VXBW?=
 =?utf-8?B?U1VVRHB3NmRQQllkc1ZpeXMzUFl1ekZEMnZBanZTTi81QjZFamc3Ujd3TG5q?=
 =?utf-8?B?WUtPd28xM1RVb1V1VW1kTkM5ZHVzSFg3aVBSVjlNcjVkM1lwUmZZa1BTa25a?=
 =?utf-8?B?VXNjZFpDWElQZVFuWFFZd1Zqbk0xUVErMlNtZDRlNVRkMTFpNjJISkxzS01s?=
 =?utf-8?B?ZlRCdHVzTTZLL2EyMitWNTd2WmRWZjJ0OHpqQ0lGS3Y4UTdnOUc3RkpLOXJs?=
 =?utf-8?B?VHYxMnlmWE1lL1R2VlJ1TkMvS0FickpvVzZZQkx2a2ZEVzNzaVFrSDNJUHJp?=
 =?utf-8?B?VWNRT3YrcjlXa0Vvc2hkZXZpWTVFSXRUWGFVMWdZM0FoRHpvb2xXUnNGaEVR?=
 =?utf-8?B?YUUvaHphOWJ0MEhIRWFWK01JcmY3VFF2NEJQYXAxZ2JSZ0h1V2U5eWVMbXpq?=
 =?utf-8?B?Y3lTeHZBM1Zvczd3SFMvc1NRTGFwNzhLSnNZOFZQQ25FTWxlcmgwUlhmemw2?=
 =?utf-8?B?bDdyNGdqOHp3Qi9VNGVKSVNaWFJqVWJqNnhvajg2NlFzQTQ4WGtpMjFUWjRa?=
 =?utf-8?B?cWhWWHh5eVVMK2RUS3ZPN045VFExQ3VOc3FNeEdXNFkrSnB0OG5vMDhqM1V2?=
 =?utf-8?B?TDRJaXpETFNjVUdicHRLTXcyaG1sYTJRL29MUjZieEw2MmNpeWxyKzJjNFFB?=
 =?utf-8?B?aytzZjZWdmZjQktFQ04vcTBoVUhwTUV4QWdXR3duTjllaDhyb3Mvd3pPUFRp?=
 =?utf-8?B?aDJGa2lSbEwwZG9yTVZ1Ri9qYk40S1prOXFHNVVnSnFPU0EwK1R4eG91Q2Q3?=
 =?utf-8?B?d0UvKzdWbjNWQWgvakRCalErUExxQ3BnU1ZveWtRbUhQN042eGpha2tHcUZx?=
 =?utf-8?B?b1hkVkN1YUZYTDlOYjJkd1BqNllEb3IvaHBSKzBYWmxBa3cwVUhLSzl1LzFq?=
 =?utf-8?B?NGZCSXFzcUhnNnl1ZEVjTks4ZWtIVmlrb1R3Wmk1QkZFT1JUSGxGQTF1YmhZ?=
 =?utf-8?B?aGxNKzhpM2xCdGlPRk1veTFqTExKWkxJZlFsbWZVUWZPVWZRN29KS1pKaW83?=
 =?utf-8?B?ejRENGlJYmVDTmhQNXZvUUFxYjF0NGVCbm43dWI4ajVFM2J2L2t1Wlg1MFI1?=
 =?utf-8?B?YTRlM1ZLMUVvTDd1SUNsN0pVdEdjY1dZbEsvV3JQRGlDdXBGVnp5cUo4Uk5H?=
 =?utf-8?B?SlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8155D43705C35D408199A47056648DFC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04114ca6-dc93-4ce8-c561-08ddaa1b600f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 01:41:10.8317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vykHUepJunWxI0w5PrMSd5sqNjUhUbX71+DNU3OSfpRIG2oIQ4Nq5A5T9NG21KyXEWzgedKp9UmrF+FAmQRDyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9012
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTEyIGF0IDE3OjQ4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEp1biAxMiwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNS0wNi0xMSBhdCAxNDozNSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IERyb3AgdGhlIHN1cGVyZmx1b3VzIGt2bV9odl9zZXRfc2ludCgpIGFuZCBpbnN0ZWFk
IHdpcmUgdXAgLT5zZXQoKSBkaXJlY3RseQ0KPiA+ID4gdG8gaXRzIGZpbmFsIGRlc3RpbmF0aW9u
LCBrdm1faHZfc3luaWNfc2V0X2lycSgpLiAgS2VlcCBodl9zeW5pY19zZXRfaXJxKCkNCj4gPiA+
IGluc3RlYWQgb2Yga3ZtX2h2X3NldF9zaW50KCkgdG8gcHJvdmlkZSBzb21lIGFtb3VudCBvZiBj
b25zaXN0ZW5jeSBpbiB0aGUNCj4gPiA+IC0+c2V0KCkgaGVscGVycywgZS5nLiB0byBtYXRjaCBr
dm1fcGljX3NldF9pcnEoKSBhbmQga3ZtX2lvYXBpY19zZXRfaXJxKCkuDQo+ID4gPiANCj4gPiA+
IGt2bV9zZXRfbXNpKCkgaXMgYXJndWFibHkgdGhlIG9kZGJhbGwsIGUuZy4ga3ZtX3NldF9tc2lf
aXJxKCkgc2hvdWxkIGJlDQo+ID4gPiBzb21ldGhpbmcgbGlrZSBrdm1fbXNpX3RvX2xhcGljX2ly
cSgpIHNvIHRoYXQga3ZtX3NldF9tc2koKSBjYW4gaW5zdGVhZCBiZQ0KPiA+ID4ga3ZtX3NldF9t
c2lfaXJxKCksIGJ1dCB0aGF0J3MgYSBmdXR1cmUgcHJvYmxlbSB0byBzb2x2ZS4NCj4gPiANCj4g
PiBBZ3JlZWQgb24ga3ZtX21zaV90b19sYXBpY19pcnEoKSwgYnV0IGlzbid0IGt2bV9tc2lfc2V0
X2lycSgpIGEgbWF0dGVyIG1hdGNoDQo+ID4gdG8ga3ZtX3twaWMvaW9hcGljL2h2X3N5bmljfV9z
ZXRfaXJxKCk/ICA6LSkNCj4gDQo+IFllcywgdGhlIHByb2JsZW0gaXMgdGhhdCBrdm1fc2V0X21z
aSgpIGlzIHVzZWQgYnkgY29tbW9uIGNvZGUsIGkuZS4gY291bGQgYWN0dWFsbHkNCj4gYmUga3Zt
X2FyY2hfc2V0X21zaV9pcnEoKS4gIEknbSBub3QgZW50aXJlbHkgc3VyZSBjaHVybmluZyBfdGhh
dF8gbXVjaCBjb2RlIGlzDQo+IHdvcnRoIHRoZSBtYXJnaW5hbCBpbXByb3ZlbWVudCBpbiByZWFk
YWJpbGl0eS4NCg0KQWggZGlkbid0IGtub3cgdGhhdCwgdGhlbiBkb24ndCBib3RoZXIgSSBndWVz
cyA6LSkNCg==

