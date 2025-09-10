Return-Path: <kvm+bounces-57176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C127B50F39
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D4151C811DD
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 07:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD2A30AAC7;
	Wed, 10 Sep 2025 07:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FRlDahd0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C145309F07;
	Wed, 10 Sep 2025 07:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757489147; cv=fail; b=ewD+oI19R/xocfq6YWeskHHmRlmBzZRsOmNDUQA1JQgofretU4dfRubukcdsjpwTiXhlcIuBp1aY6LnME7VTwOYhqbY7UiC/vUX24UBJOlbupspuKzdrWSl6zssb4G//izJekueVE2UlMdZvFh9vbeOAXEIqXsaz3cJDVcgjXic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757489147; c=relaxed/simple;
	bh=8DecJmwr3nKqhf3+ObnpPpXfRSyIDB4jk4RhjQQdRXM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Yd/SsQrVacLkQiv/eFX8iQWl2jP/WbWMP/DF5gd8E7Yqoen8+WTKjOs8L/SR937uBrq6g3XisLhkszUjOOmWKU1R0jCpcumCyj15gUQD6sMZDDzS3/Kux0xyWMFNJrbpMZav35R6h6asreSWhNtJtdBI7Vx0EDwEau9nJy4UmGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FRlDahd0; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757489145; x=1789025145;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8DecJmwr3nKqhf3+ObnpPpXfRSyIDB4jk4RhjQQdRXM=;
  b=FRlDahd0qP2bmIb+9XhbCfpwPZXmOHT3DdKqfS8uwvIxNQxDrBp4EWBK
   MV8HJeAEnkCBftrLbe/Psg+q2uwEntxfzkOTrcOHpLx8dc+er5OkbnDSw
   +k2NsREm8nnLtZ0lDJNHp0tSLRjVB/dUrNds1YC5Yl89d+4YOpr7ijnpf
   ktKBfkonpkbC7H46c8FRf/wnAjViLEwZBdy9aTeDEyqUBCiFXN/fWKU9w
   Xs1ipiDqXngKVG+7VMWXohCMNd8XLSNZx2Vvnpq8h8usVxW4rtHJ+cN1A
   4Pu7S2qepxrQx9QTQDA1yQ46HLwCS9cL/OyWOleMkPqbORmb0Po1EI7nX
   w==;
