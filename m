Return-Path: <kvm+bounces-62674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F86C4A424
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 02:11:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AA673AD488
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 01:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ACEA2F7467;
	Tue, 11 Nov 2025 01:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DIJazy7s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC322E7F2C;
	Tue, 11 Nov 2025 01:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823146; cv=fail; b=s0GVFBG8z4bq/aI/LqMZwW6sE42589WcC7NRDfuw91jFVcdo+F5zkevEUTT52jt8z8zDZ4jYhUuYdPcKFT+BAdgeyrqgQrub/fi2WgEXnbEtX0a9CA6mAnYx9uo4t3nK/+sJOzjuYDxjVtbQ8J+Y6rIXb8FfAz+U1r++34ImM4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823146; c=relaxed/simple;
	bh=yEVTuEFzLYkmOKnhQc/bBQnllvZR73ko6C/D1AlLDgg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=opckXALDO4aGj2g4FvLyOm3fieQHGUJoQ/W1I9SA2LTVR6VY3cbcHxOrTfcdUZZG5XD/S0RNb/DrWGKkM68M7fUuZN4DNF/Bpu6PP/gmV75WAGOean5TnGG25EC0qQwgeH49dOjHduCgS0ddB1MRBec7dBiMj0DgkUmECAOkwJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DIJazy7s; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762823145; x=1794359145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=yEVTuEFzLYkmOKnhQc/bBQnllvZR73ko6C/D1AlLDgg=;
  b=DIJazy7sE5Jts1nKFm7Vy4uJNKr8oHmEeFaTgQ+CUGxtXn7vv4m1xLoG
   ZGC0OqaUazOHvuAbpeXet5OV2e8xbLkmfGlEl4VUmRNBQenJEOP7RhnTf
   xKLaIL7uC6Z5uh2pz+m1ps42f9Rmylg9XP9aG5rXzYEauImCCSGvySqwL
   9oldVNc37iay8yQ+/8z6yCpkFEPsu8wcoygQwcfPDTbqibt2gnmPwvw5f
   FxvQfQ5XDw+CHAQj+2MKi97H7vdnAN1MQNxgJpEcpDAqMkEyHayALammG
   vhu2KH5gmJ+PZZ2tPyZ9beHLWKE29iIgoQkVClsXEySgVnf9X3VtzSbzJ
   Q==;
X-CSE-ConnectionGUID: mq15DUTJTrGgVU4c89DNYg==
X-CSE-MsgGUID: 7IXTO1x6SU6CxV5ZSfrHgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="67486646"
X-IronPort-AV: E=Sophos;i="6.19,295,1754982000"; 
   d="scan'208";a="67486646"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 17:05:44 -0800
