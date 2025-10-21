Return-Path: <kvm+bounces-60743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDA5BF91F6
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BF4E188E5E6
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503412FB637;
	Tue, 21 Oct 2025 22:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dn8CBlLf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C8C2C21D4;
	Tue, 21 Oct 2025 22:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086630; cv=fail; b=XFzfO9z806Om8Hl7XS4RWLGeWEdXnO0HLdzNFvviNOGO60q7jsXW28JFsbyQuIxQFQobj1PeJ1RSN2jF9fhJkd2qGeFHFVIF0Ta1aFpzzmBceXSzzmaysbULG5ap/418+68g2qkqj0Cp3fkmc3zWIuVngqhfyfiDu887pvnJJZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086630; c=relaxed/simple;
	bh=rqKP7QtDryNlUPDiCynvJey3X0GbPllFVCFgkZvUjzE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KLtEk27Qbx+kvGLDrnPX/GN12lEJiSCg6J6TyhIu2Qed8lULVqOxLOFphLAVpzOaE8EoU+Kl3trIrsA4RrKIMQy1bJDVIcddppfJgtXQt8jrJG7cvORGbLvTBMZr4QXoDAsOmUS7DL35pwebpC/OP15z20cZC9tmtHH8lkzy008=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dn8CBlLf; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761086627; x=1792622627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=rqKP7QtDryNlUPDiCynvJey3X0GbPllFVCFgkZvUjzE=;
  b=dn8CBlLfce/DYNeD8PoMafe9rTPm422CgO/UoDImPj/Z3zEuqOb3k9mu
   UsLwRSip5tou7beEKP09aX5WomZD8aO3mbcMr//RD38Klj20tOIFujcOF
   ZnLrLQ8O80y3f3sw/t/ixXp1pr0WuWZvkkRIQPAjGO56ZPloOB6n+7hIM
   4HceltGb70u2SRdbxSZaZBbCaegcmWEN5wP/qZBDTjkcoZ0BnkDgXPXe+
   e8cqBOQ7ed1w9SJrRVE831P9EReBmyLR+s+P2MmnM3Oqc8MATVRVXABRI
   qTmNjDbPj+5NsISMKkXFqWgSUdWric4uLfC9jhIWYYGLAw+0xsbbHDfgQ
   g==;
