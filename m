Return-Path: <kvm+bounces-6729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A19838B15
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 10:56:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FCD91F21EE8
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 09:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B935C5EF;
	Tue, 23 Jan 2024 09:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="qapecDgl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2100.outbound.protection.outlook.com [40.107.243.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828AB5A0EF
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 09:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706003751; cv=fail; b=bXZNUUINQB2noDRsBjxtZg3hxF0hEi7o7BOreViYKH7bzNECgiewOnHt8N3blTvk0Tw4AylqlWONZzMvHN2afi2U2/29ZRWio9aMPKYog2Ive8uGMcS7h4BDFsJG+uo34/I2pNyseNAW0XX8dxJEzC9A66iA2Wc+L3em0DFgIv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706003751; c=relaxed/simple;
	bh=LanTen/YnMBtyG8QbVAr1EEqk5h+mZjnPaXXXAOTnmQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uqst6geGXo4TgdQurSS56KCpe18lQ5c7CYoRzZ+rBbPHxiX80xPtmfn4EyOoFm5rm+qedOsZbBTQMmIzhVNDDyDeaV0vij6pH91V1CtzdjYSc0axaTTg/uNh4Il8RwOHiIUhFS+7Q3STnYFQGJkD7UslgSQm9399WQq0hH6ZR9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=qapecDgl; arc=fail smtp.client-ip=40.107.243.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuJHss9lQpR5Ie/csBnajugbTxKond2uCiF23LYEp9049JmkeUhE6moQxqv0hGrXxq5QoA3xQSkrmesmyC5/YWfZVQHdKVbsZ+LnsdjisevdYNePKRoLdsK38CdwyHKomDSWPL5thBqDYEa5cWOCtq5VM+q0zGzFdpfOF6JuGvXNrDJ8b1ga5sFBqggkviDBVpjd/+lwGYG9oFm1i2fLTWkbfgVCM+gwtGVT7Ch86Xtpy53+TGR4Oyu0jBeEMmx/lUERu9pHatafBJBw+SGf7DunA768HupjkhGr1949L8LP8ug67R8G7fNygZiIlmQF7cQOp66D0AihbC9IjxH+Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNLKHN4SYB4/aLGEBnK5ImbiaMQO2OGmZX0oEGg4n7c=;
 b=jTli7L7Xwbm0Mcq6LsTfqJt0qsRfuWUxaMkikvqc+v48oeYTwcTyFHZYT2IMtySskKJVSHlGfR7PbZyPlhozXCpetzxDF2+EjSIc/lcB6OA+GugMutRwZ8LS+ifPGiMIjxX0a3Hdf1KqDm0uPrJX8/BpwpAIlW3NKs+ccnB9+V4BRbTMjoGO0jhbhdrYrxW7tHsYGh2QnPKl08FkBLZMCAlkFYLZnV8sWztt1qeiel66tiZ+f0ePHmTu9tDegsFkg/dCxrCsjjdV0ozZq8fN4E0OjV6EUnHrLXo6ydGwgKxATxtNz9vsMmUPWNbWq77GlLnarEFZUoZ049zru2zuvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNLKHN4SYB4/aLGEBnK5ImbiaMQO2OGmZX0oEGg4n7c=;
 b=qapecDgloEbEO4E1hsYYjG/LbilDxk+OMnj+ur4DT994YSGf+2jY9akzupZfRQvuEVQOT2ghNu/GCkkTwMfSf70X+ymy/UeVOV3WqTuYL8fu2qU5bRX2Hu+E+WuchPg0Qn2Q9wWzWFYeqXmuJQGZV9sAB+jKio4J2oNAuEyOi94=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 MW6PR01MB8317.prod.exchangelabs.com (2603:10b6:303:23d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.32; Tue, 23 Jan 2024 09:55:44 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::a0ca:67bd:8f75:4f37]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::a0ca:67bd:8f75:4f37%5]) with mapi id 15.20.7202.031; Tue, 23 Jan 2024
 09:55:44 +0000
