Return-Path: <kvm+bounces-57370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAEADB545A1
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 10:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4742C165FBA
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 08:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5EC2D94AB;
	Fri, 12 Sep 2025 08:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YpxrT2oO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D2D19E97A;
	Fri, 12 Sep 2025 08:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757666124; cv=fail; b=XLj7vspFpgeQGoeqCTTWzma3tEmum67c7tRaIsDzg3Ug7FT01gmLiXg12z2UcfmOXv9TndtrwZOwv00WhuWybNHITcKSInEoe72BOSV6cpQ7HvIZf09G8kbZ0Dj3kQHx+TyJuOniaMSWgq/l6uaVsfx8azhfW2fq5TWzRKtaDAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757666124; c=relaxed/simple;
	bh=zBfEqCkmWKxJR+0QzEi28AhsH/4kMLbTUueu02rVVMA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AdvyPBn5ReD34lIDf+HTiNmW2N3kX7MMVonrwhO8+QrYjgjOOlAkbdZsImuDupb7eoQfcuFvyI8FWrmysmf0XPKVLSZzI8GkfqYpgxpnnEjMwBvk+vtbGHL9/s16SyoYefMxMpOPkqQyxKnyVjvh82eKtqZR778/L/BaPqvmJsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YpxrT2oO; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757666122; x=1789202122;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zBfEqCkmWKxJR+0QzEi28AhsH/4kMLbTUueu02rVVMA=;
  b=YpxrT2oOXpbRWgSwOPw6JKNfgSnmjKhw2FwpvteeFOr3wnOApaARi7cO
   ys1hpFAm6XAwjWtk6ijI3OIwUHQ/Vzcg2skT8EHwCcpFUhycNyGNUWG2R
   WwkXmaf4QLXPGzlhcB/REMqVGqGR2S+7u1EQikJ+yCKOVdY8/ONbMwmSM
   KbehDKvA0GxuGK8EKNJxfOMTzZlPp5lCAmsQVwr2V5G8FDg4TxNA4w9Ez
   8mrfa7VwcaxDVmXrVtQruTkjsjRhoLq9uPkhjAycXNdJXAE1FELjI3k6F
   y55q5/humVZ94wR1Gm0aFMqsBXF7yMzvtpuWJZBIS3d8blEOchS38R/ab
   g==;
