Return-Path: <kvm+bounces-19071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20DAF900636
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 16:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 732C9B27192
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 14:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B156119EEA5;
	Fri,  7 Jun 2024 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e5/secsW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3B819645A
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717769598; cv=fail; b=lVEPxjGhGcojejYjuXbZ+aqOo38wllwCXCZ5/YOoBeixNNp+LlzYBbf8WBOkaLRS4+jSKT0AaT3ZA17mMnTqPwVoIkgQKNPCs5u1Rzh9bji7eSx8Dpnl3jYtRkDTKDO67WeV+hFJkiTF4KJY5ucSY9zXTTHt6UeYLce2Ndy6rdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717769598; c=relaxed/simple;
	bh=fl7uK668sVBifVpPytFUKy4rZkuvErEVp4kCAIfdK6M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ie0t9x1hQyJxNUbGCmL7F+vAaIe9Kv5Q/mRrYJmrEXzAyO1Sg2/sm6DEcCVPnqEZLwHMYOYyL7ax8F+FzgeIYGMsAGoasXFsob0p2If+IMZMdjkZFzjwszDV1ZOAPyG/7vk43m2USYI4Mad8smCYySkp7nYGxP565W+w5PW/1pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e5/secsW; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717769597; x=1749305597;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fl7uK668sVBifVpPytFUKy4rZkuvErEVp4kCAIfdK6M=;
  b=e5/secsWI1CbkQzr4e1Wuwb0z34B0hGMCL2kkM5DSRJwck/SknOMfMPz
   kLsqLOzXhlcR1fjpKHboec/etVN4J4iIqHG0CWdXxIzMxqvIRtkMyJ9HT
   sjx8ju2i2+zcIe0zvwtIMTahCfPX0RPo2FyJgL3Uby9pGJIsupvhIBnAV
   suAQ9Mr+flp1/fxdxWkgvXga06ke0M0afjDVYaDMpeFPGlr3Qglhbic1I
   bUC+/Ox3CqP17JXjurfekXFPGXt2uJ/FiCM/xFG5HRnMkdd66WFNkqiLV
   qkuH8b67QSuCEHyNziVS1/iHZQ8rLV650dXj8cvAB4NJaLOTpi7ThMaVM
   w==;
X-CSE-ConnectionGUID: iOOZj5SOSv27mRDMJqL1+w==
X-CSE-MsgGUID: 9qfOn6qaQtWT/41DeQOcfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="25065673"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="25065673"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 07:13:16 -0700
X-CSE-ConnectionGUID: 2UPnavYeRhOFB8CAt077gw==
X-CSE-MsgGUID: Vow1n8OiQnWd6clDYuT1DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="69498255"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 07:13:16 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 07:13:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 07:13:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 07:13:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hq86z7UakBdsVRbZrr6Dc5zK+vaL9Nv0BTgz7vNYIARk+tDqG/gys1QqhjtsXfoar1b7mru9agd1Eig4NdYkOjon/RHzrbImH/X5XwQYxaqN+u25C/bx5QHWWOT6K8L/8Yz87ZeVvt7T7SACKIRFetq5NxSxBBtivH1qZneC91r15ikx0CClzv7yAG8fwrwUNOBIPjrnQ6Br7PoIQJ3n4w7RoqmXj5yWj6yTtQtnTm94/f8x9cxfPusb0vEljujOLFVqow2RmbXzOUEA4VuBxNk2JIc9LQ1bHFUcDAskaV0QmXa6nmm8tGy5/tDqcWtpr21rDyn0xjXTfbhOR7otSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fl7uK668sVBifVpPytFUKy4rZkuvErEVp4kCAIfdK6M=;
 b=O18UIccdv4WNZ3xUiVt6xP6gNAXF9wJBd1bkFfK1zq9TrXzGuOzprzvV+gv0r8QVLkuNpH7d3GWfnVAfAUWdAhN1oSbUJP419F3TUfTqE84HaA6m568aPDHu2aFIqsDV1S0r+8JI43hAmmfxmaQBsmQJjk6Clt6k7oo069pkftsgj3GxS9dPkoiZZgJJoL6pcxXTQcvFvS0kepsfVRLST34h/9ifaNqziUlHFwX/jvGPqZSFFERZLK7EENDntAyr1ntYzECGwTN21h/EmMVw8QXDiGuGS/M9m6PXzZh0amQytQu1y2SN7Ng21LkzH+rsS3vjgBv+15hnDARAaXkZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH3PR11MB7204.namprd11.prod.outlook.com (2603:10b6:610:146::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Fri, 7 Jun
 2024 14:13:12 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::fcf6:46d6:f050:8a8c]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::fcf6:46d6:f050:8a8c%4]) with mapi id 15.20.7633.033; Fri, 7 Jun 2024
 14:13:12 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"eduardo@habkost.net" <eduardo@habkost.net>, "seanjc@google.com"
	<seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, H.Peter Anvin
	<hpa@zytor.com>
