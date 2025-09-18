Return-Path: <kvm+bounces-57970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2BDB82F70
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D8BD3AAFFA
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5CE28136F;
	Thu, 18 Sep 2025 05:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UOhbqKko"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBE627F012;
	Thu, 18 Sep 2025 05:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758172516; cv=fail; b=diBMBbJhFqtu5iFFHXymtYLZndQm5kbGekpTZKRVy+5tXpAfSGIR5xGz3pIx0s5wGR72QvRksu0LRFzogRe6qJWyquFtzKAHRdl1YDAIhEq5Lvf+apiiiiyZ5uXoTaECEPMRP5tjjBYwYg0zcJLHxa7a3dPyueBElFqxBB+cMUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758172516; c=relaxed/simple;
	bh=p+D8geXYJrUxKEye/eKZBtue0d5PA9CUm88TVJ0H1ZM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JY3ifzqDR9HIgYJ36FOdOmpOy4wBwObbei7Ov5qSfCVnbyULds89I8RBRZ88WM6wc/HirgmcGdMZCZyH1ELyE8CnOTOGj+AH46BojILS79ze6gVZCVgwKvFy28evlSAC3F3+J57L68+Wiohu94cMqpVBaN+5v1eGOuIZJc5trCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UOhbqKko; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758172515; x=1789708515;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p+D8geXYJrUxKEye/eKZBtue0d5PA9CUm88TVJ0H1ZM=;
  b=UOhbqKkoYFQra6AsOaa4Xvh3YW4gfdvSDI15Ad4ovLkGmOO65L49JfGc
   DTUb51kqPFNlqYwTHINkzx3hDsb76UUjiV+9to9XUJYB108r3BMyDFadV
   nm/tYY2BiBToVKRNLSi5zhxGdJKnH4scGPyeltdwSFdayhCY+9yqQYDwq
   wxx/6bwdKtv937GOBCUWO8pxGeE7iS6oIf0eigm45bxg95roD64yoC5kV
   oRPnTriw972563UEa3mf5BYkgk0vsy6Bz/8azxiRGhQaiM8H+qtHwodCw
   wJRdZnraz9BVW/FU21zX6lZcXOaimVoY/bH2mbp2D4RbJNiaUqlask/hW
   g==;
X-CSE-ConnectionGUID: GIDwiN4ASLCgWpwXc1NXtg==
X-CSE-MsgGUID: 8UvD/KYzT6KEtocE/ffGbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71122905"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="71122905"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:15:14 -0700
X-CSE-ConnectionGUID: wG13LADlQter8myqOGnvhA==
X-CSE-MsgGUID: FfBLrEnPS0SNK8GOcDTwtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="176230381"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:15:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:15:11 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 22:15:11 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.28) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:15:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gyZdCWC90qKiyn6jBIcR306YuVS1ByIDq9WDUi7gTdjCI2YBlxDSZrV/wtWlNC16LNr/cov4rxyS2vuI2TRDOckS3Pz0wbvnwVps8V03B7XNdVXjsJIayQ54IujtPfcQLn+3h/3ougzesECrqqJneIMThsuH8/l81zWy9VgiySGZ1MNTs5KCZVfGMsim6RZmyHQeOafIr72ismNIJ6kaXfkBdnPxjN5YhP0Naz4Sn/t+arhIx6qcf+2MXyTyk8KuoGHSnzOTWpHAwl920eszgreXUyhMs4p4TeG3+k9UNGq6vJncTPvLqkLCBvt7Gk41WRUSnDvDwaKhdEt1mVF90A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcNl3Jqb6rydoiAH/G0nNvMdcJWM7EzzUWqJ+c4rB2A=;
 b=bu4ClTUbSvLJHtFI9RDpNP5TCPfXTi8993C4fAE4hv9ea9qgDIN9I5iJnMYVCrcpEmH1ANnduH+GX/C1XJOFnHy3aJocMvKzetbyvhb8rBu4yiiLWWLDwVAR0FzjbY2KDDwBl4B3QsYLjtghkYCsbZoSuQwDBXMh59scyDm3CRH9ql6vUkqEnXJBOCIV5x30Yfnj3dey0OX4g6Wo2L+FNG51t5JARk9LnBWXdzVzZor382kCzC7kALmliMF9Ieogft2V51BX7rHIZDw5wgS69psumAOpOWOx2C3SLKCe6eMpObIga/EfM+QVbvL3V66towDp5CuQrHjx2PqT5ZLuSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB8336.namprd11.prod.outlook.com (2603:10b6:208:490::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Thu, 18 Sep
 2025 05:15:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 05:15:07 +0000
Message-ID: <13a1d78b-4bcd-4216-93cd-b95961a12369@intel.com>
Date: Wed, 17 Sep 2025 22:15:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/10] x86,fs/resctrl: Detect io_alloc feature
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <cover.1756851697.git.babu.moger@amd.com>
 <c9c594dddd02b53498a184db0fda4377bcef5e89.1756851697.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <c9c594dddd02b53498a184db0fda4377bcef5e89.1756851697.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::39) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB8336:EE_
