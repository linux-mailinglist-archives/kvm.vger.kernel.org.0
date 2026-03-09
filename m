Return-Path: <kvm+bounces-73322-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sLG9Jm/ormlRKAIAu9opvQ
	(envelope-from <kvm+bounces-73322-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:34:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B36A23BC0B
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EDB2530B00E4
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE4A3D4100;
	Mon,  9 Mar 2026 15:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DWFJ8K3Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085BF3DA5A8
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773069918; cv=fail; b=HFLOZGMdfTsV+OJ3X9Hpt6ATXPp0VbpUx6NywJVUIoJSnQPXN0Vlef4X0qdaLLMR/rn+Z0RkyHLJu8q24tJowfvHIiTywyhKWJ6qCHZTcG9XGNk4JbRTAy803zRpKJ5znAgrMGnAX7s3ZSNEHc6JGJttgJ/G183lBiOUy+81DUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773069918; c=relaxed/simple;
	bh=fhlDB3P1eHH5mKCKyH0uqjz/DlJvr/XcymXtrg4a8SQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Eve1gkkiBc4cOG6qu7hhI4MeerLXWAfRLpDfJ7Tum8v6L+8+ksWyOnWwZFzt1gIRhfEqZPcMSfDWryGGMzjKskAWuQowfSoiC3BBvj9C5sgc6CE62p4evn1+wtjVFy72P/SDnTer2xhzkJE6cpqEcfa1MVFmeO/9hTpGZIaBQ7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DWFJ8K3Q; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773069916; x=1804605916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=fhlDB3P1eHH5mKCKyH0uqjz/DlJvr/XcymXtrg4a8SQ=;
  b=DWFJ8K3QkTABR4x3DreJKPJclUbJ1AWav+paw3sSfZ9Oxf4cbtRdWovT
   8yhqrN9hRAUPW3PGrr6xBZ896TkhjYv8L4vygPSJDoHVMMAyXgRSj7csR
   aO+fCgUtAOcrXVRKnvi3V1+XrfeBxLQG+16FZ/X1KryiCHpARYJDjgr8L
   e4AH2ftSVgqASEkaRZ1lW0mgIyc5h2mkrYaTXBl2rWF3ovy+K7KGVvy6A
   jks0mbAhpykj3jKml9uaInthW7D6UQWFp25vq9OREyJL2MHqdhXEJVgBo
   5JgBJ3SVoqeelVi0Crq0PgvNiTfD4PliSGCwuospvW4+3RpXt5DY2UkgP
   A==;
X-CSE-ConnectionGUID: m02aT7jLTiClL4h4o0kA4A==
X-CSE-MsgGUID: wXtmB6k6STKI/5diSCGzfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="91479905"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="91479905"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 08:25:15 -0700
X-CSE-ConnectionGUID: rl5RYABpRcittJrx8LrHMg==
X-CSE-MsgGUID: R14PlFXHTQKXN1LwoFqPsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="224721901"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 08:25:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 08:25:13 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 9 Mar 2026 08:25:13 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.25) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 08:25:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IyH0LxN6W23EDTyNxd6quR/X5Sqmr0P0xrs9PKUt8GhUHURz5cNUK/2+/ldvaivDVnXF0n1VkJ0H0w8hi1yBcTifdy1Id8UHf/t1iu8fuNifweyNBObcvAKr2iLSpePP6Z816VWe+KHjVu+/heuZyNKZU5RHOYiNJlxXnOEIrGtW1nzxpX2ZfsXl68+v0MthDm1X7CK8ksBvsSFDf5fH1Oj2lecyyBLx/iBsooYbQrK5qkojQEtNxk32+7BHfyEqIEq5qPTzNUJLL7FgL/fwp0rjKZ3l8mh5W7DN1C4x7/bnz0/+KY25DJVxLJIszXAtOEC36ByL/lWXERJySb/dBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Tv4nWVI6SNWjUJ+ccLOzws6TAd+X/MncYdFNE7s2PY=;
 b=sxMNDeVhfngoIs09X2YtgUI4Xec4M+WjKSzlWDVCa2C3MFdBzsyZjd9g5Ase+6WLGo832hMF1LHe1Kz823bEfO1Oo6Vg6BDZO49CK0LaxvWtpOKt2zB+yVzzrN59G7JFRtsg/UbhKmODpqB6tPqPCYUZXiRFqK5COlDeZGg5pBmslhZaZMkluxXSR4yQLuwfrovxObXpTlVYBZ9aBsASPuEfvo3yWrh1tKENtQK6+f9Ez3ftSrCviFAUrJYtTjAbdTRFhcvpwGxerUVN59Y9u+HnedkwlhHM3YTsNZXuQ7Nr4N8lo4IucMVQGP7Y1N+XeuIkGBSJ7vyJYvBjmFJ8pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6135.namprd11.prod.outlook.com (2603:10b6:208:3c9::9)
 by PH7PR11MB8479.namprd11.prod.outlook.com (2603:10b6:510:30c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.10; Mon, 9 Mar
 2026 15:25:11 +0000
Received: from MN0PR11MB6135.namprd11.prod.outlook.com
 ([fe80::efd5:501b:c890:26b0]) by MN0PR11MB6135.namprd11.prod.outlook.com
 ([fe80::efd5:501b:c890:26b0%6]) with mapi id 15.20.9700.009; Mon, 9 Mar 2026
 15:25:11 +0000
From: =?UTF-8?q?Pi=C3=B3rkowski=2C=20Piotr?= <piotr.piorkowski@intel.com>
To: <intel-xe@lists.freedesktop.org>, <kvm@vger.kernel.org>
CC: =?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>, "Michal
 Wajdeczko" <michal.wajdeczko@intel.com>
Subject: [PATCH v2 1/2] drm/xe/pf: Add FLR_PREPARE state to VF control flow
Date: Mon, 9 Mar 2026 16:24:48 +0100
Message-ID: <20260309152449.910636-2-piotr.piorkowski@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260309152449.910636-1-piotr.piorkowski@intel.com>
References: <20260309152449.910636-1-piotr.piorkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TLZP290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::12) To MN0PR11MB6135.namprd11.prod.outlook.com
 (2603:10b6:208:3c9::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6135:EE_|PH7PR11MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 882aba0c-9f37-4e2b-1092-08de7df00dc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: MT/0M3H474OE7bP4nMNrLeZFgGFXv12KFCNof26lvoBtJfa+7lozAhNKeEej1iQsuo4zpGnfn8beBBTe6daPIO5MYT+e9eagjAG8xghg+CjdQrjmmjGPa47YEBEyufjp+tZMTVuBWSBU3geknlmy3Zx5CGN8taeDEsLVJXrb5XlwuLcH91JRHRB1RSPF3F2hfamojjeQsTb2DNuwq/jPpTCGYynMJFN9thOCAoLntx5Yf9PvTFcPZERN19yBzp0aJlpK4Bi4kxftk6bAuvNG1fI45bZ7ntRPPUlq/oDTl7mK+izC9PFWCE+hX9HX0qyTvckpdETWGgIrkA0eB58kfLvww+JU7uiVKRqjkZSpMEQ3YXAlgdUfAxfFuyfBSkhpBpbbZtbs8rsebFiajEl3gOCWbaYr/8wD4pZgM2+a4Rvgum1dHwpOtbZugNRQwiSuYt+MNrOtHDtqMWdGm0NUa3yt/fIFb0r3VjNzyTOdE2CwMtOWtSPu7V0VglrEw2+O8rtpHnv3mHmk4t92J9QrSG2IrK8xaIoB/PHroD1zHXsH2qrm5p8mcOKKdnYXq0sXyvil1qlFU/5Gvb66JAbysrOOdEm7nOBe71ganwrfocwvXkTSUlXhhJCMfjn+kYxuUK8ox9m4AI/5MgOklRcAEfcMOXLii5DkDFmxator5IQZJvYCn98JqddSOxCwjHFAioISam73zvBiTMV/CylWjj5MG9k9MhmpmZnrjpRi5i0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6135.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkJSbDZROU1zNFZxU3pveDdGZWtTMkNrdXVVYThQZ0FLaVJyZTZpZWpxSzFx?=
 =?utf-8?B?T01wSVl3Nkt6VWZ1U3FjYzVCYXlTdXpWNEpHcHR5NEMrQWRnazdPZXRsRjNZ?=
 =?utf-8?B?Q29BSGpzVTloRUhUaUZPMTJtcXVqYWd4cS9jRlRhSFlKUktKQjFHRW5MdGpz?=
 =?utf-8?B?QTM3NTVxYWd4ZG14L1I2RTJ3bVN2S0ZzclNGSS9tTHBxTFVjZ1loeENPYVp1?=
 =?utf-8?B?cS9sNGhuVUlBZ3E4SmhaeFMrTXdheE8wR0s5emQzTG51aFdtSkRjMlBZd0RF?=
 =?utf-8?B?dmRqcVFOK2l4UklIL1ZFQUZoa2ZIbU5lelcxbXpoa0ZwYmd1SzFoUUE5THda?=
 =?utf-8?B?d0NrbzFyVHJnVnE3ZXEzMCtGM1ZVdmwrM1hRNHdCeVdBT2lkZHQ4QTZHTVRy?=
 =?utf-8?B?azgwTm0yTzdsWG5qQVE5Snhsa2hydS8zWkNPcVk1NklwWW82Q1htM25JTWlB?=
 =?utf-8?B?bFpiL05iL2lpdEUzalZDMFZhUlFxQ1J0VnVNTExsK2NxZTF3eXM0N0ROaFNT?=
 =?utf-8?B?UUlHK3MxUi80STE2cENGaDBlQnBkeElsVnMzeDRzeXJmMVZzUGpLOFh5WTlz?=
 =?utf-8?B?c2p4NERyQUI3NnZIdFpIK0RpZ1RwYmE2bE9PQkRnbWFuWWFIRk9Vb2lubHJW?=
 =?utf-8?B?QlowWmxRd3FuQjRrRG8rK1RYRTMxZXBUdFRIWU9pN3NMek9tWnlwNFZpb29Q?=
 =?utf-8?B?NnFtN1g3OCtmZU9VMmRoajRYNUFTSFFlTTJkN01MY3hOYXZNaW9uYWFNOWt5?=
 =?utf-8?B?VzNqTnV6VWdUZXd2aFBMQUVYZGM2Y2hvMTd2ZkdUQWJycmpnMVdvdFAxM3lM?=
 =?utf-8?B?R0lGbkUwVUtkRXk1VkNWVzExZklSelgzRk92cU5wZEhVRitwRENUdG5ndHJl?=
 =?utf-8?B?SjhRRHRFRVJtZ29LZnh1cmRIa3ZwOS8vRGlDcXY5NWQ2aFR1STdSWEkveXAx?=
 =?utf-8?B?UU1veXBHQnY3TmFTZ3JXdW9NQUhMQ2tJd1hrcktHU0FleVd5YTBmWmpMZHZ1?=
 =?utf-8?B?Y3ZueDhpRHVwMjlJMFNrTXcyV3Qwd0RXa3hjczgxWW8wcXJjSUppT3h6NmxG?=
 =?utf-8?B?bnRzVUEvUEkyWk1uT3lva2g0SmtPVnBJMUJkcEdCSTUwWkg5UUpqK2doTm5n?=
 =?utf-8?B?VldIRG1zeGlIZGRzSnRNdVoyYmxhLzZQMnBQeWVCS3JlRDY3WnRDLzd3K1JI?=
 =?utf-8?B?Y0lmWHpmV1JwTzhNY2JZbHQxRE1PQm40K0dWR2ZhektTU2ZMbkp2aGZhN3dO?=
 =?utf-8?B?Qmo4MHJVUlZjL21haDRrOURDSnYveXB2a1orNVhEUU9mb0RCOG9HNHRLZWQ0?=
 =?utf-8?B?OHViVUlkWVRndlp0TVAvV3BFdjQxZWJ0b2o0TDdRUW43cjhvOGgra1M5WVlO?=
 =?utf-8?B?aUVKVE0xUU5YTzg1clJhcVBOWnpabUVBVXBhNG5vTGkxallNenFKSXRRdzZM?=
 =?utf-8?B?OW40aCtZUmlBalpHdHh2eTFXaldSWWQ1R0xVVTlmNFBKTmx5SndqY3BHN0ZO?=
 =?utf-8?B?dlRUU29meHdOQlc1MkhybHdKZVgzZEtqM2NiUnNzL0U1S2drMUhLT1ROMGFT?=
 =?utf-8?B?QlFUVkxFcDI2L25lQmFDNktwZHJHMjBNdUZzUjU3MFBqNFBVeUwrV04zTURu?=
 =?utf-8?B?NHc5ZTBjQlN1U3RvUEdQZjJCeDVLRjZrcDNVVC9ibncvQ1lvQWYzbTZKNkht?=
 =?utf-8?B?NTFCSHpjY2gzMmVObEJGdUw2L3lDQ0ZPQUZiSFlPQlVxckxDWFVFaUp4Vmp2?=
 =?utf-8?B?TWJMSTgveTJJTFFYZ0JPMmhmeHd4L0t6OUIwUjNLV3pRTlR3YWQ0R2NSTTQw?=
 =?utf-8?B?VlhBekJNanNZdjc0V1NIUXVmNjU1bDRuK2kxRFNvODFtN3UyMzhidTdJL1Aw?=
 =?utf-8?B?VUU3NzFNNE50U2t5bEp1Z2lBdFMvTzdDVDJ4eWRHV3hmamdvV1dzUVRtSnl1?=
 =?utf-8?B?TDlDcDUrOWwrSmJocmhVRWxGNjBDT0xQL2d4Smt6bmo4QkJYVkJ3ZFN3blVp?=
 =?utf-8?B?bXg3b250bHNSYi9MSUNZMmlIUnRiV2ZmTTdJWW5IL1gxS29tQjVwMk8waG9G?=
 =?utf-8?B?M1RoRHFlYkczTkFWQUZHYndMRGpOMHJULy9hZWlSK216T3B3eG5QcHdRS3Zj?=
 =?utf-8?B?YVNPTDFhUkpEek15SnlnM05CSUhCb29INWJBb2k2VHZSNGZyT25jMDdOWThI?=
 =?utf-8?B?SUNDTCtIVFNMakJDb3llVHc5WTBMbWhrM2l3T1VHbVFjM25ELzg0aTlwaW8y?=
 =?utf-8?B?aFJ4L1NSVE15bWtSbWFTeEhNcmVFOS85eDlRNGpBNUc3ZFpZdGhWeCs0TGV2?=
 =?utf-8?B?TE5hT3ZYL2NFV2pLM0FxTVZFd24xVnpnMlZUSlA1YkJiQWVhdFR2V0pPNTI5?=
 =?utf-8?Q?z/fMtU6iih/SuHtI=3D?=
X-Exchange-RoutingPolicyChecked: GwcdN+sZ+gdxcTBZtyA0X14MPqZBP7vRwLOtfcd40VkDPs61Yd2VnN+JxGvizatdKELh9OsPmDV4ZkDcAl7hCZhzLdnZnS460VzVabEN0bUaFAZp/jrPG8qp4uOPUkeyubwGkyZkjH1qYdTBjIWhjPbo+f8DZU+LL9y8uhEEALc0taOfguF/32wemvikENC6HxaC/8oE7wdy6MJ4MZPj+j6lkeqp4awcq0F/aw6IcX+aMc+cjYXfsznKJEBb9xlN8oYDVdVxke/kNgRCwzlCKAhumIUC/jI8xPompp8V1c+6Q6kR/tCWqzu7RpMGdNh5DKGn4Fe0Rvg4PtVAaUCiIQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 882aba0c-9f37-4e2b-1092-08de7df00dc2
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6135.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 15:25:11.2863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sd20+vPM8jMnVy9ZzD1SSiu8VbHaZpGml6XjRK+BXOdrU8NxEIG3sgc7+VluNg7E/rEn3UiQFPCY03akN9AugiTZulLfKWG33vi3Fa8A7E4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8479
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 1B36A23BC0B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73322-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[piotr.piorkowski@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.975];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

From: Piotr Piórkowski <piotr.piorkowski@intel.com>

Our xe-vfio-pci component relies on the confirmation from the PF
that VF FLR processing has finished, but due to the notification
latency on the HW/FW side, PF might be unaware yet of the already
triggered VF FLR.

Update VF state machine with new FLR_PREPARE state that indicate
imminent VF FLR notification and treat that as a begin of the FLR
sequence. Also introduce function that xe-vfio-pci should call to
guarantee correct synchronization.

v2: move PREPARE into WIP, update commit msg (Michal)

Signed-off-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Co-developed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c   | 78 +++++++++++++++----
 drivers/gpu/drm/xe/xe_gt_sriov_pf_control.h   |  1 +
 .../gpu/drm/xe/xe_gt_sriov_pf_control_types.h |  2 +
 drivers/gpu/drm/xe/xe_sriov_pf_control.c      | 24 ++++++
 drivers/gpu/drm/xe/xe_sriov_pf_control.h      |  1 +
 drivers/gpu/drm/xe/xe_sriov_vfio.c            |  1 +
 include/drm/intel/xe_sriov_vfio.h             | 11 +++
 7 files changed, 102 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
index 5cb705c7ee7a..058585f063a9 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
@@ -171,6 +171,7 @@ static const char *control_bit_to_string(enum xe_gt_sriov_control_bits bit)
 	case XE_GT_SRIOV_STATE_##_X: return #_X
 	CASE2STR(WIP);
 	CASE2STR(FLR_WIP);
+	CASE2STR(FLR_PREPARE);
 	CASE2STR(FLR_SEND_START);
 	CASE2STR(FLR_WAIT_GUC);
 	CASE2STR(FLR_GUC_DONE);
@@ -1486,11 +1487,15 @@ int xe_gt_sriov_pf_control_stop_vf(struct xe_gt *gt, unsigned int vfid)
  * The VF FLR state machine looks like::
  *
  *	 (READY,PAUSED,STOPPED)<------------<--------------o
- *	    |                                               \
- *	   flr                                               \
- *	    |                                                 \
- *	....V..........................FLR_WIP...........      \
- *	:    \                                          :       \
+ *	    |             |                                 \
+ *	   flr           prepare                             \
+ *	    |             |                                   \
+ *	....V.............V............FLR_WIP...........      \
+ *	:   |             |                             :       \
+ *	:   |    FLR_PREPARE                            :        |
+ *	:   |    /                                      :        |
+ *	:   \   flr                                     :        |
+ *	:    \ /                                        :        |
  *	:     \   o----<----busy                        :        |
  *	:      \ /            /                         :        |
  *	:       FLR_SEND_START---failed----->-----------o--->(FLR_FAILED)<---o
@@ -1539,20 +1544,28 @@ static void pf_enter_vf_flr_send_start(struct xe_gt *gt, unsigned int vfid)
 	pf_queue_vf(gt, vfid);
 }
 
