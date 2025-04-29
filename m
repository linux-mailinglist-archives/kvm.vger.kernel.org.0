Return-Path: <kvm+bounces-44641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 765AEAA003B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:23:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B63B5A7BD3
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5037926FA67;
	Tue, 29 Apr 2025 03:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NDGCUw4y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE0B35972;
	Tue, 29 Apr 2025 03:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745896971; cv=fail; b=jOyXOAZkerwy8jITte2UKxT+Nhmaxjxgn2spNFaGfSyxlppvo/0uGZHhxNEF6wMYf2eOTz57ic4bDX/GARBy/2IU4q8AID2kXexOrEu+wgXi7J2IVskZFZUdE0SmfgPY0iojpidkOBdoqMRR38A4wZPzCQVjE2Bvu8nnwAjaLqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745896971; c=relaxed/simple;
	bh=J9llqV5E+E50XOCUbZNED1fmFrPErqPGcC785niTJ08=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=POqFH2aC877RNazcU0rtPH7BcVgaLmbbqV/ziiVTjHK1yPM04QB2ozQNSxNkmDgLAx0CLBAxr1avXE40ubY5BmoklERUMmulPzDpDxYSTjqI8EPN5aLKshUqRhen8x/lQWOto90D6MzltmDLfMoWB3H7m1HfpX6DbtymPW7nlk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NDGCUw4y; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745896970; x=1777432970;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J9llqV5E+E50XOCUbZNED1fmFrPErqPGcC785niTJ08=;
  b=NDGCUw4yyZpi3qw1fk6eHhnvL7pSlkGW2vIGWyub4fRODzPF3pdx6Xos
   L3Uz4koXoBsHBJPH9sID3Kb8K/5PRNH0t62DMObRDQis+KEBX30WFBNJL
   L95KeeT98vCLhh6YTO82mEhxHYSrrN7e2jARWnEiiPJ++JqvVJtadHk2p
   ROpVpWcaGB3tFlth9H+EX7l9An+Q0IgOK+HoCTLiNbHpcCbRnYneO1xNC
   Hu9RtIMGF+C6TtFrqhGNP5bRSfv/EyZ7norRF9FhkMO3qoJj2Kc5dSs8E
   3+mhbAoi12Jlf7vveU1786nNKNDkhT2w0vW95ZMeC0lUVW1NM0gW3ObUk
   Q==;
X-CSE-ConnectionGUID: 1ZTcPUsQRLuO0t6DxtvU7g==
X-CSE-MsgGUID: 0JdkJpDMRMesFsyR5Z3mcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58158113"
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="58158113"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 20:22:49 -0700
X-CSE-ConnectionGUID: ickkxaFzROunjrkpV2CTAg==
X-CSE-MsgGUID: hJavPLaXQAieTFJShjacOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="138790217"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 20:22:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 28 Apr 2025 20:22:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 28 Apr 2025 20:22:46 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 28 Apr 2025 20:22:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V9Xa4gyMhWlpNQMwJyRbDkhYdw/9C2KL2GIoONahZd0oH8b9+M4k4DdSh4B1PRO17ASFftnUIdSD6ZODMEI12XhMsr/Vy+0U8ECe1ODQJTvEYDuTTrh0oyYhVZZlQk6Orn9zU55YUSdiOP1mwrLO9ZUENe3JA3hSI67ejAineZMmnkrzhT0LqoR8k7XzepruKhtvChvVRqMjU/WuLc6WHnOru08LdwzVaKst74ED8N4syR46Z5dMAQQoc5HhB0iW2UYBjPelCA8ErEEq2Zmkr9KCH62+kvENO8589KwALMSneuSmBbPjeVBkH5vVFYFigIxGdMyYL9WqvhZcZVAdPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2h32UMZk25lVKo2u1auuJ7Q9fevAbCVV84CMXXSpDc=;
 b=w5q/Dh6S3f/C03bdYx+wcZiMtlc7hovPDBZz13APonwQl82bIP4mCveBn42qRpA+dQQytrbVEpI+EZ6hKxc3oXjOrHokUOE8G2BUpfzut1PgO+Q59g2jUEJYEbUfIdj/qvkSUjcR5HBvk6TnC19eyP0RfiwCgl2zE4lE/a6YG4U1Walz10yKMaPRnNnt1ftGQpsdPaZwQO+DV/E6fal3wRa9QnnhPzz0yCggRw9F90sr2zMr8f0ssxbvKhRs/u9+9mtmdncW1I5c8ekvfLXp90Xu1WcwUP6NuIteK/gfSFhWEPe55ZsrbL00vLeCWj46RSQnWKvRS6oTZ+GcE7KMeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 SJ0PR11MB4830.namprd11.prod.outlook.com (2603:10b6:a03:2d7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.31; Tue, 29 Apr 2025 03:22:41 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%4]) with mapi id 15.20.8678.021; Tue, 29 Apr 2025
 03:22:41 +0000
