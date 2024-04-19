Return-Path: <kvm+bounces-15204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E6EF8AA7EA
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 07:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8FC5285A53
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1365DBE49;
	Fri, 19 Apr 2024 05:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GUStrkgV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579948F62;
	Fri, 19 Apr 2024 05:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713504218; cv=fail; b=erLxynwARpmN4flaDaRVbWl0SLmULAIhK1J+1bwaVSnzssm8CBsi/4a9g9yZd2iJJT48lrWhQTeAD3TdheyGk3sYk999/1PjHDnfmmQ1Z7/ko4Njk8henKCAtuGA9KqeflFJejSwtezfEy0H6pQ/fxEfQlAgZLnQsszQTA+5GXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713504218; c=relaxed/simple;
	bh=GWKuJsg03pI5asAU/LP4JOjy+ciUwDFAhe+z6p+5mHs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fZqv2gK6ae/t1WO9cjOcKEQF8MfJOMoAq8PEniehJSUspbvveZOO77opnpJnpCxQUR4dzgmqv7YzZWF4bs3eUX4Z2eilbZunDlROEZo2pq4xOoNVI+Now8nUu1u2RRoODvrsiHnyKw8RiYeuGfQlyOPKZOOPyrIIcfyMXkszGns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GUStrkgV; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713504216; x=1745040216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GWKuJsg03pI5asAU/LP4JOjy+ciUwDFAhe+z6p+5mHs=;
  b=GUStrkgVGsAaCsS/J9rR/8P1wkxVxoYFZLTj2+Xeoz2O8VnY6cY8tBjM
   Pxpxwbx0tNpf9q30sEQvEIQUdSRtoMpMfICFQOXteKzn3kdhYR4qUk+p2
   wVoCawvsXukjL7Om9cgIiHp3RW+pMVtSEuoX3Oe99F7BB0CXlbfbOJ7se
   TTudjlcJR79x4/OJhaFAKAzOnGBbUobVVioyFgDDV7crhj1vvB/EdTiF9
   qnRIucNd/p+q3SHS3+EfjNS0wu9slkmNn8jZNa6+OImipl26k8YeecZ2B
   voE2IQbYC1CRBX4pqXIWF8hwXyJZpfGjPWgIlRD4bpMGLzZUwinHMiFwL
   A==;
