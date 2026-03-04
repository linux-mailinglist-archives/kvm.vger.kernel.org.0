Return-Path: <kvm+bounces-72754-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHZDFm25qGngwgAAu9opvQ
	(envelope-from <kvm+bounces-72754-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:59:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B05BA208D06
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:59:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A712C304C079
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 22:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2594F39D6C0;
	Wed,  4 Mar 2026 22:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lxvIOVuE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D49B396B67;
	Wed,  4 Mar 2026 22:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772665185; cv=fail; b=mTJrnKancxVjznwX5qCni19YH/7lMAoolACoz7M2iMXI+90lF6Rx8D4iO7GtkLLDaRjjizS4bLM9WjIUfc7MvIYFIF8LkcmKi0MdMYM2oq5BhZMMV3ewAhN5lU0xC/XAcdmFbtvZkk86DYt17XbunoHVq6YzmGgkK/x05/bpTq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772665185; c=relaxed/simple;
	bh=cNVkzkmXTbj0ORpxC6jYjcb/+HDdB4NPM+6GnKjRCf0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MivHnBtY44XMjbXkRJmxG1WBM8gLARdZUfkysv+E2t4mhUbbRsyT3alL7gjnaN8jkbUYYB51T0d23o2Xjubu/irmx+HCa6WB3vuZ/m8mtF2zNC//Y7XZFU0u5qs1/l9DN0pTne1dlIADqpi6p1g6THqpbww1/nPmjk393CnKfHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lxvIOVuE; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772665183; x=1804201183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cNVkzkmXTbj0ORpxC6jYjcb/+HDdB4NPM+6GnKjRCf0=;
  b=lxvIOVuEYrfXsgEng6CvXFX4OGcRSg9qC1b5A8zFc80y8LiX+PZIfVZu
   1qbTENlakcFe5NzxAaQHLHaVjHrOEQgelSY4xGIQtFjrTnv3cjrgjTZoi
   7uWWrkSgBMYD7iZuxkedxumzq+IUKjn3NawoZJqUnTbmoDyecP2pc/LZr
   pyL1I7BEEqh5pmMPQee7E32gXQNTatbHp0R7qiee3KerN37PQZhMDboO4
   u9pptNbC5jLCavI0WPtnwd7TTlGb+LSsKYWSDEgZYU16bu3yYNyGWSvIi
   vccXhx3X38hDQTLyBE8cK10YdQUSqZWl/+uhJd/kpCTWT/gsSnLTH/ecT
   Q==;
X-CSE-ConnectionGUID: H2Mu+xRmRLiWYjdZW+eeqg==
X-CSE-MsgGUID: h+WATjHvS/a3OZRuXm51Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="84075294"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="84075294"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 14:59:43 -0800
X-CSE-ConnectionGUID: fYH2K7b9TBOqqN7YsUUjaA==
X-CSE-MsgGUID: JYUF70gJT02b2bcvrrT1BA==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 14:59:42 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 14:59:41 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 14:59:40 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.8) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 14:59:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJBzQzqy/PsIZ7crcFkjjYbQpf4suh2p1rArCit0Xvx/p32BJv3q8+kPHNbBeMirGxpnUf7GuJCPpf5XtLpElsN4oh+CPH/bQ7hCwOm1vSNBgAjlKfr03HAiNf09J0G53JEAWFwoC2INL//OzTEFA5i6jlE8NxM4XCOsjl/63m3YpZ0j8wUhYiLD5UBZEW4OT3x81ncXPbg1zcPtvsYZHadcur/ewxxqhaIDjPf+EFUWVVjjUihrH3fCRi4aD46z58G8dGF86nPmiIZer2x70vwFpItSVaf5S/TqBk4ckRZWqphXWk0fRMK7EqtWdmX4uU+BRodQKx7yTk6wu4dykA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cNVkzkmXTbj0ORpxC6jYjcb/+HDdB4NPM+6GnKjRCf0=;
 b=ubVkNdAxMO2XZwrnns/nYQmy7X8d7+u8g99e+0hCeppJtkJxbF4mvSYyoVY8xwMwJjT5o0/1dumwoFv6C4izUuZ0Ab1Sti7bbGFSFC19gnl/FG41NdvHvTAkpSgXd6aHy+9Y2OoAopOpRNAcfD9w74IWA9okAN+BVZlPL/m5dzpGgYZjGVxVhkZH2pWYGanglmpli0SkAmp4y8xQlMxmITAP9HeHosGmbxHvW9Uz2g0ErBClhB+OVzVVHPurHGExEq2yjClMfyN5cW7gTHwUFUk6RbCgJJ1eR+ofjKU9/wfCzs8P92haL9pFZ3pHKzUwNdOZWENXcvFSu1GMdGpBwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 SJ0PR11MB4815.namprd11.prod.outlook.com (2603:10b6:a03:2dd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18; Wed, 4 Mar 2026 22:59:36 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 22:59:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 13/24] x86/virt/seamldr: Shut down the current TDX
 module
