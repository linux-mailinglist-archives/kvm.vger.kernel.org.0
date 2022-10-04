Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6725F4990
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 21:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJDTG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 15:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJDTGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 15:06:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9DA4AD76;
        Tue,  4 Oct 2022 12:06:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFzcJNN+6TMrXPs/N0dmYJf2pCDNtVksTt+Dxf8RodITgreckzoAeboPh5HcwfS89MVA5cUSPxAUnULLSsNblwbiXX8Gq/QmYmwc+Cr8TInOryE2eYSFOv5iX2RH9XFgxoJ/QbPhiT0H51YU73sYgYJpVJn98V6Sj+rk7QQbarGlcte//JhPzwTg+zs1858aliZi9gKG2MJkkwgcMUrZxd55K97FywY8icPuN1rTeqnvQAF5hn8Bil8rbSh2uJp6hxAUln4IYalvqHgSq1/zVRSgGlcO63a4rqmjAYnw+jlDZx9esRtJsLhDIUuUo7ujYI/yyaQRKagwE1glqiS1wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPhVdtXN34WpjSuvk0pyglNi66GSE8E0dheNVR7ugkw=;
 b=JVpOb1NaE2kN/hsx+1yoLXGJeIhd5pRvY9MNHYnyMRAuEtIrUUEYQboGQdIGt16PuHLd5FGA8g50spgliSIinu408jJMpBBxW6gQ5Sf+myJTCnFLJCW/XvHvz/a4XJW8pD1l/enHAVBTC8aXy1MCRqjbnTvEOUfKPNO8gP2oMpRUuxACvUIg2a+CdjsFLZ/OOZXTxkUKOsTJW0gZ9XN8avy7O+HrNYbQ0ivfU3kH/bN5Zt9izuWXJJuD/wkOLD05eU9+39HYHpzoJQmPPJw8DXOPOmvAjSG0wUSz8BB3DmSGXEI7FzYK7e3gUwSqWN9fcLq7qzZKufRJ2t9wF5n7AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPhVdtXN34WpjSuvk0pyglNi66GSE8E0dheNVR7ugkw=;
 b=efjYiUct7dG0I7vPuO1fHrkD0ac3a+a1Y9TD1Il9B14l1y/0XvNiL7+GvMaQ5x4UbSLuzcP1BFYsA8BYu0WqbSIMyhK79tkmtNHXOCVs4VCAJmDQI66pn3fBCJoCX8VKZeqOcgssotKlw3ez4n+e0yAUwm6AB5AYidVPaf42qYY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17)
 by PH7PR12MB7259.namprd12.prod.outlook.com (2603:10b6:510:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Tue, 4 Oct
 2022 19:06:50 +0000
Received: from BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::ea28:b6e6:143c:8649]) by BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::ea28:b6e6:143c:8649%6]) with mapi id 15.20.5676.019; Tue, 4 Oct 2022
 19:06:50 +0000
Message-ID: <576fc720-79d1-2aa5-9ea9-c2a90797dcee@amd.com>
Date:   Tue, 4 Oct 2022 14:06:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: SVM: Fix reserved fields of struct sev_es_save_area
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        venu.busireddy@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bilbao@vt.edu
References: <986a5886-4ddc-aa88-db52-e8781ec95aed@amd.com>
 <dd357565-d428-499f-fa0e-e35aa043449f@amd.com> <YzxfdQ7DrT9X6t7j@google.com>
 <49227bcd-3e54-4a4d-5416-dcb9315a1802@amd.com> <YzyAyiZGyooB0A8e@google.com>
