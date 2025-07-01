Return-Path: <kvm+bounces-51151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA08AEED72
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 07:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5052A189FA8E
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7BA1FBEB6;
	Tue,  1 Jul 2025 05:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q+S8xj/R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A26A47;
	Tue,  1 Jul 2025 05:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751346622; cv=fail; b=oASIJlxt/1G9Bot1szNRPN1TTY3BQBp2L9BA7ewuv4+2EBBo6/z4BO/kJfp5lIGiaEAiRpJe/efXKXC7jQNyqUP5+p8W8apx4MZt1jSTtQQknuKA/KIZCtiZAab0xzwGYqwDlG+ESgs5qDAz6A58k9p6wTfE/M5b7AzqlxQ6bUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751346622; c=relaxed/simple;
	bh=KNB6OnJhHO8vzU6S4RIu4WwKdQlzagIq9a2Ti1wm/N4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z49QmDhXt1BrbL/ssfmNFXhwFowhXa6IoaucUQ8L0bl+CR+Mr0pcZlS1wjcp4zyHOmYzJS39CC1mt1mvZgHiFhJES4BBB0D0wgDAHTjzG8D0ticeZBbdTx7IcFTUhDAC6URcH/1QpnuId9QRSYUZNsrOdmfsBCBGuqmwv8tmlzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q+S8xj/R; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751346620; x=1782882620;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=KNB6OnJhHO8vzU6S4RIu4WwKdQlzagIq9a2Ti1wm/N4=;
  b=Q+S8xj/R5ZwBiK7Vwxb0dZr2LLlShplA8eUBmxuva+iQwC+2dECRmzjs
   AkBGWbbBlxx5PT0WksdT3oUn//Y3tjphRUA7QmgS7hd6iSdlI0B5JiLr5
   QDXaoZ8Z5NdyEkqsz+4S5HHobcL+E474PRPOW3nhaPdh85n3sJZ0gpsOf
   vRMS5WuFtmgEnTJt/cTlUzf4G6qSRZhlAPOjgIgmSVkAchoHurHt2b3Nh
   jicI6ONT8DeXjz09MKqUHmtgiKCaGIvKOg3R9GnrTpI9Nf6ZAlLLRWCwD
   sl/OXTc1L82tAPEt3SQszL9p6mPAqv+pdA0ba+LM2cXH3xoCDOFZREWnQ
   Q==;
