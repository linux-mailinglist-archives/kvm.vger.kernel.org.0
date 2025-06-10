Return-Path: <kvm+bounces-48772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87533AD2BFC
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 04:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FC8A1893503
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 02:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48EC25E813;
	Tue, 10 Jun 2025 02:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uilk0fAU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A50924291E;
	Tue, 10 Jun 2025 02:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749523025; cv=fail; b=fA7VbuY+U7G+zcHaHkTBxllRSbmARXrRxLTiu6fCkVxMWDEWf4tyrO+IM7aDOGhh8ihZ3Kc18wJui2aPRJN82GrD9xR1EKk5T8YN0V+inTuZ964WzE21Am1+EnGBUTuw9taa4UqycUdPrBDn4DzxRNdNBRaa9esP+eHTPtU/Flk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749523025; c=relaxed/simple;
	bh=cicFvhm5/+82pSp+/92bYcrLjFjSzmuLdgqGSStm6qc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=s3ktAlP2BlfWGjR0P2L4rybKGkKpXuQd8ievfsdDGvqIFwMFo7PSCatyajZFn3T9++9QjnkRv2qQylR+Urgg1/n8KhjAkHBJWIcH3s0iEdg+F4VHozAKbQaWdmy0VLZlqKa/Yr/cPw3rOBqZ1BeQ/wlsO9y8yZZX0Nc853F6J24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uilk0fAU; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749523024; x=1781059024;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cicFvhm5/+82pSp+/92bYcrLjFjSzmuLdgqGSStm6qc=;
  b=Uilk0fAU3dOpGif/l+y3tS8VQhz0SHmCusfddIzodu1p38fBpsIKwX8l
   QFuryFtSHBQmRlmpayyU8g+kwv9UKKe/Bf6nfNa/w++537I5LwPLDM+a9
   ZZXelLENCMZQj/j8QV4ZuYI9yquTpYwzQcHdcMRYYktd3KuTPQxK8PsBz
   ck/WfzqmXbioXqmGnz4fpXSeAqcfExr/GP7+5cO6E8lshCsyg6CJ+ZSjH
   S070KV94maXfTg29vruc/Hlyp0ld7qM27+e1MeB4EuUJxJZh+2cZg+YVn
   mDcTEuVRjjGR0fg0PrahpCyZKsa2WmpKzEmdoFiiwE1Ii+mbFQhasMVJh
   g==;