X-CSE-ConnectionGUID: Ud5poTFbSzOJRScMajc/SA==
X-CSE-MsgGUID: HxRYzYroQBSdkrRvmGnkoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11550"; a="59238193"
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="59238193"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 01:35:21 -0700
X-CSE-ConnectionGUID: VKraGsw9Q2C/Swk6qtQQag==
X-CSE-MsgGUID: 4timd3MtTYqLwbFEh/TvrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="173474407"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 01:35:21 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 12 Sep 2025 01:35:19 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 12 Sep 2025 01:35:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.41)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 12 Sep 2025 01:35:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dIYzKB+OqDz/KL/4A7xHl8m1PB13rG4tju/vVRQEqzqS0mFpkBTtWzgZLmwV/08b2Q0EG9Ya8J6F16cSI3K46O0HE5pExtw+0qargDCUzpb/d0uKOD654YoxmEpWKDlzT/VDJ2XUrpVUD02gbnRHmS45ElzoD9Gqub5SZt6PMV4ulYEs/a2dB//GGyWIYFbFLvxs1+WqBMCD/f2sHT92rj9wunKVq92xXHtj6Vlbr+YfHu8+HtquRYo+XXVs/em2vxi3T5/KkJM0Yfh/TZ/WqfwpmWnkLNcgVGM+SKjknFsA+yck0W64JOdHgP+RiBzcza49bPQvTXjFHBwTJufQtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnBKoUEbXFzMPQ3CQ0tehS+qciDvwH8l/LhZIyNyMgM=;
 b=rqulaEEODXLl27Lr6VwY9MVu4XsgposQcda+rhlNXH+5dn1/Df/JAmpi3tKDdt7xBhx1+9K6YLNcAmjEzzDo80jys8nRYthaBdhnCjb2OR+DsD4SBMEO8o9z4CVO2ngIAiblMCwoci4Olspp8nXIcB3+2oFfWKcFR3+aejxIjKU/eFt4QDNd21/Vr/FFhcRvqi2YF7cgbKCgiMAE1w9Ub98+vlbuaGTGuwjHNdmuHYmL4Yt7eoW9rsfvu88+60vpoIuw0uqu3AHDgwqLQpYlI2EI3mUhaKvKUNImdtruEU7+a5s5pXyxKNXf1KRVxbJOlMy8BWpoE4iQk1BrFoB7yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ2PR11MB7646.namprd11.prod.outlook.com (2603:10b6:a03:4c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 08:35:11 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 08:35:10 +0000
Date: Fri, 12 Sep 2025 16:35:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
CC: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Remove outdated comments and code in
 kvm_on_user_return()
Message-ID: <aMPbNBofTCFGTCs6@intel.com>
References: <c10fb477105231e62da28f12c94c5452fa1eff74.1757662000.git.houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c10fb477105231e62da28f12c94c5452fa1eff74.1757662000.git.houwenlong.hwl@antgroup.com>
X-ClientProxiedBy: SI2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:4:194::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ2PR11MB7646:EE_
X-MS-Office365-Filtering-Correlation-Id: 78add482-bea9-4922-69ba-08ddf1d74913
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ux46gt8ECKNpaGsejswAz7XEoJmKbzsd05xRPk34Xgr5kT4Hcw75ARIHcZ9D?=
 =?us-ascii?Q?J8B8haQekPB0qGg2ZQPAHMJKFrMHdjMZIc1i0U7bdbnQvJWvDE2m7brEj8xs?=
 =?us-ascii?Q?PrRI/xTEvetHPrG1FfCkNbx2hbuGSNjWIyYcgiTCQmozIlN87yqJO/ua4eA/?=
 =?us-ascii?Q?p6wuffRHmPBF3+XY0CNr+G+zMhD+5ydin77ZG28LDgtMqQKyJFtK4FXzr+Vk?=
 =?us-ascii?Q?x4COmiEteVpCAfnJ9JNXl7aJHDNJeMPHBTLQMfqEkE+sTT0gQX5GxDsCE2iL?=
 =?us-ascii?Q?GLvXJuQWu+oiqOri3zZQvoNnpiYD1J56BphVf07fVZYUE6zAk73g50j1xWZn?=
 =?us-ascii?Q?TG9reEQ5J1Z2OP9fZ8v5sZMuVip9Xwpc9E3WUpp+L5OsqPNgHC7TOuCnHuvq?=
 =?us-ascii?Q?5xHDPkwRe3M9vN/WG+56kkjBjRHK7aQHZNAnJ5aD9o9NH7lU1l4cjWrNj5T9?=
 =?us-ascii?Q?TdlAUNIl40EANVRZaOJA/IELkpcqPvAjMifZt5PEHi/5iWRCAUn9SIc/rppH?=
 =?us-ascii?Q?4KIi2grk3Li3Wu9gb+KkQMJGf7oVoHWpXREwa1GyAslMyOo++swqimZDusUo?=
 =?us-ascii?Q?nGKjG6KSAX4I1Xg/X5U3i0RdU+R9UUg1WcyNi+6yXd1MlMA9LB2f7nH39pMQ?=
 =?us-ascii?Q?Qy3qSWTRGJLUFyiv9ppY2t9RofgaWt4z/YdHAAnTRSoRB5Lsctvs0Nfm4MAy?=
 =?us-ascii?Q?RqhiYXWtdkay+QXJf9CAkcdLAkL0pGSjgIwSN8nv2HdUECHc8F9/OpohTyFy?=
 =?us-ascii?Q?4x3xuc+pmXd9xXrtXFS/ksm6v61+LFBAAJDWSazrUNH4F0hP0ld0CvBAO4EL?=
 =?us-ascii?Q?mdP6eYFFk/ot7Jz1T+HZf2GjaFYmpq619pFuL4ux/CMMGrahue3VsBP0GF1p?=
 =?us-ascii?Q?rW2/6Fu/PwfILESVVBhLK3Y28NgBQlBDt+kbRbmqL/cqg4rxhSghkANY2DF+?=
 =?us-ascii?Q?atW30TLLBLZoIPFDWdkBnj346t6ZLupjNRmTjUNYzVugSNe2bFx6szY9wldm?=
 =?us-ascii?Q?0L9bHCnzirZNywYEaWAye3SUygIZvvVEEWXYhOkRJmnB8aX6UH/O2vzYE8bf?=
 =?us-ascii?Q?9Ru1WZ9IReEoeZ2y0oHq21vY6GISXhfFQemACwn9BT6ku5dEaXw9Yfo+JQTE?=
 =?us-ascii?Q?vp4Nsw4RSYrWIf6bKM96igx6b2gRKA7/mvp43j381TE9qv4a7jvlz8SpIQmS?=
 =?us-ascii?Q?42y3NaGO0a2c1Uf2FzMy0PhBcgd6FFnYxiEoVqHJrv+kLU6MQmgBYT51SY79?=
 =?us-ascii?Q?C6prrYhq/CERJoiFO0CooI9WIdJpAZpNI1X3Xte3f2Z1UxuKUOJcI32UEO+d?=
 =?us-ascii?Q?FTbLBVce3B9w+4ZGMldsW7uUUQT992Mz3SqSDhKwmGkLPralaEyGvrtd+e3d?=
 =?us-ascii?Q?ZzXWJfDu5W1/iuc7JQwVJrkHeeq/ngS/f6iLw3jyQ7pRgot+Ou7ZfX0U5Plz?=
 =?us-ascii?Q?Qjlbc3fC95s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pcuh5vtYnJlspjgjRPRGfHBL27nNU4LZw++4Zh1N6Stj7Uf0rRPVxcUCSEhK?=
 =?us-ascii?Q?wTfnn4bpXBMS8PecJn4NXNk+L0T8SQzy0irum8pgp9RBUoA5d+KgGRPAZ0ws?=
 =?us-ascii?Q?LTW2FIWYK/tUgchgel/JLejNSFhclCLA9nJv1t9eWGKLEzJ6opheCsAnBAwp?=
 =?us-ascii?Q?SkrQBcgcDffNoy9maEY60AkNLunDBktNfLm9liVfLiIvWyS4mkhPNmstW4eV?=
 =?us-ascii?Q?gJYqI1aeNMQQeC5winzY5n5/L7tf9nvTkrIOFsHB6jJ2pUP4RV2/m4Gnq297?=
 =?us-ascii?Q?Gy8padiG27i5vkYLVCUeh9xzFPQ/DdlK6mn7TTX9TozY3HhgATlp4lezSeEr?=
 =?us-ascii?Q?gkv7wY4nVs+yXCZBowR+ZXdJpPfXeKOkQ31iaD5VVtUJSKuCjp/b4EnD4fPP?=
 =?us-ascii?Q?9a7lJs1H1i0obubaTUdQC5CGtGoz8b59AcN58vLrDkBn/F+PwwvtXX17bpTl?=
 =?us-ascii?Q?TXKtDy+TR2Ja93EL+Tzoyd+Y3/nBuZK9F0ZbHEU26WVkycyo48eu/XMqEr83?=
 =?us-ascii?Q?VAQrtqRdcm/59potNNIJKn9ehPhNJPOYMnEHKmefu6d7SbFaBjmVvtyd6twy?=
 =?us-ascii?Q?b/DUhzLb552nEU2j1qx0pWo+YXmaiuIGyL2J+zUanlaP18Y4IIJae63bizmP?=
 =?us-ascii?Q?KDnY7YGzE3rUgkRWdk2re4ojPS90QYEIlnvfziF33HeouU2JW33PHsEkjhv4?=
 =?us-ascii?Q?QWLansePWDVXvmB5PGGKrNdzXyIz+fIPgtwK0F+gvB9lpEEi4FgVJdI8C3Zz?=
 =?us-ascii?Q?aCfk8xhri7VrkCRYCpq+iidcN8NKZvrpGru3REx809QyIrkihGAX4vNNXcvL?=
 =?us-ascii?Q?9Y6AyXz59iOj3y6hht1RtnptefVOcUVzolmIiHGVImaJ5QmvlDGuKSO+JDuF?=
 =?us-ascii?Q?XJ/F8/ZSEZdT6tIhuYH0Jjiep/1+mlo60LgA8YTBmQi1WhAysOCwhGmG581m?=
 =?us-ascii?Q?rtN/HBv3GswpIc+ufvni7Qoik57PGow8TStGnst3BIIVRoyTvEr8j6mAqCCA?=
 =?us-ascii?Q?JgPq8u1JfQ51EiIG4YXcCUSgcyLrXWGWMYepoj8Lp3fSF6Z5l9VZjsq75joS?=
 =?us-ascii?Q?Tbf41i7j40Bbq8i+R+A0J+KB6cjX2NHzkqWM5EIQ6Og+OXcNOxpvXqpqhYyy?=
 =?us-ascii?Q?TmTNVnqiywfXBA8fIHR+4A3Sn+jOSCucVOE3BXEphOfPtVWyjzBIRy8jIi/j?=
 =?us-ascii?Q?A2Qx6a8ouVFz1A8a9UeWbGzzA1SzoFcLkPDDSnxa0azqJhg9/lZ3nn1i7UGC?=
 =?us-ascii?Q?WmgXo5JZKFs8TVduOjhH40V0o7M/zd+/ddCWbRT/Th1p1xP+WwzbJjCMi+D1?=
 =?us-ascii?Q?lfESNZohnFu/8dEX5pM/aThf3m+wHIo7R6JnpZrqbEpUBtzMQAuQv+sCskAX?=
 =?us-ascii?Q?grAVHpLw7kVOb9mHTCQ0XWYsBvQbQ4Z+xTjy2NYGx0QTB3mIr3RKohyW0MQI?=
 =?us-ascii?Q?3b8xSkEQExGRzF/xhtkaJ2JU4F6AgcNX86X21lFrz7N6fmtoOjClCMw8fpJ+?=
 =?us-ascii?Q?uTcHe1JR/XErGjPJnkUIW+jN/uteT/Vgd9LRdac/X+E1t0L428TPM7dipBlc?=
 =?us-ascii?Q?r3tW3MuRzUTvyZh8ODFnFqRqG0N5+tGznUHkZZIR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78add482-bea9-4922-69ba-08ddf1d74913
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 08:35:10.6121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyctb42dPEQeEsaeoCHHgOsf+OYG7K5Li6I7g4cGUd2ZSHVc2MpwC4RdXmIjvGK+F6hwb1EDIwlgeqpgzJFk9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7646
X-OriginatorOrg: intel.com

On Fri, Sep 12, 2025 at 03:35:29PM +0800, Hou Wenlong wrote:
>The commit a377ac1cd9d7b ("x86/entry: Move user return notifier out of
>loop") moved fire_user_return_notifiers() into the section with
>interrupts disabled, so the callback kvm_on_user_return() cannot be
>interrupted by kvm_arch_disable_virtualization_cpu() now. Therefore,
>remove the outdated comments and local_irq_save()/local_irq_restore()
>code in kvm_on_user_return().
>
>Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
>---
> arch/x86/kvm/x86.c | 16 +++++-----------
> 1 file changed, 5 insertions(+), 11 deletions(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 33fba801b205..10afbacb1851 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -568,18 +568,12 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
> 	struct kvm_user_return_msrs *msrs
> 		= container_of(urn, struct kvm_user_return_msrs, urn);
> 	struct kvm_user_return_msr_values *values;
>-	unsigned long flags;
>
>-	/*
>-	 * Disabling irqs at this point since the following code could be
>-	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
>-	 */
>-	local_irq_save(flags);
>-	if (msrs->registered) {
>-		msrs->registered = false;
>-		user_return_notifier_unregister(urn);
>-	}
>-	local_irq_restore(flags);
>+	lockdep_assert_irqs_disabled();

kvm_offline_cpu() may call into this function. But I am not sure if interrupts
are disabled in that path.

Documentation/core-api/cpu_hotplug.rst says that callbacks in the ONLINE section
are invoked with interrupts and preemption enabled.

>+
>+	msrs->registered = false;
>+	user_return_notifier_unregister(urn);
>+
> 	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
> 		values = &msrs->values[slot];
> 		if (values->host != values->curr) {
>--
>2.31.1
>
>

