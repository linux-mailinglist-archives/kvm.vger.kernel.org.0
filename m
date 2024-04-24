Return-Path: <kvm+bounces-15753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 957958B00EF
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 07:19:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A41D9B22FFB
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 05:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504F21552E6;
	Wed, 24 Apr 2024 05:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WKm+nLOK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925F415445E
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 05:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713935977; cv=fail; b=XcDbU3CLDYM1Ww2i7tg+atreKKby7420Vq3TRc2l8wG8feX69wImxKenYj/Fm0HzLWXG7ntWfR1zF8fxo6eF7aJ3h8gM6D9tE9ckLR2qh0GFhpqn91UK5yW2LOBZ8TdbVNk+XA8DMcIM7fMKX8k1Y1PaGqBECRy5rpGEZxip4po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713935977; c=relaxed/simple;
	bh=plAu82mSZaBM1MOLD4zjaVqJw9W3lc0QIsvSaKljHvU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bs1KgHXBMsf4q2rNWyxBJ6F32CoQe1/Iux4OXMVieJHnVF9rT6Vl25gqWOqg/AliZMP0eq03jZu9rIWgjuOhgBPwI/GcWZAW/if4qnE2gFVA2gFjz3uLkxVeJ/s9NiEny71CkyYuqjSY8JFlPpKoDsRjzMI9sg4G9Gyjmaqv15s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WKm+nLOK; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713935976; x=1745471976;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=plAu82mSZaBM1MOLD4zjaVqJw9W3lc0QIsvSaKljHvU=;
  b=WKm+nLOK9nKRqOUsgzbchQq7a/NKv1oA54Ixqz4HEliolJWLhWZ0tX0v
   BOn8Hog/Cm77cthMCC/rc19zu/c4YKyHJ9RYgdxbo+dVcuFcxq6CTa0l0
   LjG2cCCXa+J9ojdVfRqnYBWZRjYE9PlE9t6M+WavVkhPf39OwVA9+tnnz
   oXQSMGHUcvzLJI6SPRnfjHEUq6tjE6mGIjajqiENU3xBwOih3IGcYDGMF
   G4/5VfgroxCLLwL2kP9XwTAMxMOUxa6fle+9xVjniH5wV4bg7bGR2iAlr
   yufvHc29qCPKwvrQ+7orx2pBFIy+VHZ6kz/23wwrtGEcCvCMUE7/XfCV6
   A==;