X-MS-Office365-Filtering-Correlation-Id: 16bae5f8-494d-4807-d9f9-08ddf6725539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WFRJYzhycGpTUkJvdG1XTDFNZmNEUTd4S0NzRm81Nkh1SG11a2N5aGNFbGta?=
 =?utf-8?B?cVNKZDhZVGlUdUpwTXFnOERseWROS25pZUllSVRock9iNUppam04d2Z6eGh6?=
 =?utf-8?B?clI1SHJiK3RFOUo3K0tBdEQzRkhUaXN3N1NsQjlMWnRYOWM2RWxIM28wRlFF?=
 =?utf-8?B?MG5NalBBZi9GU3N1azNVLzd2eDdieUJJSFZVZm9XS2FQMXY0cHAvYTJpbGFo?=
 =?utf-8?B?MEtISjRXbS82cy83RFEwUmR3dDBTMFVONWxlK2w0bVdsR0dJVUtKZUtFT2Jv?=
 =?utf-8?B?V2o2UVFONWVjK2ZGRFlMR3hJUE45ZXprV1ltQlNxUlA1SkVGckxVZy81Y0Rv?=
 =?utf-8?B?NzlmVlBlcnN0RExnblZucDRtUlZHZU45K0VPUVpvRU05MWZZK2ZJTTM0U21X?=
 =?utf-8?B?UlMwZ0RYbVZkdk9OWUdNSU1Lam9jMGYvblN0aXFFR25sUVREYlE4UEVKTjl0?=
 =?utf-8?B?T2RhQjFuSDk2NnFzNEQyZmVsVGVKQ1c1eXF3Z1JjSHVkdFk5M1BoelBGQVVR?=
 =?utf-8?B?ZktnNmcya0pmKzZJSXcvYjl2dUxmalo4OGhtUm5uV0JaOFdSUTZydmZwZnAv?=
 =?utf-8?B?VWpqSHNBcFlYenJJUWVFM2x6b3VIU2JoRm9yLzZGS0todktETFhSTkVINFlQ?=
 =?utf-8?B?TnVIVzZ1MzNubkRkRWE1cnd2S25tZ1NTcCsydWt1Uy9zTXdNajUyY1c5V1hT?=
 =?utf-8?B?dnRmcUJ0ZzZqQVZMclNYYTVXT1pZV3BzdmJLTnJkS2hac1Vpc3hiQzZKSHhV?=
 =?utf-8?B?azhjTndMRkZ4RGpMMGViRnJKQTFFS01TNHptbU5GTEcvdjlvL1hRYnpITHZk?=
 =?utf-8?B?M3NlM1k1K1NvTzlWQWZFNUhCQ3dRc1Nvd2dteDdmR0MzZk9meG4zNUwwY1hR?=
 =?utf-8?B?QlJjQWJxS0IvTzRZbjhVOVdnSWVvM0J4UEdlTlUwdFY2SUVmVGtrcFRTeXR6?=
 =?utf-8?B?ZFVPaGZqT2RNWnQwblA0YkpQY05iSGVTbFY2cXd6bURBdWV5U25uVEdLblFR?=
 =?utf-8?B?c0piT0JkNWJKL1hFeFV1MXo1V3NKaVFab1dyZjFGR0diRVNJb1RlREE0bFpP?=
 =?utf-8?B?ZG5sWjc1ZFp2d29Sam9YYVlIV2hSVFYxS1pTNUowaVFYTEN3S3RwSTZMTk5K?=
 =?utf-8?B?bTlkTUY1VDUxblNrRFdGUXJsNU9VNlp1U25KRjc1UHZpZmJEQnNHUGdBNkdH?=
 =?utf-8?B?YlBpNEtzTnNYZjIrQVJMWUtNaUppS29vbE9maURCZ2kxQjhwT2JJb0ZieTBI?=
 =?utf-8?B?a0dUVDYwK1AyT1FUdEhoZW8xb1c1NUlmckx3dWpzUG1IUjNsNDVzOHB4Vm9M?=
 =?utf-8?B?WUhmdGh5TWJFRFcwSGFYVVR4SjREZXQxZzE4ZTE0UFl3Njk2YjRvSDRvSmcv?=
 =?utf-8?B?dTdDWm9NeFZQVC9iaEFiZGxGbVdiVXgzcWkxaXFmTk9pSW93NWY0Tjk2Nm9t?=
 =?utf-8?B?bkhjRisxcXNBQW55dStnR010WDBCWWtoQ3Z1bGVpTnZRWGZvbWw4b2w2bHM5?=
 =?utf-8?B?eTdKY2k3eStwa05CcDF4Rmg1Y3g2STlzcW4wRXZVY0NGUkJEcXRWVDlZdzU1?=
 =?utf-8?B?bHlNRE0zWHpDdndUd1ZjTE9hQm9ZanJJME5xVjlOcWZ1WGtPNGJxa0hXKzlQ?=
 =?utf-8?B?TUtXMTVWMmZLdGE1NllzMXVDUXdON205bW1BbzltYjVxa3U2emlqRU91WmFI?=
 =?utf-8?B?VG1ZOWFPVEt1S211TE1DaWJndTRtT0dIMU05Q21FZjZGKzNwRkF5dHYvblRl?=
 =?utf-8?B?dm80OVBCbXRMUlBHQjdEZDdldWN5SmVSU3laQk90M2lKby9hbnRjWjBrZGFI?=
 =?utf-8?Q?x29SwJuZDpUupMj+2kfHDwIs9XRrYKYTvJgzo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWRZcjFrVU1ZZXFHRHA2SzJOMzRIYXA4amdYY00xVFFqTDg3L0FFYzk4TmZm?=
 =?utf-8?B?cTBhc3JlYkpkMDNBSWQwR1pyOEJHcXFCazZPdXdpaVJ6ajBIU0svYWJ5b3Vw?=
 =?utf-8?B?czFnZnpUSTdBWFNXd3hRNlI3bWI1L0R0dmZ1WmlHL29uM3dIZzI1Q3ZaMUtF?=
 =?utf-8?B?UGI1UkxCZERCNEdFSG5rL2c2R1c0MjlXSitHMERFemxkZkg1Rm9RSnc1c1lW?=
 =?utf-8?B?eFY0SkFrR28wMTRISVZ1Wi9laGpmSmhTT1pHNnRhTzc4TTdzbzU0dXZjaXlu?=
 =?utf-8?B?Z1pEV0VqemNNeFdnWVR1NEF1QXlvR3UxZXpXK3BwQUhoZFZzYlhmNVVPZGJW?=
 =?utf-8?B?QWk5TVNxYmRVYWM0RDVMQVRiMmRWUXJzdmFaOU94SnhaZDlrL3JNMGZJV0h0?=
 =?utf-8?B?eHd4Z3BGVkRsdUxidXhha3lQRzZIS0pIdVM2Qm8wWmd0clhFc3QzOVFUT2E5?=
 =?utf-8?B?SUlBNzFwNlE1KzVqdHp4WGlYbldaaEZoMldKMkgrM0RYdEEzOU5uQXBRUEVp?=
 =?utf-8?B?eTdsMDVzaUhtQ0R1enJQcDN3dVVxSDJ2WU8ySzdHVEwxamF5OGo1OGF5WkM4?=
 =?utf-8?B?RHdDeGRWZGNTV0VFem95NE10Vm5aMi9lY2dTTWlxMGtRV1V0QjBLZ2Qxd1VO?=
 =?utf-8?B?WmU1VmJRNitrOE5OMjRHRTJ6UUV2Z1UyaDE5dGVqM052QnFVaWk1VkJhUS80?=
 =?utf-8?B?MUdUTURUM1lWSGVUSkNMbGdnWTZIQ0FjM0J4akQ3Nk1CUHFsOGt4OVJhQWVT?=
 =?utf-8?B?c0hqMkp4aEYyZGtLNlZQem5SOEFoTVpaVVVzdHRzcVdNS1JFQzVsKzhHOWZm?=
 =?utf-8?B?RWVub2pKMzNnYzdxdmZZdTRGTmFaR205V3ZYREc1TjE2ekVDNUowRUtKMk5C?=
 =?utf-8?B?ZXhRS1N3L3AzeWVmZDV3cHB0RDNDRCtWQmZNUWJXQmVzTFlJSXJtUEFqZEkw?=
 =?utf-8?B?YnNESTEvOUVKemRnSEFGQkxXaDNkVUgxaTY1cy9takwvNFplUmIzdjRyR0ow?=
 =?utf-8?B?VjBaYUdMT2NobU4vWWpTZktlbVNHaVBKQU9oU0VnUEl2TDZxcTVHdjVKUDg0?=
 =?utf-8?B?S2orWlI4cnd1ZHA3ZXJqNmxQVGljRmxTQ3JXVG84aldkMWZDMFBiRERIQXBB?=
 =?utf-8?B?bVduY0IxWEZQeVJnbkMvUmJodWlxKzR0bkZ2Ym9XNVRKT3hkVDkrMTg3WFJQ?=
 =?utf-8?B?ck9aOWdjZk0yRGtXS3IwRXBFZW5YL1M4UHZxMmhEaGRkN2lna2d4cWNkcWNq?=
 =?utf-8?B?MnZrSXZaSDZJOWtuMncrelpLSDlnQ3pmeEEweGlHOHVVTGlXdUcyT1F3eHJZ?=
 =?utf-8?B?emV4d1NFcFk3TG50aEtpTWsrVFdsMHhxbHdDcmRrRmFJWU1LejlNekx2ZVkw?=
 =?utf-8?B?M2lnci84TGhvc0pmWEFkS2k2ZmFKWVEybWNlcVRnVGtEVFlXeFA1WW1nQXJU?=
 =?utf-8?B?RXJzSXRPVVBpSHF6RUV0cEVYNXBYZGd5VmNUWnNwZUVydmhRWGNTVHR6QmpG?=
 =?utf-8?B?SlFDUy9rWVlZcVdmWFFuOThVTEYrMDlDdUo3RmJZSWJMcytlWGtqQVQ1aGRl?=
 =?utf-8?B?bHN0M3R6UU8vdURoZ2ZXN0tML3BmWFZTZWQ1SXgzM2E4emFQVkRpMlNBcnNm?=
 =?utf-8?B?R2h4SlZEaUZ2K2F2Nm1MR25lbUlISnNETjlXM2cxRU1QYzdZQitjUlJLNzVB?=
 =?utf-8?B?UjR5S05IYU9uODNQSE1NYVdJNU15ZENwTlVUMXJyanpCamczeG5KWXpaSDlt?=
 =?utf-8?B?RXhDU1dZTVR5cWVWTnNONkp4eHZDbWdQUUx5YWc5cS9sQXJlL1ZvODV5THJ0?=
 =?utf-8?B?RWVpMytweUV5d1VBVUREU0ZxQXVBQW9vOE5FcEo1ZklZencvbFhxMkN1M2pz?=
 =?utf-8?B?alREM0xKbnRoVDE4VzFXellXZTJOZTkwL0FyUDc0U3cvdTZlNFZ4V3F2ZmFu?=
 =?utf-8?B?L1JtZGU3OXRNWC9vQ2xleHFIb2l6dmpTeXNEcGJKa2JFV2NtVTNYWW15TDg5?=
 =?utf-8?B?aVpWdU5YYXZIU20yNE11SVd0M0QyUzY4RVdDSjdiU0RPajUwOGhLWDd4Z1c1?=
 =?utf-8?B?eDltT2l2UG5aRCtQc2Zua1hidC8zSjV1QkNoelFCMW5XTWxZTEVQMHlLL2lT?=
 =?utf-8?B?N1ByQkIrcE9USHJOUnpXUzErTVNLRVc0Z01kVFlHYnBXb1U4b3JRY2VIY2dP?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16bae5f8-494d-4807-d9f9-08ddf6725539
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 05:15:07.4178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qCiGf6glleiSIQfOT3gJukW6sKE4QutKlgXUDgS0mvXS+/BIydtFpLSRMgmq9hAZzXfg9Va66CMOpfFAS+eSwDKpZEb/aD3hACBy62HCF6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8336
X-OriginatorOrg: intel.com

