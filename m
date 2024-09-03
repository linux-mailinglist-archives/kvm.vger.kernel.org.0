Return-Path: <kvm+bounces-25802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B09196AD12
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 01:52:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A196EB21980
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC77A1D79A0;
	Tue,  3 Sep 2024 23:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oKrancZv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BA4126C0B;
	Tue,  3 Sep 2024 23:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725407508; cv=fail; b=f39GM8L2sgUeEmhlCRQjQ6Vxu4f41Droh0extzpmZp25e4fAjUCbplnVD91xTqtuOKVe1J4wUQ0WD45CXpWH8ppXrpjEAS05Zn/rtYmwyd2Y1O69roLILYL7VWd/7kq6vjUO6fZ7/41JdJfmhcJ8IRtcxYOprFu6MQR0ktciNHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725407508; c=relaxed/simple;
	bh=UwVjNhOwPRAlvA+OZ3JRKar2Z1HrQ4hHiJtO1NhzdMM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bk2YwwVeShtyXVaipLQf1WONF6CZvottSNU5v4HrWlxmwcqWf/ZUVCjKCHqk5bOJbCNnAkqldeXrQn9en6Dvt3OnTHRMcLeaq9qfZkFExXM69G087PvhDcY+3NNdPpwWnB7KMFFC6dtxJsj4z2DEB7HzZ3pQGeZLe6w9aev6LZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oKrancZv; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725407506; x=1756943506;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=UwVjNhOwPRAlvA+OZ3JRKar2Z1HrQ4hHiJtO1NhzdMM=;
  b=oKrancZv/CXBPab5UffWVD7eB1+QhBOyWP/aYfnxELbnJJAfpA8hv0EJ
   NN3CV+bQnYgQICVN460Ttk8djsVCMlAGiV5XvdxTKWUz9U5uCSs/8eqzF
   2JgcI22yq8FZc1pB3/UPPniTpFlfdPHC4c6p6UNITGKmBCpW3ncaffNXz
   8jKVF5AmYx7keqGLGfWhsaZqvN5yTbmHZdnjhQtfpM2pKy8eHrow37ktc
   QUlNxkcNlJczDPQP6FqIYXcN36zyppxoHiNibrWsNTkmPYLBaaS/Iks+s
   ipxPQrrMCwN84pHMUVZBH0kyiDwiCgbLLEAqd2aOubRBDOzoSs7+07vwT
   w==;
