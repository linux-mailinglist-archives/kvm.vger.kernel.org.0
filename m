Return-Path: <kvm+bounces-8619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 049E2853164
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 14:09:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B07B328567D
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 13:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F79251C34;
	Tue, 13 Feb 2024 13:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gdJBkUPO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9348C4CB22;
	Tue, 13 Feb 2024 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707829739; cv=fail; b=jRKAT4y04P615u78OmttgBCNWtqZBJI/TTCrJVvtUNczO3+DVEwvsRxFcKTA2ZUiYR7mLVslV86ywZr0VwymAoGjevHr40DASsOLVy7NMMV6+eaV0UIDJ+fipirON8GtU1UkPDzX1Cmwh8Posob9wnyV0+dxTRrmVFVhieAGRGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707829739; c=relaxed/simple;
	bh=j0EotAiQtA+ne4l4f8zwEp1PPv0k4pUA+KhprLuED7w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hXFv06w6zA0l6dAvIluCuIliMXvzeIzZTs6MlwRH9nz97qi37zop1NWSmqmn6DUjoUR5vgOpg3IRLNu+vqGBJo766DYfHVHEdL5cmvkPiTElQBuYDB0QrgbhMzlgiPPnVSx1uOJxnR2bhiwWEkoOwbEWnxaIObkSKPMbL/54Dho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gdJBkUPO; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707829737; x=1739365737;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j0EotAiQtA+ne4l4f8zwEp1PPv0k4pUA+KhprLuED7w=;
  b=gdJBkUPO6FcnDeVR/2ql+gwzGeDYjJpBj5C+ppfnSoY79NFE23P25DVR
   JQHRQb5j2gsgwwK84uNjZZwPZYeTHeUvHAcXk7sNwWooQr/LW2MWKNQ40
   JxmHBt62dSM0Kd3HvXc9H4feJw1F32ZsOdBRarjq+9bXKWvL7uU8ntkPX
   DYVI73ZGTo4QsF2h7cIG8AMjO8DASIdAhBw4Cm6S9d+hF889G4IIGpyI0
   BrulCVPQGTjtrNgbaNHkP/3AFG7YvTGxcLaHJGy5kNVDccdAYcW6B2aro
   mcshT95nHytaIpt7f0YcqpbqPYRI30PGESwfkqRDtxP4jXJIgWAhBiQVh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="1986094"
X-IronPort-AV: E=Sophos;i="6.06,157,1705392000"; 
   d="scan'208";a="1986094"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 05:08:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,157,1705392000"; 
   d="scan'208";a="2850803"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Feb 2024 05:08:55 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 13 Feb 2024 05:08:55 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 13 Feb 2024 05:08:55 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 13 Feb 2024 05:08:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3AlXufyfCQfolsHEdYbKFZO+RemYEdCV7KwDcM7CCTwzvUW1Me2nphBtK1Zv3DB2n/KdooLvpUjPxFT+IU1810l2NeEnuPq74jXLM8kB21FqhA28NzygprE6HlFNAtfEjvH1xTYzL8k4dKxN6Q/AMFJv46tCryMoFKVB3OLuwbHFgXxR0DqFdIpOUOCoCcoskN0sju6njH+8o3WWBIeszOwfUyht2j2wdywyt9b3rdrJ3k8xlayV5KG7P3yHMinRTBxb60MDUjq8QnC5np2VY5PjuK45MLC0HZxeVQ1kUQVhIF7yequwhyhG/hjt57vgbMoWvuzSljOzv6iy1C7bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJLYeqqD0pkGez8tSikdUS15WAKhDHjOtM5Gm8uYTNQ=;
 b=RmpShSazJbzzrgE5f3L0W1LvckyPhHyq9XnMtK8Ny5Mvhr2ohUMciH6TJagJ0pmc8X88GI7lq9ga+71z4gbcXopoQDCKS5Iz8/GXUNHXpzthsRhDl4Bj9BEtfbhXRqF+7FUAI9jmUepfl/EfxP/WAitmvxsQXgHo2di9SNbrA4Xka9DZeKi3D73O9Wzj7x//aMZAPwz19+lgCQO0rYEQLvGvwakAI6qFCFt7rPhehfWEUCx1VWRXbK1adONADOAEcyg68hR2WaACzPpWbWGiH+FQdCi5dcP27htk6dzYVVATqJQNv37yHQhKW8xndrmfFZMFVn4Kjj2/nwTEUwuXgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by SJ0PR11MB4861.namprd11.prod.outlook.com (2603:10b6:a03:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39; Tue, 13 Feb
 2024 13:08:47 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::502d:eb38:b486:eef0]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::502d:eb38:b486:eef0%4]) with mapi id 15.20.7270.031; Tue, 13 Feb 2024
 13:08:47 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>, "Tian, Kevin"
	<kevin.tian@intel.com>, "Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Topic: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Index: AQHaVSVFJ9K0TVMQD0C9btTtb+JmirEAZyqAgAFFQ1A=