Hi Babu,

On 9/2/25 3:41 PM, Babu Moger wrote:
> Smart Data Cache Injection (SDCI) is a mechanism that enables direct
> insertion of data from I/O devices into the L3 cache. It can reduce the
> demands on DRAM bandwidth and reduces latency to the processor consuming
> the I/O data.

This copy&pasted text found in cover letter and patch 1 and now here seems to be the
type of annoying repetitive text that Boris referred to [1]. Looking at this changelog
again it may also be confusing to start with introduction of one feature (SDCI), but
end with another SDCIAE.

Here is a changelog that attempts to address issues, please feel free to improve:

	AMD's SDCIAE (SDCI Allocation Enforcement) PQE feature enables system software  
	to control the portions of L3 cache used for direct insertion of data from   
	I/O devices into the L3 cache.                                                  
                                                                                
	Introduce a generic resctrl cache resource property "io_alloc_capable" as the
	first part of the new "io_alloc" resctrl feature that will support AMD's
	SDCIAE.	Any architecture can set a cache resource as "io_alloc_capable" if a
	portion	of the cache can be allocated for I/O traffic.  
                                                                                
	Set the "io_alloc_capable" property for the L3 cache resource on x86       
	(AMD) systems that support SDCIAE.                          

 
> Introduce cache resource property "io_alloc_capable" that an architecture
> can set if a portion of the cache can be allocated for I/O traffic.
> 
> Set this property on x86 systems that support SDCIAE (L3 Smart Data Cache
> Injection Allocation Enforcement). This property is set only for the L3
> cache resource on systems that support SDCIAE.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

Reinette


[1] https://lore.kernel.org/lkml/20250911150850.GAaMLmAoi5fTIznQzY@fat_crate.local/


