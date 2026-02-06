Return-Path: <kvm+bounces-70432-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4IfQCAvBhWnEFwQAu9opvQ
	(envelope-from <kvm+bounces-70432-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 11:23:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B45BFC9A8
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 11:23:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B3CFC302292F
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 10:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E908237105E;
	Fri,  6 Feb 2026 10:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k3thIfdE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758033009F6;
	Fri,  6 Feb 2026 10:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770373383; cv=fail; b=QZ7b5HY0jPAHHQeRzF+LFYZ1tVrZYiOeWG+mAKfJjH3TrdTLBukL9Y7JUozpwuoSGdEDX/6m10aOOoHsLE68WPSnTPTb1jaO6WZnaLc0VUz5NmKV5lOp2Pd4I569KqlDM3rp0F5wHpSQ8S56whJBwcrNicPbn+6Fuv3UQHZxgF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770373383; c=relaxed/simple;
	bh=HhA1QSqK87fwWhgwjz/nv4MFcexnrcuBInbK/C5Bf90=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KnsIyNPPajJrT6jbpKU5OlD5BI5CaoSt2cWOH/uhTeep/Cez+xVkfD2hrYQRGoChMMFhK4N2/uTEVWQmyNsi0iSpHHS1X+EvnHtHbdLbuGNMzYkxZln7tkgwI2mGrdmtZ2P4kN1lDVw37sHEkhsB3rdBocV3gSBJ7zLJI4oFYvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k3thIfdE; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770373382; x=1801909382;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=HhA1QSqK87fwWhgwjz/nv4MFcexnrcuBInbK/C5Bf90=;
  b=k3thIfdEF+PcWBE6W4UD/Wwof8cpV7R6gnVczjoC0bHqOift4rmrX57W
   F2Zn92zNhTGLOBUPRCrMNy1R3OGu2n/Y+0zV5oCvfCSRLMqbzDn3ouV/a
   4Rd7Po94njiqa1maOmlQG1DJp2aa7P9fnwLJw6ARaM4GpLhHoW4Oc/xCn
   h1ikJHUayogBWjyEhnGCEaIjt1f2pqGwANz9wC0ARp2O9O+wEXTwSMbQE
   3rUFuMqsGd2rW7c+sygjIaMFWU8yB704bYKMb5BHDFpfzPAKwKJwxzhPy
   kFAzNXC7iqjDH3aklPYzPhPnDzz+D7k9mqL+9Ni/E0DUfuQIi8dMxWRVx
   Q==;
X-CSE-ConnectionGUID: R52q+maYQRKRbNmpnFx2Zw==
X-CSE-MsgGUID: HHDP3X4NT16HlJL0ty+KAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="71680632"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="71680632"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 02:23:02 -0800
X-CSE-ConnectionGUID: UYgKgq9mS4O29GY3w4ADuQ==
X-CSE-MsgGUID: u07s2tgES6aFMzqzgQL3Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="210728947"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 02:23:02 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 02:23:01 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 02:23:01 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.47) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 02:23:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OKCOfxYbHWlprj6G5QZi70fJo3ew5x2UC8TLWamvILvqp/CUbRBbmT9s6N3c3zZNqoz7jZEbk1Zc4dSEFiaumw3aad1l7fmYAiyGTSlyi3698H13HC2z3dYxb5HKwMJ7qsydsiJ1RGS0EAN0+LL5KdKdKUL211JZ5jysARzDr1boVOnlwnWfms9SKYJvoRn++L0UTavk2dtEIrruV9U6tNrebUkTeLFRHTmapMojLLWv/27YgPJ9LbSeZftQFyw0yAo+QhX24dyBAtKgRE+SSlAuwyP/FH9Cllm9OjA9pdFAO+RTOcnijbTBjMF2PI+42wwCMal8KyGxSrffTRwdbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DArmPCD3T4cw8FJHpYVrDf+pG0YikMrackD0TQ8HQTE=;
 b=AIQUfL25HA9pKJe4kTNR9vO4wtgPU8SmQPf8q2MYbMhvdKh5WyOIWStTN2S/sVXu/hjffFPNvcs9BSkr6rbv5pXpCoZnc4EEK7kzVZg2kNTbgRITXTmz2aSPEyQVGQ440jHINJjQ/4p9zxsk18RUnDEN3wlCdcPPfLk1mEhdhmYgv4uL+w8FTtwMwa8EXpMVS8HcTXA5Xg+/fNUBwdrhjAuJJ4xTJTheBnjDwA5CSBylOgt1mcTIX9EW1M4wZYIlTz//w3VZabG+ANwRLCTlHWX9fuCPENzBnZtakSBi1hqBUrirXDvfu5gowIMjFez2+2c/hJelWTJZSmN7r8XtbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA4PR11MB9420.namprd11.prod.outlook.com (2603:10b6:208:563::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 10:22:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 10:22:58 +0000