Message-ID: <f0416fa9-b4f1-4bad-a73b-b1d7ecbffc62@os.amperecomputing.com>
Date: Tue, 23 Jan 2024 15:25:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 17/43] KVM: arm64: nv: Support multiple nested Stage-2
 mmu structures
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 D Scott Phillips <scott@os.amperecomputing.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <20231120131027.854038-18-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20231120131027.854038-18-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0349.namprd03.prod.outlook.com
 (2603:10b6:610:11a::33) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|MW6PR01MB8317:EE_
X-MS-Office365-Filtering-Correlation-Id: bed74de5-df08-4566-9901-08dc1bf9770a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dty9FE719sd9UJTllSnok3KLQ1c6vS+8rhWyWnppZtyeVaKMY5GKhJSO4X67PRcZiuhvsdVxhXSeRMKEx/kAhIF/c59XD506Fm76IJreX0FTWeifNKTcK8MTBeSOQt1FhrDBsdbAmiR6LNI0oXLHluZG2m4bv8WAitg59UEZH3QfovlqOjh7b3YNUzg2xJYNUndfNnw89GIGs+TVu2cAnDkuKVGX0XAvKImQTQZ+WI4hzarsu1VperPfqvRvOz+1NAlrpxvRiZb2/xygfO8dCEWJpgV2xhyi+kvVVCJP1lQu4+lkuLRsUOZcNYDt2pES8OPWoV/ytZKOqcWphaYiZzgNT1v+t7oyJJsUEsm+MW5PQ4nr4EQ8Ak+GNfO1FhyBy9Iw5pQg/GiqnXmKWorBeN78LfQlQI9Eb29JPssjvdzNFdp2g0zX2VBMr9gWWpdhGCsAKFNumd84TrqNLUuZYZvy3lOxfWy4iLOYyoaLROM4VHLAVOlX6NUzhD7L2Uyd41zfqyG6KOPGf94nlt/us/WupbJHspmnvU46qB+jF9PgKa7D8etaYmU1ARZyJ1hMAc7mvs94JXrypRg7BoUcgqZbqv9TFjNQpDdtCdh/+ZpGF5LRNG4kCV1SMco4r5uY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39850400004)(366004)(136003)(396003)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(66899024)(6666004)(478600001)(41300700001)(31696002)(86362001)(38100700002)(83380400001)(5660300002)(6506007)(316002)(8936002)(4326008)(6512007)(8676002)(6486002)(7416002)(66476007)(26005)(66946007)(2906002)(66556008)(30864003)(107886003)(54906003)(53546011)(2616005)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cG55amJ6bWZiaEVnUndmOC9UR05idDZEYk41a3lxZTdPVU4xUVEzUnJPYWFB?=
 =?utf-8?B?bXpJa1ZyaTc1ckNvZXRPZ2lWYm5BNGY0TkZGcmFsSHpHNzh5bnZITmxMa1FN?=
 =?utf-8?B?OE81c1ZUam9GN1NRNDh5K1FaVld3emhBV0loTGE1WFVSZnpxZnNwUG1tOHhu?=
 =?utf-8?B?VmJDR0loK3E2ZzJWd0RaSHFuazZPVXFGNWZmVmJESmRGL25kNmJyb29VZU9D?=
 =?utf-8?B?MVhvbjZYRVg2MnUwdndxS0VIRG1IL0todmRFdlZxUEdBMWYzcnpHRUdRNnEx?=
 =?utf-8?B?M2Z0dDQwTmhYOXJJT0JES1VIL2V0YU1LOGNlNENkazY0bWVDNWJvMDA4aXlF?=
 =?utf-8?B?QnpmR0FlNVc1TWhmVGNvR0d1amE3VHlyckd4Yis5VE5wa2dJVkphT1kyNUNT?=
 =?utf-8?B?S0hsemhwbWVoaE43c0VZb2JZMnk5MEMvYjBYQXcxTFpJRE1yQ0gvTGMxM2tq?=
 =?utf-8?B?MjA5a0tIL1ZPWGh6YWlkdjhHaE4za0FxR2ptai9TRjBJdXp6bHZkbDFCQnYy?=
 =?utf-8?B?c09sOStlc25TV2Vjb2tFMHRJbnFyVjlnL2tNa3Z2RUEwQStXRGRvam5aZElj?=
 =?utf-8?B?UUZXMTdUQnVhMjFpK3BER1NKZkFtU0EzZEZNemNZU2VyR3lIY0lMVDB3VXN3?=
 =?utf-8?B?a1J1WVE2aFdZMkI4QlVZUDBvY0lUVW1DOXlPZW9zYWUzUHVhY3FRT1hSdXdk?=
 =?utf-8?B?MWxpQ1J3ZC81Z3REZjBjK0IwR2huUnJqTG52UlN1bFlwckpsZDd4ckgySEJY?=
 =?utf-8?B?T3FzanNmanNMYTFIWFJlN0R4N3JKam9paTczcHJpaWVMcmkvcmtIcVdTa2Fa?=
 =?utf-8?B?ZDRydWhSRUVjeDBJWGgvYmY2Z0NrN0JIVjlYTWRwanlUTVpwZE5CWGRKbDB1?=
 =?utf-8?B?UWR5Q2MvWkZLYzRFd3ZZSHJoRzVNeG80c1lJeE5WbFVEZ3lsREFrenIzeXBj?=
 =?utf-8?B?ak9FUVRZeFB1eFA1VEllZDZnSFJTSUlPNUo0Vng1elAvMFc5MFBrblVJbXpD?=
 =?utf-8?B?SFJ4d2w5NHM3OEk1bEo2WWwwYXArZ0tDL2ttdFJTZSt1OUlFenJJNFdiM2Rj?=
 =?utf-8?B?dTV3M2p4ZWFncUtDdHJEdHhFODdXLzdpQzlEMlpBcGJueW9nbnVqMHpaWitJ?=
 =?utf-8?B?aGFmbGhIZUwyQ3BVOHdaSWt4NURyL0dudEh1WlJCcitjaVhLTStpOHBTV1RQ?=
 =?utf-8?B?K1VzR3NXY1ZvV255eGlPT1hxUG9PWnRKbjZsTGFsRkNCRnVTUjhTTDVnYytM?=
 =?utf-8?B?Sk80d3p6UTQyMUZrcjZnWmQ0MmxlZXMwSVVBbW9aM0l1aUZjM05XL1RSd3Ni?=
 =?utf-8?B?aDRzdGhqRDdTYW0vZVRWakdHUXAxWFpyTGkzMSszUVB3YStXUTJWTFI0UDJF?=
 =?utf-8?B?c0NvdXBrcjVEVVZPQ3B1YzZaeDFNTGVDSTBsVVppWnlGSnJlQVc1L2x5MHdI?=
 =?utf-8?B?cEMrLytUMFhLZEdnWUpWWWRwT2FqS0dEN0VVczFoUkx4aW50eGsvTlljamk1?=
 =?utf-8?B?VzFNQm9zQTcxbC9rUmRnZGVUblNyUXFnUThVOFM4cEkzWVd6eCt1cUlLVU5S?=
 =?utf-8?B?MTFXL0pVckJLcEpFMmR4WEhLdWdBM1FZbTVuNnd4Q2FlWm5HRXlIcGVxR1Nn?=
 =?utf-8?B?UjExT29yampKaVFrN1pBeGhnRnhPZTR3V2ZKVGE3RU5LM29lcWx1QVBIUnlG?=
 =?utf-8?B?cHg2b1NaSC9nVkI2SlJOMFpVSGNxRkhSZUNHY1N0aXVJc3MydWlCUzR0dmgx?=
 =?utf-8?B?UVVOYWZJUEhlaml6SGZqc0MzWkQyaEFlQXoyNXFQckNmZHVDMXE4Y1A3SE9H?=
 =?utf-8?B?SDJjQTNXS2c1a1M4K05SSjY3Q0pnVGZDRkZ5c3pQWjR4QWhBbzlWSnoyTWZy?=
 =?utf-8?B?SVprUGxobnVJSU1PeGN3KzVqUnZOM0lvdHNMV3AxSTJ1b3NZYVBXdmFnY1ZU?=
 =?utf-8?B?VStIR0lFR0pRT3pjblVSN0htZEQ5NjMrY2kwTDlRMUdFSmFwZ0lxb24yeVNJ?=
 =?utf-8?B?V0M1am1BWXlvRFVNYmFsa2lkL3ZGRzNqRDFmRXFURUtWRzNqT3BQeERtSEd6?=
 =?utf-8?B?RGcyY2kwRURROHhWSTVuYnJRRlI4ZzhnQkFxMzF3MEoyVzVlUFdwamNESDFD?=
 =?utf-8?B?REJSWVE4UmdRWmdmOVBxR2xHalNkWGpoMFgwdVFNSDkvMk43MGFBRXFSNzhw?=
 =?utf-8?Q?yTs+0VkYs6roY4hYtsBfcohCAn01K8X4+OJylnk+U8KW?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bed74de5-df08-4566-9901-08dc1bf9770a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 09:55:44.0273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7hisCL9ZASpoDau9WJwqypHiJCo5HMUNTs8S6vVJ8Xf0qEfxPJCa9YmyfbVVyI7QtUnDV2vyA5YSkxCwyi//YgZZJiI3iLNeBcoc1+S4eZDh3zkEsBO1BbSP8mDabjwY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR01MB8317


