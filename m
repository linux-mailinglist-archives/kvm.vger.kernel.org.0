Return-Path: <kvm+bounces-56370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C51FAB3C464
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 23:54:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6845F17C00B
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 21:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38508274B2C;
	Fri, 29 Aug 2025 21:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eiHNIUK8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFC31A314F;
	Fri, 29 Aug 2025 21:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756504465; cv=fail; b=tPOtAMhcGVZtg4UmM2gc6X65OK0+eT9iW5oykWi4YMpKGvCFmgeCtOpmx1/hugTvJXMzFQs/BfOJxZO2ClOhzvri9BRzAhqMEyznFg0Bf5362bcdUizvGaW/8h5P3zCzAZxAPzSeE4v7CKom6Wvqve4upMfYc+84+GsAgcsMsCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756504465; c=relaxed/simple;
	bh=zYi8tbhSvCIh4WLiCbA7bhNaLJeUz7xs1Gd/00QEtbk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o7ZlS3Fow5LG2JhLm5R4XQys4zMVIT0QGeiHKjuwiQlgkqmU86IdBNlW3Eznvn51ENTyOMb4cHFMk+RiHLByElqcuZnLBGAAnCbHuog4oQPiz2rMwOF5IY85StNpV2Qb3zOLxXbKgW5rNUaAmaehsqWabyHaYPYyhn/JfJOy5EA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eiHNIUK8; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756504463; x=1788040463;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zYi8tbhSvCIh4WLiCbA7bhNaLJeUz7xs1Gd/00QEtbk=;
  b=eiHNIUK8f55kN/6emc2R6ZMNK/S8zELPT5syTNW0xAFnetUn19EZeFog
   s2Zj8+25wJTwPYVB3pd7icROncyMEN/G3BUHJoYfVp9r2LAP9X9SiQetY
   jsnroQnKD5cmnteGpUwarFDPvFNJnVInivZtm+DddQqX3RtI46c/wjvmv
   GfIqF38EDCTKN9Jg3pks3ExTimPfW3YDsth6nEcADIA95TTe1YZtPHQyJ
   KTQYVlyIyWubc6i+VkXT/xpC8sDfWLzpXtu7gKjYPOrXGOhYlvW+fQZkk
   G4SDZ8zJvW2NsL8squfOILF52ZV/8+C1g3F1HdlqMHd0R3mLcg1E4ODqb
   Q==;
