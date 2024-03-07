Return-Path: <kvm+bounces-11229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9990F874541
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50354286B5B
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCE846BA;
	Thu,  7 Mar 2024 00:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kkPBTYvP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622DD17F0;
	Thu,  7 Mar 2024 00:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709772380; cv=fail; b=E+qCOknBJdb6UcxVCb8BnbyBY+i2l5XOax3SCf3cYWHHY9PewyTSYfGBRB91VS0W4mSV9CVh+LUsAj/kP6xdxAGLk0yBzShOaq/yR/ypcCxvMoct7LJ2g92JmmyziV//RK3p8I1NOYQ+4yNgbUVM0ZuPoSUoZ6qpu+hgdi9+BJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709772380; c=relaxed/simple;
	bh=CUldRUdT8nk1owr7+h8oHhqdszErwJUiFrkLU6FFP74=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LDgv9JwpBmI286UcuOyG7cdYq2ykee2sdPnOo6Ef2fOXmRDhxxUCt+xz+pZckyR0qvV8xf+hlTWtNzQq+6G+dgEsc0z8bPq4H/tLFilwcU53UhbP8R0DnsHcsQ11G3rYJNWLHhwbi51iCfSb8JMgl3eNq/8dWKusR1NHeYsBuzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kkPBTYvP; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709772377; x=1741308377;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CUldRUdT8nk1owr7+h8oHhqdszErwJUiFrkLU6FFP74=;
  b=kkPBTYvPw4LP34Cw0zUytv3zUS4S/Us1LYfRU/OExXVJDey3724SkA4v
   DMQAM0KDkQIxEa8Imy8BewjF03cV3v6u8Y1Rzhh+joJ9Qh3tSzMhZAt2p
   liaH7XJKWkiyNnToJZP8OnTQBlVq/hXLv8SoB3Y6rmGcHliq6OEEXBCHT
   aO0PSzTujA1BJvhI+7BZPucQp8XcIWsjRXyj3wjWvRWUxmmEB0p3vfy76
   qBUkhXF1KNy9KHVUKqCt7M1t2cpJ7jKQLoapq2mkCpp/T2mF5dnVYyCti
   dZTVnvM1dOJeVsecGKBmeLYx2bj7QADYG2DMqvziiGo4nmx4oLmcuM0WF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4266901"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="4266901"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 16:46:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="33088160"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 16:46:16 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:46:15 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 16:46:15 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 16:46:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hyEp2/5iNU7Mata1VwSR8IIFXU1TApm2bmz05XdJ+49L1Mc32tut6sr8q/kLb3Bw32KEpyfxpkHJLX02Yu0Sm8WeW4mMYml0E0M9MCIZD4zs0OMWgBVljvT6ldIaxDRlqN6lShMuC785o4Dsp1fNiO77sT0ZPObtG5W13Ka8ijvVGh4Q/kZ6dQP9gYKytBWQtISKC5j5tEaZWLGlCLnCxrPWCdDK3EZJM8V/I5cX1N83QmP+g5x/vwyrct8rOgvHtF6jrAGSGBVd1DYL3cBcbZsMX+FxveEP3VCv9akoIkTH1jDtv6zMuR4eoAHNafoR51nVRfuHl4k9+xeSwxGZOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjvWROup9+94yPDLzmZM0jdAWxv72EJ9fUFXCdala2U=;
 b=N+0GDpaEQjHcjACrt1xW2EGHLxAnzg1roYakSwNwZfitFpzFCWeZlx/rMro2BQADaGTJBh5r2U1cVwm6RhHUTiQJEEsqXFwp6fOI9Qm3XcZiyiUBBD8bKi/b/phtjCceoOOzcUTVPzxcCVus10kPHWsGGGqtJ5pQQbv1VMfMB4HnTy/UOnQKsbP3yQjU6Zy+o5/trp3BY0f5PtafexhffpKe5XvS+6F2vShOm6+aM6B6+8MMq2NmpWDKZg4iTBwTD68nvtqtmPEXX1XL2pYevwsSKz+UJ5GeRNIKUAbOBV0T7QqH1uk7mvT0bMTyiwcCrTklHbAoQ+eVmQXVIxXuhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6728.namprd11.prod.outlook.com (2603:10b6:806:264::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 00:46:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 00:46:13 +0000
Message-ID: <baea57a0-a50e-41ce-a6a6-4e52c5c3d486@intel.com>
Date: Thu, 7 Mar 2024 13:46:04 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/16] KVM: x86/mmu: Sanity check that __kvm_faultin_pfn()
 doesn't create noslot pfns
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, Chao
 Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, David
 Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-17-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-17-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:303:8c::24) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB6728:EE_
