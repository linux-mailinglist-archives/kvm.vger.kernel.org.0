Return-Path: <kvm+bounces-25298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C519632D9
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 22:50:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CB9A1C22BDB
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 20:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C139B1B0111;
	Wed, 28 Aug 2024 20:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ztg7tieM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4411AE854;
	Wed, 28 Aug 2024 20:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724877837; cv=fail; b=JIsHmS3HY6hyYXX67EmR3+k+hZngjvo+GA770maWFuDurVHTNsye48q0mq/4P57c9fESfd+TP5z07/On9W4vOcMKI/8PZaM86EpWWG8lqeTxslob0FnLGib1Aojh2GY0HPqKkjqmnercAbRJ6mM2piuc6V7/wh0y3CBTS35wjc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724877837; c=relaxed/simple;
	bh=4LGIJO/lPyEBeZypSmoyT6jXe1ugVQU7AxTHZxt2dyQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JoclyTI4TqeDEeZf8GWu+H44GwMnbRYeofkZQDgZWQm3ytSVZAx3oyFBraDxWpSbMGP5PkWLT+GgRJOx49OXSUu7W86L4uKW8gvcZCsrTBprt14wKeAg2QTNxvkcGhg0eZDDnaV75Eov6lteyBJOuiLxeuXoadtvDPvybB0SgnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ztg7tieM; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724877835; x=1756413835;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4LGIJO/lPyEBeZypSmoyT6jXe1ugVQU7AxTHZxt2dyQ=;
  b=Ztg7tieMze65koXf6MdsE72XsAH/HPeN+biZLPUJ1ybKzHne0BUSsZhG
   8VouxCCqmaZMEluw9Furcfd/Mak079xWs9JKRfMkVk1FYEiUy3vJLKdEF
   /VPKt4Ul5NXpo2gs4u1g+hCEqxazFQA3xa4ZFx8KevbYp3P+8Jv1mdhIv
   bu+sfKYTMvG1/A10lmBb+J8ckbP5lq33SKa9kiasJr3xVRa+R/nF+ArAh
   NnJfo58SzzTsPz8HWlLIPL2w5hUtka+p0PlKcoVEvJF0OLSmEV7BdXmN3
   4Wz29JU4OvTApf38Mc9FgPBxd8H1aAg/ntJNB9N6jYByM8hYzhJ+yyNtz
   g==;
X-CSE-ConnectionGUID: qkTbi1v8RfS3nWb+ti0qKg==
X-CSE-MsgGUID: qO9wq24bSkWNGIlbf+TtQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="34053963"
X-IronPort-AV: E=Sophos;i="6.10,183,1719903600"; 
   d="scan'208";a="34053963"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 13:43:55 -0700
