Return-Path: <kvm+bounces-33479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADD49EC794
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 09:46:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1E2516A83E
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 08:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB7E1E1C2B;
	Wed, 11 Dec 2024 08:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UjiB/Jdf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6080E1C1F21
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 08:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733906772; cv=fail; b=g5mLqHgwMd9vY3HhqBOYS5A+Vli519FiNjJm6s7v50P3eRL7cL+CAIyIX+FJQtNbwEWBSwde4aMs1+WTGvLctVD02hakCY7r++FBE74PezjaOj/vPEd7Z3Bc74FvzbxGhuQGAH0OW5C2dFzdoA7PbcuYfNTZWui+jTvKL0QoeR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733906772; c=relaxed/simple;
	bh=ozXcA/vpFpVeiyxDx7fYsY4LeAiEGrwFa5/UEGhr1xQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S5gNix4LFcNWN9b+ImbJHcl/FRQg6xOnk2JuTSx7JxfEnlp+h/YhqjtPvQXPjz9bTMNRsWMLGlcdptSCMcQBxFG2tygnxbKdKXRnGYHIKbBFOB8ojbJOHMaqVMbqbeLRPdjb1VYVZPNK6zMGsdiuq2LKx5ZusvOUDRJJBdwaM7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UjiB/Jdf; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733906771; x=1765442771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ozXcA/vpFpVeiyxDx7fYsY4LeAiEGrwFa5/UEGhr1xQ=;
  b=UjiB/JdfQEdMs40kpixJTpsbVSFzxcZCnCXs4iPSwQhcusTef7kOvauY
   So8Ca++0Unemzpggxn7hjmJG4UAeawxtpaJfE2MNUjN2AwvJK/W3hNqlX
   eH0OvoDZl+07CCpjz1ZE6MUyRY2l4cCuqpzv0SOZ75saHW7E283kS1dna
   PyOPYQpueMv0qtZOgMdsEoHv8A6X8YKjn4yBet/Fbf1YdJQy9B+A7kBPr
   1vxeIh5V125ZKpj55b1oqi0OWZZhlOUSWl5kRK4x18UVYz2+D1kW4Jsu8
   9s5GSEql/mcdX48MYAoshSEhXE4XudY023Nxfi95nVVfXve3s8Mt8hpaH
   g==;
