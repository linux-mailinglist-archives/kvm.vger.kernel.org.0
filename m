Return-Path: <kvm+bounces-28596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D69999A6E
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 669CB2849A8
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EDCD1F1301;
	Fri, 11 Oct 2024 02:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DcH34TvI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D502748F;
	Fri, 11 Oct 2024 02:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728613989; cv=fail; b=hFUApH7l3Q5U4YKmG9TbjeTqR3v/uhH4e/tJgB1285BrhLp3Eng9rAJzeWvf9FgduMs7+M7lb1yjKLasE7aKLuWVt5Mxl2K2rX/5rTXdfnekDb9D1PS/9Iv65jZ8k4bwIci50bZLdduqJZeUIgoUC1iGLWfJsdmune7juL1DhDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728613989; c=relaxed/simple;
	bh=WqpwKVC3g9hIbwnOH3fWNYHOoFeIAVVShrE57J9G+XA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hXD+gYwdyWGcbMSGlCExqo6ECsiaH+wVV9TbxpbXWLYYcc/XYkjhhbbeam/UStLi+grS4UTkTIGSPKE2JqRPS3GLUnppAzN+QpRbJ56mbFE9az/KmftEIorLBrT6JR5F86qRH8Lr6HfziTsSbXS9tRKH+a2jAtytgtO8n8U4Axc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DcH34TvI; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728613988; x=1760149988;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=WqpwKVC3g9hIbwnOH3fWNYHOoFeIAVVShrE57J9G+XA=;
  b=DcH34TvIZu1BKScmTqCi6B8b4Yj4vN37Rs8DLqbWAz8rUwG0mDQKQN5c
   Q10jrVwVkM+tul10zexjmIn8jvDq1WFaC8vQHaEhDHmqQ/GzKhSupw68A
   X0SJKkPHbAFe8YNuBcqdmdUrKv9O5+GFZk3PKqfOvjBQ7kIm9IJG1xOYh
   K0l2mCCIuYOkfyPvTJrQpL2ePJaY2dUF86cumkKu9SLckEIuzA44NRMWT
   L7oDRiOFxo7CxR7UJ3nzmfO9EB0k/mA9lDHLQQDyQVQ9XqqHYYU+pha0X
   hKM7CxswQ1nud3eNsCDUSw+IYkpnIwSiLunNebm4SqlvjPF35/o341lDg
   g==;
X-CSE-ConnectionGUID: T3I/VqeyT9a3/B/SaTuP6A==
X-CSE-MsgGUID: lve6yU9yScWK6LvlWONlDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11221"; a="31704375"
X-IronPort-AV: E=Sophos;i="6.11,194,1725346800"; 
   d="scan'208";a="31704375"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 19:33:07 -0700
