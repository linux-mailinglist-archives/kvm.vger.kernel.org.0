Return-Path: <kvm+bounces-23928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF17B94FC32
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 05:26:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8A2E1C2234C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 03:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88BAB1BC44;
	Tue, 13 Aug 2024 03:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ilG74mq9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEDE1862A;
	Tue, 13 Aug 2024 03:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723519554; cv=fail; b=XrQ1YTWMqP2iEBdaq2OL+BQyJglGspoq3dDt8LBF84oIbLweIzgdCEDRe0RQo+7gxjGqclgm0plfF0cktjWKluLJz3j6zFyhzdqBNuc9N/XAJyrrDdi9fPVr7hmxuvl1E9mh54uFSMqQ3KZUPdS/OGMKbKgG8zQ+2MzxztD2nzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723519554; c=relaxed/simple;
	bh=z4jA1NmegwOIxcOZgK3AKNQiMtt3J852DQpPIphB7vs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YQjsa4FIXiw+tvaVio4g02trBwrOx+fZBxcAsZGYOG6TcVsNiIAvZgoGJFOsVRvILU2L9RrjAlxBGiMzO+iGqz8empzuX4DgVIDUEqYgfeS+Gvh9gP8aqESBUg4RXoGhfa8+S29mI9vrozSGltCCpiYFFEVxsdSLJkiZJJGe3NE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ilG74mq9; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723519552; x=1755055552;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=z4jA1NmegwOIxcOZgK3AKNQiMtt3J852DQpPIphB7vs=;
  b=ilG74mq9jADj7Br3iamgFr6CD4S2dve1vH4hL3tIquM+0LBXc6XFMneh
   +5SmKyOG5GfA8syMBqjs2qF8+woZwEYyQcZmLh9WfcJfVj3HZA8Ffq5pZ
   DHJqnS5ATbz/mSAqmQsTBBdOHOWeigJJb5DYNxomg0Sz09JIk3IumgyaJ
   psXoG4uloBK91k7FFcF7rF3efgpY/DrJpQ7SshPW9P08rZKREsVrJe/tA
   PbM+mceNCqjlHyf3c2YIPfrjpGVHGROSyiV7BmKoPfzvfNL5Iu1LKBOXp
   XKl8RavSjZhAxmM31FugyZ1RRIhgJ0vE0+R/+YwfsCR5HA9GqPdZ1hM/h
   A==;
