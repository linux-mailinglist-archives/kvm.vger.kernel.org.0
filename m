Return-Path: <kvm+bounces-19829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D72F90BFDF
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 01:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83D64B21FB8
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 23:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C64A199EB0;
	Mon, 17 Jun 2024 23:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="La5yroiG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2BDDDA6;
	Mon, 17 Jun 2024 23:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718667864; cv=fail; b=PrNT5zPbWcVzmOiFtXjtxuQohRkrwMU8XR3q8NgvWZMXzw1eBr0jjoxm5mpGm1Y2wzIgjwySBVxFXGD387bd2tizpIu17nr8ipHSOA4pzd49DzPOygq8YAXHFTwYH+y8YauJQGv9p9VuoqseRr0e2/euUK8yRqgPlFEsxku3gxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718667864; c=relaxed/simple;
	bh=sjFWunXfeunWVwuHnzqIRXWcoe3xR9/D1tRZ7nyXrrU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BVZa1bLsEn/SMFkE2M9ycmLzGFBOyqsv5GLj0Quo/qS3+3h1nXHSMkYd98lJzJq7+FjszQFzXPd/lR30u+bSQx+WYtTQb5AFrGEKzDmZ5Xxe2P2oXj+i96UDybHVSgu3qaA937sf6G2ZCO+dO3zQf5lolM98b9k2+tizi2I5JIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=La5yroiG; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718667862; x=1750203862;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sjFWunXfeunWVwuHnzqIRXWcoe3xR9/D1tRZ7nyXrrU=;
  b=La5yroiGlf35nzCmpWxfoVsVyM/9/gOTz56thrQmpC3/Xghm1GjdIA7Q
   GYHmVro9r5cMi2BiwmirNZNvoCn8NcdPsPkl/90PATLpbg4b7jqe4jHwi
   lgupPZDbLK7KhgvsZCNYT0iN48qy7NxTIGRy2z73PyKOOmrmF532EaLJb
   06LVF2TeW2wY6nlrjcVg6ejUZE9K+yxVnoULa/Mp5mkKfMMx3BMcQvOu6
   koUXOZnlHCQ5cykjj2vtNd2j/5/1c/6w4QyKHRCZtMbV0bZew4x/3fM+F
   T9inPaTEJMFIc/kCqSDWVPWzbZ4um1bPcO603+5iKDCPOzbwP1oFArCZX
   g==;
X-CSE-ConnectionGUID: q6375mVOTHq4YsgeI27akA==
X-CSE-MsgGUID: cucubrmOSFy9t1jqZ6QfrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="33055897"
X-IronPort-AV: E=Sophos;i="6.08,246,1712646000"; 
   d="scan'208";a="33055897"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 16:44:20 -0700
