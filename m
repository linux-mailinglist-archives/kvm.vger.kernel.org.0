Return-Path: <kvm+bounces-16008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF8E8B2E3E
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 03:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCF21283A04
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2720D17EF;
	Fri, 26 Apr 2024 01:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bl0zqOvl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA989EA4;
	Fri, 26 Apr 2024 01:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714094297; cv=fail; b=HXpWZV19/NYsXcfvl7TBsXlGSAV639/tUMT5n5lVbjXSK0k/h+IY5R7UVBBZ3r9NzjZnpCIOYvYziTaP+axOoIiAwDwBL2xVwy3Se9Kye9KfTITQk/85A92CSSLle2W6MstCG51G9ojxVuZc4wdydSaAh3xFDWRqeWkbHbqTgww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714094297; c=relaxed/simple;
	bh=sWuIBl0Q3AtaKxsYX0gZfHdqAjLoUA/gj5Ca2CZvGl4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gJRfCIJKWJwOx0qz5WK0KBC6GnR8/hwjnI+golaLV2S7BSpN9a8toCcQ6mDLuRthWBC4/Zf/GYjRAaGFnJuROYBkgHZDNG7CCKVvqawW22Zen4GstUjriMGMPVeygvRHzaZ4XK+Xh/UoFRXzi6oOLtmYG12YHj134xnpVhdSzY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bl0zqOvl; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714094296; x=1745630296;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sWuIBl0Q3AtaKxsYX0gZfHdqAjLoUA/gj5Ca2CZvGl4=;
  b=Bl0zqOvlPGuBEP6FlxYuL2K3F1n5nB+JgDv3LFYv7SlrSvdL6NfAIWs6
   VieJtyZoal0+BKdFmEpNm1irrqYHVvn/xDQNlJRtyIJFBNSVu9dr0D83Z
   CnyH5zYF7CnPIFLC80WEgoEdDBdudBLSd6bUadbdTVRIpRzwTc9TNTkb9
   ikLbq2ZOVxwBJhjicHEvN6/5SGoy/SaJH4ERGlrpvWtFPxus88r2xmFcG
   6mc/+CIgErTDWt96BHAOg9C/mym8UGgoyWl9h2QZNR1cebuHAcck8gAqj
   o4/KtgHio0hycrspI1XchIJDkEu+d5IZOLQ04vLi892UWbU+Iz/mbACsD
   A==;
