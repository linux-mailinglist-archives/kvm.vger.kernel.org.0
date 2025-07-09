Return-Path: <kvm+bounces-51947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32322AFEBB4
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22E75175595
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9A7F2E5B05;
	Wed,  9 Jul 2025 14:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AUWOCvUd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344AF2E54BC;
	Wed,  9 Jul 2025 14:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752070174; cv=fail; b=BwrfMqB+rqE5HcarbYJqaTPhG/bvkoGlXrGdc8vdd1jxJ4QjoRyJ+xR0t9W78ulNHS5PDTm9tG4pW3DBSnMd4srZYIHnrk5ZMCpMzcWt47Q6ftskALe6ChhW9vx875lwKUnqxYhkcYQkScMwoWinFZk80Cck4JaOnoX2B8oe+Vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752070174; c=relaxed/simple;
	bh=D5PHrfxmwSDXaNGTB0lkU5Q0whsKUOIvu4HL1AzGKtM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A8aKAoJNttItZlDIWG/84R01y0KJNWlQuacq8BWWwwBb1SGF0IYGlAqL4fGLPFzt0jVFGr1l7WCkobvQaFyBliFyhsgBO6LFyobBQElWw65b8RF70k938bU6IxzA7ipPCGbigCVPgFALmc8xijrD8FrlKi+Uwx5hahPnRgs0ovQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AUWOCvUd; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752070172; x=1783606172;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D5PHrfxmwSDXaNGTB0lkU5Q0whsKUOIvu4HL1AzGKtM=;
  b=AUWOCvUdRMthXWtMKDV2QgbwOkWVvckY1Q51+0L2SuZedygIpewCbtzU
   DehohaJUYSfRbLsDIys5CARPeZZjSpx1RJPNqWO1femENPlOD/OJ1VuxF
   IkSs3r35pmqMA7nWpNQvpaJG/r3jFo2U5qY8kJP2DL0E+Ur0bsXx6HyWf
   XWBWEB0HaW0qmAZqjY0UB5Y3mpJla/NBgPIqBQ/r258iEMBcbWw4bcHUl
   XBKWpEI0CbY5NtZd0w5SLfpqkzspC8f5x0rI8JoRcvz6WXH9QFSQJuKKC
   EzqBi7SbDGBFMf7PSVzLLgV0nd8uqps0eOOGUHrWg2TuTySNbHVbIAEqr
   Q==;
