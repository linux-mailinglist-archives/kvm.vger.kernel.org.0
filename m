Return-Path: <kvm+bounces-68862-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHg5NunacWk+MgAAu9opvQ
	(envelope-from <kvm+bounces-68862-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 09:08:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E9262D92
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 09:08:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 887B9588073
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259CE3793D3;
	Thu, 22 Jan 2026 07:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OVhUTaqL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FED32FD1D6;
	Thu, 22 Jan 2026 07:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769068615; cv=fail; b=A6ElcgKNm5Tx6Z0l8t/ELAfqGblIr7CClj3PY66guGLPMXNxmLu6rZfQ3lQna0S8s1TAaZhrYaLLWOOWGHpvLx0TagQCbh6kSJOhrYxJ79kuGpIgT8GKjFUGXZAY3mUZENVmQGWQcbQQTEZbdtZYzdBDoHQFjhIHQv9LhXS3tPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769068615; c=relaxed/simple;
	bh=uBjg2W9USoi423kGOrarCklPyRI+Rxvp3cwraK35d5g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oNb0EWf2UFUUKCs1PmNgW9bqBnCJdJzsiLbhgMrsqQ5pd/VJ7u1wyEHSmK88jnyRSg43BtwKAbsByRFQvvF862WzaTSWvDfCnelpGpyLxwTmnTNgdQLG6jleKLpgiLnVipLTVwnUl9+SjXTPThtC0/a7MKhjmNiRMmyr9+IhItE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OVhUTaqL; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769068614; x=1800604614;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uBjg2W9USoi423kGOrarCklPyRI+Rxvp3cwraK35d5g=;
  b=OVhUTaqLkh3j2ko4X5Cr0uPWL5qWkBGYFuBOL5LXrEAtJhkKbu6NI7xM
   y+1gYxD2McgQBh64l27GoAGjXJRJFGHAzcQvMs4W+HoMfC2kX3oRaS7SW
   XpT5ldzeM9O9xb8XgcRTMwmkjvT/tgbmNocMJL4O9NtvJsQoxUg8Qi0gJ
   v6s76pNSFrEqa4tLI7+0mFF/jQ1uhcGg6Q+2A//nXYDBBjacFdf4HPa6a
   e5WOv8I0gTEsOonmueWWh+2O+adOQU2KGID2h3mu5kZ6961+HjFCodsSW
   +TQU2lNtn3OEIBYKSUqnyaOHUX9PQmOR9+vtmbDBrkzi6W/GHhcgCJGzs
   w==;
X-CSE-ConnectionGUID: 4YWoDyzHT66io6sUVXXnYw==
X-CSE-MsgGUID: Dujc5urZRBmvpgBztDA4QA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70395712"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="70395712"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:56:53 -0800
X-CSE-ConnectionGUID: JzsClg1CRImb5uZouW/kyQ==
X-CSE-MsgGUID: uQVHOxNySo2d5RnYBrqd5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="211193230"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:56:52 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:56:51 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 23:56:51 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.28) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:56:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oDCApYqqlTrlM9MERKyMik3cUCRWwdy4yRYUTmRU4PpMP6AhGS1uaxQxO8ori2bQENmINGClRAXlpfI+8dlielGzZbgv+uL4UZX240hpobcVCecGcnJmbT95JDcODGiO+6qVnA3bF4/l+Ndtml3i9G/LXQ2M2fx4u4L4rxOIpXzgO415j6Ddzo2mODxqPXLiwVgQ4+AXjKG1f/aTkpNyocrrmYwNHinHGGCpCngXdJphorguxE+r20fjijWMm2DH/q7wZc2UVCQR2/+ZGnWgjE7vPgjYmg/RCCK30YV1RrwR7I9t8w70LG3qPVe3Q7945dWHImxJUB62lp3VPgNBjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2ttDGsX9romLmNHH4bLXT3bp5XxXvNkZBbAvbqZUSs=;
 b=Q1RZuVy5vZsrUAbUJpS5iPTewBh6ia42/RQeyWVxjntOtkxAVZhmkvRNqj8FmnqZbyPT80EDii1a2JRJdKsmwykN+ha7dbu9WR5+31shfEMZBlh+g3xMV30yYLOvDr1zl/a/GpgsA3TmCFgKo2POjVXMflahXghUiUO1zodLTzKeGJ/eUMgEMs/Q3zWQLbN7FzF0PSZc1mKuLQts74tYzHSDMG06OjDwnIQnbA5NgU8S02liL9R08lE1Indh2xW6ciK0MEmEpICqgXnYINpSfr5vpGJz8s3lGHjVis9YEFvJOqIOxXde1Lm5QcTRkufMuJ1dnqqI6PKEblR+Vu5sbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PPFE8B1F622C.namprd11.prod.outlook.com (2603:10b6:f:fc00::f58) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 07:56:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9542.009; Thu, 22 Jan 2026
 07:56:43 +0000