X-CSE-ConnectionGUID: +KbKbwC6Tqu8G7M6zCRecQ==
X-CSE-MsgGUID: 9N0yfhq/QgCJsTfMPgb8aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="71204678"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="71204678"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 00:25:45 -0700
X-CSE-ConnectionGUID: N6N7TOqvQ6eokiiw9Wsllg==
X-CSE-MsgGUID: Scp6ObJ9RneX0pDpNyKgcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="204075838"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 00:25:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 00:25:44 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 00:25:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 00:25:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IAQvQRy6k92kJ3NpOOKTOIlgoa30d0yKILZjO2F8ZO8MaSiicOUy5QdHP7QEZVSh6Gfjkauo8cXl/N2qfpJD4jVtEotGhb5CKNaeqmovO8EsQ/yur61tyXWGE/vCRJVFUUK9A4FxfnxJdapOOjqlx8u62PY9//fgkhWQEQw2e8fS02HLlR5dX12eG5LcGyyayXefFJopLKMtxLjC4QCiUL4HmUCIjatQ/nQM+uLSx1sYChtvaRAT3CPhUApff2hyVNG9VYnaQEXiGG7c7erlVxJ2FSlehr3dsjbQ0ToBh96vitbwMVzjkiPrAduclZFfhky8/bXlkoagQul7MuIFKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFVlFq8HVzBzfkANcRLibDaoc0oanG8XKimvJPHnFrM=;
 b=i70Zs+4/rXqozOSwBII38FFXYKnS55Fnp7WEnbKNoGT5MHl1e9SNTq5B8rplH+NR+3OsOONB2FJ7QpMRYxWmnwlXI0FcOeztq91tNuQJDpVf0VLthLOxKaEt7ZtRJ7dxDlt7EixO1iMJcGXpr11CLRvg7T9K2ehN/nhGCj0HMfWTa9pkC7HG1Bezgl6ue5xJqkq9EgTpI7VFW2baymjcGEguDDfnGVlQV/82l8y9lRWFMH1OGYUIyDyBp+uCnO9/AU13ukUihdPZPpx0EumJlt1+TVZwn8y3VLyaraQNC3epPRfx5M8kRR9sK6aWx6ofVw+OEwWEztGCGEJq3rMeQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH3PPF5D8CD6E8B.namprd11.prod.outlook.com (2603:10b6:518:1::d25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 07:25:35 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 07:25:34 +0000
Date: Wed, 10 Sep 2025 15:25:21 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<rafael@kernel.org>, <pavel@kernel.org>, <brgerst@gmail.com>,
	<david.kaplan@amd.com>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<kprateek.nayak@amd.com>, <arjan@linux.intel.com>,
	<rick.p.edgecombe@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
Message-ID: <aMEn4czyuqrQ1+oF@intel.com>
References: <20250909182828.1542362-1-xin@zytor.com>
 <20250909182828.1542362-2-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250909182828.1542362-2-xin@zytor.com>
X-ClientProxiedBy: SG2PR02CA0128.apcprd02.prod.outlook.com
 (2603:1096:4:188::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH3PPF5D8CD6E8B:EE_
X-MS-Office365-Filtering-Correlation-Id: 53e2c054-dc62-4064-0919-08ddf03b3b5d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3eGaULNzaO15bY9KVPEeNNYUM0Q53ZeKjZRFASJZJ3lgdmSjN9F/Fk6glClR?=
 =?us-ascii?Q?NQYJyFq4ANjnAOlr+4N20awVvS/zh9TR1pce0aNu8V+A4heXaqs25J0U2Dby?=
 =?us-ascii?Q?AaemweIcb3uTJLdROIbUnQytq/ieaid4jbnJ9oWHnCSAolOOVZNtzVGrd0iv?=
 =?us-ascii?Q?f4xCxlC5xz8A67hfs4GjJczIPCkKBSwqsZQ66rbCMMV+QZAJAuFT8BUyF+oz?=
 =?us-ascii?Q?UpN+/rdpIKL8IYVqY86LuXERGpkg/G9ntrPOWj5L9LA1sCt2/pLm39xQAqHN?=
 =?us-ascii?Q?lKRB6F0W0pPWgweCgv8jzsrWwEy5iSU8EVVlR6sI0tG48AKG5Bz5iaJSLQCg?=
 =?us-ascii?Q?LKIfgR1TNtBfKxGa2MpQgdgzdVziCWmIU5mw0+TSRL9nhbRqzwloZ0Y/KwO4?=
 =?us-ascii?Q?6YydTO2l/mCa9nGXNme4+Oh6m3+6S017/lROhVKC55Otxcg5H5Shjrb+2ieR?=
 =?us-ascii?Q?We3L7agRh0mwmFGkCK+zSrtMwAKScZfMtBMjqTTVg3Wnq+nxskvQYCuQcYuq?=
 =?us-ascii?Q?EW+OsdrG/7XnIdxo432+duIl8ZeO8tzHEwBWoBPN1KmZax7UIWEUlQKXHQ/X?=
 =?us-ascii?Q?de5Q/2qGA5suazAONzXz4W6cc6UPeeyMDjPkxVIXD7wwy7aiFUIKnIK0xLxZ?=
 =?us-ascii?Q?FH6LV+9pB39FZ8Ji7BQYKrMG/+/gug1PX7WfAmj5NgxFtKmIyx/iVjnRhVQq?=
 =?us-ascii?Q?BMPjYFMpoRO6FXTgJ99SeNZ+9zDL6sRxbXDWpEeB2pwxBvZxlz96FlwXk5MD?=
 =?us-ascii?Q?rIsXkpZigyNEp6/++XP/UzJpgGq2cgOsmwXcgBNLYuWj90vW+ZE9FwCisJEb?=
 =?us-ascii?Q?BFYh9Kj1EyyztQxzNZf2ev0m3l997LLVk8yzrRhA8lWt8uz9KWvQV1I9pUAM?=
 =?us-ascii?Q?aZY56wqPSoL15Rk423Lwnht0pkJn2u52XDz1XfsyaFcwa3iyGx/9Z6qVX4Kn?=
 =?us-ascii?Q?1YXhI7niUlQ8BCqomfa6bSMQ/nLhbWUzau5Nc055KRGFbrigNOcdszHyubpL?=
 =?us-ascii?Q?nwzI/bJiAHCuuuynK2hwkLOGPVrQCA909OcbNIkqoBRd5eKa2AmlCt9qT4Xt?=
 =?us-ascii?Q?gjizviQepdLIOstouyS8psE5bAY9gwpdkSfo4JXbLpsaMWqbY43T2hbkbcIJ?=
 =?us-ascii?Q?qmDtkeS2n+PEnt2G+c39ivpBTTRCdFq67WqAFg0jExBtZoTjWF7qbPHA56hR?=
 =?us-ascii?Q?IlWIyATumIIqdXug7hwCIZSYef/gvhOIQW72clPDwP1Wcb0EFc7ks2lOGl+o?=
 =?us-ascii?Q?ubTYxV6oz6NMHRJTn4hyAuXZGtEDO8hZbcO/4ab5lUKkQtvQx1NhZHYUKVmd?=
 =?us-ascii?Q?9y9OM+0lU/ywGnNNr9LwDcVUojhvvhO+qv+aH3bKbCjv4qsvOR5Adt2oH9/u?=
 =?us-ascii?Q?lVB4LiSSl3PkJB9sDGr2Y/ZX2M5loA3RAwwrBFTTxHTieC7fPxVPOnQMBKSv?=
 =?us-ascii?Q?3hzi3kcHZTw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6LSrGZCvAwcf3XwBkN3skiC/twsTa5mxs0Q6rSdDypgLIQ7cIqx1mL6kBDAf?=
 =?us-ascii?Q?TKpVNSE4nL2NL40J/yFtle1CzEtWqmrc9Obrkt6RFgxgI4n+tk4A4gDcAnya?=
 =?us-ascii?Q?Up+Fzq9PQxQxEwbOzCGedTReDO8GSznk2WjCVauxArByHkVXT8Oo3bdtCeyE?=
 =?us-ascii?Q?HTHbLdL08BetTwp0Wkse6TNQICVRGxF/D3KrUeLsRDCHhKaAmGUOWCA+3KHm?=
 =?us-ascii?Q?m8aCv5RsI4LZSCNNQjUdU4bBMiyIPj5DIESdAi2b1IlO+o6UrZbgzl9lXjhk?=
 =?us-ascii?Q?8U2I1Khkxxc97pFiekB+9SotW+3KUanfby2ng5VmN12aLNHfRyP+kUOoGdI3?=
 =?us-ascii?Q?Xi4DKSW8wqE4i30n82z84nB9Q7n7689cJBYOOH6l5o5/aZTQUOQ/hMGxTVMN?=
 =?us-ascii?Q?xKeVDp9VmLb3IonmUSocpuFwfzGXNk1iWxpxdB8CO6le469QyUp5OVM9scBG?=
 =?us-ascii?Q?nrn6I1wXWitwrhJW3icRsEIvHroD90fX1o2Xx0ce5rofLfCgi85+fq7hLRUL?=
 =?us-ascii?Q?mGwl0kPhDO7SUaoHRLfPh5q9rcqSD6Xy23pwkVaPo3gpJBRmdp3Q97MUqaHD?=
 =?us-ascii?Q?z1HDa5D6mB+VwTVUIFYwvTeyKRhU4eN33PKhxKf3Tq0hdXFe7iawiB5TfC53?=
 =?us-ascii?Q?FqFA7ZllzviUgXzNefztLPhNK1yU32Uw7X7LXMuYIamzqT2m1ItgOGPFkUfo?=
 =?us-ascii?Q?bxHiTSZizyR7Stw1rob15bciux1MBLd7ZOAHRq29jDfVzLUUrZ0gSGKTc8im?=
 =?us-ascii?Q?ZCVaJCRQzMVhYYWV2hmX+kbL2FD6Bl8L2fozM7OxXPJgVEI/JV0I0+Z//Kkz?=
 =?us-ascii?Q?3i8ul6Kkg3Tu8HnCb4cWeHsWhVsV7e4gjeYHJT3F3ndQjdvc5s+ZmSvYHgZ/?=
 =?us-ascii?Q?s52G3I2TK5CfU9i374deuxoiGvuX2ZnDki19rnxEFoCdCjAIvE98TmOGtK8g?=
 =?us-ascii?Q?1myLa2ULRzUZmsUgoF6RgibaulBZauM7CJhlEx7IuyS+QNfFpKKh/rp0HyTB?=
 =?us-ascii?Q?LKQbgabRulhSfh7AyL2ryXjn6LEPo0TMHlLOG5HZDePbAnzM53E5JQDEKLzb?=
 =?us-ascii?Q?w4WB+VC0KrvOCVbJTtIYWb2p7xra8qXbbUtgCBMYkmRjJX6ErH2yAZcZF6j+?=
 =?us-ascii?Q?F+qKoOuCkV1G544vWLsvyg8gPjlFCWp+JzAiLBcMMXqkmyV9CATn6pJ+u9Vg?=
 =?us-ascii?Q?SqxJnzFv0CbzFakX6+pZQRUbAfWF1aGb01UfA0f421ltvNNsVoAeRjEKeI9u?=
 =?us-ascii?Q?2l29rCNaviD67UdfaGm8rnz2jxXaSJG17ZFlo5inupgWGeRBjVlNaBtoUy9a?=
 =?us-ascii?Q?Q6ozau3RJRLPL40ffxqRbGK87/oNPwroVNecQSIFImx/XNIO2/lpv45NAGWK?=
 =?us-ascii?Q?N1tJimP2aOxZ6+B3Tair0ubjWxvAITHP/1DipMfDFqWqlFzz3Ln2MpVlooff?=
 =?us-ascii?Q?ym3PwNZXPUugxGLVDknHm9CZPaXVXidZ2taY3dPFkrAvzLNJtxsZuDswE5js?=
 =?us-ascii?Q?X4RG8ah15gar1i2Abv18vMq9VAnrzUUkCz5hV9DxKqSIBib6RZ0u+CDzvrG6?=
 =?us-ascii?Q?AEqe4Oj5mdRKtIzHzt8GrLLDs2w8FKyZfFDPTdAK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e2c054-dc62-4064-0919-08ddf03b3b5d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 07:25:34.8001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NMzaW90RAnT8gDWgwer+gAZJp5we1ewCLm6jcH65GNZxpsGYuI5AIRYHiKonkCV2NQ4yOaeTpuWo01R+cFCp8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5D8CD6E8B
X-OriginatorOrg: intel.com

> void vmx_vm_destroy(struct kvm *kvm)
>@@ -8499,10 +8396,6 @@ __init int vmx_hardware_setup(void)
> 
> 	vmx_set_cpu_caps();
> 
>-	r = alloc_kvm_area();
>-	if (r && nested)
>-		nested_vmx_hardware_unsetup();
>-

There is a "return r" at the end of this function. with the removal
of "r = alloc_kvm_area()", @r may be uninitialized.

> 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
> 
> 	/*
>@@ -8554,7 +8447,7 @@ int __init vmx_init(void)
> 
> 	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_vmx);
> 
>-	if (!kvm_is_vmx_supported())
>+	if (!(cr4_read_shadow() & X86_CR4_VMXE))
> 		return -EOPNOTSUPP;
> 
> 	/*
>diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
>index 916441f5e85c..0eec314b79c2 100644
>--- a/arch/x86/power/cpu.c
>+++ b/arch/x86/power/cpu.c
>@@ -206,11 +206,11 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
> 	/* cr4 was introduced in the Pentium CPU */
> #ifdef CONFIG_X86_32
> 	if (ctxt->cr4)
>-		__write_cr4(ctxt->cr4);
>+		__write_cr4(ctxt->cr4 & ~X86_CR4_VMXE);

any reason to mask off X86_CR4_VMXE here?

I assume before suspend, VMXOFF is executed and CR4.VMXE is cleared. then
ctxt->cr4 here won't have CR4.VMXE set.

> #else
> /* CONFIG X86_64 */
> 	wrmsrq(MSR_EFER, ctxt->efer);
>-	__write_cr4(ctxt->cr4);
>+	__write_cr4(ctxt->cr4 & ~X86_CR4_VMXE);

