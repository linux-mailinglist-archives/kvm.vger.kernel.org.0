Return-Path: <kvm+bounces-47066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 980B5ABCEAD
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 07:36:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA7083BB80C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 05:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90ADB25A339;
	Tue, 20 May 2025 05:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U2C1NkRC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B61829A0;
	Tue, 20 May 2025 05:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747719393; cv=fail; b=RNuWegrZJlqpC9CpE3SCM03bbGt9pq1MgqAKYQkTI0NihRdRdw75DEttbp5Y5XSGfDkBmoW8dM6aPVrS53qAsGOsUevLmPezCbZK4x3oYnG2i4TquOUhNYl/71RWNJejayxxeXavzjt+EPLpx2/xYEp8PWGZIoYeChBgo/jnB3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747719393; c=relaxed/simple;
	bh=Lh2SPZ3P5uKHQJSaKM+sm7aw5htCiG9+g+/5kW8JoAo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rpjkTij6s6fQQ5FjRYn6D6GZJJ98nyo7tzgdqVXNJs/L9qZtRWsOMRTkVzKCGbgFUPtuvmT63pFtPM2v/K/J9NOtBseLXBb0vj93xYq31ydGpvbCKYtPZcC6Iz4moorKWo0W9Nx/ZXlWrFvtrjQIG0dBqnPQxHdT2KJhHHKi1/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U2C1NkRC; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747719391; x=1779255391;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Lh2SPZ3P5uKHQJSaKM+sm7aw5htCiG9+g+/5kW8JoAo=;
  b=U2C1NkRCMRcSPyhCJSZwM0ljSBtVvgZDssbK7F17pvVmighW6lv+qPaF
   i5upILWIV85P7ztVcz/kdc2QGepcZTkKZwXgilSZ5Jod1qpLDD1iItwNw
   3zVCkWi8zzJ0+QWE8gS+rMKee7SSCvmiPC1BnKhqRHoMIKzIq5/ebcnYD
   ZlZhUry6lSE4Xo/h95Futn3fVGPxU/COOTnJ/5oRBSR9SIuvIBXY1xuQC
   ijDGtPXhoU7q3jJ9fSGdLULPfyi8v16RUGVc/KGRYCUgmK26epUzXtnUW
   /8r0UkvqR6n/nNub/MxTp92639xe+rmq0Y3cwd8ooBirgNdzc/v+eXTJx
   g==;
