Return-Path: <kvm+bounces-61948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 78571C2F8ED
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 08:09:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F25BF4EF07A
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 07:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09884301708;
	Tue,  4 Nov 2025 07:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VB1yzmby"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E95C23AE87;
	Tue,  4 Nov 2025 07:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762240101; cv=fail; b=JyeQYWs2Rqrub/Kfi79T5k4p6GRFLEnWknuOHKiOyxlswHfgEkLoG2u96NTjDXE7R3dw9yC1Rh1bilR+w/9AdukFM5rstJyAIy1hc6e+z0Fp6MBfECHVH+vfPtnrzzD0ukRWMVjezh9Ykzss0hoMv7el+zgaCirk78qB2aZ8IlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762240101; c=relaxed/simple;
	bh=VAX0fnfvFmmEXpXjrqepUPvKxx66ZgQBYcisdYvwxhQ=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YEuTWky448Yo6GTMlcolJRiqLpMZOaO8aU5N9nUvB4MRwe54oC5ON+QVYy03reNaGkPRF/tenewPiEm6lQOXCTyJfqZO7jGETs+sy+Znwwtu99qXW2M0RDl7ff3sHQVwO8Xr3Phr3yqMAhshPFjAwmYw7w/TPkTSCyMLKrSZn6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VB1yzmby; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762240099; x=1793776099;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=VAX0fnfvFmmEXpXjrqepUPvKxx66ZgQBYcisdYvwxhQ=;
  b=VB1yzmbyYtvyCf+HuWJR7oGEEKsLEZulVM6Z65ccqBknaj+M0OImqzAY
   sx/8F1w4QPh/cYb1Ll3YV0T7J4ZR1L2Mp26TlamHvRUVvT0CvZO8MYMPV
   MYIYNYWaw2QE4MOeid9IW7NEb2jEHPNUbFbJkUJieBt/wf+404Xb7YXll
   a651txgww61r5MLI3Ycgpfsv20/mdd98MZ0ik1Lx4RE3hKpbS1RG0QMo3
   +9ecqCJdCBX5I4JRU97G3mowZHuqhXLZSoILWEte1UImVNjyE0KKelAUv
   AfDrjMjaHWBbQdcY/YrBH3U/6Hm2Lg4c60m/O9ASiBOFhM+2AUe1Nnh05
   Q==;
X-CSE-ConnectionGUID: dZl7KBI8SG6FLn2mSovpyw==
X-CSE-MsgGUID: Ml4PRrywQhWHAGnAjz/1DQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64024429"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="64024429"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 23:08:18 -0800
X-CSE-ConnectionGUID: dbkvePiZROeCNITF1Mddyg==
X-CSE-MsgGUID: x0TkXesRRyKCV0CuSBFs8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="210586402"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 23:08:18 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 23:08:17 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 3 Nov 2025 23:08:17 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.60) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 23:08:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PEM07QlR9IPIpoi3cn4evMgKvhpMcZhwOppIiUECJ8hRvWVx0IPhb5fgUKpv+u+42vvCTVYKeSt/RHK6IHuwNrimZeQiSJeemc01CrBp7hVznV2HyN9mLrwr/sZ1W4N6Viu23K0IimgKz1fmnmEMxsMy/XBmnQHKaUr3SAWDU5TRnIQt2mgEr/DBh029tmvM3PTJhWwKF3pmlwvd+DS+wyV7LcipkSwXbQOiAN+ZA5e/29cVO1QADNV6EEs8z1wT+muCsFeI4xg8pilVoQb2S3dFanqN+XAo1S4ibkviSgFjf9u/SG4mJwvLaUaS0FUn/ctFZYxVukXnySPBssmegQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H6C4MVpigNNMFzAKmZV7L0RmnpAkoyTqSX/dCoWC9w4=;
 b=mSFfIZyV69a8wQDUeTjzvzuKgTJK8Xa4az7iJKzjWWe+u7bGVN8SgbIsBaeYKlTjaDVtRa11qKL2mMNndOfBdHQyXebHhgoLz8r2NNE80YxPoOWDMjTpM4oSU78xecD58O4t8/bLh1sdoZ/UFnkyTDVvjgxlhxoCBKlSq4MKJvgKmfuGT573jWZoyAmv7qq/Wp10UajpwA/9Ib0y/mCBZ6QrGrxWlsdCrE3Sop6QSaJK8Srn8faVFWBN9M4C9+QOfoJMBuX/Z38peHGXP9/jsHdR2vJqGEaSIQg6Kc9r1WT3rPS6Yh59iTKJgWI6SY5Nou6eQ5p7dMkTWmqe+RF7Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4990.namprd11.prod.outlook.com (2603:10b6:a03:2d8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Tue, 4 Nov
 2025 07:08:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 07:08:13 +0000
Date: Tue, 4 Nov 2025 15:06:45 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, Hou Wenlong
	<houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH v5 1/4] KVM: TDX: Explicitly set user-return MSRs that
 *may* be clobbered by the TDX-Module
