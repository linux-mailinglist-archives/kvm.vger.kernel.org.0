Return-Path: <kvm+bounces-23267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 33888948577
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C805B22C1D
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 22:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76EC216EBF6;
	Mon,  5 Aug 2024 22:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZPIfpb0x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD09153800;
	Mon,  5 Aug 2024 22:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722897406; cv=fail; b=MHTplk9BxE/QpFztDB8iwLflQPngbdE5REn+AGcTVdFDj+/Rs4bUKAmDWXWzrNhdme6RYrxsTswwJijqoScVjmDUB69PmHkAtXNCifdpWhG5rpSAcU9+N3lSXbl/v9mmXHCEcFydU++1xMf67o5B/TcuQaqCEt/vNnv7jtryelw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722897406; c=relaxed/simple;
	bh=ssFOE5mKxMhkcrGVk6WFWYaZUeDYgjJ6fpQezAOYEWg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j5b1tijD2wvD6G4kuUGqkJkEGFLWq6nwirgskUYCENjlNGpYAz3Ryz7Dtmh4ImejbqqnrI4DDf+B8fXVaTnikH0dloALmaWHwtCEYaHppzGKY20blplsHiJ4ZIrr5tB7uTyqfz30qb/+FAjy0Pv62uZeminiUc7DAsoAzy3nXI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZPIfpb0x; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722897404; x=1754433404;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ssFOE5mKxMhkcrGVk6WFWYaZUeDYgjJ6fpQezAOYEWg=;
  b=ZPIfpb0x1u3EyKhmzikOEy5Sc7CQOgF3iapYRMJ5yCv9GRsXqZjWVtyP
   f46z+wmnBbgavZUxyt2cRluuhQHWZ1omBSlaQngvTn1nH627ikgCzE4TT
   Tjjx1dXQs0eSw4gonuztMdHV/IUWEt0SWfp2OJ7gu0KNr3A+m5upFuxgk
   parQ+t+bYnb5kG6HqpS5GFLzSMMQtPIQkvDbepk7M/fjwWOs/gX15Fupc
   qfn6EJ7ZZZJGqBukOjP35RHVW3IwDRKS3Jqh76POdUmQgCkv+SJ5XedQB
   a9M/UckqmhHI0DLHsGhoo7p6i21mNynh43J0IIAIizxXtwOEeQB7DWiDC
   w==;
X-CSE-ConnectionGUID: ozIubsl8Sheka39OqKXkMQ==
X-CSE-MsgGUID: CoAh5TI7QZ2Kypn0p9c8cA==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="38394994"
X-IronPort-AV: E=Sophos;i="6.09,265,1716274800"; 
   d="scan'208";a="38394994"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 15:36:44 -0700
