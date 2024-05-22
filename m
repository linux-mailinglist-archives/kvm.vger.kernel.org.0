Return-Path: <kvm+bounces-17930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 349758CBB8F
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDF1828273C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E757A702;
	Wed, 22 May 2024 06:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RHdDrDok"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0230E79B84;
	Wed, 22 May 2024 06:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716360565; cv=fail; b=juzNNAEul1a3jd6L2S1RYD8wqwhV8NYCsk19hm7UR4GK2SAsOpyxnFZeW8a9MpofyCZSOhyAwefUmYtVlCiKVbneqJyeKpGPiKdWu9fg2H0LCoHwooBf10vLuSeNHVq5ITCGlmcgV6IUn4uXLlBxLHzJptJ4Cd1baKO2WtChuqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716360565; c=relaxed/simple;
	bh=GuhGcl4+kuamP3It6xxbLwYF72TiZX7eWLkbByvAGzg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DppFBhYUGtSHmUvxjugPR2Dh5oE8FAtHSHg1j9oZ3lkjWhu2QvGL/Yjrr0yKn1rYskesh9S6+Dw8OrOHokF4v6s4xo3ro5ajOxO+rLrqva1q8z/jPPcjp5lQol73uto82e1Tl9U9CVZVBFIN8fcYbz6SamTymr+s1Z6zfCkIoGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RHdDrDok; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716360564; x=1747896564;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=GuhGcl4+kuamP3It6xxbLwYF72TiZX7eWLkbByvAGzg=;
  b=RHdDrDokpTa/ItXMuc5F0RZKufwNrVkg/d8+f3FI5KXK/MIJkHjN86Fn
   F7B3Cqpo3GRFVb2dUdeM82Kd0Q3tP1OcdrYsi+82D2NWI3UTbZZW8ucX3
   Do7N6V5z8vQ5U8RIsGi89HEHjz0ZTAGmKbXURPyPmdReXGGEq7Ey94Ia4
   u1Na1hOGpJS3v5e3u4gRpQL0jd0K/d7tROyigoWE/Q6JFtjq+ZNZulmLW
   LMraZek2EAkZHx8O9VaYLMExu6CjirimxQrrcwKpY+3UaseEnNxUz5Tcq
   h8of/OjB3NpP73jP83RA9+QxV7pKb0a46kcdFO4PxHVjXwclBPzR6/gNT
   Q==;