Message-ID: <aQmmBadeFp/7CDmH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251030191528.3380553-1-seanjc@google.com>
 <20251030191528.3380553-2-seanjc@google.com>
 <aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: PS2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:300:5c::30) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4990:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fc94e60-b875-4e4e-6f78-08de1b70eb29
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SBx9yOL26uJOAvYHDLn5Xep9QALo3rOsOVeyNMWLpOagFmNaYVbg5OzkC+Gj?=
 =?us-ascii?Q?hu7BJlVumGs1RISQoGXGoiGN2nRsmzLAcBwwUXN/MTdmsYmOmVvO3V61ZpfH?=
 =?us-ascii?Q?sfS2uYIDfudsRuwjNbStJ53Waa0tNl50OlWEYk8yzJZdmacqHZakKBDDKBHU?=
 =?us-ascii?Q?XA9tRdvfRG/GJFDMil6Z6yoxVPoOHsT5cu9046gdsKa7Gg0i6Zm59LC8yVkh?=
 =?us-ascii?Q?6I89GajkuwjVupnKLBxXScunXcK15XAyQ3zdghxKr/vBLxUbQuaManqRApwz?=
 =?us-ascii?Q?D+2j1NG4ov3Lo86HGAKyzFgPyaaQVkKgVinvi+y4gRvpOD1FwPbjjZvUhnKJ?=
 =?us-ascii?Q?ARcBJFGMLhddfALY5tdNQ93ailCWLJKMgfAluFInzC08IuIgy1STOOxUh8aZ?=
 =?us-ascii?Q?pCjsGU7D/PKZ7l1uibGIu/VdIhJEtKKD8EWEbgS86qcKzkiP8MVSaAm4ZhQe?=
 =?us-ascii?Q?VmrFNG+ZYtlcvCNLR2idGKoQO7A08CfhTuRmEw0rXExYPYqzq2qts/vdzRNX?=
 =?us-ascii?Q?mjqdomYgPdfVk3EnHtfyq12mtts7ODY3I697MTCzpQsrErJPdkupnVoebyUZ?=
 =?us-ascii?Q?X5iOqyXuB7XEUFtv+W2W06O2t0XxBaAlfkYHdWH+lKh92A0mci2YYU/pDuwC?=
 =?us-ascii?Q?fqCoXA9VcrQsp4WUwgKnT8RKyvK89plVZ0aSM+CwVthKbOKAvvU82mjsneaI?=
 =?us-ascii?Q?c7+rIUneZ+FQ5dnS/WTqu96zwjrtR+Fwjnlid+KhchH5YziapYjTAMyzXTCz?=
 =?us-ascii?Q?BR5OPSHsU9ndNqJIv7hRGrv5hVYl1PBMYGFxL/j2sjpT5g8GcYlhIROxv++1?=
 =?us-ascii?Q?tNc2ZCRl7Mt9ZAdZBv6RsFce8tdCaXn3ESq/k98bd9Ha1MC5PUJXrGD/10+V?=
 =?us-ascii?Q?Fg4inOL5UOphzt0g5t5+05Etvxhw/JHjvj4m21r3daUufQZqsEM1hW10CvoK?=
 =?us-ascii?Q?KocNeeuGHM8oacbJmDYlyaqFHDnJRuRiCZdRc6wp6A3+w+WVb/ME+1UkIvuu?=
 =?us-ascii?Q?jK+uu4MUN+KMmM+mQDwyg/3smjcKODC11korI5AnOCnndOzg/LcYRz8bFKD8?=
 =?us-ascii?Q?xyJOdw/1khME39HKCxf+nwO7TUr8Z0qnJwkQtf2xoyvyze8rBk6TeZOY8jcp?=
 =?us-ascii?Q?2jRQwyDvlfxOhCgQqsB0xNKJmaYHBeYReFkwq8hea74iui0DYdeF0IZER5Cm?=
 =?us-ascii?Q?H6MN/oOU/RcMJfzMCQT6TB3en5KLrUdyZ9O9NEt7mSK0VPioPd7z8ZEw1LwL?=
 =?us-ascii?Q?s+qNrcksScBp3K2YNkrH2qqpl2PlxSKBj8y2mG/jtoTOZ/7o87gvFT/VjDVk?=
 =?us-ascii?Q?jR7QmAaTEnIiN+38S8K6KDOy7i0KFqAveVCpSEOevf2E0AT0dQHfJni1Xvbh?=
 =?us-ascii?Q?CWqJMjv8USAENvyb2+OINR/6D2Ar8wIOGsLeCQ4NFTXfc0AwVfRba/iAhoTP?=
 =?us-ascii?Q?deguyH8+Bs4q7C4ryRY9sS/XBxBJqooeBr/jK34OeLYfvfqTf7oFui1FGtZ9?=
 =?us-ascii?Q?8ixXxvhIMF0bIIo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rnrem8042qsJfA10iw1soNbtCLyaKSZKYzG4RevlkKnXAiI71KR4DHKyo3IL?=
 =?us-ascii?Q?A8LvvDxgZC9fIm3Oks4QnVICJK6OC2uumuSw3ZQrMfS5GXtxUTyHlXF6l9LF?=
 =?us-ascii?Q?QvvuiFquMiKk0MeZeh/tthTrlJSMGpBET5/17vbx792ZbGWvc3JwtASZs9vl?=
 =?us-ascii?Q?lEqT7j/sz8YkraVWVvwOlbpGqsIwf7yGejrTig4j4qiXkAzwvJk2130i0dH0?=
 =?us-ascii?Q?q7Sfm/PSCnYfoelNIenDn617D+kZH69Cbmbuv6JvxgTTjEZqL3v5DtZKYlSn?=
 =?us-ascii?Q?C4oi2bSyOxEl04ClJyR5fJLb8RsXC6MG3+rFDR/hMUHUDskxGGPJtu3jlcxr?=
 =?us-ascii?Q?sWLSAGR+Cf8q5hlWzRKoE53nU75nXGbSNcfgKLVgJEPl8VdoovgU+jrMdMiR?=
 =?us-ascii?Q?gqoD2e+DVJBKeKDRHFgkzJ73hXw3b8g6I3xPMryN7K6aUxw3YUBIBQ5Cmpcw?=
 =?us-ascii?Q?wZ7jyvlyW28fjEiWmn/UghTQ48aYNa99ADrDI0DJBZ78zXttXPq3zfFnCv5z?=
 =?us-ascii?Q?gDrw4UtpL9089WaypX4nnZsVcPE1yFlA/OUAbEFN5urLd+HUlzu+1TW9M79i?=
 =?us-ascii?Q?vzWvN1Yysq8rXoH7vMkBryLwMg5iFAgYmZkE6pGvgcdWOtP6FefpCUXWDraH?=
 =?us-ascii?Q?Zrhw3DTeBfGm2VwMVVXPpodApmTfkrvJJ83D83NWhbifryGJKjepDS7Phw73?=
 =?us-ascii?Q?YIQJ++AJ8bx+UFVDnhKAekwhYGj9CU54qw51L63ujNCeVYm012g9FA55Tb7g?=
 =?us-ascii?Q?UGiEj1F0GEwB2b/6t1iDu7SS5fznOKcNdmVW3Ivo0qbtE/53FHNnEHJ8N1eF?=
 =?us-ascii?Q?2kzwXPe+5/0EFl7IHIJWKaEeG9/aecLZ7l2K/wQugntME4asVgVkATot6LsN?=
 =?us-ascii?Q?si2GG3uCet13H5CHcph0O1pVAFSgDJiRSsuywl2wtxnIkTchGeBuddaIzOTg?=
 =?us-ascii?Q?R805+pz02HFKGd+I2WEJ6nU93u9AI3ZwxbdeZhn/y69AaFREajnpJaH5TpZM?=
 =?us-ascii?Q?st/AoYB/zv1qOphddwMofTauiI6U1bFQ/X9ZIheC8lKqeh1vbQbcW+pfUNlm?=
 =?us-ascii?Q?MRgd8fvt46EMN6NFEaXpIht/6S5QksTQpxuSzSwGOheJ0EV0lvqsSY6v9210?=
 =?us-ascii?Q?g+l71orlP8e1pRlueUEpbOpW32zaoNhYZTsEpXgHnQPEkqgMxz+XgFWQWebQ?=
 =?us-ascii?Q?kRm0YpqbKZynFm/GUMc6+bziTdR/fEbuRFJTVIpBXQYgrvD9dJa1ad+xHX7l?=
 =?us-ascii?Q?BrYMHhfMD7fe3CsOkxpPcu66sj87zdMnqLiU2JzHTm4PK8E/tv84YgBrEBjR?=
 =?us-ascii?Q?TyvCeNJPsiyiNtO4cqFhUJOHfvYWUV/o+hGT631YzboEoaHyATGxR296BBOR?=
 =?us-ascii?Q?7tnYfbX0bXTMGcnDV7o5BUqkjDGm3sAEO2zMWyJgNvdVL//Y/AE77LWZ8/Y3?=
 =?us-ascii?Q?OsvH+JK/Ag2Eqvp/E6vJ/YfYte4vmTRSjs5oGgGJEpHs1tlGfgnRslb7iXuI?=
 =?us-ascii?Q?mkDbNqEksL8q3Yc/SDOs8w7QR0I+qejEsdbje7CZZNPnqADxovTeCWtU6ryI?=
 =?us-ascii?Q?57hVLuUIlkeLy9B9ox4sEiCFLLQAdZnWHJhzA7Fz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc94e60-b875-4e4e-6f78-08de1b70eb29
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 07:08:13.0822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHSpM6Q8Msyup+ngmrrXxaUMwmjAPcfx3GhuFHQZ64/VOxBW8iA1lFCWh3UblBBMoT78yQ5VCDOtrG2L1KfOxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4990
X-OriginatorOrg: intel.com

