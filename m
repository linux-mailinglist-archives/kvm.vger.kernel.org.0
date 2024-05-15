Return-Path: <kvm+bounces-17418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 288E98C6125
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 09:07:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92296B22272
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 07:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F08443156;
	Wed, 15 May 2024 07:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gSI5fP8l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C61F41C76;
	Wed, 15 May 2024 07:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715756863; cv=fail; b=fLbVfxFGelnRuxbK9Y3qiZ8Er1tFJ7OSmG92Ri6nXut2tplY+s9Lub/Ki2CHWupnvN12elAku+eKe/IhslgAki/G8AWKX7SYHOVZ3l4rmK4+8B5r5LU9NfsC0zJT9KTdAFRxQrDcYOSuPtLp9bnA06qed2IhO+u2GiFwPEPFYPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715756863; c=relaxed/simple;
	bh=s/vXJwRpUEK+4eKFwHE5+OsUFmO9SfGVhFGge5rkCGQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lbpn2dKir2a7TbUWPGWIvO2Lm7EORNRpWO7fLSyoTYKPDPvxEMNKQ6PIVVZoIczPyLdSI6MUEgqOCoJN0T+8uaQwjhSwwyPfNxFQ1h0i7SgoVh0nPeUAIuAF11H7GdeBcY9OquniaSoNz3MWnjjpB75DgkHU078CIkRvzmNjy3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gSI5fP8l; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715756862; x=1747292862;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=s/vXJwRpUEK+4eKFwHE5+OsUFmO9SfGVhFGge5rkCGQ=;
  b=gSI5fP8lppe3JSD/h5+23kmtKqoP1J65lvkRSQzNnEYBengRB6JoL1Xk
   nn67HzsrGkLlQL7Lgq+Cho9R39ZiLBi0DpGS63l2FpJSbgqaxyozqEUVC
   dgc6tMpVFQJQsPa/zxcNJekfi1QelxM6qBgZPQLDbXcvb3BzZedo3c4fb
   8yGwvhhykbLEjxzTATiWlqANnYHfc1M9KkNl3i+IAD/CEWWwJu2dptPHe
   z7VKn9tNNs8s9qoLVbZqG2tvqEPAx+dQzI6kltHFEJaDKsyIt+o0JowHi
   dSvq+BzX1kBXHY0F7l2ws50H9MGxB23llCMGCTuGkGvdpOMFnd+q7CMtg
   g==;
X-CSE-ConnectionGUID: PkRIzyczTg2P0rrivUf6xw==
X-CSE-MsgGUID: znwJY7y1RymAnXF9XCRVCw==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="23185306"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="23185306"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 00:07:41 -0700
X-CSE-ConnectionGUID: /33rBbFsRFyhVVoEyFTHpg==
X-CSE-MsgGUID: jgodqBaoTYWKsvhnpB9F8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="31039141"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 00:07:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 00:07:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 15 May 2024 00:07:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 00:07:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 00:07:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mB+IDd+B2+8Mu8KVMPybSKhj8CDlOyna8i7ZTEQhcUgFeC6Ex7dQssm/pWK9ckRtto3JOn0HmRJryBvFXgiti85qIBjAECBuiGGH6v8dA20ipMHHWTXcfc5C0TZHX+7UvCL7DWa3gZxz63WF1Xdd72LHyJ18M8GnHKYF6XUVn3/pqUmBN+2q72A0RdNoveQLemLCUwtklxolWubj4Khl6p9KHYpmwdv/grxhCQPlzkgO1MkmVDu/orXRn7kvFnUGIvMoDkqtilDqNKj9oy7zz/F40HQ1SxamuwlRRNJ81ESqbJmq1VKQYiSmtoRNiSJTwrAnSRWSikqMiWCzXI5JxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8GgI7g0RGpGMrnTIBFxW5/yYUbVOwlFMue68q2Ilkw=;
 b=ZinMToY36+mavkm8RmBwmiB+WUZV68UCoo3RmchdyaeiAlxxFRnSSeCJPS9yHZSY3jzbamtHdyy2ZNJ2ixPODEH3pm3L9M04wrKh2qM6ges6BubpEhEt3Iny4Bl8eeFrRhrc6DfksSqXN+GVNKlCpUjIRarX2I7vPqvO5i/CRo3Yr7WYn5RYiILL1vQJY7vLpeMhANr7U+qEbwmETvLFKMdph/vE+248tfygaTel8xHsBf2104D5yMuNXyPAWNpjbF5iOU6dwsJs4ISc3KD7GNNRVZhGAaz4jZBli8Zr62dGRxaQdzeLTu+EhaE2WLQ6jZ9I8fRoObHi3AbslKx2bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by CH0PR11MB8236.namprd11.prod.outlook.com (2603:10b6:610:184::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26; Wed, 15 May
 2024 07:07:27 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::6977:62ac:420d:3753]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::6977:62ac:420d:3753%6]) with mapi id 15.20.7587.026; Wed, 15 May 2024
 07:07:27 +0000
