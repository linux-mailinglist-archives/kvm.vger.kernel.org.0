Return-Path: <kvm+bounces-43417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F27A8B6D5
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 12:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 006F93B309D
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 10:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B188B235371;
	Wed, 16 Apr 2025 10:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BXP6xw4/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE40920125F;
	Wed, 16 Apr 2025 10:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744799729; cv=fail; b=pMvCWL/A84hC6KVLPhqEUQb0/JyOP4CdlkKNCeJtxjVcqfm2xClX+Qzk2TiuN6wMBjY9TGC0tH8POeLx5fA2q0/UrRYTp3o4VWVzjQdU8fouArWgFaHiDsfPpbRfCN6HODZ/KnFH2DlKETca4bp2+ysITNxL4IHHMzpzXsRaEBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744799729; c=relaxed/simple;
	bh=h+hgjG0gRhEVFVDSUtQUNyNHoYwSFH2EDUSDJiJOc+U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hzln/iv9SrWLjJnv0ZcqQuYiwlhrpp10G9txj8rgC9htXr0Ff+ZdbP6l6hubk4P60O1SE+RPolEbJs09Wx6xZeC5uNsBCD6+w806rG+RlCcDT+T1q/E6D2ApeVq1z8iJwt1wZ9VHNMvmIe/lnzrBX8M2bY4u9i7mwORieUs0O0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BXP6xw4/; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744799728; x=1776335728;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=h+hgjG0gRhEVFVDSUtQUNyNHoYwSFH2EDUSDJiJOc+U=;
  b=BXP6xw4/dwsluFJNKenC0WEfx/QiQMykkiSPrwuPmSpe+74OkNVQXO/8
   myNKQ9S2cLevGlBECDbT1ks6b2N+UBF91EB6JXK8Z2Dovq6tJ1KfjlugL
   h2Cn1g1ZhlnL0biP0Wk9+pYyQjtyYMhfCVw2JuqjDz41M3nBNO6kdHAdz
   e8/+niRjTriUnK/z+X0NQh3HXA6x/Y4nLzCzCiEIOxztK6x94tRN/dqpQ
   CXjIpqqiXMXhcJ0JbmHasMhpICAEnkRuVB+ZM77Do98Q6yW3GU0fjeF2Z
   WJpE7FZdAfHQKN88h5WafbJvQREPW+V2Ol6Yyl+Hxe2ge+U1WYy9YsTp3
   w==;
X-CSE-ConnectionGUID: vX8YnSfzRmyjG2VKl2aksw==
X-CSE-MsgGUID: JbfbZ9cSQiSFKUzBAOooXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="46230636"
X-IronPort-AV: E=Sophos;i="6.15,216,1739865600"; 
   d="scan'208";a="46230636"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 03:35:28 -0700
