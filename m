Return-Path: <kvm+bounces-2160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A28F7F2805
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 09:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7D20281D4B
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 08:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8D522335;
	Tue, 21 Nov 2023 08:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="EOrskTKd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2133.outbound.protection.outlook.com [40.107.243.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F57598
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 00:51:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnAnzJaIsz7M5hztheHRROluS0e/J+Bt2/mWtLmL5A5KTk6fpTg+0/ywWMuXxOIRewaSmFGiCzbOAtUgA2t+12cJBuyBNOY+0f40B/ZLAwX7PiXxNnlOW9/VAWGXINjLy+FG5VJUwfwvXtlFnrUbKbuvQgpKyhrtjiQtocROXfxfHSyRKqIJHnCcXUOPb9kNGB2zdL2D0zoUuw/GqjVFWlgdjTnACKMLRSAGJZ5Ev3rLltAmnXxudofa5m3NxgCvZxIKPRjKS3hKwOpTaSKluyw4663YeWgt7fPoGPYGJ5y2yx6CHa5/tNCVkVda1LEXOSnIl6fd36aO+e6mRuShIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BiZy5Aw5aw8eMFH/0/KMFLmy2xlGNPpYGimxXMvmF3Q=;
 b=YdOMtVE77lcjfk6LpqM+Hy9p5Ar70pleWWcR22DkM2Jealr0AUBLt+Zzf9kYd6dvmVH0NSG1pr/YIYnQ9e+Q7pz/AtSP35wdqTfaefBd5Hg4F76gnpmmsJoeK17HHhIIbR17eevC46+A/103RS1jYIoHLhkUw3SbGZChvrvORWuqUmdAUlU/AqKlOXhITALUXVs0FupfkMK7e7wq/Nc/hHqUJN+Q181niH86p99WLv3rgusn+q6BWV6FLDEI9EhOWnrQXuHlnlBGU+ht/3QM47WADDMAEtwYPjPs++II0hLsryoSzitGwMuNNnG4n/aX/L2SKldR7IwbwzferRK0QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BiZy5Aw5aw8eMFH/0/KMFLmy2xlGNPpYGimxXMvmF3Q=;
 b=EOrskTKdMcU1/lxT0fYx598afSqsyXm4ixRIJgWDcBZcM7B0iMc2o8nBHchfRzBgXIB56yCHCLzmIMqNK6iECFCvS4/RpgMBH4IJx7FTKcTD9WZ8rV3A9VYokX03mJAkHBG3UeUdXq1EkE9G0H4cd3mXbSHZPrOypOH+F3wcW9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SA1PR01MB8061.prod.exchangelabs.com (2603:10b6:806:331::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6954.28; Tue, 21 Nov 2023 08:51:46 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685%3]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 08:51:46 +0000