X-CSE-ConnectionGUID: Ti/nmNbsRZi7TmvsPxqWxQ==
X-CSE-MsgGUID: 2NavNZ/aRlKhQL1MGVLspw==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="53440722"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="53440722"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 07:09:31 -0700
X-CSE-ConnectionGUID: T7Z7B2JxRkqhkIrre14Kgg==
X-CSE-MsgGUID: o8BUdLwIRJKdP9vwIp+m8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="156353329"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 07:09:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 07:09:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 07:09:30 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.64) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 07:09:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R0UzjWIacVdOyXQITfojOruL3mNU4zznyBuBDIh33muu6sX9Jwwn4YsVTMFLpphOKkMDuRNXDLviwpO7/YNU9QK+qHg54sHvERvuwfPZ91P/FmVP8XM5AegD7NDNMHHo0Y/0tra3TIOErA3qK4xRl9MBwitZvj4Dun4QRYgWIinL7LKqs8fNCGLUXQ6yqJeduXxnE8c8NQ53xm7nwpU8MYPo8EkAid3YZ9zBtvFpiolePP7q6aTWfE1RQVNSUjhgKglB/LKa0tnYSRPi0ms3Re4NwxCaMfbYiu3GbaEGoNebhW0Ulkf0uYjfBJ60ySA6x4C3sWXC51kKV10TadmdlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5PHrfxmwSDXaNGTB0lkU5Q0whsKUOIvu4HL1AzGKtM=;
 b=t1nOBGWnZWlYksGD10KcDZr99PWbAiKB8E6ibRBMRf6AemOF7NzxKFzp9KcjmVMoM2kE6WkSHN+YOyVi73+BmO33/MJ2a7Ak2nHbvlWHFQ3ZQGxcdVORbDa8N57tGrdJEQtlUja9Xr9TvUFuW6He3NSygADehoExCQ3HX+LFyFJDMJ7wyDO5koVF2q2vCapcSORhgW9hX7/QE7WDU33xiBxadgz/IZB/qgMXZ6DrRbJXjvKptkWFxk3GCHgJNVQy838drnCnxb2zyilm0FlAqqRga8q/4SxTyrf83kLD1T69nV5Ntc/ce7rtO3j1vXhRAAsXE9xgggKugm4+iCpcFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6380.namprd11.prod.outlook.com (2603:10b6:510:1f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 14:09:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Wed, 9 Jul 2025
 14:08:59 +0000
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
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Topic: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Index: AQHbtMXhHrhcZKCSdkuquayYYQc4lbQoYJcAgABV1QCAANDtgIAAxSCA
Date: Wed, 9 Jul 2025 14:08:59 +0000
Message-ID: <f6b76fc5131b2c53d9e37487ded0507820ef56bf.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030428.32687-1-yan.y.zhao@intel.com>
	 <aGzbWhEPhL/NjyQW@yzhao56-desk.sh.intel.com>
	 <9259fbcd6db7853d8bf3e1e0b70efdbb8ce258f8.camel@intel.com>
	 <aG3SnUUwFnIhiBp0@yzhao56-desk.sh.intel.com>
In-Reply-To: <aG3SnUUwFnIhiBp0@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6380:EE_
x-ms-office365-filtering-correlation-id: 6eeb5a6b-019f-4d98-6e75-08ddbef22693
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dWQ4Z0VwZkRwT3QzYW5WcmZlcUxvN1h0SEhkY1AzTFlJV2NndWFDZ2hSQWF3?=
 =?utf-8?B?RW8vUXMvWEFaaGtKQ3dyUUJuMVVlSVhONTJqcC9wRUswUVhiSTc5bElPYWNC?=
 =?utf-8?B?ZG5meU9vWFQ4R3NReUM5MVBVbjkxK0R4anpZZU5uQ05kc3I4MDBnTjlSU0Fm?=
 =?utf-8?B?VWxBVlFZVFpYYVgxNG5QemdDbElENy9kVjJ5NGRsQkt0Rnk5d3luUFNnaXVN?=
 =?utf-8?B?aldPWDdhQlJDM0NObVdicVpRUVMza0lVQXJBYkpOd2F0OHB1My9NZXlQVzU3?=
 =?utf-8?B?RmdIRnhpK2JiWjNtdWE3aXN3Q3drVGpDODloTFdtcVFNOXFTU0RwMVlQVjQv?=
 =?utf-8?B?MDRlcFVNZFBGc0ZRWFV4SEl2eVhWM3oray9kMkdUdzlHUFRwL1QySHFqcGta?=
 =?utf-8?B?NXJLc0luYzlhT3hvVEQyRVU1dm5PS0dMcnJuck1heVNnL1BwaEVEcnBLam91?=
 =?utf-8?B?TUk1TWlSZEsyRUtpdzJhRk1PWEtqK1RITGE5VWl4VE52Y1BZK04vWlZoRlU3?=
 =?utf-8?B?dFduTGtsUGhPekoyWDB3Y3ZWV2g0MEdXOVgwUVVIbnVlWG8yMkhOMURIeHFM?=
 =?utf-8?B?QXRTcUtTRFhxa09IVk9QRS9ibUhUSTJyREFRUysyWEtIUGxzWTZNZS8vZHFN?=
 =?utf-8?B?M2I5bXp1Zmgyb2ZURDZld21HeEVReFBRWjNWYmlMUzM4ODM3cnFRM3VITExY?=
 =?utf-8?B?Njk3bFp3U0R5ZWtSNUUyVjB1cm1VQUYvek1WTHhIWG85VS9YdWg3Y001bytZ?=
 =?utf-8?B?WDJGblgxUm8vWG5qOW54U1YvbEtWS2Z3clB2Nk11ajNOcDdkRW1wbEdzT2Nh?=
 =?utf-8?B?KzBGb3JiZDExbmlFQnpuU0ZQRWxJTnRzL29aTzdmUjEzK3NtYTlIVEdmS1N5?=
 =?utf-8?B?SWRvVEdkdGRNRjhPUUorRWRFYzUvS0ZpYzdVY3Q1REsxK2x3d3l3Q2hwUm5U?=
 =?utf-8?B?RkZDYWNHb2xRckFINHlnSndQSW43N1lUWEkwUXlkTzNJYUl5MHdqanZsZFcy?=
 =?utf-8?B?bU10WTVQVzQxNklVeHU4WkpZbTJaVUtBQUpPd283WUJyVUxrNGhHVlZPejli?=
 =?utf-8?B?L1h1bm1WVm9hb0YyVXF3N1F6Mm9MYTJCVGRIanlJK1lYc3RHTllFTmxPWlRt?=
 =?utf-8?B?T0lzZ0ZwSmszMkptZ2diWHFwWTRDd0FoRndiRXpTckExMHZHTmZxamRneXBk?=
 =?utf-8?B?TnBxVHR6T2tBNXlEUUQ2ZUVsUkhjVXhoUWEvVkRqNlJzc2FiYWM2VXZ5dWxU?=
 =?utf-8?B?V0ZuTHhDV01vSEtOY0lNSlBXQlpIa05KbnFOR21UdzEyTEQwMExDUGZ0Z29R?=
 =?utf-8?B?d1J0ekF0bmhmcU94K1ZYZy9qakRReW1aRm43b3FDNzNOcEJDTGFUYlU2VFor?=
 =?utf-8?B?akxNKzFhU1RZa2VVSWlvb2M1RE9rM1lVOUhRWkRsOGNJMDhrcWwrMkYwOXNN?=
 =?utf-8?B?cytiUTNEdXpTZ1dvTkhGUWZTSWtrd2xER1Nxb0ZCOUFETU0ySS91WkpQNnVF?=
 =?utf-8?B?NzdPMXkweTJpYytOZlRjd3FvV1p3Wi9PS2xrYW5LVTUvNXBkaEltV3ZvOEIy?=
 =?utf-8?B?amp0UlZFOVI5TFlFNjk0V1pvTkM0MmNPMkdnQk9TcEcvRHF5YmpDcXl4SVI1?=
 =?utf-8?B?anRzS1p1NFRMakVTU1hkd2t4U2F0Q3huQmNCcG13MEtTV2E1RGxaTjNiWFJ1?=
 =?utf-8?B?UDhsQ0FLaDFYSmVwU3FZOGZKemxuNkdOc1Z0NHE1MnVqZ0FBdzkwemZTSE9u?=
 =?utf-8?B?QjRKa3lnQ01XOWJqMTUwVHpoNkpybVRBS2hWRlhzZ21BdnA2U1dYUi9taEd6?=
 =?utf-8?B?WGpiSlVMcy9mN2g4a2c5Q3hyaDJ6Z0JRYWFBU1VXdHNBRjEwY0I4UDlDT3pn?=
 =?utf-8?B?bVc4SEgvTTJjTUMvTGlTNVEydS9OSmxranhrOU9CR2ZXYngwTWJMYUVpaGtH?=
 =?utf-8?B?VUlRc044UnZWMlVLd2h1QTBISGQ0dFhTR1IwTmRiRTdwSlljNXNlY1Y0ZHpT?=
 =?utf-8?B?SmRyc1QwWUNnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWN0SHJFTUF4VUY3VVNiWjZlV0QvN0w2YStPOXdTb3BwWGhsd0cxMzFndmRi?=
 =?utf-8?B?QkxxaUtVcUY4dTFZTnpWa2drQnJmSGZXNld1aUVlVDkweDdFUTd0MUlxSTBY?=
 =?utf-8?B?dWdhOEN0SXkxQlRnZFNVZ2x4QnRhVXp0YlNsbDlhZmtCQnh4M1IvSm40QmR6?=
 =?utf-8?B?ZlR0Vk9CS0poVWo1R0NKU3RtR0JBam9CUVRwVzhiTC9WNmRoOUY3YjRncWJa?=
 =?utf-8?B?VEsyUjMxdVFFY3d4VXduZEtUMG44bzdxTUEzL3pQQjNCTDBLN3ZHWWkxdUxC?=
 =?utf-8?B?SkxObisvS2xsbWdDd1Eramt5QlNIY3FudVNrSlcvRjRtbHJuSSttZ094RXhh?=
 =?utf-8?B?UWRlL1IzRlN5VHVxT1RKWDJtdE5vNDN4ajlFblNVTEhETCt6RVZoNThOUmxx?=
 =?utf-8?B?aXFGS1dJbExWYmZsYzBpbHVWcFdlWHN2bTdpVU1yTFlFQWRCaVNiSEovY01l?=
 =?utf-8?B?VnRjSERHSU9nUVV2RzRVb3pVU1NiZFFwRi8vTzJBM0pndkRPRVN0Y2dFZWZ6?=
 =?utf-8?B?dnJyaWNidTZ5QmtoVVA3Mzlick1ucmt2amFkYkhqVDVBRnFiNEo4eDRLeE1z?=
 =?utf-8?B?V3hsczdEVE9kV1l1WllMY3VIdnl0SDV0NHgvWEloSHRadXNKZHFCUDJuS0RU?=
 =?utf-8?B?b2dPazlWL21aemFmQjR5UlJBdmRLM2FucjdyT1pybktHVExpZkdicjl3dWdu?=
 =?utf-8?B?cU13RHNCam5sOWt1cG16aCtrYXRPRFl6T1JYOE9oaXowTFBaU0Y1dmVSckIv?=
 =?utf-8?B?YmoxekMrSEg4dkNnZE1PN2c3OUFHLzJTbWlmd3l6T0tQWGwzS3BYOHhiSGlu?=
 =?utf-8?B?QytxQklIc29MdDNIZXZPSFJ1VDVSSTJXM0YreEVyb2QvYUxIcHFYTWhNazNp?=
 =?utf-8?B?V2hER0xNRzJOQXJNR3VYQ2Z6eW96dVNzS01CTVVIaVpOV0VUbHRsWTQzb05t?=
 =?utf-8?B?R3RMV3pFWEtxRW9uOTZZVnZQU1B0aitiQ2p0Q1pNY05ncWUrNkg5UTNZMmpG?=
 =?utf-8?B?Vzd3V095NFpsYTgrclZvczJXRFBSWE1QTHZrLzhlcEdlQVRKcGNhWFNQL2hC?=
 =?utf-8?B?UjNMcEhYTy84Rk1DSlpCZjFhdzNERmxvVFlKbjJwZkEvd0lkQVFmVGRuTGph?=
 =?utf-8?B?OWswVktXUWVobTBLeUhIWGhhc0FOY2Q1SjFCdlFQSFpNNGcxcVFrbWdmMW12?=
 =?utf-8?B?YlFLaXJGb1N3YXNCTEluMGdYSUw5WTlJQXdZc3p4WlNnT1R0MytuQkRzaWZ3?=
 =?utf-8?B?bmV4QUtqK1Z1VFI3aEQ5Nmg4QVV0TnA1VXFUYXVDK3hFd2x1V1hFcjJPMEJj?=
 =?utf-8?B?Y0ZXcVg0RE1jSHc1RFFocWtYamlNR20rdGxGbElWUko0Si9lWkR1SlBjMy9L?=
 =?utf-8?B?cGphb05rRjVKS2gyYUt5ZFdBUUxyVnFZUVpsUjcrRmpwRVY4WGRSRExoVXk4?=
 =?utf-8?B?OFJhMlFBbjU4SURYVVdVZ3pRZHZudXI4ZURPb1NIZE1hWWdBZWJNL0pWTTBQ?=
 =?utf-8?B?QWYxTlFzYVpzVmJCTkY5MkVDMzY0YlVUNERxa3MwVlhpemd3bUFNR28rcmJr?=
 =?utf-8?B?OThZVnpYZXJtaW9jOHVDeDJkMU1iSm1VajVjWHhuY3ZiM3B4MEl5MlRScm5r?=
 =?utf-8?B?SlpRY3lUcVYvVWNjbGtiRnd5aENnQ2JFQ3pXcmNYQ3UyMWVrNk03bmlhcTNJ?=
 =?utf-8?B?QmJTeEMwa2I5eURYRmJiMFJ4OGhIVzAydHRRZkI0WWdGOEcyRDFBNVJPNkxQ?=
 =?utf-8?B?M1FNdTcxeWx1alZWTkIzdjJvaUE1ZU5lZDRMU0JiT2ZBaHV5WkQ1dUZVRjIv?=
 =?utf-8?B?clF1d0g1bDZTc1ROUVoydUVwSGtmYldQQnZuZHduYnBtSHN4bVA1RmU4MHBE?=
 =?utf-8?B?QTBYK25SVVlQWTRJS053ZFM2dHMrdEpyWERxNDEzSDBYZjFmUGtIMnNhOWVx?=
 =?utf-8?B?NVBOV1hFR3FWemRZb1JQR3g0eHI1eVc3VnNsSTNwVFZJRGgxNEVEMkhIZ2hH?=
 =?utf-8?B?dEFubTIvNzVSWXNuSDVMTHpicEtGSWM5Z0xsSytXTThZMS9FVEttWXg5QmR1?=
 =?utf-8?B?ZTlGRGhoSkgwUCt6eXBRTzVhY29YVGl2YVU5c0NUMWVXVTM3ejgzbkRnQlBn?=
 =?utf-8?B?Wnplei95UlhYaml0Z2FiVXB6b3dCa0c0RzJFalF3eDd5RCtyamw1cElGeWZr?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7188309582F3C949962A5D3725B34455@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eeb5a6b-019f-4d98-6e75-08ddbef22693
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2025 14:08:59.4843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PYqIn0JwwnneQ/xLgkgX2VwgjCBDArKBGGgDg3G17cnu7v5dNF5BjTf8UsCitSDC6KhwAOGCahkRM3ThA+hpjpALRLLGAZSTtIxuDT8rWnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6380
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTA5IGF0IDEwOjIzICswODAwLCBZYW4gWmhhbyB3cm90ZToKCj4gMi4g
dXNpbmcgc3RydWN0IGZvbGlvLCBJIG5lZWQgdG8gaW50cm9kdWNlICJzdGFydF9pZHgiIGFzIHdl
bGwgKGFzIGJlbG93KSwKPiDCoMKgIGJlY2F1c2UgaXQncyBsaWtlbHkgdGhhdCBndWVzdF9tZW1m
ZCBwcm92aWRlcyBhIGh1Z2UgZm9saW8gd2hpbGUgS1ZNIHdhbnRzIHRvCj4gwqDCoCBtYXAgaXQg
YXQgNEtCLgoKU2VlbXMgb2sgdG8gbWUuCgo+IAo+IHU2NCB0ZGhfbWVtX3BhZ2VfYXVnKHN0cnVj
dCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCBpbnQgbGV2ZWwsIHN0cnVjdCBmb2xpbyAqZm9saW8sIAo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgbG9uZyBz
dGFydF9pZHgsIHU2NCAqZXh0X2VycjEsIHU2NCAqZXh0X2VycjIpwqDCoMKgwqDCoCAKPiB7wqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gwqDCoMKgwqDCoMKg
wqAgc3RydWN0IHBhZ2UgKnN0YXJ0ID0gZm9saW9fcGFnZShmb2xpbywgc3RhcnRfaWR4KTvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAKPiDCoMKgwqDCoMKgwqDC
oCB1bnNpZ25lZCBsb25nIG5wYWdlcyA9IDEgPDwgKGxldmVsICogUFRFX1NISUZUKTvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gwqDCoMKgwqDCoMKg
wqAgc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdzID0ge8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC5yY3ggPSBncGEgfCBsZXZlbCzC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIC5yZHggPSB0ZHhfdGRyX3BhKHRkKSzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC5yOCA9IHBhZ2VfdG9fcGh5cyhz
dGFydCkswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAKPiDCoMKgwqDCoMKgwqDCoCB9O8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIAo+IMKgwqDCoMKgwqDCoMKgIHU2NCByZXQ7wqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAKPiDCoMKg
wqDCoMKgwqDCoCBpZiAoc3RhcnRfaWR4ICsgbnBhZ2VzID4gZm9saW9fbnJfcGFnZXMoZm9saW8p
KcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gVERYX1NXX0VSUk9SO8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAKPiDCoMKgwqDCoMKgwqDCoCBmb3IgKGludCBpID0gMDsgaSA8IG5w
YWdlczsgaSsrKcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB0ZHhfY2xmbHVzaF9wYWdlKG50aF9wYWdlKHN0YXJ0LCBpKSk7wqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gwqDCoMKgwqDCoMKgwqAg
cmV0ID0gc2VhbWNhbGxfcmV0KFRESF9NRU1fUEFHRV9BVUcsICZhcmdzKTvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIAo+IMKgwqDCoMKgwqDCoMKgICpl
eHRfZXJyMSA9IGFyZ3MucmN4O8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAKPiDCoMKgwqDCoMKgwqDCoCAqZXh0X2VycjIgPSBhcmdzLnJkeDvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAKPiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0
O8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIAo+IH3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oAoK

