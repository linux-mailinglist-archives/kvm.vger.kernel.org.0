Return-Path: <kvm+bounces-69834-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aP9AOWl7gGnE8wIAu9opvQ
	(envelope-from <kvm+bounces-69834-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:24:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 191A6CAD70
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:24:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BB415301AC8F
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 10:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D3A356A1F;
	Mon,  2 Feb 2026 10:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b="ozJlPHuE"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022133.outbound.protection.outlook.com [40.107.209.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064973563F9;
	Mon,  2 Feb 2026 10:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770027137; cv=fail; b=Nqi1CpYEUamdmTdHhhFG8z7OtHWiNnw517hc5wHHRuMv2zXWdcGPROloe+lFuwRf/CDCagul27vGX3yBqUl6tnrxsLNIucgZO0nmkpLjRsGITqY7E97uzOHiAd1UVK6yPGra90T7ElOWKIfCxBXmxMPz/SeCSnaE4bwiXqgqFpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770027137; c=relaxed/simple;
	bh=UWGbsZQohZKWnKVsaWtAMGYHumG8YtbvDFQiohw63no=;
	h=Message-ID:Date:From:Subject:To:Content-Type:MIME-Version; b=RrMV8qYy5CYEZ+Z3Q7VDvjygsQvEwF+bhp3aLE2N5gZL+DBRYtYOacS5IiF7/uKvRlPaQhIUePprAXO0LNeHFEtcNpDtZSntJ8cGVfqvmE3vMo2CSsMwfDTgK1WcIrAWdvYYBRXJWpbH35r9FkRSPWokcZSVUz/IHgRJ0iw3eAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com; spf=pass smtp.mailfrom=fortanix.com; dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b=ozJlPHuE; arc=fail smtp.client-ip=40.107.209.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fortanix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EcMoata8mAAjoqJiNu54pL0PKVFynmpVaT2DVjlmn8mjz2erHnTVUuUq0Iv06rpOgYauEB4o6UjtAo3SudfShSRFe5jCkFkvnATARQLlKtrvspOaGu7Jk5wMpS1OKCekpZ53NC0L4ypZwveXL1mbv6dB5/oeYQf5i0VDyt0bfE0myUIbzQv0kYYjMlyEjs8Z2wHaQi1KLrTUw5f49csDB40Y2bxZsubkG74WkcRthHympxLGC6GqS8bR5XfGeml4uhpx0H7y4igGvvlj/MGggOrPPrEFo7UwHvZK9H7D7vYbodI4bfLQRJG1ChRX0uLL0M3UuRkrKortsP5sNzPDbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZWkCppMGvnyfSoQfWPoEMVmNg2Lr9AL+jLlQWuyzvE=;
 b=Ja+7iyAOjvzXe0w9Uze2Osyy/H4LssloM60pwHe9WHDNSV3nQMv1DgOd3P2FilCnqm8DhzHpqxu1FRWGLsHjOGsyS4HRcbvPv033BT3u74w5/hc0NGsAtiSwWpjyttglqiZ0wJKpfXX8KjJE0/G10+yhMP2kmk68n6REv4k//h7+JfyEIVyafsHlJ88EEoZBm7NCeBjlpZ6j6/li6ofKHYR+DdNXpkLqe4Hf1n9iZvZKbkEvtuOlCbvBJuu9C13zMFuyubnh8Bb4rSksGgxPwOIe3wHN38Dr2w+SCb+L3kw7FEB1LJQRJgruUiGRRdtSgVb+W+GTasVD3iPRiN31Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZWkCppMGvnyfSoQfWPoEMVmNg2Lr9AL+jLlQWuyzvE=;
 b=ozJlPHuE3453u5zotKIpc3gLxDv6WpVku4LokCjMs5W8dxZBWWMyGrnY7wm29VsKnOi2tK7QHmOnI661qhG96sKVqIqpYp0MgpeG6hbczkM26V4vJoT9t/Ipf4E+b6y77f4iSlb4Av3QRzyM43HcKyOtTxKwk/jaICgO8GumT5c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15)
 by MW4PR11MB6666.namprd11.prod.outlook.com (2603:10b6:303:1eb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 10:12:14 +0000
Received: from PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80]) by PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80%4]) with mapi id 15.20.9564.010; Mon, 2 Feb 2026
 10:12:14 +0000
