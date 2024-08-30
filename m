Return-Path: <kvm+bounces-25568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B041966C09
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9ACAB1F238A4
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7F81BE25E;
	Fri, 30 Aug 2024 22:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bjpLtdiz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C74B2AE84;
	Fri, 30 Aug 2024 22:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055567; cv=fail; b=gHN8oRLHOwuFm80KuR7iYwZOlCvg6aYC8PqcOUA2cFbEVfJBgsy0o6juswqGDI/0ahLIfAIzfo0nWkcUsmBzOJTUv1BW0DhENwFLySJVpupjBE6acsqcW3/QIfkYguqefy4ysivQ7bD2q7TM2ZAdP3uu5bNK/+0gVgqDKOdZ49U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055567; c=relaxed/simple;
	bh=LJZN2USj1loiAwyTxIJqM0UlxAwZfKaCDPNONQZbquU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S86fi4rwedCTD0WsWAWVpZuYmoU6n22JoTBge/ekrpXdNfP+umeR+pYRNR6HqZ6E+gwLGOoe/CXOTPxXNTgW1FVjv6lbGBS7CPFhTQHIysAnt+jPd37ilYG8XhZV2SlbgFVbFbMo3QwDPfrBpFx1NfUmB269TwXw3FH5mKtsqwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bjpLtdiz; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725055566; x=1756591566;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LJZN2USj1loiAwyTxIJqM0UlxAwZfKaCDPNONQZbquU=;
  b=bjpLtdizY9ePh1vNmPoBJJbItHvc8Tr8U0hZS+EcKhzvvM806XA45NFQ
   9M6Bnd+D4tq+s3Ghul9I0siRzlR75QabaFHBvzAdoIbmcGzDytmLd1NJx
   /QinPPmjdJNlgGD2vk7aethwuTMXCW7JBqNqp80Pt7YtbwR/4zNOJ6xe/
   XhRPuNx/WcN3SecZo8GmgJMV63TEqDzsPbqiQFVxY78LJlXghJgNnOU8A
   SdRso96eJfl5d1Ptk2znLlZDVgf4gk2EKbUbKbFHg8rAQLBebupirQpUL
   31dlqedoEu1g43fE4DAz1f+6wgYW+KPF6xxLszMe5lAZCz00Pg/Ggj9FJ
   Q==;
X-CSE-ConnectionGUID: R6LIxJLdSh2I3Yxjigb7Qw==
X-CSE-MsgGUID: ihp2fzSTSCOLg2Spl3eKCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11180"; a="27590924"
X-IronPort-AV: E=Sophos;i="6.10,190,1719903600"; 
   d="scan'208";a="27590924"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 15:06:05 -0700
X-CSE-ConnectionGUID: wd9oWG5sSG+ALMeMEON+yA==
X-CSE-MsgGUID: XFZorg2yTJac0xbz/H38Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,190,1719903600"; 
   d="scan'208";a="63637395"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 15:06:04 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 15:06:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 15:06:03 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 15:06:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w6h01atVgyhsnj5mkNPZpd1r4bt1xsPJktgTt19fYltVFx4VYMuJb2mGnJUWFLRawxG8k2DWmidgM2OYepppDgp8z2oBKtZB+pnOeUYlLDRuJNxWIJ1g35qHsODsfTpVLBoJOFy4ApOLLuSqSi1NmQfDJtizOBFF69QzbRPN+mPSvv1NCEkDXVfxs30mWPKMgxEuCGBHMYClhZONefFpjgudcdXHkfcnhzQcX9ODBL1CWuyhttz+wOtvfW1XkSFPo67/Mp75ybUF8hgbQQ+D6iKhVczEWT37Zw5oguoOCi3KB8uCiFhm+P/LPYemDtMHPbU7E/8uYZZZhwWr3G/r4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/GCH9ITduJCAm9uqR0ragxcCXWLVbFEQ3qKix3a03A=;
 b=mt6zQU4Y4hj+Ngs6+29F1f1gt8dL9UvgDwBkGcGmQPc4G8pt+hZqFZRDJpPyftQ5vMWjqG833SZjxnLHub911011HUsEnRsc5Wk9aHhUdLX3QTv5DCLbT7vPTq6PYr5LSsaory9HR+KmQvAviLgnGFeJK9EBFjn8DtN4m+OtW4ybpOu2/NKEPT2E0TyOz3tFZcphGH850KQQKw9wAlcDCHlD9noU/vtcK0CksCmP9ViLDnMvZcr63riynsxg7zTEJdNB9PehuH/iQVzl39TlG1Mygg1VEH+4rpV4P+KPNNE8E+rohqU2cuvAs2YqtjXeYObv9UyblOeMVlB79LL75Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW4PR11MB6668.namprd11.prod.outlook.com (2603:10b6:303:1e9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 22:06:01 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 22:06:01 +0000
Date: Fri, 30 Aug 2024 15:05:58 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <adrian.hunter@intel.com>,
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 1/8] x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to
 reflect the spec better
