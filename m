Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A885688753
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 20:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjBBTEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 14:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjBBTEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 14:04:37 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68E423DA9;
        Thu,  2 Feb 2023 11:04:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izSlVgddLJ+5/xVE4PvQOsmij+NW2edpJ/cS7NMSYrnc4vB8XfoIDtCMZkdgcpy0l/dOs2Gwt9XKluJOlm0Wo7CadFje0hKG9zpBrKwXqSWSF0iC0Y7vpVA4EQj+WRCyJamGr79OIB/kQR27CnZtSJfbc5xMfS6uUIeIfLYMWxXFFVF7mBw9i+3F/Zqi/dP20dvOC0/k4iJAPk1yDF9SuaUicohp3qv5xmF79UtLzDLgoSjX8+iE6Xsw4Mx3TcwTwSXMUUZ9rxnxxozs67l7bR1nO04nqKKHiShrtoZNTKNoXi+Xm0c7TN2+k29NItyEeRV5ASMEeajvp9oc9SAgOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjxsez4XnkGAKM3dnD8hONSW77gH5X3CskqTW3GrY6I=;
 b=KkDlE98+3eeVFK9txHz3pqbVattmhlYgSAPkNZKS6JiEeFcxnze1U09iTfm8M6weN1gZx9t+iAJeB5ImnvlbYgbj1PKFF4FX8ueop0+aV6C2yC5RcfD/YJ1LKDVxJHPNcDsj34QHGElyEeKJvXqX2ZbVpZbabGpz3h224Zj9XekRjXEOrnRQj7SjodTIuZxDPVeVhNgYvfCZln3StYkhj5Akct39LrjMbQlyuoT/n6Z8lZsb5hE+bMqMx2ko4F/A6LzjR84aRM161YWTfPcsqUP7AdAKcxk+i5kefJkmVWtDyhL9kf0nZjKbk+VU/K3J3iEuyK5PvxapltRjwtY4/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjxsez4XnkGAKM3dnD8hONSW77gH5X3CskqTW3GrY6I=;
 b=Y8aw10IO9qlET2bZmTbuXzRD0FA1zhrgrX7jcVzotLJ1Gcc4n54fQZ8UrbOvMhu3cW1RsqBgMUZuKbMLQeJyTy9n6pXkIR+hJf4dofwbdR9odNlm0e1ykQpg4+sSA9zsRtlt0l6X99mGdgDT98ZjxVz3SfzzCfgescXG6HO3N4Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DS0PR12MB8576.namprd12.prod.outlook.com (2603:10b6:8:165::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.23; Thu, 2 Feb
 2023 19:04:33 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 19:04:33 +0000
Message-ID: <ec8f2ca8-08ca-7bc2-bb82-23482e036dc9@amd.com>
Date:   Thu, 2 Feb 2023 13:04:28 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 16/64] x86/sev: Add helper functions for RMPUPDATE
 and PSMASH instruction
