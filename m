Return-Path: <kvm+bounces-20379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A72769144E5
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 10:31:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59EA3286F71
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 08:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545C65380F;
	Mon, 24 Jun 2024 08:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eRhyA2J9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC8D42064;
	Mon, 24 Jun 2024 08:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719217884; cv=fail; b=FK+hSgrPoXoYVNLKjRMvpxxvd9nc9YRnJJ01ZWLYfqGiZ+PXXJn9olizH7RA7yFVa2zUOg/8c2If8v2cTKd2eaOlEYVQULQCTL6EzoONzwREi1uREgjvaeDhv0UeaU45eDjZrOr29lSSOuQs/I9JSzGalNGAQGx1bvWr/nHIxiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719217884; c=relaxed/simple;
	bh=jmohhCMxrbe7fG/cQAD6ioFofdVcZLEYa4TdxK2C/UE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HEzbqblwdPdipohT2ZVK1YZZe1Kd7EekrxrDF5vaOEDAWX5simk+E0cPhNXtqZnAc9zKYogJ0sAz9x5jOP4momW5w45RCg9+REHqAW/fjCBdAUhswB7m97EDwP3ors93JrqzGvSsmrhTEoCTYu28hPIAwnZlQK1NirmKBwT90o4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eRhyA2J9; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719217883; x=1750753883;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=jmohhCMxrbe7fG/cQAD6ioFofdVcZLEYa4TdxK2C/UE=;
  b=eRhyA2J9N5UsOAyNeNCfifjtUOpVdAY3UZWiKDIAEiMMoQPsxnp40Jhr
   NfSsNl7QXG0NfInD4AUCUwTgLh0IzJ4BuD6NZGRY52W7xxcEKQrXyDb82
   VHmZ+Cqio9pQdOikKw27AGGd9USbpHl01raFEfxHP/tiMvzMmBOVSnlxh
   4wvzWic+R0BXj1iZKIkCgsws+pXytkq5ugnY+5EJ6gA8LEx6tEhZyNlDq
   xmysOpeQSNI8253BpKbO78GN3SU7baa7ULw5aaErmAel7bokAVNQcA4Vx
   aGiGwYrW6KAnfoOnfZBCZvBZ398XWAakebDzDI8TkN7k68jTpj+t8JBwO
   A==;
