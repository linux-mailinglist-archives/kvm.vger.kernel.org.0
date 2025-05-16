Return-Path: <kvm+bounces-46782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE1AAB9899
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 11:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7E2F188C7C4
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC7C22F75C;
	Fri, 16 May 2025 09:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A9eTW3kg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E644422E3E2;
	Fri, 16 May 2025 09:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747387168; cv=fail; b=Bb8oazqbIkeEBt87ZdLYR5gRCF0Sf6oJTUxoi90R9iD1LXITEtgnXYBSuD/8igVAGAjOFIxWPKj5/z0jSb/QipeenDESE/I+bWhQsi5VkPpEIhPcxYhWuJeOV7937uY3msZuTfAler61BTAV9UVGgRmfoIMaqZXldLolFDO+SN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747387168; c=relaxed/simple;
	bh=wytrKRpcCPAW8uALiIYC+uRksYIf3XIWywngibM/Cc4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IxCRD9FDcUDu0RlSZwz7N2Nz/kLDtir4BX4HQ0fvl6hL3wK/2Sm+hu+UWuA8G7ngvh96QHZV7qog2QR8EUlZcl731s8KBF6n+Tfrelq4LQfaLPG5OBMTPNX5KXPLyljq/x+NuOMlkH1aGz546hWlS5DXYtCpKyoi79GlANHhmt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A9eTW3kg; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747387167; x=1778923167;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=wytrKRpcCPAW8uALiIYC+uRksYIf3XIWywngibM/Cc4=;
  b=A9eTW3kgoYz8K/OLWde2ueVaYX1YzHoh4O6sohgvWmOJ3jc73MzYsayA
   HjrpAR45nak4VvSSqB9Kn1BeeyaI6sRzCCdVNHmfadHrilReSw+js8NAw
   F+DLYBS0JEUv61PVUefEEsbeZwxNqIHARAF1T/UhtYhXIfzUFrNV0GvHI
   gmShOntanFoEOkqYwdQy0sKmkQRXte1+dK9H9c1ZLYRaTbopNqXt1iSFX
   l89ST5LpfSP2vun7dtlj5QgmXsYn4Kf/GNVPQsTwFpJk9AwG2bl+gJbC2
   OHkih1SwA5Plf1ystLcTh0oPkighMWkrRRbzu/+KE5mujF8wD+ENSy6qj
   g==;