X-CSE-ConnectionGUID: v4eei1e3SzKoU1s29ngtDQ==
X-CSE-MsgGUID: vYULi5NMQ1iKjuWlDP0IaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80848929"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="80848929"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 15:43:46 -0700
X-CSE-ConnectionGUID: sfzUujQ6Q6maY5GRjfhHeA==
X-CSE-MsgGUID: HJ/otOkRSE6dkSoQrwAZ4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183738809"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 15:43:46 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 15:43:46 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 15:43:46 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.31)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 15:43:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w6Oxle01B+RYtviUP6VaIHVpPVSOW9ZikIgJX/ltXYFiapbU6W7lzY0n0R3maBcjbSkljy2FNlcRRQNNiQhGe4ZdjIG3WXKP9VKSEMkg96lxf7O8vl9WJ7ZAtTB+YVTWycJ2Q9NgeLxqgzOrOuEk5AhPSRUVZH5M5SeIyaBoYNWOXqRN4gcFTyF3mlFjlZAYwEujW124eE64plssQB9gPHnBqZ5Lg/R3oJptIKyR6mgOyrpByxaG5qWLPuRRgtxgMaTuqNtA4FIHo7QVx6LC9ZKayuYgNgpmQkHDiB0BcsG2AisLmwM8qwiOn1jCpRJ58Tv+pH/CtzR0bcjtYDErbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEhfVMhxx8Mzm5lzz+jMe6/H8udtpz+O/d/9Ar1DKCk=;
 b=qZJAq8ymm5A6tbDYVRKhc0Zw1zGxcG1EbI89wVe8An+n6SNTIxvCm8qn37TsqGcAXXeWvc08KKaFVsrk857FPcMiJWGwTuJ1ROD7T9JNz+xiz3OKgdZ5JnbpLlOyYTHsMdv5ZzhkBFW244OvLv6S/slwtMq1aTZL4jF4POYS+BRJiDDenb25jBV4ITNdPHW+8K8SuX7Uam1pVF6mxID7q1cONKkd5ek7ngiyZYcDHYzw8NN2QUF07+C17RK6w0L94xEcBg+LhClC9ldMTuFvEqQul86LHsX4M9Dwy4Yp+aqx1+baRUBv8spHXMPkfd/+PgK8gjnegt6V+ZAM9liWpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPFF28037229.namprd11.prod.outlook.com (2603:10b6:f:fc00::f5f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 22:43:39 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 22:43:39 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Matthew Brost
	<matthew.brost@intel.com>, Michal Wajdeczko <michal.wajdeczko@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, =?UTF-8?q?Micha=C5=82=20Winiarski?=
	<michal.winiarski@intel.com>
Subject: [PATCH v2 19/26] drm/xe/pf: Handle MMIO migration data as part of PF control
Date: Wed, 22 Oct 2025 00:41:26 +0200
Message-ID: <20251021224133.577765-20-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251021224133.577765-1-michal.winiarski@intel.com>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0502CA0029.eurprd05.prod.outlook.com
 (2603:10a6:803:1::42) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPFF28037229:EE_
X-MS-Office365-Filtering-Correlation-Id: 92f74794-50f3-4ec3-8884-08de10f34715
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cDFPSHZwMGlTaU53WFhwUlh5VVlDVjBhaTlWaFIzR3kvK0JwcEFaS3hVY3ZM?=
 =?utf-8?B?VjVZOWtZQmVvQys5aVlmZjNHWjJaN3FycGZhOGlvM2srMVRDbjArbGZxcGJB?=
 =?utf-8?B?ZC9tS1FzcGticjFCL0NUNkt3WktrWEdPamxEcjk4T0RRdzRaYm9NNHp5V1RV?=
 =?utf-8?B?ZGxzc1RUYzFWN3hSSjQwcC9kVlNJamNXZEdacG5CVjYwMTlkQmFGSmwrRE55?=
 =?utf-8?B?NnVaL20vNlRaZlpjaEdyOFQwWnNpSHhjSG5LTHA1aUhSYy9ud3Z0dHBYc0Nq?=
 =?utf-8?B?RVYxNC80aWwxSjRkV0hMcWxYaTZXZFBRUFZMRWM2NSs2MWpMZjFFR0p4MVpQ?=
 =?utf-8?B?YjVyTDd3aklRYzk2Sm9xT2ZmcjU2dnhQTXhHV3gwd3grNzZuRzNBbnk3STNt?=
 =?utf-8?B?bXdxYXdnd09VTmFFaFd3VTJHVEtXcHU0Q20zVmZMenAzaFlrQURNNlZqT24x?=
 =?utf-8?B?TWtVY1BFZVp6eG8zT0tlQ0lsWWdocW84Y0JZSElYMGpGa1pBQXFwRXdqeHRI?=
 =?utf-8?B?bG53TUxUMHdsdzJnMkg3aHNVV0dBK0VUV3FkeGVjSzZ6SVpvMjVvWVkyTjU2?=
 =?utf-8?B?V1FKdWI0eml5dWhId0JJb09jWkFqSVJrdjZDdHR0aE1xL05FTVg0TFQrWkoz?=
 =?utf-8?B?OW1aQVpmbzI2YTdKMktqVGxhUjR5OEIxbXlYRTZqMzA1SUJ4L3N5Z0hmVkhL?=
 =?utf-8?B?SHpJakZlNjZrMmpGZ3VOOXZXSWxmTnQrUm04cmcxTERmbjVWOWVGSmoxVWZq?=
 =?utf-8?B?YWV4ZjZNTklDUGV4c2ZhZ0RnQnN0NzdCUkVCSW84TDRaLzNHdDhxQ291bVFC?=
 =?utf-8?B?TkpHMCtXd3RyS295SHJVU3hRUWRHN2FMNjVvQWtxWHNseGJDNWJpeko5cGFx?=
 =?utf-8?B?VzdHYVMxZ243TGEyMGdQSVQwaFo1SXRvR1Y0TDV0bFRZVnVjUDFzMGhMTHlk?=
 =?utf-8?B?Y0N0c3RYNXRNNDdFeFVsZkJkTEJrbzA2WjBzSGEydCt0VmQ4eHprcGxESEhW?=
 =?utf-8?B?U09DM0h6b1RiTFNCSEk2NWh2aVFVeFpGbjB3YWJ0SEk1VjFFT2xJakRrNGhH?=
 =?utf-8?B?UDV0SmZUUy9UdzI1OTZaaTFIUFpwRXNVeFNVekRRR05UYTJtMkxqZGYwY1Nj?=
 =?utf-8?B?VmthdHdHL2ozTllCLzhXKzgrYmJCRVY4bW9DaDZwa3lWdXdVVVZVZ254WmJo?=
 =?utf-8?B?R1hvWlVXamxaWWdpdG5Zd3k4VW83anMreWYybFJrRGNFcXdXaHRIZkR5Tzhx?=
 =?utf-8?B?RkxPUW9JZStaSDZ4dUxBT0Y4bXB0QkhXVkdHMzJ1SmtUajJRWEJjZGlTNW8y?=
 =?utf-8?B?K3Raa2NjeWNHYytiaENmd1hjamNuR0tuRXptYlhka0RqR0xFUEFhZzlVa3JM?=
 =?utf-8?B?SklhRCtPNkY4T0xzd1lvTHZud2pINk8ycjI4eDNzcVhVWG1GZ0JRRUJ1ZUdP?=
 =?utf-8?B?citDRSt0dmhvZ0FSTzdydTA3d2NMTmFoMHA1eEV5WjlVWDh1bDhmTk1wbVRu?=
 =?utf-8?B?RHdlZ3hWWWZCTXNWZEkrU05NQ1E3R0xGeHpYbzR2Z05ZeFM2V0M3YU9oaSt6?=
 =?utf-8?B?L28zZjkxL0sxQUhmRTQ5TDQ1NFpyTHRTZzBDMG8raHArejhJWi9wOGVWV21L?=
 =?utf-8?B?QkxzeFpLMTlTcU5rcysweFl3QmxUNzE0cGRHZ1ZhVVlpVk01cDFEdXJUcWpW?=
 =?utf-8?B?THd5SlkySXlGdkltRjUxNmRQcVdLSXVCMjJBV04xU1Q4T0JoRW1Hb2FyVStu?=
 =?utf-8?B?RnJQRlZZanJBRW5UOHhHaVNydXR6WVo4VCs3cGhwU1BjTFR3Z0tyd2RQZ21k?=
 =?utf-8?B?OWZwK0tDdnExek9CWWVNM0RlNHdtUm5rc2g3eS9ITmxyOWR2QTVZVkJERHZk?=
 =?utf-8?B?eUl3bXBjOXNNazd2UmlaVWNLVmZ0Z3J0c0V1TFRWMG0xRFdIclhZZ0xXVVRZ?=
 =?utf-8?B?NDUzYXE5VjhhT2RuT1RUUlA2WXNsci9aUXZnQnhoWG5oOStFelZUc0hadW1Q?=
 =?utf-8?Q?VfKAPBMzWAyNoi/n7e9XMj0ur+ZTQ4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEZmMFJQMXNQd3krQXhoUUhwYUY2dWk5YUkrTGtGeEJVTjRkZE1Xb0FPeE1J?=
 =?utf-8?B?SWwzVFhLTFpzamsyZEJqYUh3TGhTU2xXQ0UrVXVhdDh6Vnp2TnBuTFFqbm5C?=
 =?utf-8?B?SEo4VXFXb0JLRk9aRmR3RmcwYUttTlRhRnZIc215MnlCeXVGMXUrMTUzazFz?=
 =?utf-8?B?dHRFb05sb2tDdGNiZEtWektMbDB4amkzWHRuNU9uTVgrWWphTlRtZTZCRWN2?=
 =?utf-8?B?b3o0T1lCQ3lNcUpqZlpmN054UUdHWnM3N3VabGJ0dk14WnFmYTIxdmFpWU8w?=
 =?utf-8?B?N1lJYmpMTmxGYW1qU2hSUmRadUtvOEdtU2NVclZrellQbzdTQStHOGMvbTJR?=
 =?utf-8?B?OWZqVzJoV2M3bEZleEkySkswRWpremFJajl5dGhBYTZPMUlNcWNMM09uU05F?=
 =?utf-8?B?VHNrd2QyT2p1YnlOZjdQOUd4UUJiTHdFY2hPMWo5RDlBSkhUa0lta2FDY3VG?=
 =?utf-8?B?SUUwMEduSTFMZCt0SmVBdmxYMkRQZWhUVDkwbFRiampiYVVVYlpmUEFXcFNz?=
 =?utf-8?B?MitKTGRhZFBuSUdpU1d2TmVGYk15Q3BFS0lvUkNpSEtncG9ta0c5dWd5MHdL?=
 =?utf-8?B?Tzk0cEdZNGdGZVJZOXRweVQvY21ZVjZtdFNEVWUyNmxJSS9Iem9LZjkzQ0pT?=
 =?utf-8?B?a01ISnQwZUF0ZVJpWmhqOW5pbmxCVy96anE2ejJ4RmREeTVNaHdhdVdXZnp3?=
 =?utf-8?B?QUxqMHIySmc2dWFPWGdhT0Vjc1VvTnNzQUpZZkVPcVZvUVBYUk5LUXdxa2tU?=
 =?utf-8?B?a3lSWnlNbWp6S3pOZHFiajV1cmpyQ3RkM05XUXpwZE9Rcm5ITVpKaUxFTUZX?=
 =?utf-8?B?UmFhbXV6S0E2SmhMUE9xZSsyU3JHUVd4TWlwQ0p3bnJxNDB5ekEvMThrYmNt?=
 =?utf-8?B?Ui9OL2pwd3Q2bTVFc2d5ZHZFa2JlbGVXSjRPK0VnakQyWlNNUGQwbXMwSVV6?=
 =?utf-8?B?aVRDQjlyL0h4aVJQbmQ3bFJKaTBVL01BWkNEOWZ1bFF2dnIxY0h2bmVYcjFx?=
 =?utf-8?B?Z2tSWGg4bXpneVhCanIrVHVzTkljQlVLRzZEWU1Kbk1QLzU3dFcwTlJ3cUxS?=
 =?utf-8?B?V05aYkFkYlFLN3JvbEhUam1LVVBLMmxKb3RqOTFTM1ZPa2R0dWhwTzlyOWM1?=
 =?utf-8?B?WENlOHFGN3VEeGVYZktUVGtaMnlFYjdySG9CemljajducmFsZ29Db1Q4SjZS?=
 =?utf-8?B?cUdVZkJIZXBCc0w1SldsRlFacVlnSm9kZHNycUxmaEV4Nnd0QXkzU3Y0Si90?=
 =?utf-8?B?RHVBK2xSKzkvVkl5QXdCRTlBZmcxa0Z3NmtYZ0c0Z3lqbWdMSXc4UGJRU3lY?=
 =?utf-8?B?K0h2UDFvclluK250b2NMbDZTWERjbDRyNGVITUZpeit1M0tGRGxxRlJWUFFH?=
 =?utf-8?B?SjF1c1NxUGFYeGNob0tYalRQeThEcElwQzN0dXl0dEpnVnBxcHQvWjdnOEVh?=
 =?utf-8?B?VHZMZEVXNVFsRkdqQXlMVjN1NHlmSEIxelo0OGdMRmt6Y2xPQnI5OWhXc29W?=
 =?utf-8?B?WS8xaUp2d3dOYkUzZjhNdXRtejd5R0hmY3ZSREZhOHJKQlpVOFdqNFJ0R3ZH?=
 =?utf-8?B?eHVzRzlwaitHYW9MWi9OWVZac0tQTmdkVnA1L3RGMWh6TmpwdE5mcEFWWnpM?=
 =?utf-8?B?dndaaXpnQlM3YzFtekdaQ1Nsa0ZFeUNJTkZ0WDJiNmMrMmt6cWFiNnZDTU9k?=
 =?utf-8?B?RXZjMzY4aTdTTUFSMEJBc2x2dG5HMXVsY2VzMEtxOXdPQWhIMDV0ZW0yUFNC?=
 =?utf-8?B?VlNYc2V0cHI2cHRrYng0RUNqdzZCTkNTYzJYV3R5NnJqd0FsVCt1d2w5UWFo?=
 =?utf-8?B?VjhUVms5TXZUdDlWN1dxUXRWWXh3REZFMWVVVWZVMGlpNitLMmR4QWNMY25y?=
 =?utf-8?B?VVZjVlI0SHdrcHQ2L0RhNG9IM1E2ZXQvdkcwTjl2djZjb2FxTzdPb3lsWjVs?=
 =?utf-8?B?bHluVkptQWZ2YURnbjJnYVJhSVEyZ1A0ZTQ4ZFpKcnVLcUFGVk9aY004VWFY?=
 =?utf-8?B?N2JqMTIwZ09iZDhCbW1oSEh2WFJFc3FiZlVMNVhWYkRXMEVlRzRiUFhJcmMz?=
 =?utf-8?B?YW1LN0l6VlJlRVZxb2xlNERzMEhES3JWT0M5VGRlY0FkbXlpYkRhRE4yTitp?=
 =?utf-8?B?djA4Q1I4SGVzOEl2TUNpNFB5TjhDMzlja3ZtQ3M5UFRrODZ2cHNlcE0xZXY3?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f74794-50f3-4ec3-8884-08de10f34715
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 22:43:39.0209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VtUwmGcdXySTuzXCPBZ4jN/FDblxcFxb7/A8qBTvVZqP5JHLMXfO9TIrJ6eMTDUuJZvhlXnKY9p6bn6crs0O4agtbBJ+Ftl6HWER7Ic/X08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFF28037229
X-OriginatorOrg: intel.com

Connect the helpers to allow save and restore of MMIO migration data in
stop_copy / resume device state.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c   |  16 +++
 .../gpu/drm/xe/xe_gt_sriov_pf_control_types.h |   2 +
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c | 114 ++++++++++++++++++
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h |   4 +
 4 files changed, 136 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
index f5c215fb93c5a..e7156ad3d1839 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
@@ -190,6 +190,7 @@ static const char *control_bit_to_string(enum xe_gt_sriov_control_bits bit)
 	CASE2STR(SAVE_WAIT_DATA);
 	CASE2STR(SAVE_DATA_GUC);
 	CASE2STR(SAVE_DATA_GGTT);
+	CASE2STR(SAVE_DATA_MMIO);
 	CASE2STR(SAVE_DATA_DONE);
 	CASE2STR(SAVE_FAILED);
 	CASE2STR(SAVED);
@@ -829,6 +830,7 @@ static void pf_exit_vf_save_wip(struct xe_gt *gt, unsigned int vfid)
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_WAIT_DATA);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_GUC);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_GGTT);
+		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_MMIO);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_DONE);
 	}
 }
