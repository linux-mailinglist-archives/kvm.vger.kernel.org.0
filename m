Return-Path: <kvm+bounces-32941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC57B9E2B88
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 19:59:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A89FB37B9C
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 17:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D101FBC9E;
	Tue,  3 Dec 2024 17:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LCMwn75g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8471FAC49;
	Tue,  3 Dec 2024 17:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733247297; cv=fail; b=hdHQhtPboO4iKwFOX6I0jmCZhLrASNqLVRz7C4GB+HzuM/DBpG+bbRgRT6F4COkztB7XLHar027ZQKFSbT80GIqsglce/KjAuBsEjFYQcVPhk6f8vn/t88nm7JGd6dfsSZyUEEiO6r5v/nP7BStwtA9TYIfZFmHcZfnuYP1UDaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733247297; c=relaxed/simple;
	bh=8j21T/BY0bEEfLzS7v8J/ik2XqmZb4Tf9GKthu47Sus=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lns8KvPdT+qLQpVaZdB/kavgsPm6ADrFU9eS9DIIQc7vBAuGtA5LOZUT4QRxc7XBH4zhjyne7E4/iWlMPJPKQ8LByo4oa5eEsAFIn8YFesSYONPC0m74g3eyJElWfrefH0RPUL+iyeoD6o008woeW+L4gMCR813irdEU3gvxeBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LCMwn75g; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733247295; x=1764783295;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8j21T/BY0bEEfLzS7v8J/ik2XqmZb4Tf9GKthu47Sus=;
  b=LCMwn75gGJPFwcz+sPYg6oEXHpGoC+ioVH557fyJwwOo0hOgLLwBfQgd
   SNG0iMcw4eoaXCGJdMYomrFsZFtOQSBQ/CKsgcQuNCSQ/iihcgDnNMn4g
   6HNodFHR9xoWkOuORUTAsBrFrhhb77e2DjJDq44ysSuFGqVj3i++VLpwZ
   h2pCGdkQPD0jvADVSFaQ/bQq2pQcFAuoymUTrnHzNYUAaZhQz3y6jtNbt
   XBjfQROBOx55+A4srm9okLR28pFDcfPHKPUEiev2CrL45wBH8jSZOpYlP
   jxmu9rOmQmmwpxWnXm8Qp6whH76ckdrsuzvMjVGcTo8+bA32OQ5OXEBeQ
   w==;
