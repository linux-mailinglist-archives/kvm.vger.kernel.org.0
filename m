Return-Path: <kvm+bounces-33684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D06069F0282
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 03:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 095D6188BAA3
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 02:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630C557333;
	Fri, 13 Dec 2024 02:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/VAeuvw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1A64EB51;
	Fri, 13 Dec 2024 02:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734056110; cv=fail; b=dooRt9x2a3/ep+/Ax6kMMv/3zDkKaQPAOg5agsCIZrJm9UFbrrNoyAUe05hm4Zl5E3bELZRJMe38dMgvA0Q5ytLwdCL0d2IFPAWrpwosvxpEsewz7kOf496SyHzeisy9/oHFTvq+IBj1Mn8mNJoM2fb/hkpLu24li7iFbB9tIBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734056110; c=relaxed/simple;
	bh=fQpJ/EE3SWPwbgzPwTqPitN7NiuoPt7fHxgw2owiv08=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Vwjd+yw3fwN7QYZBoBSbGQxivW/Abk/0QyLozEuKL5YxoK50goLw5qDmI0hIK3Y7Q0JiDWNUtE3ucnE/kCoMRTrNvw8MYVZH5yWqirgDgsNCHPL4k9xBZuscqgdrYgL7eVy+4RcAAS9QthS0M6CrR70Px0uu41XN7OqL+gUc5L0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/VAeuvw; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734056108; x=1765592108;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fQpJ/EE3SWPwbgzPwTqPitN7NiuoPt7fHxgw2owiv08=;
  b=i/VAeuvw+tj1LOBmzEPjI54JkATSCSEvq6RkOVTl6RmTyf9VFNqCIv3R
   BCet3y0YGaiawbdTeBdJwl2/V2cV/ZUhEP7t4RNWlDAvH+UVosRCmoTcv
   FB7wcPsvnXr22t9hWPzHPDenzeHQqH4tsjJq8ycQG9uUm5pfuXWdunnRb
   c7FDcdkKGMKanwFrNtT4XNMlDLMf7AP3kFyh/mddmcnvEnge8vHwudbWc
   Boeg8Jh+Tmh/ZKPWlzoH74ZUf+55t0a1KV0Exu/sZ3Bd8d7oP/7pjQaIn
   Xb3yMTcpmNm2IuU7cx8/cpt0W3AdKS2JzRjTkEyjvoV18IsQsJPifdWzR
   Q==;
X-CSE-ConnectionGUID: bq+M9ru/QXuWUu2eRBgwLw==
X-CSE-MsgGUID: bOnW+mUmTrirbcNH9Cjo6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34417348"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="34417348"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 18:15:07 -0800
X-CSE-ConnectionGUID: jn9pMHYoRSKNxnP6SJzUrg==
X-CSE-MsgGUID: mvjTwt7qSoybJbmNd6b3oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="96643487"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Dec 2024 18:15:08 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 12 Dec 2024 18:15:06 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 12 Dec 2024 18:15:06 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Dec 2024 18:15:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tg8pew0lWFCZFRcyi1yFMxfZhRAZBDBZ4VIccZFsAqbaHX8olVK7EvHQfxzy8ukOD9856vK1eJ1Pjhv8euViJ8KYhmezAmYzWFhpEdl419qor+b/cAwM4w190aJPzyrlX8BqVW3cs7FMhn1vlwbwRcjywvfyPVluWWwvUurYF0FE0U/ZnZzM3hyNGPumnpaDkeOVJa2v4gAzJV69bfcrV3gkrF78z8ldO/Dp6AiXP6m4doz3OUW/z0O1zcm0dcCqqIUQCeguuYYp7VhWCiodDco2C2G9ZqkXdV262H32KZxSZpzFq3DF9fYNeBTZS6CktyB3/XU9F82aPQtBaZ3flg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lccff8XCpMEdp4DnKTL/8b/DRTX+DF1iiR+4zVSs1Og=;
 b=xoTiFo8HTaPIwvcUjgfh0aiRkJ3RJWxD+avXF1+aSvZTZEl3zARp8M0xaE4VpLDmhNon80uwcCpshJAppo4zBDZLG4BQvJci6pNCca7ZoQGn/RHGFWJFJ+X/2wBGAr60xK5Pz7EI+nPuLsBu/X65DTZJrRBvYUKS49LDOF+FJ9EQf7K5eJwTgRuuFjRHG4UYA56Tkk240IrxUnVsUkJTE835U6WIDyB82ZcTbaSfyp/k4jdksF8BokEy4e7zAwHrKtrbRFjRRFaj7Mpf9NpKpnasKotMejChyzXgkOQwOsDKvXe9eNzdlIisA1yIPiaDjnRPj7WI6wroSR6+TXPJGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA3PR11MB7434.namprd11.prod.outlook.com (2603:10b6:806:306::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.17; Fri, 13 Dec
 2024 02:14:45 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8251.015; Fri, 13 Dec 2024
 02:14:45 +0000
Date: Fri, 13 Dec 2024 10:14:34 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	<kvm@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, "Hou
 Wenlong" <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>,
	"Binbin Wu" <binbin.wu@linux.intel.com>, Yang Weijiang
	<weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 50/57] KVM: x86: Replace (almost) all guest CPUID
 feature queries with cpu_caps