X-CSE-ConnectionGUID: ISUCT20/QZqSYJoEjXdLWg==
X-CSE-MsgGUID: DjB4+vZ5TU2tqRD3xq++3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51757368"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="51757368"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:37:02 -0700
X-CSE-ConnectionGUID: NHQkPVbURYWncluMWISzOA==
X-CSE-MsgGUID: HTzHfUu3RVK0m0FOzQagoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="177626250"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:37:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 9 Jun 2025 19:37:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 9 Jun 2025 19:37:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.45)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 9 Jun 2025 19:37:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FdyirZv/j+Pa6fUll8DiMJuwnVIQ/vN3hHuQ3nqOL4nd8awgaayAgw29v6Ypke4RbF69zL9pnPfflvek/2hMRM3bm4Rn0RTEMSKfSQbFf1stMZoFJ8AzTy+s5VmVP28a6RPP+YtRqf4UXGGt6ej1ild0BnZgit/fShRTd9LXksMCgBYuVEWbxWF0tCBn5l7QSMpk/eOeKKE4HXg4AexstjO4NxmJawV4GnXYxOvjbQ9QzBLHJxOPg0/gp/0TE3X8LMkGTnLFQgx+MyJfr9a7gG0CNBTTigpJknkUkFFbNdiTK0Gyacvoxf8Yjswwt780p6WePeAS/NuWjG8WMDsFuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=II/5YiylKNiRWrHQfEe39eksj7OS+asIpL7g7DgAX40=;
 b=CmDhZCwbO0m2WT9RYYWqRREl16pFlzsEWTKY6uFneAgYJhUhp19FW4wGO3wQ00NK8w0+exkbJhRte0WJmQg8mPrcq2N7dtHTiUxAIZgRkML2V5823mmRNsGc2wcINKj7+s5N6FE1TEu3A+TC4Hhcl4emhHdEVd89XPWkkSqlqWOXzl37X2rPS17YI0A55D5aRX03MNRdLeLaHd8OmBgltQyWeGUzlGKSzE/TzGV4KZmQdIxmyU6NVOYnGl8pThhbDuoddpZXhz3nMlJuccOjALMpEgNTDCI2G1kQFucD2pb8x2lriwaewLNh0nPLpn/K18WRvgtBz398tF1R74GWeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB8720.namprd11.prod.outlook.com (2603:10b6:8:1aa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Tue, 10 Jun
 2025 02:36:32 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8813.020; Tue, 10 Jun 2025
 02:36:32 +0000
Date: Tue, 10 Jun 2025 10:36:20 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <dave.hansen@linux.intel.com>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <yan.y.zhao@intel.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Message-ID: <aEeaJH1KqZ38tgKi@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
X-ClientProxiedBy: SI2PR04CA0017.apcprd04.prod.outlook.com
 (2603:1096:4:197::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB8720:EE_
X-MS-Office365-Filtering-Correlation-Id: 8809b5b9-ba26-4877-550e-08dda7c79c57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0kx1yZVL+e1iPOUbYgxKBovyp7rbYtWi4bQ1HE+a8mkU8wGbPirHf+UsFMPh?=
 =?us-ascii?Q?nRNWRJXXj5N1HNiYYxx/olvyld6wyWXGmIeKPRImi0OvuSO/SjUMe1Hvy8yF?=
 =?us-ascii?Q?z7qzyBn9ltsFZ0JYeDJHkytYYyBQPTZLWpaAQGmCvvPcSgj3vy8U+SRuZzQM?=
 =?us-ascii?Q?bFtJ8H/JXrlNwqZyjpm8Um3oaiqFfTFOhwYDU9+hrXKjiNmcv85u7CzcJ8nc?=
 =?us-ascii?Q?hzOKaHz97bombRbBhhb0LC/T0SZOOkP2jtFStNmcddx+OfSMe9zH8qg49hyV?=
 =?us-ascii?Q?1bVQuFRBCX9FZnCDAOcCrD3hMi1HLSpgs6n7YzLBSz9l7fa0Uyzy7cQ29jwQ?=
 =?us-ascii?Q?H7O/9wk2KP/jH1tZRENaKGURShipfyfqivEiQ2/7dJBUYvv5b1rVnc3aLN4c?=
 =?us-ascii?Q?iqlsvqyLn1jkCyXFZ7giU4uyuTvoBdhaFiSPBAWteqikiZWFyR6Mam+L8MZP?=
 =?us-ascii?Q?E4pzVdRWo6SQiFW/VmTDtwGGbr8ET1tBrFWCwgjm5TR76fVtXL5P58g53Ofk?=
 =?us-ascii?Q?oL6uhB+K5R+25Jg4ulACNnRXny1wlr/AOI2dqkKjcVivjOFOxe29yq9Klh8p?=
 =?us-ascii?Q?wMnZPRk8wP8b1SUSojpaShtjOMTxjSRiBgXx4pWCwC6k0pilQXvwxy7nrtvZ?=
 =?us-ascii?Q?2KceCLzBaOMtEaO0IHCu0nMbr68wlkxnDneeJ7CfHtbjebAInuv/f2ng3gZJ?=
 =?us-ascii?Q?yMA0qDEYbzpW5Vsety3hAewqet71x7YQJELcWozSpQrpYivaKcbXr1vfHJP0?=
 =?us-ascii?Q?ZJSkSkOUKzvH5eH+TgI2+FnOLfGThBzDsuS7FwHawUCQFE52cJOctZ9Dpu0K?=
 =?us-ascii?Q?rGO/jSzIwe87ph6c3BXz8XkBStQ8SrhFny403H2tdnb4+hwGjQ5S5jGNSwGl?=
 =?us-ascii?Q?vsOVpOurhGA4SKeCtD3tD6dIo9U4WZN+8+CsK+QPkre1G3iH4X1nQ7cS/h10?=
 =?us-ascii?Q?nUGQ/gXGan8sqiSO0/IdF+5jrCdPsc1wK9VG7vDHwIpNQvz5kffLOoA3TIDM?=
 =?us-ascii?Q?zQ1DRQgM9Ee8BJY+YyssiJbIm78XAkayT3QW5AhteALdV/gS3oMZXRUJu9KJ?=
 =?us-ascii?Q?fUpv/e+59x1jugV/hnzieoytUFMgs1TwUKpWeMJ7zicFglcMBaHWhcxZw6B1?=
 =?us-ascii?Q?ooPswmGR1tEeCxUBGCq7Oy3lDafwCiEcEaOta+kQ6WaxzunXBCDyAyPl4Fef?=
 =?us-ascii?Q?CCns/Q7wKqQz8mafwQt9K2vIdd21JWdjldKmc1M/D3YyVIt5lCpHh3Oe9aLn?=
 =?us-ascii?Q?3EjoHZ49W7xBeRK0dwn8uFcsQLotQYXiMBQpMXgOhYyfyQWGBTbT8hwuEFKa?=
 =?us-ascii?Q?YEj4LbjzzDx77yCH/900zJoSLlFK1miWCDc1CxQPhfrvLTcz2OxW3aF7k5cZ?=
 =?us-ascii?Q?PhiFjrQjL46HToosQba18Tgzk+X3bJWN9+PEMiVWODLvqtP1KBrH/jGcRX+/?=
 =?us-ascii?Q?O7p9LqzWoH8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oLzfUexQmq+KISlKaJBsSAL57S5VE3OgQS7SDNVx9YefSxeKLCj/nWYHMLnL?=
 =?us-ascii?Q?DD5Swhk+iccaiHgN4Z6iu4WiVHN7d1afoRnZyuCCTMkdTUv6vMVlOWbX/lCN?=
 =?us-ascii?Q?Flj9QJAdxaEaCdwETE8QGY8Y8+re4z4aG8G7+CKiKw3eAIYqHug8WBg/guKL?=
 =?us-ascii?Q?YTSJSHYX3eEy75qkm+ALgSz18G1geuWpsTc9yg4uS07nj7aqeZqFEC6IGywF?=
 =?us-ascii?Q?uyS2kH64+FPjvBatDu6Fo7CktrqVj0Pz+PhRXGK9BTwyZ82G82VebDHWyaFj?=
 =?us-ascii?Q?sMk7Zs+981PEuINjno1robM9rqECnzYH55n9WxSFmFse4JN5baJamdAmeO6g?=
 =?us-ascii?Q?+hmkAjsBSUKd9OTMvws4nv8mSu6MTC9zw2xXKtaTfFFK3sxFbM2h3N2def5M?=
 =?us-ascii?Q?AIsdhAeECU3QWd2yM/GS+LrNW4vIZmWHxtYFz4YpAeohL2VIB4uvMo3ZJ2s8?=
 =?us-ascii?Q?hW6raGaBX4ix7giF83yeTNIX7QCBpibH1fbHXxuB5mvPtRlr9tWQZLlu9Qy5?=
 =?us-ascii?Q?aOBL3aGAAazkWIxZS+QbeyjkE/p6Y+l116PgjGocdLLGB0bKIOFe2G6Hd1dk?=
 =?us-ascii?Q?sezbxZmFj+n3HHMqpiBh9sR/HR4l5ssa7p0ZdnKsNlKCixE00YCsloVzzyAY?=
 =?us-ascii?Q?vmBR8RIys1y/zjnDQbXVYoH6SJfeolPhOcA4KJEkavb87OwiYayBGT1Jxwh1?=
 =?us-ascii?Q?ruGOQxh9On76KiJ424bijfEFDNxgjKruAqQASGwxQyHuq6KrJ4aX4wnWrqlP?=
 =?us-ascii?Q?x0RBLdCMb/S/cMUAGJkfpWvVakV+XU/3YLXXYSM+qj8mOk5crR+BvhOC7Pr/?=
 =?us-ascii?Q?ROiwPjFDoXNQtrv97lD/yUqjkTOw00kEmVN+AHaizVKDV/QXZpgx3k5aBNf8?=
 =?us-ascii?Q?MdIVytRWMF0YHu4O5NyJC/QsayLlP6itSvHcSZ93S9vNG8qdM0dN5MNVivbL?=
 =?us-ascii?Q?TBauu/d9yYmYvWmo+XUpfK830+sZd7W3UytRf4HwHZaEoURGYF/RNnXHUzOj?=
 =?us-ascii?Q?+68gt9+L1JHFBOCnpabprbjpJKhzpgOe/yU7cWvsT/6dO8n31Jj18zC3qvpJ?=
 =?us-ascii?Q?0hvX4wS3SwTBqPmdykW/QC1Ao8Y1nwVV1JOAQWgicmXCKAbY0zFLiy92kfD+?=
 =?us-ascii?Q?kkmbshZPFQByfgTyHrdW2RnACxYtYg5i4i0nh9w8bnavtGwcg79dJOdurDaE?=
 =?us-ascii?Q?kJ+/X/C4adnHiNyKkgq8tBatMcLHCSZ336XTNeeMUexKQ4ywdpCtoeNFar6M?=
 =?us-ascii?Q?BZcfnChjJcqyRxZ2gxf68za0D77qRqBUVp1AyPMLNOgeOUyJcIBCGH9SaLll?=
 =?us-ascii?Q?A5AqPc9i1PfM6XliKhFwmtZ/Xgr0hzSX8eipg2tOt2awNQu7xUWCHzG0IiO9?=
 =?us-ascii?Q?4DTxDnNJY73RKZgD1SjhJeygfCPdW/rQ33uJtt1+Kh6IE/S0l3HPhWASD69/?=
 =?us-ascii?Q?qWkxiPJNqmfg0ig4vm89me4O9sSVE0+hQloiVEjVnNh8rG4bIK0USwBsC8SC?=
 =?us-ascii?Q?Dov8NNEbTLPzl6k/nIIo9XR2VWuvguo3T3OnbV2YWaU5y5F6hvrWktc9hPcK?=
 =?us-ascii?Q?4A4o0YxNdW6NelOmjWQOb5Sx3HGkFrzryGdBMI0e?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8809b5b9-ba26-4877-550e-08dda7c79c57
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 02:36:32.2198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e83gMXqnQBiMKJ59RuCMR+8ZCcL0/Aq/PHzHjhcCDY0P/OLLSHULPsFN0rS6Mea5VHruEeHKND3572KYLOCIWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8720
X-OriginatorOrg: intel.com

>+static int tdx_alloc_pamt_pages(struct list_head *pamt_pages)
>+{
>+	for (int i = 0; i < tdx_nr_pamt_pages(); i++) {
>+		struct page *page = alloc_page(GFP_KERNEL);
>+		if (!page)
>+			goto fail;

this goto isn't needed. it is used only once. so we can just free the pages and
return -ENOMEM here.

>+		list_add(&page->lru, pamt_pages);
>+	}
>+	return 0;
>+fail:
>+	tdx_free_pamt_pages(pamt_pages);
>+	return -ENOMEM;
>+}
>+
>+static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
>+			struct list_head *pamt_pages)
>+{
>+	u64 err;
>+
>+	guard(spinlock)(&pamt_lock);
>+
>+	hpa = ALIGN_DOWN(hpa, PMD_SIZE);
>+
>+	/* Lost race to other tdx_pamt_add() */
>+	if (atomic_read(pamt_refcount) != 0) {
>+		atomic_inc(pamt_refcount);
>+		return 1;
>+	}
>+
>+	err = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pages);
>+
>+	/*
>+	 * tdx_hpa_range_not_free() is true if current task won race
>+	 * against tdx_pamt_put().
>+	 */
>+	if (err && !tdx_hpa_range_not_free(err)) {
>+		pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", err);
>+		return -EIO;
>+	}
>+
>+	atomic_set(pamt_refcount, 1);
>+
>+	if (tdx_hpa_range_not_free(err))
>+		return 1;

I think this needs a comment for the return values 0/1/-EIO above the function.

>+
>+	return 0;
>+}
>+
>+static int tdx_pamt_get(struct page *page, enum pg_level level)
>+{
>+	unsigned long hpa = page_to_phys(page);
>+	atomic_t *pamt_refcount;
>+	LIST_HEAD(pamt_pages);
>+	int ret;
>+
>+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
>+		return 0;
>+
>+	if (level != PG_LEVEL_4K)
>+		return 0;

This also needs a comment. i.e., why return success directly for large pages?

<snip>

