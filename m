Return-Path: <kvm+bounces-56650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D55B41142
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 02:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A2183B9959
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF89D13B58C;
	Wed,  3 Sep 2025 00:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GhI5Cijt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1236128373;
	Wed,  3 Sep 2025 00:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756858700; cv=fail; b=oEZC1tTGyUnxyqbZqLEkeWRKFODttgfyJFDLSHehZ3KyTZ2DJzLldKuPbKEI9osk1iyIe1s/FxeiZ8X02msjKgK8rZcv9WcTSOLgLE5ymwcZR3yaY48bez/dwIzqrYIiRT4rnARS/mTUUJ9Y+KoqKmxJzioPmqRp//8Vf7yUUUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756858700; c=relaxed/simple;
	bh=pXT/YWSmSNU9HvXwckWbdR9A6mHjSA0CvGLlFTnX57I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CpQ5+5buWVQJdXNcKFwUEaH9VXpIFY1h0HmLeUfR6JGW9yFPJOtj/tcBMLHpe+z9Y3jc4gnUJ8g6ysRTKMtxDLpqzBZjMWVuvll2xdXV0p510m5ud9qVpuTc4vc2XjX0QBCXmt5mEWTkLE9vLg2X4z78h+KyBMu8m+usGGRATuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GhI5Cijt; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756858698; x=1788394698;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pXT/YWSmSNU9HvXwckWbdR9A6mHjSA0CvGLlFTnX57I=;
  b=GhI5CijtMBH4ZfGJqiOmfqH2vPgUErqoOaY4gZzV4K8jQ8yNsIEW0Fvx
   4LlpcTJAWjg4BNlNrAhIqgtzaGPZVmaiXe0W7y+tcO4paiTqbG/dgYAsB
   TpCKrewmdSyvSNzFbzGtr0bJqedZgbGmEtqxlk+xznW+PQ0B9WycQ11My
   J3Hv8GuHEiQz917q8YxBScm5B9dgm916b72P05Wr+VAyYQ4WRqjVh/Zva
   6qK7LPBwLplG/+7ww+r91suqibAE4Qs7xStBo8gOiaKfp3wbUWo1YBZAA
   6ni/s/VAKNa12gNWw2xk32vs3ngYqDyCFSTKQnYoyGYeFfAx2dK3GGgkv
   w==;
