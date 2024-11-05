Return-Path: <kvm+bounces-30815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E849BD751
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 21:59:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23E20283A95
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876F2215F59;
	Tue,  5 Nov 2024 20:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5ITJtEF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA89215C51
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 20:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730840338; cv=fail; b=meilSB9FF6/kcp2Ux5LnXPLBUFwupXI0/DJIQY+3tHXbp+eKLo8mXfZgTc+YFOrzwCaw0BQ+DYn8YF7GRUUVC7/svFLS7rADsR4KPovV1eFfkqnATg/oSr43ibLEbp8y2hLUkZpsJ6Ai+HpJ4l8NgDDDViMcQfXcT5hsnrJ0M/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730840338; c=relaxed/simple;
	bh=QxMlwVrgCzqTQcQUqxDRTToM51trSrtmbYrtRi19na4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VrGpz1h47wJnMGXm2uaaxSq/iFIuMBmU3lipYmmtPC86rMs22vROFhCtEgahNyToxd3B8IqHWJRGGEwEqL5jZko+rsy0oEggekaL4UzjDsB+ZhczshMQpfMmIoMO33u1yiDo1TLY6jQjrjoTUyhhStW24n3MeKMhkQ7kGlijOCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5ITJtEF; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730840337; x=1762376337;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QxMlwVrgCzqTQcQUqxDRTToM51trSrtmbYrtRi19na4=;
  b=G5ITJtEFinqx2UJ3Zm8x9QY+HPld6AnkUzg9j09VgJCTG/51W8bTXb7a
   Mjo1Sb10kdZPR5DQzGZrVnkRF37YU3TOojIhmHgYfXWnDLNtla0kvvaNo
   VM4FZlc8qBunkIhV+o+a0zoNSpTum0vrPihyi+546bEA+vLiHcuG5ORwZ
   2cobCuY0dSYN6CqoltjYoAFcxRyYYXGdl0om7XQZHh4k4DrUgNs6oOafP
   xrmxWUtK0xwtlvJPwFkyyBkseoA/S96mVcYju4OXWGieSKXUg2nCt5Jbr
   aLQIMRebYsZI2W/RvGOOg9fPOrUsguekTS9thUPCpbC3M37HMgdfrtxvF
   A==;
