Return-Path: <kvm+bounces-7975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A9BB849575
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 09:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFCC31C20F2A
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 08:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED90011CB3;
	Mon,  5 Feb 2024 08:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B8HII2BR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6051D1170E;
	Mon,  5 Feb 2024 08:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707122246; cv=fail; b=rOZKH2T+6RPrpZxImLYUAiDdCGOl0UXc6xb/Zgmlq9Cfd3Cg+olkqANDqfojExKOag+9QzWvuXWDUiEfBO/vp5O9FXC/Czb32bfnRU9MRk9A69rgbfVT2NlNvrvLxfjSOu52iSM3AxFronyMikyb3pEWo3lg+2fG/M8g7c85Ow8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707122246; c=relaxed/simple;
	bh=WaWR3tEjDfZprvYFZ3uMy4dwblsK75V5mHU5oIPV1hE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O1mnuw0VM2R4xgNXidrRgMlqXm52gDs95oPeCpKmFBAlSSB8aDt2Fn1RNM8YAKKjubeep7KXLXo/t2DgjbbHdXqQUjkmPrlM/I3OzAWbYVN93Z3mb+vd/Prg4SWoPKyCkZjTinBkiT26JRD88ep05PVVWjEyhmLAUqi34DPDlUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B8HII2BR; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707122244; x=1738658244;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WaWR3tEjDfZprvYFZ3uMy4dwblsK75V5mHU5oIPV1hE=;
  b=B8HII2BRlk2vAngT4AOPuM/4LeBrKyUqfRVYylCJcFpOBJTE8wKrhx4l
   N3wiBTYcnc384dYwO/S4Evn2c5O1unI3YN3yHO4pC6zFN1krAzlQq1LAJ
   JLkXbC12muALVl3LN+ccmrgvV7A8fKOHD2qbb3Ir+geuze1pL3N2DV+r6
   wZ7lH7EuwUm/Oa/pzmADBanuA8qm4nV6pHBkfcQKkDOX7nm28A6T43Klw
   cy5+cprOYXRsXNo3Jf5l2AWIo5SSJ9FowQH5sCM2vhQhtb7nuL/HX99BV
   wSy9XlSXOlb0/AxvckN3tYlrK9wE46Um3JG73t9ymmHp2BG5R7X8OPR8H
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="4271315"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="4271315"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 00:37:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="909239216"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="909239216"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Feb 2024 00:37:23 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 00:37:22 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 5 Feb 2024 00:37:22 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 5 Feb 2024 00:37:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VG4RMnAaf3MKpmem9pKhUowbYIllib9HIkqYrGLR6oHLtNLSntweNtlgyYTv5XvbRFImrVgNyg/AUlF99zzmq04Cg65QLwTvr2zfWV2CvKk9Od1e8TrUwT6kiIluD1J1hS+q17QO5V79aVsSIlrVhjTXXUlMl5qxemZfPAn+iFDJooQVf9Pof+cAIiWYUdxi540ksZtITNJ6nYjjmWqOU3/oq/nXN4dNb2smIH0I4BWQhVni//Rpx+KnaPwEv+i35sIYFF1Cp21AKITe99VRl6xqft2W3lZmpWpYrIxOg9tXksXupBf8eBLoZjSpzASD3V5Gd2tXaYdFyGOEWjaZHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FCra4k9TMhjLlwlIYn5MC7+p9Ot9rIUBkx1OB4HW9w=;
 b=IBHGPmYkT0Nf6jTKia5hifUOhwqdwApTUKh+9232kZPe+4TmBLlY8PRBCV7jr+KYa+xiaUqHrbJlUw6fMHlskY9wX7e6WS3dFfSQo86EKZQPiQyocCvr2/vUjO+fm2qES2AhslFyZImEN1zNNY+n5jlOAMnrWb3vJcBD/TLSvpUpToI8QB8snW8NSEFDP2EFkUWSd2ioVtj5twVKbJr+xrRxRno2ui4TyJ5AQ9QwHC2ggfdTnpZ17jcxqvoKZOG/qhjJxAcldf3fFtXd03+BUIxXkLvLTh91dqJKasufaH8vXaJ2reIxgpo5ldmUi6ZXn6SkuYnwqhyBD80o8y0lkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6972.namprd11.prod.outlook.com (2603:10b6:806:2ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 08:37:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 08:37:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan
	<jacob.jun.pan@linux.intel.com>, Longfang Liu <liulongfang@huawei.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, Joel Granados <j.granados@samsung.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH v11 12/16] iommu: Use refcount for fault data access
