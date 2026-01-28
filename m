Return-Path: <kvm+bounces-69417-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WAqfIUV7emka7AEAu9opvQ
	(envelope-from <kvm+bounces-69417-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 22:10:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6B1A8F70
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 22:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5F3A303A266
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 21:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F91D377556;
	Wed, 28 Jan 2026 21:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IEY2UOyv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BEA2EA169;
	Wed, 28 Jan 2026 21:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769634614; cv=fail; b=m/BWM/lhGv1IWU4TNnxUtea7aWYvC90rsuNVDpThalr85IKWzQnEiErdsz3TUHar3eCh5zZVCUM55zDW3IzK0PcgXf/JGS+kfHzKGb39g4wZtwYQ+1gSbLg+/Nxaac5J6DUrgVZ/Arm0yZWlgPzyQOisqCvI2/swgRdjeDSfe/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769634614; c=relaxed/simple;
	bh=ZVaITuD6HYr4hPrXtbQNi0QCIrmiFQSD+EDKp+ptd10=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A+ZCEK++MW28ALIAFXNWdPj71Gn6GYTZHRzjvKoDh0GlLAQenrPfnsCB+7CcFyYsG+jOAcr+oDYLKurNbBC5xEV4ZG+MDt1JEP2ve0Llom/tMllWOUiYEaSluNLIZvhJ4VwD8y0ZAlX0jSjon/85lFKQ/KwDVDR+mdY1g22K7G0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IEY2UOyv; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769634613; x=1801170613;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZVaITuD6HYr4hPrXtbQNi0QCIrmiFQSD+EDKp+ptd10=;
  b=IEY2UOyvvS8sL2god3Xfgr9YrATwawb3hMIqnVj6v0A+bLM6DPJs8l+4
   LtJgEZzlQBBoa+4SIvYYZzimpNmbZGlAQvZfbl9kNZM6PILtQ0jf1GwGO
   8oC+e38Vr7a74MQ/XoSxP6G21e9w57/vEXJTSDQP8mJWXsoYx4Jc4U+3f
   vXtNtsb4i6vP5nHmglU5HJCdQliUIW62Cgrmbs8/wnF2nmKFxftFaFt4i
   LxZxvE7oaEIHdzkpRuHThhgCQIdllSvkonl4Zg4UNomv66Op1/3THmIaV
   9ntIcBxvomp2mXzewlZnWaPGk1lhpUjfr0uA5mXUkQuPwJ4E+VWakv+ng
   A==;
X-CSE-ConnectionGUID: QlttsY4cSyCt0PoOyrkUhw==
X-CSE-MsgGUID: cNNmFKTGRvyiB7LTyce8Cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="81589280"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="81589280"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 13:10:12 -0800
X-CSE-ConnectionGUID: F+6ibl+aT7+tShYreM/OHQ==
X-CSE-MsgGUID: tuJUHumGRkSqgAYgAS3jcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="239627833"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 13:10:12 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 13:10:11 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 13:10:11 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.33) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 13:10:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q7XDA86R9ALaOTuniYHt/83YP9Bi7hkcy95+1ipKSP+U/eTEqFxmK1B4Fb/dS/J57KF7lPa7aFY3Ukd0qu9Qz2zAqMVedSaRKStXrjLs45Fotgczwtq7LG9EA3z9i4eQmaQZ7fwKk3NI5BIQ5To8pkF48nXc5w0vySuT3Td5CD8aGRKG1Y+4s0IxQKmFpshY79aQIQ7GGGV0xUyrWX80i3JLmgs9VaY7VMEDdLSPY3jYnQC53tk8WJJualDLNeHLRN3L2Axh4i+KVrNaStJ4zc0xfQ+L+ZD9MqxiMc9f6vUoh0RsBwnzG5mevSL4Asw+i+tTfo2njsaVtgY0GbqezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVaITuD6HYr4hPrXtbQNi0QCIrmiFQSD+EDKp+ptd10=;
 b=vyqwKTow0AHKWlVK3oW2+hrY3fJmvL6OuXKmNsg8ImKU2Evw68Q8Qx7TPd1/7rrxxVdQKV2vUIM+9tpxA3EYuWu8Ax+0tO/eh5kZM7i1mngPRBXP6AXV8CW4Yh3MMNc5GKa5yJuhfRLEvrw4zKO38B5sL72YeZmwv0fTA4N1L0vcOTwGGbC/q4sxksRtSeXdcSYL9j6XqnzefXqoAH4ndU5Whp7PC4XedSWkMze8XGE5E3ih/XmUVAPe/W3b7Iz76daNxC8tVKyqmI6CfwraXB9EVR4ndYmcYjteBE/80n4I+R/POSn0Sszh9KH7e9kVyRc+ilLmwfX8qViPPJn8Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB7423.namprd11.prod.outlook.com (2603:10b6:510:282::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 21:10:06 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9564.007; Wed, 28 Jan 2026
 21:10:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>, "khushit.shah@nutanix.com"
	<khushit.shah@nutanix.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com"
	<hpa@zytor.com>, "Kohler, Jon" <jon@nutanix.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "shaju.abraham@nutanix.com"
	<shaju.abraham@nutanix.com>
Subject: Re: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcjGf2hzr1Aefe/EG2AzLgdqhXDbVmiYUAgAALLICAAA1igIAAPvyAgAAYH4CAACjrAIAAkgMAgABoBIA=
Date: Wed, 28 Jan 2026 21:10:06 +0000
Message-ID: <79be8c4ffb506bbf9fdf3f69ac8f24edacbeaf35.camel@intel.com>
References: <20260123125657.3384063-1-khushit.shah@nutanix.com>
	 <feb11efd6bfbc5e7d5f6f430f40d4df5544f1d39.camel@infradead.org>
	 <aXkyz3IbBOphjNEi@google.com>
	 <ea294969d05fc9c37e72053d7343e11fa9ffdded.camel@infradead.org>
	 <699708d7f3da2e2a41e3282c1a87e6f4d69a4e89.camel@intel.com>
	 <c7eab673dd567936761a8cc6e091a432b38d08da.camel@infradead.org>
	 <62f9bdb9f3c7f55db747a29c292fa632bb6ec749.camel@intel.com>
	 <aXoj6szBMy6BSzYO@google.com>
In-Reply-To: <aXoj6szBMy6BSzYO@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB7423:EE_
x-ms-office365-filtering-correlation-id: b6f41ed7-253a-4530-f7e2-08de5eb19c86
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OG50UzRwV2JmZ3IydkNvdThzelZJdTdScFFQWTRRbEF5ekdLMkNSZXBydzJJ?=
 =?utf-8?B?Wnd1TnBTNHhOay9kZ0p1WG5UYXRXZ0YvN0pET1pyVTl2aVl4WGFYYk82elNr?=
 =?utf-8?B?Tjc4TjJwc3VDVDUxb1g4S2FwSFhYVjNxR1VuVWxrbDlSMzMyK2daZjJlMnNj?=
 =?utf-8?B?cjdvcHFrRWJVQ0JnZUVyVVdLMStWM2pZbUN2WmN6b3dMVWw0RitLZ085V01z?=
 =?utf-8?B?Z0p3R1FPa2ZUZnMwOFpzMEVWMExmZ2xQT1UzN0lFZ0tIUnh1blJPeWZROUhD?=
 =?utf-8?B?SGtJbkkxN0RVanZ1WnpuTDNIRlgrLy84cEovZnZ2SUxyYUxMV0FJRzJSWmFP?=
 =?utf-8?B?MGdlSmhySDhQdzArMFZtbXlzS0NDUXNMbXpTRjgzcTIrZGtvYjlCbnBQZjlE?=
 =?utf-8?B?enhQelZSbTkvaGxUS0lsVFFlMnFkT3BqUjJsWENhTmxKYjcvRHMxVGduUkg0?=
 =?utf-8?B?VnhGekJnVFFZM1lLRWFRWEo0bDNqYmVxVmQvT05NajBtUHlHdjYzMVdVbGtE?=
 =?utf-8?B?aFFnUGxUcGFWYXNrcGw3WFRPTEVyQkFqTmJjYXNFZUJuQ1ZYWkw0TlRaR1NS?=
 =?utf-8?B?MEQ0ZGN6N2FqTjdPYUpuOXFKWHo2TlplSk5wRldhN3kzZncwb3d0a3ROV3hU?=
 =?utf-8?B?aVZOTW1hQWNJNXdmaFo3UGdwRzBaeHRRN0M0b25Rd3dKQ0M1aStjUXNINWts?=
 =?utf-8?B?MVhyVkx2WmVmcXBUVXpxSmlQVTZ0cXFVS0I1VHNPTHYxbTg4bnVYaFRzeSt2?=
 =?utf-8?B?ZmdzcUFRTk8vN0w0VlQ2Qm9RQWdGcUdvbzdic2M3aCtRYWRzUE95dzFFVVFW?=
 =?utf-8?B?QlBQVFNpZnJZOFFhVVIwdWRIRytla0FWYStUT2pGaXFBWnZ5NVhvV2NtSlpy?=
 =?utf-8?B?Q1RKYjBnUEczRjV5QXRQbzJNK3dMekpleU5pMXRubGNtV0JrYzVXYlluS09r?=
 =?utf-8?B?MzNMdGlJcmEyWXMrb1hSOU5NR2dJRzZTV3lFeTdKZkFJNUdzVmNwMUl3VGNY?=
 =?utf-8?B?VUlhRXd4M2xBVTQ0YXAzZy9aYmc3TmFFY1Y1QSt1VDk0MElyNlE2SHFnVHRH?=
 =?utf-8?B?aDE0a1I0dVR5TFVPZ1MzeUZyOFlYaStSNlNJL05Xb2Y4aVVWOTEvVkJ5NEVK?=
 =?utf-8?B?NEZ2cnFlaGZLdDE4MDJjdUx5V1AvMmQrd1pBM2xCcUNWSDgzOWdUZE9meDFC?=
 =?utf-8?B?ZkxUUkE4aGRDelkrUWNMM2xGQTFGVDlKTFdUaXVZdkFOWkYxWTUwTzVnejRH?=
 =?utf-8?B?UXc0cmJPajkvbUJtMlBBM3NZU2JUWG4wdEMxeElOa2F0bU1TNkNLYXBLL1Bh?=
 =?utf-8?B?dzJ6bStFUWRsdHk5Q2RsK0JGNklOVzB3bEZBcWdaaUFQSXp3WXRhbWlNOGRt?=
 =?utf-8?B?Qm8ySEZBaHNVUzd5YUR2bllqMmJFaXBMMXFjU0RCUE8vVlAxenBDNUc4bUY0?=
 =?utf-8?B?cEhZUGZ1WXcvR2p1U0lrUEcyMGpDL0FHWEdINUYvb2dMbk5FUXZrZlA0MXdL?=
 =?utf-8?B?TTQzRVAwaEo2VGNXR0lIbTJHSHRscHJmcXFzUER0QmtBeU9adzF0U25LRFhG?=
 =?utf-8?B?aDUwSmg3dVBtNGhjNlp6NlFCKy85T2lXdUhEMjhEYUoxR2NWc0syMlpseFBu?=
 =?utf-8?B?Q282aEVpRUswNVhZeHdibkpDVnNpb2VoOVEwNmhpaCt3NDVzT0o3dVVqNVQz?=
 =?utf-8?B?RHpzekdZY3RVKzNWSUZsRDdWZUcvNmNuaEdXaFY2SHBRRVBJdGowbGJXcTY4?=
 =?utf-8?B?aGFDNHJVemJwTVhiQWI5MTBMdCt0d2U5SlB5OFZlZXpTZUdDSFJRYmdraE1T?=
 =?utf-8?B?UlpPeWVzSzhIbVEybGl5OTBWbnZneFNaOU5KYUh1NmtFVFJPV0thNEhqWTM1?=
 =?utf-8?B?cHlobFlleUo5czdSbWFoa2poRjk2blNMaVBZZjFkMjNnUHpKQ0JqOGRTaTZX?=
 =?utf-8?B?OWFzSjNUWmhyeGloMXA1b3FoUkZrcXk1L2RFcnFRNzQwcnlhbWlJVWdnOXIz?=
 =?utf-8?B?UXB3amgyYXBxVnVBUlNZMTZoSktYc1Y5QXJ1MGZjeEs5cHl2SmJ3WDlFZmZX?=
 =?utf-8?B?K0JqYlExZHA0SEZEOHlmQmVEMGlpaDZWdi9YTDlUMzI2Smk2OWpNYmQrMEV1?=
 =?utf-8?B?eW5ua2RSczBnelQ3RDNNU1RxNVZSd2d4YTVlZEtPMnZ3UCtUdHhROXBPbld3?=
 =?utf-8?Q?/dMpDfLekcF4jM47TRqbRpU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ck9BNlloVGQ2amtZL3NMdDY4UEY5eTRDdUczWGd6ZFpBbnVvYXp0SDhQVW05?=
 =?utf-8?B?N0VrQ1VNRVF6aDF1WVFNV2pzVDVxZWlRdWNXQzRDcU9PblhzQmpNNG5paVdF?=
 =?utf-8?B?RTFST0lUa0RjSFRtT3RtazhseEtDa3ZxbGhCTnRuWE9xRVdhSnVCbjV2Zmw3?=
 =?utf-8?B?endKUnp1QW9HRWEyUVBnVEY2RnAwZ21iRDgxdHluY2Z5MThGdXdCK05sYVV0?=
 =?utf-8?B?NVZYZGExakdObTdsS28yQlBrOXEwS0JwSGc5RXhDYjRkczk1MUtaZExkd2tR?=
 =?utf-8?B?alpYREJ4R0tlK0dPYXNVdEtrOG1abnpybWhUd2YrZDhia29RMlVDTnpVTjR3?=
 =?utf-8?B?YnhzSzBvR0p3cWdiVjFvMmQ3T3IrektsRkJnTUJKRlZtQ29hV0c4eEhTUnFl?=
 =?utf-8?B?Njg3WkV5V1A4SS9VSENwQnBvRUloRVZ5OFFXOHg5THpGUHpPa2RlQS9pUkZz?=
 =?utf-8?B?SmlMQmt4Z216bTU0T1FpeThBMXcrdEQ2dHhBMEgyL1FabXQySmlOZjZmQ21R?=
 =?utf-8?B?cE9SY01EaVFkbVRoUVJZZndGWVdZSE93RjBGSEtaMmVveVhrYmsySkdRNXpj?=
 =?utf-8?B?K2V1SU1WdUNMcXpiTzBQTDFRbG93RGwyb1lSdkc0WjFmd1JHcG9UcDVOdFE3?=
 =?utf-8?B?cDJiTDZBZVZMdFR2U3dDT2ROV1hlMzlYc2hkZGFZU2N1MDRhMTlPZGI3Tmhv?=
 =?utf-8?B?WklmTjhGMmMwc3BZTHdtb1RKdm5LUkw0cVE4d0sxUGEydHc2eXlZWE5xSFg2?=
 =?utf-8?B?a2dXRFJCUStOTzhUSUgxbTdCRDRaSkVFVHMvQUc0bStnTDYzMVd2UFQ2bXUz?=
 =?utf-8?B?NzMrQUdPanNTdnFuUkdJRFlhY01Ub3YvOEhaUFhwY3o1L3lYalg3a1ZIQlFi?=
 =?utf-8?B?Y2I2WGMxdFowR1dGazErbzExNkQ1QTJzTU4zdGxuaW5VNVN0ZUp1MWtBdlVB?=
 =?utf-8?B?YW54RVR2aWl0bVVDclU3dk1YN040VXo0eGRsKy9LQ2wyWWF4dG90RXpaMWl3?=
 =?utf-8?B?QjhLeXEwWldFYytjaUx6Ulp5OFBFdUl6aWpMWWJlN1dNcHp1cFFYUHUycjdE?=
 =?utf-8?B?cHhQODAxT2NBQTRtQ1ZUYklDUkxTSGVOTEZVaitTN2tDOWJZOVlrQTdDWThm?=
 =?utf-8?B?ZUpJYU9XRnNmcjMxOXgvNVBqL2NsQlZuNWZ4b1k1dkQ5ZG5pY1pRWVFSd1k1?=
 =?utf-8?B?NElIYnkvc05ReWZ6N2ZhWXVKd1dSbE1SZGt3Ky9oK1RtTkFieVFkb3RPcE1j?=
 =?utf-8?B?SHBFbjBiUDBFMUcvekMxU1hoQmZBVDBscXFRa1pnNmM2SFZmSTRJVUJYL0V5?=
 =?utf-8?B?RUIveHdnMi9TODdGdWltOTBoWUVzTlNVald3ODFDNFVjcEpjNldiM2REZDBE?=
 =?utf-8?B?M2FwT0NSM2dHSFJ3UTNoZUJKWUxkQjJPMDNwdDU5YW5ERGZMVFJQdDR2eW9S?=
 =?utf-8?B?NDN0TXhKWENtM00vOHJhUHlWcTdUbDhOSGZtQmdudlZpTTJlVlgraDVycXIx?=
 =?utf-8?B?RVBSamIvU3NnWlVVaXdEYVlQT1ppZXhRNW9BeFp6MVV2WHJJZ1I5dDFtSFZx?=
 =?utf-8?B?MTZPRGJDRkV5c29qTGUrckFRUGh6SytUWHJsbjNZc3N1Qk9TbzRlZVJleUc5?=
 =?utf-8?B?cmpoZFVBbVdVM3hQajVaVUVpUGczSEdKcnEvblJvMC94SzRiSGhHWVlLTFVx?=
 =?utf-8?B?TGx4RGloMFk2eTBYTURLRDFzeXU1QzNISktkK3IvcmhvRnpOWFI0YmdNZmFw?=
 =?utf-8?B?R0N2cXlSRnpLeDhoL2lOYUZFNFNOM1R1a25zQ1cwVDJ5YUJHam41akF3Y3M1?=
 =?utf-8?B?cjdHRTZtdXZWMCtkdXREZnJWUnZPcVdtNzgvWlRRdzJmNjFOZEhLakRqMURJ?=
 =?utf-8?B?ZTFmUEFxc2V4a0hZakV3VWduVkc4elJ1RzAya1pjNmxaZm04OWp3OXMreHJ4?=
 =?utf-8?B?YmN5MGNKa1lRZUtoN0FGbCtLSlIzcDZwYU4xZGd6SDRvV2oxUi9zU2V4anJ6?=
 =?utf-8?B?TUc0T0s3dVRiNEJySEJjNHlsQTdQZ0NyRXZST3d5MnRXNjYzdktPaUZGUkxy?=
 =?utf-8?B?ZFpVeDBZL2xkTUhqL3NIanVBdGt3TzUxblF6b1l3U3ZyRSthL1AxUU9tWE9X?=
 =?utf-8?B?eEtBWGdpNTgvN0N0ODk1UTR1aEhYdTVhNmNhdkpWNmVkRFZZcmhGZ3Jsb2p3?=
 =?utf-8?B?NUYrK0JWUmFCc2hwU2VLeUcxMVNZV0MvTlc2b1pNQUNRQXplU0ozK1VnbEhT?=
 =?utf-8?B?aGFCWC82VGlYNTA5bGFnMHNtWVZBQlFWZFV2MlN1VC85djdYdTdZdnhCWnQ5?=
 =?utf-8?B?RDdyZHd4V0VSVnRpdDRmYjdJZmNzUkFmc0kzRlJlMUt3cFllNzFZdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D23CF408ECBE9A48AE392A79E4ADC6C6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f41ed7-253a-4530-f7e2-08de5eb19c86
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 21:10:06.1336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EJCRvRcyEfKfEl/XCnm8DBV0xhMDx3jkfaIrNRANxdYGg5CkeJ4BbXy5xEPNaOnUbMw8/9/OWVS0gLLFS8xEhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7423
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69417-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: DA6B1A8F70
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDA2OjU3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEphbiAyOCwgMjAyNiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNi0wMS0yNyBhdCAxOTo0OCAtMDgwMCwgRGF2aWQgV29vZGhvdXNlIHdyb3RlOg0KPiA+
ID4gT24gV2VkLCAyMDI2LTAxLTI4IGF0IDAyOjIyICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0K
PiA+ID4gPiDCoA0KPiA+ID4gPiA+IEFoLCBzbyB1c2Vyc3BhY2Ugd2hpY2ggY2hlY2tzIGFsbCB0
aGUga2VybmVsJ3MgY2FwYWJpbGl0aWVzICpmaXJzdCoNCj4gPiA+ID4gPiB3aWxsIG5vdCBzZWUg
S1ZNX1gyQVBJQ19FTkFCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCBhZHZlcnRpc2VkLA0KPiA+
ID4gPiA+IGJlY2F1c2UgaXQgbmVlZHMgdG8gZW5hYmxlIEtWTV9DQVBfU1BMSVRfSVJRQ0hJUCBm
aXJzdD8NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJIGd1ZXNzIHRoYXQncyB0b2xlcmFibGXCuSBi
dXQgdGhlIGRvY3VtZW50YXRpb24gY291bGQgbWFrZSBpdCBjbGVhcmVyLA0KPiA+ID4gPiA+IHBl
cmhhcHM/IEkgY2FuIHNlZSBWTU1zIHNpbGVudGx5IGZhaWxpbmcgdG8gZGV0ZWN0IHRoZSBmZWF0
dXJlIGJlY2F1c2UNCj4gPiA+ID4gPiB0aGV5IGp1c3QgZG9uJ3Qgc2V0IHNwbGl0LWlycWNoaXAg
YmVmb3JlIGNoZWNraW5nIGZvciBpdD8gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gwrkgYWx0aG91Z2ggSSBzdGlsbCBraW5kIG9mIGhhdGUgaXQgYW5kIHdvdWxkIGhhdmUgcHJl
ZmVycmVkIHRvIGhhdmUgdGhlDQo+ID4gPiA+ID4gwqDCoCBJL08gQVBJQyBwYXRjaDsgdXNlcnNw
YWNlIHN0aWxsIGhhcyB0byBpbnRlbnRpb25hbGx5ICplbmFibGUqIHRoYXQNCj4gPiA+ID4gPiDC
oMKgIGNvbWJpbmF0aW9uLiBCdXQgT0ssIEkndmUgcmVsdWN0YW50bHkgY29uY2VkZWQgdGhhdC4N
Cj4gPiA+ID4gDQo+ID4gPiA+IFRvIG1ha2UgaXQgZXZlbiBtb3JlIHJvYnVzdCwgcGVyaGFwcyB3
ZSBjYW4gZ3JhYiBrdm0tPmxvY2sgbXV0ZXggaW4NCj4gPiA+ID4ga3ZtX3ZtX2lvY3RsX2VuYWJs
ZV9jYXAoKSBmb3IgS1ZNX0NBUF9YMkFQSUNfQVBJLCBzbyB0aGF0IGl0IHdvbid0IHJhY2Ugd2l0
aA0KPiA+ID4gPiBLVk1fQ1JFQVRFX0lSUUNISVAgKHdoaWNoIGFscmVhZHkgZ3JhYnMga3ZtLT5s
b2NrKSBhbmQNCj4gPiA+ID4gS1ZNX0NBUF9TUExJVF9JUlFDSElQPw0KPiA+ID4gPiANCj4gPiA+
ID4gRXZlbiBtb3JlLCB3ZSBjYW4gYWRkIGFkZGl0aW9uYWwgY2hlY2sgaW4gS1ZNX0NSRUFURV9J
UlFDSElQIHRvIHJldHVybiAtDQo+ID4gPiA+IEVJTlZBTCB3aGVuIGl0IHNlZXMga3ZtLT5hcmNo
LnN1cHByZXNzX2VvaV9icm9hZGNhc3RfbW9kZSBpcw0KPiA+ID4gPiBLVk1fWDJBUElDX0VOQUJM
RV9TVVBQUkVTU19FT0lfQlJPQURDQVNUPw0KPiA+ID4gDQo+ID4gPiBJZiB3ZSBkbyB0aGF0LCB0
aGVuIHRoZSBxdWVyeSBmb3IgS1ZNX0NBUF9YMkFQSUNfQVBJIGNvdWxkIGFkdmVydGlzZQ0KPiA+
ID4gdGhlIEtWTV9YMkFQSUNfRU5BQkxFX1NVUFBSRVNTX0VPSV9CUk9BRENBU1QgZm9yIGEgZnJl
c2hseSBjcmVhdGVkIEtWTSwNCj4gPiA+IGV2ZW4gYmVmb3JlIHVzZXJzcGFjZSBoYXMgZW5hYmxl
ZCAqZWl0aGVyKiBLVk1fQ1JFQVRFX0lSUUNISVAgbm9yDQo+ID4gPiBLVk1fQ0FQX1NQTElUX0lS
UUNISVA/DQo+ID4gDQo+ID4gTm8gSUlVQyBpdCBkb2Vzbid0IGNoYW5nZSB0aGF0Pw0KPiA+IA0K
PiA+IFRoZSBjaGFuZ2UgSSBtZW50aW9uZWQgYWJvdmUgaXMgb25seSByZWxhdGVkIHRvICJlbmFi
bGUiIHBhcnQsIGJ1dCBub3QNCj4gPiAicXVlcnkiIHBhcnQuDQo+ID4gDQo+ID4gVGhlICJxdWVy
eSIgaXMgZG9uZSB2aWEga3ZtX3ZtX2lvY3RsX2NoZWNrX2V4dGVuc2lvbihLVk1fQ0FQX1gyQVBJ
Q19BUEkpLA0KPiA+IGFuZCBpbiB0aGlzIHBhdGNoLCBpdCBkb2VzOg0KPiA+IA0KPiA+IEBAIC00
OTMxLDYgKzQ5MzMsOCBAQCBpbnQga3ZtX3ZtX2lvY3RsX2NoZWNrX2V4dGVuc2lvbihzdHJ1Y3Qg
a3ZtICprdm0sIGxvbmcNCj4gPiBleHQpDQo+ID4gIAkJYnJlYWs7DQo+ID4gIAljYXNlIEtWTV9D
QVBfWDJBUElDX0FQSToNCj4gPiAgCQlyID0gS1ZNX1gyQVBJQ19BUElfVkFMSURfRkxBR1M7DQo+
ID4gKwkJaWYgKGt2bSAmJiAhaXJxY2hpcF9zcGxpdChrdm0pKQ0KPiA+ICsJCQlyICY9IH5LVk1f
WDJBUElDX0VOQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUOw0KPiA+IA0KPiA+IElJUkMgaWYg
dGhpcyBpcyBjYWxsZWQgYmVmb3JlIEtWTV9DUkVBVEVfSVJRQ0hJUCBhbmQgS1ZNX0NBUF9TUExJ
VF9JUlFDSElQLA0KPiA+IHRoZW4gIWlycWNoaXBfc3BsaXQoKSB3aWxsIGJlIHRydWUsIHNvIGl0
IHdpbGwgTk9UIGFkdmVydGlzZQ0KPiA+IEtWTV9YMkFQSUNfRU5BQkxFX1NVUFBSRVNTX0VPSV9C
Uk9BRENBU1QuDQo+ID4gDQo+ID4gSWYgaXQgaXMgY2FsbGVkIGFmdGVyIEtWTV9DQVBfU1BMSVRf
SVJRQ0hJUCwgdGhlbiBpdCB3aWxsIGFkdmVydGlzZQ0KPiA+IEtWTV9YMkFQSUNfRU5BQkxFX1NV
UFBSRVNTX0VPSV9CUk9BRENBU1QuDQo+IA0KPiBZZXAuICBBbmQgd2hlbiBjYWxsZWQgYXQgc3lz
dGVtLXNjb3BlLCBpLmUuIHdpdGggQGt2bT1OVUxMLCB1c2Vyc3BhY2Ugd2lsbCBzZWUNCj4gdGhl
IG1heGltYWwgc3VwcG9ydCB3aXRoIEtWTV9YMkFQSUNfRU5BQkxFX1NVUFBSRVNTX0VPSV9CUk9B
RENBU1QuDQoNClllcC4NCg0KPiANCj4gPiBCdHcsIGl0IGRvZXNuJ3QgZ3JhYiBrdm0tPmxvY2sg
ZWl0aGVyLCBzbyB0aGVvcmV0aWNhbGx5IGl0IGNvdWxkIHJhY2Ugd2l0aA0KPiA+IEtWTV9DUkVB
VEVfSVJRQ0hJUCBhbmQga3ZtX3ZtX2lvY3RsX2VuYWJsZV9jYXAoS1ZNX0NBUF9TUExJVF9JUlFD
SElQKSB0b28uDQo+IA0KPiBUaGF0J3MgdG90YWxseSBmaW5lLg0KPiANCj4gPiA+IFRoYXQgd291
bGQgYmUgc2xpZ2h0bHkgYmV0dGVyIHRoYW4gdGhlIGV4aXN0aW5nIHByb3Bvc2VkIGF3ZnVsbmVz
cw0KPiA+ID4gd2hlcmUgdGhlIGtlcm5lbCBkb2Vzbid0ICphZG1pdCogdG8gaGF2aW5nIHRoZSBf
RU5BQkxFXyBjYXBhYmlsaXR5DQo+ID4gPiB1bnRpbCB1c2Vyc3BhY2UgZmlyc3QgZW5hYmxlcyB0
aGUgS1ZNX0NBUF9TUExJVF9JUlFDSElQLg0KPiA+IA0KPiA+IFdlIGNvdWxkIGFsc28gbWFrZSBr
dm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKEtWTV9DQVBfWDJBUElDX0FQSSkgdG8NCj4gPiBf
YWx3YXlzXyBhZHZlcnRpc2UgS1ZNX1gyQVBJQ19FTkFCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FT
VCBpZiB0aGF0J3MNCj4gPiBiZXR0ZXIuDQo+IA0KPiBObywgYmVjYXVzZSB0aGVuIHdlJ2QgbmVl
ZCBuZXcgdUFQSSBpZiB3ZSBhZGQgc3VwcG9ydCBmb3IgRU5BQkxFX1NVUFBSRVNTX0VPSV9CUk9B
RENBU1QNCj4gd2l0aCBhbiBpbi1rZXJuZWwgSS9PIEFQSUMuDQoNClRoYXQncyBteSBjb25jZXJu
IHRvbyAod2Fzbid0IHF1aXRlIHN1cmUgYWJvdXQgdGhhdCwgdGhvdWdoKS4NCg0KSSB0aG91Z2h0
IHdlIGNvdWxkIGRvY3VtZW50IGluLWtlcm5lbCBJT0FQSUMgZG9lc24ndCB3b3JrIHdpdGgNCkVO
QUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUIGZvciBub3cgYnV0IHdlIG1heSBzdXBwb3J0IGl0
IGluIHRoZSBmdXR1cmUuDQoNCj4gDQo+ID4gSSBzdXBwb3NlIHdoYXQgd2UgbmVlZCBpcyB0byBk
b2N1bWVudCBzdWNoIGJlaGF2aW91ciAtLSB0aGF0IGFsYmVpdCANCj4gPiBLVk1fWDJBUElDX0VO
QUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUIGlzIGFkdmVydGlzZSBhcyBzdXBwb3NlZCwgYnV0
IGl0DQo+ID4gY2Fubm90IGJlIGVuYWJsZWQgdG9nZXRoZXIgd2l0aCBLVk1fQ1JFQVRFX0lSUUNI
SVAgLS0gb25lIHdpbGwgZmFpbA0KPiA+IGRlcGVuZGluZyBvbiB3aGljaCBpcyBjYWxsZWQgZmly
c3QuDQo+IA0KPiBObywgd2UgZG9uJ3QgbmVlZCB0byBleHBsaWNpdGx5IGRvY3VtZW50IHRoaXMs
IGJlY2F1c2UgaXQncyBzdXBlciBkdXBlciBiYXNpYw0KPiBtdWx0aS10aHJlYWRlZCBwcm9ncmFt
bWluZy4gIEtWTSBvbmx5IG5lZWRzIHRvIGRvY3VtZW50ZWQgdGhhdA0KPiBLVk1fWDJBUElDX0VO
QUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUIHJlcXVpcmVzIGEgVk0gd2l0aCBLVk1fQ0FQX1NQ
TElUX0lSUUNISVAuDQo+IA0KPiA+IEFzIGEgYm9udXMsIGl0IGNhbiBnZXQgcmlkIG9mICJjYWxs
aW5nIGlycWNoaXBfc3BsaXQoKSB3L28gaG9sZGluZyBrdm0tDQo+ID4gPiBsb2NrIiBhd2Z1bG5l
c3MgdG9vLg0KPiANCj4gTm8sIGl0J3Mgbm90IGF3ZnVsbmVzcy4gIEl0J3MgdXNlcnNwYWNlJ3Mg
cmVzcG9uc2liaWxpdHkgdG8gbm90IGJlIHN0dXBpZC4gIEtWTQ0KPiB0YWtpbmcga3ZtLT5sb2Nr
IGNoYW5nZXMgKm5vdGhpbmcqLiDCoA0KPiANCg0KUmlnaHQgaXQgZG9lc24ndCBjaGFuZ2UgYW55
IHJlc3VsdC4NCg0KPiBBbGwgaG9sZGluZyBrdm0tPmxvY2sgZG9lcyBpcyBzZXJpYWxpemUgS1ZN
DQo+IGNvZGUsIGl0IGRvZXNuJ3QgcHJldmVudCBhIHJhY2UuICBJLmUuIGl0IGp1c3QgY2hhbmdl
cyB3aGV0aGVyIHRhc2tzIGFyZSByYWNpbmcNCj4gdG8gYWNxdWlyZSBrdm0tPmxvY2sgdmVyc3Vz
IHJhY2luZyBhZ2FpbnN0IGlycWNoaXBfbW9kZS4NCj4gDQo+IElmIHVzZXJzcGFjZSBpbnZva2Vz
IEtWTV9DQVBfU1BMSVRfSVJRQ0hJUCBhbmQgS1ZNX0VOQUJMRV9DQVAgY29uY3VycmVudGx5IG9u
IHR3bw0KPiBzZXBhcmF0ZSB0YXNrcywgdGhlbiBLVk1fRU5BQkxFX0NBUCB3aWxsIGZhaWwgfjUw
JSBvZiB0aGUgdGltZSByZWdhcmRsZXNzIG9mDQo+IHdoZXRoZXIgb3Igbm90IEtWTSB0YWtlcyBr
dm0tPmxvY2suDQo+IA0KDQpGYWlyIGVub3VnaC4gIFRoYW5rcyBmb3IgdGhlIGNsYXJpZmljYXRp
b24gOi0pDQo=

