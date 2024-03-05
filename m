Return-Path: <kvm+bounces-10880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E3A871705
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 08:37:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D156A1F224F6
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 07:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E84AB7E59F;
	Tue,  5 Mar 2024 07:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SDG1Rj5b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C9018E1D;
	Tue,  5 Mar 2024 07:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709624268; cv=fail; b=nCNNmIQjXbapAbOeM6egVCWZf4c8lmF8MvKwxUDP4KgmV4ylgbGPJZsxufN3wQWohfQeNs+DGN/1j986M88aZ9WDD4+Es7f/p6qCvFDwcRQ5MU030VvjIRLODODkatK65F/7hYlynWmg+OeSce/Vv4zDdaNaiMI3/uNrjW1UuNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709624268; c=relaxed/simple;
	bh=CeU8f8KIQ1HUQxxd2NcXTQUj6fMNoUcBcON4b8NfUHo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C31eeBYGvGefde8sa8CfGV/dlxh8XY8AzQ7hFkzudmHfup4xFbZfU/1MYGM+cflueyHcwMDzns6OYkF+szO8tFQaz1VAw/DTYO7sNKkwer0+F1sbkAhn1HX8DJh6BlC0awq2eAHQO5OoULKmbhFAhMDKFAZpQFYd6NRnokc2Ufg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SDG1Rj5b; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709624266; x=1741160266;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CeU8f8KIQ1HUQxxd2NcXTQUj6fMNoUcBcON4b8NfUHo=;
  b=SDG1Rj5bR5vOORntUzdMGy0GcF4iSeWDkNPDEgfWdaCgoyf1RDVJEkFb
   zblGe0IF9eGIp74pcbRC75XEg2Z4vXCte4tzOiMWd49IIChKL4Cjd/bW8
   mL4hVlmC95zBdsq0Sx7XH8ArgVd/c2pYyYhZgnxdLVCx8EIcOgZnVVR2e
   t1M/II5HolhxWsK+zoF0L0Ys8huRAGH+Byn0P91hxcPj3YQinuCJ7t3rs
   +HGxqvjgj63lNSfse412pIu4bEEt/+pgzoMKg9vSLz8paqn711LBLGkY2
   rekun16sgCSmKJ6FHJdTBT7NgnaqQzwATAXdNydKaDw/J6SAg72ct2OIC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="14802125"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="14802125"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 23:37:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="9249393"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2024 23:37:41 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 23:37:37 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Mar 2024 23:37:37 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 4 Mar 2024 23:37:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYZIHunyddwLwGmQR1G+iruur9BiJ2xSKqwB0pXbhhr6qcfhIP0K6zDIx6jXSj995IhJYcmlYcLFt+QqpAuGFlUbFXGd74v1JlV3GFICyxYkL9QAlnSX9ictyjAO5U99ZCPSvf9fIS4cQOiFA+n9gOdljFLdrAmI6yvmn8yzJXuqKXRBHTbSGhNl/z6BNZIKSwge56zf1r/ApmZo/qE9oXQBiMmi2iZwUK0yXN4feaVlXYI3nBGKXKroOxjoA4BITRy4tiohdWmPKEY10zo1dldNwA8su8xM0IY4dtR2lGa0+vSWT1msvcInFTguhqlJyzUKeFYYnDwiO3MtFJyJ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYb3DU20xodiZ0QOgCkpLBZh9DFiBrZQzzlXcZ6USnY=;
 b=T5Vljo8nCO9auteFRAJb8HnrrHbPjsKWMQyNXyOaRSMONxwsPPoJDo4U655E1Gn2DPttpbNkiJTer+B2sMtWXlAhdNILGY81iqSRFgeK4G6zvdqCc7yC7jWUTU/RaumEOMCZ3hgCCt9OjjOoAjpkpGnpVi7xzDaxhpvDZQVAflpnXFAQPMC+jT/AxgqCTs1Wlz6cquLQFP5C3BbAV60wbj9gcbE/gsfu9NhqCJy0nKx9vZ02s3polD+COUPHe+TKb17SPtsYzVUYV/dZSJk2n5JxHqACuZgOkezhWeeLENJqwLzH8n2IAi9lt5sPAvdpgUVFMOugzlpo/Hz+2EIqdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7248.namprd11.prod.outlook.com (2603:10b6:208:42c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Tue, 5 Mar
 2024 07:37:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7362.019; Tue, 5 Mar 2024
 07:37:30 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zeng, Xin" <xin.zeng@intel.com>, "herbert@gondor.apana.org.au"
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
Thread-Index: AQHaalR95YlyUWWE9kKxaDXGuT4g97EoxSgg
Date: Tue, 5 Mar 2024 07:37:30 +0000
Message-ID: <BN9PR11MB5276492EDE7F9CA57117FE518C222@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
 <20240228143402.89219-11-xin.zeng@intel.com>
In-Reply-To: <20240228143402.89219-11-xin.zeng@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7248:EE_
x-ms-office365-filtering-correlation-id: 2657763f-0d2a-46c7-6f49-08dc3ce71d18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fp8B7KUoQh4k7c5TTE7fw+CsN3+DD7ktXzfgwZcC/4n6we92gqFcNoNOHIjYuNrAMQiw3OcxbnRpthDvmMfhWBjo5jxlxpUCz4xYFEvCr/8bxve//b7V9y+v/jgcFHbsC+wqlYXTI+RcIBTi9y24ihSf9U3Vp103u0Xv+aKdPGMderXp8n4P5tHh5n9kfWikMdk1/7MLb2pXvFtej5iGa1MFJDysPxLyPWaLs5toqtlUMT9IVd+WuiLvoLXkraTj94ICyHgm9+345fSCLnrV2tkAtleCKq1qIdMaFJ7+lGW+08nafdWRKy2h5Ev56PYMAILaMkxSnoJ6bistd+1sPUvVIL0gIFS8OLy+mPBz+/VMTtSBcksBSOcoUIUWaa113tTmgtZYdwsLZVMK0BJvMDSX0EXq86LFzcNPrXoBK1jmAlgyYyi11RnnMrSgeSAS50wo/jQsxDKQC/1ywzLU05I3grnoQ+WoAie7LWkvUu8ByQEJilSfcfv/8ddXB2Cr+FpAZNoW25EHRgRPCTRuS/CqZFL7e8Z6DLRWJSVmKqAW2zL5kDZdNWtHCqvFiiJmgnCaNVYEgT9splQ2W+t/zKSTB++CNCNLEiEAc6gm3ovoiC/SJOEH06fi096mWmYLDgR5NVnQGjYnbwBVK21AJMbLSUXSJwuCe+7VRP2eKoDOEubPd+tgOjfjSX9jLL6dsvge361UJi/KX/tifP82h7YNbQvFFIuY/OOZRlhMLP4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gYNhj1Set+JDK/xUurnT7AyAF3T7KDYWEOzUbZuM6eDRdPrXPwhcz7rv9hnH?=
 =?us-ascii?Q?MTY6EuTsuqyADrRTRF7c8sr85NQfV3UiRYVciaLRpimOfEbNj6w+GbELJXXZ?=
 =?us-ascii?Q?0DW9iyK8nfB5DzBf0uU9vwZMe4vARsx+IX2c9VFhtGVEzBMfeqz9jxlv+2M4?=
 =?us-ascii?Q?FaQ4XmoLZzppgZecKHniYHa4OvazTKeWDNDlZcUZeSjuv63kIQrvGBVh7te3?=
 =?us-ascii?Q?KrX1Cra1w6tYMTBylH1nQgdSzoD8hky3tDOjVxfUtcvEps01xBalpFcmdj0A?=
 =?us-ascii?Q?rWbixsBAhtAYfQimYCmk2x6oDkhH3JSrdka//bmkueezs7WdTVB2WT+KfIW4?=
 =?us-ascii?Q?eLFk41Ik2TudPXgwxNLeZ2xF4Ff+QBItFu7WJFLxQF0RH87aK9LbKzuaO9EV?=
 =?us-ascii?Q?a9gJpHB9zvTHZT23oVQwDjfAPCDS501y9f7aLq/Dml7Sy9+lPFNNdcsfpfkp?=
 =?us-ascii?Q?W0AS8tLT86UOjNUAKzsUGbKsOLNpdZSG0YCRjl+scRwCvXmSwDAt8eVcs/AL?=
 =?us-ascii?Q?f4R1dPPu5+Xgn+FA161uo4bM71csQEUBxeV4Krrdeet7UGcSy8bdrKxf8z48?=
 =?us-ascii?Q?YUD1LLN6nY0C12XUsxHwEVal9uEGPMH1d9g5ifaSeyQyfHt09z/YoKM5iwRe?=
 =?us-ascii?Q?wumndEfqvzDWsC9aUCJvG7TgxmyfJd9Vm88O+1X7GgHL5/CeDiW0wiiUMgTP?=
 =?us-ascii?Q?nYQ3mYkQv3kUH9SoyqvS5uOEMegkfjxJ2ALZgY6DTJ/0Dr+a/7/LPkLyC8dc?=
 =?us-ascii?Q?MDUMivAK8lzR83U0RXqK/JJUz2j+RQJiqMIxcMQVIx7RwRXjZ2lsN9sDYsdi?=
 =?us-ascii?Q?LNu/nSJgidT67CTS5f4XosbuPp0RhyOub0qklccothzPkY6klgbeHuA4fdrW?=
 =?us-ascii?Q?rKubqK1p5817peFJ2sU5XQ106p/QMfGz+jfqEdyDyk+fFFfPV3rXeS41NOdI?=
 =?us-ascii?Q?ZLJqYOM76S76Fbb14VGXlIwLQwrVxaFYz83GF7bXqopDEdO0UJIvNAmZLAsp?=
 =?us-ascii?Q?yNb77PAP1lJqfHZyPAiE4kASAJZc13ZHjJgh+p+a/kD9pMGoV8q7JSNTReQu?=
 =?us-ascii?Q?zqyIjENuaPyCn5x4pEzuRTTsSJ6oCQquDn4Eu5xnq8qhnvVBMPNofplmm8wm?=
 =?us-ascii?Q?6KBIoJvLWEPLv/FSGDB6rjt/QAdkZplIHBazwgGBqco8RiWzV1WwxqhWs4hx?=
 =?us-ascii?Q?bdRFAwedE1Z1UlYTcRsWRlURaYiPtgK6ZJu/HtNDtA4eh6VLGK58Y9KytqJP?=
 =?us-ascii?Q?izYqUemjzPgRR762D74s9e93svCI4MxYTwcuBOdNnmVxgNlQ9PA7TdmMvKSg?=
 =?us-ascii?Q?rqwE6fQsKB+5ZR+g9VNFzY63ESaj53wrFlysXtLfiiu2k6UO2SSzT+kLNm+r?=
 =?us-ascii?Q?htmtFKEIK6FVew2t3ppw231t3F9gHKVR9xQZ4t5vb/s1Gv7xcWsd9oKJRmbC?=
 =?us-ascii?Q?N35FQz0uDVsgjcFuuM9R+y11FXaRclgPZftFSmMBbMusn+qq2+H8nBuMRVlz?=
 =?us-ascii?Q?okn3MYiSSQewiuVuDaFQmi2KhD7w4tn0SjrzBXvvQCVDxwoOLMelrq0MhicY?=
 =?us-ascii?Q?GHm9s4Wn3yqOWWOLSLeLGVRKd5PMe8t1yDE5iLAV?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2657763f-0d2a-46c7-6f49-08dc3ce71d18
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2024 07:37:30.2399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YIzWG+Y7tRpxG4OsRC2apcEuP+YAPD/3b8hFNBYnw4LFd3M3GHnfmw/zdtJY67wWriEMjuQuaTdNiDS5DAm2tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7248
X-OriginatorOrg: intel.com

> From: Zeng, Xin <xin.zeng@intel.com>
> Sent: Wednesday, February 28, 2024 10:34 PM
> +
> +static long qat_vf_precopy_ioctl(struct file *filp, unsigned int cmd,
> +				 unsigned long arg)
> +{
> +	struct qat_vf_migration_file *migf =3D filp->private_data;
> +	struct qat_vf_core_device *qat_vdev =3D migf->qat_vdev;
> +	struct qat_mig_dev *mig_dev =3D qat_vdev->mdev;
> +	struct vfio_precopy_info info;
> +	loff_t *pos =3D &filp->f_pos;
> +	unsigned long minsz;
> +	int ret =3D 0;
> +
> +	if (cmd !=3D VFIO_MIG_GET_PRECOPY_INFO)
> +		return -ENOTTY;
> +
> +	minsz =3D offsetofend(struct vfio_precopy_info, dirty_bytes);
> +
> +	if (copy_from_user(&info, (void __user *)arg, minsz))
> +		return -EFAULT;
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	mutex_lock(&qat_vdev->state_mutex);
> +	if (qat_vdev->mig_state !=3D VFIO_DEVICE_STATE_PRE_COPY) {
> +		mutex_unlock(&qat_vdev->state_mutex);
> +		return -EINVAL;
> +	}

what about PRE_COPY_P2P?

> +static struct qat_vf_migration_file *
> +qat_vf_save_device_data(struct qat_vf_core_device *qat_vdev, bool
> pre_copy)
> +{
> +	struct qat_vf_migration_file *migf;
> +	int ret;
> +
> +	migf =3D kzalloc(sizeof(*migf), GFP_KERNEL);
> +	if (!migf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	migf->filp =3D anon_inode_getfile("qat_vf_mig", &qat_vf_save_fops,
> +					migf, O_RDONLY);
> +	ret =3D PTR_ERR_OR_ZERO(migf->filp);
> +	if (ret) {
> +		kfree(migf);
> +		return ERR_PTR(ret);
> +	}
> +
> +	stream_open(migf->filp->f_inode, migf->filp);
> +	mutex_init(&migf->lock);
> +
> +	if (pre_copy)
> +		ret =3D qat_vf_save_setup(qat_vdev, migf);
> +	else
> +		ret =3D qat_vf_save_state(qat_vdev, migf);
> +	if (ret) {
> +		fput(migf->filp);
> +		return ERR_PTR(ret);
> +	}

lack of kfree(migf). Using goto can avoid such typo in error unwind.

> +
> +static struct file *qat_vf_pci_step_device_state(struct qat_vf_core_devi=
ce
> *qat_vdev, u32 new)
> +{
> +	u32 cur =3D qat_vdev->mig_state;
> +	int ret;
> +
> +	if ((cur =3D=3D VFIO_DEVICE_STATE_RUNNING && new =3D=3D
> VFIO_DEVICE_STATE_RUNNING_P2P) ||
> +	    (cur =3D=3D VFIO_DEVICE_STATE_PRE_COPY && new =3D=3D
> VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
> +		ret =3D qat_vfmig_suspend(qat_vdev->mdev);
> +		if (ret)
> +			return ERR_PTR(ret);
> +		return NULL;
> +	}

could you arrange the transitions in pair as mlx does e.g. following
above is the reverse one calling qat_vfmig_resume()?

> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Intel Corporation");

please use your name as the author.

