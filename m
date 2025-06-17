Return-Path: <kvm+bounces-49648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8ACAADBE4C
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 02:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7901B174D21
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 00:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83611662E7;
	Tue, 17 Jun 2025 00:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nm2Kzwuc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FAD26281;
	Tue, 17 Jun 2025 00:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750121750; cv=fail; b=LX2qN1ZCOAMhR3mw1tSDRlxOpYZIagHT4G2138Pf7TmPD+j3i2B0Zfa2eKWafH6BZuij0aL/9lf39VtFPeeT+/8hsr0E5kacuk3M2vhImEGYyLtsWKz2MNWfnZ3cm7824nohjKlZGxrESddyyXZ4bSSiPfk6TlwfusB8gaj81mI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750121750; c=relaxed/simple;
	bh=nduyLgDr9MoXo48rs+1DFWiLJFbZaY/U3Iiqwf2PyM8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OXgVjWj8DQ6NXLMPG7+rSpJAwy6KzjlsnprvWMqe7XXn//XU5YZISsRSlw+LuFsTZ8giTJ94+co8VDLhVQ7lDHzhdeI42tEoz7+rr2s+Fjkz6XdObafDmJvS3uyMx0tcICBtZHQ/siA65klJQ2unyqE6TruKcuJjOnDPtkDtWuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nm2Kzwuc; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750121749; x=1781657749;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=nduyLgDr9MoXo48rs+1DFWiLJFbZaY/U3Iiqwf2PyM8=;
  b=nm2Kzwuc3jBwTAyGv5M59RT0uVrKXkjMfeJQ8UBMuRK0gZVUUUAVMnU8
   DmpE3ylE5+nakzG5ojRwTkswuzXyOQR2T1ltA73mvjeRjlhS7oRnvI597
   WJJchQlzjqgVJRk3v8jk+GbG5JtQTHD+s7CQ7+eLbsh8DldY+3a638LAW
   QzzH+MR2orG/t/ObuuKvopa/y+HQ+FBWtw6hit7aF+rvsdydT77NjIX7R
   cyd//Aqc62PCVEoMXH42wGPVDq6pQcQn7bT8XQFx4mH0aJwbrA6lBeRRf
   6MCmjC8rj8yWkF7/yrNJu0Agr9OYlqMEmxqDKSbMjZQlIRjQ60Dpu8vxz
   w==;
X-CSE-ConnectionGUID: v+7KmJzbQGSCEGdoEY+JIA==
X-CSE-MsgGUID: HuxRncaXQV6jc3X6P48xIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="52147169"
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="52147169"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 17:55:48 -0700
X-CSE-ConnectionGUID: c+Cwa/lVSBWD8zBJBpu84Q==
X-CSE-MsgGUID: Ms+Cx92ZSLSSfnEpTPZp3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="149163867"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 17:55:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 17:55:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 17:55:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.65)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 17:55:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pE1QNi9v7+rup1cMc/nOr9NKR2rUTkSPDebBZQXr9nh/jJ0X2rT69xT23imQQ6AbpqH1zq3m6bCWZcrPZjDChpUHPCch2jkHsK7O4ruTJl47JImKEnsXR7qFJ9zLXL55JzP1VyqxgwEGyTqS/seibDxkT5eSDlqZIfA7HCqZmOz8PWu1WPjE9TCIxoluJDZjjdCffz0+TQoOsEEZtjtJAe5NN7h8Jshc9aN9KaGr5eIZ/7HlAvWn4HBHCvzO5L9/nqLPu37++BGwyvYGXIlttAPJda5F4nESZuSXiykeep+03IKxt//OQXpUZunzvzYCIQy0NDX75pUYEOIAzABzNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6gNuQoFyoK1xgR8TkS36H5dY87SOsudmon3xGnQblg=;
 b=Oz77TMgpEkZ8SYs0gTqlggVNTalqR1faAKZGVkiHWLRCL4/H35rxvo54vSqY6LgRb/Yxfh7E/XgRs8GuuPVMTauTwPKqAcERUWl+A0UQOohAPrkVpopDga4Rab1bmt6R3PF93JG//MSkOpZAL7yeAsjkNc/gXx7jBPW9As6I30BRNTYF7IQBiW8IAtnDfh7mMi87SIJrDLq06NOK/B8ooIWR6GFzL7Z+AzH07qSfOhQCoFv2bHBrfocQbso2SVNq20KYUD2fB3kQvxAJszCZCNlcDJ4/2lykENW+L2GuhD/wNghweBEd3mm+5u0KqLf4YyKWmriqgPIfIzdeOvbdyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8009.namprd11.prod.outlook.com (2603:10b6:510:248::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Tue, 17 Jun
 2025 00:55:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 00:55:17 +0000
