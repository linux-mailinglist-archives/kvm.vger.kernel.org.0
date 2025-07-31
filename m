Return-Path: <kvm+bounces-53807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC30BB17791
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 23:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D933154099B
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 21:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9C52222B2;
	Thu, 31 Jul 2025 21:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dYHlqndt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7018E11CA0;
	Thu, 31 Jul 2025 21:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753995744; cv=fail; b=pvxSAp9r+cbIJO5PjAEyb8qdOol3FW1iFhy/WZemYlXfw/LWSW8QN0MxIkEc1bCdUlKATWq1zzR2GaRpm59QoE4iWYPJ1kJjUWRHdPCiSH/HiDNZLNiOuiCbXR8b4wu/rUhGw5Ej9J7p2tapGlbuKS6nh/yhiGUAVmnznKgM8R4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753995744; c=relaxed/simple;
	bh=CSz9EUzHgsjrU2A3HZAg9PnN+hGCG+675oOqGh5SCSI=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=SwovxoaVV034klJtaXBng6isPPXbCcCEjwuTAVdba2h3rkbw6lMZc6aHuwUzzDHDlEb7lmDMBHx8LMD6A61VFhZhIQgWr1ff9/Ocyr3ir0wFCJJ2JN71XU0auPlLw1D7996FWa2erU4BHIEW0EIxJDKRJHPW8O0kwny7edK26QE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dYHlqndt; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753995743; x=1785531743;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=CSz9EUzHgsjrU2A3HZAg9PnN+hGCG+675oOqGh5SCSI=;
  b=dYHlqndtIuXq4EfDxizAF4SRhyLxHl1uQEmCOk5+uE9I9dW7RKG4W/qY
   cD0niFYbimb6w/ch+dK1u1kwBoI4VRzvIFO2w2i0/ZJZp8qQOpN8W3FfG
   d8mJ6dA8AqZtSExNX67fB1mpY5OY83C3tbegf1A2LQqhXplp8m5m1Obt3
   gJLyD3dwmwFfKxpKNLH4OmYeqOZ5fk59eMuFRdYV1uNgt8z30ICO/QGes
   8IXCvOpcqxnAGdy1XIXzZbp1UG7CAn9NUgA7iaHvgAaiocQX6Rn7poBam
   TjkgUFVOS+OZ0k1iaoAIXJ9MAxZW1oIjgrnTT3w62wI5XBzkb8Va9f/vE
   Q==;
