Return-Path: <kvm+bounces-19429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A224B90502A
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:11:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52A3F2822EF
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 10:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD7A16EBF5;
	Wed, 12 Jun 2024 10:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gbIW9mn+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2554916EBEC
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 10:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718186959; cv=fail; b=dtxx6Su/eVi3OIfOoq9cIBkvYQpgJdkhKj7NhXMQtEErrir5YrDLpVOwVsrcmcgvofKmxw8g67/Jx0DT/hk/HJ88SneD/LSHdQAvgsjGDE77U4/6Vl2tWpdsCQbCM3VJOuBx0RpX5cgcNLHq0ySEcdbY63MioZ+Khyogz9No6c4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718186959; c=relaxed/simple;
	bh=04lqFWEG/CwFknXOQmuWOkf2m/I2b2wHtCJWrLj3jPc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f9xIJM3W58NegllVnLNSGeFtOOcVDWuVt6ca3Z6WOf8TMBUNosxli+ROnTJ1GrxbUE/JE4zhadgJLKUan5oCFnhhDthNLMnlEQs3FUFrC43/iuSRXSb/KwZe+dLEWi0rkARUbESDDmn3P5cIjEwGsRrkuHwq+9q1d5vbQHP0Hbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gbIW9mn+; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718186958; x=1749722958;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=04lqFWEG/CwFknXOQmuWOkf2m/I2b2wHtCJWrLj3jPc=;
  b=gbIW9mn+Cmj/iLi9GYpo+GsPdf/x8NR5lUCTvdBaxe+PMT8ZaIB7R9eP
   QmF81QiQC7rDgspIMFlExxupdlGslUbpHQZQ/Ylr+GRtUM3kbnYmLR36N
   tg+z8gCKF9QuZbCN072JdzWGp/tQLqxtDzcm7WntGk9cb6SyjnZwFjkuH
   XxHIYNtudfEsvxs3K98Pivuej//kzKFmSVuRTdFpuxuS9AZ9vtmubLXbD
   ZnP9WWXyh73FqaI3vKcFW+o678MOQv8BFErFDL7wavWbxsG4kIdH3gBRS
   iWjhOIr2eLTLu62TmzKxV0F9HDXQSyMvCAXJ5r6pK6PzJz/AJ8p24jjC5
   w==;
