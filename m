Return-Path: <kvm+bounces-25522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8999661F7
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:46:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2ACF5B277F0
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4992199FDC;
	Fri, 30 Aug 2024 12:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ln1CMmiB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1446919ABAF;
	Fri, 30 Aug 2024 12:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725021963; cv=fail; b=ay6oNxDg0WrrKSkwvOdvdA4K1ADry3dQIa4SF7azXByKpaPIKlJ6v2DNgXkEOnzdTPv68Q5BZ8ifUP/eeZKP5vYTpZazvvfZQjherZmpU2VSWg2DMvegSCUkr51t5ArC6jB0lead/1B4LIUGkp9Yj6JTbmXPFRySsFUEsOyhwSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725021963; c=relaxed/simple;
	bh=0TkwP5K43tVUsroFTsZ4cTGwwKvzemrrYBGO2u0EaRI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TmXW+tTgVlnSLET5GErQEaero7tR2b8+y271LOGKnfDAVjeT9OZ3wIFzRIcWZwXgbAqwDSu4E+ViR44MAXj3JyD/MT8cJebCU2JmNNWzhkFdlC5BeQDr0Nk3d/YHC8OlV4GZrCDdhEreimw01ujVb8xAG5nTDtrcQ3QDOVp2hSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ln1CMmiB; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725021963; x=1756557963;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0TkwP5K43tVUsroFTsZ4cTGwwKvzemrrYBGO2u0EaRI=;
  b=ln1CMmiBxShoPGiCJNzJLyU/F6fI2IOKaGtsTq4k1uAgDlSBawTJve8g
   BYmqZHz7P4dLcAd2gZE70iVg4gB9oR6/5WMRMNEi/9lp2WO5vrbQEnERT
   fAcZY1yBCTeDtDJKvqz9PAW2FP5MgVWcewkJv65ro+76udJ+alJMBRz+r
   mS/rh9bHJnzk6qclfrIsqeIFj3hy/x0LRbhUgr5Am1BTYG2NSyq7n++9+
   2+coSB5U+lM4G85OcsG+OAgxa/7o1NvXb0i9ihp9vHJ4tuZh3uZhd+JPe
   rJ51uSws3rPe/51HgHPVwnCeg28a8reqr3/GGPkJMToMfJWUvyFbgNIks
   g==;
X-CSE-ConnectionGUID: nd1uXMhiTDu9Ws7Ak5GdMw==
X-CSE-MsgGUID: kjaK32SWQEyLBZu9Vk9hhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34327134"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="34327134"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 05:46:02 -0700
X-CSE-ConnectionGUID: 6OrEAi4PRyGAriM2K0gQpw==
X-CSE-MsgGUID: Bqa51wHQQPSm4iK8O5XBgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="68788511"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 05:46:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 05:46:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 05:46:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 05:46:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BirwhQLoymcak6ogu9cYYQ7PkOr39Bmj/d3uO+szNqf0Yr41s3Tqkq2/hnJa5FvxLk9HY205WeP15oqvp1UPjt2urbAr5y3+h7OxW0JNHa8Cma/yYwh4iLjamszJmet/UzbJbCAFmrzkzNCj5gPMLtEqDZQeqsxrEFWLx5ODrE62K3Vsym32zhBt4i6oTAvVTA91tUbSnwHJTq+bJfFBUZnPccr+DdVK0q4+sjqGuONNvADRv7/kCzFtjFJ94mY0cD0uqkeItbEH7/insix6OBSxwnbU25U2QwKHpJK+E1Eir5CUTNG7XAM1jKV6bskTBOS9WWc2OMRDNTD30OpiZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TkwP5K43tVUsroFTsZ4cTGwwKvzemrrYBGO2u0EaRI=;
 b=X6bYAdBlAWV7aEerX30NOmioWwPJ55z5iDcIrFxLj0aNZM3aYksSmhUS7XssVeAA+GhcPpBndQa5l9nMX0TnRbl4NeT5WoUgJxtJ3h+8bm7y8J5pWZGmwefAlSshAgnPgqKZeu1MfuEmJ9hGanOIjXIzgism/+C3+Zwst323l0L45ApJRX5MSLuu6NlmcGWGYGeuJsV+rlTx4Ke//UTXXOYAfRQBHdnb4AVOMt+h+LyXUGvaHEvukTboUA6cSCe15o3I6etwnH6Zdi9i8L0M9Bn3Tnqhy3qTzznYwL8x9Wcr2K6gqFbw6VeWfOX9U9K+7pM1xj1r7Kv7mjZpxaHxeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5223.namprd11.prod.outlook.com (2603:10b6:208:31a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 12:45:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 12:45:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, "seanjc@google.com"
	<seanjc@google.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "anup@brainfault.org" <anup@brainfault.org>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "Chen, Farrah" <farrah.chen@intel.com>
