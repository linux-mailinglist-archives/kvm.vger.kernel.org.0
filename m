Return-Path: <kvm+bounces-40337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63439A56A31
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 15:20:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B8F21892F3D
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 14:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A42E21B90B;
	Fri,  7 Mar 2025 14:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E6a5yO4f"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C1910A1F;
	Fri,  7 Mar 2025 14:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741357244; cv=fail; b=K9WDB5rD1I6PGy7fenWiggfkXSaHsRy6+Q1biiOGd/Ud8wlBKn85MVggcOFSK43iSPKrYNo+HYNXsrng8WpFPqeWSxw4bxRTC+WcLF2/yaSZwBRHg8F8VNPyWxm9UHjbkZSiuBknp50oBczE7MZ5PAjc3yFoY+vNMM5rRxCrjzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741357244; c=relaxed/simple;
	bh=UC/IuzzUqvRodWu8kMsIETMiNb2GK9lXpiO+5MHDpNo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=apoaO3iIBBZgQ83hCFps/UQ4i2XW3Vk2HFEqsgpWPyLvgOVPQy5yMIqV0MdMYBKI2ySSd3ppU3VVksYSRYVn02yEbfwKzOmpiBbME/S+9J3u9NgxTEblMKDF6QZUyPTACkVzdcSmS8ofhjnqftxm7gB7UGj37JgLpMH1Z5sKJGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E6a5yO4f; arc=fail smtp.client-ip=40.107.243.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ODpQ2Dbp38Z85iJNQ9jZxa9arvuY0q5cxa6UiXSu5hcajHeIUBW2NKuopevwE47T7cGLw/I0YI1TXh3a3sddrk50OPNnmwZsnpk3jGLQ1VpFs+y/sR3hSInVzWrMScf5Fjq5JRtfmHjq0FDtkEYq5PfzSII+cMMVfOAEo0ecfQ3/ln7ItaTb6QjopsWVRIfrr2lbNtyK500ytl2CTYYVkej2IjMTZ3Ch67oOIU8FPr8/JThC9cb8V/Z4lCwOVCr9AFpq/SAlaPEMqoQUNDzln1FWXNhIN05JS0LwxBrOnCo9WuLUAjPf65PlAVCfICrFyRIu5gGsmIuFHl2NOs7mIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OluNW4FsMJp7QocdzAv9E5nvm5DpueMUH/XbMnL5N7w=;
 b=gloViQzV6Cs0ZtXTktFN4liJU0K06Xe7UGoNM5MYbF8PYH8EMexLqnTfvlcF7PqyCuf3t78WwbEz6Mf5m4/4KGBafQGYZYmKORKXV939L5Vu9BqnjwfqvLdfGAn8bReso8fzbx88ZxOOx97uaAEOVTKl+V61aO1i42jiPjxNbaeYnpfKeAfgyfDBgCaDz7rhhPOd4nWRLx4MdA61W6vBr6WdlBDsZHYWldhGlw+MmwGuztMgNWBacIfOmwQOqUEnOM4yHZGQFI6XhWNfTXDEevhjQtF/0wRjkl4YrZWPjm0lvf6RF7e3QXvpAGZK5ia36+xfKQcDYPkFSVsOmo0zJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OluNW4FsMJp7QocdzAv9E5nvm5DpueMUH/XbMnL5N7w=;
 b=E6a5yO4fDouEbZEDRqfiLxe1Teg8Mqutep8IL/pCgxlJaZdgwOIBl3ilzupcwN1XxEYaa2j3qlf/aODz9pGuxb46T9VFlLTZa4g8Iwx/IXFOtEIMijo4Vv+pEhjfhHUEeA4Oq4qU6zm/f0PvBXVYwXTOjW1ya0ZC3U/K0BpOhMU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by LV2PR12MB5776.namprd12.prod.outlook.com (2603:10b6:408:178::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 14:20:39 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8489.025; Fri, 7 Mar 2025
 14:20:38 +0000
Message-ID: <8650a6b6-10ae-4747-af53-81110681abd8@amd.com>
Date: Fri, 7 Mar 2025 15:20:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: block KVM_CAP_SYNC_REGS if guest state is
 protected
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com
References: <20250306202923.646075-1-pbonzini@redhat.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250306202923.646075-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0245.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::9) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|LV2PR12MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: bceb5dd0-7c86-454b-469f-08dd5d833bff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHdRcXJEaEtWTjJWU3JvWEtucjJscUZRQkE3V2NpVUE3MFk5RGxaUVFNQmMz?=
 =?utf-8?B?R3BGRUFrdGlackZsNmpQVjlTV1VFdWQrdWE2cmZYY3liMmxFb29ZcUoyL0Zo?=
 =?utf-8?B?WEZUTU8yNFc0Z2w3TUNPK0VUNnZkdkt2MDBxQnNnNnVMNGp4ajRvZ2FMeFZZ?=
 =?utf-8?B?U05ZbDhwMW44VWdhbW9tVWFRUklnd2dkeDRjVE56Yjc2Ulg0b1dMQnJBVTZY?=
 =?utf-8?B?QlZyRVhPT1lVM2lZTm1tckpJS3FpZ1dMU01LdTFFZUlhaCtNK2tQNmZpWDFC?=
 =?utf-8?B?VXRhQml1a0hXU1kyWUUwVEhYbURoa21sUlJEbEl6cm1QUWs4QzhXSit3bDA5?=
 =?utf-8?B?M2VkRFN5NU1NWC9hTkxVeDNBZDZSSmxzMkdud2loTTcxYnVqaFlaaGN0VHBa?=
 =?utf-8?B?TDNHUDE1VGNTOWFPVlJpamFFN1NhRmkxdHN1NWdVeitra1R6NGJQQ3NyOEtR?=
 =?utf-8?B?anVDQXpuOGtLczlWTWhSR3I5alh5d2ZsMU1HMlRuNXlnMGd4elFpWmllZG54?=
 =?utf-8?B?ODdRc0d4bkQvdjF4bVh3dUFMckxxV1BKcysweGpyTERGeGVPd1F0T0lSRDVu?=
 =?utf-8?B?bFhob1doSEg2TVFqNnl5bHdNODE3ZGd6OGNnaXFhd3dmUElCVGxIT1Y5a01Y?=
 =?utf-8?B?bW95QWc4SXVHSjRiam1rS1IySUgwQzdUM3BJOGh3TDlFczQxTTJTaG56akJY?=
 =?utf-8?B?bWpvcFFiQ3FodEJPR2dHZnYzZGtvTGd3TmxTNHM1bXQ1RWNHQnlEY3BsL2xY?=
 =?utf-8?B?b0l2Z2g4aFdSdklyK0x3T0gzUXV2WDhLdi9ubGM2UW82RWZHT0hsODkzL1Ri?=
 =?utf-8?B?Ti95K1E3NjlrYVhNeTlTNFMyVllZWStSdDJEU2c0TFRyWldLQ0t2R3RJTjBZ?=
 =?utf-8?B?L1VUcUtKQmxrWDB1M0ltc0lpR0VMamlqVWFNNExaT2FDYTJiaFkzSkFTdlYz?=
 =?utf-8?B?YzJXY0daRXpIQWkxazJVWXRYZ2FkY1EvUVBEbVRmS0IyeWZhbmJiOWpKY2hR?=
 =?utf-8?B?R0FNcWlIUTlXckdtQnRacnR1U2NwOGliNFBBbkpOa3YwcTZaUlplWmlHT2dv?=
 =?utf-8?B?VjByS3ozZzgzc0NWWlJPZDhTQ05nUldPNDZHOEIrcXFFRkt6OGlXU2d1Yzhr?=
 =?utf-8?B?NTM3V3dHZHh6amJ3aTdpKzRYQ2FoVU1INWVtOTZ5WTFHSkpvcnRFWEY4T2ZC?=
 =?utf-8?B?SVlwampPQm50TkVyZlVETWI4ZkF3UFMxQ2J5cnJ6SmNNTW1oaWxmYnd5em0v?=
 =?utf-8?B?QjRpVmNBbEZVT0lDbzQ5enVQbnNHUktWcUVVTG5Gd0l3YjEyRkdHNjJkSkxP?=
 =?utf-8?B?eEl5RVc4eVp5RUJPeGd6djlpWi9oYzRPOTdHUllobWJVMllSWjYzam4xY3Yw?=
 =?utf-8?B?MXJvWTNXcU1EYjZDeEJoMGxuazgyQTY1eWluVXNWNGY2TVFJQUs5dlN4cDQ3?=
 =?utf-8?B?QUlJeTZ3UkY0WVJqZndIdk5vTmNadlpOWHozdWpSc2M3T0Q5WWdBdTdiTytm?=
 =?utf-8?B?OENrRENTTjg0VHVRci9zaXhqNE1rOExnZ0xIV3hueVlVSndkRWwrS1h5bGNh?=
 =?utf-8?B?VE1hdXEvUHU3VTRFVHRRWjRoSDVpSlFoQXRsajY5Ui9waFNwMk1aTzhVdE42?=
 =?utf-8?B?Nnd6YkpKemQ5empFcDZrWG5HcGhaOFNReU9uUjRRQWhaL21XaDcraVplNnFp?=
 =?utf-8?B?VFJQNCt2ZzQycGN2RmF4T1FoNzJsc2Nza0hWV3pRcEFTYUYreGNJank2UjVZ?=
 =?utf-8?B?cERVNEVCSzJNWmlCK0NMTzI5RDJyclNBdmk0T21EMjk0c29uU2FjaUVNdzVu?=
 =?utf-8?B?M0pxbEI3TTRwTFFyQUdMVVhtdVZxUUlxVWR4RVF4NWwzcDBHNVdKTldiSFRy?=
 =?utf-8?Q?qwFJA5bZsKiCc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTFoUjhOd0ZWc3ZPWDRJbmdEVnFHeHR4UGJLU0JEUi9KcVl1WlBLbXFuTGMw?=
 =?utf-8?B?SHJqN3VHeHltYnplRVRndHVtYzd0QnZaOUUzVWxSSnRnRlV4WGs0bUVRZ2JH?=
 =?utf-8?B?RUx2Sk9pdVE0RjNoNmtucHJMKzRpQ1g1b2hvVkpqbjBQRisyRFMrQnVpM1hQ?=
 =?utf-8?B?UG1vdEt0Yk15VnAyTkFvNVprTnZUMkhEQjdZRDNDd3JTYjQ0dWFOM1pXRW9n?=
 =?utf-8?B?TEU1ZkdERGNLV3hEb3BIaWFnSWNjYkRYaWhwc1FHQWtoZHdVVXpTMEVKZDZN?=
 =?utf-8?B?UlpwcTZRcU0zK0Vlem5tb1VOZkpybDRPVnNoUEJGZEFsWlJJcTk5OW1vOWl4?=
 =?utf-8?B?WnVpY2Y0UzJJT0xMdXdwSGhhdktkZDh3MmxoRmhENTZUUTZJTlRVVE9TZS9u?=
 =?utf-8?B?dEkwaW9LUGFNbFhSdzI4MXVxT3YwN0NFOW5YVXRYUDZJa0ZpaEFzcEtJT3Nl?=
 =?utf-8?B?VVc1N285TzlHaXBpNEJuZzIwQ0VaMVIyWTBFcTZVZm8vV053Y2VDUEp1b1ZE?=
 =?utf-8?B?a2ZPazM4eWh2R3YxR2ZDK09Kek4zcnVjWW1oeDdwY3J4dmx0ZTVwY2Z3YmRY?=
 =?utf-8?B?WGZJZ3o2M21NK2hpTExlcHRUNFp2K1hlbnlXR00xRUwzcS9sMVNuOWdOWWVF?=
 =?utf-8?B?VnlBRzlVenVSOEV1RmJUN0RWNFRETkRyczlDeEE0T1hTVUpNblVPNG9FdCtJ?=
 =?utf-8?B?aVlwb2JDU3NnMkh3dnhmekRBbzFTT1Z2a3EwdUVLY0l3d255cnR0azRjM0Q3?=
 =?utf-8?B?VUpNT2lLQUp3R3FhZGFLdFIzUFozODgzTnVsNGhEZ010azd1elVnczc5dVFx?=
 =?utf-8?B?ZHR4RlZLN0NJellrVEVJL0duT2JiMjNxM2FxK0Q5d1dQa2FkMmx2blF3ZFRS?=
 =?utf-8?B?MzVjQTZHMEp0cmF2WHk5T2RSaDlXNi9qUnQ2TkhIMy9FWWp3VzBpS1BYanp2?=
 =?utf-8?B?YXZ6MTdwWG1IekFkVy9iYXZyaG16bWtEdVoveU5rbGRkRlB0SUhVdUxIcWkw?=
 =?utf-8?B?RlZIcGFVaUJjand5SFEvYk9NdmlMVjIxK09aS1I0U2gzUWpKTVRFVkVoOXJ6?=
 =?utf-8?B?UTdMNEpmZlpwRUVBU1IvYkdwZldNY3kweHVvWjlBL2lFNnRwVllFOU5aNWNj?=
 =?utf-8?B?M0sxL0hkWUxkT1NxdExxeC9FZzJTZHdqeVl5UDBHaXZZNVdiRjkrTFBjb2xC?=
 =?utf-8?B?K2d5Q3ozK0dPd2JheGRZUkUxTEwxcXpabmpHbXpFL1FGYk9ZTmY2VFpHNXlS?=
 =?utf-8?B?NXp2VmNJWFkrV3RWNmRpbSswRlliZmZSQ21rc2JIZktQQlZYQ2RLdEtUOE9J?=
 =?utf-8?B?eFc0R09OWnZPQVVEQVJxVHlvckpOZmViOEVoTEVjdzBLQzF4MFZSSmtjWW1M?=
 =?utf-8?B?Kzh3enFRZS9nL01YdGY0cFZld3lPN3YvWjNSdkk4VjFuS0gvQzN6eFNoNTRC?=
 =?utf-8?B?R0F3ZEloU1E1R05sOEI1eHhuNFY0RlY3SmVrTGtybllDREhYZys2aU8zajNO?=
 =?utf-8?B?cVh5M0ZLVEhUTnpUT1lxVjdoS2lKanFvVnJrQklscjA5RnVJYzh6ZEwzampo?=
 =?utf-8?B?Yk9QM0c3aTlyTkVKRDVHTTMxb0xWNU1Ba2lmSmd2ajRsMVhwUVhRSGJpUFV0?=
 =?utf-8?B?WEIzaGFTQy8vMVVsR3pjeXBJTjZoZC9aWWtwZHZ3QzJDNWtVRDJKSmpDRXpC?=
 =?utf-8?B?aGZDNTdBWWV0QklvckNJcnF1M1EyakZ4MHpjR0ZhMnUrY2k0K3Q4TW5tUGF1?=
 =?utf-8?B?bndPaUkwK0d4dlhJUmhWVnRxdStTdHREV2oraDY2My9KVkJiRlk5TG1MWWxH?=
 =?utf-8?B?ZXowUGNGL21veGVNVWk1Qkt2UWRUZDcwcGpFSUhDUFZrWVltOUdFQUc3L2hh?=
 =?utf-8?B?eFVxd0NvckxvSzhnbXI3L0YzM3h2WTZCcDZuU2swUHJsakxKcUxtdklrTUo4?=
 =?utf-8?B?S0JOTkVWbXlvSm0wcEQzM0FqU2NYZk52Y3hSNFdUU2FhMktmN1J6K3NoU2Nj?=
 =?utf-8?B?VlFBZVJRdHgyT3FuZytkbkcveHhCZXZhRHN4SWczZU12N0pERUR4TlFMMHA5?=
 =?utf-8?B?UGNHN2VlelFCTHc3U1Bta1VISllLN1NpTG5wM1hDMlZkdlpFN1ZRTm9JbXAr?=
 =?utf-8?Q?eTVa1TdLnDAXzEitDZ4oEOYMG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bceb5dd0-7c86-454b-469f-08dd5d833bff
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 14:20:38.7725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3XdcYC0fGbtu/vKyp6KnleV0ZNVFhZ8wsKnITJJPKrP/DZATzkcl2E/IXX3HgDA5s3Jbu7k7UgtOe5K40LWw+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5776

On 3/6/2025 9:29 PM, Paolo Bonzini wrote:
> KVM_CAP_SYNC_REGS does not make sense for VMs with protected guest state,
> since the register values cannot actually be written.  Return 0
> when using the VM-level KVM_CHECK_EXTENSION ioctl, and accordingly
> return -EINVAL from KVM_RUN if the valid/dirty fields are nonzero.
> 
> However, on exit from KVM_RUN userspace could have placed a nonzero
> value into kvm_run->kvm_valid_regs, so check guest_state_protected
> again and skip store_regs() in that case.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

Also, boot tested a SNP guest on 6.14-rc5 host with the patch applied.

Thanks,
Pankaj
> ---
>   arch/x86/kvm/x86.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index aaa067b79095..b416eec5c167 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4586,6 +4586,11 @@ static bool kvm_is_vm_type_supported(unsigned long type)
>   	return type < 32 && (kvm_caps.supported_vm_types & BIT(type));
>   }
>   
> +static inline u32 kvm_sync_valid_fields(struct kvm *kvm)
> +{
> +	return kvm && kvm->arch.has_protected_state ? 0 : KVM_SYNC_X86_VALID_FIELDS;
> +}
> +
>   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   {
>   	int r = 0;
> @@ -4694,7 +4699,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		break;
>   #endif
>   	case KVM_CAP_SYNC_REGS:
> -		r = KVM_SYNC_X86_VALID_FIELDS;
> +		r = kvm_sync_valid_fields(kvm);
>   		break;
>   	case KVM_CAP_ADJUST_CLOCK:
>   		r = KVM_CLOCK_VALID_FLAGS;
> @@ -11503,6 +11508,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_queued_exception *ex = &vcpu->arch.exception;
>   	struct kvm_run *kvm_run = vcpu->run;
> +	u32 sync_valid_fields;
>   	int r;
>   
>   	r = kvm_mmu_post_init_vm(vcpu->kvm);
> @@ -11548,8 +11554,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		goto out;
>   	}
>   
> -	if ((kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) ||
> -	    (kvm_run->kvm_dirty_regs & ~KVM_SYNC_X86_VALID_FIELDS)) {
> +	sync_valid_fields = kvm_sync_valid_fields(vcpu->kvm);
> +	if ((kvm_run->kvm_valid_regs & ~sync_valid_fields) ||
> +	    (kvm_run->kvm_dirty_regs & ~sync_valid_fields)) {
>   		r = -EINVAL;
>   		goto out;
>   	}
> @@ -11607,7 +11614,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   
>   out:
>   	kvm_put_guest_fpu(vcpu);
> -	if (kvm_run->kvm_valid_regs)
> +	if (kvm_run->kvm_valid_regs && likely(!vcpu->arch.guest_state_protected))
>   		store_regs(vcpu);
>   	post_kvm_run_save(vcpu);
>   	kvm_vcpu_srcu_read_unlock(vcpu);


