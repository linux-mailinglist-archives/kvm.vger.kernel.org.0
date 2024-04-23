Return-Path: <kvm+bounces-15734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 591D48AFCD0
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 01:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD37F1F23BD5
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 23:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B6043AD7;
	Tue, 23 Apr 2024 23:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hxDoqtWO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5C9367
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 23:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713916076; cv=fail; b=eapJdD1XxtLNok5PkW3XktoVuyFxf7W9fouBNMZ5dnkGsbJMbWnSuj76uZLyZ5p+1A25yRWwNMZ+Ik5EhA5hyty+ItsdbImROftmDCrlHwxHG7XqZDzP6UxJ9/8pfCFPsjolOTq//UAnGuCdsqNJMRzJIaH7UmgAE1jJ6kygVp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713916076; c=relaxed/simple;
	bh=Kl5Ya+g3qmQ/iOuMj07g/dbN6rZHy1WjCAvuLRfdE50=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ip0wgMM5aB5kqxMAxjdf189mMyJZFj4V4fX+bdGP7h7FktYx2UZw8Wumm8PXemKFlHjlU9KjdjRlKu2MP/OptkQHKU3msvyVmTp58g64dMBQLG//FD1ly37PNzfLsLu/gehHuImnG08NidNun0eDfMElPtfTYiYcw/aFKOL5v8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hxDoqtWO; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713916075; x=1745452075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kl5Ya+g3qmQ/iOuMj07g/dbN6rZHy1WjCAvuLRfdE50=;
  b=hxDoqtWOc+7/G46jaqHmENwd5F65rXQKOpJ+w56zEuSUgJLT8dH4OrPK
   Osru6KUljvZAcEjNCQvyvJfYzqvjKQS58N22aTT/pCQef0s8pX+qzOlc7
   ENh7jBFTeJDeIxjtaS5esaDPSZhRxH++SYx4r9n0hZGjefZtd4YltLx9p
   pb39NReosc13NI7M6Elrz+DDIImEKjvPUsChpPGqSgfVFulbNlFwLKL3y
   cVzwkwnp57z2EFvomyWgIkPx7fHxWE1hqg/APCOaF8cKYtJ4yMIjvAzaT
   LTUtOsauc7/fQPpq5dTt1qjt5SUuWgYczq3lpNsdD7UdBb9r1U9deJKNa
   Q==;
X-CSE-ConnectionGUID: rBGPkG4gTCGS/eLaTjy0ww==
X-CSE-MsgGUID: R61HUmGTTvaDUc0DHnFUxg==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9399988"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9399988"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 16:47:54 -0700
X-CSE-ConnectionGUID: slyxpy9jTtGaZQ6DFD6uww==
X-CSE-MsgGUID: ThMpuEu/ToefwrjHxiVMIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="55729448"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 16:47:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 16:47:54 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 16:47:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 16:47:53 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 16:47:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwdjbUNyRLAFmEReB/ZNYbH70Y+yH7/DT4LWQDBB3euMvGZ3EugiAYB4LcXftT7BFG4dfVU5oRBaNjvSF1lT8qRT8esVAMzlCCHTSpLICQt/7cu8WezPV1UEA59Rp2DSyl8LS4njlr+ayZRbguaj6rQEq0kXdcdSIivdBLj8Drva4xXNPMd4BDtVTjC/gM/HO4K1BKvfTSv+MZ063y/bueR27dKEhnEJ0NqIkS2QPy7Kz6x1divsQNWBziGvKW9Kb/CK4U964Ov4rAirjdVmBeYTSS2DJ9p8+kxTox3nI1fqFLWi1mkEtdJDuudzCORKIS9SdXXo37Dr+TOS8jSmHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvkTONnjUtLzrQwparoF/mGTIs0U7yQKLc1Q/xyAme4=;
 b=AcjY4l3v3PECjQ8ia+pcz2HBBtu30ws59c8SV2uYlEuEHvoWWgKN8RuFvYFzA320O9B/g9zUlNqdpuJiFGNy9WR6HqeKcLPy/tmh6FeZyDTaIsw2lI5kdDskxL143TvD2dVkA25m7iZ5keSkzHIxzzqMdC9FjbqnCVA7D+sqTJcBh4MoNDZ7KCaMC8oD0/+WiFy8ceRSgg/I8/LtxG+2ms9npdnvVuurrPiFWnvp1bUB1r74y1x38GU3tmEqJhVNYCPCbdZWmIN2YiqhTwtREmWTFq6XqmIj7QGSCAUQdl88b5Os991JIet2vBBLKs5OwEUrZEThZnXJ4cfC2v75vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Tue, 23 Apr
 2024 23:47:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 23:47:51 +0000
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
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIIAAuGoAgAWh6eCAAFrQgIAAvzfA
Date: Tue, 23 Apr 2024 23:47:50 +0000
Message-ID: <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240416175018.GJ3637727@nvidia.com>
 <BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
 <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
