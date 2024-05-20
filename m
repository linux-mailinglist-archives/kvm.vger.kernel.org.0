Return-Path: <kvm+bounces-17813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C6CC8CA523
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 01:42:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C36C9282521
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 23:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7BDB138486;
	Mon, 20 May 2024 23:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bNFEGFUE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32AA3611A;
	Mon, 20 May 2024 23:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716248519; cv=fail; b=iw7uiCtWTVubLtshBlCwFM4iX7btrty4HpghHRPtWm1T6De8K/9U5ZaLuhcmyYqH47bJLD85HXFll1B8fNjswvnRRHtfxmkStJunH0Mk4Gr+8biGELHJTi3SoYm69c5EJ3qanK3gmAo3YxyjI1s8W83dVtJ0i7cRlMnOkKgho5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716248519; c=relaxed/simple;
	bh=dAANT36lCbjQIDCAJNjDpak4gr8S8W2H4/XkITL97B4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cVqC/cyWAEULSs7ZxChS82XVAJxjdc0V5WzTU1+Gi/ZscPItEGTVrT4x0vvL8giLqRJ3gsnQK6OEqukpxxS2DEH7LfcRMQqw6b+/q6lScn+9QmIN9kFATNCmoE7lbtzC6eFKp4P/2mHxn65BBFx7QkKT6h8Fv5xm9o+gKRXMaz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bNFEGFUE; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716248517; x=1747784517;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dAANT36lCbjQIDCAJNjDpak4gr8S8W2H4/XkITL97B4=;
  b=bNFEGFUEGm6mCxQySBXvCiPzs+ynqpN/IQAoKLPedBET8BD8mt/abquT
   8Kt84atupr5EtsfWRNrm/TrsXYZ9m3mbA3cKnywJDauYVWXB2y77sWlth
   PuQHx3K29lF4mzFf4lk464wH69TMBTQCdn7hpyNigy/1EhKCGo/mmlt8y
   sAJMIfKw4I1/V4G3s6kxLuaa6Hn3d9IWfSMl4EvnB3z8h+ndRbFyIx0gm
   H5i6nkPDcKmNaU7xhWCWcCU9n2vwXari6JH2smBLuvhZGD3oqr9EGi/cs
   T2/Q2042Nonr/wlpXvK5ctBKcP2q7csyom63tUHOCWzEOp4s940nuOiXM
   w==;
X-CSE-ConnectionGUID: fw0fMmb9RoiEkKW0f5cKKg==
X-CSE-MsgGUID: zOlYD82JSIGZFvfMBHYmSA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="23081968"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="23081968"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 16:41:53 -0700
X-CSE-ConnectionGUID: RTf5fBjYQ7ugr4klACQCug==
X-CSE-MsgGUID: eieG+HBpSACh/BWgCoMHbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32740633"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 16:41:52 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 16:41:52 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 16:41:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 16:41:52 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 16:41:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlytPl7HwRthXwH4Y72F00qZOGdFl7do2DLHUuQNFrsML0N1grrxXPvSbOsApNiM31wwXKm/BPwervVy5cUa6GfVHJE6adorISzrIF8u8u00ovCYRtFSuk5OKcUo4KPfR1+nqjzthlhw8KlPF26uoHaHlZToVIGsaHP2GkHUNdPaImhynMcJNE8wXr/rQqwJajK9nOd/UV49Cx5VrAYWya+C5lFbSx55nI7g7IeICcTsOU19TPIBAtgekOU/NnkHUUevP4+fU5/67/MDxylLGnpb80UHdnj85T+Yy7f+pd87SZEw3Pnkw2X3EQaWu9rAoXEmIGlNnzxFWQMYLXHrPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYBeXwhiajHjl0L7o3IwRndpw1VPUEu+pFUvwVjAmj0=;
 b=Mis58fKk2lzE11wvwVjNLpqNSQ3qotLAvc8v2vZM4/9CzQQOHL4SRKDpIEovd554/OTjsL3hk4OOCtEx8SZB40yT4AaZTtd+ItxdzmF70fu+TznIWTfgl9/xzn7dxv8QnXi8VFfaQZBoAekOozR9/7dQ+zkIQ1Mm+8mvJPCPnzkxfwfp8klIIEMkq1ufwhjW8aqwn+p0jPCTPslLxxc97/Cbf32AAiqdNJ+L8ui9sXG0AmLCl31aJse8Qc29tNbZUniq/AN1kDpLaet8cUllwl7rZ5DUG4hVRkkDDn8FafeO5VepcF5972fXfErhtwjSJvi7e2jmseE49K3+/XyEKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6066.namprd11.prod.outlook.com (2603:10b6:8:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Mon, 20 May
 2024 23:41:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 23:41:48 +0000
Message-ID: <1ce87335-2ea7-41c4-8442-36210656cdca@intel.com>
Date: Tue, 21 May 2024 11:41:31 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 13/20] KVM: SEV: Implement gmem hook for initializing
 private pages
