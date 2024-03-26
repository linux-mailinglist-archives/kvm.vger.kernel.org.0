Return-Path: <kvm+bounces-12701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D4088C453
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 15:02:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0ECD81F65DD4
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 14:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E729176047;
	Tue, 26 Mar 2024 14:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="peikkJxU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2125.outbound.protection.outlook.com [40.107.220.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BD684D1E
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711461710; cv=fail; b=Dr/XlBsCpKIt+wEu48ryvyQ3cheecPJW9aYWpEqvpy6ASOlqi8PkKa7WAHJ0ljW7pTweEmQzJyV5DSq8v1loL0o+mt+KPlL5JP06debeIf42tros7kTSP+UiCf5kLfsh+DpoTRlr6mozGMYwV/YmdzYl5EN/cYYXOzhxC5F2c+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711461710; c=relaxed/simple;
	bh=AyA1rCIM2QHEAB4f2F4Novy69VYW+72hLXWNQgID+fc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rUB3SJVW8+Ho9CvoorzacpsbnT7usM97VsW7y7lBK4u8yIAWZDa9rUbmjTO6xSiFSkcojDJe1piHRhQ5VKtK4VZBuAlf9JQJvoOxnf5Ofoh9QEnd4GBtsd/gtRrloAOQyz/WraVD5UF2VCRNc87/b2BG+f/jhXE5rC3WTOgBTro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=peikkJxU; arc=fail smtp.client-ip=40.107.220.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFqwPFuRqmN9ynhw+7iPKkUy3iB3aJwQ3YjYgxc/UTgvBDlFUIyBnC1fYqvXVrgYJUPapVJHohs9bW+hFtF4Mj7XElU/kdelYZoM3Rv7TP717uj3WZvHqoJckRj3+K1Zqwa6yk1vIAKol9uP5G0Mv1rQj8od9Rv4SNaqO01rSevgvvwaln1lFGhpNxv9rtb804k/GySx2n2RHl8/DOArN5MZ6UklPHmLEg3N9RR1nhovw97zEts7lixnKAZNZrgXnjySMIBDKkZiuFONDz73TrbfoNkYra26oq9+EwWA2nsV/GZ6mky/9nY7CXauaue/LdF8GM2rJgBdqJc/cgVbKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwI4s5ZYmx/h0XnUNycmSG1TbPMSY8nsitsrpmdLfAs=;
 b=RYbGwvBblv3DZwhqV6BMaDUZIyKEl9G55hQak88UG+hXXm90kZDBozEJCK82QJwVhI7N5YffkxcR7A9d5Wuo/M/FjvHzJlOfmHRviXL/sGQ3QNydwEIL5VtJ73fR6R7XXxoqwzsaccHeAGugbRLpFbZW4bUXNkRt4SWkcUsZmH9VUIsfZNFRRF8SXLeMtgmuj72c3xfLwGxBPGj+0I/7NpigmMPURbOVLgsf7Lwm01KH1zlZ1idGwJLJIJxwisrTLZRGELiMPUtQqKSftp09ZYz184gfKfCILv1dfFW2Rb4/zpNuZ90RhyuZTkVp3xO8cZeTdkxd/DI4PYHjxF5kFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwI4s5ZYmx/h0XnUNycmSG1TbPMSY8nsitsrpmdLfAs=;
 b=peikkJxUaLfaIxfCiEJEsqeFfGaBV0as7qsc0ZXcqA9WDOUz4Pc2lrH6ZF7GIPNdTdKreFlYwt5gmbqrGPECjwr1ctW7veSzU24dxiOlh4e74j3c/828w+Wopc3wtNg9OOR4TriEmj+yFM9OjZ6L80fE9ajH+MpQ0W4+2ecuuFA=
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SA0PR12MB4463.namprd12.prod.outlook.com (2603:10b6:806:92::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Tue, 26 Mar
 2024 14:01:45 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%6]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 14:01:45 +0000
