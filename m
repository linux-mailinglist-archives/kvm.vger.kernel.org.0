Return-Path: <kvm+bounces-15746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F41E8AFEF9
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 04:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 502F8B24040
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 02:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682DF13DBA0;
	Wed, 24 Apr 2024 02:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wbj0bPqq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4049C13C68B
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 02:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713927505; cv=fail; b=X3+4vT5/B+5oO2ihfxX9sNgX+RoR+p3vW6qtnY0zhjHkw2BBXH22vM57bCwHrKCOAJiV9e20mP6OECd9iiNN42MRWEC4oVylA8ZKO726gp0uAhKWURsXL/dIFOdEYsisf3Q4YxeSMI+KbfKwi5JMr71WA1/3uZB/GNclj/bZZWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713927505; c=relaxed/simple;
	bh=pfSDp2D4kyZR82WNP8qtPnSoaLiv8LdKxG/9dgrF0qY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k1f4FD+vJkU+CB0hiyJ25cBFFXg0nI41sp8cJCJZUCu0UtjY5e4x//fPcQrgaQQ9IunGO+wk4rmFlLkIO0oa9JU4bWoPxI2SPiIG2GIgD55mKnNKfWIZ5qLa3BqMfCfStlsTh9VhOU3HPAcmeuFKBiIyFVT2auSNviiqsEkyl0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wbj0bPqq; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713927504; x=1745463504;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pfSDp2D4kyZR82WNP8qtPnSoaLiv8LdKxG/9dgrF0qY=;
  b=Wbj0bPqqHnp8SdB7t33npn/juFi2HSRIGvO1ufHvI3JGdmBjrUZOBdQg
   SZ6PIYp9RuzrG1X2Vi0X5jsRAi+JmmrdradGgx9JzUdBWHeOSXdJV37lI
   e/F/4Ne+ebdS11G486LoQbdpuRnJlAUvgCqZvCckj5QOGzRo409A0xpLs
   CvShRiAGdiXPpWH/So5Y18NbFJlzLug/1mDeDESsc8q4Z3ciksgKVoutd
   GyUG0K9gj2LHLFpjkTiI8uYgwhM9vuChkkKapMPu+h0iol72CLGOxnpmD
   hTjxI7nqrrzH6EVLSLk2k+K8XWwoGGGiyY/tiIvQJx8WQVfJmgQ/I/OxW
   w==;
