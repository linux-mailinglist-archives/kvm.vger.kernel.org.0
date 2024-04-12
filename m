Return-Path: <kvm+bounces-14376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D87CE8A2460
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 05:25:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39F04B213DF
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 03:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC371946B;
	Fri, 12 Apr 2024 03:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aiwRcn+3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E05318633;
	Fri, 12 Apr 2024 03:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712892312; cv=fail; b=POMqQcH3mcSQz19DFShW4OHayfFX1vpeEQtVh2ePoxtMdOM5eM5bSjuoKC6bh5UDLFiFFhQD/EmDe+bG+TvUOkb72oPTx0FxxqLliaYRqpe4T3Sd5ohivuqXENMgyYs97jDEAdeWPMpykPPGsmENtE5VyvJe2b+yG5cd0n6jWKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712892312; c=relaxed/simple;
	bh=tDJs3diT+Haxzz3Ce8pikWIEIR7hp1V4AHWHq3Kj30o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e8gywbPc8xkI5PnyL9BCvSdNy7amdeuE9VWnBG+5Jhiz12Bl40UgN4iHhJ4Nt5eIGdWF3Wl33DN4evtXld7Hzeh6TgAUzXDFnkGzfD9CxFEsTXPCPWdncW35Bh3kwmcZ79gZXkqgj0kMX6SmDKxkB0uzh6WYY4N8eajz/X7hgCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aiwRcn+3; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712892310; x=1744428310;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=tDJs3diT+Haxzz3Ce8pikWIEIR7hp1V4AHWHq3Kj30o=;
  b=aiwRcn+3DFDDWTRrJyNBRG9MWMabQJ640BNxqnXaFgXMKtQb7PlNKYgN
   XxZTp8GR1LN8mvzDwJkx/69xM9HxHBN1Jh3F9k/x/41TqQJsvHquiotaG
   b2xb9Mh3tlk5DG8A7/iWCcUQLMVHCI/h1KW4RX2f0GGk/UAg8CINxLihc
   j+S5vycbgArRe1Lt0iuPckYTJ3dWud6sL5ZJOHQ5wTffYydEoHxnaRGii
   oelAiQHim8leGOmEhKA8ilsFgCmzXpt9h5LSab2cxhsHeWMcr72eerev0
   RPm0FBMLSJgLP6K9bWrQV3xgTGMY0xC/nIhpa+VjzQiOeDuiHnE35J+t+
   Q==;