Message-ID: <71311318-ca6d-47f8-8fe9-807b308f198d@amd.com>
Date: Tue, 26 Mar 2024 09:01:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests RFC PATCH 3/3] x86 AMD SEV-ES: Setup a new page
 table and install level 1 PTEs
Content-Language: en-US
To: Pavan Kumar Paluri <papaluri@amd.com>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, andrew.jones@linux.dev, nikos.nikoleris@arm.com,
 michael.roth@amd.com, amit.shah@amd.com
References: <20240325213623.747590-1-papaluri@amd.com>
 <20240325213623.747590-3-papaluri@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240325213623.747590-3-papaluri@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::21) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SA0PR12MB4463:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ADJY76ZZXBzC9oN7mXCa3D0+g/J8WX2IceLwer1TMi4up9XA7VxeODll+nstMjGWUkkle7lhMkUSBHniSuhS+mI1u2294kFoJbzkV3MS2pBOjcI173uanHw3UQ/VE1YLmErDH4WSZz+852+GqZ+tphs3QtVd8TMpAaObZSoX1K5+CkMZQ9TL0mdN+PyVR390Q0XlMT3lt81qXDMzM7IBGUp+fKFxAvM6z5oybTkBHfi0JO6Y0Ef3nVUVpaB7yd8G9iX4KVUCNJUx6jhPNDsuFnf900OX1YrW16YNRaNzkbKCQtAG+8rh7TS7Qff68n8kfzCcw1/elDWhyzoQ6HHf7JzxUNzU2rEbkoOCa8vqs4zL3F7fk/VizyyFYG4GM64ZzH337Kky2Xkqki1s3zPD8ABANACfMdTFje5H9VsNvc/QCTTHU4ZTYtS6tWiI9J1i6M5lptGjN4YbLUoMAkF9NnyfVXRa7iqrEN37VODC32Cynwhg04WEC6NGAettg8Pv3CN9SOXp5a4/C+ZQT2WrBi/abPkTxD8qrRIIB1+SZHPGy0VzllatjICSl954r3ejGKJwlxzTU9WmKaAHUSnZZFQis+FShK1+Q8DioG4hpetgpQpptojPFXco6XuUr8+aFE1xkmBcWQPEJmAq+QSvX5cANtaAxB1iI1dXsJ/e8PQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OU9KbjJCVWdxaW9LL080d0JrUE1ZVTZhSU5oOVhhNkRINEUyZnh0UXc5VEdk?=
 =?utf-8?B?Q3ZGdmJyVlhXWVVnZDFSSHE5S1k4b1FsU1lHa3NUcFRkSlZoallHaGRtK0Vv?=
 =?utf-8?B?SmV0Vkd0b2dTbklmUit0aTRXOTBVbnNQaFkzV0JBR2VrQjBYd3BSc2dVTHFr?=
 =?utf-8?B?Snl3TUk0OTJHdXZuUWlOdWU1cEpzZ0RsSHFMRVdmQ1ZER1ZnK1RpdUR0WGk4?=
 =?utf-8?B?N0V5MTVPSlhMdHk0OVdIa3NYMkdkQnhYMCtocXRFYnpYeFBzT1pwRXBnVk5T?=
 =?utf-8?B?RnB2eGVYbEVacC9uVHgvekNiamt1YlFpQzNsN3BhRmRBQS9oWFRVbFV2TWwv?=
 =?utf-8?B?THYxMWlVWEc5V3BCUnhITlc4Qzdxa0FxcU01ZUF4WU1rODkrTTFSS1IzcWly?=
 =?utf-8?B?bFJteWVlV2FpS05mem5tejlXS2h0Z1dmbE91a2ljVDA0UElqNWlKR2dBVGs2?=
 =?utf-8?B?TExvMkticjJhZjRqcU1XdjNtQ2NZTzhUYTVoaXNIb2liVXlUajlEa3dBbmkr?=
 =?utf-8?B?ZldMNXVjVTlZOERicWhqVGJhRTdsU0xDUXptanNsNUVZVVQvYk9DWEtCbkdm?=
 =?utf-8?B?aUNXZU1oV0JQTGdGc1U5dFUzdXYxZUVxTUZ3aEQzcUpDNGpHZDhjL2tLZEFB?=
 =?utf-8?B?Y004UHlRVStWdEhaM1RZZ2ZUZXpweGpoOStjbndJUWNHbzNOQVhFOFY2Yi82?=
 =?utf-8?B?UjBacUU2SXZqN09JR3hOeDBxa3ZKVXN3ZGhPdWxyc1lmd0VpRE9abkhCUDlp?=
 =?utf-8?B?MXcyVDhYU2VqdW5LS1RNS1hNV1J2UUwwQ0Iyc0NqL2k1SG5RakxUNkNkKzRp?=
 =?utf-8?B?Uk9GdGdDZHNpQXVpTlc1MG12MDArRS9HYk9mQW9lWjBtR0JjQ0kvaGp3SVIy?=
 =?utf-8?B?SnhiYVFzKytqTUh4TWNPWHRPT2s5K25FL1BKOERtNkJoZHBOREVHbUJKSFU3?=
 =?utf-8?B?S3lRV2gzdjhaVWVnQjNhaWMzWE9zK0lFMkNEenc0dS9DclZsdmRQVXVvMFN6?=
 =?utf-8?B?dDZibm5sVXZicmVOWDFBMU5zemRiR1ZJNTBldFlBSllOTFpNaEVzc0c1cklU?=
 =?utf-8?B?eUZmd1hOQmFYL2ltbnhPSnFFZXRra1ZCa0ZWZGdUZk1US3lwVWVJcCs3U1hF?=
 =?utf-8?B?NTdoVy9pQmZhWE9OaFlYOHZiUXRpZEhwcGUzQk5iU2hhVEFmZjg4aWkweklp?=
 =?utf-8?B?SjJ2eXFKN29HbmUxejV3SlIrTksyQWhCcmpPYU9Kbjd3Wm9EOWZmUnNyR2Y0?=
 =?utf-8?B?U09CU0FscEJYOXFkb2hCL2JVVlNidmNySTE0cm1ldmRUdEFhUmkwaTRCQWd2?=
 =?utf-8?B?RSsxRjZ4RTdZQUdrLzZqRlhpWDRpSkN4dFdiQ1hBYnJrMUlWZW5xb0FLOFNJ?=
 =?utf-8?B?UGpGQXR0TVRIb0JzMHNxcjVUQ0txM1BGQXJsVmsxK2lnQzcyMysyNnZjcS8z?=
 =?utf-8?B?UWNQWEpHSUx5YUVSMTRqT1FtRGwvVVlnM1pkalgyVXNwRVBCbU1PUSttcytq?=
 =?utf-8?B?MzBaVVc3WFJNUGxjRExBYkNlcmVYbDNBSTlMSElSS0JwYm12UGd5M1grMVpD?=
 =?utf-8?B?M21VOXpHaURaV1lUVGQyWlc0SVFpd3BoZDlrbGQ3M0kwZHJ2RmZPVDQzTkNC?=
 =?utf-8?B?WGowejJUYlFzeVJsWFR2Y3cxYkZxc2UrVkFEWnByOWtDVERmdFlzTThrLzV6?=
 =?utf-8?B?dHM5eTM1Q0VSdzJsNVl6SWF6OUdmb3UxZXZvL0FOOEh5SlpQUW5uNWsrRmFM?=
 =?utf-8?B?SUJGRTdaRGxhUHd5cE0ydENzTUJubWE1U0ttRXpaMFpoU0g4NW5mdzQwdEVN?=
 =?utf-8?B?Mlo1VGRIbzZNTDYxNkVwZk9DOW1lSk9JOWM0VXBOY0JUaDFBL0tVdEttRzhx?=
 =?utf-8?B?YlZYMU1jcUp4bUF3cTF2Z2xFR2VvdWVEdDQxMXpLYW0yaGROaks0RkJaYnhD?=
 =?utf-8?B?Z0cwMkRQV1BzYVBmWk9YL2dXSFFzNlZYTGhvNG95Y0lwQitwSGlmcGsrSmVI?=
 =?utf-8?B?UTgrR0ZWTW9sZFY0L3FNM0Eyc0FYYWxxUkU4YkNncFhjRTlIQU52ZHl4YUpH?=
 =?utf-8?B?VTZVTnlFVFZXTXA2Q3ZiTHFnQXp4NkFZemZrc2R6SExuSHhqbitOcFFXQzBW?=
 =?utf-8?Q?fadk/Q1z0MHYR9b4zY5GOy5GE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b93ae7b-f23a-4d62-42e2-08dc4d9d455c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 14:01:45.0061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6LkBPV9ZIuSjiEOmWVk4WG6PktmRB5pYyYhfJ47AbCgpMxM/D1JFJQ1etTt2eI28kSF38BoS/VuQD/4d879c7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4463

