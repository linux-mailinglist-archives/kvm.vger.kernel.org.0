Return-Path: <kvm+bounces-48978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C477AD4FC9
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 11:31:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5D5C3A5D4F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 09:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A172F18DB34;
	Wed, 11 Jun 2025 09:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z0tesly6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1421A9B28;
	Wed, 11 Jun 2025 09:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749634216; cv=fail; b=Mei7qIM0K1iBVwW+yJsHPo5RGzertB3tetBNQahMAoXMJwtHHUpbSLQJCF4I6glNF9NCXWRaLzQbb4UT0fv0QJoPuShA0ZMwqphcARhmhGM5pkGF1iaQKbZBFwps8EOjqyBBjW3lrh661VJfgNw16IfgaSovoOCn09z7K0CFk0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749634216; c=relaxed/simple;
	bh=QanWZLNe1GwOtK+HvYylfwBtb8cmiJeZjQ6lOnUIK/Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GwsaMG6y1EvEwamWt/Le9WAs6Ls7UVMcOjqJPDiXSAi1iz+FL7aq7+QA0KZm8A+F5WZPhuAvzg1yHEq4F5H//rOLKadj+f+DerUbfNNuuWkHmXsKrhIAyfZqGh7yg6rLhnOTCKXQiwAkaciP9AmBE47WjawBeuD5DMRc2ckC54w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z0tesly6; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749634215; x=1781170215;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QanWZLNe1GwOtK+HvYylfwBtb8cmiJeZjQ6lOnUIK/Q=;
  b=Z0tesly6MF9D69YANvKKNl6wGnfpcltLBzWY40vYuT0CVqR9+1Hke5zX
   ewm4y215NkadFz0kPgD+rL5UOpuw04wQfEPykfpJVH6fY/H+TTuDgUZJX
   w7Ad57EeNt444OHmyeWVbFXyjcXDmWLsY2KwrqN9BQLX9H7+oklw50geK
   r5UsOo53xhiaH9OkNtlZ6DMVvmDwtCWg3a0R9UypWmNVa5Ssl1lVEPle4
   FXdU8rUV4BHPC5jsBgLyXmnlTIZm6bp/zARi8FzOnaKgmOMtUo/VZlaFO
   FhS00MQi4OZVvg8HhJKkx4vSARMsV+VMQ57UfuRQxIdfCNsXFrE3Puxce
   g==;