-static void pf_enter_vf_flr_wip(struct xe_gt *gt, unsigned int vfid)
+static bool pf_exit_vf_flr_prepare(struct xe_gt *gt, unsigned int vfid)
 {
-	if (!pf_enter_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_WIP)) {
-		xe_gt_sriov_dbg(gt, "VF%u FLR is already in progress\n", vfid);
-		return;
-	}
+	if (!pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_PREPARE))
+		return false;
 
-	pf_enter_vf_wip(gt, vfid);
 	pf_enter_vf_flr_send_start(gt, vfid);
+	return true;
+}
+
+static bool pf_enter_vf_flr_wip(struct xe_gt *gt, unsigned int vfid)
+{
+	if (!pf_enter_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_WIP))
+		return false;
+
+	pf_enter_vf_wip(gt, vfid);
+	return true;
 }
 
 static void pf_exit_vf_flr_wip(struct xe_gt *gt, unsigned int vfid)
 {
 	if (pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_WIP)) {
+		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_PREPARE);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_SEND_FINISH);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_RESET_MMIO);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_RESET_DATA);
@@ -1760,21 +1773,54 @@ static void pf_enter_vf_flr_guc_done(struct xe_gt *gt, unsigned int vfid)
 }
 
 /**
- * xe_gt_sriov_pf_control_trigger_flr - Start a VF FLR sequence.
+ * xe_gt_sriov_pf_control_prepare_flr() - Notify PF that VF FLR request was issued.
  * @gt: the &xe_gt
  * @vfid: the VF identifier
  *
+ * This is an optional early notification path used to mark pending FLR before
+ * the GuC notifies the PF with a FLR event.
+ *
  * This function is for PF only.
  *
  * Return: 0 on success or a negative error code on failure.
  */
