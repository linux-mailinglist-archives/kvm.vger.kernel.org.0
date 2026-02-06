Return-Path: <kvm+bounces-70406-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0AXzHc5ghWmbAwQAu9opvQ
	(envelope-from <kvm+bounces-70406-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 04:32:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D8591F9C3E
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 04:32:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CEC1B301C14E
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 03:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBA0F3321BD;
	Fri,  6 Feb 2026 03:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="47K71oHy"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB413265CC2;
	Fri,  6 Feb 2026 03:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770348731; cv=fail; b=PzAuDMVlH5xuMN+fR8JhW2NWzJ8q6Jc+RY0+YEp/pS01zUOHvvIsccqLdywYN05loklSs4CbLC186VnKXMP0fij0PAzHqG1sfkP0R5DTjChj7tMlhl74w41v8yiKwOuzKn8JJEOcR5QQniD5JxoHcu6FasNzaDBEr/hLnzvord4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770348731; c=relaxed/simple;
	bh=P1FaZ577ooEd7JIEWdpZArRwgx1JEw7KEkAgUd06U7M=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=kLhIQLk85/52YysGzo+Isy0XCrCtrQpihTY9mgEIhvOZgEPwPGvIAt3ZCEGcFH7Q9QYtn5VrZd3gDpeId6s2aRBVEcyzLqJIyuMUb/+o4B/eUhEau4o+ukcHWvnr2zAz0QZPxgV4Uz0TxGWqyHvQtqIysQ0h3WrhVNfbRLzDWiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=47K71oHy; arc=fail smtp.client-ip=52.101.56.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OU+nOyLfRWF+ir4fRDVr7UBXd1luqEYejgfu+YRD0jU7mg1RaMcjG4RLqr2n/dMa/ekKKwQSYHuCDi3PngGZ9jeXTGaTGZQDLkqiVhn1UjjcpUJ0Mx/L+Zoaj9Es0Gg1IkIB1Q7e/D7DnwzT7GT5BmCS5LG/37fxQ0zfKXcxlmF/Pc+aHQg1742XeOl8CmxSQ9DgmKEjaFuF13QPXtCyPGPbVhwb12bd0j0D2+2pGGlUW9J0BtlGYpi+5t38v5kkWWI6rhrILadoDhB3PX9cQIoEbEp9wwfrR+BsB1UR5cbHFFXFurG0zKFE4vLqYmWM+bhLXz1VBemaLlRCc9ZhoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXkmrSzhrpqMw92dPVBpQfTQO+3shRMa/PMhr408ZG0=;
 b=wvG9V7DjMx46gp4XNIiBsaZv0KM4eyn08u9FH13AeV/TVRPX29S6Gu/w27sSSYBPflas+mXhNvpS2eC6GZMMmRUo6/NyTEulgs5kRmkn7mZ9FZBKSx77Os5MkxqtOSVYVd9NUfa8uzURgSunjp+z1qS740Czhfat0rod7qwlmbFFO5qdAV/V6Foh1eeqsnoq52SX52xPbmleTTYaXcRNKLuJJUWbU6Yfsg671fxIv7qWJMVZfqvqagGqAtb/QAfLY3qEupIzElE7YqSRWPOxIiCLyyXO1MKgydVkdrEqfHWRKZrqPjRc8ujh6eP0C/Nyrylmcj27AJESdImXzj19dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXkmrSzhrpqMw92dPVBpQfTQO+3shRMa/PMhr408ZG0=;
 b=47K71oHyP++/5znCd+aftPN8KxkFi1Q61OluYWZT2m13dpNnmGMcQURzeDI3eu6TqByYEb6RDdtT3HR09EFemIm86zSIrfzYkSyrAS+H/TRshiaQcEEo9kpJLSyvFxJq1uaV6ygTuduXzyWgP900WF5AFt6w51MDAZz8oXF911k=
Received: from SJ0PR05CA0003.namprd05.prod.outlook.com (2603:10b6:a03:33b::8)
 by DS2PR12MB9589.namprd12.prod.outlook.com (2603:10b6:8:279::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 6 Feb
 2026 03:32:05 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::1e) by SJ0PR05CA0003.outlook.office365.com
 (2603:10b6:a03:33b::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.14 via Frontend Transport; Fri,
 6 Feb 2026 03:32:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 03:32:04 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 5 Feb
 2026 21:32:04 -0600
Received: from [10.136.35.67] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 5 Feb 2026 21:32:00 -0600
Message-ID: <37d4fd07-02e4-4492-b5e0-3618208b5e5c@amd.com>
Date: Fri, 6 Feb 2026 09:01:59 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Nikunj A. Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
To: kernel test robot <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <bp@alien8.de>, <thomas.lendacky@amd.com>
CC: <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
	<tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <xin@zytor.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<x86@kernel.org>, <jon.grimm@amd.com>, <stable@vger.kernel.org>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <202602051859.vGTf24Nk-lkp@intel.com>
Content-Language: en-US
In-Reply-To: <202602051859.vGTf24Nk-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|DS2PR12MB9589:EE_
X-MS-Office365-Filtering-Correlation-Id: d0f0b5f7-f819-472d-e5e1-08de65304c83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0JOd3YwNXp4MEJDeElrQTcwVExHcjJJRFQ0YkdTU3ZscTBIbDBlRVhCaTBS?=
 =?utf-8?B?R2o2N1pxeEgybE1HR2c5SFkrd0RSbzY3R0hBZXJTTVR5azFLZktPM2ZFTXlT?=
 =?utf-8?B?SFNTVGl6Sk9iV25uTWIrd2p1TGdMYU9DNERnd0IyRGttVW9adWNuZjBZZ3Za?=
 =?utf-8?B?bUR1Mjdacmt5NnFhTlZtYVpSTzBjY0JTaHRRR1NjU2owL3dRNzNqY3lwb1NB?=
 =?utf-8?B?ZzZ3dTVGR3dVSTEvWlNVRENtZVR1cngrQXNxSHY3Mzl3R2JNeTZObUcvL1hi?=
 =?utf-8?B?VXg4aDVlZEFhWktQWmh3TXF5OU1xdE45S1F6cmlodWZvRXRSckpkQUFzUGYy?=
 =?utf-8?B?aWJFdkpRYTVUMnY3c3k0VjNxYUtINDIvekN0a1kxUk5rSUJCQ0RrYS9NOGlN?=
 =?utf-8?B?dXZVYmRUTDZzT244SFI0RHo5YUliN1BEek1UWDUxZlpydEZRcG1LTlRYeUtW?=
 =?utf-8?B?NklwWm9uSTJ1MTluRWtjNVQzdnpZL2JmWlY3c1Z4T00zbVVLVWtkTFUxcEd3?=
 =?utf-8?B?OG1CK0paZUl6aWViTEhOL1gxa29kS21pczR6eThpQzdRMTNpK1BsWmVKdVVz?=
 =?utf-8?B?RXAxWXYxYjk5Y0JDTW52ZktEOTZseG9WZ3R2b2Nndm16SUJHeVMvc1RGdVE1?=
 =?utf-8?B?VnM4TDJtRFNCeVNNWEhKU3Q1c0lTNGZ0ejk5RDJVb1gvdUZ3dFFDdmg3Q3Zt?=
 =?utf-8?B?a0VKRWdXR01FQXl4aHZUeHBuTHNFUlJGS0gxU3B1aytrakZXSjVzdjFBN0I2?=
 =?utf-8?B?SmxETmJrMk4xblhCRHhhM1dLaWxCNW1qUHpac2VBVE14N0VmRmg3cEFRdUwy?=
 =?utf-8?B?czVHR2RUMDhaT3ZYUUk1VWJBeTI1YllNbitPR0QwWFdReVQyQnFLK1RmaE9i?=
 =?utf-8?B?aHJDblF1TEJGMkdoeFoxM09oczVDelM2VlM4YS9NalpQYWo0OE1uS0REUjFS?=
 =?utf-8?B?WHZyQ21Sd0tmOUhQQzBlSnZCZGlSS1o5aG9uMFdMUE85Q3hnbS8vNi9QRzN5?=
 =?utf-8?B?bkFZeXJYOW4zN0FQOXNLbUtINEpKbm13cFEybkdyQ29acWJ0MXpLZXg2aHRI?=
 =?utf-8?B?d1pIbm5SOS9DU2lkMFZVM3R6bWd6WFh3aFc2U21kVjdFalorZEtpeWVraUc4?=
 =?utf-8?B?VEdKOWZsWWxpbFh2aEFSdG91VldhV1ZtTUNZcVptdng1ZmNYU1c3UXRPZ0d4?=
 =?utf-8?B?OUFVWkpPYk1qMmFYc29HVC9vZEQzTU5iRU5kT2xmZUh1WHVOeGc2VnRtMlRm?=
 =?utf-8?B?TmdjMytNVXJ5U2NXZGxNcm1aSW95M3JaTVo5SUFpRjdSN2lrQ3JRa1h4S2tj?=
 =?utf-8?B?U3k1eklpaXRxbmtLL1RPa3hPRmJuMk9pbUduL0IwNndxQUppODN2UExaZ3Bp?=
 =?utf-8?B?UlJOLzNCdmxDQkVmQlQvZWFZMGV3SUFvRjh0ek8wWm1pMFNXNjVWL2lXOUVn?=
 =?utf-8?B?UHhxREJuVXBaTVZ2ZmplbG04QVZOMVNYYWJWWmNiQWo0MnNsUko1OWNCcFpM?=
 =?utf-8?B?dTJDbm1oZ1NIc00rTUZ1RXBXL1AvNjA3Q0FJcGRzL3JiMnExZVNHY0VvcHRp?=
 =?utf-8?B?M2hrekZlSTBFQnRTdVpqbjhZWCt5aGFYYlZNKzlKdnF0UVlkRkNGT0h4YUlr?=
 =?utf-8?B?aHlvcGI1QUJXdVBpd0VjMndFbGVwc2VHdnlPZ2NGMFVORllMYUVRYnloRVNQ?=
 =?utf-8?B?VmtucHBmSVp4Vnp3ZzRsNzBWV3QzaHFZWWwvdHZxck5ZeEdPc0d4RlR6R3Fa?=
 =?utf-8?B?b1hmYzZicVhJUnQ2My9SODEyc1ZpZnZSRVZxWTVUNnZaVWJIZ3VUTTFKcWxx?=
 =?utf-8?B?SGNwMjA0UXVJV2RZeVdSRVQwTlhLZ21RNk52dW53SkRKUCtRSjNIK1F5TVd2?=
 =?utf-8?B?NU5tS3FFam5hR0s2UHV1eXhWb21ldXl2SXRIeGRhN1lNMHFpeGUwU053Si82?=
 =?utf-8?B?cUFaLyt4R01MdkJsUDJJN0xYNlIxK3JzeTY0N2ZVVkNrOUloWEFiZGZNMkNy?=
 =?utf-8?B?dS9BM0tOWU5sT0QwOFBXek5Kblo1akVPYUZ6Y2UxcXYzaDhPdzNvTmpmUzlP?=
 =?utf-8?B?RFlqY3l1Zmw0VXBmT2xjcE5ZU3Q4ZGJqU0lvVldzWlk4NVNuVlZDK21TU0Mw?=
 =?utf-8?B?aDNOeHVDYUZxT0pMSHlYWGxHanA4TXVlYjU5bXcySlI0dU1WR05KdSsrZmVC?=
 =?utf-8?B?dEFLY2FNaFZQc0c2dHREYWFob2NNWHo1TXRMRW5uNlpBQmdSU1ErYVpsemk1?=
 =?utf-8?Q?aBwXTxGdx39Iy1cAHJc72JlQefiXfu7B73vWl6iMI8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7MHUTv2z7uHKurumrPmc5a4bVnqvu3CNi51OToCxvUpCXJPcOpBp27JQd5lj1IIrfuoM1c5jvHrkZ1rEUCQXZKfRTMVy2TVD/m7j9P6lcnDnxrsjGBH7O4EWyo2AKkXL3mUL+XPOG1bK/8kbNSe1xcOcQXXPYVxEM/PIsxwXvb9Kcxema/aNsUCd9TICHNydNdAxEVi2O7L7uCkyG6X2YNnhBeGF7+CmLmU6nRzTJTkS2Y4RembH9+bY2HcCR1eTjJ8tEuAkpHYaHbFdH8wfmSPHVwnCgLTiGA5zQQSFOwI2BQEaOLCXd1VleHL/Ogdd3D4csTb8d0HwAM0Q2TOnN+l2B2OfEATJH/0davnW6PANsOsf9Rawj9tfpKAh98XaR80V0hu6rTiIuTrwaggdKSkzIajU3uKUxKuzEaxUUOTuEKbiPkZRHjo6+PWazVqJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 03:32:04.8626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f0b5f7-f819-472d-e5e1-08de65304c83
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9589
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70406-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[01.org:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,intel.com:email];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: D8591F9C3E
X-Rspamd-Action: no action


On 2/5/2026 4:11 PM, kernel test robot wrote:
> Hi Nikunj,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on 3c2ca964f75460093a8aad6b314a6cd558e80e66]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Nikunj-A-Dadhania/x86-fred-Fix-early-boot-failures-on-SEV-ES-SNP-guests/20260205-131359
> base:   3c2ca964f75460093a8aad6b314a6cd558e80e66
> patch link:    https://lore.kernel.org/r/20260205051030.1225975-1-nikunj%40amd.com
> patch subject: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
> config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260205/202602051859.vGTf24Nk-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260205/202602051859.vGTf24Nk-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202602051859.vGTf24Nk-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    arch/x86/entry/entry_fred.c:213:11: error: call to undeclared function 'user_exc_vmm_communication'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      213 |                         return user_exc_vmm_communication(regs, error_code);
>          |                                ^
>>> arch/x86/entry/entry_fred.c:213:4: warning: void function 'fred_hwexc' should not return a value [-Wreturn-mismatch]
>      213 |                         return user_exc_vmm_communication(regs, error_code);
>          |                         ^      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    arch/x86/entry/entry_fred.c:215:11: error: call to undeclared function 'kernel_exc_vmm_communication'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      215 |                         return kernel_exc_vmm_communication(regs, error_code);
>          |                                ^
>    arch/x86/entry/entry_fred.c:215:4: warning: void function 'fred_hwexc' should not return a value [-Wreturn-mismatch]
>      215 |                         return kernel_exc_vmm_communication(regs, error_code);
>          |                         ^      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    2 warnings and 2 errors generated.
> 
> 

Thanks for the report, below patch should solve the problem:

diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index 7a8659f19441..9946b9e96692 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -208,11 +208,15 @@ static noinstr void fred_hwexc(struct pt_regs *regs, unsigned long error_code)
 #ifdef CONFIG_X86_CET
 	case X86_TRAP_CP: return exc_control_protection(regs, error_code);
 #endif
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
 	case X86_TRAP_VC:
 		if (user_mode(regs))
 			return user_exc_vmm_communication(regs, error_code);
 		else
 			return kernel_exc_vmm_communication(regs, error_code);
+#endif
+
 	default: return fred_bad_type(regs, error_code);
 	}
 


Regards
Nikunj

