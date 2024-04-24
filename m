Return-Path: <kvm+bounces-15741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF9368AFD62
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 02:34:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 324851F2384C
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794D04689;
	Wed, 24 Apr 2024 00:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nsuqk1ZH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3962346AF
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 00:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713918835; cv=fail; b=Ou9dsXCVNx7fOCq7767xI/Lf9sPuLgjAS0i7KuNmbRa0LpeE+hJhCg9r6Bttjx8qsIfUlcle1CPiF+tA7BgJ1STMvGsUBijP5Ey9S4yo7HNbEbEEmNh+fCzNMdYQHeI1PhoiG0xKX37ctYXf3aHMbGtE4JXRmYPrDBHrKQOok0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713918835; c=relaxed/simple;
	bh=t/WXP64F26eVuj7nsIY4aGflaGVxmLZd0tiFGpzLSQU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=acoKlc3k/pMdl67ihYUvgKEYhiphfYS/NC5Thc69hiR/gaEhmRWJ9F852rgKoqjzAbuZUOyOnLzpjamtoCMJXv2M8AhplvmHJt1zGtMtQtliUc4vtybbO2RCCI/RU46bnWwO+ltHv0X51SnddVRc4Xz62mb0CmBC8u4fiqtHCxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nsuqk1ZH; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713918833; x=1745454833;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t/WXP64F26eVuj7nsIY4aGflaGVxmLZd0tiFGpzLSQU=;
  b=Nsuqk1ZHHey7jN2IGiGD5TkCiCDOqhD5dIJUwZmdSmHrhpMDAZ1kniAE
   oSn1Ex0f5HH9InP8JMDybohSpgVPEDcoUNYUxUVeB0BF/T2sEHoRv2GuA
   jpito0VkVQNEw0p7SKMtTBr5XVx/lNTMkmM11ygr8YVAjruSPknyqajvQ
   30+Pxt3ouwIw2XT2r/BYqvvXk/Jc6unrjdFoIW0mgoS2t31MNyoOW+RMJ
   vhlXV/8CIpHyUBdAVDlQaaLyC0IX9DeWcHPCZ4BfEKoTwS8XtctdZH2Cd
   QZt0E7cCUwQzG7wYpJCm4ufU4cdPjN9wFzBTuaFOTmSlqJB6iu6UrkNAU
   A==;