Message-ID: <Z1uYihcPhJVRmrxh@intel.com>
References: <20241128013424.4096668-1-seanjc@google.com>
 <20241128013424.4096668-51-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241128013424.4096668-51-seanjc@google.com>
X-ClientProxiedBy: SI2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:4:186::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA3PR11MB7434:EE_
X-MS-Office365-Filtering-Correlation-Id: 865849ea-bd4d-40da-6322-08dd1b1be97d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NnlAQ7kls4FpXF5ZhjSgmG+KdiudVwmCC38VyP3wfMbM3A/KO1KDkhwNicSR?=
 =?us-ascii?Q?sJRA/IUSSzG3SavOJCdqzwKgauPvnDVPsd1eSZfdDFRlc35NeV/tUOS8U0Mq?=
 =?us-ascii?Q?H5gf6OMhfICM82A+x0F9Q4Ql8LqvwVy2EejhESFVdonKhOK84QJnvnyP48RY?=
 =?us-ascii?Q?FcVwIdh1h5UeuTjPMGY22uL7k6relClBG01dUQ16dBBsHGOUOMz5trWsTSxl?=
 =?us-ascii?Q?EAMKaIDj1VTTlLxPv0O5OAr+9HeM2Yv4c3irAooVgLUamWENkfs5K8UuXoHm?=
 =?us-ascii?Q?7cw4Kr3JrA9MgwzYAAbkNGtTckOiDcAaMkNse1pxkQHx1P9mYvuaTYiQiY2B?=
 =?us-ascii?Q?+QjPg7np8q4jksNCJ9Mdczgvv27LDDWp3+J2lXlRIV97XV2GZCdboyzDuM1o?=
 =?us-ascii?Q?/m5IK61231xden6JNLKkvquN7NJQt/mviney4CVeybLXsrMnYlkcBW5V3/t8?=
 =?us-ascii?Q?Yz5HmFaNotuoGoMhMhYS057JdEHafi+sEyS9GN/KPlDhUNYtEyO1Mk6KhnUJ?=
 =?us-ascii?Q?DjQ9FpPpVDvVjPOdFARNBAc/52ApWt52nYKR7lz/IDklHR8ak7pVcaadtIa/?=
 =?us-ascii?Q?kPKUk4dQA3qiZPTw1ZaOiE8SUaDMJvrhtXQIMICMZ7WORoBec2RiOVHFeNLL?=
 =?us-ascii?Q?I0QofLT+ZAn/IcGaD680SDd+F6k4/+Stczc9sdqZo6h9W32koPiQRXNAOS6a?=
 =?us-ascii?Q?AT33Wu62zfcyeYmh+ZUTwu7oclXAxHtuFfs5SkfiyRTnpzxDOVMBgzbsuNsO?=
 =?us-ascii?Q?Z4blINr7O3TEEkHNvszSYtW+3RPaFB0M+1HssbnVq9iFi3jc59ut0E6yryLy?=
 =?us-ascii?Q?LIUp5C6gQqOOCMWOIZeZAMKl21RkTUFAHEd/L60T5Rpy4/8wqtr40OZxa8DQ?=
 =?us-ascii?Q?SuOixnsEkfxU7rXkcDidKTOuQXLRpMS2RV2HYUvyTuC3cX7WTx5Da1mZhiy+?=
 =?us-ascii?Q?p0YOyS8Qvzdk9RFhCxKPNmuyPTe06Mgqd7LYy7ooPJdf5+lMZgvi8hJqqRdX?=
 =?us-ascii?Q?0Wtu5xYqRmlFhstTtzypE/ntYsNGCWihUyXC0p/OjThzh1ky1bJSHkbSLPRu?=
 =?us-ascii?Q?ggW+qgrvNZahGIKfqrjPGs4cXNXOm4BU9I9rUUppPT/7qS3xYQwjxiTAMSAs?=
 =?us-ascii?Q?ETfpm50E43B64RgvP45/ZdfQlpteDnI6Ua+SrGd9dF/FjURqHeeoLvkVX7M/?=
 =?us-ascii?Q?FLcKNTvoJmgXAh0ixCva3TU9HZ6YivQG8puiLI00+HrHeX8SS8SWYeg1V/p5?=
 =?us-ascii?Q?IiCPkSdJKYxXY5Hn2DUTrwdjyz23/+nhoR2fhaRneIrkyKhidRijhZLthtx4?=
 =?us-ascii?Q?u9EsFMICSDboPsC+vWyXjID566i87Y8gvh6I7OmHfG21BA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kNFd6+21m/bDVZFvlMWJ8d06ZWFhRe0hZv+8etZ56fHTl0mDc421qKDmSjtz?=
 =?us-ascii?Q?aYUdma4baDx+DstdQyUkEQD7ibdasY+5P2xMgVYcKwDd2t92eDHS5ePjyge1?=
 =?us-ascii?Q?sv75+2KnCfw/2s0f9JrgFh8FIy1iAiUvOcXNqSogDJ9xUcamZBmwU4LoYMpV?=
 =?us-ascii?Q?2i6jshE6qMRFYYYgOcKYs5rHlJncIoBoT8c0BHVczTe0QWwCgVg3XGBmhSPl?=
 =?us-ascii?Q?qDudQwRmMkmIuwXnUNRO/mMjSuTe4HkZcOBwvRt/5iHdeJk/tsTVXYDgQewY?=
 =?us-ascii?Q?URAdCac429PvF9DFRVCPa1aaFawC6PYbUswnofQznGd3ZZp9Vz/EiomL29Q+?=
 =?us-ascii?Q?e4I/i+Y76iR/A6QjxS/SaZyZXxXl/o//62KIes4LfSF/DHfN6fqoG0m1NHm8?=
 =?us-ascii?Q?wCFGESLlkWP5DjgYcEiumBwUVgtiyqULOnOrx0B1Mrbs9dKfOMR+9hqLYzI+?=
 =?us-ascii?Q?JXeMBaewT6VGu9spMHzEUOC3l/8PqXThEX1xB/6XXV4r92oXUakffyUtGZaS?=
 =?us-ascii?Q?s99vk29zX/OFW67WKgfclq1Pzf1hQm8UowO51W8uZZ/WVeyc3lfmFnlmAU/d?=
 =?us-ascii?Q?ScthnVQcARY8XKiF8Wpfs/SZYZ2MjsXKjmNhbTAsHs327fAgK0VX6K/idvhY?=
 =?us-ascii?Q?dyViXuG5ItT7eoXMoSaO6gBzH8zXL+VhuZVDt4aMrM/9KY+dzpzuvTmJ+Z//?=
 =?us-ascii?Q?Uz1X0tCrlOwIUcN1w0TxTJoGKAROJus6ALmH0zP82G2Tw8Qtg/Z2K9ccVkOo?=
 =?us-ascii?Q?EIAtg67+qVcUv4mIYeYqRU9V1n/HEP/0Rmj66uh2rnC+CzU7UPKKSD1qLGOD?=
 =?us-ascii?Q?36GZo+6JQOakbG1NmiGSt4sLSU9DZZrn0RQuq1CA+Fl/azX6EHkfKuxJojLy?=
 =?us-ascii?Q?IdnQgcb6PZ2BhonLmqIXYpQPYZwQq5w61B2qDiOutYMvD2GHLgjHSbyY3jc5?=
 =?us-ascii?Q?7eL1rKnOs6ZCpKKRZJ3AXNon57i4XNCmEF44Wf0fjPCjwQMQKeTWuT/RC12n?=
 =?us-ascii?Q?2WHOfPYyDVG7nIu1udgrFtOkh77oo/v0SBEorNEz2Et28RUUgahR7UqaNIdm?=
 =?us-ascii?Q?4Uw9G4ceMOCrkrGHB+ZBoWzHLRehSxYgD3RTBNs7yMifMRPlBuH7jfWIgill?=
 =?us-ascii?Q?+prjNhPfn4pk8N/pKt5Pj20JiyE9A6LsfWBqZpxXsu9SratcOR71XHxZmJYu?=
 =?us-ascii?Q?MrG1pGBFJ4rgQSoHyHOYE7wJaFXOvbqduRNgeKWjjaSy/g418jPhXc9Iffjq?=
 =?us-ascii?Q?7iOlropnLIchsrQpkWqJETum/7JUjvYK63ZvRoLoVhtKUZFdlEGt4LLLv59s?=
 =?us-ascii?Q?ZtJ81ELHslUaqRzHUA/exffndwtHATB3yUq+sLnJXXQvllem2JqACaH+mjGx?=
 =?us-ascii?Q?53rg7IkjKwt8DuZwfw3VKhAwdteHwm1f4QMLsDnc1+lJpmYMjSfUSMUa6EYg?=
 =?us-ascii?Q?SmY2KaBoh6xqYtfy97Mjq1URFRI5qbQLH8v/vje2Pw9M+O1IsUDdOcn2plfb?=
 =?us-ascii?Q?hG2YLlJocU/9/gFJkQQvVfibHr9mD5fzuZPr6K7OKjN9/5qK+G36cDGFJ5v1?=
 =?us-ascii?Q?QuRP4VHuPZ1AmOu0MskOjKXvae7W4LBTHZ15P0z7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 865849ea-bd4d-40da-6322-08dd1b1be97d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 02:14:45.3515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ezwkbO4MErT+3haV8IW5jWViLScwxoorqobXLXSUxgBiuvfeTditku8mypqQzWlxYJLEbe4H83u6Oz5z6f6yKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7434
