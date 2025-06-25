Return-Path: <kvm+bounces-50769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D1DAE913C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:49:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83F804A729C
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:49:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A912F362A;
	Wed, 25 Jun 2025 22:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GeeUsGJJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2834B217707;
	Wed, 25 Jun 2025 22:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891762; cv=fail; b=Z5k6CN156Ycq84h+mdm8YsKPeFJZheWdcXADwKu66xNutgeu4BJgrB1mNDeVyb79w1z3Xfwfm5aXT1QYtcO6jQSwGoD/bvANQgVDx6y9XTIAvIOQF7DXF5cC51asW66XVN+UOWhvWyzCC7kYGsDyJh6fv9CxbFxq0Of0n7kG1oY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891762; c=relaxed/simple;
	bh=WF2A5FhDJSKXilqXmdClOq5tLeXzeydcfPO/OXs23l4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qBKXl5vvbRNNP3EZv0rKf5q6UeD7xcs02JqAXxBVSf6RHR+aEKpFerGmOc0B3vBhrUkwrLIPB72KMOqLMz0DemMKcfX0xFQIh5AT+J9rdlPxrEn/sdB3s1375JKOsYHlbOu0M+sXg2svLZ7KtNyGASy1DkWu4BR+HFkE02aIYko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GeeUsGJJ; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750891760; x=1782427760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WF2A5FhDJSKXilqXmdClOq5tLeXzeydcfPO/OXs23l4=;
  b=GeeUsGJJZ+U9/MuZ7W7qS0VeyqvUUYmpVz5XBDzFG1oy7sYYuAsfgexP
   8u3cQIzVHJXuxb/2SNbh2ZHyvZ43TbivIH1SNYEbgmTRF2xphizqcL7sy
   tYB5sku32kUHzYxwo1FT8iEUl0YLRTayx+YblzksextbhmMSD+Amg1RO6
   N4ij0Ll7neDipQhjp5OW3hJHosjAEnmOxIf4Fbyxtr57fak19JyBVVDX3
   SyF5v6Nw5jiCZpqNf67fNENvHVqZ7w2lBEbTT9Xep+oHkrlmJt4YTh+KQ
   fWDAuU/Y07Gdu7l+hoX6Nu80KaqZZEo1+tnDQk+XGFmHIKYYKeB14Tfm2
   w==;
