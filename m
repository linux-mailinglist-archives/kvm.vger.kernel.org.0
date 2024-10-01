Return-Path: <kvm+bounces-27764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADC2D98BA09
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 12:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C6B6281284
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 10:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C971A08BB;
	Tue,  1 Oct 2024 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jiuMw34/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E58C1990D7;
	Tue,  1 Oct 2024 10:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727779563; cv=fail; b=JoHpmbsVEYNIzxdSx4UlSs/nskOKflO37DfCXwHrg+52nvbHx73RR2ek0zPOLywJxtZPRmAYz55xxoqZoy+Dmim8QGVUSBqP9YsJFnwIo1WkdD3ss802gjwNtvnplzVFhndRE41cmPkyFVu6KzteXjy0+P8uF0VyrCM2lIN5IUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727779563; c=relaxed/simple;
	bh=aBrriyPYlo+1GVv+rxdEUkrAGgoAzeXAZlRyB4ABNjg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FK3iiuH0cRn9vynzI99axNZpi7okfYbFfA2nIpFNiDpoyQIlmVE0E7/zE9BWaFDO8iBooAgmCoz5L+Lm5FPV/8AuHUDRa4U9PZkP7xmWmR6aZVWjqBw+loM/vnrQfdas2beYn7qVLhG28rg16ls+FwvBQH+PmhbxhxPfh/PyrTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jiuMw34/; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727779562; x=1759315562;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aBrriyPYlo+1GVv+rxdEUkrAGgoAzeXAZlRyB4ABNjg=;
  b=jiuMw34/S73q0RS0TrzyrEyfaKeqQj2M7jRmAqiy4lhWNKWGaSx6+toW
   ZW5deYH8skBPQTGTfcYT9GehMipcddcoWGaryeuRjNYSvZDRZojzCp5hZ
   KBYX3Qk56GCiJN71LdVFgd+Pa/lxBc0obJnx1GGiQWDB16BujdsgQ4+Ai
   PDOOAzCzQJOb8vN9rGKkNZQB2152bd8RMl4UuuuflnWVbwW8s0vVR8Vi5
   5VqA8bTycy/0WKzDKtnqbK5+8T6wm3uE/YZCTRa7jH6ttohMqdieNDo4K
   62K3BOekR+ceAnqn08MI2XOEmP0VaDXLCgBomgs3HcdnRHKGDY8mSzH2S
   w==;
