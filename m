Return-Path: <kvm+bounces-26468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 16604974A73
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:33:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AA81B253F4
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A93934E1C4;
	Wed, 11 Sep 2024 06:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WcAOsAgB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E262C1B4
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726036430; cv=fail; b=e++AacWGIzY5kwArsy4qj0J5600IubBHTp6zttpTabiWUdUeCsYipobrwWUNGwBu2RNKfRUE7SzY28Sg2xq1e1cbsmowzMetINZBSh2B9tkzIk4AdkBJ/XlAJUVfupRD2r7VhLw3wM6oSLH30XeIQamxoWJFcsrTahJ/uB1XNSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726036430; c=relaxed/simple;
	bh=rvq2JihauuELmf3JWQKGCTp5eAOYP05tZKJmvK87KZw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dVd6ikytJurbyYtem0/eZg3MhO3zUkxCBfz6+4WmDt5XHQqS9ll2+O9Qoq4ewkvaB77G3RKhOIo9c6pa9oc/NedaOQIEAV3+WZC+yKvt1yQqtbnk+0lOrrhsdOfOpyYNuEaF8x1ynN6nIx/mUayGUGpW5B2SRo4jVDxrhJHa9is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WcAOsAgB; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726036429; x=1757572429;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rvq2JihauuELmf3JWQKGCTp5eAOYP05tZKJmvK87KZw=;
  b=WcAOsAgBVOqKV+K38HkeVyGclp5LvbWBZ2wxbMA5h0YgX/V8SP4TXDm9
   VSyDERYBZK1wGHNv6h/GlgyL9GZNXiHrR9hAjspGdvxdaQRsBevdIVyW3
   TFQaHACMfkuESSwSio/ONiKp5tnz/lYAIJs1ZSbII08tQM/dCrGtdx4V0
   UJYoEBu+nS+Re1hs+6UEyp9b02N4v5SXpztxGD3WwCPjG6fh5lfnJrML0
   6RG+bsZLOkVje/BB9X549Yw2AeQdtyrVfHAWW8e2RbPfZH2xTZYjOIdik
   pBrN9Ug0P3iYNw88QypnndA4ME5G8DoA/CeUW1DXBSCVbYMGkfx3FguJb
   A==;
X-CSE-ConnectionGUID: QuDJk3cvSPytOPW8aL1iKQ==
X-CSE-MsgGUID: KKMikFFuRfOTs+IiYS1ZKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="24638742"
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="24638742"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 23:33:48 -0700
X-CSE-ConnectionGUID: NzEHbflCQseT0W66lz97cA==
X-CSE-MsgGUID: ZQ4rfC9ATGW2Z5fcLfT2fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="67285342"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 23:33:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 23:33:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 23:33:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 23:33:47 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 23:33:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i+uUj1Lov6L5N7WsmRtxRRjLxQBRowkjTPm4a5FdXqwezfKnBo2PxKAFGWiYaxcXSXFbvTvMhpTLvvnrJN8Wokt4P0iI/Rb7wAUTKgK+iLrzf71Yg+vuGr/Bl0y45RW/Jx+tYuhPnbthwE7DoIzOOhbJBVjLzjxRzFukPo9CXyBKjieVvrOfD9eyRq5SWyDzPlB0vSf7V+ewsArwoQm7Rlyk3pohkM8aCMbb/Bwppvy5PVTZMsELTguLwQQ6soKF1rNtiEgl9k9Boxplpm7WDfQZJj7x2LRgnugmLNIeMsSV9nk+8W/C2OmgtM8dSRMUJhGiPYr+ZnM/hpKi/wnRcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvq2JihauuELmf3JWQKGCTp5eAOYP05tZKJmvK87KZw=;
 b=Qibpu7vvQaRG2Yc/UUZv/lcGZRKIVrx9GWwU9hVDSRZGindh4mwUOix4qV0hM83Z1ceO2lcmJyt15M2d56Q3ZAhD+SQLnqxZQeVSkuNZAqlJokcKu3JusyG1piwfkOGj+mBmZIwZbq3aGnoGhZd7T6mWLUwQsO7qRArB2eKmrgGG3tNG4kTPEcegCn0IczbJ7DR6Isr1VgwOwNxANkcoeC7T4wvD2Y/iprHykrcIZiRf24fAV0pYtUOAzcCEPX+79NOTzdFyYsfgJl3MMWK0yvMwl1A46cXW2NYDEVrHdgxV3KpyezwL/jbul4INo2aSJoaAGxkvCsEQ5uhLYFS7OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS0PR11MB7559.namprd11.prod.outlook.com (2603:10b6:8:146::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Wed, 11 Sep
 2024 06:33:45 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%2]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 06:33:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>
CC: "nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
Subject: RE: [PATCH 2/2] iommu: Set iommu_attach_handle->domain in core
Thread-Topic: [PATCH 2/2] iommu: Set iommu_attach_handle->domain in core
Thread-Index: AQHbAeRMRAAUQVK6I0u3f7Z67rJCDLJSJT7A
Date: Wed, 11 Sep 2024 06:33:45 +0000
Message-ID: <BL1PR11MB5271AEB90093A87FF17943918C9B2@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240908114256.979518-1-yi.l.liu@intel.com>
 <20240908114256.979518-3-yi.l.liu@intel.com>
