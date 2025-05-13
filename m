Return-Path: <kvm+bounces-46397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF35EAB5EBC
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 23:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E41941B4714D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 21:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3800205AD7;
	Tue, 13 May 2025 21:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ShJ4KP/E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F388C22338;
	Tue, 13 May 2025 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747173370; cv=fail; b=sxegehBoB0iixXsOmjYxbU6aVDDb0OBMhLEJCc/89vVCu8YvcWLDqhWSfCyhAGJt1O0BBtzjbg5Pq4eR41j3nGkOXPzGp3Q4wB+XhP+ehr6qzjJS3aZ8Lms5x7rHyWRPFP5QGKoih+4YaSy0c4ZMqtmN9oEJAOyWhmeRFXr8cnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747173370; c=relaxed/simple;
	bh=PE4iTYMwWxYuh8ct9XD7Mdz/gwy5MDHglD1sZHDo9rw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SSVEIDXYLj+1HS68VGJy85KdPIe/FTC1ft4piqccttv7prx3y/1Z8chx25L3L0qFJr1FnhERpmQHobs/2w4oDGGJpTlrn9ryCDAp/tSoFHz65NlCQLkthKpHfUEmBtdwNOiyOdp1wdDZK3KRJrPY7YZs0TVGzKKLMtP2M29rdZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ShJ4KP/E; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747173369; x=1778709369;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PE4iTYMwWxYuh8ct9XD7Mdz/gwy5MDHglD1sZHDo9rw=;
  b=ShJ4KP/EN15NcAvHmgznA3+WsPmccNu26N2GpxTZJZUqBd0iZjM4MybI
   yKXE9hD/YmvQCF2ssLFkMtImQJb5L4xeKLG/XBnU/8w5XDDgoj/KAE9x9
   qRmzdnUC0BgufPaDqWktECAEMQLuqkqJDHz27f2TRgt39Po/RRu3M08Py
   W60GJeZ6nDy2tKrbBhDgch+XhbXXYtem0fKbB/Xyjq2fMkjNOaB06mAp7
   sul6DaqjWZVav6JmgaRFS1gN5A5i2T29SE7/dRXTXWZBHTraUHdSjWnwU
   pwq4rFCchO/ViNXOm2Ul8CKUKwfWIh9/L2KGSy1CY+999qHjr1XuBisGs
   g==;
X-CSE-ConnectionGUID: 1U8K1ErxTP+GCMNB6Z4UeA==
X-CSE-MsgGUID: krfAIMaxRMqZsH/gmlecnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="59679769"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="59679769"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 14:56:08 -0700
X-CSE-ConnectionGUID: 3tB6Ac7rSg66xgx/rIyaYA==
X-CSE-MsgGUID: has+JzaVQcCIcQU8V2GGkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="137708625"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 14:56:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 14:56:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 14:56:07 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 14:56:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zBM6q0GYsKeOe84d/2pS7KanKVnK1XQYPQbewz5cx3Z21TWvniVbHnn9yhA6zpqpbdKr3uUMgAN9J2B6VwNAad18liP7wRaob+WVZ57NzU6KeCdQ6jmeE55S8E/kEUWN/jYSp/84f2khVMAp/lE5DOWsPW7EqoWZRh97PKCauxJ/5RyJ2qTsikt/uft5fWzEaYbXEQCNHmSN+ICuf7xtFKT76je5yjCC7Jf3H1jiXLtFL15ZymrikVs4ikzxxICXTJsQUoa1bQakvA3+VKldD4VmhjvfhnIcvd5tHPsvwzP1eEEzZ06Qvok5Q02b+xp4YovMqDSbEyhfLTNWxojpHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Oe7i+F2Bwr6eunZlbUqshdsTSsweoZr4kbB1gUTzyg=;
 b=BkbtY0VYqla6uFwxHXkLzZA5rHrYPDlphar9ep2huJuhd3cgYanyxMXDX2FJVrMALCs0iNyZRiqU+u3S+Dx0/rs4dzFhszcD0RVgVDM9fGZ0aQvK4Ku0Np/t/LtYl3ABC9/VMrTmDWuija2a5hAH5EDScFFWhLfqw0Kdn7im2gtrIloAdcQcEFBb7B6faN35FHJYlcxgV06mOM87NJBfdSboSpLWNjoCCKCZ2k66UJtLLQ0ZAFuY4yLT4h6WNkIocWwzXa5MXwyr5hvjnOO1H6KnZYqKLgsYrjalqzhhf0UQjcqFprvS4N6gzutOp/EVwSsJK8MENHO+4N9kY8JKvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 21:56:04 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 21:56:04 +0000
Date: Tue, 13 May 2025 16:56:43 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>,
	<pankaj.gupta@amd.com>, <ira.weiny@intel.com>, <tabba@google.com>