Date: Wed, 15 May 2024 15:06:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<iommu@lists.linux.dev>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
	<corbet@lwn.net>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
 <ZkN/F3dGKfGSdf/6@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkN/F3dGKfGSdf/6@nvidia.com>
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|CH0PR11MB8236:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fa519ef-16d0-4dd0-cb48-08dc74adae0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NMkt/Bb5IKhQNXOZqJSD0xrcIKeUFA64fZWZIogdZ134hMO/49oK5DpW2nwY?=
 =?us-ascii?Q?eWeszZrxgrLlqoTZpsTJSoN4VK5mEacv2/FIrQd1xdjpDAc4LsP3pBHPYnde?=
 =?us-ascii?Q?xKlH+J9X7yZhjpjZLKRMqudl8X4GP/yjcKrLUZnVayk99M03DNyaTqGc4Zxj?=
 =?us-ascii?Q?nJuXrVHwmoJYXicWejyGnqly+z6nNzdI1g+6+w3IQvhAMokrqo7kennz7bcS?=
 =?us-ascii?Q?933YmXSowJvGbIjzAlhR0MP6M7C9iVJkAtz6bTNgxANrtvzES+ZLPwlAnoPb?=
 =?us-ascii?Q?Uj2Mf9UW6o/b/2/FFiZseP/TTaUCk59q9cKubhfds03G15S82y8CTDGWzUqm?=
 =?us-ascii?Q?2bfwH0cugp6ip4QmkyLtlBHKWLu5yZXyGNlAUJg+q3LjkKisC+j0IR9fhzfQ?=
 =?us-ascii?Q?Tv555ItLY+0/NVm9pkoq/UTVEm8H6gztxZZQzLAa+6oMI0CVZLGS0J2Q8Z+Q?=
 =?us-ascii?Q?XRmJHYo0ZNEqIZXZLyKP2Vq7EAYD3DWuKtkHwHtLbocWLAb4GGU14PseY8V+?=
 =?us-ascii?Q?JYc1psAEMnTg2BGKF18nNGmRPLMug/whhhPpNtgVNz+iyK8icNECYZh8HHJe?=
 =?us-ascii?Q?+qXYxj6v5ZOf+zEJRcocg9XFuoVPTg/Qk4nspkAkaRA8Iq5uMko8OyG4PMTb?=
 =?us-ascii?Q?mapgRUFYfZJvu6D79RSjQL66o5qtvjdV/dU3m6CoGi1qgVOFahN2zVdweKsp?=
 =?us-ascii?Q?QndZnAj2mx4tHmAE3qx9N4GiIqEX07a0LV+rEt7UtYfi1s9NowIpIQ2VQQLd?=
 =?us-ascii?Q?W+2TglKCwtB7joqRCK2GQ/10JAmbhzdsVM9Vf5rFLEuZ9iJCrhr1FXE8utJj?=
 =?us-ascii?Q?gEvM9H5VIRfYZWb3FmmZ/23mdkGYtTYSp6a+TKrMr8qRV6DxUi7GGS4+kDY0?=
 =?us-ascii?Q?hLGqmK9ATFD5fHSz0j63wOlE6GyY9igRrP1F3/KrThDtDS9tWXPiFAc35vzL?=
 =?us-ascii?Q?a7KV0O223YDmd4z82fw6ETFi8NWO2ad8EwHgGGrJzdctV/zKXt6usR5gfD9k?=
 =?us-ascii?Q?+i+6DyZ6y/4xCycieOvGMuaMvLIEtniqdFqwQJmH0IQueHtADb4Iv7zXh4Vc?=
 =?us-ascii?Q?jRXu9zbMpNPRJOHRIT/f16ZByCnEJSst1xk6JLgHP0lDm6LRkaJX3r/di1C2?=
 =?us-ascii?Q?K1r3id0VYcPcEH6Wd4X2gQ2d3e80YNzkuURJr7JN+x4F3Jm6PRVi0FlJDioW?=
 =?us-ascii?Q?n8s/vyWH4zRwfcAk6d+D3j9cOoUGHkRyxT9J8oKPDsQYp0aOC0N8DQMtBtbK?=
 =?us-ascii?Q?v30nq97ZjxOR/1aD9E0sQMgYt2pe2DcLMRtdw1OlkA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xalw6sX0ElzjVyaNmMIYIS+htcbqDxOCX6hOOji91YLA1mNiAZmneTDc2tkf?=
 =?us-ascii?Q?dEkQlpgJ+lrRbokkP9VL1LMj1i/C53I95PSdzNbT0IH2cgojJhzSa/TR/jwX?=
 =?us-ascii?Q?5PkyUC0qBRQ/YMzo+FE2zs0Y9OsQaqE+/P/z4bkQSHGnIoP4ckPyDg7AYpby?=
 =?us-ascii?Q?VqsdV40qFTa3om7mQCE3h7RAW6cnTxbW7JuItmSl2gL+1ExYLrZdqMpOS5Fb?=
 =?us-ascii?Q?JhoOvwvs6OgNzfiL/Y1rkZ/GLwtQ1LfrsPlPo/5mkZdU1OY9qBHL/wPYWjtT?=
 =?us-ascii?Q?CvrQidQVx5bg7EYO6kBLngPHPQfEvk+PoEVeVN5nfalzS8Bw7XLF4B2Ytrkc?=
 =?us-ascii?Q?mTx6MSWd2mjqyCSZ0wNlruZMB47lcrhBiwNo/id/g04jPkndcGrasfjZ/qWY?=
 =?us-ascii?Q?DmO4RN3HAacibGSXKqe2PdxZJF3YuZekByRAdU0DJ64h3JolXD+Xe/bUXi2z?=
 =?us-ascii?Q?oIoOZLPoUnnm+OPusq6oFZumf5/uG8M9rxTVJAkTDepY7J9ApqjMfAFmMG9z?=
 =?us-ascii?Q?uHd5OxIAp2nZUHHyaY3lguCJi1FcXA7M30Zo9kvRG4HKBX2UKl8aHrIguG/K?=
 =?us-ascii?Q?H4xrxzKKsMzHVu4i+E+a1ewXcNoCArOOrRb026PNpG/QBAeR9BAvua6m5cKY?=
 =?us-ascii?Q?JMvcM6tnz9aaeiozcClzPcmKHBzw4mxq799FmcCS3RnvFQ1DmmPkPBh55kcd?=
 =?us-ascii?Q?/DcarXwP9xH4EblIDnheNp+OXRav/uAp2Ji9SqE1nhZoJTOPlyBlc0qMLJVz?=
 =?us-ascii?Q?21w4GS0pCyOloyf+X5zqgGpu+bve4wF7S9UgXtujlcmCXieF4hTx0pliF8Ea?=
 =?us-ascii?Q?W/oxBE2m82lPUhFSfxzD9JtsHYUi73Afs8MiVvwLCr7klKvxVC7z+ApLEKEJ?=
 =?us-ascii?Q?cq6YmDsdw8eitR2TNvFkoGeV0Hn8pYaPSR+8zLlvkgfo+p1d+3nRcUum58lQ?=
 =?us-ascii?Q?jwgLrIjehlQSwXz8EeWTQLQ58zlXpf+SOXaWEQM/gLaVbpWr3e82Ue5Qabcg?=
 =?us-ascii?Q?C/ah7S0AZSzDW9orXkB5/kEp9BO81tivnI7kQmI0Wk25+166DIzlC8+ZecZJ?=
 =?us-ascii?Q?nbns9iXohMC+PFbhUvEKN2QUmol6o9kywwDzdmcBGI5RbuXV9UFbdnNnxJ5+?=
 =?us-ascii?Q?W3B4BXgrzrTvzwE6Wil0Dftpt9bUf6BOrrn7AwwxW1QAvDwt8k2PXP6qt5HD?=
 =?us-ascii?Q?rKQecfK26PmOV6jn/qxnDZV6hcuMbDd/jdJoZi/REk131d+G1Kzf4Ec/pv5/?=
 =?us-ascii?Q?/V4uv2Z9wxMgNJmfn2CnoStKgYh1pX0gzp2BAoWjGzR0Npoto31UUeh8AOm6?=
 =?us-ascii?Q?tj1XjeEPzkhUEhI9KKVLVHJqP7AfSwyPowe8b5/AZybHYBxCHspxGkop8GTh?=
 =?us-ascii?Q?7Eb3ONURr9woEw27F5Tz6wUn9tlPXmevCTYidiu+Zh8T9Bul7zed68S6x5Uw?=
 =?us-ascii?Q?X1J2nWzNYjVPfU6iH61uh2zxFrI0wchlMbVuskjqTmts8eVSfBJRuUBSVZyI?=
 =?us-ascii?Q?Z3maH3u2+oPMsofc4350LZ1051FOqAOvn7ABwtyB02KQuwZX9CsB3dFJVqMz?=
 =?us-ascii?Q?Qo6tbAuB3HouvbQq77Oxb3Slcd54h9sFHNWjN43s?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa519ef-16d0-4dd0-cb48-08dc74adae0b
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 07:07:27.9046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tg4PKOlVeMNnZzBSx0ipsP/H89RE4lhLkK35THN6c6yICyh+hLWeFmQz2eP6v5AJYVNMJVfkJjynI/ZneTtXcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8236
X-OriginatorOrg: intel.com