In-Reply-To: <20240908114256.979518-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS0PR11MB7559:EE_
x-ms-office365-filtering-correlation-id: 0170cd20-1185-4d9e-730f-08dcd22bafeb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?nkI6+b5MW/L9gjMknzMKZTYnhZACejdu0CDSMqtLZrh8Onug+va05hhlvYg4?=
 =?us-ascii?Q?7NpUs33LM06tJL++IuqWiMdP7nUL3NXfnFIQht7UMkfzHgJhrNuToYgJXPem?=
 =?us-ascii?Q?qaoBK5SwSi0WfNrfsUc91lkZ2EWozc0CgBAgddJsL1ZI8ycaI1kDR37+vebc?=
 =?us-ascii?Q?l2r4PO6utQ9BK9elzYrjvnXUmn0rco2rJHlIgtVw9m22ydxB/M74ieqpLyCD?=
 =?us-ascii?Q?QAnu35HXAJJQaABKl55YBBILWkSpVcfEwD5oB9XUgkaNyzzhted3YmubpM9U?=
 =?us-ascii?Q?gPS2CL+GtdZ3RsYz1z44DAY5NFH3uzRNKUwdD0vRAfmt1+GYPRCrj3rSkT65?=
 =?us-ascii?Q?91NDGTqB16dz6wvniL3qeR49u8XSDassFSv5GQeq+L6yg9vkoTM9CQ92qLGn?=
 =?us-ascii?Q?jWov/Iqz7AqPaDNvazrSSK8Lvojq7OfVNAvxLDvAW/YbeIaL0gV+AUsXaHsM?=
 =?us-ascii?Q?k/z9+ZfcRCLBarGsCTUU0KlLAIu+HF+w44CKYLSEeUObBB/WbosT+V+k3SjR?=
 =?us-ascii?Q?2fDwMp4wIX5S6fvBqMjcMX/qTJI/aFPhVaO8SeSsUwikeykmyPT27TM28SJm?=
 =?us-ascii?Q?pvc/0ZP/qgod+p6B1/DaYOh2Z5EoRadmfY9s7liVefa6zR7oWgkHND4gZWZj?=
 =?us-ascii?Q?6iDdOcnySfsM/t/hhatLZy6H8gwNQQr0e+UvGEV1sWGR2wGozN8wozeKOrWd?=
 =?us-ascii?Q?uE4WPDenJkcY87X+S+czM9nRjEkydDc51/q0a+1ZUkWi+2k/Xw5Fz8QgkR2R?=
 =?us-ascii?Q?WrD5kF43fxe/MwPXDhuIH28QIE4IhoU9NJKdJWnhQcMBZLiNQdvJ4KwL4f3/?=
 =?us-ascii?Q?e3OTzAugMaWrb/K8FY4b5/YQ6o1rbSCZxURyz/Av/UV2UahEQ+Lj51h3SL9K?=
 =?us-ascii?Q?JejPKx5uYj8Ul/IFlfVp2s3h9rhMZHU6H6Up1UGync8ZXvZJMsfQKp5sIRJw?=
 =?us-ascii?Q?xutMdeda3IFwOVCSopFLlpT6ky6qgTZTJKy4Dm/Zhd8zq/eJurK517ef9VSZ?=
 =?us-ascii?Q?Z0PA9lWxIZc00eAJW+IAdfRMjFuCfnu8H9JgvfvF6TuIUyk5sH0hkVH/0UuE?=
 =?us-ascii?Q?ZPcnm8N7xjMWX+quHzLMEGBpDJLtCYlOs4ncC/TPnmDGjvLruHHegSZW9RJt?=
 =?us-ascii?Q?fPCBTxyy+Cy483/HVE/x3NciKRss0ldQixlwiafOgV+VAKYUPZkDfGnGsqXs?=
 =?us-ascii?Q?NdDeQkKe2l2Frvlx0Van79ijdoJXJuktpAPElKddWTviMdoVrN5/G8zukZ/S?=
 =?us-ascii?Q?fV0WTsFK7CAUWUyHVIjufFhDROWCtgO8+XNXBkFaqkTRyoQLF084TJIyh3FK?=
 =?us-ascii?Q?1YqS3qnLULsRiaaR4KT07faFx66Gt7pFH0l4JFW7MHDdAEj/Zylyx1gCLF/Q?=
 =?us-ascii?Q?F/ag49s4fmdO1PHriJ6JNE9ClyCu?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wMRVmHhDhBSj9SCAi7G4eDFK7UD2XAYyN279PGPD6JlaHX+rBd07C+uVFK6K?=
 =?us-ascii?Q?9W+Dk4EnURNAklLSmnxQEpj7hasW5LxOTfxlwsF12bccQjQJztVLrr7sngui?=
 =?us-ascii?Q?Chuvewlk5Hb2harzp0XIwhpzQRCSbLtkZllB1FBHqGGRzPUAYIpwmdmeFY1b?=
 =?us-ascii?Q?mwXGMxTPD08RHT1GXoWrBfRm91n9QqviyIJ6Ex7WODQ1ON2IxM/vYR/vvyBb?=
 =?us-ascii?Q?U/OOjulhvq8xQxJIQl9L7gEAw4qe0ipr5p9yMrGRIvAV2MIbVufxp6aa+94O?=
 =?us-ascii?Q?EYALuH4/GBDIhltrrM2epnYd0xeNpLmsdBm/C0b6z/3qebGfE7OIaVh3Laiq?=
 =?us-ascii?Q?fCMQhonjnvhLAu/wVnnlB0lTEFjHK8G+CIjaktjjIoF2/Ndn4Lsv0f8eaxBN?=
 =?us-ascii?Q?yCsGa1gM69UF2jnwA4bRGcKFC1M6UQUssYNOU4RLZ1lDD7p5kYkvO5h6Dia0?=
 =?us-ascii?Q?BDOvRDwrIyr02zGN49kL9EYKVMwGaeI0ZEtnDF/4YTqGxOn+Xxe8h+sMivID?=
 =?us-ascii?Q?awk0Z6+wwpHFWJYSQpn7h0CrTCR8eVXWNcJiZcZYe7D8SJdIdqzR+rCetOOz?=
 =?us-ascii?Q?LVdRvR1tmMFof9QA7rjJt2sZKzLlAn2ARPsrG5I+cZOrWdIDCAltRW3G5imT?=
 =?us-ascii?Q?xeq4NmloRexf9novyzR9HudC1ppxK70m5nalshp7w+6bOBhvkaPwLH8dUliA?=
 =?us-ascii?Q?wYZcZT4f0Bg2HMXnYh8fU6g5rqhZZVXcvORtXSfX8HBhdmXfmItv0W7sAD6z?=
 =?us-ascii?Q?lzCFjXFjZGMiK0HZVsk4lBtsTAvWEAV2In7mMUj1TgY5UH2QQs4Z4rhTpd3a?=
 =?us-ascii?Q?+TIjq9t6w0wI1hKrloWyt7qO80hlPxDiQHfa3/GkJg2Jzhsm158oAFJFJcPU?=
 =?us-ascii?Q?7YZqKkyrQbmz0wJQnv3geq8hBQqiXo1MUAFp7hWRf9fGl43AsSbCrHFTFHr+?=
 =?us-ascii?Q?OQNRhmsiwvNSX9c7NaONs3+ezdyBIV2NIW+KdZuCXwDcPTU6WLbvZcg6hLxj?=
 =?us-ascii?Q?nDRHjTSxBwGGVLjSNDgplzYHzBa8SCDk28u226NMGvJJ7rDobHJ/NDvlPP68?=
 =?us-ascii?Q?uxkGdyRYAuuecLo+WYaxHJkLGRhqhB6D5jqgm4f+N1wjXwbsbwBNKX0ZZXX9?=
 =?us-ascii?Q?o1MGXVVhUCBLxBskxC+62BrQcCBUcE4QrX/JuMl+cilL8zs5rA/gcqGTyKoO?=
 =?us-ascii?Q?0rJO3AUpren8fXNc2NYctDzQwsiED0KbrcrKxfdVGhOOmMBmlC4cz8CHjhFm?=
 =?us-ascii?Q?iIocXsEHZW1eeSwpu5Qqr6dw/TB3shADnHyufZA6KYkN8znT0COivGoVFmkd?=
 =?us-ascii?Q?/0y6vo/MmbtVnxy8x8cplfegeJBFryajJyaCkbau3vyNHsCcso7feuqaG0j7?=
 =?us-ascii?Q?azj41XO3IUgKT6Ui0+jJBbcUUg3A1QhlolGObA1gn88Eqs0Gye5UcO1496cH?=
 =?us-ascii?Q?dSZneGVEKHtdxR3iZmfWR1ge7LfVKZ9UTdM08Wvec1mO9ks4mbRtFLpMyiPx?=
 =?us-ascii?Q?/ffLG36OcOHGhi/FduCzsstGaXUc3tWsCSjetBXYphBpeMHzy1fpNFMCdcEC?=
 =?us-ascii?Q?rILwoeEyXjkJ7jojHiVyFdrM30OBP/peJxyAoouF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0170cd20-1185-4d9e-730f-08dcd22bafeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 06:33:45.6593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i45mSdruOh05BsYyhcsP/gVYMtMS6yv7lKytGtDEJc1aLD1dDq4Ziu2jIKCYGMMwYk6ATG/B9l7dOnaTIRUXVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7559
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Sunday, September 8, 2024 7:43 PM
>=20
> The IOMMU core sets the iommu_attach_handle->domain for the
> iommu_attach_group_handle() path, while the
> iommu_replace_group_handle()
> sets it on the caller side. Make the two paths aligned on it.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

