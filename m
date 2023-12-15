Return-Path: <kvm+bounces-4541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 838E1813EBE
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 01:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 049351F22C1C
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 00:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25F742574;
	Fri, 15 Dec 2023 00:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kTH8TXIJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38B023A8
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 00:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702600582; x=1734136582;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m69RW9tleeRYt41ZEUhaXaH27VqfmXwrJvK1uS5fBsk=;
  b=kTH8TXIJdym4iUt+Mo8845bKrCQd08fA2i9u0fDKRohE0lUBvwVAXY8Z
   JHA+hoeJfcY3vdIDtOoF1yQt8lU4oiFRZNiHakjLcX7JVXpUHERmAfWgF
   GHx6pCGwtIPsO4A3Y2l88lyE4xZtSzXqJy1JhrNeWMQM16uTMr5yAUYY4
   6x4klVMQ2EesO/ELOnSeM3MHLqwuXSxbRQ2v+UCDlGlOEH1iokRfL9wEq
   0GXh1tX4rX6iRJpULELZ6hoDVH6qC5mbNLN+/87i+UhwWKao0R0Kut4sz
   mrMT/ZKuCHexiVekrF2BCijlFVds8rbOsGfyoEGP7CIcz6+j6eRTgoD6H
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="2030537"
X-IronPort-AV: E=Sophos;i="6.04,277,1695711600"; 
   d="scan'208";a="2030537"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 16:36:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="808779306"