X-CSE-ConnectionGUID: nr/fmGgMR22jSZH81fewkA==
X-CSE-MsgGUID: jTREON8yQpuktC5Rj02B5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="69332081"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="69332081"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 02:30:14 -0700
X-CSE-ConnectionGUID: +3zsOZr9S/qoZ4QxH48QrA==
X-CSE-MsgGUID: WJyC+mSqRZeubR8f8vG6PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="148053381"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 02:30:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 02:30:12 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 02:30:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.71)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 02:30:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEZIRipFwPfxE9H5mqY6iE2jtncfOgZCbdlw9Xb+IT5By+LvwJnG9PWw3MywwJztStJ1LfD5nHrRVDUZx8om9kBUow5DvIF8AnLvjrO1/2oUmedJhocx2/VcbNI+/5le6ZmBy7mm7NOYxQ/n9y2biYEysrhVjqsA/ORzVVv8rg8GpKPqUJ0KE4awZDHDTFfmqVBxbhL7SkYlHC58/hzJYWs/F62XGBPii0JisX4aBPLHqkWZ0k30ytGT0S8qwBDShOryDBAszNk8hYqDkUOWjz6nyoY5UKFm23+LeyPTvSe9YqRN+85IKKUQbfiV4GD49mTwXEELVg8MATTK9UQNgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1aSfzCrXpD7cMo2uL3Q/XTKje9hBbPAWyD89JeUuv0=;
 b=NHeFNfoO6/3k9pn/lpD9gdBnYNCOq+GNOUEPHaVEtVWto4sOF1zQXq6vCzNCruIXXLlx0XCefh3OUF4HuNAd2+c5WIdtTfX4PJq6SDvHSAm2OHais1Mr+2R7uSJh2kcy/YRiBiR59+l1RlVZfvuUa0QkeUIkJzrPO9cPSHrOYO0BseCONZSgfpFtKCO8zC3P+RjSnFGVsW7QTQ15nqI6ucMCyAPnlM3k1v2OHkfb8HNHqYVAleA2juRkqoUUkPM5REooqWBBCW6P4hY427HPS0/VijVPrXozNyqObNHcrxcgPalzCkCNbyzILP6l3EbVR71X8zi3rWkxZKk00Y3Mmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3214.namprd11.prod.outlook.com (2603:10b6:805:c7::12)
 by DS7PR11MB7738.namprd11.prod.outlook.com (2603:10b6:8:e0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.30; Wed, 11 Jun 2025 09:30:03 +0000
Received: from SN6PR11MB3214.namprd11.prod.outlook.com
 ([fe80::9507:5635:9ddf:a558]) by SN6PR11MB3214.namprd11.prod.outlook.com
 ([fe80::9507:5635:9ddf:a558%3]) with mapi id 15.20.8813.018; Wed, 11 Jun 2025
 09:30:01 +0000
Message-ID: <bde92ac8-6c6d-476f-9c9d-d057cc1a051c@intel.com>
Date: Wed, 11 Jun 2025 12:29:56 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/8] KVM: TDX: Use kvm_arch_vcpu.host_debugctl to
 restore the host's DEBUGCTL
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Maxim Levitsky
	<mlevitsk@redhat.com>
