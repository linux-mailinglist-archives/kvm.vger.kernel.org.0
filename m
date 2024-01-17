Return-Path: <kvm+bounces-6370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE2F82FE79
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 02:42:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5DBD1F26154
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 01:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CE2E1864;
	Wed, 17 Jan 2024 01:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WeLFwLFn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D15C10E9;
	Wed, 17 Jan 2024 01:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705455727; cv=fail; b=r3ndR81KcudwrvyN6CCRMZQhJP09hNEJhTOijAkb7yawbSEH877yXNJDxnlVnqRwCYjspS9WevjqOcdLY6WL8+H6n7+ieZE/9iH2hA+dpkJ53yVzvCr0U95a5dRR58znEoW4XDiyJgvbB5lozxJd+hHSmLdPTYQ08GpmwzUe40k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705455727; c=relaxed/simple;
	bh=LbVotSwg08U4HUpBd6wN5Dr8fvuJwkEl1crpqLGTmfY=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 Message-ID:Date:User-Agent:Subject:Content-Language:To:CC:
	 References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=u0t+CSd/dbnfdY9BtvO+OiE3qmEE+5MV7UcQDsABItHpVvNPQ/yEmkgogsw1eEtlb4mJD6lkCfo9D6DafFO7tzVGM7EYqH/bJtceaJta/Ym5q1yvEpy8OSQNIE9hl3Djl/eHZ1w+of61BRmDcNui7XJzZFSJGHbgZL06s9CA2sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WeLFwLFn; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705455725; x=1736991725;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LbVotSwg08U4HUpBd6wN5Dr8fvuJwkEl1crpqLGTmfY=;
  b=WeLFwLFnLg2pi1k7ltekbfSR1drtuKXuMDVgoD9BWg8YpT47hhLsjj6p
   2vXoc2yWG5PPlsXGU5KBjexJO7eEgy4+yQsM3BuYNEktQmC+MwPlSAIqJ
   i6oyNBHfVut1N6vctNTiQ2+Kf9627hzIN5yid/k5vPILWHF1x6nRaAr4g
   fyfGDsalNVWsX9GcGzQDj/aEe1e8vaoJemzqEOrSTPsa56Si8uoxgLgOK
   MMHMRhiPmw6AeugVDtVhBQ63AWGsWTI9VBE4XQ6Qp4SZ9GlDpSXpyJrZc
   AcGrnVa//jIOAt1R0o6LEBHOc/zm9DCStAkdjexn7N4bhkIsuzOUSjxKE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="6747468"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="6747468"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 17:42:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="784338777"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="784338777"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2024 17:42:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 17:42:03 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Jan 2024 17:42:03 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Jan 2024 17:42:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mm/+n9HprEQ0VPvqSGQnc+//jZ54LPCO3NGJCAA3GrRMISYGrzueSNh9L/tzUM8M0gevxYthdhN1lXg/nQzSukmSA5w3wqyZX2ZtGkOEuleqQAe152gmaaP43nK+jU7xzGgHfxLGb5WQoK8sW6R1QVvu+eHQQAwnvPovyrXqB6JtxUTFCVOuJlM1KyD1hmHgD6ScrpMBsdcy2e4v3C04ZJhZFy9i/a5jflOJeq/uvwavy4979/9sTdb3O0TSLZDuIiBe6WKAgo324EiMJpx5t1f86bnPP1PZxXRQkPTG8Qbq40nc9vRi9J3jkOIE1DqH99429dgIARsfMjWG05/jaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPzj6OVpREmceP90iyzEdrdUJYGvVdVQONNGIEysQ08=;
 b=eYRgm/ZWN1V7lreUz83hcT2qJroWi6+yzsW+e6LldJyq7dkTCCyBDsA/UEyvkmRvc2MIvAV2X+0V5qDJJduhBVYPlmWll/4HQczthQGZNJ0ifJ52VWZ9acda+MMWdKtcUoqDX1mAIdTWjxc1H6QNU55sPIy4wQk/WxyYxvUPhAziJsUrzd+S5qWq1ikoQLTrRxJ2wijOzSLwSekiefz3vkuLDLAlSo81HVFjaVGgoW2YQs44snnHd7e2v5VtN8p6UW4d44cujsAcLULmCBFGmpuIw40wRn7em/4C+vuNmU4EQNt1tHf/4pVhMM4wLVYXgJb8xuUSPKu3aR//MFk3tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH0PR11MB5412.namprd11.prod.outlook.com (2603:10b6:610:d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.23; Wed, 17 Jan
 2024 01:41:55 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7181.022; Wed, 17 Jan 2024
 01:41:55 +0000
