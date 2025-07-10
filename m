Return-Path: <kvm+bounces-52063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA868B00F13
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 00:53:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16413586637
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 22:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D282BEC4A;
	Thu, 10 Jul 2025 22:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KmGFEr2h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FAD2874E9;
	Thu, 10 Jul 2025 22:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752188006; cv=fail; b=Lk5P+D89arHgu8ZqAC/3GhYzC8zyf8tMxwQH2sacgQgWoOMv+fIdk0sxJrGaFmMneY0XXm5/pDJi7CFOfdF8+VLqODc/YM2q4YhDJ7JSfdFuYuRWfeaoiKZ3Jhzam9mkaIM5sDlDi73LM3Q2xyC+kfSenv9n6Zqgt01wZNus8sA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752188006; c=relaxed/simple;
	bh=MTa4FH5199ZLgzfQNRn14RMk3x+vZfLBPrP6SgG7aEY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rfJqR+mJXdqL4BHb/h6eEGPOYNN/weG/J8S4B0i3c/Fig48zF9aXumRGQORgdUZVBmbrRXNBhTIhBIeKYoYuG8ycGxCK/bn8L+UQwgSsdh8zkRV3Mcj0SV62XuuqKgH5mmZlsP76g7LTFIjQip4emt/KdPXBq8WAWIr4DDaZiUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KmGFEr2h; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752188005; x=1783724005;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MTa4FH5199ZLgzfQNRn14RMk3x+vZfLBPrP6SgG7aEY=;
  b=KmGFEr2hakD/ikRq5+EiXLfxWUUxN8iOxO2dnpCXeX+dc5y0r3Wek6dQ
   eLR4qpPO5Vs+Erer6+2qWpp1cSAc5dA6EGfiSwHGTnNXPcc+th6EHWRXa
   Y8YAZZFF7CUxIt21IJlEcOa7rxYRLlKQQfJbY21YLyupRn2qB6hLaHo4Q
   m5bwWTjHNiHMt1PJI/t5JcKSEJKX2yCsxGUcE1O/qImLvdqBw7+Y2IrRQ
   OdKxFt3O0WoDGaAQqb5zIKC9Z6c05b8ovCPccV5f2olbbuEwpF7JyMZNR
   +hw5XVU25opSASZuPoh6QG4hMV4++0YCG68xgkCue91NN+gOBemy9dZSj
   w==;
