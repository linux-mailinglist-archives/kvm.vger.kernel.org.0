Return-Path: <kvm+bounces-62964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17432C55747
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 03:38:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B4F23A57D0
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 02:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 626242FD1D7;
	Thu, 13 Nov 2025 02:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixCn9K30"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263EE2F6910;
	Thu, 13 Nov 2025 02:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763001452; cv=fail; b=ZlYI5MK9F+YFRw4oHs3pj5i/uQl925z3hhRXdBVs2Jjf07X5k9Ac2jP4/oz5bRBeHlMHs2jIP5/u55RvQvXf55FzzT6Pp0yroBN+Pt3s76Qx/oMCSVcraCoheFIrij/g4p/NpWi6TDIAaWFMgc10zH6xKwvutZaFoPZ2Lsj7X1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763001452; c=relaxed/simple;
	bh=kDiBq4l/6yfpmo0d56Foo2McUTIcB+i5QNtHA1Smop8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uVMoM2KOu8hSRfvxhaSoTwrqaG1df73Im5fv+pSx35a8u/dTsb82aLlvaJ2oMXRey5pfv8/OCNSagyVh7Hx9xhdFRXuVV3szEOmseSivKHhhY3il/v1aNKRzyzGHXIlTV/vRazlFjTFrLsfLQgrHlwOD6Sn9gLDirtmq8foOxGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixCn9K30; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763001450; x=1794537450;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=kDiBq4l/6yfpmo0d56Foo2McUTIcB+i5QNtHA1Smop8=;
  b=ixCn9K300xM0lvCl4RPuOjk9xyll2GGcjTqvy8zyMKXPgWpYeax5GNnI
   nGOis08WWFib7iaK0AiZ3fJkP+cgbecPD3tS9V1E/LIkLDK8OYvJ90Ysx
   q+K97pMuid+VBOfK7F60WtsmBdDlK4EsGgd8GueSLwHtR5g+O2fiZiyk1
   1gDN7X63ND4d7yc6x8+L1c+2HtMQMuWJXg1vfNTP2V6hTERTxJXmCXnUi
   TeCUd1UJMg+PiwkRIhA6NQ8is2xlSY5l9wLYYAq4T+Ehnbkdtvo5jpIed
   ilfNhfBlMQdvv65txY+l5gAa4XFXZD+YbEEokWs8/Rb0TFhDVgYf4EbgR
   g==;
