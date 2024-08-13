Return-Path: <kvm+bounces-24057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2730E950C7A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 20:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A75A31F22E22
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043D51A38F3;
	Tue, 13 Aug 2024 18:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A4Dn5rXS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B581BF53;
	Tue, 13 Aug 2024 18:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723574759; cv=fail; b=YOFPFgdSJxKdLiIIhehHrLY5Nsm9ph+mSRI6Fx21R6rjpcDHfNcQxLbzxZER/z0eZ4h6viaY08PBO8BWBVsnV0SoYJSph+ZO7p9GMpIk5yozn5zg89t2AGbZrntP9icbOh4SDwi4V3zSHGs0V44Oyo4C4abB4QhrqCm/m0EleKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723574759; c=relaxed/simple;
	bh=EkOPLJR0a2R9j4tCFeiyYt3Ph2FaX6d1XGuBrGnMMm8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z7VZTIJRirhI1GV6XVBtf9TK8jWiP4sejjyJgu3F2u2+yagW0dGw8nOqMT+8qitUPhXdJnsn/m0Q5pqUHzZSrLxHpLF/uUSIB2O0LQPRW5tX9X9dmVnGaH9qOlQzvUC5W9V7GPNlntNqHVd5KZ7VJ9fdcu+aFoJct9BdBuPo/WQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A4Dn5rXS; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723574756; x=1755110756;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EkOPLJR0a2R9j4tCFeiyYt3Ph2FaX6d1XGuBrGnMMm8=;
  b=A4Dn5rXSuB85w/rPRpaKfOEnqF+22o2Z1QlXwO2WkQUGLPO3tPaY+YZ3
   lgUieevug7CRmfKKI7n9lMsqYn+F0MAtM9BuHOFuR+RJPY26kqSg1J3PJ
   5gWeCsAV9e0emH10fgDNryAvScZ/qn7+Xk1NlPx8GtYO3cgrzDwRO8b/F
   UAqJdVS5G7l0WIMCh7NT2dqeZIrzv4wKglF3MV26lQRWdQ6K8USlnu6xU
   sWZQJc9uMQ7G5Rznu9espSxteE/5coatGGdXxF1OTlaSj1ItVqQye6sjj
   c8LfyjFfBsFMcX4TO5LzBy1PcOlpm3FLtFDbKNfny8B/spm1olH4qBH5l
   A==;