X-CSE-ConnectionGUID: LS4L/f0/TCGErBybFeAESw==
X-CSE-MsgGUID: cTAVwx8hTKS8PlbVOBX0pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="65064139"
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="65064139"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 15:53:24 -0700
X-CSE-ConnectionGUID: gUJeplQ5Qaa7Gy160fKhLg==
X-CSE-MsgGUID: vC9aEN9ORVy9tFdey8/6uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="193424897"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 15:53:23 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 15:53:23 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 15:53:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.42)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 15:53:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ubQlMTvSR7oI9ZZpASlCKlQ6me1ihko+UmEjTZYJF7UFFaptRii9s/nbNi/Bd1sqEW0s+0OabLlUMJCmNPc/nPIBOflNuztwVWJ5Vt+3P1obTEvqJlouyp5HMECDl8g08bx7+D5qgQ29bqSHBVQp/bc1z0cf7hdcCfYk4vPFbQEpHN6MxIIJRQBQDDOZtP8XS96NE8NMGbeRlxCQvYCsjff2ONm5AwLNzMErJNVMDuhifqpAMhYmCny13SPixbNXrmNTPRA/SwkxcF6H8K7vRePt5QIBwLyxsOreNF4vnS0hvQxDMfVBY9exz5wC56XIeCZ/HV7FV9tHFPFbGqp+Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTa4FH5199ZLgzfQNRn14RMk3x+vZfLBPrP6SgG7aEY=;
 b=ZTk+hJFsRlKpC/Cn2pjbV6xTdMschJAQTfdk0wof9votcQbpWHcpUFOeb4SexjhXjeSoDZYYWJczubKXIpXccjmcPQb+nuI4o5F4/jaTez21TXQXqME5rXgbc3mDqNCwP8SRmz4jUujj891a1smhwcFWtFypsXENdOYNqHVgyAeHfwPMkM/rJxNazBoD/wsLbtaEDPWlTw908FB6MUEri2nwKad/fyH14468SCQYSKzrN5KPPbboAJDQ9EuQYyjMZ5B13bI1cRxfCWVR45W9N7pyFFfHqxaqVydh8vPifMnJSPjgUhI6SSXATbhDthkFxWPVyRdQa0xxSQRftVAOHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA0PR11MB4624.namprd11.prod.outlook.com (2603:10b6:806:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Thu, 10 Jul
 2025 22:53:07 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Thu, 10 Jul 2025
 22:53:07 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "nikunj@amd.com"
	<nikunj@amd.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
Thread-Topic: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
Thread-Index: AQHb8JJNsvqII3I3Gk2c0fgebVez6LQpd12AgABZx4CAAiiBAA==
Date: Thu, 10 Jul 2025 22:53:07 +0000
Message-ID: <78614df5fad7b1deb291501c9b6db7be81b0a157.camel@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
	 <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
	 <aG4ph7gNK4o3+04i@intel.com> <aG501qKTDjmcLEyV@google.com>
In-Reply-To: <aG501qKTDjmcLEyV@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA0PR11MB4624:EE_
x-ms-office365-filtering-correlation-id: e4ef0927-88a8-4155-b6eb-08ddc0048964
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NmcyNUtFOEFXQk1MZ1I4WTFkeWpVMTZtUzM0RHYvNEIxUlFZa2MvY0ZzZHNE?=
 =?utf-8?B?K1o4T1NXeVdiRU41TFdiMmptR3lBajVpTnNDTGRFaWJ3RXJaeUltRXkvdUxs?=
 =?utf-8?B?WjgrdUY2VVNRYTRIYmZLdkYyRXptWlJTS1JIM0dWck94ODNVcE5sSWhFcmZF?=
 =?utf-8?B?b1QzZ1UrUnVMeUdJYnZRUDZsR2hYSHlaWkd4dGdkOTQrQ2FqemxFdU94ZkFR?=
 =?utf-8?B?RTJHaWdXZWlPS1VXelNkeSt1STZXMnpFSkpJTjZ1T29scXNqVGZiRTAwQlBu?=
 =?utf-8?B?RFJhNHBXTFVYZG5rTHZidndvL01pREloYkJkN1Q3RDJVaDV4Z1p4R3BmYkw5?=
 =?utf-8?B?ZFpkMngrRjRDeG9ud0VTMEtjMTArUEJwRkNka2RieUExQzdCTnV1RmsvWGVX?=
 =?utf-8?B?c2xwMTA1R0RMSE9OeFJ3SjByM0k5dThaWUlkVW41NkJjYWJiL0NsZGdqbVgw?=
 =?utf-8?B?dENLZnIyV05JYldkSG5OeWNyTDJ5LzViR1hnd3J5a0ZNSUx1RmVHMWlCTTYz?=
 =?utf-8?B?SnNKSWtTTS9EQkJLMk9lbkVrSVg2NEdDYWhLVVVZWFJ3MmI3RDVqU1UzY1Z5?=
 =?utf-8?B?SWhZU2prUGgxUTBUWFNSLzdRSmVhdEIxbzkwaVdFaEtCRXVrbmNpT0Qycldt?=
 =?utf-8?B?VHBDV3RNckRSUkJRaCtiOWdGZk42ODdNWEZacktkNmRVZkJyUkZPck9DWGZT?=
 =?utf-8?B?S0d4RmJkZ3VRaWRzd29Gam1YTWVwZm92dnVPTTFaUTliTDVrWkV2cXNqbG01?=
 =?utf-8?B?MTNmSWNQYlVGYnMxSjVCK2ZEaU4xQ3I2QlNnWWkrdmlWOFhSbFdEeklIck81?=
 =?utf-8?B?VVlsTTZwcmpDek1CS3RHYitKUWJJV1Y4TDUzeUhjYWZzYmpRSEs3NHFoUjlE?=
 =?utf-8?B?TWFkazlqQjM2b1F4NVZwSTVaYWlxbzF6ZHlXbFNzRCtRaTNuM0JJVWxsV3dh?=
 =?utf-8?B?MWRUVEJzc0RicklHZ2RWZWcxYisvb2dLYzZrVFpSR0RxMVFiRjg3R3Z5MjZF?=
 =?utf-8?B?MkZJVXRZQWlXWDBJWDhESVpleTZ3QTRkQnVvSGg1Yi9kWXN0bVpKN2gyUzVj?=
 =?utf-8?B?eUdEVEJUMkFVbWFyVFh3YlJsU1hLS0pRNDFhaCs2Z1g2OC8rOTRYbldpOC8y?=
 =?utf-8?B?QWNmZUF5azA2ZlBUNGg1blh0VndjeHQ4ZkRUSzJoYTRoNWJ0Y1NQcW5ob3BV?=
 =?utf-8?B?N29YRlVpSHUzMVk3NlhFVUxWWlNEZkc3RUhJNkpGanp5a1I3K0tRMW54VDRY?=
 =?utf-8?B?SDljdFBEai81L1puVzhDUk0zWWdzTmRMRmRNWDNCMTdRNHI5TTI2dmNSeU4w?=
 =?utf-8?B?TitTQUhrTHlIRWlNdHpwaHZxWkFla2hYQUhLeTMyVWJaVUZabEZwUzlRUVlr?=
 =?utf-8?B?YXFVcWJPNExYRVJlVjlQbXNoVFpIRFFCT0Z2TXFQT2d0c3FrcXg1ZUo2RlAr?=
 =?utf-8?B?dXZUM29SVHVVL1dteXcxVURhSnIyc0xaYkZSNll2ZUt5eGd4REErcnJZb01o?=
 =?utf-8?B?elpEVHN3VFF3SXhXT2xUZTIzZE8wQkJydStGMURadzhlZStMVjBNKytCUEZZ?=
 =?utf-8?B?VXVsUlQyL3VPRjR5Q3k4UGxVVHBYaytjK0xQem5vRTIrM0FJS2FGc2ExNytv?=
 =?utf-8?B?WmRRRE9XRlBHOXR0aW5ySVNVc2o3OUFycHhqaDlUazFFR1EyWkhUclNaSnBr?=
 =?utf-8?B?c0ZqclZ0dHZHenBMVVBRdDg1QTFZNTFSMnV0ZEczbjU2bXBoQTUxVXplNngr?=
 =?utf-8?B?aTljTGM3d1EyVkRtU09FTFBEM0h5VDVZVG5XK2hQZzlCNU1iT3VTeXo0WVEv?=
 =?utf-8?B?OVB3eHEvQlYyU2pxeUI2NWhnWXp5UFR4ak5xcGdwb1E0VC9kTU9BMjdQSjZ3?=
 =?utf-8?B?KzhIeGFRSExWc2k2QVgxMUcrMEZUU3lNdzZFTFl1Y0MzZFQyckNGOHBIZ0V5?=
 =?utf-8?B?T29UczlRV2VHVWVITk1WTUw5d245N0kzTllVcmFxSmdweW1TVFByY3lJWUtw?=
 =?utf-8?Q?CsB0rK+hqnUx56g8sxi5Tr3ISbT8wM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDJKZWRzNkFNc2Q5MTFlREVnOFJBYnVwVHNvUVp1cGhHWi85WC9jZzZsUzhi?=
 =?utf-8?B?MkdsaUlGZ3M5RjdtN0NxbW55TWNIOGRLWnNHY0VIeGZONS9jOExLWEg5RUlj?=
 =?utf-8?B?VXVMYnl5ME42ckhVbzFGZ20rdUMvS2d4QzlXOTRpUUJPU2FRTE5LOHc0bG1P?=
 =?utf-8?B?dnRESzh2SXFYbEhGa3NrbEltZFhLVVhjWEZOUXI5endETWlrSTEwN05FNXJB?=
 =?utf-8?B?NFJ3L1IvUkV5Q29IYTAwRW1hSlBRM1dPRmp4OFI2cXRTRDl1dEl4UHZSbzhW?=
 =?utf-8?B?bzhQU0xQZm1IdkNodzE0Q2JOMXppWXFDbDgvZDloOUJrTDFSTS9Lb3N0WVR3?=
 =?utf-8?B?VUowa3NENml6emk5R0hoMFdzR3BVWVpvb3Y2L25QSGlPNHdxRmNyMGtvdmgr?=
 =?utf-8?B?TzNHTmZSR3lFaUxlRElYQUJMQmdWOFFwUXdsT1V0RFB1RWlTWUJLbU5WelRp?=
 =?utf-8?B?UGhRUDdRWGsyQXMzc0RkamJhYW1vRWhZZk1yZlFwYkEzNGdQWVhjKzlmTWZY?=
 =?utf-8?B?STVwUzdEc1I2TlBvZ0k2MVdjdjBKcStXcXBjMGdEczJLRE1TTU1ROERQTW01?=
 =?utf-8?B?eHFkQmRKdEJmUWtkcm1KbDUyYXFKb3hqZHJFeTJvcU9GcUtINnlMUzJEM1g3?=
 =?utf-8?B?WjE4UjZid1U1cGxRaVNKcGFIWDNZcEp5S2hvTHRYNG1pMUZEUGZBNWFHZHdN?=
 =?utf-8?B?NjJ3UDFDanZDRklqYlVPYUZXTkhaemlHSm4veDExbTZHbmwwa2p5ZWhuWGEw?=
 =?utf-8?B?eWxuOXRhUERadGdUdUdMM1lQanN2UUdvNmphV2g1cTQ0bWZuTDdnbmRhWDNG?=
 =?utf-8?B?YjVHMXFXenltaUxBRTNjbkM0REc2Y1JjeFVoelNHbTJ1Y3RmYmRJWGJlN3dn?=
 =?utf-8?B?SkRrWnRkOFFxL2ZlMVVTZmtyNGdjanUxUWNDOENYazZUR1Y2ZGpWMVB3TEpu?=
 =?utf-8?B?bUFUNW9uNTJOR0UrbW1IaWp2UTAvUTE2WDJJZFhzZlBQVTEvZmMzL01jWE5Q?=
 =?utf-8?B?eFRIR3RHeEROaEpoRm5tS2FwaVdZcW5saUQ5bTNValpBeUpnUm94OEdKTFBo?=
 =?utf-8?B?MmtSL0paYmZaVzJGWXQvdjMyeWdTcE5nYS9zcEkyY0VhMVAyZHJxWlN3NFE2?=
 =?utf-8?B?R0tESStIWGpWaEJEa0l4Y3UwZy9FNTUrMlRlWFF4ZTNsd1RsYS91dC9wU3VO?=
 =?utf-8?B?bUhtSGw3ZFZzbzRCd3hocWR5T2lCN2pkWjZxUTEyTXY1T0lkM2VSOG5Vc1Z3?=
 =?utf-8?B?VWtYUnZoRXNLaWI4aHJNaktwSmcwRG5VSHA3ajZKTTllTXFqNW1PVHJvMVds?=
 =?utf-8?B?c2U3WTdMWU5VZzZQaFpuOXY0eUFpOVY2Z3NncVJ5NnlhZXE4a0ZhOVpqdlFl?=
 =?utf-8?B?YWI3YjhrTWVOdFMvKzNHY1VPQWFQQllSNUdkMEVYQ3oxbkxsMHIyOE9rNHpv?=
 =?utf-8?B?WTF6OVBsYTZUTTBEanBCZUhFQnQwenlrNEhGZlZBN1hUckN4dWx5bjVqUEw0?=
 =?utf-8?B?ZGdiUDEySUpPR2RiSDZHdmJMdnJFT25veXZSUU9CWTZWMW5tc2xIeVhCb0Jv?=
 =?utf-8?B?ZFptRHdjRFBFUWN5cWJna25BTFZFclhrY3BKRU1ETDhpazdMMVlFdXprRkpS?=
 =?utf-8?B?M3JTaWprWlFTejk2RHFrZU85bUVQeitScjVyQlhxdkRFbHVkeHhwUU1MV0Mw?=
 =?utf-8?B?U00rQXlqSVhCbFl3S3pHV2Z3c0FwVHZhcWtoTEV4UGRHR2VFYXVwYkdLb1dX?=
 =?utf-8?B?ODkrTllJY255V3NuMHIvNDJuZjRZazdMRENHVDBnY28vbE1lRGlFZlR4dmo4?=
 =?utf-8?B?dGpRMVNjSHA3NXdYbkcwSmhHaUI4UzQxdEt0bWRzdDJoTWRSaUQzMjJMSy9H?=
 =?utf-8?B?cDdZeElvQlJhdTZla0lyS2dQdmEzdVVLaHc5c2EyNWpIVUtrRnppUXVoaEJW?=
 =?utf-8?B?eHJhaVV3cncwZ3BENCs4SFcxUmZpdEEyRTc4Wm5QMHQwU0xvaDcyd01sdzZP?=
 =?utf-8?B?K3BZQ2cvZHY0S05GajJRYkFyK1JhcFNEem9xV0FMR29IOWNQemxCTHdnNm13?=
 =?utf-8?B?MU1MVERnUnRXUGkxRUFISTQzTC9DTDc4bEtFeFFrSnRPUXBjYUdVbnlyRzhq?=
 =?utf-8?Q?suI2aa0QFUY+NzRTwnM9cOGJR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B458D4E2712CD141933FA5678C628C2F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ef0927-88a8-4155-b6eb-08ddc0048964
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2025 22:53:07.3858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hUCQZsEoROnVyCCiHvVnZjNetVdqkfwK+c0/IIozg7T41ukbkVdd+XaUCuK3K2rEnvIUYnAtx+Ggp7HeSCHe8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4624
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTA5IGF0IDA2OjU1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEp1bCAwOSwgMjAyNSwgQ2hhbyBHYW8gd3JvdGU6DQo+ID4gT24gV2Vk
LCBKdWwgMDksIDIwMjUgYXQgMDU6Mzg6MDBQTSArMTIwMCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+
ID4gUmVqZWN0IHRoZSBLVk1fU0VUX1RTQ19LSFogVk0gaW9jdGwgd2hlbiB0aGVyZSdzIHZDUFUg
aGFzIGFscmVhZHkgYmVlbg0KPiA+ID4gY3JlYXRlZC4NCj4gPiA+IA0KPiA+ID4gVGhlIFZNIHNj
b3BlIEtWTV9TRVRfVFNDX0tIWiBpb2N0bCBpcyB1c2VkIHRvIHNldCB1cCB0aGUgZGVmYXVsdCBU
U0MNCj4gPiA+IGZyZXF1ZW5jeSB0aGF0IGFsbCBzdWJzZXF1ZW50IGNyZWF0ZWQgdkNQVXMgdXNl
LiAgSXQgaXMgb25seSBpbnRlbmRlZCB0bw0KPiA+ID4gYmUgY2FsbGVkIGJlZm9yZSBhbnkgdkNQ
VSBpcyBjcmVhdGVkLiAgQWxsb3dpbmcgaXQgdG8gYmUgY2FsbGVkIGFmdGVyDQo+ID4gPiB0aGF0
IG9ubHkgcmVzdWx0cyBpbiBjb25mdXNpb24gYnV0IG5vdGhpbmcgZ29vZC4NCj4gPiA+IA0KPiA+
ID4gTm90ZSB0aGlzIGlzIGFuIEFCSSBjaGFuZ2UuICBCdXQgY3VycmVudGx5IGluIFFlbXUgKHRo
ZSBkZSBmYWN0bw0KPiA+ID4gdXNlcnNwYWNlIFZNTSkgb25seSBURFggdXNlcyB0aGlzIFZNIGlv
Y3RsLCBhbmQgaXQgaXMgb25seSBjYWxsZWQgb25jZQ0KPiA+ID4gYmVmb3JlIGNyZWF0aW5nIGFu
eSB2Q1BVLCB0aGVyZWZvcmUgdGhlIHJpc2sgb2YgYnJlYWtpbmcgdXNlcnNwYWNlIGlzDQo+ID4g
PiBwcmV0dHkgbG93Lg0KPiA+ID4gDQo+ID4gPiBTdWdnZXN0ZWQtYnk6IFNlYW4gQ2hyaXN0b3Bo
ZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogS2FpIEh1YW5n
IDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiBhcmNoL3g4Ni9rdm0veDg2
LmMgfCA0ICsrKysNCj4gPiA+IDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4gPiA+
IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94
ODYuYw0KPiA+ID4gaW5kZXggNjk5Y2E1ZTc0YmJhLi5lNWU1NWQ1NDk0NjggMTAwNjQ0DQo+ID4g
PiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiA+ICsrKyBiL2FyY2gveDg2L2t2bS94ODYu
Yw0KPiA+ID4gQEAgLTcxOTQsNiArNzE5NCwxMCBAQCBpbnQga3ZtX2FyY2hfdm1faW9jdGwoc3Ry
dWN0IGZpbGUgKmZpbHAsIHVuc2lnbmVkIGludCBpb2N0bCwgdW5zaWduZWQgbG9uZyBhcmcpDQo+
ID4gPiAJCXUzMiB1c2VyX3RzY19raHo7DQo+ID4gPiANCj4gPiA+IAkJciA9IC1FSU5WQUw7DQo+
ID4gPiArDQo+ID4gPiArCQlpZiAoa3ZtLT5jcmVhdGVkX3ZjcHVzKQ0KPiA+ID4gKwkJCWdvdG8g
b3V0Ow0KPiA+ID4gKw0KPiA+IA0KPiA+IHNob3VsZG4ndCBrdm0tPmxvY2sgYmUgaGVsZD8NCj4g
DQo+IFllcC4NCg0KTXkgYmFkLiAgSSdsbCBmaXh1cCBhbmQgc2VuZCBvdXQgdjIgc29vbiwgIHRv
Z2V0aGVyIHdpdGggdGhlIGRvYyB1cGRhdGUuDQo=

