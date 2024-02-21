Return-Path: <kvm+bounces-9336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6930B85E5D5
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 19:26:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C0F01C22118
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 18:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78D085953;
	Wed, 21 Feb 2024 18:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VAu0lW3C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22F085639;
	Wed, 21 Feb 2024 18:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708539817; cv=fail; b=mii0IfzC7r3bhKiZdULWIFpwVzdbrhvq568ORzyawOLITRUW4Q44a4EMSCTDBiw0tnnitnfHb9iUrp9tvkafbeiK9gfbvcExxKDW3o6wDoxxNRJt4EKLyVgrQBM6jMquXWfRcIKkHYPhRTNAez2Kti51eMhnROtL+SHTSBuyWvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708539817; c=relaxed/simple;
	bh=9g3eFpfs3wUMSkg0UH/SYeptb9M1m5lWnl9F8rzr9gs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MD9YeGlGm7nFDuV706IlZW5wwTottO+bI41tr2Ox21JEp5Dy+hq6UrN0GNkHakXZk2fe7+jT0tvtNXzBAx96HpYBSOvQM4dyrzNCfCCMmstfNHs92HEBSRd14WFtZ+FCM3W6PQWMQdeguXdoCn4dCBO5BAPo2nYO5ACXvBzh0MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VAu0lW3C; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gW3t7oX02y/gW6mC6scT4qGc1HAxgKgETdCZD1iGoUxX8aKAhz6ehChU3sidLYxPggWwvLNgUClZuwrvnDqXbcUxuUrJtrgzMmbaiFr6S1InoUYZxlxUdCZRBAQEttL/cDZw7T8JjHbIfT7T2Er1AyyLzBx104Gm/rM4Vy8tu3aXcne0Tb6LefJKX4uhnO8aRs1tInEqCGYC4Jswy68cDbD2yPrnMcAmuLqaeMVDt81FclHKhm/FTFvgJTHY5DTqZc/HKr+NFYB4MlyXr/NVnqACEmuGcA9J3Ff4tkblwacpOnuH4U+kWUnLAWBvx2KFG93MV+FtOiP0uoMXb6ayMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtgQWZh+c9k1dsHP7FwbrT84soF9jUumLbQLyyg0264=;
 b=jLeNw/dnvPtJSc61opsytVHkC8WcOkgzj11Z5Mt04w52G2GpMH2wA70WbfbBreWKXjUEijJte1SU/OPlMMOKCknigQopLPkQtgoWkHHDOHfCU/IYwJ90DjTG81aMUachWV+3gAS3ZdIGoOSf7zHxjd0SB9pM9jY2is2mGabziT2M1eqXPRFTuwJSrCcPat5nLvBwyOkxaXwsZZlFp6QZQdiqqVpSsRDXTs2O6ZhLNq/8ECWpubkZbm9Uw1e69njZy1FM+Y806rR6XCm489n3vZE1SyhMwDbxbN5iJwJsDRIAYWQo+rel0T6TrmrxeeHpbDgA8OHqX+WpfwupamYkWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtgQWZh+c9k1dsHP7FwbrT84soF9jUumLbQLyyg0264=;
 b=VAu0lW3CTd7t3Iq5Tc2f2qpI3RfR83SXQAgaSnpaI1SqJEyYsVsjzBm0C6FhDugY8l5ZjLfD8e9p3FvEdZ6XdSHpD1OXbr2XDOsCpuVZB4W+fddQqFAMPnqrqTwXvl/g1j6Sn9nKLUoJQntY0iv1EuaqK91V9mJ1m8ORANr5ksk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17)
 by MW3PR12MB4556.namprd12.prod.outlook.com (2603:10b6:303:52::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Wed, 21 Feb
 2024 18:23:30 +0000
Received: from BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::251:b545:952c:18dd]) by BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::251:b545:952c:18dd%7]) with mapi id 15.20.7316.018; Wed, 21 Feb 2024
 18:23:30 +0000
Message-ID: <cc9a1951-e76c-470d-a4d1-8ad67bae5794@amd.com>
Date: Wed, 21 Feb 2024 12:23:25 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/10] KVM: selftests: Add SEV smoke test
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
 Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
