Return-Path: <kvm+bounces-70167-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id /xcLBf8Vg2lnhgMAu9opvQ
	(envelope-from <kvm+bounces-70167-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:48:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AECF0E40E1
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:48:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 99C60301DC3A
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 09:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4D63B8D46;
	Wed,  4 Feb 2026 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JBm+DBTx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960823AE6FF;
	Wed,  4 Feb 2026 09:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770198517; cv=fail; b=NwE8undXKrUib72OV/LOEGhJcdEI2AQq8GFEhiECmjvh6Uk5eSeiI3gRQiEBm/aVAH7hwb2brltD6TH9CIep+uuLBZPTeKo2bSwX0pvNx29yVromWkyq7fs1pl14yuN1BbsxeZ4BzfnoWW2QNSHHqhiDf33I5nSreWFRcwI/IFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770198517; c=relaxed/simple;
	bh=qrIXeKa9ERym5TkFf5bgI7JWKSDPbszxVYElkwt7gqs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GPmgR2vRJPHy3RTe82KvRKS9oEuI+hCbm8gMIlIDF6zeNG6Y7O+PUep8qCRoXwufm7tgWi/Ob2MVdQPubZxxTbDa9eUdTrbXFVaArVi2kbkEoTR6sHW9pCRkqn8AfWR4HDkVJMojbP7+3oKo0tRl8udOU2iJa9AfFhTgRNjixNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JBm+DBTx; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770198517; x=1801734517;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=qrIXeKa9ERym5TkFf5bgI7JWKSDPbszxVYElkwt7gqs=;
  b=JBm+DBTxEM7Lq44xIRZyzr/YTZJ3z1PMM78XZTS0dIZQbX1KwzmDQr2X
   0WYWD2NHiyf8+1bqIc5bPbJkjZHSciaeTSHBGVwyL3rLebgsPO9P95sQD
   nP0RiIJC287L52ltY0tAAavEL1ThA7EKQN70vUvfhwb5CwlkyEjKXimgF
   q+4J3PPv+MvJrJMglILktqdpQJOXNm8dzpcpWoQ/FwwgMovyG/ixPBS6/
   hHJREMGp1ATi6nq6yLfILzEerLeNJTQjohT9iUT2Y2pxB6nuMfc0wio6z
   9V3KHej34XPHQmKJFwi7grTPpTQPwhhU5m4PFWrlbV16tkPEIDSdtBRHM
   A==;
X-CSE-ConnectionGUID: lVD4zWX9QrO7Kc113m03UQ==
X-CSE-MsgGUID: +0dDsCdcQMGVZZ160cT5Ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="75001594"
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="75001594"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 01:48:37 -0800
X-CSE-ConnectionGUID: lbeqZDH2Qw+y7KVCXve5Zg==
X-CSE-MsgGUID: BckrjCu5SfS6Q5NwPiyouA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="214811819"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 01:48:36 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 01:48:35 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 4 Feb 2026 01:48:35 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.34)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 01:48:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0v35gxnJM4zcWtD1i5hirS4Yvyf/dCrcep65H1MLnemc4m9i1owAULj9QpGEogv3CPLTxLqzUNErSRpfw/wwDp5kQT563iCuKk/9I9TVvfgz1HrbMPeqBOMoykAKzeh3wOLTCWhnfjvzGFJrnt8TiSYcsG0VzPVXXx2671AtfW81PrjxDBOFzBJgAR4TjKhr92reKHRO6Ey7rrgCumWvqv5/FluIbk/QC/Gv8c92szpAu2kXRqf3yj/K+Nb8JFidPFzMmRrrF8ixaujzCFkWBf4rjsj2YYSYQvoXpJ5u7VfkL2s/+Vz0fQqTpaCn+CobO86gM59PIaXlEXValPniQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h58Opp+TqK2YY7pN1DJ3R2Q+VmjD6uXrZZ/cn45jo68=;
 b=aYof05ODL3gPs7inwn8jWFES/D8fP2d7JyH9eHdijkpyplTJX3NEu1w1l36IPSuyCK5VhHnOKNshRZmkmgELZU8Hq1AOqB1IBPdER2SXG9nNSjtWl+ZUYemGmAGpSe2pEJZrwXwuxXDkOIffYxUj96tFiNxy1qu/4guuZbnrNGUfpsGioG3avDyYlswMri2oUU/gNx25lwDrr/SIH8T/PU3pUzWKBakOZd74DPqekew6NPEkohLBXLxKaURNuJMdVdwFw/7LS78GgmuAiE2gPJ4xlOtDToTAIjJHJhCSoCej/yfjjuB6EekAuDcwtfwVazjYxfaXJd5e3nIRxWybAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6270.namprd11.prod.outlook.com (2603:10b6:8:96::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.12; Wed, 4 Feb 2026 09:48:32 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 09:48:32 +0000
Date: Wed, 4 Feb 2026 17:45:39 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 09/45] KVM: x86: Rework .free_external_spt() into
 .reclaim_external_sp()
