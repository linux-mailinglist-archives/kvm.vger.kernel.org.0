Return-Path: <kvm+bounces-35512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E74E9A11B81
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 09:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15080164FFF
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 08:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D05236EC9;
	Wed, 15 Jan 2025 08:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P40u4EB3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E75236A6E
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 08:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736928404; cv=fail; b=mH22CYQXzFH1WVs8S4r4zqAgsOiZLU4s5WzDPjDQPiwgN6TO77WLebWqyXbUv6/RlMUI2VNPbO+71+a3XSrmuD1bALRhV+aCvFMM/4noB+spQja/rJV53BCHGvOMU5lcGPbelmiOzrC/qS91cGshbH+NvOaY/T1pKQfi4Yn7I0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736928404; c=relaxed/simple;
	bh=DLDX5zGYcBAoM/FMu9PaWy1ZhterntVWEEW2MC+fbk8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b6ZsQj3T57Migax+Mm1t8uWp3uOZt824IhXlcg7XJI/M4ANibMgHCeTRDTfVTs4P8Uz9tr+R2RwrGug7nBbaFzmNxB+9xKx1TDYIt594ah4YX2DcYjPrwJ7oU05nYR5uqqLSurHR/ISAFEKwm87Pta+TrOHveLdstjN6rLPTxSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P40u4EB3; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736928402; x=1768464402;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DLDX5zGYcBAoM/FMu9PaWy1ZhterntVWEEW2MC+fbk8=;
  b=P40u4EB3NYrDvr1/7hM+VnY4Bx/ndeafGl3ciUkbv/1g5gSuXnsV1vl9
   KQBuuFMHDsx77bMJWu7JS0UXo+9XtgmnbNB5BKOG2T68UJqdVbT9rK+8E
   j113mq7mxGWiwUe90LtqdSMkbLu/q2OKElADrtFwo/45JOJmKzEaE5KFk
   GaiiZphvqKhsNKx4Vu+X+CemXd/BUlY8ZJRmxeQPKgRq6U1b8ONNBxq3l
   gC3B3CMU26dDo6Sr/+sktfU7faHWVOYL4wMn+1CwKWKt6Tfv88BljJVlS
   7rweISsFIS31VafLAAd/fDFqeb2wFjpCGooj5rdB9r0hznFc5UC12STkG
   Q==;