Message-ID: <66d2424628a4d_18c9294f9@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1724741926.git.kai.huang@intel.com>
 <b5e4788739fd7f9100a23808bebe1bb70f4b9073.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b5e4788739fd7f9100a23808bebe1bb70f4b9073.1724741926.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR03CA0249.namprd03.prod.outlook.com
 (2603:10b6:303:b4::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW4PR11MB6668:EE_
X-MS-Office365-Filtering-Correlation-Id: eb7911f1-d45a-4cac-7b1d-08dcc93feefe
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?aA50IuHR8isOJrRA1Z7ZynXxf5TdKWgqnbvutZ0L+IliDfdwj46V1rlX0DQP?=
 =?us-ascii?Q?M4Qk8f5QQoD2l3h6NPUY3LM3tOq32BFE0V36lR+Pi7OliOaNbpjoH5twEVL0?=
 =?us-ascii?Q?xPT3D+ZNnnbaNjqrhFus1xzLz3mSHEdpj5nYyWyktzVaTa5AZGDfhUcbQ6+q?=
 =?us-ascii?Q?zXnSD27U1EcpUrIthprVA+0V3ZHcudKI6+l/6QhYGMwbp6AcmsTJFGh1rKmG?=
 =?us-ascii?Q?mfznaBJXgl2dvmfKOMpZj9EAmYUcIQaaB+30QZyVezflq43TgEVEmHrFLJmJ?=
 =?us-ascii?Q?mVQi5IeERF69MPJ7cdBVZaWW3pyJjiQCDN+3YmerS7g3UhY9dQUW/Z1y3Bp7?=
 =?us-ascii?Q?4+GhNy6B/TIVigI5wp31bxdhuciCCWJ/Et3sXdQbiqRGpexeVFndjc4gPb+V?=
 =?us-ascii?Q?VJT0Zu5K84sqTP316qNI8BjNUFoiBJg3dxOnwNlrYQMKmsIA//xNsfCn0n0D?=
 =?us-ascii?Q?BfRqaRPVj79zn68YEtgmcg5vGYi6BI1Ea8bWcHtg0XCZrp6lFpNjNMOcQAQD?=
 =?us-ascii?Q?mdTuPWTXufS8XxFy/Bt0tDbL4hndmdgFHXCh76XhIqlFBZbEZW1lQbOHeCEk?=
 =?us-ascii?Q?/DscNgjV+/SqV3MCT0TLhi45JSP019okIzEnVw+Cso3eO7tev9yoTvXBYf5j?=
 =?us-ascii?Q?WToYMe4RoZXKmJHZkTeaoVgbCd9YyRLRuC8RiWY51OUX8fQZ6DnaN2ILrWOS?=
 =?us-ascii?Q?Hs6uFtIsn0RPmEAcU5HwFS0SU1U7tdT8HQTUmNYyKzVspMdfqq8TBLv+eT8e?=
 =?us-ascii?Q?GgRqxM4VuapSTwxZ7ZFoObl5UK+5tPvXDfF9U4X+LB+N2G1zuceDobUGKeOB?=
 =?us-ascii?Q?wRWaeDeOJ2YRtOPK/i9bF51r5Uux9Bv3FpIZCoEGGyMSQghGuuTFZolJGwb/?=
 =?us-ascii?Q?J6t5ch1f80BLC5az99X7OkwGVjvQyf9eYci5pu9U69qKKGelYJEdEPFjBS83?=
 =?us-ascii?Q?T8cBdRtfiFi3dPnF4+N6aKW8UDmDaMZnsUX/8trPS93TkuMwX4UVdsqtPItE?=
 =?us-ascii?Q?FZm583VXRV9bJm6f0+ANNWbvkds4ghM4q8Jt9pDRCLCLVcYFkT7zZJ1+Z60Y?=
 =?us-ascii?Q?J9poDglFjnLz6FEQAl57sSDqRiGt9jSip7UeViLl6I2tJUfhb0mhLQ0QSPI5?=
 =?us-ascii?Q?5poFQl0l9a4U6YYBDPmXOKnudqM6o539E+dRHAqrgYwPe391fHpJfAkXDZBs?=
 =?us-ascii?Q?xIYgoHEMpLES2abU61ficJ1odJKd2o592wzhoTn5jh9U/6qOf86bqkebk25X?=
 =?us-ascii?Q?MT2zDfP0tTLEPqZf6R+FuA4NI+yMxFsxpGJ3bPExiobkOkptXRpff9OoaqBw?=
 =?us-ascii?Q?ng1qN8m9ISU8RR9FoiETYCRiRW73ty5q2yxrQ/cn00hRdwYcRnDzHhBvlm3m?=
 =?us-ascii?Q?lmGAHDM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dE30SNxGqDDF8fdOchQbfz5AIJkqiRrQV4JlYgPiotDGiOoOmsJOZSvtidYS?=
 =?us-ascii?Q?c5xek3XWWAIYI562aWYqqMGQDc/ZKRiCaH4MJuK7obE1lFJD5eiQnVKYhX8J?=
 =?us-ascii?Q?b9U3RS0LeaCz5svKDIB7x7AZk9PGWwxSVb4CdC0eNHUU6UD72qBjZgDW2N0f?=
 =?us-ascii?Q?b9ymnZOlxB2f2BieBFL9zbWUFcsZk/I+CyvL/PsUqglyamwmzYPk45UYUiHX?=
 =?us-ascii?Q?umahX3PQgpQqp8m5zKvbRsIUVNl9iEjmk39fnGYcQRTi3eEHbtAVY8MuL6vj?=
 =?us-ascii?Q?bT1dlThnWQ1JyotmJdT/MRa01Z8T8+rkfWF8LIph0ufZNmNLzT9ajX1myiE8?=
 =?us-ascii?Q?wkfL5RT8zfb57OjPBgoe16EimPtcsYFmjFbdR9VOtjUuK/GE2vC2KWwmXU8i?=
 =?us-ascii?Q?3ONelGsJd+LVoXsR5eIqmaXJ/Q6iijG/wASdyApWxfrZcYcR5EEXzGr5Xuw3?=
 =?us-ascii?Q?RHSf4vFTxUcPvI7bKYp3wd06hGVkIz2NdAnm6I4drtPKPGEuyXdxNWzpZupB?=
 =?us-ascii?Q?buZlzOrLzc35KzR2/1vDjIdVZa6DMIF2aKLIxVDCvzR3c2DOd1xDuSW4G1d2?=
 =?us-ascii?Q?flGbW2rKoGBqc48ZIZkZvmjZiZfhnQKD6kPWjsrqtgvQ7+zpP5M+KpaQBgKU?=
 =?us-ascii?Q?axqjON5FAEkK/DsC4Oi6kuojUOZcnpO3vGGphR3Zbymhv4nr042VJlmpYGQu?=
 =?us-ascii?Q?EKhLSQ9NoitxmrtY8b19EAS7hoXBVRVQZpCNdFCaiqofs9fhlsdqwvo6mQK7?=
 =?us-ascii?Q?88FzvUCtcZdynMtKNq1rIOoP9Ppk0wzaxz6Y5YM4HQXQB0U6W9ULLKs5yLTS?=
 =?us-ascii?Q?vP+YHoEn3T6oJrky4cqyXctzg7jlxdkDtltm2KnjYejKBLOIs8sPSMnrAZq8?=
 =?us-ascii?Q?9AhcSDhCVgRn0ibwxS8lFiO0NnDAJxdI+2I2GH+DWlVrJvdRP/8VTSMVHDHG?=
 =?us-ascii?Q?8Huku7WoaSoD9wwVlQzLVK/mo1i862Mw7Ao3vgDdMQkHoPgJtN71d/SOQWPS?=
 =?us-ascii?Q?yaoCoMyU8iqtU5nfDq+MPKfxs3P77cxTdN30E3UhjpbI4IcWr/2CWAWDvq9s?=
 =?us-ascii?Q?XTh1iJT680NPQ2TRH0zXmQfO8Q/4Q841/v5EV38NhZ7hh2Fma6JIx66t6k8S?=
 =?us-ascii?Q?wkUc/ZtuZbT92+1VQddGlDSuuAytJ5cs1EiFiiYDtefmz/aPvgvCPw5/eYLv?=
 =?us-ascii?Q?1OmcHKkIwWLzWVgInhEQkIXe0lI8IFVzoBPdvktLkEZaiOLNU0+ph4YnUy8g?=
 =?us-ascii?Q?moaBu19Lfh1HVjzNGH8nZVtMjp8+lLhjRAPAr1cutLgKFU+zILmIOXWFV5i6?=
 =?us-ascii?Q?/vv/YxeuE5IZ44bWkiTcdEQqMvsq2HFeyPVtkUzXr/BtoK8vIQJSlYhv7U8M?=
 =?us-ascii?Q?WcVOm8Rr34AUSY83atiusKi/Tthx7+NvlR3iuGpQN8YZBYxHjkH7kZ3ShnNp?=
 =?us-ascii?Q?vdiHOhsXVMHAlpsjYRbRcO2eGszkO/jGjXFp042IdwhPEoOtQLnAq+lSWQqq?=
 =?us-ascii?Q?z8PmXF3EVvssekgliXeVG+z8g/o1521oAwKz+CXjU/E1qz007cxFO3FVG2h/?=
 =?us-ascii?Q?NDokDb6YjP5BdyxZb0gd0vSf/cC8a5o/Gdt9MHyHFUnTJGC8znunkgxVO1L4?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb7911f1-d45a-4cac-7b1d-08dcc93feefe
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:06:01.1069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JfXv/j/ZO9c7A7BinFRAsSaQuXTPov3GrX/syEbvbOGrV05P9YhZUhgXjpb3WSQRtO7ny6ZHFAO93P1xx8Qj382Bkig17hOeDv64Gc0PvMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6668
X-OriginatorOrg: intel.com

Kai Huang wrote:
> The TDX module provides a set of "global metadata fields".  They report
> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> TDX organizes those metadata fields by "Class"es based on the meaning of
> those fields.  E.g., for now the kernel only reads "TD Memory Region"
> (TDMR) related fields for module initialization.  Those fields are
> defined under class "TDMR Info".
> 
> There are both immediate needs to read more metadata fields for module
> initialization and near-future needs for other kernel components like
> KVM to run TDX guests.  To meet all those requirements, the idea is the
> TDX host core-kernel to provide a centralized, canonical, and read-only
> structure for the global metadata that comes out from the TDX module for
> all kernel components to use.
> 
> More specifically, the target is to end up with something like:
> 
>        struct tdx_sys_info {
> 	       struct tdx_sys_info_classA a;
> 	       struct tdx_sys_info_classB b;
> 	       ...
>        };
> 
> Currently the kernel organizes all fields under "TDMR Info" class in
> 'struct tdx_tdmr_sysinfo'.  To prepare for the above target, rename the
> structure to 'struct tdx_sys_info_tdmr' to follow the class name better.
> 
> No functional change intended.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> v2 -> v3:
>  - Split out as a separate patch and place it at beginning:
> 
>    https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#m8fec7c429242d640cf5e756eb68e3b822e6dff8b
>  
>  - Rename to 'struct tdx_sys_info_tdmr':
> 
>    https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#md73dd9b02a492acf4a6facae63e8d030e320967d
>    https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#m8fec7c429242d640cf5e756eb68e3b822e6dff8b
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 36 ++++++++++++++++++------------------
>  arch/x86/virt/vmx/tdx/tdx.h |  2 +-
>  2 files changed, 19 insertions(+), 19 deletions(-)

Looks good to me,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

