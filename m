Return-Path: <kvm+bounces-21463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A349C92F2D5
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 01:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 306A41F2152B
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 23:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D841A01B0;
	Thu, 11 Jul 2024 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZqoyIVp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99EB4F1E2;
	Thu, 11 Jul 2024 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720742104; cv=fail; b=jYUKEUxTVSjylBy0zG1ddm6nOimv214ovvVu2zpQ+2vO1OJrjbplYbpsw9ODlQ/Y0fMK3qarxD8Bs/Gvzmfu3bmgp9YvaqrtcBMV72AacBo2+yQmBb0h+9eFLRG65UF3q/dYZ88vxXiBXzRbzk6wPDMiObTX68jfTxqBR5NF+Zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720742104; c=relaxed/simple;
	bh=6teyb3ZzOeKr9A66H5AUUmCQH8GksVELMyAM9uktl3Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Tv9PkwtpjZYEEomwqrzQTQ6q3wfVlovNZdtzDCxbLFq/U327qymK5GG+8qwrBvvNYYJuVgzhHYv9RpAT+jJ6r/yGhqK/teHoBUiiIDd/RdWLoT3MQ3FiNiiwFTYjI+J44ajy7m2YHz9asuJzSHL9bM0W5mEc5deI+3O8mtQNjZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IZqoyIVp; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720742102; x=1752278102;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6teyb3ZzOeKr9A66H5AUUmCQH8GksVELMyAM9uktl3Y=;
  b=IZqoyIVpX6eTzjfXf616ppQ1OnD7RajYyF0HtmzO52jaJasd5tRgaEiU
   nxuG4Mc5P1jXww1UgMaGFQiOqfwH3H2z6UUEm8I49937vIIejiMJ2j30S
   jrcqJSsAg7LIkchXhjuMv0eSkg8HqaoCvL9UIJfcP5SdGfHf1hv+NdhWm
   nkTsE3uOutj+wfOLi2I8XgF6ErjhmhQawgV5b7qoICIzV4XY3wzzS6mqf
   4iOTaPDsOhl9lCzY0sYWMC5xLDYqQLJHsMyj8SRuyg10Qt52S+ZJcxu5M
   tQi2iuRUztIjv5ogeSjN/a9waEFKgh9ePzYgBqe3o/0Wjm5Qh/dSwjayQ
   Q==;