-int xe_gt_sriov_pf_control_trigger_flr(struct xe_gt *gt, unsigned int vfid)
+int xe_gt_sriov_pf_control_prepare_flr(struct xe_gt *gt, unsigned int vfid)
 {
-	pf_enter_vf_flr_wip(gt, vfid);
+	if (!pf_enter_vf_flr_wip(gt, vfid))
+		return -EALREADY;
 
+	pf_enter_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_PREPARE);
 	return 0;
 }
 
+static int pf_begin_vf_flr(struct xe_gt *gt, unsigned int vfid)
+{
+	if (pf_enter_vf_flr_wip(gt, vfid)) {
+		pf_enter_vf_flr_send_start(gt, vfid);
+		return 0;
+	}
+
+	if (pf_exit_vf_flr_prepare(gt, vfid))
+		return 0;
+
+	xe_gt_sriov_dbg(gt, "VF%u FLR is already in progress\n", vfid);
+	return -EALREADY;
+}
+
+/**
+ * xe_gt_sriov_pf_control_trigger_flr - Start a VF FLR sequence.
+ * @gt: the &xe_gt
+ * @vfid: the VF identifier
+ *
+ * This function is for PF only.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_gt_sriov_pf_control_trigger_flr(struct xe_gt *gt, unsigned int vfid)
+{
+	return pf_begin_vf_flr(gt, vfid);
+}
+
 /**
  * xe_gt_sriov_pf_control_sync_flr() - Synchronize on the VF FLR checkpoint.
  * @gt: the &xe_gt
@@ -1879,9 +1925,9 @@ static void pf_handle_vf_flr(struct xe_gt *gt, u32 vfid)
 
 	if (needs_dispatch_flr(xe)) {
 		for_each_gt(gtit, xe, gtid)
-			pf_enter_vf_flr_wip(gtit, vfid);
+			pf_begin_vf_flr(gtit, vfid);
 	} else {
-		pf_enter_vf_flr_wip(gt, vfid);
+		pf_begin_vf_flr(gt, vfid);
 	}
 }
 
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.h
index c36c8767f3ad..23182a5c5fb8 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.h
@@ -27,6 +27,7 @@ int xe_gt_sriov_pf_control_process_restore_data(struct xe_gt *gt, unsigned int v
 int xe_gt_sriov_pf_control_trigger_restore_vf(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_control_finish_restore_vf(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_control_stop_vf(struct xe_gt *gt, unsigned int vfid);
+int xe_gt_sriov_pf_control_prepare_flr(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_control_trigger_flr(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_control_sync_flr(struct xe_gt *gt, unsigned int vfid, bool sync);
 int xe_gt_sriov_pf_control_wait_flr(struct xe_gt *gt, unsigned int vfid);
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
index 6027ba05a7f2..e78c59e08adf 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
@@ -15,6 +15,7 @@
  *
  * @XE_GT_SRIOV_STATE_WIP: indicates that some operations are in progress.
  * @XE_GT_SRIOV_STATE_FLR_WIP: indicates that a VF FLR is in progress.
+ * @XE_GT_SRIOV_STATE_FLR_PREPARE: indicates that the PF received early VF FLR prepare notification.
  * @XE_GT_SRIOV_STATE_FLR_SEND_START: indicates that the PF wants to send a FLR START command.
  * @XE_GT_SRIOV_STATE_FLR_WAIT_GUC: indicates that the PF awaits for a response from the GuC.
  * @XE_GT_SRIOV_STATE_FLR_GUC_DONE: indicates that the PF has received a response from the GuC.
@@ -56,6 +57,7 @@ enum xe_gt_sriov_control_bits {
 	XE_GT_SRIOV_STATE_WIP = 1,
 
 	XE_GT_SRIOV_STATE_FLR_WIP,
+	XE_GT_SRIOV_STATE_FLR_PREPARE,
 	XE_GT_SRIOV_STATE_FLR_SEND_START,
 	XE_GT_SRIOV_STATE_FLR_WAIT_GUC,
 	XE_GT_SRIOV_STATE_FLR_GUC_DONE,
diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_sriov_pf_control.c
index ed4b9820b06e..15b4341d7f12 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_control.c
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_control.c
@@ -123,6 +123,30 @@ int xe_sriov_pf_control_reset_vf(struct xe_device *xe, unsigned int vfid)
 	return result;
 }
 
+/**
+ * xe_sriov_pf_control_prepare_flr() - Notify PF that VF FLR prepare has started.
+ * @xe: the &xe_device
+ * @vfid: the VF identifier
+ *
+ * This function is for PF only.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_pf_control_prepare_flr(struct xe_device *xe, unsigned int vfid)
+{
+	struct xe_gt *gt;
+	unsigned int id;
+	int result = 0;
+	int err;
+
+	for_each_gt(gt, xe, id) {
+		err = xe_gt_sriov_pf_control_prepare_flr(gt, vfid);
+		result = result ? -EUCLEAN : err;
+	}
+
+	return result;
+}
+
 /**
  * xe_sriov_pf_control_wait_flr() - Wait for a VF reset (FLR) to complete.
  * @xe: the &xe_device
diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_control.h b/drivers/gpu/drm/xe/xe_sriov_pf_control.h
index ef9f219b2109..74981a67db88 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_control.h
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_control.h
@@ -12,6 +12,7 @@ int xe_sriov_pf_control_pause_vf(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_resume_vf(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_stop_vf(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_reset_vf(struct xe_device *xe, unsigned int vfid);
+int xe_sriov_pf_control_prepare_flr(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_wait_flr(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_sync_flr(struct xe_device *xe, unsigned int vfid);
 int xe_sriov_pf_control_trigger_save_vf(struct xe_device *xe, unsigned int vfid);
diff --git a/drivers/gpu/drm/xe/xe_sriov_vfio.c b/drivers/gpu/drm/xe/xe_sriov_vfio.c
index 3da81af97b8b..00f96b0976d1 100644
--- a/drivers/gpu/drm/xe/xe_sriov_vfio.c
+++ b/drivers/gpu/drm/xe/xe_sriov_vfio.c
@@ -42,6 +42,7 @@ _type xe_sriov_vfio_##_func(struct xe_device *xe, unsigned int vfid)		\
 EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_##_func, "xe-vfio-pci")
 
 DEFINE_XE_SRIOV_VFIO_FUNCTION(int, wait_flr_done, control_wait_flr);
+DEFINE_XE_SRIOV_VFIO_FUNCTION(int, flr_prepare, control_prepare_flr);
 DEFINE_XE_SRIOV_VFIO_FUNCTION(int, suspend_device, control_pause_vf);
 DEFINE_XE_SRIOV_VFIO_FUNCTION(int, resume_device, control_resume_vf);
 DEFINE_XE_SRIOV_VFIO_FUNCTION(int, stop_copy_enter, control_trigger_save_vf);
diff --git a/include/drm/intel/xe_sriov_vfio.h b/include/drm/intel/xe_sriov_vfio.h
index e9814e8149fd..27c224a70e6f 100644
--- a/include/drm/intel/xe_sriov_vfio.h
+++ b/include/drm/intel/xe_sriov_vfio.h
@@ -27,6 +27,17 @@ struct xe_device *xe_sriov_vfio_get_pf(struct pci_dev *pdev);
  */
 bool xe_sriov_vfio_migration_supported(struct xe_device *xe);
 
+/**
+ * xe_sriov_vfio_flr_prepare() - Notify PF that VF FLR prepare has started.
+ * @xe: the PF &xe_device obtained by calling xe_sriov_vfio_get_pf()
+ * @vfid: the VF identifier (can't be 0)
+ *
+ * This function marks VF FLR as pending before PF receives GuC FLR event.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_vfio_flr_prepare(struct xe_device *xe, unsigned int vfid);
+
 /**
  * xe_sriov_vfio_wait_flr_done() - Wait for VF FLR completion.
  * @xe: the PF &xe_device obtained by calling xe_sriov_vfio_get_pf()
-- 
2.34.1


