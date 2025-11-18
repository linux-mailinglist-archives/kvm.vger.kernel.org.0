Return-Path: <kvm+bounces-63436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8B4C66AA2
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A4BFE4E10C3
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 893B32C032C;
	Tue, 18 Nov 2025 00:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fe7CKmxy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4F224A076;
	Tue, 18 Nov 2025 00:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763425790; cv=fail; b=b+sy1fnZ4PxKDD1sfB8R5rll3r4pWIejJjyTxjSazGOQsCWCQBlIMBPQ23qdfoniTJB5TwP2lSFj7uQSr6FMq2BVUwnUBxnaTECoqFSoYBW8vE0mb/yc6QfernFjpg6OrbWdZ88inZp2N16lS1+pWeryeaxFc2QMNbfA5CBNJIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763425790; c=relaxed/simple;
	bh=m0HWa60+s6dqBIFTa2YvKBD6GvotITAYFtf7fYYiKJo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UD5Lqvc8u3zmBwW+cAcaSeuf/QKh9KracKu9H9cxIFp4SVa6ReYrXzxoLmndnMyXMBG3rvhb3z824xveUVlJFmiPt7XZX2qDcgwvpCLuM32tM2zw0ow2o4sHDSVU1Z1UDlSXffHOPhmsd48Iq/PGdq+oh3/Xb0/idbDqsYVXe1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fe7CKmxy; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763425789; x=1794961789;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m0HWa60+s6dqBIFTa2YvKBD6GvotITAYFtf7fYYiKJo=;
  b=Fe7CKmxy7kyX7G3xPnpTu/7j+jw+NJRDGFnpu4AEVL95ZYhCzf7pqKVl
   uZrE323MuturWbgqBVI21jx7gS/UT/au03BHkxxtEgw8ckFjjMth0v55d
   ZondHbBumuaJzEa2Pncrict4Ng7SLR++7EBkwYBSQCt9kyKKjkTWurT/E
   qMARJlisPR2SykFw8IL70TQTH3pX+mmKK1sqkSKY7+BPR3f4uwF4W5lrK
   uyOTp1K8AitYvNifq/W66Q+zka3gC+mdyh2T5tF7wmCJIhgzZHE093BCl
   QnAON76c5T4UxBXO6ugnBqooWx+NnrfsoaJWZ5Yjjh79ia/AjeVQa1BlY
   A==;
