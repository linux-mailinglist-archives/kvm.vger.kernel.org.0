Return-Path: <kvm+bounces-63417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7244DC6608E
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:55:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 21A3E2911B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76873195E5;
	Mon, 17 Nov 2025 19:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ObR8hUa+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FE525782A;
	Mon, 17 Nov 2025 19:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763409323; cv=fail; b=TCZeZoKQhY6TTCpuRk99DgUzQUfanZ7U6fKeCXVHd2tB5msr6ok1ptmcTttABnwh5qqYOq9IFTqPDK1M3M62Q7KZPNKRpx48lXgIFzN4FS3BML7Q3Mof1Np5dXbwgRp63GNc4UMO59S8Pu9Gw1hZlHSLGdUwKhnbrF1mY67rEjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763409323; c=relaxed/simple;
	bh=XRHNpX34iGRNX41v2r5wgJ9IUXiUHw2IhZ1zamlbB4w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p1WZm/wILSGKFj60WlYhV3K7Uc2xL9CY+jn8b0LXfSZoXuBOTM4qyodgkojZGqefJejoYfoFIjdNONQe9sSzhL6tj6JmeeH7APLY4bpCn9xdWwJ37jZd/PkSnzBVee9rpjrz9rifcSGmP7k96oBl/ma/sLTEZtlz4wLIRWgZp8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ObR8hUa+; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763409322; x=1794945322;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XRHNpX34iGRNX41v2r5wgJ9IUXiUHw2IhZ1zamlbB4w=;
  b=ObR8hUa+LfG5Ka3m0ssCgVudGp9fh/O94cIKIBiOvmRNpwuNAOMYSVxd
   QO8fWmIUIcJjN630ZEhCggL8/69ExmzJnK/J2BCKzaUMGqbZrCBTqkAk5
   Ftu/39bgN7/qcttpO+O/hSgPqpedyUtxhixI5sSS/AEB4vJBreamcSE95
   WOCMlUwn47x6hGCl+O6wUYxGCPVnr4bvWOyuko1NW9qvpgF6SjActax/D
   suoF69vTWeUvVbVSX80OcaC+0LvdaVc0a5+iCA2ngkgCQPkg+xFf3zUgk
   TKw4QLiOuZfc6fxAkyZPq+/Q12Ymg4DBjNkOVvjoSmU6ML39PN3jyzBd+
   w==;
