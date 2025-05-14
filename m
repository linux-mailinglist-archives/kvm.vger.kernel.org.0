Return-Path: <kvm+bounces-46408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B58C3AB6081
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 03:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4118319E4A48
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 01:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C1618C02E;
	Wed, 14 May 2025 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MT1qp4lv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE3717C98
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 01:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747186811; cv=fail; b=tlVUvTPHgaZiZJ0+8Y2Uyok0pxv1h5WsBJEROzjSJ3lyoAFox3qhtoc0bb1X2fJIWyBVJbrCMWy9rigmrGx7c7f1Pq8xHvzutcnrsmf/M+HZ5kSrCtn7L58Ip0w+LQ4FGgJWI2OhFHC0szfQLLXTuo5+BltrOle/qZQgqyMEIvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747186811; c=relaxed/simple;
	bh=vN1EFgkaRl+7nbv1wOzlBd/7NEt4mMSeuKmD+XV8NFM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gXtSbpVh0Brhldp1iGznmlPD82cjuSBjDcL63EXW1lRiCtJyYx3T/S0zr9h2yIptAKZMcfGl7LfgR6rSniEqdGJCwqqkOtGzAiEBmOuOUYNNMhKhomgozIDfsgPTTnReEuQ95zNfwKrL4VBBpHsySzs/mhF3ipuMp4iAyQMJhHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MT1qp4lv; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747186809; x=1778722809;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vN1EFgkaRl+7nbv1wOzlBd/7NEt4mMSeuKmD+XV8NFM=;
  b=MT1qp4lvckL8HbU4t6etm3UtAvNMP08865Xhab4hmpLgkgLqXR38Um9Z
   Ugklx3cok18mLzofLNoT0JntU1db0PwkDISCagZkEx5j7gAQPtxroVUkz
   2YdEwZmiYYCTEnOSSiJ63xp0XYgh7SOwV8NKdATzzLQwCaO70+GRjnuM7
   17m/wBfWz+DldAOm+ma82Vz2u1jdlzBXD+aDsZ+4xRe95d2ZLhitrdAPN
   TtTNaRvDwC9kIB3RIRQAWWrHwvfBQnOqZcaMxS+rau1sA8WiCCvGyIZ5f
   X2UtKF4+i/m1w3t4cy4XBklWLs+Isj5dmYVAxY9o6T35B/cUVO5OVxhvm
   A==;
