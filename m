Return-Path: <kvm+bounces-19262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 793F7902A97
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 23:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91A731C2285A
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 21:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EEF612F397;
	Mon, 10 Jun 2024 21:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="muB45dMj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513DD57CA7;
	Mon, 10 Jun 2024 21:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718054893; cv=fail; b=V8fsIT2NLhmyy6dZQ2fQbzghKa69zMMMMbbIlig24w3xjw8leZThhpZKLHbX+Gkhe4+PZUlFyfOBMdFhmF8myZNz5LwD99gB2AerdhHzJw4P1C+mFqf83q3z7Y+pLr+kODqBI6Y+JUs9wX+HW0zREE16WS8na6XVyprin2DMHhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718054893; c=relaxed/simple;
	bh=BhY3NwRliREZRdNNM43bZ3OvIln91I1pxlVbr1nPbP0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HiGXwBj1Oka1QF9CZaQRRhzRxfsVrto1B4CYadtJvlcXn/ztmuwANfbM0A4o8nuCZaxHfQ2NU9gusSEcGpr4ZO7kDJCDimZVioFjTyxA+Br4i62wt1uyahYuDQvG+I0WepazkC7IDEUOgQ/ftpUxzCelxdSDzOIg6St9Il1sZGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=muB45dMj; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718054892; x=1749590892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BhY3NwRliREZRdNNM43bZ3OvIln91I1pxlVbr1nPbP0=;
  b=muB45dMjKUs7RutsIRf91MGm4Ky/E3I628V5TVVDZiM9ayD2UV0sxfM0
   R8sY4gMsJO4XYEfUpTLOZcxQVBnf8QJOiQajr9sFf15fNWf6rbgdcDIfN
   2FvMXGaXqXP5s8EIs2Ao185gd4cOVxjpCetjqn8KDKsIoO0h60pBqAfXB
   MdQz28E8lk6EAj4vWlfUCAvW5SCaUioyuBrzUAUJ55E6j2Efxd26xldTr
   waUpBXYPXbagEBYuwlOLSWQT/Lc/0YDssCpIQNUR3QkN7KuSi2VctHlnr
   PP7lMokdRQsqi1B8negO4bBByRgIV8G1kgMFGJ/B+3P5TOSY5VbA/1uUv
   w==;