X-CSE-ConnectionGUID: XLk1jgVkT9GIYKcaRwoRvg==
X-CSE-MsgGUID: p7nmSobzSy249gV8nQnVHQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="20431152"
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="20431152"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 18:18:15 -0700
X-CSE-ConnectionGUID: YcsIpj9sRZmtqjZ7c7/xlA==
X-CSE-MsgGUID: E7svrOtCQiKkHxfC9sKOtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="30063950"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 18:17:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 18:17:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 18:17:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 18:17:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBRpfBIEd+4VRX2O8RYwgBHj+CCY9l6DqmTMMo6J1zGhAlo2wUQKLPeFcgDixAotpHh25uKa1t1zmu32p54SZD3EeuHUwhuZwQIVjHUr5DgYiH9NBR6uwIPmd4wPwQiY8UzR2eoQUoh9F3bxtTP2sW9Spg/1Zlptq5GO74NmVidubzCS7+GECvCx1uK1tjgF1svgG8e88nUzJNEy/HY47z5ucmTFr8uKOw8yBXgcM2x3RLj8+ajxlpwzmkuVJ3scppAxPdjrt7zUby4oL/Yf2Kfal6LcRxWiCrcDLdi7T+qmkejmf8XJ2fwxccN07xIgTJvHmpRUWK4BUKSXU2qzig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWuIBl0Q3AtaKxsYX0gZfHdqAjLoUA/gj5Ca2CZvGl4=;
 b=RkCCYVX5YleESmpvsRiLL2LEN5EK0kWOLfgMPv/ZICPF78w7zt+U2JgKCNN0NQbGKDBKSRoz3Ehx4FcIz5gv3njo7VkTlCnBXH7hZMD/cjtguBTo8eV4gtlZwcUnI/Yea4Eo5FPOElgj9jH97O59OD54TPhhGpw1E4utnV34JfJmSP47AwN5nqVnCMIJmwV+NLjqZyGViGGh3P+0AGjpADpSmipwBmMIgiLsX/ZfXoxGASZ5B2OGAMNmQiFxDck5d5qovIQCb8DSt8XQ4WNyxI1eRH7ILlBUCiDqmksQ3BFDMnZNtWziKEI2eRBWF8a+Mu6JTorlXLTGQShG/RnUyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4633.namprd11.prod.outlook.com (2603:10b6:303:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Fri, 26 Apr
 2024 01:17:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Fri, 26 Apr 2024
 01:17:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: Fix supported VM_TYPES caps
Thread-Topic: [PATCH 0/3] KVM: x86: Fix supported VM_TYPES caps
Thread-Index: AQHalZ7asK61cfXGT063Yq/yoPCydLF5AdMAgAANPACAALSegA==
Date: Fri, 26 Apr 2024 01:17:11 +0000
Message-ID: <7f3001de041334b5c196b5436680473786a21816.camel@intel.com>
References: <20240423165328.2853870-1-seanjc@google.com>
	 <4a66f882-12bf-4a07-a80a-a1600e89a103@intel.com>
	 <ZippEkpjrEsGh5mj@google.com>
In-Reply-To: <ZippEkpjrEsGh5mj@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4633:EE_
x-ms-office365-filtering-correlation-id: 2d9defda-307f-478e-320d-08dc658e99ad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?a01nczNyamg1Qjl4dVVRclltMG5kUWtBV0g0ZnBvanJrVGdaN1N6TUxhaGRI?=
 =?utf-8?B?emhBUiswL2Q5OXpkbE5zcnF3cjFobEprUWZWVGFVTmNHcjQybkZ2YmxBWFVV?=
 =?utf-8?B?dGZCeUZHMTNOSFdQRWxPVGJ2THJ5ZzJNTGpESTFvV1AwOU5vdUFKMmJmR3Jt?=
 =?utf-8?B?VVFKWkZDbUlPWHdGZWE0ekpmbVovSVIyT3o5M0w1RDJxWDk3ZzMvYytLL0cv?=
 =?utf-8?B?T05mcTcvSmkxV3kzakR3NDAzcnJ5ZDdtN3RzNHNwaGNseDg0eDQ3VjlBVVFP?=
 =?utf-8?B?S0FCd3hLQXlCNjZMdW5HYVh4dEpYTFdQelkxK2Vtc01rU05keW1vSWc5Sk9U?=
 =?utf-8?B?a2N3UXErNjd4eEJTT2xkTXF2dExjSDA2SlNiZ2huRmpadk8wNUVaUFBXQWpZ?=
 =?utf-8?B?d3QxUjNvTFRqQytHSmFwSGdtb3paZllrb25xOEtwS2FpUjh1S0YxaGlkQmJt?=
 =?utf-8?B?NktYRm1rSk1vSFdUMkM4cWlaandxVVd1UE5lalhZamRlUkRZeGlmZEJ3WGpI?=
 =?utf-8?B?Y3V3cXpoTkhyUTYvUXFVaUJhcjlkT1BBT2FYekpJeGtMbFhOL2cyMkd6MFhV?=
 =?utf-8?B?a3FDT2RydThiNkxLUFZsM2pLdEdTZGp4U044Y1N3T0NFZ2R4OFdjdkpkNDhi?=
 =?utf-8?B?dHVjV3BBNzJ4SzhoMVJDdmhaQ1ZIWVJiSW5XODIzeW1BWkhGWURXTk9CSzh4?=
 =?utf-8?B?OXVTK3pWMkpaREh4VnZjeXJRSEtNUWd4ZkZJdFAwT21JMXJ0aG9POFBlbk5i?=
 =?utf-8?B?eUU4cVVEVnFwSERhcHZFOEtXWUdjVmRXLzhTL1FmQ1VBejZ0WE1ocXZPdDgv?=
 =?utf-8?B?T1kxcDNBZUZjN01CbjNzVjJtNDEvUDVMdnpod1g4ZjE3WmpsNHcvWDlDMlZZ?=
 =?utf-8?B?TERuV0FMUFIwaklZOGFDUDZHTHhGZmZPREtGSGc2RG5OSjJXYjdNRDFSRXMr?=
 =?utf-8?B?RTNlYVFUUmtmNWZ3a3p2a3pXMVI1TTEyTFNNS2tiUUhXcTloRllzK3FacXdB?=
 =?utf-8?B?RTVYcG93SnhGLzJQakFseXVJdFJhNjBYTUxPbHEzU2xpMkhCUFRpalQ5Rmtl?=
 =?utf-8?B?SUpNYU40NS9kVjhGRUhySUNSb0R6RDNwdjliYjJXWjlIOGRIVTBWRDZTbEt2?=
 =?utf-8?B?VlpTd1J6NUs2Yy8zNW05ZW1Yb0l1dWZFRHorV29Gd3BEYzRmRWwxVHpkU3l6?=
 =?utf-8?B?endNVElicTZ1ZW9aWHNNNXQxMDFTZWRWTFE0WVFvWTAzMjhSb3pzWThIUkJh?=
 =?utf-8?B?ekNHY3lyTVRHUWs0WmVVcm5hSUw1MW5XRk1UeDMyUUFkY2FXbmxzOFhnaHlX?=
 =?utf-8?B?TGtCNEc0dlpXUmpnRzRGRFYvMTZjem0rTlcrSEx1TlV6eHJPU2NzL1Y0TlA3?=
 =?utf-8?B?YWxkNVdLTFJUSjBjUGF1Z0NUUGVyb3RkdEpzVDhJMmJQRHMyRm40Z0ZaZm55?=
 =?utf-8?B?MFRqbEN6bzdzWkdPQjY1SUdVUGNWNkNDRndGVHpjMUlIOHpXUXZiOVkvVDR6?=
 =?utf-8?B?U1ZnQW5wa2hlcHdXKy9tYkE1eUJnVWRSeHNqRG5oMkZZbEF6ZCt4OXV4bHBp?=
 =?utf-8?B?eUV4alZSYlJxR0M3Z2p1TVJhR25WVVU4MFNTVi9JVHVoVXRqYTNQVXRqSGZY?=
 =?utf-8?B?aUxYdUlCbnNEWjlSNGhXOXJLUGIvNDE1TGpTbmhWMmZJVk9YL2V5RTM4emVo?=
 =?utf-8?B?TktMWGVkVGZ4eFFabEN3aTZ3RVN3dUM2QXNhZDFLM0ticzIyaldTblhCd3R5?=
 =?utf-8?B?TEozZVZrWktMb2xEZFNCZ1BOZ3hBWWpOV2k1K3dUKzlNbUFsV3ROcGFpT25O?=
 =?utf-8?B?VGJxWC9qUzdwUi9aVVRZZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWdSRm42bHY2UVJnbmMvOVBJbG5sMS80Ui9CQUwzM0YxNytlZTlFWEkwekQ0?=
 =?utf-8?B?eGdrYXM4NkxEMGk4bExqTFJLZHRxU1I5ZlIwRndYdHZYaXRYZTZrMDV6b1dh?=
 =?utf-8?B?RzVZWTk2VENRSWlwSk9kNUJqQ2dJdUtKcy9hZGZDNnhUNWtVTjV4UGNRaUVr?=
 =?utf-8?B?VWZLTmVFbjZEcmJFbFM1ekRsUURLZ3A3b1Y1M016cThxTnZpT1hteStOMUJS?=
 =?utf-8?B?UnZwUzlnNWQrWncyNkZZcS92Y0s1WE1wQk9PUks4VUtzSWF5dHErOTZMN1l6?=
 =?utf-8?B?K1J3cE85eVRQODNhQWloekZMSmpiUUwwbmFGZGVJamFpMTFJSjl1V3hKTUc1?=
 =?utf-8?B?aGk5RE9HakNUMTNIcW02SnpRbUpUL1FsWllGOUVodXhESkErbFcvblJzQWFZ?=
 =?utf-8?B?R0FTOFNQaHl6K3FPbk5kNzBQcVpvc3V1alJ6SStXZVlSRWJwNWh6WDNQbi8x?=
 =?utf-8?B?TzhzMmhicVFtbFpsblFRdzFMUG5JcEZXdnNrcVBpUVl3Qkc5bFVaeTE4TTh3?=
 =?utf-8?B?dWx2Z21mVnBYOEdWL0drcnF2TFhMTmdsODdQc0c5dU1hL05CWTdxczhKaXkz?=
 =?utf-8?B?Qlc4a2hFb0toRVdvZVdyeFNiM2p3QkVwVk4vQ0haQy9MdWpkQnBTSDBpWkVQ?=
 =?utf-8?B?aHRrMi9iVUUrRk56NFYwMUJHLy85WTJBdW9QVG9zWnAzZmZmNHNhWE92eWdU?=
 =?utf-8?B?WkVGWlpJejBFUnF0U2NkUUhQaCtPL25vNVFWS3JNb1NKTFFrS0YvcUsvOGxX?=
 =?utf-8?B?OUVHNEIxMWR1M2RIa3hWMHE3Mjc1clNFd2dZSDlvZkVmcW5uVlppblZ5UGV3?=
 =?utf-8?B?cVIrMFpCMG56TUhUL1htL3pOWFVaV1U1OTJCWHluVVNoSjc4SEFqVzRCOEY4?=
 =?utf-8?B?a1lDQWYvaENFeUdRYWxZSmJmakVhbnVWZUVlTHZsSW52OVhTZFlBWUVKSWJV?=
 =?utf-8?B?ZjJya3RNa3BVM3hqMC91UDhKaEhnV0I5YmFkQmlnSERVdUxxdXM5aWp2SmVu?=
 =?utf-8?B?U2RXN0x6dzlLRmJIL0tyMVJ2L0IxVnd0b3A3QmRYcThQb3lRRGt2R2RuWkhq?=
 =?utf-8?B?NWxISEtpZWxWWHBmaTRUUzdUUXZhM1RnaStWNHRDb2Q4WDF3cnhEWVJKa3di?=
 =?utf-8?B?Y0JsS0ZhcFJZRlpJTTdwNXB6VjdhZDREbW9UcW1jVkV5aStIR21PcUZ6em1q?=
 =?utf-8?B?TmMvYlZ2VmhtYlJkcjIzVnloQVNROEFyc3dXb0xDL05JUTZjcE9xaXdySTZQ?=
 =?utf-8?B?R2M5TGFEd3BoakFuR29oQUV4bm9JZGdIblY1Y0hNTTFZYUdFNXd6amo3V2VU?=
 =?utf-8?B?VzgyOFdHQVNQUFQ3eXduRFNyZkM4cG9RUHluM2VSVjFmOTdEYXhINWFYZEs5?=
 =?utf-8?B?UmQ2cjRVVC9CZmEyRnRnNkpueWxxZ0dWczFraktCOWtBMW8xSDRuUHpRYzB6?=
 =?utf-8?B?MFZZRDNOTVk2aEVMVVhzUWd3NWNJQ25UZ3BlcWlPeTBqZVE2aW1Zd0txN25Q?=
 =?utf-8?B?UG81NEJYNitGSXNRY0NaQXcwNDRSK3ViZzIwSGhNdGxpOTV5V0ZrckZ6ZElE?=
 =?utf-8?B?WWZmTnlQeUpUaHFycUgvWldHVzV4YllabEhGQmZibXZwVVZDcEdkWXMycHMz?=
 =?utf-8?B?WXljZndNVjN6UmFtL2RxSnIvOGJLY0U3Z3RHb3pNWDZXY3VjR0R5bGpvcWEz?=
 =?utf-8?B?WWsxWDMzMVRpb1Ridmx4SW1Jb3grRXN0S1RscGd0aFBpbnVxYXJRNXdnVlZ1?=
 =?utf-8?B?eVRmZS8rRHc0ZkZoSi8zN0thaU1jdWFuaUNVN2NhQ1dZQlhnWnc1cGU3Wisv?=
 =?utf-8?B?Tys2SzA0b042Y09XNlpWSUFtZ0tUejhKUGVHQzAzZzV0ak1LS1BMQ1JmYVJN?=
 =?utf-8?B?K1R6cmMrRitydzJrcW53Q1NvZVF1YjJ4KzJTNk1ObkJ3eUMyMEMrR3pXYUd0?=
 =?utf-8?B?WmNLOEd5YmdRSndqUXEraWRVRzdodE94bUgyb0Z1b1J6a3liVzNWOCszamh5?=
 =?utf-8?B?dGxwandkUlNNME43bFoyVVgxc2hxd0NBR0R0STNJbHVKdjJTV2duSEhvUFJC?=
 =?utf-8?B?dnpMUjdINGcxY0FxNDYwVTNFS0Eyd0V5U3htSDFDS1NTZHJ4U0hlVlp4bzNP?=
 =?utf-8?B?SVNwUUx0cjdvbVdVUXQ5cFVnNy9qS21Sei9VVmpiTFdta3pMWGxvYm9oZFVY?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E81303D64E72D445A2A9C718A554E39E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9defda-307f-478e-320d-08dc658e99ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2024 01:17:11.7447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9sPVrct7XcGkyW56KemD9pXwgfa0Egw1wK8Aq5GC6LUIRH1onn9i+IBCwVF+dUeW0rXPNbv+IOudKEIC8wJPNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4633
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDA3OjMwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAyNSwgMjAyNCwgWGlhb3lhbyBMaSB3cm90ZToNCj4gPiBPbiA0
LzI0LzIwMjQgMTI6NTMgQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiBGaXgg
YSBnb29mIHdoZXJlIEtWTSBmYWlscyB0byByZS1pbml0aWFsaXplIHRoZSBzZXQgb2Ygc3VwcG9y
dGVkIFZNIHR5cGVzLA0KPiA+ID4gcmVzdWx0aW5nIGluIEtWTSBvdmVycmVwb3J0aW5nIHRoZSBz
ZXQgb2Ygc3VwcG9ydGVkIHR5cGVzIHdoZW4gYSB2ZW5kb3INCj4gPiA+IG1vZHVsZSBpcyByZWxv
YWRlZCB3aXRoIGluY29tcGF0aWJsZSBzZXR0aW5ncy4gIEUuZy4gdW5sb2FkIGt2bS1pbnRlbC5r
bywNCj4gPiA+IHJlbG9hZCB3aXRoIGVwdD0wLCBhbmQgS1ZNIHdpbGwgaW5jb3JyZWN0bHkgdHJl
YXQgU1dfUFJPVEVDVEVEX1ZNIGFzDQo+ID4gPiBzdXBwb3J0ZWQuDQo+ID4gDQo+ID4gSGFoLCB0
aGlzIHJlbWluZHMgbWUgb2YgdGhlIGJ1ZyBvZiBtc3JzX3RvX3NhdmVbXSBhbmQgZXRjLg0KPiA+
IA0KPiA+ICAgIDdhNWVlNmVkYjQyZSAoIktWTTogWDg2OiBGaXggaW5pdGlhbGl6YXRpb24gb2Yg
TVNSIGxpc3RzIikNCj4gDQo+IFllYWgsIGFuZCB3ZSBoYWQgdGhlIHNhbWUgYnVnIHdpdGggYWxs
b3dfc21hbGxlcl9tYXhwaHlhZGRyDQo+IA0KPiAgIDg4MjEzZGEyMzUxNCAoImt2bTogeDg2OiBk
aXNhYmxlIHRoZSBuYXJyb3cgZ3Vlc3QgbW9kdWxlIHBhcmFtZXRlciBvbiB1bmxvYWQiKQ0KPiAN
Cj4gSWYgdGhlIHNpZGUgZWZmZWN0cyBvZiBsaW5raW5nIGt2bS5rbyBpbnRvIGt2bS17YW1kLGlu
dGVsfS5rbyB3ZXJlbid0IHNvIHBhaW5mdWwNCj4gZm9yIHVzZXJzcGFjZSzCoA0KPiANCg0KRG8g
d2UgaGF2ZSBhbnkgcmVhbCBzaWRlIGVmZmVjdHMgZm9yIF91c2Vyc3BhY2VfIGhlcmU/DQoNCj4g
SSB3b3VsZCBtb3JlIHNlcmlvdXNseSBjb25zaWRlciBwdXJzdWluZyB0aGF0IGluIGFkdmFuY2Ug
b2YNCj4gbXVsdGktS1ZNWypdLiAgQmVjYXVzZSBoYXZpbmcgS1ZNIGJlIGZ1bGx5IHNlbGYtY29u
dGFpbmVkIGhhcyBzb21lICpyZWFsbHkqIG5pY2UNCj4gcHJvcGVydGllcywgZS5nLiBlbGltaW5h
dGVzIHRoaXMgZW50aXJlIGNsYXNzIG9mIGJ1Z3MsIGVsaW1pbmF0ZXMgYSBodWdlIHBpbGUgb2YN
Cj4gZXhwb3J0cywgZXRjLg0KPiANCj4gIDogPiBTaW5jZSB0aGUgc3ltYm9scyBpbiB0aGUgbmV3
IG1vZHVsZSBhcmUgaW52aXNpYmxlIG91dHNpZGUsIEkgcmVjb21tZW5kOg0KPiAgOiA+IG5ldyBr
dm1faW50ZWwua28gPSBrdm1faW50ZWwua28gKyBrdm0ua28NCj4gIDogPiBuZXcga3ZtX2FtZC5r
byA9IGt2bV9hbWQua28gKyBrdm0ua28NCj4gIDogDQo+ICA6IFllYWgsIFBhb2xvIGFsc28gc3Vn
Z2VzdGVkIHRoaXMgYXQgTFBDLg0KPiANCj4gWypdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2Fs
bC9aV1l0REdINXA0UnBHWUJ3QGdvb2dsZS5jb20NCj4gDQoNCisxLiAgVGhpcyBtYWtlcyBsaWZl
IGEgbG90IGVhc2llci4NCg0KDQo=

