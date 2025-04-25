Return-Path: <kvm+bounces-44282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D7EFA9C368
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 11:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2FE318944A8
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCE423BCF2;
	Fri, 25 Apr 2025 09:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c6GMBVjh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD388237170;
	Fri, 25 Apr 2025 09:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745573211; cv=fail; b=VLUClPrxxcSXoUXQGCB8APyIi4S8Whiy1oxThnC/tfUi0uZqwLR/MmiQD5ps3gJJCKP+BGgJEubn5XG9w+VeCi8JXCDIzb2zuQlyNvgalOU1V1RK+uwY9Y++822ukZdNjPeVWtq8jznODCeA9MgQaubpSQf8D42OBtiwKapDCQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745573211; c=relaxed/simple;
	bh=ilGSZztxLFLyO5e+EOUKjHTEBw7VdQfZsYKLpVTG2D4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Qnc+lS9Gb87o+KCp1WY+w9+gzh2SjfJ/WN4PMMiRfOkJAWvV5Bv6bct5TliD+ucpt49v19eNFrqxZO1sV0DVW/8BJ382QE6jcAJODzkQg5zBO5nII4I2IsjGMH/ZXGZE3NG/yzGkVIKQxH5/bJFk/Xi75WMakQBdGhXcloTrtdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c6GMBVjh; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745573209; x=1777109209;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ilGSZztxLFLyO5e+EOUKjHTEBw7VdQfZsYKLpVTG2D4=;
  b=c6GMBVjhCEoc1cQInXCF6roa3n7jlBNYuVy6CfEHT06nqf5IwEiF2bxD
   lXtd2WFnNxanruYfE7YN8Y3nUqotbSnzknu6LGQRwzOWwVLE++KnJp58B
   IHDBmbyjfsASaPwTCpMFyN0VE8KZ4PaXjmSRETw0giR55VB0r8XcKx3nn
   Z9lmBfDdkMtNzIRZIKC0lJrq9wts0V9ldRG52Lf3mQrOuEVlKB9vtJW/u
   JjhsbmjGpOX2PrrphJQiYvjNxQP5sGuyg4b6Z7WWWpfaPJernyc+RkGH3
   kO8fqaXje1P4xY84QkTAp4WBC+syl7yNLClbv1uLuEFwO7rhQ14rGEctc
   Q==;
