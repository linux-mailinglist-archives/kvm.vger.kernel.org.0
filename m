Return-Path: <kvm+bounces-9947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C7C867DD7
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:16:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D52F1C2806B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C8812F385;
	Mon, 26 Feb 2024 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="crm4Nf/D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8914C12CDB7;
	Mon, 26 Feb 2024 17:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967219; cv=fail; b=AneIm9gYT/QuDLaUXYvmpgtIbpVLRnWNzjGaU6hW0heXxRSfKgJb4gKKMac6VL5SgNGIdTg10NX9EMq26/nJbO2768Jr/7b8mmDTvHUo6qFQ5sLSoZgdGldtuVnXm4hQHAYY+KiqvenxAXo08tRy4YHi5Rm2SfFvNTRGgl7Mwvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967219; c=relaxed/simple;
	bh=JnMEiNksn5nV50Smu6PNzrgRjKfOG0zDy7msK62Z9c8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U9IZuzLvnfcTGMRUAIXV4RVQOL6cd+W5j4cr20t6hffxtDu4BqY49ukEs3/pnBJpspuY1nyFLxLU2jfH42//5fbFv4xQU8nPgSgUEzWKgCvgdI+opIjpO1Czi5SHZ2/90oUZdg2prVzecmji2mEpfwXlgVDAGYExkn1nOohLWl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=crm4Nf/D; arc=fail smtp.client-ip=40.107.243.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZS7ZUQgcX01y+lahC2zCp9e0/H/2eAHCQJGOblAyTdKPiy5vMjBhb/HwuSbhA5zfLfPeik7l5qzLTQZ+7zCzIWW9fb4DcdkOn/M5XjrNHo1kqxyAJ14RODz2kn0xYMIGew3IlmdWeHcCn/0RGnYFpc9gF0yZLMgHR/8UjxElq4hAF/vj6PaiAq0wVZsfuL7gErBl7HsGJ5aS99+rvJyDy+gAJc82L2x6yO16cd8O/0eqfdBeLR2PLoOXeGrOvf0lZ9KO8/W3Y/au9Ljwtf3FoB30265fEeI1qyyXyriOWqkM1/GE1apNFG3LQpaARiXdcs1mZCkbKEcqRsDdH+VeGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rs4u5JbO+QiZE1KGgEwdIipW9PYRwVjgEFeDW9jqMng=;
 b=YzCfFS0MijW/DKzhowV5y35ObTpg4EvfD4/WcTQmNWInoly829De28Fe6ZWD/xlJXkhvo40zGNOKTk7CJF8LAW1nNSgU0c9Z69jp8dcLcDlrl74rcXoZ5B7P+nhFRM42ozxgbM5bn1qShwXwnRWiLqxKD0SbEFsFFnSprS4+GldubWZ07iNzafQsZBUjnfACdiNbSBi6ewjNDIiDE4YZUbKWEM4A0tebYxQEONtFWMrsOiBWw1YM8NyyftHKRTFniO28zylIjUDe89c8bBK3oyHKIsB6nAmgzKAzRCjsb5N+NSr4CwZBFVtrR1S9sEHDOJKLS8r3zRA8eP9+pi1shw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rs4u5JbO+QiZE1KGgEwdIipW9PYRwVjgEFeDW9jqMng=;
 b=crm4Nf/DPGd71pc+CgzNpXjkEDPFLtiAKGVNX/g2RBOwtdcUIt4M7lqgzTyHNjPAZNWifH3NNriF3CJv4sb5MUtVhLB0pZXjuFba9ysApy4836yJaWZ6gdpPOMGzdwp+sUgvYntcrDtZfbnoiDTV03Ad+3j+xXbitznHkSfwit8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17)
 by SJ1PR12MB6193.namprd12.prod.outlook.com (2603:10b6:a03:459::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:06:51 +0000
Received: from BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::14ab:832a:11af:bfec]) by BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::14ab:832a:11af:bfec%4]) with mapi id 15.20.7316.032; Mon, 26 Feb 2024
 17:06:51 +0000
Message-ID: <5e360765-3398-4b72-ba7c-4df0958bc5d3@amd.com>
Date: Mon, 26 Feb 2024 11:06:48 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/11] KVM: selftests: Add SEV and SEV-ES smoke tests
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Andrew Jones
 <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>,
 Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>,
 Itaru Kitayama <itaru.kitayama@fujitsu.com>,
 "Giani, Dhaval" <dhaval.giani@amd.com>