X-CSE-ConnectionGUID: BAeBlS71SZumo8Wvzhe9sw==
X-CSE-MsgGUID: QNJyvBX4Twu1Fe6X1aBFxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,194,1725346800"; 
   d="scan'208";a="76696351"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2024 19:33:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 19:33:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 19:33:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 10 Oct 2024 19:33:05 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 10 Oct 2024 19:33:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FZ65YBJ1LuM3TkhHRc5JSvRgTK5ZfGfzllk8SRiwrKuUSn0fr0ELlIw2oEVIXzAE8pLyzGt4ibxMLRE74ui8OtyJCxPLiAOAb8GH6CijGvlDTZrEW1+bwf2JmS4QptCyr1v4ZInX3UbofDzi433WQw2F5dvsz/R/eRXLhOPWZkXqGsaNgDpjQcB1rN1cKBlQK7kdqgc6owE+33kOEu5YAAIR/FHRl1m2UrSJWP1e9I/mIpbBfoPQN+ahJFs9C/ZoQ03DoOK0ScWGz5NJD3FgfTmOQTl7pXjFYMPjAWimq334ZL8+EFw6PT0nZrei4tQP1TKA50NfSsK5toUDUEXgag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ReQJ/7yqrXJ7OQUR3k10pE8exfEUfRZ9d+EJW/nidcg=;
 b=Xwo7o1Q6Xv8Ka2L9SwcwQt2KhWTiWs6K2d0FXSg35p0EZPihCG3tDMWzKL/MijicBYwo4FF65a0UOIMD+t2Q0PxLsKwVFEeh3IZiMQZDMboS2/CcSipLV09Cbh1H2PEQHmATXl6oE1ai4vIXBngIqGzqjnF+fMvsvdwal6EJSataDvvycA8rmlOJg6kj1JpgIlLz0c5n05y7azP37oohYrY4e5PrakD00TbxJCcDzdyat/YYH0bu/qOpOpSrjSAOO+/8pZmmSu68mGGT8yu6r6F3VvRMqziEaW+3HPPa/FAD/yUIDafbTmb598AibYwia0nDOKIosAve9I6njhv0Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7192.namprd11.prod.outlook.com (2603:10b6:8:13a::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.16; Fri, 11 Oct 2024 02:32:58 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8048.017; Fri, 11 Oct 2024
 02:32:58 +0000
Date: Fri, 11 Oct 2024 10:30:42 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Yao, Yuan" <yuan.yao@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Message-ID: <ZwiN0sdoLJ6YmpDR@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com>
 <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com>
 <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
 <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com>
 <ZwVG4bQ4g5Tm2jrt@google.com>
 <ZwdkxaqFRByTtDpw@yzhao56-desk.sh.intel.com>
 <ZwgP6nJ-MdDjKEiZ@google.com>
 <45e912216381759585aed851d67d1d61cdfa1267.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45e912216381759585aed851d67d1d61cdfa1267.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0003.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::16) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7192:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dcabde8-5e5a-45d2-0adf-08dce99d045c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?Xc8k0Ma1Sh3H/f7V9UoZbbZLT4BuvBOZ2f+GVUJFmN6fPcZcok+V7VhGLx?=
 =?iso-8859-1?Q?3f6Irix2Q/aDlTotNb6ykvCh2hEiFW9ta4HohPVOM1tkNVEIFRnGKGaI5s?=
 =?iso-8859-1?Q?BCsSCAJQUjLTNtGyvs983kzQCIkxkVd/fB5Mk4OfS0vNaKjNLJAlqmvEwH?=
 =?iso-8859-1?Q?9BogwXiSI4Jp1AZvTYnsb35p8UamVWWlHwtnmLFeGjW/0E/zCAxOFVntdl?=
 =?iso-8859-1?Q?OIWu8tyv33/FDeaBfWX3aOLlA+hqD5/ez5IaezV6l43ysV2rPe2paWpPqS?=
 =?iso-8859-1?Q?sRjSDdbfd2bW28JAXDIRvz7ifjd89OB/+EbxBXXXuxPsSVb6b+HcwXJAx5?=
 =?iso-8859-1?Q?tSsqSI7+7vNn84EST6obUKa6qrFmRZVn2y9zr+cN3k3i3KwCyWy6kr3Pg4?=
 =?iso-8859-1?Q?nuaZ0jFwe5Sy0QBZtzEB9t6GqgjNmgS3pD9qkKlvV7iZhzYA3F8og2j/OM?=
 =?iso-8859-1?Q?CRphlau1OHMgbgFt25akDjZfFKyMIyOxp7imJ9Ln5aQNHJMYFAaANJQz3k?=
 =?iso-8859-1?Q?Uu5ZpBqlz8vau4y0NoYMztq3ErYgIjmCNrOm36Uhk85LMAOuOLtRCSDr9d?=
 =?iso-8859-1?Q?ybxFN3cHS+twHhpR5ZU/kZTfCS/iOlMHb8qf4zDZGdb+zOHq4uj5oSEFAr?=
 =?iso-8859-1?Q?J1IFqT2Rp9vdDQD3ftA8dh4Jj2OdhgN6EPVWgq1oby3KXkGoYDycXTB1W/?=
 =?iso-8859-1?Q?HGgCeOuW7bf4qldl6WCco6394D77LjITSI+8Vh+nPmail/i/dsWv/Q2Rha?=
 =?iso-8859-1?Q?KKwaOtOLo8jDqOUyCupxEu+e0l/LJRfYEgslSYhZGl3Cfhy/KP9e5b6+gz?=
 =?iso-8859-1?Q?Rd/HPElr32GCxTrc/NtyNQbDfmMAVjWbDtZ/TzaYDbYOP8+EOORH/C7J/y?=
 =?iso-8859-1?Q?zavZjH8hwfvQMn6g8d6qYeOKQjnFL60YOeV6RTP36y64njKKhe5RyjJ7xp?=
 =?iso-8859-1?Q?jNva8ZWGuj4bYM2Bn7Ba4c/CN3g+82OQoePEMhSE/uTXw/HDsR2AFemuFT?=
 =?iso-8859-1?Q?DgKbxa8cBN1iqgB39aGMvyQ9N/lVIh0GA/uZURCAXMcxwwC+QsYwph88l4?=
 =?iso-8859-1?Q?X5K7/EtJcuyDsczv4Jgvhj82pkQ79tdDKHX4N2sq6rN6UjVYpQ0Ema3Eis?=
 =?iso-8859-1?Q?MwkUmd7Tp7Y2VOLLukXl65kP6I4kcYN5wI9METKdPULMtR5eQ+FV3rKlhy?=
 =?iso-8859-1?Q?II9WYPg6k3bT7Z6wPujoAzP8wbkp/VHQZaHs2g4f+bFKS9AP7LDhNNbmP5?=
 =?iso-8859-1?Q?6GUKFhK0CPElU7pFjoLBEHXBzTTFZIEf5jHaySBpRLn7a4dp4FqPuz+4YF?=
 =?iso-8859-1?Q?9et9FIuLdrRt0BmIqmwHMGLUJ9SP31KqGHkw1043GxhcuRc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?mVD1fzaNIGOBNOahWv7UmG9QE+v2R/dbBOkDBFFGDpshlvicNJ0UwlZbrL?=
 =?iso-8859-1?Q?99r34/Y3TbkbJGyenUPMf+gxqpZdSKgjEbOGeZM2mIQGEHffS39ToHBNlY?=
 =?iso-8859-1?Q?bz1MrdIUumVE0g4swWTWl0ATsmI6zEZAGG4mrv4ATIaoAO/UslG74VpS/a?=
 =?iso-8859-1?Q?OnlRrNXhUlf2djE7xoumuXPiXxuH4c7dooH1KMRJtmp0WgHlLbyqJCUXMH?=
 =?iso-8859-1?Q?/d4ZFKb/EjEQE1gYmWxLNMZGn57+gAZpVgZkz+N6xljKxxPz9E270iCCyJ?=
 =?iso-8859-1?Q?NFeBHy+ZHJDlz8YoyJOTDA2jPkr0OVcFYd2u1ro2725qexm9BSH9PAygBJ?=
 =?iso-8859-1?Q?iNH8O8aw21UrIMwUTrE3X1ZR+RNRhpnBmLlT3Fi2mpcppgq9O/C/KmeTYr?=
 =?iso-8859-1?Q?UgVtpkr2wdiOl8ba2y9LbRp2DN3rUbQJh0V4dVKvnFWIF4kzgSQfUliba/?=
 =?iso-8859-1?Q?d0NjJFQ0MjvcuDpIwhoAzrUAEUeEzmQpCOiBP9BkbP2ESbK30Q22/6PeOz?=
 =?iso-8859-1?Q?UMhTn64xBDwyeX5LUeGYJD7Xn8xvM0Uh8bXg+iVJdNpYb+d1+4Xh4XNcBW?=
 =?iso-8859-1?Q?lor8FPPZbvedIB8LFsNZ5Oq6rPFCMCGU1zyR0b8s/70EB8xXVJc2KNQ8Cl?=
 =?iso-8859-1?Q?CiGAh4W4mpxTV0TnZcLaE3om2FDhskIbF+47bH2ILqdcS9YcxPVxkeDHta?=
 =?iso-8859-1?Q?v83imbGJrlu27UCUaz69JBdMOsQFeAFbXpeGB3bFNTAiELMRQLymwSJjVK?=
 =?iso-8859-1?Q?D5QVUAP9iWQlDKQUMjay/NePJtWwH+QsFsS7cku7lE3Z78/mxDYU42II1C?=
 =?iso-8859-1?Q?K7VLfpUSqtKdcmfQquKHlvLWmUk+GJmM7kWwSfPY77BgCgxVjSFdKijmpe?=
 =?iso-8859-1?Q?mY9n71mUAXp0vOX9fEU6r7miRTNF6ClXm1NMM5zwu8H/MuF//GJKkNOG/B?=
 =?iso-8859-1?Q?YU6z3MPw04+oUg2Yssm4MmvMVZmw7czpl/U2k7lMh0bWVNQwZZoO8xNSul?=
 =?iso-8859-1?Q?kVi0imO6741j/Sl6XJ8drbSYFbRsUN8R83tDxU/FZOUuDzxBSayFwgFbyD?=
 =?iso-8859-1?Q?W0lr5hIX0JuecCS2u8owEJ3iSD1w3E/ZaIHaGi2u4SdqSYZcTRcQy8GcEB?=
 =?iso-8859-1?Q?7BAhdkKfeqlaDZs4WIiJFHzn8SAwPruGUbLmcFf/lr604AwGNpCnz57/OI?=
 =?iso-8859-1?Q?dZpdWdofb2xe/NsFnDgOlwV/rPmbn4T8IJIQHs7BtEZL2Ff1OSl+vk4mDx?=
 =?iso-8859-1?Q?GdQ4rZ5ZV0nf0OMkiBh3XuOx2ksQB0rxDAvtAqsTz+RRn0JmZJqj4T8uQ9?=
 =?iso-8859-1?Q?iG9J72qFaHgPVls18S5sCY5dImxiM7JkALmaUpBQGFnIHVijp6obU4PKAB?=
 =?iso-8859-1?Q?SW7m6wWpEsfF5tcSMmp1DPbe6T31xcBMRz7ZUK1vJoNNsUowmvBsm6TP2b?=
 =?iso-8859-1?Q?ahWBlBSlc7qFIUowl70dEogM4Fg9VrtCO8ltsTzJAM/eHbRWzcDktJmsoD?=
 =?iso-8859-1?Q?rgdQ+lnZTd2T9J07Bd2GEZoQnkOO7QsKDc8X7oJRnR2NnukwC0NjkodtAl?=
 =?iso-8859-1?Q?miUE9Y/Oorxi5HZ4G2OE9FxVCO59lfUtlKxhShWqfmxu5JQq6eXH9+fza/?=
 =?iso-8859-1?Q?GbCYRk625M9YEgYV5YgxR5+YOu2o75N2W1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dcabde8-5e5a-45d2-0adf-08dce99d045c
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 02:32:58.0932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJZHAfOK9NhJtL606N7qoS5tKjWhwOOfutFwvkc/dv/Llc5In2KDcgntyYnFTJqw+tZI9qj1wGp0402rLjgkPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7192
X-OriginatorOrg: intel.com

