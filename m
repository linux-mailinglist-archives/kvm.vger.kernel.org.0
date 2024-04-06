Return-Path: <kvm+bounces-13783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C3A89A7D8
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 02:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F2F21F231A9
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E909533C9;
	Sat,  6 Apr 2024 00:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V1fcLtJO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5160C1849;
	Sat,  6 Apr 2024 00:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712362186; cv=fail; b=NhO2OXOB4FoF+YA9MqyIdo4lq4Qn9ZTbei+1n6NBibLoPFo+QCVjBjF+U9lMSmRnSWaEqkA1dUw8IgdY/nIoVQDtIGcqyVjqGG0K5i2M32RdbnglnIT47Oa7fZgrl6+tDjYTZ0UBMeM79bGS5jGNzU7LHkw2KfKF/2Kz4wcMaEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712362186; c=relaxed/simple;
	bh=ayBYDTPaDM3MBWT1hm8zh0vubOc5uo8rukDbWAGwxrY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q6AXyBTXPewEr3sJFCbR0CtlRMJXt0cGwVzRdDY2EMSP4bQG3jSRVN85UXNNKtGhsLrinV2pwUdelgXQIEPW8tSeTFx115M1QoktARY0cF1v58NHstHGkvuRKgTsFrxQpdsBFJfXYpi22gFOQyn/SuTGF983B8ygk+ixLxkPPGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V1fcLtJO; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712362184; x=1743898184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ayBYDTPaDM3MBWT1hm8zh0vubOc5uo8rukDbWAGwxrY=;
  b=V1fcLtJOx13Xc6GKnxe8xn6kxHbfzzr2qdJUsCBzOpGwrgntZOzxrmOj
   fzcq0owBi0o5J+ss05YM3BkvfoIV8/Muj4Li970moZAh18LeiKsYaeHuB
   u+fJL3jLdhQP4jR+tflq6e0YluHSTZN2jr2eKmGIrkqO5HcM+yIL9n6fQ
   aoYn6el0JssHMa6OEYhkvwlElpnxwi07i2CAEjMsE/4IE/20PoscfDL4t
   U5z6uXnPkvcQDJ5HtC2jBHVvQIi2QSMIlLtM0ZiORjsk+b75dYvtGeASV
   3O9CtAW/cdCIh6vXRwq5fDepQ+Ltla7sLAECdcPPaoUedZZ1qHeObPZDU
   g==;
X-CSE-ConnectionGUID: faMaqOFGQj+htIAe9W9UZA==
X-CSE-MsgGUID: QssmL9hIQQaLwNyzBaA6og==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19071799"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19071799"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 17:09:44 -0700
X-CSE-ConnectionGUID: cWgdNlv+RR6eXD2q+oBoqg==
X-CSE-MsgGUID: BXFTncZbTCuOjwLEd0J93Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="24048500"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Apr 2024 17:09:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Apr 2024 17:09:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Apr 2024 17:09:42 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 5 Apr 2024 17:09:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 5 Apr 2024 17:09:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMHaf28snkCMumOFnAJuMoU4hR1l3cT2woqhMaNgKVtjJD7ef2qqFlvBdAtF9TwHkO1IJXW2DRTfAcF++jq+vJYtUV9Hzuwi4kxg6ZIkNavPxh+m6tYQAKT767wSrHXexJpDwgUxjt2OpjJpavege53Bn8k5mHUiAUZukOfrQp2hDoBvhEh1bZz5WKoY37maTmiFyZ/ljoGvmJn6o3aflkDmObqtRCbkB9SlS7ZNgw+zgmTJnZIFj43byUZfeYnwhlOQ7SQ9REKK5MCULD1gOV9dvhqkoYQ9fCGchQ7GWXP9XZz/GmU2vQ/HdahcA+EXe2g5/JWI8qUnhBzqDGxJ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayBYDTPaDM3MBWT1hm8zh0vubOc5uo8rukDbWAGwxrY=;
 b=FMRDmP6r9Rteuuse8xB2DsWSMORUJ4pDySCqhSfS1jxnd10XPyLkTEv/m3aTe7EdjmKFconE3fH2DcMU6nWWURRbc0Zg7ZhTQYKxjkTcUysQw0d8YAuge2KUcyWDWBXlK+lUFVreMlshI6DD2+Luz+QEdY+ofcV2Sc7Iy7n7a7MP6v3Ip6hnZ0fS4pzvcSWuKbUAjY3JupfFkuQ3PvFZRNoFD+VGhrWqpXD0DTiyCc9IILpJ+7mWGasR08v02ds/AWP0pJN/1/rXYJepEv9gbdR/jQ2FnVCHkoRBwlFu/EluZN81+GZh921wXV0qJZfF3NYbrf4OLTSpU5B4BfDfmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB7807.namprd11.prod.outlook.com (2603:10b6:8:e3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.21; Sat, 6 Apr 2024 00:09:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Sat, 6 Apr 2024
 00:09:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "sagis@google.com" <sagis@google.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 067/130] KVM: TDX: Add load_mmu_pgd method for TDX
