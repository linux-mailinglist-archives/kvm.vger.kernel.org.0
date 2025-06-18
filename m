Return-Path: <kvm+bounces-49920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E107ADF9DC
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 01:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CC897AE52E
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03BB0284B56;
	Wed, 18 Jun 2025 23:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YyDL+75j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549A927FD72;
	Wed, 18 Jun 2025 23:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750289992; cv=fail; b=Ft4HFr888A5AHJoqEg+vC4YjPsscWjTEBChXswjYCprlhYULQdoJstDjB8GEjsW3HilEzyAX0RWU8P9WDiVvAeO6JghBInpjY6gcO+GpKmUqT77PTHjHZ2ZyDiEWYGRsxkXF5cquFXDPjBu54SWWd8Pac83nS/Y3tiD8zfYnEJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750289992; c=relaxed/simple;
	bh=LVaDnEySzAl/8zVUqNE24xF99gYUlqjm9HDjO2M2zn0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hGw0/KkLgzBUnJmZXB2ZdSO/s1uIPqNy7/i+hdT53zYQ1x2bxyUvApGgPHUS+Nztseuyu6MS5wGmGmDR1ZEJOptpxOXuH5OkUx01XlqdlOnUfyu4hky8SolJdzrVzZv0UWyYxPSqx3vgNgV2PlaIuP0Zcr+sGBZNTdGpi2F4k3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YyDL+75j; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750289990; x=1781825990;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LVaDnEySzAl/8zVUqNE24xF99gYUlqjm9HDjO2M2zn0=;
  b=YyDL+75j+cFsU3b2bjx93vdMkmJEf9Z6TmbhMIfRzzbv7pQc54/knugF
   a89f3jVdtlStxlD5COEvle3WPsbDYk4p5vtbh05/Hf85qR+TmYIurSzcK
   k4S/9yFCoeE+5VrrAPZeRZurfZc6F2Xgfk7bocej5wpFwlLqktq3bChLY
   o/+MPzRKakfbrSxVTZASq0LStKgpMs0UET159zFlxNTYTj7nfvduXJTuK
   3s7RHzqBm2dJYU7RkC2cqQ3LXaCPgYHt/Z4SrDtTLdulqbcNBYNdxfflI
   MX187NKQG4zC8JEXId2JI/nIDGb6MPbYkFfDns980BvM5fkOjBZwKvrQA
   w==;
X-CSE-ConnectionGUID: lLHEgumVQPuOqAxmWBeMJg==
X-CSE-MsgGUID: oEIOziZIRKibc/5KpAmTXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="63137554"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="63137554"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:39:48 -0700
X-CSE-ConnectionGUID: Ua+FbMeuQ9KakZ3MXBV3ew==
X-CSE-MsgGUID: XDk8JFrwSjGswVwEFydGrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="150913682"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:39:48 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:39:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 16:39:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.49)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:39:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eLvlZ1/v77ZwnYQfQyM5FK1GieRjaMjc8losDq0BbxDw55GU0L2eXmCXtqOwdr4Dh7lw7hKIYJypc7C5WIPBSdNP39OdqV+TiaMDAia6H4AMC4ZMUGFOq7z4QcJF7skUj1sHJC+nmvHLIXSFrn3FHrlDuTgH1MfW5PZaNCvAPgRezXp9zO6k3nsM85CNIVEh+5LM2AwprVXXdGd6zcjtnIQyM7D8ja8v+y99ObgSWUznEmMuvdoCzcnlAVYcX2cSC4zjwH+T7a7hW2ff6RzCb5DUjBTf8B8n1fha5uN3iNTnL+b5/4q+Vy+41QXAZgFW84cVHOK8bOhwBMtzxp4jbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVaDnEySzAl/8zVUqNE24xF99gYUlqjm9HDjO2M2zn0=;
 b=syMddKCFCa+oKqgyhFanKIz8xviNieB1dyAjzfGseclgY51q+YLmrTP8hekL5zapjldu3MP9omLg8f4WYDHbNrX5LvvVrH+F5E1ia+PxrMh7vjsYgzcM6oFRdUZNa56wqq5iUqQUCM7IJ1DyKRF2FobjmpfcyAIGZAfFlAPZDlOhYrC5l8jI1no15Os77B/CmDVNAJqORH030nGfB7xugZQFBne6nbCkhHUIlxIabzohVD7JcGwEP9N2qzpPpCqMu/yphBnbkUox+QKCVr4SdtCRRazeh6splHVnBpOS//h+dFt+jmfvO5tcXmCv41ROqkvKkHf0UfR8Wn9QTt1e4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB4935.namprd11.prod.outlook.com (2603:10b6:510:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Wed, 18 Jun
 2025 23:39:10 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 23:39:10 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Topic: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Index: AQHb4Em/xH1txe69zU+wjMA9RpcOPrQJjpYAgAAEL2A=
