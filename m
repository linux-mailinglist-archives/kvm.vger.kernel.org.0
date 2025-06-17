Return-Path: <kvm+bounces-49650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB46ADBEE6
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 04:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC3CF1893818
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 02:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F0871CAA62;
	Tue, 17 Jun 2025 02:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ew7PSfUq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75531C5F30;
	Tue, 17 Jun 2025 02:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750125782; cv=fail; b=enTWN+j86Bo6FOKzwCRXqRrI5mpaizfWxOUfKR+ThRaEaFduGlOxs3qaWOY2cFSh8cp80S3hL5IY570FmvfeiD/v1TbopRg/xwCVYc8B6FzrnKc0o2HAa3Xr9ncKW8NjsoMqhn1MfkrTtedisuZdDKfVf7WbNU3QLoG6yL6YlKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750125782; c=relaxed/simple;
	bh=gHIinETKz+Si0UDVBglLDfdS20U+n9H2daDi0H+ihGY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TQeGprqAHvNF0gQe2eOIyifJt/wqnxas6oL1n6yc+HIGY4kEmV2NDXvRWVi5hqyuIDYiRPnh+BYAx9dSgHcLVvAy/t7uX9YbI6YRe1sVb9g6hus5fNu/MZPiWuQBekgGa1t4FoWjaKggymxYG5w9YAjBPz4+fFuZEVg4raydj+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ew7PSfUq; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750125781; x=1781661781;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=gHIinETKz+Si0UDVBglLDfdS20U+n9H2daDi0H+ihGY=;
  b=Ew7PSfUqsylLlTp0mJms7kW1YyirEvvxxDOKsjvksqNVvL3FNzXyRQdf
   hT0+yZi+OP7Nb2fAtUFvGQH6ko+FXf6URi1HPst8N0XOtbnonETAvxDg+
   SX7/OmkQTEeThV8DUMk0+h1ZOQg21toKInXxVW5TUx6bg37HSMQXVhTyq
   VSBDO0yDx95/PpVErgA+KtwltjVSaEDvjm0u3kVp81ldtFCtF24dYG3Za
   YGnkVdyNTKEiAEQmiFimamz2v4iLyeFD+sSmA/iWAjtsp0q7YOfbDiLHG
   sQlZJQn/Da9bhE7z37IZGM3vQ+XxRuhqEqULe/OZsEgtSnRHwLfzGi0ar
   g==;
