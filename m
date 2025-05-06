Return-Path: <kvm+bounces-45556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A959AAB9D4
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCB644A389C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421152868BD;
	Tue,  6 May 2025 04:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jdcdQYEN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB782857DA;
	Tue,  6 May 2025 03:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746502462; cv=fail; b=RFEqnZQ3z7DF5ZDm7z0wR0AMy7uKWGMHwJErks/4SZBcwpzIMFv+wwhXrDnvvgUAnbExncWzhPotNS4C3e6pjG8VcPHxguaajHBDAeKJ9lsXrfHeREB3IekXNkn3baq8liLdeYydzoDS4xwgXT3ZYb7248iVcX6oZtt4HvHOaN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746502462; c=relaxed/simple;
	bh=mmeZ/pC8FmuOg13laA3Cs2ofg49sqNrkJIQpSxz/CXE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D15zshDenQrCsk7iy4O6RiABKxHqFlWsqDvb+BC9T2Ro9wXRq6V9SVDbhSmzsRhJmq++LhmsjRirehspe45Qbuv+a77eXygUzCFoPRJlbcSE2o6L0Hbzb33jI9J58u97W1ELzkq2iiuIdUQ8qYqnypArHDyrsopLFVP0ONDU2+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jdcdQYEN; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746502461; x=1778038461;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mmeZ/pC8FmuOg13laA3Cs2ofg49sqNrkJIQpSxz/CXE=;
  b=jdcdQYENUic++48bfmihyaV9RNdual2QyU1JarEK+xmZo6Oild8ZWn+t
   XQcv4dyf86MwTXFJ2qmaMTj8iPlI5KTz01Hmaqxu60ysi5n/a4zvGb4L6
   P2wOOYpSqS0WIHdmlO1aOP9Qzwov6jAn7EDrJXlxc5dyNRzyp/gU0Imk0
   xI3QZIL6e98YG0d+Rfl0xcRYCERx4q26SdjjDj2u0bcF+V2Wg18UK3jO+
   CpzNA31Wop7r+/t806qzQvGbVO/4FdTOJVv0WLD4RkdTmeC1iNmOFyHmc
   rcV/0zQi98AbwXOvf9CSJuzw2Xrxw1PjDf5fwoiA4optEfGHP7WomBXZk
   w==;
X-CSE-ConnectionGUID: fOwHRtl+Rm64UZS1QlSI7g==
X-CSE-MsgGUID: kZF2Wzj+Sumw7k9k5k7ZNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="73539669"
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="73539669"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 20:34:18 -0700
X-CSE-ConnectionGUID: wrtEFXPFTd2Q1YCuycIUTQ==
X-CSE-MsgGUID: F+AEOwkgTUGj65lBNr7/Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="136415376"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 20:34:17 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 5 May 2025 20:34:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 5 May 2025 20:34:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 5 May 2025 20:34:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjOOc+4xssLPjGIy4/j+rsUrC+KmmTtliq8caXXc9zObo1BJk36hOfNdW/Kgw2UpsaUSVjug+dFRo8OsBfP+urNvbo1sI3C8Mw40XmYPdhlcy5dPrUu00p5a+XSIHI18FA+qWZIbC4fcOdiLYf/sCXn4y+VN8c7YkvVChCHr6dk47hN+39/N7kawxztld4mROhSpAMj9qxClzrz7j6wJ3prUgeapN96Izkktzn1+hquChs2icFd2h9ElhpA554OjxA0MidwOUcqUDeeuKwP7lm0/+p3cXSgX/V2UEB9oXyq6nlnjUM8v32QNeMMpoWttJKdugwovZo3lVhC2QsFUPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fbu8zH1L7UvrZhnsKn61oAlkAgIbBrTPYA48eUaIkc=;
 b=jZSq/BfdgJaSyigkO0ng6NbHDcnqFweWCZznD0I1eJAyGkeCsoXRKj7R5JeyVwgQetUaEX8JlYgbFNwiB8eLeZFvNB4MlZDPi7qa5Cg8oI+Wx//BRF8LyEFb4PFB+qVPahqCMHMUDW4MgCf67/tFw5tasuoIpJ/veOI0m95qHEs1/1vs3Ojch+lPl3nce4ttSEtNm6pP9Q1ntPanRmV26dywhvbXH15GB5BlSY8M8GqFYWf3WuN4uBWBL1J+X5T2/TfKIdO2AHD9gZoJ5Ue+W0zD0gIzZ+h8cIAgDswCOjWudhbOkf+jJPWSyoroDj5uhrjL8zu4qHh6pSnNcaf51A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7640.namprd11.prod.outlook.com (2603:10b6:806:341::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Tue, 6 May
 2025 03:34:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Tue, 6 May 2025
 03:34:09 +0000
