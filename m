Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A887865BA07
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 05:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbjACE0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 23:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjACE0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 23:26:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3B5EB6
        for <kvm@vger.kernel.org>; Mon,  2 Jan 2023 20:26:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsnIzjm7V/Ksg0NsT8QYIoynAv7bvXv0745x0umJym8i0Nzaxmy1g19F7Vop8L2RuPwmUmTPpAtM53oGwzOJI4Ubj9CLVUW0YfKSS8LZF9sucpOTs/E28csaTHOj0Zqw1Zj4D6XZ5ZrgPO1br0wdWFD5uwRSMjGK8Y2+B+c3U35SCAVYPmOSuuzWOXqTPSAVsH7dnsuZ2gFBZO9lABGNH1AjFCyPZhILtLqw7hde9S2/u37OMGVD9kkEJyRMCHFFmDTMZo24qjTqVCuMSN65cOd25Zmb2tigpJgMalTTGvgkMhTrFbx3NMboHWJBwl6dE2bu97tmXamz8WcIIbNMEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwYshsR/kSCBX1djLVRMSKkd7qGBaacG1aAd3fYrbsI=;
 b=XCfdGxu/4JwrbPFWvOc8i/aPzaKllRu8YEAcMTAIu0FHwEFuP9P4EMEzAzKWQZi/xC1u9NXwZAqKQwEumL+pmI/7118XS5PrKFfD+DTL/dPOk3JTOU2oe4yABMskk1nmkZVlJ3CMAV/70gv1mGHz7MzPcFnsPX2bSkSmFdD1GqXrM35HV4lX8Lu1lhSJPonNkGx7k4j7lhKeC2MdEU8BJLhQxMYwwTEd71YtXyFa1mn1GdpMSBMsz5pEE+R4qywEZio5yq5qWWRa7QzJLBN/WO9YG7esj30oaoJrOkMa5z/hJZHc8Cx/fbuXLVpnQUqmUYORM3nudplCmMRMjYuEeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwYshsR/kSCBX1djLVRMSKkd7qGBaacG1aAd3fYrbsI=;
 b=gZQeZrfpGuDPh7EUGamR3ZELx1P91u7tVYWV8D5bN7WEeJ9Ouyn2t0lHlVOnO9asRtCZ4p6DWxTJaMkzHX38A9HeB1JrhUIx81oRz1Gs0S2RpBYijAkeA5ZpHkM8o6Utb63n0i9QNDwt1l2P7UKkT5B6KfvVqD8AeybsIdDrpIM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 LV2PR01MB7720.prod.exchangelabs.com (2603:10b6:408:172::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.16; Tue, 3 Jan 2023 04:26:27 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d%5]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 04:26:27 +0000
Message-ID: <eadac5ec-6b61-9afe-3117-50fd9569ad4a@os.amperecomputing.com>
Date:   Tue, 3 Jan 2023 09:56:19 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Avoid block mapping if max_map_size
 is smaller than block size.
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        darren@os.amperecomputing.com
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
 <20220824060304.21128-4-gankulkarni@os.amperecomputing.com>
 <87wn6ads39.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87wn6ads39.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:3:17::34) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|LV2PR01MB7720:EE_
