Return-Path: <kvm+bounces-20434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61DFD915ABE
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4678B20F86
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 23:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF081A2576;
	Mon, 24 Jun 2024 23:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hNzmEATb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F174C6C;
	Mon, 24 Jun 2024 23:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719273147; cv=fail; b=LSllN1OBHZsKEejRNgD+kTs6rDnLsIC34GEo6nMeyf6a4d/C5RMsTZn5nF5YPYZEJmaMICgn/O5T58kFWIkSwcKhg/Z+ZS2LbBcRItkq+H6WDFHskwXQA6C/URovsaf/iH2pXVDXPoUMWdQsQGtVBTnMOm1mVMXRkaB6Dt+A7No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719273147; c=relaxed/simple;
	bh=rpJBZRmBThPFQ5h8mneNE+liUm4eRfpnAiCX+/Fg2tA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tfk7wVbPhTdfRmfaesqMyjY3Q5HB9QDSlcvB4PLzQ6GhbJcBvGnI/hkDequV1B/X0hVCEpTj16vjIcJoB5qs6a6SM7lC8UckR0U+ox9kGS4wwo9wY8WhsPQWTNprfTrqvTzyJ067tlw7SgaFHIUTeRzIUzwu4+mwYe4eiAVi34E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hNzmEATb; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719273146; x=1750809146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rpJBZRmBThPFQ5h8mneNE+liUm4eRfpnAiCX+/Fg2tA=;
  b=hNzmEATbcqV2kK08IBdIuJdnTEN8q9Hx6oJHimofWtE3/gjaPRLflYNB
   tw4637KPPteR4/AdP4GQ0qA3bsV8z+StvPSnkwxVWSoURfJ5H/5H/YnfB
   kMvhg3TdTtM+I7AV5+W7sAgmSNGKrgMauBFbTD85B4RA+Yq48SJDQZEEM
   QWogFJlnhnZfZxpxmfhFN0G6G/ZAkn5y05Mc34uqebiwEelm1ft0VfDWA
   LcKkX6FML5oUnmftIx00axkg8t9n3BSDGp0sKYFj2wesb1xAAmxOVTby2
   LbKVOF0XS2j3xsfnxzxHQm3Wfn6TVjtbcf/ejt+L6DOEYBCzD7x9D2K5f
   g==;
X-CSE-ConnectionGUID: 74aj9EknQW+9DG0+kCYRHA==
X-CSE-MsgGUID: Gjk/rD1kQlCV4ROSnuyrzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="16399011"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="16399011"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 16:52:25 -0700
X-CSE-ConnectionGUID: PASnLQLTQLKNOVnS4qqNYg==
X-CSE-MsgGUID: uKytlfQhQCWHQ5XM/8ICeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="66681852"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jun 2024 16:52:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 16:52:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 24 Jun 2024 16:52:24 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 16:52:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3FNoknAYbddcQtKk3v/sZV9PLZJvoD9CiRk+aTKp9RMCSFfL5yiAZKB3ACb0fjmfs8+6Es4pxfHATqppiaiWz1QCMLOJ7wRec/tEydn7alax0Z/0fAmiaw+YH1FaFTNyjVyb4yU2yUot6F3ghrW8cCX2XwrxwFiAPipsgJMKlWpevWUy9+kUmVWHZtUnsE/VmzYA818vImv4s70RWux+avMOiE7KULw+Tyu5NyR5rgngazTDyevYUrKoCkUuVthYR2/gHoSgCpYMnniXSUvzYwGUCCvLMl5BNiFFtAv1052nZNRy3j3aH3MffnXKnFhbZwUB2tMWFtVGJcp6YXydQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rpJBZRmBThPFQ5h8mneNE+liUm4eRfpnAiCX+/Fg2tA=;
 b=RSW3yFXOEY/Eg1RiwxWLYkCIcxOeSuoj5yiYJ63OoJSHbnPAKyBgMtdQsHekqQocVYTUW7LzeASlJOXKB7bRs2Vuq5yhmSPPh6kpB9la7LCZrP4hbK/xLpi/n/OF3lneHHJjsYsg+68SM1xfS4lYOX/PAhuXd+lRnIbqmn28bAup2+7OFjdl+KaZbtTMSUeFAFA/g294FvXhsKLJVCjWRcc1tvESOaUHm2gE/R/5jiAXCjTR19KtyOXJzRF2bMEgg2uJxbsF3DdgUxl1o+ZpFnpmQafXJIL/gY79vAyAv4fpPDYZDHe+mgNWoemnJsJ1FU0A19depTith+4mFGKIiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB8500.namprd11.prod.outlook.com (2603:10b6:a03:574::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.28; Mon, 24 Jun
 2024 23:52:21 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 23:52:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v3 15/17] KVM: x86/tdp_mmu: Propagate building mirror page
 tables