On Tue, May 14, 2024 at 12:11:19PM -0300, Jason Gunthorpe wrote:
> On Mon, May 13, 2024 at 03:43:45PM +0800, Yan Zhao wrote:
> > On Fri, May 10, 2024 at 10:29:28AM -0300, Jason Gunthorpe wrote:
> > > On Fri, May 10, 2024 at 04:03:04PM +0800, Yan Zhao wrote:
> > > > > > @@ -1358,10 +1377,17 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
> > > > > >  {
> > > > > >  	unsigned long done_end_index;
> > > > > >  	struct pfn_reader pfns;
> > > > > > +	bool cache_flush_required;
> > > > > >  	int rc;
> > > > > >  
> > > > > >  	lockdep_assert_held(&area->pages->mutex);
> > > > > >  
> > > > > > +	cache_flush_required = area->iopt->noncoherent_domain_cnt &&
> > > > > > +			       !area->pages->cache_flush_required;
> > > > > > +
> > > > > > +	if (cache_flush_required)
> > > > > > +		area->pages->cache_flush_required = true;
> > > > > > +
> > > > > >  	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
> > > > > >  			      iopt_area_last_index(area));
> > > > > >  	if (rc)
> > > > > > @@ -1369,6 +1395,9 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
> > > > > >  
> > > > > >  	while (!pfn_reader_done(&pfns)) {
> > > > > >  		done_end_index = pfns.batch_start_index;
> > > > > > +		if (cache_flush_required)
> > > > > > +			iopt_cache_flush_pfn_batch(&pfns.batch);
> > > > > > +
> > > > > 
> > > > > This is a bit unfortunate, it means we are going to flush for every
> > > > > domain, even though it is not required. I don't see any easy way out
> > > > > of that :(
> > > > Yes. Do you think it's possible to add an op get_cache_coherency_enforced
> > > > to iommu_domain_ops?
> > > 
> > > Do we need that? The hwpt already keeps track of that? the enforced could be
> > > copied into the area along side storage_domain
> > > 
> > > Then I guess you could avoid flushing in the case the page came from
> > > the storage_domain...
> > > 
> > > You'd want the storage_domain to preferentially point to any
> > > non-enforced domain.
> > > 
> > > Is it worth it? How slow is this stuff?
> > Sorry, I might have misunderstood your intentions in my previous mail.
> > In iopt_area_fill_domain(), flushing CPU caches is only performed when
> > (1) noncoherent_domain_cnt is non-zero and
> > (2) area->pages->cache_flush_required is false.
> > area->pages->cache_flush_required is also set to true after the two are met, so
> > that the next flush to the same "area->pages" in filling phase will be skipped.
> > 
> > In my last mail, I thought you wanted to flush for every domain even if
> > area->pages->cache_flush_required is true, because I thought that you were
> > worried about that checking area->pages->cache_flush_required might results in
> > some pages, which ought be flushed, not being flushed.
> > So, I was wondering if we could do the flush for every non-coherent domain by
> > checking whether domain enforces cache coherency.
> > 
> > However, as you said, we can check hwpt instead if it's passed in
> > iopt_area_fill_domain().
> > 
> > On the other side, after a second thought, looks it's still good to check
> > area->pages->cache_flush_required?
> > - "area" and "pages" are 1:1. In other words, there's no such a condition that
> >   several "area"s are pointing to the same "pages".
> >   Is this assumption right?
> 
> copy can create new areas that point to shared pages. That is why
> there are two structs.
Oh, thanks for explanation and glad to learn that!!
Though in this case, new area is identical to the old area.
> 
> > - Once area->pages->cache_flush_required is set to true, it means all pages
> >   indicated by "area->pages" has been mapped into a non-coherent
> >   domain
> 
> Also not true, the multiple area's can take sub slices of the pages,
Ah, right, e.g. after iopt_area_split().

> so two hwpts' can be mapping disjoint sets of pages, and thus have
> disjoint cachability.
Indeed.
> 
> So it has to be calculated on closer to a page by page basis (really a
> span by span basis) if flushing of that span is needed based on where
> the pages came from. Only pages that came from a hwpt that is
> non-coherent can skip the flushing.
Is area by area basis also good?
Isn't an area either not mapped to any domain or mapped into all domains?

But, yes, considering the limited number of non-coherent domains, it appears
more robust and clean to always flush for non-coherent domain in
iopt_area_fill_domain().
It eliminates the need to decide whether to retain the area flag during a split.

