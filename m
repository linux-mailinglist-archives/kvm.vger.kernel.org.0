Return-Path: <kvm+bounces-61944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98BE8C2F6A9
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 07:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38A101896489
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 06:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6BD299AA3;
	Tue,  4 Nov 2025 06:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jqjr38se"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7AC1B87EB;
	Tue,  4 Nov 2025 06:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762236451; cv=fail; b=kpjt/mcsK5OuYoh9xDvHD1CmH1q203Db8ouGPaFffCFsUmJ0fWw+HIN6G3O9j1GK8P/PsFDLohXD7EjEKeKaQwQXh72v3CO/8G9aa3zDEImWtw/C9bt6IUauYUg27doZb7DCIEgKb11NDChyY1FprcKg2xek92j/qJ0OGfTeSe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762236451; c=relaxed/simple;
	bh=jEZnekfTsQjoA0QFXtAen8IU/DyG8IbFIMJ/jwgt0HM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VOguHfxatbziE2bqpT1AIXYheK5ISpypfGu5SfGHHES9P/SM7Qlu8sDcz8yRI+7+VMPNYLxZmCqp5vLf9LgAy9PGFM3Zf2XyC3lJ1v9/pJe192TCHbHjWSV8BtFrWA42iusGDFaNIrjoinADVAS8ZYs9XI6d+Z5UhYLf+7UgJP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jqjr38se; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762236450; x=1793772450;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jEZnekfTsQjoA0QFXtAen8IU/DyG8IbFIMJ/jwgt0HM=;
  b=Jqjr38seV/emvV+mCn1u7R5y8phoqOizSP7xL+mQTEonjiFXPp3wLQJ0
   wb28ZE3pKQJBnUbrlE7/G5KwTAsD4o7sjnjVj89W3S0945OGY71bwC7Tw
   SBSxAnZkDF6+pn47Q45vmt8fYAnaBAPpbfbfwU0fU15ezGA0TgoxMzoH1
   behtVB85kBalbyZGfr5UgrI08N4CbERd2hJZGFPaeREWMr/uiYphdpGM9
   uOclEDCPuUCBbF6QsZKIZQLXpQyWFp0dA2o9oOcqmJ4q7rqxfVn5fxw7n
   EAv725Ufkl2RRQmuQGACf50cMQ7Ov/KVazUVBQ0CzqW+1nEp7Q4k0I7yK
   w==;
X-CSE-ConnectionGUID: ExwtnqBFSgSqzeFEWYBP5Q==
X-CSE-MsgGUID: JAbJs3oiSLaF5JkBQHczRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="81952473"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="81952473"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 22:07:30 -0800
X-CSE-ConnectionGUID: koCDbcB5Q7COC5abHe42IQ==
X-CSE-MsgGUID: KNHYAOJdTd2Qu0x/tFXyAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="187518095"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 22:07:30 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 22:07:29 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 3 Nov 2025 22:07:29 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.47)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 22:07:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D5AjpaBPlsWtPF+yaMQO7oh8j6f8yeSzEDyHbuT8YScDFT3FWTr+5DINwFhvvY09L1TfP+GERHPylnnEo88GsA9IA3TmF+dKz3s9BYuJT7arw39YFabkzIxNhjQAghnOBWinyZCmPQxOf83EkMenMQQL85nRqd6F9D0NRQDnQQgyT5iRhIUtRl9EXvag3Xmjv5Gf4zJRPz41cLzOdlTnFuOJlkSoenSSxAVQlHaCvJcjGY4gnkF6bk5Tr2mg1by114dJa9LlnT9OKG0iRNVByZrVVMTytHGZZmK6c8XiW7iqTTxzhyxrMplrqeNyecZvkTfUz41HcQK/ak5sRBSdAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zbePZNboU+QMf41nG2XXPQCT9qYKSTiNheRQ3Cbt6AI=;
 b=Bqs21ahXNoUG5BpKU/zo3BAd3YZgI59W95hjZkfS6T+g48xMzTiPTyOgaHw7qiytR9G396HTiYRdXv4imueW24ba9AcQmV72M7DUsLEz8FOxY5kymDotmm+XJIIOqte7qZqz3Bkv4jzrAey6JKE/lGeqswTdnTn8ddUNg/uSXlBRWbPcqRLW/XIES4CpVI0uoGEkcIT1LjAFuVXYkH7NjP844u7Tl9e5VTqk6fIhLJE1i31cSLEBpF+iAFYVeQRxSCEnHK+RFaUYl0vcLlJK8UBN9wIOaRfNqc8bnij6yUlUVN79ZiSYSO7+Hd7l94VrtcaKTQC85/ahbAGFhRm9aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CYXPR11MB8756.namprd11.prod.outlook.com (2603:10b6:930:d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 06:07:27 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 06:07:27 +0000
Date: Tue, 4 Nov 2025 14:07:19 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Harden KVM against imbalanced load/put of
 guest FPU state
Message-ID: <aQmYF8jDKlzecQ6A@intel.com>
References: <20251030185802.3375059-1-seanjc@google.com>
 <20251030185802.3375059-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251030185802.3375059-3-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0042.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::11)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CYXPR11MB8756:EE_