Message-ID: <fbaf2f8e-f907-4b92-83b9-192f20e6ba9c@intel.com>
Date: Mon, 28 Apr 2025 20:22:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Spassov,
 Stanislav" <stanspas@amazon.de>, "levymitchell0@gmail.com"
	<levymitchell0@gmail.com>, "samuel.holland@sifive.com"
	<samuel.holland@sifive.com>, "Li, Xin3" <xin3.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "john.allen@amd.com"
	<john.allen@amd.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"vigbalas@amd.com" <vigbalas@amd.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-4-chao.gao@intel.com>
 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
 <aAtG13wd35yMNahd@intel.com>
 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
 <aAwdQ759Y6V7SGhv@google.com>
 <6ca20733644279373227f1f9633527c4a96e30ef.camel@intel.com>
 <9925d172-94e1-4e7a-947e-46261ac83864@intel.com>
 <bf9c19457081735f3b9be023fc41152d0be69b27.camel@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <bf9c19457081735f3b9be023fc41152d0be69b27.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR20CA0026.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::39) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|SJ0PR11MB4830:EE_
X-MS-Office365-Filtering-Correlation-Id: c06e6fba-3483-4d92-420f-08dd86cd196c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cHdEVXJ6bkZnRzdRSE1uUXprNytUdVdIcHdOZUZZRUxqcEt2cXdHcmRzK21q?=
 =?utf-8?B?dHd4ZncwQzFVUjFRL2tkQmNnVE5idmNSTVpGdndVcjhmNmFHOStJWGcvaEFx?=
 =?utf-8?B?TFRJM0RmSXptdFJuVDJRMDFvYk9YSytndDdhUUVHWGJOcm1NZm5aR0VpdVNN?=
 =?utf-8?B?aVJGM0k2R21LRUsxTlBYR2UxcGgzTFNTZ2ZRL1piS3NhQ2JSckZ5RUE3Z1Uy?=
 =?utf-8?B?cmp5a3FGZXVEclIyTXdsc0ZBNHpXU2R1OHJjVTlCVzdJc0htU3A1S3d6YmJL?=
 =?utf-8?B?N2xUend5SGhCd1MvS3BEd1psNUh2ZkNpb0dlQjZoS3dRVmlqOTNEcHdzK3VQ?=
 =?utf-8?B?aHZIendMcy9ETnBvaENVeUJ0dzNBNGkvQ3FXQlVHS0JsK05pNG16OGJIRGlw?=
 =?utf-8?B?Z1hDbzIyL3V0d1dFRUkxVW1HSGhCRU9kMEFybUdyT2l4L0hkRGNPQ1krcXFv?=
 =?utf-8?B?d2N6TDM5NG9BbHo5MENOaFF2MmJweTkyd2t1aTloM2o5ZlZFRlJKa2graGZt?=
 =?utf-8?B?OWlJVHFLSUhtWWNUdDhvcE15YXRoczRWazdnTFNDNnZqMzUwMnNnSk9obGNn?=
 =?utf-8?B?QlFPQ2pKZ3FzUjdXK2w3ckNFclhXVTRQVWNFUTJGVVFIZU9hK2dRaEF5SW5k?=
 =?utf-8?B?QVFBNG5oN0RMMG8yU2hhWFNsQmtncld3aXZkRmpxY28vcllkbXFPQTJqMGRw?=
 =?utf-8?B?Mm1GWUhET1hOL1NGMzVKc1B3TUQrc3BkNk5ZdTNVT2VPY203bnpjZDlqc2Jv?=
 =?utf-8?B?UFRXY0V6cWNCVXRrUEkvUjhSSzZVZEF5Uk8wMVQrelQzSlZEUWo4dHF6UTdu?=
 =?utf-8?B?bjBUSytRZ29aZ3NJRVJpTDVTZFl4WlRBNVJGNzExK1c4MCtVQmxLOFg5NXpk?=
 =?utf-8?B?M3ByMFNiaHJMNkdnVTc5alNJZVhIYmJ2RUdKbkV3YndlYlRwTmNUbzhzZktN?=
 =?utf-8?B?LysvcUpKbUpnWUlYWWlJSENLV1kyVXVFeDlhVDYyOGJob0psaE1lMFdwdVRj?=
 =?utf-8?B?a3VrSmNUVHlGZTNpVW1ibE9MMFp4Ly9Dd2lZZGZ1MVpxVCtQZHJFelNTMEJ0?=
 =?utf-8?B?ZDRYWlE2SXlHKzdXeWJsNHdGdE9xVHRFMmtmU1Vka2lYZDBOZU1mMlNkOUVQ?=
 =?utf-8?B?UDZrMUpEekpzZU1TZFZDMXpTcDg3dTRIb0dQYlJMRVM2N0JhcEhlRll6V3NS?=
 =?utf-8?B?L3N1Z3QvK1c3R1c5S3g4NlNLeEtGd2tITEw0ODlwZG1BdGpnL09BT1BNYzR0?=
 =?utf-8?B?YzJhT25kMC9ZUnl4eVhTc1o1cThmQTNyb21jL2YxbjVzYWx1QjFod0JlN1h4?=
 =?utf-8?B?aHpTazJndllwcWZCeGtXVUpsVFl1V2ViZmdPbVRXY3FhcVFnZk1HNVI1Ylcx?=
 =?utf-8?B?VGlHMUdOUmF4REhCN0FwcXF6djhndGtabkNFTnJZMmlVU2gwN1UxRzNLOTBM?=
 =?utf-8?B?UFdmamF4dmNyZ1crOWdwZ0lmYTZ2SW5Uc0tiV1NNNjYyVm9hQVhjOG94Tnl5?=
 =?utf-8?B?UnAwdTNVdzFVRGdRazcxSnlWc0txSllsTUg1amV6T1dGVTlDbURzRG1NcWhX?=
 =?utf-8?B?QzNDQU5FQlc4bWQwNDF2VzdkTWJPQVArRUJ2SWxzTmxRSC9DZFFtYkNJMlgz?=
 =?utf-8?B?dk5DRUJMaC82Zks2cGNyWDlSMGk2NHV3cjE4SkE3QlhLOEdGKzFBeTdXeFBX?=
 =?utf-8?B?V1RzSWNRb1pLTkZhYUFCWXBHWDVVTFJ5TERzTWoxTmN6T2krTUFGYS9rTXR6?=
 =?utf-8?B?ZFYyejZqQVM4QURPVVAyTVdoeEVBTVJ1U0JNRVpRVTcrRGlNVEROTkNUR3FT?=
 =?utf-8?B?aFg5TGJadWh0Q2ZrMWZpSHVOQjdINlltVVRzaEVqUGxRQ1FqMlp0RDVFMnRv?=
 =?utf-8?B?RDVnWFUyK1l3OStwV3loUnJuaWdMdGRJOGlhQUlnMFkvVnc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWU0U3NXQmFOVHZLWENkRml3NS9TSzIrUlAvMzd4RWw3RWhhSm03RHlUazlX?=
 =?utf-8?B?QVNxdnp2Rm51dEVRb3QvcWRqbjNZRmp0bG1VSkNiRHlnMUxkemFhdjU3amFx?=
 =?utf-8?B?a0RwaytqcWs1Y1RFK1NmY1B6QXlwTnVhcnJRa2czWWZrK1I5c2VscGNNNzA5?=
 =?utf-8?B?WUxjNWlIZGd1dldweWFoVERvZ3ZjVEdtUGJlMGZUb1M4NkFmdEpkUEE0dGpr?=
 =?utf-8?B?LzhzcU5odXNLMm5SQXZBRmJ5cEl5TWpsclJzZENMcWhSTkFoL3YrRUF0TDFT?=
 =?utf-8?B?MGx6aTUrMGZCY2JRY3IwNXg0eXdXeGRkRlN3b2tCQmxUVHIyN2JyNVlNR2JS?=
 =?utf-8?B?RVpHM1pvTGFxcnRSdUFXQWkwRWpPMElaR0pFcXB4dTV0cHVzMGZNSElZMXUr?=
 =?utf-8?B?VzhtQm1aZkl0OXRhL2JXMlZOc1laaFQySGIvdWdFeDBMejhUS1ZUS1NkZ1FS?=
 =?utf-8?B?bUN2SVlKSWtaWGUxeHVXSDBqZi9wcGMwQkw0TFcrZm9SOGJYYkRCOTRVUUZ0?=
 =?utf-8?B?Z0xKTkdkakhiZmxtTzVWb2J2VERBSXZMWE9Xcy9LQkV5bFBUZjRzMTVLeGpQ?=
 =?utf-8?B?TGsxclQyQWN3TlJzUTRIMUxZeHUyTnhkdUdLQndORFRReW5ZbUZ0VG50d09a?=
 =?utf-8?B?MUlvYXFhQjkxZTFFVHZqRVBkV05BaThoY3RMNUs4OG5BZW8wMjBqTllJQTQw?=
 =?utf-8?B?WVBqSE0xdHVnOWgvY2U3a3RMQXVTL25PSDRlL2xiMUZKdmVuOU1UQ25XUjNR?=
 =?utf-8?B?UWNwUGlndnJ3TURLK00xMW9GdTBJSi85RU8wNEhUT2NSUE93bEpIVG9hMzNi?=
 =?utf-8?B?aXdncmVRY24wZW9TSHN5RnhCSXorZDQxWGxLMWhPYldYQ2t0R2czVHByZ0pN?=
 =?utf-8?B?Z0lDS2dtZE5RQTlEOTQvV25rQkx6K3lwemFzaDJEZ3JhS0hBSS9kY0RJNUNM?=
 =?utf-8?B?NnY5b2FNSUptNHlkOTJadG56Wlk0SmxKeVRuUWx2bXdsNG4vaXB0cjZ0MXpM?=
 =?utf-8?B?eERINWVXenRPd0tJbG1TcGFmSXprN0M4Ky9yWThFUXAxSzJuODRxQmVzd3ph?=
 =?utf-8?B?M2IzOXc5ZFZMMGJxOSt1WnJSRVFRTEwrakxvZ0E0US9YK1J5a1B3NUFESEhW?=
 =?utf-8?B?K1pUMUl4ampVZGcwemNUb0g4WGg4czc5YWN4cjQxakRoaDdydWp1SXBvODZJ?=
 =?utf-8?B?aElxNERIK3NIMU13RDgwU0kyd0lZemtKSTduRHNIRHlwTWpieE1uVmc2dUN6?=
 =?utf-8?B?U09NZU9paTN3bCt2SGhrdTlreEhLNFFUYTNDTFFYZUE4VHdhOG9RS0pEbUt4?=
 =?utf-8?B?c0hPM3FvL2hvOGR4aTk0VXIrT3l2Mzh3NU1tOXZqNlYvMDBCSHR2SkYvdXhM?=
 =?utf-8?B?TkluNmo5aUt4ajNBV3RCd1dMbTFVWFZ4S2sxalVXTENheTY4blpvTXEzOXJk?=
 =?utf-8?B?L2poenNmNXRxNmpwQU5XVUwxRGEvODQzQzRjVHFObUZybGZQbmVyenRVR3Ja?=
 =?utf-8?B?cXppMEhMRU5oVmhwRitCMXoxOHkyNEowb2lOa3lIOU03emE5MVRHYW8rT3dD?=
 =?utf-8?B?M3BaL3JCVDUyZVVSQ1VqQWRHZkVoZkF5cHI2TGJwMVl2L2lGc0h0RTJFRTBi?=
 =?utf-8?B?Wmo2eUpJdVkzSmkwNGtjZG82QWtsanpHTXJtS3Y0MityaFo3TEpFT3lSU082?=
 =?utf-8?B?SG1SWFZFRGtXMzlDWXpPY2dqbFdVVS9jN1ZVNTZ3enphK3VsVWd1aDhOMkY3?=
 =?utf-8?B?MUZSTWJUWEcrVS9QSUc5SEFTZzloUUZNRjNvZkprelA4aUJ0WHh3M2VmVmlV?=
 =?utf-8?B?Tkpuc1BKTVREUmNNMU9kc0FWL1Nxb0Q3b1VFakRVSitZQzY3b0NFTDBCSTlW?=
 =?utf-8?B?ZGJjdEZJdm43YUZpWElOU21BdDZDdU13L2QrZDFubnlVM3IzeUhHOFVRVVNr?=
 =?utf-8?B?czduT0k4dkJzNDB4UXA0cCs3TkxoUG8rLzVyWjVoT09lanRDQTVRYytqY3RS?=
 =?utf-8?B?dnVZcmVId2h2U3lDZmV4bXFEMXY3OTA4NlhkQTRob1VLbDFDREJLVnlzeFlD?=
 =?utf-8?B?c2pKNUkvZDJ4SU52dkdtd1FTYW8vR2EyZCs1VTNWaGJQU1hsVEdiTkZjMzYy?=
 =?utf-8?B?T003YnZsUWRKWXVoaGRCVk4vVDg0NmxKaDBScGR4eU5PNS9idmRrcWZMamJs?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c06e6fba-3483-4d92-420f-08dd86cd196c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 03:22:41.1070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ucaS8J4sX5iYDLoYktd8jizM9XOokpKwBCoiyGGPdRLn4FFeeL5P1sG2Tvdg/UbvpQRoF3YkuIlGovItkFD6dMpADsQETnvx6iTJd6j/Os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4830
