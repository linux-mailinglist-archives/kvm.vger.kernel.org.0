Return-Path: <kvm+bounces-26734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC93B976D7B
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 17:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B193828DAEF
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C061C1742;
	Thu, 12 Sep 2024 15:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OMiZyscG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C931BD51C;
	Thu, 12 Sep 2024 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153986; cv=fail; b=fB3vtLKEq+O3vbNaaVgWd58uYqXXQ8aK/VS1klPl07cKaJz43Df5Ee2EL1tA9rGu6sKHrf6Tq4H8B+leItJDTgvrz2nlij/kt0bbCuroOyxKOktMWXr/nqfO2N+90wL0qiAeuaUAm/3Gh+3n4MCU/qAVyCC640scWi0xgJ/fDwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153986; c=relaxed/simple;
	bh=uUxy7ri2CI9aEi/WuKOu46KdulFGcF0wAKp1sT1zVBI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r5VEPfMliyzWE6rOt/2Zr4qdf0/gAK5N/v145yjMPAIZbCt3f1vR8l3B4VoLKjllJz2/sdLGMF5ttFNqEIx5XtG3U9PsVttisyGejyEZSPuvbCUZqpnqGV2b5ogGSFxypiNsS60WHQgG7sMrqcDdONVK/Iz6UWlZ/bL5X4mYX+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OMiZyscG; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726153984; x=1757689984;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uUxy7ri2CI9aEi/WuKOu46KdulFGcF0wAKp1sT1zVBI=;
  b=OMiZyscG8rn6NY9S1KvO20dcmBCORX6ixsJy+xx7vZ6hHzbZwVV+nUbG
   8yN5Ey/no0wc12bETDF0zZYH8n9spE40dF1cm34RLnfOxUDJEclxq2JG2
   2ldsii/2hyrmujVGD7JiNbo+9+pU7Wzp/qHYupTHJw8JJms9GoEu2HYnC
   XmtRzDhX/pXRjwtvv5wLwbdmX2b+5mQeSaearPK/sgndiH2zXQYb++m8A
   OB423uDq+P3XFS7e4U2QoCeFEVGcAFIcVS5XlOtfwam3wwlTR2gDEHGTZ
   JbvVdsx50XHY0KNo0bBozyOh0jlJ7br1EIWMN8bsybpFlsVxh1uepN+0F
   A==;
X-CSE-ConnectionGUID: SNE2uVjWTkyTPMQoeYYv3w==
X-CSE-MsgGUID: P4bAwjIVSU+G22vO6R/gKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="35684725"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="35684725"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 08:13:03 -0700
X-CSE-ConnectionGUID: CMIc/NNkT4esbDYFt8OSvQ==
X-CSE-MsgGUID: kd4btdHQTcyt/JX9st3DhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="72336043"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2024 08:13:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 08:13:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 08:13:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 12 Sep 2024 08:13:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Sep 2024 08:13:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZvETxBqAR/Q/eKL5KLaHQn8lMVZ+XBTBcx09Xj05BQtsNFRVFKlanjSRpHAJPpgVknwccPfZ/ozAK0uT+Fh0ui1PYMygdbe2AGA4hWvTYNZi2ZyGGBvjb8UCq7GfOPUDLs8f0JmepH/bKuz+JrVVRCy/DogX9FxyyVocUr7KrS9Ok4f9tYIKXKj43HapjOfcB/4AmdyTemgRoVlEmaoQwRG5mcEcbQz/R1qB5i8rYiRDxDRGT/CCCbzo0XRTAmOKVI3iMKpb2MgByg2OxhDXOvstW+V9RKRHI2IfYAusk/Chx9FTmb29lLHWIyRt5ZkZ0ZutG6bu+EH8r6xHRrvyNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUxy7ri2CI9aEi/WuKOu46KdulFGcF0wAKp1sT1zVBI=;
 b=cQwTHRZrgf4zrkjZE/7lMdIKl8+Y6Lvl2douXfl0f8aYVRB5GRFH//Ju0eHuAGcgQvzgHe5iPzistd40jvkSUsRT/QsRIKtOjr1+fn8x/pSgfiodVtSbc5RnDA7j0G+NtplUcwguCYoZW/oH+QPT4EdTyuGlHQbsDKWgtFjcGtIrdKxw30K2cHYGloK4XaRhpKkBWdOWIEwSkuqtAAQ/W3cZL9vhHQPqb7iTLdh04FhZJY9Lkswo8ivVIuWyIip5C9ydSYDQeupY+UuBpIOV9dvOsPLnxyckyexovSnycKxJuQS9EnokF9YqcbtNuDCU051lk2YI6SQQUigg9H3PbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB8065.namprd11.prod.outlook.com (2603:10b6:806:2de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Thu, 12 Sep
 2024 15:12:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Thu, 12 Sep 2024
 15:12:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Thread-Topic: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Thread-Index: AQHa7QnMfdJd7ajyXkyOXXExCWhU97JHqYYAgAGtkYCACqOJAIAACS6AgAABswCAAAbbAIAAZg4A
