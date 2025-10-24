Return-Path: <kvm+bounces-61026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 140D1C06D7F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 17:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EDD83566AF1
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 15:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661D2322A25;
	Fri, 24 Oct 2025 15:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5QATSjXP"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010068.outbound.protection.outlook.com [52.101.46.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E6F322A0A
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761318016; cv=fail; b=PPpBePpN6evLMHz3ErvQmrWRARkMH2YXS+s7bA/BnJCne7FsyMj7XPdWjfBMzdEZvjQ0KpPwC7ElsRujhaaeHlJmP2P5vCAvDlrwCadQhXfZ8kFOIJGFsVpa2LM4WDtCx+rl96eioRWG1BaSg5MDzUOAhk4pjgIh1Q134tbjWPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761318016; c=relaxed/simple;
	bh=uBpaezMwWS0L9s76b4i5AW5uTziP7VknajW1yevQ63o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s9e3J+8h7vr8GgYXlJlFDylZ5LOQsroJRUGOGLTA/Ayu9CCCTg5iHqy5aijIIy68LgeeNsvu4XeI/R3YJMW/OrpDuaHmdL3B+7pOWQjgDPE6e6p4GASXq+BKBMNnbDKoAMvfe6tQs6vkrvb8FAnnNaUjAnjqp5DFmXJE3xkHCBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5QATSjXP; arc=fail smtp.client-ip=52.101.46.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5fq9NESpd/Es7cwySPvnsw+Vk1xyMlq1gXlfDHzmhOqKsa2Y45KRNqCkaVXvrCyRDU8Z7Uw9fQE1A7OQumYJ+EGnSLi4b/Ozacfh5yBNdicfYsiY8RqXzwod1MRRP0M3oEbYVywKOHPKLgG9ft6vNzTDjdociwI9aZq+vmQSRQDN5+1UlphPCpoB3UKp+tVOWMoSL6vBB683UG7uiPUMskJe0CU3tctOuFPbTWTV/IzN1E3kFnYUvwFQcMPUyFPDZZuiDaW52/atvuii6MzS0D4UQP0iEBT7bxWClYc+JHTtM6okgRryjMQLf95VajjjBkBgN6rPUG6VNw0ERU9Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cjrRmogqKVdjs64vINg9fA+U1JQu3LFUK5M0IjkGCk=;
 b=itcOYiL8cvU4Vvr8HSZjSZAjvvw9+olaGWW1Vq2WrBqYFV+lGMo1wAJaGrmVj6iVA8gRBOCCjgNe8Fb4knILBkAaT/swodR0FY9EVDQh8Yoj0BWNsgDfj27q5IdCvz2+DtO6bh2GCTe2+0cJYUJt+X+M1NiT+Iu/mZjAItX9eziVIoUOq5sKt0VAtgJnkC6WcpCktbJh7ricWMzrn9IuwibSDejHY5TpIqQR7w+/25Jj20r8OEes49GYtC/uTNTDGne7eOYIZoIBp1fBNVufg9StCy2m2bouItfD4JKMloKLUxL5qswNSLR2XaLbDG1Tp35uacDskMsWC5qUkv+Uxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cjrRmogqKVdjs64vINg9fA+U1JQu3LFUK5M0IjkGCk=;
 b=5QATSjXPLRcaAjzan2Cn4hq0mB/w4nUBbAnIj+Rv4wgBTsYXAvuBPR1KAmpxgHD6Er3WISwT0XieZkIrgnpgZgV5e6KHMyb0IDtGhnQR0NNU2BywTPnJ1bDZPY0LsoXx6pGpR21j9IxhfJPoTKzMH3FvjGZpV2OwKRg0eksLZMM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB8789.namprd12.prod.outlook.com (2603:10b6:806:34b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 15:00:12 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 15:00:11 +0000
Message-ID: <a8a324ba-e474-4733-b998-7d36be06b7f7@amd.com>
Date: Fri, 24 Oct 2025 10:00:08 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] target/i386: SEV: Add support for setting TSC
 frequency for Secure TSC
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
 kvm@vger.kernel.org, Nikunj A Dadhania <nikunj@amd.com>,
 "Daniel P. Berrange" <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758794556.git.naveen@kernel.org>
 <65400881e426aa0e412eb431099626dceb145ddd.1758794556.git.naveen@kernel.org>
 <6a9ce7bb-5c69-ad8b-8bfd-638122619c71@amd.com>
 <uzfmnzzhz7a7lghdpazb2sphtctphmsj2nyfqnu6erjt44h577@bjj57um7n2ze>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <uzfmnzzhz7a7lghdpazb2sphtctphmsj2nyfqnu6erjt44h577@bjj57um7n2ze>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0007.namprd18.prod.outlook.com
 (2603:10b6:806:f3::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 69715235-11d6-4210-e172-08de130e07c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YjlCU3FNU3hmbGtHNmF2cTdqMlNoQzdiek02eE5pZ0FGTURCcEdvZ05NN2lK?=
 =?utf-8?B?OWFsV3o5enZzWHYrbysxcXZ3T0lyUUt4aXQrMHNDRmpSNnJLUWZtRjJCU0Np?=
 =?utf-8?B?VHZtbEdoQ1ZEN3V6WjhZS1lvUytvTFlBNVc4SkVKYllTTzQ2WUVmSWoyQnZk?=
 =?utf-8?B?RUpqZW1XdnhsZXFYTWhCVXo0UUovK1Axemlna0RITG51VU9vWXR1RE5tU21l?=
 =?utf-8?B?RHpDbzk1RVlrYXM5ME9UOXQ2S0FDTlZ0NVg4Z2ZGZDdUZjVubHkyOVU4T0sz?=
 =?utf-8?B?eHFWQXJ5TS9zSkx2cWFzeVl0RTZ4NUVWTjJDTXBadldGRFhhMHJmdUJ4Z1RO?=
 =?utf-8?B?Z0RrL292aVd5QkJ2aEV5UmhoVytERnRIaE05b0JZQ3NseDUwRFV3VUpzZGtP?=
 =?utf-8?B?WS9qczMrWk1mWktSc1REOTdQNzgvajVyZjh4R3NZSDc0Qk9haVRoL3VmRmYr?=
 =?utf-8?B?bW83aDdwcFlIaTlMcXlGM2Exd1BBcDFqZytVREF0UEFZbDZsbU9ta1pTbnp1?=
 =?utf-8?B?TUY5RENwTWVpTW5hbmFWQnI0Z3QvY0dGM1pvajdJYzFSOFJSenk5MXF3RE8x?=
 =?utf-8?B?NllTNzN4RnVzUjkza3N5N1ppakJFUlhsK2JSVmFzbUJySCt0TC9qdUxTMHVl?=
 =?utf-8?B?bkNDRUZ0NWRlSG5rZXBzanlrUEVYUG82cWp5ZnhtVXYxTkpKOTlpZGxGOUox?=
 =?utf-8?B?VW85Z2s5TW96UHc0cDBNSXh0YTkxcWl5U2NsajViRzM5SXBDdERwcnBlS1cx?=
 =?utf-8?B?ZkJ3bVBlUE5EL01yaE81RkRhQWFEMHZMd25jOEVvbHdIQ2RhSE5xdGN6N1J0?=
 =?utf-8?B?R3Z5bEc0Y0Zma25MSjBiVllDWlMrRDhPcjVYS3ROZXNJdUpOdkRMdXVma0ZY?=
 =?utf-8?B?aklRb1ZwQVI3Q1p2VXRGTDIxcEkxV3R1YTBnajBUelVWamFJK2VycWh0NDJG?=
 =?utf-8?B?QmlCN05yTGVhV1NINU1va29IQ3NUOWN1TU01WkYxRTZyZmUxbUkyMTBJWWNo?=
 =?utf-8?B?TW03Z3Z1RU9veXdvVkVTUHRESjQ1dy9vMWNFVmNUSFRTNUpJY0VtOWNpa04y?=
 =?utf-8?B?UURMRktMZjlUcXJnZUk1Zk9MbURvdGcxY04vcm9vYXdjQzVIME02N0NnQ1hZ?=
 =?utf-8?B?RXhiYkdEb0xhU09yNTZ2ZUFHZlFhN3BadFBJNG02TmJCSFJSc0gxeS9VNjNQ?=
 =?utf-8?B?dS90Nlo0NXhRRVVPZ3QyanZYQUJKOGtucGJGS01PQnhEdUhyZlRMdUtCNmJz?=
 =?utf-8?B?OENCQnNGeTNSZTZKK3lXQmVYOGlvWWlzd2lmZS8rbXAxeTI2SGo5Wms1V0xT?=
 =?utf-8?B?WXNJdzArNHJ2bVhFK2xvc1Q3QUY5S0F3QnFqVEh2WUc0ekVTYzdhOFZIUXJz?=
 =?utf-8?B?NzZqWlVDNitjV3lVUHdjVzdsalhXWU5hRytmdkluQzRtaXZ6S1JsdnhiY0dG?=
 =?utf-8?B?NUQxaG5uaVh5ajYvZld5TzdsZjdmWk50S3lQMzBzTjIya1NmQjJuQmFoYnA1?=
 =?utf-8?B?NUFEZjB3V0gvNEc1WExHb0t3ZzBCQTE0NlZxclFsamhTb0pFMUxZRC8wY3Ra?=
 =?utf-8?B?dElRYXdpY0tJZCtmcEo3czgzT3Y5eDMrRTNTRjUwRVNTaEZsRWZvcU5xMWw0?=
 =?utf-8?B?cXNqTzhyZWVTeE1GTkdQdCtSanFJVERaS3d3WUxoaHd5UnhOeXVQdkIva2ZN?=
 =?utf-8?B?M005Q1NGcDNJTlZFUVdHZ2U3Y2hXNy9YUlFGOXc2YTdiMi9UYUlSNU1EUHUy?=
 =?utf-8?B?T3dWQ214UG15ODd0NEtYUmJsTTVhWWtYajJwdG1HVjEzSXBISDZ3T0QyaURE?=
 =?utf-8?B?dEkzMGVBN1BvR1FzRm5PbERJTC9wS29CK2daZ2ZPb3NoWlVwbGQyRjVxUHJk?=
 =?utf-8?B?NWF5WTdEcDRlVllyZ2piNWtnRFU3VDZzTXI3aGhRTmlvQlIzd3BLbjV4bW1n?=
 =?utf-8?Q?Y+TUpVR+T/FKtA8PQ/+ApzjlCQyN1TRt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1FNQi9jNGVWZlBJRHY2Qm5FSk5VWEpuV1JFcnMyMmtsOEM1M0xpMldkcXRE?=
 =?utf-8?B?Qlh1Snd1NVZ1MlZTVFlsVmZER2RBc3l1SHBwYU41V1NQUHQwbW14M3c4cjNN?=
 =?utf-8?B?dXlPODljL2Z3SGtGazkzaGgyTzR5VGk0b294S1JhT29sanc2RSsxeUl4R2Vx?=
 =?utf-8?B?MkZlSm5SSy9VVlEvNTNZSWpHNG5Hczl0YTJwTFFTdU5WbUlZRjB4ZHNUb21F?=
 =?utf-8?B?b0l3REZqSTFhZnV2SlMvS3liOVNGa2dUK1Q3djVodGdldmxSK0JQSE85ZEtM?=
 =?utf-8?B?Vm10bkwvdXdSNWc4Z2RNRHRpN2FsYmFwZHBxSm9rNjB4UXkzemtiUFZBc0J0?=
 =?utf-8?B?VkM1ZE1HR2VkMEpBYnVQbERBK2x6RHBCRDllRS96b2dtV013VGVKS1Y1c3A4?=
 =?utf-8?B?MnZKUHVRS2U3M2N2ZFNHL0J5S2s0WHdhWU5ZY3gwYlF0VmpqdGFCM0NIZ1Bu?=
 =?utf-8?B?MHFIamNYMlZIQ0Z5N3ZkTUt3Q1JIeTdoMXc3aTFseEtvNXZsNWJFUXFZSW40?=
 =?utf-8?B?UmExaXlVd0lPYk15b2QvSktTNFdydlQ0RUdHUU9XSHk5MkwyWTdtSG1wdXAr?=
 =?utf-8?B?a0E3cG15NGtSSUFMa3VybVBGRExwb0sxR3lRRmZHam5KWWhQY1NocmM2ajFo?=
 =?utf-8?B?YmJnanpEb2JkaS9wemsxVlpDcjIzTFFSUkFQS3FFR083SkNJTXlqNk1aTFpH?=
 =?utf-8?B?bDF3ZENXdGdxK2xGTmtQaWVBczR2RTEzQ1pFOU9FZWVIZEJBbmcwS2k5QzZ0?=
 =?utf-8?B?enhOZDZGb3lxUGFoa3BBdmd5WGVZV0pMU1hXMnQzVjhaRU9sak9KR1FHZCtP?=
 =?utf-8?B?dER1MG5lUWM1a2pPdHlYK0ttcHhBeWphMlRrUDFFYzNvdi9VMyt6SlFlTGsw?=
 =?utf-8?B?QUNRTHlFdmgyT1BRSFNvNTJvNUoyYit6T093b2NQdU9TcDZNVWozVklLL1hs?=
 =?utf-8?B?Vy9sbDdOVnZaRnFHTDBpNU9lZWNoVldFaUFWR1RJR01DdC9PN3NoNEdlU25J?=
 =?utf-8?B?eXczTW9TMGE5NGNud01qZU9iT1ZLMVBmem1uWHBySG0wK21td0l1cnlHZ1VG?=
 =?utf-8?B?L3BnVGpwNXo4SGs5TmV0eVBzZTl1TFFvUnpVdXBsS2loZ1FkZ3RZR1F2K2Qv?=
 =?utf-8?B?S294VG9HNjV2KzBab0FuSUpad3k4aGpHdGhoRzJER0x6TjJ2MUxlQUszUGdj?=
 =?utf-8?B?K1Z3MVg2bWh6WmExVUp1Njk3SDErSmEvTjJncmxKZDBVY0pRV2dLaUUxUmFX?=
 =?utf-8?B?YitBeEc1RFpKMTdLb2JacGN6bG9ZRUJXYWFOQWV0TVQ2M0FCSm9maUdxUWlx?=
 =?utf-8?B?a09EbDk5Z3BsS3lScVRqNlR0eDNFVENMMkY5cnh0ZUMrRzJQTlpIRk1ncHdC?=
 =?utf-8?B?REhlK3dFZlFPN0tWTmNoYnhpVklNallvWEdvRHJUTGIyMGlrM0tvbjg3djZQ?=
 =?utf-8?B?R04vN25nLzdhS1NGZWY3c0JSQzVOb1ArUmxUbVpmWEtVUmJjOGI1ckNkQVhz?=
 =?utf-8?B?SjZHdDVQQzJabnQ0MjZCM1M3c1BaNVJCNWNNTTA2YXZGYjI1c1krUzJTSWxI?=
 =?utf-8?B?WVpZMjBzQ0UrajZFTkQwWjRxVjU3b0J3am1TaS9CTWR5ZndTZmI4NTRGeWtY?=
 =?utf-8?B?RmROQzJXOTRycEhKTjRyU08wNVY2d2hqVW1aQWxLdzBCUlFrSzROcmRvNjR5?=
 =?utf-8?B?RUtIcnBhODkwR0hKMmU3M1dhdmQxK3dkVmQxQzF0STNNdWRQUkRWNW1UeDVo?=
 =?utf-8?B?aDBUZWsxbndZcmhQNEZpeE9tT3QvZ2pqNmVCVVdqMGprU3cxT01ULzQveFRu?=
 =?utf-8?B?ZTY5cDBkTEtrM1MvRndZLzZWditFcXJ5bExxWUFUSXI0cGVFU2hzeUhXanNY?=
 =?utf-8?B?Y0Nvb0FzLy9qK1d6RUl4MnczZXM1UnYyb1p4Q050bk5TWU9lMHpBY0pnRjI0?=
 =?utf-8?B?TDFydVBmV0h4OExJOUFIK1ViOFVvcnpvSTNrcGh5UlFQWC9HemZvTXpLUEZU?=
 =?utf-8?B?NFJ2VlF3ZXlCdmg4Y0xKektkR2lQN0hKSVMvaXhFK2ZRSGlVbkx1YTlNWjVP?=
 =?utf-8?B?Wk9hczNveklpNk1HekVaR2RXck5lQVR6SXpobitBdy95cjA4bmlyRU5SN0dO?=
 =?utf-8?Q?GyOI/n64O2GPss5nj6Rg7Q0/P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69715235-11d6-4210-e172-08de130e07c7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 15:00:11.6758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lx4zdFNqXKB7dOh3gUzWcYFjXTEg43DIi4n7p4T10/BZ7yvtW7TM0y0v5V2IkfZlB0yi5vDI2Tw7xf0FfUypAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8789

On 10/8/25 04:52, Naveen N Rao wrote:
> On Tue, Oct 07, 2025 at 08:31:47AM -0500, Tom Lendacky wrote:
>> On 9/25/25 05:17, Naveen N Rao (AMD) wrote:
> 
> ...
> 
>>> +
>>> +static void
>>> +sev_snp_guest_set_tsc_frequency(Object *obj, Visitor *v, const char *name,
>>> +                                void *opaque, Error **errp)
>>> +{
>>> +    uint32_t value;
>>> +
>>> +    if (!visit_type_uint32(v, name, &value, errp)) {
>>> +        return;
>>> +    }
>>> +
>>> +    SEV_SNP_GUEST(obj)->tsc_khz = value / 1000;
>>
>> This will cause a value that isn't evenly divisible by 1000 to be
>> rounded down, e.g.: tsc-frequency=2500000999. Should this name instead
>> just be tsc-khz or secure-tsc-khz (to show it is truly associated with
>> Secure TSC)?
> 
> I modeled this after the existing tsc-frequency parameter on the cpu 
> object to keep it simple (parameter is the same, just where it is 
> specified differs). This also aligns with TDX which re-uses the 
> tsc-frequency parameter on the cpu object.

So why aren't we using the one on the cpu object instead of creating a
duplicate parameter? There should be some way to get that value, no?

Thanks,
Tom

> 
>>
>> Also, I think there is already a "tsc-freq" parameter for the -cpu
>> parameter (?), should there be some kind of error message if both of
>> these are set? Or a warning saying it is being ignored? Or ...?
> 
> This is validated when the TSC frequency is being set on the vcpu, so I didn't
> add an explicit check.
> 
> As an example, with:
>   -cpu EPYC-v4,tsc-frequency=2500000000 \
>   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on
> 
> qemu-system-x86_64: warning: TSC frequency mismatch between VM (2500000 kHz) and host (2596099 kHz), and TSC scaling unavailable
> qemu-system-x86_64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument
> 
> 
> Thanks,
> Naveen
> 


