Return-Path: <kvm+bounces-34341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F3009FACD6
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 10:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C5637A075E
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 09:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27C9190054;
	Mon, 23 Dec 2024 09:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BVyt+HzM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF9F2B2CF;
	Mon, 23 Dec 2024 09:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734947311; cv=fail; b=k0yUFBmD5b2FuFH0AFgj5Xa2iyJaEmzlkJDVCK3PlrzfV5j/+bacnz/Pzczq6SPBnrW2sISJ571sVcV+XdS0ukW08at7K6LmbMtnnpFrx0Qw4qCmi6alUeueYjoPvw6XUdUsoBLe0ROarV/MYGRHZNvW5+o2CTvvcfN75Ygk/iI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734947311; c=relaxed/simple;
	bh=2fzLnf3gmiq1YHQvp1H+3ZoQ+g6ns4Muw2BGkJCAIRg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QEcy7ACGiW0gCKt64PQdckup+e7flLVbk2/ThX/j/E8gMfDTvui/Zm42daFTLQka5PCk12pNS4vYbniBc0gFYrvScPek+NenF/8AXZEuOV1BpaFeMaKX1vgsvz+iT/U7GZGP4yUlRU6oIggK6sOrrD4KDy76BnTAXUX6H9Gy0RM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BVyt+HzM; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734947309; x=1766483309;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=2fzLnf3gmiq1YHQvp1H+3ZoQ+g6ns4Muw2BGkJCAIRg=;
  b=BVyt+HzMivm9nEyw8obg5alg4nf3Qr0p8H/yVJErZY0x+abzL02HTuz2
   z6hyJCTRdMpg5O9/nIo5RXArQBNCZRX9GYqKZiNy9SwRNYkJcCWsQFD2d
   +T+tgZGcWzSmltqnDXdZSTozjtSVF+fyaysh0NosMd7SZRJBktPuvjKWQ
   ZuHDsiKLWvCTPeSmo18TYvsQGcBxJmLzCOXsezJUe0HW8GGyaUvB6SZO9
   udAIpzy1RYnvWaG9iMZ5tMbHF9kcmo24GWhkHFpBCNgGiovwlMlbnse+H
   A1I28BYW9wexZLJ5u9GgzQ17Hz6H/JmaD2P8IWDMwlhfZdPCzBErPepsb
   A==;
