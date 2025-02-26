Return-Path: <kvm+bounces-39411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28F74A46E07
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 23:03:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13F393A5529
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 22:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A264426A08F;
	Wed, 26 Feb 2025 22:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qqnfe3rO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3F3269805;
	Wed, 26 Feb 2025 22:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740607408; cv=fail; b=fHLhcZqcHmYNuTfmNyTlbg2rCjzQypXYhtD4vhE6DQqyRA/byrmx33k0hlZLuMyuhBukj4VLJbe+aXT2hKBCkBssHQmW/BYSKKHbsFqwb1fkzszwnhyFWaVIJDtdaZ6QJVgPwFkjJVcAazx6XJOYmhaVUoFuL62n112xKJKPpL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740607408; c=relaxed/simple;
	bh=pVeTZOSNSkS1jxBkr7pqS50MuC/X1yuqvFqHPElM1So=;
	h=Content-Type:Message-ID:Date:Subject:References:From:To:CC:
	 In-Reply-To:MIME-Version; b=tKYf7YqGSLFLEeKAMrYvEv4ZGIh6ECztIuZfnWHiwG6bIzTHWRC2bhsl05ITUwTR2ataMVqvduLkLUWZ1O6YWjZHUOa1EYmiIOQDufNVaky0YIfmRDBlbA10solw/aYkbbTgAHMJI47gefgrJxePoMHLBE+J+TfpVrGGHRZkI8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qqnfe3rO; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740607407; x=1772143407;
  h=message-id:date:subject:references:from:to:cc:
   in-reply-to:mime-version;
  bh=pVeTZOSNSkS1jxBkr7pqS50MuC/X1yuqvFqHPElM1So=;
  b=Qqnfe3rOhWvYrI6CMP7U58Sby+KdfORa71se80yCaG5SuYFTtlI7EPXu
   zqAFdYxSR8NQhgZYwHSvNfTxrGPQ55h0ldH9OhYrs58lw7/RWhlLHLNjb
   5JUHfB7PvtNkgCfwJQNMilEoklcGCwrg5pvKzDqLCmEXSVamSJMEb/+x6
   ezv5HhtUqm+MbwOjZr4Y7uhoaE6wIL1nEBSWomPAQ5kWAUA9NE7uyIefx
   uDoLRhOihVUobHkAEYdg0SU07kvIDF9VWbPfHerDQRhx0awH/ZZGcA9Ns
   2OGdcEaUicEBBEK94SQasK1NxWOAb8U8EIUpGRhlP3SJU7ASyjbrTdR9c
   g==;
X-CSE-ConnectionGUID: +3HgWCmLS/qMDLF3bHsalA==
X-CSE-MsgGUID: FDS9HaUSSTyblw0CDpfGaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="52113654"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="diff'?scan'208";a="52113654"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 14:03:26 -0800
X-CSE-ConnectionGUID: 0lS1wYRSRcavF0lCJut4Ig==
X-CSE-MsgGUID: 2kKsZa/+SmS67NqPOjMBAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="diff'?scan'208";a="140055183"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Feb 2025 14:03:25 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 26 Feb 2025 14:03:24 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 26 Feb 2025 14:03:24 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 26 Feb 2025 14:03:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SABQiLOzG4UeQi1uTCF9HTFIixXvIZRKTCkBlLdYXWkhv4GOGLx7KHZTT8P0k1LX6Qp0spuLdm7VCvcttzvGFjMC9IMgKZt7BNXIWUEzDnXTTF/okfJ6XCs/bmNq2Ru5Iryt4asCxFSeeCk69E0AlZB1Ebb4AP0FegH4Ap4C7omrrDuN4iBT1exfeQMMS8hWV4zMYEL39kQKT44zGQkzJovsQWd+u+NhgC1TiCiXvjq/u7RVm8WacYEjgEZxu+lP5hXIHH9aQRW5Ev8uHOMjfniwxVqhKhx2MVgbmMO9NJDP/6lP28bUnmnEjLBpj2H3/rRvOhgXZJjeyx0JkMHFeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUnhSi8i5l8NrYk4i/hyUG76qXyNKhEPmFXdCo+so6M=;
 b=n4OMwjXbxlmFY6H3xu4KtwRMhHDbsvuEArftGlNqaRW0YWCtaEmLTha/0Sh2gJ10qaVl/7kv8USBm/cmjZSsDo0ix1+BXAIf7PXG2tjPCi/wFFJrvIMZfkogdrzSGBjhfbS3Amz/7ALOUzuG7p+R6/SKJMEdRPmDcm7Ts9M0W/sAYKTRSH7KTYV2kAVyeTKmd3cVDtH3IpCSCum6GABLEcf//eU0C9HeV8KD5vD5uuv1BJorwd7h8TgPXSHjiCglw6eV7tKknbSCHy3iJ38B+4pPp5Kc9A++J1DsHszu7AEtjRb+SbRRGVNDXL/m9GzQbtUPdKHohVSw6+3LVpbX/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6379.namprd11.prod.outlook.com (2603:10b6:510:1f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Wed, 26 Feb
 2025 22:03:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8466.016; Wed, 26 Feb 2025
 22:03:21 +0000
