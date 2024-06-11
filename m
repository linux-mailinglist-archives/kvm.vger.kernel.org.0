Return-Path: <kvm+bounces-19348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1690090437A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 20:27:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FBB71C23AC0
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 18:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83EDC7EF1F;
	Tue, 11 Jun 2024 18:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Evcgtpvc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57820249E5;
	Tue, 11 Jun 2024 18:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718130398; cv=fail; b=u9b3i1Gcc7h9gOLN11gHdv/kLV86v/qUhuqAia27m6KTlqEY3klwc7JoLRrSfoWoldKdhLQzJYkGB0n0ezYJ1EBgBeKeRq8p0PIs/Oid2BJickG61k88KxFgffIkouB3IzFKJL0IYp288/fjqlYdx3jdjtp02n2/0DxgCuSs4TA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718130398; c=relaxed/simple;
	bh=H3QbT/STaongwVLPhPXtIfTeM4edx6C8/1328aQfoUI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q3T05PqPOyYF06SvfQ9ogGM6Dp7V1AleYiQuZgxpnrS3SwY/utxQzRsWpbwALb3K/MaAcDx/8M84p88mhm+GtEni8EGinOy8fEaw6IWatLhDV9BMc+ZE56Ii0xE9ulwfGsibOl2XCMcN4+ZW4PAuSuDG3givtTXnovAt8vICfMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Evcgtpvc; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718130397; x=1749666397;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H3QbT/STaongwVLPhPXtIfTeM4edx6C8/1328aQfoUI=;
  b=Evcgtpvc560us+WwxYKMmaiLyg+VNYNJ4QqpkgiB/tSIQIRhNLvuANvZ
   CpLTTTlGPog3HXJe5mQnkdggZN61g+gUKVurluStSiNBkfElaAZ6tuhjp
   w3/L4fwUieiKDgCVsr+dN6l+dr0/lTYQy/wzCX6Ypq0cVmZbCDLwCFXI/
   wL9acTrCARqQVtEUXvCU5huWUeWaR0CmujFrRTqqRPOjj8YWeYgQseypG
   iQ+SOXpgfKe/PYl3eOr0d86s2AaHITN7zAAGicc7NMbpR+5xrQEVgoIL3
   fTV+9Cf5tO7WlKtrKu/8GqNODyTaOYJ22X214mn9f7qTGo3HT45gXb+M6
   g==;