X-CSE-ConnectionGUID: Coiew63xSMaqnjmscpLuLQ==
X-CSE-MsgGUID: YWRfUaTfSMK5AA2rJgEefA==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9377023"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="9377023"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 22:19:36 -0700
X-CSE-ConnectionGUID: jR0aXrDMQX+jXDnYVGhnfw==
X-CSE-MsgGUID: UdVuGUFmQo2RoQ2j4q1QKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="25201598"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 22:19:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 22:19:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 22:19:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 22:19:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 22:19:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFmjP0yMc3i8ODIkQxo9uUFRhagnibsvnquiwsz5RleEmXiBELzccATp3hjQwG/jm8W2vzi9GHHuHNYZPPAYY0kOKXWxdjDY0TYMxwyXh+yv/lNRlzyvqG+75tPbz+4HH35/uKKB/9nAlpsfvi7JeupXjG55242eVAbJge94cKnWZBrn9OWzM7kt4VcYFb6pxEtHVqXARGi31iaFczKZ46reG7DYMx/Hlg0ons11G7H0+wy2KVDgFY/E1tAqOgiiynaNNZFB6xWm5eUzIkg4/5ifuQQ3sCaYZiRNzp6Z/EtQRTTziG9LaE3r8W59P1Fz19HfWz0/8+hpTeFZLtuHKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wWjAwtBU/wkKbKUgHhMcnx6+B7ywcMMc/23TALqrtMg=;
 b=JuSqESUBFOPaFTkULV79LERMf8vxpCLlsmAirF2uXyyWisQ9PWXlyiYHV3BkAVelqzI3ud7jgK5HC//YW/LKjqg+CrNJbSjaTInmjY0zyfBD9WZeMAPDxBQwyt8zkvVztS66lPDdXsTR5mS/yScepZrKk8K3QQ9h5pV/kumBcqJBbkfrlO0vopAKcJnrHZ4seKY2kqEAi/3OpdPIejPPruVv/xj2B6/RSFSSPpBWMBCDPT7iByl/alPhwNoQeOWgDNaMinx0YU10hwwebB/whIZkHBnfWppbvwNhyoVRJjm92lyImIxx2ldTuZ4lLc2F6HZo8m2cXvDyUaA2cZ1grg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB8240.namprd11.prod.outlook.com (2603:10b6:610:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.23; Wed, 24 Apr
 2024 05:19:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 05:19:31 +0000
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
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIIAAuGoAgAWh6eCAAFrQgIAAvzfAgAAM8ICAADG0cA==
Date: Wed, 24 Apr 2024 05:19:31 +0000
Message-ID: <BN9PR11MB5276183377A6D053EFC837FD8C102@BN9PR11MB5276.namprd11.prod.outlook.com>
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
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB8240:EE_
x-ms-office365-filtering-correlation-id: 40d8593e-0fcd-4d63-3810-08dc641e1f34
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|7416005|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?+UepaeRcHCNfZxhoJWUDyxcexgJDDMM3mVHO6EMDaoI1aAisAoBm+vokmpfM?=
 =?us-ascii?Q?PeASnV9CzFTmNdYeN431LTchLeGkaeNbCQaNUKkw3+uxlOCbKciA3/tWfLbm?=
 =?us-ascii?Q?LiNYJVHzYIvlKrdjhZ6/2u9dEqUAK0I7SAvr6r95UZJgh8+z1c8sqE0o//kt?=
 =?us-ascii?Q?pcmlFIqWqVtMpfg56u23XjYMSogjIG8xlD0M5DEHS6gu4AsH6OnZF8T6w6ku?=
 =?us-ascii?Q?Bz0l1vvjDT56l9Zyzlgawk0NKra7/+ThC1ipCk8ff5AID2F4TMmkKQM1m6Kp?=
 =?us-ascii?Q?WP4jfHN3LLyvkz/VIhppCH7AhXVCSdqvoCtzbt7Hp0uE1St7G/0MItpBQ8V1?=
 =?us-ascii?Q?R2uoK3Zjzszddz7XdmIWV7YWzld86pq6rGWs/IIkW2LQWndgr/kEUI/ZyNzv?=
 =?us-ascii?Q?GETXQ9Q6l65uNzV6zbl7oIl7gP6kSXrqd+vKzy2s/ZjICmJi6JcjJSLf0NEH?=
 =?us-ascii?Q?mQuyDx29+plbkgqwBXY8LanVcRxGlTAC2AhdH15wewIb8/4e2rDdtr2u+TWZ?=
 =?us-ascii?Q?pg5XdtqXV5s3iAZyaecqPy/4AAZnSN+1D4VQnvl4iwB7r/RHviWb+OvwepxR?=
 =?us-ascii?Q?ECwFiSJ2XpaH5azhCmRzUOvLk3RhWTg00bhlUkjB/QFkqJQkXXrW7HZxY1ep?=
 =?us-ascii?Q?nuP0sAPyZtN03g/L1GP9MeaeTcfLv7nLAWEfHgUDfPGYFYs7Itn0rLcgH2NY?=
 =?us-ascii?Q?ouTJqndKR5Xzcr6/iXuPCzv7WaO4tZA+AHQPzRuhK6V3gJN/TrNLnaF21IRd?=
 =?us-ascii?Q?T7T0csRQG4d1C5bvVc1MgfrznRQp6jargtAww2fjmQjeWXMxIORMWVbLEIpt?=
 =?us-ascii?Q?Zg02k8Wo9haxc0EKF4oTK4mqo+TkqqSj27XtPpLk+Fwb77hKAfdSLVsPVvoR?=
 =?us-ascii?Q?m4TunCOtZApkfcz80ZeAxuenwoVAch5nt9PWOVfW3BXg7PpUijdwLl3y3UTW?=
 =?us-ascii?Q?9Y5spQu160HdKerr1vXsDvlLEdtLO8PtzsaPUQPCZ+aj2Sz0R4irCJeRqis3?=
 =?us-ascii?Q?J+pPHkjRCVq2yAjlxXmYSJSg0dWDAh8ntbN7EelWrKWU58K96vcRamZFvd6k?=
 =?us-ascii?Q?Uw5E6wUeqN73vYXWD9zmUBslcQh5LXWmdrvSAEuT51RdZJyFifqYqYbwf/Lv?=
 =?us-ascii?Q?f6TKQcEq9+oAccZdeN/UFSp2p7/Gue+lb3XHdyuST84YrPhVllgraHv9kOfM?=
 =?us-ascii?Q?GLWJy9GiWOO1Lk7algGELmxMuY95nOhuwS6jPrY8qbjnZcTcItsXGbdJLP4W?=
 =?us-ascii?Q?H+rWFnrMj+J+HTOPGiTtGr/zE+Nlyrr//DgyY3KPY6FTEQmTXTDh3+/w7X3s?=
 =?us-ascii?Q?yujvhzGwRk1YkLQIJmIxpQ5N22oXbU9Ezcd/7/RaNW5CEA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rEFhjRtl/3V4OjbPTONO6pnakLhVJBhZ0DF4IPl3WGDJ6NrajRs6wugou2if?=
 =?us-ascii?Q?r3V7hPjEVeTqP/2BKrjYrvmJVdIa/iKMnOHXIopcGqzSg9HSaVO2Xj+4Up4U?=
 =?us-ascii?Q?GRw8oqFZxfosGtN9r3ZOm4kfyWyFgs5GVWKJIXC82zXZapGVQbY3l8hUYErz?=
 =?us-ascii?Q?irY5CP2YuqxbMYkGVwk8KVqzdW4qifZwj7sc8GEzQVlD/OULxKHBv808Oj6d?=
 =?us-ascii?Q?6m4Akn91hado4dvdJt24+aJF8ABdMGlQT9bUnerr9LQoDBRW2WAaSlF+lilu?=
 =?us-ascii?Q?ekfSgOLtsxpwrnH9GpDXl6bi0wIoHHM4gVcdKR2uyQqnE6QRHW/tZgaAC8D5?=
 =?us-ascii?Q?PcJ8+LJ41Ft4MUAdBiAgE1J620i+dsVyp2bDAn/OrIMQffOt+dFdVHC1Ddk+?=
 =?us-ascii?Q?Pys9fvOxD7hUCsvUyIR0mxyEm70awrtNnKZLbqo6e3F8qs1sx4gh8lk6zvGc?=
 =?us-ascii?Q?xfL+xHEel39PSRV0xXETlMJXFiqXo8zXaN5ZZCMcAeal9gzfgql3xx/17dpW?=
 =?us-ascii?Q?bvjiZxM9tdtKu5tLMck9JF7AsoRX/vQWCXS2LwRiDgz5XhzvvEI5pRgZ7Xbm?=
 =?us-ascii?Q?bz5sGTgltGVXZkDkalPbzbu6P7eT/7tViPWe+hXnoxksQftcuMh8u8T84xfj?=
 =?us-ascii?Q?7HsPwv05LNbG38DvW/kzTc0+ISvqcpcl4BsnU8IqeUdOL94PbYtBFCADjatw?=
 =?us-ascii?Q?DcKm+NzwKNYKwBuJ7eg0xoEhd0KX1N7AwbYWxA8SHCoBTnrZaUqG2+FGGwzo?=
 =?us-ascii?Q?jFxzgC6fOKcGbScn7XQoZMnUqnSwlt3bXiHQg0LRD7WIThBLXyglByK8xM8n?=
 =?us-ascii?Q?OjyCozOwr1WJ7KZJMHJpoHBTN5TJxXzPvMg0GfM9k+Apd/diEZEGEZe/fk+R?=
 =?us-ascii?Q?R8sOu+BwhbYDwOJTGKQM8tpKYpeK7xo3Y9Gy0dE2IaN09lg7uYBf6KlPaLUY?=
 =?us-ascii?Q?CVraXNco9xcB/IEGSEvN803pv7wz5ZTC9dke8t7hXyXVky7e/QXg9sDz3cw6?=
 =?us-ascii?Q?7MxPAr1nKR724t6LRLVCGXwNRn9hCEXFBN0bF2UQM6Jd4mgkL0IyPTIirF02?=
 =?us-ascii?Q?iW4spvB4nyBrJhIrIkU7amHW6xcWFAWMI2JWRXf1WCCJWimXFIX3hR7Gc3sH?=
 =?us-ascii?Q?U6C+wUa51cS8AVC8QHYtfgx11iSRzqQjbKDjXakeovY/ghLMQB0QDVZu6Lry?=
 =?us-ascii?Q?efb7fzFg3hwUepL9qIdQ4JNbaJpC9RihwSRSlS8bQ07lu/nJxlZBVjoHeCAz?=
 =?us-ascii?Q?82n9Jap9eI0Dab4vkBYChp9lA/ZMHgqXkdKnhhlfljiMcYyjYSVPMNqiSnuY?=
 =?us-ascii?Q?QpoLvS42LnexmasSjRzjkMoYa9A4D2QPdzaW7Xka+q9OPlxBBqJaCtprhiuq?=
 =?us-ascii?Q?uGQfmBp9JSd5tKeLk1QCs5tdsq2liFZ1SoKtUyf1QG3UBqkogjRsidoAZsv7?=
 =?us-ascii?Q?FLjGVJJuskhnq78OVx2bb+722h7NWkwqfnIjUB02pcnBhArvS/kH8nfyL0IP?=
 =?us-ascii?Q?nPtmuOR6Aym/8QfNKugmW8hwfJLzjodFfqd7Ke/PWV4jGfQH4p2V+hK1KCtL?=
 =?us-ascii?Q?XD4tJ+KPhFFNI1+gBn574ao/jj5+za+0CUxYYxii?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d8593e-0fcd-4d63-3810-08dc641e1f34
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 05:19:31.4682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R7hNmK/UCQqvpwgm8qLvsoW0g2EEmo418Vpv49drV/AHog5m6J8PUWuUJ5l2O842aiQHzfoXWu6ju4a4Jq3U/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8240
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 24, 2024 8:12 AM
>=20
> On Tue, Apr 23, 2024 at 11:47:50PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, April 23, 2024 8:02 PM
> > >
> > > It feels simpler if the indicates if PASID and ATS can be supported
> > > and userspace builds the capability blocks.
> >
> > this routes back to Alex's original question about using different
> > interfaces (a device feature vs. PCI PASID cap) for VF and PF.
>=20
> I'm not sure it is different interfaces..
>=20
> The only reason to pass the PF's PASID cap is to give free space to
> the VMM. If we are saying that gaps are free space (excluding a list
> of bad devices) then we don't acutally need to do that anymore.
>=20
> VMM will always create a synthetic PASID cap and kernel will always
> suppress a real one.

