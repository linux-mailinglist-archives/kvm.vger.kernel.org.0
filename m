Return-Path: <kvm+bounces-10791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA3586FFF5
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 12:11:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 700E01C2300D
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 11:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC2639AE8;
	Mon,  4 Mar 2024 11:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oHLlEYYk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E119538DDA;
	Mon,  4 Mar 2024 11:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709550653; cv=fail; b=cZ5yuTKyPaCakRzl8ks982IjTZ0Labepz31VI4Xn/v6bX5DPuNnFrHPQsU/XEFqYs69KgBoltsCOXwi5BAIPEc2T2+Ja7FgCJTENO1sIIsd1toNkxoZs75hPBCOs1nRAmjTKdew8OqyuYaRa7uuAHxcKEq2h/wjoLLeaE7Wlj2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709550653; c=relaxed/simple;
	bh=8BcX9Zy+3H8NgJxRYKneIFQT/lpap4QTGCIivgxcC2E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oJTWtkvqGY8mAifm5jsQtLABO0hwTb7g08SkZ7+NoHPEx7XQNXBRGsqZCoBx2lXw+88H05jR0vfsOl9mol4Ksh+JJm2ta1qzAy/pzy78Cgoq8AlB1b/t3ievNsZ0zY97KNi2FEG9KlbgInEJbTcL/5bL6EBzD7sZ2hrOANHSmW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oHLlEYYk; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709550651; x=1741086651;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8BcX9Zy+3H8NgJxRYKneIFQT/lpap4QTGCIivgxcC2E=;
  b=oHLlEYYkmDZemvgCGlqiJxcTnzOQHOjaS+vck0eeUqKx0EpGlcdvA+n7
   oqn99N843b1hFubXWuJjR6NHwJBoD29ER9gcIBWWAj9vkeW0JM7rXHCvm
   XbrFbBNf9zn+e2daVpcPRqhAMBugIZGp+KRQXBS9lms0Y5AjSRLGUU3QN
   dJ35D/RUTQqOoXpTtkzLfCOfMqg9xjkEqQ9d3MBpbIbRH8ay/3aUMzEek
   1bGJeTvRILchMcYgvZljTvJzwZ001OUnuNeHmkwWhybhBV4E0MD1tvjq5
   GWAXyfTZO4NFJFq5pS0DBce42/ftnWdso5+ZKK/tHo/SW5oQadAXnBP3H
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="4198557"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="4198557"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 03:10:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="32123594"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2024 03:10:50 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 03:10:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Mar 2024 03:10:49 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 4 Mar 2024 03:10:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8FB1ehIUCZhFiuDcUFq+HxNcqUraKvwcB7/e/AQk6demER6eqCAsw/K464iWWC1xawIaKjn5Tu/UOsql48Kw1bLA7s1WFA1GYB6W9fJF8jYChnKXSdaJSv9uCMUqJmjwrXtpmggL4AYYOsKk2gHHl3/Tdtp3XBiKj8mUgLZw+/wi9u8zMY5h4lj8eycAVZ2OvHzdxUftIBDMMYPkIWWxfXO+veTrxxjcGeuWe6IOujK94H5EBq6xZMImawJt32cevkYS323qLudizPX7PzuaN5fF6968pdaFg0mM4veGB0drgjSwv9LoDab4mKrcsopF2dFPttpNG530VojSQBDBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWGyTsNMpQl0jFKFFUwFJx6kHNrbQUQ6onc9MxjWILs=;
 b=K+E31M+i9zSZYRiWNSaPloHU/0SbIUglL3W6E8twH9kIX3SX3kJXTMAcQwFMxA5sTleO7DHVp3xiYrnPI54BnQB2pAsTxnz/JYjisNNdyTw3NlZ8r8C85aROUGQAEU0Lkx9PBNH0Swef13VjhVVQm7Io8bRZaGUAmOAfQeABpgay49bJRk9rd/rhdLV0SKC9FGjn4+mewkrLN015m8RoUIJ/RBJEKbo5BNaWKnoZ17QR8L1Jm3cu0xTLmlmpNpErzEysYm7Lc4F1Zb6MfjfIzihBR+Ll9drbNccZBDllEBoKP3Rir8Qt43SHvy+j0oD895GO5sysDNPq/bi056Vk9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5494.namprd11.prod.outlook.com (2603:10b6:208:31d::19)
 by LV8PR11MB8698.namprd11.prod.outlook.com (2603:10b6:408:205::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.22; Mon, 4 Mar
 2024 11:10:46 +0000
Received: from BL1PR11MB5494.namprd11.prod.outlook.com
 ([fe80::c656:4ebf:dde7:be4e]) by BL1PR11MB5494.namprd11.prod.outlook.com
 ([fe80::c656:4ebf:dde7:be4e%5]) with mapi id 15.20.7362.019; Mon, 4 Mar 2024
 11:10:46 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH v4 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Topic: [PATCH v4 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Index: AQHaalR9StzovMarUEC10fvX40lRFLEjlCQAgAOiZ0A=
Date: Mon, 4 Mar 2024 11:10:46 +0000
Message-ID: <BL1PR11MB549484AC60C56912F260933488232@BL1PR11MB5494.namprd11.prod.outlook.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
	<20240228143402.89219-11-xin.zeng@intel.com>
 <20240301165848.37cfffaf.alex.williamson@redhat.com>
In-Reply-To: <20240301165848.37cfffaf.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5494:EE_|LV8PR11MB8698:EE_
x-ms-office365-filtering-correlation-id: 4fae25e0-6129-40af-a2df-08dc3c3bbdbf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3vaILOr6ixdJK6wOriv7WG9PtB4JohkUV2SKo+y8TcpQChabVo9qy+97i45Wo5KiVBebNJXHOSkWDQlwbonYESGZb0Va0pq6NxvxI+fHYqQVCK8NxUenwseQHjPWZVTJRtD/o5tAnLl//iPr+IXmTGo7rz0g22/nuBJ8uWeQ84zX9zfR0Nhnd0vQ7GWc47YTINxXLaKoqBqA5aiekGknPAMQa9VNbIXmvDwFZTZ2dfB9s18LX+fsM2FNf5JeB+MUnoQELUHAK72J9bla0w9wzOsQ61U+eGRO8xnUj941wCHfervGhVJrXMWM+1syT/PsUtYjM5JQg5QmTAt4xEYfuhI6x4wOkBekXutgiWmroI2LgzxN00P5EhamNvC4/jNuNZb24DvYilQQ9qWj/MpYkigoV7K2qoewfxoOiuk+OSm9Cu431vd8PLY0zsGqTqg+Q35B0EU7vf/151Rv3DfFeYCyNo4fhvgoLvoQTGUpS/mgM+M21PMrrS244XU179zpx0UolSHtMHQnIdlnKb2cOcDObWqom2091iqiTyM8djldK7qe+hqu9psBUs2CdOoPE5rKFwMSUMhMpdGsnf61LKV3WQJBaLiIkjpw8QjQfxaBwXSYjacgFm97I/UC8dqh0JUDJsi+GrqLM3CnQUOGf6xJbuK9qYokLTqOtLN96TuiPlbyj26Gh4EWrl4+hHU7d9HzRzZZRlrwIxM8/q1lSHoHBJm40Vhl22GosNpWbzs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5494.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WYNAo6xVUUn6ayhqOKcsEtyLaYOB4p24rUuxSiReq+fb1v7rzzCuSr+L8yss?=
 =?us-ascii?Q?GuHJE8E6WQZ2TMc9rpjr1ZR+5YTBGybJ4mNPVIfwIN1BUfe3Vl0AQdg7Tizg?=
 =?us-ascii?Q?iFfMPv5bnrNgVYdj8J8Yb8u8tgB3iYzcaAURHRYUg2020XbRdJE3XwmxsAD4?=
 =?us-ascii?Q?1yzgqNuZJl4d6KkaFKHphd2Mf8Zfd97PCOFsLSb03PepF4hakTpQpZkgC1j5?=
 =?us-ascii?Q?R1zwnvPLhYfZ9GjOihodDzSigqX1WMTzghV11B+InKuH5p9cX9i6mmnCKMa6?=
 =?us-ascii?Q?S05HdXBFF1XMVoNaRtpQqvGDP9czJ7U5GbRx9nPiHOSAA5SpJEFAxqAC8Ty0?=
 =?us-ascii?Q?2hCbWQWx+EdVMzUSb8d0uUtZEFoQoE51dTG6Bnv3cPF8ZmXe9D50rnsn7ZZx?=
 =?us-ascii?Q?+EAD6780j/n6DGGuuigo9iAGpJ/TnRB93Pp7kznL8Br1so+T5TbnFerIZIRO?=
 =?us-ascii?Q?ARoQYU+ozxJA766jR8B/jGhiElHPvniOJViLuvM9UUTpNpx6h2vF3VdvTvdS?=
 =?us-ascii?Q?IdvTkurjCsUv6cV6d9GaJuVbN1j9o6MD303dX+fJgADX91FI+RJ593zw3Ev0?=
 =?us-ascii?Q?rsXUTTTkIWzmMbfkeZnmFFP/VJ+lfT9yNUtmIHfdr3ono2jAB+9GfR0wsdyD?=
 =?us-ascii?Q?ZeAuv9HdJEYGvy/l5p6U5Mqaa5owSH3zGw0sSK963kOZdw9MrFaDdXVYNmrF?=
 =?us-ascii?Q?CdmuKiQwX1krlgnSwiQcl6tS6LdbuAgD56CyXGgd6tyYZVBK9Inr4Js25P0X?=
 =?us-ascii?Q?rqxl4/uNSNKmroxB4vvJBoCM1je70vPbgnhW6ZPvLHkrCaVEhxYlMPN0trRA?=
 =?us-ascii?Q?oBeqKOxu8pHLoG56x3+8XDsovJmDcowmkjwxuLJQAY0VeRjhrUxXXDzs7eqS?=
 =?us-ascii?Q?Pxdc4ST4NQnYL+TdaTevyznta1+jPBkrR56gBqztnbNFxMDO6zRcgzwNGxBr?=
 =?us-ascii?Q?gGYU+MD465wRtke/e5WkvfDAp9z2pq8nNnDsWoH/xSbf0xQHjBPB7O10RZBs?=
 =?us-ascii?Q?gldSMtfZqk8zM4D+vbuHwm5drszGmwXMFjn/jzdFKtwlWs+v0xtcgzrRO+P1?=
 =?us-ascii?Q?lP5C95P31/4QwT+DBAVTFedqSgmws0pu5NCh3U7cJtQNt7ltjns3d/s2+txk?=
 =?us-ascii?Q?1VgI1DKMVlGz73x2N3829uo8zx7R75NRXFOGFq+dPsvhI/1PZH9KpZv0nTcg?=
 =?us-ascii?Q?EgIFLGP7eZ56/WZhEssW399WF5WZLNfp2tTMBdNLBxk5sOZQpXw29UN+78O8?=
 =?us-ascii?Q?haTsHSGvL6SXjjo2mkl0qKX2koSe7dxQC8cD6BWnrkCR9CgkPxGtCeqgYJ9M?=
 =?us-ascii?Q?uhmM5qZyhghVDhh6SA90Cm6iDHaGsaAwnmEtl7h95+3+xq+jAc/dU68KG4s3?=
 =?us-ascii?Q?jmluRWhUl6yQa+tjREaCAcYdiDkjU2d8/YfbOh7vnQ3k4ffEw52aZZDXRxkO?=
 =?us-ascii?Q?SDQxmNr2CU+Ib2MgrVXtrkkHijcaRxXPD68mLZetNf2NIy0Hxhn+1qZ890gk?=
 =?us-ascii?Q?dgse2ud3acRkNWFCZawVWmF6jRl+6Vo5SLBw+SOwFz37R/4POO/1xcyuw6Pg?=
 =?us-ascii?Q?uccp6b/1f+FudGlxATk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5494.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fae25e0-6129-40af-a2df-08dc3c3bbdbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2024 11:10:46.3777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8YyewXF4NrmkEcBSf0kt80sxp47tR9hc8V3fshyR/izIu4v6bNySZmeoH9omZObHUNF+6binTq2mZM5QmOSypA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8698
X-OriginatorOrg: intel.com

On Saturday, March 2, 2024 7:59 AM, Alex Williamson <alex.williamson@redhat=
.com> wrote:
> On Wed, 28 Feb 2024 22:34:02 +0800
> Xin Zeng <xin.zeng@intel.com> wrote:
> > +static int
> > +qat_vf_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id
> *id)
> > +{
> > +	struct device *dev =3D &pdev->dev;
> > +	struct qat_vf_core_device *qat_vdev;
> > +	int ret;
> > +
> > +	if (!pci_match_id(id, pdev)) {
> > +		pci_err(pdev, "Incompatible device, disallowing
> driver_override\n");
> > +		return -ENODEV;
> > +	}
>=20
> I think the question of whether this is the right thing to do is still
> up for debate, but as noted in the thread where I raised the question,
> this mechanism doesn't actually work.
>=20
> The probe callback is passed the matching ID from the set of dynamic
> IDs added via new_id, the driver id_table, or pci_device_id_any for a
> strictly driver_override match.  Any of those would satisfy
> pci_match_id().
>=20
> If we wanted the probe function to exclusively match devices in the
> id_table, we should call this as:
>=20
> 	if (!pci_match_id(qat_vf_vfio_pci_table, pdev))...
>=20
> If we wanted to still allow dynamic IDs, the test might be more like:
>=20
> 	if (id =3D=3D &pci_device_id_any)...
>=20
> Allowing dynamic IDs but failing driver_override requires a slightly
> more sophisticated user, but is inconsistent.  Do we have any
> consensus on this?  Thanks,
>=20

As migration support is required to be reported at probe time in the
variant driver, and migration support is device specific, the variant
driver should be considered as device specific driver, not a general
purpose vfio-pci stand-in.
From this point of view, maybe it's not necessary to allow dynamic id
arbitrarily, matching devices in the id_table provided by the variant
driver exclusively would be the preference. If this sound good to you,
I'll update the implementation (to use the correct id table)  in next
version.
Thanks,
Xin