X-CSE-ConnectionGUID: Ai3s59fDQ7qF2W7PWgWgpQ==
X-CSE-MsgGUID: v39v0A1VQvStcnq9GTORZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,295,1754982000"; 
   d="scan'208";a="189073392"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 17:05:44 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 17:05:43 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 10 Nov 2025 17:05:43 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.26) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 17:05:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Efb9MT4bXJF62yvxnh6RG9fdZaKS4tSeJyFqcQ7IULgn1t6AEetRO6LDgaQwgXh9yMdo4ItSfJ/y4D3rgRi/sAwTxA6E9fIaQcoStXzAT7X9uO20eVmF6BiNGXkDlOZsxBNpFtzFI4H/JysfVunDyZqJsZE38qeOApw2GDFwbeTiqzVOrquKNBKXNT4E89f8Hh2ev/TqH14FtdsCIr/HR3KRXDmjIEXv8zGqaJzFbxEx7IKLEaot1khFaFVnjqMR37lN7YQAhbJhC1TYU6nNGLVhNbsk4g9RKMvt1UTZw82sVN1jOhRRGj1tuV5x5O/LhKR2q5gbGqaF8m89C+xtjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbrKS7d+nZWZzkjn3o49/8lt/KWKXr7/QEvTn3mmyNw=;
 b=ILOLYe/jWf2YS37qCSBNvS3+FDXT0yzCOCyFceJzIX3XvxG1sWwicQqWd8tDgkzCVZHNoENMYt7kGCbDkTywcR7uMsUbMRB2cFo2/z7RSCAqMv/r/klYFZixNFjmSadedhVhFcj1Dc2r9kDucghMKHdPb3SdzHe3O1RuWUmVj6xghJIz5hJWQd9rjg74kxgMPI27sDi8xWS7jwUnNerIE04/LDUkCT3yLCgyk4hWKGmh4GJIWW6HJGU2Bt/8pdqOIWcTBMxOUgI42H6BFHmCDdifoSHyQWk9FKYBKW5pWUqw/zbqG5aTFeZZPkS+HQg0twffO3S/FjVEXdYo72PNsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 MN0PR11MB6279.namprd11.prod.outlook.com (2603:10b6:208:3c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 01:05:35 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 01:05:35 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>, "Michal
 Wajdeczko" <michal.wajdeczko@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH v5 06/28] drm/xe/pf: Add helpers for migration data packet allocation / free
Date: Tue, 11 Nov 2025 02:04:17 +0100
Message-ID: <20251111010439.347045-7-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111010439.347045-1-michal.winiarski@intel.com>
References: <20251111010439.347045-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: WA2P291CA0033.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1f::13) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|MN0PR11MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: 519bf13f-6038-4559-68e0-08de20be6b74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YXF2d1FnNUVZdHBUTW9laEFqMnZHeEtNWHdIY2tBWDNjSFFjK3JtbW1BaWd1?=
 =?utf-8?B?NFB4ZkZyWTczZ2liTVYzZ1JCVzRJTisrcVBZajI5RmJZRmp2amgxR2xPM0Jm?=
 =?utf-8?B?aHp0VWg0TlhYanl3TFV0T2wrRGpJU2Y1UXNVd0ZhTHdKZ2pCZDNCdW13VlBy?=
 =?utf-8?B?UElhWlpyaEpuZDBPL1Rwb1VBeFJ1M3A0UFhudkt4Y0k2K25IR0NJb0swQXpB?=
 =?utf-8?B?SXhHYXVjZmhDM1docXdNRXJwSU9Ta3hBaGJYdmNadll3RGhQTjYvM0JUOUlv?=
 =?utf-8?B?cFpCWitXeUltZzRHVmR2MnBHZGZHTkVCUmZPR2dYZDlEK2hoTXJrb29aSUdK?=
 =?utf-8?B?WTZqdDNSNmp6emJXNFBjdSt3dmh4eTM0QVh2cnhsWGl5bEJqcHpIRllHZ1R3?=
 =?utf-8?B?Wnc0eTBpZjlTdVJBMk5vQVRYUnREbmVObDI0N24xSmJnMVBiNzkvbDRySTV2?=
 =?utf-8?B?RmNXbDF5eXlIN0JqeDlIOGp5ZktNSkRnV0RXUmFKbkZYb25kRTVuNCtRUWhS?=
 =?utf-8?B?ckFSb0RjN1ZjZDF4bmxiVnQxYm5ad0Y5OFQ1aDYyMFdlaGV4dnFWWTBJWkJH?=
 =?utf-8?B?Q0FOTTZBalA2Z2VrcWUwV0U0eFNjUnpsK2cwSzZsYnpROWVsc0wyenJ6emJ5?=
 =?utf-8?B?R0FxaU5Vek83SHcxemEweFZTNFFOK01jQ3RsaDNzNE9pUXU1dTNtaUhsRDlm?=
 =?utf-8?B?aENrSExJUFhjUUtmUTI0YWtucWwwMHZQQlVKUk9OWWREQXdJMTdTdWRFcW5r?=
 =?utf-8?B?SkFMbE40am8yZFRheEMrY2IxMUt3M2xSVnpFKzlBN3hSd1JSeTNoOEh5V1lX?=
 =?utf-8?B?RVNIQ0Fra012cUtTUElkZG16WnN1bldGK0pZYXpCZGtDUU9naldNL3QrQVMz?=
 =?utf-8?B?ajNneDZYWld6VXNSdVlpam9aWGZodG52UVQ2VmR1bVh5VW0xU2Nlb2Q1c2ZG?=
 =?utf-8?B?dSs3Yldjc056REh6bzFUTUd3ZXlMdjhJUEE5QkZCbmVDT0FxbGlLcDk2bys5?=
 =?utf-8?B?TTNZNVRibHBnOTNVZEc5a2sxYzFhc0ZnOUhhaTVvMlIwMGMxaG9FQlF1cVl4?=
 =?utf-8?B?eGxDN3VGSzNmdE1SM2luZE1oV0ZncXlXZ21TRVR1WlkrbFlBOGJpd0J2Zk92?=
 =?utf-8?B?ZS9ZcVZMN3RBN2podklKNWxoN2NyQXhnaG5tZEcwZ0pDKzRwczgvZW8wUDRT?=
 =?utf-8?B?cXEwaElOV3Nyai9hZ3gvSk0wZGsrMWF3eUlrNG1zZ2hMdkhHZDZhVitVaVhD?=
 =?utf-8?B?U2JTMzMzS3M2bnpEM0tlbFZ4cEtlN0lUdzd6MUtKN1N3SnQ2ejVQaloweXY1?=
 =?utf-8?B?N24rSFAvWnAyUS9hWHhGd0xZdFg2U1ZETncySkZWVklUTUp5V1NwTHlRVmg5?=
 =?utf-8?B?ZXBDR2NIY25TaTFLVGpQckZCemZ3d2FxcCtsS0dZbzZ5YzE0ZUs0OXNYZGpB?=
 =?utf-8?B?OHdjOUs1b3RseWwwSzlnVVFCVHdmamd6V3I5ODM0V2J2enhIS0dZajVYRkxk?=
 =?utf-8?B?NXByem5NS2s2MG1jV2NrT3lPam5JaytsR3UvUzliUEl5MTE3djdpQmcraDho?=
 =?utf-8?B?VXFuQzNjVnJTaTg2OGM1anN5UFhiNUk0SXlSeVFxY3JPYjgvL0FVaEZoS1VT?=
 =?utf-8?B?TXB1VzE3QXgzdWdRdndBZmVPNEVvcjFXem9oWXRLeEdLSFYxRUJiWFVqTjRR?=
 =?utf-8?B?NVVrZW5hckFNN3N0Nkx2TjU5ZFBucFd4Zm91Zi92SlU3ZE5pbG1YellDbDFG?=
 =?utf-8?B?NjNqZVMzU1crNFExbXQ2U2l2UVljcktMVG85a0E4UGwzWDExcEhDSDRpR1Q1?=
 =?utf-8?B?ZVl5ZHdhMDVkV3QwMjYybmVDNDl3cEVlNWZORTdUdGNPTTZRNm1ZM3RtQXVF?=
 =?utf-8?B?cHFzTlNFTmJGNWpQcXF6alJsQlFxMEQ4NXZJNEtKbG1yVVJJMGxrRTJab2Iy?=
 =?utf-8?B?bFlTSlMvelBPOFJzeVlnTjhZNWJmOWc2czN1M0hnL3l2VkR6SmJPbjJ2ZVlG?=
 =?utf-8?Q?r2i2T9WmFJ3Icq08hx1i/mY7yNM9hA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MS9PU1hod3pwb012c2JCUzhRV09wNEthNGlBL05nREhFd3p6Nnc0bFpnVllP?=
 =?utf-8?B?SWNVajdOMjA5T0xnZUxZYS84MC9idGRjYXM4UGZDQittRkJ3T0l3ZkNLZVkz?=
 =?utf-8?B?eEV3eWsvNlBkYTU3UU14N1FrWFRyNzNUQ2FPTkNaZ1RjU0pLYmZUbFAwczR2?=
 =?utf-8?B?aUdveUROcnIzMzdUTmpDQ1N0QnNEM2NHUk1zVXZ0aUYzMkh0d092RWdOSHV5?=
 =?utf-8?B?cWVia1hiM3l0eUExeFN0NUlaZ3plbEI1V0lCbXVxWWdqZGxJd0pqQ3pNTDcz?=
 =?utf-8?B?NUhuQkVydnNpSHlmTUN4QUl6QTNFRGNPTG9yRm1tUSs3VHVzcHZRVDlNakpP?=
 =?utf-8?B?L2I4RzZFUHh5aTUyM1liTitHWDJOVnR2cGxCRVVLSUxhbEdPSjdMUXUwQTF3?=
 =?utf-8?B?RW1McUMrZmRwTi9OdHhWNmtVR254U0lySXBsQlh6aytLdUg4a0VPVEFrMlc2?=
 =?utf-8?B?V29XVGRKY2JNUVdIVGl3Z2g4cTlxS1FkVnhvbWY5dU5IMDBtU0dkMDIrcHhX?=
 =?utf-8?B?dnNnM0wxaENmNVZtZ1FaekUybE91NGVrM1p5c3h4VWxKK2x1RE9xOU5qZ05j?=
 =?utf-8?B?bDZzVGpGeDRrM0ZpaVB5aVEyVlZvWHEyWHBsaU0xa0E4ejBiYUcwRGllU0Iy?=
 =?utf-8?B?NkQ5dUpFWXVXMmlzVHJuWVlUMUFaS25lTENFODZWMitleGt1VnV4VDI5a3pR?=
 =?utf-8?B?S1ZaYjNxMjZKQVRpdno4MmhQMlhmYll1c2w0QkM5UTdOT0twWXV2SnVwcXd4?=
 =?utf-8?B?TkozL1M5OHhiekR5UXh4eUl2UzdoZklicTBaQ0pZZ0VaK21kaWtsOWVtcU05?=
 =?utf-8?B?T1c2NnFuNFltcXFVeHRmUmpQdXlaSXJPRyttM3MvNGpPU0pKRE5FajBHQ3Ir?=
 =?utf-8?B?M0dWUjZWRUhYRGNWYXlSdU5kaW1Gb0tLcW5IdStmQS92NE40WVhCb2ZlMERT?=
 =?utf-8?B?Yi9EYjZVZU9NV2g1cE55MDN4UkdoVkZHcko5OTJaNnh6a0t4T2phVlc2b2Q1?=
 =?utf-8?B?T1JOTVZyejA2UHJtMm5mM0FGVS9aTW9Gb2k4WHV6NU1GSmdqakpiSTZSYnpa?=
 =?utf-8?B?SmJ0ZnJhNHQrMm8veDgvaTdqRVE5QmZDalR5TUtmWlRuTUhYcE9yMzU3Umx4?=
 =?utf-8?B?SEl1dEdpTDZCUXFzSmNzOFJ1T2dJSzhlMHRrSmRqQ2Z0UGNJV1g1aWU3YWl0?=
 =?utf-8?B?NFpybU1xYmlkMThJck04UmdHY29hSHlvWmZseDRMRUJ1NEJqamZWdTlSeGJO?=
 =?utf-8?B?WWY2S1dHckRRakJBcVFTZndqNzRjRzVIV1JXUHJVK1lubEEzVTJ1Y2JWMkVC?=
 =?utf-8?B?QnpSYlFlSWRVd3Vhck5TYXFQRHk5UFl2dmQ4VXpkY3g1SU9oWGwyTnBKWCs3?=
 =?utf-8?B?SC84WGcwNlZaR3czSDRqNmdJVitvdmhwOUdneC9NUnVzT2g5VjVuNjU2SStL?=
 =?utf-8?B?SUR1TCtyZm9aTERrSnpidjVJUmJjV2xCL3JRSEFPUDd5NlF1bWEvUEUxRFJ3?=
 =?utf-8?B?YUdid01ucGl0RjBOYU1UYzh0SHVmVXh0TFYxYVBZay9jUjNId29zbUlsVWxo?=
 =?utf-8?B?clJVQzdGZnk2ZmlVMTVnc0JuRTZTQWgvQ01Idmd5dnVORXkvKzJxak9icjA4?=
 =?utf-8?B?OTVJeXFWRXVSRmYxaGNKMjY5QTgzYXhlMmdNZFZaYjllK2liVWdudXliN1A2?=
 =?utf-8?B?azlvQjVyMGt4YmtzTnhoQnpTdG5iNjBub0hPQW15VTdKVFdaRERrZHJiT0l6?=
 =?utf-8?B?S0tkUjBiQ2R2aEcyM2VNQmppallZbWRKM3hycWF3cVFhblNKdXBRcHJzenU5?=
 =?utf-8?B?bTB6SGFUWEhoOU5ZaFFEbWM1ajc2VFBpSDZYWjl1MVY0NTNvWUlPVlRYWGpB?=
 =?utf-8?B?dysxUmhMLzZDd1dZWWtBVmZ0Wm5Qd2MreU1SR0ZlNkJpWlhvOGgzMzR4S2Nw?=
 =?utf-8?B?SVNaRnV4dThpeXZUczd5TFBMMys5b1psb2txL0F6WkRPaE9pNXorMkU1U2ZE?=
 =?utf-8?B?Ni8xNmNlODZINHlvNGdvQm0reUorQVZuL0ZNWGF6bDRKRFhVdEUxb3FYRUo0?=
 =?utf-8?B?RWlYWlhQRzJLNGRLMzdKazZpampWbS8wZFYyUlFPc2RYbHFrYUV3VGhJMnFE?=
 =?utf-8?B?NkZjNWdNdXE0Tno2QkdGSUFtVS9qY2JUVGx3R2ZzSjFpeXdMS0h4ckVBVHVm?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 519bf13f-6038-4559-68e0-08de20be6b74
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 01:05:35.4436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ohM9Oz0aTa75SYo4diK8Q2peZHw73ijHUB9Aibu1WOh1EgffIoeuhb0kqK7GKSL1mtOzqMLUTyZwJ/eF5F3PbTenwQ0YlyyicTByLvJGuUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6279
X-OriginatorOrg: intel.com