Subject: Re: [PATCH v9 02/17] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
Message-ID: <6823c01bab335_32bb882941a@iweiny-mobl.notmuch>
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-3-tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250513163438.3942405-3-tabba@google.com>
X-ClientProxiedBy: MW4P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::16) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CH0PR11MB5217:EE_
X-MS-Office365-Filtering-Correlation-Id: 90c22c4b-0b67-4072-e5ad-08dd9268f4d7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4K/kG8ibX2WixkkXKov0turiTDp7plwiHFofFwbhfbXY3UzNCLsrM/tbdJtI?=
 =?us-ascii?Q?Vvexeuee7fCLo/dqajGUb3LsYMmPxa8cutLHcwu8dmryrTT/i9zzhCVmAgGR?=
 =?us-ascii?Q?09i9f+E/kY8MZq1dfJdHXucfUbRHOWIangeLw/5g27rlGqLWasLLk0+iPq8D?=
 =?us-ascii?Q?rH/8aqCdnX4aH0B0cJYiBl4Gz+QH0aTrliZGcdpCEx21+inDRkPm9LPEKlto?=
 =?us-ascii?Q?JCPKJvZUS891h4Hqm14OF2Qf5cVwwO0SdbXohYiIiWzR2fr7SHOlBxqly9Ic?=
 =?us-ascii?Q?Y8S/URVLDq+9W9EXprwJzB4t2joYVP58nqGZ8lleOO5gXt1fPLew59S2PQeN?=
 =?us-ascii?Q?eYdmSgninsbrzxUHCIgVsvm2533TO37ENc5UlX9/nPTvZoQ/RD1zyr3cQgPb?=
 =?us-ascii?Q?t3fEdQJ3BwJhSj/LaWTgH4ALTB/FFPh2KJVq3nPxNRzqD3IlaoD7JeFHZQz4?=
 =?us-ascii?Q?x74ugcI1HcvrV71ZJ40DZMbs6nbSpBYk4nICEh5kg+9AxRdArzzhmmMMmp9p?=
 =?us-ascii?Q?xeo08Ay02hiqSVeF8Aq63Jx6slh3bVmkoKgkAyFdL0TaixWetWSKw/Sn9oQi?=
 =?us-ascii?Q?7QwBLkMb7U4fdZlPVWgel5HsK9c78isNuJ6tFTm2jWuuUjrf/+0LLiVCap1V?=
 =?us-ascii?Q?U+qu/S5qnWd7EtJawI2EAcxzdtLJwMfKjmR/PEdGyeHFQWxjfxKTCrDW2g42?=
 =?us-ascii?Q?Jf7/gq0ZbjyU7ZquiIJIWC9vlJVbv2D3Ksi/utTgzznKpL37DmOT8dMsW055?=
 =?us-ascii?Q?Uu/o08UjwyBXnhew6AaiHhusuIRuVJvwqhOY32iYnNFUqOe6Rz3E8GO9uLmv?=
 =?us-ascii?Q?EToQfjq5sjrvm1O/Hs1IHophFfoKnW8uMWk1wl2dPzKb4n4/O4OGBm//azeH?=
 =?us-ascii?Q?b0I6+dXeZg3maJeMrbypG1QIcnrfhfK3Thoi3DSzlLJwWao2TiXYjO46sdXR?=
 =?us-ascii?Q?k62moMf5LxZkjICN2y7akoshYEbtp1a4uP4GDkWdez9QOZUMavUtLC3kNq8G?=
 =?us-ascii?Q?Ub0EkCiHfb/9Gk9hc+N+NYZKsE/mWvheVGKcs7otuFUhrfU4iq4d2BXzLO8f?=
 =?us-ascii?Q?jKZKVkTk4qaHNS0fmI6Jy/tnT2zUWSF1PbVArk1TzpfFA1a/DVx236PKhINz?=
 =?us-ascii?Q?+UnTJhaUOjYnWypinoMv5dMOKLikxYTWM7//SA28hvP85dcm6CLV+QugoqOB?=
 =?us-ascii?Q?hXb3HJ18gZYbWuweVxowfMXDiIAv0ktKZIBDB3FKvYkS6ih+U4080iX87RnW?=
 =?us-ascii?Q?jaEFexbHeU4dpV5bgjUowmpf+UIRB4sdIk49c4wzFVAj+z8HB6nSoDoabxBp?=
 =?us-ascii?Q?XiR8QD4hmsWog5t398Ysvo/QJ2tzjHGkD2aFE1tpIE3IsiSy5Qeho1mb3qkr?=
 =?us-ascii?Q?MUPkgOFwZWdmrO+ellsMiWJIRji4Rmk8Eyy3PIKjac77OyE7Ww=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?65yiNEAKjWPn5OcrhaLkXY99nssO+GuasZmoXq3rwzO/GViRIWaeiEdqRGKv?=
 =?us-ascii?Q?3cAmPWYthL5aPWm6XLpbc0cmPII4EFxKOr/YXi2z+G3b8Mm7ABhSzwkL5a93?=
 =?us-ascii?Q?yiCIiowKBnOU6tvMcuSFUhycxKkSE1Rod18MwDkHoCN9uXRSXWP03GC1uq3r?=
 =?us-ascii?Q?pzEntSfFYnatj2o+kqxO+Tb8a0zwYcX30TtyHNOP2c+xUO3cW/zZjVGjRRRb?=
 =?us-ascii?Q?PQO2yDUW2C16Ln/tBk2BwG0LSM73w7pDbWv2TdnfUuaVFq2dwGfoGEcV87bL?=
 =?us-ascii?Q?1kaB33R+Reb52j8HnFkPhYNFCuBfjhe11fWyzCg/DUvNzygK2nFGUdBlUZ/X?=
 =?us-ascii?Q?ISWRf2MSJXakpVs8XULx4wC28NW3ZbZatkQ4YMR4ghTpHjt0ux6g5CFFEMA+?=
 =?us-ascii?Q?S9noiqD3zfMkeJeQOdDA4HUIC5Hx8/ubnJ9CFZZvfOK0fGT9POgBcALLG4r7?=
 =?us-ascii?Q?tkJV2ZP22TmHwn7Xqei51LaGklccRF8OYAoFOPavwyAtH/qlz/MgPki1+5lA?=
 =?us-ascii?Q?Y38fT+lqLmFsHUaaQtJo48Gv8NhTROXlVhjGf1tGndrk9zUxGZf2emnTnBCd?=
 =?us-ascii?Q?WkZP5QbiRB7H1X3NDAF+3E3dbNZEpjMqNyCIC0jFDrexOwfS7kQCUtIqMndC?=
 =?us-ascii?Q?B+SaRIWWmL+gzqIUy8AAO5KWcu2Y9GyyROQ1FWJ4zVj9DpLC2yg//wl/qXlR?=
 =?us-ascii?Q?DYP+UKXj7MNWspLPSTxpbYtIDxsydh3gkmisMeGeHjNfOncZWzrh5jPfpsRI?=
 =?us-ascii?Q?7o35VBAnTF/148JP/ePWwUVG2YcEFlae3R7jeeoYtieNxs+s1OUtpMkI31cR?=
 =?us-ascii?Q?YKBG0WGIml5mL3B3ZwKDTNYoSrpL9eNr+BhzNqnnJDyj5WOPXBpuFUnERvQq?=
 =?us-ascii?Q?O1bkTkU8EbDtHoe/VBJdmiqJxlDfWBnPZ8uyHwvCqVCtfEzM/MIDcPMlT+SX?=
 =?us-ascii?Q?Zzu6x67AVsC3cZ9Dwrjxr4729e6FQobQeFMHZlSI+Wu4Llw7XBLEjyzH6lwa?=
 =?us-ascii?Q?RvgmsrtEhGhylER8T4lmydWIotlyeyf/WjrhEMyNMNvIgTKM/7RRH9GrkByd?=
 =?us-ascii?Q?H/M5XAkmH/mObTCXqhFocGChYZCzUGs6zvkW+npZlhst3TMgNejuyJIYzHI7?=
 =?us-ascii?Q?U8LBxj9c1m5IzwYbJrLWaMf+QN+/EgCq0Qxb+lZQS2qFeFIupjcL0qMfF6A4?=
 =?us-ascii?Q?x78i6C+0JEreyU4XUn9sZIVx1RfNEUkMz3bDFwkEJOFHSe37NZ8kuwaMi11W?=
 =?us-ascii?Q?FjyF08aKhC/uCo2FMRR4yZE6GuthF+Sc4yEEmnOnHcQKRhZpzj10fzkUWkph?=
 =?us-ascii?Q?hPw8KR/fX/j2i5U+G8mPkRbTdEO+c845qj6nx/uX8hJ3Re/M6XeyvkXYdp7d?=
 =?us-ascii?Q?jQOaElytswuMPb23C3h5wqLmcsQfIWUKZ6avtlt1JdMhDXfEq0BxYL5hz43C?=
 =?us-ascii?Q?yX8rT8zwH9RLm3eGQO3d8pf7527AjOjAQQvKQ7eykgykG3xeJkOtyXJ3W3Ai?=
 =?us-ascii?Q?LDh1WcVdcgwurjNHA/B8o5H0sVeFV4RQci86neFfhK8GMIjM6SN30u5wJSAY?=
 =?us-ascii?Q?z0PRJMl4+tpb1XJAlcEDc3Tf7TBAS9IBjFb3rlA3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c22c4b-0b67-4072-e5ad-08dd9268f4d7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 21:56:04.1067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYF+VH2zNuSDsnw1rv/Br6yt4NPECkxhpej/69sZqqQI1bZE9GbKwrk1Ft1gmo2YMiEDh/9bHxY/dZlB+zJ9iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
X-OriginatorOrg: intel.com

Fuad Tabba wrote:
> The option KVM_GENERIC_PRIVATE_MEM enables populating a GPA range with
> guest data. Rename it to KVM_GENERIC_GMEM_POPULATE to make its purpose
> clearer.
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

