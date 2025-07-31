Return-Path: <kvm+bounces-53768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B4A7B16B0B
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 06:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0102F3B2315
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 04:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3053123F292;
	Thu, 31 Jul 2025 04:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MO9oa+bm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D2D1FAC48;
	Thu, 31 Jul 2025 04:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753935045; cv=fail; b=s4gblBHgRkZiC4Ji1bvOoMjb/0cr8nRwyCnvO4CT2ZXC92Mu7w4aNcoaj/GJ1/UTTcR5KlVo/tEUT7spYX61KoxApdPeTmWTyZa8a+FLdYU+aPha55J24Fftcu+tYsMF+qAejjLgtig5Tpi5K+/OQN40dLAXVcFpSt2ZVyd9ZiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753935045; c=relaxed/simple;
	bh=y8f0WMyXgGQdbcLQXJ8nN55K0jrQzhuMGXnqkmekHWo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YbkaJIRPE/90IsR1D4xl1Ot2uKIWz4McjhH1rGUC+BytPCm6+19meQE0F1ZKRYOCPxVXey/UcVGofct2vHtLvzLw05NDZF3twVqpLl1H7At2Q9TQoveJH3jz5zyWr+HAsAL2iBqQ/E9xR3VzLHdslw2nnC7VCYCPQ0NE/PnY/vo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MO9oa+bm; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753935043; x=1785471043;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=y8f0WMyXgGQdbcLQXJ8nN55K0jrQzhuMGXnqkmekHWo=;
  b=MO9oa+bmDPNmqJQ7gtTBkjU/bNtW//X0Vd8ivrHrZcVDihwxkkAc3nM1
   4Dfs9DFAIb/Rnt44YDdwljaE529HsOEpmx0p8s18RaOfYB4GutT46vlfu
   d6NszSE47qm22yBWzBKVExC1NXsAJIysDrHglujNdIwGgywSKCRySXNLI
   T+sy7X2keMBVH3nZdhYXr8tNbucu+xD6yUEfXqGOm3tuh7FtzsxQ+mjGo
   F9+6DtzLyI91U/SWGo/TtYL2tI3l2i54DIRiZpEPONAZw/a36GlrHlh2f
   6XFFjk9l2ZHFwoFZLpGj/oSOSytcTPu6cn9gI5dI0z5N3Yq21pURwdZrc
   A==;
X-CSE-ConnectionGUID: K3ScL67sT5maFNfWdbJQVA==
X-CSE-MsgGUID: 23tVA6F6QbSeeXmUxiZ15g==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="67328197"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="67328197"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 21:10:43 -0700
X-CSE-ConnectionGUID: QfLJ6MjsSPq6km2KSu+iQQ==
X-CSE-MsgGUID: T67AOcCmSmeQbpDNHPlk/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="200320688"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 21:10:34 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 21:10:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 30 Jul 2025 21:10:24 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.87)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 21:10:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YTKCBoI+jO0vVeOEGEBE6qpM6LzjDwfXrN9wsN3141RvIqPy8oD0vj2pmmmleOdPSTX46AQ1nt0p7YRikp1nPHq31Q1cPLk5F3ktmeHbHZEChvkdlsoYgrnu4sm6Rk4X6rhX5wuTfvZCnAiDpIJCRQ+N5Q/R8jOriZcsTqnOWbbjLWyT3yPnb3TvehUikzJdga5/sEIVY7+Y8JbKjYMvu8VD433RY5V1g+tpKWbH+FuuGyHze0R4OuIzABqqYaiLuYwR0nTVWVhUl3M2bpv+z6dg/T/8YJzqLejZmSQp8UM/9yiCRn2MPF8S8fHiuAP8CaVkwGoZCZ/ZUyio3OZ9CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8f0WMyXgGQdbcLQXJ8nN55K0jrQzhuMGXnqkmekHWo=;
 b=wteu7QG132TgV4jvUEgZBfWo4Shwl2NuP46tKnMIzEdcX8nooteGtyxeM/h9BM1uZMSJmbbSOuF1s0/ZVe80yeWcYHPl3hAYfA8FyuSDV3ceaSTD3CwziAxQL9cBkBa8KOHjUkNdjCTdrwC+2AdC+ia5O7FdjRfY+oaWXEy83+olnwhyH57+FQoyaqToA7xDggjIlsErvh5evOJeu/khbc4KvgNmQX3lDl3SK+SP7mwQufNEwVrsLEicWajOZLZEa08fDhN311b6UX5twqxyp36pkDGOt/CN8kHE77lIanUjWdH18v+58DnSJupJUQElg8mR3vwwKcu7346bDlY7qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by LV4PR11MB9466.namprd11.prod.outlook.com (2603:10b6:408:2e3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 04:10:22 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.8964.023; Thu, 31 Jul 2025
 04:10:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 02/12] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCHv2 02/12] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHb2XKqHP8h0XH8IUWO9sF+JPLhmrQURMoAgDd3BoCAADNWgA==
