Return-Path: <kvm+bounces-58834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 904C4BA1F59
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 01:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F6A45613E4
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 23:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54D92ECE97;
	Thu, 25 Sep 2025 23:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KHVG014Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE6F2EB86A;
	Thu, 25 Sep 2025 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758842587; cv=fail; b=ZFQnPyKekiUqQePJuJwNG3qL5sHCJ/0HRm0ixH7tseXj6qNOgzkGtls0VgMVVY4UJF3k+fbWE6oeGuy/J/X3KifI5ONNisku5c6rKbD8bvywdyKMxeHDw7RLcS2gqolsqXWBBEmP64jjAvQ/WQ2HBiHVlTWo26fjy9W7d13f4c8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758842587; c=relaxed/simple;
	bh=hVC5DK00aglZ6Ha8mXZfwHsYqvteoIOwhAqYIMZBTrs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZMDW+bk/XXKrSZJ/htLYXbxmj7YaYYQ0ZF43ZS22Mmkw+E5ipI2wckHBVwMUHQK/9qcDh4k7z1gji0yZZxmFLit35GRo6siOToULiNplxx2ZVNiCrLlFiO+GrRT4gb6p2UeWBHuyTvdkfA8sPlO/yxiVXIQf0IO4+qOP6pWtK4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KHVG014Z; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758842585; x=1790378585;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hVC5DK00aglZ6Ha8mXZfwHsYqvteoIOwhAqYIMZBTrs=;
  b=KHVG014ZdYDRswuEs+fR1eB9i9CHt4OpxOyxfk1meTVlpbYH8AkizlDN
   eowMhTum6OFRntGU7pYrOD63HbU96un+oAtproSNSOz1tZAVEMv+hWcse
   PfHc3czIi6/IACz6SqsjkxMjVoHos5tklqEd4QSrudDGGI7jUKjySoUZR
   FJK7Fo0r1PCvg/NXhfB8VSPpUdo1+Sh+YHlFv1OX7aT5bUxW90egdgTaa
   7rCXFzJhvjeYPappwvP5CrmKAfB3Ztx5g8cETCh8+h8VtsL/qPcngWLBz
   cVuf/askwBalkCKmvBnvrjVTcodf3qmm+yChOGjjKK0TUwMXj7zc9NEYC
   g==;
