Return-Path: <kvm+bounces-31708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE9309C67BE
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 04:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74A54286DB1
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 03:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B44D169AC5;
	Wed, 13 Nov 2024 03:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HBzQQ0v+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D05C165EE3
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 03:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731468003; cv=fail; b=UuGWkRmveZ9B/j+lLjcCxXEBXBUse3nTdQSgnj2zizv8u0uFMDdg7JasUwltBY9an31ssb3yhfXb5NtiDWByPa+/dzEc5a84FB7jY/39RVyE7bmQJQY+mMf+SedUIc/bVZGWGjO8/NGzm60ipfwo26UF920mnxxlhXjRapsfQ3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731468003; c=relaxed/simple;
	bh=ynXNDtWskzYAVB4oXmgjET4ndE2fPdEWbDqAGxSG84c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ASATDm9Vlf63wJ5KP0dkdcJ5giL+pPVKZTXJhI7dI1Jy2YRYHxi1F/joo8kZhOBeG88kpb+tIP/+aBAa7slZfLBUs6f+86qgMsQclO5b8tKIOBJHM2rvBaBTSoPJKRud+mXLS7/lMoJoO5kmiVDX5/eoNhJEyKYObGRy5xw8Jtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HBzQQ0v+; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731468002; x=1763004002;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ynXNDtWskzYAVB4oXmgjET4ndE2fPdEWbDqAGxSG84c=;
  b=HBzQQ0v+957uUn4PC/odxCkUaVvTtIBzyV2NLfDN0c8qM2DGHhwov9Rt
   eRzX8n8+7TA98Nb3As8vZAxM78v9Ju+6OXQrLtoxdHcqCOcjg4mOjkrQV
   dVu08dxllf4q/kR+vNlHg0nTtMhkkOGiVgzkWFRqpzXYBcylWVtoxc1HF
   Rdtzg0cOmlHMTe5YUBC2fEwu9V6obAv7whoLxTzMq7v60R23hgbh3zJFU
   6tsmKy5/k/oTTlC7CKTFYPVFANhRIHSP5luOVpS877raYgM4NziJnl9b5
   63OdLbJNDVCh9GDCI8DViziYsD+zNRBv38yhvvq18N+dwpGW6YJbud/eL
   g==;
X-CSE-ConnectionGUID: CQdM6qALSKiWdskcSlvwaw==
X-CSE-MsgGUID: XVnAlPUGQy2tYHHBr0doFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42749095"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="42749095"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 19:19:52 -0800
X-CSE-ConnectionGUID: d4VDQhddTMOL01Fxito7Vw==
X-CSE-MsgGUID: nVZa2C5oQL+kFvuaHUkIzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="92664725"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 19:19:51 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 19:19:51 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 19:19:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 19:19:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZip54WyyApyxYyjDYeMSZ1LTDMidEhFT7Lr9Q3hPYCVUBcL6RCQu2e4BexhFotYsEmpT1sxz5ILgqSBEsKX7CDRca7ZaPWwfGb8WdsfX2n4aTUp/E3/stUe+pq0FOVDQKcZa/PD0TWnaW5aUmYJsFaiMk5NLh4ym4A+ItD9l86OM0l4UIfCUIg1OZ6P/QtkdzL1b7BT2q+EEovmfbg37+sEnRUwfj8bsM4Tumt+NrBJbXXHRRDS9/oASF09jfYB2SkUGHRiawb2+6hUw+cUsu16NoL8YKbqg2kExMGfXSiAnVdobGEgLHp0eDOKSgx7/fUnEpnNAVymzrcHc8kdBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nV3rW4MBVaYv0eqRw+4nxRjHU/e04iMokK9Z1ew82fY=;
 b=zSWs2UFFi0u0qOJx11Yabtqk5Wpw1T2iW3Zm3oMMLNFXtTcIkM46AZZnbnd9mT47S1wQif51jWBIDgzVbyesSM9aKsLNYfliE2tE1obBC1kivy9clqcuEiSZSVneTIhUlGQ68Ors/PVEfCDKPT1DA8bsk6iDUw/hLmuTp+yF9mFp8FFP03NjmwI8h3yCDI6dBOQz0S4UU8ya8LqebzFY/H4Ufgs+PiQy1A+RYv3pxWcqkJtJG/VGh6Jyet36GyBMUQCDimSLiyOnDgVvPDXGYb9lJCKWUKMb0z10o7v7pQxopLcdmOfFkJNPWYf+P6JExInqTjfVqk8zxJjITdoE+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7105.namprd11.prod.outlook.com (2603:10b6:930:53::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Wed, 13 Nov
 2024 03:19:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 03:19:47 +0000
Message-ID: <745904ae-f9d9-4437-88a0-7d4cb5d19053@intel.com>
Date: Wed, 13 Nov 2024 11:24:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/12] iommufd support pasid attach/replace
To: Baolu Lu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <alex.williamson@redhat.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241113013748.GD35230@nvidia.com>
 <4d0173f0-2739-47aa-a9f0-429bf3173c0c@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <4d0173f0-2739-47aa-a9f0-429bf3173c0c@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7105:EE_