Subject: Re: [PATCH v4 01/10] KVM: Use dedicated mutex to protect
 kvm_usage_count to avoid deadlock
Thread-Topic: [PATCH v4 01/10] KVM: Use dedicated mutex to protect
 kvm_usage_count to avoid deadlock
Thread-Index: AQHa+pYn1z8lzcM8h0GyjN6+FO8Z/LI/v+kA
Date: Fri, 30 Aug 2024 12:45:53 +0000
Message-ID: <1f037b5604deb5f83f05e709b2edf3063372518f.camel@intel.com>
References: <20240830043600.127750-1-seanjc@google.com>
	 <20240830043600.127750-2-seanjc@google.com>
In-Reply-To: <20240830043600.127750-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5223:EE_
x-ms-office365-filtering-correlation-id: b7f222f1-0ba3-4434-32d2-08dcc8f1af2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dzZGeG00WTcyY1AwOVNqWUM0bDAxaFp4OVcweC9mTzB6OEpxYmsza2xaTVBK?=
 =?utf-8?B?cFUrcWI5K1NtU3Q4UVVmcmtBdWF1R3hpZFJWZGhJbWJLbHpjclF0eDZsT1p4?=
 =?utf-8?B?MjF2OENrVXVneFlYWVpOdDdHcnhRTFJFaitvbmJYM2VpeDNONGVTMnZQejRr?=
 =?utf-8?B?WDR2MDBuL3ZhYjhBMyttMDhRSDhYSHBuN2xxTldNZ2lsbFNZVy94bVNJOTQ2?=
 =?utf-8?B?QUxOYVlheW80ZmhNYWxNYWw0NEJKK0ZmSUd3aXhVVTc1STc4UjF5TllmWXpw?=
 =?utf-8?B?dG5kbTZVUFBBd0hHZjJiZUJUa1I3L2kzWTlXbS9GT1hWNWcwZ3ZsTGZCYkFZ?=
 =?utf-8?B?TVY4b1RWaEo4M2RaTzVYUWU0WUFFekRHcnBXdEdjdnlKZmJWWllLMjA4alVL?=
 =?utf-8?B?TGlubTNBdmc3NlJFM1BEWVlPMjRPTlIzbmtqbzAwck9HaG5waU1vMS92V2NT?=
 =?utf-8?B?ZlBYa3dhWVM1anVXRXV3M3hxcUVqa29CWmdUQmowTVZDMVRtTnNGL040RE0z?=
 =?utf-8?B?SzU5allrN3F3L05jT2xuYkdaWG9GZzZNVStDelFwZ3RsQmZlZmRRRlc5S0lY?=
 =?utf-8?B?dTNNZnJnZTdKQnNkZGZwbGVUeU4zUS93Y0JINkNMbHlCamlQNU5FM2xyNEtt?=
 =?utf-8?B?N1hBNkpNZ3ZNTWw1ekRPTmxNMll5dDJ6djJqc09rbWE1WWMrYUF3RG9KZmEy?=
 =?utf-8?B?NVEzbVJramNKblA1c3BGbFprdHIzaVlhRnZQbWNMdVJDSDQ4ZVo2aGU4L2k0?=
 =?utf-8?B?ZDdiSHllWVk4eTNGTTVJOHVHT1MzQ0FuYWZpc1VvZ01MOWgxMmF2NUdEcGNN?=
 =?utf-8?B?L21qU1AwRk1pUjRydW5qQkNWOEg3ZjJrRmpkUEY2RWlHVkJVQVUyYU1oTHY0?=
 =?utf-8?B?SkhIOVhRMjFnelJhRW5uemxkRHZ4aHhaK1ozUTdGMnpPRzRCSlRzby9uTGt3?=
 =?utf-8?B?YjRMbGJpRXBEWkt2TCszWUdwWnBZbWJKNGN3dXRUejlLYWFvRFhycEx6UG1K?=
 =?utf-8?B?cGhMR2dRMTVuMmQ4SUZMemprZzRja2doK3ozSGdqQUhINm9HbWROdU5kUEZx?=
 =?utf-8?B?VXo0R3MvaDJNOVJHeWZRNTBDNEgxRzRXYlR6OVhvVTBuUGtsOW9mcG5ZTEk3?=
 =?utf-8?B?WkpVN3VWczNqNG9VK09hMmJpRHY3d1U4Yk1neUh1YkFYYTNMR0hGcDFPajMx?=
 =?utf-8?B?YkpXKy9DTi92eis2bDluSElxbCtyYXNrT3dBaWZCdTZiWis2cmdyNWFxZlc0?=
 =?utf-8?B?bS9qMzFjelpOLzllWjQrRVpqZUpSV2ErZzlmSU1nYVVrQ1NPNjdXWUpCdGdi?=
 =?utf-8?B?RjkydWVBZEdYMjZGWmtpOWhqM2ZPQWlHcitxdlYyNzZPQ2dVUE5qM0RBL3BP?=
 =?utf-8?B?aDd2bURwRitOcmVBekR0WEVPYUZrTGk1UGs0Ymo2UUtsQzZzYk5JblVWVUlS?=
 =?utf-8?B?RHQ4dWUxV0JzZitHNDRCdnpkY0IxRWF2em5RS01ZdUFwRFpEekRvT0h1Z2Qw?=
 =?utf-8?B?c2Q4eWd2MEF3eEgxeklmNzc0UCtWSmVMcU9XVkJCWnBvaEtwWkxrMFl0Y2Vn?=
 =?utf-8?B?cEZmTU1VT0FhZUk5bENSSVZKMUtBTUZYY3JZZ3pNQnFzc3lzcjVoY1lJcjFH?=
 =?utf-8?B?K2RpYzhkUTNRSlJ1TVZqdGxqNWozMnpXR2NoWnBXdXFMTnFBOCt1akZrK0J6?=
 =?utf-8?B?VVJiVVJ3MFhMemlBcDJRRFV0aFZDTThzdWkzd1U4eVNBdUtScGMwVk5DSG1z?=
 =?utf-8?B?YnVHeEdZajJKL09vQUVnVjJZR1hyc3ZHUlRBYjdhZ1NDdnhjOGoxYUxqbVBl?=
 =?utf-8?B?WlpIV3JpT1ZpM29Ha3YxWFJDeGJDajQ1bHpjVkRhYlV5Z1RrVnM1WGV0dnMy?=
 =?utf-8?B?VVdRMTZvU2J5Sld0M2V4N1Jpb3ZBWFo5RFVRQjBIMit2cjlKei9TWDdSekxt?=
 =?utf-8?Q?MdrHXPCAgJ4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDFFVWdhNk90UHgzS2lWUVBPRkU4bGloNkxydkl0NGJRYkZ1Q0pUek1ydHQ4?=
 =?utf-8?B?K2FTWWxJMXIvb0lBTGVGOWl0TVhCbXdHVFBuUE82ZWc3VWRqTnI5NjFHdElB?=
 =?utf-8?B?NWE1MUszUUpwRW9ONmZnaVlRNE9KTkE5TURqNFFxRTB1eUJlZ2JIU1RiUUJw?=
 =?utf-8?B?NjBVZWFSTGRPT01aL1pzdE0yeVQ1V0dvZHgwVldNVnhXWXZPYm9QdFk2NlZl?=
 =?utf-8?B?NXQwL1I1cDVRNjVuVHVHU3pMdGpGTmg2MWMvTkFROU8yNkZXQVE3UnVLTHBJ?=
 =?utf-8?B?TGtXODFFQnFhUi9UVE1MRGtqa3B5YnQvaXUzUW0wRmpYbVNCT1ZVODBjRS9t?=
 =?utf-8?B?T1BNd25sZjVIc2s0WU52d2hyenhmVWh4ZWRIb3ZJdzQ4NDk1MGNCVzY2b2pM?=
 =?utf-8?B?b09rQzV2YnpWM1M4djNXR2lhbXVxNDh3d2FWbVlxcmdQZ2paTUVvWktSN2w0?=
 =?utf-8?B?V3cxQ00rZ0IvSmpBUVFWR2psL1BzUlkvM3BGYk9oZnVhdCtPMU5JWHBxUHlr?=
 =?utf-8?B?RVNjcFU4WnRBT0VBSTBnU1VFOTZaVThBKzY4OFhlTXNqQVVtQngxeVNCZFJT?=
 =?utf-8?B?Uk9uMHAvQTdBNklWSG1KSFI3ZlVFZW9iOUsrWnlSdjdKREFCZXpvdmRUaFNG?=
 =?utf-8?B?MisydjFDWHVBZUtPUWtLZWRYL0FZVkFxWk1LOExkdHpzTXZ0Z2lGWE5mSVJ2?=
 =?utf-8?B?OGZoZkVjNERENXNkRjFndTcrSFl5ZVJkVzMvcTl3UGNZajNTcVE1ZThLMGFY?=
 =?utf-8?B?MXBNNkcwdnJyK2ZDMFVVYjQ3RElLc2RRWFZKMFo1MG9oN2lsdXNUNVB5YlFr?=
 =?utf-8?B?NWZjeUtqTlJNNFlmbUxpRm1lSEdtZmJLTThGTVRuZ3lVRWo5czNhMGQ0QUox?=
 =?utf-8?B?eXNKY3FwM3ZhZ0pTaXlkdXJLYW5sUkYrYldoQzBKYXpGckdSV3I3U3I4YzJ3?=
 =?utf-8?B?SmhrN2swa1RVN2M5aW52YXA2bFd6enZTSC9Jcnl1RmZxZzB2MnlZMkdNb1Nr?=
 =?utf-8?B?dTBDdGlIZlZHZ2hSaGRNTlpOdk1VNEoweHVoWnc4cXc5bWw0ckErSS9jNEU3?=
 =?utf-8?B?QndESTVGMU4yV2RxRnd5a1oxMnA4S01iN3hoR1gwWGk5cXE0b3FiaDRzc1Fs?=
 =?utf-8?B?NVlkZFpQbjBjN2ZKMlZxS2JnMkRlMUFUMmVrOGVGNE1XQWpOSjgyZURSK1lD?=
 =?utf-8?B?VUl4RGtqSFowT09JK1drcWlJc3JDRS9SSTdwdnpCNU5TbjJScEtXUmx2ZHh0?=
 =?utf-8?B?MGlveDVVSGUxZ3ZKLzVEYlNwa3MyVGlsdWVONHVjdndXaGVLUjVIRWt4RkFP?=
 =?utf-8?B?MlJTc204RXBzUzVwTHRQbkZBTGthT1lFcElhY0k4b1RwaEcwcStqbTI5SC9o?=
 =?utf-8?B?S296cEIzbThQQVB2eTM2S3hlWWVBNW1yTDdlK0xtODBRaWExRGJWOUtERFFv?=
 =?utf-8?B?eWl5cm1WNWQydUd3WjFEYUY3a2NzR2hZZGdKMDdPTTl3b3RSU20wYVVCUERp?=
 =?utf-8?B?Z1NwdEVBa3hkSzhReU9NOHpZRGRMYVA4NWZDOGpqakNpYXNHV0w4QUgvc0Za?=
 =?utf-8?B?V1ZJajNUTHI0SnY2SEF3WGZWd2NJT29ETkhkZ0hlcDIwQ2p4K2FvMjh5cTNT?=
 =?utf-8?B?T1gyVHZEWVJ6MTdXd2U2SXRZbmhEQXpDT3BpTDJDaW1pcnlCdkVyVGhUbFU2?=
 =?utf-8?B?bzlvb3Q3MlBNSXQ2Vmp0V0l1bjhQTUVia0YrZDNmd0R2amVyVFBWMVJHOTBa?=
 =?utf-8?B?V3RIRG5Ed21oNGNBSmttVnJrT2N2dlgvR2FSQndEQW5tTjRRclZOaFlaZDdH?=
 =?utf-8?B?Z1lPd1NEZDUyYVBNcUJuUmpwVWllVkNnMVkrd0c1K2RjK3lrcGt4WGRaUE9w?=
 =?utf-8?B?ODFHNHNsWGVJMTMxZFpEMmh0MEVhS1pTc2YrNEZxMFRWSGpyM2dGby9VcFlz?=
 =?utf-8?B?ZkM5TUxkdjBjbE4vbE94YTBoSWkrYVR1bjk5aERSMHk5VHpqMlM3NVZKR3Zl?=
 =?utf-8?B?b1JaRmM2SG14UEM4dm1RMWRCNUxtSjJWRWdCWkduMTQrL1p3cm1HbUJleStV?=
 =?utf-8?B?U3hCTTk2M0JzczFLdlhGR2NiKzRQRmxoc2w1S20vcnhWeTk1dW5XY0xkcDdp?=
 =?utf-8?Q?5zahf/pjnV/DcSDghk2+3K0Bh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A20409BF6CFF247BE0B77060706857F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f222f1-0ba3-4434-32d2-08dcc8f1af2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 12:45:53.1150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JCsswfET9abhfuElP1MM+Pt0OwxBNd71JHspDWKvWdedxPRFaVBAigQTQc7EjEdExXxVTfCfwsbrvwNzrn1cLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5223
X-OriginatorOrg: intel.com

DQo+IFJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IEFja2Vk
LWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IA0KDQpIbW0gSSBtdXN0IGhh
dmUgZG9uZSBhIGxvdCBmb3IgbWUgdG8gcmVjZWl2ZSB0d28gY3JlZGl0cyAoYW5kIGZvciBtb3N0
IHBhdGNoZXMNCmluIHRoaXMgc2VyaWVzKSA6LSkNCg0KSSB0aGluayBvbmUgUmV2aWV3ZWQtYnkg
dGFnIGlzIGdvb2QgZW5vdWdoIDotKQ0KDQo=

