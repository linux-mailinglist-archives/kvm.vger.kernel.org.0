Return-Path: <kvm+bounces-35270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60479A0AF97
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 08:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33F9C3A6643
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 07:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65689231A4C;
	Mon, 13 Jan 2025 07:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gCgLZigH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4C01B7F4;
	Mon, 13 Jan 2025 07:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736751905; cv=fail; b=KzoMxKUBDYKD1blaLvDF0UrDFbUkLM/La/TRk+N6iJ0Rz/zQOJzK5lYV2l/tHud5AkWoewdk1zdktNvpSiW3VUylh62YsnQh4DseT6dJmLrPy+0KKmJaRw+zBPR5hEh3K4nix3acfpbHLqyV/2ZtVA7JUvimQVnP2k6Q5L5AbOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736751905; c=relaxed/simple;
	bh=PE5Z2vVb9QaIFfueZ0mQl6bz3c2NZNt6StSnFM1pw5g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OZYTqBQba7HjQwmtspjepl9eZtx9MFXFU76t+8j9g3TtATJtzGjbkYMh7nbK1tyFLOHeUcXq9LBLnhOTbp6mwhVoie3+XOX8dRLEBE3iHsLZQS+hBdMGfLzy5Yr/vQue5657tgAyLHhlqiNra2qGf8FlP3DdTosJmww6EebWUJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gCgLZigH; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736751904; x=1768287904;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=PE5Z2vVb9QaIFfueZ0mQl6bz3c2NZNt6StSnFM1pw5g=;
  b=gCgLZigHVjIsMWttcUsmyGFm5M3Dr09QBG6Z2YiO3KObuNNsHf2yRmUR
   XteHoKH/tzDNfcsv2rz9wmufOeG9Pzs5gUJVtsNdu8rk0xnPKngD8lu+y
   27MIMkZDL7e/udvsyqVBMlVb1Ca7cu6qkK+FG6XYEau9D0tX+/V6pt6pk
   ijWrjV7wufk9PtEkYcrJTsKrdw66LddLCgXilJEGWGJfpnYQzn29liapE
   NERwVzuigdYbS1FgOlbpEw+zufUqwbZpC1rkxLsdWDR3GSvalDpCHo4a+
   83oNpAFDRESIlwxjTRG+KK9Uw+AQNEUIPjaPjZ+sfLZgH6m8AZ7lstCFm
   Q==;
