Return-Path: <kvm+bounces-60796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C216BBFA024
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 06:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5C02C4FAF55
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 04:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA992D97B8;
	Wed, 22 Oct 2025 04:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DMvaJNEl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE27A19F13F;
	Wed, 22 Oct 2025 04:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761108955; cv=fail; b=t0IwUGUVobz734Ss8qYTR6IvfFDitTVLmSuAFML7tbOopMDbiwhdi2NdToj5sZkIVcMnL11C1rAGA2nF8yj7/ICYW6uCrivmeM2hC80hC4g4aErYlrr+KjVJSzeHKwmmGRR5b4iJvpiYq+0Hql7VFG+XUQbqnI4OBqKtjGPeoes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761108955; c=relaxed/simple;
	bh=yV8eI1/W0/93kd6W1AutV+6OucS9l5bXbwMlM0d5tYk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=P9h/Cpkr7DVUr7O1hOXMjSJUGqDmfpz5N1bAqw3rk6ZiaqYESnrQDQS0pX1S0neUiWaxM/PCbGh3i8tSPpqTt8IowfYV42YrocUJHDVDeHiuWfHq4A6CMv7sSzb87Gl7xgx8BWuPISherCZJfbd2rlMDbZPURC+d5vZyILqs/EM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DMvaJNEl; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761108954; x=1792644954;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=yV8eI1/W0/93kd6W1AutV+6OucS9l5bXbwMlM0d5tYk=;
  b=DMvaJNElVtVKz9oBs+FydwhslTq59B+OXvCEinf+NxjteNxpMAJ5chV4
   chqfPd9eygwk/kClqmidCa2nItJK3z2yxAyJbZS0NFG7oP0JjRngGL6iQ
   OhhIdHaFGg7KVZRZWWEIpKqKJMnyqXXQlzk2w5VJIXlRopVdlHF3H7d9Y
   yj8aSp2OJnv23rTptANvj17G0ZDy7CpGyVgCQKGsDbSVrGmLIC8x90pCp
   YqPjwiT2BSMEfmBBYtffiGcQ7820PHv37PmSnqjxWVSEH7cs72kJg/E0J
   8z4xVBIDm88l5j52yRRlEkAPCCHEg8zo6mtYYy/5YHZDsyR7T5QUN5DTO
   Q==;
X-CSE-ConnectionGUID: NsXE7UOzQHOrZzSDLGXdLw==
X-CSE-MsgGUID: 6ZnRf6oTTouiiEvoAbtpiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63342615"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="63342615"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 21:55:53 -0700
X-CSE-ConnectionGUID: raK3MswxRO2D9IvLClB45A==
X-CSE-MsgGUID: OqpW8qU5TeG2H/I2S8Kd+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183346041"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 21:55:53 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 21:55:52 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 21:55:52 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.62) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 21:55:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m/Cx0tZB6XMeruZousUVN3QoHWW0PUuvm3XWMga5PK3gEB1WfuGxQz+OjSblVc/Vig+D77czBQOc/o6ft89oLab75/pzsDRThu842Gnif69K90ala55VbPtHpn3ihdn1b25O2zzOFGERfLLOHVI/+pAUcjCZI6oCTLQZCrzc9SOLe4IxL+zALKoY2ESm1AqecEPKN8bfVlXttjKD5V5iTkiEYLuPxjy6fiNkIrKiygxvtqwg54Hv5PekZyGE1gbVycg45TDTZPJOaQvCs7bqTFhJxFiwQ6eo/Mv7gJJmFohtBEFELsOQpL0WDG8wfV0EYVwhWmRMlUSaYeZzLIXmrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KsYw4eNwDK6NuBzU22r1MIZXsX191wCc0VjBcny+5A=;
 b=cWgNl81yBBpPXxKcoSGC7splZdH9Y51JLUoox27jAjexUFcrj7UzgSwAfF0bdeu4YMFd5RG1TffChqwCkAnFwkFV3N6FBvr+pXAVNmWO3/u2m7PlTVBHtAlI8WBlSEx0dqliz87XGK/5srS0Y9V/bzGOs6BXqcydVK5AZKCT+0V9oQo3Gd31/yICaJIdmFL2e9hk6VVGMUSbfsct9innPVNKn8EEcjGL14IKtAutEgPGK+j1FlRW5WOuNVlOxoY5P9rOMsYY3t8oM77CSCUzuNNNthOa/Fe4pzx8ybSHLlbO+HGRFgGWufzteYe8ZL5crnyJxZc9D7zGUILb4nTmAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN0PR11MB6136.namprd11.prod.outlook.com (2603:10b6:208:3c8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.12; Wed, 22 Oct 2025 04:55:48 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 04:55:48 +0000
Date: Wed, 22 Oct 2025 12:53:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
	<imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A.
 Shutemov" <kas@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-mips@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, Kai Huang
	<kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, Vishal Annapurve
	<vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ackerley Tng <ackerleytng@google.com>, Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v3 04/25] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Message-ID: <aPhjYcOFjL1Z8m2s@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
 <20251017003244.186495-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251017003244.186495-5-seanjc@google.com>