X-CSE-ConnectionGUID: M112Tf/sT8afttfI9M9wpg==
X-CSE-MsgGUID: o+5huTC4So2uxIaVavnzrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="13357254"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="13357254"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 16:51:46 -0700
X-CSE-ConnectionGUID: HdExd37eRj6ubBzhnOnh3w==
X-CSE-MsgGUID: W5u2evlDTxO8zdXUjft8/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="64896536"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 16:51:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 16:51:44 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 16:51:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 16:51:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 16:51:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8SJwGnuK2iXqYbwq0Yj0GfFCHlHPm73W8abaarwkpacL/WTKnKtV4whYWRKF1A5KBcmMWnwDcB2vRDPZ3U7ismbKIcyFPe0AlphMFEOVEJhKi0p1O5+J6Z++8LtUVJ4KYdDiZtLnXZQR2cXxE7R9y0iSqftoKJDLSu0z3rSE1W2NNWzeYicHzTtKj1kX56Z6zdf+qmrAJ8d9EiG92UhCUd20bDI3+lhdbb4q8JGD89zR7Jv/Gvw3L0cX7v/QHiqjdiFg5YZhLriqOH3VbIsgsXbJwGkIioAD2RZdCeLbTv4AGBfN8uilYj/cE59CeW4OYvzRJFp5Cj/Bu69LPlzyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RHoLjh3ZFa9hET5hnqLKHBKrucN5zRhAxJELymct6M=;
 b=ssDYrANAkMJpd58XEWmqEiB40uqiHH1ROuSwC4E7g4xRFACZaX6/EXg+pc7kHUQZdjqEjrmymcwGF9DFJ8ug6KYONMO/JwBMH/0Xl++b9QLHTE4KuR5OKfkLa9jb6LdkJ6ejl6FlvPccqeoe2kH+/IXGOyRwP4nDmYVe9bMQsb5rfuFQ5MGIzjdKejRBWf7/Pd1xoNkez0c6IgnZRM7QgeNapoonNiWC00H5dBcH6LOCs4raDh/ULpSvTryvCwWFYdf3EINhCaQmMqGISWYBJlzKV0+feMLv9zDfVQCIoNkdN5vOOAmZQXTE9dbvkzAMddGS8i4roadC2Auin88WKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW4PR11MB5933.namprd11.prod.outlook.com (2603:10b6:303:16a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 3 Sep
 2024 23:51:41 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 23:51:41 +0000
Date: Tue, 3 Sep 2024 16:51:38 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Message-ID: <66d7a10a4d621_3975294ac@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240823132137.336874-8-aik@amd.com>
X-ClientProxiedBy: MW2PR16CA0045.namprd16.prod.outlook.com
 (2603:10b6:907:1::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW4PR11MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: fed952fd-1c3c-4eef-48ba-08dccc735bd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z3FWSkF2S05wSE4xNHhGb1BFSmMwOENDK3ljc0tiSDgvZzBPbmhRK2hjekxY?=
 =?utf-8?B?bTQ5MWNxbEcxYWQ3bk9laHZiUUI3Y0dUeDJFSUFXNmZhOWZVTlJZbE5KYUVW?=
 =?utf-8?B?c1YzbDhMT0Z0TlNhZ3hRVmd3VkR2bFd5WS8wcVUxYmVZQk44d0FKSDltYzd4?=
 =?utf-8?B?NjJTZjRKV0pkZnZtM0VCaTBSY1UzSzZQRlZYdHl4UUlFSjFIcDJraFk0MXpu?=
 =?utf-8?B?U3dBUWc1Y1pKUTJHMWZQUnJ4Slg5NkwvbTFtZ3NGNk0zdURNcFFHV3lXbUtV?=
 =?utf-8?B?RGZKL1gyaEJvUVZEVHd3NVFsZXBab3RYeDdKa2s3cFJLVVU0dCs2T1YrU3dv?=
 =?utf-8?B?VTBrZHgreWpmQmxMSXFjb2dXQVZUN3dwM3Yyd2hvcHNsOFV0Y1BVajNDR0ps?=
 =?utf-8?B?WFRZLys1SkUzSExFMy9SR3lNT1hjUytzNDdBZ1N0STVjZDNSODg3enZzekIv?=
 =?utf-8?B?czcrdGQ4Y3ArVmlWdVBzWWpjYlVUb3NMRGorZjRycnl0aVNqeWxoZFZXdytN?=
 =?utf-8?B?b0Vlc285MjI2S1pWc25GTmFEVmZkeDJEdGhHL1J2NC9nbEw1NVEwR3lpMlh3?=
 =?utf-8?B?S29QelEyeWNGKzMxMldDNFlKYTQrWU5YNm5hRVNQem5xN3FpVVA4ZG9ySFg4?=
 =?utf-8?B?Q2hLQ0ZMektvNWlrbnZQaEtWTHAyUjRIbDF1aDVJNy9OU0Q2cGU2VXA3b2lB?=
 =?utf-8?B?U0NwVmRLVFV3alZzc2RyclhDN2xGVkJZdTQrZldiQlQzSnBHOUZXOUhsQTd4?=
 =?utf-8?B?RklRWHFUcTA5WlVBN2lQeTc0YkZvQjJFckloT3BOUWdaRDdtREYyYXBmQi9V?=
 =?utf-8?B?RzNXYlE1QmhkRE5FUTNDMjRYZVRoZnpuOTFHRTJTbTVHZXVMbG5TTG5oc1NT?=
 =?utf-8?B?UE9DTXFuUUpkYUY5VjRjOGtzTDR0NDgvNkMyaDhkVEVuTU9oQmpRMzllYWhi?=
 =?utf-8?B?SW5RSXI5b1RqQmxRZHQrWklZY0tOVjc4Z2lLSWlHUGRyNXJ2cFIzYVBZNEh4?=
 =?utf-8?B?b0liYVpTKzZ1UE5kUnZUSnhUUjZiRUM1Rlk2VWFRalJGV3JuZ1ZJd0w2dmxB?=
 =?utf-8?B?R1VBRXJOdlRZRHVBUTFlbmNpYXRRR0x5S0ZaM2RsYzBuazNONzNubk5kUUNS?=
 =?utf-8?B?Q0VoU0c1d1BWbmt6TWVQaUh4M290TWx0S0RnK2wvVEFjSSt1ckUvV2ptN1hK?=
 =?utf-8?B?Ulh1Um9YOXBOamcvdmVkTHVITkxYTGlFTlBBUHBKQUN2L000K1I5S24rK243?=
 =?utf-8?B?TEtDMGRYUXBrTTZpdktkNGdrQWczaXZIeFdPL0ZGQVAycnFLVVBXNjJTeGJp?=
 =?utf-8?B?ZzlMSEJEZGE4a3FRQzdCRnNOR1ZoNExxdmc2RE16TGUvZzI2UHdyWU82SmU3?=
 =?utf-8?B?anV0SVYxMUJiZUQzOU1pRCtMc3JTaWJxeU12WUVBcng2T1dvRW51cW5QZzV1?=
 =?utf-8?B?YStEYUpKUGtzaFIyNDMvTUJoUjdBVVNIMXI5MFh4OVhmV1h0aGF1MmRORG02?=
 =?utf-8?B?eTNGSmtvZkFNZFdJZ1pjRWFtVGYya0J5Z2NJV0ZCc2NLSkJnMkpoc1JDOW92?=
 =?utf-8?B?VThiRHZVVk1NbWh3RWFKeVlldUVnekdWV0MzUnJUcUVNRGFaVDk2VVpsTXNT?=
 =?utf-8?B?OFRLVkQrVCs4ZzRIVVlINHdmVms5cDY4RGRBL05zTkdoOVlzcnZZUDV5TjQv?=
 =?utf-8?B?MEViR1Q0aTVNOEtxbytwcllIZmE3T05tYnk2ZDRkdjhoM1krR0tSeHpLeitX?=
 =?utf-8?B?VnN5eWpqQzZiMTF3ajY4blJ2bXVxdktiMytZUS93WWhnNkh4YUNCUlJSaHRv?=
 =?utf-8?Q?8IDUHWCrHHVGMQh4wCPDx9yZ6NdUi4SjUFVZQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFdhbFluMXE4MjNrSGxNd1RYdmhna2lteGgxMzVPcXkwZ0xvd1JxcWV1cnBq?=
 =?utf-8?B?WnlVYmZEZFRoc3Q3YU9DemREY1NRNjcwMDhSdzNRaUJFNnNKRzBMaHMwajY3?=
 =?utf-8?B?bmxQM2hvWXpMMDIyR0VUNDZNbEt1enNLSTJ2bU5TOCtaak1COUtlYi9zdm43?=
 =?utf-8?B?L3lGUkNJUWRtaXcwdnJWNHdvb3owaW9jSlNNS1hoYW5kMGpFZUZobU9LSHNz?=
 =?utf-8?B?NGZydXArMFlhOFJFQUJQamxQa0Nkb0JQa1d4TkU4aXAwVTJhdEFXeGl6SXZR?=
 =?utf-8?B?NFpiVFZDWlllcXk4K0hmSnFIOFU0TXZ5WUlDT3lkQS8wdmNxYlZJMmpDYXhr?=
 =?utf-8?B?eUppM1JuMWxsWUhYazVmYi9rckJ4SnBKZmErM3U5bk1ZZlpHVHc4bURoQ0dZ?=
 =?utf-8?B?alVNUElSUGhzd3laSTZTdWUwd00xWkQwMWdwa05Wd0x0eE4yY2EyUWpPR00x?=
 =?utf-8?B?b0NIS1g2R2pEL00wMDA4Z2Z1MndNeEV5d3BMV0xabDg3ZFE3T2hBSy9WbWNl?=
 =?utf-8?B?b0NuYStvbnNMTVVqaXZtOG81b1VQTi82OHlZTHN4Q0JtSEt3Rnh3Q1JQUGtN?=
 =?utf-8?B?WndFeVdYYnRCeCsrYXBlQUgvYVE1ampmUU83azJXVGxxaVNFRzdkNktOZFhR?=
 =?utf-8?B?bk1QbytSQTd0bWMzSitiUld6MDU5SHpxaWZZOTM0TWZWY2FCcXJiclRDR0tY?=
 =?utf-8?B?TmdBSjgvc24xSXczVnlibFNjUXAxMWlMSnpoT0ZZYURpMjZSTlRCbWFPanRm?=
 =?utf-8?B?US9vUVdHNVNXTEU2djdBWlJ0Qm9PdTBzbStRVXhvdXpOc3E3RmRUYk1MeFcx?=
 =?utf-8?B?VndsdDhMeDBVMERXcjRia0tDT2Vqa3o5UTdUSkRHTnQ5ZEM2QkZiNzF4WjlP?=
 =?utf-8?B?NHJYV3AyaTNya3NOR3VteUJqUk5ndG9MQ09DQWhMS0FjR1pqby81MlJDMCtY?=
 =?utf-8?B?RzJXc1JtNklGNUtCajlaQ0tGL0N5enVoZ2xSSWdqMTE1eDVIQTFFM0dER0NL?=
 =?utf-8?B?MHkwUWp3dy9MaVdqRWFnMllOVFltanRkeDZrV2JxNmxCUytYeFY1NlpSc1Nq?=
 =?utf-8?B?ZHVmYy9vUW82Z0F0RlJJWGVzalcxM3J1V1h0STRvUVlnalVOYjdRdGlOZVJt?=
 =?utf-8?B?aUlsVkFSWlNrNzlsQXRQZVdMaktaVC9iRHFTanc5SFBkc0ZJZTdMSWFabDdJ?=
 =?utf-8?B?b2kwaXg2OU8wRTUwamd0Q05wdHJJNm5wUCtpS3pjVG1Td3ZLdWVkVDJzL2Ix?=
 =?utf-8?B?Zmp5bThESVc3bUg2bmxtTlBtUlgwdWN4OUJYcmxvaThaTVVKL2l4aVlPWjRI?=
 =?utf-8?B?TDJIVVFSVEVpUmZQQ0JiY2JZRVBaODZkSmYxdGgwZHAzY3dKQlVOTFBNdmJr?=
 =?utf-8?B?ZG55ODVLdVNUaFFTbjNhN1FaRGpUVVhYU1RlNFZpM0RaUlkwTm1aYjVYQkxn?=
 =?utf-8?B?NENmUnZlS0ZXVkFQYVNGeTJOSWVEb2FCR2hoUTV2ekltL1BvNERWMm5oMnFS?=
 =?utf-8?B?VVhRYmVhRUtIRkZoYTliUVF0dXBmY3djZGhwVEVXNzdheDJaakd5VjROWGJj?=
 =?utf-8?B?ZFpCSEVmSGFDVGV5MnppUVJpZzdqa013YkhVZHZYRjN6V2w4cktHYUZseHVv?=
 =?utf-8?B?NmowdmEvZDhZcWZNaVdUSitCRW1QODQ4RzZOdi9nS0JXeE5uL3FRQ2gyd1Uz?=
 =?utf-8?B?TExUaXRJZ0JlVWNRdXhrVlFVdjE4OUpDSXB3UHVJbFI3M3R0blhUWjJTekov?=
 =?utf-8?B?TDg3NXZwOElaMkFiZC9LemtQMC9yckFsN2J6T09IMDBPZlZ2a3paMkZzTXZn?=
 =?utf-8?B?SytRaTk3VHNGQzFUY1JIL1ZCem5TSFYyUmFCM294ME9rWVRUa0dGdDcxRFZG?=
 =?utf-8?B?UGxVRkY4NHFnLzFlbHBhVHF4OXFtUDFsN1RlTTRzZ0NhT2IvbW43dk53aWFo?=
 =?utf-8?B?c2p0bFhyb2cxM3I3TlZWV3cvaXh5cHNYZXkxWUoyamF5NklsYkxmZFJjZWlK?=
 =?utf-8?B?QlZzZGw2aENLenBvcWdpVDdNVG9CcUV2WXBESzZiTjBDSm9kQ2pVZGEvWnFs?=
 =?utf-8?B?VVgyNjBYOE5lSlhqRUtnV3NwYytob0pvU3JqUitzOXFIYk5qaXlJTmxlQzZV?=
 =?utf-8?B?UHVsN3ZLeFNKeUQ3alhTcDI3OWFQWkxaK0l3KytwV2x4MnNvYmpzRkFMQ00w?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fed952fd-1c3c-4eef-48ba-08dccc735bd2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 23:51:41.5592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8FHCXg4urHt9uw2Y5IiyzQPxy5Pbo20PMBsyE3ury40kOvhw69hRT5kkVmnnofunU1w97CmtL8tcmzwDwe9zwCOVo/G9Xxi3nOqVvmWk0gw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5933
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> The module responsibilities are:
> 1. detect TEE support in a device and create nodes in the device's sysfs
> entry;
> 2. allow binding a PCI device to a VM for passing it through in a trusted
> manner;
> 3. store measurements/certificates/reports and provide access to those for
> the userspace via sysfs.
> 
> This relies on the platform to register a set of callbacks,
> for both host and guest.
> 
> And tdi_enabled in the device struct.

I had been holding out hope that when I got this patch the changelog
would give some justification for what folks had been whispering to me
in recent days: "hey Dan, looks like Alexey is completely ignoring the
PCI/TSM approach?".

Bjorn acked that approach here:

http://lore.kernel.org/20240419220729.GA307280@bhelgaas

It is in need of a refresh, preview here:

https://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux.git/commit/?id=5807465b92ac

At best, I am disappointed that this RFC ignored it. More comments
below, but please do clarify if we are working together on a Bjorn-acked
direction, or not.

> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  drivers/virt/coco/Makefile      |    1 +
>  include/linux/device.h          |    5 +
>  include/linux/tsm.h             |  263 ++++
>  drivers/virt/coco/tsm.c         | 1336 ++++++++++++++++++++
>  Documentation/virt/coco/tsm.rst |   62 +
>  drivers/virt/coco/Kconfig       |   11 +
>  6 files changed, 1678 insertions(+)
> 
> diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
> index 75defec514f8..5d1aefb62714 100644
> --- a/drivers/virt/coco/Makefile
> +++ b/drivers/virt/coco/Makefile
> @@ -3,6 +3,7 @@
>  # Confidential computing related collateral
>  #
>  obj-$(CONFIG_TSM_REPORTS)	+= tsm-report.o
> +obj-$(CONFIG_TSM)		+= tsm.o

The expectation is that something like drivers/virt/coco/tsm.c would be
the class driver for cross-vendor generic TSM uAPI. The PCI specific
bits go in drivers/pci/tsm.c.

>  obj-$(CONFIG_EFI_SECRET)	+= efi_secret/
>  obj-$(CONFIG_SEV_GUEST)		+= sev-guest/
>  obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx-guest/
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 34eb20f5966f..bb58ed1fb8da 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -45,6 +45,7 @@ struct fwnode_handle;
>  struct iommu_group;
>  struct dev_pin_info;
>  struct dev_iommu;
> +struct tsm_tdi;
>  struct msi_device_data;
>  
>  /**
> @@ -801,6 +802,7 @@ struct device {
>  	void	(*release)(struct device *dev);
>  	struct iommu_group	*iommu_group;
>  	struct dev_iommu	*iommu;
> +	struct tsm_tdi		*tdi;

No. The only known device model for TDIs is PCI devices, i.e. TDISP is a
PCI protocol. Even SPDM which is cross device-type generic did not touch
'struct device'.

>  	struct device_physical_location *physical_location;
>  
> @@ -822,6 +824,9 @@ struct device {
>  #ifdef CONFIG_DMA_NEED_SYNC
>  	bool			dma_skip_sync:1;
>  #endif
> +#if defined(CONFIG_TSM) || defined(CONFIG_TSM_MODULE)
> +	bool			tdi_enabled:1;
> +#endif
>  };
>  
>  /**
> diff --git a/include/linux/tsm.h b/include/linux/tsm.h
> new file mode 100644
> index 000000000000..d48eceaf5bc0
> --- /dev/null
> +++ b/include/linux/tsm.h
> @@ -0,0 +1,263 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef LINUX_TSM_H
> +#define LINUX_TSM_H
> +
> +#include <linux/cdev.h>
> +
> +/* SPDM control structure for DOE */
> +struct tsm_spdm {
> +	unsigned long req_len;
> +	void *req;
> +	unsigned long rsp_len;
> +	void *rsp;
> +
> +	struct pci_doe_mb *doe_mb;
> +	struct pci_doe_mb *doe_mb_secured;
> +};
> +
> +/* Data object for measurements/certificates/attestationreport */
> +struct tsm_blob {
> +	void *data;
> +	size_t len;
> +	struct kref kref;
> +	void (*release)(struct tsm_blob *b);

Hard to judge the suitability of these without documentation. Skeptical
that these TDISP evidence blobs need to have a lifetime distinct from
the device's TSM context.

> +};
> +
> +struct tsm_blob *tsm_blob_new(void *data, size_t len, void (*release)(struct tsm_blob *b));
> +struct tsm_blob *tsm_blob_get(struct tsm_blob *b);
> +void tsm_blob_put(struct tsm_blob *b);
> +
> +/**
> + * struct tdisp_interface_id - TDISP INTERFACE_ID Definition
> + *
> + * @function_id: Identifies the function of the device hosting the TDI
> + * 15:0: @rid: Requester ID
> + * 23:16: @rseg: Requester Segment (Reserved if Requester Segment Valid is Clear)
> + * 24: @rseg_valid: Requester Segment Valid
> + * 31:25 – Reserved
> + * 8B - Reserved
> + */
> +struct tdisp_interface_id {
> +	union {
> +		struct {
> +			u32 function_id;
> +			u8 reserved[8];
> +		};
> +		struct {
> +			u16 rid;
> +			u8 rseg;
> +			u8 rseg_valid:1;

Linux typically avoids C-bitfields in hardware interfaces in favor of
bitfield.h macros.

> +		};
> +	};
> +} __packed;

Does this need to be "packed"? Looks naturally aligned to pahole.

> +
> +/*
> + * Measurement block as defined in SPDM DSP0274.
> + */
> +struct spdm_measurement_block_header {
> +	u8 index;
> +	u8 spec; /* MeasurementSpecification */
> +	u16 size;
> +} __packed;
> +
> +struct dmtf_measurement_block_header {
> +	u8 type;  /* DMTFSpecMeasurementValueType */
> +	u16 size; /* DMTFSpecMeasurementValueSize */
> +} __packed;

This one might need to be packed.

> +
> +struct dmtf_measurement_block_device_mode {
> +	u32 opmode_cap;	 /* OperationalModeCapabilties */
> +	u32 opmode_sta;  /* OperationalModeState */
> +	u32 devmode_cap; /* DeviceModeCapabilties */
> +	u32 devmode_sta; /* DeviceModeState */
> +} __packed;
> +
> +struct spdm_certchain_block_header {
> +	u16 length;
> +	u16 reserved;
> +} __packed;

These last 2 struct do not seem to need it.

> +
> +/*
> + * TDI Report Structure as defined in TDISP.
> + */
> +struct tdi_report_header {
> +	union {
> +		u16 interface_info;
> +		struct {
> +			u16 no_fw_update:1; /* fw updates not permitted in CONFIG_LOCKED or RUN */
> +			u16 dma_no_pasid:1; /* TDI generates DMA requests without PASID */
> +			u16 dma_pasid:1; /* TDI generates DMA requests with PASID */
> +			u16 ats:1; /*  ATS supported and enabled for the TDI */
> +			u16 prs:1; /*  PRS supported and enabled for the TDI */
> +			u16 reserved1:11;
> +		};

Same C-bitfield comment, as before, and what about big endian hosts?

> +	};
> +	u16 reserved2;
> +	u16 msi_x_message_control;
> +	u16 lnr_control;
> +	u32 tph_control;
> +	u32 mmio_range_count;
> +} __packed;
> +
> +/*
> + * Each MMIO Range of the TDI is reported with the MMIO reporting offset added.
> + * Base and size in units of 4K pages
> + */
> +struct tdi_report_mmio_range {
> +	u64 first_page; /* First 4K page with offset added */
> +	u32 num; 	/* Number of 4K pages in this range */
> +	union {
> +		u32 range_attributes;
> +		struct {
> +			u32 msix_table:1;
> +			u32 msix_pba:1;
> +			u32 is_non_tee_mem:1;
> +			u32 is_mem_attr_updatable:1;
> +			u32 reserved:12;
> +			u32 range_id:16;
> +		};
> +	};
> +} __packed;
> +
> +struct tdi_report_footer {
> +	u32 device_specific_info_len;
> +	u8 device_specific_info[];
> +} __packed;
> +
> +#define TDI_REPORT_HDR(rep)		((struct tdi_report_header *) ((rep)->data))
> +#define TDI_REPORT_MR_NUM(rep)		(TDI_REPORT_HDR(rep)->mmio_range_count)
> +#define TDI_REPORT_MR_OFF(rep)		((struct tdi_report_mmio_range *) (TDI_REPORT_HDR(rep) + 1))
> +#define TDI_REPORT_MR(rep, rangeid)	TDI_REPORT_MR_OFF(rep)[rangeid]
> +#define TDI_REPORT_FTR(rep)		((struct tdi_report_footer *) &TDI_REPORT_MR((rep), \
> +					TDI_REPORT_MR_NUM(rep)))
> +
> +/* Physical device descriptor responsible for IDE/TDISP setup */
> +struct tsm_dev {
> +	struct kref kref;

Another kref that begs the question why would a tsm_dev need its own
lifetime? This also goes back to the organization in the PCI/TSM
proposal that all TSM objects are at max bound to the lifetime of
whatever is shorter, the registration of the low-level TSM driver or the
PCI device itself.

> +	const struct attribute_group *ag;

PCI device attribute groups are already conveyed in a well known
(lifetime and user visibility) manner. What is motivating this
"re-imagining"?

> +	struct pci_dev *pdev; /* Physical PCI function #0 */
> +	struct tsm_spdm spdm;
> +	struct mutex spdm_mutex;

Is an spdm lock sufficient? I expect the device needs to serialize all
TSM communications, not just spdm? Documentation of the locking would
help.

> +
> +	u8 tc_mask;
> +	u8 cert_slot;
> +	u8 connected;
> +	struct {
> +		u8 enabled:1;
> +		u8 enable:1;
> +		u8 def:1;
> +		u8 dev_ide_cfg:1;
> +		u8 dev_tee_limited:1;
> +		u8 rootport_ide_cfg:1;
> +		u8 rootport_tee_limited:1;
> +		u8 id;
> +	} selective_ide[256];
> +	bool ide_pre;
> +
> +	struct tsm_blob *meas;
> +	struct tsm_blob *certs;

Compare these to the blobs that Lukas that maintains for CMA. To my
knoweldge no new kref lifetime rules independent of the authenticated
lifetime.

> +
> +	void *data; /* Platform specific data */
> +};
> +
> +/* PCI function for passing through, can be the same as tsm_dev::pdev */
> +struct tsm_tdi {
> +	const struct attribute_group *ag;
> +	struct pci_dev *pdev;
> +	struct tsm_dev *tdev;
> +
> +	u8 rseg;
> +	u8 rseg_valid;
> +	bool validated;
> +
> +	struct tsm_blob *report;
> +
> +	void *data; /* Platform specific data */
> +
> +	u64 vmid;
> +	u32 asid;
> +	u16 guest_rid; /* BDFn of PCI Fn in the VM */
> +};
> +
> +struct tsm_dev_status {
> +	u8 ctx_state;
> +	u8 tc_mask;
> +	u8 certs_slot;
> +	u16 device_id;
> +	u16 segment_id;
> +	u8 no_fw_update;
> +	u16 ide_stream_id[8];
> +};
> +
> +enum tsm_spdm_algos {
> +	TSM_TDI_SPDM_ALGOS_DHE_SECP256R1,
> +	TSM_TDI_SPDM_ALGOS_DHE_SECP384R1,
> +	TSM_TDI_SPDM_ALGOS_AEAD_AES_128_GCM,
> +	TSM_TDI_SPDM_ALGOS_AEAD_AES_256_GCM,
> +	TSM_TDI_SPDM_ALGOS_ASYM_TPM_ALG_RSASSA_3072,
> +	TSM_TDI_SPDM_ALGOS_ASYM_TPM_ALG_ECDSA_ECC_NIST_P256,
> +	TSM_TDI_SPDM_ALGOS_ASYM_TPM_ALG_ECDSA_ECC_NIST_P384,
> +	TSM_TDI_SPDM_ALGOS_HASH_TPM_ALG_SHA_256,
> +	TSM_TDI_SPDM_ALGOS_HASH_TPM_ALG_SHA_384,
> +	TSM_TDI_SPDM_ALGOS_KEY_SCHED_SPDM_KEY_SCHEDULE,
> +};
> +
> +enum tsm_tdisp_state {
> +	TDISP_STATE_UNAVAIL,
> +	TDISP_STATE_CONFIG_UNLOCKED,
> +	TDISP_STATE_CONFIG_LOCKED,
> +	TDISP_STATE_RUN,
> +	TDISP_STATE_ERROR,
> +};
> +
> +struct tsm_tdi_status {
> +	bool valid;
> +	u8 meas_digest_fresh:1;
> +	u8 meas_digest_valid:1;
> +	u8 all_request_redirect:1;
> +	u8 bind_p2p:1;
> +	u8 lock_msix:1;
> +	u8 no_fw_update:1;
> +	u16 cache_line_size;
> +	u64 spdm_algos; /* Bitmask of tsm_spdm_algos */
> +	u8 certs_digest[48];
> +	u8 meas_digest[48];
> +	u8 interface_report_digest[48];
> +
> +	/* HV only */
> +	struct tdisp_interface_id id;
> +	u8 guest_report_id[16];
> +	enum tsm_tdisp_state state;
> +};
> +
> +struct tsm_ops {

The lack of documentation for these ops makes review difficult.

> +	/* HV hooks */
> +	int (*dev_connect)(struct tsm_dev *tdev, void *private_data);

Lets not abandon type-safety this early. Is it really the case that all
of these helpers need anonymous globs passed to them?

> +	int (*dev_reclaim)(struct tsm_dev *tdev, void *private_data);
> +	int (*dev_status)(struct tsm_dev *tdev, void *private_data, struct tsm_dev_status *s);
> +	int (*ide_refresh)(struct tsm_dev *tdev, void *private_data);

IDE Key Refresh seems an enhancement worth breaking out of the base
enabling.

> +	int (*tdi_bind)(struct tsm_tdi *tdi, u32 bdfn, u64 vmid, u32 asid, void *private_data);
> +	int (*tdi_reclaim)(struct tsm_tdi *tdi, void *private_data);
> +
> +	int (*guest_request)(struct tsm_tdi *tdi, u32 guest_rid, u64 vmid, void *req_data,
> +			     enum tsm_tdisp_state *state, void *private_data);
> +
> +	/* VM hooks */
> +	int (*tdi_validate)(struct tsm_tdi *tdi, bool invalidate, void *private_data);
> +
> +	/* HV and VM hooks */
> +	int (*tdi_status)(struct tsm_tdi *tdi, void *private_data, struct tsm_tdi_status *ts);

Lets not mix HV and VM hooks in the same ops without good reason.

> +};
> +
> +void tsm_set_ops(struct tsm_ops *ops, void *private_data);
> +struct tsm_tdi *tsm_tdi_get(struct device *dev);
> +int tsm_tdi_bind(struct tsm_tdi *tdi, u32 guest_rid, u64 vmid, u32 asid);
> +void tsm_tdi_unbind(struct tsm_tdi *tdi);
> +int tsm_guest_request(struct tsm_tdi *tdi, enum tsm_tdisp_state *state, void *req_data);
> +struct tsm_tdi *tsm_tdi_find(u32 guest_rid, u64 vmid);
> +
> +int pci_dev_tdi_validate(struct pci_dev *pdev);
> +ssize_t tsm_report_gen(struct tsm_blob *report, char *b, size_t len);
> +
> +#endif /* LINUX_TSM_H */
> diff --git a/drivers/virt/coco/tsm.c b/drivers/virt/coco/tsm.c
> new file mode 100644
> index 000000000000..e90455a0267f
> --- /dev/null
> +++ b/drivers/virt/coco/tsm.c
> @@ -0,0 +1,1336 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/pci-doe.h>
> +#include <linux/pci-ide.h>
> +#include <linux/file.h>
> +#include <linux/fdtable.h>
> +#include <linux/tsm.h>
> +#include <linux/kvm_host.h>
> +
> +#define DRIVER_VERSION	"0.1"
> +#define DRIVER_AUTHOR	"aik@amd.com"
> +#define DRIVER_DESC	"TSM TDISP driver"
> +
> +static struct {
> +	struct tsm_ops *ops;
> +	void *private_data;
> +
> +	uint tc_mask;
> +	uint cert_slot;
> +	bool physfn;
> +} tsm;
> +
> +module_param_named(tc_mask, tsm.tc_mask, uint, 0644);
> +MODULE_PARM_DESC(tc_mask, "Mask of traffic classes enabled in the device");
> +
> +module_param_named(cert_slot, tsm.cert_slot, uint, 0644);
> +MODULE_PARM_DESC(cert_slot, "Slot number of the certificate requested for constructing the SPDM session");
> +
> +module_param_named(physfn, tsm.physfn, bool, 0644);
> +MODULE_PARM_DESC(physfn, "Allow TDI on SR IOV of a physical function");

