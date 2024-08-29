Return-Path: <kvm+bounces-25419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA99E965397
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 01:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 665B31F23110
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 23:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD9D118FC8F;
	Thu, 29 Aug 2024 23:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FRF7n+6M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29E5187843;
	Thu, 29 Aug 2024 23:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724974903; cv=fail; b=a0BDihzGPF2osifbYUQNw+mM4aTNijBZgKaDFFRxiqDEnYQSosir9YcJxFdZdXr7DGdEO0WEnzexMB6OsstqYzDeX92luPpARbGocWTacu3kgCnBPEvj0HkwZDv8PyIQJL8OavtnLYq/xI028iouuEAv8GrsyFbEO3YSpqdcVGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724974903; c=relaxed/simple;
	bh=Qd5TRsKbe2gX+YFOD8JDbkUqbTVtp/k2O1yoTvZZN1A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k0ozKXN5aK68AACCOSfa+4OT3nqVP8EwKJFmXNqcOMg+GMJEBaHy3+uYyOD8jhK5ZXBCJI3Xb7UGDY5daDaHSDTdksiN9iM4165bWy1uC8K5T0UkRsL20jwUFosOzojYu92yyfoU1PwGs9CQCqJggt0rOMHWOxFKaLBNjFhteng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FRF7n+6M; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724974901; x=1756510901;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Qd5TRsKbe2gX+YFOD8JDbkUqbTVtp/k2O1yoTvZZN1A=;
  b=FRF7n+6MA5h8pselBT0nxf6LdEBXoU9sgRIq360ou8OubOzAvlttJ0Fy
   CGlvIEGR7z8zfdbHnfaANuC6ZHGbh3HvmPkN3NVlHhyZt6X4YFZC8TBdO
   Aao1cBTtqfqt6p3MxUokcbJfAdqRXHlmZCVH12o2WGeieKB7fPXcP8Oza
   f+f3aTgGZZ9RGbQX41ug1WBhsFZungoRsqfKZTpn3QDD1n+rk/JBAsbro
   H7mD4kBwr4Y4gUizmDSf/aGEf12aLP5X5csevg/1wc/6ZmA2mOnO5dYBY
   hhyVhmGUDP8cugK0hY5aSaB+EAoWSmGbN4P3pa0+oFYxqIe8PZewaTenl
   Q==;
X-CSE-ConnectionGUID: mgGq1+OPRtW1hyMBZ+XZ1A==
X-CSE-MsgGUID: VUkbabfqSYyoUvi5Ahm5RA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34977071"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="34977071"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 16:41:41 -0700
X-CSE-ConnectionGUID: kszvPSsgT+ixe/+aC6rbIA==
X-CSE-MsgGUID: TzhO27nmTAKJJPpDpXfg6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="67890456"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 16:41:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 16:41:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 16:41:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 16:41:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 16:41:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F2ujXcPvE3e6XM3IY1vQ571NgYX3dLgcRhbMN9V5rZ9bJr3bAkwaxyTJjNIY5SSiHcz3K0xBcgfzgw61wAEqK4Uw9nm2VFqSzmV6D9oTXRlcsx31Uu8PgImz5jBb9ErRDJTYAoqbSW4db3ih/5RQOsVY11URw4QwhhXzATgxRdZz+Y8XBMsR2LGQds6QdklCDk1bnB3uTGv3BELFDurWEkZWVY1cJg310AY6FKtVIuNhPD8n9aXEEWu+PgxJLR/I5VwC3sQTS3K2kdbx/cTnd341ntBNxxm9OlZnBBu/hooa7OZHwoUMgbRJh2G/U/P4c+gICMYQ+4viIZaEuzqgnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mEUXfnqz02fzFUqRjQGMabClB4KLYxbq1mu6BAfCS6g=;
 b=UocW8yidQkXT/mLXbfpHoNYOoGqdDuVteY89kxzcW2qp84OYth+6lfytL7Yyj0+ymoWqgU4/Euzc7rb55shDhjINQfg1n0rs18awDzu8E2xC/p8PB8qBlkxXV3fzqMiLe+hy2I1h1V3qz/Oh5v7yeMu1KT+KuW3RndZOTDYVe+Y0QuZzDJOUFuHACEmzNEDMFX8w1qT60g72JeMmJ9h6N7JnYw71T0yYIRjgHOxTmRuMOdUtBSVRp4jllQhfA8xRb+LFS+U8v2V+F/PDMxEKzwqcu08PB4Km+hbOf7vM7a1wrxGhWAwam1a9KG3kpP1sdiLkdS5/IY4SUyLVsaDvuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA2PR11MB4828.namprd11.prod.outlook.com (2603:10b6:806:110::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Thu, 29 Aug
 2024 23:41:38 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 23:41:37 +0000
Date: Thu, 29 Aug 2024 16:41:34 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, <pratikrajesh.sampat@amd.com>,
	<michael.day@amd.com>, <david.kaplan@amd.com>, <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 00/21] Secure VFIO, TDISP, SEV TIO