X-MS-Office365-Filtering-Correlation-Id: b15a9899-a2fe-4b10-23a3-08dc3e3ffd4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: INH3q3u01sPaJt6ESFeYsdp3GAv8GPPKZRCikPnhuK3KLVXlHuFS9FaJdDr2KszcTujlQELFGEzk9lH00lUh4CRhlieeNRQctJujk7d00xFpwmmhKnNcmXfqoFQ1X9azd0HvmzWEup82z8A9a1ZHtRAO03unXcyCLSfAlkR5T8Ok0/FOknL0ouZ9cba/QIKLuI6v0UYPIt7342n8ZvKzfNHd9sjMASE345V3JxFPNQ0TYaYHSuIDe8IFE1qvHu+YghlwNCmRccQPPhDJBsgqyhmrMPOxWJN/zrOGQ4i3IiVtPGaTC/kxafViLuf2VtvfRnugl7Z+fmeO+vapoNB4D5XGx25nNA5PPwi04kowpdHVseeAXXJ0CvB0+u7KluzhoAEq5vCYVBTKOAXnW3EW6BFy7vOarEUvtpDzS+aWPVvLB12eoaAy5k4OIPTBiTfPIz8xxUC4mZTkMiKEVXLwYWUndovXN0mE5cdXztDziT1u0+DexuQ6pWO6PP+L0vsDLe7H77x/pjJTk9r8A93jL6hOaLoPVZCX/f/ph/gzaZrP+n4/btAa0ylyP+utGUWWI9ml92ZpPwwbA8U5iTwg2Kc4GG3dibZO8Tzc4ODCLM2wZP4JyYuejusWxcYnpXdhbztegq7zAxO7N1QEs8+rZ6OMHbTYaZ7TcFWOrRp9L9o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3lDTS8wWWppOVZyVkJKcVpIU3RES0Z4QkxDRWFmUy8rYzc5WUoweGNKekgw?=
 =?utf-8?B?QkpDak1XS0sxMDBYZmtPS2NaQllHZnVRbjJtUmxNeGRZZHh3VnFjTUF1UzJO?=
 =?utf-8?B?RjZvbU4waC84VG5mVTlMUnA4U3g1OGNOQldhNlB2TG9YL0Rpb0NNSmZCa1Jl?=
 =?utf-8?B?VmlWS1dlRGN4SGdGa2FIeGVSTmFWaTFtdGFSSTBwZlUycHZGLytweU9jdnZ3?=
 =?utf-8?B?U3FNMnZuN2ZpVGpoV0d4ek1sZ28xNlFjajQzU2piVkNEd0NWai9Od0ljcDYw?=
 =?utf-8?B?NHpnWkJWRWFjY0Z4YVpPYnkyYk9SMnhjekhvd3RrMG54SkUzaFU4Zms1dERM?=
 =?utf-8?B?SmVKTDVLM3F3MnlJSUFrd3lxNnVWVUhrTVFTQloxSHg4Ym96TUExeEFUbzRw?=
 =?utf-8?B?YUhMdWJCdCt6RHYveHh5Q3dIbkhjUlFvd0ZMZ2JzcHk2QWhBMmFrSDJEemxz?=
 =?utf-8?B?di8wT0ZnSXIwdGNzcnNncGJzLzlmdzZKNVFYQkFKckxqYW13Q0Jpc3ltWi8x?=
 =?utf-8?B?QmtNNXJoNjJPbHZhbFpka3JrVWN5T3NkSDdFZ2U2Z1dUWm0vS0htd3VBb2lO?=
 =?utf-8?B?L3BTYlh1bXRpcHZtY2RtVkRreGtrQmcvWk40WXRhb2hnZEpYRFlPK3h0SHlS?=
 =?utf-8?B?MUVHUlNDRWV2VDNDRUZrbmZOTWt1S2MyYU93QzZZcnVVN2FUZ2hEWjE1NjdW?=
 =?utf-8?B?ZmYzcUUzQmRRRmRNU29vbisyV0dka2xoRGtlMHg4Z01rQjVqSkREWFJSQTRy?=
 =?utf-8?B?VnFXVFR1ZmtwWmVZeXpXd0xVSGFteWpSZVh6VmVVMVlrcnVja3VKcGhNTVQr?=
 =?utf-8?B?cVNCNkg4dmdMVVNDRUcxa2tRWDhpQ2xZVkxpV3BGVmZhVkY0L1ROZCtxenhF?=
 =?utf-8?B?ZU10RENqRG53Wjd4dnNRVVhGNDNJcU5saVd4b28xUFE0WG5jUENkOGozcFQ1?=
 =?utf-8?B?OHZRNWpVbHVpSUY4WXloU01GMGQ1MlZ3M0I3Y0tud1pOUzhRcUlXRDRHVkxS?=
 =?utf-8?B?T0JobE82MklTSkpUOGlvcXZUejc3cVhYSlA2TGJhZVBkOEZGazBhUlRSMlpj?=
 =?utf-8?B?eXd3MHUxeFYzWjBqbndpUzJvcFhPTUN1Q0pCZkpEbkxaZ09HemlEWitTQ2ZT?=
 =?utf-8?B?WkoyV2QzeUVUVnkyZVo0QTI5SUZFS2pGSDF2UEVTNzE4RDlMMXVkdTlGUm5Q?=
 =?utf-8?B?c2tNdWwwL2p3NkUvUW5NbGNkYW1hSFNuazVPaGtXL0VTRm1jTFZtcDZ6ZHZn?=
 =?utf-8?B?U3hnZmcrdnhXWllvOXgrQjdKNmgzUzd0WDFKOU4yMzRmMlZodDg1UFBvdzdS?=
 =?utf-8?B?emRhb0phSXdOYzM0aVNYdG9JRG1xV2VYaklXZXhCK0VhNzcyTFRzdmdBQkNn?=
 =?utf-8?B?YWdtTE5GdEd2d0tHZkY1RWpMTkVPWW93NDZ1RVp1UGlWME9TclJnNm1QOWRr?=
 =?utf-8?B?NmlVOHUwdzZpemVMZXd2ckRVRXVFSC9vYmc5N2lxdUlEdFFJaVg5VFV1MFlz?=
 =?utf-8?B?dzY3eDlSdUJsSGs5Yjlobmh4eXhRTlFzdDRCUjd5MGp5Kzk0QjlrUEwwRGp3?=
 =?utf-8?B?SG1WT29TMjFQS2UwMVBZZnIzSlpDWHJvR3puckJBWGlNMm1GbTk2N0Zsckd1?=
 =?utf-8?B?cTBOMDJJQWtrTm0wVjRRTVIwSDR5Y1JxV01pQng5RmlXWkJwaEc0MXVJaWJo?=
 =?utf-8?B?TWRZNFFRNXZydnAzNllzMW5QM2hmZmdTai9jeWN4elcxTVpTcnBqZENTY3ND?=
 =?utf-8?B?NGhxa1ZjOUpwTmIvMVdJSzdqaXUvaW5XZU9yRGRJejBqVy9XZmNXUEVMNGlx?=
 =?utf-8?B?RVlDK0MvMDRJZm1XRDdEdkd3akZ5WmVMaG9wYUU1elpSUjMyL0JsUnR3Z1dO?=
 =?utf-8?B?aThubFAyUFdRNlFMWm8vZmtQb1FuQzE3eGpVUEtjQUU0SmorNDl2K29OWWdP?=
 =?utf-8?B?Q1l0T0RJd3h6bjNQdXpjM1l5MFNyRnFmL3BiQ3hxR00xSSt4WVlkQ1ZYM3FY?=
 =?utf-8?B?TVNmTzhiY3k4bFY1RmVFM2lzVklVZVd5V3hkeTNyYnBNZFNMUzNVSXN5Tjd2?=
 =?utf-8?B?K2MvREpTYm1MQmVGZGVQRDJ0bjM4WERDSHkzNlNRYnRQeng3cjJCM0g2dzJB?=
 =?utf-8?B?OFExV29MQVNDNVhPa1FsMHlVUnRhNTlNdHVkbzE4aytUdnhrWVZmNGNTZ2Nj?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b15a9899-a2fe-4b10-23a3-08dc3e3ffd4f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 00:46:13.4957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMX65C4EYYCoXZ9RzOid52/gVgISbfNVN98t0l315suVFfgAR+dxPTeOXUHkOO95VAhiSUx32zs6y6Awpyzf3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6728