References: <20250610232010.162191-1-seanjc@google.com>
 <20250610232010.162191-2-seanjc@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20250610232010.162191-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0278.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::13) To SN6PR11MB3214.namprd11.prod.outlook.com
 (2603:10b6:805:c7::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3214:EE_|DS7PR11MB7738:EE_
X-MS-Office365-Filtering-Correlation-Id: 5acec388-807f-46ca-c1be-08dda8ca8a32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cmlEanlrQkhvbFVrRzZWS2daSTVsZ3ZkZlhFZ1haaFFQamFFdUtuK0FNSmZW?=
 =?utf-8?B?TnJhYmVzWE5TSWtYZmdjWFB4WmRzS0hJU3hGZ0lmZmZCUVd5ZXp3NldTaUVX?=
 =?utf-8?B?N2h5Tm1YWGg1WGJvNnhDR3NaWHlCRXZVeDJ6SWxpcStmcVE1bVE0QmdleUo2?=
 =?utf-8?B?U2JSbU9MTVNuak0wMDdSNktwdzBmWUtTZHJ6TVlPN1V0NEVIbERZKzR5Wnhl?=
 =?utf-8?B?TXIyT2oxUzRFTkhmWkxPQUwzQVhuZWtYTEkvdzlMaHZybllucWRONFlUL204?=
 =?utf-8?B?czJwRTZBNm5iYlI2c1kzT2V3UkZ0QVkyVTB5N2cwcCswUlJZOTdsa05qSGpF?=
 =?utf-8?B?dFdNeFBLN0dyTm5heGczV0VwcFJjdTR5Qkxud2xBRkw4eGJCRGM0aDExMzdl?=
 =?utf-8?B?ZFRZSDJZQW0zQlFmdkM1bitKKzBJSmQ0bHpZOVdTQUd1REVOV1UxUXRpdHU1?=
 =?utf-8?B?V1A5aTUwZVk3b2ltMDgyYWc5RWNNQ21mTnYrVGM1c2VYOVN4YmMyWjFoOFVZ?=
 =?utf-8?B?WUs5R1FoTjNSVDRuUEVZWWN5cXNTWkNoNUx1NlFIMlpPYlhlN2Mzb2I1Uzd1?=
 =?utf-8?B?M0Ztb0VvWVgyNFdOYnEvbTNrT2wrMENDVUZ1bVNGcFBtRkRjeTd0bEx4L0tn?=
 =?utf-8?B?YUsrM3RibWE3Tk1tQTBxc3JCanpGS3VtMjB1UUVEMmNuaXJlQVZkbUM2K3Jj?=
 =?utf-8?B?ZnVMd2UydkdmUGlwMG9hcXdFQ0pTWFpJSitTSU1yOU1BR0laUTkxem03eVI4?=
 =?utf-8?B?UkxxelVYYWN2azYvYzJtOHNPT0djam5NWFRrWFVtSnRWOXhLVmJzOE9ySWJK?=
 =?utf-8?B?K0VwWHF3YWYwZmdBekt6UEVzbGk2eFNPNS9laTJvcFRrOHYrNVkzWjRieSsx?=
 =?utf-8?B?SEdmQmp5aTFwaW5oMy9OWWE1SElHb3Z2SDR6Y0JSUDBLY3lYbFIzRC9PMXFS?=
 =?utf-8?B?TVZpalh4Q0x5dTJ5NjlPOCsxNEM5K3U1dVFWRjczcE92eUFuWjVRQSttZmVI?=
 =?utf-8?B?WkxSRThkdTZYck1IZktrbWJjRHhST1RxUDA5N1BWMGs4OEtUTGVaZE5jRHVC?=
 =?utf-8?B?UmkxWmZ5STdwZkRZTkNOVXRqdElaWlBHNnRkVkxITzllRzllRm9aOHJMeDdH?=
 =?utf-8?B?cjhSUGF6Nm5WaUZETDZOUkhNVEM0SStXS0x1RkErcGpYSHVMaFlza2xiODU0?=
 =?utf-8?B?VDlhTmlCODIxMS92bG1IS2lITzRSb3BPbEZnYmMyWE1aeWNmbTNpNVk3VkV4?=
 =?utf-8?B?QXJubWlFekEzeUpQVTM3U2lVcWZHNHJoR3FITFlsRkxJWFlERS9xMS9ad1J3?=
 =?utf-8?B?MW5lMDJlcStNZ3F0T0k3ZXliYUFkK0UzUUpPSlBtYkhkZFJtaFErKzd5OTBF?=
 =?utf-8?B?cDVHYnd1NjlmekF5MlhLNEpFOEQwS1BwWDg3RW9mODdYLzdZcUxkV0F2R0Rk?=
 =?utf-8?B?QklUNUNqVWIvYms4MmlVbG8reThQNm9zdWQ2dStDYitkUEtqZDVicEVBMWYx?=
 =?utf-8?B?bGNJMGVNK2lWS0tjRUFoSms1bzNhb1ZwcndoRkN3UEFRc0s0YVBUWlRxUkxN?=
 =?utf-8?B?bzNHem94YUtTVGppcHJuTUVzNTdUQms4Ynlucm1NbG0xYUxUTU1nby9iYVVp?=
 =?utf-8?B?NDdxUXRiY0Q4T0dQenZEVjJxcGZKVGo3dlR5Q1lxRE4yM2VadFB1Mm9pVzND?=
 =?utf-8?B?L2FrclZoT044V1JFT2RPOS9Hb21BSG1BZnBsTURNeTZzZmxnK2pvZVZmOS9k?=
 =?utf-8?B?QjVPbUxxNnFaYzIzK3VsdlQvcE1qczJGdGxXZ1h6UlEvVUxZMG1PSmoweW1t?=
 =?utf-8?B?dXVuNDdMNFVqME5FWXNkMGV5NisyUGlnaG81MHRlNU5DM3VaWGVDRmxjRElh?=
 =?utf-8?B?cnQxdHU0aEpZSWpSemxuL3ZpUisrb1ZrUElLMUJmK1FUUHlmZG9scmxvdC9j?=
 =?utf-8?Q?2fGyYz68kKY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1BOQjlsTFZ1NjhPRnVVUUMvUDZvb0kydkNQQXUrNFBDK3FZUlBiQ0tsOHZB?=
 =?utf-8?B?L29KSUZuS0d1bmErdG1EbzN0Z2FvNGV3MGMvSXVNZHltQUZyNXdxdCt2Q2VK?=
 =?utf-8?B?QnNmOVFIRFZHS3NqVnBJNGRSdEZFRFE1dXZnMUR0dlg4OWlVUWU4NXZEVEt5?=
 =?utf-8?B?N255ZU9ETDh4TnRBS2NhWHdFSEMwNlQrR2J4NEpXcXpkemR0dUd4U29sUGh5?=
 =?utf-8?B?bHJFdnhuWFdCT3RuNk11akZrVUVmOG95dStsZmpzNWEvclF6UjFPTythcnNV?=
 =?utf-8?B?Z2djaHR6Ym0xKy84QktSL3I2VWgwK2dHUVBqNG0xRFhheEkxZytNZm92YWF4?=
 =?utf-8?B?a2JKWnVLa3E1alJubWhobWI2UlhWcEtxc0RYTlBKSE1ydFJmbkRZN21qaDdB?=
 =?utf-8?B?ZEdIUkZEeU9ORmVPeU5aelFBdXhQWTFzeDYwWVNaR0Z4enNwNmxUN2xLaksv?=
 =?utf-8?B?Mm02NEpObmtwSjlkL01KaHFDck94dXZ3dkJ3WWJIRkdiQVZNemY5bFliVGNF?=
 =?utf-8?B?RngycGFFemlBZTh5TjIrM0VUUWdJMW9JdWpDOXVSSkx0QWQ5YS9wdzc5akVh?=
 =?utf-8?B?K3ZQVFgrL0ZFd3NnckF3aEJCYVBxeTR5OEE0UzhBSFZjK2oxMjR0WXprRTVp?=
 =?utf-8?B?UEpoOStqNUtCbkJPR0UvcmdaMTduMy9LcVZjTHZ4TEcrMUNXeGNabmlJWGZ1?=
 =?utf-8?B?blJpd3lwcnNxUUJzTXpkZmNNZ0lOTFZYVThPUWtHeVBmSEZBSTRTa3Vwandy?=
 =?utf-8?B?NFRWdjVOMzk3a0JVcUNxMVc3NGdHS28xZnh5V0tPVnVuenFmU1h1azM4RHN5?=
 =?utf-8?B?cUhHOFV2ZlVaT2Z0NlZneVNyTWJoSGJ3NkY0RGJCcFFUWnhuR2pOZGJ2UUQ1?=
 =?utf-8?B?ZmdZQW14UzJ6OUJITElVS2RLck1ZUEszYkFrNE05anJ5S1lybmVCSGsyNWZy?=
 =?utf-8?B?YWowQUJjVFRjMzhLNVZSMnQ4WXk1bmdKeGFOaVNsUGNKb01jY2ZrOUNlZnlH?=
 =?utf-8?B?Y0UrM2VWdDNQY2hOTm1IRk5oNklmV1NCYlVMTWFtT25sRVJqT0h4YTBaY0Nh?=
 =?utf-8?B?QmJ3alN6RXpBZGZ5eE56VURrZnBHTXE2NHR4bitjRVVvT0xZUmRZSFNNVHNs?=
 =?utf-8?B?YXVDWFNMVW1TOEpTcDI1dWFzcHUxR0FmQ2VBTTVnZDFhMjZJRUZ5MHNmOVpk?=
 =?utf-8?B?U0ZaRC9PL3Raak0zVU9RNERYL0FmRVdQRTV6aUJTZmEycXI5STd1WU02Skhz?=
 =?utf-8?B?NGNCeGlnWVRDbXBtZUJWSmk4blBCUWxDNUcycVFTOEMvUHBscnVVcVFibkRO?=
 =?utf-8?B?cmZsbVNEUUd0eklOSGZTYWgxYlgzS3hDaUNiTWp0OGJQK3hycXNJOVhsVzAv?=
 =?utf-8?B?MEtxNVEwa2hhVm5vckFTcWt1Kytja09BNTZkZkhiSUhFV3BEQWg1ZUgybHVX?=
 =?utf-8?B?aE1HaFRZaGtXSTNybEM3dW4vS1hPNUtva2JQN0lxSG8wZGxMaXZHSFc3RHFs?=
 =?utf-8?B?UG85b0VlemMzY1VZM0ZDTGtwaDJGNzhLT0VpdTE4OWhHM2s1V3lwanBZYi9C?=
 =?utf-8?B?MW9FYkQ3VGtZR2gyVnIwajhjRHlidGp4UjFXZlVoWHM0ZjlXNjFhc1FBNVFq?=
 =?utf-8?B?YzBWRWxqUU9wcHVtVVVpam5ieE80bjcraW5JME51UnlTMVVRdUNnL1dLSXEz?=
 =?utf-8?B?enRuYWNjdFhnV1RuWkpQZEF6bGQxZGlXOG9ja3ErZWNLWmJIK3hwUGNSVFVa?=
 =?utf-8?B?Q1lOM0xLZVJZZUl6b2Q3Zkx5ZFNacGI0U0ZyOW1TdmVITE9oYksrK1pwOW92?=
 =?utf-8?B?M0pTWkVqQm9sVW9MbWVUYm80OHAzTTlrd3kxUXNTL2pqT29abXVFZXNjWEJp?=
 =?utf-8?B?aXNWZ3ZVSzA4ekRnY1JkWngrN0ZCRnlFQlRoZUlxeFNwYkhCSzhBNVVpVkNt?=
 =?utf-8?B?OFYxWjg2NWNKZnUwK0pud1hvOVp2bTRLeDF2bW9MUmNkN2ozM05ycGt0ZWp0?=
 =?utf-8?B?STkzdWRKNlZNczdaVTMrNEdSZis3T2hTZE83VWY1b1NHZDVIaU5MbCtOdUlI?=
 =?utf-8?B?QXVLYzgyenhTUkd6KzcvUDlZVWc3WktwWmZOL2RCQlNFUTQ5VlFBaFBSemFx?=
 =?utf-8?B?aDZyS3g0QUhTS1Jyd0ZlbG5VcjVVNzRiZ3ZEZzgyMzNIZDg3K2s0U2Z0dktP?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5acec388-807f-46ca-c1be-08dda8ca8a32
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 09:30:01.6175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k7+IFV03/z+xnuf8rVhQ1P1lMsb/lbRv9HbW0tS3KAY2cBZHnJYXek+V4jgqZG0FLmjYWZdXyvAIOznDTyLN7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7738
X-OriginatorOrg: intel.com

On 11/06/2025 02:20, Sean Christopherson wrote:
> Use the kvm_arch_vcpu.host_debugctl snapshot to restore DEBUGCTL after
> running a TD vCPU.  The final TDX series rebase was mishandled, likely due
> to commit fb71c7959356 ("KVM: x86: Snapshot the host's DEBUGCTL in common
> x86") deleting the same line of code from vmx.h, i.e. creating a semantic
> conflict of sorts, but no syntactic conflict.
> 
> Using the version in kvm_vcpu_arch picks up the ulong => u64 fix (which
> isn't relevant to TDX) as well as the IRQ fix from commit 189ecdb3e112
> ("KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs").
> 
> Link: https://lore.kernel.org/all/20250307212053.2948340-10-pbonzini@redhat.com
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Fixes: 8af099037527 ("KVM: TDX: Save and restore IA32_DEBUGCTL")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks for fixing this up!

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>