X-CSE-ConnectionGUID: 3hL5jKlTSxW0DoNWNqYf8A==
X-CSE-MsgGUID: 5lQ9ZCApSVOuhzEpfyzyHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="62936398"
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="62936398"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 19:03:00 -0700
X-CSE-ConnectionGUID: rMxBbwJ7SvGC7VCace6sog==
X-CSE-MsgGUID: NxKZgTG2QKSBrBsRVhCXkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="185889551"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 19:03:00 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 19:02:59 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 19:02:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.54) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 19:02:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YWf2Ssu4t2PhcyF/bwkdLuJ8Wwp0ESxdqEglLCERB9BgkOFDl4Iu9pKM+VCZv0Puu4+cGshsgywkxS6PDHqVB9MArdCleBsg5wVVrzje2+rAuVk7Mhz1yifPMYOca27BIwA54LCNqrAUupvl7ORQyhLP20q/wK7QuPrKUrPca1/+dGJ/URVgp0pLeQhePnibWmDhXyXwuGO+G6mLHzE7RqtLje4nOenEUfxpdlNKcZThK6EeNj5aHozq73c3jdgs94iJCrsY9Zaz/PwLyTWjwwNbpm1tLJonnAz1KtLNUiLiUtbAj7ZRZ8Llkke7Qe4eOvUienGwAeG0wp4Jogey0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KW1CY6tAzdTVAnWkVXI1L19XORkySISQOpmY659pn6U=;
 b=dlyaekpxum276GqxgLsPuOELamA24yhBIEuDBKvjoI6yGY82iDr4JpezMjrlLuf39z7wazVuSj+bdKNRGeIO8UATt2wejjcznTPJHM8tXPgusg3ejwNfoo2vnFnKfM429vTKvBm91yLGEy1Ok0pkRn+DJLVPmxvtVgyEFLk4jC4+mxdHkZnA9lydnNAjdSMyZNg+K/zk8W94K9WpKUA8hHUfG5XJvv/fIGqJ4sEtBa1sQzxN0rLqifKWunFvgxIzbMABtOKyu6rfEnChlvCuAek9TWy/dl8h7bGc+WHR3YnpyopFCRlul7tgu6s2CBeV3cHUhd4wKtTLp6EnunnwbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB6891.namprd11.prod.outlook.com (2603:10b6:930:5c::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.18; Tue, 17 Jun 2025 02:02:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 02:02:56 +0000
Date: Tue, 17 Jun 2025 10:00:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Annapurve, Vishal" <vannapurve@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFDMO5mefGubO50c@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
 <6afc4b972858db7c98f682ec9f7975e2ca38db31.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6afc4b972858db7c98f682ec9f7975e2ca38db31.camel@intel.com>
X-ClientProxiedBy: SGXP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::17)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB6891:EE_
X-MS-Office365-Filtering-Correlation-Id: afb48b80-b3fc-476f-b04f-08ddad43140b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?HWbmfjbdbRD/nnCILwVN8xnTbbCaak2WNNlFSykXt3weiDViVh0dSH+5YQ?=
 =?iso-8859-1?Q?8UtBHh71gOUnI9P3UxbxTj8LDbHxZdocp1DF7wpYboHLs0zX+egk365RRf?=
 =?iso-8859-1?Q?aRcyr83jEn+jViZs72+yKnTUPMsoeLlqn5L2nGrGzPiG5CSaOVTPcmb8Y9?=
 =?iso-8859-1?Q?85dvaD3mjegzu86irezyLfFU2jch/h4LuAR6CFE7ZNuFbh86X0oiTmHKxH?=
 =?iso-8859-1?Q?I9t2Wd7J3H1Lzw9WJB9cAWEZdk1sOAPb3Iw8HZue2GKM6eZ92IIeDkr00W?=
 =?iso-8859-1?Q?LIzZcA5I25m9ANUGgeEjF/saaK8bnZzCW9xVqK8znFsYpmYsUmQH11LeBo?=
 =?iso-8859-1?Q?NMYcvViDEBjKd8M8Ma/EisWQ8B0H03WnK/2p75hv1VAP9vmuLTH8bL7sBc?=
 =?iso-8859-1?Q?TAwkt/E56BURYo0AlX3Czr/EpqMWHS5uKtNLqHD3A5yGH0QzLBf2B/rnFi?=
 =?iso-8859-1?Q?FaPnn9CpbUGk8SGwLIyJjuy58az2qKcGAexz6WFZ4U/yRF5lUG/TTY/Tne?=
 =?iso-8859-1?Q?3d/CmeXjS1Ea27AS8kB9wVyMn2GU3bAo8fFJnhg/ek+WEKbwa1B3OlF3m1?=
 =?iso-8859-1?Q?wh/0KV3DmPfMMW2EKDbgCNGExAhadsmZcIMtCoiWgRXL9FF3nTBJJMSX8u?=
 =?iso-8859-1?Q?8r9kAs0A6zD5nv1884wRi032NUmIvF1bOwgNUTaxNNQlsvZGjE6Rij70AQ?=
 =?iso-8859-1?Q?I5lMPPUkmzKeOmSeCxSayg30bC6gru4Uma2KdFE17+IEjRYWme0MZnzjle?=
 =?iso-8859-1?Q?MRtvND0HxX59La0F8tlvkAtY7NLu9XmjrBenj7xNMxdPB487pJ6Hde/COO?=
 =?iso-8859-1?Q?nHtLSBLaoImN2wu9c+46A361684NITflrtpGXf3A336FffINm83zMYIo3r?=
 =?iso-8859-1?Q?h7lS/hp0rUWcUFEcL0bUTaJhAeHazlajZEdyNtNprYFGz83LvOLNZW/XQ5?=
 =?iso-8859-1?Q?Gi1/Afcoc370n4VA6RLdRDUpAbhORdAWgGzXlRkaWAIJOt2Wdx9T7CSFGl?=
 =?iso-8859-1?Q?ZbT8i6eGZ92+hS+SKttsiiRZ/cjyXD7bcLuZ8GmCHucg5ZxsinTkPEf6ma?=
 =?iso-8859-1?Q?ChUhGPqEfrgVCj4rL5/IlkKG6VBa10U6CxEk8y2BUQ/FLMkx2augwFScYh?=
 =?iso-8859-1?Q?TirUVVFwyDp/wesPnkEMvT4j6xfu/7OeIn9ef6uFSj8jG9vPnHC0I6MemE?=
 =?iso-8859-1?Q?GAM/lzP7nFP/oylr91hB/W8VVszTadge0HEI6X2KON4313JuiAS9EncJzd?=
 =?iso-8859-1?Q?n4sl5FQxpCsRiqlU04bRvnSwur/w3/Lo4TPP7CjRDIHfjDRdrsR36I5XyU?=
 =?iso-8859-1?Q?4A9fcdO16MI9TZmcKhcbo1hhma0vnd7wv9z4HjNd79qLluB2kFVyf6eEVT?=
 =?iso-8859-1?Q?fEtTeqqJBCfdVp9CK6Z7CwQcCFhbwntDSc2I0ou7DkebbXxeykCbR+qOm+?=
 =?iso-8859-1?Q?x0fM5izf0qjINYLCPrmJZ+cVMSEJ5UsF5RRq57OACRzFCJ970sPKoWWmbm?=
 =?iso-8859-1?Q?I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?2IO3tsrEl6Z4Lfl17eODbQTtz0zqbmEO21/SsnU0G4D+vPbPoTgNTTHqsW?=
 =?iso-8859-1?Q?TycRu4ImhYygJ9w8hU9UXfqog2zXqK+CYp+jTwTIzkMmNq8ZC1r18Ba8I9?=
 =?iso-8859-1?Q?qB/omf230vf8/JHBzMK6mjbSlE9GNW6L3jX/SdXOFo/DHiLy7doim3HJON?=
 =?iso-8859-1?Q?oKRhcz8sS/iBnIfE3DGLoBOPTLcxqB14BuGOoacct3n4T/P/KSCCDCaKte?=
 =?iso-8859-1?Q?8kA2KsNmHEpNFvxLVT89/hL4n1RPLUgJ/waVabjdFrrQ5p6kocrtOoV0xT?=
 =?iso-8859-1?Q?v4s1Kb/1SlTdKH4tZV8HgeZFMkOYTE/QQsfFfSLfeVRFH9d/okCKP6k995?=
 =?iso-8859-1?Q?lQgczpacp0wqiKGfOe0oQWxbHGxzaiKTuNG5RIlsOfNKQ084SDVXUSJY4u?=
 =?iso-8859-1?Q?/Z/4yUrMbDr4jBQGZIIq5UFCr6yw97yY+73VjJNx+7bl2/iNmDTgn+HDEB?=
 =?iso-8859-1?Q?L94IX0snkdJR/rRDMxKyUMxKwmAeeEXilz5u0WwRdB5lOAzn8mX77qCFqo?=
 =?iso-8859-1?Q?lK6DKgkED/B2L2xmEwXicTbP8mfWnAvMWT7tOTspuYeCYqBUdKRsHNVxBN?=
 =?iso-8859-1?Q?8LKCh2hZsrrxNYpoeX6Ps3DSOEb3UdHcRN4Pqx3n0uD0NcqoZSV8zSAJdW?=
 =?iso-8859-1?Q?10QosdiOSTvoY5N1B4FSegJS9wAS/o4MpPnJmxyij1n9WBkYD2ufQEew5S?=
 =?iso-8859-1?Q?E3ms+nIilS+HKtmF10tlqccJhzTUZvcR62XVJPiJh5t3hxbTXH+VTU9msb?=
 =?iso-8859-1?Q?lMvFYKge5Hei5/RkAnQgaxvZs36YACHgPv5PHM7r7OtsGsfl96WZdbYvAi?=
 =?iso-8859-1?Q?JO1dt6yeq8TSLVTDw8qzZ6csU36rUPmireIkJDTIHF/FlZxt+u5eYjLTQu?=
 =?iso-8859-1?Q?NQ4XKy9O5RQJfmwBB19UkVGHQbckgcB6pqfrGfQqtOct6lUboylWZ7HRFk?=
 =?iso-8859-1?Q?1c5bHSVuTMINfcyOuiS9yPDijzC3pqnTznN/UQ/y/8W41Zzj4zIOhRJUgm?=
 =?iso-8859-1?Q?w+KJ9col9kAd4dSLaTPBj2z5wQo/flF+1CAGOcfGFevopAQmVfWufD/qsK?=
 =?iso-8859-1?Q?lHeV4McZNH9Dt490U3oLR9KCsMytm5kEX8U/pryxvQ6eo2XbzfxXYU7gQF?=
 =?iso-8859-1?Q?8L8/c5y/BnSB1Z6Uym5J3tVZ3SMXB8V6QXSlXNLWJakDIEUUe73EgzVj6w?=
 =?iso-8859-1?Q?3WXgzwHl6evEocNoUSpXO5Xq6O+99KAuUQgntmfeL/bv0A3XkXSejXz8Ni?=
 =?iso-8859-1?Q?1waaT949JHUnYTaCbUESpNeY33tJgBjKQNSuE6sWWA81eI1i08XSD8JQl1?=
 =?iso-8859-1?Q?dPVG3CEt7yuo1e6dZ/UoQClJqW3g3R0PM1iBToNOqL5GX6wo54fR+nkonh?=
 =?iso-8859-1?Q?Bt4axsrrPA0GtWEuHfsPGutRq3S5dPMrlsci3g8kVLt6uiqFEuW1t9zR2m?=
 =?iso-8859-1?Q?CNIgcdsjshNMaEeH/CGd9An6s6Ca32f16bqWHUuhopXqn1q0ztGKXL1r0H?=
 =?iso-8859-1?Q?uKzRnSKHI8mpjs4m/cOFy2NvJ0H9EpKLscZTKk8Z9CLuiMOGqNc3P34HDN?=
 =?iso-8859-1?Q?UgcofikXpdFs7kYn+G+CxfOgBrwkUz1QdiuGDYemRTFTWqJMvr5XAwzOUE?=
 =?iso-8859-1?Q?DsJwm35pl3l1SEM1sdqTW+hqEJJvgFhjV3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: afb48b80-b3fc-476f-b04f-08ddad43140b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 02:02:56.8966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dcZu8TH5PMKxaBMQN0yGtdj5z3WrQqNPenPdvW2HBUXaHD40KPhjcISI67GdMq8kLE6ayF8KDYg7S4inEvWMqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6891
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 08:25:20AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2025-06-16 at 17:59 +0800, Yan Zhao wrote:
> > > Few questions here:
> > > 1) It sounds like the failure to remove entries from SEPT could only
> > > be due to bugs in the KVM/TDX module,
> > Yes.
> 
> A TDX module bug could hypothetically cause many types of host instability. We
> should consider a little more on the context for the risk before we make TDX a
> special case or add much error handling code around it. If we end up with a
> bunch of paranoid error handling code around TDX module behavior, that is going
> to be a pain to maintain. And error handling code for rare cases will be hard to
> remove.
> 
> We've had a history of unreliable page removal during the base series
> development. When we solved the problem, it was not completely clean (though
> more on the guest affecting side). So I think there is reason to be concerned.
> But this should work reliably in theory. So I'm not sure we should use the error
> case as a hard reason. Instead maybe we should focus on how to make it less
> likely to have an error. Unless there is a specific case you are considering,
> Yan?
Yes, KVM/TDX does its utmost to ensure that page removal cannot fail. However,
if bugs occur, KVM/TDX will trigger a BUG_ON and leak the problematic page.
This is a simple way to constrain the error within affected pages. It also helps
in debugging when unexpected errors arise.

