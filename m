Return-Path: <kvm+bounces-19655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC9E908439
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 09:14:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B06BB21395
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 07:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5633E14882E;
	Fri, 14 Jun 2024 07:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EaTkOv3n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9D6144D38
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 07:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718349251; cv=fail; b=IHsmt9f0WwD6/9bahoDHkgum96/djg49zp9Oy3WFn2HOsXaoFcuo6EyYliugfel6OqmPXmOq+KUemL6ZD9pjmwywapUtNNo85jquqx8eOPBpls7KkMxhXWl+xz85GxlwUAxVthMjbm6YJSn+kNJUkkFAAslh7jZB3zihbtIf3XE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718349251; c=relaxed/simple;
	bh=cjaqLq7C8M1EOI73OK6mifVhKR9o/i8Gxged+YEC9e0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=NVDzFjDX9ZX4rgFj1tmWKS/7CelVENicCCuA+FSTxQt4McU3c3fqwuZhsB7IYfCkK4iqK2BfykkD7E4qnzg2yM78aDvtVrPzWK7W5L3oJS1h/dVFGd4PKrhKybUq2kJ4D3Ft/R9fLuKPXqKtB6puT7NgYn4ZKub1gtkWWkoWz8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EaTkOv3n; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718349250; x=1749885250;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=cjaqLq7C8M1EOI73OK6mifVhKR9o/i8Gxged+YEC9e0=;
  b=EaTkOv3n+ScvbUHVEMME3uvkAztt9SKXEh3Y53PMEVJ5w94E9AuvlCEw
   e3wMeBs01DXUv+s1k7NuK2kMip0xvBCPrSdCkUYoJLfefc9eQrgT7ExMs
   Y/ozKB99441sgSF1gr+XCNkry5QxCFo+tjPF5dRFBI31QB8CVLKqpwRu9
   2/sUnNVn9q1eEypfyJSZ5/jQ/TwaVIX2yLvgVl5MMLbpRjIuUMJpk9mg7
   yHEZCYgdBHzrWHWtYEch3uDZHwwNydisxJp9w+KqId3BuYQWjqEAcmvNs
   q6VTLoXefYRymi5wpIdwL/532G64QXCdP9fWbsUe6HooqUV1mFkRpajgY
   g==;
X-CSE-ConnectionGUID: fzRclmHgRY+Cq/JW22zuIg==
X-CSE-MsgGUID: xJF22gw8QOSSaTtJUumbnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="32764604"
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="32764604"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 00:14:09 -0700
X-CSE-ConnectionGUID: RMEUZVmbQ+ePc7PTu1p6xA==
X-CSE-MsgGUID: mpvBpGBxTUGbhVk79MVRew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="44939734"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jun 2024 00:14:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 00:14:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 14 Jun 2024 00:14:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Jun 2024 00:14:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNVzU6hUal7T8rxn4JnvnyDbdF5fVqNmXMEdbX/ir0p3Q9+9cUtjH2vF8VjexIm4YLDvD4O96frAecQSgUlwu3ow1FKj42C6B+3KKfNE4nxgdDbbMWrvNdWSmgrAENgG+3K8aPIxCDcP66E5RL1qdTILCve4jWN014IJeyFej3bU8XQvI882mw3xHTKL3gRqDj5CBJofKchMf6KECHqnjOK8fiz07RhaKYhUq0E1MZ3nObsDgzbfFdV2U4zXue3YR8xyqTMYIXJlZxVLJmZYPHRbYzLk+mS8avLbP7iZQ7UtEn4AyNJZjGh4JVjxOCQgcvEA9ONbIxkDoVj8SlADQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjaqLq7C8M1EOI73OK6mifVhKR9o/i8Gxged+YEC9e0=;
 b=gKHecq2dsIrRgTwwx54Aj0sTipxzQCirr4dnQpYfitFmAIcDCYuF/jP4hSKXAlodlIP3uwIbFljF2BTpLdna7rhMRwCPewJBoLC3lg05ydLX3kQrqFHC0WA0K+LzHfUEK1fD5ETRhx//nPi9GhTBvZTVlb/43G9wCHsqnqMpvDeQ6PUD8s9FXlM7CxWMUhElZy9JJ6PBnpx1D/41Yo9T17BK3uAoL4KCrgl7NO4LBkhvRdTVnrSMEVjhEBpvXWdneMlVvCkCUEE1Rn7BnkBeW7FlcR5DSbiALtLJy9f1DERQ8G7RbfgtVdATznVr44KMLw5RSR3nYoWmYXfiM0SlOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS0PR11MB7213.namprd11.prod.outlook.com (2603:10b6:8:132::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 07:14:06 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7633.037; Fri, 14 Jun 2024
 07:14:06 +0000
Date: Fri, 14 Jun 2024 15:13:58 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Linux Memory Management List
	<linux-mm@kvack.org>, Yiwei Zhang <zzyiwei@google.com>, Yan Zhao
	<yan.y.zhao@intel.com>, Kevin Tian <kevin.tian@intel.com>, Xiangfei Ma
	<xiangfeix.ma@intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
	<kvm@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [KVM]  377b2f359d: kvm-unit-tests-qemu.vmx.fail