X-ClientProxiedBy: PSBPR02CA0018.apcprd02.prod.outlook.com (2603:1096:301::28)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN0PR11MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ac32bf-f29b-4685-e6dc-08de1127448d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nZbIC+T1bbfWXXqXdRGOQou2D93zkMOB1qb5hOohmJCsXs5qP9SsTBwPxR9k?=
 =?us-ascii?Q?APWaoTKBrsW9Q9Ig3qYy+NZqvNSUt1o8DzQtBQqCWdRQ1+3UI4bzUC0D3xIr?=
 =?us-ascii?Q?8LuskM3Ixi1vjIHfIAii7Nl8EGdrlbnp//kw610CeGu9RsuAQYr2U/Wl2v6X?=
 =?us-ascii?Q?p54oeGp5fyCMgWfCkfLCnjmX3UmeNZzOMYy4HHVDFzdmQRRxjyTwpTGdCKSz?=
 =?us-ascii?Q?M+17fHFVkWUchoRkg8RdwjrvAMd/UI3O0ZJWVRWGr7xaItzfHfUVrMvvKTLP?=
 =?us-ascii?Q?re13Z7JgM9p2zoMFB4hWc0PHSgtqBpcXDP+Q1y3TVEDKnnLbQSZns2JDyvWy?=
 =?us-ascii?Q?hRVpoADZLjhsa04sP4ZrZSbXT7uZNVGVuI2EAAqyuQjpAb1HU9z6CwieGISj?=
 =?us-ascii?Q?dXFRA6aap0xL4BNZkUzbeOqA9fNSq4SmVQr5mUOshX89tKb1ZPU1JYXd2ZyJ?=
 =?us-ascii?Q?arDLfMOFBAdZnHtW0ovYeSd345oAbI02UkUoxGU46DaNRCFvPBGI8GT25LuY?=
 =?us-ascii?Q?M4c3Wl/81Bmu2LEVKYIYZn6uKnrEa1Uty5gX0tcFmiWOyRSk1KaTGl7FoaIh?=
 =?us-ascii?Q?xoV/rrSINxqPQs9KrVFug2ulKEjJ10WhGuoDM0JCNZbHN/rcpKE4uwW1YxRm?=
 =?us-ascii?Q?nFbnvQ4zJAOFeIs9zhRzIF+08a86fZUre0o3ju/dc7g1wQOPxbkIkiG+a5yT?=
 =?us-ascii?Q?kajFw8AMt6v+rx7CsvfUlCV5qGNwMJkKHSw2endW7uHEUsb2GLww7wCca9Yw?=
 =?us-ascii?Q?e55dxb6DKJWG27peQGKGF2hE9rtm+1HPBdUATJXFCiQJGLDLW1wf6Majv9ov?=
 =?us-ascii?Q?dxjTU4BpB+esyT2LSRKPhtQB9VSu/CrJ2t8xkBSpOuZUhUIp/d2DGFLVkh5M?=
 =?us-ascii?Q?8CxdLGX+iKDT2B3evZZjHIML9mHxaTAgkT1Kp7DSLG7n3H9HuDQuYw7lTtJE?=
 =?us-ascii?Q?TJFHqNdldIU4LSrhIuyb/61vD1EXIY9p4zoDctQdjoYInfksNW2KHKhQFpaz?=
 =?us-ascii?Q?kMwVpyAe93CNiGRJC46gsDwDQwlVzoPfDREswMCbPdLXla3hTBQBwTA3DlR0?=
 =?us-ascii?Q?5F4fqj2f0dC/K5pINeA6owxXCNXSKl8/1M8shIuopUvGkE/WtS/KZrtptyK4?=
 =?us-ascii?Q?MSgooljRma1ckBR+X0ANaQQ/d2pvXNy4He4/eVbem4zaslmv7WKzUvIVQ7xa?=
 =?us-ascii?Q?lQ/mHvDcJAZ53oLfol39OKM5Q6APpV9c4Z4LYJLRbtHzGt191Pr78scM65ij?=
 =?us-ascii?Q?TThwuMna7viQ8LQ2DNlTY1x+jrFd6yR/WHRVSQNRzxwDG8puP+hFXJ7U2Jre?=
 =?us-ascii?Q?NT6QRfpV+cJ7oTYyjRgoiwDhYtmY+VO1YmRzVyTj5TGSoJSqpz/rlZDErWd7?=
 =?us-ascii?Q?lSKa3jN7ywAR+P3/vb6LKLvNDFk5ze9TNfMEoPyOwB5Tvd9Im9kiSEvHsBZQ?=
 =?us-ascii?Q?oocw/mIfKPS726H2Ztuo/5OI7Uo6O4AnNvfmA60DdBvksOH0/AGLfg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4GIgj9jvNn/wgozm9vwmPtvJKG2Svixf5gW7Q/eTPHWXfg6F1yRjokXwQwZy?=
 =?us-ascii?Q?bwI5VPuLOjwJTlPU7Dy5OBSo+la0fcrN+5X7o3Kxz0rF5BTerYu7ZTO2jZg7?=
 =?us-ascii?Q?W05J7Ma1+s//ALXgHZv/YeH56Uh/lqbVanCdmlYhjSDU33/Drsvb3TM5YGL3?=
 =?us-ascii?Q?cqTXBe2BQKM9zDKw15g1DpiYka7eO1wC+LaRWqSuxARKaPyxtfqtqmqUc/77?=
 =?us-ascii?Q?Dd+bytLpe98FNx0xxtOPJUyduh2dj4Q4V/Y0Y7UjfXTZH+Hcr9Vc0aXSkZq0?=
 =?us-ascii?Q?16/QRIz3+j4JfSd68CvE/GseKstUh3ypA0sH6lp+dXLCq7HTNE/yyQGU/Wyz?=
 =?us-ascii?Q?ngJVhZN6Azl6+F4Xmqcl0h2YQfCZgVjIUokNwlptVT/Mk639Yra4zgGWlVxp?=
 =?us-ascii?Q?AefTD0XYAATceWCDijepUqwOu2X4CynfCFxlTcW0/fuOti0HPY2KwNOQviWb?=
 =?us-ascii?Q?gdUXs/OeKqYU5y8R89ceG2FfjjB3M9fvU29i7kp3TLmdvVEz2N3KK0pq5fPk?=
 =?us-ascii?Q?3zXwqO73L+Tp6x8rBSWCZEBcv7hmaYJkuMF+fkLc+Hq+sw7L+xVA069nzdwm?=
 =?us-ascii?Q?Z3MCNxSYG1KqwPHQ58lN0OjfUB+M2FDQtsG/i9OH/+5L754PmmnzEs73jjLb?=
 =?us-ascii?Q?zygRoIWx5O9VfSSP4uIUGrWvlPrmact8vwhVCfhVxYTyZy895lhdMZou3p7A?=
 =?us-ascii?Q?1HKZVgCdKVBWpJOKit3kkvPb18MzchZVvJb5LiCqr3mry+b4938WT6PkORlu?=
 =?us-ascii?Q?ex94sILuJjw9E72AYLSFbpLu3nL7q1lukC/hGbdmveu7f6qBjsAo4qzhY2gK?=
 =?us-ascii?Q?7K18BjrqRsFowZQPB0ZLXpYgqATfzzxCJD98umN6UnSEjXF8bU+BS2yw7Rss?=
 =?us-ascii?Q?ib58J4J3v1wjtEIOUzl4Nun0XX0d4J6aDhdO+2pWexxJKjPPSvTaxdzXIbUl?=
 =?us-ascii?Q?aQ5r/9+w6WNJ99OPTqtK8H1s6o+o2rPKCbwxmHDm6mmsk1cCC/4AFIQQJIEk?=
 =?us-ascii?Q?ICKBulMoRNGYFzTWZBAEmFvRt/NusIZUCN0SMB+W++8tjUcCev7phG3uJHth?=
 =?us-ascii?Q?ms935wI0IW9yotjY72e201TVQ6bz4cWedGc6oWDyySLzXyzTau/BqFhJu6ev?=
 =?us-ascii?Q?m98d0cjDwY3ywP9pf8zGExpqNAIJJM6KdlP99ZC+XSPHJVFdNSVBSm/PuOT2?=
 =?us-ascii?Q?tin2iDX+SZvXW09Vsh6A7ekxwG69+Xz6/nHAckq4gDilqkPSlkuW5kaoW8wY?=
 =?us-ascii?Q?L+r5Gs8S1w2bPjFt5C2d1qoZpCGl+rstHmK1x8twbLBP/XYdNKw1r6xlaIVj?=
 =?us-ascii?Q?cufja76wkJjegS3138J+3TGCB0eEsoGsgrv/ri2zEktpvYyfwpvLLBWYTV+X?=
 =?us-ascii?Q?PNjRzkR9pvUmjWMDIWySvDsdoy/3xT35lBfxXSVlORNMlgwVAEnTK1xElC3I?=
 =?us-ascii?Q?5IFpM36ghMuesu0T/DlrASCtYfTQqbkMuksUlBruyPiEXfW3SGSuQLtkZ1At?=
 =?us-ascii?Q?PVx6gPfytqJYnPF9+arRr64r5s4+RvnkXgSNIGKEQdPrbcBOv1ScLJ3pZEaO?=
 =?us-ascii?Q?HMc3f3Bzdkx8pNXsKGRYKZpZHX2J0+oaxyJ5NQRz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ac32bf-f29b-4685-e6dc-08de1127448d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 04:55:48.6811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HYKrAOk29VkfThsSaUOndnntFJgVEN6XwSMpB0FLPrp/0P6TZlshZX07QfpP5el8t7x/NZBuPNZWvs7IZaN4bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6136
X-OriginatorOrg: intel.com

On Thu, Oct 16, 2025 at 05:32:22PM -0700, Sean Christopherson wrote:
> Link: https://lore.kernel.org/all/20250709232103.zwmufocd3l7sqk7y@amd.com

Hi Sean,                                                                         

Will you post [1] to fix the AB-BA deadlock issue for huge page in-place
conversion as well?

Without it, the "WARNING: possible circular locking dependency detected" would
still appear due to

- lock(mapping.invalidate_lock#4) --> lock(&mm->mmap_lock)
  for init mem on non-in-place-conversion guest_memfd
- rlock(&mm->mmap_lock) --> rlock(mapping.invalidate_lock#4)
  for faulting shared pages on in-place-convertion guest_memfd

[1] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/                     
                                                                                 
Thanks                                                                           
Yan 
 

