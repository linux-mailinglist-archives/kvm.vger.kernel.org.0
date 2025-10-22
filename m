Return-Path: <kvm+bounces-60855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3787BFE3E8
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 23:06:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BF2E3A7D43
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 21:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5730830215A;
	Wed, 22 Oct 2025 21:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZcYED5sM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57FB274B2E;
	Wed, 22 Oct 2025 21:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761167149; cv=fail; b=ShtPVbk6yi/oN4b7UgrNezQ7Kz+UJMg+/6v+auFz/70O4Vi1AMuNeGPi6WovDoetrZitTQVIG/rjbCik7BlXsmkQYsYEaYemMHoc0xvn4eIKWkYCvF4zEpBaA6kXpT/2+spj3iXEiSQSLoHEf0I1wirkLEwpSHtI54hzmn4mCao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761167149; c=relaxed/simple;
	bh=4E/GWWmMd7/oLCFU8LpX6hu5SFZnlQqKCNxkDUI7giM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TVq5CoVootaXutxZRMqwjr0DnpkKOdbIAlVFvRYNxP4gIR+HmRCwKkRw7XgBaskq344aMsQ1rS9fS3ynHa9/MBrP43khoz/FFIUmig4pbh2gBMHuYY3b6jJuC87U3SCxmZMjdEc4YEOZzkJeSJoZoKCjAZk3JXAj/XFuSsl630w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZcYED5sM; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761167146; x=1792703146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4E/GWWmMd7/oLCFU8LpX6hu5SFZnlQqKCNxkDUI7giM=;
  b=ZcYED5sMQK5bgiM43W2Ti8cf83UNog27LzVplbM1gWwknS5EhkpGn3d5
   Iw5/akHZ4wkq1NhM+KHQI5S3uTm+O3DDWC+2wT38pf5xEpIE8Vne7oUvN
   rgR0FCF8wznCyj9+tULSPEE1xfm2ckVfWD+uYwLe/ZSDeovQKa3qV3e5G
   loq+2VYJizXbZt+J8aJd5LrVFQ24lX5L5r2G7aV2FB2gcoovHzzBsTbsS
   lMz7yBYxppFv71m5j4HsKSk9GLEGWVmjC6GIjZDiWHOpvFGE09E7cD3Tg
   6CNpBU2s2i/GBb/s+6IV+Mhea566rnRIpwkdUlkA1coibIKAZOCbkegIw
   A==;