Message-ID: <202406141424.5053d640-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: TYCP286CA0217.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c5::18) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS0PR11MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a4ac1be-c1ce-48e5-25b7-08dc8c4193dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|376009|1800799019|366011;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?70boO9c34QUffRsqIscAvfWi7UAm7s8j1poXY2Ug96MybpOE4cE+82B8Ojan?=
 =?us-ascii?Q?7ZjP2XQuONYdgbZuk/A1cAtO9tj24bIdlsMuKLmVZRz/F51mpsTBcQmcvr1Q?=
 =?us-ascii?Q?f3hzm1gl5yGqySD+CBY11s0l2zIivOgYJ7Q3CvgeBXHcP4OEVMmdCpbPMR/Q?=
 =?us-ascii?Q?bHaqBYiLCJ52HWnhq1Wx0T1wRgx9BYasUnt6ce/zzulvx481LfAz14qCCWM5?=
 =?us-ascii?Q?T4ZPk0parrTHPe7PuF6MAdblngZDl6CC0az7TV9Wt7VzPDDrBiaFj+TLpL8Y?=
 =?us-ascii?Q?l/HHexPUZ0OinG5qxP/Y9tZY4mnVmRuasQMWIQ9t43Cgd8uzjnTjZFCOT6W7?=
 =?us-ascii?Q?CE7cdGBSoB40bV8pw7g1/f9PSKPj2wEbLMGzBoVyc/C4rmW7bZsJYB2o3QE0?=
 =?us-ascii?Q?ZLZU9xY3Wq12pAPBL4ArXPE8l4XIGI6oAonxYI9ZdAexfVqMsROn+xpL5Dxb?=
 =?us-ascii?Q?8eGkNrM+++jzUMr2H9a4bn9UvGHTaR0f4iOwHwISttn7xjrSUkJwXvmLXuAV?=
 =?us-ascii?Q?g+mQ8PKEpPgHFt/BpafsAmA8Ar5enGnXlssr2LRtcKAeoIW2GgZQujivjPe3?=
 =?us-ascii?Q?K1FTBvrbdqrj4W47GYjRFmWFldeIKkk8mwWnlBrzzAMlmXTyf8ub8Buv76hv?=
 =?us-ascii?Q?MT5Mf3D3p67gkhY9J8OS5rfJVimaLk6uivlls1ejqvKN3IiEE9ltkYvolnBa?=
 =?us-ascii?Q?D+6uN2hv1DGJ/9nK112/Zacw97rUI5OKMuPaelGSy0wrNtlVNbMaX5Qcqt9N?=
 =?us-ascii?Q?lD5U6JtUIeYytf0liDrP6+c7GnQL87hKSyp+lK114IQTBS/55xoWlf5e0EJc?=
 =?us-ascii?Q?gtGSN9ZwxJjKP/TnqXf++cV+fTC/YXT08VQvtT/D+0+o6+Dy7SPEWzgodEGi?=
 =?us-ascii?Q?MQINnSon1ZyJCpdfa6ZcWDv9bPZc7h4A9jYEvh6xJhlNAyleQx7NhZ7NcBKa?=
 =?us-ascii?Q?iV6GiiZncdfeTIqD6yKpRxnYgPEmwPE7fYvh2arKnKHatziP4pXv1LDKV9vm?=
 =?us-ascii?Q?Druqv40vuLnj0nTKKVyCopZThl2kkDcwEBHHIzSf7Yi9ieghWNIxhzyG6RqN?=
 =?us-ascii?Q?mLbeufA4HP69pi1AhCSJ31pTCJwAE2D58ztKq9v2pKQHrq2cIMqLgNaPIeCW?=
 =?us-ascii?Q?Tyx7Z3hT0b9V6UJOH8yJXfTOXdaOOZsg3/mWd8Lk3YlX3s+WOFNkMrsTnw+9?=
 =?us-ascii?Q?l7cGewcti0lTzqSNkL5BV5mYB3yQ90h4eUYjB//eZp0Gl8YeGPKT3JBVFR+c?=
 =?us-ascii?Q?xOgWdqpXaGfgnR9/kHesR95cy+0IcM6NiwUQ1mTBDQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(1800799019)(366011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hSCzam4OT36dZDXkf7b0RfT0OCfDZBaTyDo/7sU2rzJX8k1uDVW/l/PAgUsp?=
 =?us-ascii?Q?Ked1sH7brpuscfPJB7Pzn87lSL3zsLFge78O/aSs7FEnt5Mvk43vchWjFP1j?=
 =?us-ascii?Q?DyIEK52yOhGKJUNGhmEzhDjnT1EuDuxf39fwdeB5LgB4mm57TB/MNrSgNwGv?=
 =?us-ascii?Q?euU6ZpgDlvepCqczHBPYtrRFN+hmwy6rpotPTzDTytFyRqFrO4Vs0fyEjzYQ?=
 =?us-ascii?Q?rmXL4aywiKmYUbF6+aYQIrmPT5TCvtMCmW87nv+pCpnteQCwvGj7nXDhgRzB?=
 =?us-ascii?Q?Xawu5NfY3q2/aGbPzvYP/3e8bYNq/oplTkWPkUlfOVi8iZSRYZ4SSTphgK0z?=
 =?us-ascii?Q?r1G2jBeN7WqDyjp2/t+s4LJB+xa2rSDO2GEV9KXHG1tku0cH4I+4lpSU7IeO?=
 =?us-ascii?Q?507iMAXpapfV8ZwdX180XpiTGUO+h0B0Mbdg2jKfGpse8qLF8071WNnU/KpL?=
 =?us-ascii?Q?ZL2EFhyXinp6S92MtstpFT02zMwtQtQ0wZUxaj0Z9zZeWTsg0gt+E8jshS7l?=
 =?us-ascii?Q?GPJFZ475BYkcAeJedPlO9D0fntW7m83vVA5hOEKGzWTtiX9jcBmDxd8OxXuV?=
 =?us-ascii?Q?L1NkG+dW/qynFsBvh1BtqjFcZ9bT9doUVEJZW3viEI+XT0JpqdG+YTwhFixZ?=
 =?us-ascii?Q?4taKcudi0YYiha0Pt2OH+Mz2pA2R40kW2s6F896GCZ3mVVJ0BkVpQ6T3Fuwf?=
 =?us-ascii?Q?qDvABJCoJzzk1/LnJcdLGXrGt/MAfp8uPX7a94ni1bTdODjvkfZD8VWCMVaq?=
 =?us-ascii?Q?8pkvBdMq4zXI8yT8f9znHfzPThDfODT7v1BVD6JIz8jJ+uegsF7WLV2TFfUe?=
 =?us-ascii?Q?N0LyzLVb1UBYRaRw2Qcl+IHjixC546cFnoDvaYaGjNzSt/DdR11jGUnwMRJv?=
 =?us-ascii?Q?0p1W0i09pqFfDnmke3HkB7EFtWtLJpW4vWO+rx/l56k9mlulHK/p6qMWbyJ7?=
 =?us-ascii?Q?A+WYKuJwmlbeMjCJHQeOM1f/6VCRi77mmQjNYBQiQ0vQawNw+AJySRLKCQJp?=
 =?us-ascii?Q?foGgsVBRs/M7WtTJX7CEFF2MoAKfFBvNNuXUC2FD357IxwaykYD2+nyoimiL?=
 =?us-ascii?Q?6p/91sANE+DLK4Nky3QUFy3Q/WLNu/YEBsAb68SARVSVRDcFkD6j+fltV2Mg?=
 =?us-ascii?Q?VSfwFTYJAVaMqq8gXJ3zFsWdeC12s/IGbf6s6WiPlTf2k6151S8KF3yCqUOQ?=
 =?us-ascii?Q?QRToMQPUlnEvU9KZ8ZCF76lIfBfZ54oWJgVOFzjFJ5kYhyCf0L+Dykw+2fU7?=
 =?us-ascii?Q?iZzNLKY/Y/nB9v2lXfT/lZQnaWT98F/+z3QQg5eMOcAXOGvkKNUIQqWpyzLo?=
 =?us-ascii?Q?/XCeobz362PpUpGqev793FHO+B/kglSCOZ/VPBvf7c48I4g2ld7V77v+JHsC?=
 =?us-ascii?Q?ETINMKbBTxG2aUgGfOtMBoKVkwV1Na0xCE/UHqlqz3LKlLu+hcaeW1WfVDC2?=
 =?us-ascii?Q?eW3Eo6iuJc+ut/69tbw9TswWqa8eEjCjDXATzVeyfnT2nZr9BVJSHayspmJD?=
 =?us-ascii?Q?1g95fwZsQywBece9b1nAAe5NkHkQXEl1v7THL0pCAf5MihGIEXfNhvDR9SZF?=
 =?us-ascii?Q?viBhRAEHVGGUMi/dT8BuWUAqNhIcE4D5lsBYqXOXs44m0+9XouJkXOpjtpdd?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4ac1be-c1ce-48e5-25b7-08dc8c4193dd
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 07:14:06.2045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6VUXdl3ux6btF5kdFTLEpMRpav4UXV+KIhn/QtJV4xLpAPF+enKjMQld8Vtbl+bl3DwqCcZORKBmgVulnTEXgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7213
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "kvm-unit-tests-qemu.vmx.fail" on:

commit: 377b2f359d1f71c75f8cc352b5c81f2210312d83 ("KVM: VMX: Always honor g=
uest PAT on CPUs that support self-snoop")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 6906a84c482f098d31486df8dc98cead21cce2d0]

in testcase: kvm-unit-tests-qemu
version:=20
with following parameters:




compiler: gcc-13
test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.=
60GHz (Ice Lake) with 128G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202406141424.5053d640-oliver.sang@=
intel.com


=1B[31mFAIL=1B[0m vmx (65128 tests, 2 unexpected failures, 2 expected failu=
res, 5 skipped)


as a comparison, on parent, we observed


^[[32mPASS^[[0m vmx (430039 tests, 2 expected failures, 5 skipped)



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240614/202406141424.5053d640-oliv=
er.sang@intel.com



--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