Subject: RE: [PATCH v3 4/6] target/i386: add support for VMX FRED controls
Thread-Topic: [PATCH v3 4/6] target/i386: add support for VMX FRED controls
Thread-Index: AQHat/AfUz1l3nwMX0S2Xkt8VZjKW7G8NbdA
Date: Fri, 7 Jun 2024 14:13:12 +0000
Message-ID: <SA1PR11MB67346CB6BD80A4A3CFB9E32BA8FB2@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231109072012.8078-1-xin3.li@intel.com>
 <20231109072012.8078-5-xin3.li@intel.com>
 <bc9560e2-39e6-4391-9fb8-b972f3605c80@redhat.com>
In-Reply-To: <bc9560e2-39e6-4391-9fb8-b972f3605c80@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH3PR11MB7204:EE_
x-ms-office365-filtering-correlation-id: 1cedad46-778b-4d86-e44c-08dc86fbf758
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Tmc4dHlrMkF0NXdnOTY3V29BWEVxdHoyMEpYSVZhVC9SdmVpMy82VzJBK0sz?=
 =?utf-8?B?L014NjB3Yjc5cDAxeFlPMHRDTjFzY0krVC83ckVPYjB1d1pFbHF4OTNPeUpk?=
 =?utf-8?B?ZWRCTzlZbkUxUGdSaEcyb0NwU21tZCtiamVLM1JucXFIYU1XcHJOWmNiTm1O?=
 =?utf-8?B?azJvQkNuMVA3RDczcTloOGR4THFMNUpuR3IvM3QwMjlrbmlpQ3djMWpkc0E2?=
 =?utf-8?B?WGk1Q2FXSGhMMmZDSEE5dXJ5WXY2Y0VzQ2hwbWUvdy9JRWdSdmY4OHpXZzNU?=
 =?utf-8?B?Qm1NdUE2N2ovNEFxOGZKY2xCdThWNkxnQkw2Nk1Hbk9kY1RvbzE3YTV5VVRh?=
 =?utf-8?B?d1QvbHNwYnAyVVlSTDVheFNBMDI1dk9oaGhhR2hmeGJTN2xFU1hGYnY4UlV1?=
 =?utf-8?B?RjRwZWNzb0dyeFBJY0VpRExhcEdzdkdsTXdmTFROS0V4V3BPSEtZcHVZUzli?=
 =?utf-8?B?M2MyUUV6bHd2L3VFM1V2ME41czJOZXFxYkMwaEI0Tzd6SjFncW44a2crSzZT?=
 =?utf-8?B?SExCZ2VHOG51WW1aT21jMzd5R3NoNjgrc2o4MzNYV2hJNitDaGdrRGxJZUgv?=
 =?utf-8?B?YmJ6MVk3RE85dDh2bDlEMGtnci9sRnErcnROdGNhMzQ3ajJ4WEVsRVdyQ3dU?=
 =?utf-8?B?RFA2Z1g5Tk5yclNXbkJBWWRlWHQyYTlPeStNNU5DRTVnUnVZd1BuMVZHeDBW?=
 =?utf-8?B?cmxQQTB0VSt6NWVoRCtCNlhyVVMvdEIybGJsWWMydlRMWDlhcDRBTXloc1J2?=
 =?utf-8?B?eW80OGMveEplWE04Mml5aFpMR3FDRmxHVzdXZHp1MVU0MTdzaldnd0w2MkJV?=
 =?utf-8?B?L3k3dUtaSnBEYWZSOGwrNndyQnkxbVFhMDlPd24rSm5Ic2tnUThQb2hBTCth?=
 =?utf-8?B?MFhBNGkrTjNvdXZVS2tORU9vT3Urby8zOEh5eE9UVyt6eVlodTlUeUI5T0FG?=
 =?utf-8?B?TzNvZjZnNzRDUTd2ZzJnZG84dEpRV09vc1g2NE42aDMvYzJiWThZUWt3LzI3?=
 =?utf-8?B?RzhEcWdLMjVzdENKSjlKcysyK0U2cmRXejNNM0xZclJaR21ZTHpWNzBZUys3?=
 =?utf-8?B?K2d4MXd5eml3WFJrTDdhRW9SOTU2am1GV2VNa0RmQTVWZVRvRnllN1dJcG01?=
 =?utf-8?B?UmlnNmNybUVMbVZoZ0hRRTNSM3hLdnFsMXNwRXl1U2lwOXBZSGxwQUY5KzFZ?=
 =?utf-8?B?Q0NmdVN0c2p2eWN5YnpNQ2luSlJFNnpaVWZFZmx1RW93eE45bCtmaS9kSml3?=
 =?utf-8?B?cXBrbW9Td0M0UFlxb2JIMGNIZVZySHlvbnhaS1oreWlMSEc1RFNqa1liYzBC?=
 =?utf-8?B?bEpVMXZtYTJDZUw2ZXFudERRVFcra2psSDVTNENHWjVSeHlYMUVOeWpaYTdu?=
 =?utf-8?B?RmRKditnaUI0T2crMW5yS05SKzA1Sm5FK21ubXFsRVA4YnRNVHNnVGZQdVJm?=
 =?utf-8?B?L01ETlQwcWxJcWtuZnZINEhmWWlwUEFaejcva2V0ekpveEhFakQ5encwbHJo?=
 =?utf-8?B?YThhYVhsdE15Z0d1Q3BKQ3lhcHp1cGs3b0tVS1MvdnMzZDJuODdtcU5jcXVn?=
 =?utf-8?B?WlpOekJrVEgxZ25OVjVFRzZQRFBNSlBWRVVDOW9IVTlKYmNPTmxjdTFVOElz?=
 =?utf-8?B?Vnp4U25heVJhWHg4UFJJRng5OHQrMENKa29ZL3FTcUVFTGVRVnlad3h6N1dW?=
 =?utf-8?B?Y2F3Tmk4Tk5qRnJrczhwczBQcUd1WmMyZWlqVEtKNU5tbWRlNFFrelE3OFdn?=
 =?utf-8?B?NXY0bUpkdENPK3lNRGZqZ0NqdUs4WnZZZ0EzZDJiR3NhNUFYVEhuMTlteVh0?=
 =?utf-8?Q?xDoFPKj1CxmKjkNErITmIzvEin8rqLPSs6VPw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGpBb2VNVTB3cGtzOWx6MHJVbEY1REVrUTkrbE9WNkFwVmpSR2Y4OWpHVjZi?=
 =?utf-8?B?aHNvSjhqK0FXRWN4YWJzNXF1akJqelV3L09hYnhueUlQU2hSK0hrdzI0MDh0?=
 =?utf-8?B?VGtrN1BGUWNmOW1CWXg1Q3NpejREU1MzV043SVpUbWZEeWdTWEVhOGlreFRB?=
 =?utf-8?B?TGo0aXRMeHVHajJWTTUvenR2R0hWbG5XTGoxRE1iVUpxcWlNNnBLVjlxQ3pI?=
 =?utf-8?B?d0gzOEtGc1FMRCsxSUZHV3Nvb1ZRdDBSK2c2VjNVbVIrTmlIMHVKNmdzUDlF?=
 =?utf-8?B?TVRNcFlJWG5YKzc5cmg3N043aHQyVGhnNVhJSkZ6bkZOVVBlUlZHOGszMmpD?=
 =?utf-8?B?bTBFbzlSaFo4SkJYMGJlVTg5YjdVT1QvUEk5SW0yM2RQRjNHT2R0WldyU0pw?=
 =?utf-8?B?NHErV093OFNDdWNFT2czbzBOK0tnYis5WDV0MmZOODcrU3MzckNDcWUzV2tY?=
 =?utf-8?B?TlRPSlpoNnFHbGNzc05VUDBGSm53SWR3YXlSVnN5N2ZKRXZPSjhIUjNqMGRX?=
 =?utf-8?B?RnI4b292ZjJyR1dEMW8zTG1XR24vWG1PZ1UwSFphREtEVkRtK1IvQWRSZkF1?=
 =?utf-8?B?YzJ0MzRKVFZsUTBBcHliRERSc3lCajBLVE93dVpzbzhCTXNtQmJEN01mMU5k?=
 =?utf-8?B?WWFRVzdieVJ5bG9YSHllajJ3RlZZYVBNeGZoT1VDZ0JzUEw4N1RnSExreWJO?=
 =?utf-8?B?aGU5UGhmVXJ3UEVNMGxXQVQ5cHVPcnRiY0FlbzkxcHp2N3MxSnNSdGo4bE9W?=
 =?utf-8?B?TmhacUxGQlI5ZjZpOUtIczQ2eHdoOVhFdE5idWdxb3hWTFdwTVhoVzkrY1Fi?=
 =?utf-8?B?N3lxZHIvUmRRWGZsTGRzMnRXUStqdkp0MDMrZ0lTZjVLK3EzZWkwNGIreGJt?=
 =?utf-8?B?YVNHR0F4elpHajgySU82MXFjMFBRTlhaVGdNRVNJYmh0Si9jYW4zbjJLbGNT?=
 =?utf-8?B?VThhZUVzMzBmazVzQ2dkMCtyZ003dWZNWXgyMEtOV0NROTFUZ2tqdzV0cU1F?=
 =?utf-8?B?WW96ZU11TEpFMTZkUmFQRjcwYis1dmZiUFZZTFNSNVFaRkt1dkpBT1FmWTRI?=
 =?utf-8?B?QnlPUTd3TGhpNEp0ZGxvSWMxNVRNQWV2cXpPeTdSc3RkeS9VdmNneXMwc2hx?=
 =?utf-8?B?VW9mR3lIcWlEZW1PV1BJZjVJUkhRL2pqZFFQQ3ZpMjYydEhtVmdOd3ZIU2NN?=
 =?utf-8?B?Qm5Zb0JUTGlTQUFjTUhJaWh2cEtwNzc3TzFxMWRjbXNhOEFMQ1dRbVBZRmZD?=
 =?utf-8?B?WE5JVjQ5NXROYXRySVhsMU1ueSsyZ0FjdTVDQXBQenMxVU9rWEpmRldBSnRO?=
 =?utf-8?B?QW0rMkl3SHdBNTBUdTFuYkpoVi8yc25zeC8wVnlyOEp2aVM4TlJiWWJkcTVj?=
 =?utf-8?B?cEQwbWxGTUo3MkM2TTFxekZXM2NzZ2hlSXl2bWkrWENaS3lDWmFpVGZja2dp?=
 =?utf-8?B?Y25BdG5Ddm5wdHdIS1JvSS9EemFtaU9EZHQ2TzJMOTlqYVNEeVhQZERKeVJ1?=
 =?utf-8?B?MHQvQndmbFJ5TkVmbVV0SzBKRUNFSkpGdWZ3aDdoTmJZZUQ1Y0lZWVFGeWxx?=
 =?utf-8?B?YXNEQTMvTFZTV0xjcitvUGtwZTZ1ejNwalZhOHpGTTN3QWhYbG1QS28wYy91?=
 =?utf-8?B?SkVxQ1VGYnV0VmlpU1NXR29Kb2U1UVNkZEphUUkzdXBzUEhlTVZmcWhZSkkx?=
 =?utf-8?B?STNrWXN3WXRvUHZwWGd5QXlNVkhic0FYTnlKelZOTWVUYnlqNjByNUNZck9n?=
 =?utf-8?B?b2NQTURnMlpHdWtpMzhOc041S2RxUWlabyt5bU01TUpkTjlXY1JaV1NrODNH?=
 =?utf-8?B?ZUpFVXk5Zm9mVlIrbDF2aXZrMDNsem50cXFxZ2lHV0V1d1RPK25vY0ZTWklp?=
 =?utf-8?B?MFhQdXZ2TnJPb3luSTBwK2Z4TWwwUzlwZ3pTVnpUVDBtakIrZ0h2VFp2aVlU?=
 =?utf-8?B?ZlFPUm5LOXc3ZmVXUTdVYkFIZzFKeXVYOTYxZEtVc2ZGYUpZVWZnVHVtNWp6?=
 =?utf-8?B?T2dySTdLS01adW1VOWZtOUJyaGpHeUdXQ2VlbHhtVGhYK0owVW1yTlVPNlRU?=
 =?utf-8?B?M1lQenFKYXFwdlpKV1MxeHgxb3plS3NyYnZUbmtyNjcrVzNNU2FNNGpUWVor?=
 =?utf-8?Q?X3ew=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cedad46-778b-4d86-e44c-08dc86fbf758
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 14:13:12.4109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AUb+ynCWRXDNW2b7C3RfJ5kfpzPzkJezOvETEXP+T0rRoSMgpjAyI1e9LSi3YmG0FPH8dbIsgiBM85ozkDrhzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7204
X-OriginatorOrg: intel.com

