Return-Path: <kvm+bounces-8294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4464D84D9DF
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 07:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B1E5B23938
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 06:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C301A67E6F;
	Thu,  8 Feb 2024 06:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NPZ/pliM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8D94314C;
	Thu,  8 Feb 2024 06:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707372860; cv=fail; b=PedkIQtOjoNioViIgeceNJPQ8L1TXMWXhicHnOqQxdHKvU2vopQHR9K2Sjnu0G7Z751aqV1QcXigiJvjodQIq3Ojkasrdf8UyXfnN72IY4SDJBShZ/nw3UBIzoQsTl2TfPa8biRMwnUATplfjfgQXUVampLSAEBeLIUkDfEB6rc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707372860; c=relaxed/simple;
	bh=e6GAKKVh7zWXFoUHNh3qVnATAg0S3sFejvSfdVy5/yo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lQlqNDXBDqG3vh/1U1UJq2+zVdWMDGyRguew2xOiFmJdSKpu2U9ZeKG5LleYe/3BubeqATzCMfn4rwJaArhsxAv7ZLjbjzOtlUpV9fVcNKyS+GU+4As7GbHbm5PBfU864MU7StWycqvquzIN6G/UXX6i6TNl2jc5zgNrgaFf6N4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NPZ/pliM; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707372858; x=1738908858;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e6GAKKVh7zWXFoUHNh3qVnATAg0S3sFejvSfdVy5/yo=;
  b=NPZ/pliM8e0OwBP/VGzCJFUcGeR7n4zyuxWLv8x8YcugP9qN55NCiB4u
   5fea3oblJRBwb2onPOANl8ShYIjdYGwTodmzRcwh7JIwT7+IPISNdC3tU
   jJPwbIkFMWY3bi398gTUrxp9rnDDND6ZMgdUAXmVDIig25jR4SAs1Aw0C
   mmw2YVhMG4tip96bKaErhnV4l5qgbFm+duB09NC4DjtFgtTx/jlkbIw0j
   bKM73xCBX8kyPyFobAhW8eZJMZGdAFa57OjajXj+kyMewbOjHj98FvQMw
   jVgLRAVSWuTVpVkok3EiPhIkCQq4+kyWzixVWzUaU7mhopHd4X3yZiCEd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="4134859"
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="4134859"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 22:14:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="1852710"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Feb 2024 22:14:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 22:14:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 7 Feb 2024 22:14:15 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 7 Feb 2024 22:14:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My2ERBkDyCeEj4V6tBBAjmX230G3kdXnn/a3AFh/JmOz2/oSUoDeXrYQjUZiScSP6Q2R2T6NkCZ4SbBtJKfq3eolr7mIKLU4kkCSQZjaf9TqvkIpdjQzqsfhkgOkL2jLEPXgPeqEbrNuAzdgXhPyDkvxmlGzFFky8Gm5rl76MI5Uh8D8SPrwNTdbygaTYwV1+ufxSXadgWJQkqkCE3AGk2+61xMcU5BzxtpfafFzmBbC9Bh3vLy8AkdXHwQjzqUh3XowFYH8is1rgH5LbhIWsu4UQzld3GVi4ulcZQTimik4t36vs13PK0H1JGEywDPnKLKv0OAVjeDv5E5nId1OYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6GAKKVh7zWXFoUHNh3qVnATAg0S3sFejvSfdVy5/yo=;
 b=NC/oEhphNNDio8pktjjzCLS1bKdb7a1s5SOSHUYpkQwUbfuwoLaXhI1tSRnEbHAWCMPdHio+2uJIl8/0jsi30DbbKlpM9XwfUldqG43U2P7S/A0g8oK4wp8GhzxZ65feeRWAWhKNsbemrtRRq0/rmYBI7kEKHzyMHMshGMnbC6Su+qvadZ3ZBHpNXWcvnKITTjSguFFm0TdWrxbZsnC0RhjCyaQjfI/rkrfnFIlpS3XwGxCz+RaYX8TahoExCar6k1dkR60Iqf9fKmAIAmuuHBpEgyYJyzgD8gLZMf7akTBmskHhRt7PfFvDnY0n+SZBlLexf2dhP1z2bITuvYBZaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Thu, 8 Feb
 2024 06:14:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.038; Thu, 8 Feb 2024
 06:14:12 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "ankita@nvidia.com" <ankita@nvidia.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "clg@redhat.com" <clg@redhat.com>,
	"oleksandr@natalenko.name" <oleksandr@natalenko.name>, "K V P, Satyanarayana"
	<satyanarayana.k.v.p@intel.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>, "rrameshbabu@nvidia.com"
	<rrameshbabu@nvidia.com>