X-CSE-ConnectionGUID: bGZKqCViTuqWr0QeSQYu+w==
X-CSE-MsgGUID: Ydk8sBo1RSarA1+RxMaNow==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68041314"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68041314"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:29:47 -0800
X-CSE-ConnectionGUID: Na1Y2qtgRKyXHwg1nfC+hA==
X-CSE-MsgGUID: quGzl3rYTlOOvUR2eLOnfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="190621560"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:29:48 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 16:29:46 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 16:29:46 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.11) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 16:29:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dkaOiwZJ5pVusip8+NQZ5qFIAM+3iIyXLxsU1wRChEASd0P3TwEKwJmCrzbvnBmkCxUDPxO62ZeZvbFmqtBPrD93/JdzeRz4sJaRCehvoAXjEIKYjrhdvZJ92XG/0YB8GUJh7GBNnKgGlvEgYUrWjq/tSwVjytcXT8BA7ferja6UVyMLG3WfZg7gtGV04Y5akSSsjysM/mmtoibl5348q/eFvUc+5vQunaLc4Ob2Ht/eFCimDHhudoZix5jsvhcjj7VOBzXELQapVcxdGPi8caSTjvDBphbp+AIfUcJKgxK6DNiK7D3aWi/r3UXfnmcO0rtJXpHl4EkSp2iZ0JWpng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Olzq9qgUQ7+HMB4ux0L86oyweP8ORT6fUgtCNLkIwOI=;
 b=bM4Z7vpVdztzYOVT9VD8nPP5WregT3Ke8jP91UclM9VgBwGQ+nrnOshRiGqiMIJO/MGAzvsTkBiBWTNdaP2FkW/2efxXNxP8/9193kDPHBazpplG6keuMXSTbW3aDoKfBStCL92LtXDGvwtcHE4mi3rCovkYVR1eyNidDOzHYOYkiSXfPGASPBwwTp69byjSuyrSyi4lWG3VD+m7qAR40N4nBFg4AN4/loQSreM1mLDuJldTLv71HhM9upaw0DrIFuBhRvwjrBcYEQzlSYYGcVB/232ykMK865BYqPkljuGiXFmwqjYnSAY1zCiOMcQ24V+14p/rBzUV++E9gFADCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB8749.namprd11.prod.outlook.com (2603:10b6:610:1c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 00:29:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 00:29:43 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "afael@kernel.org"
	<afael@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: RE: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Thread-Topic: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Thread-Index: AQHcUsnzy6x4f36ohkm++SV8i6qV3LTx7zWggACMYQCAA9kXgIAA9gOAgABTBDA=
Date: Tue, 18 Nov 2025 00:29:43 +0000
Message-ID: <BN9PR11MB527649AD7D251EAAFDFB753A8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRduRi8zBHdUe4KO@Asurada-Nvidia>
 <BN9PR11MB52761B6B1751BF64AEAA3F948CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRt2/0rcdjcGk1Z1@Asurada-Nvidia>
In-Reply-To: <aRt2/0rcdjcGk1Z1@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB8749:EE_
x-ms-office365-filtering-correlation-id: fb3e27f0-a69e-4368-e446-08de263991c1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?mFa1kgp2PZHSB80N6Z37Zwhf0tZng8hUoTOSzEUojyxAgWwYa+Lh+WvOi/Nd?=
 =?us-ascii?Q?GFE/jWqLusNSi2NxbWSIOwooqmwjpIvNldl81O0RBKxdClTCLh3NsJFpeHdr?=
 =?us-ascii?Q?Ya0NaCBaK7gH4dBEB/wmzOK08DkVkN49IBpSpvzKInDx62MFCvkL9visJVRr?=
 =?us-ascii?Q?R2FEjecZ+coP3oWOlNP4/4Qsn3nhyx2XIU3C7df/WTuyyat+M28V4CimaJcR?=
 =?us-ascii?Q?ofRXIq9xezFs37tb2RrT/Xq9F4g0tBQLtyVGzb4fNqtbt7aqoWsHeuGOoyZp?=
 =?us-ascii?Q?Jy3JRf1nF6md/oSv9RRf1naIMmo5rRMDzuYhnW/pmxNd5oR4ll2mMN5zYwgs?=
 =?us-ascii?Q?3mTLBYcDK2K1HKemK3cu5fB+jjqcxCIwiQ+CFIcRvzqIGmsawcBo6ojRvQvh?=
 =?us-ascii?Q?b+iQ36MWE2hwiXy7CHdICuSnk3ITPtbqk6ARh4IUQXAY+p8bB90UsYHCMhf+?=
 =?us-ascii?Q?zCafUIA83dJY8lE+bIyJ/t29AAknpZA+uqULiYvlhoLCSPiew4Bl+2l2P7PP?=
 =?us-ascii?Q?VUgj2wZF9oxA2OzgHeHtBiUrDF3fIikoEutcEEZF7nMrRJ+WBdEG9Ou9/u2L?=
 =?us-ascii?Q?+f79Sy+/YbzbDKWWe0xCG14U40GAfEvYRD054NV1+4Mf+dF2hlTYo/lQjWnU?=
 =?us-ascii?Q?ggWtdIDoJ6T0zpdHBbl8wq4+bRcGDOtEVU80xuJ3SXlcIbO0/aT1MK2bQqf/?=
 =?us-ascii?Q?VEQ8C0Ds3B95vJRFTHiNOVPYnbtt0I2sJ9JqWwR6TGcvfCf/fgiYaOnOvIyh?=
 =?us-ascii?Q?utmtGasXaTixt084hYBNj2MDiPjGYfY7zPpsaVk5vxp10earc4SqyDzdthMP?=
 =?us-ascii?Q?pmMVWsZMxwgm2gCSMRw0vg7FIhZSWc8Gy4AZXFgVNvqqtJ8Q9XYSdED0v7NT?=
 =?us-ascii?Q?7LLYNGzsksgTpkVQHwLH1RfugKLD56eL9aYV+dAv1gwHH++VZG2xMOUz62wq?=
 =?us-ascii?Q?uaWNBdFDkmimQbKC6Irl44wG6mRaknoEHgwplp+H/cY6/22iSvVyCy6OOx/o?=
 =?us-ascii?Q?aMUEcRvcapBQ5A6odg4YnvbyFGV5yxOwVv7RxBRR+yzxutfX70GkHq8fbFHI?=
 =?us-ascii?Q?81p7e1ekWIhzHiGd3gEypAy2L6fbh6iZaZEYvL7RYsfurbD5aRDIJj13nDXX?=
 =?us-ascii?Q?MXBsVsKLqECofpFdlaxBrPbZaSToSqs0eCvSwhFG/vUob98A9UoecEIApPQz?=
 =?us-ascii?Q?mFm+hvQ0sAuM5q+Wu4qeLNXCM06k8cmgJGIGCV392HcnoRM9gl2Z1GLphi7I?=
 =?us-ascii?Q?lTvTS6eCCkA8xoYVFUD3ytkFuCD9WtbsKy2KDF0iwEh9iV9aRAAHmSESotVO?=
 =?us-ascii?Q?angY7xqtzjy9ZIJbWGHscc45xv2z8I+XJEYsdOE41VMdOIXUE6ICzoNmMngq?=
 =?us-ascii?Q?EL3dvH9atbYTSsUr4ZmmHXrt14zRVMUUioo0Op7Vpa445AYvfdpPrA/xOHpL?=
 =?us-ascii?Q?4AhfSxfYLTCZwkVifLUXoVe76uYS2HAzObc+ZX0IoAVj1W8X34jkp0nBCVZg?=
 =?us-ascii?Q?MRrCb48XUwm064bt5Zoq2WyU5DsS92f3NAuN?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MHR+ZAjGuzEdQuzuHz381CEZmE5+099Bv2E1Yke+d+JKPCnNaAlPcHuUgn5k?=
 =?us-ascii?Q?o+iaNhLkJd/yVOUGGwyPgmQZYTSAZCF8CHI8S2E4AxydRFx7qti1s2B7UiDj?=
 =?us-ascii?Q?moY9t9uJ7z6LNGxln5o8GoI+5hx1YmH2zG5+5YExkq/8thLPmFjzsvkeaWwx?=
 =?us-ascii?Q?h8wvj2z/k0ESRx2pfjD04IOlLE5zKtGHlj/R5O1NxMhJWYROqsXSbq/zdDHu?=
 =?us-ascii?Q?BvVZjIByTyiAyn0h+9Ndu45WsPE+toiIN6JrA5JYiPwYWuVuMimdkjNJeiJm?=
 =?us-ascii?Q?pLMXI9wcZkezsow9VQCXHk/11KuInTFj3KLrLSjVa4vRdyrvJ0KXbGLtaMF3?=
 =?us-ascii?Q?no2TqZiZvLhGNhBkCBOviWxGbtML+I2Zz9mAvHChGGEbyjdCv1hJ4T4AaWpa?=
 =?us-ascii?Q?YQh5Y+ahrApMdvrVZOivJUZKFavOq82XKwc0erNQcmV6XkEkkZRETyRJXwTR?=
 =?us-ascii?Q?lvWnWzXMcIuEV3mgyUB+iM4HOE81NKnwUVBTVupv5eEMJcxVbGlzdf5CX8HY?=
 =?us-ascii?Q?ePwqTTtBPoyvqRWyngTM4HdFxydgx5kDUIDX99tyFSgPGBnexnV+4x0Xdbe7?=
 =?us-ascii?Q?+EMm2AEAJ3QuUm74jA0VuXFS44vHcQZWgkIiTRUt7pusWfJBSeF5u9j7zvCv?=
 =?us-ascii?Q?r6+SQeTp1NhVnJ10/t0h2xeuqAHtuzirtPrRtPoo9ZEenPaPPR0K/1KUJFu5?=
 =?us-ascii?Q?E4rjuOKxmG7ijyo4fzgO497pk5N6O3x9OfujJebcUrs1BxOBunxL8Drt/hVH?=
 =?us-ascii?Q?Ggl0CaEjz7zKSSRw6aQrsj3r5zg5NwpZy+NKxKCBH7nfliboEmvAo4Jag7MD?=
 =?us-ascii?Q?38YUJkuPWf42sgctYUVnwNOBA+a6uh75h3bRLKv/cRawE5xFWD1tIz75k6bi?=
 =?us-ascii?Q?aUIKawmzwYS8oKB9pLUAEAHyfgUKDyUmsoVEWfSE9BWCi7Do2t7ZgG6UMAGN?=
 =?us-ascii?Q?x2hJwTn9fyVgFUEHiNl2urw3dleCRJkDq7DFGnCbBMdqZzq+7cLoVkIpInYr?=
 =?us-ascii?Q?3sr7UCDQw5OingW5YB1dpobNNGqchWsdsf9VFHfl6eoJ1OfpE2O/YX+RCMmS?=
 =?us-ascii?Q?bN0ck1b3cKUNPDVLRQquEM475HD+pm1bSpR/VMStcp9eDwXzcmLRktUzoox7?=
 =?us-ascii?Q?B+Ke+J3+U9FeHMmE/Re+UGtFD7S51P4bJ4CzTxGt9agnxDYKq9+5M4P7xFkG?=
 =?us-ascii?Q?7GovIPopRPza+PjYV6HU4rNwQJiKdky3WXMqtj2evvtYzVxQ980N0cUhbpzV?=
 =?us-ascii?Q?7gtmJRvdmM6Lu9P9UOppQVN6Dnr4NFssHz6kvwTt0YFUMWB3oEZBbCpdu0wm?=
 =?us-ascii?Q?N9KNfdFbNIm0iqEz4Ee+r6OafatVVCk3eGzA0d2zbeGg0timNI6nGgl1QL5x?=
 =?us-ascii?Q?cD4mGPlOUv0mnIe+K3ce+rg09nvw4MhoyBfjtDRKH4D0FWpKRyJUq0e6ZgCm?=
 =?us-ascii?Q?GYijOKRq4zRk8SO6zwe0caXfr3OMvY9Bs06OiKRicPFzfWUsjpaOhGNh+A9g?=
 =?us-ascii?Q?Xfs6HhY/ny+jVhhLzvx8QVkEAlciCH958n5Rtc+mMHifLG2ujesLWXydGLRD?=
 =?us-ascii?Q?sUdNkBHmz/Y/I9heBmAakjpiN+bbuHAwI5pKeiOZ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3e27f0-a69e-4368-e446-08de263991c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 00:29:43.3195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UtsXRhHqy/9h64mFzZO8XCOTo/mbfF0LcIduZi/eHhYnChBqxG7It7Txu3XdmGGi+oZeEz6ahsIMFMlj0SysOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8749
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, November 18, 2025 3:27 AM
>=20
> On Mon, Nov 17, 2025 at 04:52:05AM +0000, Tian, Kevin wrote:
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > Sent: Saturday, November 15, 2025 2:01 AM
> > >
> > > On Fri, Nov 14, 2025 at 09:45:31AM +0000, Tian, Kevin wrote:
> > > > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > > > Sent: Tuesday, November 11, 2025 1:13 PM
> > > > >
> > > > > +/*
> > > > > + * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software
> disables
> > > ATS
> > > > > before
> > > > > + * initiating a reset. Notify the iommu driver that enabled ATS.
> > > > > + */
> > > > > +int pci_reset_iommu_prepare(struct pci_dev *dev)
> > > > > +{
> > > > > +	if (pci_ats_supported(dev))
> > > > > +		return iommu_dev_reset_prepare(&dev->dev);
> > > > > +	return 0;
> > > > > +}
> > > >
> > > > the comment says "driver that enabled ATS", but the code checks
> > > > whether ATS is supported.
> > > >
> > > > which one is desired?
> > >
> > > The comments says "the iommu driver that enabled ATS". It doesn't
> > > conflict with what the PCI core checks here?
> >
> > actually this is sent to all IOMMU drivers. there is no check on whethe=
r
> > a specific driver has enabled ATS in this path.
>=20
> But the comment doesn't say "check"..
>=20
> How about "Notify the iommu driver that enables/disables ATS"?
>=20
> The point is that pci_enable_ats() is called in iommu drivers.
>=20

but in current way even an iommu driver which doesn't call
pci_enable_ats() will also be notified then I didn't see the
point of adding an attribute to "the iommu driver".