References: <20240203000917.376631-1-seanjc@google.com>
Content-Language: en-US
From: Carlos Bilbao <carlos.bilbao@amd.com>
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0059.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::33) To BL1PR12MB5874.namprd12.prod.outlook.com
 (2603:10b6:208:396::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5874:EE_|MW3PR12MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: 20b75b53-0261-47a0-434d-08dc330a349a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Mfj8PbRpkEM2pjl6eRlI6rwUWpOOy1W3DOduEy+R+4O1NkZUh80im677i9DVQ6fSA0A5kgRfmqLHzD9jUIFqc5ayg4ZmxGcJfHFuDCwRFh1g1dHZNXF3hX0JJXNXpjGh7GtVVgMSQBg/HBYgb4kZedM95zYK5H56kXO0V5gP8vBj4ghCmr2KiCW6Xx9lUoJb7YPCKzaSZwYn/rySxI+15CFtKjY5iLdTbMoaOgPfc0NKqA68q+8OCsO0lehW3c0lAMoxfcYtzoX/z3788ZS5McU/x31dm0rHiwOqDSRP+j/UWVX12AspetCR5/3rSsekUN+4y3o5BMrFbmlgR/D6QJpK/ubWupuScscmF8XIVS5p9aoIwVerrxOLGuVf4UG4b2P35FfOcGBQhhW5yYARq5O6ewjnCm0vJbAXmKM9g2tlLGBPx9qmtsfNsVWmYnP2/7F5AxVBQh5yx1A54A1S+gDw3GmyYl+FrYLsGCfRSLtGfoXXW7XyDjrD0J29YWC6F1qd3K9C+AQ5VigeJGiUF+48WKjSGqTdy37ZkpsHTHhFh3aU4bUFB61jfjS8yWNsddtUTFmPsBTDX4ieZ8Dv5A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5874.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVFNOGcyL1dFRmx0VXQ0SkVib3V0RzlBYnhUVzNjZUxkekdjMTgxUXZYa3M0?=
 =?utf-8?B?Ung3OHg3emN0THZVdGhlNzlkVUgxZkc3Q1ZZL3Z0TXJnaWJiYzR1N3dXeGxt?=
 =?utf-8?B?bkNlLzdhbUozUlhGUkFsWHJ4V3JrRk96MUxERmJBMnB3cEIyUGJzam9ER0J3?=
 =?utf-8?B?TnFzelRpVlkxblJpa3l5MmJaTU5jTVR1MWUrWU8rcE1qOWlyaytOa1VpOVZH?=
 =?utf-8?B?bmFOYkxpVVo1YVl2L2FvVlo2S015Y2pWOEhNaVV1bldRMm9kclJ2VTdrR2pQ?=
 =?utf-8?B?VFdndUhvNXNINXZhYmVHUVdqcDRVclNFUnMvOE82aGx3eWRTblBtNFkrR3JB?=
 =?utf-8?B?aFFVc3hvK0NMbW8rTGI5NW5vL1FOT1E4VjVGUG14d2lqamVZb1ZTaWRwMmRO?=
 =?utf-8?B?NFYwZlEzVVc2dnNUT00zeWo0R05SN3VYNXJlTmt5VjB2UlVQdDQ5OHowUGxS?=
 =?utf-8?B?UEY4NmlmWTM2VU1NTVZsOXlBSW1sZVhoazBrTjVLbWZDSS9OSlczSXkrVUJ0?=
 =?utf-8?B?WTNYRmlWNllIajM1MFplWlpYNWRPVlVpNUtSSW16L01Hd3Mwb20rRzVhT1NR?=
 =?utf-8?B?aVQxZXdLbmNTR2cvcEpMcStpZ2x5Tnk4QzVudmtrUStnbmdVY3N3c285bEFR?=
 =?utf-8?B?akE2V0k0d1dPaGt3WUgxTTcxcHFjZmFrWi9GcVQvdnJEY0NXdjNJQ2hVend5?=
 =?utf-8?B?NVlSVi9YV0xYMkR4Q0NCTi9RQlpIRlVZTUtaRDVKbmVHcVFocEdxNzZoM0ZE?=
 =?utf-8?B?ZFZRYWp0MjkyMFE4b3JtR3VRd1R5bUN3OG9VVjNqS1Rtb3lVbEFNSG5JNy9Q?=
 =?utf-8?B?WWF0RDdzMzAwQUpKOFowTW93djB6L0oybFNockNFamNncGtYM1RCUFIyM1I5?=
 =?utf-8?B?eEViNFR2NEFPdFJYV1ZoL2djTWZZa0NlK0NybXdlanlWYU1KQ1hWS2hubzZm?=
 =?utf-8?B?M1gvZHZ6eEVRZ3FlTGFTZUY1NGU3L2dCWTBiRDNDU1hpTkI2ck4zeEZxaU1j?=
 =?utf-8?B?Ym1zbGd3Ui9yc3RlMUFrVWg4c29TZUpWcDBvbHJuZDAxOEZ2SlVoTk5GRUlx?=
 =?utf-8?B?ZFpqV1VWd2dOMEsvSkdXV0xKMzBIZjMyUmpLUEE1QWFTR2gyWWdYV1JwNnBt?=
 =?utf-8?B?NjlUQnYyNlpvS0QxZElOdnNDN042YW5Hc1VJWjY1Y3o3aTNRcHNyaGk4WTIx?=
 =?utf-8?B?RHo0RlVDOWo0NUtiK3hkK0lHNk84QW11dGRjdHR2S0R2eDIyQXBYSm5lRXZC?=
 =?utf-8?B?M2FsRCtmTzF6NmJOTW9hQ0dxM1FRTHNmTzdxb1NLbXlTSlhFdkJNV3ZzS3Ix?=
 =?utf-8?B?cjZkY3JsdkFoaXluSTMyOUlwL3Y3Q1ExNjVKMGNmeUgyMEp5aEYwYitSdXlX?=
 =?utf-8?B?blVNSHBPeko0dFRmRWNCTXdZTEkvc1BYY3Y2TzIyVHlLQSs5NDFEYURmZTMw?=
 =?utf-8?B?WDU5SVRYampYUVlUSmRZVmF2ZnM5MzZxbjBVL0UvK0VFSDY1UFlZMkhQT3Zn?=
 =?utf-8?B?ZzBhbzRRZHRGMVBIZ0RQaXRUY0gzSkQ1WStWVHp4dTdsSmI1QmltNC96OVhR?=
 =?utf-8?B?MG9DMkZjOWN5Q0ZiR041WlNJMnpIV3hhQU10a1pOZWNJK1hxNmJrVndsOUJj?=
 =?utf-8?B?TGtKV0lWS2VVeHFNeTEzeXVNSjU1TzJ1MElSNUtRMkJ1aWpxdFpZUXR1dUR0?=
 =?utf-8?B?QzE5WUUxU2tGYVA0WlFnbmFieHFLc0FremsyZDJPb3l3aUVhZTVienhIMW1n?=
 =?utf-8?B?OXJENUtEc0dUR28xdjBHRXdWb2tranErcHRMeXNtMXU3clB6TWsyc2duM05h?=
 =?utf-8?B?ZUFWSVlndUJNWnh5MW8wazJuUXU5RjV0bThNb0ZqQk5rdllDbHJRMk5MeUVt?=
 =?utf-8?B?eHNzdEYrRFBPcVplTDY5c2NqUE5mWUIweDlzM0tXdU1OdUwvZFpDang4c25k?=
 =?utf-8?B?MkFrMS9nVjRzbDNvTUNJRFB6SGVrQ1QvcVUzbTZDQTlQNXV2N2VLT3NHVUFZ?=
 =?utf-8?B?UHJ3Q1NHb0VoV1gyZ1R6Y2JKQTNaWExVYjJUWVFPR2xhOSs0R0ZTVlBteE5Q?=
 =?utf-8?B?dk95RUlsd0pqMForbSs1YjEyblFmZUhnWmFDc1JNTUpvdzkwY0s5enBZWlc5?=
 =?utf-8?Q?nhiH0MMnElw0IRvhg3/LZr6ar?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b75b53-0261-47a0-434d-08dc330a349a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5874.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 18:23:30.6266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQ/lkzbsS68u6XzNYMtQaH3hBBBcseFbH414oprakJ62zeJQ4eHYN4o+Gz9dD9X+S9DIb86/XQHOh6FyR4ccqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4556

Hello,

On 2/2/24 18:09, Sean Christopherson wrote:
> Add a basic SEV smoke test.  Unlike the intra-host migration tests, this
> one actually runs a small chunk of code in the guest.
> 
> v8:
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
> V7
>   * https://lore.kernel.org/all/20231218161146.3554657-1-pgonda@google.com
>   * See https://github.com/sean-jc/linux/tree/x86/sev_selftests_for_peter.
>   * I kept is_pt_protected because without it the page tables are never
>   readable. Its used for the elf loading in kvm_vm_elf_load().
> 
> V6
>   * Updated SEV VM create function based on Seanjc's feedback and new
>     changes to VM creation functions.
>   * Removed pte_me_mask based on feedback.
>   * Fixed s_bit usage based on TDX
>   * Fixed bugs and took Ackerly's code for enc_region setup code.
> 
> V5
>   * Rebase onto seanjc@'s latest ucall pool series.
>   * More review changes based on seanjc:
>   ** use protected instead of encrypted outside of SEV specific files
>   ** Swap memcrypt struct for kvm_vm_arch arch specific struct
>   ** Make protected page table data agnostic of address bit stealing specifics
>      of SEV
>   ** Further clean up for SEV library to just vm_sev_create_one_vcpu()
>   * Due to large changes moved more authorships from mroth@ to pgonda@. Gave
>     originally-by tags to mroth@ as suggested by Seanjc for this.
> 
> V4
>   * Rebase ontop of seanjc@'s latest Ucall Pool series:
>     https://lore.kernel.org/linux-arm-kernel/20220825232522.3997340-8-seanjc@google.com/
>   * Fix up review comments from seanjc
>   * Switch authorship on 2 patches because of significant changes, added
>   * Michael as suggested-by or originally-by.
> 
> V3
>   * Addressed more of andrew.jones@ in ucall patches.
>   * Fix build in non-x86 archs.
> 
> V2
>   * Dropped RFC tag
>   * Correctly separated Sean's ucall patches into 2 as originally
>     intended.
>   * Addressed andrew.jones@ in ucall patches.
>   * Fixed ucall pool usage to work for other archs
> 
> V1
>   * https://lore.kernel.org/all/20220715192956.1873315-1-pgonda@google.com/
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
> Sean Christopherson (2):
>    KVM: selftests: Extend VM creation's @shape to allow control of VM
>      subtype
>    KVM: selftests: Use the SEV library APIs in the intra-host migration
>      test
> 
>   tools/testing/selftests/kvm/Makefile          |   2 +
>   .../kvm/include/aarch64/kvm_util_arch.h       |   7 +
>   .../selftests/kvm/include/kvm_util_base.h     |  50 ++++++-
>   .../kvm/include/riscv/kvm_util_arch.h         |   7 +
>   .../kvm/include/s390x/kvm_util_arch.h         |   7 +
>   .../testing/selftests/kvm/include/sparsebit.h |  56 +++++---
>   .../kvm/include/x86_64/kvm_util_arch.h        |  23 ++++
>   .../selftests/kvm/include/x86_64/processor.h  |   8 ++
>   .../selftests/kvm/include/x86_64/sev.h        | 110 +++++++++++++++
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  67 +++++++--
>   tools/testing/selftests/kvm/lib/sparsebit.c   |  48 +++----
>   .../testing/selftests/kvm/lib/ucall_common.c  |   3 +-
>   .../selftests/kvm/lib/x86_64/processor.c      |  32 ++++-
>   tools/testing/selftests/kvm/lib/x86_64/sev.c  | 128 ++++++++++++++++++
>   .../selftests/kvm/x86_64/sev_migrate_tests.c  |  67 +++------
>   .../selftests/kvm/x86_64/sev_smoke_test.c     |  58 ++++++++
>   16 files changed, 570 insertions(+), 103 deletions(-)
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

Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>

Tested including TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV)); in main() too.

Thanks,
Carlos