X-CSE-ConnectionGUID: OjwnXH9/QL6IIDfpyExS4g==
X-CSE-MsgGUID: yD0V6q9YT2SemTUt/Plk8g==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="10080188"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="10080188"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 19:58:24 -0700
X-CSE-ConnectionGUID: EV4zdorMRCiPlOJ9rAZWhA==
X-CSE-MsgGUID: CtGenn3tToC6cqOGVG3Jww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="29206811"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 19:58:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 19:58:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 19:58:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 19:57:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fu8/seq94U9jMkR4sDoiTibnlPReTsK3X5NIFGD0z9Bc7UetBlUpmG4PfAdALi/uw6a4MH6ESI0MJlrBEN7IgDSuk3HAekoUaBqqUcLgIfOTFjDCen096iGfCdlLnW1srkkcnMBMtDg7N0tG+37PQ+2m+ZxY5S6DGzs4JnCpa4ImCpbm+Go6y77GlLUWCy9QzYJcdi+IZ63FR0Bb8/ab83iIHSqh9cajRC60asEnqdieC6hYeommKfR0Qpim7tCpJDKPjnpAC1rTTrcTHUQElF+f2Nt965Ao/uY95YZvgmrroWzVxK1CrZWcaemkU1xZC7UDVJ4LqQuBz2ijV2XI5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AQEKvpIz+S4txlB8zTqK/i5fe1RJsu6VtyWky4UREdE=;
 b=O0Ttp70h1idOEB0QSkr+2tuVTCaQpjYmGC633fMNWmFHc1+x6BoQgQW1oODYrGn9x6yg5u/NyrFhcjWQvKT3RTSu49Ai/agGfXctWixpq6QhBvT4IR9UwqGWgRS9o/ULBZIOTJYacOPT+MI483cwCCFbjdTe5oFOeVcCQJlmdTdgKHkz20VX6LTfoon20RYY4Y3zGrxK+M9PJDQR+mpxz9ztSNSaIjbsVT4xV0g9vGyNjD62jQrAO07xBmd07O/VxjdR0W12RENcvi/0fbf/7jWM/0qqE8K9BWP2czDwz8ERawG6o5mIgHEHzrqHjHkErMvqEAbcsa1qu0vTmYnyHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5069.namprd11.prod.outlook.com (2603:10b6:a03:2ad::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Wed, 24 Apr
 2024 02:57:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 02:57:38 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIIAAuGoAgAWh6eCAAFrQgIAAvzfAgAAM8ICAACm70A==
Date: Wed, 24 Apr 2024 02:57:38 +0000
Message-ID: <BN9PR11MB5276555B3294D5A0892043E98C102@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
 <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
In-Reply-To: <20240424001221.GF941030@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5069:EE_
x-ms-office365-filtering-correlation-id: 2afde94c-b7f2-49b8-6bd6-08dc640a4d49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?wfA8l5eM5DWOpF3eGgVWV4eAQL+RCb6Dydi+v5dd/koSvyyEgAG2vbhqUzLj?=
 =?us-ascii?Q?A1dPS8a54PzDfqQZdSVoE8O5WuNLtsMH5FIUHzS9vnnbOn4z+9a27aXjLBXW?=
 =?us-ascii?Q?3nkMRelChL93WBvtewVZkSWvx5IFN3+M3XjtK72K6g4n/GM3v4HG5+KzxNsJ?=
 =?us-ascii?Q?2VSgph5+f+A4oHT3Xw4ZZYRr/XwwFdXATD8x6WgzyYZcRcEZc7g3CkZGFiva?=
 =?us-ascii?Q?mBl0c7xvomLgyiBvfd2FOH1yFmXp4Bg8E3p1DiF+ApkHWaNC3AMqloyxl2Ds?=
 =?us-ascii?Q?AmKVrUt/DEhjdF0zvxKY+SF/aJLeUY9qq4E/kTzuOQGqiPD/2ljcycZWOeBF?=
 =?us-ascii?Q?gaKz6CxbpIH81Otyj7YCPimVjQ3x30byaFW/BqlvCR5ugHafQSf3xwm/dMyy?=
 =?us-ascii?Q?BWYf4A7AzvjNkUR+WKixdsl1vSIreZolo5j5eu+nvUTXnn24VK+/75BGJUzf?=
 =?us-ascii?Q?0y/3zAzJpY5FOrT+X5ApaobB0hQCKiKvhDSqMUQ+2UXOcpvooE1SjUirqjd9?=
 =?us-ascii?Q?0AfqoyQCogMQRZoPwDG0IQG7WSBNuPIpwAgAbRHBP/BAypq1OQAHKSHDjkYJ?=
 =?us-ascii?Q?5dF+h5YINTcWLWd8h/OwCafx/jy43Q5WdIRJKt78n823Ax+77kcxKvB+LfXg?=
 =?us-ascii?Q?ldGXcNS2t+1YZMmeX2lYO0bVz+y67XE4V3+AX43f9pWq68/d4kRKYiL+/yV/?=
 =?us-ascii?Q?P85dnPe7Ol4nR1qmcQ4m6AFscmHnb52eNrFoZIQxez70E0JC3lvtti+7e5Wj?=
 =?us-ascii?Q?iX05/f4FIuyQfopqONfJbY7TkkMlJuUjQC/H6E/Pndk6/ES9iLnJayatVNHV?=
 =?us-ascii?Q?8/BDZu4IdP+jaIv8h4KanuEEGjpopViHAFvDmFLE4me6oM8vQ+76/DnQTezj?=
 =?us-ascii?Q?9zwFLsIQuSB4YFCruzW1PfiBacUjitgBAvwXZiWKxpMFt/5sXSw/jTT5crwy?=
 =?us-ascii?Q?4avAXpaeI4nZKUYwX7GILRogyB42q/GMF//8QFZN+degilokNniz3E3YsfX1?=
 =?us-ascii?Q?zjOIv6+BhUabNRSekpYdMp6yNSeKpmMX2BgcYQxmT0pXWur24NdCEKVkiaxS?=
 =?us-ascii?Q?fWRIhVszJWL9LzB6cF0zPpulrPe02m4kyC4M3V0763eg2IrHP8kRXiqste9Y?=
 =?us-ascii?Q?9P8+T92C5vPlYCBa13g3VcHFjoOax+B75TNYD3UrNB2bEx/K4ShzxkmSO149?=
 =?us-ascii?Q?si3KaZ7z8W7EAerAuvaAQ3hxqtKxNSI05M7pLhPF7jHyW+/XYWW3CMqpzhzA?=
 =?us-ascii?Q?WCWiuBqY/HiU7CzAfCuH/PGilryJyu7DTHa8SdDbF+6QJDzw9677DG/1/inT?=
 =?us-ascii?Q?ND9bCGLcndFqdu/ctUdKZRG90T0/2EliWx6uCTZsHmbL7Q=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?17YRvAtvk0+9SOvL95Dscx2WzOavG/UMJ1tUVdAyd+q5GY81e75rFABzHKLI?=
 =?us-ascii?Q?YuzBTmCe+m0XLAEo1jEbT0xsnik63bIW+u05fkoIpZKXbXRV8ASgiiuVQGBq?=
 =?us-ascii?Q?RY+yb0VKJniGUGpw5AmK7uTQUS9J91UaMftReAeLnH8el366srQNpNG+sWhP?=
 =?us-ascii?Q?/kJDOitap1901/gufkA/1alZesd8UY1IN707khEcbcOHJ94sMQZBeiDpPEQl?=
 =?us-ascii?Q?bzwEXEKKShWwHIQrhzE7NETqU6OAll2cNOI8tLbZ9ozJZCwswMznwqFwZXYC?=
 =?us-ascii?Q?oMW0yZPzlZyBOh2gVWGhf5RJZ8EZm55a3Zk+ZSr8IPdwMfub/eH5MsSNJMeQ?=
 =?us-ascii?Q?DOX5kunbPW2xyysRibpru2TbcUvxl/Fft58+nF7QT+61dAswLPyKIoqiUW8F?=
 =?us-ascii?Q?mHux4j9MiDWDUWOHgKOZXiwPhkzqwNzBpM+x2JoBCeGF86zUJsWc8VFo4pAi?=
 =?us-ascii?Q?h6UodM6jQtvOLsfuc2Mp0O2shpfq/pIUj3OGmlsho5fKQFHJgwU6X9rdhDOd?=
 =?us-ascii?Q?qFRzVdndUFOzi/YQrp8jit2cPOLOSv/uaZDMwhpRO8h4idn0CO8MQlaV/o/K?=
 =?us-ascii?Q?hb9s59qIhIT6QM5ozkJZBaFiBf/Xeo/VC9rUy139WS7zb+0JSHE0GJ1/5ocR?=
 =?us-ascii?Q?+ufFVtFLyOiDPH4izfH0uZGs+/uk7qWPR/nS/fN2RiS3CaxwdLoVRivdQVET?=
 =?us-ascii?Q?CPHWF1WTwqRx3vTCvJN41y44JJHSstFKxCGr3fpdjkPRUkypjfAmzz9XfWAb?=
 =?us-ascii?Q?NqvE+kjvyvRBk5m+YWSaTrhBja2g89TC391DxzySXGUzG+Szv/6ka5eU/GSa?=
 =?us-ascii?Q?AXAa3bHe3uQHIcmuMhKckU9MolZXOg+4NlwZ0mJEKMJmVdLInnHYWyzjsbB7?=
 =?us-ascii?Q?js5ZuXBZNlghI1FoueXzOdrg45RMjFcBPv6D2kK+eJzuawsQBVYN/t6V8cpV?=
 =?us-ascii?Q?3wQ/TWfj/JCtLO9xgoNBrz9IaY5UskXjMsgYufCbHTZ30VtFyDwK+3DTYQQe?=
 =?us-ascii?Q?NkX8v+JtBJhT5MOcx9gTg8OFstVkIFQGA3/qtHtYTKZYoXuqNI2KS0WSTKZK?=
 =?us-ascii?Q?95Wp+KSdKUNiEQWqtQ1u+ZOSAdff+k3S9LYswnLg/UuqaCFVRNP+U4xUsHT3?=
 =?us-ascii?Q?S/fLWIsjy/lCVAfRoKLXOBmOC6Eie+YMjK1OHqfQbIonkMx+FWxpZFl1F8XT?=
 =?us-ascii?Q?51SNtnqGY/RjmD94BOldEAtdo8XuKgQaoNP9Ai+Tl5tv6BuAFvOsn7tC5Cfj?=
 =?us-ascii?Q?1d6q6+HnnTZ7Oq3MjiljiIBRycU5okO3V+RKwPrOl7tL5TAqUzr2JSKk91Mu?=
 =?us-ascii?Q?FVc4KvFYOPN4LYglvGOgHlsWD0q+IzED3ccOUPhWX8g/2hpy1DAfyiUrnblg?=
 =?us-ascii?Q?jWEo91c8VWX+18RFwAbBLUGaL7C5vMpAm5Ujsb9IS5ESiE6TVnAn9/jPfbOG?=
 =?us-ascii?Q?E+iW/l9bl06O5PkFJ0v7YGt4WdvXck2hD176bwGEPRUZHMlqhaLG6NY7v4TI?=
 =?us-ascii?Q?qrZy6dKca5JU4wMn4dco9LPgPsW74gxpTCzygTnu4GLM1iYeFlrUQzAPZO8a?=
 =?us-ascii?Q?aq/NXyrY6miQW8PyaTbQHfGzcplvZG05J6aICrUp?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2afde94c-b7f2-49b8-6bd6-08dc640a4d49
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 02:57:38.8804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8EMggUvSIICr40LIeI91DGQ8jm1zIwMpWiArKBrZbtDUIsFIKfbJpA49QnkdFW/P7jrHF7zRoo90GECvnp9MWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5069
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 24, 2024 8:12 AM
>=20
> On Tue, Apr 23, 2024 at 11:47:50PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, April 23, 2024 8:02 PM
> > >
> > > On Tue, Apr 23, 2024 at 07:43:27AM +0000, Tian, Kevin wrote:
> > > > I'm not sure how userspace can fully handle this w/o certain assist=
ance
> > > > from the kernel.
> > > >
> > > > So I kind of agree that emulated PASID capability is probably the o=
nly
> > > > contract which the kernel should provide:
> > > >   - mapped 1:1 at the physical location, or
> > > >   - constructed at an offset according to DVSEC, or
> > > >   - constructed at an offset according to a look-up table
> > > >
> > > > The VMM always scans the vfio pci config space to expose vPASID.
> > > >
> > > > Then the remaining open is what VMM could do when a VF supports
> > > > PASID but unfortunately it's not reported by vfio. W/o the capabili=
ty
> > > > of inspecting the PASID state of PF, probably the only feasible opt=
ion
> > > > is to maintain a look-up table in VMM itself and assumes the kernel
> > > > always enables the PASID cap on PF.
> > >
> > > I'm still not sure I like doing this in the kernel - we need to do th=
e
> > > same sort of thing for ATS too, right?
> >
> > VF is allowed to implement ATS.
> >
> > PRI has the same problem as PASID.
>=20
> I'm surprised by this, I would have guessed ATS would be the device
> global one, PRI not being per-VF seems problematic??? How do you
> disable PRI generation to get a clean shutdown?

Here is what the PCIe spec says:

  For SR-IOV devices, a single Page Request Interface is permitted for
  the PF and is shared between the PF and its associated VFs, in which
  case the PF implements this capability and its VFs must not.

I'll let Baolu chime in for the potential impact to his PRI cleanup
effort, e.g. whether disabling PRI generation is mandatory if the
IOMMU side is already put in a mode auto-responding error to
new PRI request instead of reporting to sw.

But I do see another problem for shared capabilities between PF/VFs.

Now those shared capabilities are enabled/disabled when the PF is
attached to/detached from a domain, w/o counting the shared usage
from VFs.

Looks we have a gap here.