Thread-Topic: [PATCH v3 15/17] KVM: x86/tdp_mmu: Propagate building mirror
 page tables
Thread-Index: AQHawpkrPaYBRdB1kkStoRGGv1+H/7HQHHkAgAeBbgA=
Date: Mon, 24 Jun 2024 23:52:20 +0000
Message-ID: <f31b467a67aa0240dff3ab1e7b19424f363e1589.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-16-rick.p.edgecombe@intel.com>
	 <e59e5e1a-a7bc-4649-abbe-f0e64fbfcff3@linux.intel.com>
In-Reply-To: <e59e5e1a-a7bc-4649-abbe-f0e64fbfcff3@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB8500:EE_
x-ms-office365-filtering-correlation-id: 63c90084-8bbb-4fb0-5bc9-08dc94a8b00f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|376011|366013|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?ZnpRcUNxVDRGWGFkVjZiWjZYNHBmMDdHNTNqRmhUczJCMWhLeENsZ0lZTXhP?=
 =?utf-8?B?ai9uL2pFU1phTzBYdEZGVFNJZk5WdHRidi9kN1dRUnQvcnhyZi9TOEsxVXRs?=
 =?utf-8?B?K3kzenI2MmI2TDh6TUJPd2Z6UTc1Um00TThPVk5XdnE0eThGRTJybCtRYnVv?=
 =?utf-8?B?OFJWN2FrMHE3T3JFcDJzRVBtMlVXVnh1SUxwSnJjZlpZRmtFRWVxdzE4dGFt?=
 =?utf-8?B?WmEwdzhXZm1KT3Rhd2JiYjZ2NVJLQVNXRHNXUWM3UnBKRzdkWkE4cXcwbllj?=
 =?utf-8?B?bjdBNVZldU1JbVRLdUF2d0NrTWk2OEZDQVc4QUxKZm53L3FOZHoxUmtLL2RT?=
 =?utf-8?B?RTRTREFVSjU0NFpVTlc0M1Z0U3FISzFaMzc5TGtFM01Pb2tkTERiTk01ekxj?=
 =?utf-8?B?TytIeWdwTEJLVzdCVWJuS0lMcGREOFAyYkJLc2hLOXYrdFBSWkhBLzhEYjJq?=
 =?utf-8?B?enBra0ZJZVUrcmQ5SkhGaTNWeWEvRHpKV04yeUJGc2haVndYQjc0RWk3OWZv?=
 =?utf-8?B?MllyWjNURklwaG9TVXBMcnF4WjNobU1NY0FnbkpLcFdwNFdGQjBFUXliTzJn?=
 =?utf-8?B?YmplSlVSOVB4aUZvU1ppZG9Nclc1V1BKdk1CdHNvNmlseTNJNFZ5aDBoM29n?=
 =?utf-8?B?RmpGVVVjWXVIb1lCSjd0VW5HTUhoWmwzZE9sbzc3YmVaZ0xPc01yMTRoOHFW?=
 =?utf-8?B?MXVsYnFmcVNaVzFVZ3pKUWVrKytrUnBZNXR5emc2UTFkNmdyRzVtSVh3djVL?=
 =?utf-8?B?cjA5M1A5ZWNHYnpzZTY4TnF3b3BHdjVaeXExNklYM1NtdFhSY3NjakwzTjAz?=
 =?utf-8?B?aEtzeExyZ2V0OWZxSVM3b2Y1OXZicFNmbzU1WkEwVUV1bjhoQUZPdGVrYVlk?=
 =?utf-8?B?dGhrYXlIK0gyb3NZdE5TQ0kyTDVQVzk1L2tSYmQ1TjZUc1JYdWpCcE9ER1Ri?=
 =?utf-8?B?Z05qOWVKMHNmMWFEZVZkdU5hM0ZTWFlTVDlWVWtyWVRIT3NhZDFiY1hxdU5z?=
 =?utf-8?B?NDZXb2N1NEtDT2ViTmJ5WWRhelpLbTNNcU9ZeEpHVVRkOHUwT09qb2NHK1Bx?=
 =?utf-8?B?UmR1NTdIVG9mR1U1UEc3ZmxWTGUvdWxVVTFBRVhvUWFKWkxsK0Fxek0vZXdp?=
 =?utf-8?B?RER4NzF1K3FsR0NZT0xMQlVlM1pXUWVhSCsvcDFocW5SK2xkMlJ2R25IK2di?=
 =?utf-8?B?QVRLNlZzdmQxYW45Uk5YbzRWRXlZbGUzditWVzNTd1VuVnR3S05ibFZ6c3M2?=
 =?utf-8?B?MnEySnJERzFHQnRjcEZFRVBaV2VPdXViVVdkR1VLajI2aGJUQzZoeW91eUhh?=
 =?utf-8?B?YitaSFFGSitCNmszZ3lSUDlDTEZ3YUtLTTBnQ0w0OVBnWi9ncXZLb0lXWitN?=
 =?utf-8?B?ci9LeW54S1dUTUdWR1hiWEUyK24vNHQ4by80WWRKT3ZWVHY4YytRcUtyK2Vl?=
 =?utf-8?B?d3V3WXFGQUVuWFFmbnpMcHAwdFd3VkZ4R1NZRnNPejQ5S3ZkbmtBUzRDd3BR?=
 =?utf-8?B?ZDViK3YzRkJ1NzNJM0RSaVRaUmU4em10aUpSVk5ESUErZWFOMThlMjg3eVF0?=
 =?utf-8?B?QnhxZ3Jab2RnSVRTZTRjMThPNWhZU1dBK2oxUDI4RHhZaEIzMzlPZ0wrUjRF?=
 =?utf-8?B?cDQ2U3ZPNVZMWHpnQkQxeGZsRmpLRGVuSWFERFZZVVNKRTF4cm0xYU9lcm1G?=
 =?utf-8?B?ajJsTnVaZWdnWW10alBwRnE1d1orODRNck56eGthNmpLKzdRRlRaSm5sOGwz?=
 =?utf-8?B?NjRYNGttUHZDcWxTYWhkZDUxSzR4cXgzdnd0L2RGeVRwQks2VTBzbVJDdkZ4?=
 =?utf-8?Q?DGWd3VseNMVs2440RVZtjdf8yrf6ps7N7swRQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXlUV3Q5R2lTczBUMHdwTTFSSkFMMUxLWFREdTA0Z3NjMWlGeGNXZkFwaStY?=
 =?utf-8?B?QU9VTkNYM1BDZDRKRkNvZnZTeEsrOUh5VWN3MVFhUjNrakJPUXExc1JZbnRM?=
 =?utf-8?B?aVB1MUF2OEFDNU13UkdGelJUNDFQODVranVRNFc0VDZKY05uTThPY3JGRWJy?=
 =?utf-8?B?TUZuRXJmellFaXozdkJqVzdGQ0JScU9hSzFyZ0lkM2FyV0pERWtMWjRRZG9Z?=
 =?utf-8?B?M01Mc2RTWlBUcDlETEQ5VVdJaHBIV2pUZjdESXZJNEZxMnJaUVNoWU5qZnhq?=
 =?utf-8?B?bHR2Ri9vTnZaNUtxRlkzdHBoNVRvSWRUZ3FvNVdIM2pla0JhN0treW1YYnlu?=
 =?utf-8?B?ZGpaTDBZNGlhc00wOGw4NVdnN3pobFJrY0hhUWhIaXVRdEk4SkltcmxHY0w0?=
 =?utf-8?B?U0VDUUVGR1VVTGVaUmpydjFHWStCdjB1d1p4NVhzb1BrM1hwcUtqNCtnSElB?=
 =?utf-8?B?MlQ4dmhYTTRNNUpMbitkN1pFbi9OZUpuc2Q4RG8wWHlhbEF4YXFyUmJsb2NU?=
 =?utf-8?B?WGIrZHQvTnhqajRzQVdGSTFtMFM0UnRXV29jUTlYUDdEU3JQTXB2eXhDcXRI?=
 =?utf-8?B?NGtCRFhjMnVyMkhHeXNOVzVTZG5TaVpwR1NMdnBtaFlEL0syWHpBekN5UDM3?=
 =?utf-8?B?bHFuSWxzbG0yN1lmTDdUMkU5RUE2VDcrSk5aekI5NnFVbFNQZTl0d091Vkpi?=
 =?utf-8?B?Vm5SSGRidlpiMW44czJ3dUpTbExlWWczL2QvRkhxVG9YcmsvN3Y1dlVPeGJm?=
 =?utf-8?B?RjlkWStNRXFoWGVTdkE4eDFLWTB5Q0FmRmJOSFpoSVpkVHh1ZjlodTFaZThl?=
 =?utf-8?B?OWdrdmRyVzYwT0s2bzZmdjJDYlNWRTJ2VzlheEtrTDdxVVdXMlJKMUp0eUtB?=
 =?utf-8?B?ODZkbkNNWldxYkdhOFRtdFFhRTkvb0s3aVUxNUdBbXZydkRkbGRDek9uMVhn?=
 =?utf-8?B?NnRMeGMyUTBERFZKMmVBWEpJcHNia0JEb2cyaUVPSzlkSnZoUGN2MlVuS0Z2?=
 =?utf-8?B?OUNra3prU1hQK1dlVGVzcFdGWE9sYThIbHZUYlB5alNmYWRUT3pqNGZDRzVz?=
 =?utf-8?B?N29ZNk4vN05wTktuc3YyZHI5ZnJQd1MwTENjSHd1RncyOUxKczdBYjBuVFhE?=
 =?utf-8?B?QlFqR2NjUEFtVGZuQ2c0UmM2c3hXei8wSm1EbUhrR0x4YjBFWmVYcDBnRkJl?=
 =?utf-8?B?YlpKSEhYTnlTc28yTTFEVUkxUWdmYVlLMWF1T2ZRYzFZYng0VFVwRm4zYkJp?=
 =?utf-8?B?R29xaEFYYXBwd213VlFJUDRsRmV6ellHSzVPRnZ5WmprSkg1NTV0TW8rSWo5?=
 =?utf-8?B?M0JYL1BjVXNFeW9ZQ1dwUUs5WDR3SnFacm5HRjdTd3U4Vk0zM1k0c3pKUVp0?=
 =?utf-8?B?bUhjUTRLWVJPdWFRMnMxbjlndkVxSWpsd01objZRMUxpam1sV2hVOEQ5WC9U?=
 =?utf-8?B?a1NUTHNyc3k1eTg1ckVBRDRueU4rL1U4TmhUR2s0bzE3aEQ5K3MxRGllamtG?=
 =?utf-8?B?d3RnZ1lqM29xczQ0a1FoL2ZKNDdnWVo3M3laRXYvZGVTblVrcmJBVjFhakZT?=
 =?utf-8?B?RUVUdjUvdlNWNkpsbmZmdXZnYlNwWWZyNEkxcnk0QUtTUGdrV3E3NnVwZGJE?=
 =?utf-8?B?eldtOTBqdEF0VVFJSUxudGd2SWY3NGdMYWVKdU11S2V0UnRpRTNseU05bTVM?=
 =?utf-8?B?NXRLcjVSTytjV2xYbE9Dck1iNndXdGNxQzdtYks5aEUvS2k0SUxxa1NwUlE2?=
 =?utf-8?B?bmZiWm9pbWtyd3dWTFhtQlBqSldOd1c0WXhOYk13MWdSQnQ2L2Y1aUxjbGMw?=
 =?utf-8?B?VmFuZ3pkaDg1cGRUWjBWRW1Id3BRN2ZuWVdVQjhqTnE2MVlubjljdWpNS2NH?=
 =?utf-8?B?VHdNQ1prOGVSTkFBcDl5cWJDbGwxMjd4VlNRZGxCeWgvRlhWMVZDNkFmUy9L?=
 =?utf-8?B?MUF4ODZyWnlJTDNJWSs3ZEkwbEF6azhxUXJ2Z0x0S0F3ZllXOWpzTllUTFJs?=
 =?utf-8?B?aTFreW4vZkhURDZrYU5uYVllbnBuRnM4MG41VVl3NjhScTJtUmJzaHNCU0Fl?=
 =?utf-8?B?REVnWWhnOHdvMWdhc2k2RUdrUTFVdHdIbllDclB4VEgyVmw2NUczZDRtYmY4?=
 =?utf-8?B?KytQbmhiVjBzeUZsTkRlbVJYTkdaNC9lT1BEU2dnZ2E4eVRGTzV4REtWajdw?=
 =?utf-8?Q?J1PF5GxZjuTFqYp+MgtX37A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A551311360CDF04B922163C274DC357E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c90084-8bbb-4fb0-5bc9-08dc94a8b00f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 23:52:20.8752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Cds40v3Xw1LmNb55z1g0WSJyYEQxtrmHcYr9d7noktCDo5MI+i4iGffxbEzfW/tGwaSx87Qn46jsrQ3e7INmWrgOpNxda+DxO/+I79LOqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8500
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA2LTIwIGF0IDEzOjE1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6Cj4gPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcm9sZS5pc19taXJyb3IgPSAxOwo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJvbGUuaXNfbWlycm9yID0gdHJ1ZTsKPiBJZiB0
aGlzIGlzIG5lZWRlZCwgaXQncyBiZXR0ZXIgdG8gYmUgZG9uZSBpbiAiS1ZNOiB4ODYvdGRwX21t
dTogU3VwcG9ydCAKPiBtaXJyb3Igcm9vdCBmb3IgVERQIE1NVSIuCgpXaG9vcHMsIGFuZCBhZ3Jl
ZWQgb24gdGhlIHRleHR1YWwgaXNzdWVzLiBUaGFua3MuCg==

