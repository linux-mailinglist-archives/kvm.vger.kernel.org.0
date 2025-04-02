Return-Path: <kvm+bounces-42460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E8CA78A6E
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 10:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAECC16C86D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 08:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC44A23536F;
	Wed,  2 Apr 2025 08:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TWS8sjEy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053C41E570D;
	Wed,  2 Apr 2025 08:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743584305; cv=fail; b=JuHtyJze4hCVwz1aDr1hV9f5Wb0OU5mWA6QFjesfO5dgC7zzNgcU+07/wIG3OIncL04omqxoKENEemoK5SLCdKzDLR8lcjkHKh2mmXGgVHV4v6vdmgxhDQH6GBqonnyXGZn2pIhQ/y++xh8tUVPogAi+EmEYIzUGrsWFvh/2CXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743584305; c=relaxed/simple;
	bh=3h7Z2GdH/LnetZDIUcMoYmTck/KGkrjt9Q1gKFHWIQo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FJWVlCPR0nUI6lGoiyMzdNRjPI8O0j4GNjiw+T7+/Yadijieqd2uAvQs2SuBQnZK+RK1FAt6uzJBqVIEbu9NPgN+3+Yh1tHzbBrrGEkt7C9zmzhD79lTe0eR0wHD5/YPwKPym4NE5oSkibJEf55EVOGXJvCSZ9fInCp4hQR0ILo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TWS8sjEy; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743584304; x=1775120304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3h7Z2GdH/LnetZDIUcMoYmTck/KGkrjt9Q1gKFHWIQo=;
  b=TWS8sjEyYrQkfb2OOzKgHibYsLP7NYSpRUcwQAJiL+F/PTL9O4x6DHNZ
   OpZ/Ks1B9MabI/TJfA526ZZDi12K7H4HVtygnaApSjkxFFtnRyIFaL2KB
   Ye7XjZ5QAFkE/6zYiuSndxuZW0luFhjoziXWDknD6XMe5HFuNANLkLlYx
   ru7b1pGePXD1Ldr5FgJXEQEc/QtgYnfho7LpK/XEQojcnr1jPHA2NpYUn
   jNdi4XdITKgTLrUweE6mm8ie1SyGJx57ZlrTbiGzXJBd7YggVKGrTgHiq
   kBvGiCGJjun+U1rDcH0uaGpCeUH6YQ6iA/JVMqsliZ/VkvkqCvbgfVKPU
   w==;
