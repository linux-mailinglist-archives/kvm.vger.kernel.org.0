Return-Path: <kvm+bounces-24076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00700951122
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 02:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C1BD1F23732
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 00:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533588C04;
	Wed, 14 Aug 2024 00:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZRXSJy45"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E6D631;
	Wed, 14 Aug 2024 00:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723596502; cv=fail; b=NzYxqWgb62QqxGIS2oFHDNu1coDPqYLGnQpR5CAq0bVlQEG/aSv/GpWWk6nZsYCMU+DrgbwfW3oKARQz/1D92qZo4mnjJO2qWYS5EygAoJPYulKsvXlNMW+p3T3+7r0SGrSx/YjfUmOzA0V2km98aVaxERnj4JtZ1c8o+Wjvqr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723596502; c=relaxed/simple;
	bh=2qE7wEPUN+7rHc5Xy2a7F9lIl+hnMSUiymgL8B0ZPhY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QcpATjLN5q+Qp7un9m12aAaD72OstJtAgy9WXPt9UDhsaqZzlQwEqNbhvgCjoeC9cF/lyx8e/wzK0/TMJpfOzdRf/AH6Ifen+NpZieXH/b2nUSDcUDY6xuhBtUUq9goPtbSQV+98fjMzwHqf0yrI0+TK2QWEPmuFtC1r0ALErdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZRXSJy45; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723596501; x=1755132501;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2qE7wEPUN+7rHc5Xy2a7F9lIl+hnMSUiymgL8B0ZPhY=;
  b=ZRXSJy45V+frjNIqGQcnObdYavt9uRam4lhJrWKFIKbfnCEHAOXX6/HR
   QRrQXLhxXSQeClt0e8WCwGvvefoUWU23JdzlkWjpknB4Bm797B0t584KB
   oR/BJNoChvBXHs/8HXIQPqdQ5eLhbPvnRguZIX/oDums3YUZUHBq1kzny
   +oi1f8C1rPlQN2gmBctQnGtbIn0Ze9vOqygEnwyW+m6nV4wKHaSOA8j0L
   gab704D/sjdIYxaGPrtkBKIBp9raJ7RQnVWQ7a0ZeSZVZz1cFLsG8Fl96
   pIzlYBapp+wcXZOn4ZEHmHRMI8o+hawtr0IuJ9bsE3UahEI7wkSjupZPi
   w==;
X-CSE-ConnectionGUID: tpx7fBEqRsuTF9zAhz8XBQ==
X-CSE-MsgGUID: eYGylMDmQ4Kd6TLE5FvrQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25590851"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="25590851"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 17:48:05 -0700
X-CSE-ConnectionGUID: /rNuMGbLTYmA1MVg7JtzCg==
X-CSE-MsgGUID: 9xDR18YcT42gjReBjf1gwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="96362070"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 17:48:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 17:48:04 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 17:48:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 17:48:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 17:48:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QTbYM9FLM/K6hMkJ0R91qIcSn5B4CnmTeuEE+GQg4/uzJJZsRExQErqnVLMSiQd9IhC3p1/vTeKDE7u+owhfwv3UpFWwJ75lZmeoGWp+EtnunCCxqZdmZrSiSgQ7mUHNyUgjU8Ux8lM1rEcvQApD9c0lAs7MU431mD2hlyl8o0M+CmmVkXyX7cNM/NYh/cc3MkHjDFwtyPaoskSfVv78eDnd9T+Z6eP6mAVVknGJ2xtLUOsMrPF3EFwkwfPAaPsSRpxFfPHtlNsXr3BQOkk67VOy/0I5k2GVwajRZEtCMVivQBp7ufg12dy59ra08J5DWUbXcwC1gk0mBaHu8+jLUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qE7wEPUN+7rHc5Xy2a7F9lIl+hnMSUiymgL8B0ZPhY=;
 b=UzUp4Dl1liUT4gxTl/I/6Ao+d1kAOLm4GvZAQJO7xeQjUa+l2dEiHmtusg0t+ehFN486uv1XO+S+VJRafiVHPrjrVtjUz0galFRlP/68SNQUjo5MTjEv3s09Gg5urlM9tLc1vEZZXHE8B0dEXwwT5yUp1WJjYhLbhxb1VdzOCglb4WwK4DYkKtJZ+r2nKBZykVbFruM7CH+QIeqWLRHaAdZGY0o7TRofNmGJVmkThOrqadRqRjhLDa2bCIkwv9QZY3gN9NyVR9+y9zWwDMsDhPDFQAzq6/JN/X60d3WiApjG9/kLL8dV5bPU6Gfbqau3jwe71tc2hOgrlc4T7fzyGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.33; Wed, 14 Aug 2024 00:48:01 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955%6]) with mapi id 15.20.7828.023; Wed, 14 Aug 2024
 00:48:01 +0000
