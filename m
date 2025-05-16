Return-Path: <kvm+bounces-46780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD9E1AB9857
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 11:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 694781BA2A7E
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C0F22E3FF;
	Fri, 16 May 2025 09:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oAaCbwhg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC6D222585;
	Fri, 16 May 2025 09:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747386480; cv=fail; b=MdDlqq3tFPAQ/59aV2braRYEh7fecKfJpOxiAgPSZfkVPVZrn+tj1rQOB7MwYB9mW7XfKU+90WKTJ2fKf3Ow0PUZlJ6eBLgSF/PDovViuS1YQ/WfX4nxPFYZ8U2LVX/NvbwJoQtisrLjFOubwStEXEqEenFpRqajMkLoMSINEKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747386480; c=relaxed/simple;
	bh=r751w7BCJhcM0GSmMCJbjia9fZgSSjs8ROOSJz5BXLs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jc+fH42vgMBPCJdgoRG4ks/ZZsY2HOtjnHTcF7IYOv2MeM64BZF3OtbHy0iF6qEYoTfW+3HGLuNEwT75nfCvQcseaLsON3dIfgW8VuNz5K064UI0ghHPE/4zkp+9kkwbwOIHZ8V8HShL9vsSHbvcCTjunZ6zrSvB7gDdnWm4sT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oAaCbwhg; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747386479; x=1778922479;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=r751w7BCJhcM0GSmMCJbjia9fZgSSjs8ROOSJz5BXLs=;
  b=oAaCbwhgvEUGHWyDiVFJFCqvHz1ORuz3CawW0GZ/Ni+YszBHsCCwxEYp
   4aAVtiYnHXQ55deBFQ33YTColoWrCtuDjkkNlRBb9aLtxn8Y/NXL38j9E
   +VEacODYHrqVjAIY6/h8lgIYekrZmPaGope3/7QxhAXwQFo2GxuH/dgRC
   rt/OHNotWZKoX6HIY68C8iTPtch5vB7dJC6gQTS2NZprsSTAeBr6YxtAV
   kkv5IOAJ5TJBj9P9e++0DJMmMey1UtXKK+Rss0D33CR59aSKKBS4xUU8a
   z7djTuwHiffkYJRX4EgDWT0V/fdaK/UrRDiAUF5T+2ji1ewq35qyaGDUY
   w==;
X-CSE-ConnectionGUID: zxo/UIDXQ+awei42JosDTA==
X-CSE-MsgGUID: gAec0RgiRPC2GDYwGFQuOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="59990996"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="59990996"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:07:58 -0700
X-CSE-ConnectionGUID: 2jQ0+4vST2Ko0yeKE9BbQA==
X-CSE-MsgGUID: j0ToKu6aTDiJhxzPJRLc8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="138554807"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:07:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 02:07:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 02:07:57 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 02:07:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HP4khPqWcZ58UNfeyCD/waWLyMCU1CndYQS9GdTfLikmSO+TkTGGMgbNQIPHn10Mho2B1U9JbTEn5GPD9IE0NIUpX7B4uXDTPZUU4yeRDxst7G3/CYfVY2vSJPnBsyHocuCfXvj/8LAPHf04LUNw7v4eJ3GpaJ6iPZOTfQvXMuddKR+vvmqSdBGSPIkrQrqtzjLyyKBhdklICqLB2LGAgDJX9TjBQ+xTZYY75IxVNS+AbDlqGiQo0uplJegRwCTfy/mdsdq+gxmbD7kghakRGcJdhOqShOsGF9Rd2ZOQ4oXMagFWqjuHp+jxHVoHIB5RzNDKWrXMad1yn1XjEKcTtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A2Sfupce6T8Ro/iexTsMby+5hZt/akg5u9mFbTD2jNE=;
 b=wwRS6+za5j2SkClNcb2CnAhws2qhXa9I38W0hRk0JCaU1rlp5ZNjdmVEWbaJNDEBAqAtC/Qs5w8CsX/7kdKOj0sokdq2b9I1CPRe41pbanGoFY+79n2UPJeUUF0ul8puBsZ/SgSPOiC7NHNTLGcN/brLifXGMLL6IDDKzyh5J/gkzNfTTpMJ4IW/lRhFzuusIKmbeKI83RIeBABjN+X0Mfu4L74Uj3ofuerMXE6SlopzlJNjMsgl70KL/0kymGadsI/x3zIs7VTwJedr7a/1hBxmKZ21aEYOdp228CFqKP4E6yrpRflbeIzkVH7qXnotHPFU2G98pNyL00VP5XBLKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPFD114713BA.namprd11.prod.outlook.com (2603:10b6:518:1::d50) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 09:07:27 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 09:07:26 +0000