X-CSE-ConnectionGUID: zr+nF85uT26auhYTG2eEaQ==
X-CSE-MsgGUID: ac097W/gTVq73c6ZeweW4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11112"; a="20059482"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="20059482"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 01:31:17 -0700
X-CSE-ConnectionGUID: pY09UakWQXic9t+rT05dvQ==
X-CSE-MsgGUID: B+AwFEfgTx+dFcaA44zP1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="43208607"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jun 2024 01:31:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 01:31:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 01:31:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 24 Jun 2024 01:31:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 01:31:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6YFibXrmVKzndTg6TvPSom/apGh7H7K25akUTAgUDqZsxxpuIWldqH9tMCwVdtHY8AsmQT0KLDZbi2kJhcf1DnybLldp76WTzwUQBgsMzQjyUW1Vu5JhkzGzvsXM1n6Kl8gZj8WEh0lf0/VB3srRFD5+VrFfzvJ2fOooKb02HSJ/nKmUN+Ioxyz7p+l1zBSXdQxfgDkNaCWR8P2pow2rrv4LOLzcdkSZ94Ygi8Z/TqXMRYAb9hr75Bk7Ln1CbWv6XBNacN6mnZePzyu5VN7UJe1wYU2Cx6t1Yg40yfTDJf5nN+PUyzNTyqpSJHvvD3Yjnxjy2ItreVgJ6aYSm/Dhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b6s47bVAcJhyCVsh9XUPDYp+50eaMokNVwiGlrO3/PE=;
 b=Um5yDnGL7/da5z0spLtENe2ZPwmmlJJwNcObJG6sAH8wu/WzsTXCn3SoISMMI31a7jn7bC8uOMfltPyB5V/V7ANl3sODOizc0p5ZNe9CQWnX1k3Qhl+dvf25+62tGAxAvP0MqfAsh00q6QW+d3FZPXDxRNoblXAQZs97kZWqVNRd9pq9VMsQo6rXdcbN7XTq+H/BJMR2go/RIq4eo7wtCL+DD6KQ2xIU3vUSgBsAnPVTrFU27ORpPAE3ZYVA+PoEX+zSPD3yo3aH08/HkbkNOB8bsunQwJWWwLOta6JVkLxAOP+T4liE4PvVB6esSlvyusrEiE+iyaIkvCrni+u5lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8328.namprd11.prod.outlook.com (2603:10b6:806:376::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.28; Mon, 24 Jun
 2024 08:31:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 08:31:11 +0000
Date: Mon, 24 Jun 2024 16:29:59 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Message-ID: <Znkuh/+oeDeIY68f@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
 <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
 <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
X-ClientProxiedBy: SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8328:EE_
X-MS-Office365-Filtering-Correlation-Id: e6641086-5f86-4aa2-e850-08dc942800b8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?W3eIXcBwhjZxeDnWSNI60W3p3XZ+OvSMm8r87IVGJlWQ/8R7ItPA4aIn24?=
 =?iso-8859-1?Q?L+repaXxc1Qu9P3axDpUmNCyL9l33zgMzASSp8PmqiFgf90+RE4hWlnLz4?=
 =?iso-8859-1?Q?KVzJ1EJAq6wrYSaOBCjWVA0DhIDMGmjjYf46tTLKzfM6Q1QsuQhJ8pq4Jn?=
 =?iso-8859-1?Q?y1Mdoo9rV98QNJwd4rlUXJb+oKC0yNv+ReVVjqhBgaN04Tou7yYJAWXbM7?=
 =?iso-8859-1?Q?I1AJbdW/NScjc7jthPRyUVuVVeSfW94NTgmRKGVaPB8QwwhQPNX1AYHF99?=
 =?iso-8859-1?Q?qBvWilIetoHzOIIKoRX/Thk5lJwXaUIsoTzokU9XO+6WEo6xtpuJlhr+2Y?=
 =?iso-8859-1?Q?6wd3+vI5BpwlgUOxFUxhnlcd/1x2gvo9aTBt75WsA6fnNPHw84UVZFV0sg?=
 =?iso-8859-1?Q?ZmqWInU4B0bSiKM3fulZaZIWmmZApNMrksPhjnixXesGR9PomAUq14hvBq?=
 =?iso-8859-1?Q?yqnwi36wQK24HRCpVtxSS9YbJCwHnEoXcvaLnKpZaXjX7isUs0ur5PGB5a?=
 =?iso-8859-1?Q?kH4upo/1WCOoApJDZ9gH1w3pq/Oh4BBG5xmv5tYHYpbm6yKXtJZt5P6dSe?=
 =?iso-8859-1?Q?pH/1AMxfsCP8vfSp6DVbcJ8sAD+laGtukn+13f6uJ0+2n2IzwJTY0RQ3of?=
 =?iso-8859-1?Q?3eJawhbMoXOhZk1UtwENy0sYRM+7xkbz3wfaM7NR6YnW0ELnF+ocNlwYVH?=
 =?iso-8859-1?Q?jygFSWXMvuCVS4+6rzoH56/T9Ekte2Az6RcMzEXL8cI/ZbnmhsmPEBGoAr?=
 =?iso-8859-1?Q?5kuo6dD7avJjV0XF4jW/rXdrk+1tWa7h/qusYAnqV+3b4FqEZzJJmIDfDc?=
 =?iso-8859-1?Q?odCWcL6LFfsDUmOIp4ENfM0I9MSnIW5gu66bekf7S5j994A7h+SRPEp1sI?=
 =?iso-8859-1?Q?LUkITGC1zEQ2ChKUig/0H39SLH3BXEDMUozStVaoPlwYJYXR7DAJT5+ViX?=
 =?iso-8859-1?Q?iMoYdrCbPAqmB/Zo3wG9CuVYRZY81YkyllQbwuJF3mbPwn9mVGA2bN/54c?=
 =?iso-8859-1?Q?hbqCsoBXv9pZ7pPihOpFXJyrx2YsGlJwAVPVZsig3l4ITbGc7P1OVaE8Oc?=
 =?iso-8859-1?Q?CqedaxWSGZiyIpfULrJKqdzmjXQcpYICCWM7Z6JGIJ/CC81YZPl62ePvmT?=
 =?iso-8859-1?Q?noWHb8BmBRWMMvHgiK65V28Q/fMZQCnPRSiRpyVUK3MFHuYy6ZoqxSCFpR?=
 =?iso-8859-1?Q?F+3kGXa8mMlpz9GlyhaVXwK0fTZRvX8/PCqDWd0pfASrr6/l9OUwe6Wtyq?=
 =?iso-8859-1?Q?hUc3JrxaBNDaPdq4KRCMoS8JDmulwAQOFbgRIB/zy03PA9diW2li9yEvne?=
 =?iso-8859-1?Q?MkR5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ie/jPl4rBq0apoDYpVPhjP1hcenSuTN1jVr/jOIgq18T7+5G/bgm4IRtnN?=
 =?iso-8859-1?Q?o51zfyuMKfxMbBDl3tUYu4LQf3WKxp5aKH+47bkQl660813zSXIMkw2RSQ?=
 =?iso-8859-1?Q?TTcsLllMOiQ4/pMdDWgBaCAJhGXJX+t7938/6Ynu3Z322KEW/vkH+Ws/ef?=
 =?iso-8859-1?Q?Uc8WxJULS/0ErYVmba1BK5Mxz6mZbgHHKlKCu2GcIHY7PtXo3VH/WCQ8QF?=
 =?iso-8859-1?Q?yNaKsmHAEb15DxrFjX20l6tOHliDG1jb2VIfTY483v4wzynYZ/bGt4vl+H?=
 =?iso-8859-1?Q?TzH82koa6Sw697iI+7IiPrT/+p9TdGFqgB933z+z69UZYzJdJRx+oXCCNz?=
 =?iso-8859-1?Q?fMnd6kuVA5UI0sJsYEDXx2Ayr7TLPD0aAHtRQFjBfIez52TGx+Z9a6u1dT?=
 =?iso-8859-1?Q?qDBlwpBL7CKFA4Umnz4Jqy4NbbGO2xc152FOtFa1HSCNlkBUM0IeYhp6G5?=
 =?iso-8859-1?Q?BcnkxLs2uNkgFhiSiwZa2V/OG1SoHwu7Qr+uqwQDL+ROgTAqD3IGaWXItX?=
 =?iso-8859-1?Q?/QCqaOyvNCnWWp365Dmn+4ExHMQS/QnLtF2kr2Ls3s3xTsshyhHIKaqjSB?=
 =?iso-8859-1?Q?X0W01+vOA0dp0x+mdHTV7HFgCR3W8Ue8+JQG5QDHV57uLVQJZMoao4skyD?=
 =?iso-8859-1?Q?zQ6LOB5jbVUm59IbujCmFf3FEzCyHePo2c7u2hrG4eSridAYDl77T+rdDt?=
 =?iso-8859-1?Q?BsZ90VAhubzrUHGW75qGC+S4pdaYXRk2K7V28acxnA4DVk4DFa/rdAF4zE?=
 =?iso-8859-1?Q?bNYCQbtYt+UlL48assOn7gwS9mDKdvRbbrZcnwitYL1JAwgedqHRJj+fN1?=
 =?iso-8859-1?Q?e70LeSjs8Unp+0dIOXO8bBCRFV7RhQxKJAT3rH4slBi41MhWupsCr3JVAt?=
 =?iso-8859-1?Q?RAlMk8AYjsSyAsVqtsfiUnd1aZub/JFMNL5SHrF8oB4Shmh2o5xYG2mEAK?=
 =?iso-8859-1?Q?WAf4nbstjX0nOoo1Dv0axVjmMe3rvyX/TQz2uTIQKK2Hb2mm3RAgOYAdKg?=
 =?iso-8859-1?Q?kYKZAbQxuYExrJGxZ9C0unik38nK5BI1eCCpALPE9TJK5L1Wfm4/he0Pxl?=
 =?iso-8859-1?Q?lnJJEC07GrrCNNhMJJJ8lDw3W0STXkrLMpOA/zSozA+CZTcH68kU1mzjFm?=
 =?iso-8859-1?Q?hbGi/+RFUPcX8nz/m6wisU3rJDL6fEAVU7hP3IEvEKg6NOym3ZkV4DJjEB?=
 =?iso-8859-1?Q?oB7iDMibMPm7tUqjh8wOd7c4lIyGwiPZ1/mT+Qeom6zjcX91vOimT+aPGp?=
 =?iso-8859-1?Q?qx0vMXBDu3JjaVE+2hlIZuVAQtMftPxUUKwNCDGtf3/8okeWm9RvRDh7pl?=
 =?iso-8859-1?Q?m+YENtcxOuBgSninYisSs9O+4jwQ1k4Bz7dK7qjTe/jC2sJOLS26SMbg7W?=
 =?iso-8859-1?Q?GDqu4YjKMIeReD1fNGZBbrC2ihIGOk0cxa8Kko91ADJ9kyt4EXmPmu7XOF?=
 =?iso-8859-1?Q?fHmj89zNbY0/NIrykwCOoLr9aAy6j9NeJdeHsYJtX6oimq3GUabhQNq2oZ?=
 =?iso-8859-1?Q?GtFSbVvQNI4UQHCV5o3PfT4DHqKJgQPRY8Q8YTSzydwLpoJtGwKUE6G+/9?=
 =?iso-8859-1?Q?zQ8hwNLv9elJ6a3r4sKX76ZwjfpI70D3jY5x07IwzQtLxJ+lH4rGi/DkNL?=
 =?iso-8859-1?Q?M/umDiXGYw1KTIJ92Tb673AM2JQaBFOa1z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6641086-5f86-4aa2-e850-08dc942800b8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2024 08:31:11.3187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6nJ0TdFUoe94JppG2WcrSfNqaERx7sEUe8JY/pXEVmpacFJ8f9iYbhGasUB3rEkIFw/Apm4sMukLyRvuvX9YIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8328
X-OriginatorOrg: intel.com

On Sat, Jun 22, 2024 at 03:08:22AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2024-06-21 at 15:10 +0800, Yan Zhao wrote:
> > On Wed, Jun 19, 2024 at 03:36:14PM -0700, Rick Edgecombe wrote:
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 630e6b6d4bf2..a1ab67a4f41f 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -37,7 +37,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
> > >          * for zapping and thus puts the TDP MMU's reference to each root,
> > > i.e.
> > >          * ultimately frees all roots.
> > >          */
> > > -       kvm_tdp_mmu_invalidate_all_roots(kvm);
> > > +       kvm_tdp_mmu_invalidate_roots(kvm, KVM_VALID_ROOTS);
> > all roots (mirror + direct) are invalidated here.
> 
> Right.
> > 
> > >         kvm_tdp_mmu_zap_invalidated_roots(kvm);
> > kvm_tdp_mmu_zap_invalidated_roots() will zap invalidated mirror root with
> > mmu_lock held for read, which should trigger KVM_BUG_ON() in
> > __tdp_mmu_set_spte_atomic(), which assumes "atomic zapping don't operate on
> > mirror roots".
> > 
> > But up to now, the KVM_BUG_ON() is not triggered because
> > kvm_mmu_notifier_release() is called earlier than kvm_destroy_vm() (as in
> > below
> > call trace), and kvm_arch_flush_shadow_all() in kvm_mmu_notifier_release() has
> > zapped all mirror SPTEs before kvm_mmu_uninit_vm() called in kvm_destroy_vm().
> > 
> > 
> > kvm_mmu_notifier_release
> >   kvm_flush_shadow_all
> >     kvm_arch_flush_shadow_all
> >       static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
> >       kvm_mmu_zap_all  ==>hold mmu_lock for write
> >         kvm_tdp_mmu_zap_all ==>zap KVM_ALL_ROOTS with mmu_lock held for write
> > 
> > kvm_destroy_vm
> >   kvm_arch_destroy_vm
> >     kvm_mmu_uninit_vm
> >       kvm_mmu_uninit_tdp_mmu
> >         kvm_tdp_mmu_invalidate_roots ==>invalid all KVM_VALID_ROOTS
> >         kvm_tdp_mmu_zap_invalidated_roots ==> zap all roots with mmu_lock held
> > for read
> > 
> > 
> > A question is that kvm_mmu_notifier_release(), as a callback of primary MMU
> > notifier, why does it zap mirrored tdp when all other callbacks are with
> > KVM_FILTER_SHARED?
> > 
> > Could we just zap all KVM_DIRECT_ROOTS (valid | invalid) in
> > kvm_mmu_notifier_release() and move mirrord tdp related stuffs from 
> > kvm_arch_flush_shadow_all() to kvm_mmu_uninit_tdp_mmu(), ensuring mmu_lock is
> > held for write?
> 
> Sigh, thanks for flagging this. I agree it seems weird to free private memory
> from an MMU notifier callback. I also found this old thread where Sean NAKed the
> current approach (free hkid in mmu release):
> https://lore.kernel.org/kvm/ZN+1QHGa6ltpQxZn@google.com/#t
> 
> One challenge is that flush_shadow_all_private() needs to be done before
> kvm_destroy_vcpus(), where it gets into tdx_vcpu_free(). So kvm_mmu_uninit_vm()
> is too late. Perhaps this is why it was shoved into mmu notifier release (which
> happens long before as you noted). Isaku, do you recall any other reasons?
> 
> But static_call_cond(kvm_x86_vm_destroy) happens before kvm_destroy_vcpus, so we
> could maybe actually just do the tdx_mmu_release_hkid() part there. Then drop
> the flush_shadow_all_private x86 op. See the (not thoroughly checked) diff at
> the bottom of this mail.
It looks good to me.

> 
> But most of what is being discussed is in future patches where it starts to get
> into the TDX module interaction. So I wonder if we should drop this patch 17
> from "part 1" and include it with the next series so it can all be considered
> together.
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-
> ops.h
> index 2adf36b74910..3927731aa947 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -23,7 +23,6 @@ KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
>  KVM_X86_OP_OPTIONAL(vm_enable_cap)
>  KVM_X86_OP(vm_init)
> -KVM_X86_OP_OPTIONAL(flush_shadow_all_private)
>  KVM_X86_OP_OPTIONAL(vm_destroy)
>  KVM_X86_OP_OPTIONAL(vm_free)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8a72e5873808..8b2b79b39d0f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1647,7 +1647,6 @@ struct kvm_x86_ops {
>         unsigned int vm_size;
>         int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
>         int (*vm_init)(struct kvm *kvm);
> -       void (*flush_shadow_all_private)(struct kvm *kvm);
>         void (*vm_destroy)(struct kvm *kvm);
>         void (*vm_free)(struct kvm *kvm);
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e1299eb03e63..4deeeac14324 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6446,7 +6446,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>          * lead to use-after-free.
>          */
>         if (tdp_mmu_enabled)
> -               kvm_tdp_mmu_zap_invalidated_roots(kvm);
> +               kvm_tdp_mmu_zap_invalidated_roots(kvm, true);
>  }
>  
>  static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
> @@ -6977,13 +6977,6 @@ static void kvm_mmu_zap_all(struct kvm *kvm)
>  
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> -       /*
> -        * kvm_mmu_zap_all() zaps both private and shared page tables.  Before
> -        * tearing down private page tables, TDX requires some TD resources to
> -        * be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
> -        * kvm_x86_flush_shadow_all_private() for this.
> -        */
> -       static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
>         kvm_mmu_zap_all(kvm);
>  }
>  
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 68dfcdb46ab7..9e8b012aa8cc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -38,7 +38,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>          * ultimately frees all roots.
>          */
>         kvm_tdp_mmu_invalidate_roots(kvm, KVM_VALID_ROOTS);
> -       kvm_tdp_mmu_zap_invalidated_roots(kvm);
> +       kvm_tdp_mmu_zap_invalidated_roots(kvm, false);
>  
>         WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
>         WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
> @@ -1057,7 +1057,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>          * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
>          */
>         lockdep_assert_held_write(&kvm->mmu_lock);
> -       for_each_tdp_mmu_root_yield_safe(kvm, root)
> +       __for_each_tdp_mmu_root_yield_safe(kvm, root, -1, KVM_DIRECT_ROOTS)
nit: update the comment of kvm_tdp_mmu_zap_all() and explain why it's
KVM_DIRECT_ROOTS, not KVM_DIRECT_ROOTS | KVM_INVALID_ROOTS.

