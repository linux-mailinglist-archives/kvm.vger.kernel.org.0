Return-Path: <kvm+bounces-14752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA6E8A6750
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 11:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2AD31C2162C
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C399785C76;
	Tue, 16 Apr 2024 09:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zn7cLAoN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8702907
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713260485; cv=fail; b=H3JZ2y9NIFrA7FYR46SiiUxHp45Pmr505fBcDJyBTfmj1y5QmnvIgCliJ5GHcyYfuKpkLewR3M/yozOLQ3NYsq+EDO8RparrEh7Att7kQC5H/Yy/vg6DL2oDK84qzRa0RaxvWe3Gb9hi6S9mzS79/JC+mx237mP02b+5mRKNV5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713260485; c=relaxed/simple;
	bh=uija+Ie1z4qjP7jqbHw27IZcdvgfNA1zEeHfFaHKCI4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MurnEyGJA/9CqUqk9+F3rho0tfZvUwmw8HlejpQ+pWA2d+dOCPMPkHZ/Y2fDY1v4jwuR3Cg85yQ4OVz2MKWxVcLnOwD3TRUueZz7sfRx0BIXAoPFIW/anv2EYAGbs7E20DfpkzAjXOfxH5H/UX/i/UREjV8QclmjJ0ItkmuTfEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zn7cLAoN; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713260483; x=1744796483;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uija+Ie1z4qjP7jqbHw27IZcdvgfNA1zEeHfFaHKCI4=;
  b=Zn7cLAoNVYr/VGfuMWLtbRzaMEjWwIw9q8m//DNhGS25+A6G5XYgskku
   5ZVGEegJtGo4OrzuiH8tf6KZSJ9AL1ENwAm1dpjyulQYgJOI9KHPMgdwB
   Ov2x0fxZbWeE7JMLVVtHzYSuv+Z8u3jcxnPaarSMQEVBP6E3OyKm9uEVu
   TMctewT1Tjm0l1bT0HuVPmHvBZDhOzTM5z4OE8y7hqM+Xf1wldcHzbvTO
   9QX2RMEZ0VzFD0POr5YgYZ/tfDZJS3WsV1GMxCNHcgGa8BVNKEhhZJ+9I
   kbbOEvOrOScCcE42w9sbTuYupB1A+qmIMFNPw/efbP/rvVHoAlOU7yH2Z
   A==;
