Return-Path: <kvm+bounces-23937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B487594FD28
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 07:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D02261C2274B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 05:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6582A249F5;
	Tue, 13 Aug 2024 05:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bTI2PCIP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6222823B0;
	Tue, 13 Aug 2024 05:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723526554; cv=fail; b=NksXUcaiZi58EFW2VCHyHKg0jQKY+TVYNrg9Sc0HCqGf1Q2V1sCK7dpL6rXG0KVQhhj3PjpthjPuXGNE7tR1IxrfykIyidVQ48sw0pxKggMBJFukipSNXmO+yUOXM8gmqmo7YeJISLzUmcRk+FcLmI+wgm52jR7JCe2MeuUxKv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723526554; c=relaxed/simple;
	bh=GUvJ6JmVc5wLSb5dN9WHovHhA2+m6ZIQpj4FaauZ8Yg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T33Xf/vU29OrBCEZ7RcObffSNZUw1prOFosVLnXitfNnDzqHDKCAAnD3gikjfBI960vGt6vne7rWiOSmAI3z0RaACLzvMY3RFWWTJblzBb9XvnDqHYhGAVR9XpEWb/8d2/arYnTjfzhOL7g2zFq2ROAVKgxwpflG1Ws76cXwGjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bTI2PCIP; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723526552; x=1755062552;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GUvJ6JmVc5wLSb5dN9WHovHhA2+m6ZIQpj4FaauZ8Yg=;
  b=bTI2PCIPj/eroM9CRrOzbxUX6DT+UdtBzOOazRYqs67zPABdIEUHqTqV
   l5LAOW4SRVN9xYFAcDm2sQg7eqDIJTMsA9pezR1hcRNKqbTFr5ly53cxL
   hGdO1dCn3S5FTx0kQmGDlmS98Mcg0Dz9vyciQHe/xBy0Y7WF4dltsUcc0
   y5mdMs2LLXuXI1ykftT/zKiS6NlO/jzVDKZyGMh8Y6r8F1R+sKOKaBLHE
   M4hCw85Jc0wrvHIAhMbMnqolLkyusay4y6xGulQlZibjuxnjMIn1acJSa
   uSUhS7EjixK8NknlAeeRi3qUmZVAVlHqKOB9bwmORcQ56wDMGEvRPiETr
   A==;
X-CSE-ConnectionGUID: o+8mMGtqR1WdkUMJxJx2Wg==
X-CSE-MsgGUID: 5hQwSXKoQ4ejsdL+j0yTfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="24575520"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="24575520"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 22:22:31 -0700
X-CSE-ConnectionGUID: B0ppbxvyTMakKwkIFhw3tA==
X-CSE-MsgGUID: JvVZWyZ6S7iOCbEcOWR4Mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="59107105"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Aug 2024 22:22:31 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 22:22:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 12 Aug 2024 22:22:31 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 12 Aug 2024 22:22:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aX2Unw5bRqpvQFcSjXUtJvmkdCVMDn14gu1CYbENxbdvE1FoqITE4dcKOqqaTYWokSH0rKWMDkUiiJaRA7NXVyqMZRoqQGpGYw4eh3SSwOqfD04G0whsx/cZbeuHqECBcciDFXbJvC2UhnpuTWObxB18466myf24v3z1cU2PJ9kl+0rjST+3N0WSOcGitIMRRbLCPimySTLyGHhAB4DWc8JKmTUsOPzZMPixINGIJJ3f8xildgJnlA6y1ZorW7bAtt4/z9L+WAtCLUFvCTGu4Zu0pid+1ETYAXF2UKIOpfrYiKESrgz6ftrucwFKneNOL0+lz3g7Qeu1OMTQu2W06w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GUvJ6JmVc5wLSb5dN9WHovHhA2+m6ZIQpj4FaauZ8Yg=;
 b=RSGfz2JnjvT5IyMz6pEfyO5CYHyjfzs63VjGcXXAwbeO+B8lsHi5nFOUmAThDTsXDSpgx+zpK/Hd5K8mOhQ1Jnkh3rrrBGl8LLwgLTFyai8UckDS0ZvU1eaOt/Pnin/+OVB+hRr7GZVgZJ/KyUMFEUkftH7sbX2z0tYO6Vl+MXtLP91Dc6HJNWCCXMguq2ixaEE4YbadepwYEReNaWKxwdwfjWbze3hjnO7QNcz3L2ZLWYuDSByHNRSXnyTSqfIVKOZnkST/WiXLv2hZcVzDmKMb54od/BMBxd1XL5BTLwa5Vw4ydy2PrXdjN6cM0AKm3+hxM0kgW+HTlr5slqATrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7801.namprd11.prod.outlook.com (2603:10b6:8:f2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30; Tue, 13 Aug
 2024 05:22:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 05:22:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v3 4/8] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Thread-Topic: [PATCH v3 4/8] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Thread-Index: AQHauTfPMFWPSBOIHEiZJ+sXeeXGULIUNR6AgBCqPwCAAC/DgA==
