Return-Path: <kvm+bounces-54996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBEB0B2C825
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:13:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D149816E0C1
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 15:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F681283CAF;
	Tue, 19 Aug 2025 15:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FkMoPPFa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AB827E074;
	Tue, 19 Aug 2025 15:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755616056; cv=fail; b=k3NfZ2oIIww4qcg0gxNdxthRPF8yNeKBOfOhGWvncxysFucnR2KkUL/7x6PxFTQw2ehYU7ARkE0ycAQXOXpQsU3HyprOO6vMYNkAQaOWjVLS93U8aB6X3UpDxuwDJwFk9XSrifDd8oe5pfDuIMTXZycj9XxGbmTUplFeK9bBJuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755616056; c=relaxed/simple;
	bh=9yreB8RoTieTH0fWGFNQfHO54WOnKXkvsEn21cY2OCU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W3jx0lTP5aTQcZQl/RifX736iuwmKFM9KsCPYsrLPXYfJB+cDxelcCwf4Y2DTSDyieZ5t6DIjHxm4p070qCcOjfSJIctDnKYbdYkdAeWa/wfgioo4xJ8olgGF6dEdkby2dlruusm7KfJmDX3ya+IaJ3qe2rTIjJ8GXXXEKPhXVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FkMoPPFa; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755616055; x=1787152055;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9yreB8RoTieTH0fWGFNQfHO54WOnKXkvsEn21cY2OCU=;
  b=FkMoPPFaWWs9YOezYK/wlmVfhqHA58TYInxCd/V2S9EpW5l4RuQDtG/E
   z+Hf6zKk02ta2taj7029fEtcbcgi0/N2SsGuybIlcVb9SIH2QNtLu1lcA
   AQ7NJYiIS/JzsM6UiuGvq+Ea83o4y3gq+T1eqRAb+Dqb1vZy/kaknQofe
   VQz3RJ/MrreZYdF9fxCAS6V1GcB8jzo/e+CZdpiEv8w9bVwVUz/3aC4bY
   WMF0QoSFcgBaSdKAYA9MEM41Ba1oqwP3B2x0heN04IY8incH+x0xvUkjU
   Xqk9EXie2tfWZefI6j5nlK8R4P1I5FOkO0NLK6mq7Wot7GPP2cXcC3gGX
   A==;
