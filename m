Return-Path: <kvm+bounces-69957-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHsbIDo7gWmUEwMAu9opvQ
	(envelope-from <kvm+bounces-69957-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 01:03:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 00121D2D09
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 01:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BB8C3041BED
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 00:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C721D88B4;
	Tue,  3 Feb 2026 00:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kw4N9zju"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2444617A2EA;
	Tue,  3 Feb 2026 00:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770076837; cv=fail; b=Q7MqmGr7lY5VVZBgsJvkQr8OZUqgP6j1LWXzw47OxhgbqWMSDGLtTD6zoBn6DJseUheISrdasuYlx8zgpI4uBpR0aI3Wv9nsvqMi0TFMnJsQmlNZQMezDsY5p0cf9CWQ1GkrUMinI5i2SswpPEmo8VqpPdjOu1sqM7PMGkpKEe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770076837; c=relaxed/simple;
	bh=HOPSFPip0WMsgK64kVUgbLTX7AmUwh14ViMEmOrTyx0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qqmJngwllqjnNwVtEo9mQdvpdW/mXBIxy5Wljuws0gVRd7DpLd1vxrJjReu8QFMmnQAmX5xBmsgNzEzLVAcLrG4AtthHYHB6Yj3zXbco1ef9vnGE0ZFc4UUuMOpOvoo51jLFRsBqt74rG8q9zX1qd3RLb+smKX2bpBKzP+4M4tc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kw4N9zju; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770076836; x=1801612836;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HOPSFPip0WMsgK64kVUgbLTX7AmUwh14ViMEmOrTyx0=;
  b=kw4N9zjua/YNUFokCuHvJPQFyeIWonhx6Jpqru6MyAyj+l5ckq04lR7q
   mvO/DrvGhsXSg/9tZqgbjkklW/BD8fJQ4OAJuRsJtIXw9hU+m33HRmWuJ
   MNpHQy6mHRvtPEa1z6w3/ZZ9k74alADTfL4SfFWbxG1MSpMbVlIN0de77
   VNbRbR92fnXuBg70x2FKtTxcxzvrojxVekiQ6L8GTOjKjm7dGln7lXXu7
   rq3V10Wqz2Hq8VEuWN7hk9zEljXofVTDHx88DQHouUyz/7IkTrvbTCmJT
   0Hi/OZGFAQvJBsOtRcKE1/OQXK0GB/20bns/vaft6AKwW6QgKHC2qlSYW
   w==;
X-CSE-ConnectionGUID: gbsez+S4R8CNvTDYrzOr/g==
X-CSE-MsgGUID: FpHYLCtQSGOidMWYgaWU4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="71405895"
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="71405895"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 16:00:35 -0800
X-CSE-ConnectionGUID: sBLNyVJSRCi4Vjl8fo9r/A==
X-CSE-MsgGUID: g6B8el7bQfGc3V1uB2BQdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="209673538"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 16:00:35 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 2 Feb 2026 16:00:34 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 2 Feb 2026 16:00:34 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.3) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 2 Feb 2026 16:00:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pGgp4JOirDz8X7aITPDXcoqg+MXlc/tNRhR4ksnU5RLAk3R1cwjkxx6rr6v3K/Y6p3VhpezbadPKbjA9AGZWjczbgW+qyRZ18Rh64aDnHJQr2UdeSlBS4T8x0mF7vYcYyqZiL1bQMOux2mpWiFEhdSFKgNfJd+yJuGsAS2dr0DLLsPKkAs6JkY3/5JiuMA3fZF9JGdxYfK9C/DG90JZgVJHIVGjlCYNv4j8NkiWWxkwKDhY8Yxu44ZHhpkEirb7Pup5bvUNjBWRQc5M436KTIuH70eFSxV33P9ZnrdfLyATADFvuWrCc4L/f4V5Mq0xpQ96IvlFgPwUzFoq+E3yc8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DlslZE7pqpClkhcxjVK+RK3RI2toyeKjs1N6CdrT1E=;
 b=baR0frBV9IjrNlicpeHOaP4Wc+at3uFaS/W+kjIOnM30GTg1/gnGfe2gG+ptsm+qQc7Dm0SCZpUsMQxiXHG8qGxzwh0W7y6fVYlJQi4YcSJyJW/gyXde7ejrkU6+S4x/VllTvNWqrC4yYEz0dTnCuUZJFw3psYHNdqZH3FeAqYpUItXtUS3Pi1DSaXn2xW96TA9094wAHFdgBZBbuwL5U/5VzawMvLIbn4AiTdEG2dhzwLYogCCB662ZXuJ6+Ezme+i7N8LUxcYeSLSZernRyXVQB9V8xIGsmz5/xrL21nFTWnGRQkrKXj2/mGC1Sir+HvKgIN2cOvN355waakkdCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS4PPFFAE6AEB4B.namprd11.prod.outlook.com (2603:10b6:f:fc02::61) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 00:00:29 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 00:00:29 +0000