Date: Thu, 22 Jan 2026 15:54:29 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH] x86/tdx: Use pg_level in TDX APIs, not the TDX-Module's
 0-based level
Message-ID: <aXHXtcdwFMESOxM4@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260120203937.1447592-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260120203937.1447592-1-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PPFE8B1F622C:EE_
X-MS-Office365-Filtering-Correlation-Id: 08c60eab-55e1-4676-d6a5-08de598bc8be
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?E72r4bMXGLCTGvhlPdi/UmlPJSGrQ2m21d9W0ZjJpVFZpmB42V49xud58KJ7?=
 =?us-ascii?Q?Yqc5gN4jH2SZ9ggecgC+nnwcKIX+pF8MObG5gnXwlNj19b4cRydChp7qHB8p?=
 =?us-ascii?Q?FdzhcqtX7Oqr+r30W0Ot0EjwKkmRBKLMWemQHanLqvL+q/sHHnmPBQ2BIwgt?=
 =?us-ascii?Q?8DrMoG0gdw+VnpZS6VQZvw/Uu1xlmxdzCMLQ3fypqLEcQtSoBVwhdo+yPho6?=
 =?us-ascii?Q?HGkIm1i++kU/MLaUDIq+EG8v0ayB4snz7gCWcnkK9p03Rr90A33KaTl1UpCP?=
 =?us-ascii?Q?2FkTbcpfOgUwAhuAauqUgAu6iOPVWf7GB8dWuZehqj2GlmxAlSczQ/IyIz/8?=
 =?us-ascii?Q?1PX/tWLw0r9PGsWZ0jyJh27ONaHycqC/+AI7QPDtLmokRMVXIsFybJ/W6lgr?=
 =?us-ascii?Q?veib8YKaRziWgOPqz69NJHkOfb16BZGnj0+cYftFePFhqZb32X3nn3AoTnwz?=
 =?us-ascii?Q?arX8SnUP6FTKxoOK4yH7/rSvfa94HvY21kcp9bVHq/aCsX2V85seUsV9w28q?=
 =?us-ascii?Q?TY6eDxOdREPtALt3/tyg1JyNWDVaeG8hfJ/+CcfRSdrDB5U3wKHy+5XlhAKR?=
 =?us-ascii?Q?FT+2p31bbi4dwDG8MmvFICy33Ut+rlCqgiQIT9EWwnRZBGgDz8Cu40Yv1T0A?=
 =?us-ascii?Q?W+2WQODK8UwwMPIs9pv0ZUXHrB/qrh95ph+kPztSu0dEAmLI04LVFbRTu9QO?=
 =?us-ascii?Q?/E0OHJzEoM71pJjOIt6B3AkgmI+jyEzbvuacdAPI5Hg0TAOyStqoPA8y1t0R?=
 =?us-ascii?Q?LoKgZ4PmZFxAGZfwoRap3ET7VD+OuLRQ06N6i4FKIHsacnKS8bHWBOSmC52+?=
 =?us-ascii?Q?F/aoEFcvmVbSbR7HEX80lxbgOjbDX3tC7WKm6hN6LxIV5QKXH3kZck7lL0OW?=
 =?us-ascii?Q?jeUlYtA/1vklZx1psG4iMfjF2fltgsl6q1iBV3EgnHlgGsSwDbMybc+VSrFK?=
 =?us-ascii?Q?DTabRe3hcp3w7fnVwDc6DuXD6KAim9C6/3bym1dTMNwo1hOKRiw1VC6Aec4b?=
 =?us-ascii?Q?rSb84s/0K8WWlJpZ0Jh2pG7xMgblVM0umrkbjR1LSkLiDFDv6hzt7qe0n7EI?=
 =?us-ascii?Q?M29vq5VOGyIYclIQaXjKQaEBtSHE6yFchQARVDcoV6LM5AAvoBUAfFNqnXzs?=
 =?us-ascii?Q?BOky9fe3aoGOwoi3mCIptjaXUYjpDFASG5g+pqoRxHTEv/C6EKBT3ouExj9R?=
 =?us-ascii?Q?U4DAHy79FfRKiUDcK8dnXNGWHO9UR8iCD+G28SbqgvQnO5LA3FVDslON6JJf?=
 =?us-ascii?Q?y4zdi2lotIAx5MZ7BYT4Uwrq0FKaU8Lv2GFx2jn11UpPSRRaPiSSLHPGxWVS?=
 =?us-ascii?Q?T+s+D74rgPBA1lykLS0kw+XWwf5X0mv1IDu41taKyQhvvTBffwyPGxj54TRd?=
 =?us-ascii?Q?s9o6KwEz2VbeW5t1H1D4aLtnDAFie+RBJxtw815uWDOnncK3Z6HF1OEIkFym?=
 =?us-ascii?Q?yYlnDdAlzr4fs9nemAH91Rz4J8dr75J2E4le9xKE11BKP+4oOsRx7skYF+8H?=
 =?us-ascii?Q?/MJlmEV/0LXAVd3UHPLJ3bdS5ogywem/crxiDc6w6uagYHL977utevHoxB68?=
 =?us-ascii?Q?NvOe3MXszKu3qATq7p0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XPSPXhY+VwoUpC3YZ7CfZmPtutWfECkbSUjfegFA6Jv8i4N+SR3Kv49FMiGN?=
 =?us-ascii?Q?sFNsw6TgjzLl3wH1dmDA+CSCvMeTA+FvUTPbsRARW3Df2SJjHi8eyjf2PGD7?=
 =?us-ascii?Q?kzUQdKCzdg4jofl4c7grGfntPbW65F5V4kyvJgR7lMc+Kp3f1pq/ngVMEY5Z?=
 =?us-ascii?Q?8+7tgqKdodeLZ2LOwTdz1k/k36TxGE5ISiQ1apON/wSDzw/WHZPPBR5xuJma?=
 =?us-ascii?Q?cIa4RcPRg4y8v/olw3//1UZneC80a5VQXAFaWL+508+EFFqUT8sdbbki/mwk?=
 =?us-ascii?Q?9PF1A/8X5eF548nsc3oKPQNSz8vOj2cwhH/YH2QYh5uG1sir3rksHOZgczXk?=
 =?us-ascii?Q?Dcra3YetKB25rsWdcRM8mnMlrIqlj+tHE93+24MYkJMP0P1Kk7iXW1I8RMXA?=
 =?us-ascii?Q?oh1ixevgz78XKEFFAxy5w74UcfuLMmbGXJ5cZ9f7cpwSbdlPjY8gN4cgPqPH?=
 =?us-ascii?Q?y1pe6eZuylVBh2WC6KpdXd91/i86XZvpldBzt3gaXZYhhwNJa2HEun1EUrAi?=
 =?us-ascii?Q?8dR1gqLoFANEqo40FVEwrIDm12dCHGvsH0x3KmaztDbt3pqKXFNy0Dm7PS8T?=
 =?us-ascii?Q?uGErxI0OfrhFLX5i4aBA1cjPAj9wGYKUOsJurT7c1UdCHTYbF7XGr6DaeQn5?=
 =?us-ascii?Q?G/nVL1S2YL+jnc7kj+6ydO9EnaLcQsiUCzhQtpRugCdWknpsnqhM7CikIUIx?=
 =?us-ascii?Q?bZLOcEniVT2XU9cr/s1JVDR4lzAJ3ZoQ2+mfWo+9IW5dWhiQ5OWA/bRf0MLY?=
 =?us-ascii?Q?GWDGKNV8PVWgPEuAYTRIlEKWbTuEQdRqAA5YdGTET7YogKRhSSEuaCu1u4l1?=
 =?us-ascii?Q?ixhR1aqelWo1gCUiA2weSz0to1hCenT9cKAySBIDXPCky6vQYmSGgaudECrD?=
 =?us-ascii?Q?s5jKzONkKfRquABlCKvyl7lbLt1YXmtw8Z100pL/pKnJGg2u/IlDOZm8Hcto?=
 =?us-ascii?Q?3rKTY8k8jjg1UivlDEHbxg9KIJnvD9Qv1sk1XhCVnZJYWDGr2a1IM61npLTK?=
 =?us-ascii?Q?wJ+CLJsFIuMC/DxOEJxRwd13TzZNFLt2gY+rLmxXEQ8IdoA4fjY2eHmUuado?=
 =?us-ascii?Q?H64pipEay1Jo4DP9toQ0ptcWyxmIowQjNgmVbn0IpHzfsuCVD6nbzZJcN2Wy?=
 =?us-ascii?Q?LLe2+f78QX5o4P4d0MYbkEJOcnP0q/wgT345KdCQee6UWCIJtI+/8GJ6YE7l?=
 =?us-ascii?Q?+UXPtqpL+fiB9ck2gr9xAoXPj5sCXDpeFAq6NjSt53unC80LgkjXxsP5t/Nb?=
 =?us-ascii?Q?A4KRZuVXLU7F3Ydv5C9+fnaQq7fgbzRPhwUsKv9B9wswaUPTNTrGst3VGyZq?=
 =?us-ascii?Q?k3Awi5yJuGSfJsRCpdR+vu8uH2dnwrGW9ZvdBN/fxHQVV6GE9isr47eTWGOS?=
 =?us-ascii?Q?Ip/oXH6N4/hlNFOiYJHQzFWo8wXghXHpJp8FAsS36cevahG7zUL/hyw3eBRt?=
 =?us-ascii?Q?AAO0pbx5MKkpvdjKp2XyNYLKBSq+Wt6hadEUapKS1zVW3LUXwGFD6X1Gd1UT?=
 =?us-ascii?Q?9sNSd0/YhajCJp081SRw1uWgQ4TlBrpeQzKTUPf/G97oz9GWdluTOHEeYRCJ?=
 =?us-ascii?Q?fFLwPptCDkuQ1RhfY8HZtrbhelwcJFlJuOf5faQN4FxF/6xsV+rsih7NsFUD?=
 =?us-ascii?Q?U3kcwtNEOHhkEFeTqBTSwHAKZYmbzwDmAFtsYwcbG1gO/FMkXE2EFoIgedUO?=
 =?us-ascii?Q?LKy/2/hTokDWklR7R6UMk7KdI0gpYa2rFw/DqAOJkzZeJQ67/Dsv9K0c6nrI?=
 =?us-ascii?Q?0LaAamVPlw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c60eab-55e1-4676-d6a5-08de598bc8be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 07:56:43.7770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sv1OE8gQ1Zn5xfZNDMqndzPC4skr8/TSa/brbyB4qUgoPasVed8x1n36mJMusHTRe/aw+KXV53MaPKfaZ085cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFE8B1F622C
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	TAGGED_FROM(0.00)[bounces-68862-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:replyto,intel.com:dkim,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,yzhao56-desk.sh.intel.com:mid];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: A2E9262D92
X-Rspamd-Action: no action

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>

