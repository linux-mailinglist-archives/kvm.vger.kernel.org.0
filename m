Return-Path: <kvm+bounces-18421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CA48D4B6C
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 14:22:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D6C1284E1E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 12:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E0F1C9EC4;
	Thu, 30 May 2024 12:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PvzXi2cn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA4C16F0C1;
	Thu, 30 May 2024 12:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717071728; cv=fail; b=RJDM+nD9VRhOi5d4wnQbxOsxWnsXbekK6Bk+lrm95gJow+6jShYfr+vXIDhGdnk5M11aVmxk9Ztn17v8vw6wS0HQKcNnU41oq8pJgL8ApvE+roQvxlMixPFKmHiwYBQpnjbtEn4f1VrpwwQIhpL8pFwEbfHuytOFNVw7EVR1n5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717071728; c=relaxed/simple;
	bh=08CAFV0Z35YpACnH/6TQ+v/A9k663OFoYdO8QOVkwRE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=toZ9qrVIqri7BGTsyNmQBYVelRrNpcW5Yf5EHLfl3cZOlJusZ407sfd66wlCP8sczmH8aKn4TCkhA08xkfNGTIZ9pAC6+qp1xQbkNG0t9R0Z0+lF+EFCHL+8ZAacpIC/fb3QfDVssbrdsAFi48MrsH7cZvJzkdS7mHuOSaU2JCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PvzXi2cn; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717071726; x=1748607726;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=08CAFV0Z35YpACnH/6TQ+v/A9k663OFoYdO8QOVkwRE=;
  b=PvzXi2cnwfDhlcc3zT5H8CQH8P/VOtwy72/W9otukdHZr740e8FdEcLw
   8yz0u6c7SxljodAGns5N8jeIttT0JPJqukbgqsEIbHH12Q1ct4MNM/+yW
   nwLujsiYNVEJaZYkhuhVT/58HzgumqIjzMi3bULHxQVvTkUrk1DzhBnxh
   DNgfNqeoov3scmVw/+6epZSGjfxhv6ic9B0ww4jo7WJA47rN46w0PQfrb
   tEWsHLIlEToc0cOTUYRwxOL/VW7Af6kto+0XxsZP3CU6WEAklyVqwjwYV
   DSbiOT81NyUGhcMuQAvNpy+rRZuVT28L08bCTf762HlEwcsrmFVLrr6hp
   Q==;