Date: Mon, 2 Feb 2026 16:00:26 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>
CC: <corbet@lwn.net>, <reinette.chatre@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 04/19] fs/resctrl: Add the documentation for Global
 Memory Bandwidth Allocation
Message-ID: <aYE6mhsx6OQqeXG4@agluck-desk3>
References: <cover.1769029977.git.babu.moger@amd.com>
 <d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com>
X-ClientProxiedBy: BYAPR21CA0018.namprd21.prod.outlook.com
 (2603:10b6:a03:114::28) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS4PPFFAE6AEB4B:EE_
X-MS-Office365-Filtering-Correlation-Id: cc10ffc4-e98c-413e-b2f3-08de62b73df7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wVrZu93bmzZIgNuSdpc/AbMrwTiujdSEpuUCVpxI+z571iP2wxIrxBft5Fmx?=
 =?us-ascii?Q?vFih3N7Kg31kRKICVRvB0FK8B9wUNd/yEULmGpbNJXXQHGAmN7B9/a+w+XMy?=
 =?us-ascii?Q?QFn+l+txxdUEn5Rw15z8LBDGy5AQuK8iC1OOc1x+JiVXTiIIz+XaYt9H0hc+?=
 =?us-ascii?Q?iWD2jyUgCjBaLZuKNBywXKpJwCUNKLQBL6Uz8STjzcYKdAggZovKS3m4UBq5?=
 =?us-ascii?Q?zoGNgjlRrZls4plJmz0ENJv0XunilPUT3n5h9MbuQOCmCrkrD5Axymy9PYJD?=
 =?us-ascii?Q?f8Wi0xZRwDoO6+Py5FhqliCL67FwclGn/S83gGQ4dVQjabrfjo4w3yzlZm0O?=
 =?us-ascii?Q?2Mo2GHdnLxGpcCNuVFfOrYDCWtv1Q0WVwom5vXm1JME14ksGYZ8PRUc/wbWE?=
 =?us-ascii?Q?4mSwN+7LAfuknv4AllPPpu2PamwIa7IautpwaI4sFhoShFX9fT+SLZ67TAIc?=
 =?us-ascii?Q?64DlLyM7q18+qatxQLNuI1vmbxv2wJgUVn6QPk5VTQs/TS2xdnLySeSgAyp8?=
 =?us-ascii?Q?Wh7KB/pzhQs4jvj46mpDyUpuAgR4D5QSQt88WqwE32GbdWRR8b9J0mgavbB8?=
 =?us-ascii?Q?wxGrF+2QOslIM+u6d7KP+51dhowp4u/IrOdzPacEzsEJ2on6Rle6cueHfv63?=
 =?us-ascii?Q?lyA6s+IT3ww0jCgfI/9C9e7Z4Vk2YwFT2tes9eBGIkXOzcT1pKtEQNJufm2s?=
 =?us-ascii?Q?44tinc62UPgP5kkEOXHrruzVjDCkkgxsfIyAhwG/6fkXxI73JY0fMPZU/pIP?=
 =?us-ascii?Q?qeuN7flCQlt3yHvCY2I/dHnzCy3kNja/PtxpIjKTph6l0P9pcRQOw8Z1nAix?=
 =?us-ascii?Q?mBU1EMkpDSN9QRqAWG1YLM/9pH3LwY4tiUKeekZmL6yGwYwGvCJ/wSg3JoSb?=
 =?us-ascii?Q?3Lxy5SpXRnvhlO+pm9LtTfZ65gc5YMpnz7cgoYNDi99cWgxeQ1zZQaqIKvas?=
 =?us-ascii?Q?Mvn0pb6vZOfUpLwJ37NDxY8HZQWibvkb6YbOJjkvwzrxKyFoQ8FKuOjQBSFu?=
 =?us-ascii?Q?fIShDHXlWDboqdnUiVSAYel3f+hA6pv4XrarFKuVXZJDlwGEibcEu88hvL3x?=
 =?us-ascii?Q?F3ju5SkGbCDCxTCbFdz333/NHWsz5k4bd4muWHcYMc5E6mooN0BUkytGGEif?=
 =?us-ascii?Q?NqQBmbKcfLMo6Ozb0Jri6caCIycKwNA+ZoYe5yNU0O9SvZmphvxpWAjJERVn?=
 =?us-ascii?Q?n5aR79eXi+BhzxCHnjn8BCxaYnjHt2dmYokkOCGv2cwipUEGQ/dPAnW3nvoy?=
 =?us-ascii?Q?/HWcn4zxuMBKuNrbxFqYggjCBv8QgRyKSgYUzwnHHGseNQZ4bSuXZfgCzwBk?=
 =?us-ascii?Q?kV9NUCe3FgglasSZt72SiWU6yQV3tcMPa9XW7DnjEoOXdsUTbiXcj/mgEA7A?=
 =?us-ascii?Q?9ePcF7V1TzyKLWgnnGhoLlgZKQk5tD8+yXrYWtY+G8oqx+uiARCYvoy3OZSJ?=
 =?us-ascii?Q?41IapdactH2qiG1UJHni+U6TSM24KDjKdVnm2gfBl3mzw3KBV9TSNXWJT4YB?=
 =?us-ascii?Q?N4TeoBbN9ULBDDlhdjDU2V2M0je6j34hqNJYPrNIopg6KicorCd0WCj8G/HB?=
 =?us-ascii?Q?GMB/Pl0HZLUMZr65w1w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YqKRKDYoL1vQ6+ivPBHb2oS2Bs4rg09zzef8UcGuAEtiDKeLC7npnu7GUhq+?=
 =?us-ascii?Q?ARLa1Oj9+hwQC2WFCyOhCUvgjqaF0IjDuAhBmTGT8ZZtU+v027KEVtuRrw7o?=
 =?us-ascii?Q?cz4P4uQtHqaY7CH7A3tMZ6WauyqzQqT5T0J0C3VtOplpv0wGrQc6PKA7DBZ+?=
 =?us-ascii?Q?y7RHX026B1BWjvOFDC5rHwJHtGhFJoF/QzP511xd1bIR3ztoLmIgKzagqnbm?=
 =?us-ascii?Q?U/32i8ST3Fi6QE4V4xCOgsYEIfbSu1LtxcKyCn0Hzeog9wNoSuwtQeOM3V5F?=
 =?us-ascii?Q?IUtMsgNYWGOM1dmG08Gn5n4watFLAYBbha+QEPtotr7q28vy57+r0Brzit6B?=
 =?us-ascii?Q?2RZ+QaaqbZKe48vvDPzc/C/5R5AuHPN/TaNeV+++Kh7o19Za2+kmZX8YKD6A?=
 =?us-ascii?Q?x6dZ5BEsMyR3YoIld/P8CZihPsS+wSQZRkzAaiNLcEEwo1YmH927hrSXFGot?=
 =?us-ascii?Q?/qlgPOoWZWfPyM5AeNEhw3ql54l4QTaEppPED9ubskYcCl/zKAL12j41GonK?=
 =?us-ascii?Q?a0Hk03FvgygCFgcHLkQR9CWBJnHe5jgMiw/dpk8dgeCSMoZsOaxuXInA3uGS?=
 =?us-ascii?Q?VUv2yLzlErIjZsBRPX1KbiXiwyq8Jtrn/h/5WYe9nsLbJXE1Epe2HRTcKtIB?=
 =?us-ascii?Q?RQbZGNgcJ1ctsGDqCz1bCutFSLENZ7E5c4AH01N81Wj1FiVWGG3hirnOFMeK?=
 =?us-ascii?Q?KJxGo+E5xi1w96L9xhUs76J+znreSdGQQ+1qW39jlISdXNDUWu6T+LaGlQ0F?=
 =?us-ascii?Q?ZLZd6dbld5SOv+HZu6/6iiSyoLWaPs1rDY77mbQpsz3B4gNHUtIKxK5F+jBz?=
 =?us-ascii?Q?QB5js2dnMNtvaTr1cYsrPEnTqYgAlarGTyhrSs9NyKAO24B+g6NPTzc/6s58?=
 =?us-ascii?Q?bikncchl2YBrcells8b8uDdyvAHprtBALBfPp6E8OS37OEtb9ZIMzy5RD92D?=
 =?us-ascii?Q?XM8QVFSFah7kOLgde9/8hGZ7PrqYCP+sIINlJVDRCZyBBFCpGR+WeFsiHxXX?=
 =?us-ascii?Q?C531xT1iRRO8CPynNyF0jhArGfS6sEsTJRAC0lA6bJjt52F9Whrhhho9ct3Z?=
 =?us-ascii?Q?PjlPeI7QlqndN7irh9XZ3QCrw0FA2e5D1uMPBNDvna5Wh7DLkLgwFnp0JyVS?=
 =?us-ascii?Q?vL7s9EspAq7Yk2wBvD0M8eN6q8ocql2MfxJ2EXwwt6EpVBSrVKOWGYyd0mp5?=
 =?us-ascii?Q?NxoqKglyFmG9HtNyUSTDGKKAmiyA0J3+Wu3U5tF0xJRQ1zeqNm7JxkycLII9?=
 =?us-ascii?Q?ZFRkhwpdUrzK29205fJXgjLDR1XLetRWc/j8EtCTGVpOtaDFwoajboGfDa/1?=
 =?us-ascii?Q?5zaFh8L5eIjXALTaHv1/d62lqv0D0JMKRRItNHsmBOoaXotmgkNoFuahJAtZ?=
 =?us-ascii?Q?f4RVFpXuvKc1XY14PYD3WnTlHh68PZePDtnCcoLDzReTp2EqDR4j7E4AS/bu?=
 =?us-ascii?Q?Qu9ZuQ31rWxsQlpZRCYaglhnixVfpwWzPbLMhyn4gDVKf3DNnCXDoSEi8E6f?=
 =?us-ascii?Q?Z7ahXN6nC2QjtWLU5QyNiPK0Oo+bU2It2R4ozjTx6PJ1JH12FYqFn+9mRLHZ?=
 =?us-ascii?Q?Io3DJqOl4HRRos3ZqBbav9877PvE9l+lN1kOpiIFENC27kSDnk0GzoRkKT49?=
 =?us-ascii?Q?sLX9b+8qJH04BlUYhLPCD2eSvrNew77C/+zi03VwyzYNI1ja7BH7TwjbwYiG?=
 =?us-ascii?Q?4RuGvl5WlmDWeXPnq+CV+wx4tSjsmw1OBXrc6LH+g5lmD/Xgqmg9JkNkUfPN?=
 =?us-ascii?Q?6jNPS5t7gw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc10ffc4-e98c-413e-b2f3-08de62b73df7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 00:00:29.5479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VVWnalYwPmBFNGPn2izoG1GkQnYYYknM+nfXJ4svLZSSaJgPlSbtzYtIKmGPXENS78wBq30fOJeI/BcUk2ZqeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFFAE6AEB4B
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69957-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[43];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 00121D2D09
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 03:12:42PM -0600, Babu Moger wrote:
> +Global Memory bandwidth Allocation
> +-----------------------------------
> +
> +AMD hardware supports Global Memory Bandwidth Allocation (GMBA) provides
> +a mechanism for software to specify bandwidth limits for groups of threads
> +that span across multiple QoS domains. This collection of QOS domains is
> +referred to as GMBA control domain. The GMBA control domain is created by
> +setting the same GMBA limits in one or more QoS domains. Setting the default
> +max_bandwidth excludes the QoS domain from being part of GMBA control domain.

