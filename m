Return-Path: <kvm+bounces-70382-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SIILFqslhWlV9AMAu9opvQ
	(envelope-from <kvm+bounces-70382-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 00:20:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD646F851D
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 00:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86A62301BCDA
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 23:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE2C33CE87;
	Thu,  5 Feb 2026 23:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VEo2yDa8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3497F2FF677;
	Thu,  5 Feb 2026 23:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770333554; cv=fail; b=mxs0QIvknebEd1/fdFWzfYctaMkPTbUq1XmVJZTGfkCxgDGuJSHsyWvDdwxkfBJXU92qNn0FR6Bv0GMINGpKWe98F92Siuk4sfoN2srIs2jOchdYNuBB02qegh9+2cQAV3czjpvTMSMXASXYiBRbOWnwZSHEYVDMjw8LxhBUfcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770333554; c=relaxed/simple;
	bh=MkXPYVSbwwCL8U4F4DhKWK/BELaYFx9XW3TfLne07fw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CnOJAWApkIYv2726UWYwaG4MwN1QlQ0N09r+KwshOgUET2RCtoCJP4GbSIIxYdPcs35Ctzw79qFk4y25CzVqpkFd4e8AtgDbyQbuxQ3gopzNieV6ZADE7nZgLgQtsRyBIqzUtkGKIGT9qCMjJSXarF5WTbzzA0X4wor+rndPOBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VEo2yDa8; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770333554; x=1801869554;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MkXPYVSbwwCL8U4F4DhKWK/BELaYFx9XW3TfLne07fw=;
  b=VEo2yDa8dIPgkrwDaP9vnqhanp89d0bCImBNfYW6GbondU2eOdfAILxE
   hF5iiuhHS3FIMWbUbqQ5j5PNYg0IUPQXBCiCWeY1fCrJYlwKxM8aea4qu
   1N1r0nKRlLPyDssZW+EtxoYoyxExy7zCaQRNgQmjPqfmC89Q0uGnwx/Yw
   z9hWoYhEs3pWwTOFXcupcSmoH/acR7og0+xbTIsVq/ykDlvGRtI4QIblu
   eo7n/0wuSSLSLNmHQX3TPji8NWzPwVc9FfSH+UFQMB27ascq+V0cQcSEi
   G4Pf5k5jIs9f8BmuuiFpZoEca5YNHKznPgNGFs3/1qQYypgPiHuVk1CIA
   w==;
X-CSE-ConnectionGUID: lZy5nS2BTV6Zcki8ZoklrQ==
X-CSE-MsgGUID: 5jKDb+1NQ1KjvbxQlMlhzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="81859616"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="81859616"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 15:19:13 -0800
X-CSE-ConnectionGUID: 4B3CXN0nSWOu0HJ21Cd1cA==
X-CSE-MsgGUID: SPTKkRioRp2ZtP7ueO3/Fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="214865519"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 15:19:12 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 15:19:11 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 5 Feb 2026 15:19:11 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.43) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 15:19:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQG+ot4HA3wruWJI9B2wcbKcJHZDyeO9YeWGUgUUeDWxJDJIfxkmaSyRn5wMwYWAmn8X+H4cseTdiQNd01DQ76VnXJdi3maCwaKqETu0sJ930RnOw+IVFbdUSV1jzWg/g0BgBjp565x8B8knL2NCgOTXIkAGHbg/XoEQA6nZ32LwuxM3o//ZfjiB72n66JdUYKSUmnrYNP6ZoTLu/iWwJl3P9dxw2/D+FSWUaVLpZQBgv29ETxkJ1JE9nFQe4qm9Ak+VvcK6V01cQFxpME/arTGLKB+A1B4xfdshNr0Rk4HTXyY/YFFIBLQyG+EdYj7+B62mez34JTrwvi8burI/9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQXzAbtpax9zPpXJ4r1zmO2CANMeD936wVXls9EZKA0=;
 b=rS3dTsr2J3ZGc9ZWQjHYGETceZACn12QrFdop1YC0HRbmxvA12xuVaCSR3H/fWsblPRZn0EIQWOP+aiOQn8nm8ime7h83mq0MlGOc75xEDoGDWROVZcAeEEdY6v0kNPOG4f9MHpZoLyHvrI1rEkreD/whZUudkwB8LTtyUXr3FlIbDvlWtqLHcOseoE0FDMzmBYvx7CkVg6nk16fAvXUDsbP2TeSmXVuSUUarp735zJxlIDvsHmoHmCWXjN2HA0eeDDO+pTAwiYI/XyqCImLi8ldUE+n94uU/WVGz3ErArle2TC67raNQrvQleBEqYDzUASaYoqwg99aVM4y9tj9RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14)
 by DM3PPFFCD58DF03.namprd11.prod.outlook.com (2603:10b6:f:fc00::f63) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 23:19:01 +0000
