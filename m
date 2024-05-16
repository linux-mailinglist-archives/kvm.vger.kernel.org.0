Return-Path: <kvm+bounces-17531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A698C770F
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 15:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ACE81C225A5
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 13:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D63146D59;
	Thu, 16 May 2024 13:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z4hjjAfi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAC9145B28;
	Thu, 16 May 2024 13:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715864676; cv=fail; b=OR1AeSRVvbldWK4qfW/KlSxZ+LxiHLjfdQkJ4veNmfRI5xbEritaQa5Pi9HipgOKwF8aNB9kDoxDZ8Yh3BbtMl6p6tO0nLHzWdwbS+YoExDyfhsQc00eX5M8GNDnUc9ydBfS3vv8bUyuyyRQ5EcHYl6nKRr0KELR2EYYlgZPJ3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715864676; c=relaxed/simple;
	bh=SfS+0LZALNhYMD8JKFrs3d90faG2ghCLCq6Ef62V0TI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sH3TcvK5Hq1DayPegOfM51YHAPznO7zs122k8ZB8vsxs9JD/SKenaYrY2pf6nFnSUXuwYgpnV3ctWjSb5jza+NhI/btA9hEY0Sd9Lg2CHRVWRuhc9UMVbo6H0RFeB0gN4kjJ3e9+cwNWx10O552E5FE0kTAYl9z0MCbi93Yj8kU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z4hjjAfi; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715864676; x=1747400676;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SfS+0LZALNhYMD8JKFrs3d90faG2ghCLCq6Ef62V0TI=;
  b=Z4hjjAfi/A/30s1Dv9QnRmq6QsaK0uuv+hoWX4S41P/HUn2cCgBwRXrD
   bBji/LRqZ3P8PJdpVYkpRb7AwVRAkaGE9WVy2+HfUBV1/AriY/wk8WQj2
   /7qwVSb2jFDaYI5nrhI5c3aR5tqdiJUma46A5zVFWvt1+ebO5UXfG6FdJ
   VTPbNPygEHDtsNpazKflxDJJet0EzDQu/3TnWnLkBHDIxZCEgVtUOTuqe
   dSaORDF3y56LrqU263Qv0aU+UDEmgdKiWnFE0M2sW/sgoOOPzpmZq+7eb
   XciXgQORgoTAMmSlZUseLhtz1YrcMUk5aIZ2jTb4gsddMgj0ku77/uk4i
   Q==;
