Return-Path: <kvm+bounces-61741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 146F9C27313
	for <lists+kvm@lfdr.de>; Sat, 01 Nov 2025 00:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B017F3AFCC2
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 23:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773F932C930;
	Fri, 31 Oct 2025 23:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZV6YfF49"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ADC28C035;
	Fri, 31 Oct 2025 23:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761953724; cv=fail; b=k/Qhz+75MY08MXbVGI59Jxo7mE+gUsPE3iLi/GziDq5yRElnPQKkQD2IiUcJFc7dHJ5UHxil1WT4hCl54OWoBnjqWSCAcqhXgOG4obzoNQgLIhKRHwgdMP+Inovj+aYvlMwds0g8pqNT5cTckKuORaDLJrBLvq+Il0MPrZPaUxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761953724; c=relaxed/simple;
	bh=mfx+zfKzGjt17+DWe7HHMQOepV/yvhxO/YNZvFj9ra4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mLY97W+3nCF2eiToUy4CJNvDO/9rgjU6YIXUy09Prq05Y0vvXB9iNsEKXQcBA5VgybO4wjiftGc/A9MSXb7hQuXAZov8sI9yyGzZ1gBbHUcEwvRUOjMV9xqD8Yi54W6YnQwQQ2iS5gRAtD8ms2e5mKZ3JDzU+OldxDnxFdBgluk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZV6YfF49; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761953724; x=1793489724;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mfx+zfKzGjt17+DWe7HHMQOepV/yvhxO/YNZvFj9ra4=;
  b=ZV6YfF49nluB7bd+fTvv16Ja6L43h1yaIvwtrHKEWrXDJV8h/MOfdCjQ
   QZjxm6yE4cNtgIfu4hmZKOEWdmIey1lnKW9cXlGSWTywtL81y4m5VLlBo
   gGZ9Q6To6BKHRpwf47TQLIu1ZIqyMEOgCxIGaP3kbVP+fZkdqVamaFUbQ
   8gMm2yOyxxvwZ21i9FdMIeKmmXjEsc19MG0D8Qv2qfhNt+MvcG3veOqB4
   yrvbe14EM7XbUfr9kNmUlO/qp+tz39oeLxY41MTn7Ad7/sNaXQvR6tq7G
   s/eMIWyn9JsZy1D5nZX/nbuAx5TrBYTkf+KhZeqyIZQ9tsRjFmOdea6mt
   g==;
X-CSE-ConnectionGUID: V7IEkzCCRfSnIYo8Gco1dw==
X-CSE-MsgGUID: cZIhI8KyRAu+RQM84GYAAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="64270143"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="64270143"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 16:35:22 -0700
X-CSE-ConnectionGUID: IM4/00fgTxWqvDvEKznEpw==
X-CSE-MsgGUID: /omuCK2TQ3Os3cu6sNTD3w==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 16:35:21 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 16:35:20 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 31 Oct 2025 16:35:20 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.35) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 16:35:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vZDSfquJrty/QE0fxXJp5/GbBuyeH9/CHa7xxy4gYi7UryM+a2nmuTlFzg7bywcyHo1snpQPnmu3RMZFJjtH8yR9QxTSJa2eOKjAj4JZzGquCyvzyDfXvkVfrK+Nwjj7wvKCJ9Y5OsoxNX7c/fLpTIQVuw8saxqC+uGapHR3/P0h5QnIuUfTl/pffwn/WHdlRRTWzOYF8JvIfeZINx0vXLMLUuv/yrJEY3oSYVNwmFfldZfroJ20Okp6ARJoO8miJR+1YGXnbRlSt8mez1RscIDnIX073qCiQK9LOXxTvoUQjSAXkkfLKBkW2Kkh7uhS3SQ1bAtxFqMy+If2LMzutA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfx+zfKzGjt17+DWe7HHMQOepV/yvhxO/YNZvFj9ra4=;
 b=TctuNfycBwIiysmtcaf4N+maFnYCLEeQkSMD1TO1hZtovUsOClR6+AL2Mae80Ko33EQpODad/vgad43As4S4S/ZP2DT5VplrUcvHbjiDxrb82m/fiib7FUdUsxcrzqiGITE9VtC9MtQkVoCed0KQGGM1oPIYCJPNcP6ATn0ytif2kah0ERLmOp0MNxRbahqR7y5bHk8Xx5yybK8hh936VGmLVfDHBT6ZAMor6RX/9V55zCfeKuO9NRxAN5r26XY+eVBHLWOwjMgo7/BQvI7ZwpUFkwQLvCj9Gzg+Yq9kaPhtjAnALDVXbLgdczbFGYZQ4lOsP2DoymY35HQaiaB4VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6882.namprd11.prod.outlook.com (2603:10b6:510:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Fri, 31 Oct
 2025 23:35:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 23:35:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Kohler, Jon"
	<jon@nutanix.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] KVM: x86: Cleanup #MC and XCR0/XSS/PKRU handling