On Fri, Oct 11, 2024 at 05:53:29AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2024-10-10 at 10:33 -0700, Sean Christopherson wrote:
> > > 
> > > 1st: "fault->is_private != kvm_mem_is_private(kvm, fault->gfn)" is found.
> > > 2nd-6th: try_cmpxchg64() fails on each level SPTEs (5 levels in total)
> 
> Isn't there a more general scenario:
> 
> vcpu0                              vcpu1
> 1. Freezes PTE
> 2. External op to do the SEAMCALL
> 3.                                 Faults same PTE, hits frozen PTE
> 4.                                 Retries N times, triggers zero-step
> 5. Finally finishes external op
> 
> Am I missing something?
Yes, it's a follow-up discussion of Sean's proposal [1] of having TDX code to
retry on RET_PF_RETRY_FROZEN to avoid zero-step.
My worry is that merely avoiding entering guest for vCPUs seeing FROZEN_SPTE is
not enough to prevent zero-step. 
The two examples shows zero-step is possible without re-entering guest for
FROZEN_SPTE:
- The selftest [2]: a single vCPU can fire zero-step when userspace does
  something wrong (though KVM is correct).
- The above case: Nothing wrong in KVM/QEMU, except an extremely unlucky vCPU.


[1] https://lore.kernel.org/all/ZuR09EqzU1WbQYGd@google.com/
[2] https://lore.kernel.org/all/ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com/

