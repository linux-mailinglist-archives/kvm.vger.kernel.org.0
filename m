Return-Path: <kvm+bounces-71035-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ePctOnLRjmnJFAEAu9opvQ
	(envelope-from <kvm+bounces-71035-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 08:23:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E461337D9
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 08:23:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7653A301021D
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 07:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A117A29ACFD;
	Fri, 13 Feb 2026 07:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DyMcXUWH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B492F29E11D;
	Fri, 13 Feb 2026 07:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770967397; cv=fail; b=qNBtMOn85ZZ+UWSZ+eQ7q16TJA6yonsEmXWtLwQRfLY2DZzGcMoLeMJWqchyjTvNWLVT0sSwGKQ487YTPpLDIeqjffFMBUkcSEKajw1tSv1V+fcAgEc4uCYBY0oJDlqKILBtr9xXrBKzq8pM/aIx00yDUrwcaC74reLyQJihGqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770967397; c=relaxed/simple;
	bh=odyMcFfZB6cTCkn3rIc6+zPY+Dizu88GEBm356W+wV4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dz/58m9hYUDNM6lbauO+kVE+apSNgtfQfEzWWZzhQz1zwonoUgcOL1IrTzqNpIHacc9YJZ7k6nT7WSQYqEVRXJq4GP64i4VcPLValQZHAZqBFbjnmW+GYeo8eRWFwSDTuI9tsG+xe6GVrzNU5mbKCU54DuLoMubOzZaMiGrcZQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DyMcXUWH; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770967396; x=1802503396;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=odyMcFfZB6cTCkn3rIc6+zPY+Dizu88GEBm356W+wV4=;
  b=DyMcXUWHs13nFq/d+gt1JwGut5t3Dpn5m8fQPTU356T9UigBokye77rx
   2avtWg6UmhaqecJ96DXKa0bPxBFtalsn6GYu791HTcGApB1NCjgHNZF6t
   VnRa2JQ6bGl271GKJK8ID0RddMDae+jr1pQkPtu4IhDBa63vYBr3uqk30
   Log3h6WvCR34qTrPwH607wsAZYV1aVuruxOxFdq8eeSMfZYNZefEguWp7
   ziCXyUtRhSAMyydD4zKCugBOipocv47+IF15PXkVsY+BcNiYfKoWgkmcG
   xiqLkpqk2IHv8WV1kBYDnAaG4TyBWjlkZe6fgTC5iIBYAbH0lzItV6xcL
   Q==;
X-CSE-ConnectionGUID: 7EKWy4r/SrGqt4v3e2K8qw==
X-CSE-MsgGUID: jyUCSl3rTJqHXK909MdqsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="75775424"
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="75775424"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 23:23:15 -0800
X-CSE-ConnectionGUID: hXchPH7MSz6JI6YV3/h0GA==
X-CSE-MsgGUID: IwIGFTviRXilkgvrq7Z80w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="216990831"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 23:23:15 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 23:23:14 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 12 Feb 2026 23:23:14 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.69)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 23:23:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EKqCY8ZiPSd7gvGp+94+ryGHgptCXX2K//Z0ueUVpQ0jhKnyXBey7zg/yZGIra5FCFwLnTseNJheHFgkQRvJ9TbpYVlyKFaB84ZhxINCQCpKaDrqC5eIjoOQZQImIlAaUeK99XhwmDjQ3iI+8UPKH3BLIbvwe2yp1do/kbkdNe36CLcsuUEmLhJQsKlkqvMuj131wP6VP67VaBHFMGXZuCEfZE22EOTxhPekY2f8CDB5kNRwuiGfYcWom4wPLLGA5oS/hFh0IB8Ff1LM2I90iST/ggHHT0wS+IMF3eab3lFw+T6YfWBu3wZhS99I2mlh5BNlVWCuCWMxB3ge8MWJ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odyMcFfZB6cTCkn3rIc6+zPY+Dizu88GEBm356W+wV4=;
 b=izExH4AY/wHYZFJws7URgZ0fMafwIqZf1eZiOKFxpXFJ3yedag1udLdk3FnRzJDUIYs6gO9VyXX7aSPvfW6yMgLXtG9SWVqwZEb8tK00GtD3vge3lzEAggUYPxG7yY76t0sz8P8ciLdkkqKqSzoWNyZvDegJGSfOE3h3fC7wpvWb5Y013Ehout71PZ+JQEq+DwylPsWxCXidwClr5XprWHevi0cqvdsUhzVXms6PL3GjAkFw6xnGTpPxclEz1i5VLO5PIc77t1GfkM9VwnUJUuwssClpjVwBqNNtDkls8aSolZGzJZlcx+19XHUhZXsPWZJlrii94s6nqEZTQ69mMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by SA3PR11MB7980.namprd11.prod.outlook.com (2603:10b6:806:2fc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 07:23:05 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 07:23:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 43/45] *** DO NOT MERGE *** KVM: guest_memfd: Add
 pre-zap arch hook for shared<=>private conversion