Date: Thu, 31 Jul 2025 04:10:22 +0000
Message-ID: <8c1b4aeaf404d3f034bd27eb514972c9867ac490.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
		 <20250609191340.2051741-3-kirill.shutemov@linux.intel.com>
		 <c3f77974-f1d6-4a22-bd1d-2678427a9fb1@intel.com>
	 <3b2d90dc8ae619c5d9372d6c5e22c47aeea1ef0b.camel@intel.com>
In-Reply-To: <3b2d90dc8ae619c5d9372d6c5e22c47aeea1ef0b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|LV4PR11MB9466:EE_
x-ms-office365-filtering-correlation-id: 49f278f6-9caf-47a3-873a-08ddcfe82b3c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aUY5cS9GUFZCeDNDVVA2RTZJKzN5eXh2SVVXdmIzeUsxZTNNanp1KzlsZnBT?=
 =?utf-8?B?YXNGaXUwZk8zbGpIckYxc1RlempNeU8zYzZXNHB0d0IxR3BsZG5Yb3BOQ2p0?=
 =?utf-8?B?TXBQVTZOV3NhaHNWNjlwMlN2ZVlCQmx5OUVQK1J4Q3A2b0Z0SXhxR2VKVVNW?=
 =?utf-8?B?cTlzTGZCeHRqU2hOdTBzZHhRUmszeXVIS1dkZGZReE8xRVExelhXRFdjbVZq?=
 =?utf-8?B?RHBlUjdqdnF6ZlVHT1pkMEFpVHJuS1NoMVZPS3JMdmVNNEIyVEx3U0d6c1hJ?=
 =?utf-8?B?bXN4YXNoTU53Skxrd1ZOaURnUkJuR0tmc3FzeVJYYjcwUEVad3BKL3hOcU9q?=
 =?utf-8?B?dndqRjhudDhTamp3VVUwV2d0VE95M0R6WlFBWEZlOUdZbkNsMjR4dVRsSENT?=
 =?utf-8?B?d3NUU0Z6VjRLelJWOUx3R2pWRnNaamNWY1JEeFV2aFErM0VJbWJoL1docnYx?=
 =?utf-8?B?dkMzeGo2Mk9sUVdqekU4RnN0TGNPLzlwZ2JmS0JNYlR2RGgzQ1hiUGdFc2E3?=
 =?utf-8?B?VmJxZjZ4c2tKL1g5enJjOXp4dzQvbjNobisyYUJlVS9hQVZQVUhVVEFzZjRR?=
 =?utf-8?B?RFM2VThnMWFHOWlJdDJFT3p3UXp6SU1XNDNkWlZBL2ZDcW02OWhmTGhadEdw?=
 =?utf-8?B?aHRWcTFsa2JQM3ljL1RPS3d0emdTeW5objJBRVN2emo2WldGblVza2lPMkhu?=
 =?utf-8?B?L0FUNzFxMWs0eWlMb25wNzZra253TU95M3pmQVJRZHkzTWVQN1pNTUJGRTNq?=
 =?utf-8?B?NFZ1cHo4ZkJFNWNDYUM3azZGYXl1enJRRW0zWHl3SzNPS0pwL1FXb3V4c09R?=
 =?utf-8?B?ZEhyckRxcmplUnFWQkJnSHcrd3NjN2hraDNSUktCZldLc3JqYTAzUjM0TnMx?=
 =?utf-8?B?eC9sV1NFMDRtWVcvN0tPL2ZPYVFmRVVvdmZ2L2x0WWVPaUxBUUdsdnp1K0Q5?=
 =?utf-8?B?SzNxbDFQbFpzVkVPcDY0VGp0VldzNmlTSVh2Qmh2cHd0cG03Tk9sK3llNHJ3?=
 =?utf-8?B?aGc5N1IvaUE1ZEVIWkVta1NBZWdwVlJVZmlvakJKenhPRGNzenRxdzZNTDFz?=
 =?utf-8?B?Z3lBME5RUFJzdEYwcnZNYVd1K2dsK3h6bmlSK3BhSWFjMEI4YjR2a2FLQ2lz?=
 =?utf-8?B?RWpCbGkxTEFQdjhISER6UDVhZlJ5OXdUNld1YnJZQml4cFpaVFllakNkb21r?=
 =?utf-8?B?WEI5RzN1YnA3a3RhQ0Q4eCtwQ1czQkxiWDNWaDNyR2xST0J4dCthUi9MRnZ6?=
 =?utf-8?B?VXZvQ2lTRVZjNFZNS08wVjlGMFpsSGFZaEtYbDdzMFliQ2dqejNaN2t4dGlQ?=
 =?utf-8?B?d3pESnlFVUp6ZDZSYWg3MzNLUWExaExNNEdoQWI2VG5NTWN2NEZVSnRRejE0?=
 =?utf-8?B?czRLamNlMFRyY3BDVkhCQWk0Y0NxZytzUHBhM0NZWTJ5RWNCTzNKQ0ZBbFQr?=
 =?utf-8?B?QUtSeGVQbzN1M2o5citHVklhdkVNNjA4VUdHT3ZlTTBwODFaUVY3eXdqczhW?=
 =?utf-8?B?bVNZbWE0NWZycjdndDBZR1ZKbGdSWjZFR3ROWlFmOWo5c1FJRWtlY24yNUI5?=
 =?utf-8?B?bzQyWHdoaDYwOHNObStTaDh3WlgzdHFiQVlnQW1wS2JnVGxMY0xwWWVabzY3?=
 =?utf-8?B?Tlp4TDVNSDJoRjFCbHFSYkxxSzN5SGM1dHlFWXdlckhZQW5tOVZWTmlZNUt4?=
 =?utf-8?B?eUV4djErbU5zKzEzd3didjhpaGtteUU3SSs3RVQ0MGpaeVYyMUdHVzlLTWVQ?=
 =?utf-8?B?c0kwcXA2WCtKcFVJK2JtRUREd1dmZ2ZQYmFyU1pPRGJOVlQ1bnd2empLRDYv?=
 =?utf-8?B?OTJJYUFtRHUwOEZUaUhpNS8wM001QlZjQStFM2JieFB2aU16NmVPQ3Q0T1lW?=
 =?utf-8?B?MmdNTUs0bWdYcFBIN0JmYUQwNm1IT0tORVVVMjY0Z3VYNzdpckFmUVZabGlw?=
 =?utf-8?B?Nk82T1A1ZE90R3lHc0RRcFdySFpjbHF5NTI5bTRZbWMyY1U2dFhkYUFpZEp3?=
 =?utf-8?Q?OQVzwalo6oFHUT3liMDSfcQPaU4eCY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTJKRDd6ZnZzZENsMzl5QU85R3lOUldhQXRUYXZHLzJqY2R2dUNsOVQxZDVl?=
 =?utf-8?B?L3pYK1hNR084aEQ1YnhkUmVYRGR2SGZ5ZlBBaFl5YkZ5eVlzOHlETENBR3Rm?=
 =?utf-8?B?ZERobnArRVk3LzlJZjRPZHhPQzNsbTM0TnRsU3BMdGFsTlc0ckFadnNyVk03?=
 =?utf-8?B?NklINURqT01udE84R3VheE8yVm81VlBXdHB5Wmh0QTU4MTVZOE5rdmNqT2tv?=
 =?utf-8?B?VmVRa2Z1Z29DY2orSzJyd3dmZFd2aFNaN2VZZnkvdUxsbnhwVWx0NUd2Q1lo?=
 =?utf-8?B?YUkrZVBxNmdXZkRmdlU2Q2FlWWpML2trSlVxYWZ1algrUzYwbTZzRmZJZ3F6?=
 =?utf-8?B?K3VIN1RvbHI4Mm5CNlhkWDlHRjJoWGE2bG1vc1UwMk1HcDZxNEdwS29teVdu?=
 =?utf-8?B?U3g1WStIUm4xVytoeTNvcC9jVUhoM2xqbVorM1dpbjZCbEl1ZUR1M3JkZk1K?=
 =?utf-8?B?bmJLWFNRVHpsWVpidUxsUzlNOU81bW1hblRHUytQSDRmSVRia1YzS1RFUkpU?=
 =?utf-8?B?aXJYbWNpNllVSURxTWxsNURtWG5JNCtwUFhUdDdUY3hQV0NQa0lOZmVWTTJr?=
 =?utf-8?B?SGt3UkRmRzdVdXNPYm5rL2hpdG4wc1hxdTlIMk43RXJhOWJyWHRUazZaYUJF?=
 =?utf-8?B?TDdJRVQ3ZFNMNUpVUmIvVzlaQlk3OWE2YS8wdXBhNkJ2Y1JHVFVnK3hKTERW?=
 =?utf-8?B?eTRFclFTQ2xVUjIySWdvWXgxM002bUJHMTN3TTNIOHBuWEYzaXlIMkN2dkRm?=
 =?utf-8?B?N1dnZzJ2MnNmVjBkcWFQcTNOSm9yU3lQMTZsb3dxT3BlQkZ4RFNDQnZuOU50?=
 =?utf-8?B?TUJyYmNQV2RISVZkUG5NTU1FaXJCc2xMYS9XeE0yUVZmTFd1aVEzNHozSU5D?=
 =?utf-8?B?dXRSVG1nbHpCVHdHQWpVbE5QYnB1cldsUzVyc24vbGFKRHlpZUpoTzc3ZFUw?=
 =?utf-8?B?a20zcCtkdWozaGlYN1V4ZjZXb0lldFFXSzM5aGJ2TWhuamxJM2RYVTZGa2hZ?=
 =?utf-8?B?T2pWUlY0VWJnRUpwWE9KOU5oeVNtdE5jeUtpS0MzZGJ2NUFoRWlDdGw4SDhD?=
 =?utf-8?B?V3B4Q1c1eWpwZW0welhrT0l2N2t0Z3Zublh4OGM2ZWJFYVdMbzc0ZUtzN2sy?=
 =?utf-8?B?ZXkyMU5DeDc1TjJmWDUvb1FOZEpVREtyWFZYZEpaQ0hvWjM1SzBEeW12WVNw?=
 =?utf-8?B?MDhOVFdaMlJycmFNS0RxbFJPY3lvSGJjSFlQN3pVUHIwU3BveVg3cHlMTExS?=
 =?utf-8?B?b0pBWVhzV0ZaMDdBQ29MaUpIZktPeFZIdXQvek40NGJyZkZzUXc4a1VrVFNG?=
 =?utf-8?B?Q2E0eGVQZGdZT2FLWjc1SXhqRUl6Q0Q5eWErSVhoSTFWVEg5VDlQTGUwaWF0?=
 =?utf-8?B?TGc2dHIwTjVJam1WcmU3Rm1UT2Fsc2N2RHRBQURiUng4ZEZmdkNvVVdIOUJi?=
 =?utf-8?B?bENKM2lISUlMMTJ1V2pZSksrM1lUSFhkcjFHd21yLytMa0dyQng3VEkzOVBz?=
 =?utf-8?B?Mk1FUk5iaXlZbml5OVpQeXdFT0NlWU14dGxlUFVpVVJQTWNvMG94d0E2UzN2?=
 =?utf-8?B?K1ZDZGpSRzZiVU5VK3V1Wkw2QXIwNU9CeWtTSzJMNFlqRDdMNFcyQUlkUyti?=
 =?utf-8?B?TmhCSW1CdmRZQjNMbEpyNVhLU2kwVjJSWGdGMUZoUXJwdEQ0bzc3KzVaR3Zv?=
 =?utf-8?B?QkZ6YWpNVUgvWWYxRWdjcWIzMmJaeHdlSzM2QWswdW1UQjhRMitUZjdoTUhu?=
 =?utf-8?B?OUQrNTE2Q1hFdHFGajNMekN4R1Zzd096QkFNOXVJT2xtWnNCMXZ6dG1BUzZL?=
 =?utf-8?B?SjRPMVJVTjJRQ25uM2E2MmRZMTNCb0JIcFVZOXNrVHBLMHlnSFF5dXdTMDcr?=
 =?utf-8?B?U0Vqb3IzeThsWFgzNFd3em0wdm5meUVFRmtmMTZtRHBmQks5N251TmZyUzBN?=
 =?utf-8?B?Rmk5NGg2TTJ6RHVTWUVwMUNIb3dUbWlacmwvWHZpMUNFM1RIclhBTU9DZlNP?=
 =?utf-8?B?TjdIYVVOdmFQUzAyb0t2c0RMR3Z2QVpXY0Z0VGlSOC91WFJPWmtvR2g2VUFJ?=
 =?utf-8?B?dmNUTStNVUFEa3ZFQlhkNXo5TnpmVDQwR0hQcDl0ZVhPRnhTTEVDZC9DOXZu?=
 =?utf-8?Q?S4TGJNoWtc/6PciYrM7BeKp6v?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4AA1B21F2B43448B582AA02307C7387@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f278f6-9caf-47a3-873a-08ddcfe82b3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2025 04:10:22.1125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uvEeBgSjCfIVuWJZ0nAKf/svmTQBW+wuNpZT5MmSCjwkwlwu6ce1ZJaCnzhbtniz61Ig7H7Wn6UvFnFEwKHEXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PR11MB9466
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTMxIGF0IDAxOjA2ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gV2VkLCAyMDI1LTA2LTI1IGF0IDExOjA2IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90
ZToNCj4gPiBUaGlzIGlzIHRoZSB3cm9uZyBwbGFjZSB0byBkbyB0aGlzLg0KPiA+IA0KPiA+IEhp
ZGUgaXQgaW4gdGRtcl9nZXRfcGFtdF9zeigpLiBEb24ndCBpbmplY3QgaXQgaW4gdGhlIG1haW4g
Y29kZSBmbG93DQo+ID4gaGVyZSBhbmQgY29tcGxpY2F0ZSB0aGUgZm9yIGxvb3AuDQo+IA0KPiBJ
J20gZmluZGluZyB0aGlzIHRkbXJfZ2V0X3BhbXRfc3ooKSBtYXliZSB0b28gc3RyYW5nZSB0byBi
dWlsZCBvbiB0b3Agb2YuIA0KPiBJdCBpdGVyYXRlcyB0aHJvdWdoIHRoZXNlIHNwZWNpYWwgVERY
IHBhZ2Ugc2l6ZXMgb25jZSwgYW5kIGNhbGxzIGludG8gDQo+IHRkbXJfZ2V0X3BhbXRfc3ooKSBm
b3IgZWFjaCwgd2hpY2ggaW4gdHVybiBoYXMgYSBjYXNlIHN0YXRlbWVudCBmb3IgZWFjaCANCj4g
aW5kZXguIFNvIHRoZSBsb29wIGRvZXNuJ3QgYWRkIG11Y2ggLSBlYWNoIGluZGV4IHN0aWxsIGhh
cyBpdHMgb3duIGxpbmUgDQo+IG9mIGNvZGUgaW5zaWRlIHRkbXJfZ2V0X3BhbXRfc3ooKS4gQW5k
IHRoZW4gZGVzcGl0ZSBwcmVwcGluZyB0aGUgYmFzZS9zaXplIA0KPiBpbiBhbiBhcnJheSB2aWEg
dGhlIGxvb3AsIGl0IGhhcyB0byBiZSBwYWNrZWQgbWFudWFsbHkgYXQgdGhlIGVuZCBmb3IgZWFj
aCANCj4gaW5kZXguIFNvIEknbSBub3Qgc3VyZSBpZiB0aGUgZ2VuZXJhbCB3aXNkb20gb2YgZG9p
bmcgdGhpbmdzIGluIGEgc2luZ2xlIHdheSANCj4gaXMgcmVhbGx5IGFkZGluZyBtdWNoIGhlcmUu
DQo+IA0KPiBJJ20gd29uZGVyaW5nIGlmIHNvbWV0aGluZyBsaWtlIHRoZSBiZWxvdyBtaWdodCBi
ZSBhIGJldHRlciBiYXNlIHRvIGJ1aWxkIA0KPiBvbi4gRm9yIGRwYW10IHRoZSAidGRtci0+cGFt
dF80a19zaXplID0iIGxpbmUgY291bGQganVzdCBicmFuY2ggb24gDQo+IHRkeF9zdXBwb3J0c19k
eW5hbWljX3BhbXQoKS4gQW55IHRob3VnaHRzIG9uIGl0IGFzIGFuIGFsdGVybmF0aXZlIHRvIHRo
ZSANCj4gc3VnZ2VzdGlvbiB0byBhZGQgdGhlIGRwYW10IGxvZ2ljIHRvIHRkbXJfZ2V0X3BhbXRf
c3ooKT8NCg0KVGhlIGNvZGUgY2hhbmdlIExHVE0sIGFsYmVpdCBJIGFtIG5vdCBzdXJlIHdoZXRo
ZXIgaXQgaXMgZGVmaW5pdGVseQ0KYmV0dGVyLg0KDQpGb3Igd2hlcmUgdG8gYWRkIGR5bmFtaWMg
UEFNVCBsb2dpYywgSSB0aGluayBpdCdzIHJlYXNvbmFibGUgdG8gcHV0IHN1Y2gNCmxvZ2ljIGlu
dG8gdGRtcl9nZXRfcGFtdF9zeigpIGJlY2F1c2UgaXQgY2hhbmdlcyB0aGUgYW1vdW50IG9mIG1l
bW9yeSB0aGF0DQp3ZSBuZWVkIHRvIGFsbG9jYXRlIGZvciA0SyBwYWdlIHNpemUuICBJZiB3ZSBk
byBkeW5hbWljIFBBTVQgbG9naWMgYXQNCmhpZ2hlciBsZXZlbCwgdGhlIGNvZGUgbG9naWMgaW4g
dGRtcl9nZXRfcGFtdF9zeigpIHRvIGNhbGN1bGF0ZSBQQU1UIHNpemUNCmZvciA0SyBwYWdlIHdp
bGwgbm90IGJlIGFjY3VyYXRlLCBpLmUuLCBpdCBpcyBvbmx5IGNvcnJlY3Qgdy9vIGR5bmFtaWMN
ClBBTVQuDQo=

