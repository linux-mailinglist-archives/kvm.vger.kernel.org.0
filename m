Return-Path: <kvm+bounces-15847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B65F08B1065
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CB2AB283E4
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 16:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240F816C87C;
	Wed, 24 Apr 2024 16:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FHvKhQ7i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1216C869
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 16:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713977714; cv=fail; b=TE90o6ccuKGjbsdM1WSToXvYSA5dfmDHUF3YWx1b6Ns5swWIe2odVcnwb9f8WAxRdgUvlx7gEtFWygpBtM5a1ORPgc+DFZhBNez2t/jtNra0EX2h+u1EjQ8AOi+yig4di8/2BJZO6m+A0eTlr3ZeC2BsgrS4zr/4G3Ma1YPumhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713977714; c=relaxed/simple;
	bh=duY77MlXRUggH938Zp1RfVC0YiVUSw2oZb0YzedQFZo=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lI5U31++HYn3FVPGDWlL+u8RcTT8vRky8hbWxjhZFz9VzVtWV1cCsHuE5XHAHt5/jumgGiEg5Gez0Zu1GNugmGlAfmrl69gPDqfCTg+5LhbJhj43YA35qXNYy1TGqNRRsjT81F8Ps3ezKQHZDfLolt+Qb2QPEyECsU9XCcYVvhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FHvKhQ7i; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713977712; x=1745513712;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=duY77MlXRUggH938Zp1RfVC0YiVUSw2oZb0YzedQFZo=;
  b=FHvKhQ7itziWPNSEN4faoRqcRB+HjCONv97KKsUqAGqLOB+jQIyM9LM/
   OUwUeuDLwn0g83720LsdW83ywujudDmNenctPNgKJpeTKwepu5iGqf0Ma
   UHK9tpQ/bs0Gd3eYgKJ11P1TiBNDUFeTPGCFwziHL5Lk0FtgblSf+O5Of
   Vsa7lEyxm9HZ4jEJ02HVlNwERwTgyz4I8subvKCesOpJ0jZG6VJajJfnX
   VFZ82QUhpncZtULvgXmj8VEuBAGCPwiHeDOQJYwQA3PUdX1/KX+y/D2EJ
   I4KEYM/cViF/hVPK1st5lL6TxmwpcNM43TkDzHEyR2spzSGYTuRamIkwE
   Q==;