X-CSE-ConnectionGUID: HhROUWP3TlqS3wLhT2VyUg==
X-CSE-MsgGUID: jiIvDdMUTUScJ/a6gbubkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,246,1712646000"; 
   d="scan'208";a="41291122"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jun 2024 16:44:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 17 Jun 2024 16:44:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 17 Jun 2024 16:44:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 17 Jun 2024 16:44:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNXlEmlv/XGmpObTHIM45XtRb3wZ7nVdz2PsdUqj9ng4bpNOhGALdEC7elV7YCAFmEtxtrw4Q1ULCuhJ6ZaafMaGFuN8oi9pN+WzqcZdqNcHh06b9olhKZpqF2SmfE3StcAJqlUsn2ffrCHT4Sn9IZbrkr5H0XYcD7GoidosFEkuIOfyIXLTsiPQwP6SPNWixAQnHq3yMd7u0EFqMu3PCdJShg2cAbitzVdFLfS0aBVSYOHiFqKLrDeqEpIsptuAwacOarN23tFGSPA23udmge/me8DtxM2secqXEpAzoRiCnSXb+RdLEqPsHd7lxGusl2wpLYQNHUeyYMfRzYtyYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EuqBYo6h3zOu8GheQ6VD8VJHRTxvHXcHlpY9Kmq1Aq0=;
 b=Sciwm+9H6VUwDsKtiaNucvmZcN/BdgtBZY1orW390iBFCSTWlqMSwBDFQ2dA0JgpXu6fFmAs0uCnxa9oNGUH/QHdakQJcTnPRsZvkm/4mOKwItXmLPxOR3WVRtqBgYyFR3fYtnJIjrWl4tYlAhixFEaBB4kF9LjcYIPYMnI+BAm0ngkh5zBfR510S0mxJIRPmKokNP7JisPr5+MK4FMCV+1PR3Z0oqIJK6CJNQMHHOWijAceriYrPPyfrBMJLBxADvsgcwzRPGzorN+1syOmokNdrmGRHep2KHlMlLUMvYfeGPAvNTcZtCqTmqfU4xzL6WYmUYYN4EpOMrXr/aqljg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5077.namprd11.prod.outlook.com (2603:10b6:510:3b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Mon, 17 Jun
 2024 23:44:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 23:44:16 +0000
Message-ID: <5bb2d7fc-cfe9-4abd-a291-7ad56db234b3@intel.com>
Date: Tue, 18 Jun 2024 11:44:07 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
To: Sean Christopherson <seanjc@google.com>
CC: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Bo2 Chen <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, Erdem Aktas <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <Zj1Ty6bqbwst4u_N@google.com>
 <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
 <20240509235522.GA480079@ls.amr.corp.intel.com> <Zj4phpnqYNoNTVeP@google.com>
 <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
 <Zle29YsDN5Hff7Lo@google.com>
 <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
 <ZliUecH-I1EhN7Ke@google.com>
 <38210be0e7cc267a459d97d70f3aff07855b7efd.camel@intel.com>
 <405dd8997aaaf33419be6b0fc37974370d63fd8c.camel@intel.com>
 <ZmzaqRy2zjvlsDfL@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZmzaqRy2zjvlsDfL@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0378.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::23) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a72b6d4-df2b-4aa3-9795-08dc8f276672
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WHlKZDdRMFdPMSsrRkpvdGpuelhUVGZ3TSsycjlqS3BxekJUbWJkR2RNejc4?=
 =?utf-8?B?UGxNcjBKQzJWUzMrclJYLzhCQUgzUGhtQk5xYWc2Sm5Tbzk3cGtvOWhXd0wy?=
 =?utf-8?B?c1E2bVoyVXdkTU9NV05PdThKYWUvMTQ2MnhUOXZoUVBhSGhybnRHMmxEYjlS?=
 =?utf-8?B?Zjg5bC9KaDN5N0FYZ3JScW1Ga3o4UkNvYS8vSHdvcWJLdlNoTnhWczI3bFp3?=
 =?utf-8?B?QTR0Z1NRd3RSTEV4b2JUMHc5UTJwVXE2ZmE2eFhnR04vaTM0RUs4WFg0aHZE?=
 =?utf-8?B?THcyR29TSVF4eS9vaHBvRk9TSjBhWW9ueGI5clRPTlMvVys2clY3N0hKeFdR?=
 =?utf-8?B?bDdPa1BobmNmbXRYOCtHYm9iakM0WEthdy8rZ3FJWnQxT3c1OENjaHZQbGN2?=
 =?utf-8?B?djBxYnQ3NmozNmNhWURmUUNYNE82M1VKZWFDRVNpaWNMME9HV1I3RmxFeWpT?=
 =?utf-8?B?YkZtZGFtaGlUMkRkN3V3cU5Najh6QTVweDZoaXFJbGwvYkZvWkRjWFE0dzc5?=
 =?utf-8?B?dk1uMEtISDVzR0JuY3I4TU5MK1NGZTJMcDJoRTVobVY0c1FlaVY1OEEyUFEx?=
 =?utf-8?B?YUlzTXNscDNkK2pkRzlraW9XMVgvNk9DTHMrTzlza3hud1BSWUY4Zmk4ODRQ?=
 =?utf-8?B?OXNoT3ZDQndaL0UvSXBwcUlRMzE1ZFQyRlhRa0JVTEVsVHdUdjVValRTKzFt?=
 =?utf-8?B?WlZ0SVAzSHV1TFBIRU9vdEthU1orWmRXdmxqdlRjaS9BM3I1SHZyZVJ5amZp?=
 =?utf-8?B?NDlwcklVZEhGbU9QbmFOK2M1RXpxUWtUM0Ruc01QclVhMDRYbXVGT2hSTGZQ?=
 =?utf-8?B?RWluMFFtVlR3bWNWNWUrenpPVndTNGlrckdxazAydEdwTkh2cEgzNlZWbSt0?=
 =?utf-8?B?dklTZ0lpVit4OTBHVVlaRXZjQk9tREhSSXNzSnh4aUF0cGhxQU9hSTI1SHJn?=
 =?utf-8?B?UExqMng1L21PekdRZnYzMGZiNnd3RVB1VDVhNmhodmtyazI4OGVFMzdqLzV2?=
 =?utf-8?B?dDVnY2hubjZQb2RQdThSNE5VSXRkTFIzdnBIbTBRTEUxbWR4NWJYZXpuVDQy?=
 =?utf-8?B?djVmcERlLzdaZ28xWDRZeWw3MDFxQjN1clRVckxNQzEvaWl4SVFBa2pJQTBx?=
 =?utf-8?B?RW5nTmJvUlhVMUFoVjhndjg1TGFsa3dWSm80REFDRUNIQjRxMFNmZm1QWXdr?=
 =?utf-8?B?eE45UFBldDJDMmR3SWR3bVVKVnBwd3ppRmoxUUxuTzFjVC9QTHNDZVhuVzNK?=
 =?utf-8?B?RTZQc3lJRGhmUG0wT2I3VEcweU5zd2FqY1Qza3VaRURETUVEVkh6ZkhtbWpY?=
 =?utf-8?B?NlNHcURjQTM3NHlCNG1iL2VSWTc5ZGhnSTFFWmNXQTNvSWRMdnk3WWxBdklu?=
 =?utf-8?B?dmJ6NzNtM2lTTGVpemVoZXRMeTZCaklLc3ZHQ2NZQmdaYTNDYUNJOWRPOWhU?=
 =?utf-8?B?Z28rOER1b0dBY1ZvL0V1bzBVOHR0bnJZWjZjS3VOL2gvQXRvMFpjcUdHQkF2?=
 =?utf-8?B?dlVyR2hMTkdhWTNXZnY3RFVXSTJjYVpaSFNsWEYxSmVZMmlRelJFNWhET3Fp?=
 =?utf-8?B?U3ZiS2IvQWhySWQydmN3SmRjU2NXbWhYTEhPZWVJMjNLM3ppNUVlaGRzZkc3?=
 =?utf-8?B?RDQwTGlDSnZxTStZeVhMNXJ5Q3lLSDVYR3VxM3haUzI0UWwzMzByaS9FUWlu?=
 =?utf-8?B?VFptT1cyeUNzQ1Y0ZHFkSENjRmJ3LzBuRnloWk5XMGpHSDhFdFhBS2Qrallt?=
 =?utf-8?Q?P2r4xTPVbcJbUPfEuwUUX5cDyhDEraP+A+pBXbE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkJBSlIrdExNQ3lWakFEUm8xMkRXdVIyVS96bG5Xa0p5UnQzNkgrZUhBYkk3?=
 =?utf-8?B?aVNkWjhHU2Fva3RhekhnZWJBSkRLU2FxMXJrNTFEUnhxWkxnZ0xBd1VtRWRH?=
 =?utf-8?B?OTBYVWZvSktlSEVwbjBYL1BjeUFha0lLbHZrQVlPMFpPNXh4S0xkbDkyQlE1?=
 =?utf-8?B?RWF1TnFhbE56Vk56bmtsU0RaN3JIUlI5S3VNNVJOTmJ0UlI4RTNoLzR5MGFC?=
 =?utf-8?B?WXp6LytqNVJkcm5kWXJVSm9jY2l1UW5GeDIyNkQrQkJ2VUdPc0VPcnJUV0RG?=
 =?utf-8?B?OGJ5YXlRV2xyTTdGNVpHVmVjcUx5YkNwNC9rbG1pU2xjQzVnQTJ0RWFGOStq?=
 =?utf-8?B?MHFNeHhQQy82elZVNHZmaFZvbnFDN1pVWERzRmNvMXg1amhKQkpoS0lTR3Bl?=
 =?utf-8?B?R2FUWGhMK1VjVFl2M0ZBenk3V3Q1Q1Jlb2U3NGFIek1UZWExMVdvaU1KZ242?=
 =?utf-8?B?TlhNSE4zc2VCRXBLZk5CamttUlhMS0Q0N2Q4OWpFaWUyN2V4NzZ6NW5SQ0Q3?=
 =?utf-8?B?VFd5MUFkYVpCUFpDMUoxbjdJTlZPZmptU3JCZTJPRE56cG5HS1NiU0NyZy9B?=
 =?utf-8?B?bDNGdm81RjY2Yjc5aXhxTnF4b3MyRys2aG1Cblg0RVJIVThtOC9DR3hpa2I5?=
 =?utf-8?B?eG5OZkNhdTJoelJMU1VVSHVFNnhIaHdGRWkvOEl1eVJ1VmJ6QUE5cThXbjhw?=
 =?utf-8?B?Wkg5RER0WjRVVHFGdjRPZ01TV1NFZVkveUQ4cHhrOWZGRC9BbGxOcm0rZHZr?=
 =?utf-8?B?L2RXdWtGZmVERERLSUpCNktFdWhKYzdxSTYwUkZjUnVRZXhsSWlYNysyVlhw?=
 =?utf-8?B?WnhxQ3lSZFZwSllPRzFzSHhuV3Q3NUF2SlAxL0VjQkRTK1ZKSXArKzlwTGsx?=
 =?utf-8?B?V2dQWmxCZUN1OWYxUmg2ZTZxeTQ3eDNQK2tUUnJMT0QvSjZKY1dYc1ZZaFJo?=
 =?utf-8?B?L2c0VE1SdzlqdmNOYW5XSmd6WDlYQnlablZwOEk5VXc5QkRmaUYwQVREK044?=
 =?utf-8?B?cWRFTHlLYjlwVjBXN1V3WW0rRDZYbkVrakpIS0h5d3k5N3FSZmJEZXMrWDlR?=
 =?utf-8?B?b3EzR3c1UmZDbCtQejZjWmt3R2VaTU9ITjZUS09UeXdleXhjZGNWaERGU0Qx?=
 =?utf-8?B?ZjFtQVN1TWhXVHBwMXphaExIMTR0ZGVsTWxmNng0cEh3UTZ1TnNvckkrT3Ey?=
 =?utf-8?B?NmIrcUxRUkZ5TGliQVpIU1RRWkFYMHUrSXNndlZWQ1gvTHNEaEhUZ3pmTmUv?=
 =?utf-8?B?d0k0d2FkTVMxbHduY2NVaDFiRmt4dGVUbFkrQTltQjhaa0RmeXlDNlJpNk9u?=
 =?utf-8?B?KzJoMWVkdTNFYTErbjNiQlhpY3lIQkZhdnZUYURNM21sQUF1ZlFCZmtNL2Jz?=
 =?utf-8?B?S2lXcnR1dXdMcVNlOWRRY0xWMzQyQ2VoNzAvOHhSaWRQRkF5RGtKRy9Ram5N?=
 =?utf-8?B?d2NaQlNncWtTdUVQMVBHMUhZZ2JJSVVTMTJWSVhOeGQ2ZjJ0R2x3d29TR05y?=
 =?utf-8?B?RlZKcktYM2tUVDQyQi8vaUhBa0N2LzhOV3d6Tit1YmdqY01TMXlpSVZDYjlk?=
 =?utf-8?B?SnhmSE1iZHhSSUlDanEyVVorZ0owd2hnSFlZejI4MGZkbEZvVWFwZmgwNk5i?=
 =?utf-8?B?dmdQWjBDdG1vTGZWWHgzS2JVL2ZIVU1QYjR2MW8zODFhYXAxMGFBYXBvMThH?=
 =?utf-8?B?dTJFdWphTVpQOVMwSkdXYVlReXJTbUdEeFQ4VXM5TlNPWVQ3VVE0U1Zaa1hP?=
 =?utf-8?B?RjVxSUlYYXJXaDdpZWg0T0pnRkVuUUg3NXU0a0YyR2l1VTdPTVZaK2w5eEJP?=
 =?utf-8?B?TDdndzRPdmFVblp6ZnlLVVBFK3lJSXR0bFVjSlEvRkVzV2NlYjZHcTNYTTdv?=
 =?utf-8?B?clFZR1RWNEtPL2IrVEJMMGdZOVlTUjJYU0JVYnNlOW00bXUxUTZSaVVhZHdm?=
 =?utf-8?B?TFkvNDFsUWtrdytjUk92aTRqYzduN2p3TXpmZjJqT1JXbnd5dXN0YXAvSWpC?=
 =?utf-8?B?d3VyRUdXVHo0T1d2TUd4Y1ptVlkxQUUwYWdhNy9Ma2FjajdtTkJQeWttOEVw?=
 =?utf-8?B?NWJEaGQxcVZqd0EydlF5STZjOENXVnJFSGhja0d0QXRaTWU3VGllclJRV25U?=
 =?utf-8?Q?S3fnNh5UMk6mnAoqNbcIVisQR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a72b6d4-df2b-4aa3-9795-08dc8f276672
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 23:44:16.6710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kYL8WlvI9TLBCTTdbl7gS94HsRNHqmZA/YZexF6XWkX2Qnlsvh+VKvyfF8sdRy3cnzJ6cXGvMyckVjgFgmg0DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5077
X-OriginatorOrg: intel.com



