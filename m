Return-Path: <kvm+bounces-18088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9D78CDD42
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 01:12:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E2241C21FBA
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 23:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CCE128809;
	Thu, 23 May 2024 23:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iEelBT9g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75BF126F27;
	Thu, 23 May 2024 23:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716505940; cv=fail; b=rz0ufjoNgVKJ1Wn+BuJQgOYnk1zF7tVRJ/6jicmhZA2Ig7sUWHN/3xMwguRvb2J64TrMKM5WWzUd2UbYaBJfs49OxuU94R4+Jnlt3wtwXB4Ehrw3DV4m0k8sPFrFwc3/e5GMZeDHJHWgy0oZio6cOp4h9Dtg+7A/gCq2l0d5uxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716505940; c=relaxed/simple;
	bh=KM/kkkj11dWAIb64+s0XVTe7Wt2fyXgNtEwvTMOy4l0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RlDHL/Bz+8Vvn/c5Jh3NDqd6YcffS8iB0wJ7+ZJdlHf2KRL++goPXDvuoilo2ydpBgaO0d3LmTKvz0vGaowSNfF+dvtoTbKWLEeOLOvUu8sX0mJpU9krwrU3IpLy18tcV52oGJECaWDUpFCU8b/IUeHtGJQL74GIhmDDjgg+Pe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iEelBT9g; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716505939; x=1748041939;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KM/kkkj11dWAIb64+s0XVTe7Wt2fyXgNtEwvTMOy4l0=;
  b=iEelBT9gHbfPr5SfjVnhjiHREYhA6YykpWN9AXd7KKYidyjLn3lDqBPc
   +pkSEMeos0mNooVmF/ZMbBYFNSWT2KLQ5NtYWzRUHGk/ehQakqb7EmvxT
   E83OwMyN2UviD/M4lRtyTqeQ6E+dc2M5uriMtoxVAOunz/TxCKygBxNGX
   vywJJxVgkWHyU9+JHOhGLGQWEOAuurTBbqGw1Kc/4ehXiqs4AJqrpQFx9
   YAf8xm2mz8LPVT2/XWQqVLm7nSTQ6tHfMm817ZTYck3n24GgrBhyWn5Yc
   324DRfmmX0Ku+IaGR13Hh5whk1IzMKKp3WCINHKh8W8HPeOpwBZTR9GLM
   g==;
X-CSE-ConnectionGUID: hirtfK/DRX+dXMjvydU7zA==
X-CSE-MsgGUID: ThcVEjmXTy6oqXV/TZ+s2w==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12711463"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="12711463"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 16:11:54 -0700
X-CSE-ConnectionGUID: 7zjz7uSRRm2KHOa8wKtJiA==
X-CSE-MsgGUID: TGMlj8aQQMqm6o5JzbeArQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="38282586"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 16:11:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 16:11:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 16:11:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 16:11:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7xJrvFCV2azPoTHXm+/w3wfRL5rq4d6fV9WNvWCKqi506ZtxHAnKSJ3uNC1oDFxxF4y/6nvMqNyz7Yth8c0R8l7L/2gpPdkI8M08HH9NKZ79T9ljilbTeguh7scQ6nF9XGmd9SdGWgQFOUIIXxEZG55Fdnnp8gOu78mwbDeQ3uesoFmcEDuWwnPFT2XCqIJ/IqqhsKIc9onx7CXkR1HoFBnbSaacbwTHvaCsNeQGYUBu5j4kCYUXyXFEvK8C1Z0hA8L1yrGYfbFCKzq0O1NX0OouMlxs/kzFA2eZWFqGqKENP4VXVPaooZR6HP+LARVfqxIpn5do/kL4eRkfxM/Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCE+s7VpK/n3ssZIL0N5aTWAJC1NFbR3EeONMU0ib1M=;
 b=IMXN4Dg09JcXXhDKODOE7i1NbrCegatCE1PaWEVWWKFbswGQyOYEzVngNry0TabXXDUWeeyRQ+VCbqQ5i+hna9c8AvG9RO/Ka1qNPo3wVgGUBrXNF9p575ggyXbUU0uFu9j0E7KIDwn7PIht5KFZevCumANVK4imiHShreFtvvgOjHO8vKJrfvltKJpVgIdmYj7cc1Ebsym4GM91NbNG3vluYXo3gF/aIelfL4mft4H655cluswZYP+0mqZaB/W2O3dp2n1QtP+LHsmZzMhKYtO0+LRbcT4ODSXsLA8Pr31HBh1l1Oj9tGs84DZQMWkcUYYh5HB+63RF9ChgPJfFfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6154.namprd11.prod.outlook.com (2603:10b6:a03:45f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 23:11:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 23:11:44 +0000
Message-ID: <c4fa17ca-d361-4cb7-a897-9812571aa75f@intel.com>
Date: Fri, 24 May 2024 11:11:37 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
To: Chao Gao <chao.gao@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-4-seanjc@google.com>
 <8b344a16-b28a-4f75-9c1a-a4edf2aa4a11@intel.com>
 <Zk7Eu0WS0j6/mmZT@chao-email>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zk7Eu0WS0j6/mmZT@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:a03:505::7) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6154:EE_