Received: from DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246]) by DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246%4]) with mapi id 15.20.9587.010; Thu, 5 Feb 2026
 23:19:01 +0000
Message-ID: <e5ac3272-795b-488c-b767-290fd50f2105@intel.com>
Date: Thu, 5 Feb 2026 15:18:58 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel
 expects so
Content-Language: en-US
To: Shashank Balaji <shashank.mahadasyam@sony.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, "K. Y. Srinivasan" <kys@microsoft.com>, "Haiyang
 Zhang" <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<decui@microsoft.com>, Long Li <longli@microsoft.com>, Ajay Kaher
	<ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>, Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	<linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <jailhouse-dev@googlegroups.com>,
	<kvm@vger.kernel.org>, <xen-devel@lists.xenproject.org>, Rahul Bukte
	<rahul.bukte@sony.com>, Daniel Palmer <daniel.palmer@sony.com>, Tim Bird
	<tim.bird@sony.com>, <stable@vger.kernel.org>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-1-71c8f488a88b@sony.com>
 <0149c37d-7065-4c72-ab56-4cea1a6c15d0@intel.com>
 <aYMOqXTYMJ_IlEFA@JPC00244420>
 <722b53a7-7560-4a1b-ab26-73eeed3dffa5@intel.com>
 <aYQzhRN83rJx6DSb@JPC00244420>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <aYQzhRN83rJx6DSb@JPC00244420>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::30) To DS0PR11MB7997.namprd11.prod.outlook.com
 (2603:10b6:8:125::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7997:EE_|DM3PPFFCD58DF03:EE_
X-MS-Office365-Filtering-Correlation-Id: e7f12305-7a9c-4a40-c694-08de650cf272
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eW1CdzBVcXJJdzJuZXVEOEUxRlMyYVNPNXdHWlAyN3BTOXZsZFdnMTNmeHB6?=
 =?utf-8?B?dlJDNmE5TmQrR3VXRkYzalMzU0d6eTBtQWxScFptVXU1NVZGeWVNMUJseXFy?=
 =?utf-8?B?UThobnJycFhaNFhGSFJHUHZHY25UTDltd3ZNSGRnYVRpZDNCcUR3aHdPTVBQ?=
 =?utf-8?B?YzliRmdGWXNGV0Q4Z211bWxSL1FDUWloVGVRNXM0cFQzTTJSUUFGYyt6c1p5?=
 =?utf-8?B?RGdFSnNpdVpBbGhaK1RYbWRjUXE3Vlk3Yk94VjdOc2h2NkxHRzlvckFZc1ha?=
 =?utf-8?B?cW9jajk0Z1ZkK0Vud2pDYmEwOXNQT1VGT3FMdk9TbzRPc0JRTjJwT1Q0aEFF?=
 =?utf-8?B?WnFVM2hsOXJZMUZEck9vRVJsUHNHY1VpQWpraVYxeEVPS3RzNXFoV3FsYVdV?=
 =?utf-8?B?K0NkaUl2R0ZwTy92VFhVQlo0UGF1RVZ0WVY5aHhDU3dvTytVM2tXT2NDWHNt?=
 =?utf-8?B?VnBUWmJrN1ZkZ2lFQ2NwbVd5WlQwU0sway9GZ2F4MnRiWlF1eFRqa0pseGky?=
 =?utf-8?B?VzBwOHpPMXc0Q0tkOWdiRko3VG5keVNyRG1HWFE4VXZrUGlFN29rYXA3SDhG?=
 =?utf-8?B?M0J5TjNucE5KQ1Z0anZIWHkwY29rLyttcVl2Ny9jMkZpN1ZHZ0lsTy9nUVhV?=
 =?utf-8?B?OXkyOXNKRzFhQjJqSHpVWmNPbktLWmx6OFN6ZjIwUzNuZnZyUjdpUG5UbDNV?=
 =?utf-8?B?T0pZUXFXbVVvemVNWEZ4UkFjVmp1V3dPc3FudTFNcWVNbXVMYm91THozd1JK?=
 =?utf-8?B?MDRJNi9yRFBkenEvUStKaEVHMCt5anNkNkhpU1Zwckd3YTdUK2lRcElocWV2?=
 =?utf-8?B?NHI1MkhuNC9DWVc1L3h5VWRsZC9KaUViWXJtTU5XOGh4akIzekhya0p5Uk9E?=
 =?utf-8?B?SzNEVWlBM3FnRDFrdDI0ZWpMMWN6SFBmSUZ0bldxZExhVUNJZFpFeTdNbnZF?=
 =?utf-8?B?RFZJUE1zQWJxdmxmNVYxRkV2S3pVOHFWMFUvd2tNVHpWS3hCWDJZYVBHclZr?=
 =?utf-8?B?UEU4OUtQaEpLWUFiODdzK1l0akhtS0dyeEptL0NlWlk5cFRHdHJvQnNqVHlZ?=
 =?utf-8?B?ME02eWxTT1AvY1I3cGFndGdwVjFBMHc0Ty9BRFNoM25taW1uWWRwSTI3b3Bq?=
 =?utf-8?B?cEVnczRzYmJ6c0YwaXozRlFIUjBuR01GbmRCS21xUHpSdkErdENZeHNEQkFQ?=
 =?utf-8?B?TnRydWQ2S1Y4VDBaYzVKUlBIcElDbjh3SWhidHBrZkR2RzdITldlbWVEdGph?=
 =?utf-8?B?K2E3aUx3WGpjVDB1TjBZdWRPMmhrU25JSDR4NFpseWc4QnUzVEMxY3M4U2Z2?=
 =?utf-8?B?ZzlacExnaGNHUGVRbEdValp0K1dUNzJsWGtXcGxpK1pzd3ZmN0Y1ZDk3QWNB?=
 =?utf-8?B?VlI3ZHc0QVdlSHByUXBpR05PTkRRNmIvZUdDSHAvYVBCSStJQ3J4ZGxrQTZT?=
 =?utf-8?B?dHVLb1NjQ1lkSWVSa3VDeHlsVnc0bEk3UVltZlJJV2dPRll4Q01uSjJrdkpS?=
 =?utf-8?B?RVB6SXIydU1vdEQ5NEU4RCtWNENLTEJja3VvZk5GK01pdjEvVzdUMm9hZnJS?=
 =?utf-8?B?dWw1dWVlOVV4MkhEWTdoZXJmeUJSNGxDRy8rcDJabzdob3JLWWFjVEl6dzB6?=
 =?utf-8?B?NWhMbCtrbUFVWFVTRVNQeEd6dktwUUFsN1FaK0JtcC9Kd2x5NnJzN3V1ZnE5?=
 =?utf-8?B?aUI2M1lmeWNiTUNqVGNaa25OTWxNT2xBMzF6a0p2alJKNmFHYjA3VWtLaFFm?=
 =?utf-8?B?cUdmZDJrQVZzWEtJNUNLTjRrZlk2b3ZrRmZ5WmxXSHgvOS8wTWRBcnlpSUlo?=
 =?utf-8?B?K2kwcGxBQktXaG5QZWNPQ08rdjZaVHZWNEVHNkVNRW9uVWpVcmU1ZE5SZkZP?=
 =?utf-8?B?ZEFOcTBuMktOcnFKTXRMN3JxYW11MlduRTBWZXJWcW90VlhvRzhoVVIrRStL?=
 =?utf-8?B?WTlLeFdmSklCSWh4ZUlEOFJWY0N3WCtoUGpTeDNZcVpWREs5WXZvZ2Q5SWF4?=
 =?utf-8?B?K21iWkt6RHdMdThXTGJhSFhMSTVEcFRZSXVWcXVOeGVOR2tIS1REZ2pmWkZI?=
 =?utf-8?B?bE1zdHRPeWsxbENLbGhOSUdMakhJQlBpWEczMFNzUHYvNGdOM0REandhRWhF?=
 =?utf-8?Q?w88pHEZmkZqbO9e5hh+xzrzlz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7997.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1VRZ1hMdmdiYkRSLzFMenIxTEdpdGNLSnZScEZTNHRLNGZVSm5tcFBqNkU3?=
 =?utf-8?B?N08zemZWaW4zWVJKQVNZUEVEVEplTGl6cktQeU1ISUhPS2dZQzRpUWViTkha?=
 =?utf-8?B?VHM1M3lkUVBzaDhMbWdjR01CUng2WlRNSXlLU3lxc0NUWlBvMlpTTHFIS283?=
 =?utf-8?B?aWVMMVRQSzVKY3BwbWpsUzhTMXdqd3FiTjgyNFArdm0yajRKYm5UakF2d2NF?=
 =?utf-8?B?b2FOOTNZenp4bjZYaTJ4cUIzRU11Y1QwRmRYREVjQlBXeE9YcjZGQU9UOWVY?=
 =?utf-8?B?N1hMUmZ2a2dpVjRmV2ZqcG9yRnZUSlpsVHErb3lMZkpvT1NscW9Md3NwU1Az?=
 =?utf-8?B?TkNoWmFOU3Baalp4S1N1b3BWdGU4MjJSVEpCRnRPaFZMZ3ZPRGtFUzJsS0g1?=
 =?utf-8?B?UXRFK0hwVmdFK1Mxb29FU1p4K3FWRWw2dmhqNVVGSmo2NnlRMm93T3NSRVNL?=
 =?utf-8?B?MEFwOTI3eFJqaU0wcGdnUyszQ3VtZDNCZUpLSHkrZWZudmF3S3ZxbFUvZmdl?=
 =?utf-8?B?aUtoNU5xUC81bEZYNHZMeHdaY2Iwdi9uZ0VTcUpNVUpTU0ExU3Q4OGZtcVJt?=
 =?utf-8?B?STFkZzRBWlZza0gvU2RneWl3YVl1TjdIcVVHTGhsSHUwQ25tVFo2emd6TWQy?=
 =?utf-8?B?OFNDbENyZHRUTUpqcW9icm5KQmVFY0VXT01jOVdYSEdhandXVURPcGpBd3Vv?=
 =?utf-8?B?L25MUHVDY3FORFFkeG1FQ1N0V2ZGVzFKSUdiYklKTG0zMXNXVWZ4MU5xZ2RI?=
 =?utf-8?B?ZnIvR0M3NGVnVm5oN1QxQ1kxYjEwejIxYi9XMU5nZGxPSElqTGh2SU8wKzVO?=
 =?utf-8?B?aHcrcU9JZlhIa3ZINmdvUGNtTko3N2c3RWFReWJNYml5cXlRbkozRjg1ZzF0?=
 =?utf-8?B?MHNpdWFkSUtPdXUySkdITkJKK2RzWFRxSUtPUHBKTk0xcDBxVnBjUnFQL3Ew?=
 =?utf-8?B?UldkblhqTUhxa29Ed2dGRERJQjFOalZGR3dJaUk0Z2RzOVJGNkV0SDhmcGxY?=
 =?utf-8?B?VGR3NjB6RllobDlEUFgzdWdyRloxQWNOMllEUitQd0xuc1dqWi8xMkllNUp2?=
 =?utf-8?B?bWI5ZnM0V21yMkJIRDBUcUxiVnlqUzBkWkxoRVF6RVB2eWdDVXZ4Y2FHNkZt?=
 =?utf-8?B?V1o1VHBwT25LcXphakhNMDQ2WGgvM2FRV3hna0ZXSmtlcmZuNy9BbW42ckZB?=
 =?utf-8?B?NEQxL1FWem80NE95aWlUNWtjZGhlSlF5OHpOT2tUMXVIK1hiZU53QkUrRVh4?=
 =?utf-8?B?bnYzVGpKQWN5aGVpY1dSbVljYTlOV3A0eGczeXI4aEZSNUdxVnRXZUVpOXVq?=
 =?utf-8?B?ZFVjWThuSEFRbmRDTFRmK0EvQnA3QXBXcXhhQXJ5aHJma1dZdjdXUDk3M0Zw?=
 =?utf-8?B?UnBRcEwvc3VsRktvcDZENkNFYVhxdDFodWUxOHdOV2plNlNXWWp1cUsrYTlx?=
 =?utf-8?B?WUd0TXZhM3I3Z1NoZFVSaUZEelpmTnYrL0VONjdzc3Vna3R2NnFqZ3hMenE0?=
 =?utf-8?B?aWFlbE1LWUp2aUlmbnZ4UzB5ZnlidS90anhEQjhVK3B6SGdVSWJQUkNKVnd5?=
 =?utf-8?B?Y1JhTGNaZVVqOEdnYW5Ha3NPZkFaanpOVkkwOFdsQlhxVVRGVWVxSlVyOGIv?=
 =?utf-8?B?NndvLzhCNjJCZHM1UUNiWDFvaXJYRDdFcFpVR1k3TkRNRWZsdkdvVytIQ3hv?=
 =?utf-8?B?RVdpd1dxVEx3SVk2T2llRDB2OUJ5UTV1Y25JckorQXhEcWJ5dWZDd1lPTEx2?=
 =?utf-8?B?YURCUzV5Ukd5K2ZKRThTY3JkbEJwV1VCdHJjeHdiTDN0YWNScnBRWkJNZXlH?=
 =?utf-8?B?dFZ1L0p1RGlqZXRMcllpdnpubkNvOFpJVUh5eVU4UEJERlNVRHdOeEFraTRX?=
 =?utf-8?B?dmtSYzZaNVVXazlmTmFoME81dkZFY0l3M0dPU1hpTS9Yb3FzeVZ6NEZ2NkVq?=
 =?utf-8?B?K01jUHJUUjc0dFNycllvTURwVFFqc0VvcUxJSjJJRUphNFRteEE2aVl4bDlH?=
 =?utf-8?B?UWVzc1BhUzhNc2xjQ3JLb1B3ci9nd1paTDdwRWxVT3NVbXdncGpaQTVTcWpP?=
 =?utf-8?B?UloyVmx6V1JzL09IRVREQTJ4QXhMdmdjaFNMQ1FoSC9mRTFYOTdaZ3FKek03?=
 =?utf-8?B?OW53cnd2VHY4dHlyNWYrSElOazI5VGJHTDVHWnBtamtyR0NRUVQyZk4zTVQ5?=
 =?utf-8?B?Nmc0QkJ3SGN6MXd1QnRySkUvSkhDOEs4eW1tVkxBR0FhbUIwZGZTM3hqWWt0?=
 =?utf-8?B?ZnhIcUNHN2dNcENiMXdPemNiSTl1ZWNDd2dZbkJKZUZsZjdQVkRBTEFSZElu?=
 =?utf-8?B?UGdOaHcvOVVhdHpsQ21zamNwUEs3VUxXVXk1TDNFOVZNSWU0R3lFUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f12305-7a9c-4a40-c694-08de650cf272
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7997.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 23:19:01.6520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dTFCq32cpV+ZjSdGIL/mbp6eMvFEZEVUuO2LFRexjDbt1z7YxIY7ti2eKKNAnK/cdeGLAN2BHKS74lJ7xZivlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFFCD58DF03
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[32];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sohil.mehta@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70382-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: DD646F851D
X-Rspamd-Action: no action

On 2/4/2026 10:07 PM, Shashank Balaji wrote:
> On Wed, Feb 04, 2026 at 10:53:28AM -0800, Sohil Mehta wrote:

>> It's a bit odd then that the firmware chooses to enable x2apic without
>> the OS requesting it.
> 
> Well, the firmware has a setting saying "Enable x2apic", which was
> enabled. So it did what the setting says
> 

The expectation would be that firmware would restore to the same state
before lapic_suspend().

>  
>>> Either way, a pr_warn maybe helpful. How about "x2apic re-enabled by the
>>> firmware during resume. Disabling\n"?
>>
>> I mainly want to make sure the firmware is really at fault before we add
>> such a print. But it seems likely now that the firmware messed up.

Maybe a warning would be useful to encourage firmware to fix this going
forward. I don't have a strong preference on the wording, but how about?

pr_warn_once("x2apic unexpectedly re-enabled by the firmware during
resume.\n");

A few nits:

For the code comments, you can use more of the line width. Generally, 72
(perhaps even 80) chars is okay for comments dependent on the code in
the vicinity.

The tip tree has slightly unique preferences, such as capitalizing the
first word of the patch title.

Please refer:
https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#patch-submission-notes



