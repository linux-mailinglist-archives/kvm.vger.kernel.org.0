Return-Path: <kvm+bounces-26028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 489D796FC9D
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:22:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B85EB2439D
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 20:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350C11D7E26;
	Fri,  6 Sep 2024 20:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NXHuL3u8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B1E1D79A3;
	Fri,  6 Sep 2024 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725654127; cv=fail; b=qgvmIPnEXwc/dy8+8leDGkmD60gQOhi51+JtusHtNkMqU1vmi1aSohkhVxCRk2Ir1ZiHnqt523uvEObVvx4cDAmXjSFpo15cqKtzntxHL+MzxL15YKnbQtIPlvNzKhjqPHIrpdEkH6C/95E6PmAluw1Kut3z17Ft69PGYhb9WkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725654127; c=relaxed/simple;
	bh=QT4fOeX212NKkyN80wBSnAMnVk9UGlZ8pq2gRpUtCaw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bwcWFp3l0hY8jdc2DqI2pimk738vROA56eeyGODHFg/BLPp/AK2GXbxoQGvuR6KXPXTQpwEYjMXwFnf0+ItjTOjUAkNlj4drfUdbqGmia51vj1bzULMzbLkdsCyAdIzkC+f7y2cXMPoZGF4lNen0wzer5Ra8ZANPFS5WbH/M1Yw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NXHuL3u8; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725654126; x=1757190126;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QT4fOeX212NKkyN80wBSnAMnVk9UGlZ8pq2gRpUtCaw=;
  b=NXHuL3u8iilp6gfEoAq4t6TIsaEwflkwvFV6kOi1FAp/Gx5j2mc8GqwI
   zWeeXyrBOdvRe3rSLrLr5IZhf+cH8MI7NvUjybLLhlGahPJfzbM3TQ9vu
   cdpUffdS1jF6N0mKma+QDsjJgpxVz04AzItV89z5+SjJplWQl0V7DBZPt
   nxN4X6jJ78EiIrm3sBtSbUcftN0redilCQY/wZ842yZ/SR1M/N8z2A79Q
   CuPaksHEY79R4bzRqaA+B7/m4xR15fbkpG1UurwgK4wtw7GzcW0E5ojx4
   +NU4LVL1hCujwxwFxOs8Fy6TIyR8pqQ8Ja7Qu3QdmKiSR+x27DsJwq+tj
   A==;
X-CSE-ConnectionGUID: U1EChlQbRCCpN0XrxDBaeA==
X-CSE-MsgGUID: euDZiVrvRIiviF3qejIeNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="28307542"
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="28307542"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 13:22:05 -0700
X-CSE-ConnectionGUID: 1n6mGDpmRN6pgUgQ5unYgw==
X-CSE-MsgGUID: AtrNKXcSTtWEM7W8D5J5eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="66391173"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2024 13:22:05 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 13:22:04 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 13:22:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Sep 2024 13:22:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Sep 2024 13:22:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iftX2MbpGVLLgFObdldRCGz4+y77zm2gCltHXyj4ZcrUW/7sf4uoQamKhKiapMcS9M3Z+2Mx62R66IVTp//p6GrxmfWgV7sxSFzTW46h6jXD29FudLHCtFHiuiwuK5PHGNpOPVDkAByYWFxs8nAPUevpw0isMDAOkdSoKluWPXD/oK+/BDXY+Ctz7hDOhyNtJIc/g9BH5rFlz92kp2jt11ufEAxFA7wuxh3tZXsGoKLDoHyr6Sx0zV8LGwJox9YmhgOx3Bp/E2JgAdC60m0rXgxTBxRggGc8PCth0gxKnwNiDiQo27M9pTfyAW07xsUrn+y9y30Azx3nyCPcoN4bxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4I6hhnGChw4LyKKe0ZzsJYwi3mTUKydDjBUJPpjD0IM=;
 b=arr5bpKyj9BfAg0YMVH48wyZPQQPgdRoekuLuZKKbdXnLyVN9hMTiMp/0b4slRaXqinFhoARZUM9n3Ie4ZNtr3YfJJYvsjAb/RtbJ09xfqcgl7HE7Y/0F0U4OKfEeBzsDivOtNAXSWGZ9rEzwVreukiNf4Ql9pE7mwnn2tktq1AxQSPXT08piUlruOk1xTCk7AMDbG2xg7COYfI90L7e+2l7dn2rWTJmeUic/QKZTDVUcFeDZeSnzw7jFqiyOWYPDIhvhGWqsCHz28z20FaOAEb0K9UwcHi7NoNeHjKnXWtRQZQi7ebDjURPa4h423oq7MKqJ61sfMvs78uhWPAMYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB5264.namprd11.prod.outlook.com (2603:10b6:5:38b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Fri, 6 Sep
 2024 20:22:01 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 20:22:01 +0000
Date: Fri, 6 Sep 2024 13:21:57 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <adrian.hunter@intel.com>,
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 2/8] x86/virt/tdx: Remove 'struct field_mapping' and
 implement TD_SYSINFO_MAP() macro
