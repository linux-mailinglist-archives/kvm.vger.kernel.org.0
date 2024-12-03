Return-Path: <kvm+bounces-32923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D2D9E1FFA
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 15:50:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12DF5B3B68A
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 13:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B6C1F12E5;
	Tue,  3 Dec 2024 13:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QJkn+Y4/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625321E32CB;
	Tue,  3 Dec 2024 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233122; cv=fail; b=Wy5OyQTJQEZvfQJeRcnMIfmis3UMw+GUNvI9oFz6zUH9fkPT9sOCm+KrnFeAuUeZ9HCGuzQ2A9gsd6K2h8OcQyIVewg5PXG2OyvXh7PoaG2y8wImCcRYEJ2m8bWKMj5wZbMDlS1VNewo7cGimD5YZ6ScAi853e9TyKHNrPAaUMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233122; c=relaxed/simple;
	bh=4RV9kp+1ToDsj6sfLdyWlIQMnFdRWMrJvKEf/bSjWJk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ITkxU7STiONtu9te2s3/QhY+b33XsY4VnJkd/USF56iklHGxmIFJTMaJEuCcLls9YXpnucfsJ0vIxvKwYZ7EUAJ321jNqAKX2nfvDNzUq53Gs1v4vSCXWEuXd900pXIn/v8OeyoV8vP5h0VB/Ow2zELO1dPOZGEEX4Jd/JLsM5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QJkn+Y4/; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733233119; x=1764769119;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4RV9kp+1ToDsj6sfLdyWlIQMnFdRWMrJvKEf/bSjWJk=;
  b=QJkn+Y4/czQMqaQ3yh92IeRTNkCE7hJPraEPN1EUyTzGr/cTMwBPOi6c
   sSBbIaPF6Xso/RDJ2f8SV1scQFvOP1SlXDnqGDTQp7dqRQobsd5EZINn4
   DXV5ma3keYt5i1BONQ4sYXdyLMsBqr3houjRld6GjjY+FFkVkFmYF9bly
   5+PfgNxMUA0mcHCgzEtuFA/oIpsTbcuv0GdijwXc16vHFaDAJ7NRCqKGS
   frWr6DRFdmGrRhmJ9zdhY7pAHT5AXMcutYwXGIuB70U0Mq5MpsMN4Xqlm
   hZl/Uhr5zls9EH00GZ+Lbl++UiNCLCireRp8fYxBkBYEOQH/g1l2op9Rt
   w==;
