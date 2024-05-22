Return-Path: <kvm+bounces-17989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51A118CC918
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 00:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA90AB210C0
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 22:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD6814901E;
	Wed, 22 May 2024 22:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xhpzo/SK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4395A146A8F;
	Wed, 22 May 2024 22:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417215; cv=fail; b=hN4ibjbDzlddrKbSxiXn5lWQvQ5sg9SpJn3rZAeWFe+BD5TWq5vjXrX4aFyZe6qLLwQv1kSk4tvJdjuJUCtnM1j4uE5KEZekNGa0oCbuLvE+22vRlBthISrMd3415JaXD8ZpbY+W+Sn3/w2oKvru8542u9i8O6GVuNRmif+Sbb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417215; c=relaxed/simple;
	bh=Ea7FlnAw5qui8pYLGIpgA+d2R4sKxoOYj0wt7o5pRGA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I2fZjMNWr+sOJ7G9ScJcfwh56XYD+OfIKjNsZLR1ViZbIbKrYSF3ADotS+7SLRcInz5P/khH396QAicqY9khTWRa8y1cNhbiSSGBHJoI8e4z10k3JcmVuxGwKBU7Em4Yjj1p0uGdRflKBMN3jjXK2lcsowwnoA1it1fTcl2yfLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xhpzo/SK; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716417213; x=1747953213;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ea7FlnAw5qui8pYLGIpgA+d2R4sKxoOYj0wt7o5pRGA=;
  b=Xhpzo/SKvp/M0ekVZQ/sOjLOWCc20RcugtGFvoTKyZ82DxkcNkN1UZA0
   PewjGSIWAS2INPTfeIYU15PI1aaG/o0Jk63MROCvyUu0qmY3MXwnVDIiv
   xhjNpr/jlsYT8IoqzCu8eQ3louUBdkdiL3DvnYHpQ63LiOnNBeFxPdFMB
   y0c3Oci2cWDIO5vAWlZE27iPqbkQbDMJ/Y2pAjasZxltxbsscmCn1IkwD
   0bT5htuggTpXmFr8g3dT3KcwprKMmbUDDtW6xSr54RiNn3t36kw/Bedw2
   cHyiqz+26mDPZ8ncheyxP9ByFlT/kw4vyjjUPRRrP5H2g5/c9MQg9Vbnz
   A==;