X-CSE-ConnectionGUID: PnBdldPfSL200CFash8/gQ==
X-CSE-MsgGUID: KtSDdfbDQD+xZ8KT2yNrHg==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13709272"
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="13709272"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 05:22:06 -0700
X-CSE-ConnectionGUID: Y2stpbFXS4GIU7pZKpGPag==
X-CSE-MsgGUID: 7jIbXTKUSJ+2tkaf/NwhqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="40240025"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 05:22:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 05:22:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 05:22:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 05:22:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 05:22:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZLoANLeh4NVhRDrzKWOAs2iL3lqqvbpZWLcZxoBD1g/sDLFbya/OeIJEZhTnXiqHgVethCxJcLqfiA2yrPwZ/sQNs6ER/Cm4YGUovxVoqTAqCHx2W5Oh9j5QvvQkmQo6Ap3I6//rRAaSxqj2ZRGwdEmuJ+Rox1JOBKYTqtOFH4GtFtWPq1OJaqVrmMJfMZVDAh22IgcRFNcJHTs+FxMXzGqEMgcKOTUCG2aOjGiE18lRy/WXDQgXl9cb/DiaOMo/wp4hZF8uE6wNEL0lzbxzlDu51JXZdoyB8f+wxsP+FNcffvwQLbkTWkq/La5gEVWupB16XcL/2dWwvUw1lKMbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=08CAFV0Z35YpACnH/6TQ+v/A9k663OFoYdO8QOVkwRE=;
 b=DSQ2Txnfr0jrtMumF+YflqNuJUFc1oov3+CEgnLOGsgViBuJxEdsBtV+tKrIwCg850mUd4HHp/2VlX6faNCUUHYSQLeKqADYKZs3L0Y1d20j3hZXdro7zDjLQ9FEszWNZj398/Y8Ka60NKKrAwxKLxxnWa9+PB79UBBJChDad5ZFTg9lCHENWYxCGXc3M8YUey8Ep8jnmbJHwmplh2shldNya+UZuYhC1m5L+zMilwz4IjBLwmz6m/XCKY1FWm6N1Yk8+f0otFfIF1eVICnTo5M1KOG7vBh6/pKvbPZgzUVWds9QwLAGlcRAXfxpdNFOqsXCdaRjw+KIVztjMZqDSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB7857.namprd11.prod.outlook.com (2603:10b6:8:da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Thu, 30 May
 2024 12:21:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7633.021; Thu, 30 May 2024
 12:21:58 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Topic: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Index: AQHaaI2/dJkfmwuOl0Kzt5Q4G20a/rGPjNSAgABl+QCAAANegIAAB3kAgAAJ9QCAAO1bAIAFfyEAgBj234CAANvZgA==
Date: Thu, 30 May 2024 12:21:58 +0000
Message-ID: <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
	 <Zjz7bRcIpe8nL0Gs@google.com>
	 <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
	 <Zj1Ty6bqbwst4u_N@google.com>
	 <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
	 <20240509235522.GA480079@ls.amr.corp.intel.com>
	 <Zj4phpnqYNoNTVeP@google.com>
	 <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
	 <Zle29YsDN5Hff7Lo@google.com>
In-Reply-To: <Zle29YsDN5Hff7Lo@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB7857:EE_
x-ms-office365-filtering-correlation-id: f275f623-5baa-4dfa-ca98-08dc80a31a17
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?akNFckNYS2JzRktqRmZrbTAxRXp2eHk2NllJVmptMWRZUHBCU3hwTDJyeWNr?=
 =?utf-8?B?c3hVKzZETHB1S1hMTlF3RFNZbjk2VkpPdHFrbkR5R3MrSklzSUM4MXRnZm9u?=
 =?utf-8?B?T3paVGIxbG1nVEVVT0R0OUw2UUliT2h0U21hcmhlQnEwVko1REpoRHN3dFpX?=
 =?utf-8?B?bkJLQWN2bm11UnF3TG1LRUpUWCt5YjN4Uy9SajRjdFIweDFwYUNnaVZOLytH?=
 =?utf-8?B?UFYvcHNhWHlmWllaeTZzNXF3SC9CLzRla09MUlNQSldzeU9LMk00VDI1eGZp?=
 =?utf-8?B?L1cxdHhJUjcxcTA4VXdhNVBTYnBFbG1pWFJLaHEzZ1d3ZjMzQ01INk9hRG1Q?=
 =?utf-8?B?WWR4VkdNQ2cyOUd3VytVM1BQQktYejVPVGxTdEcyc1pyeXlTY1lNMmVMTGJC?=
 =?utf-8?B?bWRoL1R2U0VkS2RqemRVZnc1NEFBR2RDdUlnYTA3TGpMbW1DdWMrSDhWYVdU?=
 =?utf-8?B?cjVnYVR1MGVMME9FcWdIZjdwUnVCcFhDOHdESjBsa29DVklCWUFQVHg3N1dF?=
 =?utf-8?B?SDlWR3dRNjg1N1lHREpDQmUzd25rbmZMeGFXK0lORytlWU9FbGZIZjAwdlVW?=
 =?utf-8?B?K3dIbnVYRGlOeFNmRlI0WkpzVHFzVU9LOXpQUzZRRWQxQ3hhSFAxY1IvSkVJ?=
 =?utf-8?B?VzY0eEFsc21CRW5KZUt1d1FsNGdJZTBLYzJnS2J6aVIwV0ltN2tMZzZYRDkv?=
 =?utf-8?B?TWYvRnlvYVlPZzkxZ3hjTDdjV1VoMnF2dzIrVGJHWXlHMkR0RHZMNkVZV20r?=
 =?utf-8?B?ZnpERDJlYUc1cHY5TXNrSFRGRUJaMW14K1ZWZGFRZktXajZsQXh0ZmNPM2hs?=
 =?utf-8?B?bm9xdk1vUzd2enRENXNIMlg4NzlCdDNCUTBpaWZnQ0FFbkJwVjNyeHFZUXVn?=
 =?utf-8?B?eXVUOXEzWTJOSUFINGozdnVNbFB4N01yaDRzMUwzclVzNUJESW10aDBnSVJa?=
 =?utf-8?B?K1dESStTdFJ1Uk05cmpvNFlUSUhCR3JiRVpPTGMzakFZcFh5a040aXVNUm1t?=
 =?utf-8?B?cGtaWmNSb0NTc1hUSjN1eUNQcHhMejZ2ZkNmUmhSTEFUazVHMWhtYXdqbTdr?=
 =?utf-8?B?SUxTcStWbWhVTExhcDVNYUdnT25LcElZZ0xLUHBNQ01tRS9HeWNDSzZ3a0Zj?=
 =?utf-8?B?bU1odVpWUHBudXo1Q3lSbFBpck54dVpqMVhqU002d0l5NDVwMW8wQ0JoN1FG?=
 =?utf-8?B?NHA1RUo0OFNEdEdqb24vbXFLMjQ1NlZRNVJQYkdTUUVBa1lZZlBZczZDNmRr?=
 =?utf-8?B?ZUNrNG84V3Y0SXhPeFFVLys3cHZTY2Ruc09vb1hOWGVzbmV4ZzZrNStrUFZ0?=
 =?utf-8?B?d3hNR21BbWNuZ3hPTW1XbldmWjdmWFRPcTBPbWtHckkrci93cnZ1aE1tRDdj?=
 =?utf-8?B?Y2N4K2ZyQzNnNWpMeS80QnpkaENGV3ExZU5QMFJ5NWk3MlArZE43SkxHbEVC?=
 =?utf-8?B?eWxISnU3ZWZ3bEpDUmdjc0Q5UW15dDVKZmVOVWhLYUxIdDlYODY5N2FiYnNK?=
 =?utf-8?B?L1VFTkMwYXBHL0t5ZFBrNzVaZXhyWVExczRadXBYZ0J4M2cxU245YmdMbU5P?=
 =?utf-8?B?dlRESmc5MHFKSFpUL3phS3BwMkxFditsRFZ4UDFYQ2RFRVNJMzBNS3pBRjJi?=
 =?utf-8?B?U2ttVjVsRU1VbHRyVGU2TDZ3V3hVN3FCdU9nNnU0TEFhRUZieFZYL05qSTIy?=
 =?utf-8?B?SFFLMHlaWkxuSk8xUi96WTREcDdIeGZvc0k1V0I0cUw1a0FOZVc2WXlMYS80?=
 =?utf-8?B?WTJrb0pXbE1wQ0dSMzJERFpwWEVINDUvREhWVUdmVVptQ1dvZFhmQ2xQcjNx?=
 =?utf-8?B?OUZYREFRT0pqaG1JaFZHQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnh3RjFoZDk1cWdYTGp3aTFjV1JNK1hLdFI1Y0NyUk53MWg4OTZZV0pLL2Jw?=
 =?utf-8?B?aWRSVEZCbEozYytselFTWnNmemphYmg2OU4yK1Exb1hVZUp1TXU5cXV3YkZa?=
 =?utf-8?B?bkRudVFDUDZaTDdzZUlJUmxyNUtwcnRwWVNoUjdDV1VsQUpVZ3drNmJxWTIv?=
 =?utf-8?B?STVqbDdFVDlrd0dwMFovN2NJMVREcmFtNm9OUW9idG5JZEV1ZVd6dHh0Tkkv?=
 =?utf-8?B?cVpiY1pLWENhTE1hN1NtYVNGRGxYQ01OSkpRVVB6NUIzWnZONUozVFp0Sk1R?=
 =?utf-8?B?T3RWWXRxbFNkTkhwdFc3MkpET3BzaUFmZUQ2WkFQZ3R3ZytDY3doRysrYnNE?=
 =?utf-8?B?Z2RZR0tMeU5xNERkbHNEeUtMVlBZQkRuQmRTZTVRVmhieDhVVE5iNjF3Nm8r?=
 =?utf-8?B?dnZxWXNQNTFXYWtGNm5oaG5vRmFLWVhFL2NXV0hSYkoxc0p4U21RdkJWSXls?=
 =?utf-8?B?UXdUSzRTd3VYNHkySW13QWtaT3hUeHRKOVQvWEJ6VVJEbG1FUjZzTEFCYk1T?=
 =?utf-8?B?NGhZMUY0ODg1NVNKT3J4OXZwR0tudHdoMWtpU1dWNjZKWUFPMUozdFB4Mk5m?=
 =?utf-8?B?QVEwYkd5MGdVeThzaDlyWXVZelRDTTdPQjFJYkYrY2NzaHRXRDliVTljdm8y?=
 =?utf-8?B?Zkk1b2FlOU1aYS9KSGc4eUdQUThUdVFoT0ltZ2R6Si9OeHptNlQwdUovT3No?=
 =?utf-8?B?VFFPT21qMk54S3JnY052T2RtWUR4ajNzU1Q5RXlQeFVpRHhnYXFueW9mSmNv?=
 =?utf-8?B?VkJIU3p0bE1jdW8yK1JNU2EyakNlOHByb0xjM2d3ZlJ0RHFBbjkrL2NNdzVT?=
 =?utf-8?B?Z1dmQkt0SVdpY0JEQXJJVUNET0xFdUI5RnNRTXF5S1FBU2lKNzdnL2RkME45?=
 =?utf-8?B?MkZjbFNySks3TTE5M3RpaHNuZ3FraEFUdExWR3ZLQWxYT2FhR3JwTUdUaFk3?=
 =?utf-8?B?eWRIWm1xR1c3NTZtK3BGNGw0WkRHWE9kODBORG5UaUxtK3c2ZFlOQzVMaDNG?=
 =?utf-8?B?Z3puMjlZbFF5blJaQUZuWE9VMWdjRExQOEJTUVM2ZmJkMVRtcW9SVWdqQVhY?=
 =?utf-8?B?MWpZL1JZWmpCMWhCNlNjR01qQnY2YTduWDBzd3ltekdQQi8wRTlBV3FOcXBS?=
 =?utf-8?B?eGRpQllBalMrVEg2dk1sdXBPclBGY1pTTHJtcGJidFUzZC9qbTY0WjJkdFNH?=
 =?utf-8?B?QlUxZ3Zodmd2a281bXBRSzkyYnNVQVlFN1JRQlNXdlJId3FCamtydlpvN1BR?=
 =?utf-8?B?L3BrZ2dGbWFlQWc5VXBrY3NlT3ZiYXVUWWxRSVpMWEFscEl1Mkc2M1Q0T1lo?=
 =?utf-8?B?OWRhZEQyaHRZdjRQMjJoNEFkR0cyRG0zcG90Zi9vUDdhQlFROWhBcy9RbVlR?=
 =?utf-8?B?R05UQUlVVGJ2Q245VXNzTWd2bER1SVFrOVBMT3MxU1dYd3dxT0w3eGtGWE1s?=
 =?utf-8?B?OHYxVDJLZ2ZGelA5RlBHTmIvZ1dqRTBjRXN5SkhEeTVIWHBBaERmbkFmTndS?=
 =?utf-8?B?c3EySHlpMUdkTHF6ODYyWTNKRm1XREVyMHhSaXd4eW14azdGaE9oUGVRQkpu?=
 =?utf-8?B?VVU2RlRxVzFEcFY2SVgvUXFoZXZJcUVCemhENDNPWks5MXZqcjIxSVNlVGlP?=
 =?utf-8?B?ZmRGVTRWSlZxY016M1ZBMlU2dWVlRVdtbjYvMG9Fb3JEQ2pUNjZtTFphNXZk?=
 =?utf-8?B?ck9jY1ZuNlEvYzI0T1kwQkVmRHhad0NMdmV2dVdicGRlMlpQdERqeE9RSjRC?=
 =?utf-8?B?aDBjRVN3QzZCMGN1eDJodGJFR0llTkk2Y2dGa2ZQTEk4RnJMNDY1K1dOYVRG?=
 =?utf-8?B?NmJjTTFmL2FoWDNPbWZYUStvYWFNSnVYUkt0RUVmYXIvdlh2YU9UNFJoUWgv?=
 =?utf-8?B?VjFCZVpOQjV3dWp5WUQzR1JqTWxBRytZaFFHdGYwM2tkd2p3TWlaeVFCQU1F?=
 =?utf-8?B?eitYTDFycnBVaDM2NkVWTDBtVVRsVlNOelRUUFNTcjE4VXdOTkxRckt4V3dL?=
 =?utf-8?B?ZTh5VGs0SFZYb3hZWFZ0NVVtdWRHSEVpVEJwT09UeTM0eDBxVjMyb0lxTXJG?=
 =?utf-8?B?N29wd1lDTFZhaWlueDJnT3h1UlRnZ1ZlbC9xTjVjY21qTnNpNFBTN0Y0MFBB?=
 =?utf-8?B?M1k3aHpveFhLRFpYeHlOWkFMbTNmYkx4bGd2K3ZQdmlzUG5xaUZwajFJZlZC?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E186905B7418ED4EA73814785BBEC0E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f275f623-5baa-4dfa-ca98-08dc80a31a17
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2024 12:21:58.5225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EoIeylLsBWxzyiHPS5SsM91zUB1iq4Cu76NLPdOKmqsYBIvfhTYHhvUXGWHwocDFNEQzcWebZab/EDLdqSllRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7857
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTI5IGF0IDE2OjE1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE1heSAxNCwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IA0KPiA+
IA0KPiA+IE9uIDExLzA1LzIwMjQgMjowNCBhbSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFRodSwgTWF5IDA5LCAyMDI0LCBJc2FrdSBZYW1haGF0YSB3cm90ZToNCj4gPiA+
ID4gT24gRnJpLCBNYXkgMTAsIDIwMjQgYXQgMTE6MTk6NDRBTSArMTIwMCwgS2FpIEh1YW5nIDxr
YWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+ID4gPiBPbiAxMC8wNS8yMDI0IDEwOjUy
IGFtLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+ID4gPiA+ID4gT24gRnJpLCBNYXkg
MTAsIDIwMjQsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+ID4gPiA+ID4gT24gMTAvMDUvMjAyNCA0
OjM1IGFtLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+IEtWTSB4
ODYgbGltaXRzIEtWTV9NQVhfVkNQVVMgdG8gNDA5NjoNCj4gPiA+ID4gPiA+ID4gPiANCj4gPiA+
ID4gPiA+ID4gPiAgICAgIGNvbmZpZyBLVk1fTUFYX05SX1ZDUFVTDQo+ID4gPiA+ID4gPiA+ID4g
CWludCAiTWF4aW11bSBudW1iZXIgb2YgdkNQVXMgcGVyIEtWTSBndWVzdCINCj4gPiA+ID4gPiA+
ID4gPiAJZGVwZW5kcyBvbiBLVk0NCj4gPiA+ID4gPiA+ID4gPiAJcmFuZ2UgMTAyNCA0MDk2DQo+
ID4gPiA+ID4gPiA+ID4gCWRlZmF1bHQgNDA5NiBpZiBNQVhTTVANCj4gPiA+ID4gPiA+ID4gPiAJ
ZGVmYXVsdCAxMDI0DQo+ID4gPiA+ID4gPiA+ID4gCWhlbHANCj4gPiA+ID4gPiA+ID4gPiANCj4g
PiA+ID4gPiA+ID4gPiB3aGVyZWFzIHRoZSBsaW1pdGF0aW9uIGZyb20gVERYIGlzIGFwcHJhcmVu
dGx5IHNpbXBseSBkdWUgdG8gVERfUEFSQU1TIHRha2luZw0KPiA+ID4gPiA+ID4gPiA+IGEgMTYt
Yml0IHVuc2lnbmVkIHZhbHVlOg0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+ICAg
ICAgI2RlZmluZSBURFhfTUFYX1ZDUFVTICAofih1MTYpMCkNCj4gPiA+ID4gPiA+ID4gPiANCj4g
PiA+ID4gPiA+ID4gPiBpLmUuIGl0IHdpbGwgbGlrZWx5IGJlIF95ZWFyc18gYmVmb3JlIFREWCdz
IGxpbWl0YXRpb24gbWF0dGVycywgaWYgaXQgZXZlciBkb2VzLg0KPiA+ID4gPiA+ID4gPiA+IEFu
ZCBfaWZfIGl0IGJlY29tZXMgYSBwcm9ibGVtLCB3ZSBkb24ndCBuZWNlc3NhcmlseSBuZWVkIHRv
IGhhdmUgYSBkaWZmZXJlbnQNCj4gPiA+ID4gPiA+ID4gPiBfcnVudGltZV8gbGltaXQgZm9yIFRE
WCwgZS5nLiBURFggc3VwcG9ydCBjb3VsZCBiZSBjb25kaXRpb25lZCBvbiBLVk1fTUFYX05SX1ZD
UFVTDQo+ID4gPiA+ID4gPiA+ID4gYmVpbmcgPD0gNjRrLg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+
ID4gPiA+ID4gQWN0dWFsbHkgbGF0ZXIgdmVyc2lvbnMgb2YgVERYIG1vZHVsZSAoc3RhcnRpbmcg
ZnJvbSAxLjUgQUZBSUNUKSwgdGhlIG1vZHVsZQ0KPiA+ID4gPiA+ID4gPiBoYXMgYSBtZXRhZGF0
YSBmaWVsZCB0byByZXBvcnQgdGhlIG1heGltdW0gdkNQVXMgdGhhdCB0aGUgbW9kdWxlIGNhbiBz
dXBwb3J0DQo+ID4gPiA+ID4gPiA+IGZvciBhbGwgVERYIGd1ZXN0cy4NCj4gPiA+ID4gPiA+IA0K
PiA+ID4gPiA+ID4gTXkgcXVpY2sgZ2xhbmNlIGF0IHRoZSAxLjUgc291cmNlIHNob3dzIHRoYXQg
dGhlIGxpbWl0IGlzIHN0aWxsIGVmZmVjdGl2ZWx5DQo+ID4gPiA+ID4gPiAweGZmZmYsIHNvIGFn
YWluLCB3aG8gY2FyZXM/ICBBc3NlcnQgb24gMHhmZmZmIGNvbXBpbGUgdGltZSwgYW5kIG9uIHRo
ZSByZXBvcnRlZA0KPiA+ID4gPiA+ID4gbWF4IGF0IHJ1bnRpbWUgYW5kIHNpbXBseSByZWZ1c2Ug
dG8gdXNlIGEgVERYIG1vZHVsZSB0aGF0IGhhcyBkcm9wcGVkIHRoZSBtaW5pbXVtDQo+ID4gPiA+
ID4gPiBiZWxvdyAweGZmZmYuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSSBuZWVkIHRvIGRvdWJs
ZSBjaGVjayB3aHkgdGhpcyBtZXRhZGF0YSBmaWVsZCB3YXMgYWRkZWQuICBNeSBjb25jZXJuIGlz
IGluDQo+ID4gPiA+ID4gZnV0dXJlIG1vZHVsZSB2ZXJzaW9ucyB0aGV5IG1heSBqdXN0IGxvdyBk
b3duIHRoZSB2YWx1ZS4NCj4gPiA+ID4gDQo+ID4gPiA+IFREIHBhcnRpdGlvbmluZyB3b3VsZCBy
ZWR1Y2UgaXQgbXVjaC4NCj4gPiA+IA0KPiA+ID4gVGhhdCdzIHN0aWxsIG5vdCBhIHJlYXNvbiB0
byBwbHVtYiBpbiB3aGF0IGlzIGVmZmVjdGl2ZWx5IGRlYWQgY29kZS4gIEVpdGhlcg0KPiA+ID4g
cGFydGl0aW9uaW5nIGlzIG9wdC1pbiwgYXQgd2hpY2ggSSBzdXNwZWN0IEtWTSB3aWxsIG5lZWQg
eWV0IG1vcmUgdUFQSSB0byBleHByZXNzDQo+ID4gPiB0aGUgbGltaXRhdGlvbnMgdG8gdXNlcnNw
YWNlLCBvciB0aGUgVERYLW1vZHVsZSBpcyBwb3RlbnRpYWxseSBicmVha2luZyBleGlzdGluZw0K
PiA+ID4gdXNlIGNhc2VzLg0KPiA+IA0KPiA+IFRoZSAnbWF4X3ZjcHVzX3Blcl90ZCcgZ2xvYmFs
IG1ldGFkYXRhIGZpZWxkcyBpcyBzdGF0aWMgZm9yIHRoZSBURFggbW9kdWxlLg0KPiA+IElmIHRo
ZSBtb2R1bGUgc3VwcG9ydHMgdGhlIFREIHBhcnRpdGlvbmluZywgaXQganVzdCByZXBvcnRzIHNv
bWUgc21hbGxlcg0KPiA+IHZhbHVlIHJlZ2FyZGxlc3Mgd2hldGhlciB3ZSBvcHQtaW4gVERYIHBh
cnRpdGlvbmluZyBvciBub3QuDQo+ID4gDQo+ID4gSSB0aGluayB0aGUgcG9pbnQgaXMgdGhpcyAn
bWF4X3ZjcHVzX3Blcl90ZCcgaXMgVERYIGFyY2hpdGVjdHVyYWwgdGhpbmcgYW5kDQo+ID4ga2Vy
bmVsIHNob3VsZCBub3QgbWFrZSBhbnkgYXNzdW1wdGlvbiBvZiB0aGUgdmFsdWUgb2YgaXQuDQo+
IA0KPiBJdCdzIG5vdCBhbiBhc3N1bXB0aW9uLCBpdCdzIGEgcmVxdWlyZW1lbnQuICBBbmQgS1ZN
IGFscmVhZHkgcGxhY2VzIHJlcXVpcmVtZW50cw0KPiBvbiAiaGFyZHdhcmUiLCBlLmcuIGt2bS1p
bnRlbC5rbyB3aWxsIHJlZnVzZSB0byBsb2FkIGlmIHRoZSBDUFUgZG9lc24ndCBzdXBwb3J0DQo+
IGEgYmFyZSBtaW1pbXVtIFZNWCBmZWF0dXJlIHNldC4gIFJlZnVzaW5nIHRvIGVuYWJsZSBURFgg
YmVjYXVzZSBtYXhfdmNwdXNfcGVyX3RkDQo+IGlzIHVuZXhwZWN0ZWRseSBsb3cgaXNuJ3QgZnVu
ZGFtZW50YWxseSBkaWZmZXJlbnQgdGhhbiByZWZ1c2luZyB0byBlbmFibGUgVk1YDQo+IGJlY2F1
c2UgSVJRIHdpbmRvdyBleGl0aW5nIGlzIHVuc3VwcG9ydGVkLg0KDQpPSy4gIEkgaGF2ZSBubyBh
cmd1bWVudCBhZ2FpbnN0IHRoaXMuDQoNCkJ1dCBJIGFtIG5vdCBzdXJlIHdoeSB3ZSBuZWVkIHRv
IGhhdmUgc3VjaCByZXF1aXJlbWVudC4gIFNlZSBiZWxvdy4NCg0KPiANCj4gSW4gdGhlIHVubGlr
ZWx5IGV2ZW50IHRoZXJlIGlzIGEgbGVnaXRpbWF0ZSByZWFzb24gZm9yIG1heF92Y3B1c19wZXJf
dGQgYmVpbmcNCj4gbGVzcyB0aGFuIEtWTSdzIG1pbmltdW0sIHRoZW4gd2UgY2FuIHVwZGF0ZSBL
Vk0ncyBtaW5pbXVtIGFzIG5lZWRlZC4gIEJ1dCBBRkFJQ1QsDQo+IHRoYXQncyBwdXJlbHkgdGhl
b3JldGljYWwgYXQgdGhpcyBwb2ludCwgaS5lLiB0aGlzIGlzIGFsbCBtdWNoIGFkbyBhYm91dCBu
b3RoaW5nLg0KDQpJIGFtIGFmcmFpZCB3ZSBhbHJlYWR5IGhhdmUgYSBsZWdpdGltYXRlIGNhc2U6
IFREIHBhcnRpdGlvbmluZy4gIElzYWt1DQp0b2xkIG1lIHRoZSAnbWF4X3ZjcHVzX3Blcl90ZCcg
aXMgbG93ZWQgdG8gNTEyIGZvciB0aGUgbW9kdWxlcyB3aXRoIFREDQpwYXJ0aXRpb25pbmcgc3Vw
cG9ydGVkLiAgQW5kIGFnYWluIHRoaXMgaXMgc3RhdGljLCBpLmUuLCBkb2Vzbid0IHJlcXVpcmUN
ClREIHBhcnRpdGlvbmluZyB0byBiZSBvcHQtaW4gdG8gbG93IHRvIDUxMi4NCg0KU28gQUZBSUNU
IHRoaXMgaXNuJ3QgYSB0aGVvcmV0aWNhbCB0aGluZyBub3cuDQoNCkFsc28sIEkgd2FudCB0byBz
YXkgSSB3YXMgd3JvbmcgYWJvdXQgIk1BWF9WQ1BVUyIgaW4gdGhlIFREX1BBUkFNUyBpcyBwYXJ0
DQpvZiBhdHRlc3RhdGlvbi4gIEl0IGlzIG5vdC4gIFREUkVQT1JUIGRvc2VuJ3QgaW5jbHVkZSB0
aGUgIk1BWF9WQ1BVUyIsIGFuZA0KaXQgaXMgbm90IGludm9sdmVkIGluIHRoZSBjYWxjdWxhdGlv
biBvZiB0aGUgbWVhc3VyZW1lbnQgb2YgdGhlIGd1ZXN0Lg0KDQpHaXZlbiAiTUFYX1ZDUFVTIiBp
cyBub3QgcGFydCBvZiBhdHRlc3RhdGlvbiwgSSB0aGluayB0aGVyZSdzIG5vIG5lZWQgdG8NCmFs
bG93IHVzZXIgdG8gY2hhbmdlIGt2bS0+bWF4X3ZjcHVzIGJ5IGVuYWJsaW5nIEtWTV9FTkFCTEVf
Q0FQIGlvY3RsKCkgZm9yDQpLVk1fQ0FQX01BWF9WQ1BVUy4NCg0KU28gd2UgY291bGQganVzdCBv
bmNlIGZvciBhbGwgYWRqdXN0IGt2bS0+bWF4X3ZjcHVzIGZvciBURFggaW4gdGhlDQp0ZHhfdm1f
aW5pdCgpIGZvciBURFggZ3Vlc3Q6DQoNCglrdm0tPm1heF92Y3B1cyA9IG1pbihrdm0tPm1heF92
Y3B1cywgdGR4X2luZm8tPm1heF92Y3B1c19wZXJfdGQpOw0KDQpBRkFJQ1Qgbm8gb3RoZXIgY2hh
bmdlIGlzIG5lZWRlZC4NCg0KQW5kIGluIEtWTV9URFhfVk1fSU5JVCAod2hlcmUgVERILk1ORy5J
TklUIGlzIGRvbmUpIHdlIGNhbiBqdXN0IHVzZSBrdm0tDQo+bWF4X3ZjcHVzIHRvIGZpbGwgdGhl
ICJNQVhfVkNQVVMiIGluIFREX1BBUkFNUy4NCg0K

