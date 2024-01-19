Return-Path: <kvm+bounces-6466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0668325A7
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 09:22:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEDC41C2260D
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 08:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB4022318;
	Fri, 19 Jan 2024 08:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S5LXh6Ee"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8001B1DA44;
	Fri, 19 Jan 2024 08:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705652541; cv=fail; b=pd4r8IYPlhD2gBh4a3+WcUC8OojzWqQX/Q/CEBJsxbroGhsqUHARLw6JXC9AfPBkb1sOgKfGn8ROY4pJUAaoCQoQDqtqO34SRMy3szVNbWojTKZM0BEafzTRI1x/hvoWcnBLjftI/0XRQM/5j0p+qdizupuOq4eD94Sax0eYv2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705652541; c=relaxed/simple;
	bh=4lakEl5GO+NnJGyWy8FV42csaMduo+ufaQZK81ygr8E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XI/YqdzTwT4LrNhzLgeDFoVBOnCyVcYENhnL42zaJNp5zkVEyy0IJXTLfPT2H4lsNwsV+j2ZrrLf+zc5USBoax0hwsuRgsl01IvK0QdNa64fghu6LGDFh71LnqHJrLVkKQCkSHrCgoGZWPKvdOjDawdmknP/YF/SwOo/rQKjrkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S5LXh6Ee; arc=fail smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705652539; x=1737188539;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4lakEl5GO+NnJGyWy8FV42csaMduo+ufaQZK81ygr8E=;
  b=S5LXh6EecwHlImfrdZk/YG9g57Pqbyrxx8DicpDqAlRLC3OpoJxj3rpk
   8t9AM9oTYum/+R43s0f93SA2Co8/qsyfIq7XXVPpCrqjVK6QiiQOIw4ho
   Er11d/C3aqyOKJn+IjWRM+yjwQ3mlmJquYUE8eVw9+CF8k+fB9H0OILQH
   goazRXRqsKRT25zaEmZjnFVzJZi06X9bOCG6bnmYZDn6WPiAe1WLIa9dX
   Cc/FDw/ky0sHqpVFR+ERuWycl8f5Izy59AjgnEHEZ/pa9UIRNsEUgBWa8
   WMJCPdVYugyiTpnPKECp836Ln9h+dEYfhSTfz6gK1R95MFMwCE8vL4Usw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="397860708"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="397860708"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2024 00:22:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="1116192208"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="1116192208"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jan 2024 00:22:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Jan 2024 00:22:17 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Jan 2024 00:22:17 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Jan 2024 00:22:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvnsauoDOyxqyUxr6r94UTd2DfZJwZPy+Ayld4/DwJUz29Gc1Akiu7YMNLnbqy6PT3Pxy50kXMeNXKIHjagmspQ8o68aX0TGhKgi2d9TlKgPspYKJvOvXGrEjw0WJRfd66JZPn+7N764B0RQp+mgLLtK5gQfQtjWdlQLUj2FuAgJFKyDeWL3ZDzM31e0k6bH+tPlj0re4HVatKldFyD5fU6SE+BsOihDXbVzyA1z53t4q/1bvXWOqC1PZnuHfO3I/ccyt11zLIT8vh0WlMFztbOL808K/j30+iYRyQnk+iuOukDZpV1aaKoC2bVpWdZGr2GxTiAm+uQ0oGGYnvsBvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lakEl5GO+NnJGyWy8FV42csaMduo+ufaQZK81ygr8E=;
 b=Hl1LzBrg5C5lMho0i3CRAHhuyxBcZMi6R4PqlN36wGxDLuDOhC3DJAW7ANvPl7BUURZy+HiTJ5fKuAtf51a8ySMkDYwws1XXt9P2o7oAw2I//XOp4e3hl4OGC6T5HyQ2lmFx4ePRm4v1IID/IwpfFYCiOoxO0F74blzTG1eb59pHdi0M3cTtRiPt5frUSntsaKAy5amrjadNVnK+4bbgQXuUKGKZx9a/jDa+NxnSXZq5ecn3do94n5CIWYuEReBe4Ahow7A6O9mbv5Uvu6GmWR/fbKQkDXVtraqDBEBPJAcwkWiFGMAR4i/11z1RBF9pM1bycGYQFzbCflU8f3XoeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5032.namprd11.prod.outlook.com (2603:10b6:510:3a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Fri, 19 Jan
 2024 08:22:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 08:22:14 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Ankit Agrawal <ankita@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>, Aniket Agashe <aniketa@nvidia.com>,
	Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun
 Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
	"Currid, Andy" <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj
 Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v16 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v16 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaR/gI7yTY7IhFHUuQNfBGQwI94bDetk6AgAHKP4CAABFEgIAAPzEw
