Return-Path: <kvm+bounces-17486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E8C8C6F5D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:59:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 666391F22012
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468B415B0F9;
	Wed, 15 May 2024 23:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PMgo8h9e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF61157A40;
	Wed, 15 May 2024 23:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715817572; cv=fail; b=XX5xrQhGuPVNub+bZBCv4W1IJpkZmDPYcYla8d6gBAhCdI6rR3xBm6AxZ1sWFsqVbJ8O+K800T0PX9+2MxqJxkKymxaYKFzY7JdeAlwAreDd35LX4bMK1YVYhaha8cyNHytVrwWOWukAjbBMvfKSIzO9Lumhr5e+j4EE2AgEpks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715817572; c=relaxed/simple;
	bh=TLI1HOR6g6ioozo1X0v9PCEzKm11BL1eEKxZkJiFE/0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Co64QscBcvYASTPUQLw5swRal2qh95VM1ZiJJAfvUtL9UL5KcwgnLPtiupFWLrvuHpyXhLX0vDOZztTywMxgt/WQFVi6cgY1ey9J2SYqyYBUKljTkfkVFn2mElKrEQdIEIhCNigYjXr9DsY974vdur84vPjEnQz9Y7+njzWuIF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PMgo8h9e; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715817571; x=1747353571;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TLI1HOR6g6ioozo1X0v9PCEzKm11BL1eEKxZkJiFE/0=;
  b=PMgo8h9eKI3fXL/5z+kS97lgtiSMrnQQ+EKkSuTgYvp2MdV6QpKpGM9d
   JVviFI5eo3rV/H062bROcL6MHnvjtNB5Cww2ph6i9jT1DnrWTeD+dV09n
   jipnxhbXfwBxCxxn3PPpitTtGyK8ON5HUDFsCsrN+3Sec+R1jrSWHLdPq
   QEqppBzqvI7mJRrRDmew7sHH2ansBwFH4UEaKBUVXdK9/HS1YE7D13rYF
   7Z8yDhO2pE+9IOOql+oF8MMVPE0Wq/2nfh7OPnYK0L5gHCetOzEfWpudM
   gib32s2JQt95EYlZEW7UUzzk1GH8SY1iZ1+kISyKHCiM7R+Xs3STkQne0
   A==;