X-CSE-ConnectionGUID: kOaXFrsuSlCNOofVkD66yw==
X-CSE-MsgGUID: 30rgjnhSTbuNWePS6S9rlQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="24113084"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="24113084"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 15:33:28 -0700
X-CSE-ConnectionGUID: jhrxoex7TCKWYbKaCFA4WA==
X-CSE-MsgGUID: 2vr47Ce0SUGs7oxaow2ddw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="38417437"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 15:33:29 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 15:33:27 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 15:33:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 15:33:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j05ViwcB79/m54pQematWIhrN4XB0uFt9XRbfaX3w/6ZPZDG1bVCMc33fXldvJ+6+WQ09JA48XbOS39+AqOXxiWnm615xF4oaYGvtCYB9F+GRyLhDlm6gW0MQYe5CU3dEaOaVxMoSJC2+hFLVdqlzhWUJGHsHkoLFevuKdAQ3t4qQ41hyW+53kiHEWZCOS1XwURIK3w2rgSwec+qFcTJx368ds6wDWXC2oIpS+lX4hC/0EwTuLfO3IKAjXykYycS/wGEPHJLDKTvG8LqFDugCk2jZOiaAq5j3haciGtXzC0EIrly5V9eyth5ad4XCgul3KbL5c1Bb6Gh5t2vkgkWdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7wImcC7TVdinSB6a1EVGpJcnltZuhYUDsaCgDKCdkY=;
 b=jWDz4ZHxOS1+0odJ/4YRNS6vhxgiusBmybRp93HTtnzFG9OwzF3SpiDpZXHEYY4g01sr2HAMFw0p+bUD+uKQki/X7JV23jVoyAyxUixv5Ro+80a40ukwW/FA9nLfghQ8VfIOQIbLgofIuFcxsv12njT5PYXS9Mvg1qvYUwlei0Rpo3fsP/ahhxytNlPF6RVPmBm9zLZLKzrplMw7/gfAU929957F6+knlJhFE9V3QWETAYOGKkCVqSvRXEEvDNM13/1ahBYHTifJqfsL8jZjSLfdtIRMAgfn50B+sp0tDwcULjIf+Gq66gOjsJNy7M6tTUx0iJ1cOCagOLf4NaRoaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB8015.namprd11.prod.outlook.com (2603:10b6:510:23b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 22:33:25 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 22:33:25 +0000
Message-ID: <2d873eb4-67d2-446d-8208-a43a4a8aba14@intel.com>
Date: Thu, 23 May 2024 10:33:17 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] KVM: Add arch hooks for enabling/disabling
 virtualization
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-5-seanjc@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240522022827.1690416-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::23) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH8PR11MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: a53652ab-fde9-4eaa-c943-08dc7aaf31e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cFp4K0hvN2NINnZoNE9YM3JQSk5XT0JHMkc2NytINzhEblhDNi9DQ3pGZ3lw?=
 =?utf-8?B?WWFTQXp5ZncvUk5Bb1VOcDc2MDQxZGRoZlc0Qy92ejVQVmpDajl2SFBPaFlX?=
 =?utf-8?B?aE13TFV4TnM0eG1LUkpNRnJrMTY0MkV3dDh0d2VDa2MzUkdRNks5V0ZsR3FG?=
 =?utf-8?B?eTNLdE0wSnVTM241UGY1VjQyMXJlSUpYUjZSQWhhWDN5aDR3UlN4dWRLbVhY?=
 =?utf-8?B?OFVLYUtIQzZwR1VyNTEyZkpRQzFsUXBFN3Nac1lOOXJIbFZyRUMrNjZ4eENU?=
 =?utf-8?B?Rm8yaXdTaG1lNU5Wa0pGL2hiTnpuU0EwQXZVYU5UeWZxVEduV3ZOeWpLM0xO?=
 =?utf-8?B?dHpLUTc5RnJDa3JqY2pMMHBMVFVPU09USnp4SThibzREOHhlY3lzdFVvMGlx?=
 =?utf-8?B?SEZSdjBBekZpbC8zM3RLa0dCWWhJdnFEK0NuOVE4YVlTY1RIWXovd3VnSWZa?=
 =?utf-8?B?VHY3emxtZ3ZRWEpJaGtDRFBVNjUvMHIrYmgzY2I5bnFDUWRxSUJaUUlhSWlu?=
 =?utf-8?B?OXNFZXFURUh3V3VNTUdGYndJVWw2YlI2Rzd3WElWcDRUMnYwazNPZlFHRm1v?=
 =?utf-8?B?UWI1UXY5MUZXSW8yR0xaRmsvNEJyZEpJbGFaazVHeWtLeXY0YmlzRDhMc0Ex?=
 =?utf-8?B?RUpvZXIzVVZmVlNab0tZWHpISEU4ajlZaG5rd1FpT3RQUVRpbE51RW9BZHF0?=
 =?utf-8?B?bVh3NytPZWp3M3hhaVIrUHNsMTYxRzU4TEc4eVhVeDV6N3ZiNVRPU290ZkNT?=
 =?utf-8?B?a3VsMDRYN1FxcVdnRmR1ZThiWlIwd0VuTlU5bTJWNEcvdExBYWE3NDJKelNX?=
 =?utf-8?B?MjZ6VXJZVTk4eGxkNGFwUzEzdXNxUWRTa3ByZStBbjRXZ25CN2ZxeklqNTlG?=
 =?utf-8?B?cUVTYW1WYjdTM20zNUR2aHQ0amJEbjloc0VOSjZOQVpSNXZ6OEVMSXlJd044?=
 =?utf-8?B?YnUrclU4TG5aSzhTcytYb3BMV0J6eUE5OWdzZFhrbDNWdjRvbDZGVDdaNnc4?=
 =?utf-8?B?c2l2VmszVWRKR0dOenNZL3c1UXVRZXplSUxSeUo5eWRHd2hrallYWkpSblRy?=
 =?utf-8?B?UFNYZU1ZUFRLS0NJY2J2TnA3Y1hvNjdlUGFQZDZsZmF6Y29RTHRrMnlPb29X?=
 =?utf-8?B?L1l5K0gvMDZUbkwySVpQczdnbkZQVVdpTXF3WE9RTWVKS0hzYnpZOG52cWJG?=
 =?utf-8?B?dlFPaEpyQkk1dVJob015L25kNTZIMVBrR1RTaUNmWE1CbmI1TkRld1dKMEht?=
 =?utf-8?B?RkdrSE9YN1ZJRE05MDRxMnoxZVc0L3h4MDVjYU9DZXZtNWRoVHo5dUJhckdX?=
 =?utf-8?B?alZHSTIya1U0ZDQ4VXRSb0VabENCV1o3ZnJaNGtjUWYwT0oyWjE0M1F2RS9i?=
 =?utf-8?B?OU1FeDg0VzRKbGpWUWVpLzExVTNUc0pBRmhtNHBpVGJidWZvQTJVdC93cGRF?=
 =?utf-8?B?eVQ2V3dKenprd09WWStUc211UnpTcGJxQjZMaGRjSWNFUkxneWhvRWVGMUxG?=
 =?utf-8?B?RGlLR1NROFlLOGc3dGJOOEw3bkRsTjB2S05ZQURHZnl3R0ZyVmUyY0Jsa2tx?=
 =?utf-8?B?NkgxNGh2d01hZjNiaWcxczd2dXB5bGpoRFptYW85K3VDamt2d2NrblpIL1Q1?=
 =?utf-8?B?RmpSZVpEZ3k0OEhQWXNBdTNCVUpVL2xaZW5ibXJmaDk5Q01LYnVQdEk5WTdL?=
 =?utf-8?B?WmswWkIxZG5CRFhYTTJEWWQ4Uk54elIyclJ6NmVQd0lGcktPNVRUM3ZBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHNMUVFBRUtOL3dTYjZ5TUtSNDlNcUNhNWpIK0R0dHl1SlRlWlQwTlV2T1NR?=
 =?utf-8?B?bjhKemtXZzFnU0RZUkVJVVdtR0FLeXA5dFBjTHp6QmZHeXdYVHpvRGMyUEVL?=
 =?utf-8?B?NXR2cmJiZE9OVGYzOG1Nc3pCSlNNYjZzcVFFZDlKclNiTGw5OVVuUHdBbjdI?=
 =?utf-8?B?cnk2VEtIamdhcjQwcGI5UnRIZWJMbmNXcnB0Q2lKb2xpTWkyOUlHYnFrSnJz?=
 =?utf-8?B?YXFBbkxqakZOMHpMMHk2WXl2Z0oyY2ZYWFN2N1pGRjFtd1J5VFVvTDZqUXZT?=
 =?utf-8?B?VWM4T0RjNW5oV3hzN2dWbHdSUTNPV0VjOW1ITFVuSFkrQmc0OVdVbEN1b1Vu?=
 =?utf-8?B?T1k1WjFUdFdFaFgyZFNHUEhwcjlOWVFnVmwxbzQ4dzJodWRMbEZtYnhKb1FS?=
 =?utf-8?B?TjFYTzFvbkhmTElzeitnay9mdWcxUzZ6Syt1K0VkVm1TNGNqZ2JOaVVMSnFU?=
 =?utf-8?B?TGpHbmJ1L3FrVmtTWXk2ejdjR3E2aWJlcXVYc1dPSzFNVXhZRzBrTUFxcGVC?=
 =?utf-8?B?d1d1eUF0K1MyM0pCY0xvZGJ3MnQrNlVmb210N2luYmY1cEFLTlVyb2FUSU1v?=
 =?utf-8?B?OC9JREZwN1ZVRlMyaWRFQzd6MUs3YzhaamRyb2pGUXVCd0tVWWIvcnR0ZzIy?=
 =?utf-8?B?d0xSTEUwR1NEMXFqRzZCL0QrTlNmUGtyNFpIa09ZRDRmWW9aVEduQU5uMHhl?=
 =?utf-8?B?cGpuRVdyck12SUk0T1o5c05SazFxME1CTEE2WU5XUHByUk5pVUZVczNDSHYw?=
 =?utf-8?B?WFUwN0owNDUrRnBuSmZ1S3BudzV1Q3E3R2VucmthVVFhY1ZZL2pURENnOEUr?=
 =?utf-8?B?VW1zbVBwSDViNUtrSWRCZHB0WE5NQmpLZUFlWG4zdW9Pb002RC9seGJ1R1VK?=
 =?utf-8?B?NVczUUlnREt1NXZNTURqZDFpekk5dFlhVS9pTE9vczFqZElqZzlPNC9VYzJL?=
 =?utf-8?B?VzNvaHJBWHN0TGRaWHdxakEvNzVOeXpEa0tzZldOTW1JL0lIbnNndktYV0JT?=
 =?utf-8?B?TURVUkwzdWI4bTBKUkg0L2srWEJ3ZzIyZk1IUWxhUnBDL0t6d1E0OE9XQ2xu?=
 =?utf-8?B?S2U5V1pXSGJoQlc0d0NFV0U0cEVScXVDeEpEQ05qKzRjZXZUR3lIUGZQMUVQ?=
 =?utf-8?B?MTBuWUpwOE1ud3FPaWoyeENIQTVhYWx2OGw4d05ZMER6bklXVEd0RWlPemVp?=
 =?utf-8?B?OFBiKzBRekZRbTVrZ1BoMXRhTThxdHgxQWFFclAwNzZtYUVRS0drenVhWW9U?=
 =?utf-8?B?RjFsajVpNTMxOWsrbEdhSk1sbUFnUEJua3AwM2hyUzUveCs3QlhtaUdqbjRG?=
 =?utf-8?B?YTVjQTJsRzdDbWpxQkxHM0x0MG15U3FHWWdhMXpJQStEUWJLYlY5c0JHWWhs?=
 =?utf-8?B?dWhrdUZ0K0k1NUtYbnBETDZzaDF3UWxNZWNkYUVmRy9ReFB6TmlOMFN4aEhH?=
 =?utf-8?B?ak8zVXFJWnNYKzhLYXZpZTRjSXRaZlhLWVVkNHlMcmFxWkw5djNWd2tvWDd4?=
 =?utf-8?B?bFZ4TkVCSUc2SjJVbENselFoRzB0by9CQVhLRndVN1RXOXJmTUcxR0JWekp3?=
 =?utf-8?B?MThkWlpCSmd4SWRET0JTOFZKUW52TXA5Zko0cWpJY3JYZXp1Zkt5VGVBbmt4?=
 =?utf-8?B?LzVYeXliY3RWQ1oxWTlBQjN0aTdWVmhoMkxBNmdFaXRrUHFzSFNrZ2pWdWhW?=
 =?utf-8?B?WWQxMUp3aFlYYmM4bHhlS2F4UStzbERsbzY2R1p5dFNtNmswT1I5TGQ4VXNC?=
 =?utf-8?B?MEtzYUEvTDJENFVzWk1JMmlORlgyOGZvWGtCaVQzeUs5Y0JxQVdWaGkwZzJu?=
 =?utf-8?B?dDM3ZVJCeklWRGFGMnJOdVVyVHZSRVUwV0dNZ05sZUhaSjlXUG1nUjlZV3ZN?=
 =?utf-8?B?dDdEanRKbVNLWm9na29SWnlPSFJNQ2FsU3ZNbk1Wei9WalBLcUFjQzlySHNa?=
 =?utf-8?B?TVBLVHVSYURBRTJNeWlPZm9wdHdPRlBwSkZjOG5OME1oRUVtZlNSaytNdUs5?=
 =?utf-8?B?MEdScFZjRG5rdTlxWFl1c0pZUmJDSW1lci96Sk5vemE0WW52UDdNYVpOL0x4?=
 =?utf-8?B?eXd3ejFRNGdlT2JsWk9rQnV2WjVTTVhXaHAwSkVnOUtCYklCb2JWdmMxdmd0?=
 =?utf-8?Q?KNVtzute22bsiImGNHPHGXN/w?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a53652ab-fde9-4eaa-c943-08dc7aaf31e7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 22:33:25.6553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7QjKpTM3xIsWOPmi7tTIHWTZ+nyxvFXMq8RjVMW5NjdXMMkqTQb9BWaJpMeNbkmqycb6desRFgwiYn7xq1esw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8015
X-OriginatorOrg: intel.com



On 22/05/2024 2:28 pm, Sean Christopherson wrote:
> Add arch hooks that are invoked when KVM enables/disable virtualization.
> x86 will use the hooks to register an "emergency disable" callback, which
> is essentially an x86-specific shutdown notifier that is used when the
> kernel is doing an emergency reboot/shutdown/kexec.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Kai Huang <kai.huang@intel.com>

[...]

> +
>   static int __kvm_enable_virtualization(void)
>   {
>   	if (__this_cpu_read(hardware_enabled))
> @@ -5604,6 +5614,8 @@ static int kvm_enable_virtualization(void)
>   	if (kvm_usage_count++)
>   		return 0;
>   
> +	kvm_arch_enable_virtualization();
> +
>   	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
>   			      kvm_online_cpu, kvm_offline_cpu);


Nit:  is kvm_arch_pre_enable_virtualization() a better name?