To: Sean Christopherson <seanjc@google.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "tobin@ibm.com" <tobin@ibm.com>,
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "alpergun@google.com"
	<alpergun@google.com>, Tony Luck <tony.luck@intel.com>, "jmattson@google.com"
	<jmattson@google.com>, "luto@kernel.org" <luto@kernel.org>,
	"ak@linux.intel.com" <ak@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "pgonda@google.com" <pgonda@google.com>,
	"srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>,
	"slp@redhat.com" <slp@redhat.com>, "rientjes@google.com"
	<rientjes@google.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>, Jorg Rodel
	<jroedel@suse.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "kirill@shutemov.name" <kirill@shutemov.name>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "ardb@kernel.org" <ardb@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-14-michael.roth@amd.com>
 <41d8ba3a48d33de82baa67ef5ee88e5f8995aea8.camel@intel.com>
 <ZkuJ27DKOCkqogHn@google.com>
 <e771a7ba-0445-483e-9c42-66bd5b331dce@intel.com>
 <ZkvZkPvHqqPnVa9k@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZkvZkPvHqqPnVa9k@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::9) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM4PR11MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: 388f4dc0-6c6b-43c6-31c3-08dc79266aa7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bFc5OXJ2OWZEYVNpa2RWZFRsMWUyT1FoNXZWTUtXUmZFZXA0NEhmTklmWGFB?=
 =?utf-8?B?dThteEFnWDJGdlhnbm51U2UrbUVJWmRWMXdqNWtzZFVUMStlQ3JyWlU0OXRZ?=
 =?utf-8?B?V0V1N2M3aTNncVIxMG0yc2VUT1JWQXl3SHJ2SzFDMEJBb2dxWElLcHVkb2tY?=
 =?utf-8?B?cjVSc2JmTkZxUU1pUjVCTUhnUDd3QTM5bjYrOFdZakNEM29OelJkV2c4QThK?=
 =?utf-8?B?ZGdRUDh5aVVpZnB2SSs4d1dJRXFlcEpVejRydTMvUVpxRThhUkI2b3dQcm1r?=
 =?utf-8?B?SHNRdnFuMHU2dzEwSXNhSWdtVkQrOTJHVjNhMTlJalAvazd2c1ZidTJ0VHRx?=
 =?utf-8?B?bVJQYnJSR09pUkdqZktPOVc3WWttUFlvWHByU2srM054N2oyV29sdENWVUJn?=
 =?utf-8?B?UFA5bG1NRjczbm9FNmhjdGdDWFhnYVhEZ3ZCTTFZZE5CSmp2MkRwSUJ3T284?=
 =?utf-8?B?amVyYzB2WlZGbUZIVmR3NEU4N3lmUmpLdGJsWmhrMmlXLytpS0ZPYUlsbk5j?=
 =?utf-8?B?R1NPOWc0VjljVlhlNTRHdTlZT1pLT1B1TFhCeGZkdjZkZm1NVUgwem1XS2xB?=
 =?utf-8?B?d0U0ajkyWG5JL1B1QzRLdGpWL1VPTVVpY2hOU2xsRXVoYktabUFxajRzSFBr?=
 =?utf-8?B?RDdSZGFFaFF4S3FWd1h1Tm1oTUtieEk3K2pJTGYzZ2lRZTExOXBncytKNzF2?=
 =?utf-8?B?bTNwcTB4NGdrQ1Z3NnNrZmhWUUp0RDJNNEgyMWlMdGsxYklENFVaWG9pTmRy?=
 =?utf-8?B?VURaNHR5YTY1R1cxR25JaTZZcUloMGVXT1J1M3AvaTRYbWljam9HTThBR0o1?=
 =?utf-8?B?SGR0Z3JqTmNnTHNIejdQd0UzVXd5STdCdmNwZ0FGUXIrM2svTjFwMDFxQWEx?=
 =?utf-8?B?WXU1bWNiVGE4WGRBMzdDNGE3TXQ1WmhSL1UzS09qamVFSkZqSjNTMHQ3NHBD?=
 =?utf-8?B?b2lWOEV3MDlzcXI5RFJRZ21mY1c5K1VGKzRSekwvMWJjK1hSNGxnaEpMUUlq?=
 =?utf-8?B?VVlza0pqOW1pckZQUFFxL3ZhcGp4OHg0NXUyNHhZNTNBa0xBTXBRRW8wQVp5?=
 =?utf-8?B?dEhZUGFxekF0UE9oUmg5emtiYitZS0dTN0g3b3lYRHpIQmttRENHQ1B6L0U1?=
 =?utf-8?B?d3hNcFdCbzRkZXBIaENDMUc1SVUzZFIvSHBocXlxMjJLazE0RHF1U3gwU2Vh?=
 =?utf-8?B?Zm5SbFR0ZGNlWG9rcEhWWVhzWkdTUUE5TXcwNU41ZmxrUklJNTZkdmcvYXh0?=
 =?utf-8?B?b05NNFozWEhlYXJ2NkFTdzdhQmNPN3BrVXo1YnRFWGxlRWRCaktvWEN4TWZO?=
 =?utf-8?B?RXE0VGFxbnYyWlhkQW1mRStIY1g5U3Q0YlhtVDR4ZWIxd1hma0JDaHlXNlE1?=
 =?utf-8?B?ZkRVOE9pTEJoR2dqS2pqSjc1ZFpOQzRGQnIxWHlEOUZCNUdKanRvQUJYVzVj?=
 =?utf-8?B?clE2a21BOWhxdVhhMURDblFNbTRvYjZtMG9FczJaby8rTWRGMVBJeUJJODFD?=
 =?utf-8?B?dE1mREI2YW1WeHE0bzQ4VE4rbFZ0bEx1cS9JMWVOWkZCQzc0QWlhcThhVG9G?=
 =?utf-8?B?NDliWUhTUVdEd2ltdjFiNTJ4bEFpOFhxcmRLZW1CMlU5bEQxSW9pRU1yWlJs?=
 =?utf-8?Q?goPxjjImw12BCZgi2veNnFBGl7Sl1m1okVMXHGb0KsaU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjMxT1lGWVVUSlFIZEIrejhvcWJRc1U3QXNOL0xTUTVhdmxqaVJKYkZTdDlz?=
 =?utf-8?B?U2hJS1d5M0twZkFqakRuSEU5dDNmdmZWR2kwYXBtRUpaem90Sm9vRjJIMHRo?=
 =?utf-8?B?blBTQTVTck5OVTZzZ05lclFMVXB6U0FaaGhMM0l3ODZ1blBnZFJ3a3pKY0w4?=
 =?utf-8?B?QlNlSDh4QVRIbWpSQVlSMHY2MW1abGRsVng5ZHcwaE5FVFRFN1lLNFFPV1I3?=
 =?utf-8?B?dFVDUUJyanJZYmFFNUN5MGRxMkdEWkFXV1JmTUxIUTI2eU44cDc5U0F6cEdH?=
 =?utf-8?B?cVlSMlc1S0twZDE3SW1BWXM1U3RNdGc5Rk1mRk4vaHRURkR2NU9hSmVKTnht?=
 =?utf-8?B?NCtDaUZseWYzSWUxVzFzVi9JbVY3WmNXVDQwOWpMeC9iT2ViNFQ5S2VVSnFo?=
 =?utf-8?B?VlQyMERmM3RBT3VWWmZJUjZJUzh1V0VoYTYvS3NOYm5aVjRqbnVYTEZuekZM?=
 =?utf-8?B?cWJ1ZURRZURlbW5Mc1FVQVRBOXhMODRieDFUM3RDczRVbFBpUmdyb3pGOHli?=
 =?utf-8?B?eWMwSFFRK2R1S0NFTjZHamUrYlIxWGFMWU1paXczTFBVQlZjVmEzV2t5cXg0?=
 =?utf-8?B?KzdkZjdiRUVuZ2U2eER2TUZjMkhyckJxTFMramNiL08rQ0hWTmxyZEJmQ3M2?=
 =?utf-8?B?SXBlNzQ0MTFicmdWUXlYeDBNYjRZOWsxVit4TnZPcS9pQTl4MTRrMUxTNEY4?=
 =?utf-8?B?emVPb1JxTzJLNElWZyt0ZU8zTmtRVkF6YjlDcGFpN1BIbkc1a3JNOXg4bXpj?=
 =?utf-8?B?ZmtxVy9CUU5Md0VpbHMyMXk4bklTb1V0Wm5CL3ZWNi9lK1ZCTjd2eWFUSndR?=
 =?utf-8?B?QW1IeWJXT3BNWWRFaTZUcWJDNEwvRHpYcUdnSHdZVnN1QzBleUVBb3lyWFZw?=
 =?utf-8?B?djhOV1diNGlMNUhoUkFqcWF5WjY4VFd3R21zcCtHK3ptNzN3bzFnZGxVOXo1?=
 =?utf-8?B?RlVndkZwQXdvQTB6SHp5bzZMVHQ5ZDk1MFpGbTFuUktSS3Y0SlVpWnU0ODZO?=
 =?utf-8?B?TmdaM0l6YTBScFpBdGtKdmNwV2YwTERoU200TGZUK3dMNWt3ODR1TzlEVE00?=
 =?utf-8?B?OStTTHFUaENZUlY0bHBabDlkTG4zdXphM21YRFB1R1pRd3p0WEsxeEp1clZI?=
 =?utf-8?B?VEt5cjhheTRXT0FDMUsrazBoaTRIcU9RUkRteGVyalJ4WjRzMk5na200dExp?=
 =?utf-8?B?RDBrdHhjR1VMZkNiWUdpZDM2RmUvYVBhdHhEZjJVUDV0Y2JhL3JrRXp1SFZr?=
 =?utf-8?B?QmVtYUhVOTI1TDV0Vk9uM0dFRUV6Wm9mNWxNYXZEMFpSU0R5aFJwT1pod1dB?=
 =?utf-8?B?MVlHVkJIbFE0cUJVOHNaMWdMZW1OTklpQmhlK1BRZS9xVlpuRlM0SWNSc0xT?=
 =?utf-8?B?RjNiQTRHRkdkZzJrUThsb01GS0VXL0VydHdIcUgxSjY4VmI2YzBXT0gxVjV1?=
 =?utf-8?B?WkY4SXhGSGNkMnpoaTR5a1ZFVTN4ZFBUdXFLYXh0dU94cVZIUWJaV2lVN0pq?=
 =?utf-8?B?bFc0THVVNEpnZk1GM0tCUjhYM0o2WXNubDFEK0hQcGR5bDdjN1dpTUdCcEFt?=
 =?utf-8?B?MWVUN1pWMVllUW1jQ2tXaUdydFEyYWZQamszdWE5VEZYOG0zdVB6eFk2d285?=
 =?utf-8?B?N0h5RFJmUmhjMUg0RWpwY1VzNjhHZjdYVHEvR3NVUmJnMDF0NHk2RTdOWXZl?=
 =?utf-8?B?U01TUi9FWmlyZW0wWXZHY2NURk9naXlZWW9kS3FYNlBxeFZXMlF1azlGM3hU?=
 =?utf-8?B?YW85cmI2QzJmdVlKNEJqVXZVQ3ViR3g2aStmM25EVWt4MXh6ejBUS2h6S3hi?=
 =?utf-8?B?ekxuaUxlMThXcUc3M1NYSXk2QzQ0RlBCUE5mOE5PZjMxdmc3MjNqbktGV2J0?=
 =?utf-8?B?YnhtZDVJWjJ6em1keEN1S2ZlVkRnKy9hZmFsSXFreHB3WjhPODNsTTlnTWNQ?=
 =?utf-8?B?bmZGWFpSYUoyVG1PNE9xd3ZWeVJsMVptWE5OU0djVWp6Umx4N1hramhjRUFO?=
 =?utf-8?B?Q2xWVHluOEU5RllpdnpCcGNiQTd6VXFWaHhpL000UlpicWltTHpZc2NJeUNp?=
 =?utf-8?B?ZHlTZTlId0kzc0xxeVlBci9QSWlvYjkyb0FyaDExSldQWXM5MU4rWExEZVJv?=
 =?utf-8?Q?JsnPRCsjCEmD5aI4M68AoZvf0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 388f4dc0-6c6b-43c6-31c3-08dc79266aa7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 23:41:48.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OkKtdKjS7jT0Wu+cf6ZoSyRCR8d2b4ygh1oxqE0pZrZYIVERNAlrlhrUAEvOy/oIwY79ubshrZBVEp07h/ltZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6066
