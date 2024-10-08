Return-Path: <kvm+bounces-28091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 266D1993BE7
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 02:47:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 162C91C21404
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 00:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943FBCA4E;
	Tue,  8 Oct 2024 00:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gky5YiWr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBF3AD5B;
	Tue,  8 Oct 2024 00:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728348402; cv=fail; b=tznv6+3VNn0vmFFGvyCHlkIX8WUPJ+B4mIMcZ/Nt+5rUSl79OT2fVRFoQJ7F7Byy79ywVblcnN/sZcWywKV8Qo4/j3P6xLnTFqNQZpm8nvx+NVhJmSSy4GMsxWAfu7a48FgBiuZ/+DC6B70Ci/S2sczuv7nLjk9VQ+WLXW+KT1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728348402; c=relaxed/simple;
	bh=QYY44IXlpv4Smti4BNDYp88Zdu227D7+6tdJmRozkwM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FrXQ4IC0PmlRnjhHRmHPuHjEy3bpFzo/rp40C5gIxoI3m/aNlynIq/jVZlNZCWAF2oeWFJ8lN9pC5dScaunpp1T2fsxUT4qeN/Xp11bYFzpbmFJhpFnuwwrVMRJpXlbh8c6J1m9EqqofVJLaDca2mR4A99ftdxnEPUnf3xGT8ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gky5YiWr; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728348400; x=1759884400;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=QYY44IXlpv4Smti4BNDYp88Zdu227D7+6tdJmRozkwM=;
  b=Gky5YiWrV2gZAQp2VowH+mpWxsQckeYGldK1STH8GpuiihepPUoxSnvN
   ugv+7UVcP50YY46kqdKxNZmEmN+lGxX4qmBPA1s5z5AeCwd9UCzga/ojf
   4WGHVKz+IBuX2xNdQEz5gCQHB6bL7YPGkbYZdyyP14TP3utnKImVTc0k8
   oNts8RFwQIIWrIkONcZA58OdR+pvax0lZTy2Xpag8ZH4zoZ9mZkyT2iId
   bTnQoVDOXQVL3xrttj2ToyU7aZVVcQ0X5rRCb1BTQiXr6ll96M00XrtIB
   aBBsppym/8/U2wPiqBjE29C7/qL/3WSWE0DnAS5LBYr1rNLRMFyVmqFUA
   w==;
