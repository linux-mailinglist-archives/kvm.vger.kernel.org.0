Return-Path: <kvm+bounces-14746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 614948A66CC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 11:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 855141C21D2C
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB6D84A5F;
	Tue, 16 Apr 2024 09:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VDYnRo+l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B178F84D0A
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713258814; cv=fail; b=DQVgYe4IPwY4fhidhK1G1tNMRfYldh4IjvATiyAFq7HibiEWuyvPFwtkqeroVA4lflkKafYPOfXK9iaG62G2PPZHpScMTz2haVbfFiGKhUy4sqdnUAF8b4yOlxKN7ey8RrAuQvhwhRhL/p5BWrbNpr0l8TAmgtIiM3c0XTR4sTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713258814; c=relaxed/simple;
	bh=R/FM/khVRnSr5uqg79ER3zzes8uny9PbciZr8UJevO4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Iq1TvYw8VJaBzYzljEZ3oE3Oi15qYuSgxfKawABBVGMUSsu5xJd1FYrua0NysuqBoqy/94ZYJKui0CpJ9IF2Ryh/c9ONcg4OsUehxjeocdRbLc781X1Ev3dapC9VJ6qZ1yqpoQU6SlZkkvaKdzwfh/Yo1Aso7G2r5NXEg1ng/BE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VDYnRo+l; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713258813; x=1744794813;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R/FM/khVRnSr5uqg79ER3zzes8uny9PbciZr8UJevO4=;
  b=VDYnRo+lHTdELYqvAQmP+9K52YCI9tVglGHjUPjEbPJWSY5coS5nwiEz
   myuCj/yn5I8l566ewtnZCLh23t7Kcrfjdx4Q7NzhKgVfmZ5QLjH/38/7Q
   wsnFCrGb53OCNMfMt4OUIxNZO7JRMqF1phm4xMDicg044sMA38RjrW5Ix
   XQJWT+FzIb93Kdzqm+LcKkUDVO89SdHs5/Nz75sWKeZpbqB6VxYnt4i8w
   DuxR6RexyLs4Cqn+EoT6v8R/mPU6eQHMZlVvxkkh4EgfNOQf3SzRORhOk
   zqdCO+ySCkCZPHKdkxSy7U0C6DaEkO/PsdqNWo8jYPsJhpw9tLvR/PDyZ
   Q==;
X-CSE-ConnectionGUID: k7VLYy8PRri7jeGnWnNVhg==
X-CSE-MsgGUID: U69CRJpqT3maV3SOFKQ9Tw==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="20108063"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="20108063"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 02:13:32 -0700
X-CSE-ConnectionGUID: I6K/T/IfQyGWMqoVFmtY/A==
X-CSE-MsgGUID: kkgxMd9VSUCp+jBx0WA9DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="22090478"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 02:13:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:13:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:13:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 02:13:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 02:13:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBNBzVO7TZwjTFzKFvPdPAi4Z6Y8X1RMUMFHq4aJh/LFSf/j7wnhr+//MoCfpqXXk8uRa3FakH2vcNS3drK0sIVs+mSejeHu3namVn1dNxj0eBULcpRGq/BQ01A4aeTCA/MUGAXtn3cbcqCYIRUxWTOn+3uKrSIaMWWL5xCzjoPeZTKRl3yKQXbVBGXp83KUMz97K9CGPvQTCLCMQ8Hm1OCzfVFmiZfh3GgcdmSSXJvUwHfSnZJakIaPZ/SlUEekfoEUhboFwC+Tj7nYbde7uxmMzTis18UAVgWtEphAMOfR/p2fisNAYVvPnVVwCHB78k0xWQWzC0PnfdmMea2yxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ib99GmD8yF4IXraAZr+45qPUtzRLiYgqsMDyrUnPFY8=;
 b=nIop4oOHa15ywrfDM6AL9ZFFbwgAW+UvNb2pVVFL70ryfMMtpM8ieA2uNC/lWcrlDm0UHusJ3IY85gzz4qKhEM1yoI4tBr+B+QzIA2XXSRHlg4Cqe8wLwctGB4BZSarID6EiuEY6HSHXBzIsLlhOln6fmdvlQ04ZcJVBwSyDZjUmVfmcqZ+H+0X7SkLKOuQ05iX1Swa4Z3sFIofTTSnlPuIqMNTqx0DhU6/VVaFELNjdchkG2lISJlGuljZqz4/b0L7ayfczsRohCvrPZO34RFBOrwKmJ7CFb3NZ/zJFFEwGLB2CN1UCt9M70nXe9CZUnlknzT7xZAuelDmZyrHe9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5770.namprd11.prod.outlook.com (2603:10b6:a03:421::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 09:13:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 09:13:28 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 3/4] vfio: Add VFIO_DEVICE_PASID_[AT|DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v2 3/4] vfio: Add
 VFIO_DEVICE_PASID_[AT|DE]TACH_IOMMUFD_PT
