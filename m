Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A506F403E
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 11:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbjEBJf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 05:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjEBJfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 05:35:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2139.outbound.protection.outlook.com [40.107.244.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5D495
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 02:35:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EB6zP0hnrztsXb+kaJALk1MYp5X1hK4gw28kKii2hlvWRcd6Mt/6yUYHYK+pDRUEP+jzr77Gs1+xgixx68NixicXucV2o1zCAoHIrYlB14hk8BnO8A7tcMQ8fW0kp2R85LfMJ5iLTAf/vdihK4fb8/iDic9dxrsP7C9vpxbx+xbLn5Wu6ZfPmgwwukO5Wbo/cltS3Q1ufsczhXkn/Y0xuGDbOUGrWTKEAZfy8A3BJCt3W+gq3CVbhdLgEkI+d8U0rdx+oopYPPlBtD+1yagtj4BfHkzj0zeLvTK6Zk9ZPgoQldJ/J9eRdb2jUnt4S7YjVmcu2viw/I8EWMfI5bCDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvteYRzoECxO6G81GtlRB8baCgidgdSDZkALVh1Wb8s=;
 b=bYFk+w9S2Dd856fN5+3pakkK+5N5hrlJEe5BhJQcgRnCMZtCGWS7WxCB3Dn+FlYs7gOAkRSTdZO7yfRk5xO7J+PFGdpSPSVLO0e7o8n7rKwNjasuyD0GON95qnaBHDodDpQm86XAK6knnx1RsjpOZojGjth2cq4AGFjPXHpp4xBfEZ+LGUJ15CQfcbqUb3/sHt7htT8djnnEi3ZtjU0YWDM/R3m8YAJa/u30l1SzjE6xmV/3tX5XqGsERRUD+/4RhPkAjEMUxp5qsA39TlVkWL0maa4auBWVeWe8KCM0QxPHZn7tIooB9llMVb82IG0nqYBys+u1YL/QNLmVdMAjFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvteYRzoECxO6G81GtlRB8baCgidgdSDZkALVh1Wb8s=;
 b=YsSrsXaR/Kh7gvkUEFaXb22Ml5btNluyk9KjX0eva276GYXOMcxdBYrk2GaYpX24uYWGJJZdVaFiMk1HjshWSiD66FhL0J9fO9xIMjXh0/UcjQbQ7GQ3I551tNl9+pFrJ69LuMfEDbaYSnJWjawNalB9v1k+EwK0llh2dSUn6EM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 PH0PR01MB6698.prod.exchangelabs.com (2603:10b6:510:76::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.31; Tue, 2 May 2023 09:35:49 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::e0ea:cb46:91ef:f961]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::e0ea:cb46:91ef:f961%2]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 09:35:49 +0000
Message-ID: <f1b997e5-568c-b047-afd0-8fd6140d67df@os.amperecomputing.com>
Date:   Tue, 2 May 2023 15:05:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v9 17/50] KVM: arm64: nv: Handle shadow stage 2 page
 faults
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230405154008.3552854-1-maz@kernel.org>
 <20230405154008.3552854-18-maz@kernel.org>
