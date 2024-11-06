Return-Path: <kvm+bounces-30863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B669BE02B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A4921C23143
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF661D432C;
	Wed,  6 Nov 2024 08:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d0S51qsq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88B19066D
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881052; cv=fail; b=YGsLIfDj7p3TjKmLXTM4dtIBLCb1XVDv/xpzWy6HBryKTa0FOFW4caE77rIKjQkqMi83kVYXK4Ry0xkmP3RlOFFOpM/9uKaSi57ULl2/bs3evAcLVXTt8G2CfzDy0F1P2SdOybwX71Shl8x3hkr5PMnR4wtpffalzZ1fU3Zyikg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881052; c=relaxed/simple;
	bh=1oAQkfQH7si/5EXXKKKKqgPeDODa3IMIIwrmGMNbFWQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QhBWsAYH2xtYRSFYjeMcpl0qtGz1KtbtGk3bJFiiIhcXRl5BWhkxn/0S+Blsy6GsDrMn7yyKL9sHYYoi6UD0gginEqdsyt3E7HnUVCc5fmOLvgi/VRin/z6TnU4bX1r28eA8rfPymy6c1KlzNkJsjOGPy0Zj8HKEOGW1FxUQzCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d0S51qsq; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730881051; x=1762417051;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1oAQkfQH7si/5EXXKKKKqgPeDODa3IMIIwrmGMNbFWQ=;
  b=d0S51qsqOisuOa0XJAud3YCvR7S9FUslo6MXctypuv699OYrDgRtKFEm
   Gx4pDeSbZ6maHfv6bAO4kXR6yxU8pIV51vE6eRuUtAFZOgPZQHJk5hevD
   h60VSWfhHZyf6WqVclKEvA+RBlh2Yi/0bWdvi/4hDe2G3cdeej1pZMrCf
   bTdIewFtLKc9KjB3LgdkjM+CJq4mS6SiSgA6tOhfSOMdc1twKiaLKg0Rl
   w1XcnoB8G+wiZa/jXBKXETYopfyicQjrDw5qoDD43uRSJ5Zy8YgCnAppn
   rIENb61+sOLbgdagmRHOzbFkNdNCAi+iFzh4DBpcXxW04u1kTLVwaaxfq
   g==;
