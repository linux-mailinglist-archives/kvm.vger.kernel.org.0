Return-Path: <kvm+bounces-29909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2110C9B3E1C
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:59:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D414B282F94
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B25241F4FB4;
	Mon, 28 Oct 2024 22:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hho+AokG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED94D1EE012;
	Mon, 28 Oct 2024 22:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730156382; cv=fail; b=WRNWVEtXnEP2BHXz3t49PQAdarYX7WhF91ES31LV2b8UQ203kiQTHJGDc8QA5e3DBJJ2SghpbZTIZ4x63ZWs7qn4IBrPoFiylAd2Ojki5PzA3YJRtCxvx9GXUhYHu8KnEFH9CEcZGeIsDwLeHq6ED1MnBbWKttbCLeb7EgbwU+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730156382; c=relaxed/simple;
	bh=Q3MkjyYwOzZA70eg5of+yJoUVxFJYAVmANsToXxWOUE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XRzGdHd9lIXgdjTV6QZmiCQ9KVc097pW8Q/2gtx6xvYZYoI54xwJqmLzQ4AKcCq2hA58z53gCqwm53D+5MkS1NQ+ShW4F7/5V/0unvgE43RVypIA4vcjXlFYtjheheAvD3l11bG3wUAErWRLDvT5zVNmySOrpzZgW4dWaFhNkQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hho+AokG; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730156381; x=1761692381;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q3MkjyYwOzZA70eg5of+yJoUVxFJYAVmANsToXxWOUE=;
  b=hho+AokGra1lWZJf47ItvrKfhx/ScA3irTbc9GPWpkziD9FoGX7iwXBV
   Q5w5lJ7Cj6i3urAgQe6DeQ9fwDqEP4E9NiBenLyrZwgy82X8eo8xHIX29
   rTnEYMzXIrivtmUdAtM+zgi7fsqflVv0LgbAFy6P3TsI+Kk1UoJgN/IOV
   7LfC8JyudvfWyH+opHa7QJUjaKd214uO6/VT5V2N92ik5EgNbbMMoqTBq
   LpERYKLixk8OxB6QtEKWWyiEJsTbTg8RKZGDGn2YHEppgYArHN/Ncy5jt
   n0sF57pjaquAkKKgCA/IZJ2mBWrNAGIhNCnMobips5BAJZ1H8I1xC5SLH
   w==;
