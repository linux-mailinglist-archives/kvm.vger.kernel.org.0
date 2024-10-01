Return-Path: <kvm+bounces-27756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 908BD98B63D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 09:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EDC4282209
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B451BDAA3;
	Tue,  1 Oct 2024 07:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OkMWs9zp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C881E4AF;
	Tue,  1 Oct 2024 07:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727769396; cv=fail; b=M5hTDF6cNJzz412IbM9asd3Vho0Uk0W0RBygk2ad8erRMM5ZpzremkThwBy/9crmP31z2lZuJvVp0UN5EY61P0FieMPCJr3rNtNgE3xZhZIuPDLaqKq+cuhq1MYKITc7Na11KFmJ0fDntzOoxHCQvvALWx+jZs7ZSMBUlfpj3qQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727769396; c=relaxed/simple;
	bh=kR9l6Xq/nPsF2xX84AqFQ4NjIUcvOs9gU6DCRdR9va8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NPtbbQZg58jZryIOptSE/3rKAG5GYU4GfvHHJuTUIuyc1yisrRpHm8q7w0FuewdUiqyro6OqPpg5TebDTQ3dTUrKgkLhltABq90Wb7/taaBiJGWw8BsVZh5eDLSUgMrol4TaA5S80T/wjKxVDDxjyO9dDi+y1mga6Wzs5DuSkjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OkMWs9zp; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727769395; x=1759305395;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kR9l6Xq/nPsF2xX84AqFQ4NjIUcvOs9gU6DCRdR9va8=;
  b=OkMWs9zpDS/Wj+PsI3SieYkVXM+hhGhiMtPlG9AFhV5gaPnakXZxofpK
   a2/aemQMxoJM2DL0Dc6gPGZMsOJ0hpDi95/eeJqRg7BQKBtbnva8KgHOj
   hATeZ4WRJPKhCaAHQeeiR5HPJtcreMLkM1WRxZcanaE8qHXdGhUYnZV/M
   OxCc0SFW6L5+KDig9OHvHDKKSF6NQzgbe7A/Mupwp3ZpYhS1a4OkywDK5
   uvyugLCo0B4IYyVYJpQC52Xn1/bFaCyohFPWAgrU+DKeSse/kg+z43V1T
   q7kEDhatDnaVEhp48Rdbl5iTuZa4FgNxxVhtGlDu1sCe626v7pkJ8th7J
   Q==;
