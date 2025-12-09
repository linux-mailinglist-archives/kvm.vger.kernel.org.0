Return-Path: <kvm+bounces-65539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3F1CAEDA1
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 05:19:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3E4DB3007216
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 04:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBC62D9494;
	Tue,  9 Dec 2025 04:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="REYwSKWN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04993239E76;
	Tue,  9 Dec 2025 04:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765253954; cv=fail; b=C2gmGBY9lu6nAPiE93jQ/SxpDbNRlbblp8ChXGPLBoL34dbaIwI8Rozc0FvuuWvZpPJ680DyunERGZIk9S+gkSrzfmRzDMspEe3KTdUr/HO19CNTCBLQ9foAeMZ+nnBIHmJXoLeZUch6cEWircbDp2vOMkNJz/maO1z70r58Isk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765253954; c=relaxed/simple;
	bh=mFTE1P7rVCNJsbKyJixyJbI7Y/CF2BDSQzBPR000URs=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=Cw1SmMf8XWoyWl+g90/8ldNW1DvFpsasTFlK2Dqskd7nMIr46m8KWtNYkjl+piJesoXQ0A3jRm1aNvkbLJ53L2GoP0sRzy2z5cvffFwx2SIepYCh3dyeuvSzP0CWfMnHfqWfOT2XlF6l16slcGZMYMo7OA2YjBXPRlm/BUCGjxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=REYwSKWN; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765253954; x=1796789954;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=mFTE1P7rVCNJsbKyJixyJbI7Y/CF2BDSQzBPR000URs=;
  b=REYwSKWNZPNaMkdXFFjIM9Zuop9Z92tNywse0tCVaiO4taF9duKTcvAp
   L36jSCI9XsuWbAiNmnyzcNcw5Iq1o4GQaXBTcxsH7trVOoSKuOumDZCyI
   qINlKlpJK+TE5m49VLaQU+69N2aiwyqNhNLEqO3/bj+30IDYxoFytGwah
   CkJr5EIIxNkjvJidKEfoeHA2KQSAuq7+suQbXeMWOrn8SCXLiRm9yR6GY
   KnzJQN8OHQtlkNHyMfWZPGLKXNUGotvR2/QOSco4Q9Lxq/R4hPpsf4r5l
   uvVIL3Ok2ptP+l+ZYB5Ri1PCVFGdPE5F7PXlqpa3MlO0wZN5vtT1ChnNf
   w==;
