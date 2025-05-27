Return-Path: <kvm+bounces-47827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB137AC5C68
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 23:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C95C3B8D7F
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 21:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37F31FA859;
	Tue, 27 May 2025 21:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2g0F6Go"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6825D1F03C7;
	Tue, 27 May 2025 21:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748382491; cv=fail; b=W8XRCb7QEWql1PL3tM4NFV9ar8v97HCmFXNzUeMkKXP2srl9Zdlw5NX15S4AgtlYxR78a96gykc70X92Q9QQRyChSpb4LWwFbbE+DYj3Wio/Z1ojuTocr7OX5xUygqZPAIDIxmFw9Aeic1Udv3a3+Z1bGh+SGRSseXBksQLXQa4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748382491; c=relaxed/simple;
	bh=bbsLk0egeW+T6SBL2cbN3yw6YAY2ncsqBrG3CTD/PXc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ISNhUTjydU/pq3TtxBuoNZY26bCO0m5HbHiMp++/ghMJbzq3jBrNWGcWGSJ3GYHe/pbINbq9+GqbAwpVAtl39G3XbzsdOC/L+KnLl1jkT2aQNqqZ6Us6vNqn+p+lXvZvlOIWd5SIVMycL66QFZDam+P+gpYTBO4duF2F0K7NXtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d2g0F6Go; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748382491; x=1779918491;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bbsLk0egeW+T6SBL2cbN3yw6YAY2ncsqBrG3CTD/PXc=;
  b=d2g0F6Go/Cl6uoW+hD1TbagxxJWtXHuIcII6F3ecFMfeNFFB1sHyrwZq
   xv96mQcwFJWF965gQ8eo6w0iKYKMMYk1TcRl8yxxjKTF/dpQbvoz7nJUa
   RJA9a37/JJ4toYa6Jft2ZV+ZR4SPWO5h1TITYNvQ9uVCYMZDElNbtRRj4
   T2Npd79BptnDOWO99X/nNA8RvBLW7cIduRNHWfZMgd8lSqDV975UdxJ3D
   KeogeBofK/73VbfZPdym6CWuZdZJeEAWIIOtLN4cbn+KPb7TlpvzWLcCB
   AXqR7mijcdrCs+l0Z65MuKCo+if36H4i8+Cf4YPZWuCyeAhJjgaLoLSFs
   g==;