X-OriginatorOrg: intel.com

On Wed, Nov 27, 2024 at 05:34:17PM -0800, Sean Christopherson wrote:
>Switch all queries (except XSAVES) of guest features from guest CPUID to
>guest capabilities, i.e. replace all calls to guest_cpuid_has() with calls
>to guest_cpu_cap_has().
>
>Keep guest_cpuid_has() around for XSAVES, but subsume its helper
>guest_cpuid_get_register() and add a compile-time assertion to prevent
>using guest_cpuid_has() for any other feature.  Add yet another comment
>for XSAVE to explain why KVM is allowed to query its raw guest CPUID.
>
>Opportunistically drop the unused guest_cpuid_clear(), as there should be
>no circumstance in which KVM needs to _clear_ a guest CPUID feature now
>that everything is tracked via cpu_caps.  E.g. KVM may need to _change_
>a feature to emulate dynamic CPUID flags, but KVM should never need to
>clear a feature in guest CPUID to prevent it from being used by the guest.
>
>Delete the last remnants of the governed features framework, as the lone
>holdout was vmx_adjust_secondary_exec_control()'s divergent behavior for
>governed vs. ungoverned features.
>
>Note, replacing guest_cpuid_has() checks with guest_cpu_cap_has() when
>computing reserved CR4 bits is a nop when viewed as a whole, as KVM's
>capabilities are already incorporated into the calculation, i.e. if a
>feature is present in guest CPUID but unsupported by KVM, its CR4 bit
>was already being marked as reserved, checking guest_cpu_cap_has() simply
>double-stamps that it's a reserved bit.