Thread-Topic: [PATCH 0/4] KVM: x86: Cleanup #MC and XCR0/XSS/PKRU handling
Thread-Index: AQHcSr1bAl8gqrCpZUa1bHaAMqAAaLTc6IyA
Date: Fri, 31 Oct 2025 23:35:18 +0000
Message-ID: <d77d8c4c009d42a56341180d83138b111b75aff7.camel@intel.com>
References: <20251030224246.3456492-1-seanjc@google.com>
In-Reply-To: <20251030224246.3456492-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6882:EE_
x-ms-office365-filtering-correlation-id: 81cc497d-d8b7-4bf8-2f71-08de18d6268c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Nzd6MWE0cVJqcjV1Q252MzdqNnpnenFOWENQNGxMZjB1eGtNV3RxS0NVemd3?=
 =?utf-8?B?UkU5Z0hZMUpZSUtCelhNU3RnZDRLWGVBK24reFZxZkIrQTFPRGVuM0pEWXJ0?=
 =?utf-8?B?clNwM3RTS2EvSVU3QkhuSmhXMS93TmxOWkp6aFBNTkY5d0xSZkxqaE5oQjhU?=
 =?utf-8?B?V25nbWJZYjJ3ZlN1VmIrK0thRVdYNUJBTWNmQXhwMXhmVlJ5dzZUQ0ZJVDd3?=
 =?utf-8?B?Qnc0bGx4NE0weWhiQzEzZE41eE4wT29Td1QrQUpJR2IrWUFJTEZWai9mZy9u?=
 =?utf-8?B?VzQrL0NTUnNUTmxqWlpDRXVvcjQvOHdjUFFLblNFYkdNU0gwTVFQTGxlZWQx?=
 =?utf-8?B?TUdKWXRJU3MwOGw2TTRwM2MvL0htL0F3Zk54NlhXYk1VS2xGcDJNRE5MOHJL?=
 =?utf-8?B?UndjWDRObmRZdlJLallFeDI0WDJpL3R1cWdNVmpiUjczbHd6cFdramR0azZP?=
 =?utf-8?B?dmlZRCtESEVaMUlDVTlSNmo2eWJ6WUZvMVEwdEhGMXZvbUV3b2I3dkZXMzBx?=
 =?utf-8?B?OHEzRWFrcVpYbTdKRC81TXorUEtETzRXSksvQjN1K0ZKeHhrSzN4VDlyMGdX?=
 =?utf-8?B?SHA0eUZuQXpTNyt6TmpjZjdXQjNCcnAzbHZOUFVUTFpxU1RNeTFIZlRwMWFn?=
 =?utf-8?B?VDlZeDF2SVU3SnpEQ25tampuTUZnVEtab2Z0cE43N2lNTFI1cS9rSWdjNkxt?=
 =?utf-8?B?cnB1cWRtTlBvY2xrbnRSaSt2WGdLb1h3VHRsL0FjYUE1aHBXN1BYREkydVhq?=
 =?utf-8?B?UkN1L1ZaYnRDWmdDY0JKM3pPWHY2SDNaUENUM25SVXJ4M2h6N2JSSUw1SUdh?=
 =?utf-8?B?T0Z1YzU2ZFFMazJlRldvTWoreTAxMmZpQkg2RTk3a0hraTM0RUVkL0pvYTlx?=
 =?utf-8?B?L1pkdVRCYjZMYkhHNmQ4bUluU2NTazhlcXJkUjlxQWpwSzVkeDlGaGxLVmtx?=
 =?utf-8?B?VFBjQ2szOXI4RVJ4VHJzZnA5cFF1eG9yTUE3aFJBRUp6MlB0eXR3cWZrWUI5?=
 =?utf-8?B?STc5Yk1kcUdONCtWZFhWSURnZ3FkRnUxa09WZml0YzdZZGkrY0x3Z0xua2Uv?=
 =?utf-8?B?d2R6QjMxYVEvQUlVVUtIblRWQloyYTNqR0ZhNXMxY1pmVGpUMVM1dFJ3dnRT?=
 =?utf-8?B?RWQ4d093QjQ1Q05iUkNDaEI1OVBjOWNhdnhIU296SlgvbGM5QXRqcERxZTJw?=
 =?utf-8?B?bG9ZU1BTV3JkaGRtMUtkSG5WVjlha0hiYlM1cElJS3pSUmNpVFFBS1FSaGM3?=
 =?utf-8?B?UnFHTEhsSE9EMVZlWDZRNFFOZzgxYnlsQ0tFaFYzVUhsR0JDeFpaUTAyS2lh?=
 =?utf-8?B?R2xVQkpKeFpObjBZcCtvcnlHeThGMm42YnI0a0dFdlVXYXM5N3RPZ1d2a04x?=
 =?utf-8?B?S0RDbysrYXF5eXdzTUNjK3NtdzVScnA0dW1BT3NYcTRkZEcwcFFTUTh2aE81?=
 =?utf-8?B?a2k5Z3RMNU4rQi83V3Nkb1diQ3ZDYzBReVRhU0xzbDl5RVNhUzFWZS9vQ2Vh?=
 =?utf-8?B?VkZ0NG95dEVGNmdhRWNLQ0t3UDhBWm1kMHNtWWhzU3MvTXV3OXJXSm5QN0JD?=
 =?utf-8?B?dFI3bXlqQ3BSUytwOFRTZXJLYTY1cVp6U2tMdVM3R1J6cHhiajVXbTEzYk10?=
 =?utf-8?B?RmljRFpmOFlHaW1hdURqcFdXUitrQnlDNjZOMklPR0JLUlNXVkF4V212OG9K?=
 =?utf-8?B?YUZyelhldVdwVzlNOHF1Y2Q1RkkwcEo4ZWI0MUpCMXJRdFAxRjYyWnZycStI?=
 =?utf-8?B?WGtMcnczM2pVMC9QVVk1anFHUjdVUjV3Ym9ESndINDEvMzBVd0hmckN4ZGYv?=
 =?utf-8?B?Qnk5OGM0LzBubHJKVW5UcXdtV0RaZyt1V2c1elg0NXBydzVaYmdsSWZqbnJZ?=
 =?utf-8?B?SzFaUmUxOUl3NUFyRUxndlMzbTFSQjJuWjBUbFBNV25EczBCUElwZE1LbGg4?=
 =?utf-8?B?cFBTc1NOckF3NUszbEprd0gwWjlUeFZoT240Nlg5ZlVMcGpLTjNPd1hscEZs?=
 =?utf-8?B?Z0hERzc3VTVsYUg3SWJrZ1dWSGFzeVh4aEdkbktaMVBnajk0bG8zNUoxdVFT?=
 =?utf-8?Q?45QPke?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0huV0lxU0hyMFB5Vmh0MlFDa1F6cy9pa2JtenM5MXYzbTNaVDZyVEMvdERt?=
 =?utf-8?B?Q2VYUm5nSHZ2YmErSjBhaWZWeFNGdzF3dXIxR1MvR3FGMjVteXVQZnFiZTNr?=
 =?utf-8?B?VTB0L21BYkJUaS9hc1ozajg3MVlJZnBkdGJuNHVudkozd0JSUm9LZlZqQy83?=
 =?utf-8?B?bmpPN2VVWU1PeXdlb2lldEVYZEVnRlNkZTRJVkhlQlAzK091aUtNSmtDT3FR?=
 =?utf-8?B?SHNqaFFSRldSVVQ0bFZZNWFaSGZnVCtoaHE2U2hSM0p2NFk2ZnpTWFBnNFYz?=
 =?utf-8?B?T3luYnVrTzN5ZzNoemN4RDV2ckMrT3VpemJoTlRpVlgxZXdEWi9nOHBJaVFL?=
 =?utf-8?B?RGJNR2JnZmQwZG85alMzYzlEOTdyMlRwV1lvZ0JTN1NCMFFsRWI0MFFPOStS?=
 =?utf-8?B?NmtDVWNFUlF0Q25UaVpJNWNzTW1HeDZBc21CcTQ1WmZTZTdhcE1FRWx6OG4y?=
 =?utf-8?B?RUxOS0Vkakhmak1yWmRHQjExM1Q0SlF0eGVlYzNxTk9YVDBSbFFsREltVnZV?=
 =?utf-8?B?MEpySUx1dnFzRjFnWk0rVTgyNGQwQlJQV0cxczRhcVJDb1A2NVMxcVNKdnFG?=
 =?utf-8?B?N1dHTmxmMWJ5Q0xwaFE3bllBZHBlNW9YendFTGxJb252aEkxelc3bTlCRzZR?=
 =?utf-8?B?VVlNemNQdEdlaFJEa2s2QjRiYmdJbG4rSjExcnUzODJsdGdQVHlLeXE0Nm5G?=
 =?utf-8?B?OTlTZGVrQlYvNFhWOWlXNHMwdnBjWThsRmc4V1BHQytRVVc0eGZVY3lIbVFH?=
 =?utf-8?B?N0FGa2RuOXNyZHNZekFDTTR5WVZmanVYT0RWUW94Mkg1TXJ0aWVndUl0UVVW?=
 =?utf-8?B?NUVSeHRMRnVTbFh6VzlJUS9ZdzlJWng0SkxlRmFGa3hlT05HeEwvN3RTbU8w?=
 =?utf-8?B?K1R2bzI0ZEZScjY5NHFWSXRWTjdFZjJ3L1cxMWEzRFV1NUwxS0hmU1VnQ2dF?=
 =?utf-8?B?RjljYWd3WkRKU0I0Z0pNSmJlQWpDZklud0dUZFpJSThsYXBYZDRwZ3lnYVhl?=
 =?utf-8?B?djFXVFZRS2gyTDVtZmR1Q1pTVzNtcjc4WXRBM2tSV1NaNzBYSy90UkExSUJv?=
 =?utf-8?B?R0J3dDFuQVFSUGcyRjFPYVNBMGhyVldLNTl0WjRRVloyc1hHaTc2NUdTdTBO?=
 =?utf-8?B?VnpJQi9LemhFREc3T25uZm5ac280TTVicHc3UWlZa3NlNjVqYkROcnJ0SzFo?=
 =?utf-8?B?YjV5UnB0OUxhdnExTS9QeXBCaTY0YmlZSVFXYWZqeGRwUUxFcCtjSjJLRitG?=
 =?utf-8?B?SVFMU29qUlRPb05iUVVBMGVHZWdqSTR2cTNLZnM2UGNKcks1ejlXSzF6RGZl?=
 =?utf-8?B?WGxrZWYvL2M3UVc4b3Q5UkQ0UG9Ub041Mnd4Z1FNS3VqV0hTTG9xZXFQajN5?=
 =?utf-8?B?T3lhTVZmNDA4N0xXdzNndkRQREFoTUplbndVRVFpaUpnRHExL2xCcXp4RVY1?=
 =?utf-8?B?MFEzV0RwS0ZmS0NwTDdpZVErWE9GeUc1VHBwMkxwREtUWkwyMXZqcytsOExt?=
 =?utf-8?B?TkZlRlY2MTExZytlTnQyTWsyL3NxOHd3R1hDM29aZEh6N1NuTHRoQ3JVSEJp?=
 =?utf-8?B?RjVaMUMrV25seHltNm1JNnVqUmhnUjg2L1ZTZkN3Y1NDbU5KRStFRDVKNjJk?=
 =?utf-8?B?czF4WE9FR1dvNHdaQlBHQVdFdURyOUJmYzlGN1k0NUs4dlJHNHYvUkN0RHZ3?=
 =?utf-8?B?a0hvT0tZTlVJZFp3Q0Fxb05id1JLYlhuYTFIQmZka0U2SGdJckF1bjFwOEZI?=
 =?utf-8?B?TDkzdGFnc05mL0VnbUR2bGRGbXJ6YVptKzFRUU10WVd4ZmhacHQyRGYwR2Z0?=
 =?utf-8?B?Sk9ZZldGcWlva1pGbDZja1BUOHE5dlVHWVJISFF1bThoSTZaTllIbFQ2R3Ni?=
 =?utf-8?B?MHhvZXhYMGtaUERSUXJJM01PRGhqMnNIRjBNTms0SmpiQ3Q1b3g0bDRscndL?=
 =?utf-8?B?b1V5cnNZZ1FycmxMaDQ0NWRwSXdTOHg2bElaaDZmTFV2akxLRG1nRStoM0sv?=
 =?utf-8?B?S2o4Y0pEQzBrcmd5YkJnMDhlc1JxR3kvd3doUXNpaW5EY2tQUUFScmFEa3hR?=
 =?utf-8?B?akNhQ3NEbGkyRlN4WlgvbFJtVEJTVGRKamNIdnFDZnA2cXpZNlhQKzcrcFVa?=
 =?utf-8?B?Yy85c3I5Mzd5TDRwMTFQTWlKa1Y4ZDlTMXJkck5VZUpQMXU0R2h6MkRwU1Uv?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5F639E27AA9DD43BAAE81F3810BBC62@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81cc497d-d8b7-4bf8-2f71-08de18d6268c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 23:35:18.1594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 68dTF6xCZ2iO51DeXgeEN69e4Uut+U1WSblESuyEVRsPFNdJR7SiBNYVF/v4UxvQCbZYTXXE2dtjU5gNHbyPtWt/xoklDFJ+KFtMfsne9wM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6882
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTMwIGF0IDE1OjQyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBTZWFuIENocmlzdG9waGVyc29uICg0KToNCj4gwqAgS1ZNOiBTVk06IEhhbmRsZSAj
TUNzIGluIGd1ZXN0IG91dHNpZGUgb2YgZmFzdHBhdGgNCj4gwqAgS1ZNOiBWTVg6IEhhbmRsZSAj
TUNzIG9uIFZNLUVudGVyL1RELUVudGVyIG91dHNpZGUgb2YgdGhlIGZhc3RwYXRoDQo+IMKgIEtW
TTogeDg2OiBMb2FkIGd1ZXN0L2hvc3QgWENSMCBhbmQgWFNTIG91dHNpZGUgb2YgdGhlIGZhc3Rw
YXRoIHJ1bg0KPiDCoMKgwqAgbG9vcA0KPiDCoCBLVk06IHg4NjogTG9hZCBndWVzdC9ob3N0IFBL
UlUgb3V0c2lkZSBvZiB0aGUgZmFzdHBhdGggcnVuIGxvb3ANCg0KUmV2aWV3ZWQtYnk6IFJpY2sg
RWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg0KSW50ZXJlc3RpbmcgYW5h
bHlzaXMuIA0KDQoNCg==