X-OriginatorOrg: intel.com



On 21/05/2024 11:15 am, Sean Christopherson wrote:
> On Tue, May 21, 2024, Kai Huang wrote:
>> On 21/05/2024 5:35 am, Sean Christopherson wrote:
>>> On Mon, May 20, 2024, Kai Huang wrote:
>>>> I am wondering whether this can be done in the KVM page fault handler?
>>>
>>> No, because the state of a pfn in the RMP is tied to the guest_memfd inode,
>>> not to the file descriptor, i.e. not to an individual VM.
>>
>> It's strange that as state of a PFN of SNP doesn't bind to individual VM, at
>> least for the private pages.  The command rpm_make_private() indeed reflects
>> the mapping between PFN <-> <GFN, SSID>.
> 
> s/SSID/ASID
> 
> KVM allows a single ASID to be bound to multiple "struct kvm" instances, e.g.
> for intra-host migration.  If/when trusted I/O is a thing, presumably KVM will
> also need to share the ASID with other entities, e.g. IOMMUFD.

But is this the case for SNP?  I thought due to the nature of private 
pages, they cannot be shared between VMs?  So to me this RMP entry 
mapping for PFN <-> GFN for private page should just be per-VM.

> 
>> 	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned),
>> 			level, sev->asid, false);
>>
>>> And the NPT page tables are treated as ephemeral for SNP.
>>
>> Do you mean private mappings for SNP guest can be zapped from the VM (the
>> private pages are still there unchanged) and re-mapped later w/o needing to
>> have guest's explicit acceptance?
> 
> Correct.
> 
>> If so, I think "we can zap" doesn't mean "we need to zap"?
> 
> Correct.
> 
>> Because the privates are now pinned anyway.
> 
> Pinning is an orthogonal issue.  And it's not so much that the pfns are pinned
> as it is that guest_memfd simply doesn't support page migration or swap at this
> time.