X-CSE-ConnectionGUID: RQA8edHTQzKlmSB3DO73nw==
X-CSE-MsgGUID: WtWkBtSLR7+ZusWaw0a53Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,216,1739865600"; 
   d="scan'208";a="130272583"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 03:35:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 16 Apr 2025 03:35:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 16 Apr 2025 03:35:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 16 Apr 2025 03:35:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vSitDD6mwP+5Dyab1awiJlrv24gMkQbMQpa1ruAscCs5d3TwKwRq9S+ng5gl58z3ItOrs6wNt4BNg3QuQKZjD/HJ8bj8L4aygv42omgV/z47kJh4GJaKEPUkMoukSfI50H1u5hL4tubDP6mfocD2qdO0rZWlPOQKpk3DU0EwXvH5vBpZ6s/zZPdioiKccGTaYr6K1P7wD1C0qusf7Cx50Sc+PLv6Ls7ybr86cJJb/3b9WhSVppeVbyt8XT9R6lpeNQmZHpQWFhACedp3wQNlW1LbC/Ur68nfkYf4HySTYOZxofD1vLYbu6cHsFHPSD+DYzzjYNCQE+HLgh/QL8ouxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+hgjG0gRhEVFVDSUtQUNyNHoYwSFH2EDUSDJiJOc+U=;
 b=uK8VrlM55woj1wz02GxThDTKC3w55sn7JSkjHuDzNUbIQpOQvdf9f5HVvEkthWzDQbQ/0kAdR7rWqce85nAb0ybHBv6hrzPh0z1B1al/h/SJiy3lDGr7JM2qkTX63rHVp+W4PgWaxW/TI+mGOE1w8fbzPx16G44Zyim+o/TAY8Kb8GQChThFKG/NEkpTX7nIF4ey3UNvU4N95zG0cRGd8Jsp9dz2rEzDey0jgzq7IQ9YgbCDq3IQ0gk2tQ578S9hu3jqG70SZ7qx/lvNLvge9eL+33ATGIM2SIFUlWlKNE5TDeMh+psrTHdbNhjD09FUWnyrR/+zjUZzClZ9hqWiVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5265.namprd11.prod.outlook.com (2603:10b6:610:e0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.21; Wed, 16 Apr
 2025 10:35:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8632.030; Wed, 16 Apr 2025
 10:35:23 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "mikko.ylinen@linux.intel.com"
	<mikko.ylinen@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Lindgren, Tony" <tony.lindgren@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 1/1] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Topic: [PATCH v2 1/1] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Index: AQHbrpPkPamwkIQ9FEGkv2NeYzoB2LOmGVkA
Date: Wed, 16 Apr 2025 10:35:23 +0000
Message-ID: <225123a8632172a08ffb9adadfffdf1ec36d6f09.camel@intel.com>
References: <20250416055433.2980510-1-binbin.wu@linux.intel.com>
	 <20250416055433.2980510-2-binbin.wu@linux.intel.com>
In-Reply-To: <20250416055433.2980510-2-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5265:EE_
x-ms-office365-filtering-correlation-id: 7d21daa0-07bd-4615-1b5a-08dd7cd2650c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aWFkWlMraFdENUZycVpyQVpBdXVwcE5ZaVh4V252M09QNmdBb0RGUE1mVUFJ?=
 =?utf-8?B?V2h4QjdPb2VyczN5eGoxbkMzTzdaZ2FjM0s3L3FZQ2VMVXRPVzNlaWNSZGRr?=
 =?utf-8?B?VTcxa0lIdDhBNjkrS3ErdzRmTkIvWDYrTlRMd1lCRU9lZFMxbEZBTHY2Wm5B?=
 =?utf-8?B?M1VQSjJUNVRtaFRZSHVqY0hCMGdjVVlzMlJwSXdqeldqVGd6amhESEpMY0Fx?=
 =?utf-8?B?b3hlbGFqcHR6elFjTUNjWTBRdmFqNkVCOStBQjJsbUthWm9TRnNJVUh5SnlY?=
 =?utf-8?B?WC9tQkxZM0hlMkIyZjgvUVdvUFhnN2R0Ny9kOS81WERqeUw2MXozY1BWc0dQ?=
 =?utf-8?B?NTFJSTJPLzkwNGRhaDdPZnp5Y0paQnd6WjlKZUZZQmhNcmxBd09oYVN0amN3?=
 =?utf-8?B?R2dUSUh1cWxzaEczOXMyZDlFYmRGTEVEdEV6U1A2bXhlOEs1cW8rTUNucFRk?=
 =?utf-8?B?U0tqdXIvQ2VvUFNpMjI2THRZV0RyMDNFVlQ2L1o3REhzMENmUE0vV0NrbHdV?=
 =?utf-8?B?dUxhUkpwN2ZsUjFoMlFjSkRmWEVlWGtSc3VES1Z6VG9YYjVPdnByaUQvN2p0?=
 =?utf-8?B?R2VYTmlWMmtZbmZiN3JJNm1iZjRtRnFVajRaT1ZQa01GbFRoZzRIeFR1QjVw?=
 =?utf-8?B?cW5sbEt4NU1PU3hXSm10dkhnTG56QWFnZjBkRHZMUmE0RnFUNlpETUltUjJr?=
 =?utf-8?B?d3pzWlQxNUFnTUEvQVZkZ3JQL3Fwa3UvWnJZdHN1bTg4dVBHdWVGSEVZZVBk?=
 =?utf-8?B?cFZtMEZQcFF0ZHVrdVJ3SEtkK1RhMmp6SGJGekRuQnAzK0pQOHRlWkk5dTNr?=
 =?utf-8?B?T0lxM0djc3pmRmZGRlIxRGZDd250WCtWcGVQQkNpVm1PQ2M4TTBOODhxYjRq?=
 =?utf-8?B?SUpHZXFMSXBuTTZ5eGhFdWdqUDlNUVR6Tjd6SXNydVo0cFJkM1JTVmJkT0Uy?=
 =?utf-8?B?Si81MWVCZ2dDd2ViMW5sUmE4R0FWVjZzMGVVRjZYT2s4NzlnUktaQitpRXc5?=
 =?utf-8?B?SnBFZFdaM0NGbE1sSnoyKy9NRzVabHZHSlVnaDlUKzl3NWRoQTl6QnVDWk9t?=
 =?utf-8?B?bktwRDBpZUk4L1cvbFpONW8vNHNwVFZEbVdtYzV5VHc1Z29TYjM2cWRoTkpE?=
 =?utf-8?B?cGtvVmlwZlJTanJjUHNIMFVPSytjeDZMT0krK1JXT3d5VmRnTmNZcytZa3Vz?=
 =?utf-8?B?bXBZWFN0MHo1V3Jndk5LbmpVaGc1T0E3eWo2L3ZNeTY3NHM1QmhiYklUZUVI?=
 =?utf-8?B?UHBRYWVYNkk5RGlLQ1pHYm03TVJXL09HOC9JaUdWMVRJSTNLRXMzNmNpeGNQ?=
 =?utf-8?B?c1Y2T3FkdE5Dcjh2eVN0MDZVdDZPOUUrMG95VlZrSWZKNlpER0ZmZDhwOGpa?=
 =?utf-8?B?dVVGbU9wNXN1c1RaeDBHZWNadllmcGxEWUljTExnZVVGK3VqOGljaUNkcmRL?=
 =?utf-8?B?dkFZOEUwVEd1UGhMYzdsYytWR08xa0E0WmFNNWVFeTF3M2Q0aS9tTEF6aWFO?=
 =?utf-8?B?djN4NDJEeE02eG1mZFltc2x0UHNFTWptbEJhbWpLeGpNSjdOYW5RVEsySTZo?=
 =?utf-8?B?SlNuUk9ObjMyQ3I5aG91SGdGVXJZU3lkWit5N0lzeDRQS0l2VUF1cDdPTnVm?=
 =?utf-8?B?aWluRTVWRGRabmQ0U0NkRlpaZThVOEhFWjNjWk91Sm9sTGMyL2tHVVRRM3c2?=
 =?utf-8?B?bjhQQ1hSK1pCZ25OL3ltVHFMQUZkWHNJQ0VqZ1B3VE5YZkNFSFhwMTFTR2VP?=
 =?utf-8?B?S05VNnlMbm52MVhFYmF4WlZiS2Rad3IrNmg3WDlUMEpNWkJLSWJ1YWR3djI2?=
 =?utf-8?B?TVNlRjhkVlYwOGRhZzN1bmhTcE1CVFNWSHNvZkNKMUxMN0dhR3VNYmpxQlBz?=
 =?utf-8?B?Y25McXd1OFhSM0hIbkpCVndNWkp0WHRJbzZMaUxEUWh1dklySHkvdm5Sd0Ew?=
 =?utf-8?B?RlRSL1RsN1g2dC9jTGphT1BodUJUV1FjazBjajMxS0grbE1ERnY3bFpSYmN5?=
 =?utf-8?B?ZVJnbkxXcm9nPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVNXVTJGZ1drM0tPWmMvTUZIN3gyQTMzTTFPWTdnS3p5Q1F6T1RpQkNpYjVJ?=
 =?utf-8?B?RlFxd1ZBMk1wbkpMUWFUMkVERFI5Y0hoM1M0SjdBWmx6M25iOEZ3N1VUdjdh?=
 =?utf-8?B?OGZpOU12WUwvSnZXdXlMVk45TmdYUEY4aWFoM05UUVp6ZDB0K0VWZnRsRHJV?=
 =?utf-8?B?SmJvV05FaVFoci90RUczSG4vOVdXVTBoaHR0Zm1uempUUUJ1WWJQSHgzZXc4?=
 =?utf-8?B?N2Y2WndySXVieElXa1NOdlRqdTFoaUhEK0o3eWYwUzhXQ3FrclBJc2FFclZY?=
 =?utf-8?B?dEZUeUxyRHJpdW9aeTZiTXlmSlQ4SEpock9MSFN4NlUxWm9WOGhoUFRsaTZz?=
 =?utf-8?B?aUJlMGYxN1FsaTRYWmdCUHEydGRkTDdDWnZtYUpaall1YlpLb3JXR2JDRERa?=
 =?utf-8?B?em9CN21mWnBMUTdsak5LbndxZTE1UVhpUlhzYjgyRFdYNFB2Vk5xdFcxY1Ny?=
 =?utf-8?B?dHpxRG4zckNxTG9hV0lEV2d4T1dCUVdRaTQzSlpJUXdMTWhnalpkVUpqUm5Q?=
 =?utf-8?B?eFMzNnk1NWt1TmNyenBmM0VEVnZ1cFJGbVp4WGpqY09hT21sU2Yra2pkZVla?=
 =?utf-8?B?bCs0SURVak5maXp2UVJEVXpQSHVpY3pKT2VuVjJzazRWVHJ6dVZBNzU1UCtR?=
 =?utf-8?B?dzBxelBpdUlvN01BRG15WmlITi9uaG5VOFRSMzRkSVUyb1JNdy9WbDZ0b3da?=
 =?utf-8?B?cUlvT2NPaENwRHlzdDRVSmpyQjExdzNRcUllR3VBOXRFSVFsUUVGS2JzWUl3?=
 =?utf-8?B?MXFNb080VlNEK25rUkl6cHlIN0JjT3dDU2pmMHA0cGxXL2ovanBkdGFiMXpt?=
 =?utf-8?B?TTFieEhUVThyM3JjMkNCbDZ4QTJSNlB1S2dKZmdJaGFlcFNmdlRMVXZ1OHpC?=
 =?utf-8?B?anpoUVRzNWd5Y3VTSzYwREZDYkJKMC9GWVBReS9kRmp6U0J2YmRGSW1WMWNQ?=
 =?utf-8?B?bG8wRnlQc0s1RVFLQTFEUVFKTkhlMWI3bGdhcS8xQVNSQWJ0VFIydWxlSWxq?=
 =?utf-8?B?QVptS2czb2dLNFpldnVqN3YvNllVenRQS0Q3WXJBVGNodEhDSmpsSnNDSS9z?=
 =?utf-8?B?K3A2WEIyaXE0RjZkY1hFSjdjaFVVLzFHMVVlWk5PZnFvOFY3TlJVVjFkaFVF?=
 =?utf-8?B?cm03bXhTRXAveFVVSHo1OU1QUVM5VjMxc0JzaDNUZnVWdTQ3bkxSUzFLMUs4?=
 =?utf-8?B?QTBpeVREbWM5MGZteXJncDFBdzZWRDRaSFFwMWc0ZW92UVluL0Evc1pUaEpN?=
 =?utf-8?B?eUxqYmozZHpKbFdyOS9mUUNkamx5YmdZajVVKy8rZXlrbjdydTBMNzlGZFR3?=
 =?utf-8?B?Mlc4MTkzZ3dpZXpjVDFCZWpDUVFiZjk4eFhySjFFa0hxSlNLVXBkSnF5RnBI?=
 =?utf-8?B?a1ZGcnQyQVBiZHlqMU5mdmE0QkVmcHRldE1mYVhETWN3WEZqbUJpK0VFZVJW?=
 =?utf-8?B?VHR3NlJNUzUrRERJTTZyOFA5TFdGL0c5QW9ienpMTXpoQzlHODFpN1Zpei9I?=
 =?utf-8?B?VVM4L25Kdzh1U0J0TFRmVlJUb2JJRENzekd5VFpFUUdJbnFTTXZYYXhUdUpO?=
 =?utf-8?B?aDkxTjhWTmpuOCtSbmtlT1NlangyL2VlSmphNTY5YWFVVkk1MzczaWVvY2pC?=
 =?utf-8?B?TG14SE56bGZTV3F4Y1k5ckgwSUdrZGN4OXdZWmtEeUlOK1JnbVBaMmJ4bmhK?=
 =?utf-8?B?b1djMm9wT0dHOUVTREp4RzFWTkdCYktwYS9rcnJIalBNMktqRnVYZERqRmJL?=
 =?utf-8?B?UHJ3NkJ5OEZuL3FwS3QwMjgya245SWQvSC9FbUJtSzVGa3Y0VlB2MExDSDNK?=
 =?utf-8?B?QkIvNy9ZWGVPWkQ1aHMxbGdRYWpuVTJYOXQvMkNJT1RFcHEyRGFMejZETGtv?=
 =?utf-8?B?VWxsWHh6S2RrTDZzdUFza1hzTE55MldhODhyYzZVa1BwVWRWWWFOVlV4RXFR?=
 =?utf-8?B?VUJZN0pEMnMyUHlOVHNUOW5RdUc4c0svMi95d05lU28vMmRWTnVzbmxtakVG?=
 =?utf-8?B?Yit3SWVDdlJZZExDdzdGQUNMVUdaTmtPWEJ2YlZib3lQVUFUYTlCaTc1NnRI?=
 =?utf-8?B?YTRsUldJaGNBNkZmRzQ3cUtpNnUzQndWalB5elEydTdkYk5vMjFmcXJwdUZu?=
 =?utf-8?Q?O9lqBtaPZla35QQRdZZgouROy?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <77E5F8D7B7BE9C48A555EFFAC082D974@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d21daa0-07bd-4615-1b5a-08dd7cd2650c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2025 10:35:23.6533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kt41Zc5qq7OaHXYhpYvpB5nUm1REf7wBNTSmN+4QCe6oNRSY3HVOW8Hc0Z0AaspcFqpqe7tJFNcNEYHdEe5QGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5265
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA0LTE2IGF0IDEzOjU0ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IEhh
bmRsZSBURFZNQ0FMTCBmb3IgR2V0UXVvdGUgdG8gZ2VuZXJhdGUgYSBURC1RdW90ZS4NCj4gDQo+
IEdldFF1b3RlIGlzIGEgZG9vcmJlbGwtbGlrZSBpbnRlcmZhY2UgdXNlZCBieSBURFggZ3Vlc3Rz
IHRvIHJlcXVlc3QgVk1NDQo+IHRvIGdlbmVyYXRlIGEgVEQtUXVvdGUgc2lnbmVkIGJ5IGEgc2Vy
dmljZSBob3N0aW5nIFRELVF1b3RpbmcgRW5jbGF2ZQ0KPiBvcGVyYXRpbmcgb24gdGhlIGhvc3Qu
ICBBIFREWCBndWVzdCBwYXNzZXMgYSBURCBSZXBvcnQgKFREUkVQT1JUX1NUUlVDVCkgaW4NCj4g
YSBzaGFyZWQtbWVtb3J5IGFyZWEgYXMgcGFyYW1ldGVyLiAgSG9zdCBWTU0gY2FuIGFjY2VzcyBp
dCBhbmQgcXVldWUgdGhlDQo+IG9wZXJhdGlvbiBmb3IgYSBzZXJ2aWNlIGhvc3RpbmcgVEQtUXVv
dGluZyBlbmNsYXZlLiAgV2hlbiBjb21wbGV0ZWQsIHRoZQ0KPiBRdW90ZSBpcyByZXR1cm5lZCB2
aWEgdGhlIHNhbWUgc2hhcmVkLW1lbW9yeSBhcmVhLg0KPiANCj4gS1ZNIG9ubHkgY2hlY2tzIHRo
ZSBHUEEgZnJvbSB0aGUgVERYIGd1ZXN0IGhhcyB0aGUgc2hhcmVkLWJpdCBzZXQgYW5kIGRyb3Bz
DQo+IHRoZSBzaGFyZWQtYml0IGJlZm9yZSBleGl0aW5nIHRvIHVzZXJzcGFjZSB0byBhdm9pZCBi
bGVlZGluZyB0aGUgc2hhcmVkLWJpdA0KPiBpbnRvIEtWTSdzIGV4aXQgQUJJLiAgS1ZNIGZvcndh
cmRzIHRoZSByZXF1ZXN0IHRvIHVzZXJzcGFjZSBWTU0gKGUuZy4gUUVNVSkNCj4gYW5kIHVzZXJz
cGFjZSBWTU0gcXVldWVzIHRoZSBvcGVyYXRpb24gYXN5bmNocm9ub3VzbHkuICBLVk0gc2V0cyB0
aGUgcmV0dXJuDQo+IGNvZGUgYWNjb3JkaW5nIHRvIHRoZSAncmV0JyBmaWVsZCBzZXQgYnkgdXNl
cnNwYWNlIHRvIG5vdGlmeSB0aGUgVERYIGd1ZXN0DQo+IHdoZXRoZXIgdGhlIHJlcXVlc3QgaGFz
IGJlZW4gcXVldWVkIHN1Y2Nlc3NmdWxseSBvciBub3QuICBXaGVuIHRoZSByZXF1ZXN0DQo+IGhh
cyBiZWVuIHF1ZXVlZCBzdWNjZXNzZnVsbHksIHRoZSBURFggZ3Vlc3QgY2FuIHBvbGwgdGhlIHN0
YXR1cyBmaWVsZCBpbg0KPiB0aGUgc2hhcmVkLW1lbW9yeSBhcmVhIHRvIGNoZWNrIHdoZXRoZXIg
dGhlIFF1b3RlIGdlbmVyYXRpb24gaXMgY29tcGxldGVkDQo+IG9yIG5vdC4gIFdoZW4gY29tcGxl
dGVkLCB0aGUgZ2VuZXJhdGVkIFF1b3RlIGlzIHJldHVybmVkIHZpYSB0aGUgc2FtZQ0KPiBidWZm
ZXIuDQo+IA0KPiBBZGQgS1ZNX0VYSVRfVERYX0dFVF9RVU9URSBhcyBhIG5ldyBleGl0IHJlYXNv
biB0byB1c2Vyc3BhY2UuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCaW5iaW4gV3UgPGJpbmJpbi53
dUBsaW51eC5pbnRlbC5jb20+DQo+IFRlc3RlZC1ieTogTWlra28gWWxpbmVuIDxtaWtrby55bGlu
ZW5AbGludXguaW50ZWwuY29tPg0KDQpBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50
ZWwuY29tPg0K