X-CSE-ConnectionGUID: e96MRelnSAaa4HkSaHHWtw==
X-CSE-MsgGUID: guVrU6IaQsWKx4LGBE64hw==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="59583521"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="59583521"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:19:26 -0700
X-CSE-ConnectionGUID: KKtDf59PTdW9m7GJphc4Ww==
X-CSE-MsgGUID: UOIKg3PIQWO8jL4Y+8noCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="138689112"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:19:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 02:19:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 02:19:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 02:19:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+IP2F4Ot0n1bBY9dRTsACxYh2Wguz2g0DohBElSsSd1yILYi/+aQBoPPJ/3kdki9ZqfDpaU7OM/WBtVp2+HaCJw0x6Y5BppVFrK78tKpRjvpapUyu0oDlxtxblM61Wd2NGBoBdrCl7s/0hs/eJJ9QxQWZkmlhp3xQ7NZ97BdS9vtog87onLIpSmTxA58PRmBWXng5tCtJx/rJu98R4hBatPn5d1sGPlPjTiFulNJpsDIJ2JyZcDcWnUDbAAnBoJDn+w0v5fyH1BBBYc60DNPGqu3mWALmCYmDxqgs6KuGNOWvwFTVcvSKAtwxnIzJmqenXfEEgJbJObLarH9gY/gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Okph7VkP2ZSS20to8BbJXuJ/i5R2nhMjaFMfyYwVcj8=;
 b=pP2B1/zjOHYHhrslfs89aGIpsHUb2dlATl74aT4/WewR6MexS6Gf5/4sno5NppiAT9XSjcK3IZAYJusDqCyxrDA97iQ2/Z+CuetZUqhGK0U6LjNurcGaJyghvDHkGcGbn26JyEzmQndy8lkjvlE3/2wElspA7M6ON0UYCU5XnqS0rLd08xTFtGItwWopFBqTW12ogpIAFsgB8e6P8OwXDEIXfBi1Nt4tRCBik5T2iXLQ0ltrEl5uCkI6IpqLjozQrfmb1oMfyJRdUq2DMJqQgJXv3qBYGkpOvWYXaQ3xzcl+ii/qpQlIe/6wO07Iu4KaRzQc78IRp+3eiP3Wu6HFfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8592.namprd11.prod.outlook.com (2603:10b6:610:1b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Fri, 16 May
 2025 09:19:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 09:19:22 +0000
Date: Fri, 16 May 2025 17:17:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt
 hook with exclusive mmu_lock
Message-ID: <aCcCl6nSvYpSK1A2@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030744.435-1-yan.y.zhao@intel.com>
 <b5af66343b3f5d4083ee875017c7449dea922006.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5af66343b3f5d4083ee875017c7449dea922006.camel@intel.com>
X-ClientProxiedBy: KL1PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:820:c::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8592:EE_
X-MS-Office365-Filtering-Correlation-Id: 718228a0-5b1e-4d23-7c4f-08dd945abe55
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?bPa4Ab6GIE2kR7Ug4mgO6GdAJtW8MzihQyySW+b6Ub5REdrD7yanpPzGbI?=
 =?iso-8859-1?Q?OoPYGh/OxTgXnE4O7qPE6zKHbG8MR0Asf2awCP/NPjIEF2ADgK2kdOk77L?=
 =?iso-8859-1?Q?qe0Y+92MFF8zxj/IToJ3r9cOCSO/yUNr9mHA1HvtTE9gUojEOHTvP43yHD?=
 =?iso-8859-1?Q?Lfl1YlczITiuZdo/sP0ZJhnE7dcB+agkplUZKbjRjV1JY0cZy6zDedpyzp?=
 =?iso-8859-1?Q?9CisDnP5CSFO7HgDy1i4xNXGidiK7fHy3qJfV/XqSX/PTsaF9GMCpXoi/F?=
 =?iso-8859-1?Q?NCH/lkPV2NEmBfJtcFaxiNee5qfI69VflJ7EA5Cj7i/NNzYhtyRLp7RNrj?=
 =?iso-8859-1?Q?Q8r4AzI7kiZcwCVBLVtiHKtdOh+WPu1M9bxYWHZcjkAV/6rrVnZcHFgP14?=
 =?iso-8859-1?Q?USKkw4hn077oo6nsDS1dWUGXT3XJepts0iNvd0Jpm7tEeBUdbKXBcpTTdk?=
 =?iso-8859-1?Q?sW1K3x1rZ6R605j6Ac8r35S9s8bCqI7y8nE6sDLqAhXZQX/dCsXdoebW7l?=
 =?iso-8859-1?Q?hmclDO3SLtBf23cq4+D22ALEmSSR3bMtfM22z5UhK9qmjC03BEAmo3G531?=
 =?iso-8859-1?Q?15a9Qh2vZ7HtpBy0puqnrI3YNMdgK7Y7JB96JQpkk95wWWtrOLOls88y7s?=
 =?iso-8859-1?Q?qzGyjHejZHuho7n1V2ujcpCoyvNTb22RLeLygGyP8fNssX7FjxyaXH4kd7?=
 =?iso-8859-1?Q?GLpTmbMkRajT5gBpCiCQ3lLODiqQbCB7MslS6SZfPSKzhA3bSgCH20xjYY?=
 =?iso-8859-1?Q?7jRmGEAQLcE7fQOKLO90EMihT4iZQUqqmTKmjqrL0BSy4jqQ3n/iCLN9qX?=
 =?iso-8859-1?Q?LbIcSCiaWc0ApSaUXBxJ8/kYNvGF+bPyHRYvOQwDIsymr8AYdZplY2K74M?=
 =?iso-8859-1?Q?zSpC+Ua81xHrI2pYJ2SP+ahPZ3PSb6aajDrTVKh4h9SN5pHF33RDqq3GSB?=
 =?iso-8859-1?Q?/elAf/ubXcdkck0L+JbTZ1mBVW1ERuZhvMgUKonyqasWyZImta/11vo3WF?=
 =?iso-8859-1?Q?u/XeBfZQ9MG2+TL/NrBvBzc/Zs9R9PX6WHi7GWsGYp7VURQg9C88nfgrIC?=
 =?iso-8859-1?Q?wLGSL9C3ZX8jlR308dTDlPAKvLQhPOCrS5donS8GBqCm9Hyyd3nl5NUmrf?=
 =?iso-8859-1?Q?3eTVSfYUmeIunbXc59Y7eqhDwBkTO//S3TZYmhGyAjvijPlHPsbtQDtoXs?=
 =?iso-8859-1?Q?YeXSSLf3VCPVUaJENMHGFJzkfgxfXkMkyMq2LQNSNiMPaWDkllATh7ib5f?=
 =?iso-8859-1?Q?CPnSOVQ8XIr1HwJrmABMY5w7cUdBWkO4APKXVVE+w6RhxMOxj+36owkkMZ?=
 =?iso-8859-1?Q?rTVyd01q5+Ro5Ux7L7qUFWD3Z9r9iAI0woHl71o4LiXreLG5yuEFvKptom?=
 =?iso-8859-1?Q?zN4lzHCmwBN7lCp0r4YbgZb8lak5MBapeeBiP9qZgSl69EQK9eeMbozxOk?=
 =?iso-8859-1?Q?lgWMy6B19nh8Yzh6yHso790LEzS8JYe2XTulBvYGsMw/xExVJ4GeJcNe1W?=
 =?iso-8859-1?Q?E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?VOKTRidhB02tK3UnFUw9fqhk5cBsrUVkqbSRavPd2QnKpGtoy6XvnrU2w8?=
 =?iso-8859-1?Q?o7JV4+MhQYnviPGUnrlu9DVrcwxTOpEvf6S8mocOcV1UMYl3D/DlEKJ15k?=
 =?iso-8859-1?Q?FTJJhe5m1HvtCwoDVSxyLp5cl8VMU2K4C2xTCcEcAMeR1K4WA92QM36Css?=
 =?iso-8859-1?Q?cnmw5/bDxZw7b/XGT2ZlBsaKxqLSzvqwMF1MCpFDOma13BYfPVAmorX4eh?=
 =?iso-8859-1?Q?yEPefhZLvfgVAE9ryGeogQcW9L6FtWvhPDaPsOCFvZ2EjaMYDvlXA8XmRQ?=
 =?iso-8859-1?Q?EEtfR5nOpsszrbPxOcVk3sdaL+vLE6CBYnM7gBNpMbKe1J7/aDYTzDZjCR?=
 =?iso-8859-1?Q?S2bet6lkGK15nOeSC28buzqw5+GGqzqQDNzK3FBF5mwcUFeleYSEcaZAUu?=
 =?iso-8859-1?Q?SV0O6j3jxliC/VGJ3rfzC7UiVdjx6wUr3LbIB35LDvQPYCOdGZaCmlBQoU?=
 =?iso-8859-1?Q?ri6fTucvCdSjbPuny6e0VeXSYFTGofacB40I9R0vsiuwbpKVZFteWULw5a?=
 =?iso-8859-1?Q?kw/yOBgliv2YMnP0AZSYuZpZOLc0RDtCBXQ9e0CRGh5V/bLd5TznnlHvRW?=
 =?iso-8859-1?Q?Vd5X5gp92IGQ9W6DvX8DwbEXWKzs+TLOzLMkU4+jlGvCi6onqwpHhkcVXw?=
 =?iso-8859-1?Q?1Y6TDnS4OYw1wmbI35inRS/EJSx9/V97Al2KBCJ6+iiNCQA9kodGHJU9c2?=
 =?iso-8859-1?Q?JCwraStyoyCbJYRkt4VoeJOT1F1JsrvA/1PQ2ghNsAFJs+jXoKhJICVww+?=
 =?iso-8859-1?Q?r3zocDTCTiwDH35pXTsK1z4K9rxqtMaK7BCAPlp98l2OtVrgEuiXSKHWE2?=
 =?iso-8859-1?Q?wy6tpIwaVJVaKeMDIhd4AYObVCZS6z1DFGN9wFgfrGEZVb2A6QKTbIHxB3?=
 =?iso-8859-1?Q?oJYOj7AtolN75s6Yq6yNNPvixnYZnzVH4YU0br/SQdXPED217zrTAjz4yL?=
 =?iso-8859-1?Q?bjYIljFMnf7BFcv4c2uLZxzY+6aQW1kcxllG1XZNCyVmDIea9R3H3VmWKK?=
 =?iso-8859-1?Q?rblRsfEga9gTbsuWckBDmM1QvKjWm5EQIr34ha5HGy7XAA/kVi3NHrRrR/?=
 =?iso-8859-1?Q?iEOMmA3f20UGzRABoxCuvK0jyluNJbP2HhKxJr0ZcSkaLC9C2VGyCeKea0?=
 =?iso-8859-1?Q?w0/uWQ++nHFXGhV/gsFwrn/c7H75qOEwvnyQliM838NUa4kwZ/EuwxUkrW?=
 =?iso-8859-1?Q?o62xXAIdAxfxmPeuVZ9xQnJkrwAfz9wRTGWdhkMVu9HUf0wCbZd7ef/8xw?=
 =?iso-8859-1?Q?XeBhL/FiIn9g3F6W+Eb8dWOuvWuXOj+0jOS2dD7c2YY80Ffd8EdQLAd9lZ?=
 =?iso-8859-1?Q?Is8f56MxJssLQnGTLAk+lio/Cn0N5u7Cr/YdW5jg6V2rH8gpyCOzNGPfmG?=
 =?iso-8859-1?Q?bv9CW2prtTylgOlPFseCtST0qxZu0Ndn8ig7mqkFe8uFzq6G6Z4g/fxEe3?=
 =?iso-8859-1?Q?F/8ZB6E6DZIuS9TvLmnOCyvdR2wHJCp+COc/TmJsFa30RJDBEUy5w4xWdL?=
 =?iso-8859-1?Q?g4h+0RGS97jmjQB6XVchT58HZtWgqpwVzbn6Vp/i4JHNBZl7TGDa1hLhqs?=
 =?iso-8859-1?Q?sw8n4VZlkzf1y3kGKCBb46bYCynh8eZOKTYDbv+t7QiQlXfILHC0Wznd6b?=
 =?iso-8859-1?Q?a2NiT3mabbKpYbRjvCdWDvxraUCAOffchZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 718228a0-5b1e-4d23-7c4f-08dd945abe55
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 09:19:21.9389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6AouO8MfaqRSOifWxzNdGr85I98CFR6cUP/cN/mk/a7J9rQ/7gThq/FVYuAGtKb7eycFPeOizVlTvDGKDftr0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8592
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 07:06:48AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:07 +0800, Yan Zhao wrote:
> > +static int split_external_spt(struct kvm *kvm, gfn_t gfn, u64 old_spte,
> > +			      u64 new_spte, int level)
> > +{
> > +	void *external_spt = get_external_spt(gfn, new_spte, level);
> > +	int ret;
> > +
> > +	KVM_BUG_ON(!external_spt, kvm);
> > +
> > +	ret = static_call(kvm_x86_split_external_spt)(kvm, gfn, level, external_spt);
> > +	KVM_BUG_ON(ret, kvm);
> 
> Shouldn't this BUG_ON be handled in the split_external_spt implementation? I
> don't think we need another one.
Ok. But kvm_x86_split_external_spt() is not for TDX only.
Is it good for KVM MMU core to rely on each implementation to trigger BUG_ON?

> > +	return ret;
> > +}
> >  /**
> >   * handle_removed_pt() - handle a page table removed from the TDP structure
> >   *
> > @@ -764,13 +778,13 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> >  
> >  	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> >  
> > -	/*
> > -	 * Users that do non-atomic setting of PTEs don't operate on mirror
> > -	 * roots, so don't handle it and bug the VM if it's seen.
> > -	 */
> >  	if (is_mirror_sptep(sptep)) {
> > -		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
> > -		remove_external_spte(kvm, gfn, old_spte, level);
> > +		if (!is_shadow_present_pte(new_spte))
> > +			remove_external_spte(kvm, gfn, old_spte, level);
> > +		else if (is_last_spte(old_spte, level) && !is_last_spte(new_spte, level))
> > +			split_external_spt(kvm, gfn, old_spte, new_spte, level);
> > +		else
> > +			KVM_BUG_ON(1, kvm);
> 
> It might be worth a comment what this is looking for at this point. I think it's
> that external EPT only support certain operations, so bug if any unsupported
> operations are seen.
Will do.

> >  	}
> >  
> >  	return old_spte;
> 