Message-ID: <ee2c5c91-68bd-4f78-aafc-c14093f05342@intel.com>
Date: Wed, 17 Jan 2024 09:41:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 22/26] KVM: VMX: Set up interception for CET MSRs
Content-Language: en-US
To: Yuan Yao <yuan.yao@linux.intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-23-weijiang.yang@intel.com>
 <20240115095854.s4smn4ppfjfa2q2z@yy-desk-7060>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240115095854.s4smn4ppfjfa2q2z@yy-desk-7060>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0239.apcprd06.prod.outlook.com
 (2603:1096:4:ac::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH0PR11MB5412:EE_
X-MS-Office365-Filtering-Correlation-Id: 7705458f-bab5-47d6-a74c-08dc16fd7c7c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kKOkDf+LFEAnhp2VYcKujZBxHBGyxDCmigS1151VO3BDI6Zz3j6k9WNiFvfkLhsg0w/hZz7DY0dohZlxrjpKxhSbhgxgTJsBJPUyglQiURzem91uD6jJHgbIAUAPExg4F6M784vWJmNxRw049ziTqpDW3/xdLgwKS1P78FcN3SEGGVB14poRCgeJa9un9IgNDgpFVfwxGZsWlFyWlvvQDtE6AjTXG9sxdmtVuY6wvnbZVg/F+epy106yfi/v56CNfQIcxPd2/NYRRPfHjETor/Sd9y2BzMOpUPwJ4HF8z/xMSPgPtWsi2caRs+4Qx5x43OpAX1QGNRjJFjZB1jNTS6mAkkBgNFiUdfPhZg4AUR1z5CMHZECBpjurrGWbCVv53Zu7fk9mBHdJ6fOYnC+X8Yp7hMrq9TONLLQnp8ewZnf4lzLkl85CxmbXJW0M9IzBIy6K5cX44Oko7xdBVAnSVzakSJ0UV1dJ0SJV9EbkJKBTcmMoM4LJiQ1dyV32tYznGFKwJemrBrOrS4mVNFJGxQp/M1hmyagrhP62Z3dy8ytal+H14S8mWMyfB4Qx/ObinD7hzP7NuFiU5uRgy3ZallHsBeG2oJivb35dbwSN6MOWcQAVparFUbCXfBJocLjjLfGK37kvkuaoaKvhlRwQDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(136003)(376002)(346002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(4326008)(26005)(8676002)(66476007)(66556008)(2906002)(5660300002)(8936002)(6486002)(2616005)(36756003)(86362001)(31696002)(66946007)(316002)(6916009)(82960400001)(31686004)(6506007)(53546011)(6666004)(6512007)(478600001)(41300700001)(38100700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkR1Q3lFazlQVjg1YXF5VmRiSFdzVHE2aW1UNUZ0MkEzdzllczV2RFpqVUxL?=
 =?utf-8?B?d3hXS1NOYkp5aS9qak9wVkFTU2xvNmhWZGI3UkNCZjR2SmFFN1pRbWIwS29u?=
 =?utf-8?B?SFV5RWpDT1hiYWlqK1l2S3M3OVdROGNGaTZ1dktXbmk5Ynd1RC9ZUGlMUVhp?=
 =?utf-8?B?VkVmRFNEUW1QSklQR1B2MHpPZEwrdGpSb3JsM24zMG5QNGs0cldpdlB5WXlO?=
 =?utf-8?B?QmVuRWZVNG9hU09rRXBYb3JOeTNaRUlzbUVuQUZXbCtVcjE5K1JKazNEZm5q?=
 =?utf-8?B?blVlQ0hBQWw2Sy9rWU9qOVVqRCt2elFneWJtZTNmakVNbWNnN25oUEtzZjE5?=
 =?utf-8?B?ZUhSMjdoNFp6VG9QK0JnVzJDUFhZYkp1Mm03djhaWUpPVHhHMWVCUFNibnl1?=
 =?utf-8?B?WnM2YzREcGZWRWoyMHhzNGE1bWc0MlBLM0k1Vm1tSEplYkEydE80ZWoyRU8y?=
 =?utf-8?B?anNxclgwMVJYY2RsWTdqWG4vMVlqbVQ0aHlZSm1qNEJFeFp6bW1uSFZabUJW?=
 =?utf-8?B?S3piZDZzNHR0S0JuclpoMzRocUFPc3IzaS9hWG9GZ29KNUR2T3AxNk4rSnIz?=
 =?utf-8?B?amI4OGkxSVExTWEzT01GMGhXdDlMeURqSTVYZmVUVk1vSE1JamYyOWxJYmlM?=
 =?utf-8?B?SEpOcDgwRHlSNkdhUWpCV0xNR1ZNQmFJaEh6NEF5M1VEQjRzN0tBdTExTmdM?=
 =?utf-8?B?YUIzbU93dmFGWmRMbnlKNDdIVUVGOVNCVnJxNGdvejN6TmhGK001eWlhVXpG?=
 =?utf-8?B?RWxidkhzODhoTTlya2lwV2pVVlpkWTJGQmplVFNkNEFYL3lQWERZbFY5cC9n?=
 =?utf-8?B?Mlh3MTMvZzkzM2dFejMvSWtKK1BBcDcyZEEwdHBDVlZPTVNxVURwSUdwUmYr?=
 =?utf-8?B?WDEzY24rOHFsc1VmYVlVZmwzVk1aQStzR3RNREdlSWFad095WTJNL1JpSTVM?=
 =?utf-8?B?eG53TzVMbVR5R0lDRXVUMHVyYnpvcklZQ2xqSGErSTVyTjR0UVAvYlFDL3Ux?=
 =?utf-8?B?emxtMEN1bm45UFpvNjVVa0VFQWphcUZPbTVLYVpyb3BvaXlPNGdlUWhzNWQv?=
 =?utf-8?B?V25xUVdtRi9UK3Nja3BOTjZwK1pJdnlEWGFXMEQyKzFVT0srOVlZT05yWjJi?=
 =?utf-8?B?dGFKdFR5ekRnUnY4YkpVYXkrbHJIQ3grN21CQmlranYwMnVlMHJyUDVWeURM?=
 =?utf-8?B?aThhQzduWS8vaWt5VHVFeitoZk9vL2x3VmJXSUd4T09aTFhyTVBXOEFtb0hh?=
 =?utf-8?B?YkxVYUpZUFVwN0tFVXE2NDRIS3FWR0crSlFacUVhcUFTTWkxeFk4QVBhR2JH?=
 =?utf-8?B?Y3BMUWZhZWdkS3hDZzZXcHV1UDNRYXFPTGtxcGJqUnlFWlpYSjRBaEEwMDg3?=
 =?utf-8?B?NG5ZVGk2c3lYbldqZGF5WWVJR3BKWHRKZ0pPL1NUdlZNdTZNdXZ5OWFzUXdL?=
 =?utf-8?B?Mlp0VmJCUTN4WFlXaE9jY3RFRjMrSXRBbGR0eWhLMCtWeUpjdi9SSXNsZzFn?=
 =?utf-8?B?RnlaZ2ZrZzBsZER0cTRDMkMzNVltcGc0VDdjTTdUcmNSbzFERlJQUjFqNzhU?=
 =?utf-8?B?Si9lSjNWZ2djTDJ2QmtaNWJEUEs1MGFYY1lGUnVUbkdCMi8wRTcvKzJYMzVQ?=
 =?utf-8?B?V2h2akkxVkM3cEI5RFY3TlYvTWVrbFd3TG80cjVwYUxubm40VEFlOUJRYzFL?=
 =?utf-8?B?RW9mUVlyTmJsM2dyZXFFanloY2xxNWF2MU1wZmJOMEgvajM4YXFMblVxaHpG?=
 =?utf-8?B?V28wSkx6VUljNVhKaVluOVlCTnBTNGI5blpYVUxwY1lQRG9WdS9jMzhsOG9L?=
 =?utf-8?B?dWlIU3FmOGt1SDdGcUlsd1pnMlpkNWdpRDljVTRzdkloZXFrTlNGQjFSdCtS?=
 =?utf-8?B?bFpHdkx4NEdUb1E5dGI0YWZSN0VKRm9wd0lOYWFiZWlvZHVXTGdxVEtzL2w4?=
 =?utf-8?B?VXR5NnlLWndUQUF4eHFwQ0taeEc0M3hORU80cjhlRXdyQjhNK3FjMjVSNngr?=
 =?utf-8?B?VzdQd2xqazEzdmJqTjIrNWxzQVhpQjFpZ2NlOFVya0JyM0FDMnBuaW0yTFhB?=
 =?utf-8?B?R0JZNWV3UWJXU0tOYk14eWpRNy9FZzJ3cG5FbktxMHRSbE1wTVFrazlzai8v?=
 =?utf-8?B?cFE3ajR5S3kxTXRqMXVubk9pS3N4U0tJTTc2Nzk5MzdjSFFBcTBEc1VGYjd3?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7705458f-bab5-47d6-a74c-08dc16fd7c7c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 01:41:55.4152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DEoHDtX+Ljjg0p2fhPWI0okjgrlkoZFkcaRuQj3Z47mc7evkBgbR/n1Yp0eKpd/1C3Im3JHmq97NN5XG4UFruw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5412
X-OriginatorOrg: intel.com

On 1/15/2024 5:58 PM, Yuan Yao wrote:
> On Thu, Dec 21, 2023 at 09:02:35AM -0500, Yang Weijiang wrote:
>> Enable/disable CET MSRs interception per associated feature configuration.
>> Shadow Stack feature requires all CET MSRs passed through to guest to make
>> it supported in user and supervisor mode while IBT feature only depends on
>> MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
>>
>> Note, this MSR design introduced an architectural limitation of SHSTK and
>> IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
>> to guest from architectual perspective since IBT relies on subset of SHSTK
>> relevant MSRs.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 064a5fe87948..08058b182893 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -692,6 +692,10 @@ static bool is_valid_passthrough_msr(u32 msr)
>>   	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>>   		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
>>   		return true;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_S_CET:
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> +		return true;
>>   	}
>>
>>   	r = possible_passthrough_msr_slot(msr) != -ENOENT;
>> @@ -7767,6 +7771,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>>   		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>>   }
>>
>> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>> +{
>> +	bool incpt;
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>> +
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
> Looks this leading to MSR_IA32_INT_SSP_TAB not intercepted
> after below steps:
>
> Step 1. User space set cpuid w/  X86_FEATURE_LM, w/  SHSTK.
> Step 2. User space set cpuid w/o X86_FEATURE_LM, w/o SHSTK.
>
> Then MSR_IA32_INT_SSP_TAB won't be intercepted even w/o SHSTK
> on guest cpuid, will this lead to inconsistency when do
> rdmsr(MSR_IA32_INT_SSP_TAB) from guest in this scenario ?

Yes, theoretically it's possible, how about changing it as below?

vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
			  MSR_TYPE_RW,
			  incpt | !guest_cpuid_has(vcpu, X86_FEATURE_LM));

>
>> +			vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>> +						  MSR_TYPE_RW, incpt);
>> +		if (!incpt)
>> +			return;
>> +	}
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
>> +
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +	}
>> +}
>> +
>>   static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   {
>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> @@ -7845,6 +7885,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>
>>   	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>>   	vmx_update_exception_bitmap(vcpu);
>> +
>> +	vmx_update_intercept_for_cet_msr(vcpu);
>>   }
>>
>>   static u64 vmx_get_perf_capabilities(void)
>> --
>> 2.39.3
>>
>>