X-CSE-ConnectionGUID: lJ40bz3EQd+e/IE+AXWx3A==
X-CSE-MsgGUID: 9qRvv0LnSZqM6eWbAmKDyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="67028784"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="67028784"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 14:02:22 -0700
X-CSE-ConnectionGUID: HP/bdIgpTbSfhMQLHu0dUw==
X-CSE-MsgGUID: OrkP2lhFT4auDtTgo0CvJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163710842"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 14:02:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 14:02:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 14:02:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.72) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 14:02:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sY+rwHXWKTLB6peJJNK9Gjb9enSsl1vAdT4DDsXe9qmgUOGyFeZp6RGZMO5WTky1PSfOPLC4T9CTNa3inaQbxsYGRZnedBB6yW9sn53WURlXjguA8siZGAl/vze5PSW6zCxtfM1ce7nmu5j0YL1jDy1nLVD6xH/SiEr114R/VcEXpqkj8R8Ueh73dxwHz/dpwVeyhDbg/Rfa3l9Wz7u55OKyQxVnZCwgKuL8VoUvb1sg3tCYaCJO+yHLD5+rz45ZGinJbFCQB+IdHW5X3y05N5DHGUSSE3+tNb+J7yt12eoIXvCSHAYO+dYtd7k/Lcq+LpOmTSuEOfHERMr8bL63xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xArEnMj7tMuAuyukJPRwx+HkiRHx33M10zcxc89keM4=;
 b=PRhdpz40GxlKhxFy+aClNpESd2Zz0XXpUVucSWHex0BVjKjtbf/wctRzxCombUiJWL7qG/etaALxhHFl8pFUdcQJBvnu0v6pGAIjE3zBKRgTS5vX/A2EDp6vUQECE9SDgL14l2cw8zgcTqh+PMAFd962AVAvzpA9OPsCN7Ia5PTC75Za6zZumzEVqFd7lHUpTbh/xE9Xk6Gan5PUiLaXnAE+HUp91luIOyYIcYEuCAyc1+LlLkCRM/IcGFb2nlr7op9S8oosB9Ju1j5ahhCbwmCiLZM7Sn0/y4m6TRsFgmHSpt+9+yybFxso3By2jcsP5hs0gFFuNqjXEoqloeIL8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW4PR11MB6984.namprd11.prod.outlook.com (2603:10b6:303:22e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 21:01:24 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8989.010; Thu, 31 Jul 2025
 21:01:23 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 31 Jul 2025 14:01:21 -0700
To: Xu Yilun <yilun.xu@linux.intel.com>, Chao Gao <chao.gao@intel.com>
CC: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<kirill.shutemov@intel.com>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Farrah Chen <farrah.chen@intel.com>, "Kirill A.
 Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Message-ID: <688bd9a164334_48e5100f1@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-8-chao.gao@intel.com>
 <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
Subject: Re: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via
 sysfs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW4PR11MB6984:EE_
X-MS-Office365-Filtering-Correlation-Id: b1a0cca0-1e0f-491c-5a39-08ddd075681c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MVFZZGJMam52K2dqd1NSUG05MTNmODFpeU1abVBCUnRONjFOWFZsdWdXR204?=
 =?utf-8?B?SmRBK3ZvbEZ1YVFGZ29ndU1CaThXOG1BSUJycWQyR1ZLdW1ETWZFMnJsaHE1?=
 =?utf-8?B?bnJEUGdLZXk0SjBnTmZQaGxxYlVGclRwYm1GVkRUZEJnRUZ0Y0xyZU1hbDdX?=
 =?utf-8?B?cXRuT1FvMUFMZ1hnZ2J0WkxYRFlxMVo0M2Vvd1JpVnFManVwbWt5ckdJYm00?=
 =?utf-8?B?N1VHSGRqL2RqRzNjK285MlVDN2M5NHdONDhOcFBtMXlnbEN0YjRaemswbDlK?=
 =?utf-8?B?ZW1STUwvREtiWVA2L3dodVF2ZCtQbHBGczN2OUNFYTcrd0NJQTJFZGg2RHk1?=
 =?utf-8?B?eHJJQ0RBRVMzNDJsM3dJK0I0OC9ibHZXQUpQdDV6WDhzdElyZnpqTFZ6MEI5?=
 =?utf-8?B?MU41ejhYNWhQVmN0N0s4US9waEdjblVGcXF1dzlqc1BReE1Ic0dLUHY5SEov?=
 =?utf-8?B?U2tuUjQzdXJlU2s3WEdzcURnWnljM0lWOE1GcEhyYkcvRVpIdlRPZ08wVElT?=
 =?utf-8?B?bDZhaVQ0T2pubDdqM3RDN0FGVm9nRHVxbkhlWGp0bTl3eWtjREZDcDlxcmh6?=
 =?utf-8?B?ellnQmUwK3BLYUpOdWRvMzNoaU8rOEZHcG9YSUg0aEsxeXQ5QVZVZk1aVkc1?=
 =?utf-8?B?TDI3NkJYdXd4UTFKcGQ3Yk1HRjB2ci8rTHA2ZmRWQUtMYWg3bkhMcnhLZElC?=
 =?utf-8?B?aVdYQXpEZkJuenZxeXI3WXo2VFA1ZmhyeHN3WEg3aWhpOEx4Y290RVFyTFdR?=
 =?utf-8?B?YmtQd29pSy9mZU1sOEJEd2RSMEU0UE14ZUI1OUFja1NVVEdMaFU4NStoeFFC?=
 =?utf-8?B?SHRzRHg3UkZzRVlwSGk0eE9VR0E4WktKZCs4TjZxeWMrOFFnVFkxU2N2dWdx?=
 =?utf-8?B?bldza3I0em5aVkU0MGpibGtFSnU0aUMrOHN1b25WTEtmZldXU2x3L1hUVmNY?=
 =?utf-8?B?dU0vM1lsTjMzWEZWejFUa3RMSk1ucmRYUU5qQUwwcXRtdFZtaTdFd2crc1Fp?=
 =?utf-8?B?TDdpY0tsUkJ1L2YrR3pwRkxxN3c4dklDZzZZdlBKS281cGx5cEFxeEtRQTV4?=
 =?utf-8?B?cXViOGU4RWQ3bGM1bnNkUXVsMjFFZURSMU9xYTQwQld0UmNITUtEN3NzYkFR?=
 =?utf-8?B?QTU2ZTJObUZyZnpRUVVOWlp4VXFoM2wvS0hIMTNUWktGdGlaTW1vNE9TVGV6?=
 =?utf-8?B?TndzQ3EvR3ZMRVVIRjBLWE43aWlMQ2tQa2xHbWdaZmVnYm9wOFJSaXV4RC83?=
 =?utf-8?B?ck14SWFkMW9ISzhnTGd6b3FyZi9ZbmdKMUZhR3hBUDJTZlVpKzFQTEZrU1Nk?=
 =?utf-8?B?eDJVSGlhamhPOTVqTTlNWEptU0ZXSGRmWmFqRm96azd3c2dVYmVkMkFST1Zw?=
 =?utf-8?B?eTRsU3NKdFVRMDE4TGFJckdDdHltUTA2SlI1QWtVbVh4YjF5Y1ZYOHVnaWw2?=
 =?utf-8?B?ZEI0SU5VM01vSlplQkN3cW5zWTRCc1BCaWJhQk4xTE5SbU8wZVU1WUJiSlhU?=
 =?utf-8?B?WVdYYW0zMGFrSDRyS08yMjBodUdVb0M5eVpSUStEc0YrRU5yS2hjTDhXMlRP?=
 =?utf-8?B?TXhPclBjSGxEZjRVY1RhNlJVd0VpRHBwWWxPRlRGK3h2MXBWZDdOdGZTTGh4?=
 =?utf-8?B?dkErMVk5Yy9ZSkNHdUh0eEFpLzZCdjl6YzkrYmNhZk4zZWxZeld6NG1rSlhm?=
 =?utf-8?B?cHV4RjlTbHNaQTdHdDRjblloVCtzVWdXbzJpTG9ubG41a25XTnhyN3RGaDNm?=
 =?utf-8?B?N2FJMDVjMTdkelovZEYrZWJNdUJ0WkV3Zi8zQ2RkMmJmZzd5VVJTREEyQkdG?=
 =?utf-8?B?TlV3VU5FYW5GMGZYQk13bHM4OXZKaTREQ2lpaHliTUJCTkowMUVhL0Frc0Jw?=
 =?utf-8?B?TCs4STBYTU01QklBdTBQTGx2emJlS3FuS2FlWStFTHBhMVVRVUI2VExoMDZ5?=
 =?utf-8?Q?dr3XmJoi4zE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1pYaXc2ZEozSHNJK05uZ3VaRWpCaERZRDZGeHdVNGMrQXhXcHR3NlBocDRt?=
 =?utf-8?B?U0FlZS9yWFNZTEhIZDB6anZyMzdCSU1lZ1JQMWxsdkk5ejVGNDlZdm9ES2hG?=
 =?utf-8?B?V1RRd1lBZi9FZ3dTQkJIaDFoa3lVUHNIdGRWekVKbWtVazVzekZvSlJvUnZX?=
 =?utf-8?B?YWt0a3pJSlRkbVFsV3dRd0FsYkYyM0gvUzZ4RUJ5RXFkMDlCMExyL1ljcHNa?=
 =?utf-8?B?SmNzZWlueVh5VFRQZ2ViclRhUU5BR3RTZUZVRE1XcmJxUFdqaC9qc3VsSmFB?=
 =?utf-8?B?T3ZaNVdpMElQelg4eW44aG9rbWpzRUxRYU5oOFg4QXdXOEZpaVJUdVdiTGJq?=
 =?utf-8?B?RUJlR0hHSGRFeGU4NU8xZWlmQjkyR2ZZTzU2eXQxMnErR2Q2NGlDdFNUdHRR?=
 =?utf-8?B?V3B3enJCMjBYOXZhdWlSMWMzOGNJZmZYN0ZORnZBeTV3RTZQdG9iRisrRC8z?=
 =?utf-8?B?Zzd1Wlh2dTNtNUVweTc5SFNYR0JZZEZlbmNISGJYZm9tZUloSWpNUnlYM0sz?=
 =?utf-8?B?M2Zjc1RLckJhSzR5TVZwTGJ6SUVLUDZmRkdzNUJHRkxTemNFYi9XMmtPdURw?=
 =?utf-8?B?MDByVE9uMlp2TnJMWTdsQWc1K3hqYUNZNjlnZ3B4cXM1d1Q4NDhqRDBMTTdG?=
 =?utf-8?B?WUFKaEc3ZXVnL25WY2duelcrREp5RVJXYjY2K1FMRzAzUytPRy9PcVZMTUVr?=
 =?utf-8?B?eDJDY1BUSGM5emltWUVlUmVRL3BxMVczMU1NdWRoTXJYV1RNczVVbTNPOUR1?=
 =?utf-8?B?R1EybXhNWWZGOUp2MXlVVEdEYjFvcGlXM05BNTREcjZOeHpaeDRTaTVmTEhN?=
 =?utf-8?B?VXE0Ky9NbHdVUndrNVFnejJ5elo4MzV6cE94Z3VVTUtNUFV6L01hY05yL0ZZ?=
 =?utf-8?B?OVBLdlB4UkpMVUJPZ0hIQzRXdExBK0FNMThwVmgrbGVQSWZPaFZiWDM5R0pm?=
 =?utf-8?B?UWhmMy91TUpjSm1YYUdZZG4xL01DN1R0Y0xMVHNCYUNRV2FBakJaL20vbkMv?=
 =?utf-8?B?ZWFkQ25WaWJSeXowT3hEUW1hTVF4NUdPZjVCdHNxUmxDakIwMTllSW1TSDdB?=
 =?utf-8?B?S0ovZ1RDSGlra050b0x2YUp6SURZREVWS2FBc0tXZ3g2NnhvN2dpeWtTNHJU?=
 =?utf-8?B?VU05Nk9uRkZpWHFGMC9wRXhzc0s2WEsyb0JZR2NVUU05ZXV5MDBDcGI2dkJm?=
 =?utf-8?B?MUVmUkpLTDVsNGFLMks1MmxETnl6ZTFzbitJTW1NVi9BcWY3bEhLUERHK0Zs?=
 =?utf-8?B?Q2RaK2JweVVaOWdDcXphNjNQV0t6aFlzUFJqVTA4eUFrTWdaeVdNTkx0c3BD?=
 =?utf-8?B?WkFRRVEyRmFValdIWkErSWdycGptbE5lRGVhWHNvUVRIWDJyQnlSL2dQZjIw?=
 =?utf-8?B?RGlPczZlS0ptc1F5TG1yeVFqNEpLcDZaYTRxWkRIN3U1bFNLcGFBYUo0Y2FN?=
 =?utf-8?B?cWhpOXFlNWoyTDlva0pva3VFUkVMSHBkcnlyd3g3ZWE3RzNEVjNtZ3RXdXpD?=
 =?utf-8?B?T2dIL0phL0lScUF4eTE1cTRJR1dHUnlPVkFZY1ROWW1PYjRlMGdZTFUvU0Rr?=
 =?utf-8?B?SkdUeDBOVDQvQU96L2hjZTdoallZZTNhR3ZJNnhXblF0REFROXZZRk1qdzF3?=
 =?utf-8?B?eE5GbGg0STZrdVA2N3dlVUJKZ0hYa1ExTEhvRUJuVlRrSzJRaXZPajhhS09r?=
 =?utf-8?B?TmYyK21uNkhObGpNSXprcmJ3RmVJWjBEcFNPenEyUnRtcDlPTVBCNkVrcmxU?=
 =?utf-8?B?YXJGejlPQWNoWkF3Ky9XeUc3YmF1dTJNbThZQUxiVks2K1ArcmtzZEZYRkVT?=
 =?utf-8?B?YzFlL1VNZHd6a2lIOFZpWkdlSEdVTnllelBSajgwV3B2RG5vK0FZN1U3c0dB?=
 =?utf-8?B?c1ZNYVY4cFZ4Uk94Vm5Tb1Jnd0JYY1huQ1VkU1U0SjJnZnN4dlhIK3NETlBI?=
 =?utf-8?B?anhOYXh6a1JzSk84MzZVVVUwQ0IwU2kzeHR0aDB2dTR5QXZlTFJBc3BNZFdU?=
 =?utf-8?B?eVNtUGlsL2hCNERPS2xUaUxoNGhoSElsbGVtRGVxbEVuNEZZTmNUcFdvaXYv?=
 =?utf-8?B?QWRxTUdFRXpqWncxWEdpVWNZbkNBOGVYMUM2MzJiYzFmL0l6TEl5OUtWblIy?=
 =?utf-8?B?ZHd2MXpVRERUZkRyUk9RRTlhc0VrNG1ySmphR0pxbDkyVUtXRDVZbW9qeWtK?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a0cca0-1e0f-491c-5a39-08ddd075681c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 21:01:23.6149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fiE2XLwZT84cDKLb1CgpLavGqHBDu7WmzJDRg+x8kVh7X1XBJ9L+Zwmz3B3zqJWnXUS3zx/7zTcl0lf7rTvO6YtHKzMjGLCYz4BR3dG8pX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6984
X-OriginatorOrg: intel.com

Xu Yilun wrote:
> > +static const struct attribute_group *tdx_subsys_groups[] = {
> > +	SEAMLDR_GROUP,
> > +	NULL,
> > +};
> > +
> >  static void tdx_subsys_init(void)
> >  {
> >  	struct tdx_tsm *tdx_tsm;
> >  	int err;
> >  
> > +	err = get_seamldr_info();
> > +	if (err) {
> > +		pr_err("failed to get seamldr info %d\n", err);
> > +		return;
> > +	}
> > +
> >  	/* Establish subsystem for global TDX module attributes */
> > -	err = subsys_virtual_register(&tdx_subsys, NULL);
> > +	err = subsys_virtual_register(&tdx_subsys, tdx_subsys_groups);
> >  	if (err) {
> >  		pr_err("failed to register tdx_subsys %d\n", err);
> >  		return;
> 
> As mentioned, TDX Connect also uses this virtual TSM device. And I tend
> to extend it to TDX guest, also make the guest TSM management run on
> the virtual device which represents the TDG calls and TDG_VP_VM calls.
> 
> So I'm considering extract the common part of tdx_subsys_init() out of
> TDX host and into a separate file, e.g.
> 
> ---
> 
> +source "drivers/virt/coco/tdx-tsm/Kconfig"
> +
>  config TSM
>         bool
> diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
> index c0c3733be165..a54d3cb5b4e9 100644
> --- a/drivers/virt/coco/Makefile
> +++ b/drivers/virt/coco/Makefile
> @@ -10,3 +10,4 @@ obj-$(CONFIG_INTEL_TDX_GUEST) += tdx-guest/
>  obj-$(CONFIG_ARM_CCA_GUEST)    += arm-cca-guest/
>  obj-$(CONFIG_TSM)              += tsm-core.o
>  obj-$(CONFIG_TSM_GUEST)                += guest/
> +obj-y                          += tdx-tsm/
> diff --git a/drivers/virt/coco/tdx-tsm/Kconfig b/drivers/virt/coco/tdx-tsm/Kconfig
> new file mode 100644
> index 000000000000..768175f8bb2c
> --- /dev/null
> +++ b/drivers/virt/coco/tdx-tsm/Kconfig
> @@ -0,0 +1,2 @@
> +config TDX_TSM_BUS
> +       bool
> diff --git a/drivers/virt/coco/tdx-tsm/Makefile b/drivers/virt/coco/tdx-tsm/Makefile
> new file mode 100644
> index 000000000000..09f0ac08988a
> --- /dev/null
> +++ b/drivers/virt/coco/tdx-tsm/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_TDX_TSM_BUS) += tdx-tsm-bus.o

Just name it bus.c.

> ---
> 
> And put the tdx_subsys_init() in tdx-tsm-bus.c. We need to move host
> specific initializations out of tdx_subsys_init(), e.g. seamldr_group &
> seamldr fw upload.

Just to be clear on the plan here as I think this TD Preserving set
should land before we start upstreamming any TDX Connect bits.

- Create drivers/virt/coco/tdx-tsm/bus.c for registering the tdx_subsys.
  The tdx_subsys has sysfs attributes like "version" (host and guest
  need this, but have different calls to get at the information) and
  "firmware" (only host needs that). So the common code will take sysfs
  groups passed as a parameter.

- The "tdx_tsm" device which is unused in this patch set can be
  registered on the "tdx" bus to move feature support like TDX Connect
  into a typical driver model.

So the change for this set is create a bus.c that is host/guest
agnostic, drop the tdx_tsm device and leave that to the TDX Connect
patches to add back. 

The TDX Connect pathes will register the tdx_tsm device near where the
bus is registered for the host and guest cases.

Concerns?

In the meantime, until this set lands in tip we can work out the
organization in tsm.git#staging.

