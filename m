Return-Path: <kvm+bounces-55091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D096B2D2A2
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 05:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6360E189CB7F
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 03:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5B5228C9D;
	Wed, 20 Aug 2025 03:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DLzjr7fs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F93211A28;
	Wed, 20 Aug 2025 03:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755660884; cv=fail; b=norCWNUGs+HtPxDH7laM+nuYTeudUVS/0wNxM0/XyYUoVJE9Evnkzg+ptnQFtwErf/PCsWsvQmlr9uCv4oqnOQdGPVoNj1W/j5LuKyihOqtI7XZKndHklvf7V5k5lcphFuPGeD2Z2n6Dog4us0aTuk3l71EvkaKTy9NrBgfw6fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755660884; c=relaxed/simple;
	bh=mejiILu0Pq00qwbofQLGw6vKQEICbpzaqTk0GOv9Ie4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cyzQwH8RoBGDN47ERJcd5iiG0Rg7Q5uIcWiJfqgsKcxpgtYc60d8njAjsKxBFjk5bLKrCbFohAITDvnOr6yAcQeIOEow0i82ku8G1vFYYJ743yMuLt9EmoqXajelcPE1g2Dp9etJ4KG6pqZRRb4JCd5OfzaOqN8zbxWtoXHkB3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DLzjr7fs; arc=fail smtp.client-ip=40.107.220.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zSX9HpBB14SPOhpGd99ymnGn5/s1Q77gtekXlH8Ul1a6ROWkccgV3fj6JNpZn0+OiQXrYt6WmouTBAi74LcplLht8CPwGLDw2cluJapcohKnhwMWIQYTftG3/X2RPCA4xJtDGFJVMdMnfi1+XZI+imWqP6VZBDckVvRjmBGPPfLEPyiAZVNIr2o0ZS9DhXUJRE1xxCiUcCQmOeVzWzb9fbZvUcA+M5sgcwmACYLCzFxzf/RsQ30Zj+0icFtRcO3YngyTNoJ9/bMLeBLl5yPNA4rogeFB/S/oYuVD6RoHSSYl5LU+MQU+yqvz2U6pzAOc6M8njCKNuPTSK9pj14lnKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1ijycZBqQewkb33ERKOo7cKQlXkKmL1Wbv8PP8DACY=;
 b=KFP8cCAhfP31QbjaFji+Qr2cgod/g7Aj6INE+/B6+ayQKc4CLO1W23wkPnOW/mpMb09ak4KRlZeMJTvlzriXXKQBEgO+9uHbq4aPQLpW4hjDKdrkSGuqHt3jlbz38onPqMwYcQCbNh5dUwZxV4lRSLCyIF/UH3ZBc/Xggm2Sa7CuBnaAnCspnYuYdUoPsg+xJDMm0qny7PDn4goZ5+Z07A5ewgexkZdL/aRlyIqipAnCOn3jR9R/svpSql0BTBV/sEKtk7nv0YpI2MWStBnNsQcUwQK7XWkhbjGO2F2YLy7JjNecFIy5GVT54m2y+19+ETMqsmeP8/DUCli5rzZ1UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1ijycZBqQewkb33ERKOo7cKQlXkKmL1Wbv8PP8DACY=;
 b=DLzjr7fslh/Og+/KGFGM4UY/uBr1skv0DusrL/I9mZExHsEg9Naf/ZBqnn5bSI4nXOPR+ZIWZsiVmY6TJNPwtAdn8O8snQ/m10k0RpqRIgDGhboAQDmYgeJO1r53dIBPoFTR7ZFr/T0l8kpAvNLpeRFU/CMhCWDppBd/rN0DMiQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SJ0PR12MB6688.namprd12.prod.outlook.com (2603:10b6:a03:47d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 03:34:40 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 03:34:40 +0000
Message-ID: <157157b1-dc05-403a-bd1d-ec8d829dbd8d@amd.com>
Date: Wed, 20 Aug 2025 09:04:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 04/18] x86/apic: Initialize APIC ID for Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-5-Neeraj.Upadhyay@amd.com>
 <20250819215304.GMaKTyQBWi6YzqZ0bW@fat_crate.local>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <20250819215304.GMaKTyQBWi6YzqZ0bW@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0155.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::25) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SJ0PR12MB6688:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b0fabb7-e4b3-4b3d-c4aa-08dddf9a7eb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cE1PQk9EUkltMW5sNHFSYklZUTVacFRUclhjaVp0bzBzSUg3R2swa0Y5NG93?=
 =?utf-8?B?dzJuOG5XSUVXOFJZMnhnS1l6aFVNQkNBNlBqbmRNeUJMam12QVdYdHdhN0lD?=
 =?utf-8?B?T1ZuZ1RJdnExTGF2eCtPYndmcUpGSUJFK2FyTXFtNUV2enRmYkRnemJ6RnlG?=
 =?utf-8?B?NDl3YXNWTnF1bnhoZUdMekdUUm9wZHpyVWhyRWkyRFdDQzlQbjc1VlBRdE12?=
 =?utf-8?B?bDB2TVF0ZXMyZmtaS3VZcXkrMDlQL3NHR3V4eUlvanlrdXArQ21LQTAxVytv?=
 =?utf-8?B?TStzSGJ6QnpFbXhWa0paRW1VQ2ltUk1RSGZCZElVcHZZRjQ0TWp0c0hwS2h5?=
 =?utf-8?B?RlczUG1hUE83d0pUTTIrbmwzVi8vRmlCZ0pONVIwdHBXcjlBTkI1d0xSUEwv?=
 =?utf-8?B?aUxLY1huQXkrZ3ZDMW4rcHEzbTExOWpuK2hwdVN2VHA1WWM3NTFpdFNyUWIr?=
 =?utf-8?B?K2FlWDlOQmNaWHdkUzh4NDM4ZVVrMUFGVjdpYkVxREhDMWV6TGpDUGtHNFh1?=
 =?utf-8?B?RHBXb0dCZjcxUHNJVFhKdFJQTFhsV0w5R0o0ZU5YdUxTRlh0QnQxWm5yQ0pl?=
 =?utf-8?B?ZmVjdDVkZEl5ejdnbjhLdExGbm9TVWxkTXN4VGViTXVyT1BHQnkvbmwvNXNl?=
 =?utf-8?B?ZXNRdjFmOWh0aGF4Wnp2TkVXSmFiWUYzR2hINnVwMWpxVGs1MjVUYUlCRlg1?=
 =?utf-8?B?d2gzTWNSaDVhWW1MUWZWRUVKZzYvbWo1M0FKN29PNjlQT2NoaEpDZHBWQUxz?=
 =?utf-8?B?WFlrVVJHeGxJeHQ0enlkaFRJUUE5cnZUQ293dmRMSk9LUVV4a3pnam1hUG5z?=
 =?utf-8?B?OEk3RXJjWU5CTC91aHB4NVlUeU92Mk0zVUNVbXlnUkVJakxZTEtiYjVXdVZt?=
 =?utf-8?B?NzY3VTlCcWQ1aVpjbWtVMk9tNWFneGdpNHZHUDN5NzhIY2lxYmJCQnB5LzNi?=
 =?utf-8?B?bUEwci9pL2NONzlDM0x6UEl2czZCMERBeE9lUEw4ZldDbDFpZ3ZSMlZiRjhC?=
 =?utf-8?B?YTdPVk9nejZLSUdUWkZBQ2RIeGUrdkhXWm9jQ3lmeWZkU2w3Z2FSNWpRSkNm?=
 =?utf-8?B?NXp3ai9NZnRhQjFxcXoxb0d1a2Jsb3FqcHRYdDdRL2xKTzdYMVVyekVvSks0?=
 =?utf-8?B?R0JrUlJxR2plZi9BdlQrM3lNZHFZRXVvdjF6N3BwalZVRnhSNktIK3JzTkZ3?=
 =?utf-8?B?R0U2MEs5UENLbVZ5UFhIRW1BNnB0aDdsTXZ6SkxnbzhyQk5QQlk3VEYvcjVw?=
 =?utf-8?B?MDJscjlyK1gycVRQaFM0Z0c3VmxwUW5IQkdDS2pleHVab3NXbUduWjQ3LzNI?=
 =?utf-8?B?MXB3MFFkbXk1dXdPVC8rTDlmdUtLbUtGSUFHWjMwYkdyMWVPTElNOWxzYkF2?=
 =?utf-8?B?b0d4cTgzTmJsRGNNNTBMVG5WRDBaQVNHQzJ1dlp6NDIvMDRRbzdhYXVBZlc0?=
 =?utf-8?B?YnJaZkJCRSt1RGpiRXlmRkJIVWJSc204RHFscGV1R2NsTFBSZzk0WExtS2Rr?=
 =?utf-8?B?K05DUE42cWxTdkxaSHNRU1MzRzhFYWdEZ010UFBoZ0NnSUpaR25aL1ptVEp1?=
 =?utf-8?B?dnJkZ2MwNXZhWlliSkpWbDVrT2syRXRrVlNQc3UzY004K1llNmxKSXZ1cmRI?=
 =?utf-8?B?QVZoMjVkK3RUWHFqL0lWVTFuR1lsejhZaVJZcklPbE94c3lIdklwY3QrUjlI?=
 =?utf-8?B?WXk2WlY0d0kyZW1TOWU2VlpOaTUyUldJanl0UldTSDlDckF2ZlNReTlyU3Ro?=
 =?utf-8?B?aVpleDVuSG90SSsxMVdZOU5hTk1XeVNxZ1pGZ29xS0N6aVdMWHNuZzNiQVFD?=
 =?utf-8?B?Ym9RRnNOUTFYWGVoSUQvTlp2b1F0T1VabVA0RHhsWHlUZCs2REV1eDBjOVBX?=
 =?utf-8?B?ZWN4enhESzk0UzJRVmEyNWNHaVU2TUwzZHc5QTBLYWNRb044TGR0NXk3b2lG?=
 =?utf-8?Q?vD3cutirKzM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0NBNlVEcTlzMnp0TlgwWjllYmh2MHo5MGN2bmhWR2VPa21uMmltUmh1Ylc2?=
 =?utf-8?B?Q2EzVUtQcTBqN1puZUh3b2s3bXVKYWtqSnU4cFM1L2sxK1JQRVJQTHZkaEZ2?=
 =?utf-8?B?OXNydDlhdmRDb3J5Tzk3d2VuSzZTMWRRd2lDT1EyY0ZRUkt1UTIzRDhCSFIv?=
 =?utf-8?B?M2hxTG5IdFJIWHFOcUJ1RVRHdDEwRUc5bFI4WWRuemt0Ukg5cElCMmRIaHVE?=
 =?utf-8?B?MDJFZ1lXSmFjbVlCYmR4aGdsa2I5SUNWMGp5TFJXMkhuekpGbmtGbzExalpT?=
 =?utf-8?B?ODZXSnd1Mkw4SDJTSDBNaWVGaEJKdVdrM3lBbFVPUWgzVFNzWVRqcE1Tek5O?=
 =?utf-8?B?WlYrcHZCYlpuaVlFY1Ivd2pDejVubkdqMlMwc0NWNTV5N0pRVGs2ZjcwbzVv?=
 =?utf-8?B?bDhrZUVnVUIxNHFlOTFMcUwwZUdkSUZacUU1TTFHT2c2cCtETFhtbUZTcU9U?=
 =?utf-8?B?L1R2TGZ0YUtsRjNUZUp1bXZuYngrc05QNXFua3JidDFBNFlQNDYzeVpRTWhs?=
 =?utf-8?B?bXkyQnZRRmwrVHBjNkpaVDljOXBWSkpVV3pOOFBtRzhqZ20wS3g0Y0ZNYjF2?=
 =?utf-8?B?aFVnVU5RMUxTeHpHaFg4Y3JMREFiMndTd2xEVGlDb1pGODljOVVET0FxVUtM?=
 =?utf-8?B?NGtEWkNOYlRVQTFSTm9HTGZEdGlDZ1dGRG9vZWp0bVBacTluR1FnSXZFRXBT?=
 =?utf-8?B?MkEyTk16b20vT0s4eW1GazZEUzFHcUtlSkFybnRvbUJWa2Jtb3A4Mm5maVlY?=
 =?utf-8?B?U1B3NDFJY3pJdE5CcXBRSWRNcGk4TkhWSkVvMC9IOTNnTmVpSVdPWWsvZHQ0?=
 =?utf-8?B?L1ltaDJDZ3UrbUZmbHVOUVZ2d2wreVB4ZXRXN21lVmg1c2I1RGllQXVrRm5O?=
 =?utf-8?B?ZCtiTDdCSUE5U0w4MG85TmVCNDlvRlZWdGJ6RjhtakNqWGcvRjVGcFB0eCtD?=
 =?utf-8?B?ZmJKdG9NMzRSREovYkpOVUNlakFUN0s4dWJrVjMxVFVZR2l6VDB1VVFUbzlx?=
 =?utf-8?B?cVJ3UzlOcUJlL1B2VVVsZlExSWJaQzNhTFhWc1gvRnorUUl2QjJNT1g2NHFx?=
 =?utf-8?B?cGo2bGdmSG1ML091ZTJnQXErSUlBblRXMm82alhQemdSTGt3Ny8xRlpqOEZp?=
 =?utf-8?B?LzRTRUlmQWpJTVhhTzhoUE4vOEhxRlhyZHY3VDZEQ21zazM5cEI1bDRjVkpR?=
 =?utf-8?B?RG53Q0orYmF1K3daWjZhQ2xVMnNNajlBWXhmYmFUZlFHeklYQXp5cWp4UWpw?=
 =?utf-8?B?NWVGMlo0U0p3OU5mYnpLWlljTzNlazAwa1lWbllpSWVoalk2cC8vaGhONXdl?=
 =?utf-8?B?U0hVOC9hSlhKUTlmUjFnMXc4Tm9GZUN2aHNFUkltUzc5V3Z1OHplcjRtSFFs?=
 =?utf-8?B?WjlMWVdIZHdIZTZhWFMxZG90L1FYNGFHZEorSVR2NGtFSUtPVThUTVpuODNK?=
 =?utf-8?B?L1F4UUlqUE9zMEszdGI3Qy9naHl1UWdIdHkzcFRPQ3ZUU0k4Vm9Md0xKUnpx?=
 =?utf-8?B?cTYwZE01MGVjcldwbUFhdGtLTHdva1M0cW42anh3S2VvZmI5Q0kvK1FpNTIv?=
 =?utf-8?B?ang3dGNKYUx4TUdYS2J2Tkpvdm1yZzNmd2xVTHQ5S1QwRFZRM09NK0RyZ3pJ?=
 =?utf-8?B?NkczWTc4V1Z0SWJMdnR5STlyczRvRDFRZWxXaE5OVXhqSXh3MEtRM2l3RmpC?=
 =?utf-8?B?ejZ2aTZGYlpVWDlpZE1JaVJ1QVUxQmY0MnpUdUUrT004VUxzMm1LbTdoN2VJ?=
 =?utf-8?B?bFArTUt5SGw2WkR0aTgwb3MxQW8xRjlBdUxpdE5XMFQ2R1JLcVBieXVjcTRX?=
 =?utf-8?B?M2l1Zzk2TThqaFJEc0c1UWhPQjBVUjArdnM1NlplcEUyK2dYQTBrc2h3eEww?=
 =?utf-8?B?TGMyMkN4ZGJmVWhwZk5Vdit2T1VoZkp3WndnNmFueGpKUDV5U2QyY3kxbnNh?=
 =?utf-8?B?WVhQRUJtUEhHa084bklXc1pHNGQ4RVhvdDMwTlNSQTlWQVhiVFBNbjV5WTRH?=
 =?utf-8?B?ZVNodE5Pc01JTkwwYU1zb2dvYlFuN1dUYUY2cTFFeGtHYmdOOEZUOXNqZkl3?=
 =?utf-8?B?MEdQR2NjOG5SdjRxS3U3UzZkUU1oK1lEZzlQNk90NUo4ZWc1SUUwY3JCYTZE?=
 =?utf-8?Q?CW3O7+h0Tk9U1WAAj+MEb4Hi3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0fabb7-e4b3-4b3d-c4aa-08dddf9a7eb8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 03:34:40.5073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GIf0ny408gO9P3NMukDSQdvsdpdadgJ4eFeq7QvH1j2AT6GjhZYQVg8lH6JOjwoqPbhD6zIU97y5OH82s8hMGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6688



On 8/20/2025 3:23 AM, Borislav Petkov wrote:
> On Mon, Aug 11, 2025 at 03:14:30PM +0530, Neeraj Upadhyay wrote:
>> Initialize the APIC ID in the Secure AVIC APIC backing page with
>> the APIC_ID msr value read from Hypervisor. CPU topology evaluation
>> later during boot would catch and report any duplicate APIC ID for
>> two CPUs.
>>
>> Reviewed-by: Tianyu Lan <tiala@microsoft.com>
>> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
>> ---
>> Changes since v8:
>>   - Added Tianyu's Reviewed-by.
>>   - Code cleanup.
>>
>>   arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
>> index 86a522685230..55edc6c30ba4 100644
>> --- a/arch/x86/kernel/apic/x2apic_savic.c
>> +++ b/arch/x86/kernel/apic/x2apic_savic.c
>> @@ -141,6 +141,12 @@ static void savic_setup(void)
>>   	enum es_result res;
>>   	unsigned long gpa;
>>   
>> +	/*
>> +	 * Before Secure AVIC is enabled, APIC msr reads are intercepted.
> 
> s/msr/MSR/g
> 
> Please check your whole text for such acronyms.
> 

Ok, will fix this in all patches.

- Neeraj

