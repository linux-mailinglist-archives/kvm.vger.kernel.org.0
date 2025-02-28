Return-Path: <kvm+bounces-39654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A717A4903E
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 05:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CE043A1A72
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 04:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C06719DF99;
	Fri, 28 Feb 2025 04:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LfABTaHn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E8D819;
	Fri, 28 Feb 2025 04:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740716412; cv=fail; b=DbHymQniywYVv8AOfeLlJY3v4NLuUP4p+x1GL3j4QjNFtY2EU8VK/y+Sc0nT+1QBwTDRkhmhoOH0dnOfO5kj/PySwjnMU+VmWBDYsyK+4MA4a0vsyzemuTlVa7emrztb3cObL/FOdhsF6f2TH7rTMJUCpvXu3bx8mGaR5du5NBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740716412; c=relaxed/simple;
	bh=sGO9GtgcvXmcwic5ICjbf5yIytEyhIRA7b14ERzTHHM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YbScRVbB+GfEGmzjblwo19afIJ/e0zDhnch7fVnF0zcRtL7equB+wGDbhAM8c24OX9PibJ18th5syeIoSF4OWwllE+w0T03JK2VLq7I6fymuyYtLQqRUVB+w1ytyroUkBlJOq698XoNrw4VCpu/8NcJ67tHeckMdAOSy2frcWoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LfABTaHn; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740716411; x=1772252411;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=sGO9GtgcvXmcwic5ICjbf5yIytEyhIRA7b14ERzTHHM=;
  b=LfABTaHnic0xpxSWo7Suvk8CQNXi60oYVmsS27kz1SDNaXvppXvE78eo
   P5AfvzkzaoF1tC9k6X9/9RpJCSa3PZaxd73cah7xX9PEBf/1kOqJuiVRT
   t/m0vNYelABS2eNtoLLlrMmO7/4ENAExZ800G8STWDPA1mKXflOMiy76T
   seaeXJKjKjWmN+3GZWQqY+YSW5a/e7aiX8joK1/HWynqtIfROYug73YnN
   DKGRSO3Gw4ltYULfUJzpY0Dtx78LcGlI8hBi5YG4c1rpCGRzUJrvOazEV
   zvX+RsnNF1rf12559UgPdlmNSphIAiCpLfNkzyzkdoYRpPa+zq6WhKBfi
   w==;
X-CSE-ConnectionGUID: X7lhLJEsRMuV6hCDR09I2g==
X-CSE-MsgGUID: 2c5aj6TORxi/gZjnGil9Ig==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="52622493"
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="52622493"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 20:20:11 -0800
X-CSE-ConnectionGUID: F49STj9aTdm85pMQ7C3YnA==
X-CSE-MsgGUID: 4Zjv/RrTSl2Xma+d/01cJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117099264"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 20:20:10 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 20:20:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 20:20:09 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 20:20:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yYX84j5vlkZQbMjNjWu0ObNvMAbkm13ob0VS+a12ouIFWyxsEN/ycFDwru3JnVktPtsdPaxN2Cu2eVD4GVMPhaj/0j+IGYor5+xcKHqTin4vkIvx94BhG/1+krnuoTrUSG73eJut7+c5QuW2l8oedqHuC2ZLFpb6w9v5o3tLLxczVHdSXHScSLvsdubOmJeWr3YY5VHzS4Uyktzlmv6XJ/LRQ2kiOmAiuwd7zV0AEgqDdyGVLuHFdFseJE5sGeLuhMxod+4FdmKV9h14LbFAtbRiKBr+anIbdkIhs/CSGTYcHssp89YgaqP7JbzR/RZMMykxgYCWwydVvvU4VRjlKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfE1TcTylckCGHguFDQPVqvH72sqjWsuTQNVtnz/TWk=;
 b=ZnGfTP/5aB2wClG8+08asm7yx9uLJlA7pg7RiK+3lofqyj4+VKCsJgWYfXVIEjlC0WHBt90EiQ1Pg4sWNK1rZzjiLZZ0Z17CF9NIvuhoi5aqpX+hqINRgUtSNCQjDW5M6HYqZ3CDQB8eN9mbfNk2agcFasxYBMUo1Ihb4pkU3m60stEbP47MbXTthw8DjtG5bIWtzGn+WJqyynd/ySq7x0zERPOPHpQBYn57g2HH78X4SNdcp0zBas1Zc1UoYRpcBwOdBxCN1ySEHo5jClQ8ZsQAjG5TlycolnPIiFKNVC0hf9o/iCa7pxXuRvuMBlgdwZN0Yj68gjnoxr6fAJNfLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB5790.namprd11.prod.outlook.com (2603:10b6:a03:422::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Fri, 28 Feb
 2025 04:20:07 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 04:20:06 +0000
Date: Fri, 28 Feb 2025 12:18:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 22/29] KVM: TDX: Add an ioctl to create initial guest
 memory
