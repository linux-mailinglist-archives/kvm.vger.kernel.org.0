Return-Path: <kvm+bounces-68051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A4236D1F68E
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 15:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A41F330552EA
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 14:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE0C2DCC04;
	Wed, 14 Jan 2026 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bDPtybn7"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011063.outbound.protection.outlook.com [40.107.208.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DD8280331
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768400848; cv=fail; b=KJ5N3BnXB9MQJ2RWDAt16gnkxvBlkNvq+CT+J/Z//0GX4QIc7cYW8RCOuFWYMghSxEyUR7jvicnSFQ2V/WtsxLfVn/LjzHNptA6B0cd6FeLk8KUJReGALyqooloMekWoL2hMUstFYOOq+YBybYg3xdIaLRSlh06IbTr5h86j2OU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768400848; c=relaxed/simple;
	bh=06vkqr9O/aL1AINWS6/tTKcMqL5W9OsjXIu42QavRjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=plRvVkQx9qQJdGhSb0Alp9SV+3EIlCMmQUvX0cAOe+u5G7YbtC49/z20muM4Hgs/VIiJA/UglK5h7prN6ysc6rTPBxbf6gpqvnXXvFNUcv3t6/2IQYwwMSpEN0Or20sy4PQEbWiv9wWwg6r3xAla+c8tvYmmu1CHbgxSg4EfPiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bDPtybn7; arc=fail smtp.client-ip=40.107.208.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XT0b2Z+BsuA2r2DZ2c/R3ivxEcFxcZbv7bSaLjv5byQLUdQiRGRwFhVY7M68+gNXA1wdyIYHhoM7nPBgPt4CYoVDLk9gryJthMqFXoLbGhwgJmukJR8mdV916xdPLNJQupKWLz1iebDWkTIYs3y5/BaBTU3RMp5x4d+K3PO3JZbw7tryWBVQzKdT13fOIDj7EhO2/7BQ186Y+XcMq+e+chgwN4kZWmt9RIdChaRiRh2+InXS4x5dZ5n4oPiqIAFKZrfRYvUpAMZz8rezqy+j3V/7vg1wO2SqyhNhYINkp3IEeJAlBEqsO7frtwjGs9D704G/V8QkJzpD/KPWP5ZDoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b587gV0IVtPquOeX9f65SBr0TSq76KvZThh815w76eg=;
 b=TGrMFyCMBO62pUam8mT1TcOeIJ7I8XRMGsrFkdAiWCzdXl/eGaRn0AejXTXZQGqbMsHYDfqDoxtqmpDIRGvlzRW1J+qobRoTtw+kfOf63vbT740QteCP0D++Tesd2aZ7BS3CZPTQ3Dc2X4UY+r2yIOXDnXiwvvS/hvFJqv/oBErA6r8XhoNb7Lzrr4JjLuPTeJmBcBcjw4dOlImCBrXWx8lEcuQA2Uq82/egZPQXPB9UqbS2Ks54ISsLcOB0J8z/kr13w3+1/n3Efd7CT+z/jebGW61THZ932zfli2v5A4uiQ8jwJhZPmljuRPo0dl8BwEwck6soJN681Uh38/JdGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b587gV0IVtPquOeX9f65SBr0TSq76KvZThh815w76eg=;
 b=bDPtybn70NKE/FYQjKDh507Sr7+15N/rzDBvesGSSbISPbovZGHmuDKdGRnDm1moaZRrI3tHGOxZEtyXVVuKZytOahTXroES+66apdoTaYedwTASxCt7Ur1yi2P4P2zp8vY7YAqSKNo6A5BI5U2QVElKKNi6FjkeqigKxlqwJAs=
Received: from CH5PR02CA0008.namprd02.prod.outlook.com (2603:10b6:610:1ed::15)
 by DM4PR12MB6542.namprd12.prod.outlook.com (2603:10b6:8:89::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.4; Wed, 14 Jan 2026 14:27:24 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::8f) by CH5PR02CA0008.outlook.office365.com
 (2603:10b6:610:1ed::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.6 via Frontend Transport; Wed,
 14 Jan 2026 14:27:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Wed, 14 Jan 2026 14:27:24 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 14 Jan
 2026 08:27:23 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 14 Jan
 2026 08:27:23 -0600
Received: from [172.31.177.37] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 14 Jan 2026 06:27:20 -0800
Message-ID: <6b2c88b2-ab73-41b2-a467-ee8f16a714b3@amd.com>
Date: Wed, 14 Jan 2026 19:57:19 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/8] selftests: KVM: x86: Add SEV PML dirty logging
 test
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	<yosry.ahmed@linux.dev>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20260105063622.894410-1-nikunj@amd.com>
 <20260105063622.894410-9-nikunj@amd.com>
 <d035cbc079a777d25863b78e9583c238fff03f9e.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <d035cbc079a777d25863b78e9583c238fff03f9e.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|DM4PR12MB6542:EE_