Date: Tue, 17 Jun 2025 08:52:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aEtumIYPJSV49_jL@google.com>
 <d9bf81fc03cb0d92fc0956c6a49ff695d6b2d1ad.camel@intel.com>
 <aEt0ZxzvXngfplmN@google.com>
 <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
 <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
 <aEyj_5WoC-01SPsV@google.com>
 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b6f7db2-3267-4bb9-8f2a-08ddad39a094
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?PL1obkeJxEc2fNXwG6CM/LxJhaGXQ5kCF5lOb2pPm5QrW2aPbv0Fynx5aH?=
 =?iso-8859-1?Q?4dclD/wx6sBC1Bn/+SukEZ8e/vq/y7/lMXONGcV18pMpRimoKSXB2bEA0y?=
 =?iso-8859-1?Q?tba8Lxv8F6HMab57o2yO/2J954yaWOe6+QL8Nftj3rNtsp975/0WxRVK21?=
 =?iso-8859-1?Q?Rv0e/TNPVLQlIm1O5Fzg9I0EEbGpRfBn91fooCoPE2yQ4XhXFpvh0+oI3u?=
 =?iso-8859-1?Q?UptisJolOG+Jj9pjJnyBOvc791evwe4DB8dRzhSd/Gsk7fdtO2A/DgOexx?=
 =?iso-8859-1?Q?WabhLzoKlI/B8vr4s+2gi8Wt6AxC0Gpb41EJISaJy8/p/uT5AXdaLBaIrT?=
 =?iso-8859-1?Q?ppReOMcTjrNknGd9dN3glFN17Ie9e4OY3IFdg/dHP+vHcuo7mCNDp7K+aD?=
 =?iso-8859-1?Q?eB7aUJ/xcVASDBx77wz0cypC04BgL/O+Evm1GM6jOs1TQzKjxZib0IWerz?=
 =?iso-8859-1?Q?TOrglBTtgWXlSza1faBy+4PMXF5oU++vacL0xUGFzgttP2vU46AxG2JCNT?=
 =?iso-8859-1?Q?sbgQxbq4dmgOb6zl/5UhvuFzYRqDsUffZW9E8yQNG5FwLA4zL6tkHPr3lB?=
 =?iso-8859-1?Q?3QA00X46++rQmB+0r/+nE/zublaLdLgGo236ii6ZWdnO3CgWD9NhZyaR8o?=
 =?iso-8859-1?Q?dQT6pL3EKiMS4LOCVTs3rcHtLRlUOwCB8zuuiV+Q7tzGzATUKst9d9F2ZQ?=
 =?iso-8859-1?Q?u8y2jNFbcqUjKiYTkWOfaLg3aGjnSqgVFTOCMwtlWzuzeLKEZPff7MoB88?=
 =?iso-8859-1?Q?+5IEGjNHzK5LFoI+aCX97YWYzko/MGB+38U2HMkirmjhyqyAadAwsGQ2j9?=
 =?iso-8859-1?Q?N3eXUOyL7Fv5EAuGc1P21bbAGZixQxhxMLLxIj4nKYbFXZA2U0BMU52lFA?=
 =?iso-8859-1?Q?ZvR9qSxAeNXD+PCzOzupZieD3dfPDXUJ0mTKfz2s17tSfHysOQ3Yo6l3uk?=
 =?iso-8859-1?Q?vCXCODfcpC4yhsUMrFkPNKdKZDbe09pX8FKzIb+aeNVLf8er2PlwDIUvH5?=
 =?iso-8859-1?Q?A/tl36OnLUBMaOFkY2zAp5k5uw7lwdSgqGiOUp+q7H5Y82jfUpiF2z94bk?=
 =?iso-8859-1?Q?+5OuXK1uBDZ4Qp8oXZ1eAVsb0COSXLjCdx6SSkO72CJR3kUOL4QsakCP+g?=
 =?iso-8859-1?Q?0y/atyDhdpIdeRVcNvEL4XqQAtX49255yFvuOXOfZ4Jeajrp7n8NSiuCbW?=
 =?iso-8859-1?Q?1LZqCQ7oG33i7XvZ+Y0QPlXaRrMRpuHg+T+hKujdlF+H2WAacpde9G1Lru?=
 =?iso-8859-1?Q?941bSI1pbWKcsQVVsdejFn5M2CePh7UymtItbxwIXO0u0OYSjkMKAD0V00?=
 =?iso-8859-1?Q?qa/iljzWhTKkEwXE0PvHR0DF/WCUYCRIrxfAehF9qKDROBMR/cu1lXiq84?=
 =?iso-8859-1?Q?N4Wf7omfVTalwHjPe+ODjnfhjiPmkwt8+2cOmYdW6ds1V6PLCI12w06kc2?=
 =?iso-8859-1?Q?NI0O75io6bDomImfOuaQ5KCqz+nf76lsKRrFFQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?70oZ3z/Q6jVi4Ch4PKrUZeJ13dPuyrtJLMV14rQYzOcMrEEaiNOLBiZdqy?=
 =?iso-8859-1?Q?B7EQrWJyfCMhhWFsOKzuK5jAL8mTWQAp8IT079r99kz4lSQ7xNirGwC7j1?=
 =?iso-8859-1?Q?bW82iuuxYRyTEQjB8bhi3muGFZvfW6KiAcJlaWhY8S9/N+0rLEvgcBt1Zu?=
 =?iso-8859-1?Q?WhS6jrS6H0jOMWbLIdbAXLcID6Xps3OtCIS8XnG1fBmzTOMDhXeqSd4w3F?=
 =?iso-8859-1?Q?DQYft/5GZkh25cctyVDhQbUgqAVMPCDjqcTpAE4SfI1jMPWewOYhbWCMsu?=
 =?iso-8859-1?Q?7Y+6NndBM+5tYrM4hXtg0zU0j6RSknFEEX6wBRCllIYcd1fh+5GrrrZwO8?=
 =?iso-8859-1?Q?LXLIAFFu7IqjsJ+dev6qkzx0e5IpSzfF2E0qLeyIFSPXyVlpVcfNKEtQ83?=
 =?iso-8859-1?Q?rezrbB/KUjyvemRuNl8HvAUtqFYCcUoJQnG9vLcbH8945CQM94TKhttcbe?=
 =?iso-8859-1?Q?IIg8/hKiJ+qw8NRVI6tLZ4kV2jjr1uUDzI1KXq8DG3AuVj5Rplp2RpzM8x?=
 =?iso-8859-1?Q?+zdsP+3BFTHtAAq36Ob9AkIr5WS6iVkErMktiYdBwXCICAl3Gsj3gtxIvZ?=
 =?iso-8859-1?Q?WqEoKkUTMTatlMNNBTXtirGheBzMHvH9opI9gZpPv4ElrQkPSvCZ610wqW?=
 =?iso-8859-1?Q?6kjMPhSDiAIXtsTdcHZKGDOG4O+KDik3VwY3xIY242UI8ttWiNjqjug23e?=
 =?iso-8859-1?Q?MXagn77XSgL06iTcWqu/pR8XjR4OoWPCxiSzTSPhOZAHElBcPH2mag7kqi?=
 =?iso-8859-1?Q?px62cia5Owk3h4Eq+Sxz3FiQuyW/0kOVeXfVm4GkisDZd0Q/nvPsLD2x9P?=
 =?iso-8859-1?Q?xYQQBHSmOSPnI4eKD8FlYk1nu/uK8GkGLGEZKK8hMDJPv1rf+7eNoPt8mE?=
 =?iso-8859-1?Q?358yVj6932HIlbxV3GTUtSa8INrbAm4EghdXfktLXwi/CgxfF3Lxb7k/wV?=
 =?iso-8859-1?Q?XYIZRNuOXhp6JV1dHDBQ9ZMOjgHd3CWZoJ8+taWD+UMAl40cgw+TaPyftM?=
 =?iso-8859-1?Q?gkVAi5VjmLk1go56axLuClSlsJHMHm3ZieWrErapOS2ETLO598WYtlnWlW?=
 =?iso-8859-1?Q?jvpXViUVd5WryRSfDm+xXZZ4toUw0nnDGrk/llsSpokKmZk/hX4NIVT1jv?=
 =?iso-8859-1?Q?mrR+LcSflJT68eCDHEdapRhetXY+O8bkrnmUwpTN8gERYSCzycCmMPDDVD?=
 =?iso-8859-1?Q?KwMnEuYyi1r1Efj4GFZ6/35uteBXkNOsWq72Hffy9P0dtt4O/Y/oEtFCpe?=
 =?iso-8859-1?Q?q1cCv19FbFFTbh64/q9u0ro3/ptAZcKiCmE7qo7aIyzxrsVJiRQ5CKNTen?=
 =?iso-8859-1?Q?IsLXKAnd65IqEET3ieIOnc481sRtBNRzRtsN6TdgmMGGpmHiwaf3XOSQ97?=
 =?iso-8859-1?Q?dioFYMF7FGb8tHD1T+gm43Z9jwRiPnkiCvfDaYmIfDpKtQvMt+3vILQD8+?=
 =?iso-8859-1?Q?7ZSgOXh51bNkz/0gACCpGfwOLdQUA93Os0mfaH67BNJf1jKxx58c8o3EzU?=
 =?iso-8859-1?Q?NDQ1GAGZQ/2S7tKbPSOhcZ6HKvtRBJmSszV9/qocC1xVmTgfWOBftFc6Pl?=
 =?iso-8859-1?Q?gXcfJoyN5L+Jg0qSoKUzHTpfN80VkDEVLUGBcAuOLHsbDWCN5sltC553Ld?=
 =?iso-8859-1?Q?qL37wy4jgfFWyrKzt/PaVGc2b1cac56of4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b6f7db2-3267-4bb9-8f2a-08ddad39a094
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 00:55:17.7128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1L7SqmCB8NHWXEsAqaA7nv9nEdKy4BlOXDO58y703ZX1FVPwCfA2Ime0H9teTtBLWmNyjp9MCgugHrPH2x7FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8009
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 06:49:00AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2025-06-16 at 11:14 +0800, Yan Zhao wrote:
> > > Oh, nice. I hadn't seen this. Agree that a comprehensive guest setup is
> > > quite
> > > manual. But here we are playing with guest ABI. In practice, yes it's
> > > similar to
> > > passing yet another arg to get a good TD.
> > Could we introduce a TD attr TDX_ATTR_SEPT_EXPLICIT_DEMOTION?
> > 
> > It can be something similar to TDX_ATTR_SEPT_VE_DISABLE except that we don't
> > provide a dynamical way as the TDCS_CONFIG_FLEXIBLE_PENDING_VE to allow guest
> > to
> > turn on/off SEPT_VE_DISABLE.
> > (See the disable_sept_ve() in ./arch/x86/coco/tdx/tdx.c).
> > 
> > So, if userspace configures a TD with TDX_ATTR_SEPT_EXPLICIT_DEMOTION, KVM
> > first
> > checks if SEPT_EXPLICIT_DEMOTION is supported.
> > The guest can also check if it would like to support SEPT_EXPLICIT_DEMOTION to
> > determine to continue or shut down. (If it does not check
> > SEPT_EXPLICIT_DEMOTION,
> > e.g., if we don't want to update EDK2, the guest must accept memory before
> > memory accessing).
> > 
> > - if TD is configured with SEPT_EXPLICIT_DEMOTION, KVM allows to map at 2MB
> > when
> >   there's no level info in an EPT violation. The guest must accept memory
> > before
> >   accessing memory or if it wants to accept only a partial of host's mapping,
> > it
> >   needs to explicitly invoke a TDVMCALL to request KVM to perform page
> > demotion.
> > 
> > - if TD is configured without SEPT_EXPLICIT_DEMOTION, KVM always maps at 4KB
> >   when there's no level info in an EPT violation.
> > 
> > - No matter SEPT_EXPLICIT_DEMOTION is configured or not, if there's a level
> > info
> >   in an EPT violation, while KVM honors the level info as the max_level info,
> >   KVM ignores the demotion request in the fault path.
> 
> I think this is what Sean was suggesting. We are going to need a qemu command
> line opt-in too.
> 
> > 
> > > We can start with a prototype the host side arg and see how it turns out. I
> > > realized we need to verify edk2 as well.
> > Current EDK2 should always accept pages before actual memory access.
> > So, I think it should be fine.
> 
> It's not just that, it needs to handle the the accept page size being lower than
> the mapping size. I went and looked and it is accepting at 4k size in places. It
As it accepts pages before memory access, the "accept page size being lower than
the the mapping size" can't happen. 

> hopefully is just handling accepting a whole range that is not 2MB aligned. But
> I think we need to verify this more.
Ok.