Date: Tue, 13 Feb 2024 13:08:47 +0000
Message-ID: <DM4PR11MB55025C3ECE1896D9C5CA4E86884F2@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
 <972cc8a41a8549d19ed897ee7335f9e0@huawei.com>
In-Reply-To: <972cc8a41a8549d19ed897ee7335f9e0@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|SJ0PR11MB4861:EE_
x-ms-office365-filtering-correlation-id: ee2c3493-975a-424e-3ed6-08dc2c94ea1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bQSbIXdI9TbPTdXJdCdoxBXpAKTyg6kAXG8VArdkayBWjeYzY2rymtwQB4VSLJvnRLpq/KnqPneYwqwieKuADFEUOMQ+ZBg9/hqwIJkTyMUTbFxMeR5VuvWscAfj1mdQsKT1qrLaqfwITQuD5mQ1+XoaqvqvKZ/ak3aeCaQ8T/YxExXa7qjvtzDBxJuV0TazthEnerO+9IAJnuej7cRe+duROycLSxDg0uKD9KDAOABVdG6oW36jwpDY7OIZXw5ZnwkdEyEN9ESlvZIWp1Wv/5m2EmyxkTvNn2aHJLc9MbDTYAl1qC9+33teTo5ZylM1g1LmD+5P5Vt580SLg4rWbKvF/J7MWjhB1/aKhLU/Ir3tAVHMfEYCEI33gIWGOlqFa9B6VmzyaC/3VHcyLmRBEiQ+FE9HAySfEUurB5127pfY73BxF0DcQj/aB2NEd90SXAKLR7yb0O4KqLc9nmU8F+eslMvPSOEfuHvodo04+MiPlkTBByKpfwhcAWsHztpRI38VG13r+8veOO0qbIfCS/mRTEQ4gYwg84AgvSlO/Zb2MloqHsEeCTvfWPcsuPfK//sUdHCrvhWYBzzGsMT2HxVVQ9cr7bVQKGQpbM3W25RWt4uyomlYPCofBqUZB9Q6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(39860400002)(346002)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(4326008)(2906002)(8676002)(8936002)(5660300002)(52536014)(83380400001)(107886003)(26005)(38100700002)(33656002)(82960400001)(122000001)(86362001)(38070700009)(64756008)(66446008)(66556008)(76116006)(6916009)(66946007)(316002)(54906003)(7696005)(6506007)(66476007)(53546011)(9686003)(478600001)(71200400001)(55016003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xUAhQAk3eOXjN1SaZ0vssa/AYqbYyQ+7gM+Na4i/pw70VJR5CgSk4+qJmA0B?=
 =?us-ascii?Q?wEDOT6dAesKj0czvGPCp31N4kNugwH0zTIMQUx8UCQGYRO5Vkmb03PDHixQi?=
 =?us-ascii?Q?ujY6gWdkjXm135e/5gU1Q6ukDps3Pf5fz6l3oaoHeA6PDSKuaCqinvsyGIbL?=
 =?us-ascii?Q?zhDCXbwJXPW66jVUMwQZtMIDMo/VxTmidKMnkVTTyxblwq1SyLDWRFWb2OLu?=
 =?us-ascii?Q?Lx9YGHyAbXCehG4b8JgzLWkVu8S5md+jkuAD/1T0PaSyAn/EcshgXdibm1R1?=
 =?us-ascii?Q?kB0+JMy8dPN0DiUfr8V9RF8Fp602dM4uAd+ghJ76KtLPwBG7iriL4BOqXO39?=
 =?us-ascii?Q?YxEpI4UMMMjPIQM9oct5TWWdb2K8giygz3d2MIfoDWHU8ZXrPc0VCNzBgaRb?=
 =?us-ascii?Q?sVNZzckA/lqAaMmqsKTR6HPW1R/e8rRrQ0B/MCn0Ord3lOFFi9NASh/NdAQl?=
 =?us-ascii?Q?OgeXYvr677IFL+g4Y6L63rk/shKvGMcolfdnhqb0f4IvW7Ht8Dxr75rubBs9?=
 =?us-ascii?Q?UYej2pTYJjDXmZF3IXpuMPQYQO8X8hldy98dUO3frFFdy2GilzMLAIRxy7RN?=
 =?us-ascii?Q?afgeQvmyU9jLLGvUOr5mbaG2LTN2/Unjdq6o+s1zob0V5/WQ+ZtZj2FHkn+u?=
 =?us-ascii?Q?5S9sT01RKjyqDidmnBzMittuhJ/72S4OC2xybm9N/QaQ0qbTrU+0kT9iurFd?=
 =?us-ascii?Q?ZsAGUgcFscWjkFiFDsNwzaEHLJQssAiF5hEDa3sqWvPwt9Dn5safMdysU1k/?=
 =?us-ascii?Q?9YBHW5H+GwbO9BU/urTQWOa5LVJ0VQYCHv+tMmN0VtLU6sAxmO6bYOpxeD05?=
 =?us-ascii?Q?YwgI/Tz1X6kgPT6Y3YgJiLNtulNqnD5q8MRuh9CUAq+mComjgaDUIo58Axir?=
 =?us-ascii?Q?EnUmyB6zeTLL2mkfDHPsNZfFkG/F9SuOswxTloBWfPumbqO+j+hP51TpSIMe?=
 =?us-ascii?Q?Hayk1mrfpI5aa/xc4nj+/OrKZkVsCDXOdUUzVVjXD7rApIae3OmnRYNJMgZY?=
 =?us-ascii?Q?wjtRlxMS425RvO5xNDzueHTwdU3oSwN1zLA0bT1iUwVm60zMmFtqo3sjvyNv?=
 =?us-ascii?Q?W9ijirAi2gXd4dSNmGrJRN65p3t+E1kInOCH+z++bxIEgqEQWqmGNJd6vsdE?=
 =?us-ascii?Q?5WdzEY/kGs+vbq7g/1nm0jT5DkpXricRcUfCclsvU7sgSWRmiw9HySh5+W6P?=
 =?us-ascii?Q?D7sFDX3QPzornlXK0cV6qg1VdWDx12S3/IK6th90VMthPWrDbF7GfpOZ088m?=
 =?us-ascii?Q?7wJqXW/5hDBsElWy7yBnHwf6i4MSHCoG6crRsyV0p6UUC5jXaBEzMMwO8RGA?=
 =?us-ascii?Q?L8v5Vb80VHupb3gPBwH9+sEjbbSSQMCdx1eX50JZeU0DJgnKti7P4jaND7dE?=
 =?us-ascii?Q?VdN0Og8W3oV390V6XKYZRWxHMlfoLABgBrsC/V9kdlQ6j3sMzTHoKbv9i1Zd?=
 =?us-ascii?Q?DrFbWY4EP1VG7QB1Pf9wphvxxwnmEQLOtNlB2SGPp2+wsaNQV7PxiGsNp2RL?=
 =?us-ascii?Q?SwWTikmDYhFVAs5XALCWkVunZshYJzTQ1LpP9h+CUEDxeE4/lSbwQ/5NXbLM?=
 =?us-ascii?Q?mf+aqCvLzD4j6/mYv9ZobNZ1gjE8tndukiaioCe1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee2c3493-975a-424e-3ed6-08dc2c94ea1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2024 13:08:47.3861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q9BVodFQX8pwMSShZVLSKhEbxpq4VA+HxowDqNDTevq9ys1JhfKPsWv3MVRZo0JwW8+MIC5KuQwjJ3ILTBBhvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4861