X-MS-Office365-Filtering-Correlation-Id: 78a90b35-29d9-4c37-7389-08daed42ae54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0vQrv7jfiGMmRqGlgl00FomZcvsKFgkFyauet3uhtaX3p4rxFx8+2tZEhddJzuID9TCPV4m4PYFcn+kgOa91JSG8eIA2cQXUd5cwRr6R8D+B/r8wD0nP8bspqTzAlDMYgE8HNVgLIBVwMrUkktqZHsutps58/cFL6eZ43T6rjOnabJsa9IyNKS0uW8DqhcZmKUuEYEYl4beSuxtAT9sFHjpNDT1+gtPlLpwl7+hYmlIgFLIxtbEwiUjrCFQyFu26zhlIFkqDqOgC8wUINjQ/dvcX7mQFAshmszm3yWdo/Iug9vTQ8o7p8grKqQF3jqiMrSdb5yuuPww0BHbhJ1U8ziPoiC+UyF2H/7ghrsCp4r1ckovkY/oAAeYXvRdkbQsCxRc9L6XEMOd+/wz49v9fHfYeioPmQ2lb1nrQmTKCQkHSXHbq7TAVFUrxiHH88KPPUrI76CE2pilDwtkUz7+qzc5LpethGl3PJFbSAJ5dCU7SwfbzNVjyDFGBMUiMEIZJbi4EBJNnusUEfypCi3VqGoZyLqalpR6fVEwSCNlqI2TQ5EvIiYdjQN6zMS+HaYQl1Gb3bqClNAyOQinhZQTQvLp8pH01ncT1EgE/2nDXoT/Up/iw1pL0k83jb0LNNcvblOhk8oPHY/wMqrwbubyV2o6gQ5tM/u8z8Ku9Omr/wcOnBEjqeKl29YI3EpJa4bf6vC3QdPN/DwHmWeEaE9D975vG0F1tgckthrAN9BbauCg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(396003)(39850400004)(346002)(451199015)(66556008)(66946007)(31696002)(8676002)(4326008)(31686004)(66476007)(86362001)(41300700001)(8936002)(5660300002)(316002)(6916009)(83380400001)(2906002)(53546011)(478600001)(6666004)(107886003)(186003)(6512007)(6506007)(38100700002)(26005)(6486002)(2616005)(22166006)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1BLWFQxYmE5UkR6ZzJZemhyNFlhTHF4RG9vdGdYYndlaHRNUlYrekFQK0dB?=
 =?utf-8?B?dU4rZXhpK1lqZUxLL0lrK1g0N0owQTJZY1FDZFZHbHdPWGRWQWxKOFljYXdD?=
 =?utf-8?B?dnhEODBOeUdNVnUvK2dETEtqeVZtT1plMUdDVjNWSFhGVGhWVlROVzFuNEFQ?=
 =?utf-8?B?eGxibkxCcExjdStmWlMvSlRCQUQ5cXN0YnFNMndlUWxyYUY5YXlYbTdidzVN?=
 =?utf-8?B?MUJjSmFJSUhhcXB6R0N4aVdZc2tsejF1MFU3aWVNTVN2QUcvMDM1VXBIU09O?=
 =?utf-8?B?bXN0YWxmNGR2eEZEVVNCRVdQaFg0WWxBRTJNR1g5QXg3dWhlTWpwbFR6RWky?=
 =?utf-8?B?SFZxeFMweUVWVGM0L3VIWU4yVXQ2OTRqNHNNZjVLUlY4M1VNQ2hiWXlsdU55?=
 =?utf-8?B?cER6bC9FUFRCTlM4MEhaVDJLTHJmcjNNQmYzNm1kSWN4QzkxTW5RUWVMd1NJ?=
 =?utf-8?B?Q2FKZXhJZnlZa0MrZCt1REk5YnJ0QmpwRE1VbXVSUTB0VGc0Yzl4ajgyU0JE?=
 =?utf-8?B?VU15cGhjdWQ5R2wzUHdYbG9IMnFabVZUZnR2OXQ2T2tyaWpkZCtsWUIyVnV6?=
 =?utf-8?B?SndNSVBVTXliY2I1SW9IMHpXNlV3aVk5VHJBVXFiTDBYeC9US3M4REg4eWh1?=
 =?utf-8?B?V1dOM3Vpbkd5MjR2a1lKQjgxdFFFbVhSaWRwT1BGTE9QbnYyVVRnWk56TFRl?=
 =?utf-8?B?eitrcnIzUnlRdkhaMVpsV1ZjSlN0UUpUa0dGZEJ3WUxFeUROWXBnS1JUcGwv?=
 =?utf-8?B?YThzdlVTUi9ncHV5ZDM5emkrVWV2bEN1Z2t4UDJFRGEyWjJSZGRsYkNNUkl1?=
 =?utf-8?B?aFRsYzBxKzhJd2dsenVHdTgvWVRCR0p3MnVwTTRudnVGa0l5ZjRGMkRlUEVD?=
 =?utf-8?B?c3FhKzM3ZUEwc0k2Y1VrV3Y4VHRPVXAzOGcrc0R5T0NCZExRdHZhWHRLUHNK?=
 =?utf-8?B?OVRtQmR6Y1ZFbTNpQys2b0RJTVVKMHdJREVnczRjU2xzNHZ1azE0RWpaUUQ5?=
 =?utf-8?B?d3IzQWF1OUlVbm9QQlBrV0lSUDgrZDhBN2tWdm5GVjJ4akJPd1llcWU5c204?=
 =?utf-8?B?ckRnelBUaTAvcHpwQ0JTMUFBQnpnYjViNWkrQXFFaXk2UStYUFlPLytwQ3NL?=
 =?utf-8?B?QUpEYkEzcitzemNCTDJFWVg2b3dZVXIveGswcmlpWGtsTUwxN1FtYkErcUJj?=
 =?utf-8?B?TWo5aGFxbDA4NW1icFQ5Z0ROajdWdDdzZXU2L1FzSG9PdEtXT3F0emZyeGsr?=
 =?utf-8?B?M3I2djM2aktLZVMwMzJpcks0VzdTREVuTUVzQ1pjS3VBbU0vMEswM1RMRlRz?=
 =?utf-8?B?Z051MkdJbXAxM0lYQkRCNDZqN1RPVHU2bXlXaERra0tHQk5BN3BsVFNwMWpw?=
 =?utf-8?B?YTFZcHZjdmNiUGF2WWExdk9KZnp0SzRHdWdsVXlkSXNod2F0aW1xQ0RjaTJ5?=
 =?utf-8?B?YVRLR1ViOXh6TUwxNkhwVXJhenhRSG1nRkQzR2syTk5ycWJ1b2hXS1pMNldK?=
 =?utf-8?B?QjIwVjlTeHhMQ3ZMeDBXRTd4MlV6YlRxZ2RqM2dvYy9nR2VUcE5GZFU1SGtX?=
 =?utf-8?B?WDNrU1Jrc1VTTWRoQUtlVmRLTStvN2ZiT2hOb3hJNmorQXIrVTlZTXltRVhS?=
 =?utf-8?B?ck0xSk4zSVRaTHJVaXc1Vm1PeXd5UVpYL0hSRTVEUjA2YkVlSjRGVVluQzIz?=
 =?utf-8?B?cndVMzBSZ21lRjh2VXpwbEliaFY1ZkdIekRjZ25aM0VwUitOUEtWSzVYWlVB?=
 =?utf-8?B?KzZPdTVaTEJIS2R4N201SlFOaVV5bTBtbWFpODBXeDNtT1ViNlRYbnloMExS?=
 =?utf-8?B?Z2ppOElpR0xSbUx2SXYzWU53MWJ3U3FBcGQ0aE5QY0hkTnpUZ0szT2JhT3l3?=
 =?utf-8?B?dDNRZEhna2gvVHdVOXBob2FBSW5PY2tCWWhmdHFOMm5vbGJoNWxWY2ZKeFRY?=
 =?utf-8?B?ODB5bVFUMGhVc2JjdFM3cTlEcmRhRjZTYXlXVWJJaE95TEN6clZySXdlQTVH?=
 =?utf-8?B?cHZldS8vaXBCYXE3enk2T2F6dDNvZDBjUHgzZ2RWVFFtTzNJZkFVVXdnL0tX?=
 =?utf-8?B?c3Y5ZFQwNzhjM3ZXK3V3VDc1TEhHakFBOVVIZC9jdE1pYVk4M0hUcWUzWXhI?=
 =?utf-8?B?VzhGRS9pWW9XdmxaZmI3NWp1WUwvKzFiWWlXZ2pMRXBrYVljVVlLK2k2QXNt?=
 =?utf-8?Q?cz0nbay85FXzRk6Zmv872QfKXtq/WkmxDW0QzysoiWtn?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a90b35-29d9-4c37-7389-08daed42ae54
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 04:26:27.8334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CeKgipX98i8yosiUwdFlIDevCx1Qp2bGKNYsT3tnlthwZXhkBrVqKqSCi45b1anF9pARGupeVUmjpuMwHD1z4/l6SZaai1LTgNJzkQlK6oedh1Y2Mrom2UETCKk59PLX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7720
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 29-12-2022 11:12 pm, Marc Zyngier wrote:
> On Wed, 24 Aug 2022 07:03:04 +0100,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> In NV case, Shadow stage 2 page table is created using host hypervisor
>> page table configuration like page size, block size etc. Also, the shadow
>> stage 2 table uses block level mapping if the Guest Hypervisor IPA is
>> backed by the THP pages. However, this is resulting in illegal mapping of
>> NestedVM IPA to Host Hypervisor PA, when Guest Hypervisor and Host
>> hypervisor are configured with different pagesize.
>>
>> Adding fix to avoid block level mapping in stage 2 mapping if
>> max_map_size is smaller than the block size.
>>
>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 6caa48da1b2e..3d4b53f153a1 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1304,7 +1304,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	 * backed by a THP and thus use block mapping if possible.
>>   	 */
>>   	if (vma_pagesize == PAGE_SIZE &&
>> -	    !(max_map_size == PAGE_SIZE || device)) {
>> +	    !(max_map_size < PMD_SIZE || device)) {
>>   		if (fault_status == FSC_PERM && fault_granule > PAGE_SIZE)
>>   			vma_pagesize = fault_granule;
>>   		else
> 
> That's quite a nice catch. I guess this was the main issue with
> running 64kB L1 on a 4kB L0? Now, I'm not that fond of the fix itself,
> and I think max_map_size should always represent something that is a
> valid size *on the host*, specially when outside of NV-specific code.
> 

Thanks Marc, yes this patch was to fix the issue seen with L1 64K and L0 
4K page size.

> How about something like this instead:
> 
> @@ -1346,6 +1346,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		 * table uses at least as big a mapping.
>   		 */
>   		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
> +
> +		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
> +			max_map_size = PMD_SIZE;
> +		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
> +			max_map_size = PAGE_SIZE;
>   	}
>   
>   	vma_pagesize = min(vma_pagesize, max_map_size);
> 
> 
> Admittedly, this is a lot uglier than your fix. But it keep the nested
> horror localised, and doesn't risk being reverted by accident by
> people who would not take NV into account (can't blame them, really).
> 
> Can you please give it a go?

Sure, I will try this and update at the earliest.
> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat
