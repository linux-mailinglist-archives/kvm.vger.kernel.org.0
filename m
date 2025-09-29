Return-Path: <kvm+bounces-59022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B0EBAA33B
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 19:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36FDE164202
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76EDC22127A;
	Mon, 29 Sep 2025 17:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M7mdTWvx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C1B21257F;
	Mon, 29 Sep 2025 17:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759167708; cv=fail; b=GPbFCJqRUhyulKKJ029VhvHW3mzDW0RdIlOzV9X6rMh7qlG11CPPaqRirpDWaVCB1mchZPHG7d9RRynyWX8U93B7h/lX8r4T6Il1vKI4tbcLeyHOAdD+5YpQh50fauFQJ/JJ+ZjcZiQleZSQbM71N3ocgnPh4lktuGYneI3yQ3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759167708; c=relaxed/simple;
	bh=xC+lwAr2Te4ey5v5crY1KdcqI+dd35CY8MojRWzaUJU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sQ5hLKDZYASmkYOkG0t1D2FGx5sgGvHTh0eZAUC10BF/eoSWA7sId1sQiPOVc91PrY3jB+iib7kBsA9PDWO01WPBnzJZ5vVN7IcGaVWewyFPRsBwm54uO9kC7MFZ/V3QkgibKT8OnAY2pGgD3fTdE+F6aQ9O35nNJDLL2wCn46Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M7mdTWvx; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759167707; x=1790703707;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xC+lwAr2Te4ey5v5crY1KdcqI+dd35CY8MojRWzaUJU=;
  b=M7mdTWvxZUABfyCI48r00zXTHIT7Zdo8o4nAtrlN5Lo/dbO1rwq3QUJd
   VElIZrt0TfZK32u1N0E54nD8MB3pfSntJ86m061dOTJNxGbJRKcGvAN7m
   4Y7LYNUanekK5C1CKXnV/pku8tsl3J6/EibNhXVolKVVG+fukIE1UQ/K/
   uaswu5mQYi+bksoGKgb9H182jJbygO1Ldk6EkR2lkgarPFzbVIkIBsXBZ
   x1v/QeC4OwymTP6xRnFTrHB2b8Mk+bPxEHAfqvuEBM3HgZaJpBN8OjO4B
   VoJijxRUxCAmR2EkwAWgSIQP8COVn1l4b/YG7pUIgZtgbmZr7u24jDIFi
   g==;
X-CSE-ConnectionGUID: 1BroEaiXQn+nH6+Xsg5xFA==
X-CSE-MsgGUID: 4/uaZFRmTIW3cOrXPSdN6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61328271"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61328271"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 10:41:45 -0700
X-CSE-ConnectionGUID: Rh1WAw8UQiSSpuhFgaiGtg==
X-CSE-MsgGUID: 4VbhYC/GRcG86e+KiAH6PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="177417343"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 10:41:45 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 10:41:43 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 10:41:43 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.60) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 10:41:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ltQC6pKnObPDWhLZHPgy1oGFXo966VuyVmDLATU0FkPdFJnHbdT6CLV2xLMkAttNytY3rla0z0LYl851+6fIgqrzTq5SSGjp9JtZsHAPgbxZqwjDq2ryMEWi+RlRb/AmTmMmv8C38sJdwph6hPK4OT26H1aDLZvUq5MCy8iZIZbeodt/FOZea/bjZkIUbK2qzbq+pgjJHIaCL+LC1T+aQg8JhXjvgbWSv7lFHWLY663EsdXUeyL6KjSE+v32QdxFz1UHdM27yM0ZLRNPNsWkESth1uf6iX+WOef7mM7mLryBNvQnlesWUmO8eN5vpxzLtSKRTQgd2+dY9JmRJAS7dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xC+lwAr2Te4ey5v5crY1KdcqI+dd35CY8MojRWzaUJU=;
 b=VYu4rCHoLJvS6drq1L9n1wwvmz15N9EDZ2ugFPLcvmf3A50Qjnk6dGYpqxcQfyOBJEESGB97sRHU6aaL3stqL01K+K60QI02bxzGsVvjnnlixlymsEmz+nx685bQtPr+0CSKe+1zUM29gA4RzGiPOPQ9R4atvFsATXl4LG2XYet9tKcmgD+SaIFom6yE2lUPn+2sJVbEL/77TV9Z4WqSBOB2q3W0d2gcBYgaKiqExfjqdN+3tte+RkVByy748YQgI3XohMGOoTeDVyJnFSCSOkxdwEeWyJGz/ChqK9t8iQBNi907rua11woe+ft4KYH90+0MUJ9U4AMtQR3Rq6KfKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ5PPF6E320AF71.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::833) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 29 Sep
 2025 17:41:39 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 17:41:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 05/16] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Topic: [PATCH v3 05/16] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Index: AQHcKPMyqcZdyD86IkOkQscaglq3prSgakGAgAoUdIA=
Date: Mon, 29 Sep 2025 17:41:38 +0000
Message-ID: <c8b69a9c5709d8bc482ce724f23da01e8d151727.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-6-rick.p.edgecombe@intel.com>
	 <47f8b553-1cb0-4fb0-993b-affd4468475e@linux.intel.com>
In-Reply-To: <47f8b553-1cb0-4fb0-993b-affd4468475e@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ5PPF6E320AF71:EE_
x-ms-office365-filtering-correlation-id: 867901b1-b659-47be-88d5-08ddff7f718a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?T00xc1FudHJjWDJhRnpGK2liem9sWjZMTFR6bi9odWg4dDhCWWMzZ2IvSFJj?=
 =?utf-8?B?NWY2Qm95ZFJta0M0VXd0OEZORXhPbTQwZGt5QmU5UEh0dHlTRDJTdUFkdThL?=
 =?utf-8?B?SHJTYmZLU1N4akpyOGNYQ2tKWDcvNVVYVzRPMjNnak1lbkNPSHp6RERTblJF?=
 =?utf-8?B?UFdlSXhBOVU0bHo4Z3NtNVZ0RGE3QWNZa1dnM2hMMVNpZHNMZ1c0SWo2cFdn?=
 =?utf-8?B?ZnN1ZVhqditEbVEveUdIK2pXbUVxTElqVmI1T0NVbHRHNk45bXVibDJrUjQv?=
 =?utf-8?B?NnJCRElhend4Qi9wSUxCTEJuSC9zdFhicVh5b2VTa0VHUmp4eTUzdTd1MWhO?=
 =?utf-8?B?ck9mSGZ5UXlrWC9VbzFZMjJnY284VFp4cjlkZlZsUWlhWndSVHpmYldQVlJC?=
 =?utf-8?B?REV6TGYzOElQTS8wMW41OWxVYjFBbGNBMmRJTzN5WnRqVDZ2ai9aRTBFQStJ?=
 =?utf-8?B?SUdGZTdBRnc4RjB1QWdudWt3Wk0wcktXRnpDS2RtL09BaDJsM3R2YWUveHN1?=
 =?utf-8?B?TDVvekNMdDZJbzR1WmlZSG9FaVdEVkp2R2hLc1ptWGoxSDhSSTJXNll1VzR2?=
 =?utf-8?B?Q1J0cUZTdXVtbjJYQXV6OWswVTZBVEtHOElzYjJ3MDN4c2tzMFpjWDRJa1FX?=
 =?utf-8?B?ZkNLZ1VoVVNGakkwb3RrdWg0WUU5MHFNalJEdWZjbEQ1QitWNGljSEY0aDA2?=
 =?utf-8?B?K3c1akJ5eVRmc3JtY1ZrTmdYU0NIWkhrUlh4Mld1UmxGK1dnUmtacWtlSURE?=
 =?utf-8?B?M3ptQUJsS3lNOHFFbFFzdDcwWWY5d3pUajZ3K0EybFY3UkdTMEhxVndWS3Aw?=
 =?utf-8?B?UUVUa2tid2VHUmhjOGNYWE8rY1ZFQ1hPM2V1bGh2RkJIQ0FteTVXZEtIbnAr?=
 =?utf-8?B?M1gxaC9ZRXd5dzJzNG1pVHp3Vlp4SkJIbHAxQ0NZaEZ2NHVmZnI2eG9YWWc5?=
 =?utf-8?B?UWt2MzR5VUdtZnNyVnpoem5aUTBBYkk0eXBKQ0E5YkluUDBjd0ZvZ2czQTdt?=
 =?utf-8?B?RDkxNjRXa1N2OXo0WUN1aDZFM1NsRVV3d2srejVyWm5nUGo4SHhod1FOMVNx?=
 =?utf-8?B?V0g2aE9OcE9YZ0JNUHNzYzF3M0ZwTHBjTXFVWDQ1K3R4Tndvc0ZSVWlVeWFU?=
 =?utf-8?B?MEdKVUpsVDg2RU9ETExFdDNUSFNGUkp2MWlXT094MjlKbHozSGNtMXVjRzEv?=
 =?utf-8?B?cVU3bGpiNHFLcFIraWh4K3JKYmNWbUJEOUt2Tmp6Y05pRUIraUxKYWVLa3Ex?=
 =?utf-8?B?ODFETXZ3U2JpeVZheVdLOXltUm9ra1FZbU83b1VudkJQZVpwd3A4bTJDL0Qy?=
 =?utf-8?B?eWxCcStqTGhRS0dYVHhyVkJPdnRPNkhhYzFrcXVEVWF6WVpXakR6WXp2S2Ry?=
 =?utf-8?B?dzFjTjZ1K0NDT0tIK01Dek9nTllTdTZsRzQvaVdra21nc3J0YWlCRE9yN1Zj?=
 =?utf-8?B?aUZ5bElPNzBRZkx2QjVYTjVFcE9vQWJlYUFuNk5tZld4U0xWZzdZaGtsblVF?=
 =?utf-8?B?Vm9tRE5iWmxzYkNDclJna05PVzFKcm4vdzBPVXJpd3RZUGxGL2F4UmtIMjJk?=
 =?utf-8?B?MUhzdkxBWnFIMTJNbjFRejhKbm54MUtZZ3hyYzBtczBXTTRmZXVxOVVFcnJJ?=
 =?utf-8?B?aE9FMlBkYzVVYjNnQkZGdytzdWRMTTNlY0RQL0Z0THVzOUd6aXEweSswVE5H?=
 =?utf-8?B?SVhiYVV2T2Y1MTBzZFVOWjhXVW8vNngzMFF0T3FycU1hT25SMXJNNjFDU1pY?=
 =?utf-8?B?aG0vNWpJQzZSZkZCVTh4N2VMQjV5RnRUVDdJVm9PQ1NDSHVEOVlxMTF2bUMz?=
 =?utf-8?B?MHZwY01PRDMyd1dWNWFsQko5VUF5azdCblRuMmVjQVgzazhjVXREYnV1NXRI?=
 =?utf-8?B?Y1pjR0RVd2VQQ0VyQUtYbVhvaUFHVzhvRjJUR0tQT25pcmdsZmJSS3YwK0tu?=
 =?utf-8?B?ZHh2cVhISitzdnRUT2VqcVBOd1ljeG5rVEx6ZEpjOVBUVmwycm5UMDhGT1V2?=
 =?utf-8?B?bmxDcWQycE9MU3JaS0FONDVqVUJobE1JUWI4OEtkSENQUkNZYzE3ZlhWZkx3?=
 =?utf-8?Q?Tqit2t?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTlZY0JYTjc4MVowc00wTlVwT2h3L1VGQmtqQmd6Nzl5MnMwTjE3WVVveFJT?=
 =?utf-8?B?bmdud3VjbzhweGR3dWtsSHBhSGZnNkNzTElpZ0pab0FyRE90aVBVQWlpTDF0?=
 =?utf-8?B?QTZEb1VZVlUwcWdJZExUSnRZTXBuSlIvdmFsNU1TclJMZWc2MXEwMmpxZjJW?=
 =?utf-8?B?Ykp0Z3VwMFQ0VlBQWEZubnJmVHdlWmJ0emw3amlITUxNRTg1ZDR1RUlLL1Zs?=
 =?utf-8?B?ZU1ZT3lCcTJSMHlyNEdvRmhwdi9OL2JEaDdTeHFvbkU1U3M5KzRtYjMxaktC?=
 =?utf-8?B?WFVDbXZJc0RtL2hGSW1WL1NRM1hpNkN3TWVvTkZlMm9RSFVLWDhEQmt3OHhP?=
 =?utf-8?B?cjBnRVBnU1hOYncrcVZzYWJrWkdXaDRiT3BlMmdaNTFIODc3cm1EaHFTcExM?=
 =?utf-8?B?bFR3SFBXNERlTmpJK0RqNlNPdVZtN1kyRVVmaHhMTWM1Rkp0VHlBUUdsTllt?=
 =?utf-8?B?WGRldGM2cnhRWnA2cGVwbjAzUG1kalZtYU44MFNRa2JGdjNsbklxK2pSMU9X?=
 =?utf-8?B?K2hSQ0svVVJpY0VVV0ZaLzdEUzZCeEJuZE9wY000dEo3eVBTVkZ4MWNZaWha?=
 =?utf-8?B?NHhYcm54TUNySHliZm9jRzFUTHVOOGVLbEo2eEhSZzJlVWt1eStFSERncVly?=
 =?utf-8?B?eEtmb1UxWDk1TklZRnVqSFlyMDRpbFVMNEEwUFE0OSsyMTRxd01yL0NTMHJD?=
 =?utf-8?B?VlgvSitPcGFYWWNMckFPZ3IvQ0g1SnRobzd0WVJqMzlqVFZLSnVXbk5qcnk5?=
 =?utf-8?B?Ri9nRm1aRitHY09GUnNwU25scXVrbzJnS1BKV0hxSmw0ZlBMV1hqSmdTUWx6?=
 =?utf-8?B?MjdOV0IzMlRMcncyRWs5WHRpYnVlQWU5OFd5Z254bm91NFJNTlR5Mi9WOFdV?=
 =?utf-8?B?bE0rN0VJZnFQV0F0aXRRZ1VMT01KNWRTVkU3ai9sSEZzbHFvNUtTT01iMUdz?=
 =?utf-8?B?L2ZKaklXcjFiTVg3dUVJa1ZHTmtaTzBGRVFvUmF6VXRlUU5keFc0SE5EZUxE?=
 =?utf-8?B?b0xGeHBQbG12RitrZzhsU3NuWTBqcnRYN1VMTzhrU1RnZUhiQTA0QUVtb2RP?=
 =?utf-8?B?WFJnUVdBd3QvTU85Ym56TWk0cTlGaGppaUtSWkptQi9vNzVIaWltRUs2eHgy?=
 =?utf-8?B?dTJkTTR1ZGlKb0tSYnFaRlFDQ3Y4bm5DWEgvUExGYkJZWXdqeW9rakc1WmZi?=
 =?utf-8?B?SXRHd2wwWmNWRkR4VlYyQ21hVFVBTE81T2tINUIzTS9tc1J1TkNVeFpaeG8w?=
 =?utf-8?B?dDdidmY5TUFXRnlpWktMd2JuZ1BIb1pBbE5GNFdFZDF2SWlMZDR0UXdkNkpQ?=
 =?utf-8?B?UFV5ZzNUeVVuM2NuTmFoWkkvNFIzd2NHcC9zNDdGMDV5Zk9oWnZwYVh5R082?=
 =?utf-8?B?b0tzNWFSN0dqYVlGV3NqZ2dtd3pOWU5vZ2szVDdsWVc1eWpYaEw0WkdtcElG?=
 =?utf-8?B?cXA3NEJLVEx3Z1IwWW80L1ZObEZiSDdJVkRUWWZkbnZJSEpnQS80TERzWHNl?=
 =?utf-8?B?NkR3a3RqbStDeGdGK2hmcDZ5UU9pYVJDZUN0Zkd2VjltS1JXeGp1eHhSV0Jm?=
 =?utf-8?B?UTkySVBpSXdrdHRWVmMvZzM4QjZ5bVhrUGdiTDJNQUtJNHVxbXRPYzNLWHlS?=
 =?utf-8?B?Q2E3V09EZ1JaM0VnWXJYZjhiekZrZkVkdzFKMEYrbGZ4OHNhbUY4WEhTRkk3?=
 =?utf-8?B?VTBISUVNbkUwUThlTTdwdWdyUGFta3VqRXpjTzNGOU1WZzlJSG5zZ1FIcnF5?=
 =?utf-8?B?T2gwZFJaNEZhaTZDN1B3Z2t6ZHBDdDRKaDRSNDI0WUNVRnZYRmNGSGZ5Zkdw?=
 =?utf-8?B?SkNQT2hoYVVNZm9qQnVnSXIrUjZnZmxZTFZ6R0RpSDJiaFFEK1pSNkppR1Jk?=
 =?utf-8?B?bU1qdCtDR0N0aVJRdzUzb3RtWEFKZ003TmRWc243S0lheGlrSUlzODJwVjk3?=
 =?utf-8?B?U0tYaEUzcUtjS1ZvSk1MR1JYN2oyMFZ5UFp2d1B6T3E3VlQrRHd6K09iRStW?=
 =?utf-8?B?c1puUG1nSXVRdEYwRFhsdVdUZjZNaFZQdldjcXhyU0xnUlZYa2F6SGgxZTRn?=
 =?utf-8?B?TmdaSVNtR3NBZXpYMVpiZkZIWVBPTlo4b3p4U0lnUktqRmFMRUhmQnpyck15?=
 =?utf-8?B?ZlM1aVZQZVVGNEZpMnZqT3hmb2sxVjBRaHJ2UDBObGFGVVVBOHc2bzhKNEhv?=
 =?utf-8?B?Qnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3F676786D46EB4386A38DAA3A260CE9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 867901b1-b659-47be-88d5-08ddff7f718a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2025 17:41:38.7018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XklkpeR7Hru+IiiWysAF3lCG7WWZvxq9lG/FNUfY1P1G7d/aIqwZk+kq5nZg9ZtL3rbkko6rdhhkSka4uJFVHduc1ZBOdMdd053Qu6xjic8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6E320AF71
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTIzIGF0IDE1OjQ1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
Ky8qDQo+ID4gKyAqIEFsbG9jYXRlIFBBTVQgcmVmZXJlbmNlIGNvdW50ZXJzIGZvciBhbGwgcGh5
c2ljYWwgbWVtb3J5Lg0KPiA+ICsgKg0KPiA+ICsgKiBJdCBjb25zdW1lcyAyTWlCIGZvciBldmVy
eSAxVGlCIG9mIHBoeXNpY2FsIG1lbW9yeS4NCj4gPiArICovDQo+ID4gK3N0YXRpYyBpbnQgaW5p
dF9wYW10X21ldGFkYXRhKHZvaWQpDQo+ID4gK3sNCj4gPiArCXNpemVfdCBzaXplID0gbWF4X3Bm
biAvIFBUUlNfUEVSX1BURSAqIHNpemVvZigqcGFtdF9yZWZjb3VudHMpOw0KPiANCj4gSXMgdGhl
cmUgZ3VhcmFudGVlIHRoYXQgbWF4X3BmbiBpcyBQVFJTX1BFUl9QVEUgYWxpZ25lZD8NCj4gSWYg
bm90LCBpdCBzaG91bGQgYmUgcm91bmRlZCB1cC4NCg0KVm1hbGxvYygpIHNob3VsZCBoYW5kbGUg
aXQ/DQo=

