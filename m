Return-Path: <kvm+bounces-7501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1895A842D81
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 21:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DC271C22235
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F163671B43;
	Tue, 30 Jan 2024 20:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dQ2jO34F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA1771B2D;
	Tue, 30 Jan 2024 20:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=134.134.136.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706645272; cv=fail; b=cJa+5Ujl8aQFqZsXA+L49F6/NoQVwXcPtnesLUeg2JtwI0K8vzKpf4MwjG9zBI98SnQWNjjBHULte/n2Lyl0XSLNJ2vzYXE615TL0wwewxQEKmSbnFo5q+5eUYioPQ/o5BtxgBpKy0JCNXygzfEz6z42x5ifzbjYFjwsFdugNVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706645272; c=relaxed/simple;
	bh=TxmhotWvEuK9OSsyQr66IBvFI+o067igLXniRvTcuv0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Th2jTWcB1MpCCMbb5NH8squvZL53YUit05vRPqEPiKl56TAZPZTKHwY+VvB9Da/4g2OCjactWl3s3buggiQlr5WpawfzeYwPWFTFI7SEkYDnSU4vE3UhmTFZTbQ7v9gbLYxOMLf+f2h0tgd62tB/+dSZ1Kpv2cG+XcJZeZiIe5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dQ2jO34F; arc=fail smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706645270; x=1738181270;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TxmhotWvEuK9OSsyQr66IBvFI+o067igLXniRvTcuv0=;
  b=dQ2jO34FynBPh3siJT+Cn0molod79B5gpJyLrw/afOzy8iwbldwlFfBI
   H//KVJn8B3RsU6fyts1I1uxlkAqqfK3GljKJc35XRrqtQMSAkMVn1Lvpx
   5S2g1uJ8Flb/9PN644EhvvEpecXqR/y+y/pkpmITSLcPfjOTkPuOGWP/9
   Zz2XDj0xROOpQMNyjI5nD6OdPkABGgoXLkrFGqRbmtFRAR2fbGwy4JM72
   k712KpFxAtxS6EV9UXNUIF5LPwKXYTK057hobMVN+ehA0+sx2EVgI1tMI
   BQxnVJZI3Nj0MEdbUUUszHExpCu8aeKluT4Kx1++dKtjG1pu6ymLbY1+w
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="393839992"
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="393839992"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 12:07:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="3800243"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jan 2024 12:07:49 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 12:07:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Jan 2024 12:07:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Jan 2024 12:07:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1gNag/vXDK5fsli+zo4SCRqkxrk+B9jqnrplIqS9v5gjAkd6W4x/g2fKsCu97y6jQJR4W6r79Lpcq88qCsL7mHhLcbsHetZteTR8QcVEWT3e+aO1fMzkoDGJJwDuU4vyN32wXjnHGuE73jgRAlzKbL3iJfh4d+lRZ0yaH5KNqq0qxkJzmgBdPDNvuda1P5sIMaWgA13OwxKy8/1LitKRA6a3efmrVPfrW3IIYpUYnO8NQSfRB1S7Vb7G5+qDLD6EDdqxn1R/LRPWo1Pks17hAUzMFFeMm+nPC6k6wfNj/AnT0CIP6Uw+HriWs3yQIyyUZYdyY8yMEXxrCNg/zXAbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7x9jQguGnC0d8rB2KNidtEllyxI2w1PCnRJqahXsTyA=;
 b=lsFkTxuXIph2SLP7V58HeilJHdIucOBlP6Lc9resypjejls0AmbZnkgSn41Pu4vR28JT7AiaIUuCoXbdYbFxlsE7Ub0XtGCIRRXzn1usZj+qZV+usq62zrIjebwgZuLAloHUpKJqjKwRNPDLiTwrBPPvIg+PlNSAgHK7r/Vc4MHjiiQ4clO5WnRtWOzdR5UACPHg3qGf+zlxP4RqA06oX8jb6NjUorSRNmqr8uWji6mjBYdG4L+S1I6sb+CsfT0ez8mMZNlYugH2VHeiFTlcVHn6PTcn7wNfYrT0jlt2yUJSStRfAyjP5xu/SfnLWQDxzj3iCR8vm69PQVX/m0lg3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by SA2PR11MB4985.namprd11.prod.outlook.com (2603:10b6:806:111::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.31; Tue, 30 Jan
 2024 20:07:44 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::ac43:edc7:c519:73c1]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::ac43:edc7:c519:73c1%7]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 20:07:44 +0000
Message-ID: <e78d535c-172a-42d2-a946-d648f6b7259e@intel.com>
Date: Tue, 30 Jan 2024 21:07:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86: nSVM/nVMX: Fix handling triple fault on RSM
 instruction
To: Yunhong Jiang <yunhong.jiang@linux.intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <mlevitsk@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <dedekind1@gmail.com>,
	<yuan.yao@intel.com>, Zheyu Ma <zheyuma97@gmail.com>
References: <20240123001555.4168188-1-michal.wilczynski@intel.com>
 <20240125005710.GA8443@yjiang5-mobl.amr.corp.intel.com>