X-CSE-ConnectionGUID: 8EuxE5rKSVqZtYQ5WTt+aA==
X-CSE-MsgGUID: 8C2WP3afQzWDXkkYafV/hA==
X-IronPort-AV: E=McAfee;i="6700,10204,11294"; a="35546037"
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="35546037"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2024 01:48:28 -0800
X-CSE-ConnectionGUID: Lr07J0HwS8G7Oe76IkfZlA==
X-CSE-MsgGUID: 65GOITWXTrCuENQImp7Iog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="100011578"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Dec 2024 01:48:27 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 23 Dec 2024 01:48:27 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 23 Dec 2024 01:48:27 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 23 Dec 2024 01:48:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g1ymjRMGcxM7UFsvW7gJfQRiHsksXzgJ5jtAYJ8BqFpj2E8uYs0uenfa8YCEu9E8ov+Rxh0WAB9OrXKdeSjzUldlpu6dWcdyCjlzicGqvxJL9YVZM2MfEladZaHa7yGyF+BFK7CyYMxMtHpmpP2ux/kyUZSZ9Mwhni7zJiXRX/t8OMuLJd7Kc5tElyRN/w/Qzn33SXmZqL1G9fFqpLpsfHkm0vlZULUlJ/iDObw8EJaX+sMlI8rt7EBxe3XfMOl11LKqsmCj7MI7wvV3WDvIZxr+Pf6Le5poq7w99T9PypM296Y+FQpWHld636w+su/aen8gP3Aqq09DcxPVka19Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pyUqjWPZhxhv22SDAM2T4IBHPM/rmmSsApL5wgyFRzk=;
 b=aeXuKKCSERvSiFC0rMR0vHfmSkTyflLGMRTsTMc485busEJCshdOcNCAxGyh7k0ilBAlO8FysQzi6D0j7W0JyCHb8pitacX0/HCwSPEESWSOQi2rPaNWM+5pV+tM0Cdg+kPHaiZyTDReWprv1DGmJzKijl6L57aCYklwIPIRuNNIOaURrSSUxsvoQmqgsuSdSUCDUfHUHO7hehGhi1++swq3XT3jetS4raXGHRaux6FLzhpA2jiWSt1ugUKuS3m5j6sJ3/y5CtfCUm9YRJ8GxFIZYpj9vsuIsoZGZAZipdK3+kk690FQ3Z1UuwLRrx/KNw+Y+fFkOxmyqv4dwVTUcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6406.namprd11.prod.outlook.com (2603:10b6:8:8b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8272.19; Mon, 23 Dec 2024 09:48:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8272.013; Mon, 23 Dec 2024
 09:48:21 +0000
Date: Mon, 23 Dec 2024 17:13:59 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<binbin.wu@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Only zap valid non-mirror roots in
 kvm_zap_gfn_range()
Message-ID: <Z2kp11RuI1zJe2t0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241115084600.12174-1-yan.y.zhao@intel.com>
 <CABgObfbukWu5srwDGA-orsd35VRk-ZGmqbMzoCfwQvN-HMHDnw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbukWu5srwDGA-orsd35VRk-ZGmqbMzoCfwQvN-HMHDnw@mail.gmail.com>
X-ClientProxiedBy: SG3P274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::30)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 0902378a-1b89-4766-e4ab-08dd2336ef94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MEExOXRqSzFqOFVSV2w1aGVUaDVrOExFclE1RWgrRmFnSjdZVkVtcVhiQlRt?=
 =?utf-8?B?TEZmZkJWd3I5MGRNTXM4MmNZbU5sb0gzcllpaVE5Wlgyelh1WXFpTWZXOWU2?=
 =?utf-8?B?Y010QkU5YkM4akhLd1kyejZaakJSS21KczRSaWNnU0hjQ2VwdnpBSHE3Q0I2?=
 =?utf-8?B?S09GWnB3YklnSUxqems1dWZoTWJqUHBuS1o2dmFKOU1HQm9UeURjN084bnF4?=
 =?utf-8?B?c1QrTXYrcVh4U2N0bVk2a0Q1S040TnFqTDJHZWdocXBSK0oxRDJqYkYyTkV0?=
 =?utf-8?B?WUNFUVIzUFFnZ2x0RXNERGFGakdlbGkrd24rQ0NLY2NDdnY5NWJIcnN5ZGFZ?=
 =?utf-8?B?YStHUE1oNk8zdmtMRGdnNU1RZGU2VGVlWTFFRHFmaTY1YXJ5a3R3dG5IdjZl?=
 =?utf-8?B?WURSQjRVWGkrS203bmhPSHB5S0g3QnpiZy9HckJUYS9KUTl5ZUlUU0pzejMx?=
 =?utf-8?B?T1k3YkhUdVprYjBzNy8wSXUyYjM4QzBleXFoWFVZSXZ4amw5QmRKb1VFL1Y3?=
 =?utf-8?B?eXZnblNrano1cjlRcDhJVzFlYmZLclU2OGZ1NkRMMlAza29Oc09VQWNveTky?=
 =?utf-8?B?bklmUFpTN29TVnQvQTRtUGhjUTRqL0RoWUllR0Y4M3M1Skk2dU9DRjZGTStF?=
 =?utf-8?B?Z3VkeVdPMU0yMEwvWGFxd1VFQU5raVZDT3Q5ZjlPRXNLdnFmd0hseEpRTXpu?=
 =?utf-8?B?RU83RXNBUFlCemY5SVg0K2FTTGZYN3Y3djVaeTJJYlRjSWFFRkZLanlGZERw?=
 =?utf-8?B?N2tCQlZaRGtUNThvTjZXRHdBVzlxVmVScmhCSHNTNGFDY0pjSFNLZUZUd2ZZ?=
 =?utf-8?B?U25NRHJnbWpwTEV1Uk9BeFlsUmpTVzJ4LzJEeWJVL0RtdlZaZnhyODhDNUVs?=
 =?utf-8?B?OWhSLzEvQ1pBM0lTeSsvbWN6RkI2Z1V6Q0pZNXJLS3dqV2t5YWNHTmptSUpj?=
 =?utf-8?B?aWdUOGIydndrdXI0RU52RVJ2OHlQTDcrTGZGOFN0S0R2YTViUUEzV1IvbFRZ?=
 =?utf-8?B?d25TTUphNkhOUk9PY3JNY3F0T1ZzRkdBazc1Rmt2TytOL0RicTNCYUNyNFJh?=
 =?utf-8?B?UTdFTHVGT0E2dDIwcjFwVDMyaGwrWm93aUY0ZU1FZE9pclArdHNBVGhVb0Jh?=
 =?utf-8?B?N0pkT09QOVQ0OEpmSnZHME04MERIdytvZ2ZYQmhuZGRBUUZLTEZId2JydUUy?=
 =?utf-8?B?Q2JiWGhla1pTaTFCTVlHcGNpaWNLQVlUUmZzOGxKMFk4UmdOZmUzdWhwUkJH?=
 =?utf-8?B?WW9LUUs0RU1wdzZ2YUlIdzVRakxYZ3hOT0ttYW04L2oyaGsvR3ZLeVorNGo0?=
 =?utf-8?B?cnBMU3BxTXQ4OXFMQlE3aXlwQjhIZzF0SkRDdVFXTm1qRjh0NWxndHBtTk0r?=
 =?utf-8?B?U0RoaDIwL2xHRlREazNrbGlNcDlySmduMkJma21ndHEyV21vSWIySWJySHQ4?=
 =?utf-8?B?dVUrQW9Vcll6bUhialJtcEdJRU9DYWtnVzVSdU9jNXFucmZRYkRrWkVwQk85?=
 =?utf-8?B?M1V6bzg2RnlWVXpGdTNscHZFSGdPRkFlVUFxQWtxS21qS0FEMDg5Q1BabnI1?=
 =?utf-8?B?S1kraXR4YWkxWnZIRERhNjR0SW95K1pOUnQ3bVBUUHNMMmQwa0JoZTVCbCtQ?=
 =?utf-8?B?cWF6Y0xxdDlYWWd1VHFEeitEQUN6Z1dmRVd6OWtZYXpIaHM5UHN4SFdFMjBP?=
 =?utf-8?B?MkhpZGp6U2FTa2VVcXRwTGNVQTNKOGJiNVV0QzVDR0N1TXk5L2U2NC9yQW9w?=
 =?utf-8?B?VUZzZXQ5VzVWbjZ5czJqeG9XZ1M3ejlUQWxpa3h5N2Z3bE91VVlsM0lkVEpS?=
 =?utf-8?B?c2pxQWxxSW0xYXh5VFlJTVNHOC9qTUMxRkMvY2IreVhiRndTakdhV1ZOeFN1?=
 =?utf-8?Q?jlZpYodKb4tU5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFAzTGE1SWw2NGRJZjY0UTQwT3VvaENvN3dPZlBCeTRQb1F0QTdQNHZsbGdh?=
 =?utf-8?B?S2xza0lSSHlyeG1zWGlqcHk4c0VMSVpNQ2xnRDU5VmpvbGwvZ0s4UlZEYzU5?=
 =?utf-8?B?TXF4YXpld1pCYWZHSzZIMTBBQ0lzZSt0UU5lc1ZIV2dGL1FhRXZ5cGl4RnZR?=
 =?utf-8?B?WGxxWm8zbTcxS25lN3VsdmFYcGJCd2JqbUphR3UxUEZoL0haVllNRi8xWFNX?=
 =?utf-8?B?dWFFdU9Bc3ZBR3NzbnhZY2ZIZWVJOW9WNkxsb1dmQ0dFR2EwWm1HcDZMcXNH?=
 =?utf-8?B?TFhPblRYT0JQRTZGQnplbkZGbHVWaUw5eVV4K0FUSWNiTXFSNmZOZ2FoQnJB?=
 =?utf-8?B?VDdEb21yeEJFNjZYWU0wQTZEVXVwNzRjWmczTlF2eXlTL2FycDM2MzkvZzZ2?=
 =?utf-8?B?VDcrYU9HYXRqWC9qU21OT0ZZZnJ4d0ZaOTNHVHUrY1RHM3lJbmJPMzhDdE8r?=
 =?utf-8?B?MUl0T05Nc1ArTjFrc3k3bDgrU3BBYmFmeTkwUTdERHJ4emxyRE5OUDhleExi?=
 =?utf-8?B?aFNvUi95VG93MGdQQytCbG10bmJyT0RzTjBwTEFJcEJqV1ZDejZIajYvYnZP?=
 =?utf-8?B?WGYxeFh3YVYxYzh1QkI2d3BSWlhkbERtdkhqUWJOVi9TVG1LN2V5YndBOHFx?=
 =?utf-8?B?cS96b2FqOTR0RFd3ajdheGU4M2ZsZzRnUjJQblBDMTVSUnhJcWhPNkhpd3k1?=
 =?utf-8?B?WFJPQ210d3JKa01sR2VNWGpEYmpyNCtyTnMwMkFSWElEWmlaaHpDMjJWSGU1?=
 =?utf-8?B?aXl2bXVLMlJVWTlYbXpRSHg2bExpcWFQcGVGM3RsbjFBTnZDeDJ2dGVyRUc3?=
 =?utf-8?B?YmVaVkRNMmsxUHVhaDJ1NWJvRWtldkxPLzRGRDc5UmRWbHozVjJsMUZITUlh?=
 =?utf-8?B?WlFuYVpTRjJFcGZQRk5vejZKTTVGbW1DbEg5RXdKK3N4OUxLQzVteVVCUVhl?=
 =?utf-8?B?MXlZaWgzUkdwT0dGSjYxQ0dWUUFVSk91RHI1T3orQ01IZ1FiR2dOUlZvR3Mx?=
 =?utf-8?B?c2RkUFhDTTBjeUlZRGZwMk42WndzWmEzb2hEeHo5b045TU00WXdYWUJ1SWdE?=
 =?utf-8?B?QnJTZ0ZxbSs2OHE2UHMzbTRkNW1ENnZFS3dZWHNESGxVV0MrcC9RQ0xJS0tF?=
 =?utf-8?B?WWJlSVFJeCsrazNkUTFPUzk1R0FxbjZJemRaaDJ2aHNCdE5GUzlRb215eCtR?=
 =?utf-8?B?dW91MlhUUWlqYUpWL0trUGloUTZhcWo1ZWFlL21mNXRuSkJZd1p2SEZIdWhZ?=
 =?utf-8?B?N3FDT0FPbXFWdWlXblZTeDBadkJJalhtemF0K1NaeVp5TmNFQVdMYUNqaFBk?=
 =?utf-8?B?WkZtY2Fja2NkbU9vU1NoQjNnQktLdlVUejY2RkN3VHBBaXpheG4xdndtSmZS?=
 =?utf-8?B?Nzl0TGZqc01ScUN4VzFEWjhsRThBaVBCS1V0NFQ1Vm84YTMrbjdPNFJYRXkz?=
 =?utf-8?B?L2pVSzF0TzNtQitJcEtGM1BVTWVYN1lSdm9NN1lGb0VQNDZudWhoSHpDSkMw?=
 =?utf-8?B?b0c2ZWRNMkFBc250anRSRy9VZlZxVmsxaHNtblB0WXFuODRpMkpWaUZ6T0d5?=
 =?utf-8?B?ZnNoNUlVZXRnK0FKSUt2engvcHM0MmdZQUR3cGJNTHVGeFlZR1JnbGRmU1BE?=
 =?utf-8?B?RGRSWmlwZ29PaVQrbG9RWktuSWpoNEl0MXcxNmd6VDFkSHZ1djN0TEtGNEZI?=
 =?utf-8?B?K1kxOHl1UnFiMTZiR1Z4Y1pBYzFNdVNSUDhUNDBvRGNCZ3ZoR2FCYjRFR1hr?=
 =?utf-8?B?QmZkYXY5NldxMklrYjhSb0N1a2c4a2k1RVdFcnRBcVhKS2U0Zm5veksrVzRF?=
 =?utf-8?B?MUpxdVVDYkZZdFFOSUxjSUVOdjFjbXd2dEtNU1haZGlyTDF0OWFSMEJIZ0hQ?=
 =?utf-8?B?UFFNSmI5L1JtUjRMRnMxVXJyQTBaNytlc3AzdnN4K1NZMVRaTFhpV0E5NDNz?=
 =?utf-8?B?dUNJQkxMckwyR3hFTFFWU1VBSEZVcTdQNDRpUmQvNEExRFdFMWF2dm1wVVRH?=
 =?utf-8?B?RGFKQ0hZNFZsSG0zU0JoR1JoTERhZVpuRTBzRXFsWDRQbjJISGNzVFRLejdm?=
 =?utf-8?B?bGNDTUZMY2VuZ3d1eXBrUXArVjlzNDc3MlJwckV6OUdoT0lVZWw0YVErVW0r?=
 =?utf-8?Q?bSn5mRBV84uIx0U71CRSOBRrW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0902378a-1b89-4766-e4ab-08dd2336ef94
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2024 09:48:21.2439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbxfadZGCfFqsYxGIro22kz9SLA7B6wBHVmt7/hOK4eo8OIaTSLF6aCbJwxMikCwG0cxCH9yYooaQ9a8fqcncg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6406
X-OriginatorOrg: intel.com

On Sun, Dec 22, 2024 at 08:28:56PM +0100, Paolo Bonzini wrote:
> On Fri, Nov 15, 2024 at 9:50 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > Sean also suggested making the self-snoop feature a hard dependency for
> > enabling TDX [2].
> >
> > That is because
> > - TDX shared EPT is able to reuse the memory type specified in VMX's code
> >   as long as guest MTRRs are not referenced.
> > - KVM does not call kvm_zap_gfn_range() when attaching/detaching
> >   non-coherent DMA devices when the CPU have feature self-snoop. [3]
> >
> > However, [3] cannot be guaranteed after commit 9d70f3fec144 ("Revert "KVM:
> > VMX: Always honor guest PAT on CPUs that support self-snoop"), which was
> > due to a regression with the bochsdrm driver.
> 
> I think we should treat honoring of guest PAT like zap-memslot-only,
> and make it a quirk that TDX disables. Making it a quirk adds a bit of
> complexity, but it documents why the code exists and it makes it easy
> for TDX to disable it.
Thanks! Will do in this way after the new year.