From:   Carlos Bilbao <carlos.bilbao@amd.com>
In-Reply-To: <YzyAyiZGyooB0A8e@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P221CA0037.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::12) To BL1PR12MB5874.namprd12.prod.outlook.com
 (2603:10b6:208:396::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5874:EE_|PH7PR12MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a68a40f-5ea1-466e-6603-08daa63b9759
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlz+SViRadPImH/0drlclU0M5NGxEeiEXLFd6beQ9l4V7vN0Nkjif60Nc9OeM2J0jtWxEh1VqWuu1BbZpuRMMCD2YVcT3x8Rup9dCYFqrzH/kBc5BHK288YDsbwyRKHJWnsFtDiyyd8LhlYHWhcVHsknYtKvZb5oBpu1ZZaLDiawH7PjID3bmM7En4mxMniVZ47GFqb0zTJHlOHWuIr6v5eYt+GzMiYnKBXENzGfpk1fF43CgthMBqLFebRmJTB9SWkfKhyQQjckd9EqD/yPJQ59EDWbpBhx/nxq6GSW0Cb9ZLXMgUp8OHpEmFuYIvdrnaVEuU/Q86rDDZduaL91G/DIds3z4RiMQlVlaRp21T5ZrWYE76aMroV+5VOQXl06E7Tai6p06ZzY66bAvpUcgIctaH/DA1Zu4srajzovR42Mo6axUNu6fIeqhug3IzLnxDG0D6wJc6Geforp4KR8Ov6w20kbA2mTL869c7XxOr8RMDmDx7aXGInr1LK2Aty0FN6xaLECgdWACFzRtKxqwPGAfZ7kjd35HsjoAV3KsB2fkRUiLomXOB5QgQv6GcJsE18NMgmdWMAyCBBriZkNNQ3FcyF6ZCMYiMvSyq2L5g92z2NRrNPRS63EPfclBgcHRkm5LT4KuKidCrXr1EU5L4WgsCaC4tcT1iNIC1gVCMPEIt+/NfrTSDmbPpjYeNbfNZlueF/LxO/D6IPsZu12Ide0F7Z4w/yLOaQMHXLTZytRWNK5v5lbDtGeEIiTLHsZoax4zvPe0lPNlsMZvLvXDKPn4GSrUn5lX33DYO5EnvU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5874.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199015)(36756003)(478600001)(5660300002)(26005)(83380400001)(38100700002)(6916009)(6666004)(41300700001)(6506007)(53546011)(6512007)(4326008)(7416002)(66476007)(66556008)(8676002)(8936002)(86362001)(31696002)(6486002)(66946007)(2616005)(186003)(316002)(44832011)(31686004)(66899015)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTVWRFJZcGc2cWRzOTMxM1pzZzNjd1J0bmRFVjlQQ3ZvQ3drRjBEWVVVMGxv?=
 =?utf-8?B?YXNwMXVHbmlvc2R2OXpwZTUvZmxjVXErQXUyV3lHamU4N1pYVHJLN29kdmN4?=
 =?utf-8?B?YTUyOUQrNHdwTlU5eDRIVXRPMXhZOHV2WWlLY1FabCtIcUhMaUFia3hERHpj?=
 =?utf-8?B?azExaDVTKzQrdk0rMFAyNFpneWRSbU1CUGUwQy84Y1NmTWRITXppeHZLNjBo?=
 =?utf-8?B?eExyUFhGdWY0bGtsVk5sbVhBSVlQeUsxU1pac0xnRXp5TStmSVNNNWNxeGVO?=
 =?utf-8?B?MjREb0piMmhPYWgyWnNRbGoyTmc1UjJMcXF0bFlUelpRYW9LbHhKMks4eTNk?=
 =?utf-8?B?bHRwbmZqS005RmRocUhjV2xDSW1Bd2k1eGlNRFZmWFlWTk1WU0F2Nkxzc2FE?=
 =?utf-8?B?b3FsSnBqTkhYOVJhL2hlSDd4bzBOb0kyM3ZHd0llYllDbTRFYTV4QWd1R3pP?=
 =?utf-8?B?cm9MS00xb25zUno3VUZkbTlBSzFOVDRZZ0dOU3gzWGUySkM2b1RjVWpCVUtN?=
 =?utf-8?B?SGhlcm1MbzAxWE4vT0NIZkZzMFN3Tk91R0g4bWRJY1QwM2VGWmlQeEMwUmlH?=
 =?utf-8?B?MFNOMUVwRWdRMzhjRlNiNWZ1dytYU2wrSUJpK0VuZ2hPSS83bEVUaXNNOFds?=
 =?utf-8?B?Zy9YRlVXMnBiSnFkTTgvZ3BrNUxqNlpxV0d4QVZvMzhYY2dSMVVxTk12QnNh?=
 =?utf-8?B?a0VwL0RwWkJnMzlwclIzc1hFa2NOQ0t5SjdBdkVYY0swUTliZ3d2VHJGTW5u?=
 =?utf-8?B?RmhYaytQOE1nOERtaGNodittcXo2c0ZQZGRkQTRHVVNEWmxqM0Z2anF1T0tD?=
 =?utf-8?B?cElIRFl6S0VMNWRCMjAyaHZYaVl5Y0tiaDk3SjBBSE1EYkJRQVlJNjBxOVEz?=
 =?utf-8?B?VUF2ZHNqQXI0d0ZxeFpSRlRQNk5PdXlaSlVKYS9maThtSFRZRnc0aDh5QmtL?=
 =?utf-8?B?WEg3VFFUU3hIUmgzeFpwL1E3V2w4OEpabk5HdjFhVy83WVZQUkFMa1J2bXRn?=
 =?utf-8?B?MWh2cVZoeGJkTEJHSTd3QmRwRHR5KzhtRC9oOVRPcTlHVXZSaVpSL3p4Z05S?=
 =?utf-8?B?VWh4UWg3RkdPQ3ZwSFcyQVFSdUVsVmhEVEt4Szd3WFRVNWlzOWpPNEt1SGlt?=
 =?utf-8?B?QXFtT2d1TGtCNGttUVk4cGhreW5McTZGVEVGRllvcmppa2V5QlQwY1FVamxB?=
 =?utf-8?B?enVSWkk2Zzh1WXFtS1AwaWV3c3FUOWNERndhMzV3eU5XdnNKMFVuajlpN1Jl?=
 =?utf-8?B?L1BvS2t4YmM1eXVISjBNTC9jdXp6R2VHUFFVcWVERFIvS3I4N2hocm1QY2RC?=
 =?utf-8?B?Ui9maFNQVWhVVWxQcWxxRURab3Q1Slp4RkVhQnN3QnN6UDZHb0diaDQ3OUxV?=
 =?utf-8?B?bk0xK1Y1eHJWSnhYZ1lQYUJUYU9zQWxoY0FyeW5VZ1NXNExsb25CZENNSjgy?=
 =?utf-8?B?Tk81OGplNlFGVWhDZFdONk5qdXE3ZWhHbnFSNVB0ZGtmWnZ5Y0xJYS90OFJS?=
 =?utf-8?B?cHFQUmpMSEFoc3BvR3RxZ1ZkY0xrQzNIZFdUeGhFdDFsUzRrVUdCOTh3bWV0?=
 =?utf-8?B?MklRZGc1eUFyVkpSYXBwY2JIb0ZvNnpRMmt5blBJRUtwM0ZabjJJTUhSdDFs?=
 =?utf-8?B?YjArYlBvcnBFQTR0azV6NWh0VE55YWtBY1U3NmgrdkkwUVZwa0hBdjJHK24x?=
 =?utf-8?B?bnpOQ3RtdTFHZjZLU0NDZTUvbXd5RDc1TTZoaW9Hc3ppMnNjT2N4dHVodTAz?=
 =?utf-8?B?Z1pZUmwzN3ltY1UwMlRYOVNoOW1sbTFEYUhYYUFoQVRTUko2NE90ajRYaEVn?=
 =?utf-8?B?QzlhZlNOdEszbXBWdmlkMlpTbExGRHdWdk9kN0xKTVpRNmUxQXAyMm83Q3Za?=
 =?utf-8?B?ZmIyem91Z29kMnh2K041MUlRT3hOYnMrb3o5clAvUHQ4aWxLVmFsMkRXK1Jw?=
 =?utf-8?B?cVBTSEVFb0VJWVFuR2dVckRReGNTd2hpUUlLUHJwOEwzWHprd1VWd2gwME5z?=
 =?utf-8?B?UkFoVjJNRDZsRHdQUTMyRnRDT1ZQdWNRVlJoNzYyUTNLTUcwSmVET3lXeXly?=
 =?utf-8?B?ait5QXc5dFE3S0NWYm1qYllIWTBST1pPYWd4TXNUOVpYaXVlTm5yVFg3MFFx?=
 =?utf-8?Q?WBpAEHWVcSoemLLgBjnS34yW+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a68a40f-5ea1-466e-6603-08daa63b9759
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5874.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 19:06:50.0733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AI+F/VDlsfxOpltQ3CfoHOSVds2Sg0gYco9uIHtH43ZBF+RHVDwxZpEMitcAJZ8sF6A3TZZav6kcD0dEzPOcfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7259
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/22 13:51, Sean Christopherson wrote:

> On Tue, Oct 04, 2022, Carlos Bilbao wrote:
>> On 10/4/22 11:29, Sean Christopherson wrote:
>>> On Tue, Oct 04, 2022, Carlos Bilbao wrote:
>>>> On 10/4/22 09:05, Carlos Bilbao wrote:
>>>>
>>>>> Reserved fields of struct sev_es_save_area are named by their order of
>>>>> appearance, but right now they jump from reserved_5 to reserved_7. Rename
>>>>> them with the correct order.
>>>>>
>>>>> Fixes: 6d3b3d34e39eb ("KVM: SVM: Update the SEV-ES save area mapping")
>>>> Actually, there is no bug, so this Fix tag could go. Thanks!!
>>> Fixes: is appropriate, if we think it's worth fixing.  Personally, I don't think
>>> it's worth the churn/effort to keep the reserved numbers accurate, e.g. if the
>>> two bytes in reserved_1 are used, then every other field will need to be updated
>>> just to accomodate a tiny change.  We'll find ourselves in a similar situation if
>>> field is added in the middle of reserved_3,
>>>
>>> If we really want to the number to have any kind of meaning without needing a pile
>>> of churn for every update, the best idea I can think of is to name them reserved_<offset>.
>>> That way only the affected reserved field needs to be modified when adding new
>>> legal fields.  But that has it's own flavor of maintenance burden as calculating
>>> and verifying the offset is a waste of everyone's time.
>>>
>>> TL;DR: I vote to sweep this under the rug and live with arbitrary/bad numbers.
>> Well, the discussion on what is the most appropriate way to name reserved
>> fields is orthogonal to this patch, IMO.
> It's not orthogonal, because how this "bug" is fixed determines the ongoing
> maintenance cost.  If we're going to deal with code churn to clean things up, then
> we want to churn the code exactly once.  If this was a one-line change then I
> wouldn't care as much, but since it requires modifying half the reserved fields,
> I'd rather we take an all-or-nothing approach.
Makes sense.
>> This change just follows the prior approach (reserved_x), but correctly.
>> Keep in mind that the existence of reserved_{1,5} and reserved_{7,11}
>> implies there's a reserved_6 (there isn't). Why knowingly keep something
>> that's wrong, even if small?
> Because the cost of maintaining the ordering far outweighs the benefits.  It's
> not just about this patch, it's about all the future patches and reviews that will
> be needed to keep the ordering correct.  On the benefits side, the fields are never
> referenced and the names are effectively arbitrary, i.e. there's no real value in
> keeping a sequence.
>
> A simple "fix" would be to add a comment that the names are arbitrary and have
> no meaning.  If really want to avoid ordering/skipping issues, then the we could
> assign truly arbitrary names, e.g. something silly like this:
>
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 0361626841bc..e55299a733b3 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -332,7 +332,10 @@ struct vmcb_save_area {
>          u32 spec_ctrl;          /* Guest version of SPEC_CTRL at 0x2E0 */
>   } __packed;
>   
> -/* Save area definition for SEV-ES and SEV-SNP guests */
> +/*
> + * Save area definition for SEV-ES and SEV-SNP guests.  Note the names of the
> + * reserved fields are arbitrary and have no meaning.
> + */