X-CSE-ConnectionGUID: IWTg8yucTKK8NWCD0w4qmQ==
X-CSE-MsgGUID: +J9bAq3SSvSXgBjqiLHznA==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="33144055"
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="33144055"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 11:45:56 -0700
X-CSE-ConnectionGUID: 0X87p/qUSVmGwUI6Mt/sHg==
X-CSE-MsgGUID: 1xXHDUmGRymfZ1aruj9LdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="62918374"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 11:45:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 11:45:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 11:45:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 11:45:54 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 11:45:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qNZ/KcRrr3MBrcFT9z33ioPEGQ7uluPKZSm3DsM5oeEhZPIbMbyWgPHct0WI7Wof0PLiEKXH2Vlx7C/Wlv+XuLHxX1aVQqyCkKWRYRjH42gyyoYkosa8lKqRNAwrkO6JrqTys9TIvJCWSrXFeBGwly5wyH6obwZ+OYaOCjMC3MFAG6XKcFFHbnILfg+Uwf9ANK2UwMXpybNsUq6tL+VJY3E/oBKPBJElCdhdCcAacLdtZ70zK/2fOAvsxy0sRDY9UaGCuIsyoibOuE2nUVht1w2J0qy4nB+tRvuHXX7/gufXhNm91/pKo3rb17DAa77GoDj1hpqC9j2p6OmijBDh0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkOPLJR0a2R9j4tCFeiyYt3Ph2FaX6d1XGuBrGnMMm8=;
 b=rVgRNXAMP2CSz4D9lQ83Z2zueR+9O3ZeUOZJ39d7eNF6HUpQwHuPCYpO6Pua9bK76dPFn6Jmc2+P2v3grQ5Cy5JLINu54F8Cb1nN6cfb/LJ0ahZyqGd+ieN3t96g5LbjpNn5zYLiku7PG9knU+sCfOSTd7/5IaADmXi2F2/vB7bA+DEhRiLW0pULfiaEDqmeyOPjWYe8ciECro9CGZCjdTWlugcuHfwdakkCYVhWGd5vayHNRFsZj/Leq/RFyYWXpYh/uQvZ4PkB5XXgRoTdgvms38Aj0i9ShpTZYOLrdC+iVhaE0G71nQrunr5Wn3r/OOYa5LmB68E3nZWrUjcTmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7772.namprd11.prod.outlook.com (2603:10b6:610:120::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30; Tue, 13 Aug
 2024 18:45:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 18:45:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Topic: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Index: AQHa7QnThnZIMHm/AkW0hgwbYo+0yrIlD2UAgAB4kAA=
Date: Tue, 13 Aug 2024 18:45:50 +0000
Message-ID: <a24f20625203465b54f20d1fc1456a779eee06a1.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
	 <ZrtEvEh4UJ6ZbPq5@chao-email>
In-Reply-To: <ZrtEvEh4UJ6ZbPq5@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7772:EE_
x-ms-office365-filtering-correlation-id: 766d7c26-daf3-48da-99e2-08dcbbc82747
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TGZOWU8vS0xGYlVxTkg3bnRhZkpvWVZBTjh5KzNJNlFWS1d5TVhyOG1xRFor?=
 =?utf-8?B?L2cyM0lmNXRRYmpsOEdEUEovODNaanBHMG5uVUYxenk1OUF1bExQRjREbS9h?=
 =?utf-8?B?b2dIKzQxbEp0TzJyWkxrY0tLMVI0end4WVp5Q1JSRGN5cFdYZC9GYzBNTHND?=
 =?utf-8?B?QVZjOCsrcG9lNk1VYUZNcFNZUDdJM2x1RWVWTE5qa0ljVTlyY1pRZUpSaFFm?=
 =?utf-8?B?UHZ0Z1ZLTEV1TmxHRFZkWWluUUIrNUlMcDQ2OFRKM1czelRjSnA1Y2hEcG5t?=
 =?utf-8?B?T0xOYnlHZm5LREoyUm9iNDlBMlc2WTMrSFo4NWUxS0hENmNuTzdSV0l1NS9J?=
 =?utf-8?B?QnBaSldTVTZGUGFkTlIrazhzbHdseVFsck1zUHhkSytwdzJ6SDJSSmVWbjhQ?=
 =?utf-8?B?bFRNeXEzbEw1OFo4azM2bHRFUFJJQkhZVGd5M0Y3cW5MQ3VHeXI1V3d4amd4?=
 =?utf-8?B?NDcwV3YyMi92ZkhNYkF2eW1VMG5oT2xiNTFMNGNSRlptdm43UGZnaTFYTGZD?=
 =?utf-8?B?Z3RkVmR6dkdORkpkbktzU1BlWGRsQ2V2bDUraDd4UDQ0UEhlbEJmZGtnZU1i?=
 =?utf-8?B?UlBaekgrRHpidXd0NUlPcnVob0VzeWNIK1k1TndMelhOM2lpNXZ4SWdZQzF0?=
 =?utf-8?B?Zk5rY0VOMEFOVmRNaEM5akpLQVNYa0tqbVh0U3JzQ0JpbTRtTEVBNU1BQkNq?=
 =?utf-8?B?UXNQRUJpQk9GUUx4Mlg1NGdaYS9vMnNBWDlJUFROL3Fqb2NXKy9UZTQ4WENJ?=
 =?utf-8?B?bjl4N1JKRzRhaVZjL1Vxb01mVkV6dVNiWGdxOHJLa1JBdkFBVHo3UHJ0dzVH?=
 =?utf-8?B?cjVvTFFpN2xieFg2WDV3amMvSUxSb01ZcXRWNHpZSGZieDBPOGQyczJhY3dC?=
 =?utf-8?B?K3FGdWx4ZkFMdXJZWStodXI4bEMzSnVjV1dqck1nY1dmbHFxbXY4a0tzNmJy?=
 =?utf-8?B?eWtWUEtzRWRyclJLWHAwbU1BTHhMT2dVSFhOYi9uT0dCcXcxc1lBM08wRkVS?=
 =?utf-8?B?dG8veGhmbWxIcjN0aVZ3R2FQbXE4V3pUTnZzcXU2ZE80VmF5TWJsVTRtckZp?=
 =?utf-8?B?WjJmVWtVaUFIdkpuRFhXbnlYOEZhZXJ3clJxZmdkNzNJWXlETkdndmJKRWdu?=
 =?utf-8?B?L2tLQXprVDVuR2I5UTNXMVRZOTRGckNhdmFZSmVLRjRjeGZKeFgyTDFXVEJj?=
 =?utf-8?B?Z2pqTkFtcXJKUFliQlQ4RE5jZVVBOE9wazQ4ZjBBbGpOWFJDWEV3QkhDQm9m?=
 =?utf-8?B?c05BcXl3Mms0ZS9WKzR1V1hodGRubk8xVjU2LzBKaFpHaUdDVjBxSjdGeHI5?=
 =?utf-8?B?U0RYVkJOQXd4MlNKcDY4dGYwZUthNFl1eTlhdEdXUkIzRzJ1Z3RxUnFCVmFT?=
 =?utf-8?B?M2JTdU9FUENnRGVkeXJhUHQya1hOMlZObnZLdEdlS01vYW14b0FvWUdyK1M5?=
 =?utf-8?B?YXNGSGI4TVB0VWl4R21Ld1pad3MrTVFwdHNySU1GS04wM09wTTFwdzYxL21G?=
 =?utf-8?B?RmNQUEQwbTkzMGhoOGV3eDJibmF5d09RcFR3ZlJ2eXJZbCt3aFh6dUduRUZS?=
 =?utf-8?B?N3VwdnVTZDNkY1dyTkpWU3Z3REdNR0tzWXl3Q0tkbndsNmtydjJjZWtRdXVk?=
 =?utf-8?B?Vmp0OWZlQ3lsTEdmY0xtejh6NCtvc1dDSXJsQVdwK0VOSTdyWnhqUktnU3ls?=
 =?utf-8?B?TUtNdEhuaEwzdDdrdEx1WjhwdC9PcmJmMkpaaEx2K0tSTU5xSXBLZ3BDMVJx?=
 =?utf-8?B?cEJ5TGd5dFN0RDFyOWpNb1FpcnI1VlhqQ2doV2E1NWNWQWN0NEFLbEMwa0hH?=
 =?utf-8?B?YlpUV09lWUhLZzIrbG0weGdSQ01HSmNLbGs1RzNpZTVaU1lBMm9yTzBtOFEr?=
 =?utf-8?B?RmhkODFRN0xRWUZ1azV4dk52aFZYcm1kQnRYZ0swMGNkMWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzdUdGZmeTBzelRTUlNFNnl3WVgyUUZ5YWt6cldFK2ZjbXVRajN3bzdsaERB?=
 =?utf-8?B?bHZoV0V0cGdXMTlTK1NYbFB0TlZwVFMyQUovL1NSTnkrTjYydlJGZC95emFk?=
 =?utf-8?B?NW1iajliN3hyTWczZENXS3NsaFhDVEJQRmpKbkpIb2hBQkwvUDA3Ty9OQStv?=
 =?utf-8?B?SkFwRG5YYmNIYjg0U0FvQTB4dWlyMlVlUEVzc1pTbkZUNzUxQVJ6QzhLRFB2?=
 =?utf-8?B?VkJRQUtoN1FBUUkrM2Jqa3dQRGVFMDNrUzl2NC9ZK0JyT2xUaUR4bmJ4ZUJ4?=
 =?utf-8?B?c3hHN256Ukg1YzJqNVNteU0zSzlkVmZ1c2xLTGFYVUlXMTJyWUpvZGdZYmNR?=
 =?utf-8?B?Sy9NWUV3R2pod0oyRngwN0thbHpmNzA4bForWERiUk1JMTh4YzFqVWliY1lT?=
 =?utf-8?B?U0trU09KRmR6VU5BK21PV0szS0FaV2JXTWdadG5BT2k2dVA2cHRNbGNGdGVV?=
 =?utf-8?B?bFFzWGJzcHJWSjJqN2tVNFRGMlZjc3dQLzhZZVJqc1FvemRBMSt0UHQzYUtL?=
 =?utf-8?B?Mnd3QmRzN09oOENpRmJoM2JqbTNYSDN3THBUVGl6SytpV1Fxa2hybVF3U1hM?=
 =?utf-8?B?K2p5eVZUcDdZSE1FVkVXdWNnTWpjb3hDWHA1cVdEYlFydHNHZG44NXdRUmUy?=
 =?utf-8?B?bTQ4aUxTTktJd0U0V1VvR01vVnJ2YjBMWmZPMVpaTzdyUXczNElld2RvbEJm?=
 =?utf-8?B?dVRkTTF0NmQ4Z0xFUXJWZmtIazZkdENHelVSTlpiRllZU0xVRm5PYk1WUCtK?=
 =?utf-8?B?eEthWkh6b1htRi9reEE3V0ZpVlErLzVPWENkWDlHKzVxRmc0ckpoN3phZk80?=
 =?utf-8?B?RnJub1puRkNmTi9JV3kxU3ZiblNHbDJHOEtIVzliTElMdnRsdnhzeWp5R0hT?=
 =?utf-8?B?YitvMjFQZmxSQUpBbjkwaXNHcjRkcjhVcG5qbWxmL2NNeFJuYkQvT3FSRjl3?=
 =?utf-8?B?SUNQWXR0ZHJNWVVDd3V0eXcwZFVoUi9NN2M1WDFOVW5BaGxXcTBTYzJRVkhz?=
 =?utf-8?B?RUovQTFlRitFRU1meXgyTWd5dExnc2JvNHFQblNoTXdGTTZ3Z2V3UVpza1Ri?=
 =?utf-8?B?QU9YWE9nQ3RWMFYvQnNxcUJqK05YNm1iM3lBN3FjdE83YnVFc0x3ZHIvSlRN?=
 =?utf-8?B?UC9QeGEwT3RMQnB3MzhxbFJaOEo3VlgyWitDTklpTW1wblptd2hFdWtTQWJP?=
 =?utf-8?B?WnU5Y2RxYmM3MHUrNW9KeUVzdWFKaGpMYWxzMUNBSDVIRGNIcTFiWjNtQkw5?=
 =?utf-8?B?dFpaMXpIVkFVMitxbHpkbFJMclovY2RMaXhhUmpPWEtRKzBPTFR0RUdqZGdU?=
 =?utf-8?B?SHdLZzFVUGRpMVk1bnZUdHF1OEtCK0ptSDlUM1hveDNTWHdJL1o5NHcvdk5w?=
 =?utf-8?B?NDAzZERYZEF1amRjbzFvMjhKaXdmeDdxcXNLKzQrTDF0R1B4aThwblRWbHFQ?=
 =?utf-8?B?NkhHVzZKUDF2Nk5EZTlFNEpMYmZ5N0JENkNUd2JJNndRL0xqSGlwK3JTbks1?=
 =?utf-8?B?Yml4UmhuWmdXTUMzSERFZWFZWUV1amNRK1BMK0lBV1VDN1RMTkhOMVdCUmR6?=
 =?utf-8?B?Z0pRZy81Q2ZvUUJHL1doZFpMTXFmWXRBcnQ1V3dzY3dhbnF3ZC9YNktlK3Js?=
 =?utf-8?B?Rmd4S3oxYjVmenBkWEdoUjliS3VEaDVBczNSNFQyWEtZYVVFTE81bUxkckIr?=
 =?utf-8?B?YkxyS1VQaFdiSTVQNWRjQ24xUjJubGhqYWx4VGV0MG1TMHRTSVduK3dnOHVM?=
 =?utf-8?B?Q2w4WFdUZlBtRmF6cDBWYXpVMEMwSEFVa01oVWlpUVJ2MlZrZWpoWU5xT2Vu?=
 =?utf-8?B?ZFJzdUt5emRrQVFCcFRjZ3lJM1h2S05aK0VaeWJMYXE1Q25nZTJCVWxFcVV0?=
 =?utf-8?B?NXpVQjZ5Q1k1RFV1dmN5VXpvdUdZUWhiOEVHenZZRE4xdkxMODlROTZKeWt6?=
 =?utf-8?B?aHVvM1dVZ1pDWXYxcDA2ZGc2MjhzOWR3N3I1dG53MUFSWjY3d3dNakw2bS9n?=
 =?utf-8?B?dzExeVRHUUlmSmp2MHdhRENIRkRZUHQrTGlTNGI0UFMrNFVONEt1cHZaQlk2?=
 =?utf-8?B?TlBPWTYwcVRDRWJabG5lNzRDbFFiNko4MUY4aFZkUkRRTUdVeGxxTGJVVzJp?=
 =?utf-8?B?R0xKYWdMT2tzd1l3SFFNVE9uSkk0Qmo4ZDhTaUF4Lzkrb3k1RmtLVEd0Y1BE?=
 =?utf-8?Q?QZw1OiE2XCGWm/ShLj6ARLU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <431C34BECF3D96468F2AB767E110EECC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766d7c26-daf3-48da-99e2-08dcbbc82747
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2024 18:45:50.6588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SV7bY9fN3F1iJmCNPICRc9k0R1/0WWxMjSbu0Kt7x7ctTTgBWdcYKnIiNKn7TwjMVeif1XQ5QN4JvaVGmXVJOJ46mbMqhLZmFFez/5K6/yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7772
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTEzIGF0IDE5OjM0ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gTWFu
ZGF0aW5nIHRoYXQgYWxsIGZpeGVkLTEgYml0cyBiZSBzdXBwb3J0ZWQgYnkgS1ZNIHdvdWxkIGJl
IGEgYnVyZGVuIGZvciBib3RoDQo+IEtWTSBhbmQgdGhlIFREWCBtb2R1bGU6IHRoZSBURFggbW9k
dWxlIGNvdWxkbid0IGFkZCBhbnkgZml4ZWQtMSBiaXRzIHVudGlsIEtWTQ0KPiBzdXBwb3J0cyB0
aGVtLCBhbmTCoA0KDQo+IEtWTSBzaG91bGRuJ3QgZHJvcCBhbnkgZmVhdHVyZSB0aGF0IHdhcyBl
dmVyIGEgZml4ZWQtMSBiaXQNCj4gaW4gYW55IFREWCBtb2R1bGUuDQoNCkhvbmVzdCBxdWVzdGlv
bi4uLmNhbi9kb2VzIHRoaXMgaGFwcGVuIGZvciBub3JtYWwgVk1zPyBLVk0gZHJvcHBpbmcgc3Vw
cG9ydCBmb3INCmZlYXR1cmVzPyBJIHRoaW5rIEkgcmVjYWxsIGV2ZW4gTVBYIGdldHRpbmcgbGlt
cGVkIGFsb25nIGZvciBiYWNrd2FyZA0KY29tcGF0aWJpbGl0eSByZWFzb25zLg0KDQo+ICBJIGRv
bid0IHRoaW5rIHRoaXMgaXMgYSBnb29kIGlkZWEuIFREWCBtb2R1bGUgc3VwcG9ydCBmb3IgYQ0K
PiBmZWF0dXJlIHdpbGwgbGlrZWx5IGJlIHJlYWR5IGVhcmxpZXIgdGhhbiBLVk0ncywgYXMgVERY
IG1vZHVsZSBpcyBzbWFsbGVyIGFuZA0KPiBpcyBkZXZlbG9wZWQgaW5zaWRlIEludGVsLiBSZXF1
aXJpbmcgdGhlIFREWCBtb2R1bGUgdG8gYXZvaWQgYWRkaW5nIGZpeGVkLTENCj4gYml0cyBkb2Vz
bid0IG1ha2UgbXVjaCBzZW5zZSwgYXMgbWFraW5nIGFsbCBmZWF0dXJlcyBjb25maWd1cmFibGUg
d291bGQNCj4gaW5jcmVhc2UgaXRzIGNvbXBsZXhpdHkuDQo+IA0KPiBJIHRoaW5rIGFkZGluZyBu
ZXcgZml4ZWQtMSBiaXRzIGlzIGZpbmUgYXMgbG9uZyBhcyB0aGV5IGRvbid0IGJyZWFrIEtWTSwg
aS5lLiwNCj4gS1ZNIHNob3VsZG4ndCBuZWVkIHRvIHRha2UgYW55IGFjdGlvbiBmb3IgdGhlIG5l
dyBmaXhlZC0xIGJpdHMsIGxpa2UNCj4gc2F2aW5nL3Jlc3RvcmluZyBtb3JlIGhvc3QgQ1BVIHN0
YXRlcyBhY3Jvc3MgVEQtZW50ZXIvZXhpdCBvciBlbXVsYXRpbmcNCj4gQ1BVSUQvTVNSIGFjY2Vz
c2VzIGZyb20gZ3Vlc3RzDQoNCklmIHRoZXNlIHdvdWxkIG9ubHkgYmUgc2ltcGxlIGZlYXR1cmVz
LCB0aGVuIEknZCB3b25kZXIgaG93IG11Y2ggY29tcGxleGl0eQ0KbWFraW5nIHRoZW0gY29uZmln
dXJhYmxlIHdvdWxkIHJlYWxseSBhZGQgdG8gdGhlIFREWCBtb2R1bGUuDQoNCkkgdGhpbmsgdGhl
cmUgYXJlIG1vcmUgY29uY2VybnMgdGhhbiBqdXN0IFREWCBtb2R1bGUgYnJlYWtpbmcgS1ZNLiAo
bXkgMiBjZW50cw0Kd291bGQgYmUgdGhhdCBpdCBzaG91bGQganVzdCBiZSBjb25zaWRlcmVkIGEg
VERYIG1vZHVsZSBidWcpIEJ1dCBLVk0gc2hvdWxkIGFsc28NCndhbnQgdG8gYXZvaWQgZ2V0dGlu
ZyBib3hlZCBpbnRvIHNvbWUgQUJJLiBGb3IgZXhhbXBsZSBhIGEgbmV3IHVzZXJzcGFjZQ0KZGV2
ZWxvcGVkIGFnYWluc3QgYSBuZXcgVERYIG1vZHVsZSwgYnV0IG9sZCBLVk0gY291bGQgc3RhcnQg
dXNpbmcgc29tZSBuZXcNCmZlYXR1cmUgdGhhdCBLVk0gd291bGQgd2FudCB0byBoYW5kbGUgZGlm
ZmVyZW50bHkuIEFzIHlvdSBwb2ludCBvdXQgS1ZNDQppbXBsZW1lbnRhdGlvbiBjb3VsZCBoYXBw
ZW4gbGF0ZXIsIGF0IHdoaWNoIHBvaW50IHVzZXJzcGFjZSBjb3VsZCBhbHJlYWR5IGV4cGVjdA0K
YSBjZXJ0YWluIGJlaGF2aW9yLiBUaGVuIEtWTSB3b3VsZCBoYXZlIHRvIGhhdmUgc29tZSBvdGhl
ciBvcHQgaW4gZm9yIGl0J3MNCnByZWZlcnJlZCBiZWhhdmlvci4NCg0KTm93LCB0aGF0IGlzIGNv
bXBhcmluZyAqc29tZXRpbWVzKiBLVk0gbmVlZGluZyB0byBoYXZlIGFuIG9wdC1pbiwgd2l0aCBU
RFgNCm1vZHVsZSAqYWx3YXlzKiBuZWVkaW5nIGFuIG9wdC1pbi4gQnV0IEkgZG9uJ3Qgc2VlIGhv
dyBuZXZlciBoYXZpbmcgZml4ZWQgYml0cw0KaXMgbW9yZSBjb21wbGV4IGZvciBLVk0uDQo=