Hi Marc,

On 20-11-2023 06:40 pm, Marc Zyngier wrote:
> Add Stage-2 mmu data structures for virtual EL2 and for nested guests.
> We don't yet populate shadow Stage-2 page tables, but we now have a
> framework for getting to a shadow Stage-2 pgd.
> 
> We allocate twice the number of vcpus as Stage-2 mmu structures because
> that's sufficient for each vcpu running two translation regimes without
> having to flush the Stage-2 page tables.
> 
> Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h   |  41 ++++++
>   arch/arm64/include/asm/kvm_mmu.h    |   9 ++
>   arch/arm64/include/asm/kvm_nested.h |   7 +
>   arch/arm64/kvm/arm.c                |  12 ++
>   arch/arm64/kvm/mmu.c                |  78 ++++++++---
>   arch/arm64/kvm/nested.c             | 207 ++++++++++++++++++++++++++++
>   arch/arm64/kvm/reset.c              |   6 +
>   7 files changed, 338 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f17fb7c42973..eb96fe9b686e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -188,8 +188,40 @@ struct kvm_s2_mmu {
>   	uint64_t split_page_chunk_size;
>   
>   	struct kvm_arch *arch;
> +
> +	/*
> +	 * For a shadow stage-2 MMU, the virtual vttbr used by the
> +	 * host to parse the guest S2.
> +	 * This either contains:
> +	 * - the virtual VTTBR programmed by the guest hypervisor with
> +         *   CnP cleared
> +	 * - The value 1 (VMID=0, BADDR=0, CnP=1) if invalid
> +	 *
> +	 * We also cache the full VTCR which gets used for TLB invalidation,
> +	 * taking the ARM ARM's "Any of the bits in VTCR_EL2 are permitted
> +	 * to be cached in a TLB" to the letter.
> +	 */
> +	u64	tlb_vttbr;
> +	u64	tlb_vtcr;
> +
> +	/*
> +	 * true when this represents a nested context where virtual
> +	 * HCR_EL2.VM == 1
> +	 */
> +	bool	nested_stage2_enabled;
> +
> +	/*
> +	 *  0: Nobody is currently using this, check vttbr for validity
> +	 * >0: Somebody is actively using this.
> +	 */
> +	atomic_t refcnt;
>   };
>   
> +static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
> +{
> +	return !(mmu->tlb_vttbr & 1);
> +}
> +
>   struct kvm_arch_memory_slot {
>   };
>   
> @@ -241,6 +273,14 @@ static inline u16 kvm_mpidr_index(struct kvm_mpidr_data *data, u64 mpidr)
>   struct kvm_arch {
>   	struct kvm_s2_mmu mmu;
>   
> +	/*
> +	 * Stage 2 paging state for VMs with nested S2 using a virtual
> +	 * VMID.
> +	 */
> +	struct kvm_s2_mmu *nested_mmus;
> +	size_t nested_mmus_size;
> +	int nested_mmus_next;
> +
>   	/* Interrupt controller */
>   	struct vgic_dist	vgic;
>   
> @@ -1186,6 +1226,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
>   void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu);
>   
>   int __init kvm_set_ipa_limit(void);
> +u32 kvm_get_pa_bits(struct kvm *kvm);
>   
>   #define __KVM_HAVE_ARCH_VM_ALLOC
>   struct kvm *kvm_arch_alloc_vm(void);
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 49e0d4b36bd0..5c6fb2fb8287 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -119,6 +119,7 @@ alternative_cb_end
>   #include <asm/mmu_context.h>
>   #include <asm/kvm_emulate.h>
>   #include <asm/kvm_host.h>
> +#include <asm/kvm_nested.h>
>   
>   void kvm_update_va_mask(struct alt_instr *alt,
>   			__le32 *origptr, __le32 *updptr, int nr_inst);
> @@ -171,6 +172,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>   int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr);
>   void __init free_hyp_pgds(void);
>   
> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
>   void stage2_unmap_vm(struct kvm *kvm);
>   int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
>   void kvm_uninit_stage2_mmu(struct kvm *kvm);
> @@ -339,5 +341,12 @@ static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>   {
>   	return container_of(mmu->arch, struct kvm, arch);
>   }
> +
> +static inline u64 get_vmid(u64 vttbr)
> +{
> +	return (vttbr & VTTBR_VMID_MASK(kvm_get_vmid_bits())) >>
> +		VTTBR_VMID_SHIFT;
> +}
> +
>   #endif /* __ASSEMBLY__ */
>   #endif /* __ARM64_KVM_MMU_H__ */
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index aa085f2f1947..f421ad294e68 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -60,6 +60,13 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
>   	return ttbr0 & ~GENMASK_ULL(63, 48);
>   }
>   
> +extern void kvm_init_nested(struct kvm *kvm);
> +extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
> +extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
> +extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
> +extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
> +extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
> +
>   extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
>   extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index b65df612b41b..2e76892c1a56 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -147,6 +147,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	mutex_unlock(&kvm->lock);
>   #endif
>   
> +	kvm_init_nested(kvm);
> +
>   	ret = kvm_share_hyp(kvm, kvm + 1);
>   	if (ret)
>   		return ret;
> @@ -429,6 +431,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	struct kvm_s2_mmu *mmu;
>   	int *last_ran;
>   
> +	if (vcpu_has_nv(vcpu))
> +		kvm_vcpu_load_hw_mmu(vcpu);
> +
>   	mmu = vcpu->arch.hw_mmu;
>   	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
>   
> @@ -479,9 +484,12 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   	kvm_timer_vcpu_put(vcpu);
>   	kvm_vgic_put(vcpu);
>   	kvm_vcpu_pmu_restore_host(vcpu);
> +	if (vcpu_has_nv(vcpu))
> +		kvm_vcpu_put_hw_mmu(vcpu);
>   	kvm_arm_vmid_clear_active();
>   
>   	vcpu_clear_on_unsupported_cpu(vcpu);
> +
>   	vcpu->cpu = -1;
>   }
>   
> @@ -1336,6 +1344,10 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
>   	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu)
>   		ret = kvm_arm_set_default_pmu(kvm);
>   
> +	/* Prepare for nested if required */
> +	if (!ret)
> +		ret = kvm_vcpu_init_nested(vcpu);
> +
>   	return ret;
>   }
>   
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d87c8fcc4c24..588ce46c0ad0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -305,7 +305,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * does.
>    */
>   /**
> - * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
> + * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
>    * @mmu:   The KVM stage-2 MMU pointer
>    * @start: The intermediate physical base address of the range to unmap
>    * @size:  The size of the area to unmap
> @@ -328,7 +328,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   				   may_block));
>   }
>   
> -static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
>   {
>   	__unmap_stage2_range(mmu, start, size, true);
>   }
> @@ -853,21 +853,9 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>   	.icache_inval_pou	= invalidate_icache_guest_page,
>   };
>   
> -/**
> - * kvm_init_stage2_mmu - Initialise a S2 MMU structure
> - * @kvm:	The pointer to the KVM structure
> - * @mmu:	The pointer to the s2 MMU structure
> - * @type:	The machine type of the virtual machine
> - *
> - * Allocates only the stage-2 HW PGD level table(s).
> - * Note we don't need locking here as this is only called when the VM is
> - * created, which can only be done once.
> - */
> -int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type)
> +static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
>   {
>   	u32 kvm_ipa_limit = get_kvm_ipa_limit();
> -	int cpu, err;
> -	struct kvm_pgtable *pgt;
>   	u64 mmfr0, mmfr1;
>   	u32 phys_shift;
>   
> @@ -894,11 +882,58 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
>   	mmu->vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
>   
> +	return 0;
> +}
> +
> +/**
> + * kvm_init_stage2_mmu - Initialise a S2 MMU structure
> + * @kvm:	The pointer to the KVM structure
> + * @mmu:	The pointer to the s2 MMU structure
> + * @type:	The machine type of the virtual machine
> + *
> + * Allocates only the stage-2 HW PGD level table(s).
> + * Note we don't need locking here as this is only called in two cases:
> + *
> + * - when the VM is created, which can't race against anything
> + *
> + * - when secondary kvm_s2_mmu structures are initialised for NV
> + *   guests, and the caller must hold kvm->lock as this is called on a
> + *   per-vcpu basis.
> + */
> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type)
> +{
> +	int cpu, err;
> +	struct kvm_pgtable *pgt;
> +
> +	/*
> +	 * If we already have our page tables in place, and that the
> +	 * MMU context is the canonical one, we have a bug somewhere,
> +	 * as this is only supposed to ever happen once per VM.
> +	 *
> +	 * Otherwise, we're building nested page tables, and that's
> +	 * probably because userspace called KVM_ARM_VCPU_INIT more
> +	 * than once on the same vcpu. Since that's actually legal,
> +	 * don't kick a fuss and leave gracefully.
> +	 */
>   	if (mmu->pgt != NULL) {
> +		if (&kvm->arch.mmu != mmu)
> +			return 0;
> +
>   		kvm_err("kvm_arch already initialized?\n");
>   		return -EINVAL;
>   	}
>   
> +	/*
> +	 * We only initialise the IPA range on the canonical MMU, so
> +	 * the type is meaningless in all other situations.
> +	 */
> +	if (&kvm->arch.mmu != mmu)
> +		type = kvm_get_pa_bits(kvm);
> +
> +	err = kvm_init_ipa_range(mmu, type);
> +	if (err)
> +		return err;
> +
>   	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL_ACCOUNT);
>   	if (!pgt)
>   		return -ENOMEM;
> @@ -923,6 +958,10 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   
>   	mmu->pgt = pgt;
>   	mmu->pgd_phys = __pa(pgt->pgd);
> +
> +	if (&kvm->arch.mmu != mmu)
> +		kvm_init_nested_s2_mmu(mmu);
> +
>   	return 0;
>   
>   out_destroy_pgtable:
> @@ -974,7 +1013,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>   
>   		if (!(vma->vm_flags & VM_PFNMAP)) {
>   			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
> -			unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
> +			kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
>   		}
>   		hva = vm_end;
>   	} while (hva < reg_end);
> @@ -2054,11 +2093,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
>   {
>   }
>   
> -void kvm_arch_flush_shadow_all(struct kvm *kvm)
> -{
> -	kvm_uninit_stage2_mmu(kvm);
> -}
> -
>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   				   struct kvm_memory_slot *slot)
>   {
> @@ -2066,7 +2100,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   	phys_addr_t size = slot->npages << PAGE_SHIFT;
>   
>   	write_lock(&kvm->mmu_lock);
> -	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
> +	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
>   	write_unlock(&kvm->mmu_lock);
>   }
>   
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 66d05f5d39a2..c5752ab8c3fe 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -7,7 +7,9 @@
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
>   
> +#include <asm/kvm_arm.h>
>   #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/kvm_nested.h>
>   #include <asm/sysreg.h>
>   
> @@ -16,6 +18,211 @@
>   /* Protection against the sysreg repainting madness... */
>   #define NV_FTR(r, f)		ID_AA64##r##_EL1_##f
>   
> +void kvm_init_nested(struct kvm *kvm)
> +{
> +	kvm->arch.nested_mmus = NULL;
> +	kvm->arch.nested_mmus_size = 0;
> +}
> +
> +int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_s2_mmu *tmp;
> +	int num_mmus;
> +	int ret = -ENOMEM;
> +
> +	if (!test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->kvm->arch.vcpu_features))
> +		return 0;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> +		return -EINVAL;
> +
> +	/*
> +	 * Let's treat memory allocation failures as benign: If we fail to
> +	 * allocate anything, return an error and keep the allocated array
> +	 * alive. Userspace may try to recover by intializing the vcpu
> +	 * again, and there is no reason to affect the whole VM for this.
> +	 */
> +	num_mmus = atomic_read(&kvm->online_vcpus) * 2;
> +	tmp = krealloc(kvm->arch.nested_mmus,
> +		       num_mmus * sizeof(*kvm->arch.nested_mmus),
> +		       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (tmp) {
> +		/*
> +		 * If we went through a realocation, adjust the MMU
> +		 * back-pointers in the previously initialised
> +		 * pg_table structures.
> +		 */
> +		if (kvm->arch.nested_mmus != tmp) {
> +			int i;
> +
> +			for (i = 0; i < num_mmus - 2; i++)
> +				tmp[i].pgt->mmu = &tmp[i];
> +		}
> +
> +		if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1], 0) ||
> +		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2], 0)) {
> +			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
> +			kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
> +		} else {
> +			kvm->arch.nested_mmus_size = num_mmus;
> +			ret = 0;
> +		}
> +
> +		kvm->arch.nested_mmus = tmp;
> +	}
> +
> +	return ret;
> +}
> +
> +/* Must be called with kvm->mmu_lock held */
> +struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
> +{
> +	bool nested_stage2_enabled;
> +	u64 vttbr, vtcr, hcr;
> +	struct kvm *kvm;
> +	int i;
> +
> +	kvm = vcpu->kvm;
> +
> +	vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
> +	vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
> +	hcr = vcpu_read_sys_reg(vcpu, HCR_EL2);
> +
> +	nested_stage2_enabled = hcr & HCR_VM;
> +
> +	/* Don't consider the CnP bit for the vttbr match */
> +	vttbr = vttbr & ~VTTBR_CNP_BIT;
> +
> +	/*
> +	 * Two possibilities when looking up a S2 MMU context:
> +	 *
> +	 * - either S2 is enabled in the guest, and we need a context that is
> +         *   S2-enabled and matches the full VTTBR (VMID+BADDR) and VTCR,
> +         *   which makes it safe from a TLB conflict perspective (a broken
> +         *   guest won't be able to generate them),
> +	 *
> +	 * - or S2 is disabled, and we need a context that is S2-disabled
> +         *   and matches the VMID only, as all TLBs are tagged by VMID even
> +         *   if S2 translation is disabled.
> +	 */
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (!kvm_s2_mmu_valid(mmu))
> +			continue;
> +
> +		if (nested_stage2_enabled &&
> +		    mmu->nested_stage2_enabled &&
> +		    vttbr == mmu->tlb_vttbr &&
> +		    vtcr == mmu->tlb_vtcr)
> +			return mmu;
> +
> +		if (!nested_stage2_enabled &&
> +		    !mmu->nested_stage2_enabled &&
> +		    get_vmid(vttbr) == get_vmid(mmu->tlb_vttbr))
> +			return mmu;
> +	}
> +	return NULL;
> +}
> +
> +/* Must be called with kvm->mmu_lock held */
> +static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_s2_mmu *s2_mmu;
> +	int i;
> +
> +	s2_mmu = lookup_s2_mmu(vcpu);
> +	if (s2_mmu)
> +		goto out;
> +
> +	/*
> +	 * Make sure we don't always search from the same point, or we
> +	 * will always reuse a potentially active context, leaving
> +	 * free contexts unused.
> +	 */
> +	for (i = kvm->arch.nested_mmus_next;
> +	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
> +	     i++) {
> +		s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
> +
> +		if (atomic_read(&s2_mmu->refcnt) == 0)
> +			break;
> +	}
> +	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */
> +
> +	/* Set the scene for the next search */
> +	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
> +
> +	if (kvm_s2_mmu_valid(s2_mmu)) {
> +		/* Clear the old state */
> +		kvm_unmap_stage2_range(s2_mmu, 0, kvm_phys_size(s2_mmu));
> +		if (atomic64_read(&s2_mmu->vmid.id))
> +			kvm_call_hyp(__kvm_tlb_flush_vmid, s2_mmu);
> +	}
> +
> +	/*
> +	 * The virtual VMID (modulo CnP) will be used as a key when matching
> +	 * an existing kvm_s2_mmu.
> +	 *
> +	 * We cache VTCR at allocation time, once and for all. It'd be great
> +	 * if the guest didn't screw that one up, as this is not very
> +	 * forgiving...
> +	 */
> +	s2_mmu->tlb_vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2) & ~VTTBR_CNP_BIT;
> +	s2_mmu->tlb_vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
> +	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM;
> +
> +out:
> +	atomic_inc(&s2_mmu->refcnt);
> +	return s2_mmu;
> +}
> +
> +void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
> +{
> +	mmu->tlb_vttbr = 1;
> +	mmu->nested_stage2_enabled = false;
> +	atomic_set(&mmu->refcnt, 0);
> +}
> +
> +void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> +{
> +	if (is_hyp_ctxt(vcpu)) {
> +		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
> +	} else {
> +		write_lock(&vcpu->kvm->mmu_lock);
> +		vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
> +		write_unlock(&vcpu->kvm->mmu_lock);
> +	}

Due to race, there is a non-existing L2's mmu table is getting loaded 
for some of vCPU while booting L1(noticed with L1 boot using large 
number of vCPUs). This is happening since at the early stage the 
e2h(hyp-context) is not set and trap to eret of L1 boot-strap code 
resulting in context switch as if it is returning to L2(guest enter) and 
loading not initialized mmu table on those vCPUs resulting in 
unrecoverable traps and aborts.
Adding code to check (below diff fixes the issue) stage 2 is enabled and 
avoid the false ERET and continue with L1's mmu context.

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 340e2710cdda..1901dd19d770 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -759,7 +759,12 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)

  void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
  {
-       if (is_hyp_ctxt(vcpu)) {
+       bool nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2) & 
HCR_VM;
+
+       /* Load L2 mmu only if nested_stage2_enabled, avoid mmu
+        * load due to false ERET trap.
+        */
+       if (is_hyp_ctxt(vcpu) || !nested_stage2_enabled) {
                 vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
         } else {
                 write_lock(&vcpu->kvm->mmu_lock);

Hoping we dont hit this when we move completely NV2 based implementation 
and e2h is always set?
> +}
> +
> +void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu) {
> +		atomic_dec(&vcpu->arch.hw_mmu->refcnt);
> +		vcpu->arch.hw_mmu = NULL;
> +	}
> +}
> +
> +void kvm_arch_flush_shadow_all(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		WARN_ON(atomic_read(&mmu->refcnt));
> +
> +		if (!atomic_read(&mmu->refcnt))
> +			kvm_free_stage2_pgd(mmu);
> +	}
> +	kfree(kvm->arch.nested_mmus);
> +	kvm->arch.nested_mmus = NULL;
> +	kvm->arch.nested_mmus_size = 0;
> +	kvm_uninit_stage2_mmu(kvm);
> +}
> +
>   /*
>    * Our emulated CPU doesn't support all the possible features. For the
>    * sake of simplicity (and probably mental sanity), wipe out a number
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 5bb4de162cab..e106ea01598f 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -266,6 +266,12 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   	preempt_enable();
>   }
>   
> +u32 kvm_get_pa_bits(struct kvm *kvm)
> +{
> +	/* Fixed limit until we can configure ID_AA64MMFR0.PARange */
> +	return kvm_ipa_limit;
> +}
> +
>   u32 get_kvm_ipa_limit(void)
>   {
>   	return kvm_ipa_limit;

Thanks,
Ganapat

