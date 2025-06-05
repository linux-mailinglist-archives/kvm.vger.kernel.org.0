Return-Path: <kvm+bounces-48464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B9FACE868
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 04:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 021BE16CED4
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 02:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735C81F4736;
	Thu,  5 Jun 2025 02:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="errBmt2y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F904136348;
	Thu,  5 Jun 2025 02:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749091515; cv=fail; b=S7OGtWoUr6QM5GwHm8O9owanKU4ds4ERIHlAwqXTlY5Io7zQXBfKsKZQSn0nyHgkzzgZtch9gC2iXC4dglhVePqupmnFAYxZAET3CeeHaNR81C7ZTxhIFh1vcBRnky9bY+d5GJNiNiZpBrzAmOmO4vyhnVxR5/xnFvIMvh3EIjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749091515; c=relaxed/simple;
	bh=JxWGABUB7mCXL3ILyaD0MRdTpE2lPTKMFCUpzcsXpoQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fRklFZRgg+bQXJCU3KTzi8TS3cxQ97d4tR7xOjwn86pxk+ABGZDKjI89UxywKkcs0RmdR07hqT8mkgl0bxbjCqgv6yTyuAIm3Un9aetq+2ttK4wraoxz/o2rLMOXt3YwEEuwVfCHayQCoJ+ku0KieIUR9ybbN6EiaYaRF0RFX14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=errBmt2y; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749091514; x=1780627514;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=JxWGABUB7mCXL3ILyaD0MRdTpE2lPTKMFCUpzcsXpoQ=;
  b=errBmt2yDxGooNsBLJLwR5kEKA33Xls4OrTVNcTmqG3IuojtrShs1glv
   Ywq23AiyXM4BimZyRIQAkvLSnWOMBApNbTJTWtrDHdzCixEQxU2GK++jE
   YRkaacugJHSsLMoSFWZC/kydAysjwSNC1qr0lYWubgmnLXUjTqcrQijBZ
   MbOz2VUg3ZK+9KUgyknEkSPTcDvqtb2gvcznRKj7nAg1PtmFWAEFWc73t
   LTwHpB+8dXbtMbUa16862qYgoInExAjXk8QFDHle84Tpg8dyz1OH+uMUf
   W4xV4SGPq4nIWtqFn17y8BIm2SoB/0SPZv7gAGyKaZxIolxDSpTLl3mpZ
   g==;