Message-ID: <aYMVEX5OO22/Y72/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-10-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-10-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6270:EE_
X-MS-Office365-Filtering-Correlation-Id: c32a337c-46a9-4143-69b8-08de63d28e7e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0Z51TYywma0jpveZIc7JGqOP2Grer8XYV7BTbjZVAzFqXFMKsTFhmgHKCtMJ?=
 =?us-ascii?Q?taodH8dk2OAUkSsrfw6RjE9R46KBEIpb1prE1u6lGWJMI851nWE2Z/5WikIR?=
 =?us-ascii?Q?XPXWSFnMRIemfU4GJmad4OuizBOIXnZrGMUsvptfSS3mJlNVII7zOXNmErsU?=
 =?us-ascii?Q?bCVHYrh8WSqWHS8SYhOOkX18+E0aubBGPQ6Dnpe8ARBy9/jSEYqH6mK1Grdg?=
 =?us-ascii?Q?8aU0NlgKJD4FutW3pZ0JexYJQIl0NP+dQQ7LNKSD6N048QI1NKnETacNZa9U?=
 =?us-ascii?Q?6c9idQj/s7mIiXp/mZwxd+DZrnPMeJMXnnLGNd+iUzVTOiI0gXBlpe+Tv9lP?=
 =?us-ascii?Q?/Ro6PGUzLwmh+Gh0QWQZdoQmWr3h+AS5xql4nvlUkWwXjnWc0dv+4wCEuXcI?=
 =?us-ascii?Q?E/3KzH4J1aA2cANNYv5e1QHpOzJs5Nx2Q0GRHIQJ+gnIwKp1v52TNrmvZGHN?=
 =?us-ascii?Q?ScA8V5vJhpC6jTtQHXpoDg7QjZ0uxGUG+4WDrCuLl0fu8XnVuKsONqIQ3gPJ?=
 =?us-ascii?Q?wSxSF7nET474joOn+gTYIlmAPZDJq9Gp++xc/RTLNMTxpYCpbKLxdgWdE3rI?=
 =?us-ascii?Q?sVRxz4U/6q6Nn2Mh3zGZfFwYrjUQNFPWQ1itxsdfykdDxrY14xsCyo3WTcwE?=
 =?us-ascii?Q?rKilYIYIJa9eQa3/mVmFLRAPETtMwEixIUU3pGFU0siCDbjhJoADOPhwOiVg?=
 =?us-ascii?Q?TsfoV69uaDKjx7xXeH7GuRBhwHVmXO+uGU/9gjOv8dMrYOMC6sw1duUEjy54?=
 =?us-ascii?Q?lx7ewHNbyfWmT/kEWGvz7P//ftKvnlmeiBvG+9UA/p9+VBQdd8G1FzBQbohX?=
 =?us-ascii?Q?EBbTfYrRgvYzUgAuWGxTZtki23hpV1ZqAUElx2mt6hMgeMnTTEUyZB+4pqTQ?=
 =?us-ascii?Q?WFaY0Pp2WNxDg4pnpi5hEbDumI1euE/6yEFMwm+AdrSp4zAfW1C4AikBJkya?=
 =?us-ascii?Q?IvB/LekqH/OkDzrkqpWuI7IDAQevQC0SUw0gFFMEBOw1RcXnh9GGuieFb/ar?=
 =?us-ascii?Q?IlMv5dec0aeizt+z+ue+iUREfGwMsl0lBPm8wYkJBKVrDcewXyo1ShvJr+a7?=
 =?us-ascii?Q?lbhYfKpJ5AJ0UntBYrJs76foFK4ShxZaCXrR8xuk73nRpMJ8HTXWQPKUcfew?=
 =?us-ascii?Q?3pcSML2KlMxi/oK0sSt+vG94ltYa1rdN2dRv8/F5Mu5i6DTvrzZ3XiRNHfyz?=
 =?us-ascii?Q?hlePHZ1IhnifabR1VkxNC4Q2yQ0Xa8+K2cIhxiVRtNeH39MnoZJvglLw3ekr?=
 =?us-ascii?Q?pZOVGrEZDY7FzM7kyzzee1/s+/kSL5OyND6tfKjRxqxziiUGX8mBfNOqil+V?=
 =?us-ascii?Q?wSocCqPcx13piBbijSY/uzyLiV7cRc5E+cOE7zwKUul+V7d3d6/YPPkj7hEd?=
 =?us-ascii?Q?DOUCLSXSrhM8oedtBloGlf6xtOxLlGUC/xAjxCT7ZknUILQBRUGNFfBZ1Zv5?=
 =?us-ascii?Q?VQnNbKcvsqyqvpZwH6h80M2KefOPO1wCfADjOgsCwGJhs1NEsIRUTeyWA6ca?=
 =?us-ascii?Q?STeLUIME/j+eqHlb1gFuDAwKJCwMoqLZ5ky/uQHlsUqcUCWqAq8v480/0FBa?=
 =?us-ascii?Q?nJq256ueu+3XyKXmqFc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u1qKnCDqZzs6KYfeTfzXZiHvz0rjUGEuwMGoOIJ9WKwB9+28xmGmSNi76eoi?=
 =?us-ascii?Q?D421sikHODrIDuD4Ny4+2c72pkEtnjTPVJJh86Z25hxaS8bgeO5Z2m83B4kB?=
 =?us-ascii?Q?8+CSOgzwQLwEN08LbJXKoqPT7mDiDozJe7LOjBMxNfUeYevS9elYf08EueMl?=
 =?us-ascii?Q?uq8sON12VwBj/x++2y2w31kr7I/f2iEY5vDdqMiAxIWsGVFV1MmOTa7c4nTG?=
 =?us-ascii?Q?VDPxAhmwAUiXRVQuEFuyZGY5eGm8c4kehuNdbJMHZCraWLBAqVhF3E5Vx6Q+?=
 =?us-ascii?Q?mDemE7Cj5vDlA04opl8TN18Hd+sulm7aRPe6IrN+Z9n+OySKr9e+tsThWF0T?=
 =?us-ascii?Q?8zQ3KA782TtdpV4Kq/iuS3ANgBCLnbi+rnvrn0PofixsDFuWy7KTUrZOONd6?=
 =?us-ascii?Q?h9MPg6g3mOkeOA7upnuYyZQYnhXIn7uJwDRbYUYj1FIz4GI+ScYadCC7TB4L?=
 =?us-ascii?Q?nk9sDzqlURmlvDGv7Y6CcRCiuwvzPqG1F6zunI7U9TR8YTnuAvII407gIX85?=
 =?us-ascii?Q?CvT8raPkNOEhwpljps/QN7PbQgRgGXVJRBw2Q8az875wsj4ByQODZFPKB6h3?=
 =?us-ascii?Q?vEdwcQFCET8VRe3rqBaH0//ZYm/0OcpECRz3OoFdZjcfuKGOXdsyR8kX97Sp?=
 =?us-ascii?Q?xppx3VzWD9MPc5qk7o464+aJr2tuxVbJw77Mye7tOoinZs6/WmZmxi2Jmp/H?=
 =?us-ascii?Q?kQ+/L/nLfDWeycQa5vaRxfCfldO2IQO2/cekNoUy+QzeIS7fLXzc74JZzdK3?=
 =?us-ascii?Q?Z8zYFn/WvFr5Zc0sDQlHh26qr3lfD73OLD74P5mlC3+J58PKwKoGhevfk77r?=
 =?us-ascii?Q?rc/wLm8JYP58qXQKO9oyovGCE8Hsu6JeMFXRpKIzGEsvQ89WBETKjwVtp/IN?=
 =?us-ascii?Q?NKJq9ys4axSrOaz9ga2VDwqC6zv+IFODoyJhURMImp3FtNFRJGRwxlm9yoUE?=
 =?us-ascii?Q?DzKjFyIBb8EPCZ3sRSBvhA6dNdnv4nFPyrIbySbpLgYJ63n1QYYnAGOvxorh?=
 =?us-ascii?Q?o3v+geGVdf/4EApzI2AY6/nJQPwhHFcnwQ5aeYKfD+FkXL+xnXQDn9Kyzq72?=
 =?us-ascii?Q?B168M6mDgYgmTY7t0bIGXdlR0HHmP7J+lv9XJePWZ2RRB6zJIXFVPAQ0mCNo?=
 =?us-ascii?Q?VRmj7EmFkYRg2726T0IvBg/r/lKGEThWC2zf/8oDawE1CoQWkKgYDIOyAX77?=
 =?us-ascii?Q?ACJXGsEgdOhazPIeFR8/tBgNsImfS/2F/DCUnAkIk/O9pXFtjUwZdjd2eiCp?=
 =?us-ascii?Q?o5yBcgQoeS0fXLOj/L7UOaB1uDhFpuCufAeHxQgDPLXYa1HWpPFwoDRHnPJe?=
 =?us-ascii?Q?5nKTdSyWUd1f1esL3yHKCG3ia5ltjeVo99aiFHIyQwmfAF0WKJlWJWDeP4mQ?=
 =?us-ascii?Q?e5zqv6BXmFP5RPzLYMwg3KKxMjTa2CtcgE1SSMVBUV2gO7CW5Mmx8HEbLX0I?=
 =?us-ascii?Q?Az9OjEUyCV2dLr2Ccgd69WKJIEfxOZzQ8W7/YG12AKonYaWBDyhCtHb21RiU?=
 =?us-ascii?Q?owx1QRKRmKIT5lUqpsx+B6mOifFAg0a27QgquXhGuJYO98hIfbs8rmgKsie/?=
 =?us-ascii?Q?324u8xi35xnrFvx1/jIhL50WbP9zsrt8nyJYMCJj3vy7hmwiwa0SFjASvDfQ?=
 =?us-ascii?Q?jm2J7kRQoPAaxY4Y+WitU0QcxKgRALO3vLA8y2wm4c9DCpfQ6DuDB2qpgPnD?=
 =?us-ascii?Q?Fa7sHx6yH4JY/MeOlRbaq/1Bq6JY5ljWzMqQzDaJLQlyYgzvkcymPzgU+X31?=
 =?us-ascii?Q?ApgOjkxNXQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c32a337c-46a9-4143-69b8-08de63d28e7e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 09:48:32.0685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q++3K0lph17k46Zovfaq2eq/fZJ7zn9EtG2cSYpivIs2geyRYw4BP7uynSvYVSiLhkpoTzycYZ5xYpUr82jglg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6270
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70167-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:replyto,intel.com:dkim,yzhao56-desk.sh.intel.com:mid];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: AECF0E40E1
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 05:14:41PM -0800, Sean Christopherson wrote:
> Massage .free_external_spt() into .reclaim_external_sp() to free up (pun
> intended) "free" for actually freeing memory, and to allow TDX to do more
> than just "free" the S-EPT entry.  Specifically, nullify external_spt to
> leak the S-EPT page if reclaiming the page fails, as that detail and
> implementation choice has no business living in the TDP MMU.
> 
> Use "sp" instead of "spt" even though "spt" is arguably more accurate, as
> "spte" and "spt" are dangerously close in name, and because the key
> parameter is a kvm_mmu_page, not a pointer to an S-EPT page table.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 +-
>  arch/x86/include/asm/kvm_host.h    |  4 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c         | 13 ++-----------
>  arch/x86/kvm/vmx/tdx.c             | 27 ++++++++++++---------------
>  4 files changed, 17 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 57eb1f4832ae..c17cedc485c9 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -95,8 +95,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
>  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>  KVM_X86_OP(load_mmu_pgd)
>  KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
> -KVM_X86_OP_OPTIONAL_RET0(free_external_spt)
>  KVM_X86_OP_OPTIONAL(remove_external_spte)
> +KVM_X86_OP_OPTIONAL(reclaim_external_sp)
>  KVM_X86_OP(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
>  KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d12ca0f8a348..b35a07ed11fb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1858,8 +1858,8 @@ struct kvm_x86_ops {
>  				 u64 mirror_spte);
>  
>  	/* Update external page tables for page table about to be freed. */
> -	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> -				 void *external_spt);
> +	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
> +				    struct kvm_mmu_page *sp);
Do you think "free" is still better than "reclaim" though TDX actually
invokes tdx_reclaim_page() to reclaim it on the TDX side?

