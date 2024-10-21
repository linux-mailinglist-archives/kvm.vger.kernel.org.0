Return-Path: <kvm+bounces-29248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4FE09A5A5F
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FEC4281020
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B5D5199EAF;
	Mon, 21 Oct 2024 06:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F6D/WNiq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A55DDA8
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 06:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729492236; cv=fail; b=AJUkDxyqGcu6xmJ6u8bp9DTS69MW/8XTuazDVizV3bpyllvsgv3UqZY3N71WnuaNxjPTT5cqf0XqF/EjvJelVqVFhLP4JTeCMdOzH3kKK++9+kNlYmviDUF5TMcvfhzYqS0ANfbmB2hD1GbpFeEMZBK0pdHipm9dYrMFD2zKH9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729492236; c=relaxed/simple;
	bh=f4mkGZHS2PkSXySHpumgIc5jSrXsKY4l8+PI+EGF7q8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UnbneDYhNd8S1RBKT8zhGlrhtCj4lqFnOGrCOGxY5iWlgzI0bDI6HdeHfamvBPS3aJ1rMFFiYHJEIQKPLpzbLErGD1Gwz2M5mwaZLDqG6pKLjzC4Sr8wqwSQnZAeDrxP/LGSW74uDl5BmZfl7pE6W1lUsrOs0S4XEXFIdHoeCdg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F6D/WNiq; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729492234; x=1761028234;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f4mkGZHS2PkSXySHpumgIc5jSrXsKY4l8+PI+EGF7q8=;
  b=F6D/WNiqFutRpHLLa8YNIF5RYR5pNOZmoWRh29KA7izKUIX21Kk/blKw
   vNpTDNFx2pdmmvdImNpjOX0hLwtIQ76y0kZXM005Vl7798wsNe0/8SsoZ
   nvtKORFR3rwCBR5stoj4ciFzGE7ZTAIK2r34s9ADrOreOHeSN/pNvmOH6
   eUn8yYqEN/c0SSva79bqJx1aDOSrdC6FcxmaifOniAFdelUBPWkh5+vPA
   TKvmQDQ0TlSXC3dzDJrzydc9dbOavL4Gh8z9aZyt87e6ix60ZIP4HxneY
   r4uLAIqTCu0h5LghTx6MoUS154/gGuDn1rrx4eiIq5cAJk260E0p4cEQg
   A==;
