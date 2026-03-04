Return-Path: <kvm+bounces-72732-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPODJ3p8qGn5uwAAu9opvQ
	(envelope-from <kvm+bounces-72732-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:39:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 16529206823
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:39:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C33B3075FB2
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A1E237AA6D;
	Wed,  4 Mar 2026 18:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dbxybOIo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6F336606C
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648573; cv=fail; b=m7ir1vmAupK+XaWFru5JzxT4EBzyjwTo63go1IDJerr8VUKiF0eOygDho4yyTsWXzpJXmrAdQJ/e71fbzly6gr4wnaKerUQlZ4A1VH0SOGw3ppeW4qmeJEZxgxob3WQ2RktyZgyLcLXSHLh4hVjn4Bbgv7Ejq0PGU+kUA9j4Zq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648573; c=relaxed/simple;
	bh=zQiCwiHG/yQayvNkNqtzEP2Iq7FrIfHoNS5Da97rfV8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ilwKYmCpchkgfiOImR/jmDRiYgUtWv7ROv+ROatV8uzapCR3jIG0JJtYGWz4BMEuNkAqfWpe1Bh7866XYTy9+1RCsHMvU2hVeUX38d4NMTPgU8agBoO9Dmb+17Kq6lf3w+mSMRIxPvjpYXxTQtz9Gy6JRbZTorS2QjoSAo2v1f0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dbxybOIo; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648572; x=1804184572;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zQiCwiHG/yQayvNkNqtzEP2Iq7FrIfHoNS5Da97rfV8=;
  b=dbxybOIohDRNJbIbPT4j7ZBMcBnQ9x5V0z3NMrIVl7x+IbG3nSrlFxBj
   SBi/YaNqRFk3IwEjgo1jbXKpunjP70GEpFHPx0WQUUy5DLHna/aAfFopP
   gO/JLqy1l5bfogsk7U9onTNyt/3Sol8IHLhWtyY0eH1KekqNORQkLxqIw
   HJO22U/pBuRBJlZvIYxSU6tNZ8yTToYpWAa5BtBasXM6MheEokwXmuBes
   X/dOWN8AW66XEX55Y/yDg2t2VsTxu4G+CnIT1AX1ilTHGdrNtM0I5aAKN
   /EPEidMqwdEX3+xzZaIPxc7766kvnLJCCU6OAqGek82cEUPajG6WYElcq
   g==;
X-CSE-ConnectionGUID: up+ruLByQVC4LqiWC6B6UA==
X-CSE-MsgGUID: n1DpK3+rQt2t8FmhMRYC5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="61292610"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="61292610"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:22:48 -0800
X-CSE-ConnectionGUID: FDU8tdclT3mPlzC/WyHZbg==
X-CSE-MsgGUID: kiakZbwuSwKVkHUBeNcRFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="218558355"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:22:48 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 10:22:47 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 10:22:47 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.30) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 10:22:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ivN7qfoecGLIQBqQGRulo7lnu5CbDVmOA3nq1+e2sDcwqknHpIxDE0UG4IGJnOmgUqSXlT5O1lI+MaMCO4zzE+uGJHiXyGS2Q0xqdm3rjW6TdATj4+O6RrMY6mQPR4JskucFZqzxQXSPUAWwrPI3X+F5RAtVups5mZV5RWkIsLHwocDsrlCbd8zJaBIIFR94KKm5Ztkcv7rJAOGtFpbgg2bOvnrmemf8HkgaGZtqioCejB1GJD4ogJ4n4Z+utlrzYYP/DTIW0Zf0wQDp5Txzr4CCRZgYW00jTH2smBuK6c99xxCptEmCioCMfjLF6maRjrwd5JNkpOzXrv3Nf4kjvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQiCwiHG/yQayvNkNqtzEP2Iq7FrIfHoNS5Da97rfV8=;
 b=T3Nfqvaf83cPTK8hFgo5QiH0TXx5mAVqBruSarbCWPDDTF8BuXwwgZW93EJJ+87y0teXOC8KaizktSM5H7ZnTVaLT+t77m1A+im/0efzuzdJK/IWQNvb0mczouuWSALTeoepFr17FWofmIvSRuR/Gq7Xl+q02Vd939H8bctxE76F45UCufhaVj8wYwxakhlwGSFcXP0P/S2VSDJf8AVJcFqJHojTwdgqF4+gU5CFopf/JEFx6VG8XfP2WPCVOFBaTvl0VRq0aXRaQcoxP3M/663xCeUlkte8E+W1fwtFeWU3ipepOWR72iafEoYZMmxklbIjMMMV+oLpnHzg40YL4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5093.namprd11.prod.outlook.com (2603:10b6:510:3e::23)
 by PH7PR11MB6931.namprd11.prod.outlook.com (2603:10b6:510:206::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 18:22:42 +0000
Received: from PH0PR11MB5093.namprd11.prod.outlook.com
 ([fe80::6b8a:a7c9:e153:e460]) by PH0PR11MB5093.namprd11.prod.outlook.com
 ([fe80::6b8a:a7c9:e153:e460%5]) with mapi id 15.20.9678.017; Wed, 4 Mar 2026
 18:22:42 +0000
From: "Chen, Zide" <zide.chen@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Liu, Zhao1" <zhao1.liu@intel.com>, Peter Xu
	<peterx@redhat.com>, Fabiano Rosas <farosas@suse.de>
CC: Dongli Zhang <dongli.zhang@oracle.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>
Subject: RE: [PATCH V2 01/11] target/i386: Disable unsupported BTS for guest
Thread-Topic: [PATCH V2 01/11] target/i386: Disable unsupported BTS for guest
Thread-Index: AQHckKxQ6kY8l2Il80mWLpZ0C9s0ULV9GhcAgCHL18A=
Date: Wed, 4 Mar 2026 18:22:42 +0000
Message-ID: <PH0PR11MB5093EE8AEA27898F40924BB3F37CA@PH0PR11MB5093.namprd11.prod.outlook.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
 <20260128231003.268981-2-zide.chen@intel.com>
 <7803017e-aefa-421a-92a1-3b5820beba53@intel.com>
In-Reply-To: <7803017e-aefa-421a-92a1-3b5820beba53@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5093:EE_|PH7PR11MB6931:EE_
x-ms-office365-filtering-correlation-id: d35914dd-7d64-418d-f9f0-08de7a1b066b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007|38070700021;
x-microsoft-antispam-message-info: qvx5JuGjyeKWUk9L+yMCF8PyC/4P+Z972B2girAV6FuimHTqUyeT52mxhNHjH+PmQBHAQSE96mHbW/RpuvwChTYJgJymjaQPwTuc0zelgGGqxOD++alov8I1mPS09lVh0Whwa9RgTtEY8c0BugVtkS9irSoji1cK+WlIXWDsVZx0rOeb6/1EbHgwWtSqZQCCAXjYomT1lElWiBSZ1POKs4TfIA3yqolqEZoci3w8Qd8pCEPRHxV+c9zcnhli2X80I5MfceKxIocmHjtOTB5uTpb4PExNqG6vjUD2EhbLMqO4Hf7LmNebPG2uS8YD2JZ7OVGIPp2ycP98rtTDMrzpnZlhgkiq8MM2K3wKqTwqxgPb93W+WWldPbzWkAOEdxaqOzdEwpYa1XcaRQJCYYubpGThrkZI4lwEC4GWWutMBj1XUzgIKTYrPHHURY4++tjUrGdOlBw7QbBIP6Q7r1tBosB6mYli6DletE9nDWjKSiZF0VsFoJKfoXeKzdakkv138jjKZ/eb9z7LLHeqESmOgHDV9ikhRYz/Ihh1voie4n+ItoMqnCs94FGrkB43bQI2aK6btsqxBAP4IDtjf6g1xQy15FQtj8GsT5LdaD7RlPrBVDK0UlwGGlo/8cl+tSdMhV7nDFtml5py3yYTIK/46Of+N2941ANr/Z+B7LSnu5WPF6tYrBBWoMalHMMqRMARrJLdgl23mzdhB0IMmxAXzI2ZFXfCi1aL/+YqfP7ay8OZI2ma/qONM5aVyTmbd1GsSCGdK6AQYV+J/lXtFRsu/GFnp9wuQHOWgzwEzYDsmABwsJPI1KtMoks6fGb95kxc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5093.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGp1eWZBQ2VNMngwUCt5eS9WUlprQ0thaitCdEo5cXBoZVM4aTZrb1l1UFJp?=
 =?utf-8?B?OFZPbmkwR3I5TElJWmRxRVJrRHVKbzAwT0k2OWt4U0trb3h5Z0FWR0VkbXBR?=
 =?utf-8?B?WHJMb0JKQ1ZVQjQwdDFpd3BCQ1NNSEF2bEMxRDdCRDNuVGE3YnU2Q3dDQkZF?=
 =?utf-8?B?WHFBKzVFM0t4THNNRE9JOCtEaVphM1o3K0x5Y0Q4TC9jVExteXFhemtPTkNL?=
 =?utf-8?B?T1J0MGYzM3dDWTg3V1Zqcm5DYURnV0lCQ2RHTUk0QUx2TnpiMG5zTWlSL1lY?=
 =?utf-8?B?UjZjOG5oK2ZVUG5iZlRsQVRGR2JCcjl3SUZDU3FQK2g4WHFCUUVTWHI3cnht?=
 =?utf-8?B?VEw0Z2ozOEtjcHlIa0wrblp3NE16M1B6akhjQlF4WTBWeUpmM3BkU05DcFFv?=
 =?utf-8?B?RlkvWWNWSGZ5eXFQVUdkYTRDWUM3L0VlRmxnazlUbFJpQjV1L1FTRUxDV3lL?=
 =?utf-8?B?dUpVVTF3US9pY3Q5RlQvdWk4TlQ1TituS0IyaEptR0xldUsyamlSak42WFlj?=
 =?utf-8?B?amZJNytldGdEdjdwRTdYZ0RsY2xpdGIxTWduRWh6Z01nYThqMUJJdVRxTE5v?=
 =?utf-8?B?eWhnVWxEQWk3Y3hkZ1J4QmRlOUhpOEp4YkZsc3FPS3BGNk0yNTgrMy96V01M?=
 =?utf-8?B?NkdKSU9jenh4TFhUVGhXdnZCSnB2TE52Y1ZPQUpUK2g1YzhTUU42ZWpoYXRx?=
 =?utf-8?B?UFFaMTdReGxyOGVXU3pQQzU0blp6TzlqYkRuREkvNkdPbzFFbEZiUnEvOHpp?=
 =?utf-8?B?cGdUbjRpWTBsQ3lYR003dVdrSSthOTQxbVZpMTdyMG9VbUYxckNodlZEMEM4?=
 =?utf-8?B?TExWamV0MERXUVlNNjlwcFlNSjVrS05lUi8xUTE4MXlwM1N3ZngveVBmLzNQ?=
 =?utf-8?B?Z28wNWIxa2d2bUcyWHpjc1o0ait2bTVBYWVRY0ZNS3h0VUVxQ1pKQ2pRRU1y?=
 =?utf-8?B?UGkydWZzcHF0VlhybDh4L29tM0JLeFAyampuNVluOGRaVEtBZk5ZTzdOd29l?=
 =?utf-8?B?WE5GeW9YTlN6ems0OUhOWkdHMjVwSWVuSUZEQWZSTVlNdm5uMFJCdHZLK3Uz?=
 =?utf-8?B?Mm12VnJ1QU5WZUczTzNvclR1SVl1VWNNNTBoOWFUNGpFWW1UdE1Zd3ZHVlZj?=
 =?utf-8?B?VjlNRFIzanFNN2Y2ak93Rm9VQlIrZ24wZGNaVWVoTXNHdENVeGpScFltUUlh?=
 =?utf-8?B?MzZTamczc0h3a1MyVWwxZnlpOTQ3a0V4ZE1wY2lSWi8wVVJJSm1RT29rU0h3?=
 =?utf-8?B?UFl2R3RnV2YveXU1eDlBR3M3UnRlVU0wWGhtcjZOZmswMU55NVNzekI0YVBt?=
 =?utf-8?B?YkxZd3dTSzZ4Y3dwSFRkd2hUM0pXYy9pMmY0YkJKbmNVTkNPaE1iK1hTNkNl?=
 =?utf-8?B?dzgvT0RSdWp0ZGI0bFd5RDdHWTBhWTJNZFhMVUxmR0FCT1IrcWlNck5xcThI?=
 =?utf-8?B?Z1B5dWtKdXF2RWxjKzFEb0NsVWhkUWZNbFM3MHZvampEMDNWZDJ5RHp0dmJl?=
 =?utf-8?B?NzhZQnh5VWtGaGVZaGZMWXVXZTZ3SnYzNTBsQ3pBMEU2ak1wM2N1dFJFNmlx?=
 =?utf-8?B?RUFTaWl2KzhKT3ZLUW5mRWFkcXhsWWF2aWd2Wld0ak1SMlYwS2x1Z3FiTVA3?=
 =?utf-8?B?YjhONlM2N2JvV2lMOGt5NW9jT1RqdFlhM3ZPZUQ4SVBsVk9zWkJldzRxWXdq?=
 =?utf-8?B?WGRMOEhuU29wNHhwYlVDdEhmcUt5a2phZ3ZKektvcEswSHZ0VXR6NTBMUG5T?=
 =?utf-8?B?MkFHWnh3cEphTEpKbzdVSGFvK01ieXFQcXFrckZPS3VoY1RqaDRIb1J6dkZL?=
 =?utf-8?B?WHlRNGpyL0VORUR0NFZScnRrTGxNNmo0bWNFQ2VVR3lwUU9KU1YxUGw5dnpO?=
 =?utf-8?B?VmdJMmcxL0dWV3ZTdjdJOTdyZEJpWFJFcFJMbkVNRWxlTnZQSkJlampwdkVq?=
 =?utf-8?B?OFJ1U1dodDdaU1FDckViVVUyV2ViMEc1N3NLd0gwcG1vUE80dmo4SkxpT05o?=
 =?utf-8?B?UWs2b1YrUzlzWWZHT1UrKzZpV0c3Tmh3eTRHQSs2amY5TjI0dnlGMVJXSTZ0?=
 =?utf-8?B?ek5rZjJNcDFENmxPUTJ0bFM3WW9hVytrdVJIZklRNFBNZzl1ejFScXExb3Ry?=
 =?utf-8?B?TjR0STk1eFFqaWdIdlM3VVVIZmNwWGVRV0tIZ3JnQk5nVkpaOEtRVTJ2bHI5?=
 =?utf-8?B?cHdhV0VQMVV1a0pUcFhsZFc2OWhFNlVaektKSnNSKzRkeXVEQVZJdzlVV3l0?=
 =?utf-8?B?VWxsenVwM1ZIUTgwcTR4L2NRWlRTZGoyc3JvaEVDMXRxcXl2b1AwaUZiRC84?=
 =?utf-8?B?bnpYbXNjd0FmVDRqRjBxbEoxR1NHZDh4Vy9HRTRPSzc1NWJGNTZGQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Pz7Ga/des9cMKNTul/fIhc48Gwg30Q28a4w3KGQ4xxaFEct4ncDMubO0q4IpYOTGN5M8y3zXBACRU3tenfaGlWSlvEkp6L7BYgY/up8xslAOlDIZ6bwsqPGGyewTQQzLQMmbPm2PLUpkC99VI+4la+vsI8MeE/PIl+jNN33nrtlOacdV6XASw/GYktvr0yD5az9kXLCvzY9anomoDvU7eXzDME3XL9HeM9XOVJKNOg46serjWFfVxOdNMpbIh4DI0vlJLrJaccVuHWPEWtAWbX2FRvBRT85DDqM8waztTqClUCDj9hkQvjMUrWF58zXK36FvehD4iU2NuRqNimPeuw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5093.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35914dd-7d64-418d-f9f0-08de7a1b066b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 18:22:42.3391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 46/0K4DShzOp3DG520nS3MJT/EF9OK4pLP2icpDPFkKdSXHsb78/WHTnGS0pTjg6oJZeaUUJPjUhsuaYZMZX2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6931
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 16529206823
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72732-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,oracle.com:email,suse.de:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[9];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGksIFhpYW95YW8gPHhp
YW95YW8ubGlAaW50ZWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAxMCwgMjAyNiAx
MDoxNSBQTQ0KPiBUbzogQ2hlbiwgWmlkZSA8emlkZS5jaGVuQGludGVsLmNvbT47IHFlbXUtZGV2
ZWxAbm9uZ251Lm9yZzsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgUGFvbG8gQm9uemluaSA8cGJv
bnppbmlAcmVkaGF0LmNvbT47IExpdSwgWmhhbzENCj4gPHpoYW8xLmxpdUBpbnRlbC5jb20+OyBQ
ZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+OyBGYWJpYW5vIFJvc2FzDQo+IDxmYXJvc2FzQHN1
c2UuZGU+DQo+IENjOiBEb25nbGkgWmhhbmcgPGRvbmdsaS56aGFuZ0BvcmFjbGUuY29tPjsgRGFw
ZW5nIE1pDQo+IDxkYXBlbmcxLm1pQGxpbnV4LmludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBWMiAwMS8xMV0gdGFyZ2V0L2kzODY6IERpc2FibGUgdW5zdXBwb3J0ZWQgQlRTIGZvciBn
dWVzdA0KPiANCj4gT24gMS8yOS8yMDI2IDc6MDkgQU0sIFppZGUgQ2hlbiB3cm90ZToNCj4gPiBC
VFMgKEJyYW5jaCBUcmFjZSBTdG9yZSksIGVudW1lcmF0ZWQgYnkNCj4gPiBJQTMyX01JU0NfRU5B
QkxFLkJUU19VTkFWQUlMQUJMRSAoYml0IDExKSwgaXMgZGVwcmVjYXRlZCBhbmQgaGFzIGJlZW4N
Cj4gc3VwZXJzZWRlZCBieSBMQlIgYW5kIEludGVsIFBULg0KPiA+DQo+ID4gS1ZNIHlpZWxkcyBj
b250cm9sIG9mIHRoZSBhYm92ZSBtZW50aW9uZWQgYml0IHRvIHVzZXJzcGFjZSBzaW5jZSBLVk0N
Cj4gPiBjb21taXQgOWZjMjIyOTY3YTM5ICgiS1ZNOiB4ODY6IEdpdmUgaG9zdCB1c2Vyc3BhY2Ug
ZnVsbCBjb250cm9sIG9mDQo+ID4gTVNSX0lBMzJfTUlTQ19FTkFCTEVTIikuDQo+ID4NCj4gPiBI
b3dldmVyLCBRRU1VIGRvZXMgbm90IHNldCB0aGlzIGJpdCwgd2hpY2ggYWxsb3dzIGd1ZXN0cyB0
byB3cml0ZSB0aGUNCj4gPiBCVFMgYW5kIEJUSU5UIGJpdHMgaW4gSUEzMl9ERUJVR0NUTC4gIFNp
bmNlIEtWTSBkb2Vzbid0IHN1cHBvcnQgQlRTLA0KPiA+IHRoaXMgbWF5IGxlYWQgdG8gdW5leHBl
Y3RlZCBNU1IgYWNjZXNzIGVycm9ycy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFppZGUgQ2hl
biA8emlkZS5jaGVuQGludGVsLmNvbT4NCj4gDQo+IFNpbmNlIHRoZSBwYXRjaCBpcyBoYW5kbGlu
ZyBCVFMsDQo+IA0KPiBSZXZpZXdlZC1ieTogWGlhb3lhbyBMaSA8eGlhb3lhby5saUBpbnRlbC5j
b20+DQo+IA0KPiANCj4gQmVzaWRlcywgSSdtIGN1cmlvdXMgYWJvdXQgdGhlIChsZWdhY3kpIFBF
QlMgZW5hYmxlLg0KPiANCj4gQmVmb3JlIEtWTSBjb21taXQgOWZjMjIyOTY3YTM5LCBCVFNfVU5B
VkFJTCBhbmQgUEVCU19VTkFWQUlMIGluDQo+IE1JU0NfRU5BQkxFUyBhcmUgbWFpbnRhaW5lZCBi
eSBLVk0gYW5kIHVzZXJzcGFjZSBjYW5ub3QgY2hhbmdlIHRoZW0uDQo+IEtWTSBrZWVwcyBNSVND
X0VOQUJMRVMuUEVCU19VTkFWQUlMIHNldCB3aGVuDQo+IA0KPiAgICAhKHZjcHUtPmFyY2gucGVy
Zl9jYXBhYmlsaXRpZXMgJiBQRVJGX0NBUF9QRUJTX0ZPUk1BVCkNCj4gDQo+IEFmdGVyIEtWTSBj
b21taXQgOWZjMjIyOTY3YTM5LCBpdCdzIHVzZXJzcGFjZSdzIHJlc3BvbnNpYmlsaXR5IHRvIHNl
dCBjb3JyZWN0DQo+IHZhbHVlIGZvciBNU1JfSUEzMl9NSVNDX0VBTkJMRVMuIFNvLCBpZiBQRUJT
IGlzIG5vdCBleHBvc2VkIHRvIGd1ZXN0LA0KPiBRRU1VIHNob3VsZCBzZXQgTUlTQ19FTkFCTEVf
UEVCU19VTkFWQUlMLiBCdXQgSSBkb24ndCBzZWUgc3VjaCBsb2dpYyBpbg0KPiBRRU1VLiAoTWF5
YmUgdGhlIGxhdGVyIHBhdGNoIGluIHRoaXMgc2VyaWVzIHdpbGwgaGFuZGxlIGl0LCBsZXQgbWUg
a2VlcA0KPiByZWFkaW5nLikNCg0KWWVzLCBNSVNDX0VOQUJMRV9QRUJTX1VOQVZBSUwgaXMgc2V0
IGluIGxhdGVyIHBhdGNoIGluIHRoaXMgc2VyaWVzLg0KSSBoYXZlIHBvc3RlZCBWMyBvZiB0aGlz
IHNlcmllczogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZlbC8yMDI2MDMwNDE4MDcx
My4zNjA0NzEtMS16aWRlLmNoZW5AaW50ZWwuY29tL1QvI3QNCg0KPiA+IC0tLQ0KPiA+IFYyOg0K
PiA+IC0gQWRkcmVzcyBEYXBlbmcncyBjb21tZW50cy4NCj4gPiAtIFJlbW92ZSBtZW50aW9uIG9m
IFZNU3RhdGUgdmVyc2lvbl9pZCBmcm9tIHRoZSBjb21taXQgbWVzc2FnZS4NCj4gPg0KPiA+ICAg
dGFyZ2V0L2kzODYvY3B1LmggfCA1ICsrKystDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2kz
ODYvY3B1LmggYi90YXJnZXQvaTM4Ni9jcHUuaCBpbmRleA0KPiA+IDJiYmM5NzdkOTA4OC4uZjAy
ODEyYmZkMTlmIDEwMDY0NA0KPiA+IC0tLSBhL3RhcmdldC9pMzg2L2NwdS5oDQo+ID4gKysrIGIv
dGFyZ2V0L2kzODYvY3B1LmgNCj4gPiBAQCAtNDc0LDggKzQ3NCwxMSBAQCB0eXBlZGVmIGVudW0g
WDg2U2VnIHsNCj4gPg0KPiA+ICAgI2RlZmluZSBNU1JfSUEzMl9NSVNDX0VOQUJMRSAgICAgICAg
ICAgIDB4MWEwDQo+ID4gICAvKiBJbmRpY2F0ZXMgZ29vZCByZXAvbW92cyBtaWNyb2NvZGUgb24g
c29tZSBwcm9jZXNzb3JzOiAqLw0KPiA+IC0jZGVmaW5lIE1TUl9JQTMyX01JU0NfRU5BQkxFX0RF
RkFVTFQgICAgMQ0KPiA+ICsjZGVmaW5lIE1TUl9JQTMyX01JU0NfRU5BQkxFX0ZBU1RTVFJJTkcg
ICAgKDFVTEwgPDwgMCkNCj4gPiArI2RlZmluZSBNU1JfSUEzMl9NSVNDX0VOQUJMRV9CVFNfVU5B
VkFJTCAgICgxVUxMIDw8IDExKQ0KPiA+ICAgI2RlZmluZSBNU1JfSUEzMl9NSVNDX0VOQUJMRV9N
V0FJVCAgICAgICgxVUxMIDw8IDE4KQ0KPiA+ICsjZGVmaW5lIE1TUl9JQTMyX01JU0NfRU5BQkxF
X0RFRkFVTFQNCj4gKE1TUl9JQTMyX01JU0NfRU5BQkxFX0ZBU1RTVFJJTkcgICAgIHxcDQo+IA0K
PiBOaXQsIHdlIHVzdWFsbHkgYWRkIGEgc3BhY2UgYmVmb3JlICJcIg0KDQpUaGFua3MuDQogDQo+
ID4gKw0KPiA+ICsgTVNSX0lBMzJfTUlTQ19FTkFCTEVfQlRTX1VOQVZBSUwpDQo+ID4NCj4gPiAg
ICNkZWZpbmUgTVNSX01UUlJwaHlzQmFzZShyZWcpICAgICAgICAgICAoMHgyMDAgKyAyICogKHJl
ZykpDQo+ID4gICAjZGVmaW5lIE1TUl9NVFJScGh5c01hc2socmVnKSAgICAgICAgICAgKDB4MjAw
ICsgMiAqIChyZWcpICsgMSkNCg0K