X-OriginatorOrg: intel.com



On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> WARN if __kvm_faultin_pfn() generates a "no slot" pfn, and gracefully
> handle the unexpected behavior instead of continuing on with dangerous
> state, e.g. tdp_mmu_map_handle_target_level() _only_ checks fault->slot,
> and so could install a bogus PFN into the guest.
> 
> The existing code is functionally ok, because kvm_faultin_pfn() pre-checks
> all of the cases that result in KVM_PFN_NOSLOT, but it is unnecessarily
> unsafe as it relies on __gfn_to_pfn_memslot() getting the _exact_ same
> memslot, i.e. not a re-retrieved pointer with KVM_MEMSLOT_INVALID set.
> And checking only fault->slot would fall apart if KVM ever added a flag or
> condition that forced emulation, similar to how KVM handles writes to
> read-only memslots.
> 
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 43f24a74571a..cedacb1b89c5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4468,7 +4468,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   	if (unlikely(is_error_pfn(fault->pfn)))
>   		return kvm_handle_error_pfn(vcpu, fault);
>   
> -	if (WARN_ON_ONCE(!fault->slot))
> +	if (WARN_ON_ONCE(!fault->slot || is_noslot_pfn(fault->pfn)))
>   		return kvm_handle_noslot_fault(vcpu, fault, access);
>   
>   	/*

Reviewed-by: Kai Huang <kai.huang@intel.com>

