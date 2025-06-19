Return-Path: <kvm+bounces-50000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD32AE0FD3
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 00:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DE453BEEA6
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 22:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6939828D8F3;
	Thu, 19 Jun 2025 22:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ELI0XwHl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC11325FA13;
	Thu, 19 Jun 2025 22:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750373881; cv=fail; b=VBRktlCohXuiMXzIfYhMCVhhnuDDKwX0IyOhpXJvwVhV/zs6PaLMjQ/KbJnXQDFQ5MJPlyPF7YmB8F70fghTyt9+LpICdd2uLss2CvObVTZGNC2Rda8MxRLiCp1+W+fch2rYIwYs+gSdbajp8nPwtcQrLUKv3wQpZyJX0ZTQNo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750373881; c=relaxed/simple;
	bh=fGxvR4qrNSqMmeEtdEy6j6+DbByyy7/RUhKt9GTiWV4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GQ9GDd0WxPk8tDhcI/wNeL+DF9IWxn5PhNMZCT7ts4syGu//rt3RCcyg+iCnN3RyL3oDSWs0oGbqfIHj+ZLtWi95XS3m6MJTWlgV7/GA50MBr45ElYEpzQ4bJ9Y97VCq+dmI5N38o5KA8CCZB8KZhq5vt0YancDaUGlcrm+wgXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ELI0XwHl; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750373878; x=1781909878;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fGxvR4qrNSqMmeEtdEy6j6+DbByyy7/RUhKt9GTiWV4=;
  b=ELI0XwHlyI4J0dGfCJr/yyYQH3KpQN4CwE1wlqWBa1pS45vMFzPsSzfC
   h1DRRZS/8T2rqk9GpYDFBJGezGGOmhLF0+d20Hzix+OWLVVURsOla/7Th
   aE6PKxdyq9JojPcKOy5AYDsDjmdz/4KyR0vfbQUcOAR7vaJE0fdfL8cAh
   yLrj4SI7hXm/nIUXdcsEvGVhzzCR5JgQkhEhlU3qdyT21a43f6ODqCqnI
   a5FlXYkyoydxVAzIWusLNJzsywL6G3wn3IwpZRfWfqw5jlLXNj5VOPsDK
   aMpvC1Dp+bzNhH2tkq5qHemUqLsc0e6xudO+vi+Trk7PkZsHs+ziPYUy1
   Q==;
