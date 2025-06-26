Return-Path: <kvm+bounces-50922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17332AEAAB7
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 01:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1D6B1C40C61
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 23:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8268227E9B;
	Thu, 26 Jun 2025 23:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b6BDACXX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE112264C7;
	Thu, 26 Jun 2025 23:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750980971; cv=fail; b=RV9G8bfbI5hkTorndzPxzU5dqEDaY6WT35MapNt+sNzTfvqv4OwmCdDib4A6b2VCcPrJVB53q8yil11wuZfl2RohRtdk492ekP2RUhirmDPqv9eJoGHi3d+XwQ1la344YOokA7AX5rFfXXNMzvNKmy2Ve6c35bsola4gLJL20Vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750980971; c=relaxed/simple;
	bh=IFkYmpzHx4NHfKaVq/Y9LWf6gNiYdycZI4FDo7QPVkQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DSFrwtkJpBuLWzWVAWStBR7rTgNlAmU2HURzIdSyyyxEGQbCYZptd1nXa0pI5ihqCDijanFCD3Ie3ctu60RYT+QNpXYIlYLkJqf9w8/H5YtUlxGeCQbL4atTcxyRHD7BhhPt1GVStmNlRVL5T01aJ0Xcb2RLrcEBgokBiHwWeV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b6BDACXX; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750980969; x=1782516969;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IFkYmpzHx4NHfKaVq/Y9LWf6gNiYdycZI4FDo7QPVkQ=;
  b=b6BDACXXecTKf65CF+ACRKEaidX80GjV0wkMilP7gJGJfn61XYp9yNQp
   ElvBknseiqIg1W6wsbcI7YFa9dm5A6iNMG07yEFs3Us+apQRBSkG6+wgf
   J5qePgB/2G5dzrMCYUrc/uYExqq8X0FUuDPI3VKPu12mK/rfCPEJE7PUD
   Qvwgxw1KxyPEmHn1YHHCS0vfKF+Z013g5TCmEDRwlI7kZ6EK65NcP0MZX
   iM0WeOhqOIkaAR/Pn1ZYeZ4yTyg3hSRttVcr8JtfkuUq7MzodcUzbn/+D
   IP/+1dzOdU7BEqEW1fc9NLbb1Cj+7bFSIjtfx5XOkhJux09iqx8is3y0f
   g==;
X-CSE-ConnectionGUID: J3U9e8OISDuteRFv87dRAA==
X-CSE-MsgGUID: wlS0+0ozRIuAtYHGomHXAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53017855"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53017855"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 16:36:08 -0700
X-CSE-ConnectionGUID: AtbhFGnwT9uJFd4cHNc7Bw==
X-CSE-MsgGUID: /T0ma4VESOGvyVHBC8l6mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="152826732"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 16:36:08 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 16:36:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 16:36:07 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.42)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 16:36:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vnf2RKxpyKAX54OixsY3yRcsRve9Fxf5oJQpExUfVk+O/GJKh0oMQx+Cu+W4G+5+42ucX3TF7hFkgw21J7AEQ4vF5HvdF7Q7wBbXbOPA8K4P81JRQJY5BysQQ09mT7iEMhzGFzHiVJG1xh6N1ErIz3O+ZMu7XJP6XHhk/+217YFCdYd6gcc+W55RRqAsvI4hgZ+VjeqRY53sMaWeeJgr1cJ/Yr5WHR7y5ygcdRvCBYIIwRK3nGZ8ypIr4YbllUrHHZFbITjalljgMrPwDHhRKlBx+NfOLwUZlNIKUu3b08pBqYDhcBnF/clWQR/4XTWLq6xWzzHQXJe6lgLPcM2bSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFkYmpzHx4NHfKaVq/Y9LWf6gNiYdycZI4FDo7QPVkQ=;
 b=vlyd+oLEGf6RQoZ9FMr6fEwl3QVKLb/0z/SVP3fuZZiKC783WNRKOrBC6WmxMWAGEXtT0/HEqhlB+Z/AlxPg+XkzfW3R2JqGiRvI6B/l5Vt+fQFuWPNN/YjGZ+Mj7sUWQbxg3+H2XYbYED/1yhXHhT59JF0sjUhtCd0voLnyyug/ToG5dMHuwout2e9lmL2cbiqgesr1l7lY2EkKSvilPsZtSplfB99Qvs9+gcDZRqRRT9XvVZIYjfx60lbiReGeDOuhoaoIAUe4EOSLdxWjh4HF7DCBFbhLQV396oUOFQbRpappCzLfRIq3m7dNmwQzd9gdnLiCOlbUlfk0lICYqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Thu, 26 Jun
 2025 23:36:05 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 23:36:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "nik.borisov@suse.com" <nik.borisov@suse.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "sagis@google.com"
	<sagis@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Chen, Farrah" <farrah.chen@intel.com>
