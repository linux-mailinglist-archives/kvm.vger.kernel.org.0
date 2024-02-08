Return-Path: <kvm+bounces-8300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC8584DAA5
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 08:21:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E698B215BB
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 07:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D821F6994C;
	Thu,  8 Feb 2024 07:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oxrv8F0g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514D86930E;
	Thu,  8 Feb 2024 07:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707376907; cv=fail; b=YAeHPv8/vnKbSbFL57zHZp6IZ2TbAFI3CkvU7pke/Cc5BkTJcars+PziPEREWhA4NS7v7Nx3UZemee8cKPapeNxTW7x+Wz56re+dJ1ipspLADOP80d8v3YJQn9csNpOueKDsgAwGGayJZlhxsgIIdIN+wMnpojYJIJRmzrIVrnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707376907; c=relaxed/simple;
	bh=pjHz9bJ/dCst97MayuX2zimEf/Pgqko8KVofmSIvLj8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ycqva6++DSJRnfxJv2iZOcS4kQre0g1tMmuoK9S+UgwrZjdBuG4IRRJEL7mo0sU+3wA57yookP/qjLZClezCFWTYtopusWxHr18ot2yJLMeX/NjVdOgYXtDM61Mm+UPUOjnlQLr5uCaY16H3HxCuuHtaFxdoOOxqY4QhQ9gz4ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oxrv8F0g; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707376905; x=1738912905;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pjHz9bJ/dCst97MayuX2zimEf/Pgqko8KVofmSIvLj8=;
  b=Oxrv8F0gGQq1wZWErh2/Ga9e3xLG9ldQPHd3r0bKotB7zc6eIlfR1q8T
   CMolRHonrKxoCmH+PV3/LNF4X8WpsfGubpGas6BjyEQZrtQThtwPAkRam
   mDHpqgQSjVqXfnVed4hDz+nRRGfvbWadWGv0InP8Kaw0ZCOKHWe1VeIJN
   kWvK5o0XHbZ6Pvj5cXQb+ZTLZvLI6wOwG4eFrW9iXJRg++JnvW3nKyoLG
   gWxrnICUEuMikHapnPMq6CZWR4bHd5cEkOPOJNbNxdiPuH5PfFEYJr/na
   5Gr6HAdQ9N0BZK/Yy488z4QeWs9epPKuTpJ1yuzlad0Bu08fsDpslO7Yc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="18584243"
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="18584243"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 23:21:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="1868593"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Feb 2024 23:21:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 23:21:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 7 Feb 2024 23:21:42 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 7 Feb 2024 23:21:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ker5r+DIlFUx/HcPIwIl13T/wg5tvGVSLLJru5UP8MLG9lcpRphJIh70YwinY6ioZnXq8Z8gJzjb7eu26AQxkEiZCbxY9Y12BZeVAurkWMjf6q26FdwTcqAieT4U1/FIqPvajwYM550dgxBi0qI2TE3XcXI+JngzD9W3RoCwslWoFSYCigU77Ei5r32ULnR3ZU9tKmgJ5O31YE3Utn8Wovwi0IRH5ur0gHjZMLuR4yZkThSadDZSYNWoRHP4/U0jAOwKfo08r49F9YnMIIjWS7+TKfI+8l6l73oYcVIpdHqg6n04ODVyRyPZg6ZpDwjjrCk3CtUzKUPAkIA8mZHvJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWPCycBeFceLLDePCIaFZxgks8Hf9eTmEhr6GREefKU=;
 b=RVXHP4LXl1Rd5WrYXLeZG85btqpAc+J0np+Ts16bJbaswexAdWBie9khSibSueDrd6zHGeN7UQIftwC/Wm66CL4eHchMxCtcf/SpbFwqEJJBtrhII7C+91lYGlQQkyRq5uYbDjPpspuNZAETjrF4/lrATirRYAyZa9AB/LR/z2x8Tdo0ylvDuiLh+0G5QT6iburHePJXSEHh1Op9EPnpXtLeQNq+JiauNHsWmJLMQF00ZkWu0MBxkx2IZSFIF6qArprJw8VycnW01ZCO5RsmL+FFghxrr9bOMuQ9OzO7N+lCO+I1mQYKc7RvL3kSOU2uRbbD+uFuQlNkiFCggU5Tgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4819.namprd11.prod.outlook.com (2603:10b6:303:91::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 07:21:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.038; Thu, 8 Feb 2024
 07:21:40 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Ankit Agrawal <ankita@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>, Zhi Wang <zhi.wang.linux@gmail.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "clg@redhat.com" <clg@redhat.com>,
	"oleksandr@natalenko.name" <oleksandr@natalenko.name>, "K V P, Satyanarayana"
	<satyanarayana.k.v.p@intel.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, "Currid,
 Andy" <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, "John
 Hubbard" <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj
 Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaWIdk/6Inz9VYRUqD8voDMXYJJ7D/eesAgAAPggCAAIH/gIAAATfA
Date: Thu, 8 Feb 2024 07:21:40 +0000
Message-ID: <BN9PR11MB527640ADE99D92210977E7CA8C442@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
	<20240205230123.18981-4-ankita@nvidia.com>
	<20240208003210.000078ba.zhi.wang.linux@gmail.com>
 <20240207162740.1d713cf0.alex.williamson@redhat.com>
 <SA1PR12MB7199A9470EC2562C5BCC2FAFB0442@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To: <SA1PR12MB7199A9470EC2562C5BCC2FAFB0442@SA1PR12MB7199.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4819:EE_
x-ms-office365-filtering-correlation-id: d298099b-987e-4388-6f79-08dc28769854
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PLQunGWM6nS8DdWsui/GKWU//UaNuqZnaicCRUwqjAOD1tNbR4G8OcIGfp1QPecKzdlAHW8Ea9cWxTuqMTFA9ftzjEkPC3YLd52A+2BwrlDdZ9PLzJEqzIDb+n4Q6daRTVQDZKzfna+cZzqX02DMeKbif98ObPw3eHEIthzIiP4yN9YFXNtOWzHXpr6koDqScfBG/gK9TFoHVQRnmvdY0WESBItLb6kqxRx9Wqj8fZpteZNumfwLQPOjjKmbY+RAvjedHoS9H8tRSWAuMd00GZrruY6U2LU4ez2ek3r3StKiWDdGlDXyyS1MyF6gYtCDLhb0YKhepOSTWR3RPwJZDo6oPkMa+lq9xDiOXD4ZlHsM8w6seZXtIFEUqRthAmWzL5T15/YztfllPhE9edhxJcx8GTFVHbbf9TaOdW7XypICSb7XvzOkmxdUsewoXFK3wl6FHlCFjiSOI6dMtAAIS1dKFAh4d26OAZ7qGvhiwT8q5jrYuCcho6tqCY6vKvaDjqSv0SmGgwFqREKqVecSJlc4vxS0KsY5ohpqIQeW0LD70E4X9ISkDQtmmrUI2M7l6zkqsY2EU/dO+8pUI9tGZ+I1LrJslwxvw1lW6obiqkQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(376002)(136003)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(7416002)(5660300002)(52536014)(2906002)(55016003)(41300700001)(83380400001)(26005)(122000001)(86362001)(38100700002)(6506007)(7696005)(110136005)(316002)(9686003)(8936002)(71200400001)(66446008)(478600001)(64756008)(76116006)(33656002)(66476007)(66556008)(66946007)(54906003)(82960400001)(4326008)(38070700009)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gW+YGVqck3o5RT4xJ379cEIKtG75QOjx76gwBHRXZxO/bCQTszLwRB0CNr?=
 =?iso-8859-1?Q?4GA5NoD/SAVin+XMkY9KI6nbQRKwM19xu6zoN4csW7PZG7s5KlkEMcFRw+?=
 =?iso-8859-1?Q?gLiDCXCHXK3dpZiGXRJXlYclenk63+OGk+wQiC4plPO9WAHTB5bgw/RTwO?=
 =?iso-8859-1?Q?6qF3l722QcOVd7KlSPUbQlc7ZF/LHt05uM24EMx9wbRukqV80vXKQJ/b/R?=
 =?iso-8859-1?Q?HdBg6n0LAymIAtBHVoPpUWLLXJvr16oJYrCp9AutFt5lW6qZZUYxXtNkiF?=
 =?iso-8859-1?Q?cL8x4nrUf2EOKvIxlUZpoP4qnKAe4R+ZIPh4BFtpFuegpl05AUrmCc0Sxo?=
 =?iso-8859-1?Q?nlS7+7bTm+OzsQv2zaUqzZMe9s1Lgu497ydsgg6ae7lyeSil0qKzyzMRSt?=
 =?iso-8859-1?Q?iyxyhaZVXDzJBU6cSMX6pmg999N349Yc+C9eK/YidkfyJUb4XCZSdGSK2A?=
 =?iso-8859-1?Q?ojDPK9rv08UX6C1vkFHbNZc+oZsb+OWO7WhhBbUOcht/h1aeLsgf6zpPQg?=
 =?iso-8859-1?Q?tqmmEPogqPCHrNCo3z4HaDombSkRmiajwXbphi3Q3zf6pX9PEEnHYlSi14?=
 =?iso-8859-1?Q?i0oVboRDuJFtO0pIWyq4EG4ODMDNcMw5JisvUw4QJeqOPzgNTORfw3f76Q?=
 =?iso-8859-1?Q?7WAKNMmU3D8OJ6JjD39pmwvtQFrweHYcyNlQbCSfy63Ri3u0hdnzkCgo77?=
 =?iso-8859-1?Q?wzpYLg6CyLN+b2dsZ//IJsYEsVJktCl1nEgg93TsHixQOlxYJQGVzTvc5W?=
 =?iso-8859-1?Q?2x6tj281i5N5J+XCu2tsmeNitzguZLWKv+FD2SBvIfvoa+EZoVjwP9eh6X?=
 =?iso-8859-1?Q?gHhMcHwRl9aW8C0qm9U1CFvjFz13O3CVImNz/ec9DcZhzjDoGW1tyGl6gL?=
 =?iso-8859-1?Q?iApSHlTLWCogjZOfN2jCHitKyqX5MtxtzZUjIr3dPP+EdJzUDlO7duqTJ8?=
 =?iso-8859-1?Q?/+rlFBrKwX2W8+qkgcP/HRFZab7KIqtHwYbgznshPGKEKOvfCwoPRmi/Et?=
 =?iso-8859-1?Q?EmVTL5Xg5I//mLJR8e5+327WWbXTr6WoWzve9pniiDjqsLQnt5Kn0/AXQ4?=
 =?iso-8859-1?Q?DDjPUKFUGmPYQB/3DyLkitmEecIDgFo5o4BOnOfxZER7twyrBmWkJgrgEy?=
 =?iso-8859-1?Q?A2hM96Q6Wt6WrgAGWs8OF/pEETUaj1rdMZnAyhFrCZW/sQrcPevQ0lAQ2h?=
 =?iso-8859-1?Q?QCicudjOcEeyCiyDpsT4qvI+I7eusMwNwBR8201voxtOReNSz8uy9NDIRV?=
 =?iso-8859-1?Q?GGjW6TTRtSEM8Y3QJb1ui9B+RECuL/CyUXR38lr/oLUP/CoZgeuCqN2uiJ?=
 =?iso-8859-1?Q?zaXBr4uFMUsa35WpCibKqp+nImwwFcUmk7Sj6Og+IVXwKmfI7+suYjU2iI?=
 =?iso-8859-1?Q?/TjMZy9vVLzyFUNY4CQ2/a7I5Fig2+ZrO4x7alMBUmxNE5jE4j0YKhTZph?=
 =?iso-8859-1?Q?gGqsMGNUyDydPHknvxkKKyRiMTof/rcy0f/nS5MRczgxn1jnf77qDp3YVp?=
 =?iso-8859-1?Q?gTieMY7C43bKuwSg7aW6FT2X2l7v/xUyLS27i0So0bQ5ZeB25EKVEAc6LJ?=
 =?iso-8859-1?Q?UtURksT9EJ1mGokAwrNGmYLKVAqpUDloVZ85VYMwCr6HogO5e3fYrPI0PB?=
 =?iso-8859-1?Q?iEkr0wBUuoZJ1KV/Ps9yadvOfamjDlZSx9?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d298099b-987e-4388-6f79-08dc28769854
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2024 07:21:40.6066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OL+zKlqhZ/u81aNFkNWILX70t0lVvoCJE1eNHwl9B55siZCifaCpJJk+EBlwdfjWGKMdJrll4NpK8kudq+D1mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4819
X-OriginatorOrg: intel.com

> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: Thursday, February 8, 2024 3:13 PM
> >> > +=A0=A0=A0 * Determine how many bytes to be actually read from the
> >> > device memory.
> >> > +=A0=A0=A0 * Read request beyond the actual device memory size is
> >> > filled with ~0,
> >> > +=A0=A0=A0 * while those beyond the actual reported size is skipped.
> >> > +=A0=A0=A0 */
> >> > +=A0=A0 if (offset >=3D memregion->memlength)
> >> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mem_count =3D 0;
> >>
> >> If mem_count =3D=3D 0, going through nvgrace_gpu_map_and_read() is not
> >> necessary.
> >
> > Harmless, other than the possibly unnecessary call through to
> > nvgrace_gpu_map_device_mem().=A0 Maybe both
> nvgrace_gpu_map_and_read()
> > and nvgrace_gpu_map_and_write() could conditionally return 0 as their
> > first operation when !mem_count.=A0 Thanks,
> >
> >Alex
>=20
> IMO, this seems like adding too much code to reduce the call length for a
> very specific case. If there aren't any strong opinion on this, I'm plann=
ing to
> leave this code as it is.

a slight difference. if mem_count=3D=3D0 the result should always succeed
no matter nvgrace_gpu_map_device_mem() succeeds or not. Of course
if it fails it's already a big problem probably nobody cares about the subt=
le
difference when reading non-exist range.

but regarding to readability it's still clearer:

if (mem_count)
	nvgrace_gpu_map_and_read();