Naming it free_external_sp can be interpreted as freeing the sp->external_spt
externally (vs freeing it in tdp_mmu_free_sp_rcu_callback(). This naming also
allows for the future possibility of freeing sp->external_spt before the HKID is
freed (though this is unlikely).

>  	/* Update external page table from spte getting removed, and flush TLB. */
>  	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 27ac520f2a89..18764dbc97ea 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -456,17 +456,8 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  				    old_spte, FROZEN_SPTE, level, shared);
>  	}
>  
> -	if (is_mirror_sp(sp) &&
> -	    WARN_ON(kvm_x86_call(free_external_spt)(kvm, base_gfn, sp->role.level,
> -						    sp->external_spt))) {
> -		/*
> -		 * Failed to free page table page in mirror page table and
> -		 * there is nothing to do further.
> -		 * Intentionally leak the page to prevent the kernel from
> -		 * accessing the encrypted page.
> -		 */
> -		sp->external_spt = NULL;
> -	}
> +	if (is_mirror_sp(sp))
> +		kvm_x86_call(reclaim_external_sp)(kvm, base_gfn, sp);
>
>  	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 30494f9ceb31..66bc3ceb5e17 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1783,27 +1783,24 @@ static void tdx_track(struct kvm *kvm)
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
>  }
>  
> -static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
> -				     enum pg_level level, void *private_spt)
> +static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
> +					struct kvm_mmu_page *sp)
Passing in "sp" and having "reclaim_private_sp" in the function name is bit
confusing.
Strictly speaking, only sp->external_spt is private, while the sp and sp->spt
are just mirroring the external spt.