X-CSE-ConnectionGUID: huzMaQIkT3KowC3OuZ7pFQ==
X-CSE-MsgGUID: gV2IRyKcTRGQhbQLMNr5PQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="50091389"
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="50091389"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 14:48:10 -0700
X-CSE-ConnectionGUID: GRKhRETtQru7iZZo5jztWg==
X-CSE-MsgGUID: aKR+2Z57Q6i6kurwpefclg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="142966641"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 14:48:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 14:48:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 14:48:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.66)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 14:48:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iGs+zgFZ5ej5z3Z4rKyJy+uycZHyrRvAfZxpnSotdezNjkLpgL3vMlotCd7jwgcEJLfTHIsSoaiIxU+Yu4Oq3TfUkSV4crSlT3ZyuF3FDZGdIq58CB8rqm9fekXKKqQaw9Nz0HNkS6LL629z947y66R6zBobvRj83rG6w+e7f5kfGCjiWfk7QRfphfdUz0O2dRjlUym6wHCGPUDMuqmRIytuTi+rdzzssVXgyRBkOLBDCGAkLt4g/ndiGpI/zuQMHxOBYbUbxhh3g928UItoRvcNHe+2PWVigPY1MbpDZLi9yKuiyiRK812/NKGPyMAZg1Xu1nxuD6VJIWX1JtwLdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbsLk0egeW+T6SBL2cbN3yw6YAY2ncsqBrG3CTD/PXc=;
 b=puaKKb8PtmvQw2TvthxrJoINY8o/r1yaO4xikPe0PjEog+5CJZl9F3LGxZivohVKUJS3bzHPEXvge+4vs01PwR3I4T4iED3uKKvHBLokmAAhzFN8s7jUsy67wcZEaFsogDMMTFr+f6XXzOAf2Yya0lnuiJZKZ80FWR1GMnwhUyw3gCV+Z9fROg/jpDrttXSmGV+5klFLmn7eD+rNMb9wr7cMv8cZb468f34N/rvv/JST0r664uihH4nMej5H2bksd305639u4r9qhmZ0LM/lD0LYqqrdCJGpCyiVUAITWb5BAvVydAVhWeFZZnVwH64DHCm2+zl7AjiVzt18sTo7/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA4PR11MB9201.namprd11.prod.outlook.com (2603:10b6:208:561::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Tue, 27 May
 2025 21:48:06 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.025; Tue, 27 May 2025
 21:48:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>, "eadavis@qq.com" <eadavis@qq.com>
CC: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
Thread-Topic: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
Thread-Index: AQHbzuSWB445QzrMV0+LSRpU93DRp7PmwtEAgABBcIA=
Date: Tue, 27 May 2025 21:48:06 +0000
Message-ID: <18b805fbe1de59f45b0d61667933f5301cea4f86.camel@intel.com>
References: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
		 <tencent_1A767567C83C1137829622362E4A72756F09@qq.com>
	 <c281170eeeda8974eb0e0f755b55c998ba01b7a2.camel@intel.com>
In-Reply-To: <c281170eeeda8974eb0e0f755b55c998ba01b7a2.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA4PR11MB9201:EE_
x-ms-office365-filtering-correlation-id: 032feac3-02ff-4409-5b3d-08dd9d682a47
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SlFUS3VDa0hBL3Z4Mi9UR2FQbml4WXN0TFo5bXdmYm9BUVZKVUVxWHJKVndF?=
 =?utf-8?B?aEpPSThsWFBSL1MzT0NWdzZDcFFNb2MxM2tCd2QrdkpJUFVLVmFaSFJ3b2Jq?=
 =?utf-8?B?UmZCc2dlWE80dXEwVHRqbGxKM2RlSjFqUkJVdnZKaXlpY3kwa3JWLzQycUdR?=
 =?utf-8?B?N0YrcVl0YVdvdmR4NTBYQzJMd21ZNE5oRHJLR21EWmN2eURtNDNOK2FwdDBm?=
 =?utf-8?B?L3FNOG5tRzhGcDFRNCsxUmNXV1BwcmlycFNTKzAvMFgrR2dUcEkrVFdhUVpO?=
 =?utf-8?B?VmNUeXhjUG14RjNtYzVCdnlpUVZPQnRPKytPdmFLWTJtS1laeTQrNU5XeUVV?=
 =?utf-8?B?NXRMcXp0VXZnemlqQVhiS1pYTnplc05rNHNrZklQamNaODFjZDY3enVCMjNn?=
 =?utf-8?B?N1czRDQ3WEFLMUtYTkNJN2pNRXE4SkM5aklRSlh1MWJxN24vZkt4djViZEZF?=
 =?utf-8?B?VFVhbmt3SzFzMFN0YjBYWVFLN3pVWE02cnJtUWt4RzQ2WEk4UnRLTWFUdGFG?=
 =?utf-8?B?SU1mNS9rS0Z1U256UEFkMXFuYmsxZVBKMlBDNWx5ekwwT1hJcE80VG5SLzdJ?=
 =?utf-8?B?RGhoTUt5TEFPeXd5QlQzcFhKY0lXdlpPZHZrNlZ3U1l0MWVvQ3ZFUTJzdExy?=
 =?utf-8?B?QmpSQlNQbnZncUJVY25Rd0pjRXhVYUk2cGZjTVVTaDRZQW5lOEQwUjRZdWdN?=
 =?utf-8?B?djVXTExMdU1CZkhJckpudERKczYzajVJQll3UlBIYnZRa0VqSDJ0ckRXUWlt?=
 =?utf-8?B?S3d0VFpoMUk1cDNEK1l1OGhlZ2hSZFJkZFY0V0gvVVNtemE2ZU5tOE12SHNF?=
 =?utf-8?B?Y3hVbnpaTGU4UWc0NzJvcE9jMEkxWEs3dHJiV3lHMXUzeHhpSWJERXBaOFlu?=
 =?utf-8?B?MW9ud0dONVR1VEdEOEpwUzg4N0E0a2NoK2dvSHF6SnRZRXZwR09WOVRxMVlF?=
 =?utf-8?B?amNWTm94Ukdabzdsai9aRWZINEIzeEdzZjgvUXRCWWVvSG1IR2RNUU9lOEdY?=
 =?utf-8?B?VVVNMVl3YWdnYlZwL2xzR1FFSWF5cUlISHFKWnIwbTBZSVIvMmxJZ2lQK1V2?=
 =?utf-8?B?cnQrZ3ptczNQMFB3cVlINGpFekJnTktldVFkTW9qcGxnMHRST2ZZK2gvNFFK?=
 =?utf-8?B?OEVKdC9DdVI2V2h4OGQwV0tLOGoxbXlKS1JHaXk5aXN5ayswaFlRcUFYUVJC?=
 =?utf-8?B?RWtwSkluOWlFYTZsNVJmVmExZE1lVFFTVkFuWENuSVZKdUxEcEJ6ZjNLdVhP?=
 =?utf-8?B?cmZYLzUzREZvaTRsZmozVHVUdmtmTStHOTY3STJDMTlkamN1U3RScGg2YmFE?=
 =?utf-8?B?YUdCU1k4T2plaWxldkZPYjBkalJXTmFLbzNsN25RZDQ3KzNRaG5iM1pYdVFa?=
 =?utf-8?B?eDNsRDFoL09FbzN1eW1Db3owdUlkZllvdmpoUzBkTGlGUVRFdzBCVGZ5QnVi?=
 =?utf-8?B?TG5wVXNWZWwzcWFYM2RGVXQybzRuY2w2SzJHVk91TmdRQ1NrdWV0RzcyUHpz?=
 =?utf-8?B?UkRMR3k4UDZ5dDBNMlAzQ0ZZc3YxQUZORS9tRCs5OXFvN3BRR29GV3JlYVk1?=
 =?utf-8?B?cEFmWTNCTjduWVBTMXJnelI3cGpUajlUY20yYVlRSE9NVFU3MVp5cTRnS3FL?=
 =?utf-8?B?cHJjeFNRcmh1alhRNmlSTTFEWDcxVk9LQXI1eXV0UWNta08zUUtwWEx5VmpY?=
 =?utf-8?B?b1ZrM2FkRlJsS2VhYk96Rk5HMmZjb0J0U3dGc3MyYVAyczRYQWF1YS9aeTR5?=
 =?utf-8?B?N2kweXF4Y0JQcGFiTHdvQ3lGa3V3L05hWWJESVI2akpwMnREd05TakVlZWNF?=
 =?utf-8?B?aTVRQkVCSTBaMkhhYU8zMlJBN28vSzdOQXEwTXp1STlreE9idWFUZ1d3Zlg1?=
 =?utf-8?B?VWtmdW5vUUlmeVVtdU9lbDl1dlhPd3ZXYkRjT2pYNmhhS3g1eVFvSU9jMlpD?=
 =?utf-8?B?T3hVbkVtYlE0ZFFDNG9pR2p6U0Qzc3dUcFhwUkxuR2NCM2lpM2haRGtrOVBG?=
 =?utf-8?Q?JzrSKU3Jq57WvEE5eBm01DYriftWg0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHpRamdlL3JvY1lkQUQ3aDNtaFEwUGdod0d5YVNTRzdGZVF5M2UxVjhTMkk3?=
 =?utf-8?B?Q1UwNjIzaWtiRVVRa2hXWEJHWkpNNTB1VjNZcm1sYXhFLzQrK1oxUmpkL2dp?=
 =?utf-8?B?aUFaZUFWanl2a1QyNExzWSsvZUhodXVNWUZadlg2QTAyb0N4TWdCWXMrS2Vu?=
 =?utf-8?B?dkRlL0REMDVMbXJWREFEa0xvWlJFMVo5RWJBUWIyZ25nTWh0dnVRcS9ReEhO?=
 =?utf-8?B?cFk4bFZWc1hxY1R0eGtwYng3UzJlNW9ORndMeXFYU0tac3FacFRjalN6RTJ1?=
 =?utf-8?B?VXBYNm5kYkNKUTFJaFh2dWZtODBJUVZ2aDhOVGVVU0FqMjNtc0NoaWdoUkpI?=
 =?utf-8?B?SXF4VGYrWVovbkE0czdXb25LZ0N2ajI1aFZXWkx0SkRjRWxzZG9rMCtPb2tL?=
 =?utf-8?B?MUtNWEZuZDNrNFl0bHZoYlk1VW8rTVZQUlpmb3ZVOVQ2c2JtOU5XTW9Ea3h4?=
 =?utf-8?B?amM3Vmt6VkxHdTh5WEVRenhMaTFqV0NhZ0NFZVBsckk4ZzJnQ29GK29wenpZ?=
 =?utf-8?B?RmhjWVZlczdrT09mTytMb0UwS1RWeUdRSGRGUDU2bDRZQWo0b3Vtc3p6M0pj?=
 =?utf-8?B?OUZ3MWFuV3NROG4xN2hKeXQrcjZUL0xxSStyTFNIekhYZlo2VVlXWFEvSG00?=
 =?utf-8?B?SXJCTnZZTGs1Nk1kVTY0S21xTTEvZEZEanJuMFAxQTFxTWZENUJxTkMrVjl4?=
 =?utf-8?B?UzA0d3BGMVVVRThINDNacTVmZmsxNXpseURpOHoyUnR5NGN4V1NtaWlaTWpj?=
 =?utf-8?B?bEh3aXNXVjRmNXVoTXNiVG16UFU4UnpGY1dOZ3FreHBXM3RxUGY5RmZrTCs4?=
 =?utf-8?B?SGhVNm1FTFluNTdpc0xFL2pWaEdIU3IxZXBWLytMa2N6ZWMxcExsSGk5clpG?=
 =?utf-8?B?bzk5TTZNeU1ESUU3ZFlYQkVnRDUrUmdOQy9pRzR4NmxtOE1OcTI3Z1g4Zllk?=
 =?utf-8?B?TFBJc3RvLzl5dHA0TU1Wb3VtZllIcnoyazRjL2M3Y2FYOVB4RnpSQXBXdHJZ?=
 =?utf-8?B?QXNpeEQyTjJMN2lFV25RWTRMcldJVURCWUlyN0VZKy8vNit0THhNeldMTXht?=
 =?utf-8?B?Rk9VZitsd0xkWFJyT0MwRkVqbHhRdXdDSEk3THR1a1MrRW5sZEFNZWZDeGFC?=
 =?utf-8?B?bXI4aXFBQUFtbFhveXZndW5pSHJ3ZlhSTWVMcUVUS2hSa1V0cFhoekNuODFa?=
 =?utf-8?B?eGladGh0SERDczdWQTZQbGs0TVZJT1JNVW5XQ2hFYVdvNUlhUmRmZEppd25B?=
 =?utf-8?B?MjJQTEQvS3Vra2FLdUdsYzVmd2dRUXd4cVhYRWJENHA1RXoxeVB3OEhnS2NV?=
 =?utf-8?B?Y2thR0drQTJ0T1I4S2tHcnpSKzF3RjN0R0NUV3RhQ3hUUElWRGN5cm51czJC?=
 =?utf-8?B?UnpjbDIwUzNFMTladjdOQnh1c0J4dzBUaGI2RnRwaDFxWG51U2tRMHQ3VUdh?=
 =?utf-8?B?NlBjbG1ONTJLOUkwM3BPTWprTWt3UWp3eDdSUVhsM3V0ckZ2bmFTa2FOOHZq?=
 =?utf-8?B?T1hSY3F3NzZGR1IxVmxmcmlPdllzdFJwZkVsYUxxNEo3bkUvZjc3NkRLM2FS?=
 =?utf-8?B?anhNTWNJUG5MRGRmSlgvQnRRcUlET204RXZpdkx2eGkvcFNBVDRnVitheFdx?=
 =?utf-8?B?Q0F0NWx0T01mNm5jdVcyd1lUS0hER2JnWXFYZ2dTS3F5TzdRK3YxODBlZDdr?=
 =?utf-8?B?K3gyRnEyaUZvdXAyK29qc3gxUUZMV1dDRnUxY1Y3WXVMOXFmUUZndmZybXpD?=
 =?utf-8?B?OGhQRy84RTFNKzB6ZXNWVXZvVEQwSnd5Y0gycE5lRzMyMUkyTE50bWtNcFEx?=
 =?utf-8?B?VDBIR1ZBUFptR0JKdzhKQ01lc0JCaFVuaWk1MkdTRldKN0pPamVWMDlUWS9W?=
 =?utf-8?B?ck16MzJLSWNnQXBRdGZBbHZuMmhOQkVYREVFbHp2eWN6cEtJSWdNQm1XWisy?=
 =?utf-8?B?MTlhSHRndVlsV3NtbVNGV3FoR1lTeHFSNGVWV09PQmZ6dUozVlUwbEphbGhs?=
 =?utf-8?B?TGFHRlVBaHBRYjRURzFLTUVXVnJqalNMR0htajBYT0VhcDNZWWYwWjBnRnk4?=
 =?utf-8?B?dWtQTkU1aExlTGNoMEJQWHp0SlNIN0d2STYxU2c2V2p0Z2R3VG9kSVRMemx4?=
 =?utf-8?Q?cYqm2PfP5trqt0Sej1i2/0y/2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D77B0BED20A294781A6D9EDC76C85D7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032feac3-02ff-4409-5b3d-08dd9d682a47
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2025 21:48:06.7792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r1ZmgH6QT4AV8OxFa4ev+cuv33Xn3+xHVH/yDz9H80FcreCDtbSYQF/KmqzgoFSC2N5geczUHBYJ14QoVvfJxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9201
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTI3IGF0IDE3OjUzICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gVHVlLCAyMDI1LTA1LTI3IGF0IDE2OjQ0ICswODAwLCBFZHdhcmQgQWRhbSBEYXZp
cyB3cm90ZToNCj4gPiBpc190ZCgpIGFuZCBpc190ZF92Y3B1KCkgcnVuIGluIG5vIGluc3RydW1l
bnRhdGlvbiwgc28gdXNlIF9fYWx3YXlzX2lubGluZQ0KPiA+IHRvIHJlcGxhY2UgaW5saW5lLg0K
PiA+IA0KPiA+IFsxXQ0KPiA+IHZtbGludXgubzogZXJyb3I6IG9ianRvb2w6IHZteF9oYW5kbGVf
bm1pKzB4NDc6DQo+ID4gwqDCoMKgwqDCoMKgwqAgY2FsbCB0byBpc190ZF92Y3B1LmlzcmEuMCgp
IGxlYXZlcyAubm9pbnN0ci50ZXh0IHNlY3Rpb24NCj4gPiANCj4gPiBGaXhlczogNzE3MmM3NTNj
MjZhICgiS1ZNOiBWTVg6IE1vdmUgY29tbW9uIGZpZWxkcyBvZiBzdHJ1Y3QgdmNwdV97dm14LHRk
eH0gdG8gYSBzdHJ1Y3QiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEVkd2FyZCBBZGFtIERhdmlzIDxl
YWRhdmlzQHFxLmNvbT4NCj4gPiAtLS0NCj4gPiBWMSAtPiBWMjogdXNpbmcgX19hbHdheXNfaW5s
aW5lIHRvIHJlcGxhY2Ugbm9pbnN0cg0KPiANCj4gQXJnaCwgZm9yIHNvbWUgcmVhc29uIHRoZSBv
cmlnaW5hbCByZXBvcnQgd2FzIHNlbnQganVzdCB0byBQYW9sbyBhbmQgc28gSSBkaWRuJ3QNCj4g
c2VlIHRoaXMgdW50aWwgbm93Og0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9vZS1rYnVpbGQt
YWxsLzIwMjUwNTA3MTY0MC5mVWd6VDZTRi1sa3BAaW50ZWwuY29tLw0KPiANCj4gWW91IChvciBQ
YW9sbykgbWlnaHQgd2FudCB0byBhZGQgdGhhdCBsaW5rIGZvciBbMV0uIEZpeCBsb29rcyBnb29k
Lg0KPiANCj4gVGVzdGVkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRl
bC5jb20+DQoNCkFsc28sDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRl
bC5jb20+DQo=