Returning the error code up the stack is not worthwhile and I don't even think
it's feasible.


> That said, I think the refcounting on error (or rather, notifying guestmemfd on
> error do let it handle the error how it wants) is a fine solution. As long as it
> doesn't take much code (as is the case for Yan's POC).
> 
> > 
> > > how reliable would it be to
> > > continue executing TDX VMs on the host once such bugs are hit?
> > The TDX VMs will be killed. However, the private pages are still mapped in the
> > SEPT (after the unmapping failure).
> > The teardown flow for TDX VM is:
> > 
> > do_exit
> >   |->exit_files
> >      |->kvm_gmem_release ==> (1) Unmap guest pages 
> >      |->release kvmfd
> >         |->kvm_destroy_vm  (2) Reclaiming resources
> >            |->kvm_arch_pre_destroy_vm  ==> Release hkid
> >            |->kvm_arch_destroy_vm  ==> Reclaim SEPT page table pages
> > 
> > Without holding page reference after (1) fails, the guest pages may have been
> > re-assigned by the host OS while they are still still tracked in the TDX
> > module.
> > 
> > 
> > > 2) Is it reliable to continue executing the host kernel and other
> > > normal VMs once such bugs are hit?
> > If with TDX holding the page ref count, the impact of unmapping failure of
> > guest
> > pages is just to leak those pages.
> 
> If the kernel might be able to continue working, it should try. It should warn
> if there is a risk, so people can use panic_on_warn if they want to stop the
> kernel.
> 
> > 
> > > 3) Can the memory be reclaimed reliably if the VM is marked as dead
> > > and cleaned up right away?
> > As in the above flow, TDX needs to hold the page reference on unmapping
> > failure
> > until after reclaiming is successful. Well, reclaiming itself is possible to
> > fail either.
> 
> We could ask TDX module folks if there is anything they could guarantee.
> 

