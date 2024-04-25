Return-Path: <kvm+bounces-15900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 347348B1EC6
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 12:07:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 585DC1C20AC0
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 10:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C198665A;
	Thu, 25 Apr 2024 10:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PrHQQOK+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E52485624;
	Thu, 25 Apr 2024 10:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714039531; cv=fail; b=BH/ajev64kBo//25OyDhYawChZZREPa81mbruVqV0ErrPesrzOy1Bgnkyz5x1MYxrigTi3YpjnYIjFVeR8U1ZJoYstQ7JabfXxxZD7xKZ/ywHYvAYKVx8MYQ0HcAKGyTRrvUe/2g3spDmcLjrBGXvM91VDVEzMXnLLlUFS/vGJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714039531; c=relaxed/simple;
	bh=CPZqHU1+u93MTOkoM00iAfd18B9hh/iMjek87t2mtuo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ns/GgUrFId+TTQcYwr0HgJM3VJnjABGJKjtvuTO8+zo9P2Odptr4VjCO3DRRevbkQgM8BilxU9vq0+QrbcTLXFcCilhW0eWmtxXomB0T5j08Lh+gqRgUG50vu/OgB0ypu8n8Etv+VuChkFVPjnUgXMp7od/Xlw+I72PNXHfNDR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PrHQQOK+; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714039529; x=1745575529;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CPZqHU1+u93MTOkoM00iAfd18B9hh/iMjek87t2mtuo=;
  b=PrHQQOK+p8JV0zui5VbzvtsHoaUcKXOHuT4OUC6z3PZMrJTs2y3VnaJo
   9aGB2SY4kCO0ub6/z1OqQ/T+d4IHnI+Z/Wn/z/S0Nln2pH/0zKdx86T6g
   MR02O3FpZGg6tkSgDdzSD/UaaPp16+wT2nRMT0bbPvGET6NkhT/M8G4UA
   YjABAxL1hnrzT9AIxnishMlkXSlm9FO1F5q22qpLNKj/4u1dAo4hoD72y
   dAgV3N7ukR84tpugOr5IpRrodlu8Sc4EUDeLTlyLVrLxQT/81vytIeGPm
   udGrm3pAlHNASEWNIvKqzhB2MbLfgi4Dk1yj4EZDAteECrwAkk+h4h4Rd
   A==;