Date: Fri, 16 May 2025 17:05:16 +0800
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
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Message-ID: <aCb/zC9dphPOuHgB@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
 <a36db21a224a2314723f7681ad585cbbcfdc2e40.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a36db21a224a2314723f7681ad585cbbcfdc2e40.camel@intel.com>
X-ClientProxiedBy: KL1PR01CA0081.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPFD114713BA:EE_
X-MS-Office365-Filtering-Correlation-Id: 373b586e-8ac7-4ec4-ea3c-08dd945913fd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?77t7PqaQGiuZIhbo7quhE/HZRnbx+vrttqTOWC9Q5QnI7YZ9oSt9taCoc3?=
 =?iso-8859-1?Q?kkxQ7iUzXzqIOv9cFsykisoz0VTIWuMOMaSUc38PDGcIbgYpnYI70MaHkm?=
 =?iso-8859-1?Q?ybLxNzOMmqvlfYy6fwzG/wEbO1AGA/XLY04zuJvtl/tkbLl5a1IGWhoDW3?=
 =?iso-8859-1?Q?3WyaTYewyiaLSX9Iw4HLv/NAHaIsvpdBwkSl5McHbk0xVq/QnwkphWtu8M?=
 =?iso-8859-1?Q?JBzTPTSCXgMesqWgk41Aqn71kO26q61FQbW22biEqHT3BPcvURb6+JcWrk?=
 =?iso-8859-1?Q?T0WfHyn9jI6nSCb3Z6kzswcpb2SAvel6CT4eg/mx4k6NQ7w+EEXC1aBGvG?=
 =?iso-8859-1?Q?rmFfDVC3huUb7LN3Wrqcch7Ovj1S8jhAhmy+MTvqJBAg8Qyy2ncf2dYjN9?=
 =?iso-8859-1?Q?yavH7greZ2FVJCFKTyKysEe5YtC4syBU3XC2K6g1CAg2wm1PiHN17bZkm8?=
 =?iso-8859-1?Q?IL0fBHNaujzFQkJYA3b8K3FEwQV/U0Z+mthqbxe0PYXnHqFTV9PeMJMi3f?=
 =?iso-8859-1?Q?sNqhuZB4TsJ2PQgmpnX4Zg5WuuyV9zU7uYODAonV2ORtdkKlB/d9c8Uxvo?=
 =?iso-8859-1?Q?H0kb2OGUi+1H3WPCiAPBtFusemJ8x8AOXdwyWFE7tGFw1JTR9WVgN6G7PA?=
 =?iso-8859-1?Q?qUGfKe0MEl8npPVuvLMjrpch2GkNG9Dxqrx0OHf2AirPK+KKRvswacg9G7?=
 =?iso-8859-1?Q?ojIZ+YZbXQ3O+w8FGY4y8nM3eV+sfkQ1D7g6yR692KhhNnXyzm+LqMB4mN?=
 =?iso-8859-1?Q?qp66SsyCjdxOTXj36Ac175EwOuam4XnjxO9q1WczHx6yBeHbrVZC2Cv9g/?=
 =?iso-8859-1?Q?f0WzR6KULvZ5d9ql56Fr+tZPzjxa0YUfXaqzuLMtV+kh76BCsV6KgnnUA3?=
 =?iso-8859-1?Q?0M/h0lvjTpJKJJizKlM9dCHF/mig3CPW7AFB0ZRjhPEjsp1lFM421IEP65?=
 =?iso-8859-1?Q?qeIYYieVbVODCX2i9qr2ZTfEpoYDmPmRREPIM7Q4eDx4Hc1zDVVCGf/cbT?=
 =?iso-8859-1?Q?bm3XxKOhvSUA6bPwQwKHaicoD1zOjMyZ101GA6HKWrqsPPmmqnBNec42m/?=
 =?iso-8859-1?Q?7uKc6OREc0vJC95MwTXdWhrX/VeROuOs+uoRGUUWAIQwkOe1OOCP7RTtX1?=
 =?iso-8859-1?Q?JV5q/xBtuP7QW2odeI7JV3xcvk64PQbA0baHQL4lr8p05cAERJ/Vas/1Mn?=
 =?iso-8859-1?Q?7haauP0kVeqwzx1WaVzJdBEaZrmkhvVJCskK7YgIBc7wkJlwptgnStsN8F?=
 =?iso-8859-1?Q?yoqXeERry90RNec+Bcy42Cngej/ziPPGkJTWD6T6wbCHW23CU1RmQImzDz?=
 =?iso-8859-1?Q?vIYzAlZ1qxfVlQ/haZh3H3fRPVya81K+tj5rxytmD177F6uU9Vk5/H7zli?=
 =?iso-8859-1?Q?Hwm5RAOV3ZIpAl0kdlU60im+VTEfTgVkd94Ih8eNtpcCw+/k/fWH8tMFf5?=
 =?iso-8859-1?Q?YuEmgB9LUxjSdBIZYJNjiwW7xtGzFUgf/nroX+gEyCLDl4srB5SYAubC4z?=
 =?iso-8859-1?Q?I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?xJWfHTOw9uIioqPjTx2V/e8GA5K9gCQbQ8bALBXBvbVfkSEOOMCy7/qAVJ?=
 =?iso-8859-1?Q?7mpYskW7cpFJop984e/vlzhsjRFpHzpuNKz8d5mmndiCXhWzKxcyFZ6nNx?=
 =?iso-8859-1?Q?KnwrJ8lBjOkYLQzhvDs0KukruQlQIxqeqv8ngEDfpg+ElaIkLpWK//TJ2p?=
 =?iso-8859-1?Q?Gcnw0r+DZOYYITUVAGp8AaZ/CpoATTObCfYwJR5llAFX+ft/OMStnBn53p?=
 =?iso-8859-1?Q?2bkSIjgwdNGPfR3+utX4A/4Ejxw5mQ3RU7BExtKdAelTfseVNVq8wDMcGC?=
 =?iso-8859-1?Q?Bilv8HxcExqqD2aj1oLyW6Ib9eSlii5FPJcR3V8eali1qb7ye251rDW/5m?=
 =?iso-8859-1?Q?EoGfGjtQVwZnSNVSx1cFkQHArIkxapBXmUkRdA8rWaiw36VkFn/KLuNLqo?=
 =?iso-8859-1?Q?2Mj5OGfj+lzW0YNfWBlA+6TSP+m/ymt7/KY8p7cOTGJV4OtWQqFPwWfSHr?=
 =?iso-8859-1?Q?bbBvRZUkeYgGoXDk+HO1ebgrlggC389q3jWsYoha9zBPAoecqcNQKILogo?=
 =?iso-8859-1?Q?kzEYgHVDG0iFo1CP49AzKPPxH2DR+1q9eg2kFZxc6meiSEf2DuQMVNnwFX?=
 =?iso-8859-1?Q?zX4WtiX1V539M+33W6MCo4n2W+GTT/Jz8J5u70vr1eWFr0obVMqgp2PAub?=
 =?iso-8859-1?Q?12IhLkD35Sc+AQuaCITkp1A3+zuibw4NESEkDco3utVOke3qX0L1pQBS/Z?=
 =?iso-8859-1?Q?NaUNHWkg72m9yo5BElQJnyLlg/1sNcACeN5LIbjx1tRPSusDYPbuUETYy6?=
 =?iso-8859-1?Q?PrFrobYinOJzKfBATJsSa4dMnCEK7jBIqGq9XCocMXhbQlGjDe2spgHflQ?=
 =?iso-8859-1?Q?ySq52pJhBZeDuMlptT7aae3mltgTDbhcNGTTJ7HxJ+THaFvKW0O8q1jnjZ?=
 =?iso-8859-1?Q?VlMgTahyzlYLZ+IMh/gw4wPL7f4DUAyNGa5bclfWWxTocGn/+aAemNmbPv?=
 =?iso-8859-1?Q?fVWTw2x024j8G58nQZIuctB44GMUwtMmhiEN8iA7q60zz5S60YyV3MsBDY?=
 =?iso-8859-1?Q?JUi1OQgyl8qJnzlfOReYgkppFun2uHH3slU55+yihNbN7W6ncUYJzVp9Qv?=
 =?iso-8859-1?Q?5DQEHxSBgUkepfhjPTUeLzu39PgJhnLFrZjd64NDLLQnHzZHXpca0QF4gX?=
 =?iso-8859-1?Q?5vIJsNbW6iixlCWWZAEnjlA4PLLYyfChL7YXSrVrXwIG3/LPikNDzAP/+3?=
 =?iso-8859-1?Q?pu1WuH2OdgsCU13iVrJDA2dixNi8SH6b77ggsvvJfT+W/f2CYFxZcV9mwy?=
 =?iso-8859-1?Q?ZEoM7yE8FOdDswk2T6qI9kmX4Oz58zwUhM5jh/dv7JFwEGchMayVArZ7ny?=
 =?iso-8859-1?Q?pSZPb9QnJR8SzlLHOLx9/Pt5qEydAgCIl/0P+RmntwWHx9mYmjoT2UCsHI?=
 =?iso-8859-1?Q?fGtr9wHPVIojcsCzduNYbL3iFLuVc3PGYTHFI+ykoFRBg0Wx39OSdQKuy+?=
 =?iso-8859-1?Q?/R3K3y342yKFXnrP41+MlIGIZROxQPxnyyZobZcgUM+Og4dDUtRhB6U5ju?=
 =?iso-8859-1?Q?W172oEIzYvNua2OTnIEpN+FpbW9qgs6Hf61cYgDGjvHGw1KeSjPzPW23fK?=
 =?iso-8859-1?Q?TrZbVcKismrOS8PRF97nx5FuhDHOjwv6I/uE+IGwEdjpbFm/SyAZfGmRO3?=
 =?iso-8859-1?Q?kmL+Xi7IxBxs8jlH5vE+JXApiBBw1RdbNmtFlirvgXuT4jvkORaQ6OIQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 373b586e-8ac7-4ec4-ea3c-08dd945913fd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 09:07:26.6451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WpXu9PSTD2kLCiZ9ei5JgDrjYg3VtZc+/LCJj5KqNmBgodZH26SASukA+Blxtcb+l93yvNMLsRpB0wbxcRtUtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFD114713BA
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 02:52:49AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:04 +0800, Yan Zhao wrote:
> > Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.
> > 
> > Verify the validity of the level and ensure that the mapping range is fully
> > contained within the page folio.
> > 
> > As a conservative solution, perform CLFLUSH on all pages to be mapped into
> > the TD before invoking the SEAMCALL TDH_MEM_PAGE_AUG. This ensures that any
> > dirty cache lines do not write back later and clobber TD memory.
> 
> This should have a brief background on why it doesn't use the arg - what is
> deficient today. Also, an explanation of how it will be used (i.e. what types of
> pages will be passed)
Will do.

> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index f5e2a937c1e7..a66d501b5677 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
> >  		.rdx = tdx_tdr_pa(td),
> >  		.r8 = page_to_phys(page),
> >  	};
> > +	unsigned long nr_pages = 1 << (level * 9);
> > +	struct folio *folio = page_folio(page);
> > +	unsigned long idx = 0;
> >  	u64 ret;
> >  
> > -	tdx_clflush_page(page);
> > +	if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||
> > +	    (folio_page_idx(folio, page) + nr_pages > folio_nr_pages(folio)))
> > +		return -EINVAL;
> 
> Shouldn't KVM not try to map a huge page in this situation? Doesn't seem like a
> job for the SEAMCALL wrapper.
Ok. If the decision is to trust KVM and all potential callers, it's reasonable
to drop those checks.

> > +
> > +	while (nr_pages--)
> > +		tdx_clflush_page(nth_page(page, idx++));
> 
> clflush_cache_range() is:
> static void tdx_clflush_page(struct page *page)
> {
> 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
> }
> 
> So we have loops within loops...  Better to add an arg to tdx_clflush_page() or
> add a variant that takes one.
Ok.

One thing to note is that even with an extra arg, tdx_clflush_page() has to call
clflush_cache_range() page by page because with
"#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)",
page virtual addresses are not necessarily contiguous.

What about Binbin's proposal [1]? i.e.,

while (nr_pages)
     tdx_clflush_page(nth_page(page, --nr_pages));

[1] https://lore.kernel.org/all/a7d0988d-037c-454f-bc6b-57e71b357488@linux.intel.com/

> > +
> >  	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
> >  
> >  	*ext_err1 = args.rcx;
> 