X-CSE-ConnectionGUID: ggvxWxjESTWhMlLVHJYnRQ==
X-CSE-MsgGUID: s20vyil1RqKVSDsw74q7pQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="45680446"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="45680446"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 00:46:11 -0800
X-CSE-ConnectionGUID: rgyxok0RTZu+Bq2bk6mv+Q==
X-CSE-MsgGUID: 8Qa5QxLIS66tqMiQWkXCfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="100259844"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Dec 2024 00:46:10 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Dec 2024 00:46:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Dec 2024 00:46:10 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Dec 2024 00:46:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mjp78tPJ5TKZtWQl/aeU39LycI7fAUPFBC9FlXNOMu28EkvujnvywYIRt93f7WAyO4FzNSUNQFYOdSENyTka7DyaSUxELlCl7uQBEAP96qR8JTRfpzXUMzIx/SC/5cKK8SANufVxPM3U3xJL6fUZx/3kDdmc/6rfszzo3joy9RLus7MPl/IeB4ucgxVEvZS0pVp4kNoRJ4iLtSCwdLUAWT8a7SHfvj7RyraYVn6rA7D19V/YZC+zPgeEfrdQoX+v7x6JcHN/UQ5E7X6Qh/4bAy1zWEaechD24q4IsvtKBPINckYOWuB8pbFSkVHPgDnAkFoqwVfA9BdWGnYEd/O/AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozXcA/vpFpVeiyxDx7fYsY4LeAiEGrwFa5/UEGhr1xQ=;
 b=D1/Zef5jy+3sNYnSgSebvBo3/TJT8RNa+R8e5bhM2/AgTjiDm76OQjsyKsBcKfXdbTpT+PLID2qVPOiIVqAk9Ay3ArUONh8YWSq7EwYCaw6Ywo1bSyWSMVuMC1q6eboF9e4bZXtinrGptRNBiOUA8cVWQJN/VxT8LIV9w6f7qN7+Dcty1a3ZbS6xx5SS7+X1CSmDcZGxT59YLsZv0lpTM1Yrbjzpc0to6GR/WOFQCRyURcHTvqfGVSKCZTJZe/rJQ53h+O3MjnT4tm+hyoo2R9aFst+XxcnifzAo1E5sEcJwRUh7vU+CXXtFyZx5qAHS/TqBTnrfOMEFjahbvXtsJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB6743.namprd11.prod.outlook.com (2603:10b6:a03:47c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Wed, 11 Dec
 2024 08:46:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 08:46:02 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
Subject: RE: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Thread-Topic: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Thread-Index: AQHbLr0MyG3oX7KdYkCnpIbZw3bHE7LZC5CAgACnwQCAARp4AIADagUAgADOLICAAe0wYA==
Date: Wed, 11 Dec 2024 08:46:02 +0000
Message-ID: <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
In-Reply-To: <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB6743:EE_
x-ms-office365-filtering-correlation-id: 392ebf2f-d3c3-4bc5-7b6e-08dd19c03e23
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WWtvK1Q5Y1E0ellJOURncGhRMG8rVDhrQnpVcEFSZVR6YlNmNkVxdTJTNnAz?=
 =?utf-8?B?MnZWT1lxK3BmenhWMUV4dy9BTURWZzlxVzVkR0xDVUhNR28wUTJUc05XNjFC?=
 =?utf-8?B?L0E1RmlJV05GdUl0VFcwMHRYSTZBRE5TbllDRjRJSjRKakhHWm9ZV1RPbEVn?=
 =?utf-8?B?SnJtMHR3ZEhnekNjd1U3dkdqdUpDN3liRHRIOWFLSEhuazN5M05ZeW1vWTlV?=
 =?utf-8?B?L0U1ZUc1TlhmMUU3OTdlUjAzbXhqRHMzeVQrVUx5elRaK3kxQU1OMlZyRlpT?=
 =?utf-8?B?OGYxaHpwWmhOU1U5WE1lMUR3VzlxR1g1bC9MUU53Vkh1L3RhL0JFb3Fjc2sz?=
 =?utf-8?B?M0pOcFAwbi9Ib2hGTTNDbXdZdStPcUhDSi81QlFYZ2IyNjdxYkFramtmSWRj?=
 =?utf-8?B?dnVYSEdCbVVlY3BNbEVSOUhtTFQ5V1dnRVBwZUgrbGd5RDlxSzJ4THhYbEM5?=
 =?utf-8?B?c3N0NzBIL0hqeEh5dUNMS3ZKOTZMdS9hWjhwVEd2MURBbzJtMjZoVFBRT2Mx?=
 =?utf-8?B?ZnBjQ3U4Rnh2a3FZVTRPSjY0aG8rYXZVRnlNM1dUdWNpcnJnSnpiRSs0Nmo1?=
 =?utf-8?B?WjI5VUlFeTg5NW4wK1JWU3FKQjFnY2pTWjdVeG82MW5PejF1MGRXWk1tSFhK?=
 =?utf-8?B?WUZLUXprNWw5MGpkRWNJbXVVdHFxK2NmeHYrOUlsQ2pjUEt6OWtuVzBHdWxK?=
 =?utf-8?B?SzRubE5VdzZSSGNjdUhtYy8wZVU3cm8vdm40bDVVN2ZBZzFNZURtWGh0dkto?=
 =?utf-8?B?OWJTQjB1TDBBdVRDSWJuRXZvNWh6OUdGTVhpdXZvd0VNMkFQWXBpbDNBUlZ3?=
 =?utf-8?B?WlRNeEZGWFRxYm80Q1NEN0VyaDdteWQyeC94R0JMUll5UkVkalZocUFDc290?=
 =?utf-8?B?KzFvNFlrUC9rSlpmaElTVXFFeDg2UEpNdjlxdUJmNFA5elp4MEpaSGNuOFpC?=
 =?utf-8?B?aENkVUQ3eHoxUTZsdWtXNWxMNGx6SE4xR2tQajJCcHNxZG9kd3cyWUtCVmQ4?=
 =?utf-8?B?MERsanRGaTRJK1R1aWVCYzlsWlZ2MHBxenRtS05BZ1NIK25WMzhQMGhjSjJv?=
 =?utf-8?B?QnVMbExocXMwWnR2RDEwdkQxczZmaUdLM1JMWm9hMjlVSVc2WmExN29Fb0g3?=
 =?utf-8?B?UCtEV2VsSzR3NEVVWE45QURSeHc4STJscjBlbzd4ZEJrcXdLNHR6MjFjekdN?=
 =?utf-8?B?a0NjUzFndWpjN25Pa0tNUmlNc3UwUVJDc25hKzhiVnQwWTI3Njk5Z2t3bmJl?=
 =?utf-8?B?QlVMZTUxL21lVHZFYk51WEt6YnIrT0VNMmVsQXlxYURsOGF2R0lJN1lvRUFp?=
 =?utf-8?B?Zk1lRGJkdXQ1bllaZ0pjM3I1Ujd5TnBkM1QvaVU4cnRrSnhnbGpmMlk5S0VS?=
 =?utf-8?B?dy9pOFVtQVg5SFhPQWRVODAxNWNybHpVeVZnd3pQU0dCWTJMbHkzOEJodmdI?=
 =?utf-8?B?VU9JK2N6VUl2a3h5Z1RGWnp4M0tpZS9ESW5IbjgwM2hPaFBBWVZhU00raThJ?=
 =?utf-8?B?S0ZXS3cvWGhJT1IzR1J2dkJvQnJvWXRtSWlCbDN5VkVkNC9mOGpYdkZ5MmNT?=
 =?utf-8?B?anJ5MVUzWUUvM2Q5emVBWmpaK21Wdld0NyttT3g1Z0xJaWx3UkpJSzRZc3hl?=
 =?utf-8?B?OEdmT0xBN213aGdjNGo4cTRiRExKeTFQNEcxRlA0anp0aDdwMXhIUThQK09v?=
 =?utf-8?B?WVZuNEVMdXZCUTI5R3RKbG1Ma09NR3pPNnNITCtWanFVckc4WEMxdFd2ZU5F?=
 =?utf-8?B?Y1lSTTBQa1BkV3hHVHMrb2xmMVprcXNKN08yUWkzbHl6LzJaaTVWZEl2N2Rv?=
 =?utf-8?B?VUE2ZXF2dlRNd00xVWZmNWlJeTJ6bWM4UFU3VkduYjFFRjB0eHF2YmhOcDRX?=
 =?utf-8?B?T0l0M1NLcElpWEs5dWhKMnNJMUZZSW53TmlIUFpBa2JXbFE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1JnT05mZFR3VE1WR1J1NEJEYnB0WEJZajRMVis0M0FmKzRybTRjMEIrRDZy?=
 =?utf-8?B?ZC9VSFFSSzZaSFBuTUc1N0t1aDZ3emZCb2ZYcStkcWRGUWRBMHhGZU5nL09Y?=
 =?utf-8?B?R1BscXVwZVZEcFQvVm9hVzY2VHNkUmgxaE5tU0NpdnE5NC9meUxnYnFWVitw?=
 =?utf-8?B?ZFNqanVoL3NwelZUMzVHdGRJVG1jcXdoeWZnU2ZndnVGa1c5U2ZFaXhNZ3pN?=
 =?utf-8?B?bC9uOTBKMCtINHdtUFM3ekYzRFNPOWxreUZHQ2tKQkMvWXF1RVdUSmcyTS9I?=
 =?utf-8?B?WmxXN0JOZUh5RHNMWDRCajFGZUh3SGhMUmpUaEhMcUJEQzNSd2J2VFZxQ0dV?=
 =?utf-8?B?R1QxczUrMFBaR210cVZTQkdZeGZQekZUcFg0NllsQ3luSiswbk0zYmNGQmxI?=
 =?utf-8?B?dlg5ejJjcXBKV3ZGL1Y1QjFpMWpveWJlVDlkQmhOOExaM1NyRkZUNlZRZ3BV?=
 =?utf-8?B?ZUtVaGZqVnFDMTRzeHJuTE1QcG5UQVpSODkwTWhGdVp0KzRNSitRc0NGNnhM?=
 =?utf-8?B?UHVCZTN0aGZ0TUFnTFhMd21kcm11SmloNU9VYmUrQXoxd0dVdXYwZmR5a1ds?=
 =?utf-8?B?RXR2SjVWdkJkZ084MWM0YWF5b1dvSkFBbHZIWEw0eVllVUVyV1NQSWgzdDF0?=
 =?utf-8?B?TkYxd2FrWHZPUm1HaHJUNC94VlNhUE0xNFhRQkRINFVTeVRoQ0trNHhid0lF?=
 =?utf-8?B?eDJlN3JRQTcwNDNva3ZjaUFmTU5oUmFVakVLM0YwaTNOWkpvWnlYdE05MU84?=
 =?utf-8?B?RmY4WEdzNXZIV2I4VktyczkrQzA5MnNHVkUvZjRVZ3VlTGNOYjZZZXJtWURq?=
 =?utf-8?B?OVFRbXNKODZOK0VFRVRybFlMZk9XOGlGdjUzSHd4aVFUQ2xveVRsZjBHenl0?=
 =?utf-8?B?MllDVWlMT2UxL3l4UndkU0I5MmNzSEtrZkE2MmFxRERGb0psc2wrVE0yRzJw?=
 =?utf-8?B?cTRtRVdiams3VW9KaEZBRHdQa3lhL3BsUUhMekF5cVptVFNucUtjS3IxWDdt?=
 =?utf-8?B?c3NhZnp2NU1PclZHTE4vbUh5Y3pMSlExTHI4d1UzRWdYNGY0TEtVdXd5VERE?=
 =?utf-8?B?RWwzRENpb2tpSkxxRitqOW5MTnlTUVNtZXd2MzRVUkswMG9LVG13Y1BwK3ps?=
 =?utf-8?B?VHJVVGxjTlhxY3p6SmVqbkdGaENwRVh5dzZDdk1mVjRVUkh3SnlhTnV1MkEz?=
 =?utf-8?B?NWpsandtNUJCQ1BOOVR0UUdhd1Vnc1llUktSSmlyQytLWWxpb0VpWE82MXN6?=
 =?utf-8?B?MmhjREk2SDFKdHNqcFB2QVFldTVkcG5EdHFzZTB3ZThSY2lTSlE0NW5zU21S?=
 =?utf-8?B?TnA2aHgvbzFqSkhCY3lhS3RqVjY1TVF4RXpMTnlET0laZVlLQitqL082N2RP?=
 =?utf-8?B?UWNIZmlENmUrMzJDbFBNTWNXcVp1ZkhRVGlVMVNIWmREQmxXbWVaMHl4YXJu?=
 =?utf-8?B?WVd5bm1Kb1pSM0JZWGxMcGhjMEpwdTY2VFJrNElOWDIrRkFha3N4QnlSNlBL?=
 =?utf-8?B?MWE3WVllbU5iUlJMeGlldW1ENVY3cmp3RmZKSHl4eXdVczFyaUEyekZoSWpZ?=
 =?utf-8?B?VXIxeEdCRU1GSnhSZWpmd1RMTWpqTFRTcHd1SE1qNlJqcVVOekd6d1U1U2dP?=
 =?utf-8?B?eC9qVzh4MlZFUWZPTzMzQ0VGaFJtUFRsRlY0NTJrT1JRMjlRT0l2dGVhMUt6?=
 =?utf-8?B?NHc3YzdtU0pocTh3MDh1RG9JeWErbkNBcFhMT3hEbzV5d29wcnQyb2l5TDN2?=
 =?utf-8?B?dTZkdGJ2dCtzQktsMHpRWXdqTnl0UGZXbS9yUEk2WVA3eUJoSXRQd3NXaUVV?=
 =?utf-8?B?V1ZEckNnYkJtMlRNQmkzeFJTcENxaExTemNBUEdjQ0RPYzhITnlCZkJaTUFW?=
 =?utf-8?B?NmpJZUYwM04vTzRncU16MGxyWEZDNVhBYmVPWmtSRGVYams1MURMSTNWTjMy?=
 =?utf-8?B?SEVLSkU3czhzalJtckJrWFBPc1Ixd0doREFpQktwSHBsWGFPcytBVGdGL01l?=
 =?utf-8?B?bHRmRHl3OEwwTlVtSGlxaWxkUnFRc1UzYytyNFc2dSt3MSsxSi9RTGhsVkJ2?=
 =?utf-8?B?V3N2cWY2LzlGMlNGSzB3eXVqMzViU1VBUnVkRDZpMnJIbnBsQVZHQW1rYTVI?=
 =?utf-8?Q?V94l1tbhVHso6AGwo9ztkABU5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 392ebf2f-d3c3-4bc5-7b6e-08dd19c03e23
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2024 08:46:02.3141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hoOTJWZfZNd1oF7dWORmihEvDuHYoJlj51S5Gs2c31zTT0uCVSI57k7UpHgDpIYfpICJQYvxw/WZNVISKicysA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6743
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
RGVjZW1iZXIgMTAsIDIwMjQgMTE6MTUgQU0NCj4gDQo+IE9uIDIwMjQvMTIvOSAyMjo1NywgSmFz
b24gR3VudGhvcnBlIHdyb3RlOg0KPiA+DQo+ID4gSSdtIG5vdCBzdXJlLCBJIHRoaW5rIHdlIHNo
b3VsZCBub3QgbWFrZSBpdCBkZXBlbmRlbnQgb24gdGhlIGRldmljZQ0KPiA+IGNhcGFiaWxpdHku
IFRoZXJlIG1heSBiZSBtdWx0aXBsZSBkZXZpY2VzIGluIHRoZSBpb21tdWZkIGFuZCBzb21lIG9m
DQo+ID4gdGhlbSBtYXkgYmUgUEFTSUQgY2FwYWJsZS4gVGhlIFBBU0lEIGNhcGFibGUgZG9tYWlu
cyBzaG91bGQgaW50ZXJ3b3JrDQo+ID4gd2l0aCBhbGwgb2YgdGhlIGRldmljZXMuIFRodXMgSSdk
IGFsc28gZXhwZWN0IHRvIGJlIGFibGUgdG8gYWxsb2NhdGUgYQ0KPiA+IFBBU0lEIGNhcGFibGUg
ZG9tYWluIG9uIGEgbm9uLXBhc2lkIGNhcGFibGUgZGV2aWNlLiBFdmVuIHRob3VnaCB0aGF0DQo+
ID4gd291bGQgYmUgcG9pbnRsZXNzIG9uIGl0cyBvd24uDQo+IA0KPiB5ZXMuIEkgYWxzbyBoYWQg
YW4gb2ZmbGluZSBlbWFpbCB0byBjb25maXJtIHdpdGggVmFzYW50LCBhbmQgaGUgY29uZmlybWVk
DQo+IGEgbm9uLXBhc2lkIGNhcGFibGUgZGV2aWNlIHNob3VsZCBiZSBhYmxlIHRvIHVzZSBwYXNp
ZC1jYXBhYmxlIGRvbWFpbiAoVjINCj4gcGFnZSB0YWJsZS4NCg0KSXQncyBoYXJkIHRvIHRoaW5r
IGFueSB2ZW5kb3Igd291bGQgd2FudCB0byB0aGF0IHR5cGUgb2YgcmVzdHJpY3Rpb24uDQp3aGF0
ZXZlciBmb3JtYXQgYWRvcHRlZCBpcyBwdXJlbHkgSU9NTVUgaW50ZXJuYWwgdGhpbmcuDQoNCj4g
Pg0KPiA+IFdlIHdhbnQgc29tZSByZWFzb25hYmxlIGNvbXByb21pc2UgdG8gZW5jb3VyYWdlIGFw
cGxpY2F0aW9ucyB0byB1c2UNCj4gPiBJT01NVV9IV1BUX0FMTE9DX1BBU0lEIHByb3Blcmx5LCBi
dXQgbm90IGJ1aWxkIHRvbyBtdWNoIGNvbXBsZXhpdHkNCj4gdG8NCj4gPiByZWplY3QgZHJpdmVy
LXNwZWNpZmljIGJlaGF2aW9yLg0KPiANCj4gSSdtIG9rIHRvIGRvIGl0IGluIGlvbW11ZmQgYXMg
bG9uZyBhcyBpdCBpcyBvbmx5IGFwcGxpY2FibGUgdG8gaHdwdF9wYWdpbmcuDQo+IE90aGVyd2lz
ZSwgYXR0YWNoaW5nIG5lc3RlZCBkb21haW4gdG8gcGFzaWQgd291bGQgYmUgZmFpbGVkIGFjY29y
ZGluZyB0bw0KPiB0aGUgYWZvcmVtZW50aW9uZWQgZW5mb3JjZW1lbnQuDQo+IA0KDQpJTUhPIHdl
IG1heSB3YW50IHRvIGhhdmUgYSBnZW5lcmFsIGVuZm9yY2VtZW50IGluIElPTU1VRkQgdGhhdA0K
YW55IGRvbWFpbiAocGFnaW5nIG9yIG5lc3RlZCkgbXVzdCBoYXZlIEFMTE9DX1BBU0lEIHNldCB0
byBiZQ0KdXNlZCBpbiBwYXNpZC1vcmllbnRlZCBvcGVyYXRpb25zLg0KDQpkcml2ZXJzIGNhbiBo
YXZlIG1vcmUgcmVzdHJpY3Rpb25zLCBlLmcuIGZvciBhcm0vYW1kIGFsbG9jYXRpbmcgYSBuZXN0
ZWQNCmRvbWFpbiB3aXRoIHRoYXQgYml0IHNldCB3aWxsIGZhaWwgYXQgdGhlIGJlZ2lubmluZy4N
Cg==