X-CSE-ConnectionGUID: JBVRcJ5FSIKd+Abs9bzIOw==
X-CSE-MsgGUID: 0IBZDj7iQ5y+98k2xECMbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="36280134"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="36280134"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 23:05:03 -0800
X-CSE-ConnectionGUID: QjI+8CQiQSWHOIqDA+WWVQ==
X-CSE-MsgGUID: 3QiUnV1OTNiKEltFq/IVSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104341174"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jan 2025 23:05:03 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 12 Jan 2025 23:05:02 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 12 Jan 2025 23:05:02 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 12 Jan 2025 23:05:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ymom1dKSZ5EVcaU+6xsHm61X8qxr+EjfF6WxT+19+a3pUam/ovxk+lDOv+Fk69aDFa95ZWEcSP4J3fMoIkjDIIU33eKRZHQ7r9m+/KRYzeGGPc8JL6dSjK35aEOaTbsDP8ZWqbxqrbxVOKuvQq6Y1JQxf5iOqbH7cBmULdzS1azSfMDWIyw8OP4sGJnvjSKPBQUhKSBM8E3denRa7sBJeFZORZ1jcZbZBXDKZOWetIWZbeq6Jh+RsFVDxvxYBc0QXSnBJejb1bPTy8IeVLmuADlY/kwvD47oFjrsWdzCrZklojgEJF/1q4sh5weLbMotOd5t2Wyd8IFCl0LcyxyUlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xc7KJnsvbzXVUf2GkHbzAnV0kvwJiMvULxHLrL6+7RQ=;
 b=e8gd5zi3oDnem5XGaQj5yThTj2Ppull0G/7KrtIE4FX9xNFfP9qRqvbjh1Hl+NKDu6+VOetVvAxj03XTfcc9Tad7ukMG27sTeSlbURqRV/bK+mqBR9jhEU6fG3wRgWVuxAX5/bS4+NJLfZBLiI4Whe8tSUr5mlfFn/qXE+oLXBuLOu8C/QfrbI9bZK9283ZM7LfVfnyoTBfjHWNTS7NSWWVQvkeowLSTbLfaNnv7zaILFkh97ES99/tBKfwYwMnHk4r3yPT+PmN0qXLWbGvZlNUlmiERMRrI8O4PDt3NNnCK4Vxd3xnC6zedz/TaFueKbuW+z4aoKasV7uZ/QsvYHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7904.namprd11.prod.outlook.com (2603:10b6:8:f8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Mon, 13 Jan 2025 07:05:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 07:05:00 +0000
Date: Mon, 13 Jan 2025 15:04:07 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
Subject: Re: [PATCH 3/5] KVM: Conditionally reschedule when resetting the
 dirty ring
Message-ID: <Z4S65wQcApuITa7h@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250111010409.1252942-1-seanjc@google.com>
 <20250111010409.1252942-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250111010409.1252942-4-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: 75a2197a-6054-4893-e8c7-08dd33a09887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YCI7Ht7AbKeZqKGDE5raCvKiwRtc+eChc05jGfWgud/HZEyuPhtpFONjKHUN?=
 =?us-ascii?Q?EAtJlab3apsliTMSpBp0vlj4yS/nzDEv5So8pI0sxjbTacCw/oUrOE1x7udF?=
 =?us-ascii?Q?bZkyHi/IN1xI5q3D0LQWAXYODp1lCkatVWLFJ34eI+MhQ9sQp7S6li87wAl3?=
 =?us-ascii?Q?dTwhfPgHE5sWHdd+LrLKA56BIyW+suLEyQy31E4uJnFJnYN3WbC5DuFTtC8j?=
 =?us-ascii?Q?DSdSHWoBwIreUz4QULfMn0tmXMMcjVHp9M08fyict7bp318QalM8mHUPVWu3?=
 =?us-ascii?Q?dGJZ6839lIKWGU0euNODzWjnawh1r7hTcS+Lx8ZL7lWJrKzN4LMDBLTbVHFN?=
 =?us-ascii?Q?dC2UJmEmBCU3Ggf8i87nvc8gkBAS3KGFiVwM4Si1SCxTgr7Ab0ACzKborKSD?=
 =?us-ascii?Q?VkHZFuyKy84J7Ez2UfT05pCd8hGm1NWhyY+dP9/urqBgt+V6C5VBRnoyjG/8?=
 =?us-ascii?Q?aX5mn8fN2d7SqQ0fe8ll6WJd7di5fzn0sNGx6AQQFiodhsMEtLfiHrU2WLz8?=
 =?us-ascii?Q?fwtiMAx1SczyugNm1qvQES6DyscwCSwlu5Jd2dWg1usm33FcmIGChS7yilWT?=
 =?us-ascii?Q?9SNDPQEFj53FEzUUqvZWMoIrJx9ojUfk/xd23JoI+BnwOVgSBpHPLLwivifY?=
 =?us-ascii?Q?OUxCYxySVLS6vuqi2l1trJZ1S0k4vLeP4kUfPqOgzrkDi/rCaUqPwIAOf6yi?=
 =?us-ascii?Q?2HkJIBF92KC60bz4LqiKUnnMLh4+AQmpxIecNVOg6YWqSzV8JSVAvGu207EC?=
 =?us-ascii?Q?bksgishj6uIagoa1ahRKNpCKOb2tKZ3awjsNHINVhcPr2+Z0UivU77q05lrA?=
 =?us-ascii?Q?3nMpEa5Zc/SS2VXQUPbFXr71kOnqFELByKjWl2oiIr7mCl+hfOHlVVFDguwQ?=
 =?us-ascii?Q?rlUnkV3HAqR9S8GXMSd0JeMgRDFjA5r5NliF6hHsEQ1DDdH+pIfBlPZ72Jii?=
 =?us-ascii?Q?3yTcLZE8z6rQLIfTXY4eJYae+ysA1Fx90Ke0t/4RFwGjlhDxjvFvXHXrYYo0?=
 =?us-ascii?Q?olr+g761xS/j/wZZdRuCufNYmeFMwmGtzLYjyl3TCHdtGtbJnO20hWjLUfJy?=
 =?us-ascii?Q?/xjQAQbmFX2fUagPGcSqmBJQNQ7ymjn312HNbB7gtBc+yo2WYzJX1sOvh2Vb?=
 =?us-ascii?Q?eqVbeiqCcZb5cMNmN8it/aPAro/YpMQqXohv3qi2M/Sdo2La1d7Mnr4FFdnR?=
 =?us-ascii?Q?/m1I+IyuUIhNsp7T4opyV5LLGpVU4TkBM2Mp2fw8mMikHh67UfPDZ20D2QM9?=
 =?us-ascii?Q?Vmw9ncF9SC1IsC6BFUS7621T2mb/ACrvs+xY2JeiWFjEUA44Shk4EZGig9wh?=
 =?us-ascii?Q?KQJMzjDej+65syaf5vws14ZfVuc4HqhZBgb9lQEqUoJbYUxp9v48EF9NQe8Y?=
 =?us-ascii?Q?KcUg43ZW9+rVp/oQzZKoKsyBA7c0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3747onzMCmOfoIXv0nf95OwYeL5bQs10PPkZnXkihCDpO+iqANuw1hkYB9YO?=
 =?us-ascii?Q?t3nF1I/nyGaQPaolMAsWSja/bc1sxI9IUhrSkrJzxxooxL/uxoZCDj/9A3n/?=
 =?us-ascii?Q?sZOv1uRZqChFIMFBhbG5dHcbgr+8779iE7DOHO4MgRLmpHsSzvs4LXDZujqB?=
 =?us-ascii?Q?Nwu9bGuWzuigRvAOkAUTYDrsuftPByr4CSriJGz2G/aBUv4GvQNgdXcDFTdK?=
 =?us-ascii?Q?1BYo6DffVvzvaR7CPbdX1FTUBup5YBw/kN7F9Rj+0RIMEaph7Oj4RG1AvlO+?=
 =?us-ascii?Q?WznO3DaIndJU0ZTE0t6uH9mW0gHSehnv5NFFhWJRGAuD+3CKlAiPxrjHwwZD?=
 =?us-ascii?Q?42RnGN1P9AQghW6CcsW4FftON6Qg0+L6sudxqMUuslPr0yDymBbfxcUS3TDF?=
 =?us-ascii?Q?b6mf3NARyiU8mIq1Zrs3dmE6tchqANsic/pfSiFx/+lKxuLF3mfylD6SWpz3?=
 =?us-ascii?Q?5KxaKTgGUraDjHwfcCL1uJa8yLQqA/NlYxVYZnrzUOaJ+jc8drj344L/AZQL?=
 =?us-ascii?Q?qB4TbtWBXnr8P1sM8H14ikiK0B8BiShaE9P02zGUuKODkvH4jRhZqrI6U47W?=
 =?us-ascii?Q?LI7HEBWsgxmZVZ49jhOWVwh/FWclaiiYxByKbwNv/TuI9OR3iJV7wbd2vXp7?=
 =?us-ascii?Q?gI3r0Eof1s3vW0BtcneRBqV7cQ8DvPdHh03XHzCnuZvw7NI1bShqW6TYLDyi?=
 =?us-ascii?Q?xhcaXHmKyVueznoblDw14FOBVpZq+iUuu8KjVBlreI5JHJDD5Md0dCPAmUVi?=
 =?us-ascii?Q?ScdMnGQfpv6JhHkvDK8C9/pPnDVovVublVIPP8ejmZkcFU1UWq3oh1+O6+kO?=
 =?us-ascii?Q?hEELibUMVJONqtBJBRrWX6kkdouDbbEqVKN3rnw9lL6m/I0T/D4d1vUu5Deh?=
 =?us-ascii?Q?M9MIKA+jQeuhJRZ0OFvAm1qS7llLH0CWp+HJhv83rBq3d3aQiMn3F1+Jv273?=
 =?us-ascii?Q?yvVFfJ4UrQ59IVGgOw+2/NfjmA8e/xOZevmz5faMFEBG75xcqOGAqP/5S4S+?=
 =?us-ascii?Q?wJKm0qrLZ5a90W5exJHOGV2vGMdWGSL8f/JcNfjT5mZc0a9SL5vGpmkty5GC?=
 =?us-ascii?Q?il2v9DBPXie8otPWxcoGc1REr3rPjYL3XZv1qZhOOq2KxRMU84CSAKeSLEVd?=
 =?us-ascii?Q?gCCtm4wOvx+LvXbUMl8Gh/MHv+8uydX2rf/fOmLE8dQBNOHA34NrGyeO8H7l?=
 =?us-ascii?Q?N8zE2vG4HX+IPcjW9dou4LIz20L2GDwD+IWJTcOVOy8U4TKV7lGyZ6k23C8m?=
 =?us-ascii?Q?d2kdgRTPNLx6eqT6hICWsUm+CMgkJIAMUNF5jsLYdEjC3T9o4XciKqyWCcgP?=
 =?us-ascii?Q?avkK4T5b5+z54TnY8S9UtPuWptFs8iQChPz07rXrIWuUrUzUxnwUrP4EH2Ku?=
 =?us-ascii?Q?QPNOL79b6Cb3JIVYqvZCBLy1F1HG1EnnGA8kC/kGvrOtwhqJO+JSC9XjOYAA?=
 =?us-ascii?Q?JM2KDTA4mfDxTuLUlQcIRah8Pwyg55pkq8W/pvDfpbWngfMbLSMeS1aN7A9W?=
 =?us-ascii?Q?/snvzJkSv/o1RWpnT8zrrfbyD6gpq8IkG0r1e8La2hT1UmbSx8GWudXqXZAx?=
 =?us-ascii?Q?iuGEBMdJ7QJdpr6C1fMh4rOMq2RMjZVZlkO9WeJy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a2197a-6054-4893-e8c7-08dd33a09887
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 07:05:00.4345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cDpnaDOdpro6VKKDzX7YMq1bhz9d+4E8uRPW7rJ0jUsRvRaL83Hqf2LGQRgADSW3pP+IesHkycD7iEt77DDbhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7904
X-OriginatorOrg: intel.com

On Fri, Jan 10, 2025 at 05:04:07PM -0800, Sean Christopherson wrote:
> When resetting a dirty ring, conditionally reschedule on each iteration
> after the first.  The recently introduced hard limit mitigates the issue
> of an endless reset, but isn't sufficient to completely prevent RCU
> stalls, soft lockups, etc., nor is the hard limit intended to guard
> against such badness.
> 
> Note!  Take care to check for reschedule even in the "continue" paths,
> as a pathological scenario (or malicious userspace) could dirty the same
> gfn over and over, i.e. always hit the continue path.
> 
>   rcu: INFO: rcu_sched self-detected stall on CPU
>   rcu: 	4-....: (5249 ticks this GP) idle=51e4/1/0x4000000000000000 softirq=309/309 fqs=2563
>   rcu: 	(t=5250 jiffies g=-319 q=608 ncpus=24)
>   CPU: 4 UID: 1000 PID: 1067 Comm: dirty_log_test Tainted: G             L     6.13.0-rc3-17fa7a24ea1e-HEAD-vm #814
>   Tainted: [L]=SOFTLOCKUP
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:kvm_arch_mmu_enable_log_dirty_pt_masked+0x26/0x200 [kvm]
>   Call Trace:
>    <TASK>
>    kvm_reset_dirty_gfn.part.0+0xb4/0xe0 [kvm]
>    kvm_dirty_ring_reset+0x58/0x220 [kvm]
>    kvm_vm_ioctl+0x10eb/0x15d0 [kvm]
>    __x64_sys_ioctl+0x8b/0xb0
>    do_syscall_64+0x5b/0x160
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
>   Tainted: [L]=SOFTLOCKUP
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:kvm_arch_mmu_enable_log_dirty_pt_masked+0x17/0x200 [kvm]
>   Call Trace:
>    <TASK>
>    kvm_reset_dirty_gfn.part.0+0xb4/0xe0 [kvm]
>    kvm_dirty_ring_reset+0x58/0x220 [kvm]
>    kvm_vm_ioctl+0x10eb/0x15d0 [kvm]
>    __x64_sys_ioctl+0x8b/0xb0
>    do_syscall_64+0x5b/0x160
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
> 
> Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/dirty_ring.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index a81ad17d5eef..37eb2b7142bd 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -133,6 +133,16 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>  
>  		ring->reset_index++;
>  		(*nr_entries_reset)++;
> +
> +		/*
> +		 * While the size of each ring is fixed, it's possible for the
> +		 * ring to be constantly re-dirtied/harvested while the reset
> +		 * is in-progress (the hard limit exists only to guard against
> +		 * wrapping the count into negative space).
> +		 */
> +		if (!first_round)
> +			cond_resched();
> +
Will cond_resched() per entry be too frequent?
Could we combine the cond_resched() per ring? e.g.

if (count >= ring->soft_limit)
	cond_resched();

or simply
while (count < ring->size) {
	...
}


>  		/*
>  		 * Try to coalesce the reset operations when the guest is
>  		 * scanning pages in the same slot.
> -- 
> 2.47.1.613.gc27f4b7a9f-goog
> 