X-CSE-ConnectionGUID: loDeqk4FSQquwX+Ktuj3lQ==
X-CSE-MsgGUID: ztRzF/iWSMentT1FCF6Dpg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19486934"
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="19486934"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 20:25:09 -0700
X-CSE-ConnectionGUID: 5PLT0jVGTa+QZGzCoIoSmA==
X-CSE-MsgGUID: 8XBsVe0bRgqN2tKFnenBxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="25892445"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Apr 2024 20:25:09 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 20:25:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Apr 2024 20:25:08 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 20:25:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkycUweLtoeuFqgd0nKxG1KMchgh3B2ugnPXHO3vJeG6oWGc95HmyNd77VqV3gfh5Or4050xToOPbM4uy/nLVVOAfyMCR+vqLfFB2LUWhLhg+WY98SZHwzjetCpiEXC/XqVnrVfglMOVdZLWHcuzWO2qvCpWAmkbKHVTodq4A8LTi5Gti/YTyJ5ewYqky7H104KcWO07wODD68tHobjDeRoPOym1aZZi87KZmimnASyReEoJ6FeVO4eprzYDZu5d+BOLnJPQNyRGzANiV0JxLc51oG4ab22b2ICBI7SX/gCXYm9jUMyn7vHNgWkktyBb8NalmfihE63nNs5UZpRAGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cR0dyc4b4gm9guMuc7dWPsFKS1KJYHAu4JO6tDxjXWI=;
 b=Msn4BRiv7idM19VHWXSYduZ3X6cMfsl1uFnwXJ4VwnIXgFmFwE6E4IlxVLwxzmaJOoH9m+zryjbPtGmwpKLWKOTLNcweXL42w+92ef60t5v+2+9fwiz6+SbxzQ7EeEoenuGGIT0lSGvqcm9rL6eJEP0WQ0S5dJiEI1pOln70/MrKMBBMX3qcL1CTDTsvHgdEqwVexIUNLrBVX3lr1jTXowRIFePClxY2N7ZZn5/LQoxrc6qp+s2f4n9rHVpIM/ulPwS3p843bPdtNAl/Kpl4eRfcqZ2o9DV+/bWC+IR59YtL2pTE8AnBk6lCjukj2K9bnt1yxp4T/97cAzg/xqLIoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB7595.namprd11.prod.outlook.com (2603:10b6:510:27a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Fri, 12 Apr
 2024 03:25:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 03:25:06 +0000
Date: Fri, 12 Apr 2024 11:24:54 +0800
From: Chao Gao <chao.gao@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Alexandre Chartre
	<alexandre.chartre@oracle.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<daniel.sneddon@linux.intel.com>, <pawan.kumar.gupta@linux.intel.com>,
	<tglx@linutronix.de>, <peterz@infradead.org>, <gregkh@linuxfoundation.org>,
	<seanjc@google.com>, <dave.hansen@linux.intel.com>, <nik.borisov@suse.com>,
	<kpsingh@kernel.org>, <longman@redhat.com>, <bp@alien8.de>
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Message-ID: <ZhiphhlEAg4UCUoL@chao-email>
References: <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
 <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com>
 <2afb20af-d42e-4535-a660-0194de1d0099@citrix.com>
 <ff3cf105-ef2a-426c-ba9b-00fb5c2559c7@oracle.com>
 <CABgObfZU_uLAPzDV--n67H3Hq6OKxUO=FQa2MH3CjdgTQR8pJg@mail.gmail.com>
 <99ad2011-58b7-42c8-9ee5-af598c76a732@oracle.com>
 <CABgObfa_mkk-c3NZ623WzYDxw59NcYB_tEQ8tFX4CECHW3JxQQ@mail.gmail.com>
 <ZhgIN4LIu2K5vf5y@chao-email>
 <ZhhNBCtY0rgfJdRK@char.us.oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZhhNBCtY0rgfJdRK@char.us.oracle.com>
X-ClientProxiedBy: SI1PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB7595:EE_
X-MS-Office365-Filtering-Correlation-Id: 539fef90-2f0f-4125-4b41-08dc5aa0265d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5WwglPcMyWqOJX995QbzTjLBHUl7hujhQx44YyoZ+mSBAWX/l42biOWRqQc9zCWa3GSLIflImHqAtfxtMCDBXx4TzKnLqYYCGR6gYLfgGu7M9dJxVYO7GKGDIOJZqPvBK+7t74qV303i6SDg58oEw+E2Jj+JwU/I8oLTPG994o4Ko45HMLmhdRGZIPPBmwHFg3m1kj3rYZAVIAJumGkmLf/gEb6saWOHcyRhy2Tri8vLJElCtM/7di2IulMTnT+MQmnKXwhkjVbEhBGXxmvUAX0/7uVvZwig6DvGx3GYKoWCNNWEnt2Zsl4bKALClcS6G4KDpIpv/LQyWzZ2/QHd+xs0qmJZ/Sx6IrlVIJeBT+svgJ9n4FjTeWGBo0+LkxL+DcLDThKEnkV03nuTnpxy88/xooKFO7k2LoKy8brc/NmTmSvChHc2qCN5g8Vq7idT3S0KV31nlGc9dAKeU3hJh68YdbL9QbuHGZWFg/Glz9ivLKTNzMtnFFremHjmdyqpzENucl8JOj5l+zg4y3K9IEclV2LkjiWfNn6YSDFoyf8SY4tbED7h+YbrvnRcy/aGaXtWRZnLDX0m2MVhnME44p0EXm0IjhLSfflaOu+i/S8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUNlTnRTeXhzbjZ0M2FiMThiZTdFWHhuMUUzdmRyVVlWcHZIZHl5TCt1MmJh?=
 =?utf-8?B?RUpFWFpXNy94UDNLWFVwelQwNllSelRXTTdXTzFKOHhxcXNOcDQwbU9QWDEz?=
 =?utf-8?B?TjhZQVdzdGZaYW1qS3R6anpCVkhJdENJU0tHNW5UeXIvYzlOa3pyS0k4YlJO?=
 =?utf-8?B?RzFscXNJWU03SWhBSTRvTVI1Ni9iV1czRVJ6M1dER1FjUEZmWHRGdm5IazRw?=
 =?utf-8?B?SWdCZlFUeVVwNG0vTUthTVpUcjhIbnlzN016eDRjSmVaSFBjU2hmTzNwRTAw?=
 =?utf-8?B?Nk85VEp2eFlMc2srQkxPend1enlaMmhsNEo1Q0xjSGsrWlc0RWdmRVk0ZXJK?=
 =?utf-8?B?WUIydEpDaFhLcnc2eGVyazRxWWd1QjNjcWgrZzhjLy9aTzNub3lLaE5aUXdz?=
 =?utf-8?B?UjdYMHJJRXB2eEV4SklkUVMwN003WTVDVXRGbzhSSm5kMFljUmgvZHM5OHRh?=
 =?utf-8?B?S3laU0wxY0s3SFNOVjBvVFVnRFJ6aDVlNUZkbDZTUmM2b2o3S0tNay9rTm15?=
 =?utf-8?B?UVJLMzhkR3lvZm10RllsRC9KUitNUXAwKzBEdDFXWTI0dHR0Q3dpaWRXOHd0?=
 =?utf-8?B?dmxUblpteEliV21WNGk4VU1qUmdFK24ycmVQeUFORmFlU1hnTGRGSzlnTmlz?=
 =?utf-8?B?T1hmcTArMWI5UDNZZzZJc1YxTURUbzVZbUNqTjRwYUc0alljOVJFSW1sVlRZ?=
 =?utf-8?B?UTRtbWtSUWU3VTVvQ2JwZGN3bWJRVjBPMHYxTW43ZEZnWG9qMW52WEw2RXI2?=
 =?utf-8?B?RkNnRmVBcE16M3Z6NHR2bjgyU1p6NWtScittdFpIK2w3bU9id3ozUDdMU1JU?=
 =?utf-8?B?cE02RyttSTl0a3V2TjFrN1RMcHh5aTMveFJ4T3BlbWFYcXE2eXBsRXBkYSsr?=
 =?utf-8?B?L2s4c3k1UnJieGlST0JMR0pnY2hHTENwaWdNL3ZITHhSWng0MU5iS2JZU0Mv?=
 =?utf-8?B?Wlh1RjV3Q0VXOEh3VHdINTRJbXdNUFZDdlVzRXp0QjhBOEwxK291SUxiV1c4?=
 =?utf-8?B?cUgwNkdQQmdzN3FTTHlKdld4T0hXU2tBRktMVVpaQm1LWDl6M3B6WldpU3hU?=
 =?utf-8?B?cUg5azBUSmhtTVpBR3ByZWU4em8zeU1GbTJHeGZkQnNrUVg5RWYxTnl1Ykpm?=
 =?utf-8?B?dzFhY0ExR015YUd5cXp3U3ZabkppbDJYZ2hVMW5iSWVXRzEwaGgvMVRpQmVL?=
 =?utf-8?B?cTQ1QVhkcFpmZU1JZWtoMEh2Yjg1MzN1V2RCUXRXamNUeXJjUHJ3R0s3Q0Jk?=
 =?utf-8?B?SVM1RnlZTWEyb0pmbjdoM1ludnAzNjdKRlBKRGlNQ3laQjdpL1pXdlJvZG81?=
 =?utf-8?B?OEkzZnVmU3lFT0RMYlRwK2pZYlpYWkVDRCt2MHRWUEQ3T0dKYlFaVUF4TFYw?=
 =?utf-8?B?SUUzYXo2blZhWjFCVmkwK3BMZGR3WDFDVDFkSHkxczkvbXZzV29FZ2JWYjJ1?=
 =?utf-8?B?T1lWUmdWS251TWpIWGJJYUcxM2U5dFcwVXd1WmFBZlo5YWRVOXFva0QxL1BT?=
 =?utf-8?B?aXdKR3k4Zm9XQTRYVmlvMkJFM3ZuWC9uelFYanNZKy9XaVlVYm5IWGpWS1dw?=
 =?utf-8?B?U1lkdzQwSUJaaUgvckt5U2JDUEF3S1pDRUV1c25PL0g2akFLVlJQNVV5M3VN?=
 =?utf-8?B?N0ZCSTlnbVVOYUNOUWh2bFNiWnYybE5DR1lUWmZiTVRMT0FyTFpwV2lwSmlt?=
 =?utf-8?B?S1ZQbWtXWUxWQldaVk82RklJMWF5ZXJ6eFFnQmZCNGMreUFkZk5EVGp5K3NJ?=
 =?utf-8?B?SWQvQW1MNWFRMmdBQ1J5V3V3WWRlNTQwWTlmdklYK2M0Wm1Hc2VIUE56ajNu?=
 =?utf-8?B?KzBRM1FIMUZpNjlld1BPTCtkNG15d1c0K3VDcXR1NUZKRFdidzQ2OTlZd0c5?=
 =?utf-8?B?NC9ERnNIVHpLRlN5MnJIR0tvTXlzbUxtMy94WnZPWjRobXJ0SE0yb2JabVZr?=
 =?utf-8?B?ZWRKdnlKZnRnTStNOVBsdHFuNFhJL3dhY01nMjJQTzZQU29teDY1VDRubUtZ?=
 =?utf-8?B?RWV5Wm85Y1Q1YTBkRGljMEhjbnN1NWdtUWE2Z3p3Mi92MnczOU4vTFh0MGxa?=
 =?utf-8?B?ajU2VCtuQUJkcVdQdHBWZTVmbVplelVvbWdjYWI1MUU2VGRsdWhpc0RsdW8x?=
 =?utf-8?Q?n8fvuj1ZbSrZ4LFIapygvrlHF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 539fef90-2f0f-4125-4b41-08dc5aa0265d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 03:25:06.8715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2awLyil/xSlS7H24aAWFzQTHgjb3YWE9mBaLnVgssYxb2RZcv33jyQ6JjT86usNb5acWIS8FSXmpNwWkX4W9kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7595
X-OriginatorOrg: intel.com

On Thu, Apr 11, 2024 at 04:50:12PM -0400, Konrad Rzeszutek Wilk wrote:
>On Thu, Apr 11, 2024 at 11:56:39PM +0800, Chao Gao wrote:
>> On Thu, Apr 11, 2024 at 05:20:30PM +0200, Paolo Bonzini wrote:
>> >On Thu, Apr 11, 2024 at 5:13 PM Alexandre Chartre
>> ><alexandre.chartre@oracle.com> wrote:
>> >> I think that Andrew's concern is that if there is no eIBRS on the host then
>> >> we do not set X86_BUG_BHI on the host because we know the kernel which is
>> >> running and this kernel has some mitigations (other than the explicit BHI
>> >> mitigations) and these mitigations are enough to prevent BHI. But still
>> >> the cpu is affected by BHI.
>> >
>> >Hmm, then I'm confused. It's what I wrote before: "The (Linux or
>> >otherwise) guest will make its own determinations as to whether BHI
>> >mitigations are necessary. If the guest uses eIBRS, it will run with
>> >mitigations" but you said machines without eIBRS are fine.
>> >
>> >If instead they are only fine _with Linux_, then yeah we cannot set
>> >BHI_NO in general. What we can do is define a new bit that is in the
>> >KVM leaves. The new bit is effectively !eIBRS, except that it is
>> >defined in such a way that, in a mixed migration pool, both eIBRS and
>> >the new bit will be 0.
>> 
>> This looks a good solution.
>> 
>> We can also introduce a new bit indicating the effectiveness of the short
>> BHB-clearing sequence. KVM advertises this bit for all pre-SPR/ADL parts.
>> Only if the bit is 1, guests will use the short BHB-clearing sequence.
>> Otherwise guests should use the long sequence. In a mixed migration pool,
>> the VMM shouldn't expose the bit to guests.
>
>Is there a link to this 'short BHB-clearing sequence'?

https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html#inpage-nav-4-4

>
>But on your email, should a Skylake guests enable IBRS (or retpoline)
>and have the short BHB clearing sequence?
>
>And IceLake/Cascade lake should use eIBRS (or retpoline) and short BHB
>clearing sequence?
>
>If we already know all of this why does the hypervisor need to advertise
>this to the guest? They can lookup the CPU data to make this determination, no?
>
>I don't actually understand how one could do a mixed migration pool with
>the various mitigations one has to engage (or not) based on the host one
>is running under.

In my understanding, it is done at the cost of performance. The idea is to
report the "worst" case in a mixed migration pool to guests, i.e.,

  Hey, you are running on a host where eIBRS is available (and/or the short
  BHB-clearing sequnece is ineffective). Now, select your mitigation for BHI.

Then no matter which system in the pool the guest is migrated to, the guest is
not vulnerable if it deployed a mitigation for the "worst" case (in general,
this means a mitigation with larger overhead).

The good thing is migration in a mixed pool won't compromise the security level
of guests and guests in a homogeneous pool won't experience any performance loss.

>> 
>> >
>> >Paolo
>> >
>> >