>                 tdp_mmu_zap_root(kvm, root, false);
>  }
>  
> @@ -1065,11 +1065,14 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>   * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
>   * zap" completes.
>   */
> -void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
> +void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared)
>  {
>         struct kvm_mmu_page *root;
>  
> -       read_lock(&kvm->mmu_lock);
> +       if (shared)
> +               read_lock(&kvm->mmu_lock);
> +       else
> +               write_lock(&kvm->mmu_lock);
>  
>         for_each_tdp_mmu_root_yield_safe(kvm, root) {
>                 if (!root->tdp_mmu_scheduled_root_to_zap)
> @@ -1087,7 +1090,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>                  * that may be zapped, as such entries are associated with the
>                  * ASID on both VMX and SVM.
>                  */
> -               tdp_mmu_zap_root(kvm, root, true);
> +               tdp_mmu_zap_root(kvm, root, shared);
>  
>                 /*
>                  * The referenced needs to be put *after* zapping the root, as
> @@ -1097,7 +1100,10 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>                 kvm_tdp_mmu_put_root(kvm, root);
>         }
>  
> -       read_unlock(&kvm->mmu_lock);
> +       if (shared)
> +               read_unlock(&kvm->mmu_lock);
> +       else
> +               write_unlock(&kvm->mmu_lock);
>  }
>  
>  /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 56741d31048a..7927fa4a96e0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -68,7 +68,7 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page
> *sp);
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>  void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
>                                   enum kvm_tdp_mmu_root_types root_types);
> -void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
> +void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
>  
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index b6828e35eb17..3f9bfcd3e152 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -98,16 +98,12 @@ static int vt_vm_init(struct kvm *kvm)
>         return vmx_vm_init(kvm);
>  }
>  
> -static void vt_flush_shadow_all_private(struct kvm *kvm)
> -{
> -       if (is_td(kvm))
> -               tdx_mmu_release_hkid(kvm);
> -}
> -
>  static void vt_vm_destroy(struct kvm *kvm)
>  {
> -       if (is_td(kvm))
> +       if (is_td(kvm)) {
> +               tdx_mmu_release_hkid(kvm);
>                 return;
> +       }
>  
>         vmx_vm_destroy(kvm);
>  }
> @@ -980,7 +976,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>         .vm_size = sizeof(struct kvm_vmx),
>         .vm_enable_cap = vt_vm_enable_cap,
>         .vm_init = vt_vm_init,
> -       .flush_shadow_all_private = vt_flush_shadow_all_private,
>         .vm_destroy = vt_vm_destroy,
>         .vm_free = vt_vm_free,
>  
> 