X-CSE-ConnectionGUID: /28ebv68TRODlmcNKrBUcA==
X-CSE-MsgGUID: DFiGn8eYR6eBUVN8gWBLZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="71018189"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="71018189"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 22:10:19 -0700
X-CSE-ConnectionGUID: yz0kG7wpR8GLeCCBxLSmuA==
X-CSE-MsgGUID: ioa5IYdKQDumLEXGrWfXSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="153831654"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 22:10:20 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 22:10:19 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 22:10:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.79) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 22:10:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HrH4SoqM/ZgPX6/c8hCvXCxOdneBlsQujt+nqYnuhZSPZejodR10UiS2c/FsWs4NZ8uA7m15Ur0R4CjSwiQu3NGtIDusD/ko+nOeywIbeCp+m77LQTKqWjGtJ2pt4KxPwQH/OwMYCYeg/kE2+u0mzcZ4VsNgBwfOABe4iI+DOvXLl/QiYHGejbrE1TWLdUtNt7nUHGhS4AVQYRL9zw7dPJ4zOdjkDhhNCFvT5mHJ5/UMEx/owOFJOZqS9ZKT3pvKbxRQhQm/m7TxYW8Gfbbrulx8Uw2vGMJ4xu1u28NROb0xOXjINQOg2vwdXJ5Nj7QmOrUYDhPjQ+pEfFFFrFuxww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zi361OM/9LMuaz0oBCsTbYkVPjuBtRYPdqYtlJBPGKU=;
 b=Op1AyCntR1tsHnXupe9OuwEv+fm79GRqa+2NXRrHvOyZ2KsZWGoxHsD7UrwJQjsfdFsTBu2sOlwqdStSaRSW1ivgN6um2NJqzjDBeN/zzB7gUC2/Fdte/FCBZTecbTnaReq+HDv0d7NICo/uF5mrPK7D/dJvqtyTq3iUIQfzbElmUV+9wDmS6xsQpGUQPg0nDZTgKrdqCMxiiBX6fJeD67IgEosc1PQrhVB7fX0rnkY1WyggwJa+BLCGijf62r9txfYHQ7aNBDN2xdUqZ71jh3hcPvGP8WL4uuhew0awjxHouetEGZNoznTOvHTFw6mLtH2ZDJiGYo1kapIpcErBDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by IA0PR11MB8354.namprd11.prod.outlook.com (2603:10b6:208:48c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Tue, 1 Jul
 2025 05:09:54 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.8880.029; Tue, 1 Jul 2025
 05:09:54 +0000
Date: Tue, 1 Jul 2025 13:07:15 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aGNtA+E9FT0Q2OUZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SI2PR04CA0005.apcprd04.prod.outlook.com
 (2603:1096:4:197::16) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|IA0PR11MB8354:EE_
X-MS-Office365-Filtering-Correlation-Id: 196aa3e1-e4b5-4d0d-481c-08ddb85d8418
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?F3x2HyFU4uA+wWjEnYMBPlWS91/5os0dkGuh4Qg0mvo2Ids/TZoL9inIkbmV?=
 =?us-ascii?Q?XH42eSIyIZ6DRSZRSGy0ozV9bwro9eeFdn5kqxB+hZjVouI5QAEeSgAxVUhQ?=
 =?us-ascii?Q?dHEcj44dEyUO8Z9Bj1yPdifHZuV8+DpW1uFRjlanm1SaHpdN/201S6dZN1Fq?=
 =?us-ascii?Q?epw7xcgGERm1eWEml7d9kbaYOGY8V3jDmwxDGXKv8VbwftmZzeZ9wN5XNF+p?=
 =?us-ascii?Q?i0uTBwjJAI0DkKDg9H+YfjyDRkzAO41I68jDwgrKnx1+RtTMHQy9QsZdvSI+?=
 =?us-ascii?Q?2HlwBkaHLlMebuRMRu0M23DWCMErp37w8EqNxxXkSLICSDN2mjeiTQcG6rA5?=
 =?us-ascii?Q?9nMBU9aqOnDz/ncZ+1nhkoayKA9Ne2Kg2B9HKiYcF1Nk3cZk5ZCocuRbPqWZ?=
 =?us-ascii?Q?DH0tlPSeIOdErrWJw1e4R63vTDYUmiORk3DtLvA+f7t866KnfurdesjXD3TT?=
 =?us-ascii?Q?Xyjenk9lK38AN69LJcTwf36k85kg7lxq7u7iMbld15nxHreJqL7olhyAAWr7?=
 =?us-ascii?Q?BiajdbnA5Uij0VQPbzPHlrCm5nKWbAFC6vxOtwKJqIxtFhez77xCO/Qxcwyi?=
 =?us-ascii?Q?EX5urUVQQIVVmVcfny9wn561YoaQ/EdubxOi6aECd3YSbXZjhgLh8LsWJtd/?=
 =?us-ascii?Q?TJV3mwuK4nYB1vIKe5O5WDP++KtfGsihrvXQn6XItHRRrC1qvmRtC2ZsZBT6?=
 =?us-ascii?Q?YlA2UXVeFkOTzDfmWH8M9bFnSu3f0wnCYFY4y2B9yzqJLcEhDeyIqNYq4yb/?=
 =?us-ascii?Q?Vg2Qn74b0GJjLH8fbqAQ/XuM0RwzJHXKeJtHn+Y85IMS0hVaFKakfGHAmdzF?=
 =?us-ascii?Q?eQlf7IfJBnBfBBWVBJKYWmDJeY60HaKYZYy+OhUvTREbd6lqBqe3Y0RiWY+A?=
 =?us-ascii?Q?Zc+XKJ3ieqPpnhPjxAk1eIcB/5Ypc6Z7JfhikQD+Wez2O8eflTogOZUCgMoR?=
 =?us-ascii?Q?mnIFDWSlc1cdcpq0cougcibePOu/hMDd20C8m2u5P8WrbxCRri2Y611FQx/q?=
 =?us-ascii?Q?hMXW+7lkwF1jOujzyzkCF3v3xj9GTjdNMWgk2AmPv5dhWF+soYOW/vts6OkB?=
 =?us-ascii?Q?yBc7yKAB1iljCou8MDCWuMb0CY0KtlBcIniwxLSl7gmje3ZLJzQ8/h6B8wvV?=
 =?us-ascii?Q?pyzlPPMV5yUrWtZt64J4nIrLA2aO+hP2Ol8Dk2I603u1MalgZ/GBDlBZ2Pe7?=
 =?us-ascii?Q?Nj1D7SeMDcFp6QfgcqBAsJ06VtV1HNJw2o2i3XxEE2V5droLJmUFMBoo03Aw?=
 =?us-ascii?Q?1Z6lxsvrEYht1HC8HMpuYejZTdVoKq8GA5fBuQGqwfTArLPAIke+/oPULwCD?=
 =?us-ascii?Q?QCfKGTEH+6S/aUT+uHQK9Er+lrmTgYs8F9X7jxbi9y0OJzRWWIym6flRZG4z?=
 =?us-ascii?Q?AquuwS+fFmWwWvO4VrX/7/qYWNDnIfB4y4/nhCbWersd8LfnTh0QgS1/0iKn?=
 =?us-ascii?Q?5GqFIfn0/58=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PvQdmDjMKxvviQh9DBfcbbkYKcErHBA4kJ2eoupqc0a/c81iLN7aBwg7u3kL?=
 =?us-ascii?Q?SPOL8FVXkmfMEsfIGOryA5pmvP66JfJoygtDz0rBoXQuxXvNt6iXQNwsRLJR?=
 =?us-ascii?Q?WaH8slC/Jy5JdgvYEqU1h55Sa9Sb473L9AGUdRA09vltN8KkxBYjR0uJtnLP?=
 =?us-ascii?Q?WJNuDoy4t0Kbxcr28aMUzTeowobXJhSxKGr/hrycbBcwsjm0Igs1HpdOGAh8?=
 =?us-ascii?Q?+Gmag72Bg4Ji7aCmwADfaaAkKVgPh5BnTgPebGqogSR+dJiDuel8UyGwJhfy?=
 =?us-ascii?Q?nNJSPJON4615v1GP6g2fqj5KAbe18DwJDvZPqFJ2ZTpTG4QKf1dm4zMlBzym?=
 =?us-ascii?Q?wjlUXi+E0qvLdz/kOEHzw3CnZKuNe+oPzKLxkNE6juMyPgN+SvfrniBIw8VE?=
 =?us-ascii?Q?6dZCWAnE9Jcf5Hlzd5oADU0uexgRDofPXnTMqHhW+6F4hHajBIJ2hhaO85w/?=
 =?us-ascii?Q?IQp/LGR4tIR6VJmYcih2dx/FXHqd6Z6qVX60EF7xu+OkRMU4Or2jZqMach/j?=
 =?us-ascii?Q?DcugcuypHKEPKTHV/heai/uLmj/u1oCwSZQ7Q1wAcMFmQFuf9bj94tLytPZZ?=
 =?us-ascii?Q?mU9WNdxEQkhRHmR9UrmhF3pr3PBgBjzg6rnlpIqawLpTkzz6YHlrs/RbEkmg?=
 =?us-ascii?Q?LNgnD4NlYtnZAQ+RJDrXVcBZquontsoe7jpP7u9iH2l4fJ0UP4B6iIMi1uxu?=
 =?us-ascii?Q?vBryYYPoV01yZr+bH40f43k/qPAfE7Fskrcx1UWk7Zz+Ou88wvDu/Sbm/jgM?=
 =?us-ascii?Q?JUGX5Mlm8NVTeI39XbLGcbYxy3R3za7hnEgXglCiWwrkFbfG1C/aKn/dXShC?=
 =?us-ascii?Q?1bs3pAPjaeLClMqpmKpHblElm0N0Wbwnm1dubQhTZS5TucGgFoWAzIuUPvhn?=
 =?us-ascii?Q?w2FuoFBNbOewKHNGT4WadR6zx/mIPVJROwE+2c2oqI39cTM7J09R+kAdq2A7?=
 =?us-ascii?Q?q6uzpjaYo0jmex1YhnCB4JrxIOc6PuNxiOl+OTIKt97Efj4E0NyDsEY0Jv+I?=
 =?us-ascii?Q?SNPvIjhjzQynBtgQ6/CwrWCzOJY4CeM8Sllraz3oD/phGkJE5tWn2gbHUil3?=
 =?us-ascii?Q?HoHoY1kjlqz6h8Xi6CQD6veR7Kc+Gyj2m0O9HiO4VvHR8jo62xE8q910bY4f?=
 =?us-ascii?Q?R0rM3OaiNX3NEunlpyukoyCS88fbrhYKHxve1RSTvLP8MvTlkef93z9R6aIW?=
 =?us-ascii?Q?h69wwPsGVAB0rbnOwoXJEymse+Uwzw0WYrzN6HXo9vlXC/eeBYa4Ljrgxb5J?=
 =?us-ascii?Q?KYc9MgxhqzyfJbWrgeS0RtLjhLc/yG8yEil0ZlZjmL7Zlxeki3t/2hdzKym4?=
 =?us-ascii?Q?JqEa/7xPjiQs68+e1P04IvtSaNRlXjndm6E1q8/la/ZvSfFAihRT9qUeLH1p?=
 =?us-ascii?Q?e1KCQvd5/mt0PZuhRCPa4MjPQs9TAedJpgLMkYlMdY6kb8Fo7ozTpak8ZBLT?=
 =?us-ascii?Q?3gjJqAogSvmzndhxFPkgUllGRf6xW/Tru394/25/r5X9Up8n0ZAFcz4Qvd5o?=
 =?us-ascii?Q?zV+cgUXF8UFKvgk8O4IcXJBZmXIATvgyjOIqOBr6F9XcVmXpBn+bnU/9txH2?=
 =?us-ascii?Q?5wALo96QmUVklwVxb3znJOlsFuiDeJKOSHorbpHA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 196aa3e1-e4b5-4d0d-481c-08ddb85d8418
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 05:09:54.5304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xPYEvKxzIgfkIBVi5C7y2S/VKEzHRrMBNGiSbvrNsmIXM3DYccJBdMuMzJXcafBKCcfZ+X+QnCD2MXADse5WiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8354
X-OriginatorOrg: intel.com

On Mon, Jun 30, 2025 at 12:25:49PM -0700, Ackerley Tng wrote:
> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:
> 
> > On Mon, 2025-06-30 at 19:13 +0800, Yan Zhao wrote:
> >> > > ok! Lets go f/g. Unless Yan objects.
> >> I'm ok with f/g. But I have two implementation specific questions:
> >> 
> >> 1. How to set the HWPoison bit in TDX?
> 
> I was thinking to set the HWpoison flag based on page type. If regular
> 4K page, set the flag. If THP page (not (yet) supported by guest_memfd),
> set the has_hwpoison flag, and if HugeTLB page, call
> folio_set_hugetlb_hwpoison().
Could you elaborate on how to call folio_set_hugetlb_hwpoison()?

> But if we go with Rick's suggestion below, then we don't have to figure
> this out.
> 
> >> 2. Should we set this bit for non-guest-memfd pages (e.g. for S-EPT pages) ?
> >
> > Argh, I guess we can keep the existing ref count based approach for the other
> > types of TDX owned pages?
> >
> 
> Wait TDX can only use guest_memfd pages, right? Even if TDX can use
> non-guest_memfd pages, why not also set HWpoison for non-guest_memfd
> pages?
As in https://lore.kernel.org/all/aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com/,
I don't find a proper interface for TDX to set HWpoison bit on non-guset_memfd
pages.

Neither memory_failure() nor memory_failure_queue() seem fit.

