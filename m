Return-Path: <kvm+bounces-30262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 832749B8626
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 23:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 119951F21F84
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA8B1DFD81;
	Thu, 31 Oct 2024 22:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zz7ioGDv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5401D1E63;
	Thu, 31 Oct 2024 22:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730414261; cv=fail; b=OJfJ6mtg3XAQ9hUi2ntBR/sii7rswLA9vsrGMmek5w2mVVYc0GOzBdx3GftW+8RQRKJbV8LHR3N+L/NfRRfX2G3Yw4Q6jlUGe2sPRGwN39R8Ixzb4c3/unwzvryn44mETdneFvPbimCFmbz2M24WtRAWGPwUX61y14f5370s3cY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730414261; c=relaxed/simple;
	bh=VKz/y+uiMBQwXwVllc0m5daTSHCjW+BqEb79dNm6nZA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BnuYg1/b/bEfDIzb/lrHu/9wiTxYj+lhkS69FNc+hVeYWYDqJKLsEQtMl7tD/ntZODyK7807QNfJ5/xnYzziDVmqHReWXyz9WDeGO+AOl73Wc/5NZkbC27NarMQiJPqbr1SoI/PjBOToT0jBQWLNZkCg83W9L5IWzmlzbFTKjzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zz7ioGDv; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730414255; x=1761950255;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VKz/y+uiMBQwXwVllc0m5daTSHCjW+BqEb79dNm6nZA=;
  b=Zz7ioGDvl4rp4vTtoOlez5+iaCbyCYn0Bm1yeLNsByFbhMKNRkMhYhgN
   KHbWM+D21JQt6g92lNWeXadyTojAEI+Gat3mFp/tLjAQjEAK91QTRj8gJ
   tKBdyLIDIiqznhAyTYkYW191HjIxgVfRDnTZjIT1idqlC9AhR2r7/M7E8
   7nX7fcA+nTN4IbvJqRD16bR7U2D5+Sf4D7dsoNGDsBayYA57n5vBiWKwS
   uEVfFocLlOfBUOopvrr89+dce202AVGp3jRR4Jdvcd8FaufyENHx5UCN0
   9iisk3hVwWPC+o9fnkg0MXRVUcWvKb3XQGz5yL8zDWo3WEUaK4hN+NCU+
   A==;
X-CSE-ConnectionGUID: 9J5FcYWAQyWQC7a5hq63Bw==
X-CSE-MsgGUID: MadxeRv5Ty+egOPr+ai7mQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52745675"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52745675"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 15:37:33 -0700
X-CSE-ConnectionGUID: szvFZ/PWTmW17AwIN4g96A==
X-CSE-MsgGUID: oKXX8GBJSeu2bXkEJbj87A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="87319626"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 15:37:33 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 15:37:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 15:37:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 15:37:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pTcSP6x7zQdaTW9GxvjOEdk7ECh5HiAlzqRUYA0JAchHp+IQXZrTg3i+WI6SUASYPnvRLE9Di3GsYB9ZHXQ8rF5Xn3EWi8X5+FCa3t9fNF4MyCvnX8jal5l7M97bxYCsG+Dq0no+eDmLEhuCY/kRwQ5cd9n85p37jD25sEWCZBtCpnvOLZwLT98EJd7Hu4wDaaL4DQLBhzO+jTUQyvc7GdW9cWpFxaC9nBMzm29I9Fjo7MZj6zI00wXf2XRXKyPaLkB1lteXJQ9U9zXhi0APU9FqrU7+zr1c7i7jtPpChH0ugyWFibGxlOrguBF7R53QMWAu4feBQWHIBgJWXlVzCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qLZMfsii5brXG2dEtoVJdL8wze/RlvCvSOLeJBGMcMA=;
 b=djhdugEbGHHQgUc6N3pM3wTKgVmCh4vM3BrA/XGEMjffLHcxEyKkhysNo3UIbELGPjo7ylJwSpMZMVBr/VknfZUabEvwUTBEppnIRrpH5ov13MdqbKlhc5I+zyddPaQZQJIntN/xfcPj0gKmWMgMB1PAuMTWicPdnJzA956iX3qVgFXykQXE/4EsvkUCApGMd90gtLPkujzbGn8rs4DOWOQOL/C9QK2j8IvlbehAYB6+0gDETV0670j8w8Ra/shgVq7pnzZBclU1B2GinZtsnYAbnYQ91Mw5F+M/KSPLbYrh35f6v5Lb+kHZ+2ljiecWXs7UzpOgF/999/9lmDwVfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6188.namprd11.prod.outlook.com (2603:10b6:930:24::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 22:37:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 22:37:27 +0000
Message-ID: <ebf9897e-dda6-4e74-b08b-5d266c6c0c1b@intel.com>
Date: Fri, 1 Nov 2024 11:37:19 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
To: Dan Williams <dan.j.williams@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Lindgren, Tony" <tony.lindgren@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kristen@linux.intel.com"
	<kristen@linux.intel.com>
References: <cover.1730120881.git.kai.huang@intel.com>
 <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
 <ZyJOiPQnBz31qLZ7@google.com>
 <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
 <6723fc2070a96_60c3294dc@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <6723fc2070a96_60c3294dc@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::35) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CY5PR11MB6188:EE_