X-CSE-ConnectionGUID: ws+pVuuuS5aSfwraYI1HYw==
X-CSE-MsgGUID: fhCqxKzmTwqXT4jDWVGCXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,265,1716274800"; 
   d="scan'208";a="57013899"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 15:36:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 15:36:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 15:36:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 15:36:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBrxYkUIcwwhugqqc3NfdyhYDAZ7uT8oftKn75HDSnwBvt0wWKzXVJvOWlkYTjaBifKSw0yuARpK3LFcCDqPuM2GNZdwQ6wRWyuUII+UscU8/xfpmo5DD8c2PJaEFeLVJ7AtZS8bCK8+421AWtCHSXC5QT4urAuhyrH20igZu07NgrCKkSum23lXxW30t6jO2Fsz3qsZ05DmGO42nSqK6v1gJSMEXoyMyONYQXSOlQM6c2jrfyoJVKmyUWeMQRnzrFXCgLB2hRN9M9+9L4rbMR/L3QQGyXzJZHy8gXnDWKSSDRzHoHjAAuXspUQt787mO3Junpy3crZNvxeER9DWvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2g02rBOYWt1iGIp5FsToXyI0DeX/KBz/3RKsmzRIoI=;
 b=LRhaAQMUms47T3HBLiFO7PAIzBKE43m9u65dbjxJpY0Zl7Y23uUV2m6tNIoKjRtm5nGvIodvEeLEa8vJxayHPc25IgdVtrWM6yWOVEylr64KtFk1ZZaysh/moUnzuiqL0vn9UI1aN9feFwptNC7o/SHe78Zc3b8GUXGF3cbMJdrbQBscT/IKo1wSKd0+fBkFmJ9tHvu0H5iFs4OhOLNjuRtQxqN3RH9Buh9BYOvIxQY2UD2sgTnkmdYtDz/wSCD4Ht1tED8k8S+2RZy0O63QOPMR+f6M39OsoY00/3RlcZCEwfTWeGGZt7Xm7dCrAEQRyCU0qRF2hWIWTbIYgfkxDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB7015.namprd11.prod.outlook.com (2603:10b6:806:2b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.32; Mon, 5 Aug
 2024 22:36:40 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Mon, 5 Aug 2024
 22:36:39 +0000
Date: Mon, 5 Aug 2024 15:36:36 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v2 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Message-ID: <66b153f3e852f_4fc729488@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1721186590.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR04CA0138.namprd04.prod.outlook.com
 (2603:10b6:303:84::23) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB7015:EE_
X-MS-Office365-Filtering-Correlation-Id: e05c221e-466f-4335-3abb-08dcb59f12a8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CuNtz+9n0HJEFV2qhIKOTD3beVV0CGJ/j9BE/tlJadVrUC7tE+NZdTcbd7se?=
 =?us-ascii?Q?+w9u00cL65Kw+P0bEZAikLdPH6CmE/0D8cRqjkUHrkldse7stSZwg2vUNshI?=
 =?us-ascii?Q?b28KyJeyT60irpMJuslRzslVyi7oEOtC2u5UGJufK2Fsu5UxzyUL+Wkz/cQQ?=
 =?us-ascii?Q?AjeMS7PXGmS1rbwf/T2P15eNkmcvFKkjzPM9wXCND/Xa6MWKfvybsdytJ8Yn?=
 =?us-ascii?Q?t546sCARmDNIRpcEYj8RRA9jQrO5u5b/3N71CrC/2z1vEbDYeH26kDWCOASV?=
 =?us-ascii?Q?luhF7jL6RyZRJqq8KqRKQ3A+MctOh2RpI/e4J6WcEMV0cxrZVpDgcBKXltDA?=
 =?us-ascii?Q?w5R0bn2O9ItsMcu5Mx3wjPKpmnD+9QsjqdkLY46uCPUd0AdNI0e9Y0Z3BDdE?=
 =?us-ascii?Q?2ZQap760qqPeV+a0W7DzJi1f+JsFWEbGNGKErMI/N7m9aLaUeuTAFSqrAxNE?=
 =?us-ascii?Q?DNbkMwqhAMStnH75uHxwRRORsKqx8zE9+wIJH/kjPn1Y56pcbTQpbV7I2P/l?=
 =?us-ascii?Q?XQ0Vfh04RtJq0Bj7CyYjaO44BwY7Zer6qtPG/ijdsWuD2ZrqwIt0HJkoNXd8?=
 =?us-ascii?Q?H395IjUdtfG+vds/O9oO1vwITbPgnOeZX8gtG9sokuQSWuCnjoRQoB+tS41f?=
 =?us-ascii?Q?cQTHKnvWavGtCn0A/ustH/Pcr+PChvN13gEqfpenhkf7id8BvFzn3S1OPQrc?=
 =?us-ascii?Q?r6kvEdpbZsxql2J1HrE2ju6cOvRUb2Kb/KM8fDUwNWyZ0NcoyMTu5hPcIMnl?=
 =?us-ascii?Q?LGdaJ6I9SQX/1yj3Z2kEOoN3vq4p+NedzJN5Dinr+j/6sT4cV3SyHF5lmrMp?=
 =?us-ascii?Q?esNlbvrGOovws/Vnx2o2oN3yTaa/f1rBr0n5wJz28+4mfRTFy0dVb/Lft24U?=
 =?us-ascii?Q?6HM+NaPdeYDvRU+L0qyZ4jKBlitMscwPF6bqZGmfnge0FX42vgmujOHIbupb?=
 =?us-ascii?Q?n+RIyhMtTXDIVhp8TMS7S/ZK8+/8Mbi9T41A8Zu1uU/GNstALCYvPiwYKOBX?=
 =?us-ascii?Q?7pglOdqJRG02iIGrJ7ypzvFJ/eCfPumSSrvwPqq7LnpasP4l8TRzqIwB/gD8?=
 =?us-ascii?Q?8YW0Ls+5yVAdx15KuA/kyB0EdZ/4YGnhr/KumE0Km8RWb802/pj4U6Q/6dM6?=
 =?us-ascii?Q?QgUsgyGJl6Z/fodhYwsq24SwO4lUY8PRvfvV3a7pUYOE9bJiMoN3vt4Dz/aQ?=
 =?us-ascii?Q?JeQuop21iudl2hqH9UIa5ar9XnFQm2Iq4oomzMz6jG8oB3ri4DIrt8kZLjbU?=
 =?us-ascii?Q?23wzxmKvsfcy45UryTKXMF8nVWfLQw9GuO2KXfYeeO8dB3uf7l2XIcHVMWb6?=
 =?us-ascii?Q?rcw8JjVHXg6rAZCIVBLxtpMPfUzrMFE08UUJau5qDKtohUvOrZRjIxdOTzKQ?=
 =?us-ascii?Q?/zgDPXU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8lQmg+K8VC3X5mgrFAigTBjA3zvLket3v5Va/smrOkue1jJtluHhZpgB1j3z?=
 =?us-ascii?Q?LLdN8oHU4OnVUxFDKPCjwT6iu/BEjRIr3R94asSKLf2P/aTOBxJFsWzNsf49?=
 =?us-ascii?Q?muhS+PiWy80Z00BcnR7q26VtZI5wzahNqDdjX2h6KjC8LtJPGo/wxoyf6Win?=
 =?us-ascii?Q?JxrlD5DQMjHLYj0IOTRFnybTnZ+gz2bMx5zbR8yxxQ4GWWUZEBZJoy+yUQ7t?=
 =?us-ascii?Q?CeXG9O5UQf87VJkIfW2NW1fnzEjEFW2Djr/BiY+53z41Rn3Vf1qZ9XE43dEe?=
 =?us-ascii?Q?4rvh74HA+zS/cmnSGwqnI74zUwwt2ve6ie2uJOX+6cRczUGM9KQtc691WnPW?=
 =?us-ascii?Q?cCCh6ep+9e09VvQb7fPvW9BkZD0usoY/uakXfgKzzVA49CDHZ5GkPJ0uXobg?=
 =?us-ascii?Q?VysEqZCFZ1ZqcF59042mIdZy0uaJfStYIkqK94JAcWBI3aJXG2wg5bAbHkJR?=
 =?us-ascii?Q?MG2zhQC5773AnltJ0XXQRzsV3QmLYnw4N8WHdBS3g40gSvMDyBYlQ7+utlwD?=
 =?us-ascii?Q?8nXtBpquaDjeVDcK36e9+GhksbTVzKzkYwsGArLhwyimuZqgNjChTOJOtuXZ?=
 =?us-ascii?Q?RxgleJVfRcedJpKCXHlJAzoQXig0/B+kmmEeYxwCYFIReW2uzzr0ks0AH3Fx?=
 =?us-ascii?Q?jFw0h7P81D8/J/PqfdYzY+FmG2pLRxeAN19B/l06OqV6y96R14BuM9J8MR9I?=
 =?us-ascii?Q?BYusT/2sQwmuSoQI8xt9pIAwuUbeY5SCLyVsz9egl100bMsa59Z2coC0PD3O?=
 =?us-ascii?Q?BjQAPtynXLIhHwqvAtGgc4U5UX8N+0NnQWN4JW55yjPUBHVp6IUXlWBSLo2m?=
 =?us-ascii?Q?WbbsM9S6dOF/NBsZspv0k1uyQN3maOU0HwqqlyA/z9ckwtpmN6iZFjwpFQDK?=
 =?us-ascii?Q?chrjWonf2iMqgnDqFAsv+lEFAGyYLkYhjj+FCYgAghe6xaaOpbyreYqod+JB?=
 =?us-ascii?Q?A+atz7YDg0rjQWljUCzO2AgdUdz1ixfS1cRzJolO/T6VW3PXJVrSqYNNcVYn?=
 =?us-ascii?Q?FQgkVcvqjsuk1yYysAjMxSIG9W3it2DyTS59WAIJ6evNUZTPRD3k9mmxrdLP?=
 =?us-ascii?Q?azt9ZmEcGBwrnHeHQa3lvY40oB79x7ud2FQ760+bJf8Wk/osXj2BjTbUFRgw?=
 =?us-ascii?Q?1zCzmv79qxBTBZd6J0xwXCPCt2RiI9LOSDOw/82h7oxZZBtrI2rckmRhNdCK?=
 =?us-ascii?Q?s7roy+vHGw7c/STxhNYS1ZAhKxzD+WfBJxCfw8mQNswcNvNVJ9Hz2cTQMjIF?=
 =?us-ascii?Q?lnOhEoYM+5BQJc4q6mYH/NojHMIIhyYRP0OV60GsWb8NivuPVBnJMMX9bKo4?=
 =?us-ascii?Q?aV+TuRlf3GXWVPbWZexbxp+56BosN5asvFE98z2PFhnMf82D4gbYgP89+DdS?=
 =?us-ascii?Q?KCrLhkiRWuawB5ZNOQW8o679U27JUr9YWg8IusICDGUOn9ZCYFVGC+in1EGU?=
 =?us-ascii?Q?XuMcvCJ6wN8p8q6BLSBACdNJDfIkOwQXCRC9cgmktku+/QfFHGHYNJnOT1/o?=
 =?us-ascii?Q?c7Ar1UAwWMIZoUWQkLudfkb5qTRjAMv27TvDMidJJB4/1uxQDGB/lV7/d/4+?=
 =?us-ascii?Q?gnhDxQpj0CZG1rH+Ro/S5mxZY5hJJ6HzNk1X7N89iTYa9uJIW4amfkirpet7?=
 =?us-ascii?Q?GA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e05c221e-466f-4335-3abb-08dcb59f12a8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 22:36:39.8751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TYB7q9eVsMS+01eannoLOYSMYLJYyFGsRqZop7R6iZf1/Ygkm9ssGNd0PoM6BdC2zVRqNNS03GsEr3X6+BX/uq3yD49S1/U2CqORDg35kEY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7015
X-OriginatorOrg: intel.com

Kai Huang wrote:
> TL;DR:
> 
> This series does necessary tweaks to TDX host "global metadata" reading
> code to fix some immediate issues in the TDX module initialization code,
> with intention to also provide a flexible code base to support sharing
> global metadata to KVM (and other kernel components) for future needs.
> 
> This series, and additional patches to initialize TDX when loading KVM
> module and read essential metadata fields for KVM TDX can be found at:
> 
> https://github.com/intel/tdx/commits/kvm-tdxinit/
> 
> Dear maintainers,
> 
> This series targets x86 tip.  I also added Dan, KVM maintainers and KVM
> list so people can review and comment.  Thanks for your time.
> 
> v1 -> v2:
>   - Fix comments from Chao and Nikolay.
>   - A new patch to refine an out-dated comment by Nikolay.
>   - Collect tags from Nikolay (thanks!).
> 
> v1: https://lore.kernel.org/linux-kernel/cover.1718538552.git.kai.huang@intel.com/T/
> 
> === More info ===
> 
> TDX module provides a set of "global metadata fields" for software to
> query.  They report things like TDX module version, supported features
> fields required for creating TDX guests and so on.
> 
> Today the TDX host code already reads "TD Memory Region" (TDMR) related
> metadata fields for module initialization.  There are immediate needs
> that require TDX host code to read more metadata fields:
> 
>  - Dump basic TDX module info [1];
>  - Reject module with no NO_RBP_MOD feature support [2];
>  - Read CMR info to fix a module initialization failure bug [3].
> 
> Also, the upstreaming-on-going KVM TDX support [4] requires to read more
> global metadata fields.  In the longer term, the TDX Connect [5] (which
> supports assigning trusted IO devices to TDX guest) may also require
> other kernel components (e.g., pci/vt-d) to access more metadata.
> 
> To meet all of those, the idea is the TDX host core-kernel to provide a
> centralized, canonical, and read-only structure to contain all global
> metadata that comes out of TDX module for all kernel components to use.
> 
> There is an "alternative option to manage global metadata" (see below)
> but it is not as straightforward as this.
> 
> This series starts to track all global metadata fields into a single
> 'struct tdx_sysinfo', and reads more metadata fields to that structure
> to address the immediate needs as mentioned above.
> 
> More fields will be added in the near future to support KVM TDX, and the
> actual sharing/export the "read-only" global metadata for KVM will also
> be sent out in the near future when that becomes immediate (also see
> "Share global metadata to KVM" below).

I think it is important to share why this unified data structure
proposal reached escape velocity from internal review. The idea that x86
gets to review growth to this structure over time is an asset for
maintainability and oversight of what is happening in the downstream
consumers like KVM and TSM (for TDX Connect).

A dynamic retrieval API removes that natural auditing of data structure
patches from tip.git.

Yes, it requires more touches than letting use cases consume new
metadata fields at will, but that's net positive for maintainence of the
kernel and the feedback loop to the TDX module.

> Note, the first couple of patches in this series were from the old
> patchset "TDX host: Provide TDX module metadata reading APIs" [6].
> 
> === Further read ===
> 
> 1) Altertive option to manage global metadata
> 
> The TDX host core-kernel could also expose/export APIs for reading
> metadata out of TDX module directly, and all in-kernel TDX users use
> these APIs and manage their own metadata fields.
> 
> However this isn't as straightforward as exposing/exporting structure,
> because the API to read multi fields to a structure requires the caller
> to build a "mapping table" between field ID to structure member:
> 
> 	struct kvm_used_metadata {
> 		u64 member1;
> 		...
> 	};
> 
> 	#define TD_SYSINFO_KVM_MAP(_field_id, _member)	\
> 		TD_SYSINFO_MAP(_field_id, struct kvm_used_metadata, \
> 				_member)
> 
> 	struct tdx_metadata_field_mapping fields[] = {
> 		TD_SYSINFO_KVM_MAP(FIELD_ID1, member1),
> 		...
> 	};
> 
> 	ret = tdx_sysmd_read_multi(fields, ARRAY_SIZE(fields), buf);
> 
> Another problem is some metadata field may be accessed by multiple
> kernel components, e.g., the one reports TDX module features, in which
> case there will be duplicated code comparing to exposing structure
> directly.