X-CSE-ConnectionGUID: yMErnjwfSg6bhI7Xxwh4Gg==
X-CSE-MsgGUID: i+sPSiLxTq+/E402h+GLMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="33627638"
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="33627638"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 09:34:54 -0800
X-CSE-ConnectionGUID: 6icSaTs6T3W5RWP37wkBgw==
X-CSE-MsgGUID: QzlPQ3i3StyN6RUkgpWKrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="93397535"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 09:34:55 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 09:34:53 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 09:34:53 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 09:34:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpccECaRpmFIJ6hAyfWDptfyq8QKw0lWBnGO6jLXvNZgnkbzAz/1yvJet1wrli39CKJs58DsVEZnUJC9OJ2XXMEmEA31NHqL8KIcl/A3PCsrDbZXu0a5bGxY6XBGB24gAKOkL02XKJlGf7q2d1fXHAwF+EagSZpk/5kD52XOHh1NVPlv4OSzhnYUMK56hL7zzG93WleCcNTWI6ldmqtOR7ou6ps57dBA+yJlBsXeQaeSyCh3jj9ByzsXPIjj8Vr9ADwGm6u+qDlZy9XZmo/90khBY65I40Leo1Q55ZEtd0ilMZ2IkQedLjA3Gt5PQFIWRGroaBCo2eZ+BsaetdZMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8j21T/BY0bEEfLzS7v8J/ik2XqmZb4Tf9GKthu47Sus=;
 b=eY7/RS4/+wNQ0S2h0tzEXbYV3JUZlzvKZNKoZ2gYaRgAamooLmoeqo0yKoARaJ7YuAecqLPpZDQDFYsOM5JqtPy0izSmfrbnkRN7qEkBtUXKfflj0fENMoknS8i+acr6czEtfmPyLx8E5S4NPg7iOfV6Bp7gc+RCohvRFhQm1oHhczi9EG+suXGl8iVhhdNthnnQXBVNLYD996PsU6/fOSQAuyzpN1/UcY0WVTa54fDClwRm0ANbSzf9dYVD8TrnwNudRfUDb2vfp2j1Ok4j8yBmtKEloNGXk0vi+FSqrEnzbEc8tM+U++TBrFp0i1Ov7pcSVBoKC/Pkx5q2V0qNEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6551.namprd11.prod.outlook.com (2603:10b6:8:b9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Tue, 3 Dec
 2024 17:34:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 17:34:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yang,
 Weijiang" <weijiang.yang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, "Gao,
 Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Thread-Topic: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Thread-Index: AQHbPFI1CpXUe0dtwEa1D+tl1lrdQLLCpF0AgAiMhYCAAv0xgIAFNDOAgAAEoYCAAFbIgIABHPqA
Date: Tue, 3 Dec 2024 17:34:50 +0000
Message-ID: <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
	 <20241121201448.36170-8-adrian.hunter@intel.com>
	 <Zz/6NBmZIcRUFvLQ@intel.com> <Z0cmEd5ehnYT8uc-@google.com>
	 <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
	 <Z04Ffd7Lqxr4Wwua@google.com>
	 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
	 <Z05SK2OxASuznmPq@google.com>
In-Reply-To: <Z05SK2OxASuznmPq@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6551:EE_
x-ms-office365-filtering-correlation-id: 5d0a7e27-835b-4d4c-c627-08dd13c0ca89
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eFdlcHkrSGtQRWxNRnloSGVWMFVzM2dtRkpUbjJXdjUvR2QzeVR1OHY2MDBM?=
 =?utf-8?B?alA4R0NIdXhYQ1hUeUxVVyttaWRNc3JVb2RBWVZDSG0yRk9FWlBoekd2ZG5w?=
 =?utf-8?B?NmFsL1hXaWM5VStHajhxZnJlWlR0VXBaZE94MWV4SWVwTFpPdGJDZENyRURi?=
 =?utf-8?B?azhvQnBpYldUY2dyZnNXRzdBNi9TSkd4QmJrcVdqMzJnU3huL3VFSzJGbE9L?=
 =?utf-8?B?Rm9qbHJidDNaeUs5dk1pK1FYMlJ2L1gwK0FCSld4eGxsM3pldTVSbWs4T2lM?=
 =?utf-8?B?T29HT0FjUkFCdXE3L1JEekVaUTN4VzZ4amx6NkhkQlV2c3JVSWY3cjdFNXYv?=
 =?utf-8?B?YjJjdEVFanVCdUN1d3pwcHdEVHVrYWVwUEtPd0pycEZob3RWLytGSHIxbytj?=
 =?utf-8?B?RDIyaDdOUnBhKzhQSG5VUTdTbFA3aDk1M3VxZW5KcXpuY1VudGc0M1VSOHhw?=
 =?utf-8?B?VlJyYUlYVDMzUzEzRHNIcFQ4b2RCaTVVL3FET3FjbTkzci9Wb0c2RWRZYzNJ?=
 =?utf-8?B?U3Rmc05KRUZ4MmxMUGMrbHJqYnR1T1ZIKzN5QWpxMzZuUmM2VXB3a1IzelJ0?=
 =?utf-8?B?ODNNL21FYzN4b0F1NnI0cTYvQ1c4NldtL08zQ3lmY0VuQkhxOGtsaldycTRI?=
 =?utf-8?B?cTR5VFZSUDNZZEx2V1NUZzhENU40MkZGcE80Y2ZrWlRQeTRSZkplTlQ0dDdt?=
 =?utf-8?B?ZzF2U1Q0ZjVLWFQ0Z09JWVgwT2E3aVlVRHk2cXpMcW1pdk96SGpBS2FqUEt1?=
 =?utf-8?B?a2ZuSjA4ZGU5dkQ5NFQ1akJ5VzdDQUdWajVLSkdlMURCczVJRXNpS1lXMmJC?=
 =?utf-8?B?YkZiQXdhMDdNSnR1aFI2STBFcFVFM2lGdnBGQkZVbnpCS2RBNjdTeEpkajdW?=
 =?utf-8?B?RXUzVm1xQURaWVpLckZXQkZrRE5uT0Z5QnAwQ25LSitOSHhUZ0hReklNL1lG?=
 =?utf-8?B?NWJMYWV5U3JvV0d3dkc2T2hHZkY0ZUxjTlYxZVBDTHJoVG44VERMZ0ZheCtC?=
 =?utf-8?B?NFRoTVZRaGlCRmhqSkxsaTl6M3dDNUFDcEtPMDJOSUJzakFDM1ZYS0t3U1dt?=
 =?utf-8?B?NnhycjRIa3l6dDNweStNLzk4d3dwbHZKQlNHQ3prbHBQdmZKS205Q2lMdS9Y?=
 =?utf-8?B?VEUxeUZPQU1OY1R2d3ZiTS81YjhLQkx2NWVyRk5iN0xITTZ4bEcxL3R5bmVV?=
 =?utf-8?B?ZlE0R1lhRCtqaWNtNlhrR1I3N2l2S1l3ejg2MjRWV2gyVm54WERUeG1Eay8r?=
 =?utf-8?B?eE1qT1k3dk1FNnkrRkJyek1JS3N1Y0ZWZHBQeXRRcVRPaXZFVko3NnNtckF6?=
 =?utf-8?B?VXErU2ZRRk1SS0x2Q2NMMlUvd2RZcTRnSTR5dUZZRCswcFpXT1YzUllrK015?=
 =?utf-8?B?VVFCNFNTeUNOWkxDS0R2NTMzUkVmU2dnTld6U2NOdzU4bHhLUjdLSGlWbWtZ?=
 =?utf-8?B?OURXd3hzR0o0SXMza0tnMDBjN2JmZlcyd01WVkdNRzBIQ2l3R1o0ZnFjbUNE?=
 =?utf-8?B?QTJKN1grV24vS3lzY1lsbXZkd3ZSV1JMekxSL2RlN1JwRkZFWGJKVGd1aFRo?=
 =?utf-8?B?cUtRczdZMUpLbnQ2OWF4elNQdFYzV2x3OUI4WHhNaDVzYXJvYm5TVE01ME9w?=
 =?utf-8?B?Q0pTZGNZZytUYUNTblpRVlhPMkxSNDlJVlU0NXFpQnBrb215Qy9KRm0xVE1m?=
 =?utf-8?B?ZUFOdlg3L2Q3cm5HL2owWldpeDYyV2U0dVhCVk1aM3JPZzBNbkhGcC9zdUVx?=
 =?utf-8?B?ajgvV3FUMWtoeFQ2TlBod3p1NUIycU9MYlRyNEZ2Wi9iMUQ1amRkWDlZRHds?=
 =?utf-8?B?Yjd3S1BlNGRFRUd6NUVTN2NSM0MyRFVDdjludWJxQmdjWTB3K2NNcG1iSEhm?=
 =?utf-8?B?aFI3Z3hicDBneU9tdi9MKzBXVUFudTZSZEx1ZDMyNnkxTEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blhUVTRsV1ZLL1VLcVFCV2FEdVR6Mnd6QVF2VkUrSC9QUzNsejREeHM2TGhw?=
 =?utf-8?B?cFBkNVl0SFpyZ2F4MU02MVRqdTNTa1k1MzNoYTB3eXRzRXQyd0hWdkdkaUY1?=
 =?utf-8?B?T3A5NjdrQnFnamk4Tm84dFJYVEFQL2RjeTVOY05xbFBTcER3N2NjdmJoSFhv?=
 =?utf-8?B?UTBsd2ZPWWplcTBmTkJwYzBuNE9leERxdWxRTjhrMUR2RVZzc2hDK2JNT3g1?=
 =?utf-8?B?RjBUQTRib3pVZVI0Y00wRjh3R3VEN1k1cG1rdzVJaGt6SFZxVDU2ejlDZHU0?=
 =?utf-8?B?b05mK2R4bzRmNTBZNStiRVlyQ05tSWt3NjFGZmdtaHJRMGdWbXB3ZGNwakJT?=
 =?utf-8?B?dElaa2p4Um8xaVM1MXNTdjFPZlhBTVlTSTVrQ2JNWUVaSXlDaWkwZXV3VTh6?=
 =?utf-8?B?QWVyNWlFU1N0VWU5S0Z1T1lmNFVib24wQ0ZKNVJObDBhL0dQVTJlV3JET2Rl?=
 =?utf-8?B?eGdVOVdPMUI2U2FHRXNSOE5JbFpEMHZHWXlzbzhZME9Ud3NGS1lidnBoaUwy?=
 =?utf-8?B?ck5LZXhLd2l6dm9VOS9zdlI2RWhNOUVlZHdoU0l3U0xnTy9oL3JBNVBxNWFH?=
 =?utf-8?B?T2E2cElMZGFrQVM0Ump4SVZ6ejlOZVpRcEZuMVlBTUV3K0FROXFVTzM0c3dp?=
 =?utf-8?B?RWFTZkF4RzJCNklhSkJmUStsUGhSeXIvUjNmUDZIMTBqeFYxclBTcEJNZTRr?=
 =?utf-8?B?RmJUQVluTlVsSUlNR29ib3ZiMWE0UlRSYWM5R28vb1lhMlZvak0rd1lvUHh3?=
 =?utf-8?B?QTNPb0Y0elBMeE05ZVA2V1ZIbmdlSy9vQk1iTEZickZEcFY4dVRkWXJsZGxo?=
 =?utf-8?B?Z3Fkb0kyY1MwcU1GTW5oRnV0UTZ1U3pja1NZZnVtMW12RmphWTdEZWVBcDJF?=
 =?utf-8?B?eXRPaTRSRnVwWURsSVN0U045YndEb0lFM1J0ME1MNHFxZGZ4cmxTRTRINm5I?=
 =?utf-8?B?c09RaXBpTGRuSy9td0tkY3JDSng1alFqZnFWV01HbjFIS3FkSFdDR2R2V1B0?=
 =?utf-8?B?ZkxrNnk3d1dEMlJER0MxNmVZWnZTUUE0Z3lWT1dRdHNZc1Z0ekdCbVowdGhI?=
 =?utf-8?B?WFFBb3NUaVdnSmpodXlFdFduRzhYeGk4eXF5L0RXK3BnVysvM0NveUlscGhQ?=
 =?utf-8?B?dzRyaklMSWk3TUI0U1o2cE9EcHlhR01iL0xRdU9SU005cjFHaGZGL3BRT3ky?=
 =?utf-8?B?NGszMVVFbFV6Rml0TG90eGlrUFlqL2wwUFo0c0VIaVN3ZGh5eVlKNlMzUFVQ?=
 =?utf-8?B?NU40UndpampFRVZIcWFST1hCMmZ3REVtWWRMMGJraGdjTjJZZ05ZdmY4cmxE?=
 =?utf-8?B?ZDdBVFFzWnVJcHJock1MMVQ0Y3VJdkpDTGRuV2J1T2dubE1hazRpWjFrRGVJ?=
 =?utf-8?B?d2F6cTVzQzk5M3lLS3ZIVDd0Y3RtSWZtbFZxSE40eHBRSkZqTW1aN0VFYmN4?=
 =?utf-8?B?TkJSelRtU214Nk1SL0JIUnRFRWIzY0hSM2VIUTJ0MmlFRCtXMDlWTTA1b2Ir?=
 =?utf-8?B?TDhmbmtJeTQyTlRYK25Lc2Fkclg5c1pNVXltMTkxUmt5WTI3L2svT0NxVG1C?=
 =?utf-8?B?QnRWZStCNTc1ejFUOG5aR09iaGdlMDMrOEpvODIrcHBXdkJLV1lOcHZzRCs2?=
 =?utf-8?B?UC9vZ3JVZHo5T0t2aWxreHpPSC9ycnpoNjJVMEVQNldDdXhFQ0t4Z2dicXFJ?=
 =?utf-8?B?NGlQVm94UkwrRlhtd2I5U04wOFluYmdRdnUvSUN4TnNiS0Yyc253SW5nTm9o?=
 =?utf-8?B?d3ZKSzNvZ3BVTTJlVG5CdEJldjhqNEN2TjhMNXhKMVd3K2pVaURKVUtJcXN4?=
 =?utf-8?B?LzN3SXl4eUM5VldGbDVrbEZubnhaeWRZNEl0L3RhZ1F6S1o3a0ZITkcrR2d6?=
 =?utf-8?B?WVJUQWhMa2ZlOVJyejBHempWMjhSdGxjcnRwb20zaXM5dDQ1SjBwTEI1QVdM?=
 =?utf-8?B?V2JqU0dlajFKcVhxTzZTK2ZucFR2S2poRmx3SmZlQW5aYllKeXI0czVDWHlF?=
 =?utf-8?B?TEgwMlpFc0tCV0RCM2lmQ0xIOTNRZGNtNFN4RGFRVWFrdnF5L1YrRU1jTTZN?=
 =?utf-8?B?U3ZNdEYyUGFVbEJmWDl2N0xPVjBwNXBNV1ROOWh0WVNSZjY3QTArRWdEcTlH?=
 =?utf-8?B?TVllRmFqNlh0ZVROcWNScWFRN1ZVcWg0aktmYlVRMVR4Vm5LbmZvY0h0bEhI?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EC068E9AEB82A4BAC0F63B3F6E75CED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0a7e27-835b-4d4c-c627-08dd13c0ca89
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2024 17:34:50.8703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ooGSWsb8f8UcDzzTxH2ojrZlB7zHiAIDYy28UGbeLYiPnoy22XlyaIjbHOlLUdwCVet6eCX5ESqJQb99aAH+yduuA3Pi9vWPjqajd5lVfiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6551
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTEyLTAyIGF0IDE2OjM0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFNtYWxsIHBvaW50IC0gdGhlIGxhc3QgY29udmVyc2F0aW9uWzBdIHdlIGhhZCBv
biB0aGlzIHdhcyB0byBsZXQgKnVzZXJzcGFjZSoNCj4gPiBlbnN1cmUgY29uc2lzdGVuY3kgYmV0
d2VlbiBLVk0ncyBDUFVJRCAoaS5lLiBLVk1fU0VUX0NQVUlEMikgYW5kIHRoZSBURFgNCj4gPiBN
b2R1bGUncyB2aWV3Lg0KPiANCj4gSSdtIGFsbCBmb3IgdGhhdCwgcmlnaHQgdXAgdW50aWwgS1ZN
IG5lZWRzIHRvIHByb3RlY3QgaXRzZWxmIGFnYWluIHVzZXJzcGFjZQ0KPiBhbmQNCj4gZmxhd2Vk
IFREWCBhcmNoaXRlY3R1cmUuwqAgQSByZWxldmFudCBjb21tZW50IEkgbWFkZSBpbiB0aGF0IHRo
cmVhZDoNCj4gDQo+IMKgOiBJZiB0aGUgdXBncmFkZSBicmVha3MgYSBzZXR1cCBiZWNhdXNlIGl0
IGNvbmZ1c2VzIF9LVk1fLCB0aGVuIEknbGwgY2FyZQ0KPiANCj4gQXMgaXQgYXBwbGllcyBoZXJl
LCBsZXR0aW5nIHZDUFUgQ1BVSUQgYW5kIGFjdHVhbCBndWVzdCBmdW5jdGlvbmFsaXR5IGRpdmVy
Z2UNCj4gZm9yDQo+IGZlYXR1cmVzIHRoYXQgS1ZNIGNhcmVzIGFib3V0IF93aWxsXyBjYXVzZSBw
cm9ibGVtcy4NCg0KUmlnaHQsIGp1c3Qgd2FudGVkIHRvIG1ha2Ugc3VyZSB3ZSBkb24ndCBuZWVk
IHRvIHJlLW9wZW4gdGhlIG1ham9yIGRlc2lnbi4NCg0KPiANCj4gVGhpcyB3aWxsIGJlIGxlc3Mg
dWdseSB0byBoYW5kbGUgb25jZSBrdm1fdmNwdV9hcmNoLmNwdV9jYXBzIGlzIGEgdGhpbmcuwqAg
S1ZNDQo+IGNhbiBzaW1wbHkgZm9yY2Ugc2V0L2NsZWFyIGJpdHMgdG8gbWF0Y2ggdGhlIGFjdHVh
bCBndWVzdCBmdW5jdGlvbmFsaXR5IHRoYXQncw0KPiBoYXJkY29kZWQgYnkgdGhlIFREWCBNb2R1
bGUgb3IgZGVmaW5lZCBieSBURFBBUkFNUy4NCj4gDQo+ID4gU28gdGhlIGNvbmZpZ3VyYXRpb24g
Z29lczoNCj4gPiAxLiBVc2Vyc3BhY2UgY29uZmlndXJlcyBwZXItVk0gQ1BVIGZlYXR1cmVzDQo+
ID4gMi4gVXNlcnNwYWNlIGdldHMgVERYIE1vZHVsZSdzIGZpbmFsIHBlci12Q1BVIHZlcnNpb24g
b2YgQ1BVSUQgY29uZmlndXJhdGlvbg0KPiA+IHZpYQ0KPiA+IEtWTSBBUEkNCj4gPiAzLiBVc2Vy
c3BhY2UgY2FsbHMgS1ZNX1NFVF9DUFVJRDIgd2l0aCB0aGUgbWVyZ2Ugb2YgVERYIE1vZHVsZSdz
IHZlcnNpb24sDQo+ID4gYW5kDQo+ID4gdXNlcnNwYWNlJ3MgZGVzaXJlZCB2YWx1ZXMgZm9yIEtW
TSAib3duZWQiIENQVUlEIGxlYWRzIChwdiBmZWF0dXJlcywgZXRjKQ0KPiA+IA0KPiA+IEJ1dCBL
Vk0ncyBrbm93bGVkZ2Ugb2YgQ1BVSUQgYml0cyBzdGlsbCByZW1haW5zIHBlci12Y3B1IGZvciBU
RFggaW4gYW55DQo+ID4gY2FzZS4NCj4gPiANCj4gPiA+IA0KPiA+ID4gwqAtIERvbid0IGhhcmRj
b2RlIGZpeGVkL3JlcXVpcmVkIENQVUlEIHZhbHVlcyBpbiBLVk0sIHVzZSBhdmFpbGFibGUNCj4g
PiA+IG1ldGFkYXRhDQo+ID4gPiDCoMKgIGZyb20gVERYIE1vZHVsZSB0byByZWplY3QgImJhZCIg
Z3Vlc3QgQ1BVSUQgKG9yIGxldCB0aGUgVERYIG1vZHVsZQ0KPiA+ID4gcmVqZWN0PykuDQo+ID4g
PiDCoMKgIEkuZS4gZG9uJ3QgbGV0IGEgZ3Vlc3Qgc2lsZW50bHkgcnVuIHdpdGggYSBDUFVJRCB0
aGF0IGRpdmVyZ2VzIGZyb20NCj4gPiA+IHdoYXQNCj4gPiA+IMKgwqAgdXNlcnNwYWNlIHByb3Zp
ZGVkLg0KPiA+IA0KPiA+IFRoZSBsYXRlc3QgUUVNVSBwYXRjaGVzIGhhdmUgdGhpcyBmaXhlZCBi
aXQgZGF0YSBoYXJkY29kZWQgaW4gUUVNVS4gVGhlbiB0aGUNCj4gPiBsb25nIHRlcm0gc29sdXRp
b24gaXMgdG8gbWFrZSB0aGUgVERYIG1vZHVsZSByZXR1cm4gdGhpcyBkYXRhLiBYaWFveWFvIHdp
bGwNCj4gPiBwb3N0DQo+ID4gYSBwcm9wb3NhbCBvbiBob3cgdGhlIFREWCBtb2R1bGUgc2hvdWxk
IGV4cG9zZSB0aGlzIHNvb24uDQo+IA0KPiBQdW50aW5nIHRoZSAibWVyZ2UiIHRvIHVzZXJzcGFj
ZSBpcyBmaW5lLCBidXQgS1ZNIHN0aWxsIG5lZWRzIHRvIGVuc3VyZSBpdA0KPiBkb2Vzbid0DQo+
IGhhdmUgaG9sZXMgd2hlcmUgdXNlcnNwYWNlIGNhbiBhdHRhY2sgdGhlIGtlcm5lbCBieSBseWlu
ZyBhYm91dCB3aGF0IGZlYXR1cmVzDQo+IHRoZQ0KPiBndWVzdCBoYXMgYWNjZXNzIHRvLsKgIEFu
ZCB0aGF0IG1lYW5zIGZvcmNpbmcgYml0cyBpbiBrdm1fdmNwdV9hcmNoLmNwdV9jYXBzOw0KPiBh
bnl0aGluZyBlbHNlIGlzIGp1c3QgYXNraW5nIGZvciBwcm9ibGVtcy4NCg0KT2ssIHRoZW4gZm9y
IG5vdyBsZXQncyBqdXN0IGFkZHJlc3MgdGhlbSBvbiBhIGNhc2UtYnktY2FzZSBiYXNpcyBmb3Ig
bG9naWMgdGhhdA0KcHJvdGVjdHMgS1ZNLiBJJ2xsIGFkZCB0byBsb29rIGF0IHVzaW5nIGt2bV92
Y3B1X2FyY2guY3B1X2NhcHMgdG8gb3VyIGZ1dHVyZS0NCnRoaW5ncyB0b2RvIGxpc3QuDQoNCkkg
dGhpbmsgQWRyaWFuIGlzIGdvaW5nIHBvc3QgYSBwcm9wb3NhbCBmb3IgaG93IHRvIGhhbmRsZSB0
aGlzIGNhc2UgYmV0dGVyLg0K