Message-ID: <20d3a189-5649-4864-81cd-5a421267f21b@fortanix.com>
Date: Mon, 2 Feb 2026 11:12:12 +0100
User-Agent: Mozilla Thunderbird
From: Jethro Beekman <jethro@fortanix.com>
Subject: [PATCH RESEND] KVM: SEV: Enable SNP AP CPU hotplug
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0013.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::18) To PH0PR11MB5626.namprd11.prod.outlook.com
 (2603:10b6:510:ee::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5626:EE_|MW4PR11MB6666:EE_
X-MS-Office365-Filtering-Correlation-Id: 262ce4a2-c220-440e-1bbf-08de62438949
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVhKYUFKV1lKNlBSQkR1QlJxdCtFYi84K0RYOWV2K2hKTStBM0JXRldma0Vh?=
 =?utf-8?B?UGFsRXF6ZHVVSlhSRDJpNW5iazdLd2ppUHExaHNMQ3BMY2VuQWQ5a2syTUt1?=
 =?utf-8?B?L3loZlBjakpqZW40RjlKdTFxN1JDUFRXb1YzMjB3TSs5Rnh6bjVhWis3NEE5?=
 =?utf-8?B?WW9ybTR4dTN3NGJ1cGRtUFZoOGlOSjZ1WERaSEVDUXFEOFJYZnc4cEhhcmhW?=
 =?utf-8?B?T1hsV0NFbUU0b0JkK0tJMm9vaUZjTkhKeTZOTStlZUVQUzBNQ3RCSGlydzNi?=
 =?utf-8?B?L3ZWbmwyaVEwdFR4SFVBc2Q4WW9JbGFpTXhYYkQyNi9RekF6ak9hRWlQRDlv?=
 =?utf-8?B?YXRiMEQ2eDJxMVVyNG9wWmJneUxQeDhvN1pVWmlDclVORVlpZENGVjJxTjAw?=
 =?utf-8?B?Z2lqcWt0QTdRN2EyQzFlZ1phcitnNWM4OUxVd3JuOVl4NUZIL0pIT3Ewb2Ja?=
 =?utf-8?B?enU5RUFOTUpqYmxkbGpqREhYTXRFUXNOZXA3OXpoLzUzTEVaRDlsaDQzS3d3?=
 =?utf-8?B?b3FKWUxoLzNXb2VBSjh6WDZMUTc2bDBlVUtCMTVKUXVlR2IxVm5qa0c2NUVJ?=
 =?utf-8?B?eGFhQ3RTR1liQlZCVzM0MGlaWmtrRUxVSlhIcW43K0diVEgzcTByUTJnRFZT?=
 =?utf-8?B?WElFQU5BSjVQWGVjNmZqMm9pYjZTOWw5OW1BdlpaSWswNDVBU1puVTFHWVBX?=
 =?utf-8?B?aUJDTE5CTjdVczIyZ2ZDSEZBVEpWU0dnN29kS3Y5dk1XcWFJKzAxanA5RzRV?=
 =?utf-8?B?a0VhZG5qeVRreWlvTVVQTm5Eak9xT3FST1Q0U2lFZ1dzTkZGdjJnZDBsQWdu?=
 =?utf-8?B?TXR1NEROb0hXZklHV1pVd3h5a1pHckRRZVF3ZTlpVWRQU2xrOUxNT0V1T2dY?=
 =?utf-8?B?L2tWZ1FtMzNqTVlma2JpRWNOS0xSNVViY2VrRlNYeWhWODNZQTM3QlEzelky?=
 =?utf-8?B?S3hhNXJiK0UvNGFMU25rRk5UajVmOGp5RnMzcE43Zmp4RU9iMUJjaUt4RzEv?=
 =?utf-8?B?U2RLTVlZY1BURTZjbkwwQ2ZJYnhsY1VnWG9pMEs5WFc5Q1dPVDhFS29EbEJM?=
 =?utf-8?B?R0h0VHBDaVhyNGpDT203M1JIdFhxcnJHbEVWMm9xSnV1cnpFVmRPU2tJeVg4?=
 =?utf-8?B?OWk3TWNjSndKaHVRc2prQmFEaXVnWjQ1NWZQbjErWW1aYmhtanhDTyt3N1Zl?=
 =?utf-8?B?S2lrWFBtWVd1ZWs5V216UXAxYkF1bEY3ejF5a1FTdDVyZGdDZUg3NWJTemp6?=
 =?utf-8?B?WmpoaW43eHIyMVZlSVZWYkxGV2JVM28vM0hNZWVtUjQ2UXloN0RrMkFxTnFK?=
 =?utf-8?B?dUpadXI3YVU2WElJaTdoNGVIaGpMUlBGak5GbFRBeVNvMjErdjh4cXk3cUZx?=
 =?utf-8?B?ejY1TkZ5bS9rVE5Fdk9wVEk4MUN0d2dHYnJqY29OZytzd0o3MVVQTFpqMkRS?=
 =?utf-8?B?eFQ1QW9LTnhNU3JmREdyWGs3dUk5Qkc3aFNZM05rTlh6dE9HcFlKenVHd3hk?=
 =?utf-8?B?WmhoNTFtR0UremZlQWp4YWVRYU9rL1RSb2pua2lwZVMwYlNKcExwS1Qwa0kr?=
 =?utf-8?B?dXY2aXZjK2dkR1JLZlJtckVBRHhTK2VsV3dkRWwxeVVrMkduNnBYNW5lVmox?=
 =?utf-8?B?VmNZc25jZFpnUmI0YjlOVHRtak9NS0FYYWxMcXpFVE9HeElxaDFPalJIMDI5?=
 =?utf-8?B?cHREMEp0ak9QaHBzcGFNODl0VEFubnJiTlZWWW51d0pjTzBPNDBNVUd4S3Iv?=
 =?utf-8?B?cDZKWU5tK2ZzSm01NElqOEJTSk80K2xBNW5vUk05YXMxSkh3bktsVjJQZ3k2?=
 =?utf-8?B?QlYzeTJRc0NDaHNlaElEbDZrbDgwL0tvL29EOFQxNlRObXphOTNtZDJTV1Mz?=
 =?utf-8?B?dXI4UlluU3BxVEtQbW95WHZDMEpoa00xcDdITWdJa0VLZGRJRTJRMHpVbnQz?=
 =?utf-8?B?Y25BNXJCMThXV2dUWk5ycFFReU5TMmxPa29OZXd2WmJKSGljalZ2YVlZdjd5?=
 =?utf-8?B?MzZWdTFiSk80UVpUWG1UaWpwUXdDVkNRM3IrWXQrK25oWmJTODZtZDE5RTJo?=
 =?utf-8?B?UEpjNnRpaHhTUldZbHZFc1loSURDN1dISHErUWRmb2lWMFNOWVJJS3JDNHFY?=
 =?utf-8?B?TlZKRjA4TWlGd3JMOGhXSkFJVjIzRDZVNkVENHFDVHNsdUJsc2k5bnM3ei9y?=
 =?utf-8?B?WGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5626.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHZOQTF6Mks4WnhNWFFmdllRcy9VemZMR2s0b1NLTTJEb2JabzFkUTY0YU51?=
 =?utf-8?B?bmNsNlJZc090bU1LZGx6dCt5cVNkTkZSNUU0dk1JMGJpZUtnY29IZUZRN0hw?=
 =?utf-8?B?eHdwMTg0eWZVamVORUpBaHNLZ2JkSmFybHRNdkd3TU14cWk2TnREbTdaOVdF?=
 =?utf-8?B?VjlzRzkxTVVqMEluUkpFbjFidHdTdkc4Q3huRGdtM0NsNFBvUmIvYm80NEh6?=
 =?utf-8?B?a0ltZzdaVE9MaHFWbVdqOVpBSjZ6Lzh1TVU0ZFVublRrTUNnV0pmM2llUFFD?=
 =?utf-8?B?NFJ0dnUvU1p0MjdDa2UzcnBkQ2ZZblJYOFVQZGhIaHNRYkNHc3QrKzhYbHpG?=
 =?utf-8?B?b1NNcC90Zy9aVVFDV2VxUmdLWkEydXVoTGNBYkN3dVFpblhnYnR2bHRsV0FL?=
 =?utf-8?B?SFU5SHdma01JS0RGWnBaQWN2cFA1Z2hQTFdaVjdZNXFaWnBRdWVCdTU1Ky9i?=
 =?utf-8?B?WGRNZURuUFZIaTRiSFdLeExHZHZFZVB3bWxQSFZHd01iK3F5NHR1RDVYOE95?=
 =?utf-8?B?Sm1xeXRTYUJ6V0I0ZEdpQmpOM3NkcDhKWkZJRlV5eUtubHhkWEo0Mlp4TDUv?=
 =?utf-8?B?UXV5RnJnZE5IUlNXZlowdlgyU2FkMWdDUDlPRnhZMnVqVHE2ZDVBN2RFZzVN?=
 =?utf-8?B?UlFIZzkyZHh0NHV5M0k2eVRVT2VNQkYvME1EUTg4dm5jektBbWlTNk02d1hj?=
 =?utf-8?B?MGtkTGQ4SVlvQXMyVTVINmtzWlo4cmdZYThRN1VEbDhjRUxGang3dS9OZStK?=
 =?utf-8?B?Ry9uWERwV1BPWjZJdWcveU9pRTRXMFVhV3ZSSjJZd3dtNGU5S2R0TGJaWkk2?=
 =?utf-8?B?TUp0ZWYwVjBvallyN1VDL0JQOVZmNTRYMnVmeEFEc0gxYVhFam9JeXA4bllu?=
 =?utf-8?B?bzl0czJjZ2RKUjFyNlJTVDc5Mmk4bHZPMGl3WkRwOVg2TUxWTUNBQTR5M2dW?=
 =?utf-8?B?eU5aMGpLNHVQQXZDeTBTU1oyaGd0Zi92aUlJd1BFTzBvbjJzaUdrd0ZkYkpQ?=
 =?utf-8?B?SkdibFBWc0FVOU9KSHA0NnFkQzY2WTNiV1I3YmRnQUFMSld2MHpCbXU1NjBx?=
 =?utf-8?B?ZWxnK1MzcndNNDI2QkdRa1pzdzBzc1F2SEVQOTZkZzRpUlIzeDNObGYwK29a?=
 =?utf-8?B?RU9Tdm5nK2tOaE9NNEpCZGRQcG5YaU1jZURxejZYaVNXYkZ3TVFDYmpaWFBS?=
 =?utf-8?B?Nk94aWpoaXZiaG5WeEd2L2Z3aGFQUUw4cHF2ajV5VTBPQVk3UDBzWmk0d3dV?=
 =?utf-8?B?a1RBNG9wNStwc2hmMkIwSVdpUWpwcm1odWRNeTNQRkNid05wZTFXaHY5TjJa?=
 =?utf-8?B?NHBIRjFDWDFBcm83YkNoZHBHWFM3TEQ3SWkwdjNPV1dIZDI0ZHFlMVdPRXpG?=
 =?utf-8?B?Ykp3Wng5N2JnVFlqNUYxMGRiQzhZVktnUkEwSGg3akZqcDlJYUhtSXN3YXo0?=
 =?utf-8?B?WFhIV3VoeTZnUDhUWEN3Q2VIdnMrNS8ySWVCdW9HYUpHMkV2azlodGUxQWUz?=
 =?utf-8?B?ZHQvdU5kdXJCK3pKT1BkZGNzcDVnTVN0cVIwUS95YWlZQzRXRUdWbTFEblF2?=
 =?utf-8?B?Y2tlSW9DYnRTb3VrWkxMQ0E4UVE4dnhZa3V5Zkx6L2p3aGdCWENvc01pUVF3?=
 =?utf-8?B?a2Q0NU8xdjN5MFVCQU5EVWJTVDR0T3RDUldYSlZPSTFFMWNFYjVXOFhqYzkw?=
 =?utf-8?B?OTduYk1GZG9YTXJhNThFZGVaSXRVUTNQZGlEcnlvQkorbVJOYXYwMURSOEZj?=
 =?utf-8?B?QVdxWS8xMG1jOS9RV2VkczVrMDBqa1I4bkZpUG5Wems3NGVSUVIwOURLcGRy?=
 =?utf-8?B?Q0pHSmhjM3hRcGpVK2VRQ2tOSlpnaGdlR25xaTIrYzRZQUQ2OHo2eUZVTmRw?=
 =?utf-8?B?dG81ajFvU0gxdjBaTlBKU1BMME1ldnBCTmRIYVNhbjg0bi92TU40NmJhNzU3?=
 =?utf-8?B?ZVV5SXFXZGpQaUlZUXpuZUw3bjFucUUwM0lORGF5eEtLclhXWE1VaVl2MS80?=
 =?utf-8?B?SVE5aXUvcXdaY05EVktKcWlUSVBJQTNVK25qRFdhWmtKbFg2YjVvdW8vYXI2?=
 =?utf-8?B?d2VKK2dYNUVnQUIwZHdJN1EwR2dlYVI1Tmh3S1pUcGJjR1FQWlpaUVhzVmlr?=
 =?utf-8?B?Tm5DcVo0T3k5YXRycmVNbXFmU24remw4QnBEK2RrbGxTRWtjeFpmYzNjNEd2?=
 =?utf-8?B?K21pZjF0L0VhNUYxYTlzOTdzTHB0WUZLNmpWVWxrL0xmc2M4K1NVQ1BRRzVr?=
 =?utf-8?B?YldnbEN5YnN4Zk5YZHczWjlld0ZIVmJ2YjRGbnI1b1lkM2ttU2VHKzNENTg4?=
 =?utf-8?B?dTVaUUpLUy9ZMHpCOFcxUWJLWWJZU0ViclFZeDliU0pLR0U4WEtXdz09?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262ce4a2-c220-440e-1bbf-08de62438949
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5626.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 10:12:14.1016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzZJybETUP8ToRXC6Q+7ypevb9UXK/p2mHucmNmIfwL1HI+rbP2lF4erZJCH7/Moc7olQe3I7NUbDXoobIft8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6666
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[fortanix.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[fortanix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69834-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[fortanix.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jethro@fortanix.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fortanix.com:email,fortanix.com:dkim,fortanix.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 191A6CAD70
X-Rspamd-Action: no action

The GHCB protocol states that after AP CREATE (as opposed to CREATE_ON_INIT),
the hypervisor must immediately proceed to VMRUN. Update vCPU state on AP
CREATE so this happens.

vCPUs created after SNP_LAUNCH_FINISH don't go through snp_launch_update_vmsa.
Ensure the vCPU state is updated properly during VMCB initialization.

Signed-off-by: Jethro Beekman <jethro@fortanix.com>
---
 arch/x86/kvm/svm/sev.c | 43 ++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cdaca10b8773..9af1bd5b2071 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -960,6 +960,19 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	return 0;
 }
 
+static void sev_es_finalize_vcpu(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.guest_state_protected = true;
+	/*
+	 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
+	 * be _always_ ON. Enable it only after setting
+	 * guest_state_protected because KVM_SET_MSRS allows dynamic
+	 * toggling of LBRV (for performance reason) on write access to
+	 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
+	 */
+	svm_enable_lbrv(vcpu);
+}
+
 static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				    int *error)
 {
@@ -999,15 +1012,9 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	 * do xsave/xrstor on it.
 	 */
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
-	vcpu->arch.guest_state_protected = true;
 
-	/*
-	 * SEV-ES guest mandates LBR Virtualization to be _always_ ON. Enable it
-	 * only after setting guest_state_protected because KVM_SET_MSRS allows
-	 * dynamic toggling of LBRV (for performance reason) on write access to
-	 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
-	 */
-	svm_enable_lbrv(vcpu);
+	sev_es_finalize_vcpu(vcpu);
+
 	return 0;
 }
 
@@ -2480,15 +2487,7 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 			return ret;
 		}
 
-		svm->vcpu.arch.guest_state_protected = true;
-		/*
-		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
-		 * be _always_ ON. Enable it only after setting
-		 * guest_state_protected because KVM_SET_MSRS allows dynamic
-		 * toggling of LBRV (for performance reason) on write access to
-		 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
-		 */
-		svm_enable_lbrv(vcpu);
+		sev_es_finalize_vcpu(vcpu);
 	}
 
 	return 0;
@@ -4030,6 +4029,10 @@ static void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	/* Use the new VMSA */
 	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 
+	/* vCPU was added after SNP_LAUNCH_FINISH */
+	if (!vcpu->arch.guest_state_protected)
+		sev_es_finalize_vcpu(vcpu);
+
 	/* Mark the vCPU as runnable */
 	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
@@ -4111,8 +4114,12 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	 * Unless Creation is deferred until INIT, signal the vCPU to update
 	 * its state.
 	 */
-	if (request != SVM_VMGEXIT_AP_CREATE_ON_INIT)
+	if (request != SVM_VMGEXIT_AP_CREATE_ON_INIT) {
+		if (target_vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED ||
+			target_vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
+				kvm_set_mp_state(target_vcpu, KVM_MP_STATE_RUNNABLE);
 		kvm_make_request_and_kick(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
+	}
 
 	return 0;
 }
-- 
2.43.0