CC: "aniketa@nvidia.com" <aniketa@nvidia.com>, "cjia@nvidia.com"
	<cjia@nvidia.com>, "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	"targupta@nvidia.com" <targupta@nvidia.com>, "vsethi@nvidia.com"
	<vsethi@nvidia.com>, "Currid, Andy" <acurrid@nvidia.com>,
	"apopple@nvidia.com" <apopple@nvidia.com>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "danw@nvidia.com" <danw@nvidia.com>,
	"anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>, "mochs@nvidia.com"
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH v17 1/3] vfio/pci: rename and export do_io_rw()
Thread-Topic: [PATCH v17 1/3] vfio/pci: rename and export do_io_rw()
Thread-Index: AQHaWIeJH75ep5ytUUCRGltyMsdzNbD/+uig
Date: Thu, 8 Feb 2024 06:14:12 +0000
Message-ID: <BN9PR11MB52762A6DD41ADC543B4060998C442@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
 <20240205230123.18981-2-ankita@nvidia.com>
In-Reply-To: <20240205230123.18981-2-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6733:EE_
x-ms-office365-filtering-correlation-id: 550d3cce-8dc0-4da2-5734-08dc286d2b33
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B5f2NLV5c56y+bifyYiR5QKPWPxRK+eJ6uZ54JOSUGApCCdw1UFjHyYhrxmZYiqVQz5vbh2QTgNDunnT1clunOwiL4MprrljdIuJgpulTawQJ2MfmRsgF0FpufgGNpxGi+aVPmr3kitBP8j/TKUywkPOVKoCZ6uo5oNCNlay8KT0S5qok68o+QrXblCC113DitYQ/ajNVIm4fUEH7NlgoQhxW5N4Zbn9p8qxT6rX8yuWfyWBuFyPq+Ptp4fe3Ewj/1kBWNyVGKwKQ2mygxTDyk+EtVvf4BZQQjF7BfHJG145SuPHIJL3b0wcYn6pWyRfInaHzavKffPtU9SqkfYvJqXYamFYsNE81CuRex7VJQ7oTqIYH6GY9ffnkScT7Mf3z6xz+FSOxKwiOFUOlqvLj9lBuYYZ9IFaZRWQxj8b0g32fEnHcXjzUgTi4eiePvVOt5tC/seWonb+m5k5SBkMsXKQLZZROHqp1vlSvy/M3s6J50EY52yX1vzBL8cK9Sg+9R8yDDgo+zdlqjzN75LYBLix/naTNbcYhJkKBITVY51ggPLsCieC10FEJ5HMCvopQT5VwnC5arjsTU/NO8gAGKVVBxqtpr7g0MLRVmhRhwbJoM9zQP75SJI13yPYHcko
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(39860400002)(346002)(366004)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(41300700001)(66946007)(8936002)(76116006)(66476007)(478600001)(110136005)(54906003)(9686003)(6506007)(33656002)(38070700009)(8676002)(64756008)(66446008)(71200400001)(66556008)(316002)(52536014)(4326008)(82960400001)(7696005)(26005)(38100700002)(122000001)(86362001)(4744005)(7416002)(5660300002)(2906002)(55016003)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4Jg25tw8B3bWXqTbYO6AEr+omkAu+WdLbkUHUFt1A33sN18tld1KP/j+JsHk?=
 =?us-ascii?Q?ug3QY2WsW51xbWKwfecvqTKuly5Y7/si40SyNxzYVpM2KPZoxt6H9yJqU5zo?=
 =?us-ascii?Q?D5FtKXowdQQIN14It2D80/kWPg8b/XOJXcgIPcENaXSnCwA0OQ/whJescAdf?=
 =?us-ascii?Q?3h4iR61JrHUHf6wWrxlS3yjcJH/iuUvHAmJg4ROnEuQK5AAecS94hdb8oJ0P?=
 =?us-ascii?Q?f4vsD/PB2ksaTGOHyLx71uJs+N6h1NFjiSChxY71CiRwlL4SDi5f7a9dN8Bf?=
 =?us-ascii?Q?6eBDPX0+CNmsMsApP1VDF+G95N9ckeYNUPMpFdXne5/cdrxWl3iqwjw1o/rr?=
 =?us-ascii?Q?kfo48ZyiH63jh0tdiurcm02bzk0ZF+Q6V8Lqrt5krCvpNOo3j9ykXG0cW59+?=
 =?us-ascii?Q?ii+MJPUNfTKTY0p/EwYJXcLsFE0lD3PxGfeRvtoDtlq2KDoP0R597fszrOaD?=
 =?us-ascii?Q?2V68wNIcNxioQDzXLKYqWVvaTy/3zqehFzIJPnQQI0GCFtYpGkecUc22Fb9n?=
 =?us-ascii?Q?Vgagotfa5lo8yodMDkmdKIJbhaAiJgdp9tqz888EXQqf9knuGoiLw2JuS29G?=
 =?us-ascii?Q?cnrz0kFWS8XohxlHGM8xrq98uhFlzXjtnjapeWXFVoCr/5ENaxrvISKkiS/0?=
 =?us-ascii?Q?2yjvFysSCJHfzxTwwsGLM+zE6YjB0g5iXul5dkI2XYA9inOf2u0yafr/6UZh?=
 =?us-ascii?Q?Ne2pWhP/s6rOXQR0ztOsfxIjceDa7cQleripW2bO8TMsJVzc82UFqI1w0fUH?=
 =?us-ascii?Q?dKzeHI4pWCzYaGUflgHAeh5YWT76AiRjlfqPAHDK2RH0ASKd9Nwt/LwXFjm3?=
 =?us-ascii?Q?L5PJtcPpssnbZhtmGUUTMGXM2MZk4KL0SGCLP4qnNowgUMNEGKkwJcXqSxkw?=
 =?us-ascii?Q?xGfdtknOM4MQT9A2gRaG5EYUE5O/Q46Ct+hBogaMNPzAT4vKuf4OQ5myrmYM?=
 =?us-ascii?Q?4fUdwymMS0rPetzzP9Nf2hln7xrcmlLLyYpmHDeEW09ikahzbMvGQi2YGUrK?=
 =?us-ascii?Q?X8Oxw285UzdO+Xk25ygDhKErWZeUyyEzzqrC0scZ0a+OuoLxIGOaE/P0C1DI?=
 =?us-ascii?Q?Vt9IyhPt/HWtNIhBo/mN5GouXlFNoUMY0vN3B98tWH0xZuKKB74MeqEGTh6L?=
 =?us-ascii?Q?rM/TSNXIEcNDhwu4wERkUdbt9gu4zOzyY6SV2haGG2DFGy58zInSWF4EJDHq?=
 =?us-ascii?Q?T7D89kyGiYh3DqhyubOkY24qMDfdY+txwwzc2YNzbj2pvfdRwzMZTno0NNEa?=
 =?us-ascii?Q?XjsNipruuLfbBLF48TLzSt6Pj3f+FaDPyXpNqD/q7TIgK/XzofC6+e4K3hfF?=
 =?us-ascii?Q?4Fj07+M1mFigdy8LCFhC1Rg1dJJ6iUhI9fAR7X9n8uRr/tt/Ei2zoBqh8NLe?=
 =?us-ascii?Q?GR/0pqgHUCijy+i1A3bjwWqnsHSZ5XIR7FqPUq+uaYMnjT+ujh4IldL9AvCH?=
 =?us-ascii?Q?tpDrreuGJgwy09BA+RZFBI/oqsyfGFdSD+5cmZs3fUVAQLPmoSciOq7gvHKg?=
 =?us-ascii?Q?m0/K3otIPSn1cJFB5qtbG9UGCOKWZ1vC0S1iPmgFp0sni6hNDpA0j1fs42GF?=
 =?us-ascii?Q?2EnZ6JRbqIYNXjw8AJPvojP0Ni6N3VyJlaRk2nSK?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 550d3cce-8dc0-4da2-5734-08dc286d2b33
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2024 06:14:12.0549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g83w9xXdVxEJnQfxuzefM3R4MSucKf2qr657Feu3tEHY+9b2cL6q4iULEMJuLxIYjtOCejilfkzvmJao2qd8lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6733
X-OriginatorOrg: intel.com

> From: ankita@nvidia.com <ankita@nvidia.com>
> Sent: Tuesday, February 6, 2024 7:01 AM
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> do_io_rw() is used to read/write to the device MMIO. The grace hopper
> VFIO PCI variant driver require this functionality to read/write to
> its memory.
>=20
> Rename this as vfio_pci_core functions and export as GPL.
>=20
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

