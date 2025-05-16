Return-Path: <kvm+bounces-46845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E854ABA231
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 19:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 257D74E31FB
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5D125523C;
	Fri, 16 May 2025 17:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JYi+TX2/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EDC1A256B;
	Fri, 16 May 2025 17:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747417859; cv=fail; b=HnWtuVkfvbofZBCmEiVWlXNNbm5OK09qGjxK9nhG8rYepPBNMo/qjd8hvhiY+8YvkkEPoI3AOwFM/CCv/gmIhh2u9jA4G6xgDtJSsrEOonq+AYbcZDuLZAxhIbSEtOUFp6etjo2hDbBZRyYT6f77w12ctQyvoiipXi7IHOh71qo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747417859; c=relaxed/simple;
	bh=2svl9dXPi+WOG7Htfzovfs633fTslizj/AnK+Hztv+4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kJdGvZsTSeNMtPUA30qOTxXYDelTluzrfFnVxxWtFkXIFMWQkVzDhGzji5jdUDHiTqIdUWJrbc/5lulBIbQ6jkAXRhSmcG4sWbe6Nyq4Sz3DzGiONuJ8zsX6Fgn12vhmJZUFvsbj9lV72fv0KNYtsUEccH8+VgYIB7KPCJwR3x8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JYi+TX2/; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747417858; x=1778953858;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2svl9dXPi+WOG7Htfzovfs633fTslizj/AnK+Hztv+4=;
  b=JYi+TX2/wawj0r3ruVpPMOMzOsnobjsOTRbytaqBjMPWS65IXq3HIzHl
   h13ge4s9oHRKT8Qz6uiadY7EOOVpkl75xgSmKaGBShQN2laQmtngsThwO
   Q/eGRYo31XtGenqCHWeIoc8RVWMxIbahJi3MXMSemiJZ560x8kWhtNsxn
   JJL+ZFvIiiD9ZMVdm1uL1v7/W/HlWGab4PaPVMKsP9HlSOavQOUvIvwWH
   dQ2WrZT239p+2hrStZVIBN2kusumGlkbPr21NOkAL+TkINqHTP9Jo5oPs
   MY/pcsJxFLMZUFeXWHCIzwrw7//SW2wUFpKdibNoN49C2wTmXYECOWwml
   w==;
X-CSE-ConnectionGUID: haRdZpE7RmSZj/IOWxkciQ==
X-CSE-MsgGUID: 9GeDqCbjS7+SbAgX+4g85A==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="53216265"
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="53216265"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 10:50:57 -0700
X-CSE-ConnectionGUID: JTP5ZavvQiGoiDj8VE4lWw==
X-CSE-MsgGUID: x59/LzQxTYeLuQqRZnbccQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="169795132"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 10:50:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 10:50:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 10:50:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 10:50:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsIR4ix5aQvCYgm7n9LG5VYnN3cfW7p0iklNasp/kWG7xB6oSJqtPf8OIdp8gxdTf9t5l5FPPdwipJCBxtnS/KyDbJl1k/Wf2YbpSXIJtreiFRQcFOkD95Yxn/AZ+PHR/efOm7ijTEaK/xmKCYjt/Qz69wk3ugweMgHlMxTKEqA2WC96wcyyhF9BSRmWLF4+z49HnCSpjB4KmWkrM0Iu3ZSXSWzwkk/pN5V2eGzlfGU97CMzEH2SsINWrdQPqmJfx+cZY3WJRAwO4N6CWGzOCV3kWRJ/zciR/BfvKhhVZlMbxZvE4dcGxPWOmM7JyWkxlDDrjLsKphjH/zTnzg3r2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2svl9dXPi+WOG7Htfzovfs633fTslizj/AnK+Hztv+4=;
 b=fJPNIAixmSe/EuSJ2CMKeVG9nDnunt5C/QOkSCeYhUSIcAadcSyZQnwnfmoxy/gC72jhzjA7Bbm0UwQ9zczlNEZ1syR5gUqdQ7nv+ixneTveqFfQK0i7AIbX0+0VFmIvuw6kFm6HeEp1ZoXLoJSANWm1rGrjBZuuKEeBMQclcyZZ1mVc//sy2uW/asJOv9ew8oc4g5UjdIgMrpbRHtW6m2gRnMeSfIotOhWPusdZL+BMIfiwRlA/zvjkaJseMkilkbBtlAKxILxdgvIWTlTOc1Y1z6P811KjvddTQldh1OZ2Qgid7RZxTK5a9GZO9o/VsoADxVmkiMKnR/AHeiS5/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB5220.namprd11.prod.outlook.com (2603:10b6:610:e3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 17:50:53 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 16 May 2025
 17:50:53 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 10/21] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Thread-Topic: [RFC PATCH 10/21] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Thread-Index: AQHbtMY0fWGadiEOpUminaJ+lP6+0bPRHeuAgAOm44CAAOfGAA==
