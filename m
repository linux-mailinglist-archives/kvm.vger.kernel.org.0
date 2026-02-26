Return-Path: <kvm+bounces-71915-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +M71H0Sxn2kadQQAu9opvQ
	(envelope-from <kvm+bounces-71915-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 03:34:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A1F1A0216
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 03:34:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F947303BB0E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 02:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7CB286D70;
	Thu, 26 Feb 2026 02:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kF0V2aOM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CEA2DFA4A;
	Thu, 26 Feb 2026 02:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772073262; cv=fail; b=lSqmaoDpK6bGcm3oGDl389Ivre4TH17PNr6aD6LyZx/p3G8NPV7SIScon1h2XJ4Gj6zJ3PYuDN4eXgevffvoaK5QqCKG/vUKQe4Jpe5zVIoQ1MamMYCMrGmK9rB9J9Y7JSp1KrMlc0x/GgIlpssEPhCsAi0yBFdwXaOSyhxmJUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772073262; c=relaxed/simple;
	bh=pcyyvxkHYbqQV1Iv9ZO+ltRJHNzekjLleB8C0n9pmKw=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=Z5ozIYINu3N3NC+LuKhqbpAvLp8wxT7u6aDPShWQZeHNjewstOyTr7hvwpLh64VXKT0LYW3jis7We8cSJbupMlH4iTYmbfi3Ncx/KF4yOXWmVuY81/7y/2ZKJQN8jKG+PSxuKCVQdSLR5r8coMEk3m38pz6Vq7n+SDzESBLomlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kF0V2aOM; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772073261; x=1803609261;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=pcyyvxkHYbqQV1Iv9ZO+ltRJHNzekjLleB8C0n9pmKw=;
  b=kF0V2aOMPyjM6s0kklJ87GJxUd0gIhKZjFPRftE/em1kC0cTB6+MjBg6
   UrIOQxpHl+sOxGuv4bNaMzIWiW24fEmnhRslo/KqleeCf09zZxyuPW/UK
   3YmGxqNMV3aX9iN89pNip2q5nuiyD1IRrM15/4aK00Suk7HFbKmF+kHco
   uRTRJMusL5ZPuxo5FuixlirHBMQFWA+a2cplxVdPLWhSmjECYoY2hHqoX
   MC4ioph4Um8T5rrYImImz/bq9pFAnhYAugG/Ls5nOEy4bClwwUfqUOHc8
   sGpABqxLz4mUCyI4snfo/2WgQRXA1nkr+yc0O/N/IHPvviwmOztwLJ+0m
   Q==;
X-CSE-ConnectionGUID: xPT5nYACTFiuaa+kT8uzdA==
X-CSE-MsgGUID: CgRxxNQzSv6pb5ZqxKvAsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="73195655"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="73195655"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 18:34:19 -0800
X-CSE-ConnectionGUID: wfqCNKyLQtqIjude1tP+Lw==
X-CSE-MsgGUID: Dmt3rqRRTJiytUxoX0VNZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="220551248"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 18:34:15 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 18:34:10 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 25 Feb 2026 18:34:10 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.18)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 18:34:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YWMJa6SAsYSd4AMvvVoN1uT+5+bKVXWTMkTKYGzA3BQCWTmTIanvxoy8vK7YfxQjarjvR1x7C5Jtff/plu7M+1V7YDxMDXHFVQ3bYvuvEqWFQ/eVX9A4e393IC0wTZPNpQiYd80klPhUCPyOJCdldT39m11JpOQ8QiSeDlhPzQdsPkZrDTSdxGE5YA8X5Mrs0kJjjt4Gdk8Z8dpvZ46z0xcDIyd0Nj9zCJVaKPxsAtptcmmKTZc+8cZdEQRdjlU7aI+wjOVq3Kh7+hlI4ESrTVT+rqnV2PZZvD4jJoKmVsOiMM6omU5MnMPCWEUIjZsJcvIZnG0LcrwOC1fvtwxhkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eS9w25MH8SzARfgq9FdwFMcPkpi2s2pv+L/Q8m8VVOQ=;
 b=IPgiscrm9qc7071leOdiJvSqYAM5RtpEWESkH9uMKQn2VIqiX30n6jWM/Sq/aES/h21EzB+VM/3e7NOEvGv4DnfUoqKlkNl5mLCY0SoQiF0ugpXP3jGkHI66kd6gsfivQRViDjX4x2t9e2urv/stPkD41ZCAOIdhSuO2KdzDOc1Nrcm5wSTtw5G+t1BJ5OwV5DOCWcrbrvfbs7cVBKwaqCOthl5UxVboteBihM/Fr6PaWtmcZ0QZpGbQpfsDdqpSeESlc58knwkVIQXHN/ghCvmqcKtCAaSCxZJRdoEusY+uDx5QNPjRSIFzcQMw9CVmHleh2UN+jwShSZpsimvgjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS4PR11MB9531.namprd11.prod.outlook.com (2603:10b6:8:34b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Thu, 26 Feb
 2026 02:34:08 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9632.017; Thu, 26 Feb 2026
 02:34:08 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 25 Feb 2026 18:34:06 -0800
To: Alexey Kardashevskiy <aik@amd.com>, <dan.j.williams@intel.com>,
	<x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew
 Morton <akpm@linux-foundation.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Michael Ellerman <mpe@ellerman.id.au>, Mike
 Rapoport <rppt@kernel.org>, "Tom Lendacky" <thomas.lendacky@amd.com>, Ard
 Biesheuvel <ardb@kernel.org>, "Neeraj Upadhyay" <Neeraj.Upadhyay@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Stefano Garzarella
	<sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>, Seongman Lee
	<augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>, Nikunj A
 Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>, Suravee
 Suthikulpanit <suravee.suthikulpanit@amd.com>, Andi Kleen
	<ak@linux.intel.com>, Kuppuswamy Sathyanarayanan
	<sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
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
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>
Message-ID: <699fb11e94082_2f4a1007d@dwillia2-mobl4.notmuch>
In-Reply-To: <d8fd6e0e-a814-4883-9e58-f1aa501e0d8c@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-2-aik@amd.com>
 <699e93db9ad47_1cc510090@dwillia2-mobl4.notmuch>
 <d8fd6e0e-a814-4883-9e58-f1aa501e0d8c@amd.com>
Subject: Re: [PATCH kernel 1/9] pci/tsm: Add TDISP report blob and helpers to
 parse it
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0137.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS4PR11MB9531:EE_
X-MS-Office365-Filtering-Correlation-Id: 90b33884-1e1a-48e9-10a1-08de74df847c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: DxygkcaGdX9FjvJ5I1KkycClBxKUbtKyX4cnFmXXF+hejuigABmFoo0K6G5jqxg52MuqIgQMPPfke2JPECgRatJ3hxq6LfSWstINJAByp1Pazi2zD145FaZiF9JTXlDtnABNt64lx2vf6xt5j/+0j8GVmLNxGD2Xe6pNceUy4Jh1cGvSsXqmKGtOzRkH2sK4S4X9Hk1bVBPchzGodMDnWY9wiCkqUesgshLyjor5816DPxIwfhD4RdUTpyygaMM+0M/bQteWdr09Ge6D2cGrUy9io2AjyhnYgqCaCUY7fKu5FVoNBGcujFm4Uxv1Me5gS6bQoVNwuDmLwbFdWNlndJiFE+iLWgIkevr4/1wIvPVzfUiOdRT+Np+Cd9JLErtSC+rqK+Em+3BYFC6WUSdFyJ+Csrivfn1KFIS447wrErbk4CfMRUlnga/uZr6RG844zJHFLFjjRu3gFWOaF//yj8dQIiOX1cAjDeTcLTGWhbWKmrfmSoQoqo9vX15IAJdQnqwjeAyMlMz3uI6R0F3gEGty5w3IJafJXi37zGhvwJG3TgmqJmMlGrtlYVWEfhYkdt0F++93pXyDZDdEZmNzRLGo+1oRtzxfTeJTP0sbsBzN0D9JY2fzikRD9S/YKbdCY7b0hylKxTQiO913wwCbTFx5LvgfAOMzSapLFqS2GeHa33G07wHpbrt/mSOy0+G1AmcMUHDR32vS5HY4POshZ8/BuEHRRs1xNJBBCflMQV4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WCtUNjY3UXVlekY0Vmc2b0Z6dVBENjZ2TnpmK3RCMzBqbU1BYi9NM3FxTk5j?=
 =?utf-8?B?cm40czcyalhnZkZVS2owcDVCLzdXckZwT0hGckhDTzlLOE1uOFdVSmJvcVZq?=
 =?utf-8?B?aW9TeDhmL21SNldqYVc3bG50VEVqWjZKSkRhaDd1RVBvTjBIZk5sbG1CSFA4?=
 =?utf-8?B?aGxIREMwaVB5eVZBRnlCZllZc0Jxa0E5QUVGd01ZNUtLdmpkTFNRblJORXdC?=
 =?utf-8?B?ZkR5NVM0cEZpNWpUV1o1cnA3WWY5S3hkZXN2d3g5SWVtT2pRR01kajh5NDk3?=
 =?utf-8?B?aUZ6cVBnbk5SSnJseGxGNk5YLzVIYW5JSHl1ZkVTNU83YVREdVRiZ2Y5ODhs?=
 =?utf-8?B?a0dnSlk3dWtCeHI3b0hpQzdBU05UV3h0VCtnOE0rZHU5QXhFWFFWbitneWZ0?=
 =?utf-8?B?OXprL3ptdXZuY1hnU1NRS0VsTGgxcGdYTCsyTEJ2TTFYbmhXUDQzcG9udzZK?=
 =?utf-8?B?ZjdBSjMyYTl1YUVJdTgwN0N2ZitGTTM3MmpFcmlXMTJiVlZ0U2w4bUhBaHha?=
 =?utf-8?B?b2RzcTFyZnJ3dUFjMlRkTVRFM2NRRWphMXl5N3pZQ1JiN1h5T2xMQ25KWmUw?=
 =?utf-8?B?NWpSZG5WZTB1RUV6c2JHTUlYTmJHM2IrWEdTMFhhWWVNVGVpVksxVlYvbFBC?=
 =?utf-8?B?TXYybm11Mmp6ZU0yVitxQ0dTKzNPS3ZKczl1bWcwQkpuVnNORTc3ZHNBdjFy?=
 =?utf-8?B?TUhyUU1nRGpwR2o5eDh5VTZYQkdzM3ZwQmFwVmJqaHVxeGx0VXV4RGllckl3?=
 =?utf-8?B?Q2w4Z0VqVDBuK2pRVmdRWkE0cEhDcVpyc0pxbGxMOGluNkZQOFdFcE1TdVVv?=
 =?utf-8?B?YlU0eEJJWjZ0Q2k5MlJpTnJrTnZoSm1CcEZQWEwvRFd3UDZ3NG0wYzFOVFNX?=
 =?utf-8?B?MXJxbzdhdkpLZXJoamFpdCtLME4rb3RSbzFaUlFVdG8xbDBxUlhUNzdETVdw?=
 =?utf-8?B?c202NFdiSkpCNVVpUFlXRjdNRkR0bG1sa0NJamxBOXJpeEtGNUpWdDJaQ1hE?=
 =?utf-8?B?WmdHSUs2SzR0VmJLNnJ1UzMrK0NGMnZwb09yUDBqbDlLWTJFWTYvaXFEQVNo?=
 =?utf-8?B?SHd3eERPM2Izdy9EUTdWaWFiSlRObVMwSWhQNUNkbFNYUXRTRmRBdFZPcytT?=
 =?utf-8?B?ZUJPN0RCb3pRWHdVRTVzb1RtUWRKaHcydmN5K2kyRStVTjZLeDVxRnk3K0lo?=
 =?utf-8?B?M3UrUXQ5UkZ2K21VM2tEY3BNYmV3d3kwTTVlNUo4Z2RFbGtKWFFVeXRCei9m?=
 =?utf-8?B?VFRweEpEQmhJMDdUc1dnellvWU1tQ2F4VlRQQ3NhNk1laEUvMG0wUm5WdDJM?=
 =?utf-8?B?VGczSStEOHdienlCcjh1bUVkUHh1a2VrNC9sVnY5S3R5b2FFYW5JZlRYaEZD?=
 =?utf-8?B?bzVuR0pONHZTcCs2VktCa3A3NTlQa292OStLT0RqanYvSWt2dk8wanJ3bUM5?=
 =?utf-8?B?UGdJcjJRVWExUVlPWWNiRk5yQXBkU0NKQW5OVWtPSEt3UW5uZFpTT1FFMGVp?=
 =?utf-8?B?UGlYNVpEdy9SVXE1V3ArRzJMbXl2WW94NnFZWXpUWm4zSjVsNnVOZElQQytR?=
 =?utf-8?B?aWVlb0VHMjFra2Eyc29rc1hlcUs2TEVDY2tMbk1CQ2RNelpPQmF4YUxGdHhD?=
 =?utf-8?B?V1NUT3ZrUDhKL0tBc2pUWklZTEkwK21FLzNzV1V4OWtBVC92MldpL1I2bU9k?=
 =?utf-8?B?OHYrbHhtOExNMXV1cm16SEpNRWwxbURDQVZzRTgybUp0eG9IMXZKNFVZT0dY?=
 =?utf-8?B?RW84V3Rjdmw3anVPdkNrYXV4MDRmdjBSaVBsaHZtVDY0OUFzV09XTXgwRHZt?=
 =?utf-8?B?dEhWc3JpUHpUd0k5UERuLytKUkkzUjVuTVlLTEIzTW1waGxyd2VoRTgwam5i?=
 =?utf-8?B?aVMrTmN5RWhtS0p0TldMY0d6cCsxSW1NdzJ6QytINkRxV1BqcXE0S245Vzh1?=
 =?utf-8?B?SWJVZlRKeStPUnZzOWlCaXRTb3JQdjVLSTF6R0FyTHlRV2F2eUozSGljRW1T?=
 =?utf-8?B?TWc1cWhEaHpwSjlIbC9WQUc1bHIvNUk0YzNvQ25LQ3lqemFDSW9ZaDFoT3dz?=
 =?utf-8?B?dFNmTHpmeWlZMFdqT2IwUmN2NkxSVlorMFVua003SVV5Qm8wY3BodldBdzIx?=
 =?utf-8?B?M3JmNUlOanlYQ1d1eS9BeFlnWkVLK1R4OHcvdzZPa2FRc2RlYUw4Z3orVmpM?=
 =?utf-8?B?U3d1bkloc2l5RDhzRzV0Vy8weFRYb2VZVE5rYWxtcVJNblpsdDJmTisyTFNi?=
 =?utf-8?B?L0F3OXo2aW9RTlVyZlNERHA1eDlRczF4aXVQaWFHL0UxbkVnTjFYUFErN3l6?=
 =?utf-8?B?cXdEREN0aTNsMXhVOU1tRkdjeDB1Ukl1ODlpUUpFVlVJWXErOElqTmFVNGR4?=
 =?utf-8?Q?X3DJTlRVqiLRnm3I=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b33884-1e1a-48e9-10a1-08de74df847c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 02:34:08.4629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1eIim9UgMiyWhwjio4p9hnH36hQk+kBU74OKNTxVXZY4MHDhlaEgQtL08PhTp50gPAwQ5Vp1MiqeiuFVokkyMugo8QvEBq6eoFvkCpjilVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR11MB9531
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
	TAGGED_FROM(0.00)[bounces-71915-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:dkim];
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
	RCPT_COUNT_GT_50(0.00)[58];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D5A1F1A0216
X-Rspamd-Action: no action

Alexey Kardashevskiy wrote:
[..]
> I cannot easily see from these what the sizes are. And how many of each.

Same as any other offset+bitmask code, the size is encoded in the accessor.

Arnd caught that I misspoke when I said offset+bitfield.

> > #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_TABLE BIT(0)
> > #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_PBA BIT(1)
> > #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_NON_TEE BIT(2)
> > #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_UPDATABLE BIT(3)
> > #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID GENMASK(31, 16)
> > #define  PCI_TSM_DEVIF_REPORT_MMIO_SIZE (16)
> > #define PCI_TSM_DEVIF_REPORT_BASE_SIZE(nr_mmio) (16 + nr_mmio * PCI_TSM_DEVIF_REPORT_MMIO_SIZE)
> > 
> > Any strong feelings one way or the other? I have a mild preference for
> > this offset+bitfields approach.
> 
> 
> My variant is just like this (may be need to put it in the comment):
> 
> tdi_report_header
> tdi_report_mmio_range[]
> tdi_report_footer

Does the kernel have any use for the footer besides conveying it to
userspace?

> imho easier on eyes. I can live with either if the majority votes for it. Thanks.

Aneesh also already has 'structs+bitmask', I will switch to that.

