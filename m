Return-Path: <kvm+bounces-15782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 955018B07A9
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 12:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1EDAB21B3A
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 10:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74A41598EA;
	Wed, 24 Apr 2024 10:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R4XlhGEv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E058159590;
	Wed, 24 Apr 2024 10:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713955867; cv=fail; b=mXSLQ+SousgtOOxotJBRabJmHJ7+yPeplfQ68IKIVD3jExk+wN5gMXfAjEUM7XGb9HEG/Hjl8iBlJVHoH9Ha0BMsQl15FkYIJ8X5GnPYFezS92njQY6fYZ1BouuR3dfU27LNywwoFg6NB6N/H3MJ84ZxOqWfVZOtKNftjl+tqxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713955867; c=relaxed/simple;
	bh=UhezZp4iv13s+wJWQvpT+4v8pvRG/cC5nEz7CWBQChE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QTXskfkOb6QFjTP+A8xKk56/+IlAqYFweQ9Uk+s98z9l/3Udhb1H3bjQXT4s7N8bSzVGVxFkaU8wLi7DlquOVkNsGnX5a4mKIylZptg2E7U97GSQFWX1rEzBeb1gI0dHJgzRGnOGzyo9WG3mI/MPlC2dg+4j6aijqtCFGbTi0hU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R4XlhGEv; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713955866; x=1745491866;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UhezZp4iv13s+wJWQvpT+4v8pvRG/cC5nEz7CWBQChE=;
  b=R4XlhGEvGQcrGJqLCews8lJa4FJ8bXvix0yJ2CMYUkqahmJmaEt5/wy+
   70mh3jOTxn7x4PGx4BRZlwdaBH7o1nNM0UyLuLluKl3z3RP5TO17bXJ9S
   wvJHZ7AvXUF4EK2709zFAXGBNrIQLYv7hwVhYNp0cveMVANBreYnR19gb
   GI6UPNljAUjUs3zpbpASb27qdmms/vJCw0jJ3TRF9Y/alreBbeTx+a5V9
   m/C1PlqQB1pRxg78PF4UsjvIXoeWbWByHBLfEPYHlUomLAqwnr167yss/
   FTb1mB84RaWSWoj7zn+QQpOdnPTJL+q1Gw3B6cUQg5NgBP4lPpf4mPbVM
   A==;
X-CSE-ConnectionGUID: YDlr98OMTFOgQnDyxG70LA==
X-CSE-MsgGUID: U9o7DTqLTFuSpEYl0hrTPA==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="13414775"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="13414775"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 03:51:05 -0700
X-CSE-ConnectionGUID: 89pfuJzvSy+vKf7FRSYdZg==
X-CSE-MsgGUID: O7zM9h31QROJBpxK7gjs4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="29330326"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Apr 2024 03:51:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 03:51:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Apr 2024 03:51:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 03:51:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOEdVFT5Iwr+1mBCMlXcZSySLid7kD0nDZ96TNyHrta1RZ8mcgRUpHDbt7tXOVGQSVgOOoDPX/h1dyonl0xhTpEcBQBbuMmtiTmZQLW/cstfhB/TQgOT88VGNQMEXHVe0GeFakqiyXlw9uhWJGd8H9JR1h0Td4dhTkgQ7UXpOXveIBp3pMs0hbYGJlC0cFn9fZlAF7OANH8PiEJMnWoqXJkD2tqkGJSz5zrXDIQe+Anaeuw+5WlDDApPfu5/iAbMn9Qyz2iVvA48W8mjtYct+gLq72XqUvL5BnXeW2mXIyVZ2JwS5823SU2y+Cr2lXN+kEJcrt5brgrVPk7hxG/IZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UhezZp4iv13s+wJWQvpT+4v8pvRG/cC5nEz7CWBQChE=;
 b=ZO7RHhAEjaoE+vjLc5afxUA0LaBcQeXOXqdQpMdmC4VzhsgbR1PXEDCFhHxR9dpRrTF0z1R9mvAtLtmIskxByQOmZnNH9CaMMWngGwZqqmfHM0PySNrS5D+5YmdvSqn29YqEWFpDqmIBcElov5Wk8dYiY++xtgAT9I7MC24HqahDXtSDuGuyROIk2TBIEL7i9xVGmAybIdYJ6e7eJInQ+UdPEjLWvCLb6RhdPcYstCvwFQtZ8I3whu7qEqKB9g9PPailQNLeUQgdIBFHNrmva1DwXoNOWJf8AbxbGrPLwQHKBWdGlTiI0qHIgB27BAuPf2CMqwIfR2CfbZjq2OFGeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7490.namprd11.prod.outlook.com (2603:10b6:806:346::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Wed, 24 Apr
 2024 10:50:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 10:50:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Yao,
 Yuan" <yuan.yao@intel.com>
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Topic: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Index: AQHaaI25sKFXSTHmB0GBadO6nsPCe7F3mXKA
Date: Wed, 24 Apr 2024 10:50:55 +0000
Message-ID: <a79bd3c9d49dd5e24f4dd36c2942b50dbe1099e2.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7490:EE_
x-ms-office365-filtering-correlation-id: 837f53aa-6e73-48ee-87ce-08dc644c6b49
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?b0gvZGd3V3IwRHhVYnRJQW94QUsyQ1BuaHFLakNkMnpoT2JZcVFVZEFXUmRa?=
 =?utf-8?B?czNnS0JwQjZRTC9DUHhxZndlaHRkWnR6dW9KREMyNWlVY2lHcmQ4cFBacXNV?=
 =?utf-8?B?eFlYc2tNOThCZTR2b2Z0OTRzRlZJeGpmSEJ4b0dIRmdmNHU5VEhnS2NBa3ow?=
 =?utf-8?B?NHN0c2trc3JTeUVBcDBEQWxLa0tjeURwNCs4ZVZSRnNpM3RmNDhJeWFlQUJi?=
 =?utf-8?B?TUdBUVN5bUpkdXM2Z2JtMnpnQVZkSHpyL1NsMUFldy9YSWJBZ0FKYnh1NnVL?=
 =?utf-8?B?SWY3VGpNWXNiY0NaaGNIMlFRZWM0NU5kTjlrYmh4TU1kNGFTVk92dG1BbGww?=
 =?utf-8?B?T3A5Wmg3NERnT3BwTld0SzJSR2R2SGtZT0NoblBYSVlpRFdkMFBrZlJENjQr?=
 =?utf-8?B?Q1NRRFdLRW00YVBzeE8xVTBUV2hhQmN6NmkrS0tXUlRpTHNWOUJ4Ukp5ZGV3?=
 =?utf-8?B?RCt1NUp3UFdMRnVPQlZvTTBZWGhXQ3M4TTZwd21BcFVISEtmNXlhdkplYTI4?=
 =?utf-8?B?L1dOU2pzZkpjeHNCdjFGRm5CK21nOUs0ZU55aGZuU3NENXF1KzQ5MmRHUUNz?=
 =?utf-8?B?NDFHM0luUjhmSmFaTzdrbVBmUlg1T2VVN2tnYW4wZ2tMWVpnejQybzFhaHp1?=
 =?utf-8?B?Z25Kbi9jR3RJTGZYZ1FWZ2VwUiswTk56Q2pPTXdENnFWWlFEQjRMcmdoK01Q?=
 =?utf-8?B?SkZIRmtidkZOMWV4SGRoRksxWUtJcjM1dUozajMvNS9UaWpMVXpUWlBMaGJt?=
 =?utf-8?B?RzJHTVpPVDJxUWJxN0t6TUVqaGM4c0VvaThhK2tIV0ttK3VzRTFsMEJka3I5?=
 =?utf-8?B?QkRWbWI3QWZxUldZOE02WEtlaU1oNTRvQjdGSEJqQ2d2bVhlV2EyVGIveG9X?=
 =?utf-8?B?c2ZOWWpOcmpWOWIvekxzd1M1ZEcvWUoxeWtNSDVqOWY0YWNUNTBybVNHNjBn?=
 =?utf-8?B?YUE2YTVGSmdPSmJLU25ET09uNTFHQnlCOWJEZVV0eCtRQ1ZkR2xzSFZnS2o2?=
 =?utf-8?B?ZFdpNGdrVjFvTmpaVUc3elZ1SVgwSnc2QlViV2d5c3NEc0RPYWlUZFRvd3N4?=
 =?utf-8?B?bG9xa0pTZzZ3Q2VpZTc3VGtoNnFsdnMyaHNqaVVpcEJNL2YraDhtNmhNWkNR?=
 =?utf-8?B?N1hwam9LaEFPMk92dTU4dWtOSkE0N3d4NHJZc0xxcyt6cEJhUlNlTnk2QnBk?=
 =?utf-8?B?NTAvQkdFZUNqa3pwWGpJbVhzbTBrd3crQmVjYkNreUVnb1VDTy9YL05rTFJV?=
 =?utf-8?B?RlBjSzZCMHJPRHBSbVpHMWZRS0ZwYWNlY1JVOENRZitUWkVDa3lXM1RzVkw3?=
 =?utf-8?B?SGJMVzFWL2ZpQVFUZzIrOUFZczlDM09zNDFybzVzNVc4Zmh5RDd4YlFZMFBL?=
 =?utf-8?B?MURCOU1wVERxRWQ3TUlHRzdKNTAzSDFKam5KV0FGYmR4Qi9yalJjNFY5STVv?=
 =?utf-8?B?WU9SU1h1RU94RGkrai9nU0NIVm51STRheU1NYUx5TTdSRVJNQ2ptMG5VdVox?=
 =?utf-8?B?TkMzd3YxQkVxY1VvcjlkWHpoN0NlbXlCSjJROUNQNHlEdnowNXNJOVJNU3ZP?=
 =?utf-8?B?bXdrL1lzWkE5VlVWK3VwRVhySTRUNUsyYit2QUhZM3phdFdsTFNMb2ZsQVNm?=
 =?utf-8?B?K3BQNnlHaW51VGlIUkRzYUhGQmsxSHJGVEtxSGVZL2tOSytQaitTdFI4RVI0?=
 =?utf-8?B?NklESzdmQitQT0xaWkt4ZUxXQW5tQUVwaE9KUVJpaHFMRnI1a25OaUh3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWR0YUU3Nlc2WTJIZGljZlBoc0NsTzFuTU1VdnE1N0pXRDVDYTF2YzQ0bklu?=
 =?utf-8?B?MTBhMHZHWlA4NktiWEtTMitxOHdqaG9XL3NKNmFHSURLNXZJZjhQcC9OVy9L?=
 =?utf-8?B?Vld5NEVXMDM0OUd1OW1MTVlKOHBTUmQxMldIZUROSW5QcmJnaldsWmxqN3dx?=
 =?utf-8?B?dEE2NFY3VFd4Qld0ZGF5L3QvVXF1UzRMY0Y3aUZmQTlSQXQvZUp4S3NrZVNp?=
 =?utf-8?B?WnBpUzJQTzQwWjJmNzBwMXZxQm9xRXdxZ3hUWjYyUUFSOHBzd0wrSGVXVjVU?=
 =?utf-8?B?SnZiUjdzTWJINGRRcjNBNm5XV3hJMjRCRWJ1RVNqbDM0aE11bTIrcFpzQXE0?=
 =?utf-8?B?U1J6SFN3WTVOR245U29OaldPNmwyQUtZUitNa3pGdkNxRjE3T1NNZE9XYzVH?=
 =?utf-8?B?RXhGSnd0WFBTdnQ2MkJ6M2hkSm5pMk1WNVNxaENSM0JFZFNmRTF0SFhNVElX?=
 =?utf-8?B?QUJRMGlBcUNpdVl1bmFiY2FVakxUOW5xamdRYzRmbm9HZDZBd05LUlpBM2dT?=
 =?utf-8?B?TlhyTFNOVTRnUmxJdDRSRUxCK1hXcEoxZjR1S0JIdTY1RGxhRCt2Qm9QYXJm?=
 =?utf-8?B?cDhmUVd0T3hWTU5VNkpZUFMyWUFGVVBkejB2MnF2UkgwR3FaZjZFb1BnY2Fv?=
 =?utf-8?B?ZG1pY1NjMWdXaU4vcHQxTGlyK3hoNGlocWZnZXE0UWpaa3lNN1d5b2tINktK?=
 =?utf-8?B?ZkxHN3dlOTlRQTJ3Szc4RVVxb253dElJeGVlTWJPRWtpZm1JWVFLckV0ZnJB?=
 =?utf-8?B?QWJtL3o1OEtDWW9kTW1lMHU2ZDZlVFZFdDgyV0kyN0JGcE5oSnJhckEvVk4r?=
 =?utf-8?B?U1BZUkRiRlhYYWhDdVRCeUQwRklBNXZwVFprbnQ1LzFmUjRNM09JaDBQaGhk?=
 =?utf-8?B?V1JjVVgzMHEyYWl4V01jN0xUd1EyUU5jTXhFQ2xCblhqVkdCOUI2S0ZxMHNW?=
 =?utf-8?B?YjJnZHBveDZDYllJK1dFeEh3aFpYeFJ4MFZ2R2t0bWMwbnp2MG5SRHdPNDdO?=
 =?utf-8?B?R3RuMDZ1d1hiRk9jVnBKLzkraHlrcnFGbUUzSnVZL05BblJjVnFYNW9vT3VU?=
 =?utf-8?B?ZS9RZnBvSUJ0SEJoQ0xraFR0Z21KTGU3S2ZaU3ZUTkF0K1BvU0w3cnNoRElN?=
 =?utf-8?B?bENER1M5M2pTZmoyYmtmbERYWGhUNjIvenpSZ3FpN0p4b3dwT3F6VXptSE93?=
 =?utf-8?B?NFJ0dTNSS1AwaExoa3Zxb1BlMWczd2VCZ0NWMlBPaDAxWHpOVDNWWnMzaDQr?=
 =?utf-8?B?ei9yVWlTK3pCcVJsY3RUSUZLMUtQMUt4Y2x1dUxPc290VjgvNW0yZTZ4MGVy?=
 =?utf-8?B?NFRjcG9JeXo4SUlWRGh1RWkvOTFSbjV2N2MyamVZT29nOTlOYWg4N0RyQ3BX?=
 =?utf-8?B?T09vSGdrMFJ3TUJFdS9TWkNYVktiTlR3Z1lWNG1rMlo2ZnZXdTRjK1FiKzVk?=
 =?utf-8?B?cUlWZzVybWNpdGtsTlVGWUx0cVY3Y1pZUkMzWUxjSUpqWjdrdEJqRlZkTjdO?=
 =?utf-8?B?RGM2VHAzSGh6ZUFCVTd5dVVJcWhCSHIwamg0SCtVLzBvVHltc3hjeFlsaHhL?=
 =?utf-8?B?VmpaNVJVNWdNVStvSFh5bDJ0a20xcUVSMitMZko3eUI0YzVydVVYWHNnTGZp?=
 =?utf-8?B?bFZYY2pTS2ZlQjYzRS8rOWpuaFRwaGVBR3o4c1Q0c1BPK1dnY05yT3h6cmZw?=
 =?utf-8?B?U0F2YjRoZDRxOCsvRXpoNUJ5OTVGUGRIbmVsSW1oWUVzdE1LYWxQUldXYjlE?=
 =?utf-8?B?bXdPczJ0UVBXSlJ4cFlnN1dIQThwNnZGRDRLUVNVN2lpZEpUQTNOcGhCZC9h?=
 =?utf-8?B?SERGNUlUd1dzMjcrQWwwRlErNkZsTGZubzhybU9WbjBzY3h1d1VKV3FZalpP?=
 =?utf-8?B?am5UYUZnRStrYmVaaVpzMUg4TWU3RDZKTVNaazdlaGtYa0ljRkhJcTZtTlpK?=
 =?utf-8?B?QmVmMEtuVFcxakNMT2lQSExmR09RcG5BWnBVY3EzTU5qblRyRFU3UmRMYTdK?=
 =?utf-8?B?b08rWkhyWTRUVFg5UjFPUldQeE10bUdlSzRCVDNLOEQrV2lTZk9zazV1VkF1?=
 =?utf-8?B?YVNpQWVaSlFaT0pYZVB3VmYrUUlUYWNhZjFmUE14dkdjdWxtRlNrMUpqNXpN?=
 =?utf-8?B?UXZlT0gzVHlkTVBZQU1iVW1zaW0rLzBvNE5rMWd6cXpXWEpMTnR0M2xybS9C?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2C010B4570B544995A0621D3AEB51C9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 837f53aa-6e73-48ee-87ce-08dc644c6b49
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 10:50:55.9824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OH+Wy6GLv8PWSPbzzkwa/ZxpA7LyvZvKAIuIYAMQb13FW4GM5wg0G6CGL4W6/GdFGYbowFnqIy7VM+QU32If5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7490
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ICsjaW5jbHVkZSA8bGludXgvY29tcGlsZXIuaD4NCj4gKw0KPiArI2luY2x1
ZGUgPGFzbS9jYWNoZWZsdXNoLmg+DQo+ICsjaW5jbHVkZSA8YXNtL2FzbS5oPg0KPiArI2luY2x1
ZGUgPGFzbS9rdm1faG9zdC5oPg0KDQpOb25lIG9mIGFib3ZlIGFyZSBuZWVkZWQgdG8gYnVpbGQg
dGhpcyBmaWxlLCBleGNlcHQgdGhlDQo8YXNtL2NhY2hlZmx1c2guaD4uDQoNCkkgYW0gcmVtb3Zp
bmcgdGhlbS4NCg0KSSBhbSBhbHNvIGFkZGluZyA8YXNtL3RkeC5oPiBiZWNhdXNlIHRoaXMgZmls
ZSB1c2VzICdzdHJ1Y3QNCnRkeF9tb2R1bGVfYXJncycuICBBbmQgPGFzbS9wYWdlLmg+IGZvciBf
X3ZhKCkuDQogDQo+ICsNCj4gKyNpbmNsdWRlICJ0ZHhfZXJybm8uaCINCj4gKyNpbmNsdWRlICJ0
ZHhfYXJjaC5oIg0KDQpJIGFtIG1vdmluZyB0aGVtIHRvICJ0ZHguaCIsIGFuZCBtYWtlICJ0ZHgu
aCIgdG8gaW5jbHVkZSB0aGlzICJ0ZHhfb3BzLmgiDQphcyB3ZWxsLCBhbmQgZGVjbGFyZSB0aGUg
QyBmaWxlIHNob3VsZCBuZXZlciBpbmNsdWRlICJ0ZHhfb3BzLmgiIGRpcmVjdGx5Og0KDQpodHRw
czovL2xvcmUua2VybmVsLm9yZy9sa21sLzcyYTcxODI0NDQ1NmRiMjkxZmMzYmIyNDNmY2JhZmNi
MDNmODU0ZTcuY2FtZWxAaW50ZWwuY29tLw0KDQo=

