Return-Path: <kvm+bounces-71846-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iPQ7JHMkn2mPZAQAu9opvQ
	(envelope-from <kvm+bounces-71846-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:33:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5EC919AB6E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:33:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2EA69314BD59
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 16:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414583D4122;
	Wed, 25 Feb 2026 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TLYf4Tt4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C592C3D5254;
	Wed, 25 Feb 2026 16:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772037010; cv=fail; b=gqsuIeLxXG37vyisrfrWndaw0hVx3/6ulKP/aKEVIxGtApZE7N9uVgOQaqlXKX4BwKcnieuQCi4PpSMhQfUJbhtNUR1s2ijbCCnkNTDvPtnhpXUBvy9crxp61W0Sy5rLbv8w7zzDqdukNXDDb7Qt6g8h/KCXM09Yi/n265nwbHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772037010; c=relaxed/simple;
	bh=V1HQvOv2a05yxy2T13DHKnhILLGzFdAMKk3eatWSU/E=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=ChSlFpex1DqlxemEY8++AKK336BztFSTSgr1Kdi30oJ5CH2zZx7UWHBUfHb9+Xf28RgIb2UlN+yOMvyTL0W6UEdm/Yny8y0s0XKPkaX4sQBXIKRvLFHBkcbF7ueU0fJDyqyM2sFC8UC1lq0EDPeEkgn9UCUs4e6PNGCYp3xG9eQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TLYf4Tt4; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772037008; x=1803573008;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=V1HQvOv2a05yxy2T13DHKnhILLGzFdAMKk3eatWSU/E=;
  b=TLYf4Tt4+ZaYhXd7QRsdAekZkhAXdcZS+l5PCKNML8cJH+TY7Lj7NT4F
   PMPn3GpS6b+nWxvlYzNzSrSpUcDCcF37H14uwmbk/TpWOnbqHxwNm6VR5
   jseTbzgBhaULs6hoB4ojfF6T0a7yE0y1H+NUk2jC9P+xXA0FRvSOhT3uV
   Au4UCoWOvNJPYPUWJ2QNjFEED2BkN/fHAnxHhZLqge1+6r/KuiEaZHwbA
   edRHY/kJtpQ5A8MKDWeZF6Kx/u8+qrcFb/oWbo+7qIE6S+iJ823/1H/I4
   W7zuGJxmrdkB/jy2x6uhrbvhu7mQE8KG7ozrpWrKfu9uB2A2woIrdmnjT
   A==;
X-CSE-ConnectionGUID: wLvUu1EPTMuKSmL/C2802Q==
X-CSE-MsgGUID: VvuyXCogSEmBlQUsXhxucA==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="73125303"
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="73125303"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 08:30:07 -0800
X-CSE-ConnectionGUID: lSgTBuxHS9m3sjf6Jz5nDQ==
X-CSE-MsgGUID: 5TjxIB3VSlOHTXLYfgvB6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="221276355"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 08:30:07 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 08:30:06 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 25 Feb 2026 08:30:06 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.40) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 08:30:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y4Myx5QBHSpmdrSmFE/a4InfykvbOKjvc+TpDcOqpRixPM3Mon0lvO4bUxvH0/3vZKyEggTXOoz4tMoICHMCE0AGMRnmRBuwA3dGn/2U2ubnHlH94jQqsCdDvl9taZ1mBPX/4TUlidH1n8bNOH8g9bOWPTMcW3w4ECRPQuPrnoOm3Sw8rbH2YrgWDCqFKRLuEfRcpDHq3fW2MlMVZG74Z/Q+LVUKRFGPsQHpzzTwPqiDBrEwGYi4UouVUCW9EvljIKzPt6UTL2FsXNu7ry/rVSADgutfFnPMZ8nBMOIcpWTos4E83Mod8I3m8NKzRUP+pqjEhc6jWXCeMwZrs0/3AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HF/BprbQPlP5XBt5uUEl96jiUvX9QdsASSJb0S8B3+0=;
 b=JaiKFE4fHf54t57fHwRdboVMu8+F16Q6/DGlwJv8fmyOjzJ/zzo9mrx62fxwOaJGIhUUmfZol5YrPUud7cuup85cembUOGZ0hfQhv4uhiy6yKRL23AqS4G6mwLELuDWc8wUa9IV28EPt35K52G/JPq2pZOPJtSI49PTs5PN7AhE0Qbx9hK/b+MZimP6essROENUKJ+1iYQA4UTRjAJCEdMAbaA8KK1cDovgAXXNpzdQRiSs1pF2Kt+N2BRQ1FlMn0QWr0uIrHL5rqW+h48SrCi2IS5oYEPxP8m5f24Optg0kNZzXdoYa1hjziEc/gS2+Hd+wEVkcX3iEh01pS62SEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB6176.namprd11.prod.outlook.com (2603:10b6:8:98::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.23; Wed, 25 Feb 2026 16:30:02 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 16:30:02 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 25 Feb 2026 08:30:00 -0800
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
Message-ID: <699f238873ae7_1cc5100b6@dwillia2-mobl4.notmuch>
In-Reply-To: <20260225053806.3311234-5-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-5-aik@amd.com>
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0086.namprd05.prod.outlook.com
 (2603:10b6:a03:332::31) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB6176:EE_
X-MS-Office365-Filtering-Correlation-Id: 219a5298-2cb9-445e-9852-08de748b202b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: My3TcB/dfd6WyloJJvVZfFu033daO8AV4MLbqLLrZy42CCrOJm0QF1aWP9p3fbo9/IJC5Fel8uz6CvRvTMsnZNpeFcBQ8HurKRbphXcbn9DUKvRWL8M1kKTgy4NhyoA03McbaYDPiZ43cSM+3KiMmyk0JaJPiGHBH2VKYSdQ1k3eMW1BpQeQLzJZ1z+HLYUR0/Ku1+avq6gIHMvMUtozqbCPtE3NkSltxj58altmXHc1sn2wmgZ0Y9WldFxdGpH9BuVDFUtQ9M1ONV2jTVUQ9w/+80b3vC6oqltKr3K4KZut2SgCtqp7fuFUey6fhggnzaXO2vOGMoiL7J+y80AxWxlupMrmv2OpSoOcQVmROzzlpO+3XVSoCbPDodRsbkmVey6fHR+I9coZw3dG3jDsugOP7VRNeO6YGFaw1cyhKJSbF0U9QOgJlVlREve+8YufvS3026JcwhbCqySthsmeWsoIaFAoLc9ekJ+zzgvNwD8/BSON3SMSudB7sHFLr1FZ3NfIj8RqsvwXbU6W740sCd3h7ovVs4C+yhSM0Y6htCcnl+99dHA+0sXOyFueZtpeCYsAc9yQs1MUdA2Wy71HGw/HdaNzNdj+jfcYkfwqUPoOe47/AOWdieGX+vZSSDUhyd67+k5Pgk6HkQT2ouws+6+FuQx6wawozoEZt2CTD1CApAYWOFFzy0NWbh4PxkJmjkWypNMdjaIDQQ9x/6CCjE/TQ4J4bAMdq0rcRTgPw0I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG9hTDJIZG1zUHplazY4RFVlUSs0TjdxYno5NWRpVDVDb3c5dXF3OVdFS1Rv?=
 =?utf-8?B?NGhWdVZDSCtPYVJYUloxMHROc25ybFluOCsxcjZaVmNkR0NuNEpDL1BxY2tt?=
 =?utf-8?B?V21DRUVZNmxvTXNDam15OSsyTXRrS1FNR1dIT1lHemZqazd3QktaY1lFM1E5?=
 =?utf-8?B?WU9IeER1Nk1CU0FjTzFKTUE4TVZRUWJ1a2ZONzcvRTJhZk5rYXozanl0b2hC?=
 =?utf-8?B?Q3ZRWmw1YVBlc296b1RXcmF5eklqcUMwcHk4amF1cFpseHBUU0xsR3h6cVh4?=
 =?utf-8?B?M3lQa3ZuM1dHTE94RGZRTWZ2ZVpTVmRNd2Q1WW5yWWsySDJOWG1IdjBWNm1C?=
 =?utf-8?B?T2pBR2tLVVJLTnNleW5pRUxwdTNWd2xselNLbkxFb1lFckh5Q205NGVTV2M2?=
 =?utf-8?B?WnI0ankzcXlob0VjSjBYem5ramkxdUVCQnF0WU5DNGl2cms4RkhiN1RuVDVs?=
 =?utf-8?B?a29pS21rR2Z2NnV5TGExdnpqR2VrVXJSNmxkUk5OWEdwZzR0ZE1nQ3ZQb0pE?=
 =?utf-8?B?QXZlMlFIa095RTh2TXhjeSt1em1tc3FmUlc3R2RxU1ZuaWM1TUx3L0RqRlU1?=
 =?utf-8?B?NXBNL3lPNFowbDhlVW1qZmVoT2NNMUJEVDNzbGtNQXJTTXNNWEYybjQyL3g2?=
 =?utf-8?B?QTFCeXdGNWRuTmhZK2lkcHNjOURQOWdJODhJcUsrVlBhTk93dmZDdk1hN1dE?=
 =?utf-8?B?a0x2ZkY2b1diVGlQTWNCa3prYzBYcjhFVlh0SkRKN1kzZms4RHFsR1paK1ZK?=
 =?utf-8?B?OUlINFM0OWhHRk9ESjNwa0dPVUFOM2RSejRsZGdFT09Fb2Y4dS9pcGlMcC95?=
 =?utf-8?B?Qkhva0NpZUpYbS9QbWl0R1FWQm9LRTZsUEU4S2s0bzIyWlk1NlNOVjJaVWpT?=
 =?utf-8?B?MzFBaklaMDNtSC9tTUczWnF6RzBEVWFHeDZXbE1GSHk2TEMwU2d2RXRzUHp1?=
 =?utf-8?B?YzFOZkRVU3E2MkFhY2FyaC9uKzhkS3drdUd1ZWsyS2w3R2ZvZWtpVUlYbFAv?=
 =?utf-8?B?WU5vUExDbThHSldBMEtBdWJUd0ZmZHVQcXpRN3k1SS9MOEJXZFkwaUt4M2hz?=
 =?utf-8?B?d2dUZHluR1JQemNMNzRPVkJlL2NOaThaQ3g4aEloMCtvb0Jna3VxZmZMcEZT?=
 =?utf-8?B?dGJhZW5mT090VVJjZjhRUWNUd1VHOHlQQ2tocmFvaVVObGpzZHNZWFNVZVJM?=
 =?utf-8?B?MWkybXh4NjkrRk51aGRWaUkxWUxBNGtSVzZQdWd2RUZrdnZaK1k5NnE3S2hu?=
 =?utf-8?B?UnFoK0t2QTlCUFdkM3NvSmVVZTZQK2FiYlUzRTlCdUZJdFVBRTkvZHNWRXNE?=
 =?utf-8?B?UkVITkwrczdoNndESXBacWoyNE5TTU11ZVc4Q2tWTm1iZnZSVjh4SndtL1h3?=
 =?utf-8?B?dlgwNXRDai8xd3Q3K3BuUmNmREZQRlZSd0hFVjM3cTlvNUhpaWpOZ01HMlZM?=
 =?utf-8?B?bUg2c0VxdHIvMTNwQkM2WmRFcVNaZXRHMUw4dUh6cVZtMnYvZ2dMMXFVUVlP?=
 =?utf-8?B?b3BIU0FEQTdqbkkxMDdnazVwNTU2bnNjUW0rNndzVEtHVXM5RnNVSE1LTWRl?=
 =?utf-8?B?M3lSVlNWMUdVM096VDQ4RG1JVW9wY29jSDNXZFpxTWp4UTlPSlhRSFZnN3Uz?=
 =?utf-8?B?Vkh4Z2FySVRaQlpMN1J1dnlEL2EyTEsrcjYzNmRjRWU5R0R4ZVJQcVVtWlBK?=
 =?utf-8?B?TUxmMnh6OGhZbmcyTkdlYVdUeGNIbjFXQ3UwR1IzOEVkNDh6ZFgxanZFcGJU?=
 =?utf-8?B?eGttOUFJcDlHL3dHU1hZMXIxVVFYS1pFRzhiRnJGNk80dEpBcHY0eXBSM1Zy?=
 =?utf-8?B?aDlRVnZ5alNqV0RObWJPRzM2dkNSUGErTVZkQVN2QnRTZEN0M3ptUE52a1ZR?=
 =?utf-8?B?V3lKZmFyQi9RK1Z2L09oWHVKWkJFTHJnZ1IvQVVXRDFkNStzMFJmb3dvWmNW?=
 =?utf-8?B?Q2dxMzZ1dlpvV0pkVkNNc0pXRzRhNFNNOWJjK1RQNWY5VEEvTmZDTGxGbStQ?=
 =?utf-8?B?dS9KOXhVVE1QWUMvY3p0eUxxQ1k4Si9SK0dveWYwUnNNYkF5OXNEWWdyWnRM?=
 =?utf-8?B?QjVwV2xDbFJ6NlEvUEVaSk5CNHpHVk9BL3JScEVBOE1MWVNlY3ZzK3B3bU0w?=
 =?utf-8?B?Zlh3RjBOYjZNMEoxdDJ2RjhEV1d1N1VDQ2FVdkpBclRxUmVqSElNaHJpdlMw?=
 =?utf-8?B?U0RoTERCWksrL1R1eDV2QVcrNnBrcFB0NC93S0FLTlI2Vm1DaGNNTHFhMVJX?=
 =?utf-8?B?TWVuWUEzNWVEYllFb01rRlR2ZDd1UlF5VFRGd0F4eTJ2WGJheVlUSUtVaEZs?=
 =?utf-8?B?cllrNUZsVGcrTThkV0dUSUl6RGllVkFueHczNURYc1V5K1Y2NzY5Y0YvNmY0?=
 =?utf-8?Q?on7G2Aiqw5tpyKdo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 219a5298-2cb9-445e-9852-08de748b202b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 16:30:02.4695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J/Z3+qCYWC6tXXzEXz3m3B+N5MIedwOK6mV3AdHbN/h/c0iSBv8R4HB+C1tXCiWaaN3f8+hWtQTgzWbOLVEBy7cZlv7pMUDGfDSuVqR7uLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6176
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71846-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,intel.com:dkim,dwillia2-mobl4.notmuch:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: E5EC919AB6E
X-Rspamd-Action: no action

Alexey Kardashevskiy wrote:
> SWIOTLB is enforced when encrypted guest memory is detected
> in pci_swiotlb_detect() which is required for legacy devices.
> 
> Skip SWIOTLB for TDISP devices.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  include/linux/swiotlb.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index 3dae0f592063..119c25d639a7 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -173,6 +173,15 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
>  {
>  	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
>  
> +	/*
> +	 * CC_ATTR_GUEST_MEM_ENCRYPT enforces SWIOTLB_FORCE in
> +	 * swiotlb_init_remap() to allow legacy devices access arbitrary
> +	 * VM encrypted memory.
> +	 * Skip it for TDISP devices capable of DMA-ing the encrypted memory.
> +	 */
> +	if (device_cc_accepted(dev))
> +		return false;

I worry this further muddies the meaning of the swiotlb force option.
What if you want to force swiotlb operation on accepted devices?

For example:

@@ -173,7 +176,13 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
 {
        struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 
-       return mem && mem->force_bounce;
+       if (!mem)
+               return false;
+       if (mem->force_bounce)
+               return true;
+       if (mem->bounce_unaccepted && !device_cc_accepted(dev))
+               return true;
+       return false;
 }
 
 void swiotlb_init(bool addressing_limited, unsigned int flags);

