Return-Path: <kvm+bounces-10557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E863986D6C1
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:20:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F4072857EB
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6773274BFB;
	Thu, 29 Feb 2024 22:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hW4vtDiv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E395F74BEC;
	Thu, 29 Feb 2024 22:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709245193; cv=fail; b=YTSCi4F73Fj/zdxswkDkZObTX/oNitYG94UcTxcO5YBxXZtWBtc4cLvfQVrbYlysJtkniTZSgV7ziaKMJcPN41/pC4L8H9qDl32Y9Zp/izY4q0cJNojiHv/zoFk/Y2mbJQHGByrglYT87XKL4lpYM21G2yKmC9zXT7j0Yu1Oo6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709245193; c=relaxed/simple;
	bh=bONOz1y83VyMVElRPxdwdlE1jsp3PZ4HV+5u18gaPCw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kuVtNs29dS7vOzD/gwFHIvzzIDAmzot/skiHhdwQTtyFaV5qupuQdI68bMqF6H+0gW+jFFW6y1z6nisRCREQ3gIPX2aeXtF2ZKdbXf4UlR9NxsVfJU5wHgaRkXFmgDZbYpe0rLPzv7xD35w1ob2QcNkb3y60TiCOuFReL8S/CMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hW4vtDiv; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709245192; x=1740781192;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bONOz1y83VyMVElRPxdwdlE1jsp3PZ4HV+5u18gaPCw=;
  b=hW4vtDivs/mKbDeQqOwvAJXj1B0vni2NF2wFzUwCy61x0qF6ZzenWfjh
   eArG68ew13/bMni2AI1ScSKydclqWpDJCArkOSDziM0nbV0+KJrVlCpUo
   phK9RpZwb2MGLsbJh0zBi2ZunM16cjRGi0a6gq8tTY/9b1CM1Wxjl1s9u
   Vwx2SdyvGUTFZeMpihO7DYmTgfXwEgYuzEnyxI1ejY3lV4Cgb/fIoQmsn
   wS8nG3ha6e/BROU6X/FJB35pTUaAp8XdwvQXVJJZE2NabMgODX88u8li6
   cZVTzFOe/dFVyXFXXb8PXcW72e30ag+tYOgXaq8GN6AjfvoFyjfrmb5W0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="3611523"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3611523"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 14:19:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="8116356"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Feb 2024 14:19:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 14:19:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 29 Feb 2024 14:19:48 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 14:19:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcC9PeW1BT850Yx4dmk8QWSI88b4jt8B1jtuKZ8hTQca4XBjo11IzQ/laK+Kr26WdnlibG9IulPWNmU/uS/Xfxeo1Lv7QfWnbaDNgxbyaX7opnht+iB+cA3r7+r8HNGADEHbYIPOGJ9Lb4VdZymTBhH2O9+Cgy62OCI6ybxdZbWyjobzwjz2N3sTKqjBMWHDrsScdsif1jArPuOK06OTIU9vs+bBA3Wqur4bGe7JCOrt56W+MRfAPtwJutsAiojn7oC4NeJuEHxKTNUEMtNnoR+NU/73nXjRWIcStDHzYj4dGB+HvEYBy2Sj6TfDppfx6O8YJo6M0WiWl21jfS4sew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRgLsF3nIvjtEIWbvmk6A9OG/TeKxaEBgSiJIrDkujw=;
 b=LC/zyG5/dthz2gJOBML/yvJ2RVqLe/FXBa94Qu2n8dJEaUkNxBZe+zYxw+bF1MV5PScVxy/J4E5O0PcnEHUUbhohSoGtumI7OPz/2wFn32tPZO+lWBnLgoCxdCqQTk+CzqBbAAPrRoLM319BcDVqHisA42WCjlaYwRoFf6stbno0Vh6oXcpglzN9s7vK1HCfcnd3pvxgiMItrNNIwWKcQMIkyj5iuO6MkZPCp0hKLvzXDNdlTYn/coYVwPfMWrPZBwxMHaHyd0RP6H3Kds2KWkVE4RmkN5Nk4QeCGgUNvE+rHv/7DvedKEsggt18Oeei+FhCZON5UVhzQeiaSd97dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7317.namprd11.prod.outlook.com (2603:10b6:208:427::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.19; Thu, 29 Feb
 2024 22:19:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.024; Thu, 29 Feb 2024
 22:19:46 +0000
Message-ID: <d0d5d6b7-218b-4769-9aa7-a393f174410e@intel.com>
Date: Fri, 1 Mar 2024 11:19:37 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/16] KVM: x86: Move synthetic PFERR_* sanity checks to
 SVM's #NPF handler
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, Chao
 Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, David
 Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-8-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWH0EPF00056D09.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:9) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a4624cc-a501-423d-c4c4-08dc39748926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1K3Y2XAsW/QbuaQl2/PiNmTbTadbcDFVSi7vi8E0uYN4E+/9eTiTYvhR1ll9YoPEL+oYdwxAv2gC17qP3NlFpDy6Jn3KgkswwNN9pRiWeASr/K3EZdO2SEdD9g0s26OHI7TDHTq5EdljyWTbiHNYpFkWXvj7Th3KwsLfdqCSHcIjrYoNvE6LMfXeVUUcoqU35Ms40Q+Ni2u6ldUvGKAaBMTbMfkuSB2eHIdgh3QUw5T6fKQchI9Il7au3sRrGfg2gRf/gTt4DklqO0j/zs6mX5GdbaGf1vzROdkmwKwKCZPpEJahMvRpE+FzLxqCNCvWj9GodvIALPAVdlwxtL/KEwm52lQtBjUx+jlwNbhOwYO7lsGSkHOQdYGSa174k7FFNZsCkjgDy9UGZfca2PNtYQecV8LWYv3EUQ7WF5Nun0T7MDh3k9NIK2wKUd4CqO2GKQCaE5fasQrJFVkEPZ3nvGzcskWZtQ459nsJg9514g45S4zjZhYNpWSkKvU41rNaycSMogbCD3Pv1Bn1TDkJVFhf19iLmz7Of2JsgrCbcbaSluUnnuedJFOqr9W9o9LWIapIHOr4LVNDnG1bp0G1n28uayjedJPcYdhmNwDyK+QYUYPY/DVmOekL21wa6HWRO5vWnxdp6IK5XLlyv0ruCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTdBL2dIVTY2RXRha3FTbUV5R3p2WXlaR0E4TGFJOTBLR2c5cjVMZE1DK2w3?=
 =?utf-8?B?ZXlBNEswNkNWZ2laSTVvRm9JVk9jT3FhZVppQzFRTWRLR2NqU3MzcXg1VU05?=
 =?utf-8?B?T3JINUJXSmpBUDlNT2JmSEYwUmZ3S281bWFxc0lkTktJVlA4RFpmWGs2ZjY5?=
 =?utf-8?B?M1lXL3lHdUJtaWJOZWRtWExhRXRvZmxaWmpLR2J2TStUOTFVY0tlNXkzL3lH?=
 =?utf-8?B?QUdVVWFwU3JScVM0cEJsSkYzZzNJbHp2bExUOE9VWnpyZ1h4YlY5RVYxK3dn?=
 =?utf-8?B?UWFpcTN1dnE3bVd1cXhQRG1ITk85VFVhbE1LRGwwc1FnRVBhMUowTCtReDJp?=
 =?utf-8?B?ZWZsR1FoN2UzaTQxVUtGS1FLRmJUSGhsbkg0NFozbHM5cGNuTTFqMFhORkxI?=
 =?utf-8?B?VHd0ZGVSeloxL0NjbHJnUG9EVTNNQUpkd2lsd3N2SGJZN1M2M29NWnpxaldn?=
 =?utf-8?B?TnFibGZiUDJKdEltcFNPQmNtVXQzc2NCa1VIajNlQjk3UFRkbmIvRUZhcXl3?=
 =?utf-8?B?U093bHJBdER5SVVOak1RdlVLa004N3dFenF5aEVTRCs3VXdhWUFTbnJxK0Fi?=
 =?utf-8?B?enpQT09xelZFMUprRXo2K2crUUwyWVl5WTRqZVAzUVh4c0NOdWMzU2x0bEFs?=
 =?utf-8?B?MVZITkFzSE94OEtuT0dVSXV5WnN1aWtUd3ZHRlNjeFZnN3p3UC9pR0daTHlD?=
 =?utf-8?B?MWQ4RXE5dTlXMHNkUGFWMDFTeXdvK0MvUTdsMHc1bGxhOE8wdEtpOGdwUzND?=
 =?utf-8?B?RjdSOE1mbEJISEtuUGVOaXFia1NqU0p1RUtxQml2a1l3TnowMStnSDU1MHk1?=
 =?utf-8?B?UGlDSVNkV3pVc2M4c0pPL01hZzRXTmtyTnZQdXprN1lxS0lyMDJ3eFJvRFps?=
 =?utf-8?B?MndJVVJuY29Pa1Y5UlBCSUlMd2lnNnNxTWRBTUxnaHppOXMxYzJuYVlTOVVn?=
 =?utf-8?B?Z0NVZHVLQTdpMTlZbFIvZ2tBRmpKb3FxNmp0dGtzVmYzNWI3cEI5QmhrMVFV?=
 =?utf-8?B?UElENExqSHpZeC8zN3JVRVpCWjkwdUxHNDQxa1RDR0wvN3B5YTJpNm5Gb1Ew?=
 =?utf-8?B?TjdDS1VxZmJnZlA0TkdHcHJ5K0VlNUhWc3o2cWVmaUx3d2pJaVM0THNoZVVs?=
 =?utf-8?B?ZDdqaDZ1UUYwTFpmb1Yzc1JyN09ZSm54cTJzcWVFMGZsQkU0b3UwbFZwZlNs?=
 =?utf-8?B?Rk5CRFdSby9QMFRkaWYyRGQvQUpGTlF0RlI5UWk3Tjg4UytiRVVhREMyV3Ju?=
 =?utf-8?B?T1R6MmxuczZkS1BNaWU3WVhPVEdTWUZzc0xnekZwR0xGRDRHUCtzQ1lEMGdL?=
 =?utf-8?B?anlFdUU4UkNVTEIySzlndEQxY0JwZ0JxNlZqVmJaem85QnNXd0t5UWllSnp4?=
 =?utf-8?B?M0pNei83WXE2OUY2YUx4Rk5rWTBiSC9pRi9DTVIraEVCcENqT2dCaFI0ZFpV?=
 =?utf-8?B?NGlWVU56RVlKRXp4V3J6QkRKTzFNNTQ1VmF2S1hlRGhsWXMzYUNGRjVRYngr?=
 =?utf-8?B?a0tONndwNFNOVGVUTE9rbDBYUTZzcDVHdEl0V3hlRTRscWhETlFiNVdGZldL?=
 =?utf-8?B?NkpGUUVKOTJHT2Z3SVVjTU5iczUzNHNkQVFsekcxSFNMMnF2L3BveXd1SWZ3?=
 =?utf-8?B?QXhJWU5KbExrRTdtUHVaeEVvMHUrK3VQTTZVZ2NSdTlyNDYrK1RCYnA3STlG?=
 =?utf-8?B?UDl1eGpGZHpSUkhYZXJLV01FZXkyVEVrakl5ekE3TjlpbmMySFlkRVZ5aDNN?=
 =?utf-8?B?ZStGWUUzSlpycDBHdGM1UWNDL3l1V3VlRGc1YUIwblRWazRxNm1mWkxXbXRP?=
 =?utf-8?B?OW1DZU90dzJUa1FWSnBQSWZrakRrSU9rUDVtWW43ZFFNUFFOZjBRUnNQY2pn?=
 =?utf-8?B?MjE5aVl6cGplajZuK2JscitJNjN5WVU1bU4wM3VCQVpNY2pqRXQ2ODJ5dzAw?=
 =?utf-8?B?eXcxM1pjV1JiM1hiMEdOQXJkVFEra29GT2VNRVdKUElWNmYrNEF0S2hQb3ZN?=
 =?utf-8?B?UlVlWnRUSjdTdWJXbWxxMTEwT3VJK2hiSUIyL2VtM0lEU2g5UjJ1ZFlEM0Ju?=
 =?utf-8?B?SHNOTmdRR1VtcXNuZGVoTGNZVUd2dE52cytva3h2Wmd3NWpCd1ZJY2R5blMz?=
 =?utf-8?Q?/r3El0R3uEA7v1ZfXSYOkJ0xh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4624cc-a501-423d-c4c4-08dc39748926
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 22:19:46.1329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 15RVhTM12XmAiMBP9e2e+afD8Ccol6peS5t00jP1MPAt9NQEvgYddFMT6cdD6yGGNjN2omI+ye9KrhTdvwDw4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7317
X-OriginatorOrg: intel.com



