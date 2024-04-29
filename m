Return-Path: <kvm+bounces-16148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC82D8B56F8
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 13:41:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64C2B1F26220
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 11:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3396C46453;
	Mon, 29 Apr 2024 11:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GRVlvVl4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD334C600;
	Mon, 29 Apr 2024 11:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714390891; cv=fail; b=a+9F+P8Nq7+BSod5Wh3pTDwMivgiUOYjSdU7aDGKgRpB08Je/Pp9aStobI8zJ0zgz/MzUYPtyeKm3hd6qihmHT7+wybR/N7ATCsEquVeJchitGw30IS5h2hRXzyBxTT2CCKsc8eZwrVFeEUFt9f4NUZkHUNwWdJFu9/b8EdmL60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714390891; c=relaxed/simple;
	bh=jeKl4yLTKJvd2C5VN+K4izTNpJ1RtG9xW/bdUDHzr8E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YTrtk49DmuqGsvVUbaM26BofjRAAsPip5IhDiR+VQYV4NmdW5pcsIBjP9VEVxf1J2P7DhoownbDzkjqg8phmUi8LP8rw7beylcYPtoe5c3Zl0RU+twd95Ujyux3yGsifNQLeHE+nzGx06SILmGREdne407VWMxnAhiELK+E59tw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GRVlvVl4; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714390888; x=1745926888;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jeKl4yLTKJvd2C5VN+K4izTNpJ1RtG9xW/bdUDHzr8E=;
  b=GRVlvVl4qLGMoeeozThkgkhSkPc967c1FcsaZZuT8fjfLtESH6s3izzL
   n+NENifRG9nEiZmVB5D/MU8gLNNYFiJe6vhRhwa4MV4Cb1cMOHO2VvW0c
   c9X4DO3snwxODhFZ0WjgrTbK1M/Tp2Eqhx3TFs6LQ8Kb5iwuArU1dKxVb
   upmr1qLLEaAL4BTJjkvrKzpsC3RgxsFZDqXNQ4NQPTdjMq3Q9hkBKZtiO
   GOapOhYtvuFfjE1ZtMD1V/iXwG2PCTlQrMwUkx9uCpOoOLNeEtKmEOIW5
   9jyn8zUY/mzCJUkt/gIFHbHJwDT9sY7cWxXvg3UJ1nPwvz3e2rZD/IZGI
   A==;
X-CSE-ConnectionGUID: HZeegCgpR+qwQKImnl6bTQ==
X-CSE-MsgGUID: YEMTC8GuSY2Wdaz35qzanA==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="32546604"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="32546604"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 04:41:28 -0700
X-CSE-ConnectionGUID: lufP8QrwS/CKAhSIQnaNnQ==
X-CSE-MsgGUID: SaZxJW0vR+qJ7dP48Ase/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26067045"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Apr 2024 04:41:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Apr 2024 04:41:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Apr 2024 04:41:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 29 Apr 2024 04:41:27 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Apr 2024 04:41:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcDCO2TqEsdRZxciL9aTw6GjJBm7mGVKZOmuvZFGM37sifIJpMcXec997ACWyhlLan9qNbQYICLcvSs9i3Vx0D+Ds6UOYHENk3Nb4rB4qvdtF/Q508p3dbgMO6XRKme4vfHPs92R8fegYIsZ7w7fFy/a5xay9gv7N8cfNjDJSpnXz2zF6kO75JknsyDNPCieJW6DciMa4yMeCIk+C28x2wk4qtc6BpGxNLNB4tIs3hiICBdYxOOVJGhNfzZhOWF0G+30XQVafHbiA+rIw0qbeXVPXEXjw8PIFPVAvnQVD/Z+BYf39uWNbpCQnKngSJUAXejVohvSmp/5J8ebPSeMHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jeKl4yLTKJvd2C5VN+K4izTNpJ1RtG9xW/bdUDHzr8E=;
 b=gki0BFg+yQkVn73halIPTj5xCWkWj/10fUACx4gaH6PiN/WuUP//ZdQmdVQp9SvmvGiFKsYnjkVzlD0ym2ruhZYq5vfGdhFLuida6XfGC4fj5T0hYT9BtxWRwOaC6b89UntSyoKG9jI2w5MduYKqLbIq9qPBYdi3HC4qekFs+naqzBM04A1iLh2036RmLCl6m/mnH1nHLajSCXL/sMcT8ZZiszgF4zqD+VphIsFTwemhhLiHGfbzi+wtVMZP1k/xV4agsdMzHxCC6El23L6u+tDnVHbMevgBH1yv0olVunVNJ59oiK0uOccuV8I7qp/91RtXn1p3BSo2LA3QFfzy5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM3PR11MB8669.namprd11.prod.outlook.com (2603:10b6:0:14::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7519.34; Mon, 29 Apr 2024 11:41:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 11:41:19 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwCAAEVEAIAAYpQAgAAWqwCAABgFAIAAAz+AgADiNACAAIG7gIAACF2AgAKvtYCAAGWPgIAAAp0AgAWQNIA=