X-CSE-ConnectionGUID: d2Bf6/u/SUmKt3Mk83hJWw==
X-CSE-MsgGUID: Gdh/8HixTViZl6zsa88t0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="50891275"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="50891275"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 19:45:13 -0700
X-CSE-ConnectionGUID: kkgP75UBQ+qg+q82bTr0RA==
X-CSE-MsgGUID: pVN+95yMQ7KpHu1PRgchGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="145257983"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 19:45:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 19:45:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 19:45:11 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.65)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 19:45:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qoIP/Okx6Z1NSs2LLK8g9Np3scJrcksVHsuMzf9aX7ZjiPv/0RkHxWyOi2Tav2vYSK5L4ST71txdLjfIfNrkYtfu+Wjb7eYHGyxFHmHLHYbfOqV+l4r0OFmk5CYIyauNFEA7jWcMuNaNhX5Yi/NcXEhqaOca3j0HvB3OVVFgrf15mO/vpRNqElht17HnZwSTLh4ZM55/kiEmf0zkyzIP3oBL2DDAMTpOyGJI4/WjIA/Qrpdyip4RV99FSgow0mdjrxeFZ1YAAF8ckqVmupyQkYdqMZ7M7HEox6mjDLuvFBrzyN1rJHiMpKcZnDXm7phU5a22RnX/UXTCY2nleBTHUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8yobr97dUaJ+MaBzRGCLFVjVCH6rvNZcmAhCAl77F0=;
 b=XYSB+yOjtpG6ic9eA0v3kZMZihOd0OLbON/RhrJEoLuCKV2LemCpkkXe3tfuWqoIvDjp3wW4HFwYgp7nTzIVMhypLe/+iq/ePP6FhYJDh3+ib4wVgxmFj/3M2rla84SI2lyZ+hYE1gWn8Uya4rqssYTqqqhTsWVITz2Dzk7vLuqZlWWr/QZn2QDZ/a4M+StWiNB+Q+U+oqDtA5roC/xD9tbZKtSxpmasefeiutx4X4n2EaaUNha29Ow3BSI299uMO902Y8g+10d3/DT1LcNh8hs65wuyFPSzxIL/pvtB6J/jQgmcBV6/vevQr9M+1k7yqh32utv6NtuW0mFt8WczjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7994.namprd11.prod.outlook.com (2603:10b6:806:2e6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Thu, 5 Jun
 2025 02:45:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8769.037; Thu, 5 Jun 2025
 02:45:08 +0000
Date: Thu, 5 Jun 2025 10:42:45 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <vannapurve@google.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SI2PR01CA0038.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7994:EE_
X-MS-Office365-Filtering-Correlation-Id: 21a5c58d-df81-4137-a76f-08dda3dafbf9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RlUxd0Q1bnFHUTlWQlBvZ0dPVEhoTTA0T3cwSEFBaWF6S0VOUXFJK25JbjdK?=
 =?utf-8?B?VG4xaCtDTWlONk85YUg4N3Irc1dqMDZ5VFpKOGRYOTR1S0cwOG44UzdHR3g1?=
 =?utf-8?B?Y3RGRWV4QmZDMGhxdXo2SVAxRXJoanZBSDhySGFkWGpMQm5hMU93T1A4NThY?=
 =?utf-8?B?bTJMMWZ1YjBkanJPWWFWN1lXdS9aV1RKbGcxWjlEaG9FODZjL004N0RibElL?=
 =?utf-8?B?TU4wQjdmMVF1L0RtMFBKa0JtS2RlSm1YWXRJYTdnOGRlMG1mWmtqR1FnZSs0?=
 =?utf-8?B?c3Z6VXh0L0FabFdlUzM3cjFmek9HZXpoR3FseW94QlF6L21HS1dUODMzaWVK?=
 =?utf-8?B?ejNUeUJqanI1NWJCNXJCc2ZIZzh6ZHZFYjQwVDlzZDNLazdGUXJNQU04Y0Qv?=
 =?utf-8?B?SmM2YURvSXJIUWNTSjFqSDJrWmZ4NmNxM045TEpGamRBREZkWWo1dVNWbjhD?=
 =?utf-8?B?c1l0UncvMnE3TGFKVnZ5QVJhWExKL0hwTUpRRndRMyt2MFZoMlV5QTc3WWp0?=
 =?utf-8?B?NFJIdVZqWWV5MHJ2c2w4Tjh2VWJRK2dlS1lUeHlFQTF1S1U3TGh2ckRBMGVO?=
 =?utf-8?B?UlpjTW1zd1lBS3lQdm1GczROK0crS3hqMDNJUDVQTHg1QkpwRThQK2loTnVF?=
 =?utf-8?B?eVo1K2dLOXA0N1ZFMVdwTVJhcXdMbzlOa3dDRlN2T1V0ZWEyTVFiMzZPYzBO?=
 =?utf-8?B?a0Q5V0xsZEtjWXFLNlU0Qm1sV2h4ZU1VbnBrcUpXWVdxTFozVEVnWUtVZkxZ?=
 =?utf-8?B?V1dnZFVuZ1I4aWlldllRUXgxcHA5TnIzTGMxcDhpVnJrUzhEWGMwRnZUemtI?=
 =?utf-8?B?TXJMTUR3bmg3dEdyenRUTklDbEF3UHUwcFBGV2NtWWVMQ0FpM3ZqdGNTZXhR?=
 =?utf-8?B?YjlWUlRjamQydko1aEJ6U3VST08xNE80MEdJMXcxU0JuQngvQmlZL1FCcUdV?=
 =?utf-8?B?ODREN2VVWE9XUGRSRWNxRFVRb1dYUnphZjRQQVptK0NwVytYdHlobkZhcENQ?=
 =?utf-8?B?Q3hhSzRQZDdIUWh1THhZRkM2U0tuVkdLQ3IyY1NnTml0WGdPRkcyYkNNOEhE?=
 =?utf-8?B?ckwxKzd4Tjc5cGdFbERkbk1UTCtwYWMvdWNDMSsxYWZtNG1RSm85MzM2ekN0?=
 =?utf-8?B?VW9EOFR3ZzRUTER1T0hJNFJQa05zUEJuazFCeCtFb1NFbkFkWWpXSSs3d2pl?=
 =?utf-8?B?ZHZGTXNJYVlHYVBDNGVmakZSTkZpMWlvVXdMQW5BdCt4YVRYTGh3UCtab0Ja?=
 =?utf-8?B?RnJEWGVvM1BRQXlManhpZDcyMlloTURqTmFKUEhHTlhCanZ0b243UDE5WlJK?=
 =?utf-8?B?M20zYTRSQ3Fyb1YwSFRJQWdEeFdyR3FKOXIxMUlScVJIZ1dnVUxxOWpuYyt2?=
 =?utf-8?B?REF2b3prSS8zUjFYTkxuMFV5WWxYTmlmVzMramNhS2pIWFN6MXIzRnI2K2p5?=
 =?utf-8?B?YjFFRkltQ1dJRy9uek8zRlJ4eUlabE9zS2wxZ1ZnWHljTzA4R1hod0srUEVK?=
 =?utf-8?B?MWVYUVI5NkRMalgvNEpRU09HcUJlUGh3Z0pvek9qbGw3bFhBaXZLamllT3VP?=
 =?utf-8?B?L1h0SWNCbEcybU84MjZjeVVzS0dJd3VmSlhVVS93TjhwQVFuVExLS3hEZHY4?=
 =?utf-8?B?dkxMbEhQVXEzN2lROThHQmxERkxHN0hCYkNjWlRHM3lsemFscWU1elBrNXZ6?=
 =?utf-8?B?ZjRrbXZ5anJRWFdPa0tRTU9tWnFkSlA3ZVhKRXY4UksvdTdhZklrc2dFYXQ3?=
 =?utf-8?B?TitHYkkrcnh6cmpWbGw5cVRtdW9NeW5ocmpBMnQzQ2M0cW5tTGQ4bUhwa2JN?=
 =?utf-8?B?OVF2TjJBRjlvVFFveHhtSXlpRUJwc0NyRzNEVXF2c1N0akV0N1RqRnltZ2Zo?=
 =?utf-8?B?elV3RnVIL3NUSk5ZT1ZEbFplaHYzSnlsZmNxQjQ0TEJRVnVnQ2FWT3hSaWhD?=
 =?utf-8?Q?4PoL2siABpw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGxuc2lscW9wQVgwS0R1VGIzTUxwZUxmMTdPeWgzaElPNnRseFU0RTBMbHo2?=
 =?utf-8?B?WlBaUUlTd3dGd0t2bmJxRmNqYUVmRmhvMVcxTzRyT2dqZUY2TTZXMkc5VHA4?=
 =?utf-8?B?Njhtdy9ldTJ3WTBFc2I0UStYdmZHdGNiWG1oTG5tK0xRSS93TTlGalN3anQv?=
 =?utf-8?B?UTUxeXdRN01HRngrcVhnVlF5K0dYQ2lTT1NKZW5wQU5BUTZrZHJ0SnVoYTJm?=
 =?utf-8?B?dkN5UDgyTy84QVdtandLL0tWVTZ1akxBWStwdVhIUWtzeFhxMnBTQnBVMGcw?=
 =?utf-8?B?VGJMb2xERjd5OXkrS05ISU5SL0FmT21sTkdNblp0aVMraHFHRVkwdkNXSVEx?=
 =?utf-8?B?ZFlIbkx4bmtVRVVaUEx6cFUvd0p5eUVIeFVsNENSdzk4bXJBd0x6anVGQ1Qy?=
 =?utf-8?B?OHphT0xqWG5sNVhIVU1XSkw2T1lPYVBTYzFnOVNlcmdvMlUvME96UEpCSStt?=
 =?utf-8?B?dEEvRnVPNUlKY0tZNnNoQ1h3L1RGeURDdHdaSnpVakZmcDdCNkF6OXF6cWI3?=
 =?utf-8?B?TllhRHFNTEkyejFTVGxMRDdCbWlQVmEzejBUV0FtM3YvZkNvREFoR3Fwem8w?=
 =?utf-8?B?QTRHNlFvbno4NjI4Q2QzbTBKRWNHYXo4am9NdkloanVNcXVmSTM1K0pES2g3?=
 =?utf-8?B?c0oyUU5BV3ZjMnVBRnJPRjlqeGY0R0J5TW5kL0ZsUmhRdG1MQTBFaFFkQUl3?=
 =?utf-8?B?RWVGRXh5TGlkUXFHMG11REJCV2owQ0k2ZWVtUTJYbldPWXhxL25rM1pvTmg1?=
 =?utf-8?B?N1FBcHdSUmNMTGl0d1hMS0dwNTgvZVdoeVV6OUljZFRoMDR5dDhJWXQvVVoz?=
 =?utf-8?B?NTl5U1pXRXFXNEE5TDBucGM4RXBKMWZJVDkrTTRnWldTS2c3dnpvaHZ6ZjhY?=
 =?utf-8?B?ckV6RGVSRlRoQTFUR0lPSnRHR3NheHF0cUc4UGJTeEh6a3g5YWV0dER3NHpT?=
 =?utf-8?B?WjVZZHl0eWY5UWJtbVdnMXZUb0UyUDYwcCtaL050N0laMEFST3F4bkZGbURn?=
 =?utf-8?B?cmJlejA2c0EyZDBvUVJrdjJPQVJ4R29yRjRvN29MMEhVWGlybUQ1emJtSENR?=
 =?utf-8?B?M3JnbUJOVkZVc3JPMktPbTRsb1pPRHdjcjNveGZLU1o4MEhXbk8vVloyNEds?=
 =?utf-8?B?NnVyM0lKWEFmS0VMcG9Nam1aV09PMWRDVHdNNXlOZFBOeVdxVHNtcXBPOVY5?=
 =?utf-8?B?b0dqTDRYTHFkWVZOdEtpTmNDZTlOOVIyejV4ZXZLZnd5aTBNakpHWi9zbHpN?=
 =?utf-8?B?aEpPMFJvaW0zNGlBbWNjbVhCZ2krR0hMSTQ3c0pvaGgvT0g1SmN6Q25sblVO?=
 =?utf-8?B?V1lHbDJydW44bDJBU1hEajYySXIzN0NSVEdQanVGRmptWjIyTkw2bWIydURv?=
 =?utf-8?B?aGhEV1U1UEN2WHl4TDl0RUFKM1I2M0dpTnZUaHRvOVhEcXBqN0RGdG9aZGE1?=
 =?utf-8?B?N3lLZTNoSTRVeUJRUUtFQk9BMzlzSUdDbnhwbU1HcGFNb3lsSUlncld0R2Zx?=
 =?utf-8?B?NXV5MEVyOTQ5Y2RJWkRhZ2hCcG55czV4aDM5S0xuRHRFN1R0Q3dFMlFvS1ZC?=
 =?utf-8?B?clRZbnFjOHNFbkpGd1daWjNkVy9GQkZyUkdBRXJRMG5TcEJpdUxrRGF5V2ZX?=
 =?utf-8?B?TG10c09pWVU2Qkp0ZEpweUdaQmtXSG1rbDBQKzhucGNkK0lNbFNXZDlDNUw3?=
 =?utf-8?B?REVvTU5CeHZVeXdEUWdtZ3N3S2dicmNXSXpVcmpIUDhuSVJvMjhld0FGTjRx?=
 =?utf-8?B?K3FzMTJ2YTdqQzF3SzZiaW5IcE0vQWNSMExocTlvM2NlWVpmUGhRdFRGelpI?=
 =?utf-8?B?R1hEdnBjU251TTFjWUdqTW9RK1gzMUczTlFJNWhmUllMQ3pPUjQ0bWpqNTJR?=
 =?utf-8?B?d2piaDlzTTFXZVp4M3p6WVgxeFpNMnAwcXVSeERydXRNY3lpU2c2T0RGZGhH?=
 =?utf-8?B?ajBwM3BLcUZYTHRNcUNqa3FRT1J1RzZJUTBCaWtUbVUweThsTXRJRllPV3Zz?=
 =?utf-8?B?Q3N4d0c1ZXd1ZENFYW1EQ1dWNklVWE95OWpFRXJ2M0RSWEJaR29aQnpFMkov?=
 =?utf-8?B?VTdLaEVjbFhoNC9qd0F2azBBbTBzKy8wWjdNcjVKR3FZZENZV0w1djhjWkFD?=
 =?utf-8?Q?XehYO4XJCzzi8VtfmpJg0kizk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21a5c58d-df81-4137-a76f-08dda3dafbf9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 02:45:08.5777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MlEgjnQg5yo+H7dOucArg+aFPrlCe5m1mNUP70R9UlT+91rK8VrzDtSeCxbwBunkM8hwZ+mtQU6Aj8I+EIgpfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7994
X-OriginatorOrg: intel.com

On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Mon, May 12, 2025 at 09:53:43AM -0700, Vishal Annapurve wrote:
> >> On Sun, May 11, 2025 at 7:18 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >> > ...
> >> > >
> >> > > I might be wrongly throwing out some terminologies here then.
> >> > > VM_PFNMAP flag can be set for memory backed by folios/page structs.
> >> > > udmabuf seems to be working with pinned "folios" in the backend.
> >> > >
> >> > > The goal is to get to a stage where guest_memfd is backed by pfn
> >> > > ranges unmanaged by kernel that guest_memfd owns and distributes to
> >> > > userspace, KVM, IOMMU subject to shareability attributes. if the
> >> > OK. So from point of the reset part of kernel, those pfns are not regarded as
> >> > memory.
> >> >
> >> > > shareability changes, the users will get notified and will have to
> >> > > invalidate their mappings. guest_memfd will allow mmaping such ranges
> >> > > with VM_PFNMAP flag set by default in the VMAs to indicate the need of
> >> > > special handling/lack of page structs.
> >> > My concern is a failable invalidation notifer may not be ideal.
> >> > Instead of relying on ref counts (or other mechanisms) to determine whether to
> >> > start shareabilitiy changes, with a failable invalidation notifier, some users
> >> > may fail the invalidation and the shareability change, even after other users
> >> > have successfully unmapped a range.
> >>
> >> Even if one user fails to invalidate its mappings, I don't see a
> >> reason to go ahead with shareability change. Shareability should not
> >> change unless all existing users let go of their soon-to-be-invalid
> >> view of memory.
> 
> Hi Yan,
> 
> While working on the 1G (aka HugeTLB) page support for guest_memfd
> series [1], we took into account conversion failures too. The steps are
> in kvm_gmem_convert_range(). (It might be easier to pull the entire
> series from GitHub [2] because the steps for conversion changed in two
> separate patches.)
> 
> We do need to handle errors across ranges to be converted, possibly from
> different memslots. The goal is to either have the entire conversion
> happen (including page split/merge) or nothing at all when the ioctl
> returns.
> 
> We try to undo the restructuring (whether split or merge) and undo any
> shareability changes on error (barring ENOMEM, in which case we leave a
> WARNing).
As the undo can fail (as the case you leave a WARNing, in patch 38 in [1]), it
can lead to WARNings in kernel with folios not being properly added to the
filemap.

> The part we don't restore is the presence of the pages in the host or
> guest page tables. For that, our idea is that if unmapped, the next
> access will just map it in, so there's no issue there.

I don't think so.

As in patch 38 in [1], on failure, it may fail to
- restore the shareability
- restore the folio's filemap status
- restore the folio's hugetlb stash metadata
- restore the folio's merged/split status

Also, the host page table is not restored.


> > My thinking is that:
> >
> > 1. guest_memfd starts shared-to-private conversion
> > 2. guest_memfd sends invalidation notifications
> >    2.1 invalidate notification --> A --> Unmap and return success
> >    2.2 invalidate notification --> B --> Unmap and return success
> >    2.3 invalidate notification --> C --> return failure
> > 3. guest_memfd finds 2.3 fails, fails shared-to-private conversion and keeps
> >    shareability as shared
> >
> > Though the GFN remains shared after 3, it's unmapped in user A and B in 2.1 and
> > 2.2. Even if additional notifications could be sent to A and B to ask for
> > mapping the GFN back, the map operation might fail. Consequently, A and B might
> > not be able to restore the mapped status of the GFN.
> 
> For conversion we don't attempt to restore mappings anywhere (whether in
> guest or host page tables). What do you think of not restoring the
> mappings?
It could cause problem if the mappings in S-EPT can't be restored.

