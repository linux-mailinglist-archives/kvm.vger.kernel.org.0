Return-Path: <kvm+bounces-26437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC32974732
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EA5E1C2555D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3DD1E868;
	Wed, 11 Sep 2024 00:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bzh17peb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225F01946F;
	Wed, 11 Sep 2024 00:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726013858; cv=fail; b=Wj881x+2mQizr0dBma1yiDcSt3A3mOOsB5CbdCU29Xv4Zyxv99vt4sO0OWrNyHgm80YMiUzhiD14jGJiJDAGkia83sVZczQAJbpb8ZpNcBr26g6PlXqJ4jDDiBAql5xEuvBLKuNsf9/GA8EuY9XbXvjmTQqWpFvizMUgEhKiq5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726013858; c=relaxed/simple;
	bh=5eSla+TxsQx4Jh91IHw5Dt1kwWqaxPCeXk1IQXJYhX0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tr6ltc8Bv8/isoMvDy3udlFbYNRsJr2I78NGuGIB3tws+qoL8em00EBFMY1FH36RQbxwpnUdaKU06mwn+mbM3u9/7jkovwXZtm5SGBCGCl5sguMzByfqz+A6UBVnqsXLKABRQ9VHczETfW+V91xaeul9b7D20Go5Z22WCuZawng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bzh17peb; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726013858; x=1757549858;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5eSla+TxsQx4Jh91IHw5Dt1kwWqaxPCeXk1IQXJYhX0=;
  b=bzh17pebo8S4JohFIBCnI8nQlRRCM4f+4cfWt1s/5yFwRM6744ckBPJv
   AiztcF+CpqhD3oo4t80k85cZ9RWmHF8TxLvz3G0dvTWXK+DhAf1nt1RjJ
   qseQVqSwCE9e6hGkk8b5LjnwL3zuHrVf1USAxcZz8GOrpfzD4+he5MJ65
   VyelgCSdw9he+Lnsrox0u1cNZmITDDaaaTe3VB5t13UXM691DDuwhkwlO
   oZmyoPhB+/VGai+ULHxlKP6C1IlMLAYb+FpWdbeIId65BuN1R5NSWRF1S
   zYCjFby3Zva4GXEcTRVL8XOWQgoiJ5k2SLEq36NscVpYqIwX4IF3SgLu5
   A==;
X-CSE-ConnectionGUID: QLpFaKO8RFuUnZSuW1HqrA==
X-CSE-MsgGUID: CDQVG8vGRMSmlRJXCdk41g==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="24731370"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="24731370"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 17:17:37 -0700
X-CSE-ConnectionGUID: fJB2JJduT1SUv0GUyG8bOg==
X-CSE-MsgGUID: 0imLl98+TI2fFxd1dRHhzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="67148397"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 17:17:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 17:17:35 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 17:17:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 17:17:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 17:17:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n5V/+GlItyn+gnjWoxI5dn+w3Ghi6akJofXhwLyqY8uaVpjCSSbp5fQPL+l4tgXoZrPtMAQWXa+RkaicDBYq8eClkFZ+O22XpgX8f1VVaSnTI1OWlT7Hpm+IwIDF+aEKQAFDgVz5y6XMPr1RsCNKEIc82Iwky7rd45a5+cPHEfaH7dMO2Bo5n7FrLYZW5mqDTGb/KbSKT2hLIF6DirIQmM0+lDWYPJfiZyKZRLD328QVsykEsupw92GTB/4sqhbCgwJduVG5wGeA6iqtTJJIrwaGiIXf/A7cO937mM6D0zpgqNOuYgPW9waON8Keorx2IgzMSf0qPz1NemrW3ot82A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5eSla+TxsQx4Jh91IHw5Dt1kwWqaxPCeXk1IQXJYhX0=;
 b=Dv4uGVNcXkNcXIM9rQiHT8viDi33k3pN5+QbAy1I65LBoAAfSTh88hmuh2FNN1If/6hxhdeCdi73MwmOyhCH2LQMheWc7+x8f5+NWQeZsn/V2l5HsfSW0GCKeoRGgN8xaZynwD0I+bTSrwcqdGWWA5u3sgDdr//RRaHcN9wT+wVN3A8LyLhUYfATw6pZztSropmtVghsHih740FiEFCEI5IUXDMpmbANcQ5/cY7rIb8CNgtpdAZA1qfT25RBWehcRQSCQ+W48cZpHoAKHtWMES0KSybMcZvkLT7hKoPybzRmNyiPKHWIqmYGtX2iE2pPMz3JeB7P/WVW9q4JHWWnBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4866.namprd11.prod.outlook.com (2603:10b6:303:91::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Wed, 11 Sep
 2024 00:17:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 00:17:32 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/21] KVM: TDX: Handle vCPU dissociation
