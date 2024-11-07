Return-Path: <kvm+bounces-31059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75CC59BFD79
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 05:59:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34223283FDF
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 04:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1DF191461;
	Thu,  7 Nov 2024 04:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YdE+c9K0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA5F186E58;
	Thu,  7 Nov 2024 04:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730955589; cv=fail; b=mgo5/ZRjDwp7yhCqhD8uw9tRemc0O3EdmzG0T9qCqCcoZ/b7KZr/4zUqeN/+0vllJk5syqK1QHZrgXLLYgX7m2uu/By2J0XU4e9/k/kgYGhdGoWEQACTKk1yFfwVooMoxOfM6UBGtirM1uce3WeG03zIcyDZSIX73SrmXxDMn5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730955589; c=relaxed/simple;
	bh=A6j5LySO/5LoCa7fRgA0zx9a/9Eoj9LNes1WmFrus8M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pL7B50Lvd06SlBhhBkTyeY0WyZozisetDhAyPIiHZw34LQCRbexPK4uj5oYZSvXEn/f7lyExfo1VWwv6SDoWlVNMDROK4RE4iKEYpgEZzqU5TcpQJUg89ckqNSR11sCLrvzjPV838SEcGOw+lBdWWt81Q+v961z84ozguBb17Ec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YdE+c9K0; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730955587; x=1762491587;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=A6j5LySO/5LoCa7fRgA0zx9a/9Eoj9LNes1WmFrus8M=;
  b=YdE+c9K05c3dWz+qAfHFLb4EhbiJ1gcKd/oClrGMJKuowDKwU5xTgALs
   f3AYhuacQIhG8uUO07I3IUz+AtKEujRubh+nSIGFOVAGvIe8NGTq6NqD4
   1V0gaEnD1g2+5WQxcDKZLwudfluausgzzazOV7YjTrrd9UzBOqghn23kP
   RnUBtbLqC4P7Bp7S/9+1PJ//U887awxDl0YWqyV66b9I9Zu+5GkBDKtwn
   1LUV4Zg4M8MAxDOeGB7BpcDpj72+lchrky8VP1tvqAyBAV3YAQ/dSBI4q
   sQVkPoLoO1WevCInwhMOxaN3y5IJebuo3s+TD1pMoMWdII66A1NPc+8ZW
   g==;