X-CSE-ConnectionGUID: w/TviywlSDOM7ArAMkSolQ==
X-CSE-MsgGUID: ux0MC+x6T6GF62QF1M06vw==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="47915788"
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="47915788"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 00:06:39 -0800
X-CSE-ConnectionGUID: 0xsF+hBKS0O8k/wrv1QOPg==
X-CSE-MsgGUID: ZP/40ksfQqW3Ft5qHfTuGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="105025013"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 00:06:34 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 00:06:34 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 00:06:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 00:06:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xuh9XQmeSGzuS7Blx6kplHOhbIYvOeNVP2m2b/oovefQnO6iFy440X2rTWwYw4h/cVnqcalzUbBpl5Ajs5Wr7mowiwLAaO28J++Avkcxg/uNsz/M2EzXGCIgX2lxYzIZNSA130OGETQQOUrQvibTdsEeCmUSlydV5Sk/4BmhvSJTnkXJs5d2tzWolR8gmpPoQao2b701iPnYnUHpAfqIROJQuDmdkTQ4/qirOQuI4r1nO5Mz8US80eHiRJz3Uw8pbSTmDvyJFZOYKSgQxbvadeJjiWGkCiSA/1q/Adyp4QWsQDF6GIxw7pMfYbmeb7kRjsS6NgowDzfkhOx00cB68A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLDX5zGYcBAoM/FMu9PaWy1ZhterntVWEEW2MC+fbk8=;
 b=bja1/l3Vyyht5dB1iW0J81EZozJlInqV+psejgg9JJz5OfZUMhQSdSSdY3Udn1c5ZqpbimDJm0eG1yV0ElbHZtjORxpddRG08HJ5N/oV7g8L1gD5If761+Z7Y0ZFjFsugxdCm/lIuL3iLiw5jnBJqmesge0GOY6n/phP0qeMTbLHiFX/gkwd8BP6Kep0E8k7DYSD/qoxdHhOyrK3BQhIgeUcy2KlwdmiHr1ulbwu6Kbw7kRiGKUqSojoPk93OtoLTuQN+lA1VI4vtPIxxVpXrHzZLwmgZasxQqrlAg6BFjRxgosRQ6S98IME5M1XZDS0jns6RbkzraQf5wPbCHEDSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5062.namprd11.prod.outlook.com (2603:10b6:510:3e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 08:06:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 08:06:30 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"willy@infradead.org" <willy@infradead.org>, "zhangfei.gao@linaro.org"
	<zhangfei.gao@linaro.org>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>
Subject: RE: [PATCH v6 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support
 pasid
Thread-Topic: [PATCH v6 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support
 pasid
Thread-Index: AQHbUhro4bQyi7r2YESE0yZEhdMnQrMXpHMg
Date: Wed, 15 Jan 2025 08:06:30 +0000
Message-ID: <BN9PR11MB52766E7F79EFA2E6EDF66A988C192@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
 <20241219133534.16422-4-yi.l.liu@intel.com>
In-Reply-To: <20241219133534.16422-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5062:EE_
x-ms-office365-filtering-correlation-id: 32dc78c3-e9bd-4f69-3d48-08dd353b850c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?EkS1eNZOD6RH4ysxrO4TcmEdE4QW/UXuMd+01AKFdoAx9QQusdGpRXVl4CtW?=
 =?us-ascii?Q?HEBv6aFC00xPXBKXStOqPpfdo7M2TKI3prkkx8TlNUwI6hXsyiGtugIq+vfA?=
 =?us-ascii?Q?GOFSE/gxtPF6OKekYkjGXDci64IdwlD3kxFpk8I13NFQ/vGriISPux3SJlw0?=
 =?us-ascii?Q?Fb+Lu3JhwKHE3NYmWGutk0bJ52JNj5eIkUjV+pzfS4BfxNsqB893shN+tdKT?=
 =?us-ascii?Q?e4SVW2UylKFK7UJ6aDlrPLjJ3uY6r8t9BNIp8sQMRq+JYJvpCTQSJBRt1v13?=
 =?us-ascii?Q?+fnYtmqrf8jrBzdnBRutxT8VcpNb05jAQqhVZb8NuSTN0jLbDCKXdYMqp6T8?=
 =?us-ascii?Q?PmKPkI9JFW5qots53tVQ+Yo7Hk3e3lKrpOTa40UBsWZ92b6Fe07m2TxVmmKj?=
 =?us-ascii?Q?r1ME7rIjTHJsnqH/HVAlCIzQvD/ttDpd5Edt7wjMlVD0tUaFQMGqjk7MgOgE?=
 =?us-ascii?Q?3YRTLojvbXhKyUgf16xwUaXCxLCm6Jja0+A2xGBX9s3JWkeFTs4gd3XkPavz?=
 =?us-ascii?Q?4pOdmCYugUw/gzHGK0C3jjvloXUIFQ2lIPaHnpo080+ab6JH6h1jz9sqMCKn?=
 =?us-ascii?Q?U1ClMoaaz3QTveLO14kajaLsWcbUUtokd+pendAiKXSZeRQnKPPTQ0pBoQdg?=
 =?us-ascii?Q?p7uXHQncN76KuC69pXmJHuwt7ftPKNWKTyYCIX2FvARQMN4IhfAtZGR6srIO?=
 =?us-ascii?Q?hnbx0Og+8UBrt/LBFNqEIwo61BtDeMIxm0cbAKNBApxIJ3Ux0AUsNj0SWKX8?=
 =?us-ascii?Q?KE2znMOGFE+1pcgKdf42gOKNnZVkKWkrNaGrl0F5sOJdQ8anSfowl+vbzEek?=
 =?us-ascii?Q?pn2qbIutcV3y7qLhhvwzdp17DBbj8flPTvflpRVfc9HRjLswr5L3/uxI426Q?=
 =?us-ascii?Q?kt5MgzEjmw24Va9tWqbF+D6ml7cyGBDdunjiTFytuP5J1eYuEmNxEJ5oeRzZ?=
 =?us-ascii?Q?aX5SOXur006m0ed9mp0uNy4SM+ROQ/KW9kaWYSeRZWiBbD7Wwp68GkS64n02?=
 =?us-ascii?Q?gaKV4tkR45qqj0EgGr06cIEwLpevM/MaOJwpU+NmxJn+4QBMGjPIBV1vrORQ?=
 =?us-ascii?Q?t8Oy1QwvRyOW0TnFcHE0dGGA090zrzJmVjXW2L9Z9E38jJc+i7mLj27XNM9s?=
 =?us-ascii?Q?L9qVvTkb1MXvQklXEfmnDmUi6MzWc0UuqTlBZTRc1/QFnNXuX+5gOmARIJBj?=
 =?us-ascii?Q?xtTNQ4YJOY83gqjEbZQlbKfZQVs/KHMNb9ZlAbSrPP4o5srthgXmWZ+97iNu?=
 =?us-ascii?Q?XA5MxvL/2FoV8TCdeGHxpCc/iuOgSF2bSIMv57e0UA4j9JJO9ziAT1TmnrTk?=
 =?us-ascii?Q?g3vc2n/iaDVWu2roEPQ5P1cOqnBHnkLzokeRfztoZD2yNFi1IoAnfpTPRRiE?=
 =?us-ascii?Q?vK5QzG5gbsaEWlJBmZ2Zz1MBRtnulg95/RiGWBFFgYmRXnFwlB5pnFN0tuig?=
 =?us-ascii?Q?a9jJHLiz1ns=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/luAl6KE8Ceq0sW20P+7L2bI2t20244IzvpWJPYzk92ji2VAQZb9fc7z+B3m?=
 =?us-ascii?Q?QvNzCGSrJZMIpQIxNUmbVcn/l6rE2hAjiBRfony0sU52V1NzS9DUsJMGAPJC?=
 =?us-ascii?Q?cbhfU7yXkME1XlcpPQXUTRoNHqMEVAZWdo5i3G9aUirg27UvwjQZArLaZE0b?=
 =?us-ascii?Q?UgkIJZCv4FPqMzPQAOiRyDCFujhm1FADrQqoo1FSTWWba7FZp83vgGkzPN2X?=
 =?us-ascii?Q?Edp2emgivZNCHJVwEIh4yH1C8D9dxF3kuhQYXTGPQnpp4if2owfizPaVMgYN?=
 =?us-ascii?Q?oXOmmtceiED+ARrs3Q79y1tnHLZCxKFRaTZgBEu/3kZkcnFtmcIiCR28nz9K?=
 =?us-ascii?Q?v7nvP33KCdE3vezWzWOW6Odro04PQpr5yygTv1vtPio1VWJYWym+wcfEDC7b?=
 =?us-ascii?Q?WIXuu2YAnP52L+r688d3XPKSsB6F6qP6gzj2OyBhBrwn9NU3iW4xGISY7gu+?=
 =?us-ascii?Q?nOBYEd/Us7kf9CDym6ptgR+QUrQ5v+Qa4e+C8QX2D0gZiu9JzrBkWD4/wv2W?=
 =?us-ascii?Q?Y9rasJO90vthA4Lxk8xHey8E8Az01YRR81aSOe7XYQ9uTdvJdEbw3yu98Bi5?=
 =?us-ascii?Q?DQwtMQcpu8HtwNZhmLEiUaZ2XBr6i7XrzaDAM0xdZr9Y3H37Z0MvCaIlUT8q?=
 =?us-ascii?Q?X6R6TJK8a/Jhl1NkVKr25byT8ZEIYSF/1YixjwuDUqk9XNveJs8cbLBVMim0?=
 =?us-ascii?Q?gciQQvz394Ev0JeIivLZXbS7QPTvEd0C+WROpauycdVEELvxVE+TBlWpnHRI?=
 =?us-ascii?Q?zwvKPBvwavNpzCK5G3SnSiwUKwXf4fQpBb3HG88u7Pesv7uG+crmLJ7v76Z8?=
 =?us-ascii?Q?ukl08Gn48OSoyqWyTgAePpPP/y+KBgPmAm7wPYkcRqOQZ8QHDBEpa6EhHB8u?=
 =?us-ascii?Q?O81Rc7iUHg1iaXeqNNXdiqX0esUPb1/2RxojGFh1RNPt0GSf56sw9F0vnAjD?=
 =?us-ascii?Q?Wqiw0fUxMtLIwsuzD4K3v+eVpdMx/QgU/qnZ32SPjcZRyEefi8TFxV/qSweu?=
 =?us-ascii?Q?upARLiPUYuKzctvz2/gBOey/R1YEPUJsEn7Pz5NDt4u+IfQeSttse214jiW9?=
 =?us-ascii?Q?UAwnnq6ZjXBWAqfQ5pzyIES1D0AIxh4o1rTc1p+hegCaFeOy2AmUvQb7Q/AH?=
 =?us-ascii?Q?C3k9cV23xM18NWkm3AZIWFVJimF/qDTtpYhQRtNlY7gGaX1XoiCf96+QFgrC?=
 =?us-ascii?Q?8GVvrEPv47RauKor8XgYf3jMUaL0miPAvTKxPZPAJFVtGvR7loRq21KlrzZr?=
 =?us-ascii?Q?8ZDHLxJeutEPpiSGUHDdpGYBj1vooyrTDtv1HQbnfb90jg4JpGS5hDsJWehj?=
 =?us-ascii?Q?uzTTTX/T559ALfyZaZEClHsp/YF3F7Wx2YO1i3rHA3zL4LQ//vtiu1t0QdoY?=
 =?us-ascii?Q?hQg02muTtPknZbIfHPwMWwP35iBAa1rnXxtaGxIBSbiKbx83DXw4gWYoXzLN?=
 =?us-ascii?Q?Jb4SURgKSjdin8qGI/DSxO5nzgCp/g8s+HCpgv6lOK6mrdIyROzWYVYlt3hL?=
 =?us-ascii?Q?UnvtHblSCod/Ml7wtmXwoY9kjISnP2gzz6MmJLJYKxPgZal+XQuSDN8tRPuB?=
 =?us-ascii?Q?U591XyJsdx7/pGxDBk5LXQSxMrQtxLMWG71EACUF?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 32dc78c3-e9bd-4f69-3d48-08dd353b850c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 08:06:30.7602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3VydcXbx7jfwdt/q0zwcL56/6+1hzqnN47IBUdNnn3aPjfKYpIgG7d9+PjiZy1Xki+oVsVXI8/QEAM22/U8vig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5062
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, December 19, 2024 9:36 PM
>=20
> This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to
> attach/detach
> a given pasid of a vfio device to/from an IOAS/HWPT.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