X-CSE-ConnectionGUID: pozy46cNRGaUDv0WwliZyw==
X-CSE-MsgGUID: rrbZXe6qSjG3og99c7uSew==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="69391469"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="69391469"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 14:54:13 -0700
X-CSE-ConnectionGUID: wwoStF8QQz6uE3xnJzDAlg==
X-CSE-MsgGUID: AL7TDtE4RnSInXK2ogSXIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="175755717"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 14:54:09 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 14:54:08 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 14:54:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.42)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 14:54:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HjWWQrSA/UqakmMiSpMwHHU1dDQdkCYRsGAPwI8rXrFPu7ybHceRhaDjrvgSchccCX5gUq/w2G8+LAQ4fKOwruLoj5Rez1nfZGyiMUl4UILb+dc+JJeILKI+u1oZL/ZfNe05XvSikJaG4kEUCMyW9A4MXLNxJccrWUMqQLW2MmNsyn4WqdwZaT8C/iv5GdjkxvlrUAiFAlzUrJO0y4SoTAvxQh+wFNWNkY4sXgRWQXFwmH7yauyn93ak9n2jzMrRKH1AgXKOcXGH97Oss/GvWJzD3OkbZ8kmRVooTPPfWrmcGQaH367H6MckpFj798vt5/8AYlrpo/aKdlQx5xmrOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYi8tbhSvCIh4WLiCbA7bhNaLJeUz7xs1Gd/00QEtbk=;
 b=jSFpi3GeU2gCRMLTGFSy6SB9dc0M3gplPIsHWdjodE1sU6XW1DvMkpet39rLtKZdWNE0MoDIFsxMdTv/B6hRlUb2/LqHKejc3CKAQelUIUifW89fgKHU7ntzKWj5O2aQNZL4WjusdVaw84AUm6O8slhFOqXjiPCvtlFm2lDURM1OBKJlW1oLkkjTRlMJBA7ZgMNuQ5e0vkuXxSRsu+qHB1d8H4WkI8Rxow7fhKr4cXNCJtKdTzPzd93UUpv1oOT/2dBwRoLB4Ve+2AEMhtyrRZ2VdECaZFdglipFfEtPMU+oNj87ARpR1xm8JXuibOZPijX2LDw9rEhMRG+Zw4ZvHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA4PR11MB9231.namprd11.prod.outlook.com (2603:10b6:208:560::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Fri, 29 Aug
 2025 21:54:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 21:54:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Topic: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Index: AQHcGHjL8dqNtw+1DUm4eDEQMXeVS7R6DDCAgAAHQwCAABp0gA==
Date: Fri, 29 Aug 2025 21:54:00 +0000
Message-ID: <e3b1daca29f5a50bd1d01df1aa1a0403f36d596b.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-6-seanjc@google.com>
	 <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com>
	 <aLILRk6252a3-iKJ@google.com>
In-Reply-To: <aLILRk6252a3-iKJ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA4PR11MB9231:EE_
x-ms-office365-filtering-correlation-id: 4ffd4dc7-0dda-445c-304c-08dde7468fd5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RUl0V3RwQXhNb0ZRZzIrMnAveTM5eTFUZ3VCWFZXcVo4SGdncFkzc3M5eHRk?=
 =?utf-8?B?Y01XQzY5WkIvdVRvMnhmY0ErZG9uNDN3U1gyUUtzVnNyaGduM2dVNmNLSkhP?=
 =?utf-8?B?aEo1UjVwaWNoa1JTRTlxSVdnK2c4RUt2NXVjV0c2QUZrSnQ5YTM5aTI2YkFB?=
 =?utf-8?B?am5RTEFEUTkyQWIyKzMzUFdYbklWbkxzRXhiNzlEWTNCRHFoNUlLblhkeFVx?=
 =?utf-8?B?VEg3cDdWTnlZa3RzdnpEbHNnK2Nsc0MrTG9YSlZwZWxCQTlXSlFsOHNTVHRU?=
 =?utf-8?B?eHordDFvbTFWc1VnY0tyQjdGU0lvZzcxNE56L3pUd0V6OERLOWZzT2xtMmdw?=
 =?utf-8?B?U0ZGWFA1RjVHVDVCZ001WHMxamtuSkcrTzI1eVFadzFjTlNiaGNONnZjSGFC?=
 =?utf-8?B?UEdTOEd1bmttZ21aVllIY3AxUW02ajF4T0NoR0preFU2ZXQ4K2wyYW9yY1dX?=
 =?utf-8?B?TWZtdWR4cnpjZDhHWHJ3bVdwSnY0ZW5GR2k2QjFxd2pxZ2JVcVlpSk9XTllu?=
 =?utf-8?B?b0t6Y0VoQWtHRGgvZ3FEZFUzb0wzY1JBQkhTcmtweWV4V2tBOXFOSzUvSWN2?=
 =?utf-8?B?Y20rUFQwN1BUVzFza0tRbzBNcDM0NTZqaVk1RUEzWHJlYTdPZkVxeVNQclJv?=
 =?utf-8?B?MmVOMVUzaWNTSHcvWW05dThzc25zL29BYXdkaEljd09EK05RbjhQUzF3MWNT?=
 =?utf-8?B?RC9kYnFMSkdONTBnaW4ydXRDd0dvZVgyMk1KeDJlNXZILzdVOXZSNEYxOXZC?=
 =?utf-8?B?VnhpeWhsN2ZQbXM0RTBJMlpqMTUydXZCZjZ0d3RwVFQ3bmhKNkd3bHpkbFZ1?=
 =?utf-8?B?eFNNV0N2cUU1a1lldldVOVdJWnYyVEw3UCtySzdPTURsVHI0UnRURXgzTExk?=
 =?utf-8?B?V01VSVduTVpCcHBZUFVlbTNJR05UVGNMVitiVFVnblFRUVZMa292M0N4NEtU?=
 =?utf-8?B?aWdBMitqQWdOZHlNaFVZdHlkN1EwWlhpQWVaNUd6U1ZQUnhzOTNyYkE4NGUy?=
 =?utf-8?B?MTNWcWFlU2I0c1p2VFA3RmpNcGVScktlOS9RalcybEVTY2tBRjRla1pvWFMx?=
 =?utf-8?B?RlM4YWFnUkpyelE3UCt1Z2tYZzF0d09KR0o0SmI5VjczbkJjKzQwU1crT2hl?=
 =?utf-8?B?dWJzY2lTcHA4eXBDeVRtV1NGRFJHWElVdnhMVjV6Sk0vWjdLOGNzZ0kxKyt4?=
 =?utf-8?B?aEVVNkYvZFM5Ykx1TXlydm9rZ3F3VXgzMytxNHdiVXBQRFA0c1RyYkZ6SnNN?=
 =?utf-8?B?eGdKN1ZJSUJnR2pZQzVZc3ZsUlJKVnFqVGVxVTU2MVFUWFlEZUcza2U3Z3Vp?=
 =?utf-8?B?dFMzdFRESWgzcUlRR3FlZHF1bEZYaVF4NVlGNWRobWN4U1diRHdPdjgxUTNq?=
 =?utf-8?B?bmoxa0d3aU84T3dBUG1qd0c4MGdKcnNBU0d2Sy9zUGpCd0llQWNQa1BqQWdy?=
 =?utf-8?B?U1BPakNCd0dPckdhV3V2cGIxaExDVDI0NHVvaFBMakI3ZzFzV0hXKzdPMXl6?=
 =?utf-8?B?a2lNVnZTREJPR3VhRXY3Vk4xcFNvM1hTRGJTKzhjalBWWnJRanlMdTFPRFVz?=
 =?utf-8?B?R0x6Q3Fac2RMTGJMK1B2NmF1bkFOUXk5eE4rOU0ySGhwcUN4K282YjZhbDdF?=
 =?utf-8?B?SW9hOGdVRWg5a1F6U2E5NVdtS21NR1FOUHhRZFlFeU9TQzBxM3FMR3k0UXZz?=
 =?utf-8?B?SDdBTm1nYVVpcXBZRkYyaDc1aGo1MlhTR1BhVW9BREI4Zkhsa3Vpck1pWjk3?=
 =?utf-8?B?d2FKeTVqaFM4UDc1RU9XbEZ3TlFQL21mRFZhV2hHeU9QRWZCaS9kTHBzNHpt?=
 =?utf-8?B?VlBIaWFIb3kyOWljbEErN1hsVmZBUlRNQ1c4bUZvNUpWRjc4OFB2UUNva1RD?=
 =?utf-8?B?ZStGZmVwZUQ2MjRRRU8ybUJXNlFWYnUvMFRzc1lEYmVvcjNpbTRxWnJxZHkz?=
 =?utf-8?B?SnB1UGdDNUx3WmxyRVFFaHFjT0Vad01QK3BHNS9tUmtGN0RLV25POU5icFNy?=
 =?utf-8?B?M2FGeXZoaDRnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aERLdEdyVjMveEQ1UGw4NlQxQ01Fay80b0dxZkNOcWFiakZCZWN0TGtWeURU?=
 =?utf-8?B?TFA3MjVPNy9RUWtrdmxtSkw1akNNTzBGRE1IRTJDWU1ESWJRNTNBeWpYa2hx?=
 =?utf-8?B?a0FSTk5xc25TbnVrQU5VdFg5ejJQY25WS0xYUU1hOXc1VzJGUGlWd0IvTHhq?=
 =?utf-8?B?Ri9ETGV3R25EYmVwY0hIZ3JFeHhyOFBCcmRXQzdTY2dUVmNxV0hCd0xJaFFp?=
 =?utf-8?B?THlIaVR3TCtPTmExTkJpYStEaFBidE1PcEQyTEVMNkpYMnhFSlZtT3hOeWJw?=
 =?utf-8?B?LytLWVNRS1UzY3RQdVZCM1hKWXNxd0M3cC9xUmpqNTU5RGxpamFEUlplamNz?=
 =?utf-8?B?NSs5aHZNU2JoR29IVGxENDNvL3pieHZOWklsS1M4dW9tNlhVVUVtYTBiclhv?=
 =?utf-8?B?Z1lVWTQzZEcxTEVVR0xnaUVkekxiVGdFWTd3ck5zRlhzSXZoVGcxZXg2Ykti?=
 =?utf-8?B?Y3krdFh6TXhITUhQb3F5L3YrdGVoQ2VyN2VKWUJGTVlmV0IwNkJSZzhtcG9i?=
 =?utf-8?B?dUZwUHAvd0t1RE9pVFk0amtJSVgzeXkzWTNwZlQvRTZoNkxnNmZtZHpXTG9q?=
 =?utf-8?B?cWhjOWEwdk53Tk1YTDk0RHU5NVFlcGduYllpVFhNcGxKdmV3dktLck5GQUJX?=
 =?utf-8?B?Smh1dDRkWE1rTlNzVVloQThCVHowNndTTktEd2toTjRUclNFT2R1VVVxL0N1?=
 =?utf-8?B?OHpRL21BUGE4RERpYk9jR0NnMDVWWHhMck1JeDB4ZmxVNnhkWkMyOEdYOERw?=
 =?utf-8?B?N0hyMUpaa1hoV1l2TlpOamc1WVlOaW1pcFVGeGQyMngzbDROSVpIOUkxMDdt?=
 =?utf-8?B?clNoVmRoR2tlZHBmWW5uTTYydS9KMHZHeFNJZE1ReTZTSEVlcEc4SlNCRStz?=
 =?utf-8?B?OEZNTUpYZ3hzQ1drQlFJamoyM2ROaXMvZUM4TGl2YW56S0NseGhGZ2JiWklO?=
 =?utf-8?B?OEJndStmdSt6TnlQM1kvTmd1TG53bVIwb1NBUUhrU1JGQUd6N2k0bno5enNK?=
 =?utf-8?B?dGtzVHRoQUJNanBlakVkUWdMOCttWkFYY0lWUjI5MWJHNCs2cmFqUnh5VHhn?=
 =?utf-8?B?VFI4TllOR0twRGFRWWFuSnZNV0xCakE2QjI2Z0Vtb1o5SjVQS3luSStjVG5m?=
 =?utf-8?B?eXpCZ0RUZFFWdTM5TlpsMDVLcDFxb1p6UmhwaUhUbTlKK1ZJaDZHUWpETnJZ?=
 =?utf-8?B?cEJCOUU3dzBOc0ovclh2TXRFallUL3BiZkgxN0dJNVlKWEYydDZENnR6OXNC?=
 =?utf-8?B?L09ObG9ZVysxOEptZVJlV1FJOUEwNGt3UTV2NnRheHpYS3FKblM4ekpPQ1Ur?=
 =?utf-8?B?VXhFd04xL1hhZCtSR0Y5SmFMQ1RWanhMRU5QWjd5K2ovK1NTTmhLR2xhNyt6?=
 =?utf-8?B?S2k1ZkptZExUNUJWbXJSQ2I4TzU5UStxLzdwbnl4dk1sZGVzZHY3Wm5pR0hJ?=
 =?utf-8?B?MzBnMkRWQUVzRVlzVlo4aUc0RFhFc2czTmhmUURwaTRYUWdXcm5SMXk1NUZT?=
 =?utf-8?B?V3RFbVFNemVHY3BaZ2ZpelY5ZXcvQVE1UGxhTk15S2tEQkZOd2NZRmtUZk51?=
 =?utf-8?B?L2lQNkRtdnBzaEV6dFVUOVBXQ0I1eHgxV3RSUTA5T0QyazNmTzhrUklLR3dS?=
 =?utf-8?B?SkdObzRGZVZXS0hFWDNrQndWSExydlIxTFNxZDcwTDlmc0hDU1h3YlM3OVhY?=
 =?utf-8?B?amVpdVJ4NXlVejBWWXl0VG5aTUovbnV2ajlMdkc5akxhUjV6aTVNL002SDB3?=
 =?utf-8?B?SThDU0VkbG1xVER2WTE4K21Cb05pN0E4T2JEelB3SFFkVXJSdlduY28vbDdy?=
 =?utf-8?B?OFVkMEVHY3hGSThMQmp4ZzJibXB2Y3pCQmx6S01qeDE0TDF2ZzFNS2NCMzlP?=
 =?utf-8?B?Z1NmanZ1TitIMnlOR28wNVdJU2FBMTVFMFVvbU1za1crZ0xxS2E0RU9kaldK?=
 =?utf-8?B?YnRDUENJSDRlMk1pVjYxbTZ6bmU2dWlEVGppQXFadTl4d1NqbjBYZnVmQXZ0?=
 =?utf-8?B?Y2I0M3RaVENURk1mWGhOUjdvUUxPdVR0WmQ1TVA2U2lwTHdPb1VtY3BmdjVs?=
 =?utf-8?B?cVVkNERaREhudXVUemV5V3VwUHBYaFlEU2ZGVXBwZHIzY2MxRWxlOWlYOTEw?=
 =?utf-8?B?cFB5d29XOGJPemtwYWpMNjlyM1BoOHdNVnYvcklOdkh2QkQwMW5tZllzWWVP?=
 =?utf-8?Q?+qJacLDeoalVcH+M2tcQTcQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0D91547C80DB747A9052FA0AFB1DAFE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ffd4dc7-0dda-445c-304c-08dde7468fd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 21:54:00.3154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hbPQa5ueZt5nxuGxJ4WhniTQ0mY7ZA+dgg1U7MEb3o9mUC5RUiKiH11jpR5IPzONduo8P6HVH9P1iY9MxBoSqzY/qsVXra44pNC7kxdzpJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9231
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTI5IGF0IDEzOjE5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFlhbiwgY2FuIHlvdSBjbGFyaWZ5IHdoYXQgeW91IG1lYW4gYnkgInRoZXJlIGNv
dWxkIGJlIGEgc21hbGwgd2luZG93Ij8gSSdtDQo+ID4gdGhpbmtpbmcgdGhpcyBpcyBhIGh5cG90
aGV0aWNhbCB3aW5kb3cgYXJvdW5kIHZtX2RlYWQgcmFjZXM/IE9yIG1vcmUNCj4gPiBjb25jcmV0
ZT8gSSAqZG9uJ3QqIHdhbnQgdG8gcmUtb3BlbiB0aGUgZGViYXRlIG9uIHdoZXRoZXIgdG8gZ28g
d2l0aCB0aGlzDQo+ID4gYXBwcm9hY2gsIGJ1dCBJIHRoaW5rIHRoaXMgaXMgYSBnb29kIHRlYWNo
aW5nIGVkZ2UgY2FzZSB0byBzZXR0bGUgb24gaG93IHdlDQo+ID4gd2FudCB0byB0cmVhdCBzaW1p
bGFyIGlzc3Vlcy4gU28gSSBqdXN0IHdhbnQgdG8gbWFrZSBzdXJlIHdlIGhhdmUgdGhlDQo+ID4g
anVzdGlmaWNhdGlvbiByaWdodC4NCj4gDQo+IFRoZSBmaXJzdCBwYXJhZ3JhcGggaXMgYWxsIHRo
ZSBqdXN0aWZpY2F0aW9uIHdlIG5lZWQuwqAgU2VyaW91c2x5LsKgIEJhZCB0aGluZ3MNCj4gd2ls
bCBoYXBwZW4gaWYgeW91IGhhdmUgVUFGIGJ1Z3MsIG5ld3MgYXQgMTEhDQoNClRvdGFsbHkuDQoN
Cj4gDQo+IEknbSBhbGwgZm9yIGRlZmVuc2l2ZSBwcm9ncmFtbWluZywgYnV0IHBpbm5pbmcgcGFn
ZXMgZ29lcyB0b28gZmFyLCBiZWNhdXNlDQo+IHRoYXQgaXRzZWxmIGNhbiBiZSBkYW5nZXJvdXMs
IGUuZy4gc2VlIGNvbW1pdCAyYmNiNTJhMzYwMmIgKCJLVk06IFBpbiAoYXMgaW4NCj4gRk9MTF9Q
SU4pIHBhZ2VzIGR1cmluZyBrdm1fdmNwdV9tYXAoKSIpIGFuZCB0aGUgbWFueSBtZXNzZXMgS1ZN
IGNyZWF0ZWQgd2l0aA0KPiByZXNwZWN0IHRvIHN0cnVjdCBwYWdlIHJlZmNvdW50cy4NCj4gDQo+
IEknbSBoYXBweSB0byBpbmNsdWRlIG1vcmUgY29udGV4dCBpbiB0aGUgY2hhbmdlbG9nLCBidXQg
SSByZWFsbHkgZG9uJ3Qgd2FudA0KPiBhbnlvbmUgdG8gd2FsayBhd2F5IGZyb20gdGhpcyB0aGlu
a2luZyB0aGF0IHBpbm5pbmcgcGFnZXMgaW4gcmFuZG9tIEtWTSBjb2RlDQo+IGlzIGF0IGFsbCBl
bmNvdXJhZ2VkLg0KDQpTb3JyeSBmb3IgZ29pbmcgb24gYSB0YW5nZW50LiBEZWZlbnNpdmUgcHJv
Z3JhbW1pbmcgaW5zaWRlIHRoZSBrZXJuZWwgaXMgYQ0KbGl0dGxlIG1vcmUgc2V0dGxlZC4gQnV0
IGZvciBkZWZlbnNpdmUgcHJvZ3JhbW1pbmcgYWdhaW5zdCB0aGUgVERYIG1vZHVsZSwgdGhlcmUN
CmFyZSB2YXJpb3VzIHNjaG9vbHMgb2YgdGhvdWdodCBpbnRlcm5hbGx5LiBDdXJyZW50bHkgd2Ug
cmVseSBvbiBzb21lDQp1bmRvY3VtZW50ZWQgYmVoYXZpb3Igb2YgdGhlIFREWCBtb2R1bGUgKGFz
IGluIG5vdCBpbiB0aGUgc3BlYykgZm9yIGNvcnJlY3RuZXNzLg0KQnV0IEkgZG9uJ3QgdGhpbmsg
d2UgZG8gZm9yIHNlY3VyaXR5Lg0KDQpTcGVha2luZyBmb3IgWWFuIGhlcmUsIEkgdGhpbmsgc2hl
IHdhcyBhIGxpdHRsZSBtb3JlIHdvcnJpZWQgYWJvdXQgdGhpcyBzY2VuYXJpbw0KdGhlbiBtZSwg
c28gSSByZWFkIHRoaXMgdmVyYmlhZ2UgYW5kIHRob3VnaHQgdG8gdHJ5IHRvIGNsb3NlIGl0IG91
dC4NCg==