Thread-Topic: [PATCH v11 12/16] iommu: Use refcount for fault data access
Thread-Index: AQHaU1RvIhRhmS2ge0S+4IhuLRd3J7D7djLw
Date: Mon, 5 Feb 2024 08:37:20 +0000
Message-ID: <BN9PR11MB52764927C3C56127F4B9B9DE8C472@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
 <20240130080835.58921-13-baolu.lu@linux.intel.com>
In-Reply-To: <20240130080835.58921-13-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6972:EE_
x-ms-office365-filtering-correlation-id: a35d5739-c1af-42f2-547f-08dc2625ab15
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fdK2KDVpHMrqyCMhTMcdhH7ANyVIZtum639D0GO8ytTQfZ+o41WjksI2Mm1v8e9huf84HDq44KspMHx7Nn5aQnqt/9A+lwI1N1Pz4fJeCIdmpr10K3gCuapn3hHu4UXDJr5mSvzSCNOdO1p7bdfzpWRABszB8BRJUqOdFeAMXj9YoAsMTfB9ANaLVooQAVNFqcFO6K5hHkHlB8FZb00H+o3j5kgO7+xOHvhByDoZTEPSrmg7EkCYQF2mDlawYBZNwMpWvEAr//fgs5AeR1vnmEiuaIBRGt+H30WNO2X2NVUA886CQpkQHZIp7JnzuBuGi76ZoWOC6ZXMTX+f85jBjrRhc0BNa5Dhb2d6bl/4UiDFkEuvrJK6NSHz5Sa+ydUkDlZWGLGo3d09V12PCHCVExRYK4ddB0ZEZXM5d3V0lK2L68EmY6foQeOHevDGyWkvzZA3nRis+1gWrbMPdnpUIaKMaf7GnYfAJoeagE8rjWpYScKxftSw3HGy84iD2pULXRZDNC1YaYs7d98pe8vtJR1aXQ87m0dH+t1LYDSdmAtN5NdN/UbUPs7Z/RM31mOlYi298PLjDnyawspSze4qaZk5/XK79meIJiRrzsTsVU+wFqefT0tZ18hql7komhFz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(396003)(366004)(39860400002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(41300700001)(26005)(9686003)(7696005)(6506007)(66476007)(66946007)(8936002)(4326008)(8676002)(64756008)(66556008)(52536014)(7416002)(33656002)(76116006)(55016003)(5660300002)(478600001)(2906002)(83380400001)(110136005)(316002)(54906003)(82960400001)(38100700002)(122000001)(66446008)(86362001)(71200400001)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3/izcTp6AOeqnwp1SvyI5hDyHbRJ1kKTNIfMWpqqTGRxjeGLGTj/2fGajY06?=
 =?us-ascii?Q?fpDoEdjqgLkF3iJM8LXnj/CBq5xOp74ytJ/Btc64Nw7k3/ao3P/Jb04Il0YA?=
 =?us-ascii?Q?OChL0OUe2pM21dGRNmmvP5U9fECpFfGMIpimWIfmIvT4GH0UDPJJfUzKu9dH?=
 =?us-ascii?Q?SAXmhGLrpH3vtNUoLiu3x66Q7xWJZirsyMkTatc1/mMquOGERof+0BjSifrA?=
 =?us-ascii?Q?p9KxE1YH0ttg50MBZVZjHWJ2/XwOnYwdiI0Rb+MIXiXVMP2V6yePHiroi1xM?=
 =?us-ascii?Q?9HATE7S51aMSlPGpcDqCQa1cLC83wlQji8RD4SkxGcJDCp+Tk1zxgN1wnMMo?=
 =?us-ascii?Q?exbOl5Ag/fPnsKk4nAP94T22p36RQSrfU9/LAKwolKo2eMQmzKZazGn3M7LM?=
 =?us-ascii?Q?nTG6eHwPmagCmmVf8zJwlnYiPwsxzY7AnbUYPk7Jx3zgJgZxPoesL8ZFEDmh?=
 =?us-ascii?Q?X7j2Nag8SURc2nD36FIHjkIDbss1yZWVMCAilYvuYrB7Fww6yn7xpeSxGxFv?=
 =?us-ascii?Q?hvDAk9eEKr11vx4F9OFwRYJFpWD4nyG+1z66SkXGcixAtIpqHhrl92stFZ7/?=
 =?us-ascii?Q?vI9kgj1hH79GddqwmgKClFrkcN4J2FST9s0VHIMJtYS98szC5HqDvS4HYbo/?=
 =?us-ascii?Q?S7cpSF/7uF8upFTF65ONHUfJwTKSc7ou0Cg+KCEqczrz94a331JT7BjsJVWL?=
 =?us-ascii?Q?mygkkBNMm3v/ij/LGR0PC5f4eC1rWTmJxEyJyB6/APmBL9YsLp1AugVZWWiY?=
 =?us-ascii?Q?ngvDkVCTJ0MqubhafZS65rqAwlezjfmwiHA6FnZHm1jJN8VX4SQw5PiyU4wV?=
 =?us-ascii?Q?6C1/kxQqgX1tlvYckIfvvIhUjQk+km5fUxN851zAaZLdVDDsy0L8kOlxeQqM?=
 =?us-ascii?Q?Y40PlYAWuEvMSN6gWdGWkF9xZQXr4O8hNPUz0CDqP2wgCdpMdGxrAc/DD615?=
 =?us-ascii?Q?2d6FTxtj91RuB02Hthat41Lqk8I005eRENuzw3M1GeAvVL9cHFcvxrQuq9VN?=
 =?us-ascii?Q?x4KVJ7tRwwW97FsmETAbJp1x8kHaGFGHQtaj8VwjqG+Lc/RgZ1BybE64X4zm?=
 =?us-ascii?Q?bvIOuvnGsRxpO2hWmT+mqOqDXPMVhnpnV6eROXAqtfSl7GLK5wG72XXJ2pnu?=
 =?us-ascii?Q?gLAAwLk1hh+CR04XgTlWHRGo/cNAf8OlIhxQdNZFTdaM19VQrue37uafLrHP?=
 =?us-ascii?Q?JfAu17jGhxE0djxwqZH856Za+EpIrfq2eFOxtkVfwJev5vqz6FtAzlmOo5dF?=
 =?us-ascii?Q?7j95TUsUl4Ho8uHxUMEXzvUdZtSKf538MqYRhTbhHusY+cSUc8BspWIRSn2W?=
 =?us-ascii?Q?0XuBZbhsuZhCUCQLhLAYLlldhHszmIqzZqMXR3qpnU6jObfysjA43IjUhwBV?=
 =?us-ascii?Q?bfyHeDzvWAAbJnobMs+D8i10K/ITu/LbqwARICOHi0sZtR2991J3j9QjVsAo?=
 =?us-ascii?Q?b1DfEl+Ii5JT/wKhMRt401g1HIsPfTAIRZG7n6EuWCstdLqjgu7vWJAYKzg3?=
 =?us-ascii?Q?zzp7yTCw83LgHwx3bRc4kemtzdUSHSYxd+k5eIbefKUbp1k6jVN7tEuILn/b?=
 =?us-ascii?Q?uKIRTseFC8hRbg1zZHtvLpDURR6TejfRrxB/skP6?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a35d5739-c1af-42f2-547f-08dc2625ab15
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2024 08:37:20.5518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3pvpT9lT743VSOcTV4a6XSDTgmKK9l8dbYrg/V71lV5r/UM2UjOiO0BL3Y7OAdXmjxIapg42aEoWzGmiFRjYrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6972
X-OriginatorOrg: intel.com

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, January 30, 2024 4:09 PM
>=20
> The per-device fault data structure stores information about faults
> occurring on a device. Its lifetime spans from IOPF enablement to
> disablement. Multiple paths, including IOPF reporting, handling, and
> responding, may access it concurrently.
>=20
> Previously, a mutex protected the fault data from use after free. But
> this is not performance friendly due to the critical nature of IOPF
> handling paths.
>=20
> Refine this with a refcount-based approach. The fault data pointer is
> obtained within an RCU read region with a refcount. The fault data
> pointer is returned for usage only when the pointer is valid and a
> refcount is successfully obtained. The fault data is freed with
> kfree_rcu(), ensuring data is only freed after all RCU critical regions
> complete.
>=20
> An iopf handling work starts once an iopf group is created. The handling
> work continues until iommu_page_response() is called to respond to the
> iopf and the iopf group is freed. During this time, the device fault
> parameter should always be available. Add a pointer to the device fault
> parameter in the iopf_group structure and hold the reference until the
> iopf_group is freed.
>=20
> Make iommu_page_response() static as it is only used in io-pgfault.c.
>=20
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

>   * struct iommu_fault_param - per-device IOMMU fault data
>   * @lock: protect pending faults list
> + * @users: user counter to manage the lifetime of the data
> + * @ruc: rcu head for kfree_rcu()

s/ruc/rcu