X-CSE-ConnectionGUID: +fpf0a7KTlKPTg02254cfg==
X-CSE-MsgGUID: ixyKc1MvRpWrBubiEZrcTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="52873578"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="52873578"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 18:40:08 -0700
X-CSE-ConnectionGUID: gOSP4jsvSM+Hpxn33cfEig==
X-CSE-MsgGUID: qVWByogURzu3L01oILY/ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="142829666"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 18:40:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 18:40:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 18:40:08 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 18:40:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zdryop0JIalHG5polEPv/80hQBYH9aSrNJz60O9J8DujloBXI9Ju7zjpauMg880zk2LnGfYbkojm2+PESUVV7uOCeuRoAlAs6g/av0+PvBAE8Z/8rammS8kTx+QHaPwfe0+svJYctmp1/7TB/rXYUst3gqjAb5O+3ny24T9Ajz9D84LrKLVNB1YhLm2tWa0xux0/rslZA7nb4VDBpSQSLmVc3p5Fdb7yO3zMg5rHXo50r6fmERnu4Gt/64wY3aRygVvnyaAMEGIlgN7ZazPc2LFyTQVXXIXcIDiaDrPZ36KZJfJNmcnnFVrQixnYOMgfCFWvMy7+Cewtie/402LLOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftdps8rWEqysPh+USvHJwRbrcmGQECMNLkHsd7gQ6Wk=;
 b=yDp6D5ZTZHwieqwLj5voVcOuKO4ueUPVuf274WMwXag1zpFz6pBmGDrmdz89f8gpAhStSgDoR9DiYYlWkK6cSNqfLxGy63zt7O6SU3TQe0Uv3fAi0vhmeD18ZQqWkwh2aJz5u7nL1XoOYbxHAP4mdACmANv0nJaOW6yCgelnz+syN+960AU72GOVhSaUo/hLGcLFM9x0Si+Li1z498NTR8te5gqr1lYPAX+p3U862TeL+wAGIDm8E8wH6ZVVCuE2AT3etdk6Pk/F+g1a7O9dw9zS4eABRpjtJtBhcwjNMCcJXxwLHrq+MQGyBvBVTbMvQ6moCdTEBG9zTI7SnS+nCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS0PR11MB7263.namprd11.prod.outlook.com (2603:10b6:8:13f::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.20; Wed, 14 May 2025 01:39:51 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 01:39:51 +0000
Message-ID: <b8a1a09d-5e40-48b7-beb0-6d269bd27a2a@intel.com>
Date: Wed, 14 May 2025 09:39:41 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/13] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBLock with guest_memfd
To: Zhao Liu <zhao1.liu@intel.com>
CC: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-8-chenyi.qiang@intel.com> <aCGsPh/A3sh0dDlI@intel.com>
 <3c4405f4-8d2a-48aa-b92a-f8fee223f1cb@intel.com> <aCMDRoHcoV2PM34W@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <aCMDRoHcoV2PM34W@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0043.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::12) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS0PR11MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ef31c66-782a-4ee5-7b39-08dd9288382b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WC9Gd2hYeWJaNllHV0pySkY0Q3BIM0R2MlVDb3BjeXBBQU94ZEpYd0tUVlN3?=
 =?utf-8?B?RkVwR0kvelNjRTJuNWV4MEorTkJYUGlFNnBtZFhqQ1pLcElKcEV4YWprQ241?=
 =?utf-8?B?TkRnbWRrZUNTWGptUzd5NjJiaVlxTjlsOFdxZkFNOFYxS1daYzNadWhqd0t4?=
 =?utf-8?B?Qk1MZVNPcmFuby9CN3hCL3Q2dy9XU24zcHJXYVhrL3lLb0UyUktoTkhlbS9v?=
 =?utf-8?B?ckZXWk1VNVZTNlRuRTVFa29UblpaRkk1UTBscVhHOERnTHVuSkhuMTRYMzBP?=
 =?utf-8?B?anh4dVBQUVk0bEJaT1MyYlViK0hMK3QrckpVK2tOS3RxbS9OZDdxazFPbDlx?=
 =?utf-8?B?YVRhUmROMGhCQ05Wei8wNEVRVTBLdlJmeDdRUWtnZU9XTUtSMW1uN241VFNR?=
 =?utf-8?B?a2tKTzM5d3VyTGhVS1FjYkt2OWRQdm5oa1RaWUN3SE4vaUd5RkxOcG4zelVR?=
 =?utf-8?B?L1ZpTzh5SnNudzhua2tCMmdBSDN2Z3VVZFRnWmVMKzJ1SGhSb0RxbVk3UUpx?=
 =?utf-8?B?MTVXL1ZRN1FHUmhZMnJNK1pPbzZDcmVUOWRLOTdUSkprSDBlb3hqMDFJMlQ5?=
 =?utf-8?B?UFFVcTQ2elRDQTgzVXRrUmJKS2c2cExzeTBVNEdlekZGekVUam5vK3p0MHpT?=
 =?utf-8?B?R1VlRWJldy9pMndpNFlkaFhoWENCUkhnZFRvSEFCMG8zdFd5cnhWTGJLWVo0?=
 =?utf-8?B?ck9EcVhpMHRLdlB2YUhEM3VESnVxZEZKcFA1bUIvTzFuRG1sUXdPVTBTY0Rm?=
 =?utf-8?B?cHJTaWpOakZuVWF2ZXJYRDNWUzVqaWN4Sy9KbjRhM2hBanVsYUJIOWh5Y3E2?=
 =?utf-8?B?V2YxM2tVb0JFM0ZFbnFDK09USFNpWitjeUNEbk9vaXZaZnVNUWtqSzVNTFJr?=
 =?utf-8?B?cGg0bWVDWlZ4RFNFUkQ5UUtDYkxLaENySFBGTDhyb0pUajEwWlFTbUE4a25m?=
 =?utf-8?B?K3lHTzdzSFJwcjVPWHhqdmZ0T0Y1cnZqZGlob2RHVjFJZHVGU1pNSDJqQmJO?=
 =?utf-8?B?RWpiakhSM2NTNlNtRUVKck5oTWVaT1h3WGpSNUY4cy9vVTFDMnVMZjkxa3or?=
 =?utf-8?B?WnhLL3o3dTF5dndNalJCRk9iRXhsaExya3ZUKzc1eFM5endHdkZ2OE8zbmVX?=
 =?utf-8?B?NmkrNnFNY1ZjeDBaYU91L0h4KzYzM0Z6aE9lTUV0cFBDRnU2WkI2VUpCanpF?=
 =?utf-8?B?OGliaDRWRXlvS1c3dU1Tck9JZXZLVVRrWHFncFBGY2w3OG9wRlJVQjRXRitQ?=
 =?utf-8?B?aEJQM2FZL3RWQ0swN3ZSQlJiOTI0N0hFQUVHMFg4dFdGWjVTcmlFbFVDV1BM?=
 =?utf-8?B?eHZ2NXphVGdmTTFaMFlZcGU5UWdGTmdJQXd1K3NNZ1RiUkVFMXJwelNLWE1X?=
 =?utf-8?B?a3ZsSzJYQ2FwWjhPdnJrMWluR1VpRkZUV29SQnpsTXIrcDcwV0lvVGJJazZk?=
 =?utf-8?B?dFBoOENLMnJmWUpBWkxyZkl1KzBjUjVHcklmbjJnbWxqUnBoTys2amsxQTBt?=
 =?utf-8?B?elFQZmNWVllBamVnSWs4TVJUWWhYVXpSZ096L3MvVCt2SFk3OXdOS3RqV21V?=
 =?utf-8?B?NDFqUHdRUzd1RUlpaFVCZjhXcDVDaEhkb3A4K1VCZCtScmdQclJsQWZoOENZ?=
 =?utf-8?B?NXQzSC9xQU00NjZXa1ZOOVZjQ01VVFQ2U0wzQW94aXFiVTg1QjloOVMvbHhQ?=
 =?utf-8?B?MzB2M2ViMVNsb3BGWGJ5RW51TTVLTnZnaGIwNlAxN2dtV3B3ZWNvTlBPb2F3?=
 =?utf-8?B?N1U3aFNDcjlWUllBM0FpZTF6UkxHejdwbFM4bXJJL1JNdnpnbEtmejd1SlFF?=
 =?utf-8?B?eFJxdStnNVhNZnlhT2ZudjRKN01KWEdhTEp6OWNOWkRZTjNkc29LOVA5S3Zn?=
 =?utf-8?B?cUE1aGFXeWdodHNTNFBIdWRqa215MGFZSXJRK3JRYUlPanVod29aaGJvS0Jz?=
 =?utf-8?Q?3TRGbRfFhAI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG50WlhvT2dIYUJwVkFCMmZYRm9ONUxDS1RObnhMeEUrNm9hdFlXd2xtbjNj?=
 =?utf-8?B?ZUlocnl5M3lsT1Iva0Q4aTZUbmNDUXI4ajJUZ3g2b0VSTnhDMGJmSVFQMS9W?=
 =?utf-8?B?Qm5iQm83QW9XZE5PTlRySUpwdURuOUtkNTBtNG54S3BrQXRpM0JML1JUN3ZN?=
 =?utf-8?B?dER5a0MzS0VNVHNSSkw0TWd3NzZwMFg5UWp2aWFTZkc4bkFDMzdiazRFekJS?=
 =?utf-8?B?WUNjL0d5UWxaRkhwK1lzUEREbkFLZUxIRmlqK3RkUGRMemdlenJiVnhvTHVx?=
 =?utf-8?B?SjVyMFRsVTBBWEhCVTJvM2F4cmFrT045TlRIQzZJWERDMVpYRWY3U1Q0ak5V?=
 =?utf-8?B?dHh6RkZET2NGNzArbmIvVmorakZxNDFBelB5WDBvVkRqZWtMZ0FYVVpoTmh2?=
 =?utf-8?B?NHpiZGxLbXM1c2UwSHpkUW14S2ZoanorQnZINkl1WXhLSlFxaHRJN0hOMVJ1?=
 =?utf-8?B?Zk1mMXNHWjl6N0pIYWxrSG9sUHl3VW9ZT3FBMzV0V1BFQmJXUHZTM0R4cHpy?=
 =?utf-8?B?ZDY0OVdxcnNvendEWDIwNkFZdWlVTTVjK2NOWmh5aWFMamoxSFZXbHFsbVpY?=
 =?utf-8?B?QWVZSk5qdllEejVYbVZYS01aeUZVYTRzVno5cU1KMm54amVueHEzMmw2cFpL?=
 =?utf-8?B?T1ZwV3pxdGUvVnlLQlBZd0RBOU83KzlOS21mQUxKcDlzenFjUnhONldYYzcz?=
 =?utf-8?B?T2toTnVSQXVJSDYzVU52OUxMdkwzQ0ViUWQyWVBiOFgwK1o5UFpPUi9UN0VP?=
 =?utf-8?B?MkZnaVZXOWUzUUVHdUFOUDFqZU5EUStSZ04zQW8yUWtocUVrQjN3V01CM3BL?=
 =?utf-8?B?bUUwNUZpTXZZUlQ0SEV0T1IxbHczcURNSXZybGVpUmdmd09nUDI1STI1bktJ?=
 =?utf-8?B?SXJkNkNIdmpkeXdmeTNUcWJTM3dlTCs0VUhmMS93TDdtVkVWdG1RazNMcmhL?=
 =?utf-8?B?M25xbFFLaGhjaGtxTzB0c0ZOallEWmpuNEFTMXNBek94dmJ0Z3hrZnVVaXVG?=
 =?utf-8?B?MWliQzlwTS9mci9QYzdmMGFwTGluYWZqZ1NMRkp3SUZxOEt3N2R0cGkwL1ds?=
 =?utf-8?B?bDFqSExYS3lSRko4UlBoZEZlcnRPbnhhcVBiUlVjVDYzSHVvQUo0c0ZrOUZi?=
 =?utf-8?B?NGxnVGt3UXoxYldXRnlYS1JqTW5BS2s3TTh5Q1NXdWNQbm5BcUhYRXRVUmI4?=
 =?utf-8?B?dVB4Njc4dzlNMCtsQWdTS2k0UDJTOWtRY0dleHVKZFlNQ1dzSElnZ2VCNS9z?=
 =?utf-8?B?bGFIdnZrWkpVTkVHYUk3WFd0Y2x5aWR5WnFZOGpyZExQdldOTm9oemc4Yzcy?=
 =?utf-8?B?NFhFdWJoazVZbU5IeFVFNHY5dzlRRWhLNC9sSml5YXBkdHpSVWZGbk9lN0Iy?=
 =?utf-8?B?MnFlMFNVaTJHa0xwQTZiZGZyQ0p4aEhOUHA0aGZxSis0L1U2UFpxMTRFRDJC?=
 =?utf-8?B?S0RlZGljbFk3UnBNMDFHSnl4ZjZ0WEhQQkhkelIyaTI3VUJUc3pNd2xuMEdz?=
 =?utf-8?B?cnE4MUNEbXc3NkZ3UUlweXkyKzFTK3lZRHljMXZvWHhqb3JEN3dBN2FmS3Rx?=
 =?utf-8?B?TC81dmtjeTE1c1lleVVVbCtGTDkzcVpqTWl1SmV3NXVLVWtxNHJVWEx2cDAz?=
 =?utf-8?B?QXhIL1I0bmdKbUtjUy8xdlpDcG8rUms2dVVZQk05OHBVUDNHRzRHVCtxckNX?=
 =?utf-8?B?VmNTZmtoY1NCR3NhSm9CdmFSZHJna0IwS2VKaWxNL2V3UmVTYm9zbXJkUkl1?=
 =?utf-8?B?clRqcnVDcW81ZW80c2JjdUpydDh6dXdPOVFnOU13bG5UaSt4cUZYNEY4U25C?=
 =?utf-8?B?R29zcjZHZnhZUnN5akgxTGdLVE9MUmJoL3EwUXA2bEpqc3EzelFad0NpYnlx?=
 =?utf-8?B?dGdpWUZEOFltTUd5VENjWmZVK1ZHczZncS81TVpqVWUrblo0SzAwRjh0RVJs?=
 =?utf-8?B?eXMxNVk0TDdCS1JjRXRqdzVnUFhpSENLVVpoUzVpbHNoY3B1TDRsOHFROWFv?=
 =?utf-8?B?Q1g3RWxrSzI0TTNoUnZSTkNJRzNXZ0h2ZGNSOGo0anVCb0RkZngzazhuaTR5?=
 =?utf-8?B?c2RvdUFJcVVpa3RnbnVPVDNJWVlGMDFBdS8xVUNWVmcrT1Fncnp1RkYrNk9M?=
 =?utf-8?Q?4Bj5vNqOZtPpYMjInYue/lDxh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef31c66-782a-4ee5-7b39-08dd9288382b
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 01:39:51.6201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jh77J6uPS65JdCidpgxmUmyB9i5vM3TTed0f1OtiuILj/xzu6mSuY3Kjs+Z4CPWISPd7NYDlVBXqmvTcriTKcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7263
X-OriginatorOrg: intel.com



