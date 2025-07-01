Return-Path: <kvm+bounces-51157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1218AEEE21
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 08:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0FFA1BC1E34
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 06:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B19248866;
	Tue,  1 Jul 2025 06:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bGvGJ0HQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101522459FD;
	Tue,  1 Jul 2025 06:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751349967; cv=fail; b=bkMyYaHpxt8rmUvhAcmZNiL+YzCZEJLDQf/q7u/0/cVMSmVOUgcqRZdUQp+pRdhAX2WU+pd5zWokbiGX8gZYhK0sm126xEAOxlKZgkZFi4JR2cnxj+eZml9qRxSOegzy7RNIMimid4h+VM2zaLRq8oGZW5Njn/mqANwzT/1kTPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751349967; c=relaxed/simple;
	bh=wR2ny0I/ixWxtM96+7j313IvaWw6IlJzu+58pAqNgfM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m3kDWK+hOJpzWgJlHPvmrD7T8gQbOQ2WYafKUjSeexcGNyGvMr23wpOD0zHIQrPnNQipz+kvReQsa2/qE29Ia5LnDBIa7qPqK8wvSGWzTZ+pOdkQnjrbLvK1OkRITM4IsQLVNe9OAxYHvg3HmiEWDRMDbWfCxRzhAyoc6dTMRhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bGvGJ0HQ; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751349964; x=1782885964;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=wR2ny0I/ixWxtM96+7j313IvaWw6IlJzu+58pAqNgfM=;
  b=bGvGJ0HQ/3OxQGEhbekMIh/Dk8V1sg8xta+W+A2UoLDJNuGoSNN4ekD6
   xodvzRwdRAvUp6Anft5+Ce2oeGtATy/PpN09OyKYIpy2T+V+sHlRL0U1Q
   OCuGknNJSB3/kjVyfaZnCeNXcLArnWfme/PIpBtTC/2zfv8GV3+924Kh5
   yKvce7ScXsAL5K8hnsy6M65LKhtczKYFy0gL5dGJfswTGSo6sqQGUMbxA
   4K6QLuAMQbFykihqjq+FdWAXLRni8gbFhDqtds8R513p9tux5WAqhAHjV
   J4/kyobFQL53HNEMAwCFXmsoy+jd6QXG9Bb22Ygn1kexQklGn4ZaPaUqk
   w==;
X-CSE-ConnectionGUID: YoO09M19S4yM7Org2P879w==
X-CSE-MsgGUID: vPPfunOyR06qOmcwSh4YRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="71022322"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="71022322"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 23:06:03 -0700
X-CSE-ConnectionGUID: BVgoqj1uSouHtZJwR/CwgA==
X-CSE-MsgGUID: G2H+3Tl+R3m5jBIwFUXB0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="154383502"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 23:06:03 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 23:06:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 23:06:02 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.54) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 23:06:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rhk8NYKLJJu0YOPWO8HFZUK+MXeiSq1Od79KcE5NYbvfJnDyeRf8o2Eo2x2Y3GOXBIPLy9M4O+vynzZGy0Qco9o6p0CIhEECPP4kQzu+BCbACtMMJZwSn21zHt4YGfckXOTQ6n4J2Imk21mbRMQ7HdAH9IjGjX7wRnvvLBm849Fj8KQF+pyIVIwQUc+9c50Zf2eJprMl768UtiUketbasjIf4B7P+Of8jsB4eryyWcF6qvOUrKiiHLf2VsQJg1bSld1Q6G1V+fQsdVEnsxZOrbgUynwwieZok/DzgLc7Y0wNvjhg8cc3T/AQXId/3e7sMwu+b3VdWm9eXIXa6Z8t3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgTtbjKU3qGm4ACKsGhLARyYx8be4Jv/TW7MBqIGlAY=;
 b=joHYmjt9rCtAwVe010g0dUED0AfVNtMdMUDqm26S68CAmASiPU0ButBS8rVz++8fE3wdSknP7ZZUaSX3873uDgAg+AZk4qfLkIz8TB3ktpcH4pZAM0zxmgjZodfC3IM6ZSJyR1GCjh+eJLfTBHCthlwlTrhAlsl4Dx8PdZ14mcpQlNZEp6qb7xBh5yE4Xzh2jxF2i7ZR/9fdu0mpZHOzEOMjBE+2zQ+HxTIRiuK1DSfkdeSpBhNUdykQL34byfoe1NpWuJNcvi7rUcgKevX126sElgQhbpQND1MwBHhdSI18qK9imX//4UTRSkfVJkMLogy4fm+cEUU3e/QkNQIjaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPF7CCC4B437.namprd11.prod.outlook.com (2603:10b6:f:fc02::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Tue, 1 Jul
 2025 06:05:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Tue, 1 Jul 2025
 06:05:43 +0000
