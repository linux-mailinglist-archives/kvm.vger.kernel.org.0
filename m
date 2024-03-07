Return-Path: <kvm+bounces-11230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B55A874543
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:46:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EC431C2117A
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472D01C2D;
	Thu,  7 Mar 2024 00:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LbZx6O4v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6961879;
	Thu,  7 Mar 2024 00:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709772410; cv=fail; b=oSy4CRzxKH4CtP0fflWSC9cL+wROdFXhfLnuZZUUtqwf9D6DbTyZ6JHOIkVAWzRW3q8CYGEQd+56mHKos9D8AmAVdTMkVVmRpS+/HeDdiqcI8B3kK6XgQeQ34egVhLK1/Jfymd5NHNsXXOTu59Ms1gDFNsr3n4uSLtqAXIW014E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709772410; c=relaxed/simple;
	bh=Q8Im1+vP9UWH8cNMulXiw+K3KcEDcJWPLqEACo3yBrU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sUS+t8YUXUZyh5/Z+mnR98kvrSbIFItvC8JTlxS91YzymbDemG63oYfR3AZ1pT5w7WYaJOMV6Fbg9vXyuRqTXfzl/QNPFf05ZdvdYHTel9Tiuexu1bHmtAUovnlbQC88ZIkhTrPSmUPg6/6Cyop1WwCmDznbhwZMdBCNo28E/yg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LbZx6O4v; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709772408; x=1741308408;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q8Im1+vP9UWH8cNMulXiw+K3KcEDcJWPLqEACo3yBrU=;
  b=LbZx6O4vbdFr0wBQemEiODRhFEV2XbDkKJ4gFxr3+WKAW5Sl65P0U2rI
   vpEHxdiksnXvh6QS+o/yqtvyj/7QPY8J1ag/xdeR+BT3sQKo05DEpi+7q
   5nBGG6hcjz0e7vYX+Gv0quuCciv0j6r62d+6N8UJ6nIEExy2sRz9WQMM2
   DRcpQDHdTpPzGMGq8UNTN8e4ZhrgCOUnrLMZZcMUmRiYp7jNG17+DbqQu
   s8b5ncJIQiaowK28hIKP75+Ou3eYn3fC2p6qAtNduazRwLzz0JwvzwepP
   ViXVM6o66MHi8wWVDQtAbvQNKb+66PpBgZj3SHK21holBq7nh6ZUL4srr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="14994281"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="14994281"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 16:46:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="40915942"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 16:46:47 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:46:46 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:46:46 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 16:46:46 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 16:46:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3AKzHQF6zag0uy6V5YaZYVIhQboXgu4IG0x/zTKNtTKCV8rUPpGvT6VUeCvVfD/Zz3H5TQm3s9j6QMjJ5c9IIM/lhYS19+sMOjbE4DcTERSUwbS/SJSkUoX7s4z9HhbLzyzl/mW7lZnp/Ha9R7CXlA88dgmdWf+pBuxxs4iDuv6G6KG+Y6INHOE9aFupHsfDGYqGQiMhSC+4nQTj71LBSpsyNLFVmp0dg2StUTSvsC0/ZGdHXHyOFM2TNG6oR6NEXaTZsNOW60wl39TYMzOtGY3aUhNrf88AaaGjjtn+cE8L//U51V+f3WQtOCwvkCI5oz/eZaIP79Eeb6iG8lZ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMaTuKTSWWP4kj7Z8v/f+UK03gQKV8czEWK2Iwrcik4=;
 b=VlGql+su1Ykf5mCQMD5lV56Gd058fkVXRDO3F1Jx5VOKXOVGk+65QlFw9kP8nxcUmrfCsSsm+oZf2kQZeKh4KKY5jCKLNdrf3P8KwTXwIs1/NvrOQlXK3NOEZFWl3zwlaAwuMqaL8XYxfoz5ZCfn50uT3n/OOvA68y17/yVzSkOQNIEcVc1RLsp2w4lpnvFjp5fjlfJR4RXMV+AjKRNwtDh/pQJZu5FfoaGUqnfGCA1N8HeQ3BgsF8FUpOqOEMDgrhZpA+qtceMmn39y6ipz8/te2e+o2ueRPAEeG1XNIgk4uLaTdAeohripEyIjibkcM1SOpImhRzPBsOhLUatv6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6728.namprd11.prod.outlook.com (2603:10b6:806:264::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 00:46:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 00:46:44 +0000
Message-ID: <6b6f79df-a099-412d-8a84-06692e77f036@intel.com>
Date: Thu, 7 Mar 2024 13:46:40 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/16] KVM: x86/mmu: Initialize kvm_page_fault's pfn and
 hva to error values
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, "Chao
 Peng" <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, "David
 Matlack" <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-16-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-16-seanjc@google.com>
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
X-MS-Office365-Filtering-Correlation-Id: f23fffc4-c5ce-4f47-cacc-08dc3e400fcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BSprQM0yLrXRiszAO+AJ0gePPA7ZCcnE/vbSZLQGApXgVJlbODsL8LwoCyiUeoBnzcHOzFkwVD9FT4bu2Q64OxO3k9hrhsPIfS8Y5ahFK3H2Yyaq94Bkd2qg7J8+pZDTkZQbXxOvGidZce/Cg0+bv4MvUT8oxYyoY4GAqXc6MHDZ7giWX78PaH15rS6+ZZSUPenWu/HtpLk9j/DFDCuJ5rMK2VF0GvT4Gtkx3CdZh0YJDcpK0r645bDkm/uPsbIIUCwXK0KbWnsBOTmDtxJyP3IiaFNhv8V1t1V8maqcZ0a37P0oLqnCrSNW7RB1PDh8+oVwRu+bsw9LmmAOsr7G/0at21cwKOOdTaO4f8edMbY8kvs2VZVA6zhmZ2sqxWg+oRT5s0R5S/YdvIxmvxa3izrzk9QIDk7z24cHQuVk2aEgcP+ho7TrdWyeczOejUVaiBJggk78xqjfF9epGOG9zVVZkCMUo14UuJ+ZSr2xfI399QfJj2bZwQj15JyXGHLB5AScrkd2C82jt1wM7oFEfMsNctyoGCtumfhWJG8WFU2OUuH0ifRBPg9wndZAwHeE6vl///+csigvqXF+dsOKA+DVQXlRmQilPrOTe9Jc+amm3feJB12S/CXvuVSfXmnAoYw/qPyl+XNEHvL2NXMBSpSGlmaEo1e5ny9kL2sOBWo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZENIYXVpOUZTbmRkQjFJdm5qdTRuaGdvQjFhRnFXVC9ZQUJIYkdOOWs1empp?=
 =?utf-8?B?WnBzY3ZlUGpFaHlKUCt2MGNWZ1NFU01VWmNhV1FSdVJHcVVmNnJzdDRnb3or?=
 =?utf-8?B?NnVmWjkzZlYwY1lURlJVaVh2RzAwTnhiMTJibEJmVGRDNld0TEQrOTlYakRR?=
 =?utf-8?B?ZTRuQUk2QmRMSHl3OFh1NktqQ1psSWd5UDRybk45bldKWHJpNmx3Vnh3RUtp?=
 =?utf-8?B?Q3pIVWdEWC80enRqSUl4djhmcXNBYncvTG5yNms2NnQ4bGRPQ2p5L3BtSW0v?=
 =?utf-8?B?aXA0TFFOb2VtT2hNYUJMellOVmtYaWNPUFg3ZStmbmhQTDBqM0tTbEhNdFRK?=
 =?utf-8?B?cGl4MWpuRzNvdHhuWmwvMGhNT0RaSWZCUWhFMXJhNkNTNWMraXBqUmRLclkv?=
 =?utf-8?B?QTRWQmVHMHZSTUYrQStZaVVMQjNNSGVXZGQ2eEdQc1hKZEdwM3o0NXhQejNP?=
 =?utf-8?B?Y2pnSlg1V1dMT0VyQzR1TW1zM09RQm96dXp4dkQrSU4zSERkTG9BSjdoR1ho?=
 =?utf-8?B?MDlvVFBqamJ3N0xQOXdWV1VjOHdTVmFuQmREdEFwRmhPNGlZVExoQ2RObWVY?=
 =?utf-8?B?bDE4eGlEdC83NEpZVXlFMm5QMTY4ckpoZVZlVEsyYVI4S0lRY2xZdGhOcVIy?=
 =?utf-8?B?NmlKVlpFVnhKWC9SVlpvMXFpN2g4VElTMW4renJDeW5Qd1pHcFZ6ZC9Cdjdp?=
 =?utf-8?B?WUtyMmh1bHFNZm5rc0ppQ3JYdGdHdEp6Zkx4ejY3bjdkSkUwTzhVaGQ0Y0Iy?=
 =?utf-8?B?SFQ4ZkxCMkdZeEdRbjlkZEF1eklZeE9jdnIvUU4wajZxUkRma2NsaVlMUVQx?=
 =?utf-8?B?d1VtemxnMGM3TmJzbVRsRUFHOFI5Wm9vYmRudHRCZ1dhWnVVUUJNQWdLOUFt?=
 =?utf-8?B?TERvTXFONnlRRmNMdTQ1NkNsZlo3S01zVmp3REVuRGxsenpiajZMVHQxVDBR?=
 =?utf-8?B?QkFWVnRMRzgxbTBTdFpqbi9jZkFmeVRHNlZTc2ZLelR5U3FxRWtmcVNVbDYy?=
 =?utf-8?B?N1g2bEpFKzNXMWZDNkswZEd5ZDBQbFAvWlJUZTdGenY1RU1NbXk2THIxaTFQ?=
 =?utf-8?B?ZTVyODJZNkZLLzkxbFVJUkVCdzc5S0k0a0ZRd01WY2l6MVFXSW5BeVU4Wm92?=
 =?utf-8?B?S2hhSzBpOWdnMkRhTVkvc2QxOVNoUWhuTlJNTjFQVTV5REdEbTNBaUJTUVpX?=
 =?utf-8?B?eGh0UHplYVBtUGg4cU5hNmNPN2crSmFnMHAyVWw1anVsQ2dNWDBQN2tzTlB6?=
 =?utf-8?B?cndqN0xxRWhnSzJMOEppRHdMY2pEVFJiYXJtYU9tY0R2OThoVjNlUTM1UXcz?=
 =?utf-8?B?YUNCQk9qTkRDeEQ5NWFSYTBpcmhUWUEzdnl3czVmQjByRWNkSUxaZk1OVDBm?=
 =?utf-8?B?YWlzUlF0Nk1SSlBYeEsrRS9xaUgzUlF5ZEV2cmZZSmNEeW9LTVVTRVVuaWZy?=
 =?utf-8?B?MFNKSXJ6b01uMXBCb0J5eFdQSytXWDh3azhNSnAzSkFMWk9GTGVielZmZkdY?=
 =?utf-8?B?MlpWa2UwVWtlNlJXZDFYSmtRdWs0aS8zcTNRNFNkNmVFWDQxbXpFcGVuVVlQ?=
 =?utf-8?B?QVJCSjM5NlZYRzlYbHlhWEJXcFE1dXc0YWRyblBtcytjd21wc1dlSnNpTzZo?=
 =?utf-8?B?VjJ4aERQa3ZPNUZKaGpjbUNKd2puU0NGMFIzbnNoaGQ4d2N3dTFuM1FSTjli?=
 =?utf-8?B?Mk9HYUNpVXZNSVFJRXJ0TGlhZVdMQ3ZWcE5UZXZUaUtjVTJTVkpiNm0xNG5h?=
 =?utf-8?B?Z1hGMHlJRVcyTTRPVzJva09yd2J4YlhZYy9McnhpdDZUeW1LOXQ2c0J5d0I3?=
 =?utf-8?B?OGhxNWJzMjA5dmRlK3QyRk56WDgwbEk2VVZsb0JYVkczaytMSVlwVzJ6d3pr?=
 =?utf-8?B?cDd1dmhrZGEwdDRHQUhOU3dtNVFBOGd6dFNQY1o1QVZycnVqb09tMndzUDFw?=
 =?utf-8?B?V1RCT09hZ2JadzE5Z1E0aVVJaHI1bEhCRkM0dGdXY2pteHZtUlcxTkl2SHE1?=
 =?utf-8?B?WURnd0NuSEVrSFlkM0VFenhyMnRycmxmajAwaVF3dWFqS28ydTFMcERFK29B?=
 =?utf-8?B?TzlNSzNLdjRmdkR5OWZFMS9SMlpleFhQaU9heUxSb2lWdTNmWEhhRUEwNWpJ?=
 =?utf-8?Q?b5KmQbelYibWF5ab/EcwvC+ac?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f23fffc4-c5ce-4f47-cacc-08dc3e400fcf
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 00:46:44.5296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JG1Tklyg+vZGr55U1coPXDnPiNpym2emfv6nDnt3I/xBq7jZp///B3nH63qLYBaLxdeKcuOfP96V9xYhEwDP6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6728
X-OriginatorOrg: intel.com



On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> Explicitly set "pfn" and "hva" to error values in kvm_mmu_do_page_fault()
> to harden KVM against using "uninitialized" values.  In quotes because the
> fields are actually zero-initialized, and zero is a legal value for both
> page frame numbers and virtual addresses.  E.g. failure to set "pfn" prior
> to creating an SPTE could result in KVM pointing at physical address '0',
> which is far less desirable than KVM generating a SPTE with reserved PA
> bits set and thus effectively killing the VM.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu_internal.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 74736d517e74..67e32dec9424 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -307,6 +307,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   		.req_level = PG_LEVEL_4K,
>   		.goal_level = PG_LEVEL_4K,
>   		.is_private = err & PFERR_PRIVATE_ACCESS,
> +
> +		.pfn = KVM_PFN_ERR_FAULT,
> +		.hva = KVM_HVA_ERR_BAD,
>   	};
>   	int r;
>   

Reviewed-by: Kai Huang <kai.huang@intel.com>