Message-ID: <66d1072ea0590_31daf294e8@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <66cf8bfdd0527_88eb2942e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <6cd62b80-9a8d-4f01-a458-4466dac6d27f@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6cd62b80-9a8d-4f01-a458-4466dac6d27f@amd.com>
X-ClientProxiedBy: MW4P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::29) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA2PR11MB4828:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fc904f5-1329-46a0-69ee-08dcc8841ff7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rNsNNNYAtpOd49M6Ul4CYj3ngF0A2AjDPLWvCI7W4YyucA1+EVoFMEg3cr1E?=
 =?us-ascii?Q?LP2S7EXthyzcQpELf0xmc90r1isbh400mELxn8q6x2oBmrXGx8+IBKKWeuw2?=
 =?us-ascii?Q?o8P/4v8lFLAhCtJnG4kIndLEFetEShOrU5/Vlk87Xt6ZveFrnEn5hv9fAlFy?=
 =?us-ascii?Q?HkldW92yCLjmpXOHnhj7HxBBtzsKAi5bFWc4jfO26n4kStakVj7zVmY2lYEr?=
 =?us-ascii?Q?YdblEfPJS2hXlz7P2FVh9E+EkNQa9RgGgiQDIlNjF4knDnXbS6MNTk3dei7U?=
 =?us-ascii?Q?GtCK0l74G8kadkbFlJfLOxF9UgRlGoiDRoykunhNpPMZKWe4Gy/cSe1+zrRX?=
 =?us-ascii?Q?S5joinxnXs3J6LY+EwxjXGBaEn0+zgiFjRPQV/h6kbYZube4WHXKEIH9VM7+?=
 =?us-ascii?Q?A37lCHrmjLAHK7MWNTirgYUUQ/+E73bZnJaXSFJ+2SORcvrWvWIliZfiiW8s?=
 =?us-ascii?Q?g35k30bQJnCkmNUG9ep3nEeOFb+aHBhN34SabFOUorRbjHVBW+arZEvmHHVr?=
 =?us-ascii?Q?7W1nVc8BL7MLSdIE5G8LqA01dR799YNsSMew17imLT+DhOsP4ral38d98ONq?=
 =?us-ascii?Q?dKj03SmzbKIVirEc4fsOt+Oxgy+Vtuqv54r6jcJUD+/9EWxeV1uG31/wWzXa?=
 =?us-ascii?Q?WE5mao7aR8x7KKb5gh8p+6ns2GTVJ4B64/lj/pHXVypwdWbUvrmmKLxknxUF?=
 =?us-ascii?Q?k626wNkpccudHItEb7vVEJHk5nRf12C5nMicBSH0LzO05iL0vs8NCruLGPnL?=
 =?us-ascii?Q?JKXRXy5EDvViEWP6p2mB9Qh9yEaeevdVl0Fjwlxzyu+P6TGPf5jCn1ZUMSSf?=
 =?us-ascii?Q?BRjdu3/nSxReCGc8dfFGkcX5QsM/hLzAdJgWwo7WRwpg4rBQ86xow3ER03iO?=
 =?us-ascii?Q?jGO9zRv3BX4xMSLrziV/oJdww1GMxoOGSj19BjdO1gCUMf+0ikx1JwiJwArX?=
 =?us-ascii?Q?RW6jSTaXn352/1LDsYmq3x6Enkkmet2hZ2Ui84H1DDUirQN8WZJ6WN+dluw5?=
 =?us-ascii?Q?UoKECfzIC1hdPoeGWhXwSXgI44JcBdEKhn/dfVr6PDvCA5rwtZjL6tVM5BNU?=
 =?us-ascii?Q?U1xmkn132S0Cdd7Nzm0+7T2tiiiNU2bJC62B8Ylq6TvJ6Y0BoOyLYvq3QdYw?=
 =?us-ascii?Q?GA+6aey4ngrfFNCJM6zBgXlkSfsyxOBDqz3YaLxxMASoFwDt8M9TPPn2vNba?=
 =?us-ascii?Q?p7Da9hyTDRf/yRyf0tIvYCmQlgIzPRZBLzuW3vW/DGHMcjO+nU3QM8bSojX/?=
 =?us-ascii?Q?EfA3kbQpYWs7DWu9WJqRwxzI+vC0qw75Qtk9QWrLmhr9bMHspq2q3ZWYAPpx?=
 =?us-ascii?Q?RhYJmEUGXp7dSSuG+PgaHW26vcWAerstzmWGJc3QG73BQQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7gVfGZqd8o2mPn8kOfUFwJwO/RAeaLmXsbCRbk6z+DqUDF/88G8v6h/54eoS?=
 =?us-ascii?Q?67qGK7rsPppx2uZPyp/8r2kzQh3Fy+Wi9dODZJs4r8+rC/vGK1s1Ls1j2V32?=
 =?us-ascii?Q?ibiquatI7oOzUntsU+YUy+qc/m8xXYLkTcwsoxIZ2UIB2aW/XT8wIpBrAZ+Z?=
 =?us-ascii?Q?02JhPzdv1aVGDRsW2ZQEdZ8pv5pRQ7NJb+S+cnNkgvK8p1Ak0IgaznnOYKVs?=
 =?us-ascii?Q?+V9eobN9LuZV4FwGKmg0MdIW0CpjegqiBRpxM/tKGxI2zv4+baTWlReY4im8?=
 =?us-ascii?Q?uoTgOWb/FwIGAhA8crVQPcYmG1I09hhb+Tyn0lh/Gow7+iyMYADAG9GoUzFS?=
 =?us-ascii?Q?azZ6TDyQLOExVMWfj7FM4ZnRL6k9py6yxOvjKvns2bub1GeBK/TvRMDD3dQZ?=
 =?us-ascii?Q?SngrSzOl1mbh+6jwOMiMFMI0V0AhDtk0IA50Q49yiGunXkjX7noQv7NNVyFL?=
 =?us-ascii?Q?PRB02Iyie4/PWyy2318TxsT6N7v+l+O1+j2wg3uZYJGrn3cPv18Pe1QwbRrj?=
 =?us-ascii?Q?Cl2HASJg2c8rkOt9RwVCu5DEP6ZMBs8KT0f9jSXJ0g0GpXGHKF9Yc5Vvy7wq?=
 =?us-ascii?Q?AxOO50DHvhQJDJ4hqjOXn7U4Wc4lNH7/DaJ4kueZIVy+jKZLrEqe26n4b210?=
 =?us-ascii?Q?en1kfwH/otSUNYcO2IB4oXP2Hl761Ul47toYkHYVMwXQ57S0MpiyML/HVup2?=
 =?us-ascii?Q?jhovQ6sp0I+ovSbOa/OnPn4RffWi/MCB2/pj7ivYr29Ra/qSOdCkV/gf9voi?=
 =?us-ascii?Q?DERKM8UGNr9hRIK9tCN0VWiUE7PZ4juI8zoHyD/aFar/p6+TJe4L3mq9qoeD?=
 =?us-ascii?Q?kuqTsOD+O07fQnZ8wgyqoGIq7G4Wxms2INvSI5Jtx12jbDDfVfRRMoGYyF/k?=
 =?us-ascii?Q?RW/+ojVp7OcQ45NlpnDxCucglx29tKO79mg6iF3MsR0FHTv2sD+/E72IAxgs?=
 =?us-ascii?Q?Q2o/KMCoZ8PwkJN1iJRDaI9UYh9wXPJzD+kscb/zsuJ8wZ4ybg6wqRlxgf1F?=
 =?us-ascii?Q?vZzwHsxETsaMPrWw7Nk76zOJrdkmzv7ZgD9dNwHEalzY84V3JzQuY+X+mrAM?=
 =?us-ascii?Q?pP3XtAhDWajOcGjdtG5Hc9gOgGTpoFNQr8NIxr3JhHa4tD/JQimp3QHrmxLY?=
 =?us-ascii?Q?F5XO5VhdokepueW/TJJuf3N6OeMexCJHIxgMzPSJ1yARLdzy18Vugcig4jqb?=
 =?us-ascii?Q?ElSLumTkUJUWgkACvDgBc7A37FqDHbhrTK7kz0j82f9JDpbPX87x1uMAX1g5?=
 =?us-ascii?Q?hRrQWY24L3Q1Z8Mq43e3lK7JMn6wW+pQlVwZCVSt3ZYktYdkEimvBugE6Ukv?=
 =?us-ascii?Q?BbQoQBzj9UpusMmqRy4bPUrhE+U6BDSmU/zxOC1zKi9l27P9L7r+Iiihr7Ro?=
 =?us-ascii?Q?s0LQFOooQT4mUH9+ddiaw4qbySXLPqmd5qsUB/OybooSJO1wyj3t+AMNHmP/?=
 =?us-ascii?Q?gFhE+6Fbk5snWs+6PCa/u5KBQ620QjZ3im674mP9gRvvjDttnZ+Z43Tebht3?=
 =?us-ascii?Q?qqcn8YAe0fgFO5k4EnVYc4uuuJ8IB+KEZo3Fk2TQVtwRG5B6lj83R96fgMyL?=
 =?us-ascii?Q?pIcxa26sgVLVe/TBwnlVL2Gba0F3L6bh4VLZ6tpo6V7I/CXVEcGbqrIYDiXo?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fc904f5-1329-46a0-69ee-08dcc8841ff7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 23:41:37.8353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GjI0pgO8LdKoJZMRjtD7OmUVz5Sxm+qmkBUbnGPoeT9nxGWTJU6BwtxKt4x0XIVW22A0sYu8TZeB3zSZE/r5O93iDhdUBjQXfVQOpl8u0Ug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4828
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
[..]
> >> - skipping various enforcements of non-SME or
> >> SWIOTLB in the guest;
> > 
> > Is this based on some concept of private vs shared mode devices?
> > 
> >> No mixed share+private DMA supported within the
> >> same IOMMU.
> > 
> > What does this mean? A device may not have mixed mappings (makes sense),
> 
> Currently devices do not have an idea about private host memory (but it 
> is being worked on afaik).