Date: Fri, 6 Feb 2026 18:20:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Message-ID: <aYXAdJV8rvWn4EQf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-23-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-23-seanjc@google.com>
X-ClientProxiedBy: TPYP295CA0052.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA4PR11MB9420:EE_
X-MS-Office365-Filtering-Correlation-Id: 69994d9d-3cb7-4f16-eb0a-08de6569b346
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1kkGNgTy/bnZimJoH9dPQYNd971S2Yr7xNCsoVs+DI86KKpo7+hSLzCeBpxU?=
 =?us-ascii?Q?TPEpiZG0f1L45stv9mC//DrNg4Yi5/Q1jRGHSZiL36sh50RDsvtyrzpMOLhs?=
 =?us-ascii?Q?WBlNGH4wiK0VZkvC+k71uV1f27Ok5lwEB66721viZ0w0TIjCncK97w89EYLg?=
 =?us-ascii?Q?bnAmOvTGm7XVtikuOzY34twSHGq4Lk8Z6BQ4JjyhRiEmFiAOcuvKVE3hJbsK?=
 =?us-ascii?Q?7jO7orEiLbPYURcEb8aThP8x+RqhpxM8pgk2WWgplUGtsvVy4E/zj969FLBu?=
 =?us-ascii?Q?SOkKkaENyxAg9BNAJ4JIpOiK/UXCCSGl24+zR11IaMjFao4JIscmNGEPOXPp?=
 =?us-ascii?Q?wD/VgCh1YWtDXw8f9O0Nk9JuZkZsH4Uw+6vdk7G4tK7p6fWEb7oR9aouHR1A?=
 =?us-ascii?Q?yGktIbsMNLSUAQu8Zp2LfPncAeXo8la1sjaUxisRLwrZv2AaOYwooc0ihDv7?=
 =?us-ascii?Q?SnokgLYUZxxbF4PrcBZmBMDnmxkJ8KFzpRI5wa7uPOho3mNGgLkigPqrCAaz?=
 =?us-ascii?Q?D4WglfVNNWEJEEnzQ+aJJKj/o/rQeu13Z9Vbk8XEoO8F7NgwsQkPUi3kbTxs?=
 =?us-ascii?Q?Tuai+Ztor/LLdC0iluflElB8OfYJsbj9TDJ+xXE+5YWTpx1vRXIgxAnXkRtJ?=
 =?us-ascii?Q?90XFLsz2yQcSoy7N1uZDi3890PGe6mznIqoyVvwnydosjBW2dVkEX65yS2MW?=
 =?us-ascii?Q?rRJsg0TiaginveR3H0I06VLCNtxRVOxApEimpWe5rN962ulxJ1frztBEXFhf?=
 =?us-ascii?Q?rY5bFpGB9rsRhEdSr844NRYirSUn1vStSuurWc2H9s6tlgM2NXRs4P/ohIDc?=
 =?us-ascii?Q?BpB5lPNONTCrBAvq99ajwy/HFws1gz3Yl+xVETtwCA9erHnr0icKIgTvyWP7?=
 =?us-ascii?Q?DTMpeEVVqgvz8qdvnxVS68C6MkdBEbT0sBJkw/grEPs1dmHheWCjg9hklT5p?=
 =?us-ascii?Q?qN9ovdsj186Om1RYWYNHqP75WMqS1eQRfagZw6Mtcihujp2fZoLai3nveLN3?=
 =?us-ascii?Q?1T6Ps8WTDiZNT3/ND/POYfRT0uh3ff2zW/9SB40z6ekv8igY0pjztgvOwFt+?=
 =?us-ascii?Q?TdNpekNyyYpKbMXgOxU8ITOuQk6cwumCDIQbxJzCwjp50DT5Zgecfy3SpT07?=
 =?us-ascii?Q?Z61iVsZu9XRPWAN3CxyQX5zCyeLU65/9mU/2jOPCI3ppQuUHLtrOFziI16VK?=
 =?us-ascii?Q?0oUrwiylT3+6T+qqf+2eBpksB067oBKEjh4YhDzAQaJVEAii3UbcimSqBtf3?=
 =?us-ascii?Q?6U61NYYs+30vNOAX046TtqwIzTbCgoek4FrWSc25TRHtS0mMOP3UEh6DA1VY?=
 =?us-ascii?Q?GTtiV7a1VTCcbLP+xgNbCLyLn5QE1R1RWA7XRbDbG/hNdQ99W2/LuREvGK6+?=
 =?us-ascii?Q?pco0sFbAcsLVcNoer2DWmUPlXKsEgDLVv6C1oaa+0ku3Su7WeRp5CNw6BkaC?=
 =?us-ascii?Q?z/WcLcGe+PTzK9L+5wj9lWUF4299IH3UqSU+7HuawEqKJKRQhIHmKE/XDPGS?=
 =?us-ascii?Q?jUSS3c8gK6Gs9D+iNT+xkQkuDUJxhmDvQb2pswyfgWO4o/IUGCeKJQ1OhqhO?=
 =?us-ascii?Q?2s9FSatMdPSr2QOjFUE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K2yx3Pd+5I/Dr7EGbYJ4kfxpmA+5ePDhI0GuaNtonN4TUYXaIenmddv2aJ1E?=
 =?us-ascii?Q?K1dvMj4YLs3TrrevatLcpPaetwixdHiDWd12+ilTVdRM//DtoNgg5ouU6ZqV?=
 =?us-ascii?Q?nkQHGFftcEPA1CXMxcaG1giNBnsvbFqVV/V0nheXfVbCRfr2Z16MJnhhiVqr?=
 =?us-ascii?Q?04yTnOkjgONiJbyBIq66MR7kLQBqGOxbHepvYlttxt5JG3TANhVUcSyhNNeU?=
 =?us-ascii?Q?ZgWp/08c3DTJTDnpFHQcvB0arR7bIp1MSktFE+KZ6wCa0n/XnrpCzDAXBqwn?=
 =?us-ascii?Q?BJgC5sb/Qjafn+VPOlZBG0Qf5HOUo6dFiZd4UKZifg6E/PpI0xSpfYNjf8w6?=
 =?us-ascii?Q?kkPslyiHftJPEF5Hlq+6WioG3c2eeU8VNMCdPSVERF4NYQlJXau1ktLEuM5D?=
 =?us-ascii?Q?Fv0HY1AZKrG3H03KU8mV35ebdKHpWtSHBxA8SzaPVK/pPlyBDXA64iCpypTu?=
 =?us-ascii?Q?Ev8ewFEIfSRkQjDQrNTLZ/BhuYkSwrtI72sMKqI/SdkkGPw4+HreT1ImwiFw?=
 =?us-ascii?Q?XPjkjKHhh9oTTaU1jCsI5NBG7fXpRRuQDjswMjoPY/fET5LZLYVawEgJFqDF?=
 =?us-ascii?Q?xq4GZ+pCgampKWyzbC4M1/ONfrumA5t/hGp+HEYzTl8NaNvseMajoXOUs7qs?=
 =?us-ascii?Q?QhiTSZTM7dSIw3rk2H0NUqvVILJxvM4cAmvWtSa+fiP0uycSK9FPocRj/BL5?=
 =?us-ascii?Q?7Thp/USB0xJ6qx8rA//nUO4H9Tmxx5N7A1N3QRkK8x3c+gX8Il4vT6gcEX1P?=
 =?us-ascii?Q?lkymWWaZf50xltvtQPUYjzmc2yHr+kk1hIW0zWPR/a/SKEG5hlHh2Dar2Vky?=
 =?us-ascii?Q?BKxc7irTk3QW6aAou58cl+2T0W9i3z+gX+2VwYl67076fsnwlKX5te3GxcQj?=
 =?us-ascii?Q?pBPhKq+JxFtihx1i6vXoCXl7Lmj920/lDtb19lDAYoN9ta2CbAPdJ1Gcwz4X?=
 =?us-ascii?Q?AzJ/VlxUzGVdoKX45pvH/+9SbwQz9eSjpDsihWNdHAoShXq0cTA/Ad3mfiE9?=
 =?us-ascii?Q?CWrdo/Vz6MXOogvfo/3H1nFl18oa5t6fekeJQ/gaQzyoHM6QYYYmiBJmNXQu?=
 =?us-ascii?Q?Y7MQyOYioimoOpg/i2jMrLR2p2L5QvqRLHI0WkOL3BRM59Ogjc+4x93qoPEx?=
 =?us-ascii?Q?SSZCAyFbkHgvMn4KhMTSXcWIKzlBNo9SZlzyOxKuzaevzmsnh6w92S1qG9Ss?=
 =?us-ascii?Q?Ncm8HnoXwLV9IqijqM9GoiwqHUlokTrDComYWnAODoNHLoDuYdfwom8TNkm1?=
 =?us-ascii?Q?bCL8rPVVx1M3SuXLiJRcInSwxEfTaTYzbpethfS+4hCXvzFN/0LpuKLkVuwJ?=
 =?us-ascii?Q?XlOHqfdeg8ZxoWE1QfhUzR9uIQGqyPUQijhjWQXXz8bwaMI/ndvTARj4zUlD?=
 =?us-ascii?Q?Eu0iU6ejSRvl5d7Q9axlDyYxGQ3rrHTPWbE8s5CDrX/xF6oEkYKibNHUSQ5V?=
 =?us-ascii?Q?FynhZJWW5wfFQTiwxQrz/xkqEVwi//iCBDlzgC6QISY1skJFSs0eEfD90RnZ?=
 =?us-ascii?Q?1EMFjraVd8uXY3hbIact8tcR0GVt8nBsNgZJ/amkEPoDkGPeIk7v0aQ0eTwM?=
 =?us-ascii?Q?Al87/gKWRBExYxqkZWCJKk02L8HNoLGe6Xlp5GFMJJfyx3Tc0iYdMfjmD0zj?=
 =?us-ascii?Q?BcVf9rSX8eVntO/64OY9fdDTGSWX+Tnv1JS/0y6BsAhZQ6y8J0sVaZ56DXya?=
 =?us-ascii?Q?8uXm51mNA9Y9gqert8ryI7WEydhlgES+GD+l+5W5S/IV59UgHSLYnT/vkcrR?=
 =?us-ascii?Q?J+2Ndesmbw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 69994d9d-3cb7-4f16-eb0a-08de6569b346
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 10:22:58.8276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZOX21TU0tmIX1+2TdiyDk22TcmKSbUNr0DEJeAipaC6WqDeFKIIZZhmpS6TUj8bvqZeF/Wv/uGlToWcgAYXyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9420
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70432-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,yzhao56-desk.sh.intel.com:mid,intel.com:email,intel.com:replyto,intel.com:dkim];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 8B45BFC9A8
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 05:14:54PM -0800, Sean Christopherson wrote:
> From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> 
> Add Dynamic PAMT support to KVM's S-EPT MMU by "getting" a PAMT page when
> adding guest memory (PAGE.ADD or PAGE.AUG), and "putting" the page when
> removing guest memory (PAGE.REMOVE).
> 
> To access the per-vCPU PAMT caches without plumbing @vcpu throughout the
> TDP MMU, begrudginly use kvm_get_running_vcpu() to get the vCPU, and bug
> the VM If KVM attempts to set an S-EPT without an active vCPU.  KVM only
> supports creating _new_ mappings in page (pre)fault paths, all of which
> require an active vCPU.
> 
> The PAMT memory holds metadata for TDX-protected memory. With Dynamic
> PAMT, PAMT_4K is allocated on demand. The kernel supplies the TDX module
> with a few pages that cover 2M of host physical memory.
> 
> PAMT memory can be reclaimed when the last user is gone. It can happen
> in a few code paths:
> 
> - On TDH.PHYMEM.PAGE.RECLAIM in tdx_reclaim_td_control_pages() and
>   tdx_reclaim_page().
> 
> - On TDH.MEM.PAGE.REMOVE in tdx_sept_drop_private_spte().
> 
> - In tdx_sept_zap_private_spte() for pages that were in the queue to be
>   added with TDH.MEM.PAGE.ADD, but it never happened due to an error.
> 
> - In tdx_sept_free_private_spt() for SEPT pages;
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [Minor log tweak]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/mmu/mmu.c             |  4 +++
>  arch/x86/kvm/vmx/tdx.c             | 44 ++++++++++++++++++++++++++----
>  arch/x86/kvm/vmx/tdx.h             |  2 ++
>  5 files changed, 47 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 17dddada69fc..394dc29483a7 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -99,6 +99,7 @@ KVM_X86_OP_OPTIONAL(free_external_sp)
>  KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
>  KVM_X86_OP_OPTIONAL(remove_external_spte)
>  KVM_X86_OP_OPTIONAL(reclaim_external_sp)
> +KVM_X86_OP_OPTIONAL_RET0(topup_external_cache)
>  KVM_X86_OP(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
>  KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6e84dbc89e79..a6e4ab76b1b2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1863,6 +1863,7 @@ struct kvm_x86_ops {
>  				    struct kvm_mmu_page *sp);
>  	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>  				     u64 mirror_spte);
> +	int (*topup_external_cache)(struct kvm_vcpu *vcpu, int min);
>  
>  
>  	bool (*has_wbinvd_exit)(void);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9b5a6861e2a4..4ecbf216d96f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -605,6 +605,10 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  					       PT64_ROOT_MAX_LEVEL);
>  		if (r)
>  			return r;
> +
> +		r = kvm_x86_call(topup_external_cache)(vcpu, PT64_ROOT_MAX_LEVEL);
If this external cache is for PAMT pages allocation for guest pages only, here
the min count should be 1 instead of PT64_ROOT_MAX_LEVEL?


> +		if (r)
> +			return r;
>  	}
>  	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
>  				       PT64_ROOT_MAX_LEVEL);
...
>  void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
> @@ -3614,5 +3641,12 @@ void __init tdx_hardware_setup(void)
>  	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
>  	vt_x86_ops.reclaim_external_sp = tdx_sept_reclaim_private_sp;
>  	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
> +
> +	/*
> +	 * FIXME: Wire up the PAMT hook iff DPAMT is supported, once VMXON is
> +	 *        moved out of KVM and tdx_bringup() is folded into here.
> +	 */
> +	vt_x86_ops.topup_external_cache = tdx_topup_external_pamt_cache;
> +
>  	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
>  }
 