X-CSE-ConnectionGUID: QaXyuYqwSxqgm7y9KZ7aBA==
X-CSE-MsgGUID: OTLtAcpaS4SA8CUUe6qN+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="60674794"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="60674794"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 22:36:30 -0700
X-CSE-ConnectionGUID: ypPLDyEKS825OOOccP5RZA==
X-CSE-MsgGUID: MhhtUV9NSZ+QXCAwEVVbhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="176703545"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 22:36:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 22:36:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 22:36:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 19 May 2025 22:36:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JinozaEJKgDZKqwX3daEtX7rH1Wg4f+8jc5Z0xtVIW9KDCgsSAHYy/3ElfhhdXN6nFk4JNKBMbVpy4tSztYzX+hOdkL0VNbo3rQqxyQSSyLO12lh6AoGBhMayMgwsW/UMFqAfKdu35EB0klOlXaCkZz9Z2ICotKBxBEW/rMZaTRv2VL+VjkCrcmfNRMQC6FPMZCuilMjwurFi0vNizmM2Fr4iq6yW1sO5I2wjHbwVGTblTyNrnW37M9ncp6oj8605xK/HTxSZKTZ2WuQYXcN+ilIncWq/p7grfQSXtzyeAngPi1GGi4MVC0YDJc2icddeLGqnNrkmJjDy8L6Wn4jKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBFgOUOQZjfwX9gsjS+h/yh6FUy4SKs9LAglVa5kVvg=;
 b=LLmJRE0Vk4XghzxyZQl96XU/tmh8QhncxYAKoKD3jf4f94efle96hH0RK1OEUxnPHklsv7sxbTfuKpC8lAaZVRFL9tsv0v1ul+f4NG3MTuCTxMB3FwHXh4h2gu47yqo11qCnCAae9h1Lpa1VT1n9rpOS+RBfN+JJNyAe6QnVyCR2OFOFbXj4s7m4V4uqb28ZqCl8mHVcbmt5C26rhLo7pC1579dJOKVS6gQcaBuCaR1r44DepQEmSXy1Advrl0W6mlrR3O7cp1tSud45Q+v/26P95VTTSWFaopnDRPsILbtNe5BKJ/g9uYm1jlOcYusZwfs2loW8PZ3s6eU8a0bVpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB8064.namprd11.prod.outlook.com (2603:10b6:510:253::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Tue, 20 May 2025 05:35:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 05:35:53 +0000
Date: Tue, 20 May 2025 13:33:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Reinette
 Chatre" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for
 fault retry on invalid slot
Message-ID: <aCwUO7cQkPzIe0ZA@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
 <20250519023737.30360-1-yan.y.zhao@intel.com>
 <aCsy-m_esVjy8Pey@google.com>
 <52bdeeec0dfbb74f90d656dbd93dc9c7bb30e84f.camel@intel.com>
 <aCtlDhNbgXKg4s5t@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aCtlDhNbgXKg4s5t@google.com>
X-ClientProxiedBy: SI2PR01CA0046.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: e2bbc65f-7dac-4915-1ab1-08dd97602fca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?iAIJzHRrJbwn8uuaZEIucM+ym2hTalxXOBAcmprRUISck9W1Vw+mFWQMFD?=
 =?iso-8859-1?Q?wpmTRMsoezHUBiZzez/i18Sqiti+4b2mYYdKDesVxtg6Itu03DfmChL59i?=
 =?iso-8859-1?Q?0sqI/8Tk3zRIej90CAqsLSdCpm62X6fpsWMuDrcNVPnpMJOER7ApPawxeT?=
 =?iso-8859-1?Q?gTiWPZLVDpQZ4tsuYpQtvnvK1A9e5Fnhe3AS3dNvihSuTJXUN4E2QOUffn?=
 =?iso-8859-1?Q?xBX33Jaa+aYbuWIKSYX3kbJ7nCj4RLnRfp1/Nd4hCS8S4VnZNg/lknujRO?=
 =?iso-8859-1?Q?RE2OG6JzY2bFgiZ1d70/DiZ2kXORjxPQ0R2NKeE9K2ZakvyuvDwcVb57Ms?=
 =?iso-8859-1?Q?ZwpsJ3bXS32GO8AINSdRo9V6SVZdziqdJoA44WRs2fx2XK1sr0d62NxUu+?=
 =?iso-8859-1?Q?FS7M2NyTLK5s1DsT4OqWyXtftAxq6Z4XR828GOGz81A0Z5XeK5m97FUNAf?=
 =?iso-8859-1?Q?cptu/Ua2cwZ4IbWFIQ+hBmCtzXeHr2LSpcYYlKiYyRx4fD5dqdPkvV30Xb?=
 =?iso-8859-1?Q?OD1F7z0fgkUmcxtLoI5b9YeImsRBkk4jOw0d5HN4WJBkzcbDa3FYbACSZP?=
 =?iso-8859-1?Q?lI4BCp+lPP5DyDJmYd2GRycZClbJnUqy4MO7R6fSuVeTIo3ZO0VbmHKnMz?=
 =?iso-8859-1?Q?E1IWyv5E6HyunZMAoDvbFtNhHdAm5aWitFEyE0R9KRsytdFz6IPVZ3VyPB?=
 =?iso-8859-1?Q?X0J6Xi6QMKrphy9KAvRCotGCRJO1XOheLstU9STeEAHF2Zh4QB4eABYiHn?=
 =?iso-8859-1?Q?iGUqF4bw8NSSRC2YdrWdGVRDjWYrAsnbmhzOlPkUeilh5g9rpt9mHNtMVO?=
 =?iso-8859-1?Q?0K1tarXyLSszokEU/fgFd9sUPSrJavoP/ROgDcTXrSxEu5w9SqSV+BVH9E?=
 =?iso-8859-1?Q?BQaRZpXzeh0JF1HDYDiPEyB0JCodsdXJrP2GUZGNCkqOBo7eNW9X8PR9dg?=
 =?iso-8859-1?Q?dzNs0ulUzwYi2gMprN8o8buisnbGU92aOND8gmJHEkVdoq2j5Dzvat31aD?=
 =?iso-8859-1?Q?nOE7mGyDOeqCoJ4gu8WLDx9F1mS12aZkuS9och7et3aIwLXAb6pjkGYmL1?=
 =?iso-8859-1?Q?8tLBhfHEp6pBQ6uKiyJFpWm26kF57bHbVyLBwCFO+0ilrVq5xwP3cWmctU?=
 =?iso-8859-1?Q?jXfovFbPaKz0FJF3edJTitsEYEzT0N8TwyvZvD7ogGKg6YHmGnTYh1RNfl?=
 =?iso-8859-1?Q?e6Yx94LUSWEhmK07UJGPlb/ulRI3C5UFp+DTUwQ0lOh+oc/MFZhfeCNXL/?=
 =?iso-8859-1?Q?hzNTaCt6aAdrlIPtoQtspCABjz7J3dv5ItMMJw6WY/NVBf1yLU4HfXXnF4?=
 =?iso-8859-1?Q?hRAmddfrP6469F/Nh67FVsWTEUdrU8Riz8KoVk1yE/qIgu19JdYIBu+L9t?=
 =?iso-8859-1?Q?GOaP6xh44OqqZGtGQnslFk+ybx2cAgIihxWFfTsNIRZhEo7LJ3hC3zyBxH?=
 =?iso-8859-1?Q?BYEePOENcxWgOXD+hOrTVmWNN/yhMIBBQjMFT/KOhC21SOS6+ymsYdceXr?=
 =?iso-8859-1?Q?I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?2yFVgIzIStd3Vnk/TBfCXKQkjz4M5P94C7X5IjXd15NiPB6DuKDECQLyL3?=
 =?iso-8859-1?Q?Xyp0kP2Y5dCC8SDrsJca9p0TbdtgkTMPyWXuEareHkxi0CX387hfKRDTDr?=
 =?iso-8859-1?Q?KRiCPE6Hw7osr5PJcUF5X42XLmC1TOT4DF7US7wpJEPo4bCVznzhPgdLqv?=
 =?iso-8859-1?Q?mfs1aIVY3ZP3PSDmBvsGMTYMWzT31Y5Gq+7f5yrtSuUxBlfg4DP1oZLVy0?=
 =?iso-8859-1?Q?azFLkHXZWgBBPo+sIkivBbcFgSSVHTKCWTPiZN/wsiMZW4G8vk5Jz2akv0?=
 =?iso-8859-1?Q?NZb67gCqax+WKzZLso47biYwqFPSol3CjT1aYu2P9cR9mQCCwxiYnzDkY3?=
 =?iso-8859-1?Q?BKt0KUfvuVlzDxmpfkJ1b8J6NhnpVd5HPcddIEO7BErPQJZo1XM/b72MVC?=
 =?iso-8859-1?Q?d6XPnGDMo2OD/HFKOt6x03Fn2iTzHF1fewchSIPUZ6L/J5pxVFavPSh+yC?=
 =?iso-8859-1?Q?Jm50A1KZuop88KGOcyl5BOdcBSl5k7Creqwy0z53AHIz+5fOAujRkahgms?=
 =?iso-8859-1?Q?aNCcxOCpzLE+CmOtfxo4H8QzvkMVYQICK6pZudzv+eJAPU9fVVl1qxAK9D?=
 =?iso-8859-1?Q?VmPlS3y+d2WOPRhC9SwEwrD0X7102K8QJ+1/1A96NS2UZ5kxIxfCVuiHSm?=
 =?iso-8859-1?Q?Vssm9YBKKdxYUNXWUIjcndQTgv7MFUHHaIKgss7Qim0AWtj1UnsSq03DMZ?=
 =?iso-8859-1?Q?wsy+oB34X7NzrRIldDCITuZ2voM0S10MqWIirQnNMevhwk7UbmKsf5uQeE?=
 =?iso-8859-1?Q?aXWgd2atorRbW6wzZ3cQ0nbnhY8wrG3TLVrLc/4lyzZ4sBQiK0z9X7d2ia?=
 =?iso-8859-1?Q?Qj1xvFtMKaVeXIJTNO6qpsJmnY0zhEibsMV+idUxsaoGlDuJrLRSxWN07+?=
 =?iso-8859-1?Q?moQnwdObtUp3I+g5WBPH2W6ySx2j9j+9JLZDwPhQTQraT1jfBRrbJGOfBJ?=
 =?iso-8859-1?Q?PCKs2DW6lLa/c39cshUhaFY/L8T5qjHkG+2ueglByNx4SnapMsrKsC0oao?=
 =?iso-8859-1?Q?r+YmHXYZjws7vFQ8hudV26xDcjAEVim0e6jVYHhWuFPM1MsdnHHOd3hCsz?=
 =?iso-8859-1?Q?FaW84DcEkLIAPsaIau57eNQbIZZ5cLPvyHd5/oUFfHauik8Nj05/QZAKiw?=
 =?iso-8859-1?Q?o19SHf5EwQu53UCz50z8Lwu5bdp9Z0J+lk+uAaDU3hjCukRLGhrGgaa0vE?=
 =?iso-8859-1?Q?1KtM0f0LJXE45ofYJ3LLB+O3JhrvS76Fr0EIejKOvrkiK61JGwZ4XS4vty?=
 =?iso-8859-1?Q?DdbhJdQPbzl5xVZrS3jM8icafqeBD1INVkzNSFocd/n0ZVXQJOLGJL3RA1?=
 =?iso-8859-1?Q?MDZtF/T9m3jrvXNqjyeGavIhIbuSKrh8PJ2rJS59eF1racXtrMbVD20ufy?=
 =?iso-8859-1?Q?ZBnJcMK/JQPEWzoUETlgPHQ4o5z/BTDsUOTA04qku2ZdaXV0gLxE01et7z?=
 =?iso-8859-1?Q?nAOiirGDMvROCrPsC9/VN7jv2v3tsx6CMnzbyHhohZlgs/WQNRo3fFUZHd?=
 =?iso-8859-1?Q?iTuQ1FBocBQmnnRseI6LAy5ploY/Rtg98guN7r15DIeEUTuFK0LDig1N6N?=
 =?iso-8859-1?Q?vSgQ+ePfec38qyxkVTHkzSc8RfyqNb6/3gWJRFxcScJYaJiYbG782yFnu6?=
 =?iso-8859-1?Q?58iScRFmp4o3OnQEExP6yvmwG3Aq72b1hY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2bbc65f-7dac-4915-1ab1-08dd97602fca
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 05:35:53.2151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OrWaHySTTM/qHLhvzSpzHF0bXidWk4nIYAvQxd4fvhOekWoQYU4Yn6MGDpv+yJrnETw4c590G5orISnMT0RQ7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8064
X-OriginatorOrg: intel.com

On Mon, May 19, 2025 at 10:06:22AM -0700, Sean Christopherson wrote:
> On Mon, May 19, 2025, Rick P Edgecombe wrote:
> > On Mon, 2025-05-19 at 06:33 -0700, Sean Christopherson wrote:
> > > Was this hit by a real VMM?  If so, why is a TDX VMM removing a memslot without
> > > kicking vCPUs out of KVM?
> > > 
> > > Regardless, I would prefer not to add a new RET_PF_* flag for this.  At a glance,
> > > KVM can simply drop and reacquire SRCU in the relevant paths.
> > 
> > During the initial debugging and kicking around stage, this is the first
> > direction we looked. But kvm_gmem_populate() doesn't have scru locked, so then
> > kvm_tdp_map_page() tries to unlock without it being held. (although that version
> > didn't check r == RET_PF_RETRY like you had). Yan had the following concerns and
> > came up with the version in this series, which we held review on for the list:
> 
> Ah, I missed the kvm_gmem_populate() => kvm_tdp_map_page() chain.
> 
> > > However, upon further consideration, I am reluctant to implement this fix for
> 
> Which fix?
> 
> > > the following reasons:
> > > - kvm_gmem_populate() already holds the kvm->slots_lock.
> > > - While retrying with srcu unlock and lock can workaround the
> > >   KVM_MEMSLOT_INVALID deadlock, it results in each kvm_vcpu_pre_fault_memory()
> > >   and tdx_handle_ept_violation() faulting with different memslot layouts.
> 
> This behavior has existed since pretty much the beginning of KVM time.  TDX is the
> oddball that doesn't re-enter the guest.  All other flavors re-enter the guest on
> RET_PF_RETRY, which means dropping and reacquiring SRCU.  Which is why I don't like
> RET_PF_RETRY_INVALID_SLOT; it's simply handling the case we know about.
> 
> Arguably, _TDX_ is buggy by not providing this behavior.
> 
> > I'm not sure why the second one is really a problem. For the first one I think
> > that path could just take the scru lock in the proper order with kvm-
> > >slots_lock?
> 
> Acquiring SRCU inside slots_lock should be fine.  The reserve order would be
> problematic, as KVM synchronizes SRCU while holding slots_lock.
> 
> That said, I don't love the idea of grabbing SRCU, because it's so obviously a
> hack.  What about something like this?
So you want to avoid acquiring SRCU in the kvm_gmem_populate() path?

Generally I think it's good, except that it missed a kvm_mmu_reload() (please
refer to my comment below) and the kvm_vcpu_srcu_read_{un}lock() pair in
tdx_handle_ept_violation() path (So, Reinette reported it failed the TDX stress
tests at [1]).

As this is not a bug met in real VMM, could I play with this fix for a while and
come back to you later?


> 
> ---
>  arch/x86/kvm/mmu.h     |  2 ++
>  arch/x86/kvm/mmu/mmu.c | 49 +++++++++++++++++++++++++++---------------
>  arch/x86/kvm/vmx/tdx.c |  7 ++++--
>  virt/kvm/kvm_main.c    |  5 ++---
>  4 files changed, 41 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index b4b6860ab971..0fc68f0fe80e 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -259,6 +259,8 @@ extern bool tdp_mmu_enabled;
>  
>  bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
>  int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
> +int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> +			  u8 *level);
>  
>  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cbc84c6abc2e..4f16fe95173c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4851,24 +4851,15 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
>  {
>  	int r;
>  
> -	/*
> -	 * Restrict to TDP page fault, since that's the only case where the MMU
> -	 * is indexed by GPA.
> -	 */
> -	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> -		return -EOPNOTSUPP;
> +	if (signal_pending(current))
> +		return -EINTR;
>  
> -	do {
> -		if (signal_pending(current))
> -			return -EINTR;
> +	if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
> +		return -EIO;
>  
> -		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
> -			return -EIO;
> -
> -		cond_resched();
> -		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
> -	} while (r == RET_PF_RETRY);
> +	cond_resched();
>  
> +	r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
>  	if (r < 0)
>  		return r;
>  
> @@ -4878,10 +4869,12 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
>  	case RET_PF_WRITE_PROTECTED:
>  		return 0;
>  
> +	case RET_PF_RETRY:
> +		return -EAGAIN;
> +
>  	case RET_PF_EMULATE:
>  		return -ENOENT;
>  
> -	case RET_PF_RETRY:
>  	case RET_PF_CONTINUE:
>  	case RET_PF_INVALID:
>  	default:
> @@ -4891,6 +4884,28 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
>  }
>  EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
>  
> +int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
> +{
> +	int r;
> +
> +	/*
> +	 * Restrict to TDP page fault, since that's the only case where the MMU
> +	 * is indexed by GPA.
> +	 */
> +	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> +		return -EOPNOTSUPP;
> +
> +	for (;;) {
> +		r = kvm_tdp_map_page(vcpu, gpa, error_code, level);
> +		if (r != -EAGAIN)
> +			break;
> +
> +		/* Comment goes here. */
> +		kvm_vcpu_srcu_read_unlock(vcpu);
> +		kvm_vcpu_srcu_read_lock(vcpu);
For the hang in the pre_fault_memory_test reported by Reinette [1], it's because
the memslot removal succeeds after releasing the SRCU, then the old root is
stale. So kvm_mmu_reload() is required here to prevent is_page_fault_stale()
from being always true.

[1] https://lore.kernel.org/all/dcdb3551-d95c-4724-84ee-d0a6611ca1bf@intel.com/

> +	}
> +}
> +
>  long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				    struct kvm_pre_fault_memory *range)
>  {
> @@ -4918,7 +4933,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	 * Shadow paging uses GVA for kvm page fault, so restrict to
>  	 * two-dimensional paging.
>  	 */
> -	r = kvm_tdp_map_page(vcpu, range->gpa, error_code, &level);
> +	r = kvm_tdp_prefault_page(vcpu, range->gpa, error_code, &level);
>  	if (r < 0)
>  		return r;
>  
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b952bc673271..1a232562080d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3075,8 +3075,11 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	if (ret != 1)
>  		return -ENOMEM;
>  
> -	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
> -	if (ret < 0)
> +	do {
> +		ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
> +	while (ret == -EAGAIN);
> +
> +	if (ret)
>  		goto out;
>  
>  	/*
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b24db92e98f3..21a3fa7476dd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4266,7 +4266,6 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
>  static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				     struct kvm_pre_fault_memory *range)
>  {
> -	int idx;
>  	long r;
>  	u64 full_size;
>  
> @@ -4279,7 +4278,7 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  
>  	vcpu_load(vcpu);
> -	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	kvm_vcpu_srcu_read_lock(vcpu);
>  
>  	full_size = range->size;
>  	do {
> @@ -4300,7 +4299,7 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  		cond_resched();
>  	} while (range->size);
>  
> -	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +	kvm_vcpu_srcu_read_unlock(vcpu);
>  	vcpu_put(vcpu);
>  
>  	/* Return success if at least one page was mapped successfully.  */
> 
> base-commit: 12ca5c63556bbfcd77fe890fcdd1cd1adfb31fdd
> --
> 