Thread-Index: AQHajLJsYW01CgrDlUet/ogTM4YG8LFqombg
Date: Tue, 16 Apr 2024 09:13:28 +0000
Message-ID: <BN9PR11MB5276FF829C765ADB8B8F8ED68C082@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-4-yi.l.liu@intel.com>
In-Reply-To: <20240412082121.33382-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5770:EE_
x-ms-office365-filtering-correlation-id: 0a5cac2a-2def-4192-b1fa-08dc5df57ade
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?d8r2+SEBfbCuugfKSy3zn4LNPHYtYeANwdEg6bV1ED0pS4cjsnU/mzu3JqPl?=
 =?us-ascii?Q?4ST1GhFYBIOwDOB77CxeIjz3UduyAoXGETqQGNc9hSPrSIBXWME0FMhzC7al?=
 =?us-ascii?Q?0UDQU75ZifOxBS8tVrKeL1BwFq4/EucnAz2vC1rrfUlFEA9EMbqH9682gqQi?=
 =?us-ascii?Q?tQ5RRZbBvi8604+nIvmOZOwdORDM9WCjpoj9OgxcOgPVaxlvS9YExkN8qcUr?=
 =?us-ascii?Q?eGomtYV6qehDsId0QCtzveGqzIAq6gRd8IY/rWS/P09o1Hz04hEyXeA45tjY?=
 =?us-ascii?Q?UnFGsEUip/0igy0rqFn4Jy85JJQM4e0JgD7Osgyi828QkM4+BmS7rnjQGtFp?=
 =?us-ascii?Q?DcBvHtH0V0d4KEY3BIpSryyPfZ8vNqYnvaVp9CM0eb8bRWUBZRdEjpP4/fRI?=
 =?us-ascii?Q?2+Jl/s3WW2iWfxQdY2MMTuibN7mj2N/8Jn1NPY1ID1lcgpWuXbdi9R4cq8bc?=
 =?us-ascii?Q?yDct0pLxS0lw0GJoNQ1Xb3MN+m3XEOiqtETJuQch4kb1DqxgNjwoaxDzokpo?=
 =?us-ascii?Q?qZNXrZHt8IsFkf0D0Ai9qy9yZILRimdir6bKBiQm3Mx2dwus9cW4FRDxT33U?=
 =?us-ascii?Q?K6I0yxv3fk9ZEJWh1MCEDT1/rOv4i2e3Ubq/oCdxlL2ma/yX+FGH+TJRtHSw?=
 =?us-ascii?Q?LL1yPHBwEBaJQ1Vd1G/6uM+/ZDGs17afjr+lbTh4ZVILBtk2TRKdJYOmVojr?=
 =?us-ascii?Q?2+E/CfuoOc7CG4lG0ntgZYPEPVJiiOH8PuKGWUzds1U8lBpnUNv0yG9EGnX7?=
 =?us-ascii?Q?f0bLfWQqbRYH7c/TBls8lCRI1L8tPqXvOjhP8H+vEWS6fQPSY3K4lxnkkTK7?=
 =?us-ascii?Q?sqYdQXaYIsYxn9RM6NpEocuMClGyNHceap0GQtjf6ltLiguVkM1C+UMB6pEl?=
 =?us-ascii?Q?M+nOB5mAplQwaAPSuP7pSFtPbTZVZUnHdT+sUbgVRYkP5PB/U1cFrX6LgJmu?=
 =?us-ascii?Q?9QIhUXQMePcHH2oEO5s3Ys2DS8Wt6oWvH6jtdHsfVcbrtOnADagTWoLsq0Fy?=
 =?us-ascii?Q?JI06eHmycvVdyOtA8Y6gSl9y0NFgW6XMKXV3U+Wa9R5LkLsOSg9gZAcRxcGB?=
 =?us-ascii?Q?jLGUteri+k2ngRZwerej9GlGbnNUZcGKdSaOdpDbhLMpHFzPW0BdsfuStw09?=
 =?us-ascii?Q?+NzgYG9r+WdDJjAtDnlcxprUvvf3VqMaXiIqH64WXRnY6oWFBIHpabs8r2yz?=
 =?us-ascii?Q?UbM6ZQrqJpKjEVmI+WZ8crO4nQJH2tRk0pH6OyOi6uDHw5+ja1gXLcZ0xE4b?=
 =?us-ascii?Q?3L93Vq/NxSxOYiZsTdJb2i06we28ew8oI0BvgLz+mxmj7iynJEdIddweuc0o?=
 =?us-ascii?Q?woU3ArHzu7/+eGoWbGu+1zVD2jTR2XC5JbfRiFjBmy0gVA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q76D1nk4xyr91/pJb3iXv0Bu9OOGHIALMB7MSPFCqQrK8L43mgrdu4l5OkIy?=
 =?us-ascii?Q?rDqHM3KvX0kYcOXyDuL2nx1lSHsBMd2SpA71yHI/WMbdHZKawtyIEgKkDJSH?=
 =?us-ascii?Q?MoWhYgRrtYTSTr5tsNxenQUFpjGmMOyxfnnFWvgitt1YnglqhItCs4kpbmif?=
 =?us-ascii?Q?rWl2rEOi0vLS2lUX0uUSXWf3CZ96mqxE61muI95xDRUmNoxlNHkHYHn16Y7n?=
 =?us-ascii?Q?RHHSV7MEA7x91eF3d1L3FgFWf1/zEQVtFG0ngKW2NTbFwGkSG8Yc3ACUy0+P?=
 =?us-ascii?Q?otjfA1HBz7eDFNg9ZrPnzZ2s7ewBi3dNXC23xc0I890Af2gQqUw8LPHHBz3n?=
 =?us-ascii?Q?/k/ApH9/vZ2BWHkHQqKhYeU5coB9MuZYCXhB4qK0N/WR0eKsOxtfBFaUsDad?=
 =?us-ascii?Q?RfEBjtkBrSbIlii4eo616IhcZbe4IdFnEgV5CD2WCLqUKVNHnHa1QJdv35dv?=
 =?us-ascii?Q?W0aiXYBTEU4uFnNVBjhFd+RbiwUMcOL8H8nmm0rF5KSV4nv4/4J5O7kj8sB6?=
 =?us-ascii?Q?o4rIFvIkq0B8yEeXXNzxzCIdPMfpGr4yIU4tsAyzdgbtXvPfxufpX23px7JG?=
 =?us-ascii?Q?XhtAZf8KTg1bIFhzQZhBWNwNPgpWt27nsCyooTgnbHqujvEPsw9EHN5EMbqy?=
 =?us-ascii?Q?XW7hTvTA6WneAzUvlPkQRreKx1+ag4SotnY8Yk7shUZ1OhCcboyIdBLD1byX?=
 =?us-ascii?Q?7X0ibD7+9JY/hGmdyKkcSUvZVlCjbZNlPZvsUJu14Jwrapmo+a+h0ocyUfSp?=
 =?us-ascii?Q?xOI8gxLLOkZFdndLke9GhFfn+0TlvoQg9tER4AK3E7UEtLQJICyoCdFQonem?=
 =?us-ascii?Q?9vF4nrLc+iNYCBmLK3BRdvnyxF+w6MAaTdQngTyb8wSs+x/Q8hqaOAD+FpXP?=
 =?us-ascii?Q?2UxnVfw6SCSrGWhRuwHIuvIriZwFVK3OhA9QKxryyOcY2RoL9c0d6HaYZrow?=
 =?us-ascii?Q?Hxc3CKeJ4FoRAhSysoQV6Yw/O1WKvp9sRcZl/Sc7mjV91IzJO5QiQElejKZJ?=
 =?us-ascii?Q?mbyx0vXNb6nYZYroLIsJgt2c2aBNSl+jVfYbBdr3VRsieK813W/76byq28r0?=
 =?us-ascii?Q?UtKFgFIAjmpvoCNOtsrkgSaP/jOClsIEZm5ozAA2+YDZ/2e0FGzMdXQAMHw/?=
 =?us-ascii?Q?N7odJVtZrzdZ0u8aXPz3j6Zh3TL9rGuzx/jNUaFMX6e2pVvU4w0xJG3DI4tP?=
 =?us-ascii?Q?yHgQ6czXLUA5hEmEyEEQc6G8Wt8ciuopgayMsQu/MTr6iuYwcNN+1D2oThEp?=
 =?us-ascii?Q?clyLTiBiM/ttLwFqY+70Q4fH+44C2vzIGWLREqz9aDVu35Kp3MFNGT7mvIAN?=
 =?us-ascii?Q?c0wqYBiNP9T8nsJrXBzVwvyynASduiVFCV/9y3eCx6ME5JIwZyv1k1j7uCHM?=
 =?us-ascii?Q?LsaMaTsFxDThii2NuIEm9kr0TFuocueY5pFsJRKPwMLngUzHvUji587eXJyr?=
 =?us-ascii?Q?9dx8aBP3kJ8esMX6UDTJuQJfCheHYw+DwN1envIpyWyGlnA00SQx2z3xZb3v?=
 =?us-ascii?Q?nhKmhKONMKr0UfuhmTV5ImCEgEkSP0IjrPN9LjI3GEeEx71hj22G05BuTNix?=
 =?us-ascii?Q?q/ha0Rbewgh1T1im/zSvSQ2euMoQqBjDBp2Gy4aj?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5cac2a-2def-4192-b1fa-08dc5df57ade
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 09:13:28.9413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h2Ag0inJaG6oU6b9XnJOseLa5BImYFIONgI5BsoFTZ6NGzZF9wnNwFXLGc6xbyCiNliQ2xmk621Perv5Otnqug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5770
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, April 12, 2024 4:21 PM
>=20
> +/*
> + * VFIO_DEVICE_PASID_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE,
> VFIO_BASE + 21,
> + *					      struct
> vfio_device_pasid_attach_iommufd_pt)
> + * @argsz:	User filled size of this data.
> + * @flags:	Must be 0.
> + * @pasid:	The pasid to be attached.
> + * @pt_id:	Input the target id which can represent an ioas or a hwpt
> + *		allocated via iommufd subsystem.
> + *		Output the input ioas id or the attached hwpt id which could
> + *		be the specified hwpt itself or a hwpt automatically created
> + *		for the specified ioas by kernel during the attachment.
> + *
> + * Associate a pasid (of a cdev device) with an address space within the

remove '(of a cdev device)' as end of the paragraph has "This is only
allowed on cdev fds". Also a pasid certainly belongs to device hence
just using pasid alone is clear.

> + * bound iommufd. Undo by VFIO_DEVICE_PASID_DETACH_IOMMUFD_PT
> or device fd
> + * close. This is only allowed on cdev fds.
> + *
> + * If a pasid is currently attached to a valid hw_pagetable (hwpt),=20

remove 'hw_pagetable'. the abbreviation "hwpt" has been used
throughout this file (e.g. even when explaining @pt_id in earlier place).