> 
> > 
> > Very technically, this shouldn't be possible.  The only way for there to be
> > contention on the leaf SPTE is if some other KVM task installed a SPTE, i.e.
> > the
> > 6th attempt should succeed, even if the faulting vCPU wasn't the one to create
> > the SPTE.
> > 
> > That said, a few thoughts:
> > 
> > 1. Where did we end up on the idea of requiring userspace to pre-fault memory?
> 
> For others reference, I think you are referring to the idea to pre-fault the
> entire S-EPT even for GFNs that usually get AUGed, not the mirrored EPT pre-
> faulting/PAGE.ADD dance we are already doing.
> 
> The last discussion with Paolo was to resume the retry solution discussion on
> the v2 posting because it would be easier "with everything else already
> addressed". Also, there was also some discussion that it was not immediately
> obvious how prefaulting everything would work for memory hot plug (i.e. memslots
> added during runtime).
> 
> > 
> > 2. The zero-step logic really should have a slightly more conservative
> > threshold.
> >    I have a hard time believing that e.g. 10 attempts would create a side
> > channel,
> >    but 6 attempts is "fine".
> 
> No idea where the threshold came from. I'm not sure if it affects the KVM
> design? We can look into it for curiosity sake in either case.
> 
> > 
> > 3. This would be a good reason to implement a local retry in
> > kvm_tdp_mmu_map().
> >    Yes, I'm being somewhat hypocritical since I'm so against retrying for the
> >    S-EPT case, but my objection to retrying for S-EPT is that it _should_ be
> > easy
> >    for KVM to guarantee success.
> > 
> > E.g. for #3, the below (compile tested only) patch should make it impossible
> > for
> > the S-EPT case to fail, as dirty logging isn't (yet) supported and mirror
> > SPTEs
> > should never trigger A/D assists, i.e. retry should always succeed.
> 
> I don't see how it addresses the scenario above. More retires could just make it
> rarer, but never fix it. Very possible I'm missing something though.
I'm also not 100% sure if zero-step must not happen after this change even when
KVM/QEMU do nothing wrong.