X-CSE-ConnectionGUID: exEk60sgQBe9V796NjAKfQ==
X-CSE-MsgGUID: APrEOTQlR2++gxqEO3SwXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="55931778"
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="55931778"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 05:38:39 -0800
X-CSE-ConnectionGUID: HqVB8/MASk2krZemi57M4Q==
X-CSE-MsgGUID: nR4PCUHvTsOOeNUiwF7skA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="98447729"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 05:38:39 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 05:38:38 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 05:38:38 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 05:38:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xa1apZIMI1OR8oIxM81mPL79FLWjhcX9Yh4kXDXFWL0u6bzvrrfGpsEr31wjrO9uMBaV+qXVGblj9XKb+3XkewR4r5xnvG7b/OpGW/hWVuHhZ2aOKslSRwO3MO1UoKoMqQOOc7Yp6MwTIIQEty2MxsomMaWlJD1cm3q4lM50QEbak94+TDItPxQDzVu03z4nrE2zP7/A2oN0YHpyk7g+6HnU/NEsnWn79pnoeyi4XW1bCr2Cu1CqF+hlrP9R0OxwmL0fhlpjIpkicQX0iHqa3aKbxaru7wwTbSM9plQKNG1TGnCC4Bxj4tY5t9S65scpl+lZzKL4Z0oIzNp5IULeKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySTMVxRIGAovtsDCj87u6oTuz9BI8tK/jinQi14V98U=;
 b=eo9s7Xq9hBxncopIsQKMSgpqMaMJN0J7Wvd0HDU6kPfavIQmXKtwSBnkJBUzsJR/hDRxLxkEV5UyTJTFJ/eclVK2sVj7HQX6Cfb9PqFmbdxLXe8vC7fQrMtTP9O1wkObRvESB2HKuYjHBQFHz4+nCYMqIKbvryN0CaptR3dG/08DVWLl6yHkkPpSDq4d/WDsN+8PyneK2MUisxrMaizV/N6T8ObY/TeG3sscDc4yLG7nYJrh4zVLXxrx8qzSdbrxCPl7woupsNTKlNdx3PkuB7D3M7ZcALnSobCdPP8ypi/+juc+nnmO5QVypXcXKm7Mi9PhNbbn5D0BWMANtSHuZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5423.namprd11.prod.outlook.com (2603:10b6:5:39b::20)
 by DM6PR11MB4627.namprd11.prod.outlook.com (2603:10b6:5:2a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Tue, 3 Dec
 2024 13:38:36 +0000
Received: from DM4PR11MB5423.namprd11.prod.outlook.com
 ([fe80::dffa:e0c8:dbf1:c82e]) by DM4PR11MB5423.namprd11.prod.outlook.com
 ([fe80::dffa:e0c8:dbf1:c82e%7]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 13:38:35 +0000
Date: Tue, 3 Dec 2024 21:38:24 +0800
From: Philip Li <philip.li@intel.com>
To: "Melody (Huibo) Wang" <huibo.wang@amd.com>
CC: kernel test robot <lkp@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <llvm@lists.linux.dev>,
	<oe-kbuild-all@lists.linux.dev>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	Neeraj Upadhyay <neeraj.upadhyay@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 5/7] KVM: SVM: Inject MCEs when restricted injection
 is active
Message-ID: <Z08J0EVu0VeA7Z/R@rli9-mobl>
References: <20241127225539.5567-6-huibo.wang@amd.com>
 <202411282157.6f84J7Wh-lkp@intel.com>
 <5068baf4-7065-47c7-b339-b211b8fa80ed@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5068baf4-7065-47c7-b339-b211b8fa80ed@amd.com>
X-ClientProxiedBy: SG2PR04CA0158.apcprd04.prod.outlook.com (2603:1096:4::20)
 To DM4PR11MB5423.namprd11.prod.outlook.com (2603:10b6:5:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5423:EE_|DM6PR11MB4627:EE_
X-MS-Office365-Filtering-Correlation-Id: a51b3462-a52a-4b36-04f9-08dd139fc944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2Zo+9IXM2ToMfDuLFIPqmCe4PKvAq6bmlbD2OeeGzWexNZAK2j0VMBySJ2FD?=
 =?us-ascii?Q?MMGriwz9CKfB15Z1EDnLMakGxIzsS5Ghk+sVqxoCAZ0f1JPAHssHFAD+WZK4?=
 =?us-ascii?Q?5HDmkxJZN/+JOdvMoqPl6KrfBj76VfqSeCqcSZ3z2S+y01vWUMvqb8huKgAF?=
 =?us-ascii?Q?+dChJ/l60lDAo4Jsvs/M3ANdLDXcLrOPbgsOoy/enaeVT/i8l86M0H04KXIq?=
 =?us-ascii?Q?FAfIMTcX0Ks/AFX1UVMjY1y3Y+SyL5H/7t9sy2Ksqlu+17+tDTXN0jxH2dXt?=
 =?us-ascii?Q?1fkYK1s4tSvdLkBbb5HKbH8tgJwoh2BPBrWmFtIvRdv8aUhjdmST2Ou8Hci3?=
 =?us-ascii?Q?1HMvFO7d3cdufVmUczrRPjF/3hWXFV2/EC2h3QiC2lFMuAItjRB4r6HgOwPT?=
 =?us-ascii?Q?0v6yA09R/ctCeIG1HJDaaDM/wcH0nxfI0OGsBNmn08b5yuDsRynYM9oJOJg8?=
 =?us-ascii?Q?dPCE1v/pIyi5nNIwhLNV2Ipw8tWPcRflwG6vnlUUHfCgoPMIW38J5uwkySJZ?=
 =?us-ascii?Q?ZT4OjiWx6iftLeUYVY631bpLpVwoqCTmXVE+mNiBDHrFQbAvaHpiw1CyHdBp?=
 =?us-ascii?Q?pskNl2C3flmR8ZpiK4q5uiMcFoit3uhtuPmEgpQGbCZxeTCIxm/xkRqXFfeJ?=
 =?us-ascii?Q?RwZxa5jixalx5qqVH7X+pwrZ9sHoPN6jsdW7ZwsGP3T3s/rgPfI1L8OSwVtv?=
 =?us-ascii?Q?QYqpLrhJjiBm1bEox/PFp3RbRa1xwEQmW+oKNqkCOoPubXI9dRDdtZqXvBX1?=
 =?us-ascii?Q?zlVYzfsIGf/Khy3Vk2SjpSlxUvkGX5c9v+TkP/ovHl/LBM9Uu7HlnFajPh/1?=
 =?us-ascii?Q?sCNrGssKsIGjd7/ztxirjWi8tJLLyLSmTEKHNCAyOOyGR5g8w0qLG09gk4MJ?=
 =?us-ascii?Q?V2W5yK9Ke5lr0ANmjX4FXB5vhw1urciYVNvcr0Tgh3yDtX7L88ZhQf+WFQRt?=
 =?us-ascii?Q?cmaGdvSS0n4RvPft8j4c6vLHaiqoaM6Egj0k+DSfHJdeY9Ds6Of1WcqJxivy?=
 =?us-ascii?Q?NG5qlt1WT7AkJbxWV5U2A45sMkcn7nD4bhNSeagG+5ZBQo2nfydfmik0dJdl?=
 =?us-ascii?Q?ieUvXGDVc6QWSt+gc7MbI7FwikXmtKaPlC6U/kTfuqZsOicGKjgyfoKuIaTf?=
 =?us-ascii?Q?x2IqJFDACBxI/RQ1a2BDK4upIhSnyWxYFgec96ldyXLK9TehxsGYEA7r/iRK?=
 =?us-ascii?Q?XWdMoKHA6uPskC3UArq8S1wIIVD9p6IPZDyB9Er6s8IeOEhVMVkYCSsy/Hp8?=
 =?us-ascii?Q?rrozXVgkGcmRI0sxdC7FkfbqtZQ5Z7uG9WojZ+3J0jTcBY2snmjGiAFKD11t?=
 =?us-ascii?Q?/bx9KLoLitBeRAED1Fa7j8bDyMdOeSPdxW2yKbDzw49ZCbfjaFCctz4eBVax?=
 =?us-ascii?Q?p3nb4NE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5423.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FtTuGti/2W9SIEaSeMgEav/WUpHRVFIQP/cgspxHt3h5IyoOQX1JjJPOxQ8V?=
 =?us-ascii?Q?HjHVB0X2ID4+8H+CEEwM1iH5y6jqgNI5o71UTb6K3FAIJC1Qij1Pe8z4MWmz?=
 =?us-ascii?Q?LKq5p30Am+N6fShTd0eNgOi3PSz3ODli5g0wOL51nMUa21VW8PvfrlbY+qe6?=
 =?us-ascii?Q?SVDPaEuksAlGYAkdo+/aeopgVNS1ZIpZzd3gCBFxcQaIR3+u1bX96lqfRWZZ?=
 =?us-ascii?Q?WJ3YIyItY0l6TzKKybysOXMZ2fLrtFoV4LCKRLvk58TaJrAU6eZZnMtwYIkK?=
 =?us-ascii?Q?Jt+vxU3ddt/7Ky7rVXU3n58nuUb0wXCZW4ORoYp3aJVVcX1dzWt6IZ8LAkhe?=
 =?us-ascii?Q?ZZ1XBxp9p5+J2D+GMzH2lrcpFVTTLzAB0R3GMF5/WmWS33LVzW6o20ucYyiD?=
 =?us-ascii?Q?h2sondW0ZZ7uxr0096rHFIA5RQyTXrQMdcCZ/Z/Dh7Lt6jhDDbx0D6TRb/2V?=
 =?us-ascii?Q?52ezilIplI93M9j36NvbCN6aCgwC54Y9T8PbsJiiAWeFXdsNXUnMvckZSFJJ?=
 =?us-ascii?Q?ZZIiXsgfvajKp6+45CBZAkIRSLY+QAjiV2go2X+s7tEV+aR9/1xlsMO5Kx5k?=
 =?us-ascii?Q?Z0blfS/o5UU5MWVBYADJZpIRk49zpzchJW8TdzSphg31edltw7BFreZPlQMp?=
 =?us-ascii?Q?bbOji7co0/X2IVxb/HbqCgIILb1N8KDQQXbI+DQDB2zKOUtjHrcuvW7HY5Eb?=
 =?us-ascii?Q?X0GGMeYJr8yeiR+n0+CyVDjgoy1Y3yXCXhM1MFSyL65I2zCmMBloBh5H6Q4Z?=
 =?us-ascii?Q?VgEOHc/UeVCf8U9/RCGLewrWLXdrT6ty+lWb7ro9CKr7aDm+kZzKK16odCHb?=
 =?us-ascii?Q?DkWFLe7iOpjIUPXN5V6/Iiq9ZzfJ5B/sTXlyYaCagsgXVTwDwee9iGs45uuv?=
 =?us-ascii?Q?58Ecb2AHcN2u7VWax476QdmCl9eh+X9vb1S+eWBgqDyspXFj9VC0Ds/jxx4I?=
 =?us-ascii?Q?2hDd5V/5oOP3lkeRXEuIrr2u12lGhtNjjj/ys/aTde2jDicLMid1fUjOgA47?=
 =?us-ascii?Q?sdkf75ArV05OdUtdwmF7vf8rr+aUfyiL7MsqWIu5Ytima+e1s1h/ldyOwnYe?=
 =?us-ascii?Q?M0vQXwJeRKKLs0ttvtem+toiYS5NQY8g5yiuF2PfQbyqxc16pXnImV9FJXc7?=
 =?us-ascii?Q?POZg32K9XdyioPQBsUPQD2n5oJ7dQ/InDup7LYfe0qa6d0RqxvDPeZWQkjvS?=
 =?us-ascii?Q?oKLhbcKd1s+P6j2zYsmWSLWX4uow5pvbUMH21UVL9fS4G0T7DuzfLRbu3upD?=
 =?us-ascii?Q?R3VrNH3SQ/0oO3/XtgHjwYFLAsuHtgBkarsgo0/X6SZSg2HADtJNfAHGUUCF?=
 =?us-ascii?Q?Pt35/2xnvatShHQZi+We8VdQB8W5r/N2hNByCbZcf8toIpXhOFwU3IpxbMQR?=
 =?us-ascii?Q?+ZfxWgQOA61ta3Mp8k5oPyajlm5XO02+FZabmjGlwU5SdqeJNElOATj8EGBE?=
 =?us-ascii?Q?D7FJmNNNLQpdy/3Pz1Q/qbKLL8rwPI+2owSR/801ijYy5EpQPZ1MxlzkEL5R?=
 =?us-ascii?Q?ljz/ub/7LeLWc6gEumrVgQDAycVy2RuT+1ZEI1N4pi/6XJZ3T5XOW8VYiePz?=
 =?us-ascii?Q?UkcXSuZACtjTGeKBe1DYYQxLZkGXsYXOcxIh1i/v?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a51b3462-a52a-4b36-04f9-08dd139fc944
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5423.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 13:38:35.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YS3xNKieat1O/rpdqFWUb19y/sPEyZNksB4/AqmtkCu8WskOYgt/pe83LrzAUsaPXATQdMlI6ZWy7JaqiX8HPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4627
X-OriginatorOrg: intel.com

On Sat, Nov 30, 2024 at 01:02:08PM -0800, Melody (Huibo) Wang wrote:
> Hi,
> 
> On 11/28/2024 5:41 AM, kernel test robot wrote:
> > Hi Melody,
> > 
> > kernel test robot noticed the following build warnings:
> > 
> > [auto build test WARNING on kvm/queue]
> > [also build test WARNING on mst-vhost/linux-next tip/x86/core linus/master v6.12 next-20241128]
> > [cannot apply to kvm/linux-next]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> The base of my tree is 
> 
> 4d911c7abee5 ("Merge tag 'kvm-riscv-6.13-2' of https://github.com/kvm-riscv/linux into HEAD")
> 
> which is the current kvm/next branch. 

Got it, thanks for info. We will configure this as the base candidate.

> 
> Thanks,
> Melody
> 