I don't see any checks that the user sets the *SAME* GMBA limits.

What happens if the user ignores the dosumentation and sets different
limits?

... snip ...

+  # cat schemata
+    GMB:0=2048;1=2048;2=2048;3=2048
+     MB:0=4096;1=4096;2=4096;3=4096
+     L3:0=ffff;1=ffff;2=ffff;3=ffff
+
+  # echo "GMB:0=8;2=8" > schemata
+  # cat schemata
+    GMB:0=   8;1=2048;2=   8;3=2048
+     MB:0=4096;1=4096;2=4096;3=4096
+     L3:0=ffff;1=ffff;2=ffff;3=ffff

Can the user go on to set:

   # echo "GMB:1=10;3=10" > schemata

and have domains 0 & 2 with a combined 8GB limit,
while domains 1 & 3 run with a combined 10GB limit?
Or is there a single "GMBA domain"?

Will using "2048" as the "this domain isn't limited
by GMBA" value come back to haunt you when some
system has much more than 2TB bandwidth to divide up?

Should resctrl have a non-numeric "unlimited" value
in the schemata file for this?

The "mba_MBps" feature used U32_MAX as the unlimited
value. But it looks somewhat ugly in the schemata
file:

	$ cat schemata
	MB:0=4294967295;1=4294967295
	L3:0=fff;1=fff

so I'm not sure it is a great precedent.


-Tony