Date: Fri, 16 May 2025 17:50:53 +0000
Message-ID: <20fd95c417229018a8dfb8f3a50ba6a3bcf53e6c.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030634.369-1-yan.y.zhao@intel.com>
	 <9d18a0edab6e25bf785fd3132bc5f345493a6649.camel@intel.com>
	 <aCa4jyAeZ9gFQUUQ@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCa4jyAeZ9gFQUUQ@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB5220:EE_
x-ms-office365-filtering-correlation-id: ba34a8b7-46bf-4258-c40f-08dd94a233fa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aHYyVVVEcTlDdkZ5N09Vbzl4UFd3Qk12SDBGRS9vaE9OQVhYSW5XQWtpbUls?=
 =?utf-8?B?dURiNmJjWXd6KzJEbldoNEdSN0FyMm1TWGd1N0R4dUdYR2c2cjBuL0xsczBa?=
 =?utf-8?B?NHR3TkNJOXdIeUJOTzZQWGtLQ1lyZ0ZTZVlaVGs1MDBkTTNUK1A3dG1oS3ly?=
 =?utf-8?B?R08vbU9NSDlVVVpvMTZ2amdneFR0QXlNVkYzb054eG1IRmlORGI0WnJ1RXdh?=
 =?utf-8?B?WlpXc2c3MTdNdlRvZ1lwdFRWNTVITFBVak13Z0tsMDE2RURvTk1GSWllWC9E?=
 =?utf-8?B?SElkc2FQaFV1MVMyVFg5eVdGQTNOdGdYdzYxWEF4WjVLMm9QU24xejF3RDB2?=
 =?utf-8?B?dnQxM0NJUDU2cEZRNkxRbXI4UkxrSzYrdGRFUDRmZDV0MHd4QS9BYlFPbkdF?=
 =?utf-8?B?cGVvQ1dURUNsSnRXbDdCODJMS2hDZ1d5OWZmK2tOM1h4S0RuMGMrWkJ5SEtY?=
 =?utf-8?B?SkwxNGs1VkgzM3hRU0dnc1Ywamx1NjdzSm1hT1dBbkh4R1pOYzRSVEpBbzVh?=
 =?utf-8?B?ZlE0MkdVdXJ5S1N4UTZUaDkvQTJQWlEvRDg4c0JFVHV3UEZKVjg3ek5YVmtS?=
 =?utf-8?B?NVhhUWhmdWlOSndlZFY2dVJSbjRuWEFmeVNWK05aN2loRDlka1FIcWpqQVF2?=
 =?utf-8?B?KzRKUXFZLzdjTkJmY2t3NGpLM2E3UWMvK1Q3cUI2STFNcHpKaGdPWnVCR2Jk?=
 =?utf-8?B?V3FJWjMwZlpwUmtpWHBLQXhLMEFaZ3AvSWVQSEswWVJOT2QwMS9jTUpUbDhp?=
 =?utf-8?B?TEZVTmJxRFRBMEhVaWpnZTBtK3RPQldZaHNzUGRWVGNTMHI0Qmp6d2s3RU5K?=
 =?utf-8?B?RHlMQU1MQml2RXh6d25ka1YyREtkd3BlSU9TejJCTE1aVWF1bW5iQVdBa1N1?=
 =?utf-8?B?OHNFYjVabW1VQkptMEFIT053cmVEOUMzUG1OVkx5WEpNa3BPZ1ErZ01BeXRr?=
 =?utf-8?B?R1VSNjVhaC83TnJzcDBxbzFjejY2M2k5US8rbW11OXllRmtZZ2dLUGpxL1FX?=
 =?utf-8?B?aVJlQTU1by93T1NBUWV4VkxNbnd6OXFZMG4wTEtpd2JMeHdZUW1jMmRId0Rq?=
 =?utf-8?B?Q2poekEzNlZXZWhiZ2lqK0ljaytaY1daWW81aXhGSTlLcmlETjdhZXE4dVhW?=
 =?utf-8?B?aFhZSmxPNy9GQVppZStyWGdVTXJ2Mm1YWEVidVhrdytNSlV1YWNLNW1rME9p?=
 =?utf-8?B?VGVJN1duUzhXaS9JSE1nNHdOVDloeDRFeTFuYUxXQXNFQkx0c0swNXQ0bG9h?=
 =?utf-8?B?WnU4ZWROdmoxbDl4SXlWWTU0aW1DNjJzaUFVcUFaMnl1ZGk5ejVYYytuTlNr?=
 =?utf-8?B?R2hmMXhLbyt2UytsMXdETlI2cDNnTXFvUVZxQXFBTlZrQm5wbzhDYzl1WkRp?=
 =?utf-8?B?d0o1OEZJMkZJdWFqQlE4c2s1a1ovWURaeGpRTlRaeHJKVUZHMnpFdFVTQndQ?=
 =?utf-8?B?QTlCY2tUVkI0T1BjYjRGYzY2MzRMN1pHODBXMGhCM0FQalFCRE5aaFp2NlVW?=
 =?utf-8?B?WDVLQmdrZVJjTndQRkZOeTJrZlVlS01NRTNlakNweVFVUEt1Ymd6Q1JZZUw3?=
 =?utf-8?B?c1cweHNUUEd4U21ReWF1ejkwL3M1UFdNeGR3RUVWeEg5aUdyMW94K1p3ZU5a?=
 =?utf-8?B?N2MxamtCRkpQREdSaHo0bitIQldwL2ZHenRHemtkRHRqNHlCa2tqT01BWk5V?=
 =?utf-8?B?YXZJQVZhV0xVajYwYWJ3blA4RmROSXIwZE5oU0p5NFlSeHRxdlhDWGMyWXhK?=
 =?utf-8?B?STgxRS9sVWVmQWtEbnZmdDgvMmc3UlNNR2VRSnRaRk5wU0NVZ0xlNGRMRVEr?=
 =?utf-8?B?U3BkVTNoZ2pXL3g3UkhjM1ErU2RoeHhxa1ZTZ3N5WXFmTkJKVVRoczMvQnRz?=
 =?utf-8?B?VDA1d1hYK0lBWG1nbUdRaXorQjBhbG1jcjV6WnhKaHpCMWtMSzVOb0lSMHIz?=
 =?utf-8?B?bGdQOG55SitCYkN4Mms1cnAzZnZtaDRYeTBiWFZad0NleVdVS0hHcVpLMFVl?=
 =?utf-8?Q?eHuY+cqhAZ1wQ/6cpMKLq3Ln626wJU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkRmaVJQY21MUjVLcjZ2RXc1OTFCcjlxZmt0MWwyWHBDQks2VE5FN2U1SExx?=
 =?utf-8?B?TUMrcm03c2NNZWJZdk5xS1dIbXNEbmFNd0c0dFBwSkdvaTNrVDNwMFowQUE4?=
 =?utf-8?B?SGMwRTJycmJJU1psOUpWTEppb0NEbHlobHVnNW16VXdITmYxZ2pNM2tOdS9u?=
 =?utf-8?B?WmVIb3VMaHRiMUJLSlhqbkhaOU9RT1JyK0VjazZ1VitGN0RrcDVCTkpZZFJq?=
 =?utf-8?B?ZjB2czZBcE5EWnBmN1A3TGc5RGxqejJabFlFWjlVVFJkRHdOMk9SUVY0eHF2?=
 =?utf-8?B?UFh3TzdXQmhMS091RzUvOUxyS2NqUS9kR2VLejlURENGZFhqeXBJMFFtVHVl?=
 =?utf-8?B?dGF1dk5kQUdyUE9KZk5Md0I0c2RlckhkaGdOV2VZSHUvMFVtV254QWhvdXlm?=
 =?utf-8?B?UmZiSHJpZVZsN3hpL29BUWp2Q05WcnR5RGhFUkR0ZDZnZkpZYXpCbEhkdVZj?=
 =?utf-8?B?clJmbWRVb21mQjc1NEFPZUEvam5jcVdrcHd2NXhYLzZ5aCsrM2RySll4VU9Z?=
 =?utf-8?B?UjNmVklHV3dJeWpJN25jM0EwZkd5cWVpelA5Z3prc3YwMjlqOXJIWmE1YlRY?=
 =?utf-8?B?U1pzSjE4MW11VkMrQTFSZWNRcXo3dGlTM1ZGYUpNR0cwaHBDZnV6eERMOHIr?=
 =?utf-8?B?MjhyNDF5T04yWE4vbUxRdGlubnA2SFVVanVYTzVqZ3docGhDc0pWTUkyV2ZR?=
 =?utf-8?B?WHVIYVBaNWJYUFhvS2hIL3lHckVhMGNkdEVjTHBOS0VaRmZweDRoVjNYTVR0?=
 =?utf-8?B?Slc4T0d4K050cWUrdmRuOWk4TFoxQVltRzNDL0FwVFVocEdUMlA5ZGU1dEFo?=
 =?utf-8?B?OFBLRjYrYlBnZS9MRmlCS1R3MnM1NjBVdkdnRmc5T1l3VFNZTVhKVFovNTBp?=
 =?utf-8?B?SEx0Qjl0ZDVWOVdELzh4MzEzMnh1dTZYRUxUcjRSQ1ExYmFEbjBUMElTK2V2?=
 =?utf-8?B?aFVLY1RmdnFFd3BsSGlpRWJCNlgzLytHQjJLRzQ4ZTZnalBMYUlBd0R5UzdO?=
 =?utf-8?B?QjJPSjkvNG9aSmw0a09wOElNMDJVZ1dzNnQ3R1RqWWEwS2JjT0VMaWdYaWs3?=
 =?utf-8?B?ZnNFelFzVlFNRjMxcytmS21DeFc4dXF1SWV4c21UcXhPRVIraEFVNUpLNVpG?=
 =?utf-8?B?OWhoai9iOUIySjgvWHIvY252Rm1yeVdUZTllZTFUcmYrcWFyeUZzQXEwbEtm?=
 =?utf-8?B?U0lEVnJ0ZVB1c1RwVXAxODJGNVovYUc2NmNhMkJMSHoyellzSEpKSTRiZnVl?=
 =?utf-8?B?Kzl1RHVhR2kyTnk2T0JXYTdsVVErQkltQ3BKSDZjTHpYZzh0eFhIamo5dGRN?=
 =?utf-8?B?QWdwMTlVc2VSZmRVTUJpcDE2aGNXZk1iMktmazJiUktvSlc1eVVyRjFwV2xL?=
 =?utf-8?B?L3pxRFNmbEMwNWI5amFPcW8zcjlFM0NUeHR3d043aEkrZUVsS2FWSWVNSm1x?=
 =?utf-8?B?NmlJMWxackhkbVZCem1EbU5HV0VSb2pwRHJPVXU4MlZYZy9XWnkyYllwUTFp?=
 =?utf-8?B?QXBaTGVWMUxzRTViRFpnSmthb0F6a2xxMmVGZEpjVkd3bnNtZkx4U2JpMm9Z?=
 =?utf-8?B?Ui81bEtBRFo4MUljQ3NUK0gzK3F4d2RCUEcycmJWSEFRYVN0UmRwaWg2ajEy?=
 =?utf-8?B?YjFQMlN2SHhQdHlFS3R2ekVPRkVYd1FhWnRuWlBlRDZsTnlxVHdqdEx2OEJv?=
 =?utf-8?B?aWFrYVViUjMzVVRpdzBYK1MzckJMNUU2YUtlQzNHdkk0eUdPTzVjUFlNUlpz?=
 =?utf-8?B?bnJNNGYvaUtsK2M3MUR0ckFDM2V6bnZuL09URXVvYVF0aDFTYlNGWkVVZGJu?=
 =?utf-8?B?YTlVYUhTbFVhUWpzZkhTVERHMStLRWJhWXUwbkhTVzVNNjR1R2F5OVhsRzNS?=
 =?utf-8?B?MG1NYU5hbkN3YlVZeGdNdEFvck1Tb1FoOHNQK1hpUFlKZGFSS1FNRzBuc3hh?=
 =?utf-8?B?d0NNSWZaMEJDLy9SaHdoWjd3VC93WEx6RVFjbmpITVNpMjZOYUpaeU9ORTkw?=
 =?utf-8?B?cmE2U3NBeFdIcURLOGsvcUhCTkcra0dnZ2JJcUJXRGEyZTA2eHN5SmxGczlP?=
 =?utf-8?B?QTIrWTUyVmVHRlVKRXdwbXlIL3U2Mlgwbjg5NnU0Q3RtZ1YreG5YZ3hFRksz?=
 =?utf-8?B?cHJaa0ZpYkl3M2pIVUh2T056UXhHQ2dvQVdHZXBMUFVuUkxDUTN2YVdMLzEv?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D8504852A0ABB41916422FC81CBDBFA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba34a8b7-46bf-4258-c40f-08dd94a233fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 17:50:53.4002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ez2FCFotilUudpvxTrmcm+A6IK84jwXUSSFLHTaPZVlI2l+xNPD8254s1oulEDCz5TpqLmNBAUJNtdgW4AVLOrhK1y+XEpmCxwSPKzEKSAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5220
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDEyOjAxICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBN
YXliZSB3ZSBzaG91bGQgcmVuYW1lIG54X2h1Z2VfcGFnZV93b3JrYXJvdW5kX2VuYWJsZWQgdG8g
c29tZXRoaW5nIG1vcmUNCj4gPiBnZW5lcmljDQo+ID4gYW5kIGRvIHRoZSBpc19taXJyb3IgbG9n
aWMgaW4ga3ZtX21tdV9kb19wYWdlX2ZhdWx0KCkgd2hlbiBzZXR0aW5nIGl0LiBJdA0KPiA+IHNo
b3VsZA0KPiA+IHNocmluayB0aGUgZGlmZiBhbmQgY2VudHJhbGl6ZSB0aGUgbG9naWMuDQo+IEht
bSwgSSdtIHJlbHVjdGFudCB0byByZW5hbWUgbnhfaHVnZV9wYWdlX3dvcmthcm91bmRfZW5hYmxl
ZCwgYmVjYXVzZQ0KPiANCj4gKDEpIEludm9raW5nIGRpc2FsbG93ZWRfaHVnZXBhZ2VfYWRqdXN0
KCkgZm9yIG1pcnJvciByb290IGlzIHRvIGRpc2FibGUgcGFnZQ0KPiDCoMKgwqAgcHJvbW90aW9u
IGZvciBURFggcHJpdmF0ZSBtZW1vcnksIHNvIGlzIG9ubHkgYXBwbGllZCB0byBURFAgTU1VLg0K
PiAoMikgbnhfaHVnZV9wYWdlX3dvcmthcm91bmRfZW5hYmxlZCBpcyB1c2VkIHNwZWNpZmljYWxs
eSBmb3IgbnggaHVnZSBwYWdlcy4NCj4gwqDCoMKgIGZhdWx0LT5odWdlX3BhZ2VfZGlzYWxsb3dl
ZCA9IGZhdWx0LT5leGVjICYmIGZhdWx0LQ0KPiA+bnhfaHVnZV9wYWdlX3dvcmthcm91bmRfZW5h
YmxlZDsNCg0KT2gsIGdvb2QgcG9pbnQuDQoNCj4gDQo+IMKgwqDCoCBpZiAoZmF1bHQtPmh1Z2Vf
cGFnZV9kaXNhbGxvd2VkKQ0KPiDCoMKgwqDCoMKgwqDCoCBhY2NvdW50X254X2h1Z2VfcGFnZSh2
Y3B1LT5rdm0sIHNwLA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBmYXVsdC0+cmVxX2xldmVsID49IGl0LmxldmVsKTsNCj4gwqDCoMKg
IA0KPiDCoMKgwqAgc3AtPm54X2h1Z2VfcGFnZV9kaXNhbGxvd2VkID0gZmF1bHQtPmh1Z2VfcGFn
ZV9kaXNhbGxvd2VkLg0KPiANCj4gwqDCoMKgIEFmZmVjdGluZyBmYXVsdC0+aHVnZV9wYWdlX2Rp
c2FsbG93ZWQgd291bGQgaW1wYWN0DQo+IMKgwqDCoCBzcC0+bnhfaHVnZV9wYWdlX2Rpc2FsbG93
ZWQgYXMgd2VsbCBhbmQgd291bGQgZGlzYWJsZSBodWdlIHBhZ2VzIGVudGlyZWx5Lg0KPiANCj4g
wqDCoMKgIFNvLCB3ZSBzdGlsbCBuZWVkIHRvIGtlZXAgbnhfaHVnZV9wYWdlX3dvcmthcm91bmRf
ZW5hYmxlZC4NCj4gDQo+IElmIHdlIGludHJvZHVjZSBhIG5ldyBmbGFnIGZhdWx0LT5kaXNhYmxl
X2h1Z2VwYWdlX2FkanVzdCwgYW5kIHNldCBpdCBpbg0KPiBrdm1fbW11X2RvX3BhZ2VfZmF1bHQo
KSwgd2Ugd291bGQgYWxzbyBuZWVkIHRvIGludm9rZQ0KPiB0ZHBfbW11X2dldF9yb290X2Zvcl9m
YXVsdCgpIHRoZXJlIGFzIHdlbGwuDQo+IA0KPiBDaGVja2luZyBmb3IgbWlycm9yIHJvb3QgZm9y
IG5vbi1URFggVk1zIGlzIG5vdCBuZWNlc3NhcnksIGFuZCB0aGUgaW52b2NhdGlvbg0KPiBvZg0K
PiB0ZHBfbW11X2dldF9yb290X2Zvcl9mYXVsdCgpIHNlZW1zIHJlZHVuZGFudCB3aXRoIHRoZSBv
bmUgaW4NCj4ga3ZtX3RkcF9tbXVfbWFwKCkuDQoNCkFsc28gdHJ1ZS4gV2hhdCBhYm91dCBhIHdy
YXBwZXIgZm9yIE1NVSBjb2RlIHRvIGNoZWNrIGluc3RlYWQgb2YgZmF1bHQtDQo+bnhfaHVnZV9w
YWdlX3dvcmthcm91bmRfZW5hYmxlZCB0aGVuPw0KDQpBbHNvLCB3aHkgbm90IGNoZWNrIGlzX21p
cnJvcl9zcCgpIGluIGRpc2FsbG93ZWRfaHVnZXBhZ2VfYWRqdXN0KCkgaW5zdGVhZCBvZg0KcGFz
c2luZyBpbiBhbiBpc19taXJyb3IgYXJnPw0KDQpUaGVyZSBtdXN0IGJlIGEgd2F5IHRvIGhhdmUg
aXQgZml0IGluIGJldHRlciB3aXRoIGRpc2FsbG93ZWRfaHVnZXBhZ2VfYWRqdXN0KCkNCndpdGhv
dXQgYWRkaW5nIHNvIG11Y2ggb3BlbiBjb2RlZCBib29sZWFuIGxvZ2ljLg0KDQo=

