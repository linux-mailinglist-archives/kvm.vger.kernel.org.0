Return-Path: <kvm+bounces-38546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F406A3AFC0
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 03:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 847BD3A9D52
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AABD019149F;
	Wed, 19 Feb 2025 02:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MgxHqoRc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25821186294
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 02:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739933001; cv=fail; b=oK3rg/ZcYLl10mP3s/idIZzPfM2h04lt4MF3sX1kz62J196oeaHNU1DYvvgaC82s+9aeBz5tBcP77ycJMtMShlnlpihIXBoDulnoTqqwf01lbkt9UUoabpEr1Yxg2DLxYdGlQA3gaJl0zGbqDiwPDDcGN1aafF9MK9UeNrCZGLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739933001; c=relaxed/simple;
	bh=8vfEax9swYWmFLpjfSK7W19B8HkEUBrjbjuiiTyB5nM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=g+cymXzhjBNiA+uocKsJvEjoBrLF1FnzGw5wbb0/wNFV9rwD7RWGD+sr3h07Cd5rXb0qkY7VTnO2+h2no1d96EGlhIW5Qh7bw3Wlf16PGHQIKMV7khuNpmKzE0TswfQdnOSDuP0V+N//8l8hBhZxfb1r4ke+6ZI75Zx0CwNLs40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MgxHqoRc; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739933001; x=1771469001;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=8vfEax9swYWmFLpjfSK7W19B8HkEUBrjbjuiiTyB5nM=;
  b=MgxHqoRcTmj/OcB5HPDUWDv0yd9bh2mScXRwTdtxLWpv6eAzuJNalxL1
   LleWr9EPcUrCJUDzSC73bedWOXF8tMyWT+ldwkf6+pqFgHpUkbf8oz8RW
   kNQW9yHpkgHoVODaocRiFm2zTUoqz83cXF65b9pA71AnT0Eff65iabfMh
   dP9DYsFZpDNrjJ5gtis+2XVcCp/26GZwyD0bo4NUUE8MfqanllFNq4IWd
   LoMXGZuQgeQk3/tKnS/n8SQ1Oc7J/0VS9KZ5BedQ7vEXc86AJ5mVuipMm
   1iKH/c9FRwKML5+HvX3Zs0aXM45KZSOiDvk0gyrNhjwRr0fFZRzmEpdMe
   A==;
X-CSE-ConnectionGUID: MKnQf+hoTdSo1Pq0dDi6hA==
X-CSE-MsgGUID: Z2rBqsJnSAuIM8oNzs1zBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="51638464"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="51638464"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 18:43:20 -0800
X-CSE-ConnectionGUID: 8ZI6h5maQQ6P/9Gjdm4gUw==
X-CSE-MsgGUID: 0S/6r79+SCO68Tcu8ThKMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="145430670"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 18:43:20 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 18 Feb 2025 18:43:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 18 Feb 2025 18:43:19 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Feb 2025 18:43:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xkPahCXDUMgDf65nFL+thRFCF/9AgB07ZUKhE7u/rYFjlokhawvUT23HDqJJAOpVrlITRg4fkpZLJxCi0EZC1vp/JB5a2ZOHt2JYdgmTHGCL/xSNJx3n1B6DD7Xz3ncLSXeo1uT52wAxzKN8CqXLklhxjk90q5yYOOUZLrwk0xn9f7iuB0b++vZL0/8qn+H99+xQmC7SsFmdK0S63lTmGt8f7mGUpCf4yVZMt0v37ky+53wSaO6gw60ymFwjWtKbDt/dSWuF5iMLnsfn4rVciI4XmDZSx9zK8KYEZNmjQ5sAdRMxSixGsvxQKZ/oZhBHQCM+53ha+b6m2DKshc7sZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vfEax9swYWmFLpjfSK7W19B8HkEUBrjbjuiiTyB5nM=;
 b=zL9YnJ6UQXxMu6BcW2BCIh1dH4uO9DDaXx9bO+ocSSCvShrbGqRFIv/+NR4XWpl/ZNI40A//7Wum4nLIa7oGplUHb/zYVzbuLASZRhWS1NK2SJp2fK0yQLa9x9dbRtkZjb6vy3vvCNO3kbNCurDOu0g+wjOJ4tCv0fqJdLuxHFeLFZuHBF3sqEIdMAMekFKzoCiTk8ybh4Nw9Dm+/V9NVb0qlZJaAbRJXZLSSNBly2OOwNm27y8o/Lv83wS5wIhqdx22t1ML1iMNykiKKr2PFz3vvBON98UAcAhiVaYK+0f7cCcd3KRwpj/RisAciBRlwqyGTnTXUmBb8+pJ/pe2NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7494.namprd11.prod.outlook.com (2603:10b6:510:283::18)
 by MN0PR11MB6134.namprd11.prod.outlook.com (2603:10b6:208:3ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 02:43:16 +0000
Received: from PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::353f:c8a8:2933:d288]) by PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::353f:c8a8:2933:d288%5]) with mapi id 15.20.8445.013; Wed, 19 Feb 2025
 02:43:16 +0000