Date: Mon, 29 Apr 2024 11:41:19 +0000
Message-ID: <b2bfc0d157929b098dde09b32c9a3af18835ec57.camel@intel.com>
References: <ZiaWMpNm30DD1A-0@google.com>
	 <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
	 <Zib76LqLfWg3QkwB@google.com>
	 <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
	 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
	 <ZifQiCBPVeld-p8Y@google.com>
	 <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
	 <9c6119dacac30750defb2b799f1a192c516ac79c.camel@intel.com>
	 <ZiqFQ1OSFM4OER3g@google.com>
	 <b605722ac1ffb0ffdc1d3a4702d4e987a5639399.camel@intel.com>
	 <Zircphag9i1h-aAK@google.com>
In-Reply-To: <Zircphag9i1h-aAK@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM3PR11MB8669:EE_
x-ms-office365-filtering-correlation-id: 98cee8f0-e0fc-443b-e035-08dc68414942
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ajdYM3NtenJ0RWtKei9OSWx6eUxKbWs4OGhvQ20yNFU3b0ZXcjFTYWVlZG44?=
 =?utf-8?B?SHZPWXN3L21DZVNBZUxJNFYzcU1lRE5mdk1VeG5wOThXVDdvdm4vZ1FKOTFo?=
 =?utf-8?B?Ky9EMkdyNlZZYXNmUTJ1dlVxZ2I4S3VLL2lCMGgxL1k4NGhuY0NteWMzRzk2?=
 =?utf-8?B?VCtEYVQrNlYxbG8zd3EwczNyeHFMVmFqWjZibDB2ME5yZkxTbzhZbm1saDJW?=
 =?utf-8?B?S2ozeGlGMUJ4amRuTVByMWlUOCtzMjZDalIvYXlIRllYeUdPbENFSjVlRlRZ?=
 =?utf-8?B?UmxFY2dHamZTTzNGd1BkR1NBYTM5TlN5ZnNIYkMrdDJsbzFXcURGV1Y2bzhz?=
 =?utf-8?B?ZE9ReE1MQlZKT2VvcXEvNUtTbitQbVB6SU15Rkk2UEFWWGZVbGVYTGRPVmtj?=
 =?utf-8?B?TUpNMS9vNlpISGR4Z040MUtKa21UM0x0QXRObGloOE5uNnNiYTZuZG5IY1ky?=
 =?utf-8?B?eGF5Tk8zSktlM1VicC8xa1NIODVlaXdnRSsvRyt3eVZmNkx5Mks4UWJtd2cr?=
 =?utf-8?B?QkNORmNEdlNDZEphZmthMWxkaFVpVkdmT3FvOEZORDN6N3NKKzNtUmMyditw?=
 =?utf-8?B?dFRPcmtnUVcvbHd0RkxWdUZDUkQ2b2Q1REp0Witud1lKanFXU2N0a2xjb2dX?=
 =?utf-8?B?ckp0MENXUDhEMlYydUgvcEh5dGNGdm5GSlBVUmJYR2gxWmJxNXNTRTBOVTlv?=
 =?utf-8?B?b0FuQTNuclpuM1ZIZFBYWTRCQXpTenhadnB3VDZVeDFkVXNHWXFzQUJpNUVz?=
 =?utf-8?B?TkVSSzJnTXFRREV4Y3dJOHJMTldZa3AxYW5QbmpPRHRMWjdGekpyY08rR1pR?=
 =?utf-8?B?L3kyK3cvckxkdjhUU29zQkRyNWd5ZFowNC84eFlsTkZndnh5R1dwTjVWbENs?=
 =?utf-8?B?NU4zakpRMmFCQXRlQjA4RmlKTS9CV0ZJY0NZc2xUZUM3WGlqRVQ4V1Z5N1hy?=
 =?utf-8?B?cUFtcmI1dXJ5aGxWbno2OTRrTC9Qb3hIbFo0c1ZPajlEcWRLTTdMY3k0VG5F?=
 =?utf-8?B?a2hlU3haWUVJM3BPc1E2ZGpTOVNGaTc1N01pUFNLSDhJZTArK3A2TW10VlFk?=
 =?utf-8?B?Z3I2Q1d6SFZWWjZJeUJOS0FnNXg2dG5acFY1VXNyUHc0VG14ZVpCTVJaRHhy?=
 =?utf-8?B?SFlsNzV6L1VDdktjbTA4b3c1eVRzM3dwOVZoZzFxSE4zbEtFWGNxeDcrRkli?=
 =?utf-8?B?cjZ0Ri85b2VhdTVLdVFYZUFuOEUrL2o2ZVdwVHFJSFBsN3oreTNjMUY3L0pX?=
 =?utf-8?B?VkFYdUl4Q1czbGJTQlMyR0RyZFVsTDhOMldINmZiZmQxMGFWUFJsSk8vUjZT?=
 =?utf-8?B?dFhmaFl3eXVJelhGYUFDeS9MR3NwNHpMZC9oR0ViaGFxQkVVRmpQbXNpY1Mz?=
 =?utf-8?B?U1VGS2dUdlU5bU5lU3V3MzRoZm5CZFpSS0RDRTFVa2d6bnNXT1VjTGE4Misw?=
 =?utf-8?B?T1dRMlBEMnUveUlQSTVxSWkxWlovZVk4QVhicnBjaFRCb2NGbnR2R3ZWclN2?=
 =?utf-8?B?MjhleUpXSTlwdXArVjZpYko1azhhV0dURWhkV1NXU2J3MDQ4Um0vM21qVFh4?=
 =?utf-8?B?STE2WDZyaTRpTnp3YlRJUGFaNnh4bEN5ZHhaeGNEK3RPbERlOFFwK3N6cHIy?=
 =?utf-8?B?QytWUjVjNU8vbmpDT0V4OVZrOXI2SllTa2lhZU5rcElqeDIxVXJiVlRkQU1W?=
 =?utf-8?B?aEJoSWx4TkdHYi9MeGwyS3hMVVVTTGxhaXhXMTRHRjFQRHUzOUwwTklRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ak9uOWZqQjlSbWVXZ3Q3Y0k0WUtoZXFsRWdObXIvMGJyZFQyR2NocGVDSDBK?=
 =?utf-8?B?Wmk3NzNwTkh3WWc2MS9hVzE4R25SYzdZVXBISVQvMTZBd202TTZPUTQyWFpx?=
 =?utf-8?B?SzRZeWhIUU12SDM0a1IwV05MV3RsRFUvbWdJTXg5d3BIRDN1b2JmNW4yV0Ni?=
 =?utf-8?B?RW1LRmlNWUtOTVQxK1ZyTnRiSlhmRVdJQ2ZuTldiMVF1SE5QZENXZ29QbmI5?=
 =?utf-8?B?Y2Q0eGhNbG4vS3lqZzV5Um56bVBrUFhpOFNITjZIdWlmeUtHQ0ZidnJpQ3pC?=
 =?utf-8?B?b1VQa08vcHpoalQ1M2hxSDNyQ3hFazhSL0tFcjFtM3B0eHMzbk1MeTdVQVpy?=
 =?utf-8?B?WVZwNnhFekpRNjZNSUx1ZjQxeE5mb1JNeGg2Y3NTZ1lNaXJKdmQ1L2RuU2J6?=
 =?utf-8?B?VUdTSDgrMXVVK3FPVlROSnk3SHV2TW9ZS2E0S1FYR0NXZ3BIc3ZBQy9kR0Fm?=
 =?utf-8?B?d1hpL3JzYkZiWHBEckw3SFZGZ3BmUWROZVdzeGs0elVFMDhjSmdWL25UMXk5?=
 =?utf-8?B?UHRKVW90YituVWUvTFg1VVVQVEFTT1B6ZWRZd2Fmbzd6VXZjOE1PelYySnhv?=
 =?utf-8?B?R1J2V1UycHozQWdjVzJWV0MxdzgzMXphaFI2RVBENHovT01wWjdmMVJkaGEz?=
 =?utf-8?B?cTJGRE5JWTZhWXpBR0RmTTFFZmUwRzFjNzFzSEkxUW9YZFRnS1pSZlZKZUpH?=
 =?utf-8?B?eEFLNmVTR0RMYmFuNFVBb1J6czIyNWU5eXcwZUl6b3lzcnVBWERPTUVsZVJP?=
 =?utf-8?B?SDVxRUNmaDlIQXZqZGxsSWVNUkVwRXpIR3k5b3h1bzlsc2x6SmcyU01sUEE5?=
 =?utf-8?B?Q214MGduRFJxNHl1MzR2ZmVneEdrWUVBY2kzbWFGSlF2d2VwOVhSZTY5RjMw?=
 =?utf-8?B?NHd1R2RPSEpOQWZNRStMODgxMFg5azVoYzBaajJ4UWt6RlRrM2hGREJJSTNx?=
 =?utf-8?B?K2xxd2srRXkxazltVjZvcWR4YXRRQkRVNk8zYkk1eVhVQ2RVWUNVZ29GOHZm?=
 =?utf-8?B?RDdaZ2h6WTVINEg5Nnp3Y2F1TjMvVkNKMGs0MUhtTWg3T1p5anREaEZLOUFL?=
 =?utf-8?B?UmtXQ2tZOUdFVEowTDIwbE54TFJQV1d0bEE4QSswQ21FRHpxSE1EMFlQNFNo?=
 =?utf-8?B?Y2NvUXU1azZnZzE4cVpmbmF5d1RZamovSjRnbUI0cFNXV25hQ1doZVZuQmhU?=
 =?utf-8?B?R0RmUFJTNmlCN3p4LzFvS0NJK01TRmVIL1R2Q3FCY0w2TmViOGhqSnVKNGJs?=
 =?utf-8?B?dExabDZYNEUzR3lBczFqcjhBZ3BGMkRTY3U0Q0ptcmlNanNlMlNERW94eE5N?=
 =?utf-8?B?R1pHeDRGNUphejZLM1JBTzcrbC9zdFNxTVlyai9zRWd2Zm01YzdMOVN3RmxH?=
 =?utf-8?B?K3VwSVpIb3dxVWpVRVEzSGFoTWs0ZnJGRGlLKzA0R3loYXJUU1VwM1hjVzR6?=
 =?utf-8?B?VUxyb2o2QzJQcGR6WkFEeXdRbEsxc2lzYUJqQ21rU2kzY2Y4QmhCRUl6Z2dC?=
 =?utf-8?B?UkFIcXhicWs4dmZEWXltUFhtdTFDLzEwNkxFcnVlc0dvVlY4blU0Uk1HdVFO?=
 =?utf-8?B?NEdNaGhPMGFXQVNRakpmN3FiNkFJT2JtZUVBaFZEaVlJcm5NZ2pmTzlXQkZm?=
 =?utf-8?B?MlBsZTA4R1ArMmZPQndWaHNnTGdQeVY5d1hFNmtzdTNMN2NNNUFWbWlpSTdP?=
 =?utf-8?B?S0lJaDNBb1AvWmVkV2lNWmlJcWhKUjBaNE9BSlZuN21tM0NDS1ZvYTBoM2pp?=
 =?utf-8?B?ZUlKZTRvZnZlRHl6enVTallKZ3hQMTh0L1NwaFZJR2p4SUszK1k1TXNmQTUv?=
 =?utf-8?B?ZndNdUVkaUtla20yNEtURWFXU3dMaVIzbUJzaEN1K1RWQXlXdThwdWdyQjJX?=
 =?utf-8?B?NngxdHdjZWlTUjlpYXpwS2RGOGREOWIrYnJYNFFscjgzSlNoN2JrN09aRzU1?=
 =?utf-8?B?a1BTZnRVdDd4eklscEFReVhvTjF3MXhHSzB6eWJNK3Z1ZTBGQUtwQ0pjMW9l?=
 =?utf-8?B?Q205aCtOUzRSaXVmSkQ2Ukd5ZVhnQ2RweVduVjUzVnVpNEFVNzJvOW4yZjFR?=
 =?utf-8?B?WkgzZzl1dlBOa2ZxbTZRTEpJSnVaQmxza1pmRW5pTnoyZGM3ZUI5bEowcy9K?=
 =?utf-8?B?Sy9nM0tIMkkwcG1TZU5LMFdJNCt3Rm5xRHRGMzNuWjgvMVUvSU9JeE5kZnZX?=
 =?utf-8?B?QVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <896D43C755998D4DA524B250374153CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98cee8f0-e0fc-443b-e035-08dc68414942
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2024 11:41:19.0815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NhlQxnDAk8VYk1leDdoz6Igl8J4q2thMQ9PzNDVSTrueVp6sNRjWSkc+ClARi7stocf/d4BHOO2+vgloilPWhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8669
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDE1OjQzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAyNSwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNC0wNC0yNSBhdCAwOTozMCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFR1ZSwgQXByIDIzLCAyMDI0LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiBBbmQg
YW5lY2RvdGFsbHksIEkga25vdyBvZiBhdCBsZWFzdCBvbmUgY3Jhc2ggaW4gb3VyIHByb2R1Y3Rp
b24gZW52aXJvbm1lbnQgd2hlcmUNCj4gPiA+IGEgVk1YIGluc3RydWN0aW9uIGhpdCBhIHNlZW1p
bmdseSBzcHVyaW91cyAjVUQsIGkuZS4gaXQncyBub3QgaW1wb3NzaWJsZSBmb3IgYQ0KPiA+ID4g
dWNvZGUgYnVnIG9yIGhhcmR3YXJlIGRlZmVjdCB0byBjYXVzZSBwcm9ibGVtcy4gIFRoYXQncyBv
YnZpb3VzbHkgX2V4dHJlbWVseV8NCj4gPiA+IHVubGlrZWx5LCBidXQgdGhhdCdzIHdoeSBJIGVt
cGhhc2l6ZWQgdGhhdCBzYW5pdHkgY2hlY2tpbmcgQ1I0LlZNWEUgaXMgY2hlYXAuDQo+ID4gDQo+
ID4gWWVhaCBJIGFncmVlIGl0IGNvdWxkIGhhcHBlbiBhbHRob3VnaCB2ZXJ5IHVubGlrZWx5Lg0K
PiA+IA0KPiA+IEJ1dCBqdXN0IHRvIGJlIHN1cmU6DQo+ID4gDQo+ID4gSSBiZWxpZXZlIHRoZSAj
VUQgaXRzZWxmIGRvZXNuJ3QgY3Jhc2ggdGhlIGtlcm5lbC9tYWNoaW5lLCBidXQgc2hvdWxkIGJl
DQo+ID4gdGhlIGtlcm5lbCB1bmFibGUgdG8gaGFuZGxlICNVRCBpbiBzdWNoIGNhc2U/DQo+IA0K
PiBDb3JyZWN0LCB0aGUgI1VEIGlzIGxpa2VseSBub3QgKGltbWVkaWF0ZWx5KSBmYXRhbC4NCj4g
PiANCj4gPiBJZiBzbywgSSBhbSBub3Qgc3VyZSB3aGV0aGVyIHRoZSBDUjQuVk1YIGNoZWNrIGNh
biBtYWtlIHRoZSBrZXJuZWwgYW55DQo+ID4gc2FmZXIsIGJlY2F1c2Ugd2UgY2FuIGFscmVhZHkg
aGFuZGxlIHRoZSAjVUQgZm9yIHRoZSBTRUFNQ0FMTCBpbnN0cnVjdGlvbi4NCj4gDQo+IEl0J3Mg
bm90IGFib3V0IG1ha2luZyB0aGUga2VybmVsIHNhZmVyLCBpdCdzIGFib3V0IGhlbHBpbmcgdHJp
YWdlL2RlYnVnIGlzc3Vlcy4NCj4gDQo+ID4gWWVhaCB3ZSBjYW4gY2xlYXJseSBkdW1wIG1lc3Nh
Z2Ugc2F5aW5nICJDUFUgaXNuJ3QgaW4gVk1YIG9wZXJhdGlvbiIgYW5kDQo+ID4gcmV0dXJuIGZh
aWx1cmUgaWYgd2UgaGF2ZSB0aGUgY2hlY2ssIGJ1dCBpZiB3ZSBkb24ndCwgdGhlIHdvcnN0IHNp
dHVhdGlvbg0KPiA+IGlzIHdlIG1pZ2h0IG1pc3Rha2VubHkgcmVwb3J0ICJDUFUgaXNuJ3QgaW4g
Vk1YIG9wZXJhdGlvbiIgKGN1cnJlbnRseSBjb2RlDQo+ID4ganVzdCB0cmVhdHMgI1VEIGFzIENQ
VSBub3QgaW4gVk1YIG9wZXJhdGlvbikgd2hlbiBDUFUgZG9lc24ndA0KPiA+IElBMzJfVk1YX1BS
T0NCQVNFRF9DVExTM1s1XS4NCj4gPiANCj4gPiBBbmQgZm9yIHRoZSBJQTMyX1ZNWF9QUk9DQkFT
RURfQ1RMUzNbNV0gd2UgY2FuIGVhc2lseSBkbyBzb21lIHByZS1jaGVjayBpbg0KPiA+IEtWTSBj
b2RlIGR1cmluZyBtb2R1bGUgbG9hZGluZyB0byBydWxlIG91dCB0aGlzIGNhc2UuDQo+ID4gDQo+
ID4gQW5kIGluIHByYWN0aWNlLCBJIGV2ZW4gYmVsaWV2ZSB0aGUgQklPUyBjYW5ub3QgdHVybiBv
biBURFggaWYgdGhlDQo+ID4gSUEzMl9WTVhfUFJPQ0JBU0VEX0NUTFMzWzVdIGlzIG5vdCBzdXBw
b3J0ZWQuICBJIGNhbiBjaGVjayBvbiB0aGlzLg0KPiANCj4gRWgsIEkgd291bGRuJ3Qgd29ycnkg
YWJvdXQgdGhhdCB0b28gbXVjaC4gIFRoZSBvbmx5IHJlYXNvbiBJIGJyb3VnaHQgdXAgdGhhdA0K
PiBjaGVjayB3YXMgdG8gY2FsbCBvdXQgdGhhdCB3ZSBjYW4ndCAqa25vdyogd2l0aCAxMDAlIGNl
cnRhaW50eSB0aGF0IFNFQU1DQUxMDQo+IGZhaWxlZCBkdWUgdG8gdGhlIENQVSBub3QgYmVpbmcg
cG9zdC1WTVhPTi4NCg0KT0sgKHRob3VnaCBJIHRoaW5rIHdlIGNhbiBydWxlIG91dCBvdGhlciBj
YXNlcyBieSBhZGRpbmcgbW9yZSBjaGVja3MgZXRjKS4NCg0KPiANCj4gPiA+IFByYWN0aWNhbGx5
IHNwZWFraW5nIGl0IGNvc3RzIG5vdGhpbmcsIHNvIElNTyBpdCdzIHdvcnRoIGFkZGluZyBldmVu
IGlmIHRoZSBvZGRzDQo+ID4gPiBvZiBpdCBldmVyIGJlaW5nIGhlbHBmdWwgYXJlIG9uZS1pbi1h
bmQtbWlsbGlvbi4NCj4gPiANCj4gPiBJIHRoaW5rIHdlIHdpbGwgbmVlZCB0byBkbyBiZWxvdyBh
dCBzb21ld2hlcmUgZm9yIHRoZSBjb21tb24gU0VBTUNBTEwNCj4gPiBmdW5jdGlvbjoNCj4gPiAN
Cj4gPiAJdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPiAJaW50IHJldCA9IC1FSU5WQUw7DQo+ID4g
DQo+ID4gCWxvY2FsX2lycV9zYXZlKGZsYWdzKTsNCj4gPiANCj4gPiAJaWYgKFdBUk5fT05fT05D
RSghKF9fcmVhZF9jcjQoKSAmIFg4Nl9DUjRfVk1YRSkpKQ0KPiA+IAkJZ290byBvdXQ7DQo+ID4g
DQo+ID4gCXJldCA9IHNlYW1jYWxsKCk7DQo+ID4gb3V0Og0KPiA+IAlsb2NhbF9pcnFfcmVzdG9y
ZShmbGFncyk7DQo+ID4gCXJldHVybiByZXQ7DQo+ID4gDQo+ID4gdG8gbWFrZSBpdCBJUlEgc2Fm
ZS4NCj4gPiANCj4gPiBBbmQgdGhlIG9kZCBpcyBjdXJyZW50bHkgdGhlIGNvbW1vbiBTRUFNQ0FM
TCBmdW5jdGlvbnMsIGEuay5hLA0KPiA+IF9fc2VhbWNhbGwoKSBhbmQgc2VhbWNhbGwoKSAodGhl
IGxhdHRlciBpcyBhIG1vY3JvIGFjdHVhbGx5KSwgYm90aCByZXR1cm4NCj4gPiB1NjQsIHNvIGlm
IHdlIHdhbnQgdG8gaGF2ZSBzdWNoIENSNC5WTVggY2hlY2sgY29kZSBpbiB0aGUgY29tbW9uIGNv
ZGUsIHdlDQo+ID4gbmVlZCB0byBpbnZlbnQgYSBuZXcgZXJyb3IgY29kZSBmb3IgaXQuDQo+IA0K
PiBPaCwgSSB3YXNuJ3QgdGhpbmtpbmcgdGhhdCB3ZSdkIGNoZWNrIENSNC5WTVhFIGJlZm9yZSAq
ZXZlcnkqIFNFQU1DQUxMLCBqdXN0DQo+IGJlZm9yZSB0aGUgVERILlNZUy5MUC5JTklUIGNhbGws
IGkuZS4gYmVmb3JlIHRoZSBvbmUgdGhhdCBpcyBtb3N0IGxpa2VseSB0byBmYWlsDQo+IGR1ZSB0
byBhIHNvZnR3YXJlIGJ1ZyB0aGF0IHJlc3VsdHMgaW4gdGhlIENQVSBub3QgZG9pbmcgVk1YT04g
YmVmb3JlIGVuYWJsaW5nDQo+IFREWC4NCj4gDQo+IEFnYWluLCBteSBpbnRlbnQgaXMgdG8gYWRk
IGEgc2ltcGxlLCBjaGVhcCwgYW5kIHRhcmdldGVkIHNhbml0eSBjaGVjayB0byBoZWxwDQo+IGRl
YWwgd2l0aCBwb3RlbnRpYWwgZmFpbHVyZXMgaW4gY29kZSB0aGF0IGhpc3RvcmljYWxseSBoYXMg
YmVlbiBsZXNzIHRoYW4gcm9jaw0KPiBzb2xpZCwgYW5kIGluIGZ1bmN0aW9uIHRoYXQgaGFzIGEg
YmlnIGZhdCBhc3N1bXB0aW9uIHRoYXQgdGhlIGNhbGxlciBoYXMgZG9uZQ0KPiBWTVhPTiBvbiB0
aGUgQ1BVLg0KDQpJIHNlZS4NCg0KKFRvIGJlIGZhaXIsIHBlcnNvbmFsbHkgSSBkb24ndCByZWNh
bGwgdGhhdCB3ZSBldmVyIGhhZCBhbnkgYnVnIGR1ZSB0bw0KImNwdSBub3QgaW4gcG9zdC1WTVhP
TiBiZWZvcmUgU0VBTUNBTEwiLCBidXQgbWF5YmUgaXQncyBqdXN0IG1lLiA6LSkuKQ0KDQpCdXQg
aWYgdGR4X2VuYWJsZSgpIGRvZXNuJ3QgY2FsbCB0ZHhfY3B1X2VuYWJsZSgpIGludGVybmFsbHks
IHRoZW4gd2Ugd2lsbA0KaGF2ZSB0d28gZnVuY3Rpb25zIG5lZWQgdG8gaGFuZGxlLg0KDQpGb3Ig
dGR4X2VuYWJsZSgpLCBnaXZlbiBpdCdzIHN0aWxsIGdvb2QgaWRlYSB0byBkaXNhYmxlIENQVSBo
b3RwbHVnIGFyb3VuZA0KaXQsIHdlIGNhbiBzdGlsbCBkbyBzb21lIGNoZWNrIGZvciBhbGwgb25s
aW5lIGNwdXMgYXQgdGhlIGJlZ2lubmluZywgbGlrZToNCg0KCW9uX2VhY2hfY3B1KGNoZWNrX2Ny
NF92bXgoKSwgJmVyciwgMSk7DQoNCkJ0dywgcGxlYXNlIGFsc28gc2VlIG15IGxhc3QgcmVwbHkg
dG8gQ2hhbyB3aHkgSSBkb24ndCBsaWtlIGNhbGxpbmcNCnRkeF9jcHVfZW5hYmxlKCkgaW5zaWRl
IHRkeF9lbmFibGUoKToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8xZmQxN2M5MzFk
NWMyZWZmY2YxMTA1YjYzZGVhYzhlM2ZiMTY2NGJjLmNhbWVsQGludGVsLmNvbS8NCg0KVGhhdCBi
ZWluZyBzYWlkLCBJIGNhbiB0cnkgdG8gYWRkIGFkZGl0aW9uYWwgcGF0Y2goZXMpIHRvIGRvIENS
NC5WTVggY2hlY2sNCmlmIHlvdSB3YW50LCBidXQgcGVyc29uYWxseSBJIGZvdW5kIGhhcmQgdG8g
aGF2ZSBhIHN0cm9uZyBqdXN0aWZpY2F0aW9uIHRvDQpkbyBzby4NCg0K