Thread-Topic: [PATCH v4 13/24] x86/virt/seamldr: Shut down the current TDX
 module
Thread-Index: AQHcnCz9iQLlGGBfwEu3rDyXbojy3rWfHLcA
Date: Wed, 4 Mar 2026 22:59:35 +0000
Message-ID: <0c86d95449543dee0369bd83740b25aae595a5d1.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-14-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-14-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|SJ0PR11MB4815:EE_
x-ms-office365-filtering-correlation-id: b7744980-81eb-4cb5-8dc6-08de7a41b4c2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: v/zeJL6kuOJJ7DRBcTHd+FhHxm99b390XKDy+YxPv8Azrgb1CGzk7cCBHUwkGPwas1P81EBgp/j7q9YO9vtKne0Y7Kwk2C/pCL72UDS649UkCkx+CkifTohRbjnamu57n0nMHhmHFcC4HXFOIo5EjSNkqjfwuTCcS1WstsGICV2JDHSsq/X3Wlcp6p8cRK+WutrCNBnJKnvtWDfOhn7vNSIjnAZOj0EUjSW7Md1mY/4vL30FR00rQVsdyMvQpEDQKhOU8/+wXTyxOUSu94wxf7Zsa3tf/8ggxJKLfBs+Kj9+EW81A3MpNowzZiVK/p93hzy02dxU+c6QKjL5NHxVJ6dEsBXmQWQpLCxsWZfavAdBFKggIT/eC1MiGB0LuM2xrFiKNLi5JVRhm2av5aI9cbaBNoX6DqeVIrx5vefMEOxz9BIFfim/bw4sJzcBxPAfjGwMEf5WSdYKGi1vTMjzPhuBY5YXJJcocGrHuvsOWPlEbtv8Zya72WRZGUh5NBACDHCJlkNNLAjElKqQMafGWjcOMZHIlX2H2Aqno61uIn5FMYRgRGwhhuZsmJMysWdvKFHZ6bRg8+pYc0J3gUdY561jfV/M7NfALOAp1JeooNipNfxo+NJOFRomwI6WSDcL3OuZHo00JjO2pkiA/NTmpLkzhVQSoBpwUUfzG0jB+OKV/MU3PO+V4kBU6nKhk9te8s3Te4jT8i3GTOn4Mew4DAD7QjlzlS2v5pK8Uon01cgzNwqWgH689ESLsPt1g1iWHfPJQxZeGYku6fGJJ/GW09ygo777kRudCU4CWv3ZUqs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHphaDRNa2xKajBRUU1naUVXcFlQV3QxcTZBYzRHR2dMWVhsU29IT0ZKbXcy?=
 =?utf-8?B?ZzRMaDVjK2dEaU9yeDByU3h5N0hvWHVkTWNlRndNSURrN2hsZ1FVYlhSaWh3?=
 =?utf-8?B?WENZT3VjWEUyOXhJRlhPelI4a3hwZkJucFJhZTB5RFUyVG12cG9aKytvOUtL?=
 =?utf-8?B?U0J3WWx1QVRVdCtXME1SeUo4UTZYMG83eTNSNzBrUmQ0bS8zS3prQnRMWjRs?=
 =?utf-8?B?MG9ocEFZZ1hDS0NIdE40WS9JSlR4bUxQWUtUNk9Dc1c1TWlKTGJlVzJxMGlB?=
 =?utf-8?B?WVNtT2tqd3FaaWVVWUlmQVZVNDhUWjhSQ1FWL3Z6RmtJMGc3T3F3dW42SjMv?=
 =?utf-8?B?a2FYUlFLM1laQmhOZyt6V1ZkMlF5MDQvdEtOTUFPSC9GckFWTGlGakxBSnRJ?=
 =?utf-8?B?a0QzbkEzbWk0SEJTMGxHeiswcFBZcjlUbytjU0lQTHByZ2wyQXRqNStNcFpq?=
 =?utf-8?B?WnNCNTlGSU5Qdk5LRTM5UGRYUzdxZGdOczQ0NitMVStvdU5uL2FINEFkdm9U?=
 =?utf-8?B?cUN6S3kvTUFxMUNwanNvUTI4ZlJOdmRMOTVhNXNDSnNpUjVULytiU0dSYjVB?=
 =?utf-8?B?SE5HU2lTRVVGWmRza0x3RVB1Z09DSjBSVkkwZXE0dkY4QVdpelNvTjhUbWp0?=
 =?utf-8?B?WXJ2MEV4azlORkZPWUFNWS9PeExzR0xLeVhGay92eGZJdWVqaWVNTjVsZXg3?=
 =?utf-8?B?N3Z4dDFEdVF4NWhIZ2hsYXZHVjNQUHhCbXNwTkJJb09PaUttcGxHL0J2THI0?=
 =?utf-8?B?V0RmeUhKaEJyK2VZNFBmaEh3QWRMTGZ3ZzZmanJZVjlwNCtkbGtjM1pJN0ti?=
 =?utf-8?B?d2VOZDU1VTZhb2lNZEZkUmFHYkpHUWl3Q1BDckdwOVZVc2RETlk0UEtPZDdV?=
 =?utf-8?B?WDgvRTJ6aGNyeUN4eFdJUTZCOVllcVpoN3lPL0FJUFpDTTZrOWViSC91QzN0?=
 =?utf-8?B?OHBsTGptZDBEcjFmVEFlTG5kQnpYN1lGTnJqK2tiblNDV0VYL21BSVNKa3F1?=
 =?utf-8?B?OFUrOE14eHB2WDdXU1pyWURaa29mVWdFbzA0SlFadWlNc0tZZk9NTkxyZEVh?=
 =?utf-8?B?c3V1UnUrY1QyaEt6cUVpSDRiaUZVUWNYazIyTGhoL0NwYy81VUo1N3hOcGtX?=
 =?utf-8?B?OXl6dTVsNFhza1ZjUXZkNXRyRCtXMFJUNkhsUkJKcWdxS3U2cnIxR0tKTU03?=
 =?utf-8?B?Rk9vMHJxS1RncXo0bERkeGVyLy81cVJzWm9tUk40UDlvVERIRHYwWXoxd1Vw?=
 =?utf-8?B?eTZSV1lEU1Q1MFBlNnR6T05oR0pKZGNxTnRrMEJ4M0YrQStPYjBsKy9VQVRG?=
 =?utf-8?B?ZE1MYi9VMC91OEVTMnpGQnAwd25uT2NQOXdkUklyY3A4eWhTN1RnK2hDMTlD?=
 =?utf-8?B?ejFBT0lqamZlbmxaVVZUM1ZwOWJvS3NkWGhQM2JlVjJMSnJ6Qk1oaTY5SEk1?=
 =?utf-8?B?ZlpZbjhXTUdvc1JyRHJMbDljRUtuWkNyd05LMDkxdHJsUUNRd2pmblBXbU9i?=
 =?utf-8?B?Z2dTQTRwSlBaQW4vbGhaZ3BmUGRnMXVUMjFodm1yZjZWczI5VFg4c0txd3NX?=
 =?utf-8?B?d0ZhUHlseDZXNXRLcElRWDB4Y3pnemtCdEFQOHNzMktFQm50TGFxRDhqUHVs?=
 =?utf-8?B?ZnhXK1J6Tm5qN0YxZGtUaEtZMEhPdlpZekFXaU5BSFM5V0wza1ZXMnlsTFli?=
 =?utf-8?B?Z09heExZN3ZkYnZnbDRSeHFma0lwZ1E4c3VpcHVneGcrQ1FPdmF0cVJBVjkx?=
 =?utf-8?B?eGhMR0xmbDlscE1qT0M5RzFtVysxM3BkV3l4cTNtSmxGVy95NUQ3cDNJZndP?=
 =?utf-8?B?N2FSdnNVaUo2c3ZNYlBBelVQOVlIMUtzdDArSTRSY3pYU05QRUdzRi9GYmo4?=
 =?utf-8?B?dk4rY3VHY0IxWlJmZGRIOEtydkFRUFRZdzJVSDRYbWtnQWRQRWVZMzNEZnRm?=
 =?utf-8?B?SEZYNGk2Q1ptUDZjZmhUZnlRbGQ0cDFOSThCcndZbUdmSDNpUmozYmJOLytF?=
 =?utf-8?B?alhSUno2U0NmdmtwZEE2Q01MZSsweGE4d3NTL0RQcTlURlVEdDFneUVUOVVG?=
 =?utf-8?B?UVArVVdqSkMwQ0hRYWFNY3dxRHJiOUdMdG03dVZWSUtIVGhxc3hDMkx6aGxF?=
 =?utf-8?B?R2VJN2FRZ05WNk0waFdvT1VMbTBhL2Q3WXJKMURVK05VRndockMreks5T1BC?=
 =?utf-8?B?YkJ4aktZMDZuOE1jRHRxelJncE5KZnJNY0J2Q3gvNUJ0Mk5zU0hhZVZvVGRD?=
 =?utf-8?B?MGZ0dWk5RDFVbWw1cHMveVp5aE9JM1JHWVdhU0JYLzVnOTRSL3FKMkNEd2JD?=
 =?utf-8?B?RUhxSmNWaDNBS1ZsZ2tVOVlBZlhsaXF5TTkyNFpvSkNvcENpOHUzQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8F93F19E2742D459AE050546DAA2F65@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7744980-81eb-4cb5-8dc6-08de7a41b4c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 22:59:35.6730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 34eXTterAsrr2C4dhVB74zCSgLCs5levLxYLWbMaXDM0MFmvyTxKrWZxGheANSmtsLaPT8hYljDl5zN3RYU5pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4815
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: B05BA208D06
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72754-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gVGhl
IGZpcnN0IHN0ZXAgb2YgVERYIE1vZHVsZSB1cGRhdGVzIGlzIHNodXR0aW5nIGRvd24gdGhlIGN1
cnJlbnQgVERYDQo+IE1vZHVsZS4gVGhpcyBzdGVwIGFsc28gcGFja3Mgc3RhdGUgaW5mb3JtYXRp
b24gdGhhdCBuZWVkcyB0byBiZQ0KPiBwcmVzZXJ2ZWQgYWNyb3NzIHVwZGF0ZXMgYXMgaGFuZG9m
ZiBkYXRhLCB3aGljaCB3aWxsIGJlIGNvbnN1bWVkIGJ5IHRoZQ0KPiB1cGRhdGVkIG1vZHVsZS4g
VGhlIGhhbmRvZmYgZGF0YSBpcyBzdG9yZWQgaW50ZXJuYWxseSBpbiB0aGUgU0VBTSByYW5nZQ0K
PiBhbmQgaXMgaGlkZGVuIGZyb20gdGhlIGtlcm5lbC4NCj4gDQo+IFRvIGVuc3VyZSBhIHN1Y2Nl
c3NmdWwgdXBkYXRlLCB0aGUgbmV3IG1vZHVsZSBtdXN0IGJlIGFibGUgdG8gY29uc3VtZQ0KPiB0
aGUgaGFuZG9mZiBkYXRhIGdlbmVyYXRlZCBieSB0aGUgb2xkIG1vZHVsZS4gU2luY2UgaGFuZG9m
ZiBkYXRhIGxheW91dA0KPiBtYXkgY2hhbmdlIGJldHdlZW4gbW9kdWxlcywgdGhlIGhhbmRvZmYg
ZGF0YSBpcyB2ZXJzaW9uZWQuIEVhY2ggbW9kdWxlDQo+IGhhcyBhIG5hdGl2ZSBoYW5kb2ZmIHZl
cnNpb24gYW5kIHByb3ZpZGVzIGJhY2t3YXJkIHN1cHBvcnQgZm9yIHNldmVyYWwNCj4gb2xkZXIg
dmVyc2lvbnMuDQo+IA0KPiBUaGUgY29tcGxldGUgaGFuZG9mZiB2ZXJzaW9uaW5nIHByb3RvY29s
IGlzIGNvbXBsZXggYXMgaXQgc3VwcG9ydHMgYm90aA0KPiBtb2R1bGUgdXBncmFkZXMgYW5kIGRv
d25ncmFkZXMuIFNlZSBkZXRhaWxzIGluIEludGVswq4gVHJ1c3QgRG9tYWluDQo+IEV4dGVuc2lv
bnMgKEludGVswq4gVERYKSBNb2R1bGUgQmFzZSBBcmNoaXRlY3R1cmUgU3BlY2lmaWNhdGlvbiwg
UmV2aXNpb24NCj4gMzQ4NTQ5LTAwNywgQ2hhcHRlciA0LjUuMyAiSGFuZG9mZiBWZXJzaW9uaW5n
Ii4NCj4gDQo+IElkZWFsbHksIHRoZSBrZXJuZWwgbmVlZHMgdG8gcmV0cmlldmUgdGhlIGhhbmRv
ZmYgdmVyc2lvbnMgc3VwcG9ydGVkIGJ5DQo+IHRoZSBjdXJyZW50IG1vZHVsZSBhbmQgdGhlIG5l
dyBtb2R1bGUgYW5kIHNlbGVjdCBhIHZlcnNpb24gc3VwcG9ydGVkIGJ5DQo+IGJvdGguIEJ1dCwg
c2luY2UgdGhlIExpbnV4IGtlcm5lbCBvbmx5IHN1cHBvcnRzIG1vZHVsZSB1cGdyYWRlcywgc2lt
cGx5DQoNCk5pdDoNCg0KQWdhaW4sICIuLiB0aGUgTGludXgga2VybmVsIG9ubHkgc3VwcG9ydHMg
bW9kdWxlIHVwZ3JhZGVzIC4uLiIgc291bmRzIGxpa2UNCmRlc2NyaWJpbmcgdGhlIGJlaGF2aW91
ciBvZiB0aGUgY3VycmVudCBrZXJuZWwsIGJ1dCBmb3Igbm93IHJ1bnRpbWUgdXBkYXRlDQppcyBu
b3Qgc3VwcG9ydGVkIHlldC4NCg0KSSB3b3VsZCBjaGFuZ2UgdG8gIiAuLiB0aGlzIGltcGxlbWVu
dGF0aW9uIGNob29zZXMgdG8gb25seSBzdXBwb3J0IG1vZHVsZQ0KdXBncmFkZXMiLg0KDQoNCj4g
cmVxdWVzdCB0aGUgY3VycmVudCBtb2R1bGUgdG8gZ2VuZXJhdGUgaGFuZG9mZiBkYXRhIHVzaW5n
IGl0cyBoaWdoZXN0DQo+IHN1cHBvcnRlZCB2ZXJzaW9uLCBleHBlY3RpbmcgdGhhdCB0aGUgbmV3
IG1vZHVsZSB3aWxsIGxpa2VseSBzdXBwb3J0IGl0Lg0KPiANCj4gTm90ZSB0aGF0IG9ubHkgb25l
IENQVSBuZWVkcyB0byBjYWxsIHRoZSBURFggTW9kdWxlJ3Mgc2h1dGRvd24gQVBJLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGludGVsLmNvbT4NCj4gUmV2aWV3ZWQt
Ynk6IFRvbnkgTGluZGdyZW4gPHRvbnkubGluZGdyZW5AbGludXguaW50ZWwuY29tPg0KDQpbLi4u
XQ0KDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggYi9hcmNoL3g4
Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCj4gaW5kZXggODJiYjgyYmU4NTY3Li4xYzRkYTk1NDBhZTAg
MTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiArKysgYi9hcmNo
L3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCj4gQEAgLTQ2LDYgKzQ2LDcgQEANCj4gICNkZWZpbmUg
VERIX1BIWU1FTV9QQUdFX1dCSU5WRAkJNDENCj4gICNkZWZpbmUgVERIX1ZQX1dSCQkJNDMNCj4g
ICNkZWZpbmUgVERIX1NZU19DT05GSUcJCQk0NQ0KPiArI2RlZmluZSBUREhfU1lTX1NIVVRET1dO
CQk1Mg0KPiAgDQo+ICAvKg0KPiAgICogU0VBTUNBTEwgbGVhZjoNCj4gQEAgLTExOCw0ICsxMTks
NiBAQCBzdHJ1Y3QgdGRtcl9pbmZvX2xpc3Qgew0KPiAgCWludCBtYXhfdGRtcnM7CS8qIEhvdyBt
YW55ICd0ZG1yX2luZm8ncyBhcmUgYWxsb2NhdGVkICovDQo+ICB9Ow0KPiAgDQo+ICtpbnQgdGR4
X21vZHVsZV9zaHV0ZG93bih2b2lkKTsNCg0KVGhpcyAoYW5kIGZ1dHVyZSBwYXRjaGVzKSBtYWtl
cyBjb3VwbGUgb2YgdGR4X3h4KCkgZnVuY3Rpb25zIHZpc2libGUgb3V0IG9mDQp0ZHguYy4gIFRo
ZSBhbHRlcm5hdGl2ZSBpcyB0byBtb3ZlIHRoZSBtYWluICJtb2R1bGUgdXBkYXRlIiBmdW5jdGlv
biBvdXQgb2YNCnNlYW1sZHIuYyB0byB0ZHguYywgYnV0IHRoYXQgd291bGQgcmVxdWlyZSBtYWtp
bmcgY291cGxlIG9mIHNlYW1sZHJfeHgoKXMNCihhbmQgZGF0YSBzdHJ1Y3R1cmVzIHByb2JhYmx5
KSB2aXNpYmxlIHRvIHRkeC5jIHRvby4NCg0KSSBkb24ndCBrbm93IHdoaWNoIGlzIGJldHRlciwg
c28gdG8gbWFrZSB0aGlzIHNlcmllcyBtb3ZlIGZvcndhcmQ6DQoNClJldmlld2VkLWJ5OiBLYWkg
SHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

