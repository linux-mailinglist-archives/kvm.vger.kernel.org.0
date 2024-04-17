Return-Path: <kvm+bounces-14946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 538CB8A7F94
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 11:25:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 772191C20F19
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A53130482;
	Wed, 17 Apr 2024 09:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YKSFyRbf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E9312DD87
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 09:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713345912; cv=fail; b=MqyhtMkS4gk/L3D/qwHDrK2DFuHsZgHoIGsBejS3TE3Mzzt1EgU2UrblPIC91wA+rpobROKOSVRWet0QD9Ow0m2wSkXgrzJavaO7vEUyYHYKLHT3jk2nb3oazVy0zSBFUL3yvseQba3pHL6WdFaPh23ydDwhtrOEzflOzl7jD38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713345912; c=relaxed/simple;
	bh=WmjZK7A1bvODM7F5FBqQKHyvtOpBBYLe0N5BpXr+7yk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lzklzYWza4mkZf2MQPpPz6l+JPm04VlBnImTfqAYVB8ICA9EwdozKog1vMRIh30+Dp5LEW2aLUWMJnq4Tlnkh4gF4O9Idons90iipxGDzSWWTy8sjmGRkAxUXeJtxCAP3Vgm9mPAf547v+6VmVuiFljiNJh9d6vIlqNxwHxzGa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YKSFyRbf; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713345911; x=1744881911;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WmjZK7A1bvODM7F5FBqQKHyvtOpBBYLe0N5BpXr+7yk=;
  b=YKSFyRbfOtl4SyZ+ehbd4HGHCLOgdssSVm+dpbKYoHQgDPMzk14YDS8n
   hULLpqXU40MpGMerLaJ9QeP7lzeh1qnwXSSU9SiY0naQriFliE0hniBue
   2dPbp7YECUavM1FsTLSxrOXTEccgNuhkp1X+H8EdkiHarE/bFR/GlQtGc
   bHZfgctbGTi6eMh1VlrQnJGHlWxpaHhDD6iZlwg1+lxfEnBSMtHfD672j
   c4gnE1tm8ouGdCkF+nnzeSZQ1HaevhNJJseO29EANguNdEM7K4dcWhWTk
   ALfnFNrLJoRk5u/0vcGreZ+iwMYURNhHvlsuhuUQUVw7L2nNowD4GNTjd
   Q==;
