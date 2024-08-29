Return-Path: <kvm+bounces-25312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C699636C9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 02:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2DA41C2185D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 00:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E12C125;
	Thu, 29 Aug 2024 00:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ndp9CV4b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9352F5B;
	Thu, 29 Aug 2024 00:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724890826; cv=fail; b=NS9YlGX/6DgoxwAvaVcSFQ3+U8I2JKXTOjzME1FeXDQQcB4sB57BpvkMS51Bgvp+Q67+ZjH3zXgvc1YEN77zwD1qgVq4aWVL26Pf4ihQsboRtMu3N5Nf6htC2whM9n7LnCB1fM8CHPXUX4ATqQzmL39T13EYK4BeG/1ADsUxVyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724890826; c=relaxed/simple;
	bh=5wbr/xR60UdE8tkCs6fNjJUAOTstFTvhkP+zYUK+H5s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rPVzMTowzuAZ3N8sUfAc+ipOgwndPesHwboFo6d3bOCj/SA9D4Ir+j3pvKQpQLYagdPlr9SeKzFB1rOUIn1nGEYLTjvY+dwKz6lrUuZe4z/eE2nWKpGAhD/f0NBNLrvcrrJSnNxicDSFa5mYviNPRijRX/MNnsdAcfdycKsbuzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ndp9CV4b; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724890825; x=1756426825;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5wbr/xR60UdE8tkCs6fNjJUAOTstFTvhkP+zYUK+H5s=;
  b=ndp9CV4bMT4R9Tz+QvxFVVRwvlJIvSKqk5iRB40LNqKpYg0vDP6h+JUM
   IAoURbKd8y2ZlV+pIKx37Ctp9rM1P2Hqrl7gbPrE925drdfgfmNdOSXq1
   uK4GO+96UjBBREeWCCtKQs734d/9BR66oAwhgF152gmJzEhw2dckZbHMT
   l0d6DfGJL35t/qPDRH6y4HdrPUGH61obI0O+05c4AUFE8iSW81FQwRxD4
   XnGlfT+a5XVy5uQHWPopSSPoJ5gy89TaC2G4322rI4TcSVGb9VnDmzPDT
   gOhcR/YzWFX8aI02sqv0EW54K01emQ6cFH1gbMl6q8njCXsTsq4pCTFKb
   g==;