Yes.

> 
> Regardless of whether or not guest_memfd supports page migration, KVM needs to
> track the state of the physical page in guest_memfd, e.g. if it's been assigned
> to the ASID versus if it's still in a shared state.

I am not certain this can impact whether we want to do RMP commands via 
guest_memfd() hooks or TDP MMU hooks?

> 
>> If we truly want to zap private mappings for SNP, IIUC it can be done by
>> distinguishing whether a VM needs to use a separate private table, which is
>> TDX-only.
> 
> I wouldn't say we "want" to zap private mappings for SNP, rather that it's a lot
> less work to keep KVM's existing behavior (literally do nothing) than it is to
> rework the MMU and whatnot to not zap SPTEs.  

My thinking too.

> And there's no big motivation to
> avoid zapping because SNP VMs are unlikely to delete memslots.

I think we should also consider MMU notifier?

> 
> If it turns out that it's easy to preserve SNP mappings after TDX lands, then we
> can certainly go that route, but AFAIK there's no reason to force the issue.

No I am certainly not saying we should do SNP after TDX.  Sorry I didn't 
closely monitor the status of this SNP patchset.

My intention is just wanting to make the TDP MMU common code change more 
useful (since we need that for TDX anyway), i.e., not effectively just 
for TDX if possible:

Currently the TDP MMU hooks are called depending whether the page table 
type is private (or mirrored whatever), but I think conceptually, we 
should decide whether to call TDP MMU hooks based on whether faulting 
GPA is private, _AND_ when the hook is available.

https://lore.kernel.org/lkml/5e8119c0-31f5-4aa9-a496-4ae10bd745a3@intel.com/

If invoking SNP RMP commands is feasible in TDP MMU hooks, then I think 
there's value of letting SNP code to use them too.  And we can simply 
split one patch out to only add the TDP MMU hooks for SNP to land first.