Date: Wed, 14 Aug 2024 08:47:52 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <kai.huang@intel.com>,
	<isaku.yamahata@gmail.com>, <tony.lindgren@linux.intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Message-ID: <Zrv+uHq2/mm4H58x@chao-email>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
 <ZrtEvEh4UJ6ZbPq5@chao-email>
 <efc22d22-9cb6-41f7-a703-e96cbaf0aca7@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <efc22d22-9cb6-41f7-a703-e96cbaf0aca7@intel.com>
X-ClientProxiedBy: SI1PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::18) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|CO1PR11MB5089:EE_
X-MS-Office365-Filtering-Correlation-Id: fa84d8ff-aa84-4879-5511-08dcbbfabfb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cwui0N6CP6YQCJWh+ofcvTewcKRCuUJErtXzWIP8E/MCFEKgL86naQaJtYVL?=
 =?us-ascii?Q?oeSMPQE/eOBI1KcwPLRwFvyD9QKJTUs9zLzG1HY+Mgpr4SSvdlUX8xxvNt5O?=
 =?us-ascii?Q?swJu82uzBorBbDURsA2cSMr/IPfDWgDpvn2I8RfABW/YOJZQJWxAxqiyHAz6?=
 =?us-ascii?Q?IH8oijwJ7lnZqHsO/McAszTYHtM1lm+iTNUkIsqzWB9rN06GALRTuOTA7yj2?=
 =?us-ascii?Q?6Oa3MMFUf7vjUj1g/at2Co4+JGzBe8ppfku8807r81xW5SslMqafUBdq2+hu?=
 =?us-ascii?Q?9LzFf+VvPmFkKd3e1mvy6tZOkg0IWhrMv1Mjv1p73bXsVYTaJdyWhqF+W1T6?=
 =?us-ascii?Q?i9kR8RCMvGs6958jCG2+5f144Csv/eLDbjsjfMiPlPeoe1PzOGTVFUUvB2pz?=
 =?us-ascii?Q?nZuvcT4edWmjVHSDCuvVujWAQCgWP6rcXFkMo0lqMJuEmJOG+dAi9ntOzeoa?=
 =?us-ascii?Q?EpzuSwDUGUIq0G6AXOL2Ri3iyHJ/Sxql6pd+xa9pYNvdddWrCPLlB0/HpGZ/?=
 =?us-ascii?Q?JUlw0toJiLgngd1y/DAj9/66kX975HcOXXfOdU98AVFPk/49G/imLfgSlTJb?=
 =?us-ascii?Q?UkUxSOfRWsKWdZ/K8aQHUce+eH5HX3LuWjCBL1NXCZokS/baNeli4K6t0KU9?=
 =?us-ascii?Q?lcuL4MTExzEpyTQxGEnu50bMC5HbCBKmIkQEo9wqBpqrtPz7hCoZrGi/2ETo?=
 =?us-ascii?Q?cVuPjObJk4AqGZuRfY2T7kjojgXFLM/CBrbQoR409kkvgnT4anVqpmUbagqK?=
 =?us-ascii?Q?pCqndYrXWK52D2AN3oUOYaZdkDROaW3pzcW40VmisEpA9rNvTRYBwEWjuX1p?=
 =?us-ascii?Q?gAovTWdGiYjWdmK67/JsMnX/cK3XkBviBCHUSTUHCc9wauqWvNfwnyB8T+PZ?=
 =?us-ascii?Q?2XNUPtNAQmFx/r84YcmWhgVaiPBLKtP8N+IepK+Wak8z9E9MbFq7xbJmfyc6?=
 =?us-ascii?Q?mTyE+hYvAjxL2fIIGbflcJAdlgUc3IupjDEK0oJwnVQTlpazuZLxcnHnQa+d?=
 =?us-ascii?Q?FK4mQJYHB5UvT3YRTFpzsVyqx8he6miuokkj2nvRyi0o0jiusRdsoCJUhghS?=
 =?us-ascii?Q?DhFdiyJcOBYPcfmPEn9Wv9mYtyXGbQPAFdOLUfKZTOc4JnBsfEMgE7+I7sli?=
 =?us-ascii?Q?YLm1SU6eXUtLEW2c3vUQ4GDNDN8LjShpb0ueEDIKEhKQgL9OM16e9sxwZKCz?=
 =?us-ascii?Q?gK3clNdKNgigDfSC5Mg7v6LRhtzqrHXv+ijTo7BSugGV7PNzO9qtQyMKbdBf?=
 =?us-ascii?Q?ZWudvuEFsNSiRr2/BOdoG1fT2HnOORiRacIYoho4mc++hfLUWRtZ25WxWJ2z?=
 =?us-ascii?Q?7j6Mh0Kk3LG2ipk5D4IbzEikIO+YVsd1WWVWHvPtQK89bg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bR4To4yC5DMbNjFyYfja6nisX5w3uVZ8Eo4ZUFVHk1TeLKlEkBNHDBbrg7gw?=
 =?us-ascii?Q?OSVyGtWVX9Y46EOPRaN/Pp4BmZnP3IFWl+lO9ov3ynzfHKBYIpFdNy4O9tXS?=
 =?us-ascii?Q?+xeJd4wbgQeduDqvfuxtUu2GTzVvO2YzdYscIttYx/SbfKpmKZOl58KXCWqG?=
 =?us-ascii?Q?dRbxTuD6eUOKjADRlMUMX66Bmp+HHtEvKx8TnzAhpg6S6AcgDkQyZgWDW2jJ?=
 =?us-ascii?Q?gr3u27SioJoASOq4UuUGnP6Sud+8ICwlaclUhzy5R7+bQKhQGoxkyLwNzMF/?=
 =?us-ascii?Q?FI8t5T/3++Bum4TpXdQ31GT/Pb26ndWUa0pCNzMhyHxzzPbv5btzUs+Mzo4p?=
 =?us-ascii?Q?SkbnpuY3hBQw7EXKRMDYQFu68lY7fSvq/kBk6gBlhORj0zJNt91ABQe/R0HX?=
 =?us-ascii?Q?KNw5yszfz5tzBqsjkDvvyv7BimXiZ9tlwvi3ZJD6Vc1kzMkK7B3ya3wRe15S?=
 =?us-ascii?Q?nWLMjhq8JRyFv6ipVmbIosyeIvKG54DH3jp2k2dkOWVoAqFEc3rUi54Gne15?=
 =?us-ascii?Q?0eoVpCasPFDEfswbH4QpY58EMmJhl1sXot/PRvJpaJG8Z6zwMwXYTNR12UVK?=
 =?us-ascii?Q?YUpH7wEKtHJbGVVcDy2OPHd8GB2Ac4D0uLuhtZfWb/UBAipaqABkdmHPYVEm?=
 =?us-ascii?Q?jJplhYNR9hg8ZlR75mZDESdF0OlfznTlyxoqGCMhHJJX1CI7q7p1PO8LVYTN?=
 =?us-ascii?Q?UCULJYuPsVvrk2psg3Mra/MYlZF/v9320m/lnrtIUyB5KQUc0SKm/f41fca7?=
 =?us-ascii?Q?0o1X9mj1UVkvY+EqHjtCR87U3hlkkhVVmE1azB3f12aVqgnTFYwoeg7HC7Ry?=
 =?us-ascii?Q?tM454ya7yECjcIgW4RPdcgR2OPXO0WcRIk6x3pMB1O6awawkknaLWvHfrBsO?=
 =?us-ascii?Q?r02LZsQ0zr0u31sHzWLylEoZ1uacQv0SFsNpPuqD1Kd/PSroqb4dGRue7bk0?=
 =?us-ascii?Q?y4A8V12zfnMFHSK0D6nSyZ0TUs9EKmisD1iCwppuOnrp27iTyVAy2H7NxWtf?=
 =?us-ascii?Q?jhBaOmOSxcv+FWSw4dVwXhh9ECqFlZ7+rDYYMoe3RM+JjMq2KX2CJQgVT2Jk?=
 =?us-ascii?Q?lg5iImeytQ2PdvxX1h4lU0ZkmytRjVbeg25JBiWsOS6Z9uBAK/xWUr0+0Ijo?=
 =?us-ascii?Q?1vs0KappciwNdkXi6CxjxPLq78KVTqSFWgJcFTKJKtC/6PumRq9R2qxXLksb?=
 =?us-ascii?Q?DOg75CssSSFOaBQiDTxeLtIhrWDv1ZiKdZqsCdLC1sUoKpTPLSGthZ81D07+?=
 =?us-ascii?Q?wxUw3sIUAqHmWpzEyhmexAMFOOFlpYnXHbvqWkCaZ1Cmwg+jYE740fYz4q3f?=
 =?us-ascii?Q?eMoQ3TfCysLaJP+TnNnyB8gArqN7JTeC1K2t916pP2XRHrUr1YhT3K6E+yOb?=
 =?us-ascii?Q?Ddq12VkFYcY9OaQKmw3hmupSJna8FQiXRZNNsy99jGyF9l5fPrJIFfGQVhEX?=
 =?us-ascii?Q?faVHmzQboTb7951SScGwD7Bqbe1ziUZRUHHyX3dUqvyPx6+mb5oahOeMQn7d?=
 =?us-ascii?Q?Gor5+HomEvh4Ts38HOCcB/x866RjxU9GxZQGg5xs0eZEVK+AXsjQwiBpNgIT?=
 =?us-ascii?Q?yejMY6XjdlvhyKLIkuJH1+M2VKOggG1N8OppHyXS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa84d8ff-aa84-4879-5511-08dcbbfabfb9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 00:48:01.3953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dixmI4L4ThMcohPZQ6P6aZIUs8tquKf76zRHo2lV4J7D1TvmxPq92wV9r6uDBWlofUgEM+ukXKy/jX9YbS13Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5089
