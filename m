Return-Path: <kvm+bounces-8979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E903C8593C2
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 02:00:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C5082820B7
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 01:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714E315C0;
	Sun, 18 Feb 2024 01:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I9u7+7aq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8BEA29;
	Sun, 18 Feb 2024 01:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708218029; cv=fail; b=qoc7PFl+nF+nppyW74375+Psh1jvySVm1rUIpYApVv5ufQV8BmhGJFsM0tzj/qUlhLmQmz4UG/51l/ukBCXqplHza/CHpHyMTjJ++fXE3MSNahfm6APJuk8naHMp+xXyQtCmOZYJ1wM4pKcKBtpNqOYWmfo8S8V/GVzLuTS/Y5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708218029; c=relaxed/simple;
	bh=cx/nMuTWFl7InBd3LIhXtx3Yt69eNnlnnDTkrVgo2TQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jkI0jqUjUibp1wT3STFWtD9MOg7ouKeIbSeIK1hZzDrYy55wJIUMH4xJuwY9eCPPQJEudSsRU1TWRAvVF7suvBZolZlkInbTUAJCcs1Oywk5iT95dIPFWQN30wDStY48ZyZPl7P6PhpB6zNy0hwVT9Kn6gyubEmO1ViGTgO0xzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I9u7+7aq; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708218028; x=1739754028;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cx/nMuTWFl7InBd3LIhXtx3Yt69eNnlnnDTkrVgo2TQ=;
  b=I9u7+7aq+80hoC6Px/2jn9HIWWa3FieYNDa94hbQ1Xf7ZNvVD4xtN0zs
   T2dzY0KJELEpfU50S/OkH4L4w980HQ3K4kc1EEsjCLsZ6v2Vtvu6KYE+I
   hLlJZbu6ajEnbXTCWo2Ub2aKtfCAScD0/2DRCUiLBeqLcgxNDjoykCXFC
   8kctFMtV90R8q9cY45pAgLO1NU83p9dHfHQu0sgmV5IOuQ0xSeNke/7A4
   cZdgGVhyNOkqXqzi830DCJlMjbtXmQMQD8/6tUbymwSxCm2F4yibNCi+g
   H+R1zGL7jD9LQ9YStP3YzA7kDC5dWuIf4nJ1L+M/6gvCSl6Z6TN4A62Ae
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10987"; a="13428534"
X-IronPort-AV: E=Sophos;i="6.06,167,1705392000"; 
   d="scan'208";a="13428534"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2024 17:00:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,167,1705392000"; 
   d="scan'208";a="8839482"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Feb 2024 17:00:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 17 Feb 2024 17:00:25 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sat, 17 Feb 2024 17:00:25 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 17 Feb 2024 17:00:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0cLcAurUAbqACQGk4YpYVts34fyKLTq3KUrXg4QoS7ODGTmhZhMYgNRltfi9NmxgvVgvzJ6JX2gIrxaISehwRlTHTJ8+oyMUUURDmAHmVAlLOn/kBoOtDIxrK5FLFZuY3MI8IEgYhRwY3WWs4eQFpKAP0BGxw07uHAHhehFW0Sj6qqXXPLoxXADZ0j7Za9UZcmOBas26tq3Hc98V+jKE3dev0HbvUuzpIpFXclM+sf4s8rjYdmplVPl5ScTDuikbGSk7XiKBFPZxzsuDHdoU5bOP46SiYpO6Zw1zOHolQRCCgf+j3wuMeHhzJTP/i2OROt6jvqm1h/skHOX5DYr9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvWqNqv9J2VyLTX+J8t6RF+YFRwkIH+eI3FZ9V/22CA=;
 b=NEuLu2Zs+1cGXL7NOBeg1qVbJscrVupCUt7OFThNmpr7P7Q/jAjDhpZllV4cQ7YDM7v+1JUXYfOQV/8R3m6cUvXf3V50DeY5aUqw2HdB287L93DyWawrEn7o4mZkHiLToYor2uPA4HozE4PZGGnE363AigxAHxew6oNlOYQCDuXNliVbjNhOH+73lqtPcFaW5NkSui/WWKcqAnM3jPNXQiio/L/HgDeyVcAsSf+Urrb4aurNVwxGMV3pboBtk3eaPpRM2z8Ipe+sRVRaaT7RUUAefWozXqt7lCDoE10PFgL9aFLitro6DqDaFhFPFv3EaYPMN+NcOZWiPUVEZTd0jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7375.namprd11.prod.outlook.com (2603:10b6:8:101::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.31; Sun, 18 Feb
 2024 01:00:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::bc62:d78b:f7d4:3917]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::bc62:d78b:f7d4:3917%5]) with mapi id 15.20.7292.033; Sun, 18 Feb 2024
 01:00:23 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "ankita@nvidia.com" <ankita@nvidia.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "mst@redhat.com" <mst@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
	"clg@redhat.com" <clg@redhat.com>, "K V P, Satyanarayana"
	<satyanarayana.k.v.p@intel.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "horms@kernel.org" <horms@kernel.org>,
	"shannon.nelson@amd.com" <shannon.nelson@amd.com>