Content-Language: en-US
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20230405154008.3552854-18-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR19CA0005.namprd19.prod.outlook.com
 (2603:10b6:610:4d::15) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|PH0PR01MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: c4f4dbac-b500-4cc1-3493-08db4af09d03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z8kjuaNfBN0MUqp5Aao9dhdFF6Fzh34w7352AftNnyi3gCSlZsIwSBAyegECawJNEkxe/IoDOfNqsXCBgVqpf3szJdgDn9t2JEtrsh1m74fPQ1fWENKd4Pv1MZ2Qii1WmGGGU2XbPG7+YucdWCQEQPr14iEtrz44EOZuVeVPauuHtTtk0f7A3wlM9/1sqUQZYUgAz4tPn4ML26WdknxV979Tecp73bhSiYHrfywRpRkT45spbLDdHG92DO+CAQhXXMCuwCXs2RlhXt69no1ixA0cNfMcNo7ScFU4rh7NxBwqyfYuufQM9U/1dT2dmc1tGRzz3ic6mD83bwPzpfDnAHQ4jnKO3/zlDIBbVXUewrdccRGQMxTmsZVMAZLVwLczyZnesnhE8Gjf0weGoE5ryPi5qNRFCQELePkfhRjFqAv2aUm5I+NpbNC8arCV4mm9rX7PdcxozVLADINcHXTEWXRmyIGc677/6S6NfrPBP65S6YGmCS+PDHTMbGlwkOi3r2v9JIbihqVBMJDzOuwzfLfxrID+897H/yxsjpSqIZ5cDOWUttJ5/uXYvtUPCkzEOJ42O3Tf4aKUPFzeMUpWg/9dFceS2xUzf5usUW6Sm6M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39850400004)(136003)(366004)(376002)(451199021)(66946007)(66476007)(66556008)(4326008)(316002)(6486002)(966005)(6666004)(38100700002)(26005)(186003)(6506007)(6512007)(53546011)(478600001)(54906003)(31696002)(86362001)(5660300002)(83380400001)(41300700001)(31686004)(7416002)(8676002)(8936002)(30864003)(2906002)(2616005)(66899021)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1B1SXNXczNqUjIvTlAwMEt4RzJ5TDdHWGxEL1dCQllOVGdEanUreFRiMzFL?=
 =?utf-8?B?MERqZmxKckYxSm5OeWMxZG1MVjN2bHUrNnA2T04rLy9UVG5ncjNLZXNVK2g0?=
 =?utf-8?B?bmVRVUVoMHBBeTVhanV0bjB6UWhaZFRQYVR6REFxNUdUSUIrOWh0S2toOFFY?=
 =?utf-8?B?V01yWWdmVzVOMFZISGpVV3kveW5sVC9OdE9QVlY1VUFaTFVqTFBDczcwckdh?=
 =?utf-8?B?R1MwRUhmTWl6TXpnejQzalhEYUhBMjZSeVRSZGpnODBpOWdzMlZjdEN5WlAz?=
 =?utf-8?B?QkJzNmt6dFN6THY1YlE1TmF2VitDNlpnUDdRM3IzL0lmNGVwK1dqTGpRTnRK?=
 =?utf-8?B?Y3BKVldCZjZqS0Z4dWh4eHJ1UGhMQlBPejZEeEtrd1ZmcTNMcFRCdnlGSjdG?=
 =?utf-8?B?c21OeU5PREUrYk5TcmJ0MjMwa3ZSNXEydVNDVnN5YzBCNW5reDUxbE9Fc0t6?=
 =?utf-8?B?MzljckFPODBBU3FadjBxNVBIK2lMYzFNNkdYV29LeTZQL0RiaktlNmVMZU4v?=
 =?utf-8?B?NzJUNWtpZmc1RWRjUjl4T3d5UmdMZWd0MXVWaXBkSU0wRE9mdzBXWTY3OUpQ?=
 =?utf-8?B?Z2VkQWJXTGd0ODFta3B4MDNuOWRHeXlxNGI3c0s1cnpEcGpjNFg1OENlZnFB?=
 =?utf-8?B?ZkxMVkJoczduQS9KUm94NHBSWkpMRTlpeHFnOGJPaEUxb1ltRGVlcGRockVy?=
 =?utf-8?B?YmE2aDdFZVJodHB4c0lBOTk4YXdnOFhwL2dJckd3TUp0dTBkVEFrTGZ2K040?=
 =?utf-8?B?TElUaWpEY2tkdkl4emVucGJNd1d2OE5GWE96dXFGNC9nQUZDNElCN2t5R0Rs?=
 =?utf-8?B?SSt3UTc1UkNWUnBuS0xGWHg5WmdVMHpwcFhES1FCODBzclFsaU5GcHppcFpU?=
 =?utf-8?B?NUg2SDV6NVBja3RtMjZLVmtjb0ZtbnNYY00vUmF6eDhUOWhjd3p2amNZSTRr?=
 =?utf-8?B?ZDdPMVp3bVBYdlN0VXNMTjhYb2V5WkErNjk4UlZyT3FMOVo3Nmh1eTNmRG1v?=
 =?utf-8?B?bUJMZVptYlpXL3BlSkRlMkhMRDZrVjFrdHp3bEl3ekpSSjJjYnFwQ3pHZ05R?=
 =?utf-8?B?aUpKNnZxb0xjZ2FYbEpWL1A1RElRNWIvYnYrR09DUkcvWmN5d1RYUERJT3pi?=
 =?utf-8?B?UElHTndVanh2M1NHUHBvSkhQWGQ0SEsrMzJua2pOQXhWWHJ6N1UzM0REZkFt?=
 =?utf-8?B?dUlkejJYN2VEanFtWk5DZlBlTWlSUit5RUgxb0J2R1l1ZXRPcW5UT3YvWnVS?=
 =?utf-8?B?RXdLUXZkYnVGNUdNMHRPSWhBaTlVY3dXQk1kcTV4RDBSbW9ydWhMaVNQaGov?=
 =?utf-8?B?UXR5MG9GV09sb3F6OWJ4MEt2TzM0Q2ZaSTNhVURUdWtRZXdENGpXdWZoOVd1?=
 =?utf-8?B?V1lGdy9LbmE1VEU3RFh3UWNMdHNSbE5mUi9zbzlNNUNYZFpZK3ZKWkdITVVX?=
 =?utf-8?B?N1BBQnM1dUF0M1RXU3JtMysySitFTEpaTUF5UG9pT1BxcEFFVmtVdElkdDRL?=
 =?utf-8?B?MmtVOTU1cFdvVjE1MmJLUVBRYVF3Mlo3UlpWQ2pvV2FKdlBsUFNJWkdOSmZZ?=
 =?utf-8?B?T2VMRUdJcG9raEZURktRWmJRbmtWQ3orMXVpUDNVcXlyRTl1U3N2aTR6NTcv?=
 =?utf-8?B?K2g4VGx3bGErRWI1NUdwVUZZNnJqK3FIb0hmZW1kN240anVQbUE4Q01KUUth?=
 =?utf-8?B?TVI2YkN4c0ZraE1DNWFiWFAwdlhxZ2xKaG52b1BnU1gzbC9uMDc0bmVEbTZQ?=
 =?utf-8?B?Vlp2ajVKbnp3TmVmNXEyMmdqRUc2eUk5Y3lHelJuK2w3VVYvRzNJSXJZQ1E2?=
 =?utf-8?B?a0F6akpUOFFWbVNyV1Y5MDlSSWIzN0JRR2lzYkdiTERZODM5azNqZjJDYm84?=
 =?utf-8?B?VFdUdU0yTkxKNkN3aGFxWkltUDlLQ1lxZUsxYWZISEx0endMM3QvS2JyM3lH?=
 =?utf-8?B?MUMvdGxrVnk3Yi9IZWJWYU5GSml3K0NyazNIeEwxUDlnTjB6Q2dra3NFdFNr?=
 =?utf-8?B?WWF3KzNkZHBqWEF0QTlMRVgxTGFmUVJJRHh5azRQWFJ2SWZvZTYwT2xwVGxs?=
 =?utf-8?B?Q2tabmVFV1NXaXlSRFJPdjlMRy91RTQ3TmdRSVIyTFJLay9ORUg5QWdpeE5n?=
 =?utf-8?B?czVLWjhlTFdDRURVUFpvaForblQweVNLZDdPdlUwcU1FUjQ1dUgxY1AyM20r?=
 =?utf-8?Q?7KVpZVHAbE5UAOcbV66S99g=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f4dbac-b500-4cc1-3493-08db4af09d03
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 09:35:49.1227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aefDaVvDDDKJIMxJAy1/obzbeUIvjVUP3cFy/NVPgSLmq6G8pUgGquI8ZwWbutwVA4KRjO5G2lxnl4ZrHgN3QnbAvpcYGGNp/7dHLP8aZr1PqbJYHxbMPZK0yHhPFj1A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6698
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 05-04-2023 09:09 pm, Marc Zyngier wrote:
> If we are faulting on a shadow stage 2 translation, we first walk the
> guest hypervisor's stage 2 page table to see if it has a mapping. If
> not, we inject a stage 2 page fault to the virtual EL2. Otherwise, we
> create a mapping in the shadow stage 2 page table.
> 
> Note that we have to deal with two IPAs when we got a shadow stage 2
> page fault. One is the address we faulted on, and is in the L2 guest
> phys space. The other is from the guest stage-2 page table walk, and is
> in the L1 guest phys space.  To differentiate them, we rename variables
> so that fault_ipa is used for the former and ipa is used for the latter.
> 
> Co-developed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: rewrote this multiple times...]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_emulate.h |  6 ++
>   arch/arm64/include/asm/kvm_nested.h  | 19 ++++++
>   arch/arm64/kvm/mmu.c                 | 89 ++++++++++++++++++++++++----
>   arch/arm64/kvm/nested.c              | 48 +++++++++++++++
>   4 files changed, 152 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index fe4b4b893fb8..1aa059ebb569 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -646,4 +646,10 @@ static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
>   	return test_bit(feature, vcpu->arch.features);
>   }
>   
> +static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
> +{
> +	return (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu &&
> +		vcpu->arch.hw_mmu->nested_stage2_enabled);
> +}
> +
>   #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 19796d4b0798..33a25ac0e258 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -76,9 +76,28 @@ struct kvm_s2_trans {
>   	u64 upper_attr;
>   };
>   
> +static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
> +{
> +	return trans->output;
> +}
> +
> +static inline unsigned long kvm_s2_trans_size(struct kvm_s2_trans *trans)
> +{
> +	return trans->block_size;
> +}
> +
> +static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
> +{
> +	return trans->esr;
> +}
> +
>   extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>   			      struct kvm_s2_trans *result);
>   
> +extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
> +				    struct kvm_s2_trans *trans);
> +extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
> +int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>   extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>   			    u64 control_bit);
>   extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b2612763abc1..e08001a45a89 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1251,14 +1251,16 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>   }
>   
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> -			  struct kvm_memory_slot *memslot, unsigned long hva,
> -			  unsigned long fault_status)
> +			  struct kvm_s2_trans *nested,
> +			  struct kvm_memory_slot *memslot,
> +			  unsigned long hva, unsigned long fault_status)
>   {
>   	int ret = 0;
>   	bool write_fault, writable, force_pte = false;
>   	bool exec_fault, mte_allowed;
>   	bool device = false;
>   	unsigned long mmu_seq;
> +	phys_addr_t ipa = fault_ipa;
>   	struct kvm *kvm = vcpu->kvm;
>   	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>   	struct vm_area_struct *vma;
> @@ -1343,10 +1345,38 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	}
>   
>   	vma_pagesize = 1UL << vma_shift;
> +
> +	if (nested) {
> +		unsigned long max_map_size;
> +
> +		max_map_size = force_pte ? PUD_SIZE : PAGE_SIZE;
> +
> +		ipa = kvm_s2_trans_output(nested);
> +
> +		/*
> +		 * If we're about to create a shadow stage 2 entry, then we
> +		 * can only create a block mapping if the guest stage 2 page
> +		 * table uses at least as big a mapping.
> +		 */
> +		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
> +
> +		/*
> +		 * Be careful that if the mapping size falls between
> +		 * two host sizes, take the smallest of the two.
> +		 */
> +		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
> +			max_map_size = PMD_SIZE;
> +		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
> +			max_map_size = PAGE_SIZE;
> +

Thanks for folding the fix[1] in to this patch.
please feel free to add,

Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

[1] 
https://lore.kernel.org/linux-arm-kernel/20220824060304.21128-1-gankulkarni@os.amperecomputing.com/T/#m2d0d950604009f0ab3f8217b3b1daf6f34385c7e

> +		force_pte = (max_map_size == PAGE_SIZE);
> +		vma_pagesize = min(vma_pagesize, (long)max_map_size);
> +	}
> +
>   	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>   		fault_ipa &= ~(vma_pagesize - 1);
>   
> -	gfn = fault_ipa >> PAGE_SHIFT;
> +	gfn = ipa >> PAGE_SHIFT;
>   	mte_allowed = kvm_vma_mte_allowed(vma);
>   
>   	/* Don't use the VMA after the unlock -- it may have vanished */
> @@ -1497,8 +1527,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>    */
>   int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   {
> +	struct kvm_s2_trans nested_trans, *nested = NULL;
>   	unsigned long fault_status;
> -	phys_addr_t fault_ipa;
> +	phys_addr_t fault_ipa; /* The address we faulted on */
> +	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
>   	struct kvm_memory_slot *memslot;
>   	unsigned long hva;
>   	bool is_iabt, write_fault, writable;
> @@ -1507,7 +1539,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   
>   	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>   
> -	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> +	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>   	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>   
>   	if (fault_status == ESR_ELx_FSC_FAULT) {
> @@ -1548,6 +1580,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   	if (fault_status != ESR_ELx_FSC_FAULT &&
>   	    fault_status != ESR_ELx_FSC_PERM &&
>   	    fault_status != ESR_ELx_FSC_ACCESS) {
> +		/*
> +		 * We must never see an address size fault on shadow stage 2
> +		 * page table walk, because we would have injected an addr
> +		 * size fault when we walked the nested s2 page and not
> +		 * create the shadow entry.
> +		 */
>   		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>   			kvm_vcpu_trap_get_class(vcpu),
>   			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
> @@ -1557,7 +1595,37 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   
>   	idx = srcu_read_lock(&vcpu->kvm->srcu);
>   
> -	gfn = fault_ipa >> PAGE_SHIFT;
> +	/*
> +	 * We may have faulted on a shadow stage 2 page table if we are
> +	 * running a nested guest.  In this case, we have to resolve the L2
> +	 * IPA to the L1 IPA first, before knowing what kind of memory should
> +	 * back the L1 IPA.
> +	 *
> +	 * If the shadow stage 2 page table walk faults, then we simply inject
> +	 * this to the guest and carry on.
> +	 */
> +	if (kvm_is_shadow_s2_fault(vcpu)) {
> +		u32 esr;
> +
> +		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
> +		if (ret) {
> +			esr = kvm_s2_trans_esr(&nested_trans);
> +			kvm_inject_s2_fault(vcpu, esr);
> +			goto out_unlock;
> +		}
> +
> +		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
> +		if (ret) {
> +			esr = kvm_s2_trans_esr(&nested_trans);
> +			kvm_inject_s2_fault(vcpu, esr);
> +			goto out_unlock;
> +		}
> +
> +		ipa = kvm_s2_trans_output(&nested_trans);
> +		nested = &nested_trans;
> +	}
> +
> +	gfn = ipa >> PAGE_SHIFT;
>   	memslot = gfn_to_memslot(vcpu->kvm, gfn);
>   	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>   	write_fault = kvm_is_write_fault(vcpu);
> @@ -1601,13 +1669,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		 * faulting VA. This is always 12 bits, irrespective
>   		 * of the page size.
>   		 */
> -		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
> -		ret = io_mem_abort(vcpu, fault_ipa);
> +		ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
> +		ret = io_mem_abort(vcpu, ipa);
>   		goto out_unlock;
>   	}
>   
>   	/* Userspace should not be able to register out-of-bounds IPAs */
> -	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
> +	VM_BUG_ON(ipa >= kvm_phys_size(vcpu->kvm));
>   
>   	if (fault_status == ESR_ELx_FSC_ACCESS) {
>   		handle_access_fault(vcpu, fault_ipa);
> @@ -1615,7 +1683,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		goto out_unlock;
>   	}
>   
> -	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
> +	ret = user_mem_abort(vcpu, fault_ipa, nested,
> +			     memslot, hva, fault_status);
>   	if (ret == 0)
>   		ret = 1;
>   out:
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 1e5eb8140012..1cf2ad18a5cd 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -112,6 +112,15 @@ static u32 compute_fsc(int level, u32 fsc)
>   	return fsc | (level & 0x3);
>   }
>   
> +static int esr_s2_fault(struct kvm_vcpu *vcpu, int level, u32 fsc)
> +{
> +	u32 esr;
> +
> +	esr = kvm_vcpu_get_esr(vcpu) & ~ESR_ELx_FSC;
> +	esr |= compute_fsc(level, fsc);
> +	return esr;
> +}
> +
>   static int check_base_s2_limits(struct s2_walk_info *wi,
>   				int level, int input_size, int stride)
>   {
> @@ -478,6 +487,45 @@ void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
>   	}
>   }
>   
> +/*
> + * Returns non-zero if permission fault is handled by injecting it to the next
> + * level hypervisor.
> + */
> +int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
> +{
> +	unsigned long fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
> +	bool forward_fault = false;
> +
> +	trans->esr = 0;
> +
> +	if (fault_status != ESR_ELx_FSC_PERM)
> +		return 0;
> +
> +	if (kvm_vcpu_trap_is_iabt(vcpu)) {
> +		forward_fault = (trans->upper_attr & BIT(54));
> +	} else {
> +		bool write_fault = kvm_is_write_fault(vcpu);
> +
> +		forward_fault = ((write_fault && !trans->writable) ||
> +				 (!write_fault && !trans->readable));
> +	}
> +
> +	if (forward_fault) {
> +		trans->esr = esr_s2_fault(vcpu, trans->level, ESR_ELx_FSC_PERM);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
> +{
> +	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.far_el2, FAR_EL2);
> +	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.hpfar_el2, HPFAR_EL2);
> +
> +	return kvm_inject_nested_sync(vcpu, esr_el2);
> +}
> +
>   void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   {
>   	int i;

Thanks,
Ganapat