X-CSE-ConnectionGUID: q+2ipTCTRySgN10YIvDIcA==
X-CSE-MsgGUID: z2R+P3ydRKCTNjPa+WQZqw==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="37262120"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="37262120"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 14:28:11 -0700
X-CSE-ConnectionGUID: eUv3vfAtSeaYz9bX1BbdJA==
X-CSE-MsgGUID: Svj42NBxR9+Im31HyZocDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="70356682"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jun 2024 14:28:10 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 14:28:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 10 Jun 2024 14:28:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Jun 2024 14:28:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQ5wiXLJ15WP5CiENgk85WPGtphz7Lx8JjcU66zgA5Y4/2brtokQIQIBEr1Z1F2zDoZfzDetKF4McOn61kl3Ma3QmuBKLVx6hLSwbOoFr6TgylFDg+3p9SJg4W0pDZWuGquhW7xQZErwmNWfmb3wt98NUUAn6IvcFARHvYpjxkQYIDiKSlqaFOyTjyHQJ3kL4Sl2ZCZDXt5Hw1fkn4atcyt5MtVO/qnFb/q3vNK5QxsSU/4ywqMcYRM2ndJ83zWWXj3gPQq+SFHShRDMkwDiWQ+mCcVAzBJq/jyFVMX8oYlgaN3/W0ZPkcGn/qNH6sp9eL+mjRjyFx2q+JGKHFf8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhY3NwRliREZRdNNM43bZ3OvIln91I1pxlVbr1nPbP0=;
 b=O0evvpLs2XG6aet3YtmvsdPNUOgD3O87I+MxhWst91/N8In3Yr6GYRhQgJAZIpwZV0A2bXjsvi2/7QY1mUW1+BeNJBvh/Bjz2OPsmpGrXEshrI0KyI7oIz5sIQ96eD8DpwvARQo8LePwOjJ3SVD8kHdf7IcD+01nsaN6+IDvDMgdfIM2LAJAynleX7K5nJgncjxiW/Ie6b7pm6b3fJ+VEYAN18PCLK+M+NKEQfkkpkFrK28rXvHs/w/mlY8Iy8UDAblRA/BnLjmedLm6RP7MMgP2xI9+lPEMVs5eKPfokNx9M4ABnaLx3Vn/zC4i/Yljy6VIzthVaT07DWKvmzXSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB7004.namprd11.prod.outlook.com (2603:10b6:510:20b::6)
 by MW3PR11MB4569.namprd11.prod.outlook.com (2603:10b6:303:54::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 21:28:04 +0000
Received: from PH7PR11MB7004.namprd11.prod.outlook.com
 ([fe80::8c26:2819:d0f9:1984]) by PH7PR11MB7004.namprd11.prod.outlook.com
 ([fe80::8c26:2819:d0f9:1984%3]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 21:28:04 +0000
From: "Zeng, Oak" <oak.zeng@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>, "Robin
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
Thread-Index: AQHanOEtbi0VHTnLn0mNwgftYB7xRbGEmFqggAEftYCAO5ykoIAAFS8AgAAFauCAAA0xgIAAMSmg
Date: Mon, 10 Jun 2024 21:28:04 +0000
Message-ID: <PH7PR11MB7004DDE9816D92F690A5C0B692C62@PH7PR11MB7004.namprd11.prod.outlook.com>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
 <20240503164239.GB901876@ziepe.ca>
 <PH7PR11MB70047236290DC1CFF9150B8592C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610161826.GA4966@unreal>
 <PH7PR11MB7004A071F27B4CF45740B87E92C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610172501.GJ791043@ziepe.ca>
In-Reply-To: <20240610172501.GJ791043@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7004:EE_|MW3PR11MB4569:EE_
x-ms-office365-filtering-correlation-id: 37589a98-37ed-4ea4-5c50-08dc89943694
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005|38070700009;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?eI1q3pcT7kUZJHjJhmmYCldx30UZuwN2ap1MYL260M/76wUwvTFvvgIUrl?=
 =?iso-8859-1?Q?Ck/dGCdUutjIbPxkNiN7AJcTu9Sjp5xW4sOPG3SLvU4JE570alWaBa9dQG?=
 =?iso-8859-1?Q?og64/k5Lil7XsES3sDQCjwVx2KCX/Fs0QlYHkqVeizvm6n+9OP6m/5PHyI?=
 =?iso-8859-1?Q?tZhWeDCLAXL56BbjO8874YhxiGO8AyTB0iZmX0oyQgZDica80XlVESyeyk?=
 =?iso-8859-1?Q?lS2HYDZ3jJK/S7iQF97OM/+mH5m88uPoMTxV4gvhcxIgrcXoTP2a+w5uFf?=
 =?iso-8859-1?Q?j6/lOMD0vv6HFSyZ+89v5CfJw2CJTAE1vMOQgL+j1jNSzPDivQxxMl5sb3?=
 =?iso-8859-1?Q?RgOWDgfmTJnTvWSydRD0sRH7e0H9CcAThIKYw/Ixf5XsoMzw7Nu1O/UtmI?=
 =?iso-8859-1?Q?yL/IWhM3t+5ymt2+jNWuRA0+hvOnfX0VTbrfSTECu3y5dDtvVhfTbwpOo9?=
 =?iso-8859-1?Q?YHD+zY8fjJV4YLYvQmbBFpDCkA4SaTFeoazSAYv3OSxjI0Q5mp4NCmpUmn?=
 =?iso-8859-1?Q?lciBYZ+5RrdJavnsLFgIK2roPdTp7gPOs7IXTj8xj68zHxTCU2ydK0EvJq?=
 =?iso-8859-1?Q?WKgd4XXm3PqFjOYL6tw9wg9n7oyz7KGKoKjJih5HcoSQlEmS0wsfoKzapL?=
 =?iso-8859-1?Q?n/QzLaM4oLoAGWJcOXTzyqllDDbDpymBLHbrBt87c4Jc/PXenwFl7g3DwV?=
 =?iso-8859-1?Q?aqXNOpM6FuDPTvvgbHT9f9fIXN+REnB+qSjKbZteFPYfKqiODmdFMadsA+?=
 =?iso-8859-1?Q?9SXMTRn5iXPUnl8lSPQaWYgNwQBL7nbaCMQoAbNKUMJL7sjaAHqj6bSco6?=
 =?iso-8859-1?Q?EbiOhDfZnp7jTWExrkfIHjfwOBCdCJDOmx1kpm5Aod/vDeHNPbN3rACpIA?=
 =?iso-8859-1?Q?w3OezTU/H1XqBgfi1YbAnliGjwkamTcq79SWvTTMCHWMbNe15BnLz8YLhv?=
 =?iso-8859-1?Q?muicqQkpODJfUs8Lzkl8d+UDqIygAHVFPAT4xF+iFUiixbJsuF++h0fw8T?=
 =?iso-8859-1?Q?WdLI8jAnMs6icoQRkPBy1jFr1VMGvqAyF6T80dn9INLWo/ilMMzk6o48uP?=
 =?iso-8859-1?Q?pALbSc2qvzx1BXer0TEFnXY3+JLb69TAZgmzBIa/PaI/mROnqpDNUATIvO?=
 =?iso-8859-1?Q?ioW1gyWk/EMGI/Ggwu4tIj8ELJKI5zclPiczn06ovmy7WQC1+iMEdAleYQ?=
 =?iso-8859-1?Q?tSTbABFXuXWyrq70jXXug14vhjvObQIt/WV+U3fXEOVOGDx0fUDniKN8D6?=
 =?iso-8859-1?Q?+wn7pFpdmUW1Etq6MfaUnkr1Mtf292dVIRY7mRd46ytYTkfjFwH93b8pEA?=
 =?iso-8859-1?Q?eXZTO/hAlY2ELaLOdKqbKBAkYjunRXoIgQenyD2SMR/mhfVHFOqWuIOgzM?=
 =?iso-8859-1?Q?banKjHG+d9pR69qxU9SXvAjXRYzd42QNzec7khZDdVkB98IKsf4kA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7004.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?PjcdyxOnSaSGrq+tbgi8+jJ1RCh76Ixo4uQSOUIgXwEcfdhYH60dvSSSCg?=
 =?iso-8859-1?Q?uAmayoww6Td8Lm5exyoVwK3Ruimaran6JFjYjUn7oKLfusDHLCEwGoBK8s?=
 =?iso-8859-1?Q?PNRuV/1HgK4icXJF0CrEKu0yWYya73Ys0uOWSdkxSekmRF0t9Ja7XUKoDd?=
 =?iso-8859-1?Q?d+g/EDvSFLgHnCWhVtt0AWn1LfnA4nW1vSUGbGqXeScuhEYdD+fWyulsp8?=
 =?iso-8859-1?Q?ETvgIz4cIqpQUk3+yIPSjsiGS9KnWnmtbU7clz6s8ZvSfpLoMARUjFR3lC?=
 =?iso-8859-1?Q?SBUvA55voMve+iVIxZLj8hNXdPL/sqALb6b+tCq973wUvlKtVG0MMJR6NF?=
 =?iso-8859-1?Q?4pdrmXirELGkVnFluKfQ6DiDwo6urHzMxnqLaDJSfPGuqZMHGzYKVipLZS?=
 =?iso-8859-1?Q?nrVgJ+wV4fMXfzJqnpzjRpahWwLV2lVNk3rUnGnu2yvBWbdPe1NwJJTgET?=
 =?iso-8859-1?Q?lBmEHw2Zfui34kwQ/goQm4AxXDS4vto9g/SJubDAF5sd/o+9vGtERrWJ3Y?=
 =?iso-8859-1?Q?vM74li+app7/EV5MzeRZakSBqWDv4nXAAoZbSUm4PIONcQ8BowjC7VPXim?=
 =?iso-8859-1?Q?YB+1svn3+rbS45fWiKRTOq2LHLnukAprFLdBUHPW4J4UBpQVJEsg7i7LL7?=
 =?iso-8859-1?Q?rJa1YdFNkfpxK9dFNQh0nwpY4GZF+74Ves4LebKXYo8lmXOR4oIvhU4WUh?=
 =?iso-8859-1?Q?zVk+VZWGgVbIvWhuIHaFaD/f/L41JO5IiEnP+aSstvTUXaEtFqgriHyntP?=
 =?iso-8859-1?Q?gRGT2EW/2iWQsfWxlbVCld6+O24XTAr0ZGeuHYehzXkbmgGSzCeFJGLlKT?=
 =?iso-8859-1?Q?LnI4lY+hnYjA02clZmp/zTgYxMY1Fhbj9teM+c7xCq4e9hx0OxLdo0tX/e?=
 =?iso-8859-1?Q?4GbGJy0lSaRCOdgS9sgXBiawXX+tev5wPpQnGUbpkO/7cwiYQkSzdYgxWx?=
 =?iso-8859-1?Q?HuwSlxostrJDpMdBY3qowWlinlI2Fo40pM8eJeHnsBTgFSfEmjcap2cbxa?=
 =?iso-8859-1?Q?e4yEOVrFmebPoBhLL0VkCFySREI5U8gz/IMAhThgwUgY1/GnJz8B9QtrGP?=
 =?iso-8859-1?Q?d4Vu7DW0q/AGUdhBsB7HBkChBwL0AcTMcWHZCjprWuF8tCoEWjcI+OwbDR?=
 =?iso-8859-1?Q?3gDGlWgSlOvrdOXnK/J8/jk5fPkTQEyx+1LqygJgjn6e6PWTIdyMGRCMbx?=
 =?iso-8859-1?Q?oNdDMpjNcQlzciIZmSeLxMe02ofb0wrUwSh00DYrrwc+iC768FlzGS+z/M?=
 =?iso-8859-1?Q?aMiok0HMjWQHrm4gX8niIjw+G0g+GGqL6PqUycIutzGCa7G9Pdy+Psbox3?=
 =?iso-8859-1?Q?0w81vALl/0OP4H2MnGqDE8VhVpS/B07r93nzQ5n7ki8ITkANpUimJwwL6Q?=
 =?iso-8859-1?Q?B7fRkam9NVtLRhZqZ4gsGko2neVZ6Jk03tc1xpCQ0Mk4uE+un8uGZA/ae5?=
 =?iso-8859-1?Q?w9Uvzn+pxRM2B7uRyzgjCS81WODkbSnnNb8ijGcEmK6oL/TLVi4XWgqsJe?=
 =?iso-8859-1?Q?NCEPFcrFV6JAjBDKh752M1yAUYW+4uIXpzTdKAcJkZAVPaeeZpZDP4Tkln?=
 =?iso-8859-1?Q?Nqcx+KGCqwEmjSvP7zQvTZXsfemM3QvsOruR/43e0SXJP8OwTdBYVEJia4?=
 =?iso-8859-1?Q?I1psmDW/GdYNw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7004.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37589a98-37ed-4ea4-5c50-08dc89943694
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 21:28:04.3358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rQ8N4799OngImkQI47K7erSnlVSMJVBu4avWVxd5FwDOMguigj2T6uY1xo4cGeVG11r09CRETuGb9fisGr0sYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4569
X-OriginatorOrg: intel.com

Hi Jason, Leon,

I was able to fix the issue from my side. Things work fine now. I got two q=
uestions though:

1) The value returned from dma_link_range function is not contiguous, see b=
elow print. The "linked pa" is the function return.
I think dma_map_sgtable API would return some contiguous dma address. Is th=
e dma-map_sgtable api is more efficient regarding the iommu page table? i.e=
., try to use bigger page size, such as use 2M page size when it is possibl=
e. With your new API, does it also have such consideration? I vaguely remem=
bered Jason mentioned such thing, but my print below doesn't look like so. =
Maybe I need to test bigger range (only 16 pages range in the test of below=
 printing). Comment?

[17584.665126] drm_svm_hmmptr_map_dma_pages iova.dma_addr =3D 0x0, linked p=
a =3D 18ef3f000
[17584.665146] drm_svm_hmmptr_map_dma_pages iova.dma_addr =3D 0x0, linked p=
a =3D 190d00000
[17584.665150] drm_svm_hmmptr_map_dma_pages iova.dma_addr =3D 0x0, linked p=
a =3D 190024000
[17584.665153] drm_svm_hmmptr_map_dma_pages iova.dma_addr =3D 0x0, linked p=
a =3D 178e89000

2) in the comment of dma_link_range function, it is said: " @dma_offset nee=
ds to be advanced by the caller with the size of previous page that was lin=
ked + DMA address returned for the previous page".
Is this description correct? I don't understand the part "+ DMA address ret=
urned for the previous page ".
In my codes, let's say I call this function to link 10 pages, the first dma=
_offset is 0, second is 4k, third 8k. This worked for me. I didn't add the =
previously returned dma address.
Maybe I need more test. But any comment?

Thanks,
Oak

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Monday, June 10, 2024 1:25 PM
> To: Zeng, Oak <oak.zeng@intel.com>
> Cc: Leon Romanovsky <leon@kernel.org>; Christoph Hellwig <hch@lst.de>;
> Robin Murphy <robin.murphy@arm.com>; Marek Szyprowski
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
> On Mon, Jun 10, 2024 at 04:40:19PM +0000, Zeng, Oak wrote:
> > Thanks Leon and Yanjun for the reply!
> >
> > Based on the reply, we will continue use the current version for
> > test (as it is tested for vfio and rdma). We will switch to v1 once
> > it is fully tested/reviewed.
>=20
> I'm glad you are finding it useful, one of my interests with this work
> is to improve all the HMM users.
>=20
> Jason

