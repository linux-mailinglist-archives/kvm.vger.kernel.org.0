Return-Path: <kvm+bounces-8321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B144584DC5A
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 10:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5E401C25213
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 09:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8FD36A8C6;
	Thu,  8 Feb 2024 09:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d3RAZPFk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565656A8D8;
	Thu,  8 Feb 2024 09:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707383105; cv=fail; b=tam4tWwytH+MyzniOh8AJpXpSOstPJVjEubQta2WrK90YnJH72/qFZiVOZ9Nb/IEBEqolSGi+YeI/sYT0Q/DFd4gVkCTOnxaiWx1iHIoPgO86LvQhU5UvYSHsgnTb+Cv8ErXHkl1NlfMq8A8xc4rzSJsyk/nXvE1p6XYS2d3djs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707383105; c=relaxed/simple;
	bh=1HlzXfdc8lvhEUcSZAXlHrQ8tI5R4LqU6Vbn104u6mE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e3+YqBXv4FtIMYcjgNFcz3Ry9xBIncjgU0X58YKl9lRyOZtJHDGrOaXISDU+zlDTQPhb3cULCvBz4Ktqox+3GSAZo6ZYB4J6x6iWF1f3hzlPvlpIDeEVMH5AzgxwowC3inp2B37JkklxIS71diJoW72/EQLORcdlvR1PuL8JalQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d3RAZPFk; arc=fail smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707383103; x=1738919103;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1HlzXfdc8lvhEUcSZAXlHrQ8tI5R4LqU6Vbn104u6mE=;
  b=d3RAZPFkoHk0DhyR4gUsNE+8A/0hCSLntNNaC8bLpMS9P0XIiimYUjEC
   loaH/VeFpVR7ZoVeLc2kZixJtWd3C6Qvo1zVRnBTVboXn1On/5Bvj2FQp
   FJJtaST49pLQOuCBr5wAOU76udXtZl2FT0HMVqwqmvMkW+3dYme6qIW5G
   30gzT+rbtP/JQULgc8OFwzIR6HMgoKWLuh9dqp08HIxXe1PmBHiLF6yKF
   KkoBOrXr0ORIO71cVjIEz2JlUCWlAUToVNLVX/T6LvCaT40mM44B+kNNd
   IAfhpTK9o0Cjd9AO70ebn+54XeMRu0YixccMm36zONph8LP+evLo9BcO/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="436314054"
X-IronPort-AV: E=Sophos;i="6.05,253,1701158400"; 
   d="scan'208";a="436314054"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 01:05:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,253,1701158400"; 
   d="scan'208";a="1591615"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Feb 2024 01:05:01 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 01:05:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 8 Feb 2024 01:05:01 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 8 Feb 2024 01:05:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anMEQ6XfxiywAYu7B7NpaxoQVsNfj+vfVLcimEyjeCBhOyXFlEv571utR+xkQ2u2MJ7uOI6lHk9E7WnxEEI53/OMQ8OpWUDqXUfKmIH0b60RKFyM8tj8N2PqTwJp2u/JEaJyEGTPEs3rYj/Fdc0uEFxxGLrekM6lcy0JouelvX2hPs6c2+XP8x91JIKHZ24NKlZoMyEtLO+Mg37iaNsu4Tc+my78iXqqaMQQWuSz85PERoRWlcxCSJjhHwux4fSPfbTaRByesbTPF45kWwNrUDsg4xCtJ7eIKREh/Y/whsY/V5CVmaVR1cs7vmS7H+wV7tByVqq+bKeM5zyfbGxOOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X4Ov4QB92kitpVlUiP66xay9dtqm0mjjIp+4Hi6hwAk=;
 b=feaEq4REtqjrg0OIABQfJuMoHdsPoS8/d02p1hwBGKlE6NsByjEFVlP4a5avYfbR+3tktts8iBLKtEhLoJrmnv95wKm1x00ob8sRt1AJ7WhR+ea+vGfZPZ/rRD0MIR2mFa+f/RJW9y2ghEQ0MRtlMX9TOvXyN0xElwLVYjZs1kLG1ikIJnK5E4YKHkmDHkzK1EUttngtPhYusX60hT2xqmfxSINupRL7CNQ1N83tHx52VgKe1tgmUhdoZoe6HOJ13K0cnJ71T46U9j1hJf1llLl4sgqUcyvBP9sfBMJKQwuAhzFaB0qduC5bfn0tc4zmwqaZ2gXPpFg+CaD5bPqOIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by SA1PR11MB8474.namprd11.prod.outlook.com (2603:10b6:806:3ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.42; Thu, 8 Feb
 2024 09:04:59 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::ac43:edc7:c519:73c1]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::ac43:edc7:c519:73c1%7]) with mapi id 15.20.7249.037; Thu, 8 Feb 2024
 09:04:59 +0000