X-OriginatorOrg: intel.com

On 4/28/2025 7:50 PM, Edgecombe, Rick P wrote:
> On Mon, 2025-04-28 at 18:11 -0700, Chang S. Bae wrote:
>> On 4/28/2025 8:42 AM, Edgecombe, Rick P wrote:
>>>
>>> Right, so there should be no need to keep a separate features and buffer size
>>> for KVM's xsave UABI, as this patch does. Let's just leave it using the core
>>> kernels UABI version.
>>
>> Hmm, why so?
>>
>> As I see it, the vcpu->arch.guest_fpu structure is already exposed to
>> KVM. This series doesn’t modify those structures (fpu_guest and
>> fpstate), other than removing a dead field (patch 2).
>>
>> Both ->usersize and ->user_xfeatures fields are already exposed --
>> currently KVM just doesn’t reference them at all.
>>
>> All the changes introduced here are transparent to KVM. Organizing the
>> initial values and wiring up guest_perm and fpstate are entirely
>> internal to the x86 core, no?
> 
> This patch adds struct vcpu_fpu_config, with new fields user_size,
> user_features. Then those fields are used to configure the guest FPU, where
> today it just uses fpu_user_cfg.default_features, etc.
> 
> KVM doesn't refer to any of those fields specifically, but since they are used
> to configure struct fpu_guest they become part of KVM's uABI.

Today, fpu_alloc_guest_fpstate() -> __fpstate_reset() sets
vcpu->arch.guest_fpu.fpstate->user_xfeatures using 
fpu_user_cfg.default_features.

Are you really saying that switching this to 
guest_default_cfg.user_features would constitute a uABI change? Do you 
consider fpu_user_cfg.default_features to be part of the uABI or 
anything else?