For TDX private-to-shared conversion, if kvm_gmem_convert_should_proceed() -->
kvm_gmem_unmap_private() --> kvm_mmu_unmap_gfn_range() fails in the end, then
the GFN shareability is restored to private. The next guest access to
the partially unmapped private memory can meet a fatal error: "access before
acceptance".

It could occur in such a scenario:
1. TD issues a TDVMCALL_MAP_GPA to convert a private GFN to shared
2. Conversion fails in KVM.
3. set_memory_decrypted() fails in TD.
4. TD thinks the GFN is still accepted as private and accesses it.


> > For IOMMU mappings, this
> > could result in DMAR failure following a failed attempt to do shared-to-private
> > conversion.
> 
> I believe the current conversion setup guards against this because after
> unmapping from the host, we check for any unexpected refcounts.
Right, it's fine if we check for any unexpected refcounts.


> (This unmapping is not the unmapping we're concerned about, since this is
> shared memory, and unmapping doesn't go through TDX.)
> 
> Coming back to the refcounts, if the IOMMU had mappings, these refcounts
> are "unexpected". The conversion ioctl will return to userspace with an
> error.
> 
> IO can continue to happen, since the memory is still mapped in the
> IOMMU. The memory state is still shared. No issue there.
> 
> In RFCv2 [1], we expect userspace to see the error, then try and remove
> the memory from the IOMMU, and then try conversion again.
I don't think it's right to depend on that userspace could always perform in 
kernel's expected way, i.e. trying conversion until it succeeds.

We need to restore to the previous status (which includes the host page table)
if conversion can't be done.
That said, in my view, a better flow would be:

1. guest_memfd sends a pre-invalidation request to users (users here means the
   consumers in kernel of memory allocated from guest_memfd).

2. Users (A, B, ..., X) perform pre-checks to determine if invalidation can
   proceed. For example, in the case of TDX, this might involve memory
   allocation and page splitting.

3. Based on the pre-check results, guest_memfd either aborts the invalidation or
   proceeds by sending the actual invalidation request.

4. Users (A-X) perform the actual unmap operation, ensuring it cannot fail. For
   TDX, the unmap must succeed unless there are bugs in the KVM or TDX module.
   In such cases, TDX can callback guest_memfd to inform the poison-status of
   the page or elevate the page reference count.

5. guest_memfd completes the invalidation process. If the memory is marked as
   "poison," guest_memfd can handle it accordingly. If the page has an elevated
   reference count, guest_memfd may not need to take special action, as the
   elevated count prevents the OS from reallocating the page.
   (but from your reply below, seems a callback to guest_memfd is a better
   approach).


> The part in concern here is unmapping failures of private pages, for
> private-to-shared conversions, since that part goes through TDX and
> might fail.
IMO, even for TDX, the real unmap must not fail unless there are bugs in the KVM
or TDX module.
So, for page splitting in S-EPT, I prefer to try splitting in the
pre-invalidation phase before conducting any real unmap.


> One other thing about taking refcounts is that in RFCv2,
> private-to-shared conversions assume that there are no refcounts on the
> private pages at all. (See filemap_remove_folio_for_restructuring() in
> [3])
>
> Haven't had a chance to think about all the edge cases, but for now I
> think on unmapping failure, in addition to taking a refcount, we should
> return an error at least up to guest_memfd, so that guest_memfd could
> perhaps keep the refcount on that page, but drop the page from the
> filemap. Another option could be to track messed up addresses and always
> check that on conversion or something - not sure yet.

It looks good to me. See the bullet 4 in my proposed flow above.

> Either way, guest_memfd must know. If guest_memfd is not informed, on a
> next conversion request, the conversion will just spin in
> filemap_remove_folio_for_restructuring().
It makes sense.


> What do you think of this part about informing guest_memfd of the
> failure to unmap?
So, do you want to add a guest_memfd callback to achieve this purpose?


BTW, here's an analysis of why we can't let kvm_mmu_unmap_gfn_range()
and mmu_notifier_invalidate_range_start() fail, based on the repo
https://github.com/torvalds/linux.git, commit cd2e103d57e5 ("Merge tag
'hardening-v6.16-rc1-fix1-take2' of
git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux")

1. Status of mmu notifier
-------------------------------
(1) There're 34 direct callers of mmu_notifier_invalidate_range_start().
    1. clear_refs_write
    2. do_pagemap_scan
    3. uprobe_write_opcode
    4. do_huge_zero_wp_pmd
    5. __split_huge_pmd (N)
    6. __split_huge_pud (N)
    7. move_pages_huge_pmd
    8. copy_hugetlb_page_range
    9. hugetlb_unshare_pmds  (N)
    10. hugetlb_change_protection
    11. hugetlb_wp
    12. unmap_hugepage_range (N)
    13. move_hugetlb_page_tables
    14. collapse_huge_page
    15. retract_page_tables
    16. collapse_pte_mapped_thp
    17. write_protect_page
    18. replace_page
    19. madvise_free_single_vma
    20. wp_clean_pre_vma
    21. wp_page_copy 
    22. zap_page_range_single_batched (N)
    23. unmap_vmas (N)
    24. copy_page_range 
    25. remove_device_exclusive_entry
    26. migrate_vma_collect
    27. __migrate_device_pages
    28. change_pud_range 
    29. move_page_tables
    30. page_vma_mkclean_one
    31. try_to_unmap_one
    32. try_to_migrate_one
    33. make_device_exclusive
    34. move_pages_pte

Of these 34 direct callers, those marked with (N) cannot tolerate
mmu_notifier_invalidate_range_start() failing. I have not yet investigated all
34 direct callers one by one, so the list of (N) is incomplete.

For 5. __split_huge_pmd(), Documentation/mm/transhuge.rst says:
"Note that split_huge_pmd() doesn't have any limitations on refcounting:
pmd can be split at any point and never fails." This is because split_huge_pmd()
serves as a graceful fallback design for code walking pagetables but unaware
about huge pmds.


(2) There's 1 direct caller of mmu_notifier_invalidate_range_start_nonblock(),
__oom_reap_task_mm(), which only expects the error -EAGAIN.

In mn_hlist_invalidate_range_start():
"WARN_ON(mmu_notifier_range_blockable(range) || _ret != -EAGAIN);"


(3) For DMAs, drivers need to invoke pin_user_pages() to pin memory. In that
case, they don't need to register mmu notifier.

Or, device drivers can pin pages via get_user_pages*(), and register for mmu         
notifier callbacks for the memory range. Then, upon receiving a notifier         
"invalidate range" callback , stop the device from using the range, and unpin    
the pages.

See Documentation/core-api/pin_user_pages.rst.


2. Cases that cannot tolerate failure of mmu_notifier_invalidate_range_start()
-------------------------------
(1) Error fallback cases.

    1. split_huge_pmd() as mentioned in Documentation/mm/transhuge.rst.
       split_huge_pmd() is designed as a graceful fallback without failure.

       split_huge_pmd
        |->__split_huge_pmd
           |->mmu_notifier_range_init
           |  mmu_notifier_invalidate_range_start
           |  split_huge_pmd_locked
           |  mmu_notifier_invalidate_range_end


    2. in fs/iomap/buffered-io.c, iomap_write_failed() itself is error handling.
       iomap_write_failed
         |->truncate_pagecache_range
            |->unmap_mapping_range
            |  |->unmap_mapping_pages
            |     |->unmap_mapping_range_tree
            |        |->unmap_mapping_range_vma
            |           |->zap_page_range_single
            |              |->zap_page_range_single_batched
            |                       |->mmu_notifier_range_init
            |                       |  mmu_notifier_invalidate_range_start
            |                       |  unmap_single_vma
            |                       |  mmu_notifier_invalidate_range_end
            |->truncate_inode_pages_range
               |->truncate_cleanup_folio
                  |->if (folio_mapped(folio))
                  |     unmap_mapping_folio(folio);
                         |->unmap_mapping_range_tree
                            |->unmap_mapping_range_vma
                               |->zap_page_range_single
                                  |->zap_page_range_single_batched
                                     |->mmu_notifier_range_init
                                     |  mmu_notifier_invalidate_range_start
                                     |  unmap_single_vma
                                     |  mmu_notifier_invalidate_range_end

   3. in mm/memory.c, zap_page_range_single() is invoked to handle error.
      remap_pfn_range_notrack
        |->int error = remap_pfn_range_internal(vma, addr, pfn, size, prot);
        |  if (!error)
        |      return 0;
	|  zap_page_range_single
           |->zap_page_range_single_batched
              |->mmu_notifier_range_init
              |  mmu_notifier_invalidate_range_start
              |  unmap_single_vma
              |  mmu_notifier_invalidate_range_end

   4. in kernel/events/core.c, zap_page_range_single() is invoked to clear any
      partial mappings on error.

      perf_mmap
        |->ret = map_range(rb, vma);
                 |  err = remap_pfn_range
                 |->if (err) 
                 |     zap_page_range_single
                        |->zap_page_range_single_batched
                           |->mmu_notifier_range_init
                           |  mmu_notifier_invalidate_range_start
                           |  unmap_single_vma
                           |  mmu_notifier_invalidate_range_end


   5. in mm/memory.c, unmap_mapping_folio() is invoked to unmap posion page.

      __do_fault
	|->if (unlikely(PageHWPoison(vmf->page))) { 
	|	vm_fault_t poisonret = VM_FAULT_HWPOISON;
	|	if (ret & VM_FAULT_LOCKED) {
	|		if (page_mapped(vmf->page))
	|			unmap_mapping_folio(folio);
        |                       |->unmap_mapping_range_tree
        |                          |->unmap_mapping_range_vma
        |                             |->zap_page_range_single
        |                                |->zap_page_range_single_batched
        |                                   |->mmu_notifier_range_init
        |                                   |  mmu_notifier_invalidate_range_start
        |                                   |  unmap_single_vma
        |                                   |  mmu_notifier_invalidate_range_end
	|		if (mapping_evict_folio(folio->mapping, folio))
	|			poisonret = VM_FAULT_NOPAGE; 
	|		folio_unlock(folio);
	|	}
	|	folio_put(folio);
	|	vmf->page = NULL;
	|	return poisonret;
	|  }


  6. in mm/vma.c, in __mmap_region(), unmap_region() is invoked to undo any
     partial mapping done by a device driver.

     __mmap_new_vma
       |->__mmap_new_file_vma(map, vma);
          |->error = mmap_file(vma->vm_file, vma);
          |  if (error)
          |     unmap_region
                 |->unmap_vmas
                    |->mmu_notifier_range_init
                    |  mmu_notifier_invalidate_range_start
                    |  unmap_single_vma
                    |  mmu_notifier_invalidate_range_end


(2) No-fail cases
-------------------------------
1. iput() cannot fail. 

iput
 |->iput_final
    |->WRITE_ONCE(inode->i_state, state | I_FREEING);
    |  inode_lru_list_del(inode);
    |  evict(inode);
       |->op->evict_inode(inode);
          |->shmem_evict_inode
             |->shmem_truncate_range
                |->truncate_inode_pages_range
                   |->truncate_cleanup_folio
                      |->if (folio_mapped(folio))
                      |     unmap_mapping_folio(folio);
                            |->unmap_mapping_range_tree
                               |->unmap_mapping_range_vma
                                  |->zap_page_range_single
                                     |->zap_page_range_single_batched
                                        |->mmu_notifier_range_init
                                        |  mmu_notifier_invalidate_range_start
                                        |  unmap_single_vma
                                        |  mmu_notifier_invalidate_range_end


2. exit_mmap() cannot fail

exit_mmap
  |->mmu_notifier_release(mm);
     |->unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
        |->mmu_notifier_range_init
        |  mmu_notifier_invalidate_range_start
        |  unmap_single_vma
        |  mmu_notifier_invalidate_range_end


3. KVM Cases That Cannot Tolerate Unmap Failure
-------------------------------
Allowing unmap operations to fail in the following scenarios would make it very
difficult or even impossible to handle the failure:

(1) __kvm_mmu_get_shadow_page() is designed to reliably obtain a shadow page
without expecting any failure.

mmu_alloc_direct_roots
  |->mmu_alloc_root
     |->kvm_mmu_get_shadow_page
        |->__kvm_mmu_get_shadow_page
           |->kvm_mmu_alloc_shadow_page
              |->account_shadowed
                 |->kvm_mmu_slot_gfn_write_protect
                    |->kvm_tdp_mmu_write_protect_gfn
                       |->write_protect_gfn
                          |->tdp_mmu_iter_set_spte


(2) kvm_vfio_release() and kvm_vfio_file_del() cannot fail

kvm_vfio_release/kvm_vfio_file_del
 |->kvm_vfio_update_coherency
    |->kvm_arch_unregister_noncoherent_dma
       |->kvm_noncoherent_dma_assignment_start_or_stop
          |->kvm_zap_gfn_range
             |->kvm_tdp_mmu_zap_leafs
                |->tdp_mmu_zap_leafs
                   |->tdp_mmu_iter_set_spte


(3) There're lots of callers of __kvm_set_or_clear_apicv_inhibit() currently
never expect failure of unmap.

__kvm_set_or_clear_apicv_inhibit
  |->kvm_zap_gfn_range
     |->kvm_tdp_mmu_zap_leafs
        |->tdp_mmu_zap_leafs
           |->tdp_mmu_iter_set_spte



4. Cases in KVM where it's hard to make tdp_mmu_set_spte() (update SPTE with
write mmu_lock) failable.

(1) kvm_vcpu_flush_tlb_guest()

kvm_vcpu_flush_tlb_guest
  |->kvm_mmu_sync_roots
     |->mmu_sync_children
        |->kvm_vcpu_write_protect_gfn
           |->kvm_mmu_slot_gfn_write_protect
              |->kvm_tdp_mmu_write_protect_gfn
                 |->write_protect_gfn
                    |->tdp_mmu_iter_set_spte
                       |->tdp_mmu_set_spte


(2) handle_removed_pt() and handle_changed_spte().


Thanks
Yan