No. Lets build proper uAPI for these. These TSM global parameters are
what I envisioned hanging off of the global TSM class device.

[..]
> +/*
> + * Enables IDE between the RC and the device.
> + * TEE Limited, IDE Cfg space and other bits are hardcoded
> + * as this is a sketch.

It would help to know how in depth to review the pieces if there were
more pointers of "this is serious proposal", and "this is a sketch".

> + */
> +static int tsm_set_sel_ide(struct tsm_dev *tdev)

I find the "sel" abbreviation too short to be useful. Perhaps lets just
call "Selective IDE" "ide" and "Link IDE" "link_ide". Since "Selective"
is the common case.

> +{
> +	struct pci_dev *rootport;
> +	bool printed = false;
> +	unsigned int i;
> +	int ret = 0;
> +
> +	rootport = tdev->pdev->bus->self;

Does this assume no intervening IDE switches?

> +	for (i = 0; i < ARRAY_SIZE(tdev->selective_ide); ++i) {
> +		if (!tdev->selective_ide[i].enable)
> +			continue;
> +
> +		if (!printed) {
> +			pci_info(rootport, "Configuring IDE with %s\n",
> +				 pci_name(tdev->pdev));
> +			printed = true;

Why so chatty? Just make if pci_dbg() and be done.

> +		}
> +		WARN_ON_ONCE(tdev->selective_ide[i].enabled);

Crash the kernel if IDE is already enabled??

> +
> +		ret = pci_ide_set_sel_rid_assoc(tdev->pdev, i, true, 0, 0, 0xFFFF);
> +		if (ret)
> +			pci_warn(tdev->pdev,
> +				 "Failed configuring SelectiveIDE#%d rid1 with %d\n",
> +				 i, ret);
> +		ret = pci_ide_set_sel_addr_assoc(tdev->pdev, i, 0/* RID# */, true,
> +						 0, 0xFFFFFFFFFFF00000ULL);
> +		if (ret)
> +			pci_warn(tdev->pdev,
> +				 "Failed configuring SelectiveIDE#%d RID#0 with %d\n",
> +				 i, ret);
> +
> +		ret = pci_ide_set_sel(tdev->pdev, i,
> +				      tdev->selective_ide[i].id,
> +				      tdev->selective_ide[i].enable,
> +				      tdev->selective_ide[i].def,
> +				      tdev->selective_ide[i].dev_tee_limited,
> +				      tdev->selective_ide[i].dev_ide_cfg);

This feels kludgy. IDE is a fundamental mechanism of a PCI device why
would a PCI core helper not know how to extract the settings from a
pdev?

Something like:

pci_ide_setup_stream(pdev, i)

> +		if (ret) {
> +			pci_warn(tdev->pdev,
> +				 "Failed configuring SelectiveIDE#%d with %d\n",
> +				 i, ret);
> +			break;
> +		}
> +
> +		ret = pci_ide_set_sel_rid_assoc(rootport, i, true, 0, 0, 0xFFFF);
> +		if (ret)
> +			pci_warn(rootport,
> +				 "Failed configuring SelectiveIDE#%d rid1 with %d\n",
> +				 i, ret);
> +
> +		ret = pci_ide_set_sel(rootport, i,

Perhaps:

pci_ide_host_setup_stream(pdev, i)

...I expect the helper should be able to figure out the rootport and RID
association.

> +				      tdev->selective_ide[i].id,
> +				      tdev->selective_ide[i].enable,
> +				      tdev->selective_ide[i].def,
> +				      tdev->selective_ide[i].rootport_tee_limited,
> +				      tdev->selective_ide[i].rootport_ide_cfg);
> +		if (ret)
> +			pci_warn(rootport,
> +				 "Failed configuring SelectiveIDE#%d with %d\n",
> +				 i, ret);
> +
> +		tdev->selective_ide[i].enabled = 1;
> +	}
> +
> +	return ret;
> +}
> +
> +static void tsm_unset_sel_ide(struct tsm_dev *tdev)
> +{
> +	struct pci_dev *rootport = tdev->pdev->bus->self;
> +	bool printed = false;
> +
> +	for (unsigned int i = 0; i < ARRAY_SIZE(tdev->selective_ide); ++i) {
> +		if (!tdev->selective_ide[i].enabled)
> +			continue;
> +
> +		if (!printed) {
> +			pci_info(rootport, "Deconfiguring IDE with %s\n", pci_name(tdev->pdev));
> +			printed = true;
> +		}
> +
> +		pci_ide_set_sel(rootport, i, 0, 0, 0, false, false);
> +		pci_ide_set_sel(tdev->pdev, i, 0, 0, 0, false, false);

These calls are unreadable, how about:

pci_ide_host_destroy_stream(pdev, i)
pci_ide_destroy_stream(pdev, i)


> +static int tsm_dev_connect(struct tsm_dev *tdev, void *private_data, unsigned int val)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!tsm.ops->dev_connect))
> +		return -EPERM;