X-IronPort-AV: E=Sophos;i="6.04,277,1695711600"; 
   d="scan'208";a="808779306"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Dec 2023 16:35:48 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 16:35:48 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Dec 2023 16:35:48 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Dec 2023 16:35:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAA2/uDTZK/odbf+kuu0q9geDEfePJEaCnz2Ba4qNJCa8saPu9wz2eK5FKPrlv5A7RWByO5Ke9Nqbb3cKrZEMkvOf43ShTzfGT5dh3HSL2b6RWLEZwiryDvTKDtQTotCCpO42vxX7jIIQLaqT52KTHZB2PyD0BhTdV3qN/vA6RgkrmSRKPW+W/adVVBpBJpaIQQLwKBURaZu82lmxk8mryzl0gRNvgd2bnUnZBLfI14vSU49c2WfqBTIzhHoQBnugSoV7pSu3n4SLSvJWTRsI0Z2RfuMqXZldOhv8ogHfGdzDfxhWMM/MLEeXrXShVz9cKzD/omP7ZqNKKMfbHkyeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m69RW9tleeRYt41ZEUhaXaH27VqfmXwrJvK1uS5fBsk=;
 b=avmrByL5BzS2zP95aOFmDlhxEnPezykq9G2aHTaqpXnjH3H9ocpq3YGb8dMQas52ga+pGDWhVmsX/+3CPDhFCS0WIV3sdBZO9NUM7hgUBU7bIKgme0zemqLfGMxUfoPvA0fG092BejrLrW3XBEJnpdpiUQ0xpCeJTlzMLwhH1LARIh1uknsYPVOarqtMuP9qCZIX/qNRZj+uemNZOzCCtgrIZQNbEvDzNa4Rm2o/BmHdNvg5Su2DN42tbZkv/7cOx4m3+qZuGfIX3L9oMnY7aMQl/27STb9/Y0b4zqHYzggwzrNWmR7IcMu465pN7BhnyvQir2QY6VZj2ZJvAWYCpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5243.namprd11.prod.outlook.com (2603:10b6:408:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.31; Fri, 15 Dec
 2023 00:35:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7091.029; Fri, 15 Dec 2023
 00:35:44 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
	<parav@nvidia.com>, "feliu@nvidia.com" <feliu@nvidia.com>, "jiri@nvidia.com"
	<jiri@nvidia.com>, "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "leonro@nvidia.com"
	<leonro@nvidia.com>, "maorg@nvidia.com" <maorg@nvidia.com>
Subject: RE: [PATCH V8 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH V8 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHaLoqas2GbVXtrDkCrjuOJsdjKCrCpf97g
Date: Fri, 15 Dec 2023 00:35:44 +0000
Message-ID: <BN9PR11MB52765F808AB35422D10846EF8C93A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231214123808.76664-1-yishaih@nvidia.com>
 <20231214123808.76664-10-yishaih@nvidia.com>
In-Reply-To: <20231214123808.76664-10-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5243:EE_
x-ms-office365-filtering-correlation-id: 171a0f3b-eb7a-4a21-847e-08dbfd05c65e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXoxZ+onh5h8STyrJLJAt9OYOIZmLJKI7tq+yHoBHTtw/rJA7UYAHxOJE1Elarfo0f0U2wiBT1YehFG+pNCCes4jUr9GVyHuplFrqMGZ97ezsxl4Gq07lEoNbnSASt2yZdtcq4+slUtFzEHzKzHFl27fN9wiGHFO/jwP0UjIXJ5CGIBCaIA9B2vrNzLBOAaEos37+PYmr7VZGbZbOkK5kXhgydGgSpE4n2ZmMa27+nW+jbuMwGZWKUvCgVWsuRBoAGP9Ba6aV6Etalb23paV8yxO7DDyae7bF7Up7LKob0Xjpy+m7AgEk0fvuTpoggNqE6F7nqYXScPBXAPP1McXwfAO0pE0jtra1FhzTMhCv5GbobVKnWDe1d2qqsNjglST2Ms+6/v71yvHwUiYPZa5IN6/JrI4Lgd1vgPibE28SmJ9+Bnzu5gqBfY6dM838Fv+GZ7bpvzn2Dhpzxafv6s+i2On9deTX+fc/b+o51BtuH4r3hRtgqUO9WlngNO18EdHAGF4XbrkT7b+zwcHLOza0xlad+BjhUJllBnsN+9UTCzcETWR2XVp6bnSYSfj4xiZAdXY7kW++5OshtkU1Im2hw/c7ZZNY7FoiWo7E8pTmzU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(376002)(366004)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(4326008)(8936002)(52536014)(8676002)(2906002)(7416002)(5660300002)(478600001)(6506007)(7696005)(9686003)(110136005)(54906003)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(966005)(41300700001)(38100700002)(122000001)(55016003)(33656002)(86362001)(38070700009)(82960400001)(71200400001)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I8IgqCfFITJSgv9rMmQRyxebxCRTsW3tTA+5ZFMbf/bdIh2WjjG3UmBzhXNr?=
 =?us-ascii?Q?caQB+Nl/lvSZV6/1F8TxhuOYHHjRXC0CSO4kBjCflRh5VdVF5W4NNwqlX6m0?=
 =?us-ascii?Q?Gm/7Ecarx9y6CjKuGFm/U2PdW4egnn+OCH8eu1XbsO30xNbp0r2T1HT6fNS4?=
 =?us-ascii?Q?RxrHSq55/vsJGjd/DUwgfSy102W+DsQU8j83ng2NXcp6OQ7Ix1qStgaFvQyk?=
 =?us-ascii?Q?sjGUQYfJPBy5w+R+MMVBxWfHL8u6ecJVQoxSj8Z/NTAvSu+fVwiYGutFtSki?=
 =?us-ascii?Q?T523ksqPsiGa/wFgQhGDoErguC3r3agFRdvm71+LJrVkba4iTK3XSrqelP5m?=
 =?us-ascii?Q?YdYnqA06drgcAIvMqcCP+NloKUyQkK9a64F3cPR6foOpxodEHBoMi8nII4Sy?=
 =?us-ascii?Q?c5D7vlZpMZgrEM6qo3ZLOgpTkjDIGQUJAZa0aSlBbY/mq0RqXLFVXsa6Ge17?=
 =?us-ascii?Q?dofqXgQar+Y1Cg3fjm+wKCgH0ac5XGMKtrwxXwz6Wgj9hRQmvK/P02vxV/ap?=
 =?us-ascii?Q?J75tEU8X69gAIoFGL9v8QkxmIAVkFARqUUfnmLw4961D8CAqprDB1Q3vAhC5?=
 =?us-ascii?Q?EU9dqlVc7jOOS3QljdfSiiUTD7dFoIfdnTddamUXOCZcMDAvjanxIy1Oek8N?=
 =?us-ascii?Q?lR6/B41W2wtnXy+8weljrQmFNxH80Ia7xtS7GHzIC7izgFySa28SvQFhA7v1?=
 =?us-ascii?Q?BKM5Y/heIfW7BCDtzTr27JMirgjCZBtSqo55xeOpM8Rc6NzN2qMEztWojmbZ?=
 =?us-ascii?Q?22aTQxioWz9ocrEgns6jHB0HiEV4SMPcPL5YdQNhJvoq7KDjgKJEI75W9UD0?=
 =?us-ascii?Q?SQUQdYBH/KCy2Bxgb8LsUepIsjawhhpHM2znSBLPHbPvNJuxlG3FDmg89wWg?=
 =?us-ascii?Q?fM5zygN5+2Rg9TFY/C/r1bWdH3o23a3E5l7avv1dY7AyLBAKsRzl82/x5jNk?=
 =?us-ascii?Q?vDXYxOek1SWzqugPsdE0GTqUABBH9Xxp+EtNR03GR/kl+vfvpowL2ztEOSQ5?=
 =?us-ascii?Q?MoifBeZUC9Za3FKEAIj8Yma2ys8SEqkI1IxSWACjiP2TEd/Y0YmWlxcEc9Dm?=
 =?us-ascii?Q?Te8OWC6bctl+NvmuVkVhUdNBSKfHzKf4NdUBfCYXR9GBIi8YUmAwzYENvbih?=
 =?us-ascii?Q?iwtKV7zdAoZ8zAiS2zMqbguYS7OLOGIozfR73GVKwp8b43L4UJFj3+6AoZRx?=
 =?us-ascii?Q?L/1+0V4KpYDNBIa2Lb7jWNVSOGyVr99pjZhLC0HjQ7ygsXGtViEEpybM5XL+?=
 =?us-ascii?Q?6s5d89tINFTK+2M+Hca8FcV6V9LKoEea9obft1ED5KkKGU6fS9t/SDrSNhup?=
 =?us-ascii?Q?YaSpNuDBqhCqMnH+wB/D5DmpmNfQB+0mt4NzNhiXYSaLpV930RsXUBSic+6G?=
 =?us-ascii?Q?gX/Wsm7gyidQz0BbZg89kfZ+Fs858K+Pcf8o3Osx4fqfpRGQE9Wq3PN6zdt8?=
 =?us-ascii?Q?wi1B003j3+EkqdxyCpMCM6Dbzt0GqoDSViN88ReBUkwXmwXGTvZCTZSJQXLi?=
 =?us-ascii?Q?BVRC3qmKqiBvsSsIu0zOCHyoIIwR7ZfImb1ScJoOZXMsCa+9l16PKNH9CDFl?=
 =?us-ascii?Q?OzQKEncOmYvrSzfRLeIMdkprMNUT/975drZ5Y4ZJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 171a0f3b-eb7a-4a21-847e-08dbfd05c65e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2023 00:35:44.7421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iKdrE09//z1GoesQw2s0kqLxbYhbqyq3PbLJpxhawNMGBXERZZYnVi5uQhu5v7ETbG1i6UqykLAM1wSPKxj7rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5243
X-OriginatorOrg: intel.com

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Thursday, December 14, 2023 8:38 PM
>=20
> Introduce a vfio driver over virtio devices to support the legacy
> interface functionality for VFs.
>=20
> Background, from the virtio spec [1].
> --------------------------------------------------------------------
> In some systems, there is a need to support a virtio legacy driver with
> a device that does not directly support the legacy interface. In such
> scenarios, a group owner device can provide the legacy interface
> functionality for the group member devices. The driver of the owner
> device can then access the legacy interface of a member device on behalf
> of the legacy member device driver.
>=20
> For example, with the SR-IOV group type, group members (VFs) can not
> present the legacy interface in an I/O BAR in BAR0 as expected by the
> legacy pci driver. If the legacy driver is running inside a virtual
> machine, the hypervisor executing the virtual machine can present a
> virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
> legacy driver accesses to this I/O BAR and forwards them to the group
> owner device (PF) using group administration commands.
> --------------------------------------------------------------------
>=20
> Specifically, this driver adds support for a virtio-net VF to be exposed
> as a transitional device to a guest driver and allows the legacy IO BAR
> functionality on top.
>=20
> This allows a VM which uses a legacy virtio-net driver in the guest to
> work transparently over a VF which its driver in the host is that new
> driver.
>=20
> The driver can be extended easily to support some other types of virtio
> devices (e.g virtio-blk), by adding in a few places the specific type
> properties as was done for virtio-net.
>=20
> For now, only the virtio-net use case was tested and as such we introduce
> the support only for such a device.
>=20
> Practically,
> Upon probing a VF for a virtio-net device, in case its PF supports
> legacy access over the virtio admin commands and the VF doesn't have BAR
> 0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
> transitional device with I/O BAR in BAR 0.
>=20
> The existence of the simulated I/O bar is reported later on by
> overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
> exposes itself as a transitional device by overwriting some properties
> upon reading its config space.
>=20
> Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
> guest may use it via read/write calls according to the virtio
> specification.
>=20
> Any read/write towards the control parts of the BAR will be captured by
> the new driver and will be translated into admin commands towards the
> device.
>=20
> In addition, any data path read/write access (i.e. virtio driver
> notifications) will be captured by the driver and forwarded to the
> physical BAR which its properties were supplied by the admin command
> VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the probing/init flow.
>=20
> With that code in place a legacy driver in the guest has the look and
> feel as if having a transitional device with legacy support for both its
> control and data path flows.
>=20
> [1]
> https://github.com/oasis-tcs/virtio-
> spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

aside from the non-x86 discussion:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