X-CSE-ConnectionGUID: 81U/br8gRvKIiZ0ipbm/Zw==
X-CSE-MsgGUID: 1hAuE1c+TP6izjBnRudB9Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="25518312"
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="25518312"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 03:09:18 -0700
X-CSE-ConnectionGUID: EdDgOlGfTDy7yEwtHXll7Q==
X-CSE-MsgGUID: 0HGnzFNqQGyqXJqoIOfccw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="44649004"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jun 2024 03:09:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 12 Jun 2024 03:09:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 12 Jun 2024 03:09:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 12 Jun 2024 03:09:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X250cNROIYbYUyQ4DmbxUbNq7ZI8kRHWMLpHD8wYQQ4uUuOqkLVWfCZYEWwbkTMCqxKxtkt6l1Y4u0hiFWiTeGCEuLuv+9NNFHUhoiEGXLqfFvhHmeK5oy23o1pVBIZ0vZWKbuL+iLJJff21GauszHXHdoncLeg7bwOPyXEQTMct+BOPgrkvxlH2hVfdZY3ocaisbMmtTIOEQjnaF32SPTJZcDDsJPnUqMCYSHn75yG2I7neo6GYnlNn1P+4YDhp/XUX8KthV3LxtuljYcEQ5qoPPvrNpzCdYCVHq9xrExL0h1QrQdmv0hFNcSFmtth0Rxrt/qyNcEnIaxCPeMDrwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WO2tiqSmpxun/kWtN0hVJw12Elp6g3/1Y5S+5kT1Go0=;
 b=md4JFlti3C5Ih/q8iTk9YTKcZHjmty5KCeEZpL2Vu8ZUWRP2t+dTVoUxhEpWaD6JpavFCsPp8ZznAmivEue92AlPB9A/ZteHFrzfU5eXbN9OZnLchNRUnYMbARdR26F18cu3aOizGm/QFvT4FsoDI/1hlapa4yEBdml/2WXLx6o6kDV7fdc7PNYavyuVdiQf1ht9jV4MGN0VGFQJvBMIB7/fMiX0+Rb+dYwWSZd+hJd4vyzC2xBXeAxWiluB0D1PCbJB6Pvh3GtIcF+Ffh3Th8hGHhGPaBkuRoHpGFsWuzkns86QIdn4PkygNIkRDXUQTgI6rBuGrvk5GfMaAXfk0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB6985.namprd11.prod.outlook.com (2603:10b6:930:57::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.36; Wed, 12 Jun 2024 10:09:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7633.021; Wed, 12 Jun 2024
 10:09:15 +0000
Date: Wed, 12 Jun 2024 18:08:15 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <ajones@ventanamicro.com>, <kevin.tian@intel.com>,
	<jgg@nvidia.com>, <peterx@redhat.com>
Subject: Re: [PATCH] vfio/pci: Insert full vma on mmap'd MMIO fault
Message-ID: <Zmlzj7XH9xIHimOE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240607035213.2054226-1-alex.williamson@redhat.com>
 <20240611092333.6bb17d60.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240611092333.6bb17d60.alex.williamson@redhat.com>
X-ClientProxiedBy: TYCP286CA0362.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:79::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB6985:EE_
X-MS-Office365-Filtering-Correlation-Id: f5d48dfa-1475-4294-c6f7-08dc8ac7b700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|1800799016|366008|376006;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mVK0Vuz4LQAwTJHoVZzJ6oCwIXwMzUeA6hrZ5MxOCdBByazB0buPamAoTsiT?=
 =?us-ascii?Q?38S/9vAvR0hSSiElKlEaRViWXfYG8uCP4fPss3HTD7K/6QqQp9emVmZIZVfY?=
 =?us-ascii?Q?oRqzygZxRWuKxgrQcMc7g85nk8eYo1lQRJFP4CT7GHUxTbnr2Ym8iDC+B912?=
 =?us-ascii?Q?hxZGaO0+HGdAcK9GQD8ZWK81U6ql8/Cnhfl+ma+dyMGna4NhnnN6uVQM090s?=
 =?us-ascii?Q?degxCT+6zLwIOuGOVvfOKWY0qedh8j7J20T5jgRB2xPbF257hRY5VtMz1zmE?=
 =?us-ascii?Q?8gJX9kJXr5lys+acYddq3ynm0bFn1GNSNtIhe/zzNzXa6+XdLjWmFyC+2T+r?=
 =?us-ascii?Q?kuh524keaiqX7H7Th/fEe7Qo4xhGu6SVTP0mjRY2AN1z4RKDNA0zCe+brzre?=
 =?us-ascii?Q?OjK6lcuCz20C+ENzguMS3+M1EV8q+0hDd1jYRqqm4YkwPvsd64gBYHeXCjes?=
 =?us-ascii?Q?Z/INNS4Wja2hueSxCQ8RJ+MGPUefb2neAxvVHj9sz1OG4IVz56EqUBoXLdXr?=
 =?us-ascii?Q?PoqQirvp1NNhFIwgrTu7z1YwGNv0eq5i7yKqC9c1ZjxeWLecOv5jza2tyOxY?=
 =?us-ascii?Q?noT5mzZEt93ZDT2ehYlcIS78WxpVpdbxY4CLmSAy8FPknmL2haOK2ex/6bQk?=
 =?us-ascii?Q?y4giP4I/i4IIwzI8e0bw9oDiUWzXYzp3kAX/nRf7VGkC3cSdm1YiQxi7vMSz?=
 =?us-ascii?Q?lwjIaLxFOY2AJuaz6XISwKjtNqD59O/+jquC1IlojWRKScyPtPnQnmbc3dCi?=
 =?us-ascii?Q?j58BHBsXVMBmfA1hmYdEMHrCoYYS4HQhKKJxvauPcsz98yaVDpVrP6PijGHi?=
 =?us-ascii?Q?Ecp+wWvHH+kjR/uLYvx0m2fIb5dz+xSgTSBNrz8pZ6QAmOP0u/uQun2B2rRY?=
 =?us-ascii?Q?qiAjg6mx3WnLU5zjqfwNhXGj40w3Qykrm0y6KcP8WFkjM7vIQ3YkHYRnlOwK?=
 =?us-ascii?Q?3ObimDi/XDDOuH8ro3D2Zs3n7tJ4UnY+kk5ORWXDOji09EmHPPQndlhFWj1Y?=
 =?us-ascii?Q?ts/KDNTGxF1JXsFULNNxe3yC/bAd89maq5DBFqOAkRlOhX1jwYd2mXYDywCp?=
 =?us-ascii?Q?UMZ8GkFGNPZiZRNukQqdLo0Ijha02ARRRk91qRDo6V7lcq6zURBSXfonNmza?=
 =?us-ascii?Q?8/yqqQOTWV7Pl2idFFuc/Oz7ekrvSxgqsaZvagdYl3OK61AAP9K0FFuxNf95?=
 =?us-ascii?Q?GAHRx7ohlBNsy3rr57oKwJJrHNcd2vnDPj9LEaHVvk1F9IkJxukfmmw5Jh8B?=
 =?us-ascii?Q?QmrkzbjZJGoHURlTQAo+xus72EDwvd7ATusHuQAumX9cA8skAtM6u9M0nHyW?=
 =?us-ascii?Q?/Nq3ABLsgyNQeRHpSWGmDumv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(1800799016)(366008)(376006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XXDhRLmkoiyWrPMOz6eS6VZH78+39hDk1lgOPfaCcEvViDOBUL0SAGvSeRD6?=
 =?us-ascii?Q?0JEL7CKNfB4ELgNHdqbTAI7/VQVTo8YD+k0AwDBUL8+KGnG1QtP3l9XbGMPA?=
 =?us-ascii?Q?eRpqZpWiooF7n0WRVEjh5srX9mFb9aB3DtB1qymo1QtpvMCTZdy7WFyfC7s7?=
 =?us-ascii?Q?tCbedNJa+6IOWdBdZ/JJnk99BmLCMxgKUFilnRXcQdGkeP6j6mWJY3F8DslO?=
 =?us-ascii?Q?LX6gBL0VjMSktdlViqGL/+UN4jURwie1kFwLwplh2bGO4FTP0lZkIbschBc/?=
 =?us-ascii?Q?guq9aStjUIFRokTWrBf64JzcS7/K0vI4kXty+BZMF2t9IDGXULs5hntiQN1u?=
 =?us-ascii?Q?WwfLVyznGa//U60YKVVBrLPHI68NEEUBeOaWA6orzICOgWx3D98f9RIeRdiO?=
 =?us-ascii?Q?8Tvx2S4MdYCCpDK7/jtXqcJaLk/w0H4brRoxa9j9LI+vypuLwCD8k0xlGkp/?=
 =?us-ascii?Q?bpEAIYHu1eTEdCIm/LLETHqc1exvjoI6acM8HKEqMdm8d2H+524/3aNGAS5g?=
 =?us-ascii?Q?Cw7PYu1nRH5kO22tXK5QbxMxwn8h2wub1AG7qmW/ushA6MLZuNGevV4w5oQz?=
 =?us-ascii?Q?fLGlclc0qhqMxmLG749J9tDcm2NwWjzLYG1dMuATEJMYeYUmgXdaGPaWG8sm?=
 =?us-ascii?Q?sYmReTGAmWzihlruNeAY097Pbv1r/yFQYYqdMrZ6qfVxrmmQNEvp/KenGgmq?=
 =?us-ascii?Q?7cM/9yarLfxLB1BRaxyl7mjL2WXKr58k9tqkl/nS6u9ymhi74tpD+v8f//W3?=
 =?us-ascii?Q?/CfoCyqRZ9dMKgJNXEEN0atdukv7IdZ3TaejqjHiy1sdZVKvzg/E7MaRFkil?=
 =?us-ascii?Q?53fIbQ56FN4kpmSPFnsVe9VrINO6LY1Sb4XFiw7RKkD+eASU2kRkwCvsTCwj?=
 =?us-ascii?Q?RvhIpgOE5vKkBoVN5nd2wc/elKjUuRbPx09RUDzLas3BJEAULF9hph1debBz?=
 =?us-ascii?Q?6haCXN0whRGtUomc09/yGnRyQV3jqgSmsmgUsARmSJq3geRLo/cwoiv5lX0o?=
 =?us-ascii?Q?bBCZJ/YlhkaP3BS/3su6Vt6gMgDT5Gqj8TuiHacA7si2UziSQB0Qr9o+wyCG?=
 =?us-ascii?Q?HA7sKIaRkVmSRqP3y1rSTcfW7B0Kv9rCPOR+ZNl/3Ik439i+b/YaXOWKlIMX?=
 =?us-ascii?Q?v6Mu4RUluP0ptqTJbxLS2q9FangTvVrMqxcHQleQOxtnqVEAOF7+GeNbHDyW?=
 =?us-ascii?Q?joMG7nJ7+u53747L1sHzYuR9pJQ7ZofmEKFbPaEwDUM4IPw2cf/leHmKdmcA?=
 =?us-ascii?Q?hCC+fuilDx1s4thqhO+/Je5MWjUz2f7suAPSvqOajJ4RQB00VR4wnvLP8Rrd?=
 =?us-ascii?Q?7A/zFdiM7/1AiPHoENAfGolw4A++MXDr+3pzcjWv7cLvg9YMhK1mWJhhlQpU?=
 =?us-ascii?Q?5RIYUTMtZKbMiJ6Axu+53/+N+hm14xLSWy7QUbfNhG6rsu1tPZwfIQBV32k2?=
 =?us-ascii?Q?q9lJR+gcI30wFO5GR89Gokdc1Qz41kAzyizCxOzoI+57yH3VR5JdnH5pGjSh?=
 =?us-ascii?Q?+Xk1ZKQ4A+1dwz/dXT7wg/Fweu2aevIKwrMbkI325sQ3horgjrkASpYpKSTQ?=
 =?us-ascii?Q?h6ETOqQ+BXaXxx3xOUGZnw3q3BPXS/FyulM3YoyH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d48dfa-1475-4294-c6f7-08dc8ac7b700
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 10:09:15.3961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfFfm+rOezCgmU7pQw7gn9BPJsXe5Uh2S1TZ1bp42tUBXFxBfHrjvaDlO29pGeCqvQgDbahtczOTSIi8tnClxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6985
X-OriginatorOrg: intel.com

On Tue, Jun 11, 2024 at 09:23:33AM -0600, Alex Williamson wrote:
> 
> Any support for this or should we just go with the v2 series[1] by
> itself for v6.10?  Thanks,
Tested on GPU passthrough with 1G MMIO bar.

Cnt of vfio_pci_mmap_fault() is reduced from 2M to 18,
Cycles of vfio_pci_mmap_fault is reduced rom 3400M to 2700M.

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> 
> [1]https://lore.kernel.org/all/20240530045236.1005864-1-alex.williamson@redhat.com/
> 
 

