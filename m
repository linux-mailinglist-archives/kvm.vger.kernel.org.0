Return-Path: <kvm+bounces-51201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97516AEFE70
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 17:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75F214819D5
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 15:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6EB5279DCE;
	Tue,  1 Jul 2025 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XKevra5g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227D6264F9B;
	Tue,  1 Jul 2025 15:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751384225; cv=fail; b=uX1XGaRaZVvAHa97BUHN+fXSV3bblJyULFT+fwfWYJSJekCL6fhPkogOVomYQsYzd9A3Q0FWmaEluScsJv5uBes7F2nmPl6jdlAaeRX5WQ9hhJiXb9fQpgFg+hCXoOJC/aToRT/SxBCvmBpkjWqw3FZ09ppRUJRpBXHjYB4K8gs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751384225; c=relaxed/simple;
	bh=R5NMjkZtk2W8p8lNhwJ+fDatICDCt2VYQSvT7rKcgOI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MOttjm2izZUsnks9oOinbe01Ao5OodlPGewLmkye3g0UbdH3RdGsnunaewlmZaU0/RfoQN5+Bx1+oiALSvzWEOpUrdrY48rs9kqz5vWyI/tP2nzjJ9ajM7PfMGgz5Vf+noRMjMht90q8H/TSpu5bnCHfZ8QvWs9Rqn07Dk9nUv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XKevra5g; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751384221; x=1782920221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R5NMjkZtk2W8p8lNhwJ+fDatICDCt2VYQSvT7rKcgOI=;
  b=XKevra5gTIcDezmjLuXjIbDS+5yUN8QhT1NSJC6ETNmRjM13EQ4TBzF0
   coYd20BDUWuLLhDDfsPhMEe/hppWlFmdcxwTKY42Vs4k/PqtlLQndslnr
   6U28Ed57GZC27oZznQGez3OIVmHfBL8VKU+uqGYkH1D1cplu+04nG3Upa
   gZlny5MFBMNHGSTsTo9KiocTNI7W9TXx261PiwY5IpJ/dI6fpD4WHc3xR
   rTcfpwcE/dGhDloJbjDnsXqmhNLDRvZO/DzcYjfsraP+zndeDTKNbMWbd
   eYkeiK2MUv6NydGpc5/RKtXv6gF4ICYNa8oOJqxVENtq181lVLIS9Lg0/
   g==;