Date: Thu, 12 Sep 2024 15:12:57 +0000
Message-ID: <80555977208f10df437696bac0f2354fd8f6ff61.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
	 <caa4407a-b838-4e1b-bb3d-87518f3de66b@suse.com>
	 <aa764aad-1736-459f-896e-4f43bfe8b18d@intel.com>
	 <2a2dd102-2ad9-4bbd-a5f7-5994de3870ae@suse.com>
	 <45963b9e-eec8-40b1-9e86-226504c463b8@intel.com>
	 <55366da1-2b9c-4d12-aba7-93c15a1b3b09@suse.com>
	 <e2a11f6d-96d3-4607-b3f2-3a42ba036641@intel.com>
In-Reply-To: <e2a11f6d-96d3-4607-b3f2-3a42ba036641@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB8065:EE_
x-ms-office365-filtering-correlation-id: 7a77e23a-5986-4820-8f1b-08dcd33d621b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NGNucGdZUFUxZXlVY3hDWWdPTXFNVG41N3RPNUtPaXZaRFNnamdWWi9Ycnha?=
 =?utf-8?B?eWdFNHdicHVyczYxUVIyandzSW9NOXZWbktaVTVpRG5SS2RqdTlKTnYyN05R?=
 =?utf-8?B?THBXUEIybWt4cm9lQ1llMUl3YkJTQTM2cW5TT3AyeXk0WTNhNmFVbS9maXd6?=
 =?utf-8?B?ZDFIT0Y4a25VVitIcitBVFIvSklCUEhxRzRsemNWbFBYc0NaQkwvbjZkR1k4?=
 =?utf-8?B?V0F0LzI2ei8zQSt0VFI5SVJzTmM3ZXNCR2VUakZLeFBoMHhHaFhZYkM0QTFD?=
 =?utf-8?B?ZHBKRXhqYnN6MU1xNmNCWkhobFNUWXJHaUkreGhQSk5FWmZkdC84am05U2Qz?=
 =?utf-8?B?M0FKaVZwSTBPRkY5TUJWZXN1dDAwTTA2cTROMXZycStJTGpsN0F4UFBnVS8w?=
 =?utf-8?B?c3V6VjlGMzhyaW9MU1M3Nng3aEZRSWlSVmFMR2FCOWxGOGpQK1VFNUJmcGRJ?=
 =?utf-8?B?VmtQV2JFZnZZZlJGdUlVdWM2Q3IxYU90M2lZVk9ONFZwTmtmVHQvSmJyRE9r?=
 =?utf-8?B?WTlKaUtDcU5CUzhCWDNqb2RYU296RlFZbmtJMW9oZForYVU5T04xVHZpOFp5?=
 =?utf-8?B?M0NoU1BTdWU3bWNtNXAyWUZsazN4T2tXNTBwVWFyNWlzVGlHa3pxald4ejJy?=
 =?utf-8?B?NW9UVTZNcThWQ3R4QmpsdDR5cXJjaDBMLzZZblAzdHBMQUZtbC91TWE4dVBN?=
 =?utf-8?B?MlRYNHVrTzVNdy94eFdkSWo4Smo1Q0FZUjZ4WHM1cEN0N2R4QlNjSEZyb0pj?=
 =?utf-8?B?Y01CdWs2MTZaT21NNHAxQmVOY2Q0cStqT2l5bThVY3QxOHBXQzF6LzMrYndp?=
 =?utf-8?B?L2J3dm8xVitFb0FHTHI4UFFmMVQwUHBXUUtUQjk3eDNEQldWL1NwdktlaE1k?=
 =?utf-8?B?STVNVEo4OThvaWhVUmpnUkNxVE14YlNVT2EwUFdna0pXZ3h5RmhBRlZ0UndG?=
 =?utf-8?B?TkRwczhEUWU3NWZBMy9HbkJzaHpoQ044TUhZRnFVMGFnRng4NEZneUc3anJG?=
 =?utf-8?B?YkgwbVk0SmxrcTIrUFVKNkc0YzVEcCtTZ0dpZERUZXFSZzFnSjNhTzRNQUt4?=
 =?utf-8?B?cU9BNDJiZFR6cGRtNVpaTVpicWlDeXJpUVluNWprWk5qVmV5VUlHZnZZM0ts?=
 =?utf-8?B?L1NCaDRNaUd2TWJTQllocU1wREQ5VHc2RWgwRTJRam11UytNSmo3S2VuR2U0?=
 =?utf-8?B?dG9rdkFqbkxJQ3RMQ2VFOE8yN2VSak1aVUY2Q003QnZnTE9JSTVzOHJwSE9O?=
 =?utf-8?B?dHQxbkJ5cDY5b09OVUh4WnQ2N3RrV3cvbTh2eTVjRjBORE1Iemt4TWxMZERC?=
 =?utf-8?B?SEJMY2t2Mmw4M3c0R3E1R3pGR0hNaDdPUC94dG53WlZSaFNkaGRlYW1pTmVK?=
 =?utf-8?B?QklCcUp2Y3RuVWF2YjZhcXZWMTY2amY2VnNLU3lZdGxBZ0hCb0VmSjd0WlJE?=
 =?utf-8?B?ZHdCcHJYcmtqSGJGM05tOUNPc0YzZTB2RXBrVkkwUm5ONkcwbHFkZ01xcVVK?=
 =?utf-8?B?TkJrbkhOa3dzZVNQdWYxRDVhc3JTQ3pWdldCV2paVDVwNmR4Zmtta1JoQnpI?=
 =?utf-8?B?OHdCTGF2ZXJXa3NpczRVaHM0V2lJclNudmhYaWlTZG1uTGlBdVpZRU5Dc0NK?=
 =?utf-8?B?cnVTTXBWK3VzbWNZRjBncG00VlJzRjlQK3ZPOEZmS3VyK0hoaW56UWJxRFpk?=
 =?utf-8?B?ZzBCMmNKOVo5WHUyNy9yVEJ1YnFSM3gxVzBDdkFJN3NrZmg4UTV2ZTlhMDhx?=
 =?utf-8?B?T1J1QlY2b0VmTkNwWHI4N3lXNUJsUEw5K2VyVHdEL3lyREJKdnZPSjI0R0ZT?=
 =?utf-8?B?ZXlYSWx5K3RRbEJxNCtRVy9ha0IyT3VUc1Yzd1NrcmxBOWFySHZrQW5WMHIz?=
 =?utf-8?B?dmh0YVl3WTBnZlF4MTQyeW9EdnhvakpPRkdkSWVpUi96S1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2o3d3o4WWtDZHZrTFFqbVYwVEpFWnVvWlltSnBLY0NOY1JWc3dHcDJxWTFY?=
 =?utf-8?B?bS82dWxxVVFPLzR1Z3JiU0hwT0xLdjhTaTRmeG9PbDhWODlUaVpsUlZOOUhD?=
 =?utf-8?B?VG4wejNuKy85N3dVM0IxeHhJWE9OZTBacm9kOEJYQURNb056dkJIdlBxbmk2?=
 =?utf-8?B?d0N0NmwvY1dZY3UvMnRmbVVIOW56dDRTNlNQS3FFYlhjd0E2RjhWb1pIVGh6?=
 =?utf-8?B?OEcyaFc2K1pEMnZ2RXYxSTk4RVN2Z295VTVheTFoMlRCYUFtRUhSdUNjVWdr?=
 =?utf-8?B?YStvbXFock9EL3pZNmhERVJ5aTVQWTRvL1RnK3NYQ1BFOGJ6dkNRMmg1RXJo?=
 =?utf-8?B?RU5NMzYxbzg1ZzVmNmxGR2dQV2UzdXdUVXJ1Rit2TEhpeWtLbjl1aUVMc3ZS?=
 =?utf-8?B?RHNhc1B3bGh1a2VuaEYwbG84RHRoM2I0VVF6TDBGSmxuWTdHNXF4Z2xjakox?=
 =?utf-8?B?Tm5BaDhPeTR5TkVDdnkvdWZiZFVHSytOTm1aY2JLd1l6T3RXc2xWRitZWHVr?=
 =?utf-8?B?TlZTZU5Kb01oYkt6dEE3TjZZZnJlREdOMVoxTENQVVpRRlVhRmJyaWpaZTZO?=
 =?utf-8?B?VW1zWDlWNkNud2hjTlYwWUdxUkdxd1BZOUxTbyt3Vmw3ZkxDSkswT2xmM05y?=
 =?utf-8?B?ZTV5cDhuOER2Qm5hYTZqbDRKTTVRVjBJZVVKSkhaRmVPVkhiTy9QeXdKY0JY?=
 =?utf-8?B?cVVjalZxa3R2NkRoTjcybFFwL2duMTdjbHJRczNxYjJrK3hldWtXTlhHZVUy?=
 =?utf-8?B?MTBuZUpBUGRjdHZDVXR6TE1JM3hzOVcvTEF2TkRybTBSaGdyK2JwUFNiMGZh?=
 =?utf-8?B?clVEbGl2Nm54Uml3L0JURHRZTWlBMG5HdWlhR0pkRzNQcVhQR3o5WGhiajk1?=
 =?utf-8?B?cG4wUFVtZWY5ZGNSelRPSUM0dTIwK2MxOW1aejFWSkk2Sk4rWE1xY2RobVNq?=
 =?utf-8?B?SkQySlBZeFhzMDE0V2xsWExEZk1OTzhaL3hoVTZsVERIZVV3OVA1TkNtWDlG?=
 =?utf-8?B?Uk02VlBJNmRqWGhwMmQwVUpqODIweFZlK0tneFQzbmcyREpUOFllRWZqN1N4?=
 =?utf-8?B?L0o3ZjlzVWQ4dGV2WHpKOXpLZ3pEUUZGM0thRG1yMUZvRk5lMEVOZStRK1RU?=
 =?utf-8?B?eGFyQnRKQlAwV2JYb1V5S2tiOGM0MUJxMmI3MnJIeVFyeWd3L29tRTNadm5E?=
 =?utf-8?B?cE8zLzZScUFmSUt5cmlVSkNWcWpJbTl0bSt6MEc4blRJdTI1L1YrRXlTbDY0?=
 =?utf-8?B?ZVV3V1d5QUVvNCtEWG5YMi9RWWg5MG1DM0YzeHFoQlZSaFpxQXRnRHVLSVJC?=
 =?utf-8?B?KzA0MzdHbzlnSlZiUGN1VnpiVCsybHJnd2Q0SWQyZlJha2FEV05La2ord2J2?=
 =?utf-8?B?eGxJQzRLSzNzL2lXQ0w2ZENMRllkN2hlNmJuKzN4bW5uNGFJQk9GSHdvTFho?=
 =?utf-8?B?YUZjeXQ4VC9zQXlBcVRPRWVYU3RMby9lRkVrdDMxeTR5cDJXeVRTTkp1OVFa?=
 =?utf-8?B?cUx5ZTlUcmt0ZkpzQlQxUVdZMUpkY2pTYkV4T1IrRDUvbDJubEUzc05IU2VE?=
 =?utf-8?B?OVRWMERnZSsxb2hCbzZvZGluaDY2TmhaUnNmK1lTWlRXQUVxU2d6cTVHU2J1?=
 =?utf-8?B?MENtLzdZZFRCQ3BCUWRCNDZVMmFJR3dLSDZoSG10NnFsejJGZjlWbjBVM1hG?=
 =?utf-8?B?UmFkSU9QTXVCcURtaGFSYXRQYURjeUozdFNscmZVbHJQaGFYeDFKMHg0amVk?=
 =?utf-8?B?cHl2QlFxUFd0RzRzUmQ5YXdwOGZhTGRWczQ5K3lJa0FhZ0J1ZG9tTXVWbTRt?=
 =?utf-8?B?THJ6aHpleW10TitKM0ROZ2Y3SlNDOUVzWElWc0dzYmRDUm8xeC9hWVlEcHAr?=
 =?utf-8?B?ZCtnUmszTy9XZWVkYlpXUEk5RlF6S3d4eDJkbU0vUVhTY2o2ZjA4ekdQQi9P?=
 =?utf-8?B?SkdPbnpCN0xra0twbWFOQWNVa04xMUl5YzRaSFBROUVvaUNYbzRRcjB2cmJM?=
 =?utf-8?B?Z2FJWWZvV0N3dEttTmRLT0Uwcmx3ZHhzd0Y4TGlIOTYvbTlUUEcvTXVmcldr?=
 =?utf-8?B?aU1iV1RJNnZjRFFnWGxQblNQK3hRTmQyL1dkaHFMOGJhT2FUOTM2ZHBCUXlh?=
 =?utf-8?B?TGU4enFmcGpiMDlGNU5KbkU5TEx6UE1JKzVoRktlSE5ONjVzTDJkL0V4dHdG?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAA07A006F13C743A782044F80153970@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a77e23a-5986-4820-8f1b-08dcd33d621b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 15:12:57.1875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRfPjd9zyxSSYsnsSIFcxjwY9TGA+R2j9Fw+R5Aw4wSVuVDDehcrVOvCSS3b1dZq7CawekeSY4N7KMrxgXA3qObwJM1ayZxxBNGsC3VZTjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8065
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA5LTEyIGF0IDE3OjA3ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IEkuZSBpZiB3ZSBkaXNhYmxlIFNFUFRfVkVfRElTQUJMRSB3aXRob3V0IGhhdmluZyBBVFRSX0RF
QlVHIGl0IHJlc3VsdHMgDQo+ID4gaW4gYSBwYW5pYy4NCj4gDQo+IEkgc2VlIG5vdy4NCj4gDQo+
IEl0J3MgbGludXggVEQgZ3Vlc3QncyBpbXBsZW1lbnRhdGlvbiwgd2hpY2ggcmVxdWlyZXMgU0VQ
VF9WRV9ESVNBQkxFIA0KPiBtdXN0IGJlIHNldCB1bmxlc3MgaXQncyBhIGRlYnVnIFRELg0KPiAN
Cj4gWWVzLCBpdCBjYW4gYmUgdGhlIG1vdGl2YXRpb24gdG8gcmVxdWVzdCBLVk0gdG8gYWRkIHRo
ZSBzdXBwb3J0IG9mIA0KPiBBVFRSSUJVVEVTLkRFQlVHLiBCdXQgdGhlIHN1cHBvcnQgb2YgQVRU
UklCVVRFUy5ERUJVRyBpcyBub3QganVzdCANCj4gYWxsb3dpbmcgdGhpcyBiaXQgdG8gYmUgc2V0
IHRvIDEuIEZvciBERUJVRyBURCwgVk1NIGlzIGFsbG93ZWQgdG8gDQo+IHJlYWQvd3JpdGUgdGhl
IHByaXZhdGUgbWVtb3J5IGNvbnRlbnQsIGNwdSByZWdpc3RlcnMsIGFuZCBNU1JzLCBWTU0gaXMg
DQo+IGFsbG93ZWQgdG8gdHJhcCB0aGUgZXhjZXB0aW9ucyBpbiBURCwgVk1NIGlzIGFsbG93ZWQg
dG8gbWFuaXB1bGF0ZSB0aGUgDQo+IFZNQ1Mgb2YgVEQgdmNwdSwgZXRjLg0KPiANCj4gSU1ITywg
Zm9yIHVwc3RyZWFtLCBubyBuZWVkIHRvIHN1cHBvcnQgYWxsIHRoZSBkZWJ1ZyBjYXBhYmlsaXR5
IGFzIA0KPiBkZXNjcmliZWQgYWJvdmUuwqANCg0KSSB0aGluayB5b3UgbWVhbiBmb3IgdGhlIGZp
cnN0IHVwc3RyZWFtIHN1cHBvcnQuIEkgZG9uJ3Qgc2VlIHdoeSBpdCB3b3VsZCBub3QgYmUNCnN1
aXRhYmxlIGZvciB1cHN0cmVhbSBpZiB3ZSBoYXZlIHVwc3RyZWFtIHVzZXJzIGRvaW5nIGl0Lg0K
DQpOaWtvbGF5LCBpcyB0aGlzIGh5cG90aGV0aWNhbCBvciBzb21ldGhpbmcgdGhhdCB5b3UgaGF2
ZSBiZWVuIGRvaW5nIHdpdGggc29tZQ0Kb3RoZXIgVERYIHRyZWU/IFdlIGNhbiBmYWN0b3IgaXQg
aW50byB0aGUgcG9zdC1iYXNlIHN1cHBvcnQgcm9hZG1hcC4NCg0KPiBCdXQgd2UgbmVlZCBmaXJz
dGx5IGRlZmluZSBhIHN1YnNldCBvZiB0aGVtIGFzIHRoZSANCj4gc3RhcnRlciBvZiBzdXBwb3J0
aW5nIEFUVFJJQlVURVMuREVCVUcuIE90aGVyd2lzZSwgd2hhdCBpcyB0aGUgbWVhbmluZyANCj4g
b2YgS1ZNIHRvIGFsbG93IHRoZSBERUJVRyB0byBiZSBzZXQgd2l0aG91dCBwcm92aWRpbmcgYW55
IGRlYnVnIGNhcGFiaWxpdHk/DQo+IA0KPiBGb3IgZGVidWdnaW5nIHB1cnBvc2UsIHlvdSBjYW4g
anVzdCBoYWNrIGd1ZXN0IGtlcm5lbCB0byBhbGxvdyANCj4gc3BldF92ZV9kaXNhYmxlIHRvIGJl
IDAgd2l0aG91dCBERUJVRyBiaXQgc2V0LCBvciBoYWNrIEtWTSB0byBhbGxvdyANCj4gREVCVUcg
Yml0IHRvIGJlIHNldC4NCg0K