X-CSE-ConnectionGUID: z/VYG7XKQxacGXusAZbHsg==
X-CSE-MsgGUID: 6VUvAz88SjmQQ4VQDZKoAg==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="13548494"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="13548494"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 03:05:28 -0700
X-CSE-ConnectionGUID: rhz8qrc+S7SDpVQNZJQM5w==
X-CSE-MsgGUID: WRAghiiBTHuIwL0NGp9ARQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="25094439"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 03:05:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 03:05:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 03:05:25 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 03:05:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQW3iyPBxFbFF7vcIrsugJNd4tHdMrJpngb3pqMuK9Q8GrhKsjPyy9aEpzUhUF/QcPDa0heOallMVRlEqYEh/4dwxhssvMc55vOKh3T+Xmc6peMX2TG0g6Dx6u2unqDKONW/PJtYFtwjtb4dM9sU4w+8ip+FaRl7BRAkWDkQ6vAZSm9O82z7QLgjkj4xKcbNqduoJ8o6K0bKnzeU8zBykECgk4JOQ2ZmcbEp7TbAIdFcD0aI4Dd1+FhNKpDMih8LG/0OrkAOQYFAlzRkJ0m77TDTHkPW01bWePtqsg8BHqLwXe9nGuJBKcxc+zXRnDHEUQrsm3N0qVpnsx3nGdQulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPZqHU1+u93MTOkoM00iAfd18B9hh/iMjek87t2mtuo=;
 b=ceekKgjOeKyIO33Gi/b6k/3r3OT2rF7FZXPOWQ/sev0/dnXRjixGMW1TqnyI3M+6lbMWpm0cDAXdPg1zRAXiOk71TEX8hEOLe1Afpt6MX/xIfxkMKsL0wfLLtH3I+2bUJwn0OEYOhTozdGqamprlgrDxJnhjSn6ZQfBQdqx1rpYw23GdMcbIfU0gcY1eH3tTWAOHhsyguv5Pgv9NtiPZcILpYRVdhkXF8qpRk5osMXNtCGmdAe5AJDz4dWxKdfSMU3goT8Y7f+FKJTk87yjIGdvVs3mQeSlDSAsPr0E7mteSuLzTo8icagsVgDqqRIG4+zHzeuIT+g+3Xx9OVcoz0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7306.namprd11.prod.outlook.com (2603:10b6:208:438::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.23; Thu, 25 Apr
 2024 10:05:18 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 10:05:18 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "luto@kernel.org" <luto@kernel.org>, "Li, Xin3" <xin3.li@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"Liu, Zhao1" <zhao1.liu@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate mask
 in its accessor
Thread-Topic: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate
 mask in its accessor
Thread-Index: AQHaccEFvtQhH+vFrkOHoBYSjiDforE4/FIAgAAjwQCAGgLcgIACjaUAgCJxxQCAAOpDgA==
Date: Thu, 25 Apr 2024 10:05:18 +0000
Message-ID: <64cc46778ccc93e28ec8d39b3b4e31842154f382.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-9-seanjc@google.com> <ZfRtSKcXTI/lAQxE@intel.com>
	 <ZfSLRrf1CtJEGZw2@google.com>
	 <1e063b73-0f9a-4956-9634-2552e6e63ee1@intel.com>
	 <ZgyBckwbrijACeB1@google.com> <ZilmVN0gbFlpnHO9@google.com>
In-Reply-To: <ZilmVN0gbFlpnHO9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7306:EE_
x-ms-office365-filtering-correlation-id: 291429af-95ff-45bc-df16-08dc650f35c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?SXJWMnpvbzdsV29zY1ZMRk1KL0RnZExEcnF6UlNWdVlWZ2kwS3ByUnFKNVgv?=
 =?utf-8?B?bXpRcXNkdE94bXhxQlJROENlNGVqaldYcVJtY1R1VnZNa1dVN0pJRTdPWC9B?=
 =?utf-8?B?M1BsNVd3dXY1dm9MMG1SSWdMNCtDdEczQ0VWQ0lBcGlqWFRYTDVLL0htOEl6?=
 =?utf-8?B?L3ZMc1hkSjJURG4vTWIybld4dWpldFZUSzdIbXNSNFRvbkZKNHVPaXViN3hW?=
 =?utf-8?B?cnFDODlVeFJ0QnNuYlVhZW5BcXFjcFBCbkFYOXJ2VGFqSHNwZkRLS0lyR3dJ?=
 =?utf-8?B?L3ZYczJ5ZzJkTWhSaUkxVWczTHJObHYzdHpzWFRIVkZqT3N2TnIzMjdvU3o5?=
 =?utf-8?B?Z21xdnFZcDV6bURMZDZXQnFjZ0VWZmRQbkE3QU50ci9rU0tscmpCbG1nbzl3?=
 =?utf-8?B?Y0tZdzdFU1MvczZFSXd3Z0lMK0tEQ2FGZVArWGFhb1l4SUhmeEV4bExrdFdh?=
 =?utf-8?B?QmJyc21HQWdSVlF1S0E5VUk3R2lnNG1OdkxvL0lPOHhlbzllUWpGNkdiK0kr?=
 =?utf-8?B?ODJKVW05b0FtbURvOG8zOVBYQjlPU0thc3llMHY3b2QxcytzWmNMclhnRDZL?=
 =?utf-8?B?Yzh4VElZb3NENUZyTjlac0lnMlUrNTdzRndoODRiWlR3b1V0RnI5QmJKS1Vq?=
 =?utf-8?B?MlVlNHdmRDQxcUxkdjVwL2NVRHB3U3RnYWt3cDZNYW9KNyttazA1RURabVZ2?=
 =?utf-8?B?djFVeGJXbWhVNnBnTGtCY0JKcng3N09YYStodUM4YU55ZmJ5bkJmU2czQ0d6?=
 =?utf-8?B?dGEzcFRUQUtlSERqcWZMMG1TMVc0dFdsZk02ZHVySVRta3UxV1BGU0dIODhz?=
 =?utf-8?B?VHRoMUhLL0NPOGtSbVQzR2NtOEQwNUhZUVU1SDRsUHBMcldQUkZUdnp3SnFB?=
 =?utf-8?B?M3NsZlpveEJRNnBRYWIyQzlzMUNVT001V0NjOFNaeHQ0N3g2VHlob1RFaE9k?=
 =?utf-8?B?ZlM1Q2pVelU4RXVXckdrTGJsOGErYW1qNUYxbHVqc1NzbGo5WExmVDRkam1I?=
 =?utf-8?B?MmFjZk5lVWFSamhCb003dkE1NlZ2VDFpdXhtZU5sODZRU1ZDMkY5aEVhckh2?=
 =?utf-8?B?TlR4T3k5NWRBc1pNeXE2TjRxY2V3em13cjFsK1BwMTJLS1FCcnVyUGg2b2pr?=
 =?utf-8?B?YzMwbEJnalhVR1VkUGlXOWNsWDNvaWt6VFdjOG5aZldoeXcvaWl0ZUtJdkhT?=
 =?utf-8?B?RGZtKzUvTW54UHkxYnUzMTdBNVZnMHhBZVZ5NXpTMHFmdW5FVGdsM1BtYUx1?=
 =?utf-8?B?OHZiZTJlWlQ2c3VDaHlUN1dFSlBRUUgzb3NNWGl2SUswbjMwcmxBV1NTd1Rp?=
 =?utf-8?B?UzBMQy9xNW05UFZOUU5RZi9FdWpGVWhsVWgyU0xpSkY2WnF2ZWNYSmNETVMv?=
 =?utf-8?B?K3JCbDNmU0FScDFzbnBvdWo3U2RoVWV3UFRUNGNyLy8vbjZLSkFwcHNrbU91?=
 =?utf-8?B?YlBhbW5Rd2tHdnB0UTdpMGNCTXppYS9DdlI3enJlVFJtajUzaSttN0VOVHQy?=
 =?utf-8?B?T2ppZFo2bDZNN2krYmx0MDV6ZHJudTQ4OTg4VlVUZFN1V2dVRTZWdXpHd040?=
 =?utf-8?B?VURMMWZPbWxiNTFGcCtkT3h2UGRYWmtTd3pPMW5UOFRJMDBrM0xZSk5JS0tC?=
 =?utf-8?B?VTJseGYzOVY3bU1VSzNCL0YwWVFsbGYvdTE2TU8rcE82OWEyemRzUWM4dHR5?=
 =?utf-8?B?dkxBa094NjlDSGtFVDQrSUIrNktZVkZsTFJsVEtHbDYwNWltcFV0UUpnbU55?=
 =?utf-8?B?K01NaGRKTW5wWWJvSTVvMCtvZno3S05vRkdyMlkxZittN2p5dTc0NU0rRENH?=
 =?utf-8?B?RS90ai9ROEFEYzJ4Zk5tZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFo4N3IzNlFWcFVvSVk2QUE1eUdkYmNvTTVEOENpbm5pZnIrMTdaQkc1MXhx?=
 =?utf-8?B?ODdPcllTVjFCbFRQcUtoc25RdzFRWWNmL01oZERRZ2d3K0o0aEo1MW4rNy9s?=
 =?utf-8?B?NEdUc3VZbFl6UmdhaWtjRm1RWEJjUE9vMXlkU2FyRG5URHZTK1dMZ0c0bFNm?=
 =?utf-8?B?a09KSEVNRzhlajd6UkRTN3JvTGRHdFg4dmozU2hGNzU0WnduVkVjaXlERlk4?=
 =?utf-8?B?TE9ISVRITUNwcE1nU1hXQURpSDZZck9OcVkxUmlZQVdFSGZXUkVRRXNjbFRz?=
 =?utf-8?B?aDZGbDVSSHRhWGczc2hXcUFNeHdIRldtYWZMMktOZElUUjVuMDBKVEdITFVM?=
 =?utf-8?B?ZHgzaFIvc2hUbDMvU091cGJMRFUveTVrZmZKb2lBNTdyWjFtTitncGFHOTVX?=
 =?utf-8?B?R1NJcUhmaytoMEhaajJFNmFEMjBENUVwMER1M3U3Q3NkTTk2Tms1eWZ3ZUIw?=
 =?utf-8?B?bDZDeUhrbE9MdGZWelBUcW92djNaVFFxRFJSTUhCNWZtWDhvOUMzbWs1RVlR?=
 =?utf-8?B?aWhrNllkaURIbDRJN215bzZUR3FIU3IxVmdnUGxmZjRnZkQ0ZEx5YlAzL3Jh?=
 =?utf-8?B?Vk5POUQvYmp0cjl0VUlHVHlQS2RpaWRXNGZ5YXZ5NWRBUEVYamJWYjNraEJi?=
 =?utf-8?B?TWN6SGVpZHEwSUI1cTRZRWpxemxselM4b0xJSUtsMEFQNmVSQWw3OGV0ZWNJ?=
 =?utf-8?B?N3h3aTV2YnNYWGZrMHE4Sm4xS1NkWU1CRzBBME1xcXJPK2gyck9FTkVOZjll?=
 =?utf-8?B?dFpoMlpZMVhka243bmhVNUtyUmUrK05XcXpsRG93dThmcHVVK2hXWEUvcy9o?=
 =?utf-8?B?QmlMNnhCNFBRN2d6N2p4RDlic0hXNXphWlZaOERDSmVyU2ZnSVNKYnVmbThh?=
 =?utf-8?B?WWkwajArendBclBaajVtRVpOQnNsaGg2aCtYNFpmeVVqMXRiUCt0T204Uklt?=
 =?utf-8?B?L2FxSzZ5MURpYndiTXoxU1dlcGZ4RW5FdWcvSEhBZFoxNkg2bEYwUDVzamdV?=
 =?utf-8?B?L0hRVitRV1JFWFVoTThyK2pleG9tMktPMmZXb3pDWFpKN3dkeExEZEpHZGRF?=
 =?utf-8?B?a2RYN3NJTjJsOW1UVjhoNlY5MEU1ZUtFV2VHaHpCekNQMXdSeFVxcXRpKzYz?=
 =?utf-8?B?WElKRXd5OHZrb3JZZGhyZkppMlhEYmJzMlJTSTEvUDk5UFRaNi95eHVNSTRr?=
 =?utf-8?B?SXp5dkJUWk5NSlVmOWtESmRwOVMramdyTVVLUnNUa2F0UVVMbTJuemVEaWwv?=
 =?utf-8?B?YTNmL3B0bUVtNng4VWVCUkhzcndBcGdhbkxtMVJBaGZqZzdkRUpZR2lwWnN0?=
 =?utf-8?B?SWJvaEJkdGVodnJRNTAvSFp5NTRLRnU5SmhRWVplbFBqL3dIc3ppQ0FTQVE3?=
 =?utf-8?B?VjcrcEtUbzhzclBGRVJpQjIreGp2eHdOL0ZzUnBkcWZWSWFwRzlrVWtnSzlG?=
 =?utf-8?B?Ylh2eXk3NXdCajVkdlRiQS9NVHZDdFZyZGsyNGkwR0IzNThzVzhsVmovUXlm?=
 =?utf-8?B?Y3JNR3RCcVR2bkhkZlpVckI1TjQ3eDJHT0U5aTIrOTFyN0o4TFpLekhzUWpM?=
 =?utf-8?B?OXdRMVU1UEtTanFoOGM1YStsQ2dyeUdpN0crQ0JUdDAvSUs2RmhKVnhIakNB?=
 =?utf-8?B?L2E1MmlVUy9nQWUyTlovQ05oaVBOUnNGVVMrbDRGUXlrMXlHMmtYZjhNdnNk?=
 =?utf-8?B?Q0w0L01zQmxKNEphYTZmZFJKYzd3alVZaW9UMFE4RjdtcG80MVBsbVlOelMv?=
 =?utf-8?B?LzJVbTRQQXZxMW90VkJlWTBTMW9sSFMvcmxIRzYrUFVSY3BwdXluaCtRWjJR?=
 =?utf-8?B?czYrM3dqTHNFU01NUzdSSFN6dm5RcTdCTDZWaFF5QmxQVkZWZFRRdHAxVDhD?=
 =?utf-8?B?NTd0ZFRuTDFZaGphZDNKNytkc1g3Mm5xUW5LSk1VQUFvdHdqOWtLOTRsZVZx?=
 =?utf-8?B?MTA0RW91cytUUnl1T0YwbEZGZVYwcFhaMStVRzdkNUdkT2JMNTNJTkhwRVB1?=
 =?utf-8?B?eWRhbE4xUlRIWW5GQmlHWUx5dHpxRHUwRHgxczRWQXRvdGo1R285WUNZL0VF?=
 =?utf-8?B?Njk1NEtWUFpONmxpSjN2Szh0eWpZT2R4bm5heFBtOVFOeTlLeWRxMjBxVUds?=
 =?utf-8?Q?mYYTIhp5hA4D0CxIthJMmITk0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5BDA7D44813A04E8E76D376623030E8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 291429af-95ff-45bc-df16-08dc650f35c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 10:05:18.0248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hXAFnuuqBP5LZ2zD5LBSxQ0rjKrVowesz/VGhNsI2Zqj+StYzUNfZxeu6nNPvJr1vj8/NQoia2Pix5s72mjlSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7306
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTI0IGF0IDEzOjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEFwciAwMiwgMjAyNCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiBPbiBNb24sIEFwciAwMSwgMjAyNCwgWGlhb3lhbyBMaSB3cm90ZToNCj4gPiA+IE9uIDMv
MTYvMjAyNCAxOjU0IEFNLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+ID4gPiBPbiBG
cmksIE1hciAxNSwgMjAyNCwgWmhhbyBMaXUgd3JvdGU6DQo+ID4gPiA+ID4gT24gRnJpLCBNYXIg
MDgsIDIwMjQgYXQgMDU6Mjc6MjRQTSAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+ID4gPiA+IFVzZSB2bXhfbWlzY19wcmVlbXB0aW9uX3RpbWVyX3JhdGUoKSB0byBnZXQg
dGhlIHJhdGUgaW4gaGFyZHdhcmVfc2V0dXAoKSwNCj4gPiA+ID4gPiA+IGFuZCBvcGVuIGNvZGUg
dGhlIHJhdGUncyBiaXRtYXNrIGluIHZteF9taXNjX3ByZWVtcHRpb25fdGltZXJfcmF0ZSgpIHNv
DQo+ID4gPiA+ID4gPiB0aGF0IHRoZSBmdW5jdGlvbiBsb29rcyBsaWtlIGFsbCB0aGUgaGVscGVy
cyB0aGF0IGdyYWIgdmFsdWVzIGZyb20NCj4gPiA+ID4gPiA+IFZNWF9CQVNJQyBhbmQgVk1YX01J
U0MgTVNSIHZhbHVlcy4NCj4gPiA+ID4gDQo+ID4gPiA+IC4uLg0KPiA+ID4gPiANCj4gPiA+ID4g
PiA+IC0jZGVmaW5lIFZNWF9NSVNDX1BSRUVNUFRJT05fVElNRVJfUkFURV9NQVNLCUdFTk1BU0tf
VUxMKDQsIDApDQo+ID4gPiA+ID4gPiAgICNkZWZpbmUgVk1YX01JU0NfU0FWRV9FRkVSX0xNQQkJ
CUJJVF9VTEwoNSkNCj4gPiA+ID4gPiA+ICAgI2RlZmluZSBWTVhfTUlTQ19BQ1RJVklUWV9ITFQJ
CQlCSVRfVUxMKDYpDQo+ID4gPiA+ID4gPiAgICNkZWZpbmUgVk1YX01JU0NfQUNUSVZJVFlfU0hV
VERPV04JCUJJVF9VTEwoNykNCj4gPiA+ID4gPiA+IEBAIC0xNjIsNyArMTYxLDcgQEAgc3RhdGlj
IGlubGluZSB1MzIgdm14X2Jhc2ljX3ZtY3NfbWVtX3R5cGUodTY0IHZteF9iYXNpYykNCj4gPiA+
ID4gPiA+ICAgc3RhdGljIGlubGluZSBpbnQgdm14X21pc2NfcHJlZW1wdGlvbl90aW1lcl9yYXRl
KHU2NCB2bXhfbWlzYykNCj4gPiA+ID4gPiA+ICAgew0KPiA+ID4gPiA+ID4gLQlyZXR1cm4gdm14
X21pc2MgJiBWTVhfTUlTQ19QUkVFTVBUSU9OX1RJTUVSX1JBVEVfTUFTSzsNCj4gPiA+ID4gPiA+
ICsJcmV0dXJuIHZteF9taXNjICYgR0VOTUFTS19VTEwoNCwgMCk7DQo+ID4gPiA+ID4gPiAgIH0N
Cj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJIGZlZWwga2VlcGluZyBWTVhfTUlTQ19QUkVFTVBUSU9O
X1RJTUVSX1JBVEVfTUFTSyBpcyBjbGVhcmVyIHRoYW4NCj4gPiA+ID4gPiBHRU5NQVNLX1VMTCg0
LCAwKSwgYW5kIHRoZSBmb3JtZXIgaW1wcm92ZXMgY29kZSByZWFkYWJpbGl0eS4NCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiBNYXkgbm90IG5lZWQgdG8gZHJvcCBWTVhfTUlTQ19QUkVFTVBUSU9OX1RJ
TUVSX1JBVEVfTUFTSz8NCj4gPiA+ID4gDQo+ID4gPiA+IEkgZG9uJ3QgbmVjZXNzYXJpbHkgZGlz
YWdyZWUsIGJ1dCBpbiB0aGlzIGNhc2UgSSB2YWx1ZSBjb25zaXN0ZW5jeSBvdmVyIG9uZQ0KPiA+
ID4gPiBpbmRpdmlkdWFsIGNhc2UuICBBcyBjYWxsZWQgb3V0IGluIHRoZSBjaGFuZ2Vsb2csIHRo
ZSBtb3RpdmF0aW9uIGlzIHRvIG1ha2UNCj4gPiA+ID4gdm14X21pc2NfcHJlZW1wdGlvbl90aW1l
cl9yYXRlKCkgbG9vayBsaWtlIGFsbCB0aGUgc3Vycm91bmRpbmcgaGVscGVycy4NCj4gPiA+ID4g
DQo+ID4gPiA+IF9JZl8gd2Ugd2FudCB0byBwcmVzZXJ2ZSB0aGUgbWFzaywgdGhlbiB3ZSBzaG91
bGQgYWRkICNkZWZpbmVzIGZvciB2bXhfbWlzY19jcjNfY291bnQoKSwNCj4gPiA+ID4gdm14X21p
c2NfbWF4X21zcigpLCBldGMuDQo+ID4gPiA+IA0KPiA+ID4gPiBJIGRvbid0IGhhdmUgYSBzdXBl
ciBzdHJvbmcgcHJlZmVyZW5jZSwgdGhvdWdoIEkgdGhpbmsgbXkgdm90ZSB3b3VsZCBiZSB0byBu
b3QNCj4gPiA+ID4gYWRkIHRoZSBtYXNrcyBhbmQgZ28gd2l0aCB0aGlzIHBhdGNoLiAgVGhlc2Ug
aGVscGVycyBhcmUgaW50ZW5kZWQgdG8gYmUgdGhlIF9vbmx5Xw0KPiA+ID4gPiB3YXkgdG8gYWNj
ZXNzIHRoZSBmaWVsZHMsIGkuZS4gdGhleSBlZmZlY3RpdmVseSBfYXJlXyB0aGUgbWFzayBtYWNy
b3MsIGp1c3QgaW4NCj4gPiA+ID4gZnVuY3Rpb24gZm9ybS4NCj4gPiA+ID4gDQo+ID4gPiANCj4g
PiA+ICsxLg0KPiA+ID4gDQo+ID4gPiBIb3dldmVyLCBpdCBzZWVtcyBkaWZmZXJlbnQgZm9yIHZt
eF9iYXNpY192bWNzX21lbV90eXBlKCkgaW4gcGF0Y2ggNSwgdGhhdCBJDQo+ID4gPiBqdXN0IHJl
Y29tbWVuZGVkIHRvIGRlZmluZSB0aGUgTUFTSy4NCj4gPiA+IA0KPiA+ID4gQmVjYXVzZSB3ZSBh
bHJlYWR5IGhhdmUNCj4gPiA+IA0KPiA+ID4gCSNkZWZpbmUgVk1YX0JBU0lDX01FTV9UWVBFX1NI
SUZUCTUwDQo+ID4gPiANCj4gPiA+IGFuZCBpdCBoYXMgYmVlbiB1c2VkIGluIHZteC9uZXN0ZWQu
YywNCj4gPiA+IA0KPiA+ID4gc3RhdGljIGlubGluZSB1MzIgdm14X2Jhc2ljX3ZtY3NfbWVtX3R5
cGUodTY0IHZteF9iYXNpYykNCj4gPiA+IHsNCj4gPiA+IAlyZXR1cm4gKHZteF9iYXNpYyAmIEdF
Tk1BU0tfVUxMKDUzLCA1MCkpID4+DQo+ID4gPiAJCVZNWF9CQVNJQ19NRU1fVFlQRV9TSElGVDsN
Cj4gPiA+IH0NCj4gPiA+IA0KPiA+ID4gbG9va3Mgbm90IGludHVpdGl2ZSB0aGFuIG9yaWdpbmFs
IHBhdGNoLg0KPiA+IA0KPiA+IFllYWgsIGFncmVlZCwgdGhhdCdzIHRha2luZyB0aGUgd29yc3Qg
b2YgYm90aCB3b3JsZHMuICBJJ2xsIHVwZGF0ZSBwYXRjaCA1IHRvIGRyb3ANCj4gPiBWTVhfQkFT
SUNfTUVNX1RZUEVfU0hJRlQgd2hlbiBlZmZlY3RpdmVseSAibW92aW5nIiBpdCBpbnRvIHZteF9i
YXNpY192bWNzX21lbV90eXBlKCkuDQo+IA0KPiBEcmF0LiAgRmluYWxseSBnZXR0aW5nIGJhY2sg
dG8gdGhpcywgZHJvcHBpbmcgVk1YX0JBU0lDX01FTV9UWVBFX1NISUZUIGRvZXNuJ3QNCj4gd29y
ayBiZWNhdXNlIGl0J3MgdXNlZCBieSBuZXN0ZWRfdm14X3NldHVwX2Jhc2ljKCksIGFzIGlzIFZN
WF9CQVNJQ19WTUNTX1NJWkVfU0hJRlQsDQo+IHdoaWNoIGlzIHByZXN1bWFibHkgd2h5IHBhc3Qg
bWUga2VwdCB0aGVtIGFyb3VuZC4NCj4gDQo+IEknbSBsZWFuaW5nIHRvd2FyZHMga2VlcGluZyB0
aGluZ3MgYXMgcHJvcG9zZWQgaW4gdGhpcyBzZXJpZXMuICBJIGRvbid0IHNlZSB1cw0KPiBnYWlu
aW5nIGEgdGhpcmQgY29weSwgb3IgZXZlbiBhIHRoaXJkIHVzZXIsIGkuZS4gSSBkb24ndCB0aGlu
ayB3ZSBhcmUgY3JlYXRpbmcgYQ0KPiBmdXR1cmUgcHJvYmxlbSBieSBvcGVuIGNvZGluZyB0aGUg
c2hpZnQgaW4gdm14X2Jhc2ljX3ZtY3NfbWVtX3R5cGUoKS4gIEFuZCBJTU8NCj4gY29kZSBsaWtl
IHRoaXMNCj4gDQo+IAlyZXR1cm4gKHZteF9iYXNpYyAmIFZNWF9CQVNJQ19NRU1fVFlQRV9NQVNL
KSA+Pg0KPiAJICAgICAgIFZNWF9CQVNJQ19NRU1fVFlQRV9TSElGVDsNCj4gDQo+IGlzIGFuIHVu
bmVjZXNzYXJ5IG9iZnVzY2F0aW9uIHdoZW4gdGhlcmUgaXMgbGl0ZXJhbGx5IG9uZSB1c2VyICh0
aGUgYWNjZXNzb3IpLg0KPiANCj4gQW5vdGhlciBpZGVhIHdvdWxkIGJlIHRvIGRlbGV0ZSBWTVhf
QkFTSUNfTUVNX1RZUEVfU0hJRlQgYW5kIFZNWF9CQVNJQ19WTUNTX1NJWkVfU0hJRlQsDQo+IGFu
ZCBlaXRoZXIgb3BlbiBjb2RlIHRoZSB2YWx1ZXMgb3IgdXNlIGxvY2FsIGNvbnN0IHZhcmlhYmxl
cywgYnV0IHRoYXQgYWxzbyBzZWVtcw0KPiBsaWtlIGEgbmV0IG5lZ2F0aXZlLCBlLmcuIHNwbGl0
cyB0aGUgZWZmZWN0aXZlIGRlZmluaXRpb25zIG92ZXIgdG9vIG1hbnkgbG9jYXRpb25zLg0KDQpB
bHRlcm5hdGl2ZWx5LCB3ZSBjYW4gYWRkIG1hY3JvcyBsaWtlIGJlbG93IHRvIDxhc20vdm14Lmg+
IGNsb3NlIHRvDQp2bXhfYmFzaWNfdm1jc19zaXplKCkgZXRjLCBzbyBpdCdzIHN0cmFpZ2h0Zm9y
d2FyZCB0byBzZWUuDQoNCisjZGVmaW5lIFZNWF9CU0FJQ19WTUNTMTJfU0laRQkoKHU2NClWTUNT
MTJfU0laRSA8PCAzMikNCisjZGVmaW5lIFZNWF9CQVNJQ19NRU1fVFlQRV9XQgkoTUVNX1RZUEVf
V0IgPDwgNTApDQo=