X-CSE-ConnectionGUID: hQz3V6vzSIebV1wZGzH79Q==
X-CSE-MsgGUID: 9GjDxJrTRySB3ccU82GALA==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="42185163"
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="42185163"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 20:59:47 -0800
X-CSE-ConnectionGUID: tOUPVZrNR5mJYOp/C93eBQ==
X-CSE-MsgGUID: 0gOxOLt/Sm6h+/V6kC3wWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="84885744"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 20:59:47 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 20:59:46 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 20:59:46 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 20:59:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b/pCu2VPlT9Pj0h/QNpoyep7t1GU3EkNVJObYEx82nYK+ppeG+Xu9xyLDe/xoaHVBQNPoOa8vViEYeIPtH28ka1acRxfe/EW461OSJ3qmnT1McTXx9XmPAqSOJWbDK8Q/kXtHaMzXzovkpUdw5vPcIGDd8IEaQhki8IFIR2QsCADP8Fhty8flt9THPhnpVs5unK+Uj3/CYHZyXuVniNgEeQLrUZT/cUW9JIB0y0wxCx5+avtxvO92YTRIVl+JDROoGJxFd3ul2Ml3imL1DeqDy+Y34eVWDWDb8OdqR2zJTIXYrgpMuEFUJu9p+X9VDeQ4eNopZTP2zL6zkXuUziJyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPL74LTY6e1NQotM1krTEqHS5EslBK76BRR7I2cLAiE=;
 b=VV7rrv9Tet86FGEdTIuTr133+P2hqYVX3e89KTfgbH+8VC4+utK3W2o+VbJIl4Rx2Ix36cOabTDefDqV+sL+ChgzSCsDNiZAHwYaOHZMK3ScSk428jsayRNdLC40TJJd4Q3Nlmygq5Mtyyaxph57Qerf6fsA5cPw8n8dmBWrcNF8mWfqNNmnZakqWaR3cnHVbr2i/qpDloQwO5OULhcgTYUfzP4Xaj7+OU4R/ueCobQEmS6nRol9sOapx4uqD1ALI7zv4tej2gZrFlNVCsX3OVqKgt/woBWlMKD1phIgfB5rcC65Tv5Aj+7SzrRthsaOMAqgsbTvKkKe6tenP85Qwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CYYPR11MB8388.namprd11.prod.outlook.com (2603:10b6:930:c2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Thu, 7 Nov
 2024 04:59:39 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 04:59:39 +0000
Date: Thu, 7 Nov 2024 12:59:30 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yong He <zhuangel570@gmail.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: x86: Update irr_pending when setting APIC state
 with APICv disabled
Message-ID: <ZyxJMoYMfQKug02q@intel.com>
References: <20241101193532.1817004-1-seanjc@google.com>
 <Zymk_EaHkk7FPqru@google.com>
 <ZytLLD6wbQgNIHuL@intel.com>
 <Zyt1Cw8LT50rMKvf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zyt1Cw8LT50rMKvf@google.com>
X-ClientProxiedBy: SI2PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:194::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CYYPR11MB8388:EE_
X-MS-Office365-Filtering-Correlation-Id: 788c9a02-be96-49c4-9c90-08dcfee8fbe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7mWgmzpNg1RxIXV+ykK5yISQhjNoqcXYu/Ho21RChl0i8jBOFXk+4nDhRIyW?=
 =?us-ascii?Q?E36GucRW/aGTrtlgxq2q4a9KWnuc+zVqqdh0+y2HT5q6asRV3DxrT9+3zx7P?=
 =?us-ascii?Q?RsEPfuNm+1bHfY8mSJqPqEM7skzBwLN7yyQABiv0MnMKRZKEyLyKF4y3Pgzl?=
 =?us-ascii?Q?PvrxNQ/VTEbhzz95GRrWKdptK+ppFXp9I2x5BHS5le5aSDhcNYrkkeL1z1vB?=
 =?us-ascii?Q?oLtrErFsU/H4g8iWafcGQxWg7bf1kKyX/r+fnX54de/JYlCg+tNKCSKIup0H?=
 =?us-ascii?Q?giEwFKKxR3crGnjNpcp405dn1BT5WMebdlN4q5ZUlXdGeI1J8Zfq5FSCZUVf?=
 =?us-ascii?Q?cC1mLWmdrAne1oBGXjogfJZWY97yDwcR7AtMambOqeoGtdLgJ0Amr3MK9tcY?=
 =?us-ascii?Q?UwkrNVSvZTOyHvmm71kv3AjsX4rrDfC1uVViWdxvL8cF5AxEKMOkakuUTyn4?=
 =?us-ascii?Q?xcxblE2s4vPYmAK8oQAsFd6g3E6SBtKeH2jM8GPa0chlqc5u4XSOuwhQz6eu?=
 =?us-ascii?Q?7CeZYhvpMXoSTKERcTfU2d7D52DryyWjdS4bCUHE0AYGI4uvd55HHUoZBCJu?=
 =?us-ascii?Q?jkVssz99KPnmS9M7XiXluFfaObMDIpERvnQV17QKD3pqvg6LufN4ya8T6dot?=
 =?us-ascii?Q?VuCGnmDhubtJxmGnT1/TujYGcKb5YdyfVbPtmt7NxuYzO1amLqix0d10yKJs?=
 =?us-ascii?Q?RYwMCrfehhY+/gptKghzokP181ubhgUbDJSB2aYH1skVmGuJtlQCHGRxizHr?=
 =?us-ascii?Q?n9dn9vGMUaDshUbPUrkOSMiE8/IhTl1AL4HrgVzZ13/nYwQbnjXPNSkJHT58?=
 =?us-ascii?Q?nYnFHk2pdQZuOolPcKGy1QrLA/N5djWHMQizB7Cv6IVLbdNdchJCgOyJJHhP?=
 =?us-ascii?Q?fwtnauWLeZLCj72qeo6DSGu415F3bNcCKpOLstOjGKMZNcAhMXcWpyh2D5+l?=
 =?us-ascii?Q?nMkVzIQN4BjUhANRikIWqDscLPzlsNlmntgw7X/MZ1N7GD3NS/2QAl6YbVuo?=
 =?us-ascii?Q?mLbDAwFzQbIYZ0Di+xMd0jO1hndmX64iuNRmhTWX/BAqVKf3o/SYBP+I8Q+G?=
 =?us-ascii?Q?2EvnSrv9K67YReWAbXMpAiTOUanAVpKDIYiIezuWKaNpsuz68h6iRPk/5iAG?=
 =?us-ascii?Q?qLo0G71+ixdsxgeL4sa/ugamiZHdrJsCKeFsD5QoX/ILJaDsDuC9HehO7Bha?=
 =?us-ascii?Q?Z7Td6LLzRXZa47g8rcfGTJu5pQeb362Aaz3ySEd66akFaeItGjqL7z34wLhZ?=
 =?us-ascii?Q?waw2XyXe40vP0pAb67DLichZGzp78jWYmUnyZ+JOM/fWus7fOLJHh5U3ruPZ?=
 =?us-ascii?Q?b1kABVonzDLvLH4D3dTrvI6j?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WKi+bH6MKvLB7qHeXhot2o7/TU39Q+MjwGzKKsEz8hHarqaIfA8xLEc8Pxm4?=
 =?us-ascii?Q?5lUHXx7llt51rqTrpYf4z2aYgyjQfgLxeCT7tx3+b0ncaEnKrfqlTgecw4JG?=
 =?us-ascii?Q?izy8au3K9vYq+3F8MJ0+Y5cROESYJsY7/L63O3dLkh722XCFhkhRX2ROCxvl?=
 =?us-ascii?Q?FKelCwHewgxDXYeBUCG9mg4o3ZirKMOc20RoM7I2+kfaUTfnuE73gx8HT+Ty?=
 =?us-ascii?Q?tj8wakB/X2o6ipz5YmcOPdvs61j3c0M5BzRFgiECBobaVPkQGZW3kNOH2oAO?=
 =?us-ascii?Q?77rQndx8wS5O2JHqWknPV+dyuUw6ijQ1iY2DbecemSqGGD+vcc1RkL+GacxL?=
 =?us-ascii?Q?87vBcsTuG3/PydbDEqRvPjhsu/pXaW42xVhE6mWrPIBH9WmVsYczGUaKxn7D?=
 =?us-ascii?Q?CT7CyiYkm1oqtJ6RW2wn+VZsVHgLCFgDYtNeXMoSnDlYBtrP9Am+n12IcrbR?=
 =?us-ascii?Q?m1/MLvvZji0ZUKBqIWoAPDpC9ErEKa4pIPrEkGy1DsLP56Lsx/QAjI72w+cW?=
 =?us-ascii?Q?ej+55QKlVnJfgkuVhh4JBMG7HvjbVlDIbWMQRaru8kfJ9/drjQTXRscNhfFg?=
 =?us-ascii?Q?441ZMVSW668mwfgGByxgqrcriJLj5QUuaotKkrOXG+J6WwhYghc0Nu3m5soV?=
 =?us-ascii?Q?NGva1M7UdieHPy8PXjuP+pfacAZz7J/otBFyGADJLwYNnaeDsv2w1TF6w0O4?=
 =?us-ascii?Q?JpccYDzcPtYZkxYm+i7XuobqHg35T59XtBYnnXra7g8fNbH8LGcO2eE9goJk?=
 =?us-ascii?Q?+8gIWQG7Y3VM5KcxMqSKWXE1UNIi+7eLXoLvsr7sNJvfHGNIodZLSTdAkzAx?=
 =?us-ascii?Q?UYaARQ8zWS7Us9Q0Mf00FfslBkNfalrjhHV3lio0el77iAnddaZLni7AwarX?=
 =?us-ascii?Q?C7APfmnzzXdFOHlOutS3kWouO8LLTwuAEDMy2OalxKh8QE3pgTtPPzgXcOsR?=
 =?us-ascii?Q?jtsSQC08FWjwE8a29k06TUOdgvzW3UNzoJELps4/2CRG66dwHVvPJjTPG808?=
 =?us-ascii?Q?g0B4+Fc+jrvQQPfQYmN9a1RIoSvqWiajVtbiW/5diaavGgbPWajsz8oCHhAt?=
 =?us-ascii?Q?0JpbAZWUvVkFlxebp6xDmtF+hro+KyVS0hHGwRHTt44avK0hEkHLipCFu8nh?=
 =?us-ascii?Q?QGPxEK9E5qYCnxtza+Q1Tz93pNhRBpsNdciy7Si2/nMIhI8Cd3XPuA8ylzGl?=
 =?us-ascii?Q?JCRcj8Xi0mRyfGpyZkh0vui2sLOT7Wvx9IQaWeXNtuLJnMI3YqKuvqZordh5?=
 =?us-ascii?Q?GTkUSEvTMW7siva1cViTjllPklI9nRP+Ci2MDNKFJo+cTC7QNa8dlmWWJ1uV?=
 =?us-ascii?Q?B5NStD7yTcTB3jI6r/C9HA8950fT1DDRj1kpmRP2z6V1eYRRUr/j8xqKIJ1l?=
 =?us-ascii?Q?tz2G9p+h/JAwQd66C73Es9B0+vOCIZfTp+gxEV8s/HCQfCpW9Yf+44tlgYd+?=
 =?us-ascii?Q?9XjEIbgjn8135+ys9+SMUKXA29zhLnaR1CYV5YNbvsRVXYzgQo2dHcEb5VQr?=
 =?us-ascii?Q?rTjMmENPfHy/Bv1Y3N/n6ywwERXSmxGKrpsfMKzqe6PD8FkNlgpqLAmpxCnN?=
 =?us-ascii?Q?4F29TVyEvS36QgTjVZPg0ez41pSVPdae4sEPVET+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 788c9a02-be96-49c4-9c90-08dcfee8fbe8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 04:59:39.5246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3j7wxv1/ZnVPO8g7fJwz4kS1g+iVdfb5ghWuZJqUcjGn7yXsvaLQQhbSD1hlOMrTx/J2HZ0PwRsSX+4GDt+GIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8388
X-OriginatorOrg: intel.com

On Wed, Nov 06, 2024 at 05:54:19AM -0800, Sean Christopherson wrote:
>On Wed, Nov 06, 2024, Chao Gao wrote:
>> >Furthermore, in addition to introducing this issue, commit 755c2bf87860 also
>> >papered over the underlying bug: KVM doesn't ensure CPUs and devices see APICv
>> >as disabled prior to searching the IRR.  Waiting until KVM emulates EOI to update
>> >irr_pending works because KVM won't emulate EOI until after refresh_apicv_exec_ctrl(),
>> >and because there are plenty of memory barries in between, but leaving irr_pending
>> >set is basically hacking around bad ordering, which I _think_ can be fixed by:
>> >
>> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> >index 83fe0a78146f..85d330b56c7e 100644
>> >--- a/arch/x86/kvm/x86.c
>> >+++ b/arch/x86/kvm/x86.c
>> >@@ -10548,8 +10548,8 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>> >                goto out;
>> > 
>> >        apic->apicv_active = activate;
>> >-       kvm_apic_update_apicv(vcpu);
>> >        kvm_x86_call(refresh_apicv_exec_ctrl)(vcpu);
>> >+       kvm_apic_update_apicv(vcpu);
>> 
>> I may miss something important. how does this change ensure CPUs and devices see
>> APICv as disabled (thus won't manipulate the vCPU's IRR)? Other CPUs when
>> performing IPI virtualization just looks up the PID_table while IOMMU looks up
>> the IRTE table. ->refresh_apicv_exec_ctrl() doesn't change any of them.
>
>For Intel, which is a bug (one of many in this area).  AMD does update both.  The
>failure Maxim was addressing was on AMD (AVIC), which has many more scenarios where
>it needs to be inhibited/disabled.

Yes indeed. Actually the commit below fixes the bug for Intel already. Just the
approach isn't to let other CPUs and devices see APICv disabled. Instead, pick
up all pending IRQs (in PIR) before VM-entry and cancel VM-entry if needed.

  1 commit 7e1901f6c86c896acff6609e0176f93f756d8b2a
  2 Author: Paolo Bonzini <pbonzini@redhat.com>
  3 Date:   Mon Nov 22 19:43:09 2021 -0500
  4
  5     KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled
  6
  7     If APICv is disabled for this vCPU, assigned devices may still attempt to
  8     post interrupts.  In that case, we need to cancel the vmentry and deliver
  9     the interrupt with KVM_REQ_EVENT.  Extend the existing code that handles
 10     injection of L1 interrupts into L2 to cover this case as well.
 11
 12     vmx_hwapic_irr_update is only called when APICv is active so it would be
 13     confusing to add a check for vcpu->arch.apicv_active in there.  Instead,
 14     just use vmx_set_rvi directly in vmx_sync_pir_to_irr.