X-CSE-ConnectionGUID: oQqp1M/ESzK5G0j8Jc137Q==
X-CSE-MsgGUID: uJ/EfwIERSmcPwWDEXpQog==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="71793708"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="71793708"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:23:04 -0700
X-CSE-ConnectionGUID: NkWT5OuHTCW/G1djZfSXOg==
X-CSE-MsgGUID: dj7ah1PaQJyQUfAMSuVa3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177395339"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:23:04 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:23:03 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 16:23:03 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:23:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xYlxHOb86hrP6DtWhgwmnTBpD2GCjjodiIpvCdnTabgEcG2M5/SvgK/q31pOUwlEcAeKoMTmJey8p7rJIjzN+voHEh5fG0dJVHwnYTm4BP08q/zz+TjomeFLOYmvMjtQsVenLUvFDGvBntTUYCn0eRR4bzEc7y5U4qZ07SVfXn/rpYo0fmluQVCEWa50pL7xJ89LlBzfXvsEcwFkAI+ViCF9Qa977uqBD3Y7ln4thy0cnWlIxetze6Zg9nqwjn201Sz6hFlKELQRAs4W7/YUbztuFsQSPipY4XDAfZWeoojp8J+EtbdZxnEzlC3cFBn+5/kaBGYW82oKPGGFbjUx1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVC5DK00aglZ6Ha8mXZfwHsYqvteoIOwhAqYIMZBTrs=;
 b=wLVfJK7LQ/Meik03LBavHgi5JHBe6f+WX7c/VAE8o7XczU7B3Ic9MQebsYDri8S3EivhquVVHIt6jzJNSqx9ZUFZKGYQL/PREoeJoX26FAmQqjmQqBDL0ovrlmvhsnaZQSd5zFigx1JBVyqaxy8xGqraMpwATjX5aEwaRtJY/0F23mlTiNt6wuJB3kKYJG5dswDy1jo9y+rtcGKY6WEo8ysMGfw8I/bsR4JwcM+Is8XpCPhWkNlptD+Az7Yf0KJ3s0tJk/rm8lCU3yh9fyAiMbUbffOD3Pgcrp31V+W7h2xxx5b0zBs8lDY+z22nJ4fsVF6JG6CAy7v1UKj6O4N0og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB8087.namprd11.prod.outlook.com (2603:10b6:610:187::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 23:23:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 23:23:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcKPMwwODp7//+PEGBZ/2ZnMIQ/bSZt9MAgArc74A=
Date: Thu, 25 Sep 2025 23:23:00 +0000
Message-ID: <b6dbc85805ba02701d23902f020d83469fa34d2e.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
	 <56c3ac5d2b691e3c9aaaa9a8e2127d367e1bfd02.camel@intel.com>
In-Reply-To: <56c3ac5d2b691e3c9aaaa9a8e2127d367e1bfd02.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB8087:EE_
x-ms-office365-filtering-correlation-id: 8e7b2f01-5826-4020-9945-08ddfc8a77dd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?amVMdFZZc2E1UzhwWVdJMEdRdjU0RU53d2FZbk5kNmNNRXVKSWExTzMyaTJv?=
 =?utf-8?B?eisrSkFiaGdKb20wSDlBbXQzaGtxZlZIWWJVb1JISGtYQTQzZ2phRFpETk9V?=
 =?utf-8?B?VWpjUTBSTUJoK05TdlJmTGtzempPcEUvSkRucExWYzVsKzg1VmVLMjhGTjZs?=
 =?utf-8?B?T2diY1pHcFlJVG5SdDVaUHdaOHlkQmphSXpHNEtxYmg5RWJMK2RiZVhkR3JM?=
 =?utf-8?B?Zk5tZHQzOC9paDg3b1lNaU9DTFRDeVZEZkVpdmExSVBJNXFONUJzOXZsVmtX?=
 =?utf-8?B?NkxqOFowL1lKUFhvVEZMVVBqSXRYNDRjRVFiUC9iQjk5RkRiTEJFbmdGSTNN?=
 =?utf-8?B?aDFZL2FkVjN6ajJ2Y3pDcmRHc2dES0w3UG5Tczk2c0tlNFZCRllnZVJrWUpD?=
 =?utf-8?B?dWg4WldLSzV2aEtqQ21xbDkwQjJxcTYxMVowZ3lWbTdSKzR0RHNjdnY1K2V2?=
 =?utf-8?B?M08relpKaUIzUWVSdGY4WlMxSUUxSVI1WjJIcUVyMVFremRJWERrRWdubGxE?=
 =?utf-8?B?MWZSMFNaNmlXQUIyUkJWa1ZtY1N1WGJzaXh5THZ2T1dZY2QyUlp3MWE5bnFk?=
 =?utf-8?B?eTlsbHphOWtndFdaZzBDaWpweHFkaXdLODdCdG8xL292NkFFSDdTMU9QNitJ?=
 =?utf-8?B?TS9jeVlDOW9DOTRsRU82ZVBmZUhXQVZ0UTNNOEwyMlNDOExIdkg4YTFQaE9p?=
 =?utf-8?B?NStDNFZUaDNGZmhUYSs5R2N2dythekgzbUNnckR5UE9VY0ZXU0pLdVFHdVNF?=
 =?utf-8?B?bXNmSjJMSmlrWXJHYlRxQzQ0UGwydzBtZEVpam1tRTN0blMzeHZhRVRoekRp?=
 =?utf-8?B?QlRmRG1XeTJOYzcvTkhOTHZvWTlNejZwQlJiTUFtaW15aVlCeWlQVDY5T2ho?=
 =?utf-8?B?YVdHVFZDbGxDMy9RK2U0WGEzRkVPY2pJVjRWSUZyUXF1Nm1xQXJBQThCK1p3?=
 =?utf-8?B?OXdGQ2t5VFRZODJxZ2NFNzFGYVhPTk1yek9uMEYzMUhjbHVhQnkzZEhqdS9F?=
 =?utf-8?B?VlMrUGF1Q3c0RjJTeGJwd2hiSFgrTVRHV1dxNmx4L1lVUVFpY1UvZERaSWMv?=
 =?utf-8?B?K0hrTjQvZTREZDlHVXJGdzVnZXNNZlRVU1FVT2RHbzRYTCtaeHBCNWsxR29t?=
 =?utf-8?B?aEt2cmV3NDZoZGd5WnZ6QUJUWVp6bnhEZ3hucFRyWmozSWZlZ3plbWFNbWlT?=
 =?utf-8?B?aG9NZ0ZrV1RhUWJsRkh4Qm1pRjJwM3BNTytyc2x3L2dVbEJDTGU5MmQydHpo?=
 =?utf-8?B?dDVTVnJXazRmOU5pWGk5SXF2TFVBdFVkNi9kQnRiUmdid2pTazRZZTRDdE9F?=
 =?utf-8?B?S0NPalVZbHdUVkNxTnRZd294VzhPSG45ZS9VTWZIQTdCWWZreVNQbVlnR1lp?=
 =?utf-8?B?NEVoR2Y1aWoxRFhmRGJmSGhralZUSkhGbWdIb1RGNkFZK1l6Y05ETjBpbkkz?=
 =?utf-8?B?Q3BYUDZncUk0dDFKeWdQQTZhNXhyVkMzalVlVzNudUJpd2JWeHZFTXBEVEdT?=
 =?utf-8?B?NHFja3lXYU05RW92eXJ4b2gxcWR6b1FkUmNMUDlha1hRUzFqRURKZXFiRHVI?=
 =?utf-8?B?VW1FRmZwRW1oTmFaaXR4bzNqRytGeTV2STdXNDhnaWg2NDFkMVNyVmt4RHFC?=
 =?utf-8?B?Vkl0bGdKeSthT0xURlRqYXRtWnVFVlpFMDFpb2l0bTR5NE5tb1MrRnVaeWh5?=
 =?utf-8?B?NGFwZmtMUkVMZVhzRW5WMjB2SGlzc0Fhb0VDN0dNdVowM1dtZHhGajNKaWhW?=
 =?utf-8?B?N0lrcXVPdXE3MzBEcFhlOE5FRitONTVZeDJWZWdoTDNqTVFSbmhQeXYwSzJr?=
 =?utf-8?B?d1ZLb0YwYUcxZTVDQVhVcUxsamhZT0c4dWkySXVWRktFOWhGQ3NBcjNSZXlS?=
 =?utf-8?B?SmNONDVEUUZndXBFTGFVTnFoTXJ5dllsbzRBcnowZCtRRnhpMVAwdk5EN0tT?=
 =?utf-8?B?bXc3Z0tOTGt2MVlMS2FUS1ltdjZGMTBQVXVHWG1WdEo1UTMzU2pqcFVYcFlt?=
 =?utf-8?B?eWhhM3R3MUJZWlROeFZxSlR3Y01jWXM0SDd6c1RFcTF0aUFwRW1IckVIaHln?=
 =?utf-8?B?ZGVsZUluNnlTTkNIcS9yN0s2a1RFUGZPQ1d3Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHpNNE9vNTY0Q2gxZUFTbEFlZE0wM3hrLzQzdVNWazArdHh2Ujd1eDJ6TG05?=
 =?utf-8?B?Rk9mNnVIdUl6c0RDV3lrc0YzQU9yOXF4VXI5ZWowSmJnYndPRFY3Nk9XQnBo?=
 =?utf-8?B?STNuNnN6ckpReE85dno2L2tGNVRZMDc1YjI2T1UrdjVvc2Z1UlBoV0lZbXg3?=
 =?utf-8?B?VmJZdXhnMWUrbkltR3VrQkNYSkdXVTZSbkF3OENFQVByUkJPVVRSY3llTEFs?=
 =?utf-8?B?UVFLTGkxWUVjelEwTEtEQ2lsbC84T2draWIwSEI5S3dYTW8zSE5sdUVsSjFF?=
 =?utf-8?B?V0dYQmVvZGlGdDlwK1N1RVoxa3Vabmltc2NvaXdZZkkrcXVxUkFxdzhWa2dD?=
 =?utf-8?B?L0VRNmFzOWF4dDZpNEp2MWJtK0ZxOGFOaThHOUoya1RvQzVaSURSNDd0dzM1?=
 =?utf-8?B?VU12NFJxbmNqeEtnV2N4N1ZFUjhsVDVkN1hxWU5ZSXlMRHovb0IxUUVPaWJE?=
 =?utf-8?B?eE9oc0JxTUlUczNWeFhuNmI0cE92VTdtYUwzWnZRUlFpT1Y5RVJzUHJVQjRn?=
 =?utf-8?B?YXZWWE1GS0lWZENHVXI5QmowcUhzVWVLb2dzdmVTZU9mNnFpeGxoK1YzWXVL?=
 =?utf-8?B?M1pQbmF0dTZwOHdOM3JPWWdGUFdEZHhoUjcwQlFvNTFUSEtBZG8vTS95RXlH?=
 =?utf-8?B?a0d3SXN4eTlIV1lYZk9KZ3FpUi9ud1A1ak5TWG1RUENsK00wUFZ6b01BZlpj?=
 =?utf-8?B?dFZmaEdxbGJVR3U1dzFuemxIZjYwSGY4TllMTExwRWtSRWdjSkJyNmRvaEpj?=
 =?utf-8?B?QWdSZGlEbHlpenU4VnZhZHRQeGNvVTAzSngwcHRyN1RIaytCNVJKcTVsbDlN?=
 =?utf-8?B?V0FnSUJ4UUhoUUM2RnU5VnRUZFdVUms3enRqVWtiT3lTSnBZTWxZMVQ3NzBa?=
 =?utf-8?B?aFdWNzFYRThTYlZIRjJXT28reVg2LzN0YnVpaGN1ZWlUbWhmQ0JaZnRKTjM1?=
 =?utf-8?B?dzNQbVJYSkY1ZzQxdy9KQVdwL0xvRGQxMFJuY0VKdFNWNGd5UmowZDh5cTc0?=
 =?utf-8?B?azNtc25sbVFzbVNkK2h5U1Q2MFVIOFlUQnVTVjBjbkM2bWFYSEdNN05IL0JR?=
 =?utf-8?B?clNPbWltYm1OcFliUUJucE1jcTUyK2xoS1RpTkhHL0ovdWdpUVEzbDdmeURF?=
 =?utf-8?B?UE9WTTNLTzlTTnc3WGllek5DQWZXQ2J1M3h4SVhFbjF1WlRUZW1Sc3JUcS96?=
 =?utf-8?B?ZXZISEFrRmVnSDdJeW91cFJYZG4vSjU0K1J4dE1FTTlzZlZuaytsZEV2L2ht?=
 =?utf-8?B?SVhwWkl0aGpURHVLN1pFTDdxYWFXMnh5blVVMGh2UHExeFAzaWdLU21XRkQv?=
 =?utf-8?B?WGtIMkN1QnJnWUZYU25GQzRVS041RFdXTUlneUFFRkFUaGFibFlob25KeDB5?=
 =?utf-8?B?c0JIK1Y5R24zQ25yVmM3OHQ1bUxMeU9wRm5hR243bkpDeU9tVm1pVG9jN29q?=
 =?utf-8?B?Y2hiTWRyMmVuTDdOSDVjRzNVWVJqU05XL3VabjEyOE5kckw0K05abEc1cTZ4?=
 =?utf-8?B?ODNwU2pvZGh2RTk5MVVRL1NLWEY0aGlVbzYxKzhkUll2dmFnZXdTWDFZd3JC?=
 =?utf-8?B?UzZsTUllSXFaUklKTys0L05CajlVbFpoYUd6akVoUzl2aDN4V0RMTUFQMitH?=
 =?utf-8?B?VzM5YUcxUVlrdUpteExkcVNBOVYydUgvamlzY0FWWEZQajRsZWlRUGQ2K0No?=
 =?utf-8?B?U2wzcVJTMWxxR1luQ3hMSlBpRkdjOWt6SHo0aHNrd0JBVjNuRXRhaHR1c0NS?=
 =?utf-8?B?MW1EZUJ3VnpPZGtYRVlOZUhWQ0Y0U0FTV0dqdjV2bVhOS2tGczhXSWQrSmRW?=
 =?utf-8?B?clNXU01lTk9JQTMyQU5mRW5QZmZjSTljdENmcU9zdjJONy9jYk9BUU5XRlBs?=
 =?utf-8?B?WXF1eVpzS1cxL3hkLzlEQm9tdmVUVzRZUVRGWTdQQ1B3VldKbXF3cld0RlhC?=
 =?utf-8?B?TWxxc2w1d0VCTHgvMXgyUFVoNC9sN2gwazhuaTg1YTB3UUhOTkdPOGRyMUxG?=
 =?utf-8?B?YlhZeXM0RWRrdUd0V3RvV2NLWHE5TUlyRzFKVGc2SWlrWkNiQ2J2ZTI0ZTZ5?=
 =?utf-8?B?K2pWdnpGRnhGRTJXSWFEdThXU1kvTFEycU40VERTdVpxbnNQV0xwNi9idzNs?=
 =?utf-8?B?a25tVGZUbDBFYkxjM09LejZFemd2QnBuMWh6TTlFdCtUaC9KcnhsWHVvQ1JB?=
 =?utf-8?B?SFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6902C5FDF191734F80911C0658037040@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7b2f01-5826-4020-9945-08ddfc8a77dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 23:23:00.3108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E/t5I5IZl0GgGJAmmUYY7okz1F7T8sHFXFkQIP5hq1PEKz7EeXnEhPK/MEbNCj3NbQP0mgvYsrVxNmBj7Eys3aj7gwKVUGGwn0P1Z7lvVLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8087
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTE5IGF0IDAxOjI5ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBU
aGUgZXhpc3RpbmcgYXNtL3NoYXJlZC90ZHguaCBpcyB1c2VkIGZvciBzaGFyaW5nIFREWCBjb2Rl
IGJldHdlZW4gdGhlDQo+IGVhcmx5IGNvbXByZXNzZWQgY29kZSBhbmQgdGhlIG5vcm1hbCBrZXJu
ZWwgY29kZSBhZnRlciB0aGF0LCBpLmUuLCBpdCdzDQo+IG5vdCBmb3Igc2hhcmluZyBiZXR3ZWVu
IFREWCBndWVzdCBhbmQgaG9zdC4NCj4gDQo+IEFueSByZWFzb24gdG8gcHV0IHRoZSBuZXcgdGR4
X2Vycm5vLmggdW5kZXIgYXNtL3NoYXJlZC8gPw0KDQpXZWxsIHRoaXMgc2VyaWVzIGRvZXNuJ3Qg
YWRkcmVzcyB0aGlzLCBidXQgdGhlIGNvbXByZXNzZWQgY29kZSBjb3VsZCB1c2UNCklTX1REWF9T
VUNDRVNTKCksIGV0Yy4gSSBhc3N1bWUgdGhlIHB1cnBvc2Ugd2FzIHRvIHB1dCBpdCBpbiBhIHBs
YWNlIHdoZXJlIGFsbA0KY2FsbGVycyBjb3VsZCB1c2UgdGhlbS4NCg0KSWYgeW91IHRoaW5rIHRo
YXQgaXMgZ29vZCByZWFzb25pbmcgdG9vLCB0aGVuIEkgdGhpbmsgaXQncyB3b3J0aCBtZW50aW9u
aW5nIGluDQp0aGUgbG9nLg0K

