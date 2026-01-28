Return-Path: <kvm+bounces-69317-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Yp8PIrN9eWmIxQEAu9opvQ
	(envelope-from <kvm+bounces-69317-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:08:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E02089C7FF
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:08:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DC8053031AE5
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 03:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044CD2D0605;
	Wed, 28 Jan 2026 03:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PV5Tdlsa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DE21E511;
	Wed, 28 Jan 2026 03:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769569703; cv=fail; b=tlvaY5BO7bVflTVSAt8oM9dGANsA6IT0dkmeUiXWUls7lVe3sh+XQCeS6gqhBF79MS1jAtmtt4yJgaRdvaoLJHW+49ekU8NkO/7TrRvfu1CKeTE7pbYF4AZhGnQgnKodLNC3TCIx8labiEPnUEZAlfEY9Vxntx8W+rtmIslEbiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769569703; c=relaxed/simple;
	bh=DaJR+fk4sADmOsczdpyoGDLNg3aJT4YK2QxrwxQl/EU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bbnAho+omIBHRXHuitrSqgOGQLdnMKWRB0zp6+FDCeS5XlF0++3w47LPe4VfR0gxoh5CLRDraQUXtSfIQ/Y/sjZv0+VUOIXy50X11k8RnNYn46MJuqQhHxA3gHH4TmehP8mT0gEbAV9dBRGZ2UXb4VuyVtRmoZ924dNS0qGGby4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PV5Tdlsa; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769569701; x=1801105701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DaJR+fk4sADmOsczdpyoGDLNg3aJT4YK2QxrwxQl/EU=;
  b=PV5Tdlsa0oXM3IeQC/7qcV/jSyEOwHRoBYay6JPNgZpTKzhnh1wPDjX8
   TD7QNPxE7ZtxLfmuJ9WEsQZuyQFtTJzUCioIp6XJEPx2cJsCbgxxu3/Q8
   nf8boqkPgcxckwDLK2DapEXFqMF/arQyMziG/XycyMypkWBt9ag46EiRb
   q9WwLqUtL5XfD5B2O2LWUJ0cB49YDhP/zUvJNhwgwC6yDvthhM8KoRPf9
   lTz+g5L1Z6d/ZuhMNRDIBuTIiZzLLiawj39Tdjj/3Y6A+xNYZhqC1FB/m
   qeHQqw+yHqIZcNQjg1+L8qNw4d23BbgjWff/2mO6ORvLC9rm/DVd/S6db
   w==;
X-CSE-ConnectionGUID: BEmrceb9QaGrlJ9jVbVcWA==
X-CSE-MsgGUID: JowrnTnaR1S6360yTElLEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="81089098"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="81089098"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 19:08:21 -0800
X-CSE-ConnectionGUID: Atoua7fKT9qnKTTOIYsRQw==
X-CSE-MsgGUID: 1ABvoelPSjK14SNDMlWQMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208499487"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 19:08:20 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 19:08:06 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 27 Jan 2026 19:08:06 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.2) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 19:08:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eLro3WtMWqtFwwq/bph0eQh4UZg7FLqY7LkFgOCmwrQLFvD0qwHC/2V52DnwhYdia37ASzTDsszR8oQohO2S/l8XfJY7iniznDBHWopzKFqDk+jGZHhftqrcPxLt519ve0vmN43ol3bYmIgg5/Y2na9cozYUuJqKuNpJEM8utJiV8pN0z4nzxkJB2O7u4dWHUNphIX4bDcaOQarJ0gvEnY8EBKGmG0nSwO2NLPXPG3/X/9HKQ259FyqM/cVxiDS8UPD3ygU0DjbUJL8Kw/VbAZtwom0uZ1WP+jj7qFmGNUfcDiwqWr6wKzXxiBXgpxOw+fnVizTAIoba4+VkEPb6pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaJR+fk4sADmOsczdpyoGDLNg3aJT4YK2QxrwxQl/EU=;
 b=Y+ozrevD2uY71ZUGbUy2TRhQyoiKEwG3rcMaOkkQzJoa10A3iZ+N4P66mY6QeScAJUclP0eW+W9Dj+Y4qFGAgH3ZMfZqus3Jgw0NSIyrsp03wZKgpfO9nHFqvx4gY76bR7PhXnLKzxWavlBUyy7V3X/hkKjesQ+ufWfWhlMZWYNdLUAzC8BXLpgf7+v1+EHOZeOWOP2APmvDSjijvuHkkLKDr/dVQpHcrt+Upbk0pRqYzNMhzCM0XyZ5pvVwWJEO6vSvT1kbjFKLWyLDbC/K25dlnSDY8KZ+XsVVPklB1EpwWxo1ifmD42xJSLDDvxhXjwyitwwIS1nBYVOIeW8lbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6794.namprd11.prod.outlook.com (2603:10b6:510:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 03:07:55 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9564.007; Wed, 28 Jan 2026
 03:07:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, "sagis@google.com"
	<sagis@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Verma, Vishal
 L" <vishal.l.verma@intel.com>, "Chen, Farrah" <farrah.chen@intel.com>
Subject: Re: [PATCH v3 09/26] coco/tdx-host: Expose P-SEAMLDR information via
 sysfs
Thread-Topic: [PATCH v3 09/26] coco/tdx-host: Expose P-SEAMLDR information via
 sysfs
Thread-Index: AQHcjHkT7B6QBoWjZkCx2YzBmfuQG7Vm7aIA
Date: Wed, 28 Jan 2026 03:07:55 +0000
Message-ID: <d0129ebf5f00fcbff2ece64847ee7e638a9b1d67.camel@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
	 <20260123145645.90444-10-chao.gao@intel.com>
In-Reply-To: <20260123145645.90444-10-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6794:EE_
x-ms-office365-filtering-correlation-id: 299cc3cf-ec71-4e5c-777f-08de5e1a6eaa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?R3lIRGNSVW9na0lhS3ZzNjRsK0ZCVndnU3NpM1dKSE9NOWQxL2c3NUFIWk84?=
 =?utf-8?B?aFRIQkhqajhoMjByamx6YkxzL3hxcW9OeXF2Z2FXN2V4ZStyUEFmWjdnSUVN?=
 =?utf-8?B?WTVKa0lmVTFUNlQ2eXZJQlJjN1o2YjhUSGlVUmZrbzRYbUFvS090TmZTQzAr?=
 =?utf-8?B?a01SSHlWMERlYW9zWTRoNVNqaGJNd1dZMGlkVEgyN3c5QTJ4aWd1azBUNG9u?=
 =?utf-8?B?b1pKa1FzZkNYYmxRaEliNVhCczVZMkRhYnM0UDQyZlA1a2oxQSsrUnRFZEJX?=
 =?utf-8?B?bE9vanZ6MEQ5M0FJZ2dCeUZvbUdOekFrd2pRZHBRL1ZlSjVHSTNVY3hLVFUy?=
 =?utf-8?B?V2lGbmZweVVGY29Oa2dsR1VaUjUxRDdjdnRqWWp5cFN3SUdjcmcxYnkxeEIx?=
 =?utf-8?B?Vjd0QnViZmJjclMzRElBc1ZlZWNFeHdIVkgwZjZwdlg5NkZWTk56cVFuTnds?=
 =?utf-8?B?SEp2RDJ0RjJJM09BZWkxaUQ4S0xjNWV1NVBBS1Vqc1pmNmxSV056UWxQVFBY?=
 =?utf-8?B?eWZsWENZNkNIRDcyVGdWNm12bUtVYjhpUnFRL0todGZWZld1cndVTHZpMHVk?=
 =?utf-8?B?a2o3WTI4ZGJ6Vi9WS1Q2QWx6RFlqbHd4ZDhpRUtXYW1TaVNFUDZpeTcrcDlz?=
 =?utf-8?B?ZXVIVFdHY1QyMlhJVHlLQVpSMVBCQ0hwSk1sYVFoVnJzT0NhaGpGREh3ajVv?=
 =?utf-8?B?Q0NrMkpHa3ViUmpraUlxcFlyTDRYT0RSa3ZlNFVHSWNlMWJpSTd4UFlFL3ZO?=
 =?utf-8?B?ZGdUd2lLeDYrR082dzkwb0hHVDFkSDNFcWhtcEIxVE9SMFN6b3AvdEFWQklq?=
 =?utf-8?B?ZlYyeWY5Z3VyajZPVmdsWkdUVTN0dzZLVUdPQmxXeVlWQ1lMbkhDTXUwN1JD?=
 =?utf-8?B?WFMxZDJtOXJnVGRsNjlzQmZlcWpXNnFwK0dZU1ZGSWx2R2c5NUcxdlMvcVRt?=
 =?utf-8?B?c2dFOGFQOUlPTkM0VVBKdFVRaUJXMEgwckxnZGt5dkNUZERiSHNQV1lvYWti?=
 =?utf-8?B?bHlHZ3dyTnhRVVUwZ1llMUpFd1dPdW1rMm1pdnNjS0F4NXFNcU5IR1ZoTHVl?=
 =?utf-8?B?MFJpcVFRcHZHbHhuMFhuZnVIZE1XM3dBNWs3elZBazZyUHBudU9kOG9JRWFl?=
 =?utf-8?B?QVRuM0pPOE1ZcE1ZZEwwNExQaW5DSXU1QTFBY3lLMytpTkZFQmxoN0dZTEkv?=
 =?utf-8?B?VmtOaWg1Rjd5RllkMm45dklGcENHZHFNQno5RDZZSTBhRFdZUUp1azRhNVRR?=
 =?utf-8?B?aVd3VnovTXhlaW1EbWR5ZEdKczZYdDg3TlIwaThWVzRWa3NoQmNoUmI2aFNC?=
 =?utf-8?B?L1NpaE5qWW04dWxHM2ppQ2phbHN2SXhuZ0lRV2dvQThvWWtDNDA5dmJwdG5k?=
 =?utf-8?B?Rm1nY29jeXl1blZZc0h3WmpqbldGWGZWZ3pxN1BqVTEwck5BeEsxVDVtbWJz?=
 =?utf-8?B?VVNyTGZldGRFMUc3bldDeERubXI0TzB5eWZIVzNVZVpRNThTNldpQ25CM1Na?=
 =?utf-8?B?TTJUa1ZsVGNJQkwvUURtUG95VGJXclhaSUM5amVDLzhQaTFUZk51KzVVd1lL?=
 =?utf-8?B?MkRBWkw3VTJOc3dPVFdRMmgzM3pXOUhBSE1BWEE4RkRwR0g5MERkRjZHUlp1?=
 =?utf-8?B?TmVHRUhYY2lveXVLTHNFY1hDajJyd1hhYUMrZ2EyeTJPZ0JWbWtWdG1xLzZH?=
 =?utf-8?B?YUlhL2VEMTJkSWFkTVY0RXAycHBtaGdiQS93Ty9iSVZFZjUwclVCeEsyOENN?=
 =?utf-8?B?Yjc3SWR3czVKWjJoR294Wmx6M0dTTXJPcncveG8veE8weUZBSllEa3lKK05p?=
 =?utf-8?B?Q2xidTVvN1huaGxtUnRVUzdidmRGMFZtV2wydzloTkthaUUwbHI2dkFoVjFK?=
 =?utf-8?B?UWxieWdzZThMNEIyL3lLamRPS0J3U2ZKWEVZTWZvWUpHQW5scGg0YWpXVVU4?=
 =?utf-8?B?UHppQkFSUWpvaHdOQllxbzNUL3NrVmZiUmRYbmQ3T2FXTVRyUDRxYjU2ZWQz?=
 =?utf-8?B?MGZFdnhtNk5MV0pVbEtVQWxid0tRMGRkMThPN1ZQdVNEcFZsMklVazgxVTFp?=
 =?utf-8?B?eDZ0S2FScEx2YXBZcTJ1RUdKMmRlM1pIMHV4YVFtcmZSd0V4UE5YS1BtMDdD?=
 =?utf-8?B?cnFDdGlzZmNSWXZtQi80VzVKYWJmZ0pWRXZadjN5d3UxWFEvNThyc0IxVUEy?=
 =?utf-8?Q?KLcxDk7vFhF894aPU6ZlEiQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1NUK3BFclVjRGdabHUxSG1XNEowVHpZUkF2aUxRYkVxb0hRQ2o1U1lwQ0Fq?=
 =?utf-8?B?WDRXZ0F3MVhuUkQyWXgxbXJFK3BaYXg2Wi96b3htNTllbkRuUGVRZVJjcVVp?=
 =?utf-8?B?Ym03TFltUnE0QmxCS3ZlbTdDcDlOeURVb3ljUXpSOFdiR1BHcVRUcjVpK05E?=
 =?utf-8?B?MXBLV3JpMnhTamV0YVhoZy8vT1Qwa1JrenVuQ2VtQUloelRwUi9KeXlkSUZN?=
 =?utf-8?B?Ym94MnNZZHZDamFMWVA3b1ZZSENURDY2aHcrWStnT1ErUjB4Q0lGRkd0dkNK?=
 =?utf-8?B?dmdFa093R1ZHaDBVSER5YUNhZWVqaTA3b1ZjQXlxU2FRVEhLZHVHb01TbXNG?=
 =?utf-8?B?RWgxdVVNK2dMM0JoVkZLbTRaeHZubktUeFVnYmxHcHZ0ZVZ6ejNiNUs0ZEo1?=
 =?utf-8?B?QTd5ZHg5cGkvVm1DbjMxWi9Sc2VNQVoraWNYRjlqMDczeTMwN3p3eW9CSWNr?=
 =?utf-8?B?ZGlFWnp1ZFpQaTArQkxIMXpvb2p5TWpRRW1GSHYzenBMWi9zTHVOMithMkVj?=
 =?utf-8?B?RTB0cWhpQzN5RldWNWpQcTNwUllia04rOWRjUFg3OTRDR3dyRUhzN0tiOWJW?=
 =?utf-8?B?cVZDR3p5aVRjY20yS1VUcERIc3JvYkg4K2lKWG5rMEtNbFNZenJHWDVnSlJN?=
 =?utf-8?B?K0tNOTc2cFRJb2E3VXQ3Nlk1eGxsNEFtRWxIekl1WFhGTzVRUm8wZ1huMmpC?=
 =?utf-8?B?N0JFZzQwb3NFOTRHV1pCM2ZZK25sTjZuQzJYMHBLdStTdURxTlpxZmJ0c1hv?=
 =?utf-8?B?Um9sVm9qdkpNbmpVVVZCWG9NSGswRHQ4Tk10NFQ1S1NFZytiNXFOV2lxUVBH?=
 =?utf-8?B?cDJEd2JsdklxeVdscW9YcnpuaXZmdHIzMlcvS2ZxL210aDRmWExwczRwOStR?=
 =?utf-8?B?RS9WU2lFNE0zWUdrMVYyNEM5bGhVTC9CUmREZjAzR3dMdkZqMWRWSXh4azZN?=
 =?utf-8?B?OEM4SnY2NlV0VkdlaWVRWlB1aGxVSXRuUWhHc3Zka2hPWEVXYVVDOXdHbHVq?=
 =?utf-8?B?UGd5NmVQOWtuRzcvblM3ejdUTzc1VG1aa0FsTEdkdEsyN21oWnNwZFd1RFlo?=
 =?utf-8?B?RkkyQWJmQVNURlZsdU11WGVGNlcxcWdCVmFrZ1ZqZXNKWGtHbktwZWRqTVJO?=
 =?utf-8?B?NkNQeE5pN255M1l1MkUrd3JWTkRiYkUxYkpyZ2xZQUZCRTdLUmpqUDZVTmJ5?=
 =?utf-8?B?ZVlvS1FaQUZ3MTNiQ1VySGJsdDN5WU9URS9sRzBoQXFiZXBoVmdFK1Y5N05K?=
 =?utf-8?B?bjdxRkhUVjlmSmM2cm1wNHppV0tuUkIwT3AydjI3N1BjcVY5TmNydTlzNkR3?=
 =?utf-8?B?SWZJRDlsN3pmMDNZLzE4U3MvY3Rna2s0aVVxK2haZlZXVVo1UnBOYXZSRFNM?=
 =?utf-8?B?bktNam1lWS9lc0pxZDhXSmJSdFE4UFFrZEZ1NFl2UWlpaEN5ZExUTFg2bmN6?=
 =?utf-8?B?NFdlQWppbU82MTZiUkhHT1FMZzJFeWVvdWN2S0lCNFJjZkhZU2MvWTdEalRD?=
 =?utf-8?B?S1hLQWVFVm11UTZ0UzNkZkcyWFpiMU5Pd0xsd0RFR2FucGFMY0FUZFdaTUhp?=
 =?utf-8?B?ZHVZaDF0MkpSbkNucXdGWEJUVjVIa3lOcFdiVytnNDBQOXhCVENMQnRMOHZp?=
 =?utf-8?B?Wis1MDNLenpRWi9JRzAzZVUxaWZoVytlenlDK0JZVFFTVEg1c3ZnT3dvYjdm?=
 =?utf-8?B?dHEwaDVpWEdjbUdqT2dPNWFhZXdBYkt0Z0Y3VXdXZ3JHNElJNHFvZ1RnNmt5?=
 =?utf-8?B?cGR3bEVQWEZOQ0daOUFzS09BT3ZqZjVicEM0MDZRYTJzcjFZQnNnVmZFeUw5?=
 =?utf-8?B?WDZpTFNOZGFlREFHYS9BejhaSy9jMk5ZMmRDVmQ3RDJ3STZHR2x5T0lqTHk3?=
 =?utf-8?B?YkJ2ZWRsQW9oZUtqeGNFWjI3d3hiOEZoa3gzQjJPTFFiRXNUQkxoYTdPVGJV?=
 =?utf-8?B?ZXQwOTlVYytJYXVDYmM1K3RrOGJaNTdEUFRoc1JPUHJHVVJqOEVid3ZqVlRP?=
 =?utf-8?B?bnV0N1BjWjZlVDVkSHBVMnFUNjRlS3QzQmFreEhna29POVgwZUs1WjA4RjZV?=
 =?utf-8?B?WEJ5OWVJTkdiOGcwblRCQllUTXY0T0JURjA3N3JYVHI1bEpQRC9GYjIzSTR1?=
 =?utf-8?B?WTROTnFiT2dPVGtTTGNMTDA4QXZBbWo3SC9qWmh5c291N0oyeVBZZFE1RFZE?=
 =?utf-8?B?R1RUWkZhcXE3cisvM2pnSmcwQTkzZjByOWpEZXIzOE8xLzBFTnV5RytVNGMw?=
 =?utf-8?B?T2hqbVdWV0g0dGdjYlJ6aWk3aEFpOUFiYTRRdU9iZ0psMDdCMnI3QkV5eTl6?=
 =?utf-8?B?OXZPYUg5WXpYQStIVVo1Q0xmTnlDSG5pQ055eFlFOWJEbU96M1Fudz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BA1C3A3D238224DBEA39BD0D95EDBBD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 299cc3cf-ec71-4e5c-777f-08de5e1a6eaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 03:07:55.1651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Au7uDvB3UogoaUvJmDBDSWXoy3CJjBX2oWRj8YQUQ8iTdx2QSjmvoSGmJ2KzNOut5moiqafBSA9GdsRVtomYPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6794
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69317-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: E02089C7FF
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTIzIGF0IDA2OjU1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gLUFU
VFJJQlVURV9HUk9VUFModGR4X2hvc3QpOw0KPiArDQo+ICtzdHJ1Y3QgYXR0cmlidXRlX2dyb3Vw
IHRkeF9ob3N0X2dyb3VwID0gew0KPiArCS5hdHRycyA9IHRkeF9ob3N0X2F0dHJzLA0KPiArfTsN
Cj4gKw0KDQpUaGlzICd0ZHhfaG9zdF9ncm91cCcgY2FuIGJlIHN0YXRpYz8NCg==

