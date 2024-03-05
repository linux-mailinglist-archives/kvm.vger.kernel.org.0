Return-Path: <kvm+bounces-10882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FED087172D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 08:43:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 436D91C20D5F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 07:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FA57EF12;
	Tue,  5 Mar 2024 07:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ggCKePJD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981757EEEA;
	Tue,  5 Mar 2024 07:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709624594; cv=fail; b=C4egkyv4PEntw/NYA1D/aHRQMIfEdOsDfQDHHu7hbKkUnm572NVZZgjuMq43VtPRceyAbeLbhBIC9PlwvGTaesC/PoFa8FFCvbS0yEp4EIY8GAcPaDSNRULHpRGvN9Kz+s8L+yFKm0hCHtFpMPpSAaNwNN8spmIv/wa81MSxu8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709624594; c=relaxed/simple;
	bh=2QAd01d6LqT4jIhwugNnSApPVQ/z9CQjOy9kiDD28k8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nh2A61IxRzNYVwZtfECaw6V5NeRU8PtuJKEi4gcr6pW8J2mPkWt/JH7mNTQW/Jkdsp3iv9f7NWFGb0mkw99jLs02VCM577DtvZ0fq3aYc0dijK0kCLlXnGtKcTL50YRPUJX6F+Q/Qv6FugOXpaYCEftFMvJ62GP7sV/sUG0isz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ggCKePJD; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709624593; x=1741160593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2QAd01d6LqT4jIhwugNnSApPVQ/z9CQjOy9kiDD28k8=;
  b=ggCKePJD6dsvyeZsd0RA1dSbtzptqBqX47bABSpBb+ypXopFR5Ckm2BY
   S35OmBuxD1oIBNRN8F3fysRm+Bowv0s2YA78l8Bwq/PoSKJr6svaZA8iS
   WkiwGEkJe/LFtJoXt3keSyBF+peamtBbJEber1hdt/Ts50C0kD1Woxp7g
   vguvUvKs9EnwDjFsNmMBYQ91x/8vDNlGtbZVjC9fZBgR0Ky63g8waHjcE
   B8wwHdK16hfNEzIghS5Ojyi4AZ+crz0qm+MKryMY/3ohSkucAcnoJwYWb
   153OLcRp6USCZX2JmyQ+LqjoTlerMJVKIYCSo+h6LhsnZ5RzLrAffl5yf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="21687827"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="21687827"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 23:43:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="9137141"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2024 23:43:11 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 23:43:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 23:43:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Mar 2024 23:43:09 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 4 Mar 2024 23:43:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VabpnWd4lUarkJFWRthyihTreDcqs0EN/wRqoMRz63CH48h4sklYnwhvJWXv4GXhEdiJKt4TEPsO+l72R72V5OE32joOpJwXhNToWytEODtWdvebSO1+GtsUzW2EY3mSRzLvKaXBfeuYIuGvykVxKq+ZmwLY/OtZRpYzlYkNsP2zZUeQYthx9hX762E2kGqiC2Mwg0JDiBFwOxCmOJw5Ay+HLgWWjr24KAW1KAcTtidMV5aUEKTqwxc0BAIb+DFHpCByxb3Imhz/EEQrjuKN6Eh61a5+GCugzBUDMtrdemcJjkzghQ0tfA2qi6gVAN4963Xf7qw0LhoI/iCiSMQo1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckxompoGVJ7hTR6YaDnf3WXiXBK/StkNkOLo8E/+jao=;
 b=mWPty7lLNMxMNTAOvzeONSONOxNXXd5Pi8abok2iSHgKVOArt+mLZx3KRXFrlvVPgl8sasvSOmaUwWV7cgfcR2bAkJoh1SUM8J5dBLghFC5I7HkACRsSRzc2QEMje3BXC/jX89hv8MYTgXzg0A+0ARs99tjgYnW5JFr6zBXK1wK+mHJKA2IhgCYrEN0XzMrCbgavpxFfwogg7093nKVNn9YfOEx9WHhNRc42sLnkd/kNu0dpc/0J4BqrBa98Eh5G7vZHG07g1Z5zG53ax9iZccvE0ibub+9D3dUs790wcQMUiYFZbU353ja1gYykrSZOPngDOTtIb6c5AZMAoCKVeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4959.namprd11.prod.outlook.com (2603:10b6:a03:2de::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Tue, 5 Mar
 2024 07:43:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7362.019; Tue, 5 Mar 2024
 07:43:06 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zeng, Xin" <xin.zeng@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>, "Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH v4 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Topic: [PATCH v4 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Index: AQHaalR95YlyUWWE9kKxaDXGuT4g97EjlCQAgAPgaQCAAVbSwA==
Date: Tue, 5 Mar 2024 07:43:06 +0000
Message-ID: <BN9PR11MB52765004B838A18B46C43C328C222@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
	<20240228143402.89219-11-xin.zeng@intel.com>
 <20240301165848.37cfffaf.alex.williamson@redhat.com>
 <BL1PR11MB549484AC60C56912F260933488232@BL1PR11MB5494.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB549484AC60C56912F260933488232@BL1PR11MB5494.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4959:EE_
x-ms-office365-filtering-correlation-id: 803ff90b-908b-4de6-075a-08dc3ce7e58c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BKcmAnx9kDGxkyUf3ETspQPZm1AWue0UIaw9qfeo7bBqFJ5EuPgge66w74+emfhv5Y4/IxoepwLrlSBnDxtp0pojxw+90/RAgMuKZnd35gz0mK6DvdaGahJy6A+t6Y5BH1GYVvicROrfswhYmRX5XZ7Dx+vBycYXuZPtHnWhzRBW/iA8D12P4O/GwPQXrTfU17Wqx6mguAgoFhbd9Sys2CwCUI/zRR5yMHaiCvxyXvEXjzWE+D4oFyeyucZBscxleIA20pcpy+f9gmSMXytDnTfs/+0DKuznnCVRmr2BD2+cpkKiOw0joG/DAZaIfuDC5TLruqVNdDyTurWvkDQmHKpfqruLP+uojq8llYeVvVMSur6y/J+jpZ5usXAINV22hJnL+SHXB/yVoc75SilR+93RlfnOLTHL3Jv/Qkj7Wrnpd3lWlyGwYN1aeZT6yWDEjnE4kwmI4swCevhSLfWs4ABBOgoFVif2T3E1LPK0+HycIszO4ZDq+kkH7EPIZOu2X6joLnpoCBw6qATJ6zLyU3Y4rMZoQSXbrsgcXitWUA8SgRTgFViQnUZnOak2KCvK7f8x7AVOlBTIO7KFFBF1yC0SOuAcBYBhMzfrycrZkqkLX5gJWDGDnE/w0LBzEvyDG1hKZoOpq4qK//hEWtF3CdC00OdEld4I0w1GN6yK03Q8aV/BpoFMkvLoDLhlgLCExvGvoe1g3ItwfEZPFx8/uzFua0udis0TRcIvYvJSg7E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WBq55n5bYOInwQXPg17Z/rUDzUn8ftupcl0um42mUVkwHoIXhhG8SM25/S+r?=
 =?us-ascii?Q?ZXAGskYsLNllNngZKu+44tR4v3a0wa6lGFqm0LZPQcU9a4m7haXnhWzUdheg?=
 =?us-ascii?Q?pjhoD+GIsCwmlbmBoX5LRaeKdVWfSt5vRYzk9M/+UfDAdP7HENR2sW2Mt9b6?=
 =?us-ascii?Q?x4rz6NAk/qRjpYVSrp5mKa43WKSwz9t/BN/3nihnuOmg/u5LRXUzCoaNnOJ6?=
 =?us-ascii?Q?nfL2NA1MketUcG9WK5bh3rqy7guizax2ApqOYs4CK3oKGGoBc5YS5u6h/Yh8?=
 =?us-ascii?Q?xpDexkmzJkto8xXeSgagi1II5Dnk7RUy7Ad7XurdymV50ri5I1qqUe91W02G?=
 =?us-ascii?Q?7eqeH07hp5viyjbhQtcqjViLLVfTHy3YJmkt3V0F/Q6Eg0T5UdhW84BLM0rg?=
 =?us-ascii?Q?7G9MfFxtal1baON+j/2JW5YCGu+l9NHO5+pQMzlR5rdyISl0CVw8QC+fZzPn?=
 =?us-ascii?Q?4ocFlJKeK/6Rit9+88c3elZNjO40HHhJiX1MYn3KnANu6Q8SDfR2RXOBriUK?=
 =?us-ascii?Q?34E3uZ/ich7bAoeKaBgjJKF/YK+mVzQyNEXY7gHyMt18ekzoDKJcYeOZqJiL?=
 =?us-ascii?Q?5Giy2EbrsZiH8YofMjs3PzCGHikfdPCH5OZn+8TL86lGT7PlaokgWUFmrmlA?=
 =?us-ascii?Q?ZlHntlEOm07vM63qkKpjh8vwpaxOXSQtGykJ+oF4SpQTjY2d9cmM7Sxs7czG?=
 =?us-ascii?Q?8Fcu7XUkc5D/Ow7lhEnpJ4PSsf/5QO5PWPd3HxMq3beNCYOIT/AjrGJlj6A9?=
 =?us-ascii?Q?5xbeLMcUSYNj9ulWLuzX3DgqY3PX/Qmu8qWpCCJEuEq+Otvne/eHsIHbL1EX?=
 =?us-ascii?Q?Q0K0w8ozInuTOSfVK0w+f2CHIt1cvKqTHJhuiVkzYL0TwdqmRsLlXxN6jNUh?=
 =?us-ascii?Q?V7jm+5A7UFsM4mh5qmzwxHnKwGBeHgF4oxGivVQZgYRruTqrctVgTUVdJZi/?=
 =?us-ascii?Q?EVIWzI91BL/jB/4wd8t6fYCOUX1MiqtCRwrJ5DP1rO/nwh25pFH90wABU9YA?=
 =?us-ascii?Q?Iet2/hIbv4fCEktQZED7SwdCWX9zDiOkD7OWuQVZJlIE49/H0nW9+Qsa8mLC?=
 =?us-ascii?Q?1ThNfLp4DXDns41WsilEpwIGnxKDrQ0L6gSzpbonljUoOr9ak+dE5AX+YHVn?=
 =?us-ascii?Q?qkn2AgKncUag/wtzD4VUnYugk10kEYBAkhOeiQ/aY8xwaXx1LDCYU2DoDV53?=
 =?us-ascii?Q?LEmd70HmUF5XZ4poRLyaqvr4p7g+9Qmt1o1KCbDQQ8mQBinJ3SNshsPIh8PX?=
 =?us-ascii?Q?dsuct+qE2c5GpTLndRbsoHbWE41x8uD24VvIXENTdWbwugptwtwaXLvGZAUP?=
 =?us-ascii?Q?DzcxqYtZ6fl2NGyc6fJkWrjEoIEK/JaRQh27MeBmeyYovKP2N/pR8dl6s6yw?=
 =?us-ascii?Q?RPEO6ywT9CWfnZxAt18qXZxs96rIXUdE0OSDvhOIjjn9n9MH0HayFabjJkIB?=
 =?us-ascii?Q?Mi8qmLHRfJaYGwTAUpTZ96j9zwHYlYdixEApc93Kqm9QTYJy/EBfOLz9eBBW?=
 =?us-ascii?Q?bw72ZK5oUvigwPHGept4Zan4M0FKFadN5Ck1dK41fzbwYdkgwxRiU5aOR7is?=
 =?us-ascii?Q?75f2Zf9jhCJ3//rUxUHlt7o3SwV5FINWgUYyMzdH?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 803ff90b-908b-4de6-075a-08dc3ce7e58c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2024 07:43:06.5698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L7DtM5RlhhW9p27KgWXUQzlGKTzLG5IeqSc9MdZK2Wk/kyTZ5JyHzbp0BYncca69TvbbHpVXyTwMA55D/ez+7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4959
X-OriginatorOrg: intel.com

> From: Zeng, Xin <xin.zeng@intel.com>
> Sent: Monday, March 4, 2024 7:11 PM
>=20
> On Saturday, March 2, 2024 7:59 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Wed, 28 Feb 2024 22:34:02 +0800
> > Xin Zeng <xin.zeng@intel.com> wrote:
> > > +static int
> > > +qat_vf_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_=
id
> > *id)
> > > +{
> > > +	struct device *dev =3D &pdev->dev;
> > > +	struct qat_vf_core_device *qat_vdev;
> > > +	int ret;
> > > +
> > > +	if (!pci_match_id(id, pdev)) {
> > > +		pci_err(pdev, "Incompatible device, disallowing
> > driver_override\n");
> > > +		return -ENODEV;
> > > +	}
> >
> > I think the question of whether this is the right thing to do is still
> > up for debate, but as noted in the thread where I raised the question,
> > this mechanism doesn't actually work.
> >
> > The probe callback is passed the matching ID from the set of dynamic
> > IDs added via new_id, the driver id_table, or pci_device_id_any for a
> > strictly driver_override match.  Any of those would satisfy
> > pci_match_id().
> >
> > If we wanted the probe function to exclusively match devices in the
> > id_table, we should call this as:
> >
> > 	if (!pci_match_id(qat_vf_vfio_pci_table, pdev))...
> >
> > If we wanted to still allow dynamic IDs, the test might be more like:
> >
> > 	if (id =3D=3D &pci_device_id_any)...
> >
> > Allowing dynamic IDs but failing driver_override requires a slightly
> > more sophisticated user, but is inconsistent.  Do we have any
> > consensus on this?  Thanks,
> >
>=20
> As migration support is required to be reported at probe time in the
> variant driver, and migration support is device specific, the variant
> driver should be considered as device specific driver, not a general
> purpose vfio-pci stand-in.
> From this point of view, maybe it's not necessary to allow dynamic id
> arbitrarily, matching devices in the id_table provided by the variant
> driver exclusively would be the preference. If this sound good to you,
> I'll update the implementation (to use the correct id table)  in next
> version.

I'm leaning toward this view too. Somehow driver_override is more
restrictive than dynamic IDs based on its description then it sounds
a bit weird that on one hand we are doing strict match upon static
table but on the other hand lifting the bar for dynamic IDs.

If consensus cannot be reached quickly I prefer to not adding
the match and wait to change all drivers together when it
is made later.