X-CSE-ConnectionGUID: UdB12tAoS5yi6lseUMxHcg==
X-CSE-MsgGUID: J/or+Z3LQ1ugd1f9xAC6ZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="69770843"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="69770843"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 17:18:18 -0700
X-CSE-ConnectionGUID: rKfK7PgsQ9eN0erHfLkybA==
X-CSE-MsgGUID: JY5wzfJcTgOX4KL1OLwaEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="202385285"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 17:18:17 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 17:18:16 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 17:18:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.80) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 17:18:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EitLLj+9qge0e8CivwShZZWAWsf68StMFf8a8TlqVO/GXzyNeGZF/TGNAYBp4/yo0lV+numv4pU2pSFW6iI4PszaqLpHkN2nZUEfzb3I+4og02lxlxPkKo+5l45zAd8e8Q0PMY4WxYoo3B/8bvghkLQ2AFt6JN9a65FbIO2ijo+MckmerGfpQXOcSV6AoIWThSg5bojGAPpwKkd/z5nuUkotWYA4NFsDhCTaEm1VgfutmhrS59RWJH5JGaoxdlV+88o/JTsgh6SLMU+1oN5oLUxcAZPf1f9snLJpPy129tF5pbRZmWB6XqHvp4xuMZtJiXqMlBzfA2dNWzVIGUz2Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXT/YWSmSNU9HvXwckWbdR9A6mHjSA0CvGLlFTnX57I=;
 b=QLhwn7PCyDtSPg0MSiVilrhhvs9tMs6pG0owQAaeD7quQzNFRXgo5qdoLMQNb/5VC2EUQ7+R6NtsaLet0w2vr+ifeQJGEE5xXrXiyw3n0B9dQt0St3dfqwisXxzI+ZNnDoLqRvZjseevZeS7xzVPCAqvPxs3ILOQvgtpbGgBNM5EtdOd15ZJZB/u/hNq0slN2cueNnT8GDzShVqS7oMUg28H49tVBjnQ5eMY6J9JATMPx89IHBRoly9CsYYT6Q/VVjrcRW+uprRrP/bpUY8r2FNZV9B3lTB3pBDxZdMXULod0JRINNcA7+yoeBR0FZperQ3H05YRLHjPniUJRPghPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA3PR11MB7486.namprd11.prod.outlook.com (2603:10b6:806:314::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 00:18:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9094.015; Wed, 3 Sep 2025
 00:18:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the initial
 measurement fails
Thread-Topic: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the
 initial measurement fails
Thread-Index: AQHcGHjSRjNmRiPKf0OfM3rq5B2s2rR5SfIAgACnMICAACApgIAFlJ+AgACAeACAAHkhAA==
Date: Wed, 3 Sep 2025 00:18:10 +0000
Message-ID: <77cd1034c59b23bae2bbf3693bf6a740d283d787.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-13-seanjc@google.com>
	 <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com>
	 <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
	 <aLIJd7xpNfJvdMeT@google.com> <aLa34QCJCXGLk/fl@yzhao56-desk.sh.intel.com>
	 <aLcjppW1eiCrxJPC@google.com>
In-Reply-To: <aLcjppW1eiCrxJPC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA3PR11MB7486:EE_
x-ms-office365-filtering-correlation-id: 081a6d6f-68c8-4006-8714-08ddea7f5dd6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dUFiYm82eTZDdTQ5eEE2NXlSSlYzUXdyS2hacGZOd0c5bUowYW9JamNMazlS?=
 =?utf-8?B?Y1AyWldtb1lWUFNKeVZ0NkNmaGh4d0UrM0w5ME9uOHhIRGpsb3ZNblhETkdp?=
 =?utf-8?B?U05vZTAzOU1TeG1ZSWZGSDNZVTM0bnF5NkRIUFFoU3NaN0ZqTTZuU2VhZGxu?=
 =?utf-8?B?RG96NStYUmg4NUhKaEc2cjNNOWpKWDJMcGdrd3ROWnBhS3ZKZ3k3WHM3TlB2?=
 =?utf-8?B?c2FiQWc1MkNTUTFNOFY1MDA3d2s4U2Vyc09mRXYwcmVHRHp6RzJlMXVQa0xq?=
 =?utf-8?B?ZTgxc3ZFek1Vc0JWa0dVc3hySUpJQlFoY1VGT3VpMVQ0alFwRnZjeG9tVXVa?=
 =?utf-8?B?YWR4YTB6VjZQVnI3STZKMkNqV2V1aFRXaXRyV1dvL2dFNWwyeUhvMTdBVmds?=
 =?utf-8?B?L2l0MU9GVlVIeTRDVXJ2TGFhdnBxenpXYkN2VWhMMERtSHo4ZVdXY1FIVGU3?=
 =?utf-8?B?NGRGV2dicmgxcDVZYkQyYUh6Q2FnWkd4em1qNkczVnl2RHBaSERYN2pSL0g3?=
 =?utf-8?B?TzZIYzVBdGJtY3ZaQjlRckVGTVFKb2RBOWpPajIycUZ4cFFxVVB6NkdMUnZG?=
 =?utf-8?B?eTkyQTJ1SjV0WG1BNXFKdkZxRnlVZ3o2eXhKbTBDanVGTnVQKzBSYXhUVFNS?=
 =?utf-8?B?QnpoM3krSlVHcEFFVVFXaVgyRldPNyt4c2VyRm85NFJ1cGE0SW9ibmZSMXJi?=
 =?utf-8?B?TXREcGx2cy9WZVA4Y1RlQTBoWkNuQnpETE0vT2VKTGhQSll6OVRHazdmOFpx?=
 =?utf-8?B?QUFxNzhaQzJzbDgvbDkvLzdrMVlITm1IU1ZiYzNrejBuQ0lBNG9sZDdvRWxm?=
 =?utf-8?B?eUk4SjRQYno2a0tUV09OUUNGNzMvaG5XTXdCb0UvSVA5ekhYZk1PQ0FiTURF?=
 =?utf-8?B?QTBBeUs4NVF6SFZoaTcrZ1daZWxLTEVXa2hQVkRqak82b1k5aVF2c2dSTkhz?=
 =?utf-8?B?MFlrZTNmdWRaR1VGUWFiMFJKNzVaMWFRWnQ4SWppMk1ma2RXSWZXOXBVT0V5?=
 =?utf-8?B?YWRUUTlLakJtS3c1TTZDNC9UL2svL2p0YWxlWHJXTENydUpsaVA2dEZjcVYr?=
 =?utf-8?B?VmxPZXdoOWRabGlMYmU0YWV6cVRQWEFOc3VQOTNZT2xuK2ZsN3EzTDJZSk1w?=
 =?utf-8?B?NXRlT0N0YU02WlVlQlVOWlpqS3pRVjdGN3RvRktndjlac0M4SWF3Q0c0cFpk?=
 =?utf-8?B?UG5CdkRlQ1AvanhEaEFJSmFNTU90Snk5Z2NITmhSZHppS3ppKzhOSm5GVUE1?=
 =?utf-8?B?OThHejdhdXhwZ0hkaU9aeE9XeVl1TFpnQXhrdzNXVTBhT0kwcW00RmFwZlE0?=
 =?utf-8?B?L3FMYWNPTW5iN1F1TEl1eFdQWWVSS3grSEdOLzloK3hyQXJNWjNOeWNlU0hk?=
 =?utf-8?B?VDdaZ3U2bkRFWGpBWk90bDhOcm12TFU0Y0ViRDBlNjlxQ0VsdDEyNU1ZVloy?=
 =?utf-8?B?WGRGMmZWNjR5dy81TGZHYkJhSG9DTTJKSHdhYzU4aTlsVFN6OFZvUHFqL3BL?=
 =?utf-8?B?d28vSldFYStKbU1hakc4VnlLY3ZXTnpXdDVvTU0wZ3E5SEZFTG45bU5iRWtY?=
 =?utf-8?B?OWh1ZisrRGRWWjBybFNJN0hhSCs2cm56QVFkTmJaK01jZjAwcE9Oa0x6bjZi?=
 =?utf-8?B?TU5vYjFPbkg2b0h0VHBqQytaUEV1UnBBRGZVWkcwK2dndDBYUnhRdHBaVnFF?=
 =?utf-8?B?SmFsdEJybmd0eXpCUGFWUnl6RTB3aVlpQVdzbElJYU43UkZZM2JJYzFockZT?=
 =?utf-8?B?TDQ0SktZbDNVNWFrTjZqVzNUMnNuN01PeHZOK2dMbllmQzVIbEV5RUVUVFlj?=
 =?utf-8?B?VW9FbXlNNjN4aDMzTDNpcGdpWGN0VGFMUkhKV1FDaXV1KzFOS3JTaHdta1J1?=
 =?utf-8?B?MGVHZVRhWDA0R0YxeERMWXFTL3JnekdMM0tybzRHV1AyU1pRUVVNSWZweEZv?=
 =?utf-8?Q?IoCGKP5BOkY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekR2dW1CYXk4SVZ5NHFKWjZmb3BHcmpNMTI0OTN5VVVtdzNTbEt6ZFVGK0ho?=
 =?utf-8?B?OFhkUFI3Q1cyenR2ekZKMU9iajQ1WTY1c0VKSTFXNmsyQXVzb1U1NEhMaDlB?=
 =?utf-8?B?N0ZpKzA4OVZnUC9vU21wdUx0Tll2SjhCTDFDZVZubXUxdCsrdy9ZVmtIRnhQ?=
 =?utf-8?B?S0xvZ0wwTUF4aExzRmlaaEJZeHl4bk9EeVNmbmxxVkQ5dlE3dkExS3pNZnlw?=
 =?utf-8?B?MWE0RUtweEJ2U1ZiVzZ1ZTl4S3RDTjJGb3F6TnZlMng1WG5zYkpuYVJWQTZv?=
 =?utf-8?B?dHFhdXhzZm5zSzlFVmpSdEMzRGtpdEFqazRYSGNZaUJFb3ZSMkRtTkRUL0li?=
 =?utf-8?B?bnBDeEM2NTlnTXR6dldpZWtrTjQ5TU8zMWtDdG9JUXJESDQ5ZFA4Qlkvb3hj?=
 =?utf-8?B?SVhZRGttWGk0QjRleEdueGgzQjIyQTZ3bm95Z2xBNHNtQnBhR3hMNXF1VkZ3?=
 =?utf-8?B?R2MyQkQzOTFSejBjaHJnejVXQUcvZjdvVG5rRGxoenR6ZmhaRm9NcExwbFdW?=
 =?utf-8?B?Z1dXUW81WTZXSGZYakVjbEhJWEFiMmloNXpVZXpWUURsQjdBNUlNb05waU9x?=
 =?utf-8?B?alFWbitOeTI1bVZuUk9PclViOTZwMndsZWNIdkJWU2c3SnY1bERscGlVQmsv?=
 =?utf-8?B?bWdvL2o3NEl4YmZramZ5NVNmWmJKYm92Q0dXTG1KYXE3WU1zNlp2WVlOYjh1?=
 =?utf-8?B?ZFFUYUNBekcxMFMvN0ZNMkFYWUsrODg3NEdRRzN6QzVvTHRLUUxKY3YvZFJB?=
 =?utf-8?B?QWswbDFzemJyT1lkWEZ1cDNTaVQ5c3NQa1hmMVpjb2J2SUllVUZCTldZM3NX?=
 =?utf-8?B?VFI5cGZxMlRlS05kRlVyUkxtWWVnWkVtaWkwaFQ0MkgwRkYrVDNiOGZIYUlx?=
 =?utf-8?B?UWNVdmdDZ0l4OXBLT2lJenNZRXZXbHE2UjRYY3pDTlM4akhvbDNmMk9uWjRV?=
 =?utf-8?B?bnYvb29CaGRpM3BBbUliQXN1T1FGUC9LWFZUNUtEYjI0SE5JQlhJMDIrV1JV?=
 =?utf-8?B?ci95a1YyYURRUU5VV2drbStaZVNIM3Z5SUxjWjEvSmxPVy8wOHA0ZHBZTXdM?=
 =?utf-8?B?S1QxNWQwTFRBemtzbVlXWGorU2JoaHd1aVdCQm82NXlvTjlYRFo2dDk0cUxV?=
 =?utf-8?B?c0YwT2czakVraXlhb0NBbGZrakxvTUtkOUtxemI1S2x0N2txRlpDZHp2d0dC?=
 =?utf-8?B?NTMyeis0dXhDSElnVGVhQ1RhNncySzBtRmZ1S25aZWd6RnJISThUaW9ubVo2?=
 =?utf-8?B?VTYvVlZBdGVLcHQvYmRBeHZIdUZsWVc0QkNXT2lWY2lxSkRpRkVuVjlmUHRH?=
 =?utf-8?B?UWZrUWtaZHRQWk9HaEx3UENaR0VpSDNETEswOFlqdXBONUI5eHhtMnI3N1g0?=
 =?utf-8?B?NDU1K2Y4UlZDd3k2RUl4MG1OT1Q3cGM0SEl2S1A5WGFEalpQNEpDNHIvd3VZ?=
 =?utf-8?B?V2tlNmt3blpoaHBneVJha2VkeS9ncjFwUFY4dXV6d3NyK3JTUm1MYURnRFY0?=
 =?utf-8?B?UW1rd1dHR1pqTkRQb1ZPZ0hXUmZyekRaaUlGZ0czV01rR0FsUDd1REsvYmUv?=
 =?utf-8?B?UjNkaXZwOElvTmw3TzlNTEd0YzRFUnBGZ1B0N214c2VWekVicjVIeHVqMW1r?=
 =?utf-8?B?V3Y2QUk3alkyQ3htdjdYNFhzdVg4eVpvd0d6Tk1CM21vcEdFdEpSb3JRSzNr?=
 =?utf-8?B?RTQvai9yNmlMV29uenpSWFp0c2p1WHNNTkJLcXpOKzIwaE5kZjdEQjNhNlA2?=
 =?utf-8?B?VDJjQWJ2eFRpRFlBcEdZTUhsNEpBZldERlJUS2dmTENFcnFQTXVjb2xSWFNw?=
 =?utf-8?B?TUoxOTBYc1V3SFZQNjZRbFNyanBUL3lmemNnVytSMUZHMXo2ZkFvc3N4ekIr?=
 =?utf-8?B?NzEzMVdFbW95QmZxWEdubFFTNk9LdERrcjZvaXJ2VW0vZjJSQ0R6MWZKOGtk?=
 =?utf-8?B?aEZyK1RjQWxqcTBpYW16ZDIwNVFaQ1F5QWRrL05wbGJublZFMWdhbzlnZ2cz?=
 =?utf-8?B?dkRUbWZpeEdaVWdmYitCOC95NEFqWS94b3ZoMVJ0ZUtpWkVhQnE5ZkVNNjJq?=
 =?utf-8?B?ck84T3NWSk5JcHU4RTJYcS8rS21FdXZ5djRlTU1OV2NjZEthNkh2MVd4RXo0?=
 =?utf-8?B?R1FoYWZpbDRWdThxWnNsQ29hTVVPLzVVZ0xRSHJya0dzUWVzdG82TmNIQUpI?=
 =?utf-8?B?dGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17CD898BFE7CE44FA651A8835570696C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 081a6d6f-68c8-4006-8714-08ddea7f5dd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2025 00:18:11.2390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EM0eDQXb0mWcT9qWrFexeqPul84Im8gla7IWrmZBh83OhE3cZuFauVJwMc3fpFHo3KlW2bITeC+5RXk4SKAMPyH7VlaX/TXJ67VSGvBUQOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7486
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTAyIGF0IDEwOjA0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIFNlcCAwMiwgMjAyNSwgWWFuIFpoYW8gd3JvdGU6DQo+ID4gQnV0IGR1
cmluZyB3cml0aW5nIGFub3RoZXIgY29uY3VycmVuY3kgdGVzdCwgSSBmb3VuZCBhIHNhZCBuZXdz
IDoNCj4gPiANCj4gPiBTRUFNQ0FMTCBUREhfVlBfSU5JVCByZXF1aXJlcyB0byBob2xkIGV4Y2x1
c2l2ZSBsb2NrIGZvciByZXNvdXJjZSBURFIgd2hlbiBpdHMNCj4gPiBsZWFmX29wY29kZS52ZXJz
aW9uID4gMC4gU28sIHdoZW4gSSB1c2UgdjEgKHdoaWNoIGlzIHRoZSBjdXJyZW50IHZhbHVlIGlu
DQo+ID4gdXBzdHJlYW0sIGZvciB4MmFwaWM/KSB0byB0ZXN0IGV4ZWN1dGluZyBpb2N0bCBLVk1f
VERYX0lOSVRfVkNQVSBvbiBkaWZmZXJlbnQNCj4gPiB2Q1BVcyBjb25jdXJyZW50bHksIHRoZSBU
RFhfQlVHX09OKCkgZm9sbG93aW5nIHRkaF92cF9pbml0KCkgd2lsbCBwcmludCBlcnJvcg0KPiA+
ICJTRUFNQ0FMTCBUREhfVlBfSU5JVCBmYWlsZWQ6IDB4ODAwMDAyMDAwMDAwMDA4MCIuDQo+ID4g
DQo+ID4gSWYgSSBzd2l0Y2ggdG8gdXNpbmcgdjAgdmVyc2lvbiBvZiBUREhfVlBfSU5JVCwgdGhl
IGNvbnRlbnRpb24gd2lsbCBiZSBnb25lLg0KPiANCj4gVWgsIHNvIHRoYXQncyBleGFjdGx5IHRo
ZSB0eXBlIG9mIGJyZWFraW5nIEFCSSBjaGFuZ2UgdGhhdCBpc24ndCBhY2NlcHRhYmxlLiAgSWYN
Cj4gaXQncyByZWFsbHkgdHJ1bHkgbmVjZXNzYXJ5LCB0aGVuIHdlIGNhbiBjYW4gcHJvYmFibHkg
aGFuZGxlIHRoZSBjaGFuZ2UgaW4gS1ZNDQo+IHNpbmNlIFREWCBpcyBzbyBuZXcsIGJ1dCBnZW5l
cmFsbHkgc3BlYWtpbmcgc3VjaCBjaGFuZ2VzIHNpbXBseSBtdXN0IG5vdCBoYXBwZW4uDQo+IA0K
PiA+IE5vdGU6IHRoaXMgYWNxdWlyaW5nIG9mIGV4Y2x1c2l2ZSBsb2NrIHdhcyBub3QgcHJldmlv
dXNseSBwcmVzZW50IGluIHRoZSBwdWJsaWMNCj4gPiByZXBvIGh0dHBzOi8vZ2l0aHViLmNvbS9p
bnRlbC90ZHgtbW9kdWxlLmdpdCwgYnJhbmNoIHRkeF8xLjUuDQo+ID4gKFRoZSBicmFuY2ggaGFz
IGJlZW4gZm9yY2UtdXBkYXRlZCB0byBuZXcgaW1wbGVtZW50YXRpb24gbm93KS4NCj4gDQo+IExv
dmVseS4NCg0KSG1tLCB0aGlzIGV4YWN0bHkgdGhlIGtpbmQgb2YgVERYIG1vZHVsZSBjaGFuZ2Ug
d2Ugd2VyZSBqdXN0IGRpc2N1c3NpbmcNCnJlcG9ydGluZyBhcyBhIGJ1Zy4gTm90IGNsZWFyIG9u
IHRoZSB0aW1pbmcgb2YgdGhlIGNoYW5nZSBhcyBmYXIgYXMgdGhlIGxhbmRpbmcNCnVwc3RyZWFt
LiBXZSBjb3VsZCBpbnZlc3RpZ2F0ZSB3aGV0aGVyIHdoZXRoZXIgd2UgY291bGQgZml4IGl0IGlu
IHRoZSBURFgNCm1vZHVsZS4gVGhpcyBwcm9iYWJseSBmYWxscyBpbnRvIHRoZSBjYXRlZ29yeSBv
ZiBub3QgYWN0dWFsbHkgcmVncmVzc2luZyBhbnkNCnVzZXJzcGFjZS4gQnV0IGl0IGRvZXMgdHJp
Z2dlciBhIGtlcm5lbCB3YXJuaW5nLCBzbyB3YXJyYW50IGEgZml4LCBobW0uDQoNCj4gDQo+ID4g
PiBBY3F1aXJlIGt2bS0+bG9jayB0byBwcmV2ZW50IFZNLXdpZGUgdGhpbmdzIGZyb20gaGFwcGVu
aW5nLCBzbG90c19sb2NrIHRvIHByZXZlbnQNCj4gPiA+IGt2bV9tbXVfemFwX2FsbF9mYXN0KCks
IGFuZCBfYWxsXyB2Q1BVIG11dGV4ZXMgdG8gcHJldmVudCB2Q1BVcyBmcm9tIGludGVyZWZlcmlu
Zy4NCj4gPiBOaXQ6IHdlIHNob3VsZCBoYXZlIG5vIHdvcnJ5IHRvIGt2bV9tbXVfemFwX2FsbF9m
YXN0KCksIHNpbmNlIGl0IG9ubHkgemFwcw0KPiA+ICFtaXJyb3Igcm9vdHMuIFRoZSBzbG90c19s
b2NrIHNob3VsZCBiZSBmb3Igc2xvdHMgZGVsZXRpb24uDQo+IA0KPiBPb2YsIEkgbWlzc2VkIHRo
YXQuICBXZSBzaG91bGQgaGF2ZSByZXF1aXJlZCBueF9odWdlX3BhZ2VzPW5ldmVyIGZvciB0ZHg9
MS4NCj4gUHJvYmFibHkgdG9vIGxhdGUgZm9yIHRoYXQgbm93IHRob3VnaCA6LS8NCj4gDQo+ID4g
PiBEb2luZyB0aGF0IGZvciBhIHZDUFUgaW9jdGwgaXMgYSBiaXQgYXdrd2FyZCwgYnV0IG5vdCBh
d2Z1bC4gIEUuZy4gd2UgY2FuIGFidXNlDQo+ID4gPiBrdm1fYXJjaF92Y3B1X2FzeW5jX2lvY3Rs
KCkuICBJbiBoaW5kc2lnaHQsIGEgbW9yZSBjbGV2ZXIgYXBwcm9hY2ggd291bGQgaGF2ZQ0KPiA+
ID4gYmVlbiB0byBtYWtlIEtWTV9URFhfSU5JVF9NRU1fUkVHSU9OIGEgVk0tc2NvcGVkIGlvY3Rs
IHRoYXQgdGFrZXMgYSB2Q1BVIGZkLiAgT2gNCj4gPiA+IHdlbGwuDQo+ID4gPiANCj4gPiA+IEFu
eXdheXMsIEkgdGhpbmsgd2UgbmVlZCB0byBhdm9pZCB0aGUgInN5bmNocm9ub3VzIiBpb2N0bCBw
YXRoIGFueXdheXMsIGJlY2F1c2UNCj4gPiA+IHRha2luZyBrdm0tPnNsb3RzX2xvY2sgaW5zaWRl
IHZjcHUtPm11dGV4IGlzIGdyb3NzLiAgQUZBSUNUIGl0J3Mgbm90IGFjdGl2ZWx5DQo+ID4gPiBw
cm9ibGVtYXRpYyB0b2RheSwgYnV0IGl0IGZlZWxzIGxpa2UgYSBkZWFkbG9jayB3YWl0aW5nIHRv
IGhhcHBlbi4NCj4gPiBOb3RlOiBMb29rcyBrdm1faW5oaWJpdF9hcGljX2FjY2Vzc19wYWdlKCkg
YWxzbyB0YWtlcyBrdm0tPnNsb3RzX2xvY2sgaW5zaWRlDQo+ID4gdmNwdS0+bXV0ZXguDQo+IA0K
PiBZaWtlcy4gIEFzIGRvZXMga3ZtX2FsbG9jX2FwaWNfYWNjZXNzX3BhZ2UoKSwgd2hpY2ggaXMg
bGlrZWx5IHdoeSBJIHRob3VnaHQgaXQNCj4gd2FzIG9rIHRvIHRha2Ugc2xvdHNfbG9jay4gIEJ1
dCB3aGlsZSBrdm1fYWxsb2NfYXBpY19hY2Nlc3NfcGFnZSgpIGFwcGVhcnMgdG8gYmUNCj4gY2Fs
bGVkIHdpdGggdkNQVSBzY29wZSwgaXQncyBhY3R1YWxseSBjYWxsZWQgZnJvbSBWTSBzY29wZSBk
dXJpbmcgdkNQVSBjcmVhdGlvbi4NCj4gDQo+IEknbGwgY2hldyBvbiB0aGlzLCB0aG91Z2ggaWYg
c29tZW9uZSBoYXMgYW55IGlkZWFzLi4uDQo+IA0KPiA+IFNvLCBkbyB3ZSBuZWVkIHRvIG1vdmUg
S1ZNX1REWF9JTklUX1ZDUFUgdG8gdGR4X3ZjcHVfYXN5bmNfaW9jdGwoKSBhcyB3ZWxsPw0KPiAN
Cj4gSWYgaXQncyBfanVzdF8gSU5JVF9WQ1BVIHRoYXQgY2FuIHJhY2UgKGFzc3VtaW5nIHRoZSBW
TS1zY29wZWQgc3RhdGUgdHJhbnN0aXRpb25zDQo+IHRha2UgYWxsIHZjcHUtPm11dGV4IGxvY2tz
LCBhcyBwcm9wb3NlZCksIHRoZW4gYSBkZWRpY2F0ZWQgbXV0ZXggKHNwaW5sb2NrPykgd291bGQN
Cj4gc3VmZmljZSwgYW5kIHByb2JhYmx5IHdvdWxkIGJlIHByZWZlcmFibGUuICBJZiBJTklUX1ZD
UFUgbmVlZHMgdG8gdGFrZSBrdm0tPmxvY2sNCj4gdG8gcHJvdGVjdCBhZ2FpbnN0IG90aGVyIHJh
Y2VzLCB0aGVuIEkgZ3Vlc3MgdGhlIGJpZyBoYW1tZXIgYXBwcm9hY2ggY291bGQgd29yaz8NCg0K
QSBkdXBsaWNhdGUgVERSIGxvY2sgaW5zaWRlIEtWTSBvciBtYXliZSBldmVuIHRoZSBhcmNoL3g4
NiBzaWRlIHdvdWxkIG1ha2UgdGhlDQpyZWFzb25pbmcgZWFzaWVyIHRvIGZvbGxvdy4gTGlrZSwg
eW91IGRvbid0IG5lZWQgdG8gcmVtZW1iZXIgIndlIHRha2UNCnNsb3RzX2xvY2sva3ZtX2xvY2sg
YmVjYXVzZSBvZiBURFIgbG9jayIsIGl0J3MganVzdCAxOjEuIEkgaGF0ZSB0aGUgaWRlYSBvZg0K
YWRkaW5nIG1vcmUgbG9ja3MsIGFuZCBoYXZlIGFyZ3VlZCBhZ2FpbnN0IGl0IGluIHRoZSBwYXN0
LiBCdXQgYXJlIHdlIGp1c3QNCmZvb2xpbmcgb3Vyc2VsdmVzIHRob3VnaD8gVGhlcmUgYXJlIGFs
cmVhZHkgbW9yZSBsb2Nrcy4NCg0KQW5vdGhlciByZWFzb24gdG8gZHVwbGljYXRlIChzb21lKSBs
b2NrcyBpcyB0aGF0IGlmIGl0IGdpdmVzIHRoZSBzY2hlZHVsZXIgbW9yZQ0KaGludHMgYXMgZmFy
IGFzIHdha2luZyB1cCB3YWl0ZXJzLCBldGMuIFRoZSBURFggbW9kdWxlIG5lZWRzIHRoZXNlIGxv
Y2tzIHRvDQpwcm90ZWN0IGl0c2VsZiwgc28gdGhvc2UgYXJlIHJlcXVpcmVkLiBCdXQgd2hlbiB3
ZSBqdXN0IGRvIHJldHJ5IGxvb3BzIChvciBsZXQNCnVzZXJzcGFjZSBkbyB0aGlzKSwgdGhlbiB3
ZSBsb3NlIG91dCBvbiBhbGwgb2YgdGhlIGxvY2tpbmcgZ29vZG5lc3MgaW4gdGhlDQprZXJuZWwu
DQoNCkFueXdheSwganVzdCBhIHN0cmF3bWFuLiBJIGRvbid0IGhhdmUgYW55IGdyZWF0IGlkZWFz
Lg0K

