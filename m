Return-Path: <kvm+bounces-17574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E9728C8081
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 07:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 740FF1F22270
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 05:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E450DDB3;
	Fri, 17 May 2024 05:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ho6ZPaT8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12801079D;
	Fri, 17 May 2024 05:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715922094; cv=fail; b=UPV/jC+ip1M2wlu/uAk5NUVIVWbyIyuA76IChAWkkFMpQALYWEw3MGQGels2bXBnEVHESD1BG7h+25DfTF/C79gt2L/u10N62zWov/xsld4VrWywXkbcfTGq8nJXSoyv9Dv2rlWNk2YHqEUxWnxp7aKjPSOTzjDv+kVscFfnCB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715922094; c=relaxed/simple;
	bh=M7I4L0cH+NyHm/gyaCbOZUstBnl/Rzmkmeg9BOe6AfA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QFPIJp1siZWSgIKZBfADbjDCUJfkVkeM55Fcv7q2GLbTpxJuVvaLNfVsdRTVJ2L6LOlniZG3UuCuS785oGddCnqBPJ4ARc7bwJI6giRXI8tRJy+sjfvADpRqNbyFYhTEoqW9V5hVEURHJm0rgtlRU8SXNL8sJWwwisUh5zcaox4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ho6ZPaT8; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715922093; x=1747458093;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=M7I4L0cH+NyHm/gyaCbOZUstBnl/Rzmkmeg9BOe6AfA=;
  b=Ho6ZPaT8B0yMuIFU+jk99669E1X0DggH4gyIUVwBlqyqoG/JgcmbcWg+
   M+v03RBiT1L6T+mtRKFzH60Z+lhaui561lXDNAI1T8WV9kv/+ipmMYaw0
   +/cycLupARW06ncuqKzaB5jFuwZKrROIP8l1W+dY5BklxAW/AXvFGIJwn
   AWtQ/8soPJtEM2+gqKRPDj8IFkk+S+dcVaur+uln9upt6osV/4DbXinnb
   bcDe3kJmndP6Fh/OF55uPKYUDkqIBEwLl/sYQdvSUk4Fbf4eVcoSA+sda
   A2zXiaqreW0BwshBJe3mI4fzUGom8xYGTh7fS38NePFz1Ib5zA9BWippb
   g==;