X-MS-Office365-Filtering-Correlation-Id: 32c29ac2-b98d-40bd-bd9d-08de1b686e35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ozbqDPZMg1+4qqa6MEaXy/20jJk8b9NbT3hNl6bTOeTD+lWMcv9YvuANw/Op?=
 =?us-ascii?Q?LQcuxWakTy15FR4U5su7B+bk1K8OuKp9EwwA3zmp1O/mDAM9Be+yxNp4yoDz?=
 =?us-ascii?Q?V1XHzSOrVJCcEbcbbriHLktggzB/yLk/CJxv5aBwYNwTB++K1bjiUA+Y328/?=
 =?us-ascii?Q?mGjU5p6FJUfIwQXcIH0sYd6mIDVa4LAxC0gPgFSO6uWZDMiWyxs7Qubhf1TT?=
 =?us-ascii?Q?NV5nWn2z0GhDpVgxLw/J7+2/ZRxwUCQzOpW0+3c89PyzkXr4Z52DGLcSOzzF?=
 =?us-ascii?Q?1YeMFT8PdG2XsOz69gA8UwZzjWhyPvnWa/NkIpz0w1qrWnhNrbd11NESTEmq?=
 =?us-ascii?Q?Ep37NZr+D0NdtjEO7G9y0neUrTDNClyRLSWMVEarehC4yB+YDmIFDmehMJBI?=
 =?us-ascii?Q?xY0/ogiCxPyG7ole1ArcFv4AWBvECtc9lqs4GZYy/MM1r2RdJ8UP2vUaDHL3?=
 =?us-ascii?Q?mTDre/3Lrkue0rmDZacawVGY+HFVYhPb8enTwxOpTgmlQYNtI/aZt12mVCfY?=
 =?us-ascii?Q?80y74KTDu11ub+XYLJxKlveMNILgrjvEqwULoLU4WEZsZwzgMDEI7nRN1p8e?=
 =?us-ascii?Q?UA0VfosQyUdwCaP+FnQwc+cU0jPJX+fjhBVY+Ov0JBf1rFXGkUU50N17juAp?=
 =?us-ascii?Q?W9KTmolU9s75aegBxzF4v0khkZwvF6nMOJvPFuvGE22Tsa5gGm88h+cgE3Q0?=
 =?us-ascii?Q?FlXbRxe5+fiquwH7FV9/K8JHB/JoI0Y1bYfGPLnPm7TEC+nmyeaOWUjftmE/?=
 =?us-ascii?Q?YagU7Wt0yvDTp4U5ntoy+rDGF5LPGqmzda8S5X8gJ8z3ed3FhEkU0h0I/9dr?=
 =?us-ascii?Q?OU2eAX3Sj9UjfsyORnudMFzjOBW4z8HWPxrBSWX+dHqLuTVcOaI3Od44St4X?=
 =?us-ascii?Q?dZH4nkqaekq/879MJo6Q7LJK7LW+n7cJun6100z+hr24091lsLmDqVgHzzB2?=
 =?us-ascii?Q?kiT0MnPkrgQAah7+VLH+pfBctbVx019ea1VNEtJw8YQfZcM0PLJPe0OKYLKk?=
 =?us-ascii?Q?CAVE09q6zR95ubYZznykUcBidghITlr2mrbldfaMPkhDHUidwHyi5+kq3/Dw?=
 =?us-ascii?Q?rF4Q1bpelJULD4TsoV4A0rpG5gfqFgZ868iv/6gcrLplQHyLJSFDyzUZ8T2O?=
 =?us-ascii?Q?Ss5RLqVCx3ZdI0p//l4a+r2SjIfD8BHZgyLrDJBjikTbDkK1eCnUvyByUVNZ?=
 =?us-ascii?Q?9kund5PC+qV7+gmD46/Ew902TVWosjDE+xW2xK4TJDRyyilylQUxhWvzWwOV?=
 =?us-ascii?Q?sP0/fTJrSKRow/h24CgtVo7ohl1OEA8U3IKEjoB2O5u8mJakBaMa6ZNBNEO0?=
 =?us-ascii?Q?BYCyOr1Y7tBbzTe5OCWzWWtcQzAopYXLIOp+tQI50CLvM9/VfI9sVI7hqjbN?=
 =?us-ascii?Q?dlKeC3Y9IuO99kQc8vt73p+t+gEQ06Ir80aB1rXDiryfusA06KbY1E2FzC3r?=
 =?us-ascii?Q?51EQ7sYkLBAkLaQeMlzypjrHNG7Fw63r?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wKIFSVnHB/pCZfcmm2aJ/wRMD1qtYbYQRBCqEFnzjcQFJzaqRpXMHVUpokrU?=
 =?us-ascii?Q?0LQ4yJMKCkM8HXaqIfPI37p8hmofWKlgU0mWxyAahdGLiD3hVl48LkR5oerZ?=
 =?us-ascii?Q?+lQ7M1yjJpik/oMdt/TAlkdPkRz+C8ecMYbCdgLAK+MTQ0alauVbInNl9qO0?=
 =?us-ascii?Q?Haa7M6WOEYRENxcujT5eNIPAMIrTvilX8eplO++eIP9kHwjvZ89AO10W7N3Z?=
 =?us-ascii?Q?5qdrP7wRNI+xe0MSvpO0Iix3AkjZjWMqILLuEeK0pTjQxi3kqveI8KsK0uwL?=
 =?us-ascii?Q?17cjubxJPLXAsMV9zbdwzoSqKm06Tl1+SqNdTXertQYGOxdZEoyV5JT+D+hX?=
 =?us-ascii?Q?s4HZcfgqcjhUUVm4JHl+NHFZuoP/OrW9RexYotfC9vdNbSGMcfsJ9iqjIs2t?=
 =?us-ascii?Q?IWMOUqfSlnq+rzAZKIbGuvhc4nROq5ypLfge560hZPE1VsH9vT5kdOWRa2Xn?=
 =?us-ascii?Q?EEkiAxbho+EG2Mxj+iCnWl61T2lw62ypRLnduSouV68DDuVm3mAaCYeDbClk?=
 =?us-ascii?Q?ceXaw/WFLYjO76J080eeJ8REvsEB4noVz83cuc4xXuA9IcKj+m9ok3AmpZWY?=
 =?us-ascii?Q?WLxqZctl1t5hpkmfLyTisqRdcTYv/SgFEz22i0R/jnCFZGZ3QGGtwmv/vQTT?=
 =?us-ascii?Q?CyhVtu8/h0FuaK5TrF64YpTHoyJ6DGVSAivW8T+/TxuPEPiwOuQTtoCEgFZv?=
 =?us-ascii?Q?/hVG+44A024getKQlSJRAnIzlzkm+9oNoZp7ig2PFLbP9eWuxa9xK/+YEuDK?=
 =?us-ascii?Q?IkVXE0cMSkEnEHBuehEhK0rg+deZjJEBXTDXdMdnnSUQaE3ThSpkz5Flmp1j?=
 =?us-ascii?Q?PwuBsKRzDJLryHVXMtt9MsQs6LyQANo9DdFIdWvnu9LqofsqcJVdaLaMEDsz?=
 =?us-ascii?Q?Rmbp553VUCCyYIooICSUCTKrLmPf4cQWemS8bBzRjpwWcmTPd/YWnuQuFtKp?=
 =?us-ascii?Q?mjychFeiqKp7NVEa781OUqhxdW2A6IvySPM84SurTDmSSiP4M+SDjmtfD9wH?=
 =?us-ascii?Q?mVZbU269Tkxw2plgoCuCmHLwHn/zrc93/PdtWEW2tZsXvtMu7+vHmXMe3Zp7?=
 =?us-ascii?Q?kOwOvSWK82rSDBkLMVJ90ZmWI5wIGt8L5spfaxZ0oy9oC4jnSJWR6h2R3DK6?=
 =?us-ascii?Q?QWmD9IoWiDUDIryQHH2elY23HR2a3olLcvYgsQHh42pbGyDg3k5h8luF8Ofv?=
 =?us-ascii?Q?SFzS2gxhE6qE/EFXx0WfRYqBl7TnhqwxFCalWGS3tXgqnru8rNL4B2HQ+lsh?=
 =?us-ascii?Q?QoIw1Po3h7jvPuf4vGraTrnTwkA/VLYi4kR5iGxozXXcRMsVgve+dVeKFnTl?=
 =?us-ascii?Q?1siNpQ+LypRwqm/ZCbtJwDU+rikaAKEue+oHwaFMSBG0Oc8dPnbbBTn6RvGz?=
 =?us-ascii?Q?YeBB4NWJennpoEGT60f9i5vVrbTbjah+MMkyE5/29A9myGjq0cpPoku1/D+5?=
 =?us-ascii?Q?KVAeV3ucgtNwkpLyZn4JS6zkZimdqtuYILv1vF0Km7xcik8Z6ZtMTdmhpWFS?=
 =?us-ascii?Q?1LERwrTodDBwO9nmM1HMXBKAIyGgpVl7vU/Onbkvfk/QH5bi1gw/fp7+geRZ?=
 =?us-ascii?Q?qmHP0O8UQLt3CUWIusFnEJhf17JQU52Pojb93k0O?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c29ac2-b98d-40bd-bd9d-08de1b686e35
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 06:07:27.4597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uy+Pu5bmnHjPossSPv2FQoWGB9R26BxGHLiqP79hGPVGk0LbXWkW6YHimXKxEvJy16eBERTeRl2T7V1RzDbhow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8756
X-OriginatorOrg: intel.com

On Thu, Oct 30, 2025 at 11:58:02AM -0700, Sean Christopherson wrote:
>Assert, via KVM_BUG_ON(), that guest FPU state isn't/is in use when
>loading/putting the FPU to help detect KVM bugs without needing an assist
>from KASAN.  If an imbalanced load/put is detected, skip the redundant
>load/put to avoid clobbering guest state and/or crashing the host.
>
>Note, kvm_access_xstate_msr() already provides a similar assertion.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