Content-Language: en-US
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20240125005710.GA8443@yjiang5-mobl.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR06CA0177.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::34) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|SA2PR11MB4985:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ee8e3a7-f01b-4f48-09a7-08dc21cf1f3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IRhwENTk8gWBisvXQLQP9IbnudbccFQQRUFZD/pWnoRlul+FW+GqPvB2zHO62t+HTAYdWdWnr0UCE+RhXd+/I99yQmkmKMWvehXGMfRcdLlC4GlqRpeOmMj1SmOgaWaxKYFm7ylxms7yTy/z1DpqwUKgAZzdyad08e3C9gzMEJ1+dP8k143CZ/acy+UnXRQ62WSOE/LQ71ZfahDds+wuLGb4FLeGRpqpRZWRrksmrHx6GsLe0B1uAgJG18nzeDxZNrn3WhoN6idSXKNwiWZRR9f5izbAxKjaPNeesvnkP+9HzQfqUkTb1qZstEBlXbgobPYl4Xg9eMdPPwZt0RAkLO17t4deUXH38GuTQY1euwex8TlTN0/KpNKkR1JhbsCzic5MoS6yJu/YM5tn0A0uGKlAgcDwUbYGjKrnRPsoo5EUpR7qlz9CqA/9jh4nivAB/u+oTLKouqtEO14NpRM0oqGkJazpnp5k2s3FdpWC0K1ajUos6uJw/vEIAi6/opERF8rRoom0EpOWEn19CRypuRC586Z/1OUsp9y9GqFFS+f2n9slXvF52CKmE8Lms86omlUfJReW/qoqJ9AXNWZsPiL7GemwLifq/DIQ/vuaIo5de9k4he7LKmQMCn4yYa2rm7nFZmNXwQ1tRf0/PS1vcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(136003)(346002)(366004)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(41300700001)(2906002)(5660300002)(36756003)(7416002)(66476007)(66556008)(31696002)(66946007)(6916009)(86362001)(6506007)(2616005)(316002)(6512007)(38100700002)(6666004)(6486002)(53546011)(478600001)(8936002)(26005)(82960400001)(4326008)(8676002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1hGNEJOczIwd212dDJnVzdyOVU2SG5WNkVGR0p3d1FUTUV3Z3ZGUTYxMHRl?=
 =?utf-8?B?ZGxuZzY3YzQ0SUdvaElTcE1DM0lmbFljRHcxYzU1U2RRYzdLUzBMMmFsWkpo?=
 =?utf-8?B?RldsYlp4cVJJd25CcFE1ZXNrajM5bTRlRE5HUlhFRFNBVFNoOUFhNktBcG9s?=
 =?utf-8?B?VlVabW9sL2xzcnhaNkJiWk4xZ1k4SHBOaGtiY1owQmdleFVPN3ZxeXovOVlt?=
 =?utf-8?B?a2xGTENZQ3VXRXhHZUlIMEtNZnJGSktYVGZ1bTlTRFp4dFR6cWh0ZytBSGEw?=
 =?utf-8?B?T05ieU50NVlxNlJWRUs5OXlwbER4TjRKcVhyR1JYTGdIVXUzUWRvMitXUCtp?=
 =?utf-8?B?ZXpsSlB0TFNpdys3dCtFZFZFYitXZjRpUS9vM3FiUG5TTkl5ajh4cFBOT3dY?=
 =?utf-8?B?ZXQ5VzVZZTk2dUNHMGxnSTFuVTd4R1EwT2tnK0lvcUVIM1RGcDMvdEtFZURN?=
 =?utf-8?B?MWpxbExxbTlNeE1IRVZFOTNYU1hOdVJDeEtzT1NYWXVJRXdTYzB5Wm5RL3o3?=
 =?utf-8?B?OU5LWWlXUHlUaGs3d1NNNm0rR3Mra2owSGFsaEppbkxRUXVGNmJrMnljM0xa?=
 =?utf-8?B?enJ1OXNla3dIai9pUms5d0RFM2VkdWxDcTdCWTlrdjh3bWVoUDErT0RYRkhs?=
 =?utf-8?B?cVpBdmpGZWZPTGwwcUc4SGpkZUJuZUJUajVYNXk3UVVLMXZYTGIxd2pMK1BK?=
 =?utf-8?B?cXhIT0g1UUtxeEhzSmZYOGJYRUMrOHRHTUJDSEUzRkRKR1FNRkhEU2x0MzRl?=
 =?utf-8?B?YWwyZ3crOVhmTU5lUTZWaTkxM1BZV094WDR3WDFQOE9QaTBKQ3BBS0JiSFNX?=
 =?utf-8?B?RjB3MjR6R1NTaEo3ZXdwU21sTDRGdjVOejgxdGRqK0JwYVdvUS9YR3pJNU5J?=
 =?utf-8?B?Q2VIQ2NFUFpjVU81bHZtTGc0RFpXTXlzWWhld0RZbXVFM0cyUmVaOFBlZE1s?=
 =?utf-8?B?R2xmRVFPQzE2SFZaS2Q2UFA3RUR2aGRNb1Y1eTNld0ZhM2xIYklublJzU1lS?=
 =?utf-8?B?S0F5cHZnRG5rWnpYem9aSHo4cDdJNDkrcThuUDdWMWg2UFhqNXF1R1EzTDdQ?=
 =?utf-8?B?N0lVZEowL09zQVZDOW5QQlRZcFZ2Y2FORFYzc20vOCtWLzVmWEswMGk5NHJq?=
 =?utf-8?B?dEtmMDBMVEsrQkc0WHpIY2o2VVlsRmRoNFkzVzg4OFVrWnQ5eE55N2U4ZFc1?=
 =?utf-8?B?LyttYUszMS9IL0toTHc1VXBNdnY1OStvdkFCdHdORDd5bkdMNStGSjh3OGI0?=
 =?utf-8?B?ZVpjcW8vU0g2cC9Id0g4UU81cHROeEtqdjd2R1hMR000ZWFQc3BQNHhubkps?=
 =?utf-8?B?cUZER013TWxpMXBTTFZudEd6TjBHVHNUY2lJTVc0VjNSVTB5SG1XNCtuckxu?=
 =?utf-8?B?YUovcjhFbmxyVUpJUFdzZk1GMEtRdUVyaE5MZ29zQVZQTHp2dkh3dDlrWjB6?=
 =?utf-8?B?T1ZTa2Z1R29VcWF4S0xBUk1hUklIUUp0Z0Jkc0xMU2ZGWHZKTVRNRXVhWC84?=
 =?utf-8?B?YXJUVVRrK3Axd3h3d3M1Q2cvbWpMdWwwbEFURWxUL1Q5Wi9BM2hkKzVEM3h3?=
 =?utf-8?B?eXVUQWZ6OXAwUjlqRmR1UC9XTlNFWERuSW1JWFJSbStQZ0F6eWZHRVM5bUNh?=
 =?utf-8?B?UjlPRko0SS85eGlWdlpUcUVsZEwrKyszU3pkVU45dDZISWVjeWw3MmVjTEox?=
 =?utf-8?B?SUdTUkNPREVMMU4wY2wydnZtSmxiWFZiSzhaSEQ1VEdObjNFaU82Z0IrcE5n?=
 =?utf-8?B?YkdMWlJWellQdWZGU0VheVdzak9GQmo2cnpuQ0RHMndjNmk3bTZaZnZCUDJw?=
 =?utf-8?B?UjdYWmlvSGtvU2JUVTVCYzNYSVVvZmlzbWhxR1JVd1crZ3VxMGsrb253TC9z?=
 =?utf-8?B?M0lBVGx5VzVHOGJXb1ZNWGtIWjZZcUdSN3NnRFRkOTNZUUE1UU1vWVBLSlZV?=
 =?utf-8?B?aGRxbUxuMFBOVm5NS0IrYVUrNUk5WHYwR3RJRGZlTVpOVlkweElJQ1lVRDcy?=
 =?utf-8?B?c3RuWjkwRWxMMTFsZE1tbkVZQ0swQkxqZ0Vvb09kQXhhcnQ4amdaYkRXd2Nn?=
 =?utf-8?B?ckRDOEZMY3NQT2xXeFRmZjkvd1o1Q2pRazBXL0d2YzZyNmZ1d0t5bEFuenEy?=
 =?utf-8?B?NGJOQjhINFNJVHlSWS9mMlBscy9rWDFuQzkvMitWT0tISVRTM0Yvb29Ockhp?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee8e3a7-f01b-4f48-09a7-08dc21cf1f3e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 20:07:44.8433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mVZxGgN/UEAEQzzZ/jm6FLeWZkdpRR+5+nNEPu7WmMbeAh7msiyzpJUqpK5G9/pcZO4DU3TcWT8TEDLk8ngiGR47lJLNcmm0TFC5xJD9x0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4985
X-OriginatorOrg: intel.com



On 1/25/2024 1:57 AM, Yunhong Jiang wrote:
> On Tue, Jan 23, 2024 at 02:15:55AM +0200, Michal Wilczynski wrote:
>> To resolve this, introduce a new emulator flag indicating the need for
>> HW VM-Enter to complete emulating RSM. Based on this flag, a decision can
>> be made in vendor-specific triple fault handlers about whether
>> nested_pending_run needs to be cleared.
> Would it be ok to move the followed emulator_leave_smm() code into
> vmx_leave_smm, before setting nested_run_pending bit? It avoids changing
> the generic emulator code.
> 
> #ifdef CONFIG_X86_64
>         if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
>                 return rsm_load_state_64(ctxt, &smram.smram64);
>         else
> #endif
>                 return rsm_load_state_32(ctxt, &smram.smram32);
> 
> --jyh
> 

Moving rsm_load_state_* to the vendor structs would be architecturally
incorrect as vendor callbacks should only do vendor specific stuff, and
recovering state from SMRAM is VMX/SVM independent, and should be kept
that way.

nested_pending_run is unfortunately buried in vendor-specific structs so
it's zeroeing has to be done in vendor specific callbacks.

The way I structured this fix is hopefully in line with the discussion
under v1 of this patch, where Sean gave some background on the code and
proposed ways to fix.

Thanks for your input !
Michał


