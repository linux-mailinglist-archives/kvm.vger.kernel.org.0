Return-Path: <kvm+bounces-47316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF4B8ABFFE8
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 00:44:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69BF67A951A
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 22:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC9B23A9AD;
	Wed, 21 May 2025 22:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I33kF1xw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A119239E85;
	Wed, 21 May 2025 22:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867438; cv=fail; b=DGSvXkzWt8krOdBwJ7VGew7GRqedc7sA/RVeOxHsBBCWrzNyB9g0IPXI7Jpo0IH/Rd9ga84J/nYcIG854lRBw3aqyPDuUfEYs1UAgse8qQjJgFYtqX353KERnsrwfWEJYUuyeT/YdWdeyoRDXUKbavPtUc94bGqghX4Tz3lTyLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867438; c=relaxed/simple;
	bh=ad7nYHEvA3FiFoL5sChx8Ylju+Hu8BNf4UUWOrXQ6Cw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gCtYJLs7e43026KajH4tFed7pCnq1mmM5T+mscBfdwVTSZ/vXq8Wx/k8UKoACpYhojHyUFaX34lA2qY/FjMBFgnj7N4KZ/7sFm/MCJr09D53tiOSy+P8yPT2VGgMTdrExiUdSu1iFjnxvxLy8FoohRNf74r7Non7cAjtj4lGN1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I33kF1xw; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867437; x=1779403437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ad7nYHEvA3FiFoL5sChx8Ylju+Hu8BNf4UUWOrXQ6Cw=;
  b=I33kF1xwXYe0CUnFlHAX9FKPcBFl34FBAJooNil8ll7LCpNZufmA6dfr
   F2/72Il5eOt/5LMnD8LAOGQ7hRI9UpI4twWQQzxvLCHK+lRAAQ4AUAqUp
   lJl9r+t8EEIVdoo2IAdrGyLvsJSbsyb7HT6dU+cIGfq5V3zY1RDAmtwdp
   DHCrKCGgGnwT6jS4W70SwwhWwrf2wG4G9G4UP5qSWqSiFFbVfq4kDTgr+
   HLkRHjjODkgLoeJ+xkgYFX6AJXP40DeUC+WbSRABqsmbamawEqysOANsG
   cii1NFMkU9OQ67GrIYCv9R7E+qTJaanzalF/mWv8JJDtvls0LaM4DpBFY
   w==;
