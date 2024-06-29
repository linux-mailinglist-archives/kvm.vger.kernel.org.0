Return-Path: <kvm+bounces-20714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBEE91C9B9
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 02:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59B59284762
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F7064C;
	Sat, 29 Jun 2024 00:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kQeq6dXa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462C918E;
	Sat, 29 Jun 2024 00:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719619854; cv=fail; b=Zs+nAUmZfF0faxA7+jTZptuMyJ/u+3MsseCVGB69x/iuDj1Jaf73LmgznkyoyDv9P85xTzDT1I1DT5Zm7+HsRWEj/401zPsPqL9TajQKj7UGaahO027g1/G4ztaiU3874rMtw4QgRwnYEB5waR9/t0cYDosaT2OdMm35ou4T4ZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719619854; c=relaxed/simple;
	bh=0e/yOucR/ziuZZjNoOCFDJ6m/AUrjkPY/UFCPHJd9/I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VbRiYoY+zGwWSva49y7d7arzQDJy9LzyND4NZT6T2ohOVvsxE6+Rd3ELW9yqZQraJtWL2zAfgE0KozaDYWbaOmJ34Pno5rH8o9Sexb4OQ421MTxUpTuBPfszK1RHjt8Bp/Lp5iT96UJ4VG5JA8jKvUDlEgTr6SNK1dkRd813XW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kQeq6dXa; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719619853; x=1751155853;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0e/yOucR/ziuZZjNoOCFDJ6m/AUrjkPY/UFCPHJd9/I=;
  b=kQeq6dXaV3pxSjBlo8VuuhLWomJ6QJhznNLXARK3vAGuJFQVVy88MOWl
   VPvPwsrXJ5m7zXC3io1lvXJjlEsx620gFBiBZe8uQkKym0jlYjL52qiIX
   zgxbQJcsfMmUDGQ3prHXjOdZMorpJtUqaRTJcV3tKCBj3N1DvuNM84fgZ
   G1/3y5OGEmEceZiWMEhzuOvn0j6YmxKDW7Lsg+z+IGtX/X6fCozYi8Qhd
   9AGES6ZYUGD9RYeasq/FbEMeR4ckKeHV9kzzWY8q8Q5fRdCNKExLH6CBI
   +rnYMsMELw1O+5D16vSagnphy27DMHbMaVxvvBrgaB7LByrPAWPfRXBvY
   g==;
X-CSE-ConnectionGUID: QGW+1807Shmyc5S4MiJCGQ==
X-CSE-MsgGUID: Y6OPipwUTlmlT7J1PsMP1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="20636013"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="20636013"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 17:10:52 -0700
X-CSE-ConnectionGUID: tiXu56wZRy6DlSbZeaC2UA==
X-CSE-MsgGUID: nHH1vCPMQnyNpGcnaLxafQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="44964670"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 17:10:52 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 17:10:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 17:10:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 17:10:51 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 17:10:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rl1aBCjAETH0e1OkCgWmQzyC+TeKFrTL50plrB09JciJbrYrXiv0vRzM7Sdoee4m/1sHR9iMK7URvCLU3XJ/c8+JYfgZl9BMiSETXCouNV5bIuKAjyP4/Xk7BJ4LaYcFI2EZJRzE9lR58pUO6MrhhQog8K30mDnv0sumq1HE62f2tIpLgMY2BBiVgsyxmOjOMEWmUy1xLMzUkf3A+/9eBgAjs3UKEKEP93kJvY8Q4YPBTOtsNoEV8laJXARjKbpifxuuM/1LyZ1y9VfFVbX3wqwQNI6U3fawhz0V34avQ+SdQHWhs8NxZsduUzzwPmAYCBj8R9EHGpM1XbfvBTHRRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsU7KOvRwlxYNB6Ss0Ad54tB0NejBImwCq2UDGLkkdM=;
 b=D9ebJinbMB3YGlbyMdwXsVcod2yoJE0MoBgpaJrjk6eB5ecCNWaDCZp1cnU6G2wGNb1mgo1kHCe+m6i4TjLJNpopMfuNumrxM6N8faMfZzYdhbfpaVGKiujrrx/1i/h1uMXrHXEtn8/fQVKz+VKEV2X2MuX2wlBpW5melEnsJ5iB6e8gB4rELLF2R/xczhS2IkNeUvkn1mO7nPTb+41AD0oS9LrfiUJTClRocPNiJip5lwoxruFMC+HFXi61WluFxqAHhz8xfwPbo0sKoVpk6hbTfNSl5sGwZ8OtnWLCO9ecykjioRio5Az8d3MahGT9tjJvZ7je1gIi0xhFI6kvOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6781.namprd11.prod.outlook.com (2603:10b6:806:25d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Sat, 29 Jun
 2024 00:10:48 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.033; Sat, 29 Jun 2024
 00:10:48 +0000
Message-ID: <5354a7ae-ca32-42fe-9231-a0d955bc8675@intel.com>
Date: Fri, 28 Jun 2024 17:10:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 0/2] KVM: x86: Make bus clock frequency for vAPIC timer
 configurable
