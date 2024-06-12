Return-Path: <kvm+bounces-19488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D80FC905A30
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:49:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D7871F23615
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAC81822DE;
	Wed, 12 Jun 2024 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MvkSg2IW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073AF16E895;
	Wed, 12 Jun 2024 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718214568; cv=fail; b=bwndf3AcmLJMeCapPizJGHcZg9vUFa1L4v3oYjNDsljf0huE0IZAgHIYDQ2wklJXoOVJaCqKERs/y0hi50h5r2HDDHo5xCJn1iRM+GTccJPkb7TDVuMwgeek3Sb35gCt3Ipc2z/uiQrs8YiEl0uMiXq1gYH4rYN4pdgDIgl0Qmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718214568; c=relaxed/simple;
	bh=dR+fNrN/N/PrgIoYtJIjC/cdH6bJHBm+/miNAsRV7AM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ocR1sOBDXl561XWjfgXjXW4OxjE7r4UvbWlIJzQZ8UGc3waTy/FNX5Fk0SI9u3nW4Gru6vpPcQFtNNSRSZ8OJchla2Rojz3tTbwbJWLMIieVCI0+VojNjO9B7TC/gMm4FKTd34Gtx8WQz6CNVBIzVGusLiYkVlX7WzH8A9mbmvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MvkSg2IW; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718214566; x=1749750566;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dR+fNrN/N/PrgIoYtJIjC/cdH6bJHBm+/miNAsRV7AM=;
  b=MvkSg2IWVTvKvM9ZU3pvJcy/NHBe0nlgvciUJ9FrVJ/H3F2jBJHDEgVZ
   F/pdAS45KfEdrdxPQNtqlh6EfA9QC1qBM3s5Py5BKiJq/CQyGP5ECNF+g
   vObmLq6DnesSmgNWBy/8madzdNvAm9Eck++2AIGNZ0Jr2rBGZSGAphOCb
   QLBq8ubM6oJGxqVRjNJm3CyNmp14TOfxNNzhB9HfTMpG+nbDydgY2WL2g
   +giozS8ObuA8/ZznB85dMaRqGYTH5hHERTznlLmm1N54xQOcgN2IjFCaK
   DGT2Yfukt29x/xpvv+9cx89/fOp4nI5kCp9Ot9zv3lk0rvA6qin8pMinD
   g==;
X-CSE-ConnectionGUID: LgFQslBoRui7q92QBIwlkQ==
X-CSE-MsgGUID: cxBIvyzfQiKFEzeZKhZYrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="14958793"
X-IronPort-AV: E=Sophos;i="6.08,233,1712646000"; 
   d="scan'208";a="14958793"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 10:49:26 -0700