X-CSE-ConnectionGUID: ZmaP4qzuQKuav+gGrc0yIA==
X-CSE-MsgGUID: ZBWl0CtNT5WRj8FI+9UPIA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="11770354"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="11770354"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 02:25:10 -0700
X-CSE-ConnectionGUID: dsFwFH+ORKGOTb2w4V541Q==
X-CSE-MsgGUID: I9oMzBwRR2Ga2W7Ar9/Hig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="53525328"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 02:25:10 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 02:25:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 02:25:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 02:25:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 02:25:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgGwkkA2fnm8pEPBuHFpzqpKaGUgWroEfYN3d7hVRd37QKC4+ADEk+pdsfMdhAl4uMU8rEPZFIc5vJpMmg8I2WhCuJMDIIP5WUo8LUuwzXu9Skfo8vv+6jJqrLCNhKu0uCjQ+HWWvyyA6Vx0Bj5yYHlQNGCLC0cFnxJDjficVWqk2cQjTDxC1gx/1IAFnBIRnWFVBsFKjZpg3mFuB7aAgEQyzzbd8XkmZB9DGjNv/L45U1r9TgnrVJXxsf3pn4BsutmtshuqR02aokh0Sh6Z9YwEBQW/aoBDooUphKvH/d8C2Qm6tc6gHYRts7sphTDiLXnH9POGhXg5ynrjA7FNhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGFZcxBvyWJb2vg7FANw8beVTnSTZs4yIgdszK3jI/o=;
 b=dEn1THU/djfI+veeDljYpoVTe17ksalmwG5uPTHHwFG3RL/Td4nboL1WC+1bSjVHCMgscckPjrqaMmJ72NMUlrrZ087+SD6n+ZCg2fiHt6n1ugbplSRT2Wb2jtJP3zc88MDaQFI5RacinaEPgZs/WjO9vPxrfG0WAdV8c7DOhJqY5OIheJ3abirxkaQlWb/tv/mrI024+heIXEyqBfKLAhrpha1kd+YWAccYv1YxsRuGv47IXPYTlSza9s9FMsqGQYON2nqIZn2atFmY8ACIP4K0yPDvooMIfMeMbAdJhnDwpYMdZgmxU5eCebjDixfLMqj+Hb5T6Ue0FFSEBzPYCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5956.namprd11.prod.outlook.com (2603:10b6:208:387::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.27; Wed, 17 Apr
 2024 09:25:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Wed, 17 Apr 2024
 09:25:07 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Thread-Topic: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Thread-Index: AQHajLGk+C2pq6NVG0WVhgTxEUELM7FsOFog
Date: Wed, 17 Apr 2024 09:25:07 +0000
Message-ID: <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-13-yi.l.liu@intel.com>
In-Reply-To: <20240412081516.31168-13-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5956:EE_
x-ms-office365-filtering-correlation-id: e38b8f72-6b7a-49e0-d537-08dc5ec04590
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cThtgJPh/l2L3T/nx5V0oiIqsQXlJHV8XlIrxKBGkqB0050XO6poaWvo+5PzKB2hacMNaGUDJcZxj+NlMiBauHd6wi6p0cXRBXZcXB077dQRlUZlcWbcfXXSOYXiClofzoia7eUDzyXPNGSnrOW06JD/BQAIgPx1QDDU8RkeVBhhRhCPG6H4Jy1MIFmRttZH6vYx7mZtzTEK7fGKce3roMzqgn9izLbGV9/lAyHIs0+2kbK8eK/YlXlBPYNBBZWLEWoalhC7qJRjWhowPcdB7PtATmgZ7lSmDmgA5NPF08fdNC5qFBANxedxzAVf4vwJKPK5pZXAT9N5sLDg4qrD73HOVSg+AG1uZgsoFsHB7zRYtoE0bcljBLszvIRns7VcdBOIeFY+uzZwNqiYOEZIpNUQlVmv9VP0vrSHRqfAHIvU0ELtxI33I4lbn+5+b30hl0jNMYW856Jk/7pMat3e/YS50MQRrxVRwPcQdwY/WxLolSRstmfbN9zYO1vw8KnH1cp6W7+ZqHw6JvNjt99ayouikAUArwjtf3VeNFJH0vwM49NzyANiTaGUbsKRvi9g7ntTg0hteefPfiwPlcjx7c/Nqv2ITfwNaubXqseqcvGavw5LkmKlmX8092fY0/aObMQ86OHAvN5hurSK6G4S8Lrb2nNLeLYTzQlYMHd6KMF2pBCnj/ImqK9QuUP+69WOUOYpbvlvy0C6r1Th/jnKyVteFkgqKr/JjbKx/0KubQk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?46wSHiwjzzAPb7iIlB0MGO3obJ69O0cKnurimNCosG0psnooIs9/eNY3mhdG?=
 =?us-ascii?Q?2Q6h1lOi3f506EDHnY40EzA85KU0ezQ1gCCdNZB7dnNs8znEER1ovBdVRCpd?=
 =?us-ascii?Q?tgnHLojBpy0xllSeEMvXSGJuoh2vq8dAP8G5PHqpL2R4xCyrpqbfGBn81q5W?=
 =?us-ascii?Q?9S8IAI7m16DznQwN69QEmg5PjWxM3dj0V60kqLFtKq3nw0s4/TPZENkx304n?=
 =?us-ascii?Q?+k6FH4+qGjwbZap4bUpw6Ngjw1/++QbOfQtnqkWpr1xkFd8NeMAbYl62iQLJ?=
 =?us-ascii?Q?oVmEAwtliMH4FGQ9V7lLlb6CHNWRo5XjfcqNv/u8u2WuzM73OYO0kofRZb9P?=
 =?us-ascii?Q?dIeSFR9XJFH5QogcUbITrF1xYTgWTFmDJvQ7bNuRjTJNNP0OtzkDeobbbBEY?=
 =?us-ascii?Q?HVnKt3cZKIvP1RHmHsm/iFmSDEBQ4be5uI8fIXV6+wMY7vmu0R0ZT/aEMucc?=
 =?us-ascii?Q?8bjeYcENK8M7995IQ7CRBWQNSkg3/nZZQ0fpkIDDxKERvY7detkbJyXumX5Z?=
 =?us-ascii?Q?SDf/UFmTwBQpeTZrmKNydldXfY3nAmTLN99saAwWvRPi6TvaSUp39Yai4WD6?=
 =?us-ascii?Q?QIWhrVCESDlxBA/7nih+XVhHQLYlkYJXT96XV1tB1dHlAujoyy54qCkgTauf?=
 =?us-ascii?Q?cRL4ZiaOqTsH0LwMLzRj/LLXvYb03hKuiX4mj2c58LS8SkSfzSceGRLjopr5?=
 =?us-ascii?Q?A5lmy8qvhOuVUeWsgmSXqu8pHInZcmmWFjtwQbgz+6/TJtaHCPGv1vOM8geH?=
 =?us-ascii?Q?5UI0RHQd3rEyIkX3Eo5bVUh6Gjc6XXbxlMqRTjDtjmV5Dr1FKM+gBI7YUExV?=
 =?us-ascii?Q?SERYDSwNuN8itoJEt0y94LeWeGIsFOkOfxQckQsEnZDReei/Gmhnom+L+vHB?=
 =?us-ascii?Q?uFF3zhe8DunryY8GsaBRHgRL4knJY9G26R2sf/FtyQJE7Plj24CLDFhWLOni?=
 =?us-ascii?Q?yhHIwSGKwzQccK4Evaadk23WQv2TpAz18AXRejol51B7+luR1jZhVUmXqpZh?=
 =?us-ascii?Q?IghZWgRJ+cWFvAPU5VPPeMHJTTu/Sj9lLm1kQ+MCpx3CF9i3ZHv08V3YODzl?=
 =?us-ascii?Q?7f4FT3EXyjP8gkF0C4vnYqK4ITloHCNEBDvtnHGDS/PM9Ab95OwFKbGy4uid?=
 =?us-ascii?Q?GdaPNPvcfTcPwtiHFgJJZMQAVE1qtvTKl7EZhDFs9Np/xS+ug2FhR106Wtey?=
 =?us-ascii?Q?fv5NRu1iatoOy5b/minXqr0cgFqA1ceahOclr+CByCB5sGzehfx3Whb69kXB?=
 =?us-ascii?Q?ropmp88pGaM9LuL1RodU7JlRCdhRbSgfF61MmgRLyUFL17UjU+Zp+LVpzdSG?=
 =?us-ascii?Q?IygPUYAuwCsHE0l+wG/lm+W0zJenGKV+c+wsbo81sPmRONHBHzirET05KAMj?=
 =?us-ascii?Q?SdOzJrdHa4YU7wAxIsMO54w+I2XWlA0VTO0sfyG2Y38XWMWwwHZdG6luX2OF?=
 =?us-ascii?Q?Sm3jPqmAIlWM0VkdkHMhOVrocKcvvn669TzclxVuY+ceNrSSOB8oSt5iLKFh?=
 =?us-ascii?Q?7jd5bom88iFj5SM6B1kpQdE6QJ70jLo2z9UKXrCf/CEDHnA3xyR6cwuQgBub?=
 =?us-ascii?Q?AE9yAhLU2OAodPg7JU3Nnx5pynSx+eLe8UYAA0+F?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e38b8f72-6b7a-49e0-d537-08dc5ec04590
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 09:25:07.3376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PUcnnxV6mp306ds8D+VdaWtzD84N6+6pI7TNwigR0CJvILU8/tTGVJW/GqtWznxf803LjZ+3LX/oIVSzRBBIfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5956
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, April 12, 2024 4:15 PM
>=20
> From: Lu Baolu <baolu.lu@linux.intel.com>
>=20
> This allows the upper layers to set a nested type domain to a PASID of a
> device if the PASID feature is supported by the IOMMU hardware.
>=20
> The set_dev_pasid callback for non-nested domain has already be there, so
> this only needs to add it for nested domains. Note that the S2 domain wit=
h
> dirty tracking capability is not supported yet as no user for now.

S2 domain does support dirty tracking. Do you mean the specific
check in intel_iommu_set_dev_pasid() i.e. pasid-granular dirty
tracking is not supported yet?

> +static int intel_nested_set_dev_pasid(struct iommu_domain *domain,
> +				      struct device *dev, ioasid_t pasid,
> +				      struct iommu_domain *old)
> +{
> +	struct device_domain_info *info =3D dev_iommu_priv_get(dev);
> +	struct dmar_domain *dmar_domain =3D to_dmar_domain(domain);
> +	struct intel_iommu *iommu =3D info->iommu;
> +
> +	if (iommu->agaw < dmar_domain->s2_domain->agaw)
> +		return -EINVAL;
> +

this check is covered by prepare_domain_attach_device() already.

