Return-Path: <kvm+bounces-58656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F59B9A510
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:44:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 270927A41F3
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191BA30AAC9;
	Wed, 24 Sep 2025 14:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dSsuZ7OO"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012027.outbound.protection.outlook.com [52.101.53.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE31C3093A1;
	Wed, 24 Sep 2025 14:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758725025; cv=fail; b=qOCbJqs1reptS29nFMbgn5o9ok62UGiLtWnY3lgbv1dBx+UtAAA7SJiL1bB1iRks/lZPDiKUSmj6jTXw/cp4qrm7kqy7pHR9ur24g8hAGNmUIqT0KWDY7DtvTZh6vtn45sKwos6W91gdWNutVYw8s5uKdegyK3Ug6vT8NtXd9HQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758725025; c=relaxed/simple;
	bh=0JYhS0UFIZ3feXFHpBDC2+JiGbUKew93l6lSF5UaKLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nTb0qvAPuySSBzJWRiw7+ETFa+NsLJJZTNviv+02/QvzQBzhaZd020UlpgPrUoA+3aRCcsl6fjYfRDC/mqilA+CtsI1RpRscNMN8dx8gZe7zjtyjXvRXIyXLWjbvRa99SOsTJA84FFXoL0csoZ0Js8fdNoWzwux9/eS1kfyBFZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dSsuZ7OO; arc=fail smtp.client-ip=52.101.53.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=joHyKePRvDVf2wkpydCWILndaGNgV5e7JyuNfJjPFNJRwnAdnMOjup6tzGt6fS+TKehgsREDSM+CfKN9OI8nHVZ8R3yt80R2KKBdToBigi/bTyp2XGtaOdNrAkcL5tWpKo4uAzuh5XwTZ8krx/i+eU72R/T9UvV8pqdzWyxJ/SxuKeOQ6tH5rvlGuJ6pTN/Wb26Fpzs3UyUQMhTDPIVSc8EEYycJyYeZqSjQTbqLc0XD3a4HB5dKx9Uo6xjddzhtXgNkVbw6N98vzwhpT95Lt+P0Dwlub+J4yRb+CL9BUeU6ofNYNkZgryYmpScMK9/RHPOKIc6WvQ4owHssuHEkBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4CNoIyWWca7HCbnxWE1fAczmCiEdpONHWCecFfsui0=;
 b=Scum4WPPfxmzDXyh4f8Lcu64XvtDCyW8kzjmbN9kwbkSauv5xYzs//tpOJrJPkQq04msvm0yyFjZP01pWd0FplfDvn0QBkuvey6WtHcAw4wG2i6RoBqBHVSGU4jSt3Q2rkTtYPpOe/wntlmxko3Uu4cA07mS0nYhMgV04OrOc2r6hDcYVPjgFUir81MOZtWOjwVcY1cCk2gcqWiVbmtC53fO+00CCtBGHWdDzeCD2vuZPdPSpbCZg6q8NwIbwIuMH21baOa+B5hwsVWH6EnwKfYi6gkDNju6obKkc57JUNnvWif7oZraKz6J8qpel4+MpuGZy73ZS68TTyTd/QntrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4CNoIyWWca7HCbnxWE1fAczmCiEdpONHWCecFfsui0=;
 b=dSsuZ7OO0vNn7lUz7bVI/DtrkH9+M3ejrna/82KMV3WC119JoB+0SRgSq2qsK9S8A/1AKiqfBE7SwOFg1jAKg0LMvYyYMSQoRYuMY+hKFXeuaxVkvkQqHbZ2Afnqs8/fUMheq3+rX6sot0VtQmYJGAcOPwgkNnTwDSlMgfO8sfk=