X-MS-Office365-Filtering-Correlation-Id: 5708d746-6761-4e85-e719-08de53790928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHZyL3dhdlhGT2lQcENPVStmN01ObEJRVHMzRjQ2cTdlNFUrK2FyVVA4OGtT?=
 =?utf-8?B?VUtGRFgrRDBlU0lycXZRbG5oemgxN2V5dllYdnlhcWhCSk1idC96dDVMUlFD?=
 =?utf-8?B?VjlZTitJdUd6ZExnVUVaY2QrcFlRVHhrdGM5ZytheThGcElpTEVjZHp3RE5B?=
 =?utf-8?B?eVE1aUc0L0QyNUEwU2NNM2xzVDhXbmVSMFB2Skp3TTVxMkQ5MWp0OGNjVnY4?=
 =?utf-8?B?VHU0Y09ubFVxOUxQZE5XY1JTVDN1UmxuOU5JbGg2Nk9xK3VFZXJrT1U4dGo1?=
 =?utf-8?B?Ui9iQU5hOTRaOFZiZzFkaTd6dDRCcHY4eHV0VTdObzZReldwbElKVlNORDVo?=
 =?utf-8?B?dTMweFpzYlA5czh6UGd6TWVSTXJCd1VSZEFKaVBXaVRvbmVKUzd3WC8rVG1o?=
 =?utf-8?B?b3NBSGt5eU5MamViYWxFbjdVOUNwN2Ric1krOGw5YWJmZm9wcVNJc29leVZV?=
 =?utf-8?B?SU9UaUpxczF4NmhuU2h4ZUZhYVluMWRkSzk4bmVYS010Y09ZdjRpRHc4cHdt?=
 =?utf-8?B?THhpbHNyYWFLTzJRU3R6RUh4RUdKa3FkemJjWFl1WVBXckVrSlhBU3BsS2tB?=
 =?utf-8?B?WS9aMzhQNW5SUGtNT01UdHVpUHJ6bVdMbHUrODN1bituajg1NmlNNDQ5TnZK?=
 =?utf-8?B?emtWZU5WazlmeWs5eWdudkFVN0tzaGhXMnZOU3pEZWpET292R1hGOENXY2dq?=
 =?utf-8?B?Q0l2N2pkWFV1Q0VXVEpPN1Y5eVFZUE9KbC9qL1RCZVRyRTZDeXMrUWhaLzZm?=
 =?utf-8?B?K0xGZzZzRHJZeTdHZXZFMUJkN0YxeEVYQ3c0aXJUY1FmbzJHdzVtWGIwbVJZ?=
 =?utf-8?B?OWVlYmZySkhTMUpTMjdCeW9JNHZQUmJ6TlNoVW9ROTVHVW5sK015a25GeHZx?=
 =?utf-8?B?WjlQZDhtUi9Ga2lWelNxTURXdk9pYXdHeENFM2huQ3ByZFFCZXlzTTIveDVE?=
 =?utf-8?B?NGJ5emF2TVlRbzBlNFlWR3k4Y2RmeXpsS2lZc01Bczd4TTA3OVdtak9SVHZi?=
 =?utf-8?B?MTNFb2Y1aXFpVVFHR2REOWRTQmlYcU0vVkdVUFpTOWVwc0p4NGEvVzVZRnh5?=
 =?utf-8?B?VXdEVEpaS0M2WWlxZHFqeW0zWmExa1hsM01FU3pwVStTSGtlL3AyampzeExI?=
 =?utf-8?B?TEJyWFdIWG5MOG5yTk1HZElDVXlkZ0ozQXpYNTV0cDAzbjRCVUZyMVg2QUNM?=
 =?utf-8?B?Njk2aytja0l3Vkc4RHZ6YWRkT2JEMVp2OEhtQWpKNThVOGJSdTU3V2dzQVpl?=
 =?utf-8?B?ZnNzTnBrMTZBVStCbmFWMWxsQ3IrcE13WThsTGpLbjlHZjhrc3RVc2lZcGhE?=
 =?utf-8?B?MkkzZUl3aVhWZ3dxSUloYk9UM2YzR0V2cXBtUkZZRU9OTmlVaEJUZEJZcHNm?=
 =?utf-8?B?VHZNN1hOdWZCWWMvQTl3V1NwNEhSU0h3alQ1bXFRRE4veFZnV0UwbkdJOEJy?=
 =?utf-8?B?alFsN28rUTg0Q25PZU9WcnhieEkxSFR0TWdQY0hMbkxtNExZRTBZSmtnaHpy?=
 =?utf-8?B?ZkRiaUNJcVk5UXVvT2JWN1N2QXFwaURta0pVOFpuSmNVNHpSRjh2SEJUZk9j?=
 =?utf-8?B?RVo1eWFtSWhJTlRsNnIwZ255T0czeXR5M0JOUUZuTHh2UG9JUEhLbUdLblF2?=
 =?utf-8?B?Qk54Vk5hbzRFeXBlMWYvZW5WVlVwa1kycDl0Q0NRbTZlcmRITXB0SzhPd3JX?=
 =?utf-8?B?QTZCc0JnTlRTdnJnc0J5S3dsdi9Fa2hvTlArN2Ywc0F0dEloTmpVRnl0a2pm?=
 =?utf-8?B?NWJsbEVNaE5SMjhWbm1pbjFmRWp5VEI0akhGWWdoalJJMEtJQ00rTVJOUm00?=
 =?utf-8?B?Ykx1WVRKTms2dXlZeEdnNmc2L1pSdlZXSEQvTDZmTUFobUp2bmhkVU9mMVlz?=
 =?utf-8?B?OFBtd2YrcksrTVAxd3NnMldkQUJPZlNyVHoyVnhWaXlCY1JZQ3BWT2VDNXZj?=
 =?utf-8?B?bm1RWGtXVDl0WmVTWXlub1loUkVOclJEYkRFMDZVZUtDWjRXZXJHWUJVREFh?=
 =?utf-8?B?MTZQY1p5NTduN2NLbmJGb0NjcXViaUNud2lBMWpjY0swdVRoNmpDTTgxaUNw?=
 =?utf-8?B?SDZkOHB1U2FGSVJsKzV5VEg1OGFtR0tGL091Y3YycWdQQ082RWFxc1RZLzNO?=
 =?utf-8?B?MktEQ1Q2ZjV0NkFVWU80UllKWEhTMDljb1J6czdWYzJkMVBRMTJQRVJsbmdJ?=
 =?utf-8?B?T3hOSS8yUkRFM3Rha3RUVndvOUFMMkJCcEZkY0tUQjRiTWRMaEFBWnJFMzV0?=
 =?utf-8?B?Wm1zRUF2YlpQY3JyZElXellXRlh3PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 14:27:24.2483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5708d746-6761-4e85-e719-08de53790928
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6542