Thread-Topic: [PATCH 21/21] KVM: TDX: Handle vCPU dissociation
Thread-Index: AQHa/ne7SX1xh76jUUONLpUuqlnIa7JQ4BCAgADi/IA=
Date: Wed, 11 Sep 2024 00:17:32 +0000
Message-ID: <67302be30e3411df8179ff87b78d62e6762bf8b6.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-22-rick.p.edgecombe@intel.com>
	 <7fab7177-078e-4921-a07e-87c81303a71d@redhat.com>
In-Reply-To: <7fab7177-078e-4921-a07e-87c81303a71d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4866:EE_
x-ms-office365-filtering-correlation-id: 12e6de64-dd6f-4a2e-393a-08dcd1f72125
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZUwrTzFZK3NTdklwV0VzT1B6Z1E4aG1vczdQTUE5aGNyOGVHVkgvRjl6NXJQ?=
 =?utf-8?B?Q0M0dXJQYkJjWkdQVmdaNGdPWWZsN3JlN3lDVGdnZWYyQnkveWRzcTV2T3RV?=
 =?utf-8?B?SnNRVHNwSXZVQ0RzcXVsUmhTVmEyNTJyS0w4Qzl5N0oxQWZiRFRxN0txdElL?=
 =?utf-8?B?K292eFFvbzhWOExiVFhCaWZhZVUzM3Y5dWRXN05obmR6L0c1NXJ6OENjTnNr?=
 =?utf-8?B?T2JYZ2JEaVpOcVJHZnpQU3d5ZlZzTnY1MkNHakp5bkR1bTkxdE9KeEI3N3FD?=
 =?utf-8?B?U2hXN2JSMlVMekJPWlJSNGI5cmRjNEVVSGVOTWc5SDEvd0V3WjdTSEhtSndC?=
 =?utf-8?B?MmV6Vml3VWlMVFppVmdrRWFnZ0lhTkRSUUZuaDBKZEs0a05pc1BoY056UlA0?=
 =?utf-8?B?TzlqUXVrUDc1MHhpYWtpQnVSUnFRdmxHQk5BcytmU0ExWDFOTXI2eVUvbTdR?=
 =?utf-8?B?dFNuNEhHR0cvUEJXUW5RdTFKYXJaOHhUWjIvcExIRmVvaG9JL25yK253Tlh3?=
 =?utf-8?B?aHhVUExEcGQ4Z3c4cHQrMHZEODZGRE9OaGtPV2p3YTQzRkdXY1MySSs0WmRH?=
 =?utf-8?B?TU1oaTlydnV6azJUZDBwOHZoamJwSDRSTldJQ1p1NmxQa2kxdG9TZmpqSmR4?=
 =?utf-8?B?VWx6WXlVRE82OC9RUEZ6QUtpWnRIVXlpaG45a0VxNlZCcklOMS9LeFU5M2Fl?=
 =?utf-8?B?amhCK0dOYlBmSXh5UnVOMVU5R0lRaExDZjcvZVZMWGpaa1RWSHdZZHpHdW0r?=
 =?utf-8?B?V3RIcUZlSkhBVndoYS9MRnZOeXB4NzhSbXFFdGg5cHVtRTdIUlBwWkEyTUhn?=
 =?utf-8?B?M1FiM0w2SzlWLzZUdzhVTnlrVXprRXZORHJuS0F4S1VQNjBFczFWMFVtTTlL?=
 =?utf-8?B?L1VqUHBhZ2x6ZGRMSEJJUThKL0ZVOUtJWGtaNzBneG1vMzVtREl5N0thWFY3?=
 =?utf-8?B?NndYMDBrSWJUaEt1VHhpbzlaNkpGUEVGZVo0TkNPcFI1R3dzS24wdVNjTkVv?=
 =?utf-8?B?VEhGT01SUU4wYWp2WktLeGMwYWIvdGg2ckJ2NGNlRkVBZmlwcXlkUElha2du?=
 =?utf-8?B?NWp6V1RzU1lsSHNpenhoZmlxVHh2R0VmMy9nWDU0ampBTXFqdjRIeXJWRlBN?=
 =?utf-8?B?U2Q1VjE4TlE2UG1LeDJHb3lLNFlrbUpQWEQrRFozcklaNVgvNUxtcG9BZkxs?=
 =?utf-8?B?eXRaZEpnNWltaW9PTWZkc3JjVnRQcGNnNEozQXJVSjk0RytQVTJpMGIzakY0?=
 =?utf-8?B?KzhDMGVudHdFRElURy9jTFpFeEdGN1hmaUFibkpldTZkN2lUaUxhRjRrdUUz?=
 =?utf-8?B?ZVo2eEZRd0p4cU9VVC9wbGhQdG1QTHNnWlp4TWZXd3ZUUWd5Y1V3RG50amta?=
 =?utf-8?B?SHJGdjhtZ2lTV3BmMW5CbDdhWlhxd0FkL1Z2K0hmVVlMZUozYnM4NHhnZy96?=
 =?utf-8?B?bFlVVXNKWk9ZWDNmVnNYeXZnbjhCRlFFUGN0djFuNklkWjE4SHdQM2VyL2h2?=
 =?utf-8?B?VVIxam1LRkpNWWljRm1nRzFqdnYzNHAreFRZQW5rdmFGY1lhQ25nS25KbkVF?=
 =?utf-8?B?RjJack9lUDVzNzltQnZOeVFPODVqcW13QWh1dHF1Tm5LalNBYjdvSk1peW5V?=
 =?utf-8?B?Nk1KT0s3bnZkTWVzd3BDRFN1enJnS0c5TlhnWk8ra2JYR3l0RWExcmU0SkJL?=
 =?utf-8?B?bmdtUVZGZXE0TGVoazViazBia05KVUVGcWkyRm83WmRyendMR3dZZU9wWEdQ?=
 =?utf-8?B?cnk0UG1UUUtVU1kwcUJXdkgxYko4cCtMRUc4UjRzaEpNbXkvbkxUckNTejhp?=
 =?utf-8?B?VjFPWmNKM0tFbk00NWZxYVNoRjhhUGp4MHFoK1cvUVJoektobXV1RVlDOG43?=
 =?utf-8?B?S25ZMzdSUncwczJnMnNiMjlPM1ljbmhBaU9WRUdIbWZhWFE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVVaVG1qcXhkclVLMlNIelkwbFJKczdueVBkZktTSXEzTTN2bWl5Sy9RTzlo?=
 =?utf-8?B?RGdTa2srY2VYK3ZDaEJNMFNQT25pMWdERGNNVG8xY083M0s3RVFTVjAvTVh0?=
 =?utf-8?B?N21DRGowOUNlZ0creU1keVBHOHZpV2g3WnFjdUtqamxEb3drVExSNnU2c2Vz?=
 =?utf-8?B?cFhIK3FKOWo3V0dpQ1ZFSVhrR0UxeTNPS3B5YnZta1R0bE1vQ3B4cXRkanp5?=
 =?utf-8?B?MndZa0I2Nmt6YUhmbXp0REI2R1M1Ky9QQW9aK3NPcVNWYnFZSWZiSk1zeStn?=
 =?utf-8?B?ZmhBV2FCWWxqOHE4SXVteE50Y1ZCc25tYnN2TEVKb2dvOXcvSW52V2ttQ0d2?=
 =?utf-8?B?VGF2emgvSWloeDlZcDQ3emZPRVcvdFpSK0hOVWpSSEFGNGVaaTJBb0tiU3di?=
 =?utf-8?B?dnR0M1paUHllMXRCZ1lQWXU4Z2RtbGFDNmxRUVVUSSttMzZqRnZ4QSs2T0RC?=
 =?utf-8?B?OHV1c0U1WkkyK25scVhvK3BFcmpFcHdJUncxVlJMN0VwS05Wc0E3amw0T0hu?=
 =?utf-8?B?YnJUbGw4VUp3TXlobElhU1MzZW5hRkh2ekZPNWlKUDYrcmNaSHlqb0c4YXpQ?=
 =?utf-8?B?RzJzcHh0SE1TMldONXhubTVTcWV4WHhCRnZ3a3dNL0gvdHB6TjFjR3Y3ZmJK?=
 =?utf-8?B?emVwVzJIa3VYMDJHcU1iSTF6U1U5cGROV2RCRnM5Zmt3bnlMbVRpRzJqQVNI?=
 =?utf-8?B?Z3hNTndLZXRoU0ZPZVRUK3VBVVF4YnRHM1I5UzNNQld0S3dzT2dZS0UyOE5P?=
 =?utf-8?B?TjdKdEdlRENwYTFzRzJNT09YL0d1dkc5QmREV0U2RmFKMDFsU2lNSm42RGFn?=
 =?utf-8?B?REtmN3NXZXpVVUp6cUtoN3djZlk0UlQ3RkVoL1BUWkI2R0ZCaUh1OEdDdCsv?=
 =?utf-8?B?SUN2QVE5OEFrNktBMEJma21RdXZ2K3ZEREZLdFV0d0x6NTh3YU1tV055dFlR?=
 =?utf-8?B?WVBWWkd1Z2dvSjU3a0JCVmNiUkJtaUVwOVZpRGNuNEViYWxaNy9tTWVwV1BE?=
 =?utf-8?B?VTg3d0h0S3JkaEgvM0NvOTUzSWFRa0RCS3Y1aGZLZ0x3OGFhc1hTYStnYk1O?=
 =?utf-8?B?VFkyTElLenRQRDU4SXFsWnFQMFVzdUhjN0JyUmlsVjgyRDhGMUphR0xBTkk2?=
 =?utf-8?B?VlRZbWlyaHE0MWNzdENNcFEwTTl1VFd0VUZpTFdQaVVHUm93dzN0OUpPYnZX?=
 =?utf-8?B?Mkt3NVl6QUR5dm03K0ZONTcvOGRTVXlmbEpld3hDVUh5UTBPRkJVdUd6bWVW?=
 =?utf-8?B?UERGNFcrUUZwRTQzSlFWQ3YvTEw2d1ZLeEorZFBPeVRWaWU2S3padnhHQisw?=
 =?utf-8?B?dFozTUppN0JUeFc5dnYxNFpmUHIvdUdyU3hxVGlheFVEVWlSek9GL3dyNTIr?=
 =?utf-8?B?RlplUGpZQ2VmbHB5SGNiNlltMG8zZmpSUWtJR0oxVHJzL1pHQTZueWVnYU5I?=
 =?utf-8?B?V3I3Z09DMFVqYjM5bm9HNll1SzZTRmdCRk5ndkx6YTBiT3RxeURpbG15TDBl?=
 =?utf-8?B?U1Z4V0Z0bjFJc2tORnNna1ZxM2FvL1BKcjFNM28rcFZrb1UzTVZnb01RTlVh?=
 =?utf-8?B?TFF2VmFtZEtTRUt4TkxIem91ajZ3OFdKbWxCQ1ZWTGZ6WWpQeTd2TnU5ZVk5?=
 =?utf-8?B?Wm1KQXV5cDVpVVpNeG5nWjh4eEtHMEV3Tm4ySzBIa3YwNmtRRjV0czY4Z05H?=
 =?utf-8?B?dU1qT1ZZRVVlRFFHdjZVR2Q5SExObldBYjhvdVpkWFl6V2ZTZjVLOGNtckR6?=
 =?utf-8?B?cXNFeGYvN01RN2pPMi83SzdJUFdMTHNkUHNkY1JEVGpQNWNtSmdBUHl2VHFj?=
 =?utf-8?B?NVBSRVJlNHZxY2FScHMrbHNrTEQ3aUtjQ1FlTlFlTUFORW5rQjZqY0Y0YXlE?=
 =?utf-8?B?SkRvRzdFYXZoYzVmM0hRS2RpREpZZ1NuRnMrWWcxWEI3VlorRTZQK0swYTlp?=
 =?utf-8?B?WG4zbndndjc4bHlrMEE4NUZJeHh5aENCOWRDM1lzeDFqUGJDOUdJZG1yMXBD?=
 =?utf-8?B?U3BGdGxLcitaaUUyNHNWQTZSQkdpalJvSlVQbHdvL0dYRlA1UXJqaXBpdk82?=
 =?utf-8?B?MUY0enVGakFzeUk2MjFCWjlEY01NcU1URVVhSVEzNk9zdTRyLzV6ZGNuSHFY?=
 =?utf-8?B?UUQrbXYvdTM0RHlYNjRXTGUwbDdZVytySmdvSm9sMEFmcU5QaGJQL0tqS2lH?=
 =?utf-8?Q?YR6zY9N1j1jiwGWO7f79dYM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0EF82EC3C9ABC498C4C72BCE508DF5E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12e6de64-dd6f-4a2e-393a-08dcd1f72125
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 00:17:32.2585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HoHjaotoD9RmwR0kpXD3/Zr1HFU2QxHMh3YCnNh+pPgAmGA3kUcqqzKPAAENcl+UlvBNuYXuId3fyn374pNZNVN6rmgtm+WfgncsjOUP7Io=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4866
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDEyOjQ1ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiA5LzQvMjQgMDU6MDcsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiA+ICsvKg0KPiA+ICsg
KiBBIHBlci1DUFUgbGlzdCBvZiBURCB2Q1BVcyBhc3NvY2lhdGVkIHdpdGggYSBnaXZlbiBDUFUu
wqAgVXNlZCB3aGVuIGEgQ1BVDQo+ID4gKyAqIGlzIGJyb3VnaHQgZG93biB0byBpbnZva2UgVERI
X1ZQX0ZMVVNIIG9uIHRoZSBhcHByb3ByaWF0ZSBURCB2Q1BVUy4NCj4gDQo+IC4uLiBvciB3aGVu
IGEgdkNQVSBpcyBtaWdyYXRlZC4NCg0KSXQgd291bGQgYmUgYmV0dGVyLg0KDQo+IA0KPiA+ICsg
KiBQcm90ZWN0ZWQgYnkgaW50ZXJydXB0IG1hc2suwqAgVGhpcyBsaXN0IGlzIG1hbmlwdWxhdGVk
IGluIHByb2Nlc3MNCj4gPiBjb250ZXh0DQo+ID4gKyAqIG9mIHZDUFUgYW5kIElQSSBjYWxsYmFj
ay7CoCBTZWUgdGR4X2ZsdXNoX3ZwX29uX2NwdSgpLg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIERF
RklORV9QRVJfQ1BVKHN0cnVjdCBsaXN0X2hlYWQsIGFzc29jaWF0ZWRfdGR2Y3B1cyk7DQo+IA0K
PiBJdCBtYXkgYmUgYSBiaXQgbW9yZSBtb2Rlcm4sIG9yIGNsZWFuZXIsIHRvIHVzZSBhIGxvY2Fs
X2xvY2sgaGVyZSANCj4gaW5zdGVhZCBvZiBqdXN0IHJlbHlpbmcgb24gbG9jYWxfaXJxX2Rpc2Fi
bGUvZW5hYmxlLg0KDQpIbW0sIHllcy4gVGhhdCBpcyB3ZWlyZC4gSWYgdGhlcmUgaXMgc29tZSBy
ZWFzb24gaXQgYXQgbGVhc3QgZGVzZXJ2ZXMgYSBjb21tZW50Lg0KDQo+IA0KPiBBbm90aGVyIG1v
cmUgb3JnYW5pemF0aW9uYWwgcXVlc3Rpb24gaXMgd2hldGhlciB0byBwdXQgdGhpcyBpbiB0aGUg
DQo+IFZNL3ZDUFUgc2VyaWVzIGJ1dCBJIG1pZ2h0IGJlIG1pc3Npbmcgc29tZXRoaW5nIG9idmlv
dXMuDQoNCkkgbW92ZWQgaXQgaW50byB0aGlzIHNlcmllcyBiZWNhdXNlIGl0IGludGVyc2VjdGVk
IHdpdGggdGhlIFRMQiBmbHVzaGluZw0KZnVuY3Rpb25hbGl0eS4gSW4gb3VyIGludGVybmFsIGFu
YWx5c2lzIHdlIGNvbnNpZGVyZWQgYWxsIHRoZSBUTEIgZmx1c2hpbmcNCnNjZW5hcmlvcyB0b2dl
dGhlci4gQnV0IHllcywgaXQga2luZCBvZiBzdHJhZGRsZXMgdHdvIGFyZWFzLiBJZiB3ZSB0aGlu
ayB0aGF0DQpiaXQgaXMgZGlzY3Vzc2VkIGVub3VnaCwgd2UgY2FuIG1vdmUgaXQgYmFjayB0byBp
dHMgb3JpZ2luYWwgc2VyaWVzLg0K