Message-ID: <f0e37b73-1d8d-4717-9dcd-2596384d0d19@intel.com>
Date: Thu, 8 Feb 2024 10:04:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86: nSVM/nVMX: Fix handling triple fault on RSM
 instruction
To: <seanjc@google.com>, <pbonzini@redhat.com>, <mlevitsk@redhat.com>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <dedekind1@gmail.com>,
	<yuan.yao@intel.com>, Zheyu Ma <zheyuma97@gmail.com>
References: <20240123001555.4168188-1-michal.wilczynski@intel.com>
Content-Language: en-US
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20240123001555.4168188-1-michal.wilczynski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0266.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::11) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|SA1PR11MB8474:EE_
X-MS-Office365-Filtering-Correlation-Id: 30baf4e0-e35c-45c0-6423-08dc2885069e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64sx0Ce5i4gHtDudYEYZAp9PoTbFmojq2LTclqiZEW3ZCwXeEYmGfBuSmyh86XiHESTgjrovYLP89mOgMBQrBjWcP3qcoy/4vz1xMZLC2kUwI47bSij0zQ25zn7JQeYg3BAnHqMKqPuAqkRQZ9auQ1s+3IczC7fQhYSFcAGzjeBICQeBIwvFrkaR3Q2/kpqSm310UiPseSFAx2Tl5pfOX3cGiSfZ66WTTDVbuLV5cNR111aSFxfVZPpcE4W5N51OKgtRAhJOXzVMqpVl+6TIIm8A2asAPyo8xrMSevoZitaXIGCzc+P+63j8DLn1+zF3e+c6cGctYJYSh2peg7ql8FCWmZnCTMVZS0bdigwRvphfQGZtgNgWktHkbR8z2QqhZ7X4mg9G1Y/VbViVX+sh49XJWsqy0IEwhaE7XXqRiQR4Ervy7wLsn005Nv6dGr2iyIOosv37WgOrwMaLswrINwDbRZbRJ2Q7HCe4tW3x17jF9w/XADlmT3wrj4dLxP/PMR21Vlt8Gp8BJqRjbKlOtDGs7hZvH+FYDsDdYUeDwpdZs2+S1n/Dtu5o/X4Dcaw3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(39860400002)(346002)(366004)(230273577357003)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(2906002)(8676002)(8936002)(4326008)(7416002)(5660300002)(83380400001)(2616005)(26005)(38100700002)(36756003)(82960400001)(31696002)(86362001)(66556008)(66946007)(66476007)(316002)(6666004)(6506007)(53546011)(6512007)(966005)(6486002)(478600001)(31686004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkIxSFg2aWUxZHVaemRjRGhoME14TWgwdkJzMGdCS2doVlNsaExFcjJhWW5k?=
 =?utf-8?B?cG1FUm84ejFrSG1ZbGlrd0E0UWV3UHVtaWNBa1pDZnIxcmw2RXlpa1BzQ094?=
 =?utf-8?B?VDg1ZUUvNTRIK0tZOW5kR1FjN0JFSVJmT2NpNDkvb0lHazQ1d2lXb2RyOWg3?=
 =?utf-8?B?YzhtSHQ4RVpvNXpWVEhSQW40WFdHMGlnTVBOOGpjcmF3eG1yZEtrMDZ5Zy9n?=
 =?utf-8?B?dVVnbzJJQmhERjRuYTU1Y1BtRWdjaGdSQmxRWlZ2a2RZNUtpVml6RkI4Rm02?=
 =?utf-8?B?WmhDNFkrNC9idHhSOHAwNXk3V3ZHS2pibG4yZFQzTGd5dTljNXlYR3dTVUx1?=
 =?utf-8?B?L3BXVTlRdThhSVNodTZmb3pDdGRPeHF6bnZkdWl6QVdhWkUvbzZiSlVFZjNr?=
 =?utf-8?B?V0t4WVFsRUJvalYwQWNZd1lTRGpVODA2ZHF5aTVmZURhSTRFTzRYWHF2WWI5?=
 =?utf-8?B?dlo0b3BsU0wzb3liOExraFREbktHdmNZVFg5TWV4SmRMN2taZnFFTyswUkRn?=
 =?utf-8?B?b3RqTlZqTnFWK1d3eFdVV2tML2liYkVKNmxUblVacm5pNmlqZ1grUDBtT051?=
 =?utf-8?B?d1JKdTI0MEJYRXNXckxNcExVQlRyNHErUVRrNXB2ZC85UzZHZ2xEOGl6Q3JX?=
 =?utf-8?B?RnBHOXliTjdRV2hSc2tLVVhVc01vdHQ0RjBjd0JJS0pseFV4SncrTVNNTkR1?=
 =?utf-8?B?eUVEQjQxcHMrbXlCelY1aVJEZTRRTUJIT0JiVWZlbEsxTTBoSzFGRG55UFht?=
 =?utf-8?B?MDdJN1pQcnpoa0QyMXVlYTcraXJrVjBJQnhDR3BZRUtMYjd3VjlhVjNMT2N4?=
 =?utf-8?B?MkxVRWpvRFd2VWRmRFhSOEgzdjhsS084YlI3NVBPOFpUcTVhZXBrVFRpQkVk?=
 =?utf-8?B?MHBQN2UwQk9xb3dxL0N5bTdOQkRSdlBuc3l1TEZtd2cySDZmQ0w1TDVVOHBo?=
 =?utf-8?B?alN4MXZDM00wYW5BbjhWYkVQUVlxUnNObGVrYkhqK1U4dGJzbHhlQXdhZXFy?=
 =?utf-8?B?dUxTdHUyUG1SRzE5OTE4dURoeERWVnlXWlRKTGxjSVhNUXRCS2p2SkdpMUx2?=
 =?utf-8?B?T1pXVS9ZNkxqTWszT0hXaitidThiOW9CUHhmQngwc3RNTDdJenQxMFpDQWhR?=
 =?utf-8?B?ZzJGT0hiMDRtcVh3bzdDUkdKd1JabDloKzI2dTFyOW1FempzWmthREpVUHhj?=
 =?utf-8?B?QVJhQzRkREdFVU1xb1FRWUFPcm5KWEJ5Q2Y5dDVFUjhyc2xZZGxncnhLUjE4?=
 =?utf-8?B?UTg0QW1vaFlSKzhRU28vbEZqMVI1azdXaXZIQnZtdmlRWnJ1emdaanM1ajBY?=
 =?utf-8?B?dlJuMU5OS0t6blBIYWVUMDJjenVEdE9WVmR4aXZFOUdwYVQyQXFOcDJaSy94?=
 =?utf-8?B?ajhNV0xJODYzOW81dHVDT282WGloNHBHOFIvUEo1SDZIeGxsVkhTNUhkRG5y?=
 =?utf-8?B?NkhBc2lTY2wrWnh4OGYzMzFDSnpzcGg2RWxEMWF3Sjh3bGNYRHJNMTFUVTZa?=
 =?utf-8?B?Z0sreG1jSEI5MlA5dmpOVmF1amtnRHlvK3h4cFJyZ1YwSGVZTnBySWxTUEdJ?=
 =?utf-8?B?ZWdUekgvMkJkZ0grMmgwczNpL1BCU2JVa254SExtbWJqQ0t0S1Y3Q3dlWWpT?=
 =?utf-8?B?R1BpalJidTh3bDNTaXlhZDIxQ2xZSS95ZzRhRWNudG5WeWdQSGViOWNjZ0N5?=
 =?utf-8?B?QmQyc003c2dnd2VtTVlrV3A0dVhKV3hmZTlDOHNOQ1pKWXZWQmZiM2MxYXJ5?=
 =?utf-8?B?UnNuTHMvTXEyYjlPbERWQlgvSjFDb3gyQzluc3Y2OElSYkYrdHJ0Um9yS2Ir?=
 =?utf-8?B?U3BRcnJ2dWZUbFdtTXlhbFhvQm1wZlBrQXlMMmFIdWVzbWI0U0hDTDJBWjVi?=
 =?utf-8?B?LzlmaUxWQ285WHExMTIyNDlVeW1jYkN3V1dqS04wVjIyMEJ3clVrTGJPRTlT?=
 =?utf-8?B?eUxGZFlocmp0SndUVllldkRYbFNCWmFSMU5JdFBBbWRvUW42Y1RLYXNqeHRF?=
 =?utf-8?B?cUVlcjd3aXRIb3A1Y1RRMWVTenVacHpiWFlweXd4OHdOZkJmZGZpV3BMM0dP?=
 =?utf-8?B?c2tsZlRqazRteGxyQzB6Q1FBZ1RPNE5sZ05zTDc2U0ZXOVBGZTk2aVVjeExy?=
 =?utf-8?B?WFhHQTBPOEd3RW80WWZiTnplazgvZmdvazk0WUhTdnNPZENiZnBtcGhSdmpu?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30baf4e0-e35c-45c0-6423-08dc2885069e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 09:04:58.9033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FnBpkWtBC1M5nQmXdtGbOua5QvihV9N+dSvyF50CswRCOgttwmkQYjRZJlhfU2LYgey7+x+QhTblnjRg/+XoVkrX09Lv0w+ITxEEeA+5pxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8474
X-OriginatorOrg: intel.com



On 1/23/2024 1:15 AM, Michal Wilczynski wrote:
> Syzkaller found a warning triggered in nested_vmx_vmexit().
> vmx->nested.nested_run_pending is non-zero, even though we're in
> nested_vmx_vmexit(). Generally, trying  to cancel a pending entry is
> considered a bug. However in this particular scenario, the kernel
> behavior seems correct.
> 
> Syzkaller scenario:
> 1) Set up VCPU's
> 2) Run some code with KVM_RUN in L2 as a nested guest
> 3) Return from KVM_RUN
> 4) Inject KVM_SMI into the VCPU
> 5) Change the EFER register with KVM_SET_SREGS to value 0x2501
> 6) Run some code on the VCPU using KVM_RUN
> 7) Observe following behavior:
> 
> kvm_smm_transition: vcpu 0: entering SMM, smbase 0x30000
> kvm_entry: vcpu 0, rip 0x8000
> kvm_entry: vcpu 0, rip 0x8000
> kvm_entry: vcpu 0, rip 0x8002
> kvm_smm_transition: vcpu 0: leaving SMM, smbase 0x30000
> kvm_nested_vmenter: rip: 0x0000000000008002 vmcs: 0x0000000000007000
>                     nested_rip: 0x0000000000000000 int_ctl: 0x00000000
> 		    event_inj: 0x00000000 nested_ept=n guest
> 		    cr3: 0x0000000000002000
> kvm_nested_vmexit_inject: reason: TRIPLE_FAULT ext_inf1: 0x0000000000000000
>                           ext_inf2: 0x0000000000000000 ext_int: 0x00000000
> 			  ext_int_err: 0x00000000
> 
> What happened here is an SMI was injected immediately and the handler was
> called at address 0x8000; all is good. Later, an RSM instruction is
> executed in an emulator to return to the nested VM. em_rsm() is called,
> which leads to emulator_leave_smm(). A part of this function calls VMX/SVM
> callback, in this case vmx_leave_smm(). It attempts to set up a pending
> reentry to guest VM by calling nested_vmx_enter_non_root_mode() and sets
> vmx->nested.nested_run_pending to one. Unfortunately, later in
> emulator_leave_smm(), rsm_load_state_64() fails to write invalid EFER to
> the MSR. This results in em_rsm() calling triple_fault callback. At this
> point it's clear that the KVM should call the vmexit, but
> vmx->nested.nested_run_pending is left set to 1.
> 
> Similar flow goes for SVM, as the bug also reproduces on AMD platforms.
> 
> To address this issue, reset the nested_run_pending flag in the
> triple_fault handler. However, it's crucial to note that
> nested_pending_run cannot be cleared in all cases. It should only be
> cleared for the specific instruction requiring hardware VM-Enter to
> complete the emulation, such as RSM. Previously, there were instances
> where KVM prematurely synthesized a triple fault on nested VM-Enter. In
> these cases, it is not appropriate to zero the nested_pending_run.
> 
> To resolve this, introduce a new emulator flag indicating the need for
> HW VM-Enter to complete emulating RSM. Based on this flag, a decision can
> be made in vendor-specific triple fault handlers about whether
> nested_pending_run needs to be cleared.
> 
> Fixes: 759cbd59674a ("KVM: x86: nSVM/nVMX: set nested_run_pending on VM entry which is a result of RSM")
> Reported-by: Zheyu Ma <zheyuma97@gmail.com>
> Closes: https://lore.kernel.org/all/CAMhUBjmXMYsEoVYw_M8hSZjBMHh24i88QYm-RY6HDta5YZ7Wgw@mail.gmail.com
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
> v2:
>  - added new emulator flags indicating whether an instruction needs a
>    VM-Enter to complete emulation (Sean)
>  - fix in SVM nested triple_fault handler (Sean)
>  - only clear nested_run_pending on RSM instruction (Sean)
> 
>  arch/x86/kvm/emulate.c     |  4 +++-
>  arch/x86/kvm/kvm_emulate.h |  2 ++
>  arch/x86/kvm/svm/nested.c  |  9 +++++++++
>  arch/x86/kvm/vmx/nested.c  | 12 ++++++++++++
>  4 files changed, 26 insertions(+), 1 deletion(-)
> 

Hi Sean,
Friendly ping,

Regards,
Michał