Content-Language: en-US
To:     Alexander Graf <graf@amazon.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Rapan, Sabin" <sabrapan@amazon.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-17-michael.roth@amd.com>
 <854a0caf-6940-8381-1e20-0ddb5ed94858@amazon.com>
 <59dd6291-6a99-ab7a-865f-b333a5f57bb9@amd.com>
 <7e73cb2d-5046-66cd-5a9b-8e2faa8458dc@amazon.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <7e73cb2d-5046-66cd-5a9b-8e2faa8458dc@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:610:38::46) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DS0PR12MB8576:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eed7ba5-7b51-4477-f404-08db055051f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ux2cSyDdfEAPyNDcsQ8tSr5D4PbXOF80wJ8WL32GGKfh6XTS0uWuOoHINeHsvGkLSI7SHgIZ9onY0CACbP8RQN6w/B4gOvTTc9HEqv+u/JQ2IiYJyJpJ4y3g53IW8ChrcA1s+OcTg4GnM/z0dBQj2Niw2Pm0PphK/ppaIXV2sjcTOt5SrScbLbPBBtAc7e04OD5hbipODAfpYLCn9Xtzz8MqiTyaJGnld62FmaOM2PSY81aMYDHvAch8+dAN4QRCglY1LoLLLmCqXWpiG7U+to/H2I7QBfKJqlFvvvWoN/6hTJsCxcu7lVY5DlUbIPsz02v4u2QkmlLsEAtyOpVMQvCX1tLGJ8ojV9JlKQqusp7P56cDpCrVxfYu/i5rAuzKClssz+5qpW3PSzq55qdZNo8LKp33cM1cojCFw6atroVTBfHOnRbUK7ev98seyIAyzjGmHI5uW9+RchT/2/QmTWn+ue+qQ9cl5jAcU4+w5u4OZnOtCtFKf6HvaPkca1icoUXzSysfuNX0ndB5clwPkhIbJRdPWi70lVFWSjIa1DindNCUs7F6tWcdYYnlDnl7f4RIoRQePGUwPboWvw7SHDPwDqBlCCiyrahNvKnmDMzPUXv9TCXki5hB6n2CAWF+0n6W+UdrTo6Z35Aqo02zViLYLkvBoohogXGiXWPdP82dwO90gNGDctMc8EGrAwLlEk0QRFsWqVGi7h9XakxVclqYI2U86omch3rrWMU1JQjOdqi7npTnKcTjet3iwJCRb+vRUgGyNPq2NYCCDtUx5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199018)(5660300002)(7416002)(54906003)(7406005)(36756003)(316002)(110136005)(8676002)(66556008)(66476007)(38100700002)(41300700001)(66946007)(4326008)(8936002)(478600001)(53546011)(26005)(31686004)(6506007)(6666004)(2616005)(186003)(6512007)(31696002)(86362001)(83380400001)(6486002)(2906002)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NExCb2QzZnA1MmxWbzQwMHZuZkNJakNRNjZyRTlobnc0LzZ4N2xxS0I2a0JJ?=
 =?utf-8?B?N1VDOHI2Z2pGTGdJZnpTZDlGdGNCejkwOGRpVXVsVUc4K1ZuYTBVWVVHZ25B?=
 =?utf-8?B?U3N4eVp3eXJEbWZyNzB5blVsM2wxeUFJZFZOUXlBWTVudnc4VkFyME43Mkpx?=
 =?utf-8?B?ZUgzS2RVbXdrUW41eGptYzFsMmIwbVNNWFBvSFlpbkN3ZXB4Y1Y1cTFTeHRi?=
 =?utf-8?B?Y2E1eExGUDgxV0NrS1RzcDZLY1hGSjd6ZEF2UmlzUmZqaEJJVEhVaFMvQ0Ra?=
 =?utf-8?B?WmV2WjhSQjNoM05saVhpUkxHTElKTDBEd0ZibEtxeEhYMUpTYlFFdEQwZUNi?=
 =?utf-8?B?TDlKSjRCc3AyZDNzMEJ4a0g3ei9aL3hQYTlMWU5aRUU5RkpTQ1JJTnhXRlQr?=
 =?utf-8?B?SnVFQXgxZ3Bucmdvc1h4OCtFWTBLVkhCVXZVR2dMVzIvdHVoc2NwamlLVlJh?=
 =?utf-8?B?bDBNSVZmbE84UjgralQrWmRzNzdlRldLcXBocGRPY0x3TnIyS0YxbkRvVVo5?=
 =?utf-8?B?OWVXOXorUzM3YjBxcHl5YmtrU3FEQUkyeUJDSkNmVlo0bm5KbjBrWWFScVRp?=
 =?utf-8?B?cmRZMVcrRG9YOHZ2NHlOS2NJWjdUZE9NdEpWRk5xRDduSTZiTk0xbHU4VWl3?=
 =?utf-8?B?Ym84ZEI0Nk9Vd1dvOWRaKzF6a2xRTmUvM1loTlduaisvV0JMWTFaQUF6MGZ6?=
 =?utf-8?B?MXJCNkRvc3JrUDJZMFFYZWFDNWhKbzNMUW8xOVJoemNuN2ZQbnB5cXNiVEoy?=
 =?utf-8?B?MkFnQ0V5MFVDc0QzdE1OdEY5ZHArRFI1TnE4SGxXZE1JeStWWHhxZmdmcE4w?=
 =?utf-8?B?emJ0UVp0MUFBenp1SmFMZzFZZ3Y3QmxRZXIvaDVmeUY5SmVHcHZMKzJGaDZr?=
 =?utf-8?B?RjVOYjNNVmxxKzY4T3hSSHcwLzdZMkRQdjJEem56dHY0QUc4TDF3WklZNlF2?=
 =?utf-8?B?M3hpTU5aR1pWRjlHMFppZ3NFSUhOcWwvOWNhUllNeCt2RGdMTXZJbExTMUdT?=
 =?utf-8?B?V0Rwb1JpS3krQ09CMXFJZHR0U1d1c3Znc0haQ2tKQWZoNzBrdFRFMnozKzIv?=
 =?utf-8?B?TzlMVFNwVktnOXVWVmppbWFhOE9VUzk0ZVcrWTFDZTQ3dnpBVVlTT2FOcmYv?=
 =?utf-8?B?bTR0Ymt0bUxKcmo5NlhjUDVXcWVLUUc0OFRJemJnTGFWMStpNEVTSWptK2tB?=
 =?utf-8?B?VktsZVNwNXBOVjJuMm9yWDVhZEtPUnVNV2tFbmdnVFBVZUFReGI5YnVNemN1?=
 =?utf-8?B?MDVreWxIK2k2RHpObGMrT0ZpS3dGbW8xdGtVOWpJeTdEaHIweGEwVWkzMlhH?=
 =?utf-8?B?cWZHTnBreXdxSm40OUZMYnpIQmZRUGNSa0ZoQ3lURTJlZGZWelFmaE9PRDB0?=
 =?utf-8?B?cWVsL3lUR1UrZHJkMEZNRkIvclN1c0IrekJ1ZGpDNU9ZdXo2bnVQNjQ0WEtm?=
 =?utf-8?B?Z09QT0l4V3pLSm1jN3FCVnVpY1pnUHFmRHVtTjc0Zi8zT20yZ2ZFcHZPaldl?=
 =?utf-8?B?NWpuRWtmZ2xlQld2NVVEMzFPWmtJbloreC94L2ZDeTIyalpEM1pDNkZPUVBy?=
 =?utf-8?B?cnJPaXI0QTV6Yi9ITHRqekNEYXUwNnVyMGl2czhPVS9BQ3I2T0c2NjR6TVJl?=
 =?utf-8?B?d0pVSldGaFdKUGJpQy9pNi9aQnlZdnFtSVl5dXpnVVY4dlNqLzdSNmpmNkoy?=
 =?utf-8?B?b0I5WHB4WlRlVmRiSUZRUHQzWFBoZXBqUzR0OHM1Rzdha2VQZGppVU5CbW80?=
 =?utf-8?B?b3lpc1AxSEwvQnE5WEYra0hDSTIvRnB6Z2tsVnBrQUhXeGJHQ1ZONGVPdGhm?=
 =?utf-8?B?NlhjaDlFYk5SSG9sVlFFSG1JZjY3MWpVYUVJcVU1enUvYmhBdXlML0tEYy9p?=
 =?utf-8?B?SjViNlExSlVPWFk3dG1EazhPd1VBd2twTkJ4d0k5RXNvN3BZdVZ4WmxqMlJQ?=
 =?utf-8?B?UGlBc3JVSEk2Wi8wc1BBcytaQUFYTXltTE1pWUJRWFJTSi9xRVljeExTMEo4?=
 =?utf-8?B?eVZWdHU3dEU2SVA2Uk8xQXNuUFdzdEQ1bzNoZ3JtRy9HZ0xrUlRTNldjMUVo?=
 =?utf-8?B?dS9HRXVNdVVFVDhmVlNHWDIyRFN3aGtEWmZkY0x5c3o5NTAxbHlOQTh1TnBI?=
 =?utf-8?Q?/EX4fajR1FQ4SApo4fa5i4BWW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eed7ba5-7b51-4477-f404-08db055051f8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 19:04:33.6349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MYeyuyn+L+r/G0XshkmwcwBZYDVBJxMvandRV9xbcUXxBGgN1MgiWZWId3Rh/AbBOo/RDUftt9tGRec20ILfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8576
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2023 11:20 AM, Alexander Graf wrote:
> 
> On 01.02.23 18:14, Kalra, Ashish wrote:
>>
>> On 1/31/2023 3:26 PM, Alexander Graf wrote:
>>>
>>> On 14.12.22 20:40, Michael Roth wrote:
>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>
>>>> The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
>>>> hypervisor will use the instruction to add pages to the RMP table. See
>>>> APM3 for details on the instruction operations.
>>>>
>>>> The PSMASH instruction expands a 2MB RMP entry into a corresponding set
>>>> of contiguous 4KB-Page RMP entries. The hypervisor will use this
>>>> instruction to adjust the RMP entry without invalidating the previous
>>>> RMP entry.
>>>>
>>>> Add the following external interface API functions:
>>>>
>>>> int psmash(u64 pfn);
>>>> psmash is used to smash a 2MB aligned page into 4K
>>>> pages while preserving the Validated bit in the RMP.
>>>>
>>>> int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
>>>> bool immutable);
>>>> Used to assign a page to guest using the RMPUPDATE instruction.
>>>>
>>>> int rmp_make_shared(u64 pfn, enum pg_level level);
>>>> Used to transition a page to hypervisor/shared state using the
>>>> RMPUPDATE instruction.
>>>>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>> [mdr: add RMPUPDATE retry logic for transient FAIL_OVERLAP errors]
>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>> ---
>>>>   arch/x86/include/asm/sev.h | 24 ++++++++++
>>>>   arch/x86/kernel/sev.c      | 95 
>>>> ++++++++++++++++++++++++++++++++++++++
>>>>   2 files changed, 119 insertions(+)
>>>>
>>>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>>>> index 8d3ce2ad27da..4eeedcaca593 100644
>>>> --- a/arch/x86/include/asm/sev.h
>>>> +++ b/arch/x86/include/asm/sev.h
>>>> @@ -80,10 +80,15 @@ extern bool handle_vc_boot_ghcb(struct pt_regs
>>>> *regs);
>>>>
>>>>   /* Software defined (when rFlags.CF = 1) */
>>>>   #define PVALIDATE_FAIL_NOUPDATE                255
>>>> +/* RMUPDATE detected 4K page and 2MB page overlap. */
>>>> +#define RMPUPDATE_FAIL_OVERLAP         7
>>>>
>>>>   /* RMP page size */
>>>>   #define RMP_PG_SIZE_4K                 0
>>>> +#define RMP_PG_SIZE_2M                 1
>>>>   #define RMP_TO_X86_PG_LEVEL(level)     (((level) == RMP_PG_SIZE_4K)
>>>> ? PG_LEVEL_4K : PG_LEVEL_2M)
>>>> +#define X86_TO_RMP_PG_LEVEL(level)     (((level) == PG_LEVEL_4K) ?
>>>> RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
>>>> +
>>>>   #define RMPADJUST_VMSA_PAGE_BIT                BIT(16)
>>>>
>>>>   /* SNP Guest message request */
>>>> @@ -133,6 +138,15 @@ struct snp_secrets_page_layout {
>>>>          u8 rsvd3[3840];
>>>>   } __packed;
>>>>
>>>> +struct rmp_state {
>>>> +       u64 gpa;
>>>> +       u8 assigned;
>>>> +       u8 pagesize;
>>>> +       u8 immutable;
>>>> +       u8 rsvd;
>>>> +       u32 asid;
>>>> +} __packed;
>>>> +
>>>>   #ifdef CONFIG_AMD_MEM_ENCRYPT
>>>>   extern struct static_key_false sev_es_enable_key;
>>>>   extern void __sev_es_ist_enter(struct pt_regs *regs);
>>>> @@ -198,6 +212,9 @@ bool snp_init(struct boot_params *bp);
>>>>   void __init __noreturn snp_abort(void);
>>>>   int snp_issue_guest_request(u64 exit_code, struct snp_req_data
>>>> *input, unsigned long *fw_err);
>>>>   int snp_lookup_rmpentry(u64 pfn, int *level);
>>>> +int psmash(u64 pfn);
>>>> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
>>>> bool immutable);
>>>> +int rmp_make_shared(u64 pfn, enum pg_level level);
>>>>   #else
>>>>   static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>>>>   static inline void sev_es_ist_exit(void) { }
>>>> @@ -223,6 +240,13 @@ static inline int snp_issue_guest_request(u64
>>>> exit_code, struct snp_req_data *in
>>>>          return -ENOTTY;
>>>>   }
>>>>   static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return
>>>> 0; }
>>>> +static inline int psmash(u64 pfn) { return -ENXIO; }
>>>> +static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level
>>>> level, int asid,
>>>> +                                  bool immutable)
>>>> +{
>>>> +       return -ENODEV;
>>>> +}
>>>> +static inline int rmp_make_shared(u64 pfn, enum pg_level level) {
>>>> return -ENODEV; }
>>>>   #endif
>>>>
>>>>   #endif
>>>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>>>> index 706675561f49..67035d34adad 100644
>>>> --- a/arch/x86/kernel/sev.c
>>>> +++ b/arch/x86/kernel/sev.c
>>>> @@ -2523,3 +2523,98 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
>>>>          return !!rmpentry_assigned(e);
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
>>>> +
>>>> +/*
>>>> + * psmash is used to smash a 2MB aligned page into 4K
>>>> + * pages while preserving the Validated bit in the RMP.
>>>> + */
>>>> +int psmash(u64 pfn)
>>>> +{
>>>> +       unsigned long paddr = pfn << PAGE_SHIFT;
>>>> +       int ret;
>>>> +
>>>> +       if (!pfn_valid(pfn))
>>>> +               return -EINVAL;
>>>
>>>
>>> We (and many other clouds) use a neat trick to reduce the number of
>>> struct pages Linux allocates for guest memory: In its simplest form, add
>>> mem= to the kernel cmdline and mmap() /dev/mem to access the reserved
>>> memory instead.
>>>
>>> This means that the system covers more RAM than Linux contains, which
>>> means pfn_valid() is no longer a good indication whether a page is
>>> indeed valid. KVM handles this case fine, but this code does not.
>>
>> Hmm...but then is also using max_pfn reliable ?
> 
> 
> I would expect it to not be reliable as it only looks at E820_TYPE_RAM, 
> yes. Do you rely on max_pfn anywhere?
>  

We use it to check if the RMP table is covering the whole system RAM, 
to get the max. addressable PFN, which should be fine.

Thanks,
Ashish
