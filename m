Return-Path: <kvm+bounces-61125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 152A0C0B8E9
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 01:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EF3404E87AE
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 00:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F400230EF71;
	Mon, 27 Oct 2025 00:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QLJDAtaB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A5B1E503D;
	Mon, 27 Oct 2025 00:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761526248; cv=fail; b=OQIpqQs3W9THCTYARQeKgTDLrR9H9KJG60lGRe4CtpndZWj55pF0gzaLOvRs9WKZ0r3qqH9cxFGCNF+jPW4szGAmAMSSbEyKbOKodFeELTAN0VHyz2i3qeAhQ3mh92Q3vf8xhcl2p4zbs/cRjGRNqATmfXt1fDtnpY88SkjE+18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761526248; c=relaxed/simple;
	bh=V66afb0h2pYARMv/j3cmq0TnfGJYNLdxsOdaP01ztzo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T2wnC16m07YiWetB1A0oUGtd7z/SGuhKq50/W2UAawI8Ksn2nMDeN7BVZfd9wPKGA9/Jck4WdxIM6fP0wctrsM6KtvdTlR/lj6FSarlEEzCR07RpQ8riQhoHNc4S9hOukulWGzDqUjH1g7dJSOsBZBc3lnTk7/nQ0KN77P3RV/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QLJDAtaB; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761526246; x=1793062246;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V66afb0h2pYARMv/j3cmq0TnfGJYNLdxsOdaP01ztzo=;
  b=QLJDAtaBHu/fGvdl8ZzqwHA03JR8eAIlYZ3BB+nrtpDHNbpUkJRr91Bk
   dCGwQvgg0dH1VXkOrUTLaIjQiDDjiaFNJ+hq6tSPt4ksTipFMFsMIGbNB
   s62PCF11EmlNzglGJt+LdKKo8E6J5ImbVSEo9zjyNTJLpLtpgX2JreACs
   IXfu1Fb/gnv9MQJnmULZs/b+ShGGgP51zAbsBiyThDONlYo6RM/couLwj
   1k+SR9hUvX1ydcrCOcOToUx6/9o30fhqGK1OvvjzKGcufUHNnD+t/DzQZ
   m1NWRwhCXYpvMi1fqZCO9ssnJC12cdBhITWib+Gm3enZd252o6o8hdCuH
   Q==;
X-CSE-ConnectionGUID: 6tNXem3QQ/Gfk59MVNO9BQ==
X-CSE-MsgGUID: /j3s161WR6Su25+5bmeLfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74723792"
X-IronPort-AV: E=Sophos;i="6.19,257,1754982000"; 
   d="scan'208";a="74723792"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 17:50:46 -0700
X-CSE-ConnectionGUID: 3ghLP5SNStuduMSXK0eSvg==
X-CSE-MsgGUID: TE8tfllrSbSGSdp0Qf0vLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,257,1754982000"; 
   d="scan'208";a="184090552"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 17:50:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 26 Oct 2025 17:50:45 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 26 Oct 2025 17:50:45 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.3) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 26 Oct 2025 17:50:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=unNV5JqQ4Avvf5+r8J5m3m/UALrXi3o3RH1q1QaZqeM4fnFLr0DWMy9xMQ+7ADdfkIjaRUH4IsE1CCUhTWTMvdGQKAOQMm5xVtnLwutaSLb7UyCmpdzdXHXLdj9g7src6NQ4+zRRUK49lw8apBsebYVgS/fFG4Kdqq87I/dt0JqG/oYB+X/kW8TIqz/FJ9TGQajCUc8nvdjF6DjhSDEa0I84icUT+tKLTAs60Omg9J/C64B8k1NQKv7urBLYzy1jWB2hcSlEFurSL3khmnkDeMLNJJfUUAheULw5HrIGIEIqmsWl3RrJDSra/R/vzyKE88ed9nV9LDbIEgmuyEWDvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V66afb0h2pYARMv/j3cmq0TnfGJYNLdxsOdaP01ztzo=;
 b=O04au8M8gzOQhTQQ56b/YywP/8GPgfnxs1JJxXtv/76OfShTAvanIhgOBnyylZaez9ZF9XzNBbrGG3EhjxUKtAjEvt7R8DBsY1AsMVTzQOH4/YjJqG/o55IsvfSgpFdHF3AZE1amKCPj57wbSVl2qOnxyVR8H5FTt2lcr6gM5luUbXhKiLzXZtv9JH9hSz4a3xWpSonsPnWBd4NGisgse2CXt1Owa4sDJLWfhlLrhkuUEMEBjIea+IdlKuBKW4FSnpOPTDrcUFX7F2REWr5KK5Kmb+8//rjBMJpVLadXzERGduyyD2XrdT/ROzfFKb5sIpFvzgOCtnaMGT/6Aq3Vjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA0PR11MB4637.namprd11.prod.outlook.com (2603:10b6:806:97::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 00:50:42 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 00:50:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "seanjc@google.com" <seanjc@google.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Topic: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Index: AQHcG1rj8xzFenegOUSY8voF4LzMlLTVayCAgAAVl4A=
