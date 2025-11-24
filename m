Return-Path: <kvm+bounces-64426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E4AD3C824ED
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 20:31:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E573348B92
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48CB224CEEA;
	Mon, 24 Nov 2025 19:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZNETBnlX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C3872612;
	Mon, 24 Nov 2025 19:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764012673; cv=fail; b=eUG671CrtFrinTV/iAgTJtgDt3RIHrWUgFCu9OfwmYM+MSq0dkT39rXjJerugIbH1TCgvpzKOV0rMqWwlFJ5knLsPfWF/pF1OuAQrPp0cQvcHea+jYsbFcneuSlw1AxOLYPNqfhSxVsSJNsHGsCZc+bzgJN+2INU5JfiPQrVg/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764012673; c=relaxed/simple;
	bh=GA791CEgcD3bEXoUtxgA9CA2PlYyK/U34oGArzzpPck=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hNl9vALquE5LhioqdggrgjRfS35yr6vWzEOfp/6daNqzPxwUbATjPYlaY+L4tjTgWBYvMCBNtKMzXA8CL0oEbgZ2hfnWvoa/VNY7y173kPZf0gJqeih9WJuFtvskYJd8cySAlTzCA3Ku/U3CfqziEPHgK+v7bRMFmWQVByeMWQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZNETBnlX; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764012669; x=1795548669;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GA791CEgcD3bEXoUtxgA9CA2PlYyK/U34oGArzzpPck=;
  b=ZNETBnlXfRz8Yyf6+fLTK0XZ4GtIIFvs5b0hk9JEgPst0gU23/UxiLeC
   gMWpfNtF0fsIdhezgwIYmelPjXW8Mm96bcsUg/6Y9YKi9036cgqQ9rjuc
   LafqGcsaig5SmAc4lH/EUUI+ziFD4iFLjhNiKgTIzPmxqyjuYas06j7nT
   OwqTF+oN7sERsGbowTN5GdYLsxMrDn7FX083AJZPJH3nRNvFqPNF8Si7f
   I3sfjoNQKtYoEMk/hw9hMhltABywVzxvs2e0RztHteM2bQOSi1I8drI6b
   mGTRKu6oHCGHWgLbbm2NJuSmeC2aILWLBFMlAPEm3+LbxvQkhG5+hxE7K
   g==;
