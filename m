Return-Path: <kvm+bounces-19147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1519018E8
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 02:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B0661F212D0
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 00:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC00F17F7;
	Mon, 10 Jun 2024 00:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="isW1xH4L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF80EC5;
	Mon, 10 Jun 2024 00:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717979208; cv=fail; b=p9KEKRNbHcAS5T1Y3O3Nmk0HwSOueDdthubBln544xQtra1CFnLOIZtcSkdTzzOG/VgsC2Z4dGdRNuD+7uvlPRi9Mkmnm808XfFONjPYOaMX2E2OATGAYEUKpLCf0IHGWe44hQLXyexe6Iyo4NXfmuwOVA5Qbo+CS54g9tRpoKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717979208; c=relaxed/simple;
	bh=CdY4WL6Z0cCro0zci8nDGHCDSexPT5PWQlmC/0TsizM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YqD8Y84ZGHuRrC4F9IP7udH6fEjccBPwpay5fOVNnPexVvmgSiSDV0BFz0qHtUt07xfo/0qwgEdTQHJtyMdqt4uvU3pk0GQkZ2T1UcCTw5RRjJhpp/nQRwPYOMwsGucC2cruKpVnpfpyvAO54vPODi39NnzV1GiVj2Ooaq6CXQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=isW1xH4L; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717979207; x=1749515207;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CdY4WL6Z0cCro0zci8nDGHCDSexPT5PWQlmC/0TsizM=;
  b=isW1xH4LnteD8EnLouysVDH5a5mvBL64FmH1y9/VAIXo1KIP5gL8NiCB
   tJzEI3SvH2C8bGaRthri/NpLvoyN+VirtzEx5Z980sHpTmUwzPKp+rFEb
   3iFqIDcrOmwjr4yet/SYXLsc4zSxqZnAFWiovQqyJfi/BhvqGphlGl82B
   iCWT8VX4AOgpws/zPrr4iVwrVYyKCjk1V9rmR8GUIMC7X3a0ZkKInxWAV
   jkGpCWijkKyZ4Kj8vR7iJiDuohaSRfsr+Dg/dYvIhkVeSUm3ttZErjzXE
   km1DLuzcWYT7aldIZoNYr/ojJPt6DT5uF9vUob9GDXIjIk/nyrgZPD+Lh
   g==;