On 5/13/2025 4:31 PM, Zhao Liu wrote:
>>>> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
>>>> index 0babd105c0..b8b5469db9 100644
>>>> --- a/include/exec/ramblock.h
>>>> +++ b/include/exec/ramblock.h
>>>> @@ -23,6 +23,10 @@
>>>>  #include "cpu-common.h"
>>>>  #include "qemu/rcu.h"
>>>>  #include "exec/ramlist.h"
>>>> +#include "system/hostmem.h"
>>>> +
>>>> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
>>>> +OBJECT_DECLARE_TYPE(RamBlockAttribute, RamBlockAttributeClass, RAM_BLOCK_ATTRIBUTE)
>>>
>>> Could we use "OBJECT_DECLARE_SIMPLE_TYPE" here? Since I find class
>>> doesn't have any virtual method.
>>
>> Yes, we can. Previously, I defined the state_change() method for the
>> class (MemoryAttributeManagerClass) [1] instead of parent
>> PrivateSharedManagerClass. And leave it unchanged in this version.
>>
>> In next version, I will drop PrivateShareManager and revert to use
>> RamDiscardManager. Then, maybe I should also use
>> OBJECT_DECLARE_SIMPLE_TYPE and make state_change() an exported function
>> instead of a virtual method since no derived class for RamBlockAttribute.
> 
> Thank you! I see. I don't have an opinion on whether to add virtual
> method or not, if you feel it's appropriate then adding class is fine.
> (My comment may be outdated, it's just for the fact that there is no
> need to add class in this patch.) Looking forward to your next version.
> 
>> [1]
>> https://lore.kernel.org/qemu-devel/20250310081837.13123-6-chenyi.qiang@intel.com/
>>
>>>
>>>>  struct RAMBlock {
>>>>      struct rcu_head rcu;
>>>> @@ -90,5 +94,25 @@ struct RAMBlock {
>>>>       */
>>>>      ram_addr_t postcopy_length;
>>>>  };
>>>> +
> 
> [snip]
> 
>>>> +static size_t ram_block_attribute_get_block_size(const RamBlockAttribute *attr)
>>>> +{
>>>> +    /*
>>>> +     * Because page conversion could be manipulated in the size of at least 4K or 4K aligned,
>>>> +     * Use the host page size as the granularity to track the memory attribute.
>>>> +     */
>>>> +    g_assert(attr && attr->mr && attr->mr->ram_block);
>>>> +    g_assert(attr->mr->ram_block->page_size == qemu_real_host_page_size());
>>>> +    return attr->mr->ram_block->page_size;
>>>
>>> What about using qemu_ram_pagesize() instead of accessing
>>> ram_block->page_size directly?
>>
>> Make sense!
>>
>>>
>>> Additionally, maybe we can add a simple helper to get page size from
>>> RamBlockAttribute.
>>
>> Do you mean introduce a new field page_size and related helper? That was
>> my first version and but suggested with current implementation
>> (https://lore.kernel.org/qemu-devel/b55047fd-7b73-4669-b6d2-31653064f27f@intel.com/)
> 
> Yes, that's exactly my point. It's up to you if it's really necessary :-).
> 
>>>
>>>> +}
>>>> +
>>>
>>> [snip]
>>>
>>>> +static void ram_block_attribute_psm_register_listener(GenericStateManager *gsm,
>>>> +                                                      StateChangeListener *scl,
>>>> +                                                      MemoryRegionSection *section)
>>>> +{
>>>> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
>>>> +    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
>>>> +    int ret;
>>>> +
>>>> +    g_assert(section->mr == attr->mr);
>>>> +    scl->section = memory_region_section_new_copy(section);
>>>> +
>>>> +    QLIST_INSERT_HEAD(&attr->psl_list, psl, next);
>>>> +
>>>> +    ret = ram_block_attribute_for_each_shared_section(attr, section, scl,
>>>> +                                                      ram_block_attribute_notify_shared_cb);
>>>> +    if (ret) {
>>>> +        error_report("%s: Failed to register RAM discard listener: %s", __func__,
>>>> +                     strerror(-ret));
>>>
>>> There will be 2 error messages: one is the above, and another is from
>>> ram_block_attribute_for_each_shared_section().
>>>
>>> Could we just exit to handle this error?
>>
>> Sure, will remove this message as well as the below one.
> 
>    if (ret) {
>        error_report("%s: Failed to register RAM discard listener: %s", __func__,
>                     strerror(-ret);
>        exit(1);
>    }
> 
> I mean adding a exit() here. When there's the error, if we expect it not to
> break the QEMU, then perhaps warning is better. Otherwise, it's better to
> handle this error. Direct exit() feels like an option.

Sorry for my misunderstanding. You are right, only warning may cause
unexpected behavior especially after adding a new listener for changing
attribute. Will add a direct exit() here.

> 
> Thanks,
> Zhao
> 
>>>
>>>> +    }
>>>> +}
>>>> +