X-CSE-ConnectionGUID: s2WY9GzeSOuyNoTKriOkZQ==
X-CSE-MsgGUID: 5kxvoXdRRAqF4Lx+/Cq6Aw==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21801382"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="21801382"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 20:25:51 -0700
X-CSE-ConnectionGUID: A8He0TM8SseRr5kmjMo06A==
X-CSE-MsgGUID: SvEplbZfQbmZl6kjMl4kXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="62675033"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Aug 2024 20:25:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 20:25:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 12 Aug 2024 20:25:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 12 Aug 2024 20:25:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zRK0PILG2uRsbb8a+LNUvk6WJ/W8T95ExXllx7PjOuHgoDVX9zYd2FkrXifNWI93bLYgI7RWGvDoMERnecsaJ02a/HnbXaVHWqNXXhZvIWzgSSbVnV9IV4aI6UBhIQGWSHGp8BXBQ9MtZ6yh+8WZwW/mXJooeSz1XEADCu2y+f48NwrY+dP/cS+IqUv457qunjzoEdQyqCIWQsH2293qg3P662rnabas7dsA2qJPHFd7MV3ZrR2WqUVDg+W8QtLk4T1OildmkAwQ2xrjl1jZd8J6Ts8a3UvR7mm2DP8EhzbZ+NsdiBbO1VTRXGTwn79gkXGu7F/olQSSFzfjLUhL2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqGuL0xYmtPs8ZNpMArfB4Th3cStcBnxoUHHIKUXKbg=;
 b=S1kJIkvvEj0O6UxfJVbP47ekNstIztPWjIJdzf01LsMujEGhLuO1j45a6Atdze2r7AKbeaSLukOiPxtee8DPkUWI3g5DMYN7XiKEJ/5cN6A3FQoRDWB/v/JTGyJIkWzyLdjbB4Fy3v0xq9neZLus+9bezC9Dp1Vk2lN/Kn+4kWEzwHvXf/5n73ESTRBJV/EMfj3cOTB+MbCOpfceo2VJVNUw8+DZ7zCzFaOH7iyqaLmS3rIKg+8Cx0bteYi6BF/5JV/UlvK89BVYY8AGyEat4ZD4q8IiztnRSyNjZNcP4MO+zrvx8BuGRYNuZ73kehfLPCB41LqRYI0X+Cj1XrGupw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB6248.namprd11.prod.outlook.com (2603:10b6:8:97::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.29; Tue, 13 Aug
 2024 03:25:47 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7828.023; Tue, 13 Aug 2024
 03:25:47 +0000
Date: Tue, 13 Aug 2024 11:25:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <isaku.yamahata@gmail.com>,
	<tony.lindgren@linux.intel.com>, <xiaoyao.li@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Message-ID: <ZrrSMaAxyqMBcp8a@chao-email>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-11-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI2PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:195::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB6248:EE_
X-MS-Office365-Filtering-Correlation-Id: 926763c9-fbf4-437a-9c29-08dcbb479f63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?h+pOkYNAtE3YR4mHOsw0lmD2+smTk1n24VuSb/OSTygYpcLf8kj2Vz3a3Pqt?=
 =?us-ascii?Q?EEgS41ZXyqq+k98kAxhzTvF7q5CyrXbL81HyLjg3OFKZKo0sCvGyumWIcXwu?=
 =?us-ascii?Q?lkzJ7M+O6bH5ScAoCWpbYLxtBrF5viesLzSVTC7rkt5rq06ziNURyhOxWcYR?=
 =?us-ascii?Q?ZbRXdPD3JSBfHIuBbjgxAwk5Z7WiFN3VJD0UdEdmDuMzicI3JDH4Hbuade00?=
 =?us-ascii?Q?jck5dfnlnb/FfG3vcuruScqrhVn126TcEezwW8NEiGYTKjEw6tdr46ezfe7q?=
 =?us-ascii?Q?RbiCjc9GAVPLh0UOD2FdvFdp34aGKsnk6fIPEZZbtsEVeKRd09DATgcC6D7s?=
 =?us-ascii?Q?P0bDbhoELze3xXoPbapsN47a7F9c7Y89+1svqM6yu0FMcmgK3JSv+q2OBRK7?=
 =?us-ascii?Q?no3WHHTrvg7RLiBREybgfJ/2gVgBuI8+A6LdNgY4U4titNsoU8EpklBtRCLd?=
 =?us-ascii?Q?SFKGwzpU+ubW2lvetXuX4TIt3YYgx6nGamU6lf32EDGQigZzv49wlN2eNge6?=
 =?us-ascii?Q?CdffDrKJsfyx5Vf5dqREYkrfvbLcQnNq7RtOC1xeAXVF54lFQDtxlmFZngdM?=
 =?us-ascii?Q?o4eAuOwWpWIvA9rcAAQ1Y9p3Yz9pE+Pz71589cUiutihcu2fyc4knaFGdzm6?=
 =?us-ascii?Q?uxUy/KtZ5AvvFTh/iTUuAbZraKY9ijul3ySb0/0SHD7Xzi/0eJkMaWM5gjjx?=
 =?us-ascii?Q?0VAH/65hcKlJSmS0CYfCTvOSLyiGS0OAYbufwYqp/iJTpIDSsaEBRSCCCjX2?=
 =?us-ascii?Q?JnhI3QEQK/LNS41hsM1/OqbRikeloW0OOhlB8C0uej9eLB+kepXIgXAUiWAE?=
 =?us-ascii?Q?mf0YBnzfHatwjzzhabAcaCzrLECOwQfLDyaSCMXiTwJVSD/0SdmeFwkZPn5Z?=
 =?us-ascii?Q?45j8vOfwGXVz0qlDw01wPHukVPPJmP4Rzgv+l/uW23Kp8reJ2OgDulOkdbuv?=
 =?us-ascii?Q?JmYh/icVhmqVB6UlzW7fO44a8cmKHTvWiea/4E87JzQohMvtK4XeOAKhkYeJ?=
 =?us-ascii?Q?2ezeBenkkR6rHD5qIp4NOl87w2mk8RvltTspnZPLBKWEQytRAIbIQGKkxrgg?=
 =?us-ascii?Q?9pRgrqCEi8NLZOXQrmuIdtRsf7iMxFSGSPFvwi7csUuEyvw0OFygCSB6mKIC?=
 =?us-ascii?Q?KGONZoP1+yMpUrPDdLIQ4dfuZHVI+DbXvRCDGvUxVpmZiZzKDcUQnGYcK3vz?=
 =?us-ascii?Q?+sxLt4R9XvXNkvTiatHqlR7urjis0LWAeUT/KXMSRV90caKTkcBoK9Zm9j6S?=
 =?us-ascii?Q?K6u2S/1+K27kcBxzjgQeN1R4tFGb1B8fUt150X1qnR1fGk6BV+EDvEgSNJMm?=
 =?us-ascii?Q?ZPLsucUBJ2T/fokys7QR8NFckCqkuvch2HhP7/KGL70Crw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NCHBRwSbFWo2dNSduOZaj2nOOcYyzyXfLACFpTIZfgIEGheXlzcBcDJQm7hq?=
 =?us-ascii?Q?hMRt9reox8IhxrhXBmr1sFmGb5vzgSo/qaKOMe4MhTk8ZwLb7RgFLml7Yxjl?=
 =?us-ascii?Q?J9tbVKSXEnM8CZVZz3KlFDzt/8TboMqy7GrQhE26Aw4h7bFRS5vg6TEuVveE?=
 =?us-ascii?Q?71Iuu89f5xBPoFljAmhbsfAQNJmQ3cyjPSc28B/JBzDIYY1iPBadhczKSo2w?=
 =?us-ascii?Q?06dq7vvxr9s1YioIhodtyz9giyp1P/9JGLxv8iHblYf+yksW8y6WElHOHtV5?=
 =?us-ascii?Q?/nG3xW3hNt8JATKRBoZH9wfbMSdGey5nHA0fpeNCCvmI7UkF2LCMC6zlojGk?=
 =?us-ascii?Q?p/JGXVnaIg8f1/uB07vniEuJf9ll+Ejd+85uAHOzo7Wcylzbd1Ax37G2fiXx?=
 =?us-ascii?Q?i9w1CkL1s+84nSid4YJb9pCoLFpqprUrF/WCwiMprsNjQEPBJdoVcEcipS9Z?=
 =?us-ascii?Q?kvOMpxKZqY9M0Cko4v6pusKtrmOoD2EcXE32fbCT0Q5CcB0UeVTspRCHe89A?=
 =?us-ascii?Q?z4m4D6RjUnBirVrB9ZGUYUcNT6nFddkTgv0Vq3yGVFhhA0DQiwnYqZkUTsrs?=
 =?us-ascii?Q?qttPiklzUJnfdaQPT7gHDhZrNIyx0AVMagRYqGTQoA4SCbOxcRCBnbjsXsLn?=
 =?us-ascii?Q?+YBHGfOv6Nq9noFsLJlPR0Flau2ALrhQz4zlBlLUMS+UpWbtiaAY1BR/8JP/?=
 =?us-ascii?Q?KZIyrGPIE8/fNB5LI69ah/p47EdjYEbyB+yb3lgBwXsn9f8MRJ2mvsdDZKD/?=
 =?us-ascii?Q?UoaHZCnIQyE3dhkvU3gj5NAmKwbLlsjmqwIHfhyNBMwuUGUsP4dF62nyp8u7?=
 =?us-ascii?Q?TVmeLXdE74s+pjg6MpsQgqqcoNmNPtLFjz1qoS93Uu7HZsGH9O2NTz1jkoxi?=
 =?us-ascii?Q?RDOPnAJBOo+jNoGDfMrKQnhrb0a3UWTD10axKzKf65z/jxZIRYUlr5ZjkQrE?=
 =?us-ascii?Q?WooBG9jFZez21HGA/rhGXVA7XBz1OtPQS+nX+0Mv/Wh/qmvQC/swlR0q1hU2?=
 =?us-ascii?Q?mAIDzjhAoVa7kTzpz5O/lwSb238qPNvKONKrPZJf1dbG3QY6fY/ES+MIaeko?=
 =?us-ascii?Q?iVWtwIMaziIP4v+HNdquB83nVhCvdYGRxEO7mnxHYiiH4FlkKum/sRTOwQPe?=
 =?us-ascii?Q?PUoCbf84OyXvnbJJ8ZEac3cuq1AI3/zXry2aT8xnfZPUWa9+fZjoo9duS7Cx?=
 =?us-ascii?Q?UJlRLy86DS50xxqs1L34+wH5HF+0ycq0kzf38lPAGSDKi0We6FJ+S6o77wId?=
 =?us-ascii?Q?4dGiwTnD4TZrBIDMQosqgAByOLQzAxh2T13Vlb/6h/eec1fdTABJQgT9WhQe?=
 =?us-ascii?Q?Aqv5Dr5uliKB/FO+60B/nX7jAtr5kROUzcixmeSVZwkOg9r0VgjzYm+x8Jzr?=
 =?us-ascii?Q?Gr+gxMxRKhsNY5fi729/OS6kgsOslKCbBCKfb2X7Tbbg9js4Ri9CeZFFT2I+?=
 =?us-ascii?Q?cgM2rwdppc9Zi8pvLu2Hwy2S8S05UqO/lBqbvY6UL9aVS7YHVl6qmM1/fr2X?=
 =?us-ascii?Q?NiXQCvFczc7bRYg3x9P04lj/XNZsED8TQRsZOk3Kn+GBUiMgXpjsgC/U+6VH?=
 =?us-ascii?Q?B5LTk0lSUxlhfzCH3ByNjzTERcQA2yT7dm8LXAY0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 926763c9-fbf4-437a-9c29-08dcbb479f63
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 03:25:47.3107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V7YlO1BeDiZUfLhP2/EefTx8K9f7Aa7Vnq6ikb30SKJ3VzJ6nMQCTBpYdoReXJPn99XoXokllswNnG2YU6RHaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6248
X-OriginatorOrg: intel.com

On Mon, Aug 12, 2024 at 03:48:05PM -0700, Rick Edgecombe wrote:
>From: Xiaoyao Li <xiaoyao.li@intel.com>
>
>While TDX module reports a set of capabilities/features that it
>supports, what KVM currently supports might be a subset of them.
>E.g., DEBUG and PERFMON are supported by TDX module but currently not
>supported by KVM.
>
>Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
>supported_attrs and suppported_xfam are validated against fixed0/1
>values enumerated by TDX module. Configurable CPUID bits derive from TDX
>module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
>i.e., mask off the bits that are configurable in the view of TDX module
>but not supported by KVM yet.
>
>KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
>and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.

If we convert KVM_TDX_CPUID_NO_SUBLEAF to 0 when reporting capabilities to
QEMU, QEMU cannot distinguish a CPUID subleaf 0 from a CPUID w/o subleaf.
Does it matter to QEMU?

>
>Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>---
>uAPI breakout v1:
> - Change setup_kvm_tdx_caps() to use the exported 'struct tdx_sysinfo'
>   pointer.
> - Change how to copy 'kvm_tdx_cpuid_config' since 'struct tdx_sysinfo'
>   doesn't have 'kvm_tdx_cpuid_config'.
> - Updates for uAPI changes
>---
> arch/x86/include/uapi/asm/kvm.h |  2 -
> arch/x86/kvm/vmx/tdx.c          | 81 +++++++++++++++++++++++++++++++++
> 2 files changed, 81 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>index 47caf508cca7..c9eb2e2f5559 100644
>--- a/arch/x86/include/uapi/asm/kvm.h
>+++ b/arch/x86/include/uapi/asm/kvm.h
>@@ -952,8 +952,6 @@ struct kvm_tdx_cmd {
> 	__u64 hw_error;
> };
> 
>-#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
>-

This definition can be dropped from the previous patch because it isn't
used there.

> struct kvm_tdx_cpuid_config {
> 	__u32 leaf;
> 	__u32 sub_leaf;
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index 90b44ebaf864..d89973e554f6 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -31,6 +31,19 @@ static void __used tdx_guest_keyid_free(int keyid)
> 	ida_free(&tdx_guest_keyid_pool, keyid);
> }
> 
>+#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
>+
>+struct kvm_tdx_caps {
>+	u64 supported_attrs;
>+	u64 supported_xfam;
>+
>+	u16 num_cpuid_config;
>+	/* This must the last member. */
>+	DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
>+};
>+
>+static struct kvm_tdx_caps *kvm_tdx_caps;
>+
> static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> {
> 	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
>@@ -131,6 +144,68 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> 	return r;
> }
> 
>+#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
>+
>+static int __init setup_kvm_tdx_caps(void)
>+{
>+	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
>+	u64 kvm_supported;
>+	int i;
>+
>+	kvm_tdx_caps = kzalloc(sizeof(*kvm_tdx_caps) +
>+			       sizeof(struct kvm_tdx_cpuid_config) * td_conf->num_cpuid_config,

struct_size()

>+			       GFP_KERNEL);
>+	if (!kvm_tdx_caps)
>+		return -ENOMEM;
>+
>+	kvm_supported = KVM_SUPPORTED_TD_ATTRS;
>+	if ((kvm_supported & td_conf->attributes_fixed1) != td_conf->attributes_fixed1)
>+		goto err;
>+
>+	kvm_tdx_caps->supported_attrs = kvm_supported & td_conf->attributes_fixed0;
>+
>+	kvm_supported = kvm_caps.supported_xcr0 | kvm_caps.supported_xss;
>+
>+	/*
>+	 * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
>+	 * and, CET support.
>+	 */
>+	kvm_supported |= XFEATURE_MASK_PT | XFEATURE_MASK_CET_USER |
>+			 XFEATURE_MASK_CET_KERNEL;

I prefer to add PT/CET bits in separate patches because PT/CET related MSRs may
need save/restore. Putting them in separate patches can give us the chance to
explain this in detail.

>+	if ((kvm_supported & td_conf->xfam_fixed1) != td_conf->xfam_fixed1)
>+		goto err;
>+
>+	kvm_tdx_caps->supported_xfam = kvm_supported & td_conf->xfam_fixed0;
>+
>+	kvm_tdx_caps->num_cpuid_config = td_conf->num_cpuid_config;
>+	for (i = 0; i < td_conf->num_cpuid_config; i++) {
>+		struct kvm_tdx_cpuid_config source = {
>+			.leaf = (u32)td_conf->cpuid_config_leaves[i],
>+			.sub_leaf = td_conf->cpuid_config_leaves[i] >> 32,
>+			.eax = (u32)td_conf->cpuid_config_values[i].eax_ebx,
>+			.ebx = td_conf->cpuid_config_values[i].eax_ebx >> 32,
>+			.ecx = (u32)td_conf->cpuid_config_values[i].ecx_edx,
>+			.edx = td_conf->cpuid_config_values[i].ecx_edx >> 32,
>+		};
>+		struct kvm_tdx_cpuid_config *dest =
>+			&kvm_tdx_caps->cpuid_configs[i];
>+
>+		memcpy(dest, &source, sizeof(struct kvm_tdx_cpuid_config));

this memcpy() looks superfluous. does this work?

		kvm_tdx_caps->cpuid_configs[i] = {
			.leaf = (u32)td_conf->cpuid_config_leaves[i],
			.sub_leaf = td_conf->cpuid_config_leaves[i] >> 32,
			.eax = (u32)td_conf->cpuid_config_values[i].eax_ebx,
			.ebx = td_conf->cpuid_config_values[i].eax_ebx >> 32,
			.ecx = (u32)td_conf->cpuid_config_values[i].ecx_edx,
			.edx = td_conf->cpuid_config_values[i].ecx_edx >> 32,
		};

>+		if (dest->sub_leaf == KVM_TDX_CPUID_NO_SUBLEAF)
>+			dest->sub_leaf = 0;
>+	}
>+
>+	return 0;
>+err:
>+	kfree(kvm_tdx_caps);
>+	return -EIO;
>+}