Message-ID: <66db6465cd956_22a22943d@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1724741926.git.kai.huang@intel.com>
 <9eb6b2e3577be66ea2f711e37141ca021bf0159b.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9eb6b2e3577be66ea2f711e37141ca021bf0159b.1724741926.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR04CA0374.namprd04.prod.outlook.com
 (2603:10b6:303:81::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB5264:EE_
X-MS-Office365-Filtering-Correlation-Id: f1f996dc-35ae-4f45-bc19-08dcceb1907a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SvuFAjIIYtqLzRf2PCFXfMy8GBhabXvvuG9rGSkg+dmLyXLpSqU53Zmn3g/K?=
 =?us-ascii?Q?asC1IQqqCtnALB67VkMU1rAdAymYjRF68NGlmGUXMqdNpi2YbahWe6m2a47V?=
 =?us-ascii?Q?GZ0x9WXkR0bk5mKtcK5N4MIuy4/F/3k6Ca2tyhoUdGoDNVTunaXK6wyNOnQL?=
 =?us-ascii?Q?ZN2KrRQ9FVW0wX8XnqE8Aa5bnGra6OfnImGkekEJSFndMBA64LDC9QA3OiHX?=
 =?us-ascii?Q?buUe19/ggSkQPspY671zBUap8XcJ71aJVy7UJBa7H4K22PtssIjhW5roZVld?=
 =?us-ascii?Q?ZBEQroLL3ttEujfhYZIW+rrMYx1MT9juaMkDXNB+2L7EoXd4vdmYPo0A3Zax?=
 =?us-ascii?Q?ehwMX79b2EscZ/JfjueHeR9n5EMUXCivE/niA2VogTqufs8cCFbDeWaNAKhQ?=
 =?us-ascii?Q?day+ki3rWAPskl4JC7wbpOBr35U2fxW2u8DKGXgTzXPUcNc/EMYpgDQU6Umv?=
 =?us-ascii?Q?8oVVtWolKjKLehGoDKwPjeZFBBe3PPAvApnGNY7hUhttJqUNppdXqFfqUpEx?=
 =?us-ascii?Q?ki/ry4Vf/shlWNX/tgMVucqEzRikO25zHGPzrmBdbUl8dr4oSGbdq1HRKkf6?=
 =?us-ascii?Q?hSPXz7UE+nk5Ub6NnaetJFv8C5m+Ns4Y7e+yqTKSNfIvRa9dkCTYr/ZM+CD3?=
 =?us-ascii?Q?/aUFYF+frziu6toqMIrQOjxIu3ppkuntYZROjENoT/9DE2s/hUJmt+J0JFxR?=
 =?us-ascii?Q?tlRvhYsbj1mgXi1aMHqEulLQn63z/yjUlF1BMqu0jPWpM4kpVmJXzkRl/s2G?=
 =?us-ascii?Q?btWbwhOh4nDvTJ27N0B1eMobM/vEfNTSxwZ7giO0RT3z/yscZPvM0wpNLYDS?=
 =?us-ascii?Q?jiEZCprzNZYfsJ+F5t9rPjwaSv6M/dby6LhWC48/N5TFmjQh1pnBtXT5LpKF?=
 =?us-ascii?Q?xVgwoBdJKQp05DDSuJBMcjVqfj3VvxFlGDxgL0IR5mjgQKDvcYavK3v7vPo2?=
 =?us-ascii?Q?8aKgpBfhtYw2v7zoGKbwYdz7RH2ePObuHMo50L5u1umE1+kH8jbMW9G815H8?=
 =?us-ascii?Q?nhSVXNOq54PirIxZ6PTVblgPkCkqLBAaX2K3PvihKTDICC1h+daRCpXyvzx6?=
 =?us-ascii?Q?1d/i1D0W1mShdOoNqcGWEywR5U2CHX4btZEzTZvrFx/hpSpaU2t9d1cPLjtC?=
 =?us-ascii?Q?k+zpVyB2xMGVtT2iY/NLO7mgJQrkBOyWEaC1sWIWKZ+Sw3g5VSqJhwMHJ15T?=
 =?us-ascii?Q?7p0yxvMONebeSKwJobEQdqRw36/cKEhVP/69W9BiscmDqanECje13XThjm1s?=
 =?us-ascii?Q?kY3RpW6b8zmj4Jo46WFeK8PdKaUIowexkbqS+TYxuXFky23/nN2aMQ60rA7r?=
 =?us-ascii?Q?7Wl0O6p2lS3d2Wne0VidZFyvOBrs2isCxQtEhe/JB4kVr3GKCYC/AmiGGslI?=
 =?us-ascii?Q?VCUpHRA+UuWDln7b4ceCxpGUecpfzQfdnJjKxa37vvPTfNezJg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3OOrnt/LHbD19AXayzLHaHKRfVYwfAexGnbhw3diX+E2AKszZ7enGA/Cig5J?=
 =?us-ascii?Q?O1ilttpuGgKg2mOaKi891JkBwOazONFLyQH+j6PoO3jptl1VnZpJXJTsbtaF?=
 =?us-ascii?Q?V88XAdE/MXG7jyxC8qEqHwzIEp72pxcUHyoxqwssDlIdTtMHQKaHx1mO97lK?=
 =?us-ascii?Q?v+QWrBLSBFFvymvitomLCk4ecjctazhkLG/KCwcEdLWDLtna/0cKHLnBrZVM?=
 =?us-ascii?Q?m2zpz14GSlwgU0xZOAxYxr/DcCYWwLYua2TfDI7SXMvIhXQ/CKtZchhSzD4h?=
 =?us-ascii?Q?BUU8t6vr/k9dKdHZxhtkEcPbiJivc1SsuVuhQBWaTJgkOZyItD7o5OysVGGD?=
 =?us-ascii?Q?HQ7kDq0KUeRL1bP+Y7hZW9XV4+i5nzlCA6RgA8FXY67cshBuTjeYE/r1YMd7?=
 =?us-ascii?Q?0WRczCDXF3BOto7ii0rc7GeOKGy+l7o7G00yeULIvBk+poNQt3/8wOYTS+rK?=
 =?us-ascii?Q?a5JVLDA6rdRjom/J7R4oCQtYi0vu8NuMWlJnNnDd0jmQC0IiDa9J4uNbyXqn?=
 =?us-ascii?Q?+oj3LPDt59Vqygm96dK1XvcdtfQTCQSxVEG7PiI1uZrBBlTwYQClPuZ+iHy6?=
 =?us-ascii?Q?V7SFNg4X+aOxlpvMfukgYL1DybapfQJBK8Lm7qwsJdq1kLMKb8IGo6/gVgBo?=
 =?us-ascii?Q?k/SC7QiaWYcJM1fm5Ta2A5Q/lCncn2eYEnFl3GhxYxgStk/h/NwIg3Qpzvhi?=
 =?us-ascii?Q?iqqETlvsHzgT3R+zGiRdxMYBydiKRJ9rslpOUEtvtb0nlS5nHhouRoJF/drI?=
 =?us-ascii?Q?5SrmiH8qanJpyEy2bfDSqBVMfcXuyiYIFzg4k8QHHHB4EsLuf9IdIn4YH5B9?=
 =?us-ascii?Q?Mr7vVXB7kUYZZatVCs3kW7LmZbyy++Ka/0VxtqSimM1qjXfbY7jarN5MR0Es?=
 =?us-ascii?Q?gtEcjdWyFgId5AvIviXPsS8Cle2WkhSct9AoVcKnX3gHPTVHCNc+4CbFQQ1A?=
 =?us-ascii?Q?UyxVwqydOU2bBYAyqdNeipf4c+j8Q/E+iLsVX46S1GPGSNDmQN0NWU3fW+nJ?=
 =?us-ascii?Q?y6QnJ3/nDpcxxkSeR2Nz5ljb02d1i5Pc5tq7KBPjjmkdJqNYBVQXjcW7SEvj?=
 =?us-ascii?Q?DaaXrhHYQrX3XsZbIwvVQbilaxljbuTGiMC3IsfHMPm62uireRFcVOAHkUlR?=
 =?us-ascii?Q?jBFuoe0msdGVYpW3kYon03o5o5sD6W+2/oQGsorhHHb22TexCA80UZ86efeM?=
 =?us-ascii?Q?QbJulreGlska/eT/Kc3L4W62bCBCSFKKQAbpCJzw4quhy675kSHZR757ej4T?=
 =?us-ascii?Q?0J+s7zj3hM4+zMAznKi8YIOeXDtEr46AtBa/dZFGbeY2X3FINXMkFLne8CAw?=
 =?us-ascii?Q?Q4jDjy4D1HLZZ2mJIh92aMmvR0d4BfsygNtgaKbh2MQ/zaZqnDZnnaw4se87?=
 =?us-ascii?Q?LrHpgU7KaoUBbJL0T9CXC6NPnLvd/19EOw+i/ptV8Z80xUn2Y49ItwniwtPb?=
 =?us-ascii?Q?TocSU7GDAlx8BM5eLFmDwFmqKcuYHJLokU1JErXiHF5bRd9brkbfQudgIxWK?=
 =?us-ascii?Q?xjIvyxIE8AHBmhCj2grerHKFWJP1aenAkdhGgo21qnidzNgBkrT1wa7D+t/E?=
 =?us-ascii?Q?abO+TdkDLXt7YYleAq/BXd7sNpCRWvFhsRTx48Va9aLLxCiCGn43JJk6dKt7?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f996dc-35ae-4f45-bc19-08dcceb1907a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 20:22:00.9435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qXIKp7hRb9Zfq+pR1HteOih24ck+onrunrX0eAk3jDphYATKKXzKi82dK16CO+4zUDvrXy6JfedBuTzaHS9+T0iMwFShdYFkTG5U7VdNZKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5264
X-OriginatorOrg: intel.com

I think the subject buries the lead on what this patch does which is
more like:

x86/virt/tdx: Rework TD_SYSINFO_MAP to support build-time verification

Kai Huang wrote:
> TL;DR: Remove the 'struct field_mapping' structure and use another way

I would drop the TL;DR: and just make the changelog more concise,
because as it stands now it requires the reader to fully appreciate the
direction of the v1 approach which this new proposal abandons:

Something like:

    Dan noticed [1] that read_sys_metadata_field16() has a runtime warning
    to validate that the metadata field size matches the passed in buffer
    size. In turns out that all the information to perform that validation
    is available at build time. Rework TD_SYSINFO_MAP() to stop providing
    runtime data to read_sys_metadata_field16() and instead just pass typed
    fields to read_sys_metadata_field16() and let the compiler catch any
    mismatches.
    
    The new TD_SYSINFO_MAP() has a couple quirks for readability.  It
    requires the function that uses it to define a local variable @ret to
    carry the error code and set the initial value to 0.  It also hard-codes
    the variable name of the structure pointer used in the function, but it
    is less code, build-time verfiable, and the same readability as the
    former 'struct field_mapping' approach.
    
    Link: http://lore.kernel.org/66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch [1]

[..]
> Link: https://lore.kernel.org/kvm/a107b067-861d-43f4-86b5-29271cb93dad@intel.com/T/#m7cfb3c146214d94b24e978eeb8708d92c0b14ac6 [1]

The expectation for lore links is to capture the message-id. Note the
differences with the "Link:" format above.

> v2 -> v3:
>  - Remove 'struct field_mapping' and reimplement TD_SYSINFO_MAP().
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 57 ++++++++++++++-----------------------
>  1 file changed, 21 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index e979bf442929..7e75c1b10838 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -270,60 +270,45 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>  	return 0;
>  }
>  
> -static int read_sys_metadata_field16(u64 field_id,
> -				     int offset,
> -				     struct tdx_sys_info_tdmr *ts)
> +static int read_sys_metadata_field16(u64 field_id, u16 *val)
>  {
> -	u16 *ts_member = ((void *)ts) + offset;
>  	u64 tmp;
>  	int ret;
>  
> -	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
> -			MD_FIELD_ID_ELE_SIZE_16BIT))
> -		return -EINVAL;
> +	BUILD_BUG_ON(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
> +			MD_FIELD_ID_ELE_SIZE_16BIT);

Perhaps just move this to TD_SYSINFO_MAP() directly?

Something like:

#define TD_SYSINFO_MAP(_field_id, _member, _size)					\
	({										\
		BUILD_BUG_ON(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=			\
				MD_FIELD_ID_ELE_SIZE_##_size##BIT);			\
		if (!ret)								\
			ret = read_sys_metadata_field##_size(MD_FIELD_ID_##_field_id,	\
					&sysinfo_tdmr->_member);			\
	})