X-MS-Office365-Filtering-Correlation-Id: 46fbe852-d978-4c81-56c3-08dd039206c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUF6eHpweVdIM3BQeFNWcmVRTHloWjRxN2lKM3ZvQ0pPZ2xnUTVTVEk3bUtQ?=
 =?utf-8?B?amZTb3pFZFBQcktkZHFSYlhCa0RTbkxlMVFGaTYvTmNVemRQdUlGSVhBUmp0?=
 =?utf-8?B?cVhBK2JnYzlCRDJQMllUbXJUZi94QVZtc2FDK1phSk5PcGJTTXdNeVFLTTcx?=
 =?utf-8?B?aHAxbVB6cUN0ZzJ0V0lLajZLWHBMZ3BOUlZGTzM2VmcweFNVYjF2WTgzRlkx?=
 =?utf-8?B?dFluQVBVR0lZZG9Wb3RLOTJIV0FQN1hwVkF4STB1MHYyNHFHb0NIbmx6WlRD?=
 =?utf-8?B?NU1HY2ZTalM2WXVUSzRKbGFhaWtKQXlWMFlVT2E4VU8rdUdoTHJuQ3c0QjVD?=
 =?utf-8?B?ZitRbHV2OXpMVHd5ZnhJT3dwdlU0TmVVeWNnbm1jZ1pYa2YvenduZWpRTEo0?=
 =?utf-8?B?eCtnVFhhUWI2Mm5xYjVJTVhJOXJsVjhIVlM1aDFtUm45d09mdjJRTXdheEZO?=
 =?utf-8?B?aU1VcEIrbjZkK1ZpK01wSTNxMVhoQ3B4T3BuVHhVa0E4Qmx1RzgwallXZjFv?=
 =?utf-8?B?OXBTRjJXSW1tV3NuZVc2eFhhampJYWU3K3k5am1vZ0JkUUhMOXAydUlveCtJ?=
 =?utf-8?B?U0pYeDJmY2RFR0wyV0EweEtUbTNBOUxqMmZGNHJ2cUxKRGVreVo1Nzh0VHVK?=
 =?utf-8?B?NWRoaW5JNUZSNjM5dVh0TlRPNFZPZmljWUtkWHlpZDNBdU51aENXVDRMTlpJ?=
 =?utf-8?B?NENrTFpIZ0Q4WUoyTDBLVXZGZ3lWTzVTblMreGJXcXEzWERBYXgxSE1JaUx6?=
 =?utf-8?B?TTIvQTI4cEVaUlBPODV2UU5YVlZ6cmQvYUVUdndBOXZkVE41NW84YTg3NEkr?=
 =?utf-8?B?SnlqZVVhTDlGa3dhUEtRV2ttenlPdktrRk5HT1I0Rnc1ODF5UHVUOEpXQ2xM?=
 =?utf-8?B?bnpOejFhU0daOWFmUEYwSXlQalZzTTZud1BzV013ZnBiVDYwOU1Yd0VSMGs4?=
 =?utf-8?B?amx1RlNCNFRqUzlTRHdwWEI0eHA0dkxDVFNQSTcwNlFSU2RxeTcrZWVGcno5?=
 =?utf-8?B?Ry9HcDRwYU5kbExWL1dTYStPem1pS3I3dENNS1BPMWV3YnlCQVFMSWhTNCtD?=
 =?utf-8?B?WVdsWHNvWmdVcS9oQ1MvVWwyR0JFZ3JTVXNQbDNnQlQvMHRYZ2w4REJTcWtR?=
 =?utf-8?B?Q1VqR2JMd21tNzlHTi9TUERrTG5rMWw4ZlVURmh1c1Zybi9ScWdCdlRRZXdU?=
 =?utf-8?B?QThwU2RhbWdJNUZVZ0xrb2MrTjZ5VmszbmZLNTJTd08wNUMyWmcya2ZrTFdC?=
 =?utf-8?B?OVdVK1pGMDZxaWE2SjhSRmtCNlBiM2ZnSWozZmJSY2lRQmxFTnNhU05kWW1j?=
 =?utf-8?B?M1BTVWlKSFl5cC9HQWZvbFFQSmpRZ1JPOFpPNW4zVzFsUlJHdDdZNnZYQ0VQ?=
 =?utf-8?B?UlBxcDZ6MUdBTHV5RUxOMUtDeXB6M3E1c2k3eThLMWhCSUwwdXlBMURuYXdH?=
 =?utf-8?B?K3lwWVJqYzZ3dG1hY1ZyZFRUKzlJMVVhMVNyKzEwelFFOVBUVWY0MFFYVkdV?=
 =?utf-8?B?L0ZOMEFQVFZvOGhvR3JHVVJUWXNhYk5uZ2dyK2ZnT3VCdDJUOVZHdmE5T29Z?=
 =?utf-8?B?NERPNWxKcFJnekNkWTRzMjNXK1FFRU9oVThnV21zWmNyMWttRHhSTng3QXNs?=
 =?utf-8?B?b3JJbFhUdUtNcVBsVXlwcGFXK01Ha3hlRVlyU2lqeDhoelNyOVBtbGlIclYv?=
 =?utf-8?B?ekJ1UUdHVEpDTlZFZjdYTUVsVnRKTXNvWGxXTmRSckQ3OVZsQTdYSVNscFYr?=
 =?utf-8?Q?hOkZwBuP5r5HxZgdnwOHByzrp2BcN2IhMww6AHs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ek1mOGxweHpnbnczVnVnZG9RWHVkemVPOGpXdDl1Mi9JRW9abzdRUE9Xd1JE?=
 =?utf-8?B?R1VQbGNlSFAzc2toQSsvd0kza0I2QnplcHRWUDhRWnVlR1FBeUNiY0xBd214?=
 =?utf-8?B?czVUQlowYi9wb3J1SUJ4bGFETTdCeUtycmdLMEpEbEhGMHA5bUNLdTRaNXlh?=
 =?utf-8?B?TmdnYml2L1NwcnIwUHZhTVd6bC9rOW9MYnhoaXl5bUR4UWJFMEl6M3hTampH?=
 =?utf-8?B?V0xEdGV1dlo3UVBxWkdqdFdDOHluN3N6SFdjMjQxZEV4RVJUdXo1VHljYXJD?=
 =?utf-8?B?eXBWSDVnNzVPVmdaTEFZREExdlhhV1JZWmoyTEF4VW9MUjFJYWJFNHM0bmwz?=
 =?utf-8?B?NHhQUXhKbzdUQXBvWjh6dUFHNlhVMlhkL3phWi9KL1FQM1o5UERNYU41WmEv?=
 =?utf-8?B?MmRXMEt2WGtDK1JrQUhvdWVCa1hqMnUzQ0JaalBJUnR6NlNFQXh2Sks2eDE0?=
 =?utf-8?B?dHd6YlZJNzBrWWdvNWVlSnBET0tUQ1BDeHUyZGY1aGIzRjZ1UUp5T1JPSjJV?=
 =?utf-8?B?d3pTZ2VBM3ZiZzhNMVVvaWxUYWlNS0VrWVZBejNUVkR4UXprTkJxNmJyelRz?=
 =?utf-8?B?THROQ3l2ZTk0ZjFUazlmR0h0V2c5TkpNYUhuRGRKdzNPeEVpcEdtSS81ZENn?=
 =?utf-8?B?VVFRNkxyZG9QTGFUeC9mMDhkRnd5THZud2loNTM4VEluR3d4aEozWnBjU1hL?=
 =?utf-8?B?Z3J4ZFNzRUZtUTNQWXE4b2YrYVVKaGg4SHRLV1BhRHpmZnZNQThSVldNVVg3?=
 =?utf-8?B?azQwVDI3eVFSNkVMODdxM1R6d2NvMmVGUWExUDVYSUJLRm94czhITEpXWkYz?=
 =?utf-8?B?aS9Yc0N6dUtZZHZhY1NhMG51YnBsczlIR3Jzc1FEaCtBMWhjQmYwcWVYL0JZ?=
 =?utf-8?B?OWlscUdPUFJQYTRMdklCRW9NWk5KODZkcFdXS3IyM3RkUC9paWtxdDhZRkRx?=
 =?utf-8?B?VG83MTQ2a0VsQVVRWHN3RzRBZXJRd0dZM2FzVGlDRisxMGs2V0VhdmQydUVu?=
 =?utf-8?B?ZzRMdHpWMFJ3c1Y4N2w5V284cVZhSTJsY0h3eVhPeGl3VGxHaDVRd1dEWStj?=
 =?utf-8?B?bmE4b05IS1Z1WWFobjY2cUxscTl1WmFRNVhSZ1VWdEc2VEFXbGxrMjJudDd6?=
 =?utf-8?B?aUFUODBGWGZGSjdEdVM3MnQ2UnZOQnhKTHJFRjZ4MTFiSFZoVFVwNG9tOHFG?=
 =?utf-8?B?RnpFaEdpbFRpcUsvaDZEZTZkNzBkbmEvTGhkWWJpejJ4Y0RTNkJTaDNERnFa?=
 =?utf-8?B?TmpyWWdqTzg2cDcxRWpNK2xFTDlVZmZzWjhYS3NUNmM3UHRuTFR4eHNsV2hD?=
 =?utf-8?B?TTQ5OFdScStFSi9xdUJ4ckNJL3lPSzE4L3JxTEtxVklDR1UyOFlYVkRXV0sw?=
 =?utf-8?B?WTBDbmRWUHJtTEpiL0FUdFlFN0ZNMnJmYWJCNXdWSURmQkRaWkJIZ1c4ZlJz?=
 =?utf-8?B?cTRvZng2dFh3ajBCQktTTGpoK2dSSk54SElUaXhwMnVVbnpNZTRZNEZPRmJz?=
 =?utf-8?B?THdJdWtHQitLVnI3cW9oOHlFOGhIUHduQU9hQXFLWUhKSlpZa3pzZ2VRWER2?=
 =?utf-8?B?YkpxUGFIYk1qKy9YbzFsOVI5YUlpbmtRK2pZeDNVRE1PYzlDNzJ5V2N5ZHJD?=
 =?utf-8?B?ekFiV1ZVc0cySlhuVFFkM2RDODFLSENudVJsZkc2SXdwaytqQzFMQm0yeUZh?=
 =?utf-8?B?ajJhWGNDQ0JYbXc2aHNRZEdDNmcrOUZITUNtbEU0ME04c0U2U1M4aWE2cmJx?=
 =?utf-8?B?c2syakJpU0xadXdvd1ZvQ3JqL29FM0xiNHNTTVBUZkFycm9ValFOeHhrMEVa?=
 =?utf-8?B?ems2Z0F2ZUU4YmRNOFBmNko4N3FpK09LUk9FRkZYRGllRlFjKzFXaGs4WDZ0?=
 =?utf-8?B?L2pya1B2bmhMaXB3Nlh3dm5yOUk4ZTN5Ni9NQ01BWXZISk9wbHd0WjUrQStQ?=
 =?utf-8?B?QkUza3dnT1RCL0MwV1dGaWpvVDFPejBOUlFrdnRUalJCdWFlemdZTnNnRVY4?=
 =?utf-8?B?VzlQVC80cVBJRGJRallxaU52Z3ZSTTl2Qm5ueWxTWGpQei9wL3lFY2lRdWIy?=
 =?utf-8?B?bDc5bEZ6Ym5FQmZ3SURKTUY1dmMrcXhJU3grZTZZUUlWdHBNcGdHbDZnT0Nh?=
 =?utf-8?Q?y02xsmZ1XMWV4XTYuRJ+SNZ7h?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46fbe852-d978-4c81-56c3-08dd039206c0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 03:19:47.3060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y5WY4+FyTv7VfdEWApjfPOQRTNYUjdZVvfA3lzJkrOsKwBz9/GMHmbGgtqR8NAZ75ruU6Q8OuvcKhem+jyB+9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7105
X-OriginatorOrg: intel.com

On 2024/11/13 11:01, Baolu Lu wrote:
> On 11/13/24 09:37, Jason Gunthorpe wrote:
>> On Mon, Nov 04, 2024 at 05:25:01AM -0800, Yi Liu wrote:
>>
>>> This series is based on the preparation series [1] [2], it first adds a
>>> missing iommu API to replace the domain for a pasid.
>> Let's try hard to get some of these dependencies merged this cycle..
> 
> The pasid replace has been merged in the iommu tree.
> 
> Yi, did I overlook anything?

I think Jason means the two series I listed. The first one has already been
merged by you and Joerg [1]. While the second one [2] is not yet. It might
not be a hard dependency of the iommufd pasid series, but as it was
originated from the iommufd pasid series, so it is listed here as well. I
think it is already in good shape except one nit spotted by you. Perhaps I
can update a version and see what we can do for it.

[1] 
https://lore.kernel.org/linux-iommu/20241108021406.173972-1-baolu.lu@linux.intel.com/
[2] 
https://lore.kernel.org/linux-iommu/20241108021406.173972-1-baolu.lu@linux.intel.com/

-- 
Regards,
Yi Liu

