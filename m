Return-Path: <kvm+bounces-50956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA8CAEB167
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD3E717DF16
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 08:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1360E23B62E;
	Fri, 27 Jun 2025 08:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EqMG76IH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C273F136672;
	Fri, 27 Jun 2025 08:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751013219; cv=fail; b=VfnYl1+MBa+40XPyhh12mJguTMgR1j7YbVJdMKF1RUEsLzf/NoB12+lhS2ZW+K2YXBJO7x8Gppfke7REew4V62mCvUY7fcXH6HFfsvliLdtWLY+Dqu6J/af+jByoE2puhCEuWw5SLjWgzdxScebZv6dbAvem2EcVuGa/GFZ/n2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751013219; c=relaxed/simple;
	bh=YeVkTQhvaOEkd2YI48sZP9d5CSNFKM+BR6rzrDSfDiM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oqS/rZrOHunqDVmPImMR06tq+XEDUpXsnFud/LEWYmflxXKoF09EBGtjNwNmfHgT0/Nvtsqd6UBstwr9OMzCmAkewOHQqwfaEtaJ4N1pSLbGPYnU8Wfc2FsPvaT8QxBVk+d99KuDIrTwn96UB5xQagUEzXRWDpVJos/p3qr0F6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EqMG76IH; arc=fail smtp.client-ip=40.107.93.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sl9FIh6/Z/dJGVa3nI1FnC8jB1WPtmibtiJoG31WpMTk9qi/971/DS73t9hVC0839+I5+AOMXpZKsjmyKeuSh8lxpXUMo82nScuIW1nFPomLVHC3NZCt16+XlaPPgI2dkYN4GVyun8uzep8si4omMWgR5EbyyfS11P5aYwywN8aFCM3rA2eThWHNaLmPyXOPHPzCHTjO0l+U41Ja+T3UIWx0sxA8jLCVA870RpubanOmtCzbdstMYX7Z2U48lJn+5KNSfezGPLHR7uuhp8cY+xUfnHkNWMVnTaJL+FS6qJfkniWe+7ozvXExHQ8voRAD7RhGVa4QBtz4NjGcINn7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qjdtvjarVEOqe2S5jogwrXlsiJuoMHNG2W7dsIuvDk=;
 b=MG+eV+Kx0tldC+xRnGIWptIFPiDf/EEPL4IfjlRBIMdSyvEOV+negiomgbUcdWK8CBc9wWb0ANBjDYE2nKCew71ioRK0iVzp7lwAoHUo5tgQQW6dliDsp+6pYXTUepiG7K8IZnlv9lT4FPiz17Wao9A/DSiz8tn1TU74b0kxD4s7lJdrANFrUx0DvgfvlRjWDb61pmSCOsw2mZ5M42k4Pd6AVnV/XCKiIIG0uYF3xen0lxebDI0BrdBIIDs9pe5McEyXrmVeIdhA+LkVucGuCV3PUngjrLQHZLQqnaW8CDNAWYd+GKyVXcx2JxOw/spLWIqVxCy84vHNuFPdK+nD+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qjdtvjarVEOqe2S5jogwrXlsiJuoMHNG2W7dsIuvDk=;
 b=EqMG76IHYiyTnU+YFkQRX43ek2sKniozaQsoOU6G+VUW3eFFBgwrFIkV7AgK8OlRTD3hwBX68qQ0oUJt33P2dUEBds8JlNHBCRLZZdhuIIeLvX07TLFzopSlKym0wHHQ7vfXX59aqaHIfXI2J2R4a3KqTq1FxXkgQ/bYBEMNqpE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by PH7PR12MB7211.namprd12.prod.outlook.com (2603:10b6:510:206::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Fri, 27 Jun
 2025 08:33:31 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8880.021; Fri, 27 Jun 2025
 08:33:31 +0000
Message-ID: <d3189b65-ec6a-4dba-adac-44e72935419e@amd.com>
Date: Fri, 27 Jun 2025 10:33:28 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] x86/sev/vc: fix efi runtime instruction emulation
To: Gerd Hoffmann <kraxel@redhat.com>, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>
References: <20250626114014.373748-1-kraxel@redhat.com>
 <20250626114014.373748-2-kraxel@redhat.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250626114014.373748-2-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0259.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::9) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|PH7PR12MB7211:EE_
X-MS-Office365-Filtering-Correlation-Id: 456359b1-219e-46f1-9c76-08ddb5554c5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TGhWNmd2ZSt6Z0t0aUFwVEhmZm05YjlkdjlqVUR3NitXMXMvVDVPZnVzY3J2?=
 =?utf-8?B?T2U5SGFXZFE0MWxmZGMzOGJJQ21kbTJPdEpjVTVYenZxWmdFdllENFFFL1Zy?=
 =?utf-8?B?NnRPeThISDdJUXQvODNXZHpGNnZjNUF3NzZSdnExS3NLYi9ZdUptOU1LWStq?=
 =?utf-8?B?aDNWNzZmZG9CMlVQWXI3UDZqOU03ZzR3MU56TXdEcEg3Zm1sRERXWWNVTU5F?=
 =?utf-8?B?WURRMXl5aUZMT0JnUVZydGh6NERpaWdaUzB1OER2MzFIWkJVeDFnTlF1UkFB?=
 =?utf-8?B?RlVBQnN4TkJLbVpjdm9MdjkyRjEvQU53LzRzeUZ3OHVJTGZPUUNVMXRuSFFG?=
 =?utf-8?B?ZCt1WDkzVUxxS2ZYdUZPZmdLMnRZU1RVN1lTTHJUMi9WVWZodVBad3JxNmJk?=
 =?utf-8?B?eG5lUmU2aFcwK0VkMEdrejMxYzhvZmFHcndyMDdiVzNsdDI3R25aemhYL2dm?=
 =?utf-8?B?Z1lwQUR0OXVUZFQxZVNXaXhTYkVJZFp6OVJPMnpqTnhZYjY2dnhqQWthODJo?=
 =?utf-8?B?aE1jZDlqM0ZsNTlXNFBRU1JHNUg1c1JISGQyTlN4Nlc4ZC93VVd2c2FWeHRK?=
 =?utf-8?B?bWJlemxNc253TndPeURKcVFaSXF1S3BWL081NWlaWGZiT1FaTHpYOE0xVm9F?=
 =?utf-8?B?NEJyM21vVkRnclliTVZvcUVqR3RWbnlIRkZrNTZmNDFTeVdjR3BnblE0K1pS?=
 =?utf-8?B?SHhHWEM3ZVphcDcyRDNDTTZFdmtFc24yZitQNGdGcEJxMUFJckRhakpsYzNJ?=
 =?utf-8?B?dHg1NHZZMk9QckZWWXk2emhpUTNNMXJwWVB3a2tSNW5TNW1XRFNsY0wzRWVh?=
 =?utf-8?B?VFpGZ0U5aW1JSVJUay9UczM1MldjR1ZmUS9RMVR2RDVuK05qTHp6cklTTDh0?=
 =?utf-8?B?cWxBWGpkS1dGK01lNTNpMm41RU9UanhBVlk1aWNuVW5VaXhxVzhkb2U5UUZt?=
 =?utf-8?B?c1lzUGZqRXY4TlRXNVVycXlONWNZNUlwMCtxU2p5T1FWMkI4VEZmc3lMMWxq?=
 =?utf-8?B?eDFLbG5pMzZMVmQ5MjlDbkNtMUV5MnIrMHM1K1BQNnlZcEZxcVpBdGZXUklt?=
 =?utf-8?B?VkNwNnIzQnluWUQ4dHVwM2xwOXdJQ3NHV1V2Z0ZkZ0lxNEJDT2dVc1dKamtE?=
 =?utf-8?B?SjQxcURiOW5QNWIyUkYxMXZ3TVdNbjFYb00wVnlKUlRYWFl0WEYxZnZOUzhl?=
 =?utf-8?B?cFZkclM1T3JYQ0gzNFNYYnRIcExNeW85ZDI1TmxmREF2d2g4UXlXaEJ4dFZZ?=
 =?utf-8?B?MkM1RW1JZmxkbGlmb0NEUGExR3BVc2RxSk0xWmZXYk9kNWRzZVhYKzBvd1NN?=
 =?utf-8?B?L1FiTnJTUlpsRC9Ya0llMSt3d0RFaVowU2hiUTR4SmY3dm42Q0hxeW4xZkNN?=
 =?utf-8?B?bWlrNHZNUjRQVC81bDdaNjEzWmR0ZGpDZzRwVDNBLzBJaW9PUXMrd2JSTFk2?=
 =?utf-8?B?S3h6ajVoN2R5dGR1SWlZOGJtdnpKampDQnJBSGptZU5ERUV4ZWUwQ2FqdE1u?=
 =?utf-8?B?bDlUQVl4MkZPSlNuTytKM1BxMGg4bmhPNzAyMzU3bGdLNmxVSzlhdzY5dGFs?=
 =?utf-8?B?N1d3Nnl4cncwdHJFYzRBQTFrN2xoc1NnZWJBSjBKUDhpdkZoMGRTSUY2djhO?=
 =?utf-8?B?bHMxK0gzYlNtMFgwTERYUFVydWNEeXRsWXFkVmgrMC8wU01JMnY1K3lXZEh1?=
 =?utf-8?B?S05ramtTS1dTd0QycHFZVzNsWk96b1hpbHNnSFowcjJ0cXIzd3U2K3h3TWY0?=
 =?utf-8?B?Z2tDbGNldEI3R1NBaFNvWmcveXdPc0NXQXZVVXhKU1lEZFRjTm1rd2lNRVJt?=
 =?utf-8?B?dFdpemNOZjYrV0d4ZkM2bHhzNW5OUnl5MnZTb0hvbnNZM0MrZDBTY2xzakdj?=
 =?utf-8?B?a2EzU05ydWZtSnBmR01YNTZuWnhRRGFUK0N1MCtnTVdiY1NMRjNxazNoU0Ni?=
 =?utf-8?Q?Ml6BmRbpDAc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmFaTVZpMDVOOG1QUUZya0YxeG9QODA2SS9udWRtZFV5akxOU1lwNERhd05R?=
 =?utf-8?B?SUd4cjFmZDhETi9BajEwb3kxV0szbWYrM3ArYnk3KzVnSDFGVDY2OWRSMDVU?=
 =?utf-8?B?MkpmZmliZU5pdERKTmFFcGt0WUM1cFpMZldESHhyUGRqQkN4RlpIUDRka3lF?=
 =?utf-8?B?bjNPY0NVUXkvODNFb0FaTGNHVjNGYWM0ZkswMlJvdVIvTFM0eE12QnkvNDZv?=
 =?utf-8?B?S2ZmNWUrVlpTaHZZYlVTOW9DWGtMM0dlYzdFK01mRXFjWUROalZ5NHpLTkN0?=
 =?utf-8?B?UFg0RVQ2N1hPcE5YU3ladFFCMVRCUlk1MEJuZmQ0NjdyOW9FUlRpMFVCRlVU?=
 =?utf-8?B?NWlPWVZFMHlUVmV0a1M1dVNqZjgzVm82SzR6dFRSNkF2Vnc0RDFoRWZvb3N6?=
 =?utf-8?B?cy9GaGVLSXlWczFvTDEzRUExSS9NWHN4UFV1Z0dtYytjL1E5MGk5RmxLSDY2?=
 =?utf-8?B?V0hZUzRKUmhSZUQyMzI2czh5dEI3OElsRUxaQ1JydVI1YlBhWjZ1a2xDNldv?=
 =?utf-8?B?dUVrOEc3SWt2dkRqTm5zNHR4QUFRQXhQMkZvdCtrbHRyZ2thY2FyeHdQWHBZ?=
 =?utf-8?B?d0JlMTBUN3I1N2p2cENydTVXSlBLNXRKVUxpdGMyTVJEeTZlVzJuWXE3dUs5?=
 =?utf-8?B?Z3RXS3NQUzBDQmJkNEl3ZExBL05hZGprZWQrTW1GYW8vMFpoNlNqVnlZOFlE?=
 =?utf-8?B?Umtqa2cxaWJ6aXZFRVZkMXQ5UmZJS21tQ3BzYnlyL0cxaXBoYXNsM0wwQk80?=
 =?utf-8?B?N2sxMElDK1R0ZGpNb0hrMi9xcC9GSmt0OGd0RkMxT1pXRmVKZHBYZUV5N2pq?=
 =?utf-8?B?eW1xQ3hnUkNYREVYbE45REpRaDJDckpaVVVQS2xEdVoxSVh6TXZLaUtoRkVw?=
 =?utf-8?B?cklQejFPcGV3QUVJdUJNV0w1cHZqc05JaW0xQ0ZYMzN6aGVITzc1Zk5wcW91?=
 =?utf-8?B?WE9ZZUtZWmp2bzJSL2dXemtWRmI1ZTdBYlFrR2ttOGFWdU9RNHJwbWtpSjhO?=
 =?utf-8?B?ZGdyYWdIOVk4TFdKN3J5SHVjQXlMbG1hU21aUFNVZUttR3BzTUo2K0Fvbll0?=
 =?utf-8?B?WnZzb1NlNEloY2tHRUJVWU1zeDZzYW56UVJibUxMcHdMUWQ1a0VxMUx5OEpJ?=
 =?utf-8?B?V2RZUWJEbm9hOTR6eFFhL21IN2FNMFJLSVJoYWNmYmVqTDNQWnFPU3kzaTh6?=
 =?utf-8?B?QVoxdVhGaDZrK0srNVBndDhkcXRPdEJzeFg5eWRuNnR5TEtwZFBUdkhZZFAw?=
 =?utf-8?B?SXI5dEd5Q3hVL0JhSFpFa1g3ejlsQngvMDNQT0duYUJ4cEc1NWNoazB2Q0Nv?=
 =?utf-8?B?OXNSaWNOS0R3bUVBT3U0alpOd2s4ZDMyalpOdloyN0d1WmVhSngyWWM5N2NC?=
 =?utf-8?B?TG01eHI1WlBTRkJyNytJQVp2ZitOVkxUT0JWSU5MSWIzZzc2UVhjbTBYRm9h?=
 =?utf-8?B?b0tsd3I4VExkQTBDUFY4RUNEWmJQOVYrUmlUNDh6OUhsUnFTNm5PTTB2NmQ5?=
 =?utf-8?B?QmhyVGlmUmR0L1VRU3NNN1NwY05ETUtvWXBjRUpmZ2lMUGo1U09CZHRmUjRU?=
 =?utf-8?B?UDlDNDk1Rm90UC8wVnI2RC9lZUxOaFlWSnRIK3dzMlJaQlkvSG9HcXE0VHJI?=
 =?utf-8?B?T1JTODRQYnVVUFcveUU5V1pyV0tWSlpHOHMxd1VrM0F4anJpMlJkbU94Tkxr?=
 =?utf-8?B?ZWpyQ2cralVJd2ZWVE5IcnJlR3Q0MEJibnF6RmVrS2NWdG9ld2FOa2dxdlVD?=
 =?utf-8?B?b2F3MGlGemlaRElpczFqK2UvcFFtMEZLZzViekJGOFNCTHFoVEcrNHovU2R2?=
 =?utf-8?B?SGFSRkJWS296V3FZQ2d3bitnU25EVHJZRk9pSmhmMi9ncmJaeEhJcHllUnBM?=
 =?utf-8?B?eDBEc0lVZkM2aVMzMTgrODFVRk9UK05OMnB2b29RY3RNd2lhcHlUNG1TTXlO?=
 =?utf-8?B?eVpyOWViakhHQWJXcGVhWitDWVBvN0IrWVRPU29zSUxERjBxSWwwQ3UvNUVH?=
 =?utf-8?B?djJvZE1jQ2ZpdGUyUHM1aGoyMkZVWTdWbFFDSXZ1TnI2UExaSEw4WmZacmNl?=
 =?utf-8?B?MFpCWlFNOVVxNVhMUXo2bzZTSXJ5K2RrOU96QUpJWTNIQ29oeGxsOU9Tby9E?=
 =?utf-8?Q?cd7WCJ/cLE10JMXgYwEHWu2+l?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 456359b1-219e-46f1-9c76-08ddb5554c5c
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 08:33:31.6650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EC5QhEh+2XNDvQg3QKSbw3J1AGtF524jWaiGehgROdL5B2Jf0SZKDrJqrb+vfQsLvrDOy1FxOJwXygeEogwpdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7211


> In case efi_mm is active go use the userspace instruction decoder which
> supports fetching instructions from active_mm.  This is needed to make
> instruction emulation work for EFI runtime code, so it can use cpuid
> and rdmsr.
> 
> EFI runtime code uses the cpuid instruction to gather information about
> the environment it is running in, such as SEV being enabled or not, and
> choose (if needed) the SEV code path for ioport access.
> 
> EFI runtime code uses the rdmsr instruction to get the location of the
> CAA page (see SVSM spec, section 4.2 - "Post Boot").
> 
> The big picture behind this is that the kernel needs to be able to
> properly handle #VC exceptions that come from EFI runtime services.
> Since EFI runtime services have a special page table mapping for the EFI
> virtual address space, the efi_mm context must be used when decoding
> instructions during #VC handling.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/coco/sev/vc-handle.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
> index 0989d98da130..faf1fce89ed4 100644
> --- a/arch/x86/coco/sev/vc-handle.c
> +++ b/arch/x86/coco/sev/vc-handle.c
> @@ -17,6 +17,7 @@
>   #include <linux/mm.h>
>   #include <linux/io.h>
>   #include <linux/psp-sev.h>
> +#include <linux/efi.h>
>   #include <uapi/linux/sev-guest.h>
>   
>   #include <asm/init.h>
> @@ -178,9 +179,15 @@ static enum es_result __vc_decode_kern_insn(struct es_em_ctxt *ctxt)
>   		return ES_OK;
>   }
>   
> +/*
> + * User instruction decoding is also required for the EFI runtime. Even though
> + * the EFI runtime is running in kernel mode, it uses special EFI virtual
> + * address mappings that require the use of efi_mm to properly address and
> + * decode.
> + */
>   static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
>   {
> -	if (user_mode(ctxt->regs))
> +	if (user_mode(ctxt->regs) || mm_is_efi(current->active_mm))
>   		return __vc_decode_user_insn(ctxt);
>   	else
>   		return __vc_decode_kern_insn(ctxt);