Date: Tue, 6 May 2025 11:33:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yang, Weijiang" <weijiang.yang@intel.com>, "Li, Xin3"
	<xin3.li@intel.com>, "ebiggers@google.com" <ebiggers@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"john.allen@amd.com" <john.allen@amd.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "Spassov, Stanislav"
	<stanspas@amazon.de>
Subject: Re: [PATCH v5 5/7] x86/fpu: Initialize guest fpstate and FPU pseudo
 container from guest defaults
Message-ID: <aBmDJVaKdSvoHozQ@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-6-chao.gao@intel.com>
 <9ca17e1169805f35168eb722734fbf3579187886.camel@intel.com>
 <b43f9043-58ce-4932-badf-e9510a7d4cd4@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b43f9043-58ce-4932-badf-e9510a7d4cd4@intel.com>
X-ClientProxiedBy: KL1PR01CA0020.apcprd01.prod.exchangelabs.com
 (2603:1096:820::32) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7640:EE_
X-MS-Office365-Filtering-Correlation-Id: 705069cc-85c4-4b69-e755-08dd8c4edca0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GTX1TMzeIYW1D5NP8Zt4FwNpj04mbSn2T+hbednY/7YNs3tApEO2eYjId9GI?=
 =?us-ascii?Q?GN4dBS7OZ7e/oysmxusH/0COQQ1gcqhb4/qyiymcbx20i3xmrfz10xMJflhs?=
 =?us-ascii?Q?pm8vGXcsgO4HgR6RIuCs0y8nUgxzokOnWHsjll4NtcEBOvQszG4qxjIBmv7j?=
 =?us-ascii?Q?pQDZk07X/67K0n0FLCBmea3ObyIB/a3f/VhA/iXJMMXEFeBqj18MH1nEXDXE?=
 =?us-ascii?Q?toWksMkL++Tp+LYkF+Xqdywiead/TKZCEez0xJdINotLR/7/issGQVUygW6B?=
 =?us-ascii?Q?58GX4H8jjcnX0LiJR++nnopNp9RdCXzWtXm9i7n1WYHSOsxI5uwDo7JGS9nC?=
 =?us-ascii?Q?VRnmmDncHGYKmC9iyWGysaq6C6rbSIrBb9dDFQ9u600C9/vsFPjymL8pim8q?=
 =?us-ascii?Q?moc5RkN05scK2QEqRG3y5nY9KMPFZh7e83IktPIIB4kQEWwh6yYUwtXbr1lT?=
 =?us-ascii?Q?8ARSteZT9RqHRjm1Kknd2SC57k2+5zbhBf1dXFzoVVnwKLYIdil0lPsnTIMt?=
 =?us-ascii?Q?xQaSbsQ5Ye/dpHEqh+QKrc3AaEv0yh9o9F2x605yWaJKqsuJ0JgCCLshrVMo?=
 =?us-ascii?Q?q98C6gCgDQYtLn1KdF7EzJQbG/HykisicuQLgaaRBrFPsptW37rsDoic4yRz?=
 =?us-ascii?Q?/rerX/MaZJZ5zBQ8CFfUC9GOjWmjPCW/tOTE6nIMoUI/nXyk8F6pttbxPO11?=
 =?us-ascii?Q?qU0fRtaMfQVrImuYoS0Zza0Ry0yaMKVAvU5+zHPLEj+0kB5+2zWHuVqXWlCt?=
 =?us-ascii?Q?EhORJJWP/OOgv9BngyX1RcCKV1L0x7AzckLg9DyjKgNOZNAeYBjkbTlL/w1G?=
 =?us-ascii?Q?rP41kl6d7m9IXnAGhRMAV4kYujcO+gEWWHnTLx3uGGsJAFdu04QzE4RQSVny?=
 =?us-ascii?Q?b7LXtoBMrVt1evYJDj5IxWmc7XHpC+JAD7lIGeB6GMruVE5+FO/3BMk6zSUy?=
 =?us-ascii?Q?HccC+ucwtvDC6KSlYdbse7QviEBzwon+Jt+CcY7UHBZo2BSJ7NYIQyLr5/sO?=
 =?us-ascii?Q?Nt67hxzbOvXxS8zgSlsnmONftJmnacyXnaJfsxUVpEMBlouz1xiQA/Gizf+r?=
 =?us-ascii?Q?hq8WGypYkw0C2QCk0wkvd73/GuoFMfUsecOz5CkTW56DR+sNpzZzmVeWoE7G?=
 =?us-ascii?Q?74JDoi4slO+A2F5mBfkXPVj+eqOElWDqX4MFQvR/TlrpZ6aaRRl8gYs01hfk?=
 =?us-ascii?Q?t+dzfuEYpd+164YG/pmNF4PPfc79PmBjx5CfABKlJUIW62Gq4QnxOoSGKZdQ?=
 =?us-ascii?Q?Tuf1zlAFvn/NY+mrO3mfXPnbIscr1H5P6ovdhS0i0QudubkEKgo7K/OuZ0rQ?=
 =?us-ascii?Q?C5GDds7s0xbLbATHrNdOXG9VheNvh5Y/vcEqL+Dd2PS+aQ5KrLqPLfkfvb18?=
 =?us-ascii?Q?HH/WQfWJMlCfepUgQFdXT4VnddA7xYwsEwJVM78ZOFCGVTNmPw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CneZ8keM7+Wzoerta63uapi2OUl+JrVPs21TOO8K19mqhge2pc0h6Si+4P2g?=
 =?us-ascii?Q?qtCESSqqSU0BVscd3utbtkShM/Ds6Kzb1eEy9Pulgf96as8Ujye1DFHLzDgj?=
 =?us-ascii?Q?1n526z2T36y7UehcwH49PPURHyM+U/l8XzZrIV4/LAE9v9s3XmHypATFRxbO?=
 =?us-ascii?Q?gk/mameoYZlhrUyfSHrpiCunjDmVYX/jQo7mLtoYBYBq2vUX4uyttxe6REZM?=
 =?us-ascii?Q?saTUfonXMX+vroBOSY7Hk7D520ZPJiqovLeST7RHcdTW/SELNy2LLVjv6HiB?=
 =?us-ascii?Q?4vjE1q9etgVEKnzGXvLHnxSRXtoECQ9JOC4qoePgC6WNQJNMT9CYG7tqHQcf?=
 =?us-ascii?Q?8XEayRSZ/Gn2tXAgAaA7nX6UaMS3fjaK731VfpFLp3SlSFFY6T6t0PfwPAD3?=
 =?us-ascii?Q?RQNwJqraznTP24iLTBSnCtrqEciS/GOrdmflpsSRLZG7+grR3TYKuxn07Zpe?=
 =?us-ascii?Q?QqL2ifT/18q+XFtfIxdOioPxzSkgaOhiZGrkBR4/YBhZkd0haWWS+uUplyrV?=
 =?us-ascii?Q?nNxaDugMErz1XDR8BhdJ3QlIcnQnVwOE0YfByGS0sFhpKgPnfdRqJoZ/adHP?=
 =?us-ascii?Q?/dJpNWR7SH4nBOxSoOq0wDfVv3BQUWp3RJkD9JJE6dxqISng94Ctpv9iBq6l?=
 =?us-ascii?Q?T2s+4kdrzypWs1SD86HfQ2qbJ3IAGOQELiyifXE8ZyY1VrVK5RSTDYjOzzQS?=
 =?us-ascii?Q?4FVJgB1gXi+8peGjqVdYTAl+p5+NIEAAh2k3UINDVK0Bug8YyVHa0kYfTToy?=
 =?us-ascii?Q?XvDVn2QNOGat8eAa88WRjTHl3WZGoMXA/up6rcGjjNNTqdsQsOF5+jWbPmzm?=
 =?us-ascii?Q?+iAwVj02D5N8g35viSmDKiLKU0nOcyBtJSkXVrkFf2aQ96NSXh2SYnXY+N7j?=
 =?us-ascii?Q?M52om+CGGYx1/NYsoRPCxWXPN9kh2L4+o+56QMg0sd28S+46v3C4X85W/dCe?=
 =?us-ascii?Q?9oV02Q7FD0K2hKbM4byj+CFO9iKeqdk7GAkuM+BEpXh5dUYxBNSy7IhATbgH?=
 =?us-ascii?Q?OjyhcU6Xv7CGGJ3Gffq3w00Py1MHqSJTWROGzexi3lLbTNqEJRvcNk1iWVi3?=
 =?us-ascii?Q?ah1eqQimeT3yK4kgTe+gvX0zp4YETbFVA6OkS3DhsEBZG8VbChJb+7QAN33x?=
 =?us-ascii?Q?ymazE/1rK/nsJ0TJc8IuI+K/31v/RGNc5ZpFhZ8Yi4KDS/MC9q5D+/oBtotB?=
 =?us-ascii?Q?iouUM1wmBvPKKu9hI6qRLUike/m/hC7Em0Pj0GIURZpOUT40udONC3c/T733?=
 =?us-ascii?Q?Lz+qYPpLgr3Sm7cAH2N91nHmLI//sXm7XF1f3f6w6UmwUUtbuLhw/O9YDe7C?=
 =?us-ascii?Q?mdLOcxRdMImvglXGH8fACoCPQVMuoaFAe+tNlyytF4yuA6FCti/Fcbg8rrCn?=
 =?us-ascii?Q?Cv+iYESLp5gN86lCRBhSg8kwRmCMP6M3ZFyRUyVJcEXgiNb/FNro36nOGRqc?=
 =?us-ascii?Q?2p9g5ex0mZ2ioWG7sA0MmS8/wzJbzt8JWIQMdUVeZdwSfboSUZZpTRmZdI7t?=
 =?us-ascii?Q?VYOWd2FTeVqbOJIeUKdAqwgPxdTAOc0cPYk6dGH4kktYg/2Z0upZxVMq2Ezh?=
 =?us-ascii?Q?XxOcCbkpQxPUf5G7lg32viOk1udx6Iyyc8yLUCiK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 705069cc-85c4-4b69-e755-08dd8c4edca0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 03:34:09.6487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFU+nFcnEG7OCMyLYycXsEIxJku9wDvcPjJf+MNv3GrMTjj5vqAdyBtJf68JqGFDFGVBtKGs6dTcFSR657hp/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7640
X-OriginatorOrg: intel.com

On Thu, May 01, 2025 at 07:24:09AM -0700, Chang S. Bae wrote:
>On 4/30/2025 11:29 AM, Edgecombe, Rick P wrote:
>> 
>> So let's drop the code but not the idea. Chang what do you think of that?
>Sure, that makes sense. Thanks for bringing up this case.

Yea, I agree with dropping vcpu_fpu_config.user_* for now.

>
>Staring at the struct guest_fpu fields, some of them appear to match with
>fields in fpstate. In any case, I agree it would be helpful to consider a
>follow-up series after this.