...

>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> arch/x86/kvm/cpuid.c             |  4 +-
> arch/x86/kvm/cpuid.h             | 76 ++++++++++++--------------------
> arch/x86/kvm/governed_features.h | 22 ---------
> arch/x86/kvm/hyperv.c            |  2 +-
> arch/x86/kvm/lapic.c             |  4 +-
> arch/x86/kvm/smm.c               | 10 ++---
> arch/x86/kvm/svm/pmu.c           |  8 ++--
> arch/x86/kvm/svm/sev.c           |  4 +-
> arch/x86/kvm/svm/svm.c           | 20 ++++-----
> arch/x86/kvm/vmx/hyperv.h        |  2 +-
> arch/x86/kvm/vmx/nested.c        | 12 ++---
> arch/x86/kvm/vmx/pmu_intel.c     |  4 +-
> arch/x86/kvm/vmx/sgx.c           | 14 +++---
> arch/x86/kvm/vmx/vmx.c           | 47 +++++++++-----------
> arch/x86/kvm/x86.c               | 66 +++++++++++++--------------
> 15 files changed, 124 insertions(+), 171 deletions(-)
> delete mode 100644 arch/x86/kvm/governed_features.h
>
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index d3c3e1327ca1..8d088a888a0d 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -416,7 +416,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> 	 * and can install smaller shadow pages if the host lacks 1GiB support.
> 	 */
> 	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
>-				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
>+				      guest_cpu_cap_has(vcpu, X86_FEATURE_GBPAGES);
> 	guest_cpu_cap_change(vcpu, X86_FEATURE_GBPAGES, allow_gbpages);
> 
> 	best = kvm_find_cpuid_entry(vcpu, 1);
>@@ -441,7 +441,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> 
> #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> 	vcpu->arch.cr4_guest_rsvd_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_) |
>-					 __cr4_reserved_bits(guest_cpuid_has, vcpu);
>+					 __cr4_reserved_bits(guest_cpu_cap_has, vcpu);

So, actually, __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_) can be dropped.
Is there any reason to keep it? It makes perfect sense to just look up the
guest cpu_caps given it already takes KVM caps into consideration.

> #undef __kvm_cpu_cap_has
> 
> 	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu));