Worked on where? You mean the PCI core indicating that a device is
private or not? Is that not indicated by guest-side TSM connection
state?

> > or an IOMMU can not host devices that do not all agree on whether DMA is
> > private or shared?
> 
> The hardware allows that via hardware-assisted vIOMMU and I/O page 
> tables in the guest with C-bit takes into accound by the IOMMU but the 
> software support is missing right now. So for this initial drop, vTOM is 
> used for DMA - this thing says "everything below <addr> is private, 
> above <addr> - shared" so nothing needs to bother with the C-bit, and in 
> my exercise I set the <addr> to the allowed maximum.
> 
> So each IOMMUFD instance in the VM is either "all private mappings" or 
> "all shared". Could be half/half by moving that <addr> :)

I thought existing use cases assume that the CC-VM can trigger page
conversions at will without regard to a vTOM concept? It would be nice
to have that address-map separation arrangement, has not that ship
already sailed?

[..]
> > Would the device not just launch in "shared" mode until it is later
> > converted to private? I am missing the detail of why passing the device
> > on the command line requires that private memory be mapped early.
> 
> A sequencing problem.
> 
> QEMU "realizes" a VFIO device, it creates an iommufd instance which 
> creates a domain and writes to a DTE (a IOMMU descriptor for PCI BDFn). 
> And DTE is not updated after than. For secure stuff, DTE needs to be 
> slightly different. So right then I tell IOMMUFD that it will handle 
> private memory.
> 
> Then, the same VFIO "realize" handler maps the guest memory in iommufd. 
> I use the same flag (well, pointer to kvm) in the iommufd pinning code, 
> private memory is pinned and mapped (and related page state change 
> happens as the guest memory is made guest-owned in RMP).
> 
> QEMU goes to machine_reset() and calls "SNP LAUNCH UPDATE" (the actual 
> place changed recenly, huh) and the latter will measure the guest and 
> try making all guest memory private but it already happened => error.
> 
> I think I have to decouple the pinning and the IOMMU/DTE setting.
> 
> > That said, the implication that private device assignment requires
> > hotplug events is a useful property. This matches nicely with initial
> > thoughts that device conversion events are violent and might as well be
> > unplug/replug events to match all the assumptions around what needs to
> > be updated.
> 
> For the initial drop, I tell QEMU via "-device vfio-pci,x-tio=true" that 
> it is going to be private so there should be no massive conversion.