Message-ID: <Z8E5J73BBGKk8bmS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
 <20250226195529.2314580-23-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250226195529.2314580-23-pbonzini@redhat.com>
X-ClientProxiedBy: SGAP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::32)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: d45f0e58-54a9-455e-dbab-08dd57af2e3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VrFkQ1BXcRjjGri/sC3kfs6QOVC44hKQ1hveUZlYaaf9i9VKTnrtWAddLQ0g?=
 =?us-ascii?Q?df5UNVr22H9Q3FM6WxarC929LsmVAv+u3oZ/cTDcXPvUI0CpU+GhvM8VCOSW?=
 =?us-ascii?Q?RsM8zyHanvSUIlw4aJjLAuEjK3hmm6J6mzigxoCVaPK5wViZ7D+8KtVZYTjl?=
 =?us-ascii?Q?eAiHeXaBXcH1MGKKMrxIh+a+/t4n0JCr02+9Ea8MRu4tScvxovC5c3f8egnU?=
 =?us-ascii?Q?ZXEfISGrUhRIRjU48XKHtpbl59S+42t8S3kd21jOAelrvhr3CQtAhf3KADHw?=
 =?us-ascii?Q?CmRisBjZ5hH5ZCTtGf/QXPp58o0U1VkKCm+9fYom+LAuxF4USsCiuqPqwHYe?=
 =?us-ascii?Q?pRkw2B7mgeQ0ru2lX/cm2j+SNIrH/tF5yhOONwzR7wi+9IwIi7MKh/+Ukjth?=
 =?us-ascii?Q?vdTUKrkLEPO3lMlV09or11G6b1l4M4IDN9lSzXWJUjCaHABEjtvZzl5uCXnI?=
 =?us-ascii?Q?OX/9G/4hAanbYkM4eAWvM6TWLqwK6/WD1T7phmNqgYWT3yP+VZYU9/KDYZYA?=
 =?us-ascii?Q?v0+NOUYcfQcpZD0POPO6PCN8CXRyW3YEicppSF1TaKgzhCcGLS8mDSUFCIEt?=
 =?us-ascii?Q?X/MFvfOj+d2+qqBbqN8tde0FuNHHx4imZOhVnwiy8iDj8k4IRbWxiPEpkJb8?=
 =?us-ascii?Q?J9wS8XuR66g9OuB4+7XeYlzI4rAT+56MsHXx66TGvRD96vBA4U/atu0BOpQy?=
 =?us-ascii?Q?8CjeQMj8KSni7yeHJoFVk1pYBe3e1nBWOHkpYCIighEp26zPfMyk9jgIzK0E?=
 =?us-ascii?Q?uYImnveltuBiJmxKGkvshpTMJyERqZEZpAgWr+YP9IhD+hLshwpOUFwV8KZq?=
 =?us-ascii?Q?KRiFodnbQzHM9aVxmS83J4cM45MyXRw4UqT3N6k3wF2NZm7/W9DJvxJoRPH4?=
 =?us-ascii?Q?TAjSZnWQXqm+T6yPIs93zQ4Cxn3CJPWgPh6NKQWF1Q1KFZLQ7FX4MOG647JQ?=
 =?us-ascii?Q?j4oK5EvrDOA/JVbqlXMYZeHUrPTgmY8ediFLCC6BAYf91M6DxHCBEDbRASZ4?=
 =?us-ascii?Q?HJwDUxTpoTk1EI/k35FNDRH8o4dUADUYjGu0D9WaQx04w5gPo/7BrL1d6f+Z?=
 =?us-ascii?Q?JCdubB7iC036AlE1VW591IykC6TZagY3yF+yKsPqzJ4OexnDzLqEUJqdbaG0?=
 =?us-ascii?Q?De7+g96v5pXX/6Ht9Qf45DJBIGInMAYOFCdq2Rf5rWcRUz0b/ufqvOBpPnn+?=
 =?us-ascii?Q?XJfdcNkcc3seh/Ebza0TrGgK4X1pcOplBCwN5qv8jNK7W3qO1y+m4tkr+Q4U?=
 =?us-ascii?Q?IHcz18rkHu3SRHLIJ7t0ymRkqP3x8ag+Hu7OJJ8ESAGxiVdj5Ch/TlvzZPuY?=
 =?us-ascii?Q?Vlh8CZ+KjkgBhoeEXZD2/lJ8iOWT4B+TalGQ3Fy80MSHPqj5mzm80cFjiRYo?=
 =?us-ascii?Q?7jAn8bqtdr/pf06+xVMcL4M+qWUp?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vme/btAtjr1ew89Y2+YVyVNgaz3fI9YZgQP9oCLUURz/7EoMwQ840FalqkGt?=
 =?us-ascii?Q?/x3AlqRVj0XVEOk4T+vkSyc5QMa/VoW85J97G/tIuM1FP9HN5AnK3pgSaOEY?=
 =?us-ascii?Q?Cyfnf0FWGFMrOsuwngbIyVmEg9sKMOSaoqH1I0CE78KmCkrJJugDyQ7SCyyU?=
 =?us-ascii?Q?CZUKfDwibeVOHQyVExMB3hL2uJ//wjIYjPjM1pMKDmR2mXbs86c0p5KIHTbv?=
 =?us-ascii?Q?ZalQhOPdVlpzjkZcE6abG4W53DAU6HA6Sk/xBRNsbi76+aG0ZlzjX7/DYMHO?=
 =?us-ascii?Q?BdOoxvd2sltphGEBfRyEqMN3U7LicsUk4Us/B+rWKxMPBQ6lhRys/TYyzM8R?=
 =?us-ascii?Q?EOS8/Xm8IPoqupDmoJPXqh9BMkLsC3Vl+mBZCUdF9oZ7Ii50dDCnJzQ9Ez0d?=
 =?us-ascii?Q?li9gpnKXuISfAddvn1qmnZleMe7PTjM0zfE/6JkaMEvsQb7132rfBUn0Aqhn?=
 =?us-ascii?Q?mYFUiD2Q8p1iLpd7bybJOBKzW3TaG/Wof5JnWh54LoaRjv7ADqVCzTcVy8Pu?=
 =?us-ascii?Q?F7Df0pEIs6qb+g6zzROH+dy/sCEbNJY2Zh77NDKwebdE/3LU7/vjUfARCCoM?=
 =?us-ascii?Q?e83iAksKVuBp3CLS+Omfk61t7jRJ5t90pbdRxmwg7lcvd2exyxrf16zezyWq?=
 =?us-ascii?Q?qWX6WcmYKZ3KiUGl0OSeM190VQ1puvdp9o6NDBKEIe7fac3VrXyN+u4hAeKf?=
 =?us-ascii?Q?A1YHlCaF2GUjkPuIM9goVMIpzwGeyzdkhWK+ojkWku2muwdoGrFa3HxRC4lu?=
 =?us-ascii?Q?7pcmB+m+hUjdi1Dm1YX2I3X8rGwe/h2ZrZYkni8/0ylhxNNQifeLdjcY9Gfl?=
 =?us-ascii?Q?ARxA5grfKQoFIsg1P5Wv/hKX58OZ65CTPW2SqF/VDBknhxHMAvyGghOuhBx7?=
 =?us-ascii?Q?eEUEZyhJWCfFJS6CzrYAIAtr1miFPwe3oo48VGxc+6iTluQFSA+GrdzKTLYG?=
 =?us-ascii?Q?5FJasTf4KCfwdTcBRYZkA5Wg4+KRluxMV3b+4q0q9CEBCnLoNrznViSAPq/u?=
 =?us-ascii?Q?wzu5Fd42CdoSsDlXM/Nc3HyjmXLGmpTs20/q7pjvuuW1sxay3+ozCXtdrBkb?=
 =?us-ascii?Q?KMjOPowtkGkiPx02xfe+i1DvsUyxqWFtpPbRIG3DoHPH1AsUdpzn4jm86owL?=
 =?us-ascii?Q?6aZYhlLwnFu3qf7itxDzurvmxEV8A0RsGsOhEpoZGpnD3AFTKYPNokVPFjxT?=
 =?us-ascii?Q?0YbSWUflsr+I7q56EwhQcS59pt31M5sA9RsgiNNeqhLFox4w4el7O2iywk/Z?=
 =?us-ascii?Q?jj1RzFQCow3eqf5KXPHF+JOasPky8x7qYGZnvdzvkBoor2Nal9VVSAsuj8TH?=
 =?us-ascii?Q?yYQ1TAC3t580hl5vcZLJnR8SAk2hvxaSoYdViw767Kn5Jiaf+QVJQNP75bgN?=
 =?us-ascii?Q?uWvicFl4qtINYQ0ehP7ieVlB6i+vsjHHluLLxdNk21ZXFSZ3MJS8qHx6CoIR?=
 =?us-ascii?Q?uK3ee62J1YzyC3qON+pxalZn7o5KQ/pmoj0R6epnA6KBQCl6ALP4TPwiBmSg?=
 =?us-ascii?Q?90UW78jnfuvtuZdY3W7BuLdlqdzxZSzAiO/PVEEL7Y62yZQVl1ge1EaPwQw6?=
 =?us-ascii?Q?DXrM8ej8j+PZzxc4kh0R4OVRomtZoKfnVVElKvU+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d45f0e58-54a9-455e-dbab-08dd57af2e3c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 04:20:06.8663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYFE30CwflboYw0UJwI2C3onc4LT5lp1eTlcIU7CThtsuLU1fEPr5eZ/7HqHlLFN1A1luaWz9/eoXUrYKjfzYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5790
X-OriginatorOrg: intel.com

Just two nits below. Feel free to ignore them.
The rest of this series looks good to me.

On Wed, Feb 26, 2025 at 02:55:22PM -0500, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
...
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 989db4887963..12f3433d062d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1,4 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0
> +#include <linux/cleanup.h>
This include is not necessary.

>  #include <linux/cpu.h>
>  #include <asm/cpufeature.h>
>  #include <linux/misc_cgroup.h>
> @@ -10,6 +11,7 @@
>  #include "tdx.h"
>  #include "vmx.h"
>  #include "mmu/spte.h"
> +#include "common.h"
>  
>  #pragma GCC poison to_vmx
>  
...
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 622b5a99078a..c88acfa154e6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2581,6 +2581,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>  
>  	return NULL;
>  }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
This EXPORT is not necessary. Though looks kvm_vcpu_gfn_to_memslot() is
the only one not exported among the gfn_to_* functions, e.g. gfn_to_memslot(),
gfn_to_hva_memslot(), kvm_vcpu_gfn_to_hva()...

>  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>  {
> -- 
> 2.43.5
> 
> 