X-CSE-ConnectionGUID: HYTSlCD3QJ287YP1V6E36w==
X-CSE-MsgGUID: 4+pM/gBLSrimGokUn4vB6g==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="25537537"
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="25537537"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 11:26:35 -0700
X-CSE-ConnectionGUID: ETAi/CauSgKZ4fTRal3/uA==
X-CSE-MsgGUID: KNPfxB1aRQGiRcxeIOIDmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="39627794"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 11:26:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 11:26:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 11:26:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 11:26:33 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 11:26:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYdwVL+9CF33bzymasEMW4Pm8xOc8CNpTq2ODUFvlKPXDWNqlITvoKOrH0cP2rXfvrmyZAaxd40NJKVTN51h13IGrSPBsYwJKpY5SO3SJ+qcPL+jrhCKIRYLgzTANrrHnvEn4ILzbF2LFrYtkrbX9u4zLI4dt5wurUqbwWZDieLGgyeH1JHovK17Jd2Cd0DbHCrrlVernFZz9muZM1QSmLdDeQRNqs3SRPxQ1XWDFwTUYSLI+wVxE/M5guyrnMomgoS2S6xG6nnkardLYQPCDrzXQX8QrKZrsrlul70pe/nLkNvDT21msomNSy2wVdqhO4jQQb8RZkWUOZO0GtsiTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3QbT/STaongwVLPhPXtIfTeM4edx6C8/1328aQfoUI=;
 b=DLxfQR1aySY1Wcudaeaw3vpBcGkMbL4vLCBm926vKqfxzW/W1MltsHtM6GqHs16MdfJjl0kcUulQWkwcAOWvihO9JwqXASRptbMTyzp03drINglWiC0Ywg/8QDvxgyDc5iFpYrThv0qxDWRs04Qyi3wxZRPN73AK6iEWbe0emH2G+WFL9EAs3o94MkEFMZxgishl3GMrPo1d4zezKETMYTseYO6OBUX806x4icHghHZAR15leMekQVP6R9hAc2xSgIgg6m3n1++wuKfnPEtrPUYpXNY+OtrciuCGqC7l7Oxh+DeIcDjuTHgZBWRHLhpgLwRdtaOTX/HwJS2zWvZm+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6991.namprd11.prod.outlook.com (2603:10b6:806:2b8::21)
 by SN7PR11MB7115.namprd11.prod.outlook.com (2603:10b6:806:29a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Tue, 11 Jun
 2024 18:26:24 +0000
Received: from SA1PR11MB6991.namprd11.prod.outlook.com
 ([fe80::4a2d:3dc3:a8ff:2dc5]) by SA1PR11MB6991.namprd11.prod.outlook.com
 ([fe80::4a2d:3dc3:a8ff:2dc5%3]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 18:26:23 +0000
From: "Zeng, Oak" <oak.zeng@intel.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>, "Robin
 Murphy" <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, "Chaitanya
 Kulkarni" <chaitanyak@nvidia.com>, "Brost, Matthew"
	<matthew.brost@intel.com>, "Hellstrom, Thomas" <thomas.hellstrom@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>, Keith Busch
	<kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Yishai Hadas
	<yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Bart Van
 Assche" <bvanassche@acm.org>, Damien Le Moal
	<damien.lemoal@opensource.wdc.com>, Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "jack@suse.com"
	<jack@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>, "Bommu, Krishnaiah"
	<krishnaiah.bommu@intel.com>, "Ghimiray, Himal Prasad"
	<himal.prasad.ghimiray@intel.com>
Subject: RE: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Thread-Topic: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two
 steps
Thread-Index: AQHanOEtbi0VHTnLn0mNwgftYB7xRbGEmFqggAEftYCAO5ykoIAAFS8AgAAFauCAAA0xgIAAMSmggAFFTICAACZPQA==
Date: Tue, 11 Jun 2024 18:26:23 +0000
Message-ID: <SA1PR11MB69915818E4DC6FFAD620D62C92C72@SA1PR11MB6991.namprd11.prod.outlook.com>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
 <20240503164239.GB901876@ziepe.ca>
 <PH7PR11MB70047236290DC1CFF9150B8592C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610161826.GA4966@unreal>
 <PH7PR11MB7004A071F27B4CF45740B87E92C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610172501.GJ791043@ziepe.ca>
 <PH7PR11MB7004DDE9816D92F690A5C0B692C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240611154515.GC4966@unreal>
In-Reply-To: <20240611154515.GC4966@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6991:EE_|SN7PR11MB7115:EE_
x-ms-office365-filtering-correlation-id: f329519a-1364-4c08-8771-08dc8a43ffc2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230032|376006|7416006|366008|1800799016|38070700010;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?iqUYgwmA6C6f6fCFwa56ZLzqM/fc+5mDkASIWGDlHWE0bGI02yLVydK47o?=
 =?iso-8859-1?Q?33z0gxWPo2NRi1wOjQ/azteRAgVbpukMGhTrjY/6wOk5i2n4MYAoWjdRyi?=
 =?iso-8859-1?Q?N+9gQt/wFG0ah0jYi2SvhRVXkk8tMT0E4Jk627Z3IhY5LM5vUkt2E60C9X?=
 =?iso-8859-1?Q?rNk7rnpgw99sqLwoM0RTuthyajXXybk0ZmGbVnhA3sMc0fMoSDs6L1rru6?=
 =?iso-8859-1?Q?5NNvB9SuQ4/wqArK+QmzYxXNYOAe77M80tI/7gUaQtnFW4BCrA4BHeW/iZ?=
 =?iso-8859-1?Q?3ffW9daer9DRs+wC3UixiJXM8yxGbmWB6XNlhz7nMzTNUzts4Sx55bvYAu?=
 =?iso-8859-1?Q?AcZHoeubKCQQIxM55VcndRyiihiSpIq0DOnkClWf39oZ4a/fnB/qUwf0ip?=
 =?iso-8859-1?Q?sSgTQ4aJWGugolvEwqZKlPTy54fYDKesAafElp90EUV83wJF2rZalAQpgp?=
 =?iso-8859-1?Q?keayqf8EszAXi5dXxDzaU58SLQrGwGSBhD5qD0vhLXqoArGP+qrfsKQDs7?=
 =?iso-8859-1?Q?uWy/pzrUxBBiHQD6SiVfjUR9fZ2P9RICpTiDyMvCxC6SXSz8SCd3En0v+Q?=
 =?iso-8859-1?Q?RbfpOx13i+iiwTChJcbS1PJSgDC8osApaJ4E9ILgxGHQokQqQtS6aCcp89?=
 =?iso-8859-1?Q?T25TIZpLlpDKmIBGnbqw+ae2x35dnn0XE8alN154BUeGe3BRMRuMk5xbVp?=
 =?iso-8859-1?Q?ynS7bmWU5Tc9nHqktf8qRlhV2HCsY5myE4DK3HBHE1iNO/y+3BVLsQVT/h?=
 =?iso-8859-1?Q?0K4ufNSdTWc4MeRf+q67+mXELxHCZOm4qD2mhzHQZBxVCN1iEhGoHsdVsX?=
 =?iso-8859-1?Q?JtXU6JLPdGjhjE7+qjrNB+Nx3LAsaz7nqBCp+6L22XSHFHqqOjcNs5TV9j?=
 =?iso-8859-1?Q?Y3uiRJp08AhUvuZ22Qn2U/H4PdHYpi/sWxYWLeh1mgdLzHkXSc87/vE9q0?=
 =?iso-8859-1?Q?XxsPgnUH/EsgRoQlk7jd2QUSGKPKamfbiGDrm66YLQvPbxamdZXCgDFnfR?=
 =?iso-8859-1?Q?uBJxpneaqUfAnhqmmw/B9+Th6wPJL+626RCWf0romOq/Ofc4GR4LHyuG6w?=
 =?iso-8859-1?Q?q01ZOJI6EZd+Aa5AbFXXw+JObp2Zn2gsbXp54F+3UCackB8UbNMrniC58B?=
 =?iso-8859-1?Q?hWY7ulLMhIxaL32hvQqxbMBERjcAaW1rNmwZ7XjTPddaDCn99m9eacKYjE?=
 =?iso-8859-1?Q?MKAunmYkS09UsC20Z8z7/o3D+PMvGGFpA6We1y71BG80XtlYGZ+P9ar+fq?=
 =?iso-8859-1?Q?1mU7EXa4L/EXyewsqUUour9D/2DMglXPV1B2xttsDNCBF6sX0Qwi+VgiKF?=
 =?iso-8859-1?Q?zNKVA2NHVkaaj3n9a4oA6jjKKvhPrVbYG9wjFgizaszgQibEjo+zhJhvMc?=
 =?iso-8859-1?Q?hIZJXfNeJlSKl8lR4NT/To7hPTnj9M5KQv/wU4pnas4OaGe8BzJT4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6991.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(376006)(7416006)(366008)(1800799016)(38070700010);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?MmR3hg8IsWJYIvQ71iVEWnAWp1lQ/tQaNJImq1Ka4QEmv9pFZDBum7n0Sg?=
 =?iso-8859-1?Q?SjVYcmWUL2yhK/CrSxRmoxJa9+koYjxmS7ytmHyZP2fHEqwtpcF+WyZQEJ?=
 =?iso-8859-1?Q?weG2Lpm3zFVh0Pqubww/wq5aPRIoHl6+2YeTEgpFxH7v6CX6PvINhwxAiL?=
 =?iso-8859-1?Q?RWKmB/kAsP4PPVuFBsGB40eryd7/szxpmqD1Yhdnwa+WSMU8QfdDoQTxan?=
 =?iso-8859-1?Q?kyQFZ29d56xRFhxfr1jscs3D4Zk7AZkrAjxJCiJrLq9xmiYahMByhGGg6l?=
 =?iso-8859-1?Q?QshucYdvJiyGInAVRT2fFFzp3u4CQW9HnktgYpTdwpmsnwZqk1B1qP8S8c?=
 =?iso-8859-1?Q?fomewPW/NV5G+igi0iDWZEi/iquK3C/X4bkD+FQyM8dOlVbt3mRnHzSQly?=
 =?iso-8859-1?Q?spHXC278Jr9c7qTrzNRCJxsyTv4FsS5g3VQHSPK9X/hcbCM6zxGf9yDoGE?=
 =?iso-8859-1?Q?7f+CqCN1GbwEFMCQmkELuE3jixXCrdKxrMvBaMgGBj2XL8zpyadn6VgMAF?=
 =?iso-8859-1?Q?vWf4bwE2SK3TbdDscWX+vYmQjNd7RoMfqt4C6vv+b7jTQfBRVgQOGfXMPs?=
 =?iso-8859-1?Q?bCgVe0Se+gh5BEVjp6lePn/+/4/K1CdPhQieX9DGf7AsG8d8ca5CDBlnal?=
 =?iso-8859-1?Q?qC//XOERJw2ZMhwA0+EA/RYo7jOlJseoazzJEnShZFxQqU9cV/SCQ/x9lA?=
 =?iso-8859-1?Q?YUTtV/uGf451O1njCQQIIFXOqbO6ZuRnP0+Cxnwjsg8SmQf929zcSHs+Fd?=
 =?iso-8859-1?Q?1I51nV/26LtnTU8cjch1nzfWbpikH1CuBcvv6Nj1gK3f9BAVtPH7ULjYRB?=
 =?iso-8859-1?Q?lYHAn/Xv5VX9YrMSoocBZTVm6qI08PUZXP9jVANEvyhtBr9iAKwlj6hyG8?=
 =?iso-8859-1?Q?REECAtmaHevYU+fcqotsdpuPthoedaAOev2DCfZ4WxR79PxwyCORHNYgKl?=
 =?iso-8859-1?Q?s1yfr31tNX8Ag9LrqKDGz7JKjGHW17VDzCuiUP57K4tEJE//yzT1MeyOYJ?=
 =?iso-8859-1?Q?oOl7zo7F7V4Pk9zTIL8NdyNrj5mNN0kNVT+hWHjVhaZ24lh5yKYueAs687?=
 =?iso-8859-1?Q?bHd0aAEeMvgYUYDjxb2ZZVv626SW/lP8IOyH8FdsApAVw53or5cHJCeqo9?=
 =?iso-8859-1?Q?eLSj8PQ87XrAORUeFrk+XkfuPcBJUndMViWNblnfkMZ/+cm23t3odH412c?=
 =?iso-8859-1?Q?tZ4/6n8IIBS+pXYQu7zbZ/yAwW1zfLY0dh3WvY5meXgm8uSLLwEyhmMcw2?=
 =?iso-8859-1?Q?PhWMrMdmz/M3r8i0/+PONUhJbJTGEIIV7ESymSghoCT3hkJpiYGwUI/ttp?=
 =?iso-8859-1?Q?kytiPnamQSmMuxfi3M0kls2xXJUG5YWbsdspnfzRpv2pJs9pfLjOAplFFQ?=
 =?iso-8859-1?Q?vxkWLpe+uJNoCslaUcxNL8HyC8Sl3rfKWCPLcFrxS0AnmiTk3USMutHh/m?=
 =?iso-8859-1?Q?lPk03XdFWBsjX6NbXK4WercrpLk6XYFNqdFCq0gWHKg0fMqGqlB3Fo7H/D?=
 =?iso-8859-1?Q?eLjzA/V0OY4tgovG1dBbeZ9+qoGPscmBdFzC8NSF4nCm+qXtJMxKGHDkca?=
 =?iso-8859-1?Q?SbfBhM+2ioUqXW7hdt36l/OA3dGI5rEPcxdB+YIb+fhyN+BFP2ahXvbdTf?=
 =?iso-8859-1?Q?tVSemmqX+Fs9c=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6991.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f329519a-1364-4c08-8771-08dc8a43ffc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2024 18:26:23.7564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BbxlFgIYjKb36+W3Oaxtw7TpQeUlpP4aGP9T1TE1PBZPfEdv2KV9/iMJrS9nY6aFMfVagEs85QKNRrxe2UgDsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7115
X-OriginatorOrg: intel.com

Thank you Leon. That is helpful.

I also have another very na=EFve question. I don't understand what is the i=
ova address. I previously thought the iova address space is the same as the=
 dma_address space when iommu is involved. I thought the dma_alloc_iova wou=
ld allocate some contiguous iova address range and later dma_link_range fun=
ction would link a physical page to the iova address and return the iova ad=
dress. In other words, I thought the dma_address is iova address, and the i=
ommu page table translate a dma_address or iova address to the physical add=
ress.

But from my print below, my above understanding is obviously wrong: the iov=
a.dma_addr is 0 and the dma_address returned from dma_link_range is none ze=
ro... Can you help me what is iova address? Is iova address iommu related? =
Since dma_link_range returns a non-iova address, does this function allocat=
e the dma-address itself? Is dma-address correlated with iova address?

Oak=20

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, June 11, 2024 11:45 AM
> To: Zeng, Oak <oak.zeng@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>; Christoph Hellwig <hch@lst.de>; Robin
> Murphy <robin.murphy@arm.com>; Marek Szyprowski
> <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
> Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
> Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
> <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>; Jens
> Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
> Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian, Kevin
> <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> J=E9r=F4me Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
> foundation.org>; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
> iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
> kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
> <bvanassche@acm.org>; Damien Le Moal
> <damien.lemoal@opensource.wdc.com>; Amir Goldstein
> <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
> <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
> <dan.j.williams@intel.com>; jack@suse.com; Zhu Yanjun
> <zyjzyj2000@gmail.com>; Bommu, Krishnaiah
> <krishnaiah.bommu@intel.com>; Ghimiray, Himal Prasad
> <himal.prasad.ghimiray@intel.com>
> Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
> two steps
>=20
> On Mon, Jun 10, 2024 at 09:28:04PM +0000, Zeng, Oak wrote:
> > Hi Jason, Leon,
> >
> > I was able to fix the issue from my side. Things work fine now. I got t=
wo
> questions though:
> >
> > 1) The value returned from dma_link_range function is not contiguous, s=
ee
> below print. The "linked pa" is the function return.
> > I think dma_map_sgtable API would return some contiguous dma address.
> Is the dma-map_sgtable api is more efficient regarding the iommu page tab=
le?
> i.e., try to use bigger page size, such as use 2M page size when it is po=
ssible.
> With your new API, does it also have such consideration? I vaguely
> remembered Jason mentioned such thing, but my print below doesn't look
> like so. Maybe I need to test bigger range (only 16 pages range in the te=
st of
> below printing). Comment?
>=20
> My API gives you the flexibility to use any page size you want. You can
> use 2M pages instead of 4K pages. The API doesn't enforce any page size.
>=20
> >
> > [17584.665126] drm_svm_hmmptr_map_dma_pages iova.dma_addr =3D 0x0,
> linked pa =3D 18ef3f000
> > [17584.665146] drm_svm_hmmptr_map_dma_pages iova.dma_addr =3D 0x0,
> linked pa =3D 190d00000
> > [17584.665150] drm_svm_hmmptr_map_dma_pages iova.dma_addr =3D 0x0,
> linked pa =3D 190024000
> > [17584.665153] drm_svm_hmmptr_map_dma_pages iova.dma_addr =3D 0x0,
> linked pa =3D 178e89000
> >
> > 2) in the comment of dma_link_range function, it is said: " @dma_offset
> needs to be advanced by the caller with the size of previous page that wa=
s
> linked + DMA address returned for the previous page".
> > Is this description correct? I don't understand the part "+ DMA address
> returned for the previous page ".
> > In my codes, let's say I call this function to link 10 pages, the first
> dma_offset is 0, second is 4k, third 8k. This worked for me. I didn't add=
 the
