Return-Path: <kvm+bounces-71850-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NJxJ1opn2kOZQQAu9opvQ
	(envelope-from <kvm+bounces-71850-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:54:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 342A019B05B
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:54:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6A75D30B0451
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 16:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A52B3DA7DF;
	Wed, 25 Feb 2026 16:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+iuKLL4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084033DA7E6;
	Wed, 25 Feb 2026 16:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772038282; cv=fail; b=VmZXea4Ve/Pr7zRXibLzgcB3wxB+FcMvkALj7lsmpqBtl6aG5GxLDBpXd7C4S2QkKKAuLitRPfkgcGNgDwHUZCRadnYqmZaXmTRDfW6uImSfMwd71XcXLbE3YN5oie4ZdxImF1Qf0hZk4bCVa9oD2BE0OJCQw913eDmqgswtNWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772038282; c=relaxed/simple;
	bh=SdPPf0uYy7g0+Fbujka8vEZh24n6+TH5P1ch7ASOXV0=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=M6ReK6lmwZSREJOI4T6JmgVIjnZVfjT3wsq1I2nPG76AlwUs5P0wxs8qz8mO9TErg9L0CfC2I2Dcl8vcjuFWVXoxSJgMHXw2ZsZXBHnKaZ4AqBNSfkECygDRreZKLx89tg4aC+E4ng6pLwOkRdocvFNOQDjAeim25WDvf1Pbqfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g+iuKLL4; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772038280; x=1803574280;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=SdPPf0uYy7g0+Fbujka8vEZh24n6+TH5P1ch7ASOXV0=;
  b=g+iuKLL4MUO8AaHGX/8P+F3THmTcx4hl59Mc+8CGQu2NvhRHU15sZ9Ch
   Gu81V5wrFf3+CJfg57ESbL6wc3nWF04sWVAHYUW5Kec2pAHPkWzDgrLpu
   OGbku2NJ3i/V9OSRp0cwVZAHOt/WjOW+6Ab5CrPeoOS5K1kBQzCtcE20A
   92YqyYAh+EDNl6Nr6PWDmGVrEmg9FhXiYRxKKuHx4ycEcMWVdwh+yDIpK
   qW1VA3YQabRPLvI5YqRFIGBVlPyeGe0JZEd/6ghJU/3OhYSS9bQFX0nkb
   c5wPNKZJrgdWgOHWfUimgmEGUS76k2aNDyAqIW1LS/wGO9izG8eJsQ1Mt
   w==;
X-CSE-ConnectionGUID: vGYyscT4TlmndWNSqS2F6w==
X-CSE-MsgGUID: QefrlsT8S26YBc+qQVmJQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="73153883"
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="73153883"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 08:51:19 -0800
X-CSE-ConnectionGUID: K+Nx1SC4RnSN7C95SC+Qxg==
X-CSE-MsgGUID: 6FInyPxfTOGyteg2Cqooog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="215058000"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 08:51:18 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 08:51:18 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 25 Feb 2026 08:51:18 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.19) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 08:51:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iYJXnXE13yi9XP59ds1C2Od6bMkwa2amHbdjpirNrPUYnPbZNqEoHbR/136uldWgGWiD1sECQE1rBDPeNUzZROAXr+wC23NRYvGIYkgxzQeN/vHP1rhg5FJ5AuxNE97yhJiElCADIiAXqxtho953BY53Kd+zF7+80aA1V5H8NJ9wSWEb+obN1FyrJooC7hVHy4FfN6MVTDBiW+kjn4FId/fEbZs2uQj/e0HwJ+p2+Ow0azneHAmB+WfKpyjjmoHG4BJ2EwWIV3aDXkkMNG3qeEf4kNKUgESmw1z1FCe8dyxby3OEVyLGecdhZiBBzU+0FmgmWG8rHhurkQwzOH5rnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+deu8mCvPW4vl8jQj8JRsNTKwy+KIPg6rnvnHwOmzwk=;
 b=iOAz1hyCRhDNQlI1Ehu1MwQ1ItBH3tdNiLvZPBT3Q6UfeWDuqZoF7JoHQMcybeZ6OH9ZzzdqkkNUQyIgbVNmW6Wl4SIx4Ke/6SQT3/zgLWVRPdVZaH9rmRWOlbIFLwUZjGOWI20VMbAXUkjNiHMbWQqCYRfyYqczpoSurfhCfdCyYN914FjjDC8tCeC/QCzwpWIMY0nkCGtB56bLGQ+/oGyBloTLvQkPyTOkRNzLKjgMm6vSJ9o5wVRG68GPiLNX6cXr9pEMmoMn29eCcs/edbEaIzc1gB9CTEcxid48MuoCfQZFN5DxwpGXwVFS5eGbquG4ETSQrqPdBJm/xhV6IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB7991.namprd11.prod.outlook.com (2603:10b6:510:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 16:51:13 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 16:51:10 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 25 Feb 2026 08:51:08 -0800
To: Alexey Kardashevskiy <aik@amd.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Dan Williams
	<dan.j.williams@intel.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom
 Lendacky <thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Stefano Garzarella <sgarzare@redhat.com>, Melody Wang
	<huibo.wang@amd.com>, Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel
	<joerg.roedel@amd.com>, "Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth
	<michael.roth@amd.com>, "Suravee Suthikulpanit"
	<suravee.suthikulpanit@amd.com>, Andi Kleen <ak@linux.intel.com>, Kuppuswamy
 Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>, Alexey Kardashevskiy
	<aik@amd.com>
Message-ID: <699f287c44cf7_1cc5100e@dwillia2-mobl4.notmuch>
In-Reply-To: <20260225053806.3311234-6-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-6-aik@amd.com>
Subject: Re: [PATCH kernel 5/9] x86/mm: Stop forcing decrypted page state for
 TDISP devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB7991:EE_
X-MS-Office365-Filtering-Correlation-Id: a2d5551a-6c39-4d0e-80d3-08de748e13af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: nzI6Hr20uS6/iQdTTqMfrCDtfnDMU4KKKXYgMTQT5m1kuAXjpbW78f0rp1QiASCG1hGOswGoig533CGo4sG9ErotyUaJb24McfNcwNKxGVwVUF1ZMW81TTAeJxFQEbQGFONMiJmdDfpvcVCHRUYyyRGUVV3Y2tcHNthMQgGdFCJcrLeYFORU8dT2CDkpDuk/BI7rWqj08aboBP1f4oYOZak4aXOCccT9Vymqu6ZR82OQsIukzdtuTOBynmcbIuZBGMBbOlR1hEvfgw+JwhwLyXFqviRWUBWHKu8vg3MjpjIEapPqDrZrskIayUlvrGwZKnfi+HzXhk4oueILWVsHg8HQzJBvlHQ0Z1evnBRm+zNeOhlFXuMumMIEheBEhYNzeyMxQ4yeBfNdDC4w9rNP47ldJ+6srlLa5spk+ZKw2UXH5vjdRb4Q9dqeB6tdleDTBljetc2q+TtYiB4vykcGLpcojBo4POgQB2HdVFjgxoh4DyDNsxpCTEIwahc2EXQ2DR+aZOwHLwolLBE+m9ZLqe+l6tHfOmUXFkF7xwLPWYKsJcZOndKUFMXRA6HsU45ef8lK0GMnX0gqJUtzqdAawLUi1Qhq5lvN1NG94yMF8XKm6FFLp0t9hwVy3nt2kpHtRiZrly8bxlRQbRCq3Nr7C143kFvFlDhnlKhqxGns7XeL7j/K1zn078R8xnz4aPJsiwfZsC1Yk6rsl+vPS2R/mJ0yBX90kk6bIGAEJ2MxSG8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDE0dWl6aGpiRDFLWHpHTTIyRDY1cHFOU2pubHlsQU1sRkNoelZuM0JFSmk3?=
 =?utf-8?B?N0xTRGJnTzNCbzZEMlZOQ2F1dUd5RE13NEE0clduNHYrT2tnNGV1bGRBL2wr?=
 =?utf-8?B?VnJ0SkFHOTBGeS9tcjgrSjE2TElJL2FzMWRIQUlSWWppaGZpOXpDbytqR2li?=
 =?utf-8?B?YStpbkpWTGRSUHQ5RzhlZzJhcTgvUVZSSW9EVTdxRXZlQ3dDRkw0SXUvWHJN?=
 =?utf-8?B?YklUNGpTbHg3NDFiZWNWUDRIMjREMnpaK2NRRXpQaVhTMThXQXVidUtLaWVt?=
 =?utf-8?B?NGFKM2JZcld1bkM4bm1YQWRBOFpwQ3ZCM3lpeVErdUFMUGVzS0Q4RDBrNzhW?=
 =?utf-8?B?ZWRJeEF0V0NrRkFzU1hCaWsvR3ptZDBsdk9ZSXVibmgxS3RTVDlURzJFZzg1?=
 =?utf-8?B?K3RpTGl3Szg3N053czNOWTI4am10cEp5RkdHTHNjT3llYWRPMjJqdDdSOVdZ?=
 =?utf-8?B?Q1FHcEtjTEFCYUNjdzUyVHdsRGNRT3d2NUkzSVF6MDc1STB4YXFmaWRJNnNn?=
 =?utf-8?B?ZzhSbTJPWGphelpCNWdOZGh3ZHBEL1ZQcTk5djExSW9xRmluSngzaGRuNCtH?=
 =?utf-8?B?VE9uWlhrTDF1QTAxZ0lNbmZlY2RhVzNiMVU1VmhOcXRSZ3JhRTduUmgxQ0dK?=
 =?utf-8?B?c054OWRNTVhNQ2VwWFIzakJsY2hEOXRqYTliZzFUbzZGWWpubDZMVkYvQ0ty?=
 =?utf-8?B?d2NwV01DelhTdWVXYnJPWWlRL2JGRjBRZHUyL3JhOWZBdjFNUE9EYnJzakE0?=
 =?utf-8?B?R3dkb2JRTTJHUXVCclJnaFBjcktkRmY0R2tHYlVtRUVIU1B2SGRocUF2T0to?=
 =?utf-8?B?aG5zLzZPeCtQMjB4SXo3cU5yUGFrd0NaYlc5TFkxYmJxOUgyWW5PaDQyQ2FE?=
 =?utf-8?B?bEI1WDNLVExId1ZiK2pJMUhJYWNwTjdaU2JQOUsySGVHQ0lKSlNKVlNPaEsr?=
 =?utf-8?B?ZVdRb1p1V1RucUZpblUxMTdHVk1FcHM1d3RPSjBLaVlhdnZibmQ3YTBUcUQ1?=
 =?utf-8?B?RGt6aUNFb2NQVGtnMG1QYTVCcFBueVZ1aUFKQmtqRnJBZnhmYjBLZVNBWDlU?=
 =?utf-8?B?WlNzVUUxbDlJNkpkVHFRRWNIUlJndTVyYUlYSzF6N1dkdW1qOVdxQWNLOFFq?=
 =?utf-8?B?S0NPd1ZzYVJBKzQxWFZHcWdkTDZVdkdVQkdldUJITlpxMmRUWVFKdk5CQS9y?=
 =?utf-8?B?aXVocEduc09BUU9ZcUI1eHNBSHB0T1I3aG1uRWY5amxuanlTVXJobVRtQ2kv?=
 =?utf-8?B?T1lRczU0b05KelNaSjZxY2JqR3V0azBoUEVTZTNIdGVZWkFBL0J4dVc3d0k4?=
 =?utf-8?B?Vjh5d1FidU80Q09lVjhkb0FVcDQwU1UvVm5zdGJOVmVhcEZKcEFiUW9wVmd2?=
 =?utf-8?B?Q1k4bGJVcjJEQTd5a1ordEJZdTZJUlIyVDlSZDNNV0t5YW5RU2xyL2JqSTZT?=
 =?utf-8?B?aXdyTXNlNXlzd0xGK04zVVUyREdJOXNNZDUzLzY0bWUrZkIwMENrUDFya1NX?=
 =?utf-8?B?UC9tNG11NVBWcHk2WVVjMlFyVWN2enVxV3dWZjluWlZLVE5HUTQzWWRXZVU0?=
 =?utf-8?B?UVcyTUVTUjMyc0tlM2pxczUxQk5VdG41OEF6RWw0RW9xWFdtbDl5bjk2Sk5t?=
 =?utf-8?B?YVZOVFNldXV1QmJsSzZkTHhETVRDR1FwUkR0RU83a05XOVE1YmxWa1NqaUFq?=
 =?utf-8?B?WmVxMFNzdFlZeGRJN2FpdTBlVzdoeHlVaW9ZWVRqRnJVKzZzdlJQbFBhYTla?=
 =?utf-8?B?TmNtK1BwWkZjc2ZrUDdESFQ1VlN1OXpRWGp2UmlsMVRkSXdCRSs0R1pVU3U5?=
 =?utf-8?B?Q1NkTHg1ZXBLalFXZVZpQnA4ZXZUU1FOMW1FNzNoQzVtSFprMlZPdE9oNXZs?=
 =?utf-8?B?cGlQcWErY0ZHV0pWTkE1ZWUwMkRaNGFNQmRoM1M1UzY3dTVZeFpDSGtmNE80?=
 =?utf-8?B?Kzc2eldMOGNrU0wwU2dJbEF2aXhvK3U2T0k5NTV2d2puUXQyWUpOTVZ2Z200?=
 =?utf-8?B?UWl2MjlHNzh6Z0orMFhDZU10OTBlNE94SDlYL1l6dTBnMlhRcHV5SzhRSUpv?=
 =?utf-8?B?dStEa3M4dTRZcFY1dGs0UWFVWklzZGloUW51eW03YWd4WUNCU1ZJZTNkM2dV?=
 =?utf-8?B?UWhZN25TdlBVSjBOS1VIUW5rcmRCNC9RaGZKWFVEcnF5ay9XaXFsR0tYSkll?=
 =?utf-8?B?UTliLy94cTNVbFowTmlJcWtsdVlRZFJrVFNIeGdLRWZ3SXd1U1VRdzRRNzdh?=
 =?utf-8?B?VFAwejY0MGF2R0lTblB3SSttSktWVHcyNkVVVzZCc1ByVlJHcCtnVmU2ZWZr?=
 =?utf-8?B?UkQ5NUlyME5TRHVKNjg2d1ZVcldxaGxEcWpoRHc0cW1MeUpmZUI3a0NvZjdF?=
 =?utf-8?Q?93uDV8q1lwv+Jpuc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d5551a-6c39-4d0e-80d3-08de748e13af
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 16:51:09.9095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJU/DC+60pqr4cbMbXRh9U2kgDnpMU/A1ndCfZF3IVVxk5bua4GxCBbrGmNY6m6e38gKSdlMMKPcAI4MLlsJd5Bfby2g232eMPRaT+j5/Mg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7991
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71850-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,dwillia2-mobl4.notmuch:mid,intel.com:dkim,amd.com:email];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[59];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 342A019B05B
X-Rspamd-Action: no action

Alexey Kardashevskiy wrote:
> The DMA subsystem does is forcing private-to-shared
> page conversion in force_dma_unencrypted().
> 
> Return false from force_dma_unencrypted() for TDISP devices.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  arch/x86/mm/mem_encrypt.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 95bae74fdab2..8daa6482b080 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -20,10 +20,11 @@
>  bool force_dma_unencrypted(struct device *dev)
>  {
>  	/*
> -	 * For SEV, all DMA must be to unencrypted addresses.
> +	 * dma_direct_alloc() forces page state change if private memory is
> +	 * allocated for DMA. Skip conversion if the TDISP device is accepted.

Looks ok, but I would not reference "TDISP" here. TDISP is the PCI
"accept" protocol. Other buses might accept devices via other
bus-specific protocols.