X-MS-Office365-Filtering-Correlation-Id: 50acb8ec-c4af-4829-2a87-08dc7b7db6a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YmtPS2F1dkxlUTVvYStVdE5lb0ErWUF2c0FMeDk0aG01bnd6M3FBbi9xSWdU?=
 =?utf-8?B?NzFQVkZUdWZsNUdrTWZQKzhJU0t2MUgzb0o0UUR4ZTcyU1ZnNFFXZ29VanUz?=
 =?utf-8?B?MVcvSlY4QnBJQ3gvWlhKT1haUG01b2QvV1VNUjJzUlRpMS8rVHBCczFCU1pE?=
 =?utf-8?B?RGdPL2RRaXl3QTBVZklvRWNnWGprczBDUCtVWkg1TnUwWjhsU0RPdWxSMzZS?=
 =?utf-8?B?MVlyTnpYZmNzT3h2U0EvRlhmY0FXblhvUlJUUGNkRlBxdkFoNFhXbHRYN0FI?=
 =?utf-8?B?L2duZEN2Zm5UckN5Q0ZwV0tsa2J3UXYzOTI2QmEvK2UyUTNYaEhlQ1BTV0lJ?=
 =?utf-8?B?Q015aGE1alltcmVVK1hmYUdsRkNmeWMyanZ4SVZHbjBObkNIN3ZsaXV6cDNX?=
 =?utf-8?B?WGFnUUpnUHRqQnlPRWhWVHpVeW13dmh1YjBleldJZUpkNHY2b0NoNVpVSlBx?=
 =?utf-8?B?ZkFzbyswLy9JajJqZWdvcjVQamc4bEhiTEhhTUl3QjMzWTZvbjdaMk1UV3pT?=
 =?utf-8?B?M0tWL3JEVzdHbXM4NW1lcDczTU5BQW5aU2M5NW5QelppUllDYTdva3J3N0pr?=
 =?utf-8?B?NS9FUEp1clhmVlpRM2NkbGJmeVFoVEdUc1R3U2xTVEs4eFB5RUhtZTNkdEFQ?=
 =?utf-8?B?WURJQWdVZXRUdDhxTWZRKzc0NUhDMzlJT3pVMFlkUFl2S1B5cTNJYy9reGxq?=
 =?utf-8?B?bnJLWWc4T2JIbU8wZHJMRnFLTmdQUjk2RU5zMUt4UFBMbHNmMlcwd3F5M0E2?=
 =?utf-8?B?ZWpFajVPaUo3UnJ2UXZVRDUwbk5Zd2pZSFJjQisxWlNYVmtUT3UydzJPMklp?=
 =?utf-8?B?Q1BpSWZaR3VOUlI5MmpQZmd6VXJvOExpZXp6UDNSSEdZR2FjRjRUTlpnQmQ0?=
 =?utf-8?B?aXF3amdtVXhQSTlQZ2FjNGM3cTl2UW9xcmZiNEpzUGFsTnRMNElFTlZkaE44?=
 =?utf-8?B?SWpYdTJzclpQcERFU3BkNDNseFhnUUR2TXYyREhNTnVWa0tEWnlRd3BQVWRx?=
 =?utf-8?B?RlB5QW9ZV3BENWRub281QUNRS0VZZGdRL1c4YjNENDdTVmxxYzNzMFZHUU5I?=
 =?utf-8?B?c2xlUE9reXFDdS9DRExFQTNWaWNadVNtNXA5cXBuc3FUZWRPd0p0dGhDWnRz?=
 =?utf-8?B?L1B4bG12dkZmZDB2cGxGTDRZbWVHaWtsUmhCSlFjNDZSdk5xbEs5dC9DSkww?=
 =?utf-8?B?V21iUkVkaXJPWGdIMnZDZkpwU09LWlNXRmdEL1Q4TzU0Vm81eVowWGV0cWJQ?=
 =?utf-8?B?VmZiKzhDSG0yYytPdWZwTjVrdVRVdkREekNtZTF5aVBFSXdYd2lESTcrMTh1?=
 =?utf-8?B?T1U5VGpYdFdPZHZHSWtDbk9LYjBpZUR2c3l0MEZ5NTRUWXlTK2djbEdodFV4?=
 =?utf-8?B?a2toblluOWw0bnZoci96YUNiSm0vejFQM0hkeGx3Nk50ckxxYnM3ZjhnTzV0?=
 =?utf-8?B?RmlJUTZ3RTgrVmxtYkFzNGxZaGVtVTc1MThzeG5wV1ZhWCtUQTBYcExqSkJv?=
 =?utf-8?B?enZyRlNRU1pncjBPOUpCMDRRaTNWaUZxY1prbzNPVDRmeEdSd3U0blhQZ09R?=
 =?utf-8?B?WHhUV1FTQU5zcGJuZHQxNzhpMTllTzNFeXo0bWJCTml5TXZmUTVvaEthaXB1?=
 =?utf-8?B?cVg3S2hXNkFMZ1phTmMxdFdDVzk5V2x5SGlUb0FLcHpmbHBDai9HdC83WXNR?=
 =?utf-8?B?amptTzVYY2pvZjhxZzZUT1Nqa0tCNU9SNlM1V2t3Y3JraG0ydjNHbjFRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnJ6WGVVTEpEYUhsQXRFM3pCRjVpS2tzYzRHT1ZqL3I3akxOdGJyTUF2YlhT?=
 =?utf-8?B?S29MTHpEa01tUE5sWEhsdkNURG8vT3pVRHJMNUMwNVBTUDNVRFZLSnhibmQr?=
 =?utf-8?B?S3Z2dm5GUVhpTjZuT2dwT1ZBazZqVENuSXpBdG9VenJtY1AzVFB0cWdaYng2?=
 =?utf-8?B?dE5aM2J4N1BSdG1PQ0gzcnYrNlA4QjdNYzB1ODhFMEk0eDFuY2JjYkpwbVBU?=
 =?utf-8?B?Z1Q4MGZRNURHeldSVzlDbVBwSkp6QS8wY2VMQUdneWNPb3V2K0R1dEQwY3lD?=
 =?utf-8?B?RUF5WTdyblRtSTlyUmxOSnJ3LzNRTW1hS0M4ZDE5ZWZlWmJta1FhSURPYUlX?=
 =?utf-8?B?bzlSR0dyVkhSYVJOeXpCSUFpOVFMS0VtQUZVTGt1cWNBSXBraVBFcFlOZ0Zp?=
 =?utf-8?B?NHNCYmJLOVFGcS95UkFMSUgzUm1Pc280WmNEL3JtaWNnOW1zS0x2UXlyWG93?=
 =?utf-8?B?RnNnVngyL0lJR2M5NTRGTVRPSTk4THFXSE1nMlVBWjdob0xOY3ZEWmNxUndz?=
 =?utf-8?B?ZjMwTFBrSU5TYy9wRVZBWWtxZmRvbFdGNk0xMnYzV2pFbENaZGUveUZDUThR?=
 =?utf-8?B?R1JQT3ByZzFKMWxBSDh3SnVNaXJNSXZDRStkWVNSbWhUWUE2TUZZdFV5emNZ?=
 =?utf-8?B?cUt0d1NQK3F2T3NkVWJZd1ZxN3JZNXE4WS96RmVkUUpJaHMzRDhXUlJ5UmRP?=
 =?utf-8?B?WFUvUWptOThVTmJQb3p5VldvRU81Rm1weVlNWFJ3T21sRUF1aVFUeHBrQXJ5?=
 =?utf-8?B?UXRRZFEwSHlNUWttWTlFVXVOZE9HazhqOEFEcmdYemRYWittN1FIb081WVor?=
 =?utf-8?B?QXBhK0tRdHVRSHgzY2o5L3FXeEtsd1Q3YjhnYUl5allKL1QzY3E5eENrZmhh?=
 =?utf-8?B?bUcybUlQWXZTdXNGT2grOHBiN2xmS29XeGxLVTIzKzBmcGVCTUM3SFpSendz?=
 =?utf-8?B?WllDUVVHTmpQYjZzVDNNNHoxTWNEMit1bHhMZzU4NmttWUNJRC9MRndkRi9s?=
 =?utf-8?B?emNXb1lZRWtwQ3J0eDBxRDhCcDJMZG9MdlBJK2lUVndaMFk4Rmp6S3VzOUJi?=
 =?utf-8?B?SEtOOXV2cW1oWml4RXc1TVhCVGpURHg3UEZHalZyS3VRRGJ4ZTgyVSs1Sm9v?=
 =?utf-8?B?RUFiajNhYkN3eXM5MjR0TEViN0tFY09sVUpITHdNRmJNM1l5V1h3OEljaUxm?=
 =?utf-8?B?Y1FOVFE1WGd0VnB2NFJPQ1FVMmRXSGRNT082a0tLVXc5L3lhcHErUjM5Z2h2?=
 =?utf-8?B?RzMxWXY5L2RRRmJPSWtQUjYwUTM1VjI5SENObHlQYkVGbTJNODNNM2xJMFVi?=
 =?utf-8?B?LzBDTE5yOEp4dURXQ3N6ZVh0Q0dVSzFhOWxPMWxZbVVpa2V1ck05dmF2S3ZR?=
 =?utf-8?B?VUtReUxWS1l1OTdySDdwek0wNjdqZTNKaTJXU1FGUHBwbzZUWjI1aldnaVlt?=
 =?utf-8?B?ZXFZaUJpd2w2SkVPd3Ztd0JtcXB0Uk5OdFdWaGp4YnBDMm84ZjI4K1NudXB0?=
 =?utf-8?B?akwxaFJudTdCcXhKeUZnVWlWUHJpejFxbnIveE4vL2EzK3hqYXVMYlJpVzQ3?=
 =?utf-8?B?UEY5Nlk3N3I5MEUwa3NJMStIVFFJc3pmdHdHZG5ieUNxMmdtNmh2MmxOcUhC?=
 =?utf-8?B?dWZ1aHAvR1dPc1hzbGVUR0k3QnZIcCtycnA3ejhpOUMxbmZEOFRHaTE5OWhH?=
 =?utf-8?B?dG41NzI2alRNWVdWaytEZkpObDBFTFB0RWRwM0FEOU82RkFRZWNzRzBjNVdx?=
 =?utf-8?B?MzhIWDA5d2wvM2wwWjBSazAydXFtRXFqTllVYmloNENWUmpuZkVuUVpPNTNF?=
 =?utf-8?B?WDlqUU00czlwZnVjUXI0elpzTkJBRmIwbk9ZUjErUGRiMVpLRzBER2haalNU?=
 =?utf-8?B?SzVSOTJVL242VEFRaGcrMWt6NUJOcnZHeUdzekE2UngyRXYzZXNtRlIzaERL?=
 =?utf-8?B?RmFLaWlTT0pHYVhpTUxMTitac25zOTZ2Y2F4MEQ1UjFKUkhGNVltaHNrTjF3?=
 =?utf-8?B?bEs0SS9oU1Rpb3MvTmxCMko4ZHphUzJhY29zeWMxcWU2WHY2VXoyWEp5cWFk?=
 =?utf-8?B?cHFWSWpVU2M1S24xeXd6bHV6L1ZlTk9PYkllUGdzZFJGVXJUNkR1MzMrZ0ZH?=
 =?utf-8?Q?lAVhI+vdEqKSCAhBzT+cT3EfA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50acb8ec-c4af-4829-2a87-08dc7b7db6a9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 23:11:44.7505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17+fVZFwL8vVYb76bws6tq59MPiYEzse05tz25rCcfsZEQTvd2XWrPQWb1Uuez/S3D7IZHorTIL+uGAVTHLJ+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6154