X-CSE-ConnectionGUID: Nz8MfwS3QY26pbRMBw32GA==
X-CSE-MsgGUID: z74qgsyYSteQ1u/3UFvlew==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28910135"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28910135"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:30:34 -0700
X-CSE-ConnectionGUID: BcSlBTkZRQOtKonuFCHs+Q==
X-CSE-MsgGUID: hpPuWF3rRG6exUsvidyLJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="83424953"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2024 23:30:34 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 20 Oct 2024 23:30:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 20 Oct 2024 23:30:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 20 Oct 2024 23:30:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c1FQt7RCksqR2ZKo2+NVKi94xL9JmpYWCa7a3VCSwVRqCWwv6sutnolAFWsURuVi9cHAeg2KKBuNDn9Byqpjb4oqrC5wgzCrwigu/3fhD3FyzeLsK4jzQkiF9SPN3Mpqf+d9yfHk4QpMTMghD6WtYzdHerLGFCHMKkwbYd5pKxsy4ZMEPP3L2GPUNqRgR5z3JpZDTmuj3jENIhzc+DVPtiKFmBFeVMA/9GGB6Sx9kvRbNNonp8KX7FpAEx0L/rCLHv6REpIxVsVqHGNjfrq7ENKFQxk/jwl9/kLlka43E2uLM/B9QEgfAnnv8UprPpEaJL6eLH4GbOjfiH7txvte8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNw7hBvNQ92WJwyS6zspd50JOZKMrwtWRa38+zZMrSg=;
 b=u1u/uIPMGTyiYSPR+YkgwC0kR2J+19oISrzSgssKxJsEJlVyppkX1V4h7rxqp2vS0Xl0fPaAQmWrQpDomx8r1VMBClnRjox8WXuuJG715xGfyqJ2Fn4etfnLgXai47dfiV/pP7bkFsmlVpu1oelsEzR0u61XuQeShfklufItHbQN2FobTPTKxN04FyxMuG6XsHpQKlOBnX76joB9Ra+0BXZnQHfxb4ur3zokni1AUmhBQNwlZPuZZMX0nSzs17oFkC+UkWc1jFix0b6R0ulQr06zp6mupSV3tTTdfsqluAXZZvIor5k3FPMjn9+jx/jdg6vg1Ibb8pSEF6dpWrlQiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB7255.namprd11.prod.outlook.com (2603:10b6:8:10d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 06:30:25 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8069.024; Mon, 21 Oct 2024
 06:30:25 +0000
Message-ID: <521b4f3e-1979-46f5-bfad-87951db2b6ed@intel.com>
Date: Mon, 21 Oct 2024 14:35:00 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] iommu/vt-d: Let intel_pasid_tear_down_entry()
 return pasid entry
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>, <will@kernel.org>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-4-yi.l.liu@intel.com>
 <e5cd1de4-37f7-4d55-aa28-f37d49d46ac6@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <e5cd1de4-37f7-4d55-aa28-f37d49d46ac6@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR0401CA0019.apcprd04.prod.outlook.com
 (2603:1096:820:e::6) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM4PR11MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: ccb152db-64c4-4322-7185-08dcf199d8ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TXp1OGI3eTE4Z3FCaUlHYVJ0SEVMelJjZ3NnUzRlYmlOY1hRYW1LeU4rZUNB?=
 =?utf-8?B?QlQ3Y0JpdWVwcE5Rb09jR0d5cTNYeldXL3NCK3l2WWFIZHQvMVVRdEZjRnVW?=
 =?utf-8?B?a0tacEhtdmk3WFFzMHl5TkV0R1o1cy9WOVhUZVI5UStHSTV5dU8xZE90VmV1?=
 =?utf-8?B?MkI3VW1lN3JrcWROc0V3cXVIdHdHbTgzYzFvOENLN2xMZ1VnOGd4ZlpERDhP?=
 =?utf-8?B?M2VTc0M1cFRHVGl2TExCZlZ3T2dTd3B3K0dhMFhFZXNJamR2L1oyRWhmVGsx?=
 =?utf-8?B?cUp6UWtkaUtSa25RVzNMVUR2YUFNNW1LWGFnSGszcEYwVjFpNmZ3Z09EaElQ?=
 =?utf-8?B?SCtQR2xGb1lVYU9oTXBSc0UvTEY4Ry9CczluYTFMd3BhaXRyWHVyUEtQU3RP?=
 =?utf-8?B?QkxlQ2tUVk5pTlZ3Y2lLOC80ODJMTE1iTHBTY2VNQmdaYTVZSXJqQUJLTUV5?=
 =?utf-8?B?OWQyU1AyR3dvRndIM1N0Z0NscUlqaWhXckhkT3VWRzVPemZkNTVFZ1hobHZh?=
 =?utf-8?B?WC93ZUJZNkUyNXN6eXhEYjQrbnprTGhQb0ZlQnlNWkRnSHhlc1ZCT2pqT1lv?=
 =?utf-8?B?RENOdHNINHEyVDMwMytyTVRUVEhLTkZZekJhR2M4VDlTZGlmaHBYZVJYZlk4?=
 =?utf-8?B?YkNnbEtIcExKR0ZSVDBYenlCZjU2KzlId0tJMDRwaGJjeFBLUWxmUEdSMnhQ?=
 =?utf-8?B?Qm9NL1BtQlpOME1xQ0pFZnFXSnJCZndGeDFtc3lHY3RnOUlaZnV3eEpJblVM?=
 =?utf-8?B?MWFMeHVjM1Q1Q3gwWDlwYnpzbjhvQ3YyanRjK2RMUFRNMU5NbGgranBlWkpp?=
 =?utf-8?B?OVp0NDYxZWtZa0ZOZDhsRm5nNjNPNS9oYzREeEpiVE5TcHpNRDNYa3BteHVC?=
 =?utf-8?B?OVpqMVlUcGFKQi8xR0xCTHFMZ2dPVG1nSDJpZVAxQ0t3dGxqOTFDdERGcVZu?=
 =?utf-8?B?MlpmYW9BZm5mb1FUTitTZkhpYm1IUmFCbERTK3pteTMxaFRNdG15SXVPbVZC?=
 =?utf-8?B?Uzg3ZXNuSGhLVHBRZUhwaFhGdHBTLzFHNUZic1Q5TGZoYUxESUo5eU5vSGJs?=
 =?utf-8?B?MzE2Wkg4a3VPc3VUd1o0VmV6UkticG1SV1dFY1FoYVhzRy9tUHppOEo0Vmkw?=
 =?utf-8?B?TjVQTkIyT09zN01QZ0RNUFFaei9UMFYvWGZSMEFlK2xJNVN0ZHEwYUpTL3ZY?=
 =?utf-8?B?enRwTDFScnRteDFwaUd0MllwNzU1Zyt3eWxxK2ZiNFhUU09jMVkvMktxWkNm?=
 =?utf-8?B?cndXRUJENlJ2c3daNm5lMUZFL2NXVDhaUnpvNVNzdXNTelJEQ3RYTmJvMTVh?=
 =?utf-8?B?M0dWRyt5dWh3SXdGZ2RrSldwTTE0aDROcHM2Skw2a0psNDEvSWw4OWl4UVpG?=
 =?utf-8?B?MnQ5MjU2NEpyOWFJMnluc1E0ZDlVdk1oZ1p5V29yK1doQWVhbVpBeFNxS2gx?=
 =?utf-8?B?Q2VnSEFrSWlMM3kwV1QyNndCTmZrYitlZElZQ0xDMzhBOFFrVHdUSllrMmNQ?=
 =?utf-8?B?RXkvdy80LzBobEhWcGRGRUM5YUNxWXl1RlBHQ0FMZkc3cWQwTU1IOE44OW10?=
 =?utf-8?B?Y1E3azBDNlBDdm5XQ0hXakwvQUJkY0dpdVVrZ2Y0UkJ4ZW5icU1TcDkyYjJH?=
 =?utf-8?B?cExOdnNRdHFWUnlUTWVCaGlvWTFZQ3crck8xVzNoZGJsUndiKzNXaFFiZlNx?=
 =?utf-8?B?OFUvQXpjQmRmajhTUkorZXZOeEU4OUhYb3M0SThibU53TW53b2FSdFNYR3kx?=
 =?utf-8?Q?3FCDFVgkt44rXpka6M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2xwaXYxRFRRK0J6Vnp2dmJCTEJkVVhVaVQ1Y2JETHdxcDBsSU1QM0U2NFQw?=
 =?utf-8?B?RXNCbXNtTzAwUGw4a1BUK00xRkFjRzFObWVuQzR3ZDA3RGhWT2ZmU1lyWDFi?=
 =?utf-8?B?WUdCekNNL0dteUg1R2hsSzdVUkFzTnZHaGtYTWwvajB0T3RjOWpmZjEzYXFO?=
 =?utf-8?B?T0lsajBkYVpqVWN2d1I2OTcrS25wYXR5R3YrczQyck9WQlJDR1gvbGo5Uk9u?=
 =?utf-8?B?aDFEVk1xaitYOVBHbTN1eldlb0E0Zm5BdGc4OEduS2pjQ3BVeU5IVHYrMm1P?=
 =?utf-8?B?cWpuOFJPZmR5bW5rV1FlakpzTEJiNk5FdUNXNjV0a0FXVytsblNmN0xHNjdX?=
 =?utf-8?B?RTRjNEVMbUYvYjFnVEdRc2gwdGNRTjBUVGh1Ty8valBVSG9CdW1pT1dIUXQx?=
 =?utf-8?B?eTRURURWTkw4N3llVHpxVkR4TUN4MmRZUEprRVhnR3FoejlBNUY1a3RqakFi?=
 =?utf-8?B?SDRHNjZ3ZjRXeS9PU1IwWFlNN20yRElDL2xYemN3TkxNTFBYcXF5Z0prTWtZ?=
 =?utf-8?B?TUJuODFKVnFlYWo2bC80L2J5UXAydWI0eUZrUGNWTEdyeVhHMDVReVhteGV4?=
 =?utf-8?B?QkpBNWlFcUtyQnhneGRyYkdtWFVEOEV4OVhtSGJoR2FWNWlJWERyaTUrdFNq?=
 =?utf-8?B?Q0pOSHIrZ04zT0lhYjhUY1VnY0FhQUs5Q3MvaFExUjBscWlXa3ZnS1V5akU2?=
 =?utf-8?B?YVBwUXJ4Rlhlc2xCWWVZUXc4bTJBbGlSNVpDMmVqdi9LSzVVUXNFRFVGL2ZQ?=
 =?utf-8?B?K3dXaHdYVjhKSFgxRTJpaDlIVnpMSVQyUytFTGpLNGhvT3ZDdlZ6VGZqTERG?=
 =?utf-8?B?U1ZkWGhVTkZDNHRCbDA2OHdTY0drWUZYa01WWEZtWVZuK1dvWVpYMzcwWXZW?=
 =?utf-8?B?VHhUTTd6bm9nbnRJRTlzK1FZdVJFTG9uMlhLS3dFQ0o3RitqNnlRczBKN1pV?=
 =?utf-8?B?Q0tHa21LZlBJRGpzTm1OMlpyL0c0VWlSYnlTeVhxcEFWZ2grV2RkOVo0WEFs?=
 =?utf-8?B?cVVnYlZCNTlEa2Z4Y2JmbDlMaWpUOFg5dWJDL2pxVVJrYXpTWTFvcGduUVp2?=
 =?utf-8?B?Ty9qMEUrV3ZFdTdXVVV5L3hERVVjTGp0RFRCWkMxcGRZeEY2YisrK20wVnNu?=
 =?utf-8?B?OFp6eE1MR2czOFFNMTIvT3ZlZlNhNnhDeFRYZGpxV29kcUZPMHVlTjFKNmk1?=
 =?utf-8?B?S2pITG1UdzhmYUtDUzRoajdNdXlGWUIwSkxiWTZJQlJBZHZudEhpTTY3bTlW?=
 =?utf-8?B?UzQyUHFGc1k2a3d5TTF3Z2JJTElYR0N6RnE3NGQ2dTBZS3dBRjhzTlM0SHdX?=
 =?utf-8?B?UHJ0aFhjc1lWTThDOU4zaXpTcWVRZFNVUyt2ZkxzdHJxQ1hVZFU1ZmQ2dTJ5?=
 =?utf-8?B?K2VTcUlrTDhKNjFaRThmS25HWmVDdi9oVXluQ1dtNHVSVWdiNVQ5MDYrZFV6?=
 =?utf-8?B?VDM4S2lkbVVyWURyb0VFNnZHY3BURGFLTDg3amZPZ01HVDQyUXRCditHZnhH?=
 =?utf-8?B?WktUd2hQVzBkTDltUkhqc1FWcVUzTE9pVkRDcHlxRVRNeGNYNGxkaWdUa0Jl?=
 =?utf-8?B?ZkN1d1NoWmlCZDdRdllhSGZPQytHUFZBU09OTkI4U3NrcXY1NWdSdXMxMVZT?=
 =?utf-8?B?OVA2amFMbXRsNVhvVEpsWE1xWXpyRmdvQnNmUVljbzJLSW5ZNUx3b1puSlFM?=
 =?utf-8?B?VEJSYVpYUVNPVFNsNm5IWkdQd3BaNGw4Q2xJNFNCaUVQNWl5NlNMQmZPK0Fy?=
 =?utf-8?B?THAzZXo4c3RUdTZoa3BXbVp1ckU0QTBwOG9SRGQwUmZwRllLMjYxSjFtM2hY?=
 =?utf-8?B?NFlNdW56QWJRbXlxMDViK1ZsYklPNlVzcUxUQUkreXVsYW5BcCtadGZjLzBP?=
 =?utf-8?B?UlVZMnpkMVYrTUVyTzliK1dRa0VUNFZLQ2I1SXJHTUV0L0RoekwzcVRQeC9O?=
 =?utf-8?B?b2g2SkFweFlNbGwrbWZ2ZDhlMVRNNXJmVlEzM1dpOWRVb0E4VzZvSDBNTE1H?=
 =?utf-8?B?b2kzTVhjNDJUU004QTJ3OWZRcExTWi9UemRIaURVRGRMNGFvUDJXTkJxUVM4?=
 =?utf-8?B?WG44U2VtaDk1VkZEWGNydzRRb2FXdU8zeGVEdkd5UHdnUVZPcGhtcm0rZ01D?=
 =?utf-8?Q?NtvQxAOUpvTuHJi/rRmkx/mC3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb152db-64c4-4322-7185-08dcf199d8ed
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 06:30:25.4534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: joRa6K5ZHT8ElO/hGlR9UzA5k0NrqGWAXmNre2x7L7X4YN/lKRCWi9dpUCqxg2E1jZN2WRizj6CEOK8lHCLpag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7255
X-OriginatorOrg: intel.com