That's a SEV-TIO RFC-specific hack, or a proposal?

An approach that aligns more closely with the VFIO operational model,
where it maps and waits for guest faults / usages, is that QEMU would be
told that the device is "bind capable", because the host is not in a
position to assume how the guest will use the device. A "bind capable"
device operates in shared mode unless and until the guest triggers
private conversion.

> >> This requires the BME hack as MMIO and
> > 
> > Not sure what the "BME hack" is, I guess this is foreshadowing for later
> > in this story.
>  >
> >> BusMaster enable bits cannot be 0 after MMIO
> >> validation is done
> > 
> > It would be useful to call out what is a TDISP requirement, vs
> > device-specific DSM vs host-specific TSM requirement. In this case I
> > assume you are referring to PCI 6.2 11.2.6 where it notes that TDIs must
> 
> Oh there is 6.2 already.
> 
> > enter the TDISP ERROR state if BME is cleared after the device is
> > locked?
> > 
> > ...but this begs the question of whether it needs to be avoided outright
> 
> Well, besides a couple of avoidable places (like testing INTx support 
> which we know is not going to work on VFs anyway), a standard driver 
> enables MSE first (and the value for the command register does not have 
> 1 for BME) and only then BME. TBH I do not think writing BME=0 when 
> BME=0 already is "clearing" but my test device disagrees.