Thread-Topic: [PATCH v19 067/130] KVM: TDX: Add load_mmu_pgd method for TDX
Thread-Index: AQHadnqtEwBbn0F4FEyYzDQ1ZvXcVA==
Date: Sat, 6 Apr 2024 00:09:40 +0000
Message-ID: <a2386cbfc8a4e091f86840df491fb4d999478f44.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <bef7033b687e75c5436c0aee07691327d36734ea.1708933498.git.isaku.yamahata@intel.com>
	 <331fbd0d-f560-4bde-858f-e05678b42ff0@linux.intel.com>
	 <20240403173344.GF2444378@ls.amr.corp.intel.com>
In-Reply-To: <20240403173344.GF2444378@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB7807:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2AvVkAqUNESA5NDhK8bz+5NNFitZwC8oQ/HOTZaOn7mHCdWVaSOZx34h77nKXjoSe4+j7tuoisLt2yOTwzX0+oWxVlG1lsFOx8/Fb0X3qDCP4mCFGpIBJmxW2dNTBOQvgix5oLXBc+nV0cLE+0f6WH1e2ZsHO/7JijurIx3IHOc3/z+YfM9NVg2dlD1gWtquS9AfL0fWoMMqzV4Qq03WwGAU8Q+ANDQScY5vONhYQktPNykCcJAIUGx5wiWeqeVEfvL5/0yKvdia9Rk3CVsyqk5mYwEIAAvpQW7ZU85WqrDz/VwkvvDBJH1AF5cfCXDDGr276zSJrC0azvzRzC7Ta7enNapC+LQg67Xrh1qf7X9p4grYlSG6knNykXsxfugOkUbGh1NeobS7Kpw1s/9ULHGGgyA2g+hB+7H3NOPIqkF/aqr5HA34Qivr3S2wrbIegNh9mjceONsvr5zodV/0GVPfax9JBIUdFsWILdjWGSDbPGj9VzhRvIsuQcOcHvDrYmljhr6Tbg4sSQylzpmFbwVN5EiNcdZxePZldbvwErdrRbwCV2BiyTo4QHdh5a1fix9ILPs+qMMKgtqvzIDM06riNtK3wBrCEbsXHB3lon6kOuKuGql3i5O4D3za+9hQ5/o9ywpsF9X9WtFkYwATHHIHZuqqdilY886y/2BJ4sg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXN2MkFnZFgvSEQ4ZE1CQmFjcWNGV1ZsM2NGdUtXV2R2QWdmbHN1Z0hOdkpa?=
 =?utf-8?B?YU1Bek02U3BMbkQ1SUd2YVdieUozTytkZERiK3FzbHlMUWtVaUhFTVpVMVAw?=
 =?utf-8?B?N2Y4cnNXVmg4YVdMNHpCVDhnVGtFME81OENnOGFJQ2ZVWnE5SVU0Ujg1cUlk?=
 =?utf-8?B?UFAyWFZ1UGszcVNDTGZyRE1DcWZPZmZiZnQxQjJiOTZ1Z3NMRUR0ODNlUllw?=
 =?utf-8?B?NC9FYTFPUmllcEN3MjhVejcxRFRkRlhKZUxPYkFLa2ZBTlpkbnV4dzZkVTZa?=
 =?utf-8?B?blBYYU9maUZ5YW5UYUlrR0t1amJJTXQ2U2NIS2NmbGxRekNsRFIyM09jVWo4?=
 =?utf-8?B?Yk1VYmlTY0hIcXlTK25qeE0veWg3bzhHTDNRY05MekNxenk3SDNqa1I1VzVk?=
 =?utf-8?B?ekR4UHpUZW81RnBMKzQ3dWpFRFdjTm1lTmttTFlIQVlEb3JhbUZaWjhRRENG?=
 =?utf-8?B?K3hINjhUZ0dXMDdDQmtxS09FMG1GVDhTcXhldnpOczVqbUFpY0YzNHlnMGNZ?=
 =?utf-8?B?Y09LNURkQjlvdStvc28zNmZFVnFrVWQ2Tk91MFRsWlpOa1B3MVAyS0Z1Q1du?=
 =?utf-8?B?eFY2aG9FdE5EMkcvR0swenFZWGFsZU42NFBzQXRMRGhRMG13WjBUaHJDQ1Yr?=
 =?utf-8?B?OVpPcm5WVTN0c3dDWHB4ZDhnUGhhQUhpTWI3SVM4ZTBFTHBHTlZlYnFValAy?=
 =?utf-8?B?cTViaVF1YXFXajBkeVlhOElBTVllMHNiTWl2RHdMam1ueWdzTkxMZVN3d1Jy?=
 =?utf-8?B?U25INmJkRWFaY1JaUmlCdyt4YVNzVU0rV3IybnRuakRScTRxdTIvZjMzd3FD?=
 =?utf-8?B?MDNyTHMySzh2K1Z1RDd5cFFGV3gzTWNLVnRISnNNRkZSamxBREpZMno1TmJi?=
 =?utf-8?B?ZGVVT2hlU1IyQlJpQkZvN09WNWtNa05jaGhINm8wV2FWeGRwSTBFYVRaWm1p?=
 =?utf-8?B?c1p5TjRzQTBBT05SSExFNkZJK05MVFE0UGlvOWFERWU4cVJuRW1TbVR2Umtm?=
 =?utf-8?B?NjZ6bFlBQ2ozeU1nbHI4NHlqaitsdlFNV2hsRDVhSi9kNm5ocnlwdXUydzhw?=
 =?utf-8?B?bXVpNWFldWFKbFpsS2pob0xkUHViTkdNRnU1SzNFTnJtL3pKT3c4cTV3anl6?=
 =?utf-8?B?YnR2R3V2SXFCOGhlQmdxUEVDZ216Mm8xUjBSNUx1cWpEbzR6VEViSlA5aEo0?=
 =?utf-8?B?SjJEZHZaVTM4Z0NWSW9Tc3RlbEt0cHhKUGNFNmU3M1I3V1R3cTB3UGV5WXdk?=
 =?utf-8?B?S3YyalNyNnc1V1grWmR4aXRVSkllNzdmb3FFMURndGFkN2p0QlFYNkRiQXBD?=
 =?utf-8?B?LzBFdkxneG5iUHNHVC9Pa0I3T1B2Z1hLODFESkxqUHlNZXlBR0RYemtJc0dB?=
 =?utf-8?B?TTd1SUFXTnk1bk5SUE1ibHNFbURHQ2NjQTVyaHl5L1pxeXdLeFQ5NHk5N3Va?=
 =?utf-8?B?ektDYkk4VGE2b0p3RXhtMDBETVpjZ3pzRW5rUXh1MGJvS2xqSmxEcDlYYzZU?=
 =?utf-8?B?R1lmQzBTNitXckZoRnlNd0RFdDFDVTJsOXdkWGF4QXZHYU11ZzRUMXB3MVFq?=
 =?utf-8?B?WVBVd1Z3UlZCdm4zWm95MSsyN05CRjMvd1FBVjdwWkR4bU1qc25aYmROeEs1?=
 =?utf-8?B?QVhHMy9EdGRTZCs2U3EvQnZTNk1lY255V2FSVFRoMHhHTWwzUXBLd1UwVG9J?=
 =?utf-8?B?cXFGeUNWZ2RUb2pLRm5nZTJXQUtqTXU1dzZ6UkNaNmpyL2JaTXFxUjh0MFh5?=
 =?utf-8?B?ZVZncmN2Z2N0NTEyWjdJTVR4bmVBZHN0djVqMy9jbk9pUHdmK21nTHB3UHZm?=
 =?utf-8?B?YXhVeU82YVIvc2RwckdjNWZRZkk0aFp2RjlZUFBWSldUSXM2V2IwSHF1VnBh?=
 =?utf-8?B?WDhiM3JoNXZHeGVqUWtLSlZOSkpIdm1YaXA3V2tIOHE0emYrTlppejJaQlVy?=
 =?utf-8?B?UWVJSDMzYk1MSmFsblV4dUdnSGdQSEowTEwxUFd6YWtyNHF0aC9tblh6MUdi?=
 =?utf-8?B?Z0ZERDB6N1pkU2NJakphcUhuVEY4czBDMmdwWEduRE1NcTBjNlNzUExhT0JM?=
 =?utf-8?B?NUZoRjlXVVZBaDhhb1Y5ZE9FdjhZY01kV21EWi9iODIzLzFVYVdnYVMydFp5?=
 =?utf-8?B?cUVmMUhSVXRiS2Zha0dmN1VoRXBaZ1BTVGhUSVVPN01IcDQvWU11YWpicjJh?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F34DCBE6F2D774584BFC965594D3E98@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f670c7c-c839-4afe-4aa4-08dc55cdda65
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2024 00:09:40.0362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MIt/Hbq0fIf4nAohIAYyrm9qXteZqfdHAeU4LsqsaHJCFk9E7P9n767QzFAblrQK0Bw3XxWZX3fOw2e/qqrE0sorrWy5RFYTb0QP0+21yrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7807
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTAzIGF0IDEwOjMzIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gTW9uLCBBcHIgMDEsIDIwMjQgYXQgMTE6NDk6NDNQTSArMDgwMCwNCj4gQmluYmluIFd1
IDxiaW5iaW4ud3VAbGludXguaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gDQo+ID4gDQo+ID4g
T24gMi8yNi8yMDI0IDQ6MjYgUE0sIGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbcKgd3JvdGU6DQo+
ID4gPiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50
ZWwuY29tPg0KPiA+ID4gDQo+ID4gPiBGb3IgdmlydHVhbCBJTywgdGhlIGd1ZXN0IFREIHNoYXJl
cyBndWVzdCBwYWdlcyB3aXRoIFZNTSB3aXRob3V0DQo+ID4gPiBlbmNyeXB0aW9uLg0KPiA+IA0K
PiA+IFZpcnR1YWwgSU8gaXMgYSB1c2UgY2FzZSBvZiBzaGFyZWQgbWVtb3J5LCBpdCdzIGJldHRl
ciB0byB1c2UgaXQNCj4gPiBhcyBhIGV4YW1wbGUgaW5zdGVhZCBvZiBwdXR0aW5nIGl0IGF0IHRo
ZSBiZWdpbm5pbmcgb2YgdGhlIHNlbnRlbmNlLg0KPiA+IA0KPiA+IA0KPiA+ID4gwqDCoCBTaGFy
ZWQgRVBUIGlzIHVzZWQgdG8gbWFwIGd1ZXN0IHBhZ2VzIGluIHVucHJvdGVjdGVkIHdheS4NCj4g
PiA+IA0KPiA+ID4gQWRkIHRoZSBWTUNTIGZpZWxkIGVuY29kaW5nIGZvciB0aGUgc2hhcmVkIEVQ
VFAsIHdoaWNoIHdpbGwgYmUgdXNlZCBieQ0KPiA+ID4gVERYIHRvIGhhdmUgc2VwYXJhdGUgRVBU
IHdhbGtzIGZvciBwcml2YXRlIEdQQXMgKGV4aXN0aW5nIEVQVFApIHZlcnN1cw0KPiA+ID4gc2hh
cmVkIEdQQXMgKG5ldyBzaGFyZWQgRVBUUCkuDQo+ID4gPiANCj4gPiA+IFNldCBzaGFyZWQgRVBU
IHBvaW50ZXIgdmFsdWUgZm9yIHRoZSBURFggZ3Vlc3QgdG8gaW5pdGlhbGl6ZSBURFggTU1VLg0K
PiA+IE1heSBoYXZlIGEgbWVudGlvbiB0aGF0IHRoZSBFUFRQIGZvciBwcmlhdmV0IEdQQXMgaXMg
c2V0IGJ5IFREWCBtb2R1bGUuDQo+IA0KPiBTdXJlLCBsZXQgbWUgdXBkYXRlIHRoZSBjb21taXQg
bWVzc2FnZS4NCg0KSG93IGFib3V0IHRoaXM/DQoNCktWTTogVERYOiBBZGQgbG9hZF9tbXVfcGdk
IG1ldGhvZCBmb3IgVERYDQoNClREWCBoYXMgdXNlcyB0d28gRVBUIHBvaW50ZXJzLCBvbmUgZm9y
IHRoZSBwcml2YXRlIGhhbGYgb2YgdGhlIEdQQQ0Kc3BhY2UgYW5kIG9uZSBmb3IgdGhlIHNoYXJl
ZCBoYWxmLiBUaGUgcHJpdmF0ZSBoYWxmIHVzZWQgdGhlIG5vcm1hbA0KRVBUX1BPSU5URVIgdm1j
cyBmaWVsZCBhbmQgaXMgbWFuYWdlZCBpbiBhIHNwZWNpYWwgd2F5IGJ5IHRoZSBURFggbW9kdWxl
Lg0KVGhlIHNoYXJlZCBoYWxmIHVzZXMgYSBuZXcgU0hBUkVEX0VQVF9QT0lOVEVSIGZpZWxkIGFu
ZCB3aWxsIGJlIG1hbmFnZWQgYnkNCnRoZSBjb252ZW50aW9uYWwgTU1VIG1hbmFnZW1lbnQgb3Bl
cmF0aW9ucyB0aGF0IG9wZXJhdGUgZGlyZWN0bHkgb24gdGhlDQpFUFQgdGFibGVzLiBUaGlzIG1l
YW5zIGZvciBURFggdGhlIC5sb2FkX21tdV9wZ2QoKSBvcGVyYXRpb24gd2lsbCBuZWVkIHRvDQpr
bm93IHRvIHVzZSB0aGUgU0hBUkVEX0VQVF9QT0lOVEVSIGZpZWxkIGluc3RlYWQgb2YgdGhlIG5v
cm1hbCBvbmUuIEFkZCBhDQpuZXcgd3JhcHBlciBpbiB4ODYgb3BzIGZvciBsb2FkX21tdV9wZ2Qo
KSB0aGF0IGVpdGhlciBkaXJlY3RzIHRoZSB3cml0ZSB0bw0KdGhlIGV4aXN0aW5nIHZteCBpbXBs
ZW1lbnRhdGlvbiBvciBhIFREWCBvbmUuDQoNCkZvciB0aGUgVERYIG9wZXJhdGlvbiwgRVBUIHdp
bGwgYWx3YXlzIGJlIHVzZWQsIHNvIGl0IGNhbiBzaW1weSB3cml0ZSB0bw0KdGhlIFNIQVJFRF9F
UFRfUE9JTlRFUiBmaWVsZC4NCg0KDQo=

