Return-Path: <kvm+bounces-13013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80BF389007E
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 14:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0BCE1C21A12
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 13:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3AF80BF8;
	Thu, 28 Mar 2024 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OJKKpd9r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346B61DDF6;
	Thu, 28 Mar 2024 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711633175; cv=fail; b=WPyrDOXvr4A7oBabaz8NmfA+Itiwo/uMz8sRUYlPJ3r2aDmt/wlhno4a0RCOzI4ffLUfD4Gf8F/ijGOwzT0B6N5QFjofOzlHB/7APfkTuy6s9uY+3N5T0C2ciExCqIdKvs087JZaeQO8YnrY988CxRyo1sld9gX+/c4cSNRbPy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711633175; c=relaxed/simple;
	bh=76VCfGwzwLp2ul6/ZipM5ISuxtcPsMdEZ8UbyMVX2/A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QcZob+/Yt+W8D/Zf1i3byOuW6WUe1fPeG6+jaR7wjPU+iOUBiR7P6v3H4bAvtDhD0CPi5UPTKOA38YLnpiBXrGLsWg55axFyEQXWhZRfQ/HA6DOyUPkQ7wJbri01R+b+1jrJZWraXAPCfktue5atdPntsqHT/fLyWF+c4NIbAtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OJKKpd9r; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711633173; x=1743169173;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=76VCfGwzwLp2ul6/ZipM5ISuxtcPsMdEZ8UbyMVX2/A=;
  b=OJKKpd9rOfjeAVHm75nOBESGhZo/W8AknUcbG1psP9b/7O3/qSJnbiEx
   khPaonKCdOc+46ILkBdqUEyXqq2uOPKE9yKjO4k9LqjkhhMxkgMeDcAoo
   BJcwQaNzpv970GOlW6rVWxIAw3auj85nZeVTB192GJW2KoJ/hPzm+luI5
   WAyR4sSol5h3+4dD692iNFI48gQOvuuP0pcbccbJCSCuPeEIpXGvdfAx7
   9dls/3z0yfyopoUK3YxSDtk1bX+cQFNJBeTK9T3lgvn8JCwV6BDYULpDS
   dPpqnu7kdFjbNy6+fQo5/dve6+PdOGHH/1uqPejHHAiG5jAil5vRRvTxY
   Q==;