Now that it's possible to free the packets - connect the restore
handling logic with the ring.
The helpers will also be used in upcoming changes that will start
producing migration data packets.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
---
 drivers/gpu/drm/xe/Makefile                   |   1 +
 drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c   |  11 +-
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c |  33 ++++-
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h |   1 +
 drivers/gpu/drm/xe/xe_sriov_packet.c          | 137 ++++++++++++++++++
 drivers/gpu/drm/xe/xe_sriov_packet.h          |  22 +++
 drivers/gpu/drm/xe/xe_sriov_packet_types.h    |  19 +++
 7 files changed, 221 insertions(+), 3 deletions(-)
 create mode 100644 drivers/gpu/drm/xe/xe_sriov_packet.c
 create mode 100644 drivers/gpu/drm/xe/xe_sriov_packet.h

diff --git a/drivers/gpu/drm/xe/Makefile b/drivers/gpu/drm/xe/Makefile
index cb6b30fd8c2d8..e4b273b025d2a 100644
--- a/drivers/gpu/drm/xe/Makefile
+++ b/drivers/gpu/drm/xe/Makefile
@@ -174,6 +174,7 @@ xe-$(CONFIG_PCI_IOV) += \
 	xe_lmtt_2l.o \
 	xe_lmtt_ml.o \
 	xe_pci_sriov.o \