X-CSE-ConnectionGUID: JIaFJoJQRpCKsRkzHOHF0Q==
X-CSE-MsgGUID: 9ZlUwbcdSAOPxqG56fuvfw==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="45035868"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="45035868"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 01:58:24 -0700
X-CSE-ConnectionGUID: kWi5rCvEROC6VCYseix/3g==
X-CSE-MsgGUID: 6a7uiVYqTe69mNkfh4ZrBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="130760128"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Apr 2025 01:58:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 2 Apr 2025 01:58:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 2 Apr 2025 01:58:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 2 Apr 2025 01:58:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OB5pwiqDp4BwtXghi2hFoAD0mgkrXXWB2uzrBWHYDvDiK/BM5u3DX83Lo9Ld2Bgy2RHBrk9hLIuN2FER2M11K/DHoxIMOJnPGxhFrsUzve7nCW3kdNy59wsS9V2kOk3KpFkwZjAjUYwLiR4VTS8/iYflVLYi1LpbW6iKOZXH5hVs+JNYjw5oK6ryrSedM0kQC8vuAG5LQgT2YBS6HWfPOE1Ke0HHQ90AO9k+guWF7etp7ZIAd3VQSDhqEkDdm3O93z1iQugL3B7KaJ1Qu6g7E6iCflnIt1dpT4Q0FKdfMKz3t7s4pPat3te41iTSUT1H9Us6yBq3Byh7BsZ5GB0T3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3h7Z2GdH/LnetZDIUcMoYmTck/KGkrjt9Q1gKFHWIQo=;
 b=qblULGKE6eOby7K+nwkFH1l17gQ0gWpj4UCWSr0m/eTmzJdLz9u8/mXx8DsvsBrzqbW3m1fFqcqxcIx7gt3rJwjRCGJ6Lt5FMV34jeAQ44/Wn5SW+PyQzC2gJ3FcY7ULJvnfdAHjKPEPD/WyVWKJwa96Boi235Av0rz2LJqqSYCGjUgDn3C1vQytvWKT2F7H2YrM/HIqeztnexmpZrqPSiLJodNY7gD0l00ZogocSsh2gm3Wx6mBSNYcMbZ5U6p8njVEnCeH5sd6sLCAwsnHExSBHwg6cEdKorCPjmzCmgA3yQ97ztQXyLEOwBdb7m/ok980BxKDoR3DribCUa7iPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4709.namprd11.prod.outlook.com (2603:10b6:208:267::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.48; Wed, 2 Apr
 2025 08:58:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8534.045; Wed, 2 Apr 2025
 08:58:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Gao, Chao" <chao.gao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Lindgren, Tony" <tony.lindgren@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Topic: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Index: AQHbo2Q+reE/k3eiXkm8HRe31hfG0LOPjGSAgACHigA=
Date: Wed, 2 Apr 2025 08:58:14 +0000
Message-ID: <d14777dd931996caca138c9b51c2f6c4128bdf81.camel@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
		 <20250402001557.173586-2-binbin.wu@linux.intel.com>
	 <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
In-Reply-To: <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4709:EE_
x-ms-office365-filtering-correlation-id: ad810667-87e7-4bb4-7261-08dd71c480a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MUVreDROL05sbDAzU2VPd3FyTG5IUjdBU2dpeFp2eU9Ic3Rha2crR0NSRTZ1?=
 =?utf-8?B?aHlZQXQ1c3NzVzJvaVMzdWRZMFFGZklwMk5lRnRhNXNnZXV0TGtEYzhIZHhp?=
 =?utf-8?B?WnU2ckl2ZGtBUWYvZEtDOEtIR29XMGdUQ0NzQVp1Sll1bWd4ay9jY3U4Sjcz?=
 =?utf-8?B?cVhjT1VpTDNyKzZadUpHazk4M1RIYzFSYWtpaUR1ZllYb1B6d2ZDMVIzL3cy?=
 =?utf-8?B?R203alIwZDA0U0xFYmQxMXFOWlhybEdLMHpOTWtrR043VFRjNDI0TXZGM1lP?=
 =?utf-8?B?SUc1amtiSVZEdVpGUTlKbUtkeld5bFhWQ3cwUkhvTVpwQTVOUjFlcm9oU3JL?=
 =?utf-8?B?SFFoWGo1QkZ4QWIzYm5FQkpybHVxbDdWR2pma0dkbm9iOUwzOUtlQ05XVHlT?=
 =?utf-8?B?V1F2ZVBlYmtLbUtxTG9OME8zd1l3MDQvcVR5MHNwNGtUb1JEeVh2UzZpVndL?=
 =?utf-8?B?a1VjTzNSMUdsb2l2WHZBRkJPcDJRYjhYcDVCL0FqeWVLUFltMFB1N3prMENF?=
 =?utf-8?B?OENjTm1zVUpTVEt2QkRVa2p5MjRnWkYxWTNBV0Q4WTBxc29FbnpXUkVzbGxL?=
 =?utf-8?B?cStjVzFJcDFtRlhxL0lMQW9QcFVUYktPTEdaNm1ncHJTZ0NFQU0rSTRZMUFi?=
 =?utf-8?B?WUdjc1I5R2NrdHVmeDdqQlppZXVGVVp3YnBmMzcyVGxZNW9FTW5Bb1RDYVV3?=
 =?utf-8?B?QWlGNVYxQmt0ZHo5a0tPZzR6UFBqSVBjcUV6aHhGTk1tTkdIdlZ5UnN2ejJJ?=
 =?utf-8?B?TkpGaE9Cd29qN2dKYUlxV3RtTnROOHBhRjVhRGtWTHRXaVg0dThscWhpcUgv?=
 =?utf-8?B?QUpUWkQzQjVkRzlzS1g0dmt3ZFBDR0dBS2taZmNxbGo0cjhBOWlsTW81LzBK?=
 =?utf-8?B?aGo4T2o5Sy84VTRSR3REanlsdVZBRDgxczNnelVSdFRuVUk0U2RmYTlJVEtZ?=
 =?utf-8?B?a3JIclEvM1ZDaVlBT0duMDF5dDQ2L3o0ZzU3KzhRQ1Y3OFlGblJNc2daN3B3?=
 =?utf-8?B?U3V6c1cxUlRmRlhONWEzYWhNc2V4dnNxQkhnTEpNZHZuc0Z1SnJjUmxTcFNF?=
 =?utf-8?B?WDJGYm4rUW5Oa2RkSUhmN0ZwWmFHVURnUHpqYWZxeGRQRE5DTjJxTGhyaGZ3?=
 =?utf-8?B?d09Mczd3a1hUbmhGbnk3Ukk3ZG5tK0hYTXA1b3hURzJBelp3VkVTRVF0MmMz?=
 =?utf-8?B?SWN2cTBTc3dWdkU1OCtUT3JvbVBsL1lHUWgzMmlvNHJqSWFsdlRVOWNLamRM?=
 =?utf-8?B?aG0waDlzTTZNWTJpUlQ5V2wzUit6MTlteVJKV2VNMUNpNkpIQktVdVZQNEIx?=
 =?utf-8?B?elptaVBhTDBGM0s4V3NxZWYzUmFzblY0N1FVZ2dwQUQwYkZNL2V5QUtFU3Zl?=
 =?utf-8?B?MG0vNnpDSkxBMm93SmcxYlpIWUcrWitVejhqK1ZUcFBkV2NkaStMNmRheThY?=
 =?utf-8?B?MmlrT0RmR1NIUG9wMUM0TkZkN2xCTnpHM0pUK0FYT0pGY3FDQVRweUcrSlZn?=
 =?utf-8?B?alFYR0hiZkNvYk9yMU14Sk1rWHJLUFJMejNJN3BjS1QvZ1BlVkJoVVVqNi9Z?=
 =?utf-8?B?KzhlbUJVTmF4bUFQMUtsazJxOFJLVzg5OGd1TTh2aDFZTkljRTJaQjM1cUVX?=
 =?utf-8?B?QmtLVzJUS2VOUnNyUFMyUjdkdUk2YXFnWDJ3bG1IRTlmTmhlYmp2QkM4NDc3?=
 =?utf-8?B?WVhvajIvU3BOandTUFNCZWtZQ2tKWHd2RGNpZ2N5b3h6a0laRFRQYkltTGlT?=
 =?utf-8?B?YkV2eFV0VmxMWVJhYWdhcWYwRXBVWWhJOXFCbDFRSlh5TUN2ZEI4N2plN20x?=
 =?utf-8?B?K0FFNVhZM0xpTjdhSExkTmEycS95ZFRXbUJGdGxoTDNZUDF4aXpWNU1WSk5k?=
 =?utf-8?B?WDVmTDNIUzZCZmJxNWNiMW9tNmgrRmFLSDFSQlp1MHlsMmRCZVJDZm1sdUJV?=
 =?utf-8?B?dnVJbUhQWWFaVEFFZmsxQmt6VllaY1NvcUJ4ZWkrMkZvTWFhQmozTHo1RDBQ?=
 =?utf-8?B?QkQrSEJRYXJ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUNLMnllejNxTzBHMFpVeVZRMzdDMkhrUUsvaTZ2SldRZkgrQ2JmS1ZoSHgv?=
 =?utf-8?B?TDBFbDdQYnEvdjlDMWNSQjR4TFh2ZVJTM1JVT0YvaDY2VVZTeU9od1VFRndh?=
 =?utf-8?B?b3BRVFFJY1Z3Vjhxd1lIaFhwYTFNbDJpUUhPUEtRWHJ1OUFBYTlUMHlWcUgv?=
 =?utf-8?B?bm5Kc0RVUkJYK2JBMDZHL0NPOWF3dmF5YVlFeHJCRThZMldmNGpUMlUvZ1ov?=
 =?utf-8?B?NzY2ZVZ5ZUIvTiswdUpjS3hzcVZHMElqekFOTm84L2ZkcnlxSW1hWW5KN2gw?=
 =?utf-8?B?M0V6VlY3ZGxScEFkY21Bc3FINGRWaUdoNVVLYkJqRVJ4ei9SRDlOdFZOVm1P?=
 =?utf-8?B?NCtSOVFzdlBMS1Z4dm1zRmI1bUg3ZXVhK09yL0NMQkFRa0gxOFZlSXhGaGFV?=
 =?utf-8?B?QTZSSzdjZksxaEVqTW82SnFJcm1nQm9UTmQwek95LzFITUl1a1FLK01Zd01k?=
 =?utf-8?B?R1M5T0VzVDBJZEw4VGtoK3Bvc05zYndZbTJQOVZsQzBreFVScm44ODFSOGJu?=
 =?utf-8?B?clNxcGIxL1JxZnVVaGx0MHE0SDBxL0FuQnZYZ2VHVjgwUWQ2dEVoWEp5SGVV?=
 =?utf-8?B?YWV3WlFaVjlqSmlQeUN1anY2Y21RV0F1MWw0SDREZTNEdDlpcVJ3MXhUdlFL?=
 =?utf-8?B?NjJ1Qm13bFR3WWJ6Tnd1LzZwWXdDSG1nMUlKcEtPVUIvbFhUUEpQNTFuMDBs?=
 =?utf-8?B?bDFJN1M5bW5zK3hSajZxMTdESGNZV0dhTGdUUy95VmRkWGF2UEVPT2RZbDRJ?=
 =?utf-8?B?ZFlNVnczSnhKYlU0TkY3cXRKU0JJWEgrQVhoT2FIdzhyZHBYc3Vvdm9UY2l6?=
 =?utf-8?B?aHpybVhaTm5rWmVsNjlSZlp6SzR1RUVjZHJTN2FMUkNLQkZ5WkJGWi9LcEhx?=
 =?utf-8?B?cndnRjk5Nmx5RGZNOFJyczR1WjA3WGwrbThBdUVUdStLUUNxeVZ5aXdxeWZ4?=
 =?utf-8?B?U2V2NFl0aDRJYzVRcGJiM0F6U0JrTGp3RXVvQ3pDQVQ0aXhxU0xkelZIRm5L?=
 =?utf-8?B?OGduZk1ITnhHTWV6L0MrWjdoOVF3Y0xRdnAzWjRGUXlWTkJoRmt6ZnYwUUxx?=
 =?utf-8?B?NitseW8waUNFU1hZT1VkcnBhQjZjZ3dUdEx5WTYyNU1LSDZ4SFhzWSsrQkMy?=
 =?utf-8?B?dDFoRmVPbnE3SENCTWg2RWxLbWlzeXRVdm4rYXRydmJkZkR1aFZKQVpodWVo?=
 =?utf-8?B?dWpkbkRSeVowZzkwN2xjWXp5V2gxMlVHd2ZuLzY1Y0hBTENuOVh3Mm9yTC9n?=
 =?utf-8?B?WUlXSURTWE1RVDhhT1o0UGxWOWNndHJGZWRCMHlITms1NTNENjhBUDA0ZTZB?=
 =?utf-8?B?Skl3N3AwVGdVM3BSREhOMEEwNU84OXlKa1hacWFQU3BrQU1LcVJOWE9wTHJQ?=
 =?utf-8?B?RjU2OGd5RW1PU2hIa2dPVk1vWloxcmFKOHNZUUttbTBDWmJjNkV3YkFNd3hL?=
 =?utf-8?B?K0hMSjhHTGxHK2dJUGRZcmVFMEFlS3dHQmF2d2pjMVFjeGdkN2dDS2tmUEFa?=
 =?utf-8?B?Z0R2WVk5bS8zYlFrNTFCeE5mdGFrOGo4MEtOYTFDWTM4MFVFYzFEKzNlMnVE?=
 =?utf-8?B?UjhvbG9ETStkUkxjcmwzTExMeENDZkJUSUlOR0R2ODdvWk53ZWQ2U2F6Q0dE?=
 =?utf-8?B?UlVZMTVVdnlXQjVWSWE2QWo5ODFIYXhaZlFCTURyMFpPbWFzMVREak1xWm9h?=
 =?utf-8?B?WjRpQk1hbFovc3QzcWlLN1VudU9CMUsyeDJqbHIvTC9ZNVE2ODFQbTVyU0tX?=
 =?utf-8?B?cUpSQmw0VzZGT0lzZDJ1cnRDYW42bFlRblkwc1I1by95WWdXaGZaK1VlYWNv?=
 =?utf-8?B?VzFCRXVsaTZsRGxoZEdSNDFjbE16WGIxNk9KSGJUNTArQVZhSEF2ZU5QV2w2?=
 =?utf-8?B?L1JJM09oeFlPRmpNZDJGQ2ZKeC83NTRoNENaci93bHUvVE5sUTdwUmVlYjZh?=
 =?utf-8?B?RjRlcHhPT0FTblV1U3FhUC9PR3dEWTFTbUQ0NFlNdHBIYW5IRXQ2aEhQc1NS?=
 =?utf-8?B?VFdoTHByYVRtZk5kNU9uN0RDRXZtVnFuMnc3bzJhQkpWV0FoZjJpZ0tUeURy?=
 =?utf-8?B?djNpNS9keEk2ejVtUlJ6ZTI2SlZGWk9Pdk5YWVI4TTJQUFYxaFBHT2g2MFpp?=
 =?utf-8?Q?bfOsGLRD1OoGmu1dg/nBBz89w?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8584AE56532344CAB690D69ECF3D06F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad810667-87e7-4bb4-7261-08dd71c480a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 08:58:14.1915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qhkTqPtsBwAPUpteYR6OY/RJ/NZLqQhKvxkO4aHTtU1US6MvXMqRa200RgtdrUnTBdbArEL0btbQDVLQAGmziw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4709
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA0LTAyIGF0IDAwOjUzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IA0KPiA+IEtWTSBmb3J3YXJkcyB0aGUgcmVxdWVzdCB0byB1c2Vyc3BhY2UgVk1NIChlLmcuLCBR
RU1VKSBhbmQgdXNlcnNwYWNlIFZNTQ0KPiA+IHF1ZXVlcyB0aGUgb3BlcmF0aW9uIGFzeW5jaHJv
bm91c2x5LiDCoA0KPiA+IA0KPiANCj4gSSB0aGluayB0aGUga2V5IGlzIEdldFF1b3RlIGlzIGFz
eW5jaHJvbm91cyB0aGVyZWZvcmUgS1ZNIHdpbGwgcmV0dXJuIHRvIGd1ZXN0DQo+IGltbWVkaWF0
ZWx5IGFmdGVyIGZvcndhcmRpbmcgdG8gdXNlcnNwYWNlLsKgIFdoZXRoZXIgKnVzZXJzcGFjZSog
cXVldWVzIHRoZQ0KPiBvcGVyYXRpb24gYXN5bmNocm9ub3VzbHkgZG9lc24ndCBtYXR0ZXIuDQo+
IA0KPiA+IEFmdGVyIHRoZSBURFZNQ0FMTCBpcyByZXR1cm5lZCBhbmQNCj4gPiBiYWNrIHRvIFRE
WCBndWVzdCwgVERYIGd1ZXN0IGNhbiBwb2xsIHRoZSBzdGF0dXMgZmllbGQgb2YgdGhlIHNoYXJl
ZC1tZW1vcnkNCj4gPiBhcmVhLg0KPiANCj4gSG93IGFib3V0IGNvbWJpbmcgdGhlIGFib3ZlIHR3
byBwYXJhZ3JhcGhzIGludG86DQo+IA0KPiBHZXRRdW90ZSBpcyBhbiBhc3luY2hyb25vdXMgcmVx
dWVzdC7CoCBLVk0gcmV0dXJucyB0byB1c2Vyc3BhY2UgaW1tZWRpYXRlbHkgYWZ0ZXINCj4gZm9y
d2FyZGluZyB0aGUgcmVxdWVzdCB0byB1c2Vyc3BhY2UuwqAgVGhlIFREWCBndWVzdCB0aGVuIG5l
ZWRzIHRvIHBvbGwgdGhlDQo+IHN0YXR1cyBmaWVsZCBvZiB0aGUgc2hhcmVkIGJ1ZmZlciAob3Ig
d2FpdCBmb3Igbm90aWZpY2F0aW9uIGlmIGVuYWJsZWQpIHRvIHRlbGwNCj4gd2hldGhlciB0aGUg
UXVvdGUgaXMgcmVhZHkuDQoNCkkgd2FzIHRoaW5raW5nIHRvbyBxdWlja2x5IChzaW5jZSBuZWVk
ZWQgdG8gcGlja3VwIGtpZHMpIGFuZCBtaXNzZWQgdGhhdCBpdCBpcw0KKnVzZXJzcGFjZSogd2hv
IG1ha2VzIHRoZSBHZXRRdW90ZSBhc3luY2hyb25vdXMuICBTb3JyeSBmb3IgdGhlIG5vaXNlIGFu
ZCBwbGVhc2UNCmlnbm9yZSB0aGUgYWJvdmUgY29tbWVudCA6LSkNCg0K