X-CSE-ConnectionGUID: lygcPwgiR7KZjT28ayWElA==
X-CSE-MsgGUID: xsjxQMvARgishbrlztD+nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="70195662"
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="70195662"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 15:57:57 -0700
X-CSE-ConnectionGUID: NxuCGcV0QTqIg2ayK2Al7A==
X-CSE-MsgGUID: mkjcr8PwTeK3JWJjVr2omw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="150957895"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 15:57:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 15:57:58 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 19 Jun 2025 15:57:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.56)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 15:57:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WUXuIROUuIye9rerAxZs3ndEu4U2VXTBwz9ECPuS90A27Nb61C2BI5VPwaOgisSnOXCEDlg8Q9xic+1dss5NSrq8RsgMEz69HoVpvzMfqIHPOhIx/bLfOZhpjgbFDId8S49EhxDXh/DKkBQgDBeZXpByP53qXIGCAiXYgXzek8XEDpXzh1Ru6k1NeAS50vhBXoIVNiHK47cnAiAWQfC/6QIWuxjErG7TNcaZT6zjoGb4reSlkfs+yeoHOUAvWHd7ghwYppsBB4Bs972I5yjBvm/fagWznbCpyY03g4856h+LJ8S0Zi+ktjnpMxZ91KcIOQQKYeYI+rmwqK/CssbDVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DiBCHcBuIdCk5o9Zt1FSRAQb/3UjRbaIAw4F4a31s4=;
 b=IPDU84S7aXtzNaOqvKsrhsGN0vnZkfJca78GHMPvQ1ZGQJDu9673fdvS6YnSDVtcbKNTscfnv8peVnO95vKZg17gGKUUMfdBEdrg/0MEfP3y27lQ+zJx1J/t82zkbIrFRorbgmv/xrjsMt7V9uttwwDJeIr30wD1rTjOKL/O2NqhpjOw6UxXzjx7mndwkpzUWXvm7Af0dpRwVzPVy16hGROVD8bNy07mQtoedvwHQkijszkBwzLUnE7JRlbI4RaGF5VsXVIi1/igY2Yhy+I85Z+1NUntBiS4BURFGf1PBv0lIAnLdnZhUh9YLnqnSG3pgbwUa+pAwUzjXiLzELuXug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3322.namprd11.prod.outlook.com (2603:10b6:5:55::19) by
 IA3PR11MB9327.namprd11.prod.outlook.com (2603:10b6:208:57a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.22; Thu, 19 Jun
 2025 22:57:55 +0000
Received: from DM6PR11MB3322.namprd11.prod.outlook.com
 ([fe80::fca4:6188:1cda:9c1e]) by DM6PR11MB3322.namprd11.prod.outlook.com
 ([fe80::fca4:6188:1cda:9c1e%4]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 22:57:54 +0000
Message-ID: <39987c98-1f63-4a47-b15e-8c78f632da4e@intel.com>
Date: Thu, 19 Jun 2025 15:57:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point
 from KVM
Content-Language: en-US
To: Xin Li <xin@zytor.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson
	<seanjc@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Kan Liang
	<kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Zhang Rui
	<rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-3-sohil.mehta@intel.com>
 <7525af7f-a817-47d5-91f7-d7702380c85f@zytor.com>
 <3281866f-2593-464d-a77e-5893b5e7014f@intel.com>
 <36374100-0587-47f1-9319-6333f6dfe4db@zytor.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <36374100-0587-47f1-9319-6333f6dfe4db@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0107.namprd04.prod.outlook.com
 (2603:10b6:303:83::22) To DM6PR11MB3322.namprd11.prod.outlook.com
 (2603:10b6:5:55::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3322:EE_|IA3PR11MB9327:EE_
X-MS-Office365-Filtering-Correlation-Id: f57db732-7453-40ce-5046-08ddaf84b9f1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V2ZtTWpNTGRpN3ZDY2IrQ0dtNzNIYUdXN0RselZGL1E3LytCdE9qekNmS0ZQ?=
 =?utf-8?B?Nnpuc0tCZEhIYktmbWpKUnduNDV3WmRiK0VQbytUanJ3MUtGRm5NVEtaKzRO?=
 =?utf-8?B?Tmx4WURnZkUxZnZTUmp5NFVwMmk0K1J1VWgyV1ZuSmdUby9ITURaZzlrZlVR?=
 =?utf-8?B?ancyVjhCaWZWNlpBa3hFQXU3emtLaFFsWWFDeXZMZHhPS25pQWlVQkxIdDJk?=
 =?utf-8?B?Qk85V2R6ZVd3a1UrZlQ3M2JjVW5QaHIxb0wwVjR3V1NDTGZESFRDb0tQNklU?=
 =?utf-8?B?VGYzcGU3eUM1OGR3TnlHUkwvZ1dXL1pDQlZaeTZnWVNDcjB5c09qSFE0eFhQ?=
 =?utf-8?B?ZzkrcEFoZUFveGNhWFQvTmVJYUMxL1N1TTVjTnBTS3Z2K3dSdU5wOHo0Vy93?=
 =?utf-8?B?NlBZTVZ4Nko2bDQwVU1ScFlyN1QzTDFOdlBNaWxqbHVJN25RNlFjdnZwWnZa?=
 =?utf-8?B?QVcvQk9aUHp4RG13cXBGcUp2UEpYVHZia1BBMlp6VjA4WCtQVFJwcVpPK2dR?=
 =?utf-8?B?Ry95NkIxQ2dlOEFSaG4wd3VCZ2htOTBwb0QzcDFHUTRQaktWN0FWTWdqNlhl?=
 =?utf-8?B?N2tsTysyT2dHckd2ZGoyejNuWEUremRJT2NqdCsxYkx0Ri9ScXpPZ1gxa2xJ?=
 =?utf-8?B?a0h0WUhHMktSaGc3WHlpZ3F2YWpOaG1MZEFmUEZ0OXlDZWZ5L2w2cE84YnBQ?=
 =?utf-8?B?N090RlFZcGh1Zk5kZFBkT2liNG0wR1M0NWlSaDhxV011MWNoYWg5RG9ZazBS?=
 =?utf-8?B?eFN6dlVlVDhEZXhES0hmMGNHSnRxWTlxN2g3K2FCYUFNUWxMU2tVQmRPRjRI?=
 =?utf-8?B?UHFlaWQrYmlQaldvaG1XWTFHWFloN0hEOTVYTGNObG1iM1NiY3VZYUpEUGI2?=
 =?utf-8?B?TitiamxnT043MmVMelV6ZmxKSG5uSVUwSUljbWZzUEQvOXkrMDhBZnpySDl2?=
 =?utf-8?B?QmxETzdJK1pJUWVLZm1lS3JTZzRmcmtvQVBidnB3TThJWTFMTiszSGFuZHRl?=
 =?utf-8?B?WlVuNm1PV3N5eStIWHczdkZINVJuOEtSRGE0aE14Ynl1NTI4Z2NTUFA0dlQv?=
 =?utf-8?B?Y0lYYzFhd3MzYmZycHVScytNSFF4RHhQQjIrQnIyVVhjV2VYMENjTVNFQWJV?=
 =?utf-8?B?UXV0SDZLUGplZ21UbGRJN0JiVHByajU0dytsUjVyOVUvK2JWOVlKNiszeE5v?=
 =?utf-8?B?VzBhZlBuNlJMRFBVV0JqamJDNmpPL1JSbUFyWStyLzJiY3JBeTIyTW92ZU51?=
 =?utf-8?B?SlArb1EwanM3aW9jaTFwQ1BoV0h0bHFmNFB0ZER4NzNreDQ1RlBia09zNHB1?=
 =?utf-8?B?cHFoejRwWk1XODVJT09CSzhyelg5M0F4c0Z6b2RLUFdDQjhBRFN5ZGxpQkJH?=
 =?utf-8?B?T2JVTlcza3dTblhSZDVxb1pOWFFzVXc0Unc0Qkl5QVN4WTM5OFVhbGdpL0s3?=
 =?utf-8?B?bVUyQTMvd1IxQmJqclFHVUtiV1ZtYlk2Q2xVRUc0UU5EdW9PK0owa2dwbW5Y?=
 =?utf-8?B?VkUxL29hT3pjSlpDZGJ0Rld3dDBWMmgwb2Z6Z09ya3dYMEVMZ1FxRUNUZS84?=
 =?utf-8?B?U3YwdUdVbnQ3M1RUOUUrOUtEUHN2ZVdQclBtdXJOMjFoVVVhcGZNTS9CZ1F2?=
 =?utf-8?B?NkwzdHBlb3RKd04zVGRqenRUblJ2THVucW1Ob25sbTFRRkJOVDB1OVdCRVcz?=
 =?utf-8?B?K0VrZGlnQkJVcmt4OGFEVGs1QTEwcGJPcDQwVVBtM0svN2tCOXFYa1RGUGRt?=
 =?utf-8?B?c1BiN3pwWUpCM25ySWs2dmZROXU4QndPWWZud1RRekFXNnQ0Y1R1SHo4MENC?=
 =?utf-8?B?ckFoZnBiQWRyckV1MlVCZG9WMFlqNTdPZXE2QUw5WUt3NVZDVjlEdHl3UGt1?=
 =?utf-8?B?NTNCN3FOVW52b28xdjl6QWk4V2ZncVZIUWRvd3RZbDJGSlE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3322.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDhUVkxnYTZ1ZDZxNDhycDRSODhuQVl0c3VkcjVzd3JPOGdMSnJtSmZDNzNP?=
 =?utf-8?B?d2E3TFRkdEhJSTBUYnE2akVVRTQzdS9GbDY4YlFkWDRkZlgveWp2bnpiREo3?=
 =?utf-8?B?MzN0RnMybzZyMWhzSGN3TmhYTWlndjMvMGtOUDR2UnFCQURHTGs5UWJHNFBS?=
 =?utf-8?B?VjhGZ01ReEhTQzd1SlNTUnQvd0FPV1ZZdmRTQ1lrYVdTUmJCSU9IaXNtS3c2?=
 =?utf-8?B?aFpseFdiN0U2YVduQnppSWl3NTFlT2RMaGsxRGJYNTRvUy95UDU1WktEK3lM?=
 =?utf-8?B?TTV2dFB5RkJQUEpYVkkyV2VybUJOWVFWMW13OGpQK2FPV2RaeEZOQWY0d2Ir?=
 =?utf-8?B?WkM5RVVoSnprcXJSc3poZW91ZVdsSEZUV3dSZ3NrOXMwYVo4bkhRNUxSbk9R?=
 =?utf-8?B?eG5uRXFJQ2xiZ0t0dnJNTUxsQS8wdTFob3YvSjVwcTlsSTZFV0hVOGlNc1ZL?=
 =?utf-8?B?VmRmMnVGc0FnYXppRHByV2VkMzNSUVU4S1ZvUmhMcStQbGZ3bzcwM3FicVoy?=
 =?utf-8?B?VHpzOWFtK3dscE82aCtwdzEzTWpuUHdmWTkzTVo5RnRieHlBeFNIZHppNlRn?=
 =?utf-8?B?Q0hwOElCMHdWZ005UE5YWm1DQWVZQjdWT01JVGtsZE1SZkIzRjJYaE81aDhu?=
 =?utf-8?B?ZXBQSjdmNk5Ib0xnNlF1RTlCTitpOS9ScTNpZDlQY29xMXhyaHM3STFNb1hw?=
 =?utf-8?B?OW9MNmdxWUtWRENiMkszUVY5dlo3bE1teEQxaXErVk56OGdkVFltdmlqTFZB?=
 =?utf-8?B?QmRwV2pkUmhYOUVHK01hdHY1WTVLUlg1QlNtQnZ4c25JdFl1WllNcmdOOEhL?=
 =?utf-8?B?YURGU1U2aEFYZWpHc3lpR0MxemxFSkRORVlSMmdsUWl6WVNvRG5UWFJNZ1Vr?=
 =?utf-8?B?YUJZTHRMVXJKUk1kN0RHcW9malZqQndrdlJITUlpaVlFdUxsOUdHdllIUnNV?=
 =?utf-8?B?aVNIcmYzTis3Vy9EaHRHUFZ3NE15WFBNQlpjdlJWZjc3dGQvYk4xd2VJNUhj?=
 =?utf-8?B?dkZrY2k1ZGhCcHg3Zm5lb2V0aktiMjYrVC91Wkpvbk5pN2xjVjI0Slp6bXJS?=
 =?utf-8?B?TU8rWkNvdFhITFRzYjczSHNtMzdRSW1rclNuL0oybXpxV2RFMTZiYys3QnJZ?=
 =?utf-8?B?UnhGUzE0Nm55RG5OZmgrR0h5MjdmYXl3NnFTRThHUXdIYVUrd1VPN21nckxX?=
 =?utf-8?B?Zk1PeUVxa09DaE5HVVlwbDFDK2FOSlFCRWVTaVpzMnFmWUJsUmhXSlhZNzhU?=
 =?utf-8?B?bFh2QWUrd2FpRzdvQllvQWxPZTdDTWxwTmoyVVhvQTNQR2dUM1hQVXNYMFFX?=
 =?utf-8?B?L0FRWnBxZGI1Vlh4RTFmNEhFa01oVXBsV21LR2loN2M2YlhqY3lGZEV0TGF2?=
 =?utf-8?B?SW5rTXhKQ3pwWEU0TXZUYXFCZS9NYXY2QU1BMmlKUmFKRStzQTh1cTkxc2h1?=
 =?utf-8?B?eUtmOEJWL045WUp0eXB5R2hqZ1dCSlFXeWwyY1REcXo3T251YXpSTmtnWFZj?=
 =?utf-8?B?S3BDb0JjdTdnRVByL3V5T1VUcTZtaW9HQVUzTWw5a21Ja3FaSG1TQnBuaXBW?=
 =?utf-8?B?UlJuTERLU2xJZUdJdUk4TWxOcWVNRCtJUUxKa3VXcFBWMDlhOGdwQ1NVUTkv?=
 =?utf-8?B?L0pscmhENmFjSE1USmJyQzdVNDFaNzRMTHIzaTduU2NFZ05hYkY2eDYybzdT?=
 =?utf-8?B?ZmFZMXB6ZzVCQmxqcit0OVkvZ2xjaW1Sa3lKeEdMN041OWZudmRVSUV6aFU1?=
 =?utf-8?B?TlQ1T1ZrWjN2cGhuVHpaeVdnclpNa3dPYlNkdUhZZlVyZGdZWFF6RWN1VFdz?=
 =?utf-8?B?YitoTzZHOEEraGNIVStBNWJmVXFaQkdWWW8wOGVEYVFja0oxRHNOTHI1Y0RL?=
 =?utf-8?B?NE5jU3YvT0dyQ2NSVjVXVWtVMmFLb2VkaWpTN3JoeUFaSjBSWUtoRWhvNUcz?=
 =?utf-8?B?Y3pWbnB4SzdCV0VFd3E4UXRyOUk5NUZHeTd3bUZFellHRUovUzBSdWEzd0F0?=
 =?utf-8?B?RXVCekxOZlZCQ2IzVzRQMnNkdzAybmd4QW1rQXdkV1FwUW45MzdFK0NQWXgy?=
 =?utf-8?B?Z2pxd1dBZmZseW04U0pVek91QUZZMnpTdFBuQmYvcnA2Tms5M3FKaDBkanJ0?=
 =?utf-8?Q?wEF4eYNjHChdoenTIRL81QxUV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f57db732-7453-40ce-5046-08ddaf84b9f1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3322.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 22:57:54.8339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: waAcaFxk6wGPUJWMWfWIFL3iHD0Zwwg+9ICdTrSDLNthFZO8F2VRgONfPnbieiG0SArY2tzy6MzNQLHX38b/1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9327
X-OriginatorOrg: intel.com

On 6/19/2025 3:45 PM, Xin Li wrote:
> On 6/19/2025 3:15 PM, Sohil Mehta wrote:
>>
>> I want to say that the event data for IRQ has to be zero until the
>> architecture changes — Similar to the /* Reserved, must be 0 */ comment
>> in asm_fred_entry_from_kvm().
>>
> 
> FRED spec says:
> 
> For any other event, the event data are not currently defined and will 
> be zero until they are.
> 
> So "Event data not defined for IRQ thus 0."

I am fine with this. Not *defined* removes the ambiguity.