Subject: Re: [PATCH v3 2/6] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v3 2/6] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb5ob0DIdF1IdedUu3tc4rNu0nBLQVxaGAgABTdIA=
Date: Thu, 26 Jun 2025 23:36:04 +0000
Message-ID: <0d32d58cb9086906897dada577d9473b04531673.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
		 <323dc9e1de6a2576ca21b9c446480e5b6c6a3116.1750934177.git.kai.huang@intel.com>
	 <554c46b80d9cc6c6dce651f839ac3998e9e605e1.camel@intel.com>
In-Reply-To: <554c46b80d9cc6c6dce651f839ac3998e9e605e1.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW3PR11MB4538:EE_
x-ms-office365-filtering-correlation-id: 931db31a-caa5-430b-86b3-08ddb50a37ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?S1ZOOVA2Ump1eTlTMmowT2NHcWdMTzV0Z2tZS0JnYTFTMTNoV251TStqTXdl?=
 =?utf-8?B?KzZsUjJFT2NmdzZBNmp3Rjl1WWpyL3ptS0lvR25zbEZPdnZrM2RqMFRsQm8z?=
 =?utf-8?B?TlBaNlNvY0dFNmdlZ29qSE44MWpZRUUwZ2tLb0tEWG0zT0t2bVgxLzc4VCtM?=
 =?utf-8?B?WWQvUVFIQ0diRDl0UUhRS04yN1ZndWtrREFGWlYxcE5QTGtxUDlXNFR3Mm5D?=
 =?utf-8?B?SkgxdktKVWdoclEwU2ZUeHZYanJDdEFzRktRNnNPRVZLWUMrNkRVRFpjZXor?=
 =?utf-8?B?WGp3ZmRJd1J1M0dTTkdEak1abjhBUWxvZ1BMeDgwS2tNdjBVQ1RwcXlIandG?=
 =?utf-8?B?NENXTkpOMFFHTWs4Mnl3OWhnck1zcDZTUjkzcDBwK2N0YmxhZ1ErZ3A1MXRP?=
 =?utf-8?B?UUNYbnVUUno1YWtQc1NSRTRvUEg3a1k4VVVGTlpacWpJOFgyZVFzTHBaS0x2?=
 =?utf-8?B?eVpoV1FHMjE2Vm5qVThMbjdCaC9ZUWRYUmsxc0l2ZVRyeGtOdnl6c3JMa1Fa?=
 =?utf-8?B?SDNNaE92bzdlMWU2bVFqczU0ZUFHVnkyN1YrUm1ybWwvRXRESWdZaXVrSVoz?=
 =?utf-8?B?YVJ5alZxZmROYXdvamNMaFNhL3ZoTGNPRXUwVXJGeHBXNmxRZ1Z4ZTZXaGxm?=
 =?utf-8?B?dDZacGlINHowd1hiTGZDTExTVytqSWZTMEkvOTgwWnkyeStqNlVLdERCN2Ja?=
 =?utf-8?B?NEY3NmhWNU8vQXhqL3hwbTZ2ZzNWWG1HalV4QWNVQ2JoTnlQbGlUZk1kYURw?=
 =?utf-8?B?T1Rra3Z1KzB3djYyZ2JoZnF4eExmVHIxbzVEaEtCY2FQTHA2VjBDOEg0WGJu?=
 =?utf-8?B?dFdlK0cyTHVJMHFETWNuOEh6TzNsQkRrTTNFUWlFTGVZZG8wanAzUTZ2aFZt?=
 =?utf-8?B?RFVXVlRBbFlLeWRaRWxYTENibzRCbjV2NXREaVVoK1JvUXA2MXFZVlo1aGZY?=
 =?utf-8?B?b1BpZ3UrSGhjUzZwQStiaVFnRVVMb2Y5R2lueHRMenc0NnI0TnFTTkp3bGQx?=
 =?utf-8?B?V0xwZjlSdmFXS1QreWJxbDBZSXNGRW1qbFZFalUxNS9XMUdGL2hhTE9iRy9L?=
 =?utf-8?B?NzVjV1RDZFVQUkVRc3U4UUVxd0RwN2U1QmlVWVlFUkJObXgxVVRMd0ZYaHBu?=
 =?utf-8?B?TkNQZFBsSWdKcU9xalNORm1LWmF3dkQ0S2tFaEJCL3BuUys5bE5KNGo3emhQ?=
 =?utf-8?B?WVIyMzRpYUNIMGRDZ0xMc1ltTm12VWVQRWVKUlFCMmlKZHVTUVJjb21Ta1pm?=
 =?utf-8?B?anl5VUJMWWhPaFM3ZUJldUJJSVl3L3N5WG5hS2pGTm8xU1AyUHliMlVXei9l?=
 =?utf-8?B?TmV3bHNDYnhnRWg0WjAweFY3WU1neDBMejhodk5TVnlRTjRmRHJKNmU3WWxK?=
 =?utf-8?B?VkdyQXM5aHJQUjN2MVZCZ3diV3RaNkIrWUUreEFVN3NDdml4cExuT1lYbHdH?=
 =?utf-8?B?OVhKQzk2SjdUcGRIR005dnJqendwNFJnOUlDWW52bmNGVEkzV0tlOFE1cDU1?=
 =?utf-8?B?Q3ROZXYwUnZCSVNwbXdtNkNmbm9WaExBRmFzUjNpN2dPMW1udkx0bTdSeE9y?=
 =?utf-8?B?WERmeFlUT0N4aXpyUjFhNUZTWjRNd1pLcXdzNDgxWHJRVWlLaDRjdUNrcHp5?=
 =?utf-8?B?WS9wNERSZHpGems0YXZKUFZ0WVdKRkFFRUhrN3YrQ3BvV28yUWkzamo1dHZ5?=
 =?utf-8?B?N0FaR2dnc1VQMjI3aEVqeUtvN2hheUpKbWwzQjlWdHVIbXFOLzBnMlN5empu?=
 =?utf-8?B?SndMczZqVWpMUG0zZFJadG5PR1l2R1NNL3VrOTBvREZQL1RyTGM5c0piUWph?=
 =?utf-8?B?bXJCZFRFbDJhUUxWZ2M1dmdUNTFHcDVDcU5qTjArVmphTkR4Z3lxbXB5UFps?=
 =?utf-8?B?KzB6V01ibitsQ1dOWlFScFl2a2llUm9iUWgrcll3bjJNb2ZLam1aWXJoWXVk?=
 =?utf-8?B?M3dUVEVNR0NJNUxMb3VyTk13SWQ2bWE5VHNza280V3U2QklIeC9UQUFURXdR?=
 =?utf-8?Q?REXOVpj/2ZV1QvxglZvLfNtBzSapTU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VG8vbU5VWStSY3BoOGdaYWU5cHU3QUV0czhVRDRSeENTVUd0eUF1T3FxTlJR?=
 =?utf-8?B?NFRtQ0YvV3VwakFUdHpRc2Y0RnhBeFkrMEp0UTNEL21NeXJkcCtaNkNnTEFt?=
 =?utf-8?B?dzI0N0RxczdkNXZ4cStWQmdkaXRnbG4yMHRpSTh6WkQ5ajIramNsb1Z2ZVE2?=
 =?utf-8?B?RThhc0hEbjZBWjhTYUphSUtKSW5zN1hKZ1lIeGNzR0VYYlFnWFhCMEw4SUhS?=
 =?utf-8?B?bUVoWWgyVnMwbGFDamFjb2VtL0JNYlNkTVYyY2ZVSzVvcDBUMDRTTWovY2F2?=
 =?utf-8?B?OExoNWYxeFFueHlkUjNFaTlMdHNMNTEzZWxYUFpuVjFSRllMWkZiQytELzlT?=
 =?utf-8?B?aGxaeTFQQXI0TEhQMXk3YVJ6eVpzcTg3UXNXNEt6MlZ2SzM4Z3g4WXpxbEFt?=
 =?utf-8?B?S0p1azRCYVRqMlluejdBRjhtMnZKWVkzU3kzNXNMOC83eUZKbytxTytQc3pE?=
 =?utf-8?B?cnNHaEYweTkwNTJZVDZ1M2txMmFlRERRYk9NdU5jQTVTTzZUdmJSWSt6K04w?=
 =?utf-8?B?SFJLK3pDL0NSSjJsbU5wNU5HMUx5RmlraUs0d0NGdFpFMDRPaUdVNnhPeWt0?=
 =?utf-8?B?anB6WW1LRWZYSXJ0T1htU1B1eHplNVVXbnlERlB2M2JkSndNN3FxaVpaWEJi?=
 =?utf-8?B?Y2pFSUcrakNCU1ZNdlJnNDJRZEd1VVhFSndpSjZ3TG5YZlpDT0JEN3pUNlhG?=
 =?utf-8?B?NDV3dk0zL0hmclBBa1B3ZHZ2aEpVakNDVlkzVURVU0puTzM4ZklhNUVnZzUv?=
 =?utf-8?B?WGtDdVZld0RycjZDS1lQYjBYeHdGK2lYSncyRHBQRVFhMnpyOHM5ejd5QjE4?=
 =?utf-8?B?bGQ5OU5NbzBWNDhIRDNDVUJYR05LZEhJTTU2c2xxS0JERXZCNkdoeExiR3dG?=
 =?utf-8?B?OUdSNEowaFg4cC9FSlh3SThBRVQ1RG1DdGs4SUxDWndWcFowNVlZRGpDbXVJ?=
 =?utf-8?B?N285Qk9rZ0Q3Qnc1WjNZYTdaeVRNbGlrSHUyOSt3Q2FyUDNKRFJkdkpyVGRR?=
 =?utf-8?B?M24rdjBzSjdLUk1MMHRIR0I1VVNvOWd0OVNJcjlZMVBVanZhUEpFK3Q1SmJX?=
 =?utf-8?B?N09jbFVqQ0tjVGhSU0FTNHJXM1F2ZWlPUUxGWE5XMjVEWnA1Q0ZKNzZERkdp?=
 =?utf-8?B?a0dTMVkwSVI3OFA4WURlWllUdFFPUVhwZ1ZQcW9JS1ZnUXJhUW1PdHNkdElz?=
 =?utf-8?B?QnZvV0VyVld5WWtHYXJkR1ZpbkxnT1NMWkRrOVFBbG5Eb2ZQakVYb1BjdW42?=
 =?utf-8?B?UlJiWkJPZ240WWxPUGxKejJ0U2xCaFZzdmE0UzR5OFdMcUorbW0xcy9JNnRw?=
 =?utf-8?B?bFJ1cldhdHFWSVp3bURnQUY0RnlqS1plNzBQZnJ2VGR2LzZFTEhHbS9QRDFS?=
 =?utf-8?B?ZExBbWtSOVZVY1U2QzM2VDZLZVduSDNEdXkwbWFlL08vZ0E3RkVScFZHVlRi?=
 =?utf-8?B?TXRNcENCZEJqdEJwNFRxenNodHpLSVdnekNVVU9SZDRGdDlVWGdBREJMQ2Vq?=
 =?utf-8?B?QzJENGdoRVpvaElvUmRZUFNuUzdhdDZaQVV6ZllQVlg0NEE3MXI1Q2lwa0Vx?=
 =?utf-8?B?RzRIOXNwQTZsbGcwV2ZERm9oRVVndVZ0VXpjTmx1RVVSTFJvNlZIWkNvYkll?=
 =?utf-8?B?RTVFcWtNbEt4MzZ5T1BGNTY0VGFFekJwUnhvTEhrdjhtYjFiYS91TVdydkFv?=
 =?utf-8?B?RFZ2TVdjS2FaRVdFT0lLZER5UFRBdVQ5NDh1QW9JRVJhTjQveHEwV0VhLzFu?=
 =?utf-8?B?RDkraFh2ZENxRmJXTGd4emJQZjFKUHBYaVdUeitDbC9HUXB1SzE2REVMQ3gv?=
 =?utf-8?B?V1ZrSzVLblpSUE9XdS9nUWpNenJsSjVaVktmMWxyd2lqUmxnb0Z5bnNVMGdY?=
 =?utf-8?B?WitNKzhydjhOMVdvQ0ZWMjRHMWVFaFBsUlIyczJ5cWttOElHYXBmeTM4bmhD?=
 =?utf-8?B?Zzdld2h3S2ExQVMvVmhTb2tDRVgzSnhHQU4wWEpXT1JnZ2t4aTY4ZWdMRlpW?=
 =?utf-8?B?ZjR5cjlqV3FreW5iOUtYNWdFakVxN2dOR3l0RVI3aEd4T1QvZFk0MFdRVmtX?=
 =?utf-8?B?YjF2K2krSFcweVlRaEpwdnB4U3VIUlUyeVRTNnpCby9vYUhuc3gzZUkyS0N1?=
 =?utf-8?B?a2RrUlltNHd0ZHFOVnhnN3h2ZU5xZUtCOFlQalpYNVFzYVNsWmRnTUlLVXFW?=
 =?utf-8?B?Tmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7988CBCB6093348B1AC4595E560C684@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 931db31a-caa5-430b-86b3-08ddb50a37ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 23:36:04.9834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UwVgD8WRzrLZcdC/aqwMZnzMUfgaFs627M3XAJMppSiuFXpW19uH3b1iiGkofaJy/6xIJauu9IK4eOdloZ84Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4538