How does a device get this far into the flow with a TSM that does not
define the "connect" verb?

> +
> +	tdev->ide_pre = val == 2;
> +	if (tdev->ide_pre)
> +		tsm_set_sel_ide(tdev);
> +
> +	mutex_lock(&tdev->spdm_mutex);
> +	while (1) {
> +		ret = tsm.ops->dev_connect(tdev, tsm.private_data);
> +		if (ret <= 0)
> +			break;
> +
> +		ret = spdm_forward(&tdev->spdm, ret);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&tdev->spdm_mutex);
> +
> +	if (!tdev->ide_pre)
> +		ret = tsm_set_sel_ide(tdev);
> +
> +	tdev->connected = (ret == 0);
> +
> +	return ret;
> +}
> +
> +static int tsm_dev_reclaim(struct tsm_dev *tdev, void *private_data)
> +{
> +	struct pci_dev *pdev = NULL;
> +	int ret;
> +
> +	if (WARN_ON(!tsm.ops->dev_reclaim))
> +		return -EPERM;

Similar comment about how this could happen and why crashing the kernel
is ok.

> +
> +	/* Do not disconnect with active TDIs */
> +	for_each_pci_dev(pdev) {
> +		struct tsm_tdi *tdi = tsm_tdi_get(&pdev->dev);
> +
> +		if (tdi && tdi->tdev == tdev && tdi->data)
> +			return -EBUSY;

I would expect that removing things out of order causes violence, not
blocking it.

For example you can remove disk drivers while filesystems are still
mounted. What is the administrator's recourse if they *do* want to
shutdown the TSM layer all at once?

> +	}
> +
> +	if (!tdev->ide_pre)
> +		tsm_unset_sel_ide(tdev);
> +
> +	mutex_lock(&tdev->spdm_mutex);
> +	while (1) {
> +		ret = tsm.ops->dev_reclaim(tdev, private_data);
> +		if (ret <= 0)
> +			break;

What is the "reclaim" verb? Is this just a destructor? Does "disconnect"
not sufficiently clean up the device context?

> +
> +		ret = spdm_forward(&tdev->spdm, ret);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&tdev->spdm_mutex);
> +
> +	if (tdev->ide_pre)
> +		tsm_unset_sel_ide(tdev);
> +
> +	if (!ret)
> +		tdev->connected = false;
> +
> +	return ret;
> +}
> +
> +static int tsm_dev_status(struct tsm_dev *tdev, void *private_data, struct tsm_dev_status *s)
> +{
> +	if (WARN_ON(!tsm.ops->dev_status))
> +		return -EPERM;
> +
> +	return tsm.ops->dev_status(tdev, private_data, s);

This is asking for better defined semantics.

> +}
> +
> +static int tsm_ide_refresh(struct tsm_dev *tdev, void *private_data)
> +{
> +	int ret;
> +
> +	if (!tsm.ops->ide_refresh)
> +		return -EPERM;
> +
> +	mutex_lock(&tdev->spdm_mutex);
> +	while (1) {
> +		ret = tsm.ops->ide_refresh(tdev, private_data);
> +		if (ret <= 0)
> +			break;

Why is refresh not "connect"? I.e. connecting an already connected
device refreshes the connection.

> +
> +		ret = spdm_forward(&tdev->spdm, ret);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&tdev->spdm_mutex);
> +
> +	return ret;
> +}
> +
> +static void tsm_tdi_reclaim(struct tsm_tdi *tdi, void *private_data)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!tsm.ops->tdi_reclaim))
> +		return;
> +
> +	mutex_lock(&tdi->tdev->spdm_mutex);
> +	while (1) {
> +		ret = tsm.ops->tdi_reclaim(tdi, private_data);
> +		if (ret <= 0)
> +			break;

What is involved in tdi "reclaim" separately from "unbind"?
"dev_reclaim" and "tdi_reclaim" seem less precise than "disconnect" and
"unbind".

> +
> +		ret = spdm_forward(&tdi->tdev->spdm, ret);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&tdi->tdev->spdm_mutex);
> +}
> +
> +static int tsm_tdi_validate(struct tsm_tdi *tdi, bool invalidate, void *private_data)
> +{
> +	int ret;
> +
> +	if (!tdi || !tsm.ops->tdi_validate)
> +		return -EPERM;
> +
> +	ret = tsm.ops->tdi_validate(tdi, invalidate, private_data);
> +	if (ret) {
> +		pci_err(tdi->pdev, "Validation failed, ret=%d", ret);
> +		tdi->pdev->dev.tdi_enabled = false;
> +	}
> +
> +	return ret;
> +}
> +
> +/* In case BUS_NOTIFY_PCI_BUS_MASTER is no good, a driver can call pci_dev_tdi_validate() */

No. TDISP is a fundamental re-imagining of the PCI device security
model. It deserves first class support in the PCI core, not bolted on
support via bus notifiers.

[..]

I hesitate to keep commenting because this is so far off of the lifetime
and code organization expectations I thought we were negotiating with
the PCI/TSM series. So I will stop here for now.