X-CSE-ConnectionGUID: BBtdMNTVT6qaPKvlD9c8Bw==
X-CSE-MsgGUID: 3WbreRr9S32dTEvWCQIIHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11211"; a="37562460"
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="37562460"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 00:56:34 -0700
X-CSE-ConnectionGUID: ih8Yx9wfTFWYeqCJ3CmQhA==
X-CSE-MsgGUID: saCB/gBlQ9OnMJe8nJ60Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="78310726"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Oct 2024 00:56:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 1 Oct 2024 00:56:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 1 Oct 2024 00:56:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 1 Oct 2024 00:56:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M6QXastznUN2xozRga7UhHrVKVecoeMLHsrMjRr1r7sBHQ4nvH0rWHS0uoQFIIPrGTmwjbWmpVeNfHTqPq9kQyAnnRjJfydwCd41kw7nWAi2/EeNktx5K/O785KbNiHIMIOFl/+spemVcXs4NgmfM/SiXevMMY2CAQO4d9V7eu848Y12RMm1Jw8DIsZMeoJcTbLnzVnUiA7D4Afb2p+rNcOpt06D9U3C3prqhEWpZsPsDvvZHfPlIDFFdsIhFHE1OwSdazuD8ufZJ39HGLXr7LXzvIAzICA1RqEd7XsAvWldJq6hUP/Bpsv39QD5FfvNOGhrExCiY85fF1buwz3YkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/+ZJWSLMSeBTYwlc7aptXGi1n/e4I5VA6fZzIlnaaQ=;
 b=Tfg63S3DzQXHs8xJ4FCgCiPqzIvfAH8sKAOPtk4dAOMpRnzin+2ixcV/OJIZY+XGC+ESCoK8/E7LZaX+RGMxzby3sl5YZwG7pm/hBE/IBpNIQD7fjeVIvzdKMUBRbN8fGKJ24B7VnSaltTqbO5FG30B2e24Fy8YCtRFRqlC4HM1BI0Bf4O9jndZ83/hoMI7daUR6x08g5Bh1i/2168wFQqJg65jfI8GpHsCX0LGFvAvB6fXYvwedKgDUHEA0hnbYXfm8Vgtyq5Xsw7DbEKgi9NCMmFZIE+BjQsGuJjOh90VZDNlpQPI6baH2bKmrPaZlTMd7A5O5QyMSRDZ2PerxQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by LV3PR11MB8695.namprd11.prod.outlook.com (2603:10b6:408:211::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.25; Tue, 1 Oct
 2024 07:56:30 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8005.024; Tue, 1 Oct 2024
 07:56:30 +0000
Date: Tue, 1 Oct 2024 00:56:27 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org" <peterz@infradead.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Message-ID: <66fbab2b73591_964fe29434@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1727173372.git.kai.huang@intel.com>
 <101f6f252db860ad7a7433596006da0d210dd5cb.1727173372.git.kai.huang@intel.com>
 <408dee3f-a466-4746-92d3-adf54d35ec7c@intel.com>
 <62ca1338-2d10-4299-ab7e-361a811bd667@intel.com>
 <a03f740b-6b0c-4a64-9ff1-7eba3ac7a583@intel.com>
 <1b14e28b-972e-4277-898f-8e2dcb77e144@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1b14e28b-972e-4277-898f-8e2dcb77e144@intel.com>
X-ClientProxiedBy: MW4PR04CA0167.namprd04.prod.outlook.com
 (2603:10b6:303:85::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|LV3PR11MB8695:EE_
X-MS-Office365-Filtering-Correlation-Id: 5355ac73-28bd-4870-f8ae-08dce1ee8f4f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?irBNyy6j4GpWh2MeDymeSzDqv9jUi6iFi9rg4RssE7UyPtr8qANJNphlVs8o?=
 =?us-ascii?Q?b06BDPi4a1XiwF87Z6Ht0rHeKUbv08h7xpXYFL0LU76kTCRLhchQ1cQj8Cza?=
 =?us-ascii?Q?auqsUpCHa8LKmmPZJ0UAswDIXCtUYOT5Uy9VVj3sQ8KOoEdivjjha2TFIpJs?=
 =?us-ascii?Q?QTMD4jp+zZCwzxnZju12R22xH2q2rf1F5GRWOoKQiKL6Lb/G/c3+dUGcWB+8?=
 =?us-ascii?Q?TGhAEV4k9hpVzsiQSbIULp1v8TVzaQLJZm4GZ0lVMCui+6BqO9QP6eOGg7ci?=
 =?us-ascii?Q?sEzZHoLpEZ12RKDSuRMHwgDbZlijXkLmeMCWLaQOGltXgf6QveCriW98xSu2?=
 =?us-ascii?Q?i4KvrEjJYV7z0AoH6eQ4BGoFbGF813ylqssVxd0I0s3DQ+EPsNnEbITJ+ojs?=
 =?us-ascii?Q?iz+NTUydPRGWWk6lFyfOrD/RfKj7Wofdq4YvypkkidhUBwgX7U33lwTDA/XU?=
 =?us-ascii?Q?fFqePaVJYlVksfMsrCbHFz1Faz1hfnUWYwoHtVd3WDEDB3wlcv4pM1MyLUtx?=
 =?us-ascii?Q?FdlX56YWECBnEFXU4Gn55YW3p/AHVVmoqAjbCptyhKmkzJMDgwohXCJweAtL?=
 =?us-ascii?Q?ttITso8OjuIM7JSpugxr3dgrvTNFz+KHJFsnICm2IjvpV2hRcNia4qG2u454?=
 =?us-ascii?Q?NyABBWUBfjjMU0Lot8V9tXfCVu3sO5qfPI9xCyPe77yXKga84BgfLsBT9zGX?=
 =?us-ascii?Q?9CnP+vhlY2CNkH2vjHe5PCff8qUAerCUMpJM7IWND7YKohF+8KOa/PVxKYg6?=
 =?us-ascii?Q?CzLEutcX1k+/K0KJROyrgSE+7OHSMVaRqwuli33y/lsJdNGK4LWJdDeKL/Ik?=
 =?us-ascii?Q?E73+QdoPxBgqISS5uTZOfSEoJkiOiPNQFX+1SkGmYTXkjhQdqN6B9elG+kqC?=
 =?us-ascii?Q?kT3eaHrLkBS2v6fJXs+vjv+Tb0kZSw27HWlmbfyW6kMF4rkvY/ZCPU40jz4f?=
 =?us-ascii?Q?xiSOmw3NObk/+xvZ1P0scHP0Q/YJwhV3CHdlvIAdFODo9tmAnS6CQSE1Awto?=
 =?us-ascii?Q?U5T21QTtxcc3Lke3NHXTP+4lWpT9wzkJt1CpT0ydCsPOFWc0Dr0GTfADA6GU?=
 =?us-ascii?Q?YE2JK+TpQtzy2hzRr1tgZGPszRZwtYRQ5g/rqxYvQ23j2KI+Fvh5gIkBXNcX?=
 =?us-ascii?Q?Yo1vsMLJTDlOCu0r6mvin9gtNBKzA9bSLZRkVRY9O7yfs9xPl0datDs3yyZ/?=
 =?us-ascii?Q?boDwAECyAktmEVvDkdY4mfSBrNbH4BpDR+6Y95D3ruSDfd8hlnOL/25AwX8S?=
 =?us-ascii?Q?n/fZlNH0GRLnWEXwxAl68yskoIU0ZFrcbyLbmXOEws3IwN3Eo/8BrSGkg92w?=
 =?us-ascii?Q?ufPuXMCBhAN1ygTVCvq3RuDf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dNtn44oKhYxkWlMC6WihpNrQI3urLg2hHjkVrPcDGYpVpzow2xoyko2irykT?=
 =?us-ascii?Q?CMOkMWnMzawFMS1JVJQ/OpbdPJyKfwvhQ6Z52hh4osqcZFIGqo4pBB+7gjG2?=
 =?us-ascii?Q?rxicewr03810ybuLkramicWsivMCmXr0dsZC/R58kb3oME5B3kRHeQHCrVUd?=
 =?us-ascii?Q?TJpAV+Cf5GZOuYCMeKdsPEhKE/sklZr5wXWEjroQXWrtXCWCPCTCuIVInAq1?=
 =?us-ascii?Q?Kgpo4lyZXvoPeJRHLFVQ5AXoOyd1BmmswTpKtMGXrbGh/jrLdUnuAx0fQgDr?=
 =?us-ascii?Q?S7edQitW1yfpOsJXUZyjEmruGWuSTKXb2OBMulY/fou73M0wtbARGNPwNiCK?=
 =?us-ascii?Q?AnqbObMXEDr5kMwm2UfD9NH1k6hRZAjwV+dE2cnF/l4GSnhyhfQF/qzDUkWV?=
 =?us-ascii?Q?79T9nymgEPxHVtPIRHU2TzqgMhLUN69Wo9P4f1m9pRhom9STtGCX9ZIzx0aC?=
 =?us-ascii?Q?hdWhS4tgNW+H6YwZp8glFmODjM2KWiITvNlxFG+kAyg0kje3SfE5998UDkuN?=
 =?us-ascii?Q?cGDo7TUZxn8GFU8Ct5k0AaZmEplpbCsLMFTp+Dy8HH0rvQotu61HjHXkXMoB?=
 =?us-ascii?Q?ydzmwxIu4d+Il/7SQKnIEo94S3kQVRNcTfm8hAq8n+4FoiXqeENJldGoo41E?=
 =?us-ascii?Q?EDkpt94ZbQFXC5Vjt32PvUNJRJ3ChfGLt6poGo6eaSLBoxz80K1h86BBIkj/?=
 =?us-ascii?Q?gLjyxDz6aLsxSLrXYjP7mw7tHp2j9ecNaVZEmcapc+DwHLk9rCR2PfjGLUE7?=
 =?us-ascii?Q?7JzUuztSHvPf6LfIR6Xhd5rAp0YMMK87EfEW0dJ7ZysRIPftsgcpS3RpsLEQ?=
 =?us-ascii?Q?Qtn+/01/coqNK4IxcKB1cmkQhk7+ROP6AvvA8bvbYWTvOYYv82WiQfL9+9go?=
 =?us-ascii?Q?+CfQP7IpvAT61SH4w+i2u5uX/3HLuJoPGtWa70GmBFDog66rFKL1mGcGADQs?=
 =?us-ascii?Q?bwq4MIPHGBKrQuX0cOH+YvRfAEdw+CshBO0TVTsr4w0hLsfG2fnAYC8Tv02F?=
 =?us-ascii?Q?HcF1T2bxVTlB5M0Tlyx6k5O2bjvKSzHwU860NrfXMgoeXOyFqwu3kPIKRSRm?=
 =?us-ascii?Q?0Mt2IjW5ZAmWT7JMVqSS6rgSUS92mRATANKSbhvpQ/Cs4kIU3XY+LPGIBUZ/?=
 =?us-ascii?Q?30HWKF8ya7cNSKyEDIeU8dOrDAo80K02Qbd0twvqjnpYyXLyQkjiqzIBr7rK?=
 =?us-ascii?Q?oWm8eOcYpqECA7T8KYWeeg0Nfvjx3o8zE0+Y4vuERSOHCw03x2B4G7rKa3Rk?=
 =?us-ascii?Q?3GdDpw3g8vtRxDyykWkR7I5fmGIdBMEe9navG4v9siOJQD3ffoZFyXZ5S0Ur?=
 =?us-ascii?Q?iSfPkh5mOcU2PlLp1gJUWPKI1lgiQ3iyEqxx8J6yVG2oYRabH9rXcbwa0hn7?=
 =?us-ascii?Q?Z2YZu1GXGw6jVTHSJOoJjUwdJr2HZSHI2O6RTrxJ6peL0GkAMRAkgAASsMfx?=
 =?us-ascii?Q?5MnPwhwdzZIHgbnLir4VWtKx3UnA0/Zs89hVMTSNxzXIAW0VLYW9stLE1GZP?=
 =?us-ascii?Q?icN1k1kF3fp8EijogLtxu0qIqebHeYKLrurt31CSDNHDOiFn+E/N3FkiTSmA?=
 =?us-ascii?Q?jiiP4RMap9t73DO7V6jNQwxJbk9R/eDz4z2YbqmbsAb8WMghLegClbdIs69J?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5355ac73-28bd-4870-f8ae-08dce1ee8f4f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 07:56:30.3797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z9EM0Cw+cVPENea+HkZOXBWdMB48CloEUdUPK4VoVUp17giFd6ZL+WMh8x+fyHgMVPVaCfhV2naJDxf77R+e2aNin9a5vCVKJcu0dJlgQvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8695
X-OriginatorOrg: intel.com

Huang, Kai wrote:
> 
> 
> On 27/09/2024 10:26 am, Hansen, Dave wrote:
> > On 9/26/24 15:22, Huang, Kai wrote:
> >> But Dan commented using typeless 'void *' and 'size' is kinda a step
> >> backwards and we should do something similar to build_mmio_read():
> > 
> > Well, void* is typeless, but at least it knows the size in this case.
> > It's not completely aimless.  I was thinking of how things like
> > get_user() work.
> 
> get_user(x,ptr) only works with simple types:
> 
>   * @ptr must have pointer-to-simple-variable type, and the result of
>   * dereferencing @ptr must be assignable to @x without a cast.
> 
> The compiler knows the type of both @x and @(*ptr), so it knows 
> type-safety and size to copy.
> 
> I think we can eliminate the __read_sys_metadata_field() by implementing 
> it as a macro directly and get rid of 'void *' and 'size':
> 
> static int tdh_sys_rd(u64 field_id, u64 *val) {}
> 
> /* @_valptr must be pointer to u8/u16/u32/u64 */
> #define read_sys_metadata_field(_field_id, _valptr)	\
> ({							\
> 	u64 ___tmp;					\
> 	int ___ret;					\
> 							\
> 	BUILD_BUG_ON(MD_FIELD_ELE_SIZE(_field_id) !=	\
> 		sizeof(*_valptr));			\
> 							\
> 	___ret = tdh_sys_rd(_field_id, &___tmp);	\
> 							\
> 	*_valptr = ___tmp;				\
> 	___ret;
> })
> 
> It sets *_valptr unconditionally but we can also only do it when ___ret 
> is 0.
> 
> The caller will need to do:
> 
> static int get_tdx_metadata_X_which_is_32bit(...)
> {
> 	u32 metadata_X;
> 	int ret;
> 
> 	ret = read_sys_metadata_field(MD_FIELD_ID_X, &metadata_X);
> 
> 	return ret;
> }
> 
> I haven't compiled and tested but it seems feasible.
> 
> Any comments?

If it works this approach addresses all the concerns I had with getting
the compiler to validate field sizes.

Should be straightforward to put this in a shared location so that it
can optionally use tdg_sys_rd internally.