X-CSE-ConnectionGUID: H/9mlqkPTWymirC3rEfqLg==
X-CSE-MsgGUID: uN3SyvH1TCKcdY7etCwzUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="64281645"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="64281645"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 18:37:29 -0800
X-CSE-ConnectionGUID: 04OZICyVTbqLOEUTw1dOlQ==
X-CSE-MsgGUID: XDqh+LHVScGljPCqN7BtmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="189233876"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 18:37:29 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 18:37:28 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 18:37:28 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.19) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 18:37:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vkft4zoEOW8LntKiQMdNTnQtk4ageJK1NhCwFlzGG2gxFGaCkg2j5FbA/yGsYuAMRpnHYQrWlzRzJI9cRm5QrLBplw9vD1qYv1nf0D2Qx2MhDX86FBK3v4dTmyXqzbEB5d3gZrhHRNKswR1AzhNXWBXzJgwza3/9tpCT0rtBLaSXpJk9qHf7r0TILgnn7HrKMNDxf5Y7ech6Zuy7hCs0lVg6ZpP4mZbjfAHyZj9f9tWV0yhCkrBkx9QXeGMqlzBR2RWlDl6IMQ3WmA0M/dFfN7cCdgjzXuf0jokJLL5R+FUNxgZAPDoH7pt7nfKZMNP7+B4EXupeb4boesBNp0JT0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6cJeBEe/qdIX/bivRmRMl/rtOrQZMgeCYp0q0TYVnY=;
 b=ZULZ0niI2M9X+PgUX2sJMxTnUcoKKKhI7WW8rG7AYBxfnGW0dGGLGEoj3dkvbQV926sqoH9wWtWBnLxuyTG2las+oyFRy6ulDfMo8QxYUEqtlC+FTYVEPxUl2WlFG7jE0wKDIKOES0gsz3AXDS2ebA78TvHqrptqOyFTGctfC0FImx4GXmsGJBFUiZAlMkoKG91fH2e1sS4uhR3XJUHtB27kZ8T0SAHXZ7ZXw8EOwG1Li1SQLlUjFFGAnjFlRXYwU4dyh3zYBEp5ieiGpnUacGXimhkWOWXRD877429kpuuqqy0LREluAPMBXX75RlrNbrAeYv4rJ5CFlqwWHN2lKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPF6EA6DD735.namprd11.prod.outlook.com (2603:10b6:f:fc02::2d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 02:37:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Thu, 13 Nov 2025
 02:37:20 +0000
Date: Thu, 13 Nov 2025 10:35:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Message-ID: <aRVD4fAB7NISgY+8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094202.4481-1-yan.y.zhao@intel.com>
 <fe09cfdc575dcd86cf918603393859b2dc7ebe00.camel@intel.com>
 <aRRItGMH0ttfX63C@yzhao56-desk.sh.intel.com>
 <858777470674b2ddd594997e94116167dee81705.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <858777470674b2ddd594997e94116167dee81705.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0035.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPF6EA6DD735:EE_
X-MS-Office365-Filtering-Correlation-Id: ba16840d-051b-4329-8b1e-08de225d91b5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?t+1i4W51lGqx0Hx7wOJCPs+5DKxnjOfqFmIVPnWm7T25Rm057m5TCqNB/t?=
 =?iso-8859-1?Q?GwAgvXpiHskCbr4mOV8I15nt9bZDt9IONqkbBpKX5RosfaPgaHV+ECZp+v?=
 =?iso-8859-1?Q?Vslnoc4dOWSY24/t1B7hKH/BSnx6KKYNyLN2mE5Rcfuu3POIDNDg9sHQ0y?=
 =?iso-8859-1?Q?AGQz5zab1OcZ8CTLb9gMXxDRxaB/MRSOJ7q7zIZ6wfq4HO9IDp+b4JGot1?=
 =?iso-8859-1?Q?gZjgZJG5rucJzb3iNBB3/CVzJDevsbmwtuo7HV9fr1FTL04wsMC+4J7sNg?=
 =?iso-8859-1?Q?wQtMdaooRZXNB2QC5XGt9XtxqbORgfJByeCdBahqsLBITRSRYvmU+2mSfQ?=
 =?iso-8859-1?Q?AG5/yxeApMmJ5gqj312ePpRNaahD+XMgnf4HENL9K3akDEDsT+EHKT3eet?=
 =?iso-8859-1?Q?jFT/ZMnWtpI1g63CzUm/l5dVS07551BC/aQRVrw3J8ZBBgnTbFxqf4u7TP?=
 =?iso-8859-1?Q?naQxYWyv4oeKTrEFE5johFMo2QVNYYga0/nPCwPSh0N9X6pg3ttk5edQLu?=
 =?iso-8859-1?Q?HDGg5wTtwXkf8ALh0YVlFTBPHj7gU7XZVSViF7yT4VE6SZqK4vxbIbve9x?=
 =?iso-8859-1?Q?vd99Y11F256OMG+XJvfk+Qbk9GPkP7ljVBgoOfMfNxMgq/6jsopE3wd+xb?=
 =?iso-8859-1?Q?n3rC5NHwegcfqbal5M3Er3CBL7piVZf5qwzTozITW3KOFmrV4kfJr1iYSO?=
 =?iso-8859-1?Q?OSA3pf9pie9DpYIy94cnW1fZ78CwCHgMxbvZO/gUaLErx6GhKxMmm09xIF?=
 =?iso-8859-1?Q?5ShiXDEEe9YvjT+9UgcqWblWe4836/4ODZMWLD9SRR/LRlFWySPeeFLrGc?=
 =?iso-8859-1?Q?bv3IQZ/9RNkuXddT2JZZpGNjLopWRdtWshikaXU58HH1/1eX0tpNDnixf0?=
 =?iso-8859-1?Q?BTelAZLR36GbFhG+T3OOBxIw4nyZl5//JusjESqlKP+ue5FMLREvqqnMQ9?=
 =?iso-8859-1?Q?lKoGUk5XdH6PjTnShKI9F6DrRnjQmRURPna/qfNHpSoYeeArSXRu5yREXh?=
 =?iso-8859-1?Q?GDBVrOM1hWExfsLFbS/T8wfLYDoOXaAvPpJMErDTqKXaumwZxglJUmTmFE?=
 =?iso-8859-1?Q?FeA2f/6AGLSodGWJ+68tApOZroK0aEcg/uefEP7EVDRpC6d4lPsTDH7mB3?=
 =?iso-8859-1?Q?ztPo1OW4laqEKnlxSAgdKcC0TDx6qt4kZm1ljvGW/QM+gsFSXd4OKAsesC?=
 =?iso-8859-1?Q?gO3ctn23HPDSAfGHMI19UyLHh/h+gQQ45CbYEr20YToSrRzK6MwBunAvDz?=
 =?iso-8859-1?Q?n1AcTmeCaYZ9Ecd2dIyG2FzBzA97ee16OK8z2fWLrngEFoYV0Vsn/nCVot?=
 =?iso-8859-1?Q?fcmrqFK+wS57NTYTGeyQkbNY86hZhYFxrUGowxf2tzQhm/RPADvaRMcmT8?=
 =?iso-8859-1?Q?x1fQniBWgvxXUiP890qNhIZ9Lb1AV6Bs9s3V6D3D+VTP9mc3b8S6QdpW31?=
 =?iso-8859-1?Q?thJr0fG+9RdqjKJj1FSam/Hbh6UdbjV697PYB4fc1tWqRMR3x9yzT7xIWd?=
 =?iso-8859-1?Q?NsO+R5iSRQBIdVgZdkEvAAFDSAR5g91RRWY9waNli1vQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?3TcsfAYbm4VGyDRNmTxe0wHwnRkzWD1W7xp0cMatm7iIi9k/lKJ3BLeUqA?=
 =?iso-8859-1?Q?47xBWZgVv+wUHmPpcb02f6y3v1V9zDtknC0f5MsQuHbrJH3cpZkZfpuKJ8?=
 =?iso-8859-1?Q?ENy6fdtVBMyXnzMbDFJ/CST0B8X30a26gUffoSHdAVUn9mGj0FyBTFx76S?=
 =?iso-8859-1?Q?cXTMDjqraiKerPqRUQkOJxqFoJT1hxLpO7yym9+Ec2heaa1kB9jRWmGnlE?=
 =?iso-8859-1?Q?t8aNIxm5dpGlFA2okDKyFWAalC00bSFyPpLDwIykNFdOTSApr8KoRVRgd3?=
 =?iso-8859-1?Q?gGbBr20B6Ntt38Spg0yIF/igxG2+KSFfaxQta/x9AhOgacP3DBMDTvNDbe?=
 =?iso-8859-1?Q?xsM/iUCa/qqN31oo3xSMb8bKwF6BI/ZEPiFhsCWdPiDrwqOUvLnv9w8V+g?=
 =?iso-8859-1?Q?paQy2OqXneCqG3ilJtab6xIXWaa2HDwWp6x/Oe32oSyuaKCzSMh/g8Vq5p?=
 =?iso-8859-1?Q?P3/lRDWrzK97vlrjwcWp7C8kwoXMGVpofUDyHcifLn9mwzuKxK2bGN5cQG?=
 =?iso-8859-1?Q?tjSsZXsZ25eo+yrGT9g9IVRkUlfTZUv3TY+H5z6HqJHtumWW+9T4NgkVeN?=
 =?iso-8859-1?Q?9RT7MMIU9+ZLjwsfySGwQWe6J2eytdPePyNWZ5deWx6K9HnsMtU9LKj1vg?=
 =?iso-8859-1?Q?6u5x3p3yClKO+WZ1DEGX4J/tDzo4U/msx+49ZaqBzZU8E9YWm1W+ePgeJq?=
 =?iso-8859-1?Q?nYrJLu/uqVTkLGnBx2yf+UBsoyG6UBP4H+CnnBrUAw//p0T3Mbw//sV0KF?=
 =?iso-8859-1?Q?bhDZUgx/CUrMG6lps4M9ntwOh6ItmynPvJKxfBSvfFHIopc3NDgSWHfw4r?=
 =?iso-8859-1?Q?VPUG+7ivzG/nQ9AM9/XZmOZSEFP2lT3FYFIAvXO3PTFuz2lJnMnhKFVruT?=
 =?iso-8859-1?Q?M7h14XnrMWMQF65mVHF2tvI1dxoAWDmGvHGpfqzFJTe5UiFEjf3O3zncmD?=
 =?iso-8859-1?Q?IQIzEFYgwbGq2/UG43AJfJgXgyzIJci/QfuXQfxe+DXFx4EE5j7ygdzatV?=
 =?iso-8859-1?Q?I93C6147GTig+uIyZnKmEw22oJ7sQCBkq1MFTha6FR1JKoV3XRE/vfOzSD?=
 =?iso-8859-1?Q?bndHJGJRfAp0+C/JYuxeQM1iSKMvRRkMA3c7C90LwmXmfSydaZHEgnoRjg?=
 =?iso-8859-1?Q?g7QWNzhSzZPaDhfXN8Llt75xBxEEj/0dvwvk30y0kOwxG8XGDPhnRbLtQL?=
 =?iso-8859-1?Q?aqjIRjaekmoKx4YzbBnp08vN059pFj7cgKzrrA57FH7U+l33HevlYv5Qiy?=
 =?iso-8859-1?Q?pmaMc50x0npGuO35T2U/uAUKbsF8zG5PIK3jpXfG7yvOB7yv+WnHlSzmWV?=
 =?iso-8859-1?Q?NQvfUR66uqUqcmBxNrQQkgolKsRWm/Y2cc+AKts+CaQ/dWf1Dw7rXxXmFU?=
 =?iso-8859-1?Q?9+z8SJQISEBqZ9thKcbWMiSMIKU4HeS0uubIjoujiEF/IlYGD2fWYV0X7r?=
 =?iso-8859-1?Q?fpizn8rObbLKqetO0LmT22JiZ8rov+K23IsmRh/TGVfMsmr90yduepuGpo?=
 =?iso-8859-1?Q?NqI8JbPljAAcSG3VhmHjeYKy0UzjOtQN+reRccAB0vfQK+9NCBY3Vaz1mq?=
 =?iso-8859-1?Q?H7vNkbhTgqKfW+I/pNHtGxmn32MuFsVoiZV1tgMGDofzqjr5lLtF2X0+vp?=
 =?iso-8859-1?Q?yzZqA3uuNc3bOW4i7++NsXVAsOLRh95Q3Z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba16840d-051b-4329-8b1e-08de225d91b5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 02:37:20.7458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcNiBFMPGxKw1w89+tSU9jtaMX5m4Zm4zZTa71nNgWy9mQcBJMT4rei0D0Cs7TqQFf9D8KPSPRsGBOVXw7XbUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF6EA6DD735
X-OriginatorOrg: intel.com

On Wed, Nov 12, 2025 at 06:29:11PM +0800, Huang, Kai wrote:
> On Wed, 2025-11-12 at 16:43 +0800, Yan Zhao wrote:
> > On Tue, Nov 11, 2025 at 05:23:30PM +0800, Huang, Kai wrote:
> > > On Thu, 2025-08-07 at 17:42 +0800, Yan Zhao wrote:
> > > > -u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
> > > > +u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
> > > > +				unsigned long start_idx, unsigned long npages)
> > > >  {
> > > > +	struct page *start = folio_page(folio, start_idx);
> > > >  	struct tdx_module_args args = {};
> > > > +	u64 err;
> > > > +
> > > > +	if (start_idx + npages > folio_nr_pages(folio))
> > > > +		return TDX_OPERAND_INVALID;
> > > >  
> > > > -	args.rcx = mk_keyed_paddr(hkid, page);
> > > > +	for (unsigned long i = 0; i < npages; i++) {
> > > > +		args.rcx = mk_keyed_paddr(hkid, nth_page(start, i));
> > > >  
> > > 
> > > Just FYI: seems there's a series to remove nth_page() completely:
> > > 
> > > https://lore.kernel.org/kvm/20250901150359.867252-1-david@redhat.com/
> > Ah, thanks!
> > Then we can get rid of the "unsigned long i".
> > 
> > -       for (unsigned long i = 0; i < npages; i++) {
> > -               args.rcx = mk_keyed_paddr(hkid, nth_page(start, i));
> > +       while (npages--) {
> > +               args.rcx = mk_keyed_paddr(hkid, start++);
> > 
> 
> You may want to be careful about doing '++' on a 'struct page *'.  I am not
Before the removing nth_page() series, linux kernel defines nth_page() like
this:

  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
  #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
  #define folio_page_idx(folio, p)        (page_to_pfn(p) - folio_pfn(folio))
  #else
  #define nth_page(page,n) ((page) + (n))
  #define folio_page_idx(folio, p)        ((p) - &(folio)->page)
  #endif

i.e., unless SPARSEMEM without SPARSEMEM_VMEMMAP, a folio's page is contiguous.

In David's removing nth_page() series, CONFIG_SPARSEMEM_VMEMMAP is auto-selected
along with CONFIG_SPARSEMEM in all architectures but sh.

David further ensures folio pages are continuous even on sh with the problematic
kernel configs (i.e., SPARSEMEM without SPARSEMEM_VMEMMAP) [1]:

: Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
: but not SPARSEMEM_VMEMMAP: sh.
:
: Fortunately, the biggest hugetlb size sh supports is 64 MiB
: (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
: (SECTION_SIZE_BITS == 26), so their use case is not degraded.
:
: As folios and memory sections are naturally aligned to their order-2 size
: in memory, consequently a single folio can no longer span multiple memory
: sections on these problematic kernel configs.

So it's safe to assume folio pages are continuous.

[1] https://lore.kernel.org/kvm/20250901150359.867252-12-david@redhat.com/


> expert, but I saw below discussion on the thread [*] which led to the series
> to get rid of nth_page():
>   > I wish we didn't have nth_page() at all. I really don't think it's a
>   > valid operation. It's been around forever, but I think it was broken
>   > as introduced, exactly because I don't think you can validly even have
>   > allocations that cross section boundaries.
> 
>   Ordinary buddy allocations cannot exceed a memory section, but hugetlb and
>   dax can with gigantic folios ... :(
> 
>   We had some weird bugs with that, because people keep forgetting that you
>   cannot just use page++ unconditionally with such folios.

I found Linus's reply to David [2] :
: On Tue, 5 Aug 2025 at 16:37, David Hildenbrand <david@redhat.com> wrote:
: >
: > Ordinary buddy allocations cannot exceed a memory section, but hugetlb and
: > dax can with gigantic folios ... :(
: 
: Just turn that code off. Nobody sane cares.
: 
: It sounds like people have bent over backwards to fix the insane case
: instead of saying "that's insane, let's not support it".
: 
: And yes, "that's insane" is actually fairly recent. It's not that long
: ago that we made SPARSEMEM_VMEMMAP the mandatory option on x86-64. So
: it was all sane in a historical context, but it's not sane any more.
: 
: But now it *is* the mandatory option both on x86 and arm64, so I
: really think it's time to get rid of pointless pain points.
: 
: (I think powerpc still makes it an option to do sparsemem without
: vmemmap, but it *is* an option there too)

The removing nth_page() series then ensures hugetlb and dax are Ok like changes
in [3]. The series then iterates over all pages in a hugetlb folio by invoking
page++. e.g., [4][5].

[2] https://lore.kernel.org/all/CAHk-=wiYLcax-5THGofwk-SAWYZ1RsP08b+rozXOm0wZRCE9UQ@mail.gmail.com
[3] https://lore.kernel.org/kvm/20250901150359.867252-7-david@redhat.com
[4] https://lore.kernel.org/kvm/20250901150359.867252-14-david@redhat.com
[5] https://lore.kernel.org/kvm/20250901150359.867252-16-david@redhat.com

> So, why not just get the actual page for each index within the loop?
We need to invoke folio_page() to get the actual page.

In [6], the new folio_page() implementation is

static inline struct page *folio_page(struct folio *folio, unsigned long n)
{
	return &folio->page + n;
}

So, invoking folio_page() should be equal to page++ in our case.

[6] https://lore.kernel.org/kvm/20250901150359.867252-13-david@redhat.com

 
> [*]:
> https://lore.kernel.org/all/CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com/T/#m49ba78f5f630b27fa6d3d0737271f047af599c60