A full explanation of what this patch is not doing is a bit overkill.

> 2) Share global metadata to KVM
> 
> To achieve "read-only" centralized global metadata structure, the idea
> way is to use __ro_after_init.  However currently all global metadata
> are read by tdx_enable(), which is supposed to be called at any time at
> runtime thus isn't annotated with __init.
> 
> The __ro_after_init can be done eventually, but it can only be done
> after moving VMXON out of KVM to the core-kernel: after that we can
> read all metadata during kernel boot (thus __ro_after_init), but
> doesn't necessarily have to do it in tdx_enable().
> 
> However moving VMXON out of KVM is NOT considered as dependency for the
> initial KVM TDX support [7].  Thus for the initial support, the idea is
> TDX host to export a function which returns a "const struct pointer" so
> KVM won't be able to modify any global metadata.

For now I think it is sufficient to say that metadata just gets
populated to a central data structure. Follow on work to protect that
data structure against post-init updates can come later.

> 3) TDH.SYS.RD vs TDH.SYS.RDALL
> 
> The kernel can use two SEAMCALLs to read global metadata: TDH.SYS.RD and
> TDH.SYS.RDALL.  The former simply reads one metadata field to a 'u64'.
> The latter tries to read all fields to a 4KB buffer.
> 
> Currently the kernel only uses the former to read metadata, and this
> series doesn't choose to use TDH.SYS.RDALL.
> 
> The main reason is the "layout of all fields in the 4KB buffer" that
> returned by TDH.SYS.RDALL isn't architectural consistent among different
> TDX module versions.
> 
> E.g., some metadata fields may not be supported by the old module, thus
> they may or may not be in the 4KB buffer depending on module version.
> And it is impractical to know whether those fields are in the buffer or
> not.
> 
> TDH.SYS.RDALL may be useful to read one small set of metadata fields,
> e.g., fields in one "Class" (TDX categories all global metadata fields
> in different "Class"es).  But this is only an optimization even if
> TDH.SYS.RDALL can be used, so leave this to future consideration.

I appreciate the effort to include some of the discussions had while
boiling this patchset down to its simplest near term form, but this
much text makes the simple patches look much more controversial than
they are. This TDH.SYS.RDALL consideration is not relevant to the
current proposal.