X-CSE-ConnectionGUID: uK3OlrYdSOaAoiNjeMO9iw==
X-CSE-MsgGUID: 5J3wy22eQ5ybAPuscwz/sA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="12464562"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="12464562"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 02:41:23 -0700
X-CSE-ConnectionGUID: 5OLDPoXsRVOpuh83OJOMHA==
X-CSE-MsgGUID: UnO4/AqySWOPPU1eW+//5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="45491417"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 02:41:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:41:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:41:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 02:41:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 02:40:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JW7UDu6v2Y5WJq7FJ60rhpW4BB7Gtcx2FSIOxCkDmGEOzBhMVPELpb+PpZiNqOpxSuUGJ7DfHlW1sq9Mj4B1XaI4Ei3DwId7oPDr7miityHGL/XtPyOHz1E1CLI48/10TClLCYIMwmCW83CrJPXE7W7ongLBgkmpKPl1D42TDHdQQnHdimK6/mbodbdR8BvSqcGcvXoX6WrPr6zX6nGyEd7A9VfhB6BqwRLN4W/TUuEAtjWhJf8z2nSCG2+44kDKeyE543WAMSSxzGPbAzqoT4WKmd0S1+09MURflMMz63hQjtExpmilQh/9Ic/qS5ThZtpHKaLq0jmWxHrpGFBBHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hphO4jBMm8oNIaArEx1riWgtyo84BabpxeLZBLK8Gcs=;
 b=Z4REEs33qI/Fq7Buci9Pc7WjgAEuhLs+z2e1B/Y21InRHr7GveJ4CmAiIfyipfWU/rXa70san8pTzuLZMqG94urVsireM7CXdx0vOyhIrciglDw2/283iwPrz9gOAY9hDCya+avsWfIwl4cxh52v1/Ribya2+33LmYLR9nUzefGNj5JSDHT4c60IzAuWLzqNW1Hr7ktgX2EgwrugCCSj0pQVTnSlTeGYUsWYKY1y7PiE66o5VutcUN1DAovUgWvyyzrUlU43TCfAMON9S/Ao5Yf5uLWZoldiA6uV+TYE8KV5IiPV9jLepwlPAlCJRF/AmPhKkXGt4tzTJjiDQP2aIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7839.namprd11.prod.outlook.com (2603:10b6:208:408::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.29; Tue, 16 Apr
 2024 09:40:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 09:40:50 +0000
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
Subject: RE: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Thread-Topic: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Thread-Index: AQHajLJzYiLjOoAxokK40c4Rfn6iJLFqo73Q
Date: Tue, 16 Apr 2024 09:40:50 +0000
Message-ID: <BN9PR11MB5276B930B0177AAA709BF83E8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-5-yi.l.liu@intel.com>
In-Reply-To: <20240412082121.33382-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7839:EE_
x-ms-office365-filtering-correlation-id: 34c15faf-99db-4620-788b-08dc5df94d87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?up2Qoqo2IupcHHzSaXVhMXd8z6/LpmFwtRW5/kKR0SmFPfhwvXJ4T6dJne02?=
 =?us-ascii?Q?3cMdHGgXAVpzN/A5Eaa0ZsqprRYLdsrHw0mIX2uRO9ER6mJTtktC1D8YKrmG?=
 =?us-ascii?Q?ucwsg3TdC5tpP4UEJk9hfyZVaSB+eH6wxQfv8EMLVA5YN0UyEYtnlVUHAW8q?=
 =?us-ascii?Q?5osM5dPcI+XpFpThd+nkcZOGuMkaYO68pe3tswOvVmIWb1gIdVv8degBF0zG?=
 =?us-ascii?Q?hhSLFWQFj+0lAZi42i2RYksYJdQqLlccvi7YqxtfpnW4bRLUC9iMEH82OOCH?=
 =?us-ascii?Q?aVHk98tHc77VS/b3y26191FScaG+PONfP+rFtBjeua8Zk2CknLlP97tH7lMV?=
 =?us-ascii?Q?zPHeseS1Nx6j9vCtTolUPFA8klSA/s5NQFPQjui3REMJmwy28tzXzSPh3Iz+?=
 =?us-ascii?Q?zNcyZ5YElMag0c/mP2s3kfw0IIEki03QTo3oxyo34954sQyg0DHfENhHAJzF?=
 =?us-ascii?Q?OTaqvks8DVXk+Uk1TbOWdfhDxtPloNj2i3OO47pZi07UhNdoRpYw3tGOuQro?=
 =?us-ascii?Q?ioDjBMA950aeGXFC7Y5IJv1iEyP+5zZKH/j57kJrSfHq6UnviVNDLz/s2nyR?=
 =?us-ascii?Q?Kg6atdsMJch25Opfm6vxmALsy88vc3MYHCdrkQhMhCpr6+FNnZGhlNiyZDI1?=
 =?us-ascii?Q?TTASP7XeupHB7WoqYqKK+45y7M/FJfppmESBS2Txvdx8TBYNWfS5TTIPkGGu?=
 =?us-ascii?Q?WRA+4VmKMuUXjjOMlzF5IFP07lDxoiEu3s0vkEZ7+7xk6UBRBWgB8CnW/XWx?=
 =?us-ascii?Q?cnHT+feSy+48ulvozmGd6DJODZnmr6ZXRa8DNcaNZL91oQMmTcAYs43M1wLj?=
 =?us-ascii?Q?sX+LMTlxOfChsIQVQwG0j0wk7mrbl0ckDQkUfOEPOjANEN7kUA3pWD8j+65b?=
 =?us-ascii?Q?+zijrC6FnHraqNS8lVVQo4GfP5jNqp9z8Z6YR2H5OsJ2uFqNZG87cfPokUot?=
 =?us-ascii?Q?iqdm8Y3QIOfwJAUjOScrbnjm6lb7MiTA/EtwFdL+fL+vIjXRTemeZtsE69av?=
 =?us-ascii?Q?344TsMnNp6u/Xsoq/ofeZPbzY7p0k227jldV/WVHzU37Ml/fBJ9i4zABYV2x?=
 =?us-ascii?Q?IDIt3sTsoR6EodpkW/3xqZ4lMh4zO+mhuyPn78Z+TVsJY8hfqlG+f9Hb+5p4?=
 =?us-ascii?Q?o+6Yox+Bcs/wF6N59W7pKMgyzWg1NRGs+3pN2DRFxWidrLR6dbNeVwUqBI3g?=
 =?us-ascii?Q?Jxz7yo7QpnTvgiZ8bSrIhV8Ot4r5f5bNTheBzmIWU10Zq81fz3lq43jizfbz?=
 =?us-ascii?Q?4SQ0t8/Pus/TujTwgxoSL9/Zl/BHY2X/5ypVjEXgGOucGwDvWpIJwg7+hIf7?=
 =?us-ascii?Q?K0uBdgpCw0toT3A47PL3PDtTSM5YaLMqs+RXOqdJFPYhdQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QEhZ5md0mUsPdKUyLvUKNUzvqkgm0FPXPNGOLsPS4ZQajcBcsh6q9AiCGO8c?=
 =?us-ascii?Q?/UvxcTuR7srfcuTF7wL5Mr+U60KMWfaEYHELt/n3u9NLRBs/6YPR53v3wBEH?=
 =?us-ascii?Q?POjJbF5wFOfbhAiUI71n0ZUSJ+OIamQBvQ4/eJs0Y79CzBi53zSvT3psY9vM?=
 =?us-ascii?Q?kv7X1+Ajomg2GfSdKFepXgldz8MoQbI5ZPGrk2i3W063+iRzqFYF4W8zkqyv?=
 =?us-ascii?Q?X2t0LP9BnKkktV064yGgoFDiINOSSIMNlzR4QFOCeGv6VJ9Dd252VRsaE3/P?=
 =?us-ascii?Q?kHA8JCHyuL8i1IGOACGQHhhcVT/Wh9ZMEe8UmPcptfP8l7JmgaGhWDG7AiaQ?=
 =?us-ascii?Q?ZwKOeRaWSqOSjTbpVklae1T1t9MPT2js17FU3jT08AKqv3XhqY9GKakYmTtf?=
 =?us-ascii?Q?3+lu79HLcZ4VWm8iX0NuhWvngAWE852VlFqSzVGq2lcE+pxsDl41MDfM+qNq?=
 =?us-ascii?Q?IlvNPq/q5pOH54KWCs+4p8eD3ukDxvVun9OdYy6VzA/UUIFuYzZsWmvNahGK?=
 =?us-ascii?Q?qG+gcxqu2k+3pIHwf7KCd5MUwbiMklwVPRNiMimYbRKREQPzlXZM8k8SoG09?=
 =?us-ascii?Q?nfgDEGhWXAGC23FAtRaAcNi53zsP1atn2so+YFu5LWdmtnVfFOc2SgEkq6Mu?=
 =?us-ascii?Q?7ybLOYM0zuCxUT45pBosJwYgwKLtcOHL4VSI3FHJoIuEgRDUiSxF05Q0tPpi?=
 =?us-ascii?Q?EL9YcoaCGRUikXaTYg7RE0O/AAYY+VwPffwEKP9bOr3xBrFE1zUDFOL9T5Qj?=
 =?us-ascii?Q?aA6US6sqTrHeSLpnJhs4COqavQG0E+G663CjPu97zi5vvvdASg1VqDza0NJ3?=
 =?us-ascii?Q?31GvWIFLuRZGsIqykk85Zmz4o7cmRrDNP8xcMTs5e6p/YZIpqRu2gs53Nj4+?=
 =?us-ascii?Q?+VXN0A+n+b17/95RILN2A2isFmM2FLApQLVKjkJw707Yon3Fm0vnZOuUX2xb?=
 =?us-ascii?Q?vg4ZdrRcVmWuq8aOyRPXQVw6vzUipRD5yCHanJ1At5kD7FQGm+4hWZH/xceh?=
 =?us-ascii?Q?9fniqHrtU8gJkJ3Jn1NQT7FKzQyJBIKZtCp51PXqvubiGkArKUm+URcbtICB?=
 =?us-ascii?Q?3pZZxP1AHi+xONYcc05JfYAwUXe8mMlToZHnH3a96xXgOPkh7b5UNA7UCaFr?=
 =?us-ascii?Q?DXDjiuFk2Lfm3tDhHp2wbU/jruWd4AclgUH9b6aaa2s+HFMXp8wxl4fhTgOM?=
 =?us-ascii?Q?6J5GbS8sGQ/UBhFhf5JLBZrhMj5jhnZtyzDnsmdJl7oZtzNOaxuAPgswCH86?=
 =?us-ascii?Q?AZ3t7DknhJayujwklnjnIn/gsQbCxZ6c1/muelHdlnn0oGEFyUT+W/OSwNkm?=
 =?us-ascii?Q?W24b17jGDvfyEiZSj+ssXSfhvESxTGUlCYvzNRx4rbIh6jEGKeFAN5hVTteV?=
 =?us-ascii?Q?YsRbIFxl5CF+1mjm6++mbs6Cx9R2JR5UcQCD8p8u8VQpxNvyuH4e4ykPANgP?=
 =?us-ascii?Q?E2jhUGhj4npnJIZoJQRu2elUeX4fTgF6Ik7hCj69z8RNuuOCKQYXIewODCp9?=
 =?us-ascii?Q?vtrEPW68eSNtHWa1vwrb+ot2LbFIyukcYp1aKgnCgXCad3z8A/E7xrqRQbZ2?=
 =?us-ascii?Q?QJs1Ysgc6UpSFg7KSCpsFWKgnvXZV6pfaQIQuQ7o?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c15faf-99db-4620-788b-08dc5df94d87
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 09:40:50.8378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mw2MgO+XT+26bK9FQ+gi06RX00YtNGKyrFJO5S7nL0th0MYrFPE08L/bzM4Gy9qjHFD1ECsflDA2ctDtexB/MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7839
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, April 12, 2024 4:21 PM
>=20
> +static int vfio_pci_core_feature_pasid(struct vfio_device *device, u32 f=
lags,
> +				       struct vfio_device_feature_pasid __user
> *arg,
> +				       size_t argsz)
> +{
> +	struct vfio_pci_core_device *vdev =3D
> +		container_of(device, struct vfio_pci_core_device, vdev);
> +	struct vfio_device_feature_pasid pasid =3D { 0 };
> +	struct pci_dev *pdev =3D vdev->pdev;
> +	u32 capabilities =3D 0;
> +	u16 ctrl =3D 0;
> +	int ret;
> +
> +	/*
> +	 * Due to no PASID capability per VF, to be consistent, we do not
> +	 * support SET of the PASID capability for both PF and VF.
> +	 */

/* Disallow SET of the PASID capability given it is shared by all VF's=20
 * and configured implicitly by the IOMMU driver.
 */

> +	ret =3D vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(pasid));
> +	if (ret !=3D 1)
> +		return ret;
> +
> +	/* VF shares the PASID capability of its PF */
> +	if (pdev->is_virtfn)
> +		pdev =3D pci_physfn(pdev);
> +
> +	if (!pdev->pasid_enabled)
> +		goto out;
> +
> +#ifdef CONFIG_PCI_PASID
> +	pci_read_config_dword(pdev, pdev->pasid_cap + PCI_PASID_CAP,
> +			      &capabilities);
> +	pci_read_config_word(pdev, pdev->pasid_cap + PCI_PASID_CTRL,
> +			     &ctrl);
> +#endif
> +
> +	pasid.width =3D (capabilities >> 8) & 0x1f;

it's cleaner to have helpers instead of directly checking CONFIG_PCI_XXX he=
re.

there is an existing helper for the width: pci_max_pasids()

pci_pasid_features() can report supported features but not the actual
enabled set.

for enabled features it's already stored in pdev->pasid_features. so what's
required here is probably a new pci_pasid_enabled_features() to return
that field.