From: "Chen, Farrah" <farrah.chen@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Lindgren, Tony"
	<tony.lindgren@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>
Subject: kvm-coco-queue 2nd round regression test report
Thread-Topic: kvm-coco-queue 2nd round regression test report
Thread-Index: AduCdwN0DXQnfttURYaJo0mXE0hcLw==
Date: Wed, 19 Feb 2025 02:43:16 +0000
Message-ID: <PH0PR11MB7494043DDF4D4CAF416FA229EFC52@PH0PR11MB7494.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7494:EE_|MN0PR11MB6134:EE_
x-ms-office365-filtering-correlation-id: 67de8e99-d2cb-48cc-cfeb-08dd508f2991
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?6jFpIyolGGxnGEp+R3Uol9kidkwJTD9XyV62uSbXr9F8FwwnHuPx0FKB3tFH?=
 =?us-ascii?Q?ploT0hyzULud0WhjGyFTNbDl8dvx2+izz0ZkQvpfCj1ihLJc/yh6A37J4jqO?=
 =?us-ascii?Q?VGbuZ1H+bFFpGQN63FTNrOv8oiUiS+6AYf5ZE4irpoXMXjmEBplUJV2nwbuI?=
 =?us-ascii?Q?96w4PG8dKZYzrKN4LTjYRqaUUJvlJtwch8ENwW9PQ2chaWTRjn5C5SYhvmNB?=
 =?us-ascii?Q?YHsA/5cBhlUWbSba0rMEeS8Cy5OoBeJLt8L0bPzdvHXQlhf5nXEC9ZQrD/GT?=
 =?us-ascii?Q?Kmu7f6C7p9PPZCYghpkcigXlz5zhI+TfnD3BjeMJAHGUrf66gRIukhHPm/5J?=
 =?us-ascii?Q?VIuTcRk4zHmd28iUV37zKd2iB3tOq6w29SFYoHYTiL3irU28yjXt8NDOTc3m?=
 =?us-ascii?Q?slpa94TqCQrE3F95Qmr1xW7Ik9RqSngUvnxPw3Z+OzsY4AOdN4plfO8zWWh2?=
 =?us-ascii?Q?e0gQpm7LUVXsapmMlePXnNQzq0iOqpI9RaRrOUaLX7or56NV62RR13py1jKa?=
 =?us-ascii?Q?O56Ymc1RPI4tLDXXD6AdR8PRhccb9Ixd5jg6iG3XAKy2+TCwsBVTjrgJCmin?=
 =?us-ascii?Q?KA9n8RUq+lt0Tr7zBJWSfAxr9nUI/p2wykQTU+3Hy8L/b2g+s1jv9xsGu8Xo?=
 =?us-ascii?Q?AkPB+UVQbrSBzsPfhfCsQdgXpOcU95pKRlylP330zo8zoVB0l3jzHjP0QhS9?=
 =?us-ascii?Q?9yNXQFj85T7E+MIJ53WHlbjW9asQbim0hjlZ3GLtLJQ1uX2pad6zLLj2icSj?=
 =?us-ascii?Q?u36SeWZhFZUL92cuXX/fDz98UcHujrNF655grjkEAnntLx/4PcG15aNZixP7?=
 =?us-ascii?Q?1CQejtC7vOeSrFC5Y7uQXEZPThm8k35MwLFZPzMu82m7UMfALRAK7X9MPYZT?=
 =?us-ascii?Q?0XvijrkGisPwSSTe2rMrBPqYvHVHdlb2b1aebHzxEicHRBMx6gkzhs7boLmm?=
 =?us-ascii?Q?HNg3qdpe14pmaUwUeUNUJPBVoZBN+/bF/dzolDoDqJUZsX7RuLw/+Y3VSsXi?=
 =?us-ascii?Q?uB5ttWlQXgK02IlVkRgJXuswC2tTfAo2AxRoAG8uWUGXOXuRAp82BMjenah0?=
 =?us-ascii?Q?3mTTGN2wAipeVOOfxfVIuYosjfjQxz2WFmazrkHAQgxyRDHlp5Q7vW+ru9XP?=
 =?us-ascii?Q?B8sEjwxTg9JGZz6wCNq4KaBz6qJ08RAUhRQj1w5d2imIBktFi/T6ymdRF73k?=
 =?us-ascii?Q?KoBLY10Kqba/hm82oFO6fqbUrNMAHr5JBh0yWhmcSNQHsztOIrCoUIto1Ixn?=
 =?us-ascii?Q?hEx7Mmb2hNPLS1mOCntGtkgTxXSApC3CDENEFyB11lSIsGgouqg1pibM/ivr?=
 =?us-ascii?Q?UlkYbpYRejknmwnb0EjPBUa/hHwNZ/kRQC5PgCcXavFTi3nO0OK/orIAT3/V?=
 =?us-ascii?Q?pP0HBvFlNtVAxltahAzhM0ohFYZa13X1gyP2VW8thDVcDqz3jOECOpVelYnE?=
 =?us-ascii?Q?qkdCI9+bKPHtPbS8gUoEgxw8S1vxSOF/?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7494.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qyYhO1SyufZ/PRwrBpGeshMyiIAmVUGPMZuesTDsdMGz9779ONC9FWhZo4Gt?=
 =?us-ascii?Q?VfFx5xOntXFbR53eiKPDYZy8kJOX7YOnjxnteTS2vS8yRObcEPy3N6Pq7Z/+?=
 =?us-ascii?Q?pdsNR01CMRIKCZDf5wgxFMGio8fYNTS9cC4H+3Zz+YWYNdnoU0ralC6fvamY?=
 =?us-ascii?Q?LzjPSQOXas41UBkWRUQw45W2ftb57mj+svcWUS0EJXv1i3Uw8JJZyGBraGQB?=
 =?us-ascii?Q?njD5L/qKR7ggXMOMr2UOV6rYroKYqT4gvGMyhT8zlwLt2zC2gKolMlqheqUn?=
 =?us-ascii?Q?U/AYCI6sixk7pa8dcpT+kQsJyphJ9NWdjeJ8pJYkWocc7jdI3IwLrpBxZEs1?=
 =?us-ascii?Q?NeKvzGBYWhUSkUvwisVKjq3F8j2yhm7+i2srREFJ40yK96U342TdqLb4o7Dw?=
 =?us-ascii?Q?9QkArVQzG4Qu0XTrrs0N/OZW2Gc7MqGKxaxH1ef5/rNq1pGIPGdbC+lv/Cf0?=
 =?us-ascii?Q?/IYGt9PHyhIAdCOr4h93eG2Vpdoje/64yWqQkAVJUVU06X0jUQ8l4W4gETs4?=
 =?us-ascii?Q?GnskzV+D5bX5bhPPhhLCksMUGKvXC/x32vRn1rUuWnCFiemPhCoObyrJ8djD?=
 =?us-ascii?Q?9KCPKzihw/6CZ1sNQJiY6nn/RCYeBugld7qk0iDt9dNIx0m31y19ZJSAyY9L?=
 =?us-ascii?Q?6UidiSaY2zEjAp2yyEnt2LWq6oHIYgxC/L+46OJfRyhYi/Qu5BrJnnKAC+8d?=
 =?us-ascii?Q?14myhrt+3bugpRCYJoi97JYCPdIIgxDr+fL97AdSoVKJiYfyCcAAiDFGTvO6?=
 =?us-ascii?Q?0R+2kYVq/pVjJAhA95Xyr58YptEBpeNL6SxCUR5XI1N9r6Erlmqz2kFkl3nN?=
 =?us-ascii?Q?tRhQHrErLW6CrwzdB3wC6qFDaEBm/+JcYiHLX5n3vrc4oCucqjDD8y9ub+2v?=
 =?us-ascii?Q?CN45o2hrlLRxUnThH9a4n5YznQqEBx88PG5DPyMnTq+yR3oKPdyuxZBLL0jg?=
 =?us-ascii?Q?63vTcLLR5GkizjPuMyJU9TLkr9JYf3Q6bOMQwa5cAqBsGWhFC3gQ/RrOn8pu?=
 =?us-ascii?Q?KecaB6MYnAgEHu5rKFbS+8lj8MRVUD5R0PCLcJ9oGSnz5U8noAhZnZMdpZW3?=
 =?us-ascii?Q?Ts+awMcsxKItINHNsjwQkr7FVXueVkndsdvpY/cMVc9y5lCdQvkVvbh9q0Vi?=
 =?us-ascii?Q?n0G+s48dR4Mk8XUpaoXI07q/bMo5QJuqVDhyConwqRc59xwZx4GKC21MMb6s?=
 =?us-ascii?Q?8TRTiHJC7yuw7hTO1aNZ4o8+DU7lMVnmT6KEozB8wFrRfWJUWIyIjIEsj3C2?=
 =?us-ascii?Q?I93QQetVrcn4XTmrIGQvOgKBuMgww/F7ISa4JCu0ICigSr4NtPnn/SN+YVb4?=
 =?us-ascii?Q?qjBVEPFCD0BZkGtGfdpkhh1jQBUTx0O84CXqEsZjZsO+nnqFjZuzwsJg0gbL?=
 =?us-ascii?Q?/6XbVxt7VzgzX/KMiDXSgXs4o9y9wkzT+GbbbhZ9cD7m80fRXwjvZLfPpAEy?=
 =?us-ascii?Q?3+IcCL20SAgzFpWvY6OM05+k0XS2Zjdy5VJw1Abp5Xl8IGmjED7B/kLcfxjn?=
 =?us-ascii?Q?WRKuQ6bLwtiWxNrg7wkauVM51hlQqW+4BWcicYhPsycY7Pn/IwQs5NOKGb4j?=
 =?us-ascii?Q?UJuJun6W1eiV0afQ24GaRWhcuVaK+e26gCdpvLJZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7494.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67de8e99-d2cb-48cc-cfeb-08dd508f2991
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2025 02:43:16.4202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RPgjKdJf9zvb9vZ0egMARQf65OSC1yuNjTBPpIBcJDW9EEQs4ap3ldaaS2hhjpXod+GoD9q8b3rykAykzFjMCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6134
X-OriginatorOrg: intel.com

Hi

TDX support in kvm-coco-queue has been rebased to 6.13-rc7, we thought it's=
 the time to do a new round regression test on normal VM and it might be us=
eful to share the results of our testing on the list. This is in addition t=
o the normal suite of automated tests that run in our CI.

There's a known TDX issue in kvm-coco-queue, the fix has already been poste=
d[0]. No other new issues were hit.

Details
--------------------------
Test Environment
CPU: Emerald Rapids
OVMF: https://github.com/tianocore/edk2/tree/edk2-stable202411
Host/Guest Kernel: https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=
=3Dkvm-coco-queue commit: 50b7294b
QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v7

Tested features or cases:
- Basic boot
- Boot multiple VMs
- Boot various distros(including Windows)
- Boot VM with huge resource/complex cpu topology
- Stress boot
- Memory hotplug/unplug, memory with NX hugepage on
- Memory workload in high/low memory VMs with NX hugepage on
- Device passthrough(NIC)
- Live migration
- Nested
- Intel key instructions
- 5 level paging
- Bus lock debug exception
- PMU/vPMU
- SGX
- Workload(kernel build) in VM

[0] https://lore.kernel.org/kvm/20250211025442.3071607-6-binbin.wu@linux.in=
tel.com/

Best Regards
Fan