X-CSE-ConnectionGUID: UQBjY1wRQ0anSzW2tQNkuw==
X-CSE-MsgGUID: 0vI0PqMGSUijpbVW8T4Ydw==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="78670700"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="78670700"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 20:19:12 -0800
X-CSE-ConnectionGUID: uWYTFuHGRvmLYfR51Iy90A==
X-CSE-MsgGUID: 9/glS9lLTh6sXzx/GBTPtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="196020374"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 20:19:11 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 20:19:10 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 20:19:10 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.26) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 20:19:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j+/vQu+Abyvq4n2FKa1NavmAj4U+IBcgdYtgkuN4So/HOm0bHJ5OdERv+VZtni2yrms119fPyLE3qQoe4UIrp9ZQg4dWWd9GXYTH4vqUOytx2G5aCUanZv4M9hC9FP3/wVZWa51wMMk8LOIbA3mAt1C0AI5c9QWjV+CzjcxRw0ezyr3m9V+FQYvyI92Rbx+I+RO3qbrHPUiFYmBMijOQ1yKAvMGIbeW+IG78qiDD+CYpLKVuoSvJHE0xuxkLmy0LBhtGR9Sb4aMDh4++q3zvKSF7jZbEJZ1sONNfvzUUdbU8Pekv5M73wMz6X0ewia4sxwWhrGLq/v7t4pKF/+lszg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ai/4D625bhMldpp2+Z4+dMO0sWkeVsXx+izOKR4DxE=;
 b=jPYCHvaqQe+TnE2zVQ9cW+2IJ/bB66u5Y7K8QzEA0ExFFdx38sNHSS9kAha+ZjIuEFHKv702Yr5p0zJcmoCwFbj48Ge5+dq320+3Bpr8/4kuIV2aGVfHMzDYFDV2QysGX2B5UvAdVGfARd95mAznMSi43xha8/YKyPA93zqCDvPAkCa4NX5H6fnvcL9ZbYmBMfolkxT6pENRW7j/mLzrS0nOh8ehFU/FA5CCXpscKDMA+Zhk4tfb62f/pXFgIiX7Va33JzMmnid7OCc/yFTGmbCyl1HiuF5pGDht3jznQfPtTUBlwbVSJn5WSzzEKRQe/iubII39dpbPvFYw3zfYFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6285.namprd11.prod.outlook.com (2603:10b6:8:a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 04:19:08 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 04:19:08 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 9 Dec 2025 13:19:04 +0900
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, Chao Gao <chao.gao@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Message-ID: <6937a338ac782_1b2e10072@dwillia2-mobl4.notmuch>
In-Reply-To: <20251206011054.494190-6-seanjc@google.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-6-seanjc@google.com>
Subject: Re: [PATCH v2 5/7] x86/virt/tdx: KVM: Consolidate TDX CPU hotplug
 handling
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6285:EE_
X-MS-Office365-Filtering-Correlation-Id: b7baeabf-074b-4ea2-1586-08de36da18e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MzNXU1VXVXExRDlRdFgzRWRFOU9ZVCtEak5UTlI3ZE1qejRTZHNmUmJHSi92?=
 =?utf-8?B?NHlHem1yRDZ2UVlvMmF6VTFxTm9FVDRVRnQxK0FrYm1LNFk0bDRYb1N3THhK?=
 =?utf-8?B?S1B0TUZzUTJSRktnWUtEWUNxODVMd3pxRFdjV1FCNDlXZ3FPT3RJTXFxMDRC?=
 =?utf-8?B?Q1plSzRCLzJ5VHAzQWJJTG5hUldZeERVMTBxaW9ReVBQdkJxRWlBYnIrb2Zw?=
 =?utf-8?B?elNXKzhxampJd2F0a1JrSllpWENWSnUxcjJXWDYwZUUvVmFMTUdicFpnSEdI?=
 =?utf-8?B?YUNOQitRb2o4VzJxU1RLWWpGOE10VjVudmZPMnRvUnUzTGZqTnFaRHRyY1NT?=
 =?utf-8?B?bjhWMzFRdDNFc3drRk9mSTV1SGpCUzVPRThlTWFRN1pNdnlSSzBPWkh1blB3?=
 =?utf-8?B?NlBpcHZjcnozTWpIZnd2NGNaRzM0NWFxTzlyc0ZVQkl0TmsvR3N1QnY1MUoz?=
 =?utf-8?B?cU85ZGJGOHdRRm03T2JtNHlLTHk1UmorUDc3NFp0ampEYmJCc0N5R3c3SGlt?=
 =?utf-8?B?KzFHLzBrRUF0NnE1Tm16dy9PeGdFY3ZJSkNZd1AzK3M1azA1aSt3NFdxMlJi?=
 =?utf-8?B?V2s3Qmd2Y01QS0dTNlRiclJQTmdZOTRoTkVyOEYrZFpVTitBUFNOcko3dVNK?=
 =?utf-8?B?SXFJZFVvbVpIR3ZQdHo3S3pkZTFMS1craEVzbjFESS9Fdml6VzQ2SjNFVkhq?=
 =?utf-8?B?UmtndmZHQWdteEVOdUxRc2JFMU1qZzRPbHFNTW1DY3FYV1AvUFNweFdmdVg1?=
 =?utf-8?B?OC9PWTdUcU5BVlBPNXZMSGw5bnNFNmhUWTZoYjZwZTJDZUdQaFl2NkxWQ25v?=
 =?utf-8?B?UngzOG1HNUhleFVZSEFFMlQ4VHJvdndCQzZ2NWJtd1NLRmI3OTgyTVo1MTdQ?=
 =?utf-8?B?MEd4WldxV2FYOVRHeUEwUk5IVnRoaHZlYkVDZW5zWWhLSlJySHRETU8vQjZT?=
 =?utf-8?B?dFY5K2hDZFVIeVRob0lZL2VGRjh1Nm1yeTVBcUIvb08xVzR2eSszRFhMWm5J?=
 =?utf-8?B?UWI2QVZNL2IwMExwSzUvR3FPeVFlUGlTdnh5YnVHUXc0Smk4bGNEV2taejVC?=
 =?utf-8?B?am5xMkNqMkZhT3BGUGIxTEJhZ1FoN2U0ZmhGekREZFhLRTJkelJEZFlaOXVV?=
 =?utf-8?B?bWZ1VkdOYktlbXdZNWQ1dVNLdXRTZzRXK1k1OXkzdDNEcFZlSDNmTEZLVkVL?=
 =?utf-8?B?d3Z0eldyazlpNEJ6RUU1SUZkek0vRE5mVGlnaUdpWGxzOXZpbFFBcGpUNnkz?=
 =?utf-8?B?b0F4OHZ1aEkveE94QW5Ldm14M3FFTmhUR1BoLzd2SnpqL3pia200dFhOYVhP?=
 =?utf-8?B?Z3cxaTgxVnhxZmVtMTNYNlNoQlNmQzFYMWFheXFCUFdvTURYOXc3blBNSHRr?=
 =?utf-8?B?WVpEdTVQbzVuNGw3Z3Q2WmYzb1VLajdZa2h3cHZ6Q1ZteFNrU2lzL2F3Rk4z?=
 =?utf-8?B?MERGMXllU2hHNU4yM1Z4VjJLdFJuTGNzR1JRS282eER5cXQ3WVpnVkFueFI2?=
 =?utf-8?B?RitIMmVJL3VHU0RoR0ViRlJEZlRQd0hRMjFlMGo2ZSt2d0E5emh4K3hHQUxn?=
 =?utf-8?B?NWlYdURsTnhHSVZ2QTZ5cWpSVG10WmNTbmNlRW5SQ3FUWXBISjByZ2dLa1gv?=
 =?utf-8?B?U1V1VGdYMFg3elNSV0hnaUhtQkJRSStqUFpHNkswU0pxUm9GYVd0NWg0eSt1?=
 =?utf-8?B?OVZzeUJxVFEzVEFjeExROFlYa0FDSW1LWlR3TkFNcE5tUjdaNUdldFRYQ0xn?=
 =?utf-8?B?NkFGYU1ML3QwY0JRSFFST3E4aGhsQjMyUjdBakxUWndtajRtc0p6T1RzT0xH?=
 =?utf-8?B?anVMU2dxMDNnWEQ4ejVEaDZLVERHV0JlN0xHRWtrMFZ2SjdQckYxRWV1TXFV?=
 =?utf-8?B?S1FnYjFhQUFxZHFsZCtZV2NFdUhFVWdtS1BxWlhaNGpOKzlUN3BUclArTWZi?=
 =?utf-8?Q?Zkbc4g4Dkj/udh93rtzm6FvVpFvuDuCi?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2lUdTljY0owU3N0TVRNUWJEV3M2NDlrUmxIRHJ6S3gyUlpjTVFyc1ZvaXJt?=
 =?utf-8?B?ZzJWRWEvUnpHOFV1aVk4aHBWakpEWDNDLzRjVGxMNWpGS3dqNDh3MW5ZRlNI?=
 =?utf-8?B?T1YrbStEMUdHaVk0RktURjBxMkxPZ3RBT0VpcFJqK1FNRzFqTnpVeUZVYXZw?=
 =?utf-8?B?YzZJMVRsb2c2bnhUMXVXTDV5cFFXVXdjV1ZmeTBwUEw2N2VjVmladUJwN2xK?=
 =?utf-8?B?SDlIL0JFR2krQXh0enYvODc1NjZOSisrUG5PdlpRbHRUUHdlLzRsMnBmeUM2?=
 =?utf-8?B?UnNFOG05czI4UldNK3NVdUJRSlVHTmJNbkdVV0NTd2M5Qll6Wjl2QjlkaUJ2?=
 =?utf-8?B?aUdaNk5JZ1h0Tno2K3MzeUVzZG1HcldSdW9nZGxUU1R5elBaOEVRZTlRK0ky?=
 =?utf-8?B?TzczRzAvMjFVdVUzcTNXT2l5eGVyQjVQYVh2V1NHWGx6RDlsVWNWc3R0YmNN?=
 =?utf-8?B?ODkxeVJhZ2c5NVBnWE9uUUs0OTlKWDVEWmpZWmN6dkgwSDJlSUFpc045QnRn?=
 =?utf-8?B?dXpTd2ZMazBhSE9CNHdjc1dCMnh5ZWNNMlhOQnRxYnI3YnVBUVEzT3c3dlZH?=
 =?utf-8?B?ODNJUUxweENwRFA2THMrSDRzSlFObjRjTW5hSHl6QzdJVmFkWkRWaUVpNjdV?=
 =?utf-8?B?RHYvb2R3b3MxRGVQVW1qdTcyUDNuaU0wZkYrVHN4RUxNS0tDekFzS1Y0a1dx?=
 =?utf-8?B?RVhMbkYreDIzWkh5Mk5mMm9PdHdPZzk0K25LRHcvb2d3ekVxMmNCQVpnMUVE?=
 =?utf-8?B?a0lqZ3lBd0x6SFJvTE0zNmVZalY2MUNVcm03U3JzRkhESS9XTkorUjNJdnVU?=
 =?utf-8?B?ZHh1K2p3S2RSSnMzMkxYT2h0TGlyT2xaMWlhL3BRS2dTMzBxUmZVQml0bEZO?=
 =?utf-8?B?ZDJQU0JQclhZaHNUVjU3bE5QN2xkNHoxYkcwUEdQMWtxZ25lMXRGcXlBYWtG?=
 =?utf-8?B?OW9oTFhCSzJsSndHRFFGeWpZSXRPQjJGSGJjSEVwNXZyK0FCb1IzWEFZbGsy?=
 =?utf-8?B?blg2MVJXQktBWjZ5UkhOb0s5ZXJORUxpbndldWhxYzdWVndFWWFrVGl2WDk1?=
 =?utf-8?B?WERva2hTS0MwSGhVUHpSTE9GSm1DSjNvdVJWdktVTjVNYWpneUpIRS9CNXkv?=
 =?utf-8?B?NXhVVUZMTzhrYW50emNrNWdoTVlicThocktHbGVoRkRhK1BzdkZaZXhONFZY?=
 =?utf-8?B?SklYek9wUkNHem9TQ1IwaXRvYVd6SGZzSURXQzlmZW5QWDR1UGRTYlovQU1L?=
 =?utf-8?B?UTFHem54ZitjS0ZvVU5iT2x2TDQ1RUdXRkdIeDBrQXJGZjlNN0tGT1BtTWc1?=
 =?utf-8?B?SmVzY3pFUXFTaTQzSVV3WUpZQy9PNnBaR3pWK3pSa2lCaEkrL3pLRHNLcTRC?=
 =?utf-8?B?NHhqVVc4ZHZCL3dsOHd3OGxkL2ZFaFY3YTBaMkIyMXBQV3VxRFZOZWJMWFEw?=
 =?utf-8?B?WmMraFhwaUEwZ3cybGxzNDNGSEFGZS8xRmszZUlSbUZYYlF6cUVqejdjZGNx?=
 =?utf-8?B?RnViRVZmMHd2Y255RXVlM3JjMWRkMnErWk1jVXNldEVZNG5ocVYrNG9Nb3Iw?=
 =?utf-8?B?emZhSDhqYlVkSDJoZFB6VW5vZXJISERUbzlGMFQzU2VWOGNGelk1QkQrTGpB?=
 =?utf-8?B?QVpzYSt2UTlkVHNkY2xjUWU5NUZzbmh6cTNyQ1ZQQnpaWENyTGhvaDd0V25j?=
 =?utf-8?B?UEZUUGt2M3hPQktMTmk0aGlPRzdwUjd4bzlJSytWbHhBN2ZkdlFDQzJSN01x?=
 =?utf-8?B?K1g3SEdhZFRaZXlwaENnVTFmVUNERzdyekQ2bENWRkdhOE4vV3dtMFZndFYy?=
 =?utf-8?B?aUR3MUVwL3VuTHJyT0o1eHprNDUxZjRBeThZSzdLTmNXNTY3RDBYbjd3alFR?=
 =?utf-8?B?ck9UUkNQYzg0aDB5WVhTblVzUlAzcDI0L1hlMkxsQlJUSkVtbWV1QWhMYm9z?=
 =?utf-8?B?RHhTVHpsakU5WkhUQkRHQ3RuUWRsL3B2WUVwSjhEbkpiTVpDenlOaTNmODlW?=
 =?utf-8?B?WU9CVTRsNG1HUWhSbFBxTFhJYU9FeGtHSnAwTE9zeDYyQ0tjSlZxQWh0V3ll?=
 =?utf-8?B?em9RSzBpS202V05QaHNkZkkzWm5sWVA2NzVIQjh3TG9wMU02NHZkMjN6Q2lO?=
 =?utf-8?B?ZlNHWlM3ZStMVFpNZFdWVmk1bDZMRVVUb21PbmRURHphV0t6VUZ5MDhIMTZQ?=
 =?utf-8?B?UHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7baeabf-074b-4ea2-1586-08de36da18e6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 04:19:08.3041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yU1vvCF3KJRfoZm+ktWpEmfDNsATwYoYNBMk4QMm8mlmziEEUuCN5Rq6d+kfwyRO1v9RHvr3txkRa9YqUomvpmHk27SI4g6HaT0VIH3A6+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6285
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> The core kernel registers a CPU hotplug callback to do VMX and TDX init
> and deinit while KVM registers a separate CPU offline callback to block
> offlining the last online CPU in a socket.
> 
> Splitting TDX-related CPU hotplug handling across two components is odd
> and adds unnecessary complexity.
> 
> Consolidate TDX-related CPU hotplug handling by integrating KVM's
> tdx_offline_cpu() to the one in the core kernel.
> 
> Also move nr_configured_hkid to the core kernel because tdx_offline_cpu()
> references it. Since HKID allocation and free are handled in the core
> kernel, it's more natural to track used HKIDs there.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