X-CSE-ConnectionGUID: FAs9UAk6Tlq7PFozKe2veQ==
X-CSE-MsgGUID: lGoAvuiFQRKbbNmgOz+26A==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="63866956"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="63866956"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 15:49:19 -0700
X-CSE-ConnectionGUID: WRGN+d70QL68F7QoM1HHvA==
X-CSE-MsgGUID: 6ZeGTcyoQGKvTk3e0aWpwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="152466855"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 15:49:19 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 15:49:18 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 15:49:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.83) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 15:49:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=my5Q2GgTBTKk2T4XRyLUVo9WKcUusufvrt5NyPt/hbE1Et8DWrHma+jLvBpHbRehKnJHxzQR6FVX0lE2qTxSm6PtogLC3ZFprwH/QUn97cZPS+PtBp42xw7htIZgkDRNgKQRzDnCRVh8ZKnFYSjXmUq0ilf+DGOPZpfrEqcManrOxjzzJ0yCjVDD42YYYVaCgB+fizPfjB8ooLdaSi/YW0r8+a4nNeBliji+/Tv03fot9j+dUFdes1E997aGe7spdid8JwoK+L9LJOn0txU5lfStXgZWxHk7BK9jrjGVk8H/IyBzDx76LYmeYCwYdZsDQcJe0aM3vBAkdXf7SYYisQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WF2A5FhDJSKXilqXmdClOq5tLeXzeydcfPO/OXs23l4=;
 b=UFzQBqMvG9iFsimP5dn20pP0E1eUQpTk2G0FQsO1vVMFqCvTAjT2N3qWU6SF1qfnGpoa/P8IU6NU3W5hHnMb8pfiGlDL7hOAzd4TqTi3RTxXCaJdef64FoXmrTXAwaAEBlSR6WKoaH2ou/q0vPHEOTzKoUPspyzh7GqnNrmmQpvAHwbRkPlm8G7ULiJ+g3SiLiFgbwpaKR1UKW2gFQvbPNA6fHxF7w+0s8qZqN+3luYIQpDaBz57UpduTRW8JUurm6xJItyR3E4GDUpeHVr07rpBvL9wCqeRNy2KZc5zAX8J01eVl09WrtxoCHV7kBipOwcA26NqHIdgc0g3IDfXUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB5798.namprd11.prod.outlook.com (2603:10b6:303:185::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.35; Wed, 25 Jun
 2025 22:49:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 22:49:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7QUk9uA
Date: Wed, 25 Jun 2025 22:49:16 +0000
Message-ID: <643af193b814ae6ab2473562c12a148b31ad608a.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB5798:EE_
x-ms-office365-filtering-correlation-id: ad0563b2-9535-43fb-2b93-08ddb43a8365
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MVF2dmcvMDh6NXYybXB1MnV2VDN2R1ZkdlpuLzZTMjNHRFFZSG9BdXJob0wy?=
 =?utf-8?B?S0Rab0hEZFIrdTl0TWdrak9RZmNPYm03Q3hkUlEwSGhtM2FaYkwxWjJIL3hr?=
 =?utf-8?B?TCt4Q1Eyd3dQQnNQYlVzbVgxbDd4b25rSW03TkpudE85WkdhUjk5RUNoemoy?=
 =?utf-8?B?dExwb09LbnFjWXFDb1pOOENPdG1VbUMrbVFBMVFrYk1FT2gyYnVLMWxKSGha?=
 =?utf-8?B?YUFpdjZUQkN6Wm9DTDBMRFdvUFh3ZG9aRVc3L0JPUG9ET1BpdmF5YktwMFJu?=
 =?utf-8?B?elVnMDEzeTA3UGRHazN1YzZCL0xtN2ZCREVlaHJIRVhHWk1vdDF5ck05N29x?=
 =?utf-8?B?MnY0R05TRTdKR2RNRk45UUZvSzNVNFE5amdYVGNwc1k2eGRRRTJkenFsZFAr?=
 =?utf-8?B?bENTYmZvNVBrQW5XZzdHZEVnRzNPY0VHOGdBMHowdUF6ZmI1Y1ZhOVJhVSt4?=
 =?utf-8?B?SUx0YTVWY3pKaHF3QTdKRzBrd2o2cW5JczdKK2xPcEsxWStmL3VrbkYrd3FY?=
 =?utf-8?B?ZG9wWURkcTY5UHQ4azZ6b1RCRFE2dk5LazlvVk4xenBscWYxUGVSd2hyTGFq?=
 =?utf-8?B?blJsSzJTNzVvaGliak1YSWhmcmcxck5TeDRHcWVFRlByNTRFTjF3UmpVQVZ6?=
 =?utf-8?B?V05VUC8vNmJYMi95czJXeVFaNUZZUkVmeWVEQVd2dzVBZHdlSXc4dmZEbjBZ?=
 =?utf-8?B?U1RLQlpuRkF0NEFmVlJzSXRDTXdSTEh0bmlNZlJnYjlaNjFOTnJTa250Z3Zl?=
 =?utf-8?B?RzBoKzBWSVVnd2JBdHNiMTFNRmg2WDY2eFMveEtiWUNGemM4L2kxZXF4N3p3?=
 =?utf-8?B?ZWw2RlBDN0lBSkJEdld5NWFEdENGaStCK1ptWmoram1xdGpWazVCUy9nT2JV?=
 =?utf-8?B?d09jcmhic01lbjlHMkMxQ2dZS0c4ektnSlliMkYrTEJ1TCs2allvZ004elRH?=
 =?utf-8?B?TkZaUHdqK2xtdTNsQW9aRllEZmhiMlREMmJiQVcyUjhEVnFTbFJEenM4czdq?=
 =?utf-8?B?VG9DMzk4ZzFDeXk4UEdtMDlKcy9EaThDb1VHY0hNOHFYT2RyNzMwQmg1V29l?=
 =?utf-8?B?ZkpTNkxRb21vOHBPd2R5VWNqeUhYTWRnMFdyZEJ5Wnh2OWZtVC9pVGtra0x3?=
 =?utf-8?B?cmo1YkIzZkU0TnRWdkZtUzY0QXh5TFMrQTlwTDZ5THFibkFwdFNKTjVLMzI3?=
 =?utf-8?B?d25NSjRVcm9PV0pHS0NlOVFOcVJ3U1dCR3VvUDV1ZGNJcHVrQnE1WmliZ2p4?=
 =?utf-8?B?M2VFSXZVSGFTOENjZGhBVTZzdUNYajdoOHlsbzZaMG13NWlZN1pLYjYrWWs3?=
 =?utf-8?B?SkRnU3hKemN4MmZpNEYwTTBZOVlEYTZScU95bXFhblMwTGpadmo3Z3VuOVhG?=
 =?utf-8?B?bkV3clF1TkpEbnJpWDRCTzhUajQzZDExcUlWU1VIZTgrakt5Ulo1UTlnT004?=
 =?utf-8?B?Skl0czdjTE8zM0VlU2M1U0tObGRqNW1qcEtQaDRpSzh0UkM2T09NUWFkd1Jw?=
 =?utf-8?B?anJ3TEZxMUFya0VXbkgvZXo4aDlHSkJuMldSZXVWRXgxR2RpcVdzOVVrcTF5?=
 =?utf-8?B?YVNpYzFYUjNXSnJpcHh2ejJtRTkrS3ArUm5PdThLd0UvV1VzTjJwV01EWmMx?=
 =?utf-8?B?K3FOekwzYmJXMCtaOG5VMWdqczZFSm5rQWJzR29CQzZHa0FCbk9xVGlhbkJo?=
 =?utf-8?B?QXJNZ3V5TWZPSTVSZUxiZVVMdDloeHBjeTJ3bmYvYmxITHNqWGltSmRjWWND?=
 =?utf-8?B?NDkydHBkQ2ltNnRoc3RTUjB5NFo4OXVQYmdUbW12RnVYajM4VHk3aG5KZlpE?=
 =?utf-8?B?ZFVKZDRIYzBtZHpzK1pXRFVZUzh0RmZlQXJQNzkrMjFicG1XUkJNM21JQmo2?=
 =?utf-8?B?TU5aeEh0cDFGYTlzaStzOUZpcUhJaFBRTnhmS0VlM3BYSVpVZkdIdEsrQnJj?=
 =?utf-8?B?QU14Q2VsZnIrdW8xL3R5a2VBRGxKMXVOQUFuQVhENjBoL2EycEdVVTVXOUlX?=
 =?utf-8?Q?dBl868Icf/wCibnSIbeaaiCGKpYrEY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2hoQTlNU3M2NVJMMTRlMitGUTZEaVgzQXgwY1BvQ3Rkay90RWZUNTQvUzNs?=
 =?utf-8?B?UWhUUHNWcnNMZ1FrdVhpaERTWVdRck5saUo1VXBFalBvUUFpM2Z4amlDV0Vm?=
 =?utf-8?B?SFBaYzBmZGdaZU5PRnBLM0FzVytWMU9iejdrdkRyYnBsaVBNbTZGdElOc2tD?=
 =?utf-8?B?N2JFd1cvRkplL3VXMVNkaGs5Rm12bE1ac1NTMko1RUhSNXZYVzZqYlp3WE1E?=
 =?utf-8?B?bzJYeGw2Z0JOMFpGL3BVMzlnUnBjdHRBL1V4b0hSRytpUWVHSTMrM2loYU1D?=
 =?utf-8?B?dStDQnh6cVQ0TU5WZ3RzRlhsQ3FLc1RpSytHcnA1amRXeU9GQzJwVE91cTB4?=
 =?utf-8?B?ZllpQ3Y1Q3cwRWRQekdMVjI3UDVtbjRDdVpaaDErS1pwZDBSZGJNK0t3MUd6?=
 =?utf-8?B?UmNCSVg2YXhLa0k2Y0FkWmVobzQ5czVlaTc3Z2UzMFB3MFpENzdFZDlhdzNx?=
 =?utf-8?B?RFZTR3lvckRlcVoybkthdHFFbG85ZmVrQm5iaW1BNUlaSmUwczF1ei9SODg3?=
 =?utf-8?B?V0xNUzRuRE5UaDNaQTlZOVAzem5BdURnYWplZWwrdG01OVZqMzJkVDRXY2JO?=
 =?utf-8?B?OUsxZmZ4YWRMTDNQUmNhcVova3BpVmhKZEZpdFFVamxNWTFtOUE3TjN2WTJy?=
 =?utf-8?B?a0xWSGFLTWRoR1F6WjFUdlNZVjBaU1dzL1R5SzB3bG5UakxxQjBzQVI5WVRu?=
 =?utf-8?B?SEx0NXF6UFVkNnB1NzREOUxrMldtcFZtQ2l5end0Y3pQRWNNQWZlMUd2TVNi?=
 =?utf-8?B?aENZUzBlVWZMclNZRlhIMGNZN095L0JmM3hwcS9LSEpmdUJPeXpBUk9zV3J3?=
 =?utf-8?B?Wk9acEoreEdaSnpiYk16SVQ0U3FqU2NuaEd5Znh0SGdxTk5oZEdCOHZYQytq?=
 =?utf-8?B?eUYrYk8yTkVoWCt6YUNFeXhBcWdpNDg5cjNmelhZOFRsTTFScFRuZDk4L3FT?=
 =?utf-8?B?K0pWTVhCTDBVNzZhNlpoQjR6RG05MUt5RzlrRDJQRFRZT1JRTjJrMlVvZnhh?=
 =?utf-8?B?L1JIREtXOUc4VHFZQnFEQkRlUDB2MUZVc29wTTR6VXc5MWpmM0lTRTY1U212?=
 =?utf-8?B?eVduY253cnFTSFhybnF2elZGazJIT0FyNTlITm55bytrZG9rVERZdkNRd3c0?=
 =?utf-8?B?WmQwVDNiZHZ0azFhcFlIZmpJeklXbGZEclE4bWZiV2dRZ2xVbURIVFJMQ3gv?=
 =?utf-8?B?R2s2TU9ZOXhYMFJBRWgwa2hMMWhZUjhYQzVDS0VFZWNDVDVhY0UzMFo3TTA0?=
 =?utf-8?B?bk9uWEg4SmdPTmYzRFFoYS9lMjNpcU40SW5kNXBzUHJRZGxWbUh2cEw1YmtI?=
 =?utf-8?B?citJZFQxZ1JNWVZQVXFUZHlUczh3RUFmNEN5UWVPUklWdXJsckZaZmtXRXM4?=
 =?utf-8?B?SDZyMVFXMlByTjBxVitQRXppZVh5NkhpSms3amh2WWN5bGdvR1lLc3hzUFhL?=
 =?utf-8?B?MXNKV29GeW51YkpNWnVqc3FOY3IyRVV5SUtQZ2tUMkFrSm5mZkhlMjBacEJp?=
 =?utf-8?B?K3N2ajBKK1pXY2tEeC9TUWg0dGQ5Uk1PY0doM3o0NU41ZjJxbXJPNUVHTmJk?=
 =?utf-8?B?QWxCTXJleVk2dENkZVRhSjhGSldYc1JDZE9KTFVPbko4eDdyVzhPNk1vRFpw?=
 =?utf-8?B?NXRFbVZuaFdEQVVIS0lRdms1N1lRWDBrdlhFeHlsQnlKdUU2WG9XbThWME1Z?=
 =?utf-8?B?aUFuUHhsZUhPTUdGaTVWMGltTTVIQjhPR1kwR3ZDQTVnV21tbk5KQ0E3Nm1x?=
 =?utf-8?B?NnI4NkJHOXpDM2U4YXVDamVtOWhTQXd4OURnUXZFOFptd3NYaTRWbUh4UVc5?=
 =?utf-8?B?UGN0V252bU55V3V2cnoxb3NSN0lrT0E3NHAxbEFxWEVGQ2ppQ0VrQ2FXRWFx?=
 =?utf-8?B?MEZRS0laenY4WnlRSGhIVFY0ODJ5SUw0d3FpTHRTREF3Q083anJSSTI2M0VX?=
 =?utf-8?B?TUoyMHhyUzhtUGJCeU45cjd1V2lMS1c1d0VTd0pRSkFuWVlpdk5sL09Da3Jz?=
 =?utf-8?B?WERxNmRWMTFZOVRhN3RiczVZS3ZBVmZMbGFzZHA4K2pRNHlBOFlpL0hXZCt2?=
 =?utf-8?B?WEdiWUtIanh2Mk9TR29NU2JJVnhRZTFROFVFNTRTM1o4bWF2azNWNmRKclkv?=
 =?utf-8?B?WEVkbmFpUTk0T09NT002eHpOakhHbG1NSWhFNkFJWG5zektXdGNZMVZ3L1Vw?=
 =?utf-8?Q?2cQkmTYH3LcJfnyjh2QWUFs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E437522C5FB5FC478B4384461B9CF4A3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0563b2-9535-43fb-2b93-08ddb43a8365
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 22:49:16.1627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8xe1RTKyv3ziwLqSw6IPHjDjQVf4lOSg7su4n74TcqYqSDu16lTqa12YwOQBCS/fsT2y6o/GdmlPQlgRHegLFsNuIY2aVqh01bPQ1H1JKeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5798
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTA5IGF0IDIyOjEzICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IFRoaXMgcGF0Y2hzZXQgZW5hYmxlcyBEeW5hbWljIFBBTVQgaW4gVERYLiBQbGVhc2Ug
cmV2aWV3Lg0KPiANCj4gUHJldmlvdXNseSwgd2UgdGhvdWdodCBpdCBjYW4gZ2V0IHVwc3RyZWFt
ZWQgYWZ0ZXIgaHVnZSBwYWdlIHN1cHBvcnQsIGJ1dA0KPiBodWdlIHBhZ2VzIHJlcXVpcmUgc3Vw
cG9ydCBvbiBndWVzdG1lbWZkIHNpZGUgd2hpY2ggbWlnaHQgdGFrZSB0aW1lIHRvIGhpdA0KPiB1
cHN0cmVhbS4gRHluYW1pYyBQQU1UIGRvZXNuJ3QgaGF2ZSBkZXBlbmRlbmNpZXMuDQoNCkRpZCB5
b3UgcnVuIHRoaXMgdGhyb3VnaCB0aGUgbGF0ZXN0IFREWCBzZWxmdGVzdHM/IFNwZWNpZmljYWxs
eSBSZWluZXR0ZSdzIFdJUA0KTU1VIHN0cmVzcyB0ZXN0IHdvdWxkIGJlIHJlYWwgZ29vZCB0byB0
ZXN0IG9uIHRoaXMuIA0K