X-MS-Office365-Filtering-Correlation-Id: f69c4f8a-77ac-4bd0-113f-08dcf9fc98c1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RmFxdEVJTkNGejdabmdyUkUreVF5eGdTYjdWNVJKM3RWZUtlSGNqejdHMFNR?=
 =?utf-8?B?UjZ5TzV3VUJqdk1EL1Y0N0k4dHl5KytZM0J2K1NZaVNWdGNJcVlaekJKY2ht?=
 =?utf-8?B?cXpCT1kvSy9jdFVKaVdRdnhneW1tOGdvSWpqZFhxdlhrTUs3NEV0UkZsQkFh?=
 =?utf-8?B?NnhzejhLM25uZzBkZzVuSzhmeU03Z0RDaEFiRXZENTlUUGNBVWV1VHVibDRY?=
 =?utf-8?B?ZDhkNEVsQTJ3V2cvaXppK3NwL1ZmZlYzcmdPYUs3VFpVMlpPL0tlb1FaREwy?=
 =?utf-8?B?STZIVFlJVmRGSWNCOVhsZHJvY2F6NzgwcG1ndHpRSmZNU0R3NEN6R0xUazJz?=
 =?utf-8?B?bkNVNjd2cXhCL0VwMHRQTU55ZXBqNFFxOFR3Sk1Zc0pSSlVXTXl6d1JWNlpW?=
 =?utf-8?B?bDJ6VDUyV0pkamhDTlgxRDNQblJMS3VvajJsNlovSXRqNVcwRWkxNFpsSDlQ?=
 =?utf-8?B?VlZEMGVmNm9XRUdRUG82SnY2WGNEejBCbUQ4NGJCdnl3cUtqMlJ0YmhDb1JP?=
 =?utf-8?B?ZG82L1Q5N1E0aW1BZVdiTW9DVk4xcVNhaElCeVVyMFBkcVJvQ3IyREZqWjlY?=
 =?utf-8?B?VU1YaWdjc2VFMUx4Wm5Fa1pEZWR5MEFVS05Sckpmc01xaDIxSWh0UTRmKzEv?=
 =?utf-8?B?T2h2RGlzcnlaK3lMVXl3VkZSWWJEdG9nNFVaVWEyRTM3WDg1VWFVbG5oNXZ5?=
 =?utf-8?B?RWlaZTVNa2tMWUV0bUNMT2hITW56Rm81bmxLSEk5Sm13ZldwZldsZ08xZ2Na?=
 =?utf-8?B?eEhyb2hwVE1mUXE2UllaUXNML2RVSDJYblEyZ3JlUy9KbzVZS0tDRUxPVkMz?=
 =?utf-8?B?aVJGSVBpelN6ZHBvK2xCeFlpd3cxU0hJU1FTekZSSlpDVDQzTitVMjR3aHNw?=
 =?utf-8?B?VVVJbGlHaDRIc00zajlPQTc3M29nREpQRTUvZ3BsbXlCY0pFakJYaWdqckpF?=
 =?utf-8?B?YVNHdFBZdlRBc2d1RmtwcmJEbzlueEtUT3BMZDQwMXc0MzZ3ZFg0VGRObFpO?=
 =?utf-8?B?eEVLTlNnUVVrb3pUclVGOERWcHJiRHJBVWtQMHpDcjZsOU9XYkJEdzFCQmJw?=
 =?utf-8?B?VU12L1pFWXl1NW5lbFdZdVRGZ0VHOEpnYVJucGNDSksxNCtkejVFVmc2Rmh4?=
 =?utf-8?B?c2wzSVVpUlRrbk00U05vSXptRTVVVEdFa0dtVDhoci9JWE9nc2hYSU9jeXgr?=
 =?utf-8?B?aC9uNnM2cjRJTUc5N0pQUTAxWkhqM2VEQVFIMVZWV0ZjaGtZWkM1VkszZXZp?=
 =?utf-8?B?cUY5dllPZFY1eFlCRXZ1RXN1aGVUeDduQ3NpOGRKQ0NkU1hXczh2ejdpN05P?=
 =?utf-8?B?S2htM3M3bmJNQjhnOVpwRjhRZ0tBUnFGaWhZdnU3MWwySThDY2hNeWpIeGtz?=
 =?utf-8?B?eVQ4NjlYT0FhWnpxTUE2RU42VlBvQVZmcXhFdWJ0VEFrRGVRWHREWE1mbUJk?=
 =?utf-8?B?NjA4S0xDOFh3dFFuS0krcGFUd2I4RHZtb1lhRy92TnV1djVGTWFxOGFzaUg3?=
 =?utf-8?B?UGtPa0dIZWx6R0l0NzZrK2dXSXpwNkhOMENEUUJ6dUpoeFdhSFRNRnlTYytJ?=
 =?utf-8?B?d1UrcnMyS294LzBqMHhaVlhxU2tNWFN4YjYvalYrdURKWUZXaTlBb3ZBQjZC?=
 =?utf-8?B?c2dlU0wzWlhpZDRnS0tIUm5ESndqMmxoMnJBek1ZRW1vTjhlLzRGNTBvUnVx?=
 =?utf-8?B?dnBRa0J6NkFNL1RaeC9kamJyUk5NdWNrUnN1RmM5RTZjbk5OOW1JeitYS1lz?=
 =?utf-8?Q?drX3AG5WXeH6+9aF9U7KcMR8B19NoivcE1qP5+L?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkJBVFVvODR0cDVEYVNOVmZvTkRlSHhpYmFQZEdFTXlUZ3htWHUvQmNRQVpU?=
 =?utf-8?B?VE1BcFNMT0hQOG9MOFpveEwrZ3E3RG5BMkFTVVE4ZzlmdTdndGRKemQzL2Jy?=
 =?utf-8?B?OWU2UWZ2R0s5T1B4NWRzKzRRaVNWZXVGSURvcUJva0lHci9zbkFvVUhRVHY5?=
 =?utf-8?B?cGlHNWgxWm1xeXlTYlQ0R0RDMk1abTZIWU5NZ2R3L3dPZjdkMUI5R0tGV0FB?=
 =?utf-8?B?czRkbVRBdm8zZ0xaL1JXMHJ2QmVvREZGK0VPRVpJbng3SWV4YkFUT1crRlpV?=
 =?utf-8?B?RTQ3L0h4WU92WEZCTjVMNlRLblMzS0EyZjY0NXIzcTNLbkZyTjJ6eTV1NnVx?=
 =?utf-8?B?RWtPbkVqeVNnZTdMUE9MK2hudFBrSjlRT0pkTDl3cTF5TlAybkQyQXpQYU15?=
 =?utf-8?B?em8rN05oaGpOZlduR3JuOWN6TWZIUytBRnZYSm1WWFV2OGZwSWh3dXNXMFcy?=
 =?utf-8?B?VWpTYmVvZWYzMkdIbG9Qam5IU1kxR09LUXRDZi9CUUVtWjFVV3plL3lHZ2Jt?=
 =?utf-8?B?bG1NQVNjNzBLQTlZWk9aV09NbUxUYW1rOVMzVVd5NjBhdUFBazNxcnpidzBw?=
 =?utf-8?B?MDR0cjd5L3BseVpzR3l2dkhGWUVGaTRaY2Noc0RYT2UwSnVpWFk4cFZqWGR3?=
 =?utf-8?B?M1JPWlM5RmdrYVdGazJaVmdXUlNYWklvbDdDc1YyMUtaMzJ2VEdySUtBb1JD?=
 =?utf-8?B?Yno5Mkc4N0k3dG44cEFGNUhzYm8zU21wRklvNG0vN2Z4MnVrYUZpekR5akJS?=
 =?utf-8?B?NDg2cTJDSjRLTEd3WHd4a1lmazRFTndVcHkvT2d1LzJEakxlRXk3QndITGYw?=
 =?utf-8?B?VWczcEYzY0xJMDVkNmgwRitwUCs3WWsraG0rOGo0RW14akhyODJNcGQvby9h?=
 =?utf-8?B?enpFTVRveWkwTjA2bDA3OGRUQ2Iwa0habUh4aHJFNHRLYWMyU0hIZW8rcWVF?=
 =?utf-8?B?RnUxWHcyN2lKekZPTUx5bmExRHlwdFRLZlFWQmUydGpBUDRjcXdmTVBUU1g5?=
 =?utf-8?B?eVhRcGgrU0ZjbUJZaWw1VDhHcWRpb2o2UnlDWFhISEJCaFV2SXhlQVNPSzVU?=
 =?utf-8?B?cHg3L3N4OVlHbi9HMFZEWUVUS29KSjV6VWljanpnZ3ZPMWVTQ0J4SnRMZDlm?=
 =?utf-8?B?VWVURWl6eFRpcStYMW0wMkZMd1A4akNvS29BYjJSek9vdmpOV1NGRmtWdkhZ?=
 =?utf-8?B?dWNocmFkLzB3VVdwcUVBdWhXV0NVYUlBcmdQdDZSelk1TXN5di9ERzBMRm5S?=
 =?utf-8?B?M3lFbVJmWDNORnpSSHhkdG5FTkpmWFEyaFZYUkE5T3hvV0JvaW5Pbnk0UFRU?=
 =?utf-8?B?YXNWdnhiTE00dElPMXh2ajdTMkdNWksvSm8zSFlBYUU5YURvUGU4QUxmcTJ4?=
 =?utf-8?B?ZzF5YStrUG1GT1VmaUlnUG1pbWxnaGRGNFhFOVhhU1VRcm4zN1d4YnhZb01N?=
 =?utf-8?B?eVloZHVFUmJmbmIreHFoSGV5aUZyUUVMVVVxdWd6MTc3c1ZjMG9SNDlEanlv?=
 =?utf-8?B?dDh4TCtmUllHbjhscG5LYVpoaUhBVzVaUm5KSnNJc25tTEhodmJmYUNXcWFQ?=
 =?utf-8?B?akxoVisvWFVzdURWQWNxTVJuZVQyQk9saVNWN3ptMExrenpIWitRalhic1d6?=
 =?utf-8?B?RDhDREhjVmJTUEo0TmlqZDhqc1VwZWxseTViVm5OUlZkeUJZWWdaN1RYMzVa?=
 =?utf-8?B?MjEyTHErR1E2Mi9QVXFzSUl6SmYrbm5ubkQrS0J4Z1czbnhINGdWMkxZNld4?=
 =?utf-8?B?U3VjVlkxVTVtRVdmVkx3MXB6V2ZoN0IxUEllbHZZbTVCeDQ1UFpDdU4wQmRq?=
 =?utf-8?B?YVAzNjg2cFYrdkNaWjRLYVEra2l4M0Y1UDRuV3hkTkx2Mzk3bncreW9rNDZD?=
 =?utf-8?B?dW5xci9pRHMrRjZ1QWM4MHJCd3RBNXdoLzJWVjFxZHlhQW5oS0xyRmVTOWFu?=
 =?utf-8?B?a2h0Q3RHWGJ6eVFiRUwxWHQzS2hMMTQwbjhpdHZ4Z0VpRTBjU1BjOGpBYThF?=
 =?utf-8?B?QmhBMFh6ZTFCc2ltSlBsNUxOYTFjU0RDS0x0Y3IvSUs3Sy9nZ0F1T2dFeVA3?=
 =?utf-8?B?VHJEWHJZejR3blFjYXExZVFvZm9tVFFWRmM2bzRqSlBUMWwwZHJOM3dPOGpH?=
 =?utf-8?Q?b1o0ARdDNi0mhevRB2gQ+M2bK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f69c4f8a-77ac-4bd0-113f-08dcf9fc98c1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 22:37:27.1423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYAOwta9TStHz5nCMMe5uUJWwlu8UelPQK0x+AppcZ5N8cgpeoflCJ6wdCyqF4MAlPYkR7UOEDwht0P/fmdzdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6188