On 1/14/2026 5:06 PM, Huang, Kai wrote:
> On Mon, 2026-01-05 at 06:36 +0000, Nikunj A Dadhania wrote:
>> Add a KVM selftest to verify Page Modification Logging (PML) functionality
>> with AMD SEV/SEV-ES/SEV-SNP guests. The test validates that
>> hardware-assisted dirty page tracking works correctly across different SEV
>> guest types.
> 
> Hi Nikunj,
> 
> Perhaps a dumb question -- Why do we need specific selftest case for SEV*
> guests?

As there was a request from you to check if SEV supports PML,
I wrote this test and thought to send it as part of this series.

> In terms of GPA logging, my understanding is there's no difference between
> normal AMD SVM guests and SEV* guests from hardware's point of view.  So
> if PML works for normal AMD SVM guests, it should work for SEV* guests,
> no?

Yes, that is correct.

> 
> FWIW, a more reasonable selftest case is we probably need a AMD version of
> vmx_dirty_log_test.c[*], which verifies PML is indeed not enabled when L2
> runs.

Yosry has added the support here [1].

> 
> [*]: see commit 094444204570 ("selftests: kvm: add test for dirty logging
> inside nested guests").

Regards
Nikunj

1. https://lore.kernel.org/kvm/20251230230150.4150236-19-seanjc@google.com/