Date: Wed, 18 Jun 2025 23:39:10 +0000
Message-ID: <SJ1PR11MB60831B85840BD194CBFA6CBFFC72A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
	 <20250618120806.113884-2-adrian.hunter@intel.com>
 <32c01f03f4971a76f1b7ef3634ee4e6c0ee5d899.camel@intel.com>
In-Reply-To: <32c01f03f4971a76f1b7ef3634ee4e6c0ee5d899.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH0PR11MB4935:EE_
x-ms-office365-filtering-correlation-id: 5a334998-e65c-43d4-c6bc-08ddaec15302
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VHcrcXFLdGJYRk80MTNBVGkveExqVm5QUVM0OTJSVGd1ejhOK3B6dTlaKzFr?=
 =?utf-8?B?QnRRUm9USWZ3U2o4TGJLWDJ4YWxaQ3I2VE1uYkNxQTNuMEJvOWpQQlVUNy9w?=
 =?utf-8?B?V3k4djZsczRldFdBbEo3NDVwL3dsZ3BMU1E3cTUyS2xJcGwrK2FVN2VZa1J1?=
 =?utf-8?B?WmpVWC9qUk5ETVE4N3FyRUNzK3RtNXFaR0NSb3J4blRUaWMzMzdGZjFaWEtv?=
 =?utf-8?B?YzNHdmcyTTJxaXhsM0l5Q3R5bytuU1hJZTlva3ZlaEp5K3dDYzRrSXFEb29K?=
 =?utf-8?B?VVlhMFRDWnpXNDdCR0hoYlNSeHhIc1Vxa25mSnNWNlIyMzdLWitGWmZCUWhH?=
 =?utf-8?B?MisxY1V3cTRRTnZITHJvdE1WU3A4czRaSldRaVhOSHJUeTdKZnlYaHVCMGZJ?=
 =?utf-8?B?Q3JoYU8wL1cwclNFd3FtZUhqVkpOMlZBenNsWTlWL2Z5VW0yT05NOEZMQmtq?=
 =?utf-8?B?YlFNS1h6aTFzWUhzZ3lRSllVQ2lib0ZzMG01bkE3K29CR1hySFlRZVQvcjFL?=
 =?utf-8?B?UVNuWE1FcVZHbTdYSWZBTmNuQTBFcXJuQVdodUFCeHZPWHNYQ29zK0JlVjAx?=
 =?utf-8?B?WVJOa2o2TTdqNVZTZWVLbEpiTi80UGpVcktmVURZTnVESjMxOTJ2L3ZVMUhl?=
 =?utf-8?B?VGw3RVovWmZzQklJZ3NHV3NOa3ZpZkF5U09pbW1RVzY4dDJVUHc5S09Qd21G?=
 =?utf-8?B?bE0zcG9mU1F4VHlCZW5EK2R3cDc4bmhtNFRlbzRRRVRhaXFyS090THhvTkVJ?=
 =?utf-8?B?UURmTDJ5dUhuSGQyRDNZVFdhVHkwZHRDMzQxQnYwMDRxREtyRmEwTU9sYlls?=
 =?utf-8?B?ZWYyK1kvU2JEREY2dFB6N2p3R0ZYSGxVT3NCSDNLTTBUYjBzUXhmNVJ2akx4?=
 =?utf-8?B?UXlhUXVDTm92aVVRK2ZZenAzK2trcXI0ckRSdjE2M2dnYnlIZjUzTENSRHVL?=
 =?utf-8?B?eW16U1JIVU5EWjBaYW93N2UwYkFIM3VldUg2dnhSV3JjUW5ZZWN0ZXZMSyt4?=
 =?utf-8?B?YUU3Z2xrUXpwNXJFV2d3T2hOaUJBMzR5L2E5b01LaFIveHhwT0puc2FmN0Nu?=
 =?utf-8?B?R1NWZU9pWk9meUtYcEZQdm13V01LZDlnbXFyNlNNeEJpZ1VPbVhHL1daSHBE?=
 =?utf-8?B?WUJRbmIvdGNYcThyYlNGcnJtb2wvcjUzYUs5S0FkYnYrQXUyZnY5b2NibHBo?=
 =?utf-8?B?ajRBd2R6SHo4eXB3U2lrcHBta2hpeVVtZVBWcnJOL3ZwQlVUR0Z3aVVYTW1l?=
 =?utf-8?B?MlJOclY1ZXhOWTdsUW90cFB6a1RtWm1sN0t4SGxWY2Z3RGFGOE9NejhmQkQ2?=
 =?utf-8?B?eVE0ek9heE9OUXdNWU9iN3RDZVR3eXhqbmEvQlo4S2lJUnpCTTlrTXBQQWpx?=
 =?utf-8?B?eng0Q1grMjgwRllVdHJ4R3JaTTN6TlE1U0FDQUU1b1ZZa0Z6elh1K2tRaDhp?=
 =?utf-8?B?VklLRmJkUU9MNkFXMWpUQWNWYmVhUDlhVmRYTCtPRHF1RWxweU9pdTNnUVRZ?=
 =?utf-8?B?UzgvQVNJYzhONU03ZVIzMWNrU0pvSUlKSG1kLzhYNVBCYVN1WXlNL3BiL3VV?=
 =?utf-8?B?aVVWeW5nb21ZQkFjM2lzWWtZZ2kvbjFadFZxL0oyMEUyY3RMcVRPZmZBY0Va?=
 =?utf-8?B?ZGI4OFlWTzY5SDZuODRBVDhHVjlqcW5rVXp2SzNiRHFaUXkzR1lvRjc0Tjhh?=
 =?utf-8?B?NHorRFVYZ0hTWGY4ZnN5WTkxNnRmVkhKM3E2aFNqNU1GSjczRHY2NXAzSHBj?=
 =?utf-8?B?T1JZd1c3VzAxc3d6VWhxVFd0Rk1nSTk2RTA5clcxRWtyTVZBcjhZNmcwNDFB?=
 =?utf-8?B?MGRjaFZvMGU5RWlJb0VyM0RZeG5XYnhPcmdHcGN0ZnZzNndSZ3NBOGtQMTRh?=
 =?utf-8?B?STc2dXZwbEpSdXE1M3FFZWRVM0hBOFJGbjRFMVh6cldRRXpSM01sUHJ4Nk5y?=
 =?utf-8?B?Mm5MMVY3WHlURlEwci9WaExXcnJnZktPc0lUOTZrcFNIam94UTlXQkpMQVBF?=
 =?utf-8?Q?iO0fesh9I/J8v4zlbEKqgJY9J+mpnQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0N4RCt6MFNENWVzMWNvVDZhb1VUL2p2Y01XL2VadlYxWFZHbmZaR2o0Zkdy?=
 =?utf-8?B?WkFoempRL2hJLzBVMFZ3WFRBS3NkNmtwSTVvQ052MHFQV29iZnZxRFJ0c1RT?=
 =?utf-8?B?QWZLODhGL1pNWmlaMFppVXhLWkdVK0U2bzR5SEl2Qm05Wit6c3hCZHA0L1l4?=
 =?utf-8?B?d2hUWDlaaWtjTmRJQWFFSnJvTXl5aThNMUczdHA4WmNpQWRpdXd5Umx2cHN3?=
 =?utf-8?B?UjN1MDVMSDlyckc2eDZraXhhdEo2eG9lWEJITkF6b0dZYStTZnM3YlJGNHhT?=
 =?utf-8?B?aWFUVis5MXN1RjRIN3owbWhsM0dxdDBMUlE0S1lBWmdjNWF5YnVhWERyc3RS?=
 =?utf-8?B?dFIzWWgybGp5bHl2Q2NDK3dRQTM5RUhTd3R6Y0phRmt3SDk3ZVlLb2Q2MFhx?=
 =?utf-8?B?dUZ0MDFsa0NYRnNyc3FuU2Q0Q2ZtYXJ5bVRRMU9OYzRsQmdUemdzWE9kSjZp?=
 =?utf-8?B?aVc0ZGt1WWpPa3pMVldwR1Jacml6V3AyZ0t5dW9sallFamJHMFN2ZWd5eWdX?=
 =?utf-8?B?ZFlYRVNPSTRzSHN3V3JYZEFocUJzaWdBLzBRWm4rT2hKYkpKNjJtYVNSVVQ0?=
 =?utf-8?B?WEhpSm9Rbmh2YmkvclB5WXJxYkVhTlJxczdnOStvaW0xMUJsSlRDazZQQ21Q?=
 =?utf-8?B?UjZRWHFSZTdQRDBTaXB1dEdsOEh2MlM1Y1Jpb3hFSzc0ZTkrVVJLL1lDZkY1?=
 =?utf-8?B?KzhwVUE4dkI3K2lOM1E0eWkzd2pNeUNITEUwOTdUcUtqMVdtMGxydjI1THM3?=
 =?utf-8?B?Q1U5dkQxTTJOZG53ZFVRYXdnakxXdjd3UTRTaEl0NkxJTWxLRk1nQnhmcG9P?=
 =?utf-8?B?YXpvSU45bngwcC9qL0Q1TGM3L3FqUHVVRXlUeFZNeWFNT2hkSElMbVp3cUNQ?=
 =?utf-8?B?eUdkQldVbWFoRktRVGpQQXdYRjN6YUJaNFE4MTdTWHBZVTlNRllGdzNwY1Bz?=
 =?utf-8?B?QkJCS0hzTitjVkZpbHFQV2NvTUI3ZkQ1bk9HeGR5YXRmVU9Jc0I5cUdrVzZh?=
 =?utf-8?B?c0NXdkVOTzRQMTFJdDFINW8yeEp1ck1BYzRpWXZBZFE2RGRVekN5VHhwYTVr?=
 =?utf-8?B?bEozSDRKVzFSNGl6QkFrT1pEZUVPSkF1VjV0YXZtVTN5OXdwMzFBTDlXeTcw?=
 =?utf-8?B?ZGlrd3dQdng5SVVyeEJWbi9iZGw0emdmdGFoaVhUdmVJaThwdURIMVE5cWxU?=
 =?utf-8?B?MVJ6RmdVUFlUWDZEeXZGay95SUVPdks4QXdMd2JlOU5QbW85OGFDRlN0bEht?=
 =?utf-8?B?MU1SZmRaZ3dFLzdLbVpwU1pQTzVCMmZZbHFmMGRPWHIrdWhWanl5R0xzSzhr?=
 =?utf-8?B?SW9lUEI3cG81NVNBc0JnWVFnNWRobzhkay9WeG9xRzZRNmhlR3JvcTJYcEZT?=
 =?utf-8?B?eUFiTEdORWRmMUV0T011OXc5NlVMVUYyZjlxMmRNa2hGZ2xSUmtYbkpqT0xt?=
 =?utf-8?B?eGpIVjk3MlhKVWU2Ump2ZlFTM1VOQlpNVWlZSXpUUmUycWQ3c293TGE0b1JM?=
 =?utf-8?B?T00vUkU0eUViT2VQSXhPTVVVYllCcFdPWHJrZmcwaXRzZWk4WVRmbzZNT2k2?=
 =?utf-8?B?bnNJOWtvYlpMZ09qeURjVjlqS0k4K1YrSGF3MXhQQmRtd3FHSzBRU0gwL2JK?=
 =?utf-8?B?Y3M2bFBQTFFVRUc1VHlLY2xZK3hpUytKS2NWVi84cWZNTEJML3Y1Wm9mNFpk?=
 =?utf-8?B?K2RBbG1Kb3FheVl4Nkh2eDBaMzFTTnFYTC8rUEZUWEhaa2hnOElkYVROeFBv?=
 =?utf-8?B?eDlHeDJueWRjNzliUzVSeitMcWJ2OTJ1WnphM1EwQk5tMXlxajFEYkNZWUpH?=
 =?utf-8?B?MmoxaiszT0VHcHpIb3JHT0d1a2pqZVhLK1E3MFdaeTRpVStOQ0xCei9nbWMy?=
 =?utf-8?B?MXhuY0VWU3BFUzJTZVl3dnVMaGEwOS9BUlZXdTg5MlM2aFZNZml0YUNCS3Fp?=
 =?utf-8?B?YktBZDJ6czNFRUpvU0tEenM4K2lkUFJQL0ZVTnFBdnpCTXhUT0ZZWTFvNnNi?=
 =?utf-8?B?NUtqWWdqMHZWeUJCUnBteXFpdDJFYzVhaGZzcG5ic0lYQTNLdmFRVWcweUxr?=
 =?utf-8?B?T1p1TjVqTnpqSEROMkIwTUpxODM0VnhtVmVjb0VJcHhBNWNORmF1MU9mNCt3?=
 =?utf-8?Q?FvFuKDGTVuJ05g3xtyyuC/2So?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a334998-e65c-43d4-c6bc-08ddaec15302
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 23:39:10.0831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a2y3LHjJX914fJTETSwzMQxR92+QeVsbdzc50MEVMzfHU4qbPwtlLcS3b0/qwJmef5uy/D3/cf7oHZuF9iuv9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4935
X-OriginatorOrg: intel.com