oh you suggest that there won't even be a 1:1 map for PF!

kind of continue with the device_feature method as this series does.
and it could include all VMM-emulated capabilities which are not
enumerated properly from vfio pci config space.

this interface only reports the availability/features of a capability
but never includes information about offset.

If a device implements DVSEC it will be exposed to the VMM.

Then suppose the VMM will introduce a new cmd parameter to
turn on the emulation of the PASID capability. It's default off so
legacy usages can still work.

Once the parameter is on then the VMM will emulate the PASID
capability by:

  - Locating a free range according to DVSEC, or,
  - Locating a free range from gaps between PCI caps,

If a device is found not working properly then add a fixed offset for=20
this device.
=20
>=20
> An iommufd query will indicate if the vIOMMU can support vPASID on
> that device.
>=20
> Same for all the troublesome non-physical caps.
>=20
> > > There are migration considerations too - the blocks need to be
> > > migrated over and end up in the same place as well..
> >
> > Can you elaborate what is the problem with the kernel emulating
> > the PASID cap in this consideration?
>=20
> If the kernel changes the algorithm, say it wants to do PASID, PRI,
> something_new then it might change the layout
>=20
> We can't just have the kernel decide without also providing a way for
> userspace to say what the right layout actually is. :\
>=20

emm that's a good point.