On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> Move the sanity check that hardware never sets bits that collide with KVM-
> define synthetic bits from kvm_mmu_page_fault() to npf_interception(),
> i.e. make the sanity check #NPF specific.  The legacy #PF path already
> WARNs if _any_ of bits 63:32 are set, and the error code that comes from
> VMX's EPT Violatation and Misconfig is 100% synthesized (KVM morphs VMX's
> EXIT_QUALIFICATION into error code flags).
> 
> Add a compile-time assert in the legacy #PF handler to make sure that KVM-
> define flags are covered by its existing sanity check on the upper bits.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 12 +++---------
>   arch/x86/kvm/svm/svm.c |  9 +++++++++
>   2 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5d892bd59c97..bd342ebd0809 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4561,6 +4561,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>   	if (WARN_ON_ONCE(error_code >> 32))
>   		error_code = lower_32_bits(error_code);
>   
> +	/* Ensure the above sanity check also covers KVM-defined flags. */
> +	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
> +

Could you explain why adding this BUILD_BUG_ON() here, but not ...

>   	vcpu->arch.l1tf_flush_l1d = true;
>   	if (!flags) {
>   		trace_kvm_page_fault(vcpu, fault_address, error_code);
> @@ -5845,15 +5848,6 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>   	int r, emulation_type = EMULTYPE_PF;
>   	bool direct = vcpu->arch.mmu->root_role.direct;
>   
> -	/*
> -	 * WARN if hardware generates a fault with an error code that collides
> -	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
> -	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
> -	 * flag that KVM doesn't know about.
> -	 */
> -	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
> -		error_code &= ~PFERR_SYNTHETIC_MASK;
> -
>   	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>   		return RET_PF_RETRY;
>   
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e90b429c84f1..199c4dd8d214 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2055,6 +2055,15 @@ static int npf_interception(struct kvm_vcpu *vcpu)
>   	u64 fault_address = svm->vmcb->control.exit_info_2;
>   	u64 error_code = svm->vmcb->control.exit_info_1;
>   
> +	/*
> +	 * WARN if hardware generates a fault with an error code that collides
> +	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
> +	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
> +	 * flag that KVM doesn't know about.
> +	 */
> +	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
> +		error_code &= ~PFERR_SYNTHETIC_MASK;
> +
>   	trace_kvm_page_fault(vcpu, fault_address, error_code);
>   	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
>   			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?

...  in npf_interception() or some common place like in 
kvm_mmu_page_fault()?

Otherwise,

Reviewed-by: Kai Huang <kai.huang@intel.com>

