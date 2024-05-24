Return-Path: <kvm+bounces-18097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 302218CDF51
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 03:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 904A11F22C6C
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 01:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D69622616;
	Fri, 24 May 2024 01:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TcvO3D+5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B283A79C8;
	Fri, 24 May 2024 01:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716515484; cv=fail; b=f6t0P8Tp+iBvfFAddff0hi0osp0DgYZ2BHbDBTZC4T9P94R7GqMGgzP29HYZs4AwTolWbOmG+F9+5V60/gv9ajAFZDlgdZk3Go8kfCl++/ebST4u8pcEm77UVNisUHYnS1I/BKYNVthCL8W0kvfUInZgs74VFpbYj0dGfQQ6xXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716515484; c=relaxed/simple;
	bh=CwxW2ehIu5lnGjDJq2dLCMay7NukNLYSMOs8GztqI0M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L8pnk6WWI7GFs1kUwAAs5Kd0iGPHXmFBZAjpIA1W/nfE+cqnfz6LKr1hOtt2CMUtYi5v/3kBpqikgU/uCYSLb07PRnvgqvnWxUUfbbbf4Dngee1Ne5WTYlRIMHlmFddpBHKYV+SdMKX9hnlEzJTy4/9Gu4fCrTB4QAh9n/Wrfos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TcvO3D+5; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716515483; x=1748051483;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=CwxW2ehIu5lnGjDJq2dLCMay7NukNLYSMOs8GztqI0M=;
  b=TcvO3D+5my0cIirROp54u93+Jjo30uekGoT+cs80OzOVOoljJGRCwwAq
   wBdh83mb5PlWxm3ZJZr53uwmHK3mlqBmk4mF8h0AL2aJE7VKi8V8wnzTV
   AL6LPqeNFY3QQEg53Om3JtDgk85YiLAhYN14S7Khi9yWdZQJ4pey55ua+
   hpeZYR7Mp9kafEIcPYDS4lYb8Wi05Xb0YRgDbydReSCfPaxPzYEYaAyjA
   doyGLmSj2fl1+I7a7wfHpukUKuA1VbXFjSS0LfZHDtjKZEyrZrLkcqsVz
   olEF/RqDgQRyIobiP9GXUpfzCs/4ib2AvCBQgCOHvFamX04bLwYyLR1i0
   w==;