Received: from SN7PR04CA0114.namprd04.prod.outlook.com (2603:10b6:806:122::29)
 by CY1PR12MB9582.namprd12.prod.outlook.com (2603:10b6:930:fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 24 Sep
 2025 14:43:40 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:806:122:cafe::b1) by SN7PR04CA0114.outlook.office365.com
 (2603:10b6:806:122::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Wed,
 24 Sep 2025 14:43:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Wed, 24 Sep 2025 14:43:40 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 24 Sep
 2025 07:43:39 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 24 Sep
 2025 09:43:40 -0500
Received: from [172.31.39.154] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 24 Sep 2025 07:43:36 -0700
Message-ID: <616d8f02-a4ea-4f9a-ad4f-8bcbc2ccc887@amd.com>
Date: Wed, 24 Sep 2025 20:13:35 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: AMD SNP guest kdump broken since linuxnext-20250908
To: Ard Biesheuvel <ardb@kernel.org>, Sean Christopherson <seanjc@google.com>
CC: Linux-Next Mailing List <linux-next@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>, Ashish Kalra
	<Ashish.Kalra@amd.com>, Borislav Petkov <bp@alien8.de>, Tom Lendacky
	<thomas.lendacky@amd.com>
References: <e8ace4cc-eb22-4117-b34d-16ecc1c8742d@amd.com>
 <aNPxLQBxUau-FWtj@google.com>
 <CAMj1kXHxUVowtCqBCKRE2_dv4TSUK6Kgwd46RzjjskAW8qYjHg@mail.gmail.com>
Content-Language: en-US
From: "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <CAMj1kXHxUVowtCqBCKRE2_dv4TSUK6Kgwd46RzjjskAW8qYjHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: sraithal@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|CY1PR12MB9582:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bc22e83-f68c-4071-b610-08ddfb78c0dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eG50SEcvSGdaN0ZScDlwNlpXbmxndSsrVXFYcTZXVkZLbVJ1Yi9mNG9oSGpm?=
 =?utf-8?B?enM2VVlZYUxZUHl0WTFBaWJCdWZJMytjTnJMMGFSSGJ3Y0lTZlZCTXVma0ZQ?=
 =?utf-8?B?VW4zb0lFelJqMFIzRmZpV211S0N3NmJMN1VDZjJGSml5QlNDUElyMExMMHZP?=
 =?utf-8?B?eURZbGJRTUpuc1ZFa3ZiOXo3TURzZjBKZ1k1SGNtMS9HVmdCVFRzWlpXS2xY?=
 =?utf-8?B?YWJNWW9PS242NEp5dHZ1M2V3TlFNcjJXYngxdlQyOHlzKzBWLzk4eHNLcjVG?=
 =?utf-8?B?MzROblpzWS9ub3FsVS9wd3VlY3g5Y01GbFpEc3BueVE4SlVvNkowejJLQ3JI?=
 =?utf-8?B?RE9ra0xEcTY2ejVDb1IvemcxbER3blZtQ1hXbjdTYmRJT2JQcUlzcURiWVNT?=
 =?utf-8?B?aEpucHhvaHJOVmovUkdCRjBCN1Qvd2JRRUdPWWhJRTVVODZPdFN5cXppeWZP?=
 =?utf-8?B?RG53V1JVbVFXY0JyUUxoTUhrUnZkUVlnWVkxb2grYzllUHBqUzNNZEs1RnZ2?=
 =?utf-8?B?RjZKWXY0U3R5Mncxa3F5WldnQnhtMEZFTjRzYUZBQjgrSW1DU09zN28vYXBt?=
 =?utf-8?B?cUpISVdWbFRvQ08ydm4xNTlRd3VtMEJranNDOFk5MFV3a1JzUktOMHEzT1dp?=
 =?utf-8?B?eENrNmZ4WVNmb2dHR0YxZzh5Ri94dW1pU3hpd2k3aUJqSCtGRjhuK0cvOGlO?=
 =?utf-8?B?eXpCZ2NtU2x0bWY5V1lJR1E2U3pOVmlkOE9KdkYwM3Z6L3ZSTUtXT2RORWFO?=
 =?utf-8?B?cUxsamEvTndCMlhiSWNEZkNLYXQyNWMybWY3SFhXdmZqM3JXMkQ5TU5rUTM0?=
 =?utf-8?B?eDE3OE5TZEdNZHhOc01SV2hJM2Y3SGRmemo3UHZVUEpWTTFCUnhEbkxTOGxL?=
 =?utf-8?B?VDRBam9sSjBSd21YWmFYbEJsc1NMbkhoZlVYWUtnYkx5T2xJK0hTWlNaVTdR?=
 =?utf-8?B?QUdYRHBYSkU1RERReWZzRzZaQXRTcFhpQUlwMDE4ZjhZOXl0NmhWVnZnQ1pD?=
 =?utf-8?B?UFRxaHFESVphcDloY2VQMVFHQWRmK0V3RmVMUGEwN3JPcCtkbjV1eUhPa3Rz?=
 =?utf-8?B?aFovOVNhMmRVbkF2a2E4UmFJWXV1cHlPY2Vka0xLUmJ5RVNLMlpkdmE2Ynkz?=
 =?utf-8?B?bGhlR2RkWWZjbjE5Z1BDQzJmQjlzdWxOSERGbXdTMUxLSlZrQ2h6OEZHTmg2?=
 =?utf-8?B?RkFGTW40dG9CK0VHZ3VtNHJjZFQ2RzdaMndtbTExck01dG94RWZzQktGYXpM?=
 =?utf-8?B?dm5XR2JaTTczMUgyekNYdE4xNmFHOWJwM0MwNGY4dFBOdXFFRFhBWEt1azRZ?=
 =?utf-8?B?MitPT1RBTkhpSnk3cDY5UmwrNFQ3SG1MamhWRlpQRW1QRS9OdU02OUx4Y1A2?=
 =?utf-8?B?WHRKUTl5dWtVRmtkcktic0dKdEVSNTlXRlgyQVhUVVA3RThpa0czMTdoRmFI?=
 =?utf-8?B?anVDQ29EbHd4MTBYWmpKbWtIZ2RXTzJid21NREFPcHRUZ3NXUnlKYytFZ3Vl?=
 =?utf-8?B?RU82b3FiOFFadnJ6TkM4eTZNc01ZQ0hOa2lMRzlJSUxReEFPRVIxSEJ6dWxr?=
 =?utf-8?B?UjNjYkZqQktKQnhOUDZRcHpuY2V4OVRuSkNoOVFCU1lFMjZDRG1Rc3ZmdXRI?=
 =?utf-8?B?TjhtUlY1NEhsSDZKYlRZT3NjanFNM2VSUnRldU9hWjg4RVhqcEg2OE8zSkNy?=
 =?utf-8?B?YXdQOTdQQjUxN0ttSVo2eTRxVFFsWkQ0T1JrVkJ0K2F3ZTVzMVllbkVuWWNI?=
 =?utf-8?B?YnQyVGNMY3dyU2FIK0o3eGhkb3g5d3dGQ0V6ZXNXWWl3dFgyK2wxeEJsOWVX?=
 =?utf-8?B?UDdFQ2luazFwaFBwM1FoR2JBTkpaNHlaNHdPVUVKTVVEWDRsVUp5czlLemtV?=
 =?utf-8?B?WlZyN3grMXdRSkxoUWJCcFpIekRPSStIL2pZcWJqcnlvY25iS0ZDd2hPZE5m?=
 =?utf-8?B?VHNvU0pEQmFWT2UwSmk1M2RTcDBOd1JqU05FcWo1eEFVRTRZbkMwQXpzMVRR?=
 =?utf-8?B?cGFyZUZiMDFUelVpaHJScVNEZE1TZ1hCeC8rK2ZJSmFhTTk1UjAxMkd4VlBl?=
 =?utf-8?B?bjBLUDg5UWdJaDdmSHh0dkc3NHJvVkdxS0tSQT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 14:43:40.6211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc22e83-f68c-4071-b610-08ddfb78c0dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9582

On 9/24/2025 7:45 PM, Ard Biesheuvel wrote:
> Hi,
> 
> On Wed, 24 Sept 2025 at 15:25, Sean Christopherson <seanjc@google.com> wrote:
>>
>> +Ard and Boris (and Tom for good measure)
>>
> 
> Thanks for the cc, and apologies for the breakage.
> 
> Does this help?
> 
> --- a/arch/x86/boot/startup/sev-startup.c
> +++ b/arch/x86/boot/startup/sev-startup.c
> @@ -44,7 +44,7 @@
>   /* Include code shared with pre-decompression boot stage */
>   #include "sev-shared.c"
> 
> -void __init
> +void
>   early_set_pages_state(unsigned long vaddr, unsigned long paddr,
>                        unsigned long npages, const struct psc_desc *desc)
>   {

Tested this patch on top of 6.17.0-rc7-next-20250923 
[https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tag/?h=next-20250923].

This patch fixes the issue reported for the SNP guest type. It was also 
tested on [normal, SEV, SEV-ES] guest types, and kdump works fine on all.

Reported-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>