X-CSE-ConnectionGUID: 1WM1WQjYQAy3tf3E4mzIWw==
X-CSE-MsgGUID: hK82WwEVQRuSNJlx6I0/rQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="41289437"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="41289437"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 08:37:01 -0700
X-CSE-ConnectionGUID: imxzpiwuSniH5ktBoFcw5w==
X-CSE-MsgGUID: ek13KG2nR+O5H6uLW27W0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="154122384"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 08:37:00 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 08:36:59 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 08:36:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.47)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 08:36:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JaxvyGJ0Es9z7gTNrRP9IfaLZoJWxnPCi2yMn2FMbYCBWfcrU9lvRjiBup61ilT1874/lqmcKd83pxHHtmbJN2Efpo69sYBqFEnFKhGAfeiGtElWONRdwFAwCvVkfH1+08hrkPinmCTTJLE94Bt5DPp9sue8TTXj2STIfS3Z3heW1690jEzPMZur2g8fZsb/3J7NleTjDE8MzSoPzI5t3b8gQlMalxHZx+163TYaBgRMWb2MZLjnJZrOUoJ+dv/eOiJAXOprGw6lO1IW9DYwA5urjvsivfy5vZ6plCpkAa8JmcmH+uYoQRIEq5z24L8Y4eF9yhEFVXONB+h3eBcpUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5NMjkZtk2W8p8lNhwJ+fDatICDCt2VYQSvT7rKcgOI=;
 b=I1G8KJfXByEbSJrTnVRQt61gWT/9EAF+5HLubX6FT+YVQZtsskUZlGeedGr7sNbIxFXvrQoi/u8RSJLZrKehPh9bsRrF0kr37pFyP12ApfimfuSL2HGErfIaJpVInB4OLB2Ul+rB3KCb9coDaGMPLNnngeu/3o7Vq44VInjShbQ3AivExyud2ngb3BQdASzW+noCrOVNjXtWJkqrNLGLHcm+j9/Y5/jt3h5QMe7fjcaLbSL9OI1SdnqQ/3Ry53QSDFIuiswFx5g7Fj2OOarMGVskHFhhGITcac6IapyDOqNYeKUMIh8NjZmOObosIu2Nz/OMmW9DNadbaNTxpO3l+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BY1PR11MB8006.namprd11.prod.outlook.com (2603:10b6:a03:52d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.31; Tue, 1 Jul
 2025 15:36:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Tue, 1 Jul 2025
 15:36:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"tabba@google.com" <tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygIADYjmAgAFIQYCAACKZgIABjCaAgAQxHwCABQ5egIAAzNwAgACQ3gCAAPlVAIAAWTqAgAEvVYCAB1KDAIAAIT4AgADYfAA=
Date: Tue, 1 Jul 2025 15:36:22 +0000
Message-ID: <908a8abdf0544d4fba23d3667651c4cfcafa9c4f.camel@intel.com>
References: <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
	 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com> <aFWM5P03NtP1FWsD@google.com>
	 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
	 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
	 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
	 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
	 <0930ae315759558c52fd6afb837e6a8b9acc1cc3.camel@intel.com>
	 <aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.com>
	 <dab82e2c91c8ad019cda835ef8d528a7101509fa.camel@intel.com>
	 <aGNK2tO2W6+GWtt3@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGNK2tO2W6+GWtt3@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BY1PR11MB8006:EE_
x-ms-office365-filtering-correlation-id: 3bf7be70-06b9-4341-d138-08ddb8b50897
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WU1kd0ZrbndzZEhvai9SUHMwTUZXRkpXMFRNK0hEMU9LaW1VWDZ4TFJmTjd4?=
 =?utf-8?B?TVF0RVVJM3FWVWVLeU9FUFhwdjd5dU5lQ0pHWXVuTzloK2Y3ZjJxUE1jQ2dD?=
 =?utf-8?B?KzFRbFRyVzRwMDhDb0dETVVGd0Z2QWo5WGo5bDdMZThhZGRHa0Qybk5ZWHQ2?=
 =?utf-8?B?OGtvVmtRa0dUZWh6Mk8rS01JdVAxWmtWcnlVd1J4NVNqbFpuVHdBNmxoVmU0?=
 =?utf-8?B?MDRVZDZUZkZPaml4Qm84QkkvSmRZVXhScDhraWpPbWc0R3ZXazJUNkJxZ2tu?=
 =?utf-8?B?VENHMjFCa05HTUE0Q200VmhaMlBVMFRuYXRiYWp3by8vSVdqK3AyZVl4OTdB?=
 =?utf-8?B?clpnWE9ZWEZLU2laclNURXVSNHNOU0V5b20rcVBTQ0FBaXNPZFRFRlJldXlj?=
 =?utf-8?B?NGgyVHF4RXlTYjZNbEpOaDFUQnFHbWJUNFV4V1pXTlpIRHVDeHBUbk5pMVky?=
 =?utf-8?B?NHJvaGt3dnlzZTZIU0s1UlNnWm5jNWkrWTROaDdERTJJc3Fmb1k3MHRJV2F4?=
 =?utf-8?B?SkZqT25aQzVsVWY5TlZjMXcybXljNTJoU05MM0dLYnQxeEpNSzNVL2FOOGNx?=
 =?utf-8?B?MC9BRFdEcWtLZ0RIaFNRNzZpdHZsZlZrL05jc3ZZVGRQN1JuVHozTWh1QkZa?=
 =?utf-8?B?bHJBSTI4eEVKbVl0U2QyWGpOK29mQnZLWkFjYkRObWdhVHR6QVlReW1KYWls?=
 =?utf-8?B?SEZYQjBXWVZ6VlZQWEhjT0dQY2R5QkFXL3RZZDBJL0VLbTNIQWN3Y05MckRX?=
 =?utf-8?B?WkdCcFRyRFlRWjFHQTEyV3A0T1l0VXU2c3kzWDRGalRFbkx6clNiYTd0QVhJ?=
 =?utf-8?B?bXM1c1dtaGRLV25JellpMTUxVjNZU1hONW0vUmV5THVhdDV0ekRlekgxei84?=
 =?utf-8?B?N3R3ZG4zQkpQKzVVSTlMbktObW13cXhDSnd4UEpoUUgwUDg3ZStBUVFwaTh4?=
 =?utf-8?B?TEdFeTAzSFZYZlNTN05rcm5FWXN6T2pJMlJzSmIzRExPbEpOTGRneVVRS21a?=
 =?utf-8?B?NFBRd2JmSklGOGZucWNaL1lTbHZuNXIybVl5bDEwM1pVdTU2TVprZUszM0pN?=
 =?utf-8?B?b3ArcVRCOU42QVFkam02SmM0S3F2eDRLTUJYTXBhNW9QT3FiS09LMU5JYWlH?=
 =?utf-8?B?T3B6OGtvR05lQ0MvcjNMZmJZQzBlNFg2cE5wbWJCWmtNWXEvUTlOeXM4UHV4?=
 =?utf-8?B?c3c0c29qRTE4WGhjMGFaT2IxSkxleW83R1BpSWhsQmVpZXljTDNCa0VQME1w?=
 =?utf-8?B?MEsrOHBwQlZNWm9Hakx4YlV1MmpReDBFak1pSmNVOFpSeDBNTE5qcC91M2pB?=
 =?utf-8?B?akRrako3TXRoZ0xKUUI1SFJjdUlLTmJlRkQ2WkJSZGVyVGFKdlE1T01GRHBp?=
 =?utf-8?B?ZzZsZytORm5URWFRYlVBZFRzclVqWjVxQXVRcGFLYkZMVnc1SUR1d2xPbXJT?=
 =?utf-8?B?YUdjT1JsZ1Yza0xkd2o1ZlJHMEVnTkhXUUt4R3lXa2wxSDZNbW5mcTR1Vm92?=
 =?utf-8?B?M3orR2ZMaU4zcThveHRZYVZSZFV5Yzk0YU5qSXJrUnp6THVlcEtpU25TRFE3?=
 =?utf-8?B?SW9pZ0IxOGkzMnl2MXhqbmdpdDV2MVoyZ0x5QmwvOVRrOFhpb0QzQVlWK1Uy?=
 =?utf-8?B?WlNIZDArTHRMS1MrYzR4WE1Bc1ZKenFvSXdUT3c5OXB2ZGtFZTVSU0M5Zkhp?=
 =?utf-8?B?Rm1Ba0dLWWhIMkR5WHE0VVcwUXNwZ1RTbDBqZFhSKytNblpLYW9KNzdGUzU0?=
 =?utf-8?B?N3JjeVVmSmNUVUFYVzZqOGJ4UWV1VkY1YVJFckJYSStMMWkwTHhOd2tjT1I4?=
 =?utf-8?B?cDd0SXA1Rkt2UGdXbG52WGd4RWdiQ0JvaXBRR2lOYnllbHZBbXFvNVZSdmpq?=
 =?utf-8?B?ZU9RSWRlVU14VW1JZGNkWGhHL2s5YkNVL1RKNlQ0aUJQMjFvbEEzRlJXOGhM?=
 =?utf-8?B?L3BjRzN5Y0ZlTWxYeVJHZC9PR081TE1qZlhMUTNFbUUydCtwNFpsdzhpVGpv?=
 =?utf-8?B?UEZpQmhGa1B3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHg3VG9BSGNrd3VuWnpNdXFNSWtBVjdXSGdKZ3J6Y1pZaisvUjBoRHRhREhR?=
 =?utf-8?B?cmU5ZVNPb3BzTVVCUnJtY2NEQ3pFL01iK3RuQ25zcTBKWkszQUtOWjRCVUIv?=
 =?utf-8?B?TnlZWjUyRTV6ajJQUXlVUmJGaUkwc2tTK3JLckRmVFFBZms2MlA0ekFJRzlx?=
 =?utf-8?B?UGpYM1RDRnFqQmh2dHI2c2ZSbjd0YUovazMwYkdBTVRDOGNZVGgzZS9JcnVK?=
 =?utf-8?B?aDh6U0tGY0g1Y05xQy9hMUJkYUhlNWtKbUJDTHRndTF4bFB0RnVxWlV2aGdu?=
 =?utf-8?B?Q0VCTWhya0NUWjMyZGN3WHlvNlMyZm5ZVnplTlMySk9ldHVtdE5qbm1HQWN0?=
 =?utf-8?B?QU1ja0JJQUNmVnBzNzRrRi8vZzNzTFArMG4ySTRYUG5PelNNZ3BhcVMvclhm?=
 =?utf-8?B?REVFSy9pSDJmVzBLaEltNXl2Y1ZLYldmNFVzMGtlQnJYcllSdlZJQkpMRjE2?=
 =?utf-8?B?aU8wRjN0bURoalBNc1JxNHM1eFRiOFYzR0ZLc3BiWmE5ajZ4eC81RDRWMExw?=
 =?utf-8?B?Z200MCt6eXh1bmRKNVJWR0tSaEMrYlM3dnBnbVloSFVNbW5wM1dwTzAyZTM3?=
 =?utf-8?B?WitNVzZwaGFwSU1WcUhjRjRZVzJNejFXMnJ4Y0FnTzhMSWFSeXFxWER5bksz?=
 =?utf-8?B?T3k5SmE3ZHVxcEtWTFJOZ2p6c2dqeThPMFVzYUFDSTM5SUpNeEhFMjM4ZWVy?=
 =?utf-8?B?SWNCSWpwengwUzhDekc0UUsyNWs5UjUwRjdMMU1xbjVzbDlOS0pGMytDWWZW?=
 =?utf-8?B?NEJFRjlYSlE0NXRxaHZoaGFJY2lRdUE1akloWmY1SXl6L054bTFUUmwxQW5i?=
 =?utf-8?B?Q0dpcGpZQ1pzV2ZBUU1TOEFLS0RrRlhhTkQ2KytvSVhxWkdYaDVDVjFHeW5n?=
 =?utf-8?B?R01jT1EzNjhKOE5uVm16STRaRnVHVCtpVnpRM0FNQldIU1Uva0xJZWd4NFpr?=
 =?utf-8?B?RHcyVmhyM3B4RHNGbWNCMHpwd1VEdnZrWHcwTVpnY2NVZE91RldjY0dEMVpi?=
 =?utf-8?B?d2pLOHlwS3JWcDlXckpWVmtCTzhlSzA5Z3l0d0JrQ0NZNTZaT3dRQVdxaGky?=
 =?utf-8?B?TnFzdnBjbWYyRE5IRTRQTGc5STJWdWFLdVZTNFN6ZHAwYXc4Z3dqMUIvYVUx?=
 =?utf-8?B?WkFYd1lHRVJ5RFlzdHRRR29vU1gyeDNBV051NWY1RStlZjNpazhhYndCSGlx?=
 =?utf-8?B?NWg5Y1YwZUxsZGVWZEs4TjdDaFYvOTQ2OHI4amE4ZWd6ckNtcEVia0wrQnhl?=
 =?utf-8?B?NWtIQXQ0Y2xjbmVHRmw4cnhCb20yRk5TU3laVEFxQ1d2MzZRRE1VRHFNVUYv?=
 =?utf-8?B?dVROZExzS3k3a1g0VVpkZUtBZGwzVGIyZTNjU2x6MlluOFR5UUk3SmdodGV0?=
 =?utf-8?B?SmFzcCsyR2paRDExQVY1N1NGMzNXcVhqdHJyK2srd0Y1cG5TN3R3aXA5MjNi?=
 =?utf-8?B?VkRJd1pvTzYzN0pDSk45a3g0SkNWd1BwcU45aUtVK2tKbHYxTXJCWmVnbmhY?=
 =?utf-8?B?akRsN3huUElVcG9YZ244YUdsRW4rNHUzVTlvdTN0OHZ0b3VqZ0R4Q2VvMDV5?=
 =?utf-8?B?L3VoWXNzU09ORGFFSC9aNE9Db0NIY01Zdm9oZWNIUzM4VmJvdmpOcWF1emhR?=
 =?utf-8?B?QkFiSkthdUE2NVNNRlhZMjdLRGhkU0NQMWM1ZHJubCtqWXQ4dmtIeW1hZEJE?=
 =?utf-8?B?UjVIeFNwSnk2bDg2d2E3YWZWRU1lSjZBTkcycVdUV3JMZ09hR0Jza1oxWXZF?=
 =?utf-8?B?eHMvaDRlVkM1S0JHdXhzdFZ2WXJaN09iS2pLMGYxY1p5aEZWam4xU3JLUG1z?=
 =?utf-8?B?b2xEekcrVjZKYjJzRFNuOGdvanROb1dNSVRRUGYzK2M3eGpLUGlYMnlNL294?=
 =?utf-8?B?N0Y2K2xQYi9tU0lZd3BjN2Z2SG9RVEprMnZaZzJQcXhLdVFzbzc3SHBRNjV5?=
 =?utf-8?B?OUJLWG45R0lwV3gxNlRwSU5XMmpGdlppTTJzOHNYd0FlNmpsREVZSmhtYTFi?=
 =?utf-8?B?ZlhjVTQxWjdVaE5nRDhrbmNWSys0VUV0dnQ5RkRxRFdFejg2d3VUUHNLUWtG?=
 =?utf-8?B?cDM1dGM0WkVkNEZsVEFkeVZmMW85L2xZUlNYdmt2c202MGxZUE1hQkZBaElX?=
 =?utf-8?B?bzJLazV6M3R2eUhjVmQ2SFFKZlU4dHpxeFdjeFN6b0JWcDYyT3ZIcWxKQzJP?=
 =?utf-8?B?R1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16D0D0A7D39B504F9E74B724B751D4E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf7be70-06b9-4341-d138-08ddb8b50897
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 15:36:22.9147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kmXWxlkmfUu2RbE2XJw+usu9fzjToHt9B5UodlKIUqfyaOTaMcDbhoLd2M8sVg9QBIOY7tS8s6jn2j/hkECo8+jFSrIM3EZl8tDNf/lOZ7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8006
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTAxIGF0IDEwOjQxICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBD
YW4geW91IGV4cGxhaW4gd2hhdCB5b3UgZm91bmQgcmVnYXJkaW5nIHRoZSB3cml0ZSBsb2NrIG5l
ZWQ/DQo+IEhlcmUsIHRoZSB3cml0ZSBsb2NrIHByb3RlY3RzIDIgc3RlcHM6DQo+ICgxKSB1cGRh
dGUgbHBhZ2VfaW5mby4NCj4gKDIpIHRyeSBzcGxpdHRpbmcgaWYgdGhlcmUncyBhbnkgZXhpc3Rp
bmcgMk1CIG1hcHBpbmcuDQo+IA0KPiBUaGUgd3JpdGUgbW11X2xvY2sgaXMgbmVlZGVkIGJlY2F1
c2UgbHBhZ2VfaW5mbyBpcyByZWFkIHVuZGVyIHJlYWQgbW11X2xvY2sgaW4NCj4ga3ZtX3RkcF9t
bXVfbWFwKCkuDQo+IA0KPiBrdm1fdGRwX21tdV9tYXANCj4gwqAga3ZtX21tdV9odWdlcGFnZV9h
ZGp1c3QNCj4gwqDCoMKgIGt2bV9scGFnZV9pbmZvX21heF9tYXBwaW5nX2xldmVsDQo+IA0KPiBJ
ZiB3ZSB1cGRhdGUgdGhlIGxwYWdlX2luZm8gd2l0aCByZWFkIG1tdV9sb2NrLCB0aGUgb3RoZXIg
dkNQVXMgbWF5IG1hcCBhdCBhDQo+IHN0YWxlIDJNQiBsZXZlbCBldmVuIGFmdGVyIGxwYWdlX2lu
Zm8gaXMgdXBkYXRlZCBieQ0KPiBodWdlcGFnZV9zZXRfZ3Vlc3RfaW5oaWJpdCgpLg0KPiANCj4g
VGhlcmVmb3JlLCB3ZSBtdXN0IHBlcmZvcm0gc3BsaXR0aW5nIHVuZGVyIHRoZSB3cml0ZSBtbXVf
bG9jayB0byBlbnN1cmUgdGhlcmUNCj4gYXJlIG5vIDJNQiBtYXBwaW5ncyBhZnRlciBodWdlcGFn
ZV9zZXRfZ3Vlc3RfaW5oaWJpdCgpLg0KPiANCj4gT3RoZXJ3aXNlLCBkdXJpbmcgbGF0ZXIgbWFw
cGluZyBpbiBfX3ZteF9oYW5kbGVfZXB0X3Zpb2xhdGlvbigpLCBzcGxpdHRpbmcgYXQNCj4gZmF1
bHQgcGF0aCBjb3VsZCBiZSB0cmlnZ2VyZWQgYXMgS1ZNIE1NVSBmaW5kcyB0aGUgZ29hbCBsZXZl
bCBpcyA0S0Igd2hpbGUgYW4NCj4gZXhpc3RpbmcgMk1CIG1hcHBpbmcgaXMgcHJlc2VudC4NCg0K
SXQgY291bGQgYmU/DQoxLiBtbXUgcmVhZCBsb2NrDQoyLiB1cGRhdGUgbHBhZ2VfaW5mbw0KMy4g
bW11IHdyaXRlIGxvY2sgdXBncmFkZQ0KNC4gZGVtb3RlDQo1LiBtbXUgdW5sb2NrDQoNClRoZW4g
KDMpIGNvdWxkIGJlIHNraXBwZWQgaW4gdGhlIGNhc2Ugb2YgYWJpbGl0eSB0byBkZW1vdGUgdW5k
ZXIgcmVhZCBsb2NrPw0KDQpJIG5vdGljZWQgdGhhdCB0aGUgb3RoZXIgbHBhZ2VfaW5mbyB1cGRh
dGVycyB0b29rIG1tdSB3cml0ZSBsb2NrLCBhbmQgSSB3YXNuJ3QNCnN1cmUgd2h5LiBXZSBzaG91
bGRuJ3QgdGFrZSBhIGxvY2sgdGhhdCB3ZSBkb24ndCBhY3R1YWxseSBuZWVkIGp1c3QgZm9yIHNh
ZmV0eQ0KbWFyZ2luIG9yIHRvIGNvcHkgb3RoZXIgY29kZS4NCg0KPiANCj4gDQo+ID4gRm9yIG1v
c3QgYWNjZXB0DQo+ID4gY2FzZXMsIHdlIGNvdWxkIGZhdWx0IGluIHRoZSBQVEUncyBvbiB0aGUg
cmVhZCBsb2NrLiBBbmQgaW4gdGhlIGZ1dHVyZSB3ZQ0KPiA+IGNvdWxkDQo+IA0KPiBUaGUgYWN0
dWFsIG1hcHBpbmcgYXQgNEtCIGxldmVsIGlzIHN0aWxsIHdpdGggcmVhZCBtbXVfbG9jayBpbg0K
PiBfX3ZteF9oYW5kbGVfZXB0X3Zpb2xhdGlvbigpLg0KPiANCj4gPiBoYXZlIGEgZGVtb3RlIHRo
YXQgY291bGQgd29yayB1bmRlciByZWFkIGxvY2ssIGFzIHdlIHRhbGtlZC4gU28NCj4gPiBrdm1f
c3BsaXRfYm91bmRhcnlfbGVhZnMoKSBvZnRlbiBvciBjb3VsZCBiZSB1bm5lZWRlZCBvciB3b3Jr
IHVuZGVyIHJlYWQNCj4gPiBsb2NrDQo+ID4gd2hlbiBuZWVkZWQuDQo+IENvdWxkIHdlIGxlYXZl
IHRoZSAiZGVtb3RlIHVuZGVyIHJlYWQgbG9jayIgYXMgYSBmdXR1cmUgb3B0aW1pemF0aW9uPyAN
Cg0KV2UgY291bGQgYWRkIGl0IHRvIHRoZSBsaXN0LiBJZiB3ZSBoYXZlIGEgVERYIG1vZHVsZSB0
aGF0IHN1cHBvcnRzIGRlbW90ZSB3aXRoIGENCnNpbmdsZSBTRUFNQ0FMTCB0aGVuIHdlIGRvbid0
IGhhdmUgdGhlIHJvbGxiYWNrIHByb2JsZW0uIFRoZSBvcHRpbWl6YXRpb24gY291bGQNCnV0aWxp
emUgdGhhdC4gVGhhdCBzYWlkLCB3ZSBzaG91bGQgZm9jdXMgb24gdGhlIG9wdGltaXphdGlvbnMg
dGhhdCBtYWtlIHRoZQ0KYmlnZ2VzdCBkaWZmZXJlbmNlIHRvIHJlYWwgVERzLiBZb3VyIGRhdGEg
c3VnZ2VzdHMgdGhpcyBtaWdodCBub3QgYmUgdGhlIGNhc2UNCnRvZGF5LiANCg0KPiANCj4gDQo+
ID4gV2hhdCBpcyB0aGUgcHJvYmxlbSBpbiBodWdlcGFnZV9zZXRfZ3Vlc3RfaW5oaWJpdCgpIHRo
YXQgcmVxdWlyZXMgdGhlIHdyaXRlDQo+ID4gbG9jaz8NCj4gQXMgYWJvdmUsIHRvIGF2b2lkIHRo
ZSBvdGhlciB2Q1BVcyByZWFkaW5nIHN0YWxlIG1hcHBpbmcgbGV2ZWwgYW5kIHNwbGl0dGluZw0K
PiB1bmRlciByZWFkIG1tdV9sb2NrLg0KDQpXZSBuZWVkIG1tdSB3cml0ZSBsb2NrIGZvciBkZW1v
dGUsIGJ1dCBhcyBsb25nIGFzIHRoZSBvcmRlciBpczoNCjEuIHNldCBscGFnZV9pbmZvDQoyLiBk
ZW1vdGUgaWYgbmVlZGVkDQozLiBnbyB0byBmYXVsdCBoYW5kbGVyDQoNClRoZW4gKDMpIHNob3Vs
ZCBoYXZlIHdoYXQgaXQgbmVlZHMgZXZlbiBpZiBhbm90aGVyIGZhdWx0IHJhY2VzICgxKS4NCg0K
PiANCj4gQXMgZ3Vlc3RfaW5oaWJpdCBpcyBzZXQgb25lLXdheSwgd2UgY291bGQgdGVzdCBpdCB1
c2luZw0KPiBodWdlcGFnZV90ZXN0X2d1ZXN0X2luaGliaXQoKSB3aXRob3V0IGhvbGRpbmcgdGhl
IGxvY2suIFRoZSBjaGFuY2UgdG8gaG9sZA0KPiB3cml0ZQ0KPiBtbXVfbG9jayBmb3IgaHVnZXBh
Z2Vfc2V0X2d1ZXN0X2luaGliaXQoKSBpcyB0aGVuIGdyZWF0bHkgcmVkdWNlZC4NCj4gKGluIG15
IHRlc3RpbmcsIDExIGR1cmluZyBWTSBib290KS4NCj4gwqANCj4gPiBCdXQgaW4gYW55IGNhc2Us
IGl0IHNlZW1zIGxpa2Ugd2UgaGF2ZSAqYSogc29sdXRpb24gaGVyZS4gSXQgZG9lc24ndCBzZWVt
DQo+ID4gbGlrZQ0KPiA+IHRoZXJlIGFyZSBhbnkgYmlnIGRvd25zaWRlcy4gU2hvdWxkIHdlIGNs
b3NlIGl0Pw0KPiBJIHRoaW5rIGl0J3MgZ29vZCwgYXMgbG9uZyBhcyBTZWFuIGRvZXNuJ3QgZGlz
YWdyZWUgOikNCg0KSGUgc2VlbWVkIG9uYm9hcmQuIExldCdzIGNsb3NlIGl0LiBXZSBjYW4gZXZl
biBkaXNjdXNzIGxwYWdlX2luZm8gdXBkYXRlIGxvY2tpbmcNCm9uIHYyLg0K