Content-Type: multipart/mixed;
	boundary="------------3w2PH0PMQrSNZ3h8TaLQMVSe"
Message-ID: <9079202f-2b0d-4bcf-8f61-36c7234245d1@intel.com>
Date: Thu, 27 Feb 2025 11:03:12 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/33] KVM: x86: expose cpuid_entry2_find for TDX
References: <20250226181453.2311849-1-pbonzini@redhat.com>
 <20250226181453.2311849-26-pbonzini@redhat.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>
In-Reply-To: <20250226181453.2311849-26-pbonzini@redhat.com>
X-ClientProxiedBy: SG3P274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::17)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB6379:EE_
X-MS-Office365-Filtering-Correlation-Id: 09c8e6d0-8280-4ab6-c043-08dd56b16221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|4053099003|4013099003|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L2lyVVBQc0Jjb0V5Y0NoZy95MnBzSU9YbU9RMDEwU2ZEMU5JMlpjMG1wSThy?=
 =?utf-8?B?VnNXcGdnb2p0MjM1VVVZeFUxVVdZSnN3Z1gwWkxPREI1YjYzRGtsTWtjYVNH?=
 =?utf-8?B?cjB6UHZDU0ppckk5OWFDTk1pL05wWFRUb2xIOGU2YWExQ05KaTZSU0VBZmF0?=
 =?utf-8?B?ZU5pSERJcFlZOFVaa2FpQWFIZ3YvQ2pna2MzYWhYZ3d5aklraXBNRXdOT0hZ?=
 =?utf-8?B?QnJiWlh5VGtOZ0xKL0FITWsyZnV4dlJ0ZW0zK096b21VdDZJajB6UXVLUjEw?=
 =?utf-8?B?VnJxV2RTTmFVZ0hSMTNNb0llcFh5TGM4Tm93VVZ3Zzc5SVp1VEVkVmRDcW9m?=
 =?utf-8?B?ZFVWUVU3bkVhc09mNnh3YjBuWERkZ2hqZ3Jpdk9nWFpXa0FxQlhtaEg5WXZI?=
 =?utf-8?B?ZEozTFovOExYNnJUWms4VWgyWkZTQlVlQmZyS3BjZFdaRmRBQ3gyZGVlaGFi?=
 =?utf-8?B?VlQ4TFNEVmZxUTZ0akN2aXlXM1BFY0hJWlhFZ0FYZCtUaWNPL3dMYmU2YkVs?=
 =?utf-8?B?aEVNZFZ0K0JBN3RiVThqVC9FWGJVYXcyOW9SSG14UzRrYjAzM2NxYURkaE1n?=
 =?utf-8?B?RVpsMk9nQkZmbG5ZQnllTzNwbkVCeTc5bWhFSG1SVXBHSW9qenBzdDNQVFNN?=
 =?utf-8?B?eXFLSDJXSSs1aTBaanBVdXFWRmhtcWdlV2JaWVNnME5iOHN5UGZra2NOVjM2?=
 =?utf-8?B?RnQ0OS83Skc4b1lDRjJmZ3Q2WUNtVXByUGxzMVRkT2R3YnZrK1ZBTE5taHFU?=
 =?utf-8?B?eU8ya2N6UXZqQ3REczhiMUppUXlFT3k0QW9NSmRDTlUrNE52MDdQL1g2azhv?=
 =?utf-8?B?NVZRQ1NZL2g0SVVHRlNIYXNuN1lvWmdVR0RneVI4RUZXNkhkZVkyTk4yalNp?=
 =?utf-8?B?ZUdrRXZhenBCTFhnKzlGMFRQK3pMZTJleWVVY3F0bit4K0ZQU1JCTXdRTXYv?=
 =?utf-8?B?MVRBUXhkQXIzYjNZcHFVYmJlTTkxYno0TW9IL0VsTGZBQWJ1RzRpTmVVQlZ0?=
 =?utf-8?B?a0w0cDgxcjZVS2xCWUFkbU00ODU0d0RoZ0xmYUdWZUxJRlBIa3NPV3NxRkYw?=
 =?utf-8?B?MkZ5dGREVjlTdEgvRjZhdGFERlVZNW0rTWM2dnVyaklkYkdWeVo1ZzZBV042?=
 =?utf-8?B?cktqNmREbXl2aUYxdUhhZHR4ck0xbmJ6N3N1WTV0N0RCTWFWMVh5bmFaK1gr?=
 =?utf-8?B?R0hWMS83QU5qcm1rSHdrVnhHci8vSWhnV0Z4UWpoaFRmbjhraVMzSUdYeVJ4?=
 =?utf-8?B?TWtka3JUcFdtemtrUkxoN3F0bXFQNUFjb1poQURKTDhPTisyckZ1UlRJK3dK?=
 =?utf-8?B?NVhRWm1RbjNHczRSdi9jenpuRVVLWE1WOXJJWXl5VWw1YkxubDJtZUwrQjlN?=
 =?utf-8?B?UURQU3l1NDMzcU1CV1luaUpwdHgvandRVWRxbG92YzBCZEJxSHlyUHc0WTdn?=
 =?utf-8?B?dDJPaCtERHkrQWRxcUd1VTN1cWFUTWE5bEptcVVTMnR0a0twcmxnSnNEMzNT?=
 =?utf-8?B?VEhETlZTNVFremFXeXR2alZabmNHUUJPQjMvdXAyTllhNGwvRHIvOFJZU3pT?=
 =?utf-8?B?WkxCKzl6TVBZZmREY0lTRkVZdWtEa2E5U3UyM2hCRjFxMTFCd0pGR2RJeDA3?=
 =?utf-8?B?T3NsVFV5ZVpmSXlvNFpsbE5ic3A5WE9CS3Bna3c5OFJ4TjBwRTU3dUdLSHk0?=
 =?utf-8?B?NUhWdG1iVjBTQzB2SDhRaElUWUtudmkxWGczQTRLRzhudEljcUE2Q29LTDZC?=
 =?utf-8?B?UkgycmlzNnZOOXRmSnNBTExCeWQ1K3F0ZE1ERWJ6OHVhcWVWTlQra0JuV3lk?=
 =?utf-8?B?MzRSYyt1ZXdPZWlyZHE1VS9jTmVuaU0vV3lFOUl5cE9ZL1V6QlVFd0ZmVnQ5?=
 =?utf-8?Q?fxmnfOLw8HdEA?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(4053099003)(4013099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0dWM3dKRXM1VFRBMG85U1BrbU1MWFZmbzNtM3B6dDhhWWJHRnF3QVhkNUZJ?=
 =?utf-8?B?WWZwU2gvM21oTm1SVFRhZDRrbmlWOWphUlhmZFk2ZVE1aWcwbHVZL0FiNGo2?=
 =?utf-8?B?LzF2WUZkMTBWbzZwbTBxUUJ0WnBkNVcrSTNXaFRBekQyQlZsRHpyb0JNcW82?=
 =?utf-8?B?YWRCYk1PNVJ2SFVqaC9xRmVRZVAxcVRHNHhIZUc2VmxLa1JRMmxkalZiMjY1?=
 =?utf-8?B?QkM3UFFsdjdCRjhnV2dxK2ZLNHRyY1E4a0lJR0ZjRVErUWN6T0pOT0U2OG1n?=
 =?utf-8?B?cUZ4dEUxMkxydU1qcU9nbDJWWk84OXpRZlhNQ0pUVHdWM2xRUzlWN0hpbVpH?=
 =?utf-8?B?TStuQTdqSHBFMkhvTnpOUFlwT0wzbHFsZVI4dVdUMHBnK21DbWxvSHVZeTZR?=
 =?utf-8?B?dnIzVmRyY01NN2IvMmFaR0dWa3ZoWFRhWTVVemQzRi9mQjJMS2xJcks3Qnkw?=
 =?utf-8?B?K05LK0dmVXp6T2ViSVBxZktYUHA5NkovMG1HNlZ4cE5nQmtSVVdhbTJGMkRJ?=
 =?utf-8?B?Ty9jcGtpbmRiSkZLWks1U3ZtNXdyNkZjbitoRFFMeC91U1Fza3JCUjdhYmM5?=
 =?utf-8?B?S3ZXRjVFSFB5Z29maFpZWGpPVVVHYzJkVUFNMjI0Y3pTM2VYWkJkSjhBZHJC?=
 =?utf-8?B?T25sL0xwdzVNQzFvaG5ieU5LL2trSFJQa3U2TDlMM09JdmdGNmJqTVNwV0pZ?=
 =?utf-8?B?bGVhcGlXNDBRODI5VUxpcWZQR0ZhS2ZCMjBDc01BRTEzUDkwZEdhK1FCVG12?=
 =?utf-8?B?bWZhZm5PR2JlNlpNd2lTNFR0ZSs2NHVQYkR4TTNjSStNZFFrWE9sMzJDeE1v?=
 =?utf-8?B?cENzOWpESVZUWWd1U1VLUlVZMGxRSjJqTGFjZDNvZG1PTVl4UEQ0dEtEN2di?=
 =?utf-8?B?WS8zS2F4czFRVlZaWVFUN3NYVCtQWUJRa2c4WVJ2c0xxZnp6SGhDNVF3Uyty?=
 =?utf-8?B?WGxMOW5zbFRkRldhaEIzQ1cxdWloWDdWbDNUVnJOOXp4M3hKRTdNSFh1a3N0?=
 =?utf-8?B?MmZ2YjI4WVZpNzliU3JrMkplYmp4aTFaWXlmTkgwNGxKS3BsZjI0cWVXYmxm?=
 =?utf-8?B?Zk5qazVpYzkxTUJ0NWRwYzhVZmtCRE56NjVTUERMZTBKRFVGNkZlK0dISlNw?=
 =?utf-8?B?WFBMSW5FSXpGOEptQTZKY0dQZDdOT2c1VzJuVzBqeEV2THRSV3pIcFJleFo3?=
 =?utf-8?B?MThkUUc5OEFubjdLRTY5RVV1d1VjVkxqeDJyYng5Mmh1ZjhNZ0RjVytFTENn?=
 =?utf-8?B?U2lJMWROY25JRUlkN1Fwa01iUk14WjlDZDdjdVlQamFad00yQTNoZkViV0wx?=
 =?utf-8?B?bDN0ekxTUDV0MDRoN0k1T3pjbmpIeGFreEpDT2hicUFjOWd2aFhzUjdodzBq?=
 =?utf-8?B?d0tzQ2gweXBVeGw2WUVxZXRsS2ZwYllwOE5yaGNiOUZFcEVEV1E1enB3QWd2?=
 =?utf-8?B?ejJmN1FaT3RFaVBLWUw1bnNjRXdQNVRqOVg2aDBFWWxMV2M1MjRtbmtpZVZI?=
 =?utf-8?B?WDU3bno2MFl3ZGY3U2dzc2JVMUVHTWxQRkVOKy9lSjZZTjFsZWsyNllSbFZB?=
 =?utf-8?B?K3RGT3R1eWRURHlmRlFHdEFGZDd1UzVmSzBDY3JoVkEwck9QUUpUSUFiVGh0?=
 =?utf-8?B?bEVxR2VBZko0b0hFUEZmaWtyNzI4TitWb24xY21zWC9VbTl1TE9kdStmMnAz?=
 =?utf-8?B?QjJ5V1lZZ0pEWFo2czVKampjY0daSDVmdmRxZDFIQzJDM0JLbmEwenlzdisr?=
 =?utf-8?B?UmRZa3IweHlteDRRSmFCODNIMFFMdG40MVBNZWRRaXdpNS9WYXEyOFFCOHBr?=
 =?utf-8?B?bGpDaE91RlBrWGN1RjgrYURkdE0xUTY0cHQ3VHAzR3Z6M2dnekZJckVDM0d0?=
 =?utf-8?B?NGkyV0NOb3dJMlJQMU5wZVdwdHF3eGRGUFFBbFhyOTRsMEhvRHN5NlRMOGtm?=
 =?utf-8?B?VEs1cGsrMUtWenBGMVlpU25KYTRPdWUzaGVhbmt3MFVpRXAwOG5saEIvK09p?=
 =?utf-8?B?L01JaDUxdklDTDhRRVRZWGZLbDFvN2ZOdmdRejYyZURKUlJ5WGoxaERta0xu?=
 =?utf-8?B?emN4eDUvUk0zVE94KzgzTm5nYTl6ZGdZTjdFTzJnYi81a1BjQTJjZGNONEdE?=
 =?utf-8?Q?xd5GiHsEGGi53/4llaMvmD/fU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c8e6d0-8280-4ab6-c043-08dd56b16221
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 22:03:21.5562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YvvYWPNXTjrcFRVSdlkSBtP1KGcgwvLNr9WHvQmyL4JLcLch0QFdLY2U3v8eRIBlGFwORZIaArvZc6bYc8ZYaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6379
X-OriginatorOrg: intel.com

--------------3w2PH0PMQrSNZ3h8TaLQMVSe
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit



On 27/02/2025 7:14 am, Paolo Bonzini wrote:
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Kai Huang <kai.huang@intel.com>

... assuming there will be a changelog, e.g., perhaps something like below:

TDX will need to search a CPUID leaf from a list of per-TD scope CPUID 
entries w/o any vCPU context.  Abstract the code which does CPUID entry 
search from a given list of CPUID entries as kvm_find_cpuid_entry2() and 
Export it for TDX to use.

And one nit below ...

> @@ -141,23 +141,26 @@ static struct kvm_cpuid_entry2 *cpuid_entry2_find(struct kvm_vcpu *vcpu,
>   
>   	return NULL;
>   }
> +EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry2);
>   
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>   						    u32 function, u32 index)
>   {
> -	return cpuid_entry2_find(vcpu, function, index);
> +	return kvm_find_cpuid_entry2(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
> +				     function, index);
>   }
>   EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry_index);
>   
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>   					      u32 function)
>   {
> -	return cpuid_entry2_find(vcpu, function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +	return kvm_find_cpuid_entry2(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
> +				     function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>   }
>   EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);

... I think we can change both kvm_find_cpuid_entry_index() and 
kvm_find_cpuid_entry() to 'static inline' and place them in the 
kvm/cpuid.h to avoid exporting them.

See attached diff.  Build test only.

--------------3w2PH0PMQrSNZ3h8TaLQMVSe
Content-Type: text/plain; charset="UTF-8"; name="tdx_cpuid.diff"
Content-Disposition: attachment; filename="tdx_cpuid.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9jcHVpZC5jIGIvYXJjaC94ODYva3ZtL2NwdWlkLmMK
aW5kZXggN2ZmODQwNzljMWY0Li5lY2YyNzUwNjkzZDQgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2
bS9jcHVpZC5jCisrKyBiL2FyY2gveDg2L2t2bS9jcHVpZC5jCkBAIC0xNDMsMjIgKzE0Myw2IEBA
IHN0cnVjdCBrdm1fY3B1aWRfZW50cnkyICprdm1fZmluZF9jcHVpZF9lbnRyeTIoCiB9CiBFWFBP
UlRfU1lNQk9MX0dQTChrdm1fZmluZF9jcHVpZF9lbnRyeTIpOwogCi1zdHJ1Y3Qga3ZtX2NwdWlk
X2VudHJ5MiAqa3ZtX2ZpbmRfY3B1aWRfZW50cnlfaW5kZXgoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LAotCQkJCQkJICAgIHUzMiBmdW5jdGlvbiwgdTMyIGluZGV4KQotewotCXJldHVybiBrdm1fZmlu
ZF9jcHVpZF9lbnRyeTIodmNwdS0+YXJjaC5jcHVpZF9lbnRyaWVzLCB2Y3B1LT5hcmNoLmNwdWlk
X25lbnQsCi0JCQkJICAgICBmdW5jdGlvbiwgaW5kZXgpOwotfQotRVhQT1JUX1NZTUJPTF9HUEwo
a3ZtX2ZpbmRfY3B1aWRfZW50cnlfaW5kZXgpOwotCi1zdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MiAq
a3ZtX2ZpbmRfY3B1aWRfZW50cnkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAotCQkJCQkgICAgICB1
MzIgZnVuY3Rpb24pCi17Ci0JcmV0dXJuIGt2bV9maW5kX2NwdWlkX2VudHJ5Mih2Y3B1LT5hcmNo
LmNwdWlkX2VudHJpZXMsIHZjcHUtPmFyY2guY3B1aWRfbmVudCwKLQkJCQkgICAgIGZ1bmN0aW9u
LCBLVk1fQ1BVSURfSU5ERVhfTk9UX1NJR05JRklDQU5UKTsKLX0KLUVYUE9SVF9TWU1CT0xfR1BM
KGt2bV9maW5kX2NwdWlkX2VudHJ5KTsKLQogLyoKICAqIGt2bV9maW5kX2NwdWlkX2VudHJ5Migp
IGFuZCBLVk1fQ1BVSURfSU5ERVhfTk9UX1NJR05JRklDQU5UIHNob3VsZCBuZXZlciBiZSB1c2Vk
CiAgKiBkaXJlY3RseSBvdXRzaWRlIG9mIGt2bV9maW5kX2NwdWlkX2VudHJ5KCkgYW5kIGt2bV9m
aW5kX2NwdWlkX2VudHJ5X2luZGV4KCkuCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vY3B1aWQu
aCBiL2FyY2gveDg2L2t2bS9jcHVpZC5oCmluZGV4IDQ2ZTA1OWI0NzgyNS4uNzM4YjM5NjQxNmNk
IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rdm0vY3B1aWQuaAorKysgYi9hcmNoL3g4Ni9rdm0vY3B1
aWQuaApAQCAtMTQsMTAgKzE0LDI5IEBAIHZvaWQga3ZtX3ZjcHVfYWZ0ZXJfc2V0X2NwdWlkKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSk7CiB2b2lkIGt2bV91cGRhdGVfY3B1aWRfcnVudGltZShzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpOwogc3RydWN0IGt2bV9jcHVpZF9lbnRyeTIgKmt2bV9maW5kX2Nw
dWlkX2VudHJ5MihzdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MiAqZW50cmllcywKIAkJCQkJICAgICAg
IGludCBuZW50LCB1MzIgZnVuY3Rpb24sIHU2NCBpbmRleCk7Ci1zdHJ1Y3Qga3ZtX2NwdWlkX2Vu
dHJ5MiAqa3ZtX2ZpbmRfY3B1aWRfZW50cnlfaW5kZXgoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAot
CQkJCQkJICAgIHUzMiBmdW5jdGlvbiwgdTMyIGluZGV4KTsKLXN0cnVjdCBrdm1fY3B1aWRfZW50
cnkyICprdm1fZmluZF9jcHVpZF9lbnRyeShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCi0JCQkJCSAg
ICAgIHUzMiBmdW5jdGlvbik7CisvKgorICogTWFnaWMgdmFsdWUgdXNlZCBieSBLVk0gd2hlbiBx
dWVyeWluZyB1c2Vyc3BhY2UtcHJvdmlkZWQgQ1BVSUQgZW50cmllcyBhbmQKKyAqIGRvZXNuJ3Qg
Y2FyZSBhYm91dCB0aGUgQ1BJVUQgaW5kZXggYmVjYXVzZSB0aGUgaW5kZXggb2YgdGhlIGZ1bmN0
aW9uIGluCisgKiBxdWVzdGlvbiBpcyBub3Qgc2lnbmlmaWNhbnQuICBOb3RlLCB0aGlzIG1hZ2lj
IHZhbHVlIG11c3QgaGF2ZSBhdCBsZWFzdCBvbmUKKyAqIGJpdCBzZXQgaW4gYml0c1s2MzozMl0g
YW5kIG11c3QgYmUgY29uc3VtZWQgYXMgYSB1NjQgYnkga3ZtX2ZpbmRfY3B1aWRfZW50cnkyKCkK
KyAqIHRvIGF2b2lkIGZhbHNlIHBvc2l0aXZlcyB3aGVuIHByb2Nlc3NpbmcgZ3Vlc3QgQ1BVSUQg
aW5wdXQuCisgKi8KKyNkZWZpbmUgS1ZNX0NQVUlEX0lOREVYX05PVF9TSUdOSUZJQ0FOVCAtMXVs
bAorCitzdGF0aWMgaW5saW5lIHN0cnVjdCBrdm1fY3B1aWRfZW50cnkyICprdm1fZmluZF9jcHVp
ZF9lbnRyeV9pbmRleChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCisJCQkJCQkJCSAgdTMyIGZ1bmN0
aW9uLCB1MzIgaW5kZXgpCit7CisJcmV0dXJuIGt2bV9maW5kX2NwdWlkX2VudHJ5Mih2Y3B1LT5h
cmNoLmNwdWlkX2VudHJpZXMsIHZjcHUtPmFyY2guY3B1aWRfbmVudCwKKwkJCQkgICAgIGZ1bmN0
aW9uLCBpbmRleCk7Cit9CisKK3N0YXRpYyBpbmxpbmUgc3RydWN0IGt2bV9jcHVpZF9lbnRyeTIg
Kmt2bV9maW5kX2NwdWlkX2VudHJ5KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKKwkJCQkJCQkgICAg
dTMyIGZ1bmN0aW9uKQoreworCXJldHVybiBrdm1fZmluZF9jcHVpZF9lbnRyeTIodmNwdS0+YXJj
aC5jcHVpZF9lbnRyaWVzLCB2Y3B1LT5hcmNoLmNwdWlkX25lbnQsCisJCQkJICAgICBmdW5jdGlv
biwgS1ZNX0NQVUlEX0lOREVYX05PVF9TSUdOSUZJQ0FOVCk7Cit9CisKIGludCBrdm1fZGV2X2lv
Y3RsX2dldF9jcHVpZChzdHJ1Y3Qga3ZtX2NwdWlkMiAqY3B1aWQsCiAJCQkgICAgc3RydWN0IGt2
bV9jcHVpZF9lbnRyeTIgX191c2VyICplbnRyaWVzLAogCQkJICAgIHVuc2lnbmVkIGludCB0eXBl
KTsK

--------------3w2PH0PMQrSNZ3h8TaLQMVSe--

