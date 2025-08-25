Return-Path: <kvm+bounces-55584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1078AB33392
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 03:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB6D016A49C
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 01:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7541A20E6E3;
	Mon, 25 Aug 2025 01:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J5xvsGyB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239C51FE45D;
	Mon, 25 Aug 2025 01:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756085610; cv=fail; b=fQpjSa9h2CeI3d/6RHn5xk62c25q7OLrWe3rVUpiXVAlX1gQaYakOMeq3NWmONOhhOvS/aQb6mjqcVgEPaqKGwuZb+xlmlDr3pM4cSWIO8hQULmUD5qdRrnbfbKCHLsj2dzO94QWlUuMtqXfnqAwKQFwx7/X5owRJyXW0U+4UFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756085610; c=relaxed/simple;
	bh=vyNeB/iWh3UAowXqiaG3xnFqFesgtLlZa8z6G0rFY7s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VnRzmjK25+AVF5s+3Jb3tGUXDgYTsWn8k6jnmmyjhFiWN8yNtF/qHUD4EPU7ceP8EEztopuh9iuBHBBP6wlZnKjiwDITyXRcFShvfRZVj0U+FATt7lx9eHUhkYFoQPUyuw1dmfCMa6xlcOByGUJmsvxK+lOawMI1lMgAmeJt+co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J5xvsGyB; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756085610; x=1787621610;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vyNeB/iWh3UAowXqiaG3xnFqFesgtLlZa8z6G0rFY7s=;
  b=J5xvsGyBClsUaa4ABq49X9xCuJVHVi+SJPHpaM5/S8GSEZe4//rCBkRu
   sqmDwCHle7jxRGBizeJx20MCPlByf3jKeJcwJvJXD/4AV8E/xO+9lDZ8z
   S6W1mFIxR312jA6N1yg8OO7us06RV/3R3G1wEnOJeMFZD4GleFFPVsiM9
   WcyY6lpQTIUnnm71kacSC/9rIb1FTV5FNHhXvLdBPVYSCrvfpsSzQ1UdR
   tmQFXPs1XNfzxs/4Pu9CiLLou/B6Jexgl2AbSKzXS7hH0k0M50YOThclA
   ++d+uin3baQX3Li6FWr/ZFgvkMBqNsn+LJKYVK0/XFoiJzGMM3EyIfy/Q
   w==;
X-CSE-ConnectionGUID: H/Cogb1IT5Gg5630igCOsA==
X-CSE-MsgGUID: PngDRuvIRumM/1zxuH004Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11532"; a="61933608"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61933608"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 18:33:28 -0700
X-CSE-ConnectionGUID: AHwqPWbnRnCTfLpCtlBCkA==
X-CSE-MsgGUID: hWoXeimsTju1AQfuf8bRoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="169349293"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 18:33:27 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 18:33:25 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 24 Aug 2025 18:33:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.87) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 18:33:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y7O/CBoXcByFD3Y/GcU6+3C5dGz6P9XjFcohe5GQoXDUhhga84B6ocxOuPx9+iTb4zqZy62XRj1x3yV94AbimaULDXZ3aDFK4zNHw0uJ+Gh8k9+/9XDwWLx52jGA69OSA0qi2XmeiaQgjOFl3RPsOggmDW1j+oKxWSoL+L3KwHNEifecPxLodzjnecXXVEZSk50QSY/Pp96UapaLbSfvcjuMnGCQi6Qur4GYyhDaOvOBuyC5FnlosDD/6YCCT8/PBzk+gEdVXic0YbPJlkuXRT4rVYu4dKnbrCbad76G3Ad6PueycOVAliqBxBNV+LaymFBhuMm57WGREUQezvDvOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auzCu72mbNq1pAVg7865bTCjky8OV31jRg7ttf8wpXI=;
 b=aUE3mPjEw8+zx6xzEKNtnYSZhIPxhtV1IcZhARE/C+SnzANjPx6iUGKkrXKKFwNUWRdbESYPhYPp8UsHN6ouULwh0Ri4qtsZyrWvU6gmeaFZ3+rp5volNLsjBc5VwlyiuQCj41R7dt5cHUgOeVb6FpD8teSxvrOwVwiknSH13eI34Qbyfmp62rs0XgYfc7yc3r2IXKWwmEYG/p4vlMn2VdUHunrqkW3guYe/Oy33QuYRsvZWgBbmF5e3sWco/B5KUv85q2WAn9+Z59e18zY4oIKiVN4w8MYTPoIaSJ1XRZpC9+FzZyFsbXVSEA/IzlH2JOSMfZUBpePyqntfOHwZxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM3PR11MB8716.namprd11.prod.outlook.com (2603:10b6:0:43::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 01:33:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 01:33:20 +0000
Date: Mon, 25 Aug 2025 09:33:09 +0800
From: Chao Gao <chao.gao@intel.com>
To: John Allen <john.allen@amd.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 5/5] KVM: SVM: Enable shadow stack virtualization for
 SVM