X-OriginatorOrg: intel.com

DQooSSdsbCBmaXggYWxsIHdvcmRpbmcgY29tbWVudHMgYWJvdmUpDQoNCj4gPiANCj4gPiB2MiAt
PiB2MzoNCj4gPiAgLSBDaGFuZ2UgdG8gdXNlIF9fYWx3YXlzX2lubGluZSBmb3IgZG9fc2VhbWNh
bGwoKSB0byBhdm9pZCBpbmRpcmVjdA0KPiA+ICAgIGNhbGwgaW5zdHJ1Y3Rpb25zIG9mIG1ha2lu
ZyBTRUFNQ0FMTC4NCj4gDQo+IEhvdyBkaWQgdGhpcyBjb21lIGFib3V0Pw0KDQpXZSBoYWQgYSAi
bWlzc2luZyBFTkRCUiIgYnVpbGQgd2FybmluZyByZWNlbnRseSBnb3QgZml4ZWQsIHdoaWNoIHdh
cyBjYXVzZWQNCmJ5IGNvbXBpbGVyIGZhaWxzIHRvIGlubGluZSB0aGUgJ3N0YXRpYyBpbmxpbmUg
c2NfcmV0cnkoKScuICBJdCBnb3QgZml4ZWQgYnkNCmNoYW5naW5nIHRvIF9fYWx3YXlzX2lubGlu
ZSwgc28gd2UgbmVlZCB0byB1c2UgX19hbHdheXNfaW5saW5lIGhlcmUgdG9vDQpvdGhlcndpc2Ug
dGhlIGNvbXBpbGVyIG1heSBzdGlsbCByZWZ1c2UgdG8gaW5saW5lIGl0Lg0KDQpTZWUgY29tbWl0
IDBiM2JjMDE4ZTg2YSAoIng4Ni92aXJ0L3RkeDogQXZvaWQgaW5kaXJlY3QgY2FsbHMgdG8gVERY
IGFzc2VtYmx5DQpmdW5jdGlvbnMiKQ0KIA0KPiANCj4gPiAgLSBSZW1vdmUgdGhlIHNlbnN0ZW5j
ZSAibm90IGFsbCBTRUFNQ0FMTHMgZ2VuZXJhdGUgZGlydHkgY2FjaGVsaW5lcyBvZg0KPiA+ICAg
IFREWCBwcml2YXRlIG1lbW9yeSBidXQganVzdCB0cmVhdCBhbGwgb2YgdGhlbSBkby4iIGluIGNo
YW5nZWxvZyBhbmQNCj4gPiAgICB0aGUgY29kZSBjb21tZW50LiAtLSBEYXZlDQo+ID4gDQo+ID4g
LS0tDQo+ID4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oIHwgMjkgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20v
dGR4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiA+IGluZGV4IDdkZGVmM2E2OTg2
Ni4uZDRjNjI0YzY5ZDdmIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Rk
eC5oDQo+ID4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gPiBAQCAtMTAyLDEw
ICsxMDIsMzcgQEAgdTY0IF9fc2VhbWNhbGxfcmV0KHU2NCBmbiwgc3RydWN0IHRkeF9tb2R1bGVf
YXJncyAqYXJncyk7DQo+ID4gIHU2NCBfX3NlYW1jYWxsX3NhdmVkX3JldCh1NjQgZm4sIHN0cnVj
dCB0ZHhfbW9kdWxlX2FyZ3MgKmFyZ3MpOw0KPiA+ICB2b2lkIHRkeF9pbml0KHZvaWQpOw0KPiA+
ICANCj4gPiArI2luY2x1ZGUgPGxpbnV4L3ByZWVtcHQuaD4NCj4gPiAgI2luY2x1ZGUgPGFzbS9h
cmNocmFuZG9tLmg+DQo+ID4gKyNpbmNsdWRlIDxhc20vcHJvY2Vzc29yLmg+DQo+ID4gIA0KPiA+
ICB0eXBlZGVmIHU2NCAoKnNjX2Z1bmNfdCkodTY0IGZuLCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdz
ICphcmdzKTsNCj4gPiAgDQo+ID4gK3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgdTY0IGRvX3NlYW1j
YWxsKHNjX2Z1bmNfdCBmdW5jLCB1NjQgZm4sDQo+ID4gKwkJCQkgICAgICAgc3RydWN0IHRkeF9t
b2R1bGVfYXJncyAqYXJncykNCj4gPiArew0KPiANCj4gU28gbm93IHdlIGhhdmU6DQo+IA0KPiBz
ZWFtY2FsbCgpDQo+IAlzY19yZXRyeSgpDQo+IAkJZG9fc2VhbWNhbGwoKQ0KPiAJCQlfX3NlYW1j
YWxsKCkNCj4gDQo+IA0KPiBkb19zZWFtY2FsbCgpIGlzIG9ubHkgY2FsbGVkIGZyb20gc2NfcmV0
cnkoKS4gV2h5IGFkZCB5ZXQgYW5vdGhlciBoZWxwZXIgaW4gdGhlDQo+IHN0YWNrPyBZb3UgY291
bGQganVzdCBidWlsZCBpdCBpbnRvIHNjX3JldHJ5KCkuDQoNCkl0J3MganVzdCBtb3JlIHJlYWRh
YmxlIGlmIHdlIGhhdmUgdGhlIGRvX3NlYW1jYWxsKCkuICBJdCdzIGFsd2F5cyBpbmxpbmVkDQph
bnl3YXkuDQoNCj4gDQo+IE9oLCBhbmQgX19zZWFtY2FsbF8qKCkgdmFyaWV0eSBpcyBjYWxsZWQg
ZGlyZWN0bHkgdG9vLCBzbyBza2lwcyB0aGUNCj4gZG9fc2VhbWNhbGwoKSBwZXItY3B1IHZhciBs
b2dpYyBpbiB0aG9zZSBjYXNlcy4gU28sIG1heWJlIGRvX3NlYW1jYWxsKCkgaXMNCj4gbmVlZGVk
LCBidXQgaXQgbmVlZHMgYSBiZXR0ZXIgbmFtZSBjb25zaWRlcmluZyB3aGVyZSBpdCB3b3VsZCBn
ZXQgY2FsbGVkIGZyb20uDQo+IA0KPiBUaGVzZSB3cmFwcGVycyBuZWVkIGFuIG92ZXJoYXVsIEkg
dGhpbmssIGJ1dCBtYXliZSBmb3Igbm93IGp1c3QgaGF2ZQ0KPiBkb19kaXJ0eV9zZWFtY2FsbCgp
IHdoaWNoIGlzIGNhbGxlZCBmcm9tIHRkaF92cF9lbnRlcigpIGFuZCBzY19yZXRyeSgpLg0KDQpS
aWdodC4gIEkgZm9yZ290IFRESC5WUC5FTlRFUiBhbmQgVERIX1BIWU1FTV9QQUdFX1JETUQgYXJl
IGNhbGxlZCBkaXJlY3RseQ0KdXNpbmcgX19zZWFtY2FsbCooKS4NCg0KV2UgY2FuIG1vdmUgcHJl
ZW1wdF9kaXNhYmxlKCkvZW5hYmxlKCkgb3V0IG9mIGRvX3NlYW1jYWxsKCkgdG8gc2NfcmV0cnko
KQ0KYW5kIGluc3RlYWQgYWRkIGEgbG9ja2RlcF9hc3NlcnRfcHJlZW1wdGlvbl9kaXNhYmxlZCgp
IHRoZXJlLCBhbmQgdGhlbg0KY2hhbmdlIHRkaF92cF9lbnRlcigpIGFuZCBwYWRkcl9pc190ZHhf
cHJpdmF0ZSgpIHRvIGNhbGwgZG9fc2VhbWNhbGwoKQ0KaW5zdGVhZC4NCg0KPiANCj4gT2ggbm8s
IGFjdHVhbGx5IHNjcmF0Y2ggdGhhdCEgVGhlIGlubGluZS9mbGF0dGVuIGlzc3VlIHdpbGwgaGFw
cGVuIGFnYWluIGlmIHdlDQo+IGFkZCB0aGUgcGVyLWNwdSB2YXJzIHRvIHRkaF92cF9lbnRlcigp
Li4uwqBXaGljaCBtZWFucyB3ZSBwcm9iYWJseSBuZWVkIHRvIHNldA0KPiB0aGUgcGVyLWNwdSB2
YXIgaW4gdGR4X3ZjcHVfZW50ZXJfZXhpdCgpLiBBbmQgdGhlIG90aGVyIF9fc2VhbWNhbGwoKSBj
YWxsZXIgaXMNCj4gdGhlIG1hY2hpbmUgY2hlY2sgaGFuZGxlci4uLg0KDQp0aGlzX2NwdV93cml0
ZSgpIGl0c2VsZiB3b24ndCBkbyBhbnkgZnVuY3Rpb24gY2FsbCBzbyBpdCdzIGZpbmUuDQoNCldl
bGwsIGxvY2tkZXBfYXNzZXJ0X3ByZWVtcHRpb25fZGlzYWJsZWQoKSBkb2VzIGhhdmUgYSBXQVJO
X09OX09OQ0UoKSwgYnV0DQpBRkFJQ1QgdXNpbmcgaXQgaW4gbm9pbnN0ciBjb2RlIGlzIGZpbmU6
DQoNCi8qICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIA0KICogVGhpcyBpbnN0cnVtZW50YXRpb25fYmVnaW4oKSBp
cyBzdHJpY3RseSBzcGVha2luZyBpbmNvcnJlY3Q7IGJ1dCBpdCAgICAgDQogKiBzdXBwcmVzc2Vz
IHRoZSBjb21wbGFpbnRzIGZyb20gV0FSTigpcyBpbiBub2luc3RyIGNvZGUuIElmIHN1Y2ggYSBX
QVJOKCkNCiAqIHdlcmUgdG8gdHJpZ2dlciwgd2UnZCByYXRoZXIgd3JlY2sgdGhlIG1hY2hpbmUg
aW4gYW4gYXR0ZW1wdCB0byBnZXQgdGhlIA0KICogbWVzc2FnZSBvdXQgdGhhbiBub3Qga25vdyBh
Ym91dCBpdC4NCiAqLyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KI2RlZmluZSBfX1dBUk5fRkxBR1MoY29uZF9z
dHIsIGZsYWdzKSAgICAgICAgICAgICAgICAgICAgICAgICAgIFwgICAgICAgICAgDQpkbyB7ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
XCAgICAgICAgICANCiAgICAgICAgX19hdXRvX3R5cGUgX19mbGFncyA9IEJVR0ZMQUdfV0FSTklO
R3woZmxhZ3MpOyAgICAgICAgICBcICAgICAgICAgIA0KICAgICAgICBpbnN0cnVtZW50YXRpb25f
YmVnaW4oKTsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwgICAgICAgICAgDQogICAg
ICAgIF9CVUdfRkxBR1MoY29uZF9zdHIsIEFTTV9VRDIsIF9fZmxhZ3MsIEFOTk9UQVRFX1JFQUNI
QUJMRSgxYikpOyBcICANCiAgICAgICAgaW5zdHJ1bWVudGF0aW9uX2VuZCgpOyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBcICAgICAgICAgIA0KfSB3aGlsZSAoMCkgIA0KDQpXZSBj
YW4gYWxzbyBqdXN0IHJlbW92ZSB0aGUgbG9ja2RlcF9hc3NlcnRfcHJlZW1wdGlvbl9kaXNhYmxl
ZCgpIGluDQpkb19zZWFtY2FsbCgpIGlmIHRoaXMgaXMgcmVhbGx5IGEgY29uY2Vybi4NCg0KPiAN
Cj4gQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8gSXQgc2VlbXMgdGhpcyBwYXRjaCBpcyBpbmNvbXBs
ZXRlLiBJZiBzb21lIG9mIHRoZXNlDQo+IG1pc3NlZCBTRUFNQ0FMTHMgZG9uJ3QgZGlydHkgYSBj
YWNoZWxpbmUsIHRoZW4gdGhlIGp1c3RpZmljYXRpb24gdGhhdCBpdCB3b3Jrcw0KPiBieSBqdXN0
IGNvdmVyaW5nIGFsbCBzZWFtY2FsbHMgbmVlZHMgdG8gYmUgdXBkYXRlZC4NCg0KSSB0aGluayB3
ZSBqdXN0IHdhbnQgdG8gdHJlYXQgYWxsIFNFQU1DQUxMcyBjYW4gZGlydHkgY2FjaGVsaW5lcy4N
Cg0KPiANCj4gDQo+IFNpZGUgdG9waWMuIERvIGFsbCB0aGUgU0VBTUNBTEwgd3JhcHBlcnMgY2Fs
bGluZyBpbnRvIHRoZSBzZWFtY2FsbF8qKCkgdmFyaWV0eQ0KPiBvZiB3cmFwcGVycyBuZWVkIHRo
ZSBlbnRyb3B5IHJldHJ5IGxvZ2ljP8KgDQo+IA0KDQpUaGUgcHVycG9zZSBvZiBkb2luZyBpdCBp
biBjb21tb24gY29kZSBpcyB0aGF0IHdlIGRvbid0IG5lZWQgdG8gaGF2ZQ0KZHVwbGljYXRlZCBj
b2RlIHRvIGhhbmRsZSBydW5uaW5nIG91dCBvZiBlbnRyb3B5IGZvciBkaWZmZXJlbnQgU0VBTUNB
TExzLg0KDQo+IEkgdGhpbmsgbm8sIGFuZCBzb21lIGNhbGxlcnMgYWN0dWFsbHkNCj4gZGVwZW5k
IG9uIGl0IG5vdCBoYXBwZW5pbmcuDQoNCkJlc2lkZXMgVERILlZQLkVOVEVSIFRESC5QSFlNRU0u
UEFHRS5SRE1ELCB3aGljaCB3ZSBrbm93IHJ1bm5pbmcgb3V0IG9mDQplbnRyb3B5IGNhbm5vdCBo
YXBwZW4sIEkgYW0gbm90IGF3YXJlIHdlIGhhdmUgYW55IFNFQU1DQUxMIHRoYXQgImRlcGVuZHMg
b24iDQppdCBub3QgaGFwcGVuaW5nLiAgQ291bGQgeW91IGVsYWJvcmF0ZT8NCg==