X-CSE-ConnectionGUID: wHrIGuWgSai78K8MaVdzkg==
X-CSE-MsgGUID: wpZBSPM4R/CSyCMEQBA2Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,233,1712646000"; 
   d="scan'208";a="40566080"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jun 2024 10:49:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 12 Jun 2024 10:49:24 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 12 Jun 2024 10:49:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 12 Jun 2024 10:49:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 12 Jun 2024 10:49:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5C21ccXtcB2vqWt+3l8K6SQxjFGuXKLYW2xuP4dfQZNRWMLQEwTz5H/mgboUwvdCuJpus/f71He4K26abLshwyrynu9qYNBycKMMJWgfnBpGx/gRqcHnrMOSUxA+/e8cLWZ8A0E/oQHfTZDTNNe6IuDewOxFbKpawQYs1foHNUUKH8G725mdm/DgC5Zg0MvaznFxjwF89GAzli55d2DyDA0ChCIwQQzs4Wzc5DcX4dPB5DKOFhtfyVx8B4ouT7QivMCPdkNo5B9hOnww6rpNNaQd2kK29e1XqmFB2ygkZRjaVNi65fml3s99mToGf18C5KIwy4OAUkmB8C7wtkK3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TSJXvNA+E1tL+XxtCm62ldmM1c3MBqdtu/APV+JipDc=;
 b=mheyF8QZmUb+rz5c5KUJXnfBclAG99BiCDv74jOrbBe1QyeS56jehx/fvH2EAbXE+hWKOO7obFMh2UBo9itcUbFLHmnAkZHaddQLJJYN9RVuKfBIa5heV8Nj02C/ufoJZ/chodMU55C+Ka6U3voaKyoEmBp5Jq1XT9aTB3T38gRC3wt111iUWBcSPaGaLqDVjn+gMqZ0Mb7NhKm30pWn+GKY8Ef6M36Ueb6iq73Y46+HJqcey9/RUW/mZ/OXt4Evtlwmbqg4BblCBH0SrIw9Qwof1hpabOztAs910cFkBq9TUGIAb2xiNYCVwRM3d+f+wtCjxpd4hN6FGzyDYpvHDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB8123.namprd11.prod.outlook.com (2603:10b6:510:236::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Wed, 12 Jun
 2024 17:49:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7677.019; Wed, 12 Jun 2024
 17:49:20 +0000
Message-ID: <bb9d3836-8765-4c4b-9966-6842c8cf25e2@intel.com>
Date: Wed, 12 Jun 2024 10:49:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 1/2] KVM: selftests: Add x86_64 guest udelay() utility
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <vannapurve@google.com>,
	<jmattson@google.com>, <mlevitsk@redhat.com>, <xiaoyao.li@intel.com>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <yuan.yao@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1718043121.git.reinette.chatre@intel.com>
 <ad03cb58323158c1ea14f485f834c5dfb7bf9063.1718043121.git.reinette.chatre@intel.com>
 <ZmeYp8Sornz36ZkO@google.com>
 <a44d4534-3ba1-4bee-b06d-bb2a77fe3856@intel.com>
 <ZmjJnzBkOe58fFL6@google.com>
 <88c65b89-5174-4076-82cd-7852c8c25b66@intel.com>
 <Zmj2nVhtVoGflaiG@google.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <Zmj2nVhtVoGflaiG@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:303:8e::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 52d070b8-275b-4bba-643a-08dc8b07fc92
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230034|366010|376008|1800799018;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b0YvTDBpZVY4RXFMdjZmNVk5U0pXemN3UU5UZUt6cTlrckpxdVlrTytORTFN?=
 =?utf-8?B?ZS9PcnZ4anhUQ1ZuYkROUlMyWU9CbTZKT1ZEVzJRUlNxcWV0SjAxV0FYa1Ix?=
 =?utf-8?B?V2xvSC8wTDBzTmZHdUh5cXk2V3ZPZ2ZRTVNIZVBaemcxU1prZGIzM0wxaTVC?=
 =?utf-8?B?UnArYmFHTmVsMFp0Q2xUZTJQb1lHN3h5UkpvUC92QmgwazY5bFpEMitJRDB2?=
 =?utf-8?B?SzNSTzV6VzErelZNWnZtdldPNTFFb29acGYyd0Jqc2FVZ2Z6cjMxem9pdld2?=
 =?utf-8?B?NUJ0dnpKbmwyNElSaitweWIvcEtOYkw4UlEwcWdLRzcvYUlOMnpieUYxaUZn?=
 =?utf-8?B?cVR6KzJsR2hjSVRFTXhvTmR1MkN3MUhoS3Z3Ky9qNG8xbmxtUnBxajFOQ3A0?=
 =?utf-8?B?ZUtqTXMxOEJzaXBtQ0FYNzE2bkFMbTFmbUxVZCtSNG0yNGtwaC9VMHY1Yk9h?=
 =?utf-8?B?ZGl2THVtVkNXMTZjaEVVYlA0Qm84SXdINS9xSnUvbmdzS0NQNXFzUnM5ZUY3?=
 =?utf-8?B?OU52cXlaMFBmZ3BTbmxZeVJESDQ3N3NqVHFteFNWZk4rS3hZaE9XZXRIVnZ6?=
 =?utf-8?B?amk3OVR6MzZBckZRaEVhN3Z4KzJLVWlSU3NmNG9QMk91QXJpMTdQN0cwaTVa?=
 =?utf-8?B?UStyaTIxNm9SQnF4WVB3Rm55VkRHUThobklwR2sva3Q4QUU3eSs0QzRZanhS?=
 =?utf-8?B?Wi9wTm5yTTAzR3lJRWNCZDBkcDFVSHJJUStQc29NZmQ4WXRDaU9EclNSck1w?=
 =?utf-8?B?bGpKUnlrMk0rUnpSZ2Q2NEFzVUtJc05KbTVzeTNCU1h0N2N1RERBNXVLWTVP?=
 =?utf-8?B?QVlibFNYWTBGdXd6Q3A3Y2lxUHVsVEhDVnRXK09UNHh5VE1STzNWM1ZXV0JY?=
 =?utf-8?B?UzRyampid2lldHNYWjN3V1g5TURVeWtHZ3lrWHV4a29UZTl3SzJuT3M1RXJX?=
 =?utf-8?B?MmRTVlhBTHhLWWdNWE91azZsaE5LVnFPL2hQNXN2a3dFRnYrdDU5UWZNZEhv?=
 =?utf-8?B?elUwVmsreTZ5aHhUODZGclV1K09HWUtvRXp3UWx0a1cwNHkwVjdnKzlFNjZh?=
 =?utf-8?B?ZzJVNWJmZi9TdHhNQ1lmM1MrN3MxZUhqaDYxWW56TWdTbmdkT2tHaDZmdFVW?=
 =?utf-8?B?SXViWmE5REVaWmNQWUJVN1ZtamN5eHZhM1VYdStVUzFrQVpkTFlvTHJTSnVo?=
 =?utf-8?B?bVJMNHNHN1NFR0lReUp6TEllR1JCRzNmcThBN1JrSnVlNCs3OFl1SmhBdnVx?=
 =?utf-8?B?ek9oUGR0d0YrSVpycG02Wkh3WE0yaklQNElNcjZ5bERTNFBONCs4SDdzMTBN?=
 =?utf-8?B?TFNMTDBHVDQ1bFNDUkMyU24vNUcwY3NTb21tdUh2eW0xRmVzUUE3dkg2b3Zo?=
 =?utf-8?B?UjRTU0Q4VldNY0JGSWQzclEzSzVCaGJYcUZYQ1BBdnNoRmR5QjVZbW5aZGhE?=
 =?utf-8?B?WnFsSTJ6OStPMU9wcWk4YzFZUU9IYTZ3SGZCQmh0eStSTU85QVVrYXFTSmRW?=
 =?utf-8?B?RVZ3aGQvbHBMRjhWaFlqQUhPMUFoUGdyV2hVakZoam9FMDZSMlRVbWYvTzJH?=
 =?utf-8?B?NHdhMFFTZEpKQi82Q0FKK2FwblZ3dFlYQmVXU3BsUnhZQ1BLMFB3UVZULzZJ?=
 =?utf-8?B?eHcxZGZYRGRYUnpCVmpNYU1ZTnk4ZWpXdys2eXM0anh2Qk1Ub20ycWFBeDRC?=
 =?utf-8?B?Q2IrVlB2VVh1cG5CWHBxNzJ1a0U4YklkbC9iMUxwTFhUa0RPR3M2bEMwY1pv?=
 =?utf-8?Q?AXKRAR7bH+KmnqPtyjK9EzOZnyOrIoFAyua5xNd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230034)(366010)(376008)(1800799018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHVscCtuZk5Ud205K1dhZGJQKzZQQ0RvOVVJYW9wS3NVV29IWUJoWWxtUk8r?=
 =?utf-8?B?OTY1UEtNeFZHK2NHeXRiNGRkMXlzUHlhVldrVEZ6YlV5c2JEdFVrSDh5U0NK?=
 =?utf-8?B?eXlsbi8rQnNmVlpwYy83T2JLemRDNzZBV1VJYTR3V3dxS1phMjY4TSthRFdz?=
 =?utf-8?B?V3dEbUNvNFdpdFYvQ2FCR1JtUnFZNGVMSVJVWXdjUTkrSnNCWDFwR1NQMTBU?=
 =?utf-8?B?NzByNFFkVjhmWlViVjM5dkVnZ2V6cFo1SjNNb1lDWkMxVGhTQlVyUis5Y3dE?=
 =?utf-8?B?QVBwYkx0WTdEM0VVNXIzM21CaFJTSldqMm95bWcyaHd0eTdzbHJSVnhoVXk1?=
 =?utf-8?B?UHl1SjRqZ2Uwb2MwdFhtVWNodDBzRXVDa0Y5VkJtVkFwNUhHZkZ1WHZObFJD?=
 =?utf-8?B?L2tDaGRoYTdEaVhsYUZtaWhHV1VXRUJaR0ZBVVNYMXg0R1BhakhnSlhZejds?=
 =?utf-8?B?Rk5mNnRraHBHbmFUaG4wOWRwUVc2YmlYYlY1R3ZwRmg2TWpLa2lFV284TUFI?=
 =?utf-8?B?NzBBOEdpSE9NeHQwaDM0eDlYZTJTQ3VNQ25ndm5EWk5KTnkvcUFEZGdsK1Fy?=
 =?utf-8?B?blczVWJVbEdxTUNzcDYxVzZteUwyNnNXeE4yNGhEQlY3SjloMnkreFdTWmVW?=
 =?utf-8?B?TUE1YzR1bDExdFN3WnVvZCtvYmlaNzJTcktZTEw2YktGYk1ybUVOa3lQeXRH?=
 =?utf-8?B?NkorVlNMc1Z4QnhSU2VDbFhGUW5pZUZub1F6alNTME55cmZSdFlNQzBXZ0x0?=
 =?utf-8?B?SWdhcndmM1VTUm1Xa0FKQXNmeG9VZ2RMYys0ZWI1cXNhdnNPNy9aVGhubTRP?=
 =?utf-8?B?QWZwM0N0cjhodFhlYXluL09XY3doMGpRMUFhTTFKa3pDMWlTb1FyZVhOTk5T?=
 =?utf-8?B?bkhPMmZBc1dlZUJTZG5jWGJ2Um5SaEJQNjREYzFvUFJ4WjgxT0grbHF3aEtu?=
 =?utf-8?B?YW1JbUpPdDVnVlExQTh6Q2R3QiswQ1NVMFB6MGlOMHdYblZqTU1rdDdQVmF6?=
 =?utf-8?B?dVpwMms0RGpveW9FSm1HellWdld6ZFVRRTdGaDR0TnFQRDZVM0Z6RGMxc2RF?=
 =?utf-8?B?b0lNQ1gvRGRNd1dQWFltNGVlZFFxbXFjNVpmNmZoSlA1UjlNdllBYm0rOXJC?=
 =?utf-8?B?Uk44Y2wvSWVFYVd3Q0dVbE9zNkhZL1MwT0RTWm1ZZHYyQmpLVXNlM21tbjBV?=
 =?utf-8?B?RjVlSXJnRnppRGJHN3UyT0FmL3RveHhWZkE5bTBtdktuay9KSVhHUmdWbGRU?=
 =?utf-8?B?K1RXWlA5UUpEa0VJdHJ1S0RsUWZvNkFYa0trK20xWldWM1czSWpHZDFCSzhU?=
 =?utf-8?B?M3NWNkZxSFZFZW80VXJjUEczbEpkM3pWR1E5UXV3TWJjd0Uzd3ZsQmNDYk9o?=
 =?utf-8?B?NTZudHpSajlwU25NR01OY1ArSHJibTd4TXZmMElhZi8yUlJ1MDIvbWJoOXpE?=
 =?utf-8?B?Mm9Xb3FjYk94ODBkUkZDZmo2NUg1UHdTTk5haTF4bkd3OE02blF0MjV4eVAz?=
 =?utf-8?B?TC8yZW5DWlE4QWZKQjZWQzZtblZJMkVFZHBWMTVoOExSNW9lclNvVjhqSzMr?=
 =?utf-8?B?d0JKMWlRMGxGaUwyczRMc0dpVkFRNGpGZDJmVkUzTy9rSHVJdWtkWkQwM0JK?=
 =?utf-8?B?SzVmZjBhYXZhYUs5Y0c1OTZFZ0xvMTlwR21zNllEWVJsbDVsNEdrQVBlSUo0?=
 =?utf-8?B?eE9IaWZrSjlZVnd2MzJkR0JTYlE4TU5OdGpiZy9GaTJObEtRYmg2OFRBYzdX?=
 =?utf-8?B?VmRpa3F5ZkNJMzdUalNMcXIwN1JuVEVMY3g3b0ppUDZQeC9DM2hReHBhS3gr?=
 =?utf-8?B?WlFVb08rTE1iMWhETTJhdVh5QmVCSjJTa21BNExmNWQrcmJKUVFTNCs4aHBV?=
 =?utf-8?B?ZEI4aEwzY1Q1dFNjOGtIdlhRUXQ1dUxLNnhvSHFiLzZEejZGaEh5YTlFQWJD?=
 =?utf-8?B?NERDRzZNdmNDZGdJZmtWYm40UUZSMUZ2Sm9DNUVHdGRCNmptdjVsWXlKc2JI?=
 =?utf-8?B?RjdyNml6OHBROVZFclJaQ0dRSDJJZXZYOWlNMWkzcDVDZ2JFWngwcWhPenlv?=
 =?utf-8?B?c0x2c2dIaVM0Nit3MmwwRGFyNTAwVWl4NTQ3QWc2ODc1dzlXWkRrTXhnYUN6?=
 =?utf-8?B?bTJTRzZiaDFzdUxFV0VSZ3IzYURnMjBPMHBtREc1SXJCdXZ6dzdvc3RtcjZ5?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d070b8-275b-4bba-643a-08dc8b07fc92
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 17:49:20.0159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hkgo6B0H0NWnESDF+CbLjqcoBlMMhxTZF3wuOXoO7GnLVTJsAAOyCmqs2llkBJimn8x4Kuo2mDG/O7epdlcXp7SP3euIzltNmDSPHmSVVhc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8123
X-OriginatorOrg: intel.com

Hi Sean,

On 6/11/24 6:15 PM, Sean Christopherson wrote:
> On Tue, Jun 11, 2024, Reinette Chatre wrote:
>>> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
>>> index 42151e571953..1116bce5cdbf 100644
>>> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
>>> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
>>> @@ -98,6 +98,8 @@ void ucall_assert(uint64_t cmd, const char *exp, const char *file,
>>>           ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
>>> +       ucall_arch_do_ucall(GUEST_UCALL_FAILED);
>>> +
>>>           ucall_free(uc);
>>>    }
>>>
>>
>> Thank you very much.
>>
>> With your suggestion an example unhandled GUEST_ASSERT() looks as below.
>> It does not guide on what (beyond vcpu_run()) triggered the assert but it
>> indeed provides a hint that adding ucall handling may be needed.
>>
>> [SNIP]
>> ==== Test Assertion Failure ====
>>    lib/ucall_common.c:154: addr != (void *)GUEST_UCALL_FAILED
>>    pid=16002 tid=16002 errno=4 - Interrupted system call
>>       1  0x000000000040da91: get_ucall at ucall_common.c:154
>>       2  0x0000000000410142: assert_on_unhandled_exception at processor.c:614
>>       3  0x0000000000406590: _vcpu_run at kvm_util.c:1718
>>       4   (inlined by) vcpu_run at kvm_util.c:1729
>>       5  0x00000000004026cf: test_apic_bus_clock at apic_bus_clock_test.c:115
>>       6   (inlined by) run_apic_bus_clock_test at apic_bus_clock_test.c:164
>>       7   (inlined by) main at apic_bus_clock_test.c:201
>>       8  0x00007fb1d8429d8f: ?? ??:0
>>       9  0x00007fb1d8429e3f: ?? ??:0
>>      10  0x00000000004027a4: _start at ??:?
>>    Guest failed to allocate ucall struct
> 
> /facepalm
> 
> No, it won't work, e.g. relies on get_ucall() being invoked.  I'm also being
> unnecessarily clever, and missing the obvious, simple solution.
> 
> The only reason tests manually handle UCALL_ABORT is because back when it was
> added, there was no sprintf support in the guest, i.e. the guest could only spit
> out raw information, it couldn't format a human-readable error message.  And so
> tests manually handled UCALL_ABORT with a custom message.
> 
> When we added sprintf support, (almost) all tests moved formatting to the guest
> and converged on using REPORT_GUEST_ASSERT(), but we never completed the cleanup
> by moving REPORT_GUEST_ASSERT() to common code.
> 
> Even more ridiculous is that assert_on_unhandled_exception() is still a thing.
> That code exists _literally_ to handle this scenario, where common guest library
> code needs to signal a failure.
> 
> In short, the right way to resolve this is to have _vcpu_run() (or maybe even
> __vcpu_run()) handle UCALL_ABORT.  The the bajillion REPORT_GUEST_ASSERT() calls
> can be removed, as can UCALL_UNHANDLED and assert_on_unhandled_exception() since
> they can and should use a normal GUEST_ASSERT() now that guest code can provide
> the formating, and library code will ensure the assert is reported.
> 
> For this series, just ignore the GUEST_ASSERT() wonkiness.  If someone develops
> a test that uses udelay(), doesn't handle ucalls, _and_ runs on funky hardware,
> then so be it, they can come yell at me :-)
> 
> And I'll work on a series to handle UCALL_ABORT in _vcpu_run() (and poke around
> a bit more to see if there's other low hanging cleanup fruit).

Thank you very much for explaining these details. Next version intends to address
all your feedback and I will send that shortly.

Reinette

