Return-Path: <kvm+bounces-55101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA95B2D4E0
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6F66724967
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 07:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E172D6E5B;
	Wed, 20 Aug 2025 07:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixEqn2jh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0826327602C;
	Wed, 20 Aug 2025 07:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755674976; cv=fail; b=pgKvPVXslghgi2pdS7O6Ixlblk3cTilNwXrDUzZl9jyV4lvQR1zAGyPpRxRgEi5D30TKLm7txnfzEs1zgR9FqHumA9zFFuN6RWYxc0G4h3kFarjiSf4UqbVLn2uIMmZJWoEbRhQU6l/+fjni3c4MiLdk6nZNwzN+yHbGzZqueu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755674976; c=relaxed/simple;
	bh=brcvN0NdUBMkEfnoYvJcf5pzzJqgnzYzMpQzW2fz8e4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gbke+taEf5SwY1awiQb1zwkVJ2/sjePevL94DxQqvhWA8YYFIiupFWWW4EXTVXWaDlscJZBWynrLWqwKTiPASRmp1GEhEcxMyUl16N1QUYyKmdIFWsEtMDtv6CsWgmwMUoDd+z36Pz0dOnFA1i8vXVHFhrSF9EhudOAjn2k4JQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixEqn2jh; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755674975; x=1787210975;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=brcvN0NdUBMkEfnoYvJcf5pzzJqgnzYzMpQzW2fz8e4=;
  b=ixEqn2jhwoQEfR3yOb4X+tzm/j9emuom+TghConOP1mRKARAaS3KdAjh
   tKr/AX79RIrKK++8WI3Op62Npmts1By1DDl8wQ7dVWOTh/dH1BHEYN8ht
   mVFWRFt6T9paTFmibz2a7ODaScJd5j40qZRSxNM8IU+SteakCn71lBxBv
   cIY93oPbHvXJ6QZKhRIULIxVm2hllLSC3mT1l7SGqoV+dh0zheZD0aKj5
   IaHkQkId97BAxH+Lh6fWhJ20yUxq+0ZNPEd7dci2I7KvS/k6ETL7w3pn4
   K4bYv7QDNUgdgUEDwHcd/tEHPCwKFtlMjWtKs/eKXaI1xo61cROIV7nAS
   g==;
X-CSE-ConnectionGUID: 7BWBC3ApTDO2nOtxX9eABA==
X-CSE-MsgGUID: ZBtz8wyMTpKKvSi70cGL4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="69382261"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="69382261"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 00:29:34 -0700
X-CSE-ConnectionGUID: ASRoQhFYSBOQT2naSUfz6g==
X-CSE-MsgGUID: dKDL36ugRE6WeDntbrY0SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="168464567"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 00:29:34 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 00:29:33 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 20 Aug 2025 00:29:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.87)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 00:29:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZpyMGHShyI/eC5Sg1p8mlbzlDdP4nPFXQiNRvQkO+lsA9XGkA8a8+RLN03Bamybfr340C9E+TF1tIvg2RIDF63+aghgn/j7mnk/iQPMOeTlNDboqQjN7JmrXE1YeON7fVrPDmGTVj7N5+/o66vB9yGn8bqJI8XcGpzV45JqBMh5eoGzHw02QOZHeH7yzH98M+blkLZqrsMdiwqhfhvHjn7fpaxKMwLIWwYIo0MZlJyCoeTIBZB0D4DqRmI6NqkaiLednFyT6nArBJHoaKni3gaPQt8atQTzhVqaRBSVYdpwmD9h9Y/THHZB8GBd9vrmzcAf4erSnjTUJR/xsheBtmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqt7DqHnzoW/0z8Mu4aSFSoMHyAe8OwOx5HKGPCW45s=;
 b=hp2Ywk+sB3t7lwAUqOElaKb7H0Qr8EcMIymLwEcuGflz5YqmH3CowiYMWJnw8fZbHynnbgQ9zKJb707c6I/TwoXzrBhaalVGNYaFpWZE6Lih0zO98T3oAN6x+2UgsgbehKeHAowipHuA08vqmXWKcSoe+ez9GSc3lElqObpLcZuGEg9JTcdO3e+Ay1k44kUaWN/8Va2HJsNA0w7edubItdKm/1sr9wjX4koz8EBEw+9C70PbrjHU7f5mxVqi1DRaUJU6qrqR2M6QRiZ32BZW4b8KnC7sMx6vRru00/hj9cYVlVznyZn4QZT6KQk9friTK0unba5KAZm1eAcdb65OsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB6543.namprd11.prod.outlook.com (2603:10b6:8:d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 07:29:31 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 07:29:31 +0000
Date: Wed, 20 Aug 2025 15:29:19 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mlevitsk@redhat.com>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <xin@zytor.com>, Mathias Krause
	<minipli@grsecurity.net>, John Allen <john.allen@amd.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v12 23/24] KVM: nVMX: Add consistency checks for CR0.WP
 and CR4.CET