+	xe_sriov_packet.o \
 	xe_sriov_pf.o \
 	xe_sriov_pf_control.o \
 	xe_sriov_pf_debugfs.o \
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
index bea19e7a4d18e..171b2ba0a97dc 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
@@ -18,6 +18,7 @@
 #include "xe_gt_sriov_printk.h"
 #include "xe_guc_ct.h"
 #include "xe_sriov.h"
+#include "xe_sriov_packet.h"
 #include "xe_sriov_packet_types.h"
 #include "xe_sriov_pf_control.h"
 #include "xe_sriov_pf_migration.h"
@@ -853,6 +854,8 @@ int xe_gt_sriov_pf_control_resume_vf(struct xe_gt *gt, unsigned int vfid)
 static void pf_exit_vf_save_wip(struct xe_gt *gt, unsigned int vfid)
 {
 	if (pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_WIP)) {
+		xe_gt_sriov_pf_migration_ring_free(gt, vfid);
+
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_PROCESS_DATA);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_WAIT_DATA);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_DONE);
@@ -1075,6 +1078,8 @@ int xe_gt_sriov_pf_control_finish_save_vf(struct xe_gt *gt, unsigned int vfid)
 static void pf_exit_vf_restore_wip(struct xe_gt *gt, unsigned int vfid)
 {
 	if (pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_RESTORE_WIP)) {
+		xe_gt_sriov_pf_migration_ring_free(gt, vfid);
+
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_RESTORE_PROCESS_DATA);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_RESTORE_WAIT_DATA);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_RESTORE_DATA_DONE);
@@ -1109,6 +1114,8 @@ static int pf_handle_vf_restore_data(struct xe_gt *gt, unsigned int vfid)
 
 	xe_gt_sriov_notice(gt, "Skipping VF%u unknown data type: %d\n", vfid, data->hdr.type);
 