X-CSE-ConnectionGUID: /B2q6/laSruOLGyqRJkEcA==
X-CSE-MsgGUID: qvOw93VMREil4TeTaHd03w==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12062173"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="12062173"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:59:30 -0700
X-CSE-ConnectionGUID: jQx2PVMzT7CsZCLgOZpt3A==
X-CSE-MsgGUID: txeM3c35SsGxP7R5mT0DKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="36017954"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:59:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:59:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 16:59:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:59:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYMKmviC6+1Yk/PwfQjkric9gK9+RpgPj+oyt6YqWVzAvEHUOAjbWiGqkhT65M2OxT9Lnv0CaJuf7ROpASNf/82B7bLEYlwmnQP8mp7i7521hDBgFb4lNbvXf/ylN1Zx2M6z67PcGMlLbcdErd5U+vaX7l5tC0QkKNPQxL82HpoJ7Hy78Tw0AV64HUQNfL/y4BupWjFSeKOcswhFDt9Lj9rOKtpfyfNqT8yYi56I+uiSDChQ2xzL9pWqtBG3r6g1JFc+eWjMBzz+XMraw7JtswdBmnuOHp0YeTELhc/4FskqxJ6ZlEhoJluCyaULQ6sphEHYDyphimZk7+IhPuZ4lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLI1HOR6g6ioozo1X0v9PCEzKm11BL1eEKxZkJiFE/0=;
 b=LIJdlE8IS7xG/cKz5g8yFyvyMhzo7vk4Dsk2ffq73J2YbzArZyG+TRcKCbsKiACM1mqmEWKSgoyCBIUeP51cz0YluDLAZ27E037lRHGoCh0Y4JuA7P7kEeREc0guBNKeqqycScXafaSQrfCS8Jlyvetasm+9hwVnd0bUxKKZ4FVsveLvHoF+/wzm5lxr97CidUj74Pwqw+tMcBsE0ToEI2txoBeOWwirjxrGcdpX40+xr8S2DbwmXn5DsOjRAuBtNJPF/nlnkMKU8hJepxmmJ8TG6VY5cc1yrsbJz4ZbgP/q8no7udvmSB4SavpMKxEY2WuqXIHxQI8+9WYK4TxzJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7515.namprd11.prod.outlook.com (2603:10b6:510:278::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Wed, 15 May
 2024 23:59:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 23:59:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "sagis@google.com" <sagis@google.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Topic: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Index: AQHapmNYuPeG3HmbBEy5jvfA/OKCRLGY42KAgAANMgCAAAKfgIAAAeaAgAAByoCAAAQqgA==
Date: Wed, 15 May 2024 23:59:26 +0000
Message-ID: <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
	 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
	 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
	 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
	 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
	 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
In-Reply-To: <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7515:EE_
x-ms-office365-filtering-correlation-id: a3318822-daca-472c-116f-08dc753b0d3d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?SW1JNG91NFdnbE9xUzdna3hqZGNOQ1FnM2NUcXZxWXl4VnVyKzhqajRJUzNq?=
 =?utf-8?B?K1A4azNTSi9iMVpWUiszMHBTZE1PZzRIOEgyby9YK2t3ZHpYWXFqZWZTMzNj?=
 =?utf-8?B?T1NwRHFXcW9ITS9XK2NVbnJnZkFpWU00UVl6U1Q0UThNR2FhYlExcGc3d1lp?=
 =?utf-8?B?d3JOK0w0ZExOTmpJSStFa3hZbnUrNTlCMUdvdFROQWRyS29BeWozTHlDUGdE?=
 =?utf-8?B?dHJUdjFvTjkvRnFGKzhwNTdCR3ZPajAzYkR6NTFwaW8zRVpkN05Vb0xJeDRo?=
 =?utf-8?B?cGVJZWc4WEdaaG9PKzVJL1FLRFhKTlBZT2o2N2hYbXdFZTRicXlzWGFTNUIr?=
 =?utf-8?B?MUx6QU1LLzk1Y3dheDIvMi9MSkNFMXVOdHlMVitkU0Vsc0FKbTkyeGFnMTRT?=
 =?utf-8?B?UGZqaHRLSnNjTG1tOTBBUVd5T3lyYk1oKzZ5cW1sdlplK2JIdjJ6bnVDODhz?=
 =?utf-8?B?SXhPTWNtZlVTYVZDeXNEbFlWRktSUVVSeFRPRUxteEhFTVhyNGF4U2N3OXlW?=
 =?utf-8?B?dTRTbFhYcWVZb3M4OEp2RVFVV3lNcTMyMUIzMzRoT0UwQXE5NnpuVkdZaCs1?=
 =?utf-8?B?Q252cFVLaHlwNmJsaGdaNWF4bTdSczNNaGRWb1NnZkt1VGtNUjYxSUNERXBi?=
 =?utf-8?B?U0VTMmpjdlZQSHorbnEvcHJqdDdaWVhJOGRJZVc2TGVzWWtqTWRkeFdOS1Iw?=
 =?utf-8?B?QWhmNzFiOXpKb0V2WEV4cVV4Z250LzZ2UUNmbWc1RHI2bStnN2xJNDNYT29p?=
 =?utf-8?B?STFZMldQeHRtenF3NDFjNm1CWi8wdVVmbUpVTTFYR1BLKzNMWElveUptMnFV?=
 =?utf-8?B?Zy84d3hQRlgrd2RTUHV4VytXbVoweEY1VzV6MTFORCsyZUR5dDE3dUJTN3FD?=
 =?utf-8?B?MG9UUkplSldQcGlqb3F3ejVPUHZXNE1DRmNTS0hBMWZkU0tST1U4eU5vSFRB?=
 =?utf-8?B?ZG1hTkdqa0g1V0RMSkZjVzYwTlVmUHp5N0dGM0hIeXh2VU5Famw0ZG5qRTdq?=
 =?utf-8?B?ODc4UHRVRm1OdXFQTmlzcVpoR0o3a2RzTEZFWnFHY2IwN1FISGovbklSOFR0?=
 =?utf-8?B?RFJxWXVEdnZkcnhWMGExK1N5MGIvZlUxTk1XMk1DcFgrV3JFZldCS0dGVitF?=
 =?utf-8?B?K2pJWGlhWjFXL1dMVHg0YnpHT2l5cTliRzN0bEVwMml0SU5lZ0s4SU9EV0I0?=
 =?utf-8?B?cW9nMHEveHVQcFJmTWtEcGZzeDlOcm9HU2xFV2VZQjlidTg4dGRXYmxoZWpq?=
 =?utf-8?B?STY4c2pjOW9LY3NYKzlIdzVzaUZzUzh3TWdQMy9tYkRCQSthTE1BTW1wck9G?=
 =?utf-8?B?bENxMkliOERzakYzUTdMQzNaZ3AxVmRSNWxCdnplbERvdExpQjIzV0xEL0Vw?=
 =?utf-8?B?OTcwTjlOYldzOTA4b0I4V2dObUFhOVdENXM0ZTZEU2hUb0dVUktENHF4bEdC?=
 =?utf-8?B?Z0FCajVSdmhMb08vMldDWno5clhONHJiSWRkUHRtdDRzRkJUaGlySzJkRTFQ?=
 =?utf-8?B?N1Q4UXVkRWJ3NGt3VWZsYlEzcW1ETGlOMkcvQnMwVkVjcXVGSWNEVCtQT1VN?=
 =?utf-8?B?Y2dScTgyM2lDWVEyam1VM3l2YW51a3IvUjZKeUNhUDZiQWRUazdjblhPSWtq?=
 =?utf-8?B?Snh0Um8zZ0ZBWGlCVFhQTFZOMUZBS0s2dnJOT1p4YStYeHBhcHJRRmJ1bHlI?=
 =?utf-8?B?VzlHU3ZkcWxkVmxNdXlFWVFldU91MVJsWVBrSUZ4VGU1Ri9mbTdDUFVYNjJs?=
 =?utf-8?B?bDdxQ1JBVmpkcTc3bjVoZkg3UVVrSmlrN3p2MGVNd3ZXbWFhemdRTHRlaHNz?=
 =?utf-8?B?UjMyWWFjWlhUVUROa205Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjNDbDZyV2NpRHc2bmVOSnhkL0VFRTh3dnpsTTBTLzJJWEZCUS9hcVU0a0pF?=
 =?utf-8?B?T2JibmErQnhSTnpGU1hUNEFnNnh6ZkNkd285TGRmcUNPWFFBZEpadjlvVEtt?=
 =?utf-8?B?WTN5c0YrSHpGKzJHMTllaGxYWXZucVQ1d0pXUEhNOFA3N1FCOVc2a1A3aWJ2?=
 =?utf-8?B?Nnh6d0Z0Sm05MzQzeUdkVXQvTWp3cko1eHcxSlUyR3JGbTE1Z1F2ZnJuZzFR?=
 =?utf-8?B?aEVrQ0tIeS84OVVLRGxtVlVYeFNITS9VbWJPMFRRc25jVzhNZzBhOHdYeW0r?=
 =?utf-8?B?NHUvU0p1NHNlVkVBRWgvSGhqS2dGTlNIUDgwcVVEMmVpK05NQVl5MUxXcGtL?=
 =?utf-8?B?dVBCRFBKNmNnU3VNMUZZKzJoS3M5Tnl5Mi9DNVZKcDQ5N3h4R2pTNkpqeC9W?=
 =?utf-8?B?R0Zqdm9rYlZwbnFsa1lvemVTdVdTZUNEb3ZiV003NXlzWFFFUURONkZuYWI3?=
 =?utf-8?B?UC9taXpUZ09lWUtZR2sxNWpVWFZZUytLRDdZdXRuU2xJWlV6NmNNZ1JCRlQ3?=
 =?utf-8?B?U0t5NFVGWmQwVVJ3N3pWVllBUzQ2ZXJuazhMYmNqN0F6Njc3OWhEZ3gydVZh?=
 =?utf-8?B?TXpLWjJuaHRlNVlva1FiMVc4a0NqWXZqR29MUmpIRzdBN1lVQ3NOSHJONk9W?=
 =?utf-8?B?R0NtY2VCNzZjRVdQdVJqVDI4V1hHeFlPa3FWclg1MmRocHd2Y0ZWUDJud2FL?=
 =?utf-8?B?UkRtZklCREp3RXJDenQxTFFPSWNyclNJU3F4QnlmSHBxemxhNE1pNkZnODd0?=
 =?utf-8?B?VHIxY2J1YUxIaGc1VjJib2dMdW5ENkZwM0lQQjFNYVp4VFF2VmxKMmkvcTJM?=
 =?utf-8?B?cC9SUk1wVGZaUWdOSmMwbVJZY3djYTd4TnFXYmNFdzFyWjM3d3BuSS8xWFQw?=
 =?utf-8?B?dzNRYnMxcmNvMmdKR0FkaXo4ZFlSSDd4dE5GYWNteFVhTks0N2U2c3hPU3Zp?=
 =?utf-8?B?dVhHZVJWaElzNW5GUUlsU09YeDBWbWYvcDZqbEIzaVhYLzNLUThIV1BQNCtH?=
 =?utf-8?B?RXlzUy9qdm5ZUHd6ZW56WU1CVmJ2V2luc3h2aGJoR0c0YzVJOTVFR2gzOHpF?=
 =?utf-8?B?K1dqOFZCVmdFTW5Tbk5CTzVtZFUxSjV6UWszZHRVYXY1VXFTdzlMd29OYng2?=
 =?utf-8?B?V3Z0RjBrMEt4d3V6Z3BWb2d0WkNMWkZ2dlVCamtLMHlxbElFa2xhVjF0TC96?=
 =?utf-8?B?SC93UkZESXk2dFZyU0NkZEF5YWFKT1NmcU52QURNKzdYbUhtZU85dytUK3pL?=
 =?utf-8?B?aFQ0a09Fc1BmTGx5OXQ3RGc3WFNOZnZxQ1BjSjdpVGg4cHFGRnUvMnpEK3Vv?=
 =?utf-8?B?YS8yVkV2eThhdE56c1JyeTJsYy9VcHM0MlA0TXRpUzIyQkwwcTY4RFoxUmJu?=
 =?utf-8?B?UHNYMXdFZ0lRVWdRSzNwcXNhMEYwRHMvWXBjTzE2OU1sT2tUdkYvb0tNaVZx?=
 =?utf-8?B?UHZMOFBDUFNOczZLVWFlWkNTMGl6S2FmMlZYeW5rUXZJUHNUUWVsbHkyUUhI?=
 =?utf-8?B?eGFBVEJZVG52b3JLeVVyMDh0Rjgzc1JTL3dzbFpoTTVCR2dVZzN5cFpDMXE4?=
 =?utf-8?B?c0s2enhVbi82cm8wcXE5WlhCRGE0YkpZZk1WMHpxUGdFd0xyNEdFdUVHaEpW?=
 =?utf-8?B?ZTgyOVVoZHlQVnp0Wmw5WE9vT0RaSS9QUTNoNUhydm0xQzd0TkFxeXVtOFR2?=
 =?utf-8?B?RkgrRXF4clJDcVFGaUd1T2pSSVNWcXdVRk1MQnFQRDF1ZjNYNUtqVnN0UGox?=
 =?utf-8?B?Rmo4SEhaYnRhbU9oWGdmSGg0M1hSWWNuakZCVC9KVXBHU2xpQkt6N200Sk1X?=
 =?utf-8?B?UTAyZnJ3N0FGQW12bjc2b3MvSGlGRFVPbWx3cTRRRTBHVTQxZHhFVElodUJy?=
 =?utf-8?B?REt4SGp2dHN5VUd2ZmZBampBT05XMVBFNkRKUzczTU0wUExqdkVGTmJpSkhi?=
 =?utf-8?B?ZzY4ODZYQWxOcGZwQ09ONmxsRENHWjZtbEJwQUVyRHpMSlhDQUFlYmcyYTI2?=
 =?utf-8?B?SVdkeDVCZ0Z1QlEvdzdzMTVRTktXM3lHeWhWd2RpdGU5SzUyL0RqaHFTcTVx?=
 =?utf-8?B?a2tDT2dVN0FSamprWFNnbklnbjltS3cvUERBT1grTFZLYVhIMEtydjRmbUhN?=
 =?utf-8?B?dlBxWVQ2NHRqN2tEU2dxM1lIc0xUMVdXTm91YWRSaGgzZElvMGNHUEVSYmg4?=
 =?utf-8?Q?PZL1KrcIyvJgwoAcsbg13z0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0874319BA4B61A4EBD87151FF4B9B473@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3318822-daca-472c-116f-08dc753b0d3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 23:59:26.5337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wJ7ZjTR4m6QxdsGgOrXepPYU4f3I6XlnQ8LqMcyh+XW/W76bVwFv4wpFYG/h+mzPRVIEMmSOfGssEwah/JncekZu0YU7SAzFZN67Fwptpu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7515
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDExOjQ0ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IA0KPiA+IFNvcnJ5LCBzdGlsbCBub3QgY2xlYXIuIFdlIG5lZWQgdG8gc3RyaXAgdGhlIGJpdCBh
d2F5LCBzbyB3ZSBuZWVkIHRvIGtub3cNCj4gPiB3aGF0DQo+ID4gYml0IGl0IGlzLiBUaGUgcHJv
cG9zYWwgaXMgdG8gbm90IHJlbWVtYmVyIGl0IG9uIHN0cnVjdCBrdm0sIHNvIHdoZXJlIGRvIHdl
DQo+ID4gZ2V0DQo+ID4gaXQ/DQo+IA0KPiBUaGUgVERYIHNwZWNpZmljIGNvZGUgY2FuIGdldCBp
dCB3aGVuIFREWCBndWVzdCBpcyBjcmVhdGVkLg0KDQpUaGUgVERYIHNwZWNpZmljIGNvZGUgc2V0
cyBpdC4gSXQga25vd3MgR1BBVy9zaGFyZWQgYml0IGxvY2F0aW9uLg0KDQo+IA0KPiA+IA0KPiA+
IEFjdHVhbGx5LCB3ZSB1c2VkIHRvIGFsbG93IGl0IHRvIGJlIHNlbGVjdGVkICh2aWEgR1BBVyks
IGJ1dCBub3cgd2UgY291bGQNCj4gPiBkZXRlcm1pbmUgaXQgYmFzZWQgb24gRVBUIGxldmVsIGFu
ZCBNQVhQQS4gU28gd2UgY291bGQgcG9zc2libHkgcmVjYWxjdWxhdGUNCj4gPiBpdA0KPiA+IGlu
IHNvbWUgaGVscGVyLi4uDQo+ID4gDQo+ID4gQnV0IGl0IHNlZW1zIHlvdSBhcmUgc3VnZ2VzdGlu
ZyB0byBkbyBhd2F5IHdpdGggdGhlIGNvbmNlcHQgb2Yga25vd2luZyB3aGF0DQo+ID4gdGhlDQo+
ID4gc2hhcmVkIGJpdCBpcy4NCj4gDQo+IFdoYXQgSSBhbSBzdWdnZXN0aW5nIGlzIGVzc2VudGlh
bGx5IHRvIHJlcGxhY2UgdGhpcyANCj4ga3ZtX2dmbl9zaGFyZWRfbWFzaygpIHdpdGggc29tZSBr
dm1feDg2X29wcyBjYWxsYmFjayAod2hpY2ggY2FuIGp1c3QgDQo+IHJldHVybiB0aGUgc2hhcmVk
IGJpdCksIGFzc3VtaW5nIHRoZSBjb21tb24gY29kZSBzb21laG93IHN0aWxsIG5lZWQgaXQgDQo+
IChlLmcuLCBzZXR0aW5nIHVwIHRoZSBTUFRFIGZvciBzaGFyZWQgbWFwcGluZywgd2hpY2ggbXVz
dCBpbmNsdWRlIHRoZSANCj4gc2hhcmVkIGJpdCB0byB0aGUgR1BBKS4NCj4gDQo+IFRoZSBhZHZh
bnRhZ2Ugb2YgdGhpcyB3ZSBjYW4gZ2V0IHJpZCBvZiB0aGUgY29uY2VwdCBvZiAnZ2ZuX3NoYXJl
ZF9tYXNrJyANCj4gaW4gdGhlIE1NVSBjb21tb24gY29kZS7CoCBBbGwgR0ZOcyByZWZlcmVuY2Vk
IGluIHRoZSBjb21tb24gY29kZSBpcyB0aGUgDQo+IGFjdHVhbCBHRk4gKHcvbyB0aGUgc2hhcmVk
IGJpdCkuDQoNCldoZW4gaXQgaXMgYWN0dWFsbHkgYmVpbmcgdXNlZCBhcyB0aGUgc2hhcmVkIGJp
dCBpbnN0ZWFkIG9mIGFzIGEgd2F5IHRvIGNoZWNrIGlmDQphIGd1ZXN0IGlzIGEgVEQsIHdoYXQg
aXMgdGhlIHByb2JsZW0/IEkgdGhpbmsgdGhlIHNoYXJlZF9tYXNrIHNlcnZlcyBhIHJlYWwNCihz
bWFsbCkgcHVycG9zZSwgYnV0IGl0IGlzIG1pc3VzZWQgZm9yIGEgYnVuY2ggb2Ygb3RoZXIgc3R1
ZmYuIElmIHdlIG1vdmUgdGhhdA0Kb3RoZXIgc3R1ZmYgdG8gbmV3IGhlbHBlcnMsIHRoZSBzaGFy
ZWQgbWFzayB3aWxsIHN0aWxsIGJlIG5lZWRlZCBmb3IgaXQncw0Kb3JpZ2luYWwgam9iLg0KDQpX
aGF0IGlzIHRoZSBiZW5lZml0IG9mIHRoZSB4ODZfb3BzIG92ZXIgYSBzdGF0aWMgaW5saW5lPyAN
Cg==