PiA+IENvbW1pdCA4YTAxZWM5N2RjMDY2ICgieDg2L21jZTogTWFzayBvdXQgbm9uLWFkZHJlc3Mg
Yml0cyBmcm9tIG1hY2hpbmUNCj4gPiBjaGVjayBiYW5rIikgaW50cm9kdWNlZCBhIG5ldyAjZGVm
aW5lIE1DSV9BRERSX1BIWVNBRERSIGZvciB0aGUgbWFzayBvZg0KPiA+IHZhbGlkIHBoeXNpY2Fs
IGFkZHJlc3MgYml0cyB3aXRoaW4gdGhlIG1hY2hpbmUgY2hlY2sgYmFuayBhZGRyZXNzIHJlZ2lz
dGVyLg0KPiA+DQo+ID4gVGhpcyBpcyBwYXJ0aWN1bGFybHkgbmVlZGVkIGluIHRoZSBjYXNlIG9m
IGVycm9ycyBpbiBURFgvU0VBTSBub24tcm9vdCBtb2RlDQo+ID4gYmVjYXVzZSB0aGUgcmVwb3J0
ZWQgYWRkcmVzcyBjb250YWlucyB0aGUgVERYIEtleUlELg0KPiA+DQo+DQo+IEp1c3Qgd29uZGVy
aW5nLCBkbyB5b3Uga25vdyB3aGV0aGVyIHRoaXMgaXMgZG9jdW1lbnRlZCBhbnl3aGVyZT8gIElm
IGl0IGlzLA0KPiBJIHRoaW5rIGl0IHNob3VsZCBiZSBoZWxwZnVsIGlmIHlvdSBjYW4gcmVmZXIg
dGhhdCBpbiB0aGUgY2hhbmdlbG9nLg0KDQpJdCdzIHNvcnQgb2YgaGludGVkIGF0IGluIHRoZSBT
RE0gVm9sIDNCIEZpZ3VyZSAxNy03LiBJQTMyX01DaV9BRERSIE1TUg0Kd2l0aCB0aGUgZm9vdG5v
dGUgaW4gdGhlIGRpYWdyYW06DQoNCiAgIlVzZWZ1bCBiaXRzIGluIHRoaXMgZmllbGQgZGVwZW5k
IG9uIHRoZSBhZGRyZXNzIG1ldGhvZG9sb2d5IGluIHVzZSB3aGVuIHRoZQ0KICAgdGhlIHJlZ2lz
dGVyIHN0YXRlIGlzIHNhdmVkLiINCg0KTWF5YmUgdGhlcmUgaXMgc29tZXRoaW5nIG1vcmUgZXhw
bGljaXQgaW4gZG9jdW1lbnRhdGlvbiBmb3IgbWVtb3J5IGVuY3J5cHRpb24/DQoNCi1Ub255DQo=