X-CSE-ConnectionGUID: EhW/poA9R2+5frPxe82mtA==
X-CSE-MsgGUID: jLQUcdjeSOGXX1E0ZjEGlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="46349992"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="46349992"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 02:26:49 -0700
X-CSE-ConnectionGUID: Uu8hcYhyTseXjin71orVlg==
X-CSE-MsgGUID: 2GmTU3scSfiS2LhsOqxAOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="170076065"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 02:26:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 25 Apr 2025 02:26:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 25 Apr 2025 02:26:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 25 Apr 2025 02:26:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PPHgUyYJuHvIKgN1WXddo+tJpiVJiQlyPAF+90u8OyLbcwGTezIV3RUJzZ2jLgsUbD/za61AKDMv3LtroEXEp3W71ShPfEZqA/dquh5tJfT5mFRM07cZAzLTTD4tpu6XAcl7XEVxG2qwzplaBgd/0J3Bo9SwcZ5Yzw5lgK8NGUd5HYEZoSUsZtaFZlR49oxroHq5bmTPpZBbkAjkDWRjDzuoChQ2x69iMUpg72uEgcPnwtx3o4qOGI6GDvmnDrB9oS13tM/ILMbG7n5W4tnRKh/gwVKNjsB4rZzdfA4jDfcmopJvVtXG5h7zAxhf6vdn16OFS7sN6G0mT/ESVT3DcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RmDt+dGzv91r+/eGNPXuixiHPGNzG11ech/iit+kE4k=;
 b=LxliYxo8GJVS9zqfqeuDRF/qpD5NFpJyb1uOR0NhrLkONd0DU3A4hrtpr5thMVkcsVlmlNxgto0QcvbupHcbhhVjbreppVKkrVMbZCLdyfKAC7OE51mudZ88WhLZJ6+6Cq1Q2ClydDEej69o1f/BhEzJ8ntUHpvbysOJJb4vBGpTmgZOB3036PM8SI75FRkh+MjVkKcRKBV0vpZtlIaNk9Rc7KEc/eu3kVRDOqvWb+h7joz73B9KdU2k8ZD7PW/RNYbKgFoyCEei3+Eple8oBChphvvSgAMNdHwlPlD6EU3TP1ydrwAHzAsfXo3S20viiotBcsZGM3gBM2s/QAFFYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB8260.namprd11.prod.outlook.com (2603:10b6:510:1c3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 09:26:14 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 09:26:14 +0000
Date: Fri, 25 Apr 2025 17:24:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aAtUwfH30tqx92J6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030445.32704-1-yan.y.zhao@intel.com>
 <8e15c41e-730f-493e-9628-99046af50c1e@linux.intel.com>
 <aAs3I2GW8hBR0G5N@yzhao56-desk.sh.intel.com>
 <55990bb0-9fbe-4b38-95db-bd257914b157@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <55990bb0-9fbe-4b38-95db-bd257914b157@linux.intel.com>
X-ClientProxiedBy: KU0P306CA0067.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:23::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB8260:EE_
X-MS-Office365-Filtering-Correlation-Id: a63990dd-a288-45c1-f9a5-08dd83db3945
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mAIOGGnX0hxR+ySI/PAiShGeX5j8qysnYm0PRWFTl7uGNjzsAnmX3ThVVzab?=
 =?us-ascii?Q?tDzoyg6Pa4uSYcJX05em9HYZV1VElwIKcczcwErMLI3GTaYXrzcThyitMop2?=
 =?us-ascii?Q?G5bjpWr+BwQtYWRMjCf2uPZ0U7+pdHJI0lta4Qqfa1fm3bq6OnEtKtmq7NgD?=
 =?us-ascii?Q?/nvnBiZnG8zNiaKGL2Ax2Krp4jhi9SVTf7DauK582T6VCMcJmuokAb91pnOC?=
 =?us-ascii?Q?+u2emhc2pcX8cy3KYkQ9rUnwArX6FHhOPqoU1IjJITq7RjC6eb4GZffpA6RC?=
 =?us-ascii?Q?Je056w2HCCqGfjDHAHyKBFAhKvJAzW2cbPRp2TMOMyerq+U4MCO6FG8agZGe?=
 =?us-ascii?Q?z4utJ6LgXzPJUZdYogK9k8SXVE7EP/TEI86UpDpFUZbbkeev7gb4njCqWD5M?=
 =?us-ascii?Q?2BdFzQVWqF4jLO0XEp86cNRC+9dXZN7iHgZ6nhIBLDKy9s4l589jAd74NK0L?=
 =?us-ascii?Q?9mOv2A5bvenH0rPiqT2F+ri7nx4u9iW/Wm+BUzR3EqK/2OmXJs3UrOGRMj+f?=
 =?us-ascii?Q?YlYKs0BuRUJe0aWAPWFUxR8t6W3z1UYUMD14EeJEJ6I8azj2wC7Ob+NLhizM?=
 =?us-ascii?Q?7H0uulE6+pj/v94jH1IVJI7pGvuqdztzWcXPoVnmqtT6yK4EzSmsbZBmgj7B?=
 =?us-ascii?Q?BcDBQGH18D4HRnxX6gi7SHB5aOGDlngjQk+G6QIwqEn+3H4HxKTV2Jct6VQV?=
 =?us-ascii?Q?gsWdSKz4QuFuoFm4d1pQluJJO/x0Cld6Ru+vn2yAZQhIqMjvKR/IXyki5EPy?=
 =?us-ascii?Q?HnZ0BXPnHO1DAYMvdF7nb9D2qclPINblRa3f/Z13krk78V27NsOVgvWwFx7n?=
 =?us-ascii?Q?uv/VnQwEpL/rXUcTw8OMt5pz02biPkl01DtADfjMlxsto2grxVJwBihnkS+M?=
 =?us-ascii?Q?L9acHO1+JOwQvNnY5KIJjJpheFgvHtfx3mIUpZDw978ZqB1j9TNkQiZXcLkJ?=
 =?us-ascii?Q?g6s9HuldCH262CPj3sa9WSFN6AOBq079KrfuBY0XNBVyJElmKNxgExCX6Map?=
 =?us-ascii?Q?BWVfCR+Fy2GBTNIzmY1LO99lleQMS9Ye3aYbtu2kt6kTiAg9Q4tMVvw0FlQ+?=
 =?us-ascii?Q?5ED1qZ5pR3SqQvV4UwFMZiIhtZrRu02/jWD91gSs3wMR1gMc+wyWCYzRhtli?=
 =?us-ascii?Q?O90DCcFmlbDojyzicU2ETc1yNoK+bEdnD6x9nDXfmPebLioJse+EvAQ5GSje?=
 =?us-ascii?Q?8bUrVnUL4JDut1l6pO5i3b/+y4UhPF8VRHkSoHZLsAXGBAYQY9pgOIdkURsz?=
 =?us-ascii?Q?gxndpe0O/5Pu4r0tHUeckqa4OH03saB0Qj593lZ4th1TRvXn2FZO7tHK8nG/?=
 =?us-ascii?Q?o8Pq2OPlbjRgeEiId5YfUD3T5RWld3FqM3cranl8YCTKNRNahg6tOJM7zAKD?=
 =?us-ascii?Q?Vy5Si6YXA5qIFsmaGEfeT94CIf6LaCOlUAkEf/gtoLkfhy3SjI3Q0rr0Sfzl?=
 =?us-ascii?Q?XUr6tc8nVfQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JsqzTDjO5QT9DObjgQPaedKry5mBJQ0rA6nP5OgxWkUjFlscu61sePaR64Ii?=
 =?us-ascii?Q?PLc3QA9tGXJM/K2cFtYRutS9VvRGLHNq56NjPqMSHMkYacmrMFkhw4O+uk0T?=
 =?us-ascii?Q?BWxsn0oNee8ojVWrcebZIwL9o5kHDdIxmQPlEcRJDP5iY3EsFQ5fs29aGMnK?=
 =?us-ascii?Q?DSd5l5u50c6aANkG6FxsJRdxI+jHUttf9rd63ndlMjA0l+bJHJiCA5iUIC3c?=
 =?us-ascii?Q?GKMLi3jlDNIygngAzo7SQezPGpHYXd9XM1yGBbTuphgJj5g1xknr++BRdKRT?=
 =?us-ascii?Q?432pxIhtf8YlOq7i0i/RrT1+GF2XLSxhoi0vFsqaCIJTCdUq3KoFEJa/LBDs?=
 =?us-ascii?Q?J4V0PaKPtZ8TJixNXsU6ev1d3/z2l84Rky2acLwyVvvPT1dyL2gj+nfTX/3C?=
 =?us-ascii?Q?o+yB+1ktOtWBnyXYSFcgVLXqc3WsqktYLf4cnK7ZswmdMVaDbdeRB9uLgs7R?=
 =?us-ascii?Q?NhqQECmoeHVkbO3WARoPbMMkVe7/UOJeq46ppYB9aBlAttNc1x5oA6LyzMsU?=
 =?us-ascii?Q?qqAZfklYKm1PoCQodgkScuR2d2jCkKjzZaWi8NbJFMNDy0yjZ84/YHThyuP7?=
 =?us-ascii?Q?q//8m3nfAoTULkOjYNbAGiu110smhKwsNnxNxZ9w3Ws2g3e6SZSl9sqQ76fM?=
 =?us-ascii?Q?TBFXds/XDIyLCKpaJRNL9p52a8iMWFm7YNknLQ/hri9+gU4G4ZhJ4n0Pma1b?=
 =?us-ascii?Q?lM4FF+3yKijMYU9wuUUHa0ilFIgA40K/L6Zmoyp5gjFoENqdqvKj80VeaykE?=
 =?us-ascii?Q?++BGen4Il7Gyx8lK2bvxKKot0TXWDcSUWqiqisSHpJURrb6wOl8NPvkXhAuo?=
 =?us-ascii?Q?4yDulWr+8l7EUGJqUBgvcSTLik2/oyKlPN1NEyoHtdv0CeP7I3Sdhoy7RqF3?=
 =?us-ascii?Q?cuaxxbdg0dhv9Hs81MoEWPufYthGQLRimyX/p3CxHc82WdarQaYmCkve4OYG?=
 =?us-ascii?Q?KWstjms8fENwa/akekMSJU0rKyyxIxuUZkMK+hRq19oO4IPxNHsjqvLeRExp?=
 =?us-ascii?Q?/QzZ+4CMNee16o/27kSleoRcQVa8m+tmhsxO8S68prTKIKTh6bvNIEotqKOb?=
 =?us-ascii?Q?jbTdzs1APDJrF3NgOsYlIFjTXh8YDRd8bdCM2rhQJViO4gblGvVm1JiO4v75?=
 =?us-ascii?Q?HtjBbK3XW8sYBYyRb2Id7jFHhj+1kmpTjEPGW6gTEUFnewvLy347uR4QSTXt?=
 =?us-ascii?Q?7etwCXxwI9BZMirRj4YV2o/8QWByQWPJzYlIaYikFB9ghV9bMrzxpjMVkgPP?=
 =?us-ascii?Q?w74yGIR6FIwIf7Vqn63a9tjaZGO89gGRSbQLx/U1dC1k3+zVB0kxqxjMdXwj?=
 =?us-ascii?Q?pZPcmu5X0iQWtELtTHX5QVnQ5XhrqLqCje+MbUPajRR4UsaXtwA9Ja1Ju3Mc?=
 =?us-ascii?Q?hVvQxgBaPSxJstJZ+MN38dyinMrkNWvqvelgMK6kteY38gAiDKXC9SSAgRr/?=
 =?us-ascii?Q?vHCOCHoWVeqQBGrJImC9Zkr485REAtYC81dI0Px56gQYPO0yzPq1y9b37OMX?=
 =?us-ascii?Q?2e00K1wIMZqHTCOpYjHue8AsBjbLQzF5tk5RduC6SXeEq2T/SF3FvJcA1vlw?=
 =?us-ascii?Q?M8YBXhXx2I+O5Gr0nv4fki7/Rs5VKIVV7tEtBbAZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a63990dd-a288-45c1-f9a5-08dd83db3945
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 09:26:14.0615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 34aE0IakRKzf39cVdijtMl2CGb9+Lz8GxWDxnD2crYOCTyPPMRnnPuwl+EQoB3KlcZod4JZIWj/k+Sr1aLiuBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8260
X-OriginatorOrg: intel.com

On Fri, Apr 25, 2025 at 03:25:12PM +0800, Binbin Wu wrote:
> 
> 
> On 4/25/2025 3:17 PM, Yan Zhao wrote:
> > On Fri, Apr 25, 2025 at 03:12:32PM +0800, Binbin Wu wrote:
> > > 
> > > On 4/24/2025 11:04 AM, Yan Zhao wrote:
> > > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > > 
> > > > Add a wrapper tdh_mem_page_demote() to invoke SEAMCALL TDH_MEM_PAGE_DEMOTE
> > > > to demote a huge leaf entry to a non-leaf entry in S-EPT. Currently, the
> > > > TDX module only supports demotion of a 2M huge leaf entry. After a
> > > > successful demotion, the old 2M huge leaf entry in S-EPT is replaced with a
> > > > non-leaf entry, linking to the newly-added page table page. The newly
> > > > linked page table page then contains 512 leaf entries, pointing to the 2M
> > > 2M or 4K?
> > The 512 leaf entries point to 2M guest private pages together,
> If this, it should be 2M range, since it's not a huge page after demotion.
> Also, the plural "pages" is confusing.
Ah, indeed, plural "pages" is confiusing :)
Maybe below is better:

The newly linked page table now contains 512 leaf entries, each pointing to a 4K
guest private page within the 2M range.


> >   each pointing to
> > 4K.
> > 
> > > > guest private pages.
> 