But I understand it's for setting sp->external_spt to NULL on error.

>  {
> -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> -
>  	/*
> -	 * free_external_spt() is only called after hkid is freed when TD is
> -	 * tearing down.
>  	 * KVM doesn't (yet) zap page table pages in mirror page table while
>  	 * TD is active, though guest pages mapped in mirror page table could be
>  	 * zapped during TD is active, e.g. for shared <-> private conversion
>  	 * and slot move/deletion.
> +	 *
> +	 * In other words, KVM should only free mirror page tables after the
> +	 * TD's hkid is freed, when the TD is being torn down.
> +	 *
> +	 * If the S-EPT PTE can't be removed for any reason, intentionally leak
> +	 * the page to prevent the kernel from accessing the encrypted page.
>  	 */
> -	if (KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm))
> -		return -EIO;
> -
> -	/*
> -	 * The HKID assigned to this TD was already freed and cache was
> -	 * already flushed. We don't have to flush again.
> -	 */
> -	return tdx_reclaim_page(virt_to_page(private_spt));
> +	if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
> +	    tdx_reclaim_page(virt_to_page(sp->external_spt)))
> +		sp->external_spt = NULL;
>  }
>  
>  static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> @@ -3617,7 +3614,7 @@ void __init tdx_hardware_setup(void)
>  	vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size, sizeof(struct kvm_tdx));
>  
>  	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
> -	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
> +	vt_x86_ops.reclaim_external_sp = tdx_sept_reclaim_private_sp;
>  	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
>  	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
>  }
> -- 
> 2.53.0.rc1.217.geba53bf80e-goog
> 