Date: Tue, 1 Jul 2025 14:03:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aGN6GIFxh57ElHPA@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
 <CAGtprH-csoPxG0hCexCUg_n4hQpsss83inRUMPRqJSFdBN0yTQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH-csoPxG0hCexCUg_n4hQpsss83inRUMPRqJSFdBN0yTQ@mail.gmail.com>
X-ClientProxiedBy: SG2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::18)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPF7CCC4B437:EE_
X-MS-Office365-Filtering-Correlation-Id: 854a32b7-0f44-4260-31f6-08ddb865501a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?azZoZUJBVXoyQ1lYMEtDQ3lwb2lTQk5EMDJpK2ZMTjhiSWhjZXdHa1pnbjAz?=
 =?utf-8?B?RmZta1NhTElFMU5Wb2xsUUVHTFd3WlV6Si9LbEhJYTk3WnJrUnZrRkNYOUF4?=
 =?utf-8?B?VEoxSHZwdFdaTzQxZ0NHd0pVQ2pablVDMytLZEptNDlpckZyRWF4Zk4xUUxY?=
 =?utf-8?B?Qncvc0RtZXNNSVg3NTFwUmVXMnM3MHIrR3pnZGVoTzB4NUpRYVE2UG5TMUJU?=
 =?utf-8?B?VmxuLzJNWE1FN0RHeGZZbEZJQzZCcDZzLzVuaUVjSXNkc051eHAySlk0Tlk1?=
 =?utf-8?B?TGFVZWphanpjLzgzZWRpcE5scXRueC9BUzJJODU3M0o0bVVGd3BwUDJPNm1x?=
 =?utf-8?B?clRRMmRRTUpKVHcrT3ZhZzAwQ1FVWmhReERHb3laa0lSRm9UcjZ1SjE3UklY?=
 =?utf-8?B?YU9laHFxYk5GYUY3MmMrZHZLVXZTNmJBZUdKWklEZEJyMVNsU2RLTnNGaHoz?=
 =?utf-8?B?UlBtOUwxZVZhYkg1VHBjdmJsR01lVExVSjV4R0wxd0dUaTZYM0tHemU5bEE4?=
 =?utf-8?B?ZXZ6MW12ZHZBU2N0Q3VFVDhQUEdxYk85QmtLL3dER3VFVVhXVlVYYUZnVHJN?=
 =?utf-8?B?a2xIUXJKenhIZkkyVHMzODVtaE1wUzM3ZTZibU9LcDFUakt2WXBwL3MxT1pW?=
 =?utf-8?B?UDNaTXpnM2gwb2YwYXNKeGl3NW1GKzVEWGtBSWU5dHE1ZVduMUVVSGhqdDY5?=
 =?utf-8?B?Z0lCckhkTXZqWit6MGw2aEZSeVR3ZmZySmVNYnVQdGJHYXJXZ1JZTmIwUUcw?=
 =?utf-8?B?NmswRlJXaUJTL3dzaGVsWWhyZVFib1dnK0dCNTVzNjZ6S2lFbUJVL1J2Rlk2?=
 =?utf-8?B?dTJPU2YvVFRwVnA0L281cWUyYTFSTXJqRExWMllTMVozM3pZcTkxcjkvNndF?=
 =?utf-8?B?aXhzYkxmejhRNm55YjBlYjlhRlZiS2d1VUVqYW04MjhXSGZvRnhPaG00SmV3?=
 =?utf-8?B?eVI3ZWp1WSs2YUZPQnFvclEzS3dFazFwNmVEdkZDQ3d4Qko1MWo2RUFvcGZ4?=
 =?utf-8?B?NmxmNGVDMHJWVDFBL201SUtIblB6ZTdqOVpsZm9FcU5uTUZiQkF2S2ZlaVFq?=
 =?utf-8?B?YVAvTm1hTGRxampCN2dwVEhaT3c0MklTeVZCdXNyTXdXWlo0SFkvYjlRZWZW?=
 =?utf-8?B?VHlBVFZ3ajZVbURPRVJGWmxJdUxxd3creFV0c1p4UXBWN3lFUGVHRHpYa095?=
 =?utf-8?B?MmFQTFpmRXRDYTRFa3FndlVuNWszbUExNDFGRzRaVkVoMTdUV0xGcTZpelJN?=
 =?utf-8?B?ZTVpd0p2Y3c2QVFNenpQMENSV2hOcG9xdXA1bWoweGRsSWl1Q3Q5eC9ZOWl6?=
 =?utf-8?B?WTRnUXVkeThmRHFyeXNNR1psMGZJWWtZd3RlY1ZGUjh6SWJySklaWVNLc0h3?=
 =?utf-8?B?WS9KMkxNc3VNalh5UDlkVGZiYW9XajQrK2lSMXV1ZFJNZ2pDc01MaW5uczZw?=
 =?utf-8?B?UDJ1ODVJL3VDVFRTOEZUaEJnS2NHUjQrTHo2Qy9zZUJBaDJBR290aW5GQlBI?=
 =?utf-8?B?Nml0bGY1d09UZlhEVlRNOTUwSzRVMlRpZzB6Vmh6bXVuQjJUNWJsZGVVK2FP?=
 =?utf-8?B?bERLZnJnRExnS2xOYk9IUnNadUtIWUNWT2JUODlGVEVuSG44NWFCbnUzbWlM?=
 =?utf-8?B?eDV1U2xhUWRHVmJMS0c0TUF1N050WW5ac3NidTBiVlhubmYzUEFCMmFCMHlM?=
 =?utf-8?B?enAyK0N4aFp2SWhJeE11eTNza2h6SDhxVHViZXExdU1VeWhVRGFRZUNXQjR6?=
 =?utf-8?B?VlBmQVFEbjFHTE1Td0pZWHpteG9TQUg5RnN0TDdyRTgvU1BIR2Z2eHVSUHhV?=
 =?utf-8?B?MyszeUQ2OFI5NlhNelNQV3FoVlEvZlV4cTM3M014dWJjL3FKUDVkK1lqZm9h?=
 =?utf-8?Q?8P0SdK+Suioo1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUtNU01LSEFlSXdxZGNZZE04VzY1S0l5TWloc2FsRHRjM1c0Rm5KTlhLZldx?=
 =?utf-8?B?bndYd1BHZFdFclpDRkdmZDdIMUZFekNFS0Y1Wm5kaUk0Q1NOQ0pkc1IwVk1Z?=
 =?utf-8?B?WTZyeFRlSTR3SXJLZnpIZVJQN01vU3QydFNFUHZDV3Y5b0tWbzFha01ub01l?=
 =?utf-8?B?dUdaMVZiK2l1ME0wWVY5MGV2SURBUUtlcEZlcURBeTlVM1RTcFZzV3ZZZm5X?=
 =?utf-8?B?dzYxNVIzRWZMa3VvaG41eDhOUTV4MGFTUlhtWFRNTkZ3YUtpWXh2Mm9STS9o?=
 =?utf-8?B?M241aUFSc3RTTlRNOFFPN2dyNGV2R3ZYZVBIUE5KUDUwcWdtOFVBMjNJNFJs?=
 =?utf-8?B?QjVXdEhHM05mVTM3QTk0QlNLemVPQVdoWXV3MDFDaGVOZjBJMWZXYndzbHBQ?=
 =?utf-8?B?Y0VhMDd3Y2p6UlgrU3BBNDJBd00wVEdRNWtZUkRRUDQzdGFRR2YrSk5OclFF?=
 =?utf-8?B?ZE9pV1cvTmpPNVZFRFFzZTlkWUdVWTEwMXlIOS9KOVJQUHZXelkwdWZlNFQw?=
 =?utf-8?B?R1pXRUZzVlpxWmhjZS8yY2VsRUovRWllcEx1OHdLUkYrdEdSRXluMTNvamRO?=
 =?utf-8?B?eGxFRXFFQ1h2SkY0R01EUGxiUHBib1ZuRjJ3UnRFczRrUlFPWFNiWHFUS0U0?=
 =?utf-8?B?Vklna3hqSHVXRE1yck05M3pqUytUTGtCejMwTUdxRVFwM3JDa05WTW1nN094?=
 =?utf-8?B?aFM4eE5ENy9WQjBKRTFxODVadCtvdjBkUzV4OTIwOHZtdzJ0M2N5dlpmMlZE?=
 =?utf-8?B?RGRLQmZtTXcxcEF6TTRXbUhtTjlrLzZ5dmdyQnFjUFozU0pIcDlBUkRzVU5q?=
 =?utf-8?B?aVQzdm9INFJzWWJ0OHJmWVlWZkFYNktmdDdXRVNzb0grbG9XU0oxRmRIdWE5?=
 =?utf-8?B?VFFsNS8yWTVXTzNrbXJTcE82Nk5MbWhKNTlxUDJ6RmFJb3hMdXg3WjhXVzBJ?=
 =?utf-8?B?Ym56SUVvMklXZmNpWmJKZlA3VUFsbjU3Y0JmMGwxOXVtWHUwN2pURGhvYUk2?=
 =?utf-8?B?MmsrWWZkWU93SnRHTmVZRW8xWk5WNDg2UGpqU2tYQkV5MGhWRGZtWU1WQ1VW?=
 =?utf-8?B?NjN5eWM3RTIveXN6dXozUk82Vk11Zjc1aWhWekoxOUcwRE9qRWRuaDRMbUZN?=
 =?utf-8?B?cFN0cGNYTG5BVjI4bWxXRjJLY2NNVlpGYklpdU1SYk0vT1I0SldmVnQwSDh1?=
 =?utf-8?B?UkU5bnp0Mm5CNDg1c3VRNHFYN0pDa245NStpRjVLSmIxKzEra243L3BoTUNG?=
 =?utf-8?B?UVZmeUtaL2daWEoyZHFSelZNR012eDFnR2NMbkIrc00vVXk2dXBGMjZwaGNp?=
 =?utf-8?B?V2JxbTBvRlIxYTF2MXZJMmZvMnlhQy9STm9BN0NPc3VWaXJvNkR1TFZreFFD?=
 =?utf-8?B?YUg4YTh4dVNBaEd0SlhNSjRXNGcxMVk0OUNtVFBTbUlZL2txN3dheCtTZmxB?=
 =?utf-8?B?WTZtNEtGdUs0QytiUjJIeFg4MVZQK2Y1S0xiMkxlaTU3ZHFVekxWNU82QXJ1?=
 =?utf-8?B?cWpMdGdIUkdHYWVOZHRLN2N1NWxpWHRtaWlwZGFNQXdnL2lmTDZJK29vNk9D?=
 =?utf-8?B?TlErTjFKdjkxMG1PU3VKNUtDdlFpa2JNY083SHk2ZXR5WVdUL3I5VFFBNFYx?=
 =?utf-8?B?UkVnV09HV1dJRnh3ZHcvWnppS29CNmROWW9IcVI1UFZPYkwxUlFDZE1iVjRD?=
 =?utf-8?B?WVFidnFLY085c3ROckJldGl1cFhpYVg4OU1icFVPZHhBTktyZy9SM1VTS2Rw?=
 =?utf-8?B?dVo1V3lQTnZjK1FRblBqMFYwcFZXNTlKOTYzZHUxRFZDN1ZaWVl3ZEVCTnVX?=
 =?utf-8?B?ZVZhWmNlLzNXcDhDS2pIc3J6c25HbHBKaVpFVG1Lc1ZJVmVtcGFxcnFramMw?=
 =?utf-8?B?SW9jQzRJWG9vNy9jdFUzUzJIcFBOQ05DczdrcWtlTDVISHcwaVRsb3gxT2w5?=
 =?utf-8?B?eEV3QVptSHJxWWVNWTFrb3VuR1B0TjRuSWF4NjVnVk80enp0c3NEc2tGZUov?=
 =?utf-8?B?cW9YT0RScTlWU0cyZEhSaTM3NGdZbm9hT2pqbXp5ZEZURGFWWDNxU3F5anFa?=
 =?utf-8?B?UlB1VHh1dXZTVFM3em1JR0hzdEpVNjQ0QmJZaS9aK3NJRytRL1VoeURjdTQr?=
 =?utf-8?Q?IYpj4wohVem7mYkse3MLBAaLI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 854a32b7-0f44-4260-31f6-08ddb865501a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 06:05:43.3338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvC6urgKEVRLXtl8cUavZziKwKr/xKCPq3GtpzS2jH0mvJIkgMpNQ6er3gyT5cLfPkhFFqpF3fOcGOvE9DMKLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF7CCC4B437