References: <20240223004258.3104051-1-seanjc@google.com>
From: Carlos Bilbao <carlos.bilbao@amd.com>
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0112.namprd12.prod.outlook.com
 (2603:10b6:802:21::47) To BL1PR12MB5874.namprd12.prod.outlook.com
 (2603:10b6:208:396::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5874:EE_|SJ1PR12MB6193:EE_
X-MS-Office365-Filtering-Correlation-Id: cbd44372-03f6-4128-a18d-08dc36ed535f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AosjKrc34U19icGF82O4B3ERQo1BCp7lYoD+pvGz+CMtdDuwomutVxZpaCPKeRWWHwuSPU4kOQtm/v/d5MK0kgCKqhCS89ObNUqZN+2OKtRjSDdIlMouDDnhE32bBMmWuG3UDCc5oiKp9/JgvdypQVoXyGuuMcdqwqM3Arf6aff/uCPaB/du1hHIY983n0LhO81sweZnyBbHDeEFLT5vPg2cGjqLHk5MeWgXL7jLOWzZ1jFARuLd0r0U1CZRRSyNl3XD6L8R388VzjXtvXtVoXzY4KK4KpesEmGot21dCDewpAUVx3THH7aoSUoVbHjIId0gRBqR67xkCBhpZguewD9dfPOlOB2D7Hj6WaV0vULLciMpVKVfRacP82JsXcJYtu3OQa+pxfE51wiRqhYz7N6CmpJgZ8e05bGqe6uw1LxoxcDGqHIukqDfWBT+vpPiJSr/CruMM55nPMC4cAWhUWidJb8x85Rsom0WWGwJP8Q5rrsQWUrfbeoRc9gsy/qJGBfk22UzScCTX3fDiFxl+1oZYZLdCy/j/sRTNoVxO6kLhv7OF5mFSzyN7YCnpoHYrfwzobxHXWAQudMHJi8ES2UqhYz61Uk6+uXN49sDTUujxyTC5G9/L8nGClRZ8x74mq7XgvlbyFybUZaJVP/z57I10HVIPFh4jf+iunvhmU6mawqUnMqsynlgAXRKs5Xo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5874.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGEzaUJVZHZaK1BwVVlEOHRpa3I2SThuSnVodGtiQmRFcldzSzlHcTV4dnAy?=
 =?utf-8?B?YXo4TVd0QW8vMHc4aWdMdTZnNnQrRm9NeXpqU2psSWpRTk11b3YyUk4vMFJs?=
 =?utf-8?B?ZjY1Q3RZcEJ6L0ZseXE2eDlnMzFIWlMxc1RydUtaUktWK0NqanNiaGVNYUY5?=
 =?utf-8?B?eUVCQmg4aGhlb3J4bjJtTTFEb1JuNDgwR05KWWhqcEJiRjJKbExOMzVDL1E1?=
 =?utf-8?B?NXMvYlg1aHFLZHNtTmdwb3g5alBtRWVwRjV2RWFERWg5cXlGajdzZzlPNEFa?=
 =?utf-8?B?ZU1wdHRENUIyamo0VnRaalE1YWlmc3VGb1pCSjQ3RGRISUxKS3dvVTUyRnN1?=
 =?utf-8?B?ZDNBUjNiRURZUVZKdlJ0bVZNdW5TdkcrY1h6MTZvT2R1SUFqMUJjRzZIZTAz?=
 =?utf-8?B?NlhZU3BscVpyS1VJL1BQZ3JDWllDNGZPYWdCcDZ5cTdHdllqRFgyd0ljSEpJ?=
 =?utf-8?B?d2taR1R4aytxdmZZZlNoVDF3VGdRaEgrL0FUSGgybURTTkZ0RGZUK2ExelZP?=
 =?utf-8?B?aUYwbEVwOEU4aXpoZSt5YlB3S3FpY3NFSjhkTVByUUZ0TVhCK0MwdnVlZ0I5?=
 =?utf-8?B?QnFjdFpJR1E4eXE0STRMcFVPcEFnc2hERm8rVnRoUmdKY3Z0K0d0dldZUXZN?=
 =?utf-8?B?cG9GWHFaQnJ5bWtiNC9CcG1lZ3JQT0tXd2c4K2Z2K01hZXQzRVlNNHZoQ2Zh?=
 =?utf-8?B?S2dJMXlDSTVvdUtOam5DOVpkZGs1Nkl4RHhKU3NXK1VJL0pPYzZVOFVIS3Y2?=
 =?utf-8?B?TFp5QXhpYlZVaVBUeU80dzIraEJQQ0NOdXUvNTF4VkMzRDhKSTRPdG1TQ3ZR?=
 =?utf-8?B?MC9mclhVV2V3UEtwNk5MWXduRm13ZXBlZ3RMVk4zSXhQK0NsTC8ycXFDcE42?=
 =?utf-8?B?dDlKTXlJWkNBS3l0QktuT3hXZmxIRzlscng5RjM5OVJPL0I1dEFlSU9wUHJl?=
 =?utf-8?B?SDBxcnJjbDltbjdxcFladXBTRlBxZEhQTUF4enRXTkUrUVZkK1hVU2ZhR05x?=
 =?utf-8?B?bmo5cEs5bStpZFJEZUFZVGs4RjlZTFZ5YlRSR1BmcG16cmJvUHNZbUl4UExU?=
 =?utf-8?B?bVVBT2R5VVhqR0VsSUo2WEpmc1JsVEp0eDk0TnZtU21lZ2EzbUNVZFAyVzE5?=
 =?utf-8?B?MkpoS1A0Nlg1T3BZdUduZzZ4UmlsMkRyc25mRU52Zno3MVlzd0NRSFFUNHJH?=
 =?utf-8?B?SGE0eTkzNnVhdzVwYkplQ0NFTXo4Yis2MXR5aFhteFhHVFk3Y2Iyb0xRZmtC?=
 =?utf-8?B?Nm9EbERWdVN6RkdydTJ3NXA4cFRCUCtYVHRZRzZJVTdZaHJxTVlua0VCUWZS?=
 =?utf-8?B?MlZ5WVNocU92VFZZRkwvbEpsNnVRb20ydkdqS3BZTFdLdDNqZkg3K2dlYXRj?=
 =?utf-8?B?b21kYXRXbE94b1FmTGJ2VWFEUjFQektyQUpLVlFRUDJzQjZIbVNqVGk2SjlC?=
 =?utf-8?B?TFRjenBNWGUvTjhaTk9mU2tmSU9KV2t0d0JVdUkzRnY3OHB6K0VjdGV1Y2dU?=
 =?utf-8?B?QXVvdW5peTFtRVY3U3N2bGJMQUg5eFNtR1AwQy8rR0duSmNvWVozamRjQjJq?=
 =?utf-8?B?M3FrWlJkNGI1VFlYMmhkSnYrUlJKb1NNaU1Gb2dONVBtZk5JWktNcjc3b0t1?=
 =?utf-8?B?MytZdWdzajViV0IzVkFHVHd5NDVWenVGRzM3cWZwZWdFWWlid281Q1Y4QlV6?=
 =?utf-8?B?S0VQUHNZMllSS1NZVDI3SG0yV2QwQTBmS2k3dWt6MTJzNGsxQzllTjl6ODJV?=
 =?utf-8?B?U3hnK25Ia3piTXhrV1ZSclN1MkVSakVCRy9makd1SGEwUUxVU0JYdW1VUDho?=
 =?utf-8?B?V3NNT2F4TEoyMGJYLzJLZEw1RlJyU1hPZEdzVmU1RGNraHlBV28vdFltMHl4?=
 =?utf-8?B?TnBxdnZTWVcrN2l4QWxNUGtnR2NNVXljSERqMjdRZHRUd0xpbFFYaXFIVVpR?=
 =?utf-8?B?SWtNTnJsM1FqUDJDaGo1MkkzUTNxTEk1bkFoY0NYaEc4U2lWL3VQV0ZsQ0ky?=
 =?utf-8?B?anZsaVlDTWhYQkh2bGVFeEZHZkJYeCt3VkltK0xiYmRMc0JWRGY0NTZKV0ZI?=
 =?utf-8?B?dGo3eXNRdkZkZGtsMXhIUlJUdDFrNTZUeml2UUI0eEhzNHBnNi9TVUgwREN6?=
 =?utf-8?Q?jkLDNWwMpZVHzfjQScXhihg7d?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd44372-03f6-4128-a18d-08dc36ed535f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5874.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:06:51.5016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZHHA/oFbWvCIKLp54lqyxwsr/g2I0QfDx6ZprdGX04xiRuhNSbJ//NA9O7ZiK088Vr3IAy9nas7wP43WqcpOiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6193

Hello,

On 2/22/24 18:42, Sean Christopherson wrote:
> Add basic SEV and SEV-ES smoke tests.  Unlike the intra-host migration tests,
> this one actually runs a small chunk of code in the guest.
> 
> Unless anyone strongly objects to the quick and dirty approach I've taken for
> SEV-ES, I'll get all of this queued for 6.9 soon-ish.
> 
> As for _why_ I added the quick-and-dirty SEV-ES testcase, I have a series to
> cleanup __svm_sev_es_vcpu_run(), and found out that apparently I have a version
> of OVMF that doesn't quite have to the right <something> for SEV-ES, and so I
> could even get a "real" VM to reach KVM_RUN.  I assumed (correctly, yay!) that
> hacking together a selftest would be faster than figuring out what firmware
> magic I am missing.

Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>

> 
> v9:
>   - Drop is_kvm_sev_supported() and rely purely on KVM capabilities.
>   - Check X86_FEATURE_SEV to ensure SEV is actually enabled.
>   - Collect tags. [Carlos, Itaru]
> 
> v8:
>   - https://lore.kernel.org/all/cc9a1951-e76c-470d-a4d1-8ad67bae5794@amd.com
>   - Undo the kvm.h uAPI breakage.
>   - Take advantage of "struct vm_shape", introduced by the guest_memfd
>     selftests, to simply tracking the SEV/SEV-ES subtypes.
>   - Rename the test to "sev_smoke_test" instead of "sev_all_boot_test",
>     as the "all" is rather nonsensical, and the test isn't booting anything
>     in the traditional sense of the word.
>   - Drop vm->protected and instead add an arch hook to query if the VM has
>     protected memory.
>   - Assert that the target memory region supports protected memory when
>     allocating protected memory.
>   - Allocate protected_phy_pages for memory regions if and only if the VM
>     supports protected memory.
>   - Rename kvm_host.h to kvm_util_arch.h, and move it to selftests/kvm where
>     it belongs.
>   - Fix up some SoB goofs.
>   - Convert the intrahost SEV/SEV-ES migration tests to use common ioctl()
>     wrappers.
> 
> Ackerley Tng (1):
>    KVM: selftests: Add a macro to iterate over a sparsebit range
> 
> Michael Roth (2):
>    KVM: selftests: Make sparsebit structs const where appropriate
>    KVM: selftests: Add support for protected vm_vaddr_* allocations
> 
> Peter Gonda (5):
>    KVM: selftests: Add support for allocating/managing protected guest
>      memory
>    KVM: selftests: Explicitly ucall pool from shared memory
>    KVM: selftests: Allow tagging protected memory in guest page tables
>    KVM: selftests: Add library for creating and interacting with SEV
>      guests
>    KVM: selftests: Add a basic SEV smoke test
> 
> Sean Christopherson (3):
>    KVM: selftests: Extend VM creation's @shape to allow control of VM
>      subtype
>    KVM: selftests: Use the SEV library APIs in the intra-host migration
>      test
>    KVM: selftests: Add a basic SEV-ES smoke test
> 
>   tools/testing/selftests/kvm/Makefile          |   2 +
>   .../kvm/include/aarch64/kvm_util_arch.h       |   7 ++
>   .../selftests/kvm/include/kvm_util_base.h     |  50 +++++++-
>   .../kvm/include/riscv/kvm_util_arch.h         |   7 ++
>   .../kvm/include/s390x/kvm_util_arch.h         |   7 ++
>   .../testing/selftests/kvm/include/sparsebit.h |  56 ++++++---
>   .../kvm/include/x86_64/kvm_util_arch.h        |  23 ++++
>   .../selftests/kvm/include/x86_64/processor.h  |   8 ++
>   .../selftests/kvm/include/x86_64/sev.h        | 107 ++++++++++++++++
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  67 ++++++++--
>   tools/testing/selftests/kvm/lib/sparsebit.c   |  48 ++++----
>   .../testing/selftests/kvm/lib/ucall_common.c  |   3 +-
>   .../selftests/kvm/lib/x86_64/processor.c      |  32 ++++-
>   tools/testing/selftests/kvm/lib/x86_64/sev.c  | 114 ++++++++++++++++++
>   .../selftests/kvm/x86_64/sev_migrate_tests.c  |  67 ++++------
>   .../selftests/kvm/x86_64/sev_smoke_test.c     |  88 ++++++++++++++
>   16 files changed, 583 insertions(+), 103 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
>   create mode 100644 tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
>   create mode 100644 tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
>   create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
>   create mode 100644 tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
> 
> 
> base-commit: 60eedcfceda9db46f1b333e5e1aa9359793f04fb

Thanks,
Carlos