On 2024/10/21 14:13, Baolu Lu wrote:
> On 2024/10/18 13:53, Yi Liu wrote:
>> intel_pasid_tear_down_entry() finds the pasid entry and tears it down.
>> There are paths that need to get the pasid entry, tear it down and
>> re-configure it. Letting intel_pasid_tear_down_entry() return the pasid
>> entry can avoid duplicate codes to get the pasid entry. No functional
>> change is intended.
>>
>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/intel/pasid.c | 11 ++++++++---
>>   drivers/iommu/intel/pasid.h |  5 +++--
>>   2 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index 2898e7af2cf4..336f9425214c 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -239,9 +239,12 @@ devtlb_invalidation_with_pasid(struct intel_iommu 
>> *iommu,
>>   /*
>>    * Caller can request to drain PRQ in this helper if it hasn't done so,
>>    * e.g. in a path which doesn't follow remove_dev_pasid().
>> + * Return the pasid entry pointer if the entry is found or NULL if no
>> + * entry found.
>>    */
>> -void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct 
>> device *dev,
>> -                 u32 pasid, u32 flags)
>> +struct pasid_entry *
>> +intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
>> +                u32 pasid, u32 flags)
>>   {
>>       struct pasid_entry *pte;
>>       u16 did, pgtt;
>> @@ -250,7 +253,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu 
>> *iommu, struct device *dev,
>>       pte = intel_pasid_get_entry(dev, pasid);
>>       if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>>           spin_unlock(&iommu->lock);
>> -        return;
>> +        goto out;
> 
> The pasid table entry is protected by iommu->lock. It's  not reasonable
> to return the pte pointer which is beyond the lock protected range.

Per my understanding, the iommu->lock protects the content of the entry,
so the modifications to the entry need to hold it. While, it looks not
necessary to protect the pasid entry pointer itself. The pasid table should
exist during device probe and release. is it?

-- 
Regards,
Yi Liu