X-CSE-ConnectionGUID: Tasi/RBvQbmVzryMus5eSg==
X-CSE-MsgGUID: HDHoCi2FQcGRz9o4UecLrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="83290323"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="83290323"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:07:34 -0700
X-CSE-ConnectionGUID: k4gU+pOhRHOiGHReYtaaSg==
X-CSE-MsgGUID: 6qdZSJF+Sy6tu4xtp9lUBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="167782395"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:07:34 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 08:07:33 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 08:07:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.76) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 08:07:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dbEvs1swF6nzdqDble1p1bA+w2eWeiIEAKHDChYaTNkpmIztgiRfcI/q0Lcx7y4BGAXVbcX4641IDJS+IKHRncqARYfPWRh6KPWSvpSSjwAtu1S/S9LsBKtzEXc5r6eFvD9HERUDvYpfCZqEzJtBsSpNwHfmiQIEBjiegI+dZCXVwrDzhT1ePt1CvhB1+DMBwPeAgQUnc6+dqgdpCmOcpA+tbGzVXO7Y9JMDauIhBCwdOZJtuWS3bdy5aELrrfZLFt6PKrO9IBNvubODYp6GOpgp0uD6nmpHWFslV6Ga56qU3a3OubiMAelHgr3HxFqVT21zhniORBEQnumsr1QfZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yreB8RoTieTH0fWGFNQfHO54WOnKXkvsEn21cY2OCU=;
 b=X9/LTEmUS6LLMOC8O9ZFERUNWA8qJVNDSIgdQ+0A74X91qdCm37UrGdXp9MOkdI1441eN19F12iW0v2It+ytSJGjFp4fxO8GirWlgcHNCv7IkunJniDKikgcBAvAzEbWkpiK7M8HXr7QkNH6uEP9XXg8GT8RS2czH9T9U/fS7ph+p4tKIe94MA4WCG42ifvbORA2/Xz6OPhMJQbxN4hIxJHpLfAjrvubfq+Fgujx2+iNbBPk0atsGBZ9cQYLA3yKajs2wYOHHh1tFMMJilQBfM1Sl4aFEtJ0sem9NGIxnQ6HVvamJuNyXaF5Wvn+usIFAMPFh8/lUlSj3w3+djPUDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB8233.namprd11.prod.outlook.com (2603:10b6:610:183::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Tue, 19 Aug
 2025 15:07:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 15:07:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Brown, Len" <len.brown@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Weiny,
 Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
Thread-Topic: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
Thread-Index: AQHcDrxaRC2HgQTKCkiAAwmmnxOsO7RodPeAgABPRoCAANa4AIAAfYYA
Date: Tue, 19 Aug 2025 15:07:29 +0000
Message-ID: <fb858e9d16762fbc9c44ef357c670c475f559709.camel@intel.com>
References: <20250816144436.83718-1-adrian.hunter@intel.com>
	 <20250816144436.83718-2-adrian.hunter@intel.com>
	 <aKMzEYR4t4Btd7kC@google.com>
	 <136ab62e9f403ad50a7c2cb4f9196153a0a2ef7c.camel@intel.com>
	 <968d2750-cbd6-47cb-b2fc-d0894662dafc@intel.com>
In-Reply-To: <968d2750-cbd6-47cb-b2fc-d0894662dafc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB8233:EE_
x-ms-office365-filtering-correlation-id: cf86492d-db46-4ff4-bf80-08dddf321d91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TUtRYXAyanRpRzVIYWNxMlhQTHM5b2duTmduRk91dG90TUU4SmJZV21UdXFN?=
 =?utf-8?B?aE1WNURWaTcrQmlEQlEzYXphRUdIL0h0cTRITk9TVHV0Z0NMQk1sRU9VcDBW?=
 =?utf-8?B?cXVJZ1NRdVpIZ2RyWmRWMjVvbUtMeVN0MWRQWVUxWCtHV1VtWDVqclFnTVht?=
 =?utf-8?B?RGtPK1NWOVpWL0dKYVZsUWFiSUtaMFNDWWdoaUV6MHpQcEJsb3JHMFk4aU1R?=
 =?utf-8?B?SzRzWHlJSkU4NGxKNjRxSFZMOGd5c2prNEd1VmN2akY4VjRGbnc5RkRmWkNs?=
 =?utf-8?B?bUF1bXQ0TDgxMFlsZVhBN0N5cE10dWxnR1Q2S3ducFFMUE5aMVo3WDFaVit4?=
 =?utf-8?B?c1ZGUWtaTDRnbHRieTgxM3ZHWEVkQ21oMTljaU1yR2IrTUw0OUxoTGs3RmVx?=
 =?utf-8?B?UExzME82YkNPR2VUdTg2WGc2SlVtRUNEOWVDUjF5UXNhRjZRWDR2czc2NmJF?=
 =?utf-8?B?M1NNZ1FVNmlQVm9GRlVDSEJPUXhtSkE5OENYaVdiazZDdFVESmRSZ1lUcHNy?=
 =?utf-8?B?eFBQSGt0OEwyRjgxY2NLVUU0OUkyZWlJVXFmMzJqbis5MkU5RnZYRU91c1RS?=
 =?utf-8?B?dWJ6OHdZeWVZek43dDNyeUJSbUEyNU1RaTcwYjcrS2lFNlA4YjZOK1VZSWxa?=
 =?utf-8?B?ZjA5L096TWxSVW5vU2NackJ1YkE2OVh0UkF0V3RPL1dNdmJCNlVENWJyUEJT?=
 =?utf-8?B?THJzUENEaGNrMytybkI0SE5oMjZPd2JnYWlIOElZMjFVTGl0STVkUTVwQ25G?=
 =?utf-8?B?aVd6SnJtdEhYVG5VNCtPYUZsMGdrMk9SZkZkRk8rQ1FIbXFSa3J3U09aOWxu?=
 =?utf-8?B?amZPazdielJDQ3ljdlRkYnVteGRYRFdCKzFnYUsra05QUmhwUE5qTlB2NkNX?=
 =?utf-8?B?d01KZ1JibnAxU3F1bnZFUm1kSytWZmdWMDQvSXFnQXpFOGRQbWpYRlFhZ0hQ?=
 =?utf-8?B?a3lzWFFJVHpkZTFBSlBnUGk0K1NKZys0dmJsTkE4UEFWd3dBVnY4YmhQV005?=
 =?utf-8?B?aVdZQTd1SFpEMWZuY2JZbE1ZelBFWkNUak50WUlYQnNyOEt6NkliVjQ0M2Ix?=
 =?utf-8?B?RFkvYnNSWFMzQjlRYWdvWjYwOHkrVXV1L0NjcnlRTW40dndKQkJjc3U2MXVW?=
 =?utf-8?B?N01XR09VemRwN01vQWhhZEM4WmNhYU5UTEl4TVVGb0k2TzhRTno2cis2bFFO?=
 =?utf-8?B?VW1sRUJZT2p6OElRZ0d2QTFldENxNDRWa3FxMVdWWmlzSWIva3cxcjVkRzRj?=
 =?utf-8?B?ZVVFUHI1MlNNV3RJUld6ejZvRFNEU2RPeEViKzQ2UjhBWnBuRmlYY1dPM3Iy?=
 =?utf-8?B?c3JVcmtDVGNlaHhXVlBVaElwNy9pZkFOK1FaOUY3Tm9uMTV6Y1pOQlo0MEhq?=
 =?utf-8?B?TEtDNnBQMVE0MjlKYjFTRm4wWFhOQ1BjYzlpckxydXZKWW9xMUNWK2hrQndX?=
 =?utf-8?B?QThUZldSc2JtR1pXeE5nTlVuMEVYc1dkTElLUU1UenNBWEJlTEpCTFpFWjZE?=
 =?utf-8?B?ZWRuN1Q5OGtndmpCR2RHdHByNWFLT1lienlXYWQ5bU1PN3NMYWtXZ1pEMGJk?=
 =?utf-8?B?Z0dZKzZRbFFzTnVmbzNUK3hER0tHenhxdDF5eW01QnlRYnVNZWpUSkprM1cw?=
 =?utf-8?B?OEZMcGxpSWh0bTdQZFhiVWdwbWlhMDA0UWZsMmU2T0ttWVNWdWovMG5MQlFs?=
 =?utf-8?B?aEtxVnpTNnhCR3JYbWkxcnFwZVhBNE1aMEFOeGNnWDJFSllDVDRiWlZhc21M?=
 =?utf-8?B?TkVqRGtZNHd1YkdMZHE1bHJOWi81UWhIM2kyanMvMUxYL1U0aExiOHJyWXJE?=
 =?utf-8?B?bC8yR2R4cUcvZGVhelZDV3RPM0NYQVlvQ0dRSVlSV2hmOWJPT25CbjROWk0r?=
 =?utf-8?B?OW5PVFdYNmsrVHRFaUJxTUNrT1NyTU4yRDZMeVdGaXNKRGRzelJMQzVFODFW?=
 =?utf-8?B?V0huVjJUMGRZakQzV2xzYjA1WXJEMzlqbjdCUjB3TEc3ZGdLaGNCT2Z0SUxL?=
 =?utf-8?Q?JbrzOQu27Bp9qpAjWQ5JEaGfP0kJ74=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cU5ZbzhscTExY0Q1aDRNVWNSTWFETkUzd0tVZ1VSSXdicjBFQ3M3Zkh2K2NK?=
 =?utf-8?B?Tlc1OGQvcnNpeUJQbWJnYU1tUEhYNXRoTnVZSWJKTEdqUHBXZHRvNTIzY0pv?=
 =?utf-8?B?MERZZlhjVktCNTZIek5ZdHBDdG15YWMySm9pOE8xTmwzNGprcjlEbzJEZUFR?=
 =?utf-8?B?YUJrYlFDUjIxNzI0dk92VXdNQXdJajRRTGVUNVA4MXNmU3I3K2h0cWs5WWRT?=
 =?utf-8?B?b3ZTYmhLd1YwZ3ZOd3VBK1NOVC9sWjRXL1Z4U1pGSlRxc1NyQ1JoSU1iR0FT?=
 =?utf-8?B?cUp3NHJRT1J1VjhtbVpYa0tvZmdhMEJhcnRDY1VnT1NBMEI1R0h4a3doZFVU?=
 =?utf-8?B?M1Fvd2F5b1dqaW1vTlNrYVh2RVRDUGJzUEpNYlFjdFFha2xjZCtGcVRFcVQ5?=
 =?utf-8?B?aElvREVQdjAvaXJHNkdkWDUrbjJWeEhHZlZ6aXQ5UlN6cUFwdlJoa2tkbGlz?=
 =?utf-8?B?VkVMMnBzOWh6aEVnWEcxbWFvQ2hCOVBqYlM5czZNWVJGdUhvTktpUENDbzBQ?=
 =?utf-8?B?eWRQbnV5a2pXa1UzdWRNcVptNkE4RVBrbWdUWkZvZkJ2NVFEUktBaTZLa3ZS?=
 =?utf-8?B?UGthcmtmOGg3SGgvVGh1VnZ6U2JKOUdNUDZRdG5wSVFZakR5TGsxanlrRmkr?=
 =?utf-8?B?aXRkTG9LVHQ4QmxudWRtQXJIU1pLZDB6cEgvOXFPa1J0R0l6aVlTbnVsMEIy?=
 =?utf-8?B?THVyYXBrWTVoV3o3Y2l2MHN4NnZTZ2pkNzlGbmxQcXBlZVdGSTJDWllpeFFH?=
 =?utf-8?B?dEhHVDlVck5CQ3RPKzdpL1B3SCs3dlJxenVlZ2owb0orQzlpMmkzeUVrTDFJ?=
 =?utf-8?B?RnFzQSs5L2Q5Rm01Q080bTRMV2NJRFE3STlQWjlkdUhJNUErQkNYdXF4b1ZS?=
 =?utf-8?B?UlFSTStIZFMvclF2cFh3aWplWUZjMUEvYlFIanpINDZMUlJSa04reHhBSXFy?=
 =?utf-8?B?aXAvWE51d3A0bVZnRGZRRkpOMkowMy9XblhFNkRxN0lFS1NFaUwwR3dsOG5N?=
 =?utf-8?B?c2I2aFZSaW9hUE9jdHF0TkFXdU5RY1R3ZkkyRTFsUDA1RXNrMGdVRlIwLzFt?=
 =?utf-8?B?RHltWlRxUWlGS1pVcmFQZjM1dlJGRHhPR2d3Vlo5dmFDRk11SU1CVnIvZTlQ?=
 =?utf-8?B?QzRIVG1pNEdQQnhlUCtFZURnSkV1d3pEK1hGM09CVlErV201cG50eE5KOGR4?=
 =?utf-8?B?V3B4ZEhVajNpUkRYWi9VT0RoM3ZlUG9TUVFTVld6ME1MTmdXbTM1blpSR3dr?=
 =?utf-8?B?TTdmZ05nRHpFTUZmMFl0S2JpMW1iWkJHaVlWSGNMSEZmcmQzZ1c0Ui85bGxj?=
 =?utf-8?B?MW1kMzRlamhvbTc4bHNPTTFJQitzL3JHazZkNXNMbVNMRThEZXQ3MVBsMkVD?=
 =?utf-8?B?dzNhZDg5cFp4Z1c1SEdOTFJLckVmUzk2UnNpSnlQeFl5VWVCS29rWWROVm56?=
 =?utf-8?B?T1lWSURxamwvdXRMYzFzcy91YXdJMVdHdDhsMElFbkpUREdhdXVaT1czclZa?=
 =?utf-8?B?Slg2eklBNnJvZDdETWtiWTNoSkV0WXdSRExDNXhBWTJySXBCMUFpcmFkWGl4?=
 =?utf-8?B?RnIyR2xzblF6UDBMcTdDU3BPaG5sbnd3aUsyRkZpSG1ycFBDVE0rVjduYlBT?=
 =?utf-8?B?RDVtWkErRGI1QXpWaWpkeE42cTRiRGJlcFYwQkg1eStYMUJob21pTm8vcjdK?=
 =?utf-8?B?RDFxbUF1SFlMVUd2MjZvNjZDamd2OWxlVEw2Q1JNMmVVZTNaR204RnFFc1Zk?=
 =?utf-8?B?RTF3UmU0N0dpdmp3MEdFMnE2dWVBbmN4ZHQ4WVovb3QwcUhCeFpVWXpwSGhU?=
 =?utf-8?B?QW9NQ1VHeGh4NG94R3IzZ0JhNFk2RmN6U2huc3lJTE9ycUc3QlJMVE83aXA5?=
 =?utf-8?B?QzZqZFBQQ2V0Tm1BTTNaZ04xRWVJRWY1dms0WUQ0UmFhMGwxMis2VVJGakNW?=
 =?utf-8?B?c3Y0Y2I2NDQyOXpvUXRlU1p0cVNFT2FUeVNwc3gwdy9OQW4xeHdKTlhWSGUx?=
 =?utf-8?B?TUZ1VmxONU1IN3lUVmV1YW5kWFdJNnZBUmVPbnBwcFNrdFJmR3pEZlpLRHFT?=
 =?utf-8?B?MUI4WkNrSlhNbm41bGFSdHpjQ0tLTmx4bC8wNVR0aThkM1NFSit5WWJQOG9u?=
 =?utf-8?B?anFybUNNWVpTTjBHOGZFU2ljVTNTTkpGcmVJWnNCaU9lUk1uT3FDako0cEli?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCF9DB651B438342A56CAADDCA8C0EFC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf86492d-db46-4ff4-bf80-08dddf321d91
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2025 15:07:29.3603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aKNU5W1kjuJapNuYvGYr7OQb0fxBOuRvGeuDcO0qlwEPbqN55QAgXgBe9J1vmIeJnyoWMprNLvhJxZ0Six7xQ+YLBSM8brY9PQEtvtIIb+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8233
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTE5IGF0IDEwOjM4ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBPbiAxOC8wOC8yMDI1IDIxOjQ5LCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiBBdHRu
OiBCaW5iaW4sIFhpYW95YW8NCj4gPiANCj4gPiBPbiBNb24sIDIwMjUtMDgtMTggYXQgMDc6MDUg
LTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiBOQUsuDQo+ID4gPiANCj4g
PiA+IEZpeCB0aGUgZ3Vlc3QsIG9yIHdoZXJldmVyIGVsc2UgaW4gdGhlIHBpbGUgdGhlcmUgYXJl
IGlzc3Vlcy7CoCBLVk0gaXMgTk9UIGNhcnJ5aW5nDQo+ID4gPiBoYWNrLWEtZml4ZXMgdG8gd29y
a2Fyb3VuZCBidWdneSBzb2Z0d2FyZS9maXJtd2FyZS7CoCBCZWVuIHRoZXJlLCBkb25lIHRoYXQu
DQo+ID4gDQo+ID4gWWVzLCBJIHdvdWxkIGhhdmUgdGhvdWdodCB3ZSBzaG91bGQgaGF2ZSBhdCBs
ZWFzdCBoYWQgYSBURFggbW9kdWxlIGNoYW5nZSBvcHRpb24NCj4gPiBmb3IgdGhpcy4NCj4gDQo+
IFRoYXQgd291bGQgbm90IGhlbHAgd2l0aCBleGlzdGluZyBURFggTW9kdWxlcywgYW5kIHdvdWxk
IHBvc3NpYmx5IHJlcXVpcmUNCj4gYSBndWVzdCBvcHQtaW4sIHdoaWNoIHdvdWxkIG5vdCBoZWxw
IHdpdGggZXhpc3RpbmcgZ3Vlc3RzLiAgSGVuY2UsIHRvIHN0YXJ0DQo+IHdpdGggZGlzYWJsaW5n
IHRoZSBmZWF0dXJlIGZpcnN0LCBhbmQgbG9vayBmb3IgYW5vdGhlciBzb2x1dGlvbiBzZWNvbmQu
DQoNCkkgdGhpbmsgeW91IGhhdmUgdGhlIHByaW9yaXRpZXMgd3JvbmcuIFRoZXJlIGFyZSBvbmx5
IHNvIG1hbnkga2x1ZGdlcyB3ZSBjYW4gYXNrDQpLVk0gdG8gdGFrZS4gQWNyb3NzIGFsbCB0aGUg
Y2hhbmdlcyBwZW9wbGUgd2FudCBmb3IgVERYLCBkbyB5b3UgdGhpbmsgbm90IGhhdmluZw0KdG8g
dXBkYXRlIHRoZSBURFggbW9kdWxlLCBiYWNrcG9ydCBhIGd1ZXN0IGZpeCBvciBldmVuIGp1c3Qg
YWRqdXN0IHFlbXUgYXJncyBpcw0KbW9yZSBpbXBvcnRhbnQgdGhlIG90aGVyIHN0dWZmPw0KDQpU
RFggc3VwcG9ydCBpcyBzdGlsbCB2ZXJ5IGVhcmx5LiBXZSBuZWVkIHRvIHRoaW5rIGFib3V0IGxv
bmcgdGVybSBzdXN0YWluYWJsZQ0Kc29sdXRpb25zLiBTbyBhIGZpeCB0aGF0IGRvZXNuJ3Qgc3Vw
cG9ydCBleGlzdGluZyBURFggbW9kdWxlcyBvciBndWVzdHMgKHRoZQ0KaW50ZWxfaWRsZSBmaXgg
aXMgYWxzbyBpbiB0aGlzIGNhdGVnb3J5IGFueXdheSkgc2hvdWxkIGFic29sdXRlbHkgYmUgb24g
dGhlDQp0YWJsZS4NCg0KPiANCj4gSW4gdGhlIE1XQUlUIGNhc2UsIFNlYW4gaGFzIHJlamVjdGVk
IHN1cHBvcnRpbmcgTVNSX1BLR19DU1RfQ09ORklHX0NPTlRST0wNCj4gZXZlbiBmb3IgVk1YLCBi
ZWNhdXNlIGl0IGlzIGFuIG9wdGlvbmFsIE1TUiwgc28gYWx0ZXJpbmcgaW50ZWxfaWRsZSBpcw0K
PiBiZWluZyBwcm9wb3NlZC4NCg0KSXQgc2VlbXMgcmVhc29uYWJsZSBmb3IgdGhpcyBzcGVjaWZp
YyBjYXNlLg0KDQo+IA0KPiA+IA0KPiA+IEJ1dCBzaWRlIHRvcGljLiBXZSBoYXZlIGFuIGV4aXN0
aW5nIGFyY2ggVE9ETyBhcm91bmQgY3JlYXRpbmcgc29tZSBndWlkZWxpbmVzDQo+ID4gYXJvdW5k
IGhvdyBDUFVJRCBiaXQgY29uZmlndXJhdGlvbiBzaG91bGQgZXZvbHZlLg0KPiA+IA0KPiA+IEEg
bmV3IGRpcmVjdGx5IGNvbmZpZ3VyYWJsZSBDUFVJRCBiaXQgdGhhdCBhZmZlY3RzIGhvc3Qgc3Rh
dGUgaXMgYW4gb2J2aW91cyBuby0NCj4gPiBuby4gQnV0IGhvdyBhYm91dCBhIGRpcmVjdGx5IGNv
bmZpZ3VyYWJsZSBiaXQgdGhhdCBjYW4ndCBodXJ0IHRoZSBob3N0LCBidXQNCj4gPiByZXF1aXJl
cyBob3N0IGNoYW5nZXMgdG8gdmlydHVhbGl6ZSBpbiBhbiB4ODYgYXJjaCBjb21wbGlhbnQgd2F5
PyAobm90IHF1aXRlDQo+ID4gbGlrZSB0aGlzIE1XQUlUIGNhc2UpDQo+IA0KPiBJdCBpcyBzdGls
bCAibmV3IHN0dWZmIHRoYXQgYnJlYWtzIG9sZCBzdHVmZiIgd2hpY2ggaXMgZ2VuZXJhbGx5DQo+
ICJqdXN0IGRvbid0IGRvIHRoYXQiLg0KPiANCg0KSSBkb24ndCB0aGluayBzbz8gSXQgZG9lc24n
dCBuZWNlc3NhcmlseSBicmVhayBvbGQgc3R1ZmYgaWYgdXNlcnNwYWNlIGRvZXNuJ3QNCnVzZSB0
aGUgYml0IHlldC4NCg==