X-CSE-ConnectionGUID: Cu8qMPlhTV61+2P7pcinaA==
X-CSE-MsgGUID: 2kcF1Lp2SdSL5W9c9iAagg==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="48991751"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="48991751"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:43:56 -0700
X-CSE-ConnectionGUID: FvBiXP7STCCxX6wRYWJnVQ==
X-CSE-MsgGUID: oE91ROeWRtigOC/lbfENrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="171158828"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:43:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 15:43:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 15:43:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 15:43:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjOXWbbeLVOJq9MMT0L5yQ/nr/iL+5wTs8XqpYuzTahNk6Qz12mVn9wQzSy7W4wJMTXoJKsWIRd4exe+H+e5qIi0GTXeOROVar33xKL6B6tP1sG5RILpQR3Cx0Ejna1NqrWZBsp+J0NaLFvTFtytelhWfWgky0Dz0i65ZT91b9YjpwNrnIPaI9v84PGN4so7LVDDrM8M+M3oFMyl7tusMpNKBDPAHF4aQa59kIdpcVMOLBWkEiOOztl9+X+me69i/Pw5ZFcYioJbNmzJJK60FR1hmzZr8r71szZ6vesEaKfAWvqao7sfZUvwG3Rb1g8hAeJw0R5G9u1Dmb91/sXKLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ad7nYHEvA3FiFoL5sChx8Ylju+Hu8BNf4UUWOrXQ6Cw=;
 b=AqUVKtO9TDgjIgtBj2f27N6XW35O/KcH7EXPSFHkyU+xAxhr3j6wENx0j0ZASssv0F4NWv7Bqe9zWPyqTZNXyY13FrGDcVUAAKUINSNtm5JH40GBfvAsCm0Gc8h6gsB4HPborJ+bscA92W6DZb5GLw/I0g9Uxx4d56kkYq8ROOV36UEbFDVvYmh8ipzn8szwUoETlv1KDquhujY7gVuzE8/YlOUzxTVHCGynbAjHYZoa9QEU4mhOr1w8Chlq9rVzH6LzpLeuNdMx+M0i1/hrbMlTU1G4za6B9pUKI07gTlg0VdPA7M/lahtACB+eLMxiFvFXBDc83nnRLf5ZpflEAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MN2PR11MB4726.namprd11.prod.outlook.com (2603:10b6:208:269::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Wed, 21 May
 2025 22:43:53 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8746.031; Wed, 21 May 2025
 22:43:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "vipinsh@google.com" <vipinsh@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
Thread-Topic: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
Thread-Index: AQHbxq0+OB9mwly9vEqEwiQpLwdhbLPWwyGAgANXzYCAAgqsAIAABhSAgAAM2QCAASEUgIAAXKwA
Date: Wed, 21 May 2025 22:43:53 +0000
Message-ID: <918715044bf0aa6fb51ce511667bf7bb4ccbabea.camel@intel.com>
References: <20250516215422.2550669-1-seanjc@google.com>
	 <20250516215422.2550669-3-seanjc@google.com>
	 <219b6bd5-9afe-4d1c-aaab-03e5c580ce5c@redhat.com>
	 <aCtQlanun-Kaq4NY@google.com>
	 <dca247173aace1269ce8512ae2d3797289bb1718.camel@intel.com>
	 <aC0MIUOTQbb9-a7k@google.com>
	 <5546ad0e36f667a6b426ef47f1f40aee8d83efc9.camel@intel.com>
	 <aC4JZ4ztJiFGVMkB@google.com>
In-Reply-To: <aC4JZ4ztJiFGVMkB@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MN2PR11MB4726:EE_
x-ms-office365-filtering-correlation-id: aa256570-efee-4957-e847-08dd98b8f670
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WUVRUi9TQTFWUmlVazN6VW9Od1hBMElWS1VHMHpnbE5HYXlvTEZjRnRxejU4?=
 =?utf-8?B?d3haMXlqL1htK2tBcys1Tmt2Q3gwU3cxbWk3WTY1emVBVytOdGFLOEdMWDFY?=
 =?utf-8?B?SURrejRwcy9oUVVwOVU2YkJnZTJLMW9QUk9qbTcvR01wR2syOXpQWXE4TlRp?=
 =?utf-8?B?dlR4aDNQUzVkVXlZSlJiWVprZ1NpQ2MzaVRHZUVHbm1ReXFwYno0QlZBRnlP?=
 =?utf-8?B?MEQ4V1JTMG0vd2ZpY3NoN2NSSDkxZE5ZKzRhdUVMY0FnWkU4RTNPUVpEN1VQ?=
 =?utf-8?B?NkQwWDlsSGFEL3hKSi9FUDlnYWVseTE0ZXNUY3dXSW0wU2lpSGJrU0p3UjE0?=
 =?utf-8?B?UzYzeFZ3VWpaZ3k5bjk5L21QaVpqcG1Za0dVbStlL2tZZ0FZbmlaRFdINHVa?=
 =?utf-8?B?RWcvQ0gxLys3VlZRenVrTkUyVm5xRWZGenRnMGMrc1BBVVBsMHI1K0xBMVg5?=
 =?utf-8?B?WVJhRkFKckZGcVlHLzZsek1BbEIrdjZHSFI3c2c2V0x5OFJ5OWsySWZMaEtv?=
 =?utf-8?B?Y005dC9wTUE4U1k0QW1OUVVWRHdWbkpGVW9PVkhKellLQXpYYUg0elJtaFE3?=
 =?utf-8?B?Nkpvanl4YzBkK3QzUFdYa2xrVlROWVpsUlZYZFNzYUR2b0Jrb0orVXZ3bloy?=
 =?utf-8?B?aE9kcGs0M1ZUVHkrZWhPdnYxdmhTOVpOQTJPcnROdnZkQWZHNzdSbzdxTEVa?=
 =?utf-8?B?WFE0RlpyaVlldTFORXVWb2ozMEptQ3E0SXBUWUZEU0NEVHVHenNvV2xrL3Fa?=
 =?utf-8?B?UHVFUjA1cVptTmxBZVIrTnhWcjhucFlQMWl2K29DQ2VHWVEwbDhSMkI2K2R3?=
 =?utf-8?B?YXBhVmlyQjlra21iQ3BVZE1YU2toZGZoQXd6THRyTlZhTEdUbkx4QU05VWUr?=
 =?utf-8?B?dmdVZUM2c2VZTFl3Z096ejY0TmJ4V0M1aStCc2RpdVVuZWl3eGVFdWZlQ2R2?=
 =?utf-8?B?TjZCRkJoclNMOGhxMDVoQlZmb0lrT0VpT1UzQjJ5Q3Nlajh2SnFISm5tMXgy?=
 =?utf-8?B?Tzllc1dmRm1yS1hhdXdqQ2Q1U2RPS0puTkJ1UC9BZkVLSzZHV2dSb3FvUEM1?=
 =?utf-8?B?S2laS1BsL0doTzJtRE5lZUlRVDBPdWs1WW5KdVdKdmZaQmdEamcxN3BSR3J0?=
 =?utf-8?B?ZjVrV2xWYzZ2TCtlaUVlSi9GbEtOcDRWanNHcW9XZnIvemJkTmlHZlQxM28x?=
 =?utf-8?B?QWpEZ21nR1JHcG9QZ3d6NU9xRnByWDdJbG9GdDJRd0RLNUJWNFVtc1lmUytv?=
 =?utf-8?B?Q2FWcS94bzB3cDJ2WHBncW84QkYrMkY3QmFqSUlYd2k1NU10aFBSUFN5eUZp?=
 =?utf-8?B?YWs2Nyt5RGVzWjJVdEp6bXRUTXp6ZS9URmduNGdzbGIwSmJBNnhpMTNXekVs?=
 =?utf-8?B?Q3RLT1F6R1FXb2FGTkxCU1Y5VTNkYkVjaGpPOUlYMzJreXppTXF4ZzRiOEEx?=
 =?utf-8?B?cVlSd3FuNjNEVXQwaW1icExiN01NYysveDFyblRreVRlRVZBN1pTUGdDNGt5?=
 =?utf-8?B?NjZCRnVWQWkwSXpjVWFpSmhweWphM0VQeFh5Z3JsYXJrSTcyNWsyQXRURkp6?=
 =?utf-8?B?S1R1SWpnNzFlVlYwVHJubXNMNG92SVBCcCtDYlpSS1NvR3U4L2lQeldaNmNi?=
 =?utf-8?B?UTFMRnFiVjlicmNOWkNZb0xWaVlVQVlFSTd2NFIzVDdhR0VyQ3lZMUl1ZW96?=
 =?utf-8?B?RFJ2MGI2c1ZnOVJnakZuSkZZdmFubUFRc0ZpRWU1MTV6anpCNzRYaHozdzVo?=
 =?utf-8?B?TkRSWkdXMnNTWllSRzM4ckxORytEZ1JWNlJXUjIwNW4zc0NTcEZ5QWtUbmtw?=
 =?utf-8?B?Z0RkOGxSc3U1cW5SbXpLMjZkSWx5eERlSUZGZktleEREWll1RG1XUUwraEpu?=
 =?utf-8?B?QVRsSkxZVHNtWDVqbCtTcjQ5TlBINWpncERYMytoOHpUSGdrQ2wrRDBydmFk?=
 =?utf-8?B?UjN0d0xLbG9QSlNuVTlxLzFYcHd0R2RhbkVyalNkeEIvL2luVTIrRys0SW1C?=
 =?utf-8?B?YTFDbDNjYmR3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjhVVVI0b3I0RGVPcDF6aHBINjlWcGRQVzJhL0U4ekVmdGVKaTltUG5UY2pP?=
 =?utf-8?B?SzVqeEt5bWVWRlI5SzI2bzNjRENKanZ4SWZDOVVSUEJuSUVRL1JRVXV4ZDB1?=
 =?utf-8?B?anA1c1pzcDVxLytOZTVFdDd4Lzg5VUhDTlNBMlpFTUs4TnpvUDlYVEY0ZWhv?=
 =?utf-8?B?VFZQMWtHN2xNTkZqMnVOaXFTcmgvQUNtTDlHdzZIOEpqWTVvRGYyUnAvUFBn?=
 =?utf-8?B?Q3NrTlU2T2QyQzh4bXA2eFcvcG1KMzdISEFzaDNjVWNNeEFVWUw0UDdsaHBL?=
 =?utf-8?B?ZFltOXBjYTRPdUJlVlRuVmJ3OG8wVnlEUUZFNGFvWUJUbnF2NEhLVldzSHM0?=
 =?utf-8?B?R21NOUJDV243L1dpSTlSaWVMOHpkeTdnQkhzRmd0bkpYaFFmeE9oajlha01R?=
 =?utf-8?B?UW1TZ1lQeVpGVnhOZkRjakxSazdBT1VVbUJ1MkVjZy85L1AwS09xVnZqelpp?=
 =?utf-8?B?cXovZ3NjWlZoamdXVEZMc3c3T3Jxb2NrdGpUN0QxeG53UzNzMnBlamZmOGZ3?=
 =?utf-8?B?YUI2NGZZT0VLb3hQenF2MEVjZkZtR2JSaUJ0a08wNEROZ0wwS1NxUjdkNzRH?=
 =?utf-8?B?L0MxN0lOSVlNWnRpVzdUakZacXFqUW5vRDZBRGh3MlM2cVl3dXVsbzNhZlND?=
 =?utf-8?B?TEhUQmNycDdOVU1vL0xhTWxVNDdNR0hRQzhsQUpZdmRKWEVvN1hMcWVoV1lL?=
 =?utf-8?B?Sit2MUxFblZ2eDhETWpXMThkQ3JLWVdnVGMwdzNtUUE2R1NQNjFFclRXUVBy?=
 =?utf-8?B?bkY1UmkvVVIydDVVTDJUU1RWeVZGK2xWMnFxaVdhNXh2b2UvYTBUOEVDZEJr?=
 =?utf-8?B?Y3RXbzFuT3hKT1FMVFlHQ21yN0RDVm5uUjdaMjQxTURYWnJ3YjR2ODk2M1JQ?=
 =?utf-8?B?Z3RMb3BPZlR3VE5GZXR1SWwyQXVrMmYvWWVYaENVWEp3VWR4SVZZZHpBaTRl?=
 =?utf-8?B?QXErYmhGWmdqcDVMODM1dGZBQjlWY0Y4OVdDYU5pQ2dpMVI0azd3eFdsdUg0?=
 =?utf-8?B?RUhwTllmYStIVGRDQ09jbzAzKzgwOGt5VzdoK29YazRvdlp3VkptWWdVMkl1?=
 =?utf-8?B?cW9YdkdxQ1V2L2Q1Tzl3MWMxNUcyMVA3bHladElHRjNadkF2OTBET2g2a2k4?=
 =?utf-8?B?Z0JYVnZ4QTY3SzFTOHhiUTRZaTdPaVQvRGkvSHpSZXcycDhzRmhCckxQK0ZO?=
 =?utf-8?B?SlBpZmRCWitRQW1ianJHU1NDc2I1aTNpeS9CMVBSVUlmN1pQaEpQeDdFdTNY?=
 =?utf-8?B?OHNDYmRxRjh5U2k1YUNNYTNVcHE2bFQwdk8zQVJNZmZSQjM0SWd5MTFOMkpm?=
 =?utf-8?B?NytRVGpuMGpBazlqcVYrOU5CUVZxa090MjhyT2RKQWFtaGVrdW9vcHJJYnV2?=
 =?utf-8?B?WjZWVG5JeFhWY3N3RlNmekttN3Q4blZOTXlGamUvdzhxdlFrYVRLcE9hMm1n?=
 =?utf-8?B?OHhVd0hCeC9NNHkrNERrekNYZkFvMnhicGlldTdsUUlEYmdZaTlvdUtnNzVl?=
 =?utf-8?B?eFh1ejVsdThYZzJxOWhyS3UwQVpURFNxdS9iY1htdmUrbmFQSjRGbFFlUks2?=
 =?utf-8?B?WXZkanVNK2hpb2NyejdHa1JtQXBjRDN4YWNTOUtRdEQwY09kSUMyeUhvRkhR?=
 =?utf-8?B?R0RFd1dnNlpEWXlERWlnT05vdzdWQlcvVHV4cnltbTk5d09rU2pkbzM1ZkN6?=
 =?utf-8?B?bm9EalVRMjJObHdWY21MQjE5MC9vYVBoRzZ2RVhuNmptZnlKd094bTRZcUhq?=
 =?utf-8?B?ZEl5ZWV5UjB4VU56amxlS1c0STJzeHBVelIrY1hYRFVkV0Iwa0NSUS9qeHA5?=
 =?utf-8?B?Z21teVhubXM3UGVqakNFUGJMVzg4Njc3dnFBNGJoR0lUTnVkQW96N2ZkWWFu?=
 =?utf-8?B?WGdXMVYwR3BQaWNhZHBSTVlIZnhaeUlqclFFOC9RWmd3SXBJMjVtbElFaUo2?=
 =?utf-8?B?c1UzMzdsNGN2RUE0b0F5MUtnOFJzZUpsMHE3K0l2MVZZb3ExdlZOM04zSWFl?=
 =?utf-8?B?Y0x4b2lDMjhsWjlKc2M5dzA2SElSNnBpTjdGdGthaHNzeGxKd014VXhvSFNR?=
 =?utf-8?B?YXFrcC9QOW8weGdtUXlOREVtQ1ZQaTlhVUxzTEcxQnYySUxvejRwZlRabEtt?=
 =?utf-8?Q?Hq8gJvcx9m1zGKVn4pViHI1we?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E8F0AEF24A1C24C9DCCE0194C0871B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa256570-efee-4957-e847-08dd98b8f670
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2025 22:43:53.2045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mknIaFqC6aJKJjGUpWgxZt5qCXo5HeN+06jG/owXDYxXp8RJrjlwiRCO7O43eY8B7sKxsWMuszBkStIfUg5R2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4726
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA1LTIxIGF0IDEwOjEyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE1heSAyMCwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNS0wNS0yMCBhdCAxNjoxMSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFR1ZSwgTWF5IDIwLCAyMDI1LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IE9u
IE1vbiwgMjAyNS0wNS0xOSBhdCAwODozOSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90
ZToNCj4gPiA+ID4gPiArc3RhdGljIGludCB0ZHhfc2VwdF9yZW1vdmVfcHJpdmF0ZV9zcHRlKHN0
cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiA+ID4gPiA+ICsJCQkJCWVudW0gcGdfbGV2ZWwg
bGV2ZWwsIGt2bV9wZm5fdCBwZm4pDQo+ID4gPiA+ID4gIHsNCj4gPiA+ID4gPiAgCXN0cnVjdCBw
YWdlICpwYWdlID0gcGZuX3RvX3BhZ2UocGZuKTsNCj4gPiA+ID4gPiAgCWludCByZXQ7DQo+ID4g
PiA+ID4gQEAgLTM1MDcsMTAgKzM1MDcsMTQgQEAgaW50IF9faW5pdCB0ZHhfYnJpbmd1cCh2b2lk
KQ0KPiA+ID4gPiA+ICAJciA9IF9fdGR4X2JyaW5ndXAoKTsNCj4gPiA+ID4gPiAgCWlmIChyKSB7
DQo+ID4gPiA+ID4gIAkJLyoNCj4gPiA+ID4gPiAtCQkgKiBEaXNhYmxlIFREWCBvbmx5IGJ1dCBk
b24ndCBmYWlsIHRvIGxvYWQgbW9kdWxlIGlmDQo+ID4gPiA+ID4gLQkJICogdGhlIFREWCBtb2R1
bGUgY291bGQgbm90IGJlIGxvYWRlZC4gIE5vIG5lZWQgdG8gcHJpbnQNCj4gPiA+ID4gPiAtCQkg
KiBtZXNzYWdlIHNheWluZyAibW9kdWxlIGlzIG5vdCBsb2FkZWQiIGJlY2F1c2UgaXQgd2FzDQo+
ID4gPiA+ID4gLQkJICogcHJpbnRlZCB3aGVuIHRoZSBmaXJzdCBTRUFNQ0FMTCBmYWlsZWQuDQo+
ID4gPiA+ID4gKwkJICogRGlzYWJsZSBURFggb25seSBidXQgZG9uJ3QgZmFpbCB0byBsb2FkIG1v
ZHVsZSBpZiB0aGUgVERYDQo+ID4gPiA+ID4gKwkJICogbW9kdWxlIGNvdWxkIG5vdCBiZSBsb2Fk
ZWQuICBObyBuZWVkIHRvIHByaW50IG1lc3NhZ2Ugc2F5aW5nDQo+ID4gPiA+ID4gKwkJICogIm1v
ZHVsZSBpcyBub3QgbG9hZGVkIiBiZWNhdXNlIGl0IHdhcyBwcmludGVkIHdoZW4gdGhlIGZpcnN0
DQo+ID4gPiA+ID4gKwkJICogU0VBTUNBTEwgZmFpbGVkLiAgRG9uJ3QgYm90aGVyIHVud2luZGlu
ZyB0aGUgUy1FUFQgaG9va3Mgb3INCj4gPiA+ID4gPiArCQkgKiB2bV9zaXplLCBhcyBrdm1feDg2
X29wcyBoYXZlIGFscmVhZHkgYmVlbiBmaW5hbGl6ZWQgKGFuZCBhcmUNCj4gPiA+ID4gPiArCQkg
KiBpbnRlbnRpb25hbGx5IG5vdCBleHBvcnRlZCkuICBUaGUgUy1FUFQgY29kZSBpcyB1bnJlYWNo
YWJsZSwNCj4gPiA+ID4gPiArCQkgKiBhbmQgYWxsb2NhdGluZyBhIGZldyBtb3JlIGJ5dGVzIHBl
ciBWTSBpbiBhIHNob3VsZC1iZS1yYXJlDQo+ID4gPiA+ID4gKwkJICogZmFpbHVyZSBzY2VuYXJp
byBpcyBhIG5vbi1pc3N1ZS4NCj4gPiA+ID4gPiAgCQkgKi8NCj4gPiA+ID4gPiAgCQlpZiAociA9
PSAtRU5PREVWKQ0KPiA+ID4gPiA+ICAJCQlnb3RvIHN1Y2Nlc3NfZGlzYWJsZV90ZHg7DQo+ID4g
PiA+ID4gQEAgLTM1MjQsMyArMzUyOCwxOSBAQCBpbnQgX19pbml0IHRkeF9icmluZ3VwKHZvaWQp
DQo+ID4gPiA+ID4gIAllbmFibGVfdGR4ID0gMDsNCj4gPiA+ID4gPiAgCXJldHVybiAwOw0KPiA+
ID4gPiA+ICB9DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiArdm9pZCBfX2lu
aXQgdGR4X2hhcmR3YXJlX3NldHVwKHZvaWQpDQo+ID4gPiA+ID4gK3sNCj4gPiA+ID4gPiArCS8q
DQo+ID4gPiA+ID4gKwkgKiBOb3RlLCBpZiB0aGUgVERYIG1vZHVsZSBjYW4ndCBiZSBsb2FkZWQs
IEtWTSBURFggc3VwcG9ydCB3aWxsIGJlDQo+ID4gPiA+ID4gKwkgKiBkaXNhYmxlZCBidXQgS1ZN
IHdpbGwgY29udGludWUgbG9hZGluZyAoc2VlIHRkeF9icmluZ3VwKCkpLg0KPiA+ID4gPiA+ICsJ
ICovDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGlzIGNvbW1lbnQgc2VlbXMgYSBsaXR0bGUgYml0IHdl
aXJkIHRvIG1lLiAgSSB0aGluayB3aGF0IHlvdSBtZWFudCBoZXJlIGlzIHRoZQ0KPiA+ID4gPiBA
dm1fc2l6ZSBhbmQgdGhvc2UgUy1FUFQgb3BzIGFyZSBub3QgdW53b3VuZCB3aGlsZSBURFggY2Fu
bm90IGJlIGJyb3VnaHQgdXAgYnV0DQo+ID4gPiA+IEtWTSBpcyBzdGlsbCBsb2FkZWQuDQo+ID4g
PiANCj4gPiA+IFRoaXMgY29tbWVudCBpcyB3ZWlyZD8gIE9yIHRoZSBvbmUgaW4gdGR4X2JyaW5n
dXAoKSBpcyB3ZWlyZD8gwqANCj4gPiA+IA0KPiA+IA0KPiA+IEkgZGVmaW5pdGVseSBhZ3JlZSB0
ZHhfYnJpbmd1cCgpIGlzIHdlaXJkIDotKQ0KPiA+IA0KPiA+ID4gVGhlIHNvbGUgaW50ZW50IG9m
IF90aGlzXyBjb21tZW50IGlzIHRvIGNsYXJpZnkgdGhhdCBLVk0gY291bGQgc3RpbGwgZW5kIHVw
DQo+ID4gPiBydW5uaW5nIGxvYWQgd2l0aCBURFggZGlzYWJsZWQuIMKgDQo+ID4gPiANCj4gPiAN
Cj4gPiBCdXQgdGhpcyBiZWhhdmlvdXIgaXRzZWxmIGRvZXNuJ3QgbWVhbiBhbnl0aGluZywNCj4g
DQo+IEkgZGlzYWdyZWUuICBUaGUgb3ZlcndoZWxtaW5nIG1ham9yaXR5IG9mIGNvZGUgaW4gS1ZN
IGV4cGVjdHMgdGhhdCBlaXRoZXIgdGhlDQo+IGFzc29jaWF0ZWQgZmVhdHVyZSB3aWxsIGJlIGZ1
bGx5IGVuYWJsZWQsIG9yIEtWTSB3aWxsIGFib3J0IHRoZSBvdmVyYWxsIGZsb3csDQo+IGUuZy4g
cmVmdXNlIHRvIGxvYWQsIGZhaWwgdkNQVS9WTSBjcmVhdGlvbiwgZXRjLg0KPiANCj4gQ29udGlu
dWluZyBvbiBpcyB2ZXJ5IGV4Y2VwdGlvbmFsIElNTywgYW5kIHdhcnJhbnRzIGEgY29tbWVudC4N
Cg0KSSBzZWUuDQoNCj4gDQo+ID4gZS5nLiwgaWYgd2UgZXhwb3J0IGt2bV94ODZfb3BzLCB3ZSBj
b3VsZCB1bndpbmQgdGhlbS4NCj4gDQo+IE1hYWF5YmUuICBJIG1lYW4sIHllcywgd2UgY291bGQg
ZnVsbHkgdW53aW5kIGt2bV94ODZfb3BzLCBidXQgZG9pbmcgc28gd291bGQgbWFrZQ0KPiB0aGUg
b3ZlcmFsbCBjb2RlIGZhciBtb3JlIGJyaXR0bGUuICBFLmcuIHNpbXBseSB1cGRhdGluZyBrdm1f
eDg2X29wcyB3b24ndCBzdWZmaWNlLA0KPiBhcyB0aGUgc3RhdGljX2NhbGxzIGFsc28gbmVlZCB0
byBiZSBwYXRjaGVkLCBhbmQgd2Ugd291bGQgaGF2ZSB0byBiZSB2ZXJ5IGNhcmVmdWwNCj4gbm90
IHRvIHRvdWNoIGFueXRoaW5nIGluIGt2bV94ODZfb3BzIHRoYXQgbWlnaHQgaGF2ZSBiZWVuIGNv
bnN1bWVkIGJldHdlZW4gaGVyZQ0KPiBhbmQgdGhlIGNhbGwgdG8gdGR4X2JyaW5ndXAoKS4NCg0K
UmlnaHQuICBNYXliZSBleHBvcnRpbmcga3ZtX29wc191cGRhdGUoKSBpcyBiZXR0ZXIuDQoNCj4g
DQo+ID4gU28gd2l0aG91dCBtZW50aW9uaW5nICJ0aG9zZSBhcmUgbm90IHVud291bmQiLCBpdCBk
b2Vzbid0IHNlZW0gdXNlZnVsIHRvIG1lLg0KPiA+IA0KPiA+IEJ1dCBpdCBkb2VzIGhhdmUgIihz
ZWUgdGR4X2JyaW5ndXAoKSkiIGF0IHRoZSBlbmQsIHNvIE9LIHRvIG1lLiAgSSBndWVzcyBJIGp1
c3QNCj4gPiB3aXNoIGl0IGNvdWxkIGJlIG1vcmUgdmVyYm9zZS4NCj4gDQo+IFllYWgsIHJlZGly
ZWN0aW5nIHRvIGFub3RoZXIgY29tbWVudCBpc24ndCBhIGdyZWF0IGV4cGVyaWVuY2UgZm9yIHJl
YWRlcnMsIGJ1dCBJDQo+IGRvbid0IHdhbnQgdG8gZHVwbGljYXRlIHRoZSBleHBsYW5hdGlvbiBh
bmQgZGV0YWlscyBiZWNhdXNlIHRoYXQgcmlza3MgY3JlYXRpbmcNCj4gc3RhbGUgYW5kL29yIGNv
bnRyYWRpY3RpbmcgY29tbWVudHMgaW4gdGhlIGZ1dHVyZSwgYW5kIGluIGdlbmVyYWwgaW5jcmVh
c2VzIHRoZQ0KPiBtYWludGVuYW5jZSBjb3N0IChzbWFsbCB0aG91Z2ggaXQgc2hvdWxkIGJlIGlu
IHRoaXMgY2FzZSkuDQoNClN1cmUgOi0pDQo=

