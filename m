Return-Path: <kvm+bounces-27793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D91198C7B2
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 23:41:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB34C2858E9
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 21:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08CA21CEEAE;
	Tue,  1 Oct 2024 21:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4tXF/zc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E0E1CEAAD;
	Tue,  1 Oct 2024 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727818865; cv=fail; b=SWXEG4V2YXOcElf+gqr4c0yuelyPUC5oT1VfhKvHy8KfycrjqnGzwckXMWobZQFZKtPsZEKc6+u+KELDSp/L/ZCR94B+8OglGmlEI+zG0t44Xv824NTC9UDiYdXlkXi/85R3cx1SHBjjAuVRsYUgJVaEklDiEkLbtKpBC+aLfCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727818865; c=relaxed/simple;
	bh=rzF6yVrNRpXb33fw1Ahc7bb92BkhW3Wb8xZ0JKe7qd8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TGFWEdyi2GemIH0xnHFqZ6HHrommVYdHHJuOigq2hjF3uoIDc1AbyAg28y0B1cICXCU6iHOq+8AXGNffFfhbLdDycJeG+8FWNUqE/CR3X6vnqIgpqCxAS/KuldyI+qNZyVQOVLOj/stcWf/3yHEozd5dPa5rCUu6Vy+0Pt2bu0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4tXF/zc; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727818863; x=1759354863;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rzF6yVrNRpXb33fw1Ahc7bb92BkhW3Wb8xZ0JKe7qd8=;
  b=E4tXF/zcF2rRqx0IVOUi2z0rVJCRfqmyRm+pjKKt6Jc361k++xglnXmK
   FJKDNtUDA2q5IvvBsvwjdRmjDmnirO5RIQO3IGKfED7OjQ7p0hBq2jhvr
   OxUxJrS2Q9Fcai3BcSk6W7+VpLiUfGHqRthNEQ4eRVo9SkckCVALJuUQA
   vHyOhzHBleg1BYIN3DHPKO8yhgEmqVakKrgyzCNqoKhJVu4mMt/6PIYHH
   X/jvRe1MD6hp/uhrcKNdNU6O5axu4opBcp4fvHATLDpVPKkfaH/6D7JgK
   fVcG5KJ80FHLsVg1qALGn09ZMfzS1ytSdUKK6+es+zSNSy+CqRS3jUcOR
   A==;
X-CSE-ConnectionGUID: hK1jpJtCQ/amn4hiolOBCA==
X-CSE-MsgGUID: kYVhE/iWR1KfuJsEzaViXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11212"; a="26481730"
X-IronPort-AV: E=Sophos;i="6.11,169,1725346800"; 
   d="scan'208";a="26481730"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 14:41:02 -0700
