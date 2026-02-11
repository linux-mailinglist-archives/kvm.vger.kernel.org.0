Return-Path: <kvm+bounces-70832-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCXlKBZSjGmukgAAu9opvQ
	(envelope-from <kvm+bounces-70832-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 10:55:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D4712308C
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 10:55:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C2DBA308EBF4
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 09:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52725366831;
	Wed, 11 Feb 2026 09:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TdzEcXJr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745152F6192;
	Wed, 11 Feb 2026 09:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770803548; cv=fail; b=DG1IqgEu7HR8WjFZkXkqbPOWZ9G4kaJW+9QRsFYP+NHltvibD9TmIZZ4itk+Vg+tEuQip01MuutoCNLdcNgQab85I68toA3GS6YP5m8PFueZPxwfLkGUmkq/z7FumOATPCQxzOM3ySmDsTfKM7rnrnmVIcre03lYdQnujE7veBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770803548; c=relaxed/simple;
	bh=PtZq5jdTQhv/g2FOn45rPR7Bn2tSG9wt9ydaJvXrQ44=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nG6dpj2k+BsMEZLQcjgdA3KnUYyChCnALTlUGpLDfUV9nC7W21vxLV0o7txtNaT7TekcmVY1FG++/KZuDJlogY1m1OaJrMq/26kclHhQFfeLazCZxIoz0lHCQK9X5TddivKAtPylAav09K4ldGO5ebVHXCcsHWxCE7Vi0MXhIHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TdzEcXJr; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770803547; x=1802339547;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=PtZq5jdTQhv/g2FOn45rPR7Bn2tSG9wt9ydaJvXrQ44=;
  b=TdzEcXJrHRAg1K0qcq3gVtbVB3r22f3NkwwuPe0gK3+NYfp0EAPKTirn
   UXeCO4PVIbocdloASHCfwEIgv+7fXn3XUjRjVC6fw9w4lzleTgIkFZDuK
   ucAMFuR5wWZmM+eXkcR9qqMJJ+EbzNYxcSWBID0W55nRYT7vzoE2tuL6E
   JgSfYP/LW/FbxqxiSJY9AWDBxFmnb8P3kkgXQyAli7geqbb0lpc+NNKZe
   Pgjtbg7PN7LOOoBDabniU3j6JKzew/tP4H8aeIlMCnJ1uFB539IdBfSGo
   Jg9WEK2LmASAo2erTatbUx0aIX0Ut0BbFSCgFrfspWK/cnugL/GyrAdaz
   A==;
X-CSE-ConnectionGUID: cd2LOoObQHSRlWAkU5/Qhw==
X-CSE-MsgGUID: DJenMNhBT+K45LLj9muJXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71989895"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71989895"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 01:52:27 -0800
X-CSE-ConnectionGUID: D7CET4PXTVqJEBNXezeXZw==
X-CSE-MsgGUID: 4caGA41HSLKO5lhxMV/lYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="216363376"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 01:52:27 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 01:52:26 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 01:52:26 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.40) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 01:52:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CgUH3VSiqAHrt1Ks4aG9cMTwhZM3lsuPXMKFttlmHGCTA6kIKFtDoEd++lXaxH9bVfaYDRzuO/2eQ30NhKLAoYpTWq37o2Z1FSqpx3WHLFtLuKRb8kw9DHjmn+QvGrjcujhWunT7JSwYHMJcIs5XCxLDidVnoWXA9A6+fQsRflBP9X+YSVJHZGzN9PpfUGCRLHj0fKAhc5snrrBPBVZ6rN2Th4MhHJ10MmUNC9daRwymnLrQtoKbhrQsGMtJ5RNm92sQkR0stcw+DJBySyGk80vkmML39d3C1FOmEDeEjacDPVraDUCHzTHVJTT+430at+mp5fDHqQ0Sba3RXmSD7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICdl9YOZI1+FZ8lblCJijCqO/FUMJY2AA7vjaX3ftmo=;
 b=Jc5BoLqXn6XVxAEHVwH0vqkmd05QqfULNOrpnaxixHF1tr1YvUMiB4syWT2MtHutjVK6DPBdUVC/7z+D0FE+MCszJljoOqudjS3xh17274DRu08xRokP+rZ3rX2T8isD/Xn+MMmj1qlAI2RBu5R17fULP39cm6ikOQCuYHXmxD1RPQIYka1tTnoM82lVAGqIQiI0lOAnmDOfRwNeWf/+neHHrupAlIwjvwgYVNF/MAf/zUBFdexYwaqlgOIZBUH7ltWQ/CIjWoyzb5bcoDe6mp2GuCLZPIiJYsSmcQdCdDcoaichSPKl1EQBr0bvPPrM8beb+ZNbH0VlkbDDuy8egA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7468.namprd11.prod.outlook.com (2603:10b6:806:329::21)
 by MW6PR11MB8309.namprd11.prod.outlook.com (2603:10b6:303:24c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.20; Wed, 11 Feb
 2026 09:52:18 +0000
Received: from SN7PR11MB7468.namprd11.prod.outlook.com
 ([fe80::c17a:b7fa:6361:dbee]) by SN7PR11MB7468.namprd11.prod.outlook.com
 ([fe80::c17a:b7fa:6361:dbee%3]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 09:52:18 +0000
Date: Wed, 11 Feb 2026 17:49:06 +0800
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
Subject: Re: [RFC PATCH v5 37/45] KVM: x86/tdp_mmu: Alloc external_spt page
 for mirror page table splitting
Message-ID: <aYxQkgxu06eCddwT@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-38-seanjc@google.com>
 <aYW9UaK7tePxDuyh@yzhao56-desk.sh.intel.com>
 <aYYSIndbqLdFkaM-@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYYSIndbqLdFkaM-@google.com>
X-ClientProxiedBy: KU0P306CA0059.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:23::12) To DS0PR11MB7457.namprd11.prod.outlook.com
 (2603:10b6:8:140::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7468:EE_|MW6PR11MB8309:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c028ffb-ece5-47cf-d907-08de69533e46
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ICFXzdwS7mFK3STdhV0DogmLDB8m5T9xGdM7Cpr45Wpx+0Hf8mZga0h/LMrm?=
 =?us-ascii?Q?tMHO8TLKLC6200GeyabuzSx3QI0e1BtZVeAvX7yrxFkQ42SEFS98+u3BV/Yd?=
 =?us-ascii?Q?WzCaaHCbPpaHARPLRtwP5MutGL4iaI9025Egc0eKoYwrPaWXHpRK0bAaD231?=
 =?us-ascii?Q?2LB31+O+lQpsfVVvQdqJ2iiFkRau833xP2ASiKj6oekDJr/4sYUBdyT87lfq?=
 =?us-ascii?Q?EHGE7N0FOJsivMRX4/747COjWUs9jDj+JXlot4l194g11XKnYHENvxdsK5Z0?=
 =?us-ascii?Q?syN5wKM7B1I5Xe5/IS48MnPhO56P+AwAzEPc1bX7kk8wnINHzMxcij8urY8m?=
 =?us-ascii?Q?EUnPQD6g+7S9RcRuytuz2buJIsneHRMYhAkTzpputLIaqwblCp0ikLu2vc87?=
 =?us-ascii?Q?GyMz5o745qy+/hO5bEP7rZ5DLOIhI7CwRWGejXJwqAIJCBnrNDKoRPwixSwr?=
 =?us-ascii?Q?7xtemjd7aZY2vpfyFTAc00H3k7CgNpUKRceOXAj3TWWHnfK1siICjOqB/atv?=
 =?us-ascii?Q?7YT7iu9PW59ax8G1Xvv0gHylciN87+ZXu5KV2ftgu2CluxM+Mixce4JKVXlD?=
 =?us-ascii?Q?v6UwfHwSS2G4C88cN9qaUb9X7Y1V0ylrqYpD8wBrldusTFbvB7ODa3xf6m4y?=
 =?us-ascii?Q?u8E2GgvNcnOB84QJRK87Vjk1sgd8J4koNxu996EqNBOYZ96Qhlmk1bv6E2JD?=
 =?us-ascii?Q?zLFbLPU9iwkHt5COGfXnWv0VmK9FCTSEbDuUkWdEc3SK/uHk0mlno6qU4Y7K?=
 =?us-ascii?Q?zlpw293O2ZOSt2UO1ob8mCwmZiOB5a0Z8rmUF4g64r133xUquAnxx4CCD8dM?=
 =?us-ascii?Q?Jmsqnf07GuDwpx7gr1aoQIW6cjPxAxnSYYTYMz2oOTTT4bEJ7YANFE8BaLna?=
 =?us-ascii?Q?V77tK7vYKR6Y5/DSLk+7mcMZOZ220VgGtH0JUj37uGcJcrfH6afb/fNIgeuA?=
 =?us-ascii?Q?MPwNiM+DYqXap2gQCmXJFoyAThTYSBrWKVNOsQ4nbkgrCnGzgBEWCrclxcK5?=
 =?us-ascii?Q?rSM4hsOQpUa+1YI0vNKW6uru2H/8CABsSjEpx10LFUaFW9IGzqPKGtxoRkOR?=
 =?us-ascii?Q?szyqkCFTAUUtUA5JVRLyrFE3AAfYlYe1NGm2vTyv0e/601E812v4KfKyFmq4?=
 =?us-ascii?Q?YPkQ0bp3hWRpMN/E3P/D0ZhkUPzraRtTTnHDcqJ9n42S/7yFOOaRm6HJqDbL?=
 =?us-ascii?Q?8oFXDeRCQL7fq8KxG9G+l/9Zw0kwwouMJUWTtxRi0uVJrfp2qdASpcU5nfyr?=
 =?us-ascii?Q?Mz3Bjh4RePmPyLf14IuauChKHR+SESlh8WKe6zjMKZtlQK1uTAzwSiEsL1fy?=
 =?us-ascii?Q?226Pl8iXRDhHX8C4oBRE24/x0gttjZPMC7kUH4nWbbwLBLZWX+E/H66hk0Gh?=
 =?us-ascii?Q?JtWWr1+KtHQ8nGe5AutnC3XZrnj065uOm7xrvyYJjcSwnwYR1kIjWYNEXtK0?=
 =?us-ascii?Q?hF8dHCHNIhM1SHi4q7d/C6xPpFmbblLNE26bEQL15oVTCXMTQr+V0izXftIz?=
 =?us-ascii?Q?e1nbvCl+0sTQLICDALd19oXYOZojwfQwZSKmr113CicaVxh2rL3+KNQFljxu?=
 =?us-ascii?Q?19/ugU3jc7RFr8i7qRs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7468.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wb0jRWHuahdJuBdEw4OP0nD4W9AkaN8UaDJIKTu3skt4iDsFggwwuTI595w2?=
 =?us-ascii?Q?k3I6Aq4biwSKDpKKYpLr/ztYcnU/w/Pt3g2NjaFQ4UIS1MsFbe+m1A0ySWr1?=
 =?us-ascii?Q?tVbtTEVcGFXI/UY639pQmcqlNFyLwRzgusq/Zzebt9t764McdLDSBorG8Uco?=
 =?us-ascii?Q?7Y5WPwmFHqjurEHBpkNhMO2v5Jq9zEXqUeDDwr4joIMH7ksHGwSXo3miU6pg?=
 =?us-ascii?Q?a17E+864Po/W2tUHH989uSLDJKjEPW4CIi3gpEKpBsT3yoY8bQEQcJ7rBqhv?=
 =?us-ascii?Q?TM66NqVf7TavhP2D6HliO0cBUkaGZykGm5gSFd7GyjmDjZsGWuIFBLg+BqS9?=
 =?us-ascii?Q?nPR/oJV2wRU7zg4GK2pm1NWVXrzDycDr7ub6XE72BdT6Q1g67F/Q+JKt5/n3?=
 =?us-ascii?Q?uvPO+h80ujfnxsaZ9dE7qdDBM7RyIhVILWuDNBI92BBGF6UaP3Pyt7ZqHzoi?=
 =?us-ascii?Q?TOTLLI01InpDsh4VDcLfGqKCrdY09rwx5yjHHWAUj6+SZ6wJwUNOkKc46F3g?=
 =?us-ascii?Q?XvOo1xpJ/vPxHlJPl0avwaJFnmq+uvegquaRkh6YAw0gsvlpwIMsmmi5DMcd?=
 =?us-ascii?Q?KXFcwo20dD7NAWXZ4GRl9vzbzwllhO3PJ0BvbTEZJrfA2QvCst60QFSVYoMw?=
 =?us-ascii?Q?atzYwM2H3NyKpLzHmPw2tGN63NJziNjfxPdlZC4iYdwQOWPE3pcP8y+tWVK4?=
 =?us-ascii?Q?QDtGz0jybqTBpY2zksuzVVa4h9nMkq+NG22nsI6LGlYfNHd4wSTWM5h1kul2?=
 =?us-ascii?Q?JwoUM5elq8WRnywW38LPqSGKReKotzDFBMSsWBzfoE+8UbrrPgxtz3VYBU3L?=
 =?us-ascii?Q?YWp7NcEumKoBjzwkKVr2m+b3RcLhTIs2gdrevtKk3Av491DZjDC0VRkuOqEw?=
 =?us-ascii?Q?tGzI7zR432AKAcqdLrD8ukK2eSRgEpYPPiBEKjkxJcfqKEkshXUNz4iPp++0?=
 =?us-ascii?Q?bBFLVOeVqdks2NGODUF5dQ5WVIzw/5QZCFZ77iXu2yKH+AymYZR6uBH+8B8N?=
 =?us-ascii?Q?TdK6RnmhztIevjp4qRw48Nvb/ZqFhM23DhuQT3p+BlqYPDDfq7eS8sNQwiHJ?=
 =?us-ascii?Q?EVLHnc0exupiIx7Vt0yyE9wa+VfXYOgFVgEo/jedkKRunugJQGo5JdGQQ75S?=
 =?us-ascii?Q?kjuJHArXC//dloPWtGSfk/hAJdiKA3Y0yGUIhj+JlIPNE1OdNoHgjVQJxQU+?=
 =?us-ascii?Q?FfrT8mGLPONvsxzo8fDWRpWB8p+JB0jAogI5Vxmh24SBJpIWjpA3O2Xzylzn?=
 =?us-ascii?Q?HXHOOrzsdxLFNFkQb4L8XXIdw4vW6tA53Hp4imIZYGQ8t++E6Rpx4I5w7C3+?=
 =?us-ascii?Q?UrBfonqEFKOUooayBmVbudwaLOA1Lydqy8eeGF7YHkiouFeE2An6NEPy7qDZ?=
 =?us-ascii?Q?UrwC3f3W5YDszxIo/V/qlFYJsdUeZMSOnLwqyxckdT8hT+JjxQ06gSfa8dQK?=
 =?us-ascii?Q?c4SbH1HUkh7RejmLhr23LbppoYxIexCZ9ZOvTkD+UOAoyOI7Q5EJ0+ydiPVV?=
 =?us-ascii?Q?rwYsceZayS0BuoYa5n+P1iPn9OK/vx5pin4Qd1iEsrySY9jsHs4OpfDAVwul?=
 =?us-ascii?Q?OyVckERqO4hyAN8aL06WIeono/hQ3NTJzC/z3F4qI6LRKKK13219ux9gYjd/?=
 =?us-ascii?Q?+CMOdBOhkKCs/Iq8DZYqsv1fnsiKDvGCD8gIsOJn7PlFATJ+2/5TLc2OIdd+?=
 =?us-ascii?Q?v11P2aMpJKebXtYhH82pHLilOgYeyS8mhEEFjS8NhdAqsZPhAeA9XuzUB61h?=
 =?us-ascii?Q?0xQ06gAP+Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c028ffb-ece5-47cf-d907-08de69533e46
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7457.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 09:52:18.6810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnRsNQ8NOAyBKQxmKZLMw2ECfl8hgOB9bEcIN2Rz4/8/dbItMBsedB3j/Vo38lQ+LMl49a9hssvblQGwlgnp0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8309
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70832-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:replyto,intel.com:dkim];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 48D4712308C
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 08:09:06AM -0800, Sean Christopherson wrote:
> > So, it's incorrect to invoke is_mirror_sptep() which internally contains
> > rcu_dereference(), resulting in "WARNING: suspicious RCU usage".
> 
> Ah, now I see why the previous code pass in a bool.  I don't love passing a bool,
> but passing @iter is outright dangerous, so I guess this?

LGTM.

> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a32192c35099..4d92c0d19d7c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1448,7 +1448,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>  }
>  
>  static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> -                                                      struct tdp_iter *iter)
> +                                                      bool is_mirror_sp)
>  {
>         struct kvm_mmu_page *sp;
>  
> @@ -1460,7 +1460,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>         if (!sp->spt)
>                 goto err_spt;
>  
> -       if (is_mirror_sptep(iter->sptep)) {
> +       if (is_mirror_sp) {
>                 sp->external_spt = (void *)kvm_x86_call(alloc_external_sp)(GFP_KERNEL_ACCOUNT);
>                 if (!sp->external_spt)
>                         goto err_external_spt;
> @@ -1525,6 +1525,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>                                          gfn_t start, gfn_t end,
>                                          int target_level, bool shared)
>  {
> +       const bool is_mirror_root = is_mirror_sp(root);
>         struct kvm_mmu_page *sp = NULL;
>         struct tdp_iter iter;
>  
> @@ -1557,7 +1558,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>                         else
>                                 write_unlock(&kvm->mmu_lock);
>  
> -                       sp = tdp_mmu_alloc_sp_for_split(kvm, &iter);
> +                       sp = tdp_mmu_alloc_sp_for_split(kvm, is_mirror_root);
>  
>                         if (shared)
>                                 read_lock(&kvm->mmu_lock);