Message-ID: <aKu9VfW0FF5YeABi@intel.com>
References: <20250806204510.59083-1-john.allen@amd.com>
 <20250806204510.59083-6-john.allen@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250806204510.59083-6-john.allen@amd.com>
X-ClientProxiedBy: SG2P153CA0010.APCP153.PROD.OUTLOOK.COM (2603:1096::20) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM3PR11MB8716:EE_
X-MS-Office365-Filtering-Correlation-Id: c283970c-841f-4d57-2f4e-08dde3775fc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Xj2zcGeINqV6tWfdtc+MFu06VbSbnoTcTJ3CGHwTdqfkM26xk0N3ThNQtOic?=
 =?us-ascii?Q?0uHgEK8vQ5KJjvd4qmo7tHqrNDzkr4B5U/vzgByVXVQMKIaHT3wrs7tmFq2W?=
 =?us-ascii?Q?a6uyxmEnIiWa1wKFBoyJIRvbCFG1dmMrmPXKkjO0mN6w6VwZnhptYjVFPx3v?=
 =?us-ascii?Q?ezEyS2AVKcVyt9K9t6Kmutb3ADXdeNrqqlI8gOk7Ef6qj6PQdYQIkpY4p4W1?=
 =?us-ascii?Q?HBvQhuGpjrzqmnOR7qER+e6SuGQaH6Jj+Wtgrct5a+LlMVS6shxXHsXTBBNa?=
 =?us-ascii?Q?tnPla2dRYd3EchD8kk6OcFQU/sBDOU6YuOBkJ3MqA9RA+mle4RvkGi2+VYaV?=
 =?us-ascii?Q?vdSYC0bCO09qcnmEnagwDJL6Y8G2WSNO53gc2O4mTB7svmIKMRNF2l97x5th?=
 =?us-ascii?Q?ZKDtbO1AqHQN/McA+7W2hV9Dr0E+kevm9qBWGmU5IEW0oF7FxycnefRa59nw?=
 =?us-ascii?Q?9RB+bjvOgok3ME5jW6u9TFmFuYfB8kB7rIr99Hco2Wa95gJcb9tf34M49UNq?=
 =?us-ascii?Q?5bqSGMO6oQub9AUadq8z4Ca/DyQFmln+8aFruuW42K7xu/VL8d/iL9G5v7Kd?=
 =?us-ascii?Q?k6y8eHo+slBVqSlV/ro5A/ywVeEKTxmqp5/LJQz+rHZE96ECCim+r60bHc9l?=
 =?us-ascii?Q?egyiRPoIN66oFArZAD4YNdWxmlgHZ+iUEt3bgfD97TGAyPUyEfqeU4AVMCHV?=
 =?us-ascii?Q?FrXxcXlNVhJdV8sILVdhlDL3GM8z7ClH1FY7KRl5W91xxiHjzW2O8IRV5Tr1?=
 =?us-ascii?Q?RV6Euhfd/eEBMK2ABVZ0lXnvOP9q+s4WZdQG57Puur12bXI5Grb1qLGpBxdT?=
 =?us-ascii?Q?grsQqC2rn6x/kSSmO7RgAbKJOQhBBX2FMbaCLJdfyebvWcbG0bV3f960DqaN?=
 =?us-ascii?Q?PyUk+H6ijsewbAXGf7NXe+8xFSeARKxMyniSgu3JGvNRM3c1nFeYI7RM8y96?=
 =?us-ascii?Q?E+PbGDzw68RyKI6lSeDozfH4L2f6CFJM7FLtVqJhpfCPOM/J623lyKHhZJuB?=
 =?us-ascii?Q?tL8aqHMn5F1NMRbWm9gwvRsJ9OneRclr8UK0PvDmgJYZxJnNXDIsg1QNyNVE?=
 =?us-ascii?Q?riz3VTGZJs3y41zkbAhMrsayZ0qveK+2oU1xsOpki/cZogtChzxHQr7AKPyE?=
 =?us-ascii?Q?7Q+GEWQZE3l6+cLTm9qEArjWFT0HMFtIKnAVNO0ynq/5eiot0xTeSwfRfjR9?=
 =?us-ascii?Q?aRX5G+DCUXPBgf6/1Uaf4gTaR+iqhjH1v9hgB/qs7TSPugXel5nvWIaj/+I+?=
 =?us-ascii?Q?cTKxGszCrHQ3uUh82WhPTLDyJutMsqqaBL6cuDI31/nS0HYsaYqvJHUPBEUd?=
 =?us-ascii?Q?X0Nhdv6y9pynf1yTY0myyFvlDVNUDS7Ko6wYk/OL7FBKgzkJA1/IyKyybdfs?=
 =?us-ascii?Q?touKZrpQpPH9rD8v5MdJFqvsRg6uuYxP+89a+3gGBZiKkgk2dXqGbUxlq6YT?=
 =?us-ascii?Q?5zsP1C7bn4o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Es+Gx/F/zng4bWN07c4kmolDUeHF0voGUo1AfZIrusFIyPBfXomeAYGeJeEZ?=
 =?us-ascii?Q?WO6wKfF3Qv20nwF135WCHut+D2UC7GXJ15UyeFUTsIrbrL7T+zZAvo9n9bbT?=
 =?us-ascii?Q?ybuKyjoEYOguzYxo0fwvac9iP+l/C4c/MlQBf0zgPfsdRTGD3385CZDEbPVN?=
 =?us-ascii?Q?JcTHqK52gTns4BE18VguCbQSZyIXCTaqEqJvsQxGyLYrfI4WYGM/It+TJ05K?=
 =?us-ascii?Q?udEL2iAuNmtHnU2cX1uVJ/YWM3QV6ma5xlIZ533wGIhTObI8IjYLNa6vs9go?=
 =?us-ascii?Q?sLJykS97V9JskhSabGFvgi6d+dQyqNVVBt6/bwAwtCE2JZjMItzXGJiHYu7O?=
 =?us-ascii?Q?W4Qh4GKK8ZdqUg0KkmjEUgWuo16noodrTDzcXiLt+B/dZ/SzVoFfx9PdEuv/?=
 =?us-ascii?Q?JDjdOr/GCz7AJYHg/tvKBr4TwF0ipb/RyYFFaR+0TM7MEtx4bzxPsuN5EsFP?=
 =?us-ascii?Q?Jx6BGJl3T/TJkZYtvZmQzj2jaNGtKoye4gMjKhZMOYZLMoiWOZIsPC7jxuIA?=
 =?us-ascii?Q?mt29T63f9H3+LPlsHEnSGQMcHxl9ys3Qkj/cbDq7NdKVaBME90EF+p7vEZYQ?=
 =?us-ascii?Q?IUt/7mBVIcfqecPAPaErdgwQ714bYGFSrM8zK8IcO4wvxo9GlN3zoCb/l5fC?=
 =?us-ascii?Q?Q6AYnsT+EUrVBjkbMX2Bg1FKmFeNPwdNvCvm7Pyhn8fIitpcjCzFBbE6dMGh?=
 =?us-ascii?Q?qs3KPqp84D4frBpbjBgcdh5B1XviDadEcvWi2alHixJSut8hXQtMiqVrXodI?=
 =?us-ascii?Q?iDaC395AAEzGGzezM9RyuKILmEebtxBnOuHbEgDunsUyPpwllRBLGll7U7PX?=
 =?us-ascii?Q?KXlFtwgese+w0xeu/5SxsCPr1qpyiin74nq3QEfuttCC7liBQ1B6NOHxEq+f?=
 =?us-ascii?Q?enNPFw+psJqI0vpMiG20WJkpSEe2hNTBm3XH+qBp16XXsD00t1KeITNgNKhm?=
 =?us-ascii?Q?NmmcteBlHzK3Qq8RM28f7Ko6L6Woo7vMLQRZ/sUOJMDsqgUfVVGcx5gtFEEC?=
 =?us-ascii?Q?czpRXUoZmDiWyiRZxZM9FTIXhXTsyhb47f++psrAyXiXf0ajQgR5q31h7L2D?=
 =?us-ascii?Q?MVIs37ntX3gZLldGCOvXmLoIPA7sTs9Uh9eiGrmTWhRaDZVSy8Mw4OWl61sF?=
 =?us-ascii?Q?ndVQOUrH18LWlyXCcAD+vAbtjEC+WmPobDfE9omiifK3GmpsH9n3IbTaxOyR?=
 =?us-ascii?Q?sRN9CnHcZbroivmv78wHLzXxzqOOpwNC4qaZXHoi92BJgMAisG5oNdiwQ2QZ?=
 =?us-ascii?Q?5QzHkxO/neTavqcTXLzt0PcG4kl59jFbIbSPqQBeLbzTE0MX1nq0hkms8xiJ?=
 =?us-ascii?Q?XdbPGDSAB1ufOblx8ZQV9riSoQm8UQtsPuU3ngWMotRIegkLt67wDVr5mPs4?=
 =?us-ascii?Q?St0tT5H3jDb1VVRFFkIhn52RYl+PInFqh48RejMqQHIvJVhJ+Iw2Cj3pdbH7?=
 =?us-ascii?Q?NRf4fUiB9T2Ucx4d7enss9mFat2TQwuEseuTr9oRPb2/D2yItVOn3tprHl5l?=
 =?us-ascii?Q?8tkX1ea0JX+xo2Lhq04vg+FspmTiBKSghzO8czEQ6lRPdj8Fu6QVeyJty5PF?=
 =?us-ascii?Q?wOU3O9FUM5z/qIwmh897yaWm3hmw6ygCoYXF6vzX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c283970c-841f-4d57-2f4e-08dde3775fc3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 01:33:20.7404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OEHVdBGfQ5nvt8O/YV8I8g57y4QBEOga9ntGyaCSK9fMgDdBfmFcRgzfhEJQ+2BrOYYRdT8FzuxTajp8QmI6Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8716
X-OriginatorOrg: intel.com

On Wed, Aug 06, 2025 at 08:45:10PM +0000, John Allen wrote:
>Remove the explicit clearing of shadow stack CPU capabilities.
>
>Signed-off-by: John Allen <john.allen@amd.com>
>---
>v3:
>  - New in v3.
>---
> arch/x86/kvm/svm/svm.c | 5 -----
> 1 file changed, 5 deletions(-)
>
>diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>index 82cde3578c96..b67aa546d8f4 100644
>--- a/arch/x86/kvm/svm/svm.c
>+++ b/arch/x86/kvm/svm/svm.c
>@@ -5255,11 +5255,6 @@ static __init void svm_set_cpu_caps(void)
> 	kvm_set_cpu_caps();
> 
> 	kvm_caps.supported_perf_cap = 0;
>-	kvm_caps.supported_xss = 0;
>-
>-	/* KVM doesn't yet support CET virtualization for SVM. */
>-	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>-	kvm_cpu_cap_clear(X86_FEATURE_IBT);

IIUC, IBT should be cleared because KVM doesn't support IBT for SVM.

With this fixed:

Reviewed-by: Chao Gao <chao.gao@intel.com>

> 
> 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
> 	if (nested) {
>-- 
>2.34.1
>