X-OriginatorOrg: intel.com

On Mon, Jun 30, 2025 at 10:22:26PM -0700, Vishal Annapurve wrote:
> On Mon, Jun 30, 2025 at 10:04 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, Jul 01, 2025 at 05:45:54AM +0800, Edgecombe, Rick P wrote:
> > > On Mon, 2025-06-30 at 12:25 -0700, Ackerley Tng wrote:
> > > > > So for this we can do something similar. Have the arch/x86 side of TDX grow
> > > > > a
> > > > > new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs out of
> > > > > SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAMCALLs
> > > > > after
> > > > > that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in the
> > > > > system
> > > > > die. Zap/cleanup paths return success in the buggy shutdown case.
> > > > >
> > > >
> > > > Do you mean that on unmap/split failure:
> > >
> > > Maybe Yan can clarify here. I thought the HWpoison scenario was about TDX module
> > My thinking is to set HWPoison to private pages whenever KVM_BUG_ON() was hit in
> > TDX. i.e., when the page is still mapped in S-EPT but the TD is bugged on and
> > about to tear down.
> >
> > So, it could be due to KVM or TDX module bugs, which retries can't help.
> >
> > > bugs. Not TDX busy errors, demote failures, etc. If there are "normal" failures,
> > > like the ones that can be fixed with retries, then I think HWPoison is not a
> > > good option though.
> > >
> > > >  there is a way to make 100%
> > > > sure all memory becomes re-usable by the rest of the host, using
> > > > tdx_buggy_shutdown(), wbinvd, etc?
> >
> > Not sure about this approach. When TDX module is buggy and the page is still
> > accessible to guest as private pages, even with no-more SEAMCALLs flag, is it
> > safe enough for guest_memfd/hugetlb to re-assign the page to allow simultaneous
> > access in shared memory with potential private access from TD or TDX module?
> 
> If no more seamcalls are allowed and all cpus are made to exit SEAM
> mode then how can there be potential private access from TD or TDX
> module?
Not sure. As Kirill said "TDX module has creative ways to corrupt it"
https://lore.kernel.org/all/zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki/.

Or, could TDX just set a page flag, like what for XEN

        /* XEN */
        /* Pinned in Xen as a read-only pagetable page. */
        PG_pinned = PG_owner_priv_1,

e.g.
	PG_tdx_firmware_access = PG_owner_priv_1,

Then, guest_memfd checks this flag on every zap and replace it with PG_hwpoison
on behalf of TDX?