...but we should not be creating kernel policy around test devices. What
matters is real devices. Now, if it is likely that real / production
devices will go into the TDISP ERROR state by not coalescing MSE + BME
updates then we need a solution.

Given it is unlikely that TDISP support will be widespread any time soon
it is likely tenable to assume TDISP compatible drivers call a new:

   pci_enable(pdev, PCI_ENABLE_TARGET | PCI_ENABLE_INITIATOR);

...or something like that to coalesce command register writes.

Otherwise if that retrofit ends up being too much work or confusion then
the ROI of teaching the PCI core to recover this scenario needs to be
evaluated.

> > or handled as an error recovery case dependending on policy.
> 
> Avoding seems more straight forward unless we actually want enlightened 
> device drivers which want to examine the interface report before 
> enabling the device. Not sure.

If TDISP capable devices trends towards a handful of devices in the near
term then some driver fixups seems reasonable. Otherwise if every PCI
device driver Linux has ever seens needs to be ready for that device to
have a TDISP capable flavor then mitigating this in the PCI core makes
more sense than playing driver whack-a-mole.

> >> the guest OS booting process when this
> >> appens.
> >>
> >> SVSM could help addressing these (not
> >> implemented at the moment).
> > 
> > At first though avoiding SVSM entanglements where the kernel can be
> > enlightened shoud be the policy. I would only expect SVSM hacks to cover
> > for legacy OSes that will never be TDISP enlightened, but in that case
> > we are likely talking about fully unaware L2. Lets assume fully
> > enlightened L1 for now.
> 
> Well, I could also tweak OVMF to make necessary calls to the PSP and 
> hack QEMU to postpone the command register updates to get this going, 
> just a matter of ugliness.

Per above, the tradeoff should be in ROI, not ugliness. I don't see how
OVMF helps when devices might be being virtually hotplugged or reset.