X-CSE-ConnectionGUID: uOYzgElHQA+fG8qYlqkbWg==
X-CSE-MsgGUID: 9VfHoUoxT+6GkZtbGoLxag==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="34485226"
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="34485226"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 06:04:35 -0700
X-CSE-ConnectionGUID: PAvlYaezSkOU8yf0xqfFSA==
X-CSE-MsgGUID: HLTFSwyYTHmwH2maGwgstA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="35922181"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 06:04:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 06:04:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 16 May 2024 06:04:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 06:04:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 06:04:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I++NHe5XTKTGf1f2uJB1M43p1wrslwQGQSmDXFgJ6lU5pvtaCrUHPv0hMDHeF+q8imuB1245X2HkP18+X+D7idIbxeVfrekOXXbf4KyWRxPZF2yGinc2fkz6FeeaUfWsDZabu812mRpBNTrGfZNnLvmhB2jyDo+JAo1kx41aS0sjk8Kr5UhAK1uy0vkLI7uQxcxhmJKgkw+iWPTFa+u+ETkA+5tHBhaT9BwwxPYkuPNG0AxKmmsSp+2eGWVUpoOdzu1HwlLEJH4dd/vmqWpsw8prrPFoTMf9DXcgsyS4Zk0qTNQV4qZKSKv12XGOKtfHi8Pc7iNRJHTjX5h78XrFCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfS+0LZALNhYMD8JKFrs3d90faG2ghCLCq6Ef62V0TI=;
 b=Y4icyQdM+Ab2X56dpNW3ffkQGnz1ehRxGUIwlioOPyyzfQvyiouNTzaeF7Pb/0YJmC/hhU+7De65iXd2wsBwnpmK/lk2jDrx7BHekfpacLqB3MhSzQR5KF3TFp5TelIPc6BI1vMgd6yau5DVibgTE/inAPV9k9dbScThTHHArH1yhGXSiukmkviogUfotz0wcqneoKg8slAvRmZknk3T81jP3+D/ZlycWSmunMgd02I+luzRH6FwKCVWh5xNF2LPFWR+cvKk+3H9gYo2eYta1ao9k+MG2eQiXn6OEZrGyl6fYKVU7rrEg12h6Cd0aqNXTYrJ8mpk5MupkS+RgXHoDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6975.namprd11.prod.outlook.com (2603:10b6:510:224::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Thu, 16 May
 2024 13:04:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 13:04:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "sagis@google.com" <sagis@google.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmOz3jiNvsf7Ck6WlN+dtixHHLGZCeMAgAAJxQCAAAs0AIAADfQAgACpjAA=
Date: Thu, 16 May 2024 13:04:26 +0000
Message-ID: <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
	 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
	 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
	 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
In-Reply-To: <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6975:EE_
x-ms-office365-filtering-correlation-id: ada498c5-ae03-4c96-04d1-08dc75a8b730
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?QURsaUxGS2F1M2xKUW5ERDFqaDE5Vm1Fa1cwNkV2S01vZ3gvZzVDTTJUTkRY?=
 =?utf-8?B?UGpPMmlzaDh3cGlKQWRsWThIVlhLMjd1b09MWXFabDR3YnpQOFNYOWduT3F3?=
 =?utf-8?B?NXc4d2RpR3ovOFFUdEZtQTlJRjVFL1VVM1pQRkR0ZDZzRjhMSkk5dGhhY01V?=
 =?utf-8?B?anYyWWF3bkd0T003bWVIVitvWlg1WkdIMEFGbzlOL1daVEFDNHJxWGR0V0JZ?=
 =?utf-8?B?WklzUzM4UWFWR0l4QjlxRzQxY2FHcnZUcFE2c2tyei9GWGNGV3AxSm02R0xq?=
 =?utf-8?B?V1UrbkNnc1FMeWE2VmpnRzFiVmxTRTBPbUZrYUxNT09pZmlaNHk3b3Rsa3Fz?=
 =?utf-8?B?MFdXRnlBRnFQVkxyc2crZzd4aFY2cmtQbWRzK3AzeERnUWNHci9CeW5aeGxi?=
 =?utf-8?B?S0JmNHh6UWJQRzRSa1QvTUJSS3dUelhnK0kxQVhHdlVYOWpSd2o0bkFRcE13?=
 =?utf-8?B?T1VxZTZFUzFZVTZ1RlhnaDBkQkwvNDl3clJRcUFWeGx4UVdYcEM2YXRQaFZQ?=
 =?utf-8?B?NW4xckQvREdTcU9xdTU5c2xkZFUzcm1YdjZTTDVnaHFFQnJ3K0I1TkJpL1VD?=
 =?utf-8?B?dVBKVTZ1bFo3WkhaNkcrWmppSnVTTmVvN0NRSnBvMWZUNlhzZ3hsQ0VFNmd4?=
 =?utf-8?B?R1lOUDVmaVRrRHRWNUVBeHlnOGFxZXpXY3VYeXJCdUpOUXBJdjluOVpIVkxM?=
 =?utf-8?B?Y1lPV1NBTHR1QVg4eld2REt2b2pEMUk2WFY0OXZhYVFKclp6UldJb2NGL1lt?=
 =?utf-8?B?WXNDWXNKaHBlbzhrd29NVU9NZVJrQk5sVFdjUkRiVXRWbTNpZXRQY1BqRzhl?=
 =?utf-8?B?SERLZmhXVWVqUUtQZHFvc0pNanAvV0xmOWxGa3JrRzNDOWV4Y1Rua1I1VDFG?=
 =?utf-8?B?ZmJDUWRZRmJGL01JZ0RCUDdRb0JtNVFYWlU5M2VQZUlOMmdlVHFVM1Y2R2x4?=
 =?utf-8?B?V3lzUWtHZ2VPdFM2MGF6SmlQdDZGTHVCajF5dnV4SDNHY2xrRmlWYS9JdmRl?=
 =?utf-8?B?OGJSRDRkVElYUXF4NFBmS2tYejBoRzJHWExqd1FsUS8zNC80WEV0L1RGQ0J4?=
 =?utf-8?B?Mk1PcTROYlNpSGJuQ2l3RHBnblRxVkZKSHRnWU1kd2Q1cXd5eU9NRTlQYlpw?=
 =?utf-8?B?MEhYN3c4dkR1Q1FKZFU5VXlJTVR0K1pZampuZU9aV0c0VElOQTZCMmNTR254?=
 =?utf-8?B?MjJmTEpwN1dIR0thMWpPRExqcmpua3dkcHhlNjlBWk9ZcVB5dTB6QXBKVHZR?=
 =?utf-8?B?T3lndG5Pc0hLM0ZxcU45WmNid3JSSVVvQWJzTTNpblhRY3pZTzJyL0ZleHNF?=
 =?utf-8?B?YkdCOVlVakNTSm1lRWNVbkk1WW4vQXgvTmNtOG9TNEdzalVGOFBETDl4bXZa?=
 =?utf-8?B?ZVI3aGd4S3piYUQ2ZGJ0RGJtQ2N1c09zUDZLTUFlRHFhZmcwbUdMVkUvWjU0?=
 =?utf-8?B?QThOR2dkeVgvMUZEMGZVb3dxdEI0RjJwWlBnYkJLaTFRb0RCYS90dFQ5Zk5C?=
 =?utf-8?B?RVR4ajdVMStTUEpnRk1Ybll1dnUzL2Y3UWV4ajdEbU4xekpEK0tXVHlWOEUz?=
 =?utf-8?B?UnZnRXpESHIxQ1V5YjVISUZtZjVudUp2eUdYcDl6NnhqckVtcUhCL2lGNkhy?=
 =?utf-8?B?S0ZzOWFLbEd6YlJOWTJRT2JRdFljYVZqNXUrSEhVb0JZNDcxSnRVMFpjeXlH?=
 =?utf-8?B?SG5Wa0hJUDg1VnpMOTlicENXVnVmK1dESXEvRDkweHk2UXI4NFcyUk82LzBw?=
 =?utf-8?B?bGZ6b25RRDYrMkxXR0o2SEF0Z2cySUt5Z0JFOVYzRzRyUlREYW1jcVN2SkFM?=
 =?utf-8?B?b3lYcy9QaU5FODZLTkR2dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnpXSCtYMmR5NnR1QzFYMFlRSzQ4WEo3SUkvTG04Vk1GWTBGQTFMSk5IWDVB?=
 =?utf-8?B?WXVlanZFZGc3bkoweThlYUY3OXpnczY3YkxmUVNwdlhKREdWS0l2cEZLTGFP?=
 =?utf-8?B?KzZ5Z3p2SE01emJ1S0ZCd2lHTURaemJSZHoxbk9hb293Q3V6MEJTUHl4Z1R3?=
 =?utf-8?B?R1ljTEY2ODRLdmZ3K2ZvS29oelJ4WHlqV0VjZktyVVBINEJERlZKTTFwSy8v?=
 =?utf-8?B?c25jVks2QjJXcWdtZXpHYTdDTGZDdHdZK2oweU5ORXQraEoyQ013UWR2S0sx?=
 =?utf-8?B?YWRaU3lvY2VOQzlTbC8rS29pN0V5aG5La0hkMU1yZWd0V2NBV2lRNUFDMGZ1?=
 =?utf-8?B?TTBsSU1NTHFEQmV5cC95b015ZU04dEdMN2NLSWZsdDhXS3hmUlFvNC83eXNp?=
 =?utf-8?B?L2doenZ6aktNdnkrVTY4VnZHMURhSnFJUldISkkwdFB5TDkxWWI1b0ZNWUkr?=
 =?utf-8?B?bG9IRDd0aGpURktlUW13MEhiTDdhd2h1QmNhQW5WUlVTdmhKQ0xGU2RRYmhM?=
 =?utf-8?B?VUF2UEhMamgzR2lWaXYvbzBvR2czVHJHeWtLLy81VmM5TVF6WUVwZXVUNFJs?=
 =?utf-8?B?RTRXSG8xMFhvSzZjNHZxZ0lHN1dOYVlLSnlocitBUFcwUmtiN3dTM2dKWmRv?=
 =?utf-8?B?dnRWRU5zT0hnbmRvQk5GRFFxaFFrSjhTSVExNmRoTDBSRkVYZnBjWTdjZytv?=
 =?utf-8?B?bFZsZzBKL1I5SW5sL2pDZjZjSG5PczlHVmpLSUFra0xRaFh1R3IvZG9YOFQ0?=
 =?utf-8?B?bjNFeVVOcElqa1NDUEpRV1NuaHZIcHNtNHdqZ1lyNkxEc2dac0ZnODRWTnNV?=
 =?utf-8?B?ZWFzcUUrelBXc0l0NytLRmJIck03Y2dtdG4vNFhHQmE2Z0QzT1dnOVRwaFVH?=
 =?utf-8?B?eU5JSkFVZEE2YmJyaEhhWVhSVzV1dmpxaW9QdFNWNlNTRWNxOWRpMjlIVlVZ?=
 =?utf-8?B?OHBGNHBQMnRmcXVoZTVFazZlNmpreC9uTjdsdVlWcmdoS1VBanB4cVJsYUM4?=
 =?utf-8?B?VlMzeDNZU0JaL2VXcXplUGJkZUFvRUVpNlRzZ2NMSnJZYUpwV2pyZlVPdVIy?=
 =?utf-8?B?NmhJc0tLVWxRd3F4U05SaWZUeUl3TkRRMkd3ejRHVlFMdFlxRjRqaUhidmc4?=
 =?utf-8?B?VEFZbVV0ckFPQ1dVeGFjSjdrNDJCR05NMDU0UTc4K3dwZE5XdGhVWHhFQ0lt?=
 =?utf-8?B?R08yRjYxcitvYXdxYk8vbDZJbCtGdzJBQmgwbHVxTVlMdU04UFpUbTZWM2Rk?=
 =?utf-8?B?a1JwNHgxcXJvVU5FUzczVElYSjQ0VjZWdWxJSTU0dkdwYWJoZUU2bDBtM3hM?=
 =?utf-8?B?RXd3bHU2Ym9ZRW0xVHdpb3VjUEVtL00wTlBkc09lVDAxU2NMN3JYZVl4ZnlI?=
 =?utf-8?B?cGlBU2VmY0pZQmczOXZlTnE0UWh0T2ZmaGxGWldMcTQ5NDdmaDY1YUJXRWln?=
 =?utf-8?B?azhrNFg2Z25TZlA5VHppdnRTZHdnK01rTVVFZmpDeHZEblNNQXZZWHFxcG1C?=
 =?utf-8?B?enZmb1pYTDk2S1oxY2NrN0VqYTlJZmE0NCtGTEc2NFBsVWRtWm5nRWdlVER5?=
 =?utf-8?B?Vi8rL3FnbTFpWVNKRFA0eFRQYVdOSjVCN08rbzBCanFta0VnaFRINnBMMzdl?=
 =?utf-8?B?Nk1MVFlNbk1zZjVFanhqeS94bmVPREtOK3JuUU5QbVA2TDNnanU0NVpPaEpL?=
 =?utf-8?B?RmJyU0M0QkU1aTNyekM0TTRUaTJxNU9DN0p2N2pGakdycUxDTUFRYXVzSjV1?=
 =?utf-8?B?YmRDbWJlWXYyRjE3RXN4aXhWa3hqMmZRVnJVdzRZOFl2c0szdVF6OEZaL0k0?=
 =?utf-8?B?RTdUZVhIOWpkbVdQZzJabUR2NUh6ampsWGg2Q244andhSE9aZVlCbFRvcjJS?=
 =?utf-8?B?Ti9sMDRJRmd2VVV2c3pPc0llTGUyVWFicUc5d2hCMW9TL2lzRURMU25lL3k1?=
 =?utf-8?B?dFFLN3RkRnB0VkdsU1BkVURpRURSYWUyVDk5alQ5U1ZTTnlxL25qRjZVZ0lM?=
 =?utf-8?B?Rk5nc1A4RlhibFVDVHp2bytsWDVpaGtIamw3T0lweEVPN2dSVGdHMkxzTlhl?=
 =?utf-8?B?OEhMYlZJRS9kbFBHVXZyTmhwVElxREZWazFoei9oZm1PTlBjclhpZDdmNGdP?=
 =?utf-8?Q?RJDSqlHgwgmp5bQrNr5aDakUC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03C6DF8DFEFCF6498C1C5BF8803E2C5A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ada498c5-ae03-4c96-04d1-08dc75a8b730
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 13:04:26.8076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oibX+9yYhAMtIchHSfLvQgO5Oo71NH46+rQaPJkpxp68amuHwWoTEMslSAmRqRM49ffNm1POdbjSVdHQdYsQRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6975
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDAyOjU3ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gVGh1LCAyMDI0LTA1LTE2IGF0IDE0OjA3ICsxMjAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+IA0KPiA+IEkgbWVhbnQgaXQgc2VlbXMgd2Ugc2hvdWxkIGp1c3Qgc3RyaXAgc2hhcmVk
IGJpdCBhd2F5IGZyb20gdGhlIEdQQSBpbiANCj4gPiBoYW5kbGVfZXB0X3Zpb2xhdGlvbigpIGFu
ZCBwYXNzIGl0IGFzICdjcjJfb3JfZ3BhJyBoZXJlLCBzbyBmYXVsdC0+YWRkciANCj4gPiB3b24n
dCBoYXZlIHRoZSBzaGFyZWQgYml0Lg0KPiA+IA0KPiA+IERvIHlvdSBzZWUgYW55IHByb2JsZW0g
b2YgZG9pbmcgc28/DQo+IA0KPiBXZSB3b3VsZCBuZWVkIHRvIGFkZCBpdCBiYWNrIGluICJyYXdf
Z2ZuIiBpbiBrdm1fdGRwX21tdV9tYXAoKS4NCg0KSSBkb24ndCBzZWUgYW55IGJpZyBkaWZmZXJl
bmNlPw0KDQpOb3cgaW4gdGhpcyBwYXRjaCB0aGUgcmF3X2dmbiBpcyBkaXJlY3RseSBmcm9tIGZh
dWx0LT5hZGRyOg0KDQoJcmF3X2dmbiA9IGdwYV90b19nZm4oZmF1bHQtPmFkZHIpOw0KDQoJdGRw
X21tdV9mb3JfZWFjaF9wdGUoaXRlciwgbW11LCBpc19wcml2YXRlLCByYXdfZ2ZuLCByYXdfZ2Zu
KzEpIHsNCgkJLi4uDQogIAl9DQoNCkJ1dCB0aGVyZSdzIG5vdGhpbmcgd3JvbmcgdG8gZ2V0IHRo
ZSByYXdfZ2ZuIGZyb20gdGhlIGZhdWx0LT5nZm4uICBJbg0KZmFjdCwgdGhlIHphcHBpbmcgY29k
ZSBqdXN0IGRvZXMgdGhpczoNCg0KICAgICAgICAvKg0KICAgICAgICAgKiBzdGFydCBhbmQgZW5k
IGRvZXNuJ3QgaGF2ZSBHRk4gc2hhcmVkIGJpdC4gIFRoaXMgZnVuY3Rpb24gemFwcw0KICAgICAg
ICAgKiBhIHJlZ2lvbiBpbmNsdWRpbmcgYWxpYXMuICBBZGp1c3Qgc2hhcmVkIGJpdCBvZiBbc3Rh
cnQsIGVuZCkgaWYNCiAgICAgICAgICogdGhlIHJvb3QgaXMgc2hhcmVkLg0KICAgICAgICAgKi8N
CiAgICAgICAgc3RhcnQgPSBrdm1fZ2ZuX2Zvcl9yb290KGt2bSwgcm9vdCwgc3RhcnQpOw0KICAg
ICAgICBlbmQgPSBrdm1fZ2ZuX2Zvcl9yb290KGt2bSwgcm9vdCwgZW5kKTsNCg0KU28gdGhlcmUn
cyBub3RoaW5nIHdyb25nIHRvIGp1c3QgZG8gdGhlIHNhbWUgdGhpbmcgaW4gYm90aCBmdW5jdGlv
bnMuDQoNClRoZSBwb2ludCBpcyBmYXVsdC0+Z2ZuIGhhcyBzaGFyZWQgYml0IHN0cmlwcGVkIGF3
YXkgYXQgdGhlIGJlZ2lubmluZywgYW5kDQpBRkFJQ1QgdGhlcmUncyBubyB1c2VmdWwgcmVhc29u
IHRvIGtlZXAgc2hhcmVkIGJpdCBpbiBmYXVsdC0+YWRkci4gIFRoZQ0KZW50aXJlIEBmYXVsdCBp
cyBhIHRlbXBvcmFyeSBzdHJ1Y3R1cmUgb24gdGhlIHN0YWNrIGR1cmluZyBmYXVsdCBoYW5kbGlu
Zw0KYW55d2F5Lg0KDQo+IA0KPiBJbiB0aGUgcGFzdCBJIGRpZCBzb21ldGhpbmcgbGlrZSB0aGUg
cHJpdmF0ZS9zaGFyZWQgc3BsaXQsIGJ1dCBmb3IgZXhlY3V0ZS1vbmx5DQo+IGFsaWFzZXMgYW5k
IGEgZmV3IG90aGVyIHdhY2t5IHRoaW5ncy4NCj4gDQo+IEl0IGFsc28gaGFkIGEgc3ludGhldGlj
IGVycm9yIGNvZGUuIEZvciBhd2hpbGUgSSBoYWQgaXQgc28gR1BBIGhhZCBhbGlhcyBiaXRzDQo+
IChpLmUuIHNoYXJlZCBiaXQpIG5vdCBzdHJpcHBlZCwgbGlrZSBURFggaGFzIHRvZGF5LCBidXQg
dGhlcmUgd2FzIGFsd2F5cyBzb21lDQo+IGNvZGUgdGhhdCBnb3Qgc3VycHJpc2VkIGJ5IHRoZSBl
eHRyYSBiaXRzIGluIHRoZSBHUEEuIEkgd2FudCB0byBzYXkgaXQgd2FzIHRoZQ0KPiBlbXVsYXRp
b24gb2YgUEFFIG9yIHNvbWV0aGluZyBsaWtlIHRoYXQgKGV4ZWN1dGUtb25seSBoYWQgdG8gc3Vw
cG9ydCBhbGwgdGhlDQo+IG5vcm1hbCBWTSBzdHVmZikuDQo+IA0KPiBTbyBpbiB0aGUgbGF0ZXIg
cmV2aXNpb25zIEkgYWN0dWFsbHkgaGFkIGEgaGVscGVyIHRvIHRha2UgYSBHRk4gYW5kIFBGIGVy
cm9yDQo+IGNvZGUgYW5kIHB1dCB0aGUgYWxpYXMgYml0cyBiYWNrIGluLiBUaGVuIGFsaWFzIGJp
dHMgZ290IHN0cmlwcGVkIGltbWVkaWF0ZWx5DQo+IGFuZCBhdCB0aGUgc2FtZSB0aW1lIHRoZSBz
eW50aGV0aWMgZXJyb3IgY29kZSB3YXMgc2V0LiBTb21ldGhpbmcgc2ltaWxhciBjb3VsZA0KPiBw
cm9iYWJseSB3b3JrIHRvIHJlY3JlYXRlICJyYXdfZ2ZuIiBmcm9tIGEgZmF1bHQuDQo+IA0KPiBJ
SVJDIChhbmQgSSBjb3VsZCBlYXNpbHkgYmUgd3JvbmcpLCB3aGVuIEkgZGlzY3Vzc2VkIHRoaXMg
d2l0aCBTZWFuIGhlIHNhaWQgVERYDQo+IGRpZG4ndCBuZWVkIHRvIHN1cHBvcnQgd2hhdGV2ZXIg
aXNzdWUgSSB3YXMgd29ya2luZyBhcm91bmQsIGFuZCB0aGUgb3JpZ2luYWwNCj4gc29sdXRpb24g
d2FzIHNsaWdodGx5IGJldHRlciBmb3IgVERYLg0KPiANCj4gSW4gYW55IGNhc2UsIEkgZG91YnQg
U2VhbiBpcyB3ZWRkZWQgdG8gYSByZW1hcmsgaGUgbWF5IG9yIG1heSBub3QgaGF2ZSBtYWRlIGxv
bmcNCj4gYWdvLiBCdXQgbG9va2luZyBhdCB0aGUgVERYIGNvZGUgdG9kYXksIGl0IGRvZXNuJ3Qg
ZmVlbCB0aGF0IGNvbmZ1c2luZyB0byBtZS4NCg0KWy4uLl0NCg0KPiANCj4gU28gSSdtIG5vdCBh
Z2FpbnN0IGFkZGluZyB0aGUgc2hhcmVkIGJpdHMgYmFjayBpbiBsYXRlciwgYnV0IGl0IGRvZXNu
J3Qgc2VlbQ0KPiB0aGF0IGJpZyBvZiBhIGdhaW4gdG8gbWUuIEl0IGFsc28gaGFzIGtpbmQgb2Yg
YmVlbiB0cmllZCBiZWZvcmUgYSBsb25nIHRpbWUgYWdvLg0KDQpBcyBtZW50aW9uZWQgYWJvdmUs
IHdlIGFyZSBhbHJlYWR5IGRvaW5nIHRoYXQgYW55d2F5IGluIHRoZSB6YXBwaW5nIGNvZGUNCnBh
dGguDQoNCj4gDQo+ID4gDQo+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+ID4gwqAgwqDCoMKgwqDC
oMKgwqDCoH0NCj4gPiA+ID4gPiDCoMKgwqAgDQo+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2t2bS9tbXUvdGRwX2l0ZXIuaCBiL2FyY2gveDg2L2t2bS9tbXUvdGRwX2l0ZXIuaA0KPiA+
ID4gPiA+IGluZGV4IGZhZTU1OTU1OWE4MC4uOGE2NGJjZWY5ZGViIDEwMDY0NA0KPiA+ID4gPiA+
IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX2l0ZXIuaA0KPiA+ID4gPiA+ICsrKyBiL2FyY2gv
eDg2L2t2bS9tbXUvdGRwX2l0ZXIuaA0KPiA+ID4gPiA+IEBAIC05MSw3ICs5MSw3IEBAIHN0cnVj
dCB0ZHBfaXRlciB7DQo+ID4gPiA+ID4gwqAgwqDCoMKgwqDCoMKgwqDCoHRkcF9wdGVwX3QgcHRf
cGF0aFtQVDY0X1JPT1RfTUFYX0xFVkVMXTsNCj4gPiA+ID4gPiDCoCDCoMKgwqDCoMKgwqDCoMKg
LyogQSBwb2ludGVyIHRvIHRoZSBjdXJyZW50IFNQVEUgKi8NCj4gPiA+ID4gPiDCoCDCoMKgwqDC
oMKgwqDCoMKgdGRwX3B0ZXBfdCBzcHRlcDsNCj4gPiA+ID4gPiAtwqDCoMKgwqDCoMKgwqAvKiBU
aGUgbG93ZXN0IEdGTiBtYXBwZWQgYnkgdGhlIGN1cnJlbnQgU1BURSAqLw0KPiA+ID4gPiA+ICvC
oMKgwqDCoMKgwqDCoC8qIFRoZSBsb3dlc3QgR0ZOIChzaGFyZWQgYml0cyBpbmNsdWRlZCkgbWFw
cGVkIGJ5IHRoZSBjdXJyZW50DQo+ID4gPiA+ID4gU1BURQ0KPiA+ID4gPiA+ICovDQo+ID4gPiA+
ID4gwqAgwqDCoMKgwqDCoMKgwqDCoGdmbl90IGdmbjsNCj4gPiA+ID4gDQo+ID4gPiA+IElNSE8g
d2UgbmVlZCBtb3JlIGNsYXJpZmljYXRpb24gb2YgdGhpcyBkZXNpZ24uDQo+ID4gPiANCg0KQnR3
LCBhbm90aGVyIHRoaW5nIGFmdGVyIHNlY29uZCB0aG91Z2h0Og0KDQpTbyByZWdhcmRsZXNzIG9m
IGhvdyB0byBpbXBsZW1lbnQgaW4gS1ZNLCBJSVVDIFREWCBoYXJkd2FyZSByZXF1aXJlcyBiZWxv
dw0KdHdvIG9wZXJhdGlvbnMgdG8gaGF2ZSB0aGUgc2hhcmVkIGJpdCBzZXQgaW4gdGhlIEdQQSBm
b3Igc2hhcmVkIG1hcHBpbmc6DQoNCiAgMSkgU2V0dXAvdGVhcmRvd24gc2hhcmVkIHBhZ2UgdGFi
bGUgbWFwcGluZw0KICAyKSBHUEEgcmFuZ2UgaW4gVExCIGZsdXNoIGZvciBzaGFyZWQgbWFwcGlu
Zw0KDQooSSBraW5kYSBmb3Jnb3QgdGhlIFRMQiBmbHVzaCBwYXJ0IHNvIGJldHRlciBkb3VibGUg
Y2hlY2ssIGJ1dCBJIGd1ZXNzIEkNCmFtID45MCUgc3VyZSBhYm91dCBpdC4pDQoNClNvIGluIHRo
ZSBmYXVsdCBoYW5kbGVyIHBhdGgsIHdlIGFjdHVhbGx5IG5lZWQgdG8gYmUgY2FyZWZ1bCBvZiB0
aGUgR0ZODQpwYXNzZWQgdG8gcmVsZXZhbnQgZnVuY3Rpb25zLCBiZWNhdXNlIGZvciBvdGhlciBv
cGVyYXRpb25zIGxpa2UgZmluZGluZw0KbWVtc2xvdCBiYXNlZCBvbiBHRk4sIHdlIG11c3QgcGFz
cyB0aGUgR0ZOIHcvbyBzaGFyZWQgYml0Lg0KDQpOb3cgdGhlIHRyaWNreSB0aGluZyBpcyBkdWUg
dG8gMSkgdGhlICd0ZHBfaXRlci0+Z2ZuJyBpcyBzZXQgdG8gdGhlDQoicmF3X2dmbiIgd2l0aCBz
aGFyZWQgYml0IGluIG9yZGVyIHRvIGZpbmQgdGhlIGNvcnJlY3QgU1BURSBpbiB0aGUgZmF1bHQN
CmhhbmRsZXIgcGF0aC4gIEFuZCBhcyBhIHJlc3VsdCwgdGhlIGN1cnJlbnQgaW1wbGVtZW50YXRp
b24gc2V0cyB0aGUgc3AtDQo+Z2ZuIHRvIHRoZSAicmF3X2dmbiIgdG9vLg0KDQoJc3AgPSB0ZHBf
bW11X2FsbG9jX3NwKHZjcHUpOw0KCS4uLg0KICAgICAgICB0ZHBfbW11X2luaXRfY2hpbGRfc3Ao
c3AsICZpdGVyKTsNCg0KVGhlIHByb2JsZW0gaXMgaW4gY3VycmVudCBLVk0gaW1wbGVtZW50YXRp
b24sIGl0ZXItPmdmbiBhbmQgc3AtPmdmbiBhcmUNCnVzZWQgaW4gYm90aCBjYXNlczogMSkgcGFn
ZSB0YWJsZSB3YWxrIGFuZCBUTEIgZmx1c2g7IDIpIG90aGVycyBsaWtlDQptZW1zbG90IGxvb2t1
cC4NCg0KU28gdGhlIHJlc3VsdCBpcyB3ZSBuZWVkIHRvIGJlIHZlcnkgY2FyZWZ1bCB3aGV0aGVy
IHdlIHNob3VsZCBzdHJpcCB0aGUNCnNoYXJlZCBiaXQgYXdheSB3aGVuIHVzaW5nIHRoZW0uDQoN
CkUuZy4sIExvb2tpbmcgYXQgdGhlIGN1cnJlbnQgZGV2IGJyYW5jaCwgaWYgSSBhbSByZWFkaW5n
IGNvZGUgY29ycmVjdGx5LA0KaXQgc2VlbXMgd2UgaGF2ZSBidWcgYXJvdW5kIGhlcmU6DQoNCnN0
YXRpYyBpbnQgdGRwX21tdV9tYXBfaGFuZGxlX3RhcmdldF9sZXZlbChzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qg
a3ZtX3BhZ2VfZmF1bHQgKmZhdWx0LA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgc3RydWN0IHRkcF9pdGVyICppdGVyKQ0KeyAgICAgICAgICAgICAgICAgICANCgku
Li4NCg0KICAgICAgICBpZiAodW5saWtlbHkoIWZhdWx0LT5zbG90KSkNCiAgICAgICAgICAgICAg
ICBuZXdfc3B0ZSA9IG1ha2VfbW1pb19zcHRlKHZjcHUsIGl0ZXItPmdmbiwgQUNDX0FMTCk7DQog
ICAgICAgIGVsc2UNCiAgICAgICAgICAgICAgICB3cnByb3QgPSBtYWtlX3NwdGUodmNwdSwgc3As
IGZhdWx0LT5zbG90LCBBQ0NfQUxMLCANCgkJCQlpdGVyLT5nZm4sIGZhdWx0LT5wZm4sIGl0ZXIt
Pm9sZF9zcHRlLCANCgkJCQlmYXVsdC0+cHJlZmV0Y2gsIHRydWUsIA0KCQkJCWZhdWx0LT5tYXBf
d3JpdGFibGUsICZuZXdfc3B0ZSk7DQoJLi4uDQp9DQoNClNlZSBAaXRlci0+Z2ZuICh3aGljaCBp
cyAicmF3X2dmbiIgQUZBSUNUKSBpcyBwYXNzZWQgdG8gYm90aA0KbWFrZV9tbWlvX3NwdGUoKSBh
bmQgbWFrZV9zcHRlKCkuICBCdXQgQUZBSUNUIGJvdGggdGhlIHR3byBmdW5jdGlvbnMgdHJlYXQN
CkdGTiBhcyB0aGUgYWN0dWFsIEdGTi4gIEUuZy4sIA0KDQpib29sIG1ha2Vfc3B0ZShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fbW11X3BhZ2UgKnNwLA0KICAgICAgICAgICAgICAg
Y29uc3Qgc3RydWN0IGt2bV9tZW1vcnlfc2xvdCAqc2xvdCwNCiAgICAgICAgICAgICAgIHVuc2ln
bmVkIGludCBwdGVfYWNjZXNzLCBnZm5fdCBnZm4sIGt2bV9wZm5fdCBwZm4sDQogICAgICAgICAg
ICAgICB1NjQgb2xkX3NwdGUsIGJvb2wgcHJlZmV0Y2gsIGJvb2wgY2FuX3Vuc3luYywNCiAgICAg
ICAgICAgICAgIGJvb2wgaG9zdF93cml0YWJsZSwgdTY0ICpuZXdfc3B0ZSkNCnsNCgkuLi4NCg0K
CWlmIChzaGFkb3dfbWVtdHlwZV9tYXNrKQ0KICAgICAgICAgICAgICAgIHNwdGUgfD0gc3RhdGlj
X2NhbGwoa3ZtX3g4Nl9nZXRfbXRfbWFzaykodmNwdSwgZ2ZuLA0KCQkJCWt2bV9pc19tbWlvX3Bm
bihwZm4pKTsNCgkuLi4NCg0KCWlmICgoc3B0ZSAmIFBUX1dSSVRBQkxFX01BU0spICYmDQoJCQlr
dm1fc2xvdF9kaXJ0eV90cmFja19lbmFibGVkKHNsb3QpKSB7DQogICAgICAgICAgICAgICAgLyog
RW5mb3JjZWQgYnkga3ZtX21tdV9odWdlcGFnZV9hZGp1c3QuICovDQogICAgICAgICAgICAgICAg
V0FSTl9PTl9PTkNFKGxldmVsID4gUEdfTEVWRUxfNEspOw0KICAgICAgICAgICAgICAgIG1hcmtf
cGFnZV9kaXJ0eV9pbl9zbG90KHZjcHUtPmt2bSwgc2xvdCwgZ2ZuKTsNCiAgICAgICAgfQ0KCS4u
Lg0KfQ0KDQpBRkFJQ1QgYm90aCBAZ2ZuIGluIGt2bV94ODZfZ2V0X210X21hc2soKSBhbmQgbWFy
a19wYWdlX2RpcnR5X2luX3Nsb3QoKQ0KbmVlZHMgdGhlIGFjdHVhbCBHRk4uICBUaGV5IG1heSBu
b3QgYmUgYSBjb25jZXJuIGZvciBURFggbm93LCBidXQgSSB0aGluaw0KaXQncyBsb2dpY2FsbHkg
d3JvbmcgdG8gdXNlIHRoZSByYXcgR0ZOLg0KDQpUaGlzIGtpbmRhIGlzc3VlIGlzIGhhcmQgdG8g
ZmluZCBpbiBjb2RlIHdyaXRpbmcgYW5kIHJldmlldy4gIEkgYW0NCnRoaW5raW5nIHdoZXRoZXIg
d2Ugc2hvdWxkIGhhdmUgYSBtb3JlIGNsZWFyIHdheSB0byBhdm9pZCBzdWNoIGlzc3Vlcy4NCg0K
VGhlIGlkZWEgaXMgdG8gYWRkIGEgbmV3ICdyYXdfZ2ZuJyB0byBAdGRwX2l0ZXIgYW5kICdrdm1f
bW11X3BhZ2UnLiAgV2hlbg0Kd2Ugd2FsayB0aGUgR0ZOIHJhbmdlIHVzaW5nIGl0ZXIsIHdlIGFs
d2F5cyB1c2UgdGhlICJhY3R1YWwgR0ZOIiB3L28NCnNoYXJlZCBiaXQuICBMaWtlOg0KDQoJdGRw
X21tdV9mb3JfZWFjaF9wdGUoa3ZtLCBpdGVyLCBtbXUsIGlzX3ByaXZhdGUsIGdmbiwgZ2ZuICsg
MSkgew0KCQkuLi4NCgl9DQoNCkJ1dCBpbiB0aGUgdGRwX2l0ZXJfKigpIGZ1bmN0aW9ucywgd2Ug
aW50ZXJuYWxseSBjYWxjdWxhdGUgdGhlICJyYXdfZ2ZuIg0KdXNpbmcgdGhlICJhY3R1YWwgR0ZO
IiArIHRoZSAna3ZtJywgYW5kIHdlIHVzZSB0aGUgInJhd19nZm4iIHRvIHdhbGsgdGhlDQpwYWdl
IHRhYmxlIHRvIGZpbmQgdGhlIGNvcnJlY3QgU1BURS4NCg0KU28gdGhlIGVuZCBjb2RlIHdpbGwg
YmU6IDEpIGV4cGxpY2l0bHkgdXNlIGl0ZXItPnJhd19nZm4gZm9yIHBhZ2UgdGFibGUNCndhbGsg
YW5kIGRvIFRMQiBmbHVzaDsgMikgRm9yIGFsbCBvdGhlcnMgbGlrZSBtZW1zbG90IGxvb2t1cCwg
dXNlIGl0ZXItDQo+Z2ZuLg0KDQooc3AtPmdmbiBhbmQgc3AtPnJhd19nZm4gY2FuIGJlIHVzZWQg
c2ltaWxhcmx5LCBlLmcuLCBzcC0+cmF3X2dmbiBpcyB1c2VkDQpmb3IgVExCIGZsdXNoLCBhbmQg
Zm9yIG90aGVycyBsaWtlIG1lbXNsb3QgbG9va3VwIHdlIHVzZSBzcC0+Z2ZuLikNCg0KSSB0aGlu
ayBpbiB0aGlzIHdheSB0aGUgY29kZSB3aWxsIGJlIG1vcmUgY2xlYXI/DQoNCg==