X-CSE-ConnectionGUID: cvs6y/1eSMeBoVGjFH45ug==
X-CSE-MsgGUID: hBSpLAZ+REi7TZDHfVsDrw==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="26987104"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="26987104"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 17:33:52 -0700
X-CSE-ConnectionGUID: 3OgCLMi6TR6TwAUjehudmw==
X-CSE-MsgGUID: ZrTm1k9LSjSPk2lj/PfQ2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29188362"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 17:33:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 17:33:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 17:33:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 17:33:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 17:33:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9zv0QO9b96vDp7HjPAFqYxUyUcfAsgOBlRvgibfrVtFU3wtEJ0G7y3q4zUK5pqf3mACNfVw2LxAE54HKuEJSK1njoPDhObaXsZlS7By8g/VxAcVOgbFsphJBNchFhyvXD50/Bv5oHAQI3BJ6leESBSycB0jnOqA25n0NASG5n4Zxf4H4IlS2vcwSpo1ZY0Lq25OJ6a1s0meS5fxYBsQFm9oNPMikMAaVvjvDrhMfOBfX5MszmqQNFqb8jf/cv9EAk8XSUi8u9xd7yd6qM0fKG8Ewz+/szxaXPvbdN66QgBS6fke7NH4zI9ml1VgMwBTqwqwv5VdtmzIlLZlmLnOFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30MO5lz8rSpl30Tae/ot5j5ztD3YxXO5VC2nl7nlBmQ=;
 b=IRoRSjDe6YdJ/W4klP8L3C80Hc0ttBErujm1uYSbZa/FhtDnrzwdS0zkwqGLPNVWy58xdChZTPexfRvQexc5S3CH/qIfkhJ5a15FoDn1U3vAI4A4AFGlT5s4e62mFoHFCvNR3SYvbywp2hnIwotVC9i1Lqrd/jBnnUJ50evpKE2Orb1U2S7ovqdY58yM/KhscIY/M9ZA/20kkzLTCS9Q5TPKAajOKJHE44EuHYeI+vM1WdkVoh59aTaM9csbp15TFkEyv29E2hO+IMZJZvh5g062GOlPcP5Zfa2S2d16i4b0g504gkxt3/h5qnNq40Q0Nh1HyJj4n5bdA8SGrMCOvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB8446.namprd11.prod.outlook.com (2603:10b6:806:3a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Wed, 24 Apr
 2024 00:33:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 00:33:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, Matthew Wilcox
	<willy@infradead.org>
Subject: RE: [PATCH v2 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Thread-Topic: [PATCH v2 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Thread-Index: AQHajLJvqbi+3itwa0qGlqKjcLbCc7F13l4AgADFWQA=
Date: Wed, 24 Apr 2024 00:33:45 +0000
Message-ID: <BN9PR11MB52765793F1FEB8B70C867C2C8C102@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-3-yi.l.liu@intel.com>
 <20240423124346.GB772409@nvidia.com>
In-Reply-To: <20240423124346.GB772409@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB8446:EE_
x-ms-office365-filtering-correlation-id: 532771eb-ce80-4d76-636b-08dc63f63323
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?P4YHR+OOJqQmcpBEbeees9RYqtqNY/tSfJlH/HmuN6OP1gs6U1R+HWDB4Zw+?=
 =?us-ascii?Q?+x/3RA0K8cYlO+Pph7SQM2ywtk6fQHJhwCaIGGS03WD95vZZ6U86m2V6CMfw?=
 =?us-ascii?Q?OuIopOJMmQEkopLliEFb5jdwFjo2eo05nhjuA/Oi3l/3QSNy3TPfwodakh7h?=
 =?us-ascii?Q?p0fugQZAsB7N24ijqGNEfuv2T+8OrcnuT5nnr+4pbSzVoe39kehXkiKNqad0?=
 =?us-ascii?Q?9zfBuIWnyZVJelFEa4tfvILTWyT6FgvCdAoEvaksDXLIEa3CIS6CdDeGXx4m?=
 =?us-ascii?Q?Zm1pO6UsikDGrIgeBgqbf+XlYrX3W2Z59KYsqoGL8cxdQ+Lbif+DfCUiXAlz?=
 =?us-ascii?Q?w+sMMMFbYXi5A3WrBayDmjrC9JIAgTfhzX1Txbm4zNzib+BgdJYXP4eAaYfg?=
 =?us-ascii?Q?8V6L7SRBqW8R/zLDu8PmuH6wgqg3jTbXXjgEe2/Xym+80X2IrDjSJs/ycO+a?=
 =?us-ascii?Q?mbs8qCT4K0gIO3k3g0tQslgayz1KpaYNWBo0EJ24pcopINHQjUehcF6vjxny?=
 =?us-ascii?Q?YxAVLd4jpsI2zhkwojCoBzXE/4zCTgMX8QkfvL33hh49F6GxSoY+9K0x0xLt?=
 =?us-ascii?Q?knVIZvj/sYPOYdPPm2vC/CxH5bfksh5kWs2ZCl/RGgBThE7xbhXGZs52bJg+?=
 =?us-ascii?Q?nHGQGgc48DLrs3lv1yv4fECsK+4RuF4cZ6kGMpIARdWwUq+JmcgKBb+geE/6?=
 =?us-ascii?Q?0zhBzyxVOXEgeTsJbNgEgsqHgeILFbtLPZoKNUcpqh5UEGLaVGE+1jfTOQKE?=
 =?us-ascii?Q?4uj/CnUBwt2AMTbUbjpCKfYqnHLB/Hrk0ws/dWSRlH83wq+OBNVVuaKuKdyU?=
 =?us-ascii?Q?xbVgBGVhut6CQxCSTKaZC1TwcBFUysU7leUdqTGftfmmN9YOSH5jQG2GFs7i?=
 =?us-ascii?Q?MeF9i8Klq0nn+CZnzfiyBDNKlXVIyJ+NyMZzBYBnzCSFbN+f0uXDQovF4fdA?=
 =?us-ascii?Q?t/ewMgqPLwQL/iqPRDAw41bNxSrlS7J/2FdSj8U+GxalOH4JLl5jZwDNod2c?=
 =?us-ascii?Q?fLrwotPV/uwk7mts54aMERW1GvpW7+aDDSa7NWmdED+qFvXdZNomFn7DVbzO?=
 =?us-ascii?Q?x1ZFY+Ex7WfED1290jZqtyrGpVXysj/uCE83J6JNN0O5LPQZFVC27yEttZgt?=
 =?us-ascii?Q?bYwKu2eCAAT0QdlN2twJ1hl8ytU+I47CHzsCjPnta3EU7xYo6ejwN3LygUjf?=
 =?us-ascii?Q?A/2GTu8jT/EIqLzOWtDmr2t9snL7xHJD5cXLp5GFAPHPYmzyF7jZID//Arbt?=
 =?us-ascii?Q?FdDtHGDAOBCDAo+SdyxiOBwqqylSXEOHrXoZIx2EaSSqoUe50we7+qP9bMt/?=
 =?us-ascii?Q?3zTQUCGmA03JqTuJc/VJw575/N44f2sgby++FCwO1pxVQQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cbLYLfGpGvtRsFkbgojSrucgV75NpIHFPiPfPEYG1gmEFWOClPmDZZu3Hg3s?=
 =?us-ascii?Q?n/JSqC8T+l1t6uacJaiEf3YORwEKLg4wIR+jG5f2r2GLsc39hq3ISCybLVgo?=
 =?us-ascii?Q?AZDfO8iNs72Fvr29l3oWwMg6PtPWwZk009FhPyoysOvJQehybpCbX87yueMa?=
 =?us-ascii?Q?MmhbT0k1F2MCIxFnqznwIOokCRMdvnwryMKHRnsls4E7Zv/Ke4d0bLz2VRZ9?=
 =?us-ascii?Q?IITz8Q3KHE9uj8xtl29BrWijZ7YJpmTLGTSYR0EtqsHcofdzvlAVcXRHps7K?=
 =?us-ascii?Q?ERTjDT19ohVTzRp3oZ/qCeL1oAvdLw8byB7PDqolFSBXoOtSWwn6zkxj3Aza?=
 =?us-ascii?Q?50Xlv1F5BKbtmHZA0hcGpwgZ4x6Td8VlyHPzgdKTdWxKXYmUFTXnfcvxwpuP?=
 =?us-ascii?Q?0emqkVufIFyNQfvLiZLRLiU1lIht1IO5qIXGqDZlpU2RcU+DHgge1i0j7udY?=
 =?us-ascii?Q?QrQxuVBUU5hwPbq7qGZnF4iF13gGKadezGyvgeW67jYcL+fLz0ttYK9SEjIc?=
 =?us-ascii?Q?FOC2kbilK2ExxxMbb2bJAmEDS6kQyUo/5euJvOo06KK+ClnxTZWrBSnIKYWt?=
 =?us-ascii?Q?0Jo14Fmmhjyr8mQSeaGY+DlvCJCPF170XomSBoHVvSlVpyxuNH4HrKvfKfxX?=
 =?us-ascii?Q?aUH1AfGPahnpZ6v3rZH00VFYr3FMwq9XHqG9CBN/qqPZ2s9hWZuqIURKZmkV?=
 =?us-ascii?Q?4nYWljZ+OFCB0b6DvPt8mSk0ACtLC4hnx3aICp0mwvRYgP3CPsGsuoGIlWyo?=
 =?us-ascii?Q?tzQpFbuFNzyom+jy9fSW2ghjwa1Ok1qMb/GKSkIXYCKyPhr518fMUjhyuX1X?=
 =?us-ascii?Q?qij5vacSrPvOOCBw4Iy6nqiXMhsKDwd8ADRlLcr2AuXDdwlbC299h6oTafyJ?=
 =?us-ascii?Q?2Y9qWPkBio8JlMUEGEzQwDDxeAzrzddUjfld4QcgPiboJrnTlfo9FYn0MUNm?=
 =?us-ascii?Q?wesy5t9JMD7LOatOU4EIVPWVB1+HAkKtzFSwIxW5llgt5F/z4zCeIvGtOUfL?=
 =?us-ascii?Q?f0Ks/tQpCd5mZj5lhqK3pfbKKNHDDr5cH0RU2cifNjJMflIXG+ridP1rTmyI?=
 =?us-ascii?Q?IoTezosqeTO8TvnQ/opH51HaKSiVZ500SRjudNS6qX6+LiPtmtUjZgSRgZUy?=
 =?us-ascii?Q?tc8UzgvlZUzOu3FgdQy7Hc4ppYhlWyam6qBzex2k7PBtWXI1UUNEspea7fdT?=
 =?us-ascii?Q?aN3X6Tg3JwVeRwoG3aGj2QEUtpMlZX0hwlP0LwCvflKd5hlBKy+9zsagGNAE?=
 =?us-ascii?Q?9qZ/XAnYhZbQUPP4fPug1siM6JJf7U2tLVOIajT/8e/wSE4LodUBfo2ePQ9A?=
 =?us-ascii?Q?vSgMw86Q0UmXeMgQDHXMsK3Own6RduJaCG1ApKAa6+68H1QWqMS2YfoJ8tC6?=
 =?us-ascii?Q?wdSyccW6vFW+iBb66qmSN6bxJjJKPRXthai5xXAtNETxnVAVXbUA+/nwILXk?=
 =?us-ascii?Q?0VfFFWKHbcZ6Bu2/q63rPY+tDbfc2fRvtKEKK/xnzAio1OM6caTCuZ1Ep2QR?=
 =?us-ascii?Q?XUdkWyf5TCEDlMcDOeVaOQBro/x+6V/cvYTo1Wc6swrpBJnE5T/Y/llJMb0S?=
 =?us-ascii?Q?OEuvf+RvbnWEiD7eHujKgJFHhwx4j0Y6Yptx3SGW?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 532771eb-ce80-4d76-636b-08dc63f63323
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 00:33:45.0771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ydzxqv9OI7z8d0q2mMtOH60vhaAIM8BQvC6lq4ft2KR+Ge8bEO37m2pIX3YTKwNj0UzNkjWduQTQ8WeWD4jANw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8446
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, April 23, 2024 8:44 PM
>=20
> On Fri, Apr 12, 2024 at 01:21:19AM -0700, Yi Liu wrote:
> > +int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev,
> > +					    u32 pasid, u32 *pt_id)
> > +{
> > +	int rc;
> > +
> > +	lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +	if (WARN_ON(!vdev->iommufd_device))
> > +		return -EINVAL;
> > +
> > +	rc =3D ida_get_lowest(&vdev->pasids, pasid, pasid);
>=20
> A helper inline
>=20
>     bool ida_is_allocate(&ida, id)
>=20
> Would be nicer for that
>=20
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index cb5b7f865d58..e0198851ffd2 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -142,6 +142,8 @@ static const struct vfio_device_ops vfio_pci_ops =
=3D {
> >  	.unbind_iommufd	=3D vfio_iommufd_physical_unbind,
> >  	.attach_ioas	=3D vfio_iommufd_physical_attach_ioas,
> >  	.detach_ioas	=3D vfio_iommufd_physical_detach_ioas,
> > +	.pasid_attach_ioas	=3D vfio_iommufd_physical_pasid_attach_ioas,
> > +	.pasid_detach_ioas	=3D vfio_iommufd_physical_pasid_detach_ioas,
> >  };
>=20
> This should be copied into mlx5 and nvgrace-gpu at least as well
>=20

I'd prefer to the driver owners to add them separately. They know
their hardware and can do proper test.