X-CSE-ConnectionGUID: LzroTx8pRrWxEcLu5r7rhQ==
X-CSE-MsgGUID: 7ORnuLyEQa2t2Ut3dQ38mA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9472964"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9472964"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 09:55:12 -0700
X-CSE-ConnectionGUID: 2Y7SXhgFQiqNqEJwzFTzEQ==
X-CSE-MsgGUID: pge6DcHlTYS9Oalk25FELQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="62236715"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Apr 2024 09:55:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 09:55:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 09:55:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Apr 2024 09:55:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 09:55:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C59dDvXBV+eDiXLu1c/b99IXoOZk+qP1xuKXB2lf+kKScbQiqyT9MO/Mw2+Y0r8aUeETg4rpGdARRWjAoVV+H76rcMCLQiesrLcSZdw6668tgLVA8GMXkV6So3ATiMHR0ip7wTWfK9S6A7LebY+HWg2i86rhLP4RRhUPOksKIt4hMYC2pyXf6Vym6rnA/85hir1hxNZADn9t4KKSUiNKYhdptHWon62tbwOiGeNIAqcJjbSYiwh54NMeF0KJj/kMZLsYk6NlBfFnqkS9YRpLjPke4hF6jml6DV+XtxnPSIQq/Nig26LBP0Gz1kRZbPPvZ6Mf0ZmlmFo1omO0o7EE3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duY77MlXRUggH938Zp1RfVC0YiVUSw2oZb0YzedQFZo=;
 b=g5xLWwouutb9/TUYlT5bL9ur/8mtynULpwFeSasu7+knv6wedVL+lumeOWell2sUF7MkVOcj5b4bjbvl9oM+h3c0b2rLt3rRzEBdvWqT8trMe83z56/YWc99r7CVAXhGkl/QjYQ8ysTnL2Pn+nfIKSI3vbrB4Sl755yFAF2us2A1LZvxs+ogMIPGZuKcUUoWkapUwcB3uTeM1p/dBIXAGpB1uesavrme2VcGvNrWfri6NziGmqYtrjrnhISpkmW9R7Ygc5+AKc6dJoEywAbCXwb3ocwYv51TSppheCAPqAncQOKJrMqDmipoyRRCjBWx/1LtNV0q1plLd1ajs9gPdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6270.namprd11.prod.outlook.com (2603:10b6:8:96::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Wed, 24 Apr
 2024 16:55:05 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Wed, 24 Apr 2024
 16:55:05 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
Subject: [RFC] TDX module configurability of 0x80000008
Thread-Topic: [RFC] TDX module configurability of 0x80000008
Thread-Index: AQHalmgoAfxgxP49QEefWZUch1OWdA==
Date: Wed, 24 Apr 2024 16:55:05 +0000
Message-ID: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6270:EE_
x-ms-office365-filtering-correlation-id: edf3c09e-f0a2-41a1-28ae-08dc647f4ad0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?OHcyZUpCYUR6OGN6QzNXb0JsSUFzWTJ4eU5nbFgyTXp2YXNha2swc1FjUGd6?=
 =?utf-8?B?dGRGSSsvSEM4NUdITS9oVFlZdEhhWEt2Z2dyK1hicGQvdURMRC9vaUduMUZz?=
 =?utf-8?B?RkRMNXp3dVVlME1OTlA1V21sTUtTSktKQzVFNVN6V2pQclNpenZVN0JTQTRv?=
 =?utf-8?B?WTl6ZDR3VXg1N2NDM3grVXUwcFFhNFFoNlZJMTg4OWNvWFZkM2MwSzg2UFpj?=
 =?utf-8?B?aXB5Qm1CUElHMTZBL1k0REhKcWdXSFhDcEQ1SzlDellqTWZTZlVwZHkxNkNG?=
 =?utf-8?B?QVViYVh2TFRyajVBTUhzOUJ6bUljT2ZkWmVIbEV6OXMvSlZyOWY0cVFKeTYr?=
 =?utf-8?B?cHJ3UStTM0FJQ084V0NmYmtDQ2FiR1IvVE43UnBWVm9TNlZHS0VHcThSQ3J3?=
 =?utf-8?B?bVFaVnFEeDl1MWpXWU9xNzZhWVpkYVFLaE5zSzJNSE16eUs5UlMwaktjNmZK?=
 =?utf-8?B?SjJOVWk1U3FxSGlOMFFSVUtCSnY5TlZKV09Ta1A2cE5reXRoUm1xTFU1QUJC?=
 =?utf-8?B?VkU2L1J5bFBHS1NZbFZoN2wvU3hObjRONEtnY082SnlTeXE1S2duUWFYbVdr?=
 =?utf-8?B?MmFrVFBlcVhCc1FnUUFtQUpLZENrbDdPLzh4N0QxY2F1RWZnS2xlcVNPa0Fz?=
 =?utf-8?B?V3FUY3NZaDA4aHF1WC9kdzBwOVhRMlJwZzdSbk9LZ3NTR3NQbHROVHFxcnd5?=
 =?utf-8?B?NjhyU0wrNFdkKzFNeG9VczhqbS92UUNxZzJvVlhOOHlKRkhnNlhySUdjcmZN?=
 =?utf-8?B?cGozelViZzR2aFV1NDhNSGxkbjhIbTlLcENGcmgrMFBFWU02cjNmM1M3VkJ5?=
 =?utf-8?B?SHIzZzh5Ty9ncEJqSWtUV0E4TDN6OWs2enh2TTZyQkNSdWh4KytqcFdYL2RX?=
 =?utf-8?B?b1JWUUZBblZVMjc0Y3RuNU92U21aam8zMzlxeTJaaFV0SEhqR3VGcHQ3NXRM?=
 =?utf-8?B?WTN5MzNBb3dIbW01VEs0VG1mbUFRREc1aWgxdExwWENwQ29BQWtIa1NTZlVj?=
 =?utf-8?B?K1JaTGMwaTZDMWc5ZWlWdUIwREtkMW9wM2s1WngwWmF1MTF3dzZib09TZC9z?=
 =?utf-8?B?Y2V3ck12cWR2eTFhOTV1QTA4ODFUajRxQmpxaTZjSDNzOGs2aUJicGFVem92?=
 =?utf-8?B?bU1VRjNnc2xweFZmQS9FaVFqUzhIbmZiemJSc1R6MGIzUnMrYmIrY3VwMkI4?=
 =?utf-8?B?R1Z1WW9GU2lERnlqbm1yNFp4UFhQa2VWZ1NYS3dSbFhpSHhlcjJCRzUwY3VM?=
 =?utf-8?B?SWRMMkwwMTAxYTJQT0VrYURvWENpa2VNQURCWWxaeDYvYVhtRUpKWGZEd09G?=
 =?utf-8?B?MjNjTlhhVE9pamNjN3F5VmRYTzZ3c05RVmoveEM5dkgzYTBBMHM1cVFSV1Qw?=
 =?utf-8?B?R3cwZnhZQ1NBdFUrYXFkVmpSNlhHWENna1I1SHg0RzhFRlJ3UEd2Uzd3elo0?=
 =?utf-8?B?WUZ5Z1gwREVmc05EU3NrUjJtUDJGSGpJMjZOVjAzZHd6NUlnVDNkT1crM2Mv?=
 =?utf-8?B?OVVnWk55azJYNnhNOG9oS21PTEF3Z3VyL0VtbEhOTnhDRHZWd3FnRTB4WjJF?=
 =?utf-8?B?dlkwNXRMS0RldTMrNFlrMW53MnhRVTZYMUpFYTkyQWgxNHZEZjJKZnJ3c245?=
 =?utf-8?B?UFhRb1owc3Z5SGdWK1ZwRzVHZmlXa0N6VUxaWHpWaEx5Vmk4TEZIUldFUkpP?=
 =?utf-8?B?L055MURqbGN4QmdISm53K0NJWWVDYXRROXVISEQ2WWNnSHdmTksxN0JSem12?=
 =?utf-8?B?eGdHdXF1WWNZV0lxM204ZFdzMGxKcVNLNlRSbzIwSkRLV3VSSm5mbFVnTGdZ?=
 =?utf-8?B?aWtXc1YzU2RHSUFZMlR4QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1Fzc0RqTmR0MmtrQTByZlRTU2dFK3hYNExBblRFajFEem8wWCtZUEQ5YTlp?=
 =?utf-8?B?NHdyQ2crWUZCcDRROG9PM01JakdIWmFlUHYxbDhIS3ovZ2dJWmlaWUFTdjV5?=
 =?utf-8?B?QWQ1dnJxSG9ZUDNva1lKUTd2RHFjSmNlNkplcjNoOHFnWS9kZnRhWUpRSkhT?=
 =?utf-8?B?ZklZcWtpYXBKVnlaVThMSStMRGM4d3RhUmRLdnRpeStnbWRDVDljc3dHdVFD?=
 =?utf-8?B?VmY5elZGbUJIQ0t3NjVKYXhRZzdSRitEZ1NPYjZ1dUo1M3hHeVgrM2JydFJR?=
 =?utf-8?B?blRkMk1VKzZEdko2VjhOQVBGWUhhU3FVWkVNdktvNFk0ZWpKVjVtSmhjRXJl?=
 =?utf-8?B?ZW54aXFPWEwwQmw2aldVUmlzMkNlb29kZnpDVTZGVWt0R0RGTUY2aVlGR1pa?=
 =?utf-8?B?TVlLR01Jb0kzTkZHVjBYNHpHdFo4NnFDZEFXeGM4d0V4ZVdGUTJoTnA1TG1T?=
 =?utf-8?B?bmxpeStSK1NvQ2swUlVvbUh3ZTNHMTdqMW1mckQ2b2hUdHJYcWI1QXh0NHVT?=
 =?utf-8?B?Y0R1U0tLdVB2Q1hpdURQdjNqSEtBSC9rVHJOMWZTd2xGWDZXVk8xUVhrK1Rl?=
 =?utf-8?B?eDdyRXMvUmJBb0xjUzBUc2xyT00zWmlkYU1aL1RCZjNvR3JSbWM2cDJ1TWg0?=
 =?utf-8?B?WFVJTHc1R2NsUG5RSmJid0ZlbjZiMUlVSUlJbHVqcTlvSEJYQVhGYXY0OElV?=
 =?utf-8?B?V2RacjFZdWgwRW1JbnFZM0phUU52Y1JLUzFpS01lVzVKaisyclRncXNRT09t?=
 =?utf-8?B?ZmlHTzJKb0ZKcUZXa2Q5anM5aGNKcGZ4TzJxak9vaitHelNrekdjb3FTVFEx?=
 =?utf-8?B?UEN0Rit1Y1VqY3pRNERqalM2L3BqVzBGTjdNb2ZYWXpSTlVpS3A0NkhqSE9w?=
 =?utf-8?B?U2JWTzZMSGU4bUtmbXZGSDd3V205bHpDVFJ3eEMyTDVUdzZXKzRSU0RHV3Fq?=
 =?utf-8?B?Um8xMGxOazBlOTlxTDNObUJwSmZucEthUXpwYmIyQnFMN0kwRVh1cGRuV0Ft?=
 =?utf-8?B?SnpNZ01KbTRIVjdjQ3FDUWpUVDNjWDZDSnpmUnVXSXlaaXdiQlRWTWw0OEZY?=
 =?utf-8?B?NTFZVC9CR083Nm8vN0FsNDhTVFduYVVKa2tWaEduMDRZUXgrRnZ0WEtCa2Jh?=
 =?utf-8?B?My9aUDJyais4VDBERTVCenZhb0Z6ZXE3dW13VDI0dmRwNWhoRElLckdVeGhr?=
 =?utf-8?B?Ly8zNTd0OXNtQmRoWlEyY1lXWHVQVVo2dU5XdXcwYkhYWEpLVE4yL2JWVnRT?=
 =?utf-8?B?K2xJOHYwcEZwVmp6WTk0WWEraTVrK1FRelJKem05bi9aVHBnM3VFRkFKVUVI?=
 =?utf-8?B?KytBWFo2R2ZyTDFCdDRPSVoyV2tKNWFwbXBrbXNOczl0bG9pWHRaQjYycGQz?=
 =?utf-8?B?VjlvUkpXVlJOZ2VUVzZDNGpWNUozZ2hueG1XeGxob1NvaHMxMHJCUGNrVHJM?=
 =?utf-8?B?NFlYSFlUWXg3aCtQQW1sc3dSc2NtMFVzMXkwYTNLRDJCTmVPU1gxUEMrRWF3?=
 =?utf-8?B?WmczR2cza0VRQkJYT0tiSTcrekNrR1l0MWdSV0NLWDhiRlZJN3NCM0twNUNn?=
 =?utf-8?B?TDJNNWY0VDQ5empHMEhGMWZDNXFFWmhVRGFNd2k5OFBTRFhUWWNHL1VVd3I4?=
 =?utf-8?B?WXpoSW1pL0duczdSVlpWaFFCODlDOS9CdTJtVlVlYVdVeGZTVjR0Zm9GYmcr?=
 =?utf-8?B?ZFNiMDAwRnNYZUJPWXlZLzNwbGVDM29Ea0tZUWp6dWVwaEp4QnRFUHBtUTdB?=
 =?utf-8?B?UUtWVmtpWFNWOUlTUVgrK3AvMEZYVldXeDRWQWdUV2lBZEoxTUp1THI5SWdl?=
 =?utf-8?B?WnMxL0JJaXByOXNLRG9iZDhRdXhzemZlSVo2SXpvZ25EYUdqdE1HcGIzdVBQ?=
 =?utf-8?B?c1U1bFVBa2Fud2tZeFJ3OEZYdGErLzNXazFiUFRoUmdBL2wrQytvUFBwTGQw?=
 =?utf-8?B?Z1Q5WGM5VlM3TXBFMmF5czVJSkhxVnY2VDh6WlY5SWx6bE1CN2ZNU2ZLNENW?=
 =?utf-8?B?dHF0emNESmFub3dVR2g0NHhTVGVmU2hHdm9meEZ4UklMd0tmUXBwbUdZR2Ro?=
 =?utf-8?B?RW9KbENzYmtOcEQ0MnpZeVJJdU0wMXlvVTdyVTdBSjdQMTZRTnAveXpwM2xp?=
 =?utf-8?B?bktaQXU5cC9qRGJBaTR5QzhicEhmV0RYQ0hrNkNtWmw5ellnNFJYQ1ZhbTlz?=
 =?utf-8?Q?cRtov9IBlOK71ecCVU6TQGo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0BB621F6618E6478117A64FB73698B8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf3c09e-f0a2-41a1-28ae-08dc647f4ad0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 16:55:05.8359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4K/ldBsbxmH1U3gj2kATqNxF+3fFYEF/BBQYHefeFjgGnJW4LBLLmQMOekew0WCXkcwGWH6QU5Xcl6DksUvPs2Ch2UEBkLdXjSjs3jJTZV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6270
X-OriginatorOrg: intel.com

SGksIA0KDQpUaGlzIGlzIGEgbmV3IGVmZm9ydCB0byBzb2xpY2l0IGNvbW11bml0eSBmZWVkYmFj
ayBmb3IgcG90ZW50aWFsIGZ1dHVyZSBURFgNCm1vZHVsZSBmZWF0dXJlcy4gVGhlcmUgYXJlIHR3
byBmZWF0dXJlcyBpbiBkaWZmZXJlbnQgc3RhZ2VzIG9mIGRldmVsb3BtZW50DQphcm91bmQgdGhl
IGNvbmZpZ3VyYWJpbGl0eSBvZiB0aGUgbWF4IHBoeXNpY2FsIGFkZHJlc3MgZXhwb3NlZCBpbg0K
MHg4MDAwMDAwOC5FQVguIEkgd2FzIGhvcGluZyB0byBnZXQgc29tZSBjb21tZW50cyBvbiB0aGVt
IGFuZCBzaGFyZSB0aGUgY3VycmVudA0KcGxhbnMgb24gd2hldGhlciB0byBpbXBsZW1lbnQgdGhl
bSBpbiBLVk0uIA0KDQpPbmUgb2YgdGhlIFREWCBtb2R1bGUgZmVhdHVyZXMgaXMgY2FsbGVkIE1B
WFBBX1ZJUlQuIEluIHNob3J0LCBpdCBpcyBzaW1pbGFyIHRvDQpLVk3igJlzIGFsbG93X3NtYWxs
ZXJfbWF4cGh5YWRkci4gSXQgcmVxdWlyZXMgYW4gZXhwbGljaXQgb3B0LWluIGJ5IHRoZSBWTU0s
IGFuZA0KYWxsb3dzIGEgVETigJlzIDB4ODAwMDAwMDguRUFYWzc6MF0gdG8gYmUgY29uZmlndXJl
ZCBieSB0aGUgVk1NLiBBY2Nlc3NlcyB0bw0KcGh5c2ljYWwgYWRkcmVzc2VzIGFib3ZlIHRoZSBz
cGVjaWZpZWQgdmFsdWUgYnkgdGhlIFREIHdpbGwgY2F1c2UgdGhlIFREWCBtb2R1bGUNCnRvIGlu
amVjdCBhIG1vc3RseSBjb3JyZWN0ICNQRiB3aXRoIHRoZSBSU1ZEIGVycm9yIGNvZGUgc2V0LiBJ
dCBoYXMgdG8gZGVhbCB3aXRoDQp0aGUgc2FtZSBwcm9ibGVtcyBhcyBhbGxvd19zbWFsbGVyX21h
eHBoeWFkZHIgZm9yIGNvcnJlY3RseSBzZXR0aW5nIHRoZSBSU1ZEDQpiaXQuIEkgd2FzbuKAmXQg
dGhpbmtpbmcgdG8gcHVzaCB0aGlzIGZlYXR1cmUgZm9yIEtWTSBkdWUgdGhlIG1vdmVtZW50IGF3
YXkgZnJvbQ0KYWxsb3dfc21hbGxlcl9tYXhwaHlhZGRyIGFuZCB0b3dhcmRzIDB4ODAwMDAwMDgu
RUFYWzIzOjE2XS4gDQoNClRoZXJlIGlzIGFsc28gYSBwb3RlbnRpYWwgZnV0dXJlIFREWCBtb2R1
bGUgZmVhdHVyZSBjdXJyZW50bHkgYmVpbmcgZXZhbHVhdGVkDQphcm91bmQgdGhlIGNvbmZpZ3Vy
YWJpbGl0eSBvZiAweDgwMDAwMDA4LkVBWFsyMzoxNl0uIEkgd2FudGVkIHRvIGdldCBzb21lDQpj
b21tdW5pdHkgY29tbWVudHMgb24gdGhlIGZlYXR1cmUgd2hpbGUgaXQgaXMgc3RpbGwgaW4gdGhl
IGVhcmx5IHN0YWdlcyBvZg0KZGV2ZWxvcG1lbnQuIA0KDQoweDgwMDAwMDA4Wzc6MF0gaXMgZGVm
aW5lZCBieSB0aGUgU0RNIGFzIE1BWFBIWUFERFIuIEtWTSBpcyBkZXNpZ25lZCB0byB3b3JrDQp3
aXRoIGd1ZXN0IE1BWFBIWUFERFIgc2V0IHRvIGhvc3QgTUFYUEhZQUREUi4gSW4gdGhlIGZ1dHVy
ZSB0aGVyZSBpcyB3b3JrIGZvcg0KS1ZNIHRvIGFsc28gYWNjb21tb2RhdGUgYSBwb3RlbnRpYWxs
eSBzbWFsbGVyIHZhbHVlIGluIDB4ODAwMDAwMDguRUFYWzIzOjE2XSBmb3INCm5vcm1hbCBWTXMu
IFRoaXMgdmFsdWUgaXMgZGVmaW5lZCBieSBBTUQgc3BlYyBhcyBHdWVzdFBoeXNBZGRyU2l6ZToN
CiAgIE1heGltdW0gZ3Vlc3QgcGh5c2ljYWwgYWRkcmVzcyBzaXplIGluIGJpdHMuIFRoaXMgbnVt
YmVyIGFwcGxpZXMgb25seSB0byBndWVzdHMNCiAgIHVzaW5nIG5lc3RlZCBwYWdpbmcuIFdoZW4g
dGhpcyBmaWVsZCBpcyB6ZXJvLCByZWZlciB0byB0aGUgUGh5c0FkZHJTaXplIGZpZWxkDQogICBm
b3IgdGhlIG1heGltdW0gZ3Vlc3QgcGh5c2ljYWwgYWRkcmVzcyBzaXplLiANCg0KVGhlIGlkZWEg
aXMgdGhhdCBURFggbW9kdWxlIGNvdWxkIGFkZCB0aGUgY2FwYWJpbGl0eSB0byBjb25maWd1cmUg
dGhlc2UgYml0cyBhcw0Kd2VsbCwgc28gdGhhdCBURHMgY291bGQgbWF0Y2ggbm9ybWFsIFZNcyBm
b3IgY2FzZXMgd2hlcmUgdGhlcmUgaXMgYSBkZXNpcmUgZm9yDQp0aGUgZ3Vlc3RzIE1BWFBBIHRv
IGJlIHNtYWxsZXIgdGhhbiB0aGUgaG9zdHMuIFRoZSByZXF1aXJlbWVudHMgd291bGQgYmUsDQpy
b3VnaGx5OiANCiAtIFRoZSBWTU0gc3BlY2lmaWVzIHRoZeKArzB4ODAwMDAwMDguRUFYWzIzOjE2
XSB3aGVuIGNyZWF0aW5nIGEgVEQuDQogLSBUaGUgVERYIG1vZHVsZSBkb2VzIHNhbml0eSBjaGVj
a2luZy7igK8gDQogLSBUaGUgMHg4MDAwMDAwOC5FQVhbMjM6MTZdIGZpZWxkIGlzIHVzZWQgdG8g
Y29tbXVuaWNhdGUgdGhlIG1heCBhZGRyZXNzYWJsZSANCiBHUEEgdG/igK8gdGhlIGd1ZXN0LiBJ
dCB3aWxsIGJlIHVzZWQgYnkgdGhlIGd1ZXN0IGZpcm13YXJlIHRvIG1ha2Ugc3VyZQ0KIHJlc291
cmNlcyBsaWtlIFBDSSBiYXJzIGFyZSBtYXBwZWQgaW50byB0aGUgYWRkcmVzc2FibGUgR1BBLg0K
IC0gSWYgdGhlIGd1ZXN0IGF0dGVtcHRzIHRvIGFjY2VzcyBtZW1vcnkgYmV5b25kIHRoZSBtYXgg
YWRkcmVzc2FibGUgR1BBLCB0aGVuDQogdGhlIFREWCBtb2R1bGUgZ2VuZXJhdGVzIEVQVCB2aW9s
YXRpb24gdG8gdGhlIFZNTS4gRm9yIHRoZSBWTU0sIHRoaXMgY2FzZSANCiBtZWFucyB0aGF0IHRo
ZSBndWVzdCBhdHRlbXB0ZWQgdG8gYWNjZXNzICJpbnZhbGlkIiAoSS9PKSBtZW1vcnkuIA0KIC0g
VGhlIFZNTSB3aWxsIGJlIGV4cGVjdGVkIHRvIHRlcm1pbmF0ZSB0aGUgVEQgZ3Vlc3QuIFRoZSBW
TU0gbWF5IHNlbmQNCiBhIG5vdGlmaWNhdGlvbiwgYnV0IHRoZSBURFggbW9kdWxlIGRvZXNuJ3Qg
bmVjZXNzYXJpbHkgbmVlZCB0byBrbm93IGhvdy4gDQoNCkdsYWQgdG8gaGVhciBhbnkgY29tbWVu
dHMuIFRoYW5rcy4NCg0KUmljaw0K