Date: Fri, 19 Jan 2024 08:22:14 +0000
Message-ID: <BN9PR11MB5276124930AE10F1AC563FF38C702@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240115211516.635852-1-ankita@nvidia.com>
	<20240115211516.635852-4-ankita@nvidia.com>
 <20240117171311.40583fa7.alex.williamson@redhat.com>
 <SA1PR12MB719904680D5961E6F1806F12B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
 <SA1PR12MB71994FAB7CCB7A39AB4190D4B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To: <SA1PR12MB71994FAB7CCB7A39AB4190D4B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5032:EE_
x-ms-office365-filtering-correlation-id: 820765cc-6eaf-48bd-3486-08dc18c7bdcc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q1qq6JGAnRRrJuFGMgfhg474yUp4PIN1Nsq4T4DoQBLkmeQ+dOPIiNT6GXlg6XzEnbFMTBQVYIJOCMibval5vdNfY2PiMEyGOgYpK1po7dHJDyrfoEoT4EJHDzci0EigwTUyoYH8EZKIbwnfecfUvQRAgfqxJ18DOzcbltfueyByGT7eGVAe0IqcoPeDN0FUyNISPAg5eXfIiIB8OcvscfA6/SPIVvu6M6skVwu1RLQGKkfjJiC4OQEypbYuhd6LaJOO0XEDaQRArpyFWbBzrVGLAnxeXrwNmmeAH8HeK0cDhRvZ/xSvGongdzK4M3SMBYUXQCzoxw9YLM7eZvEj6xm87765LhfdYVHRQaVFG1WMGWoIx15pSCs46NdZGX9aPxsOf5u8iUbsj8KQPQqtirxj5Pa+eLBRUJJiYO8QuRdIl2K7CwtkkwcNScoR1WRXlBf73xuT2esk8nm5wObhlje3zPm3TlKTxEEg89DEBJsH0DxzhyDgAAS8wUA2XQ4AhMwRgWdmXoJfDhwZFy4ZySqm3hdLE+DPaQ918pZ2bHLEu7QZhJWzycbc5y/iJw6t1qX4HO7WT5WkMCGd/H83mTKahQ0nRH8Utt69QA4usdMxhNoTV+y8N7u06zdckG4S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(376002)(396003)(366004)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(55016003)(9686003)(6506007)(26005)(7696005)(71200400001)(86362001)(38070700009)(38100700002)(33656002)(82960400001)(2906002)(41300700001)(8676002)(52536014)(122000001)(66476007)(5660300002)(7416002)(4326008)(66556008)(4744005)(76116006)(316002)(8936002)(64756008)(478600001)(110136005)(66946007)(54906003)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DAfbciVettAkiJTftV1s3ifLGMLCVLj5j+t9/cRi7qglyUUzT5Rl6U56rjym?=
 =?us-ascii?Q?7If5KAoAl5jyDElXVk9wbENPegigZEbIegFVTugqmbHTzyyQvzhrE1oAj944?=
 =?us-ascii?Q?OVe0OFRPWRIlbq4gF15wicz3IITFwR/6bgQm+KYWRAd0piimeMDiu0qsvtYZ?=
 =?us-ascii?Q?2z1URTek5lNPCSGpMGCG68HTnh0i2qmlphWBsKvOhddvtN+3DmGelf6KaXJr?=
 =?us-ascii?Q?PNsaBL3nE1z9g2Y5biLx7kZfB363BqRGiMekQhm5HJYEpHJvjdEo7SWhFGpX?=
 =?us-ascii?Q?LFkTWbSvSMSqcl6IFrfKIRjtpow+ore20UXDDgbSZBupynz0Sv2ev6yt3qDK?=
 =?us-ascii?Q?B7kgfS0fs2Ceep1mwbGccBSw+i3r2FQdclEs4+/yrZjxMZdKqJb68G+3mXH2?=
 =?us-ascii?Q?ltoSAlMXvxLNaE9gCWQsR4/XlVLmVneoRqUAIcacmreBmxbpmphq/cviUdAb?=
 =?us-ascii?Q?49RMOcThyGP/b+1rYhz9Qd6PL8cUmUzf20+4sVZ5ooyDnVpeVc1H3k2i3qyg?=
 =?us-ascii?Q?Sk0XuKDyrvhuBP2vEtvtWOLPFwaKhTQ/caCxa37xyEy/qw/2oAJpSFtMdFM0?=
 =?us-ascii?Q?vQIPi870508h9XRxeuiLiDSSGkcxtk5ZUUCAxoewVCdnPyvnhzOLBbfh9dqD?=
 =?us-ascii?Q?0nNgvcpD2DOMttctvKDxdGltJCiWigPeVj7AFcyuU8zAUqNr+XAXEKc2Mcu2?=
 =?us-ascii?Q?ALmcBemucsU+LRvWzZx1DoRrAKY5/dupmp38mmUVy67jbT0sHxacbSel6uhD?=
 =?us-ascii?Q?4PshRTEh7UK3iTFKptr+92uASrWBrL7QrA2bl9glG2ATX2DX4sgDdLeklRwY?=
 =?us-ascii?Q?B50JW9Msec3ZgSRm6tTcCcl9Ek0eIp/Z7JAnNCfJNFHtNrr4mxhOQ+zER14/?=
 =?us-ascii?Q?fhuHiwtsFGbsJZxdzXzd2mwti1s6Ah4qnHsjTP64DZ+TDu3UwCctPkdY3yn7?=
 =?us-ascii?Q?nHEDA5Auq5wYx7TJa2BDGfxHZiZgNhI8J+X5cgdacWcJRYycZv+Ub19rStTw?=
 =?us-ascii?Q?T3aSCe5bv4aZqrINBBmjdLOXVPb000shxVB1l+WS5oA6A58jIHDjLfVxLca9?=
 =?us-ascii?Q?tgclRa5xiOR/lKTMftAJKYEIriEfGb5nwUxl3dsSdJtynTYYLjFBI1qIgMkt?=
 =?us-ascii?Q?+hJxOxcrH+M3nJ/Q97yzGbXObk26aHOIi7Ba5OHBplI14AoPFynTpHHNfl6p?=
 =?us-ascii?Q?okrzisc2NphR5lpIr0ig4A/1SpXOIRDcXhKzWWruXDG/MdBKBLmvahP9oDuW?=
 =?us-ascii?Q?iFbR0Gjbw6e7RgxpBGMqXMaX1vAyBET3mOD0h4t8Isr3Nqvy5TwSeCwlWvQW?=
 =?us-ascii?Q?EAegi4bzY6pjGA6I9lqhh/rRdNQYhI+Hr49SK7sGEdWE8G6a8GOC4azJb/mP?=
 =?us-ascii?Q?bSpqc3nCGFZ8A6L3GHrkpXPObfnb0CGC0u6xxA36Cr3u4r8B0Nt6MvVKFQFQ?=
 =?us-ascii?Q?djd7fiWVs+znYKBLSJbuCV/jqVsClTJyZI5nt8nYx5QW6F6t09IP4H0rgQVO?=
 =?us-ascii?Q?lc5WiTrjT06H83vvb8hoeD9rHeVVqjG9euYHMuiYJLwLQ+7JXuTcfCuAVqnw?=
 =?us-ascii?Q?XEWQqN2ompyrqQKWaxGBwJ1He+si1vX3VBi2O3F6?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 820765cc-6eaf-48bd-3486-08dc18c7bdcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2024 08:22:14.1307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZybgBhudI2ndre9sTjRcvbqkBwZwAOwTYiBdgB13rw0Wibvg9/9V4YStZLG4pDuJ4AEGpABU6OQeVJvGW30LOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5032
X-OriginatorOrg: intel.com

> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: Friday, January 19, 2024 12:35 PM
>=20
> >>> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> >>> Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
> >>> Tested-by: Ankit Agrawal <ankita@nvidia.com>
> >>
> >> Dunno about others, but I sure hope and assume the author tests ;)
> >> Sometimes I'm proven wrong.
> >
> > Yeah, does not hurt to keep it then I suppose. :)
>=20
> Sorry I misread the comment. I'll remove the Tested-by as it is
> redundant with Signed-off-by.

and your s-o-b should be the last one.