+	xe_sriov_packet_free(data);
+
 	return 0;
 }
 
@@ -1202,8 +1209,10 @@ int xe_gt_sriov_pf_control_restore_data_done(struct xe_gt *gt, unsigned int vfid
  */
 int xe_gt_sriov_pf_control_process_restore_data(struct xe_gt *gt, unsigned int vfid)
 {
-	if (!pf_expect_vf_not_state(gt, vfid, XE_GT_SRIOV_STATE_RESTORE_FAILED))
+	if (!pf_expect_vf_not_state(gt, vfid, XE_GT_SRIOV_STATE_RESTORE_FAILED)) {
+		xe_gt_sriov_pf_migration_ring_free(gt, vfid);
 		return -EIO;
+	}
 
 	pf_exit_vf_restore_wait_data(gt, vfid);
 
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
index 47f1d85341f7f..4e49022810ea5 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
@@ -14,6 +14,7 @@
 #include "xe_guc.h"
 #include "xe_guc_ct.h"
 #include "xe_sriov.h"
+#include "xe_sriov_packet.h"
 #include "xe_sriov_packet_types.h"
 #include "xe_sriov_pf_migration.h"
 
@@ -419,6 +420,25 @@ bool xe_gt_sriov_pf_migration_ring_full(struct xe_gt *gt, unsigned int vfid)
 	return ptr_ring_full(&pf_pick_gt_migration(gt, vfid)->ring);
 }
 
+/**
+ * xe_gt_sriov_pf_migration_ring_free() - Consume and free all data in migration ring
+ * @gt: the &xe_gt
+ * @vfid: the VF identifier
+ */
+void xe_gt_sriov_pf_migration_ring_free(struct xe_gt *gt, unsigned int vfid)
+{
+	struct xe_gt_sriov_migration_data *migration = pf_pick_gt_migration(gt, vfid);
+	struct xe_sriov_packet *data;
+
+	if (ptr_ring_empty(&migration->ring))
+		return;
+
+	xe_gt_sriov_notice(gt, "VF%u unprocessed migration data left in the ring!\n", vfid);
+
+	while ((data = ptr_ring_consume(&migration->ring)))
+		xe_sriov_packet_free(data);
+}
+
 /**
  * xe_gt_sriov_pf_migration_save_produce() - Add VF save data packet to migration ring.
  * @gt: the &xe_gt
@@ -545,8 +565,10 @@ xe_gt_sriov_pf_migration_save_consume(struct xe_gt *gt, unsigned int vfid)
 	data = ptr_ring_consume(&migration->ring);
 	if (data) {
 		ret = xe_gt_sriov_pf_control_process_save_data(gt, vfid);
-		if (ret)
+		if (ret) {
+			xe_sriov_packet_free(data);
 			return ERR_PTR(ret);
+		}
 
 		return data;
 	}
@@ -560,11 +582,18 @@ xe_gt_sriov_pf_migration_save_consume(struct xe_gt *gt, unsigned int vfid)
 	return ERR_PTR(-EAGAIN);
 }
 
+static void destroy_pf_packet(void *ptr)
+{
+	struct xe_sriov_packet *data = ptr;
+
+	xe_sriov_packet_free(data);
+}
+
 static void action_ring_cleanup(void *arg)
 {
 	struct ptr_ring *r = arg;
 
-	ptr_ring_cleanup(r, NULL);
+	ptr_ring_cleanup(r, destroy_pf_packet);
 }
 
 /**
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
index b29d34a835b71..b4c7b5dc9e914 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
@@ -17,6 +17,7 @@ int xe_gt_sriov_pf_migration_restore_guc_state(struct xe_gt *gt, unsigned int vf
 
 bool xe_gt_sriov_pf_migration_ring_empty(struct xe_gt *gt, unsigned int vfid);
 bool xe_gt_sriov_pf_migration_ring_full(struct xe_gt *gt, unsigned int vfid);
+void xe_gt_sriov_pf_migration_ring_free(struct xe_gt *gt, unsigned int vfid);
 
 int xe_gt_sriov_pf_migration_save_produce(struct xe_gt *gt, unsigned int vfid,
 					  struct xe_sriov_packet *data);
diff --git a/drivers/gpu/drm/xe/xe_sriov_packet.c b/drivers/gpu/drm/xe/xe_sriov_packet.c
new file mode 100644
index 0000000000000..1ac7e025e9fd9
--- /dev/null
+++ b/drivers/gpu/drm/xe/xe_sriov_packet.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright © 2025 Intel Corporation
+ */
+
+#include "xe_bo.h"
+#include "xe_device.h"
+#include "xe_printk.h"
+#include "xe_sriov_packet.h"
+#include "xe_sriov_packet_types.h"
+
+static bool pkt_needs_bo(struct xe_sriov_packet *data)
+{
+	return data->hdr.type == XE_SRIOV_PACKET_TYPE_VRAM;
+}
+
+/**
+ * xe_sriov_packet_alloc() - Allocate migration data packet
+ * @xe: the &xe_device
+ *
+ * Only allocates the "outer" structure, without initializing the migration
+ * data backing storage.
+ *
+ * Return: Pointer to &xe_sriov_packet on success,
+ *         NULL in case of error.
+ */
+struct xe_sriov_packet *xe_sriov_packet_alloc(struct xe_device *xe)
+{
+	struct xe_sriov_packet *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	data->xe = xe;
+	data->hdr_remaining = sizeof(data->hdr);
+
+	return data;
+}
+
+/**
+ * xe_sriov_packet_free() - Free migration data packet.
+ * @data: the &xe_sriov_packet
+ */
+void xe_sriov_packet_free(struct xe_sriov_packet *data)
+{
+	if (IS_ERR_OR_NULL(data))
+		return;
+
+	if (pkt_needs_bo(data))
+		xe_bo_unpin_map_no_vm(data->bo);
+	else
+		kvfree(data->buff);
+
+	kfree(data);
+}
+
+static int pkt_init(struct xe_sriov_packet *data)
+{
+	struct xe_gt *gt = xe_device_get_gt(data->xe, data->hdr.gt_id);
+
+	if (!gt)
+		return -EINVAL;
+
+	if (data->hdr.size == 0)
+		return 0;
+
+	if (pkt_needs_bo(data)) {
+		struct xe_bo *bo;
+
+		bo = xe_bo_create_pin_map_novm(data->xe, gt->tile, PAGE_ALIGN(data->hdr.size),
+					       ttm_bo_type_kernel,
+					       XE_BO_FLAG_SYSTEM | XE_BO_FLAG_PINNED, false);
+		if (IS_ERR(bo))
+			return PTR_ERR(bo);
+
+		data->bo = bo;
+		data->vaddr = bo->vmap.vaddr;
+	} else {
+		void *buff = kvzalloc(data->hdr.size, GFP_KERNEL);
+
+		if (!buff)
+			return -ENOMEM;
+
+		data->buff = buff;
+		data->vaddr = buff;
+	}
+
+	return 0;
+}
+
+#define XE_SRIOV_PACKET_SUPPORTED_VERSION 1
+
+/**
+ * xe_sriov_packet_init() - Initialize migration packet header and backing storage.
+ * @data: the &xe_sriov_packet
+ * @tile_id: tile identifier
+ * @gt_id: GT identifier
+ * @type: &xe_sriov_packet_type
+ * @offset: offset of data packet payload (within wider resource)
+ * @size: size of data packet payload
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_packet_init(struct xe_sriov_packet *data, u8 tile_id, u8 gt_id,
+			 enum xe_sriov_packet_type type, loff_t offset, size_t size)
+{
+	data->hdr.version = XE_SRIOV_PACKET_SUPPORTED_VERSION;
+	data->hdr.type = type;
+	data->hdr.tile_id = tile_id;
+	data->hdr.gt_id = gt_id;
+	data->hdr.offset = offset;
+	data->hdr.size = size;
+	data->remaining = size;
+
+	return pkt_init(data);
+}
+
+/**
+ * xe_sriov_packet_init_from_hdr() - Initialize migration packet backing storage based on header.
+ * @data: the &xe_sriov_packet
+ *
+ * Header data is expected to be filled prior to calling this function.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_packet_init_from_hdr(struct xe_sriov_packet *data)
+{
+	xe_assert(data->xe, !data->hdr_remaining);
+
+	if (data->hdr.version != XE_SRIOV_PACKET_SUPPORTED_VERSION)
+		return -EINVAL;
+
+	data->remaining = data->hdr.size;
+
+	return pkt_init(data);
+}
diff --git a/drivers/gpu/drm/xe/xe_sriov_packet.h b/drivers/gpu/drm/xe/xe_sriov_packet.h
new file mode 100644
index 0000000000000..282a35e77fb39
--- /dev/null
+++ b/drivers/gpu/drm/xe/xe_sriov_packet.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2025 Intel Corporation
+ */
+
+#ifndef _XE_SRIOV_PACKET_H_
+#define _XE_SRIOV_PACKET_H_
+
+#include <linux/types.h>
+
+struct xe_device;
+struct xe_sriov_packet;
+enum xe_sriov_packet_type;
+
+struct xe_sriov_packet *xe_sriov_packet_alloc(struct xe_device *xe);
+void xe_sriov_packet_free(struct xe_sriov_packet *data);
+
+int xe_sriov_packet_init(struct xe_sriov_packet *data, u8 tile_id, u8 gt_id,
+			 enum xe_sriov_packet_type, loff_t offset, size_t size);
+int xe_sriov_packet_init_from_hdr(struct xe_sriov_packet *data);
+
+#endif
diff --git a/drivers/gpu/drm/xe/xe_sriov_packet_types.h b/drivers/gpu/drm/xe/xe_sriov_packet_types.h
index e6d097a1cd5c5..3a09623b3f394 100644
--- a/drivers/gpu/drm/xe/xe_sriov_packet_types.h
+++ b/drivers/gpu/drm/xe/xe_sriov_packet_types.h
@@ -8,6 +8,25 @@
 
 #include <linux/types.h>
 
+/**
+ * enum xe_sriov_packet_type - Xe SR-IOV VF migration data packet type
+ * @XE_SRIOV_PACKET_TYPE_DESCRIPTOR: Descriptor with VF device metadata
+ * @XE_SRIOV_PACKET_TYPE_TRAILER: Trailer indicating end-of-stream
+ * @XE_SRIOV_PACKET_TYPE_GGTT: Global GTT migration data
+ * @XE_SRIOV_PACKET_TYPE_MMIO: MMIO registers migration data
+ * @XE_SRIOV_PACKET_TYPE_GUC: GuC firmware migration data
+ * @XE_SRIOV_PACKET_TYPE_VRAM: VRAM migration data
+ */
+enum xe_sriov_packet_type {
+	/* Skipping 0 to catch uninitialized data */
+	XE_SRIOV_PACKET_TYPE_DESCRIPTOR = 1,
+	XE_SRIOV_PACKET_TYPE_TRAILER,
+	XE_SRIOV_PACKET_TYPE_GGTT,
+	XE_SRIOV_PACKET_TYPE_MMIO,
+	XE_SRIOV_PACKET_TYPE_GUC,
+	XE_SRIOV_PACKET_TYPE_VRAM,
+};
+
 /**
  * struct xe_sriov_packet_hdr - Xe SR-IOV VF migration data packet header
  */
-- 
2.51.2