X-CSE-ConnectionGUID: mPd5NMyXR1y/lXqXog2fQg==
X-CSE-MsgGUID: FILIsxDsSm6lsGlHWmxMQA==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12706018"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="12706018"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 18:51:22 -0700
X-CSE-ConnectionGUID: l0j6FUEbTxaQ6Soe+68a8g==
X-CSE-MsgGUID: j2GAj7v7QYicQ77b5YOBxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="71269910"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 18:51:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 18:51:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 18:51:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 18:51:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 18:51:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKOq5wIIm9gMUoJGlxBY340c+UMxD6zgG+Z/gXE1hHasACcHA+buwEBHWOYOdvfD+KYZhKNAeAqnsRPIr/iIB9pfSbB4tcR53x/rr79t2UnDU3FOIEsyf/6H4tQGcS0dIz2m1OKVTV70qQA4/E8jxPvS3rxg5iBkeJYb4pHhBbVeoceosjFs9Gg5KCVJNlbKR1vE59zCLYavLAQe2tudlVU93lqtKXsiLXAxQ+ZR5djbpjCr09NQIqoFw9rfToIfyoVxXdR9FBujeGmm8ZQULms5z2NBbFSyCFHlioOeyGnc5bqufW4yjHRY86N24fxsF2sqOOG7FI1a39PA2dzIqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gpdb+4dwoo+I3ICiYKCpHKoxCytAUIZXZl1NeOuVdHM=;
 b=ZYdRD/N7+B6jtjxyFwGktv5IU6jNHZu0GLoPGP91mTnRx6+wZCyAtGuTO8dDxRw7IIbAOCavEoYTrh/ZhCA58F24YBhKNvoQS60EwHtSSgjxoco4Q5la7cn8YH8mlXfR48HS1vqs7SqpZTcHO5Gh00JLOwz804BNUkjg8S5xQd7JER1bZ2v87HAXeqiYdJWpFssJj0XYAaRpw3xN221hZy+CnqtfIreQOfRBIG757FjYhR9PyBWRESPj3Kal9i2NXx612nrje1FIrFKp8lYwuRagLKns/sgfC7B+vvy97MpkoO4NPiBbNDSB+xOyLo2611zgcer05o2EJlg2ntfXYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7744.namprd11.prod.outlook.com (2603:10b6:208:409::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Fri, 24 May
 2024 01:51:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 01:51:17 +0000
Date: Fri, 24 May 2024 09:50:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>,
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Message-ID: <Zk/yYkLCUi17RghH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZkUVcjYhgVpVcGAV@google.com>
 <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
 <ZkU7dl3BDXpwYwza@google.com>
 <175989e7-2275-4775-9ad8-65c4134184dd@intel.com>
 <ZkVDIkgj3lWKymfR@google.com>
 <7df9032d-83e4-46a1-ab29-6c7973a2ab0b@redhat.com>
 <Zk1KZDStu/+CR0i4@yzhao56-desk.sh.intel.com>
 <Zk1ZA-u9yYq0i15-@google.com>
 <Zk2VPoIpm9E6CCTm@yzhao56-desk.sh.intel.com>
 <CABgObfaq4oHC9C_iA2OudmFN-7E9RDiw-WiDu9skmpsW39j0nQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfaq4oHC9C_iA2OudmFN-7E9RDiw-WiDu9skmpsW39j0nQ@mail.gmail.com>
X-ClientProxiedBy: KL1PR01CA0013.apcprd01.prod.exchangelabs.com
 (2603:1096:820::25) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7744:EE_
X-MS-Office365-Filtering-Correlation-Id: 3125dba8-9fc4-4d74-9017-08dc7b9400b1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RmdJZEdJREVsL3VlNmFKMERpK3RJY0FLWjZCOEhTZ2I0RkVrdExSb2ZMTDV0?=
 =?utf-8?B?ZE1nSnE1SnNCZTVWQ1JYVlVIWmZQRlZzbWxJREVJbmdtT3FTYWtSVHU5dWk0?=
 =?utf-8?B?a295Qks4cmluZzJJMXk0c0JzL0pjWm9zVFhGRUt2Q0w2SEswRDhKeFZJU1Ar?=
 =?utf-8?B?ZjJ6SDloK2ZCVFQ5UWdDOTFmK1BqVTZpbWhEUTMwdWREWFBGbjN0bHhHZ0py?=
 =?utf-8?B?RmxEVSsvN3VoSFYvQ1EvbVp2QklXdzJ6VjgwOGJoOUd2bnJrTTM0TjZuUnpl?=
 =?utf-8?B?bktwbHhLM1NYcnpXSm9QNzYwTHQwYmU4cjRZSlAyWS80UFlnNEpXTkFoWXlB?=
 =?utf-8?B?Um5xanFJN0c0MTBaVUdaY004YkxCU0pvN3orWUFVWGRYWUlBQkhRdUNLUVY4?=
 =?utf-8?B?Qm5BbmIySlBPcDdUZE9STjcxenE2U1FWNTRPZzBNeTdUK3M0TitINUFlL1BB?=
 =?utf-8?B?M0JJUXNHV1JweDZuTFN5MlRhaE5SK3RZVm10alZGOUJET3I5c3JibTc5aDZL?=
 =?utf-8?B?ZTFFd3o4eUF3L2tkTkhka3c5Qnc3SDMrM2QwL2JYKzlkcW5tbzVhZXRZM2VM?=
 =?utf-8?B?aFJsa3htYkl5bDBnV3pocWhnWnNGek0ycDBUM3BGR1RQQ3VESzNQL2c0eDlX?=
 =?utf-8?B?R2Q4M0FaQ1AxdlNISU9DRjZodzhtQ3ZMdzh4OHVuQkVieVdjTkpsKzQ2SmRB?=
 =?utf-8?B?Ti9CejcxclVVQTFuWUtJdUhKRnl1c1JPMHIvUjNhUE1FOS9yRWhUaUF4UHUw?=
 =?utf-8?B?V3p1bk9BeUhZV0o4dGxCNVFyMld0VmNJZ2U2WXVsUmJwaDRFWUd1blF4Tk5z?=
 =?utf-8?B?YTRZMTJpVXk0c1UrTlN6YlZvRnZCK0hvV3dZVDBKcU9OVmYwZWxrenlZYzdo?=
 =?utf-8?B?QnRneHhxNXpqV3I0UXVaNDMzME9MajdmUkhBRzR3bjZEM1BzeHNHTmttMjd5?=
 =?utf-8?B?OGZYQTgyZ29jSHpVT2VJalNCSFNYeDdlaHhWRVVPSEtZS0RvRjVlZnpqeXdT?=
 =?utf-8?B?SFdvWEVhbmhBakFHM3poTW9DdHNNa3JWWDVxaTZzdDY1NDhoQnFKOHdkbnM4?=
 =?utf-8?B?UWdxbnIvRllxbTlxS3RqQ3JGOUVuQm5NZVBuUkxlM2dpcGN1TzBkR0hMVWh4?=
 =?utf-8?B?Q2JrMHNWV3A5NTZVQmpmaUtIajNCNVBsRk5SZUtCQXpGSEwrd1dIczlaMkEr?=
 =?utf-8?B?cUhBbG9FajNSQVovUGdaZzFWeFVvSVhZWXF3dEVtb01YQjg1b3lod21pZW90?=
 =?utf-8?B?cmVwbDJlSU1XeENvZXJ3SktqTGZGbFFrUXpTbVVPZXNUbDU2SjY2Y2ZRcXJk?=
 =?utf-8?B?M2dLYVdubm9abFU3bU5GeXVGc05iTE9iTWlMMy9XNGlvM1hNNXN6Tk1UUmVZ?=
 =?utf-8?B?VU42aFlrMk1idVR5U2JyRE1sbVJYTitvQ2NQanUzSU4ySnlVcmVkcSswd3JW?=
 =?utf-8?B?YmFkaFJNUnpjeEVLMVJkUlM5Mm1BazdNbS84cUwvRUtkVFBnUVJxSjlKS0Jo?=
 =?utf-8?B?K0I1U1lCMzdTTkp5azd3RDh5Wmt2K3VpSGNPV1R3dVJKQnNaNE1MM3dPMTVO?=
 =?utf-8?B?dzUyUjBDcE1uS1p2Q0RlS25hNU5mTGtKMHJabERraDV5YjZjSHhOY2w4WldT?=
 =?utf-8?B?ekh4b0l1OTJ4V3IybktQbkRaNk5ORXdJeEI4czQzTHZRc2xOVjA5RkpEQnhm?=
 =?utf-8?B?UE01YlM0NWxMamFwYjBlVnMvOHVNVGhkMXZ1d0hCZlJFMzBwRHl1SWdnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGZ0bjg4NEpiUWNsdkMzYjhHdTdtNktleEZ6MStqMi81cmJzZWloZklHbHZk?=
 =?utf-8?B?M3IydTBhYmdNMnNEbUJpMnAvaGljeGRSVTFmUzQ5RmtBZ0ZlVk1USldrVSt0?=
 =?utf-8?B?Uk5ra0F2QmpWMXpyVWF5N3VBZ0xuRkhwMHlIVmFoTEttUUkyNURhZHoyVVFR?=
 =?utf-8?B?cUFBMm1tQ1kwV3F1eVNVRnR4WlAzNUNCUml2YksxcHNIMytuM0sxTmFCeU9G?=
 =?utf-8?B?YmdpNVJLRDlSZFdkZkY0Q1BLOEkveHVjcWFpUlVXZ1QwT2psRHVkbDl5TXpC?=
 =?utf-8?B?Y2dnU3JoQXk2bEVIcnJQZUEzYkwyOWRFcENoTG1jcWlMdmVLamlUN094eXp6?=
 =?utf-8?B?WmhLZk9MTzNmazZLOVY2UXNUSXhrRk5Hd05vbng2Ylg3REdML3lBUFRQbG0y?=
 =?utf-8?B?dmJ3bnV0VXpURm5RTVhzaFM4TWdmL2hIUHplM3hiQUVnZGRkWlNSTlhsZHkz?=
 =?utf-8?B?Q1IycStGVURNSVdyQ3Uzd1FsaG1qOGFqdVdvTTBYeDYrMGI0M01vSld5eXJY?=
 =?utf-8?B?MWUxa2ZQek53QXA5QVYybEJFYjRhWkl6UExzejNsc1JSYVl6Y0NzTnJUNU9k?=
 =?utf-8?B?VUZta1ZFNkRqU0g5VmhxNmxiYU8vVHQ1cFYxQ01FaWI3cGFVZFVMQkVSM3Jk?=
 =?utf-8?B?eFA1L2R0Z1NrU2xUQmFEL1Y2aFhyalE3UDNrdk5HNVdSbnNCRHUxNHB5RUJC?=
 =?utf-8?B?cnZpa084ZDdBUEtxVkUzbkxDMndCT1VZV1F2RGZQazNKVGtEMklUQ210SUpW?=
 =?utf-8?B?SzVIUTJlTnc0VE8xbGtWT2c5bHI4S2NqUDBUNWN1Nmk4Y0x6QjFtYzkyQkhy?=
 =?utf-8?B?OU1wWWp3UVZiMEJObzFBTFM5b1BOZ2hteXdQSkxoUGZCZ1NZYnR3RlpEUXlY?=
 =?utf-8?B?MG12MkJNdEVNMWUzcU10VW1DYkZGMWU3Y1JWWGJObWFybnZYRHRmaXF1ME1L?=
 =?utf-8?B?b0FvNUg1L2h2WHJ5elIwd1c0cEdoQ0xpdUgvWk5McmNIMlh5WEg4NTBEazhH?=
 =?utf-8?B?ZnM0UTlOV1Z3cFpmT3RIVTZ6MTFJWld3V1Zyc2N3THFDYWRmYnJud09tYm5p?=
 =?utf-8?B?ZkN1N3V5Nm1OR04ydllhWk82WSs4ZGlGTmxzSiszRkJBTzR0UTBPZFh2L3o5?=
 =?utf-8?B?dWU5TTBhNEFZV2M1N2ZQZnFTblJvODl6TWVZUHB4WDd2Mi9vWCtDdkhDaE9l?=
 =?utf-8?B?dnNqekNiR2R4elQ0M05XNWp6a3pjMFg2Uy92MnpyZE10VVFHVW9QNzdYY01N?=
 =?utf-8?B?dmYrMjBkTm5qaUZMU1NqdS8weDY2R3JqZXIxWFpsV1hEZU1tQVZaRGxDY2gz?=
 =?utf-8?B?NlVlRWxQbU13SGg0SUorRkZPZ00ra3RJWHBqU2h1ZndscmlYaU5LOXJJamlY?=
 =?utf-8?B?UHl3eGNHSkFtcXJrN3ZKMEk4NlBSWHRTZG44UkdzeXhWcUJkOHBPY3lYdXpa?=
 =?utf-8?B?SlJiS1orVVVpRHdlRkE5TitYckVCMlNvVCs2MTRPa0R5RVd3ejZkTlMwdXZ4?=
 =?utf-8?B?NVRrazhqZnQxWi93UXpIRUpLZkJKZGMwekdoWXZyeXdFdzV3am5hN2R5MEYz?=
 =?utf-8?B?NTVHNFEzY1RDc21wREJhQURWeUliVGFQRU8xWmhEdGtSY2pJY2RHeFViS2Y4?=
 =?utf-8?B?RkpSaXQvUmt4R0NrRms2N0F5Tm1YSkFYU3dLU09jcURDZ2JOMHJjMFg2ZE02?=
 =?utf-8?B?UkdXVEI2WTRoU2tFSHNXSStJczNKRzk0a0xEWVZIZkJEQXIvTXVrT2dsdHNl?=
 =?utf-8?B?OUFHd0hyQmN0dXcrUG5kbkRuNnJYUlFnejVCV055bkt6d1ZHOUtPU1ZLcWJx?=
 =?utf-8?B?VkN3NEpZSC9mQkE4OE1vaHFGT3d6UFBsemZaNzh0RVN1Q1ZBZEpaZ2xvTEZH?=
 =?utf-8?B?Y3B2Q0t3WFYzUXUyQW9NQ1h6NlMzNDY5MzZJaUI2UUhiZVIxdXQ4ZGxCSHdh?=
 =?utf-8?B?SklSMG5lcUJaM3k4d3UvZFFVdlRRaG13YlgwRENKeGhIN3pvYWVNbGEvRERC?=
 =?utf-8?B?WCtFZ2huclVFR1BXMHNoRkV6NnQwTXMwZlROTC9vV3c4NFJJL1ZpSlFUWE5B?=
 =?utf-8?B?c21yZENSZEdhdFA2Vi9ZbEFvYWxlNXJrWUR6OTZzMkdFRkxOVmN3ZGFteHBO?=
 =?utf-8?Q?3Y5Sy3AfnmFmox/MZqgn/6fKh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3125dba8-9fc4-4d74-9017-08dc7b9400b1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 01:51:17.7916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCZcEVKv0oxSUMcnpEbgwbjlx+7+OGBuoBnPGBNS98WerzuWc+SoPwUrvuA5/CEJKT+OM9SMitj0RkllwjiJPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7744
X-OriginatorOrg: intel.com

On Wed, May 22, 2024 at 05:45:39PM +0200, Paolo Bonzini wrote:
> On Wed, May 22, 2024 at 8:49 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > Disabling the quirk would allow KVM to choose between a slow/precise/partial zap,
> > > and full/fast zap.
> > TDX needs to disable the quirk for slow/precise/partial zap, right?
> 
> Yes - and since TDX is a separate VM type it might even start with the
> quirk disabled. For sure, the memslot flag is the worst option and I'd
> really prefer to avoid it.
Thanks. Will implement a quirk and let TDX code in QEMU to disable the
quirk.

> 
> > > I have the same feeling that the bug is probably not reproducible with latest
> > > KVM code
> 
> Or with the latest QEMU code, if it was related somehow to non-atomic
> changes to the memory map.
>
Thanks for this input. Will check if it's related.