X-CSE-ConnectionGUID: BC48n/9jT8a77x/n5F+uZQ==
X-CSE-MsgGUID: uLTosLHTSDu/y6WK+384og==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="52992403"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="52992403"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:55:22 -0800
X-CSE-ConnectionGUID: 0Bz8o6r0SL6zoHHhYBdnmw==
X-CSE-MsgGUID: hOeAlDp9Sb+H36XBX5jgxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="190572577"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:55:22 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:55:21 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 11:55:21 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:55:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OpyIxS+Pe+xj9+bxT3pau2sgzvQSrLFQmfG+DPwkjVu5qnAcWun6fke6RqHfvmqsFLPCBG2SBRLaevpqT9hGMLRqkxk9KE89TgvZiPaiffGma6/gbkVRU1mxeg38fdCFC7x7OJ0cMOe6vjz+5g9dRtTKDymLWWfZLotdy4n6FzhOoMYhvKetoaYsOZWNbAiZcm2FjvFxnRg1ySr2IY95FjwWUte4/2gXGOjpqkHV/LCy6JkjnsseoVlZMfsskaMt+KWRqQi+vW8n45WQ3YagFOLQvj4+dHxF9WAYqLmU6t/zXQ15Tic6YWX6tButPoRoWCvrrBDuwEYMpszAjNPaDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IgQfZbPhiZMH/gvD3fFDvJhgC93wd0qXqVvZITPbfVY=;
 b=GyYzI5Nv6G2LT50qWoGMuzrEXvu9lAQl+mVvHW1PNPtkCjAQmlxPh/okoATbSEx/GIAYAOKlW8tyDz/wDHNLYWN/U1jn7PISruu/CMoPopn/omMsuocwxkvFG5wCdQ1SCydTZySi9gbRlVBVeIrrSdbjt/9QXk4hhPkO2c+OYM0z4e7jdUJzB4x40MCN+F0mUiAHb5J3SGGaDiqMsTBVQHvzxzPB0jKExQUFA9x4sXTNi7uxYeWajavhBQMrKs7eL5GCIoVWSt7BlZj6qE4RE/Uffp4bt3asoZXwzXH65OwTxoSWizZTrJUW9iPHkIO+XC0C5n32WMFAq7U3zlKmEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CH3PR11MB8562.namprd11.prod.outlook.com (2603:10b6:610:1b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 19:55:19 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 19:55:19 +0000
Message-ID: <7a140a86-59d1-43d1-a841-905721cbfaf7@intel.com>
Date: Mon, 17 Nov 2025 11:55:17 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] KVM: emulate: share common register decoding code
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <kbusch@kernel.org>
References: <20251114003633.60689-1-pbonzini@redhat.com>
 <20251114003633.60689-6-pbonzini@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20251114003633.60689-6-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0029.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::42) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CH3PR11MB8562:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c5b4b8-9353-46ba-2278-08de26133c47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eVVuQ0dNTHM1eGpPSnZVWEU1aU5HeXV5dWo2aVBoUU5ISXNGL0s1bmhZNVFi?=
 =?utf-8?B?dys2Um9RbjEwaWtvTFJNcU9Na3RUSzdIVVM0SVFKWXkwQzZ5MXVOaHRYTlp4?=
 =?utf-8?B?UEZwQlNpU2cwRkZVRUEwdWd3UHR1SzI4UWsxYmVSenRnVHBHejNpUGdhZnlE?=
 =?utf-8?B?bmNWY0wxUG5oQ3V1YXRDenlKeHhqVEVmMmhDanlqYVJoemJuekVNOCt4b3pF?=
 =?utf-8?B?UG5YenZ4YXVYMzNZUVFJdEQxOFBBQjNRQWV0REh3bzhaWEpQQnd2RGgvVXBD?=
 =?utf-8?B?aE90ZkFhRHlnZVBPdHhZaWkzbWJza2FmZFdBMnJXTll6ekU5bTNsRHdwNy9p?=
 =?utf-8?B?blBoTHNyYmxkMTdpMWNpeDBlVUppQjJLajJpSkVKTk1IclJ1OW9zU0hqejh0?=
 =?utf-8?B?VVp2RlV1dkozWEVhMTJacVRaLy9xZWdBOUxaWFl5MHRFYnhSNTIxaXNBL25U?=
 =?utf-8?B?a1VtVXI0NVdkQ1F1OVNJNjE3aHpYT0lRWXhoQWlIcm8yUGVaaHFFcUtlaGhG?=
 =?utf-8?B?Z1Z6cXNSUDgxQ3IzUHNUTWhaYnptQk4xMnlab0Y5d2lyWDVXd0IrOFNFZXRj?=
 =?utf-8?B?WUtJRUg4MmlSanljV1lQZU93Z0lHc2UzdUZLcldKUzk3NndUNXVUYWx1OTJh?=
 =?utf-8?B?Ny9hZHV6dWsyWmI1NGpEU0cyWFp0bGR0OVhVUnhoOEIzb3pwMzNVM1NwVDV1?=
 =?utf-8?B?S3hQUXFSZTNMejd2QUpYT0pFWnFSSTY4Q0FRNjZ2aStNcWVEZU1uc3FsVFNt?=
 =?utf-8?B?c3kwcmovUUUwV052ckNiQW1tS0ZZY1Vmb291M09QaTdsRmNBbWxQdGJkN2g1?=
 =?utf-8?B?Y3I4bjMxZmlOODhNb0JGMkpsTG9zZmRyOC9OOXVsdVV2aTZPWkk2OXhObzdr?=
 =?utf-8?B?VUFpUCtRVERuSk9EL1RtWFArMjM2aTNlSnpJWFhsMTBLZXBCY0pjRlZhZG91?=
 =?utf-8?B?ZDVpMWlta21NVGJSQlllSWN0eUxkNVBMUjZpZTBIdVpRU2dQZ2pSNGhReHRB?=
 =?utf-8?B?STZrWnlSeEI3Vkw1SGM3Q2Z1YVNOMC9ab3N2WnEwNU9neXlpdEJ6Q0xiYTRu?=
 =?utf-8?B?YjBGRzBWaXlweWtqUzl1OXphOC82Q1lOQWtpdzBteVV2bFM5bzZFZ2lCNXVw?=
 =?utf-8?B?RXAyc1NUd2dONnBMY3pDbWpCMEJIa1FaLzJoZ2tjc09QZ1liWG9rMEMwbmpQ?=
 =?utf-8?B?WVNjN3B3RFZTY0RzenRacktIbHJyS1UvTUYvRFJqS0xUbjlvSVBYbk1JTVBo?=
 =?utf-8?B?OTBPdmJxSGRJOGJkVzFwMlcyRHZmSzhwMHU0NWQxZ2NXck43Y1hwdnZWc2Ft?=
 =?utf-8?B?R3l3aG1mWUlIS0NTNlpJWXdpK01IUGhSd2NHc1p4b013K24yMEV2NzJxUDlZ?=
 =?utf-8?B?V1IyZUQ3QUlMZnVDbEpUd1BTZ0RJbDVwSUhIVDdEeUptek9FejI4QU1RV2NG?=
 =?utf-8?B?S3hOaXZZVWV4VVpLckZLRk9USlRKTFc4eWlXSWpNYmVrNU9JWWI2K3JzV2NE?=
 =?utf-8?B?S0xFbWVlWTNwdEtOSGNZVzdUbG42N1dISG5ORk00Z3l6dG1LN3lWaXRuZWVB?=
 =?utf-8?B?TjhtVmxLQUQrOHdjMzhwQm9ZTG9iT01WbU5uK29xZVVZbEQ0T3A3Z2c0V0g5?=
 =?utf-8?B?ZEdlQTBJTnNyUlRObWJCc1JrcGlRYmlkampZYTNMMVUzb3hQdlgzSXZRa3ha?=
 =?utf-8?B?d2RyTlhnSmgwNGdybWpXMWdtaUxMOW9vMVpHNEJ0Zy9RMzVUbTd1N3BkWlVn?=
 =?utf-8?B?T2VodkdBWnpjS2ozSk9mcVNJeXIxMnl4RW5obk9xUUREalVxQ292cWFMaS9M?=
 =?utf-8?B?dFVYWWJFOE5ZUUNJNzNGZDYrWGYvVHkwbmhnRlJudnFsVDlFYVI3OVpWSGRk?=
 =?utf-8?B?QnRseXNkdkJ3OVhCbURiQ1UxTEIxTnBqdmJqanphcEJxVU0xVlUxMEpxcmxU?=
 =?utf-8?Q?rrvnDqYKbVcGZS23bgCWqDXVfUufrQsf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3NVYVk0aG9VVnZ5ZlRHakVKalhkcUZ0QlpWemVNZkxxTkR1MnB3NFNWdE42?=
 =?utf-8?B?OTRxV05CQ2tWWHEyQk9nWWtEaGVyWWZKdTRpRE90NU9jZml5VkNWYko1d21Z?=
 =?utf-8?B?c0l0RGxCN09nUEZJT0VsSEJHWDRWVkFvd0Zuc0wwdU5kdThKd3NXTm1KQWNq?=
 =?utf-8?B?cmFFRmpkbld1aFNBWHI4WXh2eW4vL1dRVC92QTNDaWthZWQ3U0VZZjJ6MjIy?=
 =?utf-8?B?YUtVYnlmWXI4cVJ4TlRxdVYvMElLWEtoVWg5bWhnbHlUazQ0SHRWbmZWbjVV?=
 =?utf-8?B?Y0c1Y05sbmRuVUhCRjVyTlRXTEI2MzhDUHpZaXJxR3RvUGpvN3kyZ3k5QTVW?=
 =?utf-8?B?UU1LWEt2VEo5WlVXRXBXblJjYnJUdHgzTjkyMmpYM0xpK005dnVLcFc0YnBV?=
 =?utf-8?B?OVVENnJhL2orTStyY29JdWNjeXhJMkl4aVppcVVnaThrYXR2NjhpcWRjU0xz?=
 =?utf-8?B?NFEza3Uya0tSY3d2Tm16NXgwUkdiWElPRXl2TjNIZ1hJZGc4dzJpdTRUY2Q5?=
 =?utf-8?B?MTc4QTY4R252dWJsUllpR3pwOWV4ZUgvK3M0VWxZRTdvR2ZjTDdDc09OdjNB?=
 =?utf-8?B?SjdyK2ZOS2pJZVpWTjR0WXFVTmJ3aklsNFpEK1czQXZGQSt0U045VUY2WUxD?=
 =?utf-8?B?eVl2ZDJQbjdOc0g3aUgrN0UrSUVoTlRZeHFWRVFqSzJTMDRpT3ZqVDZlNEZt?=
 =?utf-8?B?eVpjM2JJeWQ0ZzkxZjB1dWd5dTFsdUxSaGROS3REblB4YmVhWGNHWWNuMHIz?=
 =?utf-8?B?NUU3a09DV1ZKTG04UzBWYTYwalZPbnJMc01PTnpaajNka1RTYithUHZVbFgr?=
 =?utf-8?B?eVlxdkhHN0ltZ2ZtMGRMNEdMcFNFdzdwTGZyRlVYQkhSMUhmUkovR3BvdUNn?=
 =?utf-8?B?dzVNWTcvK3lQd3ViazNDQlRjVmR2R3kxSEQvUXY2dllRVUlBMk1QajlkLzA4?=
 =?utf-8?B?REpSbHJBR0p4dC9mZ2o4QWp3NUxQekxpOWI4SXlXTFpEQndTUkk0L2lwdTN0?=
 =?utf-8?B?emNiS0pNTS9pd3hPQUNFTXJMWkVVQjZKV1ZKOGtoNmpVbEpxYXBwTnliSFBV?=
 =?utf-8?B?Nno0emY4NEhBdlA5K3c5VSs2SzNKZE5BMHRXUU9jdjlxUTBBT0hrZDNuck43?=
 =?utf-8?B?cXZ5YkpMcnNHTCtLbW5tc0NGc0xGOTZOOTZFWXE2MkhZandpR0ZQd011a1lm?=
 =?utf-8?B?NzR1emlKNllBcHlpQUxRZE9rcXd3SWFvMXBsSnpvOXhBblJEQzl4MzgvWHdj?=
 =?utf-8?B?WTV2ZWQzVFhhL2NoR0JpZTJuZ3B1RFd6S1g1cE5YZjIrTEpzOWRvL1pyOUtw?=
 =?utf-8?B?YjRld25pTlJGdkROMDdiK1E0ZTdmSVBYdXgzOXNsNFFQVGtvbUdwTmtUZUcv?=
 =?utf-8?B?TDM3cmVEQkt4WkgvQkZOeDFTaERNcFczb1RLWmhzYWVkQUtEWXhDRTRqcSsy?=
 =?utf-8?B?VFRJNXVOSHlNV0JIZzlDRHA4SW5CVWkvaGxQbEVXQVRRS0wzV3Z6YjRDNjNL?=
 =?utf-8?B?YTV5eERaYjNiaVFxOHBIaXpsVGFvTDdkYjZ1czVySkdHcFFLdHFWKzlXYyt6?=
 =?utf-8?B?bGhseFhOQ2RZWHN0YXdHMUpqaDA2am1ZZFNxVE56SjhvbS9qcXJjR0IzazBO?=
 =?utf-8?B?OUpTQ0FHMXlpV0lKUUJBOHhVOXpkY0xJTG82MWNCUVJSOWxvdWt1d2hTMlkx?=
 =?utf-8?B?S3RhWnUwaEFZRU9RTXVQNkVwK1g3VDVPZk9UdTBRMnF4UHcrWGJIL3kvWjhB?=
 =?utf-8?B?WVhUeDBEdTl4Qzc2WndZc0NLWGJmaG00dngvQ3VCM2l1eThWUHFyQk1UaUtC?=
 =?utf-8?B?K2NpaWU3VXo4eHpLYVk0LzRySHF0OFo2bTBKVElha0xkbTR4MVVTamNRbXFZ?=
 =?utf-8?B?V05yOGxGUVZQSTBJQnA0M2hjZ3JKZmpzYkg5YXIwTHlBVnN3RUd4UWhqelJR?=
 =?utf-8?B?Sm1SQndYVGRaV0lMRW9QWVdySXRTcFUxZldxSmNQUEd4NC9JOFZrTlNuYnc2?=
 =?utf-8?B?VU9GeEk1MWlzbXhpZ0tQSzZOd3FvV2tyb1lCWFBxVUFKZWs3T1pLeWpFSVlk?=
 =?utf-8?B?SVluUFV6QVROdElUWmZsdGNkaUZQQ1dlU2xaa2J1amlhL2kxdkNnRVA3Nk4y?=
 =?utf-8?B?RzNudkU0eVVIVDM0eGlyaWZLMERIWXNVY1hER1Q1aThCVkJndXBLSU5jUjZ6?=
 =?utf-8?B?ZUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c5b4b8-9353-46ba-2278-08de26133c47
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 19:55:19.3056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UVi9Avflgf9SfSsWMVN0JJxrHk6cQQEeBc7p5q/Y0dRFMSu1YyphvQDyN3AfbOkh6d6n/L4FDE0+/gyjOm+lNm1gp7q3ESpgxFGEhFHBe7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8562
X-OriginatorOrg: intel.com

On 11/13/2025 4:36 PM, Paolo Bonzini wrote:
> Remove all duplicate handling of register operands, including picking
> the right register class and fetching it, by extracting a new function
> that can be used for both REG and MODRM operands.
> 
> Centralize setting op->orig_val = op->val in fetch_register_operand()
> as well.
> 
> No functional change intended.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Looks like a very nice refactoring to me:

   Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>