Date: Mon, 27 Oct 2025 00:50:42 +0000
Message-ID: <811dc6c51bb4dfdc19d434f535f8b75d43fde213.camel@intel.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
	 <20250901160930.1785244-5-pbonzini@redhat.com>
	 <CAGtprH-63eMtsU6TMeYrR8bi=-83sve=ObgdVzSv0htGf-kX+A@mail.gmail.com>
In-Reply-To: <CAGtprH-63eMtsU6TMeYrR8bi=-83sve=ObgdVzSv0htGf-kX+A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA0PR11MB4637:EE_
x-ms-office365-filtering-correlation-id: 9c97bf80-508d-49ef-7b58-08de14f2db18
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VEJ2ZnByUVlGZmQybXdSazdlWGluZFBWVjUzQUpLV3BLaGpHVGs5eEgrNXRE?=
 =?utf-8?B?cjlhMTFPZzRVeE9ZbWNRYTVwOGt3N2pCUUlpdVN1MXQvNjUxOC9lZENrbUk3?=
 =?utf-8?B?MFYxY3llU2duOGR1SjczVk03MDNhS1V2OGlNUThkcVgyWUEvVmduRjhwNEx1?=
 =?utf-8?B?TlVRcWJnU2FjSkZRQUtkNzZMeHhSbXJRU2w5bWFHSXcrakNBSElSSldpUGI1?=
 =?utf-8?B?T0tqdXFjdXZsanYxbmhqLy9GS3ozZnJsRitwOFhRT1B0ZEJWL2d1WW9pRXdn?=
 =?utf-8?B?ZDdkV3QwRGQxV0dKaitadXpVUUcvS2JkSUdjdUpMeVhETWJjZjRrQi83blRJ?=
 =?utf-8?B?UmhyK283ZmxqZlZxTUxPc0lJdTQrd3Y3ZWFzRGgxUFBaTmV2ek5kVVRXVlI3?=
 =?utf-8?B?MDNDL3Jpd2VNQlZia3F6aDIzMWJFaFRsMFpaZVhLU3ErSzFibit2ajZtS0NS?=
 =?utf-8?B?cGdKNE4vVTlwSkExY2dRM0F3SUpiR1pKa1FDbUZ0bGpJeWFlUEtoY0NmUFV3?=
 =?utf-8?B?SDBmdEJKazdqTDM4bDFGd0pvWDdXeWp3LzhBL0QzVUN4aVpxd3ErY2wyMDY0?=
 =?utf-8?B?R1ZsczlpTDhhRVJvNzlnWThlSFc1dkRvV0pqR0NjakwrR3J5SGVRQjg4RVRj?=
 =?utf-8?B?Q21qalZUWlE5djlJQStzNWtQTGdjZi9lOEdEWEJIUDh5VkpmRkVIUTRrOU1Q?=
 =?utf-8?B?QVh3aHMxTE54aWhqeE90V1Byb3ZpemVaNnozWXZpbERqdmlmYUF3aUhyQ2h4?=
 =?utf-8?B?QjVRNXhvK3hKbzdtUk16cDdha0RGamRjU2dFellsVUIxLyt2NDIzYUdwSTVx?=
 =?utf-8?B?SGJmMkxPa1NyRUN2Mm1ZUGtWcXBVRXZjL1Q5ZCt3aFNKVlcrbHZqSElyRXhz?=
 =?utf-8?B?S2E4bjM1L0doWElwbFFOckZhY0F0WFUzWENkd2o0ZEVYQjluZXgvUFU0dUQx?=
 =?utf-8?B?bXdWSnZsTGQrVzB2OFlraE1vSTFLTTZZV24zUUFZa3Z3SzVGTWprb25XbmVO?=
 =?utf-8?B?VGlkZVZHM3NNK0U2MlI4K3FKL0pyL2VWZEJON05vckVPb2drQ1lnZWJrY0pY?=
 =?utf-8?B?b0tYbDdwK1FkcjdxV1h5RHFLV2JydmFOR3hDNFRnUGNKRmZzUzFPRlVCRldk?=
 =?utf-8?B?MUxIV0NocVRVK2hjRFZjMkdXbk9adHlOOTM3cEZETlJsL0FjcXoxMjFOTHR1?=
 =?utf-8?B?cDJHYWd0eXlNRmlZRUdRRDkrek1FU0JQTStPbVlHeUtkVnFNVWx6bGdKekMv?=
 =?utf-8?B?VUl2MGczQ0M0UXZSK2dwbWdrMjBjU3lGMGVWZ1RsNklFTGVsTU9hdGxGYWFV?=
 =?utf-8?B?bmJnZWI0OUVVVFloWklKR0o3Yk5mUExGM0Q1ZzEvT051Nml1bXhUOS9GZ0tL?=
 =?utf-8?B?eUtZL21PcFlGaU5LdU5oR3c1WWtieVl6WTVxcUg5alI2RTZhZ3J1OGJyQjlm?=
 =?utf-8?B?M1M5RkEwMjBvclk5T1pGNXd2dGdaNXlwSEd3c2x0SEdUdEFGQzczcnczYUw0?=
 =?utf-8?B?S2xnWUMyNlJzMzZyZHEycVBoem5neTJ3akVrOUdNKzE4dVRGOGtmNXZWOXNq?=
 =?utf-8?B?T0tQUVpVQU12OEJYRjJiS1JENEtIcDA0NHpLUE42NjFSUDI1S0hwOFp0eDJT?=
 =?utf-8?B?c1Rxd3FmKzhiYjVzNlJ1M0V3K25HS1pvVFR0aEd4T1dGZkJxUUtjNHZiZEZJ?=
 =?utf-8?B?T2Nndk9mZlJpc1ZNR3h3cHp2V2FsVG9UREpqWlZyTFhzekFJOEVxQmRSTmxM?=
 =?utf-8?B?RG1TWE0wbUJhZGRDczVwYU1RbjR5S0Nqb3FMOVBaNkRFb2ZBN0NqeG93b3FW?=
 =?utf-8?B?WSs2aDFPOWpzYlZFRWdEdDRKV05WZ2x5ZDc4eXpYSW5oaExkdDFiMEllZWRh?=
 =?utf-8?B?VGtTMzJDKzE3WjZuRU9ad2lPV2ZoalNKWjlqS3R6dVpMNHhZVmJDM3pFbHdH?=
 =?utf-8?B?YnY4N1M0bG16MCs0ZFc4cUpZQXo0M3N0MlFVY2R5K2s2aGtlVGpKK3dXVzBO?=
 =?utf-8?B?NzdXcnhIckZKc3Q0MFRIRzUxWWlYOW1sUTR6bmVlWCtod2RNcTlXazNKMXBu?=
 =?utf-8?Q?j/5obD?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXpnZDBQOFM0bWlxWTVTMU1mYSs3UUV1N3ltSVZBV1E3Nm0vYmlydThEOCty?=
 =?utf-8?B?WitPTUpmZThkWG83OW05NmhKcnZmTldMRHpIaXluWmMvYUhCNmFleGNGSmVv?=
 =?utf-8?B?dWw1eExRL2tML0Q2bEtadUZMNXhlS1dWRXpkTVNRWVBmU1FxRmVDSHorbW9O?=
 =?utf-8?B?ajZPM3phVEhrK0dRRkNoUDNCTmVjdFRSaklhcHpLYWRiY3RSdUFKNkdXKzRv?=
 =?utf-8?B?ZXMvM05HSHM3OCtNektOVEpiRC9OSDR0V0hlbmhsQU9Td2wwdThwRllNYU9w?=
 =?utf-8?B?aFR6ZmxvVWRIM1REcG01dmFubUYrK05DS2k4aVFjRGM2Y2ZPNktMR2FxNndq?=
 =?utf-8?B?cTFxdmd5K2hyU0g4UUptVWdwUkdLT2lydG8wWEN3ZExHSkNDb2hZemFiSElI?=
 =?utf-8?B?cXFZajdzTDRHUHlpeC9mN0FKZHRpUGNodHFPNXJoNlAyWS95M3BHTFJkWDN1?=
 =?utf-8?B?YnJvbFZJUHZQRGFzTGMyNmxKYVovLzhEcWJTSTA1S3ZsTWt2bEhJU21uVktv?=
 =?utf-8?B?cmVYcFZEVVBsejJlTjEvaTJhS1ZxaFZzUERMM0RnelhZb2lqdzc3TXBqV2lH?=
 =?utf-8?B?OGFsVWRRN3d4UU5tNE5uQUJQd1pzZENuOHNYclhYK2FiNS9MUk5hS2psa2p5?=
 =?utf-8?B?TkxDd1RENzdtcTd2OFoxSk1ydjhPbEQ2NWZPU1MzZ1Z4b29Dc2RlRnhtQ01a?=
 =?utf-8?B?a0R5WmlKSmlGZDJFWjZZemdLd3pmcDVseWFvUy9mb2JmTDlNZDlybEd4emwx?=
 =?utf-8?B?dG5FUUkwaFlnWlVFMUZjT3QxUDk0aytjZWVEbUMvUXdHaWE1QmtSZDc5SmY2?=
 =?utf-8?B?MkZiUTl5NnNXVlVQVlY5VVExQkJOUU5uTi9pa1B5ZTRBV1NnZ0hNcDNONWFy?=
 =?utf-8?B?SXcwSmM2TklqNlRJMU5LbjhRRTBSNnNkZGtzTkMvZzcyVWVxL2lCeFVrSlFF?=
 =?utf-8?B?U1l1Wkp0OHFZbk81RGIwRTBjdW9aTEY4Vk1ZZHpGdjRsVExWbk95U3kvV05W?=
 =?utf-8?B?QzdYTUVaZ3FsS2h4RlptdTNJRS9Oby9jemJtdnk0a1ZQbzJvbWtmQnBhSXNt?=
 =?utf-8?B?azh2d2gwa0ZGV0RsaWptTU5wTllnNTdqc25rajlBN0Z5ZjluSCtoUGJNekxU?=
 =?utf-8?B?WXBicWhBR2ZHRFBCMTFHMlFHSTlkRmtlYUhEYlh4WU9QVURiQ1daV2Z1SVJn?=
 =?utf-8?B?YkhVTXcya3ZpdVFGcy9tVERERm43RCs5RFBzSkRSMGdXV3lMeWRxNkFYU0x6?=
 =?utf-8?B?Nk4wMUxkN1pURGFrb21sTTlzNS94c1FMN2FacEVTNVpJWnF5M0hWMEdwdW5r?=
 =?utf-8?B?aWVzdXBoUVducDY0L3EzUmFJMnlhd0V2cUwrd2I2ZWMwRFZnTEUyb2hFVjdn?=
 =?utf-8?B?TmhVUEQ0ZEt1Zi9kdmlFaUdtUFJjdUU0SzQzVldVbGhxeWxLUjFRVDBxRjBh?=
 =?utf-8?B?Znk5eXdUbUI2WWd2QnZ3azJiWW1TK3VvK3kwRjJ3WHcwQm9jSGYxNXB5Wlcx?=
 =?utf-8?B?QWNxT1hjTWVoS2NWbUJ2UVFncm9yLzJGQXJ1ZFJyc1l6bTRzQi8wMVlzTmlo?=
 =?utf-8?B?ZWNBenRUdGo0Qm00YW0zZXlyamlNT2JkZDlyQWJZZC9vVGdRcHNBMGlWbjNQ?=
 =?utf-8?B?blB4WE0rSlBSMm5CcU91cVI2MnVKRVJoUC9pVnRtUE1TNDkxTkFVekpuTnRB?=
 =?utf-8?B?SG4vSUwvM25rMi93SnNLVzZkMy81V0srS0pYZjY3elhIWHJteHVXMXZtdjAw?=
 =?utf-8?B?bUtOckxLYTEyeXhvU1VCdzkzTVZ2UktoVmdTT3BpUlZOQytnSnVRTjByZTZo?=
 =?utf-8?B?TVY3Rmx1NUtUdVJwMStkcm5Ed0lxRmswbDRxdnYwNTQrS3NGNzJUa1FLVDVx?=
 =?utf-8?B?NnFsT0dsWHptSmVnU2g4WXorRFhYbVZHL0tlb1FtVExxKzRKSmJ0RmVZT0Ir?=
 =?utf-8?B?ZHZ1RUJSSTBFQzVqSG1RcXV0cHJSMDVhY09LRTNuMTdSeW1pY1ZzOGpnVEVF?=
 =?utf-8?B?ZU9UblZJM3dEOGhXbDFVQTJIR1V1UjFnaHJVR3d0WTlNYkRKUVhUL3Y4SXcz?=
 =?utf-8?B?S2U0NTMvNVhzNnZlTHdWMWd0YkhwWTJ3KzlpSHFzbEIvLzdDeUZuSTZGcFlq?=
 =?utf-8?Q?uKZ41jJdlr+IJVtgiTQx+YK2C?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B16B3CC012833478471AA586AB9F98C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c97bf80-508d-49ef-7b58-08de14f2db18
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2025 00:50:42.3486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nvb+rpeZfxGWK5GSaOKq0SuOPM0O1BsMKIVL2GqUtWDtz2sG+NsUQWrOg2bbnMe9chngqgNprxBu1jywM0xung==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4637
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI1LTEwLTI2IGF0IDE2OjMzIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiA+IEl0J3MgZmVhc2libGUgdG8gZnVydGhlciByZWxheCB0aGlzIGxpbWl0YXRpb24sIGku
ZS4sIG9ubHkgZmFpbCBrZXhlYw0KPiA+IHdoZW4gVERYIGlzIGFjdHVhbGx5IGVuYWJsZWQgYnkg
dGhlIGtlcm5lbC7CoCBCdXQgdGhpcyBpcyBzdGlsbCBhIGhhbGYNCj4gPiBtZWFzdXJlIGNvbXBh
cmVkIHRvIHJlc2V0dGluZyBURFggcHJpdmF0ZSBtZW1vcnkgc28ganVzdCBkbyB0aGUgc2ltcGxl
c3QNCj4gPiB0aGluZyBmb3Igbm93Lg0KPiANCj4gSGkgS2FpLA0KDQpIaSBWaXNoYWwsDQoNCj4g
DQo+IElJVUMsIGtlcm5lbCBkb2Vzbid0IGRvbmF0ZSBhbnkgb2YgaXQncyBhdmFpbGFibGUgbWVt
b3J5IHRvIFREWCBtb2R1bGUNCj4gaWYgVERYIGlzIG5vdCBhY3R1YWxseSBlbmFibGVkIChpLmUu
IGlmICJrdm0uaW50ZWwudGR4PXkiIGtlcm5lbA0KPiBjb21tYW5kIGxpbmUgcGFyYW1ldGVyIGlz
IG1pc3NpbmcpLg0KDQpSaWdodCAoZm9yIG5vdyBLVk0gaXMgdGhlIG9ubHkgaW4ta2VybmVsIFRE
WCB1c2VyKS4NCg0KPiANCj4gV2h5IGlzIGl0IHVuc2FmZSB0byBhbGxvdyBrZXhlYy9rZHVtcCBp
ZiAia3ZtLmludGVsLnRkeD15IiBpcyBub3QNCj4gc3VwcGxpZWQgdG8gdGhlIGtlcm5lbD8NCg0K
SXQgY2FuIGJlIHJlbGF4ZWQuICBQbGVhc2Ugc2VlIHRoZSBhYm92ZSBxdW90ZWQgdGV4dCBmcm9t
IHRoZSBjaGFuZ2Vsb2c6DQoNCiA+IEl0J3MgZmVhc2libGUgdG8gZnVydGhlciByZWxheCB0aGlz
IGxpbWl0YXRpb24sIGkuZS4sIG9ubHkgZmFpbCBrZXhlYw0KID4gd2hlbiBURFggaXMgYWN0dWFs
bHkgZW5hYmxlZCBieSB0aGUga2VybmVsLiAgQnV0IHRoaXMgaXMgc3RpbGwgYSBoYWxmDQogPiBt
ZWFzdXJlIGNvbXBhcmVkIHRvIHJlc2V0dGluZyBURFggcHJpdmF0ZSBtZW1vcnkgc28ganVzdCBk
byB0aGUgc2ltcGxlc3QNCiA+IHRoaW5nIGZvciBub3cuDQo=