X-OriginatorOrg: intel.com



On 23/05/2024 4:23 pm, Chao Gao wrote:
> On Thu, May 23, 2024 at 10:27:53AM +1200, Huang, Kai wrote:
>>
>>
>> On 22/05/2024 2:28 pm, Sean Christopherson wrote:
>>> Add an off-by-default module param, enable_virt_at_load, to let userspace
>>> force virtualization to be enabled in hardware when KVM is initialized,
>>> i.e. just before /dev/kvm is exposed to userspace.  Enabling virtualization
>>> during KVM initialization allows userspace to avoid the additional latency
>>> when creating/destroying the first/last VM.  Now that KVM uses the cpuhp
>>> framework to do per-CPU enabling, the latency could be non-trivial as the
>>> cpuhup bringup/teardown is serialized across CPUs, e.g. the latency could
>>> be problematic for use case that need to spin up VMs quickly.
>>
>> How about we defer this until there's a real complain that this isn't
>> acceptable?  To me it doesn't sound "latency of creating the first VM"
>> matters a lot in the real CSP deployments.
> 
> I suspect kselftest and kvm-unit-tests will be impacted a lot because
> hundreds of tests are run serially. And it looks clumsy to reload KVM
> module to set enable_virt_at_load to make tests run faster. I think the
> test slowdown is a more realistic problem than running an off-tree
> hypervisor, so I vote to make enabling virtualization at load time the
> default behavior and if we really want to support an off-tree hypervisor,
> we can add a new module param to opt in enabling virtualization at runtime.

I am not following why off-tree hypervisor is ever related to this.

Could you elaborate?

The problem of enabling virt during module loading by default is it 
impacts all ARCHs.  Given this performance downgrade (if we care) can be 
resolved by explicitly doing on_each_cpu() below, I am not sure why we 
want to choose this radical approach.


>> Or we just still do:
>>
>> 	cpus_read_lock();
>> 	on_each_cpu(hardware_enable_nolock, ...);
>> 	cpuhp_setup_state_nocalls_cpuslocked(...);
>> 	cpus_read_unlock();
>>
>> I think the main benefit of series is to put all virtualization enabling
>> related things into one single function.  Whether using cpuhp_setup_state()
>> or using on_each_cpu() shouldn't be the main point.
>>