X-CSE-ConnectionGUID: n1JODZdkSSS7QjWIubPDnA==
X-CSE-MsgGUID: 0ji4HP8pRD+p8JIRl4EFpw==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="14806844"
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="14806844"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 17:26:45 -0700
X-CSE-ConnectionGUID: J8x5Ux6+S9G6yTxOqKizww==
X-CSE-MsgGUID: 7OpCWRL0Ts6qeH2twsorPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="43317604"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jun 2024 17:26:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 17:26:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 9 Jun 2024 17:26:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 9 Jun 2024 17:26:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQ9B1jiVW+zdwvHw8nIxM3mnso5FH9vvW87xtIC1XQ9v8k3Z1QHePe7c9ejbHOVGSadYefDp6FHCvSIHVFJ1f3p/q2pqgY03AB7JVP77AsgZgRWPEgL3WHlfrGKqCvMf6UW4Em6mB591C8qKBgfGGodNXA7Jf90zepd0W0ka/gpqd+y4yF4HF/TAjqLimgU354Ze4UMYj5ISOA969oGp+1MkF0SWi464ir87GiWmwRWjAZegoRCLmSYPTBbssgoLdIlkrTpFaMsVn8COVoT5TlxI2LFTKuFw32SHBblmr6Tk+yGb8cZ/WWBG/3SCpKDKF4XxT3hj0x3xKkg6ITzpmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdY4WL6Z0cCro0zci8nDGHCDSexPT5PWQlmC/0TsizM=;
 b=gQDxI2gJQtvzpVKmr4PZUXNzLPPNqOybS7B8AXxVIrjBKpi5hsHrK1mpvNFwJDb88yMbMMrZo6gaqUx6lL+ZB6h+Rzm4mOehzbz8zLEGj+JLti8yHX4ch3FIqS9AKJUYX0Kzp/WHrAu5+uFvcy27JUkGMlu1/8t0/1xJ4buAMSc+CwP6O/homr6pF6cFaLiqV3uryEkOymjDPPuUleApnquthF2Is4TGHtyOXV+3triOrw3h1NaeCBR/awHxt3OpWT54yCuFeIX/jx3VuUtS0ZHlSJNR9XlZE1Am9DrQjdjiub2vlPDrMPYzglA76BD4Jk6dTrBSXEvDGJCskiOnBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5889.namprd11.prod.outlook.com (2603:10b6:303:168::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 00:26:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 00:26:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: Re: [PATCH v3 1/8] KVM: Use dedicated mutex to protect
 kvm_usage_count to avoid deadlock
Thread-Topic: [PATCH v3 1/8] KVM: Use dedicated mutex to protect
 kvm_usage_count to avoid deadlock
Thread-Index: AQHauTfMl79t+96hf0iN2iA7/9CAi7HAJ0IA
Date: Mon, 10 Jun 2024 00:26:37 +0000
Message-ID: <7ad00c584840b1ed8a79ae664c97ed1fca07d848.camel@intel.com>
References: <20240608000639.3295768-1-seanjc@google.com>
	 <20240608000639.3295768-2-seanjc@google.com>
In-Reply-To: <20240608000639.3295768-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5889:EE_
x-ms-office365-filtering-correlation-id: ec3aa2bc-7c07-4e9d-395f-08dc88e3fd70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?U3JDYWxKWFhDaTA5UTYzSXNvTlgwaEQ5eWl6cDVBN08ySUwza0tFYzVIeXAv?=
 =?utf-8?B?VkgzYm1VY1pUVngvTlkxMkZCNjVVdThEVkgweGJ6bjV6SWgyajF1RllpbTEr?=
 =?utf-8?B?dVA2MmVidjNNSXFSUzIrOVlDSlJuYk40c0o1STFJRkpxNXZkK0c4QytvUnk4?=
 =?utf-8?B?REIxT29KNzVXTmxlUDFLYzk5U3FSRStOaFJ3UDQzYjRoR1V2VFl6dE82cHNB?=
 =?utf-8?B?Uml6Q3UwNFNXV2NxL3N4QjdRaUVOeEh6NkE1ZmNxYVJ0aDg3dTRWTjhPK1pY?=
 =?utf-8?B?dUtESVkyMHVObjdmbUNSeXVHMnhqdUhFSERvdmQyay9BTk5NRXQvb3ViOWhP?=
 =?utf-8?B?ZlJkdVdsVFdvVGFxMEVKSFI4Z1NrdCtjMitTMDVhZFF6WVE0RjB2NVpxSmZy?=
 =?utf-8?B?bDB1ZWlzUnoxMTNsa3NETE1LWjVFZThyOVQrUzZ3ajg4V1NQb1lHRFVoVWM4?=
 =?utf-8?B?SzhpcWQrWndRcXFMMDkwVS9LcVhGdnhiSUZNcStYUytyNGh4eU0rUkYyajZm?=
 =?utf-8?B?bUdhb3BFTFFHbm5FYktzNGxGVC85NnpMU0pVRGxERHZVdGVqTS9sTmxqaXNw?=
 =?utf-8?B?VHh3aU1HWlkvRlN5VlRmaVJaOFRVWit6TFUwRTFrdEIwMVh6dlhZUGZ2Ri8w?=
 =?utf-8?B?UXh0TWNGbXRCOGZDbVpVYmRxSXBTSTZqNU8yVS9oYnZXMFNHZXRhNkFKM2tl?=
 =?utf-8?B?VkZKTDVJSjNVaGxXaG5qVjBZeVYrMFZWYzNYQUw3UFU5NHpiM2dWWEpYSG9x?=
 =?utf-8?B?SG1aamo5L0E5MC9aMkF6N3AyUTRmMm9SYmxyZWVQMFJ5N2pPOWNBbEUyQzI5?=
 =?utf-8?B?MlFRcUpGNytyd0dTOEtQN0tVNmhUUWJkdjdNUmVMWU9jRDN2eDBXeHFtL2JH?=
 =?utf-8?B?VVpUN3ltSHBONGt6d0tuMThWbDVGUHVNTjIvL0dnOHJpcjBEOGdFa21SLzZa?=
 =?utf-8?B?UFJaam91cng1REFBVGtiUE9WNmlzbUhRVFlsVGtxV1VTL3U0ZUJvK05LZHha?=
 =?utf-8?B?c3lMSGFaQURjYXJLSWMzcXRNM1RXTGVXQmZPMHp2Mi9OcHg2NWtzMDUxWmdz?=
 =?utf-8?B?TGVKSjlKMW5hSWxYdjB1N1c2ZkNLNHF3L1F4ZGlpUFVqNDhqRTNMejY2NDcz?=
 =?utf-8?B?ZFpZV29FNFBvOHQxcXZWNWJnTngyQnRZSlFZQjh0VytuWDdPVlAyK093dGxn?=
 =?utf-8?B?aERDTXZhYVZ5RTBNTlVNV2xuS0pPUjFrSkFMWEtkMTJBU2NSck5teUp6Q01N?=
 =?utf-8?B?cWR4VUVoTFp3YWVNZm5VazllbDhrVDk3aVFiQUtONkZCcmhWNHBEZTdIbUdG?=
 =?utf-8?B?M0Z0M1JHbDhDM2JDRFc5eU82S29GRGdtYy8zK0Q4TkpOYkx1KzI2WU9aK20w?=
 =?utf-8?B?TDVtT3Jja3h4cDUvOWV6TXY1NXBCbmxCZWlZTFVQMUV3Zkx4OG9CNjdaSXFy?=
 =?utf-8?B?WDdCZksycERJVE40Ukc5ZENVUmV0V1V6ZVJ6Vkc4QlhhRDR6VGF4K1hJWHpC?=
 =?utf-8?B?c0RkY1JiTlB4VnM1UVhheWppZXNMRUxOMHJoczZneGt0a09Fdit3U0NiUmRV?=
 =?utf-8?B?TDZ4RENTdkNPUmRPZ3VEZDhBY1R1bW1xUFJGT3RFTTVldnpnZFlJcldKT0hu?=
 =?utf-8?B?d2lTLzVkYnBQbTd6blNVV2VQa3FlWnc2VjV5bS9NQ1E0OVJUUGFmL05HczlK?=
 =?utf-8?B?OUVGNThNTk5GS0t6czIvbkl6UWVDZ3dQUDRCRWNmcHQrbER4K0RITlVCWlVV?=
 =?utf-8?B?UEgvL1IrdTBoWmdIVnhMQXFTZzNXa2p2VWtNbWJkcGtkS2FBaGphQzV0a21h?=
 =?utf-8?Q?yQcdq/QgqQkOKnRFuNsT05E++NctoVqGpmc7g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aEVNaUpBSnZ2MHBUYVUrS1JlNzRML3J2MUdiM1ZYYXdSQkw4dFRMTHZKdUxo?=
 =?utf-8?B?dzdBRUpaek9zZjEyeWd5TlFsbUZ1SDRJYm9vM0RDRWxFcDZseER6TFVuL2F5?=
 =?utf-8?B?dk0rNjZlZ2hRakNMcXJjWGtUankwSWt0Z0ZTU3hqZjJHV2ZoZnFhclVuemhp?=
 =?utf-8?B?azM0MXNiYjh0UURNcndOemFka252dEhndkZtdW5EZUtyMm9GY0JVUno3WkhR?=
 =?utf-8?B?WkFWVnIxdk4zczBUa2NRU2J3QzBBS1lxMzdJZHZpaWl0TUg0akxsYWRXcFFW?=
 =?utf-8?B?bkhIcDhwWmdzd3d3RjUwQTBqejRrbmlnZ2loY0paV05rL0xKdnJRUEd0eVhu?=
 =?utf-8?B?YTdoMjJ1Y1d1MjRqcGFmM0NQR3FOcmo4Ukp4WDZCMXovaTM2QlozNWpNb1Av?=
 =?utf-8?B?THJhd29vUktrbVg3OWJwak8xdWhYNDVZSzNOLzdFQkFlbzQ5ZDRISUtGa3Ur?=
 =?utf-8?B?dFRUMUVaVTNQOGx3elBZRU1FTFRqRzVqSFg2SXNZb08yZTd0YWlyMkU1aDFT?=
 =?utf-8?B?T0ZTa1VmV3kxSzgxYXk1Uzg0bXFtK0NBQ3FWeWdWQ2NNeVZ0RVhXelcvN21E?=
 =?utf-8?B?OUhlWm9zL0tUWit2S1lxbUY1WldJc2dHZXdzRTU4cVZwRHVxVVBFWjhJL0I1?=
 =?utf-8?B?RTNuQ09Db1JNcEJNaUxzOTk3aXlvdTdPUnU3VUNFU1NiRktTYVVPNmVtS005?=
 =?utf-8?B?bDhpbGQxMmVjTklyNEo2SW9rTURtS0duUFhtdTgySGZYdFlnMHFoZ3loN0pk?=
 =?utf-8?B?TzZIem51cGpReDNsbmp2M2UzV3JSSy8xM1R4aGFRRWppbnZnZks1Uld3U2Qy?=
 =?utf-8?B?K3FudnM2MkF3Ziszc3ZHQmkxRGdBbmJDY21lOHlRWGhCUnFxbi9hVVdDYTBL?=
 =?utf-8?B?YTBNOXdIVEQzUWJaYXd0amZtUGpFOWhOeTFSZUNwM1RjVHM0R2NPZ2JCcERM?=
 =?utf-8?B?ZktLSjYrUEF4aG9hQVJEeUtHNG0rbkpFZ3RUY3diWTlRL2VnYnl1d045c0pq?=
 =?utf-8?B?aWY4UU9kL3YzbnI3ZVN4c3VKWDM3TitSeUY5cGxubUhTaCtIOHc2akVHemNV?=
 =?utf-8?B?V2JXR2JuWlZkanR3WllMdS9UY1ZJd0lWa1pFQ2t0dWlQOHAydGtMVmF3Q3k0?=
 =?utf-8?B?M3JGZ3pHTnVDQWZJZTUxdE91QU9TdmlKNGs2VDBmbFEyQ01DZDZmeHpKekJz?=
 =?utf-8?B?UlJWOThmN2ZrRWhZWW5rNGd6S2hnRVpFMFAzVXpKUndSUmpNRW9OeloyeGFG?=
 =?utf-8?B?ek1iZjZmYTAzSlo2UDVUaHIrdVh6UXh5WHo3c1dIY3dRMXBjWkxyUytoZU9q?=
 =?utf-8?B?aWlGaDUzTEtxak12UDFDZHpxdDBLRGZpbThXVm5Qb0w4a3NvYThFalAvK0tT?=
 =?utf-8?B?cUttTUVKSEdMVzRSVmd0YlhDZ3RxYTRkTVpZRXNvbDNpeGVRaW13V0RJKzhF?=
 =?utf-8?B?cVJaNFpvN2VoL0w2aisrMDRpQWNoWkpaK1ZDMUNJdFczdk15N1RYNGhNSThC?=
 =?utf-8?B?WUdBRTI0NjZrcHBqOUtDUmhXZjZHSGJpOHFHMjA2UWJwVDhlSUI5OUZZcmNJ?=
 =?utf-8?B?TTFoUHBuY2lQdGM0MldPOUwvcm5IN3FHaHRvWGN1dzk3dVVOd2JXMTVodlB1?=
 =?utf-8?B?OXZraFFGMWhDWnIxZkRmWW55UU44OHM2aHRISzc0NTJwZXpqRUtYTlhQdWlW?=
 =?utf-8?B?WTVOcU9uelFxMm9LWnA3cEtabThIYTQ2WmhkSHVoL0d6dGQzdm9JRFpQYngz?=
 =?utf-8?B?RWF2MFp5Tzhkam1Xa25ITDAwaVJ4S0JUc1l4QkVYVVQ2cEV6dFlWT001bGl5?=
 =?utf-8?B?Y0pndVptQkp2OXVkeXNQVE5OTmFOVFNMaDdpNitzR1hZZkJtVWxTTUJ3MUwz?=
 =?utf-8?B?NDdCbFJQOGkvUm1kQ0dBc3Q3bXdHSmRJcnFYMi9pcFIvZXpyd1NNMFkvOUpu?=
 =?utf-8?B?NlU0djJ5MzZoam1oVWI5a2pMRGxYdFJGbVJ3RDhOUk1XeHljWGdYOFp5NHdv?=
 =?utf-8?B?WXo5enV6cCsxbG9EbmhDYzJjMEtLbEFpKy9zRythWGlYR1Nwa0pMYmlYeUJp?=
 =?utf-8?B?NjNhaC8wKzRockRpbUpxdGNlQUZvSGYvYlFSa2x0ZzF4T1c5S3hPbTRjZFli?=
 =?utf-8?Q?SnNj1ycbc38emTHmKmgmEbHfU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F889C06D3F37B74AB9060AC13DD41B9C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3aa2bc-7c07-4e9d-395f-08dc88e3fd70
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 00:26:37.0639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XGPhChe3E9vz8LdpbrBnr+FiNGfX4xgbc7Y9UA4bsicLCfdWWp1Tf795/T23IE/KKpBgYz7lR6C/hheyJCZ69g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5889
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgYSBkZWRpY2F0ZWQgbXV0ZXggdG8gZ3VhcmQga3ZtX3VzYWdlX2NvdW50IHRv
IGZpeCBhIHBvdGVudGlhbCBkZWFkbG9jaw0KPiBvbiB4ODYgZHVlIHRvIGEgY2hhaW4gb2YgbG9j
a3MgYW5kIFNSQ1Ugc3luY2hyb25pemF0aW9ucy4gIFRyYW5zbGF0aW5nIHRoZQ0KPiBiZWxvdyBs
b2NrZGVwIHNwbGF0LCBDUFUxICM2IHdpbGwgd2FpdCBvbiBDUFUwICMxLCBDUFUwICM4IHdpbGwg
d2FpdCBvbg0KPiBDUFUyICMzLCBhbmQgQ1BVMiAjNyB3aWxsIHdhaXQgb24gQ1BVMSAjNCAoaWYg
dGhlcmUncyBhIHdyaXRlciwgZHVlIHRvIHRoZQ0KPiBmYWlybmVzcyBvZiByL3cgc2VtYXBob3Jl
cykuDQo+IA0KPiAgICAgQ1BVMCAgICAgICAgICAgICAgICAgICAgIENQVTEgICAgICAgICAgICAg
ICAgICAgICBDUFUyDQo+IDEgICBsb2NrKCZrdm0tPnNsb3RzX2xvY2spOw0KPiAyICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb2NrKCZ2Y3B1LT5t
dXRleCk7DQo+IDMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGxvY2soJmt2bS0+c3JjdSk7DQo+IDQgICAgICAgICAgICAgICAgICAgICAgICAgICAg
bG9jayhjcHVfaG90cGx1Z19sb2NrKTsNCj4gNSAgICAgICAgICAgICAgICAgICAgICAgICAgICBs
b2NrKGt2bV9sb2NrKTsNCj4gNiAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb2NrKCZrdm0t
PnNsb3RzX2xvY2spOw0KPiA3ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBsb2NrKGNwdV9ob3RwbHVnX2xvY2spOw0KPiA4ICAgc3luYygma3ZtLT5z
cmN1KTsNCj4gDQo+IA0KWy4uLl0NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3Rv
cGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGth
aS5odWFuZ0BpbnRlbC5jb20+DQoNCk5pdHBpY2tpbmdzIGJlbG93Og0KDQo+IC0tLQ0KPiAgRG9j
dW1lbnRhdGlvbi92aXJ0L2t2bS9sb2NraW5nLnJzdCB8IDE5ICsrKysrKysrKysrKy0tLS0tLQ0K
PiAgdmlydC9rdm0va3ZtX21haW4uYyAgICAgICAgICAgICAgICB8IDMxICsrKysrKysrKysrKysr
Ky0tLS0tLS0tLS0tLS0tLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCAy
MSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3Zt
L2xvY2tpbmcucnN0IGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9sb2NraW5nLnJzdA0KPiBpbmRl
eCAwMjg4MGQ1NTUyZDUuLjVlMTAyZmU1YjM5NiAxMDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRhdGlv
bi92aXJ0L2t2bS9sb2NraW5nLnJzdA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2xv
Y2tpbmcucnN0DQo+IEBAIC0yMjcsNyArMjI3LDEzIEBAIHRpbWUgaXQgd2lsbCBiZSBzZXQgdXNp
bmcgdGhlIERpcnR5IHRyYWNraW5nIG1lY2hhbmlzbSBkZXNjcmliZWQgYWJvdmUuDQo+ICA6VHlw
ZToJCW11dGV4DQo+ICA6QXJjaDoJCWFueQ0KPiAgOlByb3RlY3RzOgktIHZtX2xpc3QNCj4gLQkJ
LSBrdm1fdXNhZ2VfY291bnQNCj4gKw0KPiArYGBrdm1fdXNhZ2VfY291bnRgYA0KPiArXl5eXl5e
Xl5eXl5eXl5eXl5eXg0KDQprdm1fdXNhZ2VfbG9jaw0KDQo+ICsNCj4gKzpUeXBlOgkJbXV0ZXgN
Cj4gKzpBcmNoOgkJYW55DQo+ICs6UHJvdGVjdHM6CS0ga3ZtX3VzYWdlX2NvdW50DQo+ICAJCS0g
aGFyZHdhcmUgdmlydHVhbGl6YXRpb24gZW5hYmxlL2Rpc2FibGUNCj4gIDpDb21tZW50OglLVk0g
YWxzbyBkaXNhYmxlcyBDUFUgaG90cGx1ZyB2aWEgY3B1c19yZWFkX2xvY2soKSBkdXJpbmcNCj4g
IAkJZW5hYmxlL2Rpc2FibGUuDQoNCkkgdGhpbmsgdGhpcyBzZW50ZW5jZSBzaG91bGQgYmUgaW1w
cm92ZWQgdG8gYXQgbGVhc3QgbWVudGlvbiAiRXhpc3RzDQpiZWNhdXNlIHVzaW5nIGt2bV9sb2Nr
IGxlYWRzIHRvIGRlYWRsb2NrIiwganVzdCBsaWtlIHRoZSBjb21tZW50IGZvcg0KdmVuZG9yX21v
ZHVsZV9sb2NrIGJlbG93Lg0KDQoNCj4gQEAgLTI5MCwxMSArMjk2LDEyIEBAIHRpbWUgaXQgd2ls
bCBiZSBzZXQgdXNpbmcgdGhlIERpcnR5IHRyYWNraW5nIG1lY2hhbmlzbSBkZXNjcmliZWQgYWJv
dmUuDQo+ICAJCXdha2V1cC4NCj4gIA0KPiAgYGB2ZW5kb3JfbW9kdWxlX2xvY2tgYA0KPiAtXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXg0KPiArXl5eXl5eXl5eXl5eXl5eXl5eXl5eXg0KPiAg
OlR5cGU6CQltdXRleA0KPiAgOkFyY2g6CQl4ODYNCj4gIDpQcm90ZWN0czoJbG9hZGluZyBhIHZl
bmRvciBtb2R1bGUgKGt2bV9hbWQgb3Iga3ZtX2ludGVsKQ0KPiAtOkNvbW1lbnQ6CUV4aXN0cyBi
ZWNhdXNlIHVzaW5nIGt2bV9sb2NrIGxlYWRzIHRvIGRlYWRsb2NrLiAgY3B1X2hvdHBsdWdfbG9j
ayBpcw0KPiAtICAgIHRha2VuIG91dHNpZGUgb2Yga3ZtX2xvY2ssIGUuZy4gaW4gS1ZNJ3MgQ1BV
IG9ubGluZS9vZmZsaW5lIGNhbGxiYWNrcywgYW5kDQo+IC0gICAgbWFueSBvcGVyYXRpb25zIG5l
ZWQgdG8gdGFrZSBjcHVfaG90cGx1Z19sb2NrIHdoZW4gbG9hZGluZyBhIHZlbmRvciBtb2R1bGUs
DQo+IC0gICAgZS5nLiB1cGRhdGluZyBzdGF0aWMgY2FsbHMuDQo+ICs6Q29tbWVudDoJRXhpc3Rz
IGJlY2F1c2UgdXNpbmcga3ZtX2xvY2sgbGVhZHMgdG8gZGVhZGxvY2suICBrdm1fbG9jayBpcyB0
YWtlbg0KPiArICAgIGluIG5vdGlmaWVycywgZS5nLiBfX2t2bWNsb2NrX2NwdWZyZXFfbm90aWZp
ZXIoKSwgdGhhdCBtYXkgYmUgaW52b2tlZCB3aGlsZQ0KPiArICAgIGNwdV9ob3RwbHVnX2xvY2sg
aXMgaGVsZCwgZS5nLiBmcm9tIGNwdWZyZXFfYm9vc3RfdHJpZ2dlcl9zdGF0ZSgpLCBhbmQgbWFu
eQ0KPiArICAgIG9wZXJhdGlvbnMgbmVlZCB0byB0YWtlIGNwdV9ob3RwbHVnX2xvY2sgd2hlbiBs
b2FkaW5nIGEgdmVuZG9yIG1vZHVsZSwgZS5nLg0KPiArICAgIHVwZGF0aW5nIHN0YXRpYyBjYWxs
cy4NCg0K