Thread-Topic: [RFC PATCH v5 43/45] *** DO NOT MERGE *** KVM: guest_memfd: Add
 pre-zap arch hook for shared<=>private conversion
Thread-Index: AQHckLz6BTQs4EDO4k+Nw7BtiVcv8bWAUbIA
Date: Fri, 13 Feb 2026 07:23:04 +0000
Message-ID: <5a06f5565e698ab9e7c9bcb06245c5ef76a03a98.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-44-seanjc@google.com>
In-Reply-To: <20260129011517.3545883-44-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|SA3PR11MB7980:EE_
x-ms-office365-filtering-correlation-id: 43602966-037e-49c1-ba8b-08de6ad0ba9b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?V1BVN0tvUTZ6Q1lwdDFTd2dDSEphMTY3MnNqUEwwTDNSS0VBMUdZdjdERnVV?=
 =?utf-8?B?OEg3bGhiVDQ0YjZZT1NxTUk3eGkxa2R0aEFySjlZSHJPbDZCQjZiQmhqNEdH?=
 =?utf-8?B?d2tZUHhSa0hJZ2pqL291d3pKOFJla25idGExdUdZdVVHTnJ6bGxVTDYyZ2VU?=
 =?utf-8?B?QU5neW4rOW9md3ZvQ2ZnZmdxdUVVcGg2dk5oR2ZzYUp5RVZaeFZnREF3THpI?=
 =?utf-8?B?d3hqNElxS3hLVTZCMDN5bWtMVHJzRjhMNUJZbllyWk9JNGE4SGd0UXBDK0dI?=
 =?utf-8?B?dHZyeUVUQTlzRy9McW5La2NBdkl3SCtwS1FCR3BIa2xEUUFoVDNRejQ5S3Jx?=
 =?utf-8?B?MWdUUHh4RGV3TFNYUGhJUzR2NG1rNFk5SklZS0p4NUI0ZlhoNHNZU2lxQUdo?=
 =?utf-8?B?SUhjOXUwNUl2bElrYldIdDcveG9Jdmd5R0RwTnpJRTh0dmNGaHd3czhGdVpN?=
 =?utf-8?B?VFI1QUJWd2FpN2YzbkhyLzJUNlkyTGtJRFgwZmFyTjlCQ3F5K01lSkVhaS9z?=
 =?utf-8?B?QTZGMWxQemVPQnI4QksveWVoR251aStGQWlYelg0anA3Qi9MUDBWRklOb0ln?=
 =?utf-8?B?UTJLeVlIVmZkQ0F0Y3hwV0hhbUsvR2hjZVZCOWNPVTYyS2JXeGhybjZoclhQ?=
 =?utf-8?B?K0hCbWpTOE5BNDQ5dmI2VTRlMDJ2VzRzcGxJZkc1aDBCU2hTaDRlSTZQM2pH?=
 =?utf-8?B?M2tmK2RXUEVQVUlubm9FMGRKbGJiWjFYUWFWbTFWWFZTc3hhMDZxd0VOUVd5?=
 =?utf-8?B?NitFWDd4WnY5L2tlWjNGQmdNeFVJejdTZUM5U1VBYnBmY25ZaGcvcmJpeTJo?=
 =?utf-8?B?d290c3Q1dDFLUTZXVXdtbFhDRlUzS2I0TlhOR1dmbE85TzFIdUdtSzhpYjdk?=
 =?utf-8?B?bVFiYVF1VkVmN0ZDRXRxc1ExTFZqVHorUSsvV0c3MTAvRXBkaVNkQUI0QXNI?=
 =?utf-8?B?Q2k1TEdkWExreGZXSEl1cEZUa2xHSXlDK3BRT1FYVFhQUnBEZFZxQjFNQUpG?=
 =?utf-8?B?NUtqOVRPZ0lXNDcySlZVYzMyc21XYklGNDh5Z2FFOGxDbGgrRFY5NnMyTFFl?=
 =?utf-8?B?UVVleGV4bnFwRENXSVVFVEpiTVhxSTlIeG9ib2orMk1STlllYVBqVElhaVY0?=
 =?utf-8?B?SXppK2VUbDJLZ3ZCS0JIMWpaRm0xYmdKWmpqM1VkSG40cnEyMXRtcWY5SDRp?=
 =?utf-8?B?TDZrWDhHRmRmVDlBUFh1aGhLZ3BMT0V6R1lHYUh5dFFLb3FQOTQrdUw0emc4?=
 =?utf-8?B?N0NOa294SzNNMWJpNUpnUWtjUmpiS3N5Q01FdmQ1eHNNS0Vyem5vOHAyVVU3?=
 =?utf-8?B?T3drM1FidDRLUnpvZlVzY1locXdxWmw3NmV6OVFkSURyUCtIcmdQWGJjbVhK?=
 =?utf-8?B?U0tSRERpcWdrSjBMdkNaQzd5b1RCZ2FDbEN2Tms0b0htMGpoOGxBdWZWallp?=
 =?utf-8?B?WFNYTCtWSWpNV3NjWFRMZ2YwbEhzUVJqM3pBbGpFa0wxS21EbUNmMEQvS0tX?=
 =?utf-8?B?dDZwTVN2MTNYVXE3ZDVWaEtqSlF4SEV5b2dEYWxGdmtoZDNJb3NPZ2E3azFw?=
 =?utf-8?B?eS8yejV6TytLS2NJdXpmajA4RFRDbTc4UDN0S0piUm9rdU5jZWNjSjFZOXg0?=
 =?utf-8?B?VmVYcUZhOEVMQVl1TUp5R1h3NnU0LzA2YmVYckMxM2EwSkU0L3NPMjFmTXVE?=
 =?utf-8?B?VHFJWHdYZi8vc2ZxNHo2Tk9MSHNaQWE0SFBBMklVYUVJWVp4T25Cbm85VUdM?=
 =?utf-8?B?c0JoaWloSm1udGtxRDJjbjZmNnFDa1VyTUdPaUJTSVlhcHIvMk5jcXJMS3d2?=
 =?utf-8?B?SUtvcDY2OUw1cm9WazM4T3pXRWp1ZVZ4WHNQRm9lcjBIQzNDeHFWbGYwOFNy?=
 =?utf-8?B?TGtTcjRqSE9LMGJUM0k2S2lXV1pMV3Nucy9NK0owT0hhN2xGa0Z1SEFENmtS?=
 =?utf-8?B?Uk1INDdla0IyQjlaNlZCSU5WbmU0UlRwaUcvWmpRelVTd0dLdy9xNkM4NGdN?=
 =?utf-8?B?YUlrc1Nia2l2VTdtamhmY0FSTUgxVGVjcEsrNCtNQjQwTDBvVTdWZzJENjVS?=
 =?utf-8?B?NmEyRWlSTXIyQU1GSnhTVWNGUWdDWkJHaDlWQytrUUxCN2FMSEo5Uy9zNWxU?=
 =?utf-8?B?NkMzNnR1NitrcFh0U0ZWaGtZRkJnbW5MMTdQcldDeng0Q0RjdkgwbzUzV0xG?=
 =?utf-8?Q?HqLehQqR2Aem0r4gtBFUY68=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clhGSzVrcndXT0ZEd1llK2x6c21FQUYvdlpjaFNPcE1udEQ0STBqMUlwdHVm?=
 =?utf-8?B?REFERHZzNmwvTTRqL08wVFMrUUxpbEQvWTdldnVYNWFIT1JWT1J3aWp6UWU2?=
 =?utf-8?B?bWM3UnBzUlNEVmQzeVZ4alZsVHQrQUtlK1pMNFZqcDBnU3lBN3dRMEQrYkhH?=
 =?utf-8?B?Y3NEaU9KbEtuSVIzVk5MWmxqbHVlSE92MFF0ZU5MWXkxT2RXVmNmQnJCTTBv?=
 =?utf-8?B?a1VKNzRnNi9iOGNncnBHcG5GeUREckprTTltRkNoRnhQbEhtbm9HaGNjdUd3?=
 =?utf-8?B?WnJYR1RwbDBIbkV3ckhUWFVMQVBOYVpBNDR6Rkw1OUJHMW0rWGNmU3dKMEFq?=
 =?utf-8?B?R2EzZnZ4R3pqNXg3MmdlNlIyT2RMMTZiZzljNjFURkEwcnEvYzdiQnNsY2V4?=
 =?utf-8?B?ZUNteHZFQ0cxUDU3UVh1V3dCbWJuR1pBSkFoTVBxNHZjZ24zc3d0RGxqbjZZ?=
 =?utf-8?B?M2o1MDE1M1RiQncxNW5vOUplU1hQZTRFOEgvbTJoKzFxVU1mQUhKQ2trMktY?=
 =?utf-8?B?cUpBemdZdWMwMC9RN2c4WE8ycXlFMndtRWNsY0NhdHFWL2lSckZVeW1MQ0Np?=
 =?utf-8?B?REI1ZDNUQUQ0TlFIM2JFeG1XeUl4T2RPMTBiN042WTdIdTk0QzA4VWRycUE0?=
 =?utf-8?B?cFZzTy9uMDhSa3BEakkwQXlSVkFsWkhOQlkwMDJJT1lhZGpvWHBzaitzMDR0?=
 =?utf-8?B?Y2tlK0NsbndKV1hyS3V0Z0toWXlpK0ppNm5jTzhhR3c5MUpHN3F0VmVobXJF?=
 =?utf-8?B?bmJaVnBBT0FMUkphTHNVcm5BNHdpTk1tV09PZG9Zb1dOUVZWRUduM25wQUdi?=
 =?utf-8?B?aEtxWFhlR1IwVjRNOGcxbDZzVHFNRFY1OE9PaHpwMjRueitqa0lxZjV4VWtS?=
 =?utf-8?B?SFZuNDgzTzhUUUpjUWlpMXdEa1hIa3FoL01xS2dsa2tJTk5IRHhrSDdRdGls?=
 =?utf-8?B?cG40NmNvWmRaRkZhUFFkK2EzTTFYajA1RlB3TVI0QnRuUWgybFNXZHBiTnlH?=
 =?utf-8?B?UmhJMUQvOUVmcHVNS1lpaVFQOVpBTGJ5dXpYU094YjBhRERBSDBEc3JoRjNB?=
 =?utf-8?B?Z0J3ajNOajBoT2Y0SEhQU0JISW1FcXlXVU0rUkR6bVRYNWFrV0JPQkdtUExT?=
 =?utf-8?B?OHYvT2g3bUZjRFdwQjAvMzhEalZmZDJOWnZDd1IxL3Z6RUpiMUUwMFg5Sjd6?=
 =?utf-8?B?UGVUOE5XQWhhcUFhQjFoRGEwRmxKUGhaUlo2Uk9YNExEZ0J4cnRLRHZtMUhv?=
 =?utf-8?B?S2M1ZHpSWEk1ZEcvRGptM2VmOGJmY3hJa2d3SDVxVkZEazJMMkNERE14SlZ2?=
 =?utf-8?B?U3BXdkgzbDFlUEcrY3JMUUVFWHZGS2RJK0dJQ3FFUithakhXQVd2d09qcmw5?=
 =?utf-8?B?T1N6Skd2K3lQTHRBN3RVMzFoWDQyTHhYMzR0cHRETVdDSk5BckxOaFF0cWxN?=
 =?utf-8?B?NXlEYmZyaVlNUjgzRU04VW9pdlA3b3hBcmh2bjB2RU1yMzZMRUtzL05KeDA4?=
 =?utf-8?B?bk9DZk9IQWZaamV1MS95MVVvSXQwTVlCSjlYRTRITkJZNEhlRmJONmR6RGFX?=
 =?utf-8?B?d2lkM2JhWG1ZOEZhSFpZMlhQTkZxT2ozT3pzeVl4QVVHYloyU3RKRWNDWDFO?=
 =?utf-8?B?b0cvUDBhRUY5enM1enRXR3hnSm81VG9JaEp5Q3ZETVhRRWlDQlMvRzYxWm1R?=
 =?utf-8?B?eVJZTUdjN2JIbWlabEttQ0Z0YllJaHRHbUNWNmZoTDZUZEdNaWRSS3VQUDBT?=
 =?utf-8?B?K25LOFRUQ05mVmZuOFZ2UnU2OVZ4VHpOMFJlTVNLcExCOEhkL3FiVG9iVjNC?=
 =?utf-8?B?dHZIR3c0VW14TnRJbzhoWmdNelo3L3d3bDBHNnpqajBGYXl1QXMvT1J3MXhm?=
 =?utf-8?B?R0NoazVmR0lTM3BlSElCdmhqUG1BdXNBTlBmbC84UUlpWDZiMGROY1RCY1NC?=
 =?utf-8?B?TzA2UEhBNTlVM01CdWxaU1pGT2xjUW9ITGYvR2JOcXVWQ0RSMFdjZVlTZkFE?=
 =?utf-8?B?YnlQdG9jeEJDQUV5YVpYZGNvOFYzbTBSUDljNW9xUkhRd1hVZDc5QTJPYk96?=
 =?utf-8?B?bUtjSEgrTzI5ZnVnV2V6SVlhTG8vS0RNL2tMNXB5NUk1RFRiNWVnUC9Gc0o5?=
 =?utf-8?B?eFlyTzZ6Q0VmV3ljYVZ4Y0J5QUhkcW04MWN2TG1QQmJmRXpUNGNiNVZ3akgv?=
 =?utf-8?B?ajQvWUZJY0lsQ2dydFhscGlEbVAvOE01cERwTytNSkpZbWZ3YjhIeHJQTmpD?=
 =?utf-8?B?WkRYM0FVZWJPQkpHV2ZFb1BXbDczbUZMT0RXVVMyMVUzSDZTTWFTZ3lzUjJv?=
 =?utf-8?B?UEsrVWhjSXJNak02NmxNMVU1MUxieTNrbW0vRU1qaWJjM3k0U0gvUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9082424599CC1747BFD051B671595737@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43602966-037e-49c1-ba8b-08de6ad0ba9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2026 07:23:04.9320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +TSnrputdz5W82UPt62KHhwq88KaWCCg+UT+aCIAd0wJ3gXuW3Dwy+QpT6sEmrJ6HcRjPfwtJL0u+/rgu/57rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7980
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_FROM(0.00)[bounces-71035-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 11E461337D9
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE3OjE1IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiAtLS0gYS92aXJ0L2t2bS9LY29uZmlnDQo+ICsrKyBiL3ZpcnQva3ZtL0tjb25maWcN
Cj4gQEAgLTEyNSwzICsxMjUsNyBAQCBjb25maWcgSEFWRV9LVk1fQVJDSF9HTUVNX0lOVkFMSURB
VEUNCj4gwqBjb25maWcgSEFWRV9LVk1fQVJDSF9HTUVNX1BPUFVMQVRFDQo+IMKgwqDCoMKgwqDC
oMKgIGJvb2wNCj4gwqDCoMKgwqDCoMKgwqAgZGVwZW5kcyBvbiBLVk1fR1VFU1RfTUVNRkQNCj4g
Kw0KPiArY29uZmlnIEhBVkVfS1ZNX0FSQ0hfR01FTV9DT05WRVJUDQo+ICvCoMKgwqDCoMKgwqAg
Ym9vbA0KPiArwqDCoMKgwqDCoMKgIGRlcGVuZHMgb24gS1ZNX0dVRVNUX01FTUZEDQo+IFwgTm8g
bmV3bGluZSBhdCBlbmQgb2YgZmlsZQ0KDQpKdXN0IEZZSToNCg0KSXQgYXBwZWFycyBzb21ldGhp
bmcgd2VudCB3cm9uZyB3aGVuIGVkaXRpbmcgdGhpcyBmaWxlLiAgSSBnb3QgYmVsb3cgd2Fybmlu
Zw0Kd2hlbiBwbGF5aW5nIHdpdGggdGhpcyBzZXJpZXM6DQoNCnZpcnQva3ZtL0tjb25maWc6MTMx
Ondhcm5pbmc6IG5vIG5ldyBsaW5lIGF0IGVuZCBvZiBmaWxlDQo=