On 15/06/2024 12:04 pm, Sean Christopherson wrote:
> On Fri, Jun 14, 2024, Kai Huang wrote:
>> On Tue, 2024-06-04 at 10:48 +0000, Huang, Kai wrote:
>>> On Thu, 2024-05-30 at 16:12 -0700, Sean Christopherson wrote:
>>>> On Thu, May 30, 2024, Kai Huang wrote:
>>>>> On Wed, 2024-05-29 at 16:15 -0700, Sean Christopherson wrote:
>>>>>> In the unlikely event there is a legitimate reason for max_vcpus_per_td being
>>>>>> less than KVM's minimum, then we can update KVM's minimum as needed.  But AFAICT,
>>>>>> that's purely theoretical at this point, i.e. this is all much ado about nothing.
>>>>>
>>>>> I am afraid we already have a legitimate case: TD partitioning.  Isaku
>>>>> told me the 'max_vcpus_per_td' is lowed to 512 for the modules with TD
>>>>> partitioning supported.  And again this is static, i.e., doesn't require
>>>>> TD partitioning to be opt-in to low to 512.
>>>>
>>>> So what's Intel's plan for use cases that creates TDs with >512 vCPUs?
>>>
>>> I checked with TDX module guys.  Turns out the 'max_vcpus_per_td' wasn't
>>> introduced because of TD partitioning, and they are not actually related.
>>>
>>> They introduced this to support "topology virtualization", which requires
>>> a table to record the X2APIC IDs for all vcpus for each TD.  In practice,
>>> given a TDX module, the 'max_vcpus_per_td', a.k.a, the X2APIC ID table
>>> size reflects the physical logical cpus that *ALL* platforms that the
>>> module supports can possibly have.
>>>
>>> The reason of this design is TDX guys don't believe there's sense in
>>> supporting the case where the 'max_vcpus' for one single TD needs to
>>> exceed the physical logical cpus.
>>>
>>> So in short:
>>>
>>> - The "max_vcpus_per_td" can be different depending on module versions. In
>>> practice it reflects the maximum physical logical cpus that all the
>>> platforms (that the module supports) can possibly have.
>>>
>>> - Before CSPs deploy/migrate TD on a TDX machine, they must be aware of
>>> the "max_vcpus_per_td" the module supports, and only deploy/migrate TD to
>>> it when it can support.
>>>
>>> - For TDX 1.5.xx modules, the value is 576 (the previous number 512 isn't
>>> correct); For TDX 2.0.xx modules, the value is larger (>1000).  For future
>>> module versions, it could have a smaller number, depending on what
>>> platforms that module needs to support.  Also, if TDX ever gets supported
>>> on client platforms, we can image the number could be much smaller due to
>>> the "vcpus per td no need to exceed physical logical cpus".
>>>
>>> We may ask them to support the case where 'max_vcpus' for single TD
>>> exceeds the physical logical cpus, or at least not to low down the value
>>> any further for future modules (> 2.0.xx modules).  We may also ask them
>>> to give promise to not low the number to below some certain value for any
>>> future modules.  But I am not sure there's any concrete reason to do so?
>>>
>>> What's your thinking?
> 
> It's a reasonable restriction, e.g. KVM_CAP_NR_VCPUS is already capped at number
> of online CPUs, although userspace is obviously allowed to create oversubscribed
> VMs.
> 
> I think the sane thing to do is document that TDX VMs are restricted to the number
> of logical CPUs in the system, have KVM_CAP_MAX_VCPUS enumerate exactly that, and
> then sanity check that max_vcpus_per_td is greater than or equal to what KVM
> reports for KVM_CAP_MAX_VCPUS. >
> Stating that the maximum number of vCPUs depends on the whims TDX module doesn't
> provide a predictable ABI for KVM, i.e. I don't want to simply forward TDX's
> max_vcpus_per_td to userspace.


This sounds good to me.  I think it should be also OK for client too, if 
TDX ever gets supported for client.

IIUC we can consult the @nr_cpu_ids or num_possible_cpus() to get the 
"number of logical CPUs in the system".  And we can reject to use the 
TDX module if 'max_vcpus_per_td' turns to be smaller.

I think the relevant question is is whether we should still report 
"number of logical CPUs in the system" via KVM_CAP_MAX_VCPUS?  Because 
if doing so, this still means the userspace will need to check 
KVM_CAP_MAX_VCPUS vm extention on per-vm basis.

And if it does, then from userspace's perspective, it actually doesn't 
matter whether underneath the per-vm KVM_CAP_MAX_VCPUS is limited by TDX 
or the system cpus (also see below).

The userspace cannot tell the difference anyway.  It just needs to 
change to query KVM_CAP_MAX_VCPUS to per-vm basis.

Or, we could limit this to TDX guest ONLY:

The KVM_CAP_MAX_VCPUS is still global.  However for TDX specifically, 
the userspace should use other way to query the number of LPs the system 
supports (I assume there should be existing ABI for this?).

But looks this isn't something nice?