I'm thinking, if we add this note then there's really no need to change any
field names.

>   struct sev_es_save_area {
>          struct vmcb_seg es;
>          struct vmcb_seg cs;
> @@ -349,12 +352,12 @@ struct sev_es_save_area {
>          u64 vmpl2_ssp;
>          u64 vmpl3_ssp;
>          u64 u_cet;
> -       u8 reserved_1[2];
> +       u8 reserved_beef[2];
>          u8 vmpl;
>          u8 cpl;
> -       u8 reserved_2[4];
> +       u8 reserved_cafe[4];
>          u64 efer;
> -       u8 reserved_3[104];
> +       u8 reserved_feed[104];
>          u64 xss;
>          u64 cr4;
>          u64 cr3;
> @@ -371,7 +374,7 @@ struct sev_es_save_area {
>          u64 dr1_addr_mask;
>          u64 dr2_addr_mask;
>          u64 dr3_addr_mask;
> -       u8 reserved_4[24];
> +       u8 reserved_fee[24];
>          u64 rsp;
>          u64 s_cet;
>          u64 ssp;
> @@ -386,21 +389,21 @@ struct sev_es_save_area {
>          u64 sysenter_esp;
>          u64 sysenter_eip;
>          u64 cr2;
> -       u8 reserved_5[32];
> +       u8 reserved_deaf[32];
>          u64 g_pat;
>          u64 dbgctl;
>          u64 br_from;
>          u64 br_to;
>          u64 last_excp_from;
>          u64 last_excp_to;
> -       u8 reserved_7[80];
> +       u8 reserved_dead[80];
>          u32 pkru;
> -       u8 reserved_8[20];
> -       u64 reserved_9;         /* rax already available at 0x01f8 */
> +       u8 reserved_bed[20];
> +       u64 reserved_bead;              /* rax already available at 0x01f8 */
>          u64 rcx;
>          u64 rdx;
>          u64 rbx;
> -       u64 reserved_10;        /* rsp already available at 0x01d8 */
> +       u64 reserved_cab;       /* rsp already available at 0x01d8 */
>          u64 rbp;
>          u64 rsi;
>          u64 rdi;
> @@ -412,7 +415,7 @@ struct sev_es_save_area {
>          u64 r13;
>          u64 r14;
>          u64 r15;
> -       u8 reserved_11[16];
> +       u8 reserved_face[16];
>          u64 guest_exit_info_1;
>          u64 guest_exit_info_2;
>          u64 guest_exit_int_info;
> @@ -425,7 +428,7 @@ struct sev_es_save_area {
>          u64 pcpu_id;
>          u64 event_inj;
>          u64 xcr0;
> -       u8 reserved_12[16];
> +       u8 reserved_fade[16];
>   
>          /* Floating point area */
>          u64 x87_dp;
>
>
