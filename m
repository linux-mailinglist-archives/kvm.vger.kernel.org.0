Return-Path: <kvm+bounces-11097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CF7872CF8
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 03:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47D0C1C26562
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 02:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84B2DDA9;
	Wed,  6 Mar 2024 02:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="asbbMXpP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33616D51D;
	Wed,  6 Mar 2024 02:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709693262; cv=fail; b=DFqgamcxsHmvBeBLSYmzUlK90ZkFM3AKCIx82tOXs0UfOP3218aBjrkA2aDbBRcn/Y17Uz0tXjQxgSv5ju/ye3F/NQNhwLpfnZBrbjDkTmAglhlPwFVRHMAxpkfIjmZNaaZ3YpE3jVHoI1/fQ8pNJesVHqKc73GsLvmgcMUa0Eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709693262; c=relaxed/simple;
	bh=6KS2PB+J/nDNECSUvu6r6WLh7L2PcCmqAg0TNEHXsfA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QDcHcBqVOSGp8SXQsyXiPSU/Lu0Y0qf2ItagoeWpxUW8f96hOKq523q0zfzRIntmOHe2AG1wZ/fVvMKjIKg/bIW8oMfcI25hIMfxxHoajymgodIa8CwOK7hdZH2fmyuDuzSfxSrg7FYJJmHhQkJuip/zmb5V1sVo5XaK1lk9Xi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=asbbMXpP; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709693260; x=1741229260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6KS2PB+J/nDNECSUvu6r6WLh7L2PcCmqAg0TNEHXsfA=;
  b=asbbMXpPxvnWDOMN4QzCvTu4ye4l40aKp6aeQYeDtJMDRNNyCCbMu5hr
   02WiSYdtFkgUIgA6OERPLm/SoSyBw/pg79DaoJOFg8L/i+vJSZe6+SHWR
   ERlqnWDpZYcsY4bJ62rkRfdtyVMxDxdWgMkI7f+WiCF8T6qHxfX3GjLC+
   0NJi6kXzh2PbLfNxbMPvEp6AzdO4saKqD7DqFxcVstCpTNGT63zUztvPf
   +Z6+2AhZGZM/xmRL+K339t6n4RapWnklkhe6d5z2UbNphQW826Nr0eaZA
   sGnspPkVae+i0a32TrxTL5T1vkeg89v0UhAazkFrQh0GI6ZpiWSljkfUR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="4458951"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="4458951"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 18:47:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="14295773"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Mar 2024 18:47:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Mar 2024 18:47:38 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Mar 2024 18:47:38 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Mar 2024 18:47:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0+7Un3GKAinIn3LFAv/PxC0+WaxoFp5HdaahX5XUZDd3jX8yVYWqEYNeaO6N6CINYQkHO3falW2+18BVoUDLUwsyHfyUMX4ffiJDTtOKgNVo04gGPB+bfziOiaabxDZq0lrjdDyRv5Q0nOYwAQK5DyNu/EkVuOl6H5XQjiuHL8sfwT49oD3VgLxsKjZB6+NGKswa5SEAA0AGf0iSM6rXb6MpUYpkhyCstt7nlb+jkpVkNq8xbl2RngIys3S2vf1YcrcrTu/8MaqpkkJ2MIqXTR04Uc+jouaiixHNwNSGaltonM+/YPd4X80zfblo6seXqp7+wc7RT/VhuQ1uf9tQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GAuCaNCyzXLZhJHOx0IQX84Eoj9L8+K6hnYy2fiXGCc=;
 b=TBB7RbiEh6y42VAPP7EM+8xHoGRNrPqghZBZJgrFzgCdyHVF8JMG3x8t410LF8+rsgv9SCxnoYzq6hLBsVvOGBdinVblJ4OAyx+WIprU3tMZaanBVlKo4GOFEIqvG1Z0rV93BryT71H/Pa3vf9Od0mbfqTz6fsokwkRRzSLLD7oZzOFdKG/QaNq9xO1UjEKon2w/lSWA/cYwdKBNY+4wSap1ing7gXuObkJiQUFjw2AU9xTNQXcU9GnTQEA73O+KOkY8JKvwGVxNzpNRuxaf4j2X1VaUonGkvvZYtH2UX93gJfFbLX2j53/qnf0IvKVgoYm1bQ4VuSpLrPSQs2Bj+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by PH7PR11MB8501.namprd11.prod.outlook.com (2603:10b6:510:308::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Wed, 6 Mar
 2024 02:47:36 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3487:7a1:bef5:979e]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3487:7a1:bef5:979e%7]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 02:47:36 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH v4 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Topic: [PATCH v4 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Index: AQHaalR9StzovMarUEC10fvX40lRFLEoy0sAgAAnj9A=
Date: Wed, 6 Mar 2024 02:47:36 +0000
Message-ID: <DM4PR11MB550263F49D2EA8755F3CCFA588212@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
 <20240228143402.89219-11-xin.zeng@intel.com>
 <BN9PR11MB5276492EDE7F9CA57117FE518C222@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276492EDE7F9CA57117FE518C222@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|PH7PR11MB8501:EE_
x-ms-office365-filtering-correlation-id: da9b25af-8f17-40a4-2e5a-08dc3d87c7f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DO54RL9SveuMkEKkt+5aHIQd7IM7DzdYZ8d569P4xB00xFMcVpQgP+jopmNyyXuW5jXAkgH8Q4k1gxyR2P6mtAI1Ak1tI/bL3npZP3kiHzTl0UjDynYXQoWhGdV+QuQGb7srAfT5i2wh1fG1GJnDfBpPJkq+ChFVA5vKmUFZui74vR0lnweQ9WF0XGVsyYgaggvgTi+WvVHMXY8bSlH4b9puaf5PCmMmvtJcuBKXvfKIyeug8yVdWp9LGhA06XZUQ3f4/tbj/hRo2mLGifnGIqfFWOr7hnZE+fg/MLgTuXGxyHZee3YrKI8oG9s6zRmEFNjYisTRL41EfemwPGtXC0vBIvBwEh1K8BomPbIRetZ1O0xdp0dH3xZFypUTgDQpWurP3z9h4C53SW/SRBqOE39RTsfgJaz3qu23QOyTx1a7gBgVQaAzRkiz9ahE0lmOxyXgCamAtUCB0S1lVXy+TLekSKeLpyC0sAjtp8m9QbBuQn5edaoZ79Q/55JrmYIm2fiYVU/+ppdb4m/26kdQ8S2pUKbwryvX3yTdxxQi2vCAEnor76wrMMFA9vknOKXJOniYZOx97ZNYStRanxhmMhA4xDi0yWOnLdR2qn/vuAL/h+Es0Urs6Q4EupBwVv41CccZEg8Aeekec/MxUjEhedrciaDchQVcz/gQjJb6dmjc/0pSy0fTzuryXuey2aaWA0Zj97Sb5y1hkaVnHKVfZ/P9Lxh1+uW9UKaeufvyhFc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2OTsKs5oYk50VhSF+EIXZ1Co3SbIsi42GmLOO772AQsrbmk5ZtNwRUaOKlcE?=
 =?us-ascii?Q?sqvgvssdBrKKii/hBmrMOtCd7RKLH6fhwvRI9dY233r1vDR4qm7TT8IMFnMN?=
 =?us-ascii?Q?k01TLSby3HznMR5Ix8/Bx9p/pnshW00v9DkcpaeFM6UD/brtrTiO0ZpHKkU1?=
 =?us-ascii?Q?iVbg9UoQzzEhRlSb8PWX3aQZjDZ7RYoItuxpIuUnvFo6dHSvYfosS1X1+usO?=
 =?us-ascii?Q?uCJbKV0YzhV0gTYBgarxFFVD53DqdZXrvgMKFpWO2eydhMESiUKALnG/X8iG?=
 =?us-ascii?Q?NvFNkzjvHny04BHG/jyDY6FbwacS7f2gwAASVgZLnDNz2U9BVIREbGGdur4W?=
 =?us-ascii?Q?AEO1cYhP8iHwtBESTikUccTi8j6eQwdeoWL7YrH9jxe+afIYOv/fpWvOhSdi?=
 =?us-ascii?Q?4aGdwulDQ/U91e2sdsfrXcXNlloqXqwbVuA3pkxNVRYOOfAMxPbIzdwG0/sU?=
 =?us-ascii?Q?KJGJrBXTHnrpnsvRDKFNNk9zATgEMA4I6s63KjFI0o7TUHJ0TI6wjKki+hYv?=
 =?us-ascii?Q?DZ7qnBzJVDxM44Bjhi6EcehFynCvr+l8QR9CyXmNeUJZlrUYMx4ZCbrO876P?=
 =?us-ascii?Q?gtn9P4i1rn1IUySMqdTrLHujCpK6CKxufidNxlq1/4MIOtiDx+gnBgRB6xJE?=
 =?us-ascii?Q?EXASYZdOCun03BfTt4PJvGakv2H4n7aoeQRSMaKAZYOQLzfDJxcl1ClskVQq?=
 =?us-ascii?Q?dyfUZMbg41fNPkp+I0H92fdkoZn/xfH57remF/t1BvKRjrstzcC4ImWENoY8?=
 =?us-ascii?Q?e1aoCl5xNnJ7Lru/tzpBEGhDRUbcmYiJgg151NqpOO2NjB+bicSmfU1vt1kz?=
 =?us-ascii?Q?/MoX8mcK9OwBU4Ntip/MwVCbINnhvHi/aayysisI9luVhzVOaN7bXnLiazRx?=
 =?us-ascii?Q?B/ZyD5poTGy/5a4K7zROVjEVbf25dA1uR7mBPxwfhL7Gg1M33I7OWTdQZrbW?=
 =?us-ascii?Q?ulAESH+qncMkna+xsF61TP/CkA93nynuflfk6d3/2Z5EJzIbfXLmMuaksDlx?=
 =?us-ascii?Q?kRYKDnY6/55J3zEfTKjwab1iFCgZDETJ59k15DTt3u5z1Rksi0MPWK4RVtZT?=
 =?us-ascii?Q?RtJgnZGPaghBWpEpAJUc12LnTJtuzunJqAgtdDq9Bk82sYXj9jpgzJTEylcx?=
 =?us-ascii?Q?vJYNYz4XzMyHzaIHbDTDCkA8ufU3PsVVQxTWcgASsDp7Ou8u4bCtZxD1LKOi?=
 =?us-ascii?Q?MvL8+R3LpCh44XWuGV/kGRO9R1+Y8cONXh+nTrWMZIU1o+y3o3TdoaEd2iCG?=
 =?us-ascii?Q?79o+pgcsptLTKH0oxMS9M4SmqSbmR1Es0NInRyQjGhL0VGjgTQQXvK87b3vr?=
 =?us-ascii?Q?fnLHft6x+54av4Z3x3yJoVr33sXpT5QFXh+1z/UNQ4QOSA5utGcBVOoUMrG/?=
 =?us-ascii?Q?meWWQdYDaEawiB7cJbKH5YrpSZwxSg4OUgSNVU84nB8u6EvVjvwvhcybmvrP?=
 =?us-ascii?Q?ZdOjshG3KVLK4uOj0L8Sc17AROYiWkr7eN5aaEWrv7iplI5pTkLuQaEPKCsE?=
 =?us-ascii?Q?VlhQisf3oUPHE3pxS47sx3VH6OSUhcMiONjr2s8x8aMoqzD/O+yhUjueOT6h?=
 =?us-ascii?Q?lbkNsRWylPFQNm50QveT0Ja0oGLKI/SSy+p+fH7r?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: da9b25af-8f17-40a4-2e5a-08dc3d87c7f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2024 02:47:36.3893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ZYrHE66lY+Mtm38UESi1d/+JeXkodn94EDQ1pQ7wNAr0CwAlCxew8FQr66aBWuCY5B4qrWRJMlLe6QwPjKTAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8501
X-OriginatorOrg: intel.com

Thanks for the comments, Kevin.
On Tuesday, March 5, 2024 3:38 PM, Tian, Kevin <kevin.tian@intel.com> wrote=
:
> > From: Zeng, Xin <xin.zeng@intel.com>
> > Sent: Wednesday, February 28, 2024 10:34 PM
> > +
> > +static long qat_vf_precopy_ioctl(struct file *filp, unsigned int cmd,
> > +				 unsigned long arg)
> > +{
> > +	struct qat_vf_migration_file *migf =3D filp->private_data;
> > +	struct qat_vf_core_device *qat_vdev =3D migf->qat_vdev;
> > +	struct qat_mig_dev *mig_dev =3D qat_vdev->mdev;
> > +	struct vfio_precopy_info info;
> > +	loff_t *pos =3D &filp->f_pos;
> > +	unsigned long minsz;
> > +	int ret =3D 0;
> > +
> > +	if (cmd !=3D VFIO_MIG_GET_PRECOPY_INFO)
> > +		return -ENOTTY;
> > +
> > +	minsz =3D offsetofend(struct vfio_precopy_info, dirty_bytes);
> > +
> > +	if (copy_from_user(&info, (void __user *)arg, minsz))
> > +		return -EFAULT;
> > +	if (info.argsz < minsz)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&qat_vdev->state_mutex);
> > +	if (qat_vdev->mig_state !=3D VFIO_DEVICE_STATE_PRE_COPY) {
> > +		mutex_unlock(&qat_vdev->state_mutex);
> > +		return -EINVAL;
> > +	}
>=20
> what about PRE_COPY_P2P?

Good catch, will add it in next version.

>=20
> > +static struct qat_vf_migration_file *
> > +qat_vf_save_device_data(struct qat_vf_core_device *qat_vdev, bool
> > pre_copy)
> > +{
> > +	struct qat_vf_migration_file *migf;
> > +	int ret;
> > +
> > +	migf =3D kzalloc(sizeof(*migf), GFP_KERNEL);
> > +	if (!migf)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	migf->filp =3D anon_inode_getfile("qat_vf_mig", &qat_vf_save_fops,
> > +					migf, O_RDONLY);
> > +	ret =3D PTR_ERR_OR_ZERO(migf->filp);
> > +	if (ret) {
> > +		kfree(migf);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	stream_open(migf->filp->f_inode, migf->filp);
> > +	mutex_init(&migf->lock);
> > +
> > +	if (pre_copy)
> > +		ret =3D qat_vf_save_setup(qat_vdev, migf);
> > +	else
> > +		ret =3D qat_vf_save_state(qat_vdev, migf);
> > +	if (ret) {
> > +		fput(migf->filp);
> > +		return ERR_PTR(ret);
> > +	}
>=20
> lack of kfree(migf). Using goto can avoid such typo in error unwind.

kfree(migf) will be invoked in fput. This was pointed out by
Shameer and I updated it in v2. :-)

>=20
> > +
> > +static struct file *qat_vf_pci_step_device_state(struct
> qat_vf_core_device
> > *qat_vdev, u32 new)
> > +{
> > +	u32 cur =3D qat_vdev->mig_state;
> > +	int ret;
> > +
> > +	if ((cur =3D=3D VFIO_DEVICE_STATE_RUNNING && new =3D=3D
> > VFIO_DEVICE_STATE_RUNNING_P2P) ||
> > +	    (cur =3D=3D VFIO_DEVICE_STATE_PRE_COPY && new =3D=3D
> > VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
> > +		ret =3D qat_vfmig_suspend(qat_vdev->mdev);
> > +		if (ret)
> > +			return ERR_PTR(ret);
> > +		return NULL;
> > +	}
>=20
> could you arrange the transitions in pair as mlx does e.g. following
> above is the reverse one calling qat_vfmig_resume()?

Sure, will update it in next version.

>=20
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Intel Corporation");
>=20
> please use your name as the author.

Sure, will do.