X-CSE-ConnectionGUID: AxS3iyU5SDGFiZb+LaLHpw==
X-CSE-MsgGUID: S+YVZt5CRJ2/fPGo4Hr1IQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="22973616"
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="22973616"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 17:20:24 -0700
X-CSE-ConnectionGUID: xL+1XGoMT1evO1X6ftY6hg==
X-CSE-MsgGUID: wOkZL/2cR+ifuY5njCjaUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="68227954"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Aug 2024 17:20:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 17:20:23 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 17:20:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 28 Aug 2024 17:20:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 28 Aug 2024 17:20:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iSovogr7hW85UJ72B0asX2mwgx54aB00bKTBWymqwfkOdBAKG61Zk7YFly+6JC9gihQclhpX/L4f4VCwrzNxOvhQI5Ia/G0QTS9lFGTUtFa04IqWosKcir6eztIj1Bzv9ffzhslz1ynAbHcYzApQ6oYx9dct/B3XjaO+DiFhxM1X2kySQl+voUH7M8h6c5omSPG/dhfQ9gu74YaOuq2t6OyD1+sxoCHKvnrlGup0SP5bn+6eyhFrIhMxsB1vZPoVDiiqgETrR0wxChB9gncunWycI5WXGXelnPJUCkhYWuw6FURloNk8Hg7XTcnr//fDrG2kws2ISnDpv20P8imoww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rs6BREKKSlFOgnL5Vt0Rl67RqlhBIT4fYJpG1yY44s0=;
 b=zHggAaMuVuBEQg3RjPOXjMZLpiJil0wDRi/v/lN8rFiqt5wXtdEsIymYQk8F/6ifK3VG0Yv+aZn5isbCqeKeLx7v2tPAOYhwFXmJUHOwA5u4HWjVnurnsYeOebKrVnrmBkVLottXFpAULG+uVviVqRHlRYpsF3z2mewGFlKku3BoD2w8ko+0g+ChVuWsOzPpyXJMk4ijqaMzSqvSye2qduuFJqBQlzX6Z4j3I/sWaeESeV7yk7pqbQlBN5jicWZriu/tZGYsMiwAEKK44FKbCE23bapjOh00Y/iUDiD9M+wsnrrxcH357l2sDfveuZx5beIRRLyW4PrGnLVzMQVgZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB6858.namprd11.prod.outlook.com (2603:10b6:510:1ee::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Thu, 29 Aug
 2024 00:20:19 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 00:20:19 +0000
Date: Wed, 28 Aug 2024 17:20:16 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>,
	<iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, <pratikrajesh.sampat@amd.com>,
	<michael.day@amd.com>, <david.kaplan@amd.com>, <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Message-ID: <66cfbec0352ca_47347294af@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
 <20240827123242.GM3468552@ziepe.ca>
 <6e9e4945-8508-4f48-874e-9150fd2e38f3@amd.com>
 <20240828234240.GR3468552@ziepe.ca>
 <66cfba391a779_31daf294a5@dwillia2-xfh.jf.intel.com.notmuch>
 <20240829000910.GS3468552@ziepe.ca>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240829000910.GS3468552@ziepe.ca>
X-ClientProxiedBy: MW4PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:303:16d::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB6858:EE_
X-MS-Office365-Filtering-Correlation-Id: 296dc4f8-e836-44d1-ce3e-08dcc7c05d20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SeW5tDWr3Y00ToQogJcKRbT0GdRUkB18m8PS1fG+PG/wM/SJsIH5ABlbnDvB?=
 =?us-ascii?Q?rr2fR53uhoMToYvrDO+bT7GuY6vn6FmMpnPzYkx92CyVzzFM73TvmqwJdRmk?=
 =?us-ascii?Q?atUEA/MM8Hzx/xT+V7ATBdY0195zCOoR+XyMrgDArbWlOMfC5WNbq9jOSYtA?=
 =?us-ascii?Q?RJ4k3NWCURFQMR7yt/fFtHJcN5bn3ykEV3XBx9voGwLczcFy0fKv9JFfCF0x?=
 =?us-ascii?Q?PtqVp9MrRoyBmLxEUN6k0aV3+c2eeqzHD9R9yfU3eZbKqpiXotQWvpgBq5Su?=
 =?us-ascii?Q?OxSEcQOcj5LG1RpXb5Zbt7oIl+EIQwxH/TaBRTnAR7cj+UfF/wI8navvhsRD?=
 =?us-ascii?Q?PMTVWDnRDGrYLIIcK+sctcF1/I5f1UzwQZu56q4Iehn+eHiD8FooziFqxweF?=
 =?us-ascii?Q?hA65NtKRu7RmTybGzKRIOIK1OceGir6osfl2JkbW6MhZtArrDgAOWwhkuAF6?=
 =?us-ascii?Q?HcBjYg8pcWuel88vsZCdIQQyk9LSiSjRCMKyTsYEQB0Yg80mNyEI+8wzEKSJ?=
 =?us-ascii?Q?Wcev+kPWnY8OpUHmu91S6w2Kqd9AkhIqj584n+fa2brUV7Kl3PN7vdB2Wrwl?=
 =?us-ascii?Q?yuPY2oRptZNIer7bWRA0/xIYxX5iJQ08DVqNYyNMx3uAKA+wa2xkNrj4q9Mu?=
 =?us-ascii?Q?vSOuol8iKlVSRSyE5fbUSWuXpzICLPBA6iFUaXFKQoQU+l4S479NkecxsU1r?=
 =?us-ascii?Q?YpowiqSs2tzEzy6v6fSvpCX0BEC8tWK6Z4uTft7FjPuyzk1VEAWnpIv5vlb1?=
 =?us-ascii?Q?wI66g7XBowtC2Am32b0p2K9Wt6KKzxwT1IvjKDDohKmabPerFVyhxgPA5r2W?=
 =?us-ascii?Q?pPuYIbsoVPcdyzWrakn8vAk72rbl5GUi7X+IfGr/GD5IKv6/+g1oOc9qECPi?=
 =?us-ascii?Q?N4f23SAwTKULeygc3mKQ8xl1DjioEAD0QoAdtD/BPYZVyorY6Ai9JbttU0xZ?=
 =?us-ascii?Q?5tE89fh+s9BZip05E3qhqoZ0YhvsoVrTRDt4J4QT/b0+lh2iWh4TGLL1eiKY?=
 =?us-ascii?Q?Tmh8couDTI6ZC6a6HAhkJ99zTy1Vf4/qsqhG6svnWkK736nd5+wLhZR1HInq?=
 =?us-ascii?Q?KiqY6r2R+K2xc0b9+JegipqnDjJZ2oV5OR+8QEadvw9mSSEjut1A/qUQ/Zfn?=
 =?us-ascii?Q?QABx4nDWBxqOzHIlFNi0XKkEaPuhoP4tsdHnna/gd8gceXboPaEtKuadmt18?=
 =?us-ascii?Q?49eHw1VH+qMk1ZIglgjB7PBp6pyq4cruI33URh6hKlRzIhtVqFhb3bFcXgDq?=
 =?us-ascii?Q?J6wGNAC98defj+U236v15J5Xi2XQqEbikKxGb8YNT/v7z+AsALM5trBRCA6L?=
 =?us-ascii?Q?dxqcXSB6NcAOHsDrZjbEkn5Mi/hJwCrCZ9sakUKs2rkjVw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qfFLqFof+4OqpeVr9o4/z3rS7XhtUsQ1iuHUPcYkH75MTR19NS4/LWLq7msu?=
 =?us-ascii?Q?WqOV+czMeU9jPVb5pI7KQYeEQlf8GFAnXOCdYHYaix31EnKWA9juMbDhi/7F?=
 =?us-ascii?Q?tYN4WGf1wnSutUp3Ey3PTOqVMoZPTqA92anIxTgux7ltAEAVTDxpyQV9TlvM?=
 =?us-ascii?Q?8pQ5nF1TEFgj9JZqR9O9CFfWUgBSIKfoqFRLbAqBsFgPi/7KGgL3HJ83phxN?=
 =?us-ascii?Q?3oQMpwAqPQ+Id65axadWC8zqDPqdjSev3uDlqxqskMIDGrS4p1Fc/7BiZP1P?=
 =?us-ascii?Q?pIWPLamc1rz0rVF/e7z/O7NvQD+C20g8jZpicZP/kpQaffyDIvEdg9cZJKzM?=
 =?us-ascii?Q?qsVZM3+/7jbTQ0SZl6i9USATh1uwbFtb97EIBVPoSHSn3Pvk078+HuM1FZzk?=
 =?us-ascii?Q?IQPVmXeGNjBcgkGXUOMsVkHKhzDwPG1hUyl6kYjwnr39K5fr8iNn9AN+QIbv?=
 =?us-ascii?Q?1kcUnGZnL7q5rqO98oGCUzTI4cUVRGpa37Duarmc/Lj0kkmWCFWRZbF8IdyT?=
 =?us-ascii?Q?szGtN5WobYLjEm711RzUksJCISDL2rQ5blBPsEXkg2bns4oZtLpbA5ayMkh6?=
 =?us-ascii?Q?IuGmds0vCkIKRgloCMJC1YJKrakGag3BNWMbwSgbKJFDWye626YuHcvsYKGJ?=
 =?us-ascii?Q?+AC4XJUYZJTUxGGAZ8xz82WL/BslUDP4NwuLTAVKtIVkdQ4Q2HacMjScySZC?=
 =?us-ascii?Q?Zj5JphXGR20h68OBfTvkwh3TsloSabY+colmfDVXYlZmoqJFQrOjEuJXghq2?=
 =?us-ascii?Q?vU+nTK6exrRfqalBMkgigRxA4JMgw14rj2SCtD/BZxa8umycC683xuiQjkIw?=
 =?us-ascii?Q?mTh19Hm9Cf60rNfpk+7RWm+64hO7xBUvaDVTaf4OlBLGqwtgHTubIDg6Ybsc?=
 =?us-ascii?Q?j6NQkUSYA8YLi/iSSj0tDDISqDBzY2d8nvnHmpTfbsmdIq3DQ5tHig2IVOtN?=
 =?us-ascii?Q?cSZS7mhBRqXq90VNaR+k2tMxWath783dPf0EhSJIsLbELMk6qpuYnw4QWzhc?=
 =?us-ascii?Q?lw8ZHWOCeFOIyQn4hoGuIoujS8MqpXEGXwcwlTVYd0b5pFcCsFYVPR7JjGe9?=
 =?us-ascii?Q?RUGRAGX0Ee13uDE2QPIrsFB5yxiIQCE3+VImweVKWarkX9qyKoybvZmy4ijb?=
 =?us-ascii?Q?C/gvANi/mYaeBjq+yHp78Mqnqtx/it0WaibGVlmStSbWAN9cVzZyR4Tp7GoR?=
 =?us-ascii?Q?LiciNopFi8As3sbIetWw5yAcJG+WGvQe5l1UmYT2LyGUPw3qSEge6OV1zlLE?=
 =?us-ascii?Q?zVZO+ayDz/gMvCXlCSVWNNXmlTDTNQkqYT1/2M8NiqkYce17y61IWWb1SPpf?=
 =?us-ascii?Q?wD601CjEcd2obBSiL47uURgNJ9YJzbWtgrFQiqV+9SKoUCQd0WFJba8csJ6x?=
 =?us-ascii?Q?7Xy9v7Qfsgmp+0fAMTrKP84vWh+jFxTnSpOEqxJEhEaWB+mwuzowTIGrX+tG?=
 =?us-ascii?Q?4/D71bk9d73aD9v4BKDnS6GJTEGAsJWGNl2fyUh6+ubRJKbog7LZRw9TXHZP?=
 =?us-ascii?Q?tmttZ/qf673YJAguN+F7s6Xg5yjKI2rXcZEtOtJSk4bFVC2qlS5YRbSkrVhv?=
 =?us-ascii?Q?nf70SXeXKvwx7j28KGgWhUMWRN4iF8oXPn+FwP4dYVE3jBELamVsjKNGonPt?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 296dc4f8-e836-44d1-ce3e-08dcc7c05d20
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 00:20:19.1201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9HuD755QCmo4ztYjJaD1UllSZeMdgOl9q8ae1wWd7zmRW9lTLFMbEGFfZYp5emCvcNBjtavJcbiS8rkNNbHCB2HcjD9H3J36D1WaA4y4Kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6858
X-OriginatorOrg: intel.com

Jason Gunthorpe wrote:
> On Wed, Aug 28, 2024 at 05:00:57PM -0700, Dan Williams wrote:
> > Jason Gunthorpe wrote:
> > [..]
> > > So when I look at the spec I think that probably TIO_DEV_* should be
> > > connected to VFIO, somewhere as vfio/kvm/iommufd ioctls. This needs to
> > > be coordinated with everyone else because everyone has *some kind* of
> > > "trusted world create for me a vPCI device in the secure VM" set of
> > > verbs.
> > > 
> > > TIO_TDI is presumably the device authentication stuff?
> > 
> > I would expect no, because device authentication is purely a
> > physical-device concept, and a TDI is some subset of that device (up to
> > and including full physical-function passthrough) that becomes VM
> > private-world assignable.
> 
> So I got it backwards then? The TDI is the vPCI and DEV is the way to
> operate TDISP/IDE/SPDM/etc? Spec says:

Right.

> 
>  To use a TDISP capable device with SEV-TIO, host software must first
>  arrange for the SEV firmware to establish a connection with the device
>  by invoking the TIO_DEV_CONNECT
>  command. The TIO_DEV_CONNECT command performs the following:
> 
>  * Establishes a secure SPDM session using Secured Messages for SPDM.
>  * Constructs IDE selective streams between the root complex and the device.
>  * Checks the TDISP capabilities of the device.
> 
> Too many TLAs :O

My favorite is that the spec calls the device capability "TEE I/O" but
when you are speaking it no one can tell if you are talking about "TEE
I/O" the generic PCI thing, or "TIO", the AMD-specific seasoning on top
of TDISP.

> > I agree with this. There is a definite PCI only / VFIO-independent
> > portion of this that is before any consideration of TDISP LOCKED and RUN
> > states. It only deals with PCI device-authentication, link encryption
> > management, and is independent of any confidential VM. Then there is the
> > whole "assignable device" piece that is squarely KVM/VFIO territory.
> 
> Yes
>  
> > Theoretically one could stop at link encryption setup and never proceed
> > with the rest. That is, assuming the platform allows for IDE protected
> > traffic to flow in the "T=0" (shared world device) case.
> 
> Yes. I keep hearing PCI people talking about interesting use cases for
> IDE streams independent of any of the confidential compute stuff. I
> think they should not be tied together.

I encourage those folks need to read the actual hardware specs, not just
the PCI spec. As far as I know there is only one host platform
implementation that allows IDE establishment and traffic flow for T=0
cases. So it is not yet trending to be a common thing that the PCI core
can rely upon.