CC: "aniketa@nvidia.com" <aniketa@nvidia.com>, "cjia@nvidia.com"
	<cjia@nvidia.com>, "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	"targupta@nvidia.com" <targupta@nvidia.com>, "vsethi@nvidia.com"
	<vsethi@nvidia.com>, "Currid, Andy" <acurrid@nvidia.com>,
	"apopple@nvidia.com" <apopple@nvidia.com>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "danw@nvidia.com" <danw@nvidia.com>,
	"anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>, "mochs@nvidia.com"
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH v18 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v18 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaYISYdCMnkFQa2kyZb3lTo7TENbEPSnAQ
Date: Sun, 18 Feb 2024 01:00:23 +0000
Message-ID: <BN9PR11MB5276CF18ADF0B687429118918C522@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240216030128.29154-1-ankita@nvidia.com>
 <20240216030128.29154-4-ankita@nvidia.com>
In-Reply-To: <20240216030128.29154-4-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7375:EE_
x-ms-office365-filtering-correlation-id: af3834b1-590c-4bf5-0f58-08dc301cfca8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rm4o5DCoGPzWav44kR5jnFYpDzLS3i4sqBosz7n64CYh+fos4jQKPpNxzRkzDp2SqkULOE8QuvkZWvNlldc3gmIS3sbo6UVJ2ME0a/rNOQjRql0glhLp5EcElH78/px7QjAwiArYe7m9oSZhgpQcmuBAZBXsl9cNzsDEmv8J5lbd/lHzoAE9gh3gwT06AzTW8s8N5NVRO9V0Bp13blC1awSWCUrIjsvfgcQiF/oem/2N04IfM5SZlRAvKFhfG9LdetwPRqjVohyYkdnax6y1KohMUTTl1PiQJl30Iheg4kyXTljR/5T4RbLZ8OaL2AOyKxklDEQgzb7CL0EXgrtadA3mBIl9g98Egh1v7NNTMajupkMvbFsII49p8QpjZvXzgM4D/+yEhUOScC8gGtqzAcM67uBqgZEOe+fqFwvs/9PfHQSHK2CJIXXeKnzvaWhcInGXRG+1BBUtRJwDmDu8sDD2en2Tnobo41SxCGhJvXXy2AR5lQUeaVp37L8+XgPbNJ+of+swtObCvmSn5G6rbTY1dW6gQ/KG2+Vj18SOpfUGroFIClrgbYlTuvvkQGnJejchXbdZ3ygFA40EU3eTHD+L1IqW5FvKHPej9VGhfW3BfuUTeHuRWyd2doEhHcHT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(136003)(366004)(346002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(8676002)(66446008)(5660300002)(2906002)(52536014)(55016003)(66946007)(76116006)(7416002)(66556008)(8936002)(4326008)(66476007)(64756008)(86362001)(122000001)(82960400001)(33656002)(921011)(38070700009)(83380400001)(966005)(26005)(71200400001)(7696005)(316002)(54906003)(478600001)(41300700001)(110136005)(6506007)(9686003)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?37YT8FVPjEHewXhJ8fnlfenLvCVQHtyZgFodFeKoBjrxdHNvjZWpwGL9eDp/?=
 =?us-ascii?Q?x0DvBE7iztzMMo5Ilr6bG2oAQatyalJ/gr+9ZkU/WRDGsFUOQuBnnbXynGUh?=
 =?us-ascii?Q?BbgJYEvd5T4PWZ6ASYm4Hc2liDCaTfxOn1We7ZKOpQuHV064r3Cxomaxv5dF?=
 =?us-ascii?Q?Dt1xCs86PQ4X2Xzkv6I09KxUMJKYEa84kdr8xq/de5Csd52ezIEJXJAnhG/c?=
 =?us-ascii?Q?Q8MuESHRpt6+gBxItVsRPFY3NYP/VbqGRGZ5zo+dGMCaYyHvBlEscvsPQkdv?=
 =?us-ascii?Q?aVOX4FUuocguXhYacetHjk+sFdSG9z0QTdCAJe+70fmQhZfYigCZzpWov5tf?=
 =?us-ascii?Q?ZoYvC0Sqta/dhURRwCtLSgY/PAxclv/7257+4/bV/CKQmQbCxB4UuYJh8mcx?=
 =?us-ascii?Q?H3jcuGyXbpe/v6mwt0lCLE454sidmmtPyPg3wpDECrfaBR6UO/jxwyCUwf/X?=
 =?us-ascii?Q?23ar/2Clqq2BfFbE07yvfGn7RZWz9GfWPeP/4iWSWVI7shh0l43MNNUDx843?=
 =?us-ascii?Q?Ejb3C3Yv7aCu2FRm5oGDh2fI2da/RB6ItlzfZl4WISQ9llxwmmlqR4uyM3B1?=
 =?us-ascii?Q?1/kihEdo/6VvrfqzDLStgl6TehwtOS8KVR1VlyE2QFxnkNltobwHKHoVYdnB?=
 =?us-ascii?Q?hDhVocZ4hKf/+b2Nwp/hGOgS6VIEV20fNFVzVHZnxtgEyRAaIxvcS9brkw10?=
 =?us-ascii?Q?J9hwejb0OJ1uKzyfXs75CtyJSshWmzCCV0AxYNmedzVwXVty1iArWJxHDkpl?=
 =?us-ascii?Q?mnikh/lgEH9FaW1VgmYO8GUOnteYbZdhX2m9s9t1+lVku8rIk4vDIYlpuiV5?=
 =?us-ascii?Q?yDGvQOmwV7UYjo4Rq36O2YiQJBS8qJOvRdIeF20KosVH33Wkr33d549yuC/o?=
 =?us-ascii?Q?yRKSixTWmah6g418NaSs2F+EjGmVXmMbF9FVlAcvGKhmm1JIawFe97NkNjLl?=
 =?us-ascii?Q?hLvth50cI6lWKvGKoX4E4v76FDS6itH1IPPgxkHHMlMuE9513IvYwPKtkO6W?=
 =?us-ascii?Q?lAwuLcQD2TEYQi8RF8D2vE0aB3k/1gjWOKnvf+J4AAyAibmrgHBTbN/9hVUp?=
 =?us-ascii?Q?L2k/jfcnBJclhkymithtBHeouXre1AQRp4NojYi6Dn6tEHYD0pWCNaqWDQ6Z?=
 =?us-ascii?Q?u/iIqIOSI9VevMlXwYS/qbvoXImWVkgbm51TUZrP4O/LN5Pn5rEfepwiAtI2?=
 =?us-ascii?Q?NYRUItNXpCCZhFiYi7Dm24xIoeUJuFyvf44cid+Dz3NiATbApjakbZFNBrlZ?=
 =?us-ascii?Q?Gk0fXn2ICn7VQi61nYTdUkj/wFULNhYxHxoiPPsBlsZLFEanKXv1QPFQbZY2?=
 =?us-ascii?Q?LNOtzXHxzyUJ199WDI23HZd/rdWpNujw35bFPSv4hE8viJJHS8r6aeH2DkmJ?=
 =?us-ascii?Q?OK6A7iXaM0yXgON7nkhOq+LC5jH7X1RT4wzOwzuSWQj7qR+kJdtJPMIzVf1c?=
 =?us-ascii?Q?ODjQFrpRNQk3II3uTt3kfhXaUM53jPpHbsxOABFgjZagIZoTjoIklzqz+rAd?=
 =?us-ascii?Q?skE1rBTNIWFC8hqqkl6r/TYqRT81ZZGkMRdh0/LTs7oZjVwrCflarpsaN+/V?=
 =?us-ascii?Q?4bRa6FEXuQAh9u+WJ/+AJ03pDlwYpsC/OzXZDnn7?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: af3834b1-590c-4bf5-0f58-08dc301cfca8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2024 01:00:23.5742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IoCUCYzttpyPFYgFK8drNC7il30D/H8NebV40uH7UZXgK4Vs2k5J0CPDqC1mSRqDkYMOHF8C5EKjN2WD63kLAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7375
X-OriginatorOrg: intel.com

> From: ankita@nvidia.com <ankita@nvidia.com>
> Sent: Friday, February 16, 2024 11:01 AM
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> for the on-chip GPU that is the logical OS representation of the
> internal proprietary chip-to-chip cache coherent interconnect.
>=20
> The device is peculiar compared to a real PCI device in that whilst
> there is a real 64b PCI BAR1 (comprising region 2 & region 3) on the
> device, it is not used to access device memory once the faster
> chip-to-chip interconnect is initialized (occurs at the time of host
> system boot). The device memory is accessed instead using the chip-to-chi=
p
> interconnect that is exposed as a contiguous physically addressable
> region on the host. This device memory aperture can be obtained from host
> ACPI table using device_property_read_u64(), according to the FW
> specification. Since the device memory is cache coherent with the CPU,
> it can be mmap into the user VMA with a cacheable mapping using
> remap_pfn_range() and used like a regular RAM. The device memory
> is not added to the host kernel, but mapped directly as this reduces
> memory wastage due to struct pages.
>=20
> There is also a requirement of a minimum reserved 1G uncached region
> (termed as resmem) to support the Multi-Instance GPU (MIG) feature [1].
> This is to work around a HW defect. Based on [2], the requisite propertie=
s
> (uncached, unaligned access) can be achieved through a VM mapping (S1)
> of NORMAL_NC and host (S2) mapping with MemAttr[2:0]=3D0b101. To provide
> a different non-cached property to the reserved 1G region, it needs to
> be carved out from the device memory and mapped as a separate region
> in Qemu VMA with pgprot_writecombine(). pgprot_writecombine() sets the
> Qemu VMA page properties (pgprot) as NORMAL_NC.
>=20
> Provide a VFIO PCI variant driver that adapts the unique device memory
> representation into a more standard PCI representation facing userspace.
>=20
> The variant driver exposes these two regions - the non-cached reserved
> (resmem) and the cached rest of the device memory (termed as usemem) as
> separate VFIO 64b BAR regions. This is divergent from the baremetal
> approach, where the device memory is exposed as a device memory region.
> The decision for a different approach was taken in view of the fact that
> it would necessiate additional code in Qemu to discover and insert those
> regions in the VM IPA, along with the additional VM ACPI DSDT changes to
> communicate the device memory region IPA to the VM workloads. Moreover,
> this behavior would have to be added to a variety of emulators (beyond
> top of tree Qemu) out there desiring grace hopper support.
>=20
> Since the device implements 64-bit BAR0, the VFIO PCI variant driver
> maps the uncached carved out region to the next available PCI BAR (i.e.
> comprising of region 2 and 3). The cached device memory aperture is
> assigned BAR region 4 and 5. Qemu will then naturally generate a PCI
> device in the VM with the uncached aperture reported as BAR2 region,
> the cacheable as BAR4. The variant driver provides emulation for these
> fake BARs' PCI config space offset registers.
>=20
> The hardware ensures that the system does not crash when the memory
> is accessed with the memory enable turned off. It synthesis ~0 reads
> and dropped writes on such access. So there is no need to support the
> disablement/enablement of BAR through PCI_COMMAND config space
> register.
>=20
> The memory layout on the host looks like the following:
>                devmem (memlength)
> |--------------------------------------------------|
> |-------------cached------------------------|--NC--|
> |                                           |
> usemem.memphys                              resmem.memphys
>=20
> PCI BARs need to be aligned to the power-of-2, but the actual memory on t=
he
> device may not. A read or write access to the physical address from the
> last device PFN up to the next power-of-2 aligned physical address
> results in reading ~0 and dropped writes. Note that the GPU device
> driver [6] is capable of knowing the exact device memory size through
> separate means. The device memory size is primarily kept in the system
> ACPI tables for use by the VFIO PCI variant module.
>=20
> Note that the usemem memory is added by the VM Nvidia device driver [5]
> to the VM kernel as memblocks. Hence make the usable memory size
> memblock
> (MEMBLK_SIZE) aligned. This is a hardwired ABI value between the GPU FW
> and
> VFIO driver. The VM device driver make use of the same value for its
> calculation to determine USEMEM size.
>=20
> Currently there is no provision in KVM for a S2 mapping with
> MemAttr[2:0]=3D0b101, but there is an ongoing effort to provide the same =
[3].
> As previously mentioned, resmem is mapped pgprot_writecombine(), that
> sets the Qemu VMA page properties (pgprot) as NORMAL_NC. Using the
> proposed changes in [3] and [4], KVM marks the region with
> MemAttr[2:0]=3D0b101 in S2.
>=20
> If the device memory properties are not present, the driver registers the
> vfio-pci-core function pointers. Since there are no ACPI memory propertie=
s
> generated for the VM, the variant driver inside the VM will only use
> the vfio-pci-core ops and hence try to map the BARs as non cached. This
> is not a problem as the CPUs have FWB enabled which blocks the VM
> mapping's ability to override the cacheability set by the host mapping.
>=20
> This goes along with a qemu series [6] to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device. Verified with the CUDA workload in the VM.
>=20
> [1] https://www.nvidia.com/en-in/technologies/multi-instance-gpu/
> [2] section D8.5.5 of
> https://developer.arm.com/documentation/ddi0487/latest/
> [3] https://lore.kernel.org/all/20240211174705.31992-1-ankita@nvidia.com/
> [4] https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/
> [5] https://github.com/NVIDIA/open-gpu-kernel-modules
> [6] https://lore.kernel.org/all/20231203060245.31593-1-ankita@nvidia.com/
>=20
> Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