To: Sean Christopherson <seanjc@google.com>, <isaku.yamahata@intel.com>,
	<pbonzini@redhat.com>, <erdemaktas@google.com>, <vkuznets@redhat.com>,
	<vannapurve@google.com>, <jmattson@google.com>, <mlevitsk@redhat.com>,
	<xiaoyao.li@intel.com>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<yuan.yao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1718214999.git.reinette.chatre@intel.com>
 <171961507216.241377.3829798983563243860.b4-ty@google.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <171961507216.241377.3829798983563243860.b4-ty@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0223.namprd04.prod.outlook.com
 (2603:10b6:303:87::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6781:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d34b1e2-b5f6-45c3-81f6-08dc97cfedac
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eWd4dE9LY3ljWDhJYW1oeUxtaUh3aytDOUlFMUp1eGFwWHorcVhaRkM1RVJq?=
 =?utf-8?B?NEN2Q3AvdUp3YXV6WGZUTDNoaVVvazl2MHB6em5iS1YwNG1sZTFlZVRKT1Fx?=
 =?utf-8?B?cHpvYWRpWEY1anZuVFFCVmdyRWZWbnJoV2J5eXgwQWQ2SFNEK1Z3ZGpyQTBy?=
 =?utf-8?B?RzV3RzZrQjVMV3dpK2NLT0VrV0FaVUdwQmNLcXIyWC9YTmUxcWdsSzhwZ01T?=
 =?utf-8?B?bFJ2STJwL3drRkRUNXY5czl5R3R5anJsOHBKMnJGUE9PK3BoVVkrNTgzUEI1?=
 =?utf-8?B?T2l4M3VXN3oxUlhoL1l1VlN0NlNoTzlGVE1iQ1MvNzNjQ0FGOWVVNEFWYWZq?=
 =?utf-8?B?YmdhVFZHdTBCZGhkVVJ6RTBFS0VxZ3I3WFRoU1grN0ZsZUVVQ2F5cTlMbUhP?=
 =?utf-8?B?d0xOQ20weU5icEd3QlVESEdPUkdkSWVISUtVSXByNGN3MG92RUFCMnpieWpi?=
 =?utf-8?B?ZzhnZmhoTHA0dTM2MCswb3E3Mlk4MVIwZmZGM2tKRllHVXJaWXRwZExueHlF?=
 =?utf-8?B?UFBZNSthd004dVV1VXpRVGFjOHJWWUhWUDBWTWE1ZW9nUWRpL05GRlB0TUhp?=
 =?utf-8?B?QmRLV08zKzcxcVhGU0hobldJZktiM1pncWdqT1pmbGNRZy9yMkJDT2JlOFNs?=
 =?utf-8?B?TmhDdlQ0WTYyc0FjUUFINEZuVFZrYjJabTFYT040eUYwZi90aGpZenUzOHpw?=
 =?utf-8?B?dzAwR0pkOXQwdVA4QzFvbC9vM1BETjMwT2hDKytpYmR0TzlHRHZxQWVXWHhq?=
 =?utf-8?B?TW13cFV1MHJYVGViVmY1aWpKWk5EaTRBMmoyd0NEUzVVaFBOaVVFQld3RFJU?=
 =?utf-8?B?WDB3Tjh6KzBScmloa3hqSkN1TnNxVXRCSHRMb3cwV1BxcXhLQ2JFUDRMK0Y2?=
 =?utf-8?B?Y0tpS3lSdFRUZkZrVDZBWldVRnp4RDNoZHFzQXVQWE1NMTFpZ1NHMFdnU2Zs?=
 =?utf-8?B?ZDBkbnc3eUFVVmZaUzRsVXFxZGZXRVhXRi9CcWdIdzR5N2V5NFljVVNKOG81?=
 =?utf-8?B?cUdIWGVZN2VrOS8rdnVUVTBacFV2clN2UEJUWWpmb0M0VElUSlVxUVNHMjZw?=
 =?utf-8?B?dE1YYk42V0s1NTJjMExuallPVnB3VU1nWlpST2NQVk1QMmVET3g2UTVnQUF2?=
 =?utf-8?B?dWVUb0M5OEZJdDc1R0Q3NC90ajRDTytYNFZQTk1GeFFFdm5IYVJYSGNqNnUz?=
 =?utf-8?B?SlZadUNiMXZFenBYRXEvOGhmL2dTUXhQRFhycjlHVnNNeUN3amNmUVNhWjgx?=
 =?utf-8?B?cHBzK3lLakNwc0tWTFltZnIwT0dwbWJscTNqUEVjNDJrSzhoSHNRSkFZNk1F?=
 =?utf-8?B?azlndC9IcnJZVVlNRjlGakN2MDZyR0NsKzVOQ3BCbDJrVjM0eitFaW8vZURC?=
 =?utf-8?B?SDUxNzJUcnhGMEE0U3JSejBxTEozYnhwV3lydWNQUmQ5R3ZPWmNGRlVGUVg1?=
 =?utf-8?B?Mzd0bEx4bDUvcE0yTmRmR2YwdTFqQm5lcHRxenFNN1NKejdrUmdvMWNXbldu?=
 =?utf-8?B?SXJrNWc4Z3A4M3h5Z1d4SDN2a2hkU2xDWUZlOTU0VnQzcnFpZ0x1NlRiRjVD?=
 =?utf-8?B?Sks1dmtRRzZVWlBHeUlJMm1SbDBreFRkT1dNRVBDZE9UUk9RNFJNMnNmQlV0?=
 =?utf-8?B?LytJRTVuTFVSNnZtb0NLRVh6TExrTmphM2VCY1d5SjlQd3d0MjRiZVRlY3VR?=
 =?utf-8?B?bHdUUWNaRERxdGRrQ3M4Z1daVTQvVWZsb1RldVc4Z21seVJ6V3VUdlh2UmdE?=
 =?utf-8?B?ZGpLbzlXM2JJdTNjTWZUM2h1M1RZZGRsK2RPRkwzVFh5RHR3Ymdlem9mTHpk?=
 =?utf-8?B?MUJHQ3h1RXo3cHVoY09NUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzhjWkMySXozUzdndmhqUklWRGlBSGkxRDNoQ1h6aFBhQ08rUUdyd3ViNHdj?=
 =?utf-8?B?dHZkVzFaNk1JelJzeGkyWHM4OG5PZkhMaldOVUs4azlROXVJQ0dTUEQ5azJs?=
 =?utf-8?B?WHB4QW13Y1ErWGk4TjNvQXV0SlJlVEhXUVlTRnFNSVE5MXgrd0tLc0R3K1pP?=
 =?utf-8?B?YnNPM0xQUzBQZXMzakJjRnNCRHBwcmFIeXlDSUp2YjR2cXowVkhKKy9MbGN6?=
 =?utf-8?B?WnF5VWJiZ0NJQzdrVUlleEJnZWFaaTI1Q0s5bmMwdWZkTFgrbGpJNTNVWG5M?=
 =?utf-8?B?MHVCcjBxUU02NkpiWjhXYUNDdmF0akNGN3p1czMyM3g0a3ZoSnlrdHRvZmRI?=
 =?utf-8?B?eEhaK3c0YzlISkJOcDN6MUV3MWFTL3BobjlKSktnZ01JNERkWml3RFE0aGg4?=
 =?utf-8?B?VXJSTmtsV0ZhOXFvV1VkQ0RBb3B2YU9OY3V2SjhneXMzazlnVitQOUx1V1N3?=
 =?utf-8?B?MkFFWWhjckhVb0Y2UlFSSlhYaWVBQ0doMkhIbHRVZkF6QVM5MXBYME5GUnFq?=
 =?utf-8?B?SENTVUlyTHFxMW14eXZQZlJFcHhmN1h6ZUU5bFJNU2ZGclhsRWNNMWFlcEhV?=
 =?utf-8?B?ZnFBcGNnZUp1WDJjT2t5Nk1BaC9CYnZtbStIZVBpQmdiUWVLS3ZaZkpJOHh1?=
 =?utf-8?B?VjFpcDZCL3VocFh6ZUp4U1owWXpJcFEwTVhVVURIZDZENURYRTliUnBidCts?=
 =?utf-8?B?azFFais3ZmZ4ZkNaTUI1eGx4S3AxZ2pnOVRRN3NPSnlaOVpmdm9GY3dNQVEv?=
 =?utf-8?B?bHRSR1Q0WmJZanRpdW9tK3BBeXBxWXdibEU0alF6QS8yVWJ4enRSUUpYd0lw?=
 =?utf-8?B?aThpNmVublBQZmpwT2g2dFM0VzcwVTFGZXpMVUl0eVRvNkhVUWxxN3luNWFR?=
 =?utf-8?B?NHlTd1cwZTZpSUdadjZsc20rSEg1MjdzU1FRcVFOM3hrVS9QVTVTYzdySjBB?=
 =?utf-8?B?WndGU2hLek03UzJTNjNjZnc4TWxnZ0ZTVEh5Q1M0U1JtY05YeHU5TDBzUEtq?=
 =?utf-8?B?b1Iya3hOanlwVEhnTVZ5SVdYenVucHNDOStlUCtnWFBTQ2xhZHNsVy8zWUJR?=
 =?utf-8?B?NXVJQzdUQ25ta0kydXlRRXJhakZic0c1eGt1UmVQS2NXN213dmJVVGJPSndG?=
 =?utf-8?B?YU50Ti9peFE3Vmo0RWJEMlhGaDhCOFJtZ05Tb0JRMnNUT0hrV2JQVmt5Uy9H?=
 =?utf-8?B?MkFYZHJWWHdST1JSQ1ZkQVQvaWlRU01Yd2JuaWhFTmJLaTV5N3p6NzNGN01S?=
 =?utf-8?B?UGM0QzFqWENQRmx6YnYyTndRZjRrVkJtS3dtanE5RnRaVFN2WjZxQnBSL1gz?=
 =?utf-8?B?cmErZEIrY09EbFkrZ2J5eWxaWTg3SWU2WktUNk9ia3owSGtscVJDb2FJYUJr?=
 =?utf-8?B?MmlzeVZaK3NEaTA4WjkxcS9LODRzTGl0OTg1MUVmV29DYnVYbzdZbW16STJx?=
 =?utf-8?B?WDJ6QWVCaGdkMEd3bXpaS09KTWNncFpJcGRIYzQ4ZWJneElUSUluenFDWEg0?=
 =?utf-8?B?dFpRVUNvVHRSZXRJSGZiUHEvQ1JrekJtVnFsMEFTaTVpR1htSFl4Uzd0OEpK?=
 =?utf-8?B?ZWI3WkgraVIzOGlRNVNzTzc0emFRbXI1YmtrMHY1RDRmQUFTK1A5SUNPV0VW?=
 =?utf-8?B?ZjRzZkVZbjVnUVlyZUtHSFhFUVlsRmliTGRBM1pYRTJCS2FaV3QwOGxjNG5S?=
 =?utf-8?B?bVgzU3UvY29lY1dOTUkyZXN2VnlaOGRCRW1XbURhNTVPNzFVR2ozRFc0OWxw?=
 =?utf-8?B?anVDNW1vbVFESEUxbG1Nb1NFUmswNHhqOVdsb28zTWNtUDhUcmE5Si9EbThI?=
 =?utf-8?B?OFZRUmo2UFB3emZyWDZQVUtnNUY2THMxVVd2VVZSQWtvRlhiNlhvb0JJajNS?=
 =?utf-8?B?Y09aV2JLMWd3V3pRbzAyZmoxeXZGOXg1cHFrQmR4QTloZkRoQjAxaXRzTGVN?=
 =?utf-8?B?T3g0OG9UQjR5NkV0UEpUQmpwdlNDaFkzWll1OVRYeE1HN3d3Zll5eVE5dk5C?=
 =?utf-8?B?Z2JUUXdRaENTdmN0elZnMTYwYlZFQzFPcGJWbTFEOVNFWEhPVUJZUEROV3hM?=
 =?utf-8?B?WlpCMWkwVDM5eHlObVBlTEtzV01HMEZXRjBRYlRPaWhOOVFrSDY2ZVNRTitY?=
 =?utf-8?B?elR1S0FEN3FaUnpzWXRRR2Z5ci84NnE1d2hrcitMQWIrcVJqNzgrWkdHTHBG?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d34b1e2-b5f6-45c3-81f6-08dc97cfedac
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2024 00:10:48.2665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NLuNvi+nVFZMin6PtZhqe+fznHoNx/F9Bd+0paxiysCqMpYDOel2ODlkKzDthFwZFRFP48tbmID8fY4SsMRPk+fbNDKlruQqHnDJBeDcTo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6781
X-OriginatorOrg: intel.com

Hi Sean,

On 6/28/24 3:55 PM, Sean Christopherson wrote:
> On Wed, 12 Jun 2024 11:16:10 -0700, Reinette Chatre wrote:
>> Changes from v8:
>> - v8: https://lore.kernel.org/lkml/cover.1718043121.git.reinette.chatre@intel.com/
>> - Many changes to new udelay() utility patch as well as the APIC bus
>>    frequency test aimed to make it more robust (additional ASSERTs,
>>    consistent types, eliminate duplicate code, etc.) and useful with
>>    support for more user configuration. Please refer to individual patches for
>>    detailed changes.
>> - Series applies cleanly to next branch of kvm-x86 with HEAD
>>    e4e9e1067138e5620cf0500c3e5f6ebfb9d322c8.
>>
>> [...]
> 
> Applied to kvm-x86 misc, with all the changes mentioned in my earlier replies.
> I'm out next week, and don't want to merge the KVM changes without these tests,
> hence the rushed application.
> 
> Please holler if you disagree with anything (or if I broke something).  I won't
> respond until July 8th at the earliest, but worst case scenario we can do fixup
> patches after 6.11-rc1.

Thank you very much for taking the time to make the changes and apply the patches.
All the changes look good to me and passes my testing.

Now that the x86 udelay() utility no longer use cpu_relax(), should ARM
and RISC-V's udelay() be modified to match in this regard? I can prepare
(unable to test) changes for you to consider on your return.

Reinette