Date: Tue, 13 Aug 2024 05:22:28 +0000
Message-ID: <c3205ac001776585d2a1fd14ebfec631d8ff7d3a.camel@intel.com>
References: <20240608000639.3295768-1-seanjc@google.com>
	 <20240608000639.3295768-5-seanjc@google.com>
	 <7e12a22947bdaf7fb4693000c5dbcf24a20e6326.camel@intel.com>
	 <ZrrFgBmoywk7eZYC@google.com>
In-Reply-To: <ZrrFgBmoywk7eZYC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7801:EE_
x-ms-office365-filtering-correlation-id: 341fef94-413e-435a-e8b4-08dcbb57ec81
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MnI5MFIwOUlZT3hpRDFmMkRqWUtDb0VIQVJNU0RoRWg0Y1dncDR4KzZGZ25E?=
 =?utf-8?B?eGVRL0hTbjVubG9kMzdlTFg5WE5DYzFTYmF3UnVESFVEeVVHaFZ3Nks4dHNu?=
 =?utf-8?B?SjFrK2lkbjJjZWtOV1JQaDFpMjhHMUZzK0tKUFRUYmZ6cE9hdTRGcXd5dUFG?=
 =?utf-8?B?aDRWa0FKWmhWRFBYZ3AzVzBKc2Z3bkJHQWZZU0JzYTRlN1Z5ZVBsSGZjMDVx?=
 =?utf-8?B?MEFzYkhkUkdaTngyUUFBTUl3WkVGVmNmYkhhNExmTzJXZEhvRTFVVzloREY3?=
 =?utf-8?B?V0dRVFFBcGhXb2hVd09OUWRNamN3b0RXRXhNMnlwNkRPbVVOZUpVTTUrRXlN?=
 =?utf-8?B?K01BbzdmZ3R3d2xzRnVzOG5aWUE0WmV0VHZWQkxmRkE4eHk4QzhsaU96aytk?=
 =?utf-8?B?ZVBjUWI1UGFGb3JvVDNqUk9GVWJYQyt5T09WR1BycUdpSUVzZmhxZ3NXUW16?=
 =?utf-8?B?K1lKcVczY0hSQ0VWbGJza0F4Y2VzM1BqcWZzdWdlMnVOeUMzaDBpcHQzK0lE?=
 =?utf-8?B?VDExbU1VK3ZsbmY1UjJoSWpmZTV3eDBVQjZ5Q2tvTTJrTVMzdko0UG9pL0wr?=
 =?utf-8?B?NFh1dytlZFRpOHZJWmVFSWtScGRzbmZyZjBJSFNtaS9uaEpEdzBmM21ZS1Fl?=
 =?utf-8?B?REZsZ0N2MC9qWXJrQnhEbDZpUmVwdVRlU3hOand6ckJzeUpjSENnVEl0dlpD?=
 =?utf-8?B?OExES1ZFRHV3SEM3LzhYcWpYTWwzSjc3c0J0dVZ6MHJuT2lHQ0FoWWQrRWs1?=
 =?utf-8?B?ekRieWE2NFVLb2NBck9iYlVOY3JGVWg5dUVXSjgrMi9IWG5LeUtaUDlaWXho?=
 =?utf-8?B?OTNZMEt5aVNSMmc0SmtLU2tMZEs5bWZyMnBlMlVBalFxek9tUEU3U3B6MUpQ?=
 =?utf-8?B?VmpRU2hldk9kaFlkS090SkxsQUNEK0hOQndvaUExWk5BQ0g2L2gzQzdJTjIv?=
 =?utf-8?B?NkFVeU1DcGlsQU1zdDNhaG9wbjJNbmlWWFRwcjFOOHhyZEp6WnVJcTczbVhz?=
 =?utf-8?B?OGMrZnVtRDVJY3RzN1dFZUxmdFRUcDhOUkxJOEFkcE5kK1ExQ1JzQndaWm1T?=
 =?utf-8?B?cm1Jck5GSFlpZldUV3NlTWhUS0NYcU03YXlLNWJYbnJKL20vQTdIeUkveFU5?=
 =?utf-8?B?N0RRQzVpTmNTSVBSdnNZSmhxWVEya1RCV3hzTjBlTXZ1WlhSLzNTd0dob0lr?=
 =?utf-8?B?bVpoRFV6ODUzWE52dzBCZVdPUWNicGpvYm5UUEl5THNqcEQ2bjk4c1A3djlQ?=
 =?utf-8?B?RWszY0xOOHR5SzVtT0Njd2JCcWdETFBrRHYzRHVPbThIWlc0aVBLNEVkd1R0?=
 =?utf-8?B?S0dvRkdKcHhGQVJ5cW15V1hpTkl5VUtmOFVacDdxVXZCejc4UFk2VDM4Vm8y?=
 =?utf-8?B?K0xYbXNaeGoxZFZNSmszaUhmMnQ0NFpvbDVYNFpUVmJQWHpkMEFBTWswT2I1?=
 =?utf-8?B?SlVuYjBuM2ZpR1FhREd5TUtzQkNEZlVOdXU2YW1JUG5xclRzTFQwdmtNTkZz?=
 =?utf-8?B?Y3VoYkdUeDNxaWV6UzlyOU5jbGpYTElvc3pwUXdqSWttOWRNZVEvWjd1WFJw?=
 =?utf-8?B?b2dxSXhuRVBFdXRRcHNWUHprMkdpdWhBQWxpTCttckhNWHhySlQxUmZsWGwz?=
 =?utf-8?B?YW9DRDJNc2c3YXg1QnNQL0VrOTVxbTRjZkEwQ1hRSzNXdUNqK1F5dFl4Snlw?=
 =?utf-8?B?U01XKzJNdlE3dDZmWk5EaUZZRTd0Y3E2ZEdVaXdxLzEybkNpMGwrNGdiaVJs?=
 =?utf-8?B?SnhBdE14Ti9YWHlLWjlNUHBTYjNaKzNsSFZRS0F1UkVlbEszeG1Za3lpdmps?=
 =?utf-8?Q?N1SKbOEXFsWCNMRMxNHHqCkdq2ZBTUwRW45Jk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckN6S0RKK0RrNHdZdEZDV1FMdnI4djN5K2dYeFY0MG9RRk9MWFBSdEJRTkJH?=
 =?utf-8?B?MmtEZi9sOUJoRThhWFpydDV5SkRsRVZpRWJXNCs4MVNLeXc1UjNZMmZoTmlv?=
 =?utf-8?B?NndRblo1UXJXN2hMbGxKY2dPUkRNSHBQQm5pNmg3NEFNMkd0aEU5WWRRSUtT?=
 =?utf-8?B?SG1jSit4THZ5QTdtbU0xM1pYNm9jcHBUam4vWlkrbGFnSHBIRlZ3YUxKTWVL?=
 =?utf-8?B?anoyRWM4YithbXlpVUZZdWw4K2VBd0pLU0FNaVdFaXBGUG5IOGZNREkwTG9Q?=
 =?utf-8?B?YnhtRkVBeklvbHorbGNDNnJ0a1lzU2VOaElZdEVmM0NtYk80aXF3azdMak5Z?=
 =?utf-8?B?MWNscHhERW9WcVpRUVg2OWp4WGVFWWhRdzdwVVNMN3JYYys5dndRd1c3SGt6?=
 =?utf-8?B?eVRoaXMwU2JjSGFtVmxlR0FtZjlLdDczRm5JMmh2M2NMVllFWjF0REtSaXNm?=
 =?utf-8?B?VkNqZW9NNnVNQW9KU0ZobXpTaS82ampuQlFkelRoVXFNUFJmbjRLTllMWEZW?=
 =?utf-8?B?OEcwVDljNHdhaDZlOXhIRlZTeGVNZmw5cFMwYndFczFjb0hVanplTFloSUF3?=
 =?utf-8?B?cFVsbjdGTFE5ZWVpMFZQUHJ3a2J3bFNiS0oyNVRYRS9KU3dxbjZpSXBOREtV?=
 =?utf-8?B?L2pqcUFrdWdmZ2RhTCtyWlZuTTB2N3VFRjgzWmdRbzVsaG1abHFncWIxaFp5?=
 =?utf-8?B?Mk5sd1JUKzkrRTgzTTc5dnRWc0VNOUdaWFZtYjdQV1dhYjUxNk9SL2N0K2hi?=
 =?utf-8?B?UVd5UTVqRklGejJicFlVcG5SYWtvR3ZLK0VUZXozMElZWGI0YWhiZlZyWGJV?=
 =?utf-8?B?M2grWjVmTjBMeGpxekRLQkVZM0JZTjBtNWh1aDdKQllva1NMYlhPR0hhb1ow?=
 =?utf-8?B?YlBXOWJJcCtNK1JKTU5Na3pGOTJCOWo1RXVhU3haL0pvTTA3eVVNdS9hREF3?=
 =?utf-8?B?NXpPNWhYZFcwWlV3ZkIzRlNPQzFCTHQrV2dRSGlWK2dRQ3BkT09tdTJsSS9Z?=
 =?utf-8?B?blBYNVJsTXVTWVcrRG1JMXVCTjJNdWR1Q0pGVGdrd1JEaThrazY4ZGloVFd1?=
 =?utf-8?B?clV0OHdxM2pIdjVoZDFQNVBxWElaY2FMRGlUWE5CekI4bDU5TExERGVRY3Ar?=
 =?utf-8?B?ejVkaTJ3TDZxQncxRytOdmwwK2xHUkdHeVd4UmI4TmRVZzZlSWJGSmkrV1VY?=
 =?utf-8?B?RERHeXVkQ3VWcFVZUjltcFAxUENWajhCaStOYnpWN1duczlBejRPSUdaSGxZ?=
 =?utf-8?B?c0hQRlZiRmxOc0N6STJwK2Y5MnU3NlJpdUlROU5RNzdaQytHbTY3bnpZcGJr?=
 =?utf-8?B?QVV6MWRUM21xMlJZUzM4aUlCbHhqRDJiYzRoMVJock5DUHNsYzdveU5rdUN4?=
 =?utf-8?B?endJVXJHRnVaODB2UHNEeVZNdy9CNldxc2kwZElZcEdSSUZFUk9HejR3VUgv?=
 =?utf-8?B?Rnd1dGtuekJaR3NXdms1Q2FaMWpZeG5JMCtqdndORjNaTkc4cUthbUQ0dW1o?=
 =?utf-8?B?ckI5eGFtZnBiNXNsdi9ldVdlUTgvU0lJdVQxcHJraWRLbG44ZGJkaDJpMmZI?=
 =?utf-8?B?V3h4dVgzK3dwWHo3R05KMCtoeHhIRytGb2h1eVp2QmpkK3FKb3ZFVjYyVVR5?=
 =?utf-8?B?WU1EVVV0ZmVWK2tZci9FU0tCRFpSSndXUUFKcmxhbkdTbWh5SkQ5TWFoSnZq?=
 =?utf-8?B?OXdocko3Q2hzRVJ6OHkyZ0U0dmF4ZGZyR2dRYjM0U3JvdjJGNC83c0FGMFpE?=
 =?utf-8?B?V2hHaDF6YUF3MGRkeUplbS9QbEk0bjV3S3JIemIyWCt4ZmxDWFkwWXh6QWlj?=
 =?utf-8?B?d2RzandES3A5Rmx5TFpSajRWbk84M1lPOVdqeWtpUVhxMlBLemo3dFpQSDZM?=
 =?utf-8?B?ZVB4Mlk0aGhnN1FUdmxSR2FMWFRzNXBoN2pXOHR5RUFEeDVqSUVWcTU3eCtR?=
 =?utf-8?B?NmZmUXFmSm9pb3lweHVLQjBjdG15RzhDT2xSbDJ5V1M5aFJsTXlLa2tMK2Zk?=
 =?utf-8?B?Y1V4Y2kzZG1PR2loZnVIR0cwWkJsWEtaSzFuMmFmSE1vYnp0WXFndHVPWTJU?=
 =?utf-8?B?ZlFPZ0craSt4U0FVYXBweGtPQVB1bnAyaXczM291aU0reUFYbVpqeE5YQkJV?=
 =?utf-8?Q?fsv8QUErYO0lyjr6PHlkcCYU5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9D9E54A6EE5C04EBE724322EB0E1DAD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341fef94-413e-435a-e8b4-08dcbb57ec81
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2024 05:22:28.3641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9FjOgZ6YNQHOdnVxDMhgMaXzCw2A1wLP/hqyYmX8s7MlmY3+uQTBK+PaN7d0HrDX+ICgR5b4DUeBXdMSA0W7QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7801
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTEyIGF0IDE5OjMxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIEF1ZyAwMiwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IA0KPiA+
ID4gK3N0YXRpYyB2b2lkIGt2bV91bmluaXRfdmlydHVhbGl6YXRpb24odm9pZCkNCj4gPiA+ICt7
DQo+ID4gPiArCWlmIChlbmFibGVfdmlydF9hdF9sb2FkKQ0KPiA+ID4gKwkJa3ZtX2Rpc2FibGVf
dmlydHVhbGl6YXRpb24oKTsNCj4gPiA+ICsNCj4gPiA+ICsJV0FSTl9PTihrdm1fdXNhZ2VfY291
bnQpOw0KPiA+ID4gK30NCj4gPiA+IA0KPiA+IA0KPiA+IEhpIFNlYW4sDQo+ID4gDQo+ID4gVGhl
IGFib3ZlICJXQVJOX09OKGt2bV91c2FnZV9jb3VudCk7IiBhc3N1bWVzIHRoZQ0KPiA+IGt2bV91
bmluaXRfdmlydHVhbGl6YXRpb24oKSBpcyB0aGUgbGFzdCBjYWxsIG9mDQo+ID4ga3ZtX2Rpc2Fi
bGVfdmlydHVhbGl6YXRpb24oKSwgYW5kIGl0IGlzIGNhbGxlZCAuLi4NCj4gPiANCj4gPiA+IEBA
IC02NDMzLDYgKzY0NjgsOCBAQCB2b2lkIGt2bV9leGl0KHZvaWQpDQo+ID4gPiAgCSAqLw0KPiA+
ID4gIAltaXNjX2RlcmVnaXN0ZXIoJmt2bV9kZXYpOw0KPiA+ID4gIA0KPiA+ID4gKwlrdm1fdW5p
bml0X3ZpcnR1YWxpemF0aW9uKCk7DQo+ID4gPiArDQo+ID4gPiANCj4gPiANCj4gPiAuLi4gZnJv
bSBrdm1fZXhpdCgpLg0KPiA+IA0KPiA+IEFjY29yZGluZ2x5LCBrdm1faW5pdF92aXJ0dWFsaXph
dGlvbigpIGlzIGNhbGxlZCBpbiBrdm1faW5pdCgpLg0KPiA+IA0KPiA+IEZvciBURFgsIHdlIHdh
bnQgdG8gImV4cGxpY2l0bHkgY2FsbCBrdm1fZW5hYmxlX3ZpcnR1YWxpemF0aW9uKCkgKw0KPiA+
IGluaXRpYWxpemluZyBURFggbW9kdWxlIiBiZWZvcmUga3ZtX2luaXQoKSBpbiB2dF9pbml0KCks
IHNpbmNlIGt2bV9pbml0KCkNCj4gPiBpcyBzdXBwb3NlZCB0byBiZSB0aGUgbGFzdCBzdGVwIGFm
dGVyIGluaXRpYWxpemluZyBURFguDQo+ID4gDQo+ID4gSW4gdGhlIGV4aXQgcGF0aCwgYWNjb3Jk
aW5nbHksIGZvciBURFggd2Ugd2FudCB0byBjYWxsIGt2bV9leGl0KCkgZmlyc3QsDQo+ID4gYW5k
IHRoZW4gImRvIFREWCBjbGVhbnVwIHN0YWZmICsgZXhwbGljaXRseSBjYWxsDQo+ID4ga3ZtX2Rp
c2FibGVfdmlydHVhbGl6YWF0aW9uKCkiLg0KPiA+IA0KPiA+IFRoaXMgd2lsbCB0cmlnZ2VyIHRo
ZSBhYm92ZSAiV0FSTl9PTihrdm1fdXNhZ2VfY291bnQpOyIgd2hlbg0KPiA+IGVuYWJsZV92aXJ0
X2F0X2xvYWQgaXMgdHJ1ZSwgYmVjYXVzZSBrdm1fdW5pbml0X3ZpcnR1YWxpemF0aW9uKCkgaXNu
J3QNCj4gPiB0aGUgbGFzdCBjYWxsIG9mIGt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uKCkuDQo+
ID4gDQo+ID4gVG8gcmVzb2x2ZSwgSSB0aGluayBvbmUgd2F5IGlzIHdlIGNhbiBtb3ZlIGt2bV9p
bml0X3ZpcnR1YWxpemF0aW9uKCkgb3V0DQo+ID4gb2Yga3ZtX2luaXQoKSwgYnV0IEkgYW0gbm90
IHN1cmUgd2hldGhlciB0aGVyZSdzIGFub3RoZXIgY29tbW9uIHBsYWNlDQo+ID4gdGhhdCBrdm1f
aW5pdF92aXJ0dWFsaXphdGlvbigpIGNhbiBiZSBjYWxsZWQgZm9yIGFsbCBBUkNIcy4NCj4gPiAN
Cj4gPiBEbyB5b3UgaGF2ZSBhbnkgY29tbWVudHM/DQo+IA0KPiBEcmF0LiAgVGhhdCdzIG15IG1h
aW4gY29tZW50LCB0aG91Z2ggbm90IHRoZSBleGFjdCB3b3JkIEkgdXNlZCA6LSkNCj4gDQo+IEkg
bWFuYWdlZCB0byBjb21wbGV0ZWx5IGZvcmdldCBhYm91dCBURFggbmVlZGluZyB0byBlbmFibGUg
dmlydHVhbGl6YXRpb24gdG8gZG8NCj4gaXRzIHNldHVwIGJlZm9yZSBjcmVhdGluZyAvZGV2L2t2
bS4gIEEgZmV3IG9wdGlvbnMganVtcCB0byBtaW5kOg0KPiANCj4gIDEuIEV4cG9zZSBrdm1fZW5h
YmxlX3ZpcnR1YWxpemF0aW9uKCkgdG8gYXJjaCBjb2RlIGFuZCBkZWxldGUgdGhlIFdBUk5fT04o
KS4NCj4gDQo+ICAyLiBNb3ZlIGt2bV9pbml0X3ZpcnR1YWxpemF0aW9uKCkgYXMgeW91IHN1Z2dl
c3RlZC4NCj4gDQo+ICAzLiBNb3ZlIHRoZSBjYWxsIHRvIG1pc2NfcmVnaXN0ZXIoKSBvdXQgb2Yg
a3ZtX2luaXQoKSwgc28gdGhhdCBhcmNoIGNvZGUgY2FuDQo+ICAgICBkbyBhZGRpdGlvbmFsIHNl
dHVwIGJldHdlZW4ga3ZtX2luaXQoKSBhbmQga3ZtX3JlZ2lzdGVyX2Rldl9rdm0oKSBvciB3aGF0
ZXZlci4NCj4gDQo+IEknbSBsZWFuaW5nIHRvd2FyZHMgIzEuICBJSVJDLCB0aGF0IHdhcyBteSBv
cmlnaW5hbCBpbnRlbnQgYmVmb3JlIGdvaW5nIGRvd24gdGhlDQo+ICJlbmFibGUgdmlydHVhbGl6
YXRpb24gYXQgbW9kdWxlIGxvYWQiIHBhdGguICBBbmQgaXQncyBub3QgbXV0dWFsbHkgZXhjbHVz
aXZlDQo+IHdpdGggYWxsb3dpbmcgdmlydHVhbGl6YXRpb24gdG8gYmUgZm9yY2VkIG9uIGF0IG1v
ZHVsZSBsb2FkLg0KPiANCj4gSWYgIzEgaXNuJ3QgYSBnb29kIG9wdGlvbiBmb3Igd2hhdGV2ZXIg
cmVhc29uLCBJJ2QgbGVhbiBzbGlnaHRseSBmb3IgIzMgb3ZlciAjMiwNCj4gcHVyZWx5IGJlY2F1
c2UgaXQncyBsZXNzIGFyYml0cmFyeSAocmVnaXN0ZXJpbmcgL2Rldi9rdm0gaXMgdGhlIG9ubHkg
dGhpbmcgdGhhdA0KPiBoYXMgc3RyaWN0IG9yZGVyaW5nIHJlcXVpcmVtZW50cykuICBCdXQgSSBk
b24ndCBrbm93IHRoYXQgaGF2aW5nIGEgc2VwYXJhdGUNCj4gcmVnaXN0cmF0aW9uIEFQSSB3b3Vs
ZCBiZSBhIG5ldCBwb3NpdGl2ZSwgZS5nLiBpdCdzIGtpbmRhIG5pY2UgdGhhdCBrdm1faW5pdCgp
DQo+IG5lZWRzIHRvIGJlIGxhc3QsIGJlY2F1c2UgaXQgaGVscHMgZW5zdXJlIHNvbWUgYW1vdW50
IG9mIGd1YXJhbnRlZWQgb3JkZXJpbmcNCj4gYmV0d2VlbiBjb21tb24gS1ZNIGFuZCBhcmNoIGNv
ZGUuDQoNCkkgYWdyZWUgd2l0aCBvcHRpb24gMSkuICBXZSBqdXN0IGFsbG93IGFyY2ggY29kZSB0
byBkbyBhZGRpdGlvbmFsDQprdm1fZW5hYmxlX3ZpcnR1YWxpemF0aW9uKCkgYmVmb3JlIGt2bV9p
bml0KCkgYW5kIGt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uKCkNCmFmdGVyIGt2bV9leGl0KCku
ICBJIHRoaW5rIGl0J3Mga2luZGEgbm9ybWFsIGJlaGF2aW91ciBhbnl3YXkuDQoNCkFuZCB0aGlz
IGlzIGV4YWN0bHkgd2hhdCBJIGFtIGRvaW5nIDotKQ0KDQpodHRwczovL2dpdGh1Yi5jb20vaW50
ZWwvdGR4L2NvbW1pdC8yZjdjZWY2ODU1MjdhNWVmOTUyMzQ2ZmY1YWI5YWRiYjhiYjZmMzcxDQpo
dHRwczovL2dpdGh1Yi5jb20vaW50ZWwvdGR4L2NvbW1pdC82Yzc2ZmZhNDdhOThjYTM3MGZhZDM4
OTI3MWRjM2NlZGYzMDRkZjJkDQoNCg==