X-CSE-ConnectionGUID: O3tMcgRuS8SUTHw69OSKqw==
X-CSE-MsgGUID: Irqm1eLCQNCsomjpxuHd+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30568827"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30568827"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 12:58:54 -0800
X-CSE-ConnectionGUID: Vvmki/ZzTpqIjB4QFuGA1Q==
X-CSE-MsgGUID: MkVjADhURVi352s36ztYVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="88737584"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 12:56:03 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 12:56:03 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 12:56:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 12:56:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uRxJPO+kIeqvfIMmnHFgKp386DI1lKqZlfTiQTAg01eWZuh9GWo9qFg2N78UjDZYXuwCO/Qn2Z9DKJoSxNwyDGvCLSbMBcPE0WNzGhstsT3tX2ZH5I2ifCjZ9NsiyxvmFXext4FTZ7yro31U5qK74pOHVeKCANWtDo9CimVMdM9GEwG0Wt2DfHV8/wti4mbp4hykikn0/jCGM7LTAPIeLwCX7H7q5FWuYyHm0BrC/Cd15NF63CZ5i14XvC4inCU0S5Hc706CvOeHFTyyFLS6Jvi3hrereBVYrYx+4B3d9Vy/rAVT2gRVH/nPWH6vE2CBM+TfZABO2BHtM46ruXFWMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QxMlwVrgCzqTQcQUqxDRTToM51trSrtmbYrtRi19na4=;
 b=n+fYuW4PuS2jB9rWloHmyTesOwk2R7sZxa/3SK/tfVfmgm3dlfOPmL6HXoypJLh4nzyERhDlkXiJ/FQfxBIA2TY89Shf3kmcehYsjsucb1bA8CNyvhZCEpCNxXG/VVVfHhIRqnIjJTkgrGyxUhG/K/QmuDWCR2CahGhNVgsjmO4ueaSgMe1+OgrEXUqLR60iLKbIGgea4umUOV49UPjLneHRKtPnIR+8Kh1aXgP58zApxGUvCaf1mHINQIjtT8Rzthvn/zXqVTjUL2LuhjUGxb3GaJC0f7lYOCi8nYWuPSJGbj2Fce7+Z7slZqjrTLz/evzrxkc6lK+/LGOrr7oyGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5971.namprd11.prod.outlook.com (2603:10b6:8:5e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.31; Tue, 5 Nov 2024 20:55:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 20:55:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "riku.voipio@iki.fi" <riku.voipio@iki.fi>, "imammedo@redhat.com"
	<imammedo@redhat.com>, "Liu, Zhao1" <zhao1.liu@intel.com>,
	"marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
	"anisinha@redhat.com" <anisinha@redhat.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>, "mst@redhat.com"
	<mst@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>
CC: "armbru@redhat.com" <armbru@redhat.com>, "philmd@linaro.org"
	<philmd@linaro.org>, "cohuck@redhat.com" <cohuck@redhat.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>, "eblake@redhat.com"
	<eblake@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "wangyanan55@huawei.com"
	<wangyanan55@huawei.com>, "berrange@redhat.com" <berrange@redhat.com>
Subject: Re: [PATCH v6 29/60] i386/tdx: Handle KVM_SYSTEM_EVENT_TDX_FATAL
Thread-Topic: [PATCH v6 29/60] i386/tdx: Handle KVM_SYSTEM_EVENT_TDX_FATAL
Thread-Index: AQHbL01XLgLDrqTpCUqGEGAQLvHO3bKpK58A
Date: Tue, 5 Nov 2024 20:55:59 +0000
Message-ID: <b2893e19e2bac78ec5d7c33e797bb52bcb7a7041.camel@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
	 <20241105062408.3533704-30-xiaoyao.li@intel.com>
In-Reply-To: <20241105062408.3533704-30-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5971:EE_
x-ms-office365-filtering-correlation-id: 28cc94c6-a8f3-4bd5-4179-08dcfddc4021
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?empNRlprSExvVDdNN2M4VTJVb2xBOTE0NjR3TGEvUnpidDM5c0M4T3h3UkpR?=
 =?utf-8?B?dllxMjhGU0k1Sml5bUlETXhHWUtJR21YTytKblVqektrYklGOFUwTHRRSHlW?=
 =?utf-8?B?Uk82MGI3Y2YzbVF3MlBVSE9oa3lPYUNTRDV3RHVZTDFJZ2lzV09GbFdnc0w5?=
 =?utf-8?B?TUwxNFpiYkFkcjE3ZzJxckt0Y2k0U3hnTGh0UnRlM1lCYXdtNkowTmZ3Rzdm?=
 =?utf-8?B?c05yR0RaV2c5NjJvZzJsTjVyRTJFdHM2NUoraWcwWWM3TGUvY0RuenJaU09a?=
 =?utf-8?B?dWVOUXdLR2w2N0tqZmpXTlRXRXdqMEh2NjdXL0x4aTUvTjBYMzVZd0VEWVla?=
 =?utf-8?B?dEh0TW9EeStwdGU1Z3hUTDIxYkpyQ3ZzRTB4N3N4MVR3aGJrSGUzRTduamJC?=
 =?utf-8?B?b2YzNUZYVWx3Z0tkN1grZUFEWVZLNVRheEZpc3V3MFZOVlRCOE9jeFpiVUkz?=
 =?utf-8?B?Zjg1TkJEbjlVelBkYjJ5ZkdnaTVnNjdQS1BlOURHS0REZnRON2dZRTFvdXVx?=
 =?utf-8?B?ejFQdXNxL1lzRFBYY25VT3IvUHh5ZUMxeVdLY1V5dWJ1MFBRZG9hZkVGVlZO?=
 =?utf-8?B?NEF1KzI0b1JDdUE2MTBSZENtUng3dWgwTmVqdnpZcmlZRHdxZk5KUGRnQUls?=
 =?utf-8?B?WStTS0ZMdEorS3BrNWQrb2ZlV21TMHlYSUVBSUxvYlZpeG1IS0xqNVAvcU02?=
 =?utf-8?B?R3VuUXJJNThnUVNBVVoxVE9jUU8zWTVFU0Y2UnFMd0NSYVlNMnEwMUxuSzVu?=
 =?utf-8?B?QjByVExJc1dsVStuUVRiK04rRml5QXpyaG1jVTkwckFkdHdqaVV6VjFBVnFB?=
 =?utf-8?B?T2JLQ2R0UXAxNUFwWXo5V3lYaVBtODF5T3JEdlJoRmN6di9lVWdmaFQwYUlk?=
 =?utf-8?B?NDFXWUthY0lkOUY5a2hPLy8xaFAyWkJzVEUwbVVWL0JhYkVXWEtHQndFTHFF?=
 =?utf-8?B?TDJQanFrbUJ6b2RWTlVCQWxFcjdmNHN6SWhnZHZpVUM0aFZveXpHSU5xaDQ4?=
 =?utf-8?B?amRuc0IxVVFXTlA3QzB0ZlFkYVhIeHdLYzAxSWlYMnl0c2p4SG03RWg3K204?=
 =?utf-8?B?T0hLc3N5U04xWGhtY2IwaFk2bjNRWm9CQnEvcFBodUdnTExRMXV6QzlNYVZw?=
 =?utf-8?B?eTBkejFZWERYaSsyNHZxRTZleXVzaHAyOHpaY1VweFBaUm5XTXJDQ3VsUnB0?=
 =?utf-8?B?czVTR1B5bnJDL2U5VDRKSFBJYVByT3dwTXhJV3NXUi9LcG1Wejc5RHMxc0Ur?=
 =?utf-8?B?MWlJTDFVNTd3UmJiQm12Y3YvcXp2T3BVT0NSQzA4bk5nWmRNN3VhQ2ZLdG83?=
 =?utf-8?B?dHVQTEh1TXBsbjl1dUJXNGxYczlDamhCMlZXM0dsM2RxOHFxLzFtZWNLSWhh?=
 =?utf-8?B?NHZTV1N4cS9TKzZ4TjFiL2dSTDZnOCtldTA3SDF0WlpJVUlySnNjTmprbmg2?=
 =?utf-8?B?blZoaFIwNFpmcFlZaEU5K1BtYWVoQkNNTTVmckoyZDYzdjI1VHZEeWtFZFpP?=
 =?utf-8?B?NEtQY2JqbjJ3RGlXeDFRdDRzTm5qSUpwcTlnQXpIZU16Wjkwbk0yOEVXZ0gy?=
 =?utf-8?B?ajJKRXpVSUUzbnZXRXg1SUwva0hyUStDSXNtQmxoVHhnMnF1c2lNN2F3amhX?=
 =?utf-8?B?SVV6cHRDdGpodnMySExVUnNLM3ZGQ2YwcWo4V09jNTlGNlhKYXRmOWF5L1ZX?=
 =?utf-8?B?aTdJTU9XN0FIclhnK0FrdnZ1RWF1L1l2bTl6bGpRRUdCU250bTdlUjlBTnAy?=
 =?utf-8?B?U0hZaFlhOXdKWnVwSXRweW1ZZUh1eFk3RkR3R3RPeldXNmdKeElYUjFiV1Nv?=
 =?utf-8?B?a2t2VFJFdzR5a2praHY5UHNkRGJGZDhuaWwvbkxDUVR5dFF2Q3d4ZUJBVzlF?=
 =?utf-8?Q?X3jwOTQBsiZje?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnNoSDhwclBRdlZvVjBhT0VCWkQweWoxY0tJekZhVEFBdEozVjR4WXZEOXk3?=
 =?utf-8?B?THIvNlVXalI3ajJZcjFSS01sbnVZbk5tMDYyVThzZllsamRxczBKZnFOZWhB?=
 =?utf-8?B?RDdmd3JOeCtmcjdCRWNtWmFsTnZLZTVtamh3blM0M1pmajcybUpKQVFNZTht?=
 =?utf-8?B?T1cwR3Z0dWtleWdWY0FEZ1hoSzcvRk1sbmxIRTlzYm5jVlByc21UU3BTNmth?=
 =?utf-8?B?cTFHZW5QdkhSSGtyQjVNMXhkZUZZVERBaS90aEFEd3ZHcWtqQm9DVTVSUFUr?=
 =?utf-8?B?QjBpZ0Jhek9pY3RoQ2xUTUxqRXJqRDNvWHJHdFdrV2owZGs2Q0JUOXYvWEEw?=
 =?utf-8?B?UHFYYTF3RytPTjZYMENjeHRNYlFnejBsdmF3ZlBySHhFbEcwRTRySjJpZS9R?=
 =?utf-8?B?QjhPYTN1K0paZlQ0SU8rYjJoT1BFTkM0R0J2VFNoZlg4bHZHV0plOVRTeWpH?=
 =?utf-8?B?VkR1ZHZ6UW1QWVRUZ1VPclZlSjFEMEhjTU93aUhqZFhqSXJKNHZsTDBCQ2Nx?=
 =?utf-8?B?akdqcW9QdzR0M0Nqd1luVHV0SEJ1SytaMEx5TXB3bjB6SVVMUzY0Q3RON1Rn?=
 =?utf-8?B?SnpXcXE5SG51R3Rkejd5ZjhxZUtQMVF2eWR2blZmYVk0eFlUWitpWkJwZG4z?=
 =?utf-8?B?aWlvU0h4NVlzTEIzdDlIR1hoNWdtZ28yRGRyeG10TFNHb2R0NkhKKy94OGxS?=
 =?utf-8?B?TEJ3UkVLNTRiY3pzTGJKVmFYejZDU2FVL0IzUStFYTNLSEVGa0tnNjdZVzNJ?=
 =?utf-8?B?bys4NXU3Q2dVc2JvZlBQc1JVaG9XL1pVQmpONjVOQ2N4bVViZ2wycnJyZVNi?=
 =?utf-8?B?aWt4cUlYNkNJWTdJY3Mra0NFUHhOa0hGU05DMjgyenVsRUtwTGsrS0NXWVR6?=
 =?utf-8?B?d1hoYzlXS25xR01ybitvYWNTUlhjK3FHUXhmby9hd1BQZ3BUOFdrNlBQNnlk?=
 =?utf-8?B?V0ZGRWxzcXBwS0NMSXdRTjBvU0gyeUxXRVBsUk9VV1Z0aERlc0xUdkt3UHBL?=
 =?utf-8?B?TFRXRjhJTFVHY3NzVVZOOFc5Z2M3MXRqcllKazlldFdBcjBRaHpZUzhMcFJz?=
 =?utf-8?B?SDBkS3dKcys3VTYxRVFOT2RScjFVOTlLaHFQOGJ1MXVUTGEyb3dkcVJFby9l?=
 =?utf-8?B?SjRIRHdsUTB6am0wem9JdVdpaENNZmkrYVpGMlJmS3BTdWFVVTZHSTlBMUsy?=
 =?utf-8?B?L01VYktrWStoNHpNeDFVTkhOWitYbmRhUGdUcGNqNFJ5UXZLN0RWZ1hDTWND?=
 =?utf-8?B?bm4vb201NXRKb3liZ3NWYUYyajZBQ0k2TmRHcURNWHIyS2xsWFZBL2tiT1M2?=
 =?utf-8?B?b25KakhzVWJnTjhFdDQ5MDdsK2IyK0FWK3lETnJQcmppaTMybnpnMkdkTjhH?=
 =?utf-8?B?Nm5BQ011bkxxdFIzMTFwdDk5dGdXVCtKWjBTQU1nVzl6RkpZR093NWQvR2hS?=
 =?utf-8?B?REZqcjQrSGwwcUViVEhSQ0puM05sV3hKQ0dyeGVTN25OQXJtZkhyZW1rUVJ0?=
 =?utf-8?B?RlVNczNMNVZuK0Z6R24ydytmVFVVYnhsazlJcm9mWUNjZGV3VE5ybklwa1pl?=
 =?utf-8?B?ZmVFNDJqNCtkZHltVTBnaW1mQUdneTczQUdreTFzY1ZaVm1xVDhDUUp2WkNa?=
 =?utf-8?B?dkt4QWxpUjdsM1E1UzBPWlQzdzI3ZnZRMVJQcHBFaDc2RFJHbFFuN3Zab0RS?=
 =?utf-8?B?Rm5UbUN6U05WekExY3RNWU5TMkQ3dGY0b2RTNTF6Zm9HUVhvTWVjcW15SWtj?=
 =?utf-8?B?N3EyQ1BWajgzRDc3QTZBV1RNRHk4UDY4YUFESDFxdnpDSnl1SDN2WnZLaUdn?=
 =?utf-8?B?aTBvTWFSR2MvT2lrcEEwTFhEMnprOEh3L0VuRG05QVFhVCttUDFhUDZsWFFD?=
 =?utf-8?B?TWdTQ01hSzNDVG1yVnlBQ3luRTRCQTd1Q3VmUEw1YkpRR2Q5VTd1R2VYOUVh?=
 =?utf-8?B?QWF1Zks0VXRxUkZJeENDU21JV3BPODRuMlpBTG5CRGEya01lVEhhWlZyZEtF?=
 =?utf-8?B?MFhwdW5wQ1hmOURwUEpBeEpOMFlOTW1ZTFd5UVg2Y1JlYnNiTDVnS1pQMkpi?=
 =?utf-8?B?UHFlSTAvVFZuTlNnbHlqVzkwYW4ycVg1d21nUW5GMmVuRHVvRzl0VkwzNGdn?=
 =?utf-8?B?ZHJWNnY1NElKWmUwUjBVekd2ODY3L285bnlFTDlBMWxZZGs2alp5ZHRZOFlr?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <534B781B59BA0746A65FE90139E076A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28cc94c6-a8f3-4bd5-4179-08dcfddc4021
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2024 20:55:59.0279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQ1vdIbbs9PEBu5EZK19fB+5q7iIXvgi58yuQa2789OoVwi8B0Keup2p6PsaqoqldUXw0H5z11VRsa4TM1GQAMfW9zvgFS2GjesDuXwC6Lc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5971
X-OriginatorOrg: intel.com

K0JpbmJpbg0KDQpPbiBUdWUsIDIwMjQtMTEtMDUgYXQgMDE6MjMgLTA1MDAsIFhpYW95YW8gTGkg
d3JvdGU6DQo+IFREIGd1ZXN0IGNhbiB1c2UgVERHLlZQLlZNQ0FMTDxSRVBPUlRfRkFUQUxfRVJS
T1I+IHRvIHJlcXVlc3QNCj4gdGVybWluYXRpb24uIEtWTSB0cmFuc2xhdGVzIHN1Y2ggcmVxdWVz
dCBpbnRvIEtWTV9FWElUX1NZU1RFTV9FVkVOVCB3aXRoDQo+IHR5cGUgb2YgS1ZNX1NZU1RFTV9F
VkVOVF9URFhfRkFUQUwuDQo+IA0KPiBBZGQgaGFubGRlciBmb3Igc3VjaCBleGl0LiBQYXJzZSBh
bmQgcHJpbnQgdGhlIGVycm9yIG1lc3NhZ2UsIGFuZA0KPiB0ZXJtaW5hdGUgdGhlIFREIGd1ZXN0
IGluIHRoZSBoYW5kbGVyLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWGlhb3lhbyBMaSA8eGlhb3lh
by5saUBpbnRlbC5jb20+DQo+IC0tLQ0KDQpCaW5iaW4gd2FzIGxvb2tpbmcgYXQgcmUtYXJyYW5n
aW5nIHRoZSBURFggZGV2IGJyYW5jaCB0byB0cnkgdG8gbW92ZSB0aGVzZQ0KcGF0Y2hlcyBlYXJs
aWVyIGluIHRoZSBzZXJpZXMgc28gd2UgY291bGQgZ2V0IHRoZW0gZmluYWxpemVkIGZvciB0aGUg
cHVycG9zZSBvZg0KZnVsbHkgc2V0dGxpbmcgdGhlIHVBUEkgZm9yIFFFTVUuDQoNCkkgd29uZGVy
IGlmIHdlIHNob3VsZCBqdXN0IHBvc3QgYSB2ZXJ5IHNtYWxsIHNlcmllcyB3aXRoIHRoZSBLVk0g
aW1wbGVtZW50YXRpb25zDQpmb3IgTWFwR1BBIGFuZCBSZXBvcnRGYXRhbEVycm9yIGFuZCB3ZSBj
b3VsZCB0cnkgdG8gZ2V0IHNvbWUgc3RhYmlsaXR5DQplc3RhYmxpc2hlZC4gTWF5YmUgdGhhdCB3
b3VsZCBiZSBlbm91Z2g/DQoNClBhb2xvLCBhbnkgdGhvdWdodHMgb24gdGhlIG1lcml0cyBvZiB0
cnlpbmcgdG8gZ2V0IHRvIHRoYXQgcGFydCBlYXJsaWVyPw0K