@@ -872,6 +874,17 @@ static int pf_handle_vf_save_data(struct xe_gt *gt, unsigned int vfid)
 			if (ret)
 				return ret;
 		}
+
+		pf_enter_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_MMIO);
+		return -EAGAIN;
+	}
+
+	if (pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_MMIO)) {
+		xe_gt_assert(gt, xe_gt_sriov_pf_migration_mmio_size(gt, vfid) > 0);
+
+		ret = xe_gt_sriov_pf_migration_mmio_save(gt, vfid);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -1081,6 +1094,9 @@ pf_handle_vf_restore_data(struct xe_gt *gt, unsigned int vfid)
 	case XE_SRIOV_MIGRATION_DATA_TYPE_GGTT:
 		ret = xe_gt_sriov_pf_migration_ggtt_restore(gt, vfid, data);
 		break;
+	case XE_SRIOV_MIGRATION_DATA_TYPE_MMIO:
+		ret = xe_gt_sriov_pf_migration_mmio_restore(gt, vfid, data);
+		break;
 	case XE_SRIOV_MIGRATION_DATA_TYPE_GUC:
 		ret = xe_gt_sriov_pf_migration_guc_restore(gt, vfid, data);
 		break;
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
index 1e8fa3f8f9be8..9dfcebd5078ac 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
@@ -35,6 +35,7 @@
  * @XE_GT_SRIOV_STATE_SAVE_WAIT_DATA: indicates that PF awaits for space in migration data ring.
  * @XE_GT_SRIOV_STATE_SAVE_DATA_GUC: indicates PF needs to save VF GuC migration data.
  * @XE_GT_SRIOV_STATE_SAVE_DATA_GGTT: indicates PF needs to save VF GGTT migration data.
+ * @XE_GT_SRIOV_STATE_SAVE_DATA_MMIO: indicates PF needs to save VF MMIO migration data.
  * @XE_GT_SRIOV_STATE_SAVE_DATA_DONE: indicates that all migration data was produced by Xe.
  * @XE_GT_SRIOV_STATE_SAVE_FAILED: indicates that VF save operation has failed.
  * @XE_GT_SRIOV_STATE_SAVED: indicates that VF data is saved.
@@ -80,6 +81,7 @@ enum xe_gt_sriov_control_bits {
 	XE_GT_SRIOV_STATE_SAVE_WAIT_DATA,
 	XE_GT_SRIOV_STATE_SAVE_DATA_GUC,
 	XE_GT_SRIOV_STATE_SAVE_DATA_GGTT,
+	XE_GT_SRIOV_STATE_SAVE_DATA_MMIO,
 	XE_GT_SRIOV_STATE_SAVE_DATA_DONE,
 	XE_GT_SRIOV_STATE_SAVE_FAILED,
 	XE_GT_SRIOV_STATE_SAVED,
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
index 75e965f75f6a7..41335b15ffdbe 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
@@ -9,6 +9,7 @@
 #include "xe_bo.h"
 #include "xe_ggtt.h"
 #include "xe_gt.h"
+#include "xe_gt_sriov_pf.h"
 #include "xe_gt_sriov_pf_config.h"
 #include "xe_gt_sriov_pf_control.h"
 #include "xe_gt_sriov_pf_helpers.h"
@@ -378,6 +379,112 @@ int xe_gt_sriov_pf_migration_guc_restore(struct xe_gt *gt, unsigned int vfid,
 	return pf_restore_vf_guc_state(gt, vfid, data);
 }
 
+/**
+ * xe_gt_sriov_pf_migration_mmio_size() - Get the size of VF MMIO migration data.
+ * @gt: the &xe_gt
+ * @vfid: the VF identifier
+ *
+ * This function is for PF only.
+ *
+ * Return: size in bytes or a negative error code on failure.
+ */
+ssize_t xe_gt_sriov_pf_migration_mmio_size(struct xe_gt *gt, unsigned int vfid)
+{
+	return xe_gt_sriov_pf_mmio_vf_size(gt, vfid);
+}
+
+static int pf_save_vf_mmio_mig_data(struct xe_gt *gt, unsigned int vfid)
+{
+	struct xe_sriov_migration_data *data;
+	size_t size;
+	int ret;
+
+	size = xe_gt_sriov_pf_migration_mmio_size(gt, vfid);
+	if (size == 0)
+		return 0;
+
+	data = xe_sriov_migration_data_alloc(gt_to_xe(gt));
+	if (!data)
+		return -ENOMEM;
+
+	ret = xe_sriov_migration_data_init(data, gt->tile->id, gt->info.id,
+					   XE_SRIOV_MIGRATION_DATA_TYPE_MMIO, 0, size);
+	if (ret)
+		goto fail;
+
+	ret = xe_gt_sriov_pf_mmio_vf_save(gt, vfid, data->vaddr, size);
+	if (ret)
+		goto fail;
+
+	pf_dump_mig_data(gt, vfid, data);
+
+	ret = xe_gt_sriov_pf_migration_save_produce(gt, vfid, data);
+	if (ret)
+		goto fail;
+
+	return 0;
+
+fail:
+	xe_sriov_migration_data_free(data);
+	xe_gt_sriov_err(gt, "Failed to save VF%u MMIO data (%pe)\n", vfid, ERR_PTR(ret));
+	return ret;
+}
+
+static int pf_restore_vf_mmio_mig_data(struct xe_gt *gt, unsigned int vfid,
+				       struct xe_sriov_migration_data *data)
+{
+	int ret;
+
+	pf_dump_mig_data(gt, vfid, data);
+
+	ret = xe_gt_sriov_pf_mmio_vf_restore(gt, vfid, data->vaddr, data->size);
+	if (ret) {
+		xe_gt_sriov_err(gt, "Failed to restore VF%u MMIO data (%pe)\n",
+				vfid, ERR_PTR(ret));
+
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * xe_gt_sriov_pf_migration_mmio_save() - Save VF MMIO migration data.
+ * @gt: the &xe_gt
+ * @vfid: the VF identifier (can't be 0)
+ *
+ * This function is for PF only.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_gt_sriov_pf_migration_mmio_save(struct xe_gt *gt, unsigned int vfid)
+{
+	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
+	xe_gt_assert(gt, vfid != PFID);
+	xe_gt_assert(gt, vfid <= xe_sriov_pf_get_totalvfs(gt_to_xe(gt)));
+
+	return pf_save_vf_mmio_mig_data(gt, vfid);
+}
+
+/**
+ * xe_gt_sriov_pf_migration_mmio_restore() - Restore VF MMIO migration data.
+ * @gt: the &xe_gt
+ * @vfid: the VF identifier (can't be 0)
+ *
+ * This function is for PF only.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_gt_sriov_pf_migration_mmio_restore(struct xe_gt *gt, unsigned int vfid,
+					  struct xe_sriov_migration_data *data)
+{
+	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
+	xe_gt_assert(gt, vfid != PFID);
+	xe_gt_assert(gt, vfid <= xe_sriov_pf_get_totalvfs(gt_to_xe(gt)));
+
+	return pf_restore_vf_mmio_mig_data(gt, vfid, data);
+}
+
 /**
  * xe_gt_sriov_pf_migration_size() - Total size of migration data from all components within a GT.
  * @gt: the &xe_gt
@@ -408,6 +515,13 @@ ssize_t xe_gt_sriov_pf_migration_size(struct xe_gt *gt, unsigned int vfid)
 		size += sizeof(struct xe_sriov_pf_migration_hdr);
 	total += size;
 
+	size = xe_gt_sriov_pf_migration_mmio_size(gt, vfid);
+	if (size < 0)
+		return size;
+	else if (size > 0)
+		size += sizeof(struct xe_sriov_pf_migration_hdr);
+	total += size;
+
 	return total;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
index 09abdd9e82e10..24a233c4cd0bb 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
@@ -23,6 +23,10 @@ ssize_t xe_gt_sriov_pf_migration_ggtt_size(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_migration_ggtt_save(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_migration_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
 					  struct xe_sriov_migration_data *data);
+ssize_t xe_gt_sriov_pf_migration_mmio_size(struct xe_gt *gt, unsigned int vfid);
+int xe_gt_sriov_pf_migration_mmio_save(struct xe_gt *gt, unsigned int vfid);
+int xe_gt_sriov_pf_migration_mmio_restore(struct xe_gt *gt, unsigned int vfid,
+					  struct xe_sriov_migration_data *data);
 
 ssize_t xe_gt_sriov_pf_migration_size(struct xe_gt *gt, unsigned int vfid);
 
-- 
2.50.1