X-CSE-ConnectionGUID: gMNIHLPiQt6L42XOCksOIw==
X-CSE-MsgGUID: VeCEzN5zRaKrxD5r06g/0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="30402798"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="30402798"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 17:46:40 -0700
X-CSE-ConnectionGUID: GYsX7rFMQo+ZwTmeOAWIvg==
X-CSE-MsgGUID: /Jck9197S5eN3dLO4x43Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="113113533"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Oct 2024 17:46:40 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 7 Oct 2024 17:46:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 7 Oct 2024 17:46:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 7 Oct 2024 17:46:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 7 Oct 2024 17:46:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NGQcXRioEnqMrE3jfjmlc58MSj1mIYxP6v2c90ov4u6BfZ8fcxKm9QMaKY1xui4dP7U6D/5ebpLOx+wOOZaqACMB76hCkKvg5rYLgtmDnk2B82I2ozXynSiZmGhS8EAbEQ+RGITzI4725a+/ckEIz/dGdMG0YOLts8uvxShCoNM9FWRGOQCS0QGSQvSmD0B9NbasxImh0rNJgm7lrierM8EOt/bbjJmCntGucVZBIgOj6aZaWF4Gg2YuLV/nMErgHxVXs4Okhc1KAt2hJKF6L9f1sQFA3h5yKYEUTd2l/taybHmAjPC2DR+xJpqU0DPTdU0paQWaeXa8N7g4DbUQ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trTgotNC1BCjg8BtpSY0l/E4XaE7Ut8nbxcdYxd9sck=;
 b=w9qWQ8ml/z2n9DnbhJEN9VrWA3DDpiWrULrvpRwlhAawPJ84wSjOZ729W971zs9+M5iu8L1RI3wf6U0PJIoUFf153a49eFJqriBbAabF6HHs0vxfILtq/Pv9I340obyVjIl+s5IS7nTtecbDrrTy69ajn4NOj86efCDUzOnkl1Ervk7pqQeB8UzTi15EseS3rtT044KCKTJYdG3UML27m0TpffzaMWjDgLsPiMzIiQcwstRuV8k1aMRtS8nnec8Z1Jh0M17CSa1wfMnrROPddboRZeop768L4JjyaUJDucRyBu7KbGlAm+DJVeTu+tvXHWMo8vLbhtrsNJHfFp0nvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6170.namprd11.prod.outlook.com (2603:10b6:208:3ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Tue, 8 Oct
 2024 00:46:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 00:46:35 +0000
Date: Tue, 8 Oct 2024 08:44:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Isaku Yamahata <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<sagis@google.com>, <chao.gao@intel.com>, <pbonzini@redhat.com>,
	<rick.p.edgecombe@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
Message-ID: <ZwSAZ0uiwhKOZVlN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com>
 <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
 <Zva4aORxE9ljlMNe@google.com>
 <ZvbB6s6MYZ2dmQxr@google.com>
 <ZvkdkAQkN5LmDaE6@yzhao56-desk.sh.intel.com>
 <ZvrJvucBw1iIwEG6@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZvrJvucBw1iIwEG6@google.com>
X-ClientProxiedBy: SG2PR06CA0242.apcprd06.prod.outlook.com
 (2603:1096:4:ac::26) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6170:EE_
X-MS-Office365-Filtering-Correlation-Id: 035a11b5-032a-4d55-8f38-08dce732a97b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SO7BhaEYQFAmKJODj342XWSOkef/wTN/a/EdEPEsX8/nehIvaawM3jgKOdco?=
 =?us-ascii?Q?/FFz7sngEcjvQbVACCyTThg9lrDY9gop0j6ghhkm+OxcswKp0rpZqQCw2CgE?=
 =?us-ascii?Q?Pkd9/38/8PYzAkr8E/iWMQHOFITqSgOUWeZ0UID/tEVTOfFnSOGMjNg9Shw1?=
 =?us-ascii?Q?hzELKTBKKRMDXz36m+6NRcBLRJBfTBT6YsPjtioFz5DnE+73SyYhJf5whnRn?=
 =?us-ascii?Q?pB3DI524R5wohW9XtBVL3l1x3Cs8tJ5n+qIBpQSwsDtGNPPoTfytU/GNkcnw?=
 =?us-ascii?Q?e/tWJP8rAL5tRr7j+I7asxvWshr7ZnDZWWRm7SxXL9PbY2DthnaHvDbHeuh7?=
 =?us-ascii?Q?t+CrQgtjhfw7ddwtmtN6UhIutTH1d3kp8ZKKH4Hl7FgO4KDaNSqgtIyplb67?=
 =?us-ascii?Q?LuVOVEoqkABW5k3RaOsAG+gTm1Y8Gw8dolzGif68rMaUuDnOGiIKX5Ml6w8L?=
 =?us-ascii?Q?RtsyZT1CfdNzJxJ+XazXetGMHUhtpox/Tw0TGXSZnnGpahGzXc+YOd6UG5JJ?=
 =?us-ascii?Q?5VVU+TCBAT9xUC9NJLedBiZpmgOA6l4e+gSFQibix66q3zOx3P4IliRNKbmJ?=
 =?us-ascii?Q?rMCYA8XnyeFPO8XjmeWQDlu0rbsam5xG+kTYvCBtvcuJJLngwpD4lYQxkkDQ?=
 =?us-ascii?Q?gIx0D0dryKrvb/EFVFYmLiKnwXsRGzLVeSJLuWn51WjviezkCJXdB7Ql51/W?=
 =?us-ascii?Q?BWMyaa7RoUdqAIxfrp4kl8wFMezo+Xbgcu2VVhWpZyrsYC8rjOOoGW1VKjf0?=
 =?us-ascii?Q?Lp1WWpWCuWOofQTifk+2rwOD30kJrRUCVy9WzI73q7J0myx6NO24LGbd3NdU?=
 =?us-ascii?Q?KiyzA2WISDpbbjAEuornvTCeB5IGA0L+ldStQMJAxCaa7S0ghaXjkgxazxTE?=
 =?us-ascii?Q?yzcUTpO0kUZrWAbju3s7ZWg8LAIb6EEkHAt/ezqHyfCF2vvUIy0pV7hTV7qb?=
 =?us-ascii?Q?q1iBwmOiw5yuDC4kMT/5WEbhfajx2g2ZCA3gGS/FtCcEZP7fAn3BLXaTuc6U?=
 =?us-ascii?Q?TdaWVNKTYfUbMdcMittcoiDblpQQlTU2gvHGwAI/RRrmBxpKCV8iKmi2UEpK?=
 =?us-ascii?Q?v9xZLrEjomYR03w8t2El+46D7Nt74+OfR2rbotKv7N4iWYrNz70W0xhgwwnA?=
 =?us-ascii?Q?glcp7LZ1DBgoIIGqvIhxb5rJgvTQNbmpzG8N/BaosxymSFvxsPtaapWSpQb1?=
 =?us-ascii?Q?GX7Zw4HSC2slhCgdlJmfRNsQyCaIIkP16kx5kjr9FBp2EqS6xjo1m2OFD1n4?=
 =?us-ascii?Q?j4S/6p5UAq4/YB52U0UnceNj9BNrd1Vm5l90akbnUydsK2cR1zcvpJEqFNdk?=
 =?us-ascii?Q?evE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZqbarHVLs2iWffhgSVDcWt7t7LQi1C4gNssSbiyCPcSAtaLLxW/WzDrp1bz9?=
 =?us-ascii?Q?2elj16CqUNPV525ln7NkQP2OMkBRNIK+5CYUXPynS2iNZx0NaZhmumRmTVuz?=
 =?us-ascii?Q?OndFQ06fp9yZ7bU0RBXQUD0hhIpVIVHMokNjGOzWpKBtEuVQrZ8YngH9zgpS?=
 =?us-ascii?Q?nvg5kmiG8imBj8uNLA7PvGq6FW3W/Mns26GB+nqrQXw5T1bz9fm0OHaolb6u?=
 =?us-ascii?Q?QVaFpzd4D6PIvb30mF+WIYTO6P3ZKC6s7yg6Qxx2fRrZyfE8yzwg+UgZy8kf?=
 =?us-ascii?Q?0SN0chcYGWR8CRWHUNPqwIipW6Q7KP7Ugk4JD4iagUuS2DaWe63MJHh8R6+q?=
 =?us-ascii?Q?nm8/uxo2n6ARCZiCOEsIabqlKQzDR6iIpch5WKK9kP1HAfsafPz1G0lg/zks?=
 =?us-ascii?Q?4+hOYhQzjZAsIu3Zwq3xGG9ePQW755UCpkHe2poQIpslwDSLtxZaxgk3/b8W?=
 =?us-ascii?Q?OmJ1jU9N83Cce7R8zNUSq51u4H11VuCE5+K0cIlTWQbkGM0bY88VJNHFaSsy?=
 =?us-ascii?Q?LP8b8EVvwCIwVUspLz0orEOQZR//T96I3ZDGjYvtQvM765sq1mjFxl5rlJWV?=
 =?us-ascii?Q?WebcJBNOYS2qgxkfeyVnOPRX0O1ubIKjXrMGc3YwwRIh/0IHeptYJqhTZM5u?=
 =?us-ascii?Q?yrHIBdADaifRxkZtKjERkaTT2jxz0mDf4mPTRZrHsTTKLJBk+jtVwWIRWHVm?=
 =?us-ascii?Q?FabPJRW+kGgR0gv9/8ciC6YxVHjRBu6bD6xpLZaO+tqi+86pPweu198phCPM?=
 =?us-ascii?Q?zwsrO3+kmWDWcpxGgtzf6PUdGFFc0HURP0d6IQsDLsSRg+h+PHJXOrklzgyH?=
 =?us-ascii?Q?TEgFDmJdD+rac9mbiXom4fe1X8rS2D0vGOz3Y8mT440OSakcVsxPXsD/IHmA?=
 =?us-ascii?Q?ncEaLH3Awm2p60+Z3/dhDJCJxW+8nlBT8Luy5pRKqGY3u11znjL7UbTleM6y?=
 =?us-ascii?Q?70WSrykvHKzAOY7qI87z6l50xkLZToNmKf6P79XxHSBhkfVOuSx7+Q8RiZLI?=
 =?us-ascii?Q?vE1u9+S3dg/QKsp3WMbz9AA0jyDzFZ4FCIkomWoYyK9/Pp4SzrWnCL16mSp5?=
 =?us-ascii?Q?EFAByYQ/TDK3QKAFd0fcmjwqfbZMbfXnQ5Oa6IKi4hn3e7dFLnhntUdnjEjR?=
 =?us-ascii?Q?ywjB3wuFqp73Gfr4d4PFNdyk+DtsoZTVSqF0Np/AFpnINdYo/ovDSUzTSZZo?=
 =?us-ascii?Q?zgCgYH4IIbOB+SXk6Xs4PTGYWQhNhA5yfH92el+ljwYLn+Lkka71riZZT7PK?=
 =?us-ascii?Q?OIpYRPm3XcphDHVF7aoHe4bRrRCMz2V6rB5bUJsHBgXYWNpkNQOV/myu1EI1?=
 =?us-ascii?Q?enGvU2hL2U3hjpQGdNkyYJF9zlakPIfh5ax29Z1UljpoUjJFaEisVBI3MwMt?=
 =?us-ascii?Q?dVFuR8ub6LzkIROyYo4A0coP6gyNX4WsiuhhxUMBnI4BuCa/P0oltI+WCTCy?=
 =?us-ascii?Q?3J+6wTBnrAi7kZdfz9Ve01hfs5rxDqp6VcBsqU23LBBMk2dukxKwnx31wxtM?=
 =?us-ascii?Q?lHKlUlekeN5JhUH1zQUPhiCtIArOdQQzxMzkVufqr5176tbYXSzxC1G5YrW0?=
 =?us-ascii?Q?3JPnNB1WKUTr9MkriQQWiEqz7DJlN/5NHxdJdzrC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 035a11b5-032a-4d55-8f38-08dce732a97b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2024 00:46:35.8859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AT77XUidJr69n5Avri4oJzLD05TGmmh9uaDFiVhk9NH+AkCk2ZqCUsIMVFWdwOAWA2fifQOZNoMKAoQeZ2OIqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6170
X-OriginatorOrg: intel.com

On Mon, Sep 30, 2024 at 08:54:38AM -0700, Sean Christopherson wrote:
> On Sun, Sep 29, 2024, Yan Zhao wrote:
> > On Fri, Sep 27, 2024 at 07:32:10AM -0700, Sean Christopherson wrote:
> > > On Fri, Sep 27, 2024, Sean Christopherson wrote:
> > > > On Thu, Sep 26, 2024, Yan Zhao wrote:
> > > > > On Thu, Sep 12, 2024 at 05:07:57PM -0700, Sean Christopherson wrote:
> > > > > > On Thu, Sep 12, 2024, Isaku Yamahata wrote:
> > > > > > Right now, the fixes for make_spte() are sitting toward the end of the massive
> > > > > > kvm_follow_pfn() rework (80+ patches and counting), but despite the size, I am
> > > > > > fairly confident that series can land in 6.13 (lots and lots of small patches).
> > > > > > 
> > > > > > ---
> > > > > > Author:     Sean Christopherson <seanjc@google.com>
> > > > > > AuthorDate: Thu Sep 12 16:23:21 2024 -0700
> > > > > > Commit:     Sean Christopherson <seanjc@google.com>
> > > > > > CommitDate: Thu Sep 12 16:35:06 2024 -0700
> > > > > > 
> > > > > >     KVM: x86/mmu: Flush TLBs if resolving a TDP MMU fault clears W or D bits
> > > > > >     
> > > > > >     Do a remote TLB flush if installing a leaf SPTE overwrites an existing
> > > > > >     leaf SPTE (with the same target pfn) and clears the Writable bit or the
> > > > > >     Dirty bit.  KVM isn't _supposed_ to clear Writable or Dirty bits in such
> > > > > >     a scenario, but make_spte() has a flaw where it will fail to set the Dirty
> > > > > >     if the existing SPTE is writable.
> > > > > >     
> > > > > >     E.g. if two vCPUs race to handle faults, the KVM will install a W=1,D=1
> > > > > >     SPTE for the first vCPU, and then overwrite it with a W=1,D=0 SPTE for the
> > > > > >     second vCPU.  If the first vCPU (or another vCPU) accesses memory using
> > > > > >     the W=1,D=1 SPTE, i.e. creates a writable, dirty TLB entry, and that is
> > > > > >     the only SPTE that is dirty at the time of the next relevant clearing of
> > > > > >     the dirty logs, then clear_dirty_gfn_range() will not modify any SPTEs
> > > > > >     because it sees the D=0 SPTE, and thus will complete the clearing of the
> > > > > >     dirty logs without performing a TLB flush.
> > > > > But it looks that kvm_flush_remote_tlbs_memslot() will always be invoked no
> > > > > matter clear_dirty_gfn_range() finds a D bit or not.
> > > > 
> > > > Oh, right, I forgot about that.  I'll tweak the changelog to call that out before
> > > > posting.  Hmm, and I'll drop the Cc: stable@ too, as commit b64d740ea7dd ("kvm:
> > > > x86: mmu: Always flush TLBs when enabling dirty logging") was a bug fix, i.e. if
> > > > anything should be backported it's that commit.
> > > 
> > > Actually, a better idea.  I think it makes sense to fully commit to not flushing
> > > when overwriting SPTEs, and instead rely on the dirty logging logic to do a remote
> > > TLB flush.
> > > 
> > > E.g. on top of this change in the mega-series is a cleanup to unify the TDP MMU
> > > and shadow MMU logic for clearing Writable and Dirty bits, with this comment
> > > (which is a massaged version of an existing comment for mmu_spte_update()):
> > > 
> > > /*
> > >  * Whenever an MMU-writable SPTE is overwritten with a read-only SPTE, remote
> > >  * TLBs must be flushed.  Otherwise write-protecting the gfn may find a read-
> > >  * only SPTE, even though the writable SPTE might be cached in a CPU's TLB.
> > >  *
> > >  * Remote TLBs also need to be flushed if the Dirty bit is cleared, as false
> > >  * negatives are not acceptable, e.g. if KVM is using D-bit based PML on VMX.
> > >  *
> > >  * Don't flush if the Accessed bit is cleared, as access tracking tolerates
> > >  * false negatives, and the one path that does care about TLB flushes,
> > >  * kvm_mmu_notifier_clear_flush_young(), uses mmu_spte_update_no_track().
> > I have a question about why access tracking tolerates false negatives on the
> > path kvm_mmu_notifier_clear_flush_young().
> > 
> > kvm_mmu_notifier_clear_flush_young() invokes kvm_flush_remote_tlbs()
> > only when kvm_age_gfn() returns true. But age_gfn_range()/kvm_age_rmap() will
> > return false if the old spte is !is_accessed_spte().
> > 
> > So, if the Access bit is cleared in make_spte(), is a TLB flush required to
> > avoid that it's not done in kvm_mmu_notifier_clear_flush_young()?
> 
> Because access tracking in general is tolerant of stale results due to lack of
> TLB flushes.  E.g. on many architectures, the primary MMU has omitted TLB flushes
> for years (10+ years on x86, commit b13b1d2d8692).  The basic argument is that if
> there is enough memory pressure to trigger reclaim, then there will be enough TLB
> pressure to ensure that omitting the TLB flush doesn't result in a large number
> of "bad" reclaims[1].  And conversely, if there isn't much TLB pressure, then the
> kernel shouldn't be reclaiming.
> 
> For KVM, I want to completely eliminate the TLB flush[2] for all architectures
> where it's architecturally legal.  Because for KVM, the flushes are often even
> more expensive than they are for the primary MMU, e.g. due to lack of batching,
> the cost of VM-Exit => VM-Enter (for architectures without broadcast flushes).
> 
> [1] https://lore.kernel.org/all/CAOUHufYCmYNngmS=rOSAQRB0N9ai+mA0aDrB9RopBvPHEK42Ng@mail.gmail.com
> [2] https://lore.kernel.org/all/Zmnbb-Xlyz4VXNHI@google.com

It makes sense. Thanks for explanation and the provided links!

Thinking more about the prefetched SPTEs, though the A bit tolerates fault
negative, do you think we still can have a small optimization to grant A bit to
prefetched SPTEs if the old_spte has already set it? So that if a prefault
happens right after a real fault, the A bit would not be cleared, basing on that
KVM not changing PFNs without first zapping the old SPTE.
(but I'm not sure if you have already covered this optmication in the
mega-series).

--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -163,6 +163,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
        int level = sp->role.level;
        u64 spte = SPTE_MMU_PRESENT_MASK;
        bool wrprot = false;
+       bool remove_accessed = prefetch && (!is_shadow_present_pte(old_spte) ||
+                              !s_last_spte(old_spte, level) || !is_accessed_spte(old_spte))
 
        /*
         * For the EPT case, shadow_present_mask has no RWX bits set if
@@ -178,7 +180,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
                spte |= SPTE_TDP_AD_WRPROT_ONLY;
 
        spte |= shadow_present_mask;
-       if (!prefetch)
+       if (!remove_accessed)
                spte |= spte_shadow_accessed_mask(spte);
 
        /*
@@ -259,7 +261,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
                spte |= spte_shadow_dirty_mask(spte);
 
 out:
-       if (prefetch)
+       if (remove_accessed)
                spte = mark_spte_for_access_track(spte);
 
        WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),