X-CSE-ConnectionGUID: N3WTyts/RbKeIzoYW7Wj4g==
X-CSE-MsgGUID: GS6LBqWmQYC/3pOQy7PGbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11211"; a="27036697"
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="27036697"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 03:44:36 -0700
X-CSE-ConnectionGUID: LGil9AzOQPaz5OBGLK5IDQ==
X-CSE-MsgGUID: 2HXOKutmSAChOpVvHc4miw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="78034051"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Oct 2024 03:44:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 1 Oct 2024 03:44:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 1 Oct 2024 03:44:34 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 1 Oct 2024 03:44:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EGxL7ZZCqZrVWqwnhCzem+ZyZELQrkcaYUTzm2E66g+DQgGqUv/2kolwnpKe63YHqupIqkndrn6+f5p4oo5A0CUR0T+m4+KPw4ms1sEJcCYrgely5oMmdaNXPakqjlyXnGDMN55v3zW65UXfRVbdUrDWaOkOY5Tmwp8l5ZcLDC5+L4SQ9LBNgUFnLCx0AsWepYKoX11e2m3LRW5G4EIFW2qzi0y4qleoHB1I6sZPX+nrqAWOuy+DLtK3UN5s01q7F2qqCnTF0Q0r7o6t9la2VEU9hWFKysfwG/uOqbi6tcH5wyYWZxZIVhzV4h533nT6zD3L1bkHBcxuF/tkcKYhlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBrriyPYlo+1GVv+rxdEUkrAGgoAzeXAZlRyB4ABNjg=;
 b=Lu6h0mgKoOSnOWdBI5nI+KtNoEu+solNd65W2AYiNyg1Ffb1U/7lF39ldpzN6WkVMGAP4FiTVSiLlvc1FPKgddZlVyiXCGvXxlgbR99UQ/7TMOSdIcD3Myu8ca4BTO9F65ut5VkUcZ0kMQiM5kkW3OMkiztWSTtoOm4aiwGPY5qCLa5KpD3L6VxDb3ulogn9OPHmviaZXlMeh77GfrtvGsoo3n2njZwCLVp34ZMOJUrd9GpY3FN4j4jCe58bhAsYtahf7AERX4COWs0NEf/nFo5JiYBYRpC9WbvYwQ6JIlaIM/GNF/xhy070yDTJrNohNTnZUJy1FUsgmahC9xlsow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6756.namprd11.prod.outlook.com (2603:10b6:510:1cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Tue, 1 Oct
 2024 10:44:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8026.016; Tue, 1 Oct 2024
 10:44:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Topic: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Index: AQHbDnRp8EihSraYXkOZ/V8hjcAzkrJqOf0AgABuTACAAAERgIAACvwAgAbdloCAAC7wAA==
Date: Tue, 1 Oct 2024 10:44:31 +0000
Message-ID: <d3fa4260c50c8d4101f8476c1cc4d6474b5800ce.camel@intel.com>
References: <cover.1727173372.git.kai.huang@intel.com>
	 <101f6f252db860ad7a7433596006da0d210dd5cb.1727173372.git.kai.huang@intel.com>
	 <408dee3f-a466-4746-92d3-adf54d35ec7c@intel.com>
	 <62ca1338-2d10-4299-ab7e-361a811bd667@intel.com>
	 <a03f740b-6b0c-4a64-9ff1-7eba3ac7a583@intel.com>
	 <1b14e28b-972e-4277-898f-8e2dcb77e144@intel.com>
	 <66fbab2b73591_964fe29434@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66fbab2b73591_964fe29434@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6756:EE_
x-ms-office365-filtering-correlation-id: 1c92637e-58c8-4407-2e0c-08dce2060815
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?SUtJd1dyOXRMYzNzeTF0SjQxN3NQbTdRSFFaSElUWGxFOENGcXVqMnpqbU9k?=
 =?utf-8?B?QWFVeEY2bVVyRUlEdlU4QkJhR3EvclBWUWxYZ0FqME1zUUxseU5nayswVENE?=
 =?utf-8?B?L1FjeDdpRjBNQjN4VFk4MGZCaGoxa29mQm8wOWdCUXI1NW15dlVmOFUxRXFi?=
 =?utf-8?B?ZVowT1dnc2hRd3YwMGwxRmhJNHlxeHRIYXVRMWdNZWIwcGx3a1VmeWxFT3Ew?=
 =?utf-8?B?NFhWNmo5OG01MnBKVGVtUlUvczdZdEpkZUxVd2hDRWdUc3Ntb1cvRVJqN2ZB?=
 =?utf-8?B?d093UzdDNmlSUTcwc2t0ZnhrbE41ZlcrcnJaeDNkWXZFejVDR09YK2h5bGIx?=
 =?utf-8?B?RTJOMXpsUHVkb2MxWWIza1R6K0xZVFQ2b0FNTlFObGtMc0tCS2lBcEdRQ3Q3?=
 =?utf-8?B?ZzVPS2lkK2FBU2Q3eDMzTXowOVNtVTdWTnhHektsTzZZT096WGJ5bjJyMWNh?=
 =?utf-8?B?d1ZubnJUVmljcXZ0SW0rUVJ0L0dUaTBMNEhkazdlelg3RnhTcXVQNWVTckg0?=
 =?utf-8?B?eGtncjZJWUp5eEtJNWhwRjBZemtwYW5YNmRCVlhrK1RpMktxMXlqZzV2ZXJR?=
 =?utf-8?B?cE91QmhtTi9qSmROay9LV3N3THFZdElyNGpXdTZyVVpEaDRwajBnQkVENGYr?=
 =?utf-8?B?aHVZa3pheHZZdHIwUVQ0U2FpOWdWQWJEU3lhMFNxZkFVcDMzTCtKdHBmbytj?=
 =?utf-8?B?Q1kzd0hMeHh6L3RnOUU5Y3FmdjlGOWNXSkhyZC9lWC9RVldOc2ovNUVkWjd4?=
 =?utf-8?B?UHRLMFY2amJ3SWVsNVlDSm5DY21kY2kzM3JHWTZ6WkRsREZyU25JSFFIYlU1?=
 =?utf-8?B?cWFjVVZNeE5PNVRoTmJ0VnZNTGxhSUkvVWRsMXpHYW9KR3gzOFIzUUp5QWFn?=
 =?utf-8?B?TmlUdjV2UkJHc0hMRnIwTUl3R1N1ZmF5YlRPdU5FNnFoTmZDMXZnT1NIN3gv?=
 =?utf-8?B?NGM3dVdsbmpKRU1mZUNPSk9mdGhSYTZxL3lsRFNJLzUzdUpMNURnUWhLWGVo?=
 =?utf-8?B?akVRc0NIdE55KzVJV3pCYitQb1h4aG9ORDh1bUtaSzBDZ0ZXZ1h2aXpEbDVM?=
 =?utf-8?B?L212bDVTK2tiTGdhcmVxZWJTRFhiaHBVRGFVb3NnK21JMkFPOWNoZC8xam0v?=
 =?utf-8?B?dWFOZnkvYnhDYlg3eStOZnNvOUh5R3JYUUpjdCtTSFlmY0ZSKy9hdXltRXJl?=
 =?utf-8?B?QkZNR2E0UDI2d0ZJRm5ncGVWZVZBUEFpb2ZvR1lreGg4SGYvMUJyYmtLeWRW?=
 =?utf-8?B?N0laTHlTaTc2TjZqOHdrclZJY3JPRHJKOWROeFF5K1FibnJnM1VHa3hJNmth?=
 =?utf-8?B?SjZWUWQ1TkM5MFJPSCtjeTZYdzAxQTV4cmFhdEVoU0F5K1FKbkNLaXlhYlRi?=
 =?utf-8?B?RW1ZYUtDTnVHZVFtSm1sZHdvSEpZOWdhazJtL1h4WnptdkxtUGQwZFpLN3BI?=
 =?utf-8?B?cFpwcWJoeTFBNjJQdFFUZzZRa1FlMUhzTENqNys3c0dxaS9odDV6WEZlcjhU?=
 =?utf-8?B?b3pXMFNvdjNIOXNFRXU4UnVtenNodHBsWWRsS3kvRTRZU2plNm01RVRMSHhL?=
 =?utf-8?B?SU5kSlIzQ2pRNzIwakVtdnYrME5idlJwUTNxUFVSRjZlTzg0aXV0QkJyQzF1?=
 =?utf-8?B?M25QRmRoc0RjWXJqZmNzb2FqMzRnVk1rcXEya2JBVTZmZXpiYXBEU2dKUnRu?=
 =?utf-8?B?MGdKU280VnlKNUQ4WW9lZm5hTWtDL25nUXQ4OG14SmZjUGF0R2p4V3YwY2w4?=
 =?utf-8?B?ZjkvTGNkT0ZsV0tza3RVK1JaSFdTWndFZEc5bmxKSkZrNlJ6bW5Jd0VwY2RJ?=
 =?utf-8?Q?dZCxKqCbNVurz2sgaRVPWLLzRZtWn0xAKOy4c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1B5cWo0T1VYSlpldjZQQ1FURVVsd0NEdFJZem9ocnM4a2VlL05KaU0yWmRx?=
 =?utf-8?B?ZUVJZ0dQd3J1NGdhM2hHZTlSNjYwa2JEK2QzRnh5V2lLcjk0NUdkc2FwNHBQ?=
 =?utf-8?B?Y010Y25vdlg2a3FkMjV2dHFiSHVsdkUzeEgxRDFDN3lKV0JybVVrd2tMMVB0?=
 =?utf-8?B?ZHJmVC9hZS9pM0c5c0l0d2ptb1FRTGZ6WlV0cVByb1JoVnVLLzYrVlVBWDlB?=
 =?utf-8?B?UXlHbzBEbG4xZW54S1RjQzg3cUx5ajBYQ2NyTnFaNU5Fc3dkMUtob0FaLy9Q?=
 =?utf-8?B?ZkJTRzBWOGd3bndSU0FsM2dyL1djaysyalNpUy9JQ0huTng2M3R4RW16eFNx?=
 =?utf-8?B?aC8yVmtSUEJzTEoyWHd0Q1ordjdVYWVmMVBHYzExdXQ2ZjlhV1p5c3MzUFRG?=
 =?utf-8?B?RXNIU2trQi9YWHpleHBXRGk4UFB5ZDRnUnN5M2w1a0c3M25TWWpLUGlxOUc4?=
 =?utf-8?B?VThLU0t4L2YxaUhUTGFWK1I5dFBMd3FJdWNOZXJCbXVnb2VJODhKbEtOTkZI?=
 =?utf-8?B?Y1BhbEtwaG9xU1pqS2tIWU8xQTg3ZDRnc09nRDFmZmttRXBJMXVneW9jZmhr?=
 =?utf-8?B?aDFVbHI5dzg5Z0EvVTB1bzNXOGxvMXdvWjhUbGFOcTBSRXUxbmVnQnJGaGFC?=
 =?utf-8?B?VktoK0paT1RUbWdiZkowRlI1WjJDK1lwTUd0YW9BcGUvalFlZDFBZTVZdmJ4?=
 =?utf-8?B?NmErWU1TNjFTN1RITlVRb1Fpd1hxYTdtSWl1NVppbFphSVNVUmVOb2R3WTh4?=
 =?utf-8?B?bTNlNGNnaU9DZmZLOEpsem9nTHpsZlRwSUFrbnpJZkt4MEFidjRGWEEvUlh4?=
 =?utf-8?B?NDljZmdaUkJlN252ZlBtUEd5eTJXazBSRUl5aW9UOXNSdCtoL1IwSkxPUFB4?=
 =?utf-8?B?YU9JTlA2SlU0QVZCb25ESGExSm90bDlDNnR0REQ5ZFpYVXovVWg0MjcxVkNN?=
 =?utf-8?B?YWNYSmh5bmZ3eE4yNXk0QnVESTlyWkxlM2NBVTh2WXMxYmp4TmUzZjRZcDg0?=
 =?utf-8?B?NnV0UTJqZm80Tnc5SzBpbWExWFErbFg5aVZSTlhPVWVMbFRVNlFFUWViWFc3?=
 =?utf-8?B?dThGQXNmZjE5WWhLRGpHUlQ0WnlvZnliZXo4UFN6RjZYay90YVptczgzWHY3?=
 =?utf-8?B?QmZyRkVaL3FzMU9IR2JwYnNSWkhyUThXSEpyaXczaXNqSkRtK2U5cER4Y0Er?=
 =?utf-8?B?bUFkckE0anZqc09ONVA5TTdLU3YvT2tPT0QwVWNyVGJsTEo5bUptZTVrenBx?=
 =?utf-8?B?UnVIYVk0ZnZxOXdFY2xodCtybVgrYzVwV3JWQnVOOXkvZm9PVTZuV2JOWnhN?=
 =?utf-8?B?WCtyYittejA0UXZVKzl1Qm01MzFmRmE3NU8zaFR6UXRsbUx4VDJxaHNueUg5?=
 =?utf-8?B?N2YvZFBUb3lUVks1NlJYa0d6aDhWOWdONVdrbWhDenpEemZnQkZkZDdjYnhi?=
 =?utf-8?B?YkpxakVWOVlVa01vc2V1WXV2Y3RTVFg5azRhc29YbWU1SzE1ME5wWmJpa1Bw?=
 =?utf-8?B?azczUmJJOVVqOEJHaGVVQjhYdkx6dzNuOEs4RjduMUU0ZkkrdysxbVU2M2Na?=
 =?utf-8?B?aldDaWVyZ0ppR2l2akRRWnVaTWRmRERGMSs3dTBqYW9iOVhSbGRtaVF1TGtL?=
 =?utf-8?B?b3lINUpDOUhsL1FUaFV4bHhwZngrTnR2bE53ZnFYVDNpT0N1cUYzKzZhdjJR?=
 =?utf-8?B?SHFXVjFpbXZra3o0Z1FtODNsUUt4emxaa29JMW9PQzFYdkxpYkkrQk1URFMx?=
 =?utf-8?B?M3ZVYUNjaUtEVlg4SSszREFCVWp6dVV5MmQ1dURuSElkaFhEeVZyK1VqOXpy?=
 =?utf-8?B?R2ZjUEF5ejlNQWRTRTM4QWs0TlJRZDJDMVo3OGZEay9sRkROMnFzTDY1M1NJ?=
 =?utf-8?B?MERWak9XaUYwZ3RIOHJQNlQvTXU5bUxDVGF5YTFvelYrUE9TYWdlMUVMd3lD?=
 =?utf-8?B?LzBNQVNheHBudjAwTXlVRVl3cnlyY3djVmdIcUVBVE10d2s5bUZUV2I1Sk00?=
 =?utf-8?B?TzE0NU9kQ2FDL2V2M2dscCs0VmJidW5MS2RuajRrZUExV3BQcFYycnVENDJ0?=
 =?utf-8?B?dFVIRXl5T0dVdEdCVlUyb3pJZldwdVpwdytlam9nUjJKOTF1TnhGTndXMTdL?=
 =?utf-8?Q?1ZqrJLx8N2ApXr8hNzmaLHIvs?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CC4FB5F05BFCE448919F258F3ACF0C5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c92637e-58c8-4407-2e0c-08dce2060815
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2024 10:44:31.2871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hbS4TuIBK+FsNdVEy313ZR7ljbXgzzdTVbljI4WfCgpFLd6rEOJmgd5uLbcX12P+4UTSH//72Yba1ncn2MsydQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6756
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTEwLTAxIGF0IDAwOjU2IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gDQo+ID4gDQo+ID4gT24gMjcvMDkvMjAyNCAxMDoyNiBh
bSwgSGFuc2VuLCBEYXZlIHdyb3RlOg0KPiA+ID4gT24gOS8yNi8yNCAxNToyMiwgSHVhbmcsIEth
aSB3cm90ZToNCj4gPiA+ID4gQnV0IERhbiBjb21tZW50ZWQgdXNpbmcgdHlwZWxlc3MgJ3ZvaWQg
KicgYW5kICdzaXplJyBpcyBraW5kYSBhIHN0ZXANCj4gPiA+ID4gYmFja3dhcmRzIGFuZCB3ZSBz
aG91bGQgZG8gc29tZXRoaW5nIHNpbWlsYXIgdG8gYnVpbGRfbW1pb19yZWFkKCk6DQo+ID4gPiAN
Cj4gPiA+IFdlbGwsIHZvaWQqIGlzIHR5cGVsZXNzLCBidXQgYXQgbGVhc3QgaXQga25vd3MgdGhl
IHNpemUgaW4gdGhpcyBjYXNlLg0KPiA+ID4gSXQncyBub3QgY29tcGxldGVseSBhaW1sZXNzLiAg
SSB3YXMgdGhpbmtpbmcgb2YgaG93IHRoaW5ncyBsaWtlDQo+ID4gPiBnZXRfdXNlcigpIHdvcmsu
DQo+ID4gDQo+ID4gZ2V0X3VzZXIoeCxwdHIpIG9ubHkgd29ya3Mgd2l0aCBzaW1wbGUgdHlwZXM6
DQo+ID4gDQo+ID4gICAqIEBwdHIgbXVzdCBoYXZlIHBvaW50ZXItdG8tc2ltcGxlLXZhcmlhYmxl
IHR5cGUsIGFuZCB0aGUgcmVzdWx0IG9mDQo+ID4gICAqIGRlcmVmZXJlbmNpbmcgQHB0ciBtdXN0
IGJlIGFzc2lnbmFibGUgdG8gQHggd2l0aG91dCBhIGNhc3QuDQo+ID4gDQo+ID4gVGhlIGNvbXBp
bGVyIGtub3dzIHRoZSB0eXBlIG9mIGJvdGggQHggYW5kIEAoKnB0ciksIHNvIGl0IGtub3dzIA0K
PiA+IHR5cGUtc2FmZXR5IGFuZCBzaXplIHRvIGNvcHkuDQo+ID4gDQo+ID4gSSB0aGluayB3ZSBj
YW4gZWxpbWluYXRlIHRoZSBfX3JlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKCkgYnkgaW1wbGVtZW50
aW5nIA0KPiA+IGl0IGFzIGEgbWFjcm8gZGlyZWN0bHkgYW5kIGdldCByaWQgb2YgJ3ZvaWQgKicg
YW5kICdzaXplJzoNCj4gPiANCj4gPiBzdGF0aWMgaW50IHRkaF9zeXNfcmQodTY0IGZpZWxkX2lk
LCB1NjQgKnZhbCkge30NCj4gPiANCj4gPiAvKiBAX3ZhbHB0ciBtdXN0IGJlIHBvaW50ZXIgdG8g
dTgvdTE2L3UzMi91NjQgKi8NCj4gPiAjZGVmaW5lIHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKF9m
aWVsZF9pZCwgX3ZhbHB0cikJXA0KPiA+ICh7CQkJCQkJCVwNCj4gPiAJdTY0IF9fX3RtcDsJCQkJ
CVwNCj4gPiAJaW50IF9fX3JldDsJCQkJCVwNCj4gPiAJCQkJCQkJXA0KPiA+IAlCVUlMRF9CVUdf
T04oTURfRklFTERfRUxFX1NJWkUoX2ZpZWxkX2lkKSAhPQlcDQo+ID4gCQlzaXplb2YoKl92YWxw
dHIpKTsJCQlcDQo+ID4gCQkJCQkJCVwNCj4gPiAJX19fcmV0ID0gdGRoX3N5c19yZChfZmllbGRf
aWQsICZfX190bXApOwlcDQo+ID4gCQkJCQkJCVwNCj4gPiAJKl92YWxwdHIgPSBfX190bXA7CQkJ
CVwNCj4gPiAJX19fcmV0Ow0KPiA+IH0pDQo+ID4gDQo+ID4gSXQgc2V0cyAqX3ZhbHB0ciB1bmNv
bmRpdGlvbmFsbHkgYnV0IHdlIGNhbiBhbHNvIG9ubHkgZG8gaXQgd2hlbiBfX19yZXQgDQo+ID4g
aXMgMC4NCj4gPiANCj4gPiBUaGUgY2FsbGVyIHdpbGwgbmVlZCB0byBkbzoNCj4gPiANCj4gPiBz
dGF0aWMgaW50IGdldF90ZHhfbWV0YWRhdGFfWF93aGljaF9pc18zMmJpdCguLi4pDQo+ID4gew0K
PiA+IAl1MzIgbWV0YWRhdGFfWDsNCj4gPiAJaW50IHJldDsNCj4gPiANCj4gPiAJcmV0ID0gcmVh
ZF9zeXNfbWV0YWRhdGFfZmllbGQoTURfRklFTERfSURfWCwgJm1ldGFkYXRhX1gpOw0KPiA+IA0K
PiA+IAlyZXR1cm4gcmV0Ow0KPiA+IH0NCj4gPiANCj4gPiBJIGhhdmVuJ3QgY29tcGlsZWQgYW5k
IHRlc3RlZCBidXQgaXQgc2VlbXMgZmVhc2libGUuDQo+ID4gDQo+ID4gQW55IGNvbW1lbnRzPw0K
PiANCj4gSWYgaXQgd29ya3MgdGhpcyBhcHByb2FjaCBhZGRyZXNzZXMgYWxsIHRoZSBjb25jZXJu
cyBJIGhhZCB3aXRoIGdldHRpbmcNCj4gdGhlIGNvbXBpbGVyIHRvIHZhbGlkYXRlIGZpZWxkIHNp
emVzLg0KDQpZZXMgSSBqdXN0IHF1aWNrbHkgdGVzdGVkIG9uIG15IGJveCBhbmQgaXQgd29ya2Vk
IC0tIFREWCBtb2R1bGUgY2FuIGJlDQppbml0aWFsaXplZCBzdWNjZXNzZnVsbHkgYW5kIGFsbCBt
ZXRhZGF0YSBmaWVsZHMgKG1vZHVsZSB2ZXJzaW9uLCBDTVJzIGV0Yykgc2VlbQ0KdG8gYmUgY29y
cmVjdC4NCg0KSGkgRGF2ZSwNCg0KUGxlYXNlIGxldCBtZSBrbm93IGlmIHlvdSBoYXZlIGFueSBj
b25jZXJuPyAgT3RoZXJ3aXNlIEkgd2lsbCBnbyB3aXRoIHRoaXMNCnJvdXRlLg0KDQo+IA0KPiBT
aG91bGQgYmUgc3RyYWlnaHRmb3J3YXJkIHRvIHB1dCB0aGlzIGluIGEgc2hhcmVkIGxvY2F0aW9u
IHNvIHRoYXQgaXQNCj4gY2FuIG9wdGlvbmFsbHkgdXNlIHRkZ19zeXNfcmQgaW50ZXJuYWxseS4N
Cg0KWWVhaCBpdCdzIGRvYWJsZS4gIEFzIHlvdSBhbHNvIG5vdGljZWQgZ3Vlc3QgYW5kIGhvc3Qg
dXNlIGRpZmZlcmVudCBjYWxsczogZ3Vlc3QNCnVzZXMgdGRnX3ZtX3JkKCkgKHdoaWNoIGlzIGlu
IEtpcmlsbCdzIG5vdC15ZXQtbWVyZ2VkIHNlcmllc1sqXSksIGFuZCBob3N0IHVzZXMNCnRkaF9z
eXNfcmQoKS4gwqANCg0KWypdDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNDA4Mjgw
OTM1MDUuMjM1OTk0Ny0yLWtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRlbC5jb20vDQoNClRoaXMg
Y2FuIGJlIHJlc29sdmVkIGJ5IGFkZGluZyBhIG5ldyBhcmd1bWVudCB0byB0aGUgcmVhZF9zeXNf
bWV0YWRhdGFfZmllbGQoKQ0KbWFjcm8sIGUuZy4sOg0KDQovKiBAX3ZhbHB0ciBtdXN0IGJlIHBv
aW50ZXIgdG8gdTgvdTE2L3UzMi91NjQgKi8NCiNkZWZpbmUgcmVhZF9zeXNfbWV0YWRhdGFfZmll
bGQoX3JlYWRfZnVuYywgX2ZpZWxkX2lkLCBfdmFscHRyKQkJXA0KKHsJCQkJCQkJCQlcDQoJdTY0
IF9fX3RtcDsJCQkJCQkJXA0KCWludCBfX19yZXQ7CQkJCQkJCVwNCgkJCQkJCQkJCVwNCglCVUlM
RF9CVUdfT04oTURfRklFTERfRUxFX1NJWkUoX2ZpZWxkX2lkKSAhPQkJCVwNCgkJc2l6ZW9mKCpf
dmFscHRyKSk7CQkJCQlcDQoJCQkJCQkJCQlcDQoJX19fcmV0ID0gX3JlYWRfZnVuYyhfZmllbGRf
aWQsICZfX190bXApOwkJCVwNCgkJCQkJCQkJCVwNCgkqX3ZhbHB0ciA9IF9fX3RtcDsJCQkJCQlc
DQoJX19fcmV0OwkJCQkJCQkNCglcDQp9KQ0KDQpXZSBjYW4gcHV0IGl0IGluIDxhc20vdGR4Lmg+
ICh0b2dldGhlciB3aXRoIHRoZSBNRF9GSUVMRF9FTEVfU0laRSgpIG1hY3JvKSBmb3INCmd1ZXN0
IGFuZCBob3N0IHRvIHNoYXJlLg0KDQpBbmQgaW4gZ3Vlc3QgY29kZSAoYXJjaC94ODYvY29jby90
ZHgvdGR4LmMpLCB3ZSBjYW4gaGF2ZSBhIHdyYXBwZXI6DQoNCiNkZWZpbmUgdGRnX3JlYWRfc3lz
X21ldGFkYXRhX2ZpZWxkKF9maWVsZF9pZCwgX3ZhbHB0cikJCVwNCglyZWFkX3N5c19tZXRhZGF0
YV9maWVsZCh0ZGdfdm1fcmQsIF9maWVsZF9pZCwgX3ZhbHB0cikNCg0KU2ltaWxhcmx5LCBpbiB0
aGUgaG9zdCBjb2RlIChhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMpLCB3ZSBjYW4gaGF2ZToN
Cg0KI2RlZmluZSB0ZGhfcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoX2ZpZWxkX2lkLCBfdmFscHRy
KQkJXA0KCXJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKHRkaF9zeXNfcmQsIF9maWVsZF9pZCwgX3Zh
bHB0cikNCg0KV2UgY2FuIHN0YXJ0IHdpdGggdGhpcyBpZiB5b3UgdGhpbmsgaXQncyBiZXR0ZXIu
DQoNCkJ1dCBJIHdvdWxkIGxpa2UgdG8gZGlzY3VzcyB0aGlzIG1vcmU6DQoNCk9uY2Ugd2Ugc3Rh
cnQgdG8gc2hhcmUsIGl0IGZlZWxzIGEgbGl0dGxlIGJpdCBvZGQgdG8gc2hhcmUgb25seSB0aGUN
CnJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKCkgbWFjcm8sIGJlY2F1c2Ugd2UgY2FuIHByb2JhYmx5
IHNoYXJlIG90aGVycyB0b286DQoNCjEpIFRoZSBtZXRhZGF0YSBmaWVsZCBJRCBkZWZpbml0aW9u
cyBhbmQgYml0IGRlZmluaXRpb25zICh0aGlzIGlzIG9idmlvdXMpLg0KMikgdGRoX3N5c19yZCgp
IGFuZCB0ZGdfdm1fcmQoKSBhcmUgc2ltaWxhciBhbmQgY2FuIGJlIHNoYXJlZCB0b286DQoNCi8q
IFJlYWQgVEQtc2NvcGVkIG1ldGFkYXRhICovDQpzdGF0aWMgaW5saW5lIHU2NCBfX21heWJlX3Vu
dXNlZCB0ZGdfdm1fcmQodTY0IGZpZWxkLCB1NjQgKnZhbHVlKQ0Kew0KCXN0cnVjdCB0ZHhfbW9k
dWxlX2FyZ3MgYXJncyA9IHsNCgkJLnJkeCA9IGZpZWxkLA0KCX07DQoJdTY0IHJldDsNCg0KCXJl
dCA9IF9fdGRjYWxsX3JldChUREdfVk1fUkQsICZhcmdzKTsNCgkqdmFsdWUgPSBhcmdzLnI4Ow0K
DQoJcmV0dXJuIHJldDsNCn0NCg0Kc3RhdGljIGludCB0ZGhfc3lzX3JkKHU2NCBmaWVsZF9pZCwg
dTY0ICpkYXRhKSAgICANCnsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAg
ICAgICAgc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdzID0ge307ICAgICAgICAgICAgICAgICAg
ICAgICAgDQogICAgICAgIGludCByZXQ7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAv
KiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAg
ICAgICogVERILlNZUy5SRCAtLSByZWFkcyBvbmUgZ2xvYmFsIG1ldGFkYXRhIGZpZWxkICAgICAg
ICAgICAgICAgDQogICAgICAgICAqICAtIFJEWCAoaW4pOiB0aGUgZmllbGQgdG8gcmVhZCAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICogIC0gUjggKG91dCk6IHRoZSBm
aWVsZCBkYXRhICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAg
ICAqLyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAg
YXJncy5yZHggPSBmaWVsZF9pZDsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIA0KICAgICAgICByZXQgPSBzZWFtY2FsbF9wcmVycl9yZXQoVERIX1NZU19S
RCwgJmFyZ3MpOw0KICAgICAgICBpZiAocmV0KSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICByZXR1cm4gcmV0OyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0K
ICAgICAgICAqZGF0YSA9IGFyZ3Mucjg7ICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICANCiAgICAgICAgcmV0dXJuIDA7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0K
fQ0KDQpUaGVyZSBhcmUgbWlub3IgZGlmZmVyZW5jZXMsIGUuZy4sIHRkaF9zeXNfcmQoKSBvbmx5
IHNldHMgKmRhdGEgd2hlbiBUREhfU1lTX1JEDQpzdWNjZWVkZWQgYnV0IHRkZ192bV9yZCgpIHVu
Y29uZGl0aW9uYWxseSBzZXRzICp2YWx1ZSAoc3BlYyBzYXlzIFI4IGlzIHNldCB0byAwDQppZiBU
REdfVk1fUkQgb3IgVERIX1NZU19SRCBmYWlscywgYW5kIGd1ZXN0IGNvZGUga2luZGEgZGVwZW5k
cyBvbiB0aGlzKS4NCg0KUHV0dGluZyBhc2lkZSB3aGljaCBpcyBiZXR0ZXIsIHRob3NlIGRpZmZl
cmVuY2VzIGFyZSByZXNvbHZhYmxlLiAgQW5kIGlmIHdlDQpzdGFydCB0byBzaGFyZSwgaXQgYXBw
ZWFycyB3ZSBzaG91bGQgc2hhcmUgdGhpcyB0b28uDQoNCkFuZCB0aGVuIHRoZSBUREhfU1lTX1JE
IGRlZmluaXRpb24gKGFuZCBwcm9iYWJseSBhbGwgVERIX1NZU194eCBTRUFNQ0FMTCBsZWFmDQpk
ZWZpbml0aW9ucykgc2hvdWxkIGJlIG1vdmVkIHRvIDxhc20vdGR4Lmg+IHRvby4NCg0KQW5kIHRo
ZW4gdGhlIGhlYWRlciB3aWxsIGdyb3cgYmlnZ2VyIGFuZCBiaWdnZXIsIHdoaWNoIGJyaW5ncyB1
cyBhIHF1ZXN0aW9uIG9uDQpob3cgdG8gYmV0dGVyIG9yZ2FuaXplIGFsbCB0aG9zZSBkZWZpbml0
aW9uczogMSkgVERDQUxML1NFQU1DQUxMIGxlYWYgZnVuY3Rpb24NCmRlZmluaXRpb25zIChlLmcu
LCBUREhfU1lTX1JEKTsgMikgVERDQUxML1NFQU1DQUxMIGxvdyBsZXZlbCBmdW5jdGlvbnMNCihf
X3RkY2FsbCgpLCBfX3NlYW1jYWxsKCkpOyAzKSBURENBTEwvU0VBTUNBTEwgbGVhZiBmdW5jdGlv
biB3cmFwcGVyczsgNCkgc3lzDQptZXRhZGF0YSBmaWVsZCBJRCBkZWZpbml0aW9uczsgNSkgc3lz
IG1ldGFkYXRhIHJlYWQgaGVscGVyIG1hY3JvczsNCg0KU28gdG8gbWUgd2UgY2FuIGhhdmUgYSBz
ZXBhcmF0ZSBzZXJpZXMgdG8gYWRkcmVzcyBob3cgdG8gYmV0dGVyIG9yZ2FuaXplIFREWA0KY29k
ZSBhbmQgaG93IHRvIHNoYXJlIGNvZGUgYmV0d2VlbiBndWVzdCBhbmQgaG9zdCAoSSBjYW4gc3Rh
cnQgdG8gd29yayBvbiBpdCBpZg0KaXQncyBiZXR0ZXIgdG8gYmUgZG9uZSBzb29uZXIgcmF0aGVy
IHRoYW4gbGF0ZXIpLCB0aHVzIEkgYW0gbm90IHN1cmUgd2Ugd2FudCB0bw0Kc3RhcnQgc2hhcmlu
ZyByZWFkX3N5c19tZXRhZGF0YV9maWVsZCgpIG1hY3JvIGluIF90aGlzXyBzZXJpZXMuDQoNCkJ1
dCBvZiBjb3Vyc2UsIGlmIGl0IGlzIHdvcnRoIHRvIHNoYXJlIHJlYWRfc3lzX21ldGFkYXRhX2Zp
ZWxkKCkgaW4gdGhpcyBzZXJpZXMsDQpJIGNhbiBhZGQgYSBwYXRjaCBhcyB0aGUgbGFzdCBwYXRj
aCBvZiB0aGlzIHNlcmllcyB0byBvbmx5IHNoYXJlDQpyZWFkX3N5c19tZXRhZGF0YV9maWVsZCgp
IGluIDxhc20vdGR4Lmg+IGFzIG1lbnRpb25lZCBhYm92ZS4NCg==