On Tue, Jan 20, 2026 at 12:39:37PM -0800, Sean Christopherson wrote:
> Rework the TDX APIs to take the kernel's 1-based pg_level enum, not the
> TDX-Module's 0-based level.  The APIs are _kernel_ APIs, not TDX-Module
> APIs, and the kernel (and KVM) uses "enum pg_level" literally everywhere.
> 
> Using "enum pg_level" eliminates ambiguity when looking at the APIs (it's
> NOT clear that "int level" refers to the TDX-Module's level), and will
> allow for using existing helpers like page_level_size() when support for
> hugepages is added to the S-EPT APIs.
> 
> No functional change intended.
> 
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Compile-tested only.  Came across this when looking at the S-EPT hugepage
> series, specifically this code:
>   
>    unsigned long npages = 1 << (level * PTE_SHIFT);
> 
> which I was _sure_ was broken, until I realized @level wasn't what I thought
> it was.
>  
>  arch/x86/include/asm/tdx.h  | 14 ++++----------
>  arch/x86/kvm/vmx/tdx.c      | 11 ++++-------
>  arch/x86/virt/vmx/tdx/tdx.c | 26 ++++++++++++++++++--------
>  3 files changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 6b338d7f01b7..bc0d03e70fd6 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -189,19 +189,13 @@ static inline u64 mk_keyed_paddr(u16 hkid, struct page *page)
>  	return ret;
>  }
>  
> -static inline int pg_level_to_tdx_sept_level(enum pg_level level)
> -{
> -        WARN_ON_ONCE(level == PG_LEVEL_NONE);
> -        return level - 1;
> -}
> -
>  u64 tdh_vp_enter(struct tdx_vp *vp, struct tdx_module_args *args);
>  u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
>  u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2);
> -u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
> +u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, enum pg_level level, struct page *page, u64 *ext_err1, u64 *ext_err2);
>  u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
> -u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
> -u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, int level, u64 *ext_err1, u64 *ext_err2);
> +u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, enum pg_level level, struct page *page, u64 *ext_err1, u64 *ext_err2);
> +u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, enum pg_level level, u64 *ext_err1, u64 *ext_err2);
>  u64 tdh_mng_key_config(struct tdx_td *td);
>  u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
>  u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
> @@ -217,7 +211,7 @@ u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
>  u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
>  u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
>  u64 tdh_mem_track(struct tdx_td *tdr);
> -u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u64 *ext_err2);
> +u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, enum pg_level level, u64 *ext_err1, u64 *ext_err2);
>  u64 tdh_phymem_cache_wb(bool resume);
>  u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
>  u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 2d7a4d52ccfb..c47f4de2f19c 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1648,14 +1648,13 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
>  			    enum pg_level level, kvm_pfn_t pfn)
>  {
> -	int tdx_level = pg_level_to_tdx_sept_level(level);
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	struct page *page = pfn_to_page(pfn);
>  	gpa_t gpa = gfn_to_gpa(gfn);
>  	u64 entry, level_state;
>  	u64 err;
>  
> -	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
> +	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, level, page, &entry, &level_state);
>  	if (unlikely(tdx_operand_busy(err)))
>  		return -EBUSY;
>  
> @@ -1699,12 +1698,11 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
>  				     enum pg_level level, void *private_spt)
>  {
> -	int tdx_level = pg_level_to_tdx_sept_level(level);
>  	gpa_t gpa = gfn_to_gpa(gfn);
>  	struct page *page = virt_to_page(private_spt);
>  	u64 err, entry, level_state;
>  
> -	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, tdx_level, page, &entry,
> +	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, level, page, &entry,
>  			       &level_state);
>  	if (unlikely(tdx_operand_busy(err)))
>  		return -EBUSY;
> @@ -1788,7 +1786,6 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>  					 enum pg_level level, u64 mirror_spte)
>  {
>  	struct page *page = pfn_to_page(spte_to_pfn(mirror_spte));
> -	int tdx_level = pg_level_to_tdx_sept_level(level);
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	gpa_t gpa = gfn_to_gpa(gfn);
>  	u64 err, entry, level_state;
> @@ -1808,7 +1805,7 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>  		return;
>  
>  	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
> -			      tdx_level, &entry, &level_state);
> +			      level, &entry, &level_state);
>  	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
>  		return;
>  
> @@ -1824,7 +1821,7 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>  	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
>  	 */
>  	err = tdh_do_no_vcpus(tdh_mem_page_remove, kvm, &kvm_tdx->td, gpa,
> -			      tdx_level, &entry, &level_state);
> +			      level, &entry, &level_state);
>  	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
>  		return;
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 5ce4ebe99774..22c0f832cb37 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1516,6 +1516,12 @@ static void tdx_clflush_page(struct page *page)
>  	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
>  }
>  
> +static int pg_level_to_tdx_sept_level(enum pg_level level)
> +{
> +	WARN_ON_ONCE(level == PG_LEVEL_NONE);
> +	return level - 1;
> +}
> +
>  noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
>  {
>  	args->rcx = td->tdvpr_pa;
> @@ -1556,10 +1562,11 @@ u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page
>  }
>  EXPORT_SYMBOL_FOR_KVM(tdh_mem_page_add);
>  
> -u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
> +u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, enum pg_level level,
> +		     struct page *page, u64 *ext_err1, u64 *ext_err2)
>  {
>  	struct tdx_module_args args = {
> -		.rcx = gpa | level,
> +		.rcx = gpa | pg_level_to_tdx_sept_level(level),
>  		.rdx = tdx_tdr_pa(td),
>  		.r8 = page_to_phys(page),
>  	};
> @@ -1587,10 +1594,11 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
>  }
>  EXPORT_SYMBOL_FOR_KVM(tdh_vp_addcx);
>  
> -u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
> +u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, enum pg_level level,
> +		     struct page *page, u64 *ext_err1, u64 *ext_err2)
>  {
>  	struct tdx_module_args args = {
> -		.rcx = gpa | level,
> +		.rcx = gpa | pg_level_to_tdx_sept_level(level),
>  		.rdx = tdx_tdr_pa(td),
>  		.r8 = page_to_phys(page),
>  	};
> @@ -1606,10 +1614,11 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
>  }
>  EXPORT_SYMBOL_FOR_KVM(tdh_mem_page_aug);
>  
> -u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, int level, u64 *ext_err1, u64 *ext_err2)
> +u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, enum pg_level level,
> +			u64 *ext_err1, u64 *ext_err2)
>  {
>  	struct tdx_module_args args = {
> -		.rcx = gpa | level,
> +		.rcx = gpa | pg_level_to_tdx_sept_level(level),
>  		.rdx = tdx_tdr_pa(td),
>  	};
>  	u64 ret;
> @@ -1822,10 +1831,11 @@ u64 tdh_mem_track(struct tdx_td *td)
>  }
>  EXPORT_SYMBOL_FOR_KVM(tdh_mem_track);
>  
> -u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u64 *ext_err2)
> +u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, enum pg_level level,
> +			u64 *ext_err1, u64 *ext_err2)
>  {
>  	struct tdx_module_args args = {
> -		.rcx = gpa | level,
> +		.rcx = gpa | pg_level_to_tdx_sept_level(level),
>  		.rdx = tdx_tdr_pa(td),
>  	};
>  	u64 ret;
> 
> base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