X-CSE-ConnectionGUID: SlbC3r48SienAULGVhe3vQ==
X-CSE-MsgGUID: 5LM1pwN+TA6X6HEhi3UVeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="56061905"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="56061905"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:17:30 -0800
X-CSE-ConnectionGUID: eUrNgoT4Q6avPApcExdkQw==
X-CSE-MsgGUID: ELrKKYuGTQ2QVe4ZZU/rhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="89251454"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 00:17:30 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 00:17:29 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 00:17:29 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 00:17:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gtx7ybbmeveAz0shmJl1vNEzoSeZz0bigC02LucWSgH1MAnn2gdKo8wpNcp4jPL+oA16TQntn+N0lNrqPUDN2w/2ozqO2S4gfw5VYD7GEce+54v+e8ILdjPlwlLC0kkZoBXEih9pndDzd8vLco98QtYtl8QSuew3EDVmNw3NbJokzR6sUHwOZKwX24SRmz34Dlp9Kuj2LvsELThdWihdHpB4ejweFmIQOqprGw32zcFEt7lRmPj1al6sgMXHT49iPBEhXGenyljcd+hadbHBtFiMTHfG4wspVBlmQQZTat4FhBzok8aM5XUYDM8qYkTNUhItfNNT8l40hxtKZ5e11w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWNglNqW+rUg5t5LTWJJTjxIOFv9JpjhOskExMhKbw4=;
 b=M9IJ0r5C9l632lvS1MrX4QJLeLDuSDNdJ4sE4GWNHEjDkZtWYWjD92kBtFikZhp3ef/zhfBPejJ9wx4SzoOX3YzjwEpI3mlePit/q5p+6EMuRfTdxSF/3NLyhc/V1NCh0RYXmEy4bvXXE/nWUuL2rTKa7ClG3yFqy6Ifg25Rv1NV3tYG3RtqVfBzroxIlhWZ7NNndLCd7G5/ztZOMccEoLMk3QjTA/kyTXUX9GrynOxKpfRr0afl4THD9CimliZgk/IYeU/It5A/TBoOMOaAMPquT5wjNqfIr+EEZp1KabG2uFlPlJPocLNMVL78owYE53q6o/SjL9GGbkeevB9/KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB8334.namprd11.prod.outlook.com (2603:10b6:208:483::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 08:17:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 08:17:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Thread-Topic: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Thread-Index: AQHbLrwgCcgcCX71Y0C4SXwzGBnNu7Kp6vUQ
Date: Wed, 6 Nov 2024 08:17:20 +0000
Message-ID: <BN9PR11MB5276F52B50577B8963A20BEB8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-12-yi.l.liu@intel.com>
In-Reply-To: <20241104131842.13303-12-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB8334:EE_
x-ms-office365-filtering-correlation-id: 19b49240-8bca-4a51-a13d-08dcfe3b6f7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?80urn+/C5iQP8nl7wB3Xc8npFuC3qjzIYbQAo6kUOQ72iIC9dxIZw4Z4aOUh?=
 =?us-ascii?Q?iPFS63lrkmq5YMxT7CSd7e1j3R6KWKyqUPrIhQb0MjxRVivIJWYgt+5l3rJt?=
 =?us-ascii?Q?4D/koXDTIhU/Z9+aD/m31L7vkZ5cRbWG6K1iRN6rwgubZ1fdVee9RBW3+e88?=
 =?us-ascii?Q?gZXeLVFDZpDyQ3B2GWv+8APcVfpQNH6fiyk/KHFLZj+0FqytNAu5JeIkKMA2?=
 =?us-ascii?Q?4GPSnuJuRcPq3gyGtU8tXn3rwVOXF/sJqCTYCdOENZmPW0WHeD/1TMRqWKwO?=
 =?us-ascii?Q?p//MrmwFhKGfKsRZbT25VnyOA1wk1rcC47P1bBM8p2wccQCPIWYge+9pWnYn?=
 =?us-ascii?Q?iGbAeLYS+gekwhLfHmw+rC+D9CMHXqfWcgfMoMP/N7wdlg2LkDNvNrFBlUkE?=
 =?us-ascii?Q?v/VyzdOvxM6DU+N4vc1GEPJeyygAICXsZ9uF+th4KS7i4BZqebJ9P3+ho3iJ?=
 =?us-ascii?Q?fTOwaTYSR2NsUgE/DtQzb5fBqY6vA0pgzLMlyDhVbsDnSLE6KHNJfvdFWXJw?=
 =?us-ascii?Q?n/TYpovW4uae+z67QQ2j56VThCMyIJk43QGk2KbQ0HnW9iAYAYKtALmxTSIW?=
 =?us-ascii?Q?n7b0/ur0JH1QkDjVWqYQSDc7HyuooasTQzSnICio5Sd+0rdx1s+QbiJpMhg5?=
 =?us-ascii?Q?yNYsioVBS58vwpUIgvKqACudQfX0/yo+lCTZaO6GbqEhf0Y0jt64NFjNPz4R?=
 =?us-ascii?Q?COBqcr/LFTc7m+pUl0URZlTOAtwaqqkrFFnK4j2MSJLo7hN+HqbP9+J9Buoh?=
 =?us-ascii?Q?k5XR0ITB/l1ru7fKfpRyhbAc4Yn/EKzEh9Qcqt5MMpfVNQIj9W4QPrBg8p/U?=
 =?us-ascii?Q?HKgMJGw20omkFO5uzwkrar1USWYQJvW9al8q99dtIH/WsOuKrEsP85E1NzkR?=
 =?us-ascii?Q?FDw7PUKpjAUln6EklRIK8l2BiF81BCNZut/mK1lZXOyoo5KHlwg5e345PRjw?=
 =?us-ascii?Q?WQeX04c626qcMR92IZjQS3BH2Nb1LsL22psc3iw/fy01chqXiqKFMzFJqJQt?=
 =?us-ascii?Q?CGxKRvDaQNlGaYEdygwQJ4FEP/2B7gAf2GTW/1wGCvY83Ine2bm6MSOGDGnt?=
 =?us-ascii?Q?B8GGW7QFl17j1ObqRPq2KiqpLtHUWsLqzX2DhG1CyLNHMMWLXMhs/d3J3XLa?=
 =?us-ascii?Q?HZx76Z5o2p09vd0RDOlcRyrGIv3Zg+pfaCN5J5uUQNFN4X+IvzPYFe3Ps8If?=
 =?us-ascii?Q?JNFDhrQTktR57hLvWmmLU2/OTQMGFFgW1o3ozcGQqizJ05n5XJ/TC3cvMJZ8?=
 =?us-ascii?Q?2j/0MSwQpF89F7JqNw0/JPVZgIeWe4S5xijovfcINP1sYj76BHeO4VrXTUCd?=
 =?us-ascii?Q?k6BiIyVnXyN2UvZNSCb4kfB+DD3SJ9wCEzpihQ0cMOZBieIK8YGwBLPcwwyy?=
 =?us-ascii?Q?z+Am91U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uTTbpWbr+rEVklmVfxvzMbbP9KLVPJCEzq8QtQNlx719sD+j6ALBk1y1Jc1B?=
 =?us-ascii?Q?SHf/uCEZTHkFBn0BbDflncL22kPRZz76S/khY9rYR4jbj2NIOuFBXYdR0loi?=
 =?us-ascii?Q?X0gNjJzE7Y9mEsBwfUqlSRK8Ho+vbIoTjwnQeYdFQOoG6gZbF3XHlCKCf/ML?=
 =?us-ascii?Q?OM3FSXcSe/stXpieR7S1r6/uydYXQjuEWeEN6IOQlRlUshtPrFia4oa7VlGZ?=
 =?us-ascii?Q?cSsLAz9lELQj0/OqxinGjSRMr9kVK1V8Nidl2yIyv0W8lgJ/asw9zUkkwiiw?=
 =?us-ascii?Q?aFciP9c9o8iq+K44FzoTBPBxACnAYK6xrvzwYTA9xhLpeS7rBk1DgLcXWIYE?=
 =?us-ascii?Q?MFI6/rBpoYoIHaHJWL+JJylGf73bpd8B6GGQdDEsek7Lr8Cum14HjaaehRfn?=
 =?us-ascii?Q?XnsKljjJf5t7VBJN94RX2Wyy6oKZbz1r3fkOksa17GxyFuvvOYadWWES0HD+?=
 =?us-ascii?Q?2K0Uty8MKjvKl7B94x5+ODq277laM4kMmpo3IxZyRJilE767/iRmlGE+6Vvu?=
 =?us-ascii?Q?wTJMYzctyaJrg6uSNGS0aq1KrYf/ClWIOTHqEWujg+t/i7p3lZ9A1AjQ4txy?=
 =?us-ascii?Q?EEWrN43ujqRyiEHdMjwsVp6zLX3FZfaR6vUGzBwbWQLgnemAWyMNJKp1FGvo?=
 =?us-ascii?Q?wxfCfRE2nYUXQ0CSQWs/j6xNZY2OLOpK3Di/v/xVbPTiHvjmdWiOEZjGlIPc?=
 =?us-ascii?Q?gRTs8Ja47BGJxvt4qZjL+ZrWboOSmlZwn0+A6dnhcuTe7mDBlEY+VP2DRcwq?=
 =?us-ascii?Q?oK3h/Mwen6n93k20F4TpqFQ4DYfeUfjvojhJtsnOjVyDDA8BJjIJZlG6P0ch?=
 =?us-ascii?Q?oD2zIeVX30ihZmEWoWsJq7wV2mzEC2DLP4Kgv50YvrgS5c3Mf2vUqQOiqq9K?=
 =?us-ascii?Q?OTRa9SFAH8urQozA4K+jMMKI5AzsaxeKAZ22b/PQduBnOMk1qwsesx/lEH0D?=
 =?us-ascii?Q?IpzYIuxoRq9xBIcA5vz1ODwvVUYS7Yk8sr86QYoh1rhIF5JiwHnBr0LWlUFA?=
 =?us-ascii?Q?og2KHhPlQJ4pdd0AW5R0jr/Ct8R3yndQmLOM5CKn0uGmf4UG7ULPmT1UTseg?=
 =?us-ascii?Q?Tw4iYHnOZkKjFgDw0SM+fhThHvfcKt/X2m0c/bi5v5wvDPM3NmeIZ9tee1wa?=
 =?us-ascii?Q?CefURRFzDD32iouNkkpdAgW5ZgjUS2Y4ZrQDQV3UeuaLoLLQ2LAGkFsk4j3A?=
 =?us-ascii?Q?+BpIJfnHNy5g/bW37dzCVzAgeaEqO1c0BArkQL2h3YG8aGzSkQuoJMZt0G6x?=
 =?us-ascii?Q?1pc5/Ef6/4PdQgvUGFBKBD7dVc7v7gyEA5gwVTjEPLHaabybrSP0fvp+HFyL?=
 =?us-ascii?Q?oPB4yLQjvuNYR91l5nmhT4WXExBGWLwE4oS+T7UnLUshF0uS2vBxBmJA3F9x?=
 =?us-ascii?Q?B3vV17C/p/nAMiMrQ2bUt0OowVj8lH90id1Ezhhp+YYlUr4hwO8lAg4KuX+M?=
 =?us-ascii?Q?ms+0Ka3oTrswcz0Fj7xVGMO7zyoo7KQRwpP+4PlMNc0TCpuRkAup3x+B2VD7?=
 =?us-ascii?Q?X8kHYyB5rzevjt+DbE0RQ3HMOv21uvxl1EeNKyFoL4c9z6Hud2K08gr8qfnZ?=
 =?us-ascii?Q?XmcljFDzMmAV8zJoxYJ0vfY5Il2uZKsJkSFG7Rzw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b49240-8bca-4a51-a13d-08dcfe3b6f7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 08:17:20.6557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /XXq8keRITazinMf+Qvb9xUVyZvAxEBBh1EwGK9NFKYMf/hUlVmBNgoZXCm5V0ZK4VKL4x/TsfK/1ex9LUM3lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8334
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:19 PM
>=20
> +
> +	dev_pasid =3D domain_add_dev_pasid(domain, dev, pasid);
> +	if (IS_ERR(dev_pasid))
> +		return PTR_ERR(dev_pasid);
> +
> +	ret =3D domain_setup_nested(iommu, dmar_domain, dev, pasid, old);
> +	if (ret)
> +		goto out_remove_dev_pasid;
> +
> +	domain_remove_dev_pasid(old, dev, pasid);
> +

forgot one thing. Why not required to create a debugfs entry for
nested dev_pasid?