In-Reply-To: <20240423120139.GD194812@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6522:EE_
x-ms-office365-filtering-correlation-id: 3bafb099-db35-472e-4838-08dc63efc997
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?AE5JpAtIXY7tbAn+9EMii1Pbd3VYo8D0iGXl3mZSTyVLz8nyAz4lxu+QPsyQ?=
 =?us-ascii?Q?q4ByRWCvwDTj4fSYLI6FYgXfXW+6K4rFHPJZqzuavbbkd0S1H3mtRJjm7Ziy?=
 =?us-ascii?Q?aYvPBNTGZz7Fc0nIbnex/TaXp6GHl33I9eeCQzMk6FKUrmztyJ+LZmJK7mXS?=
 =?us-ascii?Q?z+26MMEfDvvlji5Fcbm/18HUyfYvgiuo/rcAPJAEXjGjgPUQz6mn6iYuri2Q?=
 =?us-ascii?Q?5Qp5cB69w3e314KvHCVLrJZ0w0uX4t+cfg79zd8IjcNIMbhRGYZ+QxP1RzmP?=
 =?us-ascii?Q?6hOsxlBFz1AoF83Qnkbo/HyVFbD0XmGVn3wAeuYOqbyaZhBNGg8HukWKn+Yx?=
 =?us-ascii?Q?tFa8N08DvctPePbT6kELD+WVyBCTQCjBdwP+RCLWF80KFGYO+gRfR7moS9QJ?=
 =?us-ascii?Q?WUuk1kjqf/8wu7uAlwSNQB8MBKdaiHoaP8uVxJp9ic72ae2EhhURCXNvRwhr?=
 =?us-ascii?Q?yzGLArwe0oImqaiNrhDE/GgJ51GB5kVe6X5R9L0R7ol6C6qCBrDzUoeEOitY?=
 =?us-ascii?Q?C5ZScQK9hxa77+xhZDCeDQeE2+1GoU2KDn2Otsk8d1QxtmBRAEg1W0p65uCB?=
 =?us-ascii?Q?ShIIZM6Y9lsroNvKOYCA6ssPNzxWXm2S6DUz+MSzVsag5wznNpPDvjO3jRuo?=
 =?us-ascii?Q?3hFhGky22hf0UmkMHO8YGyEZ1DGFVHYLYh+b4u1poMRsQR4eYEchhX8HUN7R?=
 =?us-ascii?Q?UD3TUtbj71GgIcA+GcWwE6EhKEmoH2psihVjM746aFfkiBm0aCp1b+U0SvQH?=
 =?us-ascii?Q?vkMJfxfqrj732LULHEmcJN6uozxnvx2GaZfRWb4i/C4Hizjm7XZUdvW/N2mM?=
 =?us-ascii?Q?T8sjGtrcimxhAymJJoXNHYB48HiLoFDD4CoH3xzTl+QPEFhpOTVNquw7mPEE?=
 =?us-ascii?Q?sdol4uJpn/oK/JtfKM4c5I6G2/2Nhmba8YTA5nN3iaBOdNMHZTYVg2V5nnGE?=
 =?us-ascii?Q?3TiSVrvdthFI68pgkg7dm0PuMT9EHbKWODc4VgFc8ukTZB34lCRkORRwEQJC?=
 =?us-ascii?Q?rDQfOaltc4NlViKnX5l4uooqjLybbWyOgWLior3NlDteymXuvgr4E69yulY5?=
 =?us-ascii?Q?mkU8lCXZKUena+dWlGWPPhrhHmd4hcH9I5MUDVfIUr6lgERPCGdEkhC5D0If?=
 =?us-ascii?Q?EFYB9Spt8nBAYFPM03INt6kJzee8DNVjOUHR9I+RtxKgL4UAOuotWKsN5qR0?=
 =?us-ascii?Q?/T9l5RJsz4NcBQrKEVkAXrUynHzF3xv0mbFCn9QetxbhZE34upprWlhFxFpY?=
 =?us-ascii?Q?9OLZI00tBp53S34xkf6KgMM+7Z+YWXf9e1rbcg7XGXCQoAhBqjgGEUaZKmSR?=
 =?us-ascii?Q?VhCiAqK571GcvbMWl5IBT+MUw6Pa7qglzY5nKuz61Ib0Wg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uxz+ztUCshnLQqjpitog4hdOZ6bBJZ91jXgCZK2mcGSlO4Ni5HDC6zisnz+K?=
 =?us-ascii?Q?xKxSCegmngC/bzeczfYrvLvAgJ5S+TcefE0PNlYyEQR9X0ZQOLLZ4xiyMU/z?=
 =?us-ascii?Q?0hcAa7ZKL5a6S4kLDgu0nHMA33SdVvaYZCO5nEi52WJ1yaQH2jMlfDu8fA4y?=
 =?us-ascii?Q?MbueLZ9oNbW7cvdjemJ4tqtj65aYU/DYYZ0oYEHDtZWefP3QhzFpYQXyEkIi?=
 =?us-ascii?Q?sARTeCHVmOHp0mTNcFNmyfCWR6OYHxZVmFGNcnUDgTwEbokrlo5C3lYHHhA4?=
 =?us-ascii?Q?eSZhGJKU4Bb9dDBpQJ/bMtt2WS1llujKwfy/E4LigI2R1G+FgYH842zgWh6W?=
 =?us-ascii?Q?Y/Fx2t4BHtUOpsUK8GRPbUbiWP8Zb+bbikQDmYube76hI38h88IhbKmhR7ew?=
 =?us-ascii?Q?A50RtHIsLhAB/gFuWELV9PK6sT4OYJtRi3m0EQKflXVb1AlV2zci1XLouTTr?=
 =?us-ascii?Q?gwof7yWyG6hfleLH8/3hRSDNf6xW0XonLVmtDR5Njl8zrSlGrYOnQ3vqOiRq?=
 =?us-ascii?Q?KsBqpojubZ2iFDGQXUPPQbKlcS8bHG9/WCZskivjKgdWHGvJMCbbhXr7pwQY?=
 =?us-ascii?Q?YX3M8LnWdY8OgIuvBdGpvID1Rut6uZXYOOVf12kQMkt9UJAqvpStQKnjJKlx?=
 =?us-ascii?Q?+DwPQ4wMOu82c4+mrCudMsXecy6RnCCcfh9RLXRBswIUpMfRszLGQCpzbHm/?=
 =?us-ascii?Q?gkdyJJLr2r0tcQqZv9YHEvQQZIjEcuH+7ii3Kl3dhzzZ6SKD27xiCmywjAh7?=
 =?us-ascii?Q?EfKYa+ksjn56sF9FbmCDpiG3YcZhnkOVb5v5vEBDoiLYa5b57GCn9OcqgKoe?=
 =?us-ascii?Q?vviB7IAJL3QAOvARAAXnHtIM0ccaqQGpcBMAJAZFObwDvX38GRUg2hYMqclS?=
 =?us-ascii?Q?m5w3K11dIaWaipidJ3RTGOZTVJm5iNugS4So7wERUJVWtWUAYtszZjsL4Lj7?=
 =?us-ascii?Q?sSHSQdJT90iNbLWhqGGXajQx+pVbkIpYs9SHco+KhHIVNv4QohLdqZONdPkc?=
 =?us-ascii?Q?lIOBESNHIDcmliuFqygku7yh9+gw8jQSmhVkbLkthSQF9kcK9r6aOl+k7oNa?=
 =?us-ascii?Q?dO91JugcEF0epjHQvBKWNP7jT9N7Lw0EMCfi3ZBWk8xz5/BAMkLhOMg8r6sx?=
 =?us-ascii?Q?3pKEH8G497pLKfEI7DaurXpcYd9y3PuPF6LB9Fo7wSXT0BrR0qO69pmzFZRC?=
 =?us-ascii?Q?p2fGcVUn05Cwmp7ThkXWnpvhZ9/Iqvjkpfou5Lzzk/PbzLbQwP2Cxjn+8kuH?=
 =?us-ascii?Q?PVHgPc9nMf5OrzSxn+0Vr7dkVzTnpJIJ5jMknjqtOMb3Rk0pCEYTp5L1t0Lq?=
 =?us-ascii?Q?mFwMQb8rD8fxlC4ZdcEeYTW6WrS2YzWXMp7i1HUweQ/OZkxCsl23CG645NfC?=
 =?us-ascii?Q?NgXBO8nBxJr7Y7MjD8s9l9tC6r6+6zUWMqgFC25dvL8uhtnCTmLg/7peFaXz?=
 =?us-ascii?Q?OQQd7d/CwmDWlEgTPVYTQLON95k1hQK0f1dHYk6PVyWVnVADohwCGXvk60Ik?=
 =?us-ascii?Q?vSQZjaBj7jyLhNQE4ZrHg9ueSzI/qoZawEtq0LWmNwf3DavgSDYVX8vPMrN9?=
 =?us-ascii?Q?pdhOWsGjW6QARnw3Va/AIH9019mTG8esu8Gjluj9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bafb099-db35-472e-4838-08dc63efc997
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2024 23:47:50.9981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NZDTN3KpWCpF8MigPKtO9zWCdbM8nVTFqKnEF4Ev5e7+yZHJzLQfv7WPDnT0IWWOv+/GK43CFJBojQ4wlXVG+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6522
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, April 23, 2024 8:02 PM
>=20
> On Tue, Apr 23, 2024 at 07:43:27AM +0000, Tian, Kevin wrote:
> > I'm not sure how userspace can fully handle this w/o certain assistance
> > from the kernel.
> >
> > So I kind of agree that emulated PASID capability is probably the only
> > contract which the kernel should provide:
> >   - mapped 1:1 at the physical location, or
> >   - constructed at an offset according to DVSEC, or
> >   - constructed at an offset according to a look-up table
> >
> > The VMM always scans the vfio pci config space to expose vPASID.
> >
> > Then the remaining open is what VMM could do when a VF supports
> > PASID but unfortunately it's not reported by vfio. W/o the capability
> > of inspecting the PASID state of PF, probably the only feasible option
> > is to maintain a look-up table in VMM itself and assumes the kernel
> > always enables the PASID cap on PF.
>=20
> I'm still not sure I like doing this in the kernel - we need to do the
> same sort of thing for ATS too, right?

VF is allowed to implement ATS.

PRI has the same problem as PASID.

>=20
> It feels simpler if the indicates if PASID and ATS can be supported
> and userspace builds the capability blocks.

this routes back to Alex's original question about using different
interfaces (a device feature vs. PCI PASID cap) for VF and PF.

Are we OK with that divergence?

>=20
> There are migration considerations too - the blocks need to be
> migrated over and end up in the same place as well..
>=20

Can you elaborate what is the problem with the kernel emulating
the PASID cap in this consideration?

Does it talk about a case where the devices between src/dest are
different versions (but backward compatible) with different unused
space layout and the kernel approach may pick up different offsets
while the VMM can guarantee the same offset?