X-CSE-ConnectionGUID: ejzOx2wQQluV3126nr7t/A==
X-CSE-MsgGUID: GmfW8UMaTpS7jro0nQ+dJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,183,1719903600"; 
   d="scan'208";a="94156176"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Aug 2024 13:43:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 13:43:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 13:43:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 28 Aug 2024 13:43:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 28 Aug 2024 13:43:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gk7YTBiWoNk8pBbUIi1UKH3L1L4J2IWhqrh41SbI8ki5OAjFm979G7mZauNU6ztEo/RtPlrAp6O5nhT9RLygdR7ZzEtTTqhhC1W0gg7dtVMp+RcXV/+qSSCFrtzS4hZuyBDj+7xPisAicXr9CTT2YY8wu44HW33IelH/oPazRt20f9HQCxaOzpFVKUzOv1P66K4MxxCrO8RY+vskteAj6iztW6Szlaaqb6q0HSTV8/Jt/KAGcFtIInAJ+u4Mgt2mpYlYBlSafXKVxsSLLFbLnSlXXDssqNXcJOzvQhhU2lObPubL4viIRj15aJ1Nh46hDQTi+FB3ZoDCLEmaqo7EAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WBNRSt6v/HdqcAJMbX3YozcgR1LV8myi2ata6pnghRw=;
 b=v3EVG/OIh0H77kZwwOXrvFIaLAAS4a2Yy1Sh4sXR8IWFhJE4AOk5Te5H4ZOmLpCqxH7jJd1i6goZDsmxp7McB1aRQUPJJY1LCQUZWMmGicV5reYF5b43zpqfAb3YBDq2YBTazswxwV42QBjmy6bAyaPt2X5BeFsENmVwubQSVFrHL/rmshzKXaKrQ8pKZohitTwBHjjzgh5b/POg9/jd42R3cjPSprYqom520pOjVkpxODsvdiky00LecZpRfv+DiW1HG5wQ6w5hi/WcCI7KT5ZEx+XvMn4TsmKX6hC1zpXLPcos+kq568ZU7CMP9ciC4Ar0wkGF9DC/kD8FJb0D7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13)
 by MW4PR11MB6812.namprd11.prod.outlook.com (2603:10b6:303:1ee::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Wed, 28 Aug
 2024 20:43:45 +0000
Received: from SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec]) by SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 20:43:45 +0000
Date: Wed, 28 Aug 2024 13:43:41 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: Re: [RFC PATCH 00/21] Secure VFIO, TDISP, SEV TIO
Message-ID: <66cf8bfdd0527_88eb2942e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
X-ClientProxiedBy: MW2PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:907:1::24) To SA3PR11MB8118.namprd11.prod.outlook.com
 (2603:10b6:806:2f1::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB8118:EE_|MW4PR11MB6812:EE_
X-MS-Office365-Filtering-Correlation-Id: b0e7ebc9-730a-49d1-e60e-08dcc7a21c3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RSNvInf1xrwxNmQvSLyIEYVsgAimMZ3U5V/FLAxJ1rTYe2WT5S+f+tIguOHA?=
 =?us-ascii?Q?s3Tu9y8z+UN3xBl9K+i2N7VnkqBRG9mTr2bb23QJX/BE3odquIMvamE08zzK?=
 =?us-ascii?Q?KgMiFTl656Gq7lT1kwbw8PM7+jc6Mc1mw8lv0SEd/x4NrjK1xHhrHp6G5y3k?=
 =?us-ascii?Q?jxOedqhKv50x8Ir9QXYJxdUP+ZBAAUJeJxKe3+i1fKDVmmfG3qr3BD7gzH5r?=
 =?us-ascii?Q?602KlQSwK+bXCRGIcnafJZTnkpY+MMIGXsFzEvQ8618vCK4+90gLHpLCFT/p?=
 =?us-ascii?Q?lH5FRCam6++8XieRvQIvjZq6RCjpcjPWsn/WD3aYrsIehglbBMfOMHXCcyI0?=
 =?us-ascii?Q?lDjI5zRfkLhiWn8kK0vhIxfQeTLgNIoh9yQwI5vgqIUgenn+n9giX4jyXqps?=
 =?us-ascii?Q?P89P4X2AieztOCw6HMB2eO507a1a5YX87HLNcmUfCWHmDVkhCay8tZA1Pt6d?=
 =?us-ascii?Q?UjY5taHN696LiBq8cET4BdHq9WSA1zGxYZfF42pD7OHczmP+k7k3V6vwsj2c?=
 =?us-ascii?Q?Pcj0WB3JMlpcHz6yD47uKf9PcCPvpI9G5lLhK/x6feR/W5nAWvoLNm/KGnHa?=
 =?us-ascii?Q?5GDT/Wb9iUhp7+qvFRbXLeK6PXUhXicSBktfJ406xpimDjxCYpaznpiihB6c?=
 =?us-ascii?Q?EHNsxzTdurPB/fO5/EkBMq7dnaXKVE49TqzLG2P38+x2vOl7ShAnNy2MAzl+?=
 =?us-ascii?Q?ReROHULX7VjfSD9Di/wCSn7I+i22P1hEG4ya793k2QXUg6vgBHSadDnofA1Q?=
 =?us-ascii?Q?gTTaQJDRzrz/8b2/9KVmbHf20NymFkEyvL1etD/SNQTFLHEhBZxrV2A/115u?=
 =?us-ascii?Q?iBRkO20iIjAsdpR0GW0W7Kx0b4Wx1p2kpn4j4YmyeYaQCIAVtREK7xiBavnX?=
 =?us-ascii?Q?6TAVxBQL4KnNBBXBbn+CtLcgJCojSjchHU/tCgkPiqYBXbO++8Rvrw8LeoJX?=
 =?us-ascii?Q?CVa2+2fyc3AtqvWrLLiUma4ZboWHRaU+AXxCdVt86pp3lrnJoUtPoiTgzOxw?=
 =?us-ascii?Q?A6b9RdbCAcrqVRUR0UXRfzss9Npe1+fmVUOXpIlN+jCRu3F8KD2pSLg3dWR1?=
 =?us-ascii?Q?n2DQQRciD6UA+XLw4F4hVMkkyF6ZvyLsKtTFAVhXM2PJXYR4Gg/CxOcUdwZZ?=
 =?us-ascii?Q?xTZkz/U4U8npNZTxqsxWtxijSc6WRXyMzhzmUu4c8DbjDzVnkAQQcXiovXFp?=
 =?us-ascii?Q?OB+Mnhk7Fsa7SZjSli3+nDSUftCFTwHhYI6RYq0d5PVG5XZ0w4OYmkONhdWf?=
 =?us-ascii?Q?WgyZxksGK8bJTo+W0XUdW0nGp2B+dDCB56S5ynOYXPgeRdAJA5r3QSjE4SI7?=
 =?us-ascii?Q?kQDad8lg3APW+T06yKAr+4rg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8118.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rOMi0t4+j5Bd1RV6MJfF3HmUfljhSm+7x3GezTohndTkMuWuBfIZs2W9RV5b?=
 =?us-ascii?Q?6P+CH7YQSMt423tj+wo1oow1+QY1sz2hZIt/W6+Opnzjg315fBZF3b/Dxl8M?=
 =?us-ascii?Q?4bgpqgfyrIiRunw4YL+6MNjRj3snxqQwTiCjsaohHPIGEJmUSJ/eMZAVCW8r?=
 =?us-ascii?Q?GlprfrjzPpb/jSdcPlMP7X+zdHwJqcnKFRyG3kp1yg8kV/LJr6RZN5ZQFdZ6?=
 =?us-ascii?Q?gNntGGjWpg84Svz5wYDr8EcQVo/WWehYK/FNb2slSX4mTKS52zp7qw+2R11L?=
 =?us-ascii?Q?CnPNcoUfgzpU4KiYadR1RV+cupFdpENfVOtyg2m2TsIc16dSuYpAIpg8xnrU?=
 =?us-ascii?Q?A/JKAHZyObV2xyOIADz8EUOBcaXAKWe9c1MDesYWH4uA+iEz6QIdCOVYADR4?=
 =?us-ascii?Q?GgdQOvGpCfyDPf83XyuE0H/oF4lBrVEGwRfxdPWQc9E/57CrGxXTsJMQ8/Iv?=
 =?us-ascii?Q?1nOg4xab1I7sBsjN5LuqcUJlMxcxZ/nNRgbLqlcC2pTB0j2/QzL13/LY9ZVa?=
 =?us-ascii?Q?/A0vVbo0CMf/ZWWS0OBh1TV4Yei1XHiK6g2KqVCOyWBnzfyLhiKjtV04pZH/?=
 =?us-ascii?Q?Wh9bv2rVQVHJD0YrQBZoYaTBBQFoIOL9DZ7GJr4cA5g0pEQ/tlj75877P5FF?=
 =?us-ascii?Q?W2CogtX9aHdJnL9KMIIkwhhoaK3e8rtaQ4FKIqfUziiDyEICPfoBsTtGfgc3?=
 =?us-ascii?Q?7cuIrmr4Z3Muu7830gvx2xDkPNyIiZb1+C4UEmoDMeVkx4/jxofMk/rIIlu+?=
 =?us-ascii?Q?AZM3i6NqxQsQIKL4pelvcu0Cg9TFEmP8WnobyLQ6b79jP+oKHILb92w5FXjB?=
 =?us-ascii?Q?GXz6chtU+ndm6/bawSc9ccC1/XmErlZYtvLAbfhPYjfkl9s0AZmdP25VHL9O?=
 =?us-ascii?Q?9ejYk7OnQ02SE2zB0gExtdnIU1GVbBjlt9bdS7KYT2rMMNpAX8xczNwqv3ga?=
 =?us-ascii?Q?TUGjHaaoe1I5FxmaduBmoDwPX849vEhgqGm6MUqICo4zYXNVjWZG3UACXB2H?=
 =?us-ascii?Q?5qBpJ1IubYJ2RKjIjCuUs7XIz2XqpTBlnU6qrMI677xDd3rw6jZMEF9loiQG?=
 =?us-ascii?Q?lu3pmvxUGfQKpiX/+uikmodOdAWWEyaRM9pjE1fB5sOxXLi6MYa172QUB/25?=
 =?us-ascii?Q?IKlm0f/GJUMiFKm1tk9UQ57QCN1hrjk6wgf2bCcP+f6K9JFTuZ6LyuycfvPV?=
 =?us-ascii?Q?fs4uv/JdpfLGXoa58OcKPXdeGNBuumoWUuUYUOH2v44Cr2Ty/E6NAP/SYhRv?=
 =?us-ascii?Q?mu4ZPU5h30hhfkEoHVxTgqfe8r4u3zxAt3F2yhLNs4zbesHwibrzX86FYbBN?=
 =?us-ascii?Q?cVPfV+blMSkJyHO2pzlpcQoUw6xnCK77M19QiqyeYsbX79q+k7k9HBqfD/aE?=
 =?us-ascii?Q?maI4O6Pc4+d00CX0PJ+Qoe83fEoYaAFqDDHgsVOMkE0QcZleOU4PtqWB3J9t?=
 =?us-ascii?Q?esqjv5Phv4FcQq+lSDrCLnYcQ9okB77SWP7I3ms7lOk0wNaOzi76/fkXNnzj?=
 =?us-ascii?Q?Vi8QGm/OYS1jmaLjM3qzwgcH8WnlDwCpxHiCue46TlGYoWjoXlIv9HQecmgX?=
 =?us-ascii?Q?jBmuxHkUvLvzCgZHcRvb+/1gh/1Wtod9agBHhXOOryYOgglddmJL+mkp3bTP?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e7ebc9-730a-49d1-e60e-08dcc7a21c3e
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8118.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 20:43:45.4226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9ti66o6xayYIMmwqIkoCDe/wFquAqE0EFGMjLVXv9C/m+jr23pfml62qv9KUqmSOSX3D8u6taY4IGA4BntU6jMKr9giRtO38hqQUKk8QdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6812
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> Hi everyone,
> 
> Here are some patches to enable SEV-TIO (aka TDISP, aka secure VFIO)
> on AMD Turin.
> 
> The basic idea is to allow DMA to/from encrypted memory of SNP VMs and
> secure MMIO in SNP VMs (i.e. with Cbit set) as well.
> 
> These include both guest and host support. QEMU also requires
> some patches, links below.
> 
> The patches are organized as:
> 01..06 - preparing the host OS;
> 07 - new TSM module;
> 08 - add PSP SEV TIO ABI (IDE should start working at this point);
> 09..14 - add KVM support (TDI binding, MMIO faulting, etc);
> 15..19 - guest changes (the rest of SEV TIO ABI, DMA, secure MMIO).
> 20, 21 - some helpers for guest OS to use encrypted MMIO
> 
> This is based on a merge of
> ee3248f9f8d6 Lukas Wunner spdm: Allow control of next requester nonce
> through sysfs
> 85ef1ac03941 (AMDESE/snp-host-latest) 4 days ago Michael Roth [TEMP] KVM: guest_memfd: Update gmem_prep are hook to handle partially-allocated folios
> 
> 
> Please comment. Thanks.

This cover letter is something I can read after having been in and
around this space for a while, but I wonder how much of it makes sense
to casual reviewers?

> 
> Thanks,
> 
> 
> SEV TIO tree prototype
> ======================
[..]
> Code
> ----
> 
> Written with AMD SEV SNP in mind, TSM is the PSP and
> therefore no much of IDE/TDISP
> is left for the host or guest OS.
> 
> Add a common module to expose various data objects in
> the same way in host and
> guest OS.
> 
> Provide a know on the host to enable IDE encryption.
> 
> Add another version of Guest Request for secure
> guest<->PSP communication.
> 
> Enable secure DMA by:
> - configuring vTOM in a secure DTE via the PSP to cover
> the entire guest RAM;
> - mapping all private memory pages in IOMMU just like
> as they were shared
> (requires hacking iommufd);

What kind of hack are we talking about here? An upstream suitable
change, or something that needs quite a bit more work to be done
properly?

I jumped ahead to read Jason's reaction but please do at least provide a
map the controversy in the cover letter, something like "see patch 12 for
details".

> - skipping various enforcements of non-SME or
> SWIOTLB in the guest;

Is this based on some concept of private vs shared mode devices?

> No mixed share+private DMA supported within the
> same IOMMU.

What does this mean? A device may not have mixed mappings (makes sense),
or an IOMMU can not host devices that do not all agree on whether DMA is
private or shared?

> Enable secure MMIO by:
> - configuring RMP entries via the PSP;
> - adding necessary helpers for mapping MMIO with
> the Cbit set;
> - hacking the KVM #PF handler to allow private
> MMIO failts.
> 
> Based on the latest upstream KVM (at the
> moment it is kvm-coco-queue).

Here is where I lament that kvm-coco-queue is not run like akpm/mm where
it is possible to try out "yesterday's mm". Perhaps this is an area to
collaborate on kvm-coco-queue snapshots to help with testing.

> Workflow
> --------
> 
> 1. Boot host OS.
> 2. "Connect" the physical device.
> 3. Bind a VF to VFIO-PCI.
> 4. Run QEMU _without_ the device yet.
> 5. Hotplug the VF to the VM.
> 6. (if not already) Load the device driver.
> 7. Right after the BusMaster is enabled,
> tsm.ko performs secure DMA and MMIO setup.
> 8. Run tests, for example:
> sudo ./pcimem/pcimem
> /sys/bus/pci/devices/0000\:01\:00.0/resource4_enc
> 0 w*4 0xabcd
> 
> 
> Assumptions
> -----------
> 
> This requires hotpligging into the VM vs
> passing the device via the command line as
> VFIO maps all guest memory as the device init
> step which is too soon as
> SNP LAUNCH UPDATE happens later and will fail
> if VFIO maps private memory before that.

Would the device not just launch in "shared" mode until it is later
converted to private? I am missing the detail of why passing the device
on the command line requires that private memory be mapped early.

That said, the implication that private device assignment requires
hotplug events is a useful property. This matches nicely with initial
thoughts that device conversion events are violent and might as well be
unplug/replug events to match all the assumptions around what needs to
be updated.

> This requires the BME hack as MMIO and

Not sure what the "BME hack" is, I guess this is foreshadowing for later
in this story.

> BusMaster enable bits cannot be 0 after MMIO
> validation is done

It would be useful to call out what is a TDISP requirement, vs
device-specific DSM vs host-specific TSM requirement. In this case I
assume you are referring to PCI 6.2 11.2.6 where it notes that TDIs must
enter the TDISP ERROR state if BME is cleared after the device is
locked?

...but this begs the question of whether it needs to be avoided outright
or handled as an error recovery case dependending on policy.

> the guest OS booting process when this
> appens.
> 
> SVSM could help addressing these (not
> implemented at the moment).

At first though avoiding SVSM entanglements where the kernel can be
enlightened shoud be the policy. I would only expect SVSM hacks to cover
for legacy OSes that will never be TDISP enlightened, but in that case
we are likely talking about fully unaware L2. Lets assume fully
enlightened L1 for now.

> QEMU advertises TEE-IO capability to the VM.
> An additional x-tio flag is added to
> vfio-pci.
> 
> 
> TODOs
> -----
> 
> Deal with PCI reset. Hot unplug+plug? Power
> states too.
> 
> Do better generalization, the current code
> heavily uses SEV TIO defined
> structures in supposedly generic code.
> 
> Fix the documentation comments of SEV TIO structures.

Hey, it's a start. I appreciate the "release early" aspect of this
posting.

> Git trees
> ---------
> 
> https://github.com/AMDESE/linux-kvm/tree/tio
> https://github.com/AMDESE/qemu/tree/tio
[..]
> 
> 
> Alexey Kardashevskiy (21):
>   tsm-report: Rename module to reflect what it does
>   pci/doe: Define protocol types and make those public
>   pci: Define TEE-IO bit in PCIe device capabilities
>   PCI/IDE: Define Integrity and Data Encryption (IDE) extended
>     capability
>   crypto/ccp: Make some SEV helpers public
>   crypto: ccp: Enable SEV-TIO feature in the PSP when supported
>   pci/tdisp: Introduce tsm module
>   crypto/ccp: Implement SEV TIO firmware interface
>   kvm: Export kvm_vm_set_mem_attributes
>   vfio: Export helper to get vfio_device from fd
>   KVM: SEV: Add TIO VMGEXIT and bind TDI
>   KVM: IOMMUFD: MEMFD: Map private pages
>   KVM: X86: Handle private MMIO as shared
>   RFC: iommu/iommufd/amd: Add IOMMU_HWPT_TRUSTED flag, tweak DTE's
>     DomainID, IOTLB
>   coco/sev-guest: Allow multiple source files in the driver
>   coco/sev-guest: Make SEV-to-PSP request helpers public
>   coco/sev-guest: Implement the guest side of things
>   RFC: pci: Add BUS_NOTIFY_PCI_BUS_MASTER event
>   sev-guest: Stop changing encrypted page state for TDISP devices
>   pci: Allow encrypted MMIO mapping via sysfs
>   pci: Define pci_iomap_range_encrypted
> 
>  drivers/crypto/ccp/Makefile                              |    2 +
>  drivers/pci/Makefile                                     |    1 +
>  drivers/virt/coco/Makefile                               |    3 +-
>  drivers/virt/coco/sev-guest/Makefile                     |    1 +
>  arch/x86/include/asm/kvm-x86-ops.h                       |    2 +
>  arch/x86/include/asm/kvm_host.h                          |    2 +
>  arch/x86/include/asm/sev.h                               |   23 +
>  arch/x86/include/uapi/asm/svm.h                          |    2 +
>  arch/x86/kvm/svm/svm.h                                   |    2 +
>  drivers/crypto/ccp/sev-dev-tio.h                         |  105 ++
>  drivers/crypto/ccp/sev-dev.h                             |    4 +
>  drivers/iommu/amd/amd_iommu_types.h                      |    2 +
>  drivers/iommu/iommufd/io_pagetable.h                     |    3 +
>  drivers/iommu/iommufd/iommufd_private.h                  |    4 +
>  drivers/virt/coco/sev-guest/sev-guest.h                  |   56 +
>  include/asm-generic/pci_iomap.h                          |    4 +
>  include/linux/device.h                                   |    5 +
>  include/linux/device/bus.h                               |    3 +
>  include/linux/dma-direct.h                               |    4 +
>  include/linux/iommufd.h                                  |    6 +
>  include/linux/kvm_host.h                                 |   70 +
>  include/linux/pci-doe.h                                  |    4 +
>  include/linux/pci-ide.h                                  |   18 +
>  include/linux/pci.h                                      |    2 +-
>  include/linux/psp-sev.h                                  |  116 +-
>  include/linux/swiotlb.h                                  |    4 +
>  include/linux/tsm-report.h                               |  113 ++
>  include/linux/tsm.h                                      |  337 +++--
>  include/linux/vfio.h                                     |    1 +
>  include/uapi/linux/iommufd.h                             |    1 +
>  include/uapi/linux/kvm.h                                 |   29 +
>  include/uapi/linux/pci_regs.h                            |   77 +-
>  include/uapi/linux/psp-sev.h                             |    4 +-
>  arch/x86/coco/sev/core.c                                 |   11 +
>  arch/x86/kvm/mmu/mmu.c                                   |    6 +-
>  arch/x86/kvm/svm/sev.c                                   |  217 +++
>  arch/x86/kvm/svm/svm.c                                   |    3 +
>  arch/x86/kvm/x86.c                                       |   12 +
>  arch/x86/mm/mem_encrypt.c                                |    5 +
>  arch/x86/virt/svm/sev.c                                  |   23 +-
>  drivers/crypto/ccp/sev-dev-tio.c                         | 1565 ++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev-tsm.c                         |  397 +++++
>  drivers/crypto/ccp/sev-dev.c                             |   87 +-
>  drivers/iommu/amd/iommu.c                                |   20 +-
>  drivers/iommu/iommufd/hw_pagetable.c                     |    4 +
>  drivers/iommu/iommufd/io_pagetable.c                     |    2 +
>  drivers/iommu/iommufd/main.c                             |   21 +
>  drivers/iommu/iommufd/pages.c                            |   94 +-
>  drivers/pci/doe.c                                        |    2 -
>  drivers/pci/ide.c                                        |  186 +++
>  drivers/pci/iomap.c                                      |   24 +
>  drivers/pci/mmap.c                                       |   11 +-
>  drivers/pci/pci-sysfs.c                                  |   27 +-
>  drivers/pci/pci.c                                        |    3 +
>  drivers/pci/proc.c                                       |    2 +-
>  drivers/vfio/vfio_main.c                                 |   13 +
>  drivers/virt/coco/sev-guest/{sev-guest.c => sev_guest.c} |   68 +-
>  drivers/virt/coco/sev-guest/sev_guest_tio.c              |  513 +++++++
>  drivers/virt/coco/tdx-guest/tdx-guest.c                  |    8 +-
>  drivers/virt/coco/tsm-report.c                           |  512 +++++++
>  drivers/virt/coco/tsm.c                                  | 1542 ++++++++++++++-----
>  virt/kvm/guest_memfd.c                                   |   40 +
>  virt/kvm/kvm_main.c                                      |    4 +-
>  virt/kvm/vfio.c                                          |  197 ++-
>  Documentation/virt/coco/tsm.rst                          |   62 +
>  MAINTAINERS                                              |    4 +-
>  arch/x86/kvm/Kconfig                                     |    1 +
>  drivers/pci/Kconfig                                      |    4 +
>  drivers/virt/coco/Kconfig                                |   11 +
>  69 files changed, 6163 insertions(+), 548 deletions(-)
>  create mode 100644 drivers/crypto/ccp/sev-dev-tio.h
>  create mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
>  create mode 100644 include/linux/pci-ide.h
>  create mode 100644 include/linux/tsm-report.h
>  create mode 100644 drivers/crypto/ccp/sev-dev-tio.c
>  create mode 100644 drivers/crypto/ccp/sev-dev-tsm.c
>  create mode 100644 drivers/pci/ide.c
>  rename drivers/virt/coco/sev-guest/{sev-guest.c => sev_guest.c} (96%)
>  create mode 100644 drivers/virt/coco/sev-guest/sev_guest_tio.c
>  create mode 100644 drivers/virt/coco/tsm-report.c
>  create mode 100644 Documentation/virt/coco/tsm.rst
> 
> -- 
> 2.45.2
> 