> previously returned dma address.
> > Maybe I need more test. But any comment?
>=20
> You did it perfectly right. This is the correct way to advance dma_offset=
.
>=20
> Thanks
>=20
> >
> > Thanks,
> > Oak
> >
> > > -----Original Message-----
> > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > Sent: Monday, June 10, 2024 1:25 PM
> > > To: Zeng, Oak <oak.zeng@intel.com>
> > > Cc: Leon Romanovsky <leon@kernel.org>; Christoph Hellwig
> <hch@lst.de>;
> > > Robin Murphy <robin.murphy@arm.com>; Marek Szyprowski
> > > <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
> > > Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
> > > Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
> > > <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>;
> Jens
> > > Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
> > > Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
> > > Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian,
> Kevin
> > > <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> > > J=E9r=F4me Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
> > > foundation.org>; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org;
> > > linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
> > > iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
> > > kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
> > > <bvanassche@acm.org>; Damien Le Moal
> > > <damien.lemoal@opensource.wdc.com>; Amir Goldstein
> > > <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
> > > <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
> > > <dan.j.williams@intel.com>; jack@suse.com; Zhu Yanjun
> > > <zyjzyj2000@gmail.com>; Bommu, Krishnaiah
> > > <krishnaiah.bommu@intel.com>; Ghimiray, Himal Prasad
> > > <himal.prasad.ghimiray@intel.com>
> > > Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
> > > two steps
> > >
> > > On Mon, Jun 10, 2024 at 04:40:19PM +0000, Zeng, Oak wrote:
> > > > Thanks Leon and Yanjun for the reply!
> > > >
> > > > Based on the reply, we will continue use the current version for
> > > > test (as it is tested for vfio and rdma). We will switch to v1 once
> > > > it is fully tested/reviewed.
> > >
> > > I'm glad you are finding it useful, one of my interests with this wor=
k
> > > is to improve all the HMM users.
> > >
> > > Jason