X-OriginatorOrg: intel.com

On Tue, Aug 13, 2024 at 11:14:31PM +0800, Xiaoyao Li wrote:
>On 8/13/2024 7:34 PM, Chao Gao wrote:
>> I think adding new fixed-1 bits is fine as long as they don't break KVM, i.e.,
>> KVM shouldn't need to take any action for the new fixed-1 bits, like
>> saving/restoring more host CPU states across TD-enter/exit or emulating
>> CPUID/MSR accesses from guests
>
>I disagree. Adding new fixed-1 bits in a newer TDX module can lead to a
>different TD with same cpu model.

The new TDX module simply doesn't support old CPU models. QEMU can report an
error and define a new CPU model that works with the TDX module. Sometimes,
CPUs may drop features; this may cause KVM to not support some features and
in turn some old CPU models having those features cannot be supported. is it a
requirement for TDX modules alone that old CPU models must always be supported?

>
>People may argue that for the new features that have no vmcs control bit
>(usually the new instruction) face the similar issue. Booting a VM with same
>cpu model on a new platform with such new feature leads to the VM actually
>can use the new feature.
>
>However, for the perspective of CPUID, VMM at least can make sure it
>unchanged, though guest can access the feature even when guest CPUID tells no
>such feature. This is virtualization hole. no one like it.