X-OriginatorOrg: intel.com

Thanks for the comments, Shameer.

> -----Original Message-----
> From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Sent: Thursday, February 8, 2024 8:17 PM
> To: Zeng, Xin <xin.zeng@intel.com>; herbert@gondor.apana.org.au;
> alex.williamson@redhat.com; jgg@nvidia.com; yishaih@nvidia.com; Tian, Kev=
in
> <kevin.tian@intel.com>
> Cc: linux-crypto@vger.kernel.org; kvm@vger.kernel.org; qat-linux <qat-
> linux@intel.com>; Cao, Yahui <yahui.cao@intel.com>
> Subject: RE: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF=
 devices
>=20
>=20
> > +static struct qat_vf_migration_file *
> > +qat_vf_save_device_data(struct qat_vf_core_device *qat_vdev)
> > +{
> > +	struct qat_vf_migration_file *migf;
> > +	int ret;
> > +
> > +	migf =3D kzalloc(sizeof(*migf), GFP_KERNEL);
> > +	if (!migf)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	migf->filp =3D anon_inode_getfile("qat_vf_mig", &qat_vf_save_fops,
> > migf, O_RDONLY);
> > +	ret =3D PTR_ERR_OR_ZERO(migf->filp);
> > +	if (ret) {
> > +		kfree(migf);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	stream_open(migf->filp->f_inode, migf->filp);
> > +	mutex_init(&migf->lock);
> > +
> > +	ret =3D qat_vdev->mdev->ops->save_state(qat_vdev->mdev);
> > +	if (ret) {
> > +		fput(migf->filp);
> > +		kfree(migf);
>=20
> Probably don't need that kfree(migf) here as fput() -->  qat_vf_release_f=
ile () will
> do that.

Thanks, it's redundant, will update it in next version.

>=20
> > +static int qat_vf_pci_get_data_size(struct vfio_device *vdev,
> > +				    unsigned long *stop_copy_length)
> > +{
> > +	struct qat_vf_core_device *qat_vdev =3D container_of(vdev,
> > +			struct qat_vf_core_device, core_device.vdev);
> > +
> > +	*stop_copy_length =3D qat_vdev->mdev->state_size;
>=20
> Do we need a lock here or this is not changing?

Yes, will update it in next version.

>=20
> > +	return 0;
> > +}
> > +
> > +static const struct vfio_migration_ops qat_vf_pci_mig_ops =3D {
> > +	.migration_set_state =3D qat_vf_pci_set_device_state,
> > +	.migration_get_state =3D qat_vf_pci_get_device_state,
> > +	.migration_get_data_size =3D qat_vf_pci_get_data_size,
> > +};
> > +
> > +static void qat_vf_pci_release_dev(struct vfio_device *core_vdev)
> > +{
> > +	struct qat_vf_core_device *qat_vdev =3D container_of(core_vdev,
> > +			struct qat_vf_core_device, core_device.vdev);
> > +
> > +	qat_vdev->mdev->ops->cleanup(qat_vdev->mdev);
> > +	qat_vfmig_destroy(qat_vdev->mdev);
> > +	mutex_destroy(&qat_vdev->state_mutex);
> > +	vfio_pci_core_release_dev(core_vdev);
> > +}
> > +
> > +static int qat_vf_pci_init_dev(struct vfio_device *core_vdev)
> > +{
> > +	struct qat_vf_core_device *qat_vdev =3D container_of(core_vdev,
> > +			struct qat_vf_core_device, core_device.vdev);
> > +	struct qat_migdev_ops *ops;
> > +	struct qat_mig_dev *mdev;
> > +	struct pci_dev *parent;
> > +	int ret, vf_id;
> > +
> > +	core_vdev->migration_flags =3D VFIO_MIGRATION_STOP_COPY |
> > VFIO_MIGRATION_P2P;
> > +	core_vdev->mig_ops =3D &qat_vf_pci_mig_ops;
> > +
> > +	ret =3D vfio_pci_core_init_dev(core_vdev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mutex_init(&qat_vdev->state_mutex);
> > +	spin_lock_init(&qat_vdev->reset_lock);
> > +
> > +	parent =3D qat_vdev->core_device.pdev->physfn;
>=20
> Can we use pci_physfn() here?

Sure, will update it in next version.

>=20
> > +	vf_id =3D pci_iov_vf_id(qat_vdev->core_device.pdev);
> > +	if (!parent || vf_id < 0) {
>=20
> Also if the pci_iov_vf_id() return success I don't think you need to
> check for parent and can use directly below.

OK, will update it in next version.

>=20
> > +		ret =3D -ENODEV;
> > +		goto err_rel;
> > +	}
> > +
> > +	mdev =3D qat_vfmig_create(parent, vf_id);
> > +	if (IS_ERR(mdev)) {
> > +		ret =3D PTR_ERR(mdev);
> > +		goto err_rel;
> > +	}
> > +
> > +	ops =3D mdev->ops;
> > +	if (!ops || !ops->init || !ops->cleanup ||
> > +	    !ops->open || !ops->close ||
> > +	    !ops->save_state || !ops->load_state ||
> > +	    !ops->suspend || !ops->resume) {
> > +		ret =3D -EIO;
> > +		dev_err(&parent->dev, "Incomplete device migration ops
> > structure!");
> > +		goto err_destroy;
> > +	}
>=20
> If all these ops are a must why cant we move the check inside the
> qat_vfmig_create()?
> Or rather call them explicitly as suggested by Jason.

We can do it, but it might make sense to leave the check to the APIs' user
as some of these ops interfaces might be optional for other QAT variant dri=
ver
in future.

Thanks,
Xin