PiBUaGUgYml0cyBpbiB0aGUgc2Vjb25kYXJ5IHZtZXhpdCBjb250cm9scyBhcmUgbm90IHN1cHBv
cnRlZCwgYW5kIGluIGdlbmVyYWwgdGhlIHNhbWUNCj4gaXMgdHJ1ZSBmb3IgdGhlIHNlY29uZGFy
eSB2bWV4aXQgY2FzZS4gIEkgdGhpbmsgaXQncyBiZXR0ZXIgdG8gbm90IGluY2x1ZGUgdGhlIHZt
eC1lbnRyeS0NCj4gbG9hZC1mcmVkIGJpdCBlaXRoZXIsIGFuZCBvbmx5IGRvIHRoZSB2bXhjYXAg
Y2hhbmdlcy4NCg0KUmlnaHQsIHdlIGRvbid0IG5lZWQgaXQgYXQgYWxsLg0KDQo+IA0KPiBBbHNv
LCBpbiBwYXRjaCAxIHRoZXJlIHNob3VsZCBiZSBhIGRlcGVuZGVuY3kgZnJvbSBMTSB0byBGUkVE
Lg0KDQpNYWtlIHNlbnNlLg0KDQpJIHJlYWxseSBob3BlIHdlIGNhbiBzaW1wbGlmeSB0aGUgaHVu
ZHJlZHMsIGlmIG5vdCB0aG91c2FuZHMsIG9mIHg4NiBDUFUNCmZlYXR1cmVzIHdpdGgganVzdCBh
IGZldyBDUFUgZmVhdHVyZSBiYXNlbGluZXMuDQoNCj4gDQo+IEkgYXBwbGllZCB0aGVzZSBjaGFu
Z2VzIGFuZCBxdWV1ZWQgdGhlIHNlcmllcywgdGhhbmtzLg0KDQpBIGdyZWF0IG5ld3MgdG8gbWUh
DQoNClRoYW5rcyBhIGxvdCENCiAgICBYaW4NCg==