X-CSE-ConnectionGUID: fCrLz405QXOksRM8sShaog==
X-CSE-MsgGUID: RCxvin5CSW+DGUAqYeasyQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22684050"
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="22684050"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 22:01:32 -0700
X-CSE-ConnectionGUID: jgxbhtOnTTWNQA1UFFl9tg==
X-CSE-MsgGUID: bkBPYpLbTCyIdq9fgxQcIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="36463429"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 22:01:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 16 May 2024 22:01:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 16 May 2024 22:01:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 22:01:30 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 22:01:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4d4YeSL6n/N0odgrXsmNLIxovaMmf3gLCWtCSJNpOmHrE357T5TSz59LS1mBege/jwobu1b9Zg1wzu9t9AujOLcX59kFiF9S+Z0LhEKYjeBSSJYPOdqJaMZFWlK43f4VYWZag+a7Hd8jDJ9t9ROi5ZKErrF5AnQwO9JoXgr3+fKJfT2h6iriljvgfMeJOx8kkF0q+/o/9vv0pRUPODlPM8SFE13Kgcqrg2sPP1goXZ7T2kv1piC1ZBTBWR9wjA+sG5T11Md8kSfYUI/1lu5vq6lyhOWBUnsfh12yJETXaE67iszklYCw8U7W3hHllnH5ZRLrwef/dNhS9g/9vTSZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPb0odojeHaNhqiepWoD9zN98pLYFOquMTiVE/bhM2k=;
 b=T12FeTgjC/EMklkU1SXJ30+ljZiTw3A3ri354tB3QPmSGRYg8coJS1WwItXBLyIQqkhGxrnPiO3rqJ+Mnz6Sbz64MSU2jsbKKUydPrqbJmORJdVHCdVN5N8Ll00Tblpvislrz6yRGocaOi07Sw+sVtUOq9CMaHRCKoJFaYIQ4Vsl6nUNvjuybNDMoLE9MvwL7fSEmKXyO0/IOtqC3unfijeVCM2tR93vx8qHXggNwe/tdR2CTR4/06O+ICRl3GCbEIRZGYkFXyt21jxDzGyF3HUScnO/xFh/RDjkYnwDRJX5S2gJpMZsbl3yMZn+ZEBnJ8OVkJpfI3wyo1vR+NzFhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6655.namprd11.prod.outlook.com (2603:10b6:806:26d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Fri, 17 May
 2024 05:01:28 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.026; Fri, 17 May 2024
 05:01:28 +0000
Date: Fri, 17 May 2024 13:00:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<jgg@nvidia.com>, <kevin.tian@intel.com>, <iommu@lists.linux.dev>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>, <corbet@lwn.net>,
	<joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
	<baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <Zkbkdi+hipp3/YF1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062138.20465-1-yan.y.zhao@intel.com>
 <20240509121049.58238a6f.alex.williamson@redhat.com>
 <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
 <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <20240516145009.3bcd3d0c.alex.williamson@redhat.com>
 <ZkbK9CzmcxgqhSuR@yzhao56-desk.sh.intel.com>
 <20240516224442.56df5c23.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240516224442.56df5c23.alex.williamson@redhat.com>
X-ClientProxiedBy: SI1PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6655:EE_
X-MS-Office365-Filtering-Correlation-Id: c821d591-6ec1-4e6f-e07c-08dc762e693b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KbQkEbtSNVagKNvgR87flvOWrFSFQZvcFQou2b/alieER/CcpS/DBXs103tb?=
 =?us-ascii?Q?N8uSPv4YFmhJ28wxtmco//iFnAIJAKbtuCJgoq15QrlyLFBj0eszP9y3YT+M?=
 =?us-ascii?Q?pMg+PjHbfeROrOz2udeQGSzH3ZSnBy2kslH2p1XZnZPkqbX+3mpPHeD8Q0eW?=
 =?us-ascii?Q?ZMPUqmmbR6m+Mpe4M3IkwUjJoJb4gfdE7g1JM6IhqTUWwkMXQmJeDcj0m1lL?=
 =?us-ascii?Q?8+ndkTOQXcOmN4qL8zEgCpYHRFsrRPhWyOVW9JwsSdBWmjYrsklTmD0cl7q6?=
 =?us-ascii?Q?A9L6wubWmHrya5FRas8DErplpZ1YwYY/ryE3RSguZfj0WNwdGbs8tEyG975j?=
 =?us-ascii?Q?ggCn+IWfEP5qD/cjqFkZJc3cHpVrE2vDzwV5JXjw0+6/O4oJyUuL5ellLSlc?=
 =?us-ascii?Q?A3NemaceV/XE2MxXcDTSVQcPQsHgFDP87ad8AOgVhKhpeM3m19zlnw5fWABf?=
 =?us-ascii?Q?OiKP5vI4NUmxJ6zgvxR42r2pIE2IDcOBtVIa/GBvv4nqeTo3YOvwHp6iZH4q?=
 =?us-ascii?Q?gsZLdchK21ndDazKTr03D4iyBPf/pujjKE9OrQCzHfS7LMNX9P1pxIJYsoqR?=
 =?us-ascii?Q?gSxsdNLSWudIdtgHn/jT0MwxzOsiLOepTE73tZ4GraDF5slE9DWOLa7nCXru?=
 =?us-ascii?Q?XDyH+D3B3ujOlNhQ5s/GcnoPKL55kRVyR9owwhBtgcS5kLdn0azfX5VV24Uk?=
 =?us-ascii?Q?/xsPBr7YvzUxEbR1rTzvw4DX0NqHfT9wtGLVGHu9MFY66qij0DutQJwdP7Hl?=
 =?us-ascii?Q?IwfcYNYTU56kQMG35v/SnwN3niXyfrWp83g5T9w26b5ssGJJrfvQStepRfhq?=
 =?us-ascii?Q?MQYB1jsvrkLxUeBlg3GyWG9jTKdLAUjTTAnFt+WUulqSTkyewWBUYPsSW0kS?=
 =?us-ascii?Q?SX/mWsudQYiVuYNzjpdtGX+wRnSLgwGF8wgPjnKeonZabBsGyeeAdgBpJxAI?=
 =?us-ascii?Q?rAY0SDAbCosuU++ENxCvWl94STmwZU9T7ez5ggDA6JvjqKBjYaHIS9NxXSvS?=
 =?us-ascii?Q?nuFaib8SWMsMmHiA3MCfb0zoDO08QtzvSnm3R05xALxOTPynHec/YNyKvG+g?=
 =?us-ascii?Q?PM28WVSbl9V+r+Qf4/jB+1FLrsrgsBpU5UQDPaGiQPcumK2hNW3lSbUR4yUV?=
 =?us-ascii?Q?c5oz8pqNbZ7bFmMLuBVGqJ94xbiKApem1wJpPmco9lBjXhaRl+Qn3n5yDxQQ?=
 =?us-ascii?Q?uh+m5jpa9bh0ygY2BcwUi5jhA+734eIRt0l/yv/tJVyc9H2wo6UTMcJtvCTM?=
 =?us-ascii?Q?39+8Drizj3XNAfK4SmdoUSe8VnGABI6IjeYE7COmZQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BLl7v91oTNNK+uSBMsRJTKtNmcD5GhAPwTFGTibL/N6FqCx6A3CFpqSbVFX9?=
 =?us-ascii?Q?bZnhjCurSbzPdYcxNxZOw0QVYhD3JJfcsZqPbWh+ZNnqfwAIWeRewId9MMDm?=
 =?us-ascii?Q?w9zNZoeVTIbMVwgsTvfLl23ay0IdeBYA9++Z3u8RHWI9NDqG65nugxRFC4pr?=
 =?us-ascii?Q?u5OkxjJavALn8ePuQ13MqXCF76imFdRFOaL7utcOSAo5OfSW2p1JnMdwJ94O?=
 =?us-ascii?Q?W/WwJ3dZnJU/tMNzncI0x6Zh365dbG7OItoLwMmRxWT/6hALvKVyikJ2mp/h?=
 =?us-ascii?Q?lP4wM0khRpjk2VUzmpVszh4tTp4pmKobchHwl+fsCW5g/0XCH5S9N/r4xpdd?=
 =?us-ascii?Q?2PCol+/FCRErySumIZWV0KXOk/qYpSiIik5kDRKPucacZo3+HyV1iKMRMiJ7?=
 =?us-ascii?Q?o35yMaPlWK0710UIbACOso41TthCx25pVbstHGqkeMAyAcYjojHXABXH6v9I?=
 =?us-ascii?Q?bWoOe3TyPfBYmAHa+zGBdbyT3Ngh5hhbJ0C4mHYXUcsVS3EoZfuNnB4Q5y5z?=
 =?us-ascii?Q?Akd6j1RPWTvSuwhw0PiESY0n8/mAmxCWjDrsUt01EicwjopB9ceh8HQZY72q?=
 =?us-ascii?Q?1VQ9jIF5zqyEcc3ib2wPKpxh4Y4iy83G8E7RcrRevbQuTDB2JfWgXhGobnPF?=
 =?us-ascii?Q?NpBGK5dhoopvNm5/kecy5u4/SWysosV8/V9aSE2h6DhUiC7dNMpwB/MUyUoi?=
 =?us-ascii?Q?Q1dAjZ+vmcjgkTzxetIzJCChjviF0imddM5QyF/W0wW06va5WQf0IW4TfikA?=
 =?us-ascii?Q?STAGv7FAg/F1435ZKQAtVip1FouP3nBx1H948jfYxNtvZ+DLLHiUgZCORAnI?=
 =?us-ascii?Q?eL9pw0GB0ud5N/Bk2Avdv7z3OuHMHxIjYMXIq4JOiHhZy4LbB479MUhOi8u9?=
 =?us-ascii?Q?LEI9zZHQ61ENOmXRSlv38N4S5Yzn5uUsE5B96pPViMxLwaCzKGs8FurHEY/N?=
 =?us-ascii?Q?kaXK/mCBxvLxTufHyBNA9jBn52o4Yh/P3Ag7iZXWGc8TZHYum37xSCyGA+JE?=
 =?us-ascii?Q?EeIYEIWL8fvf+7COrjve2cM1SxV5CMaO6nRkyPPfhb5ux1W2vy50mayNyiP2?=
 =?us-ascii?Q?XcH5E/Cv6Ha0TspWI6O+dBMvAqRmkcTcnfV36ihG4UzvCubigjBT/W3V2Pki?=
 =?us-ascii?Q?tS7Q0hdYGfm7mj8sMK8CQhI+N3K+9Hd/r417+7sKSuzY+BDoefTn5nW952iE?=
 =?us-ascii?Q?zksDk/Fmex/yKGpVcyutS5W3pJ0+atTktEvDGFA+Blq3pANtha8hjpY9CZpO?=
 =?us-ascii?Q?kr4sFAHssfhrfkXooBLcBKaDWBBlm2b+6pF84KjSwO6LzTkg4b2nkx4lkCZd?=
 =?us-ascii?Q?PYbc/C42BWN0aP0ok+dq2hhCaK+/USL2ENsVRvyGhFXA2PjwjFwgGMpwipo7?=
 =?us-ascii?Q?joPXyswJ8ygIhYeEI2+GLvaDFhm/a0dODk/ESjd953MxDsBxZeOn0aKUVPq3?=
 =?us-ascii?Q?14KPMPDyTajySOpS8EGqJ0YJ8oIUMsxnqa5HCEGYAqxMrrBZ73FeWO8gOUNx?=
 =?us-ascii?Q?Nlj70sIi5tTFalexnXkl069cuPhoQ6cG4RvD6r4WphLE58ukfuSA0Izn3ahX?=
 =?us-ascii?Q?Qi4Keb9wsftsqXPl3hLKFz/zYt7th/BVEsKQjqtk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c821d591-6ec1-4e6f-e07c-08dc762e693b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 05:01:28.7298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OelTdtRmV/bozm5dREa4FiQoX698zE2t30uoaryI8hmZ8qvv1moWv8UcNRVpUpztQihyZTZuxQtZzgWTdcGoPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6655
X-OriginatorOrg: intel.com

On Thu, May 16, 2024 at 10:44:42PM -0600, Alex Williamson wrote:
> On Fri, 17 May 2024 11:11:48 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Thu, May 16, 2024 at 02:50:09PM -0600, Alex Williamson wrote:
> > > On Mon, 13 May 2024 15:11:28 +0800
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > > > On Fri, May 10, 2024 at 10:57:28AM -0600, Alex Williamson wrote:  
> > > > > On Fri, 10 May 2024 18:31:13 +0800
> > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > >     
> > > > > > On Thu, May 09, 2024 at 12:10:49PM -0600, Alex Williamson wrote:    
> > > > > > > On Tue,  7 May 2024 14:21:38 +0800
> > > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:      
> > ...   
> > > > > > > > @@ -1683,9 +1715,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> > > > > > > >  	for (; n; n = rb_next(n)) {
> > > > > > > >  		struct vfio_dma *dma;
> > > > > > > >  		dma_addr_t iova;
> > > > > > > > +		bool cache_flush_required;
> > > > > > > >  
> > > > > > > >  		dma = rb_entry(n, struct vfio_dma, node);
> > > > > > > >  		iova = dma->iova;
> > > > > > > > +		cache_flush_required = !domain->enforce_cache_coherency &&
> > > > > > > > +				       !dma->cache_flush_required;
> > > > > > > > +		if (cache_flush_required)
> > > > > > > > +			dma->cache_flush_required = true;      
> > > > > > > 
> > > > > > > The variable name here isn't accurate and the logic is confusing.  If
> > > > > > > the domain does not enforce coherency and the mapping is not tagged as
> > > > > > > requiring a cache flush, then we need to mark the mapping as requiring
> > > > > > > a cache flush.  So the variable state is something more akin to
> > > > > > > set_cache_flush_required.  But all we're saving with this is a
> > > > > > > redundant set if the mapping is already tagged as requiring a cache
> > > > > > > flush, so it could really be simplified to:
> > > > > > > 
> > > > > > > 		dma->cache_flush_required = !domain->enforce_cache_coherency;      
> > > > > > Sorry about the confusion.
> > > > > > 
> > > > > > If dma->cache_flush_required is set to true by a domain not enforcing cache
> > > > > > coherency, we hope it will not be reset to false by a later attaching to domain 
> > > > > > enforcing cache coherency due to the lazily flushing design.    
> > > > > 
> > > > > Right, ok, the vfio_dma objects are shared between domains so we never
> > > > > want to set 'dma->cache_flush_required = false' due to the addition of a
> > > > > 'domain->enforce_cache_coherent == true'.  So this could be:
> > > > > 
> > > > > 	if (!dma->cache_flush_required)
> > > > > 		dma->cache_flush_required = !domain->enforce_cache_coherency;    
> > > > 
> > > > Though this code is easier for understanding, it leads to unnecessary setting of
> > > > dma->cache_flush_required to false, given domain->enforce_cache_coherency is
> > > > true at the most time.  
> > > 
> > > I don't really see that as an issue, but the variable name originally
> > > chosen above, cache_flush_required, also doesn't convey that it's only
> > > attempting to set the value if it wasn't previously set and is now
> > > required by a noncoherent domain.  
> > Agreed, the old name is too vague.
> > What about update_to_noncoherent_required?
> 
> set_noncoherent?  Thanks,
> 
Concise!

> 
> > Then in vfio_iommu_replay(), it's like
> > 
> > update_to_noncoherent_required = !domain->enforce_cache_coherency && !dma->is_noncoherent;
> > if (update_to_noncoherent_required)
> >          dma->is_noncoherent = true;
> > 
> > ...
> > if (update_to_noncoherent_required)
> > 	arch_flush_cache_phys((phys, size);
> > >   
> > > > > > > It might add more clarity to just name the mapping flag
> > > > > > > dma->mapped_noncoherent.      
> > > > > > 
> > > > > > The dma->cache_flush_required is to mark whether pages in a vfio_dma requires
> > > > > > cache flush in the subsequence mapping into the first non-coherent domain
> > > > > > and page unpinning.    
> > > > > 
> > > > > How do we arrive at a sequence where we have dma->cache_flush_required
> > > > > that isn't the result of being mapped into a domain with
> > > > > !domain->enforce_cache_coherency?    
> > > > Hmm, dma->cache_flush_required IS the result of being mapped into a domain with
> > > > !domain->enforce_cache_coherency.
> > > > My concern only arrives from the actual code sequence, i.e.
> > > > dma->cache_flush_required is set to true before the actual mapping.
> > > > 
> > > > If we rename it to dma->mapped_noncoherent and only set it to true after the
> > > > actual successful mapping, it would lead to more code to handle flushing for the
> > > > unwind case.
> > > > Currently, flush for unwind is handled centrally in vfio_unpin_pages_remote()
> > > > by checking dma->cache_flush_required, which is true even before a full
> > > > successful mapping, so we won't miss flush on any pages that are mapped into a
> > > > non-coherent domain in a short window.  
> > > 
> > > I don't think we need to be so literal that "mapped_noncoherent" can
> > > only be set after the vfio_dma is fully mapped to a noncoherent domain,
> > > but also we can come up with other names for the flag.  Perhaps
> > > "is_noncoherent".  My suggestion was more from the perspective of what
> > > does the flag represent rather than what we intend to do as a result of
> > > the flag being set.  Thanks,   
> > Makes sense!
> > I like the name "is_noncoherent" :)
> > 
> 