X-CSE-ConnectionGUID: CoF65xwAQVOZAX7+kIpnOA==
X-CSE-MsgGUID: uy1Or3UrSTGeQdOw6qDO4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="17983942"
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="17983942"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 16:55:02 -0700
X-CSE-ConnectionGUID: 1biHe2wTSymoT4GkDo7TsA==
X-CSE-MsgGUID: uXAH/CZSRU6D+edxumz/VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="53659720"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jul 2024 16:55:02 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 16:55:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 16:55:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 11 Jul 2024 16:55:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 11 Jul 2024 16:55:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYzHWKy/3SaJoz+jmE8kzU6Gi8g37O/SjGY5MEQsvEVesDU/s53igHSxZ9RUvua+kGhQaDB+Ri484u1WBDsDJexSx8FMesdAG3CSbIMs/gpCvTKcpQ9OuCHBHgr1jrLSR91hzvgr1AnJXSTZ5RigIVFVPSKu1znFkWcDEn9W1mnjzcrITkmsT7kXIAZufQn22UUFKPOl9J8sm278tMDTR07jU3raf8JqNnmORwjvepuxjTBRkJZdXM2De6bt4jPwsHRZ6CJLLQjqBeR2k0+f18pITJuP/R6bdbJEJrqQ2ze2uVUztT9q93BhqhivRXX7ZTKQwq+pQNQKdMMz+AzXBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6teyb3ZzOeKr9A66H5AUUmCQH8GksVELMyAM9uktl3Y=;
 b=b0B/xoAZDu3t1cihjXRbBhwTJMCXMbb0x4bnx6x2joGRxf4TNMoMTiJK1/91Gwbsrcc/oI8VgAMg3B8GzpIgWLXJv81GhEVa7jhbGm8+ELUh4MACpNEntl6NQGxRBc4b1lH2Yx7fmn5N98DhTdkoEmAwUsgN48L3YIKRGm2eNpaCuvi9mNSCM0MedSeV75pOtPh57KlE8XZ9ji/AcGJak5/9X8RNw43J27un3WNncE2/Bl4KC1pgYgmdX7nR/RLe7MEOxBr7UdGFYRsLX8LQjZsNoFTgWinPy4xFGY9m/I+mfJFUPXzQOtlVXsIeYUCvqxWoaMF2azHJFamxo9hzBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB6052.namprd11.prod.outlook.com (2603:10b6:208:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Thu, 11 Jul
 2024 23:54:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 23:54:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Topic: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Index: AQHawpkqUontib46sU2zk5qqIlBj6LHmWZoAgAjCjQCAAzoUgA==
Date: Thu, 11 Jul 2024 23:54:50 +0000
Message-ID: <03eccdf96e917e178acbc3cc53a965328a5690b6.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
	 <ZoZiopPQIkoZ0V4T@yzhao56-desk.sh.intel.com>
	 <81b3bfa46a457ba19ce32e7a34b793867ebeebbe.camel@intel.com>
In-Reply-To: <81b3bfa46a457ba19ce32e7a34b793867ebeebbe.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB6052:EE_
x-ms-office365-filtering-correlation-id: a5b6b22a-a990-4bb7-89a6-08dca204da54
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SmRFbUhZZlExYlpxVllKTXpkREN1MFRnc3I3YXdUL2VabkFnSENORElzRG1Z?=
 =?utf-8?B?ZU90RndRb2NRK2FKSGdzcjVBN2ZWZHNMY0YrZ2FUZjIvYWZ3M29ZTU9BQUlF?=
 =?utf-8?B?U01MZ2NCZy9tUVZwaGRlVDQ0dDJzSSs3UDUzeXk3a1ZQa2dZU0hIVjNCSTQ0?=
 =?utf-8?B?ZmMvak4zaTRNeEtlamhyUUxzTVFJa1RURUx0Y2UwaThoN1hGZVZNZUI1a3Bl?=
 =?utf-8?B?bFVhdXZ0Q1hzT2wwWVJTQU00MnNWSUVEdm42ejdWSDVHL0Z1dDVMcjVUWGVK?=
 =?utf-8?B?c0NJaEd2T09mZUFRNWRjaFlocEdQZUJPaGwwSHhwR1BKYzl6a3gyRklFRUtC?=
 =?utf-8?B?OGVqU3drcXVVaTN5TVJJOHlSUU1VMWxyamFhMUpKNGgyb2lTb1BGZzRmSEhX?=
 =?utf-8?B?Ky9iZTh4ZWZPMWJFMkJSbDRhZHRHSDlLVkFJN25ESFJ2U0NQajdTdWt0bkxq?=
 =?utf-8?B?VjQvcEM1S0JHSFhCaVRVQUlKN2Urb0w5T2dyNXp3VThOcFQvUlpqemNoY0hB?=
 =?utf-8?B?NEhId1pkS1FYRnUvcllIZlJoSEZWaUV1bDcxNkY1Zy84azVKQnllY0F6UkZi?=
 =?utf-8?B?TFVBdGxjRVFYSWpmUXFYOGxHZURnbXUyN3RybTR0eDhpQkhycHBlOG8wU2Jn?=
 =?utf-8?B?b0tHaDR2RmppcGlqQXd1UVc3SENGeG02ekxUK2pTYVE5ZVVlM3ZmZUJkN3JW?=
 =?utf-8?B?MUs4TEgrZ0YyZ05iZCtsZzRpUWEyOGZvaUhOWFhxaFBnVXFpMmp0TlYwSHh3?=
 =?utf-8?B?TUhqaU94RHBEQU45OEhhSWdrMkpEWGhGS2lwRGdySjBBNVFCOU0zSzN2L0xl?=
 =?utf-8?B?eFFWUTlDdmk2WTVOUWJNUWZVemg1OUhwZDE3S0JTNzJWVXpybGplWlNobkt0?=
 =?utf-8?B?VmNnY1pyMkpzeDQra3Z2bTVhRDJzR1pSc3dWSGQ2SmliSVBVdXNzUDVyOWVG?=
 =?utf-8?B?cXRxYjdicitzUzUzSU52cUJuUnd4NUtLTS9sekU4dmRwemZJdm8wNFNUWFl5?=
 =?utf-8?B?UjhwVDNHN3pOUEUwRzRIbndjSVc0MXlmeE1mTDNHYzlicXNBT0hueFFMZHA2?=
 =?utf-8?B?Rk5wZ292cDdKdXhINjJCMithRDJtVWc0QTdubkJmcXkwSzVCalkzbFZycWZU?=
 =?utf-8?B?Ny9KczloWW1ySVhmRUcvRHNxcmY5MjZhcmxNbXAySGJ5STd2NGY3RmFtK25R?=
 =?utf-8?B?NU5mUmFrOXZsK2NkV1QwLzNzem5qUnY2Vit0TVhpcEE2dHZaeWJRdlZLd0hz?=
 =?utf-8?B?SkUyL3IycDdUeE1DcGJtam9kM2dwa0UxQjBLc2FPSU9MWjRrRk9MS3VjM3dt?=
 =?utf-8?B?MURQT01IeFpRUEdVUVZiMm9EdWxCb2VtRm56QnRReExUQ0UxeExhTUtZWkVI?=
 =?utf-8?B?OHliNlpMZW5GenRKUTlncXVrVGpvUCtkQmpzYlg0L1FxM0lNS3RFaDVoVzUw?=
 =?utf-8?B?cjJiL1lQVFZMLzhYVmNhM1ZRNlE1SjRFYmlKVGJadG5WNmtPMFF4L0pNb2tw?=
 =?utf-8?B?SHYybFFqeEU2blk5c0FwaUJoRTFySjBId200QlVFdnRjWmNvZ005MXBjV0lB?=
 =?utf-8?B?ZndtMVlnUm9HQ2U3dUloRStxRHBKTEV1V2N6VGJRMkw0MUxhUDg4T0hmbDY4?=
 =?utf-8?B?ZHlKY243Q3JpaXVuakFFMkNMcWxNbzQxbGdhTklFTVkwMEQyTjcyUWx1enVa?=
 =?utf-8?B?TEFXZGVUQSs3QmpPNFJHUkMxaklqeUhZd2REOHhxT2oxOFhHWkVYYW5sWm03?=
 =?utf-8?B?disraW1MaERDcnZDWlk1ZFFqZC9JT3Q2eVBxd1VjODloODZZTDlCQ2pIUnlq?=
 =?utf-8?B?dlhnNWhEcFFZdk0yeVE5dVh1U0pvQ1k1eE9YK09SeExhKzlrTWUrcGpVSG1h?=
 =?utf-8?B?YjhMVlRqWEMwYlllWlNsTElDYmV0RjBCTnFHdzRpWUxwaVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWdiNlRaOXU0eUw5U3c4S2VDclBOZEZzZG1lYy9PdlViT1RJRmpVR0JZaFlo?=
 =?utf-8?B?U2J6REN6REFXUFJMa2NhZWR2SEVQalRTd0xLZjAzN3NoaXpTMFU3cXk4MHFi?=
 =?utf-8?B?dnlnRzZ0OCtRVSszMHMyQjNBVHZ0T3ovbVFhZXBsUnFhR0tXYmxBQ0IrSEpw?=
 =?utf-8?B?RVA3eUFxTi9STnVPMHliY1FxaFk0Q0wxdnBzaVRSa3ZoM2RUNnRSYnJvZmQw?=
 =?utf-8?B?MldPRTgrZTBHNEZRTC9PUVY4ZlNKVVNva2graVBNbWw2bXpXcGxPSXhyTzlO?=
 =?utf-8?B?Q1FLWEpKUlZOalJMbTlOS1k4NnJaOXAxTnEvSUdQdEJmRzZCeEo2TzlCMDU4?=
 =?utf-8?B?b3BLa1Z1azhaRXRYcm0yd0YvT0hjWEJ0c1NuWXB2bVNpK3dtcVZpd1VmTms4?=
 =?utf-8?B?amdtOWVJL1hlUS8wRVZNSisvQWJqVTNSUFl3Q1RNNXNCdXFIeG9RYWp0YlR2?=
 =?utf-8?B?MnZmVEswcFgyTUIvdHpwMXovZFBITEJRK1dlUmdrNnJqQ29vaTdSQkhTam4x?=
 =?utf-8?B?OWZFTitWcWtvaEhEQUpSWGxwbnhBMnVPVGpIU0JoN1IxQWlRcnhkckhqTFlQ?=
 =?utf-8?B?RmVKdFhEOUhieE94SExCY3pIeUd1UWVQR3ZSNDIvNzFtKzg2dHRuNFlNM0dn?=
 =?utf-8?B?TFR3U243ZUtja0dwbnQrT20wVXdIaS9GeHJnY2c0dE0yekZ1akdJeWQ1RTd5?=
 =?utf-8?B?S2tYZHVMUXBvKytlZXhSQzY2N2J4NjlJRWxMaXllamdKUUF4dnBWWmtzMCtr?=
 =?utf-8?B?WUdMY3hQQWlQdDJhTEsrMDlhYmVqMDZVSlJablFRZVlKR3orOFVyeG95K1kx?=
 =?utf-8?B?UEZXNTU3Q3d2Q3o2VHlDd2tIU1FiUzRJaFlocmE3amlrWWRNU0xzdU9QZ3Nh?=
 =?utf-8?B?Q214eUtvS0FndStoMjQyKzhkRHF2R2dGNGdTYlNwQjlyNjkrU1JFRmlqLzVF?=
 =?utf-8?B?UFg2ZytadW1uUW9MbVY0ZlRvTEk3ZGxRTlpXU2ZpRjQzRGZOZ0NTSFYrRm9t?=
 =?utf-8?B?dUhZKzVLcDQyWlBjd09XeDBkdmJZRkFVK3Z6MGw3QWprakxSUkUxY0diU2ho?=
 =?utf-8?B?eStzdkxJNmk1SHhwZTFmaGJCYU43YVptK09BakFVVTdFRGRjUkp2aEpFQUpW?=
 =?utf-8?B?SVdQSzVUOVlYQ2l3bDhJT3pzd2hlOVhnSEVZK3hOUWF5bFQzUVgwaTBtOXpH?=
 =?utf-8?B?ZzhRWFNlME1oT2dFSVdmQ2NxVUZPaXQyVlhqdmhjSDUrN25wRHU3VmcvdXBE?=
 =?utf-8?B?NUc5eUtBaXUrT2I3RlBFcVFydWRDNkpqV0FWZHAxLzg0VDRkZlZxb29aQ1Bl?=
 =?utf-8?B?S3V0bFcvNk9jdEJZN1F3V241ZVpqdnFrOUo3VW01RE5Eb3NsY3NjcWRsR2tF?=
 =?utf-8?B?SjZPTitnbzdVR04vVkQraVo1VkhTeWFpKzlQWStWN29UVElQQksrRVY1Q0ZB?=
 =?utf-8?B?RjJ2Vk1PK2thQUVNSlNPa1cyVXJmaCszdmJUaVdXZEJNZ1NybTNTYzNHNHRL?=
 =?utf-8?B?SDRIcEUwNDlmTWdiTmh1WGxub1JhcGpCVnFpcUN4T3FBNHIwbjV1RFBJYXlO?=
 =?utf-8?B?RWIwcE1WNHlLWkhTL0dscGw0SURTN3RIWEJ1ZUk2UzRXTUZJYVpWR3NjbmU4?=
 =?utf-8?B?QU5BRSsydnRHdE9DeSt3OXNrazluWGNGSk1ubUx6TGpyU29ZMlpZTXpzaGFW?=
 =?utf-8?B?OTUyRjgxTHo1bUIyeU55c0NVb0RnM0pSbUJzVkcydll4bVNWQkhUZFM2Y1p3?=
 =?utf-8?B?dEUyVTNON0hZZXhHWjY3K1VFYjFTUUptQy9ha3hGOVowVG5pK3hxM0tMNTQ5?=
 =?utf-8?B?L3lqOHY3ZnZRdHRRQlBycW1Jb2NqNGh6dXU2dnMveFB4ZGkzRkNFUzJtQWZB?=
 =?utf-8?B?aEhnRS9oRGtab1dkamFndUd5VzBKQ3hmT3cxdERlN043VkQvZG1HUmJyY2h2?=
 =?utf-8?B?alArTjh4ME0zYVBFME5rK2JUZ1oyRXBubE90akRmbVBZS2poU2FDamxtTmxW?=
 =?utf-8?B?cDlQSXY3MUlGQ1VwMFg5b09pblljcUlWM0pmdFRHR3QwSlRTK0hpUHR2dUx1?=
 =?utf-8?B?QURpUkRXbUM1MWpXL3RRdnRmU29oajlMbXQ5WVNtVXNXRjNnL3o4ZkkrQURO?=
 =?utf-8?B?dE1EbWdPWWhTTVBEVHZHUVJ5MVVZMTZHTGs4dU5YNkE4cnUvZXJpRG0vdjI1?=
 =?utf-8?Q?NFEt0vQGCx5ceGchEv5hwjs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF3D02DE661DA74DB3AF7468E2E9CAE8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b6b22a-a990-4bb7-89a6-08dca204da54
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 23:54:50.6205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5cOB2LtbYfDy6F5TlW11p70sIgLjQTAPq8JE5+GE5tNxR2ETJDxEzM8GQz8ICCLGYsNq72Hu7Q8G7SZ0EwYqbfLApih2trszq0JqpUtflnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6052
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA3LTA5IGF0IDE1OjM4IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gPiBDb3VsZCB3ZSBtb3ZlIHRoZW0gdG8gdGRwX21tdS5jIGFuZCByZW5hbWUgdGhlbSB0byBz
b21ldGhpbmcgbGlrZQ0KPiA+IHRkcF9tbXVfdHlwZV90b19yb290KCkgYW5kIHRkcF9tbXVfZmF1
bHRfdG9fcm9vdCgpID8NCj4gDQo+IHRkcF9tbXVfZ2V0X3Jvb3RfZm9yX2ZhdWx0KCkgd2FzIHBy
b3Bvc2VkIGJ5IFBhb2xvLCBhbmQgdGRwX21tdV9nZXRfcm9vdCgpIHdhcw0KPiBkaXNjdXNzZWQg
d2l0aG91dCBjb21tZW50LiBOb3QgdG8gc2F5IHRoZXJlIGlzIGFueXRoaW5nIHdyb25nIHdpdGgg
dGhlIG5hbWVzDQo+IHByb3Bvc2VkLCBidXQgSSB0aGluayB0aGlzIGlzIHdhZGluZyBpbnRvIGJp
a2VzaGVkZGluZyB0ZXJyaXRvcnkgYXQgdGhpcw0KPiBzdGFnZS4NCg0KSSBrZXB0IHRoaW5raW5n
IGFib3V0IHRoaXMgY29tbWVudC4gT24gbW9yZSBjb25zaWRlcmF0aW9uIHRkcF9tbXVfZ2V0X3Jv
b3QoKSBpcw0KYSBwcm9ibGVtYXRpY2FsbHkgdGVycmlibGUgbmFtZSBzaW5jZSAiZ2V0IiB1c3Vh
bGx5IG1lYW5zIHRha2UgYSByZWZlcmVuY2UgdG8NCnNvbWV0aGluZyB3aGljaCBpcyBzb21ldGhp
bmcgeW91IGNhbiBkbyB0byByb290cyBhbmQgKGFuZCB3aGF0DQprdm1fdGRwX21tdV9nZXRfcm9v
dCgpIGlzIGRvaW5nKS4gU28gcGVvcGxlIG1pZ2h0IHRoaW5rIHRkcF9tbXVfZ2V0X3Jvb3QoKSBp
cw0KdGFraW5nIGEgcmVmZXJlbmNlLg0KDQo=