X-OriginatorOrg: intel.com


> However, I want to provide a counterpoint to this "_ANY_ kernel
> component" dependency on being able to run a TDX guest. TDX Connect like
> SEV-TIO offers device-security provisioning flows that are expected to
> run before any confidential guest is being launched, and theoretically
> may offer services independent of *ever* launching a guest (e.g. PCIe
> link encrcyption without device assignment). So longer term, seamcalls
> without kvm-intel.ko flexibility is useful, but in the near term a
> coarse dependency on kvm-intel.ko is workable.

Thanks for the info.

So it seems we should keep INTEL_TDX_HOST but add a new KVM_INTEL_TDX:

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f09f13c01c6b..bcf4a1243013 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -126,6 +126,16 @@ config X86_SGX_KVM

           If unsure, say N.

+config KVM_INTEL_TDX
+       bool "Intel Trust Domain Extensions (TDX) support"
+       default y
+       depends on INTEL_TDX_HOST
+       help
+         Provides support for launching Intel Trust Domain Extensions
+         (TDX) confidential VMs on Intel processors.
+
+         If unsure, say N.
+
  config KVM_AMD
         tristate "KVM for AMD processors support"
         depends on KVM && (CPU_SUP_AMD || CPU_SUP_HYGON)
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index fec803aff7ad..a5d362c7b504 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -20,7 +20,7 @@ kvm-intel-y           += vmx/vmx.o vmx/vmenter.o 
vmx/pmu_intel.o vmx/vmcs12.o \

  kvm-intel-$(CONFIG_X86_SGX_KVM)        += vmx/sgx.o
  kvm-intel-$(CONFIG_KVM_HYPERV) += vmx/hyperv.o vmx/hyperv_evmcs.o
-kvm-intel-$(CONFIG_INTEL_TDX_HOST)     += vmx/tdx.o
+kvm-intel-$(CONFIG_KVM_INTEL_TDX)      += vmx/tdx.o

  kvm-amd-y              += svm/svm.o svm/vmenter.o svm/pmu.o 
svm/nested.o svm/avic.o

One thing is currently INTEL_TDX_HOST depends on KVM_INTEL (with the 
reason that for now only KVM will use TDX), we can either remove this 
dependency together with the above diff, or we can have another patch in 
the future to remove that when TDX Connect comes near.

I think we can leave this part to the future.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 007bab9f2a0e..acc5a14dfbbc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1974,7 +1974,6 @@ config INTEL_TDX_HOST
         bool "Intel Trust Domain Extensions (TDX) host support"
         depends on CPU_SUP_INTEL
         depends on X86_64
-       depends on KVM_INTEL
         depends on X86_X2APIC
         select ARCH_KEEP_MEMBLOCK
         depends on CONTIG_ALLOC