X-CSE-ConnectionGUID: aogIilYlQ/eondu4Og34og==
X-CSE-MsgGUID: viqQ4yCMSTyHNAv6wSMS3w==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17416521"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="17416521"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 06:38:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="21299887"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 06:38:29 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 06:38:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 06:38:28 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 06:38:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XX1oBdDzquW/W4t8fi57pVP0NTvZujGdpf00YbUacObQUaDX/W9RfbNFjOoJOtM2L/qij2xOPAT4W7ciJdyTTBtbhzT4FIYO+9mdrYypcMit18MAmVB+ekiBJdN9wZdvOwIYA284CPUyHeQYNC3bq6vLqpkEtCbEf3p2x/oxPNyOwIYdi3Ol2QcGPTdX/xjp8WYlJs6YjQWu7KkMAcwEoZvidJarpot6UZRYllOpIGJ+xP9YXMlnwycg8Ld+VatDBZHOvUrg/P/ft+NpzHaGo+dpVNNZoz+ILjlvf+lFBELINAbnDM3PFTb2y5x/l0ISZQcLiTPvJgrfeVgEi+aNlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ej4DDpDRMxoUnv5ujCsBpFT60jpyQDQYD6jINmMsjEk=;
 b=NO/QZzKzFOm2JN15/ruNOXgYYUm5Iwj/czi8urnH6Br9F2I6Qf4Y7iSlOGsz4DYBPk+ibprvQ2SBCdR1YRLm3FzmGGfT/87DCzhseT+aZXj/raYtZqDpXOS8kjkIzd27hjtoIeWMaoOH4gwxcBs/YCzDBcH4H4G1730oXCv5Eg9wkGtGN1Gmw2fx/gWue0IObJ2B1louLQxTeNUbjMqDklOXeOD8sCfLE7VH8CYUvpJ414kvEjFZ+5cypxuOUufGQp4dEFlbDC70e8z/Z41OUotrGq9pJXErYf2eq1ptzcSmtqFxOlKyr322pDbl40b0Pqpsy7rPnU17xqRb2ehRXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW3PR11MB4730.namprd11.prod.outlook.com (2603:10b6:303:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 13:38:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 13:38:20 +0000
Date: Thu, 28 Mar 2024 21:38:09 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <ZgVywaHkKVNNfuQ8@chao-email>
References: <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
 <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
 <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
 <d7a0ed833909551c24bf1c2c52b8955d75359249.camel@intel.com>
 <20ef977a-75e5-4bbc-9acf-fa1250132138@intel.com>
 <783d85acd13fedafc6032a82f202eb74dc2bd214.camel@intel.com>
 <f499ee87-0ce3-403e-bad6-24f82933903a@intel.com>
 <ZgVDvCePGwKWv0wd@chao-email>
 <234c9998-c314-44bb-ad96-6af2cece7465@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <234c9998-c314-44bb-ad96-6af2cece7465@intel.com>
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW3PR11MB4730:EE_
X-MS-Office365-Filtering-Correlation-Id: dd5ad7d9-64d7-4bd9-1fe1-08dc4f2c54ea
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xs6IIgxvzLuxyk6YrNOkR0j+YuJ9o4Ve/26UckHxtUeAkpIqukPIi45vfcem009/kCHMROjZpOG4wJKnc96i8qFNS6gR61YKWu/7xKX0CyN2JSaMMJC7gpUiLFSNZwdHKo9V1Oa9KxQV0uq602PnFYqTmE+sYWKR30ZBDwZbrShb1EL13sbtWDP5Pb8K3qdqP06H2vGOS2m/l4sBMVmZQZeAP26FG9D1S8tNsqRWV9fBvVzWekrTz7fMNtAce3OKkVKlkr+/LU49YT2BJc1ALXnHHgEMTh48Di1equ4DXfgZKlH6vtuqnxriWqCWS+hFx8HkiF8tZlq4YMU3zYYZncLKmfYX5L1EjNNe5Gtm4NgaIkezEijeZHtbX4WNsl9AOmdOb768vRODCGSNVrnvCz1fXRIzm5OEOKnSeriB682itdFA3TFlgt4EwvoHhJYYj3MIOVqtXh154nk46XVdpxXI5041ihRKsOJ4TYMzlDw7Z8mFvzCYnJGnHiYMklM89gLt9r18dYngCO4rWpWWpF3m24RGJh/cCn+jl0eHvFeAitOQ8ps7Iy3Mb9eJ5mBXdSrVUFspzU47PLtAZhIxtW5GdL6o9tKUx2NNfxQjBI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?35pn6rxeZJHSTCEUKBziRsZ3ltAvHN8hA/JahDPBlPsrGki/WEjEvilO7u1O?=
 =?us-ascii?Q?velF0vEvHZDLl29zj8YLgecMXnNxNDlztW8Abgbz0LnhunnjCPXDyUHwJg/I?=
 =?us-ascii?Q?h3cKaWjy7xDpuL4aqSudmbQmxaOlUhp9AYhhfkJmnmsz5hC7BJzOlY4Z6wnt?=
 =?us-ascii?Q?iUTuUGqvaY9PwUqzLS3R7Mx+kLUcV4yAY8Hss736tn5jRw1JcpjXSzCsO38S?=
 =?us-ascii?Q?uvRoSlyH63U8zMl3fTS1DuyGGQBIchhYCvaNswGokgQxOycG/TR+KaEirRlB?=
 =?us-ascii?Q?kRGGNvx2ZnhoyPdb79JrENZe85iiJuR9zx5adtdR8RtCNDvAM+fJgYzVMJqg?=
 =?us-ascii?Q?+NoN2nFcMU2VUV5jtCuFdXs0/ANZ51n5oBJm050/VNURpnNwl028/6TTNgEe?=
 =?us-ascii?Q?hts3hodjNr9iyeLS+w2155+D01zRLGyM+neMyuSsnTBW8yCyT9XyTq2Fwrx8?=
 =?us-ascii?Q?7vLp79z59KA2rJpqKCi3eZfosbwKeAxp+3MMxj3rqorjb0CCMoRyvsFoh8/7?=
 =?us-ascii?Q?5xOQ0vDNsRngVnj/bAM4hOd1SsgTRJl8g8oQ2DD2S8qoYNGn7PsnXjw71kzP?=
 =?us-ascii?Q?u6RYBV1R1eFb8uwQf3J8Y02uFPLXBt5F8/I3ymdsTs3y1pjostyMgasMjzup?=
 =?us-ascii?Q?jDgsycaa3VYJM8Eoyee3a/LH4zB1dgemdaTj+d8I/zZpN78yol34MDimzG7i?=
 =?us-ascii?Q?dpaU2b0BvOUTn5rO3nSAZZqKbhB98nkB3/tkqOwsdAVIOe0DlFaFQfE3hZGR?=
 =?us-ascii?Q?7mfiIkQiup/2EXrC8Sgk9TAFaqPLu7HlyL5Mx49ZUYgtMISS0f8COylyHMJl?=
 =?us-ascii?Q?KJT/pfwZYb8T5OAIkXkIASdXua8rpWG9k59t/i1BzgCq6SDfK5oF9yU6cdj2?=
 =?us-ascii?Q?jxT0BdTRKGihV6AsoYLOzR1yOW1HsVTdcWKjRv25wll1RVM5VXEQNmQTWhXZ?=
 =?us-ascii?Q?fIUrynFgpCimvHAd7Xi4tUTYh3mnlwsHM7PSD5doXjLvth0bA3u0TFT/pSzt?=
 =?us-ascii?Q?n78bkNDwSIoL3wnQ8OqZZ+ZBb1N7VblUqI1BTWLEUaUO7KH/utuda+/cZ7Nw?=
 =?us-ascii?Q?I8gwOA/R4nXjgsEIczK1yTI17kKtKJdQF0p0WH9E1dDf4GdS4UGeVYfZC3k4?=
 =?us-ascii?Q?ryva/RuqIb4BSgD6QTfLn4uIaQzODRmddgDB23VVzTrYG2eyxpm/eMcsp10Y?=
 =?us-ascii?Q?AUu5MXwcGmpAr2BufaXth3YeT2UncHpAquqVV2w9y48YRek7ZlN4eVYUuq5o?=
 =?us-ascii?Q?LJAvkV3tvfknRmSSqXLKCmNh+CXWABUhpPBycB5/cLxvL9KhvmwTt1oq2c6f?=
 =?us-ascii?Q?Wb7HheEuRs1rR4+p2Fg0MGeQZpySB/KLzs9mOKfeUvdz3VzVGccfDXIRk0iv?=
 =?us-ascii?Q?rRRkBJQ9XKoKzmMQfbIdxi/rdfnbxFR29YB3ZrcZBHhUXZaZ2vXgVsHKQCh3?=
 =?us-ascii?Q?7LjIaV1yLLCQ5+5t+j+YBEcuJWO8fcaoc1Usr1Dlyjl3+pf0r+c2RvGX8nvT?=
 =?us-ascii?Q?LoCTkvSijkdHJVu8+Y45O7xnl12GvuDFB2RA3TZKX2Xmqr2QA3V4UTKi/i/N?=
 =?us-ascii?Q?rhkFjM9Sr4LMXhsqMQ5qEPLRkVBLbRuNRpCCH4GT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5ad7d9-64d7-4bd9-1fe1-08dc4f2c54ea
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 13:38:20.4999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EEdhsgaR1O5nvVxZQTwfuZpBwMLqPq2KStgM/AC3HE52dvpUQAj1PHyAtTFBfAOc9mitHuLHHgsfRQx3C1carA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4730
X-OriginatorOrg: intel.com

On Thu, Mar 28, 2024 at 09:21:37PM +0800, Xiaoyao Li wrote:
>On 3/28/2024 6:17 PM, Chao Gao wrote:
>> On Thu, Mar 28, 2024 at 11:40:27AM +0800, Xiaoyao Li wrote:
>> > On 3/28/2024 11:04 AM, Edgecombe, Rick P wrote:
>> > > On Thu, 2024-03-28 at 09:30 +0800, Xiaoyao Li wrote:
>> > > > > The current ABI of KVM_EXIT_X86_RDMSR when TDs are created is nothing. So I don't see how this
>> > > > > is
>> > > > > any kind of ABI break. If you agree we shouldn't try to support MTRRs, do you have a different
>> > > > > exit
>> > > > > reason or behavior in mind?
>> > > > 
>> > > > Just return error on TDVMCALL of RDMSR/WRMSR on TD's access of MTRR MSRs.
>> > > 
>> > > MTRR appears to be configured to be type "Fixed" in the TDX module. So the guest could expect to be
>> > > able to use it and be surprised by a #GP.
>> > > 
>> > >           {
>> > >             "MSB": "12",
>> > >             "LSB": "12",
>> > >             "Field Size": "1",
>> > >             "Field Name": "MTRR",
>> > >             "Configuration Details": null,
>> > >             "Bit or Field Virtualization Type": "Fixed",
>> > >             "Virtualization Details": "0x1"
>> > >           },
>> > > 
>> > > If KVM does not support MTRRs in TDX, then it has to return the error somewhere or pretend to
>> > > support it (do nothing but not return an error). Returning an error to the guest would be making up
>> > > arch behavior, and to a lesser degree so would ignoring the WRMSR.
>> > 
>> > The root cause is that it's a bad design of TDX to make MTRR fixed1. When
>> > guest reads MTRR CPUID as 1 while getting #VE on MTRR MSRs, it already breaks
>> > the architectural behavior. (MAC faces the similar issue , MCA is fixed1 as
>> 
>> I won't say #VE on MTRR MSRs breaks anything. Writes to other MSRs (e.g.
>> TSC_DEADLINE MSR) also lead to #VE. If KVM can emulate the MSR accesses, #VE
>> should be fine.
>> 
>> The problem is: MTRR CPUID feature is fixed 1 while KVM/QEMU doesn't know how
>> to virtualize MTRR especially given that KVM cannot control the memory type in
>> secure-EPT entries.
>
>yes, I partly agree on that "#VE on MTRR MSRs breaks anything". #VE is not a
>problem, the problem is if the #VE is opt-in or unconditional.

From guest's p.o.v, there is no difference: the guest doesn't know whether a feature
is opted in or not.

>
>For the TSC_DEADLINE_MSR, #VE is opt-in actually.
>CPUID(1).EXC[24].TSC_DEADLINE is configurable by VMM. Only when VMM
>configures the bit to 1, will the TD guest get #VE. If VMM configures it to
>0, TD guest just gets #GP. This is the reasonable design.
>
>> > well while accessing MCA related MSRs gets #VE. This is why TDX is going to
>> > fix them by introducing new feature and make them configurable)
>> > 
>> > > So that is why I lean towards
>> > > returning to userspace and giving the VMM the option to ignore it, return an error to the guest or
>> > > show an error to the user.
>> > 
>> > "show an error to the user" doesn't help at all. Because user cannot fix it,
>> > nor does QEMU.
>> 
>> The key point isn't who can fix/emulate MTRR MSRs. It is just KVM doesn't know
>> how to handle this situation and ask userspace for help.
>> 
>> Whether or how userspace can handle the MSR writes isn't KVM's problem. It may be
>> better if KVM can tell userspace exactly in which cases KVM will exit to
>> userspace. But there is no such an infrastructure.
>> 
>> An example is: in KVM CET series, we find it is complex for KVM instruction
>> emulator to emulate control flow instructions when CET is enabled. The
>> suggestion is also to punt to userspace (w/o any indication to userspace that
>> KVM would do this).
>
>Please point me to decision of CET? I'm interested in how userspace can help
>on that.

https://lore.kernel.org/kvm/ZZgsipXoXTKyvCZT@google.com/

>
>> > 
>> > > If KVM can't support the behavior, better to get an actual error in
>> > > userspace than a mysterious guest hang, right?
>> > What behavior do you mean?
>> > 
>> > > Outside of what kind of exit it is, do you object to the general plan to punt to userspace?
>> > > 
>> > > Since this is a TDX specific limitation, I guess there is KVM_EXIT_TDX_VMCALL as a general category
>> > > of TDVMCALLs that cannot be handled by KVM.
>> 
>> Using KVM_EXIT_TDX_VMCALL looks fine.
>> 
>> We need to explain why MTRR MSRs are handled in this way unlike other MSRs.
>> 
>> It is better if KVM can tell userspace that MTRR virtualization isn't supported
>> by KVM for TDs. Then userspace should resolve the conflict between KVM and TDX
>> module on MTRR. But to report MTRR as unsupported, we need to make
>> GET_SUPPORTED_CPUID a vm-scope ioctl. I am not sure if it is worth the effort.
>
>My memory is that Sean dislike the vm-scope GET_SUPPORTED_CPUID for TDX when
>he was at Intel.

Ok. No strong opinion on this.