X-CSE-ConnectionGUID: SbxESFOQQACIFctqkzrFCA==
X-CSE-MsgGUID: 5zwyFGTYQc6vQj3z3+F8vA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="12878611"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="12878611"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 22:23:36 -0700
X-CSE-ConnectionGUID: meBhP0ylQPCOLJjPWOpQog==
X-CSE-MsgGUID: /+HAAYc/QWqrkv1H1fLf2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="60653818"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Apr 2024 22:23:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 22:23:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Apr 2024 22:23:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 22:23:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXsRnXL4ulWYNeto6Nx1644xQbTM6aW3MInj2HUDlXJbc6lnlxJQBQQS/y/dbTFqCiJ8LzYHiAmClg8/v2crsfRivIe9Uk7FNgqsCQrLWcIKghHYslAz0ZGimJPhR5QwWfbeGQm1xwE3/0AJuC6IMW84jZ8LURksbmRCLM0ieSDVCtoR2BiVF2RfxcY79tZyg2+g/10Wz4VEUxt6PDexGf5UJ3FxUVMZdhzVvTIQOMYzjoycTIJPiMptS25pvNiNYNPCGO6ezCnBMVETrkvYy1+fvLBCxWQBkMYee0ojwhFClrflMmsZYb6hKZTVHQUfqb+AhuDyg5i0ku5/jIW1nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+EnWVrzKMgJebuoadKpwBc5d2kGfdl6Y50v4HAe2wE=;
 b=IWxsOjBIG1Anr6vN2PR3rQhPJebRtYNvKffbTzscLEgbeJc3T0RVeKa1zONSB5B8Ua2nDmstt3r3NpAEyhms483rXfvAja8nGTLVeNF0Q5EInlLO6dUCjs5OVvL2kxwl3j0v/Z3fmWwtQATwX9YAU7E3MYXRfFWu5BVUqltYwl5BsthYy9QET3W4/Y6UFOxoQChTCFO1cYNYjDtTz0aWOAbkcrPy2ehbliFp0c3czD8oWcrdnh1yVysWUHTYyocI/9n5ruTl/VS+dVjgbwbgBWPg4KpoHY4yt02Aa4Uq1dziChOwN0Ci35ryyGjI0+RFzcEolR4QY8WNCxsKoiJURQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6886.namprd11.prod.outlook.com (2603:10b6:303:224::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Fri, 19 Apr
 2024 05:23:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7519.010; Fri, 19 Apr 2024
 05:23:30 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "Zeng, Xin"
	<xin.zeng@intel.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>, "Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH v6 1/1] vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV
 VF devices
Thread-Topic: [PATCH v6 1/1] vfio/qat: Add vfio_pci driver for Intel QAT
 SR-IOV VF devices
Thread-Index: AQHakNVVVTUb/4qbx0yNW3Gu0hQhQbFupRgAgAA6STA=
Date: Fri, 19 Apr 2024 05:23:30 +0000
Message-ID: <BN9PR11MB52767D5F7FF5D6498C974B388C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240417143141.1909824-1-xin.zeng@intel.com>
	<20240417143141.1909824-2-xin.zeng@intel.com>
 <20240418165434.1da52cf0.alex.williamson@redhat.com>
In-Reply-To: <20240418165434.1da52cf0.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6886:EE_
x-ms-office365-filtering-correlation-id: e5dc8324-4630-4f11-4608-08dc6030d9cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V+dM+iaIbkqoUPZhXgbjvOcwM6CMYImPeuEam1qSJzNfmLCy/hYMAddfEO0rnKVQFj3tFOftBdgcYI5FsPwTaKKzmlnnddHbrpHaq+A8sif+YvreXzMHrn2SHOiA8jZyfcWPcmKT6huuspdID8Oco7+A9tBL9LZpsfns6amvVrFf+v8C0qyrhFb/MV1nXQrajS2Yg0RbIWzfKVqhjcE9RMmypQHpYPdR5U8GrA4Q67QAkGR/Be0/ou7TpH4orW2HPz95Orr6b53IWiCKhBNZhyzRlHMpyaLXAIc1dVGhTSe6hA2M+o9q/NM3aGI3E+9Hn2XCRI8ytP3+VDYw61eE0WUjr5Y+/HT3e4Q6y7M20nT77HROWTbk1+FODD30z660dTXrx1DxKNaLovOeUMXLcvCp++QXrGkuq2bOGTO1VikkRlydLTiwbkTxsPIyxbU2TLBKP/9sSPYUEEzaqWHJFpi2GZs7nmgFzBGGKRp9zKYhUsL/9A4zqvtj7arFCtr6NXQVTJeIQ+UGGEtWxi60DYTnPGk5KAMCVLbBuQUuWE221HYX2xoRnfCevqHsvAv0ryCiEtiSp3bQtatlxiWmrcTLv7+MrjSMp4USZ6ftIAcpd9zJp3FWnEvf5L8UiKtbbsO+kevqHIWhe7uWXejy9F3aweStoJJ8Hje25MIUdGS/q2QRWWuSOL1at33/Ff3/L6iIAVn6u53EzRN14tCJROmI0hxUPnWec0jHb6FEH6c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6FDsQkb6Kh/C4JkU7dlFJC/6g1Q4Iha9yq0dJ6WJ7+hNuDoEuUwmFgxeS1Zd?=
 =?us-ascii?Q?ewbgomr06HE3cuhymu1xIN+kqVRFM3Nhfe2PbuDZKvOXp05CxBipkEjymNAC?=
 =?us-ascii?Q?dug8Fd5pJHXlIo3SnTdnqWuRvJ5N504nlQpAcoh4geAsLIkh4iWFnzYtq7BG?=
 =?us-ascii?Q?inD93hmLVdFCVXhXsSp/Z6AMV7PAYKcCPVWyhOVJzfTuFZvzcRdRzcRwX8u0?=
 =?us-ascii?Q?NrCBrlR30xDPtnw4WbR8nVeyVlEZ9msSdwBlqZaZIbgDmU8TEy5ACK0ZqQKh?=
 =?us-ascii?Q?X6tlgBahU+MFF9nq0Ey3Jzqam33BtrXSukUwXO+IxC/WEXKl/OztysGRPFtG?=
 =?us-ascii?Q?CDt1TnZovaUq88KnOhxDpSEBTcLHa6hV7BOY7C8NBvdjvgx5dYsP1WDEFGTb?=
 =?us-ascii?Q?C+KNvL/US8Zb6AoJgW5kwnWKMRaaRhBO15ZFj+O+s0zoUcRKKJHsF2Ou7urn?=
 =?us-ascii?Q?vy9+T8Zm0sZ4bgiX/0AaINABEmt7259gHVv3Y2KC6burD2WqwVs0UhbsAInq?=
 =?us-ascii?Q?gp5WALgSs2npbh2CUOUHjBfKSDAiBtsIWMt/UlapMK1KaBtZVvM8zTW1v+CH?=
 =?us-ascii?Q?iwRlpYfn35vxiKCWS/lAR3dhJFsVPkoxF5KIOqkI7trn7q6Ru3WIv515yi2X?=
 =?us-ascii?Q?Pl7wtLl6d2mvCCQKDXsgzZdSoe4Itq5VwVGlt8YNOUmpj1iuVRLmPIEZUy8a?=
 =?us-ascii?Q?g/aonw+JdU51wL0xb9g+953musNaw5bYoIggBryGQi479sCv77yoUCIIviu4?=
 =?us-ascii?Q?/y6MFEAJ1qWyVBYX0eCs+5LZ+3TVZtHm12SNJ+G1hR4dGg1Zm4MUrkFDRzqV?=
 =?us-ascii?Q?HwkQruhKF18IRn9/aDpYnO3DxPqX8XCo9CMkA3AYxf+AW3Ke5t52hdedsOPY?=
 =?us-ascii?Q?iz5+i8qt3DK/ZHt5VDgZD8ChWvQbZxpOHJIZzGzrdWgBznXheb6LzylKW56v?=
 =?us-ascii?Q?z6WDXRFf54zlPzHQ8L2pi/uAUIQr2Xmx+1NGOzfUnO5A1xdHLCw1dRTim/tS?=
 =?us-ascii?Q?5JKEtDHAwWw+yTRBslumEM6WnVrpvZGimDlH7Yf3QiNoO+c6d+tfzU3FHPgQ?=
 =?us-ascii?Q?4u/4hm1bd42a5L/FR1Xt9clTLp/hceE1wM6Gskbx9DCG9O3G6xyiLOIgbD6+?=
 =?us-ascii?Q?NA8E5XQewAJqTkbrZ3JdUjoNPNxX5+5EAm2RkzwejgleFqzWIjPI2aLqi+y0?=
 =?us-ascii?Q?cvJ22Lub3mu1/P9N2uk14ANPxNN5OZ+302hVG8/h2piheKQhznqJi96xvqrq?=
 =?us-ascii?Q?n+F8+c7faIM/a87zz4TrSSafyUDJBbQr5bMhyEKoZGsg7U74jrHqbFdEE/+K?=
 =?us-ascii?Q?i761xA7WBnxqJ9xa8IJhn7cH+ehBroyXGnHLc7Q8K9p4n0jAZSEBQvavLEVS?=
 =?us-ascii?Q?ftafJqd/jWBpQu4KFx2fzZ5iCExLqkuOzKcasgzR3AU9lhWVZixjqB60gIdR?=
 =?us-ascii?Q?JYuaGf/YJUzYUBhXBrpoEaml45yNM2FgmLa7v+Xk7kOz5GTC34ulg2WnBicZ?=
 =?us-ascii?Q?iPuYiO3W0YttphDlNWLE0ujIPbB7y4dsKq0983thFSddRU4LhYc1AXjbISbA?=
 =?us-ascii?Q?IYsXqH0LkIjXmkv5TIZWYgNn/99tHHYEWP6ArC9R?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e5dc8324-4630-4f11-4608-08dc6030d9cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2024 05:23:30.8331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hke1lFTgFfaiAUqPDAcCqSLVcKRAzfFbUQsHCQPNWkUHKcqgMBM9BqsKMxX3j6HsQ7vz+cnP49qak/vheFZfkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6886
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 19, 2024 6:55 AM
>=20
> On Wed, 17 Apr 2024 22:31:41 +0800
> Xin Zeng <xin.zeng@intel.com> wrote:
>=20
> > +
> > +	/*
> > +	 * As the device is not capable of just stopping P2P DMAs, suspend
> the
> > +	 * device completely once any of the P2P states are reached.
> > +	 * On the opposite direction, resume the device after transiting from
> > +	 * the P2P state.
> > +	 */
> > +	if ((cur =3D=3D VFIO_DEVICE_STATE_RUNNING && new =3D=3D
> VFIO_DEVICE_STATE_RUNNING_P2P) ||
> > +	    (cur =3D=3D VFIO_DEVICE_STATE_PRE_COPY && new =3D=3D
> VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
> > +		ret =3D qat_vfmig_suspend(qat_vdev->mdev);
> > +		if (ret)
> > +			return ERR_PTR(ret);
> > +		return NULL;
> > +	}
>=20
> This doesn't appear to be a valid way to support P2P, the P2P states
> are defined as running states.  The guest driver may legitimately
> access and modify the device state during P2P states.=20

yes it's a conceptual violation of the definition of the P2P states.

same issue also exists on an incoming P2P request from another=20
device, as once the device is fully stopped likely that P2P request
will be aborted leading to functional breakage.=20

A device in RUNNING_P2P is supposed to either complete the P2P
request as usual (if handling the request doesn't further initiate
outgoing P2P DMA) or pend the request (so later becomes part
of the device state when the device is fully stopped) to be
resumed on the target.

> Should this device be advertising support for P2P?

Jason suggests all new migration drivers must support P2P state.
In an old discussion [1] we thought what qat did is Okay if there
is no extra internal operation to be stopped in RUNNING_P2P->STOP.

But obviously we overlooked that by definition RUNNING_P2P is
a running state so could still see state changed from either CPU
or other devices.

With that I agree it sounds cleaner to stick to the fact i.e.=20
only advertising P2P support only if the device actually supports it.

Jason, I forgot the original intention why you suggest a must
support of P2P in migration drivers. Can you elaboreate?

[1] https://lore.kernel.org/intel-wired-lan/20231013140744.GT3952@nvidia.co=
m/