X-CSE-ConnectionGUID: HeOfpMkjThCQyQJcj64A+Q==
X-CSE-MsgGUID: 5n/KkZZYTJWufHpgNS5njA==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="30096171"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="30096171"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:49:23 -0700
X-CSE-ConnectionGUID: C2gJBj8zRt6TE1rdQBJoBw==
X-CSE-MsgGUID: QxzK+NxkSRWQtC4x3uRkXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33311750"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 23:49:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 23:49:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 23:49:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 23:49:22 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 23:49:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJELQ7YHSnvnYXWBtEIy1TVe+metiRD8Q9jSG29XU8glLNG7fJIDaG18gt2CNQVDUvVMxk3a/FNRtnleEt7u16kJlDmpIXkWerSYxXJt/1IGqfzDE0XlPyn86DvVwolLxlrHBT0aZTUckFgp/Da3gOZVDXQ0c/dBcDHXVSGkA8RRXiz6loipvW3K+EgwQ5hpDNjgfrYsPtPEpJFDBdOtnnf8gO3IBHTGtvXy6KpFoZMUhhIcrpsBrk1nBUPJyPG57pGPHK+iZEYAQBALoj6GSHRWXZTGrgXygES7SJy90KZsSFiybmUvHRgNfMjD+cjJ+Kqldow/MG6NCf34MJm8LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9J7ss6ktIm5HSu4fdL09vZi94j1BvTiLQROnoFviAdg=;
 b=j10c7WninIaZvRsu2dMUu5SqzEbEjstEQ7ABTMZjQH2NMHyHyHsoh4l+M6QjVpCc0xy9MZasLj/K4NTLWBN9Ylx6gRGkfJhyt/mdQpSkwWXS/uuh1bng0P8suvKnFPzTwEB741xmBMnbZmy/Kuewrd4Bb4EIaiT1DCDo+cYZE+dJFyJS88xXUYphT2wqaqn6JdkwNVrmjGbY1q4tHFBkmfqb5YK+HkMpXDh4rE3jkadBmzYhXMaL6qTrra4WtYMj2rZH1muwEbzE7D6xrGEW5Y1y36v5COpj3XArk58xTXnCqkJk9nTt5M7SMeQ54nrO2brQ2xPJ+2UxeI55btDQ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW3PR11MB4569.namprd11.prod.outlook.com (2603:10b6:303:54::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.36; Wed, 22 May 2024 06:49:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.030; Wed, 22 May 2024
 06:49:20 +0000
Date: Wed, 22 May 2024 14:48:30 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>, Rick
 P Edgecombe <rick.p.edgecombe@intel.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Message-ID: <Zk2VPoIpm9E6CCTm@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZkUIMKxhhYbrvS8I@google.com>
 <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
 <ZkUVcjYhgVpVcGAV@google.com>
 <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
 <ZkU7dl3BDXpwYwza@google.com>
 <175989e7-2275-4775-9ad8-65c4134184dd@intel.com>
 <ZkVDIkgj3lWKymfR@google.com>
 <7df9032d-83e4-46a1-ab29-6c7973a2ab0b@redhat.com>
 <Zk1KZDStu/+CR0i4@yzhao56-desk.sh.intel.com>
 <Zk1ZA-u9yYq0i15-@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zk1ZA-u9yYq0i15-@google.com>
X-ClientProxiedBy: SG2PR02CA0123.apcprd02.prod.outlook.com
 (2603:1096:4:188::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW3PR11MB4569:EE_
X-MS-Office365-Filtering-Correlation-Id: e8d16470-1cca-4ba4-16a8-08dc7a2b4e77
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?anFoaWV3ei84UnF3cUVwa2tYT0tMN3lrYTBRY3BSelBKZlorbUVURVdXeExp?=
 =?utf-8?B?TXJ2YzVqTlQ2cjYvYkRsd1ZtOGxPZXlRV2dlU0h2M0VVSU94N2lpUWJsS2py?=
 =?utf-8?B?eHhYa3pkMThSdjhNKytzSDFybXJwd2hTd0tFa0QvbFRDT0VHcXJBRm1SQ2J4?=
 =?utf-8?B?TkVXQmQ0RmJxYnVZc0RxaXdZc3EyTGkvSE0xT25ZamVPWmhVcHI0TUpnd3Y3?=
 =?utf-8?B?S01oSjhod3YxZDhrV0pjT3ZDa08xU0hXZDJyYWk1VlRmWUlqWENMUm02VFZv?=
 =?utf-8?B?eDRxNGJ1UTJmbW02ZUptbEpkVFlodzA3UmhPOWg4RlYxc2VaOUhaMnVYaExB?=
 =?utf-8?B?bWQ5Mm1QWUIyQmpKOHZWbEgxRDVQcWQ4M25jb2hHR2F4WjRUVTFzR1cwTERq?=
 =?utf-8?B?TXd1T2tBT0F5Q0pqSVVoYmZQRDJxR29lYTNhdEFPVVh6S21rcGZQd005dUJr?=
 =?utf-8?B?YVZvYVl3SVhrbjViV05lVHdvRzYxbjAxMXZDL1JBSytWVEx0WWtMT2NlTE56?=
 =?utf-8?B?NVh5SURIdGpmTXAzUEhyaHc4NllBa2tJWUI3eEhzY2tkbzg2VXNIekhWVVNw?=
 =?utf-8?B?TVVxdFFjK3l4K3hUdEZUOTM3ZzhKMlBsNTlqMnlaS29KbnVKM1VxUFNHMHhJ?=
 =?utf-8?B?Z0pvb1cyOVl4OGdWbm9MRThFMnFxWmZKaWlrMzA4d01LdjVzOERwYXd2aXJi?=
 =?utf-8?B?SkZIdXRqUzFXR0wzM2NoUWRkQzJ1MWl2QjVZbzNkNGlaT25wODN1S281WktJ?=
 =?utf-8?B?WHZKTEVEN2E3NXZnaDBWY280ZGl6QlRwSVVZa3FxQmdCUk9xUFE0NHhCOE1o?=
 =?utf-8?B?OUFBM09MVVZJK2NoTEVhb2xxVytYQ2J4bU8yQVBMTU9EazkvbnNXRkh3Nk44?=
 =?utf-8?B?OVNKT2Z6MTd4VnRNd2hjU2x3dzJJMTVDa1N5ckhjQ3BjbGhnRnZhZ3ppamdn?=
 =?utf-8?B?anhYZ3NKeWNha0ttdHZrVU9HSk9LNmN1RXJhaTllc2R3S25LVjcvR0JQQTZ2?=
 =?utf-8?B?elNReGZIYTJCaDV5K0ZrNzZVUFdjZm1VK054QUpQbjlFQUhSV0tpRSt4MFNZ?=
 =?utf-8?B?OXlGT0dqSUtyWEFHSXBQbUpyaVVUQWU4bnJiQ21ndGpKR09DTUNNTzRKOEh6?=
 =?utf-8?B?c1JEelBQQi94RDhVL01EeTNNRVBRY1lVUFdNaGVENGJzdHAxRjZBZWJyY0wz?=
 =?utf-8?B?TVhzUk83Nk40YUJIWWNvcDZGVXh1ZmFSdlhiVVQzY0FDNXM2VGd5ZHoyQWYw?=
 =?utf-8?B?MVJTOGNJSXRmMWU0ejRGVHVPM3RWUU9KWDNLa1hCdTBVWHBZeDhrOElqYWhP?=
 =?utf-8?B?aEROTTd0ejVndjJtTlVHNkVpaVZ6Z0VaNTEwM0RybWF6aWxNWUNxclpvNFhS?=
 =?utf-8?B?ditFN2d2S0lRdjA1ZGQxUFZGOVlWcWs1cW5pMFVkWHMrWkpJWERtamxyU1kz?=
 =?utf-8?B?OUxLMGg4eW9WcFpxRjExZWpFejdDamtUakg1YU51TDh0U2tRU3JXS3JzbzJt?=
 =?utf-8?B?Z1U1T2JHd1VZMlloc1lxblVGeHBBbTNvMTlGTUw1dmJhZGhxbG9jd3UwZWpG?=
 =?utf-8?B?Tk5WRmQ1L2tBRCtSWkR2dUJacGkzUXZDdFZpSEVpN2h6c2R3RHNUZklYdVF2?=
 =?utf-8?B?bUFTYzhTYjdKNjh2UHJoN2FiZUVuZTJZRFo4NWFVUkUrTnU4WkRGaUVCbDQx?=
 =?utf-8?B?b3U1ZUZIYzlMS0E4a09qbzZ1V1dRNngyOTlWUHJvSXgvQTUrWEE5OExRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm5NVGh0NzJjK0ZpY0ZEcmRKYWV4WXBSM0MyYnA0QUlScEQvRzVUUmo4L0U4?=
 =?utf-8?B?R2MrZ2NnL0NUcFZsU1FxWnpoZlJWSVFCd0haWWZHbHdWK2pLZzBuR1lKTEFy?=
 =?utf-8?B?YzArR3o2RGMvajRCWUdyTG5Dem1XdWx0VVdVbkxWVXF6bHRXV0QrakVYaXN6?=
 =?utf-8?B?bWN2bE4wOW1GWklEZHlOYlFrMitpQU9raHlGU0haWXpsTmZMTHFsbzNSOUpo?=
 =?utf-8?B?Z2F0YmxoS1Z1emRsU21Zb2JPZ0xlZzhjclFwNUVCaTY5bkJNVzVQWjNla3dT?=
 =?utf-8?B?WUwxblFnenJpQW1USi9wODI4YmVEcDhWejhSUXJwKzNLR2hZdFd3d0xGWjhO?=
 =?utf-8?B?Y0R6VHd5Qlc2TFNId3JVdFlwYWN1UkIrc3JGQmVUWUVyb3h3MzEyZWpSOTJ0?=
 =?utf-8?B?OVAwUjZZZDdWZEZZcWVPcjJOQlRxTVF4MG1BbnZ0NC9oRW9EU0d2WElqQlJX?=
 =?utf-8?B?eDZlNHFaZ0VLWlZGVi9JbjcyeDBFb2w1Nlkwa1RKdXhaVjNrT1UyVEpocTQ2?=
 =?utf-8?B?K0pKek05dGd2d3p5TVpySko3cFoyZlZWT3lTV1M0bGpuOWdCc1pvUWxJNXJ0?=
 =?utf-8?B?L0t4WnJ1OE1ibmY3NkNrSWdtcGNOajczN3psa0o3OWVlWmVGcjdJaDBvNjZD?=
 =?utf-8?B?NUpwWDdvaUJQWExoMWFuSHMxQURmZlpSaEtkY1hOSHNRbFh2Zk1PUTF5UGlS?=
 =?utf-8?B?a3dYTzBvZG5USFBSVmhXVjc1Mit4TmhDSklmdDBka0RCZDQ0a2V1UEs2a0Rr?=
 =?utf-8?B?amtKRUp4WGxZVEp3WklDcDVtSXRBWWQ4MnZvd1pzQXEwS3Q0aW9majQ0ZTQx?=
 =?utf-8?B?bGJCY0RZcEM2YkNIVUlhZnhJR3Q5dHp0RDFIdEZrSE5TUTc0aUI0bjdyVEl4?=
 =?utf-8?B?T0FXM0lteTNFL1hqcWNremhmNFRBN1lqRE52SWJTZ3BOSnlNdEFIQW9iOEhp?=
 =?utf-8?B?bHg5VXZma2UwUzJkN21jWnR5RVpUa0hPd2Zkd01MZGJQWHI5R2FCNGI1Y3pU?=
 =?utf-8?B?M1pCYnhIRDdoY0UxR0hLOEx4Mk9sUlp3dktNOTJNU0YwNnBlMjhmL1Nwb21t?=
 =?utf-8?B?M2NUUnV3VlhzTVBDQWNnL2t3N3BEU2FkTVZhdm9SeXhnZld6WlZ1bGw3Uzls?=
 =?utf-8?B?Mm8rakRaMkRrOUozNjhidVJkTHdoRE5UZk1FamJpVUo4QWMrbjc1NWttcldt?=
 =?utf-8?B?Tk85TmY1OWxURGNkZ3M2THk0anZZZ0RSMk5JakcyaFB4cnpLRE1DRTFqVi95?=
 =?utf-8?B?U0xCOGJtQ21kNmJJb29GU0ZvVGc1SHQxbExkZkg4SnJrOXNyZFNKQnVoZXAx?=
 =?utf-8?B?NTNUV0xEVjBSdmVQeWs2emNIc3dBczFsdGRseURsQytsd1ZzdUpUTE5rdm4y?=
 =?utf-8?B?b1hVK2tJZUVUdUxNOWhuc2QxL1Q1eGU1Z1ZnZHd6Q0VsSEQ3V1RpajBtSnRL?=
 =?utf-8?B?WFVLc3ROd3dHZDY4SFBwOTV2V2pkZWh3ZW0rdW5LTHRzRit1cXlma0tTb0NF?=
 =?utf-8?B?amtQLzQzYUN3UWRnZFBtaXBDR2ZTNWhicEZFaUw3bW45SDJGcU9BdWNSVlA0?=
 =?utf-8?B?ZVB2WFZOcmlmdnhBN0hmdyswRDJMcHA2MDR3TTJ5dFV5ZHJGeXNyMHRGeE0x?=
 =?utf-8?B?bzRLdWs5Sm00N0JFRUxtKzk0ZkI3YUlKaWhsSG9HeXBIVko2WFdpUlFpbmhr?=
 =?utf-8?B?ZExxN0JFL1dIRUJFWTBwK1pGWktEWXoxclgxZzM4ZnF3alNCWWwxYmlvSUs1?=
 =?utf-8?B?NHgvR2ZIRU1aQzBmem1Rbk5iU0hhUU5DNlNCckUzMWREdEdQUGViSkx3b0Na?=
 =?utf-8?B?SlBVc2MyS3RhSi9GZmRVeUN2QjY4bGpjOFdIUjBGRDF6cDEwcFUrOUNmeFVW?=
 =?utf-8?B?U21nc0g0SlY2QnpVa0t3RkU2U3pCVVlvUE5ZR25RY093S0hwalRrYTdNYXFu?=
 =?utf-8?B?R3Buejg2UHkvQm9kWU5XS2c2WmZPRjI5QzhQZm9uU2w3NXRIdStQTmo0aFFh?=
 =?utf-8?B?NnVJVzlmWHd1NER0OW9oa3h5eHVON3RHQm8rZFpRWTNpdU9BTCtrY0JjT2RS?=
 =?utf-8?B?bm9OMkZWZmdWMXc5TUdqSnVmb3Z5by8yQ1NjdDdWZm4zYVZ1T3VZNEljQm9W?=
 =?utf-8?Q?h/mLeexnAkugSOYyu35gE8/8b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d16470-1cca-4ba4-16a8-08dc7a2b4e77
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 06:49:19.9346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzHgIP5rhP+UA45Cpv/yp0Od4FGOTgvgHq7v5M0rEBQL4HP4zbfo7B2UztlEeKmF39EI8DbUwF1PoNrQ7hH4Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4569
X-OriginatorOrg: intel.com

On Tue, May 21, 2024 at 07:31:31PM -0700, Sean Christopherson wrote:
> On Wed, May 22, 2024, Yan Zhao wrote:
> > On Fri, May 17, 2024 at 05:30:50PM +0200, Paolo Bonzini wrote:
> > > On 5/16/24 01:20, Sean Christopherson wrote:
> > > > Hmm, a quirk isn't a bad idea.  It suffers the same problems as a memslot flag,
> > > > i.e. who knows when it's safe to disable the quirk, but I would hope userspace
> > > > would be much, much cautious about disabling a quirk that comes with a massive
> > > > disclaimer.
> > > > 
> > > > Though I suspect Paolo will shoot this down too 😉
> > > 
> > > Not really, it's probably the least bad option.  Not as safe as keying it
> > > off the new machine types, but less ugly.
> > A concern about the quirk is that before identifying the root cause of the
> > issue, we don't know which one is a quirk, fast zapping all TDPs or slow zapping
> > within memslot range.
> 
> The quirk is specifically that KVM zaps SPTEs that aren't related to the memslot
> being deleted/moved.  E.g. the issue went away if KVM zapped a rather arbitrary
> set of SPTEs.  IIRC, there was a specific gfn range that was "problematic", but
> we never figured out the correlation between the problematic range and the memslot
> being deleted.
> 
So, a quirk like KVM_X86_QUIRK_ZAP_ALL_ON_MEMSLOT_DELETION, and enable it by
default?

> Disabling the quirk would allow KVM to choose between a slow/precise/partial zap,
> and full/fast zap.
TDX needs to disable the quirk for slow/precise/partial zap, right?
Then, when unsafe and passthrough devices are involved in TDX, we need to either
keep disabling the quirk if no bug reported or identify the root cause then.
Is that correct?