X-CSE-ConnectionGUID: 3D9shAE3S1+22phv36Rv9g==
X-CSE-MsgGUID: 81AARb24Q5aTIguRE5RgDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29916374"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29916374"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 15:59:41 -0700
X-CSE-ConnectionGUID: g3523dROSjmY273PcYAzrg==
X-CSE-MsgGUID: HJ3mjpqgThSbmGO8qmnWlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="86549178"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 15:59:40 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 15:59:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 15:59:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 15:59:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGzuG8ngA97rC4uIycNOFFzMx0BNc8vBy9Fnc/SHknApzpCfXEbPbAeIKW2BAOvDWEff7qchV5SjIYvTatL3Cg1xFlOtB3LvCzY38uXTtrzCKQcIqgy6P4hBilJ/weOpifyry03MjFx3q2w5unXA+4nBvFTP05aWex6H9A2Lg/VJJtGY4MR1w95bRUuZkXwvfOBbDHgiMJMxO0ZfYUPWKz9PI4mvEDuGYidsxNO8lB9ERBTlNHr0KfiEDas0MAdLCDotwqEBI+Hni85dfFJ+zUHylNVWlQBH+Q/Ga2F29ms71SItejfXiVnD+DSlCC1e+ibZRteGVsJGKJ1g/Abo5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IrxsfQPnw0m6Z/oRFwNpLuOqzS3Usd3o4CEBRuztC2o=;
 b=fqO/Nkf1x9lSYAQUItoxZ7CqzaWCVvgUP9Pb2iJKMR2fG5Vle76NDHkFUP2oPtXOIidXzKGA9hMPkGS4Iw+C39HVg3wic4RWMYlBGWBLt6inF3+EQVccCo1uo8EdzrVkOMExnTf2k1o+/9PbXe9K0x8JRxwndyICwHWAUcUd9JOZuA5470s6OSIxdMnF5MGDQMX5jyWBTsXIrBcT/8k7hWcXIpmE7Khj/72Nbm6m4tI6cbhAgr2OQTdXTQqTvVmOMquCU+PjWIM6HCirRNBgBrXJt+I0i2IEGUnfO6XDBzyomKOsf1Lh+NmXZExou2OQtFmEVdKVVj3MK+yy8bhbyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by SA1PR11MB8476.namprd11.prod.outlook.com (2603:10b6:806:3af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 22:59:37 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8093.021; Mon, 28 Oct 2024
 22:59:37 +0000
Message-ID: <8a8e7067-d4ff-40ee-992d-88dbb4bc38ae@intel.com>
Date: Tue, 29 Oct 2024 11:59:30 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/10] x86/virt/tdx: Print TDX module version
To: Dan Williams <dan.j.williams@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>
References: <cover.1730118186.git.kai.huang@intel.com>
 <57eaa1b17429315f8b5207774307f3c1dd40cf37.1730118186.git.kai.huang@intel.com>
 <672011d43958d_bc69d29422@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <672011d43958d_bc69d29422@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To PH7PR11MB5983.namprd11.prod.outlook.com
 (2603:10b6:510:1e2::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5983:EE_|SA1PR11MB8476:EE_
X-MS-Office365-Filtering-Correlation-Id: 9742dab2-82d4-4990-8e72-08dcf7a4322d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ek0yeUZYRGZsQS81Si9iT3ZiencycWtyVEh6b216S1VRTVRqYnhLSm5CcE9C?=
 =?utf-8?B?VkxvRjFPMlQ5VDVpUVl2U29QZUlOTnRYK05BZTBncHVPSEF2Y2p6empUVFI2?=
 =?utf-8?B?SFhQM0pEWGtMb0hiZVNGbW5uc3ZGNEx0SW10OUtrWDZZcUcwU3ltU0thbGpW?=
 =?utf-8?B?REFGRFZBWVloSFp4ZVA0MFVhY1FSemlQYk1QSTlpK3EzNzhDVU9rT1d4UTh2?=
 =?utf-8?B?dFE5SDNkN25HYTNVR3RhZ2hEMEZ6cVNiaVU0dnBjdktYZ2hqU0ZmckgyU2M5?=
 =?utf-8?B?dCtEVkdjaW9nKytkaThPVnF2Q2EzanZVek9qdkVaM0dnMjdtNUVZRHdzVjRC?=
 =?utf-8?B?SlY4Y2JjNGhRbno5Sy9nTUdCaVNDeGhuY2R6MjFTTHhDZkUrTzR4c3E5VzFo?=
 =?utf-8?B?cGJoZnBYSVZsaE1UR25GdElia0RKSncxSWJpcnBTblYrTWhMWXRsbit3elpu?=
 =?utf-8?B?WDVXRUU5cDhTZUU4dVNITVlIVmI1OFRCOWtseWxYTWlPazJET0dpSUxJeFBV?=
 =?utf-8?B?dlJTcVJRSlloZDFZZnZQQXFHdnlXc0VLbGJ0aDB1VEI3bC81VmtscHBvQUFI?=
 =?utf-8?B?NjlabUs0Vytvb2F0REg0UXc0Ry94cit0SkJIRjhZTjFYZ05SaGR2NzRHZUg1?=
 =?utf-8?B?cTZNTFQyMlplMkNmN1JETksrOVBRMnIwM2Nnc3pJQWNRYnlpTlpQT3JHT055?=
 =?utf-8?B?cVJ1QmdDSjk0UC9TVERHbkU1L1YxY3ppamlMdjdqZHRGQ0pxY244ZGlnRDhr?=
 =?utf-8?B?OHJ6alRXVlZYMVplZWQrbzBRZVFrUGFiYW9EeEk2NTFlZy9LYkpDKy9SL2R3?=
 =?utf-8?B?TkVXY1c5cHFjbUtOZ0VOekprWWhLbGJaNGNMTWVTSGxpUmRjQ2Y0c0pNUS9X?=
 =?utf-8?B?TEN2aUlQekhZUk5YRXRLbmhKK1Y5L00xUUdoTUdsazg2M1YxM3FPQW96S2do?=
 =?utf-8?B?NWdvLzVhTTc5K3ZSeDZxaHUyQ1MyVmg0d0wrVW5hNEFlOFZTdWl4Y3hIcVBt?=
 =?utf-8?B?UGZrU2lldUpVMjVtTXhveUtaRFIzN21hSmNPTHAzZDRBU3AzUUlJNFh1aXVi?=
 =?utf-8?B?RjA4cGI1SVIvNjR4VVpPdGdXVktUK2FHdFkwN2Y3Ky9tZWszSVRNdXdQdjRQ?=
 =?utf-8?B?WG9KNStsU015ZnNLNDlCN1BrRTNCQnVSUTlsRldabzJ3MnFrRitFMG1XUUFz?=
 =?utf-8?B?UXBmRmtUNGp6aE9XOXZIV1hGNERCc2dIcXVScld6SlhpNjY1NnRreDFhNGdl?=
 =?utf-8?B?WS9TL09WR29RMk1pd3lEaVdVMEZUMjhuMTN5dlNwSldLNnFhRjVmVHpOc0NM?=
 =?utf-8?B?QVBudnBRVGdoTys4bXlDT2xyeC9WQTFkaVVsRkIrc0JMdGZmTk1mTlBVSUI2?=
 =?utf-8?B?eUZtVG5qN1VRUXQwemY0akd6eWoxTmVZMVh4R2pIeThVM1FsWXVFNW1CMjNR?=
 =?utf-8?B?WGFQK2VZTkQyY1piWXY1cHB5cHRZZEhCKytaaDB2anpqK0w2NVVFbmdzN3ZM?=
 =?utf-8?B?WWhGNlFFZFpnYnVnQXBwN0ttSWx0aGpmTWNEL1l1WFZ1Yyt5RWI1LzFtekhK?=
 =?utf-8?B?djJqV2ttSVVvS1l4QlVUcGMvcjEvS3ZleEFJYzJSWGUzYWxZS0dZWVozbFVL?=
 =?utf-8?B?TzVMN0xtNG5mQ3FYRDRMNjkzQnh6aGZXU1VVMlhwdVVlNGNiMWxYNk1SL3lV?=
 =?utf-8?B?LzlSOVp4OVZxSEFwVVdBMk1LODMzVllDYkhUa2dzN2pHOGhxdVpBbDZjbW51?=
 =?utf-8?B?MFhlTmRaYzNHQ1BacHZKUWhHbUtxNzlPMHNHcHhMd0E0eFErZ281RjArR0dM?=
 =?utf-8?Q?oBC+gj0iHVSPGkuXVT8B9vj5WMNcG1mbnBjOs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UytuT2J1aXY0K0ZHdjU4bGQ1RXdoblhNMTlTbzA3c1hlckExaHV3RFd4VnpB?=
 =?utf-8?B?dGphK1Rzb3prOUw2dEVPUUs5emMzaERxa1Q2SmFpNHVKWStzMFF0WWFqZUJp?=
 =?utf-8?B?TXlNeG92Tmk1eFFPZlFxbGp1VlZDRFhuSTZiaE1SbnNxb1NKT2NHSDQweFJC?=
 =?utf-8?B?WCsvUUNBKzhGbGFaOWpZZnpvWm9qbFFCTXk0OEhCaDZNMWZVM0wwMHhlNW9T?=
 =?utf-8?B?QTFacXJhbmxGNmhsOVdtbVExNTB1R3pXdFhITEFyZEZUTnExOW0yY1M1NGJu?=
 =?utf-8?B?M3I5YzJ5MnY3Tk1CSUUrZDYwdXc4bk9BeENoTWtuRnJDVnl5RW1JN25uM0ZM?=
 =?utf-8?B?aStGNGJsdStkdlkyMndqcGdkYnZUQ2VQUmxPWW1rVEgvWUVGNlFWcC9FT1lo?=
 =?utf-8?B?MmJ1eUJnWWR2NHhqSytWOXZ3OGxqMkVDNWM3UW1OQVJrRkJxekxhVVNWWDk2?=
 =?utf-8?B?M3lwL0pFVVcyRFJwcXdrN1FiMmNjcXFaMzQ5anlTYzVSSUd0cVJtdndkYWdI?=
 =?utf-8?B?czZOeDFHaWFnMVdUalpBeEkyYkNvSXQ1RGxnN2MyTHIyVVI3WlU3SjF1N0NQ?=
 =?utf-8?B?TWVjdWFuMGt4RnVaMEZxOFNOYXBZcSszdjQ5SVhEa3Y5Wi9XM3B0clVLWFpm?=
 =?utf-8?B?Y0VWNkQrQWphNTUwVmJXcXFxMEsyT1JIcXd1SUJJWUYvMjczdGcvK3pSaUFW?=
 =?utf-8?B?Z1BNTmxLZXZndStwQlBIbjUwTUUxMVJER3c1Y2J3RU43a3YvZVc5Y0hpb3Bt?=
 =?utf-8?B?bURRVGtpQng4dUpNbk9yeTQxdThtcFZGR3ljTGlVa1Rkb0c0STNKUXpYQm1M?=
 =?utf-8?B?d0FUa0gwRHduZ2hGZ2RPc1AzOEpmNkZVR1JNeXYydTYwZVpxOUxmdWQzd1I3?=
 =?utf-8?B?T09BYTlIQ05uTkxFNG5kbzlCM0NxUkdsajhXb2llUHBUc0djV1dLZHFZWHpZ?=
 =?utf-8?B?N0M0aFJucWlSd3pPY1hEaFVPanlvVmtRZDcwenlZMVM4eGJETG13VGpZK2VI?=
 =?utf-8?B?S21WWTJQN0JOeE9mYWJ2YkFhNDIyM1R4V0lHd1RtSmFacWhXZlZSRFBWdXYr?=
 =?utf-8?B?NmFDRjlVNkdTOUVsdGprN1EzWUUrRXZVSE9xd2ZndUhVUms4N01lOE5PS09T?=
 =?utf-8?B?NWM5UjNCUDRGZVFWMG5JbkFoMzBYZWRsU0tnK0hrNWhPdmhtSWZML1FSQ0FI?=
 =?utf-8?B?dm1FU1BVcXVXR0VDaGI0cXRvSEkxdmJva0FKU2Z2VWdQc0ROa01wa3p5OEsw?=
 =?utf-8?B?ZExMMGc0RTF4SXIreFNodjc1TUVvVnJSMGFGZW9QMElnVUVUQU91WXhOSWMx?=
 =?utf-8?B?OG50TEVTV3ZodGZwWmcwdVlTOVVzd04xUnVEaGR2VlVyVm1Dc2U4NnBHYzNB?=
 =?utf-8?B?aGRkU09kODQ3MmMyRDk3N3FqWVNQVExVUndIZHU3Sy9NWTk5S0piRlloVWMx?=
 =?utf-8?B?M3RubXM0QUlXOExtdklmQ293SVdHNEVlc3IwNGZGUGtMekZqaUIzcDZMazFE?=
 =?utf-8?B?SzJ0WGt3WkphUDJIVGN3bWlzUWxHMVQ0YWNLV0NNWFA0bTdwY1ZpcElVZUNY?=
 =?utf-8?B?dXF6K2NKR2NabGpMY0dkRis4VTlaSzZiSFdueEt2c2J1QitqLzJSSGpPbEdX?=
 =?utf-8?B?UjNKWGFSVExlNW5uNXVYUTZTckRZUHYrUzFyWElsakhkZUx1MTh5QldrdGdI?=
 =?utf-8?B?MVFKSVlxU1pveVg2dHRJY2hta0lOSmd3M284VkJ0dnEwaTMvNGNzVTMwYmxl?=
 =?utf-8?B?SDJ4bng0bDhGbXlYMFBHUWFkay9reW9odmh6REtzMS92SWxWZmJRMTNNNTJh?=
 =?utf-8?B?ZzVteWZFanlMUFFpVS9VUmJjanB1RkhNdSt4NUwvRUxMOEFXWTVSa3E1ZDJ5?=
 =?utf-8?B?QnNxMXR6ZnF0WlhlbDJOWDlJOXZKcXRnNUNHRUtBVS94bnU4aXRwSmFVemRz?=
 =?utf-8?B?WUJQejd5aTdjWGEvSWpmdlNWR0JWMmhQUjg0ZUpVV0U2UlBrMmJpZ09ndVFU?=
 =?utf-8?B?TXZLYzdDMWM1U09mUnlPalBmOGdvTDF0SGllaUswajRXSEZYR1d6R3dJOTBK?=
 =?utf-8?B?OVJrQndxZWd6N0xFdDBIc2JIcC9IUGxuQUgwKzFQUDRvcHEzV2hXZEt1RVNa?=
 =?utf-8?Q?Apxhb51JCUClFXw9PAh9cYFgN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9742dab2-82d4-4990-8e72-08dcf7a4322d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 22:59:36.9930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2vAgaJi01K6YhR+fQi23HlgN5ykzo03evpkz9hMQVyGGh8xnHdG1tnaXCfYf+Ly4hPXU2KkbA5+7iKW+gzlOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8476
X-OriginatorOrg: intel.com



On 29/10/2024 11:36 am, Dan Williams wrote:
> Kai Huang wrote:
>> Currently the kernel doesn't print any TDX module version information.
>> In practice such information is useful, especially to the developers.
>>
>> For instance:
>>
>> 1) When something goes wrong around using TDX, the module version is
>>     normally the first information the users want to know [1].
>>
>> 2) The users want to quickly know module version to see whether the
>>     loaded module is the expected one.
>>
>> Dump TDX module version.  The actual dmesg will look like:
>>
>>    virt/tdx: module version: 1.5.00.00.0481 (build_date 20230323).
>>
>> And dump right after reading global metadata, so that this information is
>> printed no matter whether module initialization fails or not.
>>
>> Link: https://lore.kernel.org/lkml/4b3adb59-50ea-419e-ad02-e19e8ca20dee@intel.com/ [1]
>> Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> LGTM, would be nice if the build hash was also included to precisely
> identify the image, but will need to ask for that metadata to be added.

Yes. If that is needed we will need to ask TDX module team to add.

> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thanks!