X-CSE-ConnectionGUID: oMDxiaMTR0SFysNDXO+cUA==
X-CSE-MsgGUID: UGObZz6tRcOgatobarsVsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62357940"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="62357940"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 14:05:43 -0700
X-CSE-ConnectionGUID: Dt2wkAsFQTW/LamHgNQOEQ==
X-CSE-MsgGUID: bv56hgPhRIOkX/ITUtAUfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="188016647"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 14:05:43 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 14:05:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 14:05:42 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.39) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 14:05:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XySgt0XATr+Yd8OxzIAnDO3S0nS6a3EIqR4t+uqJbRGfoIRVkBfVe0s1hlTWHmbfaFyR8ZnUd9s+LLFFikC6iLtw/0BVzzPd9TjvQ/bHR2FKIpM7T57vu2nCmGfNFQ7E0n32nT2Pnazxw10R2dndbWwgpS1ZCgEBtR4esCaYvCGrYZVO0oaycNM+0RqRozQx1yRZsjvMPSQq1SSK5OwL37xPG2GkWGxHKHZvqhKC0gmiFPtdoRmMd2s8iorUaUDwy/O8kcravrf7k+Ir+Hh/YDr5iYh6bXBnG5zyOtXU6fk524FjlgJZ9ymYgMkBJKGzzOPIY+6ir8L8KJBQo8nVKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4E/GWWmMd7/oLCFU8LpX6hu5SFZnlQqKCNxkDUI7giM=;
 b=m/e4VCEV23UCfrbyykOK7sij0O96rAkN3R6HAFR588rU2fkR7xW5JutSNh+U854oQd3XLt5O+EnTpS3z8LcPvfraO7A60xqmdrkQ22DcILQK1N7g17+zmLvZiCheTP15/hcJbplxSQZGERQBIYw6InzyH0tDMvDkjPBownn88w3pyBhpy7VryHYXUSDOEVufE1jnXC2OzBxWJUAI/LFSXTKLhbxYqtgndW/xYzmXPPjDKyBkkD6KdENRSm9Kg4WIoXU1ObOIh7maTKda4aS69RFVtQups9f4E/5MNmpEF/Ur1eR9vhZbFXjVAAOJ670iVJ4pa6JOtPLboHOc9kcSUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB5231.namprd11.prod.outlook.com (2603:10b6:5:38a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 21:05:39 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 21:05:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "Reshetova, Elena" <elena.reshetova@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "jgross@suse.com" <jgross@suse.com>,
	"x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Topic: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Index: AQHcG1rj8xzFenegOUSY8voF4LzMlLSrHy0AgAFNloCAAExKAIAA0KGAgAAuMwCAAOV9AIAADV0AgAB61oCAABF0gIAZIU0AgATLuACAAKKSAIABMecA
Date: Wed, 22 Oct 2025 21:05:39 +0000
Message-ID: <56d5fe5268af7d743f4962cfcc48145e6c0d3db5.camel@intel.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
	 <20250901160930.1785244-5-pbonzini@redhat.com>
	 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
	 <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com>
	 <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
	 <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com>
	 <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
	 <DM8PR11MB575071F87791817215355DD8E7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <27d19ea5-d078-405b-a963-91d19b4229c8@suse.com>
	 <5b007887-d475-4970-b01d-008631621192@intel.com>
	 <CAGtprH-WE2_ADCCqm2uCvuDVbx61PRpcqy-+krq13rss2T_OSg@mail.gmail.com>
	 <CAGtprH_sedWE_MYmfp3z3RKY_Viq1GGV4qiA0H5g2g=W9LwiXA@mail.gmail.com>
	 <08d64b6e-64f2-46e3-b9ef-87b731556ee4@intel.com>
	 <CAGtprH860CZk3V_cpYmMz4mWps7mNbttD6=GV-ttkao1FLQ5tg@mail.gmail.com>
In-Reply-To: <CAGtprH860CZk3V_cpYmMz4mWps7mNbttD6=GV-ttkao1FLQ5tg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB5231:EE_
x-ms-office365-filtering-correlation-id: 3498b602-7574-486d-c15d-08de11aec0fc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?enBRT1RjZklEdjZZVTJQQzdaRkl6dlN5bjRPcWZ1YjdPaG1za0d4bHM0Rzdn?=
 =?utf-8?B?dG1FaUg1UzRiSHZDTTJ1MkxDRXpPVXFsRUhRb2VaVVI1RUpkZFBUM2ZsWjdJ?=
 =?utf-8?B?RVZGZXg4dGtONWJKTHZOVkNFUkJVTGxxTVExRERBUitoVkwyeGRsc3owVXcx?=
 =?utf-8?B?WXh6aDhPdWRhME5yOHBmODdYb1duaXhacktLeXl2UmNTUW82ekZabEZxM1FG?=
 =?utf-8?B?U2lCQUxuZGY3YXJOVStDNVVNVE1WSUFkaiswU29BYklrVm1hUTQrVVMwb1k0?=
 =?utf-8?B?VXlkdG5mZFpBejFheWtPZ3ZvUjZUMDQ5MHBGVE5FaVNnR1ZqWFEzWHh2bXNV?=
 =?utf-8?B?N2luTENCbjdYRzB6M2hTRWJuY0YxUGtid2JIa2tCZGJnNXozcEpFN05rS3k2?=
 =?utf-8?B?ZjhVUlFLS3FQM1RyMEd5MXpENGtPT3ArM3lyZmNWMEd2RHBGSVJCUWpWTkIr?=
 =?utf-8?B?ZWoydXFSeXhjbWg4WTBLTHJiTjZzamIyOE4wMHprekQ1ZGhTUmZBaUpEWjk5?=
 =?utf-8?B?Y0FKdmNucVNMWkFSUzlSMFlra1hPSXNpRHlubDQ4VWxJeXoreEVxMXdVRURG?=
 =?utf-8?B?WXN0Wktvc3JmZkU0ZHV2REtjUnhxSXZJVlJad2tQdWVuVGM4NE0zdXRsZ0hj?=
 =?utf-8?B?WmgyQzIwMnlMVzJRTkR0UEZjb20xWmZRVnNYVE9takZtdnZrTnhMa1pOV25a?=
 =?utf-8?B?dGFyNlhHRnNDaVhqLzltMFUvYUlzNkZwcHUzTFpFSXlWdjJiY00wRVppRmJz?=
 =?utf-8?B?YXJMaUc0emNzU3NUNkVsWEkxZTdSYVBxR0FSbVdsRHB4ZmJ6WjB0NExrd0tu?=
 =?utf-8?B?aktQcGZyNm15WnBHUWpHMDBkNlZ2RFBjTE5qR2lmOXhXYWh3d1Y3STNVWklI?=
 =?utf-8?B?Rm9vNlE4SElOWEFjTVZBdis5Tmg5alh0Um5TcVA4dGpoY2t2NG1OUG5sdmd1?=
 =?utf-8?B?R2s2WEhlRTBMY1QzV0VjaVVTYzBRT3JhekZ3ZFd3cXFGY054TFJWa3dXUVQr?=
 =?utf-8?B?UG45T040RmhyWlQxU1hxK2RBRmhFVzhtTVRBbEZFeG9vSmpSalg3NCthbjFk?=
 =?utf-8?B?RUIyTTRraWdHQzRteUllUUsyYll4S2dZeXo5Qms2Rm54QzNGSWZkeVFHbEVs?=
 =?utf-8?B?SXVMTk5tN2x4Wm1qcG1uZFppTnBac3RNZXFuUHVtTmtiUnFyOUZTNXpoTXRK?=
 =?utf-8?B?aTV4Mkh5aUZjTmlGd0xZL3lPSEpBNVF2dzl4UXNUQVZkQUNNdHQxWC9UMm1l?=
 =?utf-8?B?Y1VhSTBrL1lud2hTZ01hZ2lGWnN0OERyYVdGYTVoWWR3Y2pIYjFkTWhqRlpU?=
 =?utf-8?B?Mit5NmNJQXRVcDA0V2ZKTnhrNzgrQUNGVjdjejlpWmNENnlkdTk2Q1J1dlAv?=
 =?utf-8?B?aFJ5SCt4blRiZHFPNndIZCttRWNJd3UzQldXU0t5SHpzVG9jbEIrMExoTTNa?=
 =?utf-8?B?aUMrN2hYT1QvTUdjTHYrYXhBRWJxbWgxTFNWdFRtLzZyOFpBOWNMWis1Z1d6?=
 =?utf-8?B?NTZNbDhFOVBJL25KT0gvMk1BRnlHV1V3VS9UNzhVV1YwTng5TU1SYXJaeWJF?=
 =?utf-8?B?bWtVVkhHS2c3R2lJQUNLaThRYVRkZ0g4djJsN1I2RDhvakhaVHhHdGU0aEh5?=
 =?utf-8?B?MU5sYTFtWFI2Z0t0MnhyTWRZNCt6VFdHN0N3OEwyNmhqV21EUUV4RDhSdU00?=
 =?utf-8?B?WGhNZFFVTFNEWko3ZXRDODhISlY4S1c0eE5JT2gxQTF0N2paa1dqMWJkb0Vl?=
 =?utf-8?B?WlNSUXo1ZDRHclE5T2tFRnEzWGZoOTF0anFiUUtEWEQ4UVVNNnRpQ2IyRENn?=
 =?utf-8?B?TDNoUkNDVEVuK0tLa0t6REl4RXZKZlJHTFIwdUxLMlc0VHFPbmdJODd0SEQy?=
 =?utf-8?B?RWNCZEtmajc3akFTRk1kb292RWJ3V1RodEdHdWtwQWNpMDRidVJ6OXY1OW1n?=
 =?utf-8?B?K1RnTTg5ZForT2hCSmFZU01aczduY0M0cUQrRU00TThpYm5XS1E0aUtBTVg0?=
 =?utf-8?B?bkdJOW9OWjFGN3FpSXRSUFRyYzB0KzVTbGgwZHhWWkhwVGRZYUkzV1Z2cVd0?=
 =?utf-8?B?K3F5TU1wdmFJQ0trNzJNMCtqQldJdzU3OUpaQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enRiVWFXOFRXN0NabENremx3dHhBYTRrNHlvdHFrUEdLM09nVmdFeVUybjlU?=
 =?utf-8?B?T1I2VDdVZit0ZDVQVXhpL2ExZ0tuUkdldFBKbkhZVmQ2TWhHOHpaTlpKSUg1?=
 =?utf-8?B?aldKcTZLYVJYWW44TnVTZHpVY0ptZjMyd2tYYkdnUWl5Mk9oYmlwSE1HNmkx?=
 =?utf-8?B?S1REbUMrRWFWOWI2MU5zejV1WEVzc1BnN1B4dFZmM0JUbGJ4WUVJenNUTk9h?=
 =?utf-8?B?UVN2RjJkQkNYVWVwTVEydGUzdkVESlloRjh1SGYzSzVuT1ZqN3ZnRGZVbXla?=
 =?utf-8?B?bGNBNnNoTjdHendMbEFXUHNCMXJ6eWFReDRCYXNTTHMvTDBGZS9oTDg5K3RL?=
 =?utf-8?B?dGVtRWdkbTdGYVZYZ3NaK1Q5SzIwaFByMlZJQlA5SWorQjVPYmd6RzE4RFI2?=
 =?utf-8?B?dng3RmxDY1lIeUtjYXVVc0ZJRzRtcU1rSlRlWXBZcm1DNktYNGtRZC85NW05?=
 =?utf-8?B?SDFZZVEzSXdjcGxOcHR4VVd0K0ZPbjVUR3RZMTVKemRXYnNaeng0TWhqS2hY?=
 =?utf-8?B?c2ROL0h3b0YvcWY4bm1BbERZNCszMmpJMWY2YTE3V1NXZFVBZjRKZitUSG5B?=
 =?utf-8?B?YkxGNytlZEFCVERFaTM4WlZpTVRUWG8vWVNGUU1jNkZnc0w4enNKa2tTa2Jm?=
 =?utf-8?B?TmJsV0NXYUhMMWJvY2dkQUh3UUVaZjgrQmVRYUJrT0ptR0tGSkRTWVdsc2FL?=
 =?utf-8?B?RmRnNnAyVzl2b1Z5NGZGdXkwaS9HOEpTL0lIVGxkMm1GclA5K0tMelBIZWs0?=
 =?utf-8?B?NjZVV0g1ZmtBSGsvbmM2T1pYbUpyRDhZcTVEK1k5VXZ4dmpvbnFVdFBXTTFT?=
 =?utf-8?B?YXVHakhJN2VPWlNpY1BoTWM5clc1UkxIRGpkRVNTVmtCODUvODZDeUtoa3pl?=
 =?utf-8?B?NUtPTFdNTStpVjdtUk53N01Tdy9JaHpzUGZtQkFWSHpsL3paaXlNUmtMSlV2?=
 =?utf-8?B?cTMwWnlpQlNXWFdOdFB3TFp6bXJQVUNBaEoyM3o2S043VjllWXBNNWEwNEtW?=
 =?utf-8?B?c0tXVitLUkcxcVArb2hvdHEzSHBaRDdmMWdpbG5CYTVyczlDRjlWd3VXVEpz?=
 =?utf-8?B?MGhwVHU1Y2VKMitBYWZiVGUrck81cTNrNjQ2Qnd2b3JPK1VrNk9OTDVjOW1u?=
 =?utf-8?B?eWFMd09UZm1GSEZ5dDFCTUNBK1hwSUIxTHA2OHpLaitJdDk3azVzL3U1WlE0?=
 =?utf-8?B?Y2ViVk56UVlqajR2dFpyRG9aMXAyMkJDZVlLQTQ3TzloanVFczhyOFRNa1dG?=
 =?utf-8?B?NzBGbGlQTXd2TEI4dEJ3Ry9yM1dWOGxLWlRtWWszM2lKbXBWK3FnT3hCQi9h?=
 =?utf-8?B?dm5UVDdvY3hHcEx6UmRYTkxzdjZSNCtEOXU2aFRUWktLL3A5czZ4UFZpNVNx?=
 =?utf-8?B?NElNTGdJTzJsanByQnhRbHYzMEV2SmRLVWNjN2MxaitaVzV5SDlxTXUySXJ2?=
 =?utf-8?B?cE1KTXdNSDg2OUhvRHhsa0NIbGRBdXF1L29tV3V6eXFSMkRuN09QdEYxMW4r?=
 =?utf-8?B?WWhHYmhXS3MzZWI2SkVTUFNIdDl2TTNJZ3diTlpzaUtBN1RjSHBlZCtvc1dv?=
 =?utf-8?B?OEJWSm55S3lTTE01TC90WjQxc2lPcnRmREtDVXV0bTl0Z00xa1huTHpPOGY1?=
 =?utf-8?B?aGtvdytBQXNVSHJQS0VZODI0RjNseEU5ZExCZFFaYlEzMS9CanVXMHpudUtq?=
 =?utf-8?B?empkeCtBRmw1VDNMNmZrQWNudWdoaXBkM3Mwc2lEeWhmZ0ZQTjF6b1p6WVRm?=
 =?utf-8?B?U3R1QTBlOEswY0ZNaXVFWHErd3RVazZlK2FhclB5R0xld3Rnc3EvN2lxMm9E?=
 =?utf-8?B?UjF1V0ExMFFML2tuOE1nbTdNVDlTRzJrK25UYXFSaEw0bFVtbFVvK0trNHo3?=
 =?utf-8?B?UkxabnVFckJjdWJrc1FabFRtcG1MVUhZTWRjSDdvc3BZNjk2ZlVNQVpJWkNR?=
 =?utf-8?B?WDlJemt4VmFpNWlxVlBvQm1IRmlPRjJGS0d1QVRNelhSMFJTWGhkVUtUZGRN?=
 =?utf-8?B?RXZHS0EvZDZkdUNTVjd0djhxTndWRHo1Yk4xYzJLdmJ5VklYK2Jma2VhYzh1?=
 =?utf-8?B?OEUrTTZYazBJVDg5TENFVlRqamFzOEtQamJyeG5pMkplQ1RYblp0OHVMQjB1?=
 =?utf-8?Q?oNiMqVO7tf2ImE/CDFXI3ENXl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A20D23590296104A9B0A57C6CD2CD2D6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3498b602-7574-486d-c15d-08de11aec0fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2025 21:05:39.2767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s5bNaTvxRMAn6nuzEZKuCOhjZsjffKIHPgyVEHhKGQeINFiMR0uIQMW8nnw1KZIGwQz0w3qTmpZfZojfUpXAJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5231
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTEwLTIxIGF0IDE5OjUwIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBPbiBUdWUsIE9jdCAyMSwgMjAyNSBhdCAxMDowOOKAr0FNIERhdmUgSGFuc2VuIDxkYXZl
LmhhbnNlbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIDEwLzE4LzI1IDA4OjU0LCBW
aXNoYWwgQW5uYXB1cnZlIHdyb3RlOg0KPiA+ID4gQ2lyY2xpbmcgYmFuayBvbiB0aGlzIHRvcGlj
LCBJIHdvdWxkIGxpa2UgdG8gaXRlcmF0ZSBhIGZldyBwb2ludHM6DQo+ID4gPiAxKSBHb29nbGUg
aGFzIGJlZW4gcnVubmluZyB3b3JrbG9hZHMgd2l0aCB0aGUgc2VyaWVzIFsxXSBmb3IgfjIgeWVh
cnMNCj4gPiA+IG5vdywgd2UgaGF2ZW4ndCBzZWVuIGFueSBpc3N1ZXMgd2l0aCBrZHVtcCBmdW5j
dGlvbmFsaXR5IGFjcm9zcyBrZXJuZWwNCj4gPiA+IGJ1Z3MsIHJlYWwgaGFyZHdhcmUgaXNzdWVz
LCBwcml2YXRlIG1lbW9yeSBjb3JydXB0aW9uIGV0Yy4NCj4gPiANCj4gPiBHcmVhdCBwb2ludHMg
YW5kIGdyZWF0IGluZm8hDQo+ID4gDQo+ID4gQXMgYSBuZXh0IHN0ZXAsIEknZCBleHBlY3Qgc29t
ZW9uZSAoYXQgR29vZ2xlKSB0byB0YWtlIHRoaXMgaW50bw0KPiA+IGNvbnNpZGVyYXRpb24gYW5k
IHB1dCB0b2dldGhlciBhIHNlcmllcyB0byBoYXZlIHRoZSBrZXJuZWwgY29tcHJlaGVuZA0KPiA+
IHRob3NlIHBvaW50cy4NCj4gDQo+IFRoZW4gaXMgaXQgc2FmZSB0byBzYXkgdGhhdCBJbnRlbCBk
b2Vzbid0IGNvbnNpZGVyOg0KPiAqIEFkZGluZyB0aGUgc3VwcG9ydCB0byBqdXN0IHJlc2V0IFBB
TVQgbWVtb3J5IFsxXSB0byB0aGlzIHNlcmllcyBhbmQNCg0KWW91IG5lZWQgdG8gcmVzZXQgYWxs
IFREWCBwcml2YXRlIG1lbW9yeSBpbmNsdWRpbmcgVERYIGd1ZXN0IHByaXZhdGUNCm1lbW9yeSwg
Uy1FUFQgcGFnZXMgZXRjLCBhbmQgUEFNVC4gIFJlc2V0dGluZyBQQU1UIGFsb25lIHdvbid0IGJl
IGVub3VnaCwNCmFuZCBpcyBwb2ludGxlc3MuDQoNCldoZW4gWzFdIHdhcyBwb3N0ZWQsIEtWTSBU
RFggaGFkbid0IGxhbmRlZCB5ZXQsIHNvIHRoZSBvbmx5IHR5cGUgb2YgVERYDQpwcml2YXRlIG1l
bW9yeSB3YXMgUEFNVCwgYnV0IHRoZXJlJ3MgYWxzbyBhIGJpZyBjb21tZW50IHRoZXJlIHRvIHBv
aW50IG91dA0KdGhlIGluLWtlcm5lbCB1c2VycyBzaG91bGQgYmUgcmVzcG9uc2libGUgZm9yIHJl
c2V0dGluZyBhbnkgVERYIHByaXZhdGUNCm1lbW9yeSB0aGF0IHRoZXkgbWFuYWdlOg0KDQorCS8q
DQorCSAqIEl0J3MgaWRlYWwgdG8gY292ZXIgYWxsIHR5cGVzIG9mIFREWCBwcml2YXRlIHBhZ2Vz
IGhlcmUsIGJ1dA0KKwkgKiBjdXJyZW50bHkgdGhlcmUncyBubyB1bmlmaWVkIHdheSB0byB0ZWxs
IHdoZXRoZXIgYSBnaXZlbiBwYWdlDQorCSAqIGlzIFREWCBwcml2YXRlIHBhZ2Ugb3Igbm90Lg0K
KwkgKg0KKwkgKiBPbmx5IGNvbnZlcnQgUEFNVCBoZXJlLiAgQWxsIGluLWtlcm5lbCBURFggdXNl
cnMgKGUuZy4sIEtWTSkNCisJICogYXJlIHJlc3BvbnNpYmxlIGZvciBjb252ZXJ0aW5nIFREWCBw
cml2YXRlIHBhZ2VzIHRoYXQgYXJlDQorCSAqIG1hbmFnZWQgYnkgdGhlbSBieSBlaXRoZXIgcmVn
aXN0ZXJpbmcgcmVib290IG5vdGlmaWVyIG9yDQorCSAqIHNodXRkb3duIHN5c2NvcmUgb3BzLg0K
KwkgKi8NCisJdGRtcnNfcmVzZXRfcGFtdF9hbGwoJnRkeF90ZG1yX2xpc3QpOw0KDQo+ICogTW9k
aWZ5aW5nIHRoZSBsb2dpYyBpbiB0aGlzIHBhdGNoIFsyXSB0byBlbmFibGUga2R1bXAgYW5kIGtl
ZXAga2V4ZWMNCj4gc3VwcG9ydCBkaXNhYmxlZCBpbiB0aGlzIHNlcmllcw0KDQpSZXNldHRpbmcg
VERYIHByaXZhdGUgaXMgYSBjb21wbGV0ZSBzb2x1dGlvbiB3aGljaCBhbGxvd3MgdG8gZW5hYmxl
IGJvdGgNCmtkdW1wIGFuZCBrZXhlYy4gIElmIHdlIGNob29zZSB0byByZXNldCBURFggcHJpdmF0
ZSBtZW1vcnksIHRoZW4gd2UgY2FuDQpqdXN0IHJldmVydCBbMl0uDQoNCj4gDQo+IGFzIGEgdmlh
YmxlIGRpcmVjdGlvbiB1cHN0cmVhbSBmb3Igbm93IHVudGlsIGEgYmV0dGVyIHNvbHV0aW9uIGNv
bWVzIGFsb25nPw0KDQpUaGUgYWx0ZXJuYXRpdmUgY291bGQgYmUgdG8gc2ltcGx5IG1vZGlmeSBb
Ml0gdG8gYWxsb3cga2R1bXAgKGJ1dCBsZWF2ZQ0KVERYIHByaXZhdGUgbWVtb3J5IHVudG91Y2hl
ZCB0byB0aGUgbmV3IGtlcm5lbCkgYnV0IG5vdCBub3JtYWwga2V4ZWMuICBUaGUNCnJpc2sgb2Yg
ZG9pbmcgc28gaGFzIGFscmVhZHkgYmVlbiBjb3ZlcmVkIGluIHRoaXMgdGhyZWFkIEFGQUlDVDoN
Cg0KIDEpIElmIHRoZSBrZHVtcCBrZXJuZWwgZG9lcyBwYXJ0aWFsIHdyaXRlIHRvIHZtY29yZSwg
dGhlIGtkdW1wIGtlcm5lbCBtYXkNCiAgICBzZWUgdW5leHBlY3RlZCAjTUNFLg0KIDIpIEFzIEVs
ZW5hIHBvaW50ZWQgb3V0LCBpZiB0aGUgb2xkIGtlcm5lbCBoYXMgYnVnIGFuZCBzb21laG93IGFs
cmVhZHkNCiAgICBkb2VzIHBhcnRpYWwgd3JpdGUgdG8gVERYIHByaXZhdGUgbWVtb3J5ICh3aGlj
aCBsZWFkcyB0byBwb2lzb24pLCB0aGUNCiAgICBjb25zdW1wdGlvbiBvZiBzdWNoIHBvaXNvbiBt
YXkgYmUgZGVmZXJyZWQgdG8gdGhlIGtkdW1wIGtlcm5lbC4NCg0KPiANCj4gSWYgbm90LCBjYW4g
a2R1bXAgYmUgbWFkZSBvcHRpb25hbCBhcyBKdWVyZ2VuIHN1Z2dlc3RlZD8NCg0KSUlVQyBKdWVy
Z2VuIHN1Z2dlc3RlZDoNCg0KICBUaGVuIHdlIGNvdWxkIGFkZCBhIGtlcm5lbCBib290IHBhcmFt
ZXRlciB0byBsZXQgdGhlIHVzZXIgb3B0LWluDQogIGZvciBrZXhlYyBiZWluZyBwb3NzaWJsZSBp
biBzcGl0ZSBvZiB0aGUgcG90ZW50aWFsICNNQy4NCg0KSSBkb24ndCBoYXZlIG9waW5pb24gb24g
dGhpcywgb3RoZXIgdGhhbiB0aGF0IEkgdGhpbmsgdGhlIGJvb3QgcGFyYW1ldGVyDQpvbmx5IG1h
a2VzIHNlbnNlIGlmIHdlIGRvIHRoZSAiYWx0ZXJuYXRpdmUiIG1lbnRpb25lZCBhYm92ZSwgaS5l
Liwgbm90DQpyZXNldHRpbmcgVERYIHByaXZhdGUgbWVtb3J5Lg0KDQo+IA0KPiBbMV0gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC82OTYwZWY2ZDdlZTkzOThkMTY0YmYzOTk3ZTYwMDlkZjNl
ODhjYjY3LjE3MjcxNzkyMTQuZ2l0LmthaS5odWFuZ0BpbnRlbC5jb20vDQo+IFsyXSBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNTA5MDExNjA5MzAuMTc4NTI0NC01LXBib256aW5pQHJl
ZGhhdC5jb20vDQo=