X-CSE-ConnectionGUID: Yw8D34sRQhCkYG5umbtrww==
X-CSE-MsgGUID: kvYNDVuuRLO0vrHQkXWoSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="65965348"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="65965348"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 11:31:08 -0800
X-CSE-ConnectionGUID: XZ2Cv6hJS+mCSfpCGd/zIA==
X-CSE-MsgGUID: mDh82LFIR7CPTnYtyX3w0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="215762138"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 11:31:07 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 11:31:06 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 11:31:06 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.45)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 24 Nov 2025 11:31:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U5Cs3CNJ46uq1iSn+NZQwuaizB1GjCs8DcY0UZmVmDlRNLEDoRDuOcnW+rkEgcxvoTF8Rj5hPfzg8x8uuzKQVYrxdfdNlNzG2+PpeG7SX27SRU3ZL2uyqtTHSWj+ejfhu/LLkT2hbmjt3th5hvf/H6UCXkScujDZ9u03UY7M4f8SyanJQ0Cyu1I9QrJGJnvxr/Io/fZuprZx0PJLgULJyd/MrpzFRqU9N5plp2arVSbd2v0lvWk6gkfKYjKi9AAIlIz9MXs+LJzTdx9AyLBpEkc0Nxh1LBVtQtrpJ+Y2sbVJ8eI+zlwzJr8onDMgrFWyKV9X7HIzcwE5qtc/8JrjGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GA791CEgcD3bEXoUtxgA9CA2PlYyK/U34oGArzzpPck=;
 b=SYHC/daI60rdyJnBTiEvRToejyHmb3yIES5QaVIe/LWAdd4KA4f/WoVyoq4TUnRn5a4jpmKe+/pdRk2PsZJw+a8Bi5YKaktf0Cc5lZF0tMsJnYqd2HcrweFaM6OmWAv72Tjv6MbqozRgS6BsWXAc/xBS1ux6K4OHxVKL7Y4z7ysRKuTmjjHTiYYNz29Df7qbwwoCoX9uoHMAw73zza6BDriUnPHMcPy1n7ZtGo5ua3U+wChjlReaNE/lOVM2od1IYPbR0xkZ0mt3p8ZyWaS9DKRskjy5ekuobyRqit7iHMKVu1kym9ECPfJrztlRbGa54LBc2VSBYp6/SfW/GFtc4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB5194.namprd11.prod.outlook.com (2603:10b6:806:118::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 19:31:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 19:31:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Topic: [PATCH v4 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Index: AQHcWoEHfSzJD2pReUOZz4xpGvN+87UBi1+AgACxWwA=
Date: Mon, 24 Nov 2025 19:31:02 +0000
Message-ID: <76fc3731177a9be77d35cfadf31712932bd413a3.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-3-rick.p.edgecombe@intel.com>
	 <86e2d5fa-4d68-4200-98d1-77113bc3c1da@linux.intel.com>
In-Reply-To: <86e2d5fa-4d68-4200-98d1-77113bc3c1da@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB5194:EE_
x-ms-office365-filtering-correlation-id: 6e2483be-bc8b-4a78-e47a-08de2b900126
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?L2VqN1U2SEs4MUNDL0U0YkVGREVqY1VnbnIwTGdrdUNpdWxnZENYVVhMSDA3?=
 =?utf-8?B?QmVpUmh5Q3pFSDRZRks0bWlic1luMUlTK3NyMXRxczFlaFczTlZ0R3ROZE1n?=
 =?utf-8?B?clVpbTZMNkwvLzl6VEpZSjRjdGxMZkc4OTRDRmpGd0NvZkpVUHFkVElYMEYx?=
 =?utf-8?B?L1l3UzUwYmRtTEQzZnFWOHIyQU9DQ1BTSkk2bXFrdTBpM1FsZEZRMVpVSWtN?=
 =?utf-8?B?dThHc3ZtRGtiWmJnSStRaVVWOW83eGRaeTJNSEw5N2xHbENkbXIzazNtY1Vz?=
 =?utf-8?B?SWlCTWNsNGI2UFQwclg0OWV4dWxpY205QmZQcXhUZTZlcTRIU1FtK1lUT3dV?=
 =?utf-8?B?ZEdNbXNjaElxbFU1UEhkbjNRSVJqdTVlYWdiYVVGWjVBTklKMzY2KzFZYUp6?=
 =?utf-8?B?TkI5M3pnc0piV3lsNVNEYXh4aVBOUjhWSzBxUS9rS1EyWnhOL0pjQWpIVUQy?=
 =?utf-8?B?ZTRrK1VsdWlXdjVsanUycHJWNUdPQnk4K0VZbTlLeit5NXdhZGtvNkw0aE9a?=
 =?utf-8?B?ZXlabmlMMi9SK2w0NXpTMUtsVHBBc1FZYjI0ZVdxUHNjbEN5cUJuNitIVnpm?=
 =?utf-8?B?eG56bHhlZmdIUTJxZ3NMeDJyOG1LVFVMa2E5RGdEMU5mVHoydEozejJPK2Rm?=
 =?utf-8?B?dWtUZit4cnQ2cXhicE43R2lFMHptM2RkMVdtZ0gwMTc4WVUvV0hSL1kxVDlC?=
 =?utf-8?B?VDBaT0l5dE9hcDQxc2Z3R1ZiZG5nQW9IVjhvMWEvclhmUmpLaUd4VXJQekQ1?=
 =?utf-8?B?bjVubktHK3Q4dTMxdFpHU1dJTG9MbDRjeWdXckNwRnE3MFlHZkU2RlRpY0tr?=
 =?utf-8?B?OTIzWUNHTHFqNzZNSWIvQVNiQTdhNjZVNzNnMnAvUkdnTS9ndkxycXlzdHFU?=
 =?utf-8?B?c25QbndKNWUzYno2ajFBVmxINGVRdTVnbjBmQ3E5WE5Rekt6Q21BTDhRaGF4?=
 =?utf-8?B?RHo3WGRXMllKbWpmZWF5NnY1STV0V2lHYjRaRkdTVklVRkR0UVFsVGNJQ1pR?=
 =?utf-8?B?QytlOVhzZTJnaUk4TFdQc1llcmhjNXl4L0lKcGlFcVYvcUFuUGQyRzhueUdB?=
 =?utf-8?B?NVYxQkFlRUwwM2g4eWd6MjN2cEduQUJxcDVCVEovMWhab0FKa2VMWjZmdkRV?=
 =?utf-8?B?VkRwN3E0NnpDYzlvb1pKaTBBVlUrZmR4SlJ4YVZhT3BCdGkzM1lmQlNKWkZO?=
 =?utf-8?B?Uk1pczdjb01qUDRIeGxkOHFUVzZGZlZ6aXBKb2MycHZuckx6RHpoSVNEcmdT?=
 =?utf-8?B?elBiZ0RMU0hoQVVCQTJyczZ5UUhRRGZyNTVFaEo3bEdZZUgydEZVN0IxWGRk?=
 =?utf-8?B?RG02bCtrNmVTUmw5M0U1U0ZkMFNQWFVjaHpFRjVOdW5xV3BNNVNrZ04wWkx3?=
 =?utf-8?B?L1luNVo1eDcwK3orNk85Umovemg4cWhCZk90M0dHajlwdk0wUlFLOUFmazJN?=
 =?utf-8?B?Q253V0c2NkYxSDAzYmNRSjg0OGxYNCtUMG92UTVVclBPZE81MnY3Qkx1RXds?=
 =?utf-8?B?R0UrMmpSNVQrV2c2emh4RWYrWTBNSUI2c1FEVVByQUxsQWIvTGVNR0dHV21D?=
 =?utf-8?B?Uyt0WkZTNDZGZnZ4SXpZREJnZWtPcUs5RmdvMmNuNkVZNVA4aTFScWxkTHhh?=
 =?utf-8?B?VHhaaTl1Q2g3dER0dFZnbFRCdUtZM1EyeGR1RitkOVNYcVdjclVZZHJpRG9O?=
 =?utf-8?B?bnRoSmczc0hIRWt6anUrUnRnMHI3QWNiRjZ5dUJUUUdvWFJiTGNKcE92bUZB?=
 =?utf-8?B?NFlFOEtBU1Z3QWhRZDJPMklxM01UUnBnK3gxVmZNazFMSFUxTVJoUlpZQzNi?=
 =?utf-8?B?YjU1YitzSGNpVzlYRk9Uc3lqT0w1Tm5rK0YvM1NsdklWdTdLNjFiM28ydmp4?=
 =?utf-8?B?Z3RPcGhoaDdFelBvdmdmbU51YXNwcHJvNmp5ZUFNTDRjZ0x4bytYMUw1SXRS?=
 =?utf-8?B?a2phRjYrWkVQanZKdnhoQVNvR09WZExFSW0yYkVicHBJaVdNcWFsUFE5KzBQ?=
 =?utf-8?B?SS9GY3BiUFVjdVFQUnloc1FvUGZ1VzRQd0gvWmZXb25WSUdaRlAyUlV1TUds?=
 =?utf-8?Q?80kQcH?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUJPZUlRdHpLZ0tRUU9idzFBbGl3OStORUxyY1BWczNWS3NKcnVrV0NHZEZO?=
 =?utf-8?B?VG5hU3FjNjR6ZENnZ3RDOWRGS2Fad2ErSW9GR3FIYWVhb3NjdURmTlhKSmpB?=
 =?utf-8?B?YlRIc2JTSm1MOUVsaFhLSlREUkcyVGpOMUZmVWFSUkMwZEsyRWliNmJpc1p0?=
 =?utf-8?B?WldqemhkRXpuc1VTbUFOUUh4NHNZOFFaYmNpM1RQL3A1a0Y1SDMzNVJRZU8z?=
 =?utf-8?B?OFUvTTNZQU55cHNpUUdhYTI5Z0I1ZzMwVjM4RmNvVS9ST1hCV1J6eklldzNJ?=
 =?utf-8?B?WDdnNGdHbGEzbVpTMTZnSEZPbGYzZVYwUHJKQ3lOVnAwNHJjVHVPc2x5NFZI?=
 =?utf-8?B?YTNiSGNwYmNtQkZPeDJLemc4OGVYMzlKM0hHUEVMdWRQcjR2UzY5K0x3Uzdh?=
 =?utf-8?B?eUdUdHJmVEVZNnlqajNpK1ZSdGg5L0Vkamk1L0tZeDVOZ3NuQ2l0T3oxejRo?=
 =?utf-8?B?azd4NjQwM3d1S0RVblJ6cWcraVBjcU5EdXcrd1RWaE9Mc3p5WXlvNml6L3ZJ?=
 =?utf-8?B?VXJZV1FJS2VXSEk0c0lacXVnNmJjYXU3bHJEcDlrNzlPaloxdGNLMy9zY0g4?=
 =?utf-8?B?ZWtiUlM0d3drS25TLytaanU4UEZJVEtwTkZubVphaGtBWnEzVm13UjN5Ym1Z?=
 =?utf-8?B?Q3Uyd2JIdXh2NzEwOTd6WnUrTzkzTlBxRGJVTW41eTFzdDk1dTZlNXJoT3dI?=
 =?utf-8?B?U25TeE1xM1NmeVZhZDI1WlY2T2YyajJ5aFdJajlja2VuWlcwRWNqRWxIc01j?=
 =?utf-8?B?RW1Cc2MwVUxHQXBGZUhHL1V0ZjdnS3NGUDhqZDlvSW1DcTdnL1NKTlRucW5S?=
 =?utf-8?B?dXliRjdHQXl5RHh4ZVNQQjhvRkdJb2FaUFpPVVRHZmlrYjdHa1RpU284RXlO?=
 =?utf-8?B?MW42U0JaRkQyZmtITFlUR2tHaHBKSGNNTUV0ZFlIVjZ6U1owWmQzN1g4WVNG?=
 =?utf-8?B?UUlzZHlUNHg2OWsxSWtMYWpmZWFTV2E0NjdqR0VvN3hUdjJTRHhBY0x6YW9j?=
 =?utf-8?B?SEJTRmR2eERvdkY5RmlUZ05LUFNobFZJdUkwUWxVRXg3Z1dnbithWFJKVUJh?=
 =?utf-8?B?OVJEYjVuZGRPVEh2ZFVqYXB3b3Z1anF6S0VBcFhadUh3ak80V0t2K0VNTGE0?=
 =?utf-8?B?Z2FQWWhlbkRvcWsrOWhlSDdkaks4eWxHMWZnY0tPdEZ5Q2dhaVRJbEVkL1Ni?=
 =?utf-8?B?dlYvWkhSeVg5am1mRWxuVnM0OGUvSzZSQ2tDbXllSDk5Y0xCWi83cVRVM3RN?=
 =?utf-8?B?aE41SmlYa3BrMmZ2RVlVRmg5Vk1sYUJkMzg0MWJUTnRJQnhtb21oeG56bTBi?=
 =?utf-8?B?T2lrZDljUWdlU0o1a0VtMzhaOXRtbGcva1lJaG94NVROZkJERGk3NlA2cE4y?=
 =?utf-8?B?N1FqQ0NDM2VWL3pvL0E0Zy9jcE8yaENuKzkrNGlrdTUwY2RTQ1NMQU9MTWhQ?=
 =?utf-8?B?b1BnN1FtK0kzQnkzRmlHTWRnWW16VGo3YWRTQmFsTW9SV3pKZ0I4dXJmQ3RO?=
 =?utf-8?B?OGc1Z2xSbUEyeVh4eW5ya01kY0Z6YWo4b2pWNjFDanl6MXZuT2NCTHM4L1l1?=
 =?utf-8?B?NkdHWjRXNjBmWXA5NmdKcnpMWXBLaFRrMkZPQ1JPa01UeVNxUUkvNGxyM3hp?=
 =?utf-8?B?RGt0eWlFakhYanFJTmVXQU1KU1NaTi9lMFROeTBsVDFaNC91RnZGb2JYVGwy?=
 =?utf-8?B?OE00ampyc3M1VVhBT2FSUjZsYTl0UVAyeC94SkdEQW1pV2NVLzRpUGFEUVlT?=
 =?utf-8?B?d2V0WWR6eURuTFliNTF4VjJDeXBrYytqblYweE95S3VsTE9lRHNlV3hEMWUz?=
 =?utf-8?B?U2E1cFozL01CdUhrU20rTUdnVW9PSGJUWU10Qi9zTEZtQnFWcWJEaHYraytk?=
 =?utf-8?B?V0ZKSDdKc2VSSWdqZFNzOGdoTjdubTJ5bUZ3S1g0Ym1hNURxTzYrWkpNK2VL?=
 =?utf-8?B?bURkaFgxUzAreGpSTW1xc0pvQTVyUlJPNXltTUwwamMvdXFsUGozQ2NHUlRj?=
 =?utf-8?B?YjZDblBSc051YnlTay9uR2pSUVhIM3B2L0VpTUFqWlFselhVcnR4VnN5RS95?=
 =?utf-8?B?QTVFaGVreEtHVU5KUFN2cVhnK0I5OWhpQTFjd3BtV2pjTDJ3eVFIZVNxWGFo?=
 =?utf-8?B?M2M1dklFYWFKd1BsSG9MR3VjKzdDWUU4T0ZSWVFOWE1yOGtaV2hrQS9uUlE1?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEBAE476C3F643489F3BB2036A68FBEE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2483be-bc8b-4a78-e47a-08de2b900126
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 19:31:02.7509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cxqDz4ANkArTC79E1olyrqO1T50qWGj1H+s5NwFINnwMvRoXS1Kx/DrT02PZmc0xAm4vHG0MRQcbf1ixMtuvMiENEexjXzpTzq6R2RI5lqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5194
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTExLTI0IGF0IDE2OjU2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
K3N0YXRpYyBpbmxpbmUgdTY0IFREWF9TVEFUVVModTY0IGVycikNCj4gPiArew0KPiA+ICsJcmV0
dXJuIGVyciAmIFREWF9TVEFUVVNfTUFTSzsNCj4gPiArfQ0KPiANCj4gU2hvdWxkIGJlIHRhZ2dl
ZCB3aXRoIF9fYWx3YXlzX2lubGluZSBzaW5jZSBpdCdzIHVzZWQgaW4gbm9pbnN0ciByYW5nZS4N
Cg0KTmljZSwgY2F0Y2guIFllcyBib3RoIHNob3VsZCBiZSBkb25lLg0K