X-CSE-ConnectionGUID: hMkdypZcRtComKsFp+NQvg==
X-CSE-MsgGUID: gVrxqdPsSN+s0w1WeitfgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,169,1725346800"; 
   d="scan'208";a="77829681"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Oct 2024 14:41:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 1 Oct 2024 14:41:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 1 Oct 2024 14:41:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 1 Oct 2024 14:41:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vd9DG4HxRTxSR09o6NOS5bDbXqYUjwBPZZ6CxbAs6P/ZD57bWgqLPzUFf8vHB+6PxU07vZnvw1l8Gz9LY5aZV7ZqhSYr3iOv16dNVrt60onI3FM2Mo5GdPQBgCiEd/nO10iN2fkz2IwgruIfZ5duXjmzedshnMJ0qX5dzo9bFzhdYEjNEE5YWHiSrA+lM/NaFSBxZ79xMAbpJzepPNjewajEHHJxwX8L9rBgGwzXZP3A8+96Fs+uAqK38DwUP28tMcoAoevewZ6gHCwuPSq414RCIYL5rVZWDFtxy9/qAX8Oih7gWsq5BY2lvDUXCfwnmhYCtY1FdhK+iqf3i0E9Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzF6yVrNRpXb33fw1Ahc7bb92BkhW3Wb8xZ0JKe7qd8=;
 b=UYDC+WruH94OGmpIf35LR8HeKF4EE0+75AGdZ8/tq82g36x/6DC0GZGAyx3+Ve6XUxnn3jXAoW5WKPuNDimCslb8y01p3WeluZho2K03P/XZLGXiGQIu4d/pbrDaa21SvKVtyjzXrK7KqwlY4leqFOeBjvGy15xTVmTNos9mIphorSA6SInGwCRpJmKnnfM6tMkhG7jUVTMhAaF4Y8o7hrCCb5vL5I0YW/BTA1HaUWdc/ftP7TtMgxj4dGEl6b42trgwp9UyuvlAa4FmsDE/mOZb4dPouUNZE6+DuPSGBy467juSq/53qed+8YOUPvQiqLGHjHzS4Q9MUCPbfLK2HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6212.namprd11.prod.outlook.com (2603:10b6:930:24::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Tue, 1 Oct
 2024 21:40:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8026.016; Tue, 1 Oct 2024
 21:40:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Topic: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Index: AQHbDnRp8EihSraYXkOZ/V8hjcAzkrJqOf0AgABuTACAAAERgIAACvwAgAbdloCAAC7wAIAATPiAgABqcYA=
Date: Tue, 1 Oct 2024 21:40:56 +0000
Message-ID: <74a88c3df6e51ab8dd92fdd147e4282bfa73615b.camel@intel.com>
References: <cover.1727173372.git.kai.huang@intel.com>
	 <101f6f252db860ad7a7433596006da0d210dd5cb.1727173372.git.kai.huang@intel.com>
	 <408dee3f-a466-4746-92d3-adf54d35ec7c@intel.com>
	 <62ca1338-2d10-4299-ab7e-361a811bd667@intel.com>
	 <a03f740b-6b0c-4a64-9ff1-7eba3ac7a583@intel.com>
	 <1b14e28b-972e-4277-898f-8e2dcb77e144@intel.com>
	 <66fbab2b73591_964fe29434@dwillia2-xfh.jf.intel.com.notmuch>
	 <d3fa4260c50c8d4101f8476c1cc4d6474b5800ce.camel@intel.com>
	 <9514d5b8-73ba-47c8-93a9-baee56471503@intel.com>
In-Reply-To: <9514d5b8-73ba-47c8-93a9-baee56471503@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6212:EE_
x-ms-office365-filtering-correlation-id: e2bdd88d-e213-4132-7772-08dce261bbae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TEozTU9DMTRiQytTekxscTl2NGppY2FZUExJVmhVSnpoSW5OQUMwQW9oY0d4?=
 =?utf-8?B?aVJPTHlyaE9TSkxQRkJTbjhhWVhTRTB6TUpjZWRQbnZBQmE1aUFHS1lxZXpV?=
 =?utf-8?B?ZVpVV25TbityWDk2QlRyQmFxdWEweHRxV24wMWRMV2k0cGhyR0dPTlI1eUpu?=
 =?utf-8?B?WU5KUmVQMmlFR1Z0WGpMYzVJc2g3S1UybmFDMGJnYW5FcW1pSUhlaXN1NFBw?=
 =?utf-8?B?ZE9iR0ZPa0ZCVFpsMjNNQ3ltS0NGYlU1M1NQdXowK0FZY0x6bmNQTmk4bTl6?=
 =?utf-8?B?dnUxbktlOWZGczZ3ODkxRm5oRWdLTmRpdFQvMi92N0tUUGh0RDFyR2lVcE81?=
 =?utf-8?B?QmpqeWU5cjkrM1VuSjZiRjdQYzdxNFRnQ1o1cTE1aTRVL3Flb1I3cmNLb1BQ?=
 =?utf-8?B?aWd2c0dCRWV0TFFKaVpRMjgyZEVxOXM4aDMrWncxcHErUHVIWVZtNjd0cDY0?=
 =?utf-8?B?ZkdIRVJheEhxbHc1V3FvZjRMaDFkQnpjU2RTRXRKcjg4dkFvc1pFbXlIcitV?=
 =?utf-8?B?SGNiYzc0bFkzOEJvWERKZkdydjBKQUc0czArSWdwOWlaaEg2U0g1ZzRBcFNm?=
 =?utf-8?B?eUFvbXkxbGF2ZCtTaXBlRnRmajFSZGkzOEdYNlFoUTFSUjdNVi84WFlMMUJi?=
 =?utf-8?B?MWk0b2REdjRudXliUkdZQUNOcENOcG1BUVRBM3ZFOXZBWUU0SEh6eXg0ZU5B?=
 =?utf-8?B?SnYySGc2YS9iMnl3OHpLcTNPUk5zKzN3MWl5ZmU4K1VKYUVCOFMvN0NlWmpj?=
 =?utf-8?B?dmtIYStpdEN0MDQ1ZG5NbkYxVUpnaTRtTVEwNkE2NTIvQW5XcExJTU02Ny9Z?=
 =?utf-8?B?Z3ZIN2FHR0NCSWpLU2RTUjl1eDRDdUVBU2ZwT1B3OThSaVEvZ25vb1lSSHZN?=
 =?utf-8?B?Smg3c24yUlByak93Zlpqa0lyZmRXc0dyTVAxNkdLQUxHekZGbnNGSkwvWHRR?=
 =?utf-8?B?azViYnpCUVhLTUZ0OThSWkxFM1NuMDFPYVI1S2lGb3NDcEZBNDFLUy9teHZO?=
 =?utf-8?B?Sk9GSWZ1SDFObENBS1ZYQXVKODR6UGRHWGVQaUJyL1hhc1ZMejdLZ3lhcDNL?=
 =?utf-8?B?bk5QUmRWTFBhWG9LWngwbzZFVkZTUTg1bTd0MVFoL2txMGVIaEw0SE85L05P?=
 =?utf-8?B?cjF4RGg5WnArak95eVZsQjNJd0tzeDFmaDJmLy9oZWVBZE96Tmc3S3NZWU1n?=
 =?utf-8?B?aEw2WHJkNThzR1cra1FYZVlReTBxMEo0VHlTK3pNYURWWUlWSE5sejdZWWxn?=
 =?utf-8?B?d255NDMzVTMyVzVCcjdRUUFCMEFDVlY4Q0lYak5IUlpTaUpBRVE2STAwdVAr?=
 =?utf-8?B?RytJNjJ4OXdDb2tGUytRZHNLY1lIT3NCKzRoZ0lNRW5ZS2MrNWxJcUxYS2Nr?=
 =?utf-8?B?T2grTnhSaUZ5RUY5cGY4U2wzeGl3L21CNkxIRVEybnZLL2dPNWRlWWZSQ0ZO?=
 =?utf-8?B?WXVNREdpdzFhZnI4cVJxcHE3bDZFdVB5V3Z2YmFqSi9TME9tODlLYzBtb0Vs?=
 =?utf-8?B?L3JnMHNVNXhYSk5xSjVkNFdxaUVDeGlRZ2s5alh2WllyYlQ2QmpBRjU4M2Rv?=
 =?utf-8?B?RTQ2U0ZNZFNCclg4S0hXRkpSK09IZUhGNTF4aHhJMXk0Q1VwRFhXaEphUzE3?=
 =?utf-8?B?TExYbDl2REdYUEJISURqQUtQMHNrMWZoeWdGVWdRRDBHMi95NEsrRlgzcXkz?=
 =?utf-8?B?NVV6RkFIbmxJOU45Zkh3RjM1NjB6UnVEVHE1L1NSU1Ayc1dRZWtaWFdYWkZl?=
 =?utf-8?B?akVzWWo0Z1hiOVlESkNaMlRRV0N5M0pWT3p3WVZsRXg2UzhvbjBTNFExQlhS?=
 =?utf-8?B?YmZ0eDAyTlZEMXdWTTB6N1V4NmdPL2FFbHRSWVZWZE9kT1hDdmw2bFFveENs?=
 =?utf-8?B?NDI5NUd1enA4alFxV1hBckUwcEdSYlNVMHR5YTRHblNQK2hiMU94Q2JISFJR?=
 =?utf-8?Q?xubj2YKKniM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFp5OElwcm5PRS9qcHpQRFJ6b0xtTHcwNUx2TmRKUWxmek5VbkNhUEhCVzgz?=
 =?utf-8?B?Rmk4SldYMDA5WFFLQlJFdUpkeWhSSGk5cnFMWDh4R0R6V00yNFd6R1FkMFJh?=
 =?utf-8?B?eWlOanU0ckFDU2wyMmc2a3ZCeEUvVkgwOEw5TzZ3K3kyNi83R21GdlJscWUw?=
 =?utf-8?B?NlJZcHNZUHN1NGIyK3hJVFFySTlwVDdtdytRZHA4WHNYd2R0T05OVmMxaXhm?=
 =?utf-8?B?QzdDQ0kyL0ZxelZ4YXM2WEFGRnVyRnpCbHYrQnJVMmgwZDRZZDRlcW9MOU5q?=
 =?utf-8?B?UngwUmw4azh3TWp3eGZsMUcwRHNmNzVqWUpnQVk3ZmVMVUtYTGFTdjF4Qk9V?=
 =?utf-8?B?TnBVNmRtc2xVemw3Zm5zRkhCaVZsREEwMnJ1RnV2eWZucmhIZTMzdGMwUTRl?=
 =?utf-8?B?TDd2Z3ZRYmJNdG4ydDVxZ3Fvcy81eituUTdUb2taNmlMUENGaUI0MmpIVTBp?=
 =?utf-8?B?eVltQUdSN3plZU1raWtQZDRzUER5Rk9oaUJGdFgvOXRmTmllVzdRUXE2QTVx?=
 =?utf-8?B?dXg4eFBrVlVST1RUcnljcnNpeHRpd3JvaXN6a0tLM2pxVGo2K1ZsZUt6MzhJ?=
 =?utf-8?B?Vmg5eEpjcDJ5TmVJZHdqWHpEMzVYT2EvTVVIK3RKZzRpd1VqRmJiRllCZGo4?=
 =?utf-8?B?MDNHNCtONnBJY3hwVG45TGU4K2JlVUd4eDVnYVFpdnJhOGx0Rnl1VDVIQk8y?=
 =?utf-8?B?dVlBZUZETnBhcUlRakFsVUhqQkF6Z0tVWTNOZS9qU3RTSHlBbTIzT3FQMGMz?=
 =?utf-8?B?T3F3WXB6RlgvQTZoKzUyY3diQzlYUVhmaWVaS1ZkRjZ4ZDBaTHd1MDlzVW1J?=
 =?utf-8?B?cDFFd2xFb1l1RjVoSnc4SzIzeDFMMjRaaWcwZHNNdit0R3JEUW1SV014MVZW?=
 =?utf-8?B?eWYzYnVVeG5KbkRkTStmcUZKN1BkUGkzalNtZzdGWEM4QnNyYTlyUTRiM0dB?=
 =?utf-8?B?Q1drVEkvbW14NlRsTDdIRnpqb2k3YkwvNUZzK3gwWURCRmdWcUJvUHpYay91?=
 =?utf-8?B?Q3VwbTFXa3ZEVVBHbVpPbFZMMm9pSkt1cTRCUjltekMvbjRrWUZMOHBGbjRa?=
 =?utf-8?B?b3YwOWtIU0JqdjgvZU1iVmp2QVBQV1JaUW5aakJ2emZTYVQvcEtpL1dUVlB1?=
 =?utf-8?B?U1VBQ3BEYXhSRW5TT2sxZ1ExQU15RFhPbHBhWjlEYnFNbFovRmdsb2tNRk85?=
 =?utf-8?B?ZGd6Mkk5bENkMzZUeVphcC9TS1ZxeE5ZTldvQnJQVHNUeG1ZK3ZkNkkzeThl?=
 =?utf-8?B?ekFMYWpleldXQ3B5NExnODdGd096cGFPdkpKbG5VZkNjOHJUVFJZaGtOMlNw?=
 =?utf-8?B?K2hoU2FiODQ1QllqS3NDekdqSlBaUENwNXlQeEh1dDU1M25RRDF4V2cva2w3?=
 =?utf-8?B?VUhMVmRvbHljQXNBRklmSml0RHNaK3pFcEpIZ1pNTHBYSXJFbVd0TDZJc1Jm?=
 =?utf-8?B?UzdVTjZlS0l6NlM1VzFMQlNJdGt6L3VuOFlYQ01iRGM0WTJmVWFKY2pOWWdH?=
 =?utf-8?B?OHFnVmhHblNhSXBuS2NXKzNJYWYrQU1zREQ2NWNCL3B6VFczMFNPQkNBVGlF?=
 =?utf-8?B?M0lrT3NTSmNEck12TjVRZXVHUDRCMGZhcTR2aEtTZWtta09NSWdwcnRYNi8r?=
 =?utf-8?B?anZGdU55SFZCL1ZVMXF2TGZVdWFxeEMrS0w1aEZPMWlUYjM4dDhxd1RRVGIv?=
 =?utf-8?B?MnRKQ3c1MU5JSWovN1VXRVFHQ0hXbGpQVDZ2d1RDN3ltK1EwZ3FvTURpZkNh?=
 =?utf-8?B?TU9iSkE0emp0NmlEcXlPYmNIb2EyWXBSK2hxY21ncmlnWU9BRmYrd0RRdThD?=
 =?utf-8?B?dlBEdUhBQ3Y1Rk5PQ1drMzBmcmhXRTR5Q1RFcytlMndaclJTQWtqYm9LRnhI?=
 =?utf-8?B?aWtnSUVOZkVyWFhIVitVaHVUL3BqemwvakNDbHFiRC9mTGd1Tzg0b2w1bFhM?=
 =?utf-8?B?TzVOTmpjMWdKd2VUOGQ1OE5DV1dxTUNUYnVNQ0xkcXM4MnJMVFliaGxUOFYr?=
 =?utf-8?B?dEJpK1hMYkRNRzE4WGRPU2NOdTU5bjFLc0M3ZGV0VmtPSXF1MTV3b2FCcmtN?=
 =?utf-8?B?YVlTQ3NxWmV6WkZ0RU84SExZblRNYkNIaTZrcWtXTTl2R0RXSUZOU0lzWnBr?=
 =?utf-8?Q?+LQWcAdoX5JLCDb6+ywevsPZN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31FF03D8E8446C488CAAE2D28CE8C7AC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2bdd88d-e213-4132-7772-08dce261bbae
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2024 21:40:56.8163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M9jA9yFWrs5dm+LOEqLP1i6bjFaEdf60DKIvulhZRK7EvBCJPHz3gTKLfN/XOzUKJqkBnVrOKCFgdjuG2n5ODQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6212
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTEwLTAxIGF0IDA4OjE5IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMS8yNCAwMzo0NCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBQbGVhc2UgbGV0IG1lIGtu
b3cgaWYgeW91IGhhdmUgYW55IGNvbmNlcm4/ICBPdGhlcndpc2UgSSB3aWxsIGdvIHdpdGgNCj4g
PiB0aGlzIHJvdXRlLg0KPiBJIHN0aWxsIHNlZSBzb21lIGxvbmcgdW53aWVsZHkgI2RlZmluZXMg
aW4gdGhlIG1haWwgdGhyZWFkLiAgVGhhdCdzIG15DQo+IGJpZ2dlc3Qgd29ycnkuDQoNCkkgc3Vw
cG9zZSB5b3UgbWVhbiB0aGUgcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoKSBtYWNybz8NCg0KV2Ug
Y2FuIHNwbGl0IHRoYXQgaW50byB0d28gc21hbGxlciBtYWNyb3MgYnkgbW92aW5nIEJVSUxEX0JV
R19PTigpIG91dDoNCg0KLyogRG9uJ3QgdXNlIHRoaXMgZGlyZWN0bHksIHVzZSByZWFkX3N5c19t
ZXRhZGF0YV9yZWFkKCkgaW5zdGVhZC4gKi8NCiNkZWZpbmUgX19yZWFkX3N5c19tZXRhZGF0YV9m
aWVsZChfZmllbGRfaWQsIF92YWxwdHIpICAgXA0KKHsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAgIHU2NCBfX190bXA7ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCiAgICAgICAgaW50IF9fX3JldDsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAgIF9fX3JldCA9IHRk
aF9zeXNfcmQoX2ZpZWxkX2lkLCAmX19fdG1wKTsgICAgICAgIFwNCiAgICAgICAgKl92YWxwdHIg
PSBfX190bXA7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAgIF9fX3Jl
dDsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCn0pDQoNCi8qIEBf
dmFscHRyIG11c3QgYmUgcG9pbnRlciBvZiB1OC91MTYvdTMyL3U2NC4gKi8NCiNkZWZpbmUgcmVh
ZF9zeXNfbWV0YWRhdGFfZmllbGQoX2ZpZWxkX2lkLCBfdmFscHRyKSAgICAgXA0KKHsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAg
IEJVSUxEX0JVR19PTihNRF9GSUVMRF9FTEVfU0laRShfZmllbGRfaWQpICE9ICAgIFwNCiAgICAg
ICAgICAgICAgICAgICAgICAgIHNpemVvZigqX3ZhbHB0cikpOyAgICAgICAgICAgICAgXA0KICAg
ICAgICBfX3JlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKF9maWVsZF9pZCwgX3ZhbHB0cik7ICBcDQp9
KQ0KDQpEb2VzIHRoaXMgbG9vayBnb29kIHRvIHlvdT8NCg==