Message-ID: <aKV5T9xcfdBBNVYK@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <20250812025606.74625-24-chao.gao@intel.com>
 <aKS0EADlViB2Mg4e@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aKS0EADlViB2Mg4e@google.com>
X-ClientProxiedBy: SG2PR04CA0182.apcprd04.prod.outlook.com
 (2603:1096:4:14::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 50f4118b-8b45-4523-f5f3-08dddfbb4d4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bVN9GOpJQBnkuUz5fYB48oWoEgYN/CEOvcK17JadVAt8dmHRDEgCGtjANdxk?=
 =?us-ascii?Q?9PUXeG9Dc0dmXZAmHLAgquOB6c/5QN0jOKjk5nTnGJHzohTX5vGgzEXaNgKf?=
 =?us-ascii?Q?jcUVQqKlxsU7gWt/BNivqXyu89GW4j1drlLRbXAsjjkxPWkP1sw+HsHe8JH9?=
 =?us-ascii?Q?jOKaSpw/WtBYZrTOaKYypa7pT/WgXy/N19NTu+zKL2G/1XD3YzjLy52MCOCX?=
 =?us-ascii?Q?zai0VYfSSo5RefU0qqwFwUkt+FHQF0xpFpXQpGEcVTZTm7IfcNLTj0ptSH5Z?=
 =?us-ascii?Q?FS079rQeFbLhcAP35C44BjxGrzbrTyG4KtYjHl6ltkwosmdsDFgAqM2P8PIt?=
 =?us-ascii?Q?vtP0TipwDQbXez9Ykkoe5co56Ks+8eBFFTLWF9pu3lKbSk/kC7QhJhahMtyw?=
 =?us-ascii?Q?vDPMxRTayCmd+QgIAL435W04u1gl4Wj+YfNHVtCg60jJ5NC3SKqT8HbuDC9m?=
 =?us-ascii?Q?VSiR4PhNRNY2cYgatVVVlyKOR64fT0f48oLs1J/pi2++2RUUdgPxgO/qnPzR?=
 =?us-ascii?Q?RnDzM81m5JJAw2mqS3HRqa+ZMtH+CHbgbk02kG611LJwVDxVWnO7eHnN23h6?=
 =?us-ascii?Q?ovVskgFSdEoH8B/lqrmDqHJg3B8o2ipI1q7vYPiIRu2xXqJs25Se212ycGja?=
 =?us-ascii?Q?r8AqcbV5oqOKY1I93B6s+6+xcB7Mw0MzJsDOl8ZXI00fQ+oVhrHGNX1v4OIe?=
 =?us-ascii?Q?tD2KWVpFvam3gh0gWZVHYbJ2goDiAJBvFcMLhg5Fbyz77yzdjzvEItU4Fkw6?=
 =?us-ascii?Q?KeBhdFO1ye2ho9Ye2vLXDQWIXt5YF1mGoUxPAcdzKcRUP4KvDqRXoPE2L1Dk?=
 =?us-ascii?Q?r7bKz+Lib0lCwr85Jv2B6F2XnlNzgKaN01Pn89iZdjVICSlMv93/+lgfhfd/?=
 =?us-ascii?Q?tfrz+4UchJ5oGA1qaaSOuzKXWv4ZffanbTncAKfz6Qd9bC6oPT1Xqa3wYw7w?=
 =?us-ascii?Q?2JMEzz0SVM9f9ZO/wuLReyLeSW//X9Y89U5OSz3ThsAIttzIkblTqE11c7QK?=
 =?us-ascii?Q?prxThcz+c+T2e8vIYObu7Bv/8xUXpS4hEoSyjKzFCUk7t6CnM24Im3V9ZT/P?=
 =?us-ascii?Q?70erWxBKGq/NGdembi6/mJMceqKA6pH25s/dtETi6w6lKq1vqUBDopkXP8lU?=
 =?us-ascii?Q?aSjF/MuCggJORDkClkclCTTSw7q85I+zvcYiu/voVAd1uTXlH2SA13nw05vC?=
 =?us-ascii?Q?z5HIOD4RlXzxrdU4QMp/s4Ss3gtSCe3qJ1keyicAD8YxCSmJjOxo7M39pEBh?=
 =?us-ascii?Q?pJOhnntci/LE/Ovqz7uh5YusyyHzdOHKrGEiN/wR0X2YN2zU3UlGoegpQSdZ?=
 =?us-ascii?Q?lSPNYNTJH09XUkPEqBYqUoLSFWl38guRKUtHb/A42nfdbS4UsfVv5IAVrOOu?=
 =?us-ascii?Q?qKCkAnQUUtnl/WJqf4zg6K7hshYM0zsTQXqCPANXwg7Gsa7m2A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ekbwRjdj85LZ5Fx4WgoVrZkf4V6yzgA/qBXJwsHsrCZST1TVutkoVgkik7Tg?=
 =?us-ascii?Q?exgh/0DYsgt9YyfuC8Uvn/htZ06Rjm0AOuTxxHEbzkTunuQaXDUDHHYGZK19?=
 =?us-ascii?Q?T8k+XdFazdqaL6MSbAYROoj3a42F3y8K/41LAU92J9RAASj+laFrVHp6flvk?=
 =?us-ascii?Q?m/k0AFekGWedSZ93efOFagq5CyMtuOEUYlqB5J47yUfu3v6qx/bHO3jTsoWr?=
 =?us-ascii?Q?xFZP/3ajSEQZATqIUcCZ89oQanqHNldRi540wWfAICMh/5oPlxGBPhgxHioJ?=
 =?us-ascii?Q?wE6au6oNgCCa+TJu9JIs2SDw+0gRXj4qpSWHqiRZZgFkwvgCAfhz058CjZY7?=
 =?us-ascii?Q?QDvQqVOctjeBlpvRJOqIqxuKxW+mApSsTzWAcV6md88+C8GJFWQNUkKHPX97?=
 =?us-ascii?Q?ymjPAeKsDt7/azPRfuENZOHZlHl8qfqIqFPLPC2LT2BLLENOPQpPqDjDLBkL?=
 =?us-ascii?Q?17v0NZD+gfdpbdlvUw+WOY8gvE5yF6R0PFafFZ9DCxCOxqiYxNWuXczfG+Tr?=
 =?us-ascii?Q?yPMGYdzC/255AXqVYG67UVb/4jOz01iE9M5dSY0T3Rz0MyqFDIfQ6urJRLHm?=
 =?us-ascii?Q?kkbn+7qoENFUkndzE0kzUAFfjbS9duZHWw2hmQ4oGCUIhcS7lD11BLm1m377?=
 =?us-ascii?Q?qKJvHoXhS1pVEaEuS4izdLZc3MFXJ5qjWmE1B/rQ9nUtilYhB0Pb9Ti0RXVK?=
 =?us-ascii?Q?6QlM+XlRf/LMNHXhMH3L9NsSnlw01GO3RqTHbG1P/j1Z6h6vHB8NygP9fyV6?=
 =?us-ascii?Q?SlihK+F7n9ZNYK+wz6Ygpec435QC7Lt9dK8Thfm8pzkFK3tpIeI5MyN+p5TH?=
 =?us-ascii?Q?7p3MK+/hI+LSRq6FbwXzYcMnMHnBCK3X888O0na/S0kFVKLZkeB0j5Od2RMn?=
 =?us-ascii?Q?SM3BW8YkdRdk7ejmO5NPapN6p8WlBCplUIGMHgzz234C188pX4wm0NPhQtU2?=
 =?us-ascii?Q?vQbnfox/OBlOx+zqz1HCbz+3wxQlr3PtCGSmFC7mSJBp3/jHSu2x7RG25Hst?=
 =?us-ascii?Q?NuCTc2NvCO0NSxOFk21H7guPQc8OpZ+6gv1Z7Ud87NHMDY+Xa3q4wK23nhGW?=
 =?us-ascii?Q?NkdZQ/oPNcF0u5NkufqU+I4ukm1qh0TqnoPWMBRbIXDtKDe1x4fbC8VTIbE3?=
 =?us-ascii?Q?YjLdlL7XE7qtNosM3IYQiLQvFl0syN+ir+qOOzYCS7Jdjf4A5XiKvZ/xkwXq?=
 =?us-ascii?Q?w0wzZv+8njeoy3T+WyMMx+ZLFMafSAbgxA/7bAqyhfjp7eJ4AQ2f5IHq5dGP?=
 =?us-ascii?Q?LMaCGSd6qiJp/ldOFSrSv+xSGiixQ/khVrhPA8SuzStKaMfJOzi2T9bm4m3p?=
 =?us-ascii?Q?SHT/cVJuPebGack2yMRdltre/FVHJKaBDTuTW5f/rxVxBZeBwp/VDOyAXqXl?=
 =?us-ascii?Q?8p2tMbYVmfE5GkuRhB/wNk70B8hIWkbU5Yaa6d29XC4QZx0+JYR3rD0LV8+D?=
 =?us-ascii?Q?9u3VJRhIDw96eoK5LR+wivhwStQgGOEB5zQkLtyhXWdKDJpVGrYuFOTaRfeh?=
 =?us-ascii?Q?5yYkwxtw4/zzfbYkGWmNU0ei2KF6Yc9Z7OpAqbn+5VE5Ccnpjr6MMGYZ8406?=
 =?us-ascii?Q?376qjLj17ICiG57ttv4kAXt43Rc94PLFs7eZ4Qva?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f4118b-8b45-4523-f5f3-08dddfbb4d4f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 07:29:30.9611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OuH46x0WbJPDae+gBqfJswQijJ3BP5FzW4ay/TjBm2ZjwK9uyJrI2h4aokn/rEGk5dbt6etFxZ41YwbdFzA1yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6543
X-OriginatorOrg: intel.com

On Tue, Aug 19, 2025 at 10:27:44AM -0700, Sean Christopherson wrote:
>On Mon, Aug 11, 2025, Chao Gao wrote:
>> Add consistency checks for CR4.CET and CR0.WP in guest-state or host-state
>> area in the VMCS12. This ensures that configurations with CR4.CET set and
>> CR0.WP not set result in VM-entry failure, aligning with architectural
>> behavior.
>
>The consistency check patches need to land before KVM lets L1 enable CET for L2.

ok. I will separate the hunk below from the previous patch and place it at the
end of this series.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 51d69f368689..2c8ee37debb2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7123,7 +7123,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
	msrs->exit_ctls_high |=
		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -7145,7 +7145,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
 #ifdef CONFIG_X86_64
		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
+		VM_ENTRY_LOAD_CET_STATE;
	msrs->entry_ctls_high |=
		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);