Message-ID: <a44660c4-e43a-4663-94c0-9b290ea755e3@os.amperecomputing.com>
Date: Tue, 21 Nov 2023 14:21:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
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
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20231120131027.854038-1-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:610:b2::14) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SA1PR01MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 788d7108-cf2e-4cbf-b74f-08dbea6f1799
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pVfNQUcXmQbexSK0HJUnQtqtdHd+44qWVOEvQtu2WyiaNhYlgiIr23W3ArcXZv6Mqty/duj50D0mMmlbwkjhKMHfI2+fFclehDvpaWTXYEgGsuTomJyGbI1h0Vs76Fipw/oL2SxGYVAU7t0kH9K/3ApjwMCV/a7EmdJHDleqfDLm2PyxD17CPqIaGg2LcDPtuoYVhjgxf0u8pFomu3q+p5esAPPJVkl7B20ey8CRLWFBoVV7D9VPTC9Zd87k3D/KD0dZysxHiydnkScxka7/Qqxb+h/G0RMJyC8FvhU18Nsym9pW9uocP5f68mtKPmvkrduMfpq6zYBa7XIN6FPb6r+6CzQ9QbUdL81XGc4Hb5ATN3dvWaKJWG+lYJPtIxgoqH/IzZFXWVdqNE+YIrHtV54U3O+zGQCWAUFyu6wjI8lkGFNjJnBqhk5adZtEjKrpnZJRUQIncbcc8HBLqjj+8LnuWmmDGguZjq+NCqehW9tsNWVxbGPC0NJTRxs3mifmSHLNKD0Yi4kollyqsAjEfZV5Arq2WgwPN/e55GEDOprEgU1NBiUPVGDMjZ+y5cSw57lABZcQsI9aqYeQBnxkTTirNegb6/3CSXVEBioY5FM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(136003)(366004)(39850400004)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(53546011)(83380400001)(6512007)(6506007)(2616005)(26005)(6666004)(66899024)(478600001)(66946007)(8676002)(4326008)(8936002)(54906003)(66556008)(2906002)(41300700001)(66476007)(6486002)(31696002)(5660300002)(7416002)(31686004)(316002)(38100700002)(86362001)(966005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWM2RGJvOFFXWlE0SVdZaVZLVzE3NjZreXhyV3UySDkxZXdGQ2hCUU5SYmlC?=
 =?utf-8?B?QytOdWRycitpSzAyZjJCQWI1U1ZSU21Ya2M2UStIZXh5dDlkc2JmNDU3ZVp1?=
 =?utf-8?B?T0RRUHdQbGNaRXhnNzR0OHBBVHR3c1k0dmF1L29GWGFQeFJTZ3pkYTJUYXNT?=
 =?utf-8?B?cXlsVmNCRUNQbC9PSFI3eFZtcy94UlRURzEvS094WXhzSlV2TkJlKzBGZ0R2?=
 =?utf-8?B?cW5JTXM2ZjBNOVRwSlVtWHVUUlIvL3d1Tm9Eb0xRVThjK0lwR2phN0tuVm85?=
 =?utf-8?B?MENpYUZLWFp2MUdCY3dzOTQzZmRYMm1jRUxTMGhsSmF4YXgzRVR0akVLenpj?=
 =?utf-8?B?L1lVV0F3L2tTd3ZHUmMvKzFrbnpKOHpCNlZPYmplaGJaZVUvOFFJbmNmeDl4?=
 =?utf-8?B?RDJ2NmE3K1gyZFFNSUVCRTdJK0ZUTm1xbDN6dWJOOXhEVVpuaWRwa1FwWXNk?=
 =?utf-8?B?eFpIdmU3WXp4blRBa2dXWGFuRkorbVVtdXB3cURUeEpHb1ZSeTdDcCtYRHJ4?=
 =?utf-8?B?S3h5bnYrR29TTmlmVVVpUzVzMjZiK3JwcG1Rb1duVjBabkVQblN4a0MvSGk2?=
 =?utf-8?B?eUkyS2J3ZHBXSG9RRXo2VWlJU0ttUE45QzdLY0VadHc1TE1UWm9ZcE1VRnB0?=
 =?utf-8?B?UjVtTGtnTHJtdHhPMEtZdjRIUjJqTnhqeVJyVXhYZEZMbWgzeWVzT2ozOGpo?=
 =?utf-8?B?RnZOZDRZK3VsY1I0ajRoL3Buc3gxMitwR3IxNmVoWGFBT3JiM1dRak92NHE4?=
 =?utf-8?B?VTNocVpnQUd0M1JRZ0RpVENBcFFXVEVFS1o0VkZwTmhFVjFicm1RalZGaGJG?=
 =?utf-8?B?bm1yNlZUaStTWWQ5MmxwOEtoV0t4SEtQY2t6RWtSNjJjM0VuQktZdXNqbms3?=
 =?utf-8?B?U1dtVWhlVHR0V3pKNEh4aHp6eklJdXo3SlRiRFFzRUQ3WnRxTHExNHJXVWNu?=
 =?utf-8?B?MW9LYlBLeXp6bUZ4VXlJTTBVME0rTW1sR2lBMFdJbjJRVDdNUkhONm9sZVBF?=
 =?utf-8?B?Vkpab284OEJVUlcvU0xja1VUdW1wNVhDWWNxc01aSjlodm0yZW00a2dpUDFP?=
 =?utf-8?B?dnA5ZkFXR1VYSDNjbUc2dHIwckdLMmxBK2pOcnZuTTZwMUhQYzI0MmFBUVNt?=
 =?utf-8?B?N1NoMnl1UmF2eVZ0eFo5WnNqUGJwQjdYSjhxUFNkNjVHN1pVRG9zN2Y1RzlM?=
 =?utf-8?B?ZGdRMWo1VUNhdVIzMlozWGtDUzMvSEtJeUZjUHczdlNvc1daVDJ3MDFNM0Iy?=
 =?utf-8?B?aGo4dDJoNTY0aElvNmY0UUxOZkhBVk1sc1BtQ0pYSlhRalRSeWozN25FV2lZ?=
 =?utf-8?B?N0MxaytRa1AvMkNubEhxMUNSdFNWcFI4aWwzdXBmN241UGppVWNiZFZsanBV?=
 =?utf-8?B?T2c1enNQcGpENWVseWV3WE1qK0FRekptak9oOUhUYjFERkRNM0djd3pMQUcw?=
 =?utf-8?B?dHRZK1FkUitSVWZMZm5PMWd4Nlg3OTdKSWppUHpyMDVyVXZaelR1elY3YjVt?=
 =?utf-8?B?b01taVB3NGZtOG1oMCt2TU82V0RMdFBIQ1cxWkRoNmxQMmZxQjVKMURUVkdJ?=
 =?utf-8?B?Y0VKcTRLK1FwNmVINzJGZlF2SmRmamNqVUJNdzc1ek9DeU1FUWQ5VDVGajB1?=
 =?utf-8?B?VnpERzVwWDExUkxQYzFyM21RU0c2aFhDVWMwdnI1cSszemVWUEdVSFVneVlZ?=
 =?utf-8?B?TnM0bFhJNnVscE52dU45RDdvU3pEQXBac0NDVlIrVkY3OTE3a2g4bkdYL3Fy?=
 =?utf-8?B?RVdqMzBERVl4dTJoOTRhTm9pbG5idEduZ2xoVU4rZWplSldhNGMwenRwSWxm?=
 =?utf-8?B?T2liQytacXovSHJna2NqdTBBSlpsSE54SnlVdFFUOW94d3Eyd1I4SENpL21h?=
 =?utf-8?B?V01MU0YrM0ZIMmRtTFlrNENXZzlFM3hBSVRDa0swcElvRU1oSEpBS3V1Undk?=
 =?utf-8?B?YUJGL1RZVFlrYWk4dXViYjg3M3hiYkcxSEg0bFEvcEpqYjN2V3FWRzJOeWMw?=
 =?utf-8?B?a0pYTE00K1g2SlpxZGtsaTNBV3picWN4NVhVS0I1Sm52Wjh0UHZsWTFpOFR1?=
 =?utf-8?B?RHR4ZHVHZnF5a3o0U1l3VUtxZlhTaWpIMkhJU2NZWnp1c2ErUW9xSWpMOGE4?=
 =?utf-8?B?dmhxMDJLREVrMWZGNmpuV3ZLay9oVjB5aHRpcDlMRjJwYjBRTUF4QXlwMzVU?=
 =?utf-8?Q?x92/dzCJWOV4jjd26TL/jYiqaZE203zXsS5VfiaKzGpt?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 788d7108-cf2e-4cbf-b74f-08dbea6f1799
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2023 08:51:46.2633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwIQi2k0mkA3RwY7/dgcgqpZHjMc6gyPc7MSi4+Wi5czEZmPAWQgDVQkqjLnwWkn8gENurdgsJAxlOvN7Ak4d32Ue57O0RF/d37soq6hqUiJOkiqviklyfiOitzXQLrk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8061


Hi Marc,

On 20-11-2023 06:39 pm, Marc Zyngier wrote:
> This is the 5th drop of NV support on arm64 for this year, and most
> probably the last one for this side of Christmas.
> 
> For the previous episodes, see [1].
> 
> What's changed:
> 
> - Drop support for the original FEAT_NV. No existing hardware supports
>    it without FEAT_NV2, and the architecture is deprecating the former
>    entirely. This results in fewer patches, and a slightly simpler
>    model overall.
> 
> - Reorganise the series to make it a bit more logical now that FEAT_NV
>    is gone.
> 
> - Apply the NV idreg restrictions on VM first run rather than on each
>    access.
> 
> - Make the nested vgic shadow CPU interface a per-CPU structure rather
>    than per-vcpu.
> 
> - Fix the EL0 timer fastpath
> 
> - Work around the architecture deficiencies when trapping WFI from a
>    L2 guest.
> 
> - Fix sampling of nested vgic state (MISR, ELRSR, EISR)
> 
> - Drop the patches that have already been merged (NV trap forwarding,
>    per-MMU VTCR)
> 
> - Rebased on top of 6.7-rc2 + the FEAT_E2H0 support [2].
> 
> The branch containing these patches (and more) is at [3]. As for the
> previous rounds, my intention is to take a prefix of this series into
> 6.8, provided that it gets enough reviewing.
> 
> [1] https://lore.kernel.org/r/20230515173103.1017669-1-maz@kernel.org
> [2] https://lore.kernel.org/r/20231120123721.851738-1-maz@kernel.org
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.8-nv2-only
>

V11 series is not booting on Ampere platform (I am yet to debug).
With lkvm, it is stuck at the very early stage itself and no early boot 
prints/logs.

Are there any changes needed in kvmtool for V11?

> Andre Przywara (1):
>    KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
> 
> Christoffer Dall (2):
>    KVM: arm64: nv: Implement nested Stage-2 page table walk logic
>    KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
> 
> Jintack Lim (3):
>    KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
>    KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
>    KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
> 
> Marc Zyngier (37):
>    arm64: cpufeatures: Restrict NV support to FEAT_NV2
>    KVM: arm64: nv: Hoist vcpu_has_nv() into is_hyp_ctxt()
>    KVM: arm64: nv: Compute NV view of idregs as a one-off
>    KVM: arm64: nv: Drop EL12 register traps that are redirected to VNCR
>    KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
>    KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
>    KVM: arm64: Introduce a bad_trap() primitive for unexpected trap
>      handling
>    KVM: arm64: nv: Add EL2_REG_VNCR()/EL2_REG_REDIR() sysreg helpers
>    KVM: arm64: nv: Map VNCR-capable registers to a separate page
>    KVM: arm64: nv: Handle virtual EL2 registers in
>      vcpu_read/write_sys_reg()
>    KVM: arm64: nv: Handle HCR_EL2.E2H specially
>    KVM: arm64: nv: Handle CNTHCTL_EL2 specially
>    KVM: arm64: nv: Save/Restore vEL2 sysregs
>    KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
>    KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
>    KVM: arm64: nv: Handle shadow stage 2 page faults
>    KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
>    KVM: arm64: nv: Set a handler for the system instruction traps
>    KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
>    KVM: arm64: nv: Hide RAS from nested guests
>    KVM: arm64: nv: Add handling of EL2-specific timer registers
>    KVM: arm64: nv: Sync nested timer state with FEAT_NV2
>    KVM: arm64: nv: Publish emulated timer interrupt state in the
>      in-memory state
>    KVM: arm64: nv: Load timer before the GIC
>    KVM: arm64: nv: Nested GICv3 Support
>    KVM: arm64: nv: Don't block in WFI from nested state
>    KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
>    KVM: arm64: nv: Deal with broken VGIC on maintenance interrupt
>      delivery
>    KVM: arm64: nv: Add handling of FEAT_TTL TLB invalidation
>    KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like
>      information
>    KVM: arm64: nv: Tag shadow S2 entries with nested level
>    KVM: arm64: nv: Allocate VNCR page when required
>    KVM: arm64: nv: Fast-track 'InHost' exception returns
>    KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
>    KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
>    KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on
>    KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
> 
>   .../virt/kvm/devices/arm-vgic-v3.rst          |  12 +-
>   arch/arm64/include/asm/esr.h                  |   1 +
>   arch/arm64/include/asm/kvm_arm.h              |   3 +
>   arch/arm64/include/asm/kvm_asm.h              |   4 +
>   arch/arm64/include/asm/kvm_emulate.h          |  53 +-
>   arch/arm64/include/asm/kvm_host.h             | 223 +++-
>   arch/arm64/include/asm/kvm_hyp.h              |   2 +
>   arch/arm64/include/asm/kvm_mmu.h              |  12 +
>   arch/arm64/include/asm/kvm_nested.h           | 130 ++-
>   arch/arm64/include/asm/sysreg.h               |   7 +
>   arch/arm64/include/asm/vncr_mapping.h         | 102 ++
>   arch/arm64/include/uapi/asm/kvm.h             |   1 +
>   arch/arm64/kernel/cpufeature.c                |  22 +-
>   arch/arm64/kvm/Makefile                       |   4 +-
>   arch/arm64/kvm/arch_timer.c                   | 115 +-
>   arch/arm64/kvm/arm.c                          |  46 +-
>   arch/arm64/kvm/at.c                           | 219 ++++
>   arch/arm64/kvm/emulate-nested.c               |  48 +-
>   arch/arm64/kvm/handle_exit.c                  |  29 +-
>   arch/arm64/kvm/hyp/include/hyp/switch.h       |   8 +-
>   arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   5 +-
>   arch/arm64/kvm/hyp/nvhe/switch.c              |   2 +-
>   arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |   2 +-
>   arch/arm64/kvm/hyp/vgic-v3-sr.c               |   6 +-
>   arch/arm64/kvm/hyp/vhe/switch.c               | 211 +++-
>   arch/arm64/kvm/hyp/vhe/sysreg-sr.c            | 133 ++-
>   arch/arm64/kvm/hyp/vhe/tlb.c                  |  83 ++
>   arch/arm64/kvm/mmu.c                          | 248 ++++-
>   arch/arm64/kvm/nested.c                       | 813 ++++++++++++++-
>   arch/arm64/kvm/reset.c                        |   7 +
>   arch/arm64/kvm/sys_regs.c                     | 978 ++++++++++++++++--
>   arch/arm64/kvm/vgic/vgic-init.c               |  35 +
>   arch/arm64/kvm/vgic/vgic-kvm-device.c         |  29 +-
>   arch/arm64/kvm/vgic/vgic-v3-nested.c          | 270 +++++
>   arch/arm64/kvm/vgic/vgic-v3.c                 |  35 +-
>   arch/arm64/kvm/vgic/vgic.c                    |  29 +
>   arch/arm64/kvm/vgic/vgic.h                    |  10 +
>   arch/arm64/tools/cpucaps                      |   2 +
>   include/clocksource/arm_arch_timer.h          |   4 +
>   include/kvm/arm_arch_timer.h                  |  19 +
>   include/kvm/arm_vgic.h                        |  16 +
>   include/uapi/linux/kvm.h                      |   1 +
>   tools/arch/arm/include/uapi/asm/kvm.h         |   1 +
>   43 files changed, 3725 insertions(+), 255 deletions(-)
>   create mode 100644 arch/arm64/include/asm/vncr_mapping.h
>   create mode 100644 arch/arm64/kvm/at.c
>   create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c
> 

Thanks,
Ganapat