Another nit:
Remove the tdx_user_return_msr_update_cache() in the comment of __tdx_bringup().

Or could we just invoke tdx_user_return_msr_update_cache() in
tdx_prepare_switch_to_guest()?

On Mon, Nov 03, 2025 at 02:20:18PM +0800, Yan Zhao wrote:
> On Thu, Oct 30, 2025 at 12:15:25PM -0700, Sean Christopherson wrote:
> > Set all user-return MSRs to their post-TD-exit value when preparing to run
> > a TDX vCPU to ensure the value that KVM expects to be loaded after running
> > the vCPU is indeed the value that's loaded in hardware.  If the TDX-Module
> > doesn't actually enter the guest, i.e. doesn't do VM-Enter, then it won't
> > "restore" VMM state, i.e. won't clobber user-return MSRs to their expected
> > post-run values, in which case simply updating KVM's "cached" value will
> > effectively corrupt the cache due to hardware still holding the original
> > value.
> This paragraph is confusing.
> 
> The flow for the TDX module for the user-return MSRs is:
> 
> 1. Before entering guest, i.e., inside tdh_vp_enter(), 
>    a) if VM-Enter is guaranteed to succeed, load MSRs with saved guest value;
>    b) otherwise, do nothing and return to VMM.
> 
> 2. After VMExit, before returning to VMM,
>    save guest value and restore MSRs to default values.
> 
> 
> Failure of tdh_vp_enter() (i.e., in case of 1.b), the hardware values of the
> MSRs should be either host value or default value, while with
> msrs->values[slot].curr being default value.
> 
> As a result, the reasoning of "hardware still holding the original value" is not
> convincing, since the original value is exactly the host value.
> 
> > In theory, KVM could conditionally update the current user-return value if
> > and only if tdh_vp_enter() succeeds, but in practice "success" doesn't
> > guarantee the TDX-Module actually entered the guest, e.g. if the TDX-Module
> > synthesizes an EPT Violation because it suspects a zero-step attack.
> > 
> > Force-load the expected values instead of trying to decipher whether or
> > not the TDX-Module restored/clobbered MSRs, as the risk doesn't justify
> > the benefits.  Effectively avoiding four WRMSRs once per run loop (even if
> > the vCPU is scheduled out, user-return MSRs only need to be reloaded if
> > the CPU exits to userspace or runs a non-TDX vCPU) is likely in the noise
> > when amortized over all entries, given the cost of running a TDX vCPU.
> > E.g. the cost of the WRMSRs is somewhere between ~300 and ~500 cycles,
> > whereas the cost of a _single_ roundtrip to/from a TDX guest is thousands
> > of cycles.
> > 
> > Fixes: e0b4f31a3c65 ("KVM: TDX: restore user ret MSRs")
> > Cc: stable@vger.kernel.org
> > Cc: Yan Zhao <yan.y.zhao@intel.com>
> > Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> > Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 -
> >  arch/x86/kvm/vmx/tdx.c          | 52 +++++++++++++++------------------
> >  arch/x86/kvm/vmx/tdx.h          |  1 -
> >  arch/x86/kvm/x86.c              |  9 ------
> >  4 files changed, 23 insertions(+), 40 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 48598d017d6f..d158dfd1842e 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2378,7 +2378,6 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
> >  int kvm_add_user_return_msr(u32 msr);
> >  int kvm_find_user_return_msr(u32 msr);
> >  int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
> > -void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
> >  u64 kvm_get_user_return_msr(unsigned int slot);
> >  
> >  static inline bool kvm_is_supported_user_return_msr(u32 msr)
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 326db9b9c567..cde91a995076 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -763,25 +763,6 @@ static bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
> >  	return tdx_vcpu_state_details_intr_pending(vcpu_state_details);
> >  }
> >  
> > -/*
> > - * Compared to vmx_prepare_switch_to_guest(), there is not much to do
> > - * as SEAMCALL/SEAMRET calls take care of most of save and restore.
> > - */
> > -void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> > -{
> > -	struct vcpu_vt *vt = to_vt(vcpu);
> > -
> > -	if (vt->guest_state_loaded)
> > -		return;
> > -
> > -	if (likely(is_64bit_mm(current->mm)))
> > -		vt->msr_host_kernel_gs_base = current->thread.gsbase;
> > -	else
> > -		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> > -
> > -	vt->guest_state_loaded = true;
> > -}
> > -
> >  struct tdx_uret_msr {
> >  	u32 msr;
> >  	unsigned int slot;
> > @@ -795,19 +776,38 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
> >  	{.msr = MSR_TSC_AUX,},
> >  };
> >  
> > -static void tdx_user_return_msr_update_cache(void)
> > +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> >  {
> > +	struct vcpu_vt *vt = to_vt(vcpu);
> >  	int i;
> >  
> > +	if (vt->guest_state_loaded)
> > +		return;
> > +
> > +	if (likely(is_64bit_mm(current->mm)))
> > +		vt->msr_host_kernel_gs_base = current->thread.gsbase;
> > +	else
> > +		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> > +
> > +	vt->guest_state_loaded = true;
> > +
> > +	/*
> > +	 * Explicitly set user-return MSRs that are clobbered by the TDX-Module
> > +	 * if VP.ENTER succeeds, i.e. on TD-Exit, with the values that would be
> > +	 * written by the TDX-Module.  Don't rely on the TDX-Module to actually
> > +	 * clobber the MSRs, as the contract is poorly defined and not upheld.
> > +	 * E.g. the TDX-Module will synthesize an EPT Violation without doing
> > +	 * VM-Enter if it suspects a zero-step attack, and never "restore" VMM
> > +	 * state.
> > +	 */
> >  	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> > -		kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
> > -						 tdx_uret_msrs[i].defval);
> > +		kvm_set_user_return_msr(tdx_uret_msrs[i].slot,
> > +					tdx_uret_msrs[i].defval, -1ull);
> >  }
> >  
> >  static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_vt *vt = to_vt(vcpu);
> > -	struct vcpu_tdx *tdx = to_tdx(vcpu);
> >  
> >  	if (!vt->guest_state_loaded)
> >  		return;
> > @@ -815,11 +815,6 @@ static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
> >  	++vcpu->stat.host_state_reload;
> >  	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
> >  
> > -	if (tdx->guest_entered) {
> > -		tdx_user_return_msr_update_cache();
> > -		tdx->guest_entered = false;
> > -	}
> > -
> >  	vt->guest_state_loaded = false;
> >  }
> >  
> > @@ -1059,7 +1054,6 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> >  		update_debugctlmsr(vcpu->arch.host_debugctl);
> >  
> >  	tdx_load_host_xsave_state(vcpu);
> > -	tdx->guest_entered = true;
> >  
> >  	vcpu->arch.regs_avail &= TDX_REGS_AVAIL_SET;
> >  
> > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > index ca39a9391db1..7f258870dc41 100644
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -67,7 +67,6 @@ struct vcpu_tdx {
> >  	u64 vp_enter_ret;
> >  
> >  	enum vcpu_tdx_state state;
> > -	bool guest_entered;
> >  
> >  	u64 map_gpa_next;
> >  	u64 map_gpa_end;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b4b5d2d09634..639589af7cbe 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -681,15 +681,6 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
> >  }
> >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_user_return_msr);
> >  
> > -void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
> > -{
> > -	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> > -
> > -	msrs->values[slot].curr = value;
> > -	kvm_user_return_register_notifier(msrs);
> > -}
> > -EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_user_return_msr_update_cache);
> > -
> >  u64 kvm_get_user_return_msr(unsigned int slot)
> >  {
> >  	return this_cpu_ptr(user_return_msrs)->values[slot].curr;
> > -- 
> > 2.51.1.930.gacf6e81ea2-goog
> > 