On 3/25/24 16:36, Pavan Kumar Paluri wrote:
> KUT's UEFI tests don't currently have support for page allocation.
> SEV-ES/SNP tests will need this later, so the support for page
> allocation is provided via setup_vm().
> 
> SEV-ES/SNP guest uses GHCB page to communicate with the host. Such a
> page should remain unencrypted (its c-bit should be unset). Therefore,
> call setup_ghcb_pte() in the path of setup_vm() to make sure c-bit of
> GHCB's pte is unset.

This looks like it should be 2 separate patches. One for supporting page 
allocation and one for setting the GHCB page attributes.

Thanks,
Tom

> 
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>   lib/x86/vm.c  | 6 ++++++
>   x86/amd_sev.c | 7 +++++++
>   2 files changed, 13 insertions(+)
> 
> diff --git a/lib/x86/vm.c b/lib/x86/vm.c
> index 90f73fbb2dfd..ce2063aee75d 100644
> --- a/lib/x86/vm.c
> +++ b/lib/x86/vm.c
> @@ -3,6 +3,7 @@
>   #include "vmalloc.h"
>   #include "alloc_page.h"
>   #include "smp.h"
> +#include "amd_sev.h"
>   
>   static pteval_t pte_opt_mask;
>   
> @@ -197,6 +198,11 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
>       init_alloc_vpage((void*)(3ul << 30));
>   #endif
>   
> +#ifdef CONFIG_EFI
> +	if (amd_sev_es_enabled())
> +		setup_ghcb_pte(cr3);
> +#endif
> +
>       write_cr3(virt_to_phys(cr3));
>   #ifndef __x86_64__
>       write_cr4(X86_CR4_PSE);
> diff --git a/x86/amd_sev.c b/x86/amd_sev.c
> index 7757d4f85b7a..03636e581dfe 100644
> --- a/x86/amd_sev.c
> +++ b/x86/amd_sev.c
> @@ -14,6 +14,8 @@
>   #include "x86/processor.h"
>   #include "x86/amd_sev.h"
>   #include "msr.h"
> +#include "x86/vm.h"
> +#include "alloc_page.h"
>   
>   #define EXIT_SUCCESS 0
>   #define EXIT_FAILURE 1
> @@ -89,9 +91,14 @@ static void test_stringio(void)
>   int main(void)
>   {
>   	int rtn;
> +	unsigned long *vaddr;
>   	rtn = test_sev_activation();
>   	report(rtn == EXIT_SUCCESS, "SEV activation test.");
>   	test_sev_es_activation();
>   	test_stringio();
> +	setup_vm();
> +	vaddr = alloc_page();
> +	if (!vaddr)
> +		assert_msg(vaddr, "Page allocation Failure");
>   	return report_summary();
>   }

